Return-Path: <kvm+bounces-20620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BE2CB91AEC7
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 20:07:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A7851F227A6
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 18:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625B019AA62;
	Thu, 27 Jun 2024 18:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C3fQPu8l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4960914D6EB
	for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 18:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719511631; cv=none; b=h80i+LgZ25pWLkInM4ZyGCs+pvhk0wLAa0PMTXDY9vA6+nCXMWtR/V/YyujVp8hggo4DVmFhGgBTjgzp/oUdiErSrPt0WMeCLMUUkCCS9L/Yap6Z58bucF7Nt21uAeHCiR7zB6kzfKcUccYFIuVYi49IULGUOjHRBJpCLSyKArE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719511631; c=relaxed/simple;
	bh=EAiH5AcxDGizDsjRBCmIonmcVf1bNXt8AIH/QALB0Ns=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FKsJt1s44x2uWhO9YBoI3hLNQBpy9XZJB+P6sTt0t9PEBtQzuS+GPEpuGok1Kn1FTbmuJJmrPFjpii5XIn5krE77Nkv4xD9KzzFnnMEpvxkFiDSLEhnz9ovOnpr+DTyEI2+0btRd5S3EE4VJk0jGuPVB+wrod8vMo9KeQs62jIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C3fQPu8l; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7225d0435a9so3527927a12.2
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 11:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719511629; x=1720116429; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ly6j+LQp+Ou/MLEtOL32JfRKdC+LpNg62gKylauHIOE=;
        b=C3fQPu8leLvo+fMkuxHrRO/B5L9L7Nj/TIW0RKBypiH/Y3YSU9gL65fKcN0AqYcs5T
         SG7rM3ZCyhbwlnGRieU3os9fV0ZBs5FFBuYQl6d6xI+V3OOfgMmlFi+SLsO6MbXqfHo5
         wNiQ8mYke+j52265nH6Ikzc/6DkKBHfhjyxxn82Cv99oQU9MWQ3ll/qZPkzYbhf7E0dQ
         0sdFxWcoojliciaUoDN/HNicaEZQ7X3l2jWAVB6U48wsznKxujzdkpvqMQs/j7yrgiek
         2wAAey6lsEWQT9zPbLSOmlvQnDWK2IcIEK8EfHXRg16IfQ/ud8XKcx5gcmhEp8kO/AFw
         1DLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719511629; x=1720116429;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ly6j+LQp+Ou/MLEtOL32JfRKdC+LpNg62gKylauHIOE=;
        b=iizrQDnULgBCYsvfaMhtEYHhrwPStyiD6QJEg8x04ybHyx8ZlEBFze0k3BPxw7tLFJ
         GDlFjRT/jKaG39ik2CtLJoQqvng0zVTeH+YGeNPbmTtRr2Mtlbot0HO00eL4CmjLBmQF
         vahbCFRJGxYBg9BBu5J11AXIvlW2ca/YtM/6XcnNRxwaMWPQeAX9R0xe6pP35WvdqAtl
         qI77jk12TmSwBqxLDC2dNPbltIzqX+gP+XA9BDExDOiBzTZV/nQBcmC09v6/JPrpQrFw
         mr2/gn83BHOt5QKXh16xwgYfUvFSq9WpWiOj2/jL4Fcazbh4138+S1SvlfMKQowFZg0B
         /Jsg==
X-Forwarded-Encrypted: i=1; AJvYcCV4VJtBdV69dO6pJbSgXZNHw4accsrsLyXgcTtxH9CRPYE+pIyUoIt9VG47BPIwkDPnfWGkF8iJR2IcWrEyKLVn1Mra
X-Gm-Message-State: AOJu0YyQFs9W5DuFJyEdGIl2P5IZDQmJUjV98YoCIh6fbVPbMrNC5HEi
	5Jm3EZdToNut69dRHiUUXfmIKDyKubYGzkPQtikgtgLHP2/JwGBKtvekeviajngk1yqwJ+q4HqJ
	DdA==
