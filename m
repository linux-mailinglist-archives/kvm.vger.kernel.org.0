Return-Path: <kvm+bounces-44199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BFB4A9B460
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 18:43:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD9123B7870
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AEE928A1CF;
	Thu, 24 Apr 2025 16:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rVSZUf1F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A58028A1EE
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 16:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745513007; cv=none; b=DyGS0LtKMtgvE/o1meefpkFPZuNg1su0emvaWeeLXrEOEzjjsehky2oM3MbYO4Eq08n0AMtelEtxAHkJo7YHsPfpF+THcfaHgru9IxI9Bbf5H99pYTZ+N/VOSH+St/KmRJOM/60uXMNxMB9cvVcGVbLFF1H8ihArPme2qu7OrmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745513007; c=relaxed/simple;
	bh=90CWwwHEFJv30peHy5c0A+eq76UrWGSZRoZ6Mg3LII0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vt0cS4sV8B6QDdJBhhfthFk3hY3KhOX+vb91f1LWInuz//TbYhknhGjvYeFcmzro86toVUZ8T44k/g9rZHVY+HsGacM14jNk3t11yauwIIN/JGbJirRt1UbzQoMxhyPj+hdTnn07KyxZSNjA5fjh9HgNEYe8n0nWvEcxT18Z3t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rVSZUf1F; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-39c31e4c3e5so889026f8f.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 09:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745513002; x=1746117802; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WSuNi6jgd7WcC/uM9d2T2xs48Ig9Zxtluh/Uj+qej/g=;
        b=rVSZUf1FO5nmQO6dWvkfKEgbeS8dnkhWyv4ssm/4OyQQ5jCSQBjLikDdU6Gr4LSA2H
         SIANwuvQ5WplGjIAHr1zX9K8wwn0laBk9tgvccwgJyK44BTxrMQndGvX5TqJNAa4jFne
         YpzK5U4hcXBUyhnpDxh+7USrWHOd+qzfTWT2I+m92W5gwsiEBNHmVnJr5QxV+lQzAwKe
         zfxtBF995bSayCzwialATpHVcr3NSMDPM+eztVTtqKpz36/4kxpd+PbxonuGjmL2ssF7
         kcrJYGKQCYoNovRW2EkDjt6i3si5zuYtO22C44U6RKMcoYceiADheRxNzptHOknA+2jg
         0qfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745513002; x=1746117802;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WSuNi6jgd7WcC/uM9d2T2xs48Ig9Zxtluh/Uj+qej/g=;
        b=PxBdv2xr+la5wr8nRmoMH0piTFoqHusA8+KOy9tqyQjCyYfj52ulKbwIyu2nt3Y57g
         R2jqb2Soh4Xs/FjNBBhPE2nTw7+N2TLpL2Ya7yE7mlNvix4STylyVongIkzVfUPlexw9
         A5+wcLH2ehRP0iOUquGNvU1bhNv/WxXo8wM36CrkLnD3OPKjDqfxxzzLLQNduWKmES7a
         qUlc4N5Fo7y/pLjEwQQNGwzGT3pIW1KpIYt80iom4UMXWNMsoRjhULavCHHDEUoyUQYr
         ZjAxnj0iyGBy/dwIe4irAJzaDJ3z2dNU1uImNgEJonBtN3PpZlCzuLw04aTeRZNqXjVd
         WnKQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7rsE8rZzFc+ec3XXQELE8YWTTHCc2nI9yfDWqfRavaqxW/tLcb302GeMrcitZ+GwBuaw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0u3s7TX3e14mZ9fX8N9LVt0ZcXiEq0NgLl1N8ObtqG8dHnOA2
	WLeKEzX7jYuTwglaAS9WvcTEfbvpbkbSCP6JFYF8M/NxysshzVcyR54wK+l2E4g=
X-Gm-Gg: ASbGncsP4rAVwQuTMJm7BcFFKpu4g4sQj7Nap/t0SRJPlj3lwq3rgrU+wuGi5UVTlkj
	G9iGezMK6JWu7DGPOZeg6lu0STj8OcRvzu23ZtebUbYWvOqkwhP1rTu7mPPVhp/x0uEJstt9IGG
	C1YfcCG9WOuuRefe+ORk/Zxzz9ZjuC63c4o0SwShb5KOjRR6q4kun7G9XKSt4mH9BITOkwdq0wE
	Tdh58IeHmk52V0rBlV9iWLhzBuGszwEn34IIP6N12M45PP16205fzATB0GrXzxYD8bZSWSqIXUg
	u/LKHwbfmgwGkizlAbkFIDuLWNKhWUEf1W1vli2LWMLISw==
X-Google-Smtp-Source: AGHT+IHYTqxFiUW0T1o5BtOdgRWCYlL7vEIbg3oFVcl1woXhmq4i0bj5/vY1/MFeshm4lNN8UbGb1g==
X-Received: by 2002:a05:6000:1a8b:b0:391:4095:49b7 with SMTP id ffacd0b85a97d-3a072ac3e07mr50047f8f.25.1745513002496;
        Thu, 24 Apr 2025 09:43:22 -0700 (PDT)
Received: from linaro.org ([2001:630:3c1:90:97e6:f326:b9e:1a85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4c30e2sm2611539f8f.48.2025.04.24.09.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 09:43:22 -0700 (PDT)
Date: Thu, 24 Apr 2025 17:43:19 +0100
From: Karim Manaouil <karim.manaouil@linaro.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>, Rob Herring <robh@kernel.org>,
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
Message-ID: <20250424164319.p7a4qgmzn7jb7txz@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
 <aApaGnFPhsWBZoQ2@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aApaGnFPhsWBZoQ2@linux.dev>

On Thu, Apr 24, 2025 at 08:34:50AM -0700, Oliver Upton wrote:
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

Hi Oliver,

Thanks for your reply! I very much expected this take and my discussion
with Qauclomm engineers also more or less had the same conclusion. There
was a previous effort to go into this direction, but it never got
implemented, so this was my (no bullshit) attempt at doing that!

I believe that Qcom are more interested in having their own driver,
instead (as Trilok pointed out in another thread). But this port could
still be interesting for those who wanted to see KVM in EL1.

On the positive side, you get all the userspace tools (Qemu, Crosvm,
kvmtool, cloud-hypervisor, firecracker) working with minimal effort.

Cheers
Karim

