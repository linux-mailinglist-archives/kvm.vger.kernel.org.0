Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1AE95BFED4
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 15:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiIUNSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 09:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiIUNSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 09:18:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16858A7C4
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 06:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663766281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Ycsm6u9sZ82A3jlHCGPvt/qqS1OZ6xDjvbs1owMubI=;
        b=CpCGftdIlwGC7I8CU4jkHnouvBJjO7zqK7UmRGJC5wzwfmVWt4ec8v4kiJtEYBiVY12Qvt
        mzDA8n/waX1/fEZ0wUS47w00MyEM5NSIYE7DCKy5Tp3BmJdKYqSvh+GLX0zq+HkOkGHyPA
        9pJYR7Sqx/x7wqe/zlmqm5PviyHqMsQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-571-FjRPzRtOMzuO_xQReIaMQA-1; Wed, 21 Sep 2022 09:17:59 -0400
X-MC-Unique: FjRPzRtOMzuO_xQReIaMQA-1
Received: by mail-wm1-f70.google.com with SMTP id c128-20020a1c3586000000b003b324bb08c5so7904365wma.9
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 06:17:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=+Ycsm6u9sZ82A3jlHCGPvt/qqS1OZ6xDjvbs1owMubI=;
        b=WjMyDM5KvCI9DVJhTyWZbQ9BX+/SkUYcbDOPZ1J2GMbVeRL6OdZH4Ask7AizvEwKzf
         TYzP/v3fyY2y1Yp4M7eR+7AS9d8J5dUWagYhs2m0AHmnqtxmg6JymXhYh9F+NL3MNtkl
         N7fzwAhFkIzEjAv3lQ7Pig/SlHH+401wdlQ0CJLONhnQ91odHjS3JA2xtaq6PuI9rddF
         s6BgcKqGk64bLyZYxhUFmjpWgYsvMsKixhhhEnY2wmt9Wta8l6uD3tNcVD8r3dQ7qtYT
         /iPacAGiY0nbgcl12Kz8ifjISg3KObQb8ftE8PnB1P+19VwdCivi0Nnq6D52caNTaoaB
         041Q==
X-Gm-Message-State: ACrzQf2p1M8mJznInHnGKHMYsJgpjFXJ0yCCpufPv1/Hc7BtTJCD5/h+
        ZTfedYI8O1yIk53M/wv+hLieMhQ/MFknj0GAVsyjInqDvCEAiTXrQkz7Lmmu10QMD/NhTg8moWC
        QG9qTh7Mc/Byf
X-Received: by 2002:a5d:550c:0:b0:22b:1942:4bf6 with SMTP id b12-20020a5d550c000000b0022b19424bf6mr4553169wrv.520.1663766278407;
        Wed, 21 Sep 2022 06:17:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Erew7wBLP+9LtOkgcbJj5JZHqOUD/OpDcGOqy2mOcO/Om9etdvAhViz9GLTajLlLqxrqRjg==
X-Received: by 2002:a5d:550c:0:b0:22b:1942:4bf6 with SMTP id b12-20020a5d550c000000b0022b19424bf6mr4553150wrv.520.1663766278091;
        Wed, 21 Sep 2022 06:17:58 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f15-20020a1cc90f000000b003b2878b9e0dsm2769590wmb.20.2022.09.21.06.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 06:17:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v4 1/9] KVM: x86/mmu: Bug the VM if KVM attempts to
 double count an NX huge page
In-Reply-To: <20220830235537.4004585-2-seanjc@google.com>
References: <20220830235537.4004585-1-seanjc@google.com>
 <20220830235537.4004585-2-seanjc@google.com>
