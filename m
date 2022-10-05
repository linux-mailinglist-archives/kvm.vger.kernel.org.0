Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B044E5F5AF2
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 22:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiJEUZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 16:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiJEUZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 16:25:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2017F27A
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 13:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665001515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=86WWmb1vJeLs9Ctv4ANh4WOz2rPIK6lvoWUYd8tv0OA=;
        b=AQrlhsW9bRNbW29xs8kFC/csk5e76rz1iftghepgoGvy/jbwZbWbzM6EWHXnmZ15Ue6Fva
        +QwMbIZkkTF0Aw8wMar1xhq9tPQbgw15/kXiGp4s/XhWcfUqiPZbsHGi4KTTWPBu67lU9S
        KS0Ia/0UJx7oelc0FHzSTWwkqG7q/qQ=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-300-w4SGPmYCPJKFUhmDBYP0NQ-1; Wed, 05 Oct 2022 16:25:14 -0400
X-MC-Unique: w4SGPmYCPJKFUhmDBYP0NQ-1
Received: by mail-io1-f72.google.com with SMTP id n23-20020a056602341700b00689fc6dbfd6so11653134ioz.8
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 13:25:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=86WWmb1vJeLs9Ctv4ANh4WOz2rPIK6lvoWUYd8tv0OA=;
        b=myB4yvNFw1x/XlLsNu3RmftMOJfTWR6S/RaPVWZjujzBzSp/xgWWw5Aykgqh0OaEED
         fdZM+bVS0sV7aDUyVkZENa5x1j2jGpvo5PajNDpSOt4tc7LVrG7dbOYHEQqqG0bg+PF3
         VfAlY/DzLRqtGYLHe/fyfWmXPe3QfaY4PibaaJDgeAFREY9tNW0Qn2TxLieuMETTM1z6
         tnEwhep8eBmC7XSeCrEZDAPvlJR330MKPx8RTQIXMcJNR+PDSSlsmlhVnyNFRu5e5ZUp
         me/COQDXb2q38RaKt8tKFl9V07mtgBZZtlzAb69oFNSmJJnX/ehVlE+KSOu3fXwhshHV
         LU5w==
X-Gm-Message-State: ACrzQf2FSL1uC5lhAmOT8HVn00gQS+ctN59jeYAoqpxmbEcUoK6XLpxa
        DJSqZW3EzlHgYvpjGvfWryF+YT3yV8bzzDkenk9q8f+gy7ravY/xeOfVMyNU7ZZYu/FssWvVKAa
        IxfPmdwH20xzN
X-Received: by 2002:a05:6638:1135:b0:362:bcba:6fff with SMTP id f21-20020a056638113500b00362bcba6fffmr707435jar.129.1665001513208;
        Wed, 05 Oct 2022 13:25:13 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5zMQ8nZBstQ8/VZUmu7G1LF5iy09Gr1MWJLuQFjO/chMV4an7kCrwy4dVvl9VBSVUH7mrGwg==
X-Received: by 2002:a05:6638:1135:b0:362:bcba:6fff with SMTP id f21-20020a056638113500b00362bcba6fffmr707427jar.129.1665001513003;
        Wed, 05 Oct 2022 13:25:13 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h14-20020a056602154e00b006a175fe334dsm7161320iow.1.2022.10.05.13.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 13:25:11 -0700 (PDT)
Date:   Wed, 5 Oct 2022 14:25:10 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the vfio tree
Message-ID: <20221005142510.199debc2.alex.williamson@redhat.com>
In-Reply-To: <20221004073151.2d4f778d@canb.auug.org.au>
References: <20221004073151.2d4f778d@canb.auug.org.au>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Oct 2022 07:31:51 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> In commit
> 
>   66c6b7dbbda3 ("drm/i915/gvt: fix a memory leak in intel_gvt_init_vgpu_types")
> 
> Fixes tag
> 
>   Fixes: c90d097ae144 ("drm/i915/gvt: define weight according to vGPU type")
> 
> has these problem(s):
> 
>   - Target SHA1 does not exist
> 
> Maybe you meant
> 
> Fixes: bc90d097ae14 ("drm/i915/gvt: define weight according to vGPU type")

Yes, I agree.  I've fixed this in my tree and forced the update to my
next branch.  Thanks!

Alex

