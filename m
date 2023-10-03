Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C417B5F4F
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 05:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjJCDSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 23:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjJCDSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 23:18:13 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D47C6;
        Mon,  2 Oct 2023 20:18:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0Hshf+vj34dIa9W1oM1k7iVoSHV4uR2UPncCZtx68JnosQxiW+QtcCU4fBRCmASADugA7GQhiR6PniAQbl4oiK2fef6IKlhGrqKQln/ZAsf9INYeoL88r5laCy1RMoWfhcsVEfpY/17B40xxT0LzzDgkyuLLwxN2aulJTYJcRqFUlbRuUmNn67y23rlhHZQnpRxA6SF/He0mjKySnq0+ve5U+x7fnchiDqB36oBXXL8FMAR2CdFEGD3VmRKNOV88PJmGhKdjgEoGXo6XK5geQ/UQiHLo3380koweb2A5aVtTlwkFDqUiIDxt/gYMuWr4jRXmI1wkMg2F6RuMOALkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7XChy435b5eAEiQ7fld7t3GS8EFlHEWUkhTnEg0nNk=;
 b=K+tzxkcxOlUcP+/tAY2PqKQ8PK6vgrI6wTkrfdjfMa69b5rL5BvxNtR0WeKaEzCTox8NEPvadYQgogwV2dtAd3Nw/MywEzahgHOwXE6U3z3AGcTWtlVXdO141N7MUGPdRhsASwaqaIJuNkKjNNSACcSQmdXG5VOU+TtWCPiw/oVpmSXZFuSL4rkNJXIpPuZ8M07ynnMWoP1dsXnA3dZ9pXmXDN0lODJw3VjpUqPMxiLceVu5ewRgiqDbHzR6VgqhEbyLeF9rSGD2KvySB8nm2tigpSKz7ZZ/XEQab8MPMlEnb1Z8MjXI+Y26rgQFmrhZTS/afbNCVb9Xh3p2THD8Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7XChy435b5eAEiQ7fld7t3GS8EFlHEWUkhTnEg0nNk=;
 b=C1R2mjbzx0NZ3uM7ThmW0Y6/zHoKYxIL1lwgVKDeXZoPLmtPOHCmA+iPiqOaZlw6VVfc70HuaHUAsPN509SE3bqSWJB1Kmm6o138ZP2Tj25KvZlHTBN/jSMaaUsnlNNo3eLxbPke/NCzoeN7Gt5a3WiPsrfW9Jfv8za+XheR80w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 IA1PR12MB6115.namprd12.prod.outlook.com (2603:10b6:208:3e9::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6813.21; Tue, 3 Oct 2023 03:18:05 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::90d5:d841:f95d:d414]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::90d5:d841:f95d:d414%5]) with mapi id 15.20.6813.017; Tue, 3 Oct 2023
 03:18:05 +0000
Message-ID: <23912b0c-832a-fb68-adb9-f82779659d22@amd.com>
Date:   Tue, 3 Oct 2023 10:17:53 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v2 1/4] x86: KVM: SVM: always update the x2avic msr
 interception
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>, stable@vger.kernel.org
References: <20230928173354.217464-1-mlevitsk@redhat.com>
 <20230928173354.217464-2-mlevitsk@redhat.com> <ZRYZMr4fuaywW7fP@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <ZRYZMr4fuaywW7fP@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0239.apcprd06.prod.outlook.com
 (2603:1096:4:ac::23) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|IA1PR12MB6115:EE_
