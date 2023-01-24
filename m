Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8239B67982B
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbjAXMiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbjAXMiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:38:07 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A957F2BF13;
        Tue, 24 Jan 2023 04:38:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6eD6Hc71b2LPXtljRkHdylQ6McSDOLd83nqkrxM73vGHqf3754TW0eYIdZueHZKxnGuNJuS+iyTJmjFNI/QmFeWbN8Q1LDMAuBO0jV9oXJyYQScUFOdAkyeiqKN6ShZlLMnvXbLyuc+yxMeaa7r0tkzw+J5fxGPo9yKgSGGfFikEx1/m7EYxV+GJRN94JBKY6Y8wLMWZvn9yXr9ZCNrCS1FMib/sRDDP/VxOqXwAVHdwOQ+NNbnX9+4ijJUgdAfYyj3EnO/eHqwcm4ikTESkBF0xoiz2AmKY6stb7q9zzEfs2oB6nER29xVPOhPPkqPrboeG8/3CI0K2icg5UURMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5l98okWjXzpJC2jgreim6oKS74HYHxqe/sbMMV7JTzo=;
 b=lephXDNetLJ5XmcqTavjd4Z+3MDztn6ZtXpww7wQx41p6kfIEttpppctFrYRCGKsPLgve6UWr4x/5AlUlthkkgDJDnKBv03K0XlrldCi+rYuDZ+0WOQyuQ95nAOmgIoGBKSqZzDVLMl0QIYAbbpMdzk56HzPKsyOeu9bUY/ivRgeI55kWe0wZXp4OIad4JL1cL6yXixi9yRNVP4ROGHNWkUCxxB1PTZycEcMEYoT26bU9aARgWt9FL3Dq04z5Q6fGoirzsFASCeJZ7XbxSeyMn4jcTVmOeVxXMXICS7EZFeOHgC1raso0Cnb+KPIfzcIgHjbYYdkBBIMjdBJamJ3/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5l98okWjXzpJC2jgreim6oKS74HYHxqe/sbMMV7JTzo=;
 b=S+WfBF57dCudE2XC9TX8yArZh4hs0DJeXXLUmO3+5enXzdWlhlfzE/pEiOhuumaFxHpHtJtfkMeqUbh+uOLUH5LQGgt7pv4m1+yIHrOXvSKTsRh1eRxN7roTRuUTNHgMlJPMwGpPQU8SOB2L/M0+b0bXzp1Cddrq9oHiiHwM25I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 PH7PR12MB6979.namprd12.prod.outlook.com (2603:10b6:510:1b9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 12:38:03 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%4]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 12:38:03 +0000
Message-ID: <ebfcef92-d892-1d7e-004a-1899da968d16@amd.com>
Date:   Tue, 24 Jan 2023 23:37:46 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH kernel v3 3/3] x86/sev: Do not handle #VC for DR7
 read/write
Content-Language: en-US
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Yury Norov <yury.norov@gmail.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20230120031047.628097-1-aik@amd.com>
 <20230120031047.628097-4-aik@amd.com>
 <adc11ed3-de89-a389-e629-3c951257469c@amd.com>
 <533c5c83-b68b-eff0-d36d-9963194ab844@amd.com>
 <b30d6f61-2dc9-4c4f-dbdb-a48c186745d3@amd.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <b30d6f61-2dc9-4c4f-dbdb-a48c186745d3@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY0PR01CA0010.ausprd01.prod.outlook.com
 (2603:10c6:10:1bb::14) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|PH7PR12MB6979:EE_
