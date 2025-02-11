Return-Path: <kvm+bounces-37867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D3B5FA30D45
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 14:47:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E30041887C27
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 13:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A80072451F3;
	Tue, 11 Feb 2025 13:47:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 588B522FF2D
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 13:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739281658; cv=none; b=n4TiI6oXgYBDW8ltPA1AUOUsePNNXUHIC8PrXuyS9GASrhrtvPn4vuwFRqazlTkfgZAhnDiAg56B0sHSw39WqnrXQ3/2LXKIOSHuZMzeXsuyxUWfjfm/enMqPrKVvFl+7dm3M6FOREnVotCbmK/nZjLBPFh455nZPMvuH6XGYSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739281658; c=relaxed/simple;
	bh=PdQm+xL1Pj3Uwf7XrxkK34M56oXXXA1TOTc6ZlfvWUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hqfRbmcYzrzgTYL0WaUT8tZVrbcD+GOy3RwH07sE7accQvUFIv/zVc33wAdNDaiPmlVsQ2Mmw8LGz3HWegpVGvzuFIecZLqeF4AbU4w5G4aYaAi0p4KsYOEwV9Pq9NfCFlsNfOyz83FnVd32CcpmtNGF6nSKCjdwu19F3PIYxdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED4C71424;
	Tue, 11 Feb 2025 05:47:56 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 29F513F5A1;
	Tue, 11 Feb 2025 05:47:34 -0800 (PST)
Date: Tue, 11 Feb 2025 13:47:28 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 06/18] KVM: arm64: Plug FEAT_GCS handling
Message-ID: <Z6tU8IyAr8lp9IYI@J2N7QTR9R3>
References: <20250210184150.2145093-1-maz@kernel.org>
 <20250210184150.2145093-7-maz@kernel.org>
 <Z6tEUzwcHVHALIdu@J2N7QTR9R3>
 <861pw4txhh.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861pw4txhh.wl-maz@kernel.org>

On Tue, Feb 11, 2025 at 01:35:54PM +0000, Marc Zyngier wrote:
> On Tue, 11 Feb 2025 12:36:35 +0000,
> Mark Rutland <mark.rutland@arm.com> wrote:
> > On Mon, Feb 10, 2025 at 06:41:37PM +0000, Marc Zyngier wrote:

> > > +static int kvm_handle_gcs(struct kvm_vcpu *vcpu)
> > > +{
> > > +	/* We don't expect GCS, so treat it with contempt */
> > > +	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
> > > +		WARN_ON_ONCE(1);
> > 
> > Just to check / better my understanging, do we enforce that this can't
> > be exposed to the guest somewhere?
> > 
> > I see __kvm_read_sanitised_id_reg() masks it out, and the sys_reg_descs
> > table has it filtered, but I'm not immediately sure whether that
> > prevents host userspace maliciously setting this?
> 
> On writing to the idreg, you end-up in set_id_aa64pfr1_el1(), which
> calls into set_id_reg(). There, arm64_check_features() compares each
> and every feature in that register with the mask and limits that have
> been established.
> 
> Since GCS is not part of the writable mask, and that it has been
> disabled, the only valid value for ID_AA64PFR1_EL1.GCS is 0. A
> non-zero value provided by userspace will be caught by the last check
> in arm64_check_features(), and an error be returned.

Perfect, thanks!

Mark.

