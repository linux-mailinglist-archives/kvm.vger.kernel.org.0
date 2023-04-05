Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFE26D7BDE
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 13:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237675AbjDELru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 07:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237514AbjDELrs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 07:47:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0341A40C4
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 04:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680695214;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uDrWMAyxvXy+bl3Pxr9kc6xlTFSjm+8B+3mxBz/Z2lU=;
        b=BD/DMwCVzULtz5N1JeGpS+7FggD9E+Qzwo6DCNSnc3xSTmrL0RlAtL5ujOdZW0kBzFv2sY
        haQ45b8RUG8Fu/kyzQ/Q5Sh9Pr7ZXGWHw/wmp7ATnCS1RzYpNS2QMfmHgAl1Jel8c9G6pE
        iJPk+Xyjy4EvlMCPaeaepxtbjW+QLX4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-DUU-usZdPia6IsQiLWMEpQ-1; Wed, 05 Apr 2023 07:46:53 -0400
X-MC-Unique: DUU-usZdPia6IsQiLWMEpQ-1
Received: by mail-qk1-f197.google.com with SMTP id t23-20020a374617000000b0074a4dba4b5aso3448377qka.16
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 04:46:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680695213;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uDrWMAyxvXy+bl3Pxr9kc6xlTFSjm+8B+3mxBz/Z2lU=;
        b=iIwqmfBsa36lVjcH6GSMOyjr4WfAIkg6IuqGk2TklJGz0giHXKfO6kfAobNuwCJ0HU
         IrNfUhIv6+3Zl8qZaqdbLwp7E+ryYlez5WNleSxtDsxZuXcOoKhX3/Mqirkj5ZFTXYO1
         84yltNvcEEqLaYuzmZCBDtrCewAUDw74K5Svwv0xOAMvaHQT84r+XSfnHf7CuZU8o3b8
         HNqMNg32HVdi/j3YYfzOahxYw7FuiggTF0gOa85pqcG7Mi2cXuDruV0lFEqrxoxLx417
         FvGbWmJhZlyd33iJo5i9x4VVmhnIP/ogDFaI+iVpppXmGZzXpMOOC5B8xu0jPy6c3L/Y
         sxyg==
X-Gm-Message-State: AAQBX9f+ljLNPhM2Tz92lbssP1TahVPzcn+eu3tYGsoLRnXUksWv3r16
        ZkP6LuxEbGiqETJeMingK/PTjvQFIjY91bfbzBlQR/wvRA+BMhGnYHZAsXA/DTloqoimGw+Vlkf
        pDOow2b7mz03b
X-Received: by 2002:a05:622a:1309:b0:3e6:3ed2:3a91 with SMTP id v9-20020a05622a130900b003e63ed23a91mr3790622qtk.32.1680695212514;
        Wed, 05 Apr 2023 04:46:52 -0700 (PDT)
X-Google-Smtp-Source: AKy350bfNGaC4yZyoW2hoZTEeT/b+1aIRezZ/X2Gn+pULgPtxtF6FxAek4ahkkKm+7tynn0L/af5KQ==
X-Received: by 2002:a05:622a:1309:b0:3e6:3ed2:3a91 with SMTP id v9-20020a05622a130900b003e63ed23a91mr3790588qtk.32.1680695212273;
        Wed, 05 Apr 2023 04:46:52 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 203-20020a3708d4000000b0074a3c282c7dsm2654941qki.97.2023.04.05.04.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 04:46:51 -0700 (PDT)
Message-ID: <567d99c0-4448-f2f4-1d7b-7d811a3d7c8c@redhat.com>
Date:   Wed, 5 Apr 2023 13:46:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 11/12] iommufd: Define IOMMUFD_INVALID_ID in uapi
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-12-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230401144429.88673-12-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi

On 4/1/23 16:44, Yi Liu wrote:
> as there are IOMMUFD users that want to know check if an ID generated
s/want to know check/ need to check
which type of ID?
> by IOMMUFD is valid or not. e.g. vfio-pci optionaly returns invalid
optionally
> dev_id to user in the VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl. User
> needs to check if the ID is valid or not.
so dev id ...
>
> IOMMUFD_INVALID_ID is defined as 0 since the IDs generated by IOMMUFD
> starts from 0.
from 1, same as below
>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  include/uapi/linux/iommufd.h | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 98ebba80cfa1..aeae73a93833 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -9,6 +9,9 @@
>  
>  #define IOMMUFD_TYPE (';')
>  
> +/* IDs allocated by IOMMUFD starts from 0 */
ditto
> +#define IOMMUFD_INVALID_ID 0
> +
>  /**
>   * DOC: General ioctl format
>   *
Eric

