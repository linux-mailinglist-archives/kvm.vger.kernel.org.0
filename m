Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30677733D13
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 01:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbjFPX7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 19:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjFPX7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 19:59:39 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7013D30EA
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 16:59:38 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-653a5de0478so911537b3a.0
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 16:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686959978; x=1689551978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Tyi5NvBCdObx5n/3Re/Q/kvImIofGDhcRiJ1XSSKt8=;
        b=LBVfQ6qB8MRyGOFDthEwgb+mDi3yl+ygzebAfT0EvpCoMtwjIqMa9CpxIvATalnAaA
         TujQEdOfd7SUtpBm/VzaUSFtKVnyncjVURiBgIA78muqQ4PO12wzLbCTgo20DqKIBJyZ
         e8KU5aB1Jm6J+EylrZ6bk3mnqIQFoqUE1cD/bBlYFtPyia2BO4B/uNP/RHThlNgGLVlw
         hncimEFbCfQGkgQgd0y7S4ujRQ6lvso4gDdqwuCYwqzyr1dAHraqpbZFNM8j+4Sragv/
         XxHCeIJzD9lH0chNoFcTWPwUNR0+spAhgNeit1x+JyhJEKG/ltywOjZyK7yd96T0NIDW
         AciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686959978; x=1689551978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Tyi5NvBCdObx5n/3Re/Q/kvImIofGDhcRiJ1XSSKt8=;
        b=ZqnRVo2RSm9mvRaP2yjudSti/1tZXEBEA813dZS6S0n/wKqS+s1W1Tdjc57uMhtaYw
         z4MEvHVbMg5xKXB5skCrAAYSvKvCdnJL83LQp2YYRTEDUK1MxYEbNzSi11RqWYHNUgeI
         Uqe4quJkIe6Bm/100tWMN3IiyKUpkX5v2gOrdezT0m+desnW+rO9hs/+wiQnu/DMhQh8
         HPteRUGe+gg38bKbV4WaGuQ2k5KwNpIi0hvAh1B0DQ1DEP9dzA1NVwxXajEwHWm4PPVa
         lzVvKS9kfwgsaZ3dQ5sIDQk7kyc3N9YIADEnIecyCFdvcH6pTHjzENePCJtiTFziWKFB
         iW1A==
X-Gm-Message-State: AC+VfDxh3Ups8ZTfCD1EvdUK+ODswdEfZpTJ3bv/cW7S3gwBIjydkaSv
        6RMgAow9H/BaQ8dAWKMuPDCX+faj5sw=
X-Google-Smtp-Source: ACHHUZ7L8YlNjgZ81sYbrHSahdGE/awnFga/QkZVoxKfgeaO9m4lH+09VpPhX8qESaY34TUHJ2MHAE4PApE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:13a8:b0:64f:5406:d5a2 with SMTP id
 t40-20020a056a0013a800b0064f5406d5a2mr914557pfg.0.1686959977963; Fri, 16 Jun
 2023 16:59:37 -0700 (PDT)
Date:   Fri, 16 Jun 2023 16:59:36 -0700
In-Reply-To: <L2ZBWR.TERFR10NPZ281@effective-light.com>
Mime-Version: 1.0
References: <L2ZBWR.TERFR10NPZ281@effective-light.com>
Message-ID: <ZIz3aPL3K6ZagyJ2@google.com>
Subject: Re: KVM page-fault on Kernel 6.3.8
From:   Sean Christopherson <seanjc@google.com>
To:     Hamza Mahfooz <someguy@effective-light.com>
Cc:     kvm@vger.kernel.org, regressions@lists.linux.dev,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023, Hamza Mahfooz wrote:
> I am seeing the following page-fault on the latest stable kernel:

What makes you think this is KVM related?  I don't see anything KVM related in
the splat.  The !PRESENT #PF is coming from aio_read(), not from KVM.  The
?kvm_arch_vcpu_put line is just mispeculation from the unwinder.

