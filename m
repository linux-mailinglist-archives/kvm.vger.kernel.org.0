Return-Path: <kvm+bounces-13228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F3548934D6
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:14:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A57371C230A0
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A8A214D6E2;
	Sun, 31 Mar 2024 16:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aSZaNB8m"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4173516D4CC;
	Sun, 31 Mar 2024 16:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903584; cv=fail; b=VOdgDbnp8t2Had4QmvlqjO0cRb4QW6b5gy61q2x43XHq+F2YaHZ0N+dbLMHeNfA8wUIJFnPyIoe4bMJYX+c9ghEpSkJNWY2wv3WlwAtELNcki71K0ck4bvi20sPXzSokk4ktcF760a1kkmJ3wT3xi4RCF5mqtC2Di4+VNUMGHMQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903584; c=relaxed/simple;
	bh=ph6GLOQJ/MvMKKobN+JnRkkH1HYvdeYqYhoYxn0k6n4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DmlHwaWNLePgDstDWSqCrP7/mlZqOY2Epy0dgd/i76i+qk24QsVfBGIgv5uJ9qAix4E2Jd/dxyAOMGySZjTyfqFCjPVSUU0LQV2L5kNwxcH3atnJLfzqBVEAyLyo1YDHJ3d84K7zira965aziPNEOFZFxgS0YAhjpYheq1gngjA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aSZaNB8m reason="signature verification failed"; arc=fail smtp.client-ip=40.107.93.68; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id D7B972083F;
	Sun, 31 Mar 2024 18:46:16 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PbhM0JqDqwmI; Sun, 31 Mar 2024 18:46:13 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 19A822084A;
	Sun, 31 Mar 2024 18:46:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 19A822084A
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 2685880004A;
	Sun, 31 Mar 2024 18:40:15 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:40:14 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:36:18 +0000
X-sender: <kvm+bounces-13114-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
 NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAJuYHy0vkvxLoOu7fW2WcxcPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQALABcAvgAAALMpUnVJ4+pPsL47FHo+lvtDTj1EQjIsQ049RGF0YWJhc2VzLENOPUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpLENOPUFkbWluaXN0cmF0aXZlIEdyb3VwcyxDTj1zZWN1bmV0LENOPU1pY3Jvc29mdCBFeGNoYW5nZSxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXNlY3VuZXQsREM9ZGUFAA4AEQBACf3SYEkDT461FZzDv+B7BQAdAA8ADAAAAG1ieC1lc3Nlbi0wMQUAPAACAAAPADYAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0Lk1haWxSZWNpcGllbnQuRGlzcGxheU5hbWUPAA0AAABXZWJlciwgTWFydGluBQAMAAIAAAUAbAACAAAFAFgAFwBGAAAAm5gfLS+S/Eug67t9bZZzF0NOPVdlYmVyIE1hcnRpbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8AL
	wAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAWUmmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAGAAAAG1hcnRpbi53ZWJlckBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBiAAoAAQAAAM6KAAAFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 38396
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.199.223; helo=ny.mirrors.kernel.org; envelope-from=kvm+bounces-13114-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 80F00208AC
X-Original-To: kvm@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.68
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753189; cv=fail; b=KkzJ4D/hGOm6H7lybFTyphgcbndcau0OQMPGMJsmNWC/x9t/9udarNpuGuxJyPyaJnVmX1o3Z+bskjB4bbNnfizqxPl5tfOfn1mmirKOT5dS5jsb6vBK7ZyXLqk5KPcg9oc/sC7ExlRPL7QCTwc988a1J31/4gUX83WAT5lKaCg=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753189; c=relaxed/simple;
	bh=yKD6Z3CWCO1R5YG84VSYV4FFCsF/dwEriI482bu3JTE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Hk+wDZYD3447FsG7ra32Qs2LiWrfGrBfgJP5mvGU+fDcq/K12xfK0s8HNsSfuHFM9cGF0oegLiqFR+WZAi/F/e83YH4KsNf5b8i7C82bYGZsMPEUhYtVyArcbVLSjmQZ7ePFPwfWeFekg7eWuvemZykQs9kfH4g/TukLviJMg5o=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aSZaNB8m; arc=fail smtp.client-ip=40.107.93.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBib6RTkprrBtKFMtciyzEOREcrm6zXD+6o7WlqixvaMcQrdqN5lNgQjN/GEZi9eZ/Uk0V3KQrkcfK6MxgN+m5GoOojwNh6na3LS7IC3fOmbFDZa9cE67LaZJc6sBW/yuuY7ko4s39KK02TxkA+EKzY3oEVwkT2HlNkRM2Sz5JphvXbMdUhbDVYDY/a1vYK+JYZ3oH0sIp1kvHEFe/JS/uRy/NBWxvTD22+Sgkx0Rsi8jPf8smMuSBvvgPm8IdRtrAmRmClERDJqUVvbEHbilI7MdPRTD1c/kVau9zlp3M8f/SXbWI0+AOAdBFr9MFJBCeRMqTFhFZ1QUmTI16SzwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W6XwIhnbyiFwjhaPLMCpe4b4WhUMyHdpcDV6YoH2FTI=;
 b=EOrYX9UVMszmMEC0P71nwPAUTk+oJ8bi0wa1+MNrizAoGeNfdhdZR7Ox5jdSjdr5B+tz/VzeSl28+cjaYCCDAupsQ6y2G3j5I+pYlO254zExpr55GgXFCR8da2ZwPzn1Xf+n7JOM7kQjHfPn5T9ANvMtKktahv1wC8C0JwDStphIexbWCSQ8lI6Mw2bwxwc3h4om8C/JQAEDAASeRZ2mVWpstThjplsnKgX1kLjb/H9KsbwoSnhjSEJ03o6LXH9291ts9Ge2OvVyQLcPd05YW0ZQo7x3P8BnKSI+rdgdGDAbWW4O1O6IvN8BlBRTwux2RYG0oH6JRgP/znFJSzFIgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6XwIhnbyiFwjhaPLMCpe4b4WhUMyHdpcDV6YoH2FTI=;
 b=aSZaNB8moAiu1c+h0xVa328kTLaCLFbUIKInKDNjwnVJ2vKM0v7xkwoq3/yuh4TLG8CFWOMrdRP05xwspSuAYrCdvt/jPpJH5FDRsd5oNdeKvYbNLT7G6d4qdPiA6CSwEB14LCrm03jVWxWUHO78SGetvuSC4b/QAzNcI2JKU2M=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v12 00/29] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
Date: Fri, 29 Mar 2024 17:58:06 -0500
Message-ID: <20240329225835.400662-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDD:EE_|SA1PR12MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: 04df9763-f67a-45a0-895a-08dc5043ec53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QTkX01t/CQGSIM2UoVIeJlO6PgFFtT4/ZSzs6ZBMfywlsEggE0T3P1O6IwNW67dETu/srC97PsB2C3H82fJ3uFAuyuihNvj3DanNqrpJrReW55acuBpc5QoDloOchvUgSalLh6MC0rLNTWwNPDF32dQltsE3+4wtbctFxCOqTUcrw6dBf0mo1so3UfVvkquik/DNNRRQg74GsJnuYMgCehsqmObheftRlx7v9YyH39swtytXT5/355UaJXYiJ1ORIKodLig4A72a9GSfHFZv8gOtV53GAR2pQGQZNAXI3iUw66LXuInNVdZzYmNi7vke7jyb0Cge3DQgruXP3xEmR5/Q2YmOG8em5CByb7PjYC87PjHq3DoMD6LjXXLDKIo9k47RAXXDXJBIR+XyLuHrPTn9J2IL+50tzVVq65VdVgzN9Eaq0BH3EkABJc/zUIMUkVrQbMfEDe9qS5xwrcrgSjSd4/AAlw+/DvB+McKk/yYEVJgh+uCJCxPhqKHsOupwtBoekOJqFOU4WJR4dza9mOGnK5H6yerRNox+GCeM6zTpqAEsjBR4V+ThlPgAvjvm3slVfzeeoBIbBlMZX0AW8ryCEA4H6DX+UFKFOHRZPtmQPEg0+ZJpLNLRX4W4dPutC9cXPiRbY+G54XW9UA1BXl3VJz7eJ4VkbOAt7CxsxZINDvWCsSDR4wd++l86SfnluAbGk6N45Gsu/4LSRBGQ0g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 22:59:43.6602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04df9763-f67a-45a0-895a-08dc5043ec53
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CDD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5613
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-host-v12

and is based on top of the following series:

  [PATCH gmem 0/6] gmem fix-ups and interfaces for populating gmem pages
  https://lore.kernel.org/kvm/20240329212444.395559-1-michael.roth@amd.com/=
=20

which in turn is based on:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=3Dkvm-coco-queue


Patch Layout
------------

01-04: These patches are minor dependencies for this series and will
       eventually make their way upstream through other trees. They are
       included here only temporarily.

