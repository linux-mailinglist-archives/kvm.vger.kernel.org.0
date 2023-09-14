Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02E87A1113
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 00:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjINWjg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 18:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbjINWje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 18:39:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80A8F26B7
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 15:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694731123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5/WrEVjfjSwdJNwSlik82zFzILkAP+oUFVhbFFfiy6c=;
        b=BbquWT2+G5QwvavxToK0asZlIJTWnYj6InkE91X3clbxEzoTdIE7MNUsRqVlbbbeh7oT/4
        pAXuokbfATMCtJSs5pt1Y7xLKxDf/GKwmtSu/0+gLp20h320y5jNTVYsLehJwW22a+Jjxy
        74xNSysFI4ju6rHVIHZF6SNnLN1ocqE=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-joyb8MZ4N0mgc-GajsCY-g-1; Thu, 14 Sep 2023 18:38:42 -0400
X-MC-Unique: joyb8MZ4N0mgc-GajsCY-g-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1c0cfc2b995so13086225ad.2
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 15:38:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694731121; x=1695335921;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5/WrEVjfjSwdJNwSlik82zFzILkAP+oUFVhbFFfiy6c=;
        b=Nb9HsluJ9M6pZAPQZgUaaeDuHsVf5mzy+u/+H3xMHuCGqO+f2TqrL3Xqto0ZzIEofu
         +W1Eyeg+WocLzFp81PAZuGOLx4HvxMYm3VJA/lv8imHqT1aHUA8PcZmD0qBHXED5jBVE
         gKC59wtvxDCPL+ZLyKepNIb3zVFvUNoU5ClSr3/DdKPLcyCncxDwpA1seHDJVpXL+LDk
         oBINoOYPB9iqan9Kb+Si6Bc9jgaUxy4V+HVZ7/woAir4IgCNnYf+PTCCay1KI2sJ3ZcL
         q1q+lcgaOVLMneCLPQy23PzoG+vdZmz1tWo6ILVgCx2s1RwmFAu0JlZdW6lYvNaDywYT
         Ik6w==
X-Gm-Message-State: AOJu0Yx+tCIjwgJ7NbXeP6BW7tEv2ucB4NkV8YY0sRRD+FlJHanDwhoT
        kfvBrb2X+v8K4KgvjCsIDb0uSvLCkeVQBop29EL0ehukuKt6vyc8DCtIAVlIJaPlzoR+1lnYbI4
        TA7r8HUxBJeVA
X-Received: by 2002:a17:903:1208:b0:1c3:6251:a78 with SMTP id l8-20020a170903120800b001c362510a78mr8326004plh.3.1694731121386;
        Thu, 14 Sep 2023 15:38:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYHCqmGHhKtQb9yUP9PNUufE2M+KE/qgFTM6URRSeU9mW46+RqJ1Kg8bD5JrkwK/foNINY3A==
X-Received: by 2002:a17:903:1208:b0:1c3:6251:a78 with SMTP id l8-20020a170903120800b001c362510a78mr8325991plh.3.1694731121058;
        Thu, 14 Sep 2023 15:38:41 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id f3-20020a17090274c300b001bdccf6b8c9sm2076014plt.127.2023.09.14.15.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 15:38:40 -0700 (PDT)
Date:   Thu, 14 Sep 2023 16:38:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     <jgg@ziepe.ca>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <dan.carpenter@linaro.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <shannon.nelson@amd.com>
Subject: Re: [PATCH vfio 3/3] pds/vfio: Fix possible sleep while in atomic
 context
Message-ID: <20230914163837.07607d8a.alex.williamson@redhat.com>
In-Reply-To: <20230914191540.54946-4-brett.creeley@amd.com>
References: <20230914191540.54946-1-brett.creeley@amd.com>
        <20230914191540.54946-4-brett.creeley@amd.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Sep 2023 12:15:40 -0700
Brett Creeley <brett.creeley@amd.com> wrote:

> The driver could possibly sleep while in atomic context resulting
> in the following call trace while CONFIG_DEBUG_ATOMIC_SLEEP=y is
> set:
> 
> [  227.229806] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:283
> [  227.229818] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 2817, name: bash
> [  227.229824] preempt_count: 1, expected: 0
> [  227.229827] RCU nest depth: 0, expected: 0
> [  227.229832] CPU: 5 PID: 2817 Comm: bash Tainted: G S         OE      6.6.0-rc1-next-20230911 #1
> [  227.229839] Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 01/23/2021
> [  227.229843] Call Trace:
> [  227.229848]  <TASK>
> [  227.229853]  dump_stack_lvl+0x36/0x50
> [  227.229865]  __might_resched+0x123/0x170
> [  227.229877]  mutex_lock+0x1e/0x50
> [  227.229891]  pds_vfio_put_lm_file+0x1e/0xa0 [pds_vfio_pci]
> [  227.229909]  pds_vfio_put_save_file+0x19/0x30 [pds_vfio_pci]
> [  227.229923]  pds_vfio_state_mutex_unlock+0x2e/0x80 [pds_vfio_pci]
> [  227.229937]  pci_reset_function+0x4b/0x70
> [  227.229948]  reset_store+0x5b/0xa0
> [  227.229959]  kernfs_fop_write_iter+0x137/0x1d0
> [  227.229972]  vfs_write+0x2de/0x410
> [  227.229986]  ksys_write+0x5d/0xd0
> [  227.229996]  do_syscall_64+0x3b/0x90
> [  227.230004]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> [  227.230017] RIP: 0033:0x7fb202b1fa28
> [  227.230023] Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 15 4d 2a 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89 d4 55
> [  227.230028] RSP: 002b:00007fff6915fbd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> [  227.230036] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fb202b1fa28
> [  227.230040] RDX: 0000000000000002 RSI: 000055f3834d5aa0 RDI: 0000000000000001
> [  227.230044] RBP: 000055f3834d5aa0 R08: 000000000000000a R09: 00007fb202b7fae0
> [  227.230047] R10: 000000000000000a R11: 0000000000000246 R12: 00007fb202dc06e0
> [  227.230050] R13: 0000000000000002 R14: 00007fb202dbb860 R15: 0000000000000002
> [  227.230056]  </TASK>
> 
> This can happen if pds_vfio_put_restore_file() and/or
> pds_vfio_put_save_file() grab the mutex_lock(&lm_file->lock)
> while the spin_lock(&pds_vfio->reset_lock) is held, which can
> happen during while calling pds_vfio_state_mutex_unlock().
> 
> Fix this by releasing the spin_unlock(&pds_vfio->reset_lock) before
> calling pds_vfio_put_restore_file() and pds_vfio_put_save_file() and
> re-acquiring spin_lock(&pds_vfio->reset_lock) after the previously
> mentioned functions are called to protect setting the subsequent
> state/deferred reset settings.
> 
> The only possible concerns are other threads that may call
> pds_vfio_put_restore_file() and/or pds_vfio_put_save_file(). However,
> those paths are already protected by the state mutex_lock().

Is there another viable solution to change reset_lock to a mutex?

I think this is the origin of this algorithm:

https://lore.kernel.org/all/20211019191025.GA4072278@nvidia.com/

But it's not clear to me why Jason chose an example with a spinlock and
if some subtlety here requires it.  Thanks,

Alex

> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/kvm/1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain/
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vfio/pci/pds/vfio_dev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
> index 9db5f2c8f1ea..6e664cb05dd1 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.c
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -33,8 +33,10 @@ void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
>  	if (pds_vfio->deferred_reset) {
>  		pds_vfio->deferred_reset = false;
>  		if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
> +			spin_unlock(&pds_vfio->reset_lock);
>  			pds_vfio_put_restore_file(pds_vfio);
>  			pds_vfio_put_save_file(pds_vfio);
> +			spin_lock(&pds_vfio->reset_lock);
>  			pds_vfio_dirty_disable(pds_vfio, false);
>  		}
>  		pds_vfio->state = pds_vfio->deferred_reset_state;

