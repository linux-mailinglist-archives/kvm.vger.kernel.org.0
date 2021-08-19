Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51143F123A
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 06:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhHSELx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 00:11:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47775 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229520AbhHSELw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 00:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629346276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VBYriaxQXLlAIO2jBLfdlJqsXE4thEUkTkWuNBb3xSE=;
        b=jTB9d5CywGiL9GEk4/rlMOCd1ZL8Er31etGoHhK1daVm9GXiXVIAj4PJhunnDTQdVENhjD
        I+GHN5IXWbbactlYo7M5h6+Gd8fvYBtMNRWmjb79EyD+1nIb+cwGrqucRU562wRdm/gBLa
        0pqVYlYA3O7IEjU62j8NFawIBN+WRW8=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-6jP9jiOZOBSphdz_PicS0A-1; Thu, 19 Aug 2021 00:11:15 -0400
X-MC-Unique: 6jP9jiOZOBSphdz_PicS0A-1
Received: by mail-pf1-f198.google.com with SMTP id n27-20020a056a000d5b00b003e147fb595eso2427389pfv.6
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 21:11:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VBYriaxQXLlAIO2jBLfdlJqsXE4thEUkTkWuNBb3xSE=;
        b=dxlDYD22dxckNTq/qPS501fG7B26YrvbR/8dWmDqoUMH7+EgjM0nid1EQ4sSyGe+oL
         7jYC2XicQAIjz9NYL8EoW0cDxp/BOnOlQI3l4ELZDwHpUETnpqLMGYGn8H43QerTKxBs
         NcS7zA3v8j2DkhOhfLVUqMWa9A7Eo6rMBX+BdW+McymWn1Uu9yOFxW5BnY5S7guxF77E
         RTdzj20riaJpsc1maG8ohrRlZBqyWzlitap+ACUn5H808vJAYsqYih/JAdoa6XfjdfWb
         VPLGFnU9ZbUS0CNBcV0HMhDnC5O4I3nNhkdEv1e5Lw+7faknm2T3FNHIr650o6AkoW2a
         4zGQ==
X-Gm-Message-State: AOAM532O1NDQzexqg+EoX+EXZX3K7oWHwkALVgJab/n2nzKWWYlXUkpH
        rXZmSBrwDByWXHQJN2K3keI/7sf36Na5ryzI168bZGMVNULgi7QitogIJiM8L/QaXyjeY++Bk2v
        tSzVQGaMH1F2BPVKgcc51d4Fk0q11OCSwN6y/DvPUAiUVSTJrOtWcY0EX4HS6JTqL
X-Received: by 2002:a05:6a00:1ace:b0:3e2:2a73:e0a4 with SMTP id f14-20020a056a001ace00b003e22a73e0a4mr12939448pfv.73.1629346274024;
        Wed, 18 Aug 2021 21:11:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLQPUem25xDlLQ3uF4CA7Dea+zPxgfi0RExMgvKM2TveGCChyP8g6txlY/nWsye2RZ0v3/9w==
X-Received: by 2002:a05:6a00:1ace:b0:3e2:2a73:e0a4 with SMTP id f14-20020a056a001ace00b003e22a73e0a4mr12939432pfv.73.1629346273757;
        Wed, 18 Aug 2021 21:11:13 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id nv11sm6500567pjb.48.2021.08.18.21.11.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 21:11:13 -0700 (PDT)
Subject: Re: [PATCH 0/2] vDPA/ifcvf: enable multiqueue and control vq
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210818095714.3220-1-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e3ec8ed7-84ac-73cc-0b74-4de1bb6c0030@redhat.com>
Date:   Thu, 19 Aug 2021 12:11:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210818095714.3220-1-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/8/18 ÏÂÎç5:57, Zhu Lingshan Ð´µÀ:
> This series enables multi-queue and control vq features
> for ifcvf.
>
> These patches are based on my previous vDPA/ifcvf management link
> implementation series:
> https://lore.kernel.org/kvm/20210812032454.24486-2-lingshan.zhu@intel.com/T/
>
> Thanks!
>
> Zhu Lingshan (2):
>    vDPA/ifcvf: detect and use the onboard number of queues directly
>    vDPA/ifcvf: enable multiqueue and control vq
>
>   drivers/vdpa/ifcvf/ifcvf_base.c |  8 +++++---
>   drivers/vdpa/ifcvf/ifcvf_base.h | 19 ++++---------------
>   drivers/vdpa/ifcvf/ifcvf_main.c | 32 +++++++++++++++-----------------
>   3 files changed, 24 insertions(+), 35 deletions(-)
>

Patch looks good.

I wonder the compatibility. E.g does it work on the qemu master without 
cvq support? (mq=off or not specified)

Thanks

