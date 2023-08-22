Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9195784A61
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 21:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjHVT0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 15:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjHVT0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 15:26:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86BCE40
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 12:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692732321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KmPOg9DvMteU/NG+0kZXy4KRyPDAtWZoS7j3SG6N+yY=;
        b=YFMb39CMWmhI5NW1UFYAuTV/T3YpXPXB40E2xGMalcrmdd0uzMB/c+9GMMJUX0YjTsQDmu
        zoZcV9dQ9DbgHfAVKJiA0aFFh3Hrb4aBG0JknPefyhp5kCoab1I/w5KRggyqEWMqlpyR6I
        36Y32KD5B1RUWOeDpjQNNBFaBHzeNkI=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-j0vYDqK4MXKrjRrL8MIj7Q-1; Tue, 22 Aug 2023 15:25:19 -0400
X-MC-Unique: j0vYDqK4MXKrjRrL8MIj7Q-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6b9c744df27so4600533a34.2
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 12:25:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692732319; x=1693337119;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KmPOg9DvMteU/NG+0kZXy4KRyPDAtWZoS7j3SG6N+yY=;
        b=laJFEbCWHkFJ8ToRz6yYRqdEGKxRZyWEiQiWd92xQh/vgKzRqUhpwFtPhyZ7JOseNL
         Y2s/Iw2qljiXlHfQtkQGfUlFkKRLEe7kyHfefSOYgX4ai7l6sNjkazJLz94/32RzM2sO
         w2Z3Vzyvy7V1z5kbIqQMFZndWesiwRLvE655/1kwJ1Kgeyk3KWMRETt2Fk17OW2sWtUf
         Swgn0DezmB65n3zmrMEdESNxYVhqmxL/gz2H2ND/5NFsGlF3gxPIxv8WjANPEDSoLhep
         oT1yUmAwK+zbtccG521X2csLbe7/OuBGaYj0cCh0fDfSG2REKCh+C+OGPMYTnW+w7/is
         nD7g==
X-Gm-Message-State: AOJu0YxvliMRB6zj47vcdSN1qlJg4gcQA1ckxP0XiSkS79viqKPt4+PX
        8/vC4JX/AJw7ZjO6Ysjd0pj21xr4Y6exjzG0bu+fMjnm4yQMRj5f7pzNb0Rk2OJ14+jiAN2hpXo
        NuikWXD/dlEUK
X-Received: by 2002:a05:6830:1dae:b0:6b8:7d12:423d with SMTP id z14-20020a0568301dae00b006b87d12423dmr9464528oti.18.1692732318894;
        Tue, 22 Aug 2023 12:25:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHVSVa8YWQKWZRoR2F6ZHKC2dhlJzbVFI68d2qU3IG2H4ZRkvaanWpsM1ThlZDIKYVNCAJCA==
X-Received: by 2002:a05:6830:1dae:b0:6b8:7d12:423d with SMTP id z14-20020a0568301dae00b006b87d12423dmr9464520oti.18.1692732318664;
        Tue, 22 Aug 2023 12:25:18 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id t12-20020a0568301e2c00b006b8bf76174fsm4895737otr.21.2023.08.22.12.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 12:25:17 -0700 (PDT)
Date:   Tue, 22 Aug 2023 13:25:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>, <shannon.nelson@amd.com>
Subject: Re: [PATCH vfio] vfio/pds: Send type for SUSPEND_STATUS command
Message-ID: <20230822132515.51cacfc0.alex.williamson@redhat.com>
In-Reply-To: <20230821184215.34564-1-brett.creeley@amd.com>
References: <20230821184215.34564-1-brett.creeley@amd.com>
Organization: Red Hat
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

On Mon, 21 Aug 2023 11:42:15 -0700
Brett Creeley <brett.creeley@amd.com> wrote:

> Commit bb500dbe2ac6 ("vfio/pds: Add VFIO live migration support")
> added live migration support for the pds-vfio-pci driver. When
> sending the SUSPEND command to the device, the driver sets the
> type of suspend (i.e. P2P or FULL). However, the driver isn't
> sending the type of suspend for the SUSPEND_STATUS command, which
> will result in failures. Fix this by also sending the suspend type
> in the SUSPEND_STATUS command.
> 
> Fixes: bb500dbe2ac6 ("vfio/pds: Add VFIO live migration support")
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vfio/pci/pds/cmds.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Applied to vfio next branch for v6.6.  Thanks,

Alex

> 
> diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
> index b0d88442b091..36463ccc3df9 100644
> --- a/drivers/vfio/pci/pds/cmds.c
> +++ b/drivers/vfio/pci/pds/cmds.c
> @@ -86,12 +86,13 @@ void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
>  }
>  
>  static int
> -pds_vfio_suspend_wait_device_cmd(struct pds_vfio_pci_device *pds_vfio)
> +pds_vfio_suspend_wait_device_cmd(struct pds_vfio_pci_device *pds_vfio, u8 type)
>  {
>  	union pds_core_adminq_cmd cmd = {
>  		.lm_suspend_status = {
>  			.opcode = PDS_LM_CMD_SUSPEND_STATUS,
>  			.vf_id = cpu_to_le16(pds_vfio->vf_id),
> +			.type = type,
>  		},
>  	};
>  	struct device *dev = pds_vfio_to_dev(pds_vfio);
> @@ -156,7 +157,7 @@ int pds_vfio_suspend_device_cmd(struct pds_vfio_pci_device *pds_vfio, u8 type)
>  	 * The subsequent suspend status request(s) check if the firmware has
>  	 * completed the device suspend process.
>  	 */
> -	return pds_vfio_suspend_wait_device_cmd(pds_vfio);
> +	return pds_vfio_suspend_wait_device_cmd(pds_vfio, type);
>  }
>  
>  int pds_vfio_resume_device_cmd(struct pds_vfio_pci_device *pds_vfio, u8 type)

