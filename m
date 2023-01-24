Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255DA679915
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 14:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbjAXNRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 08:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbjAXNRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 08:17:43 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7CF45F54;
        Tue, 24 Jan 2023 05:17:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKhVSBur/pVFbEKkam9SP6QjmSxbbxfi6vWOarVilgb81qinBeJsZJ82Om5rSv6BhoAkhhfccl9mi7KgeixOj0OF0Dncpq84xgsc5tcB5jNRouXyT8K0URZxrNd5M48uZgyDhp4afyONNOXPO+ujIu8sEn24rRrtCJyUL6wx+5A3mNwPnawazamFIfK+Qon2ioz+Jh9EO7P9wjPHzqB/vVRdj0sWCQO4FYPeU0a6UQeegTPze96DTGdB8RPArtYrG9Gj12S7I7GpAmCTknKw9p36VUsfXnnrhHTHx1dUcweZxSUx8GmTQJLJfqcMSTKznHn81kKhKjThfDi1la8tow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=005aWiizL8bzSW2kKZ40tK6zCbZpIhxa7NmZ/MGpFiI=;
 b=Fh7ufLVPWFk+NWoVOeBj1IRT6vA1YKrCf6l3vPtc1mJb5XJzfIcxZz8htuvcwMn7GHwbXQMwYIpLgczm4gnO62fZW9Pulw/E9rIINyn6rU/Oqn74eOPhjfPinndK+ZH541RwvIN51PuF4D6BIfxnRmMOxU4yNlXBo8eHom+uN5lJwecuXCVmngjrjetNBIC1FsDLELVnkTHUVLM5VjChYWoivZmkVFp0NKKoWj6Y95xZi/hnvhNlREjdz95O1imveDU+n6pMDpsVCOIKCBBQtDDsBWIx2QISiFOXEecReQ3vG1EjZH5e/sriAi+CN4Owq0wvSQXi8dzJAEtWFmKYMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=005aWiizL8bzSW2kKZ40tK6zCbZpIhxa7NmZ/MGpFiI=;
 b=ODMP8LZOfgWDu8qAI4bIVnkzSJavo0bIzm+bKPmvRXMkK4PaWSE+Z3fr5B6OOQdG0QwEL3xhX1Jx9Cp/e3n/df6EMyiKCWF9Xjxlv6P8G21aPXoKtRD5b6MMhuGhCniW5ZJ7O/UUq0NtJci+FjQk98EKLZDD1iEdQ3qvf7Frp40=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB5655.namprd12.prod.outlook.com (2603:10b6:510:138::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 13:17:26 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700%8]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 13:17:26 +0000
Message-ID: <75aec9df-860c-f1d8-15f1-a401d1ee3c3a@amd.com>
Date:   Tue, 24 Jan 2023 18:47:04 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH kernel v3 3/3] x86/sev: Do not handle #VC for DR7
 read/write
To:     Alexey Kardashevskiy <aik@amd.com>
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
 <ebfcef92-d892-1d7e-004a-1899da968d16@amd.com>
