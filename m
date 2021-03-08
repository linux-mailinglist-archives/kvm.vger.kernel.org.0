Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517AE3317B1
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 20:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhCHTse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 14:48:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231651AbhCHTsZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 14:48:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615232905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2SQgLbIp0IJvSoEVpeaH2PNWxBkjlnl/yMLhuF4NGuA=;
        b=hrFQ6gwqMMnDPnxBZyxfkjVuEfa0BVYWBZeZQxMHnW8oPv5PoPb4GOV7SwuEZ9omy4juRO
        F6sJ4b7zHf5bPe4hI2jMU18ZCoxjz6E34QoxQ8JVeHvecYrXLsZVM41R7yb/pqna+kgXMO
        KUbBIC/XkVr6LAuJqfffxP+/qlbc4nU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-DeK-piL_Neaz-2oF5Zz7qw-1; Mon, 08 Mar 2021 14:48:23 -0500
X-MC-Unique: DeK-piL_Neaz-2oF5Zz7qw-1
Received: by mail-ed1-f71.google.com with SMTP id r19so5143739edv.3
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 11:48:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2SQgLbIp0IJvSoEVpeaH2PNWxBkjlnl/yMLhuF4NGuA=;
        b=B3wwIiTlS1uGzil+q+VS69bV0EGvP3nucGLEM+Wm3FAmvRxFbAReev9Z/rlSRmMzt2
         JAm+cSE8SNnjlzKtr03tR5gkmbV5HHs7zZDbn+xarBlDhZ6Dk2GiFB9otQwHmebQfRlA
         eP1e7UWeeNetIkQawcs2FcFBSj+fFTf8vcHCNdNGheagttzXe3xyqxGNGCOgEYi36SiY
         MBo+vPsuySf1hDAFLzk8ol/dXLARVJcBtluDigGO60ov6FwF0ooMXNAv8FN3RUPK0fss
         RfFnlGUDLVGzZstbgi5pZDz0ZSOVmMhVSLgAc6he57Tk7zRi8dyzu0dRSKWg3TfKW/yo
         d6dw==
X-Gm-Message-State: AOAM5335ZKhTBNWOHT4sP+e5cD10Srlu2jc2SmgNYUAJ6unDDk5mLThv
        IRec/3BHdbxyphjfv+O9QGr4sz3rtqHUEEgW5pcPY0dYNAeq1ayV1c1R2CSbsMyl8nLr+ND36l+
        //W1szeXQ2qek
X-Received: by 2002:aa7:d4d2:: with SMTP id t18mr222420edr.342.1615232902025;
        Mon, 08 Mar 2021 11:48:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyowvkVRjKgtghcPvbzc7xqqE5IkTrFDMwjfdd7Xj1z+s1PbP92fJRpV/ccSPWLylhy4TsG0w==
X-Received: by 2002:aa7:d4d2:: with SMTP id t18mr222402edr.342.1615232901844;
        Mon, 08 Mar 2021 11:48:21 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b19sm7768064edu.51.2021.03.08.11.48.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 11:48:21 -0800 (PST)
Subject: Re: [PATCH 20/24] KVM: x86/mmu: Use a dedicated bit to track
 shadow/MMU-present SPTEs
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
References: <20210225204749.1512652-1-seanjc@google.com>
 <20210225204749.1512652-21-seanjc@google.com>
 <42917119-b43a-062b-6c09-13b988f7194b@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f3f40f6d-2a02-e914-5d03-4bf451ef3ddb@redhat.com>
