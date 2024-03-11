Return-Path: <kvm+bounces-11572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34D6487858E
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 17:36:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEEC22819FD
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 16:36:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF4041211;
	Mon, 11 Mar 2024 16:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ImS3KFJJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6E033CCC
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 16:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710174974; cv=none; b=FuUggU1PC5or6CeG9CytAIw8wFjeL2NYVaZmQRATGEnve6iANT94cHYi5g15xBXbK3aGd3W//fu6NybSjc2BjuMYC3Jm7Q12OmRzsMZBY6Hyr8qiFF8MxTI54uv6MjRHEZ+s7TrX2BDyDDFAm7/HC/Jzy61OiIxCGV1RIwmIbdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710174974; c=relaxed/simple;
	bh=isLqK6ItRjGtIDQRhg8YPB2CyojqVbNSpsz0qaZNXNA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eR9t/hQisVScLd1bQ3Q9VIulyag7DsCC99Us5pnF6suTMklbQ1knmZtWhblyCjTLzU+9Vvhkgv9kw0d6M2o23rFXdgaav+VWPJUPu0QE2T3Ry5XZ0+De4/Cc+bJBP8W38lGOtD5gLNo8DY5IIpplnOkdE8tV5voSytacMpd45D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ImS3KFJJ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5ca5b61c841so3946612a12.3
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 09:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710174972; x=1710779772; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X3unNvMJmwckUHetUtmk+spnbtolTKG7B8byZbIt1Z0=;
        b=ImS3KFJJ6VW870TLmjy4iPKIz3tbFd60m3hjDD9L0rJK6hFb2ZPl4m5x9/GIhc0gpc
         Qjqa3/tKe4IjTdoenjzPBHFBSnEobAkfcC6iFmohXkbVfdQemSQWotpnL+e4nqE8ssEh
         R1eBa+Jr8zixRMiSa5nEbmbOHfHFIDonqhGIO0bJiv3OgwSYWy0miAjs38mawOUrKg+V
         P40LSNG+eeywbk4e23YlGnnSlJl/BhcaX+YXFl96v855SkdaMXwLPCbV7fKnJzInPVpe
         M+EeIoap1yEUmjviu5LD00g+PL0GJO6t+w4HRHVNmkVHed8j5NlUpaSTivsW6mYd2v76
         EuCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710174972; x=1710779772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X3unNvMJmwckUHetUtmk+spnbtolTKG7B8byZbIt1Z0=;
        b=k7G363v5bTOM1dZFx+2iwNDuHQJmhU82HvigTMMtB+3TQ2V3fJ1Dv+FaS06nHohh32
         at4OiaKVsHNpp/U90WAEu608vuCQkliYktLALN3n6vm750y7IioWDHsckmP5wNBn2nX+
         RBuxrMo1Ee7+fhB/qecrWXJqOzYs7GKVF1hPXSM+ZsoHWJnlxigd7RumZGUvaGQB3A2P
         Q4cIy7XVsV/Rgw7TEdkEKAGnrjAIOpK194fnOS0yN4UDhVZ1+TLeR6Jm5Z+upFbRx/WO
         XnrAcNYBwDLQDJwgbqz1zZBXSec6n+++nv4yXBsLOjHjGZetTKfFmJXOXzX5AZi/M3AE
         FnuA==
X-Forwarded-Encrypted: i=1; AJvYcCXigR4QseDCjUj3YI+sJYbJhtS58O0WS4zUxHsVkNYBlbCA03YxWPtEcjL924mtqdm87qbWT7WDOkMqDeb7wvdRjLyE
X-Gm-Message-State: AOJu0YxrbcdqxRrB38ye+rg/ElAUXz+61QYE1NlnVN7PErJ9jWENEMo6
	R2vA+qBWsrlkzGdvfroFCaTTGI87XGlNlIj0Hf2vHbXfiv2gncbeBX4NmMPXWqXfNMWd1sESXKb
	/vw==
