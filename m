Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B209E54AC21
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 10:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbiFNIle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 04:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355088AbiFNIlC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 04:41:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2EA542A0F
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 01:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655196057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7JqiAgsVYLwS4+FFvNHU6GMxusP/+pOciDPNZhIjWYw=;
        b=IrqYeh/31r0j/vr1SA0outgUNfGsEvBDLdtG/CjX6X+eRug+5LAS0geSCwER6hvFAKaaYI
        GgmU33zQn2NTBD7hWrk+yrB7BvHP3eR3mxv2m6cOlmgKrvyQAzfkQ0/0gqQzSsWXUx+e7V
        EOtXCQdXTMrDC3OWbAkIcb5Cj9QMvkA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-mA8d-KHJNYa1q9rSGXm01g-1; Tue, 14 Jun 2022 04:40:42 -0400
X-MC-Unique: mA8d-KHJNYa1q9rSGXm01g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9796A811E81;
        Tue, 14 Jun 2022 08:40:41 +0000 (UTC)
Received: from localhost (unknown [10.39.193.235])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 312E69D7F;
        Tue, 14 Jun 2022 08:40:41 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Auger <eauger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] arm/kvm: enable MTE if available
In-Reply-To: <a3d0a093-3d59-5882-c9c8-6619e5aeb3ab@redhat.com>
Organization: Red Hat GmbH
References: <20220512131146.78457-1-cohuck@redhat.com>
 <20220512131146.78457-2-cohuck@redhat.com>
 <a3d0a093-3d59-5882-c9c8-6619e5aeb3ab@redhat.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Tue, 14 Jun 2022 10:40:39 +0200
Message-ID: <877d5jskmw.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 10 2022, Eric Auger <eauger@redhat.com> wrote:

> Hi Connie,
> On 5/12/22 15:11, Cornelia Huck wrote:
>> We need to disable migration, as we do not yet have a way to migrate
>> the tags as well.
>
> This patch does much more than adding a migration blocker ;-) you may
> describe the new cpu option and how it works.

I admit this is a bit terse ;) The idea is to control mte at the cpu
level directly (and not indirectly via tag memory at the machine
level). I.e. the user gets whatever is available given the constraints
(host support etc.) if they don't specify anything, and they can
explicitly turn it off/on.

>> 
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  target/arm/cpu.c     | 18 ++++------
>>  target/arm/cpu.h     |  4 +++
>>  target/arm/cpu64.c   | 78 ++++++++++++++++++++++++++++++++++++++++++++
>>  target/arm/kvm64.c   |  5 +++
>>  target/arm/kvm_arm.h | 12 +++++++
>>  target/arm/monitor.c |  1 +
>>  6 files changed, 106 insertions(+), 12 deletions(-)
>> 
>> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
>> index 029f644768b1..f0505815b1e7 100644
>> --- a/target/arm/cpu.c
>> +++ b/target/arm/cpu.c
>> @@ -1435,6 +1435,11 @@ void arm_cpu_finalize_features(ARMCPU *cpu, Error **errp)
>>              error_propagate(errp, local_err);
>>              return;
>>          }
>> +        arm_cpu_mte_finalize(cpu, &local_err);
>> +        if (local_err != NULL) {
>> +            error_propagate(errp, local_err);
>> +            return;
>> +        }
>>      }
>>  
>>      if (kvm_enabled()) {
>> @@ -1504,7 +1509,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>>          }
>>          if (cpu->tag_memory) {
>>              error_setg(errp,
>> -                       "Cannot enable KVM when guest CPUs has MTE enabled");
>> +                       "Cannot enable KVM when guest CPUs has tag memory enabled");
> before this series, tag_memory was used to detect MTE was enabled at
> machine level. And this was not compatible with KVM.
>
> Hasn't it changed now with this series? Sorry I don't know much about
> that tag_memory along with the KVM use case? Can you describe it as well
> in the cover letter.

IIU the current code correctly, the purpose of tag_memory is twofold:
- control whether mte should be available in the first place
- provide a place where a memory region used by the tcg implemtation can
  be linked

The latter part (extra memory region) is not compatible with
kvm. "Presence of extra memory for the implementation" as the knob to
configure mte for tcg makes sense, but it didn't seem right to me to use
it for kvm while controlling something which is basically a cpu property.

>>              return;
>>          }
>>      }