X-MS-Office365-Filtering-Correlation-Id: b6f9c93d-09b5-4980-8672-08dbc3bf5bf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: niMCApqidC318Zip1poGP5FXpud6ESfQRIYSj9nQSEyjzmrRAKjGz4fmfkqSdC66bMIn9SbN4Pu9zQEzTfpK7tb3BruQ2MhKLM03PC8xq62nGvQLlQoYbCEbukvFOxOL5TjiadojaL5HKl5iujffa4/S63d4G30mo1dzQKv03W8hWHsOUL3Cbwa++04IbVd5zIY2DfH2BOPeA6/Ukg1EXZcbKmlPAKd5G8y6Cm9HAd62DTPiBZCma+Gq/mxnp97OWGShkIMydEPkh6hlvNJWe6AsLT8ZtKJ0EfaCuOtV81CByDnH8Rj9omw5tbBmZAarU1IVvYkxkbytIIvPv6QLAOYq+ruhtGSXUjGqml2X1egkxqUP5byNTE2QgPSxXDAO6mZoRiEDR2n1Rzxqed8fl95aJNkS4csdgb43xsPKQ7mm03Zj+lrphTQtxosLaVr5+LtPn8DWfOG+igLUbev0LIxkqEwGSuchPA9tlmznfktOA577O9D4sKWjuTF2eB1ymq7IuZzfVToRP10Vki+tbW05/yXiF1Pr6HgKWX9N2NRQsb8xuTRXpwArWHd7X03edxq4R4hlZUHS8MKmMJROBMaki0XEat19ERZiHLMOxUCfGGFvn5zAIhhbCxSflZmvdJbsHLz93CAb87wYnrFjGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(366004)(136003)(39860400002)(346002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(478600001)(66556008)(38100700002)(6486002)(53546011)(6506007)(316002)(41300700001)(6666004)(66476007)(110136005)(26005)(2616005)(66946007)(8936002)(8676002)(5660300002)(4326008)(2906002)(54906003)(7416002)(31696002)(83380400001)(31686004)(86362001)(36756003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2k3bFYyeVFkQm9oaHJ2VjNjR3dmQjZVcDVNbmF0L2c0WjBBR0phRDMyWTZZ?=
 =?utf-8?B?R2h4L1VjL2hRNXROeE5ISC8wSHlvZXp6OENiUWdrNXNpckpKUUtDeGdJS2Zm?=
 =?utf-8?B?QTZ3NHJtbmo0VmxwVXNseG1Vd09WMk05WmVISGZ1Nm1CVGc0NkcrTWFKK25H?=
 =?utf-8?B?cXFPRVhiK3Jrd3BZU3hKUHRqdEZjckszeUNiSXltUG8yZDhoaWRxSEhUQXdi?=
 =?utf-8?B?cjQrcDhZUXFrMlZiQ3NjY1dHN0JQL3RjUnFWby83YWZZTVp3REU5WFRJUzdU?=
 =?utf-8?B?SW1tN1lsK1orekNxNGFXNkpkaGRUVG9hSGxrK2VIR1ZySlFSTEsrRiswL21G?=
 =?utf-8?B?RWxLQ2N4b25PVU9uZ3dLaEtXYXhqd21Sb1lEOUYzK2dNQzNnQ2JVWlpmVTNO?=
 =?utf-8?B?QnYxbXkvOGZoYmZzRVVXa3Z5aTliRWx3U1FVSFdxQ0ZKQUJrcWY4WGRRZmFD?=
 =?utf-8?B?NkpwS1pMOVdvbmUxQXdCS2oxcDhXZjI1QlZmUHAxaFJEK3hDaWppdVRZRFhK?=
 =?utf-8?B?WE51d2lmOWVLWFdoRDNzanU5WlQxV1FOOHNvWWFiMUVuUWphRXhqZjA3Wkxp?=
 =?utf-8?B?RjZRaFhncFdkMko2WklPQ09FZC9pdDFlcElNY2JteXUvTXBTUnVCTFkwOW05?=
 =?utf-8?B?ZGpncUxGcHJ2SithczNLWVpobUtHNEc5SzR3Q0FyL2tuSm9HejVwaktxcHNL?=
 =?utf-8?B?U01Sb0dtZ01kM2UreS96T2J6NmU1bVZhem5LYW1CcWh3UTdlbE4weEZkOHkw?=
 =?utf-8?B?Y3h0aklYOEpxcjFtTG9RRCswUnN3VzE3SEZYalhXamtUUHhKOWh4RjFSN1lJ?=
 =?utf-8?B?ampWeUNOQXVjek0waDdaTkN3eERYc1R3c3B4OElmMEdEcXlLK0hIeEtRWDNX?=
 =?utf-8?B?dFh1MzhGaE5YZTR1MlhpWnl3VFpzbEtCRDV3bUVnUVhENk1Pa0R4aHBwVlR0?=
 =?utf-8?B?R1E2T1p2UEZPVVdlZ1hLQmd4c2ZaOEhHeThSUVd4MW43TXBxTW1ISk15ZGlE?=
 =?utf-8?B?T3RndDFPV0pJZ3FNTC9TSlBsOVAzb0pXRE9ReFJuY3dLbFllNHVGeWZqT09G?=
 =?utf-8?B?ZG9lVTgwdEQrTHpBZnZRR3c2VGNEWmhLWUcxVWluOHE4OGVWWHJlL2I1RzIz?=
 =?utf-8?B?T1gwUExmV2ZIUzUwRHZpZFFrMEU1b082NEUwQU5nRENNMnJCSHBYcElrN1JI?=
 =?utf-8?B?eG5ubmdhbjBkRWFuV3hrOWpkZG53L3NFcktNYjE4bEVwQ3hZbUhvV2prMkJC?=
 =?utf-8?B?amg0WUpqQXRsdVVDOTQ4bGRseUg0TVI5aysxRUQrWHlrUFZneFdhMTRYNGhH?=
 =?utf-8?B?NE9POXEvT0tvV1FidHp1OEpEcXJIZi8zdS96cjUwNlVGVHBMcHZjWllmakN5?=
 =?utf-8?B?a2sxMVRrRnBnL0Y2QXZPS2w2WXBHNGJqMEtHbHpMQ0l2N3hyVGk5dm9LUGdK?=
 =?utf-8?B?bXVXdEdwRmVyREhYYm00aWh0aEVWT243blZjOVBLem9IWnVYZkhHaktmOEw2?=
 =?utf-8?B?T1ZDMmlXK09sQ1pjenVkK3hGUzVuUWxYTFFFaHN6WXZ3ZDZOcVc5bkgyM1Uv?=
 =?utf-8?B?NTZucnc3N2VmNldFOC9uNzZCUXpVa29mVk9LTDdXYytMSDNhL1VIV21OVElo?=
 =?utf-8?B?RWdhM3NJNXZoVDUwMEZRSHFCOHl6S09qRVBoMTVvb3dTUjIzOGhFeTZRdWZJ?=
 =?utf-8?B?Y29aTlBQbzRjeVp6cmpjWENWZllIMENXc2dFc2oycDl3c0RCcEcvUnQ1UUdt?=
 =?utf-8?B?ZmkvRkswekQ4eUJoclZIbUJsa3d0bWR5WVcwZGJkSmZITFloQkhOOG5Ibysy?=
 =?utf-8?B?MEM1aTFhRHBuUlIvOXVaZm1Ub0pOVnduMkpoVkxDRG5NbEhJT1YyM0J1M0Jo?=
 =?utf-8?B?RlhFbWdsNDQ4cHoyOTV0cDl2T2t1bGJEbituMHdhQ0IxeWxnRzh1em1UQ0t6?=
 =?utf-8?B?ejZCVTY5dG9vWVhRRDN1dC9Qd3VidXM0L2tHbEZCUVQxU1k5c3ZMdW9EUkps?=
 =?utf-8?B?OVBlazM2VGtNdEtrZVNsQTE0ZXIvWE1od1BDMWpsRERMa28vWWJ4ZmRLZU1K?=
 =?utf-8?B?Z1k5Um4rdC9mVXYzbWVsVXRVY1Q2dmFrSFAvWVAwekxjeHJjQnk4eCtoOUxY?=
 =?utf-8?Q?pEmcQBrhb9bnRjK7uEGYoitAj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6f9c93d-09b5-4980-8672-08dbc3bf5bf9
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 03:18:05.6138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TS94Hk1ZFw4bNqBbgg9xO1M1S5o77r/Gu7Hzc34xrBbP99D5L5p6KjcTXxIN106F3NbLjLnc8j+NoEDZAs+7CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6115
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim,

Thanks for finding and fixing this.

On 9/29/2023 7:24 AM, Sean Christopherson wrote:
> On Thu, Sep 28, 2023, Maxim Levitsky wrote:
>> The following problem exists since x2avic was enabled in the KVM:
>>
>> svm_set_x2apic_msr_interception is called to enable the interception of
> 
> Nit, svm_set_x2apic_msr_interception().
> 
> Definitely not worth another version though.
> 
>> the x2apic msrs.
>>
>> In particular it is called at the moment the guest resets its apic.
>>
>> Assuming that the guest's apic was in x2apic mode, the reset will bring
>> it back to the xapic mode.
>>
>> The svm_set_x2apic_msr_interception however has an erroneous check for
>> '!apic_x2apic_mode()' which prevents it from doing anything in this case.
>>
>> As a result of this, all x2apic msrs are left unintercepted, and that
>> exposes the bare metal x2apic (if enabled) to the guest.
>> Oops.
>>
>> Remove the erroneous '!apic_x2apic_mode()' check to fix that.
>>
>> This fixes CVE-2023-5090
>>
>> Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>> ---
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
