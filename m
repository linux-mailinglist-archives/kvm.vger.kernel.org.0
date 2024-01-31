Return-Path: <kvm+bounces-7554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9E4C843B48
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 10:40:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72D92290550
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 09:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DCF367E66;
	Wed, 31 Jan 2024 09:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="SancRPbO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2113.outbound.protection.outlook.com [40.107.220.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D986027F
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 09:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.113
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706693991; cv=fail; b=r6JE0peV+aY1Ccd0fUmwuCmT0zCpq9VF4KXVn9H2rSqn4lCvNdjb2yiYShc8Ww5q7+bBasxyS2LHYQgZARghEQJLvjVLvt0rMrP43kYckUiYVj2aX8eWwW+Ze+jxuvxSk+duv2nPLFgwEBJ6OoPuvf9wlGc4A4OMMYRrPf7lZrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706693991; c=relaxed/simple;
	bh=C5XuKNxXwkK8pxFf7W4FRXwKmSJfGwCYLt/aXg0pfi8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mffa74EPMF1y8DhO6aVdSAb4VVG91HUojZvk27Pm7o5LZHpv5DgNpKppschStAeRIcv4bK/arnjb/0SHCUGZlbFJanDQhCv4VrIy+CKZ/Bnhw5zmwnTxcN0bzM/LICAatlTTpqdtX6fstigX2RwlfULocChu0vsq1U0tbjGOD38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=SancRPbO; arc=fail smtp.client-ip=40.107.220.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxVHYbZNENDWkKv6xPHO5teFCfM1LZavOky6QugwLWs0TizJrLedakizQXbOc0K4/BzLtw1+XKBPjrFZCIgOLmGjoRcHSKQ0iSj9Syublx62tWMLzWppXFGB1DSHCXBOBmLyALC4+t5zWZrY8ibsItYDHl+9U7ZHc4mnyNbg2xndnEcwCNAEXD3acWOkr2mHLzyihcZqo/j2OGksD6i/qiFwh+xUF6k5eItidzRvFTFL5igerXQoFTfVIRDC9iGFNNs/aeZ28KFtmtz56KuM30RW95RN7qSEMUkPlYRQLZI6CgpkRAGHVdTzDafcmwcSSe61NYfzqmlIKg3HDNv5fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2bCRsLGegAij3ka4FTuck1yw0nNxgq5/Xya+UBtwio8=;
 b=TIaL10w/sSIxjZDd6tglAkS8UOzI/tw5CPswsDJf8fOp7M1h3oGdrufdcB1O6+rhgku1QXO5Yo8u53BIpIWweKjJnLrdn8ifwTOx4gBApFjQlTX9RrQX8n7Jg9Cc+a52KKB+ZR08AqTuNK86Fx1+DbpNeM+7ocQg4MLMC5CxgXlVqeHsE5I3+kRWYsbU/HYMuQENFBaDfP6fzuwcQhmjiK0ZjARxyxUlPfiErM3fDjoJZJ86TNX3QHx+wGjUB2rC/RQXykVziceHe3rTaZk2SoVNeEALC1HO35FIt8DPWXDZwyqmS8tQrZjDTHsej3RPf/3JG23v0CxX4kUfRN/vTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2bCRsLGegAij3ka4FTuck1yw0nNxgq5/Xya+UBtwio8=;
 b=SancRPbO8haGptbFsmR0tjj3fFGmdMNlzlO3mcY4fgGj6cfMiUtBaMkT1FUIuTjL6hPR4ZZnqb8YXwtH+2D82OwI9ozZuah/gewlVgtJFzgvAwIuNKtULVYetvFE++77RxUQsL41gi5PEL3MuL+GwMwgJqLM5mw5J8ul7WU0hFA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 PH0PR01MB6277.prod.exchangelabs.com (2603:10b6:510:c::18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.23; Wed, 31 Jan 2024 09:39:45 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::a0ca:67bd:8f75:4f37]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::a0ca:67bd:8f75:4f37%5]) with mapi id 15.20.7249.017; Wed, 31 Jan 2024
 09:39:44 +0000
Message-ID: <3f30ac3a-9226-45fe-9e72-49c26a9f4c97@os.amperecomputing.com>
Date: Wed, 31 Jan 2024 15:09:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 17/43] KVM: arm64: nv: Support multiple nested Stage-2
 mmu structures
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 D Scott Phillips <scott@os.amperecomputing.com>
References: <20231120131027.854038-1-maz@kernel.org>
 <20231120131027.854038-18-maz@kernel.org>
 <f0416fa9-b4f1-4bad-a73b-b1d7ecbffc62@os.amperecomputing.com>
 <86le8g86t6.wl-maz@kernel.org>
 <3b51d760-fd32-41b7-b142-5974fdf3e90e@os.amperecomputing.com>
 <868r4d94c9.wl-maz@kernel.org>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <868r4d94c9.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5P220CA0020.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1ef::18) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|PH0PR01MB6277:EE_
