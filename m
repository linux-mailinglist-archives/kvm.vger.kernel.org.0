Return-Path: <kvm+bounces-48134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8357AC9C6D
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 21:08:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C908D9E0FF1
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 19:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAABF1A23B6;
	Sat, 31 May 2025 19:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fiOWwdvM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521932907;
	Sat, 31 May 2025 19:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748718482; cv=fail; b=NP95q35JRgPBCR+PJ7wqJzpY8nzop4rnQYCKUMyH/Z5szeFlkIjZEuGzAXiaofuL0ud4Qzv9NOtkmrU5bkosoHmr1euFjx6RX8dNfmIRKeAv9oGIroXnOvuAS1tWMCKOrPzZ2hdp4ES18SggInFolTEWP5qNvUnYJW7+cArOS/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748718482; c=relaxed/simple;
	bh=naAJX7JbwUgO6jTq3gR1leOud2+3vUTgjPAZoZ9x7RE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EGIXhFE6p6hXbJnwkqwVmp1PJknrd/orSM+lNUR1F1K22GTc+vkliVda0JTGSQ+Z9rbDGggyEQRREZT3Fe36BktsQ9kWCJvcSdQdFuV4uJ96pyNwsZ9bOpqMPTYM8VIBkgJ0YaZNYuIavy8nmCQn1wGNWRp37bepzEKLU1ekVPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fiOWwdvM; arc=fail smtp.client-ip=40.107.92.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ui0c6kzrD7jpXR4QIv3e+9gE77EWcQgV/59dRpoK4GUPcRPiFoIOEyzoj9Sk6NdBAbnIDOcDoF/8gHFTRv3+YwYIlcklq31Sps69EfyyahIkdBKgYbw+L3vyWRX1jnDcdu0w/cTrqZONXlQxCSx3b9zddWWq8BNqhq9k4L15EaBSidv9aDCX1Ea3qT6a+XYAOw25afsG0EU6THD3lDBdfoPM0bngQcCvhNVxgJZTiGG+/sRNQ0IBeUPqlgl/xDMrVaBaPNzA7yyyJtkO29KlEvYtopEOj8CQ84edowlzVf7R2KwizWgiQsn9KBxpDc+GSUx8diRQ03lfcvanSfxnrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8UyVPIhQjAS+GyRu1s22e8F1bSkBK91KyC/neWqs/o=;
 b=Iz+9i4sXCmLnTBurr+J/TLVtwfDD1eB61EDxJUwuVJ3+VXM4fy/J1Uy5ajhjnPWcxNIWJ+lBZncx2HMGix+znjNAFDQvzyTCsuW99B1xscpIfwJOzr/+kAAH4N+P1aomhQbhzBCqNSDIpVS9x9v7U1qQcHovU3VPUx1DOxd1I6lYNZItkeMqYzfL5XtGmsrbLEYMQdhgBuS+O6iQQEuMXdwEg2J2cfjsC+yPbI+YEsifNzrEbwCxNBQpfLXLfJZlwWKd2EBiOrfz4M0U7nsLFbKVzQZ3VEaioJFZGrMxnGzJI05rfcnbT9Sc5G5SKPVI3Z/kvsWEtkkivlbb/VDWdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8UyVPIhQjAS+GyRu1s22e8F1bSkBK91KyC/neWqs/o=;
 b=fiOWwdvMcqwQRiwJWENcSGpEbJF184lV5sfRwhdY4aKBT3VMv1e1rWvftl8bxffYBCuDvyyQyGeTFbR3y2ZvB0ST4uhOI9e4Ddu68cpUwf9L9YdGIo9C1nssQ/tyMSHLlVw578dHZqwVJIu/m1TOX4J8JU3OnV7n5NwWUFsOAH4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by PH0PR12MB5605.namprd12.prod.outlook.com (2603:10b6:510:129::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.36; Sat, 31 May
 2025 19:07:57 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%5]) with mapi id 15.20.8769.033; Sat, 31 May 2025
 19:07:57 +0000
Message-ID: <4bbf8369-beb5-4eb9-8663-afb62b448b08@amd.com>
Date: Sun, 1 Jun 2025 00:37:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 02/16] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
 CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250527180245.1413463-1-tabba@google.com>
 <20250527180245.1413463-3-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250527180245.1413463-3-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0167.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::11) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|PH0PR12MB5605:EE_
