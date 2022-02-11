Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7994B2294
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 10:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348770AbiBKJ4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 04:56:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348758AbiBKJ4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 04:56:34 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2075.outbound.protection.outlook.com [40.107.101.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC34E94;
        Fri, 11 Feb 2022 01:56:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DoS+SZTlA90rTBHj9/YoDQpnodyQCp92XH0eiAhf0is7A+RX7t84agA+TEUG9LZyexnEId9ijaQGlhPkS5v3/sGCUgTuvKzXvTPXtwbyr3WdKfBGsED4Ow/jizC2xfDRYLko9am9Ozq76YZ0mFHBVCc1EO4EG2KkmLm8K/w2Uy0qs8woa0CB0IbA8iiPMRsyeFpmi9C96tJ+ivN4Nb0LfQtBl70G13CI3RqK/9rav6Mai2XsGRylBA31Wtgd9TxlZs3BvvAFqLlJAIm59ujrqb7/d6AROQz9gI5Dp8IxgCXBXgskmq+LpMAj7qscnMVuUPi70VeRmTJ4lqkRcHapew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZ9hgffJMdsD7OSEEJjXOq5CDYoph7+Mvo5HvGNiXIo=;
 b=PTnmUTtSwKWUDIWu7UXMapKV0zo5hsd5w91CGAXwcvVdPTLC4etcfz9mTUO6LvcMuz6jzbAe7eIgRKUaB67jsf5mmW/XXWe1TKgcKgCaSD4z+Bl7GW58tQn4MnOTqxn6FlWo145pkvC+kXSYGiaR435h0GfYPK72pIOArwgquseVFUENk6A2fAjZD2mM1PjObR3Ok1JRzbW5O6NzRiNMTs8ONs4yNhV0wcsDZ6BDv5hNrfhmxgcsUYBwP5DH3mSEdUxD94GJV1WmvSQVmnX3UN0COCfRntscpOGkC0BMF+EPyHUkve6NGchhfJkOG8bNdvPFQMTTFiWAMhPqnkFh+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZ9hgffJMdsD7OSEEJjXOq5CDYoph7+Mvo5HvGNiXIo=;
 b=PWERXLx17WIlIKb1xh8vomScX88+xmqBCXH6bI88jXFoKSXB13mkL58HNAkxoqd+1TuGYY5qYRibzjnKqpr6umN0+JmC5NGdH7J97BvMpPTKrIib9yHjIWCEe5xa9EWYwnT2lla9H4FsS450vGm9DEMyTPzl0FEPqk2TMfSLof8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3053.namprd12.prod.outlook.com (2603:10b6:208:c7::24)
 by MWHPR12MB1565.namprd12.prod.outlook.com (2603:10b6:301:b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Fri, 11 Feb
 2022 09:56:32 +0000
Received: from MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::9117:ca88:805a:6d5b]) by MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::9117:ca88:805a:6d5b%4]) with mapi id 15.20.4975.014; Fri, 11 Feb 2022
 09:56:31 +0000
Message-ID: <d4dae262-3063-3225-c6e1-3a8513a497ec@amd.com>
Date:   Fri, 11 Feb 2022 15:26:15 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v2 2/6] KVM: x86/pmu: Refactoring find_arch_event() to
 pmc_perf_hw_id()
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Dunn <daviddunn@google.com>,
        Stephane Eranian <eranian@google.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>,
        Kim Phillips <kim.phillips@amd.com>
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-3-likexu@tencent.com>
 <CALMp9eQG7eqq+u3igApsRDV=tt0LdjZzmD_dC8zw=gt=f5NjSA@mail.gmail.com>
 <7de112b2-e6d1-1f9d-a040-1c4cfee40b22@gmail.com>
 <CALMp9eTVxN34fCV8q53_38R2DxNdR9_1aSoRmF8gKt2yhOMndg@mail.gmail.com>
 <3bedc79a-5e60-677c-465b-3bc8aa2daad8@gmail.com>
