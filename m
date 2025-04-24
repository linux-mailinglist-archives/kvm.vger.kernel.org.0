Return-Path: <kvm+bounces-44200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F4C9A9B4BF
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 18:57:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3360D3BFF4C
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF8D428B4E8;
	Thu, 24 Apr 2025 16:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LlhhasIs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C1E27FD53;
	Thu, 24 Apr 2025 16:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745513838; cv=none; b=szPMwO4SE0jWeOfDMfKLV6Mu0QRzqSCbZtzVbbO412IorACE2uU04niU3vFenNhSi9hdJ/qiTSOGFuSuxmJHJEs7m8cedJxJTlcU2/7cpdMoXbhvzrusjc0XUURTIn4XpZ8duML65gobVq/AnuGZgW/z1l8icQ2dNtt5oXYCg5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745513838; c=relaxed/simple;
	bh=MZYbKW86/HMaRiBQ4n+IZSKyzM9Ux5Yala+dzSbAgCY=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hPY/M5e0uSoesiejGrLJGHJrDWPn+d8IvunIzqblbdgqsAnzyXy9EjUF79Ntk6P/8tKru1sOG87X/IJobZhF/kb4owg9YPWtdKiETEBLe4eWFCIlEm5jSubzxuUbF/NsVpqAcPDgwyyDuk545h+JIaiJduMPLgiEm7Nr0OkSFnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LlhhasIs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794E1C4CEE8;
	Thu, 24 Apr 2025 16:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745513837;
	bh=MZYbKW86/HMaRiBQ4n+IZSKyzM9Ux5Yala+dzSbAgCY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LlhhasIsoavw/7NHjZZLeXJJpSHC8/xpWdCwOEHhmAyNdXrFUKgxTLFX21nEp8IGe
	 En+atfR3S91hqgFj3lbmdLhHCnN+v3SVODgISBHm/L2mtrKvORnTd55itoeOL/pxXf
	 36EhX0LcqYeGFbeJsklgwrQrNrBJwNPDQ58oY0ip7ZLzfmAONrLA5zBAHXn8gWSg/j
	 hA9Zy0eaCf1VJfJn2MctM6QSLbCEoLghCQStI7XxROWvS85G/x5GfnC4k0b9ZI3+vB
	 Gm68DJs7pGOZOH7k/TXFWCBRaO1D0JNZH/qjheQ+MUhIexcUSjph2WNq2S9GGX3hVe
	 2FK9MXd7ju1oA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u7zsw-008TLp-Rz;
	Thu, 24 Apr 2025 17:57:15 +0100
Date: Thu, 24 Apr 2025 17:57:14 +0100
Message-ID: <86ikmtjy51.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Karim Manaouil <karim.manaouil@linaro.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: 	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>
Subject: Re: [RFC PATCH 00/34] Running Qualcomm's Gunyah Guests via KVM in EL1
In-Reply-To: <aApaGnFPhsWBZoQ2@linux.dev>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
	<aApaGnFPhsWBZoQ2@linux.dev>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/29.4
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: karim.manaouil@linaro.org, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, graf@amazon.com, elder@kernel.org, catalin.marinas@arm.com, tabba@google.com, joey.gouly@arm.com, corbet@lwn.net, broonie@kernel.org, mark.rutland@arm.com, pbonzini@redhat.com, quic_pheragu@quicinc.com, qperret@google.com, robh@kernel.org, srini@kernel.org, quic_svaddagi@quicinc.com, will@kernel.org, haripran@qti.qualcomm.com, cvanscha@qti.qualcomm.com, mnalajal@quicinc.com, sreeniva@qti.qualcomm.com, tsoni@quicinc.com, stefan.schmidt@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 24 Apr 2025 16:34:50 +0100,
Oliver Upton <oliver.upton@linux.dev> wrote:
> 
> On Thu, Apr 24, 2025 at 03:13:07PM +0100, Karim Manaouil wrote:
> > This series introduces the capability of running Gunyah guests via KVM on
> > Qualcomm SoCs shipped with Gunyah hypervisor [1] (e.g. RB3 Gen2).
> > 
> > The goal of this work is to port the existing Gunyah hypervisor support from a
> > standalone driver interface [2] to KVM, with the aim of leveraging as much of the
> > existing KVM infrastructure as possible to reduce duplication of effort around
> > memory management (e.g. guest_memfd), irqfd, and other core components.
> > 
> > In short, Gunyah is a Type-1 hypervisor, meaning that it runs independently of any
> > high-level OS kernel such as Linux and runs in a higher CPU privilege level than VMs.
> > Gunyah is shipped as firmware and guests typically talk with Gunyah via hypercalls.
> > KVM is designed to run as Type-2 hypervisor. This port allows KVM to run in EL1 and
> > serve as the interface for VM lifecycle management,while offloading virtualization
> > to Gunyah.
> 
> If you're keen on running your own hypervisor then I'm sorry, you get to
> deal with it soup to nuts. Other hypervisors (e.g. mshv) have their own
> kernel drivers for managing the host / UAPI parts of driving VMs.
> 
> The KVM arch interface is *internal* to KVM, not something to be
> (ab)used for cramming in a non-KVM hypervisor. KVM and other hypervisors
> can still share other bits of truly common infrastructure, like
> guest_memfd.
> 
> I understand the value in what you're trying to do, but if you want it
> to smell like KVM you may as well just let the user run it at EL2.

+1. KVM is not a generic interface for random third party hypervisors.

If you want to run KVM on your Qualcomm HW, boot at EL2, and enjoy the
real thing -- it is worth it. If Gunyah is what you want, then there
is enough code out there to use it with crosvm.

But mixing the two is not happening, sorry.

	M.

-- 
Without deviation from the norm, progress is not possible.