Content-Language: en-US
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <ebfcef92-d892-1d7e-004a-1899da968d16@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0211.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::6) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB5655:EE_
X-MS-Office365-Filtering-Correlation-Id: f1c1cba6-010e-4ceb-51fd-08dafe0d55fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7zNENlGD0+/Q51Uqnd2KkjjWp/nEw4wDaKxV7ltGgVvXhBNDJQg3N51aUNadUFn7awcTQ1mLFLcFRsnhMzy/TuTt09Heoa6Bst+f/vTfQkQC7bWORhtLZ4NEEPTFifqcmqEdWjmqiXtnFriqtSvsV9EAF8YLZ6/Br3wlKKBUfl55YsUTs6oR1g7f93OOkdTRWohcLKwrapKzebr30VKBSq6sat73wzMHki8mf2zANrJmSCsvWM1ZQIySMv5gvAVzkDD2zry8PUAj42tGQRu7pURuggiXAyvVKxvgcY72xmKUIX3fPBZ4Ex53/o1/FSIdu3u5r9U8K1P+erh222dqtVOfW4xNMNYD5g3wLL696Me+KMHmWMX6JuZl9fuPxoWidv6p5TLt2sQSMZx97deJ3mlWKqOZY+yjuktECgT07oM6YfQqdKU3xFzO0b3tUqD38tK6PivBge2s0ghH++TN56baq+E1EOozndVrAG3Ix99GTihyM4paK4To9RN2Alr9q4KW9UeNIbX49X/DYjIioZvlKGWhUSC+Ft+l8OKuYks5WG0qY8rYekH2YSOjrrTOIRL2b8kDp5q6gwbQcMIxLOzq3rnrh2FS1p5UQnXxVlSaqEQxz0DO3CdBnQv9mFdGqkBA4g26MKK1ctvp2WeS5Zr6lxeY1mhDGaplZYYCE0G6EBY9BDY97XHAYV17Jk0yj63puH3+R8t2dE5AqGWA1MZQQlFw6AUVhhUFEw8IeLw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(451199015)(31686004)(31696002)(54906003)(37006003)(316002)(2906002)(36756003)(8676002)(66476007)(66556008)(4326008)(66946007)(8936002)(41300700001)(478600001)(6486002)(4744005)(6636002)(6666004)(6506007)(83380400001)(6862004)(38100700002)(7416002)(5660300002)(186003)(53546011)(2616005)(26005)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnJ0V2pmODc2ZkUxL3dESTBsaFM3WHh1MU15dllHSWZyL09zdURKZGprUUFn?=
 =?utf-8?B?eGZTdncrNGphSUJ5ZEViRktuY0FRM2VTVmxQMS9OL0J5RGRtd3Jua2U4OUZz?=
 =?utf-8?B?MUZRS3FXbEpWTmtBM0huYWFkUWFDYW8wUjROY3hSWll5bGR3aHFHa3Fwc2lr?=
 =?utf-8?B?RTE0RTdyQU9HWTVoS0hmTkk2SWVBTnRva0NiVlFqSk9Odmw4eHB0aXZyRUQr?=
 =?utf-8?B?Y0wzZ3I4eVVRSC9tZ2lYM0ZnNnZhL0xyWGVEQzJmQjNibDBBSVFVQUxyckhm?=
 =?utf-8?B?RXJ2RnFoZUIybDBKRmZ6ZFlYTi9xc0VQc0VWMVRCOG9UaVp0OEtoTFpCOG5Y?=
 =?utf-8?B?VWE2RGM4bDFGU3dVajF5djVSWS82UVRWS0ZpRHdNT3FsNFQzZzl2Tkp6ZkhM?=
 =?utf-8?B?ckNQRXRoMFZtbHJhN3JZY1o1bnBibEhiMmxMbzRTQy9VSE1Zem01Vkg5cTBq?=
 =?utf-8?B?RTFYWVRDRnhlMi9XbWd4MEt3WHh1NjRNNkwwZTFtb1l3QTd4QXlwOFMxYmE2?=
 =?utf-8?B?Z3BadGlwbVlCektlTU1ucUpaZ3NmdmpDNkN0L3ZxZFpLUERmV1J5aHhjNFJy?=
 =?utf-8?B?TWJmeVdhV000eUpMV21TTjVIRWdJaHYzWDVaYXhZVmpDdHNKRnYxT2taSjNW?=
 =?utf-8?B?Ui9SVUs0cVNBQnNUYWlBOTFZYWlIU3VnS3NsQ1lOd3VWUzBzbHpLSkVxdElt?=
 =?utf-8?B?M2xISnBPcitsWTZmN2JweGRCY1NtVGt4b0traVJqaHVYL3d2cHhGWmRReldW?=
 =?utf-8?B?b01XbVZ0TmlWNVFWT1EzWmJzRS9peU1tc3FKbXRjTFJzbW9jNEtROVZTc1dn?=
 =?utf-8?B?elZ0T2tzVWNyYTQ3NTJQTWpNaFZlbC9OdDZDQXhBOHdLL0VJSWZaRWt1cFRR?=
 =?utf-8?B?ZjZKQTUyN0VwVUFFTXFkbEhVVWo3dEFrUm1jS283YTZuRU0zajNJSWl4WmEr?=
 =?utf-8?B?RU44SnRFcUh6em0zM3VlSDY2RTVtNko3cVYxQVJYNVNQRldtdm1jTGJ1VEI2?=
 =?utf-8?B?c1Q5aWdzRG51aWRVWGZEMDZOTDNCTitYRU5TZzVRTmU3NjV5M3Y5U1lQTDZK?=
 =?utf-8?B?VUxkY1dhVDExWmJhbXZLaFJWL2JNVGZEUnh1eExxU2tiSi9TQTN5d2paZ2RO?=
 =?utf-8?B?b0JjbnBUTzdLMnRzUmd5d1BZR2g0SXRoZkw3VVkxb3BXVmhyS1d3UEYyVUU1?=
 =?utf-8?B?ejRIZWJMQ2kvRDUydmNUcnhqOVZGSFl2UkhzTXBhdS96bVlKWnJ5QkZLUnhl?=
 =?utf-8?B?eVNCSm80ZzcvWEJZeUJMaHhTQnZxVEFONldrU2pGMi9CemJrTTRPWU9rcVlK?=
 =?utf-8?B?dzdvMUl5NjhLdXlqMXp5R3NkUFBiZjEzaUczUUpMazN4UXkyMndPMHBEQ1JR?=
 =?utf-8?B?Ym9HOFBGQWl2Tkp0U01OaSs4S0orS0E3WHNZS3M2aFVzaWRBSmpyN0NQVnBm?=
 =?utf-8?B?cGZneWR1SkxGUkZmVEZvUjR0L0pXU3dVZi9oU25HV3ZxMFM1ZzlOMkVScHpw?=
 =?utf-8?B?QU4vMG5DQXEvUFR3OTMyWDNwSVJweXQ0VzlhOVNOZWVNRDY2SHdNbzdZOGVY?=
 =?utf-8?B?NkUvMmJVSVNsZWlTMnh2VUI4Qk0rWnVTclZoRTFhd2llazRSSHpXZXlXWmh4?=
 =?utf-8?B?WEdLTEF1WmNubjZlUTVkQ3hwbzVETkNPcklOVWVSUzRleE1ma2ltaUdsVzFC?=
 =?utf-8?B?aGkvRVRYSDRDUkVCdDR6Y3djNFhZdkZxZ1RyejhkdEoyTXU3dVRwTncxV2Fr?=
 =?utf-8?B?eGhXL1JKZGNZN0t3Y0YyUTJwTDh1ZnVCbDhxbjBBemFSYTRpaTFRUWNWdE5K?=
 =?utf-8?B?QlBFVmc3Qjl6RnVEajRMQlhhaThpY0dhS1lPRytUcE1mU2I4Z3VDUGtSVTE4?=
 =?utf-8?B?WEozZnNaWnlRVG8xNmZQQncrNjJWS3JPUXpyM3ZwL0IvNTVHb3I3Q3NoWk1n?=
 =?utf-8?B?TC9RUDloQWhVV1Q4THJOZFZPYzhmZWs3REJGUW56SnFSU1U2ZXRPVzl4ck9p?=
 =?utf-8?B?K2FOUFpvcDRnMVYya3Vnaml5TUlDMDcxeGpNcDlmZnlYbUJta2tnNnQzczNS?=
 =?utf-8?B?SjRia1hiRDM1OHFEM3RuVkdrZVpqdE1Db2hiSERseGo2eC9aOUoxUTZtMmFs?=
 =?utf-8?Q?xbkM7ywbg6GqU25GLtPhICoex?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1c1cba6-010e-4ceb-51fd-08dafe0d55fe
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 13:17:25.9149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +hJiQgIl6Sr9KF/vsZHMJ3YPNNmb2gxh9aC1YbwVONg0rQkoF1kvXmPn55DAjecZro+LCoDPWIis1ds8iL1o/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5655
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24/01/23 18:07, Alexey Kardashevskiy wrote:
> 
> 
> On 24/1/23 21:37, Nikunj A. Dadhania wrote:
>> It is MSR_AMD64_SEV_DEBUG_SWAP (SEV, not SNP), it is an SEV-ES thing.
> Yes, noticed that, earlier analysis was that Debug Swap shouldn't need any guest side changes, but it does need it.

>>> Why is that feature negotiation SNP-only and not SEV?

>> As per the spec, GHCB termination request: reason code: 0x2 is SNP features specific.
> Does the guest really need to terminate in such case? 

The termination is from the guest that do not have implementation for the hypervisor enabled feature, in this case DebugSwap. 
If DebugSwap is enabled by the hypervisor and not handled in guest #VC, then DR7 read/write can be intercepted by the malicious
hypervisor, which can return unexpected values.

> A VM could just not do the GHCB thing if it does not want to.

In that case, the VM can have unexpected failures.

Regards
Nikunj
