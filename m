Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBA366B6EB
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 06:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbjAPFik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 00:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbjAPFih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 00:38:37 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E538A40;
        Sun, 15 Jan 2023 21:38:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfvEAfrkUcYm02aoBQR0MZvSj1xFtBGf4k5S3/bzCkiRLVt16DZDGjf5h4nO+uPFY7sSyXco6jkHcBxMa8NmzyZHhJfIAtCq2ApzvgIanFy5L6O42Vz2symK0BtkxftYgxbuM8iWzYaYfqnokEAwMgGKbe98LC5eK81w4EQZCw/URewM4yr+h64Cn5m2uwKaYB/CqGSpMkJnU5c6XGj7963vn9bm5MxKHt/U1Ym01Vd2KeJWs0vXy2YpVRkjMIF27ztOK2IXRMBI7Gz3DvBSKcc6WXwdHlYpz/HCMpjjLVT7yYnsXPm2ITbTxguFElCdP1jeqz5SMMqtvA2+D6krWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BEbRuM2xdaEnj0RtKThI2IEO3HwJjbltHB0zGIN8bio=;
 b=R+GYX6wXFf2rwMPVsSWvRclQHorEExYDRi9yAdHwnH4s0c4NZd1A+ZWQyzFnx7moC4CzKWsFelrTGhWv0io+Qi6O3NcQO6kFG/WhxIoonTIx8pXpedeqTgvtBmQGXGXbi3agPBGffS3SNh19WKRhH6hEn5nYuYT+ffvXdnu1QNWAyhsdtlj/UKwLWg8Zxy9CkdqbGvd6Cc/UFOHaRGiOBJOkah5+PukelaXFhluc1B6vooB9t8YeBUqGkqWU6/JWOuAmuIEa1Pq1QgXlckDiKjiqWM60/kada5cUv7mjysQ/uKVxqKkhjqOJT0euz33kikrRZzXqQoZw9UCL3ZNhow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BEbRuM2xdaEnj0RtKThI2IEO3HwJjbltHB0zGIN8bio=;
 b=JTxTVrNkGg2HZ76GyhdOGMJ+65h2qh4Usaf4z9rMYqgL7sHmAS98TPyWHAzYeb+JL8dy5uhdWVZWflGsDWuaS9KG3DMS3ErtNiOsdUe6k5OYmMYG0/Lnpb+RRtX3dqRRxl+fRKtLhCEr0IvBfs0BBwxtKdaQujdnVn5c73v1Fgs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH0PR12MB5605.namprd12.prod.outlook.com (2603:10b6:510:129::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.22; Mon, 16 Jan
 2023 05:38:33 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700%6]) with mapi id 15.20.5986.018; Mon, 16 Jan 2023
 05:38:33 +0000
Message-ID: <f9044d0a-b219-60a8-bb40-91f8293ae2f9@amd.com>
Date:   Mon, 16 Jan 2023 11:08:16 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5] x86/sev: Add SEV-SNP guest feature negotiation support
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, thomas.lendacky@amd.com, michael.roth@amd.com,
        David Rientjes <rientjes@google.com>, stable@kernel.org
References: <20230112084139.12615-1-nikunj@amd.com>
 <20230113135326.00006f06@gmail.com>
