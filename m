Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B6F6C79B9
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 09:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbjCXI1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 04:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbjCXI1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 04:27:12 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50472597B;
        Fri, 24 Mar 2023 01:27:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m//7iQTzbCTBi9Pg3FDbDwJUhS+rBPACPPlbknSyHXf9KVTmFdMYtOxUMiCttVMM+ynclDT5ZE8kcTH3cZJXXj+7Kvp2UDFG08EfNO8uVGkQm0CazsEB0mzxJtvEHzqRj8k4SbZToGkfbz5OENXWtnaw/S7Nl6p46Tc0SvK2Zyk5ZwQT8+0siGZcMBaodLDKB5mEfoSqf5yD0m6W3/of15v1KQ8GG51KdJ3lh0vNGHQmvzNKc3YYmq4omwFwt7+nBS4dzAEYW5bI8RO7kTOQIeNAZx8VVfateWo3Yt4woRIy7xH+GOF9gd/Ea8WLFXtwb7ITdPMUfWCAyL0PaDAgug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U6Hh6fqPvVNViCXzN5IBVkemX6UuzlU2wy5MqNpoE50=;
 b=T2WCLPDkeyRMrEV/438Md1RLr8UsxvJpWL0y69Nrx2NOOK7b7gUBlXoMxuATIr384dBrlpP5PM7GHk6IkvCWhZ8FWqEhONyJ34ROCuIs4WyN1pVkCyS/EIggXXLLOwQ+7d++7jdSYfJheaPcAWjeB6fuZYkbKgTIF8jSh3A/Ye3h+uOcB5LNTxVjI/1LpTGOUmjjAiLFhbG/1QzYP2wHxSyqmXN0VTsFJ0TZif9QaV9gXg70974G9dKM5jAv4/35rVSKny4WqMtCcYHnWb3EYm3eV5zqkoYHyNa7kaBKZATYQwUb+2DCSDzdHgdVHXV7ao7Oo/N5PklPTSgxXf90yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6Hh6fqPvVNViCXzN5IBVkemX6UuzlU2wy5MqNpoE50=;
 b=XnWnG9OPIdfTo+KSBiXmyRG2PRHJ3pH61Y5LSpszvyO473HvizR8QZC72p/E57zR0K2UAtcYHdzrmhWzb5aaFAGhVUiuhpDATIzXN0Quyj7Jmd0n1GU1OknFDwRXc+8iURrgNdrQMgFTAqY4VOHPv0pPjBfopBrIvSMiDMrvDcM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by CY8PR12MB7706.namprd12.prod.outlook.com (2603:10b6:930:85::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Fri, 24 Mar
 2023 08:27:08 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::c110:892:21d6:9a5f]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::c110:892:21d6:9a5f%3]) with mapi id 15.20.6178.038; Fri, 24 Mar 2023
 08:27:08 +0000
Message-ID: <d9f235a2-9926-89f6-6451-c34db54677cb@amd.com>
Date:   Fri, 24 Mar 2023 13:55:57 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCHv4 00/11] SVM: virtual NMI
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, mail@maciej.szmigiero.name,
        mlevitsk@redhat.com, thomas.lendacky@amd.com, vkuznets@redhat.com
References: <20230227084016.3368-1-santosh.shukla@amd.com>
 <167960989477.2547780.13395816723370441701.b4-ty@google.com>
