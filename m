Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55EA65F71D
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 23:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236296AbjAEWye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 17:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235715AbjAEWyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 17:54:33 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C007C5C1EB;
        Thu,  5 Jan 2023 14:54:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1XxTRCFLkD7+KwMWHpf/vTU1Fx1U42maPaNv6jsmX4eIAWQuVCvqlKDRJFPdVg96PHIQyitk4BCiapejVrOABQXysRU9oMTeMQjAti1LrBmKuSJ8wVxe2yN7bPZQt/U/oBFxtPo4XT4Z6nmVXO99mu8HgB+H5Jhgt7kVvUYLVLhG3lvMPcBn/0reHDELLrmpAhdZ/VUkf7Z5J6422Q5s3kh42L5tohE5pXcsawyxlTIIBsMte/IehufoIHUevNJBfSHHotLfd9RqhmvYhfNRv6Z+IeI6pHaukImaUEFJthDIDGNixvSMtV9mkkHitE3cMxI/sQjNSf/i/dXKwelig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ojJjWMGcdVIAkGAVcfY868civOChs1q1LlXQOOBr88=;
 b=D5YzM6ESSiE6lGurNyfk5ZhwmJ6bYSGIkHQ5PenGVDJMiQUPvtfu+aWzQ75rXFY/gQ8wYYrrCOU6UqVj6epDX18Z8/tFEw+amnHSEvrPF7TQ/eeG0tLPq8uE1fSYoJ1Ldb2ou/9bxxLv4f7D5CXOjOSFJ3MX8LlG2H23YIGp7BpCR9At6U202tQl1RsvZtTFkGkndmuCvc5Dd+zF90wGMOQPvMIsGjXlaVGgP7hBWis6OfbYf2z3hfafX0gua67n6WqH/jhpspkYi1nTxC7UffMGWB5VMSnjyIuMVJBs8zCaSll6pTbxQX5bvPWK8lpXzB9WxCKcMcusQaYDzjZ7WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ojJjWMGcdVIAkGAVcfY868civOChs1q1LlXQOOBr88=;
 b=36f+BWP4Qdqpvi+10JQ/B1wbI1hO+wAF9xtIdtP2negmlQJQikYxeaprx6mJ6toavUVsnrZbH2uC2TuXihzBE/pMNczE9ahx9988Fk+NdynYB6n9AunHqEphJUaFaDMwUcoVIUhxOigF773wNuYu10ma73WB8l/3sU/EmWd5XfQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by PH8PR12MB7253.namprd12.prod.outlook.com (2603:10b6:510:226::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 22:54:29 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 22:54:29 +0000
Message-ID: <897b503e-48d1-bc4b-1e68-42792d589ddb@amd.com>
Date:   Thu, 5 Jan 2023 16:54:23 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 25/64] crypto: ccp: Add support to initialize the
 AMD-SP for SEV-SNP
Content-Language: en-US
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
        Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-26-michael.roth@amd.com> <Y7VtOQa5Hd0oMdfh@kernel.org>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Y7VtOQa5Hd0oMdfh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR17CA0016.namprd17.prod.outlook.com
 (2603:10b6:610:53::26) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|PH8PR12MB7253:EE_
X-MS-Office365-Filtering-Correlation-Id: dae056b2-858a-4b7a-4074-08daef6fcd4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fWEho8sFeBy5bEyzL4mYiShKKLK+jgj2+AZKkTDv3CCQSar9/pLy5rwfZcZ7T42hjmrqO/YVJxDAa/FpRWE3gecvGyqqfDSZeM6N4FEohjL6ud12K8kdUnBhqjeWD6a+VuZey9+xU7wBi3yclaOUF8Kc+kAFBK6tEOJxbcVd2twm9ejUhvZvZB8CWKBLph926MAzNVlSuEzeU1YftVmc13Efiw984y8mfAzZdgZW+4+w5OyOV8H7eUYKpz1BcKpz5PtIz+VOqnjmKKUVFbI+C7WG0ZFgdtMhw0317lFNniASAxzgIwJuAcO3DjU5mA5/IX9kAszZbczVIr1qBGCrMG1FwIBpXxPDwao3Gsi39uumI5WOAzL9FuDsNO2ilb5D9y59qJtW0ycv5Dos6sbHUkJJuUuSyr5GwBM1FiOw6DmOJ+gKe7OVFVtUK2MBxXl9qDvDm3eyh1QSyQklg6u7eqweFuL/VOKPl3GOxex1KRBcOfEOJxBmCPINyhypzg4pBJ2veURfqZWjvRVEUeVsXfHlzClJuUT8jh+T/kygi/3mjTj+b0YwbIxXbpm2SPqgAn8BfkPgW/wId93E6O58tWHD1ILiCSvrs7qRRAseE5SQ3FyQ2FQ2HlbvaiwH7yS7HN3s25L0b6yCiWfo7+LMQMqoZOoeF00w29QxyMkl3w0sp/kW82O+87EJ7nN34D7GLAOeWR9OnVm5AAstAQ2Y4tIo3YPALOjeeu1hGL1ev4E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(376002)(396003)(366004)(451199015)(6512007)(5660300002)(186003)(31686004)(26005)(6666004)(110136005)(2616005)(66476007)(66946007)(66556008)(316002)(6486002)(478600001)(8936002)(7406005)(41300700001)(7416002)(83380400001)(2906002)(4326008)(8676002)(38100700002)(86362001)(31696002)(6636002)(6506007)(53546011)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1ErRTBBSGpxSE5NU2tudlpjaW9yQW4rOHRYVmlKekNCLzBIeDZJTjNUbHJr?=
 =?utf-8?B?ek9BaXoyckZZNjFITy9XOXRZcGIvUmdxNy9Xb1ZZbmx3dXQwSXdwbU9WS3Z1?=
 =?utf-8?B?NHRaekMwWkRxSUFPWGw2cXNvZGdhQ0Y2YzlKUjZHeVRyK00zdi8zcnRaQ0ZT?=
 =?utf-8?B?QjB3anZvR21VcEdpbHZZdUJFc0p6Z0dLTjRGeW9uaGJiUytTRjZQbXFUU1pp?=
 =?utf-8?B?dkI0Sk5WRS82d2daSk9ZVHZISkpJR1F1WVlxZ01WcVpJU0lSU1NDMVZzZHd1?=
 =?utf-8?B?STNUc0ozOFBFTnlHREVmdGhybm9pRit4ZmdrU1o4ckVFV3NiRDNhdWFBaHdX?=
 =?utf-8?B?L3dTU0ljRzZ0dC9ENExyNEZwWWgzK2lvNHpLNjZNTWJoODZFb0hhTUJ3dGo0?=
 =?utf-8?B?WE52MFZnN1pkeDV6M2JNblk5N3R1S05RWlJ6MDU3TFJmd0hJRytQVkpiZ1Mr?=
 =?utf-8?B?Zi9MZE1QVVdmY0JsdFRqQTlzNkZkK29PaEcxQlZtandhL1RuT0QyTGFUY3BQ?=
 =?utf-8?B?Z29oUzYrQ1dqYSs1TU5kWXI3UmZtSE1ZOWg4dmpjWUtQWlFwaWVxNHZIWnlw?=
 =?utf-8?B?Q2plS2lYU1IwUTlPMUVkTlg5ZmV6OXhTTXNGM0lBOXg2dWtTbHF0Vlk3ZTAv?=
 =?utf-8?B?cnZibTV6SG1uM05pUVNCaFlCeEQySlJpbGNOUkNuRUIyWnliMWVqU3RNOXli?=
 =?utf-8?B?K0ZoclRlM21XcWJ3R0FYY2EzRDQvVE9rd3VXeXBwWWhjVFpEMXFVdXhwckZx?=
 =?utf-8?B?QVBNWTRMaFN2UzI0VmtYaXZkRGRwOHJXcUtTRENKdWx5ZlFiRFFGc1NLR3Vo?=
 =?utf-8?B?SG9mMmZqK091NTlqWHluWE4yNGhxVmEwTHBaSGExbGQ2bUNOL1NpTVZ3QTV5?=
 =?utf-8?B?TndORFplWVNBdTdXK0M2ajEzMFBEa2g2akV5dk9QUFdjeFNOSkN6TWNKUlpl?=
 =?utf-8?B?VXRObmFyNEJtTUtiUVAvMFdKUG95azZiUUViVHVlY2hKVE5BcmlXSVowQmxs?=
 =?utf-8?B?aGZ2bkR1Z1B2ek9DSnNCU1UwVGtSaHVCU1JHZ2pjYW04ci8rUGx6dURlOVZz?=
 =?utf-8?B?TXVNb2JkUTV1UEJnOGh0VUFSM1YwU3UyK3R6T3BLRWxacHFWL2NqTjMxV2Jj?=
 =?utf-8?B?QnlzaWZrUGJRZHM4aU1QK0Z2eDA3UWc0aEFSdmxHQjd4UUxrZjdEdEZZU0VO?=
 =?utf-8?B?Y3crQk83dG9GRjVKQkIwdFZVeGlYb05ISU5pelRjUy9VSUh4MHBHN2dCSHQ1?=
 =?utf-8?B?TndBOGdRREdYd0g1K2EzUEMrZUdSelZlNXVXbHRiNE5oOUhWdVd0TnBwQ216?=
 =?utf-8?B?cW14V0F6MWd5U0RTSEVSK2ZrWWxxQ1I0cTlMdjBqYU93TlRtbHR2NzVyNkRj?=
 =?utf-8?B?M2REcDRIRXlLeGNkbmpnU1VldnhEd3p3dUMraWgxWnlpZ1pQc3Z3R05DY0xw?=
 =?utf-8?B?cHNWNGZlVU5BZnRZdTJTTnZWZHdOS29QdTFpSHpUL01qYlBQUzNYVlc5aExw?=
 =?utf-8?B?ZUxYVEd3MW5UK1NXbjhQbVlrZjFvSEMxcVFmbjZZNHRTVktMQldDZmliRVYw?=
 =?utf-8?B?ZTRCWHR6SWEyWXVZOXcrblFnK2tOaXNoeDRPbEkxQkxlVTZ3dkVJOG9yL3pv?=
 =?utf-8?B?dkNvZWE5L2E1Zy9vMWhtWFIwTkkrb1U0MzFQcnZnZjd5ZDZjb3hYU2k0OFNy?=
 =?utf-8?B?NG44RzZkL1FIS0RiWHNZMzVTa2k2U1VLbUxaMVBUWlVSUjJ5NDc2b0JiL3R2?=
 =?utf-8?B?aGpHRmpFanUza3B2Y0xxZkxBeStkTEtQVW1jVmtOUTR2czNJbjVNcUZmbHJG?=
 =?utf-8?B?RkdtMldqRjcrYkNOK2RSL01QZW9Vamd1WC9oVzREM09HUDJPSHRzQmg4SGIx?=
 =?utf-8?B?dmlBQ2V0RjN2OE82QjAzZEd6UXVjWGJrZ1pvTE4yNmsxR08vV1lHWEp3VHZn?=
 =?utf-8?B?amJnYjRWWURNVzhWNCtxQWpPMXBta2FlUGpUWkNyc0ZqNUFpUWcyVy9lQURk?=
 =?utf-8?B?ZGMwSS9EWVVKbDBnb3NKNlptWElMK1JCaUl5dFEzcXhmcUNKdERNdkhOeUtV?=
 =?utf-8?B?WG1yT1JaTzhXbmRSWmJxOE8vdjRWUGc3TDluRlZ6OGtlb09UVzNuNnVmUzBE?=
 =?utf-8?Q?VMTcBKL+PBIJEtY2ugXW/qkBj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dae056b2-858a-4b7a-4074-08daef6fcd4e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 22:54:29.3243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fEBSIKXTn4gyL+L/W2gplR7LClAeJ2jAwYwi9NlFl4TAlb0GASR/W25BumY4YvA/NPC9oB13OiQN93ZDxUegtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7253
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Jarkko,