Date:   Wed, 21 Sep 2022 15:17:56 +0200
Message-ID: <87tu50oohn.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> WARN and kill the VM if KVM attempts to double count an NX huge page,
> i.e. attempts to re-tag a shadow page with "NX huge page disallowed".
> KVM does NX huge page accounting only when linking a new shadow page, and
> it should be impossible for a new shadow page to be already accounted.
> E.g. even in the TDP MMU case, where vCPUs can race to install a new
> shadow page, only the "winner" will account the installed page.
>
> Kill the VM instead of continuing on as either KVM has an egregious bug,
> e.g. didn't zero-initialize the data, or there's host data corruption, in
> which carrying on is dangerous, e.g. could cause silent data corruption
> in the guest.
>
> Reported-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 32b60a6b83bd..74afee3f2476 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -804,7 +804,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>  
>  void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
> -	if (sp->lpage_disallowed)
> +	if (KVM_BUG_ON(sp->lpage_disallowed, kvm))
>  		return;
>  
>  	++kvm->stat.nx_lpage_splits;

This patch (now in sean/for_paolo/6.1) causes nested Hyper-V guests to
break early in the boot sequence but the fault is not
Hyper-V-enlightenments related, e.g. even without them I see:

# ~/qemu/build/qemu-system-x86_64 -machine q35,accel=kvm,kernel-irqchip=split -name guest=win10 -cpu host -smp 4 -m 16384 -drive file=/home/VMs/WinDev2202Eval.qcow2,if=none,id=drive-ide0-0-0 -device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0,bootindex=1 -vnc :0 -rtc base=localtime,driftfix=slew --no-hpet -monitor stdio --no-reboot
QEMU 7.0.50 monitor - type 'help' for more information
(qemu) 
error: kvm run failed Input/output error
EAX=00000020 EBX=0000ffff ECX=00000000 EDX=0000ffff
ESI=00000000 EDI=00002300 EBP=00000000 ESP=00006d8c
EIP=00000018 EFL=00000046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =f000 000f0000 ffffffff 00809300
CS =cb00 000cb000 ffffffff 00809b00
SS =0000 00000000 ffffffff 00809300
DS =0000 00000000 ffffffff 00809300
FS =0000 00000000 ffffffff 00809300
GS =0000 00000000 ffffffff 00809300
LDT=0000 00000000 0000ffff 00008200
TR =0000 00000000 0000ffff 00008b00
GDT=     00000000 00000000
IDT=     00000000 000003ff
CR0=00000010 CR2=00000000 CR3=00000000 CR4=00000000
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000 
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000000
Code=0e 07 31 c0 b9 00 10 8d 3e 00 03 fc f3 ab 07 b8 20 00 e7 7e <cb> 0f 1f 80 00 00 00 00 6b 76 6d 20 61 50 69 43 20 00 00 00 2d 02 00 00 d9 02 00 00 00 03
KVM_GET_CLOCK failed: Input/output error
Aborted (core dumped)

(FWIW, KVM_GET_CLOCK is obviously unrelated here, KVM_BUG_ON'ed VMs are
just like that for all ioctls)

I can also see

