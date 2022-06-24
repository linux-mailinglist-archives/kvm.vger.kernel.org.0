Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9465559FE2
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 20:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiFXRel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 13:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiFXRej (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 13:34:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6419BFE3
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656092077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ij8iK54Agn8lcdfuu+RDaTwRNpa3Rxu3MXyeKtbzLAc=;
        b=VPevBDkfDpgLy3d0j51IcvuzOxtEQ6dJIvDS3vE2lbRJ2381Z3oGX0F3BH/ZfCqmysGQIl
        O+un88OZPQl8R/tOQcgltIFjvDl8+noNTDf0N8Vopx9gFZxFNVpbFB5VPyAB0Uf+9LEyLC
        Dw95t8E4Qi0/CL0JaGiW7M/lh0R1m/8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-s4B1DJjGMhySSzOEDtD1-w-1; Fri, 24 Jun 2022 13:34:36 -0400
X-MC-Unique: s4B1DJjGMhySSzOEDtD1-w-1
Received: by mail-ed1-f70.google.com with SMTP id z19-20020a05640240d300b00437633081abso707655edb.0
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:34:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=ij8iK54Agn8lcdfuu+RDaTwRNpa3Rxu3MXyeKtbzLAc=;
        b=yufsRtzQ5UyGZfIyKmFfGQHcilNhyM+9aoYKYMvhfp/iy0dnY34Rw/YcyqQogIIPjL
         knXzfHtrodFSSqBlKEg+WOgPk/Q+Z43Bq1eJZpl7U18WJLfTl0WRxOZKmXDyuIAfAsVf
         2h452Ndc9kv7iosvSNmit6KsCe3z82qKZg5K8QUYaTSfGmXH71br/ZMExk+vxitap6VP
         BOKnEeBdgj1QkPoCPVuSekWuzjBX+2MLSJ4m+8g2zt1i7962yb4Mxw459LjrbYBpgPt4
         mNj/ahaDo3HR7yBLmVMpj03j6NvMms2Kcs+3vYHPEW1/gEEEWiGmbwBeFrHWtB10bC5R
         pR0A==
X-Gm-Message-State: AJIora+uMEgCu3tw6yntBcIBjq0IiUqKFM385FywMFpaWIiSip+5R09F
        tzTpZR2DBeC3Xd3eUz/r5Nt7NoBVjncZk1yXtgSrnXUs/YIgwDBv4U3mdYABtrbWB4GGaM1ktTY
        vP8jAT3BNoIn0ETiIIZ2P3PJrqRbv+N9WOpQY4b9h4IKZGHdKGGtTb42bG/t/cz95
X-Received: by 2002:a17:906:9c84:b0:6e0:7c75:6f01 with SMTP id fj4-20020a1709069c8400b006e07c756f01mr88445ejc.103.1656092074841;
        Fri, 24 Jun 2022 10:34:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ujk6ExKLfbwJePmTM4nYAZ7PKR2XR931rfZuslWvX7j5U3gyx0qliqvesC+ChcyEWlD1UYOA==
X-Received: by 2002:a17:906:9c84:b0:6e0:7c75:6f01 with SMTP id fj4-20020a1709069c8400b006e07c756f01mr88424ejc.103.1656092074560;
        Fri, 24 Jun 2022 10:34:34 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id fd5-20020a056402388500b00436f3107bdasm1790544edb.38.2022.06.24.10.34.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 10:34:34 -0700 (PDT)
Message-ID: <e29b8e6c-3371-41aa-f478-c2f8ff98526c@redhat.com>
Date:   Fri, 24 Jun 2022 19:34:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     KVM list <kvm@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        Sean Christopherson <seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: lockdep splat with gpc cache
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Today I got the following lockdep splat:

----------
xen_shinfo_test/2726393 is trying to acquire lock:
ffff8885dc2818f0 (&gpc->lock){....}-{2:2}, at: 
kvm_xen_update_runstate_guest+0xcd/0x500 [kvm]

but task is already holding lock:
ffff888bc8803058 (&rq->__lock){-.-.}-{2:2}, at: 
raw_spin_rq_lock_nested+0x30/0x120

which lock already depends on the new lock.

3 locks held by xen_shinfo_test/2726393:
  #0: ffff8885dc2800b8 (&vcpu->mutex){+.+.}-{3:3}, at: 
kvm_vcpu_ioctl+0x19c/0xc60 [kvm]
  #1: ffff888bc8803058 (&rq->__lock){-.-.}-{2:2}, at: 
raw_spin_rq_lock_nested+0x30/0x120
  #2: ffffc900221f44c0 (&kvm->srcu){....}-{0:0}, at: 
kvm_arch_vcpu_put+0x9f/0x7e0 [kvm]

  __lock_acquire+0xb72/0x1870
  lock_acquire+0x1d8/0x5b0
  _raw_read_lock_irqsave+0x4f/0xb0
  kvm_xen_update_runstate_guest+0xcd/0x500 [kvm]
  kvm_arch_vcpu_put+0x48c/0x7e0 [kvm]
  kvm_sched_out+0xaf/0xf0 [kvm]
  prepare_task_switch+0x379/0xe20

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&rq->__lock);
                                lock(&p->pi_lock);
                                lock(&rq->__lock);
   lock(&gpc->lock);
