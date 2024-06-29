Return-Path: <kvm+bounces-20715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A426591C9C7
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 02:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25D34282A0C
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 00:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0829015A8;
	Sat, 29 Jun 2024 00:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="k0nKQWzt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BB8368;
	Sat, 29 Jun 2024 00:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719621391; cv=fail; b=ggWZSuD1dyw03eJ84kdbbOoBjiit3fgkQzvATwEPq4afmNjuvtLK+9CX04tceRivh7FAs791E9mweGoROIKYfUI1M6c2SA1lZzBIdyZVGRJ7VPIxFeSyUFXx+bkVugyIuZm6t7C/mqABbfO9I2jjI3cX8A+F1t+MEEC5uSiSoVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719621391; c=relaxed/simple;
	bh=8ff3zQ9xT985uogLhsHRNdeYhVEVZW0eXNzcppM0HwY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vFD/GOEtfb9LCWIndY3ZapAuzzeCOjmoIPEvdt8n+Cr4jWuHDM+5dmOKzfyhVSuSbSuWSxjkLeaexKqmfSe0MZ+j2YnDURc+sd7HwScSTD5+DNYjr8SxsL2cnG45vz4os8uf24bHqPtlAI2kIXyX8weZLtaQiZ/z9S5bPqTKlzY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=k0nKQWzt; arc=fail smtp.client-ip=40.107.92.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nURi3wRfBC+alOvlzu87+zSW3nvSaC3byq2luGBfPyuVMruxGCS1tHqXOaEO0G48xsuGU9WqZdtul2q/PUxsxCaakR4FiZY0ZOMfYrKwGuX838cf6pD81wsoj8PKI/Ixc7fuZZ2cm8uInlKM7su2HX14oUfESK9lJTWeeHq83e+ERelq8PxW7zHjhueYbUzLydfOvQmqK/vcPQam36diLREx7FS1v1Yvd/MtvuK4lEMDgm/lPyvaf7a2oOpYhVEQXKZFAagkP0R0K5aboA9BH9t0f1iylj/JbwSywOmULz0JC3MtU2gxh5FL5YIMeQjJe9ZY536gBhgGR4aJ0tflkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G4MDRHcsyr+17u89HGbZOyze2ViqsXXlZI+1judC1Iw=;
 b=BmyNo7FUAJN2MqulLG+A0afgHuGiVvYEXpJuDyHLcT/zuJOHzhxHnWGP25/WuMslRBUrXm8cX7E0dnuZDeNK6DzM/a7WR2buXC71qV8VWw5iIYYdowcmD4RuXbEkOL40kOpoU4a1lV+jg581G0A6ipzGbM1zd3WLxWvCEdxZiLZjPdK++OpNvMpx5miYp1oJ2hogaCY637mrgiZ9+1eRtpC+74s7jJX0ffd202025B7L8wFUAiL/+Wo51BB7b9HwwBWmw22+AKUoTb87GhqJfJa4DHbE/0ElzENV/oMssQ7ftmhpOAdka/aPVKSVWkrtw/KxidVsWuqOUoakmZTvEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G4MDRHcsyr+17u89HGbZOyze2ViqsXXlZI+1judC1Iw=;
 b=k0nKQWztUuh73JIjen7LvvlCej7f68Bq0I+R9WkDQJJMyoH9q8QLZ6HJhD+PXzkdMTEH8lUDe5lFBjw6qFjwwax5/fW6UAuZTDn7a7p6DGpy9NeyOlH20B+t3xmhiBxlMmx67mZUJsdzVFNE1bd5HHzJRGkOsdqy054XAgEddGw=