Date:   Mon, 8 Mar 2021 20:48:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <42917119-b43a-062b-6c09-13b988f7194b@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/03/21 19:52, Tom Lendacky wrote:
> On 2/25/21 2:47 PM, Sean Christopherson wrote:
>> Introduce MMU_PRESENT to explicitly track which SPTEs are "present" from
>> the MMU's perspective.  Checking for shadow-present SPTEs is a very
>> common operation for the MMU, particularly in hot paths such as page
>> faults.  With the addition of "removed" SPTEs for the TDP MMU,
>> identifying shadow-present SPTEs is quite costly especially since it
>> requires checking multiple 64-bit values.
>>
>> On 64-bit KVM, this reduces the footprint of kvm.ko's .text by ~2k bytes.
>> On 32-bit KVM, this increases the footprint by ~200 bytes, but only
>> because gcc now inlines several more MMU helpers, e.g. drop_parent_pte().
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>    arch/x86/kvm/mmu/spte.c |  8 ++++----
>>    arch/x86/kvm/mmu/spte.h | 11 ++++++++++-
>>    2 files changed, 14 insertions(+), 5 deletions(-)
> 
> I'm trying to run a guest on my Rome system using the queue branch, but
> I'm encountering an error that I bisected to this commit. In the guest
> (during OVMF boot) I see:
> 
> error: kvm run failed Invalid argument
> RAX=0000000000000000 RBX=00000000ffc12792 RCX=000000007f58401a RDX=000000007faaf808
> RSI=0000000000000010 RDI=00000000ffc12792 RBP=00000000ffc12792 RSP=000000007faaf740
> R8 =0000000000000792 R9 =000000007faaf808 R10=00000000ffc12793 R11=00000000000003f8
> R12=0000000000000010 R13=0000000000000000 R14=000000007faaf808 R15=0000000000000012
> RIP=000000007f6e9a90 RFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0030 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> CS =0038 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
> SS =0030 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> DS =0030 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> FS =0030 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> GS =0030 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> LDT=0000 0000000000000000 0000ffff 00008200 DPL=0 LDT
> TR =0000 0000000000000000 0000ffff 00008b00 DPL=0 TSS64-busy
> GDT=     000000007f5ee698 00000047
> IDT=     000000007f186018 00000fff
> CR0=80010033 CR2=0000000000000000 CR3=000000007f801000 CR4=00000668
> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
> DR6=00000000ffff0ff0 DR7=0000000000000400
> EFER=0000000000000d00
> Code=22 00 00 e8 c0 e6 ff ff 48 83 c4 20 45 84 ed 74 07 fb eb 04 <44> 88 65 00 58 5b 5d 41 5c 41 5d c3 55 48 0f af 3d 1b 37 00 00 be 20 00 00 00 48 03 3d 17
> 
> On the hypervisor, I see the following:
> 
> [   55.886136] get_mmio_spte: detect reserved bits on spte, addr 0xffc12792, dump hierarchy:
> [   55.895284] ------ spte 0x1344a0827 level 4.
> [   55.900059] ------ spte 0x134499827 level 3.
> [   55.904877] ------ spte 0x165bf0827 level 2.
> [   55.909651] ------ spte 0xff800ffc12817 level 1.
> 
> When I kill the guest, I get a kernel panic:
> 
> [   95.539683] __pte_list_remove: 0000000040567a6a 0->BUG
> [   95.545481] kernel BUG at arch/x86/kvm/mmu/mmu.c:896!
> [   95.551133] invalid opcode: 0000 [#1] SMP NOPTI
> [   95.556192] CPU: 142 PID: 5054 Comm: qemu-system-x86 Tainted: G        W         5.11.0-rc4-sos-sev-es #1
> [   95.566872] Hardware name: AMD Corporation ETHANOL_X/ETHANOL_X, BIOS REX1006G 01/25/2020
> [   95.575900] RIP: 0010:__pte_list_remove.cold+0x2e/0x48 [kvm]
> [   95.582312] Code: c7 c6 40 6f f3 c0 48 c7 c7 aa da f3 c0 e8 79 3d a7 cd 0f 0b 48 89 fa 48 c7 c6 40 6f f3 c0 48 c7 c7 87 da f3 c0 e8 61 3d a7 cd <0f> 0b 48 89 fa 48 c7 c6 40 6f f3 c0 48 c7 c7 98 da f3 c0 e8 49 3d
> [   95.603271] RSP: 0018:ffffc900143e7c78 EFLAGS: 00010246
> [   95.609093] RAX: 000000000000002a RBX: 0000000000000000 RCX: 0000000000000000
> [   95.617058] RDX: 0000000000000000 RSI: ffff88900e598950 RDI: ffff88900e598950
> [   95.625019] RBP: ffff888165bf0090 R08: ffff88900e598950 R09: ffffc900143e7a98
> [   95.632980] R10: 0000000000000001 R11: 0000000000000001 R12: ffffc9000ff29000
> [   95.640944] R13: ffffc900143e7d18 R14: 0000000000000098 R15: 0000000000000000
> [   95.648912] FS:  0000000000000000(0000) GS:ffff88900e580000(0000) knlGS:0000000000000000
> [   95.657951] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   95.664361] CR2: 00007fb328d20c80 CR3: 00000001476d2000 CR4: 0000000000350ee0
> [   95.672326] Call Trace:
> [   95.675065]  mmu_page_zap_pte+0xf9/0x130 [kvm]
> [   95.680103]  __kvm_mmu_prepare_zap_page+0x6d/0x380 [kvm]
> [   95.686088]  kvm_mmu_zap_all+0x5e/0xe0 [kvm]
> [   95.690911]  kvm_mmu_notifier_release+0x2b/0x60 [kvm]
> [   95.696614]  __mmu_notifier_release+0x71/0x1e0
> [   95.701585]  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
> [   95.707512]  ? __khugepaged_exit+0x111/0x160
> [   95.712289]  exit_mmap+0x15b/0x1f0
> [   95.716092]  ? __khugepaged_exit+0x111/0x160
> [   95.720857]  ? kmem_cache_free+0x210/0x3f0
> [   95.725428]  ? kmem_cache_free+0x387/0x3f0
> [   95.729998]  mmput+0x56/0x130
> [   95.733312]  do_exit+0x341/0xb50
> [   95.736923]  do_group_exit+0x3a/0xa0
> [   95.740925]  __x64_sys_exit_group+0x14/0x20
> [   95.745600]  do_syscall_64+0x33/0x40
> [   95.749601]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   95.755241] RIP: 0033:0x7fb333a442c6
> [   95.759231] Code: Unable to access opcode bytes at RIP 0x7fb333a4429c.
> [   95.766514] RSP: 002b:00007ffdf675cad8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> [   95.774962] RAX: ffffffffffffffda RBX: 00007fb333b4b610 RCX: 00007fb333a442c6
> [   95.782925] RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
> [   95.790892] RBP: 0000000000000000 R08: 00000000000000e7 R09: ffffffffffffdc38
> [   95.798856] R10: 00007fb32945cf80 R11: 0000000000000246 R12: 00007fb333b4b610
> [   95.806825] R13: 000000000000034c R14: 00007fb333b4efc8 R15: 0000000000000000
> [   95.814803] Modules linked in: tun ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter bridge stp llc intel_rapl_msr wmi_bmof intel_rapl_common amd64_edac_mod edac_mce_amd fuse kvm_amd kvm irqby
> pass ipmi_ssif sg ccp k10temp acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler acpi_cpufreq sch_fq_codel parport_pc ppdev lp parport sunrpc ip_tables raid10 raid456 async_raid6_recov async_memcpy async_pq async_xo
> r async_tx xor raid6_pq raid1 raid0 linear sd_mod t10_pi crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel crypto_simd cryptd glue_helper ast drm_vram_helper i2c_algo_bit drm_ttm_helper
> ttm drm_kms_helper syscopyarea sysfillrect sysimgblt ahci fb_sys_fops libahci libata drm i2c_designware_platform e1000e i2c_piix4 wmi i2c_designware_core pinctrl_amd i2c_core
> [   95.893646] ---[ end trace f40aac7ee7919c14 ]---
> [   95.898848] RIP: 0010:__pte_list_remove.cold+0x2e/0x48 [kvm]
> [   95.905258] Code: c7 c6 40 6f f3 c0 48 c7 c7 aa da f3 c0 e8 79 3d a7 cd 0f 0b 48 89 fa 48 c7 c6 40 6f f3 c0 48 c7 c7 87 da f3 c0 e8 61 3d a7 cd <0f> 0b 48 89 fa 48 c7 c6 40 6f f3 c0 48 c7 c7 98 da f3 c0 e8 49 3d
> [   95.926234] RSP: 0018:ffffc900143e7c78 EFLAGS: 00010246
> [   95.932109] RAX: 000000000000002a RBX: 0000000000000000 RCX: 0000000000000000
> [   95.940087] RDX: 0000000000000000 RSI: ffff88900e598950 RDI: ffff88900e598950
> [   95.948086] RBP: ffff888165bf0090 R08: ffff88900e598950 R09: ffffc900143e7a98
> [   95.956068] R10: 0000000000000001 R11: 0000000000000001 R12: ffffc9000ff29000
> [   95.964051] R13: ffffc900143e7d18 R14: 0000000000000098 R15: 0000000000000000
> [   95.972031] FS:  0000000000000000(0000) GS:ffff88900e580000(0000) knlGS:0000000000000000
> [   95.981081] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   95.987510] CR2: 00007fb328d20c80 CR3: 00000001476d2000 CR4: 0000000000350ee0
> [   95.995492] Kernel panic - not syncing: Fatal exception
> [   96.008273] Kernel Offset: disabled
> [   96.012249] ---[ end Kernel panic - not syncing: Fatal exception ]---
> 
> Let me know if there's anything you want me to try.

I can confirm that we're seeing the same failure, though we hadn't 
bisected it yet.

Paolo

