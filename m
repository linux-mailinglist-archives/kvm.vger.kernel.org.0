Return-Path: <kvm+bounces-20571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BE09918A24
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 19:31:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6D12B21688
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 17:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C851114532F;
	Wed, 26 Jun 2024 17:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M7s0b4Lj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F14B13AA5F;
	Wed, 26 Jun 2024 17:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719423085; cv=fail; b=pMf4ZB5FPArm40E+Xn5uJ0q6yejZH9Ug3FYm9QdLVLQwsUvHtcElULfSiyQjf9tLVNwnSZe5TkxWZGvpTOIoPDgnIbOIFNpe71ymi2sG/pbmJPF9VhKKc2p6vGzcXVt72UbTFiln41Q4HQEZsaw+92LOxUcDYv1uCwl9s3fgczg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719423085; c=relaxed/simple;
	bh=b/OQS8I/Y1xP9JhQdPE4sWd1KtseWqPWVNZFdgP0Pjw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g5aXzDPOI3BaC43MzyrI27PJaZVdu9fzsz6HyoUrWnP7AdiUaKfzyZvAF15yUL5sbiF0elUdqITkKbRKoiMmx11WmQVtsQ7/hLEdZ3wznGcp/a0XmP1Wy99FlaAav437FDAlw5kPbuDdEocOewDoYfb8iLCFFKiKEX1jO+t35B4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M7s0b4Lj; arc=fail smtp.client-ip=40.107.243.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SG/3yDYZmhXiN0ezbQTe7xsaqmUpyYJWu+vMGcf1zS5bEBbUmnaYeR6wtHx+X9u9RLFJ4URBzRc8YovwndAExuE97B4GWtIL90Idsy7BzYcwgaVD7tdrsRDo+XSAEBO4qQ2fFKRZ1PzRx2BncMi6u1ft7pXFQ43N2C66erKOJe33apyGGGv+uQXQ7IYMtUWbjaywOyAPp7AmDqv46Qbj0oApHspZ6TpStFydQv7rO5rsCehwx/csRtEu0BTBbY9pgxUQJMXC8SWwdTBcBJY56jqdD2N6117bGGx50KG1P0B5k856stIKmYPGv4R+9eaF+fRo6gb06F5sM/o987thtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SUmnpadNnrli6k9uDfQuXGXv4FgD3ydedZp0kD+vSeI=;
 b=ZlpqTs0oJMJfIEZRJ5J6pmXYDGA7WT4X7UBLTeXnwEK2QBWpu5Jbhd/8zONU5f3sxEere5XPZI8PZ1vAXMm2gxzfYlnvCNfJnydQayUKCNhbDLUdwdiahcfq/5DJZXumqYdex6TVWd4SsPqpw/lyuI237FiF8dOzCXCl6hGGnL+AlA94NFg28GteEcN2JxKPWgcTE+b5+MYkNeC4yuoUb+wdfeWJdVZlksrhEcfzcr1L60F2qj9DjHnO4V9n/XaQHlRzvKzKe1WfdcnHXlXtAOmPescl4afH65eRc6oYpxFTUv57P9H9RA87wPgRKBweFCFtSq4AGHWqNI+dNk3n6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUmnpadNnrli6k9uDfQuXGXv4FgD3ydedZp0kD+vSeI=;
 b=M7s0b4Ljw7XdpBVHORZz7Xbr23FFqGYwTofXrAvK7B1SQ5TPvRI/l67sXskrC/DJtL42HG0X2ZsJgU9rH5oj3ueamREPnf2SR9GEOc/IlJ6ljI9FJRVJLbz/ho7JqgyKOOK5qT2ab8nnAelM+5sSUJENEvtj+2YR47AN2/QokmI=
