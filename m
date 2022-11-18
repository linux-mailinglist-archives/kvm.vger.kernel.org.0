Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10F062F5F7
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 14:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241742AbiKRN2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 08:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241704AbiKRN2a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 08:28:30 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2053.outbound.protection.outlook.com [40.107.102.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF9ABE2E;
        Fri, 18 Nov 2022 05:28:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QtTHNzznu7XvlbSwklRiHPqu1NT/oE5rd8hsIAL/AZvTaNhrVALz+DqI9mha1aPjvz11Mx6ItYcqAzxP2pBnwevm0KmqZNIMFal7wKiVKtCXW8h69n3lWv/sEy8rrTCdb1bxez3OHyLF5FY+NEsx37FFOEhFESd8EOq5FqiaUTUWTmz/riaMweQAscyoUWaJkOryJzJBSD7UkGBLjvwk9Z32NKUgQrC8jlImxVgA00lCyihz8v0hyHTdsoCTznW76CHKYRQSaIXO4TDJSeQpx1ZMRqNkotx/JdmoQqOmFxQ9qfP6L6hWV8k+3pmzq2vXFU/+NI0164FdcMJgGfKP0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Q2iehp8iCKu3iP+0veTXebywe6xCwKOqSJmnCwF07U=;
 b=FuV8/yXhlpGrAaQcbvFsMPC2s5pEMRmUSN4dJTmctVFg/fVcLjWPqG4oaD4fTk53nw1XtkC7PZ9YX3MzTEj7lJUpUvur/0rwv9durHkMCGeR0n/x3xsRZZ1EjrRlRapxNM2j/Rl5KI92HB//BAvQ3DsVZ7CN323lLTV6ZKUVZAHNIo3lpLUQmxBbfPbMeSszhLGKY9W212mvOX1QYql4LNuxXweBdOBiTEA+3/QVo8UD2x0KpYQDU+J5c+d9gR5VZJhXw/61syXdw0WQqVzdOLUvgQ29w/V9MATGjqcmWUWGQ8FSQksKANdkGKGiVBRuTk61EWDVy7Qk92ru2Wleyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Q2iehp8iCKu3iP+0veTXebywe6xCwKOqSJmnCwF07U=;
 b=RRVHdKixCZhPB1K08dNPgDQvcKxzxeFJHGZHADQ1lhluOC4JIp9KtgVrbJZblrAxHzKEN69njnEgvSyOJa1prPR53F5od/jlVZKjyE0XyjKd+Hq40vC4RyNU8cEl8qGBS4VTUGcBgHB+rmNkgLlIZ63nbVbeM7zrurbSjkdN3cM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 BL1PR12MB5730.namprd12.prod.outlook.com (2603:10b6:208:385::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.9; Fri, 18 Nov 2022 13:28:22 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::6481:82ef:ffb1:4d0a]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::6481:82ef:ffb1:4d0a%9]) with mapi id 15.20.5813.017; Fri, 18 Nov 2022
 13:28:22 +0000
Message-ID: <4ea6e1c3-fae5-a64a-9bd3-f9ea0821fc67@amd.com>
Date:   Fri, 18 Nov 2022 18:58:07 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH] x86/sev: Add SEV-SNP guest feature negotiation support
To:     Borislav Petkov <bp@alien8.de>
References: <20221117044433.244656-1-nikunj@amd.com>
 <Y3YP5FQ6OHzVFKbp@zn.tnic> <7e224da6-6b02-2972-1334-bc8e7894cdab@amd.com>
 <Y3YuxGO8Kycymxg3@zn.tnic>
X-Mozilla-News-Host: news://news://news://54.189.247.149
Content-Language: en-US
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, stable@kernel.org,
        "Rao, Bharata Bhasker" <bharata@amd.com>
