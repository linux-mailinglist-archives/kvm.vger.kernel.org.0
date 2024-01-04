Return-Path: <kvm+bounces-5622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BBD8C823BC9
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 06:35:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2105CB24D80
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 05:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C4618ECE;
	Thu,  4 Jan 2024 05:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nZCv7TxS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2143A1862D;
	Thu,  4 Jan 2024 05:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JjKlUH+y2vmctWkB3Xo7zW3qX31AhfoVhaFIPVagJ8EzG/lOZaojmBw5CyN87DNxUbVUTa0td/kgTOSKGhIEL3CJuwx6+fXfEp3ILBQLnIfC7Nj9+MlPOWIE8d0s+T8ZmfHDeUDvuSD3bojqOKfr3uG/ljmKMQRLqC36XD6LhiYIswtwOq7zjSl7JEpGv2bDt25aF6bbbDlrUdA9v6iWks5hY3wAY6WRloFj61No1v28SG+gqUJavCorhUxa4Fo5OHTzVUTQeUp2Ui54L647omz/uSmKCFte5GZYTnc8ijyd6wXs2V5zg/TZUksGfskmYuBQbjiwDEwG33o159ma5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QowEmz7Kw5/6C3xmIb9fFwNqm/JNaNkJxcGFnIAAPfI=;
 b=SR6gYx0GJHDTOgqJGruHkT8KUyEDPOIm10GrbEyzCw1KbTjqMMKajpwQK/Kq1mze+FYwME90p+Bs8Ir9cNSETPqLKczNL1U0lPA1LmSGKtxUAPLx2qLv06MdZ+ywMwTxMI14G/8+3y9xBMWJkhmTwcDBgeI3tq+cebtksTGEhA8N7hayHMMaswW4t8uYvDA3bGPKR2ykSvf927n713UZa2fncCqGiVmO8TZNfAqJO7AeA5exDru57uSgb6F6j5FGzIq5fOpT+Ic1msKHBrxvLJWlipt/ANhU898FVFhuDErY74/IR4v7pLG/zkNzuLlzJPDTaQzByObxQxwJzhKOmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QowEmz7Kw5/6C3xmIb9fFwNqm/JNaNkJxcGFnIAAPfI=;
 b=nZCv7TxSQgW2JWAidX51PzwPRyAkYn5bgr87EnzkiyKukJDQA7BtuytPfoVkNhyPsT0waeLc2OPV/XPVpcbjC9yjGMLl5ZPhbd037qsTxTgSEQaF8HFtfes4nBc915pKTMQiAVrStIVLR/oZWq6mmRUrxh9iaDNBWOO3VZtvjSY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN7PR12MB7276.namprd12.prod.outlook.com (2603:10b6:806:2af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Thu, 4 Jan
 2024 05:35:14 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc71:c26c:a009:49]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc71:c26c:a009:49%4]) with mapi id 15.20.7135.023; Thu, 4 Jan 2024
 05:35:14 +0000
Message-ID: <76b1660e-4b14-4485-9511-8a96b0f666f7@amd.com>
Date: Wed, 3 Jan 2024 23:35:12 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/sev: Add support for allowing zero SEV ASIDs.
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com
Cc: seanjc@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org
References: <20240104024656.57821-1-Ashish.Kalra@amd.com>
 <e0d349f4-0267-b339-313c-09dcafb14a71@amd.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <e0d349f4-0267-b339-313c-09dcafb14a71@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0127.namprd11.prod.outlook.com
 (2603:10b6:806:131::12) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SN7PR12MB7276:EE_
