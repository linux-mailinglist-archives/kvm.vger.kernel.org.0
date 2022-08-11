Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616B958F906
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 10:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbiHKI1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 04:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234479AbiHKI1m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 04:27:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 17A0290818
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 01:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660206461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fRCed6nnEDFTJS61x3dawnYdkP8v3FkULNF0fZ1BK3g=;
        b=BKCCDC4v+T7/wizwn/5rKrvE5nI9x0VKsvi/ET4ftdk/liUaUuoDFASYwOQ9ciBIKjswGK
        H+ySb4xs1EN5u58DB+mK4KIuIjSXh6NWJ0ikTb/91pyayfmLhkLTxugH8cdoUfaYKhdo+l
        XTHT5bxXwKp7CDC9biKqpIoSvUgUlps=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-Jg75HPcKPJeoyGsIRk5esg-1; Thu, 11 Aug 2022 04:27:40 -0400
X-MC-Unique: Jg75HPcKPJeoyGsIRk5esg-1
Received: by mail-wm1-f70.google.com with SMTP id b16-20020a05600c4e1000b003a5a47762c3so2663356wmq.9
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 01:27:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=fRCed6nnEDFTJS61x3dawnYdkP8v3FkULNF0fZ1BK3g=;
        b=aImNZH+0RKYesRdpUxdwJ1pBIqMURKSfH3eO/0O7g2hxny8SV9PfpBxSnrI/ljsWpr
         PA+QM2otytydVya0TJbQXZS+10Vwlw6MZ1BW8UG+GQ53DhzqHgqRnciWS64zJC8NrLmO
         +8Uf+VhTAEHOkrmHbtYO8nu1hapzt903To2hDSSfxpBzgDDBf7swNYN9eszR44rwf4QB
         Mrd1Y/BCNzRuvJZLBCnhIN9zyJ15o3vRMijni3vpmX2geHuTuEPcNw0mhkSo6nk8mDaZ
         hdGdzw/zkEfV3b3o18ApcgJoAKA3Ta6AC8nv2J76d6ov3CCKI8XJ8f15Y75ZC1uHPIvJ
         dceQ==
X-Gm-Message-State: ACgBeo1GigCAcVbJZpxohNc9deoudA9bT+dBlBr2BaYLOcBB1tlCD6PY
        Pim2fpgsBfsbTLg8sKjd9bGePahH9n/H7GTkLKwA4TbNaUAsIitTmKzL1QeJwJ1+6ADYUiRz5aR
        P6gQPlGRN/nMC
X-Received: by 2002:a1c:a3c4:0:b0:3a5:512f:717a with SMTP id m187-20020a1ca3c4000000b003a5512f717amr4823100wme.192.1660206458783;
        Thu, 11 Aug 2022 01:27:38 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5sw3H77GbQvlSeiH8m701pegTIDjU8UzoPnZf53/Xhmt7IzjB7QDado1bpqhPaIYYSo6lqUw==
X-Received: by 2002:a1c:a3c4:0:b0:3a5:512f:717a with SMTP id m187-20020a1ca3c4000000b003a5512f717amr4823072wme.192.1660206458571;
        Thu, 11 Aug 2022 01:27:38 -0700 (PDT)
Received: from redhat.com ([2.52.152.113])
        by smtp.gmail.com with ESMTPSA id m7-20020a056000008700b00222ed7ea203sm8822453wrx.100.2022.08.11.01.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 01:27:37 -0700 (PDT)
Date:   Thu, 11 Aug 2022 04:27:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dinang@xilinx.com, martinpo@xilinx.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Piotr.Uminski@intel.com, gautam.dawar@amd.com,
        ecree.xilinx@gmail.com, martinh@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>, pabloc@xilinx.com,
        habetsm.xilinx@gmail.com, lvivier@redhat.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, tanuj.kamde@amd.com,
        Longpeng <longpeng2@huawei.com>, lulu@redhat.com,
        hanand@xilinx.com, Parav Pandit <parav@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Eli Cohen <elic@nvidia.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH v7 1/4] vdpa: Add suspend operation
Message-ID: <20220811042717-mutt-send-email-mst@kernel.org>
References: <20220810171512.2343333-1-eperezma@redhat.com>
 <20220810171512.2343333-2-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220810171512.2343333-2-eperezma@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022 at 07:15:09PM +0200, Eugenio Pérez wrote:
> This operation is optional: It it's not implemented, backend feature bit
> will not be exposed.
> 
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> Message-Id: <20220623160738.632852-2-eperezma@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

What is this message id doing here?

> ---
>  include/linux/vdpa.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 7b4a13d3bd91..d282f464d2f1 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -218,6 +218,9 @@ struct vdpa_map_file {
>   * @reset:			Reset device
>   *				@vdev: vdpa device
>   *				Returns integer: success (0) or error (< 0)
> + * @suspend:			Suspend or resume the device (optional)
> + *				@vdev: vdpa device
> + *				Returns integer: success (0) or error (< 0)
>   * @get_config_size:		Get the size of the configuration space includes
>   *				fields that are conditional on feature bits.
>   *				@vdev: vdpa device
> @@ -319,6 +322,7 @@ struct vdpa_config_ops {
>  	u8 (*get_status)(struct vdpa_device *vdev);
>  	void (*set_status)(struct vdpa_device *vdev, u8 status);
>  	int (*reset)(struct vdpa_device *vdev);
> +	int (*suspend)(struct vdpa_device *vdev);
>  	size_t (*get_config_size)(struct vdpa_device *vdev);
>  	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
>  			   void *buf, unsigned int len);
> -- 
> 2.31.1

