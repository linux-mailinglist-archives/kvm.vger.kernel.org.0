Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675D252039B
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 19:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239731AbiEIRdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 13:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239727AbiEIRdN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 13:33:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4BF72802C3
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 10:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652117357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gPwKGPBdX9CEZclk0bCUvrwQP6RpEVoDbCEwgTdSfhs=;
        b=M7ABmPa/pGAUhB5YHvXuwyN0QRwB2/SfNasW3bdZ91dB1eUusM+GQ5dTJrlHhWWQMXhVGT
        +Szs7B19z6hU18BYXdw8bUSkcLXwg7J6IHrNPHG29H8y6CRLWKkjVlde4kGdsuTGByKNru
        XbIwZ2HZViy652aZy9sdYX6aIwHXmjk=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-I9Du2_GbN6ew6cxhRpK1iw-1; Mon, 09 May 2022 13:29:16 -0400
X-MC-Unique: I9Du2_GbN6ew6cxhRpK1iw-1
Received: by mail-io1-f69.google.com with SMTP id m205-20020a6b3fd6000000b006586ca958d2so10377152ioa.22
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 10:29:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gPwKGPBdX9CEZclk0bCUvrwQP6RpEVoDbCEwgTdSfhs=;
        b=jbFHtGBzyrL6BY/rIE1UJcoIcPrNXaXDa11wUyZrx27q3xBnOMSI03i9F4npEmnNNU
         I60ElM9aVvLpwTDm7/O3FhYZGv+2SsZnUOVBD3aoSXms7ZbwmIJw9DTx7GTthS6GjAz7
         NewSMM77noCOw/YmlqT3IKgk0zIPRDYU7IG2mLvCqE6D97fgxSC3WF0z6f5Xw12dpkQS
         uuT+IDXZ34Cr+lW2gERBN4mjz2FrDY5HP09FELXFOktrWZSj3B7318ghoFx4cmO60RVq
         HvNaZ8Ut6EhkNT0El6Js/Eyyf7ZeycTXior6OugHPEtXPVglYiCwOcwe580HZv/Q1+KQ
         98uQ==
X-Gm-Message-State: AOAM5334gZc8uG1PN4uc5Gm0R/7cBTsn4zcDvlZ0uTHuW9A/8GA/j/oy
        v3Y3iTxMB55b3V6pYiv/aN950IgzSSHQAOfJg/1op361AbntLuXn7CponBiYB5LztA5Hjq1t1W1
        /rPNdO+PHIiUq
X-Received: by 2002:a05:6638:1414:b0:32b:c219:7a26 with SMTP id k20-20020a056638141400b0032bc2197a26mr7815184jad.45.1652117355820;
        Mon, 09 May 2022 10:29:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUcPQIG0IG/p16GfEZoUzA0+EVdGkhOpnO8yzBiFDPaYWV/9yvnmTCSGlW5JLAP1Kyeu8FRw==
X-Received: by 2002:a05:6638:1414:b0:32b:c219:7a26 with SMTP id k20-20020a056638141400b0032bc2197a26mr7815163jad.45.1652117355572;
        Mon, 09 May 2022 10:29:15 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id t12-20020a02c48c000000b0032b3a781780sm3776586jam.68.2022.05.09.10.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 10:29:15 -0700 (PDT)
Date:   Mon, 9 May 2022 11:29:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH V1 mlx5-next 4/4] vfio/mlx5: Run the SAVE state command
 in an async mode
Message-ID: <20220509112904.17e9b7d0.alex.williamson@redhat.com>
In-Reply-To: <20220508131053.241347-5-yishaih@nvidia.com>
References: <20220508131053.241347-1-yishaih@nvidia.com>
        <20220508131053.241347-5-yishaih@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 8 May 2022 16:10:53 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:
> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
> index 2a20b7435393..d053d314b745 100644
> --- a/drivers/vfio/pci/mlx5/cmd.h
> +++ b/drivers/vfio/pci/mlx5/cmd.h
> @@ -10,10 +10,20 @@
>  #include <linux/vfio_pci_core.h>
>  #include <linux/mlx5/driver.h>
>  
> +struct mlx5vf_async_data {
> +	struct mlx5_async_work cb_work;
> +	struct work_struct work;
> +	int status;
> +	u32 pdn;
> +	u32 mkey;
> +	void *out;
> +};
> +
>  struct mlx5_vf_migration_file {
>  	struct file *filp;
>  	struct mutex lock;
>  	bool disabled;
> +	u8 is_err:1;

Convert @disabled to bit field as well to pack these?

...
> @@ -558,6 +592,13 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  		return -ENOMEM;
>  	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
>  	mlx5vf_cmd_set_migratable(mvdev);
> +	if (mvdev->migrate_cap) {
> +		mvdev->cb_wq = alloc_ordered_workqueue("mlx5vf_wq", 0);
> +		if (!mvdev->cb_wq) {
> +			ret = -ENOMEM;
> +			goto out_free;
> +		}
> +	}

Should this be rolled into mlx5vf_cmd_set_migratable(), updating the
function to return -errno?

>  	ret = vfio_pci_core_register_device(&mvdev->core_device);
>  	if (ret)
>  		goto out_free;
> @@ -566,8 +607,11 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  	return 0;
>  
>  out_free:
> -	if (mvdev->migrate_cap)
> +	if (mvdev->migrate_cap) {
>  		mlx5vf_cmd_remove_migratable(mvdev);
> +		if (mvdev->cb_wq)
> +			destroy_workqueue(mvdev->cb_wq);
> +	}
>  	vfio_pci_core_uninit_device(&mvdev->core_device);
>  	kfree(mvdev);
>  	return ret;
> @@ -578,8 +622,10 @@ static void mlx5vf_pci_remove(struct pci_dev *pdev)
>  	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
>  
>  	vfio_pci_core_unregister_device(&mvdev->core_device);
> -	if (mvdev->migrate_cap)
> +	if (mvdev->migrate_cap) {
>  		mlx5vf_cmd_remove_migratable(mvdev);
> +		destroy_workqueue(mvdev->cb_wq);
> +	}
>  	vfio_pci_core_uninit_device(&mvdev->core_device);
>  	kfree(mvdev);
>  }

This looks like more evidence for expanding remove_migratable(),
rolling this in as well.  If this workqueue were setup in
set_migratable() we'd not need the special condition to test if cb_wq
is NULL while migrate_cap is set.  Thanks,

Alex

