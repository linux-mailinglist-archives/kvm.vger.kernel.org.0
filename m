Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78F4636454
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 16:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238778AbiKWPp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 10:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238217AbiKWPpV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 10:45:21 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3F377212;
        Wed, 23 Nov 2022 07:45:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPqfxBeUvdvmKW722Qg/0ckrTAWyj891A6AUYVdcqhE/ZJiwLjSquAB03nkzGyiVkAGeQNTA1CZPLbXasLVGMARj1V0Es/+j6L/HznrjK4e/G5n6H81BuaC7//+iKAj8LkWtnapO/vV7KmRQpGYsTrsFXJQO3mRrwe2gpheCTWIEQHjgKzcWuLezJ7AlZ+FCyXF9OGgzooPiF5yVvf06/CEHX3la+d1zBLBotNOD62CzUYB0hOmvexlHx8uWFINGSq1y33e1zK2myAcciPfT/nBp1rbSDGWvjaUwUoz4zKB7v5ZAdeGj6eGjWobLKLDFuuHE3gKmNpZq/KtEKXTx5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x0ss5QfybSlv8xEHyl0evKz+7HEX4STfpO45XsXtuyQ=;
 b=Ok8LxpLswIWXqUezL3FJy6oK/3Rfbe0AnA6D2FQlntd7XOTjs+seD1KD2qOq2YWDA4hHeDf+yekP9oGavmLPwMa1jX1ffDRw34s5cMJPBlgPSQcjPtSxpt12CNBYWlGbNJmH6mTpGVKl9gZ4H6ThvAax+4NmiLypR8nxObo0dUQnwxP1DasaB4RPrQNp0B0HC/DzMd8xqPE/yiwfAVq8j+OA/dOb9DRidg8elwsestSz1C5SvZGbNouCE6HY62QIlu1ROVblANqFksqpUl8Ap9eILvkZ58abQ5Fz7Nn0pfy7zLmKIwPip/kcfxNUfDPDbtFr52eT2u1/eUn83yz8vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0ss5QfybSlv8xEHyl0evKz+7HEX4STfpO45XsXtuyQ=;
 b=xq5xZS3gIZoZuqUA8T6CJy2zHLx3CJR8+tNvkIvCT39wJ3VtULzjW+2rhphrr6/z8gDbe5B0z3hB3L3Aiay0Sr+mRGRziWyNg1rI3XryrYKwpSs8mbMRv1gHVnlgoYF/0GQxEFbA0okn+RI2v5x77UI9AwepcIT3pC4U/OB5QTs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MW4PR12MB7168.namprd12.prod.outlook.com (2603:10b6:303:22d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 15:45:18 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::6481:82ef:ffb1:4d0a]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::6481:82ef:ffb1:4d0a%7]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 15:45:18 +0000
Message-ID: <72e31182-5855-3a45-ddd7-105cd3e7256c@amd.com>
Date:   Wed, 23 Nov 2022 21:15:04 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH] x86/sev: Add SEV-SNP guest feature negotiation support
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, stable@kernel.org,
        "Rao, Bharata Bhasker" <bharata@amd.com>
References: <20221117044433.244656-1-nikunj@amd.com>
 <Y3YP5FQ6OHzVFKbp@zn.tnic> <7e224da6-6b02-2972-1334-bc8e7894cdab@amd.com>
 <Y3YuxGO8Kycymxg3@zn.tnic> <4ea6e1c3-fae5-a64a-9bd3-f9ea0821fc67@amd.com>
 <Y3uj/gb8i4koG6Jv@zn.tnic>
