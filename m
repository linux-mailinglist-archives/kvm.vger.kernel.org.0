Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5D866B904
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 09:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbjAPIYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 03:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbjAPIYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 03:24:15 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA081205D;
        Mon, 16 Jan 2023 00:24:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6o7wAwhtDNzKqYSnWHElxrdyYeq78RypF4TginRQqu+8M5mkfQ5nMTSPZH6dUxNMK1+abwmNf+NbqpuSkhGkK7569IYjIfuWvR8kJc5Be+U2vQzZnr8NNT9BjbD3jOOa6/iRHtW6VCcB6CpDtemXLHn4imDLryAIeRTNqOy9Boo3gprLM/RI6uNE5+FdXL2oXKn/1qaWt5gxYzXB9JG1fQbZl6gapc3z7h4t49vW9NWmhXu+y060LyAXTnnghyUPuPAS6zlo5yTlv+ktTElELYxkQ8lHhsxgqei8EQ1ma2FlVWOddNeW+7zrZONgcCCBgiYSUkk5aET2w1TU/CTaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iCA+WWwt4p6a0LqEZaPpFYF4XG6uToQEmvNMAsfgPzQ=;
 b=VcXmbp2PFaRbMJbKQO35iMXLJ1uzvLlXUD4qnrpzZsANx1IFxY0opjtpYDw+fUGp2u20Ln6tp0Ftz2Kk2XEwsvlo6TLZZAj1Cw7KLlwPAYA4GT+BW/UhEtF3X683LQjIjW7ot28/8fBL1f20+HEHRhxc4ZUMmJmpv5/wmIKBHr+m654m/nbBPJVkjbx/c4JpnrZZ4O2k9R5I3csZpa7DOxdsPCdAA6HT6Rs8X5b8nW1CuEaFXWAotiu6bdqFnqKSig9T7fg2wLO9ojcmuKJSoiaynpasIa6FJ0kHTXox9fEApRAgwRc6WpST8Ra6KA5yVbNmqOZ3XuxUBIFSah1miw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iCA+WWwt4p6a0LqEZaPpFYF4XG6uToQEmvNMAsfgPzQ=;
 b=eJ9A/XDDTNQxzIExUhSGy4OZon2RlDvbbzfcB45ucEBWEvatmbgQPyK1wk/Q7y/bxvfB9NcyDVMmNHZ9ORbCbFNFL9H4+ae1gXShhB+KBlnYDwdvNeF5NjQg6qyIjpmZ3rvpbCyQELGjlsjsf2PTX+6Ls0EGoft+9CyaBcI4CXU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB5595.namprd12.prod.outlook.com (2603:10b6:510:135::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 08:24:10 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700%6]) with mapi id 15.20.5986.018; Mon, 16 Jan 2023
 08:24:10 +0000
Message-ID: <4bca96ee-3665-5503-bb88-baae98e700e2@amd.com>
Date:   Mon, 16 Jan 2023 13:53:56 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5] x86/sev: Add SEV-SNP guest feature negotiation support
Content-Language: en-US
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, thomas.lendacky@amd.com, michael.roth@amd.com,
        David Rientjes <rientjes@google.com>, stable@kernel.org
