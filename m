Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8FC663758
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 03:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbjAJC2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 21:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237971AbjAJC21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 21:28:27 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AF46476;
        Mon,  9 Jan 2023 18:28:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLr6fst5iSCGB3vrL7nXa2XQchjHPf1IDUA+MOPTh2k66NrSrcv6xcyfgyJbTlMZrB8QR3bydHVlyXTkowCTiSNe0fHS98L0vAh/GYEKi74a6lPkvtfo+ck/5k9d8nZ4i6FyHcuo8gu85+HMnJkdSq1rwT2sg4wHh3BoIt6AdnKG5+ZXBM8JbKAqg0V9XAPkjoBdTGzlBXkGLe+I0spD+050ngRL3HRwz4Nw9yIZAfepbvM1UcGcFgglJoZQ0m0bWsCPnYK5nsZj6pDHkhPHTomzktvBBVJErKPjLBHV/r41WlkaLbScFdbZVQnElI8U2JBeAlrRc7zr39I1NYcYLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYNehLukeWSVODaI2OA9+UOkNKOwCpEaK/kSx6qNd7Q=;
 b=Ebj9YYlIEHz/A4hNwckNVYNk1a7F2lb0S4oPsQ/5FnaNb1kqYRtHd6OCz+BAdQU81VMIftPGiqNln54UgzHcEXXxf7CtAC1ZwWiJKoaqFXPhIEJJKF6LzeOUXktzoXkPVcsmlH5DLSQCEbwGaLHX1ECFfvmaiSqhhcyEHZH1LghlZwO2ew0ZKVcJehOz1yX962B8vjERVn1CibEcmXagSUhp+YTnBqS6aAizMQ2gq/iQmJ6F2hAtdfolTOxXgUTguJGUMKoF3QlE6su/kNxXkkDCa8LQ/E+VJ9iPg4Wv2+G+xrgdI0viTsesID/i/ga3VPxNNoAdvD1rX47eNE9Sbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYNehLukeWSVODaI2OA9+UOkNKOwCpEaK/kSx6qNd7Q=;
 b=CUn+GUoTjUd4u6yVS5LQTx8i1rYMalD/IksIFpSdKJ9COGN25Ml1I+DB/mwQTqbLrK0ILuje+b0NXAyNTepWJjWIxbQRKSH+3IlM92RsMKnNGL7Eedssq4KuTRtoaHV4MudmhxQpQRsUb1fxh5KUm/VCOPUzxZeoRjesnhRMrIE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 CH2PR12MB4069.namprd12.prod.outlook.com (2603:10b6:610:ac::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Tue, 10 Jan 2023 02:28:23 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%4]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 02:28:23 +0000
Message-ID: <119075dd-5f3e-a393-f543-6cdfd34cd337@amd.com>
Date:   Tue, 10 Jan 2023 13:28:05 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH RFC v7 52/64] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
To:     "Kalra, Ashish" <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
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
        dgilbert@redhat.com, jarkko@kernel.org, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-53-michael.roth@amd.com>
 <aab7ed11-870e-579d-9328-4c32d9936392@amd.com>
 <66039193-14ca-5edb-d8d4-ca732d8c13a6@amd.com>
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <66039193-14ca-5edb-d8d4-ca732d8c13a6@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SYXPR01CA0118.ausprd01.prod.outlook.com
 (2603:10c6:0:2d::27) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|CH2PR12MB4069:EE_
