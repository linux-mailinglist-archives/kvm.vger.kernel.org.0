Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB6352B473
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 10:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbiERINJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 04:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbiERINH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 04:13:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FB585909C
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 01:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652861585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dfHp/HP/b9AoGe09y0NtWxK8atBPRWLQkNOyfDM+It8=;
        b=SvmSC3oyW+h0G7bugaTFXlTWaIMxXhgskARGpFcjWS+wqVw5wMK9OaYuMvoGSocX89QhgA
        Ee/wciGyo8RBx4u2p75WFc0+eAq3amHTi/A1h3DhWJ2VqvDF9549xl9zrLipWMIX/FwGmV
        KxH6Bft27MZeRwpgMGhH5nXUdu5X+zs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-5TUgyHZuPemZchg7siImXQ-1; Wed, 18 May 2022 04:13:04 -0400
X-MC-Unique: 5TUgyHZuPemZchg7siImXQ-1
Received: by mail-wr1-f71.google.com with SMTP id bv12-20020a0560001f0c00b0020e359b3852so324612wrb.14
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 01:13:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dfHp/HP/b9AoGe09y0NtWxK8atBPRWLQkNOyfDM+It8=;
        b=X1npS0PpgZrPIGfr3xRsG/bk6ULLfvf2fovcpr9HYXgQ0QURVWi/uu6mYROp7HvGDW
         QiYICcjul81e3ZHQ8IURjkH+WLBpFCjXd2pXk/NXpj4X5j+kVbujjpSCbc01uZXBshXZ
         jNVxhWweXM7GIw4WK+dbBJ/Bx3U4bs1gF4xJ66nbTiNYpcj0DpKN1lCk5O8movc7vuD/
         vaoANDn8Kl7glin6cb1INw/PYrGv3C0VV72iwl68mdIhA/fNr688Ej5HkluzK6uEuuOe
         WuCUULUvNJSBXpcjpCNfiNUbsY6T4RPd3nsOmy52SLXegzUdRcTFBMwHTzTeWhRN2ui0
         S6Aw==
X-Gm-Message-State: AOAM533MgRsu9M1/JuhplKrzuRJGq0e6ofn1P3OL5qhtUh9innVB04j7
        gOfErgzsR2cTM+yD9LMLo71QEHf8MFsaeEGyVHD6uF31B+xA6SqcZbYv9lh+LNU7tD2mCnnxmQd
        hbi2c3NZeCrYB
X-Received: by 2002:a05:600c:3512:b0:394:7c3b:53c0 with SMTP id h18-20020a05600c351200b003947c3b53c0mr24455448wmq.170.1652861582939;
        Wed, 18 May 2022 01:13:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmNMudMu1d4TT8vFzZFh+w0PrvObISRbOyWdvBWos1oyuudQE5xGQFE4p1tyR3Ib1wLmx3uw==
X-Received: by 2002:a05:600c:3512:b0:394:7c3b:53c0 with SMTP id h18-20020a05600c351200b003947c3b53c0mr24455422wmq.170.1652861582709;
        Wed, 18 May 2022 01:13:02 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id e4-20020adf9bc4000000b0020d0c48d135sm1293889wrc.15.2022.05.18.01.13.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 01:13:02 -0700 (PDT)
Message-ID: <1dda12f3-2552-54d4-0946-73c168ff7d26@redhat.com>
Date:   Wed, 18 May 2022 10:13:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v5 4/9] s390x/pci: add routine to get host function handle
 from CLP info
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-5-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220404181726.60291-5-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/04/2022 20.17, Matthew Rosato wrote:
> In order to interface with the underlying host zPCI device, we need
> to know it's function handle.  Add a routine to grab this from the
> vfio CLP capabilities chain.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-pci-vfio.c         | 83 ++++++++++++++++++++++++++------
>   include/hw/s390x/s390-pci-vfio.h |  6 +++
>   2 files changed, 73 insertions(+), 16 deletions(-)
[...]
> diff --git a/include/hw/s390x/s390-pci-vfio.h b/include/hw/s390x/s390-pci-vfio.h
> index ff708aef50..0c2e4b5175 100644
> --- a/include/hw/s390x/s390-pci-vfio.h
> +++ b/include/hw/s390x/s390-pci-vfio.h
> @@ -20,6 +20,7 @@ bool s390_pci_update_dma_avail(int fd, unsigned int *avail);
>   S390PCIDMACount *s390_pci_start_dma_count(S390pciState *s,
>                                             S390PCIBusDevice *pbdev);
>   void s390_pci_end_dma_count(S390pciState *s, S390PCIDMACount *cnt);
> +bool s390_pci_get_host_fh(S390PCIBusDevice *pbdev, uint32_t *fh);
>   void s390_pci_get_clp_info(S390PCIBusDevice *pbdev);
>   #else
>   static inline bool s390_pci_update_dma_avail(int fd, unsigned int *avail)
> @@ -33,6 +34,11 @@ static inline S390PCIDMACount *s390_pci_start_dma_count(S390pciState *s,
>   }
>   static inline void s390_pci_end_dma_count(S390pciState *s,
>                                             S390PCIDMACount *cnt) { }
> +static inline bool s390_pci_get_host_fh(S390PCIBusDevice *pbdev,
> +                                        unsigned int *fh)

This prototype does not match the one before the else - please replace 
"unsigned int" with "uint32_t".

  Thomas

> +{
> +    return false;
> +}
>   static inline void s390_pci_get_clp_info(S390PCIBusDevice *pbdev) { }
>   #endif
>   