X-Google-Smtp-Source: AGHT+IExHQEGBmiNYVBGoJD9ZKwDgiOscVRHbeXN523k61uOwL8cP5bF8Zoh363F9LVu2KsVjJYbwbppLE4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1941:0:b0:5dc:2368:a9f2 with SMTP id
 1-20020a631941000000b005dc2368a9f2mr17212pgz.3.1710174971787; Mon, 11 Mar
 2024 09:36:11 -0700 (PDT)
Date: Mon, 11 Mar 2024 09:36:10 -0700
In-Reply-To: <Ze6Md/RF8Lbg38Rf@thinky-boi>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-7-amoorthy@google.com>
 <ZeuMEdQTFADDSFkX@google.com> <ZeuxaHlZzI4qnnFq@google.com> <Ze6Md/RF8Lbg38Rf@thinky-boi>
Message-ID: <Ze8y-vGzbDSLP-2G@google.com>
Subject: Re: [PATCH v7 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: David Matlack <dmatlack@google.com>, Anish Moorthy <amoorthy@google.com>, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Mar 10, 2024, Oliver Upton wrote:
> On Fri, Mar 08, 2024 at 04:46:32PM -0800, David Matlack wrote:
> > On 2024-03-08 02:07 PM, Sean Christopherson wrote:
> > > On Thu, Feb 15, 2024, Anish Moorthy wrote:
> > > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > > index 9f5d45c49e36..bf7bc21d56ac 100644
> > > > --- a/Documentation/virt/kvm/api.rst
> > > > +++ b/Documentation/virt/kvm/api.rst
> > > > @@ -1353,6 +1353,7 @@ yet and must be cleared on entry.
> > > >    #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
> > > >    #define KVM_MEM_READONLY	(1UL << 1)
> > > >    #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
> > > > +  #define KVM_MEM_EXIT_ON_MISSING  (1UL << 3)
> > > 
> > > David M.,
> > > 
> > > Before this gets queued anywhere, a few questions related to the generic KVM
> > > userfault stuff you're working on:
> > > 
> > >   1. Do you anticipate reusing KVM_MEM_EXIT_ON_MISSING to communicate that a vCPU
> > >      should exit to userspace, even for guest_memfd?  Or are you envisioning the
> > >      "data invalid" gfn attribute as being a superset?
> > > 
> > >      We danced very close to this topic in the PUCK call, but I don't _think_ we
> > >      ever explicitly talked about whether or not KVM_MEM_EXIT_ON_MISSING would
> > >      effectively be obsoleted by a KVM_SET_MEMORY_ATTRIBUTES-based "invalid data"
> > >      flag.
> > > 
> > >      I was originally thinking that KVM_MEM_EXIT_ON_MISSING would be re-used,
> > >      but after re-watching parts of the PUCK recording, e.g. about decoupling
> > >      KVM from userspace page tables, I suspect past me was wrong.
> > 
> > No I don't anticipate reusing KVM_MEM_EXIT_ON_MISSING.
> > 
> > The plan is to introduce a new gfn attribute and exit to userspace based
> > on that. I do forsee having an on/off switch for the new attribute, but
> > it wouldn't make sense to reuse KVM_MEM_EXIT_ON_MISSING for that.
> 
> With that in mind, unless someone else has a usecase for the
> KVM_MEM_EXIT_ON_MISSING behavior my *strong* preference is that we not
> take this bit of the series upstream. The "memory fault" UAPI should
> still be useful when the KVM userfault stuff comes along.

+1

Though I'll go a step further and say that even if someone does have a use case,
we should still wait.  The imminent collision with David Steven's kvm_follow_pfn()
series[*] is going to be a painful rebase no matter what, and once that's out of
the way, rebasing this series onto future kernels shouldn't be crazy difficult.

In other words, _if_ it turns out there's value in KVM_MEM_EXIT_ON_MISSING even
with David M's work, the cost of waiting another cycle (or two) is relatively
small.

Oh, and I'll plan on grabbing patches 1-4 for 6.10.

[*]https://lore.kernel.org/all/20240229025759.1187910-1-stevensd@google.com

