Return-Path: <kvm+bounces-71885-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UJ3sNHJZn2lfagQAu9opvQ
	(envelope-from <kvm+bounces-71885-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 21:20:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id CCCAB19D204
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 21:20:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8ED11301C68A
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:19:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E912FFDE1;
	Wed, 25 Feb 2026 20:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5Hz3BCbO"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010008.outbound.protection.outlook.com [52.101.201.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752A0145348;
	Wed, 25 Feb 2026 20:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772050791; cv=fail; b=soXFFBLgqc/fZWw3U+E96YW5oSSMtmzro0t5C5a8UPGyNTj/RC5kkrvuBv5B50rMcda7gLV46E3JCtIhdVeflfihIpNsUnXVPIxpz008K4EyF87754sBNG/ottRUSReluZmC6LA9ImrA4gK6hgEB4OiGzuC95XAV6Ebnt7KMcw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772050791; c=relaxed/simple;
	bh=IXec71+XXzbFSRFmjKR5S5oz1Of91z/p6pbqOmfovpE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OsC5E3dg+zMkBmYGR1a+L+XxYXfqtKza46a5cHXpxGDnzzzRvvfVd9zoTkOiZeGU7igfvfcqP5XVTSdAdQwCpsfEdwqb1tW77SNb4UeTktUigYqQzPpch1v4D9D7cIU2vsO7sUMJZAUM2L9EL17XGYmLA3VWTyWprDkLDtyECHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5Hz3BCbO; arc=fail smtp.client-ip=52.101.201.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fzZrmhZpOgKVEWLgsPLe7GjpEibvMhmCZsZb1g83RJ2Qtb2KdV1QF1fMPBtuKl1gz4U1rDYo1mDEFwnw6YBAdL1coP7d1svS1JZczExpKiZ2ER+fNsTrby04h9PXWaFMRFzLqi86tE6z154cN8t1LDRcRDxEaLE2pDPbIazIhxZPoTSc5lAHUGfTcM2PwzQIHzw/a3TviAUb/Ak+j2IHrt8KgDyPgUNDcGNYQGDMyhB0SSJOvRlgvUZst7RaRs860phf7FdTGPBVQNSP41pWxUG4UIy6lWB1bQeX384DL8IOyMq0lNXpDZbqgyn9ciWZv3KRtzjPwCJ1HnFt6uVGpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4NN6PGJhZYyhJJ8zMFovVU0G0bpsnrQpAhar4xXZqRc=;
 b=x9BBbpjJ1lQZCeucXtxWKeBjqCjA2xOd1v1iuocx2vQdjmu+FjEEIC7Dz+3CgkH90hWuD9pJ14u9lypzJZPZvqdcuS9dNEocSFwQ2EJuk8QVkPv8qzI8HVTLj9cRKKazSgL6EJrqPwqBSvFoejqeUuuGIdgk7gt+PAJCKQC6WMPExNRdzkNoJym3TDSzwSuOlN6Jg/uDbwsyDDiLb2Jt9NgMSSeSqL8bM3aOMrC5UwC1E7Tz34XJKuIAmG7gculETp99+EIufnoGEFmJuKqjq5ValW77z7+VyyKhruxJ4uCg0pGDPUHCgcPFnTpj+GfLqPYpzqHxzMlrfebWm5rjnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4NN6PGJhZYyhJJ8zMFovVU0G0bpsnrQpAhar4xXZqRc=;
 b=5Hz3BCbOt73VJ/evfeI2ZkluzYJSWAo/YQgG/TX2XHw3PFhBW49c4ioh7VWZKeha533ILsfTaQEg/WqMsYJKIIv7yAiheg7ed44K+/7anVnYPNvyF93YvoaeOHsS6TPAd0gaVAjxKPcPFs57LDJDgWL2Uq1xvANimhwRJ94wZ98=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.22; Wed, 25 Feb 2026 20:19:46 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9654.007; Wed, 25 Feb 2026
 20:19:46 +0000
Message-ID: <3bf56d54-a459-48e4-b1c8-4b2630ec8714@amd.com>
Date: Wed, 25 Feb 2026 14:19:44 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/14] KVM: x86: Emulator MMIO fix and cleanups
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, Yashu Zhang <zhangjiaji1@huawei.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Michael Roth <michael.roth@amd.com>
References: <20260225012049.920665-1-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260225012049.920665-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0107.namprd13.prod.outlook.com
 (2603:10b6:806:24::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM3PR12MB9416:EE_
X-MS-Office365-Filtering-Correlation-Id: 86f116ca-c7f3-444a-a43c-08de74ab37d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	QEP/RAsPDaIHBeF1LYe/rJCMnylye7XMXTm2uy9+0scvmZD5neGjFJx38ZDvZ7HNFpwx9v1YWct94ZqfKaS1iLtd1F3MQKy2U5nuYnMvWvs0J7GqvPUup4LBOsi33Q3QsaAMkGVy+Hy7/cDjeRUBQ9n8Pt2Cr8JYuhOJ1RYPALc0xh3Jf9HMrGtBlg+luE8GMVBqKn31YtSic+uOtp6iEYIekdjxHECmyWLniu3bo/WQyqlFqGT26oS3CMlbN5fMeqBBCxRIXJe+HFnoFcOlNgh4f8ORE5CkWv3luUoTZnQzvEo89hW8Uh42beDMpD3e6Ixzx6TaOzHwlo7T4pD5KMItPsapvC3yZr8lqFSyPjP6GhPbxduy1HjDMFqVIECLiWuEA5fD4Ic7rVUC2P+i+MDYYrhrGZ2lqwAD9GhFRZo8cw4wFBGjLpkGOn/Trej+/BWPTg3WtyhgOFylrbMlroIW24Ph1YlMGUAbhLCEUoPveOcBvBHVi7kst90hu7hdtCEu4s53KhLuIaZTbxwWfZQN+RrCgsuzedReX5oygewZVAcLZiGNDg66JM40eZFec2mC0GafHS0w/f8L0VFEUAbrnXk9CnIr4ToGc51/GPd7EzDHGzk745MMAAZ5IO9Y9wcCoHSKPoyMm6Y0qUUd2GOQZ3SIFiQrEW7FRVeeYsf1Luw1188ovZqWhta2ugZTm2CzSsUd5kwjV6xvs5W5+iQZG47hmgBfTReCR6Z0U2I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFMyVTVmY1ZGdkgyUnF3aXdWTlQzTzNodVQwVG1RakkwZXg5b0Z5YlRDSVBC?=
 =?utf-8?B?RXlZeTZJVEk4ZExZL28yamhPemYzR0p4MVJZbDkyWTlqaTlwbGNxc1g0RWho?=
 =?utf-8?B?OFAzUldhNStxYm13bUVZY3IvcjZiVW9iS2hvWlJWTVQ4N0cxTVA2aFM0UVZU?=
 =?utf-8?B?TzFyR25WbXJWbXl6eHhzemlsWmI2RkJJeUphdVJyOHpVamVoU1Z4RUVVc05H?=
 =?utf-8?B?K3JiNWFVRjNreWVvZy9jQXBjYjJ3eVFuTlAxTkNHWXl6MlcrVmdrTUhUNGU0?=
 =?utf-8?B?RVAwbHV3Vzdja0pwVTJwSFNuUHN1ekxkVG1xZHJubS9nSkswMU1DeWE2NjBQ?=
 =?utf-8?B?anZxSkFCcW5jSTFxV2pSYnNMR2FqcjFTQ3dvWUVLOTJXUmduM2QzK0lIOUpF?=
 =?utf-8?B?dldlUHJrdThkallLSFNVWDdueitnamIwcnIwZDZReGdUYjMwVGRXa3YzMk5N?=
 =?utf-8?B?WDVMVDhtZ1NRS0FtRUlNQjBJSnNZdWpGNG83T2ovbTZmVE1tQjB1dEE4SE0x?=
 =?utf-8?B?N0tJUTZuM0tONWxGUmI0Q3o1YytsL0I3ejE5bVpiQzNjaTlyV1RMOGs1TXpY?=
 =?utf-8?B?TE95RVVxSHkxQjNiRmpLMGNuRnV4VVFsOVYrMFVRSllyVDdTMFBoWERlR3d4?=
 =?utf-8?B?UTlPaDExOTdqaWc2Sy9VcSs1ZE5nZytSUGF0cXo2YVozdFBDaC9qOEt1c3dz?=
 =?utf-8?B?eDUvYzZRVDl0ZTFKNm1rWU9aUDlTL0R3SVI5ZDQySTJ5ZjFZVDBXMy8vdW16?=
 =?utf-8?B?OStEcmkxblJBVDNpWHRJU2w1RDNBUU9mUCtJd1hFVitrRE5ZNHZxbDAzZmJo?=
 =?utf-8?B?cjFyQWZ2cHBNN2xaa0tsMTBUVHc4MzlCZCt3Y0gwZXVmMkdMN2FTZ0JnNDZt?=
 =?utf-8?B?ZXRod0R3UzVSMDhjWHhDRjhxSkRaL0g2ZTFueVloSytPTy96WTF2cUpWOThy?=
 =?utf-8?B?VS9GZ0JVOHhJdnJxY0Y0M2N4d2V2ekd5aDV3OEdBbVJoY3dHWndUcWxiQk54?=
 =?utf-8?B?SlMxQVJxN3IvRXcxdG40VlcvYnNhZytRbXNIL0xyeTVWWHpqUURLVlJyQlJ6?=
 =?utf-8?B?NUVMZ0dYNzQvY09jc1lFQVcrRkl2Q0pyUlc4b0R2RFNXMjZLVVNBendGLzVD?=
 =?utf-8?B?cjYrNzBPVHRiVEFwcnRFYnp1bXJCN3h1N3l4TWIzV1l2amwrVDZ3UVlKVXBW?=
 =?utf-8?B?Q0FjOUl4UmtydXgyTC9GaWZrUWlLVktkY1cvMjc5K0ZaZitSc1J6Ym9UU3Bz?=
 =?utf-8?B?SXVpeFo4QzVvNXVGbFNXeGtyNkZJbGpwVGZVNGx1ZkNvWHdxM3JkK1hPYmtX?=
 =?utf-8?B?OTQ0c1BiY1lVNW5BcTU3WHo5WVlnSHlhN2FjWCt2YWlYdTJhL2h5YU1yaHJN?=
 =?utf-8?B?S2wvTDN5RFpMTlNRMmdwaGt5bFBxWFo5dDd5UGh6MmVvSU1VUk9vN3IvcnNX?=
 =?utf-8?B?Q1M1RDNKME1DRVdyUnhFZ2hqUndQdWQ5WTltZk1rTHhhMEFZOUJ4dEIyOHE3?=
 =?utf-8?B?MFVrNnNZdnJzUFVDeW5YR203cnhObVhuNGxLMzZLenNxNGd0S1oySXlpc1c3?=
 =?utf-8?B?OVMwZTNCcmhlYWpmZ042VXV2QWhjOGtoekdvQVFYLzBJNU5VY09pQnFiZHpC?=
 =?utf-8?B?WGYxQlJ1bHgxRWZFVGs4R1ZCZFFsb2Z0dmt3R1ZyRzhqakN0akxBdUF5Yita?=
 =?utf-8?B?V21OVVpnZ3JXMUFPRzJMT2xGWWNvZlNFS0dzUFJMMTBlZmVxbk91ODJKQjJI?=
 =?utf-8?B?bXk1ZDd1ZWZzMDdOaUYvVk16OHpqcm04c21HOGZjZWpndys0MDhWK282aUt6?=
 =?utf-8?B?dTlyMTJhazJWbEJOaGkyaFhBdXlpbFUrRUhmV0JBc0RNdnNqazYzbytuaHgr?=
 =?utf-8?B?OUM1RlU0WTFBaEdhN0M0QU1yNWdyelR6c2lPREZNM09NdDI2SzJqL1BMTEdp?=
 =?utf-8?B?bzArN055K3BRWUJsZnR1ZE1WSXRxYXlSaktZMDhTKzFkTmFUdklhV1F1RzdS?=
 =?utf-8?B?alUzVk9oN2gvR1hKNzVkOGpvSGZib3VaYmlvbThPaU1xdU9UTG1kQllTcHB1?=
 =?utf-8?B?UndDMG9CL1hrUWJSeEFUK3MvSG0vMyt5ckg1SXd4OVh3VUY1NUNTdnNFYXBW?=
 =?utf-8?B?UElScktCZTRZMHVhcER6bFlYeU4yM2JpbFlvUFhCQW0yRklLY09pNDFjNDlo?=
 =?utf-8?B?czNuT2NtdWdnalNKd3NWWEJ3d200YkdlYkw2NEpRS0cvV3Rta0pQU0hpeFJK?=
 =?utf-8?B?NnJPblNBdUJiSWNpUHZNdDUyVFJGbi9UNk5McWRrczI4L2FBMFpNeGx2K1lM?=
 =?utf-8?Q?RbrSM7bHORlX8aDpDB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86f116ca-c7f3-444a-a43c-08de74ab37d8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 20:19:46.0211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uU4oj2oep/4LFaGzDqToJVohTqwQkTdAYctYcOZ1eKetlzerc5JLHJ6r57Z64IBX9JFcatVFvPFGYraCPwloQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9416
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71885-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CCCAB19D204
X-Rspamd-Action: no action

On 2/24/26 19:20, Sean Christopherson wrote:
> Fix a UAF stack bug where KVM references a stack pointer around an exit to
> userspace, and then clean up the related code to try to make it easier to
> maintain (not necessarily "easy", but "easier").
> 
> The SEV-ES and TDX changes are compile-tested only.
> 
> Sean Christopherson (14):
>   KVM: x86: Use scratch field in MMIO fragment to hold small write
>     values
>   KVM: x86: Open code handling of completed MMIO reads in
>     emulator_read_write()
>   KVM: x86: Trace unsatisfied MMIO reads on a per-page basis
>   KVM: x86: Use local MMIO fragment variable to clean up
>     emulator_read_write()
>   KVM: x86: Open code read vs. write userspace MMIO exits in
>     emulator_read_write()
>   KVM: x86: Move MMIO write tracing into vcpu_mmio_write()
>   KVM: x86: Harden SEV-ES MMIO against on-stack use-after-free
>   KVM: x86: Dedup kvm_sev_es_mmio_{read,write}()
>   KVM: x86: Consolidate SEV-ES MMIO emulation into a single public API
>   KVM: x86: Bury emulator read/write ops in
>     emulator_{read,write}_emulated()
>   KVM: x86: Fold emulator_write_phys() into write_emulate()
>   KVM: x86: Rename .read_write_emulate() to .read_write_guest()
>   KVM: x86: Don't panic the kernel if completing userspace I/O / MMIO
>     goes sideways
>   KVM: x86: Add helpers to prepare kvm_run for userspace MMIO exit
> 
>  arch/x86/include/asm/kvm_host.h |   3 -
>  arch/x86/kvm/emulate.c          |  13 ++
>  arch/x86/kvm/svm/sev.c          |  20 +--
>  arch/x86/kvm/vmx/tdx.c          |  14 +-
>  arch/x86/kvm/x86.c              | 287 ++++++++++++++------------------
>  arch/x86/kvm/x86.h              |  30 +++-
>  include/linux/kvm_host.h        |   3 +-
>  7 files changed, 178 insertions(+), 192 deletions(-)

A quick boot test was fine. I'm scheduling it to run through our CI to
see if anything pops up.

Thanks,
Tom

> 
> 
> base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49


