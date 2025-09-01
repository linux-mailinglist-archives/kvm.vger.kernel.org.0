Return-Path: <kvm+bounces-56432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D425B3DE82
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 11:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8954441B48
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 09:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B27D3101A5;
	Mon,  1 Sep 2025 09:27:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAEB30F806;
	Mon,  1 Sep 2025 09:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756718839; cv=none; b=flJceEXpNZFRy1C57JvlLs+se9Vnkfp/X8tzC5OuGxO2UYG3M4tmQczhZsXRb3WjWfgtlDGBpYF4bHycYpE1ssiX2RYX7CwmpYTpthMuapgE5oB3A6IJwn+PsMNuKH6WY1175OsW3e/HV9lRa95O3P0GYwdcbtsVE6kU+Uq8vvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756718839; c=relaxed/simple;
	bh=cVnJmyKbJcrjuroTgvsCd/AZ72fSNfmINUeviX0Y3GQ=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=JjjO8Iwq77dQXKAPd0j8ZseVxCaFgQ0TBKmQ9Qgx92jaBtCSjvGgNMOwZ1Hk5jvKCNw9JlNm+p6dUwY4xlsFJGVansLpvzALT5oK77xrvf3WUy7SZkXVX7b+P1nw8yR2jlkzCt7czpxveRfpiUXDwxhgIXX6emT2fKgi4jeByY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Sean Christopherson <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "vkuznets@redhat.com"
	<vkuznets@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: Re: [PATCH][v2] x86/kvm: Prefer native qspinlock for dedicated
 vCPUs irrespective of PV_UNHALT
Thread-Topic: Re: [PATCH][v2] x86/kvm: Prefer native qspinlock for dedicated
 vCPUs irrespective of PV_UNHALT
Thread-Index: AdwbG/HMUtBRY5omSk6mu9n6xebeVA==
Date: Mon, 1 Sep 2025 09:26:01 +0000
Message-ID: <32e96c5cea544b1282d4f91ba0250486@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.50.48
X-FE-Policy-ID: 52:10:53:SYSTEM

> > The commit b2798ba0b876 ("KVM: X86: Choose qspinlock when dedicated
> > physical CPUs are available") states that when PV_DEDICATED=3D1 (vCPU
> > has dedicated pCPU), qspinlock should be preferred regardless of
> > PV_UNHALT.  However, the current implementation doesn't reflect this:
> > when PV_UNHALT=3D0, we still use virt_spin_lock() even with dedicated p=
CPUs.
> >
> > This is suboptimal because:
> > 1. Native qspinlocks should outperform virt_spin_lock() for dedicated
> >    vCPUs irrespective of HALT exiting
> > 2. virt_spin_lock() should only be preferred when vCPUs may be preempte=
d
> >    (non-dedicated case)
> >
> > So reorder the PV spinlock checks to:
> > 1. First handle dedicated pCPU case (disable virt_spin_lock_key) 2.
> > Second check single CPU, and nopvspin configuration 3. Only then check
> > PV_UNHALT support
> >
> > This ensures we always use native qspinlock for dedicated vCPUs,
> > delivering pretty performance gains at high contention levels.
> >
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > ---
>=20
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Thanks for review

And ping


This patch optimizes performance. For example, when executing the following=
 commands in a VM with 180 vCPU:

ip link add dev vm1 type veth peer name vm2 && ip link del vm1,

and then measuring the runtime of tlb_finish_mmu using :

funcslower-bpfcc -t tlb_finish_mmu,

it was observed that the execution time of tlb_finish_mmu called by systemd=
-udevd has been significantly reduced.

The improvement is attributed to the fact that the" ip link add " command t=
riggers the forking of 260 systemd-udevd processes,
When these processes exit, they need to release memory, which previously ca=
used intense contention on the spinlock.

65.08%65.08% systemd-udevd [kernel.kallsyms]
- 63.27% entry_SYSCALL_64_after_hwframe
do_syscall_64
x64_sys_exit_group
do_group_exit
- do_exit
    -62.93% mmput
        - 52.15% tlb_finish_mmu
            -51.05% _page_cache_release
                     folio_lruvec_lock_irqsave
                     raw_spin_lock_irqsave
                     queued_spin_lock_slowpath
This patch alleviates that contention, resulting in significantly reduced e=
xecution time


