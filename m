Return-Path: <kvm+bounces-55203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE0BB2E47D
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 19:57:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 028AD5A32C9
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 17:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF78427B329;
	Wed, 20 Aug 2025 17:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GXFwmDnR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C53273803;
	Wed, 20 Aug 2025 17:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755712582; cv=fail; b=ckEOEl7lAOrLDZEPHakifS0q21b26x+2APEvD//HNccL0nYim0oMbMc5P7eWiFzNsPHdj3vbbMMHdVvL4IuIKolalqDjZbl1agH0mxHQhrBFnIbXjO0+ws6dpV0qt9V/OyvjKnDjJrTvcMb4evv9ukd7bp/5hh/JjLG16tb8BOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755712582; c=relaxed/simple;
	bh=s1tFgI/E8vTBMIbeFZiTCHGoN+1JIGcCI6x2JXWlJm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=K8jECGf0RLI43DqQQ7qFjpblbOIYGQLBn4WscBgPQyJV1qas7Lb0uDJZAGIi+33jnlPQYRVpon6dCX0E9L0LmMih5dgWHE2iPRlU1bE2q87L/kkY6FGxN5jMYUy0jVR5tgkyxrL/9nal+rUupDPrKpJIQSevPqCZXZBsipJB28Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GXFwmDnR; arc=fail smtp.client-ip=40.107.223.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y/e+sXhLgF2bIr9p2Zvx1o/LakywFUkbl+PUxMJH+N5muK4+5EwpDoDcXd/gHHwD9Ed2T11Qe0aa9TymEyA4M2QD1/H6SGt7A2n0gMKu0a6/zm0+qdlsqjPIoDxKIFS/cvCMEd7Mp3eptLNVDa+jwidsd1QSZPZUinvXIAGAZM12MXk4dWjqh4SYFV5sqqcsflL44+NqeblQX4AwCxJ3zT6KI+wHOc7Z7IsSQO+0nhhPtV6/nknclQ6zUOP1rL/wrJ8dprG39ODikiiS4onTzJIXuRUKxXldnHA9kMS0fBzIRktX0WJUKvhIY7gF46sJroOP/qOVpKmp5mTp0zQyhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Tn1xaztkJHrvOZARhcbFVzrS9/G2hvV3+cM5MAa7MY=;
 b=oItw+EtO8Q6lAl4SVWG89++gRTW0YpA7VltYyGjOjrNwN5PYzYfHHDlFuKSjnNQpzybKDMEDOYTdhr4XuVCysHznI/+LG5RTGjNXYsdtDADXSuOREIQ23hTkJEqK9nKRtFabVsv6iq0PJOoZL+JCVpdjPuySKFZlJ1cF9ETAKNpx1RkVMrZ+IBsZkbWlByutwEJ6ykYr14fqyliKJYFhVylJ6+dSZqm8WhJPfkGEcXIghCqTl+V8BWYRFoFHIAX8+38XaQ7hi6UlBiQ402/btZYZjFXIYxeZwoR6Xj5Hf2cYtwuqdrOQGO4f/CaNQsZ/BwABPWnXwokdzZyRbzdPcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Tn1xaztkJHrvOZARhcbFVzrS9/G2hvV3+cM5MAa7MY=;
 b=GXFwmDnRrd9ByZ3AHjii0IZbrURLNA4jGrYJyMYQiDumCkplwjl5NOsreuKifVQ1ITTRdk5EM5Jf+sTj30CD6nVV5OEwkTtVyjn2YnVJuFBog0ws/X7tpMd+1tVv9rrU2QoqN1tVtF8O6bDotqUq4ITPLmv9pRQ8H8Yqdj7I82A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB6373.namprd12.prod.outlook.com (2603:10b6:8:a4::7) by
 DM4PR12MB6446.namprd12.prod.outlook.com (2603:10b6:8:be::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.14; Wed, 20 Aug 2025 17:56:17 +0000
Received: from DM4PR12MB6373.namprd12.prod.outlook.com
 ([fe80::12f7:eff:380b:589f]) by DM4PR12MB6373.namprd12.prod.outlook.com
 ([fe80::12f7:eff:380b:589f%4]) with mapi id 15.20.9052.013; Wed, 20 Aug 2025
 17:56:16 +0000
Date: Wed, 20 Aug 2025 13:56:10 -0400
From: Yazen Ghannam <yazen.ghannam@amd.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Hunter, Adrian" <adrian.hunter@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
	H Peter Anvin <hpa@zytor.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Du, Fan" <fan.du@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
Message-ID: <20250820175610.GA936971@yaz-khff2.amd.com>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
 <20250819162436.137625-2-adrian.hunter@intel.com>
 <20250819172846.GA578379@yaz-khff2.amd.com>
 <aKS5ixhgtCYIvErL@agluck-desk3>
 <4b8b5c89-e8b7-4eec-91eb-1fe43a68cf9c@intel.com>
 <SJ1PR11MB60833C7AE2FA8D8200EA3645FC30A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <2b86c458-f63b-4f74-8fcd-1456ddad4d7a@intel.com>
 <SJ1PR11MB60831ED23234A274D3DCDD6FFC33A@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB60831ED23234A274D3DCDD6FFC33A@SJ1PR11MB6083.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0339.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::14) To DM4PR12MB6373.namprd12.prod.outlook.com
 (2603:10b6:8:a4::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB6373:EE_|DM4PR12MB6446:EE_
X-MS-Office365-Filtering-Correlation-Id: a1bdebda-6173-4533-123c-08dde012dc1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5fwWqCG+ktL7dwa0C0DNK41Mfk+UT6bvsK1WbOPigMvyXzEY1WISJuR+piml?=
 =?us-ascii?Q?pEAKqTdVcEisbQUFVQcs9+AHXIPRzMUToFWwGZtMnirtFCgcinQeDRPs2uhw?=
 =?us-ascii?Q?H4c0pDUFKGiO8rO/RWZMfVoj4D++4ipKZ4F168utQVDs55MaFdcU0kK1kFAr?=
 =?us-ascii?Q?MExVsFthyXJtOssOWOoLvEx2rOAOn6KrjZJ2fhpIfd3C2oheQqxezHdmRlUQ?=
 =?us-ascii?Q?JEFkw4rfr+0FqqaKAXhNYO0IfnG2LueoWlzvzZnw9JyvwpYWcLAO3NTR218a?=
 =?us-ascii?Q?AVbw8XL+gbEs4XpsVDm9V6MwZXBmxfrFbGwcOXVqKvraxO8AKJryWDL3wSNg?=
 =?us-ascii?Q?LWFggT06I+snUzP1I+RAdiHloJEfd5c8gALWWh5Jybw1rCz+5CQXCb8f5AYJ?=
 =?us-ascii?Q?cKtTC2vW/2eBYYLPidFp5FPASjTytIQH1DIrG3wPUTjOWLa2c6xXQ1+2WMCw?=
 =?us-ascii?Q?Smq+sXEC3n2wqc9ZYjP3nP+6T/OSxdabfvlg41o3nLRFUxV6rvUdiNh2/VXy?=
 =?us-ascii?Q?kHyH5kHd77ruqUambAwrtzMu+Hvtrzv/++ZqU2VdrYK9G6V8XRHXxUiSJwiR?=
 =?us-ascii?Q?jw3uwyzW+c/6UczW9kwd91AhZWVgHttKOQkb6opjVQQyrVrOZEO6aakWeghx?=
 =?us-ascii?Q?PNdTkWrcBpXWDeGtjN6+xn+WCQ+MrFuJxKsr3J52tt8+RguGeDps7kUCgIW3?=
 =?us-ascii?Q?xFH9HIZIs1wxHiw+SdDe/Yv7xji7qYUQF9Z7/KaVLWu1J2KrEqDLlHWT/hRR?=
 =?us-ascii?Q?JkzbdIQ0cj+olbkhCOVAVbMA7pbZpcMsS0TZrSmiSQT36Ax182BihTwbkb0P?=
 =?us-ascii?Q?OvYPgtZmwKzOXLFG+uPyRnobWSz+S2LqS8BicP2ESikUrdayuGQHiZ0w9bBW?=
 =?us-ascii?Q?erAhQWR9S1PMsORmfR9o2/x8BhZcEzUdNAyMXwZQ+P8eza8yY6ARkj1UxW5l?=
 =?us-ascii?Q?zqTKlQBge37lA+gdZHSnlu8p03r7SzP7pbdXCDWI9foXFreWV0Qau3Rmzelw?=
 =?us-ascii?Q?0+hsquAGijiOP0066MHkvop9R1KHmV931HgB1vHqztShQEjcN1P7LLAQFE6P?=
 =?us-ascii?Q?E2fN/R9/346D/s4SG3xSAJDdCeq1BduWrecs37MgfHQjuhZ16t56Nz9AoKIp?=
 =?us-ascii?Q?PJGU6bE2eKAhhrodHnN/w58u99i5Tu7oJBueT4B1n+FzCTqwrEBODooFSLVd?=
 =?us-ascii?Q?AGLOAW57E6C671vWhr9Dj7EbNn3R2MnGl+eX3EpS4j5EQqb4U15ZmmEGPlSN?=
 =?us-ascii?Q?3hckurdM7LmthDQtVX/9z2wYmwISUOkCNi5dAifzquu3QNDLo1+hk1+ZPLFT?=
 =?us-ascii?Q?ptge1d9T71Hv4+o6YulxVRy+bl98FmSAY7gFH/iMb2453FKIIxVuC6Z3o7hB?=
 =?us-ascii?Q?neI7/y+53Apzc1ELC8q/9UQsjgAXbaf+3l4t1qvjIVap97BXhRdoq3zX3Hxx?=
 =?us-ascii?Q?EqjVeKYql3o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0jUy+XddPHIvv2mN591XDcj59qpmqjE4atBA8MqsIegPmFjGotguZ8JbivHo?=
 =?us-ascii?Q?NmH/aJksX2cfA5DgXEe7N0t+lfbhXammgqdsr5C1KytiKvsZ/Y9QF8p6Jjgm?=
 =?us-ascii?Q?GqXvWw5urmfNtAzmL7rJLPvKRDTXiuTLl56y2Y3/isdABKM7nTuRsnw2kcz3?=
 =?us-ascii?Q?f+vMq4sKV6wC/TOb4mB2x7fFT2zQbV9MsZead46pnJwMzR0c8M/KdtdjPssD?=
 =?us-ascii?Q?UDjW8jq3DhEAheKzcfiE+6jnO3Y0S91JqppYP+1X1ykBeFt2QqvXP3ZtEpDQ?=
 =?us-ascii?Q?2THfy5oDhF55sfq6+V/X+TJyKeo0kINyMR/FE/UCo0mIcuOpm50bAO4B9akD?=
 =?us-ascii?Q?K3Pp6V5LX+yukg9XXPZJjqvGXMKNefgJzIGdYzIbEoUWUlt+EDGccUtr30qY?=
 =?us-ascii?Q?zzikgeNptNTnwbicSRbazmVPtesrAr1IJLjRNcyREdSDHroR9uys6ji5mQ96?=
 =?us-ascii?Q?r5tvQN2Pp87sRLlHzNy1iNFYF9rwDK6bI9Z8dN37ctMf/IICfwNZZrirJsKQ?=
 =?us-ascii?Q?NMXjbCgloX6NqA1QgV3jq8Vao9noRIjRPrK7wgM0rWBRPEFv1q+HvyNFOwR8?=
 =?us-ascii?Q?DR4u8sZEY7A/2YfPl+psh9E5aCpzKmR0yRl9rkvsr6bN5spYQuQL4uQcZ4s8?=
 =?us-ascii?Q?vV8KiaX3QNudCYYxPGqsLcfEhHWTQkvujRhV7u9gDgbOsIFwUMPnoJiK1FVj?=
 =?us-ascii?Q?r4z8MYQ7dFq6mtP222HbgzJT2QFyweczhi0qm5ibvFeT81kgsyepw/CqkNLm?=
 =?us-ascii?Q?YXJuaZefPZkfFL0HylxSCw6LbeSLvvkxIOMwxcom0to8ile1HjmeOmY/YBKU?=
 =?us-ascii?Q?mbqGCCFnpluYLSGUPAA2LEp7fDVaNQRs+x9ivx1xWYdB7nvnkZlo2SoxItcd?=
 =?us-ascii?Q?BFsaOB9VvLnVPcDtClf1N/rPN7LsceS9Udc0JRDTnF4LAcx+Nu70b93qteXc?=
 =?us-ascii?Q?UdvEoFVSXQjr20Oo8oN6qvxhp99b98335+hrRgBUJyvbCwnETn2zhyaEmEmD?=
 =?us-ascii?Q?hfGlfFE0eNAQXx+AF2//iihyi53yx9c7ZgzveqQUdnMgWskpCti2vFD+aIog?=
 =?us-ascii?Q?3u3Jy4eIpxrTuZ8kliLTY3CvpPsZGXboFP+idwaDllJzsH3YwBnFgNO9ju7n?=
 =?us-ascii?Q?thCXQcerck1ck4ihf66ozIN51zdaGyGnN9xmUsaIF6x8bNg3QBzOidSikM3v?=
 =?us-ascii?Q?sFeC7bd3xKlFADHWGcjcjOSPw5rywCGPjk/iqz+599HOxg39fHq8FYuW5L4M?=
 =?us-ascii?Q?y3bDKNQ5EAelqBV7DUlixNmVHk4FjBclXj9Z7QjQuoWjuwDBfcI5GqM/E2cI?=
 =?us-ascii?Q?mIBxkJgThfUNJBele6dOIWhdRPeBPZM36+oWOFSd9hQn5Nwny8F39L2os+PL?=
 =?us-ascii?Q?yuCAhkkENtcpXoMuOz7+twj8wHOUrhB3C6zwRBWOI7g1AWm1Jpt0DSLSij99?=
 =?us-ascii?Q?Dl9ENCP7kHjvbcYbwMN8bfvFS8sdrzZPnuiewEUdOOaSkgwqG2DhTyE5U8kn?=
 =?us-ascii?Q?I0jQ3lwzy/3yeFZMSzX8ljhgGsST6+oGnlMhs3kQXcHcRZC40ObQ1kcRwUtb?=
 =?us-ascii?Q?DFQ7aJRGToPYgyjtI/7QWGewMaoVhqZQiR40KNZo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1bdebda-6173-4533-123c-08dde012dc1d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB6373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 17:56:16.7404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dkzPnDUY0ZGgVQ6X/PLisosj3eleWXCUQJCplWXEOCILSGk1q99tnttVg2Lq7ZwvxQr8jb0XCzLwLVuczwKv5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6446

On Wed, Aug 20, 2025 at 04:12:28PM +0000, Luck, Tony wrote:
> > >> For struct mce?  Maybe that should be 2 new fields:
> > >>
> > >>    __u64 addr;             /* Deprecated */
> > >>    ...
> > >>    __u64 mci_addr;         /* Bank's MCi_ADDR MSR */
> > >>    __u64 phys_addr;        /* Physical address */
> > >
> > > Would "addr" keep the current (low bits masked, high bits preserved) value?
> >
> > Yeah, it wouldn't make much sense if phys_addr was the same as addr anyway.
> > Not really thinking
> 
> The other option (but a bad one) would be:
> 
>         __u64 deprecated;       /* was "addr" */
>         ...
>         __u64 mci_addr;         /* Bank's MCi_ADDR MSR */
>         __u64 phys_addr;        /* Physical address */
> 
> which would be good to force cleanup in the kernel, but bad for preserving
> ABI (since "struct mce" is visible to user space via /dev/mcelog).
> 

/dev/mcelog has been deprecated for a while.

Is the mcelog app still in active development? Could it be updated to
use trace events for MCE info?

You could also just fix up the address value in the mcelog notifier's
copy. I believe it has its own cache separate from the MCE genpool.

Thanks,
Yazen

