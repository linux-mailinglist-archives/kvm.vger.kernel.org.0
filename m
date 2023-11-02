Return-Path: <kvm+bounces-360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD9DB7DEBD2
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 05:29:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 365DCB21207
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 04:29:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345191FA4;
	Thu,  2 Nov 2023 04:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0D6eGGT8"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B505187D
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 04:28:57 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D23CA6;
	Wed,  1 Nov 2023 21:28:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDu8l399gDfJCwC5yi0wt/cpIKafPRi63fGE2jKTfcWl1x5mCE206dHfJJmfX22iw3TDRYrzRcCMxmMzEO8OXEjAxeWLOTMwo1l3VoCBPJOKCb7z+E1q6f8nahiWfnmVkm5egoa2CALK40IiRNAq+eL8w4UaXFJOZvU0Z3Om8EeiS2L87NkHKHWXDLbJ0ODSB8rH1CKoyuRWR7PHB3/GswfY7YqBlSx5+coF+vjIF3Wj3uZxS1zA6EE1OBsR7BcA4UOthS2nwBVQGz+PGuhCNqb/Kgj8nJ8e/1sWkVM8dsPgHjBOcRV/XgNd5yP1QQoPThH9JYKVedQ9fKHVmQDNAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MBzFsb/mmAsmuG183uvHIMdxGM8iB+gV4+iDV+jg3R0=;
 b=WZNvXuzORPJj5oGO+RaM9ug62qLeKvNV6wP+Tm1/r2laePgXuhfyYMQknbGYV6c29kJkQ06ZoR5MFNQWfPfMYfsRe/q9eBI7liRSBHm8ZijqA7ynCR8/jWPWqKFg3iA9OHawBe3tkSr/Hrs8qSjvdmDuyYx45P56KrhC5MIM8GaB7iPu1s0nfjYiTPMjhfu2qn5Z585kndNCi/Lp70yaqpKXSZgKObDFL2FUJYvH+HgBrbmaXbo2EdCf6kdd04MdiMZjz9dWYwi+dh0Zq1cu9o4ZH7KqJEK4KgWk1DpMFmU24VXiV2DXkJ5T+0zbSmbYPEs35meUJyAK/L46EkQGdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBzFsb/mmAsmuG183uvHIMdxGM8iB+gV4+iDV+jg3R0=;
 b=0D6eGGT840f7tXOuKIh07glZN2ScUTwbau94kcrIuSAbpnh2W0v366+dP1V+au3bd96Bobonw2lZQX3pfaqexe0/IADz8UU5Csxw7lPBKVXir/x+eEbEtUFY34PaXxos3laefWKEmkC1wO0f1BgO085bl87ZOLiOP2NiK+eOl8A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN2PR12MB4093.namprd12.prod.outlook.com (2603:10b6:208:198::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.22; Thu, 2 Nov
 2023 04:28:48 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 04:28:48 +0000
Message-ID: <d1bb638b-cb7e-44d7-bd70-e1282c993ca4@amd.com>
Date: Thu, 2 Nov 2023 09:58:38 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v5 07/14] x86/sev: Move and reorganize sev guest request
 api
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-8-nikunj@amd.com>
 <d34d280d-badb-18e1-c17e-bcf079f368de@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <d34d280d-badb-18e1-c17e-bcf079f368de@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0195.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::20) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN2PR12MB4093:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dcfc6a3-0876-4b1f-f336-08dbdb5c3546
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3y4Nkc1Og9UES6Ms/g44KlRzHHFcq9vgq2Ocoq4WN7DpBZpF7o44+fyoAoKrmzN6ISnSRX+ahnwICzTyt6BEvIZOMp8fv8pmDBjWbUndEASMLrLzzYfL/+FlF9j6JEGKDHn3MgyJv9xa2S5nMOxTW4BO5rnrb/rrYK3dm38u4hvSykCtaKiRLsGT4pat/KgNcu+rhGMYaKEYx5LQcfXQCnTonqlH0FIddBvmZfvU99To0XG89laSc63RohpGH6vu4l/6PIG/C8BI0DqeRn1p+0XAU1Gq7ZYmtHxIOgs1SVKltXmB2t23ZIBbV1XSbeD2a52ibGvYG4dBzXg5qYXEhYuVPlbYsDXzRnCH7clTo2hGVbziEwXbJ19UNyM9qHdX5it8VtpbgUEoVbDzXL30I1tEfMFjm62u4v1/cgNcguWMke0Tu6taS0LNfiYxMT3Vi3Mor6LyfwcrIyLFoc2A87Cv0t0u5V0R1B+r3xkEM4xWe/KmaQLCkDylh3VaI46t8rurNpsaobSkkyyBNoRCKZ2S6H1hnyS4Yh+JFnf8QTS2kd71Q+r6PfWzH7PKfMQRIqC/++w4CURglwbIqxUgO5jCPz6qmTvdq/SojwZfPus2MZt2Cf1ysmDwT+zGLd2GYo+63TKGRye+G99c1H3VFA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(366004)(346002)(376002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(66556008)(41300700001)(7416002)(66946007)(66476007)(316002)(478600001)(4326008)(8676002)(30864003)(5660300002)(8936002)(3450700001)(26005)(31686004)(6486002)(2906002)(6666004)(6506007)(53546011)(83380400001)(6512007)(2616005)(36756003)(31696002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1BiV3NwQldvL3JRS1BZT3puTzE5WThTYXdTYldneGtzOGFjcmZPSGJid1dR?=
 =?utf-8?B?Q3Y4WGVKdW9FYmZKZ09qNUFnM1NFWHpnS1RjYU1xd2sxb3NEQW9jWmdZNVFH?=
 =?utf-8?B?anEwVGZ4ZFZhZzJhY3ZQNzZ5N3czOVBNbGdxVzN0dEErcjN5dXlHSlZaeTgz?=
 =?utf-8?B?TG8yMXBQQTN0VWUrT3ZKZzVSZEhvRFdpSitDcFBEUUdDTXZ0Z053dFdhWGxr?=
 =?utf-8?B?UW5SL1JLMzNCTmhYRC9WdVJQNDVUdDRWODAxNEQ5S3U2SmVHSGxYSFdpMzhi?=
 =?utf-8?B?ZHVuZlpPSWdKVWZzRzlIMVpBeTg1WktMZ00vUkVSamU4bkpzb2xjVWFvMklE?=
 =?utf-8?B?eHVJRXpaejJ3OHJub05MSFlBSXdKMnJPNVFqNjZOTWJQYWh1ZnJiR3ZKNTBX?=
 =?utf-8?B?a0RQYzVKZ0x1b3hMTjBmUmpvOXVTT0hpZ3ZVSDl3ZkhiWGJMeEJneDdzMllV?=
 =?utf-8?B?UHQxWWN5Vk8zOWVQK3BMeDBFb2xYQWdaZ1VtZ1ZGR1RMbllQS0dJd1MrNlA2?=
 =?utf-8?B?UTMwMzNnZHBvWUhKUjNvc3ZhRnF0MElCZDRYc0lhWStyOVozeUdJdno2L0xF?=
 =?utf-8?B?WEswNGc5ZUQ3NGRaM0lzRWN5M01KcE8vSy9IaStrQ0FWelRWWWNDSWlUY1JC?=
 =?utf-8?B?VXBWQ3JZSklBLzFKaEVzREg1dXZMK1c4clJkL3BVbWFaUEpwQmtUaS9iRzNH?=
 =?utf-8?B?QlVmUXJPbzc0VENVUndrYXJISjRrWGNNWjZYVTJqTUprWXk4OCt6eHBjd2dN?=
 =?utf-8?B?dWc2MnZJTU5KSWN2Mmpqay9iSzJhYkxMaTdSRXBPbkprR2NRTmNUZWl6R0hG?=
 =?utf-8?B?dyszSlk0ZlhOQU5SeGRXS2JkZ0lHazFDN0djK3h0Q0V0YlBEOElIb3NGamRQ?=
 =?utf-8?B?NDBaYWxGNmliNjBpcEM3RFEvV2xlTUkvcWtMR0ltWGduQThFV1haVlpqUTJl?=
 =?utf-8?B?WmJuN0JmL0xUckVnK054NWhLeWE0ZkdzWEFITkh4emFWNFJLRDBuNDZMRW9Q?=
 =?utf-8?B?UUNha1ZTaW50OEJJV0hGZW1IN3B1M2FOQXVKcmcwUkNTcHVyeDFoOTdOYkpM?=
 =?utf-8?B?NnRtcWVOeUJKYkdaRzAxTXY1LzlKMmpmUkxrWUhmUGJjUVQwL0VqSmlOTVdz?=
 =?utf-8?B?bVZlR1hpVjF6dkJwSk5IL0tWWXloMTV5R3VESk1oYTJMRHJjVXdLSkExSHla?=
 =?utf-8?B?bEI1Z1FhT1poczljQnlOb3BDWmk3VHlTQzZrdWwxRGlzOXBOcTJBU3RmS2N4?=
 =?utf-8?B?STVFang3cHQ3eFRGSVZUcXEwUC84U3J5UEdlcVlQb1RkZ1g3Wk50a3g3Y3lP?=
 =?utf-8?B?cUJuRHN1djhyREdBNmRUeUU0T1F4V2JaL296THcxYUJFQXM5VjVteldYdGhR?=
 =?utf-8?B?UEJubjF6LzE3R284NExyOTNvQUZLNDlLdGU5RGtmZzY3ZmlvOVcwdksyRmVh?=
 =?utf-8?B?OXpkZ2hPb1pHTU8rUjhJWFlkYjZBRXZtRWNSS3cvU3NhUE9HOVhrWjQxMFQ4?=
 =?utf-8?B?b0hON0FvYkhGYXJhNkRERjVUSEhaRmpyV2pzekNYZzBiV3FZQjlHcjM3RUs3?=
 =?utf-8?B?aXBUcWE0UVFmVW91VjBkVnRxcHRDTDduTEhMcktxZTVMZG9CQ2k1Si9UMGZm?=
 =?utf-8?B?QzZPaXBZcmsrYzhpc3VKcW9yREFaY01HVno1bDUyeStKR2QzM0ROY2tBYU5K?=
 =?utf-8?B?OER0bDlTYnZNRkdjSE91VHVsRUs2ZkkyZThXZVhrNlBiOUJKZVA4eGNVVXVC?=
 =?utf-8?B?Z2RnVTRlQ3VhYnNXckpjejVsVHB5dFF4K1JqU3E5RURJc3ZOSnBIWTg4K0px?=
 =?utf-8?B?UTJFWXRMR2huVGdhSlpJS0Z0bnV2c3lnRnlzQUYrNmxyR1hJMFhjangzSmJQ?=
 =?utf-8?B?ZnhNTmJBMXBLQVM2eGxYNVVsU0t2K2lBeEVvQXFmdUZxWGVCdlJGTzQ1TStC?=
 =?utf-8?B?Q2o5QnI2YkYweFFWNTZiakFYTndmOCtnMTJ3Q0FkN01qaFRDcmpYRnZFWmh4?=
 =?utf-8?B?UHFaQmNEODBnWFlFVmpyNXJzNmNnVmpLbHVoTEZia0NlejM4cjdJTC82ODd2?=
 =?utf-8?B?NXEwb2hzT1ZwTGVVWU5uYnBvUzBYdG9KVlduM2VPa3JzSEZrYkZPdk1ENkRk?=
 =?utf-8?Q?y7gfpmstSVsaOKq3dDYEEX9B5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dcfc6a3-0876-4b1f-f336-08dbdb5c3546
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 04:28:48.1914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XEwLb4AgUEpOuexML4KDXbhXDzh3Q6cwSI6HUNmlfHmrt9EGB6THjsZyHlI7J+0pAYfu1l4izuqDVkqdwaQTcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4093

On 10/31/2023 12:46 AM, Tom Lendacky wrote:
> On 10/30/23 01:36, Nikunj A Dadhania wrote:
>> For enabling Secure TSC, SEV-SNP guests need to communicate with the
>> AMD Security Processor early during boot. Many of the required
>> functions are implemented in the sev-guest driver and therefore not
>> available at early boot. Move the required functions and provide an
>> API to the driver to assign key and send guest request.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---

>> @@ -72,6 +111,47 @@ struct snp_guest_req {
>>       u8 msg_type;
>>   };
>>   -int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
>> -                struct snp_guest_request_ioctl *rio);
>> +int snp_setup_psp_messaging(struct snp_guest_dev *snp_dev);
>> +int snp_send_guest_request(struct snp_guest_dev *dev, struct snp_guest_req *req,
>> +               struct snp_guest_request_ioctl *rio);
>> +bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id);
>> +bool snp_is_vmpck_empty(unsigned int vmpck_id);
>> +
>> +static void free_shared_pages(void *buf, size_t sz)
> 
> These should probably be marked __inline if you're going to define them in a header file.