X-MS-Office365-Filtering-Correlation-Id: fc6d7d0b-3c57-4f44-ac90-08dafe07d566
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yaZQGFjmA1DXfdWn2oJXTzdDmYTLVRMpSON1rNQ7yT3ziP5aIU0LcTwFt61sGgfqkUmjXLBe4io2NTlBoZ/xwq5T1T4Zz1q5tRWcFX6wjIYLdhTvi9bW79D2SWD5Gi6oOtZ8wNY9XBHKAa9wKgE9Ne+1AzmQLb5D9EUokOBnjbuUwYLw6tHlYtVItRs3S2lRHufuIWeig0EO1mShIee3gtQ9r/jC1olSY39uLAS7kbRGsjvghVP4G08XuOwJ7ub4+69fX9J5V2jKOGSl3vujYnoLAUyBk4q1gam9BN9ShcasXjc4dXKXos3uxIOfN9zchKWKFZ2f7YremUxUvyLTJrSVZQJvWUZj7fXAv2HrXUVoZA4uRkPv10TQW9Qalhqe/mK4LYEHuRg4GBbZ8+kjNdm2Rovl/CCxlOvgJJ1Uoki4gsEQauGWMOA6IsG8zzfD4jUpdD/vjV0bguHRvfQJbsBMsa68WB0U1++LS/n0a3QRlA5jAAmtis6RIeNlKfzK1gN87I6Es3FomGpQUbOGFHCK/ZqDAZNbQEeo2N/To9h9/cljx7M+edyirOmM747KesUUjHIWeysDpupSDqWK9aiP7te8NCF+EcfDuBkWW4HpH1CyvcNDepp2+xicLKcGBkbeUlVeJwuT9IjhATz0fbzYpEZysY8c5N4Y2bu3lhxzvU4dPCtuf+eRA5oSibirVMwWcx2Evm9EcsV0doJUFwsTEfq7rTDeKaiOcUhsmC4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(451199015)(54906003)(6636002)(38100700002)(316002)(37006003)(2616005)(5660300002)(8936002)(6862004)(2906002)(7416002)(4744005)(4326008)(66946007)(8676002)(36756003)(66476007)(66556008)(31696002)(41300700001)(83380400001)(6506007)(478600001)(6486002)(6666004)(26005)(31686004)(6512007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGdxaDg1Y21ycm9aM00xT3JsWExRQm15R0g5OWRkMjBaWUpkejNuMnNXbnF3?=
 =?utf-8?B?NlhSeThTd243Qk5zNTl2YnQwM2hyY1pTRTk2dHhkWFVpWWFYMmZnekZHemFM?=
 =?utf-8?B?aWo4MFhZUXp4aThibVBjNmxOb0xVVWh0OXZYWFhLYU5OMThOSlhOamFhdzk0?=
 =?utf-8?B?TnpXR2pzOXlaT0V1elJvN2pJb05qUjdpK3NVdS94VzdRSVJ6TGtHeXo3V2gx?=
 =?utf-8?B?ck5NejNPVlRPUis2bTdlbzh0MmpOUWV5My8wOUkvbUNuV2xuV0prUkdQSEYx?=
 =?utf-8?B?MCtlN2ZIR3RDYWYzZURQM2hSQzRUS09EaGxRTUxLa09CVzBCeFBwbnZFbEQ5?=
 =?utf-8?B?RGxrUDAvQndzTXU2R0Q2OVNhSmpNSGcxdUFmcnB3TDJYUVEvbHlxYWdLbFl1?=
 =?utf-8?B?UFlhaExEc05XYVhCdEN0R1NIV3hnbElqb2VmVG52eEFIbkZndWRZVThFVUVJ?=
 =?utf-8?B?T1dYOWxXQUF1RUhLU2FnUFRiQWNJUmVvQkZEVGRsOHljeDhsSTlJNThMRWI3?=
 =?utf-8?B?cndieExPZUVsL0FQMGZZVnZaZ0JuRjNRUkx6b3RqRUNmdkNneWZhdW9ieW95?=
 =?utf-8?B?TjFTSTNkTXVndzJWenBLWDRNZEplOUVRQ2xjWFprWC8waDNhck9Hc28yek05?=
 =?utf-8?B?bitCcklUZXlqMkVTUFZMMmZOaWQzcWo2Wmg5bDNENG55RjRZQnpwbWtYaksy?=
 =?utf-8?B?K2FnK2ZxK05lanBJMStvV0lnL0ltZFpsZTJZSWpBK1FBTjdGYUVkY0N2RXFR?=
 =?utf-8?B?YW1aZ0RlQ3JkYnAyNENmVkNsL2V4c3h6cHUxRmFQYXNZWmxtRW9tVUQwNlhn?=
 =?utf-8?B?bFNQVi9ObDdDMGE2c2t2UWh0Y09pWlJ0djdkQTMwMDA5Y0JVM2pWQVcwbHZh?=
 =?utf-8?B?VXF0TVB4TnlTNWJZNHV3M1l4UVZKSyswVHZiK2w0YThOVGthd3lPUUVmY2pI?=
 =?utf-8?B?clJ0OWVidDErTUo2THowVHJ1OGFBS0I0WEFHNStMSFQxMFZaOWo3ZE5tb0R3?=
 =?utf-8?B?YWNHeWFNYWVudklEb2c3RkFHRGhDUnk2UmtFMHE3dDZyRi9SNGpuVW1ad01B?=
 =?utf-8?B?TUNadnhPeG5aSThONFdUbytXOXhJTnpDU3VRVU50aXNjZVkrZDJYNEN0b0t5?=
 =?utf-8?B?cHg5UXhrZzl5eEI2dmZpWVNnVkJiNVVscDlIQVpzVmIzUlkzSGRJOWMxcGdJ?=
 =?utf-8?B?S29WSUIxQm5FYmljdkMxd1RBTGtBRFVQWDVHVWw2Z3NneTlhelBIRTdDallv?=
 =?utf-8?B?d2treWYvOE9tV25mSWRFRXY0OU83bE5DS3JEZjBuTURpaGEyT1Jja0toQlU1?=
 =?utf-8?B?ckd2N3VhdCtUbVl1L1A1Vkl5dnRVT1NnRllVTTBhdG1aWnFUN3lHcTFxMkdJ?=
 =?utf-8?B?dEFGcEZIM1lCQ2tCZ2U2K1k1OEQvQWhVSDcyL0JZdCtFYkFLUGZ6bDFWS2Mw?=
 =?utf-8?B?OXdENHdVVS9wb0kzcm10ZDBaRGcrVUZySGRjOFU2RHR1ck10VXM2RnQ5c0RP?=
 =?utf-8?B?U3dtWFRJaXpudWRxVFNoUEw4eGVoTHpyTU5jcEw2U0QwYURUR0xKNG1zMGpP?=
 =?utf-8?B?SncwN3FGQWJQdUl4dWlpNElyRGlmeW1NWllUSHorblg5U1F1STRYYU50VU13?=
 =?utf-8?B?OC9QN2lhZ1NMMFNkS2taMVc4MU9iZ2M2MnBQeGpQc3JuczRlQjlOdjVUQi9t?=
 =?utf-8?B?aXdmL2t2OC9xNXU0WG5saFFFcDJWSnhyNFlxNDdGalNKVTFEd0FuUGF2M29z?=
 =?utf-8?B?dWpmNnlqdWJSMUs4RThtVHU5U2JpWUZhM1VjQmVZNkYwYnhMZHo1Y1Y5Wm9N?=
 =?utf-8?B?dGJJSis4aC8zUzlKeC9PckJ1clRsUkxXWmNwL0ZuR0lGazkzTHJCUFkva3NI?=
 =?utf-8?B?eVlRMGtwaHdhdHpSU3Juc3BvQkFpWCtXck9ocFRqTkttWkdyYWl2eTNaeHFu?=
 =?utf-8?B?blBPVVNUNmdRZW82ZzZHdmx2Y2J2MXF2OHk4dVRSdWdjbmdpY2NFeGFqdzZX?=
 =?utf-8?B?QVNYZU5mQUJmWlE3YjNqQ3FqT2hQYktaYTBkUjA1dVMwQWpXVzdNaTB2VmNY?=
 =?utf-8?B?OHE4d0RZYzBSWFhpbUk0NDJ0dllRM2kxeEE3bmdGOHl3Tkl5eUtjV3ZCU3Ix?=
 =?utf-8?Q?VUfXnOFCX/Q9WmsEvn+88C+WC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6d7d0b-3c57-4f44-ac90-08dafe07d566
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 12:38:02.8754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9dzbxJQKY8I672qmDQCFIvFl0hcnNKcKLprubApA3Q231JtP4QaYNNDghk52FEW4mtVti8DrU0gMHp2m6NrRgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6979
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24/1/23 21:37, Nikunj A. Dadhania wrote:>> It is 
MSR_AMD64_SEV_DEBUG_SWAP (SEV, not SNP), it is an SEV-ES thing.> Yes, 
noticed that, earlier analysis was that Debug Swap shouldn't need any 
guest side changes, but it does need it.>>> Why is that feature 
negotiation SNP-only and not SEV?> > As per the spec, GHCB termination 
request: reason code: 0x2 is SNP features specific.
Does the guest really need to terminate in such case? A VM could just 
not do the GHCB thing if it does not want to.


-- 
Alexey
