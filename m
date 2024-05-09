Return-Path: <kvm+bounces-17139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A968C199B
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 00:53:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27AA11C21917
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 22:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 815F4129A6F;
	Thu,  9 May 2024 22:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lbA9rSby"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A236D12D76B
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 22:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715295185; cv=none; b=aq7WiJ8mYN2v3gJoqlUgnKOZoTKmA4rpiwgiyZtar2VAsRy+FV/9MY0GGLs8P9CZm5G12YxexhMpKvutdtN6xLcXAJMkXWP3jp2ExRL6Pax2wgDBDSHo9RaEBtSHckVt+UEyxwH0VCTPIVZX4CYlU3TrYLWmB0IWHbmB+re71U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715295185; c=relaxed/simple;
	bh=ckYw/fPw8cWuIIDpNf0IHTJPYm/aVSFzE+XL4Y6KroU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vbe4FuOBJRCSEMTFckA4051Ml9xcKTGmB/PR/XfEnwcC/ZZIiLff69Dy8P+6tzlCjo6fdl7fl1sGXnzYNzaYbk5SbblhZTKcyQiaIuJnVejH8c+j0yNzqxsB8tzkkwMmqKcNxShQBCCPfdznfQyvLW6wZnslGhO3oEOCO/wyeuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lbA9rSby; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61bb09d8fecso25021157b3.0
        for <kvm@vger.kernel.org>; Thu, 09 May 2024 15:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715295181; x=1715899981; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4ME9lJAyFxkTypmVhuXddPd71uqtDTvwVdbPhhkE/e0=;
        b=lbA9rSbyzy2PIdwy/vfC3n/t52/iwGRLJu1WIdUfI15uZP/COYHH4gVERHgRqoUmAG
         YjuX0xPXQUJ4crWBpHusszKQlFHyd2Nv1noSznZVadZpR2YjYFEZt5QknQd4/uLfohO+
         ycJkDE3Oj4McIuIfqHh0H+6xMkq0Xtl4H3drqv9Y6NTUKDK3q/gUoiqjp+mZxNfXBiDm
         Gq8RoOGOK9oPPiSG++okJ58mKtft3FBAOnjOmSRNHM+Mx4Lwf57zNmwB83+7rbsGug1t
         B24+ljkLPqH3YnpnoI2nZgoypidF5jztIDOFtvy0r8zPRsFWeZjl42xUFQ6zoutRXaFM
         o3MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715295181; x=1715899981;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ME9lJAyFxkTypmVhuXddPd71uqtDTvwVdbPhhkE/e0=;
        b=M6PSO2VRr17JymsO5C56gr1bNJ03sW/h+/7VPk3yuGlUwDSveFAV6HUaTMPr4D726p
         o5vDe0+RfAoh9vA6ZrEswUsQ/lFCRJRYJ1k1DNOjkoI2VXm7vmiVIrGDPyyjvvHKEQlF
         YY06iRKpyE7QZFGMmI3eAZGeu4SRnZfVzt6dWXibotyiez95UJcITcDAX2jcEwXGGhtR
         eWnHJv3Ut0Yj0Sbv9NoIta3j7TCAp4G1UPYAqoqqp2p4bOOFc+BRMg8n+CuF2NIXqDZJ
         MELxubcchvLAbaIV8Rh610apq/oUWsPcj1xmKDf5nh7FHgACwK9B0LPaEljGSKBJMCsL
         K5kg==
X-Forwarded-Encrypted: i=1; AJvYcCViR3JRpq3x5Fb3A0hqOAu9xpbFCFG5S/21DsY6VQLqB8Wp4VVjkB/IMwg0rF0Ti6n0skN+tR76LMlQrF78gfLgbdHX
X-Gm-Message-State: AOJu0YyNqZNo3qkY3eeGL8kMYq0QfuD7c7eva3naBIK2UCjPcPXDZcHT
	3oQSHYF6f3SYgz/HlgaRIIXe1jKB5Li+xhEjdrY3LJARTKkBZisAHPzg5Rd9aXIc4DHtR9MUIIY
	XQw==
X-Google-Smtp-Source: AGHT+IHXr0Ip/gr6px7u8Lg8iBTMhb3wftkpSHicRh3tOfJA2tQ77XzCrUEIalKFLIbFCTu3T9uH74i0hXc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6010:b0:618:876d:b87d with SMTP id
 00721157ae682-622b013431emr2114887b3.5.1715295181353; Thu, 09 May 2024
 15:53:01 -0700 (PDT)
Date: Thu, 9 May 2024 15:52:59 -0700
In-Reply-To: <5ba2b661-0db5-4b49-9489-4d3e72adf7d2@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
 <Zjz7bRcIpe8nL0Gs@google.com> <5ba2b661-0db5-4b49-9489-4d3e72adf7d2@intel.com>
Message-ID: <Zj1Ty6bqbwst4u_N@google.com>
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend specific
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, Sagi Shahar <sagis@google.com>, 
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, May 10, 2024, Kai Huang wrote:
> On 10/05/2024 4:35 am, Sean Christopherson wrote:
> > KVM x86 limits KVM_MAX_VCPUS to 4096:
> > 
> >    config KVM_MAX_NR_VCPUS
> > 	int "Maximum number of vCPUs per KVM guest"
> > 	depends on KVM
> > 	range 1024 4096
> > 	default 4096 if MAXSMP
> > 	default 1024
> > 	help
> > 
> > whereas the limitation from TDX is apprarently simply due to TD_PARAMS taking
> > a 16-bit unsigned value:
> > 
> >    #define TDX_MAX_VCPUS  (~(u16)0)
> > 
> > i.e. it will likely be _years_ before TDX's limitation matters, if it ever does.
> > And _if_ it becomes a problem, we don't necessarily need to have a different
> > _runtime_ limit for TDX, e.g. TDX support could be conditioned on KVM_MAX_NR_VCPUS
> > being <= 64k.
> 
> Actually later versions of TDX module (starting from 1.5 AFAICT), the module
> has a metadata field to report the maximum vCPUs that the module can support
> for all TDX guests.

My quick glance at the 1.5 source shows that the limit is still effectively
0xffff, so again, who cares?  Assert on 0xffff compile time, and on the reported
max at runtime and simply refuse to use a TDX module that has dropped the minimum
below 0xffff.

> And we only allow the kvm->max_vcpus to be updated if it's a TDX guest in
> the vt_vm_enable_cap().  The reason is we want to avoid unnecessary change
> for normal VMX guests.

That's a frankly ridiculous reason to bury code in TDX.  Nothing is _forcing_
userspace to set KVM_CAP_MAX_VCPUS, i.e. there won't be any change to VMX VMs
unless userspace _wants_ there to be a change.