X-MS-Office365-Filtering-Correlation-Id: 78bdca91-dd60-451f-c719-08dc22408ea3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	I7j0NT3kb1Mo1D17tPDnvqGaDACpNnHvtF7Vxbf0kPhmQ9bc03rbOkcR4KGDFJvtuR5MY9l0fr/zrqorIz8yl0+sH4UG8N6+PAgmdwA/XS/pTt+BTGHfvUD1OwuWhLXWpTpahu7TW0qtGRlSmUveC743hfVY8NYPDBCvazlC7VRicKkcUZgVHr3SM+vaRNYOUJIrMf3Wj2Em83JfW2bSQ7q+/8uz8NZIXeHjt86iGlXKSh2ReJUJvsBvTURZP/L6whwSPFkBX1+6s58i/SkUr4UVXaw5uHFrYPcnVAUsrS8qCsSy42SGvXfgBC8wLfg6n5hq3XfYx5lMc2uLzFNjJxsHKlKe7Qp9UgxP0Bp4/QgIKO74tKKxELaCJ0kNGattr5aaFdX6uxh/9ahJH7HXYPopWj+NOBZEuznvQTwuJ1K3qqmdlxYHft5+RMyFQz7J1gDdD9fkpAQ19qCidHjNKjSvjSYqgbPm36DeuRgujOVhGx6iaVnjM1QTKmKVq9t1OdQxsLYdr0u9ukkSO8wGD5L7KDEnHi0PeMFhjBH8NCCBpt0j2IWMFMw2xUjUDt+kgH12Ecxb2qyD46QjMvlHv6PCJgcQu4qsKsmoyuhE4sY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(346002)(136003)(396003)(366004)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(31686004)(83380400001)(41300700001)(31696002)(86362001)(6512007)(26005)(38100700002)(107886003)(2616005)(6506007)(6486002)(53546011)(478600001)(966005)(2906002)(6916009)(316002)(6666004)(66946007)(66556008)(66476007)(54906003)(4326008)(8936002)(8676002)(7416002)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cUh4RHpyNlBhY3RtTVVPZlVBVnF1VFdhTS82YXZYeXZCU2paWWtYYWtUN0Q2?=
 =?utf-8?B?Q1hxbzhOcnBKMkUyRGszZG41TWxZS2FzTTdZTGd1SSt6ZjdqQnZVNDI1RWkx?=
 =?utf-8?B?M1ZXc0l2b0ZKK0hGRE00V05nb09Db0JqLzA3bC96QlB3STRzL2tLejYvd0Ex?=
 =?utf-8?B?M21rUXlmT0ZGWFVkRHVmRVJUWmQwNGJKSnNLYnJJbWhkS0JWOStUczlMaHhs?=
 =?utf-8?B?M1V5bzQvREtHcjUreFA4SDZxTmEwNlI3REhIS2tObzVEUTAyUFE1bGhXWlJr?=
 =?utf-8?B?cmx5UHdJMG0vNFNwbklKd09VUGxzbXNsVlpEajNUOUZ3Wk14R3RtemJoemtR?=
 =?utf-8?B?YU4rd3hScW9RTFg4ckZrUlN5dnMrVHYwN09nSG5aQkFqRmdlZzhCakZmQm5H?=
 =?utf-8?B?RC9uMjZEY1kxTWp4WGhzWnNpUmZVUGhRbUFtL3ZTNWg1dWkwM2s4cS84blgr?=
 =?utf-8?B?eDdqSnBhUWwyby9WRmRhQ2FNNDFlbW1oOTNCaTExOXArZVc1c3B3TzQxNEZ2?=
 =?utf-8?B?NVpMMTdMTHYyenNYTUpNeXdpelY0N285b3NKNXJsL3ppVThUeGljcVU0WStp?=
 =?utf-8?B?NGNJa0ZObU1SMVE1TmtsYnZncXNxNGI4NGdKeitSRmRTSm01NlkvektaM3FN?=
 =?utf-8?B?cGJUMllGZXVPbnp6cmlwVS9yY2FVNFBlQmxnbEttNSs1M2lvOGd0d1RRNXRI?=
 =?utf-8?B?cXAxMFpDWW5uSkQ1dDZMUWtuSmE2NnFmeG1xd2pOdEI0bVV2Sm1WTmV2S01r?=
 =?utf-8?B?bk55VHFGSXk1cUw1UG1HeG9FM0xJOWVxN2VtM0dsS0JQbzRsdWV4WElRVTds?=
 =?utf-8?B?UkQrZUFCL1V1dHJXUGRLaW9KRU85NWZtaE8ySnBCbk5kVVBlVllUN0pZbzQv?=
 =?utf-8?B?ZG9NR25iNDhXQy9DREZVZFlPQlpPOGFUcWRrdlRnOUpaR2R3c3FVQU5WeVFO?=
 =?utf-8?B?SnNDdTA4YWJIMVRGUlQ5VDNaWG44YkcxWDFoNVZVOThtejRkc1BMMDBYS0Rt?=
 =?utf-8?B?dFdGOEI2QlY1VmJxZXNFSVIwTUsveUlLY29aVWFCZDZvbndvcTZuR3hySkda?=
 =?utf-8?B?a0ozRmkvd3hVeFE2aUxJYmlhejhndXJQQzVKcUxRdkRnYzVrNmI2c0drMUtm?=
 =?utf-8?B?ZjJKVFkxS3dNZkhIUXlxbndZanp6TTBNdTJtVGVNQ1N2YTJKemdBWWlSUHQw?=
 =?utf-8?B?cWxYa1J4NmE1bCtLQThFRkxrUzQybmQ2UjQyMDc1cmdCVm5yVzc5TFpxRlVJ?=
 =?utf-8?B?Mm1IZHNJai9Nam5FTHlyeGVQMTlXaUhPMmRvWm5CdStHcEpMVG9KR1E2YzVr?=
 =?utf-8?B?QTJKTGZuY0xMMmNqV0VIVlRVTytkbm9mWEhlb3l1SDVqQ1RPOXVUMWU2ZzNY?=
 =?utf-8?B?K3FPQWZ1KzZoM2NRSndnZko5c0pyMi9GRmhSOU9CVzNWaDdSV0FZQ2NTOEh0?=
 =?utf-8?B?WW1LOHNuRTBIRjJwdjFKeG5xS1Y1bUhLelluNkhpcDl0RlVQUWRNeTJSMjc1?=
 =?utf-8?B?eGhRdVNBRFcrcS9NV0MvdW5DT1gydmd1Y0RaOGJ6S1J5U1NzelJzZlh5Nkhs?=
 =?utf-8?B?VkY0UlNzRWNSbXNHWnU1eUk4dUN5a05ITmJSMGdrYkdhQ3dhNGUrK3M3R0dM?=
 =?utf-8?B?SEpEcmdWb0F0SVRXZjVReHk1WWw2VlZpMVUvazJYOWlabyswZ0dwdldhOTQ0?=
 =?utf-8?B?OUYrOVI4OElkaDRML2dNYm52QVc2ZFhrMlplMThiTkhYOFllNlNicFVETTRz?=
 =?utf-8?B?WDBNMUo0NVFYZEhCKzZLL0kwVDdYRU80czlOakhxQU9RSzg4bVZ1TG5rWDd3?=
 =?utf-8?B?RXdtU2hEY20vUHZUb2l5MEhtbjd5R1hoN2QxeXdoOWVSRmN1YXQ1aFEvNS9B?=
 =?utf-8?B?MnlZZHE2OThlajdtcG1vMTVjQ3p6bTFCZnY3TXU2Rjc5Qm5RLzhaS1RCbGtC?=
 =?utf-8?B?T1JDUXorMXdqTG0yN3JVa1dFR2RjallscFRQZlQ0QlVmb0RtY01SZVdyblZT?=
 =?utf-8?B?bVRBYmdtZi9xVkVGVWYzWkRsQStqQXFva2REc21oNEVnQ2V1U1FiWHJHVzhV?=
 =?utf-8?B?WlFqZDhzNzk1VFAxZzdXS2hna2o2RDZRZU1nUmcwZ3gzWjZvMnNPQlVueTVj?=
 =?utf-8?B?VjBsd0RaalNuSUVxQXlLVmZjTG9IVU43NVZ6bXFGbTMyNDYvWUtnSDQ0Z2Er?=
 =?utf-8?Q?Ug/QUWLJWc/Kfye4+/IjWH7PpKlM67eMvNscyvbHUTgN?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78bdca91-dd60-451f-c719-08dc22408ea3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 09:39:44.7752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 58rpS4OhFohj7nnmLKHMRuawjPuOwXl5OirKElHSqxv6io/XEEBTG83RozM1/kmB4kv/wHUp2dMYLoLWaFRrZFFP4FQAwQgxWp24ANaeDfwEB1ImdqV68mv+gmZHcpFg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6277


