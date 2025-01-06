Return-Path: <kvm+bounces-34575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 547CBA01D99
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 03:35:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DA2F1880411
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 02:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46EDF1D86C0;
	Mon,  6 Jan 2025 02:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="INt6nZgz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018001D7E5B
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 02:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736130776; cv=none; b=XMjgg3GqcJJwJq9SjGWe9F79JRbowjNEyB3FGCmCcZH7avvXD2GP80IN4xzVIiR99iAIT4RyeSjYdB6QtSsXFWHsQBOaZ7womakE/Ea0hlLH+g9zjvzFo0QEz6IUrKepwK8ugs/3uD0aiC8pU8KleS4eMpp1hTI/GS4T5TEeRAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736130776; c=relaxed/simple;
	bh=7qa+op98IAU4gbyEANPQ1kB+n62Hq0ZlDURcfnIZoXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZT3jvV05BI6HeUO7gvettfUxMAkDMthY5+Dj5uhllSDCPpoFMBKmv8BxlIOEs5vTaGWKVEna7NV2XwoMOIxZrd/Z7ULWB7aVZqtm83dKHuYqvhfUPI0xXqo8GYceghizEKziF2I07yyptHNKslAMvceh7KcWr5Ot81i0E4kmCAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=INt6nZgz; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2eeb4d643a5so20291935a91.3
        for <kvm@vger.kernel.org>; Sun, 05 Jan 2025 18:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1736130773; x=1736735573; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hizUyDaKTky7G883O428eVAJirBV+mTazBL7cmKBgjA=;
        b=INt6nZgzcVbguxa4aG2FhMoizs3+rymMJOi/hGzFkauERLLSWupi9qTDwBDsdrityc
         QpdlrTuHWMl/78IQe2TGMRTUEIuaR8CedGakX+aPJ7SGwa4F+6AunXeEXO7XqtHCMT69
         qKrb7EiMHb/tG3lwCTwbKncyVDz2nkuQNTOBvhYPr0Ek+Za5xH/W/JvxnEVhrywtDYvr
         kRkrQ69SkZjFUP/gEjsDmwuyZUhecKvpAn+5LrQ2Hp5Wb435cWpgSfT/r1qPjbXLgY2s
         ni45l7K6myjvwCNHWpXHPzYm8kOSJ5gs+R3Ng5pxDQjPHj5R0hjOppo+xsy3nsWMVxcj
         K2fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736130773; x=1736735573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hizUyDaKTky7G883O428eVAJirBV+mTazBL7cmKBgjA=;
        b=HI10AUiopAuh3vn+LgGDpiPlO5MSjdOazYJMk+yke7sShXSEmT3SbI4tuNWzq4QYX/
         w2400bcTOAIu8tmzTq57Qj9Z0jiZqDK0chO452U2HJ19CQ+kj5AB3ErIZ4rDRFxLzpn3
         RwI9vq7544xiRzknRgT1nQcBGUUbrHN3IXg4UHcMXLPvv5uEcCYM55K2x4UrS72dV3D/
         YK1VJvgKi7adYM9Iuo5r5P5OI9bj2pS+ppVDCVOMM9BGZlwetgLVFIS5UdqnELm7n6hJ
         acXEk6LHunaVxzrqfW06OSFNB0i3OVgZp0CcbyLLd3xapPEjsKCqwUayUmYVGIbcbo2s
         4Asw==
X-Forwarded-Encrypted: i=1; AJvYcCV8Q2B4X+tfCzTOO2Cfme/r78rlmVUlvQQg8De9+ZNJtn2Grz/piEztU1OVb65eWrbJ2g4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6loN9fCFWBgR8yBIHGavxI6BbdY7lKVZ53mypUP4Ww0un4le2
	i7J9l5dyH0PFnzbfUdyPX18MDssp/HMdMEVXDZfXuHIxwMEqHYWOqHq4HuX6bL6EVzwHPFJQsCX
	khFZZkk6zdv51/ezIe4/ZK+JJ+xbItx7Z7EfVwmq7Qzw=