Received: from BL1PR13CA0182.namprd13.prod.outlook.com (2603:10b6:208:2be::7)
 by IA0PR12MB8746.namprd12.prod.outlook.com (2603:10b6:208:490::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.37; Sat, 29 Jun
 2024 00:36:24 +0000
Received: from MN1PEPF0000ECDA.namprd02.prod.outlook.com
 (2603:10b6:208:2be:cafe::40) by BL1PR13CA0182.outlook.office365.com
 (2603:10b6:208:2be::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.16 via Frontend
 Transport; Sat, 29 Jun 2024 00:36:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECDA.mail.protection.outlook.com (10.167.242.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Sat, 29 Jun 2024 00:36:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Jun
 2024 19:36:23 -0500
Date: Fri, 28 Jun 2024 19:36:06 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <pbonzini@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>
Subject: Re: [PATCH v1 4/5] KVM: Introduce KVM_EXIT_COCO exit type
Message-ID: <r7wqzejwpcvmys6jx7qcio2r6wvxfiideniqmwv5tohbohnvzu@6stwuvmnrkpo>
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-5-michael.roth@amd.com>
 <ZnwkMyy1kgu0dFdv@google.com>
 <r3tffokfww4yaytdfunj5kfy2aqqcsxp7sm3ga7wdytgyb3vnz@pfmstnvtuyg2>
 <Zn8YM-s0TRUk-6T-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zn8YM-s0TRUk-6T-@google.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDA:EE_|IA0PR12MB8746:EE_
X-MS-Office365-Filtering-Correlation-Id: a4d06a0e-0492-453f-17ff-08dc97d380fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ya/TGWcOCAyWTJZgR/Tvh9RBSUz4gSIqqjIKg1JWjDEyIntDHJFUKfSZ7RBS?=
 =?us-ascii?Q?4DoEZlm8dRSuZs4zYPKXwHXhIaWjZM1dJaQweHDCVJhkbq9UiFS9o0DuaDnS?=
 =?us-ascii?Q?zk+hWzQK3T4VLwfxJ5oJ/10DYtXVPpY9gvFBekTnppCzimcT7DISEJRgYax7?=
 =?us-ascii?Q?dGxVahlRZtJUrmJlqYxSiG4qY3eNnClgTj5ilDmVxhpOjSps04KCJ3Tjln+X?=
 =?us-ascii?Q?BXYlAxlgHSKqFR3aXPw2M3w76khZDg0yxmqavbwazRGJ8fdpnAp+CaSmdlYL?=
 =?us-ascii?Q?51u1YXXd8Sb7geiF35VLwwiU8UWebBvwhzHiabQ1IqMMtMoaa86f5PTJ3EcP?=
 =?us-ascii?Q?jHrG/FvR5wMf8A96v/Ai1pJ7sa0KLqYIuK9m6/9vHzVy8A95yoaJgoerOlEj?=
 =?us-ascii?Q?ORI/LltXYFiYCMA2tbAYf3ZbCBYtQG4CuMmshtyuZF2t7buwWuDkhxLh/pPm?=
 =?us-ascii?Q?hTxO50KeLXjIzKu4hrYy4WfTzrnq17nJJ9MPTLXp9+trAywRp+9XZqBjjqVG?=
 =?us-ascii?Q?x00LXxHo064T591osWpyd8wl0zJPK4U0OSBvQaEct5wsPWms9iJePpqHajS+?=
 =?us-ascii?Q?UcuPIS57zeI4HrLD0lKGGoNA7QMVgpvpx8W//vNtln/ovAWYzT6PV03jpMrB?=
 =?us-ascii?Q?k5ehdkvNKIumLoPKDEg9hmspcGK+JPBUzm8fVQGsgqTwNQh97QKexNPC2SOo?=
 =?us-ascii?Q?igVn+5ko11n2DJdQQGuJv0r+DZ28QYAHTvBBBQllItpkwdbB/EtNMLyzMTpC?=
 =?us-ascii?Q?yucPubPOeK4Ufl1hc+mqECQPUIWvJcjllgbOjb6ewhBbHPxlMzy5UijKO31R?=
 =?us-ascii?Q?6bJAtLkVvNu5zVH6owKOUs0AfMJEMgVcY/sW9mo3mKsFlKhJ2YyuIXS3+HMR?=
 =?us-ascii?Q?ydtjaQ9KTrkAitsIwZk87Tv+ChH6331Ex2NNi8Wpr7CjIeOwdNXBMJIQE5IH?=
 =?us-ascii?Q?rOJvDHs+NrgGeFelDGEyXXxQ1hpMbv7XEV8O7ujwKm9mXCVcWuxhlKBaXufX?=
 =?us-ascii?Q?gk7XkWVQi5ydyKeJ3gsSBwHXsve0xRWdp5lVvuFuTVuOhLO6y6bozReHpeOz?=
 =?us-ascii?Q?hodAYYpRY0u5LOivieX935euXJ/HYn0FddlEs5TGMy/3Jo4PYfrPk+CrSDxx?=
 =?us-ascii?Q?13hn6P78RFIAu5CHmTiz7/2/M1uwZss9HlPwH72XTdzJCbylX5BXIAHPGrRs?=
 =?us-ascii?Q?sinYvsYBAsrU3naRvJAySivJOuZbEvpctH9WUbc1QwGwM+eJBCw3sJyNs6pA?=
 =?us-ascii?Q?1WqrkdR35/e7m0TN/Dn73qFX7KGJc+GRYOYYjvdML2XNvAUBZiD/SdnkyXHT?=
 =?us-ascii?Q?ptfGddioIOq5npS5XxOdom+985IVvPzFY6V7BCkPjqpZN6qUBYy03DxUHwMU?=
 =?us-ascii?Q?icxRupT7/I+PxLQL2e91/CDeFJaFp2CDL/pQPDcJ35Wepy6ax974anwGyMot?=
 =?us-ascii?Q?VEhvBEqZVTfMLF7QfARXnXVetuJ5AC5v?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2024 00:36:23.7016
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4d06a0e-0492-453f-17ff-08dc97d380fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8746

On Fri, Jun 28, 2024 at 01:08:19PM -0700, Sean Christopherson wrote:
> On Wed, Jun 26, 2024, Michael Roth wrote:
> > On Wed, Jun 26, 2024 at 07:22:43AM -0700, Sean Christopherson wrote:
> > > On Fri, Jun 21, 2024, Michael Roth wrote:
> > > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > > index ecfa25b505e7..2eea9828d9aa 100644
> > > > --- a/Documentation/virt/kvm/api.rst
> > > > +++ b/Documentation/virt/kvm/api.rst
> > > > @@ -7122,6 +7122,97 @@ Please note that the kernel is allowed to use the kvm_run structure as the
> > > >  primary storage for certain register types. Therefore, the kernel may use the
> > > >  values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
> > > >  
> > > > +::
> > > > +
> > > > +		/* KVM_EXIT_COCO */
> > > > +		struct kvm_exit_coco {
> > > > +		#define KVM_EXIT_COCO_REQ_CERTS			0
> > > > +		#define KVM_EXIT_COCO_MAX			1
> > > > +			__u8 nr;
> > > > +			__u8 pad0[7];
> > > > +			union {
> > > > +				struct {
> > > > +					__u64 gfn;
> > > > +					__u32 npages;
> > > > +		#define KVM_EXIT_COCO_REQ_CERTS_ERR_INVALID_LEN		1
> > > > +		#define KVM_EXIT_COCO_REQ_CERTS_ERR_GENERIC		(1 << 31)
> > > 
> > > Unless I'm mistaken, these error codes are defined by the GHCB, which means the
> > > values matter, i.e. aren't arbitrary KVM-defined values.
> > 
> > They do happen to coincide with the GHCB-defined values:
> > 
> >   /*
> >    * The GHCB spec only formally defines INVALID_LEN/BUSY VMM errors, but define
> >    * a GENERIC error code such that it won't ever conflict with GHCB-defined
> >    * errors if any get added in the future.
> >    */
> >   #define SNP_GUEST_VMM_ERR_INVALID_LEN   1
> >   #define SNP_GUEST_VMM_ERR_BUSY          2
> >   #define SNP_GUEST_VMM_ERR_GENERIC       BIT(31)
> > 
> > and not totally by accident. But the KVM_EXIT_COCO_REQ_CERTS_ERR_* are
> > defined/documented without any reliance on the GHCB spec and are purely
> > KVM-defined. I just didn't really see any reason to pick different
> > numerical values since it seems like purposely obfuscating things for
> 
> For SNP.  For other vendors, the numbers look bizarre, e.g. why bit 31?  And the
> fact that it appears to be a mask is even more odd.

That's fair. Values 1 and 2 made sense so just re-use, but that results
in a awkward value for _GENERIC that's not really necessary for the KVM
side.

> 
> > no real reason. But the code itself doesn't rely on them being the same
> > as the spec defines, so we are free to define these however we'd like as
> > far as the KVM API goes.
> 
> > > I forget exactly what we discussed in PUCK, but for the error codes, I think KVM
> > > should either define it's own values that are completely disconnected from any
> > > "harware" spec, or KVM should very explicitly #define all hardware values and have
> > 
> > I'd gotten the impression that option 1) is what we were sort of leaning
> > toward, and that's the approach taken here.
> 
> > And if we expose things selectively to keep the ABI small, it's a bit
> > awkward too. For instance, KVM_EXIT_COCO_REQ_CERTS_ERR_* basically needs
> > a way to indicate success/fail/ENOMEM. Which we have with
> > (assuming 0==success):
> > 
> >   #define KVM_EXIT_COCO_REQ_CERTS_ERR_INVALID_LEN         1
> >   #define KVM_EXIT_COCO_REQ_CERTS_ERR_GENERIC             (1 << 31)
> > 
> > But the GHCB also defines other values like:
> > 
> >   #define SNP_GUEST_VMM_ERR_BUSY          2  
> > 
> > which don't make much sense to handle on the userspace side and doesn't
> 
> Why not?  If userspace is waiting on a cert update for whatever reason, why can't
> it signal "busy" to the guest?

My thinking was that userspace is free to take it's time and doesn't need
to report delays back to KVM. But it would reduce the potential for
soft-lockups in the guest, so it might make sense to work that into the
API.

But more to original point, there could be something added in the future
that really has nothing to do with anything involving KVM<->userspace
interaction and so would make no sense to expose to userspace.
Unfortunately I picked a bad example. :)

> 
> > really have anything to do with the KVM_EXIT_COCO_REQ_CERTS KVM event,
> > which is a separate/self-contained thing from the general guest request
> > protocol. So would we expose that as ABI or not? If not then we end up
> > with this weird splitting of code. And if yes, then we have to sort of
> > give userspace a way to discover whenever new error codes are added to
> > the GHCB spec, because KVM needs to understand these value too and
> 
> Not necessarily.  So long as KVM doesn't need to manipulate guest state, e.g. to
> set RBX (or whatever reg it is) for ERR_INVALID_LEN, then KVM doesn't need to
> care/know about the error codes.  E.g. userspace could signal VMM_BUSY and KVM
> would happily pass that to the guest.

But given we already have an exception to that where KVM does need to
intervene for certain errors codes like ERR_INVALID_LEN that require
modifying guest state, it doesn't seem like a good starting position
to have to hope that it doesn't happen again.

It just doesn't seem necessary to put ourselves in a situation where
we'd need to be concerned by that at all. If the KVM API is a separate
and fairly self-contained thing then these decisions are set in stone
until we want to change it and not dictated/modified by changes to
anything external without our explicit consideration.

I know the certs things is GHCB-specific atm, but when the certs used
to live inside the kernel the KVM_EXIT_* wasn't needed at all, so
that's why I see this as more of a KVM interface thing rather than
a GHCB one. And maybe eventually some other CoCo implementation also
needs some interface for fetching certificates/blobs from userspace
and is able to re-use it still because it's not too SNP-specific
and the behavior isn't dictated by the GHCB spec (e.g.
ERR_INVALID_LEN might result in some other state needing to be
modified in their case rather than what the GHCB dictates.)

> 
> > users might be running on older kernel where only the currently-defined
> > error codes are present understood.
> > 
> > E.g. if we started off implementing KVM_EXIT_COCO_REQ_CERTS without a
> > way to request a larger buffer from the guest, and it wasn't later
> > on that SNP_GUEST_VMM_ERR_INVALID_LEN was added, we'd probably need a
> > capability bit or something to see if KVM supports requesting larger
> 
> We'd need that regardless, no?  Even if some other architecture added a error
> code for invalid length, KVM would need to reject that for SNP because KVM couldn't
> translate ERR_INVALID_LEN into an SNP error code.  And when a KVM comes along
> that does support that error code, KVM would need a way to advertise support.

But in that case it would be immediately obvious that if they
extended KVM_EXIT_COCO_REQ_CERTS (or whatever) they'd need to be aware
that other architectures are already using it and make the appropriate
accomodations to make those extensions discoverable.

> 
> But if KVM simply forwards error codes, then KVM only needs to advertise support
> if KVM reacts to the error code.

Forwards them where though? There's not really any reason that userspace
needs to be cognizant of that fact that error codes are being passed to
the guest. It needs to tell KVM either:

  a) success: here's the cert blob
  b) error: i need more space
  c) error: i'm busy (potentially)
  d) error: something bad on my end, handle it as you will

