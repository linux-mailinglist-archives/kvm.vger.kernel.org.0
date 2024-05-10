Return-Path: <kvm+bounces-17192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E35438C27F8
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 17:37:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11A641C246F1
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 15:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D66217332E;
	Fri, 10 May 2024 15:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1OqJNXt/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B01E172BC6;
	Fri, 10 May 2024 15:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715355414; cv=fail; b=fuiEz6sQBTuWH32yl3fPMQMOLkFRHUunMmuwKkelpZrNw7wyKjxFkjsInenW4FqctD5cz0n3La45IIgskUNC50xfKfs7CwRVyC0+1Tn41ZT35lds+Mm24lHWxqiiCzxfzp7ZwyhQRzqEH9AkorSl/18KjNw9Jd4KS0k1l6vzDeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715355414; c=relaxed/simple;
	bh=4YHmiU6nTtCjNWlivwsz/XwQZshcR/fgtYydLwaiuTQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LuKAQs4C+w7r4phZ1ML3oRqaeve1jeD1YZyXOwvu/gubsmTeyw8PbwQ9bs7wWa15iHeF7whewBZkNnxbbZbTKVsCfxnK4aA0WAts3yX++eFOBPHpGauucH9jiycITIL0SlltdQhhKj0myugzyAyoXRbYzkzrzk9N/HctNE9aZps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1OqJNXt/; arc=fail smtp.client-ip=40.107.243.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irDJ87QEw1yE9XkMXDUoK4IO+HcOFHCQKVc2oXZkXRufzD8ezvnt69sHWVkUEAVhIEj1IO+W69zi3B/rjmj6y3qGPEjy+iN4mLlCEHtWOOgkHGPo3Y3f1cPb90TiTJmAwDXygp9s8KRIRhA2EuQp2dwFLUMRqg/oViEXibJigikW9+3eROtn9KzJVKTxaZdCIf2Tpmoi4iD5zqPKOEPx5iM4nRQfjhhSVxllBUOBFAcADvGdVwjtA5KafjVS8voPgCbuRFTpr3MAntcHEbAckZSVS0zowMNsCtCxyc1WrSUqNMFvEaQUJu8PWjoS86MaFs3tGCgubs8yVUhFgSnwSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qgARFMPnxdJzCaiVTG+yabvK+3tYZkHdcAO6Uqpqz+M=;
 b=FPRQ31p4owK5CpQuVr4FCgILmTNOEJ1SQjR/T8oNaeJRMrdkZM2CzVMjKZJ2Th/JVBg6OCn9GYXktjUIGCvK1VoKGuMfiU2m3EMn7DqKZKQIbmaz7Z0IeTYDtxZ18MJQh6jwj4c4O228NmvXth/mRhDPsuNtkPb3E3sADURthnI0oB+SYOfI3vX6HSaFsQtH7o6gN+fDi+qeAU0tPFxDq6/AS4b60hmOFgqL9D2JpWM7tRrmutXnGGn8eJf+SJXsjCFNG0Zf9z5Sj1t7bPPB7S9tW9zroqGf7Cvn458Az9Vvu+FfZ0OsMfQSmf3GBe2MF9dw9Atw6pynXeCFHPvMMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgARFMPnxdJzCaiVTG+yabvK+3tYZkHdcAO6Uqpqz+M=;
 b=1OqJNXt/V11T3VqE47f9N+0xfQFuLosPLlMUiCqgFuiCtjTbQXK8yPrkZKe8N2HQKMkYa0pntcgiyTWx/eWcZuumh9UcV3bYlAO+r1kuyBkik8BQIBL/8LPZF1GNgc2IVBlo9tR67bc1lUQbkf88MAyy+5TyIjakvZMc+trDIsw=
