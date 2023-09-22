Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C397ABAF7
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 23:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjIVVS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 17:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjIVVS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 17:18:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED69C1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 14:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695417457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dwEv3veJ3icF19x/JnNZ7SXQKN10tq07tjnttgVdwog=;
        b=NM1GbREyvQP8J9tv+NtEh+kuo+Suobey6HpjKSoP9hJhSIm+Excs44xntez3/8fpPk1LNy
        Ec0CgQKCzBm+56NULCG/taqrhO2W1iGsJJ25VXRwE9MDv5CltZGVSkrELyXxRLHXyNH5yH
        Q61e48lrCEGAIDew83RB5JYbIHevTRU=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-2pbHCUiQPUyPquIxf8k6uQ-1; Fri, 22 Sep 2023 17:17:36 -0400
X-MC-Unique: 2pbHCUiQPUyPquIxf8k6uQ-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-79faa3551b5so51574339f.1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 14:17:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695417455; x=1696022255;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dwEv3veJ3icF19x/JnNZ7SXQKN10tq07tjnttgVdwog=;
        b=UgW6ytvMjFdw2nhkM1vNSGxf78E3WK6J3COgE8+WuvwMddJxZuYaEPPTRXsihJbElR
         X4o0uCIemNW9Ol2VECgbr3eTqZPVVIvfjxwIB5tP7A09qEMffEhJSxvl1TVCp890J5jL
         cxCHOVMcSE6EG9cbMPb4XYn/iA4n65n1ffC6JWDOuWjX4fZhDZ33ULTP+cyit8nOut+z
         yAREka9h60ycub4Gd53K9hPXyLE3L+GxlE6MUWII+hJpSncFelDMH/A90eiejvQ0LJ5x
         +fWz6dmbRntnayc+qcYborMo+jBvub2yB/9QkhCPAjtpkQJv6WOXlxtcB6fRdLp5RIW2
         jgvg==
X-Gm-Message-State: AOJu0Yz8LQu9NWt3iX/Axys0Si0tmjfQ1+JDSfybAEv4pUCDadk+8MRD
        CLxkjI7FkP7m6ex8CdKr3qlcSlD0hRnJcUCJ6z1OxNHphQRGV5QscNFf2SRXkqigQSbFdapXVwi
        yzUBcTBoxgENv
X-Received: by 2002:a05:6602:2542:b0:791:8f62:31ef with SMTP id cg2-20020a056602254200b007918f6231efmr771579iob.5.1695417455276;
        Fri, 22 Sep 2023 14:17:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMPtInmO2yKePn/1KCwGHM4IF35jakitSr5cH9mz/2KJ+XZ3hXUC+naxORe4rU4X18FSRL7w==
X-Received: by 2002:a05:6602:2542:b0:791:8f62:31ef with SMTP id cg2-20020a056602254200b007918f6231efmr771572iob.5.1695417455042;
        Fri, 22 Sep 2023 14:17:35 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id u7-20020a02cb87000000b0042b068d921esm1206872jap.16.2023.09.22.14.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 14:17:34 -0700 (PDT)
Date:   Fri, 22 Sep 2023 15:17:33 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jinjie Ruan <ruanjinjie@huawei.com>
Cc:     <kvm@vger.kernel.org>, Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] vfio/mdev: Fix a null-ptr-deref bug for
 mdev_unregister_parent()
Message-ID: <20230922151733.00227a5f.alex.williamson@redhat.com>
In-Reply-To: <20230918115551.1423193-1-ruanjinjie@huawei.com>
References: <20230918115551.1423193-1-ruanjinjie@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Sep 2023 19:55:51 +0800
Jinjie Ruan <ruanjinjie@huawei.com> wrote:

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
> 
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index e4490639d383..9d2738e10c0b 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -233,7 +233,8 @@ int parent_create_sysfs_files(struct mdev_parent *parent)
>  out_err:
>  	while (--i >= 0)
>  		mdev_type_remove(parent->types[i]);
> -	return 0;
> +	kset_unregister(parent->mdev_types_kset);
> +	return ret;
>  }
>  
>  static ssize_t remove_store(struct device *dev, struct device_attribute *attr,

Applied to vfio for-linus branch for v6.6.  Thanks,

Alex

