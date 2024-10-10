Return-Path: <kvm+bounces-28513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F0989990B3
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:37:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F0001C25033
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:37:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D5451CF5D6;
	Thu, 10 Oct 2024 18:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3iE+fjr+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D447320010A
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584769; cv=none; b=qis6Zbak6h9+mWoM1DbPrWZE08Ct2cOnk1bjM+4Ku2h8IdF6UDqkXzbe4/VbL68Q+qvGZF88TZgboat4zVdKKlr7Fyp3JkRCUjOnrbTgPQA5AR3XQDpLaVwG3jDONvwrxu1THm3WokB7KXzKkv6KO3OOghroCAQjT9zC5m4R4ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584769; c=relaxed/simple;
	bh=HP41e6SfsC4ul+oSDEyzHZ0hlt7iv8seYpnKNCv0jUQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aBINEimqQXBwx/RPQFM+xOb1Zi0PeECYJgUyf42SbHBU+YVp3KSwPpz1U6bA5Fmr5Xt7XVCPmfJu80gxGI08jrCKE1fOpbbR0a29aeyCsFCpGhH0pcnqpnbwg0LJHNotEw10oG0Z/Mjy3bs0WzUTpvbXgwchSUVmHI5s4Xfnn6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3iE+fjr+; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e04c42fecso1290000b3a.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584767; x=1729189567; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=n3l8C52m2RjpLTXcY6dq+UIBo01A1fTC4GBMzDz1kHI=;
        b=3iE+fjr+J+BhPA8v3iqwSMU7gQHtmXoLc2UoAeE8K7W7XowZPMedacJz0kDLjxUDYQ
         QBHxZX1NpRwXYSGnH0HL3vJtR2VFd/IfEGEWVjktv7EDSMjvcPUq75M3pmwLSNSY+vlM
         TTGcpYpnDBEcT6Yq4ZgXXOtSRMnft79vdJT2U4MoIAfvpL1GKwjhtjsMIhwYKH1sdUdg
         mA89AXe5f0SdxOYRU+ZmAG4KCc7jke6+CVqu1SVWGJg4hyIVrQYwExBFF/T3JmjQdnSL
         ThQ6E+6hJCDsmRcl4PwyBxiNMZtTBKOsC/MsBvMbt48BIiFEhaYo/ha2z7lutfruNTUk
         snKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584767; x=1729189567;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n3l8C52m2RjpLTXcY6dq+UIBo01A1fTC4GBMzDz1kHI=;
        b=OwJ0sAqusy6t9TRNQH+4a9ha81FsmbfLXUU8iTQ2VP+1rQJtze04OeEYExujn1DU3S
         +lG6Ncmxh8I48W7Fvnr9urQ63rkJpCuCW81dTTok0AeIflC7SNwYCF33taQ3jala/lMh
         +GW72W8DJAGfj5X9ezWSqKAHX9G5WqayaONPePA1bBDslgxdWWFPYAltNmJ2SbPYyDLQ
         1t6zwY7ryWPrUd3bIlgJL3FfpUPI9Y49OeQnTRzCFC+OTM9n3MRTzmJBuSes7nDdj9sX
         XsTajuknl3lsmI95t5yanDRD7jsoNYS9ub24nOc+msQNTXO1nqWkn3Hb4nOzp8xV6SNC
         82UA==
X-Gm-Message-State: AOJu0Yxsf8k3tOU5fCRIlD+kjJtE4SubvQ5paNdtJCx68DFfcxjZ2yXR
	nutfSP3LNjBxUMKUT1I6fP859iPu+QR17FV+ghXe7NLYoWGwBvPxTzXckVDyd6PfwndFHlVSNyz
	sWQ==
X-Google-Smtp-Source: AGHT+IH5y4h19aQ8D3UFZNHEjFs0l+IkJ/F+GwDOdY5CLNZ6WKY+eP+zfpO4DiXt2PfVXCIgSRJOtCb+AeE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f44:b0:71e:268b:845e with SMTP id
 d2e1a72fcca58-71e26e53c16mr11733b3a.1.1728584766802; Thu, 10 Oct 2024
 11:26:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:38 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-37-seanjc@google.com>
Subject: [PATCH v13 36/85] KVM: x86: Don't fault-in APIC access page during
 initial allocation
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"

Drop the gfn_to_page() lookup when installing KVM's internal memslot for
the APIC access page, as KVM doesn't need to immediately fault-in the page
now that the page isn't pinned.  In the extremely unlikely event the
kernel can't allocate a 4KiB page, KVM can just as easily return -EFAULT
on the future page fault.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 20526e4d6c62..65412640cfc7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2647,7 +2647,6 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 
 int kvm_alloc_apic_access_page(struct kvm *kvm)
 {
-	struct page *page;
 	void __user *hva;
 	int ret = 0;
 
@@ -2663,17 +2662,6 @@ int kvm_alloc_apic_access_page(struct kvm *kvm)
 		goto out;
 	}
 
-	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
-	if (!page) {
-		ret = -EFAULT;
-		goto out;
-	}
-
-	/*
-	 * Do not pin the page in memory, so that memory hot-unplug
-	 * is able to migrate it.
-	 */
-	put_page(page);
 	kvm->arch.apic_access_memslot_enabled = true;
 out:
 	mutex_unlock(&kvm->slots_lock);
-- 
2.47.0.rc1.288.g06298d1525-goog


