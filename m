Return-Path: <kvm+bounces-32054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E30889D2766
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 14:54:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A411B2850D7
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 13:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 653931CF293;
	Tue, 19 Nov 2024 13:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="t/eLNeo4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55D51CEE98;
	Tue, 19 Nov 2024 13:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732024428; cv=fail; b=AXFnV6Xt7ORNfytUHZGoy9ijzv9V8eYeLn+Pee/aQPWh9fZs5V7h8Mqg7nR+n4lBSLT1y9uh0bizS53PKrsEXE3n3tT1xjYnwmt2KEuG7OKQYW0x/5DDtvQFOVcffrYNFenwi5aTpQgCTBlW26ZB27fvpgqF1RdnWhtDx4PNGDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732024428; c=relaxed/simple;
	bh=iP8OKtRc39mSnV1/1Wwz5GD/V3w9G+5aPRPOXnnCvm0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FO9NnUpU1y8ipDbxypRjazp097sb8PcVQ9I3YHxE40ICOouOap0+mkgKq8XA2zQr1Xjw9+KYctlRLqc/POkrn9iPY0cRv8MKnidOh+pBXvVIGb8rxaMdORX05uxiEV22SHFoCKo8XMO9TMcIYh0/mPoUHIHMdqma+AR1F8PFaWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=t/eLNeo4 reason="signature verification failed"; arc=fail smtp.client-ip=40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IajSXINg+4VMKsSxXzloWvBi68shDpjAmNd7IzHFy5L1CeqpUbfLtb4PYbUgv7ic8gd8eeMjPOqMWe8A/IMYYKMeY92hOifXBTfzIUFWJMyqb5Vs01NC1VjjqMfst5koVshZodSFK7Zy4WnDQOlJSQH+ADwkXWrsIVeFoKFM/kFlOwbizaFOsjicx4spnaodZKoyaI4ZC35o27maF/po/qmpFD5wT7LCRvDigt85tk/yCOeutA7ifNjD6o5EKJ5wtuxI1QLH4IcTRbaGG8M+R/sbXzo6Vh6G8zR/K1oIFvMBSWsD2bPUeG2vqmhR2S/KLXEivTM8j/7yOJF4/6eYQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=igXXYeas+lOO9eFyp4njR0bGYI+wpFyq+W3+q+n0tCo=;
 b=C1O3NaVDT+K7SrI4E6i6iiRZ5nwWe6zig0jx0Hs1cOyQtjcktRMHZ8USq4qTM1Xrzl/u+EVsIvbwubHaMgN2f7JBokqUly0otcYRWCxq7/UK6XkWPXODSvbYncuoXX79TrHQ9HXUgwZggNwbWc49rEKdDMXz5Cc2AbZ/pEntYyGh/TEFynLFWwlwq7+CClm+bV+FMsyi0gJrkOKt3jCpOOkhzszhpKR4agDc1dK5pmD8y6DGqI7IwYZcOI29yKm1Ss9ZStTMevEqbtLvTYeEgWOM4nYtf98eJx73hqpT5i55myctYziDpKmBwpfM7omzYcRuV/Pt2WLZXbeULskmDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.12) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=igXXYeas+lOO9eFyp4njR0bGYI+wpFyq+W3+q+n0tCo=;
 b=t/eLNeo4G+eZRe+WAwLwch2BHhCOPMgGRq/yg2AqJN73WilmQv8bWr/JSVa3XbxQNo5l+TGrNNpe2YZjMo4uFLbdYMlunLq2CKOLc1cg71RevfrqGXEzux8PyH6U8W1GEpEG+24kdVsiOPt57tx9Rw+vRdxNeGT3S9SFx10BaL4=
