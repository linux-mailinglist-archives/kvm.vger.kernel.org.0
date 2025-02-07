Return-Path: <kvm+bounces-37639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D027A2D003
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 22:47:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0E42163E87
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 21:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62F441D6DBF;
	Fri,  7 Feb 2025 21:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cjg8jhDD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017F91CD1E4;
	Fri,  7 Feb 2025 21:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738964815; cv=fail; b=sg53E8Ud0xTJv8Jcq2JsvxFr/PtuJLaHwuyU4UCk4Fk843X7tCM+LYz0+K0yYzksZT9vZ4Kv/Pe3/QZvk+A443aOsmL2yCad9BZEfn65x24MzslJNtjLfo4v+9hrI0T0TDDoaxefkfyS6OV/66h4ag2L+RErMbku/4yn7PTiuEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738964815; c=relaxed/simple;
	bh=FjBSkWlqQMhAjCrtzcVeLPXmZtVziimufj/OVx3EFpU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=B5zNF722khsnxnc8ZjxqFy4/7UwH5Byae9gg03dUNG7RlebpNUb3skavTXUMzYp7ZlaDgfsz6NiP4xaiUErqCin3ocktv4hSzXj14JjLrJ4gAYvtXDikqp8vkgERsIZvrxj/CarUxi4Hpyb5sMCtO3L8z7p266YWWguAncbZD6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cjg8jhDD; arc=fail smtp.client-ip=40.107.220.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bJViVXcGgh4twQTPLWqLLuQURgYsnTFd6iIjOX0kMwfL5N7pZuu/aIKLYZPGYV9xh47x026xXeg3krKrDBumw5O2mIaCvvmzRK/rUkpJ8AgpE9ueSSwdLFWBwOqSNlobzg5lZk9PipKzFzLF/ljqm052bjSOearnjikfsuZ6iGFG2oMH4J4XSnhfkzMaOysHNmi3ooWAsE3srWxqma/dD3xtVsCIBw8S9Rl35t5X3ij0Il3PVPDTwkSixonln3e+EYQERF00gC9vBciseyHV/pjSr9NAhldw/vgdv/hRShil9QTwX3+YXu5b2dRqdOShbE6pkGKN9u9cy2HAXuw1vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cvR+WTXRG1AYayoWTq8Ze/3CGfc+Te0Pl5Mx1kA/5Q=;
 b=rvk/OKivBViBqm4bdAHpLiNvJOxvEAoWSqr6VAFkcd0PNpoNI6JM8HmFfVg9eAgU9Fk35SFGIOdBIPi8pAaQMQAux0p5jEkQHh9V11xj/uf6C6Kb0vKBStNJAUD1WZqAAujfCObPZlfA6kAFUgZ5DXDze8sq6ncjlQxlaV9qnBbsGgu52ijCg0wcDrRZBuVSsJ6E81ekLxy615Pkr6FhJMPMFNkkCj9sfz9in8WsIQoPqBwaRiqySwp1G+LiHhpIKHS98Ollgy0Jmswn9tHJAxsmrN7arVCyFaHe766Io34Z8BMBqCN3NnVuCZdGGvH9XPg1otwCB66nqAYUtIQ2Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cvR+WTXRG1AYayoWTq8Ze/3CGfc+Te0Pl5Mx1kA/5Q=;
 b=cjg8jhDDCa6zDbvHAa1S3E5pKnml0QuyDpi+rC9tix8C77mHcIbrOvZJwtUYCF3kl2wD2CXF8Y/Fle4ZaQxn5BetIfwZNimE04oXKv7NYHoy+Qfywpm02lkZT6r6IPAKPtDlhnw5mX7GDMkqzDMh+VnxmhsU72ceikvRQU5As7Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by MW4PR12MB6754.namprd12.prod.outlook.com (2603:10b6:303:1eb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.12; Fri, 7 Feb
 2025 21:46:50 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%5]) with mapi id 15.20.8422.012; Fri, 7 Feb 2025
 21:46:50 +0000
Message-ID: <12eba6d2-095c-96e0-8378-9c0a6582cd73@amd.com>
Date: Fri, 7 Feb 2025 15:46:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 2/3] KVM: SVM: Ensure PSP module is initialized if KVM
 module is built-in
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 joro@8bytes.org, suravee.suthikulpanit@amd.com, will@kernel.org,
 robin.murphy@arm.com
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
References: <cover.1738618801.git.ashish.kalra@amd.com>
 <bccabf4ca1c19093d5a484912cd71566102c069e.1738618801.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <bccabf4ca1c19093d5a484912cd71566102c069e.1738618801.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0010.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::33) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|MW4PR12MB6754:EE_