(...)

>> +void aarch64_add_mte_properties(Object *obj)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +
>> +    /*
>> +     * For tcg, the machine type may provide tag memory for MTE emulation.
> s/machine type/machine?

Either, I guess, as only the virt machine type provides tag memory in
the first place.

>> +     * We do not know whether that is the case at this point in time, so
>> +     * default MTE to on and check later.
>> +     * This preserves pre-existing behaviour, but is really a bit awkward.
>> +     */
>> +    qdev_property_add_static(DEVICE(obj), &arm_cpu_mte_property);
>> +    if (kvm_enabled()) {
>> +        /*
>> +         * Default MTE to off, as long as migration support is not
>> +         * yet implemented.
>> +         * TODO: implement migration support for kvm
>> +         */
>> +        cpu->prop_mte = false;
>> +    }
>> +}
>> +
>> +void arm_cpu_mte_finalize(ARMCPU *cpu, Error **errp)
>> +{
>> +    if (!cpu->prop_mte) {
>> +        /* Disable MTE feature bits. */
>> +        cpu->isar.id_aa64pfr1 =
>> +            FIELD_DP64(cpu->isar.id_aa64pfr1, ID_AA64PFR1, MTE, 0);
>> +        return;
>> +    }
>> +#ifndef CONFIG_USER_ONLY
>> +    if (!kvm_enabled()) {
>> +        if (cpu_isar_feature(aa64_mte, cpu) && !cpu->tag_memory) {
>> +            /*
>> +             * Disable the MTE feature bits, unless we have tag-memory
>> +             * provided by the machine.
>> +             * This silent downgrade is not really nice if the user had
>> +             * explicitly requested MTE to be enabled by the cpu, but it
>> +             * preserves pre-existing behaviour. In an ideal world, we
>
>
> Can't we "simply" prevent the end-user from using the prop_mte option
> with a TCG CPU? and have something like
>
> For TCG, MTE depends on the CPU feature availability + machine tag memory
> For KVM, MTE depends on the user opt-in + CPU feature avail (if
> relevant) + host VM capability (?)

I don't like kvm and tcg cpus behaving too differently... but then, tcg
is already different as it needs tag_memory.

Thinking about it, maybe we could repurpose tag_memory in the kvm case
(e.g. for a temporary buffer for migration purposes) and require it in
all cases (making kvm fail if the user specified tag memory, but the
host doesn't support it). A cpu feature still looks more natural to me,
but I'm not yet quite used to how things are done in arm :)

The big elefant in the room is how migration will end up
working... after reading the disscussions in
https://lore.kernel.org/all/CAJc+Z1FZxSYB_zJit4+0uTR-88VqQL+-01XNMSEfua-dXDy6Wg@mail.gmail.com/
I don't think it will be as "easy" as I thought, and we probably require
some further fiddling on the kernel side.

>
> But maybe I miss the point ...
>> +             * would fail if MTE was requested, but no tag memory has
>> +             * been provided.
>> +             */
>> +            cpu->isar.id_aa64pfr1 =
>> +                FIELD_DP64(cpu->isar.id_aa64pfr1, ID_AA64PFR1, MTE, 0);
>> +        }
>> +        if (!cpu_isar_feature(aa64_mte, cpu)) {
>> +            cpu->prop_mte = false;
>> +        }
>> +        return;
>> +    }
>> +    if (kvm_arm_mte_supported()) {
>> +#ifdef CONFIG_KVM
>> +        if (kvm_vm_enable_cap(kvm_state, KVM_CAP_ARM_MTE, 0)) {
>> +            error_setg(errp, "Failed to enable KVM_CAP_ARM_MTE");
>> +        } else {
>> +            /* TODO: add proper migration support with MTE enabled */
>> +            if (!mte_migration_blocker) {
>> +                error_setg(&mte_migration_blocker,
>> +                           "Live migration disabled due to MTE enabled");
>> +                if (migrate_add_blocker(mte_migration_blocker, NULL)) {
> error_free(mte_migration_blocker);
> mte_migration_blocker = NULL;

Ah, I missed that, thanks.

>> +                    error_setg(errp, "Failed to add MTE migration blocker");
>> +                }
>> +            }
>> +        }
>> +#endif
>> +    }
>> +    /* When HVF provides support for MTE, add it here */
>> +#endif
>> +}
>> +

