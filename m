Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA6E620277
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 23:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbiKGWnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 17:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiKGWnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 17:43:40 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2069.outbound.protection.outlook.com [40.107.101.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60872B1CC;
        Mon,  7 Nov 2022 14:43:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBsikbk268LGHSqvW2qc4Wk353vgrXATzpmqtCh1YGyAEtbzFD8cFdmBqfIfBaTKH+muQJODqla/449+JGgN5Qbt8hZEQIh5qxztkLaCdbWEOMh/IaP9ZC61hrPj5fbRBo0UZPLA0+xYGzBVdYZZGv5CvSBVpvwXnptlPmFCJzPxNt97392N7vz8rfBFl/Q7oWTCshq05mfPezwmru+vSsVwo1J1rhoqJtQzX/gH00gXDs2rXRHk43QMqL4t7zy48grJ1dV5G4n9xuMx2TeebHLwFs5dv/Rc1PWjtgbSqgy4hTqHmGWHT6NSw4OGQbS8YVJYW9VGA4a6s9Cn2iENOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ArxOFkThkHfZmBWpZw6BYm8M8+yyWp4h9yqawg9fxo=;
 b=Hb/ej/FKZ16CKIgfzPZTMRO1OmtqWFXJ93bVV7INQ7xogtZise4gV7wdM39xqLBV5TzIuozUjxW5xHqnFzblwlbi2SaZg0vahUTphkEhjqLWtyduYcxfoqp0OZ5laClqXm51LcsKD7d4mFgH1EMMFU4QzhzJSgVo2LYKTreuN+f8gZTK3vaViCxAIxkMSd36hbbBnyFxObR27OdRR7K3BT40Gwato3cSF0FwTz6ES0kyWoDa6oKR/lh+pejmTPa1qCVHI4YLTfpnPvGeGZb6cPXPJRile2cpsXkspONxh2qpS8miPr9KsfV+NnrzvxlC5YJ1aq36Q/BjqDU7jXGKUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ArxOFkThkHfZmBWpZw6BYm8M8+yyWp4h9yqawg9fxo=;
 b=MrJPuV5ijAJLEkli3216/1WcHlmwfD5hBoeOzMxzbU93H/4Rs46lI/hKNNfA1Iz69Z3/9Aehd8mZatLTi/uzqiiraRyPFtgXy3ChHQ9fM9fA7I9MNP6luk+Qe8SpbFD6M32aLWYCEJC+StrucEEyrhnMRUZUTG9qJF2uS3MLIXQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 SA0PR12MB4352.namprd12.prod.outlook.com (2603:10b6:806:9c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Mon, 7 Nov 2022 22:43:36 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::6f5:7c8f:32d9:e72c]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::6f5:7c8f:32d9:e72c%3]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 22:43:36 +0000
Message-ID: <b64f473a-a748-7b6c-4829-609631960cd1@amd.com>
Date:   Mon, 7 Nov 2022 16:43:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, x86@kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221104213651.141057-1-kim.phillips@amd.com>
 <b2274949-8fba-24ff-89bf-627f288ace06@intel.com>
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH 0/3] x86/speculation: Support Automatic IBRS
In-Reply-To: <b2274949-8fba-24ff-89bf-627f288ace06@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR16CA0028.namprd16.prod.outlook.com
 (2603:10b6:610:50::38) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|SA0PR12MB4352:EE_
