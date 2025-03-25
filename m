Return-Path: <kvm+bounces-41888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F7A4A6E8D2
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:14:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A631F3B2E35
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 04:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E041ACEC8;
	Tue, 25 Mar 2025 04:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VcTdoo+3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3EC1A83EE
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742876045; cv=none; b=eltb7TgoqISxnSLUeMs3Y36EujcoJocBVuAJfa8BQzUQFntg3CO8JiczE8brDiWV3VgvCK0lC0VFJiT7R190D75yhGqC7RB6aWYY5tAVCLh3XJp1mYOeu43AMapgTJGuwp4ci3nAX+lg23srR0xczivotvX8gukIFibkS1uH3Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742876045; c=relaxed/simple;
	bh=riB11PQt/oj5dWqdraSiuEPI4yjsahy2Dqzqk1jeh0E=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Cc:Content-Type; b=fOv5ExVfeZNzqR3EeyDzJ7TWKmwjk+ehmgOM0RmjWEZrm3QI7AkjUY5XRjXQ9EVS9FxJWeI0P/c0+zJ5xve+pGql7JNTtoLVzCWq0PUr9Tb/xi503JVDTNa2dv6ro7aYlsKG0EVnE5CGNhUJ4ehinPwV7e54+oq6OIz7fvHXP8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VcTdoo+3; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e63458181eeso7340881276.0
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742876043; x=1743480843; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qhwJZ46TPhNkUMJlvUXzG3cWjK4OEWJ6noSFccFjTs4=;
        b=VcTdoo+3/V8ugIkScVLUfv6XLVKPagnWCPQW611CSu9sn3fdbWabtAmLktfW9AAn2A
         uaqlVyr9wGAALVFDEQoSa8lniJIt3QQm55MQd7DrI+8m1m3a8pB+/OnwGELOtN+122Vg
         7xB3BZ0C7IC/1Yn9blbG5h9L1x5sDERl4GpG2rnZhEWiQ9Kpqj/4Z9OMluwqWJ0h2txh
         BG5HmU7+k4dZXBGEG59uf0O4rJ5CVal3HkXDCXdELlI5QoDle5XlWClsIGGi9JQPxEem
         vQY+TXNQ2vPRTUW72XGdlNRhQA8WA8p/YhbbnYvBzBahjjK+1m4Dbexhwq2gRUvsHkKl
         nLcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742876043; x=1743480843;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qhwJZ46TPhNkUMJlvUXzG3cWjK4OEWJ6noSFccFjTs4=;
        b=GX2hu5NbBdetIQT3aELTug6nxigY6i8JeLw02sHHI7G17Oj0jOu03D14Z7wCEWdthH
         f4mmQXSJlU+2IEJyCBPucz9d/IyQX+OLJPwPZh+tA6aP+tFr/AAwbtQuwaImhUGIqBmc
         wYOucOYoSxC/0Dj+ED8J+TpMAWh+FkhTKS0BUlMzt9asgRqL7OxqCbQ5TzN9qpUYoHzx
         sFPfnwccTaq28DXVsd7wCIKK/QAU+SE34mAcGTFctXIcQV5gA2W4aPbzIOg2DgaMCqkz
         /E9ckroP44ZHp+yI+qj1naZV5S9jwmTmXV5RRjPMa2dOtyJyBMcmGQZPwWVGD7aHx7Zk
         pmFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpP7MPQI4u6Q6hoTlxfgzrZmSluLIt3eZpPQulGtelyeRaaDDl9KLcHa9suVqTdJtNkbw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxN9Tpabcp1z99NUs73+ieEka0qmEmp8rfUaDsV4LwvWXMaHsbX
	1rmW/LVEpjs7qMYPW2SFKDfAdIGtnA4/dWr0vo90Zbnhh5SyIqaCq/OVSPOnDGSdaE+wXre/40G
	EnvPCYQ1meg==
X-Google-Smtp-Source: AGHT+IFuc+VMD63meYNYB+1/Vx944ugzWidKWbHJcLv+US+BXRqKR5OcoLKW2xiF+lyrpR4PBJtpM36j/2oLTQ==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:858a:76d0:aa73:eec8])
 (user=suleiman job=sendgmr) by 2002:a25:aaed:0:b0:e5d:a3bd:890a with SMTP id
 3f1490d57ef6-e66a4d2dfd0mr11722276.1.1742876043021; Mon, 24 Mar 2025 21:14:03
 -0700 (PDT)
Date: Tue, 25 Mar 2025 13:13:49 +0900
In-Reply-To: <20250325041350.1728373-1-suleiman@google.com>
Message-Id: <20250325041350.1728373-2-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250325041350.1728373-1-suleiman@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Subject: [PATCH v5 1/2] KVM: x86: Advance guest TSC after deep suspend.
From: Suleiman Souhlal <suleiman@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org, Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

Advance guest TSC to current time after suspend when the host
TSCs went backwards.

This makes the behavior consistent between suspends where host TSC
resets and suspends where it doesn't, such as suspend-to-idle, where
in the former case if the host TSC resets, the guests' would
previously be "frozen" due to KVM's backwards TSC prevention, while
in the latter case they would advance.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 33 ++++++++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 32ae3aa50c7e38..f5ce2c2782142b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1399,6 +1399,7 @@ struct kvm_arch {
 	u64 cur_tsc_offset;
 	u64 cur_tsc_generation;
 	int nr_vcpus_matched_tsc;
+	bool host_was_suspended;
 
 	u32 default_tsc_khz;
 	bool user_set_tsc;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b64ab350bcd4d..6b4ea3be66e814 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4971,7 +4971,37 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
-		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
+		unsigned long flags;
+		struct kvm *kvm;
+		bool advance;
+		u64 kernel_ns, l1_tsc, offset, tsc_now;
+
+		kvm = vcpu->kvm;
+		advance = kvm_get_time_and_clockread(&kernel_ns,
+		    &tsc_now);
+		raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
+		/*
+		 * Advance the guest's TSC to current time instead of only
+		 * preventing it from going backwards, while making sure
+		 * all the vCPUs use the same offset.
+		 */
+		if (kvm->arch.host_was_suspended && advance) {
+			l1_tsc = nsec_to_cycles(vcpu,
+			    vcpu->kvm->arch.kvmclock_offset +
+			    kernel_ns);
+			offset = kvm_compute_l1_tsc_offset(vcpu,
+			    l1_tsc);
+			kvm->arch.cur_tsc_offset = offset;
+			kvm_vcpu_write_tsc_offset(vcpu, offset);
+		} else if (advance)
+			kvm_vcpu_write_tsc_offset(vcpu,
+			    vcpu->kvm->arch.cur_tsc_offset);
+		else
+			adjust_tsc_offset_host(vcpu,
+			    vcpu->arch.tsc_offset_adjustment);
+		kvm->arch.host_was_suspended = 0;
+		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock,
+		    flags);
 		vcpu->arch.tsc_offset_adjustment = 0;
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 	}
@@ -12640,6 +12670,7 @@ int kvm_arch_enable_virtualization_cpu(void)
 				kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
 			}
 
+			kvm->arch.host_was_suspended = 1;
 			/*
 			 * We have to disable TSC offset matching.. if you were
 			 * booting a VM while issuing an S4 host suspend....
-- 
2.49.0.395.g12beb8f557-goog


