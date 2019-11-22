Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B20CA107419
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 15:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKVOeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 09:34:16 -0500
Received: from mail-eopbgr730084.outbound.protection.outlook.com ([40.107.73.84]:18175
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726046AbfKVOeP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 09:34:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F56gIUouSW2Y9NwApHFAUMFk99O+i5QbEwYueJdumS9FxDAswLnGk1cPu0sOt/czEjls2GbhHEp+Bd4IeZ6+vk11EagT6/V0tD/DKILEyv8VE9N/g8Rkrd0nHiBb3n4IqpB7jvonJw3yLw9RW2NWXFQeNPSYNmXdY7kJEa5sc1A9nEuvfN1U6IcwRX0UPkorPYbF09QwhNfh5594Nh7H5XfOF5EeGwhFbluGCc1rdCoMjcGYnfoSsU3MNz/vMi+Qi0lIUNqgkMDxOpHTEGDL9/bjhoepgwdrTDXaRSkhk4G3sRX3npU5fvV6zws4cRXAIR+MzgzSoTqHQ5x4JsVVyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfUseOGpHiHdRKO+N+4C8z8LyxwDcd7d4s+4zfNahFo=;
 b=nwZpZpGpebwejuk8g5D9tvqs/Ys4kjU88su/zVY0/bwg//XY8zzloiL0IKGda5bWQNuC8XdcEtqtFn+hpcg7Y40F4UMZxDs0hdD14rgDYGQ+PWXwzN6eYhLh49Sf7N/zRPMrmVjZopP9SzPs2udPWBkJBuoyc/47GbZl5csrgE1pB7Zh4sDCp5STsu3mUxm2KacxQKkHbgdcFb/hmbd0idUZ2jNtysQdHahpJBw/4Heyh1MkIqqux9Tjs451EZkVvDwUAi4dhqL+LHwLzWbQUNO1JwjImKFWw9NXDXzFn8pW/EEZfLBt/RVcHFxJW2vGUGrTSewZQM58Ls+aZJuwVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfUseOGpHiHdRKO+N+4C8z8LyxwDcd7d4s+4zfNahFo=;
 b=AqHjWFly5xzuNhC5a6j79xXqxgHnL0UNgJWXr4k39Ui3fUm+BS1yR5sCngcW2x23BB/nQ6pWN8i9IJkbTYNp6ySN5p1SerHHVZI0oeG/lyaMlRvi+WZsf0wQzmZslvHPpgZQ6dr7GP//avcle4BtKzlchuChY3R/kFSkg8VHnIs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB3980.namprd12.prod.outlook.com (10.255.175.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Fri, 22 Nov 2019 14:34:13 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::edfa:96b9:b6fd:fbf9]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::edfa:96b9:b6fd:fbf9%7]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 14:34:12 +0000
Cc:     brijesh.singh@amd.com, Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 2/2] KVM x86: Mask memory encryption guest cpuid
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
References: <20191121203344.156835-1-pgonda@google.com>
 <20191121203344.156835-3-pgonda@google.com>
 <d876b27b-9519-a0a0-55c2-62e57a783a7f@amd.com>
 <d945adcc-d548-1dc0-b43f-769a02d0cede@redhat.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <b53dc8fb-5296-706b-4f59-f17a5d8c0b93@amd.com>
Date:   Fri, 22 Nov 2019 08:34:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <d945adcc-d548-1dc0-b43f-769a02d0cede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0097.namprd04.prod.outlook.com
 (2603:10b6:805:f2::38) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c105ec23-82c7-4449-6673-08d76f590afd