References: <20230112084139.12615-1-nikunj@amd.com>
 <20230113135326.00006f06@gmail.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20230113135326.00006f06@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0172.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::27) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB5595:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c5eebdf-429a-4833-b79a-08daf79b0aa1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z1GPCzpMJWV2LQed2A39Exrt0bwb/gTGnKNJMv3t3zL4jTccevnDBAw0vXNRyQVB8MEalJQv+GdLEj2+fMfwEuh4T2pojIp27wfvoWyzUeg2JulDVrpOE3Aszqx60PblF5HYIw1sw22ceuI6ELt5JBN3yHjQaycDkSRc3qMbgow+jUWypPaaaW2nZA7HM/c/Ya/RW8OhMJOox1TBQas7RBDeyNErFeKATrEg4EIxUah04Pi+k9OFTRkMe0/0UuoM+0k0fAsw5kB4ghjCjZDrwKtXoEyOSC0stbQun6q5OJDlHS+yok61ZNS1Hrnry9nkqVV37wlhRUEZtliGTCTQiBY/AMi0CPhJ+tUifjUJxPsqbqB3IT2AjnNpJHnlpL81LQsxPx+9kfvx0i5du9ZBDKg7fbvrSlufCJz+1//I4oy9ga5Ed+iqiAN2wEJaHKQPGyHv5qms2Nr5+XNw5TtAwm9xAQbB84dgnB5KYjso60mT9gwCgiqcBl9u4t0RKxKQcT4Lfx6MUxznnR2V+J18DpYyhHfq7xMFy4TqpTxdgMsCdGJnAzoPPfyjnkhQEOwnPhYh5I5NUc3mNxhMnXxO6UJmmm7sugVhX2rKCxegnCU3M7IRq9Otl1zWvzRbVs5e6xTf65RgQqlWL0v3FZA11pYYQz9/itg66iGhMVL9i5J1iZKC8D7ZQKjaVvEuXqNsUPI4LAZmkS2lDBHd1rEfKl/MqRPARB35699VzNN5dqdNpzmbUxye8gVw2i/AQ4Hwe4jU/g2eyD5G4HwbxBiWGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(451199015)(36756003)(4326008)(66556008)(6666004)(66476007)(66946007)(5660300002)(41300700001)(83380400001)(26005)(8936002)(6512007)(186003)(478600001)(6486002)(966005)(6506007)(53546011)(8676002)(7416002)(6916009)(316002)(2616005)(31696002)(2906002)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anpLVWVYeXZLcXZlcGZ1ZjlQeW5hQW5BdUpWb2hpWnA1ZVNra212VHdxUUZq?=
 =?utf-8?B?cjZaeldKeElncGFSQWJRNXJFZXQ4d2RXYURISWpseFl0dmp0UlNnazNlQUxv?=
 =?utf-8?B?Wkh3dGx0VlQyRmNKaVU5WVhhNFc5R05EOWdYMnZSRVV1K2RPQjNXdGtZRmVp?=
 =?utf-8?B?SHdTZW82dXFHTnZkd2lKSmNPdGg2bEhESXlQeVBzTHZUczBHQlpzWEdmUHln?=
 =?utf-8?B?VTNQZ0VmcVBsSVdGOEVqdjVaem5sMlhQYnlCdXdsS00yN3ZsdWNNQ1FUZWRh?=
 =?utf-8?B?Z1grYUhvbGE0OUpXdlVjVmFCUVJ0bGhlL0h4alBEcWsrZXR1SVBXeVUwZ1dI?=
 =?utf-8?B?a0k2dWdRcFE3bkI2VjV2UFltcm14QTcwSHdtZENJcHd0M000a2RXeUJyRTN2?=
 =?utf-8?B?VTZuUXlNYnArQVJ1aVYrTEhzUVlXR3g5WmJLZWlMaEk5VHF0b3E0ZHJnZWg0?=
 =?utf-8?B?R2w1TktqNURIZy9sSXJKWC9DcWducmtEdnhsVGkwajBXdDdhdVVmODlQOGwy?=
 =?utf-8?B?MXdsQ2FtNkFQVnUyelFjRGNYV1RvcHZTdld5YXJFY3pMTDl3M2R4NjlXWjNp?=
 =?utf-8?B?eXFKVVpFL2x4TTNQdnNOK0FqNWdjVU1CeVFXTXBBM1d0R3FmaFY4RUxKcDE1?=
 =?utf-8?B?TXQxZ3pEeFFpdUNzV2ZleWM5RmpseGtFdms3c0xzTWRHR1IxcSszSkE0dkpN?=
 =?utf-8?B?WG5vMDN4Q3gvZE5hNTFFbVdya3d5ajBjNjZCeFlGZnJaRldiN2pjUzNCQzEx?=
 =?utf-8?B?TEViSmEyQWFVSGhub1QzbHVISTd0ejdZeEszM0YvWE9zTzFFVWJhTk8vb2ZS?=
 =?utf-8?B?bS9WT253eUhZVDJpT2ttQzRZQndFbER6Qk1yV0NrMXA0YTlWeHRvNHFPOEMx?=
 =?utf-8?B?SGM3dERkZWJySk1GNUxZa3ZUUnBtdEJFaGwyaEV4aEdsM0dWaVU4VXkvbmtD?=
 =?utf-8?B?Q3g5aEd5ckNucnlMRkcyQi9oczFEbS9YQURBU3pRdnNPR1FvNWhDcmVzSWFK?=
 =?utf-8?B?OFhKeVlSUmhlOTB0NDJzanYvNFY1K2dBMHNEVWFYa1FtSDhzcUhaelpEckJl?=
 =?utf-8?B?dEJTYWZoaFhaYnhJMkNpcUllc2RydDAycnRaU3RiWmVmTU8reTBxYjBMdkh6?=
 =?utf-8?B?bVVRQlA2anVjOERnSU9PZUxseDY5QjNhNE43SU1aSk9BaDFKaDV3WElxT1RT?=
 =?utf-8?B?cE44KzQzeEZ5dmU1L0E1RXR6M3VTMm5udDdjdDdtMkFyZzFnbDJmVnFXTTZM?=
 =?utf-8?B?UWJwZENHc010USs4ZDdzaEhRUjFRU3RpYS8zRjcxL2tJamVkeE1HY1hHK1BN?=
 =?utf-8?B?ZSs2TXl4ek1wWHU0MUkrWlQyWk9UYUI2L1JWNUNJNG5KN2d5OWhGc2tyTUtR?=
 =?utf-8?B?eTQ5Z1VFUVRPNUNvQmpsdGVEREMydStWT0xEUVE4enFvZUdJc2w4YmM0VTUz?=
 =?utf-8?B?VnRUS0s4aXNiTXVXZ0RNV3ZNdXRvV3BuYWk0Y3N0U3N1bE14K01kdG9GbDZS?=
 =?utf-8?B?TEcwdDlMckZSOE02S2dtWVM0c2pqZ09DRkVidlFSV0xwWHZLdkNydUxkeXM4?=
 =?utf-8?B?Q2lKQTFXQzF4NHlpZ3MyMWtjR0s3V0QwVzNQWXVaaU1CbjhCY2p2WEFMREFT?=
 =?utf-8?B?YkZ5SkNpdzAxZmRGOU12WklMLzM1L2JOd0RaZFZITTNGMExmSGJpZTRHSFlt?=
 =?utf-8?B?Q1F4elAzY3FNRkpPakg4ekVYWHpzYmkyek1xbWgvNHZtbjZXL3d1eDVqb1lF?=
 =?utf-8?B?ajNSUFRFT01kUTJZbU5sRTBRa0NURVJndUdHK3JBVnNoa0NuNFdRblRIRk5i?=
 =?utf-8?B?TmlJVUZ4blZ2Z0ZHRHM0aGZsaDdPOW5YWHFrbTBQaHhtSUMrM3d3a1I2ZHlE?=
 =?utf-8?B?bmliZ2V4em5UYWpYWmVNWU1GT3k0aVBXcU9DajdCVGFkSFNHVjlHZE9JN0hv?=
 =?utf-8?B?MGIwZWVQUHlJZ2hobDJOZWFVMUVwT01lL2VCVi9HSm95cE5Hb3RTdWUwbUxz?=
 =?utf-8?B?RW9HWWRkNTRVOFVMUjMwNnRsUkV3aTJ1V2ZkcWhscmRveEdrLzhZdTVwMkZY?=
 =?utf-8?B?OVpJRDJNWDE5Z1ptV1p0TlZ5Uk5wdzIvb29hRkhyTGZORGFGbUwxamR1Tk5J?=
 =?utf-8?Q?l0X9nKNjUGL0jQxcT/lEkeXOx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c5eebdf-429a-4833-b79a-08daf79b0aa1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 08:24:10.0626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JcJVlXBbFgatd+NOLRIESi3BxZA0gvutbhIf3OaI6kNTc+nMktpQuIkGUJaeMN/YE8R0TUMASpCmfP+nZZlWuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5595
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/01/23 17:23, Zhi Wang wrote:
> On Thu, 12 Jan 2023 14:11:39 +0530
> Nikunj A Dadhania <nikunj@amd.com> wrote:
> 

