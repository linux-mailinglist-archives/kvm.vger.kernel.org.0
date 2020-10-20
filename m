Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5542934BF
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 08:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403914AbgJTGTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 02:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403878AbgJTGTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 02:19:12 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F81C0613D5
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:12 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id j30so674664lfp.4
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4qhCOwzKNOI3O5QHd++Ps6ruP4fb4SeRwyQf+CUv0m0=;
        b=GSndWaHnIpcamiRyrAj/fiORS32HM6qZwJJRgw4zwfhl+YwtSi5jQEtTN8kpJEO0Fb
         0JI6szeDJonivYoGkzAE1rxYCANs9iOW+9gJP0+02XULrrfBtTTIBbiwSnDIMj36B4Xb
         +O5CFhfYyhABpZ1YJi+jeVZMpFcgDoFjW/B+KKJk4F4ZQFKBXe0Cx/FG4BWP1EEVRU2C
         HpTUlFC78LY3LUwUgbuyOoUCFe2A0vc0bFsA4gBASokNt58UOLPrZ0vg7qogFxL2se3l
         Gkxv5aV4dnb1/3ipAJyLqgx6uPlPF9cxZoFA1IChj913U7BlB9bmxXqjYbLA9+QNWwmX
         PL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4qhCOwzKNOI3O5QHd++Ps6ruP4fb4SeRwyQf+CUv0m0=;
        b=QHA+CnhA57r14khu7x+RhHvhkdhXpYWT5SRSecG5rEZ5PgC0RRA9CB/Ql6pIMb76N8
         uE4VTjgR20Osq4zItqCu5Dsk5vHmosE9M2axFFGW9PGTdHiP2yFtPCPwfiGjjLfRdmeD
         zo1V68sRVZXf15jrCICb/a7W9QGDzdyKSDEiO29IgfWc/gB6ojaGSCdLAvsarac6VNIc
         Rx8uu5EJc3euxRXm3uO+9NmioYLmI0+2WbmnOGYY3X4YZmkmuHpydMlCr/uq/KtK2mGz
         z4BZI+pldkf5gFXf3eeBnutTbQOFbp9U66+rq3M84agmEy98BPPu1YYhWO1SQilqaCwF
         UDLQ==
X-Gm-Message-State: AOAM530vY9oCQaTKeArgSxkIAwwEfSt6N4UysFppJBmCm5LAKAwzW7OH
        McvR0TlsgRazSyBDvpAuuQbZdQ==
X-Google-Smtp-Source: ABdhPJz0bYAWSZ6yvrE2dNCscOjdmtJQ3urSk2sm+men3qnSmbPZ0P47RPkjLyJGfn+xTukQu7Ie0w==
X-Received: by 2002:a19:5f52:: with SMTP id a18mr372073lfj.511.1603174750811;
        Mon, 19 Oct 2020 23:19:10 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id e28sm194113ljp.28.2020.10.19.23.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:19:09 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 1BCF0102F6B; Tue, 20 Oct 2020 09:19:02 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 12/16] KVM: x86: Enabled protected memory extension
Date:   Tue, 20 Oct 2020 09:18:55 +0300
Message-Id: <20201020061859.18385-13-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wire up hypercalls for the feature and define VM_KVM_PROTECTED.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/Kconfig     | 1 +
 arch/x86/kvm/Kconfig | 1 +
 arch/x86/kvm/cpuid.c | 3 ++-
 arch/x86/kvm/x86.c   | 9 +++++++++
 include/linux/mm.h   | 6 ++++++
 5 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b22b95517437..0bcbdadb97d6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -807,6 +807,7 @@ config KVM_GUEST
 	select X86_HV_CALLBACK_VECTOR
 	select X86_MEM_ENCRYPT_COMMON
 	select SWIOTLB
+	select ARCH_USES_HIGH_VMA_FLAGS
 	default y
 	help
 	  This option enables various optimizations for running under the KVM
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index fbd5bd7a945a..2ea77c2a8029 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -46,6 +46,7 @@ config KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
 	select SRCU
+	select HAVE_KVM_PROTECTED_MEMORY
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3fd6eec202d7..eed33db032fb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -746,7 +746,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
-			     (1 << KVM_FEATURE_ASYNC_PF_INT);
+			     (1 << KVM_FEATURE_ASYNC_PF_INT) |
+			     (1 << KVM_FEATURE_MEM_PROTECTED);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ce856e0ece84..e89ff39204f0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7752,6 +7752,15 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		kvm_sched_yield(vcpu->kvm, a0);
 		ret = 0;
 		break;
+	case KVM_HC_ENABLE_MEM_PROTECTED:
+		ret = kvm_protect_all_memory(vcpu->kvm);
+		break;
+	case KVM_HC_MEM_SHARE:
+		ret = kvm_protect_memory(vcpu->kvm, a0, a1, false);
+		break;
+	case KVM_HC_MEM_UNSHARE:
+		ret = kvm_protect_memory(vcpu->kvm, a0, a1, true);
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c8d8cdcbc425..ee274d27e764 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -304,11 +304,13 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HIGH_ARCH_BIT_2	34	/* bit only usable on 64-bit architectures */
 #define VM_HIGH_ARCH_BIT_3	35	/* bit only usable on 64-bit architectures */
 #define VM_HIGH_ARCH_BIT_4	36	/* bit only usable on 64-bit architectures */
+#define VM_HIGH_ARCH_BIT_5	37	/* bit only usable on 64-bit architectures */
 #define VM_HIGH_ARCH_0	BIT(VM_HIGH_ARCH_BIT_0)
 #define VM_HIGH_ARCH_1	BIT(VM_HIGH_ARCH_BIT_1)
 #define VM_HIGH_ARCH_2	BIT(VM_HIGH_ARCH_BIT_2)
 #define VM_HIGH_ARCH_3	BIT(VM_HIGH_ARCH_BIT_3)
 #define VM_HIGH_ARCH_4	BIT(VM_HIGH_ARCH_BIT_4)
+#define VM_HIGH_ARCH_5	BIT(VM_HIGH_ARCH_BIT_5)
 #endif /* CONFIG_ARCH_USES_HIGH_VMA_FLAGS */
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
@@ -342,7 +344,11 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_MAPPED_COPY	VM_ARCH_1	/* T if mapped copy of data (nommu mmap) */
 #endif
 
+#if defined(CONFIG_X86_64) && defined(CONFIG_KVM)
+#define VM_KVM_PROTECTED VM_HIGH_ARCH_5
+#else
 #define VM_KVM_PROTECTED 0
+#endif
 
 #ifndef VM_GROWSUP
 # define VM_GROWSUP	VM_NONE
-- 
2.26.2

