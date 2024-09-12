Return-Path: <kvm+bounces-26772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18EFF9773E9
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 23:54:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE743281CD1
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 21:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CFD51C2438;
	Thu, 12 Sep 2024 21:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eBfZpUb+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2052.outbound.protection.outlook.com [40.107.212.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5205E1C2424;
	Thu, 12 Sep 2024 21:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726178053; cv=fail; b=Umx6M1pdxwIkVBKPKHZPUuK1W3IoYZYFU6qX1stJ3h6tE6uxJPoWiqaxIDyLtHQJat5RaigTUtCWXA7uVzpEmXn0zm83JVGF0n6tTC0iiR1Tu5OQfmGRH06hgVuRa1gUT6xFq953TvXzQ1jUmBjCNvnw5meH4VkzqG6H1kGErh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726178053; c=relaxed/simple;
	bh=yjE3RU50vyj0kebmKn57Sm33n2P2Np5EOrBO1VGyoQk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E5kWmNxWLVbqT+gTYZJPGQSbg4Rcv89uL1n36jxHoIBgfM/BZYq/GeN1qKZTu5vQdeYSzM96Q0POFw98sdgYnuY5ZOSjn60CpAzI/+qEUUcymXIGAqrKjLKKJwQwn+8Qlk/bcS6an9JRXAJkEAJswPujFsxiD6D3IX7Gb3NRs1k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eBfZpUb+; arc=fail smtp.client-ip=40.107.212.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BZXfJoYnds+x/ovmyBqa2PKwUycOi4ntl0mumTWgYgEgDPQPeaSnrnfJjk35a2tX0rFrai0nvw0bviSC9N9obPj9Z3Q5s5RYa9j6lmq6wXO4JfVqAx9elh5Tf5YL0cqxuz+GvCsSTLvxi/g0+6jO413UmLMNlZ7c711ZhOgawpZCqJpbdTdr2OmXD8rZxPft8m7i0G18O+mFD6DMhm8QGnlhLiv9jpabryLHD4hgUlxduiBVklLLABLo6hYiINYQVNa4gbzl50ThoyIfl+xsxG0WbIMKI2YcKKUUKNxh/fW+o5kPNeVubxybkas4eSf2AbC9frUgCJ5uwbAYx+RNMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=clijnWhj7GG2ZU3cbuPznqxtD4ija57qPnBwQNMWgPg=;
 b=e85yy6Ss2Tddi4ErDmaiw4lD8aXOj4vlFasCWnU8V47UReatZ1pYt2k4ZL9IGZYXz8Y/CiJXcsGqe+2Uu6wZTir9zsxIys6Zi1lN3R77yLAOv4vC1G8iNyX+xJPnkxvgrdWiohsOpFePtvE2Jtqx6ZqQ64+pj1f/FjjwlGuyv70cMCYYClKrLzD3s6TOvUowJ/5txwnkZV+cpo+EzYKl+Yl/SXXYZt/zOy1ykB+wxH4+WwK+g9TouCxwYNRbeiiPinRsqOZ/B1C8rYwHKgb4t/SxmFnWS31RyhZjR9ZZr70zI3Kh/vlZT+A7521wljjwg8/ORmerPJL9NFfwdQnqmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clijnWhj7GG2ZU3cbuPznqxtD4ija57qPnBwQNMWgPg=;
 b=eBfZpUb+4efOXC6M7JR8MVTGzBC1JWITnlB6+lBnSpYy9befNeOllQr31ud6zhTUuc1nr7JZkiEudA/ZfuWgDOMvHJ9z7WoFL5T/yPdyeJqabjlK77IpKM6/EujlKHJRA6dFtbLeezgxC1cIQRIbf/D52AnyiVsyhFFWpsSaKeA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BL3PR12MB6547.namprd12.prod.outlook.com (2603:10b6:208:38e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Thu, 12 Sep
 2024 21:54:08 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7939.022; Thu, 12 Sep 2024
 21:54:08 +0000
Message-ID: <30a5505f-8c9c-6f13-6f90-8d5b6826acb5@amd.com>
Date: Thu, 12 Sep 2024 16:54:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 09/20] virt: sev-guest: Reduce the scope of SNP
 command mutex
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-10-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240731150811.156771-10-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P222CA0012.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::17) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BL3PR12MB6547:EE_
X-MS-Office365-Filtering-Correlation-Id: f1f2b49a-2da3-4a54-a899-08dcd3756d83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cmhrTC8yYm9vWVFvUS9wemJ3enRmQjlqazdQRndxblZneEVna0dXaXlTeFJm?=
 =?utf-8?B?aG9GVEQyYnpUT1pNTWphbUtua0xiUzNuaWdQQXkvS2lDRWRuRXI1VEFmdHhI?=
 =?utf-8?B?V2dJTC8xTXlZbTlVT0hrb3N2OGQ2eWU1ejJhQzI1c0kyMVVJQVRiemNpMXkx?=
 =?utf-8?B?dFgyUXk5WmJuWFJMVjdjRHZENnF6cTRoU21yUXBnanlkMllvdHEwTzZ0M1FZ?=
 =?utf-8?B?LytlYXlOdnZsZ05sampsTXRKZ3ZST0Nqd21YODRaVFZRdEZZRG1qR1FDSUEr?=
 =?utf-8?B?N2h2emtpT1ZXWXhFU3pYNm5pUVp6UlpJWVlRRGxCTEl1QUFiMUhjSDBFRlZh?=
 =?utf-8?B?UXV3cjgwNFBRSXh4SktpZzFLUGtwWGZXSVdNcndNS29uOW51eXM5WVNJNVpK?=
 =?utf-8?B?QWVkdmV0Y3Q3SldkSnR0ZjhndXZTQU5CNDlKdlAySjdGWk9SVFZSV1dVc3kz?=
 =?utf-8?B?MkhSc2lJZ3d6QWR0UTA0eUxoYS9xL1Z0Q1RSanZpa295eGhYcmR1VXd1UUdI?=
 =?utf-8?B?cXR5NDFzMmhDQXZucUg4SHVhUkNuL25CT2FGRWhNUStiZUZRZFpkeFJ6a1hX?=
 =?utf-8?B?N1BpV0Z5YS9vQ1M3ZExRTjFyWDA1bGwyMHRUMWRTLzQvM21YbG9rNUlFMWxO?=
 =?utf-8?B?L1Y5ZDh2WkV3TjMzOWIyL25qM1p1RmYrU2dEM0l5R05WT0hyU2RyQlF4ZWpN?=
 =?utf-8?B?L2VVaVNJUUtMS0JqSjVqMjRmbjgvWlR3RlpZSVE1LyszdXp5dW5QaThKRmdy?=
 =?utf-8?B?MjlWUHJScjF4Z2dncEcxWFZ4OGlKdFpycEFoSXVpZ0RvaUdBNURwZytDU0da?=
 =?utf-8?B?eFhtc1R1TWVjT2pkRkJjeVlwbG5OZEJzM0hIYXBBNnZIS05CVmdYcGtIZWxT?=
 =?utf-8?B?c2ZISWpKc0pyWFFsUFk0b1VYdzJkcTByZWZrRnZJSm5tQ3JjSUlMTGtmMWZ5?=
 =?utf-8?B?TGU3bHh4Nkx1Q2FlQ0Vkdi9iZ3gwNDFNMytadGVHZkpmRmczclpkUUhScWdh?=
 =?utf-8?B?d2M0QlZuNmVIbjVkSmVKQUduSStZZzNBTWNYWVRqemJjQ3UvcXpVYnVmYlAz?=
 =?utf-8?B?QmlsdVlsLzJKaVlVaFFwTmhDeFBBbVc3aWdNNTV5NFlONmZLOHY3ZktoVlZh?=
 =?utf-8?B?UFBaRWNmRlJNWWtUc1VNZ3lWeWpua3FzQ1VDUHQ1Uk5RUjRBL3c2eC9OblVT?=
 =?utf-8?B?MWN1Tjk0SzhGQ0xjd1Q1V1NwM0loNnBVcTZOcXpNYkdCQktESFUvSGpwNjFI?=
 =?utf-8?B?VUNaa2dPUTlTRU56R0cwMmE0eHRsYmtlRXdRRkdjS0FITDVPTjBiUDBRdGJ2?=
 =?utf-8?B?blJoZStiemNYMnBPc25zR0FVM09oV2w5U2JPUVY2OHlnLzdQQXlVUG9ZQWoy?=
 =?utf-8?B?WXFOYzBmd2VaeG5WZnZiU3R3SVhoNjVlUmY0MVdKMWxtSW5YdWlJYk9uNXJP?=
 =?utf-8?B?bCtSc0lKZysvRE45R0Y0VWxDRTRBN01zQXNYSFFCZ3hqY1ZRUHZ6ZWgvL25Y?=
 =?utf-8?B?SGdYdGo3ODh0WjdqTnpScHV2WXBNdTRqVUlaeno2OWQyQXBYaWQ0VzlueE03?=
 =?utf-8?B?a2pkSEY4V1dkUU81VEJwYnhHOG9kTEU2aERBMS9TYk93T0Z6VHMzbjlBUjNp?=
 =?utf-8?B?YVcrTHhCcGxjL1lkdUtjOUpvNXhyMXh3bUMvR1lDRWduZWt3OG5jRHpZV21a?=
 =?utf-8?B?VUt0anBoOGo1blByVGFtazBuVUFuUk9XOEdnOGE3TC9TbDNqYjJIdHhPV1M5?=
 =?utf-8?B?dklsUmFOSnBjS0lsQ2lVUUl2dmR6eWhDc3MxQzRDRVBtYWIwUVR1K2d6VU4z?=
 =?utf-8?B?UVEvZGg0ME9Ucmk0UEJyQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YW1BeU9Qc0czVXNMa0JvMEVDYnNUbHBRRWh4SklvVktyWjNUdHB5OFo0Uzdx?=
 =?utf-8?B?UVlWQlg3Z1huSjc1OG1jY1Q1YzJGakZnczUzTnVQdFhaR2xJS0J0NGRTOW5W?=
 =?utf-8?B?Vld5QlZEVVJ2TDFEdnpTOHI5Z1dPYTcyWlRPWTUzenA5WStTRkRNVHdMOWtD?=
 =?utf-8?B?UFZOSXhYcGdScXBnRVVySWk4RW1ZZ1k4bDE4WTRuUXdRNnE3M2hnQ295UTdU?=
 =?utf-8?B?ditYQW5uQU5lNUxERlprVXhqMk51TDhRWnhFcXpNakRyamUvdUZ1VVNXMW1J?=
 =?utf-8?B?bnRCQ21ta1k3RXFLMnNWamNNa3c0UHlLMHU0WmhjR2ZkdGdFeVJlc0pqeENp?=
 =?utf-8?B?dlR1S2lQdElYbG5CajlaQ0toK2xHbkNkUmtaL1hiWGVCY1lMUUpxWGZzZ3Rz?=
 =?utf-8?B?WEV6U2V6K1QwQWI1Q1ZmRXAyZDlJQ0FKeGxlU1l3MnFITHlzOVVMTk9hVnRY?=
 =?utf-8?B?SnVING92ZmoxN0JRbDNFMk5oZkhKSnhmbWVyWDZ4ZjBFSkJIZnRqSXp3UFRJ?=
 =?utf-8?B?ZzdSSmE1VGdOWm9UMEZGUVRkMDVuM3JwM2llZUMxbEROcFpVcmJJY2V3bExW?=
 =?utf-8?B?VUpRbk5UdzVQeGRabC90UFo1V3J6bFJTMHVhUVJIbzBuLzZDT0RleDN4cFVy?=
 =?utf-8?B?alR3bnNpZE9MeVZxWVBuRGlJZDFZa01ZTjRCQ3E2cjFjMWZYNjZHeXI4cG5h?=
 =?utf-8?B?SzVTYmdVQ3E1NzhPWTk0TjRJRkMya2NWRVdUcTJWNE1vWFhUbE5uWnZyZDdV?=
 =?utf-8?B?YS9xWUFjYk5YMFBzZUZTbVNqenRLdlhFVHkxZGxad2tNWUM1WWxEaExNMDFy?=
 =?utf-8?B?ejNvNTJRSUNKbFluZWpBUnRkczl2WnNxYlp5NENJU2VNL2hFbWxsRk9udWMv?=
 =?utf-8?B?UkJhWVk1eGhMaU9QMklKc1pnMDd1cWQrNUROWkpYOWhDdW1YQjRqaGFkWjVq?=
 =?utf-8?B?Uzl0RHdTWmZiZStHVVBMWUFoWEF3Z2xSalQ3RjNsQzJZRDlqMUhkSGcxeVZS?=
 =?utf-8?B?aEQ3Qmc1a0xPS2ZiQzc5b0d4Q0t2czE0Y3diOW5yVEljdVhtSlRRSkE1WG56?=
 =?utf-8?B?ZTNJSlM5T3U1WlRjTW9kWHYyQnZzSUUzTlFtZnNOZjRLNStTMFZWQ1YvVzh1?=
 =?utf-8?B?WURjREh6dTZUcXV0emwvN25JczBkdnBXRE1rQmhDUUdJMkZSUGUrcnIwR1ZZ?=
 =?utf-8?B?OVNsWDZGUXh6NVVBQTlJTm9CUWViMytIVjZwSGtTZjN0M253ZklVbTJTS0h0?=
 =?utf-8?B?ZGxpeS9penBlQytnZW9Wb0hXNW9lUzFLU2FmWjJodkUybW8rUGgxcmk4TTlM?=
 =?utf-8?B?elh4VHRlZm1JVzM3aFVidWU1SmZIRXgyL25FV25ETm96TVlHcGsxcmFTdFUy?=
 =?utf-8?B?YUdUU3RYWUpHZDEra3R3bnExR1JTN3pjaWZOOUxFQXJ1UVNEMm5GTFozcEdY?=
 =?utf-8?B?b0VIT1JQa1hJeHVtNmNSanc5c3N5UzgxOFNaY0tZWHQwT0pvUkdOdjUzVW9k?=
 =?utf-8?B?ZU40d2xoN1FxQ1BFSktGNkFoODJFWFV0RjlmUHI2R0NpVE9EbGwyVEV3ZDZD?=
 =?utf-8?B?Y3ZPMXBic2hYQTB5dnhrUkk0NkZFWkdwQlRQVGN3ZG9oZ3VRR1hsaksvZGNi?=
 =?utf-8?B?QVdYWUxCMnhCblFvQlhPbkZud3NMZkg4dFU0M0pvNUxMNkVMbjY0YS9lSDB6?=
 =?utf-8?B?Sk04UkVwUG1nWHFjTVdnMkdaaFJqUXkwZkFCaHJmZW9YTWNhMWxFNENRYzRq?=
 =?utf-8?B?eTJSekF5YzJZL05jbndvN00vNnZoVFFQZEVQVnhWbVp3cEt2aWFHQ2NjbjF3?=
 =?utf-8?B?MjR4YlVHTTVMUjBkZTc2cks3VVh0ZWxUbUkyd1B1QktPY3hWb3NkODlrZEtk?=
 =?utf-8?B?dXNIYkY4OXZTK2llMURjK1VadlYvWkRNQkdXSjVldTBYR0xXR1B1OWtmSzF0?=
 =?utf-8?B?VmN1V09KMjQxUnJHb1FMaUtBK0pXU1FhT1plMVhOaXJ4SGZ5S0kyNDJ6VUht?=
 =?utf-8?B?dEc0ajBrZkRrd2F1eElJRHExbktKd2pwY2RQZnAzaWsrWnNmR09pUHYzQnEz?=
 =?utf-8?B?ZUR3UDFWYXZCWlRhTmE3WllUMWx6bHhseG9QRGtZc0RHcm00T2RCeGpmQm5t?=
 =?utf-8?Q?71J2VDytA8XFmDsejlyyr/y9g?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f2b49a-2da3-4a54-a899-08dcd3756d83
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 21:54:08.2871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H08WhE3fF3YgIgs3hzqsEewXiYbY+IzUronYxXBtWfHH7QqzTqvyyO2LzpoHlC72cWQjnOJT+gs30RtZXFoMDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6547

