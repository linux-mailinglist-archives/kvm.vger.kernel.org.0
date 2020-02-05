Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94DA1532D2
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgBEO1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:27:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37805 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726119AbgBEO1f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 09:27:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580912853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=udOvaIJpsx9wrAMmRufUgqUxBBbPPqah8VwHBWHf90Q=;
        b=CT2/ldwixJpXT1Z9UfFbMPtJjWFHq0DFzQ5WqCQqOFI3sqqRyfqkr/BsLcz8SgRXjrFDBN
        FdH7DBic2exb8So9t/Gf7h7SjUzFm95Q+PIzk0aVaLCsZJJECIBTszoSMqwpHD557+Ux7A
        M0TFaFbfaXdYgW0YRGm8TAQ7ijea4qk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-N9nVS-pJM-GdffWOBkDinw-1; Wed, 05 Feb 2020 09:27:31 -0500
X-MC-Unique: N9nVS-pJM-GdffWOBkDinw-1
Received: by mail-wr1-f72.google.com with SMTP id c6so1250832wrm.18
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 06:27:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=udOvaIJpsx9wrAMmRufUgqUxBBbPPqah8VwHBWHf90Q=;
        b=GfcA9doMCAtJqZ3CPrGRd4XtuI+miyDe4gznPPNBT2pepxqXbqZzBW4RFpqSWjlPs8
         KQHX4AApWdiHnXg34h2fgtbLx9TsUF7z1SK2tw8FB77g4xr4vkj2CqmmZdB89ko6SZC7
         hQFwJdLqxSNIQHeICXWtZU3D0vmuXEmMo6CGAnY4DNTYomvM+1oe4nEULh/NNo6sQhA+
         tFHQ6munk8zH9lsSueb+PCMAEPT6T1TtduoHNJnHvZ2FJfwngz68yic0xLGZx/QTnVSq
         sitNTeg9D6uUUlpUFKz3Q6znU3svdjcIDV+gzCQzOtQewUh04JLlVYnwbP2yCFHYz4ye
         UpYQ==
X-Gm-Message-State: APjAAAUVuIxRoN8XaVy7kcffLYzevE/qHV60skAwDfnUi7wI3G/9NKub
        enUGlyndb+Hiv/4oqrTJRq9KiwdhZK6qJ2GoD/nCOhEGRDVt6441EJbgxbTj2c3muoeLWyMFets
        0AjJrkIMyaMoL
X-Received: by 2002:a05:600c:292:: with SMTP id 18mr6418558wmk.128.1580912849881;
        Wed, 05 Feb 2020 06:27:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqzkjcNG5Q8PJIrg66bMeEFA2HcUioDcta38qZgO+ETNzrN8b19Q38H5JexcmkrnZrQo/M3RCA==
X-Received: by 2002:a05:600c:292:: with SMTP id 18mr6418525wmk.128.1580912849574;
        Wed, 05 Feb 2020 06:27:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a9f0:cbc3:a8a6:fc56? ([2001:b07:6468:f312:a9f0:cbc3:a8a6:fc56])
        by smtp.gmail.com with ESMTPSA id d204sm8238460wmd.30.2020.02.05.06.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 06:27:29 -0800 (PST)
Subject: Re: [PATCH v2] KVM: fix overflow of zero page refcount with ksm
 running
To:     Zhuang Yanying <ann.zhuangyanying@huawei.com>,
        linfeng23@huawei.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     weiqi4@huawei.com, weidong.huang@huawei.com
