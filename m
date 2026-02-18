Return-Path: <kvm+bounces-71289-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qCRUDOhGlmmCdQIAu9opvQ
	(envelope-from <kvm+bounces-71289-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:10:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C597D15ACF6
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A138030107BD
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4E8533ADAE;
	Wed, 18 Feb 2026 23:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vPlccHqg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6E933A9FE
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771456216; cv=none; b=DvzmxGKNSat0r6jJIACvk1voEBLniE0eB11g0W2b5bWYSDUB2o3xbD111cjIAoN28RD3WXlOMcJeat1raOMeq6lqgnDTqY8FzA26ck8I25+Po6cxeCS7pP1RkPXDUMXg/tcnN3WLuziIeqPX6uxoQGR3iIWcLuRCHfKq1LjBefk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771456216; c=relaxed/simple;
	bh=lp/uTjjtBQSfze7HySN85sutooSpbSENQzv6kea1z28=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rJcSWUHNpbDPW2cItw3pTdTmrryHTPnlV3aoKa3hVYmfjNoaUVQ9qI4oEeXbltFgDt1UjCuUFeD0EJosdauoq4b1dKeAxT2Sp7hIrGg0ijHUKZ11RVhk2abWaUxJtGkSHMS0b3FhTjVF/KXDSx/7HQY4uqtN3SYlHS9T9QGp6fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vPlccHqg; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-352de7a89e1so258451a91.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 15:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771456214; x=1772061014; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BtN/pTdYbIU/D5c0aBEqj7mrLMqBg1yrQ95ctx4mzdo=;
        b=vPlccHqgV+uAv5z+ClHvDGyIKsjKoiJ2zQdtGv6bBWNLFKDNBdECko1E6hh8xSiz/m
         Pgb+g0rNEGhy1OpRViSkd70LZ2O1s7yjhWcsFYc+aUfR98sqb5z5ryoJc9gPhsn0JzuS
         iT0BEf7ei2xoErYcCrRThmqWdCMx77Ohq2t1O8RCqobzafbz3VflRKeYQQo1drueEnuM
         LTO1pL3yegXIp8Gw5kXY+4rMqeJDTsdJhvekbr8JOws97VhNRISJzSxa/SYPiRUXVyte
         31LjjtAcdNHib4SS30mbLBmicv518uzArvs+9qri1hZnUsF3UznoN9oEf/PM04IcYhQI
         HO2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771456214; x=1772061014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BtN/pTdYbIU/D5c0aBEqj7mrLMqBg1yrQ95ctx4mzdo=;
        b=pPSm3vPH285fFUUrau7fInP3nnOh111aFbLAxQoASnJcRRkNOUdHnpy4Ig1fkBWAOB
         5u0QKfRf8LLTdQfztTJk+s8e+82hDDRh/oV64nLRAFKFLccAnYP6dbPtJJ5xr3GJLqEh
         A3weQagBxPN01Dg6E5FVSX5p1uDA08xJkVmHgGMI+BHp2ctqcqPYMJqm1wEIhcKC1pPj
         VIDqabNR2WvbOq8GADYzfGlU6HOO5Rcx5u70fHPjJwVEoN8tK/KyVYfstKRj/rG95MeD
         aj3ezOFEgScAO3NOtpkZJKUnzxmPGUTRBlZgtQ8Fz3O4LYujLto6/HVG35+yRToomAU7
         G5pw==
X-Gm-Message-State: AOJu0YyLarRa+XCW9E1NM2Q6sNr+zSB7A+mP5+cw7BGgUZ4pmy4Qfahv
	903XVkkfnFPEvfefWK+5AboWAgkJYTgNhfDmku7lHCxi7pac8rpi1qJeUO1/VOtv4BKQ+AMqAxg
	3Nm6Q2A==
X-Received: from pjyl12.prod.google.com ([2002:a17:90a:ec0c:b0:34c:2f02:7f5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b0e:b0:356:5cf2:eb77
 with SMTP id 98e67ed59e1d1-3588902c42bmr2574011a91.2.1771456214190; Wed, 18
 Feb 2026 15:10:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 18 Feb 2026 15:09:57 -0800
In-Reply-To: <20260218230958.2877682-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260218230958.2877682-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <20260218230958.2877682-8-seanjc@google.com>
Subject: [PATCH v2 7/8] KVM: nSVM: Move vmcb_ctrl_area_cached.bus_lock_rip to svm_nested_state
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71289-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: C597D15ACF6
X-Rspamd-Action: no action

Move "bus_lock_rip" from "vmcb_ctrl_area_cached" to "svm_nested_state" as
"last_bus_lock_rip" to more accurately reflect what it tracks, and because
it is NOT a cached vmcb12 control field.  The misplaced field isn't all
that apparent in the current code base, as KVM uses "svm->nested.ctl"
broadly, but the bad placement becomes glaringly obvious if
"svm->nested.ctl" is captured as a local "vmcb12_ctrl" variable.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 8 ++++----
 arch/x86/kvm/svm/svm.c    | 2 +-
 arch/x86/kvm/svm/svm.h    | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bbb8dfc9979b..bcd6304f3c0c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -806,7 +806,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	 * L1 re-enters L2, the same instruction will trigger a VM-Exit and the
 	 * entire cycle start over.
 	 */
-	if (vmcb02->save.rip && (svm->nested.ctl.bus_lock_rip == vmcb02->save.rip))
+	if (vmcb02->save.rip && (svm->nested.last_bus_lock_rip == vmcb02->save.rip))
 		vmcb02->control.bus_lock_counter = 1;
 	else
 		vmcb02->control.bus_lock_counter = 0;
@@ -1191,11 +1191,11 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	}
 
 	/*
-	 * Invalidate bus_lock_rip unless KVM is still waiting for the guest
-	 * to make forward progress before re-enabling bus lock detection.
+	 * Invalidate last_bus_lock_rip unless KVM is still waiting for the
+	 * guest to make forward progress before re-enabling bus lock detection.
 	 */
 	if (!vmcb02->control.bus_lock_counter)
-		svm->nested.ctl.bus_lock_rip = INVALID_GPA;
+		svm->nested.last_bus_lock_rip = INVALID_GPA;
 
 	nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm->vmcb01.ptr);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9e76bf1671da..7c832a0decc2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3223,7 +3223,7 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
 	vcpu->arch.complete_userspace_io = complete_userspace_buslock;
 
 	if (is_guest_mode(vcpu))
-		svm->nested.ctl.bus_lock_rip = vcpu->arch.cui_linear_rip;
+		svm->nested.last_bus_lock_rip = vcpu->arch.cui_linear_rip;
 
 	return 0;
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 92a1691dc7be..c4ed1be38ceb 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -173,7 +173,6 @@ struct vmcb_ctrl_area_cached {
 	u64 nested_cr3;
 	u64 virt_ext;
 	u32 clean;
-	u64 bus_lock_rip;
 	union {
 #if IS_ENABLED(CONFIG_HYPERV) || IS_ENABLED(CONFIG_KVM_HYPERV)
 		struct hv_vmcb_enlightenments hv_enlightenments;
@@ -188,6 +187,7 @@ struct svm_nested_state {
 	u64 vm_cr_msr;
 	u64 vmcb12_gpa;
 	u64 last_vmcb12_gpa;
+	u64 last_bus_lock_rip;
 
 	/*
 	 * The MSR permissions map used for vmcb02, which is the merge result
-- 
2.53.0.345.g96ddfc5eaa-goog