> BUG: unable to handle page fault for address: ffffb4ff0cd20034
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 10002a067 P4D 10002a067 PUD 0
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 7 PID: 2675 Comm: CPU 7/KVM Not tainted 6.3.8-arch1-1 #1
> a1d299e746aebdb27c523dd3bd94aba6f54915c7
> Hardware name: ASUS System Product Name/ProArt X670E-CREATOR WIFI, BIOS 1303
> 04/27/2023
> RIP: 0010:try_grab_folio+0x14f/0x370
> Code: 83 f8 04 75 6f 44 89 ee 4c 89 e7 e8 6b bc 0b 00 84 c0 74 60 4c 8b 63
> 08 41 f6 c4 01 0f 85 b0 01 00 00 0f 1f 44 00 00 49 89 dc <41> 8b 44 24 34 85
> c0 0f 88 f8 00 00 00 41 8b 44 24 34 85 c0 74 58
> RSP: 0018:ffff9fa98504b948 EFLAGS: 00010086
> RAX: 0000000000000002 RBX: fffff4ff0cd21480 RCX: 0000000000000000
> RDX: 0000000000000003 RSI: 0000000000000001 RDI: fffff4ff0cd21480
> RBP: 0000000000000000 R08: ffff8b2edb510980 R09: 00007f5624253000
> R10: 80000003348008e7 R11: 00007f5624253000 R12: ffffb4ff0cd20000
> R13: 0000000000000001 R14: 0000000000000003 R15: 0000000000000001
> FS: 00007f548a7fc6c0(0000) GS:ffff8b35f83c0000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffb4ff0cd20034 CR3: 0000000113e70000 CR4: 0000000000750ee0
> PKRU: 55555554
> Call Trace:
> <TASK>
> ? __die+0x23/0x70
> ? page_fault_oops+0x171/0x4e0
> ? exc_page_fault+0x172/0x180
> ? asm_exc_page_fault+0x26/0x30
> ? try_grab_folio+0x14f/0x370
> internal_get_user_pages_fast+0x883/0x1150
> __iov_iter_get_pages_alloc+0xdd/0x780
> ? kmem_cache_alloc+0x16f/0x330
> ? bio_associate_blkg_from_css+0xcd/0x340
> iov_iter_get_pages+0x1d/0x40
> bio_iov_iter_get_pages+0xa1/0x480
> __blkdev_direct_IO_async+0xc5/0x1b0
> blkdev_read_iter+0x127/0x1d0
> aio_read+0x132/0x210
> ? io_submit_one+0x46a/0x8b0
> io_submit_one+0x46a/0x8b0
> ? kvm_arch_vcpu_put+0x128/0x190 [kvm
> 711ceda1c40511ce22d1f99f4e9e574def76b25e]
> ? kvm_arch_vcpu_ioctl_run+0x579/0x1770 [kvm
> 711ceda1c40511ce22d1f99f4e9e574def76b25e]
> __x64_sys_io_submit+0xad/0x190
> do_syscall_64+0x5d/0x90
> ? __x64_sys_ioctl+0xac/0xd0
> ? syscall_exit_to_user_mode+0x1b/0x40
> ? do_syscall_64+0x6c/0x90
> ? syscall_exit_to_user_mode+0x1b/0x40
> ? do_syscall_64+0x6c/0x90
> ? syscall_exit_to_user_mode+0x1b/0x40
> ? do_syscall_64+0x6c/0x90
> ? syscall_exit_to_user_mode+0x1b/0x40
> ? do_syscall_64+0x6c/0x90
> ? do_syscall_64+0x6c/0x90
> entry_SYSCALL_64_after_hwframe+0x72/0xdc
> RIP: 0033:0x7f57ac0912ed
> Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff
> 73 01 c3 48 8b 0d 3b 7a 0d 00 f7 d8 64 89 01 48
> RSP: 002b:00007f5427ab97b8 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
> RAX: ffffffffffffffda RBX: 00007f548a7fc1d0 RCX: 00007f57ac0912ed
> RDX: 00007f5427ab9800 RSI: 0000000000000001 RDI: 00007f57a9d24000
> RBP: 00007f57a9d24000 R08: 0000000000000001 R09: 0000000000000001
> R10: 00007f54740044f0 R11: 0000000000000246 R12: 0000000000000001
> R13: 0000000000000004 R14: 00007f5427ab9800 R15: 000000000000000e
