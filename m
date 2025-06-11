Return-Path: <kvm+bounces-48967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5D82AD4BB7
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 08:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB9CA167A0A
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 06:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F192E22B5AD;
	Wed, 11 Jun 2025 06:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IYi+FVWn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CAA22B8CE;
	Wed, 11 Jun 2025 06:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749623417; cv=fail; b=HWNJGD8v487GOIKI2HTqGlbXpiEbMAYhSgjKQgYv2Eskjnwm/L+f//+BRZJJbsh4obKAyiG8E8jT8jGhBzRcuOESvvQpTXxvQS3CVzvOQLGeWey48LGrD+ZFDMu6XdgXUGEWKwtJ8f53+SklWsTpd8Sxbm3TMuAz8ajJRNlWZdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749623417; c=relaxed/simple;
	bh=K2S089rMW+CBWRdoq4BZnZib+DKuSRHLKGm+0+31/ts=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=etdrO+33Z1Pvy764BqgmbSU3eEbuCz5tVfuD+dvFIDciAHNX+vcMkrnUgXWzw5Q4uvvB49Q4b6Ziuco1owWUl1INWVUMdXZx1YCAfW9TA7dVdZ9aRvVfiltyQn6jOEbH7U0W5j0TxhaZaotZ/QLof/fmNIjbEkVfQH8e1erJw70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IYi+FVWn; arc=fail smtp.client-ip=40.107.236.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G4pdslVhorS7YGaWdfRKuFQwJonHv0OGHOabhl5iniul/XoiiW7XYQzOlAJuNDjMJegf1Wa1HVoyclJnY8amAWCUc3+8/tv8cQG2PiwFwIhOlCPMbAZRhRACd0GC3YPBXNn7XGmw610FXQbIWb+3SaXHn0yvreaQRCGj5foGQMjemhHUfh0c0gBw8P6/vaD0z4upqjUEMO4Z6JqWVXKEy/5M+gHZSiL+3fsFO81LQAhEmoqVX3pxS+zBeBw+VaGooQmlq1ZN8EJ5Zm6M8rSHo0WTQ3540UHyG0qIGcoL7fWmqaRmjHDxJc/NaJeS6iCXDNsxcy41a9GfUv+vWTu3Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MqaOgz4etSF6pXNx8OmJk7r3mXcWLSh0xLAC/KwsU9I=;
 b=VUW9xq1Wd/tuXielWl9aZBL9wxvqGZHJFBGXo0j5cJB37ek1c2jKpRYKPx6Zd03Jsv+am/FzPpYjfc6Qzete9bJXkDKT4iuArP5Ik1ki2yago+vwcWrvfz39qgeSyfXthWZPlxULipTjhflmncN7ztO//95bCzU6mrnSJH+oMt+0ltT7oJ26HWNOyzbpJPJxEViVZ9muMWAzd8KfuKkDv9Qkb2jI3vQXWkHgUK5R+IZWcfx4qisc1pP/e6iVS+rrVoAHwv7/cpk689cbdkrI3YuK4MEtlDsZEJj2QseNIS5qMnYs9DF05/rb3s0znFKNPB+ZqZlu0GQQk3mDSdnt6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MqaOgz4etSF6pXNx8OmJk7r3mXcWLSh0xLAC/KwsU9I=;
 b=IYi+FVWnopWQ+hiO4/zuEU+bbj1rdPUSZ2MSk0DBroCjMogCMZLuRicP7qTLwrD+5Z2HOTK0F1ves/Lo+deBOUB0vUmvx5ciiwhz+uKqv/T0PQObig4d7Ce+KW475oE3g0HghxFnxJJL5oTHBwQ3ko0NppTCOhkY6VgjHcsgcC8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by SN7PR12MB8789.namprd12.prod.outlook.com (2603:10b6:806:34b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Wed, 11 Jun
 2025 06:30:10 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%5]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 06:30:09 +0000
Message-ID: <95fe5d24-560b-4c20-b988-6d7072ed2293@amd.com>
Date: Wed, 11 Jun 2025 11:59:19 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 08/18] KVM: guest_memfd: Allow host to map guest_memfd
 pages