05-09: These patches add some basic infrastructure and introduces a new
       KVM_X86_SNP_VM vm_type to handle differences verses the existing
       KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.

10-12: These implement the KVM API to handle the creation of a
       cryptographic launch context, encrypt/measure the initial image
       into guest memory, and finalize it before launching it.

13-20: These implement handling for various guest-generated events such
       as page state changes, onlining of additional vCPUs, etc.

21-24: These implement the gmem hooks needed to prepare gmem-allocated
       pages before mapping them into guest private memory ranges as
       well as cleaning them up prior to returning them to the host for
       use as normal memory. Because this supplants certain activities
       like issued WBINVDs during KVM MMU invalidations, there's also
       a patch to avoid duplicating that work to avoid unecessary
       overhead.

25:    With all the core support in place, the patch adds a kvm_amd module
       parameter to enable SNP support.

26-29: These patches all deal with the servicing of guest requests to handl=
e
       things like attestation, as well as some related host-management
       interfaces.


Testing
-------

For testing this via QEMU, use the following tree:

  https://github.com/amdese/qemu/commits/snp-v4-wip2

A patched OVMF is also needed due to upstream KVM no longer supporting MMIO
ranges that are mapped as private. It is recommended you build the AmdSevX6=
4
variant as it provides the kernel-hashing support present in this series:

  https://github.com/amdese/ovmf/commits/apic-mmio-fix1c

A basic command-line invocation for SNP would be:

 qemu-system-x86_64 -smp 32,maxcpus=3D255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram1
  -object memory-backend-memfd,id=3Dram1,size=3D4G,share=3Dtrue,reserve=3Df=
alse
  -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,id-aut=
h=3D
  -bios /home/mroth/ovmf/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX64.f=
d

With kernel-hashing and certificate data supplied:

 qemu-system-x86_64 -smp 32,maxcpus=3D255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram1
  -object memory-backend-memfd,id=3Dram1,size=3D4G,share=3Dtrue,reserve=3Df=
alse
  -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,id-aut=
h=3D,certs-path=3D/home/mroth/cert.blob,kernel-hashes=3Don
  -bios /home/mroth/ovmf/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX64.f=
d
  -kernel /boot/vmlinuz-6.8.0-snp-host-v12-wip40+
  -initrd /boot/initrd.img-6.8.0-snp-host-v12-wip40+
  -append "root=3DUUID=3Dd72a6d1c-06cf-4b79-af43-f1bac4f620f9 ro console=3D=
ttyS0,115200n8"


Known issues / TODOs
--------------------

 * Base tree in some cases reports "Unpatched return thunk in use. This sho=
uld=20
   not happen!" the first time it runs an SVM/SEV/SNP guests. This a recent
   regression upstream and unrelated to this series:

     https://lore.kernel.org/linux-kernel/CANpmjNOcKzEvLHoGGeL-boWDHJobwfwy=
VxUqMq2kWeka3N4tXA@mail.gmail.com/T/

 * 2MB hugepage support has been dropped pending discussion on how we plan
   to re-enable it in gmem.

 * Host kexec should work, but there is a known issue with handling host
   kdump while SNP guests are running which will be addressed as a follow-u=
p.

 * SNP kselftests are currently a WIP and will be included as part of SNP
   upstreaming efforts in the near-term.


SEV-SNP Overview
----------------

This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
changes required to add KVM support for SEV-SNP. This series builds upon
SEV-SNP guest support, which is now in mainline, and and SEV-SNP host
initialization support, which is now in linux-next.

While series provides the basic building blocks to support booting the
SEV-SNP VMs, it does not cover all the security enhancement introduced by
the SEV-SNP such as interrupt protection, which will added in the future.

With SNP, when pages are marked as guest-owned in the RMP table, they are
assigned to a specific guest/ASID, as well as a specific GFN with in the
guest. Any attempts to map it in the RMP table to a different guest/ASID,
or a different GFN within a guest/ASID, will result in an RMP nested page
fault.

Prior to accessing a guest-owned page, the guest must validate it with a
special PVALIDATE instruction which will set a special bit in the RMP table
for the guest. This is the only way to set the validated bit outside of the
initial pre-encrypted guest payload/image; any attempts outside the guest t=
o
modify the RMP entry from that point forward will result in the validated
bit being cleared, at which point the guest will trigger an exception if it
attempts to access that page so it can be made aware of possible tampering.

One exception to this is the initial guest payload, which is pre-validated
by the firmware prior to launching. The guest can use Guest Message request=
s=20
to fetch an attestation report which will include the measurement of the
initial image so that the guest can verify it was booted with the expected
image/environment.

After boot, guests can use Page State Change requests to switch pages
between shared/hypervisor-owned and private/guest-owned to share data for
things like DMA, virtio buffers, and other GHCB requests.

In this implementation of SEV-SNP, private guest memory is managed by a new
kernel framework called guest_memfd (gmem). With gmem, a new
KVM_SET_MEMORY_ATTRIBUTES KVM ioctl has been added to tell the KVM
MMU whether a particular GFN should be backed by shared (normal) memory or
private (gmem-allocated) memory. To tie into this, Page State Change
requests are forward to userspace via KVM_EXIT_VMGEXIT exits, which will
then issue the corresponding KVM_SET_MEMORY_ATTRIBUTES call to set the
private/shared state in the KVM MMU.

The gmem / KVM MMU hooks implemented in this series will then update the RM=
P
table entries for the backing PFNs to set them to guest-owned/private when
mapping private pages into the guest via KVM MMU, or use the normal KVM MMU
handling in the case of shared pages where the corresponding RMP table
entries are left in the default shared/hypervisor-owned state.

Feedback/review is very much appreciated!

-Mike

Changes since v11:

 * Rebase series on kvm-coco-queue and re-work to leverage more
   infrastructure between SNP/TDX series.
 * Drop KVM_SNP_INIT in favor of the new KVM_SEV_INIT2 interface introduced
   here (Paolo):
     https://lore.kernel.org/lkml/20240318233352.2728327-1-pbonzini@redhat.=
com/
 * Drop exposure API fields related to things like VMPL levels, migration
   agents, etc., until they are actually supported/used (Sean)
 * Rework KVM_SEV_SNP_LAUNCH_UPDATE handling to use a new
   kvm_gmem_populate() interface instead of copying data directly into
   gmem-allocated pages (Sean)
 * Add support for SNP_LOAD_VLEK, rework the SNP_SET_CONFIG_{START,END} to
   have simpler semantics that are applicable to management of SNP_LOAD_VLE=
K
   updates as well, rename interfaces to the now more appropriate
   SNP_{PAUSE,RESUME}_ATTESTATION
 * Fix up documentation wording and do print warnings for
   userspace-triggerable failures (Peter, Sean)
 * Fix a race with AP_CREATION wake-up events (Jacob, Sean)
 * Fix a memory leak with VMSA pages (Sean)
 * Tighten up handling of RMP page faults to better distinguish between rea=
l
   and spurious cases (Tom)
 * Various patch/documentation rewording, cleanups, etc.

Changes since v10:

 * Split off host initialization patches to separate series
 * Drop SNP_{SET,GET}_EXT_CONFIG SEV ioctls, and drop=20
   KVM_SEV_SNP_{SET,GET}_CERTS KVM ioctls. Instead, all certificate data is
   now fetched from uerspace as part of a new KVM_EXIT_VMGEXIT event type.
   (Sean, Dionna)
 * SNP_SET_EXT_CONFIG is now replaced with a more basic SNP_SET_CONFIG,
   which is now just a light wrapper around the SNP_CONFIG firmware command=
,
   and SNP_GET_EXT_CONFIG is now redundant with existing SNP_PLATFORM_STATU=
S,
   so just stick with that interface
 * Introduce SNP_SET_CONFIG_{START,END}, which can be used to pause extende=
d
   guest requests while reported TCB / certificates are being updated so
   the updates are done atomically relative to running guests.
 * Improve documentation for KVM_EXIT_VMGEXIT event types and tighten down
   the expected input/output for union types rather than exposing GHCB
   page/MSR
 * Various re-factorings, commit/comments fixups (Boris, Liam, Vlastimil)=20
 * Make CONFIG_KVM_AMD_SEV depend on KVM_GENERIC_PRIVATE_MEM instead of
   CONFIG_KVM_SW_PROTECTED_VM (Paolo)
 * Include Sean's patch to add hugepage support to gmem, but modify it base=
d
   on discussions to be best-effort and not rely on explicit flag

----------------------------------------------------------------
Ashish Kalra (1):
      KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP

Borislav Petkov (AMD) (3):
      [TEMP] x86/kvm/Kconfig: Have KVM_AMD_SEV select ARCH_HAS_CC_PLATFORM
      [TEMP] x86/cc: Add cc_platform_set/_clear() helpers
      [TEMP] x86/CPU/AMD: Track SNP host status with cc_platform_*()