X-MS-TrafficTypeDiagnostic: DM6PR12MB3980:|DM6PR12MB3980:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB39805B8F9BFF5EDC96D6E0DAE5490@DM6PR12MB3980.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 02296943FF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(199004)(189003)(316002)(5660300002)(50466002)(65956001)(54906003)(65806001)(66066001)(58126008)(47776003)(14454004)(110136005)(6486002)(14444005)(8676002)(31686004)(81166006)(305945005)(7736002)(81156014)(86362001)(229853002)(478600001)(6436002)(230700001)(31696002)(8936002)(6116002)(3846002)(23676004)(2486003)(52116002)(44832011)(26005)(2616005)(11346002)(99286004)(446003)(6246003)(186003)(6512007)(36756003)(386003)(76176011)(53546011)(6506007)(25786009)(66476007)(66556008)(66946007)(4326008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3980;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aFNMNTF1ZGN0bHU5Uy9Ya1Q4ajNDalRtMzBXZlYvUm93WnkxVU9xUTBJRVpD?=
 =?utf-8?B?UTJyd25NMUFJa1U4N2VDZ3FpbnJKc2RMY2FGRDdtWkh3Tk1EdWJwa0RFbVlo?=
 =?utf-8?B?WktqcUN6bFM3bkNCb2c3WXByVU56QUtLQXpoRVVsRWFFeTVFZHJkaWtrYVY3?=
 =?utf-8?B?a3NROVB2L2Q3anR6ekZnSVdtZElJK0NuREZSZ0tQMU1SU3kvRncxdExJZkRV?=
 =?utf-8?B?c2RkOXMrY1RoK3UxcVBpOG9oZ2pUZk8xd2NaTW9yMXVkTlpKcWFReGhabGRV?=
 =?utf-8?B?YWFtaGhod2hTQVBLeDdKUTlvUW92UGpuQnRUN2l3eUNqNUJXbm9FYXgyaHJI?=
 =?utf-8?B?YUI0eHQvZlJJYzBKVEx5VHBhMVRnZWMrODM4S2dZZUJJdnJuWU9PaDJYUmdn?=
 =?utf-8?B?UGM2OFUrMEZQTTZJdzNJQjY1UlJqNUFmRUo1Y1ZlN3V4M1VlRjJkUHE4R0Zq?=
 =?utf-8?B?OXFOaHJndEdzMG9ldUQyMll5ZWlpNHh1M2NWNVczTU85bThraHg1bmh2S1JU?=
 =?utf-8?B?SmIxZkJRZno5ZjJqV21mdVoyNXQ1cVAyTnY4VFhaQW8wUFJpVllLbXlQczgx?=
 =?utf-8?B?ZTlpUlJ4UTkrenBiNHVyZlpmRVBydzZlWHh4cS9ndlNIdGpNRzJTbHNLS2NZ?=
 =?utf-8?B?bGo1R1ovWHJmekpKb3padUxKdkc3K2lER1VJR0o4TUdOdFlEY2pPTWRaNVFC?=
 =?utf-8?B?VWVRRnRKc2pUZGpwR3FXa3NwRGM1WEx4Sit4TGIzZVRpbmFjSmFsM2ZES0tZ?=
 =?utf-8?B?bVBlbGMzRFMrWkpFRU5nN1BFbTQ1U09ZdlJXbGFPQlpuTzV2WFAwY2pPNjg5?=
 =?utf-8?B?cEhTUkowaVpobHNLM3pJcnRSbjhQWmdsTHI1THZ5QUc0LytQT0pkbVR1MTZK?=
 =?utf-8?B?R1E3VEVHcFlYT2w1b2dSSkg0azluRGhIS25YRFpiUjI0dVFGYmN1bWFjcncy?=
 =?utf-8?B?ZWRxdFYvUS9wWlJjTHdKaFJsUXMwQ0FTZmtWY2hiWGV3T2ZQTEZpMzN2WTNj?=
 =?utf-8?B?cnFkZWpmUVBGbWZFd3Z0UWNkeGwvcXcvSzV6ZHdDcGN4cWM1VTliV0lGUVMr?=
 =?utf-8?B?WnM3ZjAxZzQ0ZkpXWXFRdWNLOHpkKysySlJadkFOR1JBNi9oWTJkZEMrMklK?=
 =?utf-8?B?VlhCcE1QRmgzQkQ1bjVFb1JaSHJIVzc1TzIvY1FyK1owSVBFVmVPK0FLNzN6?=
 =?utf-8?B?R3c0azl6K2srNHNNZkVHRkpqRXVHdUtnYVk1NG5uSll1R1A4K25PT0RPNnF5?=
 =?utf-8?B?R2owd1hzM0p6TVBTYVY3amdnTVg3eVJya3VnQ2s4aTRWNm1Vc3BDKzB5cjhS?=
 =?utf-8?B?MVcwTy95SUJXeDFlcXNTdnI3QXVOK3VIcHU1VnpubnJmeUszcHJ6VFM4cWM3?=
 =?utf-8?B?eWhXaGp0ZXRTTS9lWWhwVi8yRndZZ3RKZXgxb1NhN21ZVnNGTDMraVA4Vklk?=
 =?utf-8?B?ZHV4dEFlZk5aaUlHRnF2SDYvNlBuMS9uMElCMjgzR1hmS2RIYk84eGpYZDdH?=
 =?utf-8?B?T1VVMDkvM0V1aDZUdVRvcm45b3BGejcwVm9wcWhSMzVUQXF2bVpCdmRDM1Rj?=
 =?utf-8?B?elh1T2VRbXVzd0NVdUNBcDd3b0VXcVZEZmlobVNKdnhFQU5LakxpZDNRT0Yy?=
 =?utf-8?B?d2g3VzhldE9qMTBXelFibHk1eWMwdnFXa0NOekdIUTNRMEZzTlZHOEhCV2Fk?=
 =?utf-8?B?UnZNbW5WSk1nejNSM2JES0gzeGdQZG5CQ05rSjQ0RHlpb0hNMVJVeTZDQVFS?=
 =?utf-8?B?Sndqc1VIc1FhRThRN3NIZVNVZ3JKREMya0NZQThKQmxLQTZIczZHV2ptWUZo?=
 =?utf-8?B?VFJNRnJJUFY2MnB1T0pHZUlES3JCNnRFbUUwNU5HdkVoYWtpNEVEQ0hUMGl4?=
 =?utf-8?B?Vm1ML2hPbXMxQkFabzRwVGJsSnhES2NDVlVVbFY0OTRieGNidjJES2NWaDFP?=
 =?utf-8?B?Rlk4eGFRQWhxV1Z4V2JzSlJpbENlWTMvQ3hWakk1S1lZU3hiT1ZBVEc4SFZV?=
 =?utf-8?B?WjBFOGh1Mkg2M1YxTHpiS3lZcEtVc3BQZEs0RUo0aitOWkRSNVBiamxIK3h5?=
 =?utf-8?B?UUhjck1BMnlabmVSS25BTWlQRUQvM2R3VW82TVJQcmV0NkxRVUp2RW4rcm1O?=
 =?utf-8?B?cnN0bDdKVVo0UVdXZ09JZ2NnVXI2MGlkUHZQelJROHVPaUtUVEs4UVZ0ZitN?=
 =?utf-8?B?RDR6ZjlEcEZhVTVHbUhCemUxcFRlbXNBRkdQelY1ZDVkWFRzcGF6cDJ5Rk91?=
 =?utf-8?B?TnRKOS9NWVJRMytya21XdklDRUFyYnNVRktvNFhnR1RWZlJtWWwycFFuZmxr?=
 =?utf-8?B?NWNDbEVSdFdqSmVjazRmVEJ3ZXk4dk9ZbHZlUG9VYldQS0tCREt6b2cxc2Y2?=
 =?utf-8?B?eFczSElHb0xvTlh4NE9LSzFBWFpvd3BaZFU1Q0dHWmpnM3hwNVduYUVjNmFr?=
 =?utf-8?Q?AmRbkfc5+L8SdQgPN9UYpJ2PhbIq/K6NHys=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c105ec23-82c7-4449-6673-08d76f590afd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2019 14:34:12.6374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dHpZKVP7ntUxv9nVsTnQAAOTa6DjskLUlNdix3QQPafVUtEy2sORmjvH/6xPSAyytCi21Ss/pdOiioUbNGIZQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3980
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/22/19 7:46 AM, Paolo Bonzini wrote:
> On 22/11/19 14:01, Brijesh Singh wrote:
>>
>> On 11/21/19 2:33 PM, Peter Gonda wrote:
>>> Only pass through guest relevant CPUID information: Cbit location and
>>> SEV bit. The kernel does not support nested SEV guests so the other data
>>> in this CPUID leaf is unneeded by the guest.
>>>
>>> Suggested-by: Jim Mattson <jmattson@google.com>
>>> Signed-off-by: Peter Gonda <pgonda@google.com>
>>> Reviewed-by: Jim Mattson <jmattson@google.com>
>>> ---
>>>   arch/x86/kvm/cpuid.c | 8 +++++++-
>>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index 946fa9cb9dd6..6439fb1dbe76 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -780,8 +780,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>>>   		break;
>>>   	/* Support memory encryption cpuid if host supports it */
>>>   	case 0x8000001F:
>>> -		if (!boot_cpu_has(X86_FEATURE_SEV))
>>> +		if (boot_cpu_has(X86_FEATURE_SEV)) {
>>> +			/* Expose only SEV bit and CBit location */
>>> +			entry->eax &= F(SEV);
>>
>>
>> I know SEV-ES patches are not accepted yet, but can I ask to pass the
>> SEV-ES bit in eax?
> 
> I think it shouldn't be passed, since KVM does not support SEV-ES.
> 

Fair enough.

-Brijesh
