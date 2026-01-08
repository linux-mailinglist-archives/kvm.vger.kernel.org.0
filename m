Return-Path: <kvm+bounces-67352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C716D014F4
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 07:55:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0A1CA30208EB
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 06:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A6D330B07;
	Thu,  8 Jan 2026 06:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="Z7RnXhli"
X-Original-To: kvm@vger.kernel.org
Received: from out28-76.mail.aliyun.com (out28-76.mail.aliyun.com [115.124.28.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDEC2D6401;
	Thu,  8 Jan 2026 06:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767855332; cv=none; b=MFrCPAWs6FBSRDY4Rh/6Ee7S7zkAkYDlJ42C8w6kidHx/ioukm388mzxmNsFZQKPZLXaJlMJQaH9LAR464aMDWgOyypFfFYkXIfF5O5fo63p6B7RyhG9LE5zG2XRMapKrffNcOUZ+MzAb2/FaG4dtpl91PMIbT6TulBbrpf496I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767855332; c=relaxed/simple;
	bh=VpsQh2e9bZrEwPorKqQC3RWqqIa6XxDHEJJKu5r/9Qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b7ufbym7nqK1lDEYImhiPbHI3taEUq5MWYZ+PAbW1/A3wAgXnVbpPbYpk+s5Xkt3JVNCt/qbM1BhHnQoXvP+wVWnHR8SWam+7uBT4bDVTNAJvTZbbvsofVTHM5F9gKputa1Mo9fyK5qcMp/on/THmCsh9X/OcBGxF1c7Q5ZxVpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=Z7RnXhli; arc=none smtp.client-ip=115.124.28.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1767855318; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=kjO/f77TXKeXLeT4+zT4iepM/gTaceD+BxWCAT6dsqg=;
	b=Z7RnXhli1mnGWgIPr4nBWrl62Cs0l8AFqiaytPDBv899C/loesJk/0OUYe89GVcOqYSuemtXHUFkseVLsZFDQJyfpxwaQvgEqa46ivVjIxLHTvZQbz0Gow/Pjk3xbciNg1yZSFCboYNJ6m7vsgDts7ET9hQN7Tf9UI6HmEQUnns=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.g12XRvZ_1767855316 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 08 Jan 2026 14:55:16 +0800
Date: Thu, 8 Jan 2026 14:55:16 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
	Anish Ghulati <aghulati@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	hpa@zytor.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
	peterz@infradead.org, paulmck@kernel.org,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH 00/14] Support multiple KVM modules on the same host
Message-ID: <20260108065516.GA8281@k08j02272.eu95sqa>
References: <20231107202002.667900-1-aghulati@google.com>
 <CAJhGHyBtis3SkNZP8RSX5nKFcnQ4qvUrfTMD2RPc+w+Rzf30Zw@mail.gmail.com>
 <ZWYtDGH5p4RpGYBw@google.com>
 <20260105074814.GA10215@k08j02272.eu95sqa>
 <aV6BzSbAjZJGJ-D5@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aV6BzSbAjZJGJ-D5@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Jan 07, 2026 at 07:54:53AM -0800, Sean Christopherson wrote:
> On Mon, Jan 05, 2026, Hou Wenlong wrote:
> > Sorry for revisiting this topic after a long time. I haven't seen any
> > new updates regarding this topic/series, and I didn¡¯t find any recent
> > activity on the GitHub repository. Is the multi-KVM topic still being
> > considered for upstreaming, or is there anything blocking this?
> 
> We have abandoned upstreaming multi-KVM.  The operational cost+complexity is too
> high relative to the benefits, especially when factoring in things like ASI and
> live patching, and the benefits are almost entirely obsoleted by kernel live update
> support.
>

We need to look into the new features to see if they¡¯re compatible with
multi-KVM and how we can integrate them effectively. This is definitely
challenging work. We also have the option to explore the kernel live
update now.

> > As Lai pointed out, we also have a similar multi-KVM implementation in
> > our internal environment, so we are quite interested in this topic.
> > Recently, when we upgraded our kernel version, we found that maintaining
> > multi-KVM has become a significant burden.
> 
> Yeah, I can imagine the pain all too well.  :-/
> 
> > We are willing to move forward with it if multi-KVM is still accepted for
> > upstream. So I look forward to feedback from the maintainers.
> >
> > From what I've seen, the recent patch set that enables VMX/SVM during
> > booting is a good starting point for multi-KVM as well.
> 
> I have mixed feelings on multi-KVM.  Without considering maintenance and support
> costs, I still love the idea of reworking the kernel to support running multiple
> hypervisors concurrently.  But as I explained in the first cover letter of that
> series[0], there is a massive amount of complexity, both in initial development
> and ongoing maintenance, needed to provide such infrastructure:
> 
>  : I got quite far long on rebasing some internal patches we have to extract the
>  : core virtualization bits out of KVM x86, but as I paged back in all of the
>  : things we had punted on (because they were waaay out of scope for our needs),
>  : I realized more and more that providing truly generic virtualization
>  : instrastructure is vastly different than providing infrastructure that can be
>  : shared by multiple instances of KVM (or things very similar to KVM)[1].
>  :
>  : So while I still don't want to blindly do VMXON, I also think that trying to
>  : actually support another in-tree hypervisor, without an imminent user to drive
>  : the development, is a waste of resources, and would saddle KVM with a pile of
>  : pointless complexity.
> 
> For deployment to a relatively homogeneous fleet, many of the pain points can be
> avoided by either avoiding them entirely or making the settings "inflexible",
> because there is effectively one use case and so such caveats are a non-issue.
> But those types of simplifications don't work upstream, e.g. saying "eVMCS is
> unsupported if multi-KVM is possible" instead of moving eVMCS enabling to a base
> module isn't acceptable.
> 
> So I guess my "official" stance is that I'm not opposed to upstreaming multi-KVM
> (or similar) functionality, but I'm not exactly in favor of it either.  And
> practically speaking, because multi-KVM would be in constant conflict with so
> much ongoing/new feature support (both in software and hardware), and is not a
> priority for anyone pursuing kernel live update, upstreaming would be likely take
> several years, without any guarantee of a successful landing.
> 
> [0] https://lore.kernel.org/all/20251010220403.987927-1-seanjc@google.com
> [1] https://lore.kernel.org/all/aOl5EutrdL_OlVOO@google.com

Got it, thanks for your feedback!

