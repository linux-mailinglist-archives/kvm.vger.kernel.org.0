Return-Path: <kvm+bounces-60752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 68A50BF92C2
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:03:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5ABC44E23F5
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 23:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 956862BE04F;
	Tue, 21 Oct 2025 23:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="iImPtcj0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AC0246774
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 23:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761087813; cv=none; b=uwOoQev3pEZAylWyJRqr9c+y/OuBBy0IDe0Hu0R7BehGB5VrOhVi145trq+FJuR52lErL1TEke8/XGhY5RhJgGiHyyASqImGYvivuy46X5DAJ5RyzClyLT9muEcxpWqY6t6j6J3vZwlFPrHvHzMtyOKlMLiTsPvijvJK0vuux4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761087813; c=relaxed/simple;
	bh=DFKz/0QWxrsnlFZ7ppZ/92x0zP8vpqycj+ZZCk0JVFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvgiC7nybymgmeeWst8zyNeel5iasyyRZyRPjVvmFoRanu/W3hqYzZwNlLmYKIHESu3TPQAj4CaWYOK0dFfbYqX/Panj47Wy+aQ7416dojinF0yc8LBQ2YuB4gDKg7kVbbVakzdlzcQ50TSFWQwf/I6dEAy4xykBQ+kbV3h77wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=iImPtcj0; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-87de60d0e3eso24720946d6.3
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761087810; x=1761692610; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t5Bh5O0u2edCj6s7JQTYVPlxSEp6IH0+GcP0uyaYNtA=;
        b=iImPtcj0eybBvZ/x2BauvvI4coi2dawMepCA7Qmmwva2BKkQz2xNHfIxiBTfYtcIAv
         LZ8xn0DXTLEYUz1j+USdjVwXOTGUz368xRNEof/TsUj57S5pl7Fuyc3/mcazgHEcBA/f
         ySv1y8bIXa6U9ZJvZvtF8RLID3+xaRt5JIly2Ip09EGWgxG0d8yOqdiAdJzB7qziSV0M
         Aavoa+CSYpr6ZzK5CM7m/Wd1dXL55wkA8L8jpAE1cWImj3j8Zxfr8JymazJhkU5ClzLm
         oLKnfgtw2aX8374zmaj1/Smp50xgWLIQqiRRKkT+OmWoDvCIiNC4qDYULspd1o68fFrX
         GZRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761087810; x=1761692610;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t5Bh5O0u2edCj6s7JQTYVPlxSEp6IH0+GcP0uyaYNtA=;
        b=AxohUnwVpT9D8+CQi69bHdGhijd0+hngtu97fErQS+N2wOjmzSS2/9nO1wqk6kOvNv
         ZiMIWB+O7Xz0LNrBuivxZJnyd4SwRNL5H/C+idM5m0I5qbbnb5ebgvvQdIeK2sQp/48r
         N/+Ykby/OA1Op1iZ3SLrY6ssCSpeyKiri8OluDqxLRzomfPca20cVQjCRF2frn3wNSC9
         s6ggetwIOr5W/e1dntaZVklU6c1CLfTjpWiY5WdVjhCBqaNB08lEe5JxorXavUf7e5CB
         rr/mowvYVgI5pn2E+4xUbLdoR4FV2XWS4Y9nWc5Ty5T0JO9BKwL0cAn+KSxMVF3L/9Vl
         FL1g==
X-Forwarded-Encrypted: i=1; AJvYcCXQ11O7jODzvbJouyAw3RHu3rybzPDcRAjRKhXa7cyUaX+jge5p6CSfE+48Y+QH2vEF0s8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKqK+5I7J+d/2V5xB+o42TpHCzNvG9TCI088hIz5Bvgw8pUghp
	mhBtVtdPZcKMr8Zlu764QmkRgFunJ142uFoZbwiKA1VxP7yq0di5W32O2pdXQogHH30=
