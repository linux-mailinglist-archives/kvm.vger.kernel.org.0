Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE241C662C
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 05:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgEFDAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 23:00:16 -0400
Received: from mga03.intel.com ([134.134.136.65]:31103 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgEFDAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 23:00:16 -0400
IronPort-SDR: TDbv5o5vXWe0dK07dt+M9FGQ7JyvGbvm5jUdcjJP+2AQonz+lb2UAzPtkiVGBYqZHljkO6OqP4
 W+ZfZhch7iKQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2020 20:00:15 -0700
IronPort-SDR: qTrE8SjvnR1KSj13RKd6pEyQFEFwKY97RkhzzshsSFob51h370j75UanlXHNlaJhOPx4x7tblL
 lQNunDOB0hiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,357,1583222400"; 
   d="scan'208";a="304669679"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by FMSMGA003.fm.intel.com with ESMTP; 05 May 2020 20:00:15 -0700
Date:   Tue, 5 May 2020 20:00:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Qian Cai <cai@lca.pw>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Intel KVM entry failed, hardware error 0x0
Message-ID: <20200506030014.GB19271@linux.intel.com>
References: <014D7571-6281-457C-9CF3-693809E9F651@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <014D7571-6281-457C-9CF3-693809E9F651@lca.pw>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 05, 2020 at 10:32:15PM -0400, Qian Cai wrote:
> Today’s linux-next started to fail with this config,
> 
> https://raw.githubusercontent.com/cailca/linux-mm/master/kcsan.config
> 
> qemu-kvm-2.12.0-99.module+el8.2.0+5827+8c39933c.x86_64
> 
> I believe it was working yesterday. Before I bury myself bisecting it, does
> anyone have any thought?

It reproduces for me as well with my vanilla config in a VM.  I can debug
and/or bisect, should be quite quick in a VM.

VM is bailing on the EPT Violation at the reset vector, i.e. on the very
first exit.  Presumably KVM is incorrectly setting vmx->fail somewhere.

> # /usr/libexec/qemu-kvm -name ubuntu-18.04-server-cloudimg -cpu host -smp 2 -m 2G -hda ubuntu-18.04-server-cloudimg.qcow2 -cdrom ubuntu-18.04-server-cloudimg.iso -nic user,hostfwd=tcp::2222-:22 -nographic
> 
> KVM: entry failed, hardware error 0x0
> EAX=00000000 EBX=00000000 ECX=00000000 EDX=000306f2
> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
> EIP=0000fff0 EFL=00010002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0000 00000000 0000ffff 00009300
> CS =f000 ffff0000 0000ffff 00009b00
> SS =0000 00000000 0000ffff 00009300
> DS =0000 00000000 0000ffff 00009300
> FS =0000 00000000 0000ffff 00009300
> GS =0000 00000000 0000ffff 00009300
> LDT=0000 00000000 0000ffff 00008200
> TR =0000 00000000 0000ffff 00008b00
> GDT=     00000000 0000ffff
> IDT=     00000000 0000ffff
> CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000000
> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000 
> DR6=00000000ffff0ff0 DR7=0000000000000400
> EFER=0000000000000000
> 
> [28040.962363][T78789] *** Guest State ***
> [28040.981990][T78789] CR0: actual=0x0000000000000030, shadow=0x0000000060000010, gh_mask=fffffffffffffff7
> [28041.030248][T78789] CR4: actual=0x0000000000002040, shadow=0x0000000000000000, gh_mask=ffffffffffffe871
> [28041.075900][T78789] CR3 = 0x0000000000000000
> [28041.096369][T78789] RSP = 0x0000000000000000  RIP = 0x000000000000fff0
> [28041.127519][T78789] RFLAGS=0x00010002         DR7 = 0x0000000000000400
> [28041.158730][T78789] Sysenter RSP=0000000000000000 CS:RIP=0000:0000000000000000
> [28041.193409][T78789] CS:   sel=0xf000, attr=0x0009b, limit=0x0000ffff, base=0x00000000ffff0000
> [28041.234135][T78789] DS:   sel=0x0000, attr=0x00093, limit=0x0000ffff, base=0x0000000000000000
> [28041.274796][T78789] SS:   sel=0x0000, attr=0x00093, limit=0x0000ffff, base=0x0000000000000000
> [28041.315631][T78789] ES:   sel=0x0000, attr=0x00093, limit=0x0000ffff, base=0x0000000000000000
> [28041.357025][T78789] FS:   sel=0x0000, attr=0x00093, limit=0x0000ffff, base=0x0000000000000000
> [28041.397808][T78789] GS:   sel=0x0000, attr=0x00093, limit=0x0000ffff, base=0x0000000000000000
> [28041.438806][T78789] GDTR:                           limit=0x0000ffff, base=0x0000000000000000
> [28041.479557][T78789] LDTR: sel=0x0000, attr=0x00082, limit=0x0000ffff, base=0x0000000000000000
> [28041.522599][T78789] IDTR:                           limit=0x0000ffff, base=0x0000000000000000
> [28041.564289][T78789] TR:   sel=0x0000, attr=0x0008b, limit=0x0000ffff, base=0x0000000000000000
> [28041.604705][T78789] EFER =     0x0000000000000000  PAT = 0x0007040600070406
> [28041.638146][T78789] DebugCtl = 0x0000000000000000  DebugExceptions = 0x0000000000000000
> [28041.676235][T78789] Interruptibility = 00000000  ActivityState = 00000000
> [28041.709019][T78789] InterruptStatus = 0000
> [28041.728432][T78789] *** Host State ***
> [28041.746774][T78789] RIP = 0xffffffffc05ab620  RSP = 0xffffb24ec6c9fb08
> [28041.777531][T78789] CS=0010 SS=0018 DS=0000 ES=0000 FS=0000 GS=0000 TR=0040
> [28041.811313][T78789] FSBase=00007f697ffff700 GSBase=ffff8d799f980000 TRBase=fffffe00001e0000
> [28041.851017][T78789] GDTBase=fffffe00001de000 IDTBase=fffffe0000000000
> [28041.881294][T78789] CR0=0000000080050033 CR3=00000008802c8003 CR4=00000000001626e0
> [28041.917895][T78789] Sysenter RSP=0000000000000000 CS:RIP=0000:0000000000000000
> [28041.953737][T78789] EFER = 0x0000000000000d01  PAT = 0x0007040600070406
> [28041.986043][T78789] *** Control State ***
> [28042.006510][T78789] PinBased=000000ff CPUBased=b5a06dfa SecondaryExec=000037eb
> [28042.043823][T78789] EntryControls=0000d1ff ExitControls=002befff
> [28042.074416][T78789] ExceptionBitmap=00060042 PFECmask=00000000 PFECmatch=00000000
> [28042.110314][T78789] VMEntry: intr_info=00000000 errcode=00000000 ilen=00000000
> [28042.144970][T78789] VMExit: intr_info=00000000 errcode=00000000 ilen=00000003
> [28042.178829][T78789]         reason=00000030 qualification=0000000000000184
> [28042.211619][T78789] IDTVectoring: info=00000000 errcode=00000000
> [28042.240511][T78789] TSC Offset = 0xffffbe0284927b21
> [28042.264284][T78789] SVI|RVI = 00|00 TPR Threshold = 0x00
> [28042.289414][T78789] APIC-access addr = 0x0000000e5dfc0000 virt-APIC addr = 0x0000000d2e76c000
> [28042.330409][T78789] PostedIntrVec = 0xf2
> [28042.349513][T78789] EPT pointer = 0x000000105a27005e
> [28042.372955][T78789] PLE Gap=00000080 Window=00001000
> [28042.396744][T78789] Virtual processor ID = 0x0001
> 
> # lscpu
> Architecture:        x86_64
> CPU op-mode(s):      32-bit, 64-bit
> Byte Order:          Little Endian
> CPU(s):              48
> On-line CPU(s) list: 0-47
> Thread(s) per core:  1
> Core(s) per socket:  12
> Socket(s):           4
> NUMA node(s):        4
> Vendor ID:           GenuineIntel
> CPU family:          6
> Model:               63
> Model name:          Intel(R) Xeon(R) CPU E5-4650 v3 @ 2.10GHz
> Stepping:            2
> CPU MHz:             1400.623
> BogoMIPS:            4195.13
> Virtualization:      VT-x
> L1d cache:           32K
> L1i cache:           32K
> L2 cache:            256K
> L3 cache:            30720K
> NUMA node0 CPU(s):   0-5,24-29
> NUMA node1 CPU(s):   6-11,30-35
> NUMA node2 CPU(s):   12-17,36-41
> NUMA node3 CPU(s):   18-23,42-47
> Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm cpuid_fault epb invpcid_single pti intel_ppin ssbd ibrs ibpb stibp tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid cqm xsaveopt cqm_llc cqm_occup_llc dtherm arat pln pts flush_l1d