X-MS-Office365-Filtering-Correlation-Id: 46b93ef9-221a-4d27-d8ba-08dc0ce6ed5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nIk4Y7xbomwLY+tjSvOqEeatpKpo2AKGTu12JiFaOEwZg5Nr2OBKKEjC4+nRMGBQSX3SxK80nZ0qIxDtj4sIMU3warSD46YtxLPmlwG6FG4bBK5dWoKAohFl7g01ZEEvZjAYsgVF1j9O7sO9kWm8FRVeJ9QgXjT+c1ZJmzR8VTGK+tO0xwrfdltq/Vqx4ox1nwQlBbbdyQEbrNJnkVwm9EYRpabs6gEaZsKE9je0ixqpoiSHPcnuC41y9kpsN18A3xb+qsKQUK1CdXxzf3Zs+ychUw4PfEs/lyIYmK13zgIysxqC/lpz8J4l0sJp/cRtVUy+2ispLhsXJeQLuytr7E3QRIdVJJDRAVglzoS5wHP/gDoeY4Ji9wcTtYt8YCA21WiS9CI1cPtA6KLNU2FrrVcGj/ySUEf6DqaJnQecOW7g0+uBJw5KIi0LiTf/g52JQRnY82oD0CkkgfU/+ybD2bejx1zwzBQIKEyvF4NnYsqSA9Jefi6UJJdf7F1Oobe2w8IDA8RCy817ioNwyRj6+0/73LBOVhj18TICS9flf9CdFAhH5gpHxvjOek4qkShXw7bMbkqfFtHiN0XECW9sflChtanUIIJhhiDuVIPxTYrDy5Z8PMlV72KOP/tRu/EaT+mHqtAO//50vYdPd1/ZDA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(39860400002)(346002)(366004)(376002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(38100700002)(36756003)(31686004)(31696002)(86362001)(53546011)(83380400001)(478600001)(4326008)(66556008)(66946007)(66476007)(6486002)(26005)(316002)(2616005)(8936002)(8676002)(6512007)(6506007)(7416002)(5660300002)(41300700001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGJIUTdWNTM4T254OUNDQm1rMmFjbnRyWlltYzV3c05jUUVOQjhUenJodldL?=
 =?utf-8?B?djhSaEpDbWdkdEZlakIxaWNXcng0ai9kOENpTiszMnA1VEdRQ3BsUG1NV1Zj?=
 =?utf-8?B?OGR5WURUTkY0YUVTekR3OHYxWVdMdU9OQ1ZuV214bFQ3WEpYQ0JlMUJhZmx0?=
 =?utf-8?B?a2U4K2RpNi9VOFc4YlpZMXhuT2lFUm5BMVRJUGNYUTVWNk9UUEEzd2M0WjAx?=
 =?utf-8?B?T0xRaVBwNktkaS9xSnNsR3VUT1MySExUMEJSblM3Tk9wY3dkSm8yeXQ0bEhi?=
 =?utf-8?B?Z21vSnJsSVhtT0dOb2FURHcvcjJ0TVlpVnVQeEdNSTNoMkN4bFAzZm1lVmlB?=
 =?utf-8?B?TG5qN0NuYVNuNTc3Wk5zTUdtMXVENEZRbm9XWktWQ01aS250NHhieGZSOVpp?=
 =?utf-8?B?aFo0SUlpWFAwcHRpUHg4YlQvU0JUbUMxQ2xFeTNWek1EOFRoQmh1S0lXSitL?=
 =?utf-8?B?VHNYR2VReFlGYnowd2UwcjJuQVdsaCtXb0hDa1VxOXltWUdRNThwQ2hFN3BD?=
 =?utf-8?B?TW0yd0VUeFFKVFBseUJEOXVkTE1qR1FCbTNHOGJuWkdyUkVEbkFNT2RVQXAr?=
 =?utf-8?B?ZFlaNENRK2FkUXVidGdrYWpjL2JLRVBzdjkwQ0JDbFRxRjMrMktoRFRoK0s2?=
 =?utf-8?B?MjcwMFlpUXFCYURRZWlESkNRSnBOQVdHcmN3cUFrd3EvT3BxNXVoZGQyMmkv?=
 =?utf-8?B?MUFDVTJNMmdRQ3h6MkE4K2hFUDFra2pWRk93SDBlZU1QVUxUY3ArMncrOEs0?=
 =?utf-8?B?S2F2MnNBZE5ieHNHK0FDbWQvbTJZUXZVRWxJN01oSzRWSGFERStTQXFFR05H?=
 =?utf-8?B?UVFjcW16bkZvT3lJRkRxL1FUeGhMSFdqbzlFNnZpTEEwUDY4Sm5VYzJwekZo?=
 =?utf-8?B?V0R5K2hZR2RUMlRoMjZXOThuWk56aDZVVEVCdC9ZeWVUaVd0QmZiWFFQdkZI?=
 =?utf-8?B?VXhkK1RlV2NjY1NOVVM3Qm5IRXJtN3pyRWN3YldUcTBJZS9zS1dQZCtVMU5s?=
 =?utf-8?B?aEtVOVFMKzdmbDhoZ2ZzVlFLTjhiaVlQWnZ1ak52Z0J3V2tLakRzZjUyNWFB?=
 =?utf-8?B?dWlzdjc1YTJhL1ljRFRZcmYyRlhIejZacGs4R21iaXF1bzNmQ3BmbC85L3dG?=
 =?utf-8?B?TmlDcERFY0JpdGkvSFBYbW50UksyMmZLckYvdzUrOUxncjE3U1dhcjN1bHNi?=
 =?utf-8?B?d1EyN2I0MTArZkY0TWt5ZUlXSTZhY1RCU0lORFZyRSs5eGVPSzNxWjk2cHFF?=
 =?utf-8?B?VEJhaDFmcXJmYm5IN1VhZ0NQKzY4emVxeXV0dUgxS1Z3U2U4OHJ1cS9CdTBX?=
 =?utf-8?B?UDNJYXJCdnFxQVJKRmo2OW03aVJQRGozUnVsT01uUzJ3R1gwU2ZCYUdPeTU1?=
 =?utf-8?B?bHFENTMwZ0s2SnZMdjhmWEJ6VWdUME1VeGJxNDg1UVNNZzFKUHkreTdreERC?=
 =?utf-8?B?OHNTZExiTXRVdU83OEkyb29hOW40NHRyK2pTU3lYTjRhMXgvN1N3OFpVWVM5?=
 =?utf-8?B?dnFxS3lXSmZVTXYwMVEwS3habGNtTUdiVnAreTNXTDNHakFLVktoZG1QTzlX?=
 =?utf-8?B?M3c2RlBISFRtTHFUWC8vcldlcUpIWUFIazR5bkgvTWZQODFEKy81RnRSUlVn?=
 =?utf-8?B?NjIvU3poVC8xUTQ5b1IzcUxvUVdTUytoSUptcnR2Vk5DT2VJTnZ3SGJ5aXBL?=
 =?utf-8?B?ckw3SUFNWWZoT1pmeXNnSXRnc0JpRGUrU1dNZGZyNEtDQ1BSanUwVzV1WlRT?=
 =?utf-8?B?Z3dwY2lza1UyY1RKRkhsNjNoNUtOcnViZ1UxQ0ZnckV0M3VJN0lvNk45WTlW?=
 =?utf-8?B?c2czYTREbGg5VDM3QVhoSVRzUWF6SmovcEFzRUFkMEtseis1NWRHa2tkT2Vx?=
 =?utf-8?B?cENVUTZTUGRkWGoyMGZzb2hPSHZ4dUlySXQ0eERZTFJrV0FuQ3Q2L1ZJeVho?=
 =?utf-8?B?SEpPME5DM29wRVJTQXpjNWJXeXV2WG91UkErQVhFdCtOU2lvdEE2bU5VZ1B5?=
 =?utf-8?B?aXJxNVFKbHJpa2wvVE5FTWo1UTM5djc2YzcxT3JBUkVvbU83b2Nla1lwRkxa?=
 =?utf-8?B?NmYyNElFbDFZTk9rQ2FYSGJiUjBmaGVDakpQVHluNm1ialNxbWFGd2Rjb01t?=
 =?utf-8?Q?7T+EHS25/7B3of55NlFfVL8Nc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b93ef9-221a-4d27-d8ba-08dc0ce6ed5f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2024 05:35:14.6026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7zKFnsnf9rrvqNzqd+hdJFt+mwlqHADuYt0gnc+U676XN1Yt8yU2oq9FymCYx8uzWWx/swxJHw9GNyoHMRp3cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7276

