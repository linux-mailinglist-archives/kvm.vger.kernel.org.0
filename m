Return-Path: <kvm+bounces-34623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37A07A03003
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 19:58:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A59993A3FD4
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 18:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C6831DF724;
	Mon,  6 Jan 2025 18:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QR4TK6y0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED771DE3CA
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 18:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736189876; cv=none; b=H0kPzv78P5SXqdL6KAfaOTQF2/Z+C1SyHG8wJDg9FYjZ3+cqpyOuJKSYd9fcEPnGku2XXKCEoL4f1n5mD8LF+VWwmPcPML9UdTQZRIdcb8h2ubM0ny+F0RqBichWz1beUY7OBHc6sFLG4Z8HK76Dy/bwKoZg8seq4M4tnC5RXeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736189876; c=relaxed/simple;
	bh=2OZKrS1dUkLlPuhPdhwGi7QnWZ+8XGoT1QDIIrdkEpI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SkQYYZcv1L+7d/n7nwCeq9bjYmQ4EDwsMBRrYqPSPc0E8HhDfnuqW5HQruhAzwgKm17FTJRFkgj4jSFBm7NX8SJsG1b2e0cKQwX6u1w+0YyfRg5XcUv0+g1nXWZN/4PqYrp1W36r3y6SQBIEIHWVggriCbJDDkXO8S/Fi3deZH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QR4TK6y0; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2161d185f04so153175875ad.3
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 10:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736189874; x=1736794674; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/aNADIekx2j0/enI87SMjtmQjX7teTUCuYI/dNHjl3o=;
        b=QR4TK6y0Qy0ZduGMCFwtPrdZwwEv46yflW88CuxZEuVghrJdVaEZsNQromlJaeW9X5
         LqFkZr/RTVLO3QiG6mw/Pxrr9OHVIw1aTlzjaWeRQgKOcU/NXzH64o9/xFN34mn1D5Mg
         rHpjVRR40CDlpxeEQ1qXa0QVQpaoSKXTKGcLwTBGASa0InbIBUCZxD49IgVMb5jeyW/C
         gvKNq/+aclsH97g5pwBoKBhIXu3jC0ralbDQb4B2k8newfJi64TAr2x3OE2079y0FWw+
         /JbVv1AubaMTmTOxdT3fhfAZZetyNf/ojiCUwT8iZelu/TaRbGymbUoYxyEvn59wm0jm
         HnMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736189874; x=1736794674;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/aNADIekx2j0/enI87SMjtmQjX7teTUCuYI/dNHjl3o=;
        b=rpPNuR48JaR4LiehEQ3pD/rjtEALJ7VIWshnemzGWLrQgeX/JMrjx3dlKF1ZY23Xh9
         jMcGr/64cBjuCfCGQV/Kv2NVpk/WAriMnN6gHuehl+Oa3NTFzvhGZiszBJeoAtvDp2GW
         4iWHnWu8QgyKvw6fXHil8xqpcX6H02WHsc3SeECZV/8dBx5n1jqy3GdCCsoQ5oQR8zzX
         V3yPwb7eguQfSEIfNhDjRLuZgbZMp56jeEM9oxnnTQYXwyviDxmqxrhWWVvCTiDh1CXV
         JkO/c11XdYcfKtOW94cwrt/k54BMBxV/4V1bX7Y15PXWGetOdYe+Cri0XIqj/TKgIYiP
         7CDQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/jIOyz1ReAD+DCr9tIfDImYlElveIG9VpEe5snEm2vG43PJOJCdfl3TZvo3FGdSrVQIs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw32Bs5DVeKyk385voBo/hc7azg8Sb8FrFq3B9W1gYXLDOV2po/
	JG5qSZRVAHKWoIpMdv/EXJ9NI9oNHlcRfjGrUGuNirXelaMMBeV0ePB+8QklHjPuUBW48n1dwbl
	yHA==
X-Google-Smtp-Source: AGHT+IFTUQyqLv9XSGGLv1fnVkWYgSUL4cT3Eg9R6oafiMKaRGpJd6axUPFHZbm1bK48Dbcs7JdFs6gpXoI=
X-Received: from pgbcv4.prod.google.com ([2002:a05:6a02:4204:b0:7fd:4d08:df94])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:8412:b0:1e1:b727:1801
 with SMTP id adf61e73a8af0-1e5e07a55e8mr87767148637.27.1736189874330; Mon, 06
 Jan 2025 10:57:54 -0800 (PST)
Date: Mon, 6 Jan 2025 10:57:53 -0800
In-Reply-To: <20250101064928.389504-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250101064928.389504-1-pbonzini@redhat.com>
Message-ID: <Z3wnsQQ67GBf1Vsb@google.com>
Subject: Re: [PATCH] KVM: allow NULL writable argument to __kvm_faultin_pfn
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Christian Zigotzky <chzigotzky@xenosoft.de>, linuxppc-dev@lists.ozlabs.org, 
	regressions@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 01, 2025, Paolo Bonzini wrote:
> kvm_follow_pfn() is able to work with NULL in the .map_writable field
> of the homonymous struct.  But __kvm_faultin_pfn() rejects the combo
> despite KVM for e500 trying to use it.  Indeed .map_writable is not
> particularly useful if the flags include FOLL_WRITE and readonly
> guest memory is not supported, so add support to __kvm_faultin_pfn()
> for this case.

I would prefer to keep the sanity check to minimize the risk of a page fault
handler not supporting opportunistic write mappings.  e500 is definitely the
odd one out here.

What about adding a dedicated wrapper for getting a writable PFN?  E.g. (untested)

---
 arch/powerpc/kvm/e500_mmu_host.c | 2 +-
 arch/x86/kvm/vmx/vmx.c           | 3 +--
 include/linux/kvm_host.h         | 8 ++++++++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index e5a145b578a4..2251bb30b8ec 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -444,7 +444,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 
 	if (likely(!pfnmap)) {
 		tsize_pages = 1UL << (tsize + 10 - PAGE_SHIFT);
-		pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, NULL, &page);
+		pfn = kvm_faultin_writable_pfn(slot, gfn, &page);
 		if (is_error_noslot_pfn(pfn)) {
 			if (printk_ratelimit())
 				pr_err("%s: real page not found for gfn %lx\n",
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 893366e53732..7012b583f2e8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6800,7 +6800,6 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 	struct page *refcounted_page;
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
-	bool writable;
 
 	/* Defer reload until vmcs01 is the current VMCS. */
 	if (is_guest_mode(vcpu)) {
@@ -6836,7 +6835,7 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 	 * controls the APIC-access page memslot, and only deletes the memslot
 	 * if APICv is permanently inhibited, i.e. the memslot won't reappear.
 	 */
-	pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, &writable, &refcounted_page);
+	pfn = kvm_faultin_writable_pfn(slot, gfn, &refcounted_page);
 	if (is_error_noslot_pfn(pfn))
 		return;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c788d0bd952a..b0af7c7f99da 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1287,6 +1287,14 @@ static inline kvm_pfn_t kvm_faultin_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 				 write ? FOLL_WRITE : 0, writable, refcounted_page);
 }
 
+static inline kvm_pfn_t kvm_faultin_writable_pfn(const struct kvm_memory_slot *slot,
+						 gfn_t gfn, struct page **refcounted_page)
+{
+	bool writable;
+
+	return __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, &writable, refcounted_page);
+}
+
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);

base-commit: 2c3412e999738bfd60859c493ff47f5c268814a3
-- 

