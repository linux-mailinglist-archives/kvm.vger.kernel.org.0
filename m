Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F306A2B8C
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 20:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBYTu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 14:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjBYTu0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 14:50:26 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9951B15146
        for <kvm@vger.kernel.org>; Sat, 25 Feb 2023 11:50:24 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id r27so3424380lfe.10
        for <kvm@vger.kernel.org>; Sat, 25 Feb 2023 11:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FQ06yesyUgRY5DSL1h615Nm6fkq1Vhy1HsTju3YI3UI=;
        b=ZxiqbkUqEBDW1KNccJkKK7LUehWcaHJqIx3XuFbnY0uj4GN7vGXNoMgM5/cavjr+eG
         S2Kis6MUPpPXHH77SUCKr0RJ+zmzrUB7pGcj7cYvyAVN8DMoK0njiV/r8E4ayS2IIvv3
         BpeF5BTztR59OOV/oLZdOZU6cfSr1Q6W0MNXw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FQ06yesyUgRY5DSL1h615Nm6fkq1Vhy1HsTju3YI3UI=;
        b=MJ5SbKL0KQFeEq7L+gHzmizHWsx9FEX1fzIyd5ONGSxShIenhTWAn0c9671sHECRoO
         5+bJAklaox67WPsrRmXaIe/f13F5DyK5zhb5jK7773cET7lxWBPX/XD0LmdgFHflOLee
         raBAZ6HBcwwlM5GV1TDdrQ1+FsFUMiPQyBP/xTrp6CZxjMCYtfFkT3MQlA8bUp79DWpD
         FPQ95ksa6GQsUf8RhwddNinBZCC0Ai+26j5+gu9sDFAgnmivwUWkLxnmUk0yomnL5gMC
         9hP1dJ2JazGPsshHVCbyJ2u+zArEUsDojotznS7VgzRvY7cHAxgj4HERW1CL3cG7QUkn
         YBWg==
X-Gm-Message-State: AO0yUKUfnUfsnQ/D770OjLiaHW3Y+pFXqk5S8XLiQFjEiztxMCODJ5S/
        T05Zj+3vK6kJcoHNaFJt+KscIhzrnf1oWW1C2Ic//Q==
X-Google-Smtp-Source: AK7set/F/aXB7bRVqfur95omnIXAuF5B4lbiguFs9/pza7+PkGYHMG+q8ul+p7+M4l1Mh/I8RFKOoA==
X-Received: by 2002:ac2:508f:0:b0:4dd:a772:8d24 with SMTP id f15-20020ac2508f000000b004dda7728d24mr2484406lfm.32.1677354623836;
        Sat, 25 Feb 2023 11:50:23 -0800 (PST)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id g17-20020ac25391000000b004d6f86c52fcsm285756lfh.193.2023.02.25.11.50.23
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 11:50:23 -0800 (PST)
Received: by mail-lj1-f174.google.com with SMTP id b13so2481194ljf.6
        for <kvm@vger.kernel.org>; Sat, 25 Feb 2023 11:50:23 -0800 (PST)
X-Received: by 2002:a17:907:60cd:b0:8f5:2e0e:6dc5 with SMTP id
 hv13-20020a17090760cd00b008f52e0e6dc5mr2490334ejc.0.1677354173776; Sat, 25
 Feb 2023 11:42:53 -0800 (PST)
MIME-Version: 1.0
References: <20230220194045-mutt-send-email-mst@kernel.org> <20230223020356-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230223020356-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 25 Feb 2023 11:42:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg-az1yPKQmmDMnTMdUrg8hLzPUiUtUQu9d2EbdquBOnQ@mail.gmail.com>
Message-ID: <CAHk-=wg-az1yPKQmmDMnTMdUrg8hLzPUiUtUQu9d2EbdquBOnQ@mail.gmail.com>
Subject: Re: [GIT PULL] virtio,vhost,vdpa: features, fixes
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        almasrymina@google.com, alvaro.karsz@solid-run.com,
        anders.roxell@linaro.org, bagasdotme@gmail.com,
        bhelgaas@google.com, colin.i.king@gmail.com,
        dmitry.fomichev@wdc.com, elic@nvidia.com, eperezma@redhat.com,
        hch@lst.de, jasowang@redhat.com, kangjie.xu@linux.alibaba.com,
        leiyang@redhat.com, liming.wu@jaguarmicro.com,
        lingshan.zhu@intel.com, liubo03@inspur.com, lkft@linaro.org,
        mie@igel.co.jp, m.szyprowski@samsung.com,
        ricardo.canuelo@collabora.com, sammler@google.com,
        sebastien.boeuf@intel.com, sfr@canb.auug.org.au,
        si-wei.liu@oracle.com, stable@vger.kernel.org, stefanha@gmail.com,
        suwan.kim027@gmail.com, xuanzhuo@linux.alibaba.com,
        yangyingliang@huawei.com, zyytlz.wz@163.com
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

On Wed, Feb 22, 2023 at 11:06 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> Did I muck this one up?  Pls let me know and maybe I can fix it up
> before the merge window closes.

No much-ups, I've just been merging other things, and came back to
architectures updates and virtualization now, so it's next in my
queue.

           Linus