X-Gm-Gg: ASbGncuJ4fRdEPqT809qEyVrtyATFoRVvNcC0ZIiBXEUfa5zHzt8ZZbD6YFHl8uFTRt
	fS/59kwUUNPx3unfvJvYlRjX2CrCeXNwvJWC4YTYTw1y52irDoUXHw6WiAGuyrTz2kQEPiKa5gM
	YTUDl9mvMSHPtHdarlvOfNSVPumyMrdOg/gfMOy4sUsZ5UXi7YRhbfH1SrAkwopKZqX0E+V5drG
	2OhMHVK2OVq1IqUVNuGClw6cEohR/i/biLCyiCy+KichiiAvja5BCxYbYQpnQbxHKrO2QWzLLre
	WDqoakpZRQOLNLgK0bqe7d7FCYFCY3RsDg9Xm4aTRaPObt/bjN6r9o/SlsR2KJe7EDKrdkn5cM8
	mJ/1qXpfkEeKiMzXcpFuKBOPOxUcO1gMK7yW1+unv40bl7nuJDZ3EUNcMz1D0kK0m4CSwRVcYaR
	2vhRPsyWBT55TSFexTaE8Po6fXszT1TQIbNAvqShJEWNx526OsoyxsW4X/
X-Google-Smtp-Source: AGHT+IF5TEP/imVUZDeqxAFOvJLVSc/DIGvaFM794M9E7hmCaqBWJ7XSxLIfFTPccdLhgqmKXhQMqg==
X-Received: by 2002:a05:6214:1243:b0:87c:1032:e849 with SMTP id 6a1803df08f44-87c2058e3e5mr236812616d6.30.1761087810447;
        Tue, 21 Oct 2025 16:03:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d02884878sm76147436d6.31.2025.10.21.16.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 16:03:29 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vBLO4-00000000NfJ-3RNd;
	Tue, 21 Oct 2025 20:03:28 -0300
Date: Tue, 21 Oct 2025 20:03:28 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Lukasz Laguna <lukasz.laguna@intel.com>
Subject: Re: [PATCH 26/26] vfio/xe: Add vendor-specific vfio_pci driver for
 Intel graphics
Message-ID: <20251021230328.GA21554@ziepe.ca>
References: <20251011193847.1836454-1-michal.winiarski@intel.com>
 <20251011193847.1836454-27-michal.winiarski@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251011193847.1836454-27-michal.winiarski@intel.com>

On Sat, Oct 11, 2025 at 09:38:47PM +0200, Michał Winiarski wrote:
> +	/*
> +	 * "STOP" handling is reused for "RUNNING_P2P", as the device doesn't have the capability to
> +	 * selectively block p2p DMA transfers.
> +	 * The device is not processing new workload requests when the VF is stopped, and both
> +	 * memory and MMIO communication channels are transferred to destination (where processing
> +	 * will be resumed).
> +	 */
> +	if ((cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_STOP) ||
> +	    (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P)) {
> +		ret = xe_sriov_vfio_stop(xe_vdev->pf, xe_vdev->vfid);

This comment is not right, RUNNING_P2P means the device can still
receive P2P activity on it's BAR. Eg a GPU will still allow read/write
to its framebuffer.

But it is not initiating any new transactions.

> +static void xe_vfio_pci_migration_init(struct vfio_device *core_vdev)
> +{
> +	struct xe_vfio_pci_core_device *xe_vdev =
> +		container_of(core_vdev, struct xe_vfio_pci_core_device, core_device.vdev);
> +	struct pci_dev *pdev = to_pci_dev(core_vdev->dev);
> +
> +	if (!xe_sriov_vfio_migration_supported(pdev->physfn))
> +		return;
> +
> +	/* vfid starts from 1 for xe */
> +	xe_vdev->vfid = pci_iov_vf_id(pdev) + 1;
> +	xe_vdev->pf = pdev->physfn;

No, this has to use pci_iov_get_pf_drvdata, and this driver should
never have a naked pf pointer flowing around.

The entire exported interface is wrongly formed:

+bool xe_sriov_vfio_migration_supported(struct pci_dev *pdev);
+int xe_sriov_vfio_wait_flr_done(struct pci_dev *pdev, unsigned int vfid);
+int xe_sriov_vfio_stop(struct pci_dev *pdev, unsigned int vfid);
+int xe_sriov_vfio_run(struct pci_dev *pdev, unsigned int vfid);
+int xe_sriov_vfio_stop_copy_enter(struct pci_dev *pdev, unsigned int vfid);

None of these should be taking in a naked pci_dev, it should all work
on whatever type the drvdata is.

And this gross thing needs to go away too:

> +       if (pdev->is_virtfn && strcmp(pdev->physfn->dev.driver->name, "xe") == 0)
> +               xe_vfio_pci_migration_init(core_vdev);

Jason

