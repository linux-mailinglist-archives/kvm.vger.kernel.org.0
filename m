Return-Path: <kvm+bounces-17361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 114618C4B58
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 04:55:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3508D1C20CE6
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 02:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A7905B5D3;
	Tue, 14 May 2024 02:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NMBgW5Dd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442884502B;
	Tue, 14 May 2024 02:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715655097; cv=fail; b=oCV/pCwkC/2mnFaA9ygO7FRStHEI5fJj2tGTdMoqbbG8ZbHkN3/8BYUwzSgT2YmiR7P/ux4Img+ol/CyeyGXktjPT5MEg5R9cRZ3rZ371vU73q7tuktGFAPtPsaapPFbMLF7d6WAP9jlhXIEFuDAsKstDCkmEOwAV4Ybv0zKD00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715655097; c=relaxed/simple;
	bh=M/lAj6snV4y/b8BumZYHy5/iZyAnVGcfGd64p4fovoU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HbCNJmCMi/WM5GreM8RZfdBYNU9hlqeK9YQHN/lsIdKhJOWl84z8+xIs6mL49Ap27Ya6kPAtE670Xyfz2kNyPlD9ogu/P5OpahxmE6pMazqt/71jbIaBkGWQJlzr+hvS/vA/8kvMk/boXSrUy/zGhPB2f61Kgkii+hbAttiAq6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NMBgW5Dd; arc=fail smtp.client-ip=40.107.94.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYTPkQ9bws3GB3UR7HZ2I5jOZnlPSyX7Fyb0+FjlFMzpo8pFe6QwdTmdyNo3zQf1SYMPCcelMJB7uMkFqMuYf6uYHYtUmA2UqthNCpPAvY6nISjOqgTk5sZZ0j5b9kEFsfA5oVWU03HwQnr7xewTWdiRuSBqoluB5qEAwdb0qnPTnHNNOulDASCSaQu67DH4P5//pQSLaPkEx/woJf1Hpbd6OXL53g5QACe5k4QYRyobGeQ/CppkXaXB+heJFZuWVqhQl6UaaBR2mdcfKtOoKJjfwkC4DkDWEOKpVtzQ5K7p/iJpU4zw+3XZ0AqZUZuwvz1XBk6qP4k2NgGsgaLc5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GU69nuJcCyxNtjbPHQk+VW2PKqI+VS0fW6UPRashnmY=;
 b=b8g0YSo0+KBibl4e+/66oSJJqw6Y/7FXb2QftyOKGQPhINECtkDb7QgspdddopknoJztx7LKJyd9E1M7zb0nHqP7cDIDC4MgRVL5o+uKXMKwJy200/VeWCtbyy3E0OLExNFNDfZ+n51c1yIu1YyaKRx7y2n8PXZYZxpTn0jJQhsocm6ktyRf2tceMD065eNVWebEzIm+mygFkFwm+R9ocYO995whRTCJnTysfMjyByntxNpt6B2R9q9EJXOBfXBuhFpwkY22++ZPa4flMvS+54V+81rQOaF7sO7wSBt86n0cjJV13JBiZx+ppJwaV/Z8F7nZ5KJH964dOT8BqFwaug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GU69nuJcCyxNtjbPHQk+VW2PKqI+VS0fW6UPRashnmY=;
 b=NMBgW5DdZJVLI1ERyaqRGXQis/nQLf/5NspSnzA0VGZr1AwgKkdYlSYUtrhPl+BXCj6AMDQEtNB1l0lx2kTh8vAOlxSVaJCKJn7/RqxV3o5bWhmDh0esjFr3dq8/CqK6n4gPbmgZRUK9f/6kF8s7PQoHeZZeH6/j4W5sPRQ+r7M=
