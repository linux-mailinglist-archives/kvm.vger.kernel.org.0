Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DF47A4D23
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 17:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjIRPqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 11:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjIRPqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 11:46:46 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116261987
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 08:44:36 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-76f2843260bso307615485a.3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 08:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695051600; x=1695656400; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Eh+ZB4w36LPHcXTuiksUrTP4emDdv3+Sn8dsj7IVUZI=;
        b=dtWa71snAW8VORs5paSZfH7cBUbWEjVXmwhELIS/mZwtpzFlReAnEI9odfvlzKDmvB
         x1t2V+cAlMW/+bLXJx3odh/VzWI6HaZhqrHidN36ay+ZcsB9KTV3KFnYFBmIlqcHyZ+j
         aokyqiPJZtRom63XlMJkljRyHkVqE8gplKgaZU2HDezv6GyqROKSfQHjIkipf9hSUxtQ
         yc+9Wmx/9e1T+j5p5Pbp9NeU6qloj/KXnK9zygig6EpYA4p6DRo2l5wco0eQUdhrjxOn
         C6dmd7FMI49vLP5UO4YAF9CjbctH6vUELqXHLc4WHlzj5hDKaHFnue949QUtPOUBVGKQ
         u77g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695051600; x=1695656400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eh+ZB4w36LPHcXTuiksUrTP4emDdv3+Sn8dsj7IVUZI=;
        b=Rc4vcSnFx01GSXFLgBGe2WU1t+XhUROrSr7nmggPxymnSMKyInhJhk0IDB3kW5mNmH
         rPN/hXBMx2WfwipimCLn02rDnrAtD6osN4H84ShxNfUYopC3hpatNrs/MotdHWj7QSlk
         NUYX/JwMyTCs0uW19YxqI0jwZVGusBoGN8szScjOePko5spGARQWI1q/skOHygGiHbtE
         rApQHl5QKnD4K9t/KE3Oq6DvvxXnAgBxqtOSy/dgNMSfscxCq9Y3wAVVo0CIThGhoRo1
         wo5ZxTabnJyow7v77/uNujLTFu4bvuoD8z8y1IiJJEbQch8Rcvg39FzZ3jsWthAlR2v6
         x+vA==
X-Gm-Message-State: AOJu0YyfzSu2BRbxlifo+UqniYyfJ5ITZj7g2e1sKfWwuxIR3UJC5gjM
        HJdEw1bG4kA6PluU/0R+FTO4Tw==
X-Google-Smtp-Source: AGHT+IEuKifL8xGSff+C16VFMKEATLnC98W0S4v46HrtO6Tv6jSzRD3UIvNwVTsEK+kNcvbvDj18FA==
X-Received: by 2002:a05:620a:404a:b0:76f:1272:2aa8 with SMTP id i10-20020a05620a404a00b0076f12722aa8mr12093902qko.6.1695051600054;
        Mon, 18 Sep 2023 08:40:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id o5-20020a05620a110500b00767f14f5856sm3214665qkk.117.2023.09.18.08.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 08:39:59 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qiGLu-0005c3-JC;
        Mon, 18 Sep 2023 12:39:58 -0300
Date:   Mon, 18 Sep 2023 12:39:58 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jinjie Ruan <ruanjinjie@huawei.com>
Cc:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [PATCH] vfio/mdev: Fix a null-ptr-deref bug for
 mdev_unregister_parent()