Received: from CH2PR07CA0016.namprd07.prod.outlook.com (2603:10b6:610:20::29)
 by IA0PR12MB8303.namprd12.prod.outlook.com (2603:10b6:208:3de::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49; Fri, 10 May
 2024 15:36:49 +0000
Received: from CH3PEPF00000012.namprd21.prod.outlook.com
 (2603:10b6:610:20:cafe::2b) by CH2PR07CA0016.outlook.office365.com
 (2603:10b6:610:20::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.51 via Frontend
 Transport; Fri, 10 May 2024 15:36:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000012.mail.protection.outlook.com (10.167.244.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7587.0 via Frontend Transport; Fri, 10 May 2024 15:36:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 10:36:48 -0500
Date: Fri, 10 May 2024 10:36:10 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <papaluri@amd.com>
Subject: Re: [PATCH v15 22/23] KVM: SEV: Fix return code interpretation for
 RMP nested page faults
Message-ID: <20240510153610.zzjqrpsbd276hj3c@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240510015822.503071-1-michael.roth@amd.com>
 <20240510015822.503071-2-michael.roth@amd.com>
 <Zj4oFffc7OQivyV-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zj4oFffc7OQivyV-@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000012:EE_|IA0PR12MB8303:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f1bbae5-889a-423d-6e34-08dc710701d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|7416005|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ifikHwikY70GrE0ytkutetawyK7Li7eb1Ff1HQXwWaK7w5eHDOdoYdyScQNB?=
 =?us-ascii?Q?NH9zZj4UhQykG0oAeKtv+4/AmNRUY/rGidQ3NDyuC4P1zfR5af1B8k5OF4p+?=
 =?us-ascii?Q?stM4V9yHKTzlJsoIaF/kHKENiO0IX/pWhrcvRG8DvMPE3ZGuu2p0C0krqrhd?=
 =?us-ascii?Q?GCO65b2SHFJcbSHCZ+DtBQ/zPqINN0+uppa9+HTdtJ+pp5dJbkw3YKXggWu4?=
 =?us-ascii?Q?JLGUQmeZkK3CyhFt8/NjFWcFKg4YGcm58NCiE3p7k0k9R2qlUIm297k+3leh?=
 =?us-ascii?Q?3Icv9XsOBztNjKyzOljxcZ6Vm2UAss7HLJZXdkD/adaBqmKpiyHlpA/CwFr8?=
 =?us-ascii?Q?0SWD/Y3ZBsqH707xWeFh1QKkWwYwfT+h3c/lDde6ty9WRmS5AGmg5Ae/V7LD?=
 =?us-ascii?Q?XhfcvnQnKCLMToNMCFLJV17POuoCXIkcnVn/q12ZtdFA6ym+YKBRlOIrfrh9?=
 =?us-ascii?Q?U9KjNVqSNHYXAknYj4Ro5g5Z3Jh8JFm86WCL8OK0dQtlihXfZj22XPAQt68A?=
 =?us-ascii?Q?PZ68FY3jN83KhYYcbgfBag3axFt0Z0uf2oDF/wUG1otgUb05MTlDcKpgSPyk?=
 =?us-ascii?Q?TkDFUpfdXFo0aqmK69KFnlMd3p6SXNUq/bAc9XZcKr6SEBT+m15fWB83FY21?=
 =?us-ascii?Q?3jChoECbty53JiuF/5Pj/sWObxkDRIAdydawlzZGGR2AqbtcHoLXH3O7eORx?=
 =?us-ascii?Q?UQVYz7hg8O4OBmIyJtNdVpIhu039FPQPM5NVCWVwLVo6g15XuoW7220KdjFz?=
 =?us-ascii?Q?SlVfbcKR7uJyXGXAdCSxzSV2m9aZfsBZVfYn4Z3oM4ujPp4H0pe55CR6I3uN?=
 =?us-ascii?Q?X4kjo6j9Z4gBiN81DmLIkPGqtCvEA/X3SV7/qm8a1KcX6fuBoIEIusH6Esef?=
 =?us-ascii?Q?BguhdlUw/nUeq4nGG5c7kzHRlh1dD5/frJGqqMaPiQw7Xn9r5nV0lpfO8hmG?=
 =?us-ascii?Q?GTQ0H0TbxGdhrMs9Rv5WpcNHh6Izru6MM6h4PMqpNgQjSsOvs+0VwuJRYczX?=
 =?us-ascii?Q?5Lt28EG/dljP+lRH3y/T5q2mrQV5wx5cuM8rTTJPOsrUsyI13Q95An8HW01F?=
 =?us-ascii?Q?EuPzs+RXzHMsxyLvDqobJDgC6GtOktgNXn5QHPrna3a0qf1X53s9C/dLYkOd?=
 =?us-ascii?Q?rJZBo685PVvRuSuSzIANaqx6LCXlyYmJHJIElIPQGwqcTXrURipm/q4rL+BE?=
 =?us-ascii?Q?hqfgcZ+EtLbw6fM8fpJtsbfVb+XILl4ohs8VpoYkTQhiU0oDdv2CjUIkDcga?=
 =?us-ascii?Q?zVSHX1Q0oWtxHtr3XZWR46k8BU97pPXQfDRr9QAAHzq+JvhGRseLwKdN/HLy?=
 =?us-ascii?Q?D3sqEMgi/AYBhSq9sWu6n822?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(7416005)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 15:36:48.8682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f1bbae5-889a-423d-6e34-08dc710701d6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000012.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8303

On Fri, May 10, 2024 at 06:58:45AM -0700, Sean Christopherson wrote:
> On Thu, May 09, 2024, Michael Roth wrote:
> > The intended logic when handling #NPFs with the RMP bit set (31) is to
> > first check to see if the #NPF requires a shared<->private transition
> > and, if so, to go ahead and let the corresponding KVM_EXIT_MEMORY_FAULT
> > get forwarded on to userspace before proceeding with any handling of
> > other potential RMP fault conditions like needing to PSMASH the RMP
> > entry/etc (which will be done later if the guest still re-faults after
> > the KVM_EXIT_MEMORY_FAULT is processed by userspace).
> > 
> > The determination of whether any userspace handling of
> > KVM_EXIT_MEMORY_FAULT is needed is done by interpreting the return code
> > of kvm_mmu_page_fault(). However, the current code misinterprets the
> > return code, expecting 0 to indicate a userspace exit rather than less
> > than 0 (-EFAULT). This leads to the following unexpected behavior:
> > 
> >   - for KVM_EXIT_MEMORY_FAULTs resulting for implicit shared->private
> >     conversions, warnings get printed from sev_handle_rmp_fault()
> >     because it does not expect to be called for GPAs where
> >     KVM_MEMORY_ATTRIBUTE_PRIVATE is not set. Standard linux guests don't
> >     generally do this, but it is allowed and should be handled
> >     similarly to private->shared conversions rather than triggering any
> >     sort of warnings
> > 
> >   - if gmem support for 2MB folios is enabled (via currently out-of-tree
> >     code), implicit shared<->private conversions will always result in
> >     a PSMASH being attempted, even if it's not actually needed to
> >     resolve the RMP fault. This doesn't cause any harm, but results in a
> >     needless PSMASH and zapping of the sPTE
> > 
> > Resolve these issues by calling sev_handle_rmp_fault() only when
> > kvm_mmu_page_fault()'s return code is greater than or equal to 0,
> > indicating a KVM_MEMORY_EXIT_FAULT/-EFAULT isn't needed. While here,
> > simplify the code slightly and fix up the associated comments for better
> > clarity.
> > 
> > Fixes: ccc9d836c5c3 ("KVM: SEV: Add support to handle RMP nested page faults")
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 426ad49325d7..9431ce74c7d4 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -2070,14 +2070,12 @@ static int npf_interception(struct kvm_vcpu *vcpu)
> >  				svm->vmcb->control.insn_len);
> >  
> >  	/*
> > -	 * rc == 0 indicates a userspace exit is needed to handle page
> > -	 * transitions, so do that first before updating the RMP table.
> > +	 * rc < 0 indicates a userspace exit may be needed to handle page
> > +	 * attribute updates, so deal with that first before handling other
> > +	 * potential RMP fault conditions.
> >  	 */
> > -	if (error_code & PFERR_GUEST_RMP_MASK) {
> > -		if (rc == 0)
> > -			return rc;
> > +	if (rc >= 0 && error_code & PFERR_GUEST_RMP_MASK)
> 
> This isn't correct either.  A return of '0' also indiciates "exit to userspace",
> it just doesn't happen with SNP because '0' is returned only when KVM attempts
> emulation, and that too gets short-circuited by svm_check_emulate_instruction().
> 
> And I would honestly drop the comment, KVM's less-than-pleasant 1/0/-errno return
> values overload is ubiquitous enough that it should be relatively self-explanatory.
> 
> Or if you prefer to keep a comment, drop the part that specifically calls out
> attributes updates, because that incorrectly implies that's the _only_ reason
> why KVM checks the return.  But my vote is to drop the comment, because it
> essentially becomes "don't proceed to step 2 if step 1 failed", which kind of
> makes the reader go "well, yeah".

Ok, I think I was just paranoid after missing this. I've gone ahead and
dropped the comment, and hopefully it's now drilled into my head enough
that it's obvious to me now as well :) I've also changed the logic to
skip the extra RMP handling for rc==0 as well (should that ever arise
for any future reason):

  https://github.com/mdroth/linux/commit/0a0ba0d7f7571a31f0abc68acc51f24c2a14a8cf

Thanks!

-Mike

