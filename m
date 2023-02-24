Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392116A1F88
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 17:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjBXQWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 11:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjBXQWb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 11:22:31 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4326A78F;
        Fri, 24 Feb 2023 08:22:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCkmqzWkq3Wp5WFXML1/1QaFvTClGZkG/X5OSNj6kb3aG3GRUW0yoxyn0Ya67PcFcPAJzsHT/O5hdKVDc+IS5gE+4FtgarA4nAzEdOffBU3tHlgR7VaBiPf4y8X0rBmqrVccKriE70L4kOZHhmEfwPW/mTkQkAPeLsEmgYgWZv4fLeR3Xik+QxF/Ntw1GM2fhlard+yF8771StGYqGi5qNOHHxgD+XVJyVfNSDiNRvKE5rvNvu0REdsIFxO5CM1d8lav9kHAT9foCS2681NHJzIbbBAvB3hKRZ2la/e+quujgOMK9qOje0evvYka5VCpboBC4UWttYBLyVZ3sQPS9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7eMZaKT/mt2i2ImLjmWqSuoelDgg7f/QvMRvYQ7hoSc=;
 b=jBnARTZpB3gGbAj2GQp6ligJaGr4MrThdQg5A+ExTSW/u9e+rcoC/sbpeNwAnbFopSnuwjbAHTVo83ql7Ke6M7oiRi0ySXDNGlAlTeSFgeE65ybn02nEuvb52uqPAhanQtqOxE/LVp4MW4ZPuQ++sVMpOOzE4GuQyVWjcZbJDg9DaYO6S4XJL8Ay82zy49aGxcvt/Ms/0CR3MC9Vg8xbvW6u+zRGB6GSrxs1N0oiQE4sXO3zKmY/gOUPeSZnIz0s6ghGXt1KomFV3n9o282ASESNplpHVZ/HLJJMJxQAxo+WfEoQ4wno3U9vKvQPyvhBxsFIHCbB/321a/V7Hen8OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eMZaKT/mt2i2ImLjmWqSuoelDgg7f/QvMRvYQ7hoSc=;
 b=aY99qAwqx/UUgmQ3OnRpUQ9s7LuGvwbNmHCTvdE2J5RZx/B42pUDJr13PWVxALoc6QkWrYs4bDbIrq0CNlXfr6qdAGBkKieaK4MjPjmMunbxX//Ctj211nmELNfp+PWhlrVz6gb7LMVRxkA68RN/qLFgYnz6SX8cXH0AFfIFCss=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by PH7PR12MB7113.namprd12.prod.outlook.com (2603:10b6:510:1ec::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Fri, 24 Feb
 2023 16:22:25 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c%5]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 16:22:25 +0000
Message-ID: <ab0765b1-6d81-75db-7476-a795b1e64c23@amd.com>
Date:   Fri, 24 Feb 2023 10:22:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH RFC v8 34/56] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START
 command
Content-Language: en-US
To:     Zhi Wang <zhi.wang.linux@gmail.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-35-michael.roth@amd.com>
 <20230223234112.000030ac@gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230223234112.000030ac@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::20) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|PH7PR12MB7113:EE_
