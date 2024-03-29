Return-Path: <kvm+bounces-13201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9D638932E5
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:30:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F3791F2341A
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BBB3149DE6;
	Sun, 31 Mar 2024 16:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dqo8rnBO"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B474D148840
	for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 16:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711902391; cv=fail; b=meSd7A2cxuAe3NaYcF+W+UDSZUKsaJbaLJebQxINMQLU536C/GbUCyH5CHI1q6N+adaRBA9/siTnPOkWMlEsLLz3Q4+WVRAzsPvEkFKhgEgds7mDvCItWjjZTCNlAHHIXvgSGAG2SX8mO7I/KnZl4QdDEXe6mxldV9fladFOvJk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711902391; c=relaxed/simple;
	bh=kErsm08yxXmUyl0hbfMy5p+9q0XrPrFe1bTpP+ywr0Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YOwxG5gUjzxS/Slesrt41lwoMwK0HVgP6vr2Y5Bxb8/709lCXmCsKbGn6iIVjdVEw66jg9yPYUGQZ869BsOlVtqS+2Hwy5nYh7p+6St56lf/DWlO9BsHZ1OgXgz71++s0MDlx8uwAtjZGj2gHnlXN9XIweD9kL92bapllWRvo6Y=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dqo8rnBO; arc=fail smtp.client-ip=40.107.94.69; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 59F63208B7;
	Sun, 31 Mar 2024 18:26:27 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rq4-PtZuZafq; Sun, 31 Mar 2024 18:26:26 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 6C0F4208AC;
	Sun, 31 Mar 2024 18:26:25 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 6C0F4208AC
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id 5FB8D80004A;
	Sun, 31 Mar 2024 18:26:25 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:26:25 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:23:31 +0000
