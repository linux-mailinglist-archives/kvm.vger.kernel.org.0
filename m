Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11D36679EF
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 16:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239485AbjALPyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 10:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240521AbjALPyJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 10:54:09 -0500
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84FC559F9
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 07:43:12 -0800 (PST)
Received: by mail-ej1-f47.google.com with SMTP id l22so16015979eja.12
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 07:43:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IbTQhhqB5FlfnlLigHLjClI0Qmrw8L/fBnc1HiTMD/g=;
        b=ZegZm7xth4K0a3z5/n5opCwWllbhFOUvt6VI6WLSBwm3Bh54gWU73fEvI4W8m/VzY5
         FtLKLth7Gtdn+V/1FvSjw/WTZnoYGpcBJ3ZnqQ2j8iTQ8Q2iVfgsr9rNQ7gsZsT4pLRG
         xMVANFFdO+OKCxCb3ati2hhsxSJY0loEAdWwYEHGSr0ps1GFkS3+p1jo+wGdRQovucX7
         zc15p8pAXfPk1e6oolxcccv7t288VsGbh9TJhxY4bGYwB7DUc1MJj71zymzqWWsiU2Al
         lDul1SvkeR9JoLC+1wZ5I6guQEyZVie1rLAubaIQl4Eeika3qs6npvSEReaZrf3T1evc
         ppNg==
X-Gm-Message-State: AFqh2kpuIHJsv8mAQx2fUpsrPN82JJmPk/16zDs+zP2anSt5+CaH+dda
        QVJ3LBOXcghH1v2gnHaGNUU=
X-Google-Smtp-Source: AMrXdXtsXniMiQGSJ+DxX6j1Y88uqHgNcUYyElcsGO4IPbkwWoa5g4tbzr1Iyhi7pwgQoAQl1teftg==
X-Received: by 2002:a17:906:6441:b0:7c1:994c:f168 with SMTP id l1-20020a170906644100b007c1994cf168mr71558571ejn.54.1673538190828;
        Thu, 12 Jan 2023 07:43:10 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:49? ([2a0b:e7c0:0:107::aaaa:49])
        by smtp.gmail.com with ESMTPSA id x25-20020a170906b09900b0080345493023sm7428417ejy.167.2023.01.12.07.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 07:43:10 -0800 (PST)
Message-ID: <17b584f1-9d3b-35bb-7035-9b225936fd23@kernel.org>
Date:   Thu, 12 Jan 2023 16:43:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Stalls in qemu with host running 6.1 (everything stuck at
 mmap_read_lock())
Content-Language: en-US
From:   Jiri Slaby <jirislaby@kernel.org>
To:     Pedro Falcato <pedro.falcato@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        mm <linux-mm@kvack.org>, yuzhao@google.com,
        Michal Hocko <MHocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>, shy828301@gmail.com
References: <b8017e09-f336-3035-8344-c549086c2340@kernel.org>
 <CAKbZUD0Tqct_G9OcO8ocdH1J_YvLSEod-ofr97hsyoHgcvBwuw@mail.gmail.com>
 <7aa90802-d25c-baa3-9c03-2502ad3c708a@kernel.org>
In-Reply-To: <7aa90802-d25c-baa3-9c03-2502ad3c708a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12. 01. 23, 7:07, Jiri Slaby wrote:
> I have rebooted to a fresh kernel which 1) have lockdep enabled, and 2) 
> I have debuginfo for. So next time this happens, I can print held locks 

For the time being:

 >  Showing all locks held in the system:
 >  1 lock held by rcu_tasks_kthre/11:
 >   #0: ffffffffb097a550 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: 
rcu_tasks_one_gp+0x2b/0x3d0
 >  1 lock held by rcu_tasks_rude_/12:
 >   #0: ffffffffb097a2d0 (rcu_tasks_rude.tasks_gp_mutex){+.+.}-{3:3}, 
at: rcu_tasks_one_gp+0x2b/0x3d0
 >  1 lock held by rcu_tasks_trace/13:
 >   #0: ffffffffb097a010 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, 
at: rcu_tasks_one_gp+0x2b/0x3d0
 >  1 lock held by in:imklog/1308:
 >   #0: ffff9538d81364e8 (&f->f_pos_lock){+.+.}-{3:3}, at: 
__fdget_pos+0x4c/0x60
 >  2 locks held by plasmashell/6865:
 >   #0: ffff95393f6092e8 (&f->f_pos_lock){+.+.}-{3:3}, at: 
__fdget_pos+0x4c/0x60
 >   #1: ffff9538dc2aa458 (&mm->mmap_lock#2){++++}-{3:3}, at: 
__access_remote_vm+0x4f/0x3c0
 >  1 lock held by fuse mainloop/9772:
 >   #0: ffff953a578a7468 (&pipe->mutex/1){+.+.}-{3:3}, at: 
splice_file_to_pipe+0x26/0xd0
 >  1 lock held by fuse mainloop/9773:
 >   #0: ffff953a578a7e68 (&pipe->mutex/1){+.+.}-{3:3}, at: 
splice_file_to_pipe+0x26/0xd0
 >  1 lock held by fuse mainloop/25378:
 >   #0: ffff9538d3d8c868 (&pipe->mutex/1){+.+.}-{3:3}, at: 
splice_file_to_pipe+0x26/0xd0
 >  1 lock held by qemu-kvm/31097:
 >  6 locks held by qemu-kvm/31098:
 >   #0: ffff953a062080b0 (&vcpu->mutex){+.+.}-{3:3}, at: 
kvm_vcpu_ioctl+0x77/0x6d0 [kvm]
 >   #1: ffff9538c6e838e8 (&serio->lock){-.-.}-{2:2}, at: 
serio_interrupt+0x24/0x90
 >   #2: ffff9538c6e80230 (&dev->event_lock){-.-.}-{2:2}, at: 
input_event+0x3c/0x80
 >   #3: ffffffffb097af60 (rcu_read_lock){....}-{1:2}, at: 
input_pass_values.part.0+0x5/0x270
 >   #4: ffffffffb097af60 (rcu_read_lock){....}-{1:2}, at: 
__handle_sysrq+0x5/0xa0
 >   #5: ffffffffb097af60 (rcu_read_lock){....}-{1:2}, at: 
debug_show_all_locks+0x15/0x16b
 >  1 lock held by qemu-kvm/31099:
 >  3 locks held by qemu-kvm/31100:
 >  1 lock held by qemu-kvm/31819:
 >   #0: ffff9538dc2aa458 (&mm->mmap_lock#2){++++}-{3:3}, at: 
__vm_munmap+0x95/0x170
 >  1 lock held by qemu-kvm/31935:
 >   #0: ffff9538dc2aa458 (&mm->mmap_lock#2){++++}-{3:3}, at: 
do_madvise.part.0+0xe8/0x2a0
 >  1 lock held by dmesg/31873:
 >   #0: ffff9538ef6000d0 (&user->lock){+.+.}-{3:3}, at: 
devkmsg_read+0x4b/0x230
 >  1 lock held by ps/31996:
 >   #0: ffff9538dc2aa458 (&mm->mmap_lock#2){++++}-{3:3}, at: 
__access_remote_vm+0x4f/0x3c0


> and dump a kcore (kdump is set up).

Going to trigger a dump now.

-- 
js
suse labs