Being able to mediate all the architecture-specific details on the
backend without complicating the front-end we expose to userspace gives
more flexibility with how we handle compatibility stuff between
architectures. And we'd still only need to advertise what the interface
explicitly requires userspace to be aware of.

> 
> As mentioned in the previous version, ideally userspace would need to set guest
> regs for INVALID_LEN case, but I don't see a sane/reasonable way to do that.

We had KVM_EXIT_VMGEXIT previously, where userspace had direct access to
the GHCB. I think TDX had similar. But that went away when we unified
under KVM_HC_MAP_GPA_RANGE.

No question that, in that case, it made sense to lean heavily on
GHCB-defined values/handling. But I thought KVM_EXIT_COCO was an attempt
to capitalize on the KVM_HC_MAP_GPA_RANGE success story and further move
toward providing more potential for common APIs for other CoCo stuff.

> 
> > page sizes from the guest. Otherwise userspace might just set it because
> > the spec says it's valid, but it won't work as expected because KVM
> > hasn't implemented that.
> > 
> > I guess technically we could reason about this particular one based on
> > which GHCB protocol version was set via KVM_SEV_INIT2, but what if
> > KVM itself was adding that functionality separately from the spec, and
> > now we got this intermingling of specs.
> 
> How would KVM do that?  

Hmm, good question. I don't think I was talking specifically about
KVM adding *_INVALID_LEN support outside of the GHCB spec at that point,
but I'm not sure I had a good example in mind. I certainly don't atm =\

