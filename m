Return-Path: <kvm+bounces-70072-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aGJrEPJHgmnzRgMAu9opvQ
	(envelope-from <kvm+bounces-70072-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 20:09:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 94E0ADE0E9
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 20:09:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5358A3103D5F
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 19:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7612F35CB70;
	Tue,  3 Feb 2026 19:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DpaubjBa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1CD318EF0
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 19:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770145636; cv=none; b=F9f1xAEU+8atmZmuVuBpWWdVqBvdaeeyWZyOBwMTUhquii9oQonebyFBcagay0NUXmw3yiM6hS+ZxeBvAl8O4beOPVh5Ux/9CyeaLqseZBnNFz6KGwkZUgi3k41wCFdQDPMngRbjTSMEsM0CbI2SNUqU5eGjTS+xdAlCvWWsFPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770145636; c=relaxed/simple;
	bh=Q7JmePnC1RMd9P2f6hE0m7tJA+CD5Jw/bgF7SVsHH2M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ESpXfwZLLLq/ok1zlWvp6nwu4k62ucT6hw/2Gx1gB71sM8aMXKf1I9clvVOm9gYF71AB1UZms8SZ8VEoijUOrJxWPO7MrbC8ykR7l+XMzZtj/ZvH2YIZGCuNqJAlQL1hh0N0+zUbWdqcqQ33TuXs3ZdnvYxnQpY7rBE3hQnb5Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DpaubjBa; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c43f8ef9bso137506a91.1
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 11:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770145635; x=1770750435; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QvN6OCBzjHoc41VsEIsReDOZdr5oWFs/Ny4TzyHdF0Q=;
        b=DpaubjBa9kDBz83+CYiUr8Cw2hGTqm3xARJShzlsvIMLRNsgMVmKC1QNEfOIW0inYS
         mc/XQv71CX+PKVp4s+WFcmrK7ErtuJL6OlgIc2kNMBDGWpVolOVPdp1/MD3Iy104wJJ2
         f2yJSwlnX217PO4dnv3YQb2AUFE1OaPMLn+uXtSC/KPnet6ju3z6txAIMHdP6Ox5VLLq
         hBHjF7w4W7/hwUOJx5FartCMJwdrhGs8nNFc9JOF7T89V4KoDLMZrr8xL3b0Md1HWjhy
         j6SJ1xQumi5EUiQYMSf7BDAnDDQDWdsoDhQUSheXs8TlameRjZJ5C7v6rixS52rZ5S0/
         TiSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770145635; x=1770750435;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QvN6OCBzjHoc41VsEIsReDOZdr5oWFs/Ny4TzyHdF0Q=;
        b=NeUfHbqo9uJboq9YnF4DZOoOPmQvNXtaGSEv7+XObYakCN39mJERZN3m1ZqJLKIhVQ
         YUr+KfB62qwAf0BwLa7MoeveNKazqPBEPfzTtW/owrmDdLzC19B9nmRtqHt19WyVkgXh
         rg4rG6bQndwl6SyNDAlIsrkwm0nGB5wqoxj/owDPQEVBAn70tvMKk/uuBeU8LerMlUQu
         KY3nIl9neETm5L706PImHpo9sNcCJNbKHA1BOveRJ+Kt02VZhHsCRLGmnIDtuubT5tA2
         hNwRzYs+/XJ/xQTt77pJkq7LPYBAAHT2YNH9V98kAA3pY8k8BDuq7hyWzM7BvvrURKct
         KgvQ==
X-Gm-Message-State: AOJu0Yw7nf03WDJ6m1B1MXpwtt1jIrnGAf/VgZjk9pZ8uEG5WNqOpyhi
	rfy2lJxeyeYgIs3T0IxeigMN5L4HSgShqktdah9QGZBb2/mOlh0OAEDUGAAX+0hIPR8frN4ozYb
	2wu/QSQ==
X-Received: from pjrz22.prod.google.com ([2002:a17:90a:bd96:b0:34c:fbee:f264])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:35c6:b0:34f:6ddc:d9de
 with SMTP id 98e67ed59e1d1-35477869e84mr3135301a91.16.1770145634624; Tue, 03
 Feb 2026 11:07:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  3 Feb 2026 11:07:09 -0800
In-Reply-To: <20260203190711.458413-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203190711.458413-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203190711.458413-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: SVM: Initialize AVIC VMCB fields if AVIC is enabled
 with in-kernel APIC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Naveen N Rao <naveen@kernel.org>, 
	"Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70072-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 94E0ADE0E9
X-Rspamd-Action: no action

Initialize all per-vCPU AVIC control fields in the VMCB if AVIC is enabled
in KVM and the VM has an in-kernel local APIC, i.e. if it's _possible_ the
vCPU could activate AVIC at any point in its lifecycle.  Configuring the
VMCB if and only if AVIC is active "works" purely because of optimizations
in kvm_create_lapic() to speculatively set apicv_active if AVIC is enabled
*and* to defer updates until the first KVM_RUN.  In quotes because KVM
likely won't do the right thing if kvm_apicv_activated() is false, i.e. if
a vCPU is created while APICv is inhibited at the VM level for whatever
reason.  E.g. if the inhibit is *removed* before KVM_REQ_APICV_UPDATE is
handled in KVM_RUN, then __kvm_vcpu_update_apicv() will elide calls to
vendor code due to seeing "apicv_active == activate".

Cleaning up the initialization code will also allow fixing a bug where KVM
incorrectly leaves CR8 interception enabled when AVIC is activated without
creating a mess with respect to whether AVIC is activated or not.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 2 +-
 arch/x86/kvm/svm/svm.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index f92214b1a938..44e07c27b190 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -368,7 +368,7 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 	vmcb->control.avic_physical_id = __sme_set(__pa(kvm_svm->avic_physical_id_table));
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;
 
-	if (kvm_apicv_activated(svm->vcpu.kvm))
+	if (kvm_vcpu_apicv_active(&svm->vcpu))
 		avic_activate_vmcb(svm);
 	else
 		avic_deactivate_vmcb(svm);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5f0136dbdde6..e8313fdc5465 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1189,7 +1189,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_ERAPS))
 		svm->vmcb->control.erap_ctl |= ERAP_CONTROL_ALLOW_LARGER_RAP;
 
-	if (kvm_vcpu_apicv_active(vcpu))
+	if (enable_apicv && irqchip_in_kernel(vcpu->kvm))
 		avic_init_vmcb(svm, vmcb);
 
 	if (vnmi)
-- 
2.53.0.rc2.204.g2597b5adb4-goog


