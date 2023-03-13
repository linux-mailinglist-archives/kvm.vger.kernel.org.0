Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAAB76B74D6
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 11:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjCMK5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 06:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbjCMK5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 06:57:22 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A17D5F6FD;
        Mon, 13 Mar 2023 03:57:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SqzpG0Dqotzwo4OLKzXzLGBzD0qCKWT2qC7Z5cvZC4hOX0LwcNCrU5/ezD+AKOILj3B7mV/ZZWfl989ceSSt00jr7lAmQ8G0+lVoGa1rwcBgPsjG72YuQUYSLf3U3iyFKn1/gQKXy7eStC7kKXtRG4ikkTNFMK4uggB7yViegKOdGso2Hys96iZsUPJdKzEBVg4/1pHkjYt2G0VPWO8evIPpaDEk3N2J7XrC8pSiduh4p429OXMJSC04tlQ/T1L6H+akuaZndZlJIILFP6IAlqX8ctg6GrliMAB6fRpKQUFqoQl5IRbPL4hkk3AASkk6SyG4rLsSPG5zNom+JvG7Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gAqZw+yue5lZLefqokK15pK9470MSOyUf1NKyGPgbow=;
 b=OmFA9XkBBclFNMf92JsLJqmWqdHe8aqcvBugH8U8s8GOA702t8BBw1th00IUmk7eSbxtRTIjriKYQsuQHh7GmZ1O+oQpxWefnzYIBd8PzO3bMk3Tpt9LBQZ/yLgRZZkThnLIJfcbndAWNgtrJu1Ii9u/QRmYqfpUYdcqG2bCvrCoqlzVU8QPvAtZ+chlF0eVrHwMoGU7yLF1SQ4oDcKS4kLdAkDN4fB5KxqAwpZLRei1kBX4ZAvUgeHLTX+9HhdSmD7Ej3cvQ3MT/Dy/O/aWWNa7geKjsW1xgdbGOIN9XyV1CCEFzA1pGOL24XXx9/Hx878vQWoq9iVVDe1bgkm/Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gAqZw+yue5lZLefqokK15pK9470MSOyUf1NKyGPgbow=;
 b=PAxaAGeEyLpPuiKpMvcLAfTHQ310DY7DTV0PLjiAfvwlmI9e2Cq+2D6KlZIIT0Z54N48bb2ekRqIwM0OPOFS5Alby87R/6JAj0ZOBTTDj8x088MOe6CNxUYt7EKSbxfW+ZXuRTWZoIeHZADhcLyIliQqBpY64LmGbeZ8GZYwm94=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by PH8PR12MB7253.namprd12.prod.outlook.com (2603:10b6:510:226::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 10:57:18 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::68c:afbc:72ac:54af]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::68c:afbc:72ac:54af%9]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 10:57:17 +0000
