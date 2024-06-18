Return-Path: <kvm+bounces-19866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF5F490D635
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 16:55:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 679332914F0
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 14:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C7115442A;
	Tue, 18 Jun 2024 14:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L4AzBa4T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F45153819
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 14:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718722189; cv=none; b=tOyPPFTjMoc9rhrLmA/7LQBm//tMLteRch4tjA4rtI6nDMhc5vmW1NQxihXy7EznFLOE+v9BSmhYstpJj8asCQVGhZf7qNrjJSFaDvagCcc3s+PcaqW8GF5S7vtF6xm9QiQCI7IoCXkVtd82Mq2Mrc+POaELfxWQd9QlavPEsfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718722189; c=relaxed/simple;
	bh=sS4KfRfJJiUqihLxcYtcY+Mfy1Ulb126w+Wc3l+706c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h6p9jxDBsizwuOiRVfNlVs93PACvsEvGFx9FhU1ueX57veSkK3mok5XHxHj5pIsGSUHM62aq0NHTvtNvnEL9CqxDrqVmEWD6r7qPSckEm9NIWWy7aFwt7iYeFTc9NaA525iajY8c1rcJmOD4nnwWEFJ0IdfignsxLmgn40ZF4MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L4AzBa4T; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1f70c5242eeso44046725ad.3
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 07:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718722186; x=1719326986; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CTIp2bgGTA/tlgQkxUpOKFr0N9Q3zohXJu7y3VJNXEg=;
        b=L4AzBa4T2B135Q3Y5vmRh/Lz4XLIdOqrmF/A/LQAN3+2H4Ns44hjr5VSlgWRUk5GhE
         efsBHBbWBW9I1CQAxQTdGpC1Won+i+5fCjZS/hQDJU1J/1Rypo6SrjoI9kEc+Dv2+1bk
         PJdPH/AtzHdQ3/GGzDTaweXMMSyEQVTzKyAOmRbspHJ8rczAe/XifT9YBgd08igyk1SO
         FaeC/LVSVPWgPwKWxh+Fn1MuSEbF26swCkjrUJd2vGN+ldPnZGewFcowyqld45/7PXG6
         2z4p/l21JjOdG8IjDQhaxSdoc1HYhJ4PFh362xNyDviKpZ7Jat31V+wdOl/Gs668ABqt
         UaeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718722186; x=1719326986;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CTIp2bgGTA/tlgQkxUpOKFr0N9Q3zohXJu7y3VJNXEg=;
        b=PyY9Xiw+n5kMwTqKnpUU04GLXxi48VTETwhEW4c8cNafXNs08o70IsTbASIpV8qyx7
         E2Rr3Ef3e8iJSm9b8hXziBidhDmJzeW3/Sd8S++XuUIEnqvOMMbBbJz4OmCgojzqd7wo
         hIKGLw0YDhW1AQlp4vuEcnQKiHQw9l5OLa5QnfaLhNuyyHPCKxJnz7GIka+jjQYD3TNH
         RYpZnbGfyQNWGGTt95NRMFqqhPdYf5AdmwolLTDPTitWvp2G/5BPVYwnUxW0e9BcA6sq
         hiMSn0At+Uxa83COI7Bxv7vasZuL+ubozThMbM9WjlcDnmtB1bfm5e2A0hONFdrAn4Rj
         ggyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcbVwBdJWYeAgfBK0viVki2yeVFlxDQhd3K+4EP9rPwyKpGOSzB3lKLiGiAlE8bGF01yC/qvDMTGTSUqI9NIIUIAPL
X-Gm-Message-State: AOJu0YyS4WMlSlwcQSIsxLqIiYc2UA6ktUiLHyrlAmsorI4T19MkVXxj
	9Am+WjSPSPCysjTO5IpN4zhero60CaTyWlNN1bremuTqA8fqN0mjZdWMSLTcg2XYXa82F9yvvr3
	q/Q==
X-Google-Smtp-Source: AGHT+IF4aKcWBFfiWCx7LxGuRbyviEwKtzksGT/KMvnW6maaVMM8cx45zq+A4lMs7oOAJ6NS2QXY68JhpeQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e851:b0:1f4:76f6:63bc with SMTP id
 d9443c01a7336-1f8625d54cemr3345535ad.7.1718722185726; Tue, 18 Jun 2024
 07:49:45 -0700 (PDT)
