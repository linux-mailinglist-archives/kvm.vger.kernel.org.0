Return-Path: <kvm+bounces-6367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8784482FE28
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 02:05:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19EC0286BE9
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 01:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 272D54A2C;
	Wed, 17 Jan 2024 01:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sHwMgMgi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1ED4683
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 01:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705453518; cv=none; b=OJcREofB9o7/YRca1PnJltR4q/sqiWIFEVQtJ4tDraSluPiamMZKB/ZSBIlOSTEitB6jZbo6+0aaFblNhzZpxcEoEipMtOOSKK3uNC5Z2HFXayPicmLCeN2tF9qAtN4VExEJJYUJ20a0/EkXC+3XVaCLgx5JJaoJ79ZER44WztE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705453518; c=relaxed/simple;
	bh=ivMZlPL10wMiuh5RI8lMpyWcINCSV4uJPhcMAtLj8Zw=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Date:
	 In-Reply-To:Mime-Version:References:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=H/yunnIad2L6mK/4c6mBGSFhXwTeCC+xIFkAHxNag+AQx/2wvrUeGUHzyAD0XYkIw8/MwgjGb3V1u/l0bwrPKJ+NcicRfV0X2sotD6656F8rcZ0Jq8LAeXFbN80nxmmedVBukqAQ9d00BK+iww0Bc8t6K3eI/OSl6mDlsMwmE3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sHwMgMgi; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6d9c7de0620so8954109b3a.1
        for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 17:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705453516; x=1706058316; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IKB8mSNKRsRlec2vx6K4+40UUB3h48mLOZFSolotTL0=;
        b=sHwMgMgiQ6ubuSV2pZE2qnFWzjAqY9ONUAFytbjm0J4ofFkzNfkmdd2PseZN7aHPql
         o6z0guX98Rc4gUFp+j1LLka7CzHupqMacCBIxsH/ctn3i54fGdw84ZO72Ee0cxiS7OnX
         6ugKrUz/wnFz27vNht5N3xtMkwlQo6LHs8uN8jj32HZNkg67Uv7qXgJZZdhYqsAYooKF
         6xYVaL1kw7Y3SMyn1R0bT1VSnLG2duBVO+tWNbWwP8pquchu3ny4bfhvrvhmwJb2HZ3E
         GvChz8EM1h6eiaS83jZz818PO5bJF3vL0VdgLWKG7m5BCTQv6TMsaKJ7WR9JSqg/gahF
         jBCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705453516; x=1706058316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IKB8mSNKRsRlec2vx6K4+40UUB3h48mLOZFSolotTL0=;
        b=UgA0iuKD9iSB5lcWI2R+TiabjXw4QwAniGdJIySgz2XnwAKuRqcHrF69Ha85UkfNCe
         hWvcL5x/6s3BY3au2rV5JQs+z1fcUDlXqgr8aMHtA0fy4e9JMa/0HJCdtAh2omh+eihC
         QkuNqynZ+6gb++srW9rQWvKW+r+Q0jrvPIjiIF50cmofju4Sd0UqeUEb042ZvTNtr7HT
         NAc54Y7qqeAhkrEnrRfoHIw0UBuPavOTDwxVPIeObZ9ami/+rzlEQAaXDcLGdXZeT6yI
         daHIBxWnWznjpOEAgfJeFPFmINyqg1HEQzocbky/TeFLh/YuFPwRGUxxmx+FJlE5EX7/
         E5Tw==
X-Gm-Message-State: AOJu0YyCd/iDV/uaIH0prf8UWCzJQK/2azltJjTwL7FMFX+lp9fKNvvE
	7Nq0VLjqcDDHuN7zXnZcs0ABylb8C3kvB9QUXEJZpJZ0IohYcNpReErr9rBO4NLxwaIuWGK1/HO
	ihQ==
X-Google-Smtp-Source: AGHT+IFoCXDD5PFg72UkfAOt6YI4Gjj6J6lS+S11t9VLKUwIvungIJioTt+tHYbdfewkkVWlaUPbt8PtnwY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8916:b0:6da:3fa7:d79c with SMTP id
 hw22-20020a056a00891600b006da3fa7d79cmr204pfb.1.1705453515949; Tue, 16 Jan
 2024 17:05:15 -0800 (PST)
Date: Tue, 16 Jan 2024 17:05:14 -0800
In-Reply-To: <bug-218259-28872-qkES9Kx8Zg@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-218259-28872@https.bugzilla.kernel.org/> <bug-218259-28872-qkES9Kx8Zg@https.bugzilla.kernel.org/>
Message-ID: <ZacnyvMmPS4m4SD7@google.com>
Subject: Re: [Bug 218259] High latency in KVM guests
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 16, 2024, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=218259
> 
> --- Comment #9 from Joern Heissler (kernelbugs2012@joern-heissler.de) ---
> (In reply to Sean Christopherson from comment #5)
> > On Thu, Dec 14, 2023, bugzilla-daemon@kernel.org wrote:
> 
> > While the [tdp_mmu] module param is writable, it's effectively snapshotted by
> > each VM during creation, i.e. toggling it won't affect running VMs.
> 
> How can I see which MMU a running VM is using?

You can't, which in hindsight was a rather stupid thing for us to not make visible
somewhere.  As of v6.3, the module param is read-only, i.e. it's either enable or
disabled for all VMs, so sadly it's unlikely that older kernels will see any kind
of "fix".

