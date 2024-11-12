Return-Path: <kvm+bounces-31625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F28849C5C87
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:57:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B24312856FA
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 15:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E57F205E0D;
	Tue, 12 Nov 2024 15:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ILv0RRJP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5D4202F73;
	Tue, 12 Nov 2024 15:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731426808; cv=fail; b=XxcEY7esKhvQOGqIbE8SY85Q2i/zYzUcmVJ8a6XW7s+4HNgo1Wf0sCUqBirqsKjZLww2qJROQPmSVHipv//kNrnS5/TeeocsW5kHsS2+lRr13PUAm4sIxa/+FH1o7RqtijdEdO9iJEsU1AMtbd4eiQEoQEJUT3GQdFqMPgPm22A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731426808; c=relaxed/simple;
	bh=w+OcG/ClGgS4shaJzcH1CEptF6cwEsovZwWUP5kiD7k=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=IcjKD2aDwu3El9IqBHcFFo6h6Fyhg/AoJSRU24Ba/SvoCs+JpSpiP1QR8bv/SZ165ZXavxPKfboMOd3MOJOFLV2VLu3RjUjNCaK/BAovUe/dq0AJV6LF0B7DyEQDjWIJb/3eNBOdcYlDgVI9sxN7tTC1KiMGJpF7mdkjatKutUw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ILv0RRJP; arc=fail smtp.client-ip=40.107.92.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CNRWUnxaUA7uo9rq5oO4IwGy4I4hum7XYwkMDf/hqvoG3qpBxZiuuk4/qKTX8WNAXfb2bLB2Kl8zqd4DH8RjtvhZSpEbS34X7mUaSW7uchcWRuto5tGkhXPzCFcCAkNC+jv17nJVeMKHjz1q9iBvocpRz86KLWAFDLlMyMESmW5Pu+0kaBGdW8wrUKzf7pNa4AhlvYV1SkUsp+A1kpxhtGMMK+uD17sSHgKfeWldPRB4xtZN3I/zmhDGcfwf6QzsMKPnsa5vzE8v2hccmewuOY52neaLKmMmXXkGYWAVw2y1Yoe/3zOfNEMYwYrSMvvsfefJyZPCaMOUDaNG8+EkGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CRtlE338xAG0vzkkObetKTzEHvyuFN32s6zrZ3sTBo8=;
 b=mNc+ABzMCye1PAYN6rHeR/k4N9a+FKbS0cIjdnhHG5U8JnqV9Mm8rSD4xVFK+nOcXMiYfSUtVKBz2hxfVoG2c56iIu1LaYhMQqvGoCgFA/XUllsvNsg9i37SYt4f44IC9fZyD2Ff9+/wCtRLxmI2iZHFALadxn0QthUYm8+Z2HA+Ww9tByaEjahHTJSyGpHMmSVbR8hJdutPX/qrPsCFaE98CMu0to5XZMRO8drpMhPPmkmWuSuBO0+TspA9+uDBQwx4Z6AJ328cXPASlv9A+91WHAnMbzZO++n9lbPXvQNXHmfNZOfYUbSGLRFg1gA3rvgdizJmpourryWAaP3vQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRtlE338xAG0vzkkObetKTzEHvyuFN32s6zrZ3sTBo8=;
 b=ILv0RRJPHLDxlJTnEzA2gsukx6FqVF3h3lcn83a0ZdaueZsnzpTPE91+5kfdsJfyrpuzFu+qy6CSo/eLeCE2WJlfjENZh/NBq/CnYuL1AqQFh/aJrIoDtL++UWyZziBgwhOTxIzK1YgixvYgbitNs+SPcIgbjOhE2FsE1p3zf6s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB7655.namprd12.prod.outlook.com (2603:10b6:8:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Tue, 12 Nov
 2024 15:53:21 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 15:53:21 +0000
Message-ID: <43be0a16-0a06-d7fb-3925-4337fb38e9e9@amd.com>
Date: Tue, 12 Nov 2024 09:53:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-coco@lists.linux.dev, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Michael Roth
 <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 kvm@vger.kernel.org
References: <20241107232457.4059785-1-dionnaglaze@google.com>
 <20241107232457.4059785-10-dionnaglaze@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 09/10] KVM: SVM: Use new ccp GCTX API
In-Reply-To: <20241107232457.4059785-10-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0067.namprd16.prod.outlook.com
 (2603:10b6:805:ca::44) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB7655:EE_
