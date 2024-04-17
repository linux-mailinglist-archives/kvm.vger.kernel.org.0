Return-Path: <kvm+bounces-14927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD51D8A7B4F
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 06:18:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A46F28287A
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 04:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E16E42073;
	Wed, 17 Apr 2024 04:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zkrVcBYw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645143D551;
	Wed, 17 Apr 2024 04:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713327507; cv=fail; b=YtrRi05kYJr2435YhLcThpMsfM4EriDtMmXSF72nRyKle1AhKu0l1FtrVVQbM197HS+4k4TQDROWgVo8c+u+gL98OCH+Rz+JZiI4gPLTMNbHJ7AZsCWdd+32uUUI8VyFaAswWuiSPM+KKoPZN1qu1qbeEOnYvrpcn+STrYHT1uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713327507; c=relaxed/simple;
	bh=MafMr2h6QupbBas2Yr8XMcZxI6+PRzuNFF2bOCY038Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BAhouF4UO8ZGM5D41ARbeiYFuHLVdQY/aEOzwfp90hbYhgRVgwc/2/IS1r6lv+hXgbWSzxFxhfFAa7BmYnPAC/ToRTE2MZ35/usZLOOvYI6OQ/bYevpFIyur9UOXwDUePQ8YJ6Qi02RJlgAab+bWA1p5zliVyFrlwxxZdOZ5+Mw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zkrVcBYw; arc=fail smtp.client-ip=40.107.237.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJG6BnYK+3tYsM3Aknk/kM9mcbPWYeUQegRRVn4+ZoOLSaMKB05C0KFF7IgD6uX4pp1mKXwIJuT0erFjFfI1C2bGxSEMqAucSopKfIVJG3uHoxSpBGzJ7Z/TifFW033Kq3Sf1o2H62qYW3mK9kOA+6SNsjYt4PSxsnRm/iNxgg8eYKxDsoN3yoboI0hy3q+7uH/qPY5+fQiAKSEoNrORuXZuRo+CpNhJfk7N7Cw0WdRdTaypaDR/947kc1/huGWdUwWajhz0yDRYv88LEzNFsT5fMG+DEXB4ZFnQeuo8TPVKc8R8uT7RcB4StvXoC5KX05l1GZEX7+PBIVcWKttKMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s6EHzNxrsM/7vR6DFtZB4dITx4UvlOlWzLK+eZx045k=;
 b=RNHSYk9aXeZULLO2ZHuA/I3S/MBHUk1cXfQY/7Cyr0PQyjXkzIPtLav5DS4JJPASmawkyCLEDsOT+Ipc/uGzuG3Gm+nupI5Zp//WKWd1qXFrX7UgbhzNKA7PoKtnSxnXF50hykMpSeIngJtj9Oui9v0DlrTUb7Yd+sXFF0HsFMDj9AoF1gqyJ2WBKmUhs2dU6xNQJloB0xhQqwdqZ5gp5wcxu6wnsXMI4BsLNXUGl+Mp7QjyaoXYg70iDcWFFkNMP9rhPJQdSPnM3EW8W5nZg4sdXAIR+lfpTYDecmHpbLOu99fJohxwIDstnhWJyIKFL14RT2IxFzCRp5bWutlVRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6EHzNxrsM/7vR6DFtZB4dITx4UvlOlWzLK+eZx045k=;
 b=zkrVcBYwkSsY+GrxsSci9kUR7rvUk6ukd283Yo1earpeQ+CWndsyKR4Sod97TdVriLpLcHOKUEI/ThG7rp5TKZqvKTPchN1B/QGMTvyNcX2ST3C3dtYo/9PKiIzrUo6jp31xJKGIa1grZq1dlQHTOS6NLfyQQo3qccIVs30amzw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB6492.namprd12.prod.outlook.com (2603:10b6:510:1f3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Wed, 17 Apr
 2024 04:18:20 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.7452.049; Wed, 17 Apr 2024
 04:18:20 +0000
Message-ID: <32181e52-da8e-404c-9832-cb29e9e31064@amd.com>
Date: Wed, 17 Apr 2024 09:48:09 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v8 04/16] virt: sev-guest: Add vmpck_id to snp_guest_dev
 struct
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-5-nikunj@amd.com>
 <20240409102348.GBZhUXND0CDk7tGv8a@fat_crate.local>
 <74f17321-42ed-417c-ad24-8bc4e7207117@amd.com>
 <20240416090658.GBZh4_sj7ursRtzijI@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240416090658.GBZh4_sj7ursRtzijI@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0152.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::7) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB6492:EE_
