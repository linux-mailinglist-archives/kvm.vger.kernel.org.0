Return-Path: <kvm+bounces-68776-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0FA2MFk5cWnKfQAAu9opvQ
	(envelope-from <kvm+bounces-68776-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:38:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 452515D684
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:38:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C868E6272C7
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 20:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29E70410D24;
	Wed, 21 Jan 2026 20:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i+BT9swE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161AE40FD83
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 20:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769027081; cv=none; b=aVpd/Lru5ZhOWTtIHkAwekLoNYKBN7reazRVAPZ+7HfN8QKtbwNI7d1Hf4Y7M3tUTwWXQNxZAP5L8uI9K1hgK5JxNDKsYZ86QC7qSNdes8dHl4I63gGXzdW4jWDVeSeQRtwJBRP3MdyvhX286+FE9iWBreTk6iQsLWgwp+72BO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769027081; c=relaxed/simple;
	bh=Jaq2jsRG/r4sZNtPJ8ltyTFCbLArZNy2emYqmWGFUaU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cna2jns5/7oaLakTyab7Gla3jJk7dA/GEloJf9QP+HD5yDPxq6QuFp6y4Vnd3hZhmYRpAKtruAGy6R0pMO4kQwN8OujZixT/vuTaEUwWTbCEVSeMcLZKlLTXQw+vZGyXCo4r1tuLwsCB6n8eXyG/TFrCsekCl3mvfiNnbrl1mw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i+BT9swE; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0b7eb0a56so1695515ad.1
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 12:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769027078; x=1769631878; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+MgxcQq5Xqx+GbQCEBAnHK7cTgnKSfyobaM2qHohzJ0=;
        b=i+BT9swEet3BcYwvpun23CLnOmfL43ZZZW8N5xVlY1Iu9O+4YBbISMYw2ng9czEDIH
         ciXoYnVPKINZw4o5aGUbHCCHaps6BqB9E02vYE4cQNtseroemksB0RIfCtrSDnHF48To
         UO1uE7TzSrdYZ8OPUhKkvT2evmp4M3K/3Tfe8bq95iBv4YXRC8u0PbnCjL21P2imZdLK
         L4vDBxdTUlKEBoVGLlG+MuYscjNw5jO1WjkBLfZGLl8V2Hbx85B4sjh/rASpmxL/Z4WU
         C7LqMcfwcUkiUIBDxBPxOvuisgkQccqAD83b63g0yk2MeP93Hbm4xjQ2ISrWoxrP1Wqr
         vJ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769027078; x=1769631878;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+MgxcQq5Xqx+GbQCEBAnHK7cTgnKSfyobaM2qHohzJ0=;
        b=OATi3Auta94ScaiRgLo31J0dCpofKxlPEs8mX3nP0FVAotFzsRn2t1+mWh0RtBfjS4
         Uof+7Zmjn+paKDEtfmx4GQqNP50oO2WnWZ5M7igzk425GRakkADTjfChZQq4z71gMDu7
         NS0OhbVZluyzy4D2nDYASj4mxmFuJyLVb3Ch3ihY1vRNoMJLmtC4LvQawZ/6DhZM/eQ8
         20bZG0Xnl7TRfdKBWEbdoC3CyzrQ4BfQLWDVQQXQzLsHXB5D2oZ77Y1ULAA9Tk973FBK
         9VEzzfR3BLXnZHVcGIbbP775I4R3zYeuvZIHhINDWIlqa1nxjRfvobzis0k88Tak2zEF
         qwZA==
X-Forwarded-Encrypted: i=1; AJvYcCWl9Ok/iZkeqFpqhO2TFLNqC3sg44ulpNJwXaZsB7a+LSPPhxH/+GIuI4JLFVrZ2ON3tv4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxInwRcDedrj5If38CzM95oNPkykfc7OxipCLNABMW+YR0Zu0/t
	pJEy6Truow1WM8+c3s+BeLlfyOm0UD5ri0HHu3gfIJi3eWSFgGIJkYXa6LifesSYClwVG8FdA8i
	+0o2mcw==
X-Received: from pjbca22.prod.google.com ([2002:a17:90a:f316:b0:33b:ba24:b207])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfce:b0:353:3977:a082
 with SMTP id 98e67ed59e1d1-3533977a5ddmr180576a91.1.1769027078236; Wed, 21
 Jan 2026 12:24:38 -0800 (PST)
Date: Wed, 21 Jan 2026 12:24:36 -0800
In-Reply-To: <BEB86711-AE1D-4438-8278-229275493134@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251026201911.505204-1-xin@zytor.com> <20251026201911.505204-12-xin@zytor.com>
 <9a628729-1b4f-4982-a3e6-b9269c91b3c2@linux.intel.com> <BEB86711-AE1D-4438-8278-229275493134@zytor.com>
Message-ID: <aXE2BPCKvcIiQbqU@google.com>
Subject: Re: [PATCH v9 11/22] KVM: x86: Add a helper to detect if FRED is
 enabled for a vCPU
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, pbonzini@redhat.com, 
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com, 
	hch@infradead.org, sohil.mehta@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68776-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,intel.com:email]
X-Rspamd-Queue-Id: 452515D684
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026, Xin Li wrote:
>=20
> > On Jan 21, 2026, at 12:05=E2=80=AFAM, Binbin Wu <binbin.wu@linux.intel.=
com> wrote:
> >=20
> >=20
> > Not sure if it's OK with empty change log even though the patch is simp=
le and
> > the title has already described it.
>=20
> IIRC, Sean changed it this way ;)

I doubt that.  Ha!  Found it.  From: https://lore.kernel.org/all/ZmszIOsGtN=
svqbpI@google.com
as an attachment:

[-- Attachment #4: 0013-KVM-x86-Add-a-helper-to-detect-if-FRED-is-enabled-f=
o.patch --]
[-- Type: text/x-diff, Size: 1418 bytes --]

From f38dcc04e334cda572289f05f4be7702bebfc96a Mon Sep 17 00:00:00 2001
From: Xin Li <xin3.li@intel.com>
Date: Wed, 7 Feb 2024 09:26:31 -0800
Subject: [PATCH 13/28] KVM: x86: Add a helper to detect if FRED is enabled =
for
 a vCPU

Add is_fred_enabled() to detect if FRED is enabled on a vCPU.

Signed-off-by: Xin Li <xin3.li@intel.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 75eae9c4998a..fe5546efd388 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -187,6 +187,21 @@ static __always_inline bool kvm_is_cr4_bit_set(struct =
kvm_vcpu *vcpu,
 	return !!kvm_read_cr4_bits(vcpu, cr4_bit);
 }
=20
+/*
+ * It's enough to check just CR4.FRED (X86_CR4_FRED) to tell if
+ * a vCPU is running with FRED enabled, because:
+ * 1) CR4.FRED can be set to 1 only _after_ IA32_EFER.LMA =3D 1.
+ * 2) To leave IA-32e mode, CR4.FRED must be cleared first.
+ */
+static inline bool is_fred_enabled(struct kvm_vcpu *vcpu)
+{
+#ifdef CONFIG_X86_64
+	return kvm_is_cr4_bit_set(vcpu, X86_CR4_FRED);
+#else
+	return false;
+#endif
+}
+
 static inline ulong kvm_read_cr3(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
--=20
2.45.2.627.g7a2c4fd464-goog