Received: from MN2PR07CA0029.namprd07.prod.outlook.com (2603:10b6:208:1a0::39)
 by IA1PR12MB8358.namprd12.prod.outlook.com (2603:10b6:208:3fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 02:51:32 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:208:1a0:cafe::5) by MN2PR07CA0029.outlook.office365.com
 (2603:10b6:208:1a0::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55 via Frontend
 Transport; Tue, 14 May 2024 02:51:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7587.21 via Frontend Transport; Tue, 14 May 2024 02:51:32 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 13 May
 2024 21:51:32 -0500
Date: Mon, 13 May 2024 21:51:15 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: Re: [PATCH v15 19/20] KVM: SEV: Provide support for
 SNP_EXTENDED_GUEST_REQUEST NAE event
Message-ID: <20240514025115.dkw3ysqrdbfaa2sg@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240501085210.2213060-20-michael.roth@amd.com>
 <ZkKmySIx_vn0W-k_@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZkKmySIx_vn0W-k_@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|IA1PR12MB8358:EE_
X-MS-Office365-Filtering-Correlation-Id: 8670b248-83af-442d-9650-08dc73c0c369
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|82310400017|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gT0YALttxef1Ch8gAfa/Uj9NF8IE/o4JCQyx5YJ8Lgupzyi4WGyPofJAg7H9?=
 =?us-ascii?Q?xV+cel4PN+eujUccmF5ZjmTyT4VGy/WVAypRZn6GcDXFDPJUeX/zEUA9BgME?=
 =?us-ascii?Q?09CCW7veHKpJoIZDdw/ydIY9faI0M81/CqBrBjD8VbeMBRjoFekfAHKE77+C?=
 =?us-ascii?Q?vSIaxC1MfaYeiBWZ4d5qOa0nEJqijCiUF8KFlJ23eua6lgaEZaDyi3mnbxpo?=
 =?us-ascii?Q?gzbTta9hw6DJFpriyUUtITciUt2rNgH8HmuzNb7WDfxe6Sj1ZeoqkCTETdDp?=
 =?us-ascii?Q?f2Z2P2U+kGM563YkD/fPg/3rQnu+Fn9lxnxtb9CjkW7uKM+bqmP5UP5zQnOz?=
 =?us-ascii?Q?H2zcN/NCFlQcCzuGLXK4vO3dP8xzV64xhnxTwC0W3J1Bu1R+W+WT08JHGP+X?=
 =?us-ascii?Q?wbu0kuBwpegqlQIVZuFlNE8cZF4rjhBPZgJVw2BfJf8qyAs+q1gww/cOegEz?=
 =?us-ascii?Q?/YKAoRfs4Hx5k47nkUE2g9cDIUNm6feWe1tUUXWpFn3XIeAdGmwBQrEtyth9?=
 =?us-ascii?Q?bv14nKUhk85vmy8vDlctn8Dnx2aHmythd7CO2r4N+YbrSOEHsAErJyRXTErQ?=
 =?us-ascii?Q?kjpT07kcD0wgE2lbUXp96MS12sLSHrzXDb5WBdNDQYRjk0OcLSBA0RMAeXp5?=
 =?us-ascii?Q?4BGgVs0tvVlJpruB6FqsH6J9phhbiDa2pK/qi+FHxNn8MYFNTbpQShI1ePSD?=
 =?us-ascii?Q?qKGRhtOuy+iY10riIXe/448GXoSatIIa4eI6n+hWdXIBdkzKNK1soBzDl8kE?=
 =?us-ascii?Q?HAGV4QzMGz3WVWwHBlzgT0BJww4h2WPDXi6pnUTBONQPiSwaYSfTrd8VL1UF?=
 =?us-ascii?Q?rJVtGkYPfb7bv4uIPCVQkCcNbD1qOAma75WWh7w29th57fmLZV6vyyae/11v?=
 =?us-ascii?Q?gE2YZ877eXqogbQsw/jlRDDoKXtHQvTWCEOoKJyjFpiNhMefFI2vetNXS7vh?=
 =?us-ascii?Q?OX/oirkm9kgtIZoN1Y296FOMYFTcTpV68ttsxRC8+BV4DJ+v2t0CRvDD/Xfs?=
 =?us-ascii?Q?4gYPc8H7kvi2J5Trk0hZaJTlylP0o13qrds+Fa3tcj5xC5z4nqT0pYKq13b8?=
 =?us-ascii?Q?vCWOQgZDHRdqnfuybvTmbk8dRWpOKLUrqUC8KGJH86f/MViFiLVqENq9SO9I?=
 =?us-ascii?Q?3+upaNfrpYJzCEpwuykf+uHJNiznvmIawf/Py2yivTNZ28diVMgNTtzC0684?=
 =?us-ascii?Q?pyEnd8+vnsMA152YVronvLzg6DW0Do54iEV15/jcs/Mub0l94N8aXGzTR3fz?=
 =?us-ascii?Q?fsaKSdBsW+G460+KHpfwXWZpZHkwUQuBxFYg9p/XTECTiRKaJUK2pfiH44Ed?=
 =?us-ascii?Q?KEPb7nuvWaODvRPHjLQ1dWloNhTTcy/zzVWLPZrHZiZLx81rNDZt7T3hurJc?=
 =?us-ascii?Q?mUnQf1Em6O+BDkoAIh0VSgiLJM/O?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400017)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 02:51:32.8534
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8670b248-83af-442d-9650-08dc73c0c369
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8358

