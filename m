Return-Path: <kvm+bounces-14669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F768A55C6
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 16:58:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A43E71F22FF0
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 14:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02530757E5;
	Mon, 15 Apr 2024 14:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t6DGZXBC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F31C60EF9
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 14:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713193104; cv=none; b=M+e7OEDf67CNhRAmGeTfR9qQfEavnEj0Jo04e4O6Vv7b1nigv2xQ8P3sceeUOjfHue/ucUMfpigVxWogRnnr98SADubsi8C1Ok3u2U2NkcJr3N7442opSVhMgdf4jez3HCN81lT8ipGGk7R0FDXNbSFXADbupCOceuoKlKQFHjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713193104; c=relaxed/simple;
	bh=2AYn/bmQeIzj6ulftp9H24+jIaZlPwCEpI/YcE8pXts=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iCLl7mRK0uw4hPIMie/TOSfw04q0VsmyOttknm+Dn+s/Ri8YklpAOojpvrVeh+4aLvSqYgUT1/Yz1r5XtCvsNVedTKUg4ZOQLzFoSH2l5Rk3GBd+QEOLCumuJCoNsE1teTBkz5Rs7tNP2Q+xsFauzMIst88USE3gnH4zdsAUf54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t6DGZXBC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e5e5fa31dbso20132385ad.0
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 07:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713193102; x=1713797902; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IZNUm4Db7gXwKkeQwn/hIy/lkUEbm0FeK/51upL4Sbg=;
        b=t6DGZXBCKRdLr8UlCxk6NUdn2f7DCNxfNWfEVtcafseU3mh+srbgG3uaHt4kkaSvg5
         PV2tFr5SZ7rBg3bDO4HQV0UXu5r4Qbm4pF4REC8SBM1AyAZDOjDRkuCrAcsHWLJcX1Cq
         NCZ9NqQr66KIL8WvewvpIj4FDnwID9vJoiUs/qXdmNLY9SvJGgQlNLuwwHNhCIU45+rH
         F1FCpUdScUNAQss7arPEPFDM0MhvXf3vysrbt94oUXJF9ys8dLhP/rSrS7/ZhiKURPo6
         O30+r+PF/8RiVuKS5/Crq1LxAhhS1NhPZ0MiAcfpv5MaEHqt1h6VxplEDC2xi5ga6BQQ
         XX/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713193102; x=1713797902;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IZNUm4Db7gXwKkeQwn/hIy/lkUEbm0FeK/51upL4Sbg=;
        b=h2GIW+g+uqkwOFeSofJgDBLqn4NUKC33CQSSVapnloIZX5ACF6bXXnY+lv9637KIhw
         WHZfq+SEwcDlYJ2YIVydBhMGfUIVC2o4FQ7gi5YL9XeXyxdcaDArh6t7BjOioqzkLtF/
         33P6Pxpff8RE50/+wZHnQGbQ6lxHQWM18pIcf1NHbr4y9mZfgNSR8b53WWSiD7uwnSwz
         bTfnk7D5jQgT3y36Cc4RZtlm4JxKbbPX7ZtJR5VyK+pW6JZvjFZGDIwqfY3BFpY3uUex
         NHogiEfJL/hUM2x55InUItz9zQ72RsZm7pfBAbvgLEiiPivnfddsIy5TSY0kHo9eIHkv
         7X5A==
X-Gm-Message-State: AOJu0YwxXmEEcikfxU05mSIp5cBAZDONqqZkNXN2KDSxxXB3SYAEFNmj
	HvxJ1yda0Uzj2UU0PaJY65+nHL65/Rb9KVVXP+CPMdryfQSKfuz0NaCNTsepxwrdEgnviVoweMt
	+pg==
X-Google-Smtp-Source: AGHT+IEvHQs7kjxv+HTgyT2pDkZQVHAKuYQQBD8pMwSGui9CWOAcn97/q2lyUG02lxRqtnhgbRT5WRnRWew=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c5:b0:1e4:32ec:ce5d with SMTP id
 o5-20020a170902d4c500b001e432ecce5dmr252776plg.0.1713193102333; Mon, 15 Apr
 2024 07:58:22 -0700 (PDT)
Date: Mon, 15 Apr 2024 07:58:21 -0700
In-Reply-To: <627a61bf-de07-43a7-bb4a-9539673674b2@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240313125844.912415-1-kraxel@redhat.com> <171270475472.1589311.9359836741269321589.b4-ty@google.com>
 <afbe8c9a-19f9-42e8-a440-2e98271a4ce6@intel.com> <ZhlXzbL66Xzn2t_a@google.com>
 <627a61bf-de07-43a7-bb4a-9539673674b2@intel.com>
Message-ID: <Zh1AjYMP-v1z3Xp2@google.com>
Subject: Re: [PATCH v4 0/2] kvm/cpuid: set proper GuestPhysBits in CPUID.0x80000008
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: kvm@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 15, 2024, Xiaoyao Li wrote:
> On 4/12/2024 11:48 PM, Sean Christopherson wrote:
> > On Fri, Apr 12, 2024, Xiaoyao Li wrote:
> > If we go deep enough, it becomes a functional problem.  It's not even _that_
> > ridiculous/contrived :-)
> > 
> > L1 KVM is still aware that the real MAXPHYADDR=52, and so there are no immediate
> > issues with reserved bits at that level.
> > 
> > But L1 userspace will unintentionally configure L2 with CPUID.0x8000_0008.EAX[7:0]=48,
> > and so L2 KVM will incorrectly think bits 51:48 are reserved.  If both L0 and L1
> > are using TDP, neither L0 nor L1 will intercept #PF.  And because L1 userspace
> > was told MAXPHYADDR=48, it won't know that KVM needs to be configured with
> > allow_smaller_maxphyaddr=true in order for the setup to function correctly.
> 
> In this case, a) L1 userspace was told by L1 KVM that MAXPHYADDR = 48 via
> KVM_GET_SUPPORTED_CPUID. But b) L1 userspace gets MAXPHYADDR = 52 by
> executing CPUID itself.

KVM can't assume userspace will do raw CPUID.