Received: from CH5PR02CA0005.namprd02.prod.outlook.com (2603:10b6:610:1ed::7)
 by BN5PR12MB9464.namprd12.prod.outlook.com (2603:10b6:408:2ab::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Tue, 19 Nov
 2024 13:53:43 +0000
Received: from CH1PEPF0000AD7B.namprd04.prod.outlook.com
 (2603:10b6:610:1ed:cafe::25) by CH5PR02CA0005.outlook.office365.com
 (2603:10b6:610:1ed::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.25 via Frontend
 Transport; Tue, 19 Nov 2024 13:53:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.12)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.12; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.12) by
 CH1PEPF0000AD7B.mail.protection.outlook.com (10.167.244.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8158.14 via Frontend Transport; Tue, 19 Nov 2024 13:53:42 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 19 Nov
 2024 07:53:42 -0600
Date: Tue, 19 Nov 2024 07:53:27 -0600
From: Michael Roth <michael.roth@amd.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <ashish.kalra@amd.com>,
	<bp@alien8.de>, <pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, Reinette Chatre
	<reinette.chatre@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>
Subject: Re: [PATCH v1 4/5] KVM: Introduce KVM_EXIT_COCO exit type
Message-ID: <20241119135327.zjxlczjbli3wdo5o@amd.com>
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-5-michael.roth@amd.com>
 <ZnwkMyy1kgu0dFdv@google.com>
 <r3tffokfww4yaytdfunj5kfy2aqqcsxp7sm3ga7wdytgyb3vnz@pfmstnvtuyg2>
 <Zn8YM-s0TRUk-6T-@google.com>
 <r7wqzejwpcvmys6jx7qcio2r6wvxfiideniqmwv5tohbohnvzu@6stwuvmnrkpo>
 <f8dfeab2-e5f2-4df6-9406-0aff36afc08a@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f8dfeab2-e5f2-4df6-9406-0aff36afc08a@linux.intel.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7B:EE_|BN5PR12MB9464:EE_
X-MS-Office365-Filtering-Correlation-Id: 066a9780-1648-45ea-d133-08dd08a19456
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?qRO4ZJfkcomnrYnsx/fCPt1mM97o8oI7y91DhQepcMIUXMSEBmIeZNnWpS?=
 =?iso-8859-1?Q?gxwZA545vIHHFl4LUdN1ZGdUuQiqPbxBabGLaBeG2tLmrSjKTiXwLhqyyx?=
 =?iso-8859-1?Q?uCpMQv0NS8Ff27RhX0atmcI1H6pEs7PJBRiT0G0DJC6jMjHb5bMZP66SdF?=
 =?iso-8859-1?Q?okj8UFN65vLjR1xDQEBI8s1UDNd9+WRsrdj6y+Mm51NG95hMkPa4EGn0/Y?=
 =?iso-8859-1?Q?FR3cta9pBaJNt8CK+ssp3+8CZeEXEDustCQBCaNoccviZDdkg4eZJ1+TZ4?=
 =?iso-8859-1?Q?7DYVwMexGFx3TtxS3hm/D5sbQHKm+p515TgDpwFNXk7PYV8M0AlR66LHnk?=
 =?iso-8859-1?Q?IV0pRjOYAxNzsxsnsRN6aRs7GCJQBmEHv2Wb5i0UqguNs+C5aOMQb4oNmy?=
 =?iso-8859-1?Q?JUeEvUAFxP96P5RJZco5TPH84YYzsSA0DlHvpLh/PDUI/4p03rEgv8HDpH?=
 =?iso-8859-1?Q?nWEMh0kmd0dU8fX8cEZEVhvPaCH6OUvBfygz62MrbFMGZ1GPoeU2X23prA?=
 =?iso-8859-1?Q?BI7tvrVTuSRjAdlxmN5uk0tfMPIhmFYGlDMuy+8Q9IHr3wDUuTBp8BIbbm?=
 =?iso-8859-1?Q?3XyJ3kaU65diP6YLop/lS3FAWztrwwrpw09BVH7JKWMWz2db2isQqRZanu?=
 =?iso-8859-1?Q?Pj4H4c8SmeSdq8kh0y5qcY+fuDudMRowSnX8xrfTsv1bxVk85aYkevcPuT?=
 =?iso-8859-1?Q?LXJlJVdgU9BynYRvbb4nduQRljTPZafjhvngtqP1hY2BQwFoG0XR8tb5B4?=
 =?iso-8859-1?Q?CEC4leHyn6xth4QAnQVSXuAoH0/gPum2Z6pEAvZ5SZUDVjGe/99v4nYFxV?=
 =?iso-8859-1?Q?ZUDld81qikQHZDWHbZmaKz85PW6Z047i6OUMT/2nf+fxTEETiP5p2U0ps0?=
 =?iso-8859-1?Q?dq9Hwt8R0tAtI4t5U9/3WPVxjb/2XSmQ3qv3uoByhBLRHzeYg2lPOsMEgR?=
 =?iso-8859-1?Q?xSXOPgcsnuGBc42sPFNNQH4B8egEoifeZVDwX0ILT4dXy1GN+9r3kR+lou?=
 =?iso-8859-1?Q?Bm+722dia8MU5rDHLLZJPP8uZgvwM0NjdVg9GcFbxkc1ZkRerEBMsk7h6W?=
 =?iso-8859-1?Q?4qeyQRyQSgJtwohIPwktNjSs79kCWExWTjRfcoGYjfDTqwHXTdgyqsVBVj?=
 =?iso-8859-1?Q?GYpewk6xyYFYQY/zbHw5shGDgDg+jVPoPCMLf4GkSPh2TarhtX5MO5/hND?=
 =?iso-8859-1?Q?VXqWfCGk1N0Qs2FonCcsvFG1ZBGnTk3HlFbP6QbHvlk9i6hdekfOZca7M8?=
 =?iso-8859-1?Q?b776awj9822AzLBBAu8ijH/8bQ7SMYaCTo4aHrbyjFnYzG12916p021FXZ?=
 =?iso-8859-1?Q?nXm2jC0cZ3QfP8t9gxZxrh8XZHDqF3ZPn0SxcPNOhZaKUonDL848HAeojK?=
 =?iso-8859-1?Q?dWh/auSkA8jelPoEvX2tKtCTPEbQCMUEtXqHb0udjjuPpJmlVEvLlE3SIq?=
 =?iso-8859-1?Q?drsF2UWLn779HXC7NszpA51307vPPHs1sUUZpc7g7VU6+e0+2Z4ZwUhdOx?=
 =?iso-8859-1?Q?M=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.12;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:atlvpn-bp.amd.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2024 13:53:42.7015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 066a9780-1648-45ea-d133-08dd08a19456
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.12];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9464

