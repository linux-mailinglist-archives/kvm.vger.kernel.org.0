Return-Path: <kvm+bounces-16188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D648B8B6173
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 20:55:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9194C2824AC
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 18:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B4C213AA51;
	Mon, 29 Apr 2024 18:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZuV5O4Df"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE42839FD
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 18:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714416924; cv=none; b=IgyvOU4YsWKWLI6QHneSKfYjjqGTmKjrfqJfb5MTo3twM12GxDqiTrQnY1L0EBFf6KGYz87gL3wu7ie02gi5g8VR6IUDfnT8vp41pRGhVX0CSs3D2/ug0pptkrSpqCrtItlG4Pj1OS3VMu93WMKi+ndFadU//VXUEixiBDSF83M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714416924; c=relaxed/simple;
	bh=+bJ4l/+MJh21mpfoMLxqNP2P/1zhMk4yCKT38ck+uDA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pvol1VnGHXoJUZCufiGWdeZ2DSLg44Eq1eDlSaRQMaTx3R4wmSLU/53e3IqS6rnxh3NzBAiscbl1c7NpcLS4ovZ16gRiq+BiRLcRdDhC0kS2L5cqBuj7Hjot2qNdX49LwsUNYrZ9TDaxvXxLorOHnVYbWI7eZy9TxR99HlNprvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZuV5O4Df; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714416922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m/3/BkQbBPDA1F/5I6ABEhaOnE4gox6HhtRjp973dZI=;
	b=ZuV5O4DfiTLM1+rPaLSA1UnQwRlZstGariFtxEQdQ2r9uuo2r4PsHEIGSZslOK+mcZuOZq
	y1gfkt9x0MsuuzQWZtlqLPTrqGcIMTyVoiY7R6+9FMmIcst2OnSMhzpra8v68FD2rXdn/Z
	CgZjX2dtNtKk8cV/XjSx00zAcEtja5I=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-vi1wpngTMLiVAMsULzB1og-1; Mon, 29 Apr 2024 14:55:20 -0400
X-MC-Unique: vi1wpngTMLiVAMsULzB1og-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-36b16d8e3a8so38150795ab.0
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 11:55:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714416920; x=1715021720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m/3/BkQbBPDA1F/5I6ABEhaOnE4gox6HhtRjp973dZI=;
        b=fHV6+JLUf5np3F9LklqVMcgkD0PK5anxDNZ8Zg0w4MZ1Ttkbsp74NKojO6UPEEC6v0
         0gCkHjTqn7eNviNiiHUuDERzTORGTmH69gQawfylNIM8wDkJsxFv5KHLdqbb4VqlAFCC
         G4mvRd8fxSFn4uw7LUA3S3P6YddxDHmjoNck/m/hr/1haQrfKHBWQJXPqfiQ/ztRX0gl
         qgBSX6nQgfcoywD+ef9Jxc6NbGKVe0WOe88myE4atnTBC2NAtFKUB93hKK3TmoK7alQg
         5JNV3KvHCAi3kBLfB/QS8Hf51iPHoEN5QoroGabZWR0+ysPNgd7u5+wOXN/9ktLjVb23
         pXmA==
X-Forwarded-Encrypted: i=1; AJvYcCWc1M6H16Qo1no6TrGkmKIONX7Uh8qpivRQzb3nqPjRqjwxHVLzL4WgoTnpd1n14NzUsQMJJwvVHMcLmGTeDcc/rBDY
X-Gm-Message-State: AOJu0Yx6aQ8zDsSqxMrXPYMIiRcYW9yM3GnD59vGEKxJlS2gVUsJM1EC
	3pnZ1mamBJ3Q9Oki3q119k8yC3UaRUDrBqC29iFJy3zCouIgxTtmIdWXqRQnOw2cSbvsMw0xCAh
	6oapOiQK3F0QKYLh/rjvCbCJFeXzB6Px6vqpe+9rdzsQanEGaug==
X-Received: by 2002:a05:6e02:1384:b0:36b:3b10:7419 with SMTP id d4-20020a056e02138400b0036b3b107419mr13461537ilo.32.1714416920204;
        Mon, 29 Apr 2024 11:55:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHrkmhoNdK7DR3Aq+qUGcS4scHO6A8gkPsrSrcUau21xILS5fqOfi1nMuJyEgwFhR3UNAzGmg==
X-Received: by 2002:a05:6e02:1384:b0:36b:3b10:7419 with SMTP id d4-20020a056e02138400b0036b3b107419mr13461511ilo.32.1714416919784;
        Mon, 29 Apr 2024 11:55:19 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id l15-20020a92d94f000000b0036bf91c25d4sm5162364ilq.57.2024.04.29.11.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 11:55:19 -0700 (PDT)
Date: Mon, 29 Apr 2024 12:55:17 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Nipun Gupta <nipun.gupta@amd.com>
Cc: <tglx@linutronix.de>, <gregkh@linuxfoundation.org>,
 <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <maz@kernel.org>,
 <git@amd.com>, <harpreet.anand@amd.com>,
 <pieter.jansen-van-vuuren@amd.com>, <nikhil.agarwal@amd.com>,
 <michal.simek@amd.com>, <abhijit.gangurde@amd.com>,
 <srivatsa@csail.mit.edu>
Subject: Re: [PATCH v6 1/2] genirq/msi: add wrapper msi allocation API and
 export msi functions
Message-ID: <20240429125517.693714ef.alex.williamson@redhat.com>
In-Reply-To: <20240423150920.12fe4a3e.alex.williamson@redhat.com>
References: <20240423111021.1686144-1-nipun.gupta@amd.com>
	<20240423150920.12fe4a3e.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Apr 2024 15:09:20 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 23 Apr 2024 16:40:20 +0530
> Nipun Gupta <nipun.gupta@amd.com> wrote:
> 
> > SI functions for allocation and free can be directly used by  
> 
> We lost the ^M in this version.
> 
> > the device drivers without any wrapper provided by bus drivers.
> > So export these MSI functions.
> > 
> > Also, add a wrapper API to allocate MSIs providing only the 
> > number of interrupts rather than range for simpler driver usage.
> > 
> > Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> > Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> > ---
> > 
> > No change in v5->v6
> > 
> > Changes in v4->v5:
> > - updated commit description as per the comments.  
> 
> I see in https://lore.kernel.org/all/87edbyfj0d.ffs@tglx/ that Thomas
> also suggested a new subject:
> 
>     genirq/msi: Add MSI allocation helper and export MSI functions
> 
> I'll address both of these on commit if there are no objections or
> further comments.  Patch 2/ looks ok to me now as well.  Thanks,

Applied series to vfio next branch for v6.10.  Thanks,

Alex


