Return-Path: <kvm+bounces-67815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 96CCDD14803
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:48:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B369530AEEFB
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:45:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B2E737F10C;
	Mon, 12 Jan 2026 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xabDZH0C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B9F37E31E
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239951; cv=none; b=Jztdkb9I8g7yR6D3PjL2V7p77xC053iaqcv2e3Trq5v9r1nEHkFHsdKLUEx+YGijf2VW9CN0XAm61v2HYnXwMiYzi63zacdh28nTUwuyrLaOZ22XimHEj5awfZ5o/xjpkHtomOqqdvqEPyijimuWkvdHfE45ydl8zTUKtmw5swI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239951; c=relaxed/simple;
	bh=9dxDLq6/qAbthmcYVLL6UpPvQimXHGVn+my1jHf4ajs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dD5xpaco/BWRKGcBA7sa5TyMWkhk6utr/P54Vd8BZYI8/4TWg3fWCIg+Q14PF8RlJgp45Eza0VEHRMdsGpB1nxw5uKYi1FtiBCO5qxC3dPy0+93aujCVx/JLTrac8T4YobzOER6x2Hwvr4C3kv0mKGdD2iYa31CSOUOoaD0lLIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xabDZH0C; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c551e6fe4b4so1912766a12.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239947; x=1768844747; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9mYJ7s1EdI2aCs8/LY1HGP2jLg2izSehk1J5fh5cOc=;
        b=xabDZH0Cwrs9jzvfGlyzajmKwkNAAU59OmT4GnNkP0Tj2dPj9kZCg00nyK17XS5hiZ
         QkHJbFwk/tgfE9+HpNFc/Egx8uanGI8boaAFwf+bGApeiwDeeYunyYjnX+ELq+fPIfEP
         X1B0sY8RnElviNY79+Jxe8zz35+NY+HdduGbsc+sNC9f0h726ONTmNFiWRFHxNUZ2zmo
         asXzOfeOX5CXhkL58a4VL9HO/HuVFATWSY6EADYrNGSj10860fsph+fmQzsqmURZd65n
         bRaCmMQEyGplckvj48TbBfCVw6PX75Txr2JKokmU1zRlJLWbzbRE6PTjwLvzxJODWgG0
         rb8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239947; x=1768844747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9mYJ7s1EdI2aCs8/LY1HGP2jLg2izSehk1J5fh5cOc=;
        b=ITBH1h9oKbbVa5gyh7vm21rC+eUW2nIdMYAuQspljqB/z/2B3ruJDHikLb2V6Q+ozc
         tDZzeFf/Qwmu+a44m4OTjq/0Oq0ZJpm1IxIAyo9CEt3uXbyrjFRtM1oW9ulxq/kJwZLT
         Ev/8jok8SpAB8T4Rm+MqmErNdmI+XH9CfJErSGquSM+s0x2EfYfstX2pmHa6vo4oKh47
         TYISnZMasRJl25CNRdoN5Rw9lbBHsFeiSpFL0oNPpAHlIO/q7tj/JlBiJdGnhpm66qP6
         Hh03WiE/X84UYJrPdWFR1eA4IhqjZg97LPkFa1X27qz0nI/OgpxB4t4V5tLJ4kfRLz1Q
         zLsA==
X-Gm-Message-State: AOJu0Ywg34ws0d5iiHcJxJLhpkHm923MeBJXGVTkqh2L6Ugxz4wwJui9
	yQYr6EwsI/XBs94yF8LvvUkot9CwakTfTZdmO6Z2T8SumDpWF7HSR1esfpXqTeaxPgTNgw1M+4G
	H276aHy+OXjCKfg==
X-Google-Smtp-Source: AGHT+IHZLWinKl0nXEQlsM/Y2+fQq9S0C1TX1a/ig3aUG4pOqNvEjoIehuB27rxhWrnVV4X7V9ruCvf18/saHw==
X-Received: from pjbcc4.prod.google.com ([2002:a17:90a:f104:b0:34e:8f5a:9197])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1c05:b0:340:bb51:17eb with SMTP id 98e67ed59e1d1-34f68c286c8mr16880247a91.15.1768239946859;
 Mon, 12 Jan 2026 09:45:46 -0800 (PST)
Date: Mon, 12 Jan 2026 17:45:34 +0000
In-Reply-To: <20260112174535.3132800-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112174535.3132800-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260112174535.3132800-5-chengkev@google.com>
Subject: [PATCH V2 4/5] KVM: SVM: Recalc instructions intercepts when
 EFER.SVME is toggled
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

The AMD APM states that VMRUN, VMLOAD, VMSAVE, CLGI, VMMCALL, and
INVLPGA instructions should generate a #UD when EFER.SVME is cleared.
Currently, when VMLOAD, VMSAVE, or CLGI are executed in L1 with
EFER.SVME cleared, no #UD is generated in certain cases. This is because
the intercepts for these instructions are cleared based on whether or
not vls or vgif is enabled. The #UD fails to be generated when the
intercepts are absent.

Fix the missing #UD generation by ensuring that all relevant
instructions have intercepts set when SVME.EFER is disabled.

VMMCALL is special because KVM's ABI is that VMCALL/VMMCALL are always
supported for L1 and never fault.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 arch/x86/kvm/svm/svm.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 92a2faff1ccc8..92a66b62cfabd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -243,6 +243,8 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 			if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
 				set_exception_intercept(svm, GP_VECTOR);
 		}
+
+		kvm_make_request(KVM_REQ_RECALC_INTERCEPTS, vcpu);
 	}
 
 	svm->vmcb->save.efer = efer | EFER_SVME;
@@ -976,6 +978,7 @@ void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu)
 static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	u64 efer = vcpu->arch.efer;
 
 	/*
 	 * Intercept INVPCID if shadow paging is enabled to sync/free shadow
@@ -996,7 +999,13 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 			svm_set_intercept(svm, INTERCEPT_RDTSCP);
 	}
 
-	if (guest_cpuid_is_intel_compatible(vcpu)) {
+	/*
+	 * Intercept instructions that #UD if EFER.SVME=0, as SVME must be set even
+	 * when running the guest, i.e. hardware will only ever see EFER.SVME=1.
+	 */
+	if (guest_cpuid_is_intel_compatible(vcpu) || !(efer & EFER_SVME)) {
+		svm_set_intercept(svm, INTERCEPT_CLGI);
+		svm_set_intercept(svm, INTERCEPT_STGI);
 		svm_set_intercept(svm, INTERCEPT_VMLOAD);
 		svm_set_intercept(svm, INTERCEPT_VMSAVE);
 		svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
-- 
2.52.0.457.g6b5491de43-goog


