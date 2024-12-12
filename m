Return-Path: <kvm+bounces-33651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D32009EFC21
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 20:13:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9AEA16DE45
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 19:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2792192D97;
	Thu, 12 Dec 2024 19:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ixEg3g7P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7817618CBFB
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 19:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734030797; cv=none; b=NhJz6ZHhcv6DbPb+E0fiFQPALlk8g1GIvEGtzVSMWN7L7kdAlkYvvEhpKBeB2qe99tdM4kpPBJOrl1RnwXCvsbwQFQR2rN36q5ybKaALUNdODL7BX63/a8MoadPgIPDeXlZd6mXtIsWNbsvIlLpVCituceMjdkxTrRMDJ0muuz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734030797; c=relaxed/simple;
	bh=OR5qLSn+wc7FwtEPCIKipiQCdjlZ5Ii4hLOIczGh+Ng=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YL5TjDT2CZC2JIfUv8uIwL7KEuUm2+k/AmZbmmiFQCnA40rxT5m+rdIfVL4tEmx0QLMn/T5Il+wKw1lFFbivgGR6gLr4WsNHupNvzBVMaUW3aRgpO+hZ6Z2VDg8TFSjo1Oufmo14H3v2BxRgXwro+gCT+8oDhpcufJz9ggmW6gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ixEg3g7P; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-728ea538b52so1383431b3a.3
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 11:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734030795; x=1734635595; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6ftIVrUurcXgbz47VOJZBrN/RkIsB3yO2o5gVSwEAPY=;
        b=ixEg3g7PJ6dNP7OjZRGo2DemZOzwMXyonOCfdw50LkeKSuWWESbO0Bfc8fPxH+6jn3
         0qqN1getu6SN50PZ8R9+ije3v1Om5JrnMHE6zf09lW/slJNQAWJHotw79MEvai5mN/rD
         cv4IUzBN+sMZxd52ZNyPPp2IvrxIRH9nzJARM+W5bR14J3BdYoWV9wwByJFKdu9Eb+/L
         WTKRkpogbUYx63Rm8J3CRJ6ZIS61cRPE1u7rx0nuxQ0LZLGoGooXH6hloZRXpxdxqwjz
         4M0FYvDZQ6uayyFAL5aUb9+X2WuCTw4PZy8eLU0hb/SrMcge/FRZ6qC7bZjkE5HreMLz
         2FzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734030795; x=1734635595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ftIVrUurcXgbz47VOJZBrN/RkIsB3yO2o5gVSwEAPY=;
        b=cDDNJiFarZZ6xY38rA1bJ5ywlBCUw6EajTxUgQYrPArJsXTjYJ90IPSkX8n/6UoXP0
         OGLbFs0Ex04GKo5LBdypxovQK+1Zh8rgqFaXKgaBgmnKhN7xwCr0nhhK4ssXsFtVEX0Z
         bhQV9HzRxhmlyk+/aQbxSQGRA6emgj/yB0mtEfsB5fDTx7aoH07KxRkGZVcA5n1Hf7i5
         BE1qVIwpLs8NahSUI4zeEzaD6xf0a2qpKe+lm5BjKIUCPs+pN+acLpbJSED4gzYpZyFF
         htGbAfOZQAkjlJz9LGkkiK/30Zr4NQSWwtL1jQSI8Ad+qtXr6TQwo/8tC6PWtu7wXyYi
         maWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKk/UYZAl7Q/VaPXTYuyoj6+/x+i8KriPPxDSgTJGuZbVSWLdJMOETk9De8kX+ErfdiCM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEr5XaxdDbl8obB4BMp1ImQpdKPPeEJA2sY7zFlKMfuuurpF8M
	WOMDBMvrN9tMKtIY22896reSTI74PFtqZINnCVqIQnY37ZiMaDqP/QxEGY6mn+bi8bqZLcLK+12
	U6Q==
X-Google-Smtp-Source: AGHT+IF/aSjkRAiUPE7prVrWmTY9lJSRlT0SoFYjGPreKIZ7z0XPtDKtWZqE+xUKFKN++gtnigcObWThIsU=
X-Received: from pfvf8.prod.google.com ([2002:a05:6a00:1ac8:b0:725:d24b:1b95])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:84c:b0:725:eacf:cfdb
 with SMTP id d2e1a72fcca58-72906f4b6demr2262010b3a.24.1734030794662; Thu, 12
 Dec 2024 11:13:14 -0800 (PST)
