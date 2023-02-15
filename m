Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C36F698580
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 21:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjBOUZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 15:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjBOUZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 15:25:34 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236494203;
        Wed, 15 Feb 2023 12:25:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1CcYLbJF8pfMr0vxEPPsYWBPcTnpvyXvJopktI0u/gW0cdo2CRxPoRcb/uxBDRsyCZ/3dJyiVSZt7axZrOmczhBJr2lgG3llhI3rCP/nb3tnwXUK2oINV3oUWbi0lb+qVpLyL98rMFIrqmFNlXcHmYR0OwKlaJlihFPQCR/+vPw599dFsl3bopM2rJJD//du/hBAQtA9vQM95M4QPvV9pn5E+M4qDN+ly/Flym1EcEjo2LlBVX8Cl7c4TD+VFMeaRE9kkR8OypdWc2Y5kSvfgunOvRPvWZUG0K2gHwIcZ+cfVtkTeI84oZZEjC/Iu2VQjoLZc97T7GyGT0l4hLpKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxz5aZSaYBXZLBKyrBsTSAkpA7jnwaAHMebs8CH8BGk=;
 b=TmamK27OmxBGsVNqiiNDyHa3QeuakXg/X29qORMTlBW419Pei0KxcrWKCV6tRfY8GS8JzaUqUSY28nCd2WhkAdM2JmacKa03MtfkgYhk6jYA9rihAcwmR8jHA8J0ggNAkQKqETeiBZ0bclyI9fFEdd8T4zhRNGGhBRXOYKHgRX3RZRua1tPEttXgLCzXlj0T11jSj2ZdUq5rQCDAxjwqzNeEKU9fBIyi600zXZ3XbLdLAQUuJxZilCArT4XF2RXj6GtwcwWuaKo3+5erv+Rpp0WC2yHJu/4aCa+7HbVmlKr6tS35DDtpogcVBcEtjjDw6vtpLjAGJDgAJ0+c9oHV5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxz5aZSaYBXZLBKyrBsTSAkpA7jnwaAHMebs8CH8BGk=;
 b=yHAPhdvSptJkiC0YIQlySX9AupNY0YWU7ioZ4HINL80NsFYR/7msb+kC2PcItewizGyKDOuwV3lI3r4abkNM2qL6y2BMO+FlQykl+Zn0iTnbkAxVdQ+hQ4yBys+TYbu1tt5KdqI6wBguD9CBxOAT45cDrMKbmehaHecX4ZroBkA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 PH7PR12MB7425.namprd12.prod.outlook.com (2603:10b6:510:200::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Wed, 15 Feb 2023 20:25:29 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c4fa:4cd7:4538:e54b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c4fa:4cd7:4538:e54b%6]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 20:25:29 +0000
Message-ID: <cc671a9d-7633-524b-6d88-d2a980ceecd4@amd.com>
Date:   Thu, 16 Feb 2023 03:25:17 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 00/33] KVM: x86: AVIC and local APIC fixes+cleanups
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>,
        Greg Edwards <gedwards@ddn.com>
References: <20230106011306.85230-1-seanjc@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0007.apcprd06.prod.outlook.com
 (2603:1096:4:186::9) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|PH7PR12MB7425:EE_