> 
> > > E.g. I think we can end up with something like:
> > > 
> > >   static int snp_complete_req_certs(struct kvm_vcpu *vcpu)
> > >   {
> > > 	struct vcpu_svm *svm = to_svm(vcpu);
> > > 	struct vmcb_control_area *control = &svm->vmcb->control;
> > > 
> > > 	if (vcpu->run->coco.req_certs.ret)
> > > 		if (vcpu->run->coco.req_certs.ret == SNP_GUEST_VMM_ERR_INVALID_LEN)
> > 
> > I'm not opposed to this approach, but just deciding which of:
> > 
> >   #define SNP_GUEST_VMM_ERR_INVALID_LEN   1
> >   #define SNP_GUEST_VMM_ERR_BUSY          2
> >   #define SNP_GUEST_VMM_ERR_GENERIC       BIT(31)
> > 
> > should be exposed to userspace based on how we've defined the
> > KVM_EXIT_COCO_REQ_CERTS already seems like an unecessary dilemma
> > versus just defining exactly what's needed and documenting that
> > in the KVM API.
> 
> But that's not what your code does.  It exposes gunk that isn't necessary
> (ERR_GENERIC), and then doesn't enforce anything on the backend because

Agreed that I should be explicitly enforcing that only the defined error
codes should be getting returned by userspace. I think that's more of a bug
on my part rather than a consequence of design choices though.

> snp_complete_req_certs() interprets any non-zero "return" value as a "generic"
> error.  If we actually want to maintain extensibility, then KVM needs to enforce
> inputs.
> 
> And if we do that, then it doesn't really matter whether KVM defines arbitrary
> error codes or reuses the GHCB codes, e.g. it'll either be:

For instance, the GHCB spec mentions:

    A SW_EXITINFO2 value of 0 indicates a successful completion of the SNP Guest Request.

and goes on to document *_INVALID_LEN and *_ERR_BUSY as other possible
values.

...but it doesn't really define anything for "unable to fetch certs", and
that's certainly a situation userspace might hit if it got
deleted/renamed/etc. It's trivial for KVM to just make up some specific
or generic error to handle this case with the current approach.

If we took that stance that userspace should just return what the GHCB
says, then the GHCB protocol does document a more generic set of error
hypervisor-specific error codes that can be set in SW_EXITINFO2 when
SW_EXITINFO1 is set to '2':

  Table 7: Invalid GHCB Reason Codes
  Value  Description
  0x0001 The GHCB address was not registered (SEV-SNP)
  0x0002 The GHCB Usage value was not valid
  0x0003 The SW_SCRATCH field was not valid / could not be mapped
  0x0004 The required input fields(s) for the NAE event were not marked valid
         in the GHCB VALID_BITMAP field
  0x0005 The NAE event input was not valid (e.g., an invalid SW_EXITINFO1 value
         for the AP Jump Table NAE event)
  0x0006 The NAE event was not valid
  0x0007-0xffff Reserved
  0x10000+ Available for hypervisor specific reason codes.

But in order for userspace to set them, we need to expose the notion of
SW_EXITINFO1 and SW_EXITINFO2 so it can set the appropriate values 
directly. But even then it's weird because lower 32-bits of SW_EXITINFO2
correspond to the fw_err passed back by SNP firmware, only KVM can set
that.

So you can't just point to the GHCB spec, you need to point to the GHCB
spec, expose bits and pieces of GHCB-defined values as ABI, and then layer
KVM-specific stuff on top like 'KVM will set the fw_err value so these
bits are actually off-limits for you', or potentially only give them the
upper 32-bits to work with and inform them to ignore the lower 32-bits
mentioned in the GHCB spec.

That sort of illustrates my concerns with this approach. It's
unpredictable what parts of the GHCB spec are/aren't applicable for
these particular interactions between KVM<->userspace, or how much
relying on that sort of approach will complicate
interfaces/documentation that might otherwise be much simpler KVM gives
itself the leeway to define them in the manner that is most convenient
to KVM.

> 
>         if (vcpu->run->coco.req_certs.ret)
>                 if (vcpu->run->coco.req_certs.ret != KVM_EXIT_COCO_REQ_CERTS_ERR_INVALID_LEN)
> 			return -EINVAL;
> 
>                 vcpu->arch.regs[VCPU_REGS_RBX] = vcpu->run->coco.req_certs.npages;
>                 ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
>                                         SNP_GUEST_ERR(vcpu->run->coco.req_certs.ret, 0));
>                 return 1;
>         }
> 
> versus:
> 
>         if (vcpu->run->coco.req_certs.ret)
>                 if (vcpu->run->coco.req_certs.ret != SNP_GUEST_VMM_ERR_INVALID_LEN)
> 			return -EINVAL;
> 
>                 vcpu->arch.regs[VCPU_REGS_RBX] = vcpu->run->coco.req_certs.npages;
>                 ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
>                                         SNP_GUEST_ERR(vcpu->run->coco.req_certs.ret, 0));
>                 return 1;
>         }
> 
> (with variations depending on whether or not KVM allows SNP_GUEST_VMM_ERR_BUSY).

