Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BF952AAB2
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 20:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350096AbiEQS1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 14:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242122AbiEQS1S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 14:27:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC14138794
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 11:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652812035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=808kPoCVZ9QBXQQ50NY9PebUEFZ1B+K2Bsp/en8vgGY=;
        b=hIpYi/sGN2DecSuoV+aN+/5uy97WasBMnQL/n4kbh3XyBo3J2E4ufENMgixlxA7jfbwPyq
        NSG5GKRT4CCuW2QxV837+nuhLlAjJdFkVPD56gWrlx0tybTB4tsQsuIPvEc3mpfEifh+1m
        79SrGJrgyTzkl3S1Q8OSGSJEmuOjDy0=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-83-xwtDGy0KNLKATBfctJYoYA-1; Tue, 17 May 2022 14:27:14 -0400
X-MC-Unique: xwtDGy0KNLKATBfctJYoYA-1
Received: by mail-il1-f198.google.com with SMTP id i4-20020a056e021b0400b002d14f2abad7so41564ilv.5
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 11:27:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=808kPoCVZ9QBXQQ50NY9PebUEFZ1B+K2Bsp/en8vgGY=;
        b=4f5IA1+m/qgbBVdCXAhUNSo9J743/XZbDXE45coSc6oN390Z5rT1arJheZKS8cdd3z
         tpmqz6+TVdUp0vxZtkOjkGgiTUwAiYkfIqnHHinJEstbMCxz+0K2jhclt0XvYWLTKZpw
         H9kF+1w7v0+fweSYRuR/b2QHW7Df+9IjnujfWrmj5WMhyqZQd7lWU+yAgXIXSJTFRPC2
         llWfOpl3uEtPvYeDfiLbpKiST5MHtkj+4UfgsNIwJo3OfxSWbdAW2/Y1i4kQK0WvhapE
         KRVqYxlnY80PipPg6ruAD0jVcIq0KYIdgr8eFwj2AMZs1sLRep9FAJ8h3N6Ozco0y9cS
         y2mg==
X-Gm-Message-State: AOAM530Z5CHhUx6q9ocU/gn+6dEL/XkV0tX8GBbYpjwU+b/sJpMNUSZW
        4Heimvzd1Ony3brvGfwBRT9cxgqra99aa5v7pJEDM6/WjwtbOrQDzv8S87lE6oteTkgYms1pb9+
        AQUSIUcuC5Cw+
X-Received: by 2002:a05:6638:140d:b0:32b:c643:e334 with SMTP id k13-20020a056638140d00b0032bc643e334mr13045259jad.125.1652812033714;
        Tue, 17 May 2022 11:27:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXPnig6pt33JX7CJmiZk9MZj+x43/FCA6lZpbkCX+oaIPq/UYqAVOL24lvn/cJscVyWc3kyA==
X-Received: by 2002:a05:6638:140d:b0:32b:c643:e334 with SMTP id k13-20020a056638140d00b0032bc643e334mr13045242jad.125.1652812033478;
        Tue, 17 May 2022 11:27:13 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r4-20020a02c844000000b0032e2dce10aesm1885083jao.160.2022.05.17.11.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:27:12 -0700 (PDT)
Date:   Tue, 17 May 2022 12:27:10 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v4 2/4] vfio/pci: Change the PF power state to D0 before
 enabling VFs
Message-ID: <20220517122710.093c9c19.alex.williamson@redhat.com>
In-Reply-To: <20220517100219.15146-3-abhsahu@nvidia.com>
References: <20220517100219.15146-1-abhsahu@nvidia.com>
        <20220517100219.15146-3-abhsahu@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 May 2022 15:32:17 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> According to [PCIe v5 9.6.2] for PF Device Power Management States
> 
>  "The PF's power management state (D-state) has global impact on its
>   associated VFs. If a VF does not implement the Power Management
>   Capability, then it behaves as if it is in an equivalent
>   power state of its associated PF.
> 
>   If a VF implements the Power Management Capability, the Device behavior
>   is undefined if the PF is placed in a lower power state than the VF.
>   Software should avoid this situation by placing all VFs in lower power
>   state before lowering their associated PF's power state."
> 
> From the vfio driver side, user can enable SR-IOV when the PF is in D3hot
> state. If VF does not implement the Power Management Capability, then
> the VF will be actually in D3hot state and then the VF BAR access will
> fail. If VF implements the Power Management Capability, then VF will
> assume that its current power state is D0 when the PF is D3hot and
> in this case, the behavior is undefined.
> 
> To support PF power management, we need to create power management
> dependency between PF and its VF's. The runtime power management support
> may help with this where power management dependencies are supported
> through device links. But till we have such support in place, we can
> disallow the PF to go into low power state, if PF has VF enabled.
> There can be a case, where user first enables the VF's and then
> disables the VF's. If there is no user of PF, then the PF can put into
> D3hot state again. But with this patch, the PF will still be in D0
> state after disabling VF's since detecting this case inside
> vfio_pci_core_sriov_configure() requires access to
> struct vfio_device::open_count along with its locks. But the subsequent
> patches related to runtime PM will handle this case since runtime PM
> maintains its own usage count.
> 
> Also, vfio_pci_core_sriov_configure() can be called at any time
> (with and without vfio pci device user), so the power state change
> needs to be protected with the required locks.
> 
> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index b9f222ca48cf..4fe9a4efc751 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -217,6 +217,10 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>  	bool needs_restore = false, needs_save = false;
>  	int ret;
>  
> +	/* Prevent changing power state for PFs with VFs enabled */
> +	if (pci_num_vf(pdev) && state > PCI_D0)
> +		return -EBUSY;
> +
>  	if (vdev->needs_pm_restore) {
>  		if (pdev->current_state < PCI_D3hot && state >= PCI_D3hot) {
>  			pci_save_state(pdev);
> @@ -1960,6 +1964,13 @@ int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
>  		}
>  		list_add_tail(&vdev->sriov_pfs_item, &vfio_pci_sriov_pfs);
>  		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
> +
> +		/*
> +		 * The PF power state should always be higher than the VF power
> +		 * state. If PF is in the low power state, then change the
> +		 * power state to D0 first before enabling SR-IOV.
> +		 */
> +		vfio_pci_lock_and_set_power_state(vdev, PCI_D0);

But we need to hold memory_lock across the next function or else
userspace could race a write to the PM register to set D3 before
pci_num_vf() can protect us.  Thanks,

Alex

>  		ret = pci_enable_sriov(pdev, nr_virtfn);
>  		if (ret)
>  			goto out_del;

