Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDE7463F2C
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 21:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343667AbhK3U07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 15:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235402AbhK3U06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 15:26:58 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEBAC061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 12:23:39 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so19157657pjb.5
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 12:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8NDR0yS5itWLwMQdcFMzAMIrcAwRbstFRp+zcJupYCQ=;
        b=kw07Ilt3TfWovbf4YoY/b+YLBHrmelv8xlne3fk+/qeBFP9ZOx7MAndQeDEVviEuLi
         P8j4cYRoSy3jLt1rp7TlrbtugB9D2nv7LlpL0pWMLWHaMNaqdOIHwoyOLEQaRotjfh1p
         7GeGMBLZ0O1tz10eYsCMPSLia66RR2VXuhI64ls0IKSO9s7sCfT4PVrVMUPvgOAREXaL
         bMwh1X0Y1q4h5ZyXYpFO7nf1IQwRSgyadlmdgfjCy+yGxJs3szrrWcOQNGZnjvd6QOLS
         tQFLyqdmyHDO5FpVceU0gUWLNJ4tnJp5w9qJyAApsZ8sTH3nfNg3dveBKcEvuD7V/ich
         Zr/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8NDR0yS5itWLwMQdcFMzAMIrcAwRbstFRp+zcJupYCQ=;
        b=r52auuMAYcZLZox9BJ3GX5HAaWiBy4K4lvtCscmsRKy/wrS9UeXgIKh9bfjAUKELCY
         5hxc0xI/qX2MJfShMp8djG43sXykzFzTufEUtohuk80sKO4Ol1qyiONVZ6PHGNk7Umpk
         ZM5i4BsyX8MTwp1RoMd9Qqy8RVs/j7kNo90CONeKaft66yKZg3U7nfKb4Nm8DRZ6IBHl
         QqTInYGFK9m16OC1VmZSyytrvls/hzsgfsoOghAxNhzeQ7PWFIsfRNKIvNRbHqNjDklC
         a06Xf5MEjNXtbqLhvvRrKsHm3VBTqfXqxf1t8RTe/+n9noqZ3L4O2jDaHJAWcbdXfUdi
         aZWQ==
X-Gm-Message-State: AOAM531fzZ8B4ClRoF6UHiwiqwQjYdX4wjDUy1h8jdp7ei6HVUNRRxgq
        YAvWPDWjMi+rCj06RVJSQHZ33Q==
X-Google-Smtp-Source: ABdhPJyfhNir0edzU6VGggikB5es2NZVbK831kXfyVbrSliP9J+M8IFJ3gSEpPdJeMtU9sZ7XalgRg==
X-Received: by 2002:a17:902:7c8a:b0:143:bb4a:7bb3 with SMTP id y10-20020a1709027c8a00b00143bb4a7bb3mr1742790pll.46.1638303818679;
        Tue, 30 Nov 2021 12:23:38 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k18sm15427818pgb.70.2021.11.30.12.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 12:23:38 -0800 (PST)
Date:   Tue, 30 Nov 2021 20:23:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        stevensd@chromium.org, kernel-team <kernel-team@cloudflare.com>
Subject: Re: Potential bug in TDP MMU
Message-ID: <YaaIRv0n2E8F5YpX@google.com>
References: <CALrw=nEaWhpG1y7VNTGDFfF1RWbPvm5ka5xWxD-YWTS3U=r9Ng@mail.gmail.com>
 <d49e157a-5915-fbdc-8103-d7ba2621aea9@redhat.com>
 <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021, Ignat Korchagin wrote:
> I have managed to reliably reproduce the issue on a QEMU VM (on a host
> with nested virtualisation enabled). Here are the steps:
> 
> 1. Install gvisor as per
> https://gvisor.dev/docs/user_guide/install/#install-latest
> 2. Run
> $ for i in $(seq 1 100); do sudo runsc --platform=kvm --network=none
> do echo ok; done
> 
> I've tried to recompile the kernel with the above patch, but
> unfortunately it does fix the issue. I'm happy to try other
> patches/fixes queued for 5.16-rc4

My best guest would be https://lore.kernel.org/all/20211120045046.3940942-5-seanjc@google.com/,
that bug results in KVM installing SPTEs into an invalid root.  I think that could
lead to a use-after-free and/or double-free, which is usually what leads to the
"Bad page state" errors.

In the meantime, I'll try to repro.

> > > arch/x86/kvm/../../../virt/kvm/kvm_main.c:171

...

> > > After this the machine starts spitting some traces starting with:
> > >
> > > [177247.871683][T2343516] BUG: Bad page state in process <comm>  pfn:fe680a
