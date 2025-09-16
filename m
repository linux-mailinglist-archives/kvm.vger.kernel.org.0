Return-Path: <kvm+bounces-57782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B596CB5A1B6
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 21:59:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD10A7AA0F9
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 19:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9DE22E424F;
	Tue, 16 Sep 2025 19:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u7lPfXRJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D772773F4
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 19:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758052777; cv=none; b=QgdRgNdmFNq0HhKWvNaAneFYPPj7RMogiyzV5PvXYdExBAWRYcHx7A1pY36Ymd7v+YO+XT5ZFF7SofLiEr9Hf5e0Bh+OLbi0aV+lq5pqvdBZe83PmAoTHMkpXmg8Y26mTyvKmZa+BjvgtqpUBHzMbetatTSWVvWk33+aaU5Ic1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758052777; c=relaxed/simple;
	bh=Vdu1BZwep+6IsmxierDdcJvK3W/IMo/wNXpYCrdmdRM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fuYy3+ByZcgN7m/8H6+h4engzMtW8ZIFE5wadSqoZxNpzvuKJoLKOGVtQ+m9y3dk4JXKLFzawD2ze+xActoJYFffQCts19ZnUbzpKc1RVqxTNQp9QmfYSZgua8hKx3WPRhZ1B4/wxvaeDxw2W1+3FABakc97PiLbvw786WNJwd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u7lPfXRJ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b522c35db5fso3882314a12.0
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 12:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758052775; x=1758657575; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fTTCcsDBpjW/mF3lSMHNghy/htFIT4NWUYSMKsa6IZY=;
        b=u7lPfXRJYT4xiNYWh0IS4nTB+M+0k/kuv92dLVKYvwabDWJDkCPkfq6PMk8NV7+Vce
         FmEEf0D4UOqhDzIIzyhEHfYhOzdgmIdDYdW3tQBIrF3BdX0LygeWW4oSdEF29uNOBsWp
         BVNCUfEiaxm7cMIZ7Ldnbgci2pHO3CkjlZnMqH95oC4gD7QTMsaqw46/I3QHYgWw53h4
         fd3R6m/rJLRO46xPakwvwN5a/TcbR+MSfMbbGHEVwz83rdfvVmffoCxeZdlVW4Jav3Yw
         ntwVieIfJalsfS2i4P9gQozkEefHaRpriPS0QLfBOhb/j5x97RO7SDkh2DCkJymAuiol
         SyZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758052775; x=1758657575;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fTTCcsDBpjW/mF3lSMHNghy/htFIT4NWUYSMKsa6IZY=;
        b=aNanpZ9/7b1fd5yzh8qVE543WslPX0ImUOByjhQNyLEG9mzmN6jDWgR40dyGC3495D
         1n+vsMQWoX4lpR+nug5z9FpMEBVuEciwAmKc1U3h60CJ7aRAVKCWe07iUNgVzsbQlbbP
         DqGIHZRTBcygkiA301LWth0nG55Y7yd/CWA14NofR9vOUAlVlvcMRS4epVImnBFJHwaw
         M9L2Em7eDwUzjlZV3mESExc81QT9mQ2G3kCgojy43cPe2VEE87/3CkQ5SvcJRV/CvEBz
         HtV0AdvndnOQGVAXei+OMC2dG4u0Snm467pKXiV/2mlWhbYJwoX1zqry1US7AGpT5tah
         nXmA==
X-Forwarded-Encrypted: i=1; AJvYcCWuwAKYiwXNqa37Oo4r0t+MF+sIpkPuSKBirJe7q+ObbhaztAjd5TTFzwNoA/YLMGheC2Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5SjD3ratuNDpsp+i4O0yAZLdnZofpZkt0X8ICQoAJWXwht1P8
	+1mU3+DQnK/beWZ/2mE3QpZ+1K/KD4LYepkMoiULY/8WzHQHgvgzMcZEmxT3jNf+pbYRJGS2o2X
	99GU1yA==
X-Google-Smtp-Source: AGHT+IEeOCLimp7Ef9XmIJDiwc7xsmOvJEWyAAUZvqolTLhCOh3V/BzP6YzcM++J0XFW+IbDbzqAEX2zdus=
X-Received: from pjbdb3.prod.google.com ([2002:a17:90a:d643:b0:329:6ac4:ea2e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:430d:b0:250:f80d:b334
 with SMTP id adf61e73a8af0-26027c13362mr22964220637.0.1758052774975; Tue, 16
 Sep 2025 12:59:34 -0700 (PDT)
Date: Tue, 16 Sep 2025 12:59:33 -0700
In-Reply-To: <2e0b5ee6-deae-4eba-89dc-4abfd63b1578@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827011726.2451115-1-sagis@google.com> <175798193779.623026.2646711972824495792.b4-ty@google.com>
 <2e0b5ee6-deae-4eba-89dc-4abfd63b1578@intel.com>
Message-ID: <aMnBpRnI4fNx390T@google.com>
Subject: Re: [PATCH v2] KVM: TDX: Force split irqchip for TDX at irqchip
 creation time
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Sagi Shahar <sagis@google.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 16, 2025, Xiaoyao Li wrote:
> On 9/16/2025 8:25 AM, Sean Christopherson wrote:
> > On Tue, 26 Aug 2025 18:17:26 -0700, Sagi Shahar wrote:
> > > TDX module protects the EOI-bitmap which prevents the use of in-kernel
> > > I/O APIC. See more details in the original patch [1]
> > > 
> > > The current implementation already enforces the use of split irqchip for
> > > TDX but it does so at the vCPU creation time which is generally to late
> > > to fallback to split irqchip.
> > > 
> > > [...]
> > 
> > Applied to kvm-x86 misc, thanks!
> 
> The latest one of this patch is v4:
> 
> https://lore.kernel.org/all/20250904062007.622530-1-sagis@google.com/

Yeah, I had applied v2 quite some time ago, just took me a while to do final
testing and send the "thank you".

> > [1/1] KVM: TDX: Force split irqchip for TDX at irqchip creation time
> >        https://github.com/kvm-x86/linux/commit/2569c8c5767b
> 
> What got queued, added a superfluous new line in tdx_vm_init()

Drat.  I force pushed to fix that goof, and added Kai's Acked-by in the process.

[1/1] KVM: TDX: Reject fully in-kernel irqchip if EOIs are protected, i.e. for TDX VMs
      https://github.com/kvm-x86/linux/commit/b3a37bff8daf

