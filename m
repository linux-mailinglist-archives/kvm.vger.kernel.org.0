Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F804152B4
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 23:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237859AbhIVVZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 17:25:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237802AbhIVVZn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 17:25:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632345851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5bSXV/WbyIuvflNI0O5gv8cTQJk2LfpQktDl+auRuYw=;
        b=RaOfdIkvkcmxJccv6Rnz8ML0XfRXrH4mx5SvhD9o7j7Bcg6NIliufn6f51kROwXuUzcMR0
        ognTE7CaIzsU44T/9cP/0y8LFzFS+JyXxyrv7btxuOwbs/fc0ng0OYuCPuJLI/HsWCih0e
        gf/QZt23/9SxRvwPGcE8q1Ng9I6hHjw=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-VkB6kjujNueKJe82f0oqug-1; Wed, 22 Sep 2021 17:24:10 -0400
X-MC-Unique: VkB6kjujNueKJe82f0oqug-1
Received: by mail-oi1-f198.google.com with SMTP id 20-20020aca2814000000b002690d9b60aaso2613553oix.0
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 14:24:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5bSXV/WbyIuvflNI0O5gv8cTQJk2LfpQktDl+auRuYw=;
        b=btTqN3auyNX5BntVMmTZy8KD0N3TBvZKJfzEkDRQR/mDBsbwrDQl+XOz6MpTFVlntV
         GjgkaoxZqDW6GfYWylImIHIgXeU03JkS7hfxV3sOmRFB5gjKdAerRwvP4Sg2KMAVoD8Q
         X+jCBYBtQX769+6bOmZ+AyjTYZAp4NyPFemphQ7YJutbqEXV1+HIO6YZ+gh0Jxgc47w3
         5+fQKTKzs1+1K8v/l+xQpioyNZD1+VBYIAZteDKz9AH3RrFvIGAEa8DO/wBBb4oOpGee
         tVTHmtRsSxmDqu3zHmQIjuq+x2dYaJ9jIRaIVEt6wNbFXVYa6XPlhFLHPTEORn6Oo7o8
         W4WQ==
X-Gm-Message-State: AOAM5308C9RsVv16xcLPfyGx5W5kutcNwUIg2KBbR08OlgjYmiyD95K/
        jV3ofWfW/TRJHrwcfFG2DT60dukC7/6ynNgq7+qnzeZLWJsl/87Oe0PHPWjjZVGDOh1v/yNmu02
        0Ta8X0B/eThM5
X-Received: by 2002:a05:6808:2026:: with SMTP id q38mr1062579oiw.15.1632345849576;
        Wed, 22 Sep 2021 14:24:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxdoCWR7q3blhAcNoLIpqhCzivqr2u9tYk00GR6mvZvaI93uSxrNhlQY0cnvU77gFLtK4G4DA==
X-Received: by 2002:a05:6808:2026:: with SMTP id q38mr1062549oiw.15.1632345849392;
        Wed, 22 Sep 2021 14:24:09 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id s24sm788936otp.36.2021.09.22.14.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 14:24:09 -0700 (PDT)
Date:   Wed, 22 Sep 2021 15:24:07 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, hch@lst.de, jasowang@redhat.com, joro@8bytes.org,
        jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@linux.intel.com, jun.j.tian@intel.com, hao.wu@intel.com,
        dave.jiang@intel.com, jacob.jun.pan@linux.intel.com,
        kwankhede@nvidia.com, robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
In-Reply-To: <20210919063848.1476776-11-yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
        <20210919063848.1476776-11-yi.l.liu@intel.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 19 Sep 2021 14:38:38 +0800
Liu Yi L <yi.l.liu@intel.com> wrote:

> +struct iommu_device_info {
> +	__u32	argsz;
> +	__u32	flags;
> +#define IOMMU_DEVICE_INFO_ENFORCE_SNOOP	(1 << 0) /* IOMMU enforced snoop */

Is this too PCI specific, or perhaps too much of the mechanism rather
than the result?  ie. should we just indicate if the IOMMU guarantees
coherent DMA?  Thanks,

Alex

> +#define IOMMU_DEVICE_INFO_PGSIZES	(1 << 1) /* supported page sizes */
> +#define IOMMU_DEVICE_INFO_ADDR_WIDTH	(1 << 2) /* addr_wdith field valid */
> +	__u64	dev_cookie;
> +	__u64   pgsize_bitmap;
> +	__u32	addr_width;
> +};
> +
> +#define IOMMU_DEVICE_GET_INFO	_IO(IOMMU_TYPE, IOMMU_BASE + 1)
>  
>  #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
>  #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */

