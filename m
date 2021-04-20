Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524833661B1
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 23:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbhDTVib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 17:38:31 -0400
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:37089
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233724AbhDTVi3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 17:38:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VG/uK7S4iarNoqqPi7YeQjOxedGiu/b6jRcH/qokISTaRq2N9QDPJeEvHWEfb6dCrTYskDaq9YAj5prN42bcBMQ1P8WE4ySVGyxVUneconoAaTLD1y7BnPhIIIh1bOoxtcLPDnIummQpMG3nW2yJc2v4SnbBiSUp4sRp3WDjJt4A0/cS2uOxko4u3xrdUt14U+ITainHX2+nOcBQjAJ0RRoFP61PabAe9N6VtmS0znKKjnEiXVqVB4njpAQTAgFKHnH/d95hi61OmzeFJ40bIrHtXTcddrZEfrwAlz1N5uV+/Bvg5rLiiBZYjU71MZbTnguMpM+oSBCCzrPcxRk01A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2F7jS+8xw1le4cWjk5SI5BpfeCtMdqbT3AneXzYAzI=;
 b=NxzJs93r+xgVRpfRDV5IHGrNqausdKTYpoDs6ycC986OV0qAWKCdfYUszUo/PvRXiomWHIe+DRcgViWxAQTL+rEdMxve1Sp7La0YS+vqP0/7GtUthbC8r/tbdegHErZAVt/0Szo/8uHe9L1kUibgc50HQ6hg63et40yIr8iiJ3YSWc+2/GKhcPI05J/zFI8FspK3kyT3cBnp4LmvlhwU+S5c9cU0JMVvbgsMCzt73F6hdiQBYhWUgS4Qbg8D92dwOMd8NuZR8L9NIrhGTjMtX1SgQL8gVWiMoZcE3zMKphoCxXDi0nn7iKl5MN/17WpK4Krz+/FWv+DRf2Uw7InkMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2F7jS+8xw1le4cWjk5SI5BpfeCtMdqbT3AneXzYAzI=;
 b=kqFm93irmwFWSp6TqwlRu8jJNXj0yuldGKoefRuU8VDLHBYJdJSf3YXLz3NMf0gigHrryWM2DLkX4ut/gf3RSB70huhoCgAGWYOlDqz63Oz6r9xelQJADukPba6tInRXSExMSQcXwB0kCNVG3XNEBcLpz9fU7olFOHkuLoyIyDk=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Tue, 20 Apr
 2021 21:37:55 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 21:37:55 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
        ak@linux.intel.com, herbert@gondor.apana.org.au,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part2 PATCH 05/30] x86: define RMP violation #PF error code
To:     Borislav Petkov <bp@alien8.de>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-6-brijesh.singh@amd.com>
 <20210420103232.GG5029@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <e1657ea1-6f6a-b284-c2ff-26bff3b890b5@amd.com>