Hi Marc,

On 25-01-2024 02:28 pm, Marc Zyngier wrote:
> On Thu, 25 Jan 2024 08:14:32 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>> Hi Marc,
>>
>> On 23-01-2024 07:56 pm, Marc Zyngier wrote:
>>> Hi Ganapatrao,
>>>
>>> On Tue, 23 Jan 2024 09:55:32 +0000,
>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>> Hi Marc,
>>>>
>>>>> +void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
>>>>> +{
>>>>> +	if (is_hyp_ctxt(vcpu)) {
>>>>> +		vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
>>>>> +	} else {
>>>>> +		write_lock(&vcpu->kvm->mmu_lock);
>>>>> +		vcpu->arch.hw_mmu = get_s2_mmu_nested(vcpu);
>>>>> +		write_unlock(&vcpu->kvm->mmu_lock);
>>>>> +	}
>>>>
>>>> Due to race, there is a non-existing L2's mmu table is getting loaded
>>>> for some of vCPU while booting L1(noticed with L1 boot using large
>>>> number of vCPUs). This is happening since at the early stage the
>>>> e2h(hyp-context) is not set and trap to eret of L1 boot-strap code
>>>> resulting in context switch as if it is returning to L2(guest enter)
>>>> and loading not initialized mmu table on those vCPUs resulting in
>>>> unrecoverable traps and aborts.
>>>
>>> I'm not sure I understand the problem you're describing here.
>>>
>>
>> IIUC, When the S2 fault happens, the faulted vCPU gets the pages from
>> qemu process and maps in S2 and copies the code to allocated
>> memory. Mean while other vCPUs which are in race to come online, when
>> they switches over to dummy S2 finds the mapping and returns to L1 and
>> subsequent execution does not fault instead fetches from memory where
>> no code exists yet(for some) and generates stage 1 instruction abort
>> and jumps to abort handler and even there is no code exist and keeps
>> aborting. This is happening on random vCPUs(no pattern).
> 
> Why is that any different from the way we handle faults in the
> non-nested case? If there is a case where we can map the PTE at S2
> before the data is available, this is a generic bug that can trigger
> irrespective of NV.
> 
>>
>>> What is the race exactly? Why isn't the shadow S2 good enough? Not
>>> having HCR_EL2.VM set doesn't mean we can use the same S2, as the TLBs
>>> are tagged by a different VMID, so staying on the canonical S2 seems
>>> wrong.
>>
>> IMO, it is unnecessary to switch-over for first ERET while L1 is
>> booting and repeat the faults and page allocation which is anyway
>> dummy once L1 switches to E2H.
> 
> It is mandated by the architecture. EL1 is, by definition, a different
> translation regime from EL2. So we *must* have a different S2, because
> that defines the boundaries of TLB creation and invalidation. The
> fact that these are the same pages is totally irrelevant.
> 
>> Let L1 use its S2 always which is created by L0. Even we should
>> consider avoiding the entry created for L1 in array(first entry in the
>> array) of S2-MMUs and avoid unnecessary iteration/lookup while unmap
>> of NestedVMs.
> 
> I'm sorry, but this is just wrong. You are merging the EL1 and EL2
> translation regimes, which is not acceptable.
> 
>> I am anticipating this unwanted switch-over wont happen when we have
>> NV2 only support in V12?
> 
> V11 is already NV2 only, so I really don't get what you mean here.
> Everything stays the same, and there is nothing to change here.
> 

I am using still V10 since V11(also V12/nv-6.9-sr-enforcement) has 
issues to boot with QEMU. Tried V11 with my local branch of QEMU which 
is 7.2 based and also with Eric's QEMU[1] which rebased on 8.2. The 
issue is QEMU crashes at the very beginning itself. Not sure about the 
issue and yet to debug.

[1] https://github.com/eauger/qemu/tree/v8.2-nv

> What you describe looks like a terrible bug somewhere on the
> page-fault path that has the potential to impact non-NV, and I'd like
> to focus on that.

I found the bug/issue and fixed it.
The problem was so random and was happening when tried booting L1 with 
large cores(200 to 300+).

I have implemented(yet to send to ML for review) to fix the performance 
issue[2] due to unmapping of Shadow tables by implementing the lookup 
table to unmap only the mapped Shadow IPAs instead of unmapping complete 
Shadow S2 of all active NestedVMs.

This lookup table was not adding the mappings created for the L1 when it 
is using the shadow S2-MMU(my bad, missed to notice that the L1 hops 
between vEL2 and EL1 at the booting stage), hence when there is a page 
migration, the unmap was not getting done for those pages and resulting 
in access of stale pages/memory by the some of the VCPUs of L1.

I have modified the check while adding the Shadow-IPA to PA mapping to a 
lookup table to check, is this page is getting mapped to NestedVMs or to 
  a L1 while it is using Shadow S2.

[2] https://www.spinics.net/lists/kvm/msg326638.html

> 
> I've been booting my L1 with a fairly large number of vcpus (32 vcpu
> for 6 physical CPUs), and I don't see this.
> 
> Since you seem to have a way to trigger it on your HW, can you please
> pinpoint the situation where we map the page without having the
> corresponding data?
> 
> Thanks,
> 
> 	M.
> 

Thanks,
Ganapat

