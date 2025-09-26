Return-Path: <kvm+bounces-58899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7021ABA4F9A
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 21:36:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3249C3881B2
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 19:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E58627FB03;
	Fri, 26 Sep 2025 19:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TkcCe/2V"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B81231842
	for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 19:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758915375; cv=none; b=b98+f7SEkjCxCnKKrZbXSPi+Y8IClrFSwr/JuT4s7+hUgwHoBI7MNyBMMZHzUU8t4wzR9FfFFaUMXyR8kzWqysZaC8ZELupPIqC8hB5n6hx05XgB5pqjEx5UNRdSWTr5yT+5E1D0kQm/WkIHhYWbi7BUPGu+xsTKjGAhr/hcRGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758915375; c=relaxed/simple;
	bh=uuIq1t4c7qGDy0Lsti4d3Xt/7BKE5D5umR9UNUEgDjE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rg5irOkilaLZJ93bmfdOEuaKUE7+LabjQbRkH/rikOVVKmELpw2BTL4ZqbWqHOuZyIsecKiYlteo04CT0XrmG0VBfWG/U2Tf7iY5jIsFw0u5vBtceMa9FcGJlJUmlqdJGvER/ZeeujjjIOZ3jElhKxsWWuvYVNGbL8kiJIk7XEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TkcCe/2V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758915373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sjnw97MU9jbLsmf1Uqxw2Nci38Y0dPqhhgHU46NMhgM=;
	b=TkcCe/2Vh5SKI+HOEInCr9QAo6z2uUrwkkzFa2d33YgQxpq26NyajiqrSaK0LlhS+Aw9qO
	Ep4dBeQCbe4njnTSK5kUS+ML6yWGL35UCo5Jx4nuwuUQSCZnzMfWkLocn8PX8eJphYHcdl
	2eO2A+/ip/Ng28l/PHl0l6r+Hj6r3xg=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-dN8gGjxPNiK8igNVs8uA2g-1; Fri, 26 Sep 2025 15:36:11 -0400
X-MC-Unique: dN8gGjxPNiK8igNVs8uA2g-1
X-Mimecast-MFC-AGG-ID: dN8gGjxPNiK8igNVs8uA2g_1758915371
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-4272d0bebf0so3211855ab.0
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 12:36:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758915371; x=1759520171;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Sjnw97MU9jbLsmf1Uqxw2Nci38Y0dPqhhgHU46NMhgM=;
        b=DMQ+/N64XOZiBJiDXkooS1EIYKwOZ0BTGO0Kga+LSt2Mhq/UhoHLlAAMbTKJjEKu11
         eI1Alpfz73QA1fAlOy4mu/t8b2Mj4Tebidd7kCJDdqeHzzess8/QVi4nGJIDj+xfTFrX
         xqYY8rYyNAk/3Q4DCxmkJ6QsdyIv7EQnDh9GTFy8+46AztUKZTLIslPzWdbMl4SZtIEy
         88czDQA8sxDILKGUJjI0vyxGGMMczd9WsOzNTgzW/KPLOZtDTMAolL3NIieoJVE4JxZn
         4jspp9d+ec+Q0F+fWTUztQqDGboXLdC//Z6bX5OOQfE6izLrJUYvT13Gw4SeQ3tEIR8j
         gsvg==
X-Forwarded-Encrypted: i=1; AJvYcCUGVZTp9iN/eozSFo+fnampd3PfIVMWhD2RQzn6UXlEBY2bkGp6K99T98n2qgoXX39CgEo=@vger.kernel.org
X-Gm-Message-State: AOJu0YymjHW/DGBjrtturAPHM7QhCL9JfBjaE0zfPjCyo3UX50r0/Ih7
	b4HrwQhZRZVo97dMPVxW2nRaeFNwTkFnsdWYacBJsorE4lC9n0EagS9FyFeKVEYbdAHmqQx9db0
	qO2snmWtkUjVX2G5k+EvgGp0b5Db5uUIbqTnw5yZVMDXRoV6aRiByfQ==
X-Gm-Gg: ASbGncvTXAgT+YSG9drMdQaQSBOaaEbDtgxSs2kovEjkVBx/qJCArlxro2u3HMdEj+t
	yjEiXLaR587vnEIxRlHjSAHwSyHM9rxrxk3/rn3nY6jSmTQnyaNYcOZaOMiu/ZsGxXIelWK2A7x
	QUMe40nmQ71/fiOgol2noHER+bNVjvxr6gMzo7cvXQD01vdIBF/BSM75YOGzZcnstHUdra0P/ZU
	jVC0BKBxePPO552Z2PbUmlE1M9f84No9z2HvaT5k42A/92YeVVqSW4XewQ4RFVs/5AJ6DA+zJvp
	eNH7S7jKIusf+Rm7Tm4qYf7yXa7LLaJwfT3hjvAbQ+U=
X-Received: by 2002:a05:6e02:1523:b0:425:9068:4ff with SMTP id e9e14a558f8ab-425955c8eb5mr44103285ab.1.1758915370847;
        Fri, 26 Sep 2025 12:36:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5kwS0VyoWACtgc/kvwMhl9hpO10Z/0kNKn1tSjerc+aPGklJvKL8PA+MiMW+9wzh2XQYqfw==
X-Received: by 2002:a05:6e02:1523:b0:425:9068:4ff with SMTP id e9e14a558f8ab-425955c8eb5mr44103155ab.1.1758915370427;
        Fri, 26 Sep 2025 12:36:10 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-425b9133085sm25262705ab.0.2025.09.26.12.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 12:36:09 -0700 (PDT)
Date: Fri, 26 Sep 2025 13:36:08 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Tushar Dave <tdave@nvidia.com>
Cc: ankita@nvidia.com, jgg@ziepe.ca, yishaih@nvidia.com,
 skolothumtho@nvidia.com, kevin.tian@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/nvgrace-gpu: Add GB300 SKU to the devid table
Message-ID: <20250926133608.4963f2bb.alex.williamson@redhat.com>
In-Reply-To: <20250925170935.121587-1-tdave@nvidia.com>
References: <20250925170935.121587-1-tdave@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Sep 2025 12:09:35 -0500
Tushar Dave <tdave@nvidia.com> wrote:

> GB300 is NVIDIA's Grace Blackwell Ultra Superchip.
> 
> Add the GB300 SKU device-id to nvgrace_gpu_vfio_pci_table.
> 
> Signed-off-by: Tushar Dave <tdave@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index d95761dcdd58..36b79713fd5a 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -995,6 +995,8 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
>  	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2348) },
>  	/* GB200 SKU */
>  	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2941) },
> +	/* GB300 SKU */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x31C2) },
>  	{}
>  };
>  

Applied to vfio next branch for v6.18.  Thanks,

Alex