X-MS-Office365-Filtering-Correlation-Id: e3e22143-2fc1-472c-4e64-08dd03322245
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?em5tVWN0RXFtMDMwWVJJWFhEOHRNcEgzUlNGSDFCUGIycWRRR0NRZ09WRWdC?=
 =?utf-8?B?M1BzVTNIdFdIWjRDVlYvN25BOFNWM09GeFhTTEpyTDhwNmljZDAzYlpzQzBp?=
 =?utf-8?B?eGZISDVBQ1dSZmM0Z0gwQXE1anB5cWI4c3NsbmR1MGJvcFVScFlxS1poY1N6?=
 =?utf-8?B?ZXNmV1lGNEJtckRvZEdSOG52aEpFVFNnN3ZoT0lqVXNWQ2g5TStWUER3YzJN?=
 =?utf-8?B?VHVMdDFLUUFZYnFhNHJQRU9hZzZYTy9ZaU9nUFZSZUF3TUNDMCsvZlZEMG1r?=
 =?utf-8?B?U3hjYk8wdng1NVJNVGczNTdMcDVQUFBoYmhocVdmdTliakg4Rnp3dmJjT3lh?=
 =?utf-8?B?L0RVNHorTDQwUDlmM2Fwdld5cCtoTzNZWmtRTisvcUlNR28ySUlqeUVVMlJL?=
 =?utf-8?B?Ync1ZVA1UmNxaVhVdlVmTGN4RUU5ZU5odkJrRGRSUXYxUm5LNTJVQmFLd0Vm?=
 =?utf-8?B?N0ppWWRielYzYWtrMnZjM1laVnpSdUdIMFliQlRnUitiYmkwdjJUTkVNQm1I?=
 =?utf-8?B?bisxaFdXMkxvY1EyRytlL2gyWVg0cjdrNW15c0FpTUlUR2p2ZjBvZ2xKTWph?=
 =?utf-8?B?dFRLZDROT3YzM2tlTjNFdEdnNzd1MXBkOHFPVzYxaHhXRmZreHpXNHpRdmxj?=
 =?utf-8?B?ZWMzQlcwQ2hiSmZwN2o0M1o3eGIyQjJJK2FZU21BQmpQN1VqL2k4M1RkcU5W?=
 =?utf-8?B?ak9yZkdBR3NiYVR3S0Qyc0w3ZndzVUJwd0dDbnpCdmkzbnpFRWNHOXVuVnAw?=
 =?utf-8?B?b1QxVjJvT25BSy9qbDRwNDdLWkYxTHZJZ1Nmc1dheHhONGxhS0wzQWZ4Z0dO?=
 =?utf-8?B?NTZSeTlKZTR4aGE0MElQZi9vcGhHQ05CaEhuMGNnVzlRQ3JLdElPWDlUM2k0?=
 =?utf-8?B?UklkMnRPS0cxSGxKVVNWaE9xTjREL1hrZWR1ODFpUlBIdHFub3g0UmtZYUs1?=
 =?utf-8?B?ejdjZUkvQkl2TnRCdGVLVmorRkU0RjJaQys0VUptSDlpYkpoMXErd1JveWtW?=
 =?utf-8?B?WC9GTVhjREVRSWFhRmNNZDE0NGNwWk16VWh3RDRIQUZueDkvUXh3Z0VzbS9n?=
 =?utf-8?B?cDNmQXlkeHdGSkw1cXVKczE0U0NlcENVMnlkL0JKM2xkdmZKWWFHdTdvdTI1?=
 =?utf-8?B?UTlZQjJqL2NxdVBKV1FwQ0J1ejJFZEZJdy9YaVhEblFrQ0IrcnNaQ1l2Vm1h?=
 =?utf-8?B?Yi91TEI3WGdzOE1GelVSVjIvRlRaVU5FOWlwZythNkc4NjlxS2Y5aXBIdzI1?=
 =?utf-8?B?QlFGcVJydTVkQkNCNVRzcVl4bG9rakdnZnZJYW93Zm5oWTlRZUFnNlh3S0x1?=
 =?utf-8?B?T1lTeis1Vng4aHlhc1BwOVhiaUdiTmNKcTZ0cUx1TXh6K3UwaThzR25HNW9R?=
 =?utf-8?B?MlI3TVRxb2NMOGVKU29hVlRDb05BSUxBTEJXS1ZlYWdzdWQwMThITXl3NTlj?=
 =?utf-8?B?V2lwZzdKUWdiZ2NGWndVbnc5K3JMUE14cGVienptSU5Zc2xuQzNLN0h1WmdZ?=
 =?utf-8?B?TWJOVUs5b3diUjhEYzJHY1czVlFzOUhDQXdROVU2akFNLzNLWGNYNUUwTzJB?=
 =?utf-8?B?UUpDVjVvSFhVZk9USjErN3d0T1FiVXVZK0poa3VWRDMyRnh4RE1YVmdhc01q?=
 =?utf-8?B?WGRGRGc1Rlh2ckdHUFhJZll0SEVwUVhnTUFVbUxYVlgvK2tPdFN1ZlFualll?=
 =?utf-8?B?OGwxMitMSUcrc1hMU3NMMlVBbDJXei9ZbUhtVEVnM1RieE5IN0VCTmNVYSs1?=
 =?utf-8?B?dUg5ZE85QmVVUisvei8rWG9MQUorbjVQbmUwZ1pHbUFzNHB1QWxrY3FaSFVD?=
 =?utf-8?Q?ZsgCNp84C6/r80O5cvD8uG2eJCvERl+sdTJe8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aU8vUno1T0xlRjEvdmRqSmFxZHBCNnNKZjcwNmJYQTFUSlVUTUU1N29YdkN2?=
 =?utf-8?B?MTY5Y2Y4WW9EVlA3VzJ0aTA1RHk1d3E5Y0tBd1BPWlp0cE9QR0FuU3pjREl1?=
 =?utf-8?B?cnZtWDVCVDNxam12dWwxdEhQWE5PR292ZzFPU21ZSXpQTStUM1NGVERoaHlL?=
 =?utf-8?B?bHJjTEdKQXBJNXQzQ0VodjIweXBRQU12RmxHWC91d3dTNkp4SWt2ZlFYSU1y?=
 =?utf-8?B?aUxuSnVDaXpiVWc5Y2dJem84SU5CL1ZqZVdoV2RpMXZQVmFxSzZ6U2VsWUx1?=
 =?utf-8?B?U2M4eXk1eElyb2RCZER5eDAxT1g0aitrd1hJalJ5RXFsSGxDaGRHYjMreXlG?=
 =?utf-8?B?ZFNxV1RLZWNZVGxyK1JTVlhsbGcwYTB6RUVLTmZxMS8rVGVNaVBBdnhkOUMx?=
 =?utf-8?B?U00xbTFGcmNnTUhsKzg1elNLcm5JYS9zSjk2Rk1JRTFueGU3SlRGN254S0Zx?=
 =?utf-8?B?QkFsMDhHSEZBOU00bUxFSTM1UERQTmc0YzBmazRuclRGaHUrenZFcnk2Z1J1?=
 =?utf-8?B?QWxyemViMW9tM1cydXpsMkxmWlNyQUFsbHIyY3FDTUhpcHcvUTNHYkowZE05?=
 =?utf-8?B?ZDBaMm9YNHpPbmVFZ3c5Y3ptdVA0SkdvbTdScmVZck9ic1JSbWo1ZGR2YWd4?=
 =?utf-8?B?NGsyaHk5VGhUcjFEbFV1dUxvb2RNOGdSOHBjUTFPU2wzSjNraFJPRGtHWXln?=
 =?utf-8?B?ZXJNREZ1M0lNTkFieTZnRFMzaUtuUlVObmhWZ2Y0bVZIYnA0aUwwRnQzOU5y?=
 =?utf-8?B?MUZtRjcvK0ZxSnRHeUtZbUhlbnozZ3FSeHRreUhIamJ0QVFWb0FKVk83U2FV?=
 =?utf-8?B?SEJSL1NubGJEVlFualJqZ0duQ2J3Q3NQempPbG9xZm1PUVM1czZmbEo3eFJu?=
 =?utf-8?B?UVpkU0VxazgrKzBSZnR3WXNIUnMzWlJhM1J1ODhjWWtWTThrYWl5dFZhM3Bk?=
 =?utf-8?B?TXpuQ0ZvUlYvdUFFNURKWjhmNUxSbWtrd0F2TFN0eUlFaXRRV245MlcwNGxw?=
 =?utf-8?B?NlluenZwRXFaMlJiVUpMejZDZ2pJc1dldkZlcWU1YllJS3hIdk42OEFnVlR0?=
 =?utf-8?B?aGNvM21UZWY5ckZQUzZlM2NubE1Gam5oMkdHcm1EblJVdDdmdWhjV0tQUlIv?=
 =?utf-8?B?WXc0KzBuY1V4S25JNXVxOTMrdTk5UG9vbldvZlZ1UlBFcGNqVkJTOFZMM0hQ?=
 =?utf-8?B?QzZ5L21RczhKb0RjNUdoWENVQUczRG5zVlV2SXJFY2lJZzd3MjJIdUNqQ1g4?=
 =?utf-8?B?YmlPOWYySzB3MVMyMk9LUlJHMDhRYUdGeVg3ejBWUjFWRmtwTU8vSkJscWxv?=
 =?utf-8?B?OURUUjMzUHpWR05SWVRKWTk1Ym5CNzVEOGxESXR5QklaMDB4M0l2ZkhNT3d1?=
 =?utf-8?B?a0lTT3g1Y0J4VHNEN1l0czhMci9tTll2bmFkcDROOUNURVVaWDhpV25TVS9j?=
 =?utf-8?B?NUVYYzVVU0dkWUwwRTdFR3g2b0hnKzVGalE4TW01aGNKcXYyZ1lNNUdCYlcr?=
 =?utf-8?B?WHVrUDVhRWhUNnB2SXJ3WWI4VUJFSVhCNHRTWGdjZ1NjNk54UnhHTmVMZng2?=
 =?utf-8?B?dEdHekNFM1kydnJnelZvK2FHY0JlalhZQTNzL1RKOTk2VExKZWhGcWcxbUNL?=
 =?utf-8?B?L2NpWGFFMU9RbUtVUjlSaVBUcEpvN3R0MmxtN0RscWtIOCt5TllGTmxwSTFm?=
 =?utf-8?B?VEd5djBLRDdQRzJFUGdOS1JhazRtUFU1Slkwbnl0MVJTRmg4VXhPSTRLbjZE?=
 =?utf-8?B?WXNTY2dRYnN3Y3d1c2pEdDR5OUFFR3U2cTlFSytEbXVHbXRoQzVhbFBRbWts?=
 =?utf-8?B?UmVCNk4yMldXZEpnUnh6WDYyZ2ZpcllPaCtXNHYyL3A4OCsyL2ZHaUNoR2tI?=
 =?utf-8?B?aVZIQ1o2bmNtSHA1Qzl3TGQ3SS9ybTAvTVByR3JISUw1ZXpBRFU5aFcyLzd6?=
 =?utf-8?B?eE1xL1Erb1JuamROdWZlSWJUdHB2djR2UUlsTlhhRS9nR3JOb1BqMDV1N05M?=
 =?utf-8?B?ZVQ0bXVaNnYyYVkxZlFvNnRaUXJQV01INExmQ1htZ043T09KTHR4RG5US1k4?=
 =?utf-8?B?Zm5oU21sMkRYaTcrZjdONkxZM3RwcTRyT0FOUnRTUGtNNGpWcDk3UFhWeGNW?=
 =?utf-8?Q?/Xam7Sem5p+xIJ5KB++maBGp5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3e22143-2fc1-472c-4e64-08dd03322245
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 15:53:21.6628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r0popuZbik+CBJPS9tHNnikkVEV8Lp0bW0NIqs/VXHtk9+jaDPC2Zms/RYFBhz0eqtkJ8x4bgLF5YMH7k5Blvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7655