Sure, I will udpate both free_shared_pages() and alloc_shared_pages().

> 
>> +{
>> +    unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
>> +    int ret;
>> +
>> +    if (!buf)
>> +        return;
>> +
>> +    ret = set_memory_encrypted((unsigned long)buf, npages);
>> +    if (ret) {
>> +        WARN_ONCE(ret, "failed to restore encryption mask (leak it)\n");
>> +        return;
>> +    }
>> +
>> +    __free_pages(virt_to_page(buf), get_order(sz));
>> +}
>> +
>> +static void *alloc_shared_pages(size_t sz)
>> +{
>> +    unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
>> +    struct page *page;
>> +    int ret;
>> +
>> +    page = alloc_pages(GFP_KERNEL_ACCOUNT, get_order(sz));
>> +    if (!page)
>> +        return NULL;
>> +
>> +    ret = set_memory_decrypted((unsigned long)page_address(page), npages);
>> +    if (ret) {
>> +        pr_err("%s: failed to mark page shared, ret=%d\n", __func__, ret);
>> +        __free_pages(page, get_order(sz));
>> +        return NULL;
>> +    }
>> +
>> +    return page_address(page);
>> +}
>> +
>>   #endif /* __VIRT_SEVGUEST_H__ */
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index 78465a8c7dc6..783150458864 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -93,16 +93,6 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>>     #define RMPADJUST_VMSA_PAGE_BIT        BIT(16)
>>   -/* SNP Guest message request */
>> -struct snp_req_data {
>> -    unsigned long req_gpa;
>> -    unsigned long resp_gpa;
>> -};
>> -
>> -struct sev_guest_platform_data {
>> -    u64 secrets_gpa;
>> -};
>> -
>>   /*
>>    * The secrets page contains 96-bytes of reserved field that can be used by
>>    * the guest OS. The guest OS uses the area to save the message sequence
>> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
>> index fd3b822fa9e7..fb3b1feb1b84 100644
>> --- a/arch/x86/kernel/sev.c
>> +++ b/arch/x86/kernel/sev.c
>> @@ -24,6 +24,7 @@
>>   #include <linux/io.h>
>>   #include <linux/psp-sev.h>
>>   #include <uapi/linux/sev-guest.h>
>> +#include <crypto/gcm.h>
>>     #include <asm/cpu_entry_area.h>
>>   #include <asm/stacktrace.h>
>> @@ -941,6 +942,457 @@ static void snp_cleanup_vmsa(struct sev_es_save_area *vmsa)
>>           free_page((unsigned long)vmsa);
>>   }
>>   +static struct sev_guest_platform_data *platform_data;
>> +
>> +static inline u8 *snp_get_vmpck(unsigned int vmpck_id)
>> +{
>> +    if (!platform_data)
>> +        return NULL;
>> +
>> +    return platform_data->layout->vmpck0 + vmpck_id * VMPCK_KEY_LEN;
>> +}
>> +
>> +static inline u32 *snp_get_os_area_msg_seqno(unsigned int vmpck_id)
>> +{
>> +    if (!platform_data)
>> +        return NULL;
>> +
>> +    return &platform_data->layout->os_area.msg_seqno_0 + vmpck_id;
>> +}
>> +
>> +bool snp_is_vmpck_empty(unsigned int vmpck_id)
>> +{
>> +    char zero_key[VMPCK_KEY_LEN] = {0};
>> +    u8 *key = snp_get_vmpck(vmpck_id);
>> +
>> +    if (key)
>> +        return !memcmp(key, zero_key, VMPCK_KEY_LEN);
>> +
>> +    return true;
>> +}
>> +EXPORT_SYMBOL_GPL(snp_is_vmpck_empty);
>> +
>> +/*
>> + * If an error is received from the host or AMD Secure Processor (ASP) there
>> + * are two options. Either retry the exact same encrypted request or discontinue
>> + * using the VMPCK.
>> + *
>> + * This is because in the current encryption scheme GHCB v2 uses AES-GCM to
>> + * encrypt the requests. The IV for this scheme is the sequence number. GCM
>> + * cannot tolerate IV reuse.
>> + *
>> + * The ASP FW v1.51 only increments the sequence numbers on a successful
>> + * guest<->ASP back and forth and only accepts messages at its exact sequence
>> + * number.
>> + *
>> + * So if the sequence number were to be reused the encryption scheme is
>> + * vulnerable. If the sequence number were incremented for a fresh IV the ASP
>> + * will reject the request.
>> + */
>> +static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
>> +{
>> +    u8 *key = snp_get_vmpck(snp_dev->vmpck_id);
>> +
>> +    pr_alert("Disabling vmpck_id %d to prevent IV reuse.\n", snp_dev->vmpck_id);
>> +    memzero_explicit(key, VMPCK_KEY_LEN);
>> +}
>> +
>> +static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
>> +{
>> +    u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev->vmpck_id);
>> +    u64 count;
>> +
>> +    if (!os_area_msg_seqno) {
>> +        pr_err("SNP unable to get message sequence counter\n");
>> +        return 0;
>> +    }
>> +
>> +    lockdep_assert_held(&snp_dev->cmd_mutex);
>> +
>> +    /* Read the current message sequence counter from secrets pages */
>> +    count = *os_area_msg_seqno;
>> +
>> +    return count + 1;
>> +}
>> +
>> +/* Return a non-zero on success */
>> +static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
>> +{
>> +    u64 count = __snp_get_msg_seqno(snp_dev);
>> +
>> +    /*
>> +     * The message sequence counter for the SNP guest request is a  64-bit
>> +     * value but the version 2 of GHCB specification defines a 32-bit storage
>> +     * for it. If the counter exceeds the 32-bit value then return zero.
>> +     * The caller should check the return value, but if the caller happens to
>> +     * not check the value and use it, then the firmware treats zero as an
>> +     * invalid number and will fail the  message request.
>> +     */
>> +    if (count >= UINT_MAX) {
>> +        pr_err("SNP request message sequence counter overflow\n");
>> +        return 0;
>> +    }
>> +
>> +    return count;
>> +}
>> +
>> +static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
>> +{
>> +    u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev->vmpck_id);
>> +
>> +    if (!os_area_msg_seqno) {
>> +        pr_err("SNP unable to get message sequence counter\n");
>> +        return;
>> +    }
> 
> I probably missed this in the other patch or even when the driver was first created, but shouldn't we have a lockdep_assert_held() here, too, before updating the count?