X-Gm-Gg: ASbGncvm0LB7nOe305POTP0e42fqaEYTXWYDmrnEqlzHh4X8cdsjLStxKIwX615k1RB
	G5uTY/iRLpP/ZDahOWDzAm/vaVOvBYGd6kmBivBbYNaLZ+drWFfuivqmfXKEw2lu0MSr5pWhIr0
	IafwDPWZPljMvdw7E3SPPjf5Yj0XlUaP7Qosqyvbi2SrdU1TOTUYtQKEtb1xWUMSh1YCUK5CZf/
	ZxfzphdmSLpTPathNJo0EnrloDISVNMujGVJ5YyiFqW+6PL8yKeGvOjGlLQNKNbIHhUgbfL/RNM
	YE/ckM5/K5BUhTQI5R4=
X-Google-Smtp-Source: AGHT+IFlKEWP1PZp3HGGHASjNs+dk5FEFAFR9mW7wibwp+bi2To37zelGhRWfoPjkS8UwpaDLhX/vg==
X-Received: by 2002:a17:90a:d647:b0:2ee:c9dd:b7ea with SMTP id 98e67ed59e1d1-2f452eb12famr84759397a91.24.1736130773115;
        Sun, 05 Jan 2025 18:32:53 -0800 (PST)
Received: from zenbook (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f4478a9108sm36139009a91.43.2025.01.05.18.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2025 18:32:52 -0800 (PST)
Date: Mon, 6 Jan 2025 10:33:39 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Bjorn Andersson <andersson@kernel.org>, 
	Christoffer Dall <christoffer.dall@arm.com>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	Chase Conklin <chase.conklin@arm.com>, Eric Auger <eauger@redhat.com>, r09922117@csie.ntu.edu.tw
Subject: Re: [PATCH v2 09/12] KVM: arm64: nv: Propagate
 CNTHCTL_EL2.EL1NV{P,V}CT bits
Message-ID: <qbmqsm3llnpy2t4ig3uyggkapwlbox2wnfu52gksbhcq4vfpqx@dz5bbn3asn5s>
References: <20241217142321.763801-1-maz@kernel.org>
 <20241217142321.763801-10-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217142321.763801-10-maz@kernel.org>
X-Gm-Spam: 0
X-Gm-Phishy: 0

Hi Marc and other KVM ARM developers,

I have a question while learning about NV and reading the code:

On Tue, Dec 17, 2024 at 02:23:17PM +0000, Marc Zyngier wrote:
> Allow a guest hypervisor to trap accesses to CNT{P,V}CT_EL02 by
> propagating these trap bits to the host trap configuration.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arch_timer.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 6f04f31c0a7f2..e5951e6eaf236 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -824,6 +824,10 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
>  	 * Apply the enable bits that the guest hypervisor has requested for
>  	 * its own guest. We can only add traps that wouldn't have been set
>  	 * above.
> +	 * Implementation choices: we do not support NV when E2H=0 in the
> +	 * guest, and we don't support configuration where E2H is writable
> +	 * by the guest (either FEAT_VHE or FEAT_E2H0 is implemented, but
> +	 * not both). This simplifies the handling of the EL1NV* bits.

Previously I was not aware that KVM ARM has these constraints on guest's
view of NV and E2H, so I appreciate this comment very much. However,
after digging through the code I could not find anywhere where these
constraints are enforced, for example initially I thought I would find
ID_AA64MMFR2_EL1_NV being zeroed in limit_nv_id_regs(), or HCR_NV added
to the res0 mask of HCR_EL2, base on whether FEAT_VHE or FEAT_E2H0 is
available to the guest. But seems like in these places the code applies
constraints looking at the host's capabilities, not the guest's.
Do you mind providing some pointers for me to investigate the code mode?

Thank you so much, I'd appreciate any help.

Wei-Lin Chang

>  	 */
>  	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
>  		u64 val = __vcpu_sys_reg(vcpu, CNTHCTL_EL2);
> @@ -834,6 +838,9 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
>  
>  		tpt |= !(val & (CNTHCTL_EL1PCEN << 10));
>  		tpc |= !(val & (CNTHCTL_EL1PCTEN << 10));
> +
> +		tpt02 |= (val & CNTHCTL_EL1NVPCT);
> +		tvt02 |= (val & CNTHCTL_EL1NVVCT);
>  	}
>  
>  	/*
> -- 
> 2.39.2
> 

