Return-Path: <kvm+bounces-52509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A18FB060F3
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 16:27:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E08EC1C4732C
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 14:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E187C289375;
	Tue, 15 Jul 2025 14:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PKHqa6ms"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB892857DF
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 14:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752588426; cv=none; b=O3OWzCBNsDzAQHpOAbviOgkEjrjIgleTllO5Ohz6kEaRDYQrPsk6wYP6DQgtNVdp+0ea/gT7qlgVrW0YwGdgNQxEqC0YoNX8UpYkqHIsVH/gjtnUUhbw6vFtmEHFv7gwjxVinswnQEPKxyfFAcJ81eq81OsOZjLCS+7GGnZDHM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752588426; c=relaxed/simple;
	bh=L86prP4TTPqpMQIoLPMaLq7KqiWjNJGxwzMCThgDnDg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pLLJr2frcURnIyZ+HBfeypWpiAPXN5Ylp5TFuNnLwSayKQkC2jdGpRCZ6P3QKa/yVRkrLxMiasLtj0JezUuUUkm3snvWYIA7GZywg+cA1/LV5ZQIYx0RclIZ7KTaTW1mcZTcv/ZXY7+dPKPF/pv95UWu+jQ99lw7oYi5393xrYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PKHqa6ms; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3138e65efe2so5389998a91.1
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 07:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752588424; x=1753193224; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cQnNGUtBGDZserhnvy1Sw3vFLWuIiTqycwu8w/nJ2jo=;
        b=PKHqa6msQMhqZ9g5dX1dt54/3J4BbyRdQAOFnCmd/G5vmMveVkykremrnyPcNWNOih
         RROsq0MlzZr82oyBzZdYGA7OLQFO/tt4fsZVW0yoxZvUFcmBvCNwI47Bnnvr010Vs9du
         MN2x6RjwmYBz2QnRIPFmfyqF1exuZYgjtyaTCrb89+Bch7R+I7Xu0kVafjA02oKnYJl+
         znZLKoZZkQQ7BHyvWNCTmsWsfqNxzfdwIe1KhXOFyLHMLF2tkoRDdf5NehZ56PmQbM84
         DoOU2FYzQanosb9Sc0dVIm+c10HtQkv7zWcoaoZ7FNu4J6v4o7mskYurRQ+IEqzIMaEb
         v6YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752588424; x=1753193224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cQnNGUtBGDZserhnvy1Sw3vFLWuIiTqycwu8w/nJ2jo=;
        b=MifejDsUca0mKzozLXXsi+aIGJwjMgmOd/MI+aauY+dhy8eZB7TxN7ECYRSMi99wTD
         pK6VrIBAmNwNiU2JhfbYmE50uaJCcCItY3H4RCMv9PI/buBA3zwuwDO0r2FZP3ENGtQr
         BaArecx5nk9sz0xv9rwEPUv44sQVjPGFnTw2uqT5M4Cf2V+Otxt80sl2XtIcnigSV0L4
         1XuQqv29uFBTVgUtkDg/Jgf2FbHOCI0POZ+ZswjS+Se/ShKjTy5pex/zXG+Qu4qpor/2
         tHOESzJE0vlE64qLwmCHVM1zSNSVPgJb/R+PShkIbAOg/HAwNDa+n1p+8bX6NzHPdWx2
         iqrA==
X-Forwarded-Encrypted: i=1; AJvYcCXR4z2jvfnfZtKKKuTp/8ggjbOCV2pwr1GIABhjE0NRH8qR9PbeHcrd9uqta5sJgEJS5Is=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZQhSan9dLBFh14BR4cCfbOheQLVLi9SdDUf8Yqd5TpQrf5b0z
	ZtLiZ717BDEVLm3XkEmvo0kkzCaTwVcBRewAkZvyaCKOZ8WvGeDQnfHPczwi7X1fjrAtgMdaSJI
	MPApgUA==
X-Google-Smtp-Source: AGHT+IHBTffReyder+/OKTtAFTslpuPttL+P7LuXHQUtEw62s0DpqUK5B296RLS9f/DVP56Fnx92h7AVsjQ=
X-Received: from pjh16.prod.google.com ([2002:a17:90b:3f90:b0:31c:2fe4:33b5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:528c:b0:313:287e:f1e8
 with SMTP id 98e67ed59e1d1-31c4ccbc93emr27660997a91.8.1752588424051; Tue, 15
 Jul 2025 07:07:04 -0700 (PDT)
Date: Tue, 15 Jul 2025 07:07:02 -0700
In-Reply-To: <e1151fff87e0f0f26462fed509a41916dd6ba8e7.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1752444335.git.kai.huang@intel.com> <175253196286.1789819.9618704444430239046.b4-ty@google.com>
 <e1151fff87e0f0f26462fed509a41916dd6ba8e7.camel@intel.com>
Message-ID: <aHZghtaRrcfX7p5d@google.com>
Subject: Re: [PATCH v2 0/2] Improve KVM_SET_TSC_KHZ handling for CoCo VMs
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, Chao Gao <chao.gao@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, "nikunj@amd.com" <nikunj@amd.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 15, 2025, Kai Huang wrote:
> On Mon, 2025-07-14 at 17:23 -0700, Sean Christopherson wrote:
> > On Mon, 14 Jul 2025 10:20:18 +1200, Kai Huang wrote:
> > > This series follows Sean's suggestions [1][2] to:
> > > 
> > >  - Reject vCPU scope KVM_SET_TSC_KHZ ioctl for TSC protected vCPU
> > >  - Reject VM scope KVM_SET_TSC_KHZ ioctl when vCPUs have been created
> > > 
> > > .. in the discussion of SEV-SNP Secure TSC support series.
> > > 
> > > [...]
> > 
> > Applied patch 2 to kvm-x86 fixes, with a tweaked changelog to call out that
> > TDX support hasn't yet been released, i.e. that there is no established ABI
> > to break.
> > 
> > Applied patch 1 to kvm-x86 misc, with tweaked documentation to not imply that
> > userspace "must" invoke the ioctl.  I think this is the last patch I'll throw
> > into misc for 6.17?  So in theory, if it breaks userspace, I can simply
> > truncate it from the pull request.
> 
> Thanks!
> 
> > 
> > [1/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPUs have been created
> >       https://github.com/kvm-x86/linux/commit/dcbe5a466c12
> > [2/2] KVM: x86: Reject KVM_SET_TSC_KHZ vCPU ioctl for TSC protected guest
> >       https://github.com/kvm-x86/linux/commit/e51cf184d90c
> 
> Btw, in the second patch it seems you have:
> 
>   Fixes; adafea1 ("KVM: x86: Add infrastructure for secure TSC")
> 
> Shouldn't we follow the standard format, i.e.,
> 
>   Fixes: adafea110600 ("KVM: x86: Add infrastructure for secure TSC")

Ugh, yes, the semi-colon is just a typo.  New hash:

  https://github.com/kvm-x86/linux/commit/b24bbb534c2d

