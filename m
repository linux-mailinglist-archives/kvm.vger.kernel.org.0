Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18046516B4
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 00:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiLSXZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 18:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLSXY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 18:24:59 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F045FEB;
        Mon, 19 Dec 2022 15:24:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XVZMkrIRzjmq2ixJ1f8sWEt+qnpjMInH2+pbDmljEMA4QqGJHfrbPsKU6cUbvi7lcroT78uyARf5bUGOOAznPL/RghIpaMvezO8fc7mmW51NPxezyYuTkOY6odH+psGAU5VeLQoB7ial7GEwMiKuORZiUy2PAwUycESiW+hift31N7oWk+0efjF59ZyMJmBYayABeDxPqId2y/FfNMXtCtQd0rmWbmJTi04HppESAuEqTIb+lMm+SRDrm4ElofImyGAi2RzaVwhWvUdUmzW2iU5Tis85m88Hfx692IX/oPmgObjIix8rvsBjUfGKlw+s6nUNqitrjszyKF13gcLLBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xF4pPWMg6+mhB36G5lfP2B0T/BhiaYfOroBigSiOgAs=;
 b=ZlZGVvU+ERfULeVYhjGiLraxbk0mh6bTSsUeBB/7F1ZYUqR2dCy99QohjUkq8mJOxTJ1S4aj2Q5vwoXzv9SFXx2xUm2uuTbvFUBOSc4sn3GZruKG8+1t5cm0/sPvlsRSgS26BUNXY/JvdMrrIlJpb3eXUmuTT0p6tIGzU/VAX6g9EJne/uUAx5hcuUrYNG9j4t/r9saYOAWwDrqIEYrV7OWtH29u/nr6J2EDeZFGTLH7Sm4s4vvK28be1JHagHfKJaxCEofRV/GEz3abZ/XsZ4BaR+bGIYwLyGyPzPc+GfN3GLatA0D5Uneypp59ms/7XM274h95Umo0IcdPNii6xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xF4pPWMg6+mhB36G5lfP2B0T/BhiaYfOroBigSiOgAs=;
 b=k7DXMeLT2I9gZVd9a4hopKhHdeCrJPBlYcyJtAskDln89//WWHgaZzVnomDTLHfN54DLEfkpEvPLWv3BxiZ3iRB9K/A3762A59xrXNoA68+ZBlmae1+i4rHGnXw+xjcgvdQYnSRvdYLvsZSPpZKdI1BKLslU1FNqED9sX9Qo4dM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM6PR12MB4580.namprd12.prod.outlook.com (2603:10b6:5:2a8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 23:24:55 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 23:24:54 +0000
