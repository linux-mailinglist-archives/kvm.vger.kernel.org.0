Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9B171814E
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 15:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjEaNVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 09:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236015AbjEaNVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 09:21:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D51598
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 06:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685539246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qZVXm+IOCgmTsEqI3VXAOS0mHF1t0Jqm4WlZG/uBAgA=;
        b=jVtxelwL1lcBmhyLOFrhfHFZ7EZ8O7z617p1J0IGkkf0d9jfq5bwgBhabL1QU+no6TlzGG
        3sdX02iZJu7ceh28g/kKOi877gD7O0liYDxBqduT1qLcgZ9wplDK4rYXDw0ocsp0s0wWh9
        jFSWKGl9zNSeW4w9eye/rLDBqITO+LI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-I2_oUBU6O267Bjp0c-yAMQ-1; Wed, 31 May 2023 09:20:45 -0400
X-MC-Unique: I2_oUBU6O267Bjp0c-yAMQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-626253ba086so22848636d6.2
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 06:20:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685539244; x=1688131244;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qZVXm+IOCgmTsEqI3VXAOS0mHF1t0Jqm4WlZG/uBAgA=;
        b=fOFm4nWLtjBDOP0ZOVHrHi2SNbzK7xSfhqxGFQg8+Muk5Lf/z/PUxDjSTgHoRISBJK
         j4HgBwhV/j/HYaShrcoECEw9BCsLEfcXlldfL+KG9C05MCcIUpq4/pM4P0pAhJSN/6wX
         VNifhrCuhKXsaovX9lOS+1cp2RrMkI8+/LiQWqhQjRGcHIwPj/2Bj0X1GUleo8Q10Qk2
         tjuQdB/e3tLOd28pTgE7cDK7AOjbv2dyf2OSvQPW3tSNCe8Jr4Q5ywFfnAdBYbQ3ges2
         zvyD3gGz/wXJ3oogKXCSpZCHynkwwH3k2x/sjkjtTbgUzxhOT3tZnIGAftSCVPcF3kaF
         EGaQ==
X-Gm-Message-State: AC+VfDw4oOe6Ay0BfWS0Sb3CvMGteCMYijXT/a6+cq+PSzLuAEL8CwwZ
        hmI0dRbqvvRT3pRQwY7XR6Bd5ll3Msjh+cUUCtKKd8R2Fm36CMmfswDtPQxZTCmF5wAJdsWRoUb
        MZMqJuVKvWxfa
X-Received: by 2002:a05:6214:e4b:b0:5ea:d52:7042 with SMTP id o11-20020a0562140e4b00b005ea0d527042mr5919380qvc.31.1685539244768;
        Wed, 31 May 2023 06:20:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7fkoMnFe/NS9uPFPjiSVB+gDPw+HMnw0nwLd0bciAqe6TJk7vFLomsCyZ6OqdJGwlkfWRidg==
X-Received: by 2002:a05:6214:e4b:b0:5ea:d52:7042 with SMTP id o11-20020a0562140e4b00b005ea0d527042mr5919359qvc.31.1685539244549;
        Wed, 31 May 2023 06:20:44 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:eb4a:c9d8:c8bb:c0b0? ([2a01:e0a:280:24f0:eb4a:c9d8:c8bb:c0b0])
        by smtp.gmail.com with ESMTPSA id k18-20020a0cd692000000b006238ac6c3f3sm5787394qvi.33.2023.05.31.06.20.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 06:20:44 -0700 (PDT)
Message-ID: <d4ad9b34-60d3-3ffb-ee88-8bcb3d0ec647@redhat.com>
Date:   Wed, 31 May 2023 15:20:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/3] vfio: ap: realize the VFIO_DEVICE_GET_IRQ_INFO ioctl
Content-Language: en-US
To:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        borntraeger@linux.ibm.com
References: <20230530223538.279198-1-akrowiak@linux.ibm.com>
 <20230530223538.279198-2-akrowiak@linux.ibm.com>
 <ee46966a-920a-37f6-9554-b2b10565cd58@redhat.com>
 <64d96082-8c05-0fb8-dfdd-96ad8efa6cd8@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clegoate@redhat.com>
In-Reply-To: <64d96082-8c05-0fb8-dfdd-96ad8efa6cd8@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/23 15:05, Anthony Krowiak wrote:
> 
> 
> On 5/31/23 8:54 AM, Cédric Le Goater wrote:
>> Reviewed-by: Cédric Le Goater <clg@redhat.com>
> 
> Thank you for the review.
> 

I also ran a few tests with the QEMU part on guests with passthrough
crypto devices. This is probably a v6.5 candidate.

C.

