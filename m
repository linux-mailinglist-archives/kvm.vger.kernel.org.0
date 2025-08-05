Return-Path: <kvm+bounces-53950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BFA8B1ABD1
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 02:48:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D2EB17C419
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 00:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 366691E5B62;
	Tue,  5 Aug 2025 00:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tPB1xKaH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BB71D7E42
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 00:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754354870; cv=none; b=mxirDUAuoQSAwUWoXcbnm/ag0JQqkcfRwqf1lsWVtBFc3XXaaHEX9DK7vA3Xl8gwAYEasuzFAxPZ83AdiHYq3xDE7RWlhDXfYvpesluy1KjUYRhvSKb3Y9KLr5/9mSCgqnMuji39sy5IvC1d9x/4RBXxmNrVHL0jrsagbAcXO1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754354870; c=relaxed/simple;
	bh=T8nD+fX6rDNRkCaFiQRFYPADN1FCVuJB1qjvodeEbJM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i5uP4ym1nCoSzXC/7+YmxwQdlXD2pYDVR4BD4JtDEHr4ii3j6E/cJJX+jSOrj22D3QsJ0z21zh4PxmmskTKSOGJGb1p+8R+fOHj+619FcRJ6xhPjshj1PmVz7puJY/ekgCVqRD4ETdbYT+5ibUZPPOHa66U2cGGJ+HW6xXWLz/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tPB1xKaH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3141f9ce4e2so6659713a91.1
        for <kvm@vger.kernel.org>; Mon, 04 Aug 2025 17:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754354868; x=1754959668; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cu8xPNeiA0Tn8TRzhuzSXVcIKY6L0tnmUlXuLitCJyQ=;
        b=tPB1xKaHRPUhnPmu9f8y86seEcb5SWa8bZY0AwvAygVyUqBmQ2qFoccZ4dOApsbu85
         NtCRnNODlb8J9Sy5AgxzIr6SfkDp+WvSaTe+fSIQ/goQFu8sFFSY2xkKsMdzJigg6h4N
         cmiUP5uUgCfeltJPa8IslyZmz4/DoqcoQrtqugAqZiXUH8+dx1ZybT6R7UWnMscj38s2
         qfnNFaR17O3sQlHsTTRs3EqzcYGgeBxD/MzaX6USWyVAtWDbRdd9CmXTh2nc2qAHZoJk
         2dgPBLHPlxsqsJM2fShatOdHi098AHTrmKUGLPcolEY2pGGDjvyDJUmQTE7NxB4x4HdF
         NuLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754354868; x=1754959668;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cu8xPNeiA0Tn8TRzhuzSXVcIKY6L0tnmUlXuLitCJyQ=;
        b=Ly0oyXjxkU/2RGVtTMAHlSv2aV6GjmLGIAhqSLGoNNW7xv40OR1Kui8yUdYk/8ViPU
         nnEbVxKDx82VmqkmmG3e3g1gYzaR0VMKa0Af7j2RjFcm6Qms/MKmi7e+A7rYGTATzOFE
         M8TfxwfcMydYQ6mPqUWEMy8n5n2CotSyWmzCqiiA8083MD8wFYqyxMwAxkiI9DiKAxnn
         AxXoBNDkHjmbP5n4Z8X8mAqIVUxBqzhQEsfWBbz47ejPsAgNfMsF2qQi4Z/xOnkexwa/
         7hqvV97NUQIDHggkweNEYrAJuQYLX4Ri+usrGSYBqtLahTqwOuNhTV8g3riN6NiwTYmq
         hYVA==
X-Forwarded-Encrypted: i=1; AJvYcCWa4A2mwltkSQCRmx03TB+SalFbpCfjPN/LvqVrlV5XP+v3LvK+2/PokUr054YTR27M6CE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMm80t30PBHp6Gp9HuXYxqyQHw4uPAEQY8EXxW2O0VZvlQHGpv
	HVP+bwjMJgviFwLQONI91aOwKnQA+hgDw4ohBVCHc9ObV+Z0NcHLLBK4wGkNmv+b4Zic22o8Yur
	wVBoGbg==
