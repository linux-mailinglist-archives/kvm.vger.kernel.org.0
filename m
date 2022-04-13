Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4334FFD0F
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 19:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237458AbiDMRr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 13:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237456AbiDMRry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 13:47:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 95EA46D39B
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649871930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zp3p7vzzBbxTrFArpXdNKfukjfLlxQZImC25sHHrDgs=;
        b=UYJwzg31/quAtqspEbiJj5NegZbJWubSU7XprNCmBZguCov6I6jlCqyII/qwXxfWnmT1cF
        U3ekggCWT5wlca3Ml2fFjbFVjM14tg5lrloXfCz95gVb7wIt8rsVo3Axn2GUYSc34sRpqJ
        6ZPH5Autgi1S8+8pEaJuiYYUWlYXJgQ=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-asQ7P-vXMumOl1T1cDCK5w-1; Wed, 13 Apr 2022 13:45:29 -0400
X-MC-Unique: asQ7P-vXMumOl1T1cDCK5w-1
Received: by mail-il1-f197.google.com with SMTP id p10-20020a056e02104a00b002caa828f7b1so1570948ilj.7
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zp3p7vzzBbxTrFArpXdNKfukjfLlxQZImC25sHHrDgs=;
        b=mnRE3Q1UtW8sQkfrvsKFNRb9GJsSM+Tjbw0Y0XO6OZPqVfJDZCs+9/jKkDukIc/yzt
         HP1JNIOWikEsqfI7eLLLcA6u9gSz+lG1jYfLV3ucaYS1PYzZdOGKP1WbCr+/zhjy9lun
         9TrvkBY0abJT14h0sML5vIzE7+NbauipWzIuHmVjyOJZeHDiOjoJ1mMzZnrUL3GAsrck
         ThF5/A3aQ1aZ5Ek5chLFUBmBxJFogJqVyl99Q13u15brvq1ewZuRE0Soj4DOQ0Ax9oCr
         FwJRGjFXt8d0gQ/LdE9ZKLoqNUD3M90Shwd/tE1yqxI6NfSOXxSXAfwYGymNdMhg1Dcz
         47Bg==
X-Gm-Message-State: AOAM5310Ugb/pLanzCvudDhWNOkmqf9sVwUAG9uPwFOhY5heiY06b9x9
        mPjXdqWSqfTue5bhQjfxcYd0SXkrvWdpEtEYFf2XSv6xMJK9YFCvKxiPVXKPItTd6HcweLeHsec
        Pd83DVLkvQYdz
X-Received: by 2002:a05:6638:2510:b0:323:dcd9:91dd with SMTP id v16-20020a056638251000b00323dcd991ddmr22018063jat.168.1649871928684;
        Wed, 13 Apr 2022 10:45:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxS9qKMXMadm0+pALUqrKaqlSWfYqHHM9MdLbhNvztQeb4TQwdZARE/Rg2usoPvGEU4kVsoSg==
X-Received: by 2002:a05:6638:2510:b0:323:dcd9:91dd with SMTP id v16-20020a056638251000b00323dcd991ddmr22018048jat.168.1649871928486;
        Wed, 13 Apr 2022 10:45:28 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id ay18-20020a5d9d92000000b0064c77f6aaecsm399035iob.3.2022.04.13.10.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 10:45:27 -0700 (PDT)
Date:   Wed, 13 Apr 2022 11:45:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3] vfio/pci: Fix vf_token mechanism when
 device-specific VF drivers are used
Message-ID: <20220413114525.534d8b76.alex.williamson@redhat.com>
In-Reply-To: <0-v3-876570980634+f2e8-vfio_vf_token_jgg@nvidia.com>
References: <0-v3-876570980634+f2e8-vfio_vf_token_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Apr 2022 10:10:36 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:
> @@ -1732,8 +1705,30 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
>  static int vfio_pci_vf_init(struct vfio_pci_core_device *vdev)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
> +	struct vfio_pci_core_device *cur;
> +	struct pci_dev *physfn;
>  	int ret;
>  
> +	if (pdev->is_virtfn) {
> +		/*
> +		 * If this VF was created by our vfio_pci_core_sriov_configure()
> +		 * then we can find the PF vfio_pci_core_device now, and due to
> +		 * the locking in pci_disable_sriov() it cannot change until
> +		 * this VF device driver is removed.
> +		 */
> +		physfn = pci_physfn(vdev->pdev);
> +		mutex_lock(&vfio_pci_sriov_pfs_mutex);
> +		list_for_each_entry (cur, &vfio_pci_sriov_pfs, sriov_pfs_item) {
                                   ^
                                   |
checkpatch noted the space here ----

Fixed on commit, looks good otherwise.  Applied to vfio for-linus
branch for v5.18.  Thanks,

Alex

