Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4AA6D430B
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 13:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbjDCLLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 07:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjDCLLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 07:11:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508E3F3
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 04:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680520223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2LyTXIwTIB/nVxYXSDDIz7jSdM+ZVkfbUtijN6RN/W0=;
        b=eQOzxIBmubDrJygysoibgT0Ehz51RvK/34tapLj2paIGkGtcgT8gWjchdCXaUA6TNkOO+5
        INNgYdmAgzNLaVTGFgtxintov3Cxx176WTWNeBWDZJ0Kbpq9+mE4ueDJoGaKvzORhyzSRg
        MkU4A3PFDGA/qrwH5i1DWKXTQs0uJSc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-7w6UbNIhMXe6mDVX6zbKwg-1; Mon, 03 Apr 2023 07:10:22 -0400
X-MC-Unique: 7w6UbNIhMXe6mDVX6zbKwg-1
Received: by mail-qk1-f198.google.com with SMTP id x80-20020a376353000000b0074681bc7f42so12910298qkb.8
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 04:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680520222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2LyTXIwTIB/nVxYXSDDIz7jSdM+ZVkfbUtijN6RN/W0=;
        b=a2DPJtvo4CQ+wka3baisEmbic85wE4t1bGIhAsH1pSfeVoO44A4gh/U5AUjg7RZcTO
         YX8fyZbp1TIIEyfztRmBozEwOCHJlxxbrgmMtFpK6suVwRQAw+QM+afEL4jPV4B7BtOr
         a4xV0S29OhXzGTASz1VF4oBwHnW8D+NC6w2tvJLPs3IoaDwBqaDVgZzXcrjKmcek89qp
         XnK3IDNqhPn/uFtey+QaMUduTgTAphePxIDmiKwCLtHvEH8Sj8Cr0NzlCgQtRNHEekYc
         V8RbXc4vonuQGUT0xH2FaS2CxtbCQUf9/sRiIUmi9fzB7B/F2eJ01qoyREHra6dbCT1R
         VZog==
X-Gm-Message-State: AAQBX9ee29Su27dfQIN7Pmd2iNZ1aotHkrufWhbWj2mEBNz86m5Tn2v+
        3ZSbvUivML9vxej1vK1p/rzaim1pDQPVuw8iwwFNyUlN3dnDipzPVZ+peJ8lBGKAJE7GS21pnwd
        HKdQX7pjJkLDY
X-Received: by 2002:a05:6214:20af:b0:5b7:fc3f:627c with SMTP id 15-20020a05621420af00b005b7fc3f627cmr56199438qvd.41.1680520222083;
        Mon, 03 Apr 2023 04:10:22 -0700 (PDT)
X-Google-Smtp-Source: AKy350anlnRjskidVzUxw4lC24jdLIo1HJimHkPD2ABe7fU37aXmhofK7QF06gaCIs48vZzsoFlAZQ==
X-Received: by 2002:a05:6214:20af:b0:5b7:fc3f:627c with SMTP id 15-20020a05621420af00b005b7fc3f627cmr56199409qvd.41.1680520221837;
        Mon, 03 Apr 2023 04:10:21 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-130.retail.telecomitalia.it. [82.57.51.130])
        by smtp.gmail.com with ESMTPSA id di15-20020ad458ef000000b005e13c17dcb8sm2536442qvb.79.2023.04.03.04.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 04:10:21 -0700 (PDT)
Date:   Mon, 3 Apr 2023 13:10:14 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/3] Add support for sockmap to vsock.
Message-ID: <u3azhe3tsae6c3h2hbhzypvcxbjsostqple3wkqtplvdhtadkf@5posaldst7ec>
References: <20230327-vsock-sockmap-v4-0-c62b7cd92a85@bytedance.com>
 <6427838247d16_c503a2087e@john.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6427838247d16_c503a2087e@john.notmuch>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 31, 2023 at 06:06:10PM -0700, John Fastabend wrote:
>Bobby Eshleman wrote:
>> We're testing usage of vsock as a way to redirect guest-local UDS
>> requests to the host and this patch series greatly improves the
>> performance of such a setup.
>>
>> Compared to copying packets via userspace, this improves throughput by
>> 121% in basic testing.
>>
>> Tested as follows.
>>
>> Setup: guest unix dgram sender -> guest vsock redirector -> host vsock
>>        server
>> Threads: 1
>> Payload: 64k
>> No sockmap:
>> - 76.3 MB/s
>> - The guest vsock redirector was
>>   "socat VSOCK-CONNECT:2:1234 UNIX-RECV:/path/to/sock"
>> Using sockmap (this patch):
>> - 168.8 MB/s (+121%)
>> - The guest redirector was a simple sockmap echo server,
>>   redirecting unix ingress to vsock 2:1234 egress.
>> - Same sender and server programs
>>
>> *Note: these numbers are from RFC v1
>>
>> Only the virtio transport has been tested. The loopback transport was
>> used in writing bpf/selftests, but not thoroughly tested otherwise.
>>
>> This series requires the skb patch.
>
>Appears reasonable to me although I didn't review internals of all
>the af_vsock stuff. I see it got merged great.

Thanks for checking!

>
>One nit, I have a series coming shortly to pull the tests out of
>the sockmap_listen and into a sockmap_vsock because I don't think they
>belong in _listen but that is just a refactor.
>

LGTM!

Thanks,
Stefano

