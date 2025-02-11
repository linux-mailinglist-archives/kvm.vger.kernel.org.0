Return-Path: <kvm+bounces-37924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D84DA3181B
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 22:46:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34FC2162FE1
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 21:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE411EE7B9;
	Tue, 11 Feb 2025 21:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JLmktekR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D775267721
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 21:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739310367; cv=none; b=PlkGCG6j+4r/2wehudg0tKEhhAyKrIlkFi7NujP0BdvLvts2Nvb8q8xQJLq7q7b/Rt645f9CxasNVPV6eTgmUWNoCascubpcQqjNFmYKQGEuRkpsFeWAOrQtMLbgr1C2kGFiumkOQKrckfjoemzpkVPnjiMftV/wFR1A+cx/AXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739310367; c=relaxed/simple;
	bh=Cl0AvwvO8dzPV+/0fQ2F3rAgpT/jet3fZHiJhFZhN6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JAbgc980tFw8whn563aG5Y27wYtaa4YKoxt3sXvGYD8G8CBSrr59NY+22h7kgTSuBjYEad1xlEg2H6pTIRSYTx++BC9WABV57d/itKyDrk18doTHggBiXVoNcopuSWrzj4xnLf6Bu+ZZrOHvIj+jY26RHR7qkFsIdi4xa+9e5z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JLmktekR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739310364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PgX+573L61jAZ+NGLaGL4AkiU3yn8kRPpAQyDAW3KPU=;
	b=JLmktekR2XSonk4V1fddddQY08Bh4KPtBZnf4LnrGZ2mVa0q6ecSSYwl9BOJYgWHsTLnqb
	1cEDfJtk2DU9kta33khXndWSnq3v2z35IOZxeuk4Zv5uQUv8TVRyjdSAHSo8CN+31AQ/gb
	GWjKi21fXBYjUnNt98uhty6r7qB7Vh4=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-z_ZA8BpPNzueeo6N_kvHUw-1; Tue, 11 Feb 2025 16:46:02 -0500
X-MC-Unique: z_ZA8BpPNzueeo6N_kvHUw-1
X-Mimecast-MFC-AGG-ID: z_ZA8BpPNzueeo6N_kvHUw
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3f3b8f794e1so2046374b6e.2
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 13:46:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739310362; x=1739915162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PgX+573L61jAZ+NGLaGL4AkiU3yn8kRPpAQyDAW3KPU=;
        b=FbatQHOwP9sPRzCcLTBnym3lVgGfjUKufiHCZdixaZS8CfvXWE4rJZH4IWgpRUah3z
         5YeP4YyJB+OgQRKuRTP0gwEHeG1ZmxkLd1cc1bsaW7PD41B/20+Rv6SH/neyY26hzYTR
         lHro2yC+24DBKX055u3icissG6invj2wIfPDusvbFG0LrWojz3V3T3EJmfZpT+HI/gRG
         wcfovrUHDXzPUfRVsw1poZX878o06qfD3FnFeOQ5z07ZhGUzHFnjqVakaEPOxhobKFAL
         PriB8E1rG/MAS4IV5uRJ8lIljkBnTLVfaizanpf2FOI6d53XuKHk0bP0zceQwSVVlfVq
         NUng==
X-Forwarded-Encrypted: i=1; AJvYcCU3HzT7yeiJxrnJLPySS8do8gEtjRtK10WKLy0Mwn7fFthvTe1UuxYt8gDb8tlHtDDHOVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZOsvDcIM0DTe0vltkZAIDoK9cwxmVdqyS9D8POhKTLfOzRTBQ
	pu1JXxJ2Wn/p3bS+0FHkIiDK2SqEWBE1rdjac8eUERR35m8xQ3dc4ieVbgMhVcOgKlkbJE+DFPh
	IvAe6N6Wl8MgqSwr3RYD/o7WTSoXIxCSXhUcMgARaD1VTTLl/1w==
X-Gm-Gg: ASbGncshrqs/oC5K9b+JsZXseBxZ1F1yVB5ax2PWMd3yWwRwZVj5qAoSux4jln44W2w
	3o2vrtvlx4JIe71nQrAwr8jDwsQ8kquJ2MqEeN/edk3fRPPagqyrVlKNJRPlhUkhrijsARSxll0
	sQFwdUKLXT3mvTROaaRnVefd0s87DEIqsL9lfarcrCqyvFex++FMtQOGVmhO9E8wgCSJWafJQSM
	KHOyFtE6wOj0QORw4srqkSYF6tIEbhEVlqHh9lIPE39Fd4M32QNutGMyUA=
X-Received: by 2002:a05:6808:1454:b0:3eb:6db7:f787 with SMTP id 5614622812f47-3f3cefdd936mr302528b6e.11.1739310362157;
        Tue, 11 Feb 2025 13:46:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHYnOD2BAMH3w3POLOCBd11WZ3vPq9hbLjN/niZU4pJlfl+Gy6RLvr7Z7LkVcpTulQy+mpdcA==
X-Received: by 2002:a05:6808:1454:b0:3eb:6db7:f787 with SMTP id 5614622812f47-3f3cefdd936mr302509b6e.11.1739310361858;
        Tue, 11 Feb 2025 13:46:01 -0800 (PST)
Received: from x1.local ([2604:7a40:2041:2b00::1000])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3f389ea91acsm3500233b6e.8.2025.02.11.13.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 13:46:01 -0800 (PST)
Date: Tue, 11 Feb 2025 16:45:55 -0500
From: Peter Xu <peterx@redhat.com>
To: William Roche <william.roche@oracle.com>
Cc: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
	qemu-arm@nongnu.org, pbonzini@redhat.com,
	richard.henderson@linaro.org, philmd@linaro.org,
	peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
	eduardo@habkost.net, marcel.apfelbaum@gmail.com,
	wangyanan55@huawei.com, zhao1.liu@intel.com,
	joao.m.martins@oracle.com
Subject: Re: [PATCH v7 3/6] accel/kvm: Report the loss of a large memory page
Message-ID: <Z6vFEwS6EjDXHsFc@x1.local>
References: <20250201095726.3768796-1-william.roche@oracle.com>
 <20250201095726.3768796-4-william.roche@oracle.com>
 <Z6JH_OyppIA7WFjk@x1.local>
 <3f3ebbe8-be97-4827-a8c5-6777dea08707@oracle.com>
 <Z6Oaukumli1eIEDB@x1.local>
 <2ad49f5d-f2c1-4ba2-9b6b-77ba96c83bab@oracle.com>
 <Z6ot7eVxaf39oWKr@x1.local>
 <6c891caf-fbc0-4f5e-8e21-e87c3348c9fa@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6c891caf-fbc0-4f5e-8e21-e87c3348c9fa@oracle.com>

On Tue, Feb 11, 2025 at 10:22:38PM +0100, William Roche wrote:
> On 2/10/25 17:48, Peter Xu wrote:
> > On Fri, Feb 07, 2025 at 07:02:22PM +0100, William Roche wrote:
> > > [...]
> > > So the main reason is a KVM "weakness" with kvm_send_hwpoison_signal(), and
> > > the second reason is to have richer error messages.
> > 
> > This seems true, and I also remember something when I looked at this
> > previously but maybe nobody tried to fix it.  ARM seems to be correct on
> > that field, otoh.
> > 
> > Is it possible we fix KVM on x86?
> 
> Yes, very probably, and it would be a kernel fix.
> This kernel modification would be needed to run on the hypervisor first to
> influence a new code in qemu able to use the SIGBUS siginfo information and
> identify the size of the page impacted (instead of using an internal
> addition to kvm API).
> But this mechanism could help to generate a large page memory error specific
> message on SIGBUS receiving.

Yes, QEMU should probably better be able to work on both old/new kernels,
even if this will be fixed.

> 
> 
> > > > 
> > > > I feel like when hwpoison becomes a serious topic, we need some more
> > > > serious reporting facility than error reports.  So that we could have this
> > > > as separate topic to be revisited.  It might speed up your prior patches
> > > > from not being blocked on this.
> > > 
> > > I explained why I think that error messages are important, but I don't want
> > > to get blocked on fixing the hugepage memory recovery because of that.
> > 
> > What is the major benefit of reporting in QEMU's stderr in this case?
> 
> Such messages can be collected into VM specific log file, as any other
> error_report() message, like the existing x86 error injection messages
> reported by Qemu.
> This messages should help the administrator to better understand the
> behavior of the VM.

I'll still put "better understand the behavior of VM" into debugging
category. :)

But I agree such can be important information.  That's also why I was
curious whether it should be something like a QMP event instead.  That's a
much formal way of sending important messages.

> 
> 
> > For example, how should we consume the error reports that this patch
> > introduces?  Is it still for debugging purpose?
> 
> Its not only debugging, but it's a trace of a significant event that can
> have major consequences on the VM.
> 
> > 
> > I agree it's always better to dump something in QEMU when such happened,
> > but IIUC what I mentioned above (by monitoring QEMU ramblock setups, and
> > monitor host dmesg on any vaddr reported hwpoison) should also allow anyone
> > to deduce the page size of affected vaddr, especially if it's for debugging
> > purpose.  However I could possibly have missed the goal here..
> 
> You're right that knowing the address, the administrator can deduce what
> memory area was impacted and the associated page size. But the goal of these
> large page specific messages was to give details on the event type and
> immediately qualify the consequences.
> Using large pages can also have drawbacks, and a large page specific message
> on memory error makes that more obvious !  Not only a debug msg, but an
> indication that the VM lost an unusually large amount of its memory.
> 
> > > 
> > > If you think that not displaying a specific message for large page loss can
> > > help to get the recovery fixed, than I can change my proposal to do so.
> > > 
> > > Early next week, I'll send a simplified version of my first 3 patches
> > > without this specific messages and without the preallocation handling in all
> > > remap cases, so you can evaluate this possibility.
> > 
> > Yes IMHO it'll always be helpful to separate it if possible.
> 
> I'm sending now a v8 version, without the specific messages and the remap
> notification. It should fix the main recovery bug we currently have. More
> messages and a notification dealing with pre-allocation can be added in a
> second step.
> 
> Please let me know if this v8 version can be integrated without the prealloc
> and specific messages ?

IMHO fixing hugetlb page is still a progress on its own, even without any
added error message, or proactive allocation during reset.

One issue is the v8 still contains patch 3 which is for ARM kvm.. You may
need to post it separately for ARM maintainers to review & collect.  I'll
be able to queue patch 1-2.

Thanks,

-- 
Peter Xu


