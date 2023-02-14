Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14938695904
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 07:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjBNGQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 01:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjBNGQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 01:16:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FA011646
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 22:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676355370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kdiiCGs8jiF79cxtwJhxCLI6Aw09fwGlhkOX3JAkxyg=;
        b=PP9M8j1P/JQ6YM06Q9FVEfwXRcBIbVx0DiKCQQvD7koEx/WykNbTPYoSlftnsVd7uKmO9U
        /WVv02oE/EyeYRGz3WYmLn/d9ckfr1hcRwglNzGU5LzH2qMw9p8xkaQyhsfgxGeQqO5K4V
        ohsGdtzbJY+GuouR2NuOM8q0Il3hxwg=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-616-bJvVPLNJOrWrG1lyUYN9bQ-1; Tue, 14 Feb 2023 01:16:08 -0500
X-MC-Unique: bJvVPLNJOrWrG1lyUYN9bQ-1
Received: by mail-pl1-f198.google.com with SMTP id t15-20020a170902e84f00b0019926b398e2so8684049plg.20
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 22:16:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kdiiCGs8jiF79cxtwJhxCLI6Aw09fwGlhkOX3JAkxyg=;
        b=YMCplAluDzoHytj1kDs0WKvlc+JsKQw4vNsHzT9t2gxQB/8tXgoSyDJdEhC7GNB3vY
         gPAYTIPBU4P5Dk4RtHQfxXL8CC3L0Jq552e/JqIUZJh44AYtVUozr6HU+NAeoiWE5IH2
         I8PbsggujcQ63x4eaufDkyWTsR5nS5X5s6+sUcSDmWxAQOHpyczJorZsDmoGvM2K6bsk
         foPiuh+3BiATfgN15zbLsF0DphOJEyOwSKwv0ulkkLdqMrbzCZfuNqY//XTs1xVv/ISV
         AUwqhd+9g3t9u72tbdrV0k4bXB/rRe/6RhX3sknRd49Ci2pH3HUaq2am78gZefDyC5W4
         pjpA==
X-Gm-Message-State: AO0yUKXiynGY7lIU9EZyMbWsiI5bzabzrG9pUBnOtMv8oLG1Slx0en/X
        cgLWZEYXN+P5WknoAvFt79cnVOS+enr7xTkCrFRTDWJ6jgM+OTcXMZaFt/KSgXVdpgJ30Vdg5q/
        VtgOmr9wHpoVR
X-Received: by 2002:a05:6a20:840a:b0:bf:bcfb:1fc6 with SMTP id c10-20020a056a20840a00b000bfbcfb1fc6mr1537575pzd.60.1676355367480;
        Mon, 13 Feb 2023 22:16:07 -0800 (PST)
X-Google-Smtp-Source: AK7set8hzWGwEqgdlvLWXsVMPGUwJMn4RgGjVNPla0dljDV116NxK8RoamZZUke8WlIgbRkDx9qv4Q==
X-Received: by 2002:a05:6a20:840a:b0:bf:bcfb:1fc6 with SMTP id c10-20020a056a20840a00b000bfbcfb1fc6mr1537555pzd.60.1676355367211;
        Mon, 13 Feb 2023 22:16:07 -0800 (PST)
Received: from [10.72.12.89] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v15-20020aa7808f000000b00593e84f2d08sm73842pff.52.2023.02.13.22.16.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 22:16:06 -0800 (PST)
Message-ID: <db99245c-606a-2f24-52fe-836a6972437f@redhat.com>
Date:   Tue, 14 Feb 2023 14:16:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] vhost-vdpa: cleanup memory maps when closing vdpa fds
To:     "Longpeng(Mike)" <longpeng2@huawei.com>, mst@redhat.com
Cc:     arei.gonglei@huawei.com, yechuan@huawei.com,
        huangzhichao@huawei.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230131145310.2069-1-longpeng2@huawei.com>
Content-Language: en-US
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20230131145310.2069-1-longpeng2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2023/1/31 22:53, Longpeng(Mike) 写道:
> From: Longpeng <longpeng2@huawei.com>
>
> We must cleanup all memory maps when closing the vdpa fds, otherwise
> some critical resources (e.g. memory, iommu map) will leaked if the
> userspace exits unexpectedly (e.g. kill -9).


Sounds like a bug of the kernel, should we fix there?

Thanks


>
> Signed-off-by: Longpeng <longpeng2@huawei.com>
> ---
>   drivers/vhost/vdpa.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index a527eeeac637..37477cffa5aa 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -823,6 +823,18 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v,
>   		vhost_vdpa_remove_as(v, asid);
>   }
>   
> +static void vhost_vdpa_clean_map(struct vhost_vdpa *v)
> +{
> +	struct vhost_vdpa_as *as;
> +	u32 asid;
> +
> +	for (asid = 0; asid < v->vdpa->nas; asid++) {
> +		as = asid_to_as(v, asid);
> +		if (as)
> +			vhost_vdpa_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
> +	}
> +}
> +
>   static int vhost_vdpa_va_map(struct vhost_vdpa *v,
>   			     struct vhost_iotlb *iotlb,
>   			     u64 iova, u64 size, u64 uaddr, u32 perm)
> @@ -1247,6 +1259,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
>   	vhost_vdpa_clean_irq(v);
>   	vhost_vdpa_reset(v);
>   	vhost_dev_stop(&v->vdev);
> +	vhost_vdpa_clean_map(v);
>   	vhost_vdpa_free_domain(v);
>   	vhost_vdpa_config_put(v);
>   	vhost_vdpa_cleanup(v);

