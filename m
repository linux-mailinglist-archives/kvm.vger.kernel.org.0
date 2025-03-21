Return-Path: <kvm+bounces-41677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5B63A6BEC8
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:54:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16B6E3AABCD
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 15:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C297E229B28;
	Fri, 21 Mar 2025 15:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BjzH7JmN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556AE1E8350
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 15:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742572320; cv=none; b=oL2KHF8rROpcTvUQVtGqY3ZBqsuL2Aas9POaMjkIgUI4lkBCZwdp3Au7pBZ9FJSBGTcBlkcPNLPc0gIMtzFsUjlFv3skGHRbJGeRHiEYFcA1TcQIoRdllPbMqG9X8QIsu1JqCG/B731UiqOjCoj2HMAkUdUzGf3iObgog9GEWjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742572320; c=relaxed/simple;
	bh=NfMtNzSkWHRadYC7fD0IETSJr8axVNhMTHgjTfoLlLw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gv+HSE8FlDx5+70CzEpLAZQ0cbjepkImgW5ZzGgh5NJ2+FBkg/OKEcx6ktuTo0cQgWDYuaKS5KEuynqKwF2+oUNGc15mX2uYwMNwTNPZb5AUoVSQ0tm1gV4S90qWUWswwGKvfIqRv63KF2peVA4vMgLpI7tWGjPYM/Z83cggEVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BjzH7JmN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742572318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PoG6USFI97OiT4qS0soZ/PVlv737qpSqxLyCgHs7OOc=;
	b=BjzH7JmNE4zkhxSCOrWG+23gui97lVWL5wc58SNy/9ZSusVEv/OPP0qgy7qEbf92UWSuVu
	w/LMs20WhVk4q6AsfL8eVQRSlPLbBJ9d9wDqtNNJexNGNUI9YUm2oZCOROVMlpOpI1zaXP
	QK2PJwUyNZgZdSmZe/tJAnJod7VMWqE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-N1935ZYUNs2t36EygdvlAA-1; Fri, 21 Mar 2025 11:51:57 -0400
X-MC-Unique: N1935ZYUNs2t36EygdvlAA-1
X-Mimecast-MFC-AGG-ID: N1935ZYUNs2t36EygdvlAA_1742572316
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-8560c8e8f29so21021239f.3
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 08:51:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742572316; x=1743177116;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PoG6USFI97OiT4qS0soZ/PVlv737qpSqxLyCgHs7OOc=;
        b=QBR6xGKlaR0Nl3IPjIQ78KGmohMkNpFdz669DHGEcyTPB8Nu3bBADkIBIB5O/PjXWe
         ixLCvERzDfMjqX/WJ7RSVcN6RjGbKrIYmFcsbu99g5/cAoUCRTnph0HlxDLjZI0BOQtH
         Vu0B2tj0fYntLJ32xFGLxjDJy7a6eJr+Xop4GI5YNnvXVSOzrAun3G6DNmeXnckCb9ZV
         Mqxv3s3NUzWN1cCLN02YkDW087i0j3UzcNslSPkgRsYgBNAR5fjYfyX+SkbjVC5nsmWh
         SAhpRsBRFDfMh44SoqRwD6w6LSr1HjFaUWqGsrZ3bQOLXw/lYiMJPyL1rrHMwJsslC95
         4duw==
X-Forwarded-Encrypted: i=1; AJvYcCWSd7n8sLXhwgaEpDMJtn/QeibXpbNwtTMQqrNDKNMyN+zp5VC8ZZi3YcuEmDn8c2MWEEk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkhSx37preAq+mw3CyXHi+WA9pL3D5Irvs0Rf/Felg8f5d6JGS
	WWcNhB2XXh0f/U0NbP8b8cBzDpxApr3Y4HBFwl7apzEkQ04SGQHdpvLmUl6ENLBxkME4FdcH5GG
	gPXjeDBJzuJM+NDbQuqIKchmzWgo3YM7bPiVWlEsF4cLcsftfFw==
X-Gm-Gg: ASbGncteCXbMr3iGdkOjWyAgXvfMCJ1mbLwlz9rvNmT2GMrV9iNNIzk5e16RBQzpPyi
	xm0tKfYTKm5D2saIpLSggL4tqioMdDFEuKEfB3eUcuDodzjn7cTKesuuVXY5LAxcRYjKeZ0fcen
	uMRkZa3Nh9cVImNhrQvPsu5JMAHJnMSoczqTSWorbV6D/LbT47k8Vf0YeuVvMLnEqe9SxBkqKFM
	cVPckx791LlVZAgA6aw0+8Q9+u9ApgsIvR6wh4MdtVwqc97o0WF6dhYofJXqMhxyNYbYnkeZt+9
	MNwt/J6eLWuZVrWaYSA=
X-Received: by 2002:a05:6e02:1fcf:b0:3d4:3aba:a8b3 with SMTP id e9e14a558f8ab-3d596167e51mr11353095ab.3.1742572316126;
        Fri, 21 Mar 2025 08:51:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHhjsy/Vs9brKKBwg2VaxEmCIn6GZl2yXbGu+lZVysKgFANqEcGieBp6AoQ0WZ5eKg1UbhSsw==
X-Received: by 2002:a05:6e02:1fcf:b0:3d4:3aba:a8b3 with SMTP id e9e14a558f8ab-3d596167e51mr11352945ab.3.1742572315661;
        Fri, 21 Mar 2025 08:51:55 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d5960ceb59sm4865145ab.48.2025.03.21.08.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 08:51:53 -0700 (PDT)
Date: Fri, 21 Mar 2025 09:51:50 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v6 4/5] hisi_acc_vfio_pci: bugfix the problem of
 uninstalling driver
Message-ID: <20250321095150.7fe81186.alex.williamson@redhat.com>
In-Reply-To: <20250318064548.59043-5-liulongfang@huawei.com>
References: <20250318064548.59043-1-liulongfang@huawei.com>
	<20250318064548.59043-5-liulongfang@huawei.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Mar 2025 14:45:47 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> In a live migration scenario. If the number of VFs at the
> destination is greater than the source, the recovery operation
> will fail and qemu will not be able to complete the process and
> exit after shutting down the device FD.
> 
> This will cause the driver to be unable to be unloaded normally due
> to abnormal reference counting of the live migration driver caused
> by the abnormal closing operation of fd.

"Therefore, make sure the migration file descriptor references are
 always released when the device is closed."

The commit log identifies the problem, but it's generally also useful
to describe the resolution of the problem as well.  Thanks,

Alex

> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index d96446f499ed..cadc82419dca 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1508,6 +1508,7 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>  
> +	hisi_acc_vf_disable_fds(hisi_acc_vdev);
>  	mutex_lock(&hisi_acc_vdev->open_mutex);
>  	hisi_acc_vdev->dev_opened = false;
>  	iounmap(vf_qm->io_base);


