Return-Path: <kvm+bounces-68626-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mDNvBiq6b2kOMQAAu9opvQ
	(envelope-from <kvm+bounces-68626-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 18:23:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 76E9B487D9
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 18:23:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9962550C93C
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 14:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB26143E485;
	Tue, 20 Jan 2026 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eav/Ltcu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99604438FE0
	for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 14:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768920357; cv=none; b=AbWCwIvzx8uEKSoglKJEqFM7qkCCbNI9T9VDhzNwnBMcDBqj5yY5/whMTeFgrZ01g7JL6kNxXfvH9X46CSS+Z8SFjM/qKYm43YuNA4/p539sCLgRCXXiIRF+sgqo24iQv4KsdZsTcU90Fv0k9N7UyvJtrUX61FkY7smaKp9+oac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768920357; c=relaxed/simple;
	bh=qohqTrHOpcszpY6T71fBAof7W0BAd5JCuzPM0Kr/W+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PDNJHi0wH7yey8gyfpXry7+zR4+E3ViiCPS9TEQfwUuoY1H5K8GF7nIAi63/og8h4hYaId8mA/nTMfF8znvD4wPYwcDgnf1P56lMxr6aOHqdr3KvD+ZvMo/k59SnC08Zb1cDDcP9LivupDt9gGMcTvvrllRvsyUzdOCa6cu8TgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eav/Ltcu; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47edffe5540so47371145e9.0
        for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 06:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768920354; x=1769525154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YIqO4SrmEsn8JNS9MkoMfSMXaWLK+Ne7pozd40Hy4X8=;
        b=eav/LtcuyO8vYNeXaiu9c3JvTpfe2+HNJ1eT/+dnpiwIJ+G06eTyR7HDkOxz9H3JR3
         1B1G/uRLQxWBK8JxOgvvmsK43E43kteFJ4t48WfYuGlcHaphWzLmSCCF9hxCSDsVB6CS
         DKqgPoQe25ee2Vt/C6tSVpK9Qv65NiesIsjvzQL7yLzDh8e2R8DIEyH14Pb8mLjY5BUE
         gALAoVxEMFddhODuCduh6b/gJHrypD7wIRoL1V7LDNux5RyghAcXSsWwfpWJ8SLWy73S
         FrLEcpyXhKZ0X9GZEDfmaeRXjA8waurXn3fMnbVvD1IwelzZS55xBhX/GtBcuGuCzj3W
         t0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768920354; x=1769525154;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YIqO4SrmEsn8JNS9MkoMfSMXaWLK+Ne7pozd40Hy4X8=;
        b=L8wQEcYFjbQ4bHZQGnKXnGLnsfRhxMnFYi+fLAfY5xolx04QIte8rhMZ6I7d/bChKz
         quaedlHgfiOeRrfIuCa809C7ziTfNoZfNqNH2YwrGFVk9FmxpiuvMSaQHeuRsVSNvtFK
         MLfoFi/Wi/i9CIHvAMrtqnbgTZN0JTUNqkkWIGL/l1wl7EPugV6bUgPKBfwIrXOYrWOo
         zzhtFEibdWIeI9odmBRjItjWGBrIKbnIWcEeJAZ0R7mJjYpsDkOCi2rDPmnO8v4jw7o1
         qk1PAxqaZ3myU1QQf4mo506cvHpcCDqIDGt1L2w4fpL8LXVbydc9xzKtvWM7CMK7UKqK
         DcYg==
X-Gm-Message-State: AOJu0Yw4LH1K3lu53TD0aKsXwFOAWciQ7HlL7z4g+0SV2SdL7FwBoQuE
	e7DEjNe3a4dUmDrNRvSx7CSLcMUrqqM0azPJwRiHubyr1Jo2AugtSesZXDGrcwcB0bE=
X-Gm-Gg: AY/fxX6BGagaDcu0U23wFBMwZI/Di7DBuFQw8nRtez64aP6ycFmmCrASfdtKG/e4fWz
	fY9Bt4xgzwah8/6Qeg10aN33z+/kCLv4Ahcfr9nhDN0cEcEZY+imR8gDyhEchOotxUKQGTrXhLW
	iDZZ4e1gR2/otELL5xxKowunOHH8wxxPeRMGL0u9DNx0V0G4R5PxONysUrKRQZ4utIiSVLgabO2
	H/HcLZcL+lBIMko1Ivyrf4eMFA+4M1lq9u8Ht9LmGtT37yFM1cPRv8WOj87C6JtRfhIv2eUKyN4
	/tInTkrLZZUlyDusNxIfPVy2t4pp2DueahuE+HfQ8ohb+AjHtm5RtOs2LL4llBcBV2/Aan1U+to
	+/C1OC3unUz9jvoy9bgJSDWmyGGbnemdDiT4WziUMScICM9jdOX0IZ1bVeJJVBgok3QPQBL3NFp
	e9lTaYWPVY6i0N47LeoJTwK2TciWKAG0LOyNZ6NwsbHliS9tmuj5MmNx3lhsfk3ubB1tpVjO+wx
	Ge76puRieCwcybpB8OGLu6Tx57RSsY1lr7ntl6q/pyJNiXkPJQq7dcuZVEhfjSD
X-Received: by 2002:a05:600c:8b75:b0:477:9574:d641 with SMTP id 5b1f17b1804b1-4803e7e8531mr31387285e9.22.1768920353193;
        Tue, 20 Jan 2026 06:45:53 -0800 (PST)
Received: from ip-10-0-150-200.eu-west-1.compute.internal (ec2-52-49-196-232.eu-west-1.compute.amazonaws.com. [52.49.196.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801e879537sm252972145e9.5.2026.01.20.06.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 06:45:52 -0800 (PST)
From: Fred Griffoul <griffoul@gmail.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org,
	Fred Griffoul <fgriffo@amazon.co.uk>
Subject: [PATCH] KVM: nVMX: Track vmx emulation errors
Date: Tue, 20 Jan 2026 14:45:50 +0000
Message-ID: <20260120144550.1083396-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_FROM(0.00)[bounces-68626-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	FROM_NEQ_ENVFROM(0.00)[griffoul@gmail.com,kvm@vger.kernel.org];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 76E9B487D9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Fred Griffoul <fgriffo@amazon.co.uk>

Add a new kvm_stat vcpu counter called "nested_errors" to track the
number of errors returned to an L1 hypervisor when emulated VMX
instructions fail.

This counter should help monitor nVMX health and troubleshoot issues
with L1 hypervisors.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/nested.c       | 2 ++
 arch/x86/kvm/x86.c              | 1 +
 3 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5a3bfa293e8b..a3aaccd6e6aa 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1674,6 +1674,7 @@ struct kvm_vcpu_stat {
 	u64 preemption_other;
 	u64 guest_mode;
 	u64 notify_window_exits;
+	u64 nested_errors;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6137e5307d0f..2e1394151945 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -162,6 +162,7 @@ static int nested_vmx_succeed(struct kvm_vcpu *vcpu)
 
 static int nested_vmx_failInvalid(struct kvm_vcpu *vcpu)
 {
+	++vcpu->stat.nested_errors;
 	vmx_set_rflags(vcpu, (vmx_get_rflags(vcpu)
 			& ~(X86_EFLAGS_PF | X86_EFLAGS_AF | X86_EFLAGS_ZF |
 			    X86_EFLAGS_SF | X86_EFLAGS_OF))
@@ -172,6 +173,7 @@ static int nested_vmx_failInvalid(struct kvm_vcpu *vcpu)
 static int nested_vmx_failValid(struct kvm_vcpu *vcpu,
 				u32 vm_instruction_error)
 {
+	++vcpu->stat.nested_errors;
 	vmx_set_rflags(vcpu, (vmx_get_rflags(vcpu)
 			& ~(X86_EFLAGS_CF | X86_EFLAGS_PF | X86_EFLAGS_AF |
 			    X86_EFLAGS_SF | X86_EFLAGS_OF))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff8812f3a129..475c8a2d704e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -299,6 +299,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, preemption_other),
 	STATS_DESC_IBOOLEAN(VCPU, guest_mode),
 	STATS_DESC_COUNTER(VCPU, notify_window_exits),
+	STATS_DESC_COUNTER(VCPU, nested_errors),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {

base-commit: 0499add8efd72456514c6218c062911ccc922a99
-- 
2.43.0


