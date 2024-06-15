Return-Path: <kvm+bounces-19730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB949094ED
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2024 02:05:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6AB03B2135A
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2024 00:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FA091396;
	Sat, 15 Jun 2024 00:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yhdw7Os1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E477A376
	for <kvm@vger.kernel.org>; Sat, 15 Jun 2024 00:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718409901; cv=none; b=btDltafePeuzhV3vAXoOXtmNkTOcQlKk8f59SjHOpANGB8qCqJBw+pn5fxFsijCB/2y2EPtm6g1/m6f7T2WAhyQg0y/7VrQjb1BIioZbd/AUPkZggQjYzg97nuTILkpWyQA3Qy7HBAtZXZBuiue5XK+C/MWpE7LakKDxH3pCrQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718409901; c=relaxed/simple;
	bh=s9EnDXutqel6yc9aWVQjnkieztpURLhI4fNOsupj9V4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W3cYPLD6YJvlb2LAxJHXr5ZI1M3gR9uKCzEUF1SWnMnGfM623FszropQ857EDBHzpXO/re7E0TlmpvjP230PFahUFxYcQDluRtcTK6pUD7ecplybCQ/MkQ1Va61lYnjElt6kewbgHpIgFzPf9v7XMeXextTQS+K3+9LK4Y7EEFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yhdw7Os1; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2c2dfbc48easo2511682a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 17:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718409899; x=1719014699; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JAbCB4cWM/jBKzkgnqSGqxJw+sHKF8jD1gh3nQqagX0=;
        b=Yhdw7Os1412zFNyQoOZNJ3CYQjH4Q4SdXO1f+hYJHRsWdkGzGP4n9ARi35M9K6YFru
         2/OvF9ew4s/19za1q3hPzjkGbkP0sUc3nc1IoIidqP31JHB2AmSpA5CX9ngUuSfq59P7
         sPPzb0uv6xdtSXzsGwNgTtZCIWW+z3l6sdV/ri/xzVVOTCsqjKUEGXTBAzHbSPUEv4X0
         kcsYHXvJVoO0CeTLOjR8DSLIvEqFA8ZXzjO4jDbLxTUeXjZRINgoiTl1bDSPCgbnNy6T
         ySsgdfDrVXOyl/CjZMVkNzVO9MvsrnNqkxPtGCyxpYmzj6VUtGcLdc68E6YyjiBdOHKQ
         eX2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718409899; x=1719014699;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JAbCB4cWM/jBKzkgnqSGqxJw+sHKF8jD1gh3nQqagX0=;
        b=NVllc84CJgypPv3T/lqRmNqEpiJ+EY1WeSQsEF1SavRGoLdJfi3NUWc3xH/3sHX6MA
         tO4VRVoqBqzNWQZTCCbW+tLC2N369xcis+ZctWVpN99CZv44raf3aSqogr0gdo2nEdC1
         6rSLJmEOsR08HetNUw7bUKmlrZ7zDE+2cOM6gDFI5QpsYlAXikXVwF7EH+hLXQYyEKXE
         VitgbWW/K4tlet82K9z9sWv3T+I6/0m2aew+zSMRqmezUJ+uEyN93HSiVYILH0B2CQlg
         F4eT0v6PNO7T47yyC5Cb5mXq6oEaYkBq8qN9KHBtHbH2fP9+iTfxv4bK5DrQmy1RSDqm
         OSVA==
X-Forwarded-Encrypted: i=1; AJvYcCVRve8hTYqSrwzLCBd65LvO1vEVHm3suR/WenvUkkOKI52i7ibchUzJgRXt3LNSKHalfvZGIoV/XKQ052wip9HO5qWX
X-Gm-Message-State: AOJu0YxKQK7ZN+GRP9yHOYm80zbPUusOD80SNcsTyeETmo5D1J4iQkj+
	deRm1rpN++OG2GuLhQk+wQgfwImyy8znHyf7GctB3NBoFgbcHoADLecjmSPgfJoRB3tIE/+eRYF
	VWA==
X-Google-Smtp-Source: AGHT+IHoIiorw5XA41KgarAZ6PxcCkxY6qe04nLr0zVITL8iJtzFO30b8vb4BsxMvGmlCF+/2gJ1QML3LEk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4889:b0:2c2:4109:6a5f with SMTP id
 98e67ed59e1d1-2c4dbd31ec4mr134262a91.6.1718409899098; Fri, 14 Jun 2024
 17:04:59 -0700 (PDT)
Date: Fri, 14 Jun 2024 17:04:57 -0700
In-Reply-To: <405dd8997aaaf33419be6b0fc37974370d63fd8c.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Zj1Ty6bqbwst4u_N@google.com> <49b7402c-8895-4d53-ad00-07ce7863894d@intel.com>
 <20240509235522.GA480079@ls.amr.corp.intel.com> <Zj4phpnqYNoNTVeP@google.com>
 <50e09676-4dfc-473f-8b34-7f7a98ab5228@intel.com> <Zle29YsDN5Hff7Lo@google.com>
 <f2952ae37a2bdaf3eb53858e54e6cc4986c62528.camel@intel.com>
 <ZliUecH-I1EhN7Ke@google.com> <38210be0e7cc267a459d97d70f3aff07855b7efd.camel@intel.com>
 <405dd8997aaaf33419be6b0fc37974370d63fd8c.camel@intel.com>
Message-ID: <ZmzaqRy2zjvlsDfL@google.com>
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend specific
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Bo2 Chen <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>, Erdem Aktas <erdemaktas@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 14, 2024, Kai Huang wrote:
> On Tue, 2024-06-04 at 10:48 +0000, Huang, Kai wrote:
> > On Thu, 2024-05-30 at 16:12 -0700, Sean Christopherson wrote:
> > > On Thu, May 30, 2024, Kai Huang wrote:
> > > > On Wed, 2024-05-29 at 16:15 -0700, Sean Christopherson wrote:
> > > > > In the unlikely event there is a legitimate reason for max_vcpus_per_td being
> > > > > less than KVM's minimum, then we can update KVM's minimum as needed.  But AFAICT,
> > > > > that's purely theoretical at this point, i.e. this is all much ado about nothing.
> > > > 
> > > > I am afraid we already have a legitimate case: TD partitioning.  Isaku
> > > > told me the 'max_vcpus_per_td' is lowed to 512 for the modules with TD
> > > > partitioning supported.  And again this is static, i.e., doesn't require
> > > > TD partitioning to be opt-in to low to 512.
> > > 
> > > So what's Intel's plan for use cases that creates TDs with >512 vCPUs?
> > 
> > I checked with TDX module guys.  Turns out the 'max_vcpus_per_td' wasn't
> > introduced because of TD partitioning, and they are not actually related.
> > 
> > They introduced this to support "topology virtualization", which requires
> > a table to record the X2APIC IDs for all vcpus for each TD.  In practice,
> > given a TDX module, the 'max_vcpus_per_td', a.k.a, the X2APIC ID table
> > size reflects the physical logical cpus that *ALL* platforms that the
> > module supports can possibly have.
> > 
> > The reason of this design is TDX guys don't believe there's sense in
> > supporting the case where the 'max_vcpus' for one single TD needs to
> > exceed the physical logical cpus.
> > 
> > So in short:
> > 
> > - The "max_vcpus_per_td" can be different depending on module versions. In
> > practice it reflects the maximum physical logical cpus that all the
> > platforms (that the module supports) can possibly have.
> > 
> > - Before CSPs deploy/migrate TD on a TDX machine, they must be aware of
> > the "max_vcpus_per_td" the module supports, and only deploy/migrate TD to
> > it when it can support.
> > 
> > - For TDX 1.5.xx modules, the value is 576 (the previous number 512 isn't
> > correct); For TDX 2.0.xx modules, the value is larger (>1000).  For future
> > module versions, it could have a smaller number, depending on what
> > platforms that module needs to support.  Also, if TDX ever gets supported
> > on client platforms, we can image the number could be much smaller due to
> > the "vcpus per td no need to exceed physical logical cpus".
> > 
> > We may ask them to support the case where 'max_vcpus' for single TD
> > exceeds the physical logical cpus, or at least not to low down the value
> > any further for future modules (> 2.0.xx modules).  We may also ask them
> > to give promise to not low the number to below some certain value for any
> > future modules.  But I am not sure there's any concrete reason to do so?
> > 
> > What's your thinking?

It's a reasonable restriction, e.g. KVM_CAP_NR_VCPUS is already capped at number
of online CPUs, although userspace is obviously allowed to create oversubscribed
VMs.

I think the sane thing to do is document that TDX VMs are restricted to the number
of logical CPUs in the system, have KVM_CAP_MAX_VCPUS enumerate exactly that, and
then sanity check that max_vcpus_per_td is greater than or equal to what KVM
reports for KVM_CAP_MAX_VCPUS.

Stating that the maximum number of vCPUs depends on the whims TDX module doesn't
provide a predictable ABI for KVM, i.e. I don't want to simply forward TDX's
max_vcpus_per_td to userspace.