>  
> > If we anticipate needing to expose big chunks of GHCB/GHCI to
> > userspace for other reasons or future extensions of KVM_EXIT_COCO_*
> > then I definitely see the rationale to avoid duplication. But with
> > KVM_HC_MAP_GPA_RANGE case covered, I don't see any major reason to
> > think this will ever end up being the case.
> > 
> > It seems more likely this will just be KVM's handy place to handle "Hey
> > userspace, I need you to handle some CoCo-related stuff for me" and
> > it's really KVM that's driving those requirements vs. any particular
> > spec.
> > 
> > For instance, the certificate-fetching in the first place is only
> > handled by userspace because that's how KVM communinity decided to
> > handle it, not some general spec-driven requirement to handle these
> > sorts of things in userspace. Similarly for the KVM_HC_MAP_GPA_RANGE
> > that we originally considered this interface to handle: the fact that
> > userspace handles those requests is mainly a KVM/gmem design decision.
> > 
> > And like the KVM_HC_MAP_GPA_RANGE case, maybe we find there are cases
> > where a common KVM-defined event type can handle the requirements of
> > multiple specs with a common interface API, without exposing any
> > particular vendor definitions.
> > 
> > So based on that I sort of think giving KVM more flexibility on how it
> > wants to implement/document specific KVM_EXIT_COCO event types will
> > ultimately result in cleaner and more manageable ABI.
> 
> I don't disagree, I'm just not seeing how regurgitating the GHCB error codes
> provides flexibility.  As above, unless KVM is super restrictive about which
> error codes can be returned, KVM has zero flexibility.