Message-ID: <a53c8ba7-f66d-5bd7-c934-2357f42b3ac9@amd.com>
Date:   Mon, 13 Mar 2023 16:27:04 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
From:   Sandipan Das <sandipan.das@amd.com>
Subject: Re: [PATCH 0/5] KVM: x86/pmu: Hide guest counter updates from the
 VMRUN instruction
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ananth Narayan <ananth.narayan@amd.com>
References: <20230310105346.12302-1-likexu@tencent.com>
X-Mozilla-News-Host: news://nntp.lore.kernel.org
Content-Language: en-US
In-Reply-To: <20230310105346.12302-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0028.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::7) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|PH8PR12MB7253:EE_
X-MS-Office365-Filtering-Correlation-Id: 3396222e-f3f0-44bc-61fb-08db23b1b60c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rgBFCOlW/QbM6/EEhcBTg93MRsm5L0dTuwChWP04eZbaSXA977Zb2JOrhVJVJz9ckal8RFaIX6bPR+QGMAmGUDwbaET8md/P5hxIorJO5n7hUS2M6CQYSSh3WX5XepLtuGcCjqkoRnJhYOWlsbnfPtIzmFnvVsu4xcm0aat3NOONpoNSBq/4Ze0NuGQ5LYluIAGxrIQ7XKm3ePrUpmyp41icK9ndE2xAwLLUKay0EL5kxH3vN5MyB75t7L1nCzzSYPZvzOeD6KJYxITTtc65wU/b0SZpLSztRnT65NPssfgnhRjtH7a4BhGcbd6mWfy8VMQlVmwpCwK4Obpafi5J48c7YSWROht5v/PaymviOuX1NtQWZ8KAIS+4gY9vBH69jTHztam4X+mdXq4otP5gr0EajewBUA53QsMW1MP/Uvp0//h24Xdhukd/Dpb6duzi69iBp4CmlHYPmiIcURCV/pLbHpOsSSk06RN37ppD+PYv7HaiZNyrYN5X9qCVb9kXKaEuZCglItQ7QEEHBk4k0YbdCrLlQloBnNFZ5tIKANSH/Ra5R5QNhMzG9qrc5QpQKZ9uwIRPRyauJqH/F1ox9q66sH7ELIlJwcMpm9ohgf454hOvUDPu87rqjl2geOAwgitdoFKIYjH9neNxCRUKMTR02755VHAoEsJmDN++lJ4bZfi1i88tkjArPCrkNXc+aqkYVKXN/JjfS123jDyU+UTF+fl3GG771CggYq6PYNg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199018)(38100700002)(2906002)(41300700001)(8676002)(66556008)(66476007)(4326008)(478600001)(316002)(36756003)(66946007)(6916009)(86362001)(54906003)(31696002)(6486002)(5660300002)(44832011)(53546011)(26005)(6512007)(6506007)(2616005)(31686004)(186003)(6666004)(8936002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1N5bnVrNDhCdGRmMWVLR2tjSk1RdGRaaTlJVGlaNzAxQUlEdVdlUmlJOGxs?=
 =?utf-8?B?RGE3WlpNWEdyTzdtQnB5bDFLSVVrdWp0RXlac1UzZ2x0MFEwNVdoVmtWcDdU?=
 =?utf-8?B?Q2xBZU4vRE5taDFHRStlYU1USlZqYU92T1lKb29KbFR5eGtKODJSRDBpM094?=
 =?utf-8?B?YkdDNzZtdnJ2Ynpkek53aXVYNmcxR0laSUFoaHdNdmJuQm8vcnJ3bnRVK0ZU?=
 =?utf-8?B?YlowSmJrNFVxU2R1N1ZWYWpkaTFrMkhYU1hxYi91OElYeFpiS0o3aUtGUDRJ?=
 =?utf-8?B?c3hLMWc1TkF3d2lxU1FHN0ZDVXJHMFh4KzQyVDVPTklKTXBkd1F2b25kY29Z?=
 =?utf-8?B?bDFseCtvZGk0d2lVZjc5dGhPNnN6dGJGNTkvY3EzU3BIeHFNY1JENDYvYmlO?=
 =?utf-8?B?OW5DSXd2S3JWRHM3cXBtdmFVVTNUc21YRllBYjF5WVgzbVRwb241SmsyVzZv?=
 =?utf-8?B?c1BONSt5K1pRZlBaR3JmaU9yOGZRTWUvTEx6dEFpNFQ2QzYwNHErNkN3WHFq?=
 =?utf-8?B?Z1NMYlBPakhoc1BQSC9XSmx3ZTNoUFMzOTk3WFV2TElUMTJmTDRYUWtLUUVZ?=
 =?utf-8?B?RlN6VFo5bStHL2FYQzFjdURsdk9LS3RjYXNyMk9yN1Z3MW9oMklhMWE2a05R?=
 =?utf-8?B?a3ZCZHVCcUlqWlVaWlBIR05lemEyUFF0anp3d2VLeEo5VWkyelpvMmp2MTlq?=
 =?utf-8?B?TWsvUm02RlNNQi9kUFpFZ2JBTTBOS3dNQ3BKRTFBVzI0NHZod2NOdXFxQWlQ?=
 =?utf-8?B?VzlrT0FINlEyb3pHbUlyYUVtUWhlaS9MZGFtemt1ZEhBYys4bW9SSkdwNHNR?=
 =?utf-8?B?NnUySjVvaWR1Z0NTbmlaMGluaThuVHV5c0tLTzNHUW0vaTJqK25SN3dMUTFB?=
 =?utf-8?B?NEQxS3pIZGF2OXZSTlkrd0NmS2llSDRGQWNwN0hQM1FFTVJsano0TlcvS1BE?=
 =?utf-8?B?ZGx0dFk5WTlCVjhLODlxZzNvTWpzUFppaWdaVVpXaFdRVWpJTUVBalhCY0xz?=
 =?utf-8?B?QVFqaXdYSmdjeUpCMFVnaXNxSjZRdVAzUWQ0M3dUNm5QRlJOMUtkNDhka0d1?=
 =?utf-8?B?L0ZBZFJ3Tmpscmk1MTlvbmVwYnA1UDZaNEs4cHZ2QkhRMDJ1aURVWjZGNFg4?=
 =?utf-8?B?ZGJjejBBYmFGamVKZkp5VnA3a0JOcUx6Z0Z0eDNjTEc2bXdEMnZIUzJHOStP?=
 =?utf-8?B?cHE2aHQrU2lBQlBSM2ZrMVE0N1h0TzVZR2t3U2FvczVaYkVxRU9qYmhDZDEr?=
 =?utf-8?B?Tml6MnN5Q254SWhNN0YrNnNUcFhPK1IvbW9RdHQrWDIreDcrbUt2bkgvemxp?=
 =?utf-8?B?cjVvVVo1UEJ6TWYzelBOcENKcnc1ZVJwUDE0cU5BK2dUNkVDTFhuOVlPUVU2?=
 =?utf-8?B?ZWlqNHFxZHlldnQxREJBaE1GcTZ4cGpZb3hlK3E2ZWs1NjhHYXZBNXlsbVJF?=
 =?utf-8?B?RDVidmVkTy9JRnVaZlV2VmhVWGh0cDB2alRKakdXNUVKRTB1RUJUNG9weC9B?=
 =?utf-8?B?OW1TUjhkQlNTWktSVDFTdUxKbHRteDFGQ3NBNXBYNkZ0cG42b1kydjNrdjNv?=
 =?utf-8?B?SFlUdUQ2T2xGejRDNVM0R3RmTCtzeVhURmFxaEZLYWN4OC9YRVZXT2xWRTBu?=
 =?utf-8?B?aDlOcVdRalMraVpOcS9RWTExa1VWT3dxdTAwV21xeGVrYW1qdUt2T1lPNlo2?=
 =?utf-8?B?RkhYTE9Ic3dCS24rTGJaS1lPM1NkcDVNdTVpQkltaW9EaWVIM3pvaG1rMnNn?=
 =?utf-8?B?aUphdjRiNmhJdmVMdks5OHdGUzF5RDdiM1YxMmFKeFBUWDcvcWNVT3V4My8z?=
 =?utf-8?B?akRWZi9CTmY4NGJFdzdGNDd4QXlqamwwUlNpRTNWRlhSTGpUZ2FGMmhrMW5u?=
 =?utf-8?B?RFducTdRZzM2bE02Sy9PcjQxc2V5Y09iNXVNQW1Tc1hsbytaOGcvaDFkVHdl?=
 =?utf-8?B?cUVHM3lyZDNHTkZqWFJjUVFYbE5CN3lHRk9RRFV2MjJsQjNaek1POWdXSWUx?=
 =?utf-8?B?OVllL3M1U1BYcFR2R1lzYXBuUWIvZlRnNU5VUlRZMmxIKzFkUWEzc25LSVhG?=
 =?utf-8?B?QnF4QVliVUdJaWRSUGZrenhSZW5YZVZvNzBjUHAvaFg3cklEb0QvSktjcS8x?=
 =?utf-8?Q?4akfRNwvclgS3CkLJGJlPgIek?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3396222e-f3f0-44bc-61fb-08db23b1b60c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 10:57:17.7879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EFVNTTUYW7vdUwMNWVurtBUCVP7S45j+wnymMMUCXSFw4yGssaoNr8JqWGhViEJLBMEzMWIVpvEBrR5cwUrvLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7253
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+CC: Santosh, Tom, Ananth

