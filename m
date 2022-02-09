Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA73F4B02F3
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 03:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiBJCCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 21:02:04 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbiBJCAP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 21:00:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E812A2B6B0
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 17:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644457515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QqS6aRbHUDdzpsG8gLAbed/VgqomfvLKE7ZO5PCIOxw=;
        b=EAWUge6OpYCxHvMymJyzXL0u6KeNKQUU7UmOf3hbi6wNGumwmhGn5JElsE2ja4BUF7CKTk
        tWV90Y9Iz8kOCpJDBcOWk+GdTEN4/DxWQvUL0LMEPMqlwoZQT5MxIet6fgh4z1SXxc4awf
        wo4tIlJ5A3FTplwCKy4zT8zvpt8Bozs=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-3WEcrkCfMKCNZPjs56I6dQ-1; Wed, 09 Feb 2022 18:44:43 -0500
X-MC-Unique: 3WEcrkCfMKCNZPjs56I6dQ-1
Received: by mail-il1-f197.google.com with SMTP id a3-20020a92d103000000b002bdfc5108dfso2701943ilb.9
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 15:44:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QqS6aRbHUDdzpsG8gLAbed/VgqomfvLKE7ZO5PCIOxw=;
        b=DVcmGlsikx2IjO8P5CfUA6lrKkIJ5YZ0H0bOJTkiQ5Dv1wIZ+9Q+sSiQ5S7q3ojUnd
         ucUTU51uDy45LZoAkwt2TxyH+/hA7VO8AKMGHBSEbjKuIPRMmR0/8lJctN82NmRqRChk
         iSvMq6dqGURT2oYhzMnC1+lpED2CszqQJvi3AWFZqqDqHIqGMykYveGyabLRhDW3i2s2
         zx8xIlUUo5kgj6bBR7B972tEnyqrtX6wswzR/1zjB6tO6j9qgjMwL5yzlaA2qvq34hkb
         YojHy8cIHxOJqw279iXurskkx5n0Gu6ho2i5kAnC6QHKe3+qm+PG931Wiu+6ZvdKQ7gQ
         0hxg==
X-Gm-Message-State: AOAM533AeU2WNOjBdXUxdArbb3HjZDS8JI2YGkXd8FS2fX+xodZ9efdG
        UcU9zY1fVx51E2pw0AbnJX/m5y4GR2GYVWqbY9aFRQrbRApOrNEGrAQpFL+vV0clYhReL49sj6m
        +nvmuH6JQjdKI
X-Received: by 2002:a05:6602:2209:: with SMTP id n9mr2470394ion.106.1644450283125;
        Wed, 09 Feb 2022 15:44:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxT6HD2F4lnfPsmgFD3PhnkTPzmCmvBRL9NupZBHsvlbk18vuDpteUdQty0XS8Ul8opPEqcow==
X-Received: by 2002:a05:6602:2209:: with SMTP id n9mr2470381ion.106.1644450282952;
        Wed, 09 Feb 2022 15:44:42 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w19sm10870685iov.16.2022.02.09.15.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 15:44:42 -0800 (PST)
Date:   Wed, 9 Feb 2022 16:44:40 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <mgurtovoy@nvidia.com>, <yishaih@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: Re: [RFC v4 7/8] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220209164440.0d77284c.alex.williamson@redhat.com>
In-Reply-To: <20220208133425.1096-8-shameerali.kolothum.thodi@huawei.com>
References: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
        <20220208133425.1096-8-shameerali.kolothum.thodi@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Feb 2022 13:34:24 +0000
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> +
> +static struct hisi_acc_vf_migration_file *
> +hisi_acc_vf_stop_copy(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> +{
> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> +	struct device *dev = &hisi_acc_vdev->vf_dev->dev;
> +	struct hisi_acc_vf_migration_file *migf;
> +	int ret;
> +
> +	if (unlikely(qm_wait_dev_not_ready(vf_qm))) {
> +		dev_info(dev, "QM device not ready, no data to transfer\n");
> +		return 0;
> +	}

This return value looks suspicious and I think would cause a segfault
in the calling code:

+		migf = hisi_acc_vf_stop_copy(hisi_acc_vdev);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		hisi_acc_vdev->saving_migf = migf;
+		return migf->filp;

Thanks,
Alex

