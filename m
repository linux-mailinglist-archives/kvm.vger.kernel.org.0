Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7937C678B06
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 23:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbjAWWta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 17:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjAWWt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 17:49:29 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1476E193E8;
        Mon, 23 Jan 2023 14:49:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AsyYA0qkuBKrWRoStCWiWkMwBEjmJ6VaAaTYJ5T2VDNjY3ml2C1sygyy64oJRg0D0ECKLy3y6G4QrW8LGf7gpvtQ/LNK2a9w12BsqjqRkg46kzD9my/u4rfYct++lm3Mv4ppNpIw7bo15TnsfGkWOjPsLLPigYnGZwtVGTd2dBGOw7mszdh+iE0Pxi4SnSIPZjsk7Z90fK5cnbsnG0IGIt/R3hooQ5GYbZ6W17Te6FlptnqQ2WsSHBLUwYIKqfeU8HRve/iJ5qQCtNARgZ7gH9OHKymVD92grCaVEQ2c6aLARqxxjgYraS2GerVzV+9Km3jrlVLw7q4yRzlAZbDyxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YpyDt1YTMkFBixMPMa8HQGXG8xXP70L1q6T6SvYosZE=;
 b=kbLGfy6kbeuh4MOnMnG1SKOojyA477gB4jmr80ZbxR2JMn4smmRPDZP3PcpFv0STff/9kEPVtp/YYzgUmKn+xiE03A51MrAaFXg9VOk4AoCDcRbPhpkltNrICvVSkVOG6i2BS7bJWw4K7HTsP4SNf2EL/0v/efqnSf6/duceRbuS9G7xuEzMS1u56qyUT8sRajFtPz/MzdDstL/wz8duBXeKSv8eRPOzyN61glbsPDxMKK3WHxQ5edh6Jbz2C0eXbl5flxMtjcP9W91ECe3Hw6nQiRBZnF5iMYMJtqzVk1XzZog5uc7qy4qIcIvN73WU59UZvq5jlxnMVkx7jRLQmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpyDt1YTMkFBixMPMa8HQGXG8xXP70L1q6T6SvYosZE=;
 b=aFDD3CMK3S8EVQpvkbbkapIM004TKIUphdR7C3L5VKjagm38Wur/aV61EceSgpn0Z0DYaHLS0ULQ+yoQjClhr+DVXbLtR+ryOACcyA1iqKp4r7Llbyz9QEkmr/jhmncD4Gr/0xjDPwO3Cdq/JWs/5yKKgYVjzg8vw6OsIrz2Zrs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SJ0PR12MB6943.namprd12.prod.outlook.com (2603:10b6:a03:44b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 22:49:25 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3%7]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 22:49:20 +0000
Message-ID: <16523f06-bb08-c4f9-bdfa-745fee553a43@amd.com>
Date:   Mon, 23 Jan 2023 16:49:14 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 37/64] KVM: SVM: Add KVM_SNP_INIT command
Content-Language: en-US
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>,
        Pavan Kumar Paluri <papaluri@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-38-michael.roth@amd.com> <Y7BG6pSuoZsBQYrx@kernel.org>
 <fd23ee51-ec47-717d-7cce-1d79db8b6bd3@amd.com>