X-MS-Office365-Filtering-Correlation-Id: 7251c802-6848-4d5b-1633-08daf2b2585f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5idUjDB+4JzRElQa3/1IRKr2mTJCSP45C9r7MQXcPehIdM0pTiL1WskFp8KPF6PJmhXrwRa2R9Mo+tBF1sHTMg5BmnUO7U6ShFpSRMhy8N6EBdSdVNiZ4/7C7mwMz9WI5UdPSPbgGJEelbj3qObZuOXMnvVRW7FMuNkExxXqvCBTcZ6ULk4bZeH0/MvqtDciS9HYSqrcCQDWM7M/NKtX8iO3zk/tMtr8HLFFmNyIFptWSi5dlGvv0VJm+foI5CTbsaGW8rXbOjKDbt67cI/l0Y2L8ir4MOpWKAK7XurAhj3KYAWWyo+5ZXNTCgP3bFQkqg2OBVfpJhevgvosdm02B0Lb4K8UAx81elJ1fXwgCiPNwfrgerKUraL/ye3mq9D/RYVuPWfM3L8Dr7c0uYSzFs8GwmOXjYmhIJlN7zRi7Fc8/BBGLmUerFSo6m/aCpVyPg1MVZdj0WFG5ZywX+u4VvclLB1QswgUYCn6EmcA6OuGTTuMfBAc7aQ7DKLCtwFu/sKXSdGx4cwJiG7yRTXL9aG9oYvWrHH6oXq6vxGIpgG526jRmXKF4XZXXgMZdItF8QbUsmGGWHsImkooOO/7sQ8ocBSnhxEqrH6hPccjc5cW1pFaCT3iBl6XPPGvesmqJ6Y7ClvN3s6gwljQTA+I9nw7YyoQphfOmQfzw9XAFnI+XCZJSZbUsYw3qsJXjnjdu5gdF5B+E74gzHC0+Eft1JmYRQ6ULRvgz8yPjyyFJWCIjODSJHF7wQ17m3lQqwNH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(451199015)(83380400001)(2906002)(2616005)(66476007)(7406005)(66556008)(7416002)(5660300002)(66946007)(6666004)(53546011)(26005)(186003)(36756003)(8936002)(30864003)(6506007)(6512007)(478600001)(38100700002)(110136005)(8676002)(41300700001)(6486002)(31686004)(966005)(4326008)(316002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N09FQWdaa1AraGM0ek1GOUhwYSs1eERqNVB2cVZvb0ZsMFVNeVVpTU1KSVBB?=
 =?utf-8?B?bGd2RkFWV3JGZC90b0hvTVU0bkw4cGhPcTRCM3g4Z1VZKzFBM29US0QwQzNC?=
 =?utf-8?B?K2J1OGxmRldMbTdEZHNua1Yxck1YWDJPWTlVSGFKN2NIazNLWFpMajNNQUt1?=
 =?utf-8?B?T3VndnZEdElUYmlmVFpMbW5KUUpUbUhiTng5RVJTTTFIOWNGZ0NMWW5lZUVE?=
 =?utf-8?B?b1BneGhSaDhBS1ZZNXlKZXFwWU9JbTJnSDlqQUo3ZkpjYjErUG1NUzZHdUJR?=
 =?utf-8?B?RzBENGZ2TUxsZEdtTUhTY3F5ZnZseDN3d2NaM1NyaW1sY1ZqVkJrRXlnOXBB?=
 =?utf-8?B?QUladE9DeWRLLzl1alVlOFYwaTJQeTNGYXJqTFdFM2ZueHpPS01OWWZybk5j?=
 =?utf-8?B?bmRvRkE1MlNKcTlGUDZpb3BqT2d5WmVtVXQyYzhwL0p6Q1FiZGozT3BUdWlY?=
 =?utf-8?B?Y0tOTkhYTnlDRlBXSHR0MC9Nb3cyLzJBZE93RWo2TnFiOWkxMjZ1OEhZV09W?=
 =?utf-8?B?MHdDZnpJeUlIS3paQ2ZHeE5WUHJMQ2tSTk1MVDRIUzJZdVdwZzdaVm8zZEhS?=
 =?utf-8?B?a3ZlcDBGREc3OElEakoxeERVTnUrMUU0T3JRZTNMOWVpVDJOZm82QjVmTDlC?=
 =?utf-8?B?NHVDc2xhMDJiYVZTUnNySWEySjY4ajNvMDJPTFBKVWt1SWRpdlZmYzE3VW5E?=
 =?utf-8?B?ZGNwcjRrMW5EQ280ajFDaGVaNmRoUGUvL1JSeVdGYXhSNzZCTTByMk5CMURv?=
 =?utf-8?B?dHFSMXNoc2F2WEhlbGh6NXg4T3dJcWttb3phMFNvMjZidXprWGNaRmpOT3Ey?=
 =?utf-8?B?THNmTzFzaGswRTRNcGVtTGdUdldlNzAxMWw2ZzgzcVBXWDJ5SVdkcEE5dldT?=
 =?utf-8?B?OFpmTTB1LzlzZmxxZTVYNnhLMlNnQWI3Z09odnFkY0RlWFV2K2Z2eTl6cU1D?=
 =?utf-8?B?SU51a3g4TitPaG5PN0R0SnFkRVRzbGRJcHIrL28xYjB3OUFia0FWWnlTVVlX?=
 =?utf-8?B?RlNmSUdCd2VMN1lLVTdxbzlNZDh3aDg4WWxxWHJmb0s3YVhIbWJ1TFBVdFhJ?=
 =?utf-8?B?b0YrdGh1VU5vZ0J5TmFKT3RJUGFTY1pTaDFPd2hHQkhlaVR1b1hQQlkzYmVv?=
 =?utf-8?B?SVYwaE9sVXhTbGNaU3h2OFg2cjZaYVZ5cXdsTzVEWm9zbzVOOTJjc2FCblRN?=
 =?utf-8?B?VDFURjY3bHFuc2RwNVVlMXRHUWFjS3VXMW5vSGZtQVZWL1NNQWVyblRrTFQv?=
 =?utf-8?B?TDRRVW10cWFXNjRhcVlVTHNQbmFFUm1KZGUvUlB6VnlJUTVIWmp1MG5MS0hB?=
 =?utf-8?B?Y3ZrV3JmcEZNbkdHSC9TNG5JeXZCYnh3TmQrSXUrLzRpVEk1RnJuZlY1dUNu?=
 =?utf-8?B?RDNTRElnUFJqMmF6YkFET3VYUnBoOFpjeExaeDErd1hNbStmcUZnTEpUTElU?=
 =?utf-8?B?clNYQndRSE5OQjRRenRscHFCMHZzNFJjU1ZnRjJxc2lqZCs4Z2xIMFZrZ0p4?=
 =?utf-8?B?aTI5d3BycXZrcHFUNlFTalpIck9aSUd4bklWZHhjOVp0TVhIOGtwb2V1aUth?=
 =?utf-8?B?NlFoUG5yRnpUeG0ybFA5Z0dBRkZ3MWVsQlE1T05sY25wUE44S1dIdHFpb0tD?=
 =?utf-8?B?bFBkREQyd3FjYnZQaEc2SDVXNnpWUGFMSW5idzZRb2lKRWUwSTU3YUt6UkZG?=
 =?utf-8?B?TEJMS1h0Z1hOZU1xbVBHNE5CdWxxZ1VITS9HdWhRUFVNZ3JJUlJDSUF3WnFT?=
 =?utf-8?B?L25oWGlpUWxzVEU4UVY0bnNaMkxZWlVBMWhTMmtBV3VkczdvN0s2Q2JRbGtp?=
 =?utf-8?B?WlBILzBubFdiVHBpcnJXb0xIbkI4K1Bub3RtN2pKZk5mNUlrK1grdXNXYTJF?=
 =?utf-8?B?WmNmSEt0VktoeVpIS3F2Tmd3elN3bkhMTFdGOWFJeFpJamZrQVRKdkt5VWVz?=
 =?utf-8?B?SDZKcWk1M3RoR3lTR3l3VWswZzV3ZTFTSEc0WU5YSkpCak5aS1MrY2dONXB2?=
 =?utf-8?B?ME1mdWxBOElkQlM1SGk2cEpPcHY3Z3FOZm5YM1ExdTJ1Qlc3RFYxS3BZV0JC?=
 =?utf-8?B?WG8zbDlkdk1XSzBNVDFBbWhkZ1U0M3NmOU5HSEloWEdBVjBqUVhYMlZqbi96?=
 =?utf-8?Q?lHlkIe0DGPpJx/OVIrNCdO+6V?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7251c802-6848-4d5b-1633-08daf2b2585f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 02:28:22.9104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BZJVOAQegMPou/ioNbeDQV0PboEye+rTpTvrWTsP2kw5TknmObMOM7/7gZti1sY+Ezcn9TKck0Yd7kd7rMWfGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4069
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/1/23 10:41, Kalra, Ashish wrote:
> On 1/8/2023 9:33 PM, Alexey Kardashevskiy wrote:
>> On 15/12/22 06:40, Michael Roth wrote:
>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>
>>> Version 2 of GHCB specification added the support for two SNP Guest
>>> Request Message NAE events. The events allows for an SEV-SNP guest to
>>> make request to the SEV-SNP firmware through hypervisor using the
>>> SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.
>>>
>>> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
>>> difference of an additional certificate blob that can be passed through
>>> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
>>> provides snp_guest_ext_guest_request() that is used by the KVM to get
>>> both the report and certificate data at once.
>>>
>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>> ---
>>>   arch/x86/kvm/svm/sev.c | 185 +++++++++++++++++++++++++++++++++++++++--
>>>   arch/x86/kvm/svm/svm.h |   2 +
>>>   2 files changed, 181 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 5f2b2092cdae..18efa70553c2 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -331,6 +331,7 @@ static int sev_guest_init(struct kvm *kvm, struct 
>>> kvm_sev_cmd *argp)
>>>           if (ret)
>>>               goto e_free;
>>> +        mutex_init(&sev->guest_req_lock);
>>>           ret = sev_snp_init(&argp->error, false);
>>>       } else {
>>>           ret = sev_platform_init(&argp->error);
>>> @@ -2051,23 +2052,34 @@ int sev_vm_move_enc_context_from(struct kvm 
>>> *kvm, unsigned int source_fd)
>>>    */
>>>   static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd 
>>> *argp)
>>>   {
>>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>       struct sev_data_snp_addr data = {};
>>> -    void *context;
>>> +    void *context, *certs_data;
>>>       int rc;
>>> +    /* Allocate memory used for the certs data in SNP guest request */
>>> +    certs_data = kzalloc(SEV_FW_BLOB_MAX_SIZE, GFP_KERNEL_ACCOUNT);
>>> +    if (!certs_data)
>>> +        return NULL;
>>> +
>>>       /* Allocate memory for context page */
>>>       context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
>>>       if (!context)
>>> -        return NULL;
>>> +        goto e_free;
>>>       data.gctx_paddr = __psp_pa(context);
>>>       rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, 
>>> &data, &argp->error);
>>> -    if (rc) {
>>> -        snp_free_firmware_page(context);
>>> -        return NULL;
>>> -    }
>>> +    if (rc)
>>> +        goto e_free;
>>> +
>>> +    sev->snp_certs_data = certs_data;
>>>       return context;
>>> +
>>> +e_free:
>>> +    snp_free_firmware_page(context);
>>> +    kfree(certs_data);
>>> +    return NULL;
>>>   }
>>>   static int snp_bind_asid(struct kvm *kvm, int *error)
>>> @@ -2653,6 +2665,8 @@ static int snp_decommission_context(struct kvm 
>>> *kvm)
>>>       snp_free_firmware_page(sev->snp_context);
>>>       sev->snp_context = NULL;
>>> +    kfree(sev->snp_certs_data);
>>> +
>>>       return 0;
>>>   }
>>> @@ -3174,6 +3188,8 @@ static int sev_es_validate_vmgexit(struct 
>>> vcpu_svm *svm, u64 *exit_code)
>>>       case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>>>       case SVM_VMGEXIT_HV_FEATURES:
>>>       case SVM_VMGEXIT_PSC:
>>> +    case SVM_VMGEXIT_GUEST_REQUEST:
>>> +    case SVM_VMGEXIT_EXT_GUEST_REQUEST:
>>>           break;
>>>       default:
>>>           reason = GHCB_ERR_INVALID_EVENT;
>>> @@ -3396,6 +3412,149 @@ static int snp_complete_psc(struct kvm_vcpu 
>>> *vcpu)
>>>       return 1;
>>>   }
>>> +static unsigned long snp_setup_guest_buf(struct vcpu_svm *svm,
>>> +                     struct sev_data_snp_guest_request *data,
>>> +                     gpa_t req_gpa, gpa_t resp_gpa)
>>> +{
>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>> +    struct kvm *kvm = vcpu->kvm;
>>> +    kvm_pfn_t req_pfn, resp_pfn;
>>> +    struct kvm_sev_info *sev;
>>> +
>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>> +
>>> +    if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, 
>>> PAGE_SIZE))
>>> +        return SEV_RET_INVALID_PARAM;
>>> +
>>> +    req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
>>> +    if (is_error_noslot_pfn(req_pfn))
>>> +        return SEV_RET_INVALID_ADDRESS;
>>> +
>>> +    resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
>>> +    if (is_error_noslot_pfn(resp_pfn))
>>> +        return SEV_RET_INVALID_ADDRESS;
>>> +
>>> +    if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
>>> +        return SEV_RET_INVALID_ADDRESS;
>>> +
>>> +    data->gctx_paddr = __psp_pa(sev->snp_context);
>>> +    data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
>>> +    data->res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static void snp_cleanup_guest_buf(struct sev_data_snp_guest_request 
>>> *data, unsigned long *rc)
>>> +{
>>> +    u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
>>> +    int ret;
>>> +
>>> +    ret = snp_page_reclaim(pfn);
>>> +    if (ret)
>>> +        *rc = SEV_RET_INVALID_ADDRESS;
>>> +
>>> +    ret = rmp_make_shared(pfn, PG_LEVEL_4K);
>>> +    if (ret)
>>> +        *rc = SEV_RET_INVALID_ADDRESS;
>>> +}
>>> +
>>> +static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t 
>>> req_gpa, gpa_t resp_gpa)
>>> +{
>>> +    struct sev_data_snp_guest_request data = {0};
>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>> +    struct kvm *kvm = vcpu->kvm;
>>> +    struct kvm_sev_info *sev;
>>> +    unsigned long rc;
>>> +    int err;
>>> +
>>> +    if (!sev_snp_guest(vcpu->kvm)) {
>>> +        rc = SEV_RET_INVALID_GUEST;
>>> +        goto e_fail;
>>> +    }
>>> +
>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>> +
>>> +    mutex_lock(&sev->guest_req_lock);
>>> +
>>> +    rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
>>> +    if (rc)
>>> +        goto unlock;
>>> +
>>> +    rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
>>
>>
>> This one goes via sev_issue_cmd_external_user() and uses sev-fd...
>>
>>> +    if (rc)
>>> +        /* use the firmware error code */
>>> +        rc = err;
>>> +
>>> +    snp_cleanup_guest_buf(&data, &rc);
>>> +
>>> +unlock:
>>> +    mutex_unlock(&sev->guest_req_lock);
>>> +
>>> +e_fail:
>>> +    svm_set_ghcb_sw_exit_info_2(vcpu, rc);
>>> +}
>>> +
>>> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t 
>>> req_gpa, gpa_t resp_gpa)
>>> +{
>>> +    struct sev_data_snp_guest_request req = {0};
>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>> +    struct kvm *kvm = vcpu->kvm;
>>> +    unsigned long data_npages;
>>> +    struct kvm_sev_info *sev;
>>> +    unsigned long rc, err;
>>> +    u64 data_gpa;
>>> +
>>> +    if (!sev_snp_guest(vcpu->kvm)) {
>>> +        rc = SEV_RET_INVALID_GUEST;
>>> +        goto e_fail;
>>> +    }
>>> +
>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>> +
>>> +    data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
>>> +    data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
>>> +
>>> +    if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
>>> +        rc = SEV_RET_INVALID_ADDRESS;
>>> +        goto e_fail;
>>> +    }
>>> +
>>> +    mutex_lock(&sev->guest_req_lock);
>>> +
>>> +    rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
>>> +    if (rc)
>>> +        goto unlock;
>>> +
>>> +    rc = snp_guest_ext_guest_request(&req, (unsigned 
>>> long)sev->snp_certs_data,
>>> +                     &data_npages, &err);
>>
>> but this one does not and jump straight to 
>> drivers/crypto/ccp/sev-dev.c ignoring sev->fd. Why different? Can 
>> these two be unified? sev_issue_cmd_external_user() only checks if fd 
>> is /dev/sev which is hardly useful.
>>
>> "[PATCH RFC v7 32/64] crypto: ccp: Provide APIs to query extended 
>> attestation report" added this one.
> 
> SNP_EXT_GUEST_REQUEST additionally returns a certificate blob and that's 
> why it goes through the CCP driver interface 
> snp_guest_ext_guest_request() that is used to get both the report and 
> certificate data/blob at the same time.