>> diff --git a/Documentation/x86/amd-memory-encryption.rst
>> b/Documentation/x86/amd-memory-encryption.rst index
>> a1940ebe7be5..b3adc39d7735 100644 ---
>> a/Documentation/x86/amd-memory-encryption.rst +++
>> b/Documentation/x86/amd-memory-encryption.rst @@ -95,3 +95,39 @@ by
>> supplying mem_encrypt=on on the kernel command line.  However, if BIOS
>> does not enable SME, then Linux will not be able to activate memory
>> encryption, even if configured to do so by default or the mem_encrypt=on
>> command line parameter is specified. +
>> +Secure Nested Paging (SNP)
>> +==========================
>> +
>> +SEV-SNP introduces new features (SEV_FEATURES[1:63]) which can be
>> enabled +by the hypervisor for security enhancements. Some of these
>> features need +guest side implementation to function correctly. The
>> below table lists the +expected guest behavior with various possible
>> scenarios of guest/hypervisor +SNP feature support.
>> +

> "guest needs implementation" seems a little bit confusing. I suppose it 
> means the feature is mandatory for the guest. 

That is not correct. None of these features are mandatory for the guest.
The hypervisor can enable this feature without the knowledge of guest 
kernel support. So there should be a mechanism in the guest to detect this
and fail the boot if needed.