X-MS-Office365-Filtering-Correlation-Id: cd02dc02-bac2-45b5-5b8f-08dda07673f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SmZjMkQyOWYveEFjWTlVbzZlWmIxY29NMzNQRXhXbDNjek9KQjUwVGNQakl4?=
 =?utf-8?B?RFdSaUkwUGZxUXRpTFhCYWFQMDJOUTVWY1VkalZ6cy9CYmw2eTlTY2ZxUmZQ?=
 =?utf-8?B?RndxZUtQM0FVNXBSc0Nta1Y0VHFURnVNZ1lVZC95QVhBcmFrVkFncFFTZC9z?=
 =?utf-8?B?WmFvYkw0OFhpY0VyUjNpanIyRWtwQUJFblFma2NwdW00bjVMNTRqb1hKaWpV?=
 =?utf-8?B?enVzaDQ5dWhRNlI5c3MraU1zaStBNVV1U096bWtNRlBOUFRrTmQ1cTF2bnRk?=
 =?utf-8?B?UGs0cFZSUVpMVjVPSzFPVW1FK0JGRUllOWVwb2taWU5PSEVQdlcxVzVIOVhT?=
 =?utf-8?B?VFBPT21GNHZVSzFtanN0Qy9IcVJOWGpYQ3U5cjBhY0JvQTBCTW0yS3FUbFIr?=
 =?utf-8?B?TncrRzFUbDQrZUlsNHhuQ2dxalpaQkxkY3dVd0lQR0JLbjNCK2J5WnU2bGth?=
 =?utf-8?B?TCtkbFE5T09wNXlrTjFUVzhPS2I1K0d3TW9CVlRRb2hpOXdQQis1MWliQzJK?=
 =?utf-8?B?WVVNRkVpYXRFN0dCa3NuUHlObTJ5L1I4NGdiWHQ0VW1IRitFYWl0SVNkQXJy?=
 =?utf-8?B?NGhWT0lVQmdZWE9UODF1MlNLOUJxYzkwcHRIcTBsbmtKa0xCTE4wMUt6d1c0?=
 =?utf-8?B?TCtZM2Y0bVhIOXVob01GZGl1Qy9wOUxFeWZTZXdnK2pBZDlLY01tWjlMc01P?=
 =?utf-8?B?ZUJqZTBlYjVPSGplSE5sdStrcmJWTk54N1Q2bjZQc0FDc1gxYzhTZitUT1c3?=
 =?utf-8?B?YWtvY2ExdXh4dzdyMUhBcTBTaHNJZUV6SFBVanFBaDNjQndqRDg1dG5BWXFB?=
 =?utf-8?B?RUkvZk9tZUp6UGxGQnlZeitOcUZML0NjQU5seUROTk9PVEdwTXJXSUsxSXBv?=
 =?utf-8?B?L0JTYk9JU01QdE1tVUQ1d01XWHFPODNMVmJNbTlJVkpnR0FESktjVnZjUkVn?=
 =?utf-8?B?U2MvMVpsM1c0ME5nQjhXdXhoMHpnWWtwU2VxUkhVSkgxaDdXeG8zSHZYUGtY?=
 =?utf-8?B?eXpVTm01bFN4bnB5K0NxQ3luQkk5bFBOVUh0ZnVNNWxRMXdDbkFkOFVtbHIv?=
 =?utf-8?B?U3hCTi83d1N0ZkdaVUpSenJMN2ZLQnkxMmNwTWhPSGlNSzFaSWZPVDlYWTUz?=
 =?utf-8?B?eHgxeWM1QVNHRTBvKy9BT0RvUlJYU0Q3eHRFTmZITlBlWFRYOUYwUWJ6Z3k5?=
 =?utf-8?B?T09BS3NEWjN4VVZGM0c2OHdZUWROMEJENUpmVUNYWTZZV3YzNkd0cHhrSGJW?=
 =?utf-8?B?TFNpWjd1bE01VEEyRlgzUnp1M2xtZEZhM1VPQjBQd2p2NUI1TktHWHNxTkJS?=
 =?utf-8?B?WXNBYnRyMGtDbHNwRVlRVFA3KzB6R2dxQjZOcGZRdWVmeitlN0dWNUtHb2pm?=
 =?utf-8?B?a3FVcldBQzhaU25zUlV2RDdjUWQxSUVWcWN6NmRtdmZhcEhQdXBScXVWUytJ?=
 =?utf-8?B?K2llWnNFZmZnaVovb3VyYjdvU3lyaE84WnNCeitWeFBFOU5iTWRyVWxWWjJn?=
 =?utf-8?B?UlBlOXcrZnlWV1hhTUhrTU8yZVJ4Mi9DbUY5dUFUd25rWWZ4TE4xL3VOVVVv?=
 =?utf-8?B?Qy9jN0lzQitiOC9QaS9FZjV3bXBDMU9FK09mRHZsVlBsNHlmZ3BvbUVkQm85?=
 =?utf-8?B?Y2dtd0wvSkg4Y1ZaRStXK3hPNU1OMzBtenVIZ0x2RE0xODE0eFNLMi9DemU3?=
 =?utf-8?B?YVZncGtJVjZ4VHlpRFN0QlovZ0YyVFZKVzBIQkZ5UWcyelN2QzRNZG8zM25Q?=
 =?utf-8?B?ZzVyL1BCak5pQVNDWGVoZ0lZajlXUVlPaXNnemlEd0UwbzB1Q0J1aXhjRG9D?=
 =?utf-8?B?aDBjY2tGSStKOWt0WFUxTDRySXR6WVJEWlpVQjZ2LytMdCs2M04wQjVHczVi?=
 =?utf-8?B?QkNUUXJlMFgvY08vb1Nqc08yczR0L3gvZkdCdFIwSG1HbE91ZHZ2b1JXbWdD?=
 =?utf-8?Q?MttdW4PoTSA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V2hvSWRzVCszZWNqMWt5ekcwYUNQb1FzUHlYbmpLUVFGemkzRlJmdndVcWNq?=
 =?utf-8?B?M2FkcjVlV0JuT1hkMVU4bkxDbnVFcGNoSEJ0UW9LOHpaRU9rYXRJTTdBdzVl?=
 =?utf-8?B?dW4rK3dFeTNVeUNON2RURXZYMzhVTzVHRWoxT0NUT2o4TmM2WGZham5kenJI?=
 =?utf-8?B?amtGOUVVWnBEM0M0Y2oyK2xGckJTUUtCUWxWcTZta0lkdnJOSERoanNYN1Fn?=
 =?utf-8?B?ZEdzUzI4VEhneWJnYVM3MHZRbW5SUmxNODhCTEZwUXowRGZXb2lReGFYUk0r?=
 =?utf-8?B?S1FJc0IwZHFuS2p3bXprUG9sY0tFZjc0OU5WMFdHZnBxUGtxUmd4QUZ1eE5N?=
 =?utf-8?B?WWhVbFR3cjZlZFZYSDc3a2xRK3UxVlFaRElwZjdvZ0Nwbms0QWYzVnpKNllO?=
 =?utf-8?B?eE9VYzVCUm9RVVpiZzBtODBQekNNdGRTclNpVG1OZ0JxMHhKNHBtdWZtVVN1?=
 =?utf-8?B?RWtNeW5uUkVMYWcxUDZSempIYThyMXNDbXpnQnAwbkY3bFJCeFFuWXhLMnZV?=
 =?utf-8?B?MTdkYUFQTEpqcUNUS3VLS3VhWjF2QVpSMnlldEJnaXBDbDlEUklBd3BvZnJz?=
 =?utf-8?B?V0tocG9tTjA0NmtOaURTYUxSaFpRbTA1VG11RkFONFZ1OGpRNW1MVFFxOHVv?=
 =?utf-8?B?ODd3Vzh1VWliU2RuMklKSlRCOWhHRGJocmNQeE5XRTY3bXZnU2w3bmVCUEZ4?=
 =?utf-8?B?SHhiTEtJQnE2OHNuZ0hzYksrOUVROFllMlRVcmhYUkdDMW5iSXNiNWd6eDVj?=
 =?utf-8?B?NXFTTUplSVd0cGFEM294STY1RXhydVNwT3BWWUg2d3N1eGdhNmNMUHBSYnU1?=
 =?utf-8?B?Y3c1ZGNsVURXWXBYVytqbERraGJ3VzgrMWxHQWYrR2FhSlpUYXZkVC9PeXlP?=
 =?utf-8?B?alhvNWxTR09nUlVDdmNVZlg5Q2dUUVd3S2M3Vml0SENTb3lZakNrOE5mRmw0?=
 =?utf-8?B?cllnVEdGdGIyV2hNV2NvRTZzVXVjWWUzR0tuTllqWlRubnlkemp0RVVkWFhU?=
 =?utf-8?B?dk1xcGl4cEE2YWlzQnRWTENlNjJtYWwzRFZqSlFFSlhzMWQ2NjJIKzk1bmZx?=
 =?utf-8?B?SHdERUhqRkkvdDlwNm1pVzM3OVhLbWhJTjBKKzdhZ1NIcllzRnBIR0VlQnBm?=
 =?utf-8?B?NjV3bFFqR3ZqYU1ZcE83Q3NxZFFIenNkRzc2T3o5aUpGTFg1b1NFaTZkaXNJ?=
 =?utf-8?B?MjlTWjdJT2dmYTNTK1ZzbERhRFllekI0dlc0clpwWHBtN2VqUW85K2Y1V0lH?=
 =?utf-8?B?REhvK2FiSU44c0x2SzFMdW1BNVd5bmRsYXY5ZTg4RTdSU0N4TWpHNlV3aVVK?=
 =?utf-8?B?MGI4am9YM0NSOTMrbkt3VnlURnk4cjJ0dks5NUFteEZjVTVpUmRmektMZEdY?=
 =?utf-8?B?VENhQm8vQVpKbmlHcTJhdEtkME4xc1o1Y0RoeFRSWGQ0eEFOM29qSVlBRXFu?=
 =?utf-8?B?V3RjS3VPclo0dWtFMHZpWE1xb20yNm9QZlUrMnMybUtIeWJsVnlnSDdkQnkv?=
 =?utf-8?B?S2Vhd2ZvZTZ5amdjSlhGRGE3ZkR5Y2FvVXJVQSt1b2JDd1N2SVZ5T2EvRFNN?=
 =?utf-8?B?ZlUvaUs0V1hEdzJKMmRkdW1OZ2NCTVFVbnlDazEvWCtVYnE1VW1aUzNnb25s?=
 =?utf-8?B?Ym5iV1A0OGY3VUF5WlV1WUsyYm1WNkNBTERtRzZHK0FqdkQwd2MxS2o2dHlL?=
 =?utf-8?B?SGhUck5MRGh3L0M4TGlLR2Vja2ZURVZBbXAvUlRvRWJNV0NoSFBpa0Zialo2?=
 =?utf-8?B?a1lqTUZqMTZPaDZBR1dONEw3VThmMGtNSy9mWXJVZmgvNjJWMzJmeXUwd3hx?=
 =?utf-8?B?QW1QNXV3cVdEWGZ5eWpLTmNXWUJYT1B1dGNGTUFWR3BIRmc4LzczUFVGNzNC?=
 =?utf-8?B?NFhuSlBtaHdLTDN1R2o4WnVnYzAraGVHNXlCb3dXaW9Sa3VIaFFJNmlKNGpJ?=
 =?utf-8?B?K1BkMWlVWTFqM29GWWR1dmhMRXpOK0dHRUhwTTJpemFTLzJXaWFoSjhEelU1?=
 =?utf-8?B?RlZzWEppTlpvdjFUWFZwMG5tTUlqZVV6SjRGVjJEK0lWVEVUby92MmZqb2xM?=
 =?utf-8?B?akpsQ3N0SXNwbFY0dVdnNG5jNUk2aUZ1MEJIdk5ieUF0MXNuNGZwTUtHam9V?=
 =?utf-8?Q?67pqRerZ0utZP0q1sbCyeUiaI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd02dc02-bac2-45b5-5b8f-08dda07673f3
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2025 19:07:57.2216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: scvxKXQiCF/KWCvAkzKyyXWFdNWgXfyp0Vb+ob8cpzHjn7G4qsv1WL6Mn/LXgDaum0zCTQgT1fy+5GZvUMZp1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5605