Content-Language: en-US
In-Reply-To: <Y3uj/gb8i4koG6Jv@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0059.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::19) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MW4PR12MB7168:EE_
X-MS-Office365-Filtering-Correlation-Id: c6abfd11-2958-43a9-8d73-08dacd69b890
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: or1WpPLL1rMCjYtkoKh8+Wn1D+vdjgLvJbuDC1DCSwJLIdCDwbS7heibTKuwTy71kCbQ820/lC/6LiPNwthUT4pNdX+8dqGLm82dlEAaIPZgq0GUfj+Qc8GhrsbpHekWC2n033MulqSaWrP3SFzpnCvkIgmHDl6NC507zMo30T0TQCyToBq1Ekg0kgVeKdRADtzwgApm9d5OaktG6X1f0+824YAixNPw2+Tv8vd1T4iBrnHosEYfpuLJPA/pNPyQ5TBG2WCcUktkBmLdtlMta5bc4ukTV5tu5sgF9Syc0fh/pa7EoumnEHEAHsUbKOw1axSsXxIqSkYAcNGzN9di3RyOTUIKEodoqbGVN85EZUPO8IrnqRJ9/6FH35tlBbKz9rjA6vtpDYuWs7mdtGvLdttqq3pC2sZ/yGnIDaQIIdq+x6UTseg0LhbOu+VpoVZBtU3T9tsICJ7M1FEut6HriBfjWpSogwEe29+EuwDirHXnQFj+tfjPZ9iFjPLG5/c45VA8HY8tvsqcpeoaYwN+JOzw41eUWuwdxWnesfg+ve+KWg2Wf+JAzw1Qej27RNevPmKCP5SZJ3uJj9aNnFl4kYSNC74BeA9jMly4qJl80knkmWfVQAVdo4NPpeLZdcekHTzUhaW8iS1UFe3oTIaYEDe2ZzpreSGGjLaBxzHnazPYQE5PoQr/5rQZ3+4xlTrwISbcWF8BFqusegHz7jBQXvJR4eV9546ivd1uqCDNxvo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199015)(38100700002)(8936002)(316002)(4326008)(31696002)(7416002)(2906002)(83380400001)(66556008)(5660300002)(26005)(6506007)(66946007)(53546011)(55236004)(6666004)(41300700001)(6512007)(2616005)(66476007)(6916009)(8676002)(6486002)(478600001)(36756003)(186003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUVuNTZnYVVkQ1V4Q29UZ0lnQVk1Z2czdThoaTR5UjJ1UlhMMmdDRVF6RXRI?=
 =?utf-8?B?aEZMUWxqOGVBMHhsbjBOYkVVdXhqK21xSE9QZTcvK1Zid2pRN25SZDVqcnpB?=
 =?utf-8?B?M092dXQ4QkdnTVMzY0RuM1hSLzUyZmdEblZiQjhIbGtJNkVHaVQreXcyOEY2?=
 =?utf-8?B?TmkzbS9EdTNaSytjaSt2WEdvTlpIQVp1TW05MHZFOXhSQXFuWWZBYzRIeXhC?=
 =?utf-8?B?aDI5QkFrNWY2dGxHbVZhMnVSbDhxZW83YUFBUk5lTStNT2UwRlRXdWp1T0xC?=
 =?utf-8?B?NWtKOWk4THM1bGZUTUs0MG9EQUhUKzdYRWcraGpib1YrQlJSVDBJVXZqSFF5?=
 =?utf-8?B?VWY1VEFmVG5vUVRqNEVSdnVlZWlTM2c4RDFhWDNNeFoyYkRuRGM3SXdibXJL?=
 =?utf-8?B?MGRyVytCNGVPRlF4SWY4RTVIV0dPblRNdUg2QkIyZ24zemt1UGIyUW5vNG92?=
 =?utf-8?B?ZHp4ZDlyYzYrak9ORUFvRS9JQVY0WVBKUCtBdUY2R1NVMnFXbnBvbEJwZHcy?=
 =?utf-8?B?UU5uUU5LNkJCS1d4dHJhQUZSTG1hNVQzV0NHc0NKYUZZbTZ3dEtsSFZiRWZ6?=
 =?utf-8?B?UFc4UVh2a0x1Skc2a2ExZWtUdk9XekY2Mm5PNHdLRzVleGM2SnRmSEJtM1pI?=
 =?utf-8?B?WEFzeDZWckxCV0NVRkF5RG0yeDdTWm1aN0RVbHl5VS91UmUzbWRWc3BwRldl?=
 =?utf-8?B?aGpzV1VlY3VHTlBVT3VLQ1Z5TmoxSWRRazhwTWF5WjI5M29YckFNakEyZFlZ?=
 =?utf-8?B?STF1TGJxWEpGQzlYTUxWNVVTS0w2WGJGWm5yYmsvY05tYlpZV1JEWm9oZ2pr?=
 =?utf-8?B?YzJkMGdzMWxRczZoeHpMTS9SZkg4dlVFYkFPMUNJc2l2VGlxVmlGN2NSemZR?=
 =?utf-8?B?c0RMQnJObWJLS0FVRGl2RThpbUl5UTNSTEFWMlhqWHhyaEFpL1JoRGJqSzhl?=
 =?utf-8?B?UGdLMzhBUHVPbklBWjlGS1I5cXl1THlpRktsN0pCNDF1bjJjem5xSWJ0NTdr?=
 =?utf-8?B?TjJxdFZRRzVQbkpGMFZJMjBWVFltTE1OYktGOFJ6Q0NNd2J4U0dicVVxRU0z?=
 =?utf-8?B?a1F5b01Ca3lzNXErLzlTamQ4cVFla0JMM1d0V2M2YUtMVDZyamViMVFBeWkr?=
 =?utf-8?B?aCt1RWo2bm54eFJyRHlnY25aQ0s1TlBqeDFxSXlETlhrRVY4MEFyTDg5SXY0?=
 =?utf-8?B?TXRXczlaZFNNODFzLytNZlU2U21qY2JWak9kU3BXdTRQcnNkMnBTK0NYK2J3?=
 =?utf-8?B?aEZ6RnRIS1UvWW5pRmRYTlloRmtISkxiaXQ4THVRclVaK2Fydlo4RjE1Mnpw?=
 =?utf-8?B?bGFMY1VEdURacmV4Z2xBVGVGNDgvNThQMGVhYUZGaGNqWXoxbW5acnRuRThZ?=
 =?utf-8?B?OFdScXRXVkYvZHlXK2MreW13ZzNvQkg3L2ZOa1JWN1FycHV5NFZxKzJ2eHAz?=
 =?utf-8?B?eFB4SjFqMGcyYU9sVWtNdVBzczhTMk1PZHNIT3JHOFRwYm80ZmI3aEU0UHlJ?=
 =?utf-8?B?aUJ2NVdZZ1o3bGZKNWRWOWl0LzdLNHloT2l0SWlza1VHbE5wVmt0ZENtRTQ5?=
 =?utf-8?B?eVJva21zZUp3NXZyYlp5YWR3LytvU0JXV2crTEVsbGpZWk1mRkMxSnB3N0xS?=
 =?utf-8?B?dWtUTEhvRlBvVGVqNHFQb2FtM1ZpTkQ3ek5CNlhpZVh5dnFBZXgrTFA3NWFV?=
 =?utf-8?B?RDMxQTh2Z3haRUo0bU5lUVRjazd5REpFZVVSQm84dW5lc0ZPSTRRbFBtemtX?=
 =?utf-8?B?WGxnbVZwT2V6Qzg0QWhjdjlibllYcUpMVVJSWmpoMCsvZWJuRzYwK2RnS1No?=
 =?utf-8?B?bUU3Y2N5ZUZVaWxhbk8wWkU4TFZIY2lVdWJJNTFSWFNpbmJJQy9RMmlNR3VE?=
 =?utf-8?B?MTZIWFhhV2RNMzNnWnoyNTRiZGZMV0FkUmdETURqSkRENGY2TlFvNkJqZ0pu?=
 =?utf-8?B?ZDdidGFpS2pIUHMrMlBsTjJKWG5vQktWMlhBbW5oRk1QYTVBbzd2Vk44T1Ba?=
 =?utf-8?B?elZwTlo5N1N2UGFUbmpINEFJYU5rRzJaVDZzdVhOdTRFQXU3c3Y0b2NNMXgy?=
 =?utf-8?B?OTlsVStoRFNyM0c4bld3NS9hR2tuZ2JpT0pPaEtuc21uMTNYdW1GR2pWY1NW?=
 =?utf-8?Q?RuACeUp1qycxWLY0fj/4E+aNA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6abfd11-2958-43a9-8d73-08dacd69b890
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 15:45:17.9181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: soUomsAc7pg7cRiIp6L2T8TFBuS3jpN1LUvJfwwVsmJALRP18K4KYGGtzvRzO/bw8EI2WH9JTWBDC5QoNxD4Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7168
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Boris,

I will work on sending a v2 patch that addresses all your questions/concerns.

On 21/11/22 21:44, Borislav Petkov wrote:
> On Fri, Nov 18, 2022 at 06:58:07PM +0530, Nikunj A. Dadhania wrote:
>> No: For feature flags that need an enlightened guest, older guests
>> should detect and fail booting on any hypervisor that sets this
>> feature flag.
> 
> What would happen with such old guests nowadays? Wouldn't they explode
> anyway?

Yes, and the patch is to prevent that and fail gracefully and so I had 
CC'ed stable.

> And how is this supposed to work in practice?
>
> I'm guessing this is supposed to address a case where guest owner goes
> to a cloud provider, boots an old guest and it magically survives
> booting and then it runs with some false sense of security.
> 
> But isn't that part of the whole attestation dance where the guest owner
> checks for a minimum set of features it expects to be present?
> 
> Because if you do this and the cloud provider updates the hypervisor,
> all the guest owner images might stop working all of a sudden because of
> this check.
> 
> So what is the actual, real-life example where this helps? At all?

A cloud provider having the hypervisor and qemu with Secure TSC support
tries to boot an old guest kernel (v5.19):

"-object sev-snp-guest,...,secure-tsc=on -kernel vmlinuz-5.19.0"

As per the current behavior, the guest kernel will hang.

This patch will make sure that if the hypervisor enables this feature, the 
guest kernel will know early that an unsupported SNP feature is enabled. The guest 
then sends a terminate message to the hypervisor, indicating that its not able
to fulfill hypervisor request to enable SecureTSC and cannot move ahead.

>> The hypervisor can enable various new features flags(in
>> SEV_FEATURES[1:63]) and start the guest. The hypervisor does not know
>> beforehand that the guest kernel supports the feature that is being
>> enabled.
> 
> This is not the right criterion: it should be more like: can a guest
> still continue booting with a new feature it doesn't know about and
> still provide the same security.

That is indeed the criterion. Hence, instead of allowing the guest to 
continue and have it fail randomly later(which would be a debugging nightmare), 
this is to detect the unsupported feature early and fail gracefully.
 
> But see above - you need to think very practically here before even
> considering such a thing.
> 
>> While booting, SNP guests can discover the hypervisor-enabled features
>> by looking at SEV_STATUS MSR. At this point, the SNP guest needs to
>> decide either to continue boot or terminate depending on the feature
>> support in the guest kernel. Otherwise, if we let the guest continue
>> booting with an unsupported feature, the guest can fail in non-obvious
>> manner.
> 
> How can an old guest decide when it doesn't even have the intelligence
> to do so?
> 
> What you're doing is, have old guests immediately stop booting when they
> encounter a new feature - even if that new feature doesn't impair their
> security.

A slight correction:
a) If the new feature was enabled by the HV/QEMU.
AND
b) The new feature requires guest enablement