Received: from PH7PR17CA0025.namprd17.prod.outlook.com (2603:10b6:510:323::27)
 by PH8PR12MB7448.namprd12.prod.outlook.com (2603:10b6:510:214::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Wed, 26 Jun
 2024 17:31:14 +0000
Received: from CY4PEPF0000EDD2.namprd03.prod.outlook.com
 (2603:10b6:510:323:cafe::bd) by PH7PR17CA0025.outlook.office365.com
 (2603:10b6:510:323::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.23 via Frontend
 Transport; Wed, 26 Jun 2024 17:31:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD2.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Wed, 26 Jun 2024 17:31:13 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Jun
 2024 12:31:12 -0500
Date: Wed, 26 Jun 2024 12:30:58 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <pbonzini@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>
Subject: Re: [PATCH v1 4/5] KVM: Introduce KVM_EXIT_COCO exit type
Message-ID: <r3tffokfww4yaytdfunj5kfy2aqqcsxp7sm3ga7wdytgyb3vnz@pfmstnvtuyg2>
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-5-michael.roth@amd.com>
 <ZnwkMyy1kgu0dFdv@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZnwkMyy1kgu0dFdv@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD2:EE_|PH8PR12MB7448:EE_
X-MS-Office365-Filtering-Correlation-Id: 32f19d53-ae32-4a24-e28c-08dc9605c728
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230038|82310400024|7416012|376012|1800799022|36860700011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m0VvicpI+/AYLHmXGiAw7gwAmzNTGpAipfQjXZuXfp/XNTWUX4JYUm17ST14?=
 =?us-ascii?Q?mNo/ACp7clqvqgpWV2fYdCJbRBI+yJ92Go0w5ob/SX7vwRadxZsLww2QLSbF?=
 =?us-ascii?Q?ByR2meRgJ9rnqeQiwU3mM/tavwImmefX/8Mgo6MaUQbW7WsRgLBTVcg329pt?=
 =?us-ascii?Q?T6vdcDGDZ/92WeJIOmvz/ghvAbFC4Rj3fxJfmVt3bauY8/mhD5b7YUjwOU1k?=
 =?us-ascii?Q?v/KSpZSas3fatoF9UAq77RgF6cWTepHT9XiUW9rrWZ61s3KazNXSgoxGa/CY?=
 =?us-ascii?Q?qJ8vjEMOJqlW0gOq83aSFYTd3wc2LP/W6fpiwR7c07wvF/tty5ORflFJV28l?=
 =?us-ascii?Q?jF3ASNCqlUJSgDz4mzxKO+aMEgi092MRiukonqj2g94VmVzPGF4wviLtZ8Jd?=
 =?us-ascii?Q?G1e/pgFpwa9yo/31Mm2q7hX9hUenbVay1JZQeuu04OwfTz8t3ARZZPeB2QKk?=
 =?us-ascii?Q?RD8syKAPLJjEjMG5v9aGOzwycxiWQe/E252QYcyWjKRF8krXKKE/j0A3ixbl?=
 =?us-ascii?Q?GA9XCbzSx2tSu37rBhoW48YiF9xsY+Y8Dt99RqqxvchOa2GwqdxPl5xoux6R?=
 =?us-ascii?Q?ZS8CjKmtVOzBCgdNr05iRRzGkz6WgSuXAFWwEp6iwt/RDke/QNM0a3T9OK4t?=
 =?us-ascii?Q?Vl+mOQGDXax8+d5nbeeilLYuA5Ftj/u0Ago/og8XwURPwLLBZWzMpVB+WDVl?=
 =?us-ascii?Q?2ToO9aux3sgisFmgPzM4lB97M7n2USEN9w9DvR/zJX1/SsXY6lLCKolJ8EyD?=
 =?us-ascii?Q?b7xx8OvJEdmJyNSDWIEnLuxbPn6WJzuAI+1ROl7yiQslWZgftXCtDosbVW7S?=
 =?us-ascii?Q?FjmL8s3gxd1Vb866tQj8W6e4GDpMVgreWcZR8b06xYreFQUgBE6/cLArMtG/?=
 =?us-ascii?Q?/bWWfx/MxpQRtGiq1S5Xucp8vKXm94dW3mQ6bJJ0RxLsbuB/eCkUdbGDy8nJ?=
 =?us-ascii?Q?8+p7aMheTCFJ5Ijdc/0hnN/nGMNKe3MPmjKOoKIOaB+4LRkZVKX/q4JiY+uM?=
 =?us-ascii?Q?tk5kT99ReznM2sBueVevcr2IAM3XByX/FU40Vge0xn/LIK3m8fM5pZJewIlq?=
 =?us-ascii?Q?D8pTxdYf8zpuv3GNewx7IArWgNz+x6WVl1dl0rpIdCQZcPhn4mu8kHZ5wk/R?=
 =?us-ascii?Q?1e6ooWMYUpPHuHk/HQ+EqejLP7CXuL7suCxI41CT+VMYuQSDt7CicFoaonQX?=
 =?us-ascii?Q?i6K6l2frmhU6SCUGBYIJ1+VZ5WDixA5CBnNcC3hkRA9vda1MOoaSYCnPN2Q4?=
 =?us-ascii?Q?HiCCAwe11T1XD7JH0S3j6fv+iAc+IrjGdHIZVQk+Vvy5mJa1We6IS9ry3zSM?=
 =?us-ascii?Q?p6XmqimK6MSIjH3+UxjYJJJxSpqHwFdPA8FZa0LKk4qygT9pLcbXoVLYuzpB?=
 =?us-ascii?Q?L4K1tZRVzvjiPMDYDaU05hbxzISrX5bfswF1LflxtwaTaICCgw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230038)(82310400024)(7416012)(376012)(1800799022)(36860700011);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 17:31:13.7616
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32f19d53-ae32-4a24-e28c-08dc9605c728
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7448

On Wed, Jun 26, 2024 at 07:22:43AM -0700, Sean Christopherson wrote:
> On Fri, Jun 21, 2024, Michael Roth wrote:
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index ecfa25b505e7..2eea9828d9aa 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -7122,6 +7122,97 @@ Please note that the kernel is allowed to use the kvm_run structure as the
> >  primary storage for certain register types. Therefore, the kernel may use the
> >  values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
> >  
> > +::
> > +
> > +		/* KVM_EXIT_COCO */
> > +		struct kvm_exit_coco {
> > +		#define KVM_EXIT_COCO_REQ_CERTS			0
> > +		#define KVM_EXIT_COCO_MAX			1
> > +			__u8 nr;
> > +			__u8 pad0[7];
> > +			union {
> > +				struct {
> > +					__u64 gfn;
> > +					__u32 npages;
> > +		#define KVM_EXIT_COCO_REQ_CERTS_ERR_INVALID_LEN		1
> > +		#define KVM_EXIT_COCO_REQ_CERTS_ERR_GENERIC		(1 << 31)
> 
> Unless I'm mistaken, these error codes are defined by the GHCB, which means the
> values matter, i.e. aren't arbitrary KVM-defined values.

They do happen to coincide with the GHCB-defined values:

  /*
   * The GHCB spec only formally defines INVALID_LEN/BUSY VMM errors, but define
   * a GENERIC error code such that it won't ever conflict with GHCB-defined
   * errors if any get added in the future.
   */
  #define SNP_GUEST_VMM_ERR_INVALID_LEN   1
  #define SNP_GUEST_VMM_ERR_BUSY          2
  #define SNP_GUEST_VMM_ERR_GENERIC       BIT(31)

and not totally by accident. But the KVM_EXIT_COCO_REQ_CERTS_ERR_* are
defined/documented without any reliance on the GHCB spec and are purely
KVM-defined. I just didn't really see any reason to pick different
numerical values since it seems like purposely obfuscating things for
no real reason. But the code itself doesn't rely on them being the same
as the spec defines, so we are free to define these however we'd like as
far as the KVM API goes.

> 
> I forget exactly what we discussed in PUCK, but for the error codes, I think KVM
> should either define it's own values that are completely disconnected from any
> "harware" spec, or KVM should very explicitly #define all hardware values and have

I'd gotten the impression that option 1) is what we were sort of leaning
toward, and that's the approach taken here.

> the semantics of "ret" be vendor specific.  A hybrid approach doesn't really work,
> e.g. KVM_EXIT_COCO_REQ_CERTS_ERR_GENERIC isn't used anywhere and and looks quite odd.

This is a catch-all error for userspace to set if any issues are
encountered that don't map to any other
KVM_EXIT_COCO_REQ_CERTS_ERR_* cases (like INVALID_LEN). It's defined
purely for KVM/userspace and not based on any other spec.

> 
> My vote is for vendor specific error codes, because unlike having a common user
> exit reason+struct, I don't think arch-neutral error codes will minimize KVM's ABI,
> I think it'll do the exact opposite.  The only thing we need to require is that
> '0' == success.

I think this makes sense if we think of using KVM_EXIT_COCO mainly an
interface for GHCB/GHCI interactions, but now that we're leveraging
KVM_HC_MAP_GPA_RANGE for page-state change requests, and TDX is planning
to do the same, it doesn't really seem like likely that exposing those
definitions to userspace at that level will reduce ABI.

For instance this is purely just a KVM interface to request a certificate
blob from userspace, which is a side-note as far as all the GHCB-defined
definitions KVM needs to deal with regarding handling GHCB
extended/non-extended guest requests. And KVM itself might have it's own
requirements on top for what it needs from userspace, and those
requirements might be separate from these vendor specs.

And if we expose things selectively to keep the ABI small, it's a bit
awkward too. For instance, KVM_EXIT_COCO_REQ_CERTS_ERR_* basically needs
a way to indicate success/fail/ENOMEM. Which we have with
(assuming 0==success):

  #define KVM_EXIT_COCO_REQ_CERTS_ERR_INVALID_LEN         1
  #define KVM_EXIT_COCO_REQ_CERTS_ERR_GENERIC             (1 << 31)

But the GHCB also defines other values like:

  #define SNP_GUEST_VMM_ERR_BUSY          2  

which don't make much sense to handle on the userspace side and doesn't
really have anything to do with the KVM_EXIT_COCO_REQ_CERTS KVM event,
which is a separate/self-contained thing from the general guest request
protocol. So would we expose that as ABI or not? If not then we end up
with this weird splitting of code. And if yes, then we have to sort of
give userspace a way to discover whenever new error codes are added to
the GHCB spec, because KVM needs to understand these value too and
users might be running on older kernel where only the currently-defined
error codes are present understood.

E.g. if we started off implementing KVM_EXIT_COCO_REQ_CERTS without a
way to request a larger buffer from the guest, and it wasn't later
on that SNP_GUEST_VMM_ERR_INVALID_LEN was added, we'd probably need a
capability bit or something to see if KVM supports requesting larger
page sizes from the guest. Otherwise userspace might just set it because
the spec says it's valid, but it won't work as expected because KVM
hasn't implemented that.

I guess technically we could reason about this particular one based on
which GHCB protocol version was set via KVM_SEV_INIT2, but what if
KVM itself was adding that functionality separately from the spec, and
now we got this intermingling of specs.

> 
> E.g. I think we can end up with something like:
> 
>   static int snp_complete_req_certs(struct kvm_vcpu *vcpu)
>   {
> 	struct vcpu_svm *svm = to_svm(vcpu);
> 	struct vmcb_control_area *control = &svm->vmcb->control;
> 
> 	if (vcpu->run->coco.req_certs.ret)
> 		if (vcpu->run->coco.req_certs.ret == SNP_GUEST_VMM_ERR_INVALID_LEN)

I'm not opposed to this approach, but just deciding which of:

  #define SNP_GUEST_VMM_ERR_INVALID_LEN   1
  #define SNP_GUEST_VMM_ERR_BUSY          2
  #define SNP_GUEST_VMM_ERR_GENERIC       BIT(31)

should be exposed to userspace based on how we've defined the
KVM_EXIT_COCO_REQ_CERTS already seems like an unecessary dilemma
versus just defining exactly what's needed and documenting that
in the KVM API.

If we anticipate needing to expose big chunks of GHCB/GHCI to
userspace for other reasons or future extensions of KVM_EXIT_COCO_*
then I definitely see the rationale to avoid duplication. But with
KVM_HC_MAP_GPA_RANGE case covered, I don't see any major reason to
think this will ever end up being the case.

It seems more likely this will just be KVM's handy place to handle "Hey
userspace, I need you to handle some CoCo-related stuff for me" and
it's really KVM that's driving those requirements vs. any particular
spec.

For instance, the certificate-fetching in the first place is only
handled by userspace because that's how KVM communinity decided to
handle it, not some general spec-driven requirement to handle these
sorts of things in userspace. Similarly for the KVM_HC_MAP_GPA_RANGE
that we originally considered this interface to handle: the fact that
userspace handles those requests is mainly a KVM/gmem design decision.

And like the KVM_HC_MAP_GPA_RANGE case, maybe we find there are cases
where a common KVM-defined event type can handle the requirements of
multiple specs with a common interface API, without exposing any
particular vendor definitions.

So based on that I sort of think giving KVM more flexibility on how it
wants to implement/document specific KVM_EXIT_COCO event types will
ultimately result in cleaner and more manageable ABI.

-Mike

> 			vcpu->arch.regs[VCPU_REGS_RBX] = vcpu->run->coco.req_certs.npages;
> 
> 		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> 					SNP_GUEST_ERR(vcpu->run->coco.req_certs.ret, 0));
> 		return 1;
> 	}
> 
> 	return snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
>   }
> 
> > +					__u32 ret;
> > +				} req_certs;
> > +			};
> 

