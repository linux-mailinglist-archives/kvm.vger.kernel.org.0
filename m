Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D07B62AF27
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 00:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237567AbiKOXK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 18:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiKOXK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 18:10:56 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8955A2DA9D;
        Tue, 15 Nov 2022 15:10:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3HcQL2+oISd3Wz+gL+49MyZLtc0Ogcl6i5gq4cBdDN/abW2/YyP6ozXz1sPvsu17htXdRp+72aK03HHxti6oMM6XFDkGzljBV38FD/ebKMP+wcqPenbEQCLabMqy5Y0+c6wsWooTnCAWd3zxAmBjbxQQ6EQxahCQHsiAjO7icvtXJeaZz5MAQF3a4BgH1l+DjAEwNgFzRNyXU7JSfcaN55yURJDpLjIJQvJq3d3+oei2z6vNYFe01ONrbXoxY6GzK/0IHWmlom/R5L+IvwhWRhvrh9SOPMJt/NFOao1yvMMuhrWOSIAyM3hJ/USCs2nZ9ZCHN7o68FB6xMWWFgouQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ju5/SFE+oKuPReCzkHUrn71D81lvbGjOsyrbiXPCsLU=;
 b=Jk6Go3TB/VMl+JEsjydtX9YB59CMghE0CfVnY5uElvoVn3ye+E1MyAVP1muiz2IncsnFeGrTUPjQ+PJWhGirDK8ALBrqMG/n0ynmLh2TrxA/WsYIrNT1oeA3z7hBM1ayxytbw69htjtE7gQdXkuqSE7IvnJdOpCDQTawK97cyp3JEBY6qc3I3seemPWwoaqaqJ2sNt+w7CxHFYpIEy5XbGvIf+G/1gZaDVfph3uAT4Chhl7csEcSOQNrx7Fl0aL/OpjmSs4pFG/qqE5PXAtyCDUfULSg/5hZy05Fyh9esw6f2Voh38qcUgA4Ua4DPATWLcWmIlik51NO6qOk/L0glA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ju5/SFE+oKuPReCzkHUrn71D81lvbGjOsyrbiXPCsLU=;
 b=dmZ1RlkVh4PT4ECUbQtDgnbyvRG3psFPpXCbRsierO+joipNXy1YEsG9DjptbLvFgM4PFWSW+mykXsfdhOrtzOd6PjolrjTj8O+wkW8iKiYQvxxcssjHYXKaueWkXBax5haFOS/BVtoAc0h1YoEMpvXnnQnfUHUDwYlWH6fY+u8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 LV2PR12MB5751.namprd12.prod.outlook.com (2603:10b6:408:17d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 23:10:53 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::818b:be51:fc53:5adc]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::818b:be51:fc53:5adc%6]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 23:10:53 +0000
Message-ID: <c00b1a65-c885-c874-79cb-16011ac82eb3@amd.com>
Date:   Tue, 15 Nov 2022 17:10:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
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
 <20221104213651.141057-2-kim.phillips@amd.com> <Y2WIy2A1RuQE/9SK@zn.tnic>
Content-Language: en-US
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH 1/3] x86/cpufeatures: Add support for cpuid leaf
 80000021/EAX (FeatureExt2Eax)
In-Reply-To: <Y2WIy2A1RuQE/9SK@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0429.namprd03.prod.outlook.com
 (2603:10b6:610:10e::13) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|LV2PR12MB5751:EE_