X-MS-Office365-Filtering-Correlation-Id: 68e3b62b-f9ad-419b-db93-08dac11181c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XEoODuevAHvXDFkcnFg1nnlqItQjM9o9qLwCH83PYM0ZG1P3JpXgen7yRF49FZlpe5jXH3fWWPbNKLyzECfQ9LBsjGOpb4RQiY5Lcp2FxhkFqW0rhE4i3tLyeQXUNJBuxe3p7ygs8q2tc2be8cBTjP5821vqogQGtjTfazbFgooTYUQFo7pRHxv2uTdm9mKZutZIL+edw9u61UBsCqGbn/Lj5j1ZFZTA6gRGkdOpHCZHinf/CaWpMdtmOPCN78cDFi1aCJ6t/BtBMDrxxRRlXiHmXcwPWEVnq0lFPQa4LQJqYz0gaf5iFze07hVOJKLCUKzWwfXgvrkXgUw/IRDUn9DZHERJRRL5cmmsBNhPY+HOevWBY9HGXCKvCitZLsvCxoa6j2SAMzfJ2uZZYsZF0VK80PUtes33Y+KFt3qZjtvESFwTHVYGeJvYm3QqJtmpLyB/83JWzl/BS4GD/Yx2bmm5M3mXubqT2CHckxNdwtZTX4jFbz5PPYIUv+K46XoafYPzjsY5ia8/o78W3MV/L4+eBv9CITjo+KRP7E82I9JhETKmKmfkdpiMT8tb/fKCXq8q2FvcToiETk4U+CXnRafQk5dXgzzSimS8awTkIW7NFen9JffYPXLx+uTvzCXyJvThaVGDHZZo+tdgCbTRWK+cDTZBHqCWLrRQiRF+PXPHYz+7/HFH9m5FQvI2WFvOO9JjDM9Igc/Z7VLuwQsgUFJlYaj8cXL/KD1o/JlOVzuq5+exZcK19lySFBrQdaT1UNbAOp5N7VW575oX1wf6XGDNZzhhXJPlwabeGQ0RDKk/R8T4ClxmaodsgRpTGxGpkhZWEfJi59a9gJ+5anxUOJcQlCvELoS0Av9UC/j0xMA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(39860400002)(366004)(396003)(451199015)(6506007)(6666004)(53546011)(2616005)(186003)(26005)(6512007)(38100700002)(7416002)(5660300002)(2906002)(44832011)(478600001)(54906003)(6486002)(316002)(966005)(41300700001)(8936002)(4326008)(66556008)(8676002)(66476007)(66946007)(36756003)(86362001)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SW1FV1FHc2d2emd5NEZrZzNYQzVlNzJGTlQ5VjgzYU9QZ1FCakZYMklpM1B1?=
 =?utf-8?B?c3VBM3NULzUwQjBZYWFTcWRxT1YvZHc1TTI3ZHlqazJzaFI4S3doSmRaaXF6?=
 =?utf-8?B?QVpEai9yZUc5QWd2RHR6RUJSVUxyV05yMXJNRjNIekJKN1JtMzRHN1RCL1Zj?=
 =?utf-8?B?SFFXOEExRDlmSnA4dDZ5Y1BYbWdXT1pLVTJiNWxLQmRDcDRIeEpYVnEwekFK?=
 =?utf-8?B?SEhYVFU5bHBkN0pOUU4yZG1ERkwwSmQrZDgwbWZ5djhaK3hyWkNQNkNzazJl?=
 =?utf-8?B?MzVNSlFBOWI3bDA1aEVpeGhNNHdua2tIUUxYWUh4dFh4ZTlTRlNSMTJFbnlX?=
 =?utf-8?B?QXExQ2dlY005WUUvdjFlNmszMko1cXRRN2xZR3l0dUJPdWpqOVIwRXFpcG5q?=
 =?utf-8?B?S0I0bEdUaEVFNHUxdThmYWtDUVk1bFZ1bTZyeGlrWnM0eW5zUHkyV0NUWlhS?=
 =?utf-8?B?Z3VQdUt4OTl3UXB0RmV1NzlJYXdFbmtSZE53ajdYaFk1NWFmc1VTT3c2WUlZ?=
 =?utf-8?B?aDMrcFRyMG4wbk4rbDQ3cFZZRGptUXJlVjJ3bGt3ZUIxbEFJTGJ6Zy9iZWp6?=
 =?utf-8?B?RXdPTVc2ZmhDK1RhNUpSSzZVSDFnT3pDWkxpZW80cStCKy9RL2RtZEY2dnpZ?=
 =?utf-8?B?R1pxR2FwTnVjWG9FYm5LN29tdmUySm1uOFVBdmZvSnZ1WkQ0TTByWDV3NXIr?=
 =?utf-8?B?RlFtZC9YK2wrRUdjTnU1cXp1eGlDTDFtUzlIM24yZ0pIUEkwWk1VSHVLdHlU?=
 =?utf-8?B?OG9kNm93bG5GVE5mTWNSMEVwb05FWkRWaFp5RThqblZXd2FaZXZLM3JkbzZl?=
 =?utf-8?B?NzdvelkyQ0FWQVE0clFmRUd4ZGlEaGVkRGV2aVpTQkxLSklNb1UxbEdDam9E?=
 =?utf-8?B?S2lRM003VG9DUXN0K1Nhc0pHODUzODJTVTFOQzFjajZheWMrWm1WelZ5aU1r?=
 =?utf-8?B?U09HZVpGWkx3dk84QU1DK21KUldFb29EWGpQRzdaNngyc1h6T2N3TkZFcmdK?=
 =?utf-8?B?Z0F3RVFyV3VlcmVpSjFXYkhrUHlrTjQraitqWWtBTCtnWEtPSHBBME14SDFR?=
 =?utf-8?B?RE9QQnJYWXpaN3dka05keFZ3THFVTHlNcWczZHhRdmtFa3J2WUZqSEtCZFJB?=
 =?utf-8?B?dVc4K0tGZnhIbUFnOTIvQTJ1UGhaSVhxT0xXVnllbDFVazhjOGdOQkwweVhl?=
 =?utf-8?B?V004b3l0azJtcHJYSW4vamlULzJ2WEJVYUZyRmNmbU80a0hndG9mZmJBR2pM?=
 =?utf-8?B?M1RWcW5aOWRiL1ZIVEZkYWV0ZDErelU2anpBYS9USXhOcUNDVVI0MkJObklj?=
 =?utf-8?B?MTBaTldBTWYrdDRENEd1RnlDbUp5OXUzTmF0NFVtTmRtbVZqR2dVZHQ3cXFG?=
 =?utf-8?B?SG9OdTNGUGdKTHRJenhQeEdON1hDQlBMaXpZNVpnTGhCREkrSUhOaXlmbUIy?=
 =?utf-8?B?SllCK1EyRVdVdFBLdnVBVllITTlJWkNpazVnRnFvZkp6UUtKSnBYTWpKSExS?=
 =?utf-8?B?T0lkeUpBRHM5RXFWMFlMNm1wU0tnWER2VVRoVUlLUFNKQWhwUEpyaE9FbmpR?=
 =?utf-8?B?TGQvcTFGeGxXNzlMOXVjczRNQlVUU2hLOE4rY1JRcUlCVlhteU5ibTFCbGhF?=
 =?utf-8?B?Mm9ERS81M3dVNjRUQk9Gc2NhZHNNT1dWeGhCTWk1Mm95djA1Y2NmMGxnRzVN?=
 =?utf-8?B?bng3NmNMdmNmdDdLRHYrajhvZW5ZQkUxVHNVOXdZVTBtNWZDRjNSMlArMTha?=
 =?utf-8?B?WlJHbjF0ck96bmhaTDFvRXZodFJMNklQeUlTYXBBT2svM05pczJiQmRTMUNv?=
 =?utf-8?B?c3hnUFk3dmxDMHA3S3AxNVNhakx1M014a0Q2cWJMd0hiaTB4bWFVdlpRTFpY?=
 =?utf-8?B?bTY3alNjUWloN1hCYjY4alAvTXRNQi83SUhQdE1pUE5TZ3JtQlJxWDNVYk9X?=
 =?utf-8?B?U2lVV3RRcVA3c0lZUEZtQmRpQTlSK3FkVzNuR0hvZjI3MWN4YkdKbXZSM2JR?=
 =?utf-8?B?eFpFdmFxbnR6eCtmWG9PR3pmTy96aS8zU0I4MmhucWJlWm9CVHZkckVuU0RS?=
 =?utf-8?B?UDR3ajVUOEtZWTMrQVpaU3Y2MC9Zano1NmNMMTRrU0tzRUI5NTY2aytrQjcw?=
 =?utf-8?Q?bQKnTeV9vaRhJDNRyYIW932r3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e3b62b-f9ad-419b-db93-08dac11181c0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 22:43:36.2788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UhVfT+QsLivKaCmiERAeFKC2ida+wMPQ17ggnkWZF4PHNiOEDYDwqj6z3eh9dwXvhamSMht6Ry2x1RX3CQ0uig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4352
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/22 5:06 PM, Dave Hansen wrote:
> On 11/4/22 14:36, Kim Phillips wrote:
>> The AMD Zen4 core supports a new feature called Automatic IBRS.
>> (Indirect Branch Restricted Speculation).
>>
>> Enable Automatic IBRS by default if the CPU feature is present.
>> It typically provides greater performance over the incumbent
>> generic retpolines mitigation.
> 
> Could you also share some information on how this differs from EIBRS and