Brijesh Singh (11):
      KVM: x86: Define RMP page fault error bits for #NPF
      KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
      KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
      KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
      KVM: SEV: Add support to handle Page State Change VMGEXIT
      KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
      KVM: SEV: Add support to handle RMP nested page faults
      KVM: SVM: Add module parameter to enable the SEV-SNP
      KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event

Michael Roth (10):
      KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=3Dy
      KVM: SEV: Add initial SEV-SNP support
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
      KVM: SEV: Add support for GHCB-based termination requests
      KVM: SEV: Implement gmem hook for initializing private pages
      KVM: SEV: Implement gmem hook for invalidating private pages
      KVM: x86: Implement gmem hook for determining max NPT mapping level
      crypto: ccp: Add the SNP_VLEK_LOAD command
      crypto: ccp: Add the SNP_{PAUSE,RESUME}_ATTESTATION commands
      KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event

Paolo Bonzini (1):
      [TEMP] fixup! KVM: SEV: sync FPU and AVX state at LAUNCH_UPDATE_VMSA =
time

Tom Lendacky (3):
      KVM: SEV: Add support to handle AP reset MSR protocol
      KVM: SEV: Use a VMSA physical address variable for populating VMCB
      KVM: SEV: Support SEV-SNP AP Creation NAE event

 Documentation/virt/coco/sev-guest.rst              |   50 +-
 Documentation/virt/kvm/api.rst                     |   73 +
 .../virt/kvm/x86/amd-memory-encryption.rst         |   88 +-
 arch/x86/coco/core.c                               |   52 +
 arch/x86/include/asm/kvm_host.h                    |    8 +
 arch/x86/include/asm/sev-common.h                  |   22 +-
 arch/x86/include/asm/sev.h                         |   15 +-
 arch/x86/include/asm/svm.h                         |    9 +-
 arch/x86/include/uapi/asm/kvm.h                    |   39 +
 arch/x86/kernel/cpu/amd.c                          |   38 +-
 arch/x86/kernel/cpu/mtrr/generic.c                 |    2 +-
 arch/x86/kernel/fpu/xstate.c                       |    1 +
 arch/x86/kernel/sev.c                              |   10 -
 arch/x86/kvm/Kconfig                               |    4 +
 arch/x86/kvm/mmu.h                                 |    2 -
 arch/x86/kvm/mmu/mmu.c                             |    1 +
 arch/x86/kvm/svm/sev.c                             | 1410 ++++++++++++++++=
+++-
 arch/x86/kvm/svm/svm.c                             |   48 +-
 arch/x86/kvm/svm/svm.h                             |   50 +
 arch/x86/kvm/x86.c                                 |   18 +-
 arch/x86/virt/svm/sev.c                            |   90 +-
 drivers/crypto/ccp/sev-dev.c                       |   85 +-
 drivers/iommu/amd/init.c                           |    4 +-
 include/linux/cc_platform.h                        |   12 +
 include/linux/psp-sev.h                            |    4 +-
 include/uapi/linux/kvm.h                           |   28 +
 include/uapi/linux/psp-sev.h                       |   39 +
 include/uapi/linux/sev-guest.h                     |    9 +
 virt/kvm/guest_memfd.c                             |    4 +-
 29 files changed, 2121 insertions(+), 94 deletions(-)



X-sender: <linux-crypto+bounces-3088-steffen.klassert=3Dsecunet.com@vger.ke=
rnel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=3Drfc822;steffen.klassert@=
secunet.com; X-ExtendedProps=3DDwA1AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9y=
dC5EaXJlY3RvcnlEYXRhLklzUmVzb3VyY2UCAAAFABUAFgACAAAABQAUABEA8MUJLbkECUOS0gj=
aDTZ+uAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAG=
IAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IR=
jIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACh=
eZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJ=
hdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ0=
49c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhd=
GlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngt=
ZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmV=
jaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAGwAAgAABQBYABcASg=
AAAPDFCS25BAlDktII2g02frhDTj1LbGFzc2VydCBTdGVmZmVuLE9VPVVzZXJzLE9VPU1pZ3Jhd=
GlvbixEQz1zZWN1bmV0LERDPWRlBQAMAAIAAAUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNl=
U3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGN=
oYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW=
5zaW9uBQAjAAIAAQ=3D=3D
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAWUmmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2Vj=
dW5ldC5jb20FAAYAAgABDwAqAAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5SZXN1Ym1=
pdENvdW50BwACAAAADwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAg=
ABBQBiAAoAhAAAAM2KAAAFAGQADwADAAAASHViBQApAAIAAQ8APwAAAE1pY3Jvc29mdC5FeGNoY=
W5nZS5UcmFuc3BvcnQuRGlyZWN0b3J5RGF0YS5NYWlsRGVsaXZlcnlQcmlvcml0eQ8AAwAAAExv=
dw=3D=3D
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 39060
Received: from cas-essen-01.secunet.de (10.53.40.201) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Fri, 29 Mar 2024 23:59:59 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Fri, 29 Mar 2024 23:59:59 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 76A5F208B4
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:59:59 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -5.15
X-Spam-Level:
X-Spam-Status: No, score=3D-5.15 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.099, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_MED=3D-2.3, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dham autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Damd.com
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p6XZakEOCQGM for <steffen.klassert@secunet.com>;
	Fri, 29 Mar 2024 23:59:56 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D139.178.88.99; helo=3Dsv.mirrors.kernel.org; envelope-from=3Dlinux-crypt=
o+bounces-3088-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=3Ds=
teffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com BB5CE2087B
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id BB5CE2087B
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:59:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56055284471
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 22:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15DAB13D62A;
	Fri, 29 Mar 2024 22:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"aSZaNB8m"
X-Original-To: linux-crypto@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10=
on2068.outbound.protection.outlook.com [40.107.93.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F8C13D627;
	Fri, 29 Mar 2024 22:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.93.68
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753189; cv=3Dfail; b=3DKkzJ4D/hGOm6H7lybFTyphgcbndcau0OQMPGMJsmNWC=
/x9t/9udarNpuGuxJyPyaJnVmX1o3Z+bskjB4bbNnfizqxPl5tfOfn1mmirKOT5dS5jsb6vBK7Z=
yXLqk5KPcg9oc/sC7ExlRPL7QCTwc988a1J31/4gUX83WAT5lKaCg=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753189; c=3Drelaxed/simple;
	bh=3DyKD6Z3CWCO1R5YG84VSYV4FFCsF/dwEriI482bu3JTE=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=3DHk+w=
DZYD3447FsG7ra32Qs2LiWrfGrBfgJP5mvGU+fDcq/K12xfK0s8HNsSfuHFM9cGF0oegLiqFR+W=
ZAi/F/e83YH4KsNf5b8i7C82bYGZsMPEUhYtVyArcbVLSjmQZ7ePFPwfWeFekg7eWuvemZykQs9=
kfH4g/TukLviJMg5o=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3DaSZaNB8m; arc=3Dfail smtp.client-ip=3D40.107.93.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DHBib6RTkprrBtKFMtciyzEOREcrm6zXD+6o7WlqixvaMcQrdqN5lNgQjN/GEZi9eZ/Uk0V=
3KQrkcfK6MxgN+m5GoOojwNh6na3LS7IC3fOmbFDZa9cE67LaZJc6sBW/yuuY7ko4s39KK02Txk=
A+EKzY3oEVwkT2HlNkRM2Sz5JphvXbMdUhbDVYDY/a1vYK+JYZ3oH0sIp1kvHEFe/JS/uRy/NBW=
xvTD22+Sgkx0Rsi8jPf8smMuSBvvgPm8IdRtrAmRmClERDJqUVvbEHbilI7MdPRTD1c/kVau9zl=
p3M8f/SXbWI0+AOAdBFr9MFJBCeRMqTFhFZ1QUmTI16SzwQ=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DW6XwIhnbyiFwjhaPLMCpe4b4WhUMyHdpcDV6YoH2FTI=3D;
 b=3DEOrYX9UVMszmMEC0P71nwPAUTk+oJ8bi0wa1+MNrizAoGeNfdhdZR7Ox5jdSjdr5B+tz/V=
zeSl28+cjaYCCDAupsQ6y2G3j5I+pYlO254zExpr55GgXFCR8da2ZwPzn1Xf+n7JOM7kQjHfPn5=
T9ANvMtKktahv1wC8C0JwDStphIexbWCSQ8lI6Mw2bwxwc3h4om8C/JQAEDAASeRZ2mVWpstThj=
plsnKgX1kLjb/H9KsbwoSnhjSEJ03o6LXH9291ts9Ge2OvVyQLcPd05YW0ZQo7x3P8BnKSI+rdg=
dGDAbWW4O1O6IvN8BlBRTwux2RYG0oH6JRgP/znFJSzFIgA=3D=3D
ARC-Authentication-Results: i=3D1; mx.microsoft.com 1; spf=3Dpass (sender i=
p is
 165.204.84.17) smtp.rcpttodomain=3Dvger.kernel.org smtp.mailfrom=3Damd.com=
;
 dmarc=3Dpass (p=3Dquarantine sp=3Dquarantine pct=3D100) action=3Dnone
 header.from=3Damd.com; dkim=3Dnone (message not signed); arc=3Dnone (0)
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Damd.com; s=
=3Dselector1;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-S=
enderADCheck;
 bh=3DW6XwIhnbyiFwjhaPLMCpe4b4WhUMyHdpcDV6YoH2FTI=3D;
 b=3DaSZaNB8moAiu1c+h0xVa328kTLaCLFbUIKInKDNjwnVJ2vKM0v7xkwoq3/yuh4TLG8CFWO=
MrdRP05xwspSuAYrCdvt/jPpJH5FDRsd5oNdeKvYbNLT7G6d4qdPiA6CSwEB14LCrm03jVWxWUH=
O78SGetvuSC4b/QAzNcI2JKU2M=3D
Received: from BYAPR01CA0061.prod.exchangelabs.com (2603:10b6:a03:94::38) b=
y
 SA1PR12MB5613.namprd12.prod.outlook.com (2603:10b6:806:22b::21) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41; Fri, 29 =
Mar
 2024 22:59:43 +0000
Received: from SJ1PEPF00001CDD.namprd05.prod.outlook.com
 (2603:10b6:a03:94:cafe::86) by BYAPR01CA0061.outlook.office365.com
 (2603:10b6:a03:94::38) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Front=
end
 Transport; Fri, 29 Mar 2024 22:59:43 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDD.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 22:59:43 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 17:59:42 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v12 00/29] Add AMD Secure Nested Paging (SEV-SNP) Hyperviso=