I tried to give a better example above of why I think leaning too heavily
on the GHCB or other specs would potentially make for less-flexible
interfaces.

> 
> Reusing exit reasons and whatnot, e.g. for KVM_HC_MAP_GPA_RANGE, is all about
> reducing copy+paste and not having to deal with 14^W15 different standards.  Any
> ABI flexibility gained is a nice bonus.  If we think there's actually a chance
> that a different vendor can use KVM_EXIT_COCO_REQ_CERTS and userspace won't end
> end up with wildly different implementations, then yeah, let's define generic
> return codes.

That's sort of my hope here. I know the certificate blob format itself
is SNP-specific, and most likely someone would need to massage it or
extend it for other applications, but at least it's not 100% guaranteed to
be useless for other archs. And if you want to take steps further toward
that goal, then maybe we can consider not even passing in the GPAs to
userspace and just have a KVM_EXIT_COCO_FETCH_BLOB interface along with
a scratch buffer somewhere to handle it or something.
> 
> But if we're just going to end up with a bunch of vendor error codes redefined
> by KVM, I don't see the point.

I also have no qualms about leaning on the GHCB spec where appropriate, or
even wholesale if the need arose. But I just don't think fetching the
certificate blob would benefit much from going down that route, and the
penalty for re-definitions in this case seems smaller than the additional
uAPI complexity we'd have exposing the sw_exitinfo1/sw_exitnfo2 fields needed
to fully allow userspace to code against the GHCB spec rather than a
self-contained KVM-defined abstraction layer.

> 
> Another way to approach this would be to use existing the errno values, i.e.
> EINVAL and EBUSY in this case.  The upside is we don't have to define custom
> return codes.  The downside is that KVM needs to translate (though if we actually

I think I would greatly prefer that as a middle ground between the 2
approaches. We wouldn't have to redefine anything, and we'd still have the
flexibility to document the meaning/handling of these errors code in the
KVM API documentation.

> expect vendors to reuse KVM_EXIT_COCO_REQ_CERTS, odds are good at least one vendor
> will need to translate, i.e. won't be able to use KVM_EXIT_COCO_REQ_CERTS_ERR_INVALID_LEN
> verbatim like SNP).

If SNP translates right off the bat then I think that's a good sets a good
example for others who might be fishing for an interface they can re-use.

-Mike