From:   Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <3bedc79a-5e60-677c-465b-3bc8aa2daad8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0102.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::23) To MN2PR12MB3053.namprd12.prod.outlook.com
 (2603:10b6:208:c7::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a5bb34a-3131-4898-f37a-08d9ed44c7c9
X-MS-TrafficTypeDiagnostic: MWHPR12MB1565:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB15659CCC9DE78B29DB270E89E0309@MWHPR12MB1565.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bwXBUrfaCtf8s+V5fjwSFPQAg0vIYZ+n87NNvvX3B3K0DRbWwyYNZLbzG4B1e7Zn/dRtbsocCoK4XQeOy2/nyP2YdNNo23+bRdHYTXSi84eaB3TDFlyBZyPHZxfKFLBxqfG+92gwDby6ZRtacT3xSzxnX2BkAZiXaxAOSAOfhVU6/NgrMc+BlU2wFrh2qYE/Nct3HacnysGSCFF5V9kNy5Es6Kp7brin2m0pnLCW3nYYymI6/cpfDTFP74LDAkjT7lYfZHoDhFDHPabAkDTXtBufX1F+Qr8OGmRG4yRhWCEqYikvy38tyqi2stTkJvM5PPLN/gwK8EOGllnBiD0Q9R5ChqyXGRRCqm26LJdsW591eUaTQsJoFTkzYkShdzYjse8ywcMTSWMZok/Lqa4LeIHbJqlj69Vs9YdUxSem8533eCTyWEvZcwlbyuVnbkpZs2IHTDV4+VNnNsrBRy6CJQv1hTmEhS9mYljTkDSga9LTt8k5TEhfPAmssVG2/D/UNRJ5G+BWReZtdz9vwlwfcfhYzm8T9Vgdlu/9HgQXnWGAqc/TKPFKrMyLRs5dqV5itFkv6ZwIRo5rPnRHigv/0z/9/jHRv435hPoROIR+EkGoMnL3oMyb+HBJC55ABoKO/YgWf0Ds+LKTyQ98/6WrKcYMueFp0s+ZYJcFOGW+/8sRM34S89jAuTJ7PgL1jjzvzWY08ewHoVlmPU8kjb3Y0p5ZWr8TPZ0ibxaoHWj5tvjiz1McUyJx48vesbsdQ0O8dQk9n/23uMfFBhbCgr8awR4O7aK6VpLimQI09TTSjd2Xm9Dl9viu5CH3LBapzbVY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3053.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31686004)(2906002)(83380400001)(6666004)(966005)(508600001)(6486002)(44832011)(4744005)(5660300002)(7416002)(36756003)(66556008)(54906003)(31696002)(66946007)(86362001)(66476007)(8676002)(4326008)(316002)(8936002)(110136005)(186003)(6512007)(2616005)(26005)(38100700002)(53546011)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3dudlQ4bzRBNVR0RUNVdE1rVXo2M291U0lETVdSdXU1V0JqTDhCWGluZXFa?=
 =?utf-8?B?NzBMRXpBdy9HaHNycTdnd3lOQlpqanNsYitNMzB5OEx2R0xZU3hQbjZLL3Rq?=
 =?utf-8?B?cUUzeGRjY0xEeDVCSTZhNUVVN3dWdG40bVc4d3RCVk5VdCs3VFMxM2V5NEZ4?=
 =?utf-8?B?ZHZKN3BEbWdWaWlCT25BQnBlUmpHTkRiTU1OMDYrcWgzaDJBa0Q5S1BLRTJG?=
 =?utf-8?B?Qlg1R0VYNjFjTkE0RVdQL016QVF6QnA5VUNLU0twN1hhSFVPZExZLzFscm1N?=
 =?utf-8?B?UURKbVpVVFo4OGozbTFjMDlwZS9pdlpvcnI4MFM2K0Z1Q1RJc0xJMGZoMFUy?=
 =?utf-8?B?OGg2N0RhRGEwZjZ5OGZwb0JKWmc3TmZ2NXZodDhISDEvUVFQMUtaZXhlcE9s?=
 =?utf-8?B?YjV2ZnNKMmhhTWJzNnFoZFhpQ252TnpBUVJuMFc2L0NMcllEK3oyMTBGUWZW?=
 =?utf-8?B?dzE0TW9ndytVK1pwOEZwNW1zNnovZnhORG1Qa05LUFNuL1NuL1A2UlV4bjdC?=
 =?utf-8?B?UUZ1Tk0zQzJYUy9HcDZ1MTU0djVTYzRJWnA3cTd3RDBLVVhBRkJ6Y0U5UUtm?=
 =?utf-8?B?YXY1QnVVdkhwVDBaSTlHK3o4TGVKTnE5M1RJT1Uvcmxjc0M2cXhHUjNYbWJD?=
 =?utf-8?B?RzhzRDdYTGc2bStJWEY3QnY3ZS85STNpanMxOFJrVmlFQ055Qm5DanpzODg2?=
 =?utf-8?B?ZkV1Y1VEQnJLWkZReVNva3dIS1JRRDVwMXkyR3lSWk1PdDNHV2VUY0NLTGF3?=
 =?utf-8?B?aUxISWpKMjhuNnh5N0YzRXY4UFhUTURYMFpTdkQ3MXg1ZlhjZmVjSWQ3MEFC?=
 =?utf-8?B?R1ZzdE11cUpDVHBZM1ExN1Z1Tkl5aTVzVis2TkErOHZXcUpxMWV4Y1RYREhR?=
 =?utf-8?B?dERvR1JKeklJQ3hORndhQ2pKeTlnY2F1QWZOU0I4T0tkdlFzOERUSkpWZDN2?=
 =?utf-8?B?Sk9od0NVdzJFaGVpNGtUdjUxaXViLy9ocmRWT09IaVZOdHMrK2ZSMmpud0lE?=
 =?utf-8?B?aFZlK01XS3NRcVhlMVliSUkxZ3dFR2xYaGFzN2Z1dzlqL2dXUHY3c2pveVpx?=
 =?utf-8?B?dlQ5MEltelZmQWFEZmFSTk9NWHowYllneCtKbkNIRzhqRnNCc0lJSTFSYURZ?=
 =?utf-8?B?SndtYnR5dkVEYmR3OG03L0tYTER0YkZoZ1AydnkxVmF6UGIxS0JKc1NKVEdO?=
 =?utf-8?B?ZGM5cG5XNFhKYWZEQkpVZzlIOGlteHRJZ0VCSzExTlovcG1RTWNJRXRoZmwv?=
 =?utf-8?B?QW9sV01HQTY3dEtrZExCck9ZL3Y3WFBUYjQzd3lvbGdHdTNrT2x2azZoT0th?=
 =?utf-8?B?WTI2dHpOQ25waktYYkxuUFoxalh5dE1hYnliNDZRWG1jUGh2Y1JiUHhiSWFB?=
 =?utf-8?B?cFpGZnpSOXNJc01yM083dVhFVTJiSWxsd0ltZGE1QUZCU2l0RHUvMlIvZUZF?=
 =?utf-8?B?NDZETENycWdTTTJaWHZBS1JqYkx6YjU3ekhkN1hYS29FU1hNb0k1UGFyM0xx?=
 =?utf-8?B?MDRiWnAxWlFybGJxOUVsVlVCVFp0eXBvajYzMk9VVUg5RHY2RjR4NUNHSXQw?=
 =?utf-8?B?WWhkcGlZbURLVmNKdXdPVzY2b0d5VFBhaDFDZ1ZwM1N5clkrQ2U4Q3BEUGNq?=
 =?utf-8?B?TU8xRUcvbGNhVGo3VmIzNEtvQkV1Z1BoTGJHUGpuOHY3YXkyN2Z5RWRybVhq?=
 =?utf-8?B?QUtjWFU5OU51bFVKOE5MWjl0ekNCMXR1b0N4UXhmdXhiZ1VTQnY4N1lzM3Fl?=
 =?utf-8?B?QnhTZnE2Q2hKeEc0WlNSMTBkSzdEREF0UkpKYTllaUxTd01GdHc1cityMkFP?=
 =?utf-8?B?L1BseldGZGJyY2pwV0hUK3VJOEJocWFKWWN1N2lMWkNIYklNMnpWazF4bzZW?=
 =?utf-8?B?TUFGRXFqRlBlRUdqNjVHelJZVmQ3MnQ1Mm5XakJsQ2t5eWNMRUYydXpMcFdn?=
 =?utf-8?B?SVBnTUVtUGFnekQvTldxNTdkWFpBSzNIdW1KOTNSbjVLQVZlU0xHNFJxWUUw?=
 =?utf-8?B?TXBvMHl4WHhadHdRWEd6QTREZGZlbEpYeXY2Y3VFellFL2lZUUVSQkNDOXdE?=
 =?utf-8?B?eDdIL2lGcnA4WTNMQnhxVTI5cnBZVFhQQ0g0QjBoR0pHc0xqL1p5T0FxZEor?=
 =?utf-8?B?Q0hsNGtXN2NvaHJ5MnpkbllNekxxbWE5ZElMSjk4TnlUNWJHcnowMmQ1OFBC?=
 =?utf-8?Q?eUa1XNy+oWG6nf+RMbS4P1E=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a5bb34a-3131-4898-f37a-08d9ed44c7c9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3053.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 09:56:31.8064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BjH+gsAwploOUWvRp2oofRm0/LEtj4eUfQ5X/A86A4BVtX1psVB0LnnCF75rqTMITHTyTk2IoH3hfPCELUH0Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1565
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10-Feb-22 4:58 PM, Like Xu wrote:
> cc Kim and Ravi to help confirm more details about this change.
> 
> On 10/2/2022 3:30 am, Jim Mattson wrote:
>> By the way, the following events from amd_event_mapping[] are not
>> listed in the Milan PPR:
>> { 0x7d, 0x07, PERF_COUNT_HW_CACHE_REFERENCES }
>> { 0x7e, 0x07, PERF_COUNT_HW_CACHE_MISSES }
>> { 0xd0, 0x00, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND }
>> { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND }
>>
>> Perhaps we should build a table based on amd_f17h_perfmon_event_map[]
>> for newer AMD processors?

I think Like's other patch series to unify event mapping across kvm
and host will fix it. No?
https://lore.kernel.org/lkml/20220117085307.93030-4-likexu@tencent.com

- Ravi