In-Reply-To: <Y3YuxGO8Kycymxg3@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0026.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:b8::14) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|BL1PR12MB5730:EE_
X-MS-Office365-Filtering-Correlation-Id: e77e0f74-ec06-40bc-031b-08dac968c276
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KhENwEacb4pt5W1tb8TWwOQxx3yvHNpKmgWsxI1iR4NCq6YeI53hCCt5ibX8a+5e8pvv0Fsv0/lOwPr/WORraw/SGgjztWZyJE73TgoUtkHTvFwbk6SabeNcUC/6UAksSRacD6ihjhHWnT5OosojNH/TjL+f74dfYta41U/EiIZAd855sdprz1X9n0T95QqXjoMH7PpveDxBWsrQokPCe/3RGZ5u1LSK4IUreswVDTbetchO1AqCqiUWxcLYO7VQHjKMdXCLBfZzAfA+SVoGeDGbrQ+kgz4AS8N3lRsFgdFnVZZtBjYMPdiEoJJnPHJIUzHRAtf7lr/sSBF+VJSqUkh5PV8aBPfvY2xQvYG1mFGu8eBkvMVch9zhAu+Bkim12aBP/aeuTnRgd0MgqcOx08OMlPC4IeG/j/i3NmwNU6wt+mjzX5Ei4iCkOgfRCcQMURbIdMvreCQZ5q7jekxDw5zmNeEpoteXIECwsgR9nmvO+jhvNxr3CM7d5PUaBK5BM9rAc2/L3KsNwO9NEWRFZG5oQudGEkqHsVrdP7AUc+MS3yBKncxve1moIfDkAVQ3ClJW+lSo+8ngluhM3I17zsjQRDh/RDA8TrBWurjvJjFAUg5FsIaLCYIt9Sk0Nqfva5E17/L4gQHmBN1tTuHKk3Ls1ohKgZMppeQtnvswF5ktYpd5o4mIJ+fCX8jaFlBWT/hiy8rKetzHLRXjxAke6/uU6EakHLHBxLvaLE+RYBA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(451199015)(31696002)(53546011)(55236004)(6666004)(6506007)(26005)(6512007)(478600001)(36756003)(6486002)(66899015)(31686004)(6916009)(316002)(186003)(2616005)(8676002)(66476007)(66556008)(66946007)(4326008)(41300700001)(38100700002)(8936002)(7416002)(5660300002)(2906002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?am9McHFWampzMFhDSW9ueXRqZkNxUlhqSUJBckEzMnZQanhVTXVMTWd4UVdo?=
 =?utf-8?B?Q21VQ1ZiZGpiMlJMempJaWRsbC96U1ZSQ1ZZb09SVE55NTRCZ2pmc21kOHRH?=
 =?utf-8?B?T0UzMlgrdjVKaWYrWHdSay9ubjlUYjN5YnFncDJYdDhNTjhYUGlFekFIWUVy?=
 =?utf-8?B?anljN2toTi9xYmsybGxRV3N5QTRLN2RnS2Q4VWRhNUdkTStSVjNkM0JHeStx?=
 =?utf-8?B?dUMyWHlNRGpUR2EzcUlWTG5UdHRlSmdJTTJFVjdaK2VMVGlXMEYvVU1BYVp3?=
 =?utf-8?B?d1BwcjBTT1k3T3ovbXAycHBsQ2ZpMFdFWVp1MHk5ZldOdTFaOENJMkxvRFhD?=
 =?utf-8?B?Wm4rdGxTcHBhUjQvTFRiY2xUTS9mT0UralB2ZHB0Sk5tWWRVMUlmeEdEYmxG?=
 =?utf-8?B?Lys1Zmt6UjdCU3hnR09oN1pqZWloaFhkTFVsd1ZRVzl4bHV6VU1wWE0rZDEw?=
 =?utf-8?B?a204SFVrWWpja3o1N1VJYlBybVJwOTlxQ3RneU5NQXBjSDNrU0hWMFNQTEVh?=
 =?utf-8?B?MXRvL0c3QVhyMnhOMlFqUkF6QlFiWWx1bVJkd3BqTHMzY0x6ZzhnUlJLbEMv?=
 =?utf-8?B?cHM4N3JMU2xvSzVuMUpQWEVGK3YwU2hBZ2dxZi9BRmp5ZlQram9Lb1V2dEZn?=
 =?utf-8?B?dHhDOWdXVWRhUjhYUjlUZzVidS9xZDcyNVRvV0hudlVBcmZqZ0ZOU3p0d2Vj?=
 =?utf-8?B?b1l6cFRVckY4bjh6b1lzaDZTUXpybGFaNWE0clgvdWM4RVpVMUU5R0FSbE5Q?=
 =?utf-8?B?VUp1L0g1NFlYY3VTZ2ZKdWlGUG9CU0F5ekswdU91dU54T2djSXZ0a29Qeldy?=
 =?utf-8?B?VFA2OFd1TlNPTzZYZ2hxWk8zMkdrMWlubjliOGpaWks5RFcrTHQ4YmZpVkR3?=
 =?utf-8?B?cEU5VlUyTFc0TVc1U1BlR3ltTURocGFLa1A3MUhFRCtxSkNhVkt0NWQ5eVB1?=
 =?utf-8?B?cnBqMmlNaDd3VnFuWTJDcW11VFpESGdlNmZIbWhtbitZVnIvMkNTZGNPOG9w?=
 =?utf-8?B?RWxpQnpoSTlaN25HeHhzcUFrbnQ2NWJseDcybFBtMFFkQzdLSkt6ZUsrVHk2?=
 =?utf-8?B?d05HRGlmRm4vY2crTUJYT2ZlZlVmYWRpaEFwR05uNElvcEoxbTVXcTd3QVNJ?=
 =?utf-8?B?MmJsL3lIK2NtSmdMWW9BRk44cjdidnB6cElYeTZjN3RKcTlvR2Q5akJnMVo4?=
 =?utf-8?B?NVJ1M1ZXM0c3OWpheWxTYlpBcnA1aUYvZmhuM0d4cmt1eVRvTXFtbFJzamJQ?=
 =?utf-8?B?QXhtTUFKanRReVF4b0pyUTBDRHU5S3lsaklGNDNrUzROT2RlaU5rSFBpSVZj?=
 =?utf-8?B?eHViRmRZb2tRalcrUXpBcFZUcEhzNWRHbDdQZ3ppbks4bnROV2VlZ2J1c3JZ?=
 =?utf-8?B?TGQzTzAyeWJWVUJOczE4RnhabEcweW9iQlFiTW9YQTIwTjJsSWI5a1loNkVX?=
 =?utf-8?B?YlBoZTBZOHlPTVlxMEk5YW01RTNmZkVGR0dMMzNkQ0RKdWhVMkxqVXBDVGVK?=
 =?utf-8?B?azFtdUZUYWYybW1YYjNydElKUEdSRlVYQzc2RUluQUNueHFkL2Jla0RyNUk3?=
 =?utf-8?B?WFg2c0NGZTY5Y05Odlo3NzBHdVBJVlFtZkhMRE9NT09zYzNjOFZIelpkaEpR?=
 =?utf-8?B?R0NwUkNGVmVaYzQ2YTU1NmdrM2ZCQkFRWTIwTTRiRWN0SHZpc3IyaWpkeHZ4?=
 =?utf-8?B?ZE9HeERtUGpRUis0V1RWSGd1eVZTWGpXVlFlVDdzckJQN1lFazdiVHFIbFZW?=
 =?utf-8?B?SnVDYXFRdEMzb1BJS0VTUEdsVXV5bkRYNkEyVkp5eXgxWUU0Q1FuaGZTU1Y2?=
 =?utf-8?B?WTh2ckFLVU5kNWFuUnYzZHE0RzF5cUpXOGRjeUZHUjFvM3pyUTN0U0k3cGpl?=
 =?utf-8?B?R2VNVzhzeE51T1luY2NZZk1VcVdMV0lHU1hMN3VrZ3NIdTVuU1FDTW9mVElM?=
 =?utf-8?B?UzNQQVpHb1FDV2JWcm8wd0ZhQ3BaZkJ4ZU0rWWMyV0V0eVEwY2JUdERpaTF2?=
 =?utf-8?B?eDg4STArNC9xcUo2SjFEK0k0SVh4MmdTNHJlbGpoMUkyL2RQT0M3RUpXNzM3?=
 =?utf-8?B?cXc5MjZOZnBrVFM4bjQrSit3dXNWZ1Ryc25hNTJpYnJiSklhU1ZTWWx4eURG?=
 =?utf-8?Q?vMya+2p7uCseWDPRnEa/R1zRa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e77e0f74-ec06-40bc-031b-08dac968c276
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 13:28:21.9983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YO/E4zW3TJka2U8aQjnhcrKofRCEs1lYkFkQUO2WuXgXUUQyL91Adaz4U7DKyhUswXKFLPO0pIiZJlh81rZ6uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5730
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/11/22 18:23, Borislav Petkov wrote:
> On Thu, Nov 17, 2022 at 05:50:34PM +0530, Nikunj A. Dadhania wrote:
>> Purpose of this patch is older guests kernel that have SNP enabled
>> (5.19 onward), when a particular SNP feature is enabled by the
>> hypervisor that needs enlightened guest, older kernel wont be able to
>> support the feature. There is no mechanism that the hypervisor can
>> find out what feature is supported by the SNP guest before hand.
>>
>> For example PREVENT_HOST_IBS needs changes on hypervisor and no
>> changes in the guest kernel. In this any guest kernel having SNP
>> support should work.
>>
>> While for SECURE_TSC, hypervisor and guest kernel changes are
>> required. And older guest kernel will not work if hypervisor enables
>> Secure TSC. When secure tsc feature is enabled following define should
>> be changed:
> 
> This all is still veiled in mist to me. What are you trying to do here?
> 
> - Make sure older SNP guests boot on newer hypervisors?

Yes and No.

Yes: For feature flags that do not need an enlightened guest, older guests should 
     boot.

No: For feature flags that need an enlightened guest, older guests should detect 
    and fail booting on any hypervisor that sets this feature flag. 

> - Newer guests boot on older hypervisors?

Yes, as the older hypervisor won't enable the new SNP feature flag.

> So, first, pls explain in detail what the goal here is.

The hypervisor can enable various new features flags(in SEV_FEATURES[1:63]) 
and start the guest. The hypervisor does not know beforehand that the guest 
kernel supports the feature that is being enabled.

While booting, SNP guests can discover the hypervisor-enabled features by looking 
at SEV_STATUS MSR. At this point, the SNP guest needs to decide either to 
continue boot or terminate depending on the feature support in the guest kernel.
Otherwise, if we let the guest continue booting with an unsupported feature, 
the guest can fail in non-obvious manner. 

* Primary goal here is to detect such unsupported features beforehand and 
  deterministically terminate the guest.
* Secondary goal is to use this mechanism to future-proof the current guests 
  for newer reserved features flags that may be defined later.

Here is the support matrix per feature that can explain better:

HypervisorEnabled: Feature bit is enabled in SEV_FEATURES
Required: Feature requires enlightened guest
Available: The guest is enlightened for that particular feature.
Boot: The expected behavior of the guest, whether it should boot or fail.

+-------------------+----------+-------------+----------+
| HypervisorEnabled | Required | Available   |   Boot   |
+-------------------+----------+-------------+----------+
| Y                 |  Y       |  N          | N (Fail) |
| Y                 |  Y       |  Y          | Y        |
| Y                 |  N       |  N          | Y        |
| N                 | Y/N      | Y/N         | Y        |
+-------------------+----------+-------------+----------+

> I'm reading the above in multiple ways so you need to spell out first
> what you wanna do.
> 
> PREVENT_HOST_IBS doesn't need any enablement. So why is it in the mask?

PREVENT_HOST_IBS will be defined but shouldn't be part of the 
"Required" mask.

> SECURE_TSC needs enablement on both. Why aren't you checking only this
> one.

SECURE_TSC should be part of "Required" mask and once secure tsc 
support is up-streamed it should be added to "Available" mask.

> IOW, I would expect to check *only* for features which the guest needs
> for the hypervisor to support before it boots. But not check everything
> wholesale.

Guests need to check for features enabled by the hypervisor that is not 
supported as well, so that we can terminate the guest right there.

> IOW, I see it this way: guest boots, sees what the hypervisor has
> enabled as SEV_STATUS cannot be intercepted and acts accordingly.
>
> Now, the question how *old* guests should act here is a whole different
> story as it depends on whether this gets backported to old guests -
> which doesn't make them old anymore as the checking will happen - 

Old guests with backport will deny booting with unsupported features. 

> or to
> really old guests without the checking. There it doesn't matter.

It does matter for old guests which dont have backport, the behavior will 
be undefined.

Hence fix needs to be back ported till 5.19, where SNP guest support was added.
 
> And come to think of it, this whole deal is no different than having
> feature bits in CPUID and the kernel implementing them.
> 
> If the kernel finds a feature bit set in CPUID, it enables the
> corresponding code. If it doesn't know about it, then it doesn't do
> anything.
> 
> Pretty much the same here: if a SNP guest finds a feature flag in
> SEV_STATUS, then it enables the code corresponding to it. 

This is the good case, where the feature flag is enabled and the guest 
kernel has support for the feature. This should boot fine.

Second Case which we are handling in this patch: SNP guest finds the 
feature flag enabled, but it does not have code corresponding to that 
feature. The guest boot should *fail*.

> If it doesn't
> find it but it needs it due to enablement, then it stops booting.

Above is the third case: where the SNP guest does not see the feature flag 
enabled and the  guest should boot fine irrespective of whether it is enlightened 
or not.

Regards,
Nikunj
