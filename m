Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B7E7CCDEF
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 22:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbjJQUZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 16:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344034AbjJQUZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 16:25:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D169E
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 13:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697574292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EtUjdWCB9WMQU/mTfw17tXlwwNnT6x1gJtmkKU4zsR8=;
        b=YjRaztP2OQbJVIQBEsJvEY5EG4oKJzG7uDCmyQZPWJsfSEW62IM9VgMRigoJh/11P7kC5o
        oH5Ndq2kkWQXZq3u6hGlvp3zZQEV8WF1gKv0rpwtUVU1DnrZqc/rcdvnNcMI57Mp/RFDLr
        4vgaavBtjrG2qz0dTDdLYWdG09OzbvY=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-eTkLlGfTNu6mZl1ElNDKQw-1; Tue, 17 Oct 2023 16:24:51 -0400
X-MC-Unique: eTkLlGfTNu6mZl1ElNDKQw-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3528544b1e5so32870435ab.0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 13:24:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697574291; x=1698179091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EtUjdWCB9WMQU/mTfw17tXlwwNnT6x1gJtmkKU4zsR8=;
        b=oANCvnv4WOk2uc/a6IumV9+O92Eb/h5M+NfJcVrhwjpxuN1rUeI6j9vNmNgiuvmXIk
         P4Bbui1UQZ4gB9NS2vPjvhzJRmuZHGMd+kWb9gLtaUF/9y3POV3nGJctJC2WnPgBgfy1
         9niJ0kdtf2D5nHVKbWcw7s3dmnGz+mcLfJfHThfEpkBJY86LUyZEllL+11pwaLtBCUt0
         xHAfq+L81FRhryZ8VfVwb6Pl4HcQdIdx4frBs/ngSgeucwckTGHvtYyJR4VNEv8xj6De
         HzM3gRyHGuexi6h9+tILnvNw5F823uji5zQQGPfsyV9XEikkwWmSbv5cBtrShQyXVkre
         LmWQ==
X-Gm-Message-State: AOJu0Yx7zB88UdKfag9XZBESRtBG+XqMw1jOedkGg5lGWP2Y5cRmy/Ul
        ml2DkXrH/a0XXBABmyM3ls/rh9ddFR5e42c6W+tueLjB/05OANyFplc3+pHoiOkig3+8Zd49u8q
        lxQ1qKGs9DLhO
X-Received: by 2002:a92:d98e:0:b0:34f:20d9:74a9 with SMTP id r14-20020a92d98e000000b0034f20d974a9mr2740339iln.11.1697574290778;
        Tue, 17 Oct 2023 13:24:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGlyFESvUm/reMsU2KMAu2LePTBp8vzSNdVO5O7BVyyVkEJDRLpPI9geTQERTRpMwuocgfjvA==
X-Received: by 2002:a92:d98e:0:b0:34f:20d9:74a9 with SMTP id r14-20020a92d98e000000b0034f20d974a9mr2740328iln.11.1697574290530;
        Tue, 17 Oct 2023 13:24:50 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id w14-20020a02cf8e000000b0045c79bb28d6sm683968jar.114.2023.10.17.13.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 13:24:50 -0700 (PDT)
Date:   Tue, 17 Oct 2023 14:24:48 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231017142448.08673cdc.alex.williamson@redhat.com>
In-Reply-To: <20231017134217.82497-10-yishaih@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
        <20231017134217.82497-10-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Oct 2023 16:42:17 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:
> +static int virtiovf_pci_probe(struct pci_dev *pdev,
> +			      const struct pci_device_id *id)
> +{
> +	const struct vfio_device_ops *ops = &virtiovf_acc_vfio_pci_ops;
> +	struct virtiovf_pci_core_device *virtvdev;
> +	int ret;
> +
> +	if (pdev->is_virtfn && virtiovf_support_legacy_access(pdev) &&
> +	    !virtiovf_bar0_exists(pdev) && pdev->msix_cap)
> +		ops = &virtiovf_acc_vfio_pci_tran_ops;


This is still an issue for me, it's a very narrow use case where we
have a modern device and want to enable legacy support.  Implementing an
IO BAR and mangling the device ID seems like it should be an opt-in,
not standard behavior for any compatible device.  Users should
generally expect that the device they see in the host is the device
they see in the guest.  They might even rely on that principle.

We can't use the argument that users wanting the default device should
use vfio-pci rather than virtio-vfio-pci because we've already defined
the algorithm by which libvirt should choose a variant driver for a
device.  libvirt will choose this driver for all virtio-net devices.

This driver effectively has the option to expose two different profiles
for the device, native or transitional.  We've discussed profile
support for variant drivers previously as an equivalent functionality
to mdev types, but the only use case for this currently is out-of-tree.
I think this might be the opportunity to define how device profiles are
exposed and selected in a variant driver.

Jason had previously suggested a devlink interface for this, but I
understand that path had been shot down by devlink developers.  Another
obvious option is sysfs, where we might imagine an optional "profiles"
directory, perhaps under vfio-dev.  Attributes of "available" and
"current" could allow discovery and selection of a profile similar to
mdev types.

Is this where we should head with this or are there other options to
confine this transitional behavior?

BTW, what is "acc" in virtiovf_acc_vfio_pci_ops?

> +
> +	virtvdev = vfio_alloc_device(virtiovf_pci_core_device, core_device.vdev,
> +				     &pdev->dev, ops);
> +	if (IS_ERR(virtvdev))
> +		return PTR_ERR(virtvdev);
> +
> +	dev_set_drvdata(&pdev->dev, &virtvdev->core_device);
> +	ret = vfio_pci_core_register_device(&virtvdev->core_device);
> +	if (ret)
> +		goto out;
> +	return 0;
> +out:
> +	vfio_put_device(&virtvdev->core_device.vdev);
> +	return ret;
> +}
> +
> +static void virtiovf_pci_remove(struct pci_dev *pdev)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
> +
> +	vfio_pci_core_unregister_device(&virtvdev->core_device);
> +	vfio_put_device(&virtvdev->core_device.vdev);
> +}
> +
> +static const struct pci_device_id virtiovf_pci_table[] = {
> +	/* Only virtio-net is supported/tested so far */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1041) },
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(pci, virtiovf_pci_table);
> +
> +static struct pci_driver virtiovf_pci_driver = {
> +	.name = KBUILD_MODNAME,
> +	.id_table = virtiovf_pci_table,
> +	.probe = virtiovf_pci_probe,
> +	.remove = virtiovf_pci_remove,
> +	.err_handler = &vfio_pci_core_err_handlers,
> +	.driver_managed_dma = true,
> +};
> +
> +module_pci_driver(virtiovf_pci_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
> +MODULE_DESCRIPTION(
> +	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO device family");

Not yet "family" per the device table.  Thanks,

Alex