Date: Tue, 18 Jun 2024 07:49:43 -0700
In-Reply-To: <5bb2d7fc-cfe9-4abd-a291-7ad56db234b3@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240509235522.GA480079@ls.amr.corp.intel.com>
 <Zj4phpnqYNoNTVeP@google.com> <50e09676-4dfc-473f-8b34-7f7a98ab5228@intel.com>
 <Zle29YsDN5Hff7Lo@google.com> <f2952ae37a2bdaf3eb53858e54e6cc4986c62528.camel@intel.com>
 <ZliUecH-I1EhN7Ke@google.com> <38210be0e7cc267a459d97d70f3aff07855b7efd.camel@intel.com>
 <405dd8997aaaf33419be6b0fc37974370d63fd8c.camel@intel.com>
 <ZmzaqRy2zjvlsDfL@google.com> <5bb2d7fc-cfe9-4abd-a291-7ad56db234b3@intel.com>
Message-ID: <ZnGehy1JK_V0aJQR@google.com>
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

On Tue, Jun 18, 2024, Kai Huang wrote:
> On 15/06/2024 12:04 pm, Sean Christopherson wrote:
> > On Fri, Jun 14, 2024, Kai Huang wrote:
> > > > - The "max_vcpus_per_td" can be different depending on module versions. In
> > > > practice it reflects the maximum physical logical cpus that all the
> > > > platforms (that the module supports) can possibly have.
> > 
> > It's a reasonable restriction, e.g. KVM_CAP_NR_VCPUS is already capped at number
> > of online CPUs, although userspace is obviously allowed to create oversubscribed
> > VMs.
> > 
> > I think the sane thing to do is document that TDX VMs are restricted to the number
> > of logical CPUs in the system, have KVM_CAP_MAX_VCPUS enumerate exactly that, and
> > then sanity check that max_vcpus_per_td is greater than or equal to what KVM
> > reports for KVM_CAP_MAX_VCPUS. >
> > Stating that the maximum number of vCPUs depends on the whims TDX module doesn't
> > provide a predictable ABI for KVM, i.e. I don't want to simply forward TDX's
> > max_vcpus_per_td to userspace.
> 
> This sounds good to me.  I think it should be also OK for client too, if TDX
> ever gets supported for client.
> 
> IIUC we can consult the @nr_cpu_ids or num_possible_cpus() to get the
> "number of logical CPUs in the system".  And we can reject to use the TDX
> module if 'max_vcpus_per_td' turns to be smaller.

I assume TDX is incompatible with actual physical CPU hotplug?  If so, we can and
should use num_present_cpus().  If  loading the TDX module completely disables
onlining CPUs, then we can use num_online_cpus().

> I think the relevant question is is whether we should still report "number
> of logical CPUs in the system" via KVM_CAP_MAX_VCPUS?  Because if doing so,
> this still means the userspace will need to check KVM_CAP_MAX_VCPUS vm
> extention on per-vm basis.

Yes.

> And if it does, then from userspace's perspective, it actually doesn't
> matter whether underneath the per-vm KVM_CAP_MAX_VCPUS is limited by TDX or
> the system cpus (also see below).

It matters because I don't want KVM's ABI to be tied to the whims of the TDX module.
Today, there's no limitations on the max number of vCPUs.  Tomorrow, it's limited
by the number of pCPUs.  Three days from now, I don't want to find out that the
TDX module is limiting the number of vCPUs based on some other new criteria.

> The userspace cannot tell the difference anyway.  It just needs to change to
> query KVM_CAP_MAX_VCPUS to per-vm basis.
> 
> Or, we could limit this to TDX guest ONLY:
> 
> The KVM_CAP_MAX_VCPUS is still global.  However for TDX specifically, the
> userspace should use other way to query the number of LPs the system
> supports (I assume there should be existing ABI for this?).
> 
> But looks this isn't something nice?

What's wrong with querying KVM_CAP_MAX_VCPUS on the VM file descriptor?