X-MS-Office365-Filtering-Correlation-Id: 3724811e-4f03-4a11-5e66-08db0f92c70b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I8v7bkXotKndpVCJfxPIr1PrI/g8u2iJIfFvuXmWExoLU+23do9UHV9nOHEHqQQmpQqaKRTvMhsdv5VjenJ0W7G6S5GpDrpHjPSKetB0mnwEI3J+Jgy7WCEQIpJJnSWjQr7X2+oJ4ZcAZka8J92GlwmsgMaJY7fEzTqXQ4zWFOYxqGKjurxhl65dbj5GLpo7P0eJSKUGmGdTpppyzcysu5Rb6PDA2Qyxr+J+DrQ+qJDCEIsPO+XR1cL+J+0YXS+uUPhxHADOmNIFZS4e8V2A5sSYjJDMR09fhU8NwZnegS5gSz1AW3MlWebl7zaIvcCr8mA5ZoWIxjwkIb8i6WMles+22ABU/dIK4NKvr0KWs0z3Q/oTPeZ1UFgN1tSMmahhUEH35nv2D5MIw17ugn32WOFvTQq6V3DXhDCp91hnMdDShGRm7lzQr70EgwQuuNlFJXmCc07G1//7DSeohopAsQdir3EAxLP7wLfI3fvncZQ5mcqNTJmVwt1CAP+xWIZ41iTEgyOtqV7iHgcItggPe8WEg9awjZX1hatqtIbQWrAuzhWdMt4vjGwnHUshq9Mv0612U3NIHStGv/By52JLdT55SzhN2QZg53hFwM4ctLEefHsU9i26MW+Ge4t5qrDSfHtilBjwtHdlKwow5TteNMJ1Bj6gUTl1guxbYPUm4j+Ff3NWmJY89wayMHiWHTp5RSd+fYybXpamJx/skzg27XRi5qJtAbDhNSqCpLox7dM95yrX9gzU4TNZ/oHNBvreC1CKT4u/iab4X5c7Ig9nBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(451199018)(316002)(66556008)(8676002)(66476007)(8936002)(66946007)(4326008)(54906003)(110136005)(5660300002)(45080400002)(2906002)(41300700001)(31686004)(966005)(6486002)(478600001)(6506007)(6512007)(186003)(6666004)(26005)(2616005)(53546011)(36756003)(83380400001)(38100700002)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHhCNUlnVDNFbjVtSlpEcGp3RjFkajZTUG9wbStUb29vNHhnTEdQSUlaekhs?=
 =?utf-8?B?RkJjczJHU0dQZ2ZaeXMyRmNTR2hLZ3JqQUpRREtKYTFxTVdGU0VSRXBxRlIv?=
 =?utf-8?B?K3N4UzBObG1hN0I1V21XSHlCMTVqNmVDZ2p4dFlYYldsd2hVMldaRDNCVG5l?=
 =?utf-8?B?aUJQakVGOCt3MjlNZk9Zb0Vmd0RkS1FabGxkMFVoUVFxZXE3ZGZGWVNwRDQ2?=
 =?utf-8?B?UGJiY0x5YXkreTcyMWNqTnlJTnRMelhCcHBmTitxUDZnU0tNUmhhdG04Y2pB?=
 =?utf-8?B?bHlUNWtiejdYdUo3RktEc0dpcVJNV0NhTUtuZ2NqbUdwc3BpRjNFRnpGcHlw?=
 =?utf-8?B?SVNMenZPOEpVaVdHOUlRUFRkRHJMRDcySUJXZ3hxSFVjSjI5WVgxeks0Vy85?=
 =?utf-8?B?SXFqdmEvME1MdGppenR0c3pqWjAyOUdhcWRhR2szRFMzOVR1UXpIRDJOMCtk?=
 =?utf-8?B?MmJuMUV6SzhxOSs4RDcyWk94MWR2NFhIUWxRbzQxbkxxTjZ1SEgxSmlMTld1?=
 =?utf-8?B?RE9qd2tOS2hCTHh2bm1Yb1Vqd2lld1NYditMencvd1VNZEFUUERnQm8wOHpN?=
 =?utf-8?B?S2FQN1ZjTlFWQ0cxbmNuOG9oMm5pckwvSXVQV3RSVFEvYW5IVFZqbERkSjhZ?=
 =?utf-8?B?WmpHSTljbGhuSzZEYUs2Q2VsU0xmeUFNK3J6VXpXcVhmNXk1TFVEWHNOaWtG?=
 =?utf-8?B?b3V4MSs3d0RHTEtoZzIxUWNaY3VnSmxwR1RMTitwU0h6Vy9kRDJzLzN3MWY1?=
 =?utf-8?B?NVNSUGxFVWFkVVI4UDQwQ1krSG1hKy9UbmpOOVJINTJyQzJFWVl6UjVDK0FE?=
 =?utf-8?B?a2xBazc2M2MzOGovUzVNc0lQYlFmS002NzNMZmV4RDVqUWZ4d05meFlqdlZE?=
 =?utf-8?B?bVBkbUlRcVRFbStjVEtQUGZieFlZWDc2RENqSCsrZ3RLVHY3Z0o0YW01QkxH?=
 =?utf-8?B?ZGdNb0hsL3k0SmVhVmU5SENhak10MHRtTW9aUUt1SHp2K1RRcGpTbFNEVHM1?=
 =?utf-8?B?WE5SOERrbXNmZWs2cHBpMEJhdmxtaXFLblI2eGZZOUxZdjJQMUtaOGo0VFdn?=
 =?utf-8?B?ZUltWHlIdG9ES29ZWEpmZFJSU1VybXRkN0p0RWx3dFEwaFA5bGxIWlhUZzZK?=
 =?utf-8?B?MExsT0ovVEd5TXRNczFwTGlabkdwQW5DdXpTUS9KbkVZLytkeTVUaTE2aTg3?=
 =?utf-8?B?bjloWTkwQTdUWFpzaTZwOXJ0d0RtNWZ6ZUFxdUJtK0lnZUcwM0s3U1l3b3FR?=
 =?utf-8?B?ZSt4OGs4SDZwbm81amR5cmE2Ry9XdU1nY0NpWDZqQm9DTVhVa1RGUkVueWcv?=
 =?utf-8?B?WGFVdGRNYVdiTWhQNkczUEtpWHJzNE56VlFIQWVzaUdCTzJlTG9rTWZmZWFY?=
 =?utf-8?B?eVlEbjRDRXNBdDJaekdqYlc0d3p3c3NhZ1d0MDV0NU9COHltaW5IN09rekF3?=
 =?utf-8?B?YUdWYmxhcmFmeXNTUnptT0JvTHZjdnhDVGNKV0VRaVF0ZmQ2ZjUzazNjOCtY?=
 =?utf-8?B?MVdMc0hhZzEyY2UrM1U5VmRXNTJteTF1UlBaSWU3UkxSTHJQeTgyS01qUGdy?=
 =?utf-8?B?ZzhRazAzazc4TjR5U2RGaDh0SXlhK05FN21uYmQ2dDRZVUJLOU9pQk0xT3hG?=
 =?utf-8?B?WndPbzNLZ2ErUDY2OUVpWDEwb3FZYm1lOUVTNTZUbzVTb3ZNdEkzR1dLRExZ?=
 =?utf-8?B?MVFUbERGSUROazFyVWszOW0zWjRoZkswcG85Qmp4NkhKMnNjbmFMZXl5VE9J?=
 =?utf-8?B?QlFNenJIcUNNbithakQ5dXg3MTZlRElXdnVJTEVwbCszdmN4Szd1MUZoOHEr?=
 =?utf-8?B?cUVIV21NMUZKcmdWeEpKL0ZpekM1Yzk0anNia3JDTm1SMk0vejVSc1ExZXdD?=
 =?utf-8?B?bEw3anlWeWlUclMrYmx6RzlGaFA5REFuSjVaaGZJK1c0SE5QdHZOSnVEYWZh?=
 =?utf-8?B?c2d0NldtYWNmUW5PWVk3T0ZScXJFM1dKOUpjNEhxM1BydUZnejBuUWxxYm5O?=
 =?utf-8?B?VUZWOEsyRFllbXpkMk16c0RsTkM0NXFaM2pHTTAwbk4wTzBEOE5aN2E5T0Yv?=
 =?utf-8?B?NHRaYUtxV001WU04aitweUpxSE1DZ2YwUHpEVTF2bGRZV2puNmdkSDJOWmsr?=
 =?utf-8?Q?fSGGgUYQH0786pkOhiqf2ugYw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3724811e-4f03-4a11-5e66-08db0f92c70b
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 20:25:29.3369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kUKNMpd76M+yRTKJ6aluntegx7w71/l3h8kD8/Njdk5aBx6oecI57yfOrumcxPVzhNobHq+Up8+XKoOrbwKfIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7425
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/6/2023 8:12 AM, Sean Christopherson wrote:
> Paolo,
> 
> This is a wholesale (and hopefully a drop-in) replacement for the patches
> in `kvm-lapic-fix-and-cleanup`.  The changes for " KVM: x86: Inhibit APIC
> memslot if x2APIC and AVIC are enabled" in v5 are relatively minor, but it
> led to multiple conflicts in later patches, i.e. a patch-to-be-squashed
> wasn't going to work.  Let me know if you've already done a lot of
> massaging on your side, shouldn't be too difficult to generate patches to
> go on top.
> 
> The first half or so patches fix semi-urgent, real-world relevant APICv
> and AVIC bugs.
> 
> The second half fixes a variety of AVIC and optimized APIC map bugs
> where KVM doesn't play nice with various edge cases that are
> architecturally legal(ish), but are unlikely to occur in most real world
> scenarios
> 
> v5:
>    - Fix even more bugs! [Greg]
>    - Collect reviews. [Maxim]
>    - Don't use an inhibit flag for hybrid AVIC. [Maxim]
>    - Fix an LDR cluster calc goof in the AVIC code. [Maxim]
>    - Drop a redundant "ldr == 0" check. [Maxim]
>    - Add helpers for logical vs. physical optimized map calcs. [Maxim]
> 
> v4:
>    - https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20221001005915.2041642-1-seanjc%40google.com&data=05%7C01%7Csuravee.suthikulpanit%40amd.com%7C266a9838dbb74b5ac6fb08daef832f65%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638085643969977723%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=%2BUOZ4e1Ov%2BwPkKTSe81P1tPUtxpEr2uddkhMn73kLhQ%3D&reserved=0
>    - Fix more bugs! [Alejandro]
>    - Delete APIC memslot to inhibit xAVIC acceleration when x2APIC is
>      enabled on AMD/SVM instead of using a "partial" inihbit. [Maxim]
> 
> v3:
>    - https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20220920233134.940511-1-seanjc%40google.com&data=05%7C01%7Csuravee.suthikulpanit%40amd.com%7C266a9838dbb74b5ac6fb08daef832f65%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638085643969977723%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=usZ0dheeVyhBJxLP2ahA1hUlN64gwAPooWR9jnQcRyQ%3D&reserved=0
>    - Collect reviews. [Paolo]
>    - Drop "partial" x2APIC inhibit and instead delete the memslot.
>      [Maxim, Suravee]
>    - Skip logical mode updates for x2APIC, which just reuses the
>      phys_map with some clever logic. [Suravee]
>    - Add a fix for "nodecode write" traps. [Alejandro]
> 
> v2:
>    - https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20220903002254.2411750-1-seanjc%40google.com&data=05%7C01%7Csuravee.suthikulpanit%40amd.com%7C266a9838dbb74b5ac6fb08daef832f65%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638085643969977723%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=olaieXGtEfg8K6wwNHjHRa0aRit0npXnoxTmnfR%2FhqQ%3D&reserved=0
>    - Collect reviews. [Li, Maxim]
>    - Disable only MMIO access when x2APIC is enabled (instead of disabling
>      all of AVIC). [Maxim]
>    - Inhibit AVIC when logical IDs are aliased. [Maxim]
>    - Tweak name of set_virtual_apic_mode() hook. [Maxim]
>    - Straight up revert logical ID fastpath mess. [Maxim]
>    - Reword changelog about skipping vCPU during logical setup. [Maxim]
>    - Fix LDR updates on AVIC. [Maxim?]
>    - Fix a nasty ISR caching bug.
>    - Flush TLB when activating AVIC.
> 
> v1: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20220831003506.4117148-1-seanjc%40google.com&data=05%7C01%7Csuravee.suthikulpanit%40amd.com%7C266a9838dbb74b5ac6fb08daef832f65%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638085643969977723%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=d9my%2BQJgnq3673JLC1YFgVSNz1zlSDi7x537abArwS0%3D&reserved=0
> 
> Greg Edwards (1):
>    KVM: x86: Allow APICv APIC ID inhibit to be cleared
> 
> Sean Christopherson (31):
>    KVM: x86: Blindly get current x2APIC reg value on "nodecode write"
>      traps
>    KVM: x86: Purge "highest ISR" cache when updating APICv state
>    KVM: SVM: Flush the "current" TLB when activating AVIC
>    KVM: SVM: Process ICR on AVIC IPI delivery failure due to invalid
>      target
>    KVM: x86: Don't inhibit APICv/AVIC on xAPIC ID "change" if APIC is
>      disabled
>    KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID mismatch is due to
>      32-bit ID
>    KVM: SVM: Don't put/load AVIC when setting virtual APIC mode
>    KVM: x86: Handle APICv updates for APIC "mode" changes via request
>    KVM: x86: Move APIC access page helper to common x86 code
>    KVM: x86: Inhibit APIC memslot if x2APIC and AVIC are enabled
>    KVM: SVM: Replace "avic_mode" enum with "x2avic_enabled" boolean
>    KVM: SVM: Compute dest based on sender's x2APIC status for AVIC kick
>    Revert "KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when
>      possible"
>    KVM: SVM: Document that vCPU ID == APIC ID in AVIC kick fastpatch
>    KVM: SVM: Add helper to perform final AVIC "kick" of single vCPU
>    KVM: x86: Explicitly skip optimized logical map setup if vCPU's LDR==0
>    KVM: x86: Explicitly track all possibilities for APIC map's logical
>      modes
>    KVM: x86: Skip redundant x2APIC logical mode optimized cluster setup
>    KVM: x86: Disable APIC logical map if logical ID covers multiple MDAs
>    KVM: x86: Disable APIC logical map if vCPUs are aliased in logical
>      mode
>    KVM: x86: Honor architectural behavior for aliased 8-bit APIC IDs
>    KVM: x86: Inhibit APICv/AVIC if the optimized physical map is disabled
>    KVM: SVM: Inhibit AVIC if vCPUs are aliased in logical mode
>    KVM: SVM: Always update local APIC on writes to logical dest register
>    KVM: SVM: Update svm->ldr_reg cache even if LDR is "bad"
>    KVM: SVM: Require logical ID to be power-of-2 for AVIC entry
>    KVM: SVM: Handle multiple logical targets in AVIC kick fastpath
>    KVM: SVM: Ignore writes to Remote Read Data on AVIC write traps
>    Revert "KVM: SVM: Do not throw warning when calling avic_vcpu_load on
>      a running vcpu"
>    KVM: x86: Track required APICv inhibits with variable, not callback
>    KVM: x86: Add helpers to recalc physical vs. logical optimized APIC
>      maps
> 
> Suravee Suthikulpanit (1):
>    KVM: SVM: Fix x2APIC Logical ID calculation for
>      avic_kick_target_vcpus_fast
> 
>   Documentation/virt/kvm/x86/errata.rst |  11 +
>   arch/x86/include/asm/kvm-x86-ops.h    |   1 -
>   arch/x86/include/asm/kvm_host.h       |  52 +++-
>   arch/x86/kvm/lapic.c                  | 319 +++++++++++++++++-----
>   arch/x86/kvm/lapic.h                  |   2 +
>   arch/x86/kvm/svm/avic.c               | 372 ++++++++++++--------------
>   arch/x86/kvm/svm/nested.c             |   2 +-
>   arch/x86/kvm/svm/svm.c                |   8 +-
>   arch/x86/kvm/svm/svm.h                |  27 +-
>   arch/x86/kvm/vmx/vmx.c                |  58 +---
>   arch/x86/kvm/x86.c                    |  29 +-
>   11 files changed, 524 insertions(+), 357 deletions(-)
> 
> 
> base-commit: c04ec04c0d15a51aa33660be175ed978beb8de0c

For AMD AVIC / x2AVIC:

Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Kishon VijayAbraham <kishon.vijayabraham@amd.com>

Thanks,
Suravee
