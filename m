Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4D2678BC0
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 00:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbjAWXGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 18:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjAWXGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 18:06:06 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09843195
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 15:06:05 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id be8so113616plb.7
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 15:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q2M3C5F20YkdLffnn0NsMls+J4x21zjwqlbdKMUf+ww=;
        b=snbDYrbPTgq4JZ2v0/Vvdfm5LNODzF45JVPrYghYQJmKHuTJkuWDwCAMqPIONbEbPu
         NWowItQLsaY9xv7fRjI3g88emXsdQ4Ru1h036g0OlLVwMWdefS/ygPob9O5cdPkC95Us
         CkSiNKo72lhMHGo0y4dNGVCNNDQahgW0VUzcLJlxsF2dQHcaQQmL1KyUu49TJA3U2joQ
         blQnQiGmxnTf4ApLbdpCw5wsIp41TTYR8dtK15Zv/2nJIsbLjiJ7jWS0g1pMTQg7LjP5
         LQdZKYvyPe/1R4WLE27urO28HJR6PYXAKlgF3CQ+rsE8Uo3oYm48Ru14m86a8triGlZn
         PvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q2M3C5F20YkdLffnn0NsMls+J4x21zjwqlbdKMUf+ww=;
        b=hniHWp+PpIXcRuXLDdQ3C1wXBsjmr31wKP4OLkv9D+SqAZf9O6B3L5bfRl8/Do7OOt
         SVk4NroK/9EP/QcX877Rb078IExy4xYUXS/yig9t2Uw7Y8JqFjz8vC3m4In9MSNi8HyU
         vrAUC4B1fkWStt936xcnZKAhoEeed85UF0JpuiwUW5RNNagpU/bdo9EV9MdtsTx6YG+f
         dMZy3xtwWdhCOLFmLIg+2IVCemylUhWHb1SGrEmwu0/oo2YQxo9khEgTtAC/xbPpuZt0
         gzyHAXi0wkw6Q5CiUtDLflURn51u1CeiiRHiXKYUEXDMwQR4dYILLGaV0uGZkxkPsHcv
         lURA==
X-Gm-Message-State: AFqh2kp8Pua8eD/Mb7sWaqmfHF7pn/FMXbexy5CrfhWWR8DLvAGhWfCJ
        oGNYaGSltFD3sVc4VVfYhsOsVdYgIuNUqWsn0To=
X-Google-Smtp-Source: AMrXdXvZX5Y0LCSO6/A2DGeqeEfe7Jk6ID2hixMnN6oPNfvuWK1zkIAzr1+l9MZ/ysBMSc6+V8pZPQ==
X-Received: by 2002:a17:90a:17ca:b0:227:679:17df with SMTP id q68-20020a17090a17ca00b00227067917dfmr763556pja.0.1674515164299;
        Mon, 23 Jan 2023 15:06:04 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 37-20020a17090a09a800b0022be311523dsm156088pjo.35.2023.01.23.15.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 15:06:03 -0800 (PST)
Date:   Mon, 23 Jan 2023 23:06:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] Revert "KVM: mmio: Fix use-after-free Read in
 kvm_vm_ioctl_unregister_coalesced_mmio"
Message-ID: <Y88S2F2laAvqmj+E@google.com>
References: <20230118220003.1239032-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118220003.1239032-1-mhal@rbox.co>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023, Michal Luczaj wrote:
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
>  virt/kvm/coalesced_mmio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> index 0be80c213f7f..f08f5e82460b 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -186,6 +186,7 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
>  		    coalesced_mmio_in_range(dev, zone->addr, zone->size)) {
>  			r = kvm_io_bus_unregister_dev(kvm,
>  				zone->pio ? KVM_PIO_BUS : KVM_MMIO_BUS, &dev->dev);
> +			kvm_iodevice_destructor(&dev->dev);
>  
>  			/*
>  			 * On failure, unregister destroys all devices on the
> @@ -195,7 +196,6 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
>  			 */
>  			if (r)
>  				break;
> -			kvm_iodevice_destructor(&dev->dev);

Already posted[1], but didn't get queued because there's alternative solution[2]
that yields a far cleaner end result, albeit with a larger patch.  I'll follow
up on Wei's patch to move things along.

[1] https://lore.kernel.org/all/20221219171924.67989-1-seanjc@google.com
[2] https://lore.kernel.org/all/20221229123302.4083-1-wei.w.wang@intel.com