Hi Like,

On 3/10/2023 4:23 PM, Like Xu wrote:
> Considering that developers are more likely to have access to AMD VMs
> and use vPMU inside guest, there's a dark cloud that needs to rain.
> The x86_64/pmu_event_filter_test always fails on Zen3 boxes:
> 
>   test_amd_deny_list: Branch instructions retired = 43 (expected 42)
>   test_without_filter: Branch instructions retired = 43 (expected 42)
>   test_member_allow_list: Branch instructions retired = 43 (expected 42)
>   test_not_member_deny_list: Branch instructions retired = 43 (expected 42)
> 
> ,which is not caused by the event_filter feature (otherwise it's zero).
> 
> After some dubious guessing and microtesting on Zen3+ pmu hardware,
> we found that VMRUN or one of the instructions in __svm_vcpu_run()
> causes a guest-only enabled counter for counting guest instruction (in the
> pmu_event_filter case, the branch instruction) to always increase by one
> right after each vm_entry.
> 
> This creates an inconsistency with the AMD64_EVENTSEL_GUESTONLY,
> where the vPMU user in the VM does not expect to see any counter
> changes due to the SVM transaction at all. This patch set provides a low
> overhead software fix until HW change arrives or simply no fix planned.
> 

Yes, VMRUNs do get counted as retired branches in the guest context. My
understanding is that this behaviour applies to all generations of Zen
and even some older ones too, not just Zen 3 and later. I also do not
expect this to change in the near future.

- Sandipan