Message-ID: <20230918153958.GK13795@ziepe.ca>
References: <20230918115551.1423193-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918115551.1423193-1-ruanjinjie@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 07:55:51PM +0800, Jinjie Ruan wrote:
> Inject fault while probing mdpy.ko, if kstrdup() of create_dir() fails in
> kobject_add_internal() in kobject_init_and_add() in mdev_type_add()
> in parent_create_sysfs_files(), it will return 0 and probe successfully.
> And when rmmod mdpy.ko, the mdpy_dev_exit() will call
> mdev_unregister_parent(), the mdev_type_remove() may traverse uninitialized
> parent->types[i] in parent_remove_sysfs_files(), and it will cause
> below null-ptr-deref.
> 
> If mdev_type_add() fails, return the error code and kset_unregister()
> to fix the issue.
> 
>  general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
>  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
>  CPU: 2 PID: 10215 Comm: rmmod Tainted: G        W        N 6.6.0-rc2+ #20
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
>  RIP: 0010:__kobject_del+0x62/0x1c0
>  Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 51 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 28 48 8d 7d 10 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 24 01 00 00 48 8b 75 10 48 89 df 48 8d 6b 3c e8
>  RSP: 0018:ffff88810695fd30 EFLAGS: 00010202
>  RAX: dffffc0000000000 RBX: ffffffffa0270268 RCX: 0000000000000000
>  RDX: 0000000000000002 RSI: 0000000000000004 RDI: 0000000000000010
>  RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed10233a4ef1
>  R10: ffff888119d2778b R11: 0000000063666572 R12: 0000000000000000
>  R13: fffffbfff404e2d4 R14: dffffc0000000000 R15: ffffffffa0271660
>  FS:  00007fbc81981540(0000) GS:ffff888119d00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007fc14a142dc0 CR3: 0000000110a62003 CR4: 0000000000770ee0
>  DR0: ffffffff8fb0bce8 DR1: ffffffff8fb0bce9 DR2: ffffffff8fb0bcea
>  DR3: ffffffff8fb0bceb DR6: 00000000fffe0ff0 DR7: 0000000000000600
>  PKRU: 55555554
>  Call Trace:
>   <TASK>
>   ? die_addr+0x3d/0xa0
>   ? exc_general_protection+0x144/0x220
>   ? asm_exc_general_protection+0x22/0x30
>   ? __kobject_del+0x62/0x1c0
>   kobject_del+0x32/0x50
>   parent_remove_sysfs_files+0xd6/0x170 [mdev]
>   mdev_unregister_parent+0xfb/0x190 [mdev]
>   ? mdev_register_parent+0x270/0x270 [mdev]
>   ? find_module_all+0x9d/0xe0
>   mdpy_dev_exit+0x17/0x63 [mdpy]
>   __do_sys_delete_module.constprop.0+0x2fa/0x4b0
>   ? module_flags+0x300/0x300
>   ? __fput+0x4e7/0xa00
>   do_syscall_64+0x35/0x80
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
>  RIP: 0033:0x7fbc813221b7
>  Code: 73 01 c3 48 8b 0d d1 8c 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a1 8c 2c 00 f7 d8 64 89 01 48
>  RSP: 002b:00007ffe780e0648 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
>  RAX: ffffffffffffffda RBX: 00007ffe780e06a8 RCX: 00007fbc813221b7
>  RDX: 000000000000000a RSI: 0000000000000800 RDI: 000055e214df9b58
>  RBP: 000055e214df9af0 R08: 00007ffe780df5c1 R09: 0000000000000000
>  R10: 00007fbc8139ecc0 R11: 0000000000000206 R12: 00007ffe780e0870
>  R13: 00007ffe780e0ed0 R14: 000055e214df9260 R15: 000055e214df9af0
>   </TASK>
>  Modules linked in: mdpy(-) mdev vfio_iommu_type1 vfio [last unloaded: mdpy]
>  Dumping ftrace buffer:
>     (ftrace buffer empty)
>  ---[ end trace 0000000000000000 ]---
>  RIP: 0010:__kobject_del+0x62/0x1c0
>  Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 51 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 28 48 8d 7d 10 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 24 01 00 00 48 8b 75 10 48 89 df 48 8d 6b 3c e8
>  RSP: 0018:ffff88810695fd30 EFLAGS: 00010202
>  RAX: dffffc0000000000 RBX: ffffffffa0270268 RCX: 0000000000000000
>  RDX: 0000000000000002 RSI: 0000000000000004 RDI: 0000000000000010
>  RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed10233a4ef1
>  R10: ffff888119d2778b R11: 0000000063666572 R12: 0000000000000000
>  R13: fffffbfff404e2d4 R14: dffffc0000000000 R15: ffffffffa0271660
>  FS:  00007fbc81981540(0000) GS:ffff888119d00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007fc14a142dc0 CR3: 0000000110a62003 CR4: 0000000000770ee0
>  DR0: ffffffff8fb0bce8 DR1: ffffffff8fb0bce9 DR2: ffffffff8fb0bcea
>  DR3: ffffffff8fb0bceb DR6: 00000000fffe0ff0 DR7: 0000000000000600
>  PKRU: 55555554
>  Kernel panic - not syncing: Fatal exception
>  Dumping ftrace buffer:
>     (ftrace buffer empty)
>  Kernel Offset: disabled
>  Rebooting in 1 seconds..
> 
> Fixes: da44c340c4fe ("vfio/mdev: simplify mdev_type handling")
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> ---
>  drivers/vfio/mdev/mdev_sysfs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