In-Reply-To: <fd23ee51-ec47-717d-7cce-1d79db8b6bd3@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0131.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::16) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SJ0PR12MB6943:EE_
X-MS-Office365-Filtering-Correlation-Id: 824888ea-864e-410c-2388-08dafd94109f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHCGeqDbNufU7CyGBArc5E1s9bjA/jmPdAkNaO2aakjU6KPxr+W/tzgqVWxd0y1E2giCFMtl+63n+LumyBSlulYmkD9qDz7bdzXvAZP75PpnbZftx//I6BPr0IFMxwSER6WlKN2IqHlHho5+JSr7hPoCgzOUZrH1uhM3Ugt0XKqGDMz+8TMJ26oNof6C+uNNMX/yHFLeK+8HjSLEcRpErjA8VLSoJ8EBBMSzVBMgGkkWromHHuc6i4R1VnpjaH7HuQ+P7BzqTQalE3WLUuiUrZEYq25Jj637CIh7qLZk3tlh/dKLMU4pC3hM+h4A4S5KYEQM9rs+eN+X+6iVXTBROUQMccy3sJWiCu81WOXTtQ30I0YdL97Ii7Qq/QRYeXT1oa7iAkq4wlTJLPwyxFB3pIOLYLTf3LrM9ggVqTZ1V7NmCpcgkRqPqhVhRCTdZudlUQntHhjzqggZkAKN+DNQx+OUvQ9FGdsjuKurwu4VtZPG4S/njlvPNc1sof7FPsqrHz6PnBiH5a7OqFZC5ViGvx7s4P6BCgX53vLkq/NWwAGt3gbmDrdRbLmDxZouxcigXyQm9QSKbGTZNazqx2rAWZnj5szY5v3Z4ZyWfbVburpfkO8rxv5LIbr11kggjcqZlLm4KYT7ngco78MftHkCLGxmFyXMvLHRAx4MCJ0esgDpOySQn0l+mI8p2+Lz1VzZGb5ijPAocbYvW6RW07m7vug6zUY7Mdm6is1rBBjyUNk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(451199015)(8676002)(86362001)(66899015)(66476007)(6636002)(66946007)(54906003)(110136005)(66556008)(36756003)(6512007)(26005)(186003)(53546011)(6506007)(6666004)(83380400001)(4326008)(316002)(6486002)(478600001)(2616005)(31686004)(7416002)(7406005)(5660300002)(8936002)(41300700001)(2906002)(31696002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OElKOFQ4cjhBRnhhMGJ3UGtqUXNnN1BYaE5pSFBQcVBJeXpLbWJGeXVBWmRq?=
 =?utf-8?B?WjUrZDFBU2VkVXBiVGdUdUhiR2lxMUU0UFFPVVJCZlVzcnRMY3dEQkZvRVdl?=
 =?utf-8?B?OEhKbnJsaGtDQ0NMd3BiMW1XeTN0Rk1IOW9WaUpZQzRsb3pKaUg5Y3VUdzho?=
 =?utf-8?B?STJETFgzTnpUcTMxNzVLVXlaQU5QaDVmQzVJRnZNemlPY0xJUnd1STEzK1h0?=
 =?utf-8?B?b2cvV0R5TFJCbFBqdGRVVHZUOVZBWG04bkF5ZjYyUVQ3S1hwd0w4TTBqeWNH?=
 =?utf-8?B?d0sxZGlROVNFTUNFRUhqS2xBZ0VjaWJad04vU00rdnNZcFlGbnVVei95b3Ew?=
 =?utf-8?B?L2pEVkY0VEJUMk0yaXhJbWt1eUI1L2VmbmJ0dmEwVVpWM1NFOFBTb255OU9x?=
 =?utf-8?B?dndLNzF2TTUrbjdDZDZzQlFTSm8yUUdWL1grcmhxRnZQTVlxTHJJeDJiL0x4?=
 =?utf-8?B?ZXhnN20rWXVCcVRZOCt5bG43Z3pXWXhvVlJMQTEwL0tiNExWSkI3U1hzY2gy?=
 =?utf-8?B?cm53VGZxd2k4ZlZERjk2enJEZ3FDaGlCY1doUGJzbDV4V2s3L2xpaVE5aHJp?=
 =?utf-8?B?QXI4S2VjalBzNnFHMWtJYjZWRDZDMDJ1Qk9ZNmNBUVJMRW5wSFNUWFhMMTJp?=
 =?utf-8?B?ckpxMUs0TGZkbStwVjZPcVY3SHlmNEl4L2lreWJadnZIZ3plKy9ZeG0rUk56?=
 =?utf-8?B?STJjcStWZ2xOOWVrQS9VZFE5U0pPaWtMb3VmVUpVUXUwT3JQSEtEei9mRnlX?=
 =?utf-8?B?alhpakJGUzdSUnNKeXgyVGdqZnc4VHRrYUcwYVFuclRMRklic0VPY1RBcmJk?=
 =?utf-8?B?V241VDJYeWE5RjdSVUpSU2hDaDNab2wzNm5qK3hQNTBPQS9sR0RvWmpOTXFz?=
 =?utf-8?B?NlZUWktzRTY3cWRVV1N4YlZpbVJta0VJRnhiMTFObitYaFBXOXg0Q3Q5ZEZo?=
 =?utf-8?B?Y20wVlM1NUpOZ3Evd2hQTGFTOSs2Wk9GL0pSMkQ2M3RtNTJMY1BvVFVQSy9H?=
 =?utf-8?B?RVVmRjlVVHFDaGUzKzRTeTZDMmg4Nk9Jc0dpejR3aWdjUmtsaWJpbFN0RFls?=
 =?utf-8?B?SHlOTzRZRXlPNXRIQ0xnNUs0RHlZeU9ZbWlTOVRtc3M5V213MnJTTy9SenVu?=
 =?utf-8?B?VTZsV3F3Sm9IMWFQYXpzSFNJQWxCZFUwY2xtTUlrZFgyZEtXY2thUGxqQTB4?=
 =?utf-8?B?SUxjOFpXUy9nSDFNZHBITXJmVTIxczg4K2Y2M01TeThLdVlEWnVlR1cvRENG?=
 =?utf-8?B?Y205bEpKb2JObS9SRUlKVzdtdEN6M21qUGlJeXNRSGk5ZkJ5dGl3S3JVSUpZ?=
 =?utf-8?B?aDNSeVJ5aWxhVmtYRjgybVFKQS8wWWhlNG9VUG1zbUVGSEZPcVZTZkpaN1pq?=
 =?utf-8?B?aWZtQTZTSytmWE5EeDNtbCsxejNzK3EzVWRZQm1xYUZ3QjdJblhIaE9SZkI0?=
 =?utf-8?B?UXpVbmExalhZNlcycHNreEZLeTFZcWdjaXpDcVNpalJPOFBwTVlNWmxvL1Bv?=
 =?utf-8?B?Q1FFS3dodEVsSmpKQmpSc0JlMlg4a0VMdmRhM1Y5MVY3V2RrT1hGUjdLVVRt?=
 =?utf-8?B?UFU5cktyaFpQVXV4VFVnNnBuejR1WjRjdXVrTHJNVTUvd0hxNHozRUZTeDdH?=
 =?utf-8?B?Tk5IWS9jNGVXczRWd2lQK1JWTTdWc2t5TEJGRGd1b0Z6WkE2VGx5TEtDNlRL?=
 =?utf-8?B?M0Nwd3Bla0U2TGJRaWZNdlJzVzVCcVZLZVV2OFNyQXFkM3JKZEdEMTRkZFlC?=
 =?utf-8?B?aEswd29SMmlNclNROVdsaTYrd2lrNnhoM1lNbm5DTHNsOC82TVRSZ2pnWmZs?=
 =?utf-8?B?ZkIyTS9SNXA3K3NTamtQbzdHUFo4a2NHR0NtT0l4Mk4wV3lIR21pcGVnZm5K?=
 =?utf-8?B?eEo0NDd2V2Z2b0tFdEl0b0N2eE1MWHo1UktValVnSlF4dlphYTRrWWpLNVFG?=
 =?utf-8?B?aWYvaWF0MlloeWk0S2lQeTdCamhJMzRweEtLZ1U2OEZNSTN4aDNYN0FZdTJU?=
 =?utf-8?B?a0RHbzFzc1c1UHRlTVN0Ylo3RFVod2RKTE1QbHBzTjU4ZkFhazVra2trN3J6?=
 =?utf-8?B?UzVkdmlrMVV4aU1ScXcvTUFldWZCcXJ4T0VGSG1RZkticjdpNVh4RUp4OHcx?=
 =?utf-8?Q?bfT7ts9hhhzaVLVAZhgKWJF0e?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 824888ea-864e-410c-2388-08dafd94109f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:49:20.5948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16trR8wRbpYO2lBNyL7N/2/hJYZmU19tsI4K30JJ/NA3hR7LfMCO/qg+j8rXekIObSF0oWkO+eCJ7qCdlsrgHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6943
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There was an early firmware issue on Genoa which supported only SNP_INIT 
or SEV_INIT, but this issue is resolved now.

