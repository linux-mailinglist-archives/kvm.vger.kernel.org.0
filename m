Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6CE642ED2
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 18:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbiLERcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 12:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiLERcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 12:32:10 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1141F21E22;
        Mon,  5 Dec 2022 09:32:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+GvETJoeLU6wpDal6GGfNEzBaXCicufWyH6AOmJ8wPAmIGnv+LfTWCUXYrTLRENx3IRYw45JnWhrFL96S9yzEfM4qDsbnhjGl/tByVhMKRibt/TecKy7/Q5pYnJPYF/n9AkrL4m95gxCJYm2C4eH0xCFFApU1v8xQIIcwiNzTSBNsGPp9iv1AndGtwIZq55+Y2WTKqMH1KSrtFnLAOQVdk2s8IlBrZtZ1+MQgAfjwsGrofb0M/87l22foK1J2RUWR/M0uVxIAVB+C04K9jXsHeZiQfV4Q/k9iLg17XFbQ0jC1i0ryFEw9/o3mvs3dY5optOPpzQxkOPrFFtrX1K6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PD/KHhXH4XHKeOEzm3mxy/2noA61jUBvtB4ZgzlvAdE=;
 b=mZj943XZKURJ198EWFsqgSVXyeRPYN/yJcBTi6zJckEI2fJBDbWzBr3ktkBSuak+Klpe6D+kW6G77RmbFlMaylRk5QbgLaA7AtiF4tOvHtWWDm6kJIgQyK7aF7jnG27s2Lo2z4lwMueOKGUHQ6H5OcDgsvrYn+xtHRVNCZtlcmOfjo3SUInnzk8xX5QdcTsPuETPhZPVLK+0KoQ1b8dXpkO4o2MPDWlyPj+a5AZiEeL1ZI6P2EZn7Q0h6VeO29jkAiFSfx6EYeb81+dnQ3YT6uuwWX6PSkymAHkw58rx/QwFlI1k9synkr3HOQmOJoxbt5BoQvaQFvfDcf64hGWJLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PD/KHhXH4XHKeOEzm3mxy/2noA61jUBvtB4ZgzlvAdE=;
 b=vTlh5CjWez7viOpVuVlwtshMfYetUULvLPgjQK61XJNnS1qM549QKqt7x+ITsorpLkNgel77Ua3ycYeo40TlIpEpYy4eEg6C6f3EWg3VhyNidS+zKwrS0lkEfjc3gwhOLzcR+d9RIqRZTipRPjcL9gUegxLI2eR+rptpf9wsHQQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 IA1PR12MB6627.namprd12.prod.outlook.com (2603:10b6:208:3a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 17:32:05 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::818b:be51:fc53:5adc]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::818b:be51:fc53:5adc%5]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 17:32:05 +0000
Message-ID: <53393726-5a8a-1a13-c620-32c65872278c@amd.com>
Date:   Mon, 5 Dec 2022 11:32:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@suse.de>,
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
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221201015003.295769-1-kim.phillips@amd.com>
 <20221201015003.295769-2-kim.phillips@amd.com> <Y43GpD9fgnOGNEcu@zn.tnic>
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH v4 1/7] x86/cpu: Define a scattered No Nested Data
 Breakpoints feature bit
In-Reply-To: <Y43GpD9fgnOGNEcu@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0011.prod.exchangelabs.com (2603:10b6:208:10c::24)
 To DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|IA1PR12MB6627:EE_
