Return-Path: <kvm+bounces-13011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B945588FF2A
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 13:39:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC1C71C2622B
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 12:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528F27F481;
	Thu, 28 Mar 2024 12:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4Khp5uXP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6DB4F208;
	Thu, 28 Mar 2024 12:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711629533; cv=fail; b=qU1KCB7EIupda4B1DkYo8TFCF90RK4K8RoNZW62UxHdXClKowKKu/zMVc5GpnH2xB8S5gK3nCJnXymmf6yMkW17nhDAen/8wizqPsfL+JvVYPjHjYUv8E7sCxaZrGU/ciSuZ66NYnDSiVEblvqxsq9MEP7NienlII78M0I4hhgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711629533; c=relaxed/simple;
	bh=zXf/o0eRG4x1T/9PMRu1iPi+G5vDgKfiNQBy/NDadkI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FwM8CDhPKKZYT1eQqIsrRIT28fPPWZUKKF+iq2hWzRr1pW8kL0IVIiz49vmheXPfykoT7bvfzFGZbbnSMtmxorRYfTnQ4+dzqZxdy8/TvsARHo43mFo9ZJG80hSOshDxPeky3gCblYCz9qlV4ZtMiAZVHjOgmJZ3VPughk+5KjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4Khp5uXP; arc=fail smtp.client-ip=40.107.220.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L38AN7Oh2PV99HRlDVpAUZ7LiSSK/zZhirCDSWu+EZYpUjIOKqwzZz6jYXKls79mzZEB6ccX4krW4mppciieUaxnbm+/mXH5bN/7fSjWLEwK5K6RL/zsp2/AbVNosFfPzvWKgz8SVYKfxOvTWjjNdPykjz/Uzli/+A0zXAjHCIFFXZycyvhYfZ5bHs4i4jLQYFLCQI8sWC39GLVnh8FlelvkNNWUEZuPxvq3EhaF1mwfnNWLJBct37Pqy6NuPemZGbJCYnq//Kfg3Z4+v8nIFz7FmIVIY9iCLjE+ml1ZlsdyBun82yhqimvWwRaAZCA6xFEbE6aG145RtPJF1WTj+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e7HIyoN4pCgOLLDPaitMeKMOkqq0YjC63JIFVZmQv3k=;
 b=jkxMbQzW9yB1Y1yZXa347byCGv4Lpw4Iq+l9drZ9jEegA0SleGF7SuhT49+CimDQxT3S7zKaQJQB5vDTDHeU6PS2lId0fOe4GXwNH9oR4Quia7j+N4Q6XdZBAPG7UCeS9i6Jm556AdNExH7fWYkxpC/e38EQ7WzhPylF11TKdGF4O62tIa8gDVy6CA6KPEMV/DC0YP/8OFft1Wok632qDivCl2BnQeYHeEezaF3MwSf9LoTEqnDis/1zmF+hfaXaxtoCqoPJ0BjJwGx3VYMolMUwggMfMYZx8NI7ByZmxxBszB8xfUyx0urzLaf4u+3Uyf9HMRQVL492N9mE7vJ4fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alu.unizg.hr smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7HIyoN4pCgOLLDPaitMeKMOkqq0YjC63JIFVZmQv3k=;
 b=4Khp5uXPv07IXYInq5Lp/u72WA+bPjaEPKsd3bziwMKjKTkCo0PIBJ6KeRM6xNb2tlboCEG7q6FzQPhdgIae/dwOV3YW13YcojeWfPcVBlgH5h14BUux5sMXA5p3oey6M7+LbpDBSlva9x6SHDaCWoxHKFOrJgPHBrf9FNxqnvg=
