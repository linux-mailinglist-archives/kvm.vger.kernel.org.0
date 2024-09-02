Return-Path: <kvm+bounces-25653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F05AC967FB7
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 08:51:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5EE71F20F92
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 06:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C46015B153;
	Mon,  2 Sep 2024 06:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="avRV2l7Y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5A03C30;
	Mon,  2 Sep 2024 06:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725259859; cv=none; b=kecY8SeaET1Sf6sEnVrGGgt4vRaRckBcByJgYOD8r9KtYX/vYbuszqzMHeoaTbWnOvlwVP1WVo21nvbQBXPunLJhnSOjz4c2WEPd+Wd1u8l/FJ1cX2UEPNjC3wT0R27OtG4ciK5yUj7JlCgtCzPI0mmtQxAs7glbUgDCEbxmdOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725259859; c=relaxed/simple;
	bh=xLvMzn5c3kgNKxtTRVdjh2fhazRhvOYOirkQfFGs058=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JgQjVKvWPpx33L+2QdVIidYa769UbTcaRk2v9LxzeRrsucCmqk4biPhuVAea9NDjJTVNM4PMxVzPcGds8CurPi0bUBzyx5RJw26IGxQ2qItf7nopbzMiie75XF3Xo0s+Jf8GMY8B7xagJNyW9RtMlSH69MYEw2lHKgUzDUd6nQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=avRV2l7Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D0AC4CEC4;
	Mon,  2 Sep 2024 06:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725259858;
	bh=xLvMzn5c3kgNKxtTRVdjh2fhazRhvOYOirkQfFGs058=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=avRV2l7YzELkesAjApwhaA2PoXtZsC5+hEEeYaO93WvM+tU460IWfWeYizadRDzBb
	 r15qFKjQWnaXd6VT7UJ1jf5yLS0QhPCtiqs3CcZwh3LQJP8sZTKFSyB7KJTEtSF20n
	 cXbn/2X35f62eZnOumz0Ll5Jj1G/QImqmtlItz5sdLOhdx1nhgoWTNmk/8uEplA6Py
	 dq6YJUvErcMqd2p19Fdi/AwrSe24NcgkdHHbwILZj7dTOLogieoWxhip3RuUr+HKnB
	 D+HRzefzmcQkzAvyd9uVm7dMyPz/CPs8JYVfarh+yZrPypO2/rjVGC4JCot2IWJGLl
	 B3IXQcr9OZIxA==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org
Cc: iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	pratikrajesh.sampat@amd.com, michael.day@amd.com,
	david.kaplan@amd.com, dhaval.giani@amd.com,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Lukas Wunner <lukas@wunner.de>,
	Alexey Kardashevskiy <aik@amd.com>
Subject: Re: [RFC PATCH 07/21] pci/tdisp: Introduce tsm module
In-Reply-To: <20240823132137.336874-8-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-8-aik@amd.com>
Date: Mon, 02 Sep 2024 12:20:51 +0530
Message-ID: <yq5abk16wnuc.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


...

> +static int tsm_dev_connect(struct tsm_dev *tdev, void *private_data, unsigned int val)
> +{
> +	int ret;
> +
> +	if (WARN_ON(!tsm.ops->dev_connect))
> +		return -EPERM;
> +
> +	tdev->ide_pre = val == 2;
> +	if (tdev->ide_pre)
> +		tsm_set_sel_ide(tdev);
> +
> +	mutex_lock(&tdev->spdm_mutex);
> +	while (1) {
> +		ret = tsm.ops->dev_connect(tdev, tsm.private_data);
> +		if (ret <= 0)
> +			break;
> +
> +		ret = spdm_forward(&tdev->spdm, ret);
> +		if (ret < 0)
> +			break;
> +	}
> +	mutex_unlock(&tdev->spdm_mutex);
> +
> +	if (!tdev->ide_pre)
> +		ret = tsm_set_sel_ide(tdev);
> +
> +	tdev->connected = (ret == 0);
> +
> +	return ret;
> +}
> +

I was expecting the DEV_CONNECT to happen in tsm_dev_init in
tsm_alloc_device(). Can you describe how the sysfs file is going to be
used? I didn't find details regarding that in the cover letter 
workflow section. 

-aneesh

