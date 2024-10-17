Return-Path: <kvm+bounces-29054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 20FEE9A1D1B
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 10:24:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69D59B22B1F
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 08:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0BA31D2F73;
	Thu, 17 Oct 2024 08:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="ABLosHbA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GmKk7qR0"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800F725776;
	Thu, 17 Oct 2024 08:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729153439; cv=none; b=VkgpK+CXP3oTWJ9/mBSknI0wLSyZ/HAT8P4edgNrHF3oqtF2T+RCySq2go3QflDUeWoEbPLvQ9pU+6Br4rQVf69FKYGHNtVebIkmJGyNA+BA1zyVuvXo/7iYsORZ8/pRQXAIqRVxG97Qq5UlJUTR2KDr9x3g4w6khB1Ql+aQ+MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729153439; c=relaxed/simple;
	bh=r/lBsogBVa1Y5PrZ6xNPTJQ1j/tdMwHgD77thc74r7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OI/raG2hYZrZOiuT1Y8MVbQ3e4HnMOaI1gY3UgT9jmyn4V1jpduXmIj4ntX4rORGOzwxBk4GiG/HbHw5iWoRcIKX78sTQPzZwPGHt0F2HPkttN7nm8HCJJkTxnvzUaieX91vQz24pc4AGuJ172UHrnSIAdTFmnvwNT5OTdc6zQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=ABLosHbA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GmKk7qR0; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-08.internal (phl-compute-08.phl.internal [10.202.2.48])
	by mailfout.phl.internal (Postfix) with ESMTP id 7BBD7138012D;
	Thu, 17 Oct 2024 04:23:56 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 17 Oct 2024 04:23:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1729153436; x=
	1729239836; bh=S+oeyrBXw3nGPntY41yaCTg/6DEfwIvZNsKzRzEm0y4=; b=A
	BLosHbAsPPQW12tOkQo0SMRPbKqz8N/YGstIZ5XdSsV3dgpfkPX0D7/rGu7sSUFt
	S2havpUmdWr5PQFbvkYMRsYAR4DZXWD+1iWlWCvarUmnWhFWToWO8qG/qQZWDRKF
	paXdPip6gI+2+28vSVCsv2qO43zTsO2el/U6yAv0M4W0Q4yT1TSvP4CNGEMDPakF
	e71fihDbkBXQpHbCV/qreKhkzSOZeCC6z3aMFufDJOVB9Tvm/wIlZN3eMhxNuywu
	aNOcOSYrnLFsi0u6neOZRQYOO7sobBQVJ2448zqxMzdIEPYN5rn4WR48LXc9ZjPI
	m9Om5BFEvizkkoQ4kR2uA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1729153436; x=1729239836; bh=S+oeyrBXw3nGPntY41yaCTg/6DEf
	wIvZNsKzRzEm0y4=; b=GmKk7qR0j0pf5DR2z5QPp9oHBgAUsE5TTb1WRKvrzH9W
	9VR5VYL1LGT9MHNVVFxkppxp9XCJR4hcw0RvunlRnJzC8AtamBxE3EsRt4mNb8WE
	cHxOn7ieJGEcxqETJWArJ+l5gErLcloUIn6BLvUsNSN8mKPTKwKr1uKHLVTTADxK
	cjpnF24tYm4fYTLN/EaZTibOxYTxSkjzUz6ewdnRuh4Z1uD8VHXm0Hxt0GpxVDH6
	UDBo5gljj46MV480s396tD8Qjn+5oKAuJqg/WkOj31GazctQuorTimGWW8+9sOgh
	0BC4aaA+DiZlyNxkaWyq9P3Omaq2PfrLug/NW1SOXw==
X-ME-Sender: <xms:m8kQZ502zBS5pIaHkeMAf61LGICrzXfqGUsTTakxdNja2GFEFs-_WQ>
    <xme:m8kQZwFrthpnVeQ4pOriiyBFjCPfaxL1i_6LZu4JaCtvkYSshg9VXC0F1Us26IQIF
    OrgxbFZwyKBI38Gxmo>
X-ME-Received: <xmr:m8kQZ57NGr45XW0vArsJ4qKoD5v_iflF8DV8NGc3CI8KXTKRynLhkkT8yKL6j0b43tuWsQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdehuddgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvden
    ucfhrhhomhepfdfmihhrihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilhhlse
    hshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeeltedugedtgfehuddu
    hfetleeiuedvtdehieejjedufeejfeegteetuddtgefgudenucffohhmrghinhepkhgvrh
    hnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhope
    dukedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepnhgvvghrrghjrdhuphgrughh
    higrhiesrghmugdrtghomhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvg
    hrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihig
    rdguvgdprhgtphhtthhopehmihhnghhosehrvgguhhgrthdrtghomhdprhgtphhtthhope
    gurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpthhtohep
    thhhohhmrghsrdhlvghnuggrtghkhiesrghmugdrtghomhdprhgtphhtthhopehnihhkuh
    hnjhesrghmugdrtghomhdprhgtphhtthhopehsrghnthhoshhhrdhshhhukhhlrgesrghm
    ugdrtghomhdprhgtphhtthhopehvrghsrghnthdrhhgvghguvgesrghmugdrtghomh