On 1/4/2023 6:12 AM, Jarkko Sakkinen wrote:
> On Wed, Dec 14, 2022 at 01:40:17PM -0600, Michael Roth wrote:
>> +	/*
>> +	 * If boot CPU supports SNP, then first attempt to initialize
>> +	 * the SNP firmware.
>> +	 */
>> +	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP)) {
>> +		if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
>> +			dev_err(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
>> +				SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
>> +		} else {
>> +			rc = sev_snp_init(&error, true);
>> +			if (rc) {
>> +				/*
>> +				 * Don't abort the probe if SNP INIT failed,
>> +				 * continue to initialize the legacy SEV firmware.
>> +				 */
>> +				dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
>> +			}
>> +		}
>> +	}
> 
> I think this is not right as there is a dep between sev init and this,
> and there is about a dozen of call sites already __sev_platform_init_locked().
> 

sev_init ?

As this is invoked during CCP module load/initialization, shouldn't this 
get invoked before any other call sites invoking 
__sev_platform_init_locked() ?

Thanks,
Ashish

> Instead there should be __sev_snp_init_locked() that would be called as
> part of __sev_platform_init_locked() flow.
> 
> Also TMR allocation should be moved inside __sev_platform_init_locked,
> given that it needs to be marked into RMP after SNP init.
> 
> BR, Jarkko
> 