On 1/3/2024 11:28 PM, Tom Lendacky wrote:

> On 1/3/24 20:46, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Some BIOSes allow the end user to set the minimum SEV ASID value
>> (CPUID 0x8000001F_EDX) to be greater than the maximum number of
>> encrypted guests, or maximum SEV ASID value (CPUID 0x8000001F_ECX)
>> in order to dedicate all the SEV ASIDs to SEV-ES or SEV-SNP.
>>
>> The SEV support, as coded, does not handle the case where the minimum
>> SEV ASID value can be greater than the maximum SEV ASID value.
>> As a result, the following confusing message is issued:
>>
>> [   30.715724] kvm_amd: SEV enabled (ASIDs 1007 - 1006)
>>
>> Fix the support to properly handle this case.
>>
>> Fixes: 916391a2d1dc ("KVM: SVM: Add support for SEV-ES capability in 
>> KVM")
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> Cc: stable@vger.kernel.org
>> ---
>>   arch/x86/kvm/svm/sev.c | 41 +++++++++++++++++++++++++----------------
>>   1 file changed, 25 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 4900c078045a..651d671ff8ae 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -143,8 +143,21 @@ static void sev_misc_cg_uncharge(struct 
>> kvm_sev_info *sev)
>>     static int sev_asid_new(struct kvm_sev_info *sev)
>>   {
>> -    int asid, min_asid, max_asid, ret;
>> +    /*
>> +     * SEV-enabled guests must use asid from min_sev_asid to 
>> max_sev_asid.
>> +     * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
>> +     * Note: min ASID can end up larger than the max if basic SEV 
>> support is
>> +     * effectively disabled by disallowing use of ASIDs for SEV guests.
>> +     */
>> +    unsigned int min_asid = sev->es_active ? 1 : min_sev_asid;
>> +    unsigned int max_asid = sev->es_active ? min_sev_asid - 1 : 
>> max_sev_asid;
>> +    unsigned int asid;
>> +
>
> Remove this blank line.
>
>>       bool retry = true;
>> +    int ret;
>> +
>> +    if (min_asid > max_asid)
>> +        return -ENOTTY;
>>         WARN_ON(sev->misc_cg);
>>       sev->misc_cg = get_current_misc_cg();
>> @@ -157,12 +170,6 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>>         mutex_lock(&sev_bitmap_lock);
>>   -    /*
>> -     * SEV-enabled guests must use asid from min_sev_asid to 
>> max_sev_asid.
>> -     * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
>> -     */
>> -    min_asid = sev->es_active ? 1 : min_sev_asid;
>> -    max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
>>   again:
>>       asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, 
>> min_asid);
>>       if (asid > max_asid) {
>> @@ -246,21 +253,20 @@ static void sev_unbind_asid(struct kvm *kvm, 
>> unsigned int handle)
>>   static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   {
>>       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> -    int asid, ret;
>> +    int ret;
>>         if (kvm->created_vcpus)
>>           return -EINVAL;
>>   -    ret = -EBUSY;
>>       if (unlikely(sev->active))
>> -        return ret;
>> +        return -EINVAL;
>>         sev->active = true;
>>       sev->es_active = argp->id == KVM_SEV_ES_INIT;
>> -    asid = sev_asid_new(sev);
>> -    if (asid < 0)
>> +    ret = sev_asid_new(sev);
>> +    if (ret < 0)
>>           goto e_no_asid;
>> -    sev->asid = asid;
>> +    sev->asid = ret;
>>         ret = sev_platform_init(&argp->error);
>>       if (ret)
>> @@ -2229,8 +2235,10 @@ void __init sev_hardware_setup(void)
>>           goto out;
>>       }
>>   -    sev_asid_count = max_sev_asid - min_sev_asid + 1;
>> -    WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, 
>> sev_asid_count));
>> +    if (min_sev_asid > max_sev_asid) {
>
> Shouldn't this be: if (min_sev_asid <= max_sev_asid) ?
>
> You only want to do the misc_cg_set_capactity() call if you can have 
> SEV guests.
>
>
Yes, it should be, will fix it and post v3.

Thanks, Ashish

>> +        sev_asid_count = max_sev_asid - min_sev_asid + 1;
>> +        WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, 
>> sev_asid_count));
>> +    }
>>       sev_supported = true;
>>         /* SEV-ES support requested? */
>> @@ -2261,7 +2269,8 @@ void __init sev_hardware_setup(void)
>>   out:
>>       if (boot_cpu_has(X86_FEATURE_SEV))
>>           pr_info("SEV %s (ASIDs %u - %u)\n",
>> -            sev_supported ? "enabled" : "disabled",
>> +            sev_supported ? (min_sev_asid <= max_sev_asid ? 
>> "enabled" : "unusable")
>> +            : "disabled",
>>               min_sev_asid, max_sev_asid);
>>       if (boot_cpu_has(X86_FEATURE_SEV_ES))
>>           pr_info("SEV-ES %s (ASIDs %u - %u)\n",

