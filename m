Return-Path: <kvm+bounces-33126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 720869E5496
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 12:51:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FF5F285448
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 11:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EB542139AF;
	Thu,  5 Dec 2024 11:51:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86784213246;
	Thu,  5 Dec 2024 11:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733399490; cv=none; b=jBEfCoIxLHx9oMBBwYOOixssJzYmd7T81xlF7tYtjaU7sYGec/I4IquYnzBOvj/vQlA/zKt7SYiKiVLnANLT57Gn4kh68YTvGVqwvTEn2SwmfE2qxsyMxVnwUwixhg22es9TcNbnZIS2L8RZS7EwKMpTEXpYR3IoNyZeTTtzxbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733399490; c=relaxed/simple;
	bh=wSnQs5Xy6npjlTaKWMPSCZO6w5wsRJLU+wS3qvlUF60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=reXlEw4QkLkTpSb6UfeLi3vWL2mpd3A9Gx6GW8kX9ECROF3v6FlssUE8eqxwmHTPDsybBfMXfyxKd0R6D0k1GDCsydaW7/ma9/tll0SGwmNgT7wI9u4qmNTILZPqnUj+RDCT8tNgeHUMVI3a/jLPsfKK1xrPG7LkM5oENy0bwgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2281BC4CED1;
	Thu,  5 Dec 2024 11:51:25 +0000 (UTC)
Date: Thu, 5 Dec 2024 11:51:23 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Sami Mujawar <sami.mujawar@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [PATCH v7 10/11] virt: arm-cca-guest: TSM_REPORT support for
 realms
Message-ID: <Z1GTu1kAV3J1cnJc@arm.com>
References: <20241017131434.40935-1-steven.price@arm.com>
 <20241017131434.40935-11-steven.price@arm.com>
 <6750c695194cd_2508129427@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6750c695194cd_2508129427@dwillia2-xfh.jf.intel.com.notmuch>

On Wed, Dec 04, 2024 at 01:16:05PM -0800, Dan Williams wrote:
> Steven Price wrote:
> > diff --git a/drivers/virt/coco/arm-cca-guest/Kconfig b/drivers/virt/coco/arm-cca-guest/Kconfig
> > new file mode 100644
> > index 000000000000..9dd27c3ee215
> > --- /dev/null
> > +++ b/drivers/virt/coco/arm-cca-guest/Kconfig
> > @@ -0,0 +1,11 @@
> > +config ARM_CCA_GUEST
> > +	tristate "Arm CCA Guest driver"
> > +	depends on ARM64
> > +	default m
> 
> I am working on some updates to the TSM_REPORTS interface, rebased them
> to test the changes with this driver, and discovered that this driver is
> enabled by default.
> 
> Just a reminder to please do not mark new drivers as "default m" [1]. In
> this case it is difficult to imagine that every arm64 kernel on the
> planet needs this functionality enabled by default. In general, someone
> should be able to run olddefconfig with a new kernel and not be exposed
> to brand new drivers that they have not considered previously.
> 
> [1]: http://lore.kernel.org/CA+55aFzxL6-Xp=-mnBwMisZsuKhRZ6zRDJoAmH8W5LDHU2oJuw@mail.gmail.com/

Fair point, the pKVM driver is also default off. At least with the arm64
defconfig, VIRT_DRIVERS is default off, so this wouldn't be built. But
an olddefconfig will indeed enable it (this reminds me to add the coco
drivers to my test configs).

-- 
Catalin

