Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE6F58728F
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 22:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbiHAUzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 16:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234532AbiHAUzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 16:55:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 95B2A14D2F
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 13:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659387343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=If7o53X6NPJUO5QP9EKT7gVSaWaVmoWSrh7iKnn9p6w=;
        b=YpUTMiQTp1t/rRFotX1+njk4xA/3YrjtWelRd0gzFEXKnBuxhRvf9Empz7k1XlPtzhpIMh
        V5j5d7CWlSh5rZaNFKhFpefbuAixITmk0eqL3HaoswjhVL82jQiD4vAdQvvJTVsMIzHw4r
        6mk/jMSJpje1tfaW9jZeBjmOPXgEdyM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-ecyhzAMNOA2_d3lN1CmqwA-1; Mon, 01 Aug 2022 16:55:42 -0400
X-MC-Unique: ecyhzAMNOA2_d3lN1CmqwA-1
Received: by mail-il1-f199.google.com with SMTP id i8-20020a056e020d8800b002d931252904so7460798ilj.23
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 13:55:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=If7o53X6NPJUO5QP9EKT7gVSaWaVmoWSrh7iKnn9p6w=;
        b=ilv2TD6LDGR6YN1Cc6jxnHt9kwPrsBSyKX51wekHd2s25+30yDhRlqnriMhIcKu7lE
         5753yjzamWjHwXsm85++YMmxbPa8Gl7+s8xnhAySKUGrsMhHSP2Fo3ngnoAOuUCrNm0y
         KrXyw0Vql2vUd0v1RJ7OU6Onv4FXXBSi4OIycRRxRkKXs7sWlhlVY1b+e33eETgoUpw+
         guYOxrFHB8dHkhOh/Ei/Ym5mxdrsey0pKugjujRq6duN+2I6Zsh9wdsMgg6FpCDnSSHk
         ZWz5G73utCXdOU06G6EJngV6tx8VS6bhVXOw6NhErjXP7jVlaHcEclrMFgZpuSgy7li0
         9RLA==
X-Gm-Message-State: AJIora+UcvtDIQEUCy4IDNfwPUjD6+CmYCdmTmBb0d2VXE0kYRivG4HS
        FnVodVYJeP2BVJzpuAqgbIUqoXmGaLSoJz1RQvgSsLCh4cuewwNyHy83+4EumcZCPS6yzK01jq9
        PUeC4pTnnqFbI
X-Received: by 2002:a05:6638:1602:b0:341:3e1f:d862 with SMTP id x2-20020a056638160200b003413e1fd862mr7064959jas.24.1659387342024;
        Mon, 01 Aug 2022 13:55:42 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sjutKz5dBzIoacK7wfnyP8jIm+dI8xx7u0A1yEnZnR/R5aP1CIyq7RJKqoV8fdmri+4HklNw==
X-Received: by 2002:a05:6638:1602:b0:341:3e1f:d862 with SMTP id x2-20020a056638160200b003413e1fd862mr7064952jas.24.1659387341842;
        Mon, 01 Aug 2022 13:55:41 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x14-20020a92de0e000000b002dd0cf02f42sm5119805ilm.44.2022.08.01.13.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 13:55:41 -0700 (PDT)
Date:   Mon, 1 Aug 2022 14:55:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Bo Liu <liubo03@inspur.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio/pci: fix the wrong word
Message-ID: <20220801145540.5cb4460e.alex.williamson@redhat.com>
In-Reply-To: <20220801013918.2520-1-liubo03@inspur.com>
References: <20220801013918.2520-1-liubo03@inspur.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 31 Jul 2022 21:39:18 -0400
Bo Liu <liubo03@inspur.com> wrote:

> This patch fixes a wrong word in comment.
> 
> Signed-off-by: Bo Liu <liubo03@inspur.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 97e5ade6efb3..442d3ba4122b 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -222,7 +222,7 @@ static int vfio_default_config_write(struct vfio_pci_core_device *vdev, int pos,
>  		memcpy(vdev->vconfig + pos, &virt_val, count);
>  	}
>  
> -	/* Non-virtualzed and writable bits go to hardware */
> +	/* Non-virtualized and writable bits go to hardware */
>  	if (write & ~virt) {
>  		struct pci_dev *pdev = vdev->pdev;
>  		__le32 phys_val = 0;

Applied to vfio next branch for v5.20/v6.0.  Thanks,

Alex

