Return-Path: <kvm+bounces-71738-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yJ4WI7xOnmlIUgQAu9opvQ
	(envelope-from <kvm+bounces-71738-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:22:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4746918E9B3
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:22:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7B0053067E74
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBD0527FD44;
	Wed, 25 Feb 2026 01:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E/S28+Gi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3947326E708
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982474; cv=none; b=BhQK/jP4TyXySWh/V7Rk4mS7uh6M/rDxQVd9qQ0HRjaXnT/ZO6UkQ7cm2dq6txbsptKmHRp0qgWcYpEfnUYytnNrr29BD9+na0cu8aDmJ1LA8yN6pZmWB93yPag3we0gqIiFQHqjk4daY0gbxYv/+VYucE7WQWHudny5yJA9zVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982474; c=relaxed/simple;
	bh=8BpbiNXkNmG68PauqKn1vI4bfavvNUcZL8H/4h/xCDU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a8PI9qSg6khHs5W0IfaXbRXdgXz1+1IWeolevKZ1TYC5TfArx0wT81t20Qw1b7QRpEdWiuy+SrEoKK3aS/wCF5fUs6/GVoJFx51to1O8QE81cVJUuMQ8IFxZLPYcX6gVQ6uibs+73UFmEffskVO1YedW7YfrNCNN7KOnQs8G0Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E/S28+Gi; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-358f42fad0bso2947785a91.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771982471; x=1772587271; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NC+PweffU72Wb4W/8tySGqQ5rYKiIvlwoGA5HRqPPw0=;
        b=E/S28+GiKw/h0AgddShLg2kxTtGNWU+SqqePcjI7qhDLWptlTcGOycmmLV0LjriD65
         4MHsIEiJ6vAWwM025BjKmgcX1lsGolh4fdfHW30dmZuuRe/1rqQU9LFnAca3NRZh5Go0
         cRpXF1t9nSE15ZoJ4sBVoq6UyqjUTthcGR79kv0xT2Y0dPTP1DTpI6FCB5Q+cxMCf2vS
         zQnC7leasPNY3hCTzDYRspDm1rO6ns07SqlAf4WCAiAvV6XUk+P7KCx/GWGb2rsMthpy
         +xE0VWCp68HzvW4RWhFgCy40Vy9vpOGx9Ik6D5kUgG8wsMIhZnS5dyGI/8Jf9/1VKtvc
         4ZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771982471; x=1772587271;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NC+PweffU72Wb4W/8tySGqQ5rYKiIvlwoGA5HRqPPw0=;
        b=K4Jl5beFbk1FXEOWU912TcwT4UmMCPl/sopZsd8zernb4Z36h28P7ZRiTgVT7CpWcg
         lNDBS0mtf6wZud7EqqP8MWW2ungmnyvdODa+mEE2hsJ0bq71lUNiDrbeK41sYRY151nE
         MILuJZHyyorSaB8b3ozGLvMjLvLOfuwDQZssVG9ibaFKFdZMz6XLFN7eSYrui6ix0iyd
         xcBkEyInkUZ3N4aeOHqb3NXouxf08mPogwFsiASNwhF6gPPfxwgfNOm//P6YhhTotLGE
         LhBAhAS3faL4/kpYdpOhKLX7W7DgChRiswUstNRfTwjx4GSneVw28tGRyBSksmoHcHXm
         7chQ==
X-Gm-Message-State: AOJu0YzMk3D6R1eCCz1a8YrYy912IoIZGK6lPwB4+YurZ8itz2auSGyX
	IbvHlboYVjdcDKrR5uSMt4r01ZdLV1h63IB/57amlhxSc/dob1PJYKrPX+jawpTcrFPbCellKuj
	swi+hpA==
X-Received: from pjbev14.prod.google.com ([2002:a17:90a:eace:b0:356:3104:ed7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ec5:b0:343:7714:4ca8
 with SMTP id 98e67ed59e1d1-3590f08c0e8mr548523a91.15.1771982471453; Tue, 24
 Feb 2026 17:21:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 24 Feb 2026 17:20:45 -0800
In-Reply-To: <20260225012049.920665-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225012049.920665-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225012049.920665-11-seanjc@google.com>
Subject: [PATCH 10/14] KVM: x86: Bury emulator read/write ops in emulator_{read,write}_emulated()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Yashu Zhang <zhangjiaji1@huawei.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>
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
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71738-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 4746918E9B3
X-Rspamd-Action: no action

Now that SEV-ES invokes vcpu_mmio_{read,write}() directly, bury the
read vs. write emulator ops in the dedicated emulator callbacks so that
they are colocated with their usage, and to make it harder for
non-emulator code to use hooks that are intended for the emulator.

Opportunistically rename the structures to get rid of the long-standing
"emultor" typo.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 022e953906f7..5fb5259c208f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8134,17 +8134,6 @@ static int write_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
 	return emulator_write_phys(vcpu, gpa, val, bytes);
 }
 
-static const struct read_write_emulator_ops read_emultor = {
-	.read_write_emulate = read_emulate,
-	.read_write_mmio = vcpu_mmio_read,
-};
-
-static const struct read_write_emulator_ops write_emultor = {
-	.read_write_emulate = write_emulate,
-	.read_write_mmio = vcpu_mmio_write,
-	.write = true,
-};
-
 static int emulator_read_write_onepage(unsigned long addr, void *val,
 				       unsigned int bytes,
 				       struct x86_exception *exception,
@@ -8295,8 +8284,13 @@ static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
 				  unsigned int bytes,
 				  struct x86_exception *exception)
 {
-	return emulator_read_write(ctxt, addr, val, bytes,
-				   exception, &read_emultor);
+	static const struct read_write_emulator_ops ops = {
+		.read_write_emulate = read_emulate,
+		.read_write_mmio = vcpu_mmio_read,
+		.write = false,
+	};
+
+	return emulator_read_write(ctxt, addr, val, bytes, exception, &ops);
 }
 
 static int emulator_write_emulated(struct x86_emulate_ctxt *ctxt,
@@ -8305,8 +8299,13 @@ static int emulator_write_emulated(struct x86_emulate_ctxt *ctxt,
 			    unsigned int bytes,
 			    struct x86_exception *exception)
 {
-	return emulator_read_write(ctxt, addr, (void *)val, bytes,
-				   exception, &write_emultor);
+	static const struct read_write_emulator_ops ops = {
+		.read_write_emulate = write_emulate,
+		.read_write_mmio = vcpu_mmio_write,
+		.write = true,
+	};
+
+	return emulator_read_write(ctxt, addr, (void *)val, bytes, exception, &ops);
 }
 
 #define emulator_try_cmpxchg_user(t, ptr, old, new) \
-- 
2.53.0.414.gf7e9f6c205-goog


