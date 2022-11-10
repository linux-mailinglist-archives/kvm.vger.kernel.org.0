Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200F9623CF0
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 08:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbiKJHw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 02:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbiKJHwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 02:52:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45FE20F5A
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 23:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668066720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0BukYDFp+3V0lSdmBo/7OCIgvVdGhW19qZEuq21xG+s=;
        b=W6glME9WiAPrprNL0sXtFDK8KsNiiob8nOPYcEIO0/dW0Y8trhVO/uL89W6MrT+xRaPEp9
        evPqUEgZO7FAOX+404EgbIFP9z9J6Icq8L2wNYHKfKjGAvtmMn5BdYfi9ydRwNo6jaCX9B
        lWEvAZ46IKwAlCOcsyHjPqR7z7bnfVQ=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-204-Jkehuv4UN3yfpYpIaor4hA-1; Thu, 10 Nov 2022 02:51:59 -0500
X-MC-Unique: Jkehuv4UN3yfpYpIaor4hA-1
Received: by mail-pf1-f198.google.com with SMTP id x11-20020a056a000bcb00b0056c6ec11eefso656589pfu.14
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 23:51:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0BukYDFp+3V0lSdmBo/7OCIgvVdGhW19qZEuq21xG+s=;
        b=yznoTyS2z76OC9RnQ+2IqF8yDhAc/y25XB+U0SpHSYgYsZWLd0BJN3PqqUmnKqYdrM
         uv+cfo4TGRN5upYYqXW2nXgtrECJ+11zauAbpXvoPPZRkFMD3L3r6xWSdWK9GfRYrIhf
         slGFzxyrd8SsI4RmdShwYMhbsZ+eTmbyKQV+iAHP/0FZY+GFumqfiH2FjFB7F9Yz7GKr
         jrROvr7IhjvNjTPmSURqs1RGXiXrvPY9vwxpExH4w9iBCMneWLElcmSzBtK37nOxPxy2
         JjFpu21UOvQUZfxedTike9oGd/u9wMjhuiBMf34GVu01on/6WhnvUJav98sN+VGLstPo
         4IXw==
X-Gm-Message-State: ACrzQf35xgIK29m6pedrgdfZ3DObItMUb+KQ7pChLXY5mFyBBKaKq5W7
        eABh/NU9CLONduM/nDVSsPeQ+pLmsjktGAUuF1mbdVkfl9rvtI5Qwrq4navQCN+hp+oHNOgdP7w
        KOVs+l4e6S2fH
X-Received: by 2002:a05:6a00:3017:b0:56c:d93a:ac5f with SMTP id ay23-20020a056a00301700b0056cd93aac5fmr2047775pfb.48.1668066716034;
        Wed, 09 Nov 2022 23:51:56 -0800 (PST)
X-Google-Smtp-Source: AMsMyM62llp4+rX7BDLVjqGS33okh97ITleFTCr5eit2hngy1azqFGjBcv7rs8d1DCZ+cEAoJNFZhw==
X-Received: by 2002:a05:6a00:3017:b0:56c:d93a:ac5f with SMTP id ay23-20020a056a00301700b0056cd93aac5fmr2047760pfb.48.1668066715600;
        Wed, 09 Nov 2022 23:51:55 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id d10-20020a17090a628a00b0020669c8bd87sm2444283pjj.36.2022.11.09.23.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 23:51:55 -0800 (PST)
Date:   Thu, 10 Nov 2022 08:51:42 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, eperezma@redhat.com,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: fix potential memory leak during the release
Message-ID: <20221110075142.f6yr7wagqa33rjjn@sgarzare-redhat>
References: <20221109154213.146789-1-sgarzare@redhat.com>
 <20221109124430-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221109124430-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 12:47:19PM -0500, Michael S. Tsirkin wrote:
>On Wed, Nov 09, 2022 at 04:42:13PM +0100, Stefano Garzarella wrote:
>> Before commit 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
>> we call vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1) during the
>> release to free all the resources allocated when processing user IOTLB
>> messages through vhost_vdpa_process_iotlb_update().
>> That commit changed the handling of IOTLB a bit, and we accidentally
>> removed some code called during the release.
>>
>> We partially fixed with commit 037d4305569a ("vhost-vdpa: call
>> vhost_vdpa_cleanup during the release") but a potential memory leak is
>> still there as showed by kmemleak if the application does not send
>> VHOST_IOTLB_INVALIDATE or crashes:
>>
>>   unreferenced object 0xffff888007fbaa30 (size 16):
>>     comm "blkio-bench", pid 914, jiffies 4294993521 (age 885.500s)
>>     hex dump (first 16 bytes):
>>       40 73 41 07 80 88 ff ff 00 00 00 00 00 00 00 00  @sA.............
>>     backtrace:
>>       [<0000000087736d2a>] kmem_cache_alloc_trace+0x142/0x1c0
>>       [<0000000060740f50>] vhost_vdpa_process_iotlb_msg+0x68c/0x901 [vhost_vdpa]
>>       [<0000000083e8e205>] vhost_chr_write_iter+0xc0/0x4a0 [vhost]
>>       [<000000008f2f414a>] vhost_vdpa_chr_write_iter+0x18/0x20 [vhost_vdpa]
>>       [<00000000de1cd4a0>] vfs_write+0x216/0x4b0
>>       [<00000000a2850200>] ksys_write+0x71/0xf0
>>       [<00000000de8e720b>] __x64_sys_write+0x19/0x20
>>       [<0000000018b12cbb>] do_syscall_64+0x3f/0x90
>>       [<00000000986ec465>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>
>> Let's fix calling vhost_vdpa_iotlb_unmap() on the whole range in
>> vhost_vdpa_remove_as(). We move that call before vhost_dev_cleanup()
>> since we need a valid v->vdev.mm in vhost_vdpa_pa_unmap().
>> vhost_iotlb_reset() call can be removed, since vhost_vdpa_iotlb_unmap()
>> on the whole range removes all the entries.
>>
>> The kmemleak log reported was observed with a vDPA device that has `use_va`
>> set to true (e.g. VDUSE). This patch has been tested with both types of
>> devices.
>>
>> Fixes: 037d4305569a ("vhost-vdpa: call vhost_vdpa_cleanup during the release")
>> Fixes: 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>
>It's fine, just pls don't say "potential" here in the subject, let's
>avoid pleonasms

Got it, I'll avoid in the future.

>- it's a memory leak, yes it triggers under some coditions
>but little is unconditional in this world :)

Nothing could be more true :-)

>
>No need to repost.
>

Thanks,
Stefano

