Return-Path: <kvm+bounces-28651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3187599ADED
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 23:02:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58B3E1C22850
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 21:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7554C1D1318;
	Fri, 11 Oct 2024 21:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P0x9Fe/J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27858199231
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 21:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728680555; cv=none; b=R1DKhnMZnkMz6CM2gSjyUNfVHlKuDfpu+hIoHr43/gAn7CBs/31NTSKlwSTOvD72FXtyuCEMKmfjk9M3V2NBSYCUmf4h8o7pIh9rZPf12LdNdlEzPbxro6tDREp68aCE1WrDn2cy8D+F3zg7c5zRckextsJsznmry9gKnHriUTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728680555; c=relaxed/simple;
	bh=t7v9LrnikA0b/tdjpm95QIPigc7c4Z7Gm+7ryEqj1gE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oKnxR+J8QEs2fw17B6oOPYEVyGZQhuDN2wSx0wYKG8nBEvutt/RTnFnRj57q+Rl1ZeuYlJiTx33MGt/fcrnYm7KVuTqUw/r2TdjIYIB/0vbXRtWB/Tz24hl9gcT+5BJKIOw1foA0jw9QKTCT+PZYnscP2FGiEsMX648SY1ziL18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P0x9Fe/J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728680552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M4ZF/lqPBd0UGdsnnza01sUUQe28zx1+oJm7x5DzidA=;
	b=P0x9Fe/JDtI0+/X4y5e5Yj1hSS6MimWRgftZG3IlsgxfuqbQfAYtXvcYBj3Wb80WcOfhvv
	ZjL/vEo2Fqc7YFCwIK61pstcOgCOlFS0AgKuofHv4JmIs821zAXW8JAOnK8g0pFwUIlql1
	PZkMt9KeBmwRc0TH4VlWHsVTJVCPpds=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-qcrPnig2PR2_4v1IMjwoCw-1; Fri, 11 Oct 2024 17:02:30 -0400
X-MC-Unique: qcrPnig2PR2_4v1IMjwoCw-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-837875efdbeso19357239f.2
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 14:02:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728680550; x=1729285350;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M4ZF/lqPBd0UGdsnnza01sUUQe28zx1+oJm7x5DzidA=;
        b=cPfpUqYvVBT51GqKxQUKEusIx3BIW0Fk02Uyge2T04Hkf08kHPszPtBOdWsrcFtDrc
         mAttck+1Yhog4LUwdWSYUnsdCQaQR8ucMYW9/U4Wz9sLJMOurancC1x19lprSILpGmv5
         kCFOC++wmgThoZJ0IvnIWMGQbo0i7M9hI0tzl3n7ofqDn3eK44g48Ty/YF1e0vVUXGbi
         mD2xiddPJ3fLBeKLvTAbjpOCZlb6GTc0dgBH3g2Iv+AFaYAQ7R6ckCeJ/QeQVuJbbWOP
         pwX37e7uB1S99Bg4gZCCXU0h7CJDEM3DlR+n12TAgbylFF8/npYKJK7GR40ygNtUwojf
         /bSg==
X-Gm-Message-State: AOJu0YzBtaIit2Frn6GQixu9j4HYpcQEwvoGUiQaSIsm/crymfE0Af46
	XO2vvs67SwpFSJ5gtlcvvZ2uRy/PJmHetUCYP0/g0ktBq46Y11DqRVE8Nf3s4Ib2EIcPjLQTY4v
	czZP4cynI7KA1Tb+krLffSjudYxlDp+k9d7Dkv4apotP5oBP+kQ==
X-Received: by 2002:a05:6602:3284:b0:834:f667:217a with SMTP id ca18e2360f4ac-8379202f708mr89166439f.1.1728680550020;
        Fri, 11 Oct 2024 14:02:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqD2f+aFQtnYWBNo5lj3VmQuysrsCAI+ZXqdxvd+ha7KP/RQaF5OE/2Ag0jxh8N+y1wX+hmg==
X-Received: by 2002:a05:6602:3284:b0:834:f667:217a with SMTP id ca18e2360f4ac-8379202f708mr89165039f.1.1728680549687;
        Fri, 11 Oct 2024 14:02:29 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dbad9b15absm792043173.34.2024.10.11.14.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 14:02:29 -0700 (PDT)
Date: Fri, 11 Oct 2024 15:02:27 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
 <kevin.tian@intel.com>, <jgg@nvidia.com>, <alison.schofield@intel.com>,
 <dan.j.williams@intel.com>, <dave.jiang@intel.com>, <dave@stgolabs.net>,
 <jonathan.cameron@huawei.com>, <ira.weiny@intel.com>,
 <vishal.l.verma@intel.com>, <alucerop@amd.com>, <acurrid@nvidia.com>,
 <cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
 <aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
 <zhiwang@kernel.org>
Subject: Re: [RFC 10/13] vfio/pci: emulate CXL DVSEC registers in the
 configuration space
Message-ID: <20241011150227.1b41a479.alex.williamson@redhat.com>
In-Reply-To: <20240920223446.1908673-11-zhiw@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
	<20240920223446.1908673-11-zhiw@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 20 Sep 2024 15:34:43 -0700
Zhi Wang <zhiw@nvidia.com> wrote:

> A CXL device has many DVSEC registers in the configuration space for
> device control and enumeration. E.g. enable CXL.mem/CXL.cahce.
> 
> However, the kernel CXL core owns those registers to control the device.
> Thus, the VM is forbidden to touch the physical device control registers.
> 
> Read/write the CXL DVSEC from/to the virt configuration space.
> 
> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 98f3ac2d305c..af8c0997c796 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1902,6 +1902,15 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>  
>  			perm = &ecap_perms[cap_id];
>  			cap_start = vfio_find_cap_start(vdev, *ppos);
> +
> +			if (cap_id == PCI_EXT_CAP_ID_DVSEC) {
> +				u32 dword;

This should be an __le32 and we should use an le32_to_cpu before
comparison to PCI_VENDOR_ID_CXL.

> +
> +				memcpy(&dword, vdev->vconfig + cap_start + PCI_DVSEC_HEADER1, 4);
> +
> +				if (PCI_DVSEC_HEADER1_VID(dword) == PCI_VENDOR_ID_CXL)
> +					perm = &virt_perms;

We're making an assumption here that all CXL defined DVSEC capabilities
will have the same behavior.  Also, should we bother to expose an
emulated, dummy capability, or should we expect the VMM to handle
emulating it?  Doesn't the virt_perms allow the entire capability,
including headers to be writable?  Thanks,

Alex

> +			}
>  		} else {
>  			WARN_ON(cap_id > PCI_CAP_ID_MAX);
>  


