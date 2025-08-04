Return-Path: <kvm+bounces-53932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E631DB1A73C
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 18:44:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0E5B18A32C1
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 16:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42F9528541F;
	Mon,  4 Aug 2025 16:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H4JRyZYl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A819284686
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 16:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754325835; cv=none; b=JdM8oXS7PoflgiYaaY21g6obPev5y89rVCmKoaPgvtyf15/O0JntkOdouVhYkGdgYHgUncVAoq5+xIBvpBITPxoh3Gkg0W5bbFYfpMwdW4rfFyBfFMRCZaZSMtA2epQH5akkZPDcpoCFF/dxnVQbGyYtAyB14JpkQHkZ+9wmfCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754325835; c=relaxed/simple;
	bh=HwwhvUJEgRxZzgYaIY7i/bxccq2glEeWYwIutuF1Two=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=eBZM87SYOjKwcD053LkEzHp8yOwHxMDT3jDEOsbubpKXT3pf6sYIjl7l7N9Fk9LJ00GLGKsZmR4ZmYALmOF2V+fWxM6j5VmpqQBwzJJ8gHApcacEFisL8dOc51g7SSQjGhCaHlaY5glZFWTp5lRuhGPJngkzv2nUsZOnJZC1E/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H4JRyZYl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7099C4CEE7;
	Mon,  4 Aug 2025 16:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754325834;
	bh=HwwhvUJEgRxZzgYaIY7i/bxccq2glEeWYwIutuF1Two=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=H4JRyZYlrPc5stxDRRVAkPlrAe9cOjB307fL67owawgAeM7VEfvighQ+8e2GVpBdh
	 tfk9TTjMWN4D+FfeYo9TVSp1BCO/rzMKWgdUf0emUgIPEDheUwu1c/RG1ctIouqQOV
	 bR0TGJQbiACBFM1g3j94ncUnA+Eyt2kyP9A30UEm6ZBxc4QIn2Lp7xrpI3djqgZhsN
	 v3QLih2xj1pJHbWtTEMCQ0OjIl1ogkEkMlrlGT5luDIPYdZiYIgJc/23t7pXIkFL6H
	 Pzde1r3z6sT99RXyfwJfdXRNouMVrwdlIBnDkDa75oAGzJxoNU+NOtaRYwM5tGRw7e
	 nf4809atviG5g==
Date: Mon, 4 Aug 2025 11:43:53 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me,
	alex.williamson@redhat.com, cohuck@redhat.com, jgg@ziepe.ca,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, mjrosato@linux.ibm.com, mgurtovoy@nvidia.com,
	linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
	Konrad.wilk@oracle.com, martin.petersen@oracle.com,
	jmeneghi@redhat.com, arnd@arndb.de, schnelle@linux.ibm.com,
	bhelgaas@google.com, joao.m.martins@oracle.com,
	Lei Rao <lei.rao@intel.com>
Subject: Re: [RFC PATCH 1/4] vfio-nvme: add vfio-nvme lm driver infrastructure
Message-ID: <20250804164353.GA3628649@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250803024705.10256-2-kch@nvidia.com>

On Sat, Aug 02, 2025 at 07:47:02PM -0700, Chaitanya Kulkarni wrote:
> Add foundational infrastructure for vfio-nvme, enabling support for live
> migration of NVMe devices via the VFIO framework. The following
> components are included:

> +static void nvmevf_pci_aer_reset_done(struct pci_dev *pdev)
> +{
> +	struct nvmevf_pci_core_device *nvmevf_dev = nvmevf_drvdata(pdev);
> +
> +	if (!nvmevf_dev->migrate_cap)
> +		return;
> +
> +	/*
> +	 * As the higher VFIO layers are holding locks across reset and using
> +	 * those same locks with the mm_lock we need to prevent ABBA deadlock
> +	 * with the state_mutex and mm_lock.

Add blank line between paragraphs.

> +	 * In case the state_mutex was taken already we defer the cleanup work
> +	 * to the unlock flow of the other running context.
> +	 */
> +	spin_lock(&nvmevf_dev->reset_lock);
> +	nvmevf_dev->deferred_reset = true;
> +	if (!mutex_trylock(&nvmevf_dev->state_mutex)) {
> +		spin_unlock(&nvmevf_dev->reset_lock);
> +		return;
> +	}
> +	spin_unlock(&nvmevf_dev->reset_lock);
> +	nvmevf_state_mutex_unlock(nvmevf_dev);
> +}