On 11/7/24 17:24, Dionna Glaze wrote:
> Guest context pages should be near 1-to-1 with allocated ASIDs. With the
> GCTX API, the ccp driver is better able to associate guest context pages
> with the ASID that is/will be bound to it.
> 
> This is important to the firmware hotloading implementation to not
> corrupt any running VM's guest context page before userspace commits a
> new firmware.
> 
> CC: Sean Christopherson <seanjc@google.com>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: Dave Hansen <dave.hansen@linux.intel.com>
> CC: Ashish Kalra <ashish.kalra@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: John Allen <john.allen@amd.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Michael Roth <michael.roth@amd.com>
> CC: Luis Chamberlain <mcgrof@kernel.org>
> CC: Russ Weight <russ.weight@linux.dev>
> CC: Danilo Krummrich <dakr@redhat.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: "Rafael J. Wysocki" <rafael@kernel.org>
> CC: Tianfei zhang <tianfei.zhang@intel.com>
> CC: Alexey Kardashevskiy <aik@amd.com>
> 
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 74 ++++++++++++------------------------------
>  1 file changed, 20 insertions(+), 54 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index cea41b8cdabe4..d7cef84750b33 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -89,7 +89,7 @@ static unsigned int nr_asids;
>  static unsigned long *sev_asid_bitmap;
>  static unsigned long *sev_reclaim_asid_bitmap;
>  
> -static int snp_decommission_context(struct kvm *kvm);
> +static int kvm_decommission_snp_context(struct kvm *kvm);

