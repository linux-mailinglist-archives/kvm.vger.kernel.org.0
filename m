Return-Path: <kvm+bounces-53028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E78CAB0CC95
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 23:27:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AAAF188E25A
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 21:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8665C23F422;
	Mon, 21 Jul 2025 21:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aF0PQoJU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2069.outbound.protection.outlook.com [40.107.101.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3357815530C;
	Mon, 21 Jul 2025 21:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753133266; cv=fail; b=jRp3ApUfa1Gy9X+ksKMCq8xfVKELyw4hHQ6UzQLurlHLN1kSLUlLxMA3SuQ0WHhry7acaenBVLMP0CTjUshUhw5M/u4isTUSSwZTK4bFkTp/eCHl4kixY7DkJVL9PDeKdFqeqqJJFmf4MmMfshW+kOgMZW5nPEYnoysXA5LoU9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753133266; c=relaxed/simple;
	bh=r2bjEb0rRq2y40oDSwCFWkhW5S4hUwGq2GeUofRS/Ew=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CQ3HLfldQlZXYUut5cQE5dKeen16+oO+WonR8mzxX34SzqVAbJwURitTQq7JC4lKZdIUHQZ7sB5VlsnAHPoyoCgao2B6Pfvi9bGOo7m0rD8QXuMvq2SieRD4GqSfyaotWHJXizPXlpoBywODkE/UO6Wz3pX4FA/GBuVK5sTU7B8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aF0PQoJU; arc=fail smtp.client-ip=40.107.101.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dJcDv1aqivo29bo8tXtm/EC5Qxo0fSqK9keiCsRkbaJj3TFVvhoE+6VPdc/A7UVWii3TEvLv3EycvcTOpl7dmaV2BSkXEpdI19JcsNfH2AcVOnXLwTVOY+JOg1lrDEqvXC85BHBg8o4FtYxn6/COLe1Z+tbuqk+ERTJuvBdG4+pH1yGGgdCNtrMAku1bHo+DD5coTgJmaktXaF+4sK+4cNEQwRcWIk9p7wovqOmz6VdFPtMrCc6S7vUiW78ML/yTCRwV1E42CorpRD96yoZodYcPbMPEaIOvQWGB/oNh/9TQugzIcThsWbmaq8hmUAlkKZYJRqYCjy9Ve4tL/rKNBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ekhvpjcLcg8vg6jBJBmg4X1jS6AbDbwrptxMNhdWNxk=;
 b=t0r6Ld96X5RKTeROk2NJrBHNO+SYxl7z382BJ5+oFavwJy0aYXUuDHrcEjXomKkk0/hOYoVu/Lqbe1YfE91bzhjmurYQ5iTzDGtjRoe3JhlSllWB1/EbXSODq02b1rEoX2cxSXsiD2IFo19istk/tsfKKQN6nR2KwGYMbjPIebVMg+0NkFMFiD8ObKTVjsiV+uqBTQtH8iSfZu6PsOBXiFrE/7ncV+xpYlgR3NTWW8oOb/Uvm/zI0T7HL7Ky7KVAJNpMSOWGrAADcsZ1Pr4E3Xlpx/6AzV7ujerkrJFwBHR0EzX2HqJxN2Ua6LqV5T9B7P+QCU8qFebr/wLhUS9PfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekhvpjcLcg8vg6jBJBmg4X1jS6AbDbwrptxMNhdWNxk=;
 b=aF0PQoJUpNDg1v0cdDATWsrQwmreIvml1u9AFU7RMDokkXXXpr4QPR0Va1ima6Axoigs9VTzVyM/3qLWSm8Y5UB+EkKrqlIra3TBSWkwrBsMf/TTI4MITuwUMU7mgzPStD1MmobACL6EQ2erZbspw+jIxmD0GLuUGU/KLOsXFTU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MN2PR12MB4334.namprd12.prod.outlook.com (2603:10b6:208:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 21:27:43 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%6]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 21:27:43 +0000
Message-ID: <7eb254a7-473a-94c6-8dd5-24377ed67a34@amd.com>
Date: Mon, 21 Jul 2025 16:27:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Content-Language: en-US
To: "Huang, Kai" <kai.huang@intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "Hansen, Dave" <dave.hansen@intel.com>, "mingo@redhat.com"
 <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "hpa@zytor.com" <hpa@zytor.com>
Cc: "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
 "kas@kernel.org" <kas@kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "sagis@google.com" <sagis@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>
References: <cover.1752730040.git.kai.huang@intel.com>
 <c7356a40384a70b853b6913921f88e69e0337dd8.1752730040.git.kai.huang@intel.com>
 <5dc4745c-4608-a070-d8a8-6afb6f9b14a9@amd.com>
 <45ecb02603958fa6b741a87bc415ec2639604faa.camel@intel.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <45ecb02603958fa6b741a87bc415ec2639604faa.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0106.namprd05.prod.outlook.com
 (2603:10b6:803:42::23) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MN2PR12MB4334:EE_
X-MS-Office365-Filtering-Correlation-Id: 35bed00d-3b1c-41f4-d3fb-08ddc89d6d6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aGxwVW04UnB6U2VUaFpnZDVOZGNpS1dYU0lRRUNsVFpoV3AvYjB6ZWU5ZnZt?=
 =?utf-8?B?SVRtS0dZVXkxRjBoT29pUmJNK082K2RqYzE1aE52TDJoNmk1U0JHTERLZGhq?=
 =?utf-8?B?Qngrd1IvcG9wbGhmZTlhZTJHT0pzZ3JMUUNSbGdJK2R2U1RHZlhBLy9tMnVU?=
 =?utf-8?B?L2hxQitxTG85K3ZTRE1Nbm5BL3dPTHdNSGNuZXg2d2lXS2pncFJmTlFrK3Rj?=
 =?utf-8?B?Q2thVlZ1dnhySmxlYlI2Zk94a2w5SlkwUmV3Q2VpK1BxQ1FkSytKa2h5dVM5?=
 =?utf-8?B?ZWNuRlErYktXUUhiY04xcG8zaEhPc2VkbExmeHQvZklybG82b1VhS3hZcjhN?=
 =?utf-8?B?anJJcGtnWmxKK0JuTWVwMkZxbTEvY2dUaS9va3BrcGpsRDlnVGJ2RDNmcnhE?=
 =?utf-8?B?UWZQUENvMER3ZGdtR2g0OFhMVDFSOVQ2U1g3QVhXYmxZVnZ5MUhiVExVS2ZQ?=
 =?utf-8?B?L3laZXhXTEFONHNJVEF5dW4wNFpzRGM4dnQza0dWSUsySDZPVEIyblVZTDZH?=
 =?utf-8?B?d1NZYUlHZmNhcU1zNEg3K0ZHbWJweU1jRkZQY3NFdnVmM2hRZ2Zmd2w1RElS?=
 =?utf-8?B?amN4QlRZRUo4aVlvV01FakV1eVV4TFROMzBmc09QK1ZEc1ZRaUFMaDBSU0Fj?=
 =?utf-8?B?L1dXbm9mUmY1Um1aQ2FycDg0VGxHMm1jV0RjajB3N3RVNkMyWU9SVXB2ZGxR?=
 =?utf-8?B?aFpUV1NVKy93cnpGT1NEWGpBemY1UzcvMGZFMXRBSzk4MWtrUmJSYlJSM1lv?=
 =?utf-8?B?eGRPRHRRNHVXTlhTS0pJKzlUNXRFVWp1dS9qeHk3WHhURmx4TzBYT00vbG80?=
 =?utf-8?B?ZHIwQ012b3c1OHNCQWFwaVFnM2I0NVJlR2lJTUpuZ2gzYlpYMkZheFB2UjZa?=
 =?utf-8?B?UzJyeUFjL21idGhyZ2lRampnV2ZxQ3hJaTF2cEMzeXNwOU0zcTVoODhTbXpT?=
 =?utf-8?B?YVlIWmNLVE9JSjBxRnY1aHRub1NZMi9FbDE3aWtYOVM1SkRjV3pnd0RKTWdz?=
 =?utf-8?B?Vm43eDhiWTYyRjhiT1RHYlk0RGFRL05oeCtRVGpVdTJRVlZiSHErQ2pkMW8r?=
 =?utf-8?B?YWozdlBmdEVoUlc1OGlpSnN6RmdQQi96ME15WFBNNUorQlVXcnNhOXNqdFM0?=
 =?utf-8?B?VytkcG5lYUQ1S0dwRGM2Mlc4cTB3WjdYQmxtZTVBOTFqRzRnRWtwTE5EN3Bj?=
 =?utf-8?B?RzdaeVcxbGlHakg1WWh4ZDUwYjVnbUhzM2x5TDBCNkVFL3UxdlVHelQxK2Nw?=
 =?utf-8?B?bm4zSGd4ajBDay9obkJvVUlJVDdSdi9WcnhhZVBFanhITXg4aytCWnMydnBm?=
 =?utf-8?B?eEwyQ0g0NmdRdk5ORmh0U3UxOG1yaHpHQ1d6dEFaTVRyWlhTUWtWYTR1dTMz?=
 =?utf-8?B?TndQNkNjeWthQnpOdERYRU11NDZiNWtJdWxwbjlkUFI5RXJZd3FKc0lrZUpH?=
 =?utf-8?B?cGxNMVBueTdYdmw4cjRXWUYvamxiVnR2Z1hHVUxSbkdORyt0L3pwSmJFaUZh?=
 =?utf-8?B?MXlWT05hRDBqdVdROEJ3M0hOVWEyK1F6WkUrQkxGQmdQUmJXR3NLZEQrc00v?=
 =?utf-8?B?MnN0azliRkwvaGVVVUU3U00rcXQ3RFp0eTIzTnZOc0xsb01uZU5mbzRpcFBk?=
 =?utf-8?B?MDZZbWY2SHVOVWxEZEtCdzJBTUdveFVyeGtGQzNMOUo0TThQV05kMW0vUWxC?=
 =?utf-8?B?YjF1Nlg5R1AyRGcydGpuZjlaS3p1U0xhdUVaZmxiTW1sKzM2dUFUM3ZabFFh?=
 =?utf-8?B?YXZGMVZvZ0xCVXFoMnZHYkQyOCtBSTJtS3dXdi9vZmRZS0o5eERSZnRTeG1J?=
 =?utf-8?B?UDFwWW0zS1dBMnp3TjAySC9UYmZrRzhzTVpMc0JmRmVxV21kNEJUc3RjZ1Va?=
 =?utf-8?B?SGR2ZnpqdWVySERTdjFydmN5dXVGVnZIUDdvcm5mUWNwR012K29naS95WnFv?=
 =?utf-8?Q?B2Tp8n6XtMo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QitwRVNLR3pCZndjcjJxbnZrUktjTVU3b3pFTWVWWkNiQjBzc29XaU1lWlVa?=
 =?utf-8?B?c015YlR3MU5ndlJhWE5oWENFS1ZnbzNRUU55MTluU2RWcGJoSmppdkkyVk1Y?=
 =?utf-8?B?cHFJSmVaWVNmeUdqNDAxeHZCUGp5Y1hNTURtQ2RRQWNMMnkzWVVIUFY5aVNI?=
 =?utf-8?B?TDBCNkNmUU8yRUN4SG9aa2FKc3dFeVZXdURidCtQWHBGU2xuYnBnNzJ2a0JO?=
 =?utf-8?B?YzBlWW9YVTJOaTRXbkVnU1ZSUnJnRXdaMFgwZUF0OC9tcm15cTNmV1VGaXRy?=
 =?utf-8?B?V0VJdm9Ybm90Q3d1ZmswaU9RaE1heUxuQ0FKQU45QXBXR1Y0WFo4TTBEQ0Nu?=
 =?utf-8?B?VHpNeXhaMFl5RG9mYW13SW1LVWdvTTFwc1RPOEF1dCtrNDFrM0dlekxYWldp?=
 =?utf-8?B?LzVNVUpTSWJCN09QWDNVanRLQnhwa1ZlL3dmL3pIV2hYYVJuREJqV29iend2?=
 =?utf-8?B?SndkSUxnNDhKbG1UYVFpWFpFY0hrWm5NVFhvUDlDbVBoTlBYelFIOWcwN0Jq?=
 =?utf-8?B?ZmhkQk9uTkVRNi9kRFdqeVUvUm1VN2pHV2N5NFNXcUNoalRnMWs3NGQ0SUtR?=
 =?utf-8?B?Qjh1RVM1eGlSNi9TbmdlSytwZlpFakhEa2tIK1ZKVWN4U1FrOEFmRUZXVjQ1?=
 =?utf-8?B?S1hyYmJWWHFLN04yRXFKQVFEczh1S25MRFNiWUlQWEZ3elhJTnMvMGV3WEpu?=
 =?utf-8?B?RlFNb2hESVlMUkY4Mk5RZ3BNejFUb3RwaVdKWG01NkNOcGtISkF3SVRCUnRD?=
 =?utf-8?B?bDlYUVV2VGcrWTNpd25kN2MxNjNOVGhOOVNtT1FhM0Y1bkVaQ1paVGppNkli?=
 =?utf-8?B?cWNpcEdVNVFKTXhSOFhEclUzWE5tTkJwYzVnNmhPNk1xcHhMSjVhZk9HdSsz?=
 =?utf-8?B?bEtzODB2TjF3emwySUVMeHd2ZUZxYkQxUFVCRlpVejBRTkRjcmR2aXFBWFNO?=
 =?utf-8?B?SWNqOEpSZVJiMnkzNy9ZcGdYOGJZZkpVSExpdVY5UUVOKzVzT2lxMy8wQ1NF?=
 =?utf-8?B?N0NNaVVXRUlwQWQ3V1dEVUcyS3VIdGxFQ25hQzZLNVlTMGhlanhLOUFuYUFV?=
 =?utf-8?B?VGc3cUEybGRva3RiRC9sSEY5dWVtZGl3VzFEUXlYYjVDdTVGd0M0bll1S3lF?=
 =?utf-8?B?Qjl2SCtreXRWTWpNMVJ0VU9pWjFPRjNsbDJQRnc5Mk8yRFJCVURpVXc4R3JQ?=
 =?utf-8?B?QnphV21yMVNHdW1CbFpFaG5qdFJRQklSSjV5K2NYenBYWVpJWC9kbVhBQlhU?=
 =?utf-8?B?aDZVWHNCMmlkalp5WnA2azhVMlhyWDh3M3d5VlBsbTlGRm9zb3VNbVRXa0RI?=
 =?utf-8?B?YmNyQW14V09VNzFWdGRQTTIxYklXVUhiRVJTdXg2TXVVUFBDRzVrVEN3dFN1?=
 =?utf-8?B?Q2MxNzFKNlExaEk3aWtBMjI4YmZOQ0tacE9hVlB5TGdZWEZRT3l6QTNGS0V3?=
 =?utf-8?B?VFJ3TlVaa2h2Si9UMlloVG1pc3JDdVNQaDdRV0pZYkUrS3ZYU3h6WklBRSsx?=
 =?utf-8?B?T1NoY3VORE13YXFwdjZJZzlSUU4vVG9sUCt5WE9rSjVhNDg5aXM0akJNT3Ns?=
 =?utf-8?B?U1BLSjhoT2UyekNWdE1JMkROZnBqR1hGbFh5K1FqVHRhZEMxcndlM2FDc1Y2?=
 =?utf-8?B?TUZnU2p6M3NKS3FhSzBqOG1PNEJsZ2ZRcE5iN0NiZGhBVzBqUkxVV2x4WEgx?=
 =?utf-8?B?Q3NORGxtQ2FDcElObUl0SG1KN2t2NnBhcWVLWkpIbXUzV3VRWHVQbCtzS0xo?=
 =?utf-8?B?YTZCY0t5K1F3Zy83WXkza3N4T0V1VStOWmVRa0xxdXFHSXVtLzNOOWxpV1NN?=
 =?utf-8?B?QVFqYzNsWWtYaW9uQWJkZ2EyNExQb2VTbjQ3eENlSzBoT0IvMHpBQ2c3TGZ0?=
 =?utf-8?B?RmRtRXV0a3lhMCt5RHlwK1lhOGdBbkFvU2c0RE1qNVFOSllZTTlKOWcwTkF1?=
 =?utf-8?B?VmozbjNGc1FZK3d1U25LMW8zVlRYeEF0NnJWVXNqN3lHaXgvRGIvMG5neW5w?=
 =?utf-8?B?Y2pLU3NNWk1DZnF5QXJpTi9pMExRZDVmZjM5TC9aeW5GRHRNaFdic0UxQkd2?=
 =?utf-8?B?QTlzNS96bm9pdEE0bTltWXZob05yVEdhOGgrVW9QcXBiQnZhWFQxcDR5R3Fh?=
 =?utf-8?Q?mZC0tpu8DpUKkRfg2e5GscdiM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35bed00d-3b1c-41f4-d3fb-08ddc89d6d6a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 21:27:42.9947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cyJNvWL5c64vcdTo2MU0HZvZ6Kig1L7H1fGkCsEhtVvskmIWrzkgBkc0oyGKwtzVm+nfqmEBw4nEM2XOV8Nb4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4334

On 7/21/25 16:20, Huang, Kai wrote:
> On Mon, 2025-07-21 at 09:40 -0500, Tom Lendacky wrote:
>> On 7/17/25 16:46, Kai Huang wrote:
>>> During kexec, the kernel jumps to the new kernel in relocate_kernel(),
>>> which is implemented in assembly and both 32-bit and 64-bit have their
>>> own version.
>>>
>>> Currently, for both 32-bit and 64-bit, the last two parameters of the
>>> relocate_kernel() are both 'unsigned int' but actually they only convey
>>> a boolean, i.e., one bit information.  The 'unsigned int' has enough
>>> space to carry two bits information therefore there's no need to pass
>>> the two booleans in two separate 'unsigned int'.
>>>
>>> Consolidate the last two function parameters of relocate_kernel() into a
>>> single 'unsigned int' and pass flags instead.
>>>
>>> Only consolidate the 64-bit version albeit the similar optimization can
>>> be done for the 32-bit version too.  Don't bother changing the 32-bit
>>> version while it is working (since assembly code change is required).
>>>
>>> Signed-off-by: Kai Huang <kai.huang@intel.com>
>>> ---
>>>  arch/x86/include/asm/kexec.h         | 12 ++++++++++--
>>>  arch/x86/kernel/machine_kexec_64.c   | 22 +++++++++++++---------
>>>  arch/x86/kernel/relocate_kernel_64.S | 19 +++++++++----------
>>>  3 files changed, 32 insertions(+), 21 deletions(-)
>>>

>>> @@ -204,7 +202,7 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
>>>  	 * entries that will conflict with the now unencrypted memory
>>>  	 * used by kexec. Flush the caches before copying the kernel.
>>>  	 */
>>> -	testq	%r8, %r8
>>> +	testq	$RELOC_KERNEL_HOST_MEM_ACTIVE, %r11
>>
>> Hmmm... can't both bits be set at the same time? If so, then this will
>> fail. This should be doing bit tests now.
> 
> TEST instruction performs logical AND of the two operands, therefore the
> above equals to:
> 
> 	set ZF if "R11 AND BIT(1) == 0".
> 
> Whether there's any other bits set in R11 doesn't impact the above, right?
>  

Doh! My bad, yes, not sure what I was thinking there.

Thanks,
Tom

>>
>>>  	jz .Lsme_off
>>>  	wbinvd
>>>  .Lsme_off:
>>> @@ -220,7 +218,7 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
>>>  	movq	%cr3, %rax
>>>  	movq	%rax, %cr3
>>>  
>>> -	testq	%r11, %r11	/* preserve_context */
>>> +	testq	$RELOC_KERNEL_PRESERVE_CONTEXT, %r11
>>>  	jnz .Lrelocate
>>>  
>>>  	/*
>>> @@ -273,7 +271,7 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
>>>  	ANNOTATE_NOENDBR
>>>  	andq	$PAGE_MASK, %r8
>>>  	lea	PAGE_SIZE(%r8), %rsp
>>> -	movl	$1, %r11d	/* Ensure preserve_context flag is set */
>>> +	movl	$RELOC_KERNEL_PRESERVE_CONTEXT, %r11d	/* Ensure preserve_context flag is set */
>>
>> And this will clear any value that was in r11 vs setting a single bit.
>> Not sure it currently has any effect because r8 (where the memory
>> encryption setting was held) is modified just before this. But if any
>> bits are added in the future that are needed past here, this will be a
>> problem.
> 
> Right.  It's just for the
> 
> 	call swap_pages
> 
> right after it.  Nothing else later uses RELOC_KERNEL_PRESERVE_CONTEXT or
> RELOC_KERNEL_HOST_MEM_ACTIVE.
> 
> Maybe we can add a comment to remind that all other flags are not restored
> so if someone wants to add a new bit and use it at a later he/she can see?
> 
> 	/*
> 	 * Ensure RELOC_KERNEL_PRESERVE_CONTEXT flag is set so swap_pages
> 	 * can do things correctly.  Note this doesn't restore any other 
> 	 * RELOC_KERNEL_* flags that were passed to relocate_kernel().
> 	 */
>>
>>>  	call	swap_pages
>>>  	movq	kexec_va_control_page(%rip), %rax
>>>  0:	addq	$virtual_mapped - 0b, %rax
>>> @@ -321,7 +319,7 @@ SYM_CODE_START_LOCAL_NOALIGN(swap_pages)
>>>  	UNWIND_HINT_END_OF_STACK
>>>  	/*
>>>  	 * %rdi indirection page
>>> -	 * %r11 preserve_context
>>> +	 * %r11 flags: RELOC_KERNEL_*
>>>  	 */
>>>  	movq	%rdi, %rcx	/* Put the indirection_page in %rcx */
>>>  	xorl	%edi, %edi
>>> @@ -357,7 +355,8 @@ SYM_CODE_START_LOCAL_NOALIGN(swap_pages)
>>>  	movq	%rdi, %rdx    /* Save destination page to %rdx */
>>>  	movq	%rsi, %rax    /* Save source page to %rax */
>>>  
>>> -	testq	%r11, %r11    /* Only actually swap for ::preserve_context */
>>> +	/* Only actually swap for ::preserve_context */
>>> +	testq	$RELOC_KERNEL_PRESERVE_CONTEXT, %r11
>>
>> Ditto here on the bit testing.
> 
> I don't see any problem?  Please see above.

