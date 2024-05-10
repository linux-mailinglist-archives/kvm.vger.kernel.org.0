Return-Path: <kvm+bounces-17210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CA9B8C2AE1
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 22:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA5C01F25425
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 20:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E32A94F881;
	Fri, 10 May 2024 20:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="csGWWaUy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676E44CB28
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 20:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715371444; cv=fail; b=p7OlPKyEgy8RNIUnihwftodGESD/B+bxy2AD6161uDaBV5HGPod87StyJhi9Na54KgbE1L9mwvhZ+qVMMQt89LmDlyfHYpCWbjK2R9u1VLjoFs5mqN6RDIeuBFY6IG6k5bFVNhrjc35/TaXMItxXK++H5r+DP3qRYRfILZ0tiVo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715371444; c=relaxed/simple;
	bh=/BpgNj+23ghIldTFdBROUyQiAgXv9HNueUrYOqyE3V4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QXRGT0DsQ+1Y5y5WGU2JdLEKSO7YRmDgM8aynnjMhrRM+59YSrYHXFbAVeeSaXO7GbWt3MqyjnQymNk94KXuSSaPg6smpL1F+atvFvH8Tsx7RgacW1CcTVUvmQtNucIgc0pzOC5ythLJ/29+bNmYQeVUlRydNoUmobfAdrZ5sxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=csGWWaUy; arc=fail smtp.client-ip=40.107.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlMJLCaVeCLtyVND5ePFpOrtG3wl77vNiv5cNNE3KugyUQ+/xZtew9b0Abxj4rkJ/Ru9SQXP7oU2xayomNg1H4kIk21OX18zG35WKCPITTNXPI9Y5Se707WZeq49uNazj68tp1u//APjy7S65ETLCx88zGpjJF6wSErMTUJRSP1HGLnLDBX9ZxjhTwzqbVOmRN0ufSBE5H7RHq9bki6YaqCjt1bZET19t2OT25kC2prdaLyYlndg5WXdg0oFBAB9yJuPB6M7DbAvcT/mdAwPhW4qnJqJ5DnmQv0HgqsV7WjYkCYFCjLzrQ8gPnZW3yP+LKc5PmSMRZpsbbMo2uNzzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YHLtm0b3qrSPmc7f5sPfQK8maAal2rz21rJj33b340g=;
 b=h1AEHsS5X2ajOx1NMu80pbNCM51vnCvMwEINipcQdnWbFaSJj4Vn9EgF8oV2IuF2LnDG8nPurOYdycNt6AYJaahnu2ILT4L1Rg2p/XwWXiouzujlH6EhSGXnDIPeIc7ILpS3bYiXE8ImpcnbVQlsqZdvPCeSFksYsKMbtt067ZQGmxm3uJpk5FFQVg2regqDFMht5zgyRnI4W+M5GWHbr5CZwjAJbS/o72gR5vOBBCgZhj5r4VvPdLTVzPHEfzkwYFVmanR38DH7Fbd4wpAKjbroRxfla2g++eQMJ9i8T+UD2QYrLlfHoEQ4kJlCsCG1rhjtlGiGUrBY2W7bTOfAeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHLtm0b3qrSPmc7f5sPfQK8maAal2rz21rJj33b340g=;
 b=csGWWaUy5X65HKzt2JeVr3vpvreRruLgX+n0xWE5SBbEneIsslaTodoyYzlhgPJCDne7dSRhwLuMscoEXoGES0qeTrqR+ZMNEYqdXSjOZZpCJT54aqm3LuEGRCZsTN1rdlBKUO2c+56m85QeO87JSSIs46963XsTT/9iqs8+SSU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by SN7PR12MB6958.namprd12.prod.outlook.com (2603:10b6:806:262::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Fri, 10 May
 2024 20:03:59 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%4]) with mapi id 15.20.7544.047; Fri, 10 May 2024
 20:03:59 +0000