True. I thought though that this calls for extending sev_issue_cmd() to 
take care of these extra parameters rather than just skipping the sev->fd.


> All the FW API calls on the KVM side go through sev_issue_cmd() and 
> sev_issue_cmd_external_user() interfaces and that i believe uses sev->fd 
> more of as a sanity check.

Does not look like it:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/crypto/ccp/sev-dev.c?h=v6.2-rc3#n1290

===
int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
				void *data, int *error)
{
	if (!filep || filep->f_op != &sev_fops)
		return -EBADF;

	return sev_do_cmd(cmd, data, error);
}
EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
===

The only "more" is that it requires sev->fd to be a valid open fd, what 
is the value in that? I may easily miss the bigger picture here. Thanks,


> Thanks,
> Ashish
> 
>>
>> Besides, is sev->fd really needed in the sev struct at all? Thanks,
>>
>>
>>> +    if (rc) {
>>> +        /*
>>> +         * If buffer length is small then return the expected
>>> +         * length in rbx.
>>> +         */
>>> +        if (err == SNP_GUEST_REQ_INVALID_LEN)
>>> +            vcpu->arch.regs[VCPU_REGS_RBX] = data_npages;
>>> +
>>> +        /* pass the firmware error code */
>>> +        rc = err;
>>> +        goto cleanup;
>>> +    }
>>> +
>>> +    /* Copy the certificate blob in the guest memory */
>>> +    if (data_npages &&
>>> +        kvm_write_guest(kvm, data_gpa, sev->snp_certs_data, 
>>> data_npages << PAGE_SHIFT))
>>> +        rc = SEV_RET_INVALID_ADDRESS;
>>> +
>>> +cleanup:
>>> +    snp_cleanup_guest_buf(&req, &rc);
>>> +
>>> +unlock:
>>> +    mutex_unlock(&sev->guest_req_lock);
>>> +
>>> +e_fail:
>>> +    svm_set_ghcb_sw_exit_info_2(vcpu, rc);
>>> +}
>>> +
>>>   static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>>>   {
>>>       struct vmcb_control_area *control = &svm->vmcb->control;
>>> @@ -3629,6 +3788,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>>>           vcpu->run->vmgexit.ghcb_msr = ghcb_gpa;
>>>           vcpu->arch.complete_userspace_io = snp_complete_psc;
>>>           break;
>>> +    case SVM_VMGEXIT_GUEST_REQUEST: {
>>> +        snp_handle_guest_request(svm, control->exit_info_1, 
>>> control->exit_info_2);
>>> +
>>> +        ret = 1;
>>> +        break;
>>> +    }
>>> +    case SVM_VMGEXIT_EXT_GUEST_REQUEST: {
>>> +        snp_handle_ext_guest_request(svm,
>>> +                         control->exit_info_1,
>>> +                         control->exit_info_2);
>>> +
>>> +        ret = 1;
>>> +        break;
>>> +    }
>>>       case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>>>           vcpu_unimpl(vcpu,
>>>                   "vmgexit: unsupported event - exit_info_1=%#llx, 
>>> exit_info_2=%#llx\n",
>>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>>> index 12b9f4d539fb..7c0f9d00950f 100644
>>> --- a/arch/x86/kvm/svm/svm.h
>>> +++ b/arch/x86/kvm/svm/svm.h
>>> @@ -101,6 +101,8 @@ struct kvm_sev_info {
>>>       u64 snp_init_flags;
>>>       void *snp_context;      /* SNP guest context page */
>>>       spinlock_t psc_lock;
>>> +    void *snp_certs_data;
>>> +    struct mutex guest_req_lock;
>>>   };
>>>   struct kvm_svm {
>>

-- 
Alexey
