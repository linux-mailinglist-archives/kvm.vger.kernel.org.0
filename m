Return-Path: <kvm+bounces-22254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72E0C93C612
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 17:02:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88A7E1F21DD0
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 15:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0174519DF4B;
	Thu, 25 Jul 2024 15:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OaAdl1sZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECBF19D8AE
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 15:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919690; cv=none; b=OwWTfGLKEwWbKFhe3OUJzjfXRBv7A/I3WEmqi8+j8Ni6y3L0RMWkn5IENo0ckq2/hFB7s0DN14P5os9Qe6+XmrNj7Q+dOAynB7wtF/cDpUotXnF0V+2/zOFE1254BHtGCoCguO3SbrBiSk5UEWtl7Woa2Eu0LwPSpSGMU3bNQV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919690; c=relaxed/simple;
	bh=/OVHaD2wSIdMirqcn9G3fNf3EzpQCnbHBXwb/43LwXo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UVZo+XG8mKl720Gedjh4BiwirwqLVXu3TG2iTC+ui9pnsGYvLJc9h3goWsCgYUa9Jj4w2ZhI0ivFleSKUyZ1LeN5qMtXuacAXbiRFpc/SDY2oqEok2PgRZWHnyLU+C8Aj+Kwc3AypM8KpxkESvMOZY+50Gnr2Z7HewnZmYdk/Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OaAdl1sZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721919687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fE+8dURlGl4WNroaQoDbMrrQ+8EOCbiOKv9YKQKsOn4=;
	b=OaAdl1sZQvr1lFsvUGasEIqJ/mDaJao1LMQoLhfTNQxP+dLh05/5YPMv4frrwYHQj5Wzr7
	Kq3Jb4qDtGR5owVwmTZT6N5woH1z6Lg3+D5aH5HohqITns8ezSVKQdgHOY5hlphcQNIxAf
	VQCQMZ5HoUBTszPL6AHZ8AGiOI0ffn0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-507-N2QEV_9vPXuDvrt9hDg-Hg-1; Thu,
 25 Jul 2024 11:01:21 -0400
X-MC-Unique: N2QEV_9vPXuDvrt9hDg-Hg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4583E1944B2B;
	Thu, 25 Jul 2024 15:01:16 +0000 (UTC)
Received: from starship.lan (unknown [10.22.8.132])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 141731955F3B;
	Thu, 25 Jul 2024 15:01:13 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/2] KVM: x86: relax canonical checks for some x86 architectural msrs
Date: Thu, 25 Jul 2024 11:01:09 -0400
Message-Id: <20240725150110.327601-2-mlevitsk@redhat.com>
In-Reply-To: <20240725150110.327601-1-mlevitsk@redhat.com>
References: <20240725150110.327601-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Several architectural msrs (e.g MSR_KERNEL_GS_BASE) must contain
a canonical address, and according to Intel PRM, this is enforced
by #GP on a MSR write.

However with the introduction of the LA57 the definition of
what is a canonical address became blurred.

Few tests done on Sapphire Rapids CPU and on Zen4 CPU,
reveal:

1. These CPUs do allow full 57-bit wide non canonical values
to be written to MSR_GS_BASE, MSR_FS_BASE, MSR_KERNEL_GS_BASE,
regardless of the state of CR4.LA57.
Zen4 in addition to that even allows such writes to
MSR_CSTAR and MSR_LSTAR.

2. These CPUs don't prevent the user from switching back to 4 level
paging with values that will be non canonical in 4 level paging,
and instead just allow the msrs to contain these values.

Since these MSRS are all passed through to the guest, and microcode
allows the non canonical values to get into these msrs,
KVM has to tolerate such values and avoid crashing the guest.

To do so, always allow the host initiated values regardless of
the state of CR4.LA57, instead only gate this by the actual hardware
support for 5 level paging.

To be on the safe side leave the check for guest writes as is.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6968eadd418..c599deff916e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1844,7 +1844,36 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 	case MSR_KERNEL_GS_BASE:
 	case MSR_CSTAR:
 	case MSR_LSTAR:
-		if (is_noncanonical_address(data, vcpu))
+
+		/*
+		 * Both AMD and Intel cpus tend to allow values which
+		 * are canonical in the 5 level paging mode but are not
+		 * canonical in the 4 level paging mode to be written
+		 * to the above msrs, regardless of the state of the CR4.LA57.
+		 *
+		 * Intel CPUs do honour CR4.LA57 for the MSR_CSTAR/MSR_LSTAR,
+		 * AMD cpus don't even do that.
+		 *
+		 * Both CPUs also allow non canonical values to remain in
+		 * these MSRs if the CPU was in 5 level paging mode and was
+		 * switched back to 4 level paging, and tolerate these values
+		 * both in native MSRs and in vmcs/vmcb fields.
+		 *
+		 * To avoid crashing a guest, which manages using one of the above
+		 * tricks to get non canonical value to one of
+		 * these MSRs, and later migrates, allow the host initiated
+		 * writes regardless of the state of CR4.LA57.
+		 *
+		 * To be on the safe side, don't allow the guest initiated
+		 * writes to bypass the canonical check (e.g be more strict
+		 * than what the actual ucode usually does).
+		 */
+
+		if (!host_initiated && is_noncanonical_address(data, vcpu))
+			return 1;
+
+		if (!__is_canonical_address(data,
+			boot_cpu_has(X86_FEATURE_LA57) ? 57 : 48))
 			return 1;
 		break;
 	case MSR_IA32_SYSENTER_EIP:
-- 
2.26.3