> If so, on the second row 
> guest can boot without it. Some explanation? 

In the first and second row, HV has not enabled the feature, so the 
guest should boot fine irrespective of "Guest needs implementation".

>> +|      No         |      No       |      No       |     Boot         |

>> +|      No         |      Yes      |      No       |     Boot         |


>> ++-----------------+---------------+---------------+------------------+
>> +| Feature Enabled | Guest needs   | Guest has     | Guest boot       |
>> +| by the HV       | implementation| implementation| behaviour        |
>> ++=================+===============+===============+==================+>> +|      No         |      No       |      No       |     Boot         |
>> +|                 |               |               |                  |
>> ++-----------------+---------------+---------------+------------------+
>> +|      No         |      Yes      |      No       |     Boot         |
>> +|                 |               |               |                  |
>> ++-----------------+---------------+---------------+------------------+
>> +|      No         |      Yes      |      Yes      |     Boot         |
>> +|                 |               |               |                  |
>> ++-----------------+---------------+---------------+------------------+
>> +|      Yes        |      No       |      No       | Boot with        |
>> +|                 |               |               | feature enabled  |
>> ++-----------------+---------------+---------------+------------------+
>> +|      Yes        |      Yes      |      No       | Graceful boot    |
>> +|                 |               |               | failure          |
>> ++-----------------+---------------+---------------+------------------+
>> +|      Yes        |      Yes      |      Yes      | Boot with        |
>> +|                 |               |               | feature enabled  |
>> ++-----------------+---------------+---------------+------------------+
>> +
>> +More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
>> +
>> +[1] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
> 
> Probably update the link here as well.

Sure.

>> diff --git a/arch/x86/include/uapi/asm/svm.h
>> b/arch/x86/include/uapi/asm/svm.h index f69c168391aa..a04fe07eb9a8 100644
>> --- a/arch/x86/include/uapi/asm/svm.h
>> +++ b/arch/x86/include/uapi/asm/svm.h
>> @@ -116,6 +116,12 @@
>>  #define SVM_VMGEXIT_AP_CREATE			1
>>  #define SVM_VMGEXIT_AP_DESTROY			2
>>  #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
>> +#define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
>> +#define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
>> +	/* SW_EXITINFO1[3:0] */					\
>> +	(((((u64)reason_set) &  0xf)) |				\
>                                ^
> One extra space before 0xf should be removed.

Sure.

Thanks for the review.

Nikunj

