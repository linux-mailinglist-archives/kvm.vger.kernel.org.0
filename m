Return-Path: <kvm+bounces-70465-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QEEKLgcrhmm1KAQAu9opvQ
	(envelope-from <kvm+bounces-70465-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 18:55:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3844510186B
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 18:55:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1B5C4301CC69
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 17:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 437AC426D15;
	Fri,  6 Feb 2026 17:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="irfEJoQ0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B0D42669B
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 17:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770400504; cv=none; b=Df1ucCNTdWpaErMPdHnVklXxQLkMVRmJUffQa/iMDhm+FG6f0R3KK0CFFT0kAzSK1GM+fG3K6W6seqZcadbToXAvxlPwQ4GxoyePR4d4DEYioUYEFcumZ8RpX6qmj1KJs3y07790OY3NXJZYsufH13CXm19vlMft2OqDMnP9eK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770400504; c=relaxed/simple;
	bh=GlpFnTDi8D4k/ZhVBxdkp4L72SyTwpevsbx9g3COs64=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YYbBq05EtXpNsSDNszg89Zo4TaX+QVrDQj/hGRzHhA5ERagPVIcFy1ob9wycdXoRoRQGuwGWwLyjWLNqsAaJAiubwIyeeoLIaKJGNFqF2V/dyPG89LilInZY/J3WwTXivr5CQJXefgMlSx5kMX9j3tH3jGvwZkbUcVvjFjnahuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=irfEJoQ0; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a90e8b54f0so26904055ad.2
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 09:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770400504; x=1771005304; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B8q7C/N88SwT4oefqY74mjYEGWdcBFY/qeCdLmO+nbo=;
        b=irfEJoQ0vRjuujv6wvFkTwAuSRR7mWcWJxAVcE1xXorrOBickHki8OvpL5STEO20fa
         tdiQkfv5fvPJkEWzqdD+XFpNzyYCTAMMcvrDxawg/e6WIy1SFNl2F7Lv0vdWxiFmWLzb
         w33snzB/v7mFJpavCDg+RIzREaSnI/IE4ulrZT6O9xkgS1iAsAEE4fjYQYYc5efzZ7jX
         GpG1HtOzPUGx+mRaC2YkZXZcnny9fjRA4FZjV7Rq4RlL6+WpoWpT59RYYeNN6QoNaHg8
         rYm/yUakTi3uY9bjy6qDw3aPudzIrKY5Qok15GyLT53qwhuJlEg1dotUGNMsTEilNx5H
         M0kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770400504; x=1771005304;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B8q7C/N88SwT4oefqY74mjYEGWdcBFY/qeCdLmO+nbo=;
        b=j3rvldbc0wjDFzC2LYJ3XKzUs2gwxMjqpnuD87AowaJHMNzlQrox2sxzx9xETktN+o
         MPAjthJLbUub6Lw3hbpWcVCcvLYUfUk8Nja10Q6y+Zo8j4wYVxzmYJLHiqrZ2BdKcPzj
         3wBppiSOi+DOK9K9K+q7WW2sHqhKu0AhZn2/D7iv5EYcpRtQ2cZ8/v/TuClLUfkZOsEK
         +TedjoTJD7+qixo+Ov0ngBRF9Z2O+44I6Sn0jbQAlv7wOxgcRYZmmWM99VxWHHHWJsXf
         75h/yPDKtSefTkOo4bmqT8GysQrZ75un+fbU90f0wMLyMZmzsCTspBR7zlfL0gdBy/Wb
         LkGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkNB25umUgLvgw2D80JuxtIwkKV99OHBrE71+iI4d3tzbmgDUu/tuTJC5Nz6ctu1fsmAg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyps/cjr6zzY4Osb0FxIHs5qIgIcAZMITPPPEGMlOSLWLyef8eY
	2RDVGuyCVkzk8KxHH9XeT8LUUPj6JbpLjgNvtJHbjSIc9p4mJtcXtQC27lijnhllW+cfbJ7p/xB
	GdTGAiw==
X-Received: from plhs13.prod.google.com ([2002:a17:903:320d:b0:2a8:74f9:83b2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3d0e:b0:2a9:484c:ff19
 with SMTP id d9443c01a7336-2a95194a492mr34248905ad.42.1770400503711; Fri, 06
 Feb 2026 09:55:03 -0800 (PST)
Date: Fri, 6 Feb 2026 09:55:02 -0800
In-Reply-To: <aYYgShD2-47P51ZM@blrnaveerao1>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203190711.458413-1-seanjc@google.com> <20260203190711.458413-3-seanjc@google.com>
 <aYYgShD2-47P51ZM@blrnaveerao1>
Message-ID: <aYYq9u7bZWsmJNMr@google.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Set/clear CR8 write interception when AVIC
 is (de)activated
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70465-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 3844510186B
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Naveen N Rao wrote:
> On Tue, Feb 03, 2026 at 11:07:10AM -0800, Sean Christopherson wrote:
> > Explicitly set/clear CR8 write interception when AVIC is (de)activated to
> > fix a bug where KVM leaves the interception enabled after AVIC is
> > activated.  E.g. if KVM emulates INIT=>WFS while AVIC is deactivated, CR8
> > will remain intercepted in perpetuity.
> 
> Looking at svm_update_cr8_intercept(), I suppose this could also more 
> commonly happen whenever AVIC is inhibited (IRQ Windows, as an example)?

Maybe?  I don't think it's actually common in practice.  Because the bug requires
the source of the inhibition to be removed while the vCPU still has a pending IRQ
that is below PPR.  Which is definitely possible, but that seems overall unlikely,
and it'd also be self-healing to some extent.  E.g. if a workload is triggering
ExtINT, then odds are good it's going to _keep_ generating ExtINT, keep toggling
the inhibit, and thus reconcile CR8 interception every time AVIC is inhibited.

