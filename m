Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428BA6BC935
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 09:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjCPIcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 04:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjCPIch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 04:32:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD3364850
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 01:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678955490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X/1UEGyWZZrbvStEgLaSVShuWDRxe0yPRa+3kY6NxaI=;
        b=WcmxndoQGwzaqzudYbXB+LUZrch215qF3XBwwmDKy0G/npNkBHt0QkajE7ewAxHs4HCTRM
        mc8WqMbrim2ISjXLZ31Z+Zqb45Yo9ij6pzBjVTCle29VuT0uKiz2dA4fwkuau5k7rh+JYv
        JLb/QeOx/WUx09wCmfyWAs0EnGDb2uc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-S36vqkPhO3a68bGRU0-1-w-1; Thu, 16 Mar 2023 04:31:27 -0400
X-MC-Unique: S36vqkPhO3a68bGRU0-1-w-1
Received: by mail-wm1-f70.google.com with SMTP id j36-20020a05600c1c2400b003ed245a452fso439882wms.3
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 01:31:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678955486;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X/1UEGyWZZrbvStEgLaSVShuWDRxe0yPRa+3kY6NxaI=;
        b=myLa8OxS53/zWIa8ilpgDUBA2brJAUMympxc8ziD9vE+b33+qUre+0vWcFK7AzGdE+
         cYwhpWmyzQEjyjA5JWMrZ635Ld7NPQ7Yf2nbviIbLYE1AjxiGXVMLskkLDNQRr+ICn/0
         14U84nrcHhM0PhsAGbANwU7aKeaOUgJhmOW1WoX3/peoASqS9ARRiwxlTVLr0uVD+oqG
         0kk2qjIsiIZdxxH/05+2HWCg48cZDdGlmfzhYF6zXygkUkfxRQi1lWe42iIMvJ3lrzQb
         5uuOrdf0QSXYr9Z9eX0YPe2WHIDmo63u20fnJScX4EuMPW4BatGAqGByNxoCAg/TYpCM
         XKNw==
X-Gm-Message-State: AO0yUKU+tsh5UCm6fkodiWyYr/F4mXyJ3EUr98JCUmpBGclMa6jM3VyH
        nvQmXwXpRdTiHKyJfq9olevTZ+7CWsDRQ1ag6feAqNICbJffGFWYzvUI2sIXaO2c5HGC5+Itc4k
        KvDButlI/DGPJ
X-Received: by 2002:a5d:5955:0:b0:2cf:e29f:d7f5 with SMTP id e21-20020a5d5955000000b002cfe29fd7f5mr3576304wri.25.1678955486052;
        Thu, 16 Mar 2023 01:31:26 -0700 (PDT)
X-Google-Smtp-Source: AK7set8XgT/fkEa6oyHpuwgit2NX40Fpv+7C8AxfojZlS6SqwfkBRFQgzp3vx+Buq6H4mrLWafU74w==
X-Received: by 2002:a5d:5955:0:b0:2cf:e29f:d7f5 with SMTP id e21-20020a5d5955000000b002cfe29fd7f5mr3576292wri.25.1678955485799;
        Thu, 16 Mar 2023 01:31:25 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id c10-20020adffb0a000000b002d1bfe3269esm1518738wrr.59.2023.03.16.01.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 01:31:25 -0700 (PDT)
Date:   Thu, 16 Mar 2023 09:31:22 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/8] vhost-vdpa: use bind_mm/unbind_mm device callbacks
Message-ID: <20230316083122.hliiktgsymrfpozy@sgarzare-redhat>
References: <20230302113421.174582-1-sgarzare@redhat.com>
 <20230302113421.174582-3-sgarzare@redhat.com>
 <CACGkMEttgd82xOxV8WLdSFdfhRLZn68tSaV4APSDh8qXxf4OEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEttgd82xOxV8WLdSFdfhRLZn68tSaV4APSDh8qXxf4OEw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 14, 2023 at 11:48:33AM +0800, Jason Wang wrote:
>On Thu, Mar 2, 2023 at 7:34 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> When the user call VHOST_SET_OWNER ioctl and the vDPA device
>> has `use_va` set to true, let's call the bind_mm callback.
>> In this way we can bind the device to the user address space
>> and directly use the user VA.
>>
>> The unbind_mm callback is called during the release after
>> stopping the device.
>>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>
>> Notes:
>>     v2:
>>     - call the new unbind_mm callback during the release [Jason]
>>     - avoid to call bind_mm callback after the reset, since the device
>>       is not detaching it now during the reset
>>
>>  drivers/vhost/vdpa.c | 30 ++++++++++++++++++++++++++++++
>>  1 file changed, 30 insertions(+)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index dc12dbd5b43b..1ab89fccd825 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -219,6 +219,28 @@ static int vhost_vdpa_reset(struct vhost_vdpa *v)
>>         return vdpa_reset(vdpa);
>>  }
>>
>> +static long vhost_vdpa_bind_mm(struct vhost_vdpa *v)
>> +{
>> +       struct vdpa_device *vdpa = v->vdpa;
>> +       const struct vdpa_config_ops *ops = vdpa->config;
>> +
>> +       if (!vdpa->use_va || !ops->bind_mm)
>> +               return 0;
>> +
>> +       return ops->bind_mm(vdpa, v->vdev.mm);
>> +}
>> +
>> +static void vhost_vdpa_unbind_mm(struct vhost_vdpa *v)
>> +{
>> +       struct vdpa_device *vdpa = v->vdpa;
>> +       const struct vdpa_config_ops *ops = vdpa->config;
>> +
>> +       if (!vdpa->use_va || !ops->unbind_mm)
>> +               return;
>> +
>> +       ops->unbind_mm(vdpa);
>> +}
>> +
>>  static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
>>  {
>>         struct vdpa_device *vdpa = v->vdpa;
>> @@ -711,6 +733,13 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>>                 break;
>>         default:
>>                 r = vhost_dev_ioctl(&v->vdev, cmd, argp);
>> +               if (!r && cmd == VHOST_SET_OWNER) {
>> +                       r = vhost_vdpa_bind_mm(v);
>> +                       if (r) {
>> +                               vhost_dev_reset_owner(&v->vdev, NULL);
>> +                               break;
>> +                       }
>> +               }
>
>Nit: is it better to have a new condition/switch branch instead of
>putting them under default? (as what vring_ioctl did).

Yep, I agree!

I'll change it.

Thanks,
Stefano

