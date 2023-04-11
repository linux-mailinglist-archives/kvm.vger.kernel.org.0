Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C026C6DE4F8
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 21:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDKT3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 15:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDKT3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 15:29:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CA7E59
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 12:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681241298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t9httPKRPvyX3l4CIJ8FsnI5lzFfyGrUe3dv0wTuPIs=;
        b=asuJj74mlV+EcoIne2evIawOX5LG5IrCvGvoPh7ldzgxXyrCHVx1hK0Mx8IbIWh08PWy/8
        4loD6t3L1XUKqodcpAUHqfLqzoUksWWTen8EM09khZwsvyclwQV8+cOcdjvDc2/iNv4v/+
        NEXUHCw+cD5XsWHlUDc4AO0tAHxHe4w=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-5F1NHyVtOZCSo-Up15IHtQ-1; Tue, 11 Apr 2023 15:28:17 -0400
X-MC-Unique: 5F1NHyVtOZCSo-Up15IHtQ-1
Received: by mail-io1-f69.google.com with SMTP id l125-20020a6bbb83000000b0074cfcc4ed07so6425356iof.22
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 12:28:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681241296; x=1683833296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t9httPKRPvyX3l4CIJ8FsnI5lzFfyGrUe3dv0wTuPIs=;
        b=SpYbZ6EEFonnpcJWg63roW5YlaqNvnQ3xnbkEBC1kFgiioNRTo0WV+6IVkF0oamfN9
         M8GugDV2z3r9JiVIeSa8K3hJH9OHjGAf+a5bp7lEfUxGVhzzi+TmiPN+1wrDSMWL2hAt
         DKOQ45uUnR8M38S9rydblhpv+jwycLuFvkV44OIyTjG0wOFS3xFf912PMDt/489O1Ir2
         mTszoUC/zvjDH49fOLLK2p/qu0G1fvZ9ROzYAfooYKQpumj/Be9qLQwcSDNZgBQAijDH
         70qsR6xSKZl9dDepvog0OVAYM/2KjGBZH26IdklXKbtQdvxVuShKJ9GFVhVRbqZggm4D
         VzYQ==
X-Gm-Message-State: AAQBX9dmGuDL7qUkDHuYmSlXi16ikwolsyW7wQhZIQCJw0pkRb4fNzRa
        +tGxzXE2E7w0bP6TqHxEJa7BmrlponEL5TWswGVzp55iz+YVDyiJpZoGhHE29N9MSl+/oI9AbUx
        Uglam4a+y48zN0K04btMy
X-Received: by 2002:a5d:8347:0:b0:75c:3b4a:d13f with SMTP id q7-20020a5d8347000000b0075c3b4ad13fmr6945921ior.14.1681241296392;
        Tue, 11 Apr 2023 12:28:16 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZFZEqAD1wW0unrC7yaotOQLLBq0VMSoxYRuJYdGFGv8EyeBTYQ4zE/z6TM+2eVXwuaoKdxOQ==
X-Received: by 2002:a5d:8347:0:b0:75c:3b4a:d13f with SMTP id q7-20020a5d8347000000b0075c3b4ad13fmr6945909ior.14.1681241296149;
        Tue, 11 Apr 2023 12:28:16 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v3-20020a92c6c3000000b003292f183c95sm113795ilm.58.2023.04.11.12.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 12:28:15 -0700 (PDT)
Date:   Tue, 11 Apr 2023 13:28:06 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca, kevin.tian@intel.com,
        michal.winiarski@intel.com, dave.jiang@intel.com,
        ashok.raj@intel.com
Subject: Re: [PATCH v2] vfio/pci: Add DVSEC PCI Extended Config Capability
 to user visible list.
Message-ID: <20230411132806.4da1c86f.alex.williamson@redhat.com>
In-Reply-To: <20230317082222.3355912-1-satyanarayana.k.v.p@intel.com>
References: <20230317082222.3355912-1-satyanarayana.k.v.p@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Mar 2023 08:22:22 +0000
"K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com> wrote:

> The Designated Vendor-Specific Extended Capability (DVSEC Capability) is an
> optional Extended Capability that is permitted to be implemented by any PCI
> Express Function. This allows PCI Express component vendors to use
> the Extended Capability mechanism to expose vendor-specific registers that can
> be present in components by a variety of vendors. A DVSEC Capability structure
> can tell vendor-specific software which features a particular component
> supports.
> 
> An example usage of DVSEC is Intel Platform Monitoring Technology (PMT) for
> enumerating and accessing hardware monitoring capabilities on a device.
> PMT encompasses three device monitoring features, Telemetry (device metrics),
> Watcher (sampling/tracing), and Crashlog. The DVSEC is used to discover these
> features and provide a BAR offset to their registers with the Intel vendor code.
> 
> The current VFIO driver does not pass DVSEC capabilities to Virtual Machine (VM)
> which makes PMT not to work inside the virtual machine. This series adds DVSEC
> capability to user visible list to allow its use with VFIO. VFIO supports
> passing of Vendor Specific Extended Capability (VSEC) and raw write access to
> device. DVSEC also passed to VM in the same way as of VSEC.
> 
> Signed-off-by: K V P Satyanarayana <satyanarayana.k.v.p@intel.com>
> 
> Changes since Version V2:
> - Added support for raw pci write for DVSEC same as VSEC.
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 7 +++++++
>  1 file changed, 7 insertions(+)

Applied to vfio next branch for v6.4.  Thanks,

Alex

> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 523e0144c86f..948cdd464f4e 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -96,6 +96,7 @@ static const u16 pci_ext_cap_length[PCI_EXT_CAP_ID_MAX + 1] = {
>  	[PCI_EXT_CAP_ID_SECPCI]	=	0,	/* not yet */
>  	[PCI_EXT_CAP_ID_PMUX]	=	0,	/* not yet */
>  	[PCI_EXT_CAP_ID_PASID]	=	0,	/* not yet */
> +	[PCI_EXT_CAP_ID_DVSEC]	=	0xFF,
>  };
>  
>  /*
> @@ -1101,6 +1102,7 @@ int __init vfio_pci_init_perm_bits(void)
>  	ret |= init_pci_ext_cap_err_perm(&ecap_perms[PCI_EXT_CAP_ID_ERR]);
>  	ret |= init_pci_ext_cap_pwr_perm(&ecap_perms[PCI_EXT_CAP_ID_PWR]);
>  	ecap_perms[PCI_EXT_CAP_ID_VNDR].writefn = vfio_raw_config_write;
> +	ecap_perms[PCI_EXT_CAP_ID_DVSEC].writefn = vfio_raw_config_write;
>  
>  	if (ret)
>  		vfio_pci_uninit_perm_bits();
> @@ -1440,6 +1442,11 @@ static int vfio_ext_cap_len(struct vfio_pci_core_device *vdev, u16 ecap, u16 epo
>  			return PCI_TPH_BASE_SIZEOF + (sts * 2) + 2;
>  		}
>  		return PCI_TPH_BASE_SIZEOF;
> +	case PCI_EXT_CAP_ID_DVSEC:
> +		ret = pci_read_config_dword(pdev, epos + PCI_DVSEC_HEADER1, &dword);
> +		if (ret)
> +			return pcibios_err_to_errno(ret);
> +		return PCI_DVSEC_HEADER1_LEN(dword);
>  	default:
>  		pci_warn(pdev, "%s: unknown length for PCI ecap %#x@%#x\n",
>  			 __func__, ecap, epos);

