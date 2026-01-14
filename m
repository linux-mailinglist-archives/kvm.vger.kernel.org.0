Return-Path: <kvm+bounces-68085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2849DD21275
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 21:20:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B4F9F30478C8
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 20:19:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4600834846E;
	Wed, 14 Jan 2026 20:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m7VAXgfp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD0330F92D
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 20:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768421997; cv=none; b=ZNhwHf1O115+VYzTqBv+YR2LFl7YGM+CvbD//SNwqKgEwcsdY2Xa7eov8gfDrVwWEx+YBKqdPV3XGoRtHkNRlZyKNKXrKVRfF+7yJSbIy84vjC8TYFeVvdN3YtETNRYQtChoZniRXurklX/ITyhZ9c34w3Ri7u7xj35qfe2zfEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768421997; c=relaxed/simple;
	bh=HAfmUDOY1D8n7xocbyERnTGWrItauVgbdl2Fl4Pv9Ko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G8rLSvBUwtkov7Zx08kHd3y/RTCpV1U3Xnvj1l/dlXcT412ZsseVo+D69JG95sy9KCVt73NgQYUmMYkOYgnvSA9A999opLoCoxyVxVqfqiCSxvcbP/62aZeuvpoO5tmJ6FMA+MSuRy/IDhQ3LV9ijsTj8yM0rlHoqr0TcRycGkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m7VAXgfp; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29f13989cd3so4462035ad.1
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 12:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768421996; x=1769026796; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G8dhIsmv3PZv8e+Rql2tXfCxY1UQZKxi6Dx2BIrL2YQ=;
        b=m7VAXgfpjMrdKFgBchXTQ3xO/sJjImR6Qgr+418A7ihvIFyXWjGGJOi+H32lOMmkLA
         Lsd3taczeark1FBwsCr/P65mx85xGLWlU9UcdsnwNXLGeLqtOXpSWZgkhm6eP1YHP3zk
         KToX3UwFM+0G9vSPZ+AgApANliJ2HLk7/riVlOkf9xsJM9+AlXWSLYPTzkDClZkh1M8I
         uxuAb4J//Mf6/XD7BD6AI18x6/4IM2xsCluzm2aDQmxZt3ULrCmaSX1xpKS+B/Tle/2X
         0m5G9iMZ8m8MiyeA/qgqRqtQkIv/zanrUPd78UyyFbG0moIsJ5NjHXxJFdMa6YQUDTHk
         iV5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768421996; x=1769026796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G8dhIsmv3PZv8e+Rql2tXfCxY1UQZKxi6Dx2BIrL2YQ=;
        b=Kd93gFvNgoeL+7QOIWPp2p8guKp2vsddXWJQ6DYwMDfhOdAqUeX+GZcj5Igx2yYnk7
         MLVlTkWvfPazTfLaGTlOq37bkd6/2QdcuspXSR6xd5zkv6l0YEluVuM66ARe228H1S5p
         cFIjWeNCuf/WouqhYqEecqoVUsII336Nwc9EzxOZOFXCRE3CJN1jcuFDIH5/ITAN9AYL
         w9WtvSGaANg1+jNXGmDc4W2Hs/WFUhqgdQ5egwhAEOZy40TEovkU5td6/vzjdzeUWu7Z
         Nn+sewlN2q+B5bIVRdZFHOW4NTPwjp/ZpV/JEjjp7CNjAG3LRwl7nYuPItfiF7t4OckQ
         jCbw==
X-Forwarded-Encrypted: i=1; AJvYcCUr/EKwqSzraD7gRz6sXS65i9DNPf39mb7hFLrFFA4L7ch8IqNeV5+zucUbrralzOwXBQ8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywvv2yCCOP4kJXnUP2U7L2LM07GKr9FAJq5G8ajekdMAw+yj4ai
	xRexfeJ5eICeqv2kFgd1X5Eb+y5y1VNnNMIpi15z4JRQ5yK428svW0nTuNQtcimKxrlYY8jcvJa
	kfKVi8Q==
X-Received: from pllg5.prod.google.com ([2002:a17:902:7405:b0:29e:fd13:927b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:240c:b0:299:bda7:ae3c
 with SMTP id d9443c01a7336-2a599dba336mr36721305ad.14.1768421995675; Wed, 14
 Jan 2026 12:19:55 -0800 (PST)
Date: Wed, 14 Jan 2026 12:19:54 -0800
In-Reply-To: <aWf0zQ6vA0Hmon2r@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1752819570.git.naveen@kernel.org> <26732815475bf1c5ba672bc3b1785265f1a994e6.1752819570.git.naveen@kernel.org>
 <aWf0zQ6vA0Hmon2r@google.com>
Message-ID: <aWf6avEdiBPcIiyN@google.com>
Subject: Re: [RFC PATCH 2/3] KVM: SVM: Fix IRQ window inhibit handling across
 multiple vCPUs
From: Sean Christopherson <seanjc@google.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 14, 2026, Sean Christopherson wrote:
> Finally mustered up the brainpower to land this series :-)
> 
> On Fri, Jul 18, 2025, Naveen N Rao (AMD) wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index f19a76d3ca0e..b781b4f1d304 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1395,6 +1395,10 @@ struct kvm_arch {
> >  	struct kvm_pit *vpit;
> >  #endif
> >  	atomic_t vapics_in_nmi_mode;
> > +
> > +	/* Keep this in a cacheline separate from apicv_update_lock */
> 
> A comment won't suffice.  To isolate what we want to isolate, tag things with
> __aligned().  Ideally we would use __cacheline_aligned_in_smp, but AFAIK that
> can't be used within a struct as it uses .section tags, :-(

Gah, finally found what I was looking for: ____cacheline_aligned