------------------

As you can see from the above dump, the other lockdep chain is weird:

   &gpc->lock --> &p->pi_lock --> &rq->__lock

but I don't understand why p->pi_lock would be taken inside the 
gpc->lock critical section:

   -> #4 (&rq->__lock){-.-.}-{2:2}:
        __lock_acquire+0xb72/0x1870
        lock_acquire+0x1d8/0x5b0
        _raw_spin_lock_nested+0x3a/0x70
        raw_spin_rq_lock_nested+0x30/0x120
        task_fork_fair+0x6b/0x590
        sched_cgroup_fork+0x38b/0x590
        copy_process+0x2e5e/0x5290
        kernel_clone+0xba/0x890
        kernel_thread+0xae/0xe0
        rest_init+0x22/0x1f0
        arch_call_rest_init+0xf/0x15
        start_kernel+0x3d3/0x3f1
        secondary_startup_64_no_verify+0xd5/0xdb

   -> #3 (&p->pi_lock){-.-.}-{2:2}:
        __lock_acquire+0xb72/0x1870
        lock_acquire+0x1d8/0x5b0
        _raw_spin_lock_irqsave+0x43/0x90
        try_to_wake_up+0xb3/0xdd0
        create_worker+0x374/0x510
        workqueue_init+0x29f/0x343
        kernel_init_freeable+0x40e/0x53e
        kernel_init+0x19/0x140
        ret_from_fork+0x22/0x30

   -> #2 (&pool->lock){-.-.}-{2:2}:
        __lock_acquire+0xb72/0x1870
        lock_acquire+0x1d8/0x5b0
        _raw_spin_lock+0x34/0x80
        __queue_work+0x2a9/0xbb0
        queue_work_on+0x7b/0x90
        percpu_ref_put_many.constprop.0+0x16b/0x1a0
        uncharge_folio+0xf6/0x650
        __mem_cgroup_uncharge_list+0xb9/0x150
        release_pages+0x55e/0x1030
        __pagevec_lru_add+0x2f2/0x4f0
        folio_add_lru+0x326/0x550
        wp_page_copy+0x70d/0x10c0
        __handle_mm_fault+0xd9a/0x13d0
        handle_mm_fault+0x16b/0x5e0
        do_user_addr_fault+0x344/0xd80
        exc_page_fault+0x5a/0xe0
        asm_exc_page_fault+0x1e/0x30

   -> #1 (lock#6){+.+.}-{2:2}:
        __lock_acquire+0xb72/0x1870
        lock_acquire+0x1d8/0x5b0
        folio_mark_accessed+0x18a/0x770
        kvm_release_page_clean+0x1a4/0x240 [kvm]
        hva_to_pfn_retry+0x6d7/0x8e0 [kvm]
        kvm_gfn_to_pfn_cache_refresh+0x368/0xb90 [kvm]
        kvm_set_msr_common+0x9f4/0x26a0 [kvm]
        __kvm_set_msr+0xea/0x450 [kvm]
        kvm_emulate_wrmsr+0xb5/0x1a0 [kvm]
        vmx_handle_exit+0x15/0x140 [kvm_intel]
        vcpu_enter_guest+0x214a/0x3cc0 [kvm]
        vcpu_run+0xc5/0x950 [kvm]
        kvm_arch_vcpu_ioctl_run+0x326/0x10f0 [kvm]
        kvm_vcpu_ioctl+0x46a/0xc60 [kvm]
        __x64_sys_ioctl+0x127/0x190
        do_syscall_64+0x5c/0x80
        entry_SYSCALL_64_after_hwframe+0x44/0xae

   -> #0 (&gpc->lock){....}-{2:2}:
        __lock_acquire+0xb72/0x1870
        lock_acquire+0x1d8/0x5b0
        _raw_read_lock_irqsave+0x4f/0xb0
        kvm_xen_update_runstate_guest+0xcd/0x500 [kvm]
        kvm_arch_vcpu_put+0x48c/0x7e0 [kvm]
        kvm_sched_out+0xaf/0xf0 [kvm]
        prepare_task_switch+0x379/0xe20
        __schedule+0x3f7/0x1500
        schedule+0xe0/0x1f0
        xfer_to_guest_mode_handle_work+0xa8/0xe0
        vcpu_run+0x5f9/0x950 [kvm]
        kvm_arch_vcpu_ioctl_run+0x326/0x10f0 [kvm]
        kvm_vcpu_ioctl+0x46a/0xc60 [kvm]
        __x64_sys_ioctl+0x127/0x190
        do_syscall_64+0x5c/0x80
        entry_SYSCALL_64_after_hwframe+0x44/0xae

I'm about to disappear for a couple weeks, so I'll just throw this out 
and think about it while I am away.

Paolo

