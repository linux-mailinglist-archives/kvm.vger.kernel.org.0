Return-Path: <kvm+bounces-26681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72F0697664D
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 12:04:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BEA0283DD2
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 10:04:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BDF919F419;
	Thu, 12 Sep 2024 10:04:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0910219341C
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 10:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726135482; cv=none; b=roVri2y0XyO//F7ENueuRn7vb4xpc2SFeJe9ZxPIzdNfJa/b1mnteNKao1QYWkWmRgI8icjscbjsChTT+ECvaCzH/DqaJqjfhYQ/kU9nW3KgZjkuP10mrl63FY/jvgQuYj0H1/oIlxl0DSdP7fjTjEt+9TwGNi9yeeFnP+B/9m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726135482; c=relaxed/simple;
	bh=9g5kxZXNC+JzmL6CmFu2yIDGL/vmZExNTwoAcSSACkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dMBo1sFmMXbQcm1w3D84H32yumSAvgeK3OfdLWlN0bBvf6g7BYI+qpWqtkbLPOJgYE9IDZ9ODYTzF2HczInJ4TIl600kFnG6Lu7IezcjG0bdAC0321s+2tGNUV0Tm3P71BeOMTvehfZ471MsYp9Of9zkCnajk4uurndChmdbSgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B82D6DA7;
	Thu, 12 Sep 2024 03:05:09 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D10A63F73B;
	Thu, 12 Sep 2024 03:04:38 -0700 (PDT)
Date: Thu, 12 Sep 2024 11:04:33 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 18/24] KVM: arm64: Split S1 permission evaluation into
 direct and hierarchical parts
Message-ID: <20240912100433.GA1162893@e124191.cambridge.arm.com>
References: <20240911135151.401193-1-maz@kernel.org>
 <20240911135151.401193-19-maz@kernel.org>
 <20240911141513.GA1080224@e124191.cambridge.arm.com>
 <86o74u6vzu.wl-maz@kernel.org>
 <20240911155128.GA1087252@e124191.cambridge.arm.com>
 <86mske6ujn.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86mske6ujn.wl-maz@kernel.org>

On Wed, Sep 11, 2024 at 05:10:04PM +0100, Marc Zyngier wrote:
> On Wed, 11 Sep 2024 16:51:28 +0100,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > On Wed, Sep 11, 2024 at 04:38:45PM +0100, Marc Zyngier wrote:
> > > On Wed, 11 Sep 2024 15:15:13 +0100,
> > > Joey Gouly <joey.gouly@arm.com> wrote:
> > > > 
> > > > On Wed, Sep 11, 2024 at 02:51:45PM +0100, Marc Zyngier wrote:
> > > 
> > > [...]
> > > 
> > > > > +static void compute_s1_hierarchical_permissions(struct kvm_vcpu *vcpu,
> > > > > +						struct s1_walk_info *wi,
> > > > > +						struct s1_walk_result *wr,
> > > > > +						struct s1_perms *s1p)
> > > > > +{
> > > > 
> > > > How about:
> > > > 
> > > > 	if (wi->hpd)
> > > > 		return;
> > > 
> > > I was hoping not to add anything like this, because all the table bits
> > > are 0 (we simply don't collect them), and thus don't have any effect.
> > 
> > I just thought it was more obvious that they wouldn't apply in this case, don't
> > feel super strongly about it.
> 
> If you want it to be obvious, how about this instead?
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 8a5e1c4682619..fb9de5fc2cc26 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -985,7 +985,8 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu, u32 op,
>  	else
>  		compute_s1_indirect_permissions(vcpu, wi, wr, s1p);
>  
> -	compute_s1_hierarchical_permissions(vcpu, wi, wr, s1p);
> +	if (!wi->hpd)
> +		compute_s1_hierarchical_permissions(vcpu, wi, wr, s1p);
>  
>  	if (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) {
>  		bool pan;
> 

That's even better, if you're happy to include it.

> 
> Thanks,
> 
> 	M.

Thanks,
	J.

> 
> -- 
> Without deviation from the norm, progress is not possible.