On Mon, May 13, 2024 at 04:48:25PM -0700, Sean Christopherson wrote:
> On Wed, May 01, 2024, Michael Roth wrote:
> > Version 2 of GHCB specification added support for the SNP Extended Guest
> > Request Message NAE event. This event serves a nearly identical purpose
> > to the previously-added SNP_GUEST_REQUEST event, but allows for
> > additional certificate data to be supplied via an additional
> > guest-supplied buffer to be used mainly for verifying the signature of
> > an attestation report as returned by firmware.
> > 
> > This certificate data is supplied by userspace, so unlike with
> > SNP_GUEST_REQUEST events, SNP_EXTENDED_GUEST_REQUEST events are first
> > forwarded to userspace via a KVM_EXIT_VMGEXIT exit structure, and then
> > the firmware request is made after the certificate data has been fetched
> > from userspace.
> > 
> > Since there is a potential for race conditions where the
> > userspace-supplied certificate data may be out-of-sync relative to the
> > reported TCB or VLEK that firmware will use when signing attestation
> > reports, a hook is also provided so that userspace can be informed once
> > the attestation request is actually completed. See the updates to
> > Documentation/ for more details on these aspects.
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 87 ++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/svm/sev.c         | 86 +++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/svm/svm.h         |  3 ++
> >  include/uapi/linux/kvm.h       | 23 +++++++++
> >  4 files changed, 199 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index f0b76ff5030d..f3780ac98d56 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -7060,6 +7060,93 @@ Please note that the kernel is allowed to use the kvm_run structure as the
> >  primary storage for certain register types. Therefore, the kernel may use the
> >  values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
> >  
> > +::
> > +
> > +		/* KVM_EXIT_VMGEXIT */
> > +		struct kvm_user_vmgexit {
> 
> LOL, it looks dumb, but maybe kvm_vmgexit_exit to avoid confusing about whether
> the struct refers to host userspace vs. guest userspace?
> 
> Actually, I vote to punt on naming until more exits need to be kicked to userspace,
> and just do (see below for details on how I got here):
> 
> 		/* KVM_EXIT_VMGEXIT */
> 		struct {
> 			__u64 exit_code;
> 			union {
> 				struct {
> 					__u64 data_gpa;
> 					__u64 data_npages;
> 					__u64 ret;
> 				} req_certs;
> 			};
> 		} vmgexit;
> 
> > +  #define KVM_USER_VMGEXIT_REQ_CERTS		1
> > +			__u32 type; /* KVM_USER_VMGEXIT_* type */
> 
> Regardless of whether or not requesting a certificate is vendor specific enough
> to justify its own exit reason, I don't think KVM should have a #VMGEXIT that
> adds its own layer.  Structuring the user exit this way will make it weird and/or
> difficult to handle #VMGEXITs that _do_ fit a generic pattern, e.g. a user might
> wonder why PSC #VMGEXITs don't show up here.
> 
> And defining an exit reason that is, for all intents and purposes, a regurgitation
> of the raw #VMGEXIT reason, but with a different value, is also confusing.  E.g.
> it wouldn't be unreasonable for a reader to expect that "type" matches the value
> defined in the GHCB (or whever the values are defined).

The type in this case is actually "extended guest request". You'd rightly
pointed out that that is miles away from describing what KVM wants
userspace to do, so I named it "request certificate". And now with PSC being
handled as seperate KVM_HC_MAP_GPA_RANGE event with no exposure of GHCB/etc
to userspace, it made further sense to not lean too heavily on the GHCB for
defining the types.

But continuing to name it KVM_EXIT_VMGEXIT sort of goes against that
decoupling, so I can see some potential for confusion there. KVM_EXIT_SNP is
probably a better generic name for what this exit is meant to cover. But I'm
not aware of anything specific that would involve requiring extending this in
the near-term, though maybe there's some potential with live migration. So a
renaming to something more generic and less specific to VMGEXIT/GHCB,
like KVM_EXIT_SNP, or something more specific like KVM_EXIT_SNP_REQ_CERTS,
both seem warranted, but I don't think moving to something more coupled to
VMGEXIT/GHCB would provide much benefit long-term.

> 
> Ah, you copied what KVM does for Hyper-V and Xen emulation.  Hrm.  But only
> partially.
> 
> Assuming it's impractical to have a generic user exit for this, and we think
> there is a high likelihood of needing to punt more #VMGEXITs to userspace, then
> we should more closely (perhaps even exactly) follow the Hyper-V and Xen models.
> I.e. for all values and whanot that are controlled/defined by a third party
> (Hyper-V, Xen, the GHCB, etc.) #define those values in a header that is clearly
> "owned" by the third party.
> 
> E.g. IIRC, include/xen/interface/xen.h is copied verbatim from Xen documentation
> (source?).  And include/asm-generic/hyperv-tlfs.h is the kernel's copy of the
> TLFS, which dictates all of the Hyper-V hypercalls.
> 
> If we do that, then my concerns/objections largely go away, e.g. KVM isn't
> defining magic values, there's less chance for confusion about what "type" holds,
> etc.
> 
> Oh, and if we go that route, the sizes for all fields should follow the GHCB,
> e.g. I believe the "type" should be a __u64.
> 
> > +			union {
> > +				struct {
> > +					__u64 data_gpa;
> > +					__u64 data_npages;
> > +  #define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_INVALID_LEN   1
> > +  #define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_BUSY          2
> > +  #define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_GENERIC       (1 << 31)
> 
> Hopefully it won't matter, but are BUSY and GENERIC actually defined somewhere?
> I don't see them in GHCB 2.0.

BUSY is defined in 4.1.7:

  It is not expected that a guest would issue many Guest Request NAE
  events. However, access to the SNP firmware is a sequential and
  synchronous operation. To avoid the possibility of a guest creating a
  denial-of-service attack against the SNP firmware, it is recommended
  that some form of rate limiting be implemented should it be detected
  that a high number of Guest Request NAE events are being issued. To
  allow for this, the hypervisor may set the SW_EXITINFO2 field to
  0x0000000200000000, which will inform the guest to retry the request

INVALID_LEN in 4.1.8.1:

  The hypervisor must validate that the guest has supplied enough pages
  to hold the certificates that will be returned before performing the SNP
  guest request. If there are not enough guest pages to hold the certificate
  table and certificate data, the hypervisor will return the required number
  of pages needed to hold the certificate table and certificate data in the
  RBX register and set the SW_EXITINFO2 field to 0x0000000100000000.

and GENERIC chosen to provide an non-zero error code that doesn't
conflict with that above (or future) GHCB-defined values. But KVM isn't
trying to expose the actual GHCB details, like how these values are to be in
the upper 32-bits of SW_EXITINFO2, it just re-uses the values to avoid
purposefully obfuscating the GHCB return codes they relate to.

> 
> In a perfect world, it would be nice for KVM to not have to care about the error
> codes.  But KVM disallows KVM_{G,S}ET_REGS for guest with protected state, which
> means it's not feasible for userspace to set registers, at least not in any sane
> way.
> 
> Heh, we could abuse KVM_SYNC_X86_REGS to let userspace specify RBX, but (a) that's
> gross, and (b) KVM_SYNC_X86_REGS and KVM_SYNC_X86_SREGS really ought to be rejected
> if guest state is protected.
> 
> > +					__u32 ret;
> > +  #define KVM_USER_VMGEXIT_REQ_CERTS_FLAGS_NOTIFY_DONE	BIT(0)
> 
> This has no business being buried in a VMGEXIT_REQ_CERTS flags.  Notifying
> userspace that KVM completed its portion of a userspace exit is completely generic.
> 
> And aside from where the notification flag lives, _if_ we add a notification
> mechanism, it belongs in a separate patch, because it's purely a performance
> optimization.  Userspace can use immediate_exit to force KVM to re-exit after
> completing an exit.
> 
> Actually, I take that back, this isn't even an optimization, it's literally a
> non-generic implementation of kvm_run.immediate_exit.

Relying on a generic -EINTR response resulting from kvm_run.immediate_exit
doesn't seem like a very robust way to ensure the attestation request
was made to firmware. It seems fully possible that future code changes
could result in EINTR being returned for other reasons. So how do you
reliably detect that the EINTR is a result of immediate_exit being called
after the attestation request is made to firmware? We could squirrel something
away in struct kvm_run to probe for, but delivering another
KVM_EXIT_SNP_REQ_CERT with an extra flag set seems to be reasonably
userspace-friendly.

> 
> If this were an optimization, i.e. KVM truly notified userspace without exiting,
> then it would need to be a lot more robust, e.g. to ensure userspace actually
> received the notification before KVM moved on.

Right, this does rely on exiting via , not userspace polling for flags or
anything along that line.

> 
> > +					__u8 flags;
> > +  #define KVM_USER_VMGEXIT_REQ_CERTS_STATUS_PENDING	0
> > +  #define KVM_USER_VMGEXIT_REQ_CERTS_STATUS_DONE		1
> 
> This is also a weird reimplementation of generic functionality.  KVM nullifies
> vcpu->arch.complete_userspace_io _before_ invoking the callback.  So if a callback
> needs to run again on the next KVM_RUN, it can simply set complete_userspace_io
> again.  In other words, literally doing nothing will get you what you want :-)

We could just have the completion callback set complete_userspace_io
again, but then you'd always get 2 userspace exit events per attestation
request. There could be some userspaces that don't implement the
file-locking scheme, in which case they wouldn't need the 2nd notification.
That's why the KVM_USER_VMGEXIT_REQ_CERTS_FLAGS_NOTIFY_DONE flag is provided
as an opt-in.

The pending/done status bits are so userspace can distinguish between the
start of a certificate request and the completion side of it after it gets
bound a completed attestation request and the filelock can be released.

Thanks,

Mike

> 
> > +					__u8 status;
> > +				} req_certs;
> > +			};
> > +		};

