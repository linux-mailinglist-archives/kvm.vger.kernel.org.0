Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A67D683768
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbjAaUVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjAaUVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:21:34 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2906C56EEF
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:21:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjuzVBlAxxwJa2/lz8H3yqnDN2PKmOaYd8XFf0jTvo3ORbAn2z2SVVu0zVSNgjSq09J+h2x51iCZwhPjhDhbafUGqFmu6gcJjiwNZP0a+vzgWGabDhYGqsPH+b3QRaGbcQ+0G+hSyIHw373stHimSXVR9GsFheUiRHkdwGOKj7x/I6cDQgHTMIDe8lNMxdyCfktepXevCvxcUs49a2m9H3FupGpbgT5/ZuFl6pQ4OHMYUzeYMuwOUJyZRTlJcaiJFn0HqpdEtWmHNWgycL3J8hN64027AbQaRaHKw7qtWrXfAxJvQU9lKO4Xif3gYNQOUyeuMGn+gvRp5QGjwkItOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZvj6MZrSB0OYUutgHeHzJYoCRhAqrskb5NwPo5IZYY=;
 b=a013j4xlk/bQJ2Epgve9cHSXJYEYLuoXvXMc5iwLu6uWnLbWvGTgXRQZbr547bKjQ55FNHMiU38J9IDjtXuRSnYfxXsI1qACO7XnHBcgQiPAj2Z+Kn7ou8hm0ElV43ThAq9UdqHwGY3GzkS0O8XU4/0DnYT948RnDLrSY2yEMjwXmUxTV2NtVwDX7oupiMJymDP6ER7/ZdeD8N0iTYgVBSabs3dL3H7IBn1CmFfm5Oxxe8gumJm1ITZ06vIvWNkNqL1JZEx9j7iImfXBg/WskfFdI130jf2JcUJAcoRk7shatAb9FV7DDnuON6UFhhhXHbfvLAeeTvsJmc6yInOtrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZvj6MZrSB0OYUutgHeHzJYoCRhAqrskb5NwPo5IZYY=;
 b=3UCkvZSvT47pz8s4CxvnKc3l/Bth2e5N0dQUHOFn4Yy/Q8w8cG+RtJUVrhh0D2wFFDNVdT7oQ7dhx30/Y4Khy/ArAXhYZwvuRIYvdLsPxzzxNGnuaEMN/hUWajv2WAqG7jcSqFFKSzJKkxGeLfhsOlTEzboNeKSaHhInbLJVEGI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by DM4PR12MB6421.namprd12.prod.outlook.com (2603:10b6:8:b7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Tue, 31 Jan
 2023 20:21:29 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::790c:da77:2d05:6098]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::790c:da77:2d05:6098%9]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 20:21:29 +0000
Message-ID: <8df55f5e-afd1-ab04-c7da-8ac70a8f9453@amd.com>
Date:   Tue, 31 Jan 2023 14:21:24 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 0/5] target/i386: Update AMD EPYC CPU Models
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "yang.zhong@intel.com" <yang.zhong@intel.com>,
        "jing2.liu@intel.com" <jing2.liu@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "Huang2, Wei" <Wei.Huang2@amd.com>
References: <20230106185700.28744-1-babu.moger@amd.com>
 <20230127075149-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From:   "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <20230127075149-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:208:256::22) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|DM4PR12MB6421:EE_
