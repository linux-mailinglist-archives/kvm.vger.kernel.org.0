Return-Path: <kvm+bounces-41664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11E4AA6BC8C
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 15:07:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3279C1896C65
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 14:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BFFC145A03;
	Fri, 21 Mar 2025 14:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EhxOuy5v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC5B78F4F
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 14:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742565989; cv=none; b=CUsUw5mEG/Rs5hXmmDzV4xDw6pis/+xAK2n1Rbk3ISUrOICYMNM7BptwfqaxFFcTyfKE/J7v6GyXliiqY1oPcpeJrWD2vDt1Ad/VKTRg1uvvYJxeypDiTBNk+fJ9G1RtE/gMlWRuRL8WpFzegd9I9P6ZdeI7a1RPphzFGM3QSpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742565989; c=relaxed/simple;
	bh=pr/QaPmsS1R3c1ZPvXy4FKnBJCT8B5G42KzW+EOLsnc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l/PajXSGxaEPnmp80vdxe9W6chAUazSotsNtNTRAR5HJX6TdTRR4SDzJGMOGLpkz/ee6/E/rpOAJk6nJ5h+HCy4/rStT7I0B+0shDCAMUGK+/p9WyG7peH/Ow8JbzCRiJN3gmzQ3oeli6uo43lXGWFi3TaNmtw1J0CwKfHgmmI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EhxOuy5v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742565986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PtfqZFqF8iFiel/s4I4nuuc5DqZUNdlFQlj2cWV2Ueg=;
	b=EhxOuy5vEGfpWneouBpggjXUspS7Yrm3tbnrNkmH2EfBT3AeYiZt7xuWJQMpF+gzoPCOvp
	VtlcLkWHr7So5n207waNa2Yjay+/F4TXoeWW9f7s2Ay3Lh7imbb36s71mBzRJJivpssX7A
	xmyVYOXS8Y7+VJH1N7jsAoDKd/gHPfE=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-fhbUIwqiPnmApA4Sc7ucSQ-1; Fri, 21 Mar 2025 10:06:23 -0400
X-MC-Unique: fhbUIwqiPnmApA4Sc7ucSQ-1
X-Mimecast-MFC-AGG-ID: fhbUIwqiPnmApA4Sc7ucSQ_1742565982
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3f6abe5c0cbso352164b6e.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 07:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742565982; x=1743170782;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PtfqZFqF8iFiel/s4I4nuuc5DqZUNdlFQlj2cWV2Ueg=;
        b=wPXH+rX3rUpkRxtuaLi/ZSmX05/aSr48eEYAI6EduOhCn3nTXe567asHCabUDz9Dab
         zSLCWbxjEn6xX+9ALeiLqDv/HYSFs4G7gaoExP/Zix6ysFtdFG+/n4CHsYvqavOfvUG6
         fs2gPOOH0wjWRWuQsk6zxrOymbqLYLrW7la082bzTVCqEDgOXN+RvzeSXU/dXcRp/hdg
         yXfgqb/LrdLCPtdq9tOM0c5AmTwUezOHXcGaN+NkRxSmBY2PCL+khZAT1jF5iW0sDEZu
         7WI7taOf5qIPm7PcKJIpshALmpQDMFgfw8+XZ27vGzozNIj7zYU8ExTQJG7+i/zn2cf2
         ZP7g==
X-Forwarded-Encrypted: i=1; AJvYcCWzBxPyNSrsQLaynn6kwRCt8Fzy3e4pMm5m/ujZrHPawLm/TgTEnWq2P/0BxXSUHhpFZ9Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdHBUWojNaTOD/e6AEmRfvwNErOuAHb6iUymGQyAPLnJ9KVlPv
	Na8ca1fc3NNfkctJF81xYLlFoUnKtCUygaLsbCrCUfCUNFhI06KlVX+xoiywVaY1BAqTHhSMbYn
	8zcAKLBl/VQx466Y2Ok27kF0OyN6qFSMHKJLOZ7agiIzMO6OJfQ==
X-Gm-Gg: ASbGncvGQ32wdgLgQ/lp8CqC4sV/wNHVED2a5e2rmyxJ9hlwybMxPqRZIuauyOYXEVO
	UujifY0CnfXoz0gB0Rmkn1TlIjJYD68hlhGUAUQHLLg9GzzW/LKf5novPNa8KDZ7jm3vi3YsElp
	bTZDWasqFbYcXRxA+bdNgIRAA37oJXOMeDBBfSJZSBnbwTrdHlEasiwMOKWi9i60yPhRQ+Ks/jb
	9W4y9qAW3Cs8JPy5CJwMJxS/4kMKleVwUrLHgo9fZqGriGgwscCE1opkcqhiJhjxkLIG3/b/Ldo
	OhgWs2tiL5QLpbISB5M=
