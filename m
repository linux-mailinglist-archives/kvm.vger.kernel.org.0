Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147EB655412
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 21:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiLWUBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Dec 2022 15:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiLWUBf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Dec 2022 15:01:35 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED6E60E6
        for <kvm@vger.kernel.org>; Fri, 23 Dec 2022 12:01:35 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id b81so2672721vkf.1
        for <kvm@vger.kernel.org>; Fri, 23 Dec 2022 12:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ytlGRN+Zvf1GCedPeHeIV0/Bc2Bxmm4MYRgni7UZ0VA=;
        b=T/HZO1Z86a/yucKbo8fCYB94xGQsaTO4ihOAnJOljMUc9OICiF/xMdXrc4ryg28DpR
         eFl/E3g3ID+1rnnglCWSW0jyixUPXe1uLYogNis+p2d9rOzDyOEgoIH4uPfAhY1MCiEh
         FRVU9oEHU2CS0vZvFc4uxoQNQVaMpW4BUYnLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ytlGRN+Zvf1GCedPeHeIV0/Bc2Bxmm4MYRgni7UZ0VA=;
        b=muVzBF83obWC5zeU9przYqzjlExuVMKylyL3LzGFib9ZXXTAA/c43QTPQ59CHwuh+f
         /vBSIOSZkJXWi8Kyw5buRXlkGU60WCaxa1N7XFCpdFw34TzmKQVOA4l/35uVmQH0yoLp
         xaI8m1vZ1hB2oEjFaB7pOVMqJVdPhbBFjOjuoMVDbF9uQ/z20r1b9ltHyg54qghTqDNF
         FSU5VKRJjAd9d3oaA8uhJqQd+8TH7oJJMWN1HtKKz91a1iIkZXsOKVNjePTpV2vWCM35
         LpWBrW4yGQFxT+pvcHXIPHm6PycmP7JgjI0ZXIp4Wm0fw9AvIpkdhfPkAGdeBt6eUJES
         C5PA==
X-Gm-Message-State: AFqh2kqJ+9EUmZGNBMDwAkR184gLjbqV5h4UHxwlSYxtJHjvuDpp7ial
        8GLJHc2MEouCS6bMiTYA4VtCtPp8Tdjq3BGd
X-Google-Smtp-Source: AMrXdXv+i+se9BbkjyDkS12BD52+BAoIyEHUH0WMB9bVOQJjlSAhVlmJbTgEYtmbsSukwf7h9+fMUw==
X-Received: by 2002:ac5:cb47:0:b0:3bc:c0d2:92e6 with SMTP id s7-20020ac5cb47000000b003bcc0d292e6mr4334184vkl.12.1671825693860;
        Fri, 23 Dec 2022 12:01:33 -0800 (PST)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com. [209.85.219.48])
        by smtp.gmail.com with ESMTPSA id x10-20020a05620a448a00b006ea7f9d8644sm2895391qkp.96.2022.12.23.12.01.33
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Dec 2022 12:01:33 -0800 (PST)
Received: by mail-qv1-f48.google.com with SMTP id h10so3768343qvq.7
        for <kvm@vger.kernel.org>; Fri, 23 Dec 2022 12:01:33 -0800 (PST)
X-Received: by 2002:a05:6214:2b9a:b0:4c7:20e7:a580 with SMTP id
 kr26-20020a0562142b9a00b004c720e7a580mr551504qvb.43.1671825298226; Fri, 23
 Dec 2022 11:54:58 -0800 (PST)
MIME-Version: 1.0
References: <20221222144343-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221222144343-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 23 Dec 2022 11:54:41 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi6Gkr7hJz20+xD=pBuTrseccVgNR9ajU7=Bqbrdk1t4g@mail.gmail.com>
Message-ID: <CAHk-=wi6Gkr7hJz20+xD=pBuTrseccVgNR9ajU7=Bqbrdk1t4g@mail.gmail.com>
Subject: Re: [GIT PULL] virtio,vhost,vdpa: features, fixes, cleanups
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        almasrymina@google.com, alvaro.karsz@solid-run.com,
        anders.roxell@linaro.org, angus.chen@jaguarmicro.com,
        bobby.eshleman@bytedance.com, colin.i.king@gmail.com,
        dave@stgolabs.net, dengshaomin@cdjrlc.com, dmitry.fomichev@wdc.com,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@xilinx.com,
        harshit.m.mogalapalli@oracle.com, jasowang@redhat.com,
        leiyang@redhat.com, lingshan.zhu@intel.com, lkft@linaro.org,
        lulu@redhat.com, m.szyprowski@samsung.com, nathan@kernel.org,
        pabeni@redhat.com, pizhenwei@bytedance.com, rafaelmendsr@gmail.com,
        ricardo.canuelo@collabora.com, ruanjinjie@huawei.com,
        sammler@google.com, set_pte_at@outlook.com, sfr@canb.auug.org.au,
        sgarzare@redhat.com, shaoqin.huang@intel.com,
        si-wei.liu@oracle.com, stable@vger.kernel.org, stefanha@gmail.com,
        sunnanyong@huawei.com, wangjianli@cdjrlc.com,
        wangrong68@huawei.com, weiyongjun1@huawei.com,
        xuanzhuo@linux.alibaba.com, yuancan@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 22, 2022 at 11:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

I see none of this in linux-next.

               Linus