" -object sev-snp-guest,...,secure-tsc=on -kernel vmlinuz-5.19.0 "

And it is not done wholesale.

> 
>> +-------------------+----------+-------------+----------+
>> | HypervisorEnabled | Required | Available   |   Boot   |
>> +-------------------+----------+-------------+----------+
>> | Y                 |  Y       |  N          | N (Fail) |
> 
> This means that you need to know those features which would fail an old
> guest *upfront*. Like right now. And I hardly doubt that.
> 
>> PREVENT_HOST_IBS will be defined but shouldn't be part of the 
>> "Required" mask.
> 
> So it doesn't need to be mentioned at all.

Yes, we could get rid of defines that do not need to be included in 
required mask.

>> SECURE_TSC should be part of "Required" mask and once secure tsc 
>> support is up-streamed it should be added to "Available" mask.
> 
> So when a guest owner gets a new guest which supports SECURE_TSC and
> tries to boot it on an older HV - which is very much pretty everywhere
> the case - cloud providers won't update their HV kernel whenever - that
> new guest won't boot at all.

I think you misunderstood, if the HV does not have Secure TSC and new guest 
has Secure TSC, still the guest should boot. As the hypervisor didnt request 
the feature to be enabled (below row in the table)

+-------------------+----------+-------------+----------+
| HypervisorEnabled | Required | Available   |   Boot   |
+-------------------+----------+-------------+----------+
| N                 | Y/N      | Y/N         | Y        |
+-------------------+----------+-------------+----------+

> 
> Which is a bad bad idea. I don't think you want that.
> 
> What you want, rather, is to say in the SECURE_TSC enablement code
> 
> 	pr_warn("HV doesn't support secure TSC - your guest won't be 100% secure\n");
> 
> or so.
> 
>> Guests need to check for features enabled by the hypervisor that is not 
>> supported as well, so that we can terminate the guest right there.
> 
> That needs to be done in the feature enablement code of each feature but
> not wholesale like this.
> 
> Anyway, I think you get my point.

Regards
Nikunj
