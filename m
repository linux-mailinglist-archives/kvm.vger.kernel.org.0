Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C89B2F1E23
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 19:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390147AbhAKShz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 13:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389472AbhAKShy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 13:37:54 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3D4C061795
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 10:37:14 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id g15so214373pgu.9
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 10:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pCOlRO55eXFQukgRUNBby75TymOdy5cq/jN7UKhXIac=;
        b=vm2LNexJa0GaiGIP/zgOeIfs0skXIM92P13a+f+s9HZM3ulZE8p27wxrVr2/hvKMOA
         2HVEwlJRAs5BzLnSsKHwEfIqDfF1bsUSnkTlFB3/Flla1ksUzRN6Vho3cO+1ttrfGB9S
         PJLeHGuYnlmg3+2mCgosX7i/nZzVdTJ9+07mAvHoBHmCrBOXBKWPtviTGbJoKoBGmUcA
         NFTY+uXYB4AeJkRrkfPZSb3dx9PveAUeDNqScMr/aj6xZ8Yu4tXW8fo8ZUtz0lCGxjj8
         zyl0oaj+FWTnqfJWYJgou4w/OZYSei2tM6/p3+O1UVsQ0EzJZ0/7AmMgLlCrF+hMvn1g
         2vZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pCOlRO55eXFQukgRUNBby75TymOdy5cq/jN7UKhXIac=;
        b=Uwb5Du/5bo9/G/1eUs1ZcrBKx3o3tsqFj748AgFlZgzl2TKcIYDbLe3ItkOCFuTVOQ
         zHky43GvaYkXPQD42SsOi2WOv1bP4l/seZFMFhjNLyxfdXulvX/4hzTEVJueHNIMJvtZ
         B9TaO10H40bkXSD83tv34ah8EXTRczgwV/zsboDHOEGFkEdSf7d5TJBidYDXd8PfsjKa
         Io4AZnGZO9niJmAKY9Ys1YVHgMFTubWrdOQb3DA1k5NAVK1OoEietJ2LDz8xal8nP0Ct
         lfld+QIvJ9qtIfV2Cz5q+7WPIb2ugtYZFTkZf+7jo4DVdFEhhDqXYgTBJAr3bi2o4jSl
         GVqw==
X-Gm-Message-State: AOAM532wAxdP46bycbs/bhiD7QVJ4K6ZBaC33o9FR6/YZ/UZtlEYXzDf
        SdfcljRUT6YudHCkMWMsRoGYjQ==
X-Google-Smtp-Source: ABdhPJyDkP5gaID6U6928S4cv3FLe7QxyIhXLPwbS6eW/UtvRY3u0QuUjdc96/aVTlE0RJmwX1iHYg==
X-Received: by 2002:a63:ec4d:: with SMTP id r13mr835054pgj.53.1610390233745;
        Mon, 11 Jan 2021 10:37:13 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id m4sm422919pgv.16.2021.01.11.10.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 10:37:13 -0800 (PST)
Date:   Mon, 11 Jan 2021 10:37:05 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, mattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Subject: Re: [RFC PATCH 00/23] KVM SGX virtualization support
Message-ID: <X/ya0XnsQn4xb/1L@google.com>
References: <cover.1609890536.git.kai.huang@intel.com>
 <2422737f6b0cddf6ff1be9cf90e287dd00d6a6a3.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2422737f6b0cddf6ff1be9cf90e287dd00d6a6a3.camel@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 11, 2021, Jarkko Sakkinen wrote:
> On Wed, 2021-01-06 at 14:55 +1300, Kai Huang wrote:
> >   - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
> >     just another memory backend for guests.
> 
> Why this an advantage? No objection, just a question.

There are zero KVM changes required to support exposing EPC to a guest.  KVM's
MMU is completely ignorant of what physical backing is used for any given host
virtual address.  KVM has to be aware of various VM_* flags, e.g. VM_PFNMAP and
VM_IO, but that code is arch agnostic and is quite isolated.

> >   - EPC management is wholly contained in the SGX subsystem, e.g. SGX
> >     does not have to export any symbols, changes to reclaim flows don't
> >     need to be routed through KVM, SGX's dirty laundry doesn't have to
> >     get aired out for the world to see, and so on and so forth.
> 
> No comments to this before understanding code changes better.
> 
> > The virtual EPC allocated to guests is currently not reclaimable, due to
> > reclaiming EPC from KVM guests is not currently supported. Due to the
> > complications of handling reclaim conflicts between guest and host, KVM
> > EPC oversubscription, which allows total virtual EPC size greater than
> > physical EPC by being able to reclaiming guests' EPC, is significantly more
> > complex than basic support for SGX virtualization.
> 
> I think it should be really in the center of the patch set description that
> this patch set implements segmentation of EPC, not oversubscription. It should
> be clear immediately. It's a core part of knowing "what I'm looking at".

Technically, it doesn't implement EPC segmentation of EPC.  It implements
non-reclaimable EPC allocation.  Even that is somewhat untrue as the EPC can be
forcefully reclaimed, but doing so will destroy the guest contents.

Userspace can oversubscribe the EPC to KVM guests, but it would need to kill,
migrate, or pause one or more VMs if the pool of physical EPC were exhausted.

> > - Support SGX virtualization without SGX Launch Control unlocked mode
> > 
> > Although SGX driver requires SGX Launch Control unlocked mode to work, SGX
> > virtualization doesn't, since how enclave is created is completely controlled
> > by guest SGX software, which is not necessarily linux. Therefore, this series
> > allows KVM to expose SGX to guest even SGX Launch Control is in locked mode,
> > or is not present at all. The reason is the goal of SGX virtualization, or
> > virtualization in general, is to expose hardware feature to guest, but not to
> > make assumption how guest will use it. Therefore, KVM should support SGX guest
> > as long as hardware is able to, to have chance to support more potential use
> > cases in cloud environment.
> 
> AFAIK the convergence point with the FLC was, and is that Linux never enables
> SGX with locked MSRs.
> 
> And I don't understand, if it is not fine to allow locked SGX for a *process*,
> why is it fine for a *virtual machine*? They have a lot same.

Because it's a completely different OS/kernel.  If the user has a kernel that
supports locked SGX, then so be it.  There's no novel circumvention of the
kernel policy, e.g. the user could simply boot the non-upstream kernel directly,
and running an upstream kernel in the guest will not cause the kernel to support
SGX.

There are any number of things that are allowed in a KVM guest that are not
allowed in a bare metal process.

> I cannot remember out of top of my head, could the Intel SHA256 be read when
> booted with unlocked MSRs. If that is the case, then you can still support
> guests with that configuration.

No, it's not guaranteed to be readable as firmware could have already changed
the values in the MSRs.

> Context-dependent guidelines tend to also trash code big time. Also, for the
> sake of a sane kernel code base, I would consider only supporting unlocked
> MSRs.

It's one line of a code to teach the kernel driver not to load if the MSRs are
locked.  And IMO, that one line of code is a net positive as it makes it clear
in the driver itself that it chooses not support locked MSRs, even if SGX itself
is fully enabled.
