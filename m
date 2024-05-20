Return-Path: <kvm+bounces-17793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D14CA8CA1FB
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 20:26:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 063DB1C20DA8
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 18:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE5E9137935;
	Mon, 20 May 2024 18:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sZPw4b5v"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3858E1847
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 18:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716229599; cv=fail; b=qTrvT8DZBQGR1EFuLwkbft2plFeBGJKY8D76qtqIHbUWXzDvXd4QuFkWaFkmF59mk0di8cuYmO45GDS8tTMQdbYsNhbw8C+A0igH/Bc6iVvXRnC4dWxe3jmMnqYH5OsO+tWlbe2V61m4sqN1+NMy+P7K8tacC+KoO1Kaz5uW06U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716229599; c=relaxed/simple;
	bh=Y+SInFIwMKhfIjSdUjcg9ntrLO6eLnCPE7l51QIYZ8E=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jZR7atFykdkpHPW1ohqB6LoVfcNY3FBKzg+hSoUOjRjDWtESDJDLy8kaC41dtPykKi+3coTYDps8eOGfYMPytXFfXQ3gf1GjJA5gtxlLtMKju8a9kXGQiCUF0JQ4M4nvh0Mev3TTY/jrxEQWB6OVWUj5ghjm8MfzlfRkxdpp0GA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sZPw4b5v; arc=fail smtp.client-ip=40.107.244.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ce3E00GBfMXuE9ZBW06gSgsJ6D5TT3ptn/4Kou9O2YmGEvb40XX5ZqDOavfVeggqx60WLyII2BRZHsvCJqlwc05kPkO+LSvPSBuP8NjMuyxOo+mZOSKGszHoKZZUsZ20ftWWkAyhGqAVVFXwlCSRowJtJJ9vg+fv3tevNMMzR04vzqfb2zGkaWqG2YX4OkaINzEGMvNOSsIinaErK2S4xUxcv0X+IamWoVvPnHpJO/R3C7RyZarIoBDjlKqf0JH/7/6bQVUhn9WiR3N3obFTDxB0AgjJaYIf8eoj7e2v32e2+JrwOVCGZt4hPkL9pNRk7wsUuV+xsy1scBCHQAXf/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T8Tf1V4nLNJ/TDjmDuGNIkie2Buzl6U50R6mkbfvKrI=;
 b=XlsIAHdsTIsjp6xB80KMFSqgsUe1i677Hliv1ZUcnc00gKtuG2qjzNvpeUM0lqsdl/N+1t0Ey/MS5wY4v2SirtrofA3ldh93KHZSaRgsTPQjA0EnaraAO15aF/bagIYC76GUdIru1MUkkkSXEapUKSyQiT3T707NwlH08XL2ZPFMi1ZGQOudzaM5peKp28Lly79bP1fG6EE9vKuACNl+QyALvkGw7yJMMtqYb4iit8qE+Ibledpoeu9pRrFp1fVXPTC8vOFuHzmqbU2YNJhrL+WBVTipM/0TlLsr8ZzqyF0B8UNMpNkU7/qpb8F3HTR2tqapzdz+q1I+vohLJ3QStg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8Tf1V4nLNJ/TDjmDuGNIkie2Buzl6U50R6mkbfvKrI=;
 b=sZPw4b5vdn2LlUGfZxaHM+mowD6BwotCF8R5VYyoOlo1UdfgDIZjdpJa+brimU4GIkU39o71jh1lAeqIE6pJp7A26+sCnKsR5syzRyCYFiI/yskmcZM6g2Zl1YTba/ig1RmgxlcUrHMyXTCPtcQXubLTxIdg+8M6LfvIqinibHA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by MW3PR12MB4441.namprd12.prod.outlook.com (2603:10b6:303:59::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Mon, 20 May
 2024 18:26:36 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 18:26:35 +0000
Message-ID: <1d66de5a-673f-c4bf-4f7f-36340e244539@amd.com>
Date: Mon, 20 May 2024 13:26:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 3/3] KVM: SVM: Consider NUMA affinity when allocating
 per-CPU save_area
Content-Language: en-US
To: Li RongQing <lirongqing@baidu.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, yosryahmed@google.com,
 pgonda@google.com
