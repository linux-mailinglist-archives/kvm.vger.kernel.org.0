Return-Path: <kvm+bounces-17277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 322268C39C1
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 03:07:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC2822811DD
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 01:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC25AD23;
	Mon, 13 May 2024 01:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PSQsaDyp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B1911711;
	Mon, 13 May 2024 01:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715562432; cv=fail; b=Ds7Gfg0S0J2nokr7+MHI4auOdAGUwNpHurVHgBoid34o3NrkbKlubA7hg1VZE5l49C4sw9qWgTO8TWbG0Vvh9lzsjc2RWUxA5DtGV4EqndG1py6bIQLK+0spBewL8YpDElkWmNtyFpQYahW6fazqJO5aMbe/MYTg9AGYGPi23Ls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715562432; c=relaxed/simple;
	bh=1qvBmO3KT5xf3KJFFpamiorcQxoO4gX6NkDsn8fLbgA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hqk2+Td1Bz7LDIm3jUKB3kCKNr+1/tDx8blZrdXgLz7F9dbDlTD6NfKx5DGbH9ts0NdK5sZ5tGoALF82NnsVedoHwWhLWFModsXxXlBVXXlcac85JRim20VECoaE/JCwlgSJLa85/UYmC+IVNJNRl8iyR4MSsB+plthcgXxppOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PSQsaDyp; arc=fail smtp.client-ip=40.107.223.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DI7JiB4GnHM04wmTp58/Op3+GZtobBTanWXxOI9F216hA3Hl4oGKz3EzGr7BfGGCDrK8u1AkLQk4iPT23nOzIERELfBiyBlhsDd2z9qfPCszMtvcRxXg+s818Wr89XK/TCFMJqFSVfkwvlqfDYsJF5BtdeK4H2hvOo7hzfYTmneh0ob/iKs5mU8wdXK+tMxdqMiBXx/HAMXMF0v09WXqh8jcNY5zgBORlmyFQ502Eig+5JSmXitILUvUMmmRlehncE/iA3ox+01NbsK8ewahK0zQmgTIRRTERfmd0aM6qNycmksbaRgksA+Pi2r4yG8z2sGSF7h/uZBbIRN5FhjjmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8eubhru7Gmb87BwcCaJlDr4mDi4n5vzyTXzz7/6rB24=;
 b=FFAa6jk4oHODh1K3xpkfDrEDd6CEq4zCtm9XZwdxctRSdQvj0Tm2wqEiuOGJS9ISpBA6eiC49tVouaUo9j+Cc96IHpTsqHFwAPt07FGK9E+2MfSb060BcuTqMHJSNIqfkEHthsWiviyaBmTOx4K/Yuy/HMJwMryoXsuU8/whxD3xKb8PmmmudfpR8enBuhDr1jyv2Cl3RtBh/jyqJ0uxoq+NSqqZT48Oq1OXPh4CTK6wXMfuGW4SiDIUHpG+ReE06DimTI1ccqTXt+fKpF7hrt4sUjj1mDm7/mS/0qwrHTknHkCEDUnNELtiqMvxDQW6gJC5dqgpVNBXLqcAYWWiQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8eubhru7Gmb87BwcCaJlDr4mDi4n5vzyTXzz7/6rB24=;
 b=PSQsaDypgJNLs5MBDKzeEnDGJJNbeM8mlV+jv6xjkmS4sYkY6JfWHExfunShZTFaxLM9V3kf2i/QQK671Hg9txndRLiPW3Zt/EJx6iPyJqTGiHI9sz3AFjH60ZLycj5zuVKm3P/24iKFmyg6ZKLtLDNo8jrAM5N/fQcgalD5PQI=