Message-ID: <531146c2-9a9e-f84d-1301-8e069785248a@amd.com>
Date: Fri, 10 May 2024 15:03:55 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v3] target/i386: Fix CPUID encoding of Fn8000001E_ECX
Content-Language: en-US
To: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
 Michael Tokarev <mjt@tls.msk.ru>
Cc: Babu Moger <babu.moger@amd.com>, pbonzini@redhat.com,
 richard.henderson@linaro.org, weijiang.yang@intel.com, philmd@linaro.org,
 dwmw@amazon.co.uk, paul@xen.org, joao.m.martins@oracle.com,
 qemu-devel@nongnu.org, mtosatti@redhat.com, kvm@vger.kernel.org,
 mst@redhat.com, marcel.apfelbaum@gmail.com, yang.zhong@intel.com,
 jing2.liu@intel.com, vkuznets@redhat.com, michael.roth@amd.com,
 wei.huang2@amd.com, bdas@redhat.com, eduardo@habkost.net,
 qemu-stable <qemu-stable@nongnu.org>
References: <20240102231738.46553-1-babu.moger@amd.com>
 <0ee4b0a8293188a53970a2b0e4f4ef713425055e.1714757834.git.babu.moger@amd.com>
 <89911cf2-7048-4571-a39a-8fa44d7efcda@tls.msk.ru>
 <ZjzZgmt-UMFsGjvZ@redhat.com>
 <efb17c5f-11f0-498d-b59d-e0dfab93b56d@tls.msk.ru>
 <Zj3WhjDW9YBW7LP8@redhat.com>
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <Zj3WhjDW9YBW7LP8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0157.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::12) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|SN7PR12MB6958:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ac41ed6-d45a-448c-e7ce-08dc712c54c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SkdXVHNYVlhGbUVhSktoT0pBaDBvKys4OXI5S0dkSCs5NFJsK0ZtWGkrSGds?=
 =?utf-8?B?eThlVmdtbCsvVFBmcndKb1grNFl5S2FQNVdaK1RUOHd5T1htRjlRZ3diRkZW?=
 =?utf-8?B?UVpETmN5TEpYNjd3NXg3a25oMmFJdWhZcmFIaDFoUlZYajV2NkxmNHk5MVEy?=
 =?utf-8?B?RkpOMU0rbEk0TVgxQUQ5KzRKeWQraWJka09GbmNmY2VJYUdVUUVHZlo0NG10?=
 =?utf-8?B?NE43em9Jd3lBbUs3cmIxbDdha1FxUHhZcmozbmhvVkZXekd1TjN5VHh0MGhn?=
 =?utf-8?B?NzlCQUE1dXFBaDlEVHpTYXZhdmpXcFc1ZFIyQXNOZHVuMThlbTAyZTFKV0hh?=
 =?utf-8?B?SWc4OWVvTHo5NFdnOHNaQnJFNjhzQjlZZ3lJTzNPZFZodnNlQjBUSUlxVHpx?=
 =?utf-8?B?NTFZTjVHZXlyd0hxQzhCbGRwcWh6WCsvOXphak8vaTdRcU5NN3F6eUJiUTkz?=
 =?utf-8?B?Mm1Sd3ZwZ3JBM3lWOGUyNzJleFlkeWFaSkdJenBuaWsvWUNHSWJndWNKNllj?=
 =?utf-8?B?R2l2b0pxVTJHdEFkWHExeVI2QWhpdFM1ZW1HMEZkd1ZoVklqZnJadU5XK013?=
 =?utf-8?B?SnhMTGUyekdHcThSWExvT2lqenMwQWhiUklzVGpZTmJxSFFLWkI3TEFSMHNF?=
 =?utf-8?B?RmtFK2grTUtZNmhXMlFyMEY4UTZkYm9iMkZtYk9ORDE3aEhaU2VwSmI3NTJ0?=
 =?utf-8?B?NTNoL1pMY1R0Z002dFhreXY5QVEzVkErNVpZcWxXTGN6Mkg0OHg2SCtDQUh4?=
 =?utf-8?B?dzZUaytmeDc0Mmsrc01Ed2tMYmpGSkhxbjd6bjlBUC9BdFVNcHRKT0Fad3hG?=
 =?utf-8?B?QU5xcE1yT2IrRU93RXZGNjczcUkzZGRlVk1jOTg3Sm9IVCtuQ3l4VFJNK0E1?=
 =?utf-8?B?bGJDWjEzYUIzQ2pMSEQrT3ROeUZ6TklLWkp6a3JxV2lBelI5TkxndXRiUndi?=
 =?utf-8?B?ckxBcEZSZU0yL2JEWlhWM0s1VU1VbnZPbWVUK09vL3ZOZUNtRUZEaW9nazE3?=
 =?utf-8?B?R1ZVUHJwVXpFbytyLzZNOU5RREVRUm50TXZsa2ZhTlF5ZllMM0w3SVh0d0tq?=
 =?utf-8?B?YU5rSXp1N0EzME10WFRPNEJibG9Pd1dpNkYyRklHbDE1bTRITXplOVBMa0U1?=
 =?utf-8?B?V2lXTTErZDkyK09zdm5IcEFUNE4ycGtCVmxxemdvdUcxWm90N2Zjak9NYTdC?=
 =?utf-8?B?d0c2bzJqOEpxMG9BRDFBUWZobWtFSXE0czl0MzJPWXRSbFVPWFV2YnZ1VGZU?=
 =?utf-8?B?bkppNTZyUmpscEtzODBDODZNMGVUWTZPZVpvN2ZZdEIyY21YZWJXbzJhTHVQ?=
 =?utf-8?B?SnB3MjRubHMzNU9xbmQwN2l1NjJTYTJvcTFBUHhNTVEzdkptMU5UOHdYbVpM?=
 =?utf-8?B?eWNjN2hVMkdwVlJEM1dtaFFzUlUyR3c1WU9RWmJoYkwzYkI0emxWeDVwT2o4?=
 =?utf-8?B?VTc5SU45MndFK2VWR0hXVGxlZHIzUC9MRkR3dUtrdHdJZk5DTjIrelN2YmdV?=
 =?utf-8?B?YTM4YzBJR3Vma2FiS0FtWDlXcDI4MDJtb3VUS2dkZEJqUmNiS2ZvME5TdlUr?=
 =?utf-8?B?SFY2YXZNdnIwMFNoRTRvN1dTM0R1dUNOVDJVUWdCN2YyVDFrSXRSSzhndUU1?=
 =?utf-8?B?Z25sZHd4YjVKK0lWNmtPVE5Nbkl1SVl3ZzFUSUl2L3dBbjdyMjBKUzR2cTNy?=
 =?utf-8?B?MysxUThUaUdGNWZjSHFSL3JMd0c0Myt1QW1wdU1TVkZxbEI0b05ITUZBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rzl4Sm5rOEEyYmJiTTBHeXArR2ZOT2ExSXlKaERRenJxNXFRWTk2RnJScGto?=
 =?utf-8?B?OWt3ZVpaVjlsOXRXRlN3SEdpeWpxOWFVd0lISnZsVlEyNytQSjh1V0dnK0Rq?=
 =?utf-8?B?MWdaUVhxR1RRSUl4U0tkaHdFUk9WTS8wYmNtYW5uVDVtZWRCa3FuT001bWRa?=
 =?utf-8?B?TDJWRGd5YmNuUUQ0U1d0SDREa255UFhjSjBvUDdaZHRXSm93VmxhKzR0bkZ4?=
 =?utf-8?B?QVExVDVFL2IvdHU3WTlxcHFmQTRia2Z3OFZDWSsxV2JtTVNwa2loRXdOWnlh?=
 =?utf-8?B?b05GUjZTUE9OejJlODlDVWVmYlBhcnZpVFBwT0xQL3lqWDREd1hCcG5yNXdu?=
 =?utf-8?B?NzBvQTUrYVdWMHJFNHVrTVVhejN4Q3VDeTZ2b0lsZnVNQnRjU0xjN3NQbVBR?=
 =?utf-8?B?OEZsWGVDSEhxQXRBblNlNk5kdlJrUitsWC9Nb01DQVZ3aGIrS09KM3ZUV2NQ?=
 =?utf-8?B?K3ArVkQ0MExzb3Nkd1d0QllwTFlGUXk4OE9DRURrR0FIN29zc3BsTld1ZmJM?=
 =?utf-8?B?UlZYeFNuZHBxa3NzbnY0VVdQL1pscG5YRVFFcGxqTnNob25nOWc0Um9iK2gr?=
 =?utf-8?B?aFpkeUxMZDc0Z2xWVjcvbUVWRld4Nnd1TnJqRVh0dXFHVTk3YkNNdW1PQjZF?=
 =?utf-8?B?aFNUUlVmQzFaQXo0MVNqUW8zZTZiTmRiQmNxOW9ITmVoajR5czllUVVoQlY0?=
 =?utf-8?B?aFFYR2UrYVR5cHBOcEgweHVxeUFxanVLWXZqVXRXanUrOHRMZTkxUnNRRVhm?=
 =?utf-8?B?VlErcTc1QnQ5S3JSRUdlUkcySjhlb3JKTXAwWlNTak45VGxIejd0akJhdE9T?=
 =?utf-8?B?dzFTWmhVUzVzeXp6b2JUS2thVExhN09OdmNjQk9FZXVMRktuL2daK0dnMFgz?=
 =?utf-8?B?Z085ZEF6MzVtSkF5eWEvTTJUWjZwWUJ2V21Na2gwaVJPK3c1S1VCUXFYanFs?=
 =?utf-8?B?L3VrTFFNem51ODBHbDNFTE1jNGU1VmR6dnhRY1ZKcllTUzcrZENHaGludWJM?=
 =?utf-8?B?UVkyMlorSE93Wks0aGI1MW5FYk9ycGxHV1pyeDZMZmRRWXQrb2hvMmFyamFn?=
 =?utf-8?B?eDEvWWpBRDNVSGhsdUJ4SC90UnBuRzdSY21uMTZMM0dqKzZtc2JrTnVINk4y?=
 =?utf-8?B?T3d6Q0FOLzFFK3ZzQlVSM0R3MzF6dm8zVHlxTWFZa2pHdG5STUlvaVUrakJN?=
 =?utf-8?B?bng4bzhucHdBZVlrSWlkYVZHZmVSOHVRbno2TVZyK1gxc2RmMGJ4akxpK1hV?=
 =?utf-8?B?ZzVTakY2OWkvWTZaZnNpTjFsN2ErRmVzMHM4TGlwTHZJOE1PcE80Y1N6NW15?=
 =?utf-8?B?TzhITUFKSnJ1ekFSc0ZFSUlQU1c1cTFCUWpJZmVna0htbzlOOENhUjVoRVEw?=
 =?utf-8?B?bTJKS0t2NW9oYWhCTkM5Um9JVEZTZGJ2OFViZ0JMQVZXTlpjQ3JvbjlDSFBO?=
 =?utf-8?B?TndDUWppQ1pFL0djd2FHUUZLR0NycFNQaHk0UG55Umt6aEY0d3BaTFQyUkpI?=
 =?utf-8?B?cGdCM0FRc2xZcktYUW9xUW0rNHQ4RDdlZ1h6ai8vY1dYallldDBObmozN05M?=
 =?utf-8?B?UkZpR0dydTBkWFZPd2Q1U1hENTQ0L05mOFN5SmNYMnhRMWR6WVdpb092Qkdr?=
 =?utf-8?B?R0dVWXkvU0xjbVZoeDBSaitSSnNKSkRSYnIzU0dxRUl6eW9BVUlyQkRSTDBJ?=
 =?utf-8?B?ZVZ5SlhKYjNhbUFqcWdpWldxUVVCWlhqVjdmYzFxendHK3k0aXhidUsvYnhv?=
 =?utf-8?B?OFFXNEhYa1VsZ0JGT2dPbUNpRE9lV2YxMTZlY0x5SFVJekU2M1dWd3BpMzZN?=
 =?utf-8?B?OXAzY0hpeEtHS3llY3BCV0c3TFp1T1ZnYTBWTHU4NEVyODE0SERZN3E2WHls?=
 =?utf-8?B?ZVg5SlBPRDVjaWZUQ3k2UnVRWDFRSjdGODFWWmxtWFJwNUFmTkcwTU1JN1dY?=
 =?utf-8?B?KzJJbkdzSFBVYUh6eXUxY1E3TlBRNVR3cGVqZ25RNFhBdlNRc1dNYWFDbG1w?=
 =?utf-8?B?d2t1anBvQWh5T2NuWmVQbXVFdGhsOHc2Q3d5NHZlOUovL0JUVWZGKzVEVDZT?=
 =?utf-8?B?WjhETEdCNSt1aUpHTWNiVjc3RFIvNE9RMkVqVVRneElWK2dxeS9idXlnMGVQ?=
 =?utf-8?Q?DAIc=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac41ed6-d45a-448c-e7ce-08dc712c54c0
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 20:03:59.6131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2B/SR5ANpEMgCTNxRs41VZbqiXwlFy/7HGVcu4tUOpilQWt/tbHgjYqoPkwpbs+X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6958