On Fri, Jul 26, 2024 at 03:15:01PM +0800, Binbin Wu wrote:
> 
> 
> On 6/29/2024 8:36 AM, Michael Roth wrote:
> > On Fri, Jun 28, 2024 at 01:08:19PM -0700, Sean Christopherson wrote:
> > > On Wed, Jun 26, 2024, Michael Roth wrote:
> > > > On Wed, Jun 26, 2024 at 07:22:43AM -0700, Sean Christopherson wrote:
> > > > > On Fri, Jun 21, 2024, Michael Roth wrote:
> > > > > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > > > > index ecfa25b505e7..2eea9828d9aa 100644
> > > > > > --- a/Documentation/virt/kvm/api.rst
> > > > > > +++ b/Documentation/virt/kvm/api.rst
> > > > > > @@ -7122,6 +7122,97 @@ Please note that the kernel is allowed to use the kvm_run structure as the
> > > > > >   primary storage for certain register types. Therefore, the kernel may use the
> > > > > >   values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
> > > > > > +::
> > > > > > +
> > > > > > +		/* KVM_EXIT_COCO */
> > > > > > +		struct kvm_exit_coco {
> > > > > > +		#define KVM_EXIT_COCO_REQ_CERTS			0
> > > > > > +		#define KVM_EXIT_COCO_MAX			1
> > > > > > +			__u8 nr;
> > > > > > +			__u8 pad0[7];
> > > > > > +			union {
> > > > > > +				struct {
> > > > > > +					__u64 gfn;
> > > > > > +					__u32 npages;
> > > > > > +		#define KVM_EXIT_COCO_REQ_CERTS_ERR_INVALID_LEN		1
> > > > > > +		#define KVM_EXIT_COCO_REQ_CERTS_ERR_GENERIC		(1 << 31)
> > > > > Unless I'm mistaken, these error codes are defined by the GHCB, which means the
> > > > > values matter, i.e. aren't arbitrary KVM-defined values.
> > > > They do happen to coincide with the GHCB-defined values:
> > > > 
> > > >    /*
> > > >     * The GHCB spec only formally defines INVALID_LEN/BUSY VMM errors, but define
> > > >     * a GENERIC error code such that it won't ever conflict with GHCB-defined
> > > >     * errors if any get added in the future.
> > > >     */
> > > >    #define SNP_GUEST_VMM_ERR_INVALID_LEN   1
> > > >    #define SNP_GUEST_VMM_ERR_BUSY          2
> > > >    #define SNP_GUEST_VMM_ERR_GENERIC       BIT(31)
> > > > 
> > > > and not totally by accident. But the KVM_EXIT_COCO_REQ_CERTS_ERR_* are
> > > > defined/documented without any reliance on the GHCB spec and are purely
> > > > KVM-defined. I just didn't really see any reason to pick different
> > > > numerical values since it seems like purposely obfuscating things for
> > > For SNP.  For other vendors, the numbers look bizarre, e.g. why bit 31?  And the
> > > fact that it appears to be a mask is even more odd.
> > That's fair. Values 1 and 2 made sense so just re-use, but that results
> > in a awkward value for _GENERIC that's not really necessary for the KVM
> > side.
> > 
> > > > no real reason. But the code itself doesn't rely on them being the same
> > > > as the spec defines, so we are free to define these however we'd like as
> > > > far as the KVM API goes.
> > > > > I forget exactly what we discussed in PUCK, but for the error codes, I think KVM
> > > > > should either define it's own values that are completely disconnected from any
> > > > > "harware" spec, or KVM should very explicitly #define all hardware values and have
> > > > I'd gotten the impression that option 1) is what we were sort of leaning
> > > > toward, and that's the approach taken here.
> > > > And if we expose things selectively to keep the ABI small, it's a bit
> > > > awkward too. For instance, KVM_EXIT_COCO_REQ_CERTS_ERR_* basically needs
> > > > a way to indicate success/fail/ENOMEM. Which we have with
> > > > (assuming 0==success):
> > > > 
> > > >    #define KVM_EXIT_COCO_REQ_CERTS_ERR_INVALID_LEN         1
> > > >    #define KVM_EXIT_COCO_REQ_CERTS_ERR_GENERIC             (1 << 31)
> > > > 
> > > > But the GHCB also defines other values like:
> > > > 
> > > >    #define SNP_GUEST_VMM_ERR_BUSY          2
> > > > 
> > > > which don't make much sense to handle on the userspace side and doesn't
> > > Why not?  If userspace is waiting on a cert update for whatever reason, why can't
> > > it signal "busy" to the guest?
> > My thinking was that userspace is free to take it's time and doesn't need
> > to report delays back to KVM. But it would reduce the potential for
> > soft-lockups in the guest, so it might make sense to work that into the
> > API.
> > 
> > But more to original point, there could be something added in the future
> > that really has nothing to do with anything involving KVM<->userspace
> > interaction and so would make no sense to expose to userspace.
> > Unfortunately I picked a bad example. :)
> > 
> > > > really have anything to do with the KVM_EXIT_COCO_REQ_CERTS KVM event,
> > > > which is a separate/self-contained thing from the general guest request
> > > > protocol. So would we expose that as ABI or not? If not then we end up
> > > > with this weird splitting of code. And if yes, then we have to sort of
> > > > give userspace a way to discover whenever new error codes are added to
> > > > the GHCB spec, because KVM needs to understand these value too and
> > > Not necessarily.  So long as KVM doesn't need to manipulate guest state, e.g. to
> > > set RBX (or whatever reg it is) for ERR_INVALID_LEN, then KVM doesn't need to
> > > care/know about the error codes.  E.g. userspace could signal VMM_BUSY and KVM
> > > would happily pass that to the guest.
> > But given we already have an exception to that where KVM does need to
> > intervene for certain errors codes like ERR_INVALID_LEN that require
> > modifying guest state, it doesn't seem like a good starting position
> > to have to hope that it doesn't happen again.
> > 
> > It just doesn't seem necessary to put ourselves in a situation where
> > we'd need to be concerned by that at all. If the KVM API is a separate
> > and fairly self-contained thing then these decisions are set in stone
> > until we want to change it and not dictated/modified by changes to
> > anything external without our explicit consideration.
> > 
> > I know the certs things is GHCB-specific atm, but when the certs used
> > to live inside the kernel the KVM_EXIT_* wasn't needed at all, so
> > that's why I see this as more of a KVM interface thing rather than
> > a GHCB one. And maybe eventually some other CoCo implementation also
> > needs some interface for fetching certificates/blobs from userspace
> > and is able to re-use it still because it's not too SNP-specific
> > and the behavior isn't dictated by the GHCB spec (e.g.
> > ERR_INVALID_LEN might result in some other state needing to be
> > modified in their case rather than what the GHCB dictates.)
> 
> TDX GHCI does have a similar PV interface for TDX guest to get quota, i.e.,
> TDG.VP.VMCALL<GetQuote>.  This GetQuote PV interface is designed to invoke
> a request to generate a TD-Quote signing by a service hosting TD-Quoting
> Enclave operating in the host environment for a TD Report passed as a
> parameter by the TD.
> And the request will be forwarded to userspace for handling.
> 
> So like GHCB, TDX needs to pass a shared buffer to userspace, which is
> specified by GPA and size (4K aligned) and get the error code from
> userspace and forward the error code to guest.
> 
> But there are some differences from GHCB interface.
> 1. TDG.VP.VMCALL<GetQuote> is a a doorbell-like interface used to queue a
>    request. I.e., it is an asynchronous request.  The error code represents
>    the status of request queuing, *not* the status of TD Quote generation..
> 2. Besides the error code returned by userspace for GetQuote interface, the
>    GHCI spec defines a "Status Code" field in the header of the shared
> buffer.
>    The "Status Code" field is also updated by VMM during the real handling
> of
>    getting quote (after TDG.VP.VMCALL<GetQuote> returned to guest).
>    After the TDG.VP.VMCALL<GetQuote> returned and back to TD guest, the TD
>    guest can poll the "Status Code" field to check if the processing is
>    in-flight, succeeded or failed.
>    Since the real handling of getting quota is happening in userspace, and
>    it will interact directly with guest, for TDX, it has to expose TDX
>    specific error code to userspace to update the result of quote
> generation.
> 
> Currently, TDX is about to add a new TDX specific KVM exit reason, i.e.,
> KVM_EXIT_TDX_GET_QUOTE and its related data structure based on a previous
> discussion. https://lore.kernel.org/kvm/Zg18ul8Q4PGQMWam@google.com/
> For the error code returned by userspace, KVM simply forward the error code
> to guest without further translation or handling.
> 
> I am neutral to have a common KVM exit reason to handle both GHCB for
> REQ_CERTS and GHCI for GET_QUOTE.  But for the error code, can we uses
> vendor
> specific error codes if KVM cares about the error code returned by userspace
> in vendor specific complete_userspace_io callback?

A few weeks back we discussed during the PUCK call on whether it makes
sense for use a common exit type for REQ_CERTS and TDX_GET_QUOTE, and
due to the asynchronous/polling nature of TDX_GET_QUOTE, and the
somewhat-particular file-locking requirements that need to be built into
the REQ_CERTS handling, we'd decided that it's probably more trouble
than it's worth to try to merge the 2.

However, I'm still hoping that KVM_EXIT_COCO might still provide some
useful infrastructure for introducing something like
KVM_EXIT_COCO_GET_QUOTE that implements the TDX-specific requirements
more directly.

I've just submitted v2 of KVM_EXIT_COCO where the userspace-provided
error codes are reworked to be less dependent on specific spec-defined
values but instead relies on standard error codes that KVM can provide
special handling for internally when needed:

  https://lore.kernel.org/kvm/20241119133513.3612633-1-michael.roth@amd.com/

But I suppose in your case userspace would just return "SUCCESS"/0 and
then all the vendor-specific values are mainly in relation to the
"Status Code" field so it likely doesn't make a huge difference as far
as what userspace passes back to KVM.

Thanks,

Mike

> 
> BTW, here is the plan of 4 hypercalls needing to exit to userspace for
> TDX basic support series:
> TDG.VP.VMCALL<SetupEventNotifyInterrupt>
> - Add a new KVM exit reason KVM_EXIT_TDX_SETUP_EVENT_NOTIFY
> TDG.VP.VMCALL<GetQuote>
> - Add a new KVM exit reason KVM_EXIT_TDX_GET_QUOTE
> TDG.VP.VMCALL<MapGPA>
> - Reuse KVM_EXIT_HYPERCALL with KVM_HC_MAP_GPA_RANGE
> TDG.VP.VMCALL<ReportFatalError>
> - Reuse KVM_EXIT_SYSTEM_EVENT but add a new type
>   KVM_SYSTEM_EVENT_TDX_FATAL_ERROR
> 
> 

