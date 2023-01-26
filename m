Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F3A67CA3D
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 12:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237355AbjAZLsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 06:48:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237074AbjAZLsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 06:48:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A123841098
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 03:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674733679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gW18Ss9Lzrp4NFwKCB2kFJc4bmfBf93FYizzDbkiEwY=;
        b=fNCsQWZw/s9A+JG8IhefkeafdiDC1pVL1QT8a/y03bs6jjtosu+oZWYaQ2UVPL+0NjgXEe
        FKs7WEgvhkgM3TveRh4oAe+ISrcoX6xPiO6j7GUnDNqJuUoQbK4N9ZFNHnnJIhhmArOolM
        t/OibdNT/nB4H1S0DCR2nBvlnho6U9s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-zsevXJBhMB2J7rGIjH5OYg-1; Thu, 26 Jan 2023 06:47:56 -0500
X-MC-Unique: zsevXJBhMB2J7rGIjH5OYg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F03DD801779;
        Thu, 26 Jan 2023 11:47:55 +0000 (UTC)
Received: from localhost (unknown [10.39.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 43C98401530E;
        Thu, 26 Jan 2023 11:47:52 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Auger <eauger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 1/2] arm/kvm: add support for MTE
In-Reply-To: <44d82d98-6a27-f4d3-9773-670231f82c63@redhat.com>
Organization: Red Hat GmbH
References: <20230111161317.52250-1-cohuck@redhat.com>
 <20230111161317.52250-2-cohuck@redhat.com>
 <44d82d98-6a27-f4d3-9773-670231f82c63@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 26 Jan 2023 12:47:49 +0100
Message-ID: <877cx9y0t6.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 23 2023, Eric Auger <eauger@redhat.com> wrote:

> Hi Connie,
> On 1/11/23 17:13, Cornelia Huck wrote:
>> Introduce a new cpu feature flag to control MTE support. To preserve
>> backwards compatibility for tcg, MTE will continue to be enabled as
>> long as tag memory has been provided.
>> 
>> If MTE has been enabled, we need to disable migration, as we do not
> this only applies to KVM acceleration

"If MTE has been enabled with KVM," ...

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
> maybe re-emphasize: when KVM is enabled

I think it's explicit enough, since it is in the "For KVM" phrase?

>> +
>> +If not specified explicitly via ``on`` or ``off``, MTE will be available
>> +according to the following rules:
>> +
>> +* When TCG is used, MTE will be available iff tag memory is available; i.e. it
> suggestion: is available at machine level

It's only configured at machine level, not sure if that clarifies
anything?

>> +  preserves the behaviour prior to introduction of the feature.
> s/prior to/prior to the ?

ok

>> +
>> +* When KVM is used, MTE will default to off, so that migration will not
>> +  unintentionally be blocked.
>> +
>> +* Other accelerators currently don't support MTE.
>> +
>> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
>> index ea2413a0bad7..42359e256ad0 100644
>> --- a/hw/arm/virt.c
>> +++ b/hw/arm/virt.c
>> @@ -2136,7 +2136,7 @@ static void machvirt_init(MachineState *machine)
>>  
>>      if (vms->mte && (kvm_enabled() || hvf_enabled())) {
>>          error_report("mach-virt: %s does not support providing "
>> -                     "MTE to the guest CPU",
>> +                     "emulated MTE to the guest CPU",
> each time I read this message I feel difficult to understand it. Why not
> replacing by
> "mach-virt does not support tag memory with %s acceleration" or
> something alike?

Hmm... well, it does not support tag memory with kvm/hvf, and the
consequence of this is that kvm/hvf cannot provide support for emulated
mte... what about

"mach-virt: tag memory not supported with %s, emulated MTE cannot be
provided to the guest CPU"

Might be a bit long, though.

>>                       kvm_enabled() ? "KVM" : "HVF");
>>          exit(1);
>>      }

(...)

>> +static void aarch64_cpu_set_mte(Object *obj, Visitor *v, const char *name,
>> +                                void *opaque, Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +
>> +    visit_type_OnOffAuto(v, name, &cpu->prop_mte, errp);
>> +
> nit: spare void line

will drop

>> +}
>> +
>> +static void aarch64_add_mte_properties(Object *obj)
>> +{
>> +    /*
>> +     * For tcg, "AUTO" means turn on mte if tag memory has been provided, and
>> +     * turn it off (without error) if not.
>> +     * For kvm, "AUTO" currently means mte off, as migration is not supported
>> +     * yet.
>> +     * For all others, "AUTO" means mte off.
>> +     */
>> +    object_property_add(obj, "mte", "OnOffAuto", aarch64_cpu_get_mte,
>> +                        aarch64_cpu_set_mte, NULL, NULL);
>> +}
>> +
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
>> +#endif
>> +    return false;
>> +}
>> +
>> +void arm_cpu_mte_finalize(ARMCPU *cpu, Error **errp)
>> +{
>> +    bool enable_mte;
>> +
>> +    switch (cpu->prop_mte) {
>> +    case ON_OFF_AUTO_OFF:
>> +        enable_mte = false;
>> +        break;
>> +    case ON_OFF_AUTO_ON:
>> +        if (!kvm_enabled()) {
>> +            if (cpu_isar_feature(aa64_mte, cpu)) {
>> +                if (!arm_machine_has_tag_memory()) {
>> +                    error_setg(errp, "mte=on requires tag memory");
>> +                    return;
>> +                }
>> +            } else {
>> +                error_setg(errp, "mte not provided");
> mte not supported by this CPU type?

yes, probably better

>> +                return;
>> +            }
>> +        }
>> +#ifdef CONFIG_KVM
>> +        if (kvm_enabled() && !kvm_arm_mte_supported()) {
> as you have stubs for both, is the #ifdef needed?

see prior discussion :) Doesn't look like it.

>> +            error_setg(errp, "mte not supported by kvm");
>> +            return;
>> +        }
>> +#endif
>> +        enable_mte = true;
>> +        break;
>> +    default: /* AUTO */
>> +        if (!kvm_enabled()) {
>> +            if (cpu_isar_feature(aa64_mte, cpu)) {
>> +                /*
>> +                 * Tie mte enablement to presence of tag memory, in order to
>> +                 * preserve pre-existing behaviour.
>> +                 */
>> +                enable_mte = arm_machine_has_tag_memory();
>> +            } else {
>> +                enable_mte = false;
>> +            }
>> +            break;
>> +        } else {
>> +            /*
>> +             * This cannot yet be
>> +             * enable_mte = kvm_arm_mte_supported();
>> +             * as we don't support migration yet.
>> +             */
>> +            enable_mte = false;
>> +        }
>> +    }
>> +
>> +    if (!enable_mte) {
>> +        /* Disable MTE feature bits. */
>> +        cpu->isar.id_aa64pfr1 =
>> +            FIELD_DP64(cpu->isar.id_aa64pfr1, ID_AA64PFR1, MTE, 0);
>> +        return;
>> +    }
>> +
>> +    /* accelerator-specific enablement */
>> +    if (kvm_enabled()) {
>> +#ifdef CONFIG_KVM
>> +        if (kvm_vm_enable_cap(kvm_state, KVM_CAP_ARM_MTE, 0)) {
>> +            error_setg(errp, "Failed to enable KVM_CAP_ARM_MTE");
> nit: return and remove the else?

I've reworked that anyway (no need to enable a vm cap for every cpu.)

>> +        } else {
>> +            /* TODO: add proper migration support with MTE enabled */
>> +            if (!mte_migration_blocker) {
>> +                error_setg(&mte_migration_blocker,
>> +                           "Live migration disabled due to MTE enabled");
>> +                if (migrate_add_blocker(mte_migration_blocker, NULL)) {
> Can't you pass the erro directly to migrate_add_blocker. Also  in
> arm_gicv3_its_kvm.c or virtio-gpu-pci, < 0 is checked. Maybe worth to
> double check the rationale.

I've rewritten that in the meanwhile as well :)

>> +                    error_setg(errp, "Failed to add MTE migration blocker");
>> +                    error_free(mte_migration_blocker);
>> +                    mte_migration_blocker = NULL;
>> +                }
>> +            }
>> +        }
>> +#endif
>> +    }
>> +}

