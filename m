Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E11026E70C
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 23:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgIQVD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 17:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgIQVD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 17:03:27 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D826C06174A
        for <kvm@vger.kernel.org>; Thu, 17 Sep 2020 14:03:27 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id j2so3921150eds.9
        for <kvm@vger.kernel.org>; Thu, 17 Sep 2020 14:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EMb7Fr/Y54WaWzA68Yj/5jSEez+NMiA8A7BnkNxiejw=;
        b=sevkU+IoTsyaC06bppYtADxBCtSKCU89Z+LMb2UAw1lmSINZLTMXafJOM6mC2VUVwl
         b7VsFapD+2axwIV2HqwZxQjiqgBvuuH3N+GXwaPPFeF77TKG4ScxNxFMb+AmjVZI4J0J
         HfcmEN3Y1gbRCKiQFzDxNcrrjOEf6/PNiz2GmY/vbjX/MdPT+BK+75ea7W9vVhPF/V0O
         FjCcURzdRN2p28hWrbQidWPn3sJM6jRQ31LN63ylvV5sGCG7T1pk2puS1KaiX8TYRGay
         YrYt/wwRzrPNwTdUBIHsbnfq5jP9CKGWeIAmFXijVjJ38BIG8kgYAoDSfZwnb9s+a597
         PfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EMb7Fr/Y54WaWzA68Yj/5jSEez+NMiA8A7BnkNxiejw=;
        b=bCDHkQMbb3EeSSD11Tqk1xBuG/u81Od0y871kbhoLuN+7jlrY5DaX2I0QSDkudZium
         Ec0mzqMyEqZJHLUzgFLUgeebuRa1ZlfpC9E2he/kPBGNBTcbIr65KZJoQsQLj2KC7e+U
         bEjIPNCmBfFw7F8OHG+ejbmdstZdzUydDdC1CZD5mHaY1xAnq7BGNgGifORSdJD9jQRG
         yMTifeqSplT6+dxAcVeEyxMQHNlr5lOWO5pEK1ivbDsxXg/MsaqO8AsW2nfzeUNGhIVh
         D3K37plqUakRfxGG/g8u2d894nqYSssSs6o5gl4oHVk9TmqopHT1d4KoKjv+2HgXS6bq
         vkEA==
X-Gm-Message-State: AOAM533Jsnpq1DnU88KOIs3VWPuXupKDeFsK2nnh+XFqrDZNPsvT8L2y
        Ogxpz2VvNyX4y00wiLGdue9f7bHUpQqESlSxJStTVQ==
X-Google-Smtp-Source: ABdhPJwMditRNWD0I+Geq7gliNOrha1QD/NA6DyNul2IcVhvc+BDjjs4upXJQcpFm5gr21jsGta8d+8iafhxJ1I9EX8=
X-Received: by 2002:a50:9b44:: with SMTP id a4mr34151198edj.12.1600376605908;
 Thu, 17 Sep 2020 14:03:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200916202951.23760-1-graf@amazon.com> <20200916202951.23760-7-graf@amazon.com>
In-Reply-To: <20200916202951.23760-7-graf@amazon.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 17 Sep 2020 14:03:14 -0700
Message-ID: <CAAAPnDH0yCr6299TLWe86U8Z2KV0QhdtHgxFF9Ya5M5F6973uA@mail.gmail.com>
Subject: Re: [PATCH v7 6/7] KVM: x86: Introduce MSR filtering
To:     Alexander Graf <graf@amazon.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+4.126 KVM_X86_SET_MSR_FILTER
+----------------------------
+
+:Capability: KVM_X86_SET_MSR_FILTER
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_msr_filter
+:Returns: 0 on success, < 0 on error
+
+::
+
+  struct kvm_msr_filter_range {
+  #define KVM_MSR_FILTER_READ  (1 << 0)
+  #define KVM_MSR_FILTER_WRITE (1 << 1)
+       __u32 flags;
+       __u32 nmsrs; /* number of msrs in bitmap */
+       __u32 base;  /* MSR index the bitmap starts at */
+       __u8 *bitmap; /* a 1 bit allows the operations in flags, 0 denies */
+  };
+
+  struct kvm_msr_filter {
+  #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
+  #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
+       __u32 flags;
+       struct kvm_msr_filter_range ranges[16];

Can we replace 16 with something more meaningful.  Prehaps
KVM_MSR_FILTER_MAX_RANGES.

+  };
+
+flags values:
+
+KVM_MSR_FILTER_READ
+
+  Filter read accesses to MSRs using the given bitmap. A 0 in the bitmap
+  indicates that a read should immediately fail, while a 1 indicates that
+  a read should be handled like without the filter.

nit: not sure you need 'like without the filter'

+
+KVM_MSR_FILTER_WRITE
+
+  Filter write accesses to MSRs using the given bitmap. A 0 in the bitmap
+  indicates that a write should immediately fail, while a 1 indicates that
+  a write should be handled like without the filter.

nit: again, not sure you need 'like without the filter'

