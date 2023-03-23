Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E5B6C63D9
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 10:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjCWJkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 05:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbjCWJjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 05:39:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D016C1040F
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 02:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679564325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wv8z0Oa+BNXMxQvoR0WkvQh5FJ+53xDgUpA+wdsZMxA=;
        b=J/Jwhw6CiDqSm0hrbSCimBkst8dTClMGBzxT63TJLO+vAQaUzHL2yE14ULkHRMbIQK+ep1
        zeHaXEssyUQJoK3Un0K93YvkeskhMv9hpis9MVy6XATpaP0iDwdIqfz7qL6HVeOAzrJymE
        fIgch21vmnoCUVER4yrOFTfMRkVjsrE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-i_ZTrni7OVWbUZCiUYzVlw-1; Thu, 23 Mar 2023 05:38:44 -0400
X-MC-Unique: i_ZTrni7OVWbUZCiUYzVlw-1
Received: by mail-qt1-f199.google.com with SMTP id w13-20020ac857cd000000b003e37d3e6de2so5961521qta.16
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 02:38:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679564323;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wv8z0Oa+BNXMxQvoR0WkvQh5FJ+53xDgUpA+wdsZMxA=;
        b=HGkJCrsJur3DI+DpwXKhhE9EzB8Nxrf9BevNFg2G7Ebq0pdjg9etBWNRkJA6RpxWnp
         t099aUHQVOOp5vlGQMAOoF2Ik8dN9pJX7aRHe6IM1x4T3H1rJreWQ0IkHZqQolqBks+U
         Laojb4L+6cpE7ljwElIiVBZ/jfFWQJWl3bplhkYrMqLd1OScBQhAE6CQ5KPmTpHwTLMW
         Y+WzfskYS4I1yA6UIVbQuqjq45ArcjzgA8IvSoadNqxyG6kabTT1qSUBoKaJlLfvOuyx
         RftU/2wGZtLatrPyOZxCVAM9NoUaUSyh6KQiQnxCFZWB2fm3rCc+6XAAY7RkOwd1GmQ/
         ZmoQ==
X-Gm-Message-State: AO0yUKVMkt9ocSHPJFmYWnKdm7wtl4PsuGlq7zHfWv3qCthwcGTo6ehn
        iVnO4TilZ5ROZI9Kf99aG/E39prN7YrbPW0F/YglfhXXPjlz9gXF2jLkjZLPbUu6j9P/IEpZ5sm
        6gb/Xjj+z6eqlgnW6H6gl
X-Received: by 2002:a05:622a:284:b0:3bf:d238:6ca with SMTP id z4-20020a05622a028400b003bfd23806camr8824068qtw.68.1679564323360;
        Thu, 23 Mar 2023 02:38:43 -0700 (PDT)
X-Google-Smtp-Source: AK7set99g4T9mj3o49CpahBOOAtxidRMSqg1u94nbjZpIXaZjWImk48PhBoKMemZZJq1z4EVJUoSbQ==
X-Received: by 2002:a05:622a:284:b0:3bf:d238:6ca with SMTP id z4-20020a05622a028400b003bfd23806camr8824056qtw.68.1679564323068;
        Thu, 23 Mar 2023 02:38:43 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id b21-20020ac85415000000b003995f6513b9sm11310043qtq.95.2023.03.23.02.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 02:38:42 -0700 (PDT)
Date:   Thu, 23 Mar 2023 10:38:37 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/8] vhost-vdpa: use bind_mm/unbind_mm device callbacks
Message-ID: <20230323093837.xdv7wkhzizgnihcy@sgarzare-redhat>
References: <20230321154228.182769-1-sgarzare@redhat.com>
 <20230321154228.182769-3-sgarzare@redhat.com>
 <CACGkMEtq8PWL01WBL2Ve-Yr=ZO+su73tKuOh1EBLagkrLdiCaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEtq8PWL01WBL2Ve-Yr=ZO+su73tKuOh1EBLagkrLdiCaQ@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023 at 11:01:39AM +0800, Jason Wang wrote:
>On Tue, Mar 21, 2023 at 11:42 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
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
>>     v3:
>>     - added `case VHOST_SET_OWNER` in vhost_vdpa_unlocked_ioctl() [Jason]
>>     v2:
>>     - call the new unbind_mm callback during the release [Jason]
>>     - avoid to call bind_mm callback after the reset, since the device
>>       is not detaching it now during the reset
>>
>>  drivers/vhost/vdpa.c | 31 +++++++++++++++++++++++++++++++
>>  1 file changed, 31 insertions(+)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index 7be9d9d8f01c..20250c3418b2 100644
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
>> @@ -709,6 +731,14 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>>         case VHOST_VDPA_RESUME:
>>                 r = vhost_vdpa_resume(v);
>>                 break;
>> +       case VHOST_SET_OWNER:
>> +               r = vhost_dev_set_owner(d);
>
>Nit:
>
>I'd stick to the current way of passing the cmd, argp to
>vhost_dev_ioctl() and introduce a new switch after the
>vhost_dev_ioctl().
>
>In this way, we are immune to any possible changes of dealing with
>VHOST_SET_OWNER in vhost core.

Good point, I'll change in v4.

>
>Others look good.

Thanks,
Stefano