X-MS-Office365-Filtering-Correlation-Id: 25f5fdc3-7d3e-47c3-1d97-08dc5e956a19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cmnMWacFERnHNHraUVVai112J9XfM40KL7fOFPtuegVhcbYBt+ItHdqwa8aV26qSQbEpHNTBMhqnQIq7IVZcRWHoDLqR4aBc7rTyaTHyBPug5RZnRvCbQ3BwIo3359gJE7tVDYoThFCsjzL4FtUgyWfbGbzkcl9cSPBFBBAj4On1UvcrRt0Z9Hx4hL+AQZDwu6qIpoccYty159CaXaOtwCva46kj9j2OFeza/5XeDVgdHwjDxyLa+ZX2I1ZSn4wnicZASzF2oktOFfQoAk4DzGCjNOmFKeCPYFXIYhZUsdwSkLyqre7Kz76KGpwHhpU+DP5fgy8AP/AOF1MNBV9tTL3x+VXfuFuMOTSQae9T73LT80PFyzpzXnQszjessa4z3bLIeseckF676By85o+/BLMHXnt2xij9sH8rmw5V228CvxruB71aADKFHGSIzsjEuBFTHZuSJZmYh7hd3xl5lmxsymNY62zFmDdhyyIsnX3RNENHVLN+6pGBSfFBT4wuP78CraP6wWnSsSqjgs1g5u2sYzDuoJ55ZToHehJHUcDf+Y8mWCcBhrytgHJ/2LA1hvq5J7FHySsHypJrH5SqS/MgZcefL2MOQ+bWXnsEmD4hcR1hHiUfhzeis4TZ4gw+I4q3s54sn5XxQyI7RltrFrFOQ7euyK9nIHEBtutw1sY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WVVvZk9ram9WSndnbkdDTXMxZThlOXJsdGt1clpSNzFjaUhsK1B1QU8vRHV6?=
 =?utf-8?B?RE5jdmtsK05UK1QzbjJLaU1QRHptaEFkY3dYSllLZUxvUkRGOFNvUEJldThI?=
 =?utf-8?B?K3ZkNGhKQ3M4dmxxalNBMkFaUy9LSHJyYUlmbWpnU1I3eVRrTHJ5Y2gxQ2o1?=
 =?utf-8?B?TzJsZGwyeENvK09PM1N5Zy95eTU1NmRFR0RsdVZmNmVEWVQvdUJSWUsrSTJE?=
 =?utf-8?B?MnRZb0tGcTVhUU5XOUZKai9iblBad3pyVlN5YlE0SU9QM2xmeVQvMmV1RmJw?=
 =?utf-8?B?QlJWRlRYdmp3OE5zRE9NTUxuZXI3UDVpR2ZyMi8rNDdCV2JvRnh5Y3RmUjY1?=
 =?utf-8?B?T1NvTW91YU9vZC91MGxjUnBqREMvenN0WUFreXM3NUI2ek52RElmby9nQlVG?=
 =?utf-8?B?L0t4MUpZNjloOWtYOUQzVmw3clYvZXJqTTRyaTZlWGNLVlNIU2JGK1F4NTFY?=
 =?utf-8?B?bXlQN2xnVERlZG4yMXIxWG1MVm1IUEJlMXBwRm1uS3grRjdPbXVXNFhuZGxi?=
 =?utf-8?B?WjBtd0dsMk1raWxDSzhQWlh5YVVnZFA2djlpWG5OVkxPWTZSaUtJUHB4WXZV?=
 =?utf-8?B?UUs3aC82TUNoanBiU0YzK1ZQTFgvK3FWQ0lqZVdZRTFiNGN3cW1LNlJpUEdw?=
 =?utf-8?B?Vk9zM0JOVkwyb2wzY2oyRVh4SjBmUEhrUTBTQ0dWUnJIaWF2eGo3TDBrU3JE?=
 =?utf-8?B?NDNOdGVTbk5TMzBQbWQrYTc4ZkN0T09YcGtVWU13Q1ZraGtPd1VEWmgwaytt?=
 =?utf-8?B?TzNXRGVYK0svcHlzcFJCTU54WWhQYWk4WTZ6RGZBMitxUGJ2TW9jYnRyR2Vj?=
 =?utf-8?B?T1BSU09BNXlzYnFpTGNKc3JGZ0RCc2NSZkw4RGE2VjVhUTdVSXp3SGRTTHEv?=
 =?utf-8?B?QnV2TTd3UmhnbnlzblpzUjZYVEk2c2padTdwSDZDV1NiVUhKZE84MlVlUUlP?=
 =?utf-8?B?VlFZUWJhdE5hb3RmbUVuUU95Q3FSUmFTT0Z0UzZWcndYTURxTk9XVFg4MURE?=
 =?utf-8?B?S1ZPVTZuRzNLRUVvVCtZRjFaSXd1SWpIa0thSkoreVg5alFrMXdsR3FQNDZW?=
 =?utf-8?B?bUw4K2ZkL2YvWUY0Z2RySmVjSTM4NWJpa2p0a3dXWG1WYUxtak5ENkpRODJP?=
 =?utf-8?B?L0tXdUw0bW1sU2lxOFQxaWdLODR3b255OHd2REZObklqRmRzWEdHSlM0OFBN?=
 =?utf-8?B?bWs1b3ZPMlhBdXdoalJtYjZKN3d6ZjE3M0xsTnhDWmwyQ2V1UzJxand2VENJ?=
 =?utf-8?B?MXRabmNSQXVlTXc3M0tEbE9VNTNiL0JGUXdKMHpqMjBiTGRpVk1CY2xUTytz?=
 =?utf-8?B?bHZvMXI0VGJrMGFCQXFqc0xRd29QUTBhdXdab2JxNkFQek54dDVsLzhxVjJ1?=
 =?utf-8?B?ais0MlJZNm1VZEtoMEtJTy9KN2djVXMzM3BzQ3ljU1JzQm5vSjNjRjhzYVBh?=
 =?utf-8?B?Sm5iMWlkUEJYU3NiZUF6bWhPYkZFUEFaTHphRUlFSVF3eTNMaWlIV1lYUVZp?=
 =?utf-8?B?c0t0L3NVM0lZa3BmK1lFaG1obVVOUFlmdXplazZSbWVkaWFUNWo5SFpwQVpZ?=
 =?utf-8?B?STR4clp3YjM1NXVTY0dGVlFLZE5VSll5anRkTVNiVTRCek9tYi94NWx1Yitp?=
 =?utf-8?B?N3RDdGN5UXREOE95MjZweVU4SnZQdU1jK1VpNzNwT3JJN0YrTUh0RkJmdkc4?=
 =?utf-8?B?TnZKSjhyRzd6QTg3WVNoRFV5L1UrUDZtK1VRb2RqbzNuMVdrdXRxeGttYjhC?=
 =?utf-8?B?SktsQ2dkNThnZ2pHbzNPTTNhQXhqT2pSY2EyaG1yZTloeGxVQ2luZHExc2g0?=
 =?utf-8?B?aGIydld6S1dReGRuTFdiU3J6ckgySGVBdmNaUXRROGN0YUFURGVzU3QvT1JZ?=
 =?utf-8?B?d25zQkY2bnpPT29TRW9YSFVORDZwaWFpaDNwR3FLS0hyZVhXSEFxNFVpN1pN?=
 =?utf-8?B?VDNLNGRrL29vNWFGejdyZ0s4Tlp3bEhEaFJVZlIxcklPejd6TVB2SDV4djlm?=
 =?utf-8?B?UmJoeEtsWjhnbGdlY25jRUIrTTR6UWp0N1ZaZ0p3VGNoajRwRmJNaTlteVp5?=
 =?utf-8?B?MDVqM3E4SHJDNjEyRHFjem90ZktMQjJyWmp6NnA5UDU3b1FkVm1UQ1piTkNY?=
 =?utf-8?Q?+Q6MMz68hgHgqz+Jh9ssKNcf8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25f5fdc3-7d3e-47c3-1d97-08dc5e956a19
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 04:18:20.4119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C7DkrcT4l08qEVFjUTx9h2b7WS3Gy+7fSsU0Dj9x9qvtbCPsnHES5agPP3ILWdjuDwDvm6O+Q5gSNafYwc3nGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6492