Without this patch:
/usr/share/bcc/tools/funcslower -t tlb_finish_mmu
Tracing function calls slower than 1 ms... Ctrl+C to quit.
TIME       COMM           PID    LAT(ms)             RVAL FUNC
0.000000   systemd-udevd  6729     16.78 ffff9d360e270000 tlb_finish_mmu
0.003151   systemd-udevd  6625     20.55 ffff9d361079bf00 tlb_finish_mmu
-0.000884  systemd-udevd  6648      5.70 ffff9d3622af9f80 tlb_finish_mmu
0.000680   systemd-udevd  6716     19.37 ffff9d3623b2b9c0 tlb_finish_mmu
0.000797   systemd-udevd  6709      8.61 ffff9d3623b29500 tlb_finish_mmu
0.000737   systemd-udevd  6959      8.29 ffff9d367057c440 tlb_finish_mmu
0.000692   systemd-udevd  6946     22.88 ffff9d3670578000 tlb_finish_mmu
0.002872   systemd-udevd  6971     13.00 ffff9d3672be0540 tlb_finish_mmu
-0.000652  systemd-udevd  6957     22.52 ffff9d367057b9c0 tlb_finish_mmu
0.002851   systemd-udevd  6942     21.17 ffff9d366d016900 tlb_finish_mmu
0.000753   systemd-udevd  6638     10.42 ffff9d361079aa00 tlb_finish_mmu
-0.000647  systemd-udevd  6891      7.55 ffff9d364e7fd940 tlb_finish_mmu
0.000508   systemd-udevd  6689     24.69 ffff9d364de12a00 tlb_finish_mmu
-0.000702  systemd-udevd  6646     11.20 ffff9d3610798000 tlb_finish_mmu
-0.000691  systemd-udevd  6699     16.67 ffff9d364de15e80 tlb_finish_mmu
-0.000596  systemd-udevd  6855     16.24 ffff9d36136e1a40 tlb_finish_mmu
-0.000472  systemd-udevd  6733     11.91 ffff9d360e271500 tlb_finish_mmu
0.000820   systemd-udevd  6779     21.90 ffff9d3608878a80 tlb_finish_mmu
-0.000685  systemd-udevd  6961     11.39 ffff9d367057cec0 tlb_finish_mmu
-0.000751  systemd-udevd  6660     13.96 ffff9d3611d20fc0 tlb_finish_mmu
0.003537   systemd-udevd  6754     11.10 ffff9d36330e0540 tlb_finish_mmu
-0.000646  systemd-udevd  6865     20.77 ffff9d36136e4ec0 tlb_finish_mmu
-0.000869  systemd-udevd  6796     17.69 ffff9d360887e3c0 tlb_finish_mmu
0.000000   systemd-udevd  6851     22.57 ffff9d36136e0540 tlb_finish_mmu
0.000087   systemd-udevd  6955     21.41 ffff9d367057af40 tlb_finish_mmu
-0.000931  systemd-udevd  6680     17.82 ffff9d3611d278c0 tlb_finish_mmu
0.000584   systemd-udevd  6652     18.40 ffff9d3622afb9c0 tlb_finish_mmu
0.000104   systemd-udevd  6615     19.56 ffff9d361079b480 tlb_finish_mmu
0.000247   systemd-udevd  6856     34.70 ffff9d36136e1f80 tlb_finish_mmu
-0.000858  systemd-udevd  6667      7.08 ffff9d3611d23480 tlb_finish_mmu
0.000618   systemd-udevd  6663     19.93 ffff9d3611d21f80 tlb_finish_mmu
0.003469   systemd-udevd  6755     18.14 ffff9d36330e0a80 tlb_finish_mmu
-0.000106  systemd-udevd  6824      9.65 ffff9d36118a7380 tlb_finish_mmu
0.000626   systemd-udevd  6835     18.65 ffff9d3635b92f40 tlb_finish_mmu
0.003886   systemd-udevd  6748     26.47 ffff9d360e2763c0 tlb_finish_mmu
-0.000263  systemd-udevd  7034      9.30 ffff9d3676585400 tlb_finish_mmu
0.000001   systemd-udevd  6801     24.79 ffff9d36118a0000 tlb_finish_mmu
-0.000684  systemd-udevd  6912     11.74 ffff9d360f9a4980 tlb_finish_mmu
0.002761   systemd-udevd  7037     21.80 ffff9d36765863c0 tlb_finish_mmu
0.000608   systemd-udevd  6880     34.60 ffff9d364e7f9f80 tlb_finish_mmu
-0.001127  systemd-udevd  7036      6.36 ffff9d3676585e80 tlb_finish_mmu
0.002302   systemd-udevd  6854     15.66 ffff9d36136e1500 tlb_finish_mmu
0.006186   systemd-udevd  6700     18.35 ffff9d364de163c0 tlb_finish_mmu
0.003561   systemd-udevd  6642     31.53 ffff9d3610799a40 tlb_finish_mmu
-0.000599  systemd-udevd  6857      6.23 ffff9d36136e24c0 tlb_finish_mmu
-0.000160  systemd-udevd  6922     18.66 ffff9d366d010000 tlb_finish_mmu
0.003402   systemd-udevd  6831     16.64 ffff9d3635b91a40 tlb_finish_mmu
0.003423   systemd-udevd  6868      6.37 ffff9d36136e5e80 tlb_finish_mmu
0.000738   systemd-udevd  6920     20.25 ffff9d360f9a7380 tlb_finish_mmu
0.000518   systemd-udevd  6686     21.63 ffff9d364de11a40 tlb_finish_mmu
0.003301   systemd-udevd  6864     25.14 ffff9d36136e4980 tlb_finish_mmu
0.003331   systemd-udevd  6616     29.77 ffff9d361079b9c0 tlb_finish_mmu
0.006603   systemd-udevd  6670     28.19 ffff9d3611d24440 tlb_finish_mmu
0.003591   systemd-udevd  6743      7.75 ffff9d360e274980 tlb_finish_mmu
0.000196   systemd-udevd  7019     21.39 ffff9d3676580540 tlb_finish_mmu
-0.000274  systemd-udevd  6944     13.34 ffff9d366d017380 tlb_finish_mmu
0.003121   systemd-udevd  7028     29.72 ffff9d3676583480 tlb_finish_mmu
-0.000809  systemd-udevd  6904     14.59 ffff9d360f9a1f80 tlb_finish_mmu
0.003006   systemd-udevd  6982     22.20 ffff9d3672be3f00 tlb_finish_mmu
0.000494   systemd-udevd  6720     26.88 ffff9d3623b2cec0 tlb_finish_mmu
-0.000978  systemd-udevd  6732     17.39 ffff9d360e270fc0 tlb_finish_mmu
-0.000640  systemd-udevd  6886     21.66 ffff9d364e7fbf00 tlb_finish_mmu
-0.000390  systemd-udevd  6672     20.02 ffff9d3611d24ec0 tlb_finish_mmu
-0.000693  systemd-udevd  6788     18.70 ffff9d360887b9c0 tlb_finish_mmu
0.002576   systemd-udevd  6703     28.31 ffff9d364de17380 tlb_finish_mmu
0.000155   systemd-udevd  6647     15.55 ffff9d3622afe900 tlb_finish_mmu
0.000206   systemd-udevd  6661      9.24 ffff9d3611d21500 tlb_finish_mmu
-0.000772  systemd-udevd  6781     19.51 ffff9d3608879500 tlb_finish_mmu
0.000478   systemd-udevd  6725     21.27 ffff9d3623b2e900 tlb_finish_mmu
0.000056   systemd-udevd  7023     20.79 ffff9d3676581a40 tlb_finish_mmu
0.003621   systemd-udevd  6712     31.55 ffff9d3623b2a4c0 tlb_finish_mmu
-0.000189  systemd-udevd  6791     21.62 ffff9d360887c980 tlb_finish_mmu
-0.001408  systemd-udevd  6987     11.82 ffff9d3672be5940 tlb_finish_mmu
0.002166   systemd-udevd  6691     14.09 ffff9d364de13480 tlb_finish_mmu
0.002882   systemd-udevd  6874     17.12 ffff9d364e7f8000 tlb_finish_mmu
0.002898   systemd-udevd  6737     27.77 ffff9d360e272a00 tlb_finish_mmu
0.000044   systemd-udevd  6696     31.57 ffff9d364de14ec0 tlb_finish_mmu
-0.000151  systemd-udevd  6784     24.40 ffff9d360887a4c0 tlb_finish_mmu
0.002642   systemd-udevd  6683     24.43 ffff9d364de10a80 tlb_finish_mmu
0.006029   systemd-udevd  6807     26.26 ffff9d36118a1f80 tlb_finish_mmu
0.003338   systemd-udevd  6739     28.89 ffff9d360e273480 tlb_finish_mmu
0.000753   systemd-udevd  6750     22.14 ffff9d360e276e40 tlb_finish_mmu
0.000608   systemd-udevd  6842     33.75 ffff9d3635b95400 tlb_finish_mmu
0.006855   systemd-udevd  6909     25.12 ffff9d360f9a39c0 tlb_finish_mmu
-0.000881  systemd-udevd  6731     33.24 ffff9d360e270a80 tlb_finish_mmu
0.008335   systemd-udevd  6702     23.27 ffff9d364de16e40 tlb_finish_mmu
0.000785   systemd-udevd  6813     29.53 ffff9d36118a39c0 tlb_finish_mmu
-0.000861  systemd-udevd  6761     29.79 ffff9d36330e2a00 tlb_finish_mmu
0.002783   systemd-udevd  6727     23.40 ffff9d3623b2f380 tlb_finish_mmu
-0.000701  systemd-udevd  6818     36.66 ffff9d36118a5400 tlb_finish_mmu
0.000476   systemd-udevd  6723     27.64 ffff9d3623b2de80 tlb_finish_mmu
0.000801   systemd-udevd  6862     30.04 ffff9d36136e3f00 tlb_finish_mmu
0.006311   systemd-udevd  6777     28.92 ffff9d3608878000 tlb_finish_mmu
-0.000791  systemd-udevd  6969     25.57 ffff9d367057f8c0 tlb_finish_mmu
-0.000634  systemd-udevd  6881     28.49 ffff9d364e7fa4c0 tlb_finish_mmu
0.000102   systemd-udevd  6626     27.41 ffff9d361079c440 tlb_finish_mmu
-0.000115  systemd-udevd  6706     25.58 ffff9d3623b28540 tlb_finish_mmu
-0.000832  systemd-udevd  6708     34.49 ffff9d3623b28fc0 tlb_finish_mmu
-0.000718  systemd-udevd  6658     24.72 ffff9d3611d20540 tlb_finish_mmu
-0.000572  systemd-udevd  6976     24.32 ffff9d3672be1f80 tlb_finish_mmu
-0.000720  systemd-udevd  6697     23.91 ffff9d364de15400 tlb_finish_mmu
-0.000742  systemd-udevd  6632     26.28 ffff9d361079e3c0 tlb_finish_mmu
-0.000583  systemd-udevd  7039     30.21 ffff9d3676586e40 tlb_finish_mmu
0.000297   systemd-udevd  6907     30.73 ffff9d360f9a2f40 tlb_finish_mmu
-0.000105  systemd-udevd  6852     24.41 ffff9d36136e0a80 tlb_finish_mmu
0.000147   systemd-udevd  6789     30.38 ffff9d360887bf00 tlb_finish_mmu
-0.000733  systemd-udevd  6770     33.37 ffff9d36330e5940 tlb_finish_mmu
-0.000163  systemd-udevd  6821     25.82 ffff9d36118a63c0 tlb_finish_mmu
-0.000511  systemd-udevd  6837     29.28 ffff9d3635b939c0 tlb_finish_mmu
-0.000663  systemd-udevd  6817     24.10 ffff9d36118a4ec0 tlb_finish_mmu
-0.000364  systemd-udevd  6640     25.26 ffff9d3610799f80 tlb_finish_mmu
-0.000603  systemd-udevd  6657     36.44 ffff9d3611d20000 tlb_finish_mmu
-0.000315  systemd-udevd  6714     27.76 ffff9d3623b2af40 tlb_finish_mmu
0.003845   systemd-udevd  6639     26.33 ffff9d361079a4c0 tlb_finish_mmu
-0.000204  systemd-udevd  7000     23.03 ffff9d36743c9f80 tlb_finish_mmu
0.006056   systemd-udevd  6665     22.22 ffff9d3611d22a00 tlb_finish_mmu
-0.000383  systemd-udevd  6793     32.36 ffff9d360887d400 tlb_finish_mmu
0.000759   systemd-udevd  7018     23.29 ffff9d3676580000 tlb_finish_mmu
0.003367   systemd-udevd  7004     32.65 ffff9d36743cb480 tlb_finish_mmu
0.000634   systemd-udevd  6996     29.42 ffff9d36743c8a80 tlb_finish_mmu
0.003064   systemd-udevd  6666     27.84 ffff9d3611d22f40 tlb_finish_mmu
-0.000449  systemd-udevd  6775     36.26 ffff9d36330e7380 tlb_finish_mmu
-0.000171  systemd-udevd  6799     31.59 ffff9d360887f380 tlb_finish_mmu
0.004721   systemd-udevd  6914     30.84 ffff9d360f9a5400 tlb_finish_mmu
0.002777   systemd-udevd  6950     28.76 ffff9d3670579500 tlb_finish_mmu
0.000191   systemd-udevd  6641     23.59 ffff9d3610798540 tlb_finish_mmu
-0.000682  systemd-udevd  6685     33.30 ffff9d364de11500 tlb_finish_mmu
0.000090   systemd-udevd  6721     33.62 ffff9d3623b2d400 tlb_finish_mmu
-0.000820  systemd-udevd  7024     30.04 ffff9d3676581f80 tlb_finish_mmu
-0.000983  systemd-udevd  6983     35.35 ffff9d3672be4440 tlb_finish_mmu
-0.000327  systemd-udevd  6889     27.59 ffff9d364e7fcec0 tlb_finish_mmu
-0.000182  systemd-udevd  6906     32.01 ffff9d360f9a2a00 tlb_finish_mmu
0.000797   systemd-udevd  6844     37.50 ffff9d3635b95e80 tlb_finish_mmu
0.000803   systemd-udevd  6811     36.98 ffff9d36118a2f40 tlb_finish_mmu
0.013158   systemd-udevd  6948     25.03 ffff9d3670578a80 tlb_finish_mmu
0.000797   systemd-udevd  6980     36.55 ffff9d3672be3480 tlb_finish_mmu
-0.000700  systemd-udevd  6924     37.42 ffff9d366d010a80 tlb_finish_mmu
0.008477   systemd-udevd  6728     28.49 ffff9d3623b2f8c0 tlb_finish_mmu
0.003010   systemd-udevd  7015     35.14 ffff9d36743cee40 tlb_finish_mmu
-0.000204  systemd-udevd  6962     37.44 ffff9d367057d400 tlb_finish_mmu
0.000480   systemd-udevd  6785     36.75 ffff9d360887aa00 tlb_finish_mmu
-0.000594  systemd-udevd  6734     38.65 ffff9d360e271a40 tlb_finish_mmu
0.000044   systemd-udevd  6913     38.35 ffff9d360f9a4ec0 tlb_finish_mmu
0.003082   systemd-udevd  6713     35.60 ffff9d3623b2aa00 tlb_finish_mmu
-0.000298  systemd-udevd  6945     39.11 ffff9d366d0178c0 tlb_finish_mmu
0.006616   systemd-udevd  6960     32.08 ffff9d367057c980 tlb_finish_mmu
-0.000184  systemd-udevd  6943     38.75 ffff9d366d016e40 tlb_finish_mmu
0.003434   systemd-udevd  6634     35.59 ffff9d361079ee40 tlb_finish_mmu
0.003706   systemd-udevd  6783     35.37 ffff9d3608879f80 tlb_finish_mmu
0.000736   systemd-udevd  7022     38.77 ffff9d3676581500 tlb_finish_mmu
0.000224   systemd-udevd  6870     39.39 ffff9d36136e6900 tlb_finish_mmu
0.000383   systemd-udevd  6820     38.82 ffff9d36118a5e80 tlb_finish_mmu
-0.000301  systemd-udevd  7038     39.88 ffff9d3676586900 tlb_finish_mmu
0.003251   systemd-udevd  6688     37.49 ffff9d364de124c0 tlb_finish_mmu
0.013021   systemd-udevd  6787     27.80 ffff9d360887b480 tlb_finish_mmu
0.003078   systemd-udevd  6717     37.42 ffff9d3623b2bf00 tlb_finish_mmu
0.002616   systemd-udevd  6635     37.95 ffff9d361079f380 tlb_finish_mmu
0.013349   systemd-udevd  6798     26.86 ffff9d360887ee40 tlb_finish_mmu
0.003595   systemd-udevd  6832     36.50 ffff9d3635b91f80 tlb_finish_mmu
0.002551   systemd-udevd  7013     38.36 ffff9d36743ce3c0 tlb_finish_mmu
0.002298   systemd-udevd  6841     38.42 ffff9d3635b94ec0 tlb_finish_mmu
0.002976   systemd-udevd  6951     37.31 ffff9d3670579a40 tlb_finish_mmu
0.003535   systemd-udevd  6756     36.62 ffff9d36330e0fc0 tlb_finish_mmu
0.003325   systemd-udevd  6681     37.37 ffff9d364de10000 tlb_finish_mmu
0.000619   systemd-udevd  6674     40.32 ffff9d3611d25940 tlb_finish_mmu
0.010528   systemd-udevd  6829     30.44 ffff9d3635b90fc0 tlb_finish_mmu
0.002956   systemd-udevd  7003     38.10 ffff9d36743caf40 tlb_finish_mmu
-0.000427  systemd-udevd  6822     41.65 ffff9d36118a6900 tlb_finish_mmu
0.006227   systemd-udevd  6839     35.15 ffff9d3635b94440 tlb_finish_mmu
0.007950   systemd-udevd  6875     33.77 ffff9d364e7f8540 tlb_finish_mmu
0.006213   systemd-udevd  6776     35.31 ffff9d36330e78c0 tlb_finish_mmu
-0.000713  systemd-udevd  6953     42.36 ffff9d367057a4c0 tlb_finish_mmu
0.002900   systemd-udevd  6804     39.03 ffff9d36118a0fc0 tlb_finish_mmu
0.004817   systemd-udevd  6816     37.08 ffff9d36118a4980 tlb_finish_mmu
0.000585   systemd-udevd  6923     41.47 ffff9d366d010540 tlb_finish_mmu
0.000747   systemd-udevd  6628     41.26 ffff9d361079cec0 tlb_finish_mmu
-0.000730  systemd-udevd  6985     42.83 ffff9d3672be4ec0 tlb_finish_mmu
0.000616   systemd-udevd  6900     41.52 ffff9d360f9a0a80 tlb_finish_mmu
0.000115   systemd-udevd  6773     42.15 ffff9d36330e6900 tlb_finish_mmu
0.008288   systemd-udevd  6965     33.96 ffff9d367057e3c0 tlb_finish_mmu
0.001429   systemd-udevd  6795     40.86 ffff9d360887de80 tlb_finish_mmu
0.005457   systemd-udevd  6819     37.07 ffff9d36118a5940 tlb_finish_mmu
-0.000120  systemd-udevd  7029     43.52 ffff9d36765839c0 tlb_finish_mmu
0.000752   systemd-udevd  6802     42.63 ffff9d36118a0540 tlb_finish_mmu
0.010397   systemd-udevd  6933     33.50 ffff9d366d0139c0 tlb_finish_mmu
0.003019   systemd-udevd  6849     40.28 ffff9d3635b978c0 tlb_finish_mmu
0.000439   systemd-udevd  6759     42.80 ffff9d36330e1f80 tlb_finish_mmu
-0.000398  systemd-udevd  6654     44.28 ffff9d3622af8fc0 tlb_finish_mmu
0.004322   systemd-udevd  6846     38.80 ffff9d3635b96900 tlb_finish_mmu
0.003872   systemd-udevd  6894     39.08 ffff9d364e7fe900 tlb_finish_mmu
-0.000306  systemd-udevd  6848     43.95 ffff9d3635b97380 tlb_finish_mmu
-0.000523  systemd-udevd  6941     42.98 ffff9d366d0163c0 tlb_finish_mmu
0.009463   systemd-udevd  6707     33.45 ffff9d3623b28a80 tlb_finish_mmu
-0.000533  systemd-udevd  6765     44.08 ffff9d36330e3f00 tlb_finish_mmu
-0.000598  systemd-udevd  6637     43.93 ffff9d361079af40 tlb_finish_mmu
0.002298   systemd-udevd  6999     40.70 ffff9d36743c9a40 tlb_finish_mmu
0.015757   systemd-udevd  6931     28.69 ffff9d366d012f40 tlb_finish_mmu
0.000568   systemd-udevd  7021     44.15 ffff9d3676580fc0 tlb_finish_mmu

