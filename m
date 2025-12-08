Return-Path: <kvm+bounces-65518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D524FCAE65B
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 00:17:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E158C3020836
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 23:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3F12EA749;
	Mon,  8 Dec 2025 23:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jCS22SA7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC07242D9D
	for <kvm@vger.kernel.org>; Mon,  8 Dec 2025 23:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765235848; cv=none; b=h5q/3o846dl+VSkNxIYa4y6JJwZj7Sb4g0x7CbvoULg4Ffn8XRQ0mcErJpfUxvjdCEl831LJh/nv2WxAMRUT8UB5gyaWNWbnkjWfptCATD+WjI994zWk4lIiuE1aQOf9Ed0r2d/XqbFJsJxJyhInXARE/DXZvVhLrqWGmtAdLoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765235848; c=relaxed/simple;
	bh=hzoqkn8DRtGSQ9n26ZR8ioB/6vuZTI8jo81s+SZD2C4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=csayp6QrsWmRGC0xZmo/70JwJPcIrBmaPL3tmpFk8lWlSfoEYJMueMiDXCBRm6EQsEyzwRGG6M/zMRO+B2dZKk5mANaaZ058wmozgt9C4plxfRu/sYmewYlSg5tGwZfTnVprmvfTtXwu3Rb0IURTb5Iic6ZNELatZZuAGknAI4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jCS22SA7; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3438b1220bcso5498529a91.2
        for <kvm@vger.kernel.org>; Mon, 08 Dec 2025 15:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765235846; x=1765840646; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cni1OkdWwZPVVj0qFxlPetCrrcs1VWExpXG1dqivn9Y=;
        b=jCS22SA7hCDa6LczIsObShGOOa1o9wj/ETuSySWGxzmcFVz4xxUht3oZBdhXqXR0r5
         ao0PsKcknDJq42cEkv45DIdPPJb3TEDQmKeYdr0QQkgWcpjg8pWnRmNdaKdeL5ZTLqPP
         JyrlPIsBqiJ2iXhE+AchhNlaHe96qyXuqaUBlxL9wQEcSx6fCV9VIy1uCpxNptVRKVDr
         F+xmiisnjVQ6mXDWZ+P9i6TJXAdi4AbKViEX3ksyvBKljvOOVw7i9zRjlYayWs43vf2f
         gCOcVCrSNHfMNxAOlTIbqlDDrZbbqI+87ZijeUPf39YtoPmhEP9DY/Ok6Pe+4JW1xgwi
         DWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765235846; x=1765840646;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cni1OkdWwZPVVj0qFxlPetCrrcs1VWExpXG1dqivn9Y=;
        b=MnEF/fUT2GIExIx5Mb6soskj8eOjkzBBEspYR3vnbsEZp4KOmesjyBvTGF8pX0siKW
         jIZyvnOygFkFps9PAFEpfylTmxbffjGBe1WPgDrBlaMu5BTgoYzfqtrZxOHuei+5nFzz
         315352gxuNXVrnyhfQeL/xkoHBwQg5+6X0w3+zptpWNtukeVuAXd/WcS4KPGfCno5ROl
         qgeosrAjkR/AefV5s+hdO61oDORRIJXqxCVagPx7xdADcB6lploFEZ7/cqQianNUlRaF
         yZZrNlvr2UnapStlqSHyAeHhd3S2dwMltoEXPvOIbRTq133HbeM2d8EJpsaoK+pk3Q/1
         RWyA==
X-Forwarded-Encrypted: i=1; AJvYcCXM0Zo0exNqSlVvQB3EwWuskSA7pMZdfmUujokcNYliBMXL0PzsuG36ukoud4mgKYorWgE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxfF3nQ1vX91BRfsA5SQECje4hk6JK6aY3m42PXTS7j17nkI+4
	fAmHDMlBWW7ZnFWQykGgw0NPzpyrpBY0E5YE7zz+tYOlRr+A1/kgzT65QfSKbiOWJ2qO/ihOlWj
	6fNy+4A==
X-Google-Smtp-Source: AGHT+IHYtV9vc8av3yAHVyltMiSRqwP42w4ShmJsUWRWz6grAusj1twmP1ZR9qBB2t+PhOWUdJlv/v86tXY=
X-Received: from pjbgi22.prod.google.com ([2002:a17:90b:1116:b0:34a:49b2:8d33])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:558b:b0:341:124f:474f
 with SMTP id 98e67ed59e1d1-349a26c129dmr7076756a91.32.1765235846478; Mon, 08
 Dec 2025 15:17:26 -0800 (PST)
Date: Mon, 8 Dec 2025 15:17:25 -0800
In-Reply-To: <69352bd044fdb_1b2e10033@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206011054.494190-1-seanjc@google.com> <20251206011054.494190-4-seanjc@google.com>
 <69352bd044fdb_1b2e10033@dwillia2-mobl4.notmuch>
Message-ID: <aTdchSmOBo60vbZT@google.com>
Subject: Re: [PATCH v2 3/7] KVM: x86/tdx: Do VMXON and TDX-Module
 initialization during subsys init
From: Sean Christopherson <seanjc@google.com>
To: dan.j.williams@intel.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Dec 06, 2025, dan.j.williams@intel.com wrote:
> Sean Christopherson wrote:
> Given this routine now has nothing to do...
> 
> > +	 * TDX-specific cpuhp callback to disallow offlining the last CPU in a
> > +	 * packing while KVM is running one or more TDs.  Reclaiming HKIDs
> > +	 * requires doing PAGE.WBINVD on every package, i.e. offlining all CPUs
> > +	 * of a package would prevent reclaiming the HKID.
> >  	 */
> > +	r = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "kvm/cpu/tdx:online",
> > +			      tdx_online_cpu, tdx_offline_cpu);
> 
> ...the @startup param can be NULL. That also saves some grep pain no
> more multiple implementations of a "tdx_online_cpu".
> 
> Along those lines, should tdx_offline_cpu() become
> kvm_tdx_offline_cpu()?
> 
> [..]
> >  /*
> >   * Add a memory region as a TDX memory block.  The caller must make sure
> > @@ -1156,67 +1194,50 @@ static int init_tdx_module(void)
> >  	goto out_put_tdxmem;
> >  }
> >  
> > -static int __tdx_enable(void)
> > +static int tdx_enable(void)
> 
> Almost commented about this being able to be __init now, but then I see
> you have a combo patch for that later.
> 
> With or without the additional tdx_{on,off}line_cpu fixups:

I think the fixups you're looking for are in patch 5, "/virt/tdx: KVM: Consolidate
TDX CPU hotplug handling", or did I misunderstand?