X-sender: <kvm+bounces-13105-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
 NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAJuYHy0vkvxLoOu7fW2WcxcPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQALABcAvgAAALMpUnVJ4+pPsL47FHo+lvtDTj1EQjIsQ049RGF0YWJhc2VzLENOPUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpLENOPUFkbWluaXN0cmF0aXZlIEdyb3VwcyxDTj1zZWN1bmV0LENOPU1pY3Jvc29mdCBFeGNoYW5nZSxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXNlY3VuZXQsREM9ZGUFAA4AEQBACf3SYEkDT461FZzDv+B7BQAdAA8ADAAAAG1ieC1lc3Nlbi0wMQUAPAACAAAPADYAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0Lk1haWxSZWNpcGllbnQuRGlzcGxheU5hbWUPAA0AAABXZWJlciwgTWFydGluBQAMAAIAAAUAbAACAAAFAFgAFwBGAAAAm5gfLS+S/Eug67t9bZZzF0NOPVdlYmVyIE1hcnRpbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8AL
	wAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAtpHp8x1Q3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgBwAAAAi4oAAAUABAAUIAEAAAAYAAAAbWFydGluLndlYmVyQHNlY3VuZXQuY29tBQAGAAIAAQUAKQACAAEPAAkAAABDSUF1ZGl0ZWQCAAEFAAIABwABAAAABQADAAcAAAAAAAUABQACAAEFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 19649
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=139.178.88.99; helo=sv.mirrors.kernel.org; envelope-from=kvm+bounces-13105-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 9CA5620892
X-Original-To: kvm@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.69
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711747738; cv=fail; b=kKRTVAa2/eQ88Gzaub+dLhYOJWdp5CRIq4TXE4gtdOZ3TFRja8JTpIlHzByTuME/10vEh4J1qJGK0KZl0GKJtXs3ulKjODWyvySmNRozkou9pwgjrsfjPl8lCqNoXUzO8oOkLATeoAtWGqJPMMGZe2SC9PiiczNzDK9EOvZNPfk=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711747738; c=relaxed/simple;
	bh=kErsm08yxXmUyl0hbfMy5p+9q0XrPrFe1bTpP+ywr0Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PSLs1Vym5fwfop+4TzBBN+CP7zjtEdIMIiSzg5nD4mahxNUrf8mMK7SgnBcpH0yhkNaM64VC2lnkNn2NKwSSaD5TasZeCkB8g9yC/rTSZeegj2uCmcUm0lzlGyy9BxppSIsp+g+eAQeukGuZ1JX9nl7V2NNYs/LR4WSYFwrdefc=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dqo8rnBO; arc=fail smtp.client-ip=40.107.94.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CSeVGqBRphoLnLG0B7D7pfosnyk6RX/FSvrMyXyHA4VNtEqU0+a70vx8fcFcM1hMnDV4Lk62UrkuvdGGTPmaxph9ssanjDIS+2z2nciXUO5iEuqz2FjOkcEXQUMhZ4x9Sco/+jzZeFt/6cK0u9yaGcGMMA44iVXSHziI09pb0VF0y5kDXpAAVdMhMI/YCdWAAaHFm2B+Hx7Jm+AMYJW6M9cQHUC5rGmsO1OrLfZ2uwwDDsNX4wjz4fKrO4KrI0LBdpd/rDDk54tujQvCkfASGclNBdtuRpOuQv4MsvNJV+EJe4wh8xlJPgnLrPYdeRo1sTMkH5N79gO36baSIkQ+ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LRIVW2LnEW8X8ToyIMb93QMRO8ipYRgPVLFD+yidL8w=;
 b=P8fCl8iw4vrfsDNuNx8P/c+mb/vhVBd4rV6HdQNogSx7ivm6vxO8NKRPEIxbAjuQ6ROpiAKbeTEY8n511bdMqFvZHFo+oh8GJVhmGAktXku2/lKFo5vvnCpbQC5NNUdMNz6imw3HkiYanANidhf5lOWw6StO20bz4V/Fvg0SZs/HuYFElI4cMvD2qc1gWXZQe3GHfQ9nTVUczqjwIqfyXXv/cDd2UVWo6J9PXr5QWLQqK6B207xOCpt583oZn+AeiWqf3ydPNmSXrypbH51Qk3GCgSpI/YaNSQWR5bdBSFdDOBDMLu64y75vdSomKmWmg97s3XRDHSYvQIY4MHI0KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRIVW2LnEW8X8ToyIMb93QMRO8ipYRgPVLFD+yidL8w=;
 b=dqo8rnBOclzfl5qD72CqGBgfE2/3mmHDUogNxsfam+O5KMLOuqeY+FcFxgY/5ACeVzyTU2cZnPT8IgDxeXX4eeu90XOnq4q7epokfT/gMavF/6fYFn9DUsf5vAyui7XGb9pwgPX/5GsN33f49eGOjUoInnryTri21t/56iAS3qI=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	"Binbin Wu" <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	"Matthew Wilcox" <willy@infradead.org>
