Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C7E535082
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 16:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243991AbiEZOXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 10:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242222AbiEZOXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 10:23:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BAA31C5DB3
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 07:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653575010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PIs2TnkQYfNX5UnfDwJthJ+utgn6CIbjyk+tWQwa1VU=;
        b=W8bfC2piwqgoF9yzadnqronglWO4nyR49R+gBdytb6ZkJ77D1wQTYWCMC4etXI2Vj0lfe0
        OvE7gDaCLmSjZ9LrqP/jEn2DrKKYeq1+hIHaLOowcWWBNAcbEhlVbu7zIROegh8zliZLS7
        s5/m4H/HgmEmdmQ5fdRPbJXuZa0U79U=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-362-8F1cxx0ZMiqNxLLMeb952g-1; Thu, 26 May 2022 10:23:29 -0400
X-MC-Unique: 8F1cxx0ZMiqNxLLMeb952g-1
Received: by mail-qk1-f198.google.com with SMTP id j12-20020a37c24c000000b006a375a433bbso1469206qkm.8
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 07:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PIs2TnkQYfNX5UnfDwJthJ+utgn6CIbjyk+tWQwa1VU=;
        b=aDHoCmxOzoh/ZlEnAxqHUcu8F8oAkOGugDgM7J9/KcQq6oORaXo8eKQE4kh2JEs8df
         6j/48vnRF67yu81LSDJ1c/50rcgb1nVC7iXiadlTADbb/DyBdEgMWwCZclMtIEHhrc4q
         acpKt2VQWgIEKN7qxuetZei3/467FayY9nZmkdUoeJVskNFwzxtpRtM4TA3pG4Djel8m
         99lAZspKwsJBvQ3xV8i7iO/16ZCLahDBob85ZAnLdAk7dqOg3SyqwPlh8M/E3lRDC+HZ
         7d1gtoxMcdJ2HyaLVXFOPDxp4P5tQml8S+7VPiuy257Yw81XI2Br6ZXk4aQxOHx3z5hJ
         9NiQ==
X-Gm-Message-State: AOAM533+k86T3fYFm5yKvJbqTn/wtYs7CgmSlIZZO+X2CrM264y2lazE
        IrJsL0XxjwZrGpz/5FM1Irv4Ya8I5b5gHHitKwI4Nl+lrdzBRqz6Iz6FDh1iFdYb/D/00QspgpZ
        shgJ1EIzlQno2
X-Received: by 2002:ae9:e90d:0:b0:6a3:28eb:1a4f with SMTP id x13-20020ae9e90d000000b006a328eb1a4fmr25047866qkf.21.1653575009378;
        Thu, 26 May 2022 07:23:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnsTslbqm3Ty98MkhbvTDM22jLrcctXdBNbGWftZfctg4y2SKQBw+AQi/5d92FEvX7YhHSHQ==
X-Received: by 2002:ae9:e90d:0:b0:6a3:28eb:1a4f with SMTP id x13-20020ae9e90d000000b006a328eb1a4fmr25047843qkf.21.1653575009105;
        Thu, 26 May 2022 07:23:29 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id j19-20020ac85f93000000b002f3bbad9e37sm1031494qta.91.2022.05.26.07.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 07:23:28 -0700 (PDT)
Date:   Thu, 26 May 2022 16:23:18 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, martinh@xilinx.com, martinpo@xilinx.com,
        lvivier@redhat.com, pabloc@xilinx.com,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>, lulu@redhat.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, Piotr.Uminski@intel.com,
        Si-Wei Liu <si-wei.liu@oracle.com>, ecree.xilinx@gmail.com,
        gautam.dawar@amd.com, habetsm.xilinx@gmail.com,
        tanuj.kamde@amd.com, hanand@xilinx.com, dinang@xilinx.com,
        Longpeng <longpeng2@huawei.com>
Subject: Re: [PATCH v4 1/4] vdpa: Add stop operation
Message-ID: <20220526142318.mi2kfywbpvuky4lw@sgarzare-redhat>
References: <20220526124338.36247-1-eperezma@redhat.com>
 <20220526124338.36247-2-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220526124338.36247-2-eperezma@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 02:43:35PM +0200, Eugenio Pérez wrote:
>This operation is optional: It it's not implemented, backend feature bit
>will not be exposed.
>
>Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>---
> include/linux/vdpa.h | 6 ++++++
> 1 file changed, 6 insertions(+)
>
>diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>index 15af802d41c4..ddfebc4e1e01 100644
>--- a/include/linux/vdpa.h
>+++ b/include/linux/vdpa.h
>@@ -215,6 +215,11 @@ struct vdpa_map_file {
>  * @reset:			Reset device
>  *				@vdev: vdpa device
>  *				Returns integer: success (0) or error (< 0)
>+ * @stop:			Stop or resume the device (optional, but it must
>+ *				be implemented if require device stop)
>+ *				@vdev: vdpa device
>+ *				@stop: stop (true), not stop (false)

Sorry for just seeing this now, but if you have to send a v5, maybe we 
could use "resume" here instead of "not stop".

Thanks,
Stefano

>+ *				Returns integer: success (0) or error (< 0)
>  * @get_config_size:		Get the size of the configuration space includes
>  *				fields that are conditional on feature bits.
>  *				@vdev: vdpa device
>@@ -316,6 +321,7 @@ struct vdpa_config_ops {
> 	u8 (*get_status)(struct vdpa_device *vdev);
> 	void (*set_status)(struct vdpa_device *vdev, u8 status);
> 	int (*reset)(struct vdpa_device *vdev);
>+	int (*stop)(struct vdpa_device *vdev, bool stop);
> 	size_t (*get_config_size)(struct vdpa_device *vdev);
> 	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
> 			   void *buf, unsigned int len);
>-- 
>2.31.1
>