Content-Language: en-US
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <167960989477.2547780.13395816723370441701.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0098.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::11) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|CY8PR12MB7706:EE_
X-MS-Office365-Filtering-Correlation-Id: fa6598f9-533e-44ef-9035-08db2c418ea2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cpWt2T9LRzFuyEvov9U4kyFtK3JA0jKg6Dwp+gbm++04XeNUzbc9setFohuNpqW9H1bPE9OVOzox3xReLAWbPEwYp1RKBUhM5/6vXYnRdgV1x2MPzxWtc7kP1XuKw93WlQ9cHXeIzsKUt86K0Clrk0itnBw4l6d/jrPY/u8+TWI1EdkRqcGAl4bdfy16d4dORXmiVpFpNZwuBHq9vJ96WErUi1E+Kg3ErJgoTMBLCzYCTzGZoJIgWfDbTHQxBgFTajkkkPGf9cvJ0b6F183KbLFVxheLHkDdfwYTOlHyuiJ5VFbe2mSUgW5JPQjLmnb8zgB6zE53niB8TMQLLfhcH7/74+/vWPf3TriiCb/VFA6AM2KH9JvDMIkDif530uaOwgKVB6rX8NUKWLuqM1cS3VOs8/FFvld1ZH6DdzOh6lzT0tsOhpakxfKl3rdCDimnTg9M9QVeXIwiE4D3+NUzITRj187P6KfsNANXox8nPRuhSoVu1+wH8W+cjUmHXZgaszdjw6QhRjrz8x9GlaLpgYRbSi1/pi7b6tnxZyBP7qrkWYdndp+B5I7Uu+N5oVuRbSp0bVwNkEcKWl3oiLhAtozHLe+5auWdLEohCNXw54Pa5eFYRBdlNjlc11mprpX/qq5bP7TUZpLjZnBn5MxFhcsuXbCctgiXMAXu0CGQaxdOvpGdsRDC0pmHF1EcWFYgtQSl+tQfj3QmS4VH6HqXsKzovjgNP9dSr7GmgT/t4bOu0w/IWxnWtvEF5jZx7ugY/2bsZGTbo8ZFkq8YPDbFdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(451199018)(66556008)(66476007)(53546011)(4326008)(66946007)(8676002)(41300700001)(5660300002)(44832011)(6506007)(8936002)(26005)(6512007)(186003)(316002)(478600001)(2616005)(6486002)(966005)(6666004)(83380400001)(31696002)(36756003)(86362001)(2906002)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjdGakNBZUN4TWJncGFQdUQvdUdhaHdXQXJZSkFPais2SDI2c2xFTnNnTy9D?=
 =?utf-8?B?L1l0ekpqUU9uT2d2YmR3Y2pTWk5aNGhCaytJLzMwNk1OTFd4YVQvR3ExLzFB?=
 =?utf-8?B?UUJtRHAvdXFHUnFMZ3c2TElSNlNVeFFGVWtxeFVUcXhqRFV4UE45Mk5GTDFH?=
 =?utf-8?B?RjhpYXBOK2R3TWwxd2tiRXc0MVF6eUlGR0YzRDN0QmFZUG0xQ3dVb1V2cWdC?=
 =?utf-8?B?SHo0MzhsMHRFalJsMjRqQVk0Vlh0dVJucndyL1VKYnBZYmkyUmxLblVrL3pX?=
 =?utf-8?B?UFdUT0NhN1BxM296QWZjN2xJSDBiYmI2SWU2a3lSMnhhaThiWDB0R3lmMS9r?=
 =?utf-8?B?YTdORERDYkovRldFVzIzMU5CV1VWaG5Vd2M0dHlMVVRESFhVQjdsY2xGNGox?=
 =?utf-8?B?cWVSQm9ZSWdYTHAwYmcrTStDQnBVc3l3Z0pQNU9oUE12Rk5XT3owUURrM3ls?=
 =?utf-8?B?YVBKeWRiTGs5VlI2cDYxTUp0anZEM1ZYT0RlUGYrbHhBRVpyd0NDSkNGV1Uv?=
 =?utf-8?B?M2Y4RUY5K1cyMzNyMEd1TFNzcjJuTDZYcW1WRFJmWmhnQW96T1pSRWxleTYr?=
 =?utf-8?B?YnhzblZLdXNnb0xGOWtIaUIva0xFK0Y2YlkrMnFXbm94UnBkeXdaRUdmNkI3?=
 =?utf-8?B?OXdSZWs1bnZab2hJaHFLUnI1a1lkdUtTOW1WL0pyaWQyc21wUERyelBFSzR1?=
 =?utf-8?B?alVyMWJOaElXcjVrM1l5Rm5NUXkvREZMYzBRUENHdi9xNWVtQWRQaWlRNTFJ?=
 =?utf-8?B?b0ZvczgyMUhpbHZ3d1lOczA5clpYWmdRM0xqcDZPVVRoUnJaaEdWQ0k0QlFE?=
 =?utf-8?B?cTR0Z25uZnZhOUJ5VjU0R0xjclJxcytad0dSSUwyNW0vdjAyVWlPY2N2aG9i?=
 =?utf-8?B?S2YwRW5Va0t1NTh5bHRuZzhHVzFvMmxvUVRrOXBzZnRlc1ErNFVENmloMXVL?=
 =?utf-8?B?WTd4RFk1VXQ5ZVY5RmRtZjN3RnFwMmdaZGRsSXZKL2dJd0Q4RFhUMmtpTEN0?=
 =?utf-8?B?MXRyQmlSWG5RbVhCYjVlYmJqbUdmZ0lzVDRjS3RQUjY0TFhReXNGOGw2YVpt?=
 =?utf-8?B?cXpNVjJMTTVzOVZtcE9GVXdOOUY3bmJaMmg4RmtDZks1NVZYOHZmNGhIWjN5?=
 =?utf-8?B?Nzl3NVloaHd1RmRFNTZ2cjNwdWdqUlFwdFNGcG0vRURTc0Z5NlBHZ0dMbzZk?=
 =?utf-8?B?cjRSRjFmTXdQSGQ4ZzZ3cGppR1hqRUp1VGsvR0ZnZjhwQ2lORVRhMUJTOURj?=
 =?utf-8?B?aVZRU3VQRERoSzdQYmF6RTZ4SDFiWFdhTzE5aDBOM1dBSEg0MmhPN2xnNW01?=
 =?utf-8?B?OGxwNlI4NVgwMjJSOWhpQVJpU0hkdjFIc09NY3EyT29vWWpqbXV2Q01kdEc2?=
 =?utf-8?B?TnZmZ0MxRURFTGN4T2xhbWVmWnF3Y3JycW5wcmRtZXk5VjJqVE1CbklsWVll?=
 =?utf-8?B?ZzRabWVCeGpNYzBXWXA4TDJyN2J6aUNnMENkbWMyd2lWVkdoeUtud1ZnRlhz?=
 =?utf-8?B?dkNHSTR2ODAyVzZ4UmxXRHFySitGRFE3WnEyTWYzYXhTaGptT21sM0I1SUNw?=
 =?utf-8?B?dXJZd2RLbElsL2lPdWtIVmhOaFl3bkxUTi9WbkdQVk92MFB2eUlCVWZRWEpm?=
 =?utf-8?B?RmsxeVoreFp5N0MvMUdQZGp4ODk2bzlxMm1teDh1V2llQ0JXVFFRaXNxQ1pI?=
 =?utf-8?B?RDlyVWx0UTdHeXdyVzdqYmpsVjh1bHc2WERJblpYLzVYOEJTMk1SSEZuSFVN?=
 =?utf-8?B?YnoxM0ZUeXRSVmkrbGlVNXNoTUIwazhCem9nOUxYWDNVZ1pjMksrUnkwbjZt?=
 =?utf-8?B?dUJtWHJ3dWh6L3R3cHJiWHJ5Smh2QlpjUWo0L0dvSVovM2ZpK204ZVY0TkZE?=
 =?utf-8?B?blR3WS9uSlMwaG1JTko5ZWFFcHNrbVduU0lBaXgrMDV6dHl6d25ubjRic1Jy?=
 =?utf-8?B?SWhpUndrS2krY29ZdjFjd29pQ1pmOTBBL2w3QVgrUkJSbVFlQWd5QXpyWDIx?=
 =?utf-8?B?TVFKN2RDallzVmRQVmU0eGI4UUNNanZRZ0RpMEw1R2svZ25sYUtnSUMyTHpX?=
 =?utf-8?B?Yjhra203cTFxSlg1dzhiK0NDMUVtL3cyNkV0NWhXSUszWFBZR3VHamU1eVU4?=
 =?utf-8?Q?UrzmuUdhOw+AcIf85vy5sJ9J+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa6598f9-533e-44ef-9035-08db2c418ea2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 08:27:08.2759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yp/tWSzWYO5qXQxaHENygKYpBJQ/m3aelDCIP0nsn3m/v28Zu9YStRjnMCJBF1AkE5JNMWRvWcUOiSX4pxThrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7706
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/24/2023 4:23 AM, Sean Christopherson wrote:
> On Mon, 27 Feb 2023 14:10:05 +0530, Santosh Shukla wrote:
>> v2:
>> https://lore.kernel.org/all/0f56e139-4c7f-5220-a4a2-99f87f45fd83@amd.com/
>>
>> v3:
>> https://lore.kernel.org/all/20230227035400.1498-1-santosh.shukla@amd.com/
>>  - 09/11: Clubbed x86_ops delayed NMI with vNMI changes into one,
>>    for better readability purpose (Sean Suggestion)
>>  - Series includes suggestion and fixes proposed in v2 series.
>>    Refer each patch for change history(v2-->v3).
>>
>> [...]
> 
> Applied to kvm-x86 svm.  As mentioned in a previous reply, this is somewhat
> speculative, i.e. needs acks for the cpufeatures.h change and might get
> overwritten by a force push.
> 

