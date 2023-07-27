Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA8D76496C
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 09:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbjG0Hyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 03:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbjG0Hyf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 03:54:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2999A30D8
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 00:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690444111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j1sGpcCh25quOAjflnOwlUM9P1X98CB5H9u91wgYUjs=;
        b=BAfH3eZZvfwnJ81BopGYpP+k8GjtSQzt79eEbkVEr2cVjPdLpQmwhB4yTswajYRZ6B+NFY
        fnfDIP4z5sl/B+tKOj4oqLqDwYTAdYRIMFU4jI42pyT3K469KCFzWOCfcsqF3klvqX6pqw
        hW/6iJzApCwFccZ6IjdClK7JPKCvBdw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-a6acApl2NgqGiUuONxl_qA-1; Thu, 27 Jul 2023 03:48:29 -0400
X-MC-Unique: a6acApl2NgqGiUuONxl_qA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-993831c639aso35741466b.2
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 00:48:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690444109; x=1691048909;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j1sGpcCh25quOAjflnOwlUM9P1X98CB5H9u91wgYUjs=;
        b=XiV5hRklqANuDT5FQbfVz0Kw5f8d0H+ArWQ5JOYsR32llKNpqwLlX/6Wc8IWQpKZac
         wQ8GYiq1/kjoThJJ5TbpuavCALBUyZoIfCgP0FBhDwLIh2eQDnnSSFRu7XwF///6gIiD
         aSadj504Yx2PtPqVrYjXWc3fCurrOYq9UCcYAdHzl9ncKcIg2RSxmwcyQpdpRr6JKw2A
         widIVeLxbhgZCmm6oqjhezDVEIQFr9AecfUuKaBhTd+NJm4MhZRwh/Htrgyx+JQoiD2j
         9GNh5vgxfWTK959DfH9Vtw8y48ssQDLhLqLBi7m94vfVt3FvD0nmRQ2lo8l4mKQHQtIE
         jw1A==
X-Gm-Message-State: ABy/qLYGW3H1b5xjlMKTcnwZH1Yn+qhgfztDZxL7avOZwdXMO+2saALK
        IZgY2SvY0vVqWyHBVFk6UMzl4teEZJY8heH801k6A2RnaM0lq81p07dtWo23007Q0g28WxfPa92
        +KJrksjNUSl0P
X-Received: by 2002:a17:907:a068:b0:989:3148:e9a with SMTP id ia8-20020a170907a06800b0098931480e9amr1273091ejc.41.1690444108917;
        Thu, 27 Jul 2023 00:48:28 -0700 (PDT)
X-Google-Smtp-Source: APBJJlE55JyhKwJyB8qUe+lq1MkQNb4GdgSPTG/st46k7wZpyOLVvAygT9RNqVELeE+FBejRoktCsg==
X-Received: by 2002:a17:907:a068:b0:989:3148:e9a with SMTP id ia8-20020a170907a06800b0098931480e9amr1273068ejc.41.1690444108579;
        Thu, 27 Jul 2023 00:48:28 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.217.102])
        by smtp.gmail.com with ESMTPSA id z16-20020a170906075000b00993a9a951fasm467215ejb.11.2023.07.27.00.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 00:48:28 -0700 (PDT)
Date:   Thu, 27 Jul 2023 09:48:21 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org, Jiang Wang <jiang.wang@bytedance.com>
Subject: Re: [PATCH RFC net-next v5 10/14] virtio/vsock: add
 VIRTIO_VSOCK_F_DGRAM feature bit
Message-ID: <tpwk67lij7t7hquduogxzyox5wvq73yriv7vqiizqoxxtxvfwq@jzkcmq4kv3b4>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
 <20230413-b4-vsock-dgram-v5-10-581bd37fdb26@bytedance.com>
 <20230726143736-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230726143736-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 26, 2023 at 02:38:08PM -0400, Michael S. Tsirkin wrote:
>On Wed, Jul 19, 2023 at 12:50:14AM +0000, Bobby Eshleman wrote:
>> This commit adds a feature bit for virtio vsock to support datagrams.
>>
>> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
>> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>> ---
>>  include/uapi/linux/virtio_vsock.h | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>> index 331be28b1d30..27b4b2b8bf13 100644
>> --- a/include/uapi/linux/virtio_vsock.h
>> +++ b/include/uapi/linux/virtio_vsock.h
>> @@ -40,6 +40,7 @@
>>
>>  /* The feature bitmap for virtio vsock */
>>  #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
>> +#define VIRTIO_VSOCK_F_DGRAM		3	/* SOCK_DGRAM supported */
>>
>>  struct virtio_vsock_config {
>>  	__le64 guest_cid;
>
>pls do not add interface without first getting it accepted in the
>virtio spec.

Yep, fortunatelly this series is still RFC.
I think by now we've seen that the implementation is doable, so we
should discuss the changes to the specification ASAP. Then we can
merge the series.

@Bobby can you start the discussion about spec changes?

Thanks,
Stefano

