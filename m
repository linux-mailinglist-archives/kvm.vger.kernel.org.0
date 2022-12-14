Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A4064C563
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 09:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbiLNI6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 03:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237691AbiLNI6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 03:58:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FD7F5AB
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 00:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671008283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=832mpI+gR6rtu0NTrZQMBVgIPwRT7EhuSzoHFhXLS+0=;
        b=hNK84nvEZDkgw6i2HN0RDK6pEC5inFIRRHfCjQFI+ZPKSdqApm7UcUOffhtDT4bfcxM6Z3
        YYwJjj7RBIgXVSkbvMD63y5n/y3JnuYeQUiCcEPtQKhTUgDaIgpH0i1RItOuGIRJ0gSWuJ
        Jk3SPZNDu0I/O60mwVmUrJLukhdUO1M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-166-DIkaKsbEOYKRM4SwHXovwA-1; Wed, 14 Dec 2022 03:58:02 -0500
X-MC-Unique: DIkaKsbEOYKRM4SwHXovwA-1
Received: by mail-wm1-f69.google.com with SMTP id a6-20020a05600c224600b003d1f3ed49adso3892510wmm.4
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 00:58:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=832mpI+gR6rtu0NTrZQMBVgIPwRT7EhuSzoHFhXLS+0=;
        b=ZD0JETaF6HnR2WPz3zIGuWgO1qbnRNZXpi+ICVwQsTskGeuIL0qGDCTFKk0J5g70dd
         oVjLw2Srwt0CVXltbg15l5jKUQfpZPvQAQIS6J+yvCsNxp37NgKijvIsCAr2qoRZ/tKe
         FPd2QuM5m0N4bbuVmp0vyrmQpIcqW0gzKXwdThfnEVLzVtyKyTy2ZCqTSaN2f6Ut+P2V
         Yi1kDeQdo2yWpswcxonxIDrSwow6kLPVfs87qTStvyWhuklDioHtNPpoLiRaM5gVjSmX
         IlKVC2HUz3JCMk+G9wm3eS1eopRNDU1kdxx9ApykQCmY7gjxncQiwycLvQusRRO/l9Qk
         VIBg==
X-Gm-Message-State: ANoB5pmRYNw1r/gpaGG3c2pMEANWUTYZ/onq/SDWEOC6k5QroTo1fFb9
        jHSLb++Us4bnOveLnWnHGqDNgkL6SY6/61iCGqeks4A8vZtFpngCWsdJTmgFFoUnFLeaUz+wOIY
        FHMquLDnQ7SbA
X-Received: by 2002:a05:600c:3d92:b0:3c6:e60f:3f4a with SMTP id bi18-20020a05600c3d9200b003c6e60f3f4amr18216226wmb.1.1671008280664;
        Wed, 14 Dec 2022 00:58:00 -0800 (PST)
X-Google-Smtp-Source: AA0mqf53p0lWtwtyxZpsSsSCyKb1X/sJvqIEShJdkD4rFJgOxq6InnJoxKzbHWv/g59LP540LxvirA==
X-Received: by 2002:a05:600c:3d92:b0:3c6:e60f:3f4a with SMTP id bi18-20020a05600c3d9200b003c6e60f3f4amr18216216wmb.1.1671008280437;
        Wed, 14 Dec 2022 00:58:00 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id m17-20020a7bce11000000b003d2157627a8sm1685733wmc.47.2022.12.14.00.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 00:57:59 -0800 (PST)
Date:   Wed, 14 Dec 2022 09:57:54 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7] virtio/vsock: replace virtio_vsock_pkt with
 sk_buff
Message-ID: <20221214085754.6kogsesmqcud5ggn@sgarzare-redhat>
References: <20221213192843.421032-1-bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221213192843.421032-1-bobby.eshleman@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 13, 2022 at 07:28:42PM +0000, Bobby Eshleman wrote:
>This commit changes virtio/vsock to use sk_buff instead of
>virtio_vsock_pkt. Beyond better conforming to other net code, using
>sk_buff allows vsock to use sk_buff-dependent features in the future
>(such as sockmap) and improves throughput.
>
>This patch introduces the following performance changes:
>
>Tool/Config: uperf w/ 64 threads, SOCK_STREAM
>Test Runs: 5, mean of results
>Before: commit 95ec6bce2a0b ("Merge branch 'net-ipa-more-endpoints'")
>
>Test: 64KB, g2h
>Before: 21.63 Gb/s
>After: 25.59 Gb/s (+18%)
>
>Test: 16B, g2h
>Before: 11.86 Mb/s
>After: 17.41 Mb/s (+46%)
>
>Test: 64KB, h2g
>Before: 2.15 Gb/s
>After: 3.6 Gb/s (+67%)
>
>Test: 16B, h2g
>Before: 14.38 Mb/s
>After: 18.43 Mb/s (+28%)
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
>
>Note: v7 only built, not retested since v6.

I re-tested and everything seems okay:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