X-MS-Office365-Filtering-Correlation-Id: 81532364-3125-4388-a169-08dd47c0edc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VzlTZHRyRm1ldSt5SzdaeDR2eisrR3I4Z09yNGVYWGwwVmI2SXhBakxsZVNx?=
 =?utf-8?B?c1B6Vmx5SlNIU2xLSEFsSlRCZUlKUDlZeEJaL3I1YWwvUGwvbE5hVUdiWGk0?=
 =?utf-8?B?dWpUbkNacmdzeWxFcmJNWTBxSmVWa25IbFE1NTNaWTQ2T0w0ZE91akM1OHdE?=
 =?utf-8?B?ZXdHNE5QRWEwWDRIUGNPRm1MM3V5TWdPQVNuK3hpcnRuZ3FreGIxaS9XWFJ1?=
 =?utf-8?B?Q1YxeWc5dVNSZ3ozZnhiQTNBZUVvbW1qVFRLZ0xabXhRSms2WXdpK1JQRE1W?=
 =?utf-8?B?SEVRd203OTc1RHFyUTJuM0ZQWlhIKzhsTUlBT3ZPdkJQekNFa0N6bEdvZlNN?=
 =?utf-8?B?WUQ2aHpkRGRTM0xZaGJKb1NuRjFYdFhpTjJwUUd2K25hS3d1b3V1b3E0a3lP?=
 =?utf-8?B?WCtvbXhkdUJJYUIrVG5tak4zYWV0TThySENuMkhNODBOcHBNZlN3eVhlaEF6?=
 =?utf-8?B?TDlnbWZsL2MxSENFUzY3MmtQQjRMT0p1YnoyZnFaVkV1YXJBbWwrNjZ6RDR3?=
 =?utf-8?B?TUVvQkJiK1doNzFlMm1MTEhoSHEwd0I5T0xOQnF2R29HcjYyV3VUeCtvQmhJ?=
 =?utf-8?B?cmRGdjVnTWUvcFVJNWdzM2NKSWZQcWRjalN6Ym1qMWR5bHVPMkQvZDlBcDJZ?=
 =?utf-8?B?TkJNazVtcVVyRWNyaC8yc2lYZFJ3Um5GaXlMdGFqWmIxcThQMmVBYnJPV3dW?=
 =?utf-8?B?TDZ3aXdqS3RuOXo3Zy9JQjErV2RPWjl0ZFY5L1ZQTksxQjR0VXlrOERPb0wy?=
 =?utf-8?B?am9qWHNnMXJXbXJ2ZGVYbHZ5dVhhcFlVS0J1b0c0TGdKbGt5M2ErSmZTdXVL?=
 =?utf-8?B?aU0zUjBOMGcwbEdZTjV0VmVCRFRyNy9uWG4xMzNHd1NmK1BmTnR1U054S0Jn?=
 =?utf-8?B?NEgvWk9RL081VjA1YS9TcVhVSlhCaDNkQ3dzc3YvWnpGVkVya2FSbEs5L0Nz?=
 =?utf-8?B?ekNlNzNHa3Rpakl3dHB3UEVQSy9CWWFTeVJtQUEyL2lpVXdOc01Ja1NhTFkv?=
 =?utf-8?B?RmUrcEVpZ09oUGdVRXkwMXNickFPYlZkQjZ5ZW9SN0xMM2FNWHRHaG01WDlC?=
 =?utf-8?B?dTg1blhkY1JSVUE4YlVDenlkVU50WGg3VzFzSG9HM1I1TERrQ2NHVXlYSHds?=
 =?utf-8?B?NWZ2elJJZE9DK3JjUVhmbU9xenhCOGtIcXMyQmNRbGdtby9hMndOODNvUCtS?=
 =?utf-8?B?YWFZUURjOGlNU1Q0bWhVemE0OUhjcnpHRW5oeXQ3akN2R1Y3WTZPd0RwL21j?=
 =?utf-8?B?K1ZMWDk5VHh4T0tvRlg0YzZ2UFJLU2JDT3M3ajlhZWFvWTNqYUwyMWVubUlB?=
 =?utf-8?B?VmZHL2hEd2lIL1NxMTE0NFY1N3NzOEZjMVRjeGJyZVJyV21LcURiWjVZUnBz?=
 =?utf-8?B?aVNlZXNmcnl6WjQvL1JnU0dqZnN2ZzRMSDZsbno4NklMa21NckFqRFRuTjNy?=
 =?utf-8?B?OWUvdG5BMnBhSkVudTdtTlA4MDZ1bG8zdW1NcnVWc28reGQxNFVWOFo2bFZz?=
 =?utf-8?B?K3RCNmsrT1BpWjBiMWdMUnQyWFlKSEJaWDJGeTlBVThLRzNzYkZrZG9nNDZr?=
 =?utf-8?B?cGFORnpVV2hXNXlEN1ZQNlpjSWpDNXA5RkdXNlkwZDcyaERNaFNUeGNlOFJN?=
 =?utf-8?B?V29UcFdnNzg3dUQrcXl5a0Y2SEF2cUs1NFJMcGpPZ2E4a1ZNdkVhNC9SNXJw?=
 =?utf-8?B?bkpOU1Z5c1c5N1hIQ3pXTEF3QkEzRTVGMnY2NEFvWFQ0eW1YaFZ3aEt3S1pN?=
 =?utf-8?B?aHMrQ2dvWWVlOXZvYkdJdWtoUWI3ei81QkZOeDNqbk5TOTBqQ2lpbk51VG5l?=
 =?utf-8?B?QU8yWTgvZS9iUlNxNWN3NDJVWHJnQTdhNjBYWnA4U2MyVFFvbE1Zck1tbExm?=
 =?utf-8?B?aCtOV3VuNWx1aDVNUVhYR0lPSFNCZjhOOUU5QUQrc2VpZ29TUmgxSGsyNFlV?=
 =?utf-8?Q?o/8/HewoDl8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NzJIbmhJUG54a1Jna3BiYllGbDBaSDhHUDRxeG9xcXhmYnNuQVd3ckd6aGEz?=
 =?utf-8?B?VTJtelBUcHdIVnFCeTRNekdwUTg1VVVhZWJpaFJNZ0VhaXlUcnZ5K3JVUW5J?=
 =?utf-8?B?UndkZ3dKRHNYNVFEM2x6anVnd1dQVmkxSXJPdlA1WVFqSmV0allrVnpxVVhn?=
 =?utf-8?B?aThyTms4alBBVkdWLy8yNTE3OVV4NmdxNm93aWFmNmNxMTlNRERqZCtuVUor?=
 =?utf-8?B?b1NWT0VzOFlsckhYSllodGh2V0pDd3dBRzFNcXBXNnFJaSt5ejMybU5zTm5E?=
 =?utf-8?B?RnlJYTJKZldSTS95NmJ0c09aR296N3hFMGhpL0MwRXlzTyt2QnBZb05JRVZu?=
 =?utf-8?B?VUxSaXNjakc2VFRKbGVPNTliTkZDVTBidlpLZ3dPcUd0UUhGaTV2NVRrZ085?=
 =?utf-8?B?ekNNWGFmaXUyRWcxMitia1Q1N2FtaHkyTmd4OVVwZUdNNXljaGVQY1ozK1Nl?=
 =?utf-8?B?djd1RUhoaDNrK0l2SGZBNXdFcWJNZmx5dWNYNzUrRENmM0gwWWVTZHB0Y2Yv?=
 =?utf-8?B?QThPMytqUnR0VmMyZm5NcHBVbExMVDlEZVl6K1BrWldYdzFIaGp1MmRubFI1?=
 =?utf-8?B?YzBrMG1FSnlTcFFPUGlYa2F0Tzh2a21sMENuMk5ZRThLc2VGUEx0WHFYMkUy?=
 =?utf-8?B?K2VHclpvUkNFUVZtSU95WGRFR3pDR2poVTB6ZkFyeUVpZFRPbDNIMlFaUWd0?=
 =?utf-8?B?NmlsRXQrL0crK0ZEOXhzMVY5d2p0dEg2Mk1qNklRY0lhRHZOT0NTeFhEVHFL?=
 =?utf-8?B?WUJiN1M2ZFJ6U0t1bGFSUjdQcmhSeEkwUnY1cUh0aGhsUmJBWGtadnlsUWZt?=
 =?utf-8?B?c1Z6enN2U3pYU3RPRXNkd0VFTVFwU0hDY3lVMkJqYlQrZmZTeTZidzhQekVh?=
 =?utf-8?B?VEJuOG1ralZYZ2NsWjlabEZEZy9HTjdWWmtadi9CdFBpbGZ4ZWNLaFpWTjJr?=
 =?utf-8?B?aGZEbVpzZGVwMVplM0tUWjZLQ2hIYlJTajF0LzF3WGpPZzlKeHJ1dDFFQ2xo?=
 =?utf-8?B?ZEsrcFVoTC80NjdNUmM3eG4weDhFTGZrZ0JNRklYQUJsVXBDZ3B6NG4yZGNH?=
 =?utf-8?B?R0N2OWd2TGcvOWFoY3gyam5TQlBaVW9rUjQ3bjRjTHFGWHNHRlpaWjlGaFVy?=
 =?utf-8?B?U2NvaWhRc2ZLYWNpRnp4Z1BOa2FybWczRWhYbTlaNXZEanllWDNhcXhZQ3dr?=
 =?utf-8?B?Q2hxSWlDVGQxZmIrQUpCMFc0QjdpV3h4d0dyTXNZTTZoMGt1SVhOcXkzT2dV?=
 =?utf-8?B?WFM2TlRycW95OHRDZWMwOUgxNUV1ZEV5MU1Bc3o5Uk5JTlBNdUQra3BXTXdL?=
 =?utf-8?B?V0lJQ25IeXQ1WFhOUWtOanpqK0JKUld5ZUlTMzg3S3ZNdThIQUJyNk5BOFpi?=
 =?utf-8?B?TnZFaDdhK0hNRklTVStFM0I1VkdEbmlkMHBpV1hHQllwZjlncllnRXI3TzBH?=
 =?utf-8?B?WlRjeTdPZnhLZDh4YzcwMjNWUzB2Yk9xaGpZaUFXaHNiaWZ1Z3I0VUxGM1lW?=
 =?utf-8?B?Q3FFNk1ySU1OTFdZaFI0bkplMXBTR2RSbGpFZjg4c1hRUmV0bGFqWXVxanVq?=
 =?utf-8?B?RHdhV0FKNzI4TDRsSElRZ0FtSHhKQVNrNVlkdmNDY0tuZzBxd2o5ZzF5VlpJ?=
 =?utf-8?B?aGpWM0NkbG1TTEh1Q1pST3ZzZFZ3VEZ6ajRuR2pYc3B3TmFhcHJtUmhPVWJl?=
 =?utf-8?B?ZEtJM1E0RmI4RTdDQXV2eDc5bEp2L0hhMTFUN2o1MU5DS1VGSERLYkQ4dXlV?=
 =?utf-8?B?eXl4N2dpVHRkb0k4N2dzQUpyaVNPU0hITkkrZUhoRThIVEMySkVvKzNKdlJk?=
 =?utf-8?B?akVtbGZtMTZyc09wdGY2bFZobklmekRJVVd3SUlMbzVrNDJkT2JxampmcHhP?=
 =?utf-8?B?a0lLQW9hT2RmbWd5SGJOTnFtd09vVlplbkN0cWk1cEJmUDNITExmamcvTURE?=
 =?utf-8?B?QURUdUQ3RjV4YlFJVENrV3F3L1k4VURaa3I5WHo2SHJNYTNxUGp6ZU5nVjdy?=
 =?utf-8?B?blRkeWV3STB6T1J3bG5oNEkyOWR0ZlZ4Yms2ekM2MU9aekhhMUZDT0VKZ2JR?=
 =?utf-8?B?MThmcitnTWU2S1hiNys5aWV0empIVzhPTzRYeVVGUHlZaFYrbzBLZFU5blEx?=
 =?utf-8?Q?+anjmSeMTYTGIJQhnneb5A/Fs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81532364-3125-4388-a169-08dd47c0edc5
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 21:46:50.7228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HbVoSof8uUQaQPVsw7YLLgjL8y1R3ldfhpOIO9zpGN/igYXvaQWKNeuA939jUuhOwmU+T5ExhyPuqgXX2gL5Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6754

On 2/3/25 15:56, Ashish Kalra wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> The kernel's initcall infrastructure lacks the ability to express
> dependencies between initcalls, whereas the modules infrastructure
> automatically handles dependencies via symbol loading.  Ensure the
> PSP SEV driver is initialized before proceeding in sev_hardware_setup()
> if KVM is built-in as the dependency isn't handled by the initcall
> infrastructure.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a2a794c32050..0dbb25442ec1 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2972,6 +2972,16 @@ void __init sev_hardware_setup(void)
>  	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_FLUSHBYASID)))
>  		goto out;
>  
> +	/*
> +	 * The kernel's initcall infrastructure lacks the ability to express
> +	 * dependencies between initcalls, whereas the modules infrastructure
> +	 * automatically handles dependencies via symbol loading.  Ensure the
> +	 * PSP SEV driver is initialized before proceeding if KVM is built-in,
> +	 * as the dependency isn't handled by the initcall infrastructure.
> +	 */
> +	if (IS_BUILTIN(CONFIG_KVM_AMD) && sev_module_init())
> +		goto out;
> +
>  	/* Retrieve SEV CPUID information */
>  	cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
>  

