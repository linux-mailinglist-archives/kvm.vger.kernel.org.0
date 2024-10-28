Return-Path: <kvm+bounces-29822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A86B29B28BE
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 08:31:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F1A01F21648
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 07:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33B8A1922E9;
	Mon, 28 Oct 2024 07:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Boi1Zg9U";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="oCPdjNXn"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A52F191F79;
	Mon, 28 Oct 2024 07:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730100632; cv=none; b=mpA6im63l9HgEnJBpJPPD8I/6gJ8pJmghSJgED0BEOd48NECMDmuf1tQtPTjU+QPNUbGr3VPbgSRCLhrvtf1g8D4VyrMcui/ReVdFqbCC4JUuy3OJY35ZH0G2nUQ/y5At4oPzr21NmDxpNVCUza1sqdiVWMja3WRlpTPgt6n5Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730100632; c=relaxed/simple;
	bh=MxYhjBjf/tvzWtOpWKpyyouzFad91PQW0/nSkr7Pexk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T1EqeXFtL9Tv25m4pqluuZ1f4fdFsHQtF99pKGI/9Tgc/Nd9C4SdoKZFyG1JOGmDzkCx1AqhNf3taAR8icxQ8MBknLRR+DbMcT8269/yLmiIEMK52eGHkNoBpLNF6Wu6iEyJZLcOyuR9h+1x6t5PVJNmqrPjdKfEVQC+NQn7ZMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Boi1Zg9U; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=oCPdjNXn; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1730100628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7y7RWelbheRVtoq3d6yz9NK/DqZz1bs7H+wrQ4ILfpg=;
	b=Boi1Zg9UPsIBQ0baY5dSSoJ9HKobMMBSJKP3iAFcGDSn19CBv5rPcRoSV6m5feerUFoXbL
	bvayPi7EGctkW8iNAXKZOS9ZRAnqJVfQPXL/3Kyn1pTKbHu5mfUG4/XASpBBI8CTUbKnLu
	v5gCJY+JusyPE5ZFK4nwahRONEt804X3N34SCTs9EZwk5b82lncFe1FNiMoRBs966Ye42S
	1e10+hczqITjisQS5AUzf33Vs+9QDoEHW4IVgqotqsVfk0jTRezvsH0U47ZvTdbsIlcOjV
	W5Ntzir0XClUR3UXoHWEX9NbF8KaKmgUKtcZjWZi4yBUB0o4cpTLOwUIv8wvQg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1730100628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7y7RWelbheRVtoq3d6yz9NK/DqZz1bs7H+wrQ4ILfpg=;
	b=oCPdjNXn0ywzUwH4Xy1PuGBoOGiGNvKV7k37NYNpiuOo3iNllFN3pyyGcEBgg1w5YDfR6C
	at10mMx7FCz1bsBg==
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org
Cc: Nam Cao <namcao@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 04/21] KVM: x86/xen: Initialize hrtimer in kvm_xen_init_vcpu()
Date: Mon, 28 Oct 2024 08:29:23 +0100
Message-Id: <c8e184b7acf1e073c0d6cf489031bc7d2b6304b0.1729864615.git.namcao@linutronix.de>
In-Reply-To: <cover.1729864615.git.namcao@linutronix.de>
References: <cover.1729864615.git.namcao@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The hrtimer is initialized in the KVM_XEN_VCPU_SET_ATTR ioctl. That caused
problem in the past, because the hrtimer can be initialized multiple times,
which was fixed by commit af735db31285 ("KVM: x86/xen: Initialize Xen timer
only once"). This commit avoids initializing the timer multiple times by
checking the field 'function' of struct hrtimer to determine if it has
already been initialized.

Instead of "abusing" the 'function' field, move the hrtimer initialization
into kvm_xen_init_vcpu() so that it will only be initialized once.

Signed-off-by: Nam Cao <namcao@linutronix.de>
---
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
---
 arch/x86/kvm/xen.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 622fe24da910..c386fbe6b58d 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1070,9 +1070,6 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, stru=
ct kvm_xen_vcpu_attr *data)
 			break;
 		}
=20
-		if (!vcpu->arch.xen.timer.function)
-			kvm_xen_init_timer(vcpu);
-
 		/* Stop the timer (if it's running) before changing the vector */
 		kvm_xen_stop_timer(vcpu);
 		vcpu->arch.xen.timer_virq =3D data->u.timer.port;
@@ -2235,6 +2232,7 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
 	vcpu->arch.xen.poll_evtchn =3D 0;
=20
 	timer_setup(&vcpu->arch.xen.poll_timer, cancel_evtchn_poll, 0);
+	kvm_xen_init_timer(vcpu);
=20
 	kvm_gpc_init(&vcpu->arch.xen.runstate_cache, vcpu->kvm);
 	kvm_gpc_init(&vcpu->arch.xen.runstate2_cache, vcpu->kvm);
--=20
2.39.5