r Support
Date: Fri, 29 Mar 2024 17:58:06 -0500
Message-ID: <20240329225835.400662-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDD:EE_|SA1PR12MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: 04df9763-f67a-45a0-895a-08dc5043ec=
53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QTkX01t/CQGSIM2UoVIeJlO6PgFFtT4/ZSzs6ZBM=
fywlsEggE0T3P1O6IwNW67dETu/srC97PsB2C3H82fJ3uFAuyuihNvj3DanNqrpJrReW55acuBp=
c5QoDloOchvUgSalLh6MC0rLNTWwNPDF32dQltsE3+4wtbctFxCOqTUcrw6dBf0mo1so3UfVvkq=
uik/DNNRRQg74GsJnuYMgCehsqmObheftRlx7v9YyH39swtytXT5/355UaJXYiJ1ORIKodLig4A=
72a9GSfHFZv8gOtV53GAR2pQGQZNAXI3iUw66LXuInNVdZzYmNi7vke7jyb0Cge3DQgruXP3xEm=
R5/Q2YmOG8em5CByb7PjYC87PjHq3DoMD6LjXXLDKIo9k47RAXXDXJBIR+XyLuHrPTn9J2IL+50=
tzVVq65VdVgzN9Eaq0BH3EkABJc/zUIMUkVrQbMfEDe9qS5xwrcrgSjSd4/AAlw+/DvB+McKk/y=
YEVJgh+uCJCxPhqKHsOupwtBoekOJqFOU4WJR4dza9mOGnK5H6yerRNox+GCeM6zTpqAEsjBR4V=
+ThlPgAvjvm3slVfzeeoBIbBlMZX0AW8ryCEA4H6DX+UFKFOHRZPtmQPEg0+ZJpLNLRX4W4dPut=
C9cXPiRbY+G54XW9UA1BXl3VJz7eJ4VkbOAt7CxsxZINDvWCsSDR4wd++l86SfnluAbGk6N45Gs=
u/4LSRBGQ0g=3D=3D
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(36860700004)(82310400014)(376005)(7416005)(1800799015);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 22:59:43.6602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04df9763-f67a-45a0-895a-08dc5=
043ec53
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CDD.namprd05.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5613
Return-Path: linux-crypto+bounces-3088-steffen.klassert=3Dsecunet.com@vger.=
kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 22:59:59.5071
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: c2cfe4bb-db27-4269-32a0-08dc=
5043f5b5
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.201
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-01.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-02.secunet.de:TOTAL-HUB=3D33545.849|SMR=3D0.135(SMRDE=3D0.005|SMRC=3D0.=
130(SMRCL=3D0.103|X-SMRCR=3D0.129))|CAT=3D0.086(CATOS=3D0.001
 |CATRESL=3D0.028(CATRESLP2R=3D0.022)|CATORES=3D0.053(CATRS=3D0.053(CATRS-T=
ransport
 Rule Agent=3D0.001 (X-ETREX=3D0.001)|CATRS-Index Routing
 Agent=3D0.050))|CATORT=3D0.001(CATRT=3D0.001))|UNK=3D0.002
 |QDM=3D10552.568|SMSC=3D0.603(X-SMSDR=3D0.010)|SMS=3D5.528(SMSMBXD-INC=3D5=
.020)|UNK=3D0.001|QDM=3D20218.892
 |SMS=3D3.839(SMSMBXD-INC=3D3.820)|QDM=3D2759.061|PSC=3D0.010|CAT=3D0.008(C=
ATRESL=3D0.007(CATRESLP2R=3D0.003
 ))|QDM=3D5.364|CAT=3D0.005(CATRESL=3D0.004(CATRESLP2R=3D0.002));2024-03-30=
T08:19:05.375Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-01.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 25204
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-01.secunet.de:TO=
TAL-FE=3D0.019|SMR=3D0.009(SMRPI=3D0.006(SMRPI-FrontendProxyAgent=3D0.006))=
|SMS=3D0.010
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-02
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-02
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAbEdAAAPAAADH4sIAAAAAAAEAO1b+XMb=
x5UeEMRBUJBsJ9
 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
 3XSdymVJvi80aWvEazJUEbUW+ZMcQEmvdLh2F2lQfu3TnAdO+6CGwM
 cctdW2AU9DTpdgpzd60J7MCtYFIM/yzfupGQKpKx9F09QzMPmKpGL7
 f+JhsVpgPJJZ7qFOdVPeulN52Z28MpY7bL+ElazXODVmGdMIBrewlc
 iLYR2hyh1Z90S6ZDeV3lVovSNzl5WZ4s0aTLuTXNOFNmXNX92iCD1R
 59zi3ZGOGMoDup/NSgFMKiQJNuePiZq7jx6JpYgI6dberDAs6CA9bV
 F43VXCssmDkY8KGa8/6Vh66MsQDYT9nWZVz/DV83avmM54SlPzrz7U
 +9f8rL2Hk65SM6udzv3bGk1U9ZckTu1yxXce6uZIpc7hcuQVtQ5XK/
 ueP6b5nadC/LXi73K5cNi3tY4pKy0EFVVu4XLjUbTbncv7g8y/Vc7n
 dz09dS7kv3MbPdH25elOV3XPcX6TTksxvXv3DZvnG9NLvpv83ZxVz/
 XK67Obqkb31mb1ngxfOiEN2smXoJCpFN9cNTIl/Y522pDInsw7Z+mN
 105pakm1zun1392DZB603jf15CjDVWqOQeyMWl/waj9ZH3ME8AAAEL
 pwQ8P3htbCB2ZXJzaW9uPSIxLjAiIGVuY29kaW5nPSJ1dGYtMTYiPz
 4NCjxVcmxTZXQ+DQogIDxWZXJzaW9uPjE1LjAuMC4wPC9WZXJzaW9u
 Pg0KICA8VXJscz4NCiAgICA8VXJsIFN0YXJ0SW5kZXg9IjQxIiBUeX
 BlPSJVcmwiPg0KICAgICAgPFVybFN0cmluZz5odHRwczovL2dpdGh1
 Yi5jb20vYW1kZXNlL2xpbnV4L2NvbW1pdHMvc25wLWhvc3QtdjEyPC
 9VcmxTdHJpbmc+DQogICAgPC9Vcmw+DQogICAgPFVybCBTdGFydElu
 ZGV4PSIyMjEiIFR5cGU9IlVybCI+DQogICAgICA8VXJsU3RyaW5nPm
 h0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDI0MDMyOTIxMjQ0
 NC4zOTU1NTktMS1taWNoYWVsLnJvdGhAYW1kLmNvbS88L1VybFN0cm
 luZz4NCiAgICA8L1VybD4NCiAgICA8VXJsIFN0YXJ0SW5kZXg9IjMz
 MCIgVHlwZT0iVXJsIj4NCiAgICAgIDxVcmxTdHJpbmc+aHR0cHM6Ly
 9naXQua2VybmVsLm9yZy9wdWIvc2NtL3ZpcnQva3ZtL2t2bS5naXQv
 bG9nLz9oPWt2bS1jb2NvLXF1ZXVlPC9VcmxTdHJpbmc+DQogICAgPC
 9Vcmw+DQogIDwvVXJscz4NCjwvVXJsU2V0PgEO0AFSZXRyaWV2ZXJP
 cGVyYXRvciwxMCwyO1JldHJpZXZlck9wZXJhdG9yLDExLDQ7UG9zdE
 RvY1BhcnNlck9wZXJhdG9yLDEwLDE7UG9zdERvY1BhcnNlck9wZXJh
 dG9yLDExLDA7UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY09wZXJhdG
 9yLDEwLDEwO1Bvc3RXb3JkQnJlYWtlckRpYWdub3N0aWNPcGVyYXRv
 ciwxMSwwO1RyYW5zcG9ydFdyaXRlclByb2R1Y2VyLDIwLDE5