As per the current code flow, snp_get_msg_seqno() is always called before snp_inc_msg_seqno(), maybe because of that the check wasnt there. It still makes sense to have a lockdep_assert_held() in snp_inc_msg_seqno().

Should I add this change as a separate fix ? 

> 
>> +
>> +    /*
>> +     * The counter is also incremented by the PSP, so increment it by 2
>> +     * and save in secrets page.
>> +     */
>> +    *os_area_msg_seqno += 2;
>> +}
>> +
>> +static struct aesgcm_ctx *snp_init_crypto(unsigned int vmpck_id)
>> +{
>> +    struct aesgcm_ctx *ctx;
>> +    u8 *key;
>> +
>> +    if (snp_is_vmpck_empty(vmpck_id)) {
>> +        pr_err("SNP: vmpck id %d is null\n", vmpck_id);
>> +        return NULL;
>> +    }
>> +
>> +    ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
>> +    if (!ctx)
>> +        return NULL;
>> +
>> +    key = snp_get_vmpck(vmpck_id);
>> +    if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
>> +        pr_err("SNP: crypto init failed\n");
>> +        kfree(ctx);
>> +        return NULL;
>> +    }
>> +
>> +    return ctx;
>> +}
>> +
>> +int snp_setup_psp_messaging(struct snp_guest_dev *snp_dev)
>> +{
>> +    struct sev_guest_platform_data *pdata;
>> +    int ret;
>> +
>> +    if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {
>> +        pr_err("SNP not supported\n");
>> +        return 0;
>> +    }
>> +
>> +    if (platform_data) {
>> +        pr_debug("SNP platform data already initialized.\n");
>> +        goto create_ctx;
>> +    }
>> +
>> +    if (!secrets_pa) {
>> +        pr_err("SNP no secrets page\n");
> 
> Maybe "SNP secrets page not found\n" ?
> 
>> +        return -ENODEV;
>> +    }
>> +
>> +    pdata = kzalloc(sizeof(struct sev_guest_platform_data), GFP_KERNEL);
>> +    if (!pdata) {
>> +        pr_err("SNP alloc failed\n");
> 
> Maybe "Allocation of SNP guest platform data failed\n" ?
> 
>> +        return -ENOMEM;
>> +    }
>> +
>> +    pdata->layout = (__force void *)ioremap_encrypted(secrets_pa, PAGE_SIZE);
>> +    if (!pdata->layout) {
>> +        pr_err("Unable to locate AP jump table address: failed to map the SNP secrets page.\n");
> 
> Maybe "Failed to map SNP secrets page\n" ? Not sure where the AP jump table came in on this...
> 
>> +        goto e_free_pdata;
>> +    }
>> +
>> +    ret = -ENOMEM;
>> +    /* Allocate the shared page used for the request and response message. */
>> +    pdata->request = alloc_shared_pages(sizeof(struct snp_guest_msg));
>> +    if (!pdata->request)
>> +        goto e_unmap;
>> +
>> +    pdata->response = alloc_shared_pages(sizeof(struct snp_guest_msg));
>> +    if (!pdata->response)
>> +        goto e_free_request;
>> +
>> +    /* initial the input address for guest request */
>> +    pdata->input.req_gpa = __pa(pdata->request);
>> +    pdata->input.resp_gpa = __pa(pdata->response);
>> +    platform_data = pdata;
>> +
>> +create_ctx:
>> +    ret = -EIO;
>> +    snp_dev->ctx = snp_init_crypto(snp_dev->vmpck_id);
>> +    if (!snp_dev->ctx) {
>> +        pr_err("SNP init crypto failed\n");
> 
> Maybe "SNP crypto context initialization failed\n" ?
> 
>> +        platform_data = NULL;
>> +        goto e_free_response;
>> +    }
>> +
>> +    snp_dev->pdata = platform_data;
> 
> Add a blank line here.
> 
>> +    return 0;
>> +
>> +e_free_response:
>> +    free_shared_pages(pdata->response, sizeof(struct snp_guest_msg));
>> +e_free_request:
>> +    free_shared_pages(pdata->request, sizeof(struct snp_guest_msg));
>> +e_unmap:
>> +    iounmap(pdata->layout);
>> +e_free_pdata:
>> +    kfree(pdata);
>> +
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(snp_setup_psp_messaging);
>> +
>> +static int __enc_payload(struct aesgcm_ctx *ctx, struct snp_guest_msg *msg,
>> +             void *plaintext, size_t len)
>> +{
>> +    struct snp_guest_msg_hdr *hdr = &msg->hdr;
>> +    u8 iv[GCM_AES_IV_SIZE] = {};
>> +
>> +    if (WARN_ON((hdr->msg_sz + ctx->authsize) > sizeof(msg->payload)))
>> +        return -EBADMSG;
>> +
>> +    memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
>> +    aesgcm_encrypt(ctx, msg->payload, plaintext, len, &hdr->algo, AAD_LEN,
>> +               iv, hdr->authtag);
>> +    return 0;
>> +}
>> +
>> +static int dec_payload(struct aesgcm_ctx *ctx, struct snp_guest_msg *msg,
>> +               void *plaintext, size_t len)
>> +{
>> +    struct snp_guest_msg_hdr *hdr = &msg->hdr;
>> +    u8 iv[GCM_AES_IV_SIZE] = {};
>> +
>> +    memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
>> +    if (aesgcm_decrypt(ctx, plaintext, msg->payload, len, &hdr->algo,
>> +               AAD_LEN, iv, hdr->authtag))
>> +        return 0;
>> +    else
>> +        return -EBADMSG;
>> +}
>> +
>> +static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *guest_req,
>> +                  struct sev_guest_platform_data *pdata)
>> +{
>> +    struct snp_guest_msg *resp = &snp_dev->secret_response;
>> +    struct snp_guest_msg *req = &snp_dev->secret_request;
>> +    struct snp_guest_msg_hdr *req_hdr = &req->hdr;
>> +    struct snp_guest_msg_hdr *resp_hdr = &resp->hdr;
>> +    struct aesgcm_ctx *ctx = snp_dev->ctx;
>> +
>> +    pr_debug("response [seqno %lld type %d version %d sz %d]\n",
>> +         resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version,
>> +         resp_hdr->msg_sz);
>> +
>> +    /* Copy response from shared memory to encrypted memory. */
>> +    memcpy(resp, pdata->response, sizeof(*resp));
>> +
>> +    /* Verify that the sequence counter is incremented by 1 */
>> +    if (unlikely(resp_hdr->msg_seqno != (req_hdr->msg_seqno + 1)))
>> +        return -EBADMSG;
>> +
>> +    /* Verify response message type and version number. */
>> +    if (resp_hdr->msg_type != (req_hdr->msg_type + 1) ||
>> +        resp_hdr->msg_version != req_hdr->msg_version)
>> +        return -EBADMSG;
>> +
>> +    /*
>> +     * If the message size is greater than our buffer length then return
>> +     * an error.
>> +     */
>> +    if (unlikely((resp_hdr->msg_sz + ctx->authsize) > guest_req->resp_sz))
>> +        return -EBADMSG;
>> +
>> +    return dec_payload(ctx, resp, guest_req->resp_buf, resp_hdr->msg_sz);
>> +}
>> +
>> +static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
>> +{
>> +    struct snp_guest_msg *msg = &snp_dev->secret_request;
>> +    struct snp_guest_msg_hdr *hdr = &msg->hdr;
>> +
>> +    memset(msg, 0, sizeof(*msg));
>> +
>> +    hdr->algo = SNP_AEAD_AES_256_GCM;
>> +    hdr->hdr_version = MSG_HDR_VER;
>> +    hdr->hdr_sz = sizeof(*hdr);
>> +    hdr->msg_type = req->msg_type;
>> +    hdr->msg_version = req->msg_version;
>> +    hdr->msg_seqno = seqno;
>> +    hdr->msg_vmpck = req->vmpck_id;
>> +    hdr->msg_sz = req->req_sz;
>> +
>> +    /* Verify the sequence number is non-zero */
>> +    if (!hdr->msg_seqno)
>> +        return -ENOSR;
>> +
>> +    pr_debug("request [seqno %lld type %d version %d sz %d]\n",
>> +         hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
>> +
>> +    return __enc_payload(snp_dev->ctx, msg, req->req_buf, req->req_sz);
>> +}
>> +
>> +static int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
>> +                   struct snp_guest_request_ioctl *rio);
> 
> Could all of these routines been moved down closer to the bottom of the file to avoid this forward declaration?

Looks possible, I will try it out.

> 
>> +
>> +static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
>> +                  struct snp_guest_request_ioctl *rio,
>> +                  struct sev_guest_platform_data *pdata)
>> +{
>> +    unsigned long req_start = jiffies;
>> +    unsigned int override_npages = 0;
>> +    u64 override_err = 0;
>> +    int rc;
>> +
> 
> ...
> 
>>   -e_free_ctx:
>> -    kfree(snp_dev->ctx);
>>   e_free_cert_data:
>>       free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
>> -e_free_response:
>> -    free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
>> -e_free_request:
>> -    free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
>> -e_unmap:
>> -    iounmap(mapping);
>> + e_free_ctx:
>> +    kfree(snp_dev->ctx);
>> +e_free_snpdev:
>> +    kfree(snp_dev);
>>       return ret;
>>   }
>>   @@ -780,11 +332,9 @@ static int __exit sev_guest_remove(struct platform_device *pdev)
>>   {
>>       struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
>>   -    free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
> 
> Looks like this one should still be here, right?

Yes, this should still be there.

> 
> Thanks,
> Tom

Regards
Nikunj


