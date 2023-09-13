Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA6179F0A4
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 19:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjIMRvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 13:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbjIMRvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 13:51:23 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D0319AE
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 10:51:18 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-400a087b0bfso593325e9.2
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 10:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694627477; x=1695232277; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IL+p0DO0IUZqRFcgqHBd4klJrZRjlDQpNVieZFDn44o=;
        b=RJMnfZ4MHlhiUVwORpKd89HtWnDSV9uWO8TN/eA2KQ+rrtduw/3OOAbcPzrLPUT/sa
         DRnhUZxRGv5Lj5mw262AH4UpMjyjz9y8WZTf7KvdBlD5HtW7bZyx2n9YtSA59djxfkZ8
         B8PqkHpJzgUvQoU3BPJowYKBAytvXuBf75W8MSy432ifEcg+fpO+LT+rApyiIYXozxeW
         V2qeFW0btFxdtsVsz/uYp+SWNzJCp4YFKK9YJs8WTGB/ViWu65yQKhVceTLDceP4fI4/
         LyMj9xk/bhD5tiZt3hWoTbz1ZFx0SngwGRSo0GV9/nF9abH1mxXr9UR7UpWQHpkk/EAv
         qgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694627477; x=1695232277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IL+p0DO0IUZqRFcgqHBd4klJrZRjlDQpNVieZFDn44o=;
        b=PNOzb6CvJKksr4brPsm3mge0SjUvQ+A+aGChR6p5SNDtRAqMEkRtvqjnk7SzEo4kAa
         Txb1uGSLCCni48RWDP8ouUTMIcZekszxpxjU+qXcg/RynLuge8Al+/DePw8Zh8s6x7dg
         QAQpTIEkFQ6JmRbNPrxaHGVfiZYs5eeQYyJlx2jV938BItaFShDQoT1P59K/IxO5YYAm
         4j4MW1BZI+Nok9cdQ6C3TpU85h+3HwY4Z2AYiNYsjPO7uTDDFSnxUsx6UzO24a6tKJap
         0z0nBQaHuolzRwwENCsv1x/p7MnjOFFrzKyIVecqa4xjTERwG5g6Xjh6NZk0PnmSypgW
         vwAw==
X-Gm-Message-State: AOJu0Yw+ZJgHLRjbbR0BLH+TxgdbSI7EMJ3uGcN0JOb4qtwfJ9AhvN7r
        ak6/zBSRyfX6mXyTyjY1kdZoGg==
X-Google-Smtp-Source: AGHT+IHsDrYYksJsH+fsMamDPEcPXK3kNmBj+8dhjNSjsHFaW/Mu1D4ub/xql4tlOhysvrRnlUQskA==
X-Received: by 2002:a05:600c:2294:b0:403:149:150b with SMTP id 20-20020a05600c229400b004030149150bmr2514123wmf.16.1694627477264;
        Wed, 13 Sep 2023 10:51:17 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id 24-20020a05600c021800b003fee53feab5sm2667837wmi.10.2023.09.13.10.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 10:51:16 -0700 (PDT)
Date:   Wed, 13 Sep 2023 20:51:14 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     jgg@ziepe.ca, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shannon.nelson@amd.com
Subject: Re: [PATCH vfio] pds/vfio: Fix possible sleep while in atomic context
Message-ID: <8fdf4fe3-dd68-4b60-87f3-2607aaa2279c@kadam.mountain>
References: <20230913174238.72205-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230913174238.72205-1-brett.creeley@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 13, 2023 at 10:42:38AM -0700, Brett Creeley wrote:
> The driver could possibly sleep while in atomic context resulting
> in the following call trace while CONFIG_DEBUG_ATOMIC_SLEEP=y is
> set:
> 
> [  675.116953] BUG: spinlock bad magic on CPU#2, bash/2481
> [  675.116966]  lock: 0xffff8d6052a88f50, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> [  675.116978] CPU: 2 PID: 2481 Comm: bash Tainted: G S                 6.6.0-rc1-next-20230911 #1
> [  675.116986] Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 01/23/2021
> [  675.116991] Call Trace:
> [  675.116997]  <TASK>
> [  675.117002]  dump_stack_lvl+0x36/0x50
> [  675.117014]  do_raw_spin_lock+0x79/0xc0
> [  675.117032]  pds_vfio_reset+0x1d/0x60 [pds_vfio_pci]
> [  675.117049]  pci_reset_function+0x4b/0x70
> [  675.117061]  reset_store+0x5b/0xa0
> [  675.117074]  kernfs_fop_write_iter+0x137/0x1d0
> [  675.117087]  vfs_write+0x2de/0x410
> [  675.117101]  ksys_write+0x5d/0xd0
> [  675.117111]  do_syscall_64+0x3b/0x90
> [  675.117122]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> [  675.117135] RIP: 0033:0x7f9ebbd1fa28
> [  675.117141] Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 15 4d 2a 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89 d4 55
> [  675.117148] RSP: 002b:00007ffdff410728 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> [  675.117156] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f9ebbd1fa28
> [  675.117161] RDX: 0000000000000002 RSI: 000055ffc5fdf7c0 RDI: 0000000000000001
> [  675.117166] RBP: 000055ffc5fdf7c0 R08: 000000000000000a R09: 00007f9ebbd7fae0
> [  675.117170] R10: 000000000000000a R11: 0000000000000246 R12: 00007f9ebbfc06e0
> [  675.117174] R13: 0000000000000002 R14: 00007f9ebbfbb860 R15: 0000000000000002
> [  675.117180]  </TASK>

This splat doesn't match the sleeping in atomic bug at all.  That
warning should have said, "BUG: sleeping function called from invalid
context" and the stack trace would have looked totally different.

I don't have a problem with the patch itself, that seems reasonable.  I
really like that you tested it but you're running into a different
bug here.  Hopefully, you just pasted the wrong splat but otherwise we
need to investigate this other "bad magic" bug.

regards,
dan carpenter