X-Google-Smtp-Source: AGHT+IGB7UmqG7gr2s7ZFzglQssq+22/a1ExsgepdyatAXjw/z8ykZWCdPSekWALd2u1nA+fi04auchOvYs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:591:b0:71a:e413:b0ef with SMTP id
 41be03b00d2f7-71b5a24f606mr39867a12.3.1719511628344; Thu, 27 Jun 2024
 11:07:08 -0700 (PDT)
Date: Thu, 27 Jun 2024 11:07:06 -0700
In-Reply-To: <30988934-c325-64eb-a4b1-8f3e46b53a55@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-2-michael.roth@amd.com> <ZnwecZ5SZ8MrTRRT@google.com>
 <6sczq2nmoefcociyffssdtoav2zjtuenzmhybgdtqyyvk5zps6@nnkw2u74j7pu>
 <ZnxMSEVR_2NRKMRy@google.com> <fbzi5bals5rmva3efgdpnljsfzdbehg4akwli7b5io7kqs3ikw@qfpdpxfec7ks>
 <ZnxyAWmKIu680R_5@google.com> <87320ee5-8a66-6437-8c91-c6de1b7d80c1@amd.com>
 <Zn2GpHFZkXciuJOw@google.com> <30988934-c325-64eb-a4b1-8f3e46b53a55@amd.com>
Message-ID: <Zn2qSl2zAjCKAgSi@google.com>
Subject: Re: [PATCH v1 1/5] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com, 
	jroedel@suse.de, pgonda@google.com, ashish.kalra@amd.com, bp@alien8.de, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 27, 2024, Tom Lendacky wrote:
> On 6/27/24 10:35, Sean Christopherson wrote:
> >> The page states are documented in the SNP API (Chapter 5, Page
> >> Management):
> > 
> > Heh, but then that section says:
> > 
> >   Pages in the Firmware state are owned by the firmware. Because the RMP.Immutable
> >                                                          ^^^^^^^^^^^^^^^^^^^^^^^^^
> >   bit is set, the hypervisor cannot write to Firmware pages nor alter the RMP entry
> >   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >   with the RMPUPDATE instruction.
> > 
> > which to me very clearly suggests that the RMP.Immutable bit is what makes the
> > page read-only.
> > 
> > Can you ask^Wbribe someone to add a "Table 11. Page State Properties" or something?
> > E.g. to explicitly list out the read vs. write protections and the state of the
> > page's data (encrypted, integrity-protected, zeroed?, etc).  I've read through
> > all of "5.2 Page States" and genuinely have no clue as to what protections most
> > of the states have.
> 
> I'll get with the document owner and provide that feedback and see what we
> can do to remove some of the ambiguity and improve upon it.

Thanks!

> > Ah, never mind, I found "Table 15-39. RMP Memory Access Checks" in the APM.  FWIW,
> > that somewhat contradicts this blurb from the SNP ABI spec:
> > 
> >   The content of a Context page is encrypted and integrity protected so that the
> >   hypervisor cannot read or write to it.
> > 
> > I also find that statement confusing.  IIUC, the fact that the Context page is
> > encrypted and integrity protected doesn't actually have anything to do with the
> > host's ability to access the data.  The host _can_ read the data, but it will get
> > ciphertext.  But the host can't write the data because the page isn't HV-owned.
> > 
> > Actually, isn't the intregrity protected part wrong?  I thought one of the benefits
> 
> The RMP protection is what helps provide the integrity protection. So if a
> hypervisor tries to write to a non-hypervisor owned page, it will generate
> an RMP #PF. If the page can't be RMPUPDATEd (the immutable bit is set for
> the page in the RMP), then the page can't be written to by the hypervisor.

My confusion (ok, maybe it's more annoyance than true confusion) is that that
applies to _all_ non-hypervisor pages, not just Context pages.  Reading things
from a "the exception proves the rule" viewpoint, stating that Context pages are
encrypted and integrity protected strongly suggests that all other pages are NOT
encrypted and NOT integrity protected.