X-MS-Office365-Filtering-Correlation-Id: 69bc2468-dda3-46df-5cfe-08db168350a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: swkYZPrHpm9L/E+33X2dyN35okFA12sxV9ntg3v2YHV0Z+82JyLSG8nWTi6rS4rAqM0yqavsRvf5AvmHSOFwGaaqPMoro6cQDVPTsk8wO13fk2FJGz495YdAxeLHS4+8icHqhbwGZqGCmJCZhF5dIE05vOtR3/qSdZtY5pn9XxHLjxokYX0/+ZekpUBm8bq4uvEgafxy4ZImgnIFLPbuQkqSUlMr0xcwDmQhny6cvl9CV1YZ6TN7Q+eLHIpcs3FTPY52uUoPQNniEza9erfZEG+uDKTJ/RhGdIfrbTfaXli2KwY9enHz2r0g+2rkzAkK4Nth2jXeo3yamOxbushWBV09k4IolhYmNKmcVPN6SwS6cvG2lMCEGfrbQFQPKmF4lMHyRssKeBrEtOScWcw++4Mb1/QI5o956E1ZBVzagpm/0SHWMEBpCTXPYG5kgrYY0JFqGZ9GZNcWfDqeTdURGNIQbIAjxfgml1VgPL2V3VBI7vMl5p64f62Qo3FGRDUJllDVkzyBn1GMWHZKLajLjCDxfjMM34xHvY+A9b1oWdjJnu49/GP34JBS4CdjKFt75mS4hCua0cuKnN55h9wJbnG2vrYnaaosqhUXws8Ce6fhtVR3B3K6/B/SIY1P6GTaUzltmQM6MPMN0choEr76t1aHqEVt75YCVVXpLKyoO7IzKVriFzEndaNh9rO0x2SSNly/IKEOlxyG2gr4N04AWWjxH05MPWQO5aDNEKfiviM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(451199018)(966005)(110136005)(478600001)(83380400001)(66946007)(6636002)(66476007)(316002)(8676002)(8936002)(5660300002)(6666004)(4326008)(6506007)(6512007)(66556008)(41300700001)(26005)(186003)(53546011)(6486002)(36756003)(31696002)(2906002)(7406005)(7416002)(2616005)(38100700002)(31686004)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFlkTEtYR2FmSXNGeUZjeUhUQ1N5YXRrQzVOb3pZaXVXQ2VLbjNjWGpldU5Y?=
 =?utf-8?B?K2pmd3ZxeDdORkRSWWoydnJYUEtCa0UzU0hUQ1JiUWlhcC9ZK3ZFeFRLWEI4?=
 =?utf-8?B?b1lUZVo4ZmpQenpndFJyZCtTRVFsSUtKVjY0RWVzVGJCUFlncWpFeC95QVU1?=
 =?utf-8?B?NTJDTkZwcjR6NDNyejk1U1RiY1F5aHVwdjlZa3RTWDdEM09zbi9PRzBrZW1m?=
 =?utf-8?B?RHkweTllNEMzVTVsSVJZc2Z4TWg3dGx2Y2hpdjloOXU4SklMN3FxQmRBaG42?=
 =?utf-8?B?MFBVdmtZbkVVSzF4bVpDcHg0Q1YvMHI3aWNQR3JGL3IwVUFHcVV6bzBDZyt2?=
 =?utf-8?B?UEMzdlZyWnZZUmRWaE1TUmhHaXVCQWxnV0JDUGptSy9VNUFmRXFpQ1ZDQmlI?=
 =?utf-8?B?Nmx3d0VMY0ZlNzNJbmR2d01HeVNQQ2dZMjQ5c2VHNmh4NjBXOHdWT3JHTUoy?=
 =?utf-8?B?TUk4cXlKVHJHb2kyR1Vid2pVdmRFTmFVa2s1QmtmQVBpZXJnSkIxN1JET0NK?=
 =?utf-8?B?L1hBWmZPSDRIMTREM08rbGlNSW9BMTRodzN4bE1QdmxkYzBvWE91N0g4MUZX?=
 =?utf-8?B?UjY5TTdNTjMwME8xZTNNZVJhZjQzM1FjM2NwT0pYZUFmcThPME1FTjdIT1Fu?=
 =?utf-8?B?RnpKNURHYUtsZCt3Sjd1cWhndFQ5OGJnS1h1Ry85eUFuZWhvcnFOck9qeTND?=
 =?utf-8?B?b0V3VFpaNDNVSnRSWDk0MjVjQjhEc0I2aWRZY3ZwaHBPTFlmTWkxRlRzNUg2?=
 =?utf-8?B?dmN1YkoySDRuQ0h5bWF4d09lQW5sQUQyYjRGN0VlM1VJbldrVGRpQkJVRUNU?=
 =?utf-8?B?UHByZE5CL3E2bzdCNHU4RkdwMVJaQ05pWXJPazZnaUNFZWgzR2FWaVVveWRY?=
 =?utf-8?B?K21sOElxazRMQXU2eXZFcWk5NlBtQzJTaUJGbDJDZlhTVE5ac05PdnkwYnBY?=
 =?utf-8?B?dUpvc3U1anFZL0xGRVYxRXc3citHU1hiRWVJbjJmNDJjcWdQSXM4Vm9RTGV1?=
 =?utf-8?B?a1Zxd0c5dlhwbW1OSHFFRU95WjNiclErdFVPbjl0MmFQS2MyalR4b2picWVR?=
 =?utf-8?B?bW5aVk0xbmZrTWdzd2I3OEc4ZU9jbG1za1pWTnVRajRaZmtrdEN3SDJRS0tj?=
 =?utf-8?B?dXRNUjU0aHgvVk9WYllJdUZFR296N1BNODRCYlplQytKcElkcEVFcUo0emtv?=
 =?utf-8?B?SGx6aVM2K1drYUsrYVg1djdmOUtKWWQycFdOc1RZVHlSaHNTSlhOOVhYa2lJ?=
 =?utf-8?B?UStGN2MwNGw2WGlKcjFIcTVRRHc5UEh2eUhDQVl1TkFERG9NN2tNS3Vsdnlz?=
 =?utf-8?B?UDBocmZPK1JDSDM5bTB3enVOZzlxaS94RC9jUExyK2VGRzVyVldmVlZSZjMv?=
 =?utf-8?B?ZE9NR2xHeWtiUzYza0JyVVhlaUltcjdqdDgwWkJSaFFVTWgvVWFtRGtuYVFE?=
 =?utf-8?B?aDlZRHVILzN4NFl2QUw0b2NUbWNYUlpDZmhEMEdoMjdwZ0h5UmlmSndXS1Fi?=
 =?utf-8?B?aS9hUGlERndZT1c4dlF5S0MyWTVPNTBqalBUQit4d0o4UCtDOVBONVQxOUFU?=
 =?utf-8?B?V2dINjZjODNFSm85MUdQN0piWTAzQStybWFWSjB3ZGswMFdXUERCRjVmdXVV?=
 =?utf-8?B?VWFZR1BBalNCZDZoL3h6Q2Uva0ltenBRUkZZaHIwQWd4dWN3cTFEWEZPNVhS?=
 =?utf-8?B?TDBRbDUwWm5rcUV1Z2pSY09qeWYyaEFWbEZhc2FtOE1kRUlQL0lmZVpXWmZo?=
 =?utf-8?B?djBXMnNLeWVPTHRaemRzV0Q3aU94V2JLNTNsek5ycWZFYTByOG9vd1pUclZY?=
 =?utf-8?B?eHkxWkxLN3VlMThjR3k2b01CTnBOakpjTm1OQXNtb3B4RFBwTzlZaTVNd01E?=
 =?utf-8?B?aU1NYi9UU3FXS0ZHamVNRzhWMjNmbjJUK3ErZHR4NkZRS0l0ZnQyMmNwMlYr?=
 =?utf-8?B?REdUUTBQaVkvYkdlbkF2QWtDRCsvQ0xLVFFJSXNZRW4zeHExMUFza3FGeFBp?=
 =?utf-8?B?Z1FkL0NOUnVycHVJT08xWXRUaDVOVmNIZU1MdmtyRmtWcTBxZ25uSUVVdXRm?=
 =?utf-8?B?bnduMWZ0T0RUSFMxcXcvUGxkUVBxa2w0eDY3RGRoVFZOaVRWSWQ2cldYUDA5?=
 =?utf-8?Q?zTNATPVknh2UJ0fvsFQkG6VM4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69bc2468-dda3-46df-5cfe-08db168350a0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 16:22:25.5239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AIZFHsERyKrOa/riEP64AceAZkrS+l5B4/IEiQHAPKBx7i+u4OO3oNnN292G2QIGC3cek64vRQ65jezhtM3W6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7113
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/23/23 15:41, Zhi Wang wrote:
> On Mon, 20 Feb 2023 12:38:25 -0600
> Michael Roth <michael.roth@amd.com> wrote:
> 
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> KVM_SEV_SNP_LAUNCH_START begins the launch process for an SEV-SNP guest.
>> The command initializes a cryptographic digest context used to construct
>> the measurement of the guest. If the guest is expected to be migrated,
>> the command also binds a migration agent (MA) to the guest.
>>
>> For more information see the SEV-SNP specification.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   .../virt/kvm/x86/amd-memory-encryption.rst    |  24 ++++
>>   arch/x86/kvm/svm/sev.c                        | 121 +++++++++++++++++-
>>   arch/x86/kvm/svm/svm.h                        |   1 +
>>   include/uapi/linux/kvm.h                      |  10 ++
>>   4 files changed, 153 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
>> index 2432213bd0ea..58971fc02a15 100644
>> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
>> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
>> @@ -461,6 +461,30 @@ The flags bitmap is defined as::
>>   If the specified flags is not supported then return -EOPNOTSUPP, and the supported
>>   flags are returned.
>>   
>> +19. KVM_SNP_LAUNCH_START
>> +------------------------
>> +
>> +The KVM_SNP_LAUNCH_START command is used for creating the memory encryption
>> +context for the SEV-SNP guest. To create the encryption context, user must
>> +provide a guest policy, migration agent (if any) and guest OS visible
>> +workarounds value as defined SEV-SNP specification.
>> +
>> +Parameters (in): struct  kvm_snp_launch_start
>> +
>> +Returns: 0 on success, -negative on error
>> +
>> +::
>> +
>> +        struct kvm_sev_snp_launch_start {
>> +                __u64 policy;           /* Guest policy to use. */
>> +                __u64 ma_uaddr;         /* userspace address of migration agent */
>> +                __u8 ma_en;             /* 1 if the migration agent is enabled */
>> +                __u8 imi_en;            /* set IMI to 1. */
>> +                __u8 gosvw[16];         /* guest OS visible workarounds */
>> +        };
>> +
>> +See the SEV-SNP specification for further detail on the launch input.
>> +
>>   References
>>   ==========
>>   
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index a8efe1f6bf77..097bb2138360 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -22,6 +22,7 @@
>>   #include <asm/pkru.h>
>>   #include <asm/trapnr.h>
>>   #include <asm/fpu/xcr.h>
>> +#include <asm/sev.h>
>>   
>>   #include "mmu.h"
>>   #include "x86.h"
>> @@ -75,6 +76,8 @@ static unsigned int nr_asids;
>>   static unsigned long *sev_asid_bitmap;
>>   static unsigned long *sev_reclaim_asid_bitmap;
>>   
>> +static int snp_decommission_context(struct kvm *kvm);
>> +
>>   struct enc_region {
>>   	struct list_head list;
>>   	unsigned long npages;
>> @@ -100,12 +103,17 @@ static int sev_flush_asids(int min_asid, int max_asid)
>>   	down_write(&sev_deactivate_lock);
>>   
>>   	wbinvd_on_all_cpus();
>> -	ret = sev_guest_df_flush(&error);
>> +
>> +	if (sev_snp_enabled)
>> +		ret = sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, &error);
>> +	else
>> +		ret = sev_guest_df_flush(&error);
>>   
>>   	up_write(&sev_deactivate_lock);
>>   
>>   	if (ret)
>> -		pr_err("SEV: DF_FLUSH failed, ret=%d, error=%#x\n", ret, error);
>> +		pr_err("SEV%s: DF_FLUSH failed, ret=%d, error=%#x\n",
>> +		       sev_snp_enabled ? "-SNP" : "", ret, error);
>>   
>>   	return ret;
>>   }
>> @@ -2011,6 +2019,80 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>>   	return ret;
>>   }
>>   
>> +/*
>> + * The guest context contains all the information, keys and metadata
>> + * associated with the guest that the firmware tracks to implement SEV
>> + * and SNP features. The firmware stores the guest context in hypervisor
>> + * provide page via the SNP_GCTX_CREATE command.
>> + */
>> +static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
>> +{
>> +	struct sev_data_snp_addr data = {};
>> +	void *context;
>> +	int rc;
>> +
>> +	/* Allocate memory for context page */
>> +	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
>> +	if (!context)
>> +		return NULL;
>> +
>> +	data.gctx_paddr = __psp_pa(context);
>> +	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
>> +	if (rc) {
>> +		snp_free_firmware_page(context);
>> +		return NULL;
>> +	}
>> +
>> +	return context;
>> +}
>> +
>> +static int snp_bind_asid(struct kvm *kvm, int *error)
>> +{
>> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +	struct sev_data_snp_activate data = {0};
>> +
>> +	data.gctx_paddr = __psp_pa(sev->snp_context);
>> +	data.asid   = sev_get_asid(kvm);
>> +	return sev_issue_cmd(kvm, SEV_CMD_SNP_ACTIVATE, &data, error);
> 
> According to the SNP ABI specification[1] 8.10 SNP_ACTIVATE:
> 
> "The firmware checks that a DF_FLUSH is not required. If a DF_FLUSH is
> required, the firmware returns DFFLUSH_REQUIRED. Note that all ASIDs are
> marked to require a DF_FLUSH at reset."
> 
> Do we need a SNP_DF_FLUSH here before calling SNP_ACTIVATE or handle the
> situation if the PSP firmware returns DFFLUSH_REQUIRED?
> 
> [1] https://www.amd.com/system/files/TechDocs/56860.pdf

This is related to ASID use. An initial DF_FLUSH is done which allows any 
SNP ASID to be used once without requiring a DF_FLUSH. Once an ASID has 
been used, it cannot be re-used until a DF_FLUSH is performed. The ASID 
recycling code takes care of that.

Thanks,
Tom

> 
>> +}
>> +
>> +static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>> +{
>> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +	struct sev_data_snp_launch_start start = {0};
>> +	struct kvm_sev_snp_launch_start params;
>> +	int rc;
>> +
>> +	if (!sev_snp_guest(kvm))
>> +		return -ENOTTY;
>> +
>> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
>> +		return -EFAULT;
>> +
>> +	sev->snp_context = snp_context_create(kvm, argp);
>> +	if (!sev->snp_context)
>> +		return -ENOTTY;
>> +
>> +	start.gctx_paddr = __psp_pa(sev->snp_context);
>> +	start.policy = params.policy;
>> +	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
>> +	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
>> +	if (rc)
>> +		goto e_free_context;
>> +
>> +	sev->fd = argp->sev_fd;
>> +	rc = snp_bind_asid(kvm, &argp->error);
>> +	if (rc)
>> +		goto e_free_context;
>> +
>> +	return 0;
>> +
>> +e_free_context:
>> +	snp_decommission_context(kvm);
>> +
>> +	return rc;
>> +}
>> +
>>   int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>>   {
>>   	struct kvm_sev_cmd sev_cmd;
>> @@ -2101,6 +2183,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>>   	case KVM_SEV_RECEIVE_FINISH:
>>   		r = sev_receive_finish(kvm, &sev_cmd);
>>   		break;
>> +	case KVM_SEV_SNP_LAUNCH_START:
>> +		r = snp_launch_start(kvm, &sev_cmd);
>> +		break;
>>   	default:
>>   		r = -EINVAL;
>>   		goto out;
>> @@ -2292,6 +2377,28 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>>   	return ret;
>>   }
>>   
>> +static int snp_decommission_context(struct kvm *kvm)
>> +{
>> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +	struct sev_data_snp_addr data = {};
>> +	int ret;
>> +
>> +	/* If context is not created then do nothing */
>> +	if (!sev->snp_context)
>> +		return 0;
>> +
>> +	data.gctx_paddr = __sme_pa(sev->snp_context);
>> +	ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
>> +	if (WARN_ONCE(ret, "failed to release guest context"))
>> +		return ret;
>> +
>> +	/* free the context page now */
>> +	snp_free_firmware_page(sev->snp_context);
>> +	sev->snp_context = NULL;
>> +
>> +	return 0;
>> +}
>> +
>>   void sev_vm_destroy(struct kvm *kvm)
>>   {
>>   	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> @@ -2333,7 +2440,15 @@ void sev_vm_destroy(struct kvm *kvm)
>>   		}
>>   	}
>>   
>> -	sev_unbind_asid(kvm, sev->handle);
>> +	if (sev_snp_guest(kvm)) {
>> +		if (snp_decommission_context(kvm)) {
>> +			WARN_ONCE(1, "Failed to free SNP guest context, leaking asid!\n");
>> +			return;
>> +		}
>> +	} else {
>> +		sev_unbind_asid(kvm, sev->handle);
>> +	}
>> +
>>   	sev_asid_free(sev);
>>   }
>>   
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 56a5c96d8a36..740969b57425 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -92,6 +92,7 @@ struct kvm_sev_info {
>>   	struct misc_cg *misc_cg; /* For misc cgroup accounting */
>>   	atomic_t migration_in_progress;
>>   	u64 snp_init_flags;
>> +	void *snp_context;      /* SNP guest context page */
>>   };
>>   
>>   struct kvm_svm {
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 499cc323f793..cf19799ca5ce 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1919,6 +1919,7 @@ enum sev_cmd_id {
>>   
>>   	/* SNP specific commands */
>>   	KVM_SEV_SNP_INIT,
>> +	KVM_SEV_SNP_LAUNCH_START,
>>   
>>   	KVM_SEV_NR_MAX,
>>   };
>> @@ -2026,6 +2027,15 @@ struct kvm_snp_init {
>>   	__u64 flags;
>>   };
>>   
>> +struct kvm_sev_snp_launch_start {
>> +	__u64 policy;
>> +	__u64 ma_uaddr;
>> +	__u8 ma_en;
>> +	__u8 imi_en;
>> +	__u8 gosvw[16];
>> +	__u8 pad[6];
>> +};
>> +
>>   #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>>   #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>>   #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
> 