Date: Thu, 12 Dec 2024 11:13:13 -0800
In-Reply-To: <1a5e2988-9a7d-4415-86ad-8a7a98dbc5eb@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241212032628.475976-1-binbin.wu@linux.intel.com>
 <Z1qZygKqvjIfpOXD@intel.com> <1a5e2988-9a7d-4415-86ad-8a7a98dbc5eb@redhat.com>
Message-ID: <Z1s1yeWKnvmh718N@google.com>
Subject: Re: [PATCH] i386/kvm: Set return value after handling KVM_EXIT_HYPERCALL
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, xiaoyao.li@intel.com, 
	qemu-devel@nongnu.org, michael.roth@amd.com, rick.p.edgecombe@intel.com, 
	isaku.yamahata@intel.com, farrah.chen@intel.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 12, 2024, Paolo Bonzini wrote:
> On 12/12/24 09:07, Zhao Liu wrote:
> > On Thu, Dec 12, 2024 at 11:26:28AM +0800, Binbin Wu wrote:
> > > Date: Thu, 12 Dec 2024 11:26:28 +0800
> > > From: Binbin Wu <binbin.wu@linux.intel.com>
> > > Subject: [PATCH] i386/kvm: Set return value after handling
> > >   KVM_EXIT_HYPERCALL
> > > X-Mailer: git-send-email 2.46.0
> > > 
> > > Userspace should set the ret field of hypercall after handling
> > > KVM_EXIT_HYPERCALL.  Otherwise, a stale value could be returned to KVM.
> > > 
> > > Fixes: 47e76d03b15 ("i386/kvm: Add KVM_EXIT_HYPERCALL handling for KVM_HC_MAP_GPA_RANGE")
> > > Reported-by: Farrah Chen <farrah.chen@intel.com>
> > > Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> > > Tested-by: Farrah Chen <farrah.chen@intel.com>
> > > ---
> > > To test the TDX code in kvm-coco-queue, please apply the patch to the QEMU,
> > > otherwise, TDX guest boot could fail.
> > > A matching QEMU tree including this patch is here:
> > > https://github.com/intel-staging/qemu-tdx/releases/tag/tdx-qemu-upstream-v6.1-fix_kvm_hypercall_return_value
> > > 
> > > Previously, the issue was not triggered because no one would modify the ret
> > > value. But with the refactor patch for __kvm_emulate_hypercall() in KVM,
> > > https://lore.kernel.org/kvm/20241128004344.4072099-7-seanjc@google.com/, the
> > > value could be modified.
> > 
> > Could you explain the specific reasons here in detail? It would be
> > helpful with debugging or reproducing the issue.
> > 
> > > ---
> > >   target/i386/kvm/kvm.c | 8 ++++++--
> > >   1 file changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> > > index 8e17942c3b..4bcccb48d1 100644
> > > --- a/target/i386/kvm/kvm.c
> > > +++ b/target/i386/kvm/kvm.c
> > > @@ -6005,10 +6005,14 @@ static int kvm_handle_hc_map_gpa_range(struct kvm_run *run)
> > >   static int kvm_handle_hypercall(struct kvm_run *run)
> > >   {
> > > +    int ret = -EINVAL;
> > > +
> > >       if (run->hypercall.nr == KVM_HC_MAP_GPA_RANGE)
> > > -        return kvm_handle_hc_map_gpa_range(run);
> > > +        ret = kvm_handle_hc_map_gpa_range(run);
> > > +
> > > +    run->hypercall.ret = ret;
> > 
> > ret may be negative but hypercall.ret is u64. Do we need to set it to
> > -ret?
> 
> If ret is less than zero, will stop the VM anyway as
> RUN_STATE_INTERNAL_ERROR.
> 
> If this has to be fixed in QEMU, I think there's no need to set anything
> if ret != 0; also because kvm_convert_memory() returns -1 on error and
> that's not how the error would be passed to the guest.
> 
> However, I think the right fix should simply be this in KVM:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 83fe0a78146f..e2118ba93ef6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10066,6 +10066,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>  		}
>  		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
> +		vcpu->run->ret                = 0;

		vcpu->run->hypercall.ret

>  		vcpu->run->hypercall.nr       = KVM_HC_MAP_GPA_RANGE;
>  		vcpu->run->hypercall.args[0]  = gpa;
>  		vcpu->run->hypercall.args[1]  = npages;
> 
> While there is arguably a change in behavior of the kernel both with
> the patches in kvm-coco-queue and with the above one, _in practice_
> the above change is one that userspace will not notice.

I agree that KVM should initialize "ret", but I don't think '0' is the right
value.  KVM shouldn't assume userspace will successfully handle the hypercall.
What happens if KVM sets vcpu->run->hypercall.ret to a non-zero value, e.g. -KVM_ENOSYS?

