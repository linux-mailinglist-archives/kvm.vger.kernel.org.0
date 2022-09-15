Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483665B928D
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 04:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiIOCLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 22:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiIOCLu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 22:11:50 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178238F956;
        Wed, 14 Sep 2022 19:11:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9h9vlftoztPKZBnUMeZO/J/NOy2Gq2kTpRe0J4A/yD7N79WcpDKiDHu1H06IfLxRo6NUnoxYjFMrnF8cKigxasUtC60vN1zz7cg9Nc+AxFmkNkyjHtwKBpnBBRjXfZX3pVJv3mKxt/bvbGgYgIn5Xn47rlLdoGHeDEAXbcWwHfE01NqEoP74VqNeSG2g32idIGXAfEH3GxiwROKLAzsMS2YWQlmpLoEEWLXpy9e6COzmusKjTYpiWoeje/lLLC467CzOQOga/OEX1gKXfu1a22sYrd2UgD/6MWwtCU4hONCqqFiglN+qebh95mGsYFROxya4rMrduPA3/zuQ73ylQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nGg4iARzWHHobajSy7mAy/W5DYrK0vQN7meJJPKul0U=;
 b=bNGUgOZjcvWqpIScoXuT6lMSvcNQhe9PuxSgzWucqRE5b5kduUvXjLweQKl0yRvs99dj0E262vPiUI3wBRn2UdOscCE+6ImdWhzNG8wSjPFwqqsHY2sDvPTBZn6iBMSZTzulg8lJ6poWAEv5PPE6jbPHi0nuws0NIfSAzDrYPAPTtdSEykf7M1xJRuplDSogC0eLxWnw8v+xumra8W+IqqGExvrBIy/hTyJ9+I+tOIyQHBD9ZQ7+chHsCr9qHdUgyicRpg1rXPuFcKdV50xG10n53OWSo4U9UICYGR8FmACKFj3OYIYbZ0ElHXd1idFwAImgIdchfxNYa4eaAgFgOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nGg4iARzWHHobajSy7mAy/W5DYrK0vQN7meJJPKul0U=;
 b=g/NNLGpKVgtm5CGniRUQAF7envKWEOHEf534J0kevtUzhtfFavfKqFRNFjrHZF7uwjlAPdxen09EDD9YNuvYdgvZqS6LDkDes1JsbhMRcBO3e7y0cEqXyYFG7TSqUfEk/uE/jB4lltwGWgaqbtk5x36ECCpPP6DOnPoQycKF6lQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.15; Thu, 15 Sep 2022 02:11:43 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::2cdd:defc:a6d3:7599]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::2cdd:defc:a6d3:7599%3]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 02:11:43 +0000
Message-ID: <59c2085e-1f0a-fe7d-8146-6c1bc570c97b@amd.com>
Date:   Wed, 14 Sep 2022 21:11:39 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2 13/23] KVM: x86: Disable APIC logical map if vCPUs are
 aliased in logical mode
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
References: <20220903002254.2411750-1-seanjc@google.com>
 <20220903002254.2411750-14-seanjc@google.com>
 <aedb7677-528a-75b7-6517-ab1865515ad4@amd.com> <YyGF6T/N1l3i7Ded@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <YyGF6T/N1l3i7Ded@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:610:b1::14) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|SA0PR12MB4431:EE_