To: David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-9-tabba@google.com>
 <ad4157a1-6e38-46df-ae24-76d036972fbc@redhat.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <ad4157a1-6e38-46df-ae24-76d036972fbc@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4PR01CA0067.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26c::6) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|SN7PR12MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e2dc140-a8f8-4852-66e5-08dda8b1693d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QmM0RERvRkhoMHpvUmt1andSaUNnVi9EMHNjc1o5Nm9YbVlGQkYrZWZLVXla?=
 =?utf-8?B?M1F0UGRpTlpET0YrblV2eGFJdDlwNlFmejYrY3pGNlZIbTBLNWRrK0JrcmVu?=
 =?utf-8?B?eWlQSmhLTE9ObFM0aW5XUVJCQ2Z3TDE1RmlIOEpaTWQvN3pXdWVxTlNMUDhK?=
 =?utf-8?B?b2IvOG5hRmZrRU0vUVl2MzNqYXJHZjNaZUJTaGtlOUh6TVBvanJGazNIZDFS?=
 =?utf-8?B?RG9EeWhNVnVlbi9oWXczYXEyU1FRMVp3dVZBM3dXQng2d3lUL1hCU3o4Zjkw?=
 =?utf-8?B?NmhZaGtidWQxdE56citLSFRGR0xubml0eHpNOXRFTEswQlJsdHVXVmVFNmwy?=
 =?utf-8?B?U1dpMWwza1BIemtGRGdWVG50bzZSOFpmblFIWkRhVWJEbmxDMHRId3ZVNUJi?=
 =?utf-8?B?MzlyQ21MWG5FcC9CNnlkTWQxSWJiMkRjbm9MRVEvc0lYajQvakJDalErMm1x?=
 =?utf-8?B?YWM0SDJQRTVpT2ZXak9CR0tKTksxUHdldWFURGVOMUEyZEVSdDNNK2kvaHBC?=
 =?utf-8?B?TWczNzV4ZDRVT1hkUFhWYmhQTXIwdlo3K3RySzBLbm5tNHV3TDF6aFpKMTRY?=
 =?utf-8?B?Mmd0Z3BmME5xT1FhSGFKU0MvT2FSek9ka1ZkMktZbWVzK2I2ZXl3azUzd0Fo?=
 =?utf-8?B?NHFFZWtqNU5MZzFVOXc0Ni93NzRSZnM1Q29SYU1JWUhpRm9mSU95L09WQm1C?=
 =?utf-8?B?enRjeHNMb09oczFOdVNyaXFXWS9zOFZqdTFDSjVIZWRlSmJ3aFpoc2xPZlNy?=
 =?utf-8?B?ZzNLbVIyOGJYbXRhbGhkeFJ2eG5lVE9pV0txSUZuaHEzdjYwSWJTVGZvVjk5?=
 =?utf-8?B?VUlZTHFUQlNEY0Q1emZiODRqMzhNVFZCb205K0MxMW9helVreHJ1OExiTmJ3?=
 =?utf-8?B?SjdDcHZ2R1hqUFpKQW9TUU5BN29tSjlRaHIrdTlYK3pORnZzaHcwWGZZa21y?=
 =?utf-8?B?SDI5L1hTdDRRbjNHRzZ6eWQ4TjB6ci9sSWtXVERnRVViSHJVQVIyNzVXOG5O?=
 =?utf-8?B?K2Y0WWVLOCsxNTcvWGxnUWV6L2c0anVKMWlEUjNaOWdXNkx5cUFZYWZVWmNk?=
 =?utf-8?B?SkR2TVE2NWVMaVMrZDFOR05rQTJKMm00QXJqdWxLeUlsMEZBUEQrbkZYeERF?=
 =?utf-8?B?NC9wWTNYWHdRN0xyVm5qK2JCbGppU05aVFlLakVBQnQwRm1TbnNzdHZXYkRl?=
 =?utf-8?B?WFNWNEkreFFCbFRQYUF6RVQ0Zjg0UDdQcGtsMnI4WFBUQ3dLcysxcUtXUGpR?=
 =?utf-8?B?eTFCWkNqeFVXL0twTzhkSE8zRFNxYnNHa1pUb1JTVFpIZlFWd2hhQmJIaWFw?=
 =?utf-8?B?Q2s2NC9HN0s2bXMvbG5KQlRxQVBON1g2aVlRbzNjSE5aYk80VWtHUkcrQW9F?=
 =?utf-8?B?aEZoSGFDQVhMYWw1VnlOcFQ3MFBIYmxES29CNnQyQXBxWXJZMFY0ek9Xcis1?=
 =?utf-8?B?eDk0ek54OGp4cEZHaVg4dDBEaWNsa3ZseFJUSzJSUzhJM0JKNEQ5TkNaS01z?=
 =?utf-8?B?c0Z4aE41MWRJdnhxOGRjT1N0VC9hZzNZd29xME5WSFNkc0lYNDYvTGxBNUpM?=
 =?utf-8?B?MFEzb2VUalZzTDJxbTB0QjJsRGxadENtWENNdkNWY0JVSk5HTE10TGRMaHM0?=
 =?utf-8?B?SDlIVUtDZm11c2pqTUpCQUdMRldxQUJTTy9Uc0hzT3p0RmtUbDhITW5xbTFV?=
 =?utf-8?B?Mnh5T0x6Znh6T0wyL1JiY1VnNkpIWEIxQ1VqOGprQlVIZ0FzOXJlSno5RUpi?=
 =?utf-8?B?VW9UMWo0VU8xNEJTMWZlSTV0cmoyeDNXWmtqd2cyTDhNbkdIakUrYWpiajlG?=
 =?utf-8?B?UkIxMTZGSUNGWHZucVAyWWFnVXROTWF2czZleS9JbTkwNHVzVFlZVlR5Z01X?=
 =?utf-8?B?QkQ4L1dtVFpEVyttZm1mMHNuTEkrOTlDNm01dzJLTVlJZjhEMEcrcDlJZHhl?=
 =?utf-8?Q?w+RalwGgSNU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aEhuZUpsd21KV3BiK1hZMHliSUwrYzFIOThseVJ3THJqNGM4cEV4QlpXTnJF?=
 =?utf-8?B?Z3ZYRjAySEVOR0NNV2lJUHBBYXE2ODNQK3FCQUw3d2FqZ2ZLM3ZpSDVJQzk5?=
 =?utf-8?B?NXlWRVpkTU5DQmNjK2hOemhVU0NyTTBTdDVVbXBiT2lwakNiR2NmMXdNZWNK?=
 =?utf-8?B?bE81dG1JRFNva3I2VzNldVV6eXZIa0ZDS1B6K09OSmhuRE5zR1U5M0NjWCtw?=
 =?utf-8?B?SEhGRDNhOCtzYVVYTnE2UU5mWXB3bGpqSEFMb2VwTmJnUlJnL2xoc3NFMEF0?=
 =?utf-8?B?TjlhTEtSVjZ3ekNRSlpzOGdHWjd4bUg0bjZCWG1WRitnWEhSQlM5TDRseWxB?=
 =?utf-8?B?azZ0MENPeE5HQ1BHQ2N6WXVhVVNIcExlcjc3U0xGOVY5R0hzWEhreE1VUHNu?=
 =?utf-8?B?R1RhWXBIb0tnTnAxMXZVTkJZeTdUNE80UnZZbER1OC9FajM2RXhGOFVHK1JJ?=
 =?utf-8?B?dTdWKys5M2NIOHJHTG1oQ2k4SVNmS1YwNFdiVWtwcHFjUDZiYXVseTdGNFRT?=
 =?utf-8?B?dWFpazR6eVFFeWp2YmFTR1JIcnZ6V1c5MzNwTi9KUW1zZVl4YXo5UkpNYmJS?=
 =?utf-8?B?MWkvODR0YkczcFNpRWUxRDNPVE05REJuWVdTbHNCZ241b2xldXhnNzcySEt3?=
 =?utf-8?B?VnVNc2c4K0VrYTJCd256YVRaSFFqOVhTS0N5dGIwTU5aU3hmelJpL2Jlc0x0?=
 =?utf-8?B?S2hhL0ZJbzNmL2NaajBFYUU1UFlKelFsR2c1QWNKc1BhRUdkaUhOZ2FOTUI1?=
 =?utf-8?B?MnRLZFIwRkV1a3dwaHVXWXpudDA0WDd1dktxWVpxQjdZbDBFWHBrNytkbjJM?=
 =?utf-8?B?aVVFMVozZ0FNcEoxREFUMUdSSkJ5QThDdlEzT204b3pkMDE2WEhvQVhJQU1i?=
 =?utf-8?B?ank5QUZvSUxya2k5Q1RMS0N5aXpZODdmM1djbUlnUlQ5ZVpQY2JuOU5ZaEZj?=
 =?utf-8?B?QzAwbGxUTjlEOXVvZjJEempTZ3ErM3JIQXIrRkRvVHZMQlFvUjB4bnZ3dUUx?=
 =?utf-8?B?b3hDWHBGK2RKVFQveGVOSWNsN0JwZlI2QzNSSE5EMFpuZWFWOXhraWJtMXdk?=
 =?utf-8?B?NXRROHNiVHJkajVzNk1idjVXWkZwQ0VZMXdOZE9nb2pWbmRyak0vbkcyamMr?=
 =?utf-8?B?VkJLdFhoQzIxVFhtUVVZL3cvVFFyZUVSZ3FEMEhNVXpURzNCSS9xWGZxWFRN?=
 =?utf-8?B?elFONHNlaVBYWkRVUk1lZXByMWtRaG83OXI0MjVLeDFaY0syeCtoSXkwQmg3?=
 =?utf-8?B?YW43VHVHZGlxMHB1ZmEzLzJjWUJrNEU4RDl4QzBWV2NBOHl6QzhLM2hLL2x6?=
 =?utf-8?B?Y0pPQktvUXJ4bVB6aENNSWc5NXJFU0RWLzRPWUFQMGM2b0pTZlJwc1NMU285?=
 =?utf-8?B?TW5UR25scmJBcEdWbGwxOHJkVHpBL3Nrd0t6eFhlQkZ3dWV1MlNadjVIajJR?=
 =?utf-8?B?SUUzNWdaYndNMDhKaGovVm9FZnF6aFRIczZKU3BRckRnWENrNHlOOW1VYUtV?=
 =?utf-8?B?am1udmk3N2I4djNHc3dJekMrMWE5ZEswWXZHU0l0OVYvL2M4ZFJGeTVHTDlh?=
 =?utf-8?B?TWZUKy9aTG8yME1jd0Q3OGFTNVJxenBhMFRjemtHUlg4UDNTN0F0WFJtd0Nu?=
 =?utf-8?B?d3JmWC9tRVI1YVhuaVFrdzV5ZVBHRVJ1a3RpVWlvTjBjcFRNYWhldEZEUEgz?=
 =?utf-8?B?NHFvUkc4VFAwSEw2aGVzVlRGU052S3dPM2o5SklxQ203TW9RbHpKcUlEcm9s?=
 =?utf-8?B?Y3BqRUErS1lJZU9FN0d3bnJwbjRwNHFCZk9YeVdnamlMaVl0Mkg4Z1NMUk1V?=
 =?utf-8?B?L1dwazE2RkhOcnNTcmVJamc5R3RJMGZwa1RGY25BQm15MS83WnNlRno2OSsv?=
 =?utf-8?B?YXBVcU1qVTJ2a2ROQzNaZEpmdVdpd3R2aXJkYlp6TU8xdVlJRTNGM3R5MWZZ?=
 =?utf-8?B?cTdnQWE2WEZpK3lNb2VqRzNZUDFTYTdoR012K0FYemIwa2NtT09wb2VJRVM3?=
 =?utf-8?B?TER5cEhPZjZLY1k4ZlhMUlZjQW16b0Rmd1oxVzlJdy9TMW96NDNVR1BPRlRu?=
 =?utf-8?B?MlhVQ0RKZysyMXoyNjNwemdDN0V6RzhNeEsxbVJoa3Bma0VzcFEyTTVnMVFp?=
 =?utf-8?Q?V6s7yogI5/JlQ7YEOTIovRssP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e2dc140-a8f8-4852-66e5-08dda8b1693d
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 06:30:09.6856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 67wWuLW/P1sarYdbfNJvMmMsT90HZlqa7pwASDzUep+enzLZwQ6Oq6ryFYc/YkfD0WG9n/DltV3+1oVWtas0Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8789



On 6/6/2025 2:42 PM, David Hildenbrand wrote:
> On 05.06.25 17:37, Fuad Tabba wrote:
>> This patch enables support for shared memory in guest_memfd, including
>> mapping that memory from host userspace.
>>
>> This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
>> and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
>> flag at creation time.
>>
>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>> ---
> 
> [...]
> 
>> +static bool kvm_gmem_supports_shared(struct inode *inode)
>> +{
>> +    u64 flags;
>> +
>> +    if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
>> +        return false;
>> +
>> +    flags = (u64)inode->i_private;
> 
> Can probably do above
> 
> const u64 flags = (u64)inode->i_private;
> 
>> +
>> +    return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
>> +}
>> +

I agree on using const will have some safety, clarity and optimization.
I did not understand why don't we directly check the flags like...

return (u64)inode->i_private & GUEST_MEMFD_FLAG_SUPPORT_SHARED;

...which is more concise.

Thanks,
Shivank