Message-ID: <5e27ed72-2cb0-0bdd-3234-58ff75cf7d44@amd.com>
Date:   Mon, 19 Dec 2022 17:24:47 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 40/64] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH
 command
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-41-michael.roth@amd.com>
 <272cf383-f97f-805c-fd70-1ec14e756523@amd.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <272cf383-f97f-805c-fd70-1ec14e756523@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR11CA0016.namprd11.prod.outlook.com
 (2603:10b6:208:23b::21) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM6PR12MB4580:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a8771b6-5519-4758-7bab-08dae2183c66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vRVKoLv7GhKtDqx7O3NgSOCu8oymBb2bJc880l4iD7/2vojfNi0AzyDnvYKsRxPBpwORmOR5aSSyup/ruqWvXxvwbvk5M8Jk8iCSS+R4zpwLiMGh6YfMkqB4MnVZTC8HeKHkNzciwH1c1uTHtf6/LURqav8WKBb2O7daUbHvvNF1Kn7LZO9gmx8FWk75zgO6et77AXrDS8isjRNS3uURds/PMHd3dgVTLRIO/dpnur3YDA3OcAcC7DiXZi7ohA37j28CSSR3v19yhW02H25pljHSY+01P2RtRJ71gqX9UljHVPdF7B4JF/hqYW+a8EBwxIT+gtSDzaA69FEr8DBvJuh9eap58qe6M4drOczQxIkZEqJH7s9rORTn5D0/1eQa3sGwRiaUXiG9QI0y6mT8jJnZ2+QseV1qjd1GvrUeb5QAI0pYYMdX7oW86a3suFxQNTozzcAyBMJ88s80MooPFMARLkgpUdujgK3xaXd0E982lc5HqdhgwFYchmXWVVkTETyMm62FZKP4TY9eaIqd+cbmg3D4hmlorq2/odK8FswiDcXfNtXOi/LLFT2Oaa8o7ibzcLbS+SiAT9CycCdy1ModjKLiWcqCTGNZ/5albaHvT0cS1HEMXj8uOcl61bSklBoYXw8vo3ul8vFpqmRVEU+XxlS1eJaLaFZMZnjTY/N/aIfnnelykgjvuMbHY0bP/AaHfK/H5ZInwB7ysXFaEKRVf/FFQc0UGYtD3UyEDT8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(451199015)(83380400001)(8676002)(66946007)(66556008)(31696002)(478600001)(7406005)(7416002)(66476007)(4326008)(86362001)(5660300002)(2906002)(8936002)(41300700001)(26005)(6512007)(186003)(6506007)(53546011)(2616005)(6666004)(110136005)(316002)(6486002)(38100700002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlZldmxqVDZGVXJiQWlGbGlSTGlBcWM2VlUyMDV2cCtWam9jVkNLMGZTV3ZL?=
 =?utf-8?B?eGdNTDc5TzNMUW0yTnp0RnVaZzRqRG9nbHhqYkU4V2FPNHl2dVNBR0xobkMv?=
 =?utf-8?B?a0NDM09veGpMSTFORkdiRGh6cWYrT1VBTEt1a0MxZU1OREg0eW9EZi93NHZQ?=
 =?utf-8?B?UmZnMldpZkhESGsrMVBQaHFLQjZNWEd3ZEQyWCtiSnVzd0Q2Y3JBV2FIUHNB?=
 =?utf-8?B?Nkt5WitJWmtCZmh2eDRqNm5qRXJocXEvL0ZwOXZvT3J2czd1VnY3dDhvVkNF?=
 =?utf-8?B?Nll4UzMvS2FYYzhtSE5kWE80WVBJNTVDOVQvaFRDWkNmTlhJSGdVeWgzcnQ0?=
 =?utf-8?B?dnFndmFsbDFjOW1OUld0enJUU1VkQWtJNnMzQVlwY3BmQUJzMVNyUVk0ZFAy?=
 =?utf-8?B?bmtLWlhNeUViR1RjU2dibTk2bDFoV1Byc1R5bDNvNUEzeGl1aDN3bXBYWWt6?=
 =?utf-8?B?SWdXZEk1MVEwNGV6RzEvME83eThBRFU3ckNkTmcwN0x4bVMzTGhKMWh4bFFj?=
 =?utf-8?B?aUxycG0xRk1sUmdmWDVtNHlPeUNveVl4RmE1T3BnaTlqQ1ZsV01abGZ0K2N1?=
 =?utf-8?B?Tm5xRURCek82Wm02MDZJR0lTK3ozbHdid0lzcVNVMTYyV2pkakVDa3dkZkM2?=
 =?utf-8?B?YzBMWUZ3T1h0a1R1em9DVXBqSHBlT2ZjQ003a2pUV1N6WVlKdmRQSUhjM1JD?=
 =?utf-8?B?bnpyMUw5Q2o5cVdSYVcvUlNBelhiZW01T3VGdmo4VTIzUnlYZXFIV1FnM29a?=
 =?utf-8?B?K053dWV2Y2Z4VUdTRFczeER3VEduSzNISDU0dTBHQ3pvWk9QTW9mNDJvT3BP?=
 =?utf-8?B?YVk2K1J3YjRwdFhSeG1QazcrS2ozTnQyNXJnSGFzcHJPMjNwOEtjSk0xaXdO?=
 =?utf-8?B?cmtrek5TRmRSb0ptLzlzeDk5RHNMbm5maVhpdzFCbmZoc21iQlhBbFladDhK?=
 =?utf-8?B?SThXOGRMVUlkZzR2UnJmYklucEpoc2xHdktyWmJPdE1CK3JVd1lROStCd1Jl?=
 =?utf-8?B?WjdCWGVpNG9JdzFmekVuTlpNZUloeUZTNFZkaVRIWDFVdWhZa05ocCtyZ1Rx?=
 =?utf-8?B?RG1Ud0VNSU5Ia2NiN2syNU0xbmF6dE1HK2VtcTFoRXhxeEtseC9lUEYxMXFC?=
 =?utf-8?B?SG9kaURaK0pjS21iM2ZnWkJWV1kzSkVZdlNscjBlUWp5ZUoyd2poUXR4dHBi?=
 =?utf-8?B?VTRCYVZXWDBJUTc4Sk4yMVhnK3FDQTBlbVBOV0dYMzA5TXhvSms5Nk95MENM?=
 =?utf-8?B?VEpmZFJvQTRJOTZ2T0J2dEZ4MVJvOW5aQTI1Z0xiUnFyVEkyV3NZMTRVWk1B?=
 =?utf-8?B?eDU5N1gzTE1iOGIzTjZuWGZ0NFJuYzc3RnR5NC9KVEdqRk9JYmNZMHNaMkl4?=
 =?utf-8?B?WG1Pdlh4NDhacXRaanNVeGkvR0dueFZ1aEppdmk2MDk2K1VMN0dGQzIzL2Mx?=
 =?utf-8?B?RWpKUS90TE9QVWVhNzdPMHZBQ2NBb0QySGlRYzdITG0rOW5QSU8vUnVlMmpV?=
 =?utf-8?B?OEZiWDBsRkVVaWRTbGJ0VUplSjlsS3ZycVU5bzBINk9UNDVMdTV4dEdHUTRB?=
 =?utf-8?B?dkd4Z3J4clFUNWkySnBqcWlTQmFUQUFCOUI3YTN6UW5USlgweERjSkV3Q01B?=
 =?utf-8?B?d3dHaTZuSE84aGNJZGRjejNnQWN3Rk40ZUpOTFlNcWQwbWRrUlYrckpyWmZJ?=
 =?utf-8?B?eHNKQXNxZ0M2OGUweTF6NERVU25DR3JlKzFVWmxBelpHR1QxWDZPd1IxSzFH?=
 =?utf-8?B?c3NXd2ZGTEVkQXo5MStBWkZlNkx0T1grM25kRkN5NkQ1Mk1rWC8xTjVzQmtJ?=
 =?utf-8?B?eWVzaTgrUGRzUUFhOUF4SmhTUndZTDZHWktOVUdZYlBUWG1XZzl1ak5yZTY5?=
 =?utf-8?B?a2pzdUVoUXBVeTVKcUpNM2dka08relJOY2huam1SVUFmSGJiL25odXBhaFNR?=
 =?utf-8?B?VFdPdFM5R1BNRmZna0Ztak1wZXZrREpEQ3RoWnlNM2xUcU54Y3U1YUFEeUhO?=
 =?utf-8?B?TFg4TmNvWUVWRTViTW5Zbk9GYmh0WjR5QXY1bVdNMUw2R3pVN3N2dG9iSktH?=
 =?utf-8?B?TnJlWEhsazlDZTNTMlgwR3RGenRqQ1pwcVF6OTVReU9YMDZTbHllZEtkL1Bq?=
 =?utf-8?Q?lKOmAnhpnrR5jmLqlZyIRxNfO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a8771b6-5519-4758-7bab-08dae2183c66
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 23:24:54.8506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AdwWNArA2EYrYnzhEP0Hc+9G169BPt4ZzeRXBEOQCPiyjrGonDk561lMa0v5BPIDT8dycMZ9RDUdq1L+7xQl/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4580
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Tom,

On 12/19/2022 12:04 PM, Tom Lendacky wrote:
> On 12/14/22 13:40, Michael Roth wrote:
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> The KVM_SEV_SNP_LAUNCH_FINISH finalize the cryptographic digest and 
>> stores
>> it as the measurement of the guest at launch.
>>
>> While finalizing the launch flow, it also issues the LAUNCH_UPDATE 
>> command
>> to encrypt the VMSA pages.
>>
>> If its an SNP guest, then VMSA was added in the RMP entry as
>> a guest owned page and also removed from the kernel direct map
>> so flush it later after it is transitioned back to hypervisor
>> state and restored in the direct map.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Signed-off-by: Harald Hoyer <harald@profian.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   .../virt/kvm/x86/amd-memory-encryption.rst    |  22 ++++
>>   arch/x86/kvm/svm/sev.c                        | 119 ++++++++++++++++++
>>   include/uapi/linux/kvm.h                      |  14 +++
>>   3 files changed, 155 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst 
>> b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
>> index c94be8e6d657..e4b42aaab1de 100644
>> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
>> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
>> @@ -513,6 +513,28 @@ Returns: 0 on success, -negative on error
>>   See the SEV-SNP spec for further details on how to build the VMPL 
>> permission
>>   mask and page type.
>> +21. KVM_SNP_LAUNCH_FINISH
>> +-------------------------
>> +
>> +After completion of the SNP guest launch flow, the 
>> KVM_SNP_LAUNCH_FINISH command can be
>> +issued to make the guest ready for the execution.
>> +
>> +Parameters (in): struct kvm_sev_snp_launch_finish
>> +
>> +Returns: 0 on success, -negative on error
>> +
>> +::
>> +
>> +        struct kvm_sev_snp_launch_finish {
>> +                __u64 id_block_uaddr;
>> +                __u64 id_auth_uaddr;
>> +                __u8 id_block_en;
>> +                __u8 auth_key_en;
>> +                __u8 host_data[32];
> 
> This is missing the 6 bytes of padding at the end of the struct.
> 

Yes will fix this, the documentation is missing that, the structure 
defination in include/uapi/linux/kvm.h includes it.

But why do we need this padding ?

>> +        };
>> +
>> +
>> +See SEV-SNP specification for further details on launch finish input 
>> parameters.
>>   References
>>   ==========
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 379e61a9226a..6f901545bed9 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2243,6 +2243,106 @@ static int snp_launch_update(struct kvm *kvm, 
>> struct kvm_sev_cmd *argp)
>>                         snp_launch_update_gfn_handler, argp);
>>   }
>> +static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd 
>> *argp)
>> +{
>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +    struct sev_data_snp_launch_update data = {};
>> +    int i, ret;
>> +
>> +    data.gctx_paddr = __psp_pa(sev->snp_context);
>> +    data.page_type = SNP_PAGE_TYPE_VMSA;
>> +
>> +    for (i = 0; i < kvm->created_vcpus; i++) {
>> +        struct vcpu_svm *svm = to_svm(xa_load(&kvm->vcpu_array, i));
>> +        u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
>> +
>> +        /* Perform some pre-encryption checks against the VMSA */
>> +        ret = sev_es_sync_vmsa(svm);
>> +        if (ret)
>> +            return ret;
>> +
>> +        /* Transition the VMSA page to a firmware state. */
>> +        ret = rmp_make_private(pfn, -1, PG_LEVEL_4K, sev->asid, true);
>> +        if (ret)
>> +            return ret;
>> +
>> +        /* Issue the SNP command to encrypt the VMSA */
>> +        data.address = __sme_pa(svm->sev_es.vmsa);
>> +        ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
>> +                      &data, &argp->error);
>> +        if (ret) {
>> +            snp_page_reclaim(pfn);
>> +            return ret;
>> +        }
>> +
>> +        svm->vcpu.arch.guest_state_protected = true;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>> +{
>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +    struct kvm_sev_snp_launch_finish params;
>> +    struct sev_data_snp_launch_finish *data;
>> +    void *id_block = NULL, *id_auth = NULL;
>> +    int ret;
>> +
>> +    if (!sev_snp_guest(kvm))
>> +        return -ENOTTY;
>> +
>> +    if (!sev->snp_context)
>> +        return -EINVAL;
>> +
>> +    if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, 
>> sizeof(params)))
>> +        return -EFAULT;
>> +
>> +    /* Measure all vCPUs using LAUNCH_UPDATE before finalizing the 
>> launch flow. */
>> +    ret = snp_launch_update_vmsa(kvm, argp);
>> +    if (ret)
>> +        return ret;
>> +
>> +    data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
>> +    if (!data)
>> +        return -ENOMEM;
>> +
>> +    if (params.id_block_en) {
>> +        id_block = psp_copy_user_blob(params.id_block_uaddr, 
>> KVM_SEV_SNP_ID_BLOCK_SIZE);
>> +        if (IS_ERR(id_block)) {
>> +            ret = PTR_ERR(id_block);
>> +            goto e_free;
>> +        }
>> +
>> +        data->id_block_en = 1;
>> +        data->id_block_paddr = __sme_pa(id_block);
>> +
>> +        id_auth = psp_copy_user_blob(params.id_auth_uaddr, 
>> KVM_SEV_SNP_ID_AUTH_SIZE);
>> +        if (IS_ERR(id_auth)) {
>> +            ret = PTR_ERR(id_auth);
>> +            goto e_free_id_block;
>> +        }
>> +
>> +        data->id_auth_paddr = __sme_pa(id_auth);
>> +
>> +        if (params.auth_key_en)
>> +            data->auth_key_en = 1;
>> +    }
>> +
>> +    data->gctx_paddr = __psp_pa(sev->snp_context);
> 
> This is missing the copying of the params.host_data field into the 
> data->host_data field. This is needed so that the host_data shows up in 
> the attestation report.
> 

