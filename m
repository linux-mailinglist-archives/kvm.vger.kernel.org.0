Return-Path: <kvm+bounces-57181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14BD8B511CD
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 10:52:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED8D11B26DEE
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 08:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B91F3115AE;
	Wed, 10 Sep 2025 08:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YD7L3Tev"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7CD3054CC;
	Wed, 10 Sep 2025 08:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757494328; cv=none; b=guGUIe+hsz0bQ1PYGB3nMTU4AUN2h6wd5hHT5PAKh+5ebeNoSVrELwiOBGIFDYl5vEKzId+UiC+PF0CEL3FnXOmawomlxviiL27qwzoyTby+z+Sc+WFoSPXNHLZeso6nqkZe3aynhf54R+qKGiG3tw6O2I5eenJ6qo6n1RyagDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757494328; c=relaxed/simple;
	bh=I5cYx/T1SXbulk3JlVlEMBZravNv1H+LLIU9yqOdm/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NWN74Xo0poCgNNfaneNCtu+LIyYbBZRxLcCjTPMT2UxWEEThG0Ah/1mSPR6NnplELlKDLEXTIWg5TyyJ5fh4RAdT8HIJUAkaDhOX3q6olh1toLIliYu8Jt4tWt5q4IExN/AxnW13HF6ST4jcLoI42y7xZ5B9t0TeiYrnacNIvRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YD7L3Tev; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45cb6180b60so41485085e9.0;
        Wed, 10 Sep 2025 01:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757494324; x=1758099124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nL6WOeH0OK0KWvIoWuECqmad1+y9j6UCjyBUSROQsnI=;
        b=YD7L3TevLXSTtEDu6D9747Hny7fRQTxM8/Oc8HqIvzo4CbsqhWDcnpIFsgfgbYd8u3
         RFSokb/LIEpkBzfXxdqiF09JiQEqUelCcWe9FT3xK97uKEfld2J8+oMDx9UhxtPsZEVo
         vEPeN69OR94QcSQQIyNq4o+HQAUG+bwi+u4x2KVPcCguqW9V4N2OwbvVmM2eTRxMr39m
         HSMSKdo+POfRgy+zPXdvUTD+756+E+5y2j2la0jwGHwTtJQm8iCChlkNLS//Mf0OU2Mo
         LNzPQ7zJbAMBPM3JvsJa48rPkFDw2a2GVypsFWLr3evK9ERumqzFHwg9FFCDy3fG1Prv
         PGHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757494324; x=1758099124;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nL6WOeH0OK0KWvIoWuECqmad1+y9j6UCjyBUSROQsnI=;
        b=kk9pylxLtIHyfBhE9g7FkdNlFBaYouSNjxgysi/KA4mz//TlA5MZsB6yvkgfvDhMZL
         vNxrsdBB3cLH7Nrif5QE7nVCh0iegsZkwHEgHFvBLi0LOJ2MXwv9T2IlSW89WuN4+se3
         /ISOwZPX3/MDQbduLSTILrKkcv+lGT+klNEoNfvb4kg9Gc/Z/dvHyI7uDt4d6RcvwkCe
         R4q9HpYd7bAJUUMKdTvLIe7Ooxo5horB4g0EsD9k5iwSbW1VJyTIx8Ie5scSJbVn4k93
         8tzkZLftDobYl0XCWdFYwqXGo/vg5QuTDQf1YESXarthkhaFl9//obGk19o7mRZcK60A
         0YOg==
X-Forwarded-Encrypted: i=1; AJvYcCVkYiVz4WNsadnisTPrgfIzH2OorgOnZmaq00VonPWB4dXBh5HVYCgC2ttJBxwdtnSqpGt/AqI7QWXw1+w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg4YjAQNe48wDV/oAsaOSR7Dq4RYQnByoDTl6fF/gViCmN1zC3
	Fr4EPhJDGvOlaCyWrknNJIqveIIlo2n8cBca00s3I/PyREK+4HRNxjZcuGdVPHcgZuq6HQ==
X-Gm-Gg: ASbGncvpySmECjcCbpksxE222vxzQ9tfdVWeLvRKqa+RJnr/RWXhCmqRFyQ22Y0c4XX
	jAlffd+qlmT08XlXhXYcAwtLd2BaEXNWiga5YPgpq6XJiHYlZFQHYembeY6c7/eXo9g1vYAWeTg
	EgQetwemCZvG5yCt44AjDbM364Uz9EeeyAGDVNyU1LkQbnNZF4FX+3lRejZYDeJyAJ6ROEsGN/I
	Ei8BFYPdRHCyCTRAbWInt0w5kKIS4VmzfKRbt7GOvk8pL6F/nfa9LCzlrvdIhH47olW156WXDNO
	ZPOToeQvjJwkYMd2sNqwT4czTFJxWJJIwYXMrhOeiwrqLoU8Kh6Nat4FQK9yNLNFDKsTtiKV484
	g4dOIdN/0vCYwCz/P3KiB5REQrhte9p0uS0KrwtIXa1rTPceZVYgWMc4epbwjen7s/u7JuRR8KP
	Ywfv8X2Ip784TErNwmvfa5ShqEFPVXrHV6yluKcQMs
X-Google-Smtp-Source: AGHT+IHzAfJGoQSZAfeNLR/GmGqrp+i2SdaV+vyygYNlE3JTqV7cE+8Ddr7jUxV5tok8lOPWnd258A==
X-Received: by 2002:a05:600c:a47:b0:45b:6275:42cc with SMTP id 5b1f17b1804b1-45dddeefa72mr128892155e9.28.1757494323859;
        Wed, 10 Sep 2025 01:52:03 -0700 (PDT)
Received: from ip-10-0-150-200.eu-west-1.compute.internal (ec2-52-49-196-232.eu-west-1.compute.amazonaws.com. [52.49.196.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e752238832sm5812014f8f.31.2025.09.10.01.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 01:52:03 -0700 (PDT)
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
Subject: [PATCH v2] KVM: nVMX: Mark APIC access page dirty when syncing vmcs12 pages
Date: Wed, 10 Sep 2025 08:51:55 +0000
Message-ID: <20250910085156.1419090-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

For consistency with commit 7afe79f5734a ("KVM: nVMX: Mark vmcs12's APIC
access page dirty when unmapping"), which marks the page dirty during
unmap operations, also mark it dirty during vmcs12 page synchronization.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
v2: Fix commit ID to use 12 chars instead of 11 (checkpatch warning)

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