Thank-you Sean!,.

Best Regards,
Santosh

> [01/11] KVM: nSVM: Don't sync vmcb02 V_IRQ back to vmcb12 if KVM (L0) is intercepting VINTR
>         https://github.com/kvm-x86/linux/commit/5faaffab5ba8
> [02/11] KVM: nSVM: Disable intercept of VINTR if saved RFLAG.IF is 0
>         https://github.com/kvm-x86/linux/commit/7334ede457c6
> [03/11] KVM: nSVM: Raise event on nested VM exit if L1 doesn't intercept IRQs
>         https://github.com/kvm-x86/linux/commit/5d1ec4565200
> [04/11] KVM: SVM: add wrappers to enable/disable IRET interception
>         https://github.com/kvm-x86/linux/commit/772f254d4d56
> [05/11] KVM: x86: Raise an event request when processing NMIs if an NMI is pending
>         https://github.com/kvm-x86/linux/commit/2cb9317377ca
> [06/11] KVM: x86: Tweak the code and comment related to handling concurrent NMIs
>         https://github.com/kvm-x86/linux/commit/400fee8c9b2d
> [07/11] KVM: x86: Save/restore all NMIs when multiple NMIs are pending
>         https://github.com/kvm-x86/linux/commit/ab2ee212a57b
> [08/11] x86/cpufeatures: Redefine synthetic virtual NMI bit as AMD's "real" vNMI
>         https://github.com/kvm-x86/linux/commit/3763bf58029f
> [09/11] KVM: SVM: Add VNMI bit definition
>         https://github.com/kvm-x86/linux/commit/1c4522ab13b1
> [10/11] KVM: x86: add support for delayed virtual NMI injection interface
>         https://github.com/kvm-x86/linux/commit/fa4c027a7956
> [11/11] KVM: nSVM: implement support for nested VNMI
>         https://github.com/kvm-x86/linux/commit/0977cfac6e76
> 
> --
> https://github.com/kvm-x86/linux/tree/next
> https://github.com/kvm-x86/linux/tree/fixes