With this patch:
0.000000   systemd-udevd  47383     2.13 ffff914aa8720fc0 tlb_finish_mmu
0.000085   systemd-udevd  47544     2.22 ffff914b0b0d5400 tlb_finish_mmu
0.000097   systemd-udevd  47775     7.08 ffff914c6c2624c0 tlb_finish_mmu
0.000037   systemd-udevd  47682     6.31 ffff914c3d07b480 tlb_finish_mmu
0.002646   systemd-udevd  47418     5.77 ffff914a90ea4ec0 tlb_finish_mmu
0.000168   systemd-udevd  47739     2.28 ffff914bb72963c0 tlb_finish_mmu
0.000235   systemd-udevd  47456     2.11 ffff914d0a4d8540 tlb_finish_mmu
0.000161   systemd-udevd  47427     2.17 ffff914a90ea1f80 tlb_finish_mmu
0.000028   systemd-udevd  47576     2.19 ffff914c89f90000 tlb_finish_mmu
-0.000128  systemd-udevd  47727     2.10 ffff914bb72924c0 tlb_finish_mmu
0.000097   systemd-udevd  47481     2.15 ffff914bf3118540 tlb_finish_mmu
0.000098   systemd-udevd  47545     2.22 ffff914b0b0d5940 tlb_finish_mmu
0.000165   systemd-udevd  47504     2.10 ffff914cb6078000 tlb_finish_mmu
0.000149   systemd-udevd  47474     2.28 ffff914d0a4dde80 tlb_finish_mmu
0.000184   systemd-udevd  47613     2.19 ffff914b197f4440 tlb_finish_mmu
0.000238   systemd-udevd  47405     2.11 ffff914aa8723f00 tlb_finish_mmu
0.004843   systemd-udevd  47720     3.00 ffff914bb7290000 tlb_finish_mmu
0.000118   systemd-udevd  47549     7.77 ffff914b0b0d6e40 tlb_finish_mmu
-0.000110  systemd-udevd  47521     1.81 ffff914cb607d940 tlb_finish_mmu
0.000234   systemd-udevd  47495     2.07 ffff914bf311cec0 tlb_finish_mmu
-0.000039  systemd-udevd  47658     2.17 ffff914d1a4db480 tlb_finish_mmu
-0.000142  systemd-udevd  47595     1.68 ffff914c89f963c0 tlb_finish_mmu
0.000017   systemd-udevd  47450     2.23 ffff914a91f90000 tlb_finish_mmu
0.000085   systemd-udevd  47591     2.16 ffff914c89f94ec0 tlb_finish_mmu
0.000227   systemd-udevd  47644     2.24 ffff914c89c4e900 tlb_finish_mmu
0.000185   systemd-udevd  47490     2.25 ffff914bf311b480 tlb_finish_mmu
0.000060   systemd-udevd  47531     2.15 ffff914b0b0d0fc0 tlb_finish_mmu
0.000039   systemd-udevd  47586     2.15 ffff914c89f93480 tlb_finish_mmu
0.000227   systemd-udevd  47582     2.12 ffff914c89f91f80 tlb_finish_mmu
0.000102   systemd-udevd  47596     2.16 ffff914c89f96900 tlb_finish_mmu
0.000238   systemd-udevd  47466     6.59 ffff914d0a4db480 tlb_finish_mmu
0.002824   systemd-udevd  47519     5.87 ffff914cb607cec0 tlb_finish_mmu
0.000022   systemd-udevd  47417     2.12 ffff914a90ea0a80 tlb_finish_mmu
-0.000001  systemd-udevd  47648     2.26 ffff914d1a4d8000 tlb_finish_mmu
-0.000042  systemd-udevd  47588     1.98 ffff914c89f93f00 tlb_finish_mmu
0.000056   systemd-udevd  47557     2.25 ffff914c78de1a40 tlb_finish_mmu
0.000118   systemd-udevd  47402     2.16 ffff914aa8726900 tlb_finish_mmu
0.000105   systemd-udevd  47680     7.09 ffff914c3d07aa00 tlb_finish_mmu
0.002912   systemd-udevd  47571     5.83 ffff914c78de63c0 tlb_finish_mmu
0.000016   systemd-udevd  47673     2.18 ffff914c3d078540 tlb_finish_mmu
0.000187   systemd-udevd  47478     2.13 ffff914d0a4df380 tlb_finish_mmu
0.000161   systemd-udevd  47696     7.23 ffff914c8c2e8000 tlb_finish_mmu
0.003069   systemd-udevd  47601     5.76 ffff914b197f0540 tlb_finish_mmu
0.000113   systemd-udevd  47406     2.17 ffff914aa87239c0 tlb_finish_mmu
0.000215   systemd-udevd  47380     6.42 ffff914aa6710fc0 tlb_finish_mmu
0.002777   systemd-udevd  47426     5.82 ffff914a90ea63c0 tlb_finish_mmu
0.000207   systemd-udevd  47563     2.16 ffff914c78de39c0 tlb_finish_mmu
0.000001   systemd-udevd  47385     2.09 ffff914aa8722a00 tlb_finish_mmu
0.000006   systemd-udevd  47386     2.12 ffff914aa8724ec0 tlb_finish_mmu
0.000009   systemd-udevd  47438     2.12 ffff914a91f91500 tlb_finish_mmu
0.000100   systemd-udevd  47597     2.16 ffff914c89f96e40 tlb_finish_mmu
0.000188   systemd-udevd  47440     2.14 ffff914a91f95400 tlb_finish_mmu
0.000167   systemd-udevd  47551     6.24 ffff914b0b0d78c0 tlb_finish_mmu
0.002765   systemd-udevd  47719     5.75 ffff914c8c2ef8c0 tlb_finish_mmu
0.000096   systemd-udevd  47746     8.47 ffff914b639b8a80 tlb_finish_mmu
0.000064   systemd-udevd  47708     2.49 ffff914c8c2ebf00 tlb_finish_mmu
-0.000132  systemd-udevd  47442     1.70 ffff914a91f91a40 tlb_finish_mmu
0.000209   systemd-udevd  47439     2.17 ffff914a91f95940 tlb_finish_mmu
0.000040   systemd-udevd  47718     2.33 ffff914c8c2ef380 tlb_finish_mmu
-0.000159  systemd-udevd  47669     1.81 ffff914d1a4dee40 tlb_finish_mmu
0.000190   systemd-udevd  47677     2.17 ffff914c3d079a40 tlb_finish_mmu
0.000041   systemd-udevd  47684     2.21 ffff914c3d07bf00 tlb_finish_mmu
-0.000162  systemd-udevd  47569     1.53 ffff914c78de5940 tlb_finish_mmu
0.006547   systemd-udevd  47483     1.87 ffff914bf3118fc0 tlb_finish_mmu
0.000199   systemd-udevd  47662     2.19 ffff914d1a4dc980 tlb_finish_mmu
-0.000133  systemd-udevd  47664     1.98 ffff914d1a4dd400 tlb_finish_mmu
-0.000152  systemd-udevd  47671     1.72 ffff914d1a4df8c0 tlb_finish_mmu
0.001218   systemd-udevd  47548     1.23 ffff914b0b0d6900 tlb_finish_mmu
0.000027   systemd-udevd  47735     2.34 ffff914bb7294ec0 tlb_finish_mmu
-0.000163  systemd-udevd  47567     1.50 ffff914c78de4ec0 tlb_finish_mmu
0.006582   systemd-udevd  47699     1.83 ffff914c8c2e8fc0 tlb_finish_mmu
0.000192   systemd-udevd  47599     7.21 ffff914c89f978c0 tlb_finish_mmu
0.003121   systemd-udevd  47663     5.75 ffff914d1a4dcec0 tlb_finish_mmu
0.000139   systemd-udevd  47449     2.16 ffff914a91f939c0 tlb_finish_mmu
0.000124   systemd-udevd  47538     2.29 ffff914b0b0d3480 tlb_finish_mmu
0.000230   systemd-udevd  47573     2.14 ffff914c78de6e40 tlb_finish_mmu
0.000196   systemd-udevd  47430     2.14 ffff914a90ea3480 tlb_finish_mmu
0.000115   systemd-udevd  47589     2.16 ffff914c89f94440 tlb_finish_mmu
0.000110   systemd-udevd  47498     2.09 ffff914bf311de80 tlb_finish_mmu
0.000131   systemd-udevd  47523     2.16 ffff914cb607e3c0 tlb_finish_mmu
0.000112   systemd-udevd  47363     2.16 ffff914aa6716e40 tlb_finish_mmu
-0.000001  systemd-udevd  47585     2.10 ffff914c89f92f40 tlb_finish_mmu
0.000223   systemd-udevd  47414     2.32 ffff914a90ea6900 tlb_finish_mmu
0.007126   systemd-udevd  47702     1.58 ffff914c8c2e9f80 tlb_finish_mmu
0.000080   systemd-udevd  47584     2.16 ffff914c89f92a00 tlb_finish_mmu
0.000093   systemd-udevd  47751     6.26 ffff914b639ba4c0 tlb_finish_mmu
0.000119   systemd-udevd  47398     2.16 ffff914aa8720000 tlb_finish_mmu
0.000079   systemd-udevd  47647     2.26 ffff914c89c4f8c0 tlb_finish_mmu
0.000129   systemd-udevd  47587     2.28 ffff914c89f939c0 tlb_finish_mmu
0.006894   systemd-udevd  47704     1.80 ffff914c8c2eaa00 tlb_finish_mmu
0.000128   systemd-udevd  47614     2.21 ffff914b197f4980 tlb_finish_mmu
0.000216   systemd-udevd  47776     2.19 ffff914c6c262a00 tlb_finish_mmu
0.000181   systemd-udevd  47512     2.08 ffff914cb607aa00 tlb_finish_mmu
0.000177   systemd-udevd  47513     2.09 ffff914cb607af40 tlb_finish_mmu
0.000847   systemd-udevd  47370     1.58 ffff914aa6714980 tlb_finish_mmu
-0.000187  systemd-udevd  47760     1.70 ffff914b639bd400 tlb_finish_mmu
0.000342   systemd-udevd  47486     2.03 ffff914bf3119f80 tlb_finish_mmu
0.000027   systemd-udevd  47424     2.13 ffff914a90ea6e40 tlb_finish_mmu
0.000136   systemd-udevd  47425     2.34 ffff914a90ea78c0 tlb_finish_mmu
0.000002   systemd-udevd  47562     2.16 ffff914c78de3480 tlb_finish_mmu
-0.000128  systemd-udevd  47612     1.90 ffff914b197f3f00 tlb_finish_mmu
0.000519   systemd-udevd  47410     1.54 ffff914a90ea3f00 tlb_finish_mmu
0.000219   systemd-udevd  47388     1.91 ffff914aa87224c0 tlb_finish_mmu
0.007926   systemd-udevd  47393     1.42 ffff914aa87263c0 tlb_finish_mmu
0.000052   systemd-udevd  47725     8.76 ffff914bb7291a40 tlb_finish_mmu
0.002867   systemd-udevd  47715     5.87 ffff914c8c2ee3c0 tlb_finish_mmu
0.000033   systemd-udevd  47733     8.22 ffff914bb7294440 tlb_finish_mmu
0.006582   systemd-udevd  47705     1.88 ffff914c8c2eaf40 tlb_finish_mmu
0.007529   systemd-udevd  47667     1.36 ffff914d1a4de3c0 tlb_finish_mmu
0.000087   systemd-udevd  47766     8.68 ffff914b639bf380 tlb_finish_mmu
0.002653   systemd-udevd  47681     6.98 ffff914c3d07af40 tlb_finish_mmu
0.000106   systemd-udevd  47706     9.60 ffff914c8c2eb480 tlb_finish_mmu
0.000058   systemd-udevd  47768     9.72 ffff914c6c260000 tlb_finish_mmu
0.006700   systemd-udevd  47685     4.83 ffff914c3d07c440 tlb_finish_mmu
0.000200   systemd-udevd  47488     9.71 ffff914bf311aa00 tlb_finish_mmu
0.006718   systemd-udevd  47441     4.93 ffff914a91f96e40 tlb_finish_mmu
0.002739   systemd-udevd  47679     8.97 ffff914c3d07a4c0 tlb_finish_mmu
0.002752   systemd-udevd  47678     7.17 ffff914c3d079f80 tlb_finish_mmu
0.000135   systemd-udevd  47451    11.23 ffff914a91f90540 tlb_finish_mmu
0.000112   systemd-udevd  47703     9.86 ffff914c8c2ea4c0 tlb_finish_mmu
0.006671   systemd-udevd  47400     3.55 ffff914aa8723480 tlb_finish_mmu
0.006622   systemd-udevd  47690     4.75 ffff914c3d07de80 tlb_finish_mmu
0.000197   systemd-udevd  47542    10.26 ffff914b0b0d4980 tlb_finish_mmu
0.006664   systemd-udevd  47694     4.99 ffff914c3d07f380 tlb_finish_mmu
0.007354   systemd-udevd  47448     3.04 ffff914a91f97380 tlb_finish_mmu
0.000236   systemd-udevd  47609    10.32 ffff914b197f2f40 tlb_finish_mmu
0.003026   systemd-udevd  47454     9.78 ffff914a91f90fc0 tlb_finish_mmu
0.000069   systemd-udevd  47540    10.40 ffff914b0b0d3f00 tlb_finish_mmu
0.000139   systemd-udevd  47724    11.33 ffff914bb7291500 tlb_finish_mmu
0.009649   systemd-udevd  47695     2.50 ffff914c3d07f8c0 tlb_finish_mmu
0.002866   systemd-udevd  47462     7.53 ffff914d0a4d9f80 tlb_finish_mmu
0.002700   systemd-udevd  47714     7.26 ffff914c8c2ede80 tlb_finish_mmu
0.002677   systemd-udevd  47748     8.27 ffff914b639b9500 tlb_finish_mmu
0.002755   systemd-udevd  47736     7.63 ffff914bb7295400 tlb_finish_mmu
0.010292   systemd-udevd  47570     2.33 ffff914c78de5e80 tlb_finish_mmu
0.008970   systemd-udevd  47412     3.89 ffff914a90ea2a00 tlb_finish_mmu
0.010672   systemd-udevd  47769     2.35 ffff914c6c260540 tlb_finish_mmu
0.010834   systemd-udevd  47351     2.43 ffff914aa6715940 tlb_finish_mmu
0.005336   systemd-udevd  47539     7.97 ffff914b0b0d39c0 tlb_finish_mmu
0.009183   systemd-udevd  47691     4.28 ffff914c3d07e3c0 tlb_finish_mmu
0.002625   systemd-udevd  47497    11.05 ffff914bf311d940 tlb_finish_mmu
0.000110   systemd-udevd  47633    13.64 ffff914c89c4af40 tlb_finish_mmu
0.002745   systemd-udevd  47534    11.02 ffff914b0b0d1f80 tlb_finish_mmu
0.002741   systemd-udevd  47752    11.11 ffff914b639baa00 tlb_finish_mmu
0.012093   systemd-udevd  47555     2.09 ffff914c78de0fc0 tlb_finish_mmu
0.002439   systemd-udevd  47734    11.77 ffff914bb7294980 tlb_finish_mmu
0.010594   systemd-udevd  47623     3.84 ffff914b197f78c0 tlb_finish_mmu
0.013066   systemd-udevd  47749     1.54 ffff914b639b9a40 tlb_finish_mmu
0.013088   systemd-udevd  47756     1.53 ffff914b639bbf00 tlb_finish_mmu
0.011231   systemd-udevd  47621     3.63 ffff914b197f6e40 tlb_finish_mmu
0.013822   systemd-udevd  47352     1.27 ffff914aa6715e80 tlb_finish_mmu
0.012027   systemd-udevd  47471     3.23 ffff914d0a4dcec0 tlb_finish_mmu
0.008924   systemd-udevd  47652     6.43 ffff914d1a4d9500 tlb_finish_mmu
0.010232   systemd-udevd  47514     5.24 ffff914cb607b480 tlb_finish_mmu
0.010190   systemd-udevd  47730     5.33 ffff914bb7293480 tlb_finish_mmu


Thanks

-Li


