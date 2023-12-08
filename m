Return-Path: <kvm+bounces-3972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9132180AF50
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 23:01:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BD9B1F213D7
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 22:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 357B259B50;
	Fri,  8 Dec 2023 22:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bGPwk4S7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A711712;
	Fri,  8 Dec 2023 14:01:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSEIrCgV62V3HEq+zccHZzGYnk3fWhcCdzPwUAjjPWTNj9sK2GApklyYEVB05gI7cBQOtJ8T94GA9iNtThUsjS4EIhcJmf7Mu/51AOzCSHdPOSxUu8uR/yDAD3NQ19sq10BCLie6S4ljJIkWkxUjY3tA564QqKr0juZnMTEFfTJgmobj3x2rB+Uzo4740YRyLdfb3NrfXj6TJ5mGmf8zy+ipusPiwqZyp1sdEQa+8wxiu8A0UqMXWpD5d+vwKSelNTGL61T29LHNJvvrXpMXpTLux4TqMrChjJSpuj4Wo7620H4NEUSRmQVGVpAi9tdto9piXNNxQm6b2XnznfGxag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ZGlIyA10nj/K3ColeR3Pkq4Mci5xQS1r3Z6xHkTDl0=;
 b=MpsXt+5/ZknvbZvLY8xjcdSIC0kjG414pyDaAHJMeFFcxzgTzJYw1orKrDrlk02QsRRpYnAuEoX7LXwwGTr5brPxRLhKdnsH5B3c5YKCeJijZ+JmGMZNXbyo68DEiwLK/71WcpexZCIYpzeSd4IztCHUT7B6TydP279XP3fqKM6l1wApAI4yHo5/JAnD7IvyXTv18Ats2wJaEVgFx0Oj0VuUpdwOusFI/GgYZ7G7HLeN6oyei2qT8cKyxVG23z9lKd3yANGt1pYYFtWdq2/yJuA9nX8yrbUrNXataMXGlMayNFnRTkFsigpJRdzGX8+nkCX2zyRRBAAw4ZX6cYTzpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZGlIyA10nj/K3ColeR3Pkq4Mci5xQS1r3Z6xHkTDl0=;
 b=bGPwk4S7SP29x6UpIFntbbCgSj4P+vawGO5vGS6GWUnKOv1w0DiZpqMBpp6ERexSo7t8xZRrCOkC0JNm0ngLZQScFj/221LGTV6U8H/9QWHcYV8kr9S7Qq2/QyV3hnjsByuqtVCKS+7r8RanckhErOW32k11AXUAbfhRUT6hUNc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by BY5PR12MB4950.namprd12.prod.outlook.com (2603:10b6:a03:1d9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.28; Fri, 8 Dec
 2023 22:01:27 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::bec4:77b3:e1d1:5615]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::bec4:77b3:e1d1:5615%5]) with mapi id 15.20.7068.028; Fri, 8 Dec 2023
 22:01:27 +0000
Message-ID: <b465e088-d914-d646-b0c4-69ea18ca11e5@amd.com>
Date: Fri, 8 Dec 2023 14:01:24 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH iwl-next v4 01/12] ice: Add function to get RX queue
 context
Content-Language: en-US
To: Yahui Cao <yahui.cao@intel.com>, intel-wired-lan@lists.osuosl.org
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, lingyu.liu@intel.com,
 kevin.tian@intel.com, madhu.chittim@intel.com, sridhar.samudrala@intel.com,
 alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, brett.creeley@amd.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
References: <20231121025111.257597-1-yahui.cao@intel.com>
 <20231121025111.257597-2-yahui.cao@intel.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20231121025111.257597-2-yahui.cao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0060.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::35) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|BY5PR12MB4950:EE_
