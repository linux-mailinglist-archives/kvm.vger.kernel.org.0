Return-Path: <kvm+bounces-37031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C9B1A2464E
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:41:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E0B53A7D6D
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44FF416F858;
	Sat,  1 Feb 2025 01:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iWbk1Nx7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B84154BFF
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738373928; cv=none; b=gb7mgwtU5gQOMuSaZJxFYKcaLSGISAUFcJGQp++i+JpFYG+Evz6yAnFCOR5kNv0BZir2p+NW/3RF/rggPMcwGsWrPt+QxdP8idoY33z4DrfnZOrS7GAQLUQ4evGVfl4Q3qJDGRTwpP576dJ/sqe8Wci+WCO3RKT1qsSB1XDghLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738373928; c=relaxed/simple;
	bh=S0cfkfcvuIT723YoScs3tAnJNc+E1NoNA3KNUZ4zydY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n3TaIfkXJTgIbceh+LL6IxZV2YkDQ4orn0y+jmvYF3XWHZls08ijWyYMyma8mdj/P7mJA5O+0av9fBujTcRP5fYCA9ljnfUHNJMaXtFflvwGMIV0o4G0eSNASFXpkC9th1u6wlvlJqZ+MkKZY4x5UaLo3xVQdbVWoh3VjQuTLJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iWbk1Nx7; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-218cf85639eso77797835ad.3
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738373924; x=1738978724; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SqlXkof1Dlk5EqS0bEckGBOreF1G6+rbdQPzOVsecgY=;
        b=iWbk1Nx7O508UiEO7t8Dgh9RTqpAmC8oWhiRPGVgRUp8LfzfTdNm1UgPsoFb89j2j4
         Z7moPpVM4Cmi9OmZxhm6F9soZiCeUsjG0pEYjcYKDCbF6vfRGuhuAbR/+E2Wh/3tdxEc
         8X1qVuIbh3llf7KBmktmhVJN5fsu+h1q9/LPypB4IZZgrMx0GCJq7ATvJoQ4J6dDPoX2
         U/aTgVoFnTcsRAdwbOqUKtwyP0pS+lbR6euXlebXSTRU1PTuCOJQHvQa5JjQEoCIttri
         x6TKlMQ6A8anLp5yEQqmQXNj53NS87ceFdGLniCUEZcDWUdyCmcqxZKR89urm0SDyaN2
         fcMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738373924; x=1738978724;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SqlXkof1Dlk5EqS0bEckGBOreF1G6+rbdQPzOVsecgY=;
        b=AtntJVtA9dOYhB4xx8d0uyc1sgzCiDoWxyCryyA0qD3Mw8zuVZUw37Y4noyImtg11u
         cnWbIwWdt3ZWRHjAEX6Ch9igoqVTr4FEOUom7aRAtG9948l1SzBKuIG4AectQH66UfNf
         kKtbeT5hLKlACqcYxMndC6mUPJ3VufyYjOgM1Y+tqdVJtvwygRrwO8a/bfQXmEne8ifm
         8Rhk3RxTO4QX5zrm60IVKddg7qwxf4diyWxcD4AVF8womprbs2AvJQcB/gbvkcSQccvV
         HN3qQVGZqiw3tESFJ8O2sBKK3aYnvZ4gi/LraphgPvv0L+FYjyioiOLJtjgoXdidK6UJ
         B0rg==
X-Gm-Message-State: AOJu0Ywef5K4Q4JuBcKY+krfN7FXBkMkSLUWfL/M8p99w47g0b6PYH+W
	GQPZVJtxCNyLtERMonwo2OrmEf5tnccXbx7h8k43IvHIPv4NDMGBRB5hcOOjzz4JBhXNywh4BcT
	c1Q==
X-Google-Smtp-Source: AGHT+IFNf5S0vTL27XQUYWusQWzi4oXLJZ2sw5QHFsmsRqLpME4oOPmWgN3SSRp50OLDEWb6ANqX8m4TZdQ=
X-Received: from plek12.prod.google.com ([2002:a17:903:450c:b0:21b:d402:6f93])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e751:b0:216:4d1f:5c83
 with SMTP id d9443c01a7336-21dd7de1c73mr200004905ad.47.1738373924151; Fri, 31
 Jan 2025 17:38:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:38:24 -0800
In-Reply-To: <20250201013827.680235-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201013827.680235-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201013827.680235-9-seanjc@google.com>
Subject: [PATCH v2 08/11] KVM: x86: Pass reference pvclock as a param to kvm_setup_guest_pvclock()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Pass the reference pvclock structure that's used to setup each individual
pvclock as a parameter to kvm_setup_guest_pvclock() as a preparatory step
toward removing kvm_vcpu_arch.hv_clock.

No functional change intended.

Reviewed-by: Paul Durrant <paul@xen.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5f3ad13a8ac7..06d27b3cc207 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3116,17 +3116,17 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 	return data.clock;
 }
 
-static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
+static void kvm_setup_guest_pvclock(struct pvclock_vcpu_time_info *ref_hv_clock,
+				    struct kvm_vcpu *vcpu,
 				    struct gfn_to_pfn_cache *gpc,
 				    unsigned int offset,
 				    bool force_tsc_unstable)
 {
-	struct kvm_vcpu_arch *vcpu = &v->arch;
 	struct pvclock_vcpu_time_info *guest_hv_clock;
 	struct pvclock_vcpu_time_info hv_clock;
 	unsigned long flags;
 
-	memcpy(&hv_clock, &vcpu->hv_clock, sizeof(hv_clock));
+	memcpy(&hv_clock, ref_hv_clock, sizeof(hv_clock));
 
 	read_lock_irqsave(&gpc->lock, flags);
 	while (!kvm_gpc_check(gpc, offset + sizeof(*guest_hv_clock))) {
@@ -3165,7 +3165,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	kvm_gpc_mark_dirty_in_slot(gpc);
 	read_unlock_irqrestore(&gpc->lock, flags);
 
-	trace_kvm_pvclock_update(v->vcpu_id, &hv_clock);
+	trace_kvm_pvclock_update(vcpu->vcpu_id, &hv_clock);
 }
 
 static int kvm_guest_time_update(struct kvm_vcpu *v)
@@ -3272,18 +3272,18 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 			vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
 			vcpu->pvclock_set_guest_stopped_request = false;
 		}
-		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
+		kvm_setup_guest_pvclock(&vcpu->hv_clock, v, &vcpu->pv_time, 0, false);
 
 		vcpu->hv_clock.flags &= ~PVCLOCK_GUEST_STOPPED;
 	}
 
 #ifdef CONFIG_KVM_XEN
 	if (vcpu->xen.vcpu_info_cache.active)
-		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
+		kvm_setup_guest_pvclock(&vcpu->hv_clock, v, &vcpu->xen.vcpu_info_cache,
 					offsetof(struct compat_vcpu_info, time),
 					xen_pvclock_tsc_unstable);
 	if (vcpu->xen.vcpu_time_info_cache.active)
-		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0,
+		kvm_setup_guest_pvclock(&vcpu->hv_clock, v, &vcpu->xen.vcpu_time_info_cache, 0,
 					xen_pvclock_tsc_unstable);
 #endif
 	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
-- 
2.48.1.362.g079036d154-goog


