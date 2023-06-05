Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF2772267A
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 14:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbjFEMzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 08:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbjFEMzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 08:55:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB4E10B
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 05:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685969669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cllYJg4KX1vPMf9LlRacmMLfsZ/aSYb5fS8F5Fzs6S0=;
        b=BI5Kdmq56EjgQ20pcrSUGAJqCeR838mK1+WHKQ5iDtt2yXoc01uUhS8D3/WjXdXFGuCuEO
        bW3D53dnzWPAW2NRIWComEUtro4806nsp0FgZxkbZfXR2I3QcaLf1JKtsVk6VFV2puijPi
        YhVp0cFTeGFbICLZRr6WmUEWVl9S6AE=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-csAanAWLNwKgVFkZFe2SiQ-1; Mon, 05 Jun 2023 08:54:28 -0400
X-MC-Unique: csAanAWLNwKgVFkZFe2SiQ-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-626070979faso33904886d6.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 05:54:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685969668; x=1688561668;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cllYJg4KX1vPMf9LlRacmMLfsZ/aSYb5fS8F5Fzs6S0=;
        b=VZ4n5kP7O8CtT3U0QZHXGmdig2Xhsvc+Y0jxfsZWiGkKcgWJzVqQf1Si018iMESz9X
         zbOEc+dPH5vz7XKiOh2iCD6N73DXBove0k3G9ZzY9TBeqCB+egsZFeg629I9sf7G5wIy
         dGcqTDKXI7Vcm13xtR+ugZvVGnXhXN8geMtiYUzBWBWow2N5bHkRhA0I8TKll4ylRCX3
         XMgIDou4cZVrbvLyPQadE25ytGKVplJup/SFRuOoLjAIFhvlNouPAemAgqkWnDiP1p4h
         qypZ9P35QPLcgrUF81I/BBbgng6jAS/h01X20PpWNaQW5GZWN6Q+z1iGyrumslh8H/3y
         z6RA==
X-Gm-Message-State: AC+VfDypMFp5AdvBShVxOvaXYxJvDo0OW5AGN5cE38mHRZBtBTYZpem9
        ErFSYnsneKYJoLhdUL/2O8CEW3sfSwIQC9kOut4pLjr/5c5iiwUBuiBesQ2o9DFrUB/M+65F6zw
        p39YuDPXhF9A5
X-Received: by 2002:a05:6214:2aa1:b0:5e9:48da:9938 with SMTP id js1-20020a0562142aa100b005e948da9938mr5534972qvb.11.1685969668258;
        Mon, 05 Jun 2023 05:54:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7evpJje0CVQr5WLMJUrUmM/oUkM2nmAHq9rmpMI832Wdb8hYuY0N9fs0ZUTOPXxOtGPcdxgA==
X-Received: by 2002:a05:6214:2aa1:b0:5e9:48da:9938 with SMTP id js1-20020a0562142aa100b005e948da9938mr5534960qvb.11.1685969667992;
        Mon, 05 Jun 2023 05:54:27 -0700 (PDT)
Received: from sgarzare-redhat ([5.77.94.106])
        by smtp.gmail.com with ESMTPSA id cj21-20020a05622a259500b003f364778b2bsm4715846qtb.4.2023.06.05.05.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 05:54:27 -0700 (PDT)
Date:   Mon, 5 Jun 2023 14:54:20 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
References: <20230605110644.151211-1-sgarzare@redhat.com>
 <20230605084104-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230605084104-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
>On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
>> vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
>> don't support packed virtqueue well yet, so let's filter the
>> VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
>>
>> This way, even if the device supports it, we don't risk it being
>> negotiated, then the VMM is unable to set the vring state properly.
>>
>> Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>
>> Notes:
>>     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
>>     better PACKED support" series [1] and backported in stable branches.
>>
>>     We can revert it when we are sure that everything is working with
>>     packed virtqueues.
>>
>>     Thanks,
>>     Stefano
>>
>>     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
>
>I'm a bit lost here. So why am I merging "better PACKED support" then?

To really support packed virtqueue with vhost-vdpa, at that point we 
would also have to revert this patch.

I wasn't sure if you wanted to queue the series for this merge window.
In that case do you think it is better to send this patch only for 
stable branches?

>Does this patch make them a NOP?

Yep, after applying the "better PACKED support" series and being sure 
that the IOCTLs of vhost-vdpa support packed virtqueue, we should revert 
this patch.

Let me know if you prefer a different approach.

I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel 
interprets them the right way, when it does not.

Thanks,
Stefano

>
>>  drivers/vhost/vdpa.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index 8c1aefc865f0..ac2152135b23 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -397,6 +397,12 @@ static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
>>
>>  	features = ops->get_device_features(vdpa);
>>
>> +	/*
>> +	 * IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE) don't support
>> +	 * packed virtqueue well yet, so let's filter the feature for now.
>> +	 */
>> +	features &= ~BIT_ULL(VIRTIO_F_RING_PACKED);
>> +
>>  	if (copy_to_user(featurep, &features, sizeof(features)))
>>  		return -EFAULT;
>>
>>
>> base-commit: 9561de3a55bed6bdd44a12820ba81ec416e705a7
>> --
>> 2.40.1
>