X-MS-Exchange-Forest-IndexAgent: 1 8379
X-MS-Exchange-Forest-EmailMessageHash: EA9105F1
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=3DLow
X-MS-Exchange-Organization-Prioritization: 2:RC:REDACTED-af51df60fd698f80b0=
64826f9ee192ca@secunet.com:85/10|SR
X-MS-Exchange-Organization-IncludeInSla: False:RecipientCountThresholdExcee=
ded

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-host-v12

and is based on top of the following series:

  [PATCH gmem 0/6] gmem fix-ups and interfaces for populating gmem pages
  https://lore.kernel.org/kvm/20240329212444.395559-1-michael.roth@amd.com/=
=20

which in turn is based on:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=3Dkvm-coco-queue


Patch Layout
------------

01-04: These patches are minor dependencies for this series and will
       eventually make their way upstream through other trees. They are
       included here only temporarily.

05-09: These patches add some basic infrastructure and introduces a new
       KVM_X86_SNP_VM vm_type to handle differences verses the existing
       KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.

10-12: These implement the KVM API to handle the creation of a
       cryptographic launch context, encrypt/measure the initial image
       into guest memory, and finalize it before launching it.

13-20: These implement handling for various guest-generated events such
       as page state changes, onlining of additional vCPUs, etc.

21-24: These implement the gmem hooks needed to prepare gmem-allocated
       pages before mapping them into guest private memory ranges as
       well as cleaning them up prior to returning them to the host for
       use as normal memory. Because this supplants certain activities
       like issued WBINVDs during KVM MMU invalidations, there's also
       a patch to avoid duplicating that work to avoid unecessary
       overhead.

25:    With all the core support in place, the patch adds a kvm_amd module
       parameter to enable SNP support.

26-29: These patches all deal with the servicing of guest requests to handl=
e
       things like attestation, as well as some related host-management
       interfaces.


Testing
-------

For testing this via QEMU, use the following tree:

  https://github.com/amdese/qemu/commits/snp-v4-wip2

A patched OVMF is also needed due to upstream KVM no longer supporting MMIO
ranges that are mapped as private. It is recommended you build the AmdSevX6=
4
variant as it provides the kernel-hashing support present in this series:

  https://github.com/amdese/ovmf/commits/apic-mmio-fix1c

A basic command-line invocation for SNP would be:

 qemu-system-x86_64 -smp 32,maxcpus=3D255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram1
  -object memory-backend-memfd,id=3Dram1,size=3D4G,share=3Dtrue,reserve=3Df=
alse
  -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,id-aut=
h=3D
  -bios /home/mroth/ovmf/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX64.f=
d

With kernel-hashing and certificate data supplied:

 qemu-system-x86_64 -smp 32,maxcpus=3D255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram1
  -object memory-backend-memfd,id=3Dram1,size=3D4G,share=3Dtrue,reserve=3Df=
alse
  -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,id-aut=
h=3D,certs-path=3D/home/mroth/cert.blob,kernel-hashes=3Don
  -bios /home/mroth/ovmf/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX64.f=
d
  -kernel /boot/vmlinuz-6.8.0-snp-host-v12-wip40+
  -initrd /boot/initrd.img-6.8.0-snp-host-v12-wip40+
  -append "root=3DUUID=3Dd72a6d1c-06cf-4b79-af43-f1bac4f620f9 ro console=3D=
ttyS0,115200n8"


Known issues / TODOs
--------------------

 * Base tree in some cases reports "Unpatched return thunk in use. This sho=
uld=20
   not happen!" the first time it runs an SVM/SEV/SNP guests. This a recent
   regression upstream and unrelated to this series:

     https://lore.kernel.org/linux-kernel/CANpmjNOcKzEvLHoGGeL-boWDHJobwfwy=
VxUqMq2kWeka3N4tXA@mail.gmail.com/T/

 * 2MB hugepage support has been dropped pending discussion on how we plan
   to re-enable it in gmem.

 * Host kexec should work, but there is a known issue with handling host
   kdump while SNP guests are running which will be addressed as a follow-u=
p.

 * SNP kselftests are currently a WIP and will be included as part of SNP
   upstreaming efforts in the near-term.


SEV-SNP Overview
----------------

This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
changes required to add KVM support for SEV-SNP. This series builds upon
SEV-SNP guest support, which is now in mainline, and and SEV-SNP host
initialization support, which is now in linux-next.

While series provides the basic building blocks to support booting the
SEV-SNP VMs, it does not cover all the security enhancement introduced by
the SEV-SNP such as interrupt protection, which will added in the future.

With SNP, when pages are marked as guest-owned in the RMP table, they are
assigned to a specific guest/ASID, as well as a specific GFN with in the
guest. Any attempts to map it in the RMP table to a different guest/ASID,
or a different GFN within a guest/ASID, will result in an RMP nested page
fault.

Prior to accessing a guest-owned page, the guest must validate it with a
special PVALIDATE instruction which will set a special bit in the RMP table
for the guest. This is the only way to set the validated bit outside of the
initial pre-encrypted guest payload/image; any attempts outside the guest t=
o
modify the RMP entry from that point forward will result in the validated
bit being cleared, at which point the guest will trigger an exception if it
attempts to access that page so it can be made aware of possible tampering.

One exception to this is the initial guest payload, which is pre-validated
by the firmware prior to launching. The guest can use Guest Message request=
s=20
to fetch an attestation report which will include the measurement of the
initial image so that the guest can verify it was booted with the expected
image/environment.

After boot, guests can use Page State Change requests to switch pages
between shared/hypervisor-owned and private/guest-owned to share data for
things like DMA, virtio buffers, and other GHCB requests.

In this implementation of SEV-SNP, private guest memory is managed by a new
kernel framework called guest_memfd (gmem). With gmem, a new
KVM_SET_MEMORY_ATTRIBUTES KVM ioctl has been added to tell the KVM
MMU whether a particular GFN should be backed by shared (normal) memory or
private (gmem-allocated) memory. To tie into this, Page State Change
requests are forward to userspace via KVM_EXIT_VMGEXIT exits, which will
then issue the corresponding KVM_SET_MEMORY_ATTRIBUTES call to set the
private/shared state in the KVM MMU.

The gmem / KVM MMU hooks implemented in this series will then update the RM=
P
table entries for the backing PFNs to set them to guest-owned/private when
mapping private pages into the guest via KVM MMU, or use the normal KVM MMU
handling in the case of shared pages where the corresponding RMP table
entries are left in the default shared/hypervisor-owned state.

Feedback/review is very much appreciated!

-Mike

Changes since v11:

 * Rebase series on kvm-coco-queue and re-work to leverage more
   infrastructure between SNP/TDX series.
 * Drop KVM_SNP_INIT in favor of the new KVM_SEV_INIT2 interface introduced
   here (Paolo):
     https://lore.kernel.org/lkml/20240318233352.2728327-1-pbonzini@redhat.=
com/
 * Drop exposure API fields related to things like VMPL levels, migration
   agents, etc., until they are actually supported/used (Sean)
 * Rework KVM_SEV_SNP_LAUNCH_UPDATE handling to use a new
   kvm_gmem_populate() interface instead of copying data directly into
   gmem-allocated pages (Sean)
 * Add support for SNP_LOAD_VLEK, rework the SNP_SET_CONFIG_{START,END} to
   have simpler semantics that are applicable to management of SNP_LOAD_VLE=
K
   updates as well, rename interfaces to the now more appropriate
   SNP_{PAUSE,RESUME}_ATTESTATION
 * Fix up documentation wording and do print warnings for
   userspace-triggerable failures (Peter, Sean)
 * Fix a race with AP_CREATION wake-up events (Jacob, Sean)
 * Fix a memory leak with VMSA pages (Sean)
 * Tighten up handling of RMP page faults to better distinguish between rea=
l
   and spurious cases (Tom)
 * Various patch/documentation rewording, cleanups, etc.

