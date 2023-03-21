Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B36D6C38B5
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 18:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjCUR4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 13:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbjCURzz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 13:55:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0D2515FC
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 10:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679421304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6OO5ZIxJDvOympMMqka+XvitUlu/HzW9BC/npWTX1zg=;
        b=eN1uR2+4YKxvJL1m89Tm/sgvxCyl/I0XytRgaiJPN6CQzFrDgIn//qCoPZgN99JvlWAL7m
        Nk16K3HcX4EUAKaV62lGkwlZDaT7usIXjtChfg5WsYDODvIcQM8qtnOFdAN+SdeHnjf4/F
        IHGxYnmA/eU38p3mhqqzqnLWNFm5Zqw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-6Zas8NflPfSSKXoaMlTGPA-1; Tue, 21 Mar 2023 13:55:01 -0400
X-MC-Unique: 6Zas8NflPfSSKXoaMlTGPA-1
Received: by mail-wm1-f69.google.com with SMTP id ay12-20020a05600c1e0c00b003ed201dcf71so7460742wmb.4
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 10:55:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679421300;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6OO5ZIxJDvOympMMqka+XvitUlu/HzW9BC/npWTX1zg=;
        b=XM84xuGbRujxlp61xa+YVQh1aiNHnEImM/uoeUIx0csZ/r8K5wp6xLYxwswwHricBS
         o5dkUDhR6Zwa1Tc3JVZQL96Ihg3Dhrwia6OdOjUi0XJico2vUjpI058B7OrMnE61btUf
         Jn6Vl+zuOU8B3GCKIXQXYVHjgYy0g4qtutfG221x6sNFnO+oFVM/gh5+BV4DlIGN5+vf
         B1WYkJXIYeS7ZlYky82WpBV3oOE36GZvCPSnu7/nY21u5PyoC+ZoAsyvMnNWc1XhbuY8
         7f0bEau82EJ3qmAywn0UIsQOdB+bbsB0kSsRrvAnRpoqzYRm+ZSz2ivl2yiMDtEqf3di
         jeaA==
X-Gm-Message-State: AO0yUKUrVVJ13zyXqmPfOGWI1LBXShpa/SoC3fJEOO8G9xHLoYGje1l5
        +P+kSjpA78h3W+vFTwBhbrrFLQ7CwGJDSHhVSnlO5BK2CWZdqDF6dn56nd1U4/iDRT5P7UldfwP
        LPzN8hiIL0l19
X-Received: by 2002:a05:600c:2148:b0:3ed:de58:1559 with SMTP id v8-20020a05600c214800b003edde581559mr3453845wml.2.1679421300512;
        Tue, 21 Mar 2023 10:55:00 -0700 (PDT)
X-Google-Smtp-Source: AK7set9RelBID8PX2Oo4YRgLh3yCs4x5rXDJQ5I40J+dfydiTGBSMryWryZAvLCGcoPwCihyPe5BdA==
X-Received: by 2002:a05:600c:2148:b0:3ed:de58:1559 with SMTP id v8-20020a05600c214800b003edde581559mr3453827wml.2.1679421300186;
        Tue, 21 Mar 2023 10:55:00 -0700 (PDT)
Received: from redhat.com ([2.52.1.105])
        by smtp.gmail.com with ESMTPSA id y16-20020a056000109000b002c56013c07fsm11771399wrw.109.2023.03.21.10.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 10:54:59 -0700 (PDT)
Date:   Tue, 21 Mar 2023 13:54:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     syzbot <syzbot+6b27b2d2aba1c80cc13b@syzkaller.appspotmail.com>,
        brauner@kernel.org, jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [syzbot] [kernel?] general protection fault in vhost_task_start
Message-ID: <20230321135427-mutt-send-email-mst@kernel.org>
References: <0000000000005a60a305f76c07dc@google.com>
 <2d976892-9914-5de0-62e0-c75f1c148259@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d976892-9914-5de0-62e0-c75f1c148259@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 12:46:04PM -0500, Mike Christie wrote:
> On 3/21/23 12:03 PM, syzbot wrote:
> > RIP: 0010:vhost_task_start+0x22/0x40 kernel/vhost_task.c:115
> > Code: 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 53 48 89 fb e8 c3 67 2c 00 48 8d 7b 70 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 0a 48 8b 7b 70 5b e9 fe bd 02 00 e8 79 ec 7e 00 eb
> > RSP: 0018:ffffc90003a9fc38 EFLAGS: 00010207
> > RAX: dffffc0000000000 RBX: fffffffffffffff4 RCX: 0000000000000000
> > RDX: 000000000000000c RSI: ffffffff81564c8d RDI: 0000000000000064
> > RBP: ffff88802b21dd40 R08: 0000000000000100 R09: ffffffff8c917cf3
> > R10: 00000000fffffff4 R11: 0000000000000000 R12: fffffffffffffff4
> > R13: ffff888075d000b0 R14: ffff888075d00000 R15: ffff888075d00008
> > FS:  0000555556247300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007ffe3d8e5ff8 CR3: 00000000215d4000 CR4: 00000000003506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  vhost_worker_create drivers/vhost/vhost.c:580 [inline]
> 
> The return value from vhost_task_create is incorrect if the kzalloc fails.
> 
> Christian, here is a fix for what's in your tree. Do you want me to submit
> a follow up patch like this or a replacement patch for:
> 
> commit 77feab3c4156 ("vhost_task: Allow vhost layer to use copy_process")
> 
> with the fix rolled into it?
> 



> 
> >From 0677ad6d77722f301ca35e8e0f8fd0cbd5ed8484 Mon Sep 17 00:00:00 2001
> From: Mike Christie <michael.christie@oracle.com>
> Date: Tue, 21 Mar 2023 12:39:39 -0500
> Subject: [PATCH] vhost_task: Fix vhost_task_create return value
> 
> vhost_task_create is supposed to return the vhost_task or NULL on
> failure. This fixes it to return the correct value when the allocation
> of the struct fails.
> ---
>  kernel/vhost_task.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
> index 4b8aff160640..b7cbd66f889e 100644
> --- a/kernel/vhost_task.c
> +++ b/kernel/vhost_task.c
> @@ -88,7 +88,7 @@ struct vhost_task *vhost_task_create(int (*fn)(void *), void *arg,
>  
>  	vtsk = kzalloc(sizeof(*vtsk), GFP_KERNEL);
>  	if (!vtsk)
> -		return ERR_PTR(-ENOMEM);
> +		return NULL;
>  	init_completion(&vtsk->exited);
>  	vtsk->data = arg;
>  	vtsk->fn = fn;
> 