On 7/31/24 10:08, Nikunj A Dadhania wrote:
> The SNP command mutex is used to serialize access to the shared buffer,
> command handling, and message sequence number.
> 
> All shared buffer, command handling, and message sequence updates are done
> within snp_send_guest_request(), so moving the mutex to this function is
> appropriate and maintains the critical section.
> 
> Since the mutex is now taken at a later point in time, remove the lockdep
> checks that occur before taking the mutex.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  drivers/virt/coco/sev-guest/sev-guest.c | 17 ++---------------
>  1 file changed, 2 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index 92734a2345a6..42f7126f1718 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -345,6 +345,8 @@ static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
>  	u64 seqno;
>  	int rc;
>  
> +	guard(mutex)(&snp_cmd_mutex);
> +
>  	/* Get message sequence and verify that its a non-zero */
>  	seqno = snp_get_msg_seqno(snp_dev);
>  	if (!seqno)
> @@ -419,8 +421,6 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
>  	struct snp_report_resp *report_resp;
>  	int rc, resp_len;
>  
> -	lockdep_assert_held(&snp_cmd_mutex);
> -
>  	if (!arg->req_data || !arg->resp_data)
>  		return -EINVAL;
>  
> @@ -458,8 +458,6 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
>  	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
>  	u8 buf[64 + 16];
>  
> -	lockdep_assert_held(&snp_cmd_mutex);
> -
>  	if (!arg->req_data || !arg->resp_data)
>  		return -EINVAL;
>  
> @@ -501,8 +499,6 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>  	int ret, npages = 0, resp_len;
>  	sockptr_t certs_address;
>  
> -	lockdep_assert_held(&snp_cmd_mutex);
> -
>  	if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
>  		return -EINVAL;
>  
> @@ -590,12 +586,9 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
>  	if (!input.msg_version)
>  		return -EINVAL;
>  
> -	mutex_lock(&snp_cmd_mutex);
> -
>  	/* Check if the VMPCK is not empty */
>  	if (is_vmpck_empty(snp_dev)) {

Are we ok with this being outside of the lock now?

I believe is_vmpck_empty() can get a false and then be waiting on the
mutex while snp_disable_vmpck() is called. Suddenly the code thinks the
VMPCK is valid when it isn't anymore. Not sure if that matters, as the
guest request will fail anyway?

Thanks,
Tom

>  		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
> -		mutex_unlock(&snp_cmd_mutex);
>  		return -ENOTTY;
>  	}
>  
> @@ -620,8 +613,6 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
>  		break;
>  	}
>  
> -	mutex_unlock(&snp_cmd_mutex);
> -
>  	if (input.exitinfo2 && copy_to_user(argp, &input, sizeof(input)))
>  		return -EFAULT;
>  
> @@ -736,8 +727,6 @@ static int sev_svsm_report_new(struct tsm_report *report, void *data)
>  	man_len = SZ_4K;
>  	certs_len = SEV_FW_BLOB_MAX_SIZE;
>  
> -	guard(mutex)(&snp_cmd_mutex);
> -
>  	if (guid_is_null(&desc->service_guid)) {
>  		call_id = SVSM_ATTEST_CALL(SVSM_ATTEST_SERVICES);
>  	} else {
> @@ -872,8 +861,6 @@ static int sev_report_new(struct tsm_report *report, void *data)
>  	if (!buf)
>  		return -ENOMEM;
>  
> -	guard(mutex)(&snp_cmd_mutex);
> -
>  	/* Check if the VMPCK is not empty */
>  	if (is_vmpck_empty(snp_dev)) {
>  		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");