Changes since v10:

 * Split off host initialization patches to separate series
 * Drop SNP_{SET,GET}_EXT_CONFIG SEV ioctls, and drop=20
   KVM_SEV_SNP_{SET,GET}_CERTS KVM ioctls. Instead, all certificate data is
   now fetched from uerspace as part of a new KVM_EXIT_VMGEXIT event type.
   (Sean, Dionna)
 * SNP_SET_EXT_CONFIG is now replaced with a more basic SNP_SET_CONFIG,
   which is now just a light wrapper around the SNP_CONFIG firmware command=
,
   and SNP_GET_EXT_CONFIG is now redundant with existing SNP_PLATFORM_STATU=
S,
   so just stick with that interface
 * Introduce SNP_SET_CONFIG_{START,END}, which can be used to pause extende=
d
   guest requests while reported TCB / certificates are being updated so
   the updates are done atomically relative to running guests.
 * Improve documentation for KVM_EXIT_VMGEXIT event types and tighten down
   the expected input/output for union types rather than exposing GHCB
   page/MSR
 * Various re-factorings, commit/comments fixups (Boris, Liam, Vlastimil)=20
 * Make CONFIG_KVM_AMD_SEV depend on KVM_GENERIC_PRIVATE_MEM instead of
   CONFIG_KVM_SW_PROTECTED_VM (Paolo)
 * Include Sean's patch to add hugepage support to gmem, but modify it base=
d
   on discussions to be best-effort and not rely on explicit flag

----------------------------------------------------------------
Ashish Kalra (1):
      KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP

Borislav Petkov (AMD) (3):
      [TEMP] x86/kvm/Kconfig: Have KVM_AMD_SEV select ARCH_HAS_CC_PLATFORM
      [TEMP] x86/cc: Add cc_platform_set/_clear() helpers
      [TEMP] x86/CPU/AMD: Track SNP host status with cc_platform_*()

Brijesh Singh (11):
      KVM: x86: Define RMP page fault error bits for #NPF
      KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
      KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
      KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
      KVM: SEV: Add support to handle Page State Change VMGEXIT
      KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
      KVM: SEV: Add support to handle RMP nested page faults
      KVM: SVM: Add module parameter to enable the SEV-SNP
      KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event

Michael Roth (10):
      KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=3Dy
      KVM: SEV: Add initial SEV-SNP support
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
      KVM: SEV: Add support for GHCB-based termination requests
      KVM: SEV: Implement gmem hook for initializing private pages
      KVM: SEV: Implement gmem hook for invalidating private pages
      KVM: x86: Implement gmem hook for determining max NPT mapping level
      crypto: ccp: Add the SNP_VLEK_LOAD command
      crypto: ccp: Add the SNP_{PAUSE,RESUME}_ATTESTATION commands
      KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event

Paolo Bonzini (1):
      [TEMP] fixup! KVM: SEV: sync FPU and AVX state at LAUNCH_UPDATE_VMSA =
time

Tom Lendacky (3):
      KVM: SEV: Add support to handle AP reset MSR protocol
      KVM: SEV: Use a VMSA physical address variable for populating VMCB
      KVM: SEV: Support SEV-SNP AP Creation NAE event

 Documentation/virt/coco/sev-guest.rst              |   50 +-
 Documentation/virt/kvm/api.rst                     |   73 +
 .../virt/kvm/x86/amd-memory-encryption.rst         |   88 +-
 arch/x86/coco/core.c                               |   52 +
 arch/x86/include/asm/kvm_host.h                    |    8 +
 arch/x86/include/asm/sev-common.h                  |   22 +-
 arch/x86/include/asm/sev.h                         |   15 +-
 arch/x86/include/asm/svm.h                         |    9 +-
 arch/x86/include/uapi/asm/kvm.h                    |   39 +
 arch/x86/kernel/cpu/amd.c                          |   38 +-
 arch/x86/kernel/cpu/mtrr/generic.c                 |    2 +-
 arch/x86/kernel/fpu/xstate.c                       |    1 +
 arch/x86/kernel/sev.c                              |   10 -
 arch/x86/kvm/Kconfig                               |    4 +
 arch/x86/kvm/mmu.h                                 |    2 -
 arch/x86/kvm/mmu/mmu.c                             |    1 +
 arch/x86/kvm/svm/sev.c                             | 1410 ++++++++++++++++=
+++-
 arch/x86/kvm/svm/svm.c                             |   48 +-
 arch/x86/kvm/svm/svm.h                             |   50 +
 arch/x86/kvm/x86.c                                 |   18 +-
 arch/x86/virt/svm/sev.c                            |   90 +-
 drivers/crypto/ccp/sev-dev.c                       |   85 +-
 drivers/iommu/amd/init.c                           |    4 +-
 include/linux/cc_platform.h                        |   12 +
 include/linux/psp-sev.h                            |    4 +-
 include/uapi/linux/kvm.h                           |   28 +
 include/uapi/linux/psp-sev.h                       |   39 +
 include/uapi/linux/sev-guest.h                     |    9 +
 virt/kvm/guest_memfd.c                             |    4 +-
 29 files changed, 2121 insertions(+), 94 deletions(-)



X-sender: <linux-kernel+bounces-125488-steffen.klassert=3Dsecunet.com@vger.=
kernel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=3Drfc822;steffen.klassert@=
secunet.com
X-CreatedBy: MSExchange15
X-HeloDomain: mbx-essen-01.secunet.de
X-ExtendedProps: BQBjAAoApUmmlidQ3AgFADcAAgAADwA8AAAATWljcm9zb2Z0LkV4Y2hhbm=
dlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50Lk9yZ2FuaXphdGlvblNjb3BlEQAAAAAAAAAAAAAAA=
AAAAAAADwA/AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLk1h=
aWxEZWxpdmVyeVByaW9yaXR5DwADAAAATG93
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 10.53.40.197
X-EndOfInjectedXHeaders: 25836
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:00:21 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:00:21 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id 4AD4E2032C
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:00:21 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -5.15
X-Spam-Level:
X-Spam-Status: No, score=3D-5.15 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.099, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_MED=3D-2.3, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dham autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Damd.com
Received: from b.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id adSVMqKikTJV for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:00:17 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.199.223; helo=3Dny.mirrors.kernel.org; envelope-from=3Dlinux-kern=
el+bounces-125488-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 10922200BB
Authentication-Results: b.mx.secunet.com;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"aSZaNB8m"
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223=
])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id 10922200BB
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:00:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 332371C2118E
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF9F113E6BF;
	Fri, 29 Mar 2024 22:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"aSZaNB8m"
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10=
on2068.outbound.protection.outlook.com [40.107.93.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F8C13D627;
	Fri, 29 Mar 2024 22:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.93.68
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753189; cv=3Dfail; b=3DKkzJ4D/hGOm6H7lybFTyphgcbndcau0OQMPGMJsmNWC=
/x9t/9udarNpuGuxJyPyaJnVmX1o3Z+bskjB4bbNnfizqxPl5tfOfn1mmirKOT5dS5jsb6vBK7Z=
yXLqk5KPcg9oc/sC7ExlRPL7QCTwc988a1J31/4gUX83WAT5lKaCg=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753189; c=3Drelaxed/simple;
	bh=3DyKD6Z3CWCO1R5YG84VSYV4FFCsF/dwEriI482bu3JTE=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=3DHk+w=
DZYD3447FsG7ra32Qs2LiWrfGrBfgJP5mvGU+fDcq/K12xfK0s8HNsSfuHFM9cGF0oegLiqFR+W=
ZAi/F/e83YH4KsNf5b8i7C82bYGZsMPEUhYtVyArcbVLSjmQZ7ePFPwfWeFekg7eWuvemZykQs9=
kfH4g/TukLviJMg5o=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3DaSZaNB8m; arc=3Dfail smtp.client-ip=3D40.107.93.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DHBib6RTkprrBtKFMtciyzEOREcrm6zXD+6o7WlqixvaMcQrdqN5lNgQjN/GEZi9eZ/Uk0V=
3KQrkcfK6MxgN+m5GoOojwNh6na3LS7IC3fOmbFDZa9cE67LaZJc6sBW/yuuY7ko4s39KK02Txk=
A+EKzY3oEVwkT2HlNkRM2Sz5JphvXbMdUhbDVYDY/a1vYK+JYZ3oH0sIp1kvHEFe/JS/uRy/NBW=
xvTD22+Sgkx0Rsi8jPf8smMuSBvvgPm8IdRtrAmRmClERDJqUVvbEHbilI7MdPRTD1c/kVau9zl=
p3M8f/SXbWI0+AOAdBFr9MFJBCeRMqTFhFZ1QUmTI16SzwQ=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DW6XwIhnbyiFwjhaPLMCpe4b4WhUMyHdpcDV6YoH2FTI=3D;
 b=3DEOrYX9UVMszmMEC0P71nwPAUTk+oJ8bi0wa1+MNrizAoGeNfdhdZR7Ox5jdSjdr5B+tz/V=
zeSl28+cjaYCCDAupsQ6y2G3j5I+pYlO254zExpr55GgXFCR8da2ZwPzn1Xf+n7JOM7kQjHfPn5=
T9ANvMtKktahv1wC8C0JwDStphIexbWCSQ8lI6Mw2bwxwc3h4om8C/JQAEDAASeRZ2mVWpstThj=
plsnKgX1kLjb/H9KsbwoSnhjSEJ03o6LXH9291ts9Ge2OvVyQLcPd05YW0ZQo7x3P8BnKSI+rdg=
dGDAbWW4O1O6IvN8BlBRTwux2RYG0oH6JRgP/znFJSzFIgA=3D=3D
ARC-Authentication-Results: i=3D1; mx.microsoft.com 1; spf=3Dpass (sender i=
p is
 165.204.84.17) smtp.rcpttodomain=3Dvger.kernel.org smtp.mailfrom=3Damd.com=
;
 dmarc=3Dpass (p=3Dquarantine sp=3Dquarantine pct=3D100) action=3Dnone
 header.from=3Damd.com; dkim=3Dnone (message not signed); arc=3Dnone (0)
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Damd.com; s=
=3Dselector1;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-S=
enderADCheck;
 bh=3DW6XwIhnbyiFwjhaPLMCpe4b4WhUMyHdpcDV6YoH2FTI=3D;
 b=3DaSZaNB8moAiu1c+h0xVa328kTLaCLFbUIKInKDNjwnVJ2vKM0v7xkwoq3/yuh4TLG8CFWO=
MrdRP05xwspSuAYrCdvt/jPpJH5FDRsd5oNdeKvYbNLT7G6d4qdPiA6CSwEB14LCrm03jVWxWUH=
O78SGetvuSC4b/QAzNcI2JKU2M=3D
Received: from BYAPR01CA0061.prod.exchangelabs.com (2603:10b6:a03:94::38) b=
y
 SA1PR12MB5613.namprd12.prod.outlook.com (2603:10b6:806:22b::21) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41; Fri, 29 =
Mar
 2024 22:59:43 +0000
Received: from SJ1PEPF00001CDD.namprd05.prod.outlook.com
 (2603:10b6:a03:94:cafe::86) by BYAPR01CA0061.outlook.office365.com
 (2603:10b6:a03:94::38) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Front=
end
 Transport; Fri, 29 Mar 2024 22:59:43 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDD.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 22:59:43 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 17:59:42 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v12 00/29] Add AMD Secure Nested Paging (SEV-SNP) Hyperviso=
