Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7381DFD4E
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 07:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbgEXFRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 May 2020 01:17:44 -0400
Received: from ns3.fnarfbargle.com ([103.4.19.87]:52660 "EHLO
        ns3.fnarfbargle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgEXFRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 May 2020 01:17:43 -0400
X-Greylist: delayed 1578 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 May 2020 01:17:41 EDT
Received: from srv.home ([10.8.0.1] ident=heh12491)
        by ns3.fnarfbargle.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <lists2009@fnarfbargle.com>)
        id 1jciaX-0005sw-GZ; Sun, 24 May 2020 12:50:17 +0800
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fnarfbargle.com; s=mail;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:Message-ID:Subject:From:To; bh=OdOLP0WvRHgcmPIHB1HDDaR0+7pMLS8Inh/6tqYLjpM=;
        b=b227SeaIBIC7nDb5U/miwFBGJZSRWhHlcUKvs5fefVuKTlaqZ0Mfw5k+gzxhk/vFTX+qfDO+y99yzV8iWSB+XyRH+9Diw265kvtAP5ks9OC1jBINVMzaEXBj1Auv+8oHLldt6mRXnIrYazayndC7YrXJBEAUIrwI6oIbm7M+k48=;
To:     kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From:   Brad Campbell <lists2009@fnarfbargle.com>
Subject: KVM broken after suspend in most recent kernels.
Message-ID: <1f7a85cc-38a6-2a2e-cbe3-a5b9970b7b92@fnarfbargle.com>
Date:   Sun, 24 May 2020 12:50:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

G'day all.

Machine is a Macbook Pro Retina ~ 2014. Kernels are always vanilla kernel and compiled on the machine. No additional patches.

vendor_id	: GenuineIntel
cpu family	: 6
model		: 69
model name	: Intel(R) Core(TM) i5-4278U CPU @ 2.60GHz
stepping	: 1
microcode	: 0x25
cpu MHz		: 2795.034
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 2
apicid		: 3
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm cpuid_fault epb invpcid_single ssbd ibrs ibpb stibp tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt dtherm ida arat pln pts md_clear flush_l1d
vmx flags	: vnmi preemption_timer invvpid ept_x_only ept_ad ept_1gb flexpriority tsc_offset vtpr mtf vapic ept vpid unrestricted_guest ple
bugs		: cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf mds swapgs itlb_multihit
bogomips	: 5199.87
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual


KVM worked fine in kernels somewhere prior to 5.4-5.5.

KVM works fine in later kernels up to and including 5.7.0-rc6 after a clean boot. It does not work after a suspend.

I can't actually bisect this because there is a bug in earlier kernels that breaks the suspend method used which requires manual patching to work around.

This is using qemu version 5.0.0, but also happens with 4.2.0.

