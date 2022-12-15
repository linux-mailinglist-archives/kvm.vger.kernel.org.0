Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B98D64E07E
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 19:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiLOSRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 13:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiLOSRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 13:17:18 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B9D186CB
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 10:17:17 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id 17so7782312pll.0
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 10:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=88f9DVitbVq2bSL1Gb4jiyhnqkfxN34fNcXoKj1mhJk=;
        b=JilFHUG4tHIgMJ6nnuK14Kvv+3VWtGVcTQVmA+UpPil409Eyzk4sTTWdDfVCosxq00
         HiVM8JbEZm0Dcu41Um4oJ13qIJ6ttBQL92Y1yJmjOhLstJ88EpEE3YQkSXNu4Hk+f0X5
         WHQNXMyQ0x2WRgxsZUbdnqSBOW+uxE8kNxWY4I6PBPu8DYku97KhWpuvzqeB3CYWKDp3
         KMnv5uwicmY/U1KHIFlF1IScXuiNnBpoxtjJWNo3VJSwZ/8nTNVcOYzM/1VAczd5PknS
         2V73dFvrDN79dRM//yjhSEu5s7mNUufFLidsxeix86W4FERHKldbBiYkD2xIVN7KOQSX
         ZNFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=88f9DVitbVq2bSL1Gb4jiyhnqkfxN34fNcXoKj1mhJk=;
        b=bzhKh1KOB3KYbWYD2pvKiO7c93xNH4UWFN+IQT7B4TDqcO32nsHYsHfpIDPrxwJPcI
         sa67DTkx4ElL29HARnyaJbMDxJkV8gdIGpyi/LYOMZiJgUGZbVGd07G0q7Qpm0Mb7Tsa
         Ws5sI/nVT2mtit8CXiI8sfHQmA4VCJLm2tbfRST+GHOrr59j/8wsbrsCWykM+QPsDwYK
         td+YkUh5qet7wBI2UgDAfhRC825pe43l+RZcPKbaFOU2smjqGYFg6q+hRilr8s9A98N0
         fTmGItYYuuWU+xiOOOt23V1CBeQU6fgzKNhLal0100UyZqohXDE/3VSBMq/prwpFUV1Z
         pE/g==
X-Gm-Message-State: AFqh2ko/APJjyXmD7xW5vTHRigbrVZOPIzT0Dmgz+IKtxDKfa2X8hDUf
        6+R9r8tZ47ruXku2YDKhXi5B9KObIBeH7AIk
X-Google-Smtp-Source: AMrXdXsIGci9sFaU8qvP3hF9lonTh3NsSBmYgcoGKx9/Cp7a2ydbhusN9p8b32SgqalLqexv3Lpbuw==
X-Received: by 2002:a17:902:b493:b0:189:58a8:282 with SMTP id y19-20020a170902b49300b0018958a80282mr140520plr.3.1671128236345;
        Thu, 15 Dec 2022 10:17:16 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x24-20020a1709027c1800b0018982bf03b4sm4146677pll.117.2022.12.15.10.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 10:17:15 -0800 (PST)
Date:   Thu, 15 Dec 2022 18:17:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     =?utf-8?B?5p+z6I+B5bOw?= <liujingfeng@qianxin.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
Subject: Re: Found a memory leak in kvm module
Message-ID: <Y5tkpxOiDoF0X/On@google.com>
References: <7144ff750e554ad28aaa59e98c36d4fc@qianxin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7144ff750e554ad28aaa59e98c36d4fc@qianxin.com>
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

On Mon, Dec 12, 2022, 柳菁峰 wrote:
> Hello,I have found a memory leak bug in kvm module by syzkaller.It was found
> in linux-5.4 but it also could be reproduced in the latest linux version.

Ah, I assume by "linux-5.4" you mean "stable v5.4.x kernels that contain commit
7d1bc32d6477 ("KVM: Stop looking for coalesced MMIO zones if the bus is destroyed")",
because without that fix I can't see any bug that would affect both 5.4 and the
upstream kernel.

If my assumption is correct, then I'm 99% certain the issue is that the target
device isn't destroyed if allocating the new bus fails.  I haven't had luck with
the automatic fault injection, but was able to confirm a leak with this hack.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 13e88297f999..22d9ab1b5c25 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5424,7 +5424,7 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
                              struct kvm_io_device *dev)
 {
        int i, j;
-       struct kvm_io_bus *new_bus, *bus;
+       struct kvm_io_bus *new_bus = NULL, *bus;
 
        lockdep_assert_held(&kvm->slots_lock);
 
@@ -5441,6 +5441,7 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
        if (i == bus->dev_count)
                return 0;
 
+       if (!IS_ENABLED(CONFIG_X86_64))
        new_bus = kmalloc(struct_size(bus, range, bus->dev_count - 1),
                          GFP_KERNEL_ACCOUNT);
        if (new_bus) {


The fix is to destroy the target device before bailing.  I'll send a proper patch
either way, but it would be nice to get confirmation that this is the same bug
that you hit with "linux-5.4".

Thanks!

---
 virt/kvm/coalesced_mmio.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 0be80c213f7f..5ef88f5a0864 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -187,15 +187,17 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
 			r = kvm_io_bus_unregister_dev(kvm,
 				zone->pio ? KVM_PIO_BUS : KVM_MMIO_BUS, &dev->dev);
 
+			kvm_iodevice_destructor(&dev->dev);
+
 			/*
 			 * On failure, unregister destroys all devices on the
 			 * bus _except_ the target device, i.e. coalesced_zones
-			 * has been modified.  No need to restart the walk as
-			 * there aren't any zones left.
+			 * has been modified.  Bail after destroying the target
+			 * device, there's no need to restart the walk as there
+			 * aren't any zones left.
 			 */
 			if (r)
 				break;
-			kvm_iodevice_destructor(&dev->dev);
 		}
 	}
 

base-commit: 0f30b25edea48433eb32448990557364436818e6
-- 