r Support
Date: Fri, 29 Mar 2024 17:58:06 -0500
Message-ID: <20240329225835.400662-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org
List-Id: <linux-kernel.vger.kernel.org>
List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDD:EE_|SA1PR12MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: 04df9763-f67a-45a0-895a-08dc5043ec=
53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QTkX01t/CQGSIM2UoVIeJlO6PgFFtT4/ZSzs6ZBM=
fywlsEggE0T3P1O6IwNW67dETu/srC97PsB2C3H82fJ3uFAuyuihNvj3DanNqrpJrReW55acuBp=
c5QoDloOchvUgSalLh6MC0rLNTWwNPDF32dQltsE3+4wtbctFxCOqTUcrw6dBf0mo1so3UfVvkq=
uik/DNNRRQg74GsJnuYMgCehsqmObheftRlx7v9YyH39swtytXT5/355UaJXYiJ1ORIKodLig4A=
72a9GSfHFZv8gOtV53GAR2pQGQZNAXI3iUw66LXuInNVdZzYmNi7vke7jyb0Cge3DQgruXP3xEm=
R5/Q2YmOG8em5CByb7PjYC87PjHq3DoMD6LjXXLDKIo9k47RAXXDXJBIR+XyLuHrPTn9J2IL+50=
tzVVq65VdVgzN9Eaq0BH3EkABJc/zUIMUkVrQbMfEDe9qS5xwrcrgSjSd4/AAlw+/DvB+McKk/y=
YEVJgh+uCJCxPhqKHsOupwtBoekOJqFOU4WJR4dza9mOGnK5H6yerRNox+GCeM6zTpqAEsjBR4V=
+ThlPgAvjvm3slVfzeeoBIbBlMZX0AW8ryCEA4H6DX+UFKFOHRZPtmQPEg0+ZJpLNLRX4W4dPut=
C9cXPiRbY+G54XW9UA1BXl3VJz7eJ4VkbOAt7CxsxZINDvWCsSDR4wd++l86SfnluAbGk6N45Gs=
u/4LSRBGQ0g=3D=3D
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(36860700004)(82310400014)(376005)(7416005)(1800799015);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 22:59:43.6602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04df9763-f67a-45a0-895a-08dc5=
043ec53
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CDD.namprd05.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5613
Return-Path: linux-kernel+bounces-125488-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:00:21.3415
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: a64cd096-8e42-4e66-dde2-08dc=
504402b8
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dcas-es=
sen-02.secunet.de:TOTAL-FE=3D0.007|SMR=3D0.007(SMRPI=3D0.004(SMRPI-Frontend=
ProxyAgent=3D0.004));2024-03-29T23:00:21.349Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-OriginalSize: 25291
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=3DLow
X-MS-Exchange-Organization-Prioritization: 2:ShadowRedundancy
X-MS-Exchange-Organization-IncludeInSla: False:ShadowRedundancy

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-host-v12

and is based on top of the following series:

  [PATCH gmem 0/6] gmem fix-ups and interfaces for populating gmem pages
  https://lore.kernel.org/kvm/20240329212444.395559-1-michael.roth@amd.com/=
=20

which in turn is based on:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=3Dkvm-coco-queue


Patch Layout
------------

01-04: These patches are minor dependencies for this series and will
       eventually make their way upstream through other trees. They are
       included here only temporarily.

05-09: These patches add some basic infrastructure and introduces a new
       KVM_X86_SNP_VM vm_type to handle differences verses the existing
       KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.

10-12: These implement the KVM API to handle the creation of a
       cryptographic launch context, encrypt/measure the initial image
       into guest memory, and finalize it before launching it.

13-20: These implement handling for various guest-generated events such
       as page state changes, onlining of additional vCPUs, etc.

21-24: These implement the gmem hooks needed to prepare gmem-allocated
       pages before mapping them into guest private memory ranges as
       well as cleaning them up prior to returning them to the host for
       use as normal memory. Because this supplants certain activities
       like issued WBINVDs during KVM MMU invalidations, there's also
       a patch to avoid duplicating that work to avoid unecessary
       overhead.

25:    With all the core support in place, the patch adds a kvm_amd module
       parameter to enable SNP support.

26-29: These patches all deal with the servicing of guest requests to handl=
e
       things like attestation, as well as some related host-management
       interfaces.


Testing
-------

For testing this via QEMU, use the following tree:

  https://github.com/amdese/qemu/commits/snp-v4-wip2

A patched OVMF is also needed due to upstream KVM no longer supporting MMIO
ranges that are mapped as private. It is recommended you build the AmdSevX6=
4
variant as it provides the kernel-hashing support present in this series:

  https://github.com/amdese/ovmf/commits/apic-mmio-fix1c

A basic command-line invocation for SNP would be:

 qemu-system-x86_64 -smp 32,maxcpus=3D255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram1
  -object memory-backend-memfd,id=3Dram1,size=3D4G,share=3Dtrue,reserve=3Df=
alse
  -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,id-aut=
h=3D
  -bios /home/mroth/ovmf/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX64.f=
d

With kernel-hashing and certificate data supplied:

 qemu-system-x86_64 -smp 32,maxcpus=3D255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram1
  -object memory-backend-memfd,id=3Dram1,size=3D4G,share=3Dtrue,reserve=3Df=
alse
  -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,id-aut=
h=3D,certs-path=3D/home/mroth/cert.blob,kernel-hashes=3Don
  -bios /home/mroth/ovmf/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX64.f=
d
  -kernel /boot/vmlinuz-6.8.0-snp-host-v12-wip40+
  -initrd /boot/initrd.img-6.8.0-snp-host-v12-wip40+
  -append "root=3DUUID=3Dd72a6d1c-06cf-4b79-af43-f1bac4f620f9 ro console=3D=
ttyS0,115200n8"


Known issues / TODOs
--------------------

 * Base tree in some cases reports "Unpatched return thunk in use. This sho=
uld=20
   not happen!" the first time it runs an SVM/SEV/SNP guests. This a recent
   regression upstream and unrelated to this series:

     https://lore.kernel.org/linux-kernel/CANpmjNOcKzEvLHoGGeL-boWDHJobwfwy=
VxUqMq2kWeka3N4tXA@mail.gmail.com/T/

 * 2MB hugepage support has been dropped pending discussion on how we plan
   to re-enable it in gmem.

 * Host kexec should work, but there is a known issue with handling host
   kdump while SNP guests are running which will be addressed as a follow-u=
p.

 * SNP kselftests are currently a WIP and will be included as part of SNP
   upstreaming efforts in the near-term.