Now, the main constraints are that SNP_INIT is always required before 
SEV_INIT in case we want to launch SNP guests. In other words, if only 
SEV_INIT is done on a platform which supports SNP we won't be able to 
launch SNP guests after that.

So once we have RMP table setup (in BIOS) we will always do an SNP_INIT 
and SEV_INIT will be ideally done only (on demand) when an SEV guest is 
launched.

Thanks,
Ashish

On 1/5/2023 5:37 PM, Kalra, Ashish wrote:
> Hello Jarkko,
> 
> On 12/31/2022 8:27 AM, Jarkko Sakkinen wrote:
>> On Wed, Dec 14, 2022 at 01:40:29PM -0600, Michael Roth wrote:
>>>   static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>   {
>>>       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>> @@ -260,13 +279,23 @@ static int sev_guest_init(struct kvm *kvm, 
>>> struct kvm_sev_cmd *argp)
>>>           return ret;
>>>       sev->active = true;
>>> -    sev->es_active = argp->id == KVM_SEV_ES_INIT;
>>> +    sev->es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == 
>>> KVM_SEV_SNP_INIT);
>>> +    sev->snp_active = argp->id == KVM_SEV_SNP_INIT;
>>>       asid = sev_asid_new(sev);
>>>       if (asid < 0)
>>>           goto e_no_asid;
>>>       sev->asid = asid;
>>> -    ret = sev_platform_init(&argp->error);
>>> +    if (sev->snp_active) {
>>> +        ret = verify_snp_init_flags(kvm, argp);
>>> +        if (ret)
>>> +            goto e_free;
>>> +
>>> +        ret = sev_snp_init(&argp->error, false);
>>> +    } else {
>>> +        ret = sev_platform_init(&argp->error);
>>> +    }
>>
>> Couldn't sev_snp_init() and sev_platform_init() be called unconditionally
>> in order?
>>
>> Since there is a hardware constraint that SNP init needs to always happen
>> before platform init, shouldn't SNP init happen as part of
>> __sev_platform_init_locked() instead?
>>
> 
> On Genoa there is currently an issue that if we do an SNP_INIT before an 
> SEV_INIT and then attempt to launch a SEV guest that may fail, so we 
> need to keep SNP INIT and SEV INIT separate.
> 
> We need to provide a way to run (existing) SEV guests on a system that 
> supports SNP without doing an SNP_INIT at all.
> 
> This is done using psp_init_on_probe parameter of the CCP module to 
> avoid doing either SNP/SEV firmware initialization during module load 
> and then defer the firmware initialization till someone launches a guest 
> of one flavor or the other.
> 
> And then sev_guest_init() does either SNP or SEV firmware init depending 
> on the type of the guest being launched.
> 
>> I found these call sites for __sev_platform_init_locked(), none of which
>> follow the correct call order:
>>
>> * sev_guest_init()
> 
> As explained above, this call site is important for deferring the 
> firmware initialization to an actual guest launch.
> 
>> * sev_ioctl_do_pek_csr
>> * sev_ioctl_do_pdh_export()
>> * sev_ioctl_do_pek_import()
>> * sev_ioctl_do_pek_pdh_gen()
>> * sev_pci_init()
>>
>> For me it looks like a bit flakky API use to have sev_snp_init() as an 
>> API
>> call.
>>
>> I would suggest to make SNP init internal to the ccp driver and take care
>> of the correct orchestration over there.
>>
> 
> Due to Genoa issue, we may still need SNP init and SEV init to be 
> invoked separately outside the CCP driver.
> 
>> Also, how it currently works in this patch set, if the firmware did not
>> load correctly, SNP init halts the whole system. The version check needs
>> to be in all call paths.
>>
> 
> Yes, i agree with that.
> 
> Thanks,
> Ashish
