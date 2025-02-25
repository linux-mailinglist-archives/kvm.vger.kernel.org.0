Return-Path: <kvm+bounces-39158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B13A4489F
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 18:42:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC8D319E4AB7
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 17:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53C631A5BAC;
	Tue, 25 Feb 2025 17:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="22e4g97n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EED1A23BC
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 17:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504922; cv=none; b=Gm7Fy2Fj4KqrH/EtnMdXWLdV62XSQYmXTGl/57boaslrlUtVlieAnBXwYQaVugbgpYduBlj8b06ntRnY0JjQ5sdWunT2XvURfIsZYkzGtxY80oVlvmV6uW4ZZX0qW8vzoEW3lA3Mas3epGtvaxp6C/Vq7bDMkkvP+kC42q6miL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504922; c=relaxed/simple;
	bh=DCj+7jqMyXQfbY2xp2rvzhQWlsMYVO7zaB44y+WoB/4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QqQBKScq1YaLkb8PjnoZEAe8/fJwzbGUwvwW5J8jK1pNKX0omzrURrYYYJkt4MHBW/JnAXM38aZnJBuDHjt+ACnu/0KUiobjOw3hfmU16RVwDJisVSyC5Z18EESpWS8zhOeuFODS8S0fRq6MakcPIZBdWS9cvM5GMZQOO3sG5Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=22e4g97n; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2217a4bfcc7so124312035ad.3
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 09:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740504920; x=1741109720; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WmPVK+L+lkct4my4gWXOH7349iAbiLDSdgIlILE/gx4=;
        b=22e4g97neCm8yw41ONcrauyntt+5VswzU5AUngctfJ9y4Nn78LKP3UqO/0mWFyIxxh
         o2Tldizy34LiAEkUavi0Ifsk3d6XaTSeklXAYYGIrWReaTFoVhtJwI3hdbqQxhipLdP3
         x/rpo2ods/7KkAuE2ApAF5AVtWRB3wrmlweiW3Mecn2fjzibvkXulqnu2v154hKllWlh
         GpmLk2FMgZ/Gp8mHT2DLysr53QuOvp8p1QVQF/6D6hOrvu6R7B7nC2lSEVmxEud9ERdg
         8mUNOUNLrGOZft90LXZ53PQnSrsAWkPigAlgwInZEH+AysL0Q1W6f5j4B49nef3vG9zK
         A82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740504920; x=1741109720;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WmPVK+L+lkct4my4gWXOH7349iAbiLDSdgIlILE/gx4=;
        b=h/Srbp4fJmCuNqzQnqRXRo2yQRgaNh13dl8XWjHjSFYC1REGDuK2gq7MwHyPZVJk/q
         MtEwqmxGf8Mzq3R1l8pqryu3/l8Q6bFbtvN2K9hdr/oyyrUrKcGCNreFq2Z2B8sfWyR8
         rSG6MTz5XiIspbR8LsAcOPGSEd+3WWhnvsKEHtgAisN56uRJiSDVLurQ8rl7MGtVkMKa
         PLC9MnKonb0XM9dxnkO1aDHcQQkwX4eN/lpIPXfVxU4OTTbeDMjDqg8tWbLX8uhIw+nX
         y/oni81wrvCuOz2DXZERYKiNJbLQf1DOYpXGLhYLCfw5A7pWU6z+xET1RDAVXkvoa5g7
         PPuQ==
X-Gm-Message-State: AOJu0YygHcSsPRQaX8aavUeQLJB3sxlxDAJo87TrlBFn82UsOv1pSgar
	gD1Tk4eB2lJ/xZkEfEnWW4SVKnhgl9fQqrEx8Wr+DsQT/kf02r6WBw4C4/kw8pPIo/Z7A4HtlJq
	ECw==
X-Google-Smtp-Source: AGHT+IHDF07aCt7qpFwpvTs1RpT9A9C3sPRgbFPhlXEj6AO9EgopLjMJSD4qeqFfHqD0Sv4+QnSbcOjcYsQ=
X-Received: from pjbqo14.prod.google.com ([2002:a17:90b:3dce:b0:2fa:a101:755])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d506:b0:216:501e:e314
 with SMTP id d9443c01a7336-221a0edda05mr242845745ad.20.1740504920269; Tue, 25
 Feb 2025 09:35:20 -0800 (PST)
Date: Tue, 25 Feb 2025 09:35:11 -0800
In-Reply-To: <b1f0f8f3-515f-4fde-b779-43ef93484ab3@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241001050110.3643764-1-xin@zytor.com> <22d4574b-7e2d-4cd8-91bd-f5208e82369e@zytor.com>
 <Z73gxklugkYpwJiZ@google.com> <b1f0f8f3-515f-4fde-b779-43ef93484ab3@zytor.com>
Message-ID: <Z73_TwUgIsceWyzQ@google.com>
Subject: Re: [PATCH v3 00/27] Enable FRED with KVM VMX
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com, 
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 25, 2025, Xin Li wrote:
> On 2/25/2025 7:24 AM, Sean Christopherson wrote:
> > On Tue, Feb 18, 2025, Xin Li wrote:
> > > On 9/30/2024 10:00 PM, Xin Li (Intel) wrote:
> > > While I'm waiting for the CET patches for native Linux and KVM to be
> > > upstreamed, do you think if it's worth it for you to take the cleanup
> > > and some of the preparation patches first?
> > 
> > Yes, definitely.  I'll go through the series and see what I can grab now.
> 
> I planned to do a rebase and fix the conflicts due to the reordering.
> But I'm more than happy you do a first round.

For now, I'm only going to grab these:

  KVM: VMX: Pass XFD_ERR as pseudo-payload when injecting #NM
  KVM: VMX: Don't modify guest XFD_ERR if CR0.TS=1
  KVM: x86: Use a dedicated flow for queueing re-injected exceptions

and the WRMSRNS patch.  I'll post (and apply, if it looks good) the entry/exit
pairs patch separately.

Easiest thing would be to rebase when all of those hit kvm-x86/next.

> BTW, if you plan to take
> 	KVM: VMX: Virtualize nested exception tracking

I'm not planning on grabbing this in advance of the FRED series, especially if
it's adding new uAPI.  The code doesn't need to exist without FRED, and doesn't
really make much sense to readers without the context of FRED.

> > > Top of my mind are:
> > >      KVM: x86: Use a dedicated flow for queueing re-injected exceptions
> > >      KVM: VMX: Don't modify guest XFD_ERR if CR0.TS=1
> > >      KVM: VMX: Pass XFD_ERR as pseudo-payload when injecting #NM

As above, I'll grab these now.

> > >      KVM: nVMX: Add a prerequisite to existence of VMCS fields
> > >      KVM: nVMX: Add a prerequisite to SHADOW_FIELD_R[OW] macros

Unless there's a really, really good reason to add precise checking, I strongly
prefer to skip these entirely.

> > > 
> > > Then specially, the nested exception tracking patch seems a good one as
> > > Chao Gao suggested to decouple the nested tracking from FRED:
> > >      KVM: VMX: Virtualize nested exception tracking
> > > 
> > > Lastly the patches to add support for the secondary VM exit controls might
> > > go in early as well:
> > >      KVM: VMX: Add support for the secondary VM exit controls
> > >      KVM: nVMX: Add support for the secondary VM exit controls

Unless there's another feature on the horizon that depends on secondary exit controls,
(and y'all will be posted patches soon), I'd prefer just grab these in the FRED
series.  With the pairs check prep work out of the way, adding support for the
new controls should be very straightforward, and shouldn't conflict with anything.