X-ME-Proxy: <xmx:m8kQZ23ssNxLswwliumbNBYTx4UuvaD5Ou9LOY16q4lKInktjJZo7g>
    <xmx:m8kQZ8FcfqIQtDzRxhZds1v1njnLZNuzD1bDZAkqnZnCpwS7CVMcxg>
    <xmx:m8kQZ3-A9Rc5ey4hZrE44Qllgyi3HpQVI3Oq_RUKH6l7tDF07K-R1A>
    <xmx:m8kQZ5lhq85RFmlCtVGVsJpA-EuvGzxTRJae5aKQTwO4LTckEzAN2g>
    <xmx:nMkQZ6_NPSnfGra52_kpnDW4ByyWlHmxPxcrD5TZRrXjvYGw13qIbHKc>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Oct 2024 04:23:49 -0400 (EDT)
Date: Thu, 17 Oct 2024 11:23:45 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com, 
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de, 
	David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org, 
	seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 00/14] AMD: Add Secure AVIC Guest Support
Message-ID: <vo2oavwp2p4gbenistkq2demqtorisv24zjq2jgotuw6i5i7oy@uq5k2wcg3j5z>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>

On Fri, Sep 13, 2024 at 05:06:51PM +0530, Neeraj Upadhyay wrote:
> Introduction
> ------------
> 
> Secure AVIC is a new hardware feature in the AMD64 architecture to
> allow SEV-SNP guests to prevent hypervisor from generating unexpected
> interrupts to a vCPU or otherwise violate architectural assumptions
> around APIC behavior.
> 
> One of the significant differences from AVIC or emulated x2APIC is that
> Secure AVIC uses a guest-owned and managed APIC backing page. It also
> introduces additional fields in both the VMCB and the Secure AVIC backing
> page to aid the guest in limiting which interrupt vectors can be injected
> into the guest.
> 
> Guest APIC Backing Page
> -----------------------
> Each vCPU has a guest-allocated APIC backing page of size 4K, which
> maintains APIC state for that vCPU. The x2APIC MSRs are mapped at
> their corresposing x2APIC MMIO offset within the guest APIC backing
> page. All x2APIC accesses by guest or Secure AVIC hardware operate
> on this backing page. The backing page should be pinned and NPT entry
> for it should be always mapped while the corresponding vCPU is running.
> 
> 
> MSR Accesses
> ------------
> Secure AVIC only supports x2APIC MSR accesses. xAPIC MMIO offset based
> accesses are not supported.
> 
> Some of the MSR accesses such as ICR writes (with shorthand equal to
> self), SELF_IPI, EOI, TPR writes are accelerated by Secure AVIC
> hardware. Other MSR accesses generate a #VC exception. The #VC
> exception handler reads/writes to the guest APIC backing page.
> As guest APIC backing page is accessible to the guest, the Secure
> AVIC driver code optimizes APIC register access by directly
> reading/writing to the guest APIC backing page (instead of taking
> the #VC exception route).
> 
> In addition to the architected MSRs, following new fields are added to
> the guest APIC backing page which can be modified directly by the
> guest:
> 
> a. ALLOWED_IRR
> 
> ALLOWED_IRR vector indicates the interrupt vectors which the guest
> allows the hypervisor to send. The combination of host-controlled
> REQUESTED_IRR vectors (part of VMCB) and ALLOWED_IRR is used by
> hardware to update the IRR vectors of the Guest APIC backing page.
> 
> #Offset        #bits        Description
> 204h           31:0         Guest allowed vectors 0-31
> 214h           31:0         Guest allowed vectors 32-63
> ...
> 274h           31:0         Guest allowed vectors 224-255
> 
> ALLOWED_IRR is meant to be used specifically for vectors that the
> hypervisor is allowed to inject, such as device interrupts.  Interrupt
> vectors used exclusively by the guest itself (like IPI vectors) should
> not be allowed to be injected into the guest for security reasons.
> 
> b. NMI Request
>  
> #Offset        #bits        Description
> 278h           0            Set by Guest to request Virtual NMI
> 
> 
> LAPIC Timer Support
> -------------------
> LAPIC timer is emulated by hypervisor. So, APIC_LVTT, APIC_TMICT and
> APIC_TDCR, APIC_TMCCT APIC registers are not read/written to the guest
> APIC backing page and are communicated to the hypervisor using SVM_EXIT_MSR
> VMGEXIT. 
> 
> IPI Support
> -----------
> Only SELF_IPI is accelerated by Secure AVIC hardware. Other IPIs require
> writing (from the Secure AVIC driver) to the IRR vector of the target CPU
> backing page and then issuing VMGEXIT for the hypervisor to notify the
> target vCPU.
> 
> Driver Implementation Open Points
> ---------------------------------
> 
> The Secure AVIC driver only supports physical destination mode. If
> logical destination mode need to be supported, then a separate x2apic
> driver would be required for supporting logical destination mode.
> 
> Setting of ALLOWED_IRR vectors is done from vector.c for IOAPIC and MSI
> interrupts. ALLOWED_IRR vector is not cleared when an interrupt vector
> migrates to different CPU. Using a cleaner approach to manage and
> configure allowed vectors needs more work.
> 
> 
> Testing
> -------
> 
> This series is based on top of commit 196145c606d0 "Merge
> tag 'clk-fixes-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux."
> 
> Host Secure AVIC support patch series is at [1].
> 
> Following tests are done:
> 
> 1) Boot to Prompt using initramfs and ubuntu fs.
> 2) Verified timer and IPI as part of the guest bootup.
> 3) Verified long run SCF TORTURE IPI test.
> 4) Verified FIO test with NVME passthrough.

One case that is missing is kexec.

If the first kernel set ALLOWED_IRR, but the target kernel doesn't know
anything about Secure AVIC, there are going to be a problem I assume.

I think we need ->setup() counterpart (->teardown() ?) to get
configuration back to the boot state. And get it called from kexec path.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