X-MS-Office365-Filtering-Correlation-Id: da76b207-1107-4653-6b7a-08dad6e6a0c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GwH99tcYWdT4qbjWoDbmwi2fnCJkEZb1ctxONEMd4uZVDXPwA15VYutS45J0ixCGKs3b1Io/2kw4znMIn2yIDfIPow5n2bk50U4QG8r8De14xJBPtEhzJ+d/qfyrFDLWq0Pmhwcs2+V2Y1cEg1cVR/W40ga2UqaMzzrVqCFLZToalc8hK2f2Q6tEJCUD2d6vvI/ddXXjG3Z3J7C6qDx/z5W9EybbpOoWvbOVq9wdA8IvP5ge5XFVQCbnOBqcIYMpTx7c5hlFQyv1Vt7f6uE4Bk/85rWzJ64C8IUQA8m9j1eKESu718QksYkSp8K3Q4uU+o7LZqlYgDwTFe67PLmhBgHDKtW+n4ssI0HqTxg3UctnmKos0Xt5e0XdPzwYA8kn/ve+XdOoFmM1L9olzm76CqNpIWFkfA5Bj2Lx2RHRF9o7SBS7O+Z929A91BCj+9b7Hr8u6m0he3FCsfatB3DanxHn1fWJQO5kNyu3nysIk3G5xXsi6QTAacBRfrw/crtgK0JldvU/dRvRTmAVtL7L35VI8H2g3b1JMCXB6uKppniTSStMyZi9JZol3VXp/DlgeWg112TUsXkWYXZ137CJS4E4v17YNzuJELWT38051cUV6oMQuNfeNDvQ06+ZSv1ofld98IREFqxYTCsRPJ8Sj8fDLCametZuFtIBC1/fjj4Xf7V64iyscidU/FJUX2Oq45DZppK3lF+D6OiDdJQkCWWqS8DxuGGB9TxfHTGhnpk8P/PUr8Qym705x7A24yoU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(451199015)(36756003)(86362001)(31696002)(966005)(53546011)(478600001)(6486002)(6506007)(66556008)(6512007)(4326008)(7416002)(8936002)(41300700001)(5660300002)(6666004)(8676002)(54906003)(316002)(2906002)(6916009)(44832011)(66476007)(66946007)(26005)(2616005)(38100700002)(186003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjRwUjNMTkhqRkNIRjNMc1JyakVPcEJuQnhiUTZjTWtzRVUvUWVpZzZ4bDRj?=
 =?utf-8?B?SEVmNnNLYjNXVnFaM2pRVVhUT2hNNERTUFZQc1ptWGsxQmp5aVkxam45UHJC?=
 =?utf-8?B?ZTIySzhCWmdHTVBOaGdVUTFTQTdrMWVsZENJZmgwRG1jL2Y4MFNiQi91UHFl?=
 =?utf-8?B?cUdDdisyQmsrMWlMTVpib2ZxOThPYVoyWGlMM0psd3JTOG16OGxJTmM1V2pM?=
 =?utf-8?B?cVYzTFNXZ3JNNWRzYlZhczdQR0J0MXgraUhYMmpqb3c1WDlabk9QVGVmQmpX?=
 =?utf-8?B?WlV4QlVnTmQrcDlBUFZnc0IxL0VxLzhQSSs2VnNvVmlSZFpFK2lZSzEwMjN5?=
 =?utf-8?B?aC9pWGZZM2RiQ1Fxam84V3BoeHZLMDhnNE9vT1Bkcm5XUHoyUW92aTRlYnhD?=
 =?utf-8?B?Rng5ZWplb0FzZUt2dlhvNFhYb3c2eXlvS1Q4TzJkT1JNUVM0SGR6ZTB6Q3p6?=
 =?utf-8?B?Wk96WE1OZy9RNTBKa1c4dkxvVDFmSlY2b3RqK3pRTVdkd08vTjI1TytSM1ZQ?=
 =?utf-8?B?cXBxTUdzR0M1T0IvU0djd216clNYWmhyelZuZU5pdTZpRGxWVUFZMktTZmlJ?=
 =?utf-8?B?TEh1UVRsTkVTcnMzeTJYWDJiYWNwenNJR2E5M1kxMldJUko0eE9vMERJSlha?=
 =?utf-8?B?UUJCdDJINGF0aTVhYXJHd2lOckxSQW1Ib2Vacnh4bW1mTDFhUmxOVThTUld5?=
 =?utf-8?B?SGhMMXdLZnNESEFoTWR0cDhaOWlrYm5SSUFFemRnY2ZuUjBtNnpGbXZNZ3pw?=
 =?utf-8?B?MXk3c25rTnMvdEFzUUgyYUFuT3BxeGtiNVUwOUZmazBWNlk4MEZ5WXRaOEVG?=
 =?utf-8?B?b1J2R1ZQQzZwa09tZTVydzRqK0dLQUxzQlp5dWlWSzBjSEdSQURucGp3djEw?=
 =?utf-8?B?QkY5WllGS2NDRVdhWEtBM0w2dytlbFBMVUR5SDIzTVhQNFFUV1pzbFlieGI1?=
 =?utf-8?B?bUJYclExNE5pU3p3QnhFZ1VHNDZlYWpvaklEVEtFVGwzRmZiNmR1ZkxHWENy?=
 =?utf-8?B?TWljYklQS3F4eDE0RnpySVFzaG1jeGtXR240WEtNbWdFVWh3SDAySGxNaUJt?=
 =?utf-8?B?V0h6Q3lMa2NKN2ZvZGJkSEpoaVZ4SDZGQmtLUmptUHdoSG9yQlN6cGgrYmVP?=
 =?utf-8?B?eVhJcWduaXhIdjVnQjlUN0pWYkZIekVBdHFOdzFJaHJQTFVidi9vdVRycUZo?=
 =?utf-8?B?am1rMFBEWlNoOENHbmhuR3d1c08wekViandJWkNvZVF5d2VsRGFrWEkwOTdQ?=
 =?utf-8?B?V01nMGRFamdnYU11SXdVeVRROHRMZHZIVW1KdkdrZTdVWWVlY2d1MERKUlNi?=
 =?utf-8?B?ZktEWFNUUWtFSWoxNWdmL2hpRXJ6TEd4SlVBckhSN2V4dEk4NHM2M2FvQmRJ?=
 =?utf-8?B?MkR4dTBMVDY2dzc3WEUzY1RXeU5OR1VDaUxCVlVyYjZadExmbDJzdThWaWcx?=
 =?utf-8?B?MkkyMFd3anVscVppWDFEWHJQQ25uUC9xcmFGRkJnUUFsUExsaytMeWtWNUsr?=
 =?utf-8?B?WGJyVnJUMEdmRXpwdUFETXdGclhjYWpmdHYzZzNhZWkrMmxFN1g2REFCWGdt?=
 =?utf-8?B?alVJNkVaVnNGazE1eU9XYmg0dnplMEdhSWZ4bFI0Yy9TMkNqVFpzeHR6b2pX?=
 =?utf-8?B?S0p1U3hpODQ0bFlxMC9OeHBJai85cVl5czhsTEwza0xpVVVOYk4xeWZNcjZq?=
 =?utf-8?B?WXd3WlE4czNRc0hCWk1ZL0hQZm1pd3NsNjVqYnZxQkN5Y3loTE44NjNPZk5s?=
 =?utf-8?B?alZCZ0VaT2ZzYlhyYzlybEFUQ1hjMkxmeUFQQ0ZhL1VwQnVjQXpHVGJseXpF?=
 =?utf-8?B?SkNIQ1NXZFEwZDBMeTZzUWZHTXV5OVVSMDhJcFBlK1FTWUdaZkxkTUNPYnlZ?=
 =?utf-8?B?ekpPbDRldEUrMTlsTlVwcHphaHdITzBPZmpjaVA0Mjg3YlRwOGVoV0tlb0ZI?=
 =?utf-8?B?QXZZdFo3Q3JhMDBxRm92VENPMC8vTjQ5NlI2bFNWSnMvd05NWHMyVUJjTU5w?=
 =?utf-8?B?dXdRRkZ4R1YxaTJxRG9YSjZYLzB3T2tGakFybWNjbjIxbkwyTGRraGJWV20v?=
 =?utf-8?B?QmwvaEtWSXZodWsvSGg4dkZyUjVRM2VuQ3VDRG5JWEdsazFtaVVkUEgvK1hQ?=
 =?utf-8?Q?dR6HA1bzT5PeyL5siQu1kXcaJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da76b207-1107-4653-6b7a-08dad6e6a0c6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 17:32:05.6557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MJHViIdnbou6TBDV55RXDQAst7oxGAvU7tEt4evjzMRtKo1naPkuPblXdE9iX+6ygz/Bfd5SUKp1N9V2XsrUrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6627
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/5/22 4:23 AM, Borislav Petkov wrote:
> On Wed, Nov 30, 2022 at 07:49:57PM -0600, Kim Phillips wrote:
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -307,6 +307,7 @@
>>   #define X86_FEATURE_SGX_EDECCSSA	(11*32+18) /* "" SGX EDECCSSA user leaf function */
>>   #define X86_FEATURE_CALL_DEPTH		(11*32+19) /* "" Call depth tracking for RSB stuffing */
>>   #define X86_FEATURE_MSR_TSX_CTRL	(11*32+20) /* "" MSR IA32_TSX_CTRL (Intel) implemented */
>> +#define X86_FEATURE_NO_NESTED_DATA_BP	(11*32+21) /* "" AMD No Nested Data Breakpoints */
> 
> Right, what is the use of this bit in a KVM guest? Running perf tool in
> a guest would use that bit how?

This is starting to get off-topic.  Propagating that bit to
the guest was originally added by:

commit 58b3d12c0a860cda34ed9d2378078ea5134e6812
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu Oct 28 13:26:38 2021 -0400

     KVM: x86: add support for CPUID leaf 0x80000021

In the future, it will be used by:

https://lore.kernel.org/lkml/20221201021948.9259-1-aik@amd.com/

to allow hardware swapping of debug registers.

If it can't be used in the nested VM case, I can remove the
guest propagation code for it from PATCH 4/7 with a Fixes: for
the above commit, but this 1/7 PATCH will remain.

Thanks,

Kim