X-Google-Smtp-Source: AGHT+IEZYBSAKiguuNjj28l/9brar2wCZOQTwnXlJ0BcU5UbbgBHEEX5wjUA9Z/lzBYCbEZSZi06SPbrXHo=
X-Received: from pjf11.prod.google.com ([2002:a17:90b:3f0b:b0:31f:6ddd:ef5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c4a:b0:31f:11d6:cea0
 with SMTP id 98e67ed59e1d1-321162cc3d0mr16395187a91.27.1754354868127; Mon, 04
 Aug 2025 17:47:48 -0700 (PDT)
Date: Mon, 4 Aug 2025 17:47:46 -0700
In-Reply-To: <68914d8f61c20_55f0910074@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523095322.88774-1-chao.gao@intel.com> <20250523095322.88774-8-chao.gao@intel.com>
 <aIhUVyJVQ+rhRB4r@yilunxu-OptiPlex-7050> <688bd9a164334_48e5100f1@dwillia2-xfh.jf.intel.com.notmuch>
 <aIwhUb3z9/cgsMwb@yilunxu-OptiPlex-7050> <688cdc169163a_32afb100b3@dwillia2-mobl4.notmuch>
 <aJBamtHaXpeu+ZR6@yilunxu-OptiPlex-7050> <68914d8f61c20_55f0910074@dwillia2-xfh.jf.intel.com.notmuch>
Message-ID: <aJFUspObVxdqInBo@google.com>
Subject: Re: [RFC PATCH 07/20] x86/virt/tdx: Expose SEAMLDR information via sysfs
From: Sean Christopherson <seanjc@google.com>
To: dan.j.williams@intel.com
Cc: Xu Yilun <yilun.xu@linux.intel.com>, Chao Gao <chao.gao@intel.com>, 
	linux-coco@lists.linux.dev, x86@kernel.org, kvm@vger.kernel.org, 
	pbonzini@redhat.com, eddie.dong@intel.com, kirill.shutemov@intel.com, 
	dave.hansen@intel.com, kai.huang@intel.com, isaku.yamahata@intel.com, 
	elena.reshetova@intel.com, rick.p.edgecombe@intel.com, 
	Farrah Chen <farrah.chen@intel.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 04, 2025, dan.j.williams@intel.com wrote:
> Xu Yilun wrote:
> > So my idea is to remove tdx_tsm device (thus disables tdx_tsm driver) on
> > vmxoff.
> > 
> >   KVM                TDX core            TDX TSM driver
> >   -----------------------------------------------------
> >   tdx_disable()
> >                      tdx_tsm dev del
> >                                          driver.remove()
> >   vmxoff()
> > 
> > An alternative is to move vmxon/off management out of KVM, that requires
> > a lot of complex work IMHO, Chao & I both prefer not to touch it.

Eh, it's complex, but not _that_ complex.

> It is fine to require that vmxon/off management remain within KVM, and
> tie the lifetime of the device to the lifetime of the kvm_intel module*.

Nah, let's do this right.  Speaking from experience; horrible, make-your-eyes-bleed
experience; playing games with kvm-intel.ko to try to get and keep CPUs post-VMXON
will end in tears.

And it's not just TDX-feature-of-the-day that needs VMXON to be handled outside
of KVM, I'd also like to do so to allow out-of-tree hypervisors to do the "right
thing"[*].  Not because I care deeply about out-of-tree hypervisors, but because
the lack of proper infrastructure for utilizing virtualization hardware irks me.

The basic gist is to extract system-wide resources out of KVM and into a separate
module, so that e.g. tdx_tsm or whatever can take a dependency on _that_ module
and elevate refcounts as needed.  All things considered, there aren't so many
system-wide resources that it's an insurmountable task.

I can provide some rough patches to kickstart things.  It'll probably take me a
few weeks to extract them from an old internal branch, and I can't promise they'll
compile.  But they should be good enough to serve as an RFC.

https://lore.kernel.org/all/ZwQjUSOle6sWARsr@google.com

> * It would be unfortunate if userspace needed to manually probe for TDX
>   Connect when KVM is not built-in. We might add a simple module that
>   requests kvm_intel in that case:

Oh hell no :-)

We have internal code that "requests" vendor module, and it might just be my least
favorite thing.  Juggling the locks and module lifetimes is just /shudder.

