Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC626478B7
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 23:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiLHWRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 17:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiLHWRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 17:17:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B821879C19
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 14:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670537770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zLNGt7T3Qd5+PRXwiloaMTpltalrMaHUGdJwLTk8C20=;
        b=SM0UwB0A4ZjT48tKQyE0/qOQvrykNMalr+LKYwox1ucLzlhT52DvUS5WIQL9dvdeNzPnKu
        mXTR3chQ7r1ohoU3+q0q8T3qALiultrYFPnswa3aQVFpxmXm+9tzSSi6KpFQeIqzGwThnz
        BX4FRhzR6MW2EuPx0feWxQmH0umgbJI=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-280-cYL8CbtpPayozdn5eE5ReQ-1; Thu, 08 Dec 2022 17:16:08 -0500
X-MC-Unique: cYL8CbtpPayozdn5eE5ReQ-1
Received: by mail-il1-f198.google.com with SMTP id h10-20020a056e021b8a00b00302671bb5fdso2475457ili.21
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 14:16:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zLNGt7T3Qd5+PRXwiloaMTpltalrMaHUGdJwLTk8C20=;
        b=nl23kUmZmtllERdhFcPlWpZE5V5LSJ0z/yNrFbLih45Y7Np/tHZY6aqB2cIzU23c8Y
         JbjU7IQjmQuQfw4f+uA5aFdozTv0nxmBqRap04Zs8DoOCGt8JWQBhr+l0EeMknMu5f1Z
         8pQs8EQWthaiJXVRyuFTcEov5wdsA7Qg2HGP6MH6inNpR4RAqh19fO54Pful5RKQglBk
         2mexX2BBH7q4qTj6C1RW9sLUGaL/XSVl+fKiZsqQF0nHPHeLtNoUROhCgkNFAYj5juBS
         0ltiwFQ0U9ZUJTnju4ow/m2bsa+uF26N977gmCIbuWPLlNHF8+3WE8haHBBOkoM6OxQN
         njWw==
X-Gm-Message-State: ANoB5pkKw5QA5wXoaJjAux7EPWljvjk9gGNFhm5eRO8aBHO2bQIisQib
        MtPWoFtiEWDepAJF1Xm7Fpy8oYkiv56NUCqMmMybp3/B7+ZDyeno5s4Vp/ZyPuLM2IpUkyCliw9
        n18jGzc9JzNFF
X-Received: by 2002:a02:6d17:0:b0:374:fa5b:6005 with SMTP id m23-20020a026d17000000b00374fa5b6005mr34078451jac.2.1670537767833;
        Thu, 08 Dec 2022 14:16:07 -0800 (PST)
X-Google-Smtp-Source: AA0mqf50hMGg5TntrZciF2eLTQZfspwdA5qvSg0CZVKgFwomHBS+qnSnF6qpBwR00pNJKHivYuNsHg==
X-Received: by 2002:a02:6d17:0:b0:374:fa5b:6005 with SMTP id m23-20020a026d17000000b00374fa5b6005mr34078448jac.2.1670537767622;
        Thu, 08 Dec 2022 14:16:07 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q24-20020a02c8d8000000b0038a40e0388esm5076029jao.125.2022.12.08.14.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 14:16:07 -0800 (PST)
Date:   Thu, 8 Dec 2022 15:16:06 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     <kwankhede@nvidia.com>, <kraxel@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] samples: vfio-mdev: Fix missing pci_disable_device()
 in mdpy_fb_probe()
Message-ID: <20221208151606.16ae8bc7.alex.williamson@redhat.com>
In-Reply-To: <20221208013341.3999-1-shangxiaojing@huawei.com>
References: <20221208013341.3999-1-shangxiaojing@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 8 Dec 2022 09:33:41 +0800
Shang XiaoJing <shangxiaojing@huawei.com> wrote:

> Add missing pci_disable_device() in fail path of mdpy_fb_probe().
> Besides, fix missing release functions in mdpy_fb_remove().
> 
> Fixes: cacade1946a4 ("sample: vfio mdev display - guest driver")
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
> changes in v2:
> - Add missing functions in mdpy_fb_remove().
> ---
>  samples/vfio-mdev/mdpy-fb.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Applied to vfio next branch for v6.2.  Thanks,

Alex

