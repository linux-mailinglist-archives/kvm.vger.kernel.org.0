Return-Path: <kvm+bounces-28305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36C7B9974C1
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 20:18:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B4E2B29C57
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17C51E2303;
	Wed,  9 Oct 2024 18:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k6Rg2T90"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871CA1E1A3F
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 18:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728497872; cv=none; b=a7P+eRdrwAEEnYxqlTLTtJ68n99prdkEOZ8blO/UV9BG4b+21nJvNIvYxO86/71SR4fe1TA/PQfjfTl+2A7rH9pnpHPFFEfGZ9qKWi3bzv2d6uXrCY2x8amUj+qeBgZX0BuSItZou4mCgf5j3bWDwbRRyxEI/qyUzMRqyDN69sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728497872; c=relaxed/simple;
	bh=aQegb2jJTwclP7J/2+nvzeBKDFmobcteHsPnTE7cqaE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k/yTz//HotFUANFvcEUTrBcEl/esh6585VK9Yx/ttgQj2u33TocXG75a5DtZSnE8UxLusd9+k0wyAgJhUD7HtXg2gisz5+yC8I49YpDC1lBcl6RbISRMQxfpjGhCacXgo7Ex+kyFz1cfMpITwhKkH0sOrbR1s3Vsu4gydgUnfzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k6Rg2T90; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-207510f3242so606165ad.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 11:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728497870; x=1729102670; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0EI8KqLxjBp63sDvxFB6h3mtXjGqieRpikapG45fsO0=;
        b=k6Rg2T90/OWcptAxi5HK3BXksYPC5YqquC88l0hMmBKDjjiICD0cIGmtiyEkAGnQaz
         eB5j2jdyRuGZYaVg90/HrOix4oV4vHUuugp4olL5K1BtEyO0KZHmZh+kw27TR9Q0fCOs
         yICmv8VFITNCOVScVBmNAHsIZburP3FVoHM6UkdhRcF7uLugFnsh4FmQUqzC5712rm7+
         KtHXe+JMxXGrONO6EIYvJjLkyMPSli0YAA/6uTiqc20aizsiodo4iyVXePo/jpV12nZH
         kl5fK7leY9NPmQ/soO58I1/PSuLQxIGDXHSjgwQ4rZI3H9vDGg67J0AB74akS72w8GVG
         s37w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728497870; x=1729102670;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0EI8KqLxjBp63sDvxFB6h3mtXjGqieRpikapG45fsO0=;
        b=uX0FG4G2ORYOwLx7mYnSwdvox+Z5JnbkJt37yhrSOByIT3/mjSr1J5QELSKWYUokuj
         bvzoPsnHc3skTKEEKJP780iqyza9BykVHQtgV6I/fA8o3ZX72VJBKux3CJSn0CDc/1sr
         xmScktwpCu1hFtY8eUHNmAICOkXFrZgZfbiB9okM4aLcXXKQCObSTn7ORRvnq1iCAzjP
         Cj/U1w7CV4RRuX7CtG/btmoNvpZ78Qa0HOVYem9yqsgb/60WNm6N/zE7EM+mgs9kdpXj
         6gjR6GJP2e+TZESex3GxucHwe5iQh1rfz33MwyfqKq/1P37lPa0Xwwxp7fMa9aVmw7tB
         8pWQ==
X-Gm-Message-State: AOJu0Yy6ShXV9XxDzMn+b8F/g9+zFzG32HWjKybPao5vWpGjqlA5b6/r
	JC3YOuDV2Al/DhAQNnVia/B81rjXAL29E147okOPvYhh0B3a0iUKYPYBQcovOapM5PH2VYRkK+i
	j9g==
X-Google-Smtp-Source: AGHT+IGCHE/pJCSD+8XIOOuGuBub6Cuxazc+vzvdE8v2/ieW0mgwvDRyxLPmlm5mrBxuObiPc5iUxZ7oNo4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:d502:b0:20b:7ece:3225 with SMTP id
 d9443c01a7336-20c6358fdd3mr824545ad.0.1728497869626; Wed, 09 Oct 2024
 11:17:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 11:17:37 -0700
In-Reply-To: <20241009181742.1128779-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009181742.1128779-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241009181742.1128779-4-seanjc@google.com>
Subject: [PATCH 3/7] KVM: x86: Get vcpu->arch.apic_base directly and drop kvm_get_apic_base()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Access KVM's emulated APIC base MSR value directly instead of bouncing
through a helper, as there is no reason to add a layer of indirection, and
there are other MSRs with a "set" but no "get", e.g. EFER.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.h |  1 -
 arch/x86/kvm/x86.c   | 13 ++++---------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 1b8ef9856422..441abc4f4afd 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -117,7 +117,6 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
 void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 
-u64 kvm_get_apic_base(struct kvm_vcpu *vcpu);
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83fe0a78146f..046cb7513436 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -667,14 +667,9 @@ static void drop_user_return_notifiers(void)
 		kvm_on_user_return(&msrs->urn);
 }
 
-u64 kvm_get_apic_base(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.apic_base;
-}
-
 enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu)
 {
-	return kvm_apic_mode(kvm_get_apic_base(vcpu));
+	return kvm_apic_mode(vcpu->arch.apic_base);
 }
 EXPORT_SYMBOL_GPL(kvm_get_apic_mode);
 
@@ -4314,7 +4309,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = 1 << 24;
 		break;
 	case MSR_IA32_APICBASE:
-		msr_info->data = kvm_get_apic_base(vcpu);
+		msr_info->data = vcpu->arch.apic_base;
 		break;
 	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
 		return kvm_x2apic_msr_read(vcpu, msr_info->index, &msr_info->data);
@@ -10159,7 +10154,7 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 
 	kvm_run->if_flag = kvm_x86_call(get_if_flag)(vcpu);
 	kvm_run->cr8 = kvm_get_cr8(vcpu);
-	kvm_run->apic_base = kvm_get_apic_base(vcpu);
+	kvm_run->apic_base = vcpu->arch.apic_base;
 
 	kvm_run->ready_for_interrupt_injection =
 		pic_in_kernel(vcpu->kvm) ||
@@ -11711,7 +11706,7 @@ static void __get_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	sregs->cr4 = kvm_read_cr4(vcpu);
 	sregs->cr8 = kvm_get_cr8(vcpu);
 	sregs->efer = vcpu->arch.efer;
-	sregs->apic_base = kvm_get_apic_base(vcpu);
+	sregs->apic_base = vcpu->arch.apic_base;
 }
 
 static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
-- 
2.47.0.rc1.288.g06298d1525-goog