Why the name change? It seems like it just makes the patch a bit harder
to follow since there are two things going on.

Thanks,
Tom

>  
>  struct enc_region {
>  	struct list_head list;
> @@ -2168,51 +2168,12 @@ int sev_dev_get_attr(u32 group, u64 attr, u64 *val)
>  	}
>  }
>  
> -/*
> - * The guest context contains all the information, keys and metadata
> - * associated with the guest that the firmware tracks to implement SEV
> - * and SNP features. The firmware stores the guest context in hypervisor
> - * provide page via the SNP_GCTX_CREATE command.
> - */
> -static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
> -{
> -	struct sev_data_snp_addr data = {};
> -	void *context;
> -	int rc;
> -
> -	/* Allocate memory for context page */
> -	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
> -	if (!context)
> -		return ERR_PTR(-ENOMEM);
> -
> -	data.address = __psp_pa(context);
> -	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
> -	if (rc) {
> -		pr_warn("Failed to create SEV-SNP context, rc %d fw_error %d",
> -			rc, argp->error);
> -		snp_free_firmware_page(context);
> -		return ERR_PTR(rc);
> -	}
> -
> -	return context;
> -}
> -
> -static int snp_bind_asid(struct kvm *kvm, int *error)
> -{
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -	struct sev_data_snp_activate data = {0};
> -
> -	data.gctx_paddr = __psp_pa(sev->snp_context);
> -	data.asid = sev_get_asid(kvm);
> -	return sev_issue_cmd(kvm, SEV_CMD_SNP_ACTIVATE, &data, error);
> -}
> -
>  static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_snp_launch_start start = {0};
>  	struct kvm_sev_snp_launch_start params;
> -	int rc;
> +	int rc, asid;
>  
>  	if (!sev_snp_guest(kvm))
>  		return -ENOTTY;
> @@ -2238,14 +2199,19 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET)
>  		return -EINVAL;
>  
> -	sev->snp_context = snp_context_create(kvm, argp);
> +	rc = sev_check_external_user(argp->sev_fd);
> +	if (rc)
> +		return rc;
> +
> +	asid = sev_get_asid(kvm);
> +	sev->snp_context = sev_snp_create_context(asid, &argp->error);
>  	if (IS_ERR(sev->snp_context))
>  		return PTR_ERR(sev->snp_context);
>  
>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>  	start.policy = params.policy;
>  	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
> -	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
> +	rc = sev_do_cmd(SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
>  	if (rc) {
>  		pr_debug("%s: SEV_CMD_SNP_LAUNCH_START firmware command failed, rc %d\n",
>  			 __func__, rc);
> @@ -2253,7 +2219,7 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	}
>  
>  	sev->fd = argp->sev_fd;
> -	rc = snp_bind_asid(kvm, &argp->error);
> +	rc = sev_snp_activate_asid(asid, &argp->error);
>  	if (rc) {
>  		pr_debug("%s: Failed to bind ASID to SEV-SNP context, rc %d\n",
>  			 __func__, rc);
> @@ -2263,7 +2229,7 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return 0;
>  
>  e_free_context:
> -	snp_decommission_context(kvm);
> +	kvm_decommission_snp_context(kvm);
>  
>  	return rc;
>  }
> @@ -2874,26 +2840,26 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  	return ret;
>  }
>  
> -static int snp_decommission_context(struct kvm *kvm)
> +static int kvm_decommission_snp_context(struct kvm *kvm)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -	struct sev_data_snp_addr data = {};
> -	int ret;
> +	int ret, error;
>  
>  	/* If context is not created then do nothing */
>  	if (!sev->snp_context)
>  		return 0;
>  
> -	/* Do the decommision, which will unbind the ASID from the SNP context */
> -	data.address = __sme_pa(sev->snp_context);
> +	/*
> +	 * Do the decommision, which will unbind the ASID from the SNP context
> +	 * and free the context page.
> +	 */
>  	down_write(&sev_deactivate_lock);
> -	ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
> +	ret = sev_snp_guest_decommission(sev->asid, &error);
>  	up_write(&sev_deactivate_lock);
>  
> -	if (WARN_ONCE(ret, "Failed to release guest context, ret %d", ret))
> +	if (WARN_ONCE(ret, "Failed to release guest context, ret %d fw err %d", ret, error))
>  		return ret;
>  
> -	snp_free_firmware_page(sev->snp_context);
>  	sev->snp_context = NULL;
>  
>  	return 0;
> @@ -2947,7 +2913,7 @@ void sev_vm_destroy(struct kvm *kvm)
>  		 * Decomission handles unbinding of the ASID. If it fails for
>  		 * some unexpected reason, just leak the ASID.
>  		 */
> -		if (snp_decommission_context(kvm))
> +		if (kvm_decommission_snp_context(kvm))
>  			return;
>  	} else {
>  		sev_unbind_asid(kvm, sev->handle);

