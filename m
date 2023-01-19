Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B15F673430
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 10:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjASJOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 04:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjASJNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 04:13:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BC2DD
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 01:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674119559;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iGZyVeBXaynrq9IzBOtexZZTKeX5k8rgJuIO4eYbJxY=;
        b=iUf9DTtUaxu2hRXIVQQIbLlwcNwVne2Z4Mjz1EwU2RqkJR3gkEkzfvFYtWg15Kim1yz4YO
        o0AdZcoIQGZxdaYg67hcA5E/pLXM8ZdSnOtB9qn9oNbHVq+XPFJDuUgAJWrypuEJmQsTe+
        wmEAFF9uV45veDMxD8OFL0WpS16d1ds=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-246-cnpdCgnaM1uxkHO3hCFODw-1; Thu, 19 Jan 2023 04:12:38 -0500
X-MC-Unique: cnpdCgnaM1uxkHO3hCFODw-1
Received: by mail-qt1-f200.google.com with SMTP id bs22-20020ac86f16000000b003b686e0ef0bso636625qtb.19
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 01:12:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iGZyVeBXaynrq9IzBOtexZZTKeX5k8rgJuIO4eYbJxY=;
        b=IpoyFxLt5o6UhVpjdlYWFkRxfLU9Sla7xOJj3SOW2ZvZxPB9IYWWxCxO4nmNCCL4j4
         v/PAfzfDQQJDP0qhIxqR1Q2+XF7gH4SdhovAUb8c0LqBu2YWTZ8kAPtRkkbC1zmadLbv
         uYUbthftYmd8QKpJdUkAIeKsMpATdq/mrjmC8AVs/Sea1T2hVROMzaAaDc8OXevPkweo
         rhE3my4GiYZftKM6Y9q2A/abxE8symXVY/dVnhl0XEFZY3pl/K6c7BJgJa3wFriuusdY
         jT1jYy4T3eTJFuPWetlwqOXI3ecihofQ40Ap7rYfez4byNMFUgWbKcVWp+Xjr2agL+7s
         JKUg==
X-Gm-Message-State: AFqh2kor1Ij3YPBH09UVvBrtzZyJ+bcePXyAhc+xBsMBVQEGFHaoJ/N7
        4SBV119zJeiGlfn/vPJEKXXrtfJVv39sJMu9xGnvRbr5Lu4oTBKg8IzI6OLBXA1mal8bcelFF/N
        aD+KQ3V5/d+jp
X-Received: by 2002:a05:622a:6008:b0:3b6:3a8f:d743 with SMTP id he8-20020a05622a600800b003b63a8fd743mr13613817qtb.66.1674119557573;
        Thu, 19 Jan 2023 01:12:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXstsOYp0qFsbe+W7NbHvTuAoE+eO3fDDRxuwSjb4qDXGBSrnOqv/pcjKiK8wAJAe2c0ey7wOA==
X-Received: by 2002:a05:622a:6008:b0:3b6:3a8f:d743 with SMTP id he8-20020a05622a600800b003b63a8fd743mr13613796qtb.66.1674119557321;
        Thu, 19 Jan 2023 01:12:37 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id bz25-20020a05622a1e9900b003a591194221sm3414032qtb.7.2023.01.19.01.12.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 01:12:35 -0800 (PST)
Message-ID: <184d793d-8bef-c8e5-40fe-14491533f63b@redhat.com>
Date:   Thu, 19 Jan 2023 10:12:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-6-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230117134942.101112-6-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 1/17/23 14:49, Yi Liu wrote:
> This is to avoid a circular refcount problem between the kvm struct and
> the device file. KVM modules holds device/group file reference when the
> device/group is added and releases it per removal or the last kvm reference
> is released. This reference model is ok for the group since there is no
> kvm reference in the group paths.
>
> But it is a problem for device file since the vfio devices may get kvm
> reference in the device open path and put it in the device file release.
> e.g. Intel kvmgt. This would result in a circular issue since the kvm
> side won't put the device file reference if kvm reference is not 0, while
> the vfio device side needs to put kvm reference in the release callback.
>
> To solve this problem for device file, let vfio provide release() which
> would be called once kvm file is closed, it won't depend on the last kvm
> reference. Hence avoid circular refcount problem.
>
> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  virt/kvm/vfio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 0f54b9d308d7..525efe37ab6d 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -364,7 +364,7 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type);
>  static struct kvm_device_ops kvm_vfio_ops = {
>  	.name = "kvm-vfio",
>  	.create = kvm_vfio_create,
> -	.destroy = kvm_vfio_destroy,
Is it safe to simply remove the destroy cb as it is called from
kvm_destroy_vm/kvm_destroy_devices?

Thanks

Eric
> +	.release = kvm_vfio_destroy,
>  	.set_attr = kvm_vfio_set_attr,
>  	.has_attr = kvm_vfio_has_attr,
>  };

