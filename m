Return-Path: <kvm+bounces-57131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 290D2B5069D
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 21:53:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 933E03B767E
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 19:53:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF588340D9D;
	Tue,  9 Sep 2025 19:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C8e8D5D/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F82C26981E;
	Tue,  9 Sep 2025 19:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757447581; cv=none; b=cs3pm6z7zApSwtg6bEBNTFavFvLYaHU58a59uGZC5f61k4z/NFNhqe/jfPHpUDCqsdrnhp8tT1p+hxk68des1LzCL7/87LVnZN9SigW8cu8+jwsHP6PU3YjrSjMxLqgQylVIp6RtnFGMCKLvA0j6u7+cwpHHqUKR0Mp9x9huCsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757447581; c=relaxed/simple;
	bh=CsixC0K8zNhIwiOrqP/b8XCHm4MvJ8dDWMEqAK/UNtc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sPqECFpvjeDIoNTkKKCLiOZWRqnvgNIZ0XkSwi76IkicuvCdJZl4FYzoRSe67Cfhl2QSVk+Kl6M3souaUVMWONBkgcmiD5C/yxMBbj6D6LCe0590bpIIuGmszX5JsK2hMEzvYGVv6tijV5n8+y2rl2A0mAaQyKmMB+4h7rxfJP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C8e8D5D/; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45dd513f4ecso37515715e9.3;
        Tue, 09 Sep 2025 12:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757447578; x=1758052378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+r3BrdGJOKGEJrMKSCJlBVSV/J2DmL71xrAl2k6S+r4=;
        b=C8e8D5D/6tw14GrBgLNv2hG7r9nD1CcSLq4vV5NSrQc4UIBknAqc+ya6k5rRP7N0cz
         KOWGmrIEHsZEiRx7r81lwyfTF8u9NYXRyH/tNpBGxpV74LnUlji+67D4W31nhv3RmKON
         bR2S9GXApws8mB3OI5Tf9lNnoBkDgTwE3kjKRAGYdRjWb24PhFkNBKKixJgCwAszroDH
         8IdQ0uXBCZ9Z1elvIpwS6hM26oLqUNIgM9SFlyW5mazep0J4fpzwEFDl+6ezQlwSYqzi
         ZYHb+suARZayBRVSwUtUbJAMNaSoLZnx0Y2yko+T5d5/6Z3BG3Jdv6xPqSf7Ub2KucHn
         LAmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757447578; x=1758052378;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+r3BrdGJOKGEJrMKSCJlBVSV/J2DmL71xrAl2k6S+r4=;
        b=mkGV3z3pWv3fTuihqSP7HSQVACl65e8939vNdrUNcApBWFzR6PEUeaBu8tvodOYsGn
         3/duDpDAP/u4dHXDBCv5A26mTjwNZhYycWQJLYUyuNRYr044KAbflLcx/dLpu80fNAw0
         ESjnzQlzi08Jj3/oKgQGjNXg75N8wuZkHFg1vdW+Y9A8g24x0Ee4olesveP3Mu+ZZ5DG
         /QcimTiTflP0M/BvYuisb6b6AkizzTa+vv/JjI9U+KD6hmsyexg/VV2+N5E/K9wQ9I9a
         mJB8BBI0khmJnZgVfvT2rTsfj900mTAVXMO/KepN/2YZr2XcbUEfTEpEW9O7j2MU5sr5
         jaYA==
X-Forwarded-Encrypted: i=1; AJvYcCVjXYVVWGgU1yKWb6PDjv1UwvKBf+PiFskx76+Xl1w5T5l5+zpXlDBnc/H3LBgJYeEPPZIVDQRntzhwZ34=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjaB7bTQHbrh3jOuWIDt8A1CXBCUvbOwJDw/DDK1j1mNhrG9Jg
	/i5BGFaAAqxi7iUfLutQekdEtlB/BNYBHS7dM8fX2r8g3fY6+t6dZy3ZwPvmdr5wJHSFrw==
X-Gm-Gg: ASbGncvcXY96B+L1q+jBy+oO8cgI3J2vc8f/ttibtUQTZacTVB3ACbZ+jeJqjDBb9/R
	kR/XSC/oTsaPxsQysNrtDFZyGcB8THYJ+BruzhL+vRE7QN7dhlN76tHMS1PBGd2IzrNi41biXih
	yJuliS8c760cjiTvj3kNjQti+05yC/XnE6ktm5WnD1I80DQpdJ3wr/HfxelNbuJZE40LVRlk5VY
	wWTKUC+XW5MD+4sKUtSjjW5SzlLHvdKpLGq15Vk2RbLFYGjxhrhbqGj/CdkMjEAE5927CC5+oro
	jU0rottppOBlzdJCHpf00kT5DATyurlx4dWdwOsnhiyPtQepO20jtkWx19hooIKIbKvqb7flnQX
	KA2BrbiTdUfTKdJXapqZEqHaHJ0vqmlgj6MhSls+UyqseTV/1/MMTHfNjpo4Jpu88L+wc6Gr4qE
	2OBkU3gPTi0AN/VEeFCgt82XvVC3eY8RxOFPTrDJFlHwHyPmTnWWw=
X-Google-Smtp-Source: AGHT+IFGz9bTH/U6S00xqzrGEx2mluuca2mQTygiN7ZqzUbCLvb8BcMFZ6DExHs4XoKoYZ3AQfEKZg==
X-Received: by 2002:a05:600c:314b:b0:45d:e111:de7e with SMTP id 5b1f17b1804b1-45de111df85mr101124655e9.19.1757447577451;
        Tue, 09 Sep 2025 12:52:57 -0700 (PDT)
Received: from ip-10-0-150-200.eu-west-1.compute.internal (ec2-52-49-196-232.eu-west-1.compute.amazonaws.com. [52.49.196.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e75223885csm3776757f8f.36.2025.09.09.12.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 12:52:57 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: kvm@vger.kernel.org
Cc: Fred Griffoul <fgriffo@amazon.co.uk>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nVMX: Mark APIC access page dirty when syncing vmcs12 pages
Date: Tue,  9 Sep 2025 19:52:28 +0000
Message-ID: <20250909195228.1412595-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

For consistency with commit 7afe79f5734 ("KVM: nVMX: Mark vmcs12's APIC
access page dirty when unmapping"), which marks the page dirty during
unmap operations, also mark it dirty during vmcs12 page synchronization.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b8ea1969113d..02aee6dd1698 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3916,10 +3916,10 @@ void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	gfn_t gfn;
 
-	/*
-	 * Don't need to mark the APIC access page dirty; it is never
-	 * written to by the CPU during APIC virtualization.
-	 */
+	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
+		gfn = vmcs12->apic_access_addr >> PAGE_SHIFT;
+		kvm_vcpu_mark_page_dirty(vcpu, gfn);
+	}
 
 	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW)) {
 		gfn = vmcs12->virtual_apic_page_addr >> PAGE_SHIFT;
-- 
2.43.0