References: <20240520120858.13117-1-lirongqing@baidu.com>
 <20240520120858.13117-4-lirongqing@baidu.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240520120858.13117-4-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:806:d3::23) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|MW3PR12MB4441:EE_
X-MS-Office365-Filtering-Correlation-Id: bc2eefc1-15da-47c6-c434-08dc78fa61bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aklrRCt1TDZwejJOZXI5SFZvaHVKVzd3OWRJb0I0MGhMdnRMKzVGbUhKL2Rm?=
 =?utf-8?B?cHZvelUrSEJhRi93QW0vVzJIZ0ZTZlR1bDRkRDVVNE5qUWFBL0tMWUVMUVE2?=
 =?utf-8?B?VWx4N2lYeExNYUtWNlRDamF0cHB0ZEQ2M3JWZnNxMFNhekljZHAwemNKRnBu?=
 =?utf-8?B?eWloeTZUaFhSU1FmbXpxNlp0UFZ1TWN4ZXBQaHhhbGFncEw3T3p0Z0FFOWR6?=
 =?utf-8?B?bzErNXAyRVNOelFXT0Y1S3pISHpOK1VmakJSVVJ6Q01Tcmt4bjU2MDZpVTNT?=
 =?utf-8?B?SlAzMExxWUtFeFk3Y2s5OURrRkdDRFlDWmdUa3ZYeUFTRWh2cEtOeHFpaXpt?=
 =?utf-8?B?T2hndW5TanhvWnRrSW90RWt4by9MWXo3N1F2V0Rpd055d0phRFFCeGpUV1Uw?=
 =?utf-8?B?MS9RWGJyd3BiNUQyVm5PN3FUaDVINlAzd2Z2b3pGTWdiNkhIV0tkcTBHdmFp?=
 =?utf-8?B?bENyU0tBN2djT2twVFpsTld0ZDJQek1vL1BMMFRBWUtwTHFIYyt2aFNPb3Br?=
 =?utf-8?B?Q3NFNk0vbHpmb1ZzaWtiVDNmcXZ4cmhOZFFIS01vTFhza3N2M01xY2xXSEhO?=
 =?utf-8?B?ekxmL0U1K2tTQzA5SXVYUkRmV3lvbUtKTGlDamQ1cVNEYUxFTVpFRk1CS1JE?=
 =?utf-8?B?SFVkeTVWSDNNeDdmUTFUSWgyWFl5aVEzcStWYmhpMVFrWFlKQ3o3WktmR3Zn?=
 =?utf-8?B?Z1JxVWxhZ1Q4NkVzNitOcWpVVlJ5Rktoc01WWFRTSm8wUDFDOWN0cGNDSG5s?=
 =?utf-8?B?MjVBTE0wOUN4NGxiUkFFMmR6TEVBWEhQYmxMeFNUZm1xWTdMTTRsQjhyaEZi?=
 =?utf-8?B?clloZWxRTnVOY3EvOE9TdlprUGZKMGxzSGltZkxHWWJkMjh5L1lYRGtYdWxY?=
 =?utf-8?B?aHpnUkZPakdSVkZQNm5LaWhYQWMwVnVidUtLQk0xT0JMZ3d1Zi9ybWJMK3Ro?=
 =?utf-8?B?N1hYc1JPMExrL2ZJRG5qa1p2ZVdHeHZvUlZFQjE5cWllVEpuMDhqVWxOUEtI?=
 =?utf-8?B?c3dURWZwWlBuNUZsVG50cEtrRGVCMEczc3NEM0VhY1hya29LQkhoQ1R0SHVR?=
 =?utf-8?B?WGJFVE9nazdTR1ZkNXdHY3c1ZnUzVTVVQnhrcDJOaTF6YWpCbjRPTkJFK2Q2?=
 =?utf-8?B?VjJlRjNzV1JEMjg1NHhDVEVvMU9EWSt1djRUQjNaUS9tZVNVelRORi85MDRS?=
 =?utf-8?B?cnFrZnZaZy9ybkcrNjczenYwcWtnSDNTbGdLL3NvRjY0Qi9oa0hTazJjemJW?=
 =?utf-8?B?SUlEYml3WldJanpqRGFnVzg1T3JvMkFRWkxBRVV0eTU3dy9sWkcyNkFNaE9j?=
 =?utf-8?B?TVB0WWtqRHpjWWtpbEdhRndwcTNPQ1VURVhCZlcwZDFYeUlYRExSdVJlVFgz?=
 =?utf-8?B?L0F0MUQ4QlF6N0M0SnVqdGJtSXdocXlKZzlnRThCZ0NOQ1M5SVQrbXlla204?=
 =?utf-8?B?MExaZExXUVhqMTgyZDFVKzE4SDNGdzZzMTV2NGZLOC9aZDdjRUJaRUEzYjlR?=
 =?utf-8?B?RlBaUmp3QnJ6emx2cGlxdUJqdVlrVlI3NlAxNytoZFJVZTRqWnpmL1l0NW1h?=
 =?utf-8?B?dEQ5MzA0bmRwblIvUU1RMlpubEZuYldyY0d4c2hwZGlZdjViZkk2M1RWUWFs?=
 =?utf-8?B?VmJrMGhvV0Y5QUdYUWdzM2NFVXp4dlhTVU1NWHRYc0JFV0pZM3p4MTNTM1dx?=
 =?utf-8?B?OFR3QmJHMGVpSEsyMGlOWUtGRHR6K2poWDhEcEF5S28zNzY5bEJwS3lnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L01iVXEzSUhXdllWUlBlQUI3VS9EL3hGVmRXNTlhQjNab2RYaGEyR2cxZjFZ?=
 =?utf-8?B?cld6MWRnbVVHWlg4M2lwYVdCUm5aRk04aFVpdnJYMHdQcEZ3djAzUVpxUnhS?=
 =?utf-8?B?ZnFoSG1WSnE0ekVKTS9sODMrU2dyKzNoNitiRzlFN2NIMjdsTFJGQVFsSWxu?=
 =?utf-8?B?QjhIY1NPN0lpZXRaemxmSXFDYmphUHVhWWFoTlFpQVU0SnpCRHZSeHRHZE9p?=
 =?utf-8?B?QTRoNDcyQnZOYW1Fby9MWVV5WkhFL09iMWVNQ1pJempNSktlRGZsYlYyYlVK?=
 =?utf-8?B?a0lmb0ZydUFra1Myd1lGbitCSWlmaEVTeDhqOWhmSXZPZWhsbzl6OXQzN2JY?=
 =?utf-8?B?cmM2QVc2NUl0ZURFVXdUVFk1eTRCZzRIWVV6Rk9FZXhMUEp3QXpJSGFJVksz?=
 =?utf-8?B?elNheWo5UXJuVFVDZEwrekpnQXNsdDB6SnpZNGxWdXRXMUFiekZBSWh0MEI3?=
 =?utf-8?B?aDlOOWlLSVRXdythZUxIRzROdVFnZVowQ2VYbnFTdzZVeUkrRlg1TWIrZjZy?=
 =?utf-8?B?ak5jR0dhcCtPM3loQjdJcHpzY0did05FZE8rK1dORUZFSFJJa2V6UVY3TVdy?=
 =?utf-8?B?aWpiZEsvekdNUkh5UzVsT0hxTXRQSDZpMVFBOENBZXhVS2Vvd2xqRGh5bGNy?=
 =?utf-8?B?REc4WnNpb0pJc2c2Vm5oQUNYdHE3eWdGOXJ6eXF1NHEvcjBWU09yUE1xNTZm?=
 =?utf-8?B?TDQybDZHMk44YXZjb3o4dUNoUkR4WWpMTDlIeHZwaE0vUHNRMlJWT1lKSmM2?=
 =?utf-8?B?TWdwamZDa1VCaTFZWjJYa1R0WHdsZjNOcXgveUdYQzRFNkRuY3dRK1BiUDVD?=
 =?utf-8?B?QkV5MkxBUjZ5TndNaW5WRkw1MUVSR01hVzkySW1JdUNXNTZyS2liWU5zTWNv?=
 =?utf-8?B?M2s4WU1lKzg3akZ6UHB3QUZVTWhqM1JkM284VzNsRnQvYjFCNlpKaUdvbTF0?=
 =?utf-8?B?VHluNHJDM1JFd2F5M0lxbHZzNC9Oc3Z3WnQyQmxjWFBJeEpBTVZCRXRHd3Bj?=
 =?utf-8?B?SWE3Zk1MaDZ4NEd2cFJPS3ZrcmNFREYxc2JtbytXN3AwVEEySHdvS2hKaUpy?=
 =?utf-8?B?NFc5MUo3V2NIRUFKTUxqR2hqV2pSOTJWamdQVzlpU2tENHBIR0VJYjh4emIr?=
 =?utf-8?B?cnJZMytBY2Y0MFRsTWUvUk1IVlNUL0RYZHZRY1grZHJuVW1sV3FjNlREVkJx?=
 =?utf-8?B?dCtHbXZWSVNSaUNIbFpKeFE0TmtpampUWkhIcGRvRlY1bnlVZW9hSVBLUEhZ?=
 =?utf-8?B?NnZrUHZUcXc1TGxNUGlXK1psMzdETm0yN3Y3MWl5cGhiOVAvK05SVVZZWVc1?=
 =?utf-8?B?b3p0VFpxZkZpemtPUnpzQkpwb2hEeDJUdEloaExVVEFIL2tKYmZ1MTF2SEpZ?=
 =?utf-8?B?N3Voc3NrUDYyTXl3QW5UU0VhdExaK2VyeTNPTlZpZVlVSlpwY3BCUnlBdUlo?=
 =?utf-8?B?Z1VFOWxpaWhXQ1RZaHF1dU01MzFybnVxc2tWenZlb3F1MG40aHQxM2tGNzM3?=
 =?utf-8?B?MytPaWw1c1NPOVpobEtuMFNDOVBLQXQyeHJEU3Y2QTlIYkdqU1dFUXhuZHpC?=
 =?utf-8?B?clBkV2haSzk5bjU3dlFidTlpNEFkdzdmZlduRCttS2xEZE50d0l3Vm9HU2dK?=
 =?utf-8?B?TzVuMHJ6WU5MMUMrdlpadnYrSXkybTVQOUQrWWhLS1lKZmxtcGJucS9ja01v?=
 =?utf-8?B?elZFQW9nYmZTVm9xQUptMTR6YmVCSWZYQWs3OHV4b1cwcmxFR2dSS0JWTTZS?=
 =?utf-8?B?RjFrS0poeCtrK2F4cHhZNzM3ZFVORElMOHQwNEtES1Arc1Y0a1N1aVFUR0s1?=
 =?utf-8?B?bEY5NXM0R3BicjMyVndWU2p1bTdUdG15SmZ1YTJ3cVNJU0ZmQWw2QXVBdTlN?=
 =?utf-8?B?dysvMlpSUktuSjRrdUkrRWdDUFJYeGtBaVJmWTk3YmdOWGl2L0RubjY1cWNC?=
 =?utf-8?B?dzFzM1AvS09RMFA2TkxoRjZKaHM2RXlTZzYzd2ZPMkQ3ampZTmhqNFJCSE8w?=
 =?utf-8?B?cGFvZjlmUUZLTkN6bklDeHpPMUJjR3pOYXI3bkxORVJHN01jaG1xMnJ2WTFv?=
 =?utf-8?B?MWJYYmpiR2VQSjV0SE5OeVhjTXJ3Ym5uekx6MFlPSm00TnF4ZDdtTnBmeWNK?=
 =?utf-8?Q?msbEh0PnRIVM7S4OcU1PJTHjE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc2eefc1-15da-47c6-c434-08dc78fa61bf
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 18:26:35.8911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fwcpfykyddM0J68oS8PfE8cSXbjEE6zvQkKcN7jToovo6hNJot5ByNpi9qQ+eV8YE+ECQHH363ghe/5GZczPug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4441

On 5/20/24 07:08, Li RongQing wrote:
> save_area of per-CPU svm_data are dominantly accessed from their
> own local CPUs, so allocate them node-local for performance reason
> 
> so rename __snp_safe_alloc_page as snp_safe_alloc_page_node which
> accepts numa node id as input parameter, svm_cpu_init call it with
> node id switched from cpu id
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c |  6 +++---
>   arch/x86/kvm/svm/svm.c |  2 +-
>   arch/x86/kvm/svm/svm.h | 10 +++++-----
>   3 files changed, 9 insertions(+), 9 deletions(-)
> 