X-MS-Office365-Filtering-Correlation-Id: 89736896-56b4-468b-2649-08dac75ea4d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uLk2/LPppBRg6elZ0XVo7uLCPqLuMZ4QnFdGrdS9cJZApfz7LgjTWfP3NvVec9sMRPzrM+EOXZ+2wVgGYQ+Z+KUowaoctyAm1TNoq7zsQTfJfYoqWxIs9FTcDARBjtp58/LdtjgwKhzZideg18vw/cgi4CN4KH5lfGDslUbiHsUGt+ympANxw3Ez9UQTM7MEUpkzZD3JMegJqaOMOhvgZxG0Owq+CLCu982UE/UVQcxBzh7xPXFeDxA671htXmMsEM9lTG/yDjpgw7p9kQttf8PRlx0/bjqKn/dxTuCPQLQR3m1RuKw0oH9YwbJFYDTpHTZaH4YEHoIQ5iuT5fiWz2hKEjIEvD222FNMAJu5yp0d/bmKbdO/Wv792zh63ufn57XypL9hJt0htNo6Wi2nWaTuXptNs5rUKCGsHFpHWR/oUI+DyURltorgKI79m3H/2Ll/ZMu7GrVF7Fl+EIc+qLDyaLxhQqqHXl+n1hO08IdTplWxNh6zCOG7pwlSG3eUClsgltvbeswpVqc7OtvsawvgxSep9bKYzPHCW9VRjIHaAg9XqLfqtmaz7Cbby3CXKWQEYtTXR+6AzU3FmRtrOx2+qsG0Sf6em0FAFG4ihi66aljX5kf1uHsdkvX7lO3YeSQ08h8syXvWtBfErTmxP9iG1Ih8EN3DFiFfA03FhvoHdoGjRioNGkzhWUIYtN5S9HYllne21WjqGHMB8B9m9vNyw0/0XlZn6ifFi4b9AjG9wuaZXt1zDepGhsOkZnSuN4goMLapDEbYg66Udmu93n11fPgEJkJeuMjmwdKEzfI5fATfxF0Q8tid0TJNjDyp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(451199015)(54906003)(316002)(2616005)(6916009)(478600001)(36756003)(186003)(38100700002)(6486002)(26005)(53546011)(966005)(6512007)(6506007)(31696002)(86362001)(66946007)(66556008)(8936002)(5660300002)(4326008)(8676002)(7416002)(44832011)(2906002)(31686004)(4744005)(41300700001)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVdEMGZMaGFCeWhnci9xa2lVT3NLS0VlcVVFWkwvaVIyQlFScUlUNVZsMlJS?=
 =?utf-8?B?M0YvR21YZmhRRi9MME9rN09KSVNTVE9yamJUWE5TUjVVbDduMmJocXpnd2VC?=
 =?utf-8?B?aDBZMjJSMUlpR1JJMVNrVEhLMm9GbThnMXdXNHdNNFpGdlJMOXJyZWpWWGJ6?=
 =?utf-8?B?N3oxdnFWNWFTbkFWcjU2bmg4VkFNYm1pUm1HM0ttWW5SZis2TUROM0VOVS9N?=
 =?utf-8?B?UDMxQ2dHUGdkTXR1RElIOTdVTVQ5UHkwcFhUdk5uajdaWm1HdFJsMjFLd3BD?=
 =?utf-8?B?dXJOb0d1ZGVhL3lqSGV2bFFmUkt4Sk1qMysxdTlpWUVoYXQrQ3pEdk1xZVdI?=
 =?utf-8?B?UFh5VnBXOVowcDBuMVllMktzZjVjNVA0RWI2bDUyeW1nM0pUbWprdSthSGdo?=
 =?utf-8?B?NmUyVDBoN1ljV1QrM0ZzbHVUUjRkQUlodHloUkcwR0JaTEJCbEpycDVzdDds?=
 =?utf-8?B?M0NQNTBiWW5VMEcreEI3Z1pUUThCZzUxZng5SzdzSXFSdVRIMGxoL25hdERG?=
 =?utf-8?B?TDRtNCtNb2xxL29yTGVuTlh0MVJGUFp1cG5lVCt5YW5nZWhOU3dNM3NId1pk?=
 =?utf-8?B?SGx1NlZSdUNmaUY0SlpwL0t6eGNBNDluMTZpYlVtOEtnWHJBRXdoS0I5YU1z?=
 =?utf-8?B?TmhMSUUwSHZSNU8rT2REb090Z2YwUDUyVUZBL1BRVnkrcGhkaVNoU0tHc2pG?=
 =?utf-8?B?Z3l5TnNLSFdYYlB6b09SSHNHMzc4ejdMTzBsa3k3M2o2MU9Eb21TQWtpODZn?=
 =?utf-8?B?bFNldVo5U0VtKzF4NHZneHJHRURENllnTVZvNlMvUTVlMXhaZWxudXFydG10?=
 =?utf-8?B?YkRDRU82eVByNGV1dzZRS3ZqU09rQU1hODdMemtjZkltWDQ0RFdubjJ2cUlF?=
 =?utf-8?B?azNpOGpCaXpOY3l2Yll0MGZxalJQVERydGxVMmM4aE9yTFZPVGlEa25Gb3h2?=
 =?utf-8?B?Y2lwK2x4TlAyTU5FWGU3Y0FOSW1YZGl1YUZUZDVTSjAvUy8vbEpvVXp4WXhS?=
 =?utf-8?B?R3Q0R1NjUkZnUDdsM0U0dUhTY29JaXNQWUJSWFlqYlo5bTRpVGVyK2huQUlj?=
 =?utf-8?B?a1RJRG5ZMm1xZkw0MFZveVpLVStGTGcrUGIwYkZ2MXBaVGFwY2FKb1N1ay9K?=
 =?utf-8?B?OG9YM1doNm0zY2lyeWpCbjhnTUJLYS9VbjUxSGo5S1ZlODk0c1lIeStFRTls?=
 =?utf-8?B?QlFpcGtRVDZVTnVoenA2OGQ5RzBmK0NXbmRmWG44V0NGQTQrcjBhbW1vZDEw?=
 =?utf-8?B?R0ZSOTJaYUhTZlYvbXlYRUszT1hZNTV4OTljREFnb0hxVmRBWWxYZzhrcldV?=
 =?utf-8?B?WFUwVnR6WkJUb1R2aE1pVER5bTV0clBDcERoaHV6Ym5TNnBGazFKM203NWU1?=
 =?utf-8?B?MHMrZWhtR3pHYUlDWllJazRLL0RWVnRMUVJyZVdUdTE1eHY5K1o4aG9pdGhy?=
 =?utf-8?B?eHN6UjhJMVhRMkNLNVFEZjBvMkhNZkF4OGRsa3hLOFlYQjVWb2J3K3NScEgr?=
 =?utf-8?B?bFpseXM5YU5DWXkwcEpwUnFpT0pVZDlxNnZlSjltQ1pnK1h1aUVRQVFJUDF3?=
 =?utf-8?B?SUt0Rkk2cWVTeFRlZ0o3WC9oQldJVncwWDQ2bG1KYVpqMUZVUDZIcHlUclU3?=
 =?utf-8?B?RkJzV05lNi9wT3lwMHJLSU4rNFZobkk3NHFieVJUL3k2SEliZ2hrU2Y1elJq?=
 =?utf-8?B?aGc0cjB4WXBhZ1hhRmJJM0J4bjZpTU05aTVDeWZhc2J5VGU3YS9RTkhyY0Jx?=
 =?utf-8?B?M1pNa3dSaFBNK3l1cWZFVjlmZitMdFJKU0FwR2JROW56S0VaeHI3ZlhNUTJK?=
 =?utf-8?B?cmNUcVFTclFzZHAzK0M5OW1ZKzFjSVBEQXNPUnhNc0d2S09mTUdvRCtBTE9s?=
 =?utf-8?B?Q0d6RWJraGJRVUhkM0IzempOTngzM1ZKYlcwTVZ4SlJHQlQxUVFrTnNVOHBj?=
 =?utf-8?B?MURYbWY2RDUybmRpV3RzbDFiMVRRN0FINVJwN1RrQ1BNMzJvN21oejZBanQx?=
 =?utf-8?B?N3ZWakdVRW5NK2FEdDdWMHgyQ1FLeDAvUW9MeWppempIdXlzNmNZQytmTCsy?=
 =?utf-8?B?c0kxRjlCM242U3A3QTM4aklnUUxESnBqdmdCTFUzcHlMb3JuUXR2TkpNMk1R?=
 =?utf-8?Q?CTFtXvjkkijcN+5Cc0QeThxBi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89736896-56b4-468b-2649-08dac75ea4d5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 23:10:53.4496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e96L2rEEJhFzAbhbOygIbqADGi3fuoIRbVunHO+uT1IVF4feNk+4T3Ta3+cNFlPD9kvs0e51J3GTeEiGNjOsgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5751
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/22 4:48 PM, Borislav Petkov wrote:
> On Fri, Nov 04, 2022 at 04:36:49PM -0500, Kim Phillips wrote:
>> AMD Zen4 processors advertise features in this leaf.
>> Add the leaf and its Automatic IBRS feature bit.
>>
>> Note: New whole leaf (vs a bit) due to propagation via KVM
>> later in this series.
> 
> No, not a separate leaf - use scattered.c
>  > For an example what to do for KVM, see
> 
> https://lore.kernel.org/r/20221103025030.78371-1-jiaxi.chen@linux.intel.com

That adds features that are mutually exclusive between
kvm and the host kernel, unlike AUTOIBRS.

When trying to wire up a scattered host AUTOIBRS version up to
kvm, I couldn't get past all the reverse_cpuid_check()
BUILD_BUGs demanding exclusivity between h/w and "Linux"
(s/w) FEATUREs.

Is there an example of a scattered feature that gets both its
boot_cpu_has() and guest_cpuid_has() satisfied in the same build?

If not, I'll resubmit like this original submission - AUTOIBRS in
a separate h/w leaf.

Thanks,

Kim
