Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C35D59A57D
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 20:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350448AbiHSSMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 14:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349993AbiHSSMM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 14:12:12 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AA111987D
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 11:02:43 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id p9so3880227pfq.13
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 11:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=2cmeZFM9Z96PK6iKkz3xRptXL/ZQZZMehAaXwUAeWQk=;
        b=lDgUXCE2+jFiEn1lhjtsVT9PS2XJKGRNpzzrrK6ZgsY63wSH18BIzdFb+RQZ3GRfya
         GxoFcqt5jXqYfaK0aTD/Sy2iOw3cjGT9K31mrs+oT/3dLkTTgytOtFoPek1e3EFZ411F
         jPZ41pNgWViMrX60LrXEY/L6EZhDvNReIPkB+xyj2wo/z8miDmDH9z+xSthnMjD9VQD4
         G0FPV73fcK+zELUgjaG6/QJ427BK5q5YEptgOy9z3g34Q25pDyp1nZqO/upmTrObptHB
         DHNQH2dRiD8VvCm+lCLOvIWvJ79YoUGKbPRVpROiMPgQ2etjpxPLJqFScdBai8kFhyE5
         YuDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=2cmeZFM9Z96PK6iKkz3xRptXL/ZQZZMehAaXwUAeWQk=;
        b=HfoL11NhKH9v+Y68zHiQqrgZ6cDBh1R2Nn2dXdgMIDtArGKPlfYrFm6tgJSxXtiuIO
         8Y2tbkxF3X75fJS7LlAayCTTBxaBpFb+HphYZqqH0+85Ehh+pF6NpDVpiGEDClKaAp2i
         6bm7WcK97xOBfA4GO8RKioT/aJZCtT22XsNT9tq9gU/rLcLi8qbuTSAVbJROftFb7+df
         1Qd2zswxkzeR3Hshyfo+IhXQAGTJ7hooWT1obD8z+sRMGpzIS5BNWcacaxg//7icd5/S
         ge116h3eW1l6rFXp4PvZBb2T9M2O+qDSwKUdrUH8yRDd0DctZqywORgnSETk/hU+weA0
         s2Ew==
X-Gm-Message-State: ACgBeo10D7V3T73tZMlol5bemsXYSkN5cU931rVngtmIYAPZrZPE32kY
        rQuQciT4XQErxIGVyN+mKLOesQ==
X-Google-Smtp-Source: AA6agR57Ufxqi9ITvJtI5lBP5D0IJbgyirUXVdH8AQZLkwyex2asB5d5Z98uXoBQRGz4/BKQfxRxTw==
X-Received: by 2002:a63:2dc6:0:b0:428:ab9e:bb85 with SMTP id t189-20020a632dc6000000b00428ab9ebb85mr7172413pgt.530.1660932163163;
        Fri, 19 Aug 2022 11:02:43 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y8-20020aa79428000000b0052dee21fecdsm3698065pfo.77.2022.08.19.11.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 11:02:42 -0700 (PDT)
Date:   Fri, 19 Aug 2022 18:02:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcorr@google.com,
        michael.roth@amd.com, thomas.lendacky@amd.com, joro@8bytes.org,
        mizhang@google.com, pbonzini@redhat.com, vannapurve@google.com
Subject: Re: [V3 10/11] KVM: selftests: Add ucall pool based implementation
Message-ID: <Yv/QPxeKczzmxR9H@google.com>
References: <20220810152033.946942-1-pgonda@google.com>
 <20220810152033.946942-11-pgonda@google.com>
 <20220816161350.b7x5brnyz5pyi7te@kamzik>
 <Yv5iKJbjW5VseagS@google.com>
 <20220818190514.ny77xpfwiruah6m5@kamzik>
 <Yv7LR8NMBMKVzS3Z@google.com>
 <20220819051725.6lgggz2ktbd35pqj@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819051725.6lgggz2ktbd35pqj@kamzik>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022, Andrew Jones wrote:
> On Thu, Aug 18, 2022 at 11:29:11PM +0000, Sean Christopherson wrote:
> > On Thu, Aug 18, 2022, Andrew Jones wrote:
> Dropping the only once-used uc_pool_idx() and adding the comment looks
> better, but I don't think there was a bug because uc == uc->hva.

uc == uc->hva for the host, but not for the guest.  From the guest's perspective,
"hva" is an opaque pointer that has no direct relation to "uc".

> 1) Doing ucall_init() at VM create time may be too early for Arm. Arm
> probes for an unmapped address for the MMIO address it needs, so it's
> best to do that after all mapping.

Argh.  I really hate the MMIO probing.  Is there really no arbitrary address that
selftests can carve out and simply say "thou shalt not create a memslot here"?

Or can we just say that it's always immediate after memslot0?  That would allow
us to delete the searching code in ARM's ucall_arch_init().

> 2) We'll need to change the sanity checks in Arm's get_ucall() to not
> check that the MMIO address == ucall_exit_mmio_addr since there's no
> guarantee that the exiting guest's address matches whatever is lingering
> in the host's version. We can either drop the sanity check altogether
> or try to come up with something else.

Ah, right.  This one at least is easy to handle.  If the address is per-VM, just
track the address.  If it's hardcoded (as a fix for #1) then, it's even simpler.

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 8623c1568f97..74167540815b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -94,7 +94,8 @@ struct kvm_vm {
        vm_paddr_t pgd;
        vm_vaddr_t gdt;
        vm_vaddr_t tss;
-       vm_vaddr_t idt;
+       vm_paddr_t pgd;
+       vm_vaddr_t ucall_addr;
        vm_vaddr_t handlers;
        uint32_t dirty_ring_size;
        struct vm_memcrypt memcrypt;
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index b5d904f074b6..7f1d50dab0df 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -14,6 +14,8 @@ static vm_vaddr_t *ucall_exit_mmio_addr;

 static void ucall_set_mmio_addr(struct kvm_vm *vm, vm_vaddr_t val)
 {
+       vm->ucall_addr = val;
+
        atomic_sync_global_pointer_to_guest(vm, ucall_exit_mmio_addr, val);
 }

@@ -87,7 +89,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
        struct kvm_run *run = vcpu->run;

        if (run->exit_reason == KVM_EXIT_MMIO &&
-           run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
+           run->mmio.phys_addr == vcpu->vm->ucall_addr) {
                TEST_ASSERT(run->mmio.is_write && run->mmio.len == sizeof(uint64_t),
                            "Unexpected ucall exit mmio address access");
                return (void *)(*((uint64_t *)run->mmio.data));