SEV-SNP Overview
----------------

This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
changes required to add KVM support for SEV-SNP. This series builds upon
SEV-SNP guest support, which is now in mainline, and and SEV-SNP host
initialization support, which is now in linux-next.

While series provides the basic building blocks to support booting the
SEV-SNP VMs, it does not cover all the security enhancement introduced by
the SEV-SNP such as interrupt protection, which will added in the future.

With SNP, when pages are marked as guest-owned in the RMP table, they are
assigned to a specific guest/ASID, as well as a specific GFN with in the
guest. Any attempts to map it in the RMP table to a different guest/ASID,
or a different GFN within a guest/ASID, will result in an RMP nested page
fault.

Prior to accessing a guest-owned page, the guest must validate it with a
special PVALIDATE instruction which will set a special bit in the RMP table
for the guest. This is the only way to set the validated bit outside of the
initial pre-encrypted guest payload/image; any attempts outside the guest t=
o
modify the RMP entry from that point forward will result in the validated
bit being cleared, at which point the guest will trigger an exception if it
attempts to access that page so it can be made aware of possible tampering.

One exception to this is the initial guest payload, which is pre-validated
by the firmware prior to launching. The guest can use Guest Message request=
s=20
to fetch an attestation report which will include the measurement of the
initial image so that the guest can verify it was booted with the expected
image/environment.

After boot, guests can use Page State Change requests to switch pages
between shared/hypervisor-owned and private/guest-owned to share data for
things like DMA, virtio buffers, and other GHCB requests.

In this implementation of SEV-SNP, private guest memory is managed by a new
kernel framework called guest_memfd (gmem). With gmem, a new
KVM_SET_MEMORY_ATTRIBUTES KVM ioctl has been added to tell the KVM
MMU whether a particular GFN should be backed by shared (normal) memory or
private (gmem-allocated) memory. To tie into this, Page State Change
requests are forward to userspace via KVM_EXIT_VMGEXIT exits, which will
then issue the corresponding KVM_SET_MEMORY_ATTRIBUTES call to set the
private/shared state in the KVM MMU.

The gmem / KVM MMU hooks implemented in this series will then update the RM=
P
table entries for the backing PFNs to set them to guest-owned/private when
mapping private pages into the guest via KVM MMU, or use the normal KVM MMU
handling in the case of shared pages where the corresponding RMP table
entries are left in the default shared/hypervisor-owned state.

Feedback/review is very much appreciated!

-Mike

Changes since v11:

 * Rebase series on kvm-coco-queue and re-work to leverage more
   infrastructure between SNP/TDX series.
 * Drop KVM_SNP_INIT in favor of the new KVM_SEV_INIT2 interface introduced
   here (Paolo):
     https://lore.kernel.org/lkml/20240318233352.2728327-1-pbonzini@redhat.=
com/
 * Drop exposure API fields related to things like VMPL levels, migration
   agents, etc., until they are actually supported/used (Sean)
 * Rework KVM_SEV_SNP_LAUNCH_UPDATE handling to use a new
   kvm_gmem_populate() interface instead of copying data directly into
   gmem-allocated pages (Sean)
 * Add support for SNP_LOAD_VLEK, rework the SNP_SET_CONFIG_{START,END} to
   have simpler semantics that are applicable to management of SNP_LOAD_VLE=
K
   updates as well, rename interfaces to the now more appropriate
   SNP_{PAUSE,RESUME}_ATTESTATION
 * Fix up documentation wording and do print warnings for
   userspace-triggerable failures (Peter, Sean)
 * Fix a race with AP_CREATION wake-up events (Jacob, Sean)
 * Fix a memory leak with VMSA pages (Sean)
 * Tighten up handling of RMP page faults to better distinguish between rea=
l
   and spurious cases (Tom)
 * Various patch/documentation rewording, cleanups, etc.

Changes since v10:

 * Split off host initialization patches to separate series
 * Drop SNP_{SET,GET}_EXT_CONFIG SEV ioctls, and drop=20
   KVM_SEV_SNP_{SET,GET}_CERTS KVM ioctls. Instead, all certificate data is
   now fetched from uerspace as part of a new KVM_EXIT_VMGEXIT event type.
   (Sean, Dionna)
 * SNP_SET_EXT_CONFIG is now replaced with a more basic SNP_SET_CONFIG,
   which is now just a light wrapper around the SNP_CONFIG firmware command=
,
   and SNP_GET_EXT_CONFIG is now redundant with existing SNP_PLATFORM_STATU=
S,
   so just stick with that interface
 * Introduce SNP_SET_CONFIG_{START,END}, which can be used to pause extende=
d
   guest requests while reported TCB / certificates are being updated so
   the updates are done atomically relative to running guests.
 * Improve documentation for KVM_EXIT_VMGEXIT event types and tighten down
   the expected input/output for union types rather than exposing GHCB
   page/MSR
 * Various re-factorings, commit/comments fixups (Boris, Liam, Vlastimil)=20
 * Make CONFIG_KVM_AMD_SEV depend on KVM_GENERIC_PRIVATE_MEM instead of
   CONFIG_KVM_SW_PROTECTED_VM (Paolo)
 * Include Sean's patch to add hugepage support to gmem, but modify it base=
d
   on discussions to be best-effort and not rely on explicit flag

----------------------------------------------------------------
Ashish Kalra (1):
      KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP

Borislav Petkov (AMD) (3):
      [TEMP] x86/kvm/Kconfig: Have KVM_AMD_SEV select ARCH_HAS_CC_PLATFORM
      [TEMP] x86/cc: Add cc_platform_set/_clear() helpers
      [TEMP] x86/CPU/AMD: Track SNP host status with cc_platform_*()

Brijesh Singh (11):
      KVM: x86: Define RMP page fault error bits for #NPF
      KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
      KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
      KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
      KVM: SEV: Add support to handle Page State Change VMGEXIT
      KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
      KVM: SEV: Add support to handle RMP nested page faults
      KVM: SVM: Add module parameter to enable the SEV-SNP
      KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event

Michael Roth (10):
      KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=3Dy
      KVM: SEV: Add initial SEV-SNP support
      KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
      KVM: SEV: Add support for GHCB-based termination requests
      KVM: SEV: Implement gmem hook for initializing private pages
      KVM: SEV: Implement gmem hook for invalidating private pages
      KVM: x86: Implement gmem hook for determining max NPT mapping level
      crypto: ccp: Add the SNP_VLEK_LOAD command
      crypto: ccp: Add the SNP_{PAUSE,RESUME}_ATTESTATION commands
      KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event

Paolo Bonzini (1):
      [TEMP] fixup! KVM: SEV: sync FPU and AVX state at LAUNCH_UPDATE_VMSA =
time

Tom Lendacky (3):
      KVM: SEV: Add support to handle AP reset MSR protocol
      KVM: SEV: Use a VMSA physical address variable for populating VMCB
      KVM: SEV: Support SEV-SNP AP Creation NAE event

 Documentation/virt/coco/sev-guest.rst              |   50 +-
 Documentation/virt/kvm/api.rst                     |   73 +
 .../virt/kvm/x86/amd-memory-encryption.rst         |   88 +-
 arch/x86/coco/core.c                               |   52 +
 arch/x86/include/asm/kvm_host.h                    |    8 +
 arch/x86/include/asm/sev-common.h                  |   22 +-
 arch/x86/include/asm/sev.h                         |   15 +-
 arch/x86/include/asm/svm.h                         |    9 +-
 arch/x86/include/uapi/asm/kvm.h                    |   39 +
 arch/x86/kernel/cpu/amd.c                          |   38 +-
 arch/x86/kernel/cpu/mtrr/generic.c                 |    2 +-
 arch/x86/kernel/fpu/xstate.c                       |    1 +
 arch/x86/kernel/sev.c                              |   10 -
 arch/x86/kvm/Kconfig                               |    4 +
 arch/x86/kvm/mmu.h                                 |    2 -
 arch/x86/kvm/mmu/mmu.c                             |    1 +
 arch/x86/kvm/svm/sev.c                             | 1410 ++++++++++++++++=
+++-
 arch/x86/kvm/svm/svm.c                             |   48 +-
 arch/x86/kvm/svm/svm.h                             |   50 +
 arch/x86/kvm/x86.c                                 |   18 +-
 arch/x86/virt/svm/sev.c                            |   90 +-
 drivers/crypto/ccp/sev-dev.c                       |   85 +-
 drivers/iommu/amd/init.c                           |    4 +-
 include/linux/cc_platform.h                        |   12 +
 include/linux/psp-sev.h                            |    4 +-
 include/uapi/linux/kvm.h                           |   28 +
 include/uapi/linux/psp-sev.h                       |   39 +
 include/uapi/linux/sev-guest.h                     |    9 +
 virt/kvm/guest_memfd.c                             |    4 +-
 29 files changed, 2121 insertions(+), 94 deletions(-)