Some differences are:

1. Unlike EIBRS, AutoIBRS needs STIBP always-on
2. Unlike EIBRS, AutoIBRS doesn't need to clear the RSB on VMEXIT
3. Unlike EIBRS, no AutoIBRS processors are vulnerable to RETBLEED
4. Unlike EIBRS, AutoIBRS doesn't need
4. eIBRS also considers user/supervisor as well as host/guest modes when
    determining its 'predictor mode', whereas AutoIBRS only affects CPL0.
5. eIBRS also groups CPL0/1/2 together, vs. just CPL0 for AutoIBRS.

> why it needs to exist in parallel to EBIRS?

If by 'in parallel' you mean why do these patches not tack AutoIBRS
onto the SPECTRE_V2_EIBRS enum, there's no big reason, other than
now that I've tried to implement it that way, the number of changes
to bugs.c goes from 34 lines changed to 58, mostly due to exceptions
caused by items such as #3 above, and ignoring EIBRS_RETPOLINE and
EIBRS_LFENCE.

I've posted the diff to the 2/3 patch thread, please take a look:

https://lkml.org/lkml/2022/11/7/1462
https://lore.kernel.org/lkml/20221104213651.141057-1-kim.phillips@amd.com/T/#m78ef9bf6a38db8348e0adde3f5ac8b4953200b41

Thanks,

Kim