Subject: [PATCH gmem 0/6] gmem fix-ups and interfaces for populating gmem pages
Date: Fri, 29 Mar 2024 16:24:38 -0500
Message-ID: <20240329212444.395559-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FA:EE_|SN7PR12MB7177:EE_
X-MS-Office365-Filtering-Correlation-Id: 10a1011e-df9c-4ee6-82a2-08dc50373a71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E9xeflZ8QOJKKsQgiGljmdnrFImcsyNG99RIZenPc4Aoe0wtvXwESGeGL5iOJK9aWVvtCURV1+fEh+Um1IP1TjWRIjbA+YJsgQUwWtLznBFdn//R8nLZnLcnOvjL2MfdL0uE5hJAPGfWXl3fMhCO15cB0x2rzT+KY7SULT25rOTnxdtYclJqKjJlYC1zFxJMnxnKXFsRSzwYRYGVWSc8QmGzxxNKPgIuDSiiALd0yvN7XXb3tFgsPGYyIK47Ur2b1snmdr1DmIbPfBo5DLcMzuDvlSOW3LoynhYHaT5Xv9egybZ26DQRRwBdHPdQwmFQztLH3pnuvP7I7wuMGEzUx+ztzQAjXqkYdjcrLUNFbXNJTTZXJSnf9BSfFv3pmUl+waJuL2xLEP+QjNMckiKBJdklclRJtHA3eDbdAr3B1f4/encRmOX+zm93gSYvA34Bw330TfuCZKMgQ2m7AnDZ2g0uy+hQo4u2eRfUCQw9OjnvYrnzJH3lEYnUSmi1gmqz++6GpsSVdPT0tGK/GlgGbf6fVHrccNv6j9Jyjinf/BTryKdERhXkU9RyKvOrkA7WqETfWaEz6ovXtpej8IuQDn52s871VBaVMCJC4DYcvuHNwzHzKOZFR3B8XSfm+JONC7AEmKwSN+sRGo5AyHPqiv5hgr1nnmOiPefd6xdFb5BlEjo474sRbpqsAFGz5W97aOwadje4AE0napYptSJ/Ug==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 21:28:51.3239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10a1011e-df9c-4ee6-82a2-08dc50373a71
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0001A0FA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7177
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

These patches are based on top of:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=kvm-coco-queue

and are also available from:
  
  https://github.com/AMDESE/linux/commits/kvm-gmem-common-v1/
  

Overview
--------

This is a small collection of patches that addresses some review comments
from Paolo's series:

  [PATCH 00/21] TDX/SNP part 1 of n, for 6.9
  https://lore.kernel.org/lkml/20240227232100.478238-1-pbonzini@redhat.com/

and also introduces some flags and interfaces that might also be relevant to
the scope of that series.

I'm posting these together initially as they comprise what may be the last
batch of SNP dependencies that are potentially relevant to TDX and a common
CoCo tree, but can split out or move back into SNP series, whatever is
deemed preferable.


Patch Layout
------------

1-3: These are smaller fix-ups to address various review comments pertaining
     to the gmem hooks that were originally part of the SNP hypervisor
     postings. In each case they can be potentially squashed into the
     corresponding patches in kvm-coco-queue if that's preferable.

4-5: This introduces an AS_INACCESSIBLE flag that prevents unexpected
     accesses to hole-punched gmem pages before invalidation hooks have had
     a chance to make them safely accessible to the host again.

6:   This implements an interface that was proposed by Sean during this[1]
     discussion regarding SNP_LAUNCH_UPDATE and discussed in more detail
     during the PUCK session "Finalizing internal guest_memfd APIs for
     SNP/TDX". It is not verbatim what was discussed, but is hopefully a
     reasonable starting point to handle use-cases like SNP_LAUNCH_UPDATE.
     It may also avoid the need to export kvm_gmem_get_uninit_pfn() as an
     external interface if SNP_LAUNCH_UPDATE is still the only
     known/planned user.


Thanks!

[1] https://lore.kernel.org/lkml/Zb1yv67h6gkYqqv9@google.com/


----------------------------------------------------------------
Michael Roth (6):
      KVM: guest_memfd: Fix stub for kvm_gmem_get_uninit_pfn()
      KVM: guest_memfd: Only call kvm_arch_gmem_prepare hook if necessary
      KVM: x86: Pass private/shared fault indicator to gmem_validate_fault
      mm: Introduce AS_INACCESSIBLE for encrypted/confidential memory
      KVM: guest_memfd: Use AS_INACCESSIBLE when creating guest_memfd inode
      KVM: guest_memfd: Add interface for populating gmem pages with user data

 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/mmu/mmu.c          |  3 ++-
 include/linux/kvm_host.h        | 45 +++++++++++++++++++++++++++++++++++-
 include/linux/pagemap.h         |  1 +
 mm/truncate.c                   |  3 ++-
 virt/kvm/guest_memfd.c          | 51 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 102 insertions(+), 4 deletions(-)




