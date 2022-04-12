Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391FA4FE7E9
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 20:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358492AbiDLS2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 14:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352388AbiDLS2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 14:28:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34D0F5132D
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 11:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649787949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zr6bTAu62Yc6ACXuxK5YiD1+cRvjwLYTb92CvqVD1MY=;
        b=R04jo9yggoIYo+72aYYuNI+O8xbqe9UirS+bo2BDD1deMpgBrix/ELBR9SxxfuXrz8RBmO
        uE5Cg2ttVC2RXQDDrROuONkcJrzsrGNurr0+AQN155ohBeAMRGXPQNPZN1xDZW5U3Bcuyu
        MkPpgnWrca0AMePcNPLg/2Tnn9TxR+Y=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-Q_VbgTzmOrqFYrp1Z2mGHg-1; Tue, 12 Apr 2022 14:25:47 -0400
X-MC-Unique: Q_VbgTzmOrqFYrp1Z2mGHg-1
Received: by mail-io1-f70.google.com with SMTP id f11-20020a056602070b00b00645d08010fcso12060830iox.15
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 11:25:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Zr6bTAu62Yc6ACXuxK5YiD1+cRvjwLYTb92CvqVD1MY=;
        b=j6Ve129a4U322cQ9Go5wBvN04gqvoIjWC0KR7eMC1u6ZkvE7I2hQYHwXHrhdwhdJBz
         mUBYoE58pZ2bRw+e9sXG4LK6as7L4VOawkQrMDEY33OCNmsndkOhWC/HCg7oigvPQGJT
         82iuHkSfb4zppZhkdtxx2VyUDM4oKJBTownjfROTCwOKF+GVa5JWmmIVlPxiZNRBsEiG
         X5HuR4MvkuV1/qRX/Yj0j/oZ4WsS1yBkBh1AonV/imzLHb83WNW3BCMbBJ81Ms9W5uVU
         47GTIquTBZ/8/Mb4JMOB+cijyN0RQL11Y77Q0/jHbwP94W+pLKTU5YQP7g3hukomi7es
         n/0A==
X-Gm-Message-State: AOAM531f97IjhiTx/HTA99CVymjEocbLPm7RbNZ747e2s5+5BEYlPLlY
        jZqMG3tF45wY3NHNCkjOmA+V5SKrQVqbHSsgdTmYmSHddtEGOfaUyctBPllnuiBFQBUgN1QdFI3
        cXQRbva6S4QyT
X-Received: by 2002:a92:c244:0:b0:2ca:1a82:2364 with SMTP id k4-20020a92c244000000b002ca1a822364mr16490158ilo.69.1649787946955;
        Tue, 12 Apr 2022 11:25:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTQxUE6Ize8kxqQrF9l4JSdWmEVNZcycwRY+KSfmF51JWDkdy2fJkwYPjlneQQe3ChLMwiog==
X-Received: by 2002:a92:c244:0:b0:2ca:1a82:2364 with SMTP id k4-20020a92c244000000b002ca1a822364mr16490151ilo.69.1649787946755;
        Tue, 12 Apr 2022 11:25:46 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v18-20020a6b5b12000000b00645bd8bd288sm22519849ioh.47.2022.04.12.11.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:25:46 -0700 (PDT)
Date:   Tue, 12 Apr 2022 12:25:44 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH v2] vfio/pci: Fix vf_token mechanism when
 device-specific VF drivers are used
Message-ID: <20220412122544.4a56f20a.alex.williamson@redhat.com>
In-Reply-To: <0-v2-fe53fe3adce2+265-vfio_vf_token_jgg@nvidia.com>
References: <0-v2-fe53fe3adce2+265-vfio_vf_token_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Apr 2022 10:56:31 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> @@ -1732,10 +1705,28 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
>  static int vfio_pci_vf_init(struct vfio_pci_core_device *vdev)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
> +	struct vfio_pci_core_device *cur;
> +	struct pci_dev *physfn;
>  	int ret;
>  
> -	if (!pdev->is_physfn)
> +	if (!pdev->is_physfn) {
> +		/*
> +		 * If this VF was created by our vfio_pci_core_sriov_configure()
> +		 * then we can find the PF vfio_pci_core_device now, and due to
> +		 * the locking in pci_disable_sriov() it cannot change until
> +		 * this VF device driver is removed.
> +		 */
> +		physfn = pci_physfn(vdev->pdev);
> +		mutex_lock(&vfio_pci_sriov_pfs_mutex);
> +		list_for_each_entry (cur, &vfio_pci_sriov_pfs, sriov_pfs_item) {
> +			if (cur->pdev == physfn) {
> +				vdev->sriov_pf_core_dev = cur;
> +				break;
> +			}
> +		}
> +		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
>  		return 0;
> +	}
>  
>  	vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
>  	if (!vdev->vf_token)

One more comment on final review; are we equating !is_physfn to
is_virtfn above?  This branch was originally meant to kick out both VFs
and non-SRIOV PFs.  Calling pci_physfn() on a !is_virtfn device will
return itself, so we should never find a list match, but we also don't
need to look for a match for !is_virtfn, so it's a bit confusing and
slightly inefficient.  Should the new code be added in a separate
is_virtfn branch above the existing !is_physfn test?  Thanks,

Alex