Yes will fix this.

Thanks,
Ashish

> Thanks,
> Tom
> 
>> +    ret = sev_issue_cmd(kvm, SEV_CMD_SNP_LAUNCH_FINISH, data, 
>> &argp->error);
>> +
>> +    kfree(id_auth);
>> +
>> +e_free_id_block:
>> +    kfree(id_block);
>> +
>> +e_free:
>> +    kfree(data);
>> +
>> +    return ret;
>> +}
>> +
>>   int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>>   {
>>       struct kvm_sev_cmd sev_cmd;
>> @@ -2339,6 +2439,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void 
>> __user *argp)
>>       case KVM_SEV_SNP_LAUNCH_UPDATE:
>>           r = snp_launch_update(kvm, &sev_cmd);
>>           break;
>> +    case KVM_SEV_SNP_LAUNCH_FINISH:
>> +        r = snp_launch_finish(kvm, &sev_cmd);
>> +        break;
>>       default:
>>           r = -EINVAL;
>>           goto out;
>> @@ -2794,11 +2897,27 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
>>       svm = to_svm(vcpu);
>> +    /*
>> +     * If its an SNP guest, then VMSA was added in the RMP entry as
>> +     * a guest owned page. Transition the page to hypervisor state
>> +     * before releasing it back to the system.
>> +     * Also the page is removed from the kernel direct map, so flush it
>> +     * later after it is transitioned back to hypervisor state and
>> +     * restored in the direct map.
>> +     */
>> +    if (sev_snp_guest(vcpu->kvm)) {
>> +        u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
>> +
>> +        if (host_rmp_make_shared(pfn, PG_LEVEL_4K, true))
>> +            goto skip_vmsa_free;
>> +    }
>> +
>>       if (vcpu->arch.guest_state_protected)
>>           sev_flush_encrypted_page(vcpu, svm->sev_es.vmsa);
>>       __free_page(virt_to_page(svm->sev_es.vmsa));
>> +skip_vmsa_free:
>>       if (svm->sev_es.ghcb_sa_free)
>>           kvfree(svm->sev_es.ghcb_sa);
>>   }
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 9b6c95cc62a8..c468adc1f147 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1942,6 +1942,7 @@ enum sev_cmd_id {
>>       KVM_SEV_SNP_INIT,
>>       KVM_SEV_SNP_LAUNCH_START,
>>       KVM_SEV_SNP_LAUNCH_UPDATE,
>> +    KVM_SEV_SNP_LAUNCH_FINISH,
>>       KVM_SEV_NR_MAX,
>>   };
>> @@ -2076,6 +2077,19 @@ struct kvm_sev_snp_launch_update {
>>       __u8 vmpl1_perms;
>>   };
>> +#define KVM_SEV_SNP_ID_BLOCK_SIZE    96
>> +#define KVM_SEV_SNP_ID_AUTH_SIZE    4096
>> +#define KVM_SEV_SNP_FINISH_DATA_SIZE    32
>> +
>> +struct kvm_sev_snp_launch_finish {
>> +    __u64 id_block_uaddr;
>> +    __u64 id_auth_uaddr;
>> +    __u8 id_block_en;
>> +    __u8 auth_key_en;
>> +    __u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
>> +    __u8 pad[6];
>> +};
>> +
>>   #define KVM_DEV_ASSIGN_ENABLE_IOMMU    (1 << 0)
>>   #define KVM_DEV_ASSIGN_PCI_2_3        (1 << 1)
>>   #define KVM_DEV_ASSIGN_MASK_INTX    (1 << 2)
