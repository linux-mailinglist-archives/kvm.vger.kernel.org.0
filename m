Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584C86A9B8B
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 17:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjCCQT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 11:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjCCQT5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 11:19:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE06B149A7
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 08:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677860343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Fwoq1E78a1auonZ+XuQFDrP0VdueZsbOuzC248blQ8=;
        b=X3kc5jbUXf2v8wuvUpBY6raIRebJ46U0ROqxiCk5I24optArtSfQY/yJHtouThI1Hz3mT5
        AfTPLt1gYOT9gY46VxnR/mpfO3MymjDcYThpoCXsLdWMATjh0T7IB1sPj4GQIq0RPltIj9
        ZV6E8gOAa7ZDJADqLH8VVDL6rY/l/BU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-w5uRvyjTMj6C-00NFqmYVQ-1; Fri, 03 Mar 2023 11:19:00 -0500
X-MC-Unique: w5uRvyjTMj6C-00NFqmYVQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C20CF101A52E;
        Fri,  3 Mar 2023 16:18:59 +0000 (UTC)
Received: from localhost (unknown [10.39.194.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 80F652166B26;
        Fri,  3 Mar 2023 16:18:59 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 1/2] arm/kvm: add support for MTE
In-Reply-To: <CAFEAcA8FD75dXcPEyZOfF7cxbgynWTdDOJV7K7fYfAbRsPDdmg@mail.gmail.com>
Organization: Red Hat GmbH
References: <20230228150216.77912-1-cohuck@redhat.com>
 <20230228150216.77912-2-cohuck@redhat.com>
 <CAFEAcA8FD75dXcPEyZOfF7cxbgynWTdDOJV7K7fYfAbRsPDdmg@mail.gmail.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Fri, 03 Mar 2023 17:18:58 +0100
Message-ID: <87356l24gd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 03 2023, Peter Maydell <peter.maydell@linaro.org> wrote:

> On Tue, 28 Feb 2023 at 15:02, Cornelia Huck <cohuck@redhat.com> wrote:
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
>>  docs/system/arm/cpu-features.rst |  21 ++++++
>>  hw/arm/virt.c                    |   2 +-
>>  target/arm/cpu.c                 |  18 ++---
>>  target/arm/cpu.h                 |   1 +
>>  target/arm/cpu64.c               | 110 +++++++++++++++++++++++++++++++
>>  target/arm/internals.h           |   1 +
>>  target/arm/kvm.c                 |  29 ++++++++
>>  target/arm/kvm64.c               |   5 ++
>>  target/arm/kvm_arm.h             |  19 ++++++
>>  target/arm/monitor.c             |   1 +
>>  10 files changed, 194 insertions(+), 13 deletions(-)
>
>
>
>> +static inline bool arm_machine_has_tag_memory(void)
>> +{
>> +#ifndef CONFIG_USER_ONLY
>> +    Object *obj = object_dynamic_cast(qdev_get_machine(), TYPE_VIRT_MACHINE);
>> +
>> +    /* so far, only the virt machine has support for tag memory */
>> +    if (obj) {
>> +        VirtMachineState *vms = VIRT_MACHINE(obj);
>> +
>> +        return vms->mte;
>> +    }
>
> Code inside target/arm shouldn't be fishing around inside
> the details of the board model like this. For TCG I think that
> at this point (i.e. at realize) you should be able to tell if
> the board has set up tag memory, because it will have set
> cpu->tag_memory to non-NULL.

I agree that we shouldn't need to poke into the machine innards here,
but I found that it was actually too early to check for cpu->tag_memory --
details have unfortunately been flushed out of my cache already, can try
to repopulate.

