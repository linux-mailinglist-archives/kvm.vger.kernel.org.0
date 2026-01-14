Return-Path: <kvm+bounces-68002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3688CD1C39D
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 04:17:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D800A301FB7F
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 03:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31B32D879C;
	Wed, 14 Jan 2026 03:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="Rs3VDJ1w"
X-Original-To: kvm@vger.kernel.org
Received: from out28-98.mail.aliyun.com (out28-98.mail.aliyun.com [115.124.28.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B78221F13;
	Wed, 14 Jan 2026 03:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768360631; cv=none; b=tGxSGd1/ymmofBxnGIX3HznkNo8hkmjwlSREImQP+NA6kSlsnkl1ewQ7oGuVDGA4eArrLOn7+Lc9tr0g/xTs3OUycuKYX/ORFnQ2nJIMm2TX8LsX+ZR+caQ7cRyMkVxFunsYgQlU1qAO5gB5W0iHqv3C03LZBKplXF/XU3GL6iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768360631; c=relaxed/simple;
	bh=jU35bec3GQLjQh6Ta0Y+MSG3xL3h9I43scGJJYXDHk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SY2Tmm69HbQ6m8exxRha24pWnsRThNzYfDAdNCzNnUqUkjDtc+FQBIYzkGmL3RBr3V07gMB94f/V/s63NgeYaeEz0wQUffpfBlLWzS/Z8EiSV9g1MRyqPYT/fm6gO+QkFFQ0u9A3PsxFGa6Mv/j7wU1/0bhluv+QgDPOjiAOXOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=Rs3VDJ1w; arc=none smtp.client-ip=115.124.28.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1768360620; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=DLN0GbWSjoY3bpjrpW0jMF7wT0DlZCik+ZkGOhxP7PU=;
	b=Rs3VDJ1wHS4xZFVKvSuzSOAvBYTbfXKqt0zp58RVJZsQnALXtcsGaZzlQvK6JMjhtI8+vn+WF6zBJV/tY0qUaHdhVdbYAPF6Ov6BHW/pzuKsIRBV6arYptebwJ3NT/wX7uWgumXPc2BcnYSJ9TMPIb2uuRsK5sD8zisCBHmge4I=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.g5xo.H6_1768360299 cluster:ay29)
          by smtp.aliyun-inc.com;
          Wed, 14 Jan 2026 11:11:39 +0800
Date: Wed, 14 Jan 2026 11:11:39 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: Don't register posted interrupt wakeup handler
 if alloc_kvm_area() fails
Message-ID: <20260114031139.GA107826@k08j02272.eu95sqa>
References: <0ac6908b608cf80eab7437004334fedd0f5f5317.1768304590.git.houwenlong.hwl@antgroup.com>
 <aWZwE1QukfjYDB_Q@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWZwE1QukfjYDB_Q@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Jan 13, 2026 at 08:17:23AM -0800, Sean Christopherson wrote:
> On Tue, Jan 13, 2026, Hou Wenlong wrote:
> > Unregistering the posted interrupt wakeup handler only happens during
> > hardware unsetup. Therefore, if alloc_kvm_area() fails and continue to
> > register the posted interrupt wakeup handler, this will leave the global
> > posted interrupt wakeup handler pointer in an incorrect state. Although
> > it should not be an issue, it's still better to change it.
> 
> Ouch, yeah, that's ugly.  It's not entirely benign, as a failed allocation followed
> by a spurious notification vector IRQ would trigger UAF.  So it's probably worth
> adding:
> 
>   Fixes: ec5a4919fa7b ("KVM: VMX: Unregister posted interrupt wakeup handler on hardware unsetup")
>   Cc: stable@vger.kernel.org
>
Actually, I'm not sure which commit is better as the fix tag:
'bf9f6ac8d749' or 'ec5a4919fa7b'. Before commit 'ec5a4919fa7b', the
handler was registered before alloc_kvm_areas() and was not unregistered
if alloc_kvm_areas() failed. However, it seems my commit message
description is more suitable for fixing 'ec5a4919fa7b'.

> even though I agree it's extremely unlikely to be an issue in practice.
> 
> > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 9b92f672ccfe..676f32aa72bb 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -8829,8 +8829,11 @@ __init int vmx_hardware_setup(void)
> >  	}
> >  
> >  	r = alloc_kvm_area();
> > -	if (r && nested)
> > -		nested_vmx_hardware_unsetup();
> > +	if (r) {
> > +		if (nested)
> > +			nested_vmx_hardware_unsetup();
> > +		return r;
> > +	}
> 
> I'm leaning towards using a goto with an explicit "return 0" in the happy case,
> to make it less likely that a similar bug is introduced in the future.  Any
> preference on your end?
> 
I don't have a strong preference either way. However, I agree that using
a goto statement could help prevent potential bugs in the future. Do I
need to send a v2?

Thanks!

> E.g. (untested)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9b92f672ccfe..cecaaeb3f82a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8829,8 +8829,8 @@ __init int vmx_hardware_setup(void)
>         }
>  
>         r = alloc_kvm_area();
> -       if (r && nested)
> -               nested_vmx_hardware_unsetup();
> +       if (r)
> +               goto err_kvm_area;
>  
>         kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
>  
> @@ -8857,6 +8857,11 @@ __init int vmx_hardware_setup(void)
>  
>         kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
>  
> +       return 0;
> +
> +err_kvm_area:
> +       if (nested)
> +               nested_vmx_hardware_unsetup();
>         return r;
>  }