Received: from CH2PR10CA0016.namprd10.prod.outlook.com (2603:10b6:610:4c::26)
 by SA1PR12MB7442.namprd12.prod.outlook.com (2603:10b6:806:2b5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Thu, 28 Mar
 2024 12:38:48 +0000
Received: from CH1PEPF0000AD7E.namprd04.prod.outlook.com
 (2603:10b6:610:4c:cafe::5) by CH2PR10CA0016.outlook.office365.com
 (2603:10b6:610:4c::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13 via Frontend
 Transport; Thu, 28 Mar 2024 12:38:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7E.mail.protection.outlook.com (10.167.244.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Thu, 28 Mar 2024 12:38:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 28 Mar
 2024 07:38:47 -0500
Date: Thu, 28 Mar 2024 07:38:30 -0500
From: Michael Roth <michael.roth@amd.com>
To: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
	<linux-kernel@vger.kernel.org>, Fuad Tabba <tabba@google.com>, Marc Zyngier
	<maz@kernel.org>, Shaoqin Huang <shahuang@redhat.com>, David Matlack
	<dmatlack@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
	Breno Leitao <leitao@debian.org>, <kvm@vger.kernel.org>, Ben Gardon
	<bgardon@google.com>
Subject: Re: [BUG net-next] arch/x86/kernel/cpu/bugs.c:2935: "Unpatched
 return thunk in use. This should not happen!" [STACKTRACE]
Message-ID: <20240328123830.dma3nnmmlb7r52ic@amd.com>
References: <1d10cd73-2ae7-42d5-a318-2f9facc42bbe@alu.unizg.hr>
 <20240318202124.GCZfiiRGVV0angYI9j@fat_crate.local>
 <12619bd4-9e9e-4883-8706-55d050a4d11a@alu.unizg.hr>
 <20240326101642.GAZgKgisKXLvggu8Cz@fat_crate.local>
 <8fc784c2-2aad-4d1d-ba0f-e5ab69d28ec5@alu.unizg.hr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <8fc784c2-2aad-4d1d-ba0f-e5ab69d28ec5@alu.unizg.hr>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7E:EE_|SA1PR12MB7442:EE_
X-MS-Office365-Filtering-Correlation-Id: c305eed5-677e-4c9a-20c3-08dc4f2403ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	se+9aIq18cK0fXuApuSNRwZPqs3YVJnABOI1BBHB6u/dQtVflVHZInyKqpm90CTU2FONX6nngxDjf6XfKayddq9GVaffobGFfI48YIr9zbATBaiWjz4SsUeiv7Rp3lRUew28EBUlsI2N4qZADlxP+lX7lJsA3zKpbSHRLzYFoBSMTDRaQf7hNg3w9Rz+v9WgIriZi3oHEJ/VCb+UeYIsTNPaffeWDEWZdLRdhlM1ZOJo4dYtPmyadMgtnr3iayCerVFcSmg0H5yYoJ6HLUxlpPDm6iqShgO1Xkg+H+a7GJxvKuDnPrznAKT4iLXSdEaW5YsDE52c/PYUextDXxfMPw8JKKEFrfHHQt//IzeRkQDmIEHauYWzXes7HLMR04UqVbSTmdwpL12Wl7i6nPS+znuZT1omkN45JaM6fuC3zTIENxg3DFi/FPc9pQUdb918VhD1+pBdMv94LbkXEgsi3uPoK+OFgqF4N4jO8RT0QVtIN7uiVmOtnKSJGAP16kTL/xGONH3fbpz11Cd9fIRbBuBeSqUewAABP1iugSD8YRT2g6XEnri+GmwJ+3YkturvzQuJyVxmYC85TKTsWvjrwdSnPCwv0ERaqFVmy7xhiapMxHaHkEYez4JUanWu1anfE7DOjcgcpgAnhm6qVZu59IP/f3ZI7j4YlESRcD+hsK0Jd6O4HZQwSjsBQY6s+dGlWjbamaxmpUfrRUSclFnu14RlH+ivtjasoBkX9EiYo1KoalZrvtKXQs/JvNkCK+lA
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(7416005)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 12:38:48.0400
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c305eed5-677e-4c9a-20c3-08dc4f2403ce
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7442

On Tue, Mar 26, 2024 at 08:15:12PM +0100, Mirsad Todorovac wrote:
> On 3/26/24 11:16, Borislav Petkov wrote:
> > On Wed, Mar 20, 2024 at 02:28:57AM +0100, Mirsad Todorovac wrote:
> > > Please find the kernel .config attached.
> >=20
> > Thanks, that's one huuuge kernel you're building. :)
> >=20
> > > I got another one of these "Unpatched thunk" and it seems connected
> > > with selftest/kvm.
> > >=20
> > > But running selftests/kvm one by one did not trigger the bug.
> >=20
> > Which commands are you exactly running?
> >=20
> > I'll try to reproduce here.
>=20
> I think I have a reproducer here on the latest torvalds vanilla tree (on =
Ubuntu 22.04 LTS box):
>=20
> root# tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> Running test with CAP_SYS_BOOT enabled
> Running as root, skipping nx_huge_pages_test with CAP_SYS_BOOT disabled
> root# git describe
> v6.9-rc1-5-g928a87efa423
> root#

I'm seeing it pretty consistently on kvm/next as well. Not sure if
there's anything special about my config but starting a fairly basic
SVM guest seems to be enough to trigger it for me on the first
invocation of svm_vcpu_run().

It seems to be 2 call-sites, one inside:

  amd_clear_divider()

and another inside:

  __svm_vcpu_run()

which seems to match up with the decoded stack you posted here. Maybe
the first case would be easiest to focus on? It's a fairly
straight-forward use of ALTERNATIVE():

  void noinstr amd_clear_divider(void)
  {
          asm volatile(ALTERNATIVE("", "div %2\n\t", X86_BUG_DIV0)
                       :: "a" (0), "d" (0), "r" (1));
  }
  EXPORT_SYMBOL_GPL(amd_clear_divider);

and it's been that way since before 4461438a84 ("x86/retpoline: Ensure
default return thunk isn't used at runtime") was added. Not sure if
anything else has changed underneath the covers since 4461438a84.

-Mike

>=20
> > Thx.
>=20
> Not at all.
>=20
> The stacktrace for the bug triggered by the above command was:
>=20
> kernel: [  101.973612] ------------[ cut here ]------------
> kernel: [  101.973615] Unpatched return thunk in use. This should not hap=
pen!
> kernel: [  101.973618] WARNING: CPU: 1 PID: 3827 at arch/x86/kernel/cpu/b=
ugs.c:2935 __warn_thunk (./arch/x86/kernel/cpu/bugs.c:2935 (discriminator 3=
))
> kernel: [  101.973625] Modules linked in: xfrm_user nf_tables nfnetlink n=
vme_fabrics binfmt_misc snd_hda_codec_realtek snd_hda_codec_generic snd_hda=
_scodec_component snd_hda_codec_hdmi snd_hda_intel snd_intel_dspcfg snd_int=
el_sdw_acpi snd_hda_codec intel_rapl_msr amd_atl snd_hda_core intel_rapl_co=
mmon nls_iso8859_1 snd_hwdep snd_pcm edac_mce_amd amdgpu crct10dif_pclmul p=
olyval_clmulni snd_seq_midi polyval_generic snd_seq_midi_event ghash_clmuln=
i_intel sha512_ssse3 snd_rawmidi sha256_ssse3 amdxcp sha1_ssse3 drm_exec ae=
sni_intel snd_seq gpu_sched crypto_simd drm_buddy cryptd drm_suballoc_helpe=
r drm_ttm_helper snd_seq_device joydev input_leds rapl ttm snd_timer wmi_bm=
of drm_display_helper cec snd drm_kms_helper k10temp ccp i2c_algo_bit sound=
core mac_hid tcp_bbr msr parport_pc ppdev lp parport drm efi_pstore ip_tabl=
es x_tables autofs4 btrfs blake2b_generic xor raid6_pq hid_generic nvme r81=
69 xhci_pci ahci nvme_core crc32_pclmul i2c_piix4 xhci_pci_renesas nvme_aut=
h realtek libahci video wmi gpio_amdpt
> kernel: [  101.973685] CPU: 1 PID: 3827 Comm: nx_huge_pages_t Not tainted=
 6.9.0-rc1-torv-00005-g928a87efa423-dirty #36
> kernel: [  101.973687] Hardware name: ASRock X670E PG Lightning/X670E PG =
Lightning, BIOS 1.21 04/26/2023
> kernel: [  101.973688] RIP: 0010:__warn_thunk (./arch/x86/kernel/cpu/bugs=
=2Ec:2935 (discriminator 3))
> kernel: [ 101.973691] Code: 62 c5 1d 01 83 e3 01 74 0e 48 8b 5d f8 c9 31 =
f6 31 ff e9 be 98 3b 01 48 c7 c7 98 21 c1 bc c6 05 22 26 8d 02 01 e8 90 aa =
07 00 <0f> 0b 48 8b 5d f8 c9 31 f6 31 ff e9 9b 98 3b 01 90 90 90 90 90 90
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>    0:	62 c5 1d 01 83       	(bad)
>    5:	e3 01                	jrcxz  0x8
>    7:	74 0e                	je     0x17
>    9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
>    d:	c9                   	leave
>    e:	31 f6                	xor    %esi,%esi
>   10:	31 ff                	xor    %edi,%edi
>   12:	e9 be 98 3b 01       	jmp    0x13b98d5
>   17:	48 c7 c7 98 21 c1 bc 	mov    $0xffffffffbcc12198,%rdi
>   1e:	c6 05 22 26 8d 02 01 	movb   $0x1,0x28d2622(%rip)        # 0x28d2647
>   25:	e8 90 aa 07 00       	call   0x7aaba
>   2a:*	0f 0b                	ud2    		<-- trapping instruction
>   2c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
>   30:	c9                   	leave
>   31:	31 f6                	xor    %esi,%esi
>   33:	31 ff                	xor    %edi,%edi
>   35:	e9 9b 98 3b 01       	jmp    0x13b98d5
>   3a:	90                   	nop
>   3b:	90                   	nop
>   3c:	90                   	nop
>   3d:	90                   	nop
>   3e:	90                   	nop
>   3f:	90                   	nop
>=20
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    0:	0f 0b                	ud2
>    2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
>    6:	c9                   	leave
>    7:	31 f6                	xor    %esi,%esi
>    9:	31 ff                	xor    %edi,%edi
>    b:	e9 9b 98 3b 01       	jmp    0x13b98ab
>   10:	90                   	nop
>   11:	90                   	nop
>   12:	90                   	nop
>   13:	90                   	nop
>   14:	90                   	nop
>   15:	90                   	nop
> kernel: [  101.973692] RSP: 0018:ffffbbd90580fc90 EFLAGS: 00010046
> kernel: [  101.973694] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0=
000000000000000
> kernel: [  101.973695] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0=
000000000000000
> kernel: [  101.973696] RBP: ffffbbd90580fc98 R08: 0000000000000000 R09: 0=
000000000000000
> kernel: [  101.973697] R10: 0000000000000000 R11: 0000000000000000 R12: f=
fff9964e4b7d4f0
> kernel: [  101.973698] R13: 0000000000000000 R14: 0000000000000000 R15: f=
fff9964e4b7dc70
> kernel: [  101.973699] FS:  0000720b95372740(0000) GS:ffff9973d7a80000(00=
00) knlGS:0000000000000000
> kernel: [  101.973700] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> kernel: [  101.973701] CR2: 0000000000000000 CR3: 00000001aea6c000 CR4: 0=
000000000f50ef0
> kernel: [  101.973703] PKRU: 55555554
> kernel: [  101.973703] Call Trace:
> kernel: [  101.973704]  <TASK>
> kernel: [  101.973706] ? show_regs (./arch/x86/kernel/dumpstack.c:479)
> kernel: [  101.973709] ? __warn_thunk (./arch/x86/kernel/cpu/bugs.c:2935 =
(discriminator 3))
> kernel: [  101.973711] ? __warn (./kernel/panic.c:694)
> kernel: [  101.973713] ? __warn_thunk (./arch/x86/kernel/cpu/bugs.c:2935 =
(discriminator 3))
> kernel: [  101.973715] ? report_bug (./lib/bug.c:201 ./lib/bug.c:219)
> kernel: [  101.973718] ? irq_work_queue (./kernel/irq_work.c:119)
> kernel: [  101.973722] ? handle_bug (./arch/x86/kernel/traps.c:218)
> kernel: [  101.973725] ? exc_invalid_op (./arch/x86/kernel/traps.c:260 (d=
iscriminator 1))
> kernel: [  101.973727] ? asm_exc_invalid_op (././arch/x86/include/asm/idt=
entry.h:621)
> kernel: [  101.973731] ? __warn_thunk (./arch/x86/kernel/cpu/bugs.c:2935 =
(discriminator 3))
> kernel: [  101.973734] warn_thunk_thunk (./arch/x86/entry/entry.S:48)
> kernel: [  101.973738] svm_vcpu_enter_exit (././include/linux/kvm_host.h:=
547 ./arch/x86/kvm/svm/svm.c:4115)
> kernel: [  101.973740] svm_vcpu_run (././arch/x86/include/asm/cpufeature.=
h:171 ./arch/x86/kvm/svm/svm.c:4186)
> kernel: [  101.973744] kvm_arch_vcpu_ioctl_run (./arch/x86/kvm/x86.c:1100=
8 ./arch/x86/kvm/x86.c:11211 ./arch/x86/kvm/x86.c:11437)
> kernel: [  101.973747] ? srso_alias_return_thunk (./arch/x86/lib/retpolin=
e.S:181)
> kernel: [  101.973750] ? srso_alias_return_thunk (./arch/x86/lib/retpolin=
e.S:181)
> kernel: [  101.973752] ? kvm_vm_stats_read (./arch/x86/kvm/../../../virt/=
kvm/kvm_main.c:5066)
> kernel: [  101.973755] kvm_vcpu_ioctl (./arch/x86/kvm/../../../virt/kvm/k=
vm_main.c:4464)
> kernel: [  101.973757] ? srso_alias_return_thunk (./arch/x86/lib/retpolin=
e.S:181)
> kernel: [  101.973759] ? trace_hardirqs_on_prepare (./kernel/trace/trace_=
preemptirq.c:47 ./kernel/trace/trace_preemptirq.c:42)
> kernel: [  101.973761] ? srso_alias_return_thunk (./arch/x86/lib/retpolin=
e.S:181)
> kernel: [  101.973763] ? syscall_exit_to_user_mode (./kernel/entry/common=
=2Ec:221)
> kernel: [  101.973765] ? srso_alias_return_thunk (./arch/x86/lib/retpolin=
e.S:181)
> kernel: [  101.973767] ? do_syscall_64 (././arch/x86/include/asm/cpufeatu=
re.h:171 ./arch/x86/entry/common.c:98)
> kernel: [  101.973770] __x64_sys_ioctl (./fs/ioctl.c:51 ./fs/ioctl.c:904 =
=2E/fs/ioctl.c:890 ./fs/ioctl.c:890)
> kernel: [  101.973773] do_syscall_64 (./arch/x86/entry/common.c:52 ./arch=
/x86/entry/common.c:83)
> kernel: [  101.973775] ? srso_alias_return_thunk (./arch/x86/lib/retpolin=
e.S:181)
> kernel: [  101.973777] ? irqentry_exit (./kernel/entry/common.c:367)
> kernel: [  101.973778] ? srso_alias_return_thunk (./arch/x86/lib/retpolin=
e.S:181)
> kernel: [  101.973780] entry_SYSCALL_64_after_hwframe (./arch/x86/entry/e=
ntry_64.S:129)
> kernel: [  101.973782] RIP: 0033:0x720b9511a94f
> kernel: [ 101.973798] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 =
24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 =
0f 05 <41> 89 c0 3d 00 f0 ff ff 77 1f 48 8b 44 24 18 64 48 2b 04 25 28 00
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>    0:	00 48 89             	add    %cl,-0x77(%rax)
>    3:	44 24 18             	rex.R and $0x18,%al
>    6:	31 c0                	xor    %eax,%eax
>    8:	48 8d 44 24 60       	lea    0x60(%rsp),%rax
>    d:	c7 04 24 10 00 00 00 	movl   $0x10,(%rsp)
>   14:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
>   19:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
>   1e:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
>   23:	b8 10 00 00 00       	mov    $0x10,%eax
>   28:	0f 05                	syscall
>   2a:*	41 89 c0             	mov    %eax,%r8d		<-- trapping instruction
>   2d:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
>   32:	77 1f                	ja     0x53
>   34:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
>   39:	64                   	fs
>   3a:	48                   	rex.W
>   3b:	2b                   	.byte 0x2b
>   3c:	04 25                	add    $0x25,%al
>   3e:	28 00                	sub    %al,(%rax)
>=20
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    0:	41 89 c0             	mov    %eax,%r8d
>    3:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
>    8:	77 1f                	ja     0x29
>    a:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
>    f:	64                   	fs
>   10:	48                   	rex.W
>   11:	2b                   	.byte 0x2b
>   12:	04 25                	add    $0x25,%al
>   14:	28 00                	sub    %al,(%rax)
> kernel: [  101.973799] RSP: 002b:00007ffd786b9ca0 EFLAGS: 00000246 ORIG_R=
AX: 0000000000000010
> kernel: [  101.973801] RAX: ffffffffffffffda RBX: 0000000000600000 RCX: 0=
000720b9511a94f
> kernel: [  101.973802] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0=
000000000000005
> kernel: [  101.973803] RBP: 0000720b953726c0 R08: 000000000041b228 R09: 0=
000000000000000
> kernel: [  101.973804] R10: 0000720b951d8882 R11: 0000000000000246 R12: 0=
00000000c9b18c0
> kernel: [  101.973805] R13: 000000000c9b18c0 R14: 0000000000000000 R15: 0=
000000000000064
> kernel: [  101.973809]  </TASK>
> kernel: [  101.973810] ---[ end trace 0000000000000000 ]---
>=20
> NOTE: Cc:-ed author of the reproducer for these results.
> NOTE 2: The stacktrace is only displayed once, repeating the reproducer d=
oesn't work until the next reboot.
>=20
> Sending the latest config as well attached:
>=20
> Best regards,
> Mirsad Todorovac