In kernels earlier than 5.7 it results in either an immediate hard lock, or a GPF that results in progressive system freeze until a hard reboot is required (won't flush to disk so no logs get recorded and I have no serial or netconsole ability). In 5.7-rc6 it results in the following trace and thankfully no further issues (so I can get the logs and report it).

I can and will perform any required testing and debugging, but this machine suspends with pm-utils s2both, and that is broken between about 5.4 & 5.6 due to swapfile locking issues, which makes actual bisection very, very difficult as it *requires* a suspend/resume to trigger the bug.

[  227.715173] ------------[ cut here ]------------
[  227.715176] VMXON faulted, MSR_IA32_FEAT_CTL (0x3a) = 0x4
[  227.715194] WARNING: CPU: 0 PID: 5502 at arch/x86/kvm/vmx/vmx.c:2239 hardware_enable+0x167/0x180 [kvm_intel]
[  227.715195] Modules linked in: brcmfmac xhci_pci xhci_hcd cmac bnep iptable_nat xt_MASQUERADE nf_nat nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd bridge stp llc appletouch brcmutil snd_hda_codec_hdmi sha256_ssse3 snd_hda_codec_cirrus snd_hda_codec_generic sha256_generic libsha256 x86_pkg_temp_thermal coretemp btusb kvm_intel btrtl kvm btbcm btintel irqbypass bluetooth cfg80211 snd_hda_intel ecdh_generic ecc snd_intel_dspcfg bcm5974 rfkill snd_hda_codec snd_hwdep snd_hda_core snd_pcm_oss snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi i915 snd_seq snd_seq_device snd_timer i2c_algo_bit iosf_mbi drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops snd drm intel_gtt agpgart evdev apple_bl video soundcore hid_apple usb_storage hid_generic usbhid hid dm_crypt dm_mod i2c_i801 i2c_core sg usbcore usb_common [last unloaded: xhci_hcd]
[  227.715221] CPU: 0 PID: 5502 Comm: qemu Not tainted 5.7.0-rc6+ #15
[  227.715222] Hardware name: Apple Inc. MacBookPro11,1/Mac-189A3D4F975D5FFC, BIOS 159.0.0.0.0 02/05/2020
[  227.715225] RIP: 0010:hardware_enable+0x167/0x180 [kvm_intel]
[  227.715227] Code: 01 00 01 b9 3a 00 00 00 0f 32 31 c9 48 c1 e2 20 be ef be ad de 48 c7 c7 68 fd bb c0 48 09 c2 85 c9 48 0f 44 f2 e8 43 78 4f dc <0f> 0b eb 8a 48 8b 15 ce 89 06 dd e9 c7 fe ff ff 66 0f 1f 84 00 00
[  227.715228] RSP: 0018:ffff97091d873df8 EFLAGS: 00010092
[  227.715229] RAX: 000000000000002d RBX: 0000000000000046 RCX: 0000000000000007
[  227.715230] RDX: 0000000000000007 RSI: 0000000000000082 RDI: ffff97091f2187a0
[  227.715231] RBP: ffff97091d873e10 R08: 0000000000000008 R09: 0000000000000495
[  227.715232] R10: 0000000000000010 R11: ffff97091d873c6d R12: 0000000000000000
[  227.715233] R13: 0000000000000286 R14: ffffb5d08015e010 R15: 0000000000000000
[  227.715234] FS:  00007f1468fd33c0(0000) GS:ffff97091f200000(0000) knlGS:0000000000000000
[  227.715235] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  227.715236] CR2: 0000563b54c7201d CR3: 000000043f43f001 CR4: 00000000001626f0
[  227.715237] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  227.715238] DR3: 0000000000000080 DR6: 00000000ffff0ff0 DR7: 0000000020000400
[  227.715238] Call Trace:
[  227.715251]  kvm_arch_hardware_enable+0x65/0x230 [kvm]
[  227.715257]  hardware_enable_nolock+0x2f/0x60 [kvm]
[  227.715262]  ? __kvm_write_guest_page+0x60/0x60 [kvm]
[  227.715266]  on_each_cpu+0x34/0x40
[  227.715271]  kvm_dev_ioctl+0x63a/0x6c0 [kvm]
[  227.715275]  ? do_sys_openat2+0x1a7/0x2d0
[  227.715277]  ksys_ioctl+0x70/0xb0
[  227.715279]  ? vtime_user_exit+0x1b/0x60
[  227.715280]  __x64_sys_ioctl+0x15/0x20
[  227.715282]  do_syscall_64+0x4f/0x190
[  227.715284]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  227.715285] RIP: 0033:0x7f146ba30427
[  227.715287] Code: 00 00 90 48 8b 05 69 aa 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 aa 0c 00 f7 d8 64 89 01 48
[  227.715288] RSP: 002b:00007fff63e4e898 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  227.715290] RAX: ffffffffffffffda RBX: 000000000000ae01 RCX: 00007f146ba30427
[  227.715292] RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 000000000000000c
[  227.715293] RBP: 0000000000000000 R08: 0000563b55030de0 R09: 0000000000000001
[  227.715294] R10: 0000563b54da1010 R11: 0000000000000246 R12: 0000563b55081d60
[  227.715295] R13: 000000000000000c R14: 0000000000000000 R15: 00007fff63e4ea80
[  227.715297] ---[ end trace 0ce5d8cb29fff4bc ]---
[  227.715299] kvm: enabling virtualization on CPU0 failed

Regards,
Brad
