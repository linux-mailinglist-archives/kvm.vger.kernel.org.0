Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E66F5F5144
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 11:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiJEJDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 05:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiJEJC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 05:02:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5015D0E9
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 02:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664960577;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OCMPBA9e7724YAMVwcvTHnuhr6IQT7g+RM8asMNTfjw=;
        b=dq86oDOUQ/tYnvXHLxIHjg2vJiqvblSRfdBzFkG6AnlqQP7W9624VFih8RyTeWErItOpTQ
        1wpaggQafQDTKFKjzYZ+IS0Lh8jK6tg/NSy/rhEVVmk3r1Dueb3l2jL5MMorlSr50vY64E
        TH6mXHnlsk+2cm1FANH0JMsAmnhTv2M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-134-otzdRWeiPVCfoFgHCAysfg-1; Wed, 05 Oct 2022 05:02:56 -0400
X-MC-Unique: otzdRWeiPVCfoFgHCAysfg-1
Received: by mail-wm1-f71.google.com with SMTP id d5-20020a05600c34c500b003b4fb42ccdeso669146wmq.8
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 02:02:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=OCMPBA9e7724YAMVwcvTHnuhr6IQT7g+RM8asMNTfjw=;
        b=rTWmLp0W5J22fo4YrjLjVGPRVtDYfYCa/XprS6VH5Mzpr1B0RcWrB6c74Vnx4j5cNJ
         tVsZ7ClpM9hdPAmI1iIDs6CY/Lw7BYOKKJQuqDcRNZ/hBoIJHXVnvkRRcEiqt1s0OVxr
         wQogNl9lv+6qyrE6XdSFt/zX4HtrkNZ7xJ6YNjZwCkflxst0aHVkeg7RU+D0wwMfJ0ig
         HobmWds/0lhkGeZk/YlOh9m09epZOatGQd1tM6GHEv0RVpOWCKEg2wiqdGUDdqTidI9c
         PW/Se8boiHdjqyNrRZYkNG5bXP4q1p0TRkruecGCCeSjydIGDBVUSArexn9A00yA8idf
         nUUg==
X-Gm-Message-State: ACrzQf3uQ+9oOJAPr//8En4QvfY8avKmkBOE39ldp3MhFAbSs74QBV4b
        g2SqpKmwPKCHeS+bFfYp1txgIN069C2SM8Z2BRRmtRqNajL4SXF2c4Iu9uMPRPwjc2dBfbcmod9
        JjS5cRCjdVt9a
X-Received: by 2002:a05:6000:1cf:b0:22e:3ef1:a268 with SMTP id t15-20020a05600001cf00b0022e3ef1a268mr8119249wrx.43.1664960573482;
        Wed, 05 Oct 2022 02:02:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Ggby1Sonvr6NPJtfZLZbisZXuVVxZNt2UEzDPGYV6Pb6Iw/EtoBbEkviExpPHtdT40Op5tA==
X-Received: by 2002:a05:6000:1cf:b0:22e:3ef1:a268 with SMTP id t15-20020a05600001cf00b0022e3ef1a268mr8119227wrx.43.1664960573186;
        Wed, 05 Oct 2022 02:02:53 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id az26-20020adfe19a000000b0022cd59331b2sm14774538wrb.95.2022.10.05.02.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 02:02:51 -0700 (PDT)
Message-ID: <33d7599c-0759-baf7-5e98-dacdf8b3ccf5@redhat.com>
Date:   Wed, 5 Oct 2022 11:02:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC v2 13/15] vfio/iommufd: Implement the iommufd backend
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, eric.auger.pro@gmail.com,
        kevin.tian@intel.com, chao.p.peng@intel.com, yi.y.sun@intel.com,
        peterx@redhat.com, shameerali.kolothum.thodi@huawei.com,
        zhangfei.gao@linaro.org, berrange@redhat.com, qemu-devel@nongnu.org
References: <20220608123139.19356-1-yi.l.liu@intel.com>
 <20220608123139.19356-14-yi.l.liu@intel.com> <87zgecqdv1.fsf@nvidia.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <87zgecqdv1.fsf@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alister,
On 10/4/22 08:47, Alistair Popple wrote:
> Yi Liu <yi.l.liu@intel.com> writes:
>
> [...]
>
>> +static int vfio_get_devicefd(const char *sysfs_path, Error **errp)
>> +{
>> +    long int ret = -ENOTTY;
>> +    char *path, *vfio_dev_path = NULL, *vfio_path = NULL;
>> +    DIR *dir;
>> +    struct dirent *dent;
>> +    gchar *contents;
>> +    struct stat st;
>> +    gsize length;
>> +    int major, minor;
>> +    dev_t vfio_devt;
>> +
>> +    path = g_strdup_printf("%s/vfio-device", sysfs_path);
>> +    if (stat(path, &st) < 0) {
>> +        error_setg_errno(errp, errno, "no such host device");
>> +        goto out_free_path;
>> +    }
>> +
>> +    dir = opendir(path);
>> +    if (!dir) {
>> +        error_setg_errno(errp, errno, "couldn't open dirrectory %s", path);
>> +        goto out_free_path;
>> +    }
>> +
>> +    while ((dent = readdir(dir))) {
>> +        if (!strncmp(dent->d_name, "vfio", 4)) {
>> +            vfio_dev_path = g_strdup_printf("%s/%s/dev", path, dent->d_name);
>> +            break;
>> +        }
>> +    }
>> +
>> +    if (!vfio_dev_path) {
>> +        error_setg(errp, "failed to find vfio-device/vfioX/dev");
>> +        goto out_free_path;
>> +    }
>> +
>> +    if (!g_file_get_contents(vfio_dev_path, &contents, &length, NULL)) {
>> +        error_setg(errp, "failed to load \"%s\"", vfio_dev_path);
>> +        goto out_free_dev_path;
>> +    }
>> +
>> +    if (sscanf(contents, "%d:%d", &major, &minor) != 2) {
>> +        error_setg(errp, "failed to get major:mino for \"%s\"", vfio_dev_path);
>> +        goto out_free_dev_path;
>> +    }
>> +    g_free(contents);
>> +    vfio_devt = makedev(major, minor);
>> +
>> +    vfio_path = g_strdup_printf("/dev/vfio/devices/%s", dent->d_name);
>> +    ret = open_cdev(vfio_path, vfio_devt);
>> +    if (ret < 0) {
>> +        error_setg(errp, "Failed to open %s", vfio_path);
>> +    }
>> +
>> +    trace_vfio_iommufd_get_devicefd(vfio_path, ret);
>> +    g_free(vfio_path);
>> +
>> +out_free_dev_path:
>> +    g_free(vfio_dev_path);
>> +out_free_path:
>> +    g_free(path);
>> +
>> +    if (*errp) {
>> +        error_prepend(errp, VFIO_MSG_PREFIX, path);
> I ran into this while trying to get things running, so haven't reviewed
> the patch but noticed path is used after it's freed if !!*errp.

thank you for the bug report! We will fix that on the next iteration.

Eric
>
>  - Alistair
>
>> +    }
>> +    return ret;
>> +}