+
+KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE
+
+  Filter booth read and write accesses to MSRs using the given bitmap. A 0

nit: replace 'booth' for 'both'

+  in the bitmap indicates that both reads and writes should immediately fail,
+  while a 1 indicates that reads and writes should be handled like without
+  the filter.

nit: again, not sure you need 'like without the filter'

+
+KVM_MSR_FILTER_DEFAULT_ALLOW
+
+  If no filter range matches an MSR index that is getting accessed, KVM will
+  fall back to allowing access to the MSR.
+
+KVM_MSR_FILTER_DEFAULT_DENY
+
+  If no filter range matches an MSR index that is getting accessed, KVM will
+  fall back to rejecting access to the MSR. In this mode, all MSRs that should
+  be processed by KVM need to explicitly be marked as allowed in the bitmaps.
+
+This ioctl allows user space to define a up to 16 bitmaps of MSR ranges to

nit: "define up to" remove 'a'

+specify whether a certain MSR access should be explicitly rejected or not.
+
+If this ioctl has never been invoked, MSR accesses are not guarded and the
+old KVM in-kernel emulation behavior is fully preserved.
+
+As soon as the filtering is in place, every MSR access is precessed through

nit: processed

+the filtering. If a bit is within one of the defined ranges, read and write
+accesses are guarded by the bitmap's value for the MSR index. If it is not
+defined in any range, whether MSR access is rejected is determined by the flags
+field of in the kvm_msr_filter struct: KVM_MSR_FILTER_DEFAULT_ALLOW and

nit: remove 'of' or 'in'

+KVM_MSR_FILTER_DEFAULT_DENY.
+
+Calling this ioctl with an empty set of ranges (all nmsrs == 0) disables MSR
+filtering. In that mode, KVM_MSR_FILTER_DEFAULT_DENY no longer has any effect.


+struct msr_bitmap_range {
+       u32 flags;
+       u32 nmsrs;
+       u32 base;
+       unsigned long *bitmap;
+};
+
 enum kvm_irqchip_mode {
        KVM_IRQCHIP_NONE,
        KVM_IRQCHIP_KERNEL,       /* created with KVM_CREATE_IRQCHIP */
@@ -964,6 +972,12 @@ struct kvm_arch {
        /* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
        u32 user_space_msr_mask;

+       struct {
+               u8 count;
+               bool default_allow:1;
+               struct msr_bitmap_range ranges[16];

Replace 16 with macro

+       } msr_filter;
+
        struct kvm_pmu_event_filter *pmu_event_filter;
        struct task_struct *nx_lpage_recovery_thread;
 };
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 50650cfd235a..66bba91e1bb8 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -192,8 +192,25 @@ struct kvm_msr_list {
        __u32 indices[0];
 };

-#define KVM_MSR_ALLOW_READ  (1 << 0)
-#define KVM_MSR_ALLOW_WRITE (1 << 1)
+/* Maximum size of any access bitmap in bytes */
+#define KVM_MSR_FILTER_MAX_BITMAP_SIZE 0x600

Add a macro.  Prehaps, #define KVM_MSR_FILTER_MAX_RANGES 16

+
+/* for KVM_X86_SET_MSR_FILTER */
+struct kvm_msr_filter_range {
+#define KVM_MSR_FILTER_READ  (1 << 0)
+#define KVM_MSR_FILTER_WRITE (1 << 1)
+       __u32 flags;
+       __u32 nmsrs; /* number of msrs in bitmap */
+       __u32 base;  /* MSR index the bitmap starts at */
+       __u8 *bitmap; /* a 1 bit allows the operations in flags, 0 denies */
+};
+
+struct kvm_msr_filter {
+#define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
+#define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
+       __u32 flags;
+       struct kvm_msr_filter_range ranges[16];

Replace 16 with macro

+};

 struct kvm_cpuid_entry {
        __u32 function;

@@ -3603,6 +3639,7 @@ int kvm_vm_ioctl_check_extension(struct kvm
*kvm, long ext)
        case KVM_CAP_SET_GUEST_DEBUG:
        case KVM_CAP_LAST_CPU:
        case KVM_CAP_X86_USER_SPACE_MSR:
+       case KVM_CAP_X86_MSR_FILTER:
                r = 1;
                break;
        case KVM_CAP_SYNC_REGS:
@@ -5134,6 +5171,103 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
        return r;
 }

+static void kvm_clear_msr_filter(struct kvm *kvm)
+{
+       u32 i;
+       u32 count = kvm->arch.msr_filter.count;
+       struct msr_bitmap_range ranges[16];

Replace 16 with macro

+
+       mutex_lock(&kvm->lock);
+       kvm->arch.msr_filter.count = 0;
+       memcpy(ranges, kvm->arch.msr_filter.ranges, count * sizeof(ranges[0]));
+       mutex_unlock(&kvm->lock);
+       synchronize_srcu(&kvm->srcu);
+
+       for (i = 0; i < count; i++)
+               kfree(ranges[i].bitmap);
+}