On 4/16/2024 2:36 PM, Borislav Petkov wrote:
> On Tue, Apr 16, 2024 at 11:27:24AM +0530, Nikunj A. Dadhania wrote:
>>> Why does that snp_get_os_area_msg_seqno() returns a pointer when you
>>> deref it here again?
>>>
>>> A function which returns a sequence number should return that number
>>> - not a pointer to it.
>>>
>>> Which then makes that u32 *os_area_msg_seqno redundant and you can use
>>> the function directly.
>>>
>>> IOW:
>>>
>>> static inline u32 snp_get_os_area_msg_seqno(struct snp_guest_dev *snp_dev)
>>> {
>>>         return snp_dev->layout->os_area.msg_seqno_0 + snp_dev->vmpck_id;
>>
>> This patch removes setting of layour page in snp_dev structure.
> 
> So?

* Instead of using snp_dev->layout, we will need to access it using platform_data->layout structure.
* Below will give incorrect value of sequence number, it will get VMPCK_0's sequence number and will add vmpck_id to that. Will work by fluke for VMPCK=0, but will fail for all other keys.

  return snp_dev->layout->os_area.msg_seqno_0 + snp_dev->vmpck_id;


struct secrets_os_area {
...
        u32 msg_seqno_0;
        u32 msg_seqno_1;
        u32 msg_seqno_2;
        u32 msg_seqno_3;
...
}

* I am using vmpck_id to index to correct msg_seqno_*


Changing this to

struct secrets_os_area {
...
        u32 msg_seqno[VMPCK_MAX_NUM];
...
}


> 
>> static inline u32 snp_get_os_area_msg_seqno(struct snp_guest_dev *snp_dev)
>> {
>>         if (!platform_data)
>>                 return NULL;
>>
>>         return *(&platform_data->layout->os_area.msg_seqno_0 + vmpck_id);
>> }
> 
> What?!

I can change the secrets_os_area like below to simplify things:

struct secrets_os_area {
...
        u32 msg_seqno[VMPCK_MAX_NUM];
...
}


static inline u32 snp_get_os_area_msg_seqno(struct snp_guest_dev *snp_dev)
{
         if (!platform_data)
                 return NULL;

         return platform_data->layout->os_area.msg_seqno[snp_dev->vmpck_id];
}


> 
> This snp_get_os_area_msg_seqno() is a new function added by this patch.
> 
>> I had a getter for getting the os_area_msg_seqno pointer, probably not
>> a good function name.
> 
> Probably you need to go back to the drawing board and think about how
> this thing should look like.
> 
>>> Do you see the imbalance in the APIs?
>>
>> The msg_seqno should only be incremented by 2 (always), that was the reason to avoid a setter.
> 
> And what's wrong with the setter doing the incrementation so that
> callers can't even get it wrong?

Are you suggesting that setter should always increment by 2?

static inline u32 snp_set_os_area_msg_seqno(struct snp_guest_dev *snp_dev)
{
...
	os_area.msg_seqno[snp_dev->vmpck_id] += 2;
...

}

> 
> It sounds to me like you should redesign this sequence number handling
> in a *separate* patch.

Sure, let me rethink and will post it as separate patch.

Regards
Nikunj