References: <1570851452-23364-1-git-send-email-ann.zhuangyanying@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e1b4d89d-f311-2bf1-7924-4b9db38fec09@redhat.com>
Date:   Wed, 5 Feb 2020 15:27:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1570851452-23364-1-git-send-email-ann.zhuangyanying@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/19 05:37, Zhuang Yanying wrote:
> We are testing Virtual Machine with KSM on v5.4-rc2 kernel,
> and found the zero_page refcount overflow.
> The cause of refcount overflow is increased in try_async_pf
> (get_user_page) without being decreased in mmu_set_spte()
> while handling ept violation.
> In kvm_release_pfn_clean(), only unreserved page will call
> put_page. However, zero page is reserved.
> So, as well as creating and destroy vm, the refcount of
> zero page will continue to increase until it overflows.
> 
> step1:
> echo 10000 > /sys/kernel/pages_to_scan/pages_to_scan
> echo 1 > /sys/kernel/pages_to_scan/run
> echo 1 > /sys/kernel/pages_to_scan/use_zero_pages
> 
> step2:
> just create several normal qemu kvm vms.
> And destroy it after 10s.
> Repeat this action all the time.
> 
> After a long period of time, all domains hang because
> of the refcount of zero page overflow.
> 
> Qemu print error log as follow:
>  …
>  error: kvm run failed Bad address
>  EAX=00006cdc EBX=00000008 ECX=80202001 EDX=078bfbfd
>  ESI=ffffffff EDI=00000000 EBP=00000008 ESP=00006cc4
>  EIP=000efd75 EFL=00010002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
>  ES =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>  CS =0008 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
>  SS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>  DS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>  FS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>  GS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>  LDT=0000 00000000 0000ffff 00008200 DPL=0 LDT
>  TR =0000 00000000 0000ffff 00008b00 DPL=0 TSS32-busy
>  GDT=     000f7070 00000037
>  IDT=     000f70ae 00000000
>  CR0=00000011 CR2=00000000 CR3=00000000 CR4=00000000
>  DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
>  DR6=00000000ffff0ff0 DR7=0000000000000400
>  EFER=0000000000000000
>  Code=00 01 00 00 00 e9 e8 00 00 00 c7 05 4c 55 0f 00 01 00 00 00 <8b> 35 00 00 01 00 8b 3d 04 00 01 00 b8 d8 d3 00 00 c1 e0 08 0c ea a3 00 00 01 00 c7 05 04
>  …
> 
> Meanwhile, a kernel warning is departed.
> 
>  [40914.836375] WARNING: CPU: 3 PID: 82067 at ./include/linux/mm.h:987 try_get_page+0x1f/0x30
>  [40914.836412] CPU: 3 PID: 82067 Comm: CPU 0/KVM Kdump: loaded Tainted: G           OE     5.2.0-rc2 #5
>  [40914.836415] RIP: 0010:try_get_page+0x1f/0x30
>  [40914.836417] Code: 40 00 c3 0f 1f 84 00 00 00 00 00 48 8b 47 08 a8 01 75 11 8b 47 34 85 c0 7e 10 f0 ff 47 34 b8 01 00 00 00 c3 48 8d 78 ff eb e9 <0f> 0b 31 c0 c3 66 90 66 2e 0f 1f 84 00 0
>  0 00 00 00 48 8b 47 08 a8
>  [40914.836418] RSP: 0018:ffffb4144e523988 EFLAGS: 00010286
>  [40914.836419] RAX: 0000000080000000 RBX: 0000000000000326 RCX: 0000000000000000
>  [40914.836420] RDX: 0000000000000000 RSI: 00004ffdeba10000 RDI: ffffdf07093f6440
>  [40914.836421] RBP: ffffdf07093f6440 R08: 800000424fd91225 R09: 0000000000000000
>  [40914.836421] R10: ffff9eb41bfeebb8 R11: 0000000000000000 R12: ffffdf06bbd1e8a8
>  [40914.836422] R13: 0000000000000080 R14: 800000424fd91225 R15: ffffdf07093f6440
>  [40914.836423] FS:  00007fb60ffff700(0000) GS:ffff9eb4802c0000(0000) knlGS:0000000000000000
>  [40914.836425] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  [40914.836426] CR2: 0000000000000000 CR3: 0000002f220e6002 CR4: 00000000003626e0
>  [40914.836427] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  [40914.836427] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  [40914.836428] Call Trace:
>  [40914.836433]  follow_page_pte+0x302/0x47b
>  [40914.836437]  __get_user_pages+0xf1/0x7d0
>  [40914.836441]  ? irq_work_queue+0x9/0x70
>  [40914.836443]  get_user_pages_unlocked+0x13f/0x1e0
>  [40914.836469]  __gfn_to_pfn_memslot+0x10e/0x400 [kvm]
>  [40914.836486]  try_async_pf+0x87/0x240 [kvm]
>  [40914.836503]  tdp_page_fault+0x139/0x270 [kvm]
>  [40914.836523]  kvm_mmu_page_fault+0x76/0x5e0 [kvm]
>  [40914.836588]  vcpu_enter_guest+0xb45/0x1570 [kvm]
>  [40914.836632]  kvm_arch_vcpu_ioctl_run+0x35d/0x580 [kvm]
>  [40914.836645]  kvm_vcpu_ioctl+0x26e/0x5d0 [kvm]
>  [40914.836650]  do_vfs_ioctl+0xa9/0x620
>  [40914.836653]  ksys_ioctl+0x60/0x90
>  [40914.836654]  __x64_sys_ioctl+0x16/0x20
>  [40914.836658]  do_syscall_64+0x5b/0x180
>  [40914.836664]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>  [40914.836666] RIP: 0033:0x7fb61cb6bfc7
> 
> Signed-off-by: LinFeng <linfeng23@huawei.com>
> Signed-off-by: Zhuang Yanying <ann.zhuangyanying@huawei.com>
> ---
> v1 -> v2:  fix compile error
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fd68fbe..a073442 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -152,7 +152,7 @@ __weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
>  bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
>  {
>  	if (pfn_valid(pfn))
> -		return PageReserved(pfn_to_page(pfn));
> +		return PageReserved(pfn_to_page(pfn)) && !is_zero_pfn(pfn);
>  
>  	return true;
>  }
> 

Queued, thanks.

Paolo