X-Received: by 2002:a05:6808:6807:b0:3fe:b5d3:3f23 with SMTP id 5614622812f47-3febf793391mr842056b6e.5.1742565982319;
        Fri, 21 Mar 2025 07:06:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEXrUa2CJtGUuPnUiUVvqG8OIHWW+85+a82cVLjG6j0tZ/F39gii6vY+WagE3AnL6fCZ04BMg==
X-Received: by 2002:a05:6808:6807:b0:3fe:b5d3:3f23 with SMTP id 5614622812f47-3febf793391mr842043b6e.5.1742565981807;
        Fri, 21 Mar 2025 07:06:21 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3febf7109ddsm335819b6e.26.2025.03.21.07.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 07:06:19 -0700 (PDT)
Date: Fri, 21 Mar 2025 08:06:13 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: jgg@ziepe.ca, kevin.tian@intel.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, yi.l.liu@intel.com, Yunxiang.Li@amd.com,
 pstanner@redhat.com, maddy@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] vfio: pci: Advertise INTx only if LINE is connected
Message-ID: <20250321080613.566cb6bd.alex.williamson@redhat.com>
In-Reply-To: <9131d1be-d68e-48d6-afe3-af8949194b21@linux.ibm.com>
References: <174231895238.2295.12586708771396482526.stgit@linux.ibm.com>
	<20250318115832.04abbea7.alex.williamson@redhat.com>
	<9131d1be-d68e-48d6-afe3-af8949194b21@linux.ibm.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 20 Mar 2025 23:24:49 +0530
Shivaprasad G Bhat <sbhat@linux.ibm.com> wrote:

> On 3/18/25 11:28 PM, Alex Williamson wrote:
> > On Tue, 18 Mar 2025 17:29:21 +0000
> > Shivaprasad G Bhat <sbhat@linux.ibm.com> wrote:
> >  
> >> On POWER systems, when the device is behind the io expander,
> >> not all PCI slots would have the PCI_INTERRUPT_LINE connected.
> >> The firmware assigns a valid PCI_INTERRUPT_PIN though. In such
> >> configuration, the irq_info ioctl currently advertizes the
> >> irq count as 1 as the PCI_INTERRUPT_PIN is valid.
> >>
> >> The patch adds the additional check[1] if the irq is assigned
> >> for the PIN which is done iff the LINE is connected.
> >>
> >> [1]: https://lore.kernel.org/qemu-devel/20250131150201.048aa3bf.alex.williamson@redhat.com/
> >>
> >> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> >> Suggested-By: Alex Williamson <alex.williamson@redhat.com>
> >> ---
> >>   drivers/vfio/pci/vfio_pci_core.c |    4 ++++
> >>   1 file changed, 4 insertions(+)
> >>
> >> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> >> index 586e49efb81b..4ce70f05b4a8 100644
> >> --- a/drivers/vfio/pci/vfio_pci_core.c
> >> +++ b/drivers/vfio/pci/vfio_pci_core.c
> >> @@ -734,6 +734,10 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
> >>   			return 0;
> >>   
> >>   		pci_read_config_byte(vdev->pdev, PCI_INTERRUPT_PIN, &pin);
> >> +#if IS_ENABLED(CONFIG_PPC64)
> >> +		if (!vdev->pdev->irq)
> >> +			pin = 0;
> >> +#endif
> >>   
> >>   		return pin ? 1 : 0;
> >>   	} else if (irq_type == VFIO_PCI_MSI_IRQ_INDEX) {
> >>
> >>  
> > See:
> >
> > https://lore.kernel.org/all/20250311230623.1264283-1-alex.williamson@redhat.com/
> >
> > Do we need to expand that to test !vdev->pdev->irq in
> > vfio_config_init()?  
> 
> Yes. Looks to be the better option. I did try this and it works.
> 
> 
> I see your patch has already got Reviewed-by. Are you planning
> 
> for v2 Or want me to post a separate patch with this new check?

It seems worth noting this as an additional vector for virtualizing the
PIN register since we'd often expect the PIN is already zero if
pdev->irq is zero.  I posted a patch[1], please review/test.  Thanks,

Alex

[1]https://lore.kernel.org/all/20250320194145.2816379-1-alex.williamson@redhat.com/