Date:   Tue, 20 Apr 2021 16:37:53 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210420103232.GG5029@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN7PR04CA0157.namprd04.prod.outlook.com
 (2603:10b6:806:125::12) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN7PR04CA0157.namprd04.prod.outlook.com (2603:10b6:806:125::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Tue, 20 Apr 2021 21:37:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3f030c6-e497-4669-8e73-08d904448f01
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44152C6CD393BFD31625C2A6E5489@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yjuk/oOrfzSJwAUv3dCFqAlMBpWCvGq37NqwIw4qojxpu0WSei+SWw8xIy06/KCtaCnTCIiPMvn3miLuV91WVYxP0v1mllZ86RM2VUIxUZppTr7BK1a9AzIismkiXEKwAA2rEKdRt5k4UxGmGQOr8ezi39WY1cdhYDsyF4SOu19/thUpzUtjUsxC62Nlurl9GFRpA+8VkRb1uBqIXkuNGuO0PKyCP2vkW61Kuhn3tBT3pi6Ae9IWH3mzoHsmR3QQ6d++/m+7NHO7EXEYRwO3YNYF2HFyI7aAgcmCaG7rzk/+5+zMM+KuYEqgbnBvbXSc42hfOI6DkDBeNIqstEtqG2iStFaUXSNtPNvdFP/tHVlHL1yHVelrZtPDsAxwzzKu6690Gs5z/SSIbNJtaozwhZPFe8oqMixBMGL2uWodpJh2IN/fvzHGiITa7Iny5fAlBfWQsBe0vONqTbljxtfMAIEdKhG1/ZbeNfS6f5STM5IQlnrncYbTxo5r4DOpNvpPJNqF2yqENvwigbbh0Z2bQDKZRMuJxUpm8rbAG1gTCkuSpMyObl8dt1quhsbBIAUc3ZSAODoapPHx2F7+R+10Mw/ioY2hae7WlvuyfPVPeLoWROxO4LoSdl022rLSJGNUtfKgRm9eIsp9AMx81TWbDFgxg8Bfg2mPNboz2II0V9ToN0PfIxXjURCLU3am8vjk6vbxawDAqRU3g0PMCaH2ITdw95gvFkD4tT+LldklNo0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(8936002)(31696002)(6916009)(38350700002)(54906003)(2906002)(86362001)(4326008)(6512007)(956004)(2616005)(316002)(8676002)(4744005)(38100700002)(186003)(52116002)(26005)(5660300002)(44832011)(66476007)(6486002)(66946007)(31686004)(36756003)(7416002)(66556008)(16526019)(53546011)(6506007)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NHFBYzExbjVhZkhGNzNDdmMwdWE3djJlMGw5aDdBNHprcFN3WFh1QUF0Z1BL?=
 =?utf-8?B?MDNBM1g0RDREUHZEaG1IS2EraTR1NkFjNmw4OUU3T1JvSUt4L09tWHA4dkN5?=
 =?utf-8?B?UmJ0TTN0L3ZMY2R4RlN2eEN4MUxJRy9sMm1EUzhwV3d0Qng2RFVqeitjWmtW?=
 =?utf-8?B?TUlmZ01qQ3k2UEdpcmJReE9PMENvWTYzOWV0amlkdHlmcmdqdC9KT0w5UnpB?=
 =?utf-8?B?K1M2ZFk0OXZuSVRQMEJaZjFNQ3ZGclIyYzYzSGtFL1RlLzRpL2NGcFo0alpT?=
 =?utf-8?B?Z280V1pNL3JRMWI1QmdkVGZPajdMdDUybDY3SHVDblJwMnVUK1htWW5ZMzJL?=
 =?utf-8?B?MHR1ZFNlcHkycE9KVHQ0dXlrd1lTR3ZSRkJYZFBBci9uNWVqbXp2R0h6eWdM?=
 =?utf-8?B?dkJ5MUVINUw2Q3BhWDhsL2hmK25JSjJYdWFnT0VNZnJ4Q3YyaWVEL1BDNVBL?=
 =?utf-8?B?SjdmeEtGUmV0WXpLOC9Helpkanp3MlJwUkRCM2VOUlV1ZW9ybkRVa0NWWXUv?=
 =?utf-8?B?L2VIUmJBRnpZcGptcEkzb0ZPN1gvdHZjcEtzUis5MWs4NGc4b0pRK1lPbGpu?=
 =?utf-8?B?UjhZVU1LREtUZ2pjRzZwRTVMWCtMc2dOWHA5OEVaL3hQNUtFa3VrVFIwOFho?=
 =?utf-8?B?RlJZVmtUeDMrWTNmY3hicW0zUkRUYW1RYkZ0eS9RMEJsVHBFSXA0SHpRcHJx?=
 =?utf-8?B?RWMwVytaSmg3QnhSV2lVazJHc2ZxdytZcEEwZ1ZYSWhmWitzWlBoNG5SWjlq?=
 =?utf-8?B?dzBvZ3BNYlkrWkl2VWptYm53VjkzR05xcU15Y2ZKYkxjOGZyZEVZTnc0VVMv?=
 =?utf-8?B?WEF6SmdodDJxNjlmbGw3VVltNHVVOWo2TjBHMW9PdUprczhmaGxaZzArL2JD?=
 =?utf-8?B?b3RkWGZaR242RTFxTUpPcjlVdytFRUVKQkRmK1Frdmg4SVJEQ0ZSUys1N3lw?=
 =?utf-8?B?TU1GNzBCd28wL3BHdzRrOUg1TW1VcFhMeTNHam1kVFFXRmllU3pSNVR2OHBX?=
 =?utf-8?B?S2hod09ZK0FaQ3M2K0U5eG9ZSVV4Z2dTQW1IclRVaVF1WUt3L0FDVWc3Rm1t?=
 =?utf-8?B?czFMeTNmdkd4ZEF4ZXBPTm96Ky9FbzZWUTdSNEFMZ003bEJZWElYWnk2WXhU?=
 =?utf-8?B?TDdybW85YWZzS1J0MFEwdXRwbDA4MWl1eEpyVzdVYnVBTmhTaXVPaHJwQlNq?=
 =?utf-8?B?ODZTeUQ0Y0w4cGNNaWE2a2E2ZVAyQTl4cmZIWmIwem5UN2NFUDFOT212SndV?=
 =?utf-8?B?b3pjTldDWVVaRXJ6QVJVSmRFaWc3dTdpRjJQSW9PQjdsY2NTSVJmVWNVTFAx?=
 =?utf-8?B?TndDd1dCTit0WCtPYTZjVlJXZDVCanZZN2kzY0luNEFjcUlzL3JYTVlweTdZ?=
 =?utf-8?B?M0txMkRESmlvN0FPT3VzVzJ6a0hnU3ZLekt1SldXcWVqL2htL1d0V1BrSU94?=
 =?utf-8?B?VFpVZWdlT1NVV1ZHMkVvMWNSTThvbmJXc1k4K0kxZUlmaUJMMHkrNUQzblF2?=
 =?utf-8?B?ZENlRi9TUS94UURMd1dTUTdiNTdOTGNrK1FGUVMwQ0xiRjRhcFQycmRxTGlv?=
 =?utf-8?B?Zk8vR3RLRGpHcjNYMlEyckI3VkpVcnRjNHdqQWxsa1JOaWh5VENLREd4eUxP?=
 =?utf-8?B?RkFTRnMzcmg3NTJVU0Q3bGdSb2pZd0RjMGh0N0ppQldzL0NFMHM0YTNURExU?=
 =?utf-8?B?YnJOajdEVFVKOFNKOUxGOUZGZGtoN0ZnZTNkdXdqRE9Md3NkOVk1UEV0ODJP?=
 =?utf-8?Q?JHxHPOXsfSMaPAOBRYdg2dN0v7ys0ItPV349lov?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f030c6-e497-4669-8e73-08d904448f01
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 21:37:55.6255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: embsApI95c0g95UmdFxUHHpOA0I1ohstAap2LdoWv+dQ6WMTxZmVJCaXC6S35qkOxqmnAtkSqNmtp1LMRVJ1qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/20/21 5:32 AM, Borislav Petkov wrote:
> On Wed, Mar 24, 2021 at 12:04:11PM -0500, Brijesh Singh wrote:
>
> Btw, for all your patches where the subject prefix is only "x86:":
>
> The tip tree preferred format for patch subject prefixes is
> 'subsys/component:', e.g. 'x86/apic:', 'x86/mm/fault:', 'sched/fair:',
> 'genirq/core:'. Please do not use file names or complete file paths as
> prefix. 'git log path/to/file' should give you a reasonable hint in most
> cases.
>
> The condensed patch description in the subject line should start with a
> uppercase letter and should be written in imperative tone.
>
> Please go over them and fix that up.

Sure, I will go over each patch and fix them.

thanks
