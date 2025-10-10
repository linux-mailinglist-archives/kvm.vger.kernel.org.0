Return-Path: <kvm+bounces-59794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C46D3BCEAA3
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 00:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DA34545EF2
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 22:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344DA2773ED;
	Fri, 10 Oct 2025 22:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N7m6sw0K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C676C27604B
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 22:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760133862; cv=none; b=pldCKSJFd6e5cl7VrAego2LvKL6tNWjcU3WtQONHTuSp10r91hMcSXRGpHN6mFCIns35c8Gvqhej6timhdbOZi4hf73OoFj096kWH3MZAQg4FQC10TUJhmMOTxAkE5Vlq+UvMlCEIf5MfjCvjIV59Yu5p/C8VGAVhIJ5czeARlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760133862; c=relaxed/simple;
	bh=fiWFhBmnXVNpJMyu1KdW1wPURNpipX/se+mCAmgbMfM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GuBNRdiy7pbv3NzhYiofYSbgNXRItF/X4/9gpmOFtzRFX+qIVTJ6aAGERY25mK55jHGfWnSKWEztBNSdHHMXXoDI3UhZ09Fr2HRNoktKU04UfBEI6BZMvBFVVFG0G+CcCq1JTFk+eImEUSrJxI5xyEhDOW+AIMM5CZu62qWg0L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N7m6sw0K; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b60968d52a1so8820023a12.0
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 15:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760133860; x=1760738660; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/zWlSX8DyUzRe9Li2JnpKDvY+0TGXw1UHSLvOrmpoc8=;
        b=N7m6sw0KjcZUWfbwGFHIoCDDBl2w7JZZ/9C4cvcFpjbkwK09zJZMj0orpL6rh5v+hg
         aWea7+mhfJvkoyuiCdEufWU1NbYdcn1o+87IQMK6ay32PZCx/fC+Oe4Xt9lRJCRLOcwc
         nZnikXzPlN/vhNwef5tFu0sFoqyk6McZk+kfNkY3ONknF50bncq0KiK/bwVRQbAKo3/b
         +crLc4tqbdnSYYHYJlhjHIKHclYtjPTR/U/L0v1ZXQk2rjkyeXNttWbEF0opHyNAhOa5
         LBHL7E7sg3liEWzOVKnvl32cDGC3jfp8CxoRysQT9VDnyhdqSe59bPoO99FTvexk776+
         /Big==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760133860; x=1760738660;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/zWlSX8DyUzRe9Li2JnpKDvY+0TGXw1UHSLvOrmpoc8=;
        b=QDX/eXQbyMx+xfNzLzd2OrSKcnK17306yXnUPdtb7ziwgAXg5mCk8hdwd10/CZksI+
         OscsDIgPQDesQnPWjEHA/TLqtuEKnx2+5kz+ezFn0Wbgng8MESJAbMCRJypwh8pEYvJQ
         rbCEY8W6fJuF+8d7JfCJ5ymUZ22OrPbrJLRzeqdqqKzwb+qo7jqyS4u7NRReBWRqbcjq
         FKHtW/CZ9gTjnGmcxPyRLv6hv617u0rw4KpaZ3Gje9/WNKRzVYxHyu+aIhlFhZEnghDm
         gCyubc4MeOXF1havn4/Osv745sAFVY4hyjaKqnjHFVKEE8TZoxVBLYnaWjssynnp0onF
         39JA==
X-Forwarded-Encrypted: i=1; AJvYcCU5i9KSxKSId9LfnN/kwBY4g7gZ0ETVFSTVTc/hPX/77Yl4Q/c78QQYHYbemJGpssV3GZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6kV3DmZbpKQSb9Uv0Dj/RSME50+JesxoQ+kZvu/4Vva85uGWm
	Na9/jLHt6chTz2IrPJI2WpKClqSp9ftkTqm+IkoPR3V0ee/sZSTG8eeG2zGsKUIW+ckDexRbuUV
	eHZcIeQ==
X-Google-Smtp-Source: AGHT+IEHOxGS/S94kHuqCPOuRdy7tjdj1GXwqOLUftwCbLIcV6PzVsh1I3YOlDMqz5KOmjUZSEt2hxkw5TE=
X-Received: from pjto23.prod.google.com ([2002:a17:90a:c717:b0:33b:51fe:1a8b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1806:b0:32d:db5b:7636
 with SMTP id 98e67ed59e1d1-33b513cdaf5mr18862070a91.27.1760133860154; Fri, 10
 Oct 2025 15:04:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Oct 2025 15:04:02 -0700
In-Reply-To: <20251010220403.987927-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251010220403.987927-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <20251010220403.987927-5-seanjc@google.com>
Subject: [RFC PATCH 4/4] KVM: Bury kvm_{en,dis}able_virtualization() in
 kvm_main.c once more
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, Xin Li <xin@zytor.com>, 
	Kai Huang <kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"

Now that TDX handles doing VMXON without KVM's involvement, bury the
top-level APIs to enable and disable virtualization back in kvm_main.c.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  8 --------
 virt/kvm/kvm_main.c      | 17 +++++++++++++----
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c4f18e6b1604..8eb1b0908e1e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2595,12 +2595,4 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range);
 #endif
 
-#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
-int kvm_enable_virtualization(void);
-void kvm_disable_virtualization(void);
-#else
-static inline int kvm_enable_virtualization(void) { return 0; }
-static inline void kvm_disable_virtualization(void) { }
-#endif
-
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4b61889289f0..6bec30b6b6c1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1111,6 +1111,9 @@ static inline struct kvm_io_bus *kvm_get_bus_for_destruction(struct kvm *kvm,
 					 !refcount_read(&kvm->users_count));
 }
 
+static int kvm_enable_virtualization(void);
+static void kvm_disable_virtualization(void);
+
 static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 {
 	struct kvm *kvm = kvm_arch_alloc_vm();
@@ -5678,7 +5681,7 @@ static struct syscore_ops kvm_syscore_ops = {
 	.shutdown = kvm_shutdown,
 };
 
-int kvm_enable_virtualization(void)
+static int kvm_enable_virtualization(void)
 {
 	int r;
 
@@ -5723,9 +5726,8 @@ int kvm_enable_virtualization(void)
 	--kvm_usage_count;
 	return r;
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_enable_virtualization);
 
-void kvm_disable_virtualization(void)
+static void kvm_disable_virtualization(void)
 {
 	guard(mutex)(&kvm_usage_lock);
 
@@ -5736,7 +5738,6 @@ void kvm_disable_virtualization(void)
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 	kvm_arch_disable_virtualization();
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_disable_virtualization);
 
 static int kvm_init_virtualization(void)
 {
@@ -5752,6 +5753,14 @@ static void kvm_uninit_virtualization(void)
 		kvm_disable_virtualization();
 }
 #else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
+static int kvm_enable_virtualization(void)
+{
+	return 0;
+}
+static void kvm_disable_virtualization(void)
+{
+
+}
 static int kvm_init_virtualization(void)
 {
 	return 0;
-- 
2.51.0.740.g6adb054d12-goog


