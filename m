Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310546A6AAF
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 11:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjCAKSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 05:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCAKSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 05:18:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514BC38E9E
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 02:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677665865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8r3Y4Afs6nDzR97mneU0Nx74HX2j2HXQLqk/fLNz+hc=;
        b=A19+H00cXKT07H8fDSQfdGrHpXHCDbwFtZWhudV7lpuNzr5TG7Km9z9M/fqaS/1dnnUrB7
        DOHo6G7wu459mgBRHMPs0UjpBo92IdLsQ3T9/cV+OJPDwgV8g+N/ww+qUQ0we8G9HijQlY
        zGkPwwObWOBiqIUnf6Bt//xY71Taoeg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-6mHCLBv4PmGmk4Ky9GErJA-1; Wed, 01 Mar 2023 05:17:42 -0500
X-MC-Unique: 6mHCLBv4PmGmk4Ky9GErJA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5C7D3C0F195;
        Wed,  1 Mar 2023 10:17:41 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 88AB42026D4B;
        Wed,  1 Mar 2023 10:17:41 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Andrea Bolognani <abologna@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 1/2] arm/kvm: add support for MTE
In-Reply-To: <CABJz62OHjrq_V1QD4g4azzLm812EJapPEja81optr8o7jpnaHQ@mail.gmail.com>
Organization: Red Hat GmbH
References: <20230228150216.77912-1-cohuck@redhat.com>
 <20230228150216.77912-2-cohuck@redhat.com>
 <CABJz62OHjrq_V1QD4g4azzLm812EJapPEja81optr8o7jpnaHQ@mail.gmail.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Wed, 01 Mar 2023 11:17:40 +0100
Message-ID: <874jr4dbcr.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28 2023, Andrea Bolognani <abologna@redhat.com> wrote:

> On Tue, Feb 28, 2023 at 04:02:15PM +0100, Cornelia Huck wrote:
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
> I've given a quick look with libvirt integration in mind, and
> everything seem fine.
>
> Specifically, MTE is advertised in the output of qom-list-properties
> both for max-arm-cpu and the latest virt-X.Y-machine, which means
> that libvirt can easily and reliably figure out whether MTE support
> is available.

Great, thanks for having a look!

>
>> +MTE CPU Property
>> +================
>> +
>> +The ``mte`` property controls the Memory Tagging Extension. For TCG, it requires
>> +presence of tag memory (which can be turned on for the ``virt`` machine via
>> +``mte=on``). For KVM, it requires the ``KVM_CAP_ARM_MTE`` capability; until
>> +proper migration support is implemented, enabling MTE will install a migration
>> +blocker.
>
> Is it okay to use -machine virt,mte=on unconditionally for both KVM
> and TCG guests when MTE support is requested, or will that not work
> for the former?

QEMU will error out if you try this with KVM (basically, same behaviour
as before.) Is that a problem for libvirt, or merely a bit inconvinient?

>
>> +If not specified explicitly via ``on`` or ``off``, MTE will be available
>> +according to the following rules:
>> +
>> +* When TCG is used, MTE will be available if and only if tag memory is available;
>> +  i.e. it preserves the behaviour prior to the introduction of the feature.
>> +
>> +* When KVM is used, MTE will default to off, so that migration will not
>> +  unintentionally be blocked. This might change in a future QEMU version.
>
> If and when this changes, we should ensure that the new default
> behavior doesn't affect existing machine types, otherwise we will
> break guest ABI for existing VMs.

Nod, such a change would need proper compat handling. It's not quite
clear yet if we'll ever flip it, though.