X-MS-Office365-Filtering-Correlation-Id: 29fa15ba-703c-4318-d181-08dbf83939d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7tQNl3ZY6eKKEsaB1chd/FGeswKwcFWAtOCT+2atWsE7jkrMhax/o/YgKo8i/2plyfpspu9BES4i15tw4FKUoU6bTddSMBuSDnjE8KuyJDWnatLJifuN5a3Wxg+y9ovwPzXTQZ0gGURGz3wQMm2M/sDpT4RxHdMB7IOMaOjzDx5vHhTWmamehJYsZhEY3hDvEcna1eFakxc1LRcjonQ/FV1NmYqgnM1weRfJ9QY1gHMIvi2DMNmdxoOyKS3Lh0DaSEL8ujQs6RBFE7O/hK0wa5HvZeSQXPvD7XuHtLhM8SpUqeDuHHU0jzX+Li7zfUuvruDDOMotHwu6cs7yViuIIUh5+y+YA8I1NIF+v9I/LoCOT6E5+6Rs4rmFcDJ6Mpx3H68vWrl5DhgU7W4BHahZ+IrJKZq5NDXMAfkVc4ijswflYEGKq/MLodxyt7fVgly1UCHSRe8+OWmpnSxipdtilVFMPXQ0TLocxgnXaXpoKl5MrICepTOUqen6llQiooJ06v8aWKldUQpPxIzAu//nSoyJtPjeb11q0U3MwK4GTg/BRvuxGSRyeOpnSKapeyVmTLezGKE0h0mPrcFkQPw5RH6P5WEEH7mEP1Xj/WsdLAvPB0CyY98RwE9W4ElxkXbwteOvbz6+hJS/xgcR/Wf2SWDmnBjNDfgCixKhFxAdsrZUJHU+zMX1sM5OlOgtgAd6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(366004)(396003)(39860400002)(230922051799003)(230173577357003)(230273577357003)(186009)(451199024)(1800799012)(64100799003)(31686004)(6486002)(6666004)(478600001)(38100700002)(26005)(2616005)(6512007)(53546011)(6506007)(4326008)(41300700001)(8676002)(8936002)(2906002)(5660300002)(4744005)(36756003)(66946007)(31696002)(7416002)(66476007)(66556008)(316002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2xkZmxkMWVwZGxPN1llM2VTR1Y5VEVuUnlDbnYzWE9CbW5nSHcyeW9kZ1po?=
 =?utf-8?B?VHVHZEdBTG90cnBWVzBSVWNpSDI1c0xTakJjOTJ1cjV5b0JURGMvcVJtSDJk?=
 =?utf-8?B?Mm5ZY1Z3bDY1cEFVRWF0eGwvOFM0ZmhyTG9QWHlzMzNFcDBoTk13bFdJMXhh?=
 =?utf-8?B?NWlZMUY2Z2J4Y3JLM2liOXZFNC9YdG8wNk5rTE9nL2d6SlZKZU83aSsyNDFp?=
 =?utf-8?B?Tmk4b05NRkZIRVJyaGVTK1RuMmxEOWl1TEx3Mi9wS0tOT3JaSkNyd21sVGVu?=
 =?utf-8?B?bkFML3BzVzc1QkZlbmpoaTFBcTdsMTU1bk42SHJQdk9yOHBBTExiaHQvSS81?=
 =?utf-8?B?RW9zSDBEYURIUGRiYnRKVllHQzByck5rZzlzQTNWT0QxTFovV3d0Z29xcHVv?=
 =?utf-8?B?enJRS2tvaGcySWV4NzNmUjZ6NDFxZ2l1dXFUcExHWVZ3YkN1QTQ1SkdsQWxM?=
 =?utf-8?B?UzBIOG1vT05KcW9jOG1BNEJTRjJia2dOVDMxZGJsSDFrbUdZWDcrM3hYMTVX?=
 =?utf-8?B?Mm45R1QzeFBwaUhscGlPc0swZFhWUk5wRWxOMmJWbGxwemNCd2FXdlYwWmlz?=
 =?utf-8?B?N1lyUFdtbWpiaTJ3eGQ2SmxjZCtwQXhZMU9Ed3pMemNQUTdETWJwU2l0a05O?=
 =?utf-8?B?TmRMeWw2R3V4S3gwUHVTbEZ6Z1pOZWtaSXRWaklEcHk1RjhtaDZ2U2pmQkJV?=
 =?utf-8?B?WDl1b29qSWxmUUhCR3ppZXRJd3NBQUMrMmhtUzk3OVNoaUxUYi9KZjZla0RY?=
 =?utf-8?B?bU9DT3BoR0Q1Zm41eGo1SzdnRndheTlFRXFoL3Q5bnV3RHAveFBDdUhIRHVq?=
 =?utf-8?B?UGk4MW1HVnVjMmtIUStQa3J3M2NKbThML21aeGZUTWZaUlZrdnliWVU5NUY2?=
 =?utf-8?B?OVkwRG8rV010VUFlNXhLcEcxRzJuVXVNeHBxV2cxelE4QXlRczJZcytZREtr?=
 =?utf-8?B?T2IweEFQYVU1cENQNTBBQjg3dWcvUytncjllaTQ1YjhzN2lmWk9UOG1wMTE2?=
 =?utf-8?B?UG9wYlFMUkQxZHh0T3BDQytmQzNpRW9CQ1U1dUJHcVI4LytpQUlEbVNINDNV?=
 =?utf-8?B?SHdSUERiN3lRVUFLWjB0eHp2OWZMZlJlMDYyeEhSbmJaTFA4RjhxRkR6TDRY?=
 =?utf-8?B?ZHRqNzFUbzhqRk94dk9pUm1ybU1BZ0s3VGxON0xLR0lSQ01nUlZSaDBpWDNY?=
 =?utf-8?B?UXF2YTNxYjFVQjhGS0djQlgxbjlJMUZMdWhyd28xV2FhMG1rdjRMMGFXWXZS?=
 =?utf-8?B?M0l6T3JITldiNzFxaTRzTmlNUHRVQkxmZDJKTVAwRFJVKzh4SUFyU0x0eXNO?=
 =?utf-8?B?UDZKYWw3NXpXeTJzS3BpZ0prWjN1bjNNQUF6eitsbzI0cW5TTVZUQjVjdU1a?=
 =?utf-8?B?TVphc3lFODFEVU8zVHUvdlFDb0NHcG5rbDBiNlRFVWQxaGRyeU5nczNpOW1l?=
 =?utf-8?B?RDFpQ2N0TVpIQTNBbGludU11V3ZhcWZBL3pucUZrTGx4MVNuNVdhN2xMT3ZK?=
 =?utf-8?B?TDhHd3lobHRkeFlrMk5vdUlpNkUybllxZmViN0hyTW50TWxqR0ZhZkYvWGZp?=
 =?utf-8?B?TXh5bXV3Z2JPUGJaODVmWkJKazNBS09XT0RzSG9vbmY0MCt5dnpwdmY1d1lC?=
 =?utf-8?B?bTVvL2tDOHhkakNLQS84RHdSQndkRklYQWxTazByOGUvVmpOZFBjcFArU0NH?=
 =?utf-8?B?QWE4RnhhRndZVThSYzlxRzJ1cjFsUndSWEsybHY1Y2NmMVRhSFVycksvMzFE?=
 =?utf-8?B?bTBHUnh0S1c1aUxtQkJLaG14djBYcXpwVHBXbGo2MnRUWkJMOHJRNXNzVjAw?=
 =?utf-8?B?TU91K3piNXNEeStVeWVSL3RIUThHbHZKcmpSZzRzN1FJQW1kbDVDMnNUdERF?=
 =?utf-8?B?YWVxTDhIcFlQbWgwN3VrMEdDazlrZ1ZxRkgzVDdxNEVLN0YyMHFxbm1CYThN?=
 =?utf-8?B?UFhkdFZaRDJPeWlrTS9vNkNqRnVoYlVhOUxyMXFNQ0lrMnRYVDE3NEMzbE8v?=
 =?utf-8?B?Q2RCYUVMRytFbWtvdkhVRHpvNTMvNTZFRjZSZmhsL05mNDI2b0xoS3IwN2dp?=
 =?utf-8?B?bW1DWlcyQkFGZHRBclMyNm5SclNzTlFkUWhPTkJMdTBQS3VwcGF0NGFqUDRh?=
 =?utf-8?Q?anL3dwZXlj1oVKTKyF0AHD8gK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29fa15ba-703c-4318-d181-08dbf83939d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 22:01:27.1473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cCf4h37Y4GoZIC93E4R7MERQBQ2suSrOzwshCrTye8WWhcMU44hYQav/aA448vN1EhCN5ja41P1uTeqXR5weyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4950

On 11/20/2023 6:51 PM, Yahui Cao wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> Export RX queue context get function which is consumed by linux live
> migration driver to save and load device state.

Nit, but I don't think "linux" needs to be mentioned here.

> 
> Signed-off-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
> ---
>   drivers/net/ethernet/intel/ice/ice_common.c | 268 ++++++++++++++++++++
>   drivers/net/ethernet/intel/ice/ice_common.h |   5 +
>   2 files changed, 273 insertions(+)
> 

[...]

