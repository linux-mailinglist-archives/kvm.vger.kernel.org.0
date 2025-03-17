Return-Path: <kvm+bounces-41235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FEF7A6550E
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:07:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D7CB3AA426
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 15:07:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADCC12459EF;
	Mon, 17 Mar 2025 15:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ly42wHkt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2089.outbound.protection.outlook.com [40.107.236.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28592143748
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 15:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742224041; cv=fail; b=kTwdwM0RAkhRoR2uA1gGP6KhrfPeBjeLR8H0J3HfQLtDwVFiQ12IqqK7KizgJhomRLXWLsxTTiys7NBA7i0UsmTLwUaHSFolayBL2Pl6ym413cAGCG0eG1I/KMSIBIjNBD5QUL3b8NRvOSL8ObflUhsjeyIbfuLmw5nIHW8HEE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742224041; c=relaxed/simple;
	bh=o/4l5G69t0kLRz4SP+bac00GYtWR5bB56AzjGezSdQ0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NQWZBz87xePg0MAN3nGda5gF+zUXNTvWAffQlpHN4hF1hiQ5q0xDZW32KQjaPar2Zy4pyKS//g3VhHd54MqEaEO4GTdgqToHuslzEgKoTIYn7psknUynpgMMI2zQ5TuonsCkEe9MZx+ren5LpTcM5HvV4aI/Si74bl67DJlVH/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ly42wHkt; arc=fail smtp.client-ip=40.107.236.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EI8vusCdsOnJgansSOkmenOVv3nT1DgxuQwcBTWGhBYthbdYAz8PXVTbzK0fpC+modHTfG0M99X0RIzByVvpZqUOIqfzYMcu7ReXmDqXVxt9Y1rP870bonconCuEe256U384geIrXx/P2sKbPU5cYBIRwAuYIimNWf5SbuDtbeC5ZZ05OqEPKRzXaSf+LChlbO+FdGase24V0S5N4+7LfSe3TroSpMtky3oanB3tPCXcwF/8ImOHfR8v2gThio0dCjzQJtnoZkjuTnzDaBskvIgAjdrQP8ecqgw14Yre2nvBh4pNq0k3hj7VOxTftZ0WAjAgRf1KZ73+pZ6CwGUWow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XuxLaLY1DlqZyLI0zE9IbkP3wbDDn5LeLsafdFoTYeo=;
 b=U9cv6MAzcEIrAvGtCHtKKNd++3Yfr7R2N9hotnjyZdijT8ngTZqH1WHihhkzFRsgE/0ie+7fFFhN35Pg19lzMf5yTUOqETXp0IMU8QcNtqlni5YOSKmSnTJBVmOU0V2jjEABoZZUfILXbnTrShnU6OkPDQmxcTnAkE57VQrou4b22Q23YpqKIiIFA6453AJ927HsGdGMu6m8vtfPVWd4KWA9sPAYa0SPmal2dHmlHfCsSVTWz2c/viRjT3NM93fxW03gvI2YKPAI1TH1Le2FqkUmBUGZbjCdll4kFOjVZ7y/RIUQLJDLmxjIzqwigvoh0QSihJAXeegGVvv1SCtMEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XuxLaLY1DlqZyLI0zE9IbkP3wbDDn5LeLsafdFoTYeo=;
 b=ly42wHktJ1vpiYDFRsFd/WBzPacSzyE0ypB5sBjmxX66Q3Mbe/WVyeMCu21ETABgM1Lsd8BT2jxlVw0hKPYpn6FpkQOP48FfI/ucDdX+UXNu/GcqjOhgkNSYRVEuSRuC+MsSHki9WLWZX+gBadOpc4e+BcFkdlwe8ZJPUBfg25M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB5595.namprd12.prod.outlook.com (2603:10b6:510:135::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 15:07:16 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 15:07:15 +0000
Message-ID: <8b312f7d-428a-aeab-cf26-412f8d8270e6@amd.com>
Date: Mon, 17 Mar 2025 10:07:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 0/4] Enable Secure TSC for SEV-SNP
To: Vaishali Thakkar <vaishali.thakkar@suse.com>,
 Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com, pbonzini@redhat.com,
 kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250317052308.498244-1-nikunj@amd.com>
 <fd404afa-7a42-4fa9-8652-519649482d75@suse.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <fd404afa-7a42-4fa9-8652-519649482d75@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0032.namprd13.prod.outlook.com
 (2603:10b6:806:22::7) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB5595:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e98fa5a-6e4b-411b-8119-08dd65656719
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?djRWZDJxUld6L1M5NjU2QkhtS3RISHE2cGkycng5YUg4SXBVL0hWM1htR0FO?=
 =?utf-8?B?RzFmUmpFUUxTR1ZQZ2lEdlV2TmVhQy9ydzB2aTJNTmJiVlh1Qkxuc0dYbXU2?=
 =?utf-8?B?MnZlclRESEszK1luNnB3MWczSmptejl5dHdITTRsMGVOWmJMVUdnNTNHV0l5?=
 =?utf-8?B?K3ZHRWswY3hYRzN2MWpoMCt5NzJXb3BDWVVOWlVYenQ5WkFZWHVrMEZWa3g2?=
 =?utf-8?B?TGZvbHFpNzh3UU80aEE5Z0xHRlMySy9sd0hFT3hGT0dEUHQvSEc2ZzlyMzRT?=
 =?utf-8?B?MlNPZ1F0eEp5MTJ4TFMzR0RzVDkvZ3FPQlZtdWNla0FSYXJrY0c0TWxPZmRX?=
 =?utf-8?B?L1RBcytybFV4T2xzazA1SHRGd1VrR1h6UkZVYkg1Vlp3ZnpheEVVTFBqWDM0?=
 =?utf-8?B?MVVrMHRKSW94ejFiNFhGUzBoTlYwaVRKM0tPbldYRHRTREQrQ3JnY1QrRTRG?=
 =?utf-8?B?ZkhhWWFtNU1WbzdIZFBSQ1BNbWUrS1dmL0l4TTByZmtrL0pMNnBnNzJxMWI1?=
 =?utf-8?B?WTVqN0c5N0dRN1NXM0JSM2N0dGd1NEJjZ281d011dmRMbU5MZFR4NVNPQTdv?=
 =?utf-8?B?ckhNR3VXYUdPZVFoczVDaDZSb002S2tsemFIYk9wRE9ldkk0cVdpM1BnQUJT?=
 =?utf-8?B?TVBzejJBMWxvK1lPZDJGeHZNZXVTalpSMVhSM0p6QVZkUE5WTC9qdkh1VzBK?=
 =?utf-8?B?aEVhV3hRZ0FBOWJIaithdzZnb20vNHRUTnByd2RqNEFUQWhnVkZ6SkppeFo3?=
 =?utf-8?B?Zy9EZHdENGdXTHJBRy9WWWNoT3JCZXFHekhNRk8rYUVNZjNlWmpub050aUd3?=
 =?utf-8?B?TXBlYlNoRXhYMnZmSU8zemZkT3FJV0Zzci9US0QxbnppNXlKa3lOYVVxY05O?=
 =?utf-8?B?dkZFOWRyeldNejUxdEJOSmpDL29BTm5TTHJhVG9xUml2bURZR2VhalNlSk9M?=
 =?utf-8?B?SWVQNTBTeUVyZG9oaXRUVmR0amNrRE5KeTUwZ0NrOFFTMUtkeGRYdElRQ2x3?=
 =?utf-8?B?UzNkUGc1dG10ZTBGUlJxZGZKWmZtT0RIKzFERjFWSDFGZXRWUm1XY3pMSmhv?=
 =?utf-8?B?Y09ZUjlaNTJTbU9BUlNnM1ZWamdDV0tEZEw4WG5RUmZ2ZXNTWnZYU2JqTHBk?=
 =?utf-8?B?NjJiSit3cm90Q2I3SGxtdmZta2s2blRSYzBKVDZiU203Y2J3d3RiTDZvZGY3?=
 =?utf-8?B?bXZXSVU0a2FwZmFIblZsazhUZW5tTE43WGFFc1dYK0IyK3BYSC94NjV2b0hp?=
 =?utf-8?B?TFpiOGdaSGs5TFpXbDVHZzlKNC9RNTBvWWs2TUtXY3EvOU9rK3ltb2RkZm5m?=
 =?utf-8?B?VmN0MGIwTWtTM2UrNHFrUXkzd005MUlGZEhSQXVxbkMwQ01DenJXejZqVmtX?=
 =?utf-8?B?MkZGaDFQdlNmaXhHODc3ZUJENWhwdjBOcjUyYmV4dnFjUlViNURWU25sdlFT?=
 =?utf-8?B?dk9USkJGK0ZNNWhEVEpkbzN6QjRwNHJmcFdPdHAycEdOMVFmL3VqNW1VeDRk?=
 =?utf-8?B?bHNtaWlVUlFCZ2kxczdwRXRON1NubzV5aWQ0WVV0OWx3OXpGVXkrdjA0WlF3?=
 =?utf-8?B?WVVyYU5nY2dzQStscTV0aUVFNHpIZWswUHFSOGIwc0VVQ3BVZk44cUM1MmdN?=
 =?utf-8?B?eldKa3A5UDNOeWpTZ2pFQTJtUldLMXYxUVgyRnF0L3hYRFRjNXY4TzRoeERt?=
 =?utf-8?B?OERqSTZCUkdUazVzQ0hxcG1SbG1Zc0l1bXVPKzRTZkxNL3I5MUJ6cldWTVFB?=
 =?utf-8?B?VVNISGcyRFZWdENDeVlBc2dRd1ZYWE9vWlpMZDhIaThKSGlkbVQ0dTE3Z3lx?=
 =?utf-8?B?Q0VRdXpQblRmTmZzWGhpakdNNExiSGxkNk5EcXpPekMrUk1SM0kxdE16aGRV?=
 =?utf-8?B?YUI4cU1DV2FBYlNXMm9OVkY4TFlPbExJRENhQ1djTVI3Wmc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1RqWUpXdndmSjJ2QUxlbWNmQUFnbnI4dC9jaGhINEQ2eVE3NHB5ZDF1R0N1?=
 =?utf-8?B?a2krQlNxZTBiMWhZMG9SNUswUlV5QUVpVUtqdlNJTndRR2p4UlltYVdJaUR5?=
 =?utf-8?B?SVZjN0lnSlhraDR6TU1mU0N2MDhlU0VQTDJBSVk5aXZPeW1hd1AzQW1EdHF2?=
 =?utf-8?B?cHlxckZlek5pbFl5OXUrNHFrWEdkdnNsOUlDckplQ0RNc1UzcnlsK21JWlhN?=
 =?utf-8?B?TUFwc1E2OW9Vc1I5cllHcUxxeGpyZ3NSKzBJLzVYU0RwSitxZjQ1UlQ5cVpT?=
 =?utf-8?B?QStlc3o1NFRiOHdKQnZXOThJSE5ocDY1OEdxY3hkd1hDUGkwVGRJeWkwdVEz?=
 =?utf-8?B?VVJCTVYvZGI2RlJoYWtmd0hZajJ1Q3hTWWUwOU9DWFQvQXpMN1RMcEE3M3Rk?=
 =?utf-8?B?R2ZPLzBDRWVjSVltRm1oSEtKc0RzWlZnVGNPNzlmOG9HVDkzS1J0ZzFlelRm?=
 =?utf-8?B?WEhjdnNzSWVwM3ovTVBmbkVFUWV2UkQ4M0tJMEN4YkljR3J0bWtVTjFub2VK?=
 =?utf-8?B?N2ZNb283U0tXaHRkeWdQZW5IOGN6NWFJUHNCbGx5ZGdKcjZuZE1LTEV1UXdM?=
 =?utf-8?B?aWdqUFFsY1ZLbThRb0ppUDZZbHl6eDlyaUFYVGcvM1hCUWF6NjlqdEwxUDdF?=
 =?utf-8?B?NVFpTDEyN1ovMGljUjAvYzgzQ0VrcDBUZVJmTHR4TW9ldExjNk1BbnhWZGVL?=
 =?utf-8?B?MWxhTEdxTXpaa1BLa2FQTlRXdFVvdldsVlIwczVOUE1SNjNKTHlhaTcyTmJN?=
 =?utf-8?B?Q1A2TmVkcEQ2Q3h1bDh4dFZjWHRsR2xRQ2hydzlBN2ZWWEhGYnI5dklFbm5X?=
 =?utf-8?B?eHREN1dsdUFadXZNWXhPZ05rc3cvQ25KL3VlMWdBVFdlMm0vK1VZTkhiU1BF?=
 =?utf-8?B?RWJtQmNNOTM3a3MxUWVlWEF3djZEUDlteHBzTE1QckZWM2t0a2VsYnZFOHVr?=
 =?utf-8?B?VGs3enZRL0EwUUc0UXd2L2IrQTZZT2xxMTA4S2w2MWxZUXFuTVYrRy9wY2F0?=
 =?utf-8?B?NHQzZEw3ZWpEMVJXR00zdFRDUUIyRSsrbWw4WTRwYWlacmVuZWVRM2thbWZl?=
 =?utf-8?B?cXVjcTJNMk9aSmpmQjF3Y3Z2cEY1MVJYa09GME43cjdTVVpvWVFvSE85S1A4?=
 =?utf-8?B?aHE3MkFZelRpd2FvaTNlaW1ZRWt2UzYzdmdCTGVtSUdNOURmRjZGTDh5Uzk4?=
 =?utf-8?B?ZU9WRXhBREFYbVd6WmxUSDJmb2c2aDRvZ3JWbERmVlBXQXN2ZU1pd2puRWZn?=
 =?utf-8?B?WHo4aFovOGpzSmw2bVhhQUloVkd2TGpCMUIrZzlKeWkyWEppZk9RMm9HQlVR?=
 =?utf-8?B?cmJHS3dWckRhcHFSbDg1Wll3alBlaW9IRUlLUDhIeFZlVjBIYU5SQzNmb3NN?=
 =?utf-8?B?NDh5dUVweGd5OU5mRnh6ZTRvRlhYKytsRU5lL1UvYVdqeWZpemozRWlJRVBU?=
 =?utf-8?B?bWh4eFNOOXBjOU1sbGRxM1JlSDAwS1hMcEVuN1VIZ2pXdTJqV2NKZG11U3hU?=
 =?utf-8?B?bnQxRjZzSHk0c3BvbEhURXJ5Nzh6KytBRk56cmdnQzFhclFnZjhRODAzS3FJ?=
 =?utf-8?B?L3lDV2l2NkRKTHFka0FCRXp5cFllM0E2aU40cjZxUDZuY2JkNEc1eWp1VnBw?=
 =?utf-8?B?UjBUTkUvL3BqZTVWV0RQMitEd0hUSWhrKzhnN3RHOEtnaTJoUnFuODFFa3Qr?=
 =?utf-8?B?ekpGTStmNG4rM09kc0tuWjlDZ0pvY1VmMGYzWTV0TFRFditWK0lNT2hjd2pX?=
 =?utf-8?B?MlJsbVBVTEFpRWdGbVhCYmp2VlVtL1NmUzB3UWdPK3lHbXlPMUYvdFNTbEM0?=
 =?utf-8?B?QXk4cmhZSmxwcmF1VU42c0xQSVBrcnVFc0lLQU15OFQ0RlQ2d0hmVlZxdHFy?=
 =?utf-8?B?Wm9wUitLemI0K0J3ZnRzNjltbm95QUU1ZlloRzFjQWNwS2JZTWxBcFRFYWZE?=
 =?utf-8?B?VXVJa3kwT3czWjZVZFVmdmUwdXpMVWU0T0VqYmM0bU5oTkg1ZDFJRi8xdi9Q?=
 =?utf-8?B?eUx1aHZZVFkrWEMxT2RXWGQ4Y3N6VlhKL29nTlZMbkcyS3dtaTJReWtUYlpX?=
 =?utf-8?B?ekUrdTZIbHExMEl4eml6QWxBQXNIWjErRUdTTStYU2RNVG93dmhEVWp0SlFh?=
 =?utf-8?Q?7xRbceXkC3LgQQZ9FWMRfoOzY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e98fa5a-6e4b-411b-8119-08dd65656719
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 15:07:15.4315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IhQSvVK+ZPOfqGonOX6f3fgYel2tdQkzBHEZ42ouiJVZ9fL9Lh2H2/UA7NOwvICTwv7oRJaxJ78D4+FXdRYefw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5595

On 3/17/25 07:52, Vaishali Thakkar wrote:
> On 3/17/25 6:23 AM, Nikunj A Dadhania wrote:
>> The hypervisor controls TSC value calculations for the guest. A malicious
>> hypervisor can prevent the guest from progressing. The Secure TSC
>> feature for
>> SEV-SNP allows guests to securely use the RDTSC and RDTSCP
>> instructions. This
>> ensures the guest has a consistent view of time and prevents a malicious
>> hypervisor from manipulating time, such as making it appear to move
>> backward or
>> advance too quickly. For more details, refer to the "Secure Nested Paging
>> (SEV-SNP)" section, subsection "Secure TSC" in APM Volume 2.
>>
>> This patch set is also available at:
>>
>>    https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest
>>
>> and is based on kvm/queue
>>
>> Testing Secure TSC
>> -----------------
>>
>> Secure TSC guest patches are available as part of v6.14-rc1.
>>
>> QEMU changes:
>> https://github.com/nikunjad/qemu/tree/snp-securetsc-latest
>>
>> QEMU command line SEV-SNP with Secure TSC:
>>
>>    qemu-system-x86_64 -cpu EPYC-Milan-v2 -smp 4 \
>>      -object
>> memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
>>      -object
>> sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on,stsc-freq=2000000000 \
>>      -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
>>      ...
>>
> 
> Hi Nikunj,
> 
> I've been trying to test this patchset with the above QEMU command line
> and with the OVMF built from upstream master. But I'm encountering
> following errors:
> 
> " !!!!!!!!  Image Section Alignment(0x40) does not match Required Alignment
> (0x1000)  !!!!!!!!
> ProtectUefiImage failed to create image properties record "

I bisected EDK2/OVMF and found that the above messages started appearing
with commit 37f63deeefa8 ("MdeModulePkg: MemoryProtection: Use
ImageRecordPropertiesLib")

It doesn't appear to cause any issues while booting as I'm able to
progress to the grub menu and boot the OS. Is it failing for you?

Thanks,
Tom

> 
> I briefly looked at this[1] branch as well but it appears to be no longer
> actively maintained as I ran into some build errors which are fixed in
> upstream.
> 
> The build command I'm using to build the OVMF is as follows:
> build -a X64 -b DEBUG -t GCC5 -D DEBUG_VERBOSE -p OvmfPkg/OvmfPkgX64.dsc
> 
> So, I was wondering if you've some extra patches on top of upstream OVMF
> to test SecureTSC or are there any modifications required in my build
> command?
> 
> Thank you!
> 
> 
> [1] https://github.com/AMDESE/ovmf/tree/snp-latest
> 
>> Changelog:
>> ----------
>> v5:
>> * Rebased on top of kvm/queue that includes protected TSC patches
>>   
>> https://lore.kernel.org/kvm/20250314183422.2990277-1-pbonzini@redhat.com/
>> * Dropped patch 4/5 as it is not required after protected TSC patches
>> * Set guest_tsc_protected when Secure TSC is enabled (Paolo)
>> * Collect Reviewed-by from Tom
>> * Base the desired_tsc_freq on KVM's ABI (Sean)
>>
>> v4: https://lore.kernel.org/kvm/20250310063938.13790-1-nikunj@amd.com/
>> * Rebased on top of latest kvm-x86/next
>> * Collect Reviewed-by from Tom
>> * Use "KVM: SVM" instead of "crypto: ccp" (Tom)
>> * Clear the intercept in sev_es_init_vmcb() (Tom)
>> * Differentiate between guest and host MSR_IA32_TSC writes (Tom)
>>
>> Ketan Chaturvedi (1):
>>    KVM: SVM: Enable Secure TSC for SNP guests
>>
>> Nikunj A Dadhania (3):
>>    x86/cpufeatures: Add SNP Secure TSC
>>    KVM: SVM: Add missing member in SNP_LAUNCH_START command structure
>>    KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC enabled guests
>>
>>   arch/x86/include/asm/cpufeatures.h |  1 +
>>   arch/x86/include/asm/svm.h         |  1 +
>>   arch/x86/include/uapi/asm/kvm.h    |  3 ++-
>>   arch/x86/kvm/svm/sev.c             | 17 +++++++++++++++++
>>   arch/x86/kvm/svm/svm.c             |  1 +
>>   arch/x86/kvm/svm/svm.h             | 11 ++++++++++-
>>   include/linux/psp-sev.h            |  2 ++
>>   7 files changed, 34 insertions(+), 2 deletions(-)
>>
>>
>> base-commit: 9f443c33263385cbb8565ab58db3f7983e769bed
> 

