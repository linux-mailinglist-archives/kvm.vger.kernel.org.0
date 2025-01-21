Return-Path: <kvm+bounces-36088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A86E4A1772B
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 07:03:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE4F316A5B3
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 06:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A68185920;
	Tue, 21 Jan 2025 06:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="Wu7EJmvv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7833D6A
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 06:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737439418; cv=none; b=WCY4L/kyc/l/yDUbBOKSUpdniEvqw4wKo+0Os/3DG0HNAW2NKjdRwX7hwi9H4x6ju/D5GLm1BLLus6VemfDI+XGXsq2qdR9rxbvR5SM/9VNTa2np4TJwRrq5ntbn6TBCbBQ/wPo7PxaEWIfOI2bPak0Ts5gZo0On8OFQy/hz7EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737439418; c=relaxed/simple;
	bh=/m5vQYZTdQ/WFQfN/eHdTFWqddZXNNA9CMeL15MdoGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iZxyZ1ykmu0hMZA/Xi2R8BBkTXgPc0VZJt+A6ioz4SCErhU+bzJPsMeyZ3fD6H5lPpMOVdxAve3/DBfyApkrITOCmNH+PUhLPI8wIYjZ5X7cuyXSiUMiRlV40ornNWp3xIgJE5yzvakVIYdmAOuhwsyPRUTYj0WqkSAMFJ7GfR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=Wu7EJmvv; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2efd81c7ca4so6995691a91.2
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 22:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1737439414; x=1738044214; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wF4cOYbAGgO/RufcLN3HIyG7NCa0ScnR/GNeXKWmqEY=;
        b=Wu7EJmvvXs6fxQNM2sEpLVpWtVahpbZNSNrgRwvdiTZun+44VKP92uIpEPskyW83KZ
         YL2Aybk2Nq1poWBBH6eOJgMRUW0m+it7HlMA/1h4YmlcVZNB64l1QZ0+vbYjD67nm45x
         RoPz0f3Ps9jrb1VywuE16cX/SGszukvYWP3Pipkmbd2a39yLJAlETQkSEW9xMg4DOhW0
         GRpZcSeg6PO7jINtBJaFYlWwJdnuAiD6VfsuejW+KBQlKzDQCBgpWwk03e1g3d95gZkC
         A5UkawBHgM9GmaZRfgRmDe31IKYjy+K0zD8Uk7NOjEpD1zBWAKN5D1Uq1wxVrUmshqhu
         rSoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737439414; x=1738044214;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wF4cOYbAGgO/RufcLN3HIyG7NCa0ScnR/GNeXKWmqEY=;
        b=TBy/fWP9nOPR2WxymezWlkj7vyLb4ICb6SWAy/z5jRtbLVMJLpfTXzd1u7vl0VnJVr
         +UE1un7IG9Yp4veG7KMe55FDQ5eUICbchAny3IGgZLJUxKr1plA3rNJBNd8HQJxCAEcA
         GILUVEQiYV4inCYLQEB7BFX8G7b06g9MkUedX6o9zSbAMW7lVNAOawPzfwx6pWQ0CPgI
         kdjaOh7aWRXd1Hl9VCBjWggNa7bfL+N+RaGLg44sXIODZUlxihzM4jnP1qHXf/DLTtZE
         PL19eIxOIc8jy7Pp92K7XyrEtw2G0NYUXv3PokqcrjIqpqHJ+J51rrolKWptqdknuwYc
         D5Eg==
X-Forwarded-Encrypted: i=1; AJvYcCUUSGYLUV6lKR/zcvwPQEllefSPP/TjoHAsxU2Dr0G0JngpG/EufrPStn7uFbOT7CXSQnc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz49OPvM2CFyKpSjGhPhGBzNjuatTUz48WhqsIlU6sNFF+BuWI0
	xKD0EE+Y9OqMMpkkFxVke1nNgp4YgexAeySQoJOP10EUbu5k32Oq/P1lXUYIRTiHBzvtlLr842S
	ZmsSEkrFBUfnPTKXNSkxh/eXwqdPM5raOlWNVsFp6Rb0=
X-Gm-Gg: ASbGncuL3xv6if7xXysFC4toCYfJfN9FlGgXU4ZcfJiBYB5yjIO/pSbLPS1dryrv4kX
	anhm4rCiNphY7GOGmuVF9m/TS7sgjW41SB/sutbD5OntzgFzBt7swZoiLXS8Y1jyP3wH4IxK3UF
	LRuPskTuqgf8yD7SeBgD+9zRWALBBF6Mdsf2kmGBSkO5PDOqgsUsLGv2FkPOCZ2mga3vzJZy3aV
	jUpyHsKHrTIn0uBUVIq1xzpzcE1xwKmpMoKc0sj5whzloD8r3Q/dKx3pBgRmrdgz87accLFA9Rb
	cN9DuJZG9CXECfmMQkSZ2atozUIErp1e
