Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214CD7A6AFF
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 20:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbjISS7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 14:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbjISS7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 14:59:46 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBC611C
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 11:59:40 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1bf7423ef3eso44985845ad.3
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 11:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695149980; x=1695754780; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7d4j7spw4e2sOo1qiG0aMjGFKB6UwpsoW1lQkqDJ21g=;
        b=eWuTuY/JoxJlzmKexawaSTf3HehHw4iS6IqaB2WEtxttPQgjt8H7nwR0bGd7fIjE9z
         QMn34mIqR5WICTdYSsTSz6EbcAJFeQSw2Tb8tYlCS0q0DuK5+2EulY5eWzirkoGN1Xke
         3hykDTav8H2vswZy8wAJFxOKxyGfnfmwUr1FcTngOe3FiI+//5hgEiCndH6OA2vnAaJq
         OqiqnXcEGE7EMZYwTxeWnyzshMu79N+H+RseGt+iknPzFZBNn2fObCmMkFEdsRSiSMtP
         HdauXgDrVxQZC4B+WeZ4yF28Bqco+ExfJGxb8Tdy8Jk7TI1UPiDRKIzjwm6oLqRxQrhy
         /dig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695149980; x=1695754780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7d4j7spw4e2sOo1qiG0aMjGFKB6UwpsoW1lQkqDJ21g=;
        b=dl8NeEoM+hMDF/sdl0uohroNQbLewY2njrW/rq+60GlkE6DgbjqtSBk/AeG4l4MvTv
         RhFxRlIytt2lZE9wowNhQ5BJuMduNjkqBjxO+U5YByaxbckHRlih1S5rKvq13i1ttFNM
         q1VouvWFfVCe+R9moCwgHBZoSNGaUBoIuW4UzgcD9rseA2+uNV9z6c49pmEIIaYnPQ1K
         OrgI/sUNaAYOvN8oCTD9d4S0IHCTJFL29hva6zpK/Am/HHBoBL3ELETmgl8/ufe1VZ0/
         9r9DxWTNfnr1JzfpwnMThitSZELnUHreWRfGewrrHQGnI3Xw0O4rPwO0xT+BuvhnkhFv
         ZJ7g==
X-Gm-Message-State: AOJu0Yz10TJOP5xOOk0g4tPPR4HB8Cybmsx7tDIMVx3hI2ZNe2VE/bN+
        D5wCRxKGMVLNMJhLuoRvJSteig==
X-Google-Smtp-Source: AGHT+IEYvwiov2T08Y5YTG2t0uwno6AUAmOTv/IbdOZ5X6Wi2xS6/BHyhRaEjOeNHyuzR5gkSr2mmg==
X-Received: by 2002:a17:903:230b:b0:1c4:2b36:897a with SMTP id d11-20020a170903230b00b001c42b36897amr439275plh.20.1695149980256;
        Tue, 19 Sep 2023 11:59:40 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id g4-20020a170902740400b001bc18e579aesm10323606pll.101.2023.09.19.11.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Sep 2023 11:59:39 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qifwg-000GD2-3t;
        Tue, 19 Sep 2023 15:59:38 -0300
Date:   Tue, 19 Sep 2023 15:59:38 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Brett Creeley <brett.creeley@amd.com>, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        dan.carpenter@linaro.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shannon.nelson@amd.com
Subject: Re: [PATCH vfio 3/3] pds/vfio: Fix possible sleep while in atomic
 context
Message-ID: <20230919185938.GU13795@ziepe.ca>
References: <20230914191540.54946-1-brett.creeley@amd.com>
 <20230914191540.54946-4-brett.creeley@amd.com>
 <20230914163837.07607d8a.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914163837.07607d8a.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023 at 04:38:37PM -0600, Alex Williamson wrote:
> On Thu, 14 Sep 2023 12:15:40 -0700
> Brett Creeley <brett.creeley@amd.com> wrote:
> 
> > The driver could possibly sleep while in atomic context resulting
> > in the following call trace while CONFIG_DEBUG_ATOMIC_SLEEP=y is
> > set:
> > 
> > [  227.229806] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:283
> > [  227.229818] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 2817, name: bash
> > [  227.229824] preempt_count: 1, expected: 0
> > [  227.229827] RCU nest depth: 0, expected: 0
> > [  227.229832] CPU: 5 PID: 2817 Comm: bash Tainted: G S         OE      6.6.0-rc1-next-20230911 #1
> > [  227.229839] Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 01/23/2021
> > [  227.229843] Call Trace:
> > [  227.229848]  <TASK>
> > [  227.229853]  dump_stack_lvl+0x36/0x50
> > [  227.229865]  __might_resched+0x123/0x170
> > [  227.229877]  mutex_lock+0x1e/0x50
> > [  227.229891]  pds_vfio_put_lm_file+0x1e/0xa0 [pds_vfio_pci]
> > [  227.229909]  pds_vfio_put_save_file+0x19/0x30 [pds_vfio_pci]
> > [  227.229923]  pds_vfio_state_mutex_unlock+0x2e/0x80 [pds_vfio_pci]
> > [  227.229937]  pci_reset_function+0x4b/0x70
> > [  227.229948]  reset_store+0x5b/0xa0
> > [  227.229959]  kernfs_fop_write_iter+0x137/0x1d0
> > [  227.229972]  vfs_write+0x2de/0x410
> > [  227.229986]  ksys_write+0x5d/0xd0
> > [  227.229996]  do_syscall_64+0x3b/0x90
> > [  227.230004]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> > [  227.230017] RIP: 0033:0x7fb202b1fa28
> > [  227.230023] Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 15 4d 2a 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89 d4 55
> > [  227.230028] RSP: 002b:00007fff6915fbd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> > [  227.230036] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fb202b1fa28
> > [  227.230040] RDX: 0000000000000002 RSI: 000055f3834d5aa0 RDI: 0000000000000001
> > [  227.230044] RBP: 000055f3834d5aa0 R08: 000000000000000a R09: 00007fb202b7fae0
> > [  227.230047] R10: 000000000000000a R11: 0000000000000246 R12: 00007fb202dc06e0
> > [  227.230050] R13: 0000000000000002 R14: 00007fb202dbb860 R15: 0000000000000002
> > [  227.230056]  </TASK>

I usually encourage people to trim the oops, remove the time stamp at least.
> > 
> > This can happen if pds_vfio_put_restore_file() and/or
> > pds_vfio_put_save_file() grab the mutex_lock(&lm_file->lock)
> > while the spin_lock(&pds_vfio->reset_lock) is held, which can
> > happen during while calling pds_vfio_state_mutex_unlock().
> > 
> > Fix this by releasing the spin_unlock(&pds_vfio->reset_lock) before
> > calling pds_vfio_put_restore_file() and pds_vfio_put_save_file() and
> > re-acquiring spin_lock(&pds_vfio->reset_lock) after the previously
> > mentioned functions are called to protect setting the subsequent
> > state/deferred reset settings.
> > 
> > The only possible concerns are other threads that may call
> > pds_vfio_put_restore_file() and/or pds_vfio_put_save_file(). However,
> > those paths are already protected by the state mutex_lock().
> 
> Is there another viable solution to change reset_lock to a mutex?
> 
> I think this is the origin of this algorithm:
> 
> https://lore.kernel.org/all/20211019191025.GA4072278@nvidia.com/
> 
> But it's not clear to me why Jason chose an example with a spinlock and
> if some subtlety here requires it.  Thanks,

I think there was no specific reason it must be a spinlock

Certainly I'm not feeling comfortable just unlocking and relocking
like that. It would need a big explanation why it is safe in a
comment.

Jason