Hi Daniel,

On 5/10/2024 3:10 AM, Daniel P. Berrangé wrote:
> On Fri, May 10, 2024 at 11:05:44AM +0300, Michael Tokarev wrote:
>> 09.05.2024 17:11, Daniel P. Berrangé wrote:
>>> On Thu, May 09, 2024 at 04:54:16PM +0300, Michael Tokarev wrote:
>>>> 03.05.2024 20:46, Babu Moger wrote:
>>
>>>>> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
>>>>> index 08c7de416f..46235466d7 100644
>>>>> --- a/hw/i386/pc.c
>>>>> +++ b/hw/i386/pc.c
>>>>> @@ -81,6 +81,7 @@
>>>>>     GlobalProperty pc_compat_9_0[] = {
>>>>>         { TYPE_X86_CPU, "guest-phys-bits", "0" },
>>>>>         { "sev-guest", "legacy-vm-type", "true" },
>>>>> +    { TYPE_X86_CPU, "legacy-multi-node", "on" },
>>>>>     };
>>>>
>>>> Should this legacy-multi-node property be added to previous
>>>> machine types when applying to stable?  How about stable-8.2
>>>> and stable-7.2?
>>>
>>> machine types are considered to express a fixed guest ABI
>>> once part of a QEMU release. Given that we should not be
>>> changing existing machine types in stable branches.
>>
>> Yes, I understand this, and this is exactly why I asked.
>> The change in question has been Cc'ed to stable.  And I'm
>> trying to understand what should I do with it :)
>>
>>> In theory we could create new "bug fix" machine types in stable
>>> branches. To support live migration, we would then need to also
>>> add those same stable branch "bug fix" machine type versions in
>>> all future QEMU versions. This is generally not worth the hassle
>>> of exploding the number of machine types.
>>>
>>> If you backport the patch, minus the machine type, then users
>>> can still get the fix but they'll need to manually set the
>>> property to enable it.
>>
>> I don't think this makes big sense.  But maybe for someone who
>> actually hits this issue such backport will let to fix it.
>> Hence, again, I'm asking if it really a good idea to pick this
>> up for stable (any version of, - currently there are 2 active
>> series, 7.2, 8.2 and 9.0).
> 
> Hmm, the description says
> 
>    "Observed the following failure while booting the SEV-SNP guest"
> 
> and yet the patches for SEV-SNP are *not* merged in QEMU yet. So this
> does not look relevant for stable unless I'm missing something.

I have not thought thru about stable tag. This is not critical for 
stable release.

If required I will send a separate patch for stable later. It is not 
required right now. Sorry about the noise.

-- 
- Babu Moger

