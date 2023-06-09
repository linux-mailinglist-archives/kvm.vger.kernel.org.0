Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F944729E9A
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 17:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241644AbjFIPeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 11:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241588AbjFIPeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 11:34:14 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2062.outbound.protection.outlook.com [40.107.100.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A103A2D7B;
        Fri,  9 Jun 2023 08:34:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhziNoxMngrTr1Lc7Y6x+IXyjcfGr53BnnuE2udvAVcQ/7LJ7EKlZlb7O/qEIuZYU1Xgz+y4TalDAn4IBINt/7h1cCJQ5yJ217aKzXix5l5sF7AKZqhWY0PwIMXSHpEZvteHV/9UWkHEzkQgFAIVPiJK0RpYEqcqRkEZ0v9Jp3HeYpIaPVS1vdjy1xU80xDu4ig36rNv1l+1+BQtudYLnBhmz6VfhfUbtGJJtv0bx5O+Ea90mwKYZDNHLGQyZuyXaD7SMjVZX8sGQro6BZ+lqQUE+V5OUWU2IH4kxJSHpnh/Tiax27DLn68z57w6QZA09sOjzg8d3TPnWmywLOp5Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xXwg8fWVjtEuXa/Hf6FUChEYkCwmSmZenKxy+nYUyeQ=;
 b=YyClYptdgS/5kVEpNVqmGKIRlVMuZWMsWHXue4zdcDhvfw9oLvWhNenvl0UIyDnuFFaE2Etin/blOltoWMTuquNip9ZtXUacWLEJnEtmFXVhhXWsip1QeaXb6Cd0C4NnkbVo619WnqKD7Tkf4Fh/xlseL4tyXLGXnv9GQQBEGN/ePH6/XRkdkV/4jrcCPD0RDDEfmVkz07qhrdIYzKeG1DgxzLfctraRzm0IRj2YnMXhr9S2kjmu2IRINEaEOxW2Wix1grFr0m6ahQyI2t8e75UWbl6A1vlKhW0qSja21ZzoiqoAifvBJ1YkchXvNSWxLBFHVV3bp5+9QUadq2A1mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXwg8fWVjtEuXa/Hf6FUChEYkCwmSmZenKxy+nYUyeQ=;
 b=SeIL8YawtBj7ifTK1i9IkgLNXV0SGKx2iD6dxfL5I5hzQQAwoDBzbs0Ox/2a7KO/bsR3ttGfD9IQwzicdwPUzUDLEQiISiV964ztKBdazghnbV2RvjTj6RbnB4JHhEZOxmsNK9OLNZDGN8ELBIDqTDIDI9XVKUBk3CY1ii9P8Jo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by CH2PR12MB4874.namprd12.prod.outlook.com (2603:10b6:610:64::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 15:34:11 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::c6be:ff0a:6668:379f]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::c6be:ff0a:6668:379f%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 15:34:11 +0000
Date:   Fri, 9 Jun 2023 10:34:00 -0500
From:   John Allen <john.allen@amd.com>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [RFC PATCH v2 6/6] KVM: SVM: Add CET features to supported_xss
Message-ID: <ZINGaJnNJ54+klsD@johallen-workstation.lan>
References: <20230524155339.415820-1-john.allen@amd.com>
 <20230524155339.415820-7-john.allen@amd.com>
 <161174d013dff42ddfd2950fe33a8054f45c223e.camel@intel.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <161174d013dff42ddfd2950fe33a8054f45c223e.camel@intel.com>
X-ClientProxiedBy: MW4PR04CA0055.namprd04.prod.outlook.com
 (2603:10b6:303:6a::30) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|CH2PR12MB4874:EE_
X-MS-Office365-Filtering-Correlation-Id: 049bde9f-6f33-4216-fd97-08db68fef8f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U706tGCWcP1tP8n2HL/lH7h96ZPuk4noV6JB3XSjuaCISiNhB+9+fZ2JOgct6Rs7uAnLqZWisPgdlVKlkYr5xTMHegY5a1z8ATcvyTRdewA5wPuObtrJ0yLodgT9xIzwURSq6jQ2aI+s+YDpfMZjWMBzlRjSl8VENmlnsZstGyz6cP49oBRdUCTithGJ8VMas9WnOPGVzJ5NnG6X9WB2/J9mjMWG+bm7OFVzaY2zdSopBM7oxJTJim75VrktJ7oIcwSQpJq7dF6s+IcOmrEnr69BMkYwDEhBvW1aPQ/6SNjuXZSjEzZjc13eiULUPrctiHwzcs4FasWdV6N4JYRFiGTvKaddC+YHbUByrOMdDQSBmwzhRS6JQr04qOGw1aLtVki+JO8dHIYSIj40B2spb3DlHPofkqImJ/6DUuZ70Qhu/2bgup6m/D1LjpAZZKOq71Ior3DNIUF7WGr6kiYc+BJgIgZsPwaqDjdxB0Gd4//dVQUYophevDRU20PUiyRplGv9HHO/GePOkreVAIeOkfSUFQxsdCK3vJvMMrsvShm3vROi1rv2QXzyAHc5CVveVF/WFsqhkEYKozBYZ2S1jZ0Cv1kFavxVPOrDEehbfEw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199021)(6506007)(6512007)(9686003)(26005)(186003)(6666004)(6486002)(66946007)(66556008)(66476007)(2906002)(38100700002)(8936002)(44832011)(8676002)(5660300002)(36756003)(54906003)(41300700001)(478600001)(86362001)(316002)(6916009)(4326008)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?2d85sqhU4fa+HpLGVZWs7bXMd+nP0azxknKYfajl73F5YqCvOoc6tKDmWP?=
 =?iso-8859-1?Q?aRGL29o1hNYH9GZ1vo5jqdTDNtJoyJ9EWzJWSpvGqp7rwfNmRwF7AQ6aVM?=
 =?iso-8859-1?Q?th4211WYo0obnOjtzrBIUDe6Vwmss2Fmivqum6vDlszcdAls94vGiWS5Z/?=
 =?iso-8859-1?Q?KiP0AZEGw2rTqFfwzOVb3G71SWLi243lHg9QGAfjFh+xgxDgxfTTs46mxF?=
 =?iso-8859-1?Q?WEjdSQz+WOIdqfVXtFwuPRq+CvaO+j1luOktUgrOmYRLjmlcyyDksGhm7X?=
 =?iso-8859-1?Q?CQ14hvoXCSRnZVaEALnQG7IyMSeFzfA6lr2UyvpBs+GXo1q/V32i9cw632?=
 =?iso-8859-1?Q?0FmlmF8mhXqhHhePP1H82pHJednqTJQypa5VkJLIS/3X458qL7EPo17Bfr?=
 =?iso-8859-1?Q?0Oe5ZbDvio7yU963qNLGXZ2F2iWOhDLvMQo4ZallzT/F0QFu5nbOMfN+Sl?=
 =?iso-8859-1?Q?nemyT2x73ZBQd3pnGikp4dRM3gLcovVdfII+o/MRsgkUKoEEJF/pC0m77P?=
 =?iso-8859-1?Q?CYOD6oa5C2x6OzoBBY0ovRWIZ5x4uagWwULL0IZAks9zE5eUWyZ/kZZQtj?=
 =?iso-8859-1?Q?PpJB/A3UKhV4q4hBhRsfUI7INpgYHDUSHVSyRYTTnwu4Wr1veQUUJR6K9m?=
 =?iso-8859-1?Q?boOqOBsu3mxx8506OnaFjT4Ry+bu+twVj2WvWjSH3Fmwf0BWKmzj6xL8uj?=
 =?iso-8859-1?Q?iuNkSKUQICzR8SUJPSgsVGI/US1e27rvQUHlqAX5sfnmuj2OPYj2JEXsqM?=
 =?iso-8859-1?Q?15zm22Ha8uoWHcybzekeXIPO/Y5YP2+3TSD76sXpPTBynq21xu8UjXwen8?=
 =?iso-8859-1?Q?N4PP17zKjrVc6wTWmsPpzEEa/cgabaZpPlM/V0TtTeyrD/RBuSRBYhZXXB?=
 =?iso-8859-1?Q?HRHS34mB6zqHHG9MeA/8/GDrUbRXgiMxwDSMmyTo9Gal4unt0RICYOzl7A?=
 =?iso-8859-1?Q?9ZdMGiH4gxLH4hIQfazIOQiYy8F414VNCn2pIdccJ8XGlx5XKmisanDqkX?=
 =?iso-8859-1?Q?I3VMTMfH1X+fxmeMQhFGzdNiw/6PPukcfM+dC+k74X7QUmH/DW3LpuysdK?=
 =?iso-8859-1?Q?mpaDrh41qzoUhxLwcALRSg2HvejnnISK7aGXXUVCy0MTXT+hZJxrjV672V?=
 =?iso-8859-1?Q?LMpQKO3t93UWV7PaOhIG7LW9pc4ZoX3BB8qQPr3JdbkapvhwPk55+XaiJ0?=
 =?iso-8859-1?Q?9Cwj4Zdqj4Ivw+RY0tLwTvoYtlH40aO64ZmCkcIS1EUNwLnt9lrMSDuJSi?=
 =?iso-8859-1?Q?N2dWdcIe0zCuGHutYMBmxjgdkZcofeKCGrnx4qMLHYBxETquZISg2tB8if?=
 =?iso-8859-1?Q?tBWeQCncVb+xUCsBOsWnnX89WUcy5MzmDCgWtWrfDnVC6APbREoQ8ArTe1?=
 =?iso-8859-1?Q?TgTelR3YrnTBsZqv4o0uPh4PcaUI7dkVVchMTvbuJZ4aaEVziRNGREBnI7?=
 =?iso-8859-1?Q?HbCShnXIXjxjSz7CSxEKrlWUuz91WH0W05L5rpxLLQ+jU6f0z/z4j1PVbL?=
 =?iso-8859-1?Q?cqfj2di9moUVpjeK4LdjfsKaO0a6Ch+CiNyy9b8NnHkjxhpNxTV2j2TiqT?=
 =?iso-8859-1?Q?+QdQM1GmWjCRThV8ZSlZGte1Fp4cuNmDoSTdj3WoDgYvuqL9n4x/ZMc4t3?=
 =?iso-8859-1?Q?8g5V/87Y3Kk+F3shKewL1GDyEwMo7mwh3L?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 049bde9f-6f33-4216-fd97-08db68fef8f9
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 15:34:11.2729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qgqz+5S+qMGA4ZDaJ5iTKf6Xl72nyExuSPgvzEWMlg27yJUivCQ1caCF+Gc1aspenxa16P/RV0mM28gOTqlihA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4874
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023 at 05:24:23PM +0000, Edgecombe, Rick P wrote:
> On Wed, 2023-05-24 at 15:53 +0000, John Allen wrote:
> > If the CPU supports CET, add CET XSAVES feature bits to the
> > supported_xss mask.
> > 
> > Signed-off-by: John Allen <john.allen@amd.com>
> > ---
> > v2:
> >   - Remove curly braces around if statement
> > ---
> >  arch/x86/kvm/svm/svm.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 6afd2c44fdb6..cee496bee0a9 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -5070,6 +5070,10 @@ static __init void svm_set_cpu_caps(void)
> >             boot_cpu_has(X86_FEATURE_AMD_SSBD))
> >                 kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
> >  
> > +       if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> > +               kvm_caps.supported_xss |= XFEATURE_MASK_CET_USER |
> > +                                         XFEATURE_MASK_CET_KERNEL;
> > +
> 
> Is setting XFEATURE_MASK_CET_KERNEL here ok? The host kernel will not
> support XFEATURE_MASK_CET_KERNEL. I guess after this there is a small
> window of time where host IA32_XSS could have non-host supported
> supervisor state.
> 
> Sort of separately, how does SVM work with respect to saving and
> restoring guest supervisor CET state (I mean the CET_S stuff)?

Apart from a minor exception involving SEV-ES, we are piggybacking on
the state saving/restoring in Yang Weijiang's x86/VMX series. So by
inspection, it looks like guest supervisor support is broken as the
supervisor XSAVES state and MSRs are not included in that series. I
currently don't have a way to test this case, but I think there are
operating systems that support it. I'll work on getting a guest set up
that can actually test this and hopefully have working guest supervisor
support in the next version of the series.

Thanks,
John

> 
> I'm not sure there is any problem, but just wondering how it all works.
> Thanks.