[  962.063025] WARNING: CPU: 2 PID: 20511 at arch/x86/kvm/mmu/mmu.c:808 account_huge_nx_page+0x2c/0xc0 [kvm]
[  962.072654] Modules linked in: kvm_intel(E) kvm(E) qrtr rfkill sunrpc intel_rapl_msr intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common isst_if_common skx_edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp ipmi_ssif mlx5_ib ib_uverbs irqbypass acpi_ipmi ib_core rapl dcdbas ipmi_si mei_me intel_cstate i2c_i801 ipmi_devintf dell_smbios mei intel_uncore dell_wmi_descriptor wmi_bmof pcspkr i2c_smbus lpc_ich ipmi_msghandler acpi_power_meter xfs libcrc32c mlx5_core sd_mod t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 sg mgag200 drm_shmem_helper drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ahci libahci crct10dif_pclmul drm igb crc32_pclmul libata crc32c_intel mlxfw megaraid_sas ghash_clmulni_intel psample dca i2c_algo_bit pci_hyperv_intf wmi dm_mirror dm_region_hash dm_log dm_mod fuse [last unloaded: kvm]
[  962.148222] CPU: 2 PID: 20511 Comm: qemu-system-x86 Tainted: G          I E      6.0.0-rc1+ #158
[  962.157005] Hardware name: Dell Inc. PowerEdge R740/0WRPXK, BIOS 2.12.2 07/09/2021
[  962.164572] RIP: 0010:account_huge_nx_page+0x2c/0xc0 [kvm]
[  962.170101] Code: 44 00 00 41 56 48 8d 86 90 00 00 00 41 55 41 54 55 48 89 fd 53 4c 8b a6 90 00 00 00 49 39 c4 74 29 80 bf f4 9d 00 00 00 75 2b <0f> 0b b8 01 01 00 00 be 01 03 00 00 66 89 87 f4 9d 00 00 5b 5d 41
[  962.188854] RSP: 0018:ffffbb2243e17b10 EFLAGS: 00010246
[  962.194081] RAX: ffffa0b5d39c5790 RBX: 0000000000000600 RCX: ffffa0b5e610e018
[  962.201212] RDX: 0000000000000001 RSI: ffffa0b5d39c5700 RDI: ffffbb2243de9000
[  962.208346] RBP: ffffbb2243de9000 R08: 0000000000000001 R09: 0000000000000001
[  962.215481] R10: ffffa0b4c0000000 R11: ffffa0b5d39c5700 R12: ffffbb2243df22d8
[  962.222612] R13: ffffa0b5d3b22880 R14: 0000000000000002 R15: ffffa0b5c884b018
[  962.229745] FS:  00007fdaf5177640(0000) GS:ffffa0b92fc40000(0000) knlGS:0000000000000000
[  962.237830] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  962.243577] CR2: 0000000000000000 CR3: 000000014ef9e004 CR4: 00000000007726e0
[  962.250710] PKRU: 55555554
[  962.253422] Call Trace:
[  962.255879]  <TASK>
[  962.257992]  ept_fetch+0x504/0x5a0 [kvm]
[  962.261959]  ept_page_fault+0x2d7/0x300 [kvm]
[  962.266362]  ? kvm_mmu_slot_gfn_write_protect+0xb1/0xd0 [kvm]
[  962.272150]  ? kvm_slot_page_track_add_page+0x5b/0x90 [kvm]
[  962.277766]  ? kvm_mmu_alloc_shadow_page+0x33c/0x3c0 [kvm]
[  962.283297]  ? mmu_alloc_root+0x9d/0xf0 [kvm]
[  962.287701]  kvm_mmu_page_fault+0x258/0x290 [kvm]
[  962.292451]  vmx_handle_exit+0xe/0x40 [kvm_intel]
[  962.297173]  vcpu_enter_guest+0x665/0xfc0 [kvm]
[  962.301741]  ? vmx_check_nested_events+0x12d/0x2e0 [kvm_intel]
[  962.307580]  vcpu_run+0x33/0x250 [kvm]
[  962.311367]  kvm_arch_vcpu_ioctl_run+0xf7/0x460 [kvm]
[  962.316456]  kvm_vcpu_ioctl+0x271/0x670 [kvm]
[  962.320843]  __x64_sys_ioctl+0x87/0xc0
[  962.324602]  do_syscall_64+0x38/0x90
[  962.328192]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  962.333252] RIP: 0033:0x7fdaf7d073fb
[  962.336832] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d fd 29 0f 00 f7 d8 64 89 01 48
[  962.355578] RSP: 002b:00007fdaf51767b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  962.363148] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007fdaf7d073fb
[  962.370286] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000c
[  962.377417] RBP: 000055a84ef30900 R08: 000055a84d638be0 R09: 0000000000000000
[  962.384550] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  962.391685] R13: 000055a84d65e0ce R14: 00007fdaf7c8d810 R15: 0000000000000000
[  962.398818]  </TASK>
[  962.401009] ---[ end trace 0000000000000000 ]---
[ 1213.265975] ------------[ cut here ]------------

which can hopefully give a hint on where the real issue is ...

-- 
Vitaly