Content-Language: en-US
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20230113135326.00006f06@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0150.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::20) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH0PR12MB5605:EE_
X-MS-Office365-Filtering-Correlation-Id: b8adafc0-99c2-4fbe-304f-08daf783e7f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cftrSH1vnbRqCzMt7O0PQDbPO4w5Vj7BDBhaykBiLlacidAhJhvySkoj7uO5roBE281Ap2G2zb0MZdwulKybJtw/MojtwGsB4/vSaMqo7HHNkR4G5zGTeKRzavT4BaBWE9rT7u9vUF6fw/2dWMiGQbVIT8x3oxQ0QZtGjUqgsji0d9bh+6vLMzV9AzlndVCkyt8uWwWg5vIt+PehW812WuEV+RgLHhN7tg5bvlu7mIYXny4W4cRufPujQ9oz/KaGcPrxfygFR0vSiuajbs6hPyNYpcmthmqs4FQwciwLB4WcvUuh5L30X1LZeg4TT2CdONxdW61g6QdborQ7bu8/C2ioL8y1i5DB/Hq8KoMOOC337CPO5EBnFvaWFPccgClMDQF/K6pTb3qmLEy/+pyHWxEptP8Y7AMTPO3hjufhUxhwnVuERUQmq/w4VKN+af8ktA2sM9QKXEhOT4tkmQC/8uwgPSKUlbf2MX9G3WmYx22lqOpvXGY8ONCYSBWOwLcRQ3sI3TJYYtcExBj0m8aoyXBXYOTsNkk9m6ZNAQ0pSeljoDbL3hBtUtHMWVpYLQRYqyLFukIQCdQ4KkJAUFbWi1EiYMM1/8OJuWBSMHJpiXwd3Vwq3Gts4VQhV10Q2XybgaYD68wb9tk6yJwDPSocH+nC3/R7CaTXp1IKSYrfnvvF1KGNzKbDwY6KT0npTWupSaqwwr4sfm1L8cwF0p6ODJCv6T4oA3jbcXBSoKTdrqhdO7B6UGnakI47zguc8cm1f52a2R3kXOD8NbfUVCEDMLIK6MciZ0/SWh4VJgQ4O4Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(451199015)(6666004)(478600001)(966005)(8676002)(6916009)(36756003)(4326008)(66476007)(66556008)(66946007)(41300700001)(316002)(6486002)(38100700002)(53546011)(2616005)(6506007)(55236004)(6512007)(31696002)(26005)(5660300002)(186003)(7416002)(31686004)(83380400001)(2906002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0l1alMwRzVIa0thK2xDeG9CODdnZTZlVEY5dFVNRjR6S3daYkRIWjJhYmNt?=
 =?utf-8?B?RTJsZFlCRDhFcG9VQjBJTU5lQ0t5NVFjYlkyN0RYb3F6aDR5VngxNlZ5Tk5q?=
 =?utf-8?B?MUZWTXVXdnpDZFZ1dmNQcUlRY3JFd3dkMmszdzBPZUgwUWVIa21YclBaL25B?=
 =?utf-8?B?MXgxOEg5QnZEZ013QVdybXpNOHNDejF5SGJhTkMxOWlBSXY4VmE1OUFzYmFn?=
 =?utf-8?B?Q2VlQlhyWXRzbGpHUEFPcU8rczVTM2NPb0V5eHlOMktadjloZkNoTXhSVU82?=
 =?utf-8?B?dUU1ZGNFVXNGQytGSzhoS0NSZFNyL0x0UTNWa3d3RWZjY2pHMlNwc3hQNCtU?=
 =?utf-8?B?czFaMEl5cGowQlUwV0tiMHJuZjV3OEttVTRCN2twM2k0MGJnRXpNd0ZjZmxJ?=
 =?utf-8?B?akZ5cDdTTllhQ2tScU1hbkkvL2lTdTNCZ2dTa0x6cjQ0U0xCaE44Yk5SS0JW?=
 =?utf-8?B?NGNCcWNSdHlnb0NRMGFGYzd0UUxxYWVScEpJeEtlLzFWSHZGNkd3YkZhVE1Q?=
 =?utf-8?B?T3RtUHI3dUFKaHhkR2N1TkVrY0lmL3VubUFaOUxBbW5kekNmajVXOElvR0NW?=
 =?utf-8?B?OXVoSTJuaWZBaDR3SzNjZDJudStBNk1TeTF6cVdzOFVFTW5rdTUxbFc5cXAv?=
 =?utf-8?B?eituWFEwMWxBcVpiUm1oTkNFSzFCeTRLU3JNSjN2dWtraEd6OU5GMXFURWdC?=
 =?utf-8?B?QXhtNEl0VTQzZVh5ZVNYRGNwcUlPTlppbjV5Z2xhbXlScmZQdTIwRHdCTnpP?=
 =?utf-8?B?K01IdzdvdzRFRnpNd2o2SUFhM0JmZkZlblAxSzROUko5K0REY1VES2tqTFgz?=
 =?utf-8?B?ZmhjNmxJT0VFdHVxZWRMWjZlNmlaYi82cXlMZlR3L3h2ZjFSL2VmdmZnNy8y?=
 =?utf-8?B?U1B0bTZtY1kxZjI4YUVVUXh1U2xrMGpzSkwvdExqR2VnaTV4cVkzZ0lzSVZF?=
 =?utf-8?B?N3dzTTB1ckFBUmVWbmk4WFdoZkIvaVoxeFBjMy9JVEx5OTM2R1ZrVWZibjQ1?=
 =?utf-8?B?UXdRbnVrang4VjJFNXZGSjZHUFFHaWhMbTl3NFZodlNZS3IyYmNFb3F5NGwy?=
 =?utf-8?B?VkFONlY1Q1dRWlgzNW1LaW4vemlqb2s1WUZzZGFCMktnNmJYMkZpQUJTeXJa?=
 =?utf-8?B?N0NPbmFPUUx3UGRMODJ3bzVVaTRVb3NFYllFSWM0ODhaZWZ1TkFvQzFYZEd0?=
 =?utf-8?B?WkM5SmZTNzV2OEtIaDVjQ3F1T1VPUCtPUHdYRDFGdzJjRzhDUCsxSVdWejRv?=
 =?utf-8?B?eVVXRTRTZ002SkVJaHVvZWZDMEUrdkVaNmNnMmZLdmV5RWFMMUd4UGk4RVRE?=
 =?utf-8?B?bEFyV3B3UHE1QWJtVnRROHhKb21sekh5Q2ZrRmVyUnZiSEF1TXpaa3Z0RHM2?=
 =?utf-8?B?MXF1bTAyMVl1cHhEY2VDQzdTbUk3c0swcWltS2phZVpkc3dlZmJoT2xxZUR3?=
 =?utf-8?B?OFRINGJYRXFNbzNOSEJRd0JKY3VpMUVtOTIzWlpDSlIxT3pMRlNLcTQyR25J?=
 =?utf-8?B?L3V0REhKYTJWZXZLQWhKOWFTVTBxcGFObkJRd3pOVHJBdEo1bWhGUW4yOVVT?=
 =?utf-8?B?blhCRHdnKzVzeENQVXJVTlgvUUV6VEZGeGgwU2V2RmRLaGNPMFYzdStyTXAr?=
 =?utf-8?B?RUNVcHJCQ0ZxRm5KTVdlZ1NPWkNiVFV1UEZpZGFRTUpkMWpCS3k3U1grSjVV?=
 =?utf-8?B?dDhXNlRsWXBpYlZKVjZVa2VvYnI2bmZ4Z2o4b1JqeE9yTG5zSElva1lTVFFN?=
 =?utf-8?B?ak9tMEJYREowWnB6amRZb0RMVWNWc1I0TTM1VXRBVExIVmtnR2xKcTVwS25N?=
 =?utf-8?B?OVdSZHRUamVMbytkeGpZLzdrRWl3blpicHdzTm1WaUZnc3BVbmQ5SDlLczNU?=
 =?utf-8?B?MjZiWjhmdm9lTkkwVWFZSkJHb0RyczlZeTUxWlJ5d0toa1hQQk1zNllDL2tV?=
 =?utf-8?B?TVA2ZlNrbXBUMEczb2k0VGt1aW80RllzV1JNKzFsRnBMb3cyWGFuTEFNUUpP?=
 =?utf-8?B?NHViL2c3dXd4N2pzUFNFS2dBTTFLWjJPbmlXNVJBMEY1NHZxUzIvd0x0MTlh?=
 =?utf-8?B?K0ppSzdtMG1wTjNiWC85cnY0U2tYV25uWDRKYk8yS2ZMbngwK0tiSy8vUTZP?=
 =?utf-8?Q?+8cjtxedVydCb9YVMDkPFiOnB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8adafc0-99c2-4fbe-304f-08daf783e7f3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 05:38:33.4828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zQFa82WNnROBxR45hRsqGJQEm66T8jpA1vv+94/hRb9Kp7O9sTrGy6g3Awwlrr+OeSvISTTUDZjRU1cr0LRMag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5605
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
>> The hypervisor can enable various new features (SEV_FEATURES[1:63])
>> and start the SNP guest. Some of these features need guest side
>> implementation. If any of these features are enabled without guest
>> side implementation, the behavior of the SNP guest will be undefined.
>> The SNP guest boot may fail in a non-obvious way making it difficult
>> to debug.
>>
>> Instead of allowing the guest to continue and have it fail randomly
>> later, detect this early and fail gracefully.
>>
>> SEV_STATUS MSR indicates features which the hypervisor has enabled.
>> While booting, SNP guests should ascertain that all the enabled
>> features have guest side implementation. In case any feature is not
>> implemented in the guest, the guest terminates booting with GHCB
>> protocol Non-Automatic Exit(NAE) termination request event[1]. Populate
>> SW_EXITINFO2 with mask of unsupported features that the hypervisor
>> can easily report to the user.
>>
>> More details in AMD64 APM[2] Vol 2: 15.34.10 SEV_STATUS MSR
>>
>> [1] https://developer.amd.com/wp-content/resources/56421.pdf
>>     4.1.13 Termination Request
>>
>> [2] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
>>
> 
> The link of [2] is broken. Better update it.

That is strange, I will fix that.

>> +
>> +void snp_check_features(void)
>> +{
>> +	u64 unsupported_features;
>> +
>> +	if (!(sev_status & MSR_AMD64_SEV_SNP_ENABLED))
>> +		return;
>> +
>> +	/*
>> +	 * Terminate the boot if hypervisor has enabled any feature
>> +	 * lacking guest side implementation.
>> +	 */
>> +	unsupported_features = sev_status & SNP_FEATURES_IMPL_REQ &
>> ~SNP_FEATURES_PRESENT;
>> +	if (unsupported_features) {
>> +		if (sev_es_get_ghcb_version() < 2 ||
>> +		    (!boot_ghcb && !early_setup_ghcb()))
>> +			sev_es_terminate(SEV_TERM_SET_GEN,
>> GHCB_SNP_UNSUPPORTED); +
> 
> ===
>> +		u64 exit_info_1 =
>> SVM_VMGEXIT_TERM_REASON(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED); +
>> +		vc_ghcb_invalidate(boot_ghcb);
>> +		ghcb_set_sw_exit_code(boot_ghcb,
>> SVM_VMGEXIT_TERM_REQUEST);
>> +		ghcb_set_sw_exit_info_1(boot_ghcb, exit_info_1);
>> +		ghcb_set_sw_exit_info_2(boot_ghcb,
>> unsupported_features); +
>> +		sev_es_wr_ghcb_msr(__pa(boot_ghcb));
>> +		VMGEXIT();
>> +
>> +		while (true)
>> +			asm volatile("hlt\n" : : : "memory");
> ===
> 
> This seems another approach to terminate the guest which can bring extra
> reason info compared to sev_es_terminate(). It would be better to wrap
> the above snippet into a function and call it here.

Right, I will add it as part of the new function in my next revision:

static void __noreturn sev_es_ghcb_terminate(struct ghcb *ghcb, u64 exit_info_1, u64 exit_info_2)

Regards
Nikunj

