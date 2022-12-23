Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59CC655536
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 23:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiLWWgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Dec 2022 17:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbiLWWgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Dec 2022 17:36:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C96F55AC
        for <kvm@vger.kernel.org>; Fri, 23 Dec 2022 14:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671834966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vAEhCvBqDOSeVJ5cr+C6I0wt8yyHcksJQ4MmdK2pgfQ=;
        b=VCD5XFNNFahNaBun0+u5iYfeEm9ZgbZh694LccFbz5ulG3F/Up354niYevB7PclVcaiKo/
        ms1zcJjgytvUSpwzXHSa0bQf4brfL8eRQgbOVb1sEzMWt/ejZG6htOSeCKPhAjT8MrVvIZ
        fYIWwXQzbNTW3RpQiwqoYU/vOIRHy2M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-534-Le0HkqIKP3i-f_jby9jT3w-1; Fri, 23 Dec 2022 17:36:05 -0500
X-MC-Unique: Le0HkqIKP3i-f_jby9jT3w-1
Received: by mail-ed1-f70.google.com with SMTP id v4-20020a056402348400b0046cbbc786bdso4379343edc.7
        for <kvm@vger.kernel.org>; Fri, 23 Dec 2022 14:36:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vAEhCvBqDOSeVJ5cr+C6I0wt8yyHcksJQ4MmdK2pgfQ=;
        b=bUZX2z6COJdaqGYp1ccl+HnN/W5eQvPX6zbPWe435XUOUG+qDX2LMnC0O7G9Ya5XdA
         7LG3OUWJ9cmdB5u9iNt1dfqKEkjPPPD7QVuVNCckFVeyHWDBGfl3Tfdr49L3E8bnclAe
         yUfBs80LF3JKfO4WyApcPm0iaCWwgr+gqK2I7538p21Q5MBOpJfG//i6ZEJgASoT3Z0k
         UiuOUYvlrQZOvKvJsFpoeiySafwkS7RYjGdlZdpgdwPcNX0dh2kDGdcqgu47pLzzt+WH
         ehtMRrFyiYfjQRbTbVBXFagpcACf7HsL0Tti85N9hZdp3WwaOKusKZswln1YJc3wdK+c
         FHsA==
X-Gm-Message-State: AFqh2kpShIbf9N7MjSnwjRLXVGfxc2Hl1H0pB57V1R2Ltzq1qD5CahVm
        L8Qjo0Ylsq5ywNG60267uOJGuh+leEVuR2bzokFT9WsaKk6logn44OSgyKKpR0Mmi8i2W4UOPiz
        iKKeEa4iwSGsU
X-Received: by 2002:a17:906:7f91:b0:7c1:5a5:f6bb with SMTP id f17-20020a1709067f9100b007c105a5f6bbmr8730268ejr.50.1671834964184;
        Fri, 23 Dec 2022 14:36:04 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuLH42LmprbIKVhy48/0bhL/K12YuoqsuPbuz81JiRHptRGsUb+Yjw6OoTZMpmBqEdLpDoCRQ==
X-Received: by 2002:a17:906:7f91:b0:7c1:5a5:f6bb with SMTP id f17-20020a1709067f9100b007c105a5f6bbmr8730220ejr.50.1671834963942;
        Fri, 23 Dec 2022 14:36:03 -0800 (PST)
Received: from redhat.com ([2.55.175.215])
        by smtp.gmail.com with ESMTPSA id z4-20020a1709060ac400b007c500ac66b2sm1831409ejf.64.2022.12.23.14.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 14:36:03 -0800 (PST)
Date:   Fri, 23 Dec 2022 17:35:56 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
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
Subject: Re: [GIT PULL] virtio,vhost,vdpa: features, fixes, cleanups
Message-ID: <20221223173127-mutt-send-email-mst@kernel.org>
References: <20221222144343-mutt-send-email-mst@kernel.org>
 <CAHk-=wi6Gkr7hJz20+xD=pBuTrseccVgNR9ajU7=Bqbrdk1t4g@mail.gmail.com>
 <20221223172549-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221223172549-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 23, 2022 at 05:27:49PM -0500, Michael S. Tsirkin wrote:
> On Fri, Dec 23, 2022 at 11:54:41AM -0800, Linus Torvalds wrote:
> > On Thu, Dec 22, 2022 at 11:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> > 
> > I see none of this in linux-next.
> > 
> >                Linus
> 
> They were all there, just not as these commits, as I squashed fixups to
> avoid bisect breakages with some configs. Did I do wrong?

More specifically, everything up to
458326ec10d1233399a342263d33878cb0afe710 lines up in next-20221220, and
then I decided to rebase to squash bugfixes.
Plus these are two trivial patches on top that just tweak sparse
tags so 0 chance of regressions, and an also trivial security-related bugfix.


> -- 
> MST

