Return-Path: <kvm+bounces-70203-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EAA9KwRWg2mJlQMAu9opvQ
	(envelope-from <kvm+bounces-70203-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 15:21:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 54BD9E7003
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 15:21:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 622873005A91
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 14:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1AD6410D0B;
	Wed,  4 Feb 2026 14:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xFBfSsep"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0A9274FDF
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 14:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770214910; cv=none; b=bPeNbD1RFv2tfUniXa0+9sSlyGa+ZJ/ZWyie+M+M9IAGEW7X1PKggrf0AAj3GzgbuTW8Y5PMu52j3KTgFwpX+OnB66B3Ha2cMGUa5I/D1+gZVRdnfaP501KRe44AuND2YDf4Km6l9CFAcTBsqSVC4QxDGRP6Zls6TndpvVUlvBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770214910; c=relaxed/simple;
	bh=0MNDA2Ny0tJNWAJdXkje5Nlf+llWLY+vVIb/GMcUhbc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MabqIcjTVji20ZTYW/ToNg2Yo4UdnK1z9zWVUF5aNTUR8EKPYzjWbkYqDrqQS7Mi1Xea2dxht73kXs6P0Shg2RC1wFFOT1LE6Zuoye2REDS5Vz2ylS1KduoqHYtOsCLAcMd2ENbhYc2TiuZEnbDa1cZ0BhxZdvf+gHLqyA1DAlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xFBfSsep; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34e70e2e363so1169241a91.1
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 06:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770214910; x=1770819710; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qVJvtKJuuvGxGxyWpMoMpOxiQua226/Cb1xLlw715Yg=;
        b=xFBfSsepGo6+crUBO/KeDDXyjoFOaMaOfK7qRqcv3HRkuvk1dyJyvZli6oAb7jnzIX
         Evn76/lYtNsiVad1vouAa5XHbWAFg6Z0MftAP/9gQKHdE2Sy/De3DAzYYo2cZARPrK+7
         nbBhTN3c1G/9iF6dyPL2ksPFoS713weKk3fCCva6kyNLuuJib60IBu/MIwC7lSW+By26
         HHeJSgX/ZmLFpXznxMjlPRECfkpfS3RUvjoevfqkFYGACNhrjiIPugtFu0mui5GzRfb7
         c3BISO38gZnlqV+dcbhQv+82fWLUuIyn9vbO9rAIw0t2OcxiVmxaiLHcCA1toC+1YxhQ
         QF2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770214910; x=1770819710;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qVJvtKJuuvGxGxyWpMoMpOxiQua226/Cb1xLlw715Yg=;
        b=fwdRZyBGx9i2QSR3yeYcDcTmx+hj68/24zKz0Edt7j6/ZfrQOHpfc737/FzxcyLk2c
         7sTEDaPLvoD3YhgKDFzSQCmjy2DlC1XSHpz8ICQ2RfcFGLw56QwOh7zWtqcv9HJw3ogi
         v44ExbUQbHrsIZG7bQf6mSdTiEXH20v8ogjTTtwtBi0U4HJVSTVwvC3Pv0Mmy7cnEpwP
         K6OvtCtfgMNG6SxNI5zBCxg1e+u3oKmm4RnNcTQNnRy+2wTGYyf6VgozTQi2b9Og36ss
         lMjEkOIK+iZmCXv/20YGGt3Ny2gUR9RPoYqq7poJPOK+tx1hD/y+jaAKv/2bASONaDtq
         sEDA==
X-Gm-Message-State: AOJu0YyNFbVZUwKzJcPHDc+QRkYxwTbA6iH94OfsOxDVG5WwMmDi9vhP
	E+FAHFXZ0U5InalB1i2vZDzwbXpOIxN13DmgIGSPznBz8993cHd7TMSTpUKJAb5IZl1/2TJqiA9
	GPDQggQ==
X-Received: from pjbnk22.prod.google.com ([2002:a17:90b:1956:b0:34c:cb46:dad7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d12:b0:34c:4c6d:ad0f
 with SMTP id 98e67ed59e1d1-3548721e9d2mr2606038a91.37.1770214909813; Wed, 04
 Feb 2026 06:21:49 -0800 (PST)
Date: Wed, 4 Feb 2026 06:21:48 -0800
In-Reply-To: <aYJFdgUxYWXkavfi@iyamahat-desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <7acdd9974effabe5dc461aa755eacf9fb0697467.1770116601.git.isaku.yamahata@intel.com>
 <aYI-rqFnqJeAb_mB@google.com> <aYJFdgUxYWXkavfi@iyamahat-desk>
Message-ID: <aYNV_KJc6WDo0_cH@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: apic, vmexit: replace nop with
 serialize to wait for deadline timer
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: kvm@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70203-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,redhat.com,linux.intel.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 54BD9E7003
X-Rspamd-Action: no action

On Tue, Feb 03, 2026, Isaku Yamahata wrote:
> On Tue, Feb 03, 2026 at 10:30:06AM -0800,
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > > +static inline void serialize(void)
> > > +{
> > > +	/* serialize instruction. It needs binutils >= 2.35. */
> > 
> > And a CPU that supports it...  I don't see any point in using SERIALIZE.  To check
> > for support, this code would need to do CPUID to query X86_FEATURE_SERIALIZE, and
> > CPUID itself is serializing (the big reason to favor SERIALIZE over CPUID is to
> > avoid a VM-Exit for performance reasons).
> 
> Thank you for pointing it out. I'll replace it with raw_cpuid(0, 0).
> Or do you want to opencode cpuid() in each places?

It probably makes sense to add a helper to arm the deadline timer, and deal with
the serialization there.  E.g. start_tsc_deadline_timer() also has a nop() of
dubious value.