X-Google-Smtp-Source: AGHT+IFYx8DTwR4EYN24qsSl35fQVXwjk20eSy/eyrx/w4w7hv/zybodC9ah8qtt+C9HHOtDYV5LZA==
X-Received: by 2002:a05:6a00:3487:b0:725:456e:76e with SMTP id d2e1a72fcca58-72daf94f68dmr21324015b3a.6.1737439413834;
        Mon, 20 Jan 2025 22:03:33 -0800 (PST)
Received: from zenbook (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab9c8b3dsm8465180b3a.95.2025.01.20.22.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 22:03:33 -0800 (PST)
Date: Tue, 21 Jan 2025 14:04:26 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Bjorn Andersson <andersson@kernel.org>, 
	Christoffer Dall <christoffer.dall@arm.com>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	Chase Conklin <chase.conklin@arm.com>, Eric Auger <eauger@redhat.com>, r09922117@csie.ntu.edu.tw
Subject: Re: [PATCH v2 09/12] KVM: arm64: nv: Propagate
 CNTHCTL_EL2.EL1NV{P,V}CT bits
Message-ID: <2uvoet55pchhcwafgdkcjca5m4mrvtwpgbmg4gmltimv62oauo@p4cipsni3a2q>
References: <20241217142321.763801-1-maz@kernel.org>
 <20241217142321.763801-10-maz@kernel.org>
 <qbmqsm3llnpy2t4ig3uyggkapwlbox2wnfu52gksbhcq4vfpqx@dz5bbn3asn5s>
 <86wmetv57c.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86wmetv57c.wl-maz@kernel.org>
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Fri, Jan 17, 2025 at 03:19:03PM +0000, Marc Zyngier wrote:
> On Mon, 06 Jan 2025 02:33:39 +0000,
> Wei-Lin Chang <r09922117@csie.ntu.edu.tw> wrote:
> > 
> > Hi Marc and other KVM ARM developers,
> > 
> > I have a question while learning about NV and reading the code:
> > 
> > On Tue, Dec 17, 2024 at 02:23:17PM +0000, Marc Zyngier wrote:
> > > Allow a guest hypervisor to trap accesses to CNT{P,V}CT_EL02 by
> > > propagating these trap bits to the host trap configuration.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/arch_timer.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> > > index 6f04f31c0a7f2..e5951e6eaf236 100644
> > > --- a/arch/arm64/kvm/arch_timer.c
> > > +++ b/arch/arm64/kvm/arch_timer.c
> > > @@ -824,6 +824,10 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
> > >  	 * Apply the enable bits that the guest hypervisor has requested for
> > >  	 * its own guest. We can only add traps that wouldn't have been set
> > >  	 * above.
> > > +	 * Implementation choices: we do not support NV when E2H=0 in the
> > > +	 * guest, and we don't support configuration where E2H is writable
> > > +	 * by the guest (either FEAT_VHE or FEAT_E2H0 is implemented, but
> > > +	 * not both). This simplifies the handling of the EL1NV* bits.
> > 
> > Previously I was not aware that KVM ARM has these constraints on guest's
> > view of NV and E2H, so I appreciate this comment very much. However,
> > after digging through the code I could not find anywhere where these
> > constraints are enforced, for example initially I thought I would find
> > ID_AA64MMFR2_EL1_NV being zeroed in limit_nv_id_regs(), or HCR_NV added
> > to the res0 mask of HCR_EL2, base on whether FEAT_VHE or FEAT_E2H0 is
> > available to the guest. But seems like in these places the code applies
> > constraints looking at the host's capabilities, not the guest's.
> > Do you mind providing some pointers for me to investigate the code mode?
> 
> Where have you looked?
> 
> These constraints are enforced in the kvm-arm64/nv-e2h-select
> branch[1], which is pulled in the kvm-arm64/nv-next branch[2].
> 
> The NV support is split in discrete series in order to make things
> easier to review, but you need to have seen them all to somehow
> connect the dots.

Ah, that makes sense. I was only looking at kvmarm/next, and wasn't
really sure what the other branches are up to.
Thanks for telling me, looks like I got a lot more (complex) code to
study. :)

Sincerely,
Wei-Lin Chang

> 
> HTH,
> 
> 	M.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-e2h-select
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-next
> 
> -- 
> Without deviation from the norm, progress is not possible.