X-MS-Office365-Filtering-Correlation-Id: f43da906-b3b3-4424-2aaf-08db03c8bc92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 60HQdlmtkx1tcx3zgpFPYyrVghrRuvUwbrwRBIIHga+cksGF4/kCzpI3HTpUe3KhRuFxuCVFC72fVcRiotGIz5oDdD2suo3dh0bAhkjaA2GbpF2BSJgtu+X+dzblkKihC/dYpi7BJlZ/vzjm1R8gdI8gMBeJMhlfLCVGufehNOImv2cmb6D44UnNG0xDJb7T3sHeQHP6q+Xmt2NW0aey7c5vPJsbUN8yKNg8o+gFPCAtiNDOazQpl0POTcSlixfyP0TvJ+Au3v4Y4nOLhPQ4+X5nov5CQVBTSPlac6NXnGhU7XDkABJets3+dY+dbwjIaFltwgvZrtgv9SXpb4w0jnvz1Qgi/uIdbtuEUDFvieCG9FTh/ZuxRSk+yNBiJ/3FNZTfvjuUZ1qJoYwyKuzACrIGIp/OSqHbKXH5AUJp60XT3DLWgHWrGdj3TPrhEH4Wth5O1Rs0w4ho7FdtWeYsHIc7npOUQitgmvzm/y7us05GDIVHA+MKqdHYp1txH9Ez/n7ZoD+KjteXIqQ4q1uzuomOlsJTcpT1uk/S7cvTxlS5/zAWECSrsylA2XekhmhXaHl3fV8vt+QSerMkECUYMadCSBEg9K2guKQrX0KFiuHk676QYxws2MmgBgPVD18E5kITCEprktJx8vLVxSpBTlZubWob1vYJubKuc1SMlZFJnjVD2A6W8kCwKAY4hTh26nuWJu+4Ng3r6yTXVSORTQUqYWcJK+YM2Fbp1gpj9GwXbVeZ+8bHL0Bdd3rTpz7c3ReB9+jRtyHHrLvqErEh+4FxummlQgAHFcF2jhSLrWBgRN69b2OvTZUapb0BxHyJj8DWLnk4arXPBwWGgcJeig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(451199018)(6512007)(186003)(26005)(53546011)(2616005)(6506007)(36756003)(31696002)(38100700002)(83380400001)(6666004)(966005)(6486002)(478600001)(31686004)(110136005)(54906003)(5660300002)(316002)(4326008)(8676002)(41300700001)(15650500001)(7416002)(2906002)(8936002)(66556008)(66476007)(66946007)(170073001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZElPNjg5VzVFa0pvQUtXZW41R0J0OXZoU0psVVhINFRLMHRVRWEvZjlKNVJ3?=
 =?utf-8?B?VlZjU2hSd21ObXEwNGsvQW93ZDFianEyWjc3Mlppemd1RnVlejFsdTFzRnlT?=
 =?utf-8?B?M0NjTjdKMGEyWG5pT3hkbU9GRUhaY3pQMmtpOXZYaHQrYVAyaFQ5SlNlS1Ny?=
 =?utf-8?B?L2cwcm9GTTBaaG9YTEkwSEpzOE9sY3JBQmFBV2lGUzlya2EwaVNqT1BPRmdw?=
 =?utf-8?B?TmtDNGphMzErMlVDVmZRQ0x4UHM1ZnVpSWhaeEx1SnNkZ0ZUb3NOeGFlWFMw?=
 =?utf-8?B?Y2tiaEs3a2V2WENMY1RpU2V1bytCN2lWa1hOZHFPRUNML1I0T2Q0NjdEU2Ux?=
 =?utf-8?B?QTFvRUNydzlia0szSFB6NCtXSjJFR3dMTzFvSzBDRlRVUnRzWlZ1dXlUTk0r?=
 =?utf-8?B?ZFkvZG92VUUvM3VrNjZlZVNoL0lFWUtjLzNiMTgvR0NCYTVRQ2dxejZFK3dq?=
 =?utf-8?B?ZXYwWkZYWEgvdVgvcUtaQ0tTTmJmOEs4RUE4MUZnUmNwZFBieURUQk5FN2xT?=
 =?utf-8?B?cmszUnN2bWVZamRTTjloclMzQ1dsL3ArT2VqQ1dzTERjTEZ1VVVsamU4ekJL?=
 =?utf-8?B?bFVNMXRhdGQ3cTZxTHRCTTBDd05XUVhXRS9OcDI5dTJ0M0tOcEtvZFZacnZ1?=
 =?utf-8?B?TExyVlNCMHB5Mmh1Rk41MHY4cDMvWGYvckt1ZlYyaHAxOTRxV3pITkdZVWpo?=
 =?utf-8?B?VUZ0cW9oMnNvRTFXWEtWM2g3SzdTajZ4WndxTTZrREQwemQvYnZ3eEpxcTJk?=
 =?utf-8?B?dVJLVFNiYXBaY2ZuZU1sbmdXU2dSUkpmWEtkaXdBWCsxRTRRUUdqMEc5Nk1r?=
 =?utf-8?B?NWpWQ2hER05KU0FBQVdBRzlHUXByY1VUYUlicHlmd2VKa1NDMEJlMmRlMXhE?=
 =?utf-8?B?NXJPWnRhZmt2TkxVUG5xV0VCTU5TMWFFN1dwb29pUUtoOTRtdGpET1JOK1BI?=
 =?utf-8?B?dzJqQW5PbTEvbURwTVlsSmZYbUhIZmpHZWdJRVNKbFFlVlpaek5sZTR2enNH?=
 =?utf-8?B?VkM3L3BWWlpFekhDYndTWTRnMVBiNTY5cHFrQ3Y4ZGlNMTI5M2hqSXk1Unlo?=
 =?utf-8?B?RmdqMTY5MlZpWC9vaHZVWS8vTzVHcDJ6UzJndmZhUUxUNmJCQmxzUFRIQlNa?=
 =?utf-8?B?SWdQRE9lVDFPQkd2ODRCSTd3SGpoTmZUcEZnV3pHTzc2MkJ1T3hORExobGhM?=
 =?utf-8?B?MjVFYkxpY2t0K3hQSnJROFpmemRnUDByelJMMUtPWU1MdDRrMFZqRzFGWkFV?=
 =?utf-8?B?NDdvU1VhYXIrU0NpZ1BzSjhFVFhrVXh2b0tzZEhINk56QnZwbG9ORWFpN3dN?=
 =?utf-8?B?d21ETEkyTDBZMXY1ekw3RWlzeE9wV2tXYklCWXNXRFYvY2JETDg0eExVellW?=
 =?utf-8?B?cmFta2tsajAwbGs0aFVJTDFkb1FNY0pnM2l6eVg0QlJLYVVxU012Z3ZHbXJY?=
 =?utf-8?B?d2dVcERPTnpmQUc1akhWK1BhVVJBYUFPdXNzbWRDejZ0WUR3ZU5FOTFReEp0?=
 =?utf-8?B?TFNVaFFWVnZQS1k2RitEYW9HWEhhNk16RXZYc0ZacldXS2VwK0NkZG1JTW94?=
 =?utf-8?B?NmV4Z0V3Snl3ZjJHbXJ4WHNNQVFocnJhQmxJMmlNdVE4TTI2QW9YRHZvS2pj?=
 =?utf-8?B?M0k0NmxqVTZrL1lTTmQ2WDRGZzBaeno5OStDMFJ1OTM4ZHFzRDIveTZ1UzQv?=
 =?utf-8?B?MXVUQ2hQVFhVNW1NcTZHWk1XMTZ6WFdzclA1c3FUbEFiZlkzVGJVencrYkRz?=
 =?utf-8?B?MlJGRUhTN3hLcTd6RDUxemlNbkZlRFY1Q1R0blppUSsydk04K3hLOWRORlk2?=
 =?utf-8?B?SXloY2hpQWNsSmliQUorb0RlZWRMN3JCMTVEV3VwaVlGWmZ2cG5uRG1mWC94?=
 =?utf-8?B?YlBiTmZnSFNZRmIvSUlveUY2NTNLK0E2MU5KYlJvMEg0TmN5UVhPcTBNMFAw?=
 =?utf-8?B?aGlqekNhVldJMVVadmtPc0Y0T1NqTXB3RDVFU2pLMTdMdFVCbURiWGtsc2F3?=
 =?utf-8?B?R0NLN1RWL0JacEFSaFQrOFFTMzVRZ1JEakJuTHRQT21lQlBob2xIRnhRbERS?=
 =?utf-8?B?ejB6aW01VWFtOERHcFYyQ3JEcUlvT2ZwYkQ1bTVEZmQwTmZGSE54T2ZNenFn?=
 =?utf-8?Q?3tdkitWOSRNzW8PFxV8ItmjMq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f43da906-b3b3-4424-2aaf-08db03c8bc92
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 20:21:29.6970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UrEE7iJN+VOTHO2r2ciUl2gc/d520paBQkT1tMCvpe1wNgK0DVpNICWUcvvmY+Hc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6421
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> -----Original Message-----
> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Friday, January 27, 2023 6:53 AM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: pbonzini@redhat.com; mtosatti@redhat.com; kvm@vger.kernel.org;
> marcel.apfelbaum@gmail.com; imammedo@redhat.com;
> richard.henderson@linaro.org; yang.zhong@intel.com; jing2.liu@intel.com;
> vkuznets@redhat.com; Roth, Michael <Michael.Roth@amd.com>; Huang2, Wei
> <Wei.Huang2@amd.com>
> Subject: Re: [PATCH v2 0/5] target/i386: Update AMD EPYC CPU Models
> 
> On Fri, Jan 06, 2023 at 12:56:55PM -0600, Babu Moger wrote:
> > This series adds following changes.
> > a. Allow versioned CPUs to specify new cache_info pointers.
> > b. Add EPYC-v4, EPYC-Rome-v3 and EPYC-Milan-v2 fixing the
> >    cache_info.complex_indexing.
> > c. Introduce EPYC-Milan-v2 by adding few missing feature bits.
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Michael, Thank you

> 
> who's merging this btw?
> target/i386/cpu.c doesn't have an official maintainer in MAINTAINERS ...

I thought Paolo might pick this up.

Thanks
Babu

> 
> > ---
> > v2:
> >   Refreshed the patches on top of latest master.
> >   Changed the feature NULL_SELECT_CLEARS_BASE to NULL_SEL_CLR_BASE
> to
> >   match the kernel name.
> >   https://lore.kernel.org/kvm/20221205233235.622491-3-
> kim.phillips@amd.com/
> >
> > v1:
> https://lore.kernel.org/kvm/167001034454.62456.7111414518087569436.stgit
> @bmoger-ubuntu/
> >
> >
> > Babu Moger (3):
> >   target/i386: Add a couple of feature bits in 8000_0008_EBX
> >   target/i386: Add feature bits for CPUID_Fn80000021_EAX
> >   target/i386: Add missing feature bits in EPYC-Milan model
> >
> > Michael Roth (2):
> >   target/i386: allow versioned CPUs to specify new cache_info
> >   target/i386: Add new EPYC CPU versions with updated cache_info
> >
> >  target/i386/cpu.c | 252
> +++++++++++++++++++++++++++++++++++++++++++++-
> >  target/i386/cpu.h |  12 +++
> >  2 files changed, 259 insertions(+), 5 deletions(-)
> >
> > --
> > 2.34.1