Received: from DS7PR03CA0284.namprd03.prod.outlook.com (2603:10b6:5:3ad::19)
 by DS0PR12MB8786.namprd12.prod.outlook.com (2603:10b6:8:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 01:07:06 +0000
Received: from DS2PEPF00003443.namprd04.prod.outlook.com
 (2603:10b6:5:3ad:cafe::1e) by DS7PR03CA0284.outlook.office365.com
 (2603:10b6:5:3ad::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55 via Frontend
 Transport; Mon, 13 May 2024 01:07:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003443.mail.protection.outlook.com (10.167.17.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7587.21 via Frontend Transport; Mon, 13 May 2024 01:07:05 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 12 May
 2024 20:07:01 -0500
Date: Sun, 12 May 2024 20:06:45 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, <linux-coco@lists.linux.dev>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <vkuznets@redhat.com>, <pgonda@google.com>,
	<rientjes@google.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<alpergun@google.com>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <papaluri@amd.com>
Subject: Re: [PULL 00/19] KVM: Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <20240513010645.ewsorvs5g37yay4w@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
 <CABgObfZxeqfNB4tETpH4PqPTnTi0C4pGmCST73a5cTdRWLO9Yw@mail.gmail.com>
 <CABgObfZ=FcDdX=2kT-JZTq=5aYeEAkRQaS4A8Wew44ytQPCS7Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfZ=FcDdX=2kT-JZTq=5aYeEAkRQaS4A8Wew44ytQPCS7Q@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003443:EE_|DS0PR12MB8786:EE_
X-MS-Office365-Filtering-Correlation-Id: 68547c39-a7f4-40bc-4e9e-08dc72e901a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|1800799015|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z1p2ckRKcWsvZkU3bTRGNm94VU1tSXF5YTN6c1Y1QnhXY0RBbE11OXhNcyts?=
 =?utf-8?B?SHJUYWRuenlYNUtaUER4eFdwRVducSt5c0dDSUxEWkFBVDBoQUw1Tmk5eWZZ?=
 =?utf-8?B?dHQ5QmJOVzFITTU0UlFHTktLM3R6NDRkOHZLeXhDL1RxOEVaODNCQVNOeC9F?=
 =?utf-8?B?b3IvcWZnaC9zbnFzNlpUendGOWZEa1ZLcWZiK2JHeFpQbVM4cmI3RFBTZjZl?=
 =?utf-8?B?UldJeU1wendaSkpmZGNvMVV0QUFiMWJ2cmlLeEhJLzJhZEY4VTJCdGlCa05O?=
 =?utf-8?B?YnJQRzdKTU50dHlUR3FJQVAyODYyd01qSllSdGt3cTYvQ0kzeGJpUWg3KzBz?=
 =?utf-8?B?K2ZZcFQ1ajlqQ0s3V1ZtbktqNU5JdXFDODFja3B3cE5RY3JvYWxxdWE1d2th?=
 =?utf-8?B?R2w4V3NVWmQ2R2Z6eCsrU2Eya3ZGTU9lTlFlR2F6QlZtQUhlVk90UUJvTDA2?=
 =?utf-8?B?SWwzdWIxZFVwdmRWMUhsUkIybHJhdkxERTNXTXhzK2NWbngrOXh6ZUxkL3dT?=
 =?utf-8?B?VWV1SW9vRkRzcE9GdURSZ3FFUTFEVFdJTHZTbXhtd0lpV1gyUDJOSEFiQSth?=
 =?utf-8?B?WXFQVG9Ibks0b0ZlQzFCN1N0eWp5U2Q5Skp1TUtBejV6cWwzV3JYYTI4VzhH?=
 =?utf-8?B?ZVVjdzhXM2ticUtvcTRaSTVwcklRVjFuaUV2ZzZsZmNzMGZpTUZyOFBEeVN5?=
 =?utf-8?B?THlnNzFKb05BYTVFNkFOV1RSa0VDQ1E4a0xzQVYvWUFYeWxHcU01YzRxenBW?=
 =?utf-8?B?elY1ZEhIc3ZxeW1MYmJycU5wbGxHM1lTMFpUaFZYTHVmZzVLYmdqWk1naHl4?=
 =?utf-8?B?MExnT0lGZC84WS9CeWNkSmxoeUlIYit0M0R6VUlDdXRyRFhHaWFUWDJINVNF?=
 =?utf-8?B?UFVrZFE2UUlTUjJoZkUxayt3QW1maFpUV0FBaEpneUsweENCaHVpczVtSzVu?=
 =?utf-8?B?Q2JueHY2SUJneWE0ZTJKellETTBBcWI4SlFyd0Q5eERNRGgvUnJPczBVNVFX?=
 =?utf-8?B?MDFLWEFWclVDUXQ3QjYydmNOcnFRUTNCUCtrMjIwSzE5ODV5VHdPTTZSNlcy?=
 =?utf-8?B?RVhnbHl1THNtanNnQ00zamtRR2w0YUhGUVZxZXpKTUhkSUJKbllEb2RUc1Fk?=
 =?utf-8?B?eGJGRkpSQ0NIMkdKY29ITjJsZGhRRW9aTk5NQlJnSWQ4cU0ySndyeVVaNjlp?=
 =?utf-8?B?WGFTbXhaa3NwQ0kxMHhLU2wzbkU1V0Y5TGRtaXkraVZCZEFOaE53c0RMRVp0?=
 =?utf-8?B?bFhSVDFxWHFhMDZIVWZlN0ttZ1g1aExHQ250WEIvVkZUUVZFdUloUTlVME5R?=
 =?utf-8?B?VFJXWWw1VHoxbjhtVjZ6SXJOT0NZQWIrcEpHSGpmNm5QOUo5SitGcFRBeklR?=
 =?utf-8?B?T3BCMmxHM0xnTGxJSVdpUVdpNHhNOEJ6Z0E5cWNBRW55MFhJdU9yRjNEWkxa?=
 =?utf-8?B?T2lOdjR3cGJRd2FUck1jckp5MjI3cVhmeHVEREx0MVJtaGg3c0ttcWpRbXZF?=
 =?utf-8?B?dndNUkpYNXBnTGVlNjRCbkVsZS9FaHo4TmhZOWRxaUovNlhIQnNFTzRQYmht?=
 =?utf-8?B?YWdRRzExT2U5Z2xLcHlZRzVVZVBCRVNWR2RHeWZqSU5RMTRDQ3EwVWZUQTVL?=
 =?utf-8?B?dlI2SERQcjBFTlBGR0V0VTlSTFdpb1JyV2xSVXFiY1R5MEorTDVmM2diNXBD?=
 =?utf-8?B?bzlvY2p1ZmJDdHdzdktLNlFkbDdlQXdCemxKaXh1MnNTYVVBR3NQNFZRTEM5?=
 =?utf-8?B?YnovV3JlMFNETFRGY0tkRXNQdDNyN0xzSEk0UVY0ekVJVGhzVFhWU0RlWWlv?=
 =?utf-8?B?T1FsMEFQZnd0RUU2ZU9rb1JIdmxMbk9aeHlGbmNRVy9ENEtSOXpTSlhpbUdN?=
 =?utf-8?Q?d62KKM+no+7t1?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 01:07:05.9216
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68547c39-a7f4-40bc-4e9e-08dc72e901a0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003443.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8786

On Sun, May 12, 2024 at 10:17:06AM +0200, Paolo Bonzini wrote:
> On Sun, May 12, 2024 at 9:14 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On Fri, May 10, 2024 at 11:17 PM Michael Roth <michael.roth@amd.com> wrote:
> > >
> > > Hi Paolo,
> > >
> > > This pull request contains v15 of the KVM SNP support patchset[1] along
> > > with fixes and feedback from you and Sean regarding PSC request processing,
> > > fast_page_fault() handling for SNP/TDX, and avoiding uncessary
> > > PSMASH/zapping for KVM_EXIT_MEMORY_FAULT events. It's also been rebased
> > > on top of kvm/queue (commit 1451476151e0), and re-tested with/without
> > > 2MB gmem pages enabled.
> >
> > Pulled into kvm-coco-queue, thanks (and sorry for the sev_complete_psc
> > mess up - it seemed too good to be true that the PSC changes were all
> > fine...).

That issue was actually introduced from my end while applying the changes,
so I think your suggested changes did pretty much work as-written. :)

> 
> ... and there was a missing signoff in "KVM: SVM: Add module parameter
> to enable SEV-SNP" so I ended up not using the pull request. But it
> was still good to have it because it made it simpler to double check
> what you tested vs. what I applied.
> 
> Also I have already received the full set of pull requests for
> submaintainers, so I put it in kvm/next.  It's not impossible that it
> ends up in the 6.10 merge window, so I might as well give it a week or
> two in linux-next.

Makes sense; glad to hear it! I've re-tested the kvm/next version and
everything looks good. Will also get our CI configured to monitor kvm/next
as well.

Thanks,

Mike

> 
> Paolo
> 
> 
> Paolo
> 

