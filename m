Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF1E66E41F
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 17:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjAQQxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 11:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbjAQQxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 11:53:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C53212F2F
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 08:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673974366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FDgixqMdZgJKYF6e0PBWXRXvTbMCho7EW2mMMQM3c70=;
        b=FFQDBKYlPXvl6qo/siUeQgDSCaC2Q2Cr0FPF2FbhDrgkZW22LuBh4Daeh4JnEvTC0chzq7
        2XSLuyTrQckXMP6fFvgLfJfX4FycLYEowcORYmuIkhP0YEZoekAQb8rH5Fj0E9ej4Xoaav
        nMUTOox33kGZZJOso9+lZAlcI1JMJPo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-KRcR06ouMPCBRAQ0kDPHRw-1; Tue, 17 Jan 2023 11:52:39 -0500
X-MC-Unique: KRcR06ouMPCBRAQ0kDPHRw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E4C938173E8;
        Tue, 17 Jan 2023 16:52:09 +0000 (UTC)
Received: from localhost (unknown [10.39.192.81])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A843A492B01;
        Tue, 17 Jan 2023 16:52:08 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 1/2] arm/kvm: add support for MTE
In-Reply-To: <CAFEAcA9BKX+fSEZZbziwTNq5wsshDajuxGZ_oByVZ=gDSYOn9g@mail.gmail.com>
Organization: Red Hat GmbH
References: <20230111161317.52250-1-cohuck@redhat.com>
 <20230111161317.52250-2-cohuck@redhat.com>
 <CAFEAcA9BKX+fSEZZbziwTNq5wsshDajuxGZ_oByVZ=gDSYOn9g@mail.gmail.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Tue, 17 Jan 2023 17:52:06 +0100
Message-ID: <87a62h85op.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 17 2023, Peter Maydell <peter.maydell@linaro.org> wrote:

> On Wed, 11 Jan 2023 at 16:13, Cornelia Huck <cohuck@redhat.com> wrote:
>>
>> Introduce a new cpu feature flag to control MTE support. To preserve
>> backwards compatibility for tcg, MTE will continue to be enabled as
>> long as tag memory has been provided.
>>
>> If MTE has been enabled, we need to disable migration, as we do not
>> yet have a way to migrate the tags as well. Therefore, MTE will stay
>> off with KVM unless requested explicitly.
>>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  docs/system/arm/cpu-features.rst |  21 +++++
>>  hw/arm/virt.c                    |   2 +-
>>  target/arm/cpu.c                 |  18 ++---
>>  target/arm/cpu.h                 |   1 +
>>  target/arm/cpu64.c               | 133 +++++++++++++++++++++++++++++++
>>  target/arm/internals.h           |   1 +
>>  target/arm/kvm64.c               |   5 ++
>>  target/arm/kvm_arm.h             |  12 +++
>>  target/arm/monitor.c             |   1 +
>>  9 files changed, 181 insertions(+), 13 deletions(-)
>>
>> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
>> index 00c444042ff5..e278650c837e 100644
>> --- a/docs/system/arm/cpu-features.rst
>> +++ b/docs/system/arm/cpu-features.rst
>> @@ -443,3 +443,24 @@ As with ``sve-default-vector-length``, if the default length is larger
>>  than the maximum vector length enabled, the actual vector length will
>>  be reduced.  If this property is set to ``-1`` then the default vector
>>  length is set to the maximum possible length.
>> +
>> +MTE CPU Property
>> +================
>> +
>> +The ``mte`` property controls the Memory Tagging Extension. For TCG, it requires
>> +presence of tag memory (which can be turned on for the ``virt`` machine via
>> +``mte=on``). For KVM, it requires the ``KVM_CAP_ARM_MTE`` capability; until
>> +proper migration support is implemented, enabling MTE will install a migration
>> +blocker.
>> +
>> +If not specified explicitly via ``on`` or ``off``, MTE will be available
>> +according to the following rules:
>> +
>> +* When TCG is used, MTE will be available iff tag memory is available; i.e. it
>> +  preserves the behaviour prior to introduction of the feature.
>> +
>> +* When KVM is used, MTE will default to off, so that migration will not
>> +  unintentionally be blocked.
>> +
>> +* Other accelerators currently don't support MTE.
>
> Minor nits for the documentation:
> we should expand out "if and only if" -- not everybody recognizes
> "iff", especially if they're not native English speakers or not
> mathematicians.

Ok, will change that.

>
> Should we write specifically that in a future QEMU version KVM
> might change to defaulting to "on if available" when migration
> support is implemented?

I can certainly add "Future QEMU versions might change that behaviour."
We should be able to add compat handling for that.

