Return-Path: <kvm+bounces-72770-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qMntIkzVqGnpxgAAu9opvQ
	(envelope-from <kvm+bounces-72770-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 01:58:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1103B209A39
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 01:58:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4DBE1304A59F
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 00:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C5CF22A80D;
	Thu,  5 Mar 2026 00:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="trzRVrao"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DF81E531
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 00:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772672297; cv=none; b=UcEvQITm+/cdadSJDaGwgRK+8m7j/g9lrLpoxY6Qn3N5TMT8VBij+6ExqquNdqsDdUCEIaZULDl6IYInxu0AequqPDWG2/in/cpaVuATxDW4/ONZZ5ZB/Vyda/cB1U6YtrlNwOh77QY3kmtYCWjwIIeMAf1dDJP9yQyU6PhCh5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772672297; c=relaxed/simple;
	bh=WSamV3bJGwVCKYfsWBc2fcUJ8VRYquFsGqzA2SVkL6c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kQcujKDv1VVk+Jd0JVF56oYjOzMaqwaX/BiPN0IPN6wcls+80h2iVoRDf/Hs3NioRtn2l1nKWCTrzB81CPFJ03C+izKuBa9YoS5jNSKIuzHIrnxuzT/OkpXev0j5/p42Oe+wXABnSyumPctfnXk1HeTQal5yXATF1bK8rSajOLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=trzRVrao; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae57228f64so37083945ad.0
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 16:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772672296; x=1773277096; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KSIZnrQN4PY6Sd3rSuJIjuMIxqVFieEA+dujL5XM0o8=;
        b=trzRVraoBaAt/POa/JCb+sRz6mY0MNWsPRpE3Vkoq6+hNPyYdTbmxDbiykx2K9EP/m
         NpLknlyQbFaqq05Wyn8HL0C+Ajcld9194QUmXJ2JSY3hyuA9iZmx+k7pEH16pK7Zx7Wo
         4wp3y/JWzGbqD3Pl6bGn2b2w6H1p09//gsiS22y8RRxhKWExlfRsqPaQs7O32Fn3cU2q
         xZ7FJMebg9X8nOJz6pkxcWAc/cFlnDMacPxwjW+oKx4xiPwA8ziVloW1LQ2D89MNJjJo
         8XbWyfw3XuP4OsNmwx2a+D9sHocITjQ+IVe0BGV7AtzU+yHbybcdrSUxfH0U87WNVkE+
         O4cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772672296; x=1773277096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KSIZnrQN4PY6Sd3rSuJIjuMIxqVFieEA+dujL5XM0o8=;
        b=F89P9ENPH5wkhD1qiyHdms8cHNZ3D4chrudzQQvFPbd/HSjV+/t6JfcqLmFCf1knNu
         f+kM48Ekd2kFUTMdczdibur4e6uzrb1X0BtCjYEXxxPXd38XRBvRF9vFPDVwDoL4hzNr
         oMdctIGxvPygmtlhYcvX/DOtlnsjk+WGnGN2+Oh+mP6T6aqWpQmdz17thmxgrlWfvCVy
         tIdIejVk6I3h3Z4fxquEF7b9xIzQwhcki/MKMnKdhThzk3DVyO0rh9DxERjJiyhJR1DK
         MGfPzB5nn4GUtx0hfRBkVnf3ZwrjcFXu3obAJWPUq1HS+Kxt6ZmWgLRWITWeFUpBFg2X
         SZdg==
X-Forwarded-Encrypted: i=1; AJvYcCWxSnQ2MtCnY0WeBCrHdQsFZhVqV5lWiuCfhvGpj606JsxFfew4iTwaWG/H1SYZ1JqQW7k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3LlBhrBFVRSKN/LQO7dkBxhEY/igew77qmHS180c5eIwo7mRp
	ngkfOb8VZEKk4F9FPWTUCYq6k4E7l+MNIzNzpU7NtScOw3yQe/Qx0j3tyr7JgHTPMfFQXUTKtJA
	bDMeTgg==
X-Received: from pgcv18.prod.google.com ([2002:a05:6a02:5312:b0:c63:4cb4:6aa1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:ae2f:b0:394:f73b:734e
 with SMTP id adf61e73a8af0-3982df0703fmr3642488637.26.1772672295877; Wed, 04
 Mar 2026 16:58:15 -0800 (PST)
Date: Wed, 4 Mar 2026 16:58:14 -0800
In-Reply-To: <aR1xNLrhqEWu+rmE@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251026201911.505204-1-xin@zytor.com> <20251026201911.505204-16-xin@zytor.com>
 <aR1xNLrhqEWu+rmE@intel.com>
Message-ID: <aajVJlU2Zg4Djqqz@google.com>
Subject: Re: [PATCH v9 15/22] KVM: x86: Mark CR4.FRED as not reserved
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com, hch@infradead.org, 
	sohil.mehta@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 1103B209A39
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72770-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,zytor.com:email]
X-Rspamd-Action: no action

On Wed, Nov 19, 2025, Chao Gao wrote:
> On Sun, Oct 26, 2025 at 01:19:03PM -0700, Xin Li (Intel) wrote:
> >From: Xin Li <xin3.li@intel.com>
> >
> >The CR4.FRED bit, i.e., CR4[32], is no longer a reserved bit when
> >guest cpu cap has FRED, i.e.,
> >  1) All of FRED KVM support is in place.
> >  2) Guest enumerates FRED.
> >
> >Otherwise it is still a reserved bit.
> >
> >Signed-off-by: Xin Li <xin3.li@intel.com>
> >Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> >Tested-by: Shan Kang <shan.kang@intel.com>
> >Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> 
> I am not sure about two things regarding CR4.FRED and emulator code:
> 
> 1. Should kvm_set_cr4() reject setting CR4.FRED when the vCPU isn't in long
>    mode? The concern is that emulator code may call kvm_set_cr4(). This could
>    cause VM-entry failure if CR4.FRED is set in other modes.

This has nothing to do with the emulator, KVM will intercept and emulate all
CR4 writes that toggle CR4.FRED.  KVM also needs to enforce leaving 64-bit mode
with CR4.FRED=1.

> 2. mk_cr_64() drops the high 32 bits of the new CR4 value. So, CR4.FRED is always
>    dropped. This may need an update.

Ugh, I didn't realize FRED broke into bits 63:32.  Yeah, that needs to be updated,
and _that_ one is unique to the emulator.

Unless Chao and I can't read code and are missing magic, KVM's virtualization of
FRED is quite lacking.

More importantly, I don't see *any* tests.  At a bare minimum, KVM's msrs_test
needs to be updated too get coverage for userspace vs. guest accesses, save/restore
needs to be covered (maybe nothing additional required?), and there need to be
negative tests for things like leaving 64-bit mode with FRED=1.  We can probably
get enough confidence in the "happy" paths just by running VMs, but even then I
would ideally like to see tests for edge cases that are relatively rare when just
running a VM.

I'm straight up not going to look at new versions if there aren't tests.  Like
CET before it, both Intel and AMD are pushing FRED and want to get it merged,
yet no one is providing tests.  That's not going to fly this time, as I don't
have the bandwidth to help write the number of testcases FRED warrants.