On 5/27/2025 11:32 PM, Fuad Tabba wrote:
> The option KVM_GENERIC_PRIVATE_MEM enables populating a GPA range with
> guest data. Rename it to KVM_GENERIC_GMEM_POPULATE to make its purpose
> clearer.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/kvm/Kconfig     | 4 ++--
>  include/linux/kvm_host.h | 2 +-
>  virt/kvm/Kconfig         | 2 +-
>  virt/kvm/guest_memfd.c   | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index fe8ea8c097de..b37258253543 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -46,7 +46,7 @@ config KVM_X86
>  	select HAVE_KVM_PM_NOTIFIER if PM
>  	select KVM_GENERIC_HARDWARE_ENABLING
>  	select KVM_GENERIC_PRE_FAULT_MEMORY
> -	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
> +	select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
>  	select KVM_WERROR if WERROR
>  
>  config KVM
> @@ -145,7 +145,7 @@ config KVM_AMD_SEV
>  	depends on KVM_AMD && X86_64
>  	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>  	select ARCH_HAS_CC_PLATFORM
> -	select KVM_GENERIC_PRIVATE_MEM
> +	select KVM_GENERIC_GMEM_POPULATE
>  	select HAVE_KVM_ARCH_GMEM_PREPARE
>  	select HAVE_KVM_ARCH_GMEM_INVALIDATE
>  	help
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d6900995725d..7ca23837fa52 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2533,7 +2533,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>  int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
>  #endif
>  
> -#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
> +#ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
>  /**
>   * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
>   *
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 49df4e32bff7..559c93ad90be 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -116,7 +116,7 @@ config KVM_GMEM
>         select XARRAY_MULTI
>         bool
>  
> -config KVM_GENERIC_PRIVATE_MEM
> +config KVM_GENERIC_GMEM_POPULATE
>         select KVM_GENERIC_MEMORY_ATTRIBUTES
>         select KVM_GMEM
>         bool
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b2aa6bf24d3a..befea51bbc75 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -638,7 +638,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  }
>  EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
>  
> -#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
> +#ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
>  long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
>  		       kvm_gmem_populate_cb post_populate, void *opaque)
>  {

Reviewed-by: Shivank Garg <shivankg@amd.com>