X-MS-Office365-Filtering-Correlation-Id: 831478d6-3580-435f-15c0-08da96bfa275
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: llqFTlvTWLg9jdek/2fKu4anWZC1J7CMoQgBbl0zX87SlTQS9WXUeGkajsWqsd1HO8iZUSHvmZhOLkjXdd+lfRHdO6ggvR/khboSkHSkeqq4In6OAfBNV3t2kyWb+A6x+SMbvkJJYBqABqU8ODiDmEAve81fwh8HBRZsisTf8nFJ7K4UrZmtCfHAO4xiG+X1VtMO2hOKVJCI0O0VjXRS8C1CwPuXbBncNWvnEq7zy77ZvTCiQriZA1cBRNlWmAYfkjCbs/ZYAHzomc5KU9XFWnxvU+QjVJX/VmgifPy89Z/Q4ODEw7bdxDt7gM8/h9MnzZGmtSjOI9GzMBZIhPdBPovzCjj1PVD6q7Ncfaa8gu7rlzR7glCGRSP8Tx5V4nDovMAs1XnalQszvDdgNYXnG3UkmMc/+tVmGz1pcANLODWEnqxmyvgeHXYGnvCg4JVaXZQaxUAMEAGXPbpzjTrzmeBdCPAelSehLkvlArqfpBtGFKtUeyR5bFCc97eK3hHdbbKVIRUf9s+KK+a4MucarA9cApNiL4kGSHuHlagILXFV+Dkg4SSMzbZh6PAXyuhckc1bBoNGxLAaCcp5TA4wEfPfzeViuA2SWiDQqz/vhHL3lGdQ7va5Zbt3Ngg9m/WASU/yb35cw2HoKqnm+m3iohcxOSv+7VPSwYonl2eeJVceNxdK9yvZwbTAn0u77eelpVFaiObdvovji/MjPgloL4W57U0YPyNgvin5RlXYitDfTYKsHEKGHSWYBqMJeob46U5Jluq/7Bi8txUUBol/POrdoWdu6hrd5+iHZ3dCwAg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(451199015)(41300700001)(26005)(6486002)(6512007)(36756003)(38100700002)(86362001)(31696002)(6666004)(316002)(478600001)(53546011)(8676002)(66946007)(66476007)(4326008)(6916009)(66556008)(54906003)(6506007)(31686004)(5660300002)(186003)(83380400001)(2616005)(8936002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHByUThDTG0yaXI5WkdXNUR3VmNmSngzdWQwNDBSUWFtdzJGY1htR1NDcno4?=
 =?utf-8?B?cHlBMjhJVjErV1JiRFhQMEVPN3VIRi9BbFRIeEhGS0l5NTdCYjZTd1JTeFZ2?=
 =?utf-8?B?ZXNsd01TQVVXV3RZUjB4azNoWkdjVXdld3o4SFNhNTJEN003TFBMQnNaa3Qv?=
 =?utf-8?B?Z1JHZTRRc2tvcVE0dG5aNTdpM1J5eEx3K3dzTENkSmNac0wrRUcyNmFjODdj?=
 =?utf-8?B?RjVIWkpBY2VabW9LUGVCRlVzcHVadys3ay90UlZ1cmliOVVWd0hIeFQyTWhK?=
 =?utf-8?B?NWltV2hEUlU0c21KV3FsajlPNFVWakNDSTJ1dk5OcXV2b3NSdDlGbGoySzdL?=
 =?utf-8?B?S0h4UnA2SE1qQmE2bXJWc2tjd2VVajF6WnVPb29PeENRd3ZabjlsVC95cXBV?=
 =?utf-8?B?eTlBK2NCUWxaQlFnZmEwN3FPWmNLU3VVVWhJVms0dkxpZGgyODNLWUQybjZi?=
 =?utf-8?B?M0RKT1UxbVkyQlBzWFhlVVNSRkZ1SWk3dTMrQXhxeEhxQ2ZBTmRIdTZBL3k1?=
 =?utf-8?B?NEFlMVpwYjlMdnpqWEsvU1loODJrUW13N2x2cDhuN3o5Y0hlTDNzNTZscy82?=
 =?utf-8?B?ck5pS2E3MzJzSFpZMy9UQTQ0ZUFlQ3ZPemV0cHVoem9BanNqVy8yUk1LeHVF?=
 =?utf-8?B?cm02YUhraWFldXFPczB6VVN2bGVlS0JpTjhHa3pFeklhU1JFdEt2SE9SM1FZ?=
 =?utf-8?B?K05MMTBUZkQydFgwTWZJMGIzR0xmTUlhTDNZZFJXeUlPVVZtZGZRMGNTMUpl?=
 =?utf-8?B?MXJaSytvZlY2WHRic2dwNkFCVXJmazlmY1lLb3ZsUnR5MDJ2Z1daTHpacWxy?=
 =?utf-8?B?NUhHK00wTXBkK1hoRVVTbXRmZSsrR0F0cXVoTnNTWHhqdjNYcS9SUU1leDlO?=
 =?utf-8?B?QXJZN3g4VXZFWlZodGpuMzN1MVZUeDdkL0pWMU9XUGx4ajlQVjRWUm9Uckx0?=
 =?utf-8?B?dTBoUG9wNVpWVElvbmxrS1N1L0w2ejNHOCtBbEZ6TTlsZkdlODg1aDdndy9O?=
 =?utf-8?B?a3QyVmFUdDFiTXMzRzNRVFRscTRTbU1taWNxVno0MDRIdHNLamNzRTlPTm9m?=
 =?utf-8?B?MThDWkU3bmJ1YjVCTWtVeUdHRVFjTGpoSGZaOEY2NGxUYXNueGVDVDVKcytJ?=
 =?utf-8?B?T0hIRjMwUVV0WEF0aGxLdTdCOFlVY3V5UUJScVB5VTYwajlUWHN4OWJWNXdY?=
 =?utf-8?B?c3lYR1llZWNYWlRCYTFsd1VYN2dmdWZYZUxoc3VaMDl2QVpTdDdXNzZyYVA1?=
 =?utf-8?B?NW01SlVlWGhmSm56VlY4ZnBJeGpBeWVNV2w4R2M2TlIxWVhHYXR4Sk14QXlJ?=
 =?utf-8?B?dmhEVy9iWTRaRXQ0YUUxTEU0Yk14Q08zR3ZOZDVMa3ZLbFNaSXYrNnllbW5Z?=
 =?utf-8?B?MHZQdUFsZDFkbjdLOTd2NjgzNk8yM05RSTZudElMajhVWG8vSkc2MXhxbFZN?=
 =?utf-8?B?NVhXSGlUUTE5V1BBTjFyQ0tVU0sxcjN1UHk1bWZjU1dFMExCVVc2Vm5YWTV5?=
 =?utf-8?B?ekVtWTdLUjN4eDZpaXRFSHllNGoxZ3hBc04zT0dOUklCQVVCVFViNnkvbndG?=
 =?utf-8?B?c0FNVlBIeUM1T1ppcGM2aEZyZzVxWXNrOWNlem84YmxaR21yOGpUK0FmQjEz?=
 =?utf-8?B?ZUI0dHhJTzBYMVdobllqWkVRWkZZTG1EL01oUm5qZVdvUlpkdndNaGUvRnNH?=
 =?utf-8?B?L2dXYWhoT3hqbit1Y0VBN2RSbThSVG5CZjBPemptRlg5M0VxdWY3VCtWNmgz?=
 =?utf-8?B?ZmRhMTVLbkFTN3JDa2FMMFBmdDdpRTVPMHVjWXl1cFIzSk9aV1ZNaW9PTlNE?=
 =?utf-8?B?RDFGalpWRmsrYXFMS0RienFhcFJONHdDcXFTK05uZzhNNjBXL2g0ZmUvL0N5?=
 =?utf-8?B?TTJsUVdFNllER1Q5THNzaXpYOHU5UE4rQnA1VkpweHkvWGFVOFJ4dks2T1RW?=
 =?utf-8?B?Z29ybDRCQUlkY0JFM1lJZ0NxMUVNSG9xTitjazc3QmNwWHZmaWt4dFRVdXV4?=
 =?utf-8?B?clRvalVTaFhQcGNhMFUybTc3ZXU5VlhWUHpHTlA0ODdlaWhYajNmSzVrMmVM?=
 =?utf-8?B?Qi82WkVtRExJSGRuVHdvSjVYNnVGVUcvT2oxT1A4Q2QzRTk1MDVsaUlwcDhl?=
 =?utf-8?Q?u6bPiqB8KCKE/zaFR7nAl7hT5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 831478d6-3580-435f-15c0-08da96bfa275
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 02:11:43.6411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ARJnoMOxDbgInELfladtwc57cHqToO0Gt7DlW9POydea12H4u90lglc58fv8gC7/2fLkiWqzJt2IcjshB0A7XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean,

On 9/14/2022 2:42 AM, Sean Christopherson wrote:
> On Tue, Sep 13, 2022, Suthikulpanit, Suravee wrote:
>> Hi Sean
>>
>> On 9/2/2022 7:22 PM, Sean Christopherson wrote:
>>> Disable the optimized APIC logical map if multiple vCPUs are aliased to
>>> the same logical ID.  Architecturally, all CPUs whose logical ID matches
>>> the MDA are supposed to receive the interrupt; overwriting existing map
>>> entries can result in missed IPIs.
>>>
>>> Fixes: 1e08ec4a130e ("KVM: optimize apic interrupt delivery")
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>>> ---
>>>    arch/x86/kvm/lapic.c | 5 +++--
>>>    1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>>> index 6b2f538b8fd0..75748c380ceb 100644
>>> --- a/arch/x86/kvm/lapic.c
>>> +++ b/arch/x86/kvm/lapic.c
>>> @@ -303,12 +303,13 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>>>    		if (!mask)
>>>    			continue;
>>> -		if (!is_power_of_2(mask)) {
>>> +		ldr = ffs(mask) - 1;
>>> +		if (!is_power_of_2(mask) || cluster[ldr]) {
>>
>> Should this be checking if the cluster[ldr] is pointing to the same struct
>> apic instead? For example:
>>
>> 		if (!is_power_of_2(mask) || cluster[ldr] != apic)
>>
>>  From my observation, the kvm_recalculate_apic_map() can be called many
>> times, and the cluster[ldr] could have already been assigned from the
>> previous invocation. So, as long as it is the same, it should be okay.
> 
> No, because cluster[ldr] can never match "apic".  kvm_recalculate_apic_map()
> creates and populates a _new_ kvm_apic_map every time, it doesn't do an in-place
> update of the current map.

Yes, the _new_ is getting created and initialized every time we call 
kvm_recalculate_apic_map(), and then passed into 
kvm_apic_map_get_logical_dest() along with the reference of cluster and 
mask to get populated based on the provided ldr. Please note that the 
new->phys_map[x2apic_id] is already assigned before the calling of 
kvm_apic_map_get_logical_dest(). Therefore, this check:

	if (!is_power_of_2(mask) || cluster[ldr]) {
                                     ^here
will always fail, we are setting the new->logical_mode = 
KVM_APIC_MODE_MAP_DISABLED, which causing APICv/AVIC to always be inhibited.

I do not think this logic is correct. I also add debug printf to check, 
and I never see cluster[ldr] is NULL. Here is example of the debug 
printf just before the check above.

printk("DEBUG: vcpu_id=%u, logical_mode=%#x, mask=%#x, ldr=%#x, 
cluster[ldr]=%#llx, apic=%#llx\n", vcpu->vcpu_id, new->logical_mode, 
mask, ldr, (unsigned long long) cluster[ldr], (unsigned long long) apic);

DEBUG: vcpu_id=0, logical_mode=0x3, mask=0x1, ldr=0x0, 
cluster[ldr]=0xffff8f54fe7e8000, apic=0xffff8f54fe7e8000
DEBUG: vcpu_id=1, logical_mode=0x3, mask=0x2, ldr=0x1, 
cluster[ldr]=0xffff8f5475c28000, apic=0xffff8f5475c28000
DEBUG: vcpu_id=2, logical_mode=0x3, mask=0x4, ldr=0x2, 
cluster[ldr]=0xffff8f54ac488000, apic=0xffff8f54ac488000
DEBUG: vcpu_id=3, logical_mode=0x3, mask=0x8, ldr=0x3, 
cluster[ldr]=0xffff8f550dc34200, apic=0xffff8f550dc34200
DEBUG: vcpu_id=4, logical_mode=0x3, mask=0x10, ldr=0x4, 
cluster[ldr]=0xffff8f550dd08000, apic=0xffff8f550dd08000
.....
DEBUG: vcpu_id=15, logical_mode=0x3, mask=0x8000, ldr=0xf, 
cluster[ldr]=0xffff8f54ac488200, apic=0xffff8f54ac488200
DEBUG: vcpu_id=16, logical_mode=0x3, mask=0x1, ldr=0x0, 
cluster[ldr]=0xffff8f5531ff8000, apic=0xffff8f5531ff8000
DEBUG: vcpu_id=17, logical_mode=0x3, mask=0x2, ldr=0x1, 
cluster[ldr]=0xffff8f54e87c8200, apic=0xffff8f54e87c8200
DEBUG: vcpu_id=18, logical_mode=0x3, mask=0x4, ldr=0x2, 
cluster[ldr]=0xffff8f551c870200, apic=0xffff8f551c870200

Please, lemme know if I am missing something.

Best Regards,
Suravee

> The loop containing this code is:
> 
> 	kvm_for_each_vcpu(i, vcpu, kvm) {
> 		struct kvm_lapic *apic = vcpu->arch.apic;
> 
> 		...
> 	}
> 
> so it's impossible for cluster[ldr] to hold the current "apic", because this is
> the first and only iteration that processes the current "apic".
