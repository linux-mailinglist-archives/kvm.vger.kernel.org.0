Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0C97172B4
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 02:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbjEaAoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 20:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbjEaAoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 20:44:03 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05714E8;
        Tue, 30 May 2023 17:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685493842; x=1717029842;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=bZGPU5KhSTx3InTDEBeCoGgpCxaa13/K+/jASOAyvvg=;
  b=PKX7ptGIIL+tGq83KOZxbsmS7de1o7OMmfL+G1DIGeF+EUJ4UBdsdAoZ
   0XJifLydmStpLbAcbbi1srwPDnS45ibBR0+BKBDdnB9r30DsO0/i8IN0W
   iFmmeFfQtRbzJGhG1tuvqeBm/s2JAJPHe9Jn/WclXM++HzG1gxBMlYKk0
   T9uKmEwkF5li1EX4x09/JWskFZwbkE203WU29MGKcotByIZ0oFPbVi0HU
   asqe6jINYYSl5B2NRIuxN8CQCwPp4SPyx4kGY4M5U2Z/uWdNAIM3JHaDs
   KThtpRFj0m09wlVfyqgjaJOR+xSMDTtunFcfXGcOgRdsy16N2cT1BvTYb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="358347818"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="358347818"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 17:44:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="851006906"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="851006906"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 30 May 2023 17:44:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 17:44:00 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 17:44:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 17:44:00 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 17:43:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6pWqRl4YWvEO/bL+DANuYrcUZl7EcO2N906eyY6fiiBc/4BDUDxjcOT1uwnHBvQik1qbi+Z5HKgx6CVbHo4KG70MjWmesxQSo3GNWlZAoTXEyc0Ddn/QX3UHGmGYzXqvXW82nwEVgl5I0tRsxJh/lvBV6o0gAVoApSIyxZAVcmbIZEITmw8RkO1Ev3S6rZegngdW7vlONuinVwpaCYVfJ4IwDWNWHtLGTd+XGIhdL+5TEV2URHU1MVUZ5+P0ggvtHunsZeXaeSDocN4s0BKVD+NsRrLI+z7Q7DiHlEaVu+J7DttBT5iZTbcJzY8W2pN7axvcxmVtfdZX5oBD8wKcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5GdCyJYHTWXB7cnqt04dAO++o99zT2HvTxxH06+9/5U=;
 b=Sx0NLYQxf1POilJeAnGv5jRMqlpf7rMyqdOrexlOpdJfpDM08tru6kcIjDNKuwZz1EqJnGwkXTn2gKG8wbe2ff6fUYFwIIDy29uy9QrWDXeCDJGM4w8EJ091+UTh1FbOTBPDcNpz6uScI6YE6TiVeMI/iRmIyqXlvmVmsOSdSErFPEc0vxWfhgMP5f+MbRjjPDqFmxuk+DuY5xjnCYxCfijCHT69xjU87J6neu0zfHDEqmQh1gYsM7ZsqyR3MrD/Cyf4+EUWEW9YgrK5BQvQ56s/W0ICqGsVPf2TmhVgM7wLo2w7hHoqCA0JBw9OjX5+ECN1xnTPebC3nUqPElurTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7266.namprd11.prod.outlook.com (2603:10b6:930:99::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.24; Wed, 31 May 2023 00:43:53 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af48:a141:6dd6:25e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af48:a141:6dd6:25e%7]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 00:43:52 +0000
Date:   Wed, 31 May 2023 08:18:42 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: add a new mmu zap helper to
 indicate memtype changes
Message-ID: <ZHaSYqOWDluRmIAd@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230509135006.1604-1-yan.y.zhao@intel.com>
 <ZFsr9TynkA/CyPgg@chao-email>
 <ZFtQeLNuXP6tDMne@yzhao56-desk.sh.intel.com>
 <ZG1DhSdhpTkxrfCq@google.com>
 <ZG10zi6YtqGeik7u@yzhao56-desk.sh.intel.com>
 <ZG4kMKXKnQuQOTa7@google.com>
 <ZG807ECX4TeBcE61@yzhao56-desk.sh.intel.com>
 <ZG+Epwp75nJ7tpXM@google.com>
 <ZHXGWsw3ARk2OOjX@yzhao56-desk.sh.intel.com>
 <ZHaL/d0XhoCmoo3q@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZHaL/d0XhoCmoo3q@google.com>
X-ClientProxiedBy: SG2P153CA0017.APCP153.PROD.OUTLOOK.COM (2603:1096::27) To
 DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7266:EE_
X-MS-Office365-Filtering-Correlation-Id: 104e1b4b-0a96-4aa4-c52f-08db61701af8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jDu1LFWxz4MHLx2qoyXEzta7oNYUOkL0Q8LT5g9kpSqCa8UdB5UvkNJ4byYTcWFDYLl1L2F6+ckUWvr/IyCkB1SceZEGkEl6nuOGPi3De6XCz3xGEg/rFCL4Cq88W99SRXX7ct5zWwDtg9iROOr4GfGzHpPkr+q6cRyIi1eKSjwqzDZ+WzlGKJ+QVp39oaPLJFYO4WJVdoKSo4dKpOhmR+JOrnTEVA25L0AfXYsW+06O4BzhEuSDSrIVVKOvcZzphrwpIBz1V8mywhJu7oeFHzDx3PMQEyihw76vfF2jbe//7V7jSbPD0Ruxxxo2CrmWX1OnoE8Ki68HqrQzdVFCROrZPwIUP1ZotKP2By9VA4P8engLSljO9xaeLiMyDBLZwXMfIsVFb2r3VvZOBTDMNdAumQrjARMuLS0h3iQ/DVgRM/LL6Ty875hLsBzZIQ8uGs/BTpefdFRIwTiP4mxc0IVOHDS75df+XN9rH3XIKwf06BtC+PlHxcW0Gnta0J96bVUUe9eKkNJPC/KDuT2BkC01Skq0tng3C/BQnTfJpw7C4wIKJVdpA2CPctgvOXPk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199021)(2906002)(3450700001)(8936002)(8676002)(478600001)(38100700002)(82960400001)(316002)(66946007)(66476007)(4326008)(6916009)(41300700001)(66556008)(6666004)(6486002)(5660300002)(186003)(86362001)(6506007)(26005)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mzGA21Qrbldz6hV5ABRquSdaGMf6ycB/piM4ChBcAzTLxMLv9vS78O/7CDNG?=
 =?us-ascii?Q?/yChjKaFxN2KfJyHVGuzOW34zHRUyk/1ROmrb65bOHgDCxbkI379dlt32Dpl?=
 =?us-ascii?Q?9bFQcoOc4Ij+mD8zGikSI6eRdV88LDSil08HN2yoT4KzOE6OrI2bM1qEdOjo?=
 =?us-ascii?Q?zoJqpJSdUWRNfeyIQMTWCGsqmlraz5cXsFjeYqj+t64fyB/4Krpl0EZtZx3I?=
 =?us-ascii?Q?MSAUlHsIOlHsxhp1DF4l2DpjK1NckEL8oIT3vvGkvhrKSbah0MlrBvI4y9gC?=
 =?us-ascii?Q?hIk1spPbuZhYifCfUyOrQl6aImLsR72VX+1OCIhHexL7AIkrTH2aduc1GA3V?=
 =?us-ascii?Q?VlWshGN0mvEr6vbL3LbvIVpJ0U04T6G7uZcth0WhsPv3/muQXsLGfCQqg5ej?=
 =?us-ascii?Q?FWgbAKAOb9h+le4Woz4nwTZQWuTj7HIQS8YqQwLe/zgutlwSvY3nefz0mqDK?=
 =?us-ascii?Q?fATX3zbd6l+Mai5LQHdABBMLNHRJtmnPsgcJugACCOglhGzVZiSoj1B0KE+M?=
 =?us-ascii?Q?UKHCOfaUh8JOCORI2trWDzCUPEXXd2Hkj0KzCbjFz3HRS4ZFG2egkayvNkTH?=
 =?us-ascii?Q?/lJjdkU0V4nRGLI0fNYnSecQetRnVtjmp9i+W99mcHDRDwX6xHin/1SBXFFa?=
 =?us-ascii?Q?cCAARMpRMwi3cGDrxWKxKV0x2+dlhTtT4GMdH1RuY54vmyXU09R/hdTfDXb7?=
 =?us-ascii?Q?iii808PUQvi12/E8z4AnbNQ9ZjESPLJ1qXG4EPPLekcY6cvUTKQLpK9zSIxT?=
 =?us-ascii?Q?JQ1G/n6cDBjgkkQ8rzjisYkbc+MmmmTKn7C7aiWpZJzPruTuDcCDWBXJS6Zq?=
 =?us-ascii?Q?lvG61slYnAuf34u23im9uZScKGBRoz68yaHS/66EwKicW4A/Igys/XCdP7oB?=
 =?us-ascii?Q?CJNelylzjarVf0h65aNuzRGPkG8ARhAMij1ux1tY9BUSNYWC1/BzLEF/qIa2?=
 =?us-ascii?Q?4/Zw+w0+AUR1E9bOrHOW4DsYni86FTVBXq31AtoKJyUerK1tLeInJ+JvPkAL?=
 =?us-ascii?Q?3rIgHnLXrJnTClVZTXirDArMXeK0cjBTHiDf21nmAxn6bvMsw5wnanG5xe2U?=
 =?us-ascii?Q?kjjqo6X0YA6PyRiIjtfKdVEUXV25gFgVhjofRTibhu+m2HdgytnYRiUXRjim?=
 =?us-ascii?Q?EfXN8I2+Y9gsHIQYZ/obQplInuCbFWEbeNks95Xt0dwzn70B01Ji/3vM7O2M?=
 =?us-ascii?Q?Uw9QYd+K8PbJXu6Y5pkG5NIS/EmWfJcJAfdCy5GmCHzJ56zZfPnHAG3HIRWx?=
 =?us-ascii?Q?xovBfH5OI7FmeMicEDkCva0osBxyj6WZ4/Zm1b+NBRQJsDA48MxVV1p7XG6L?=
 =?us-ascii?Q?XvRbVUVPF3G/hDfseWdbQYwEaRJB/NXJXs2MmiUMFCJbZN1xW5R0qK/MEeR6?=
 =?us-ascii?Q?DhF6qfD9yqRB5CYLo7obiMjnEaHS5gx94VzQMreoRbTyx3cDuywbBUK1DnRr?=
 =?us-ascii?Q?Qdi9uJn9gHh0XrnSMGvE+Xp6a27dJakJiPNeHrMMv++wr/vnbWHpOwMNAkNb?=
 =?us-ascii?Q?0QwpcgRskV45h+RgB2vqjFG9AIlBSs4xk6NUm0V9M9LgGBMnOR1peBOv0szR?=
 =?us-ascii?Q?fUT5IqUP5MmI1VI+zLyR8/PLShyT9FhRJDqUJ8Rh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 104e1b4b-0a96-4aa4-c52f-08db61701af8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 00:43:52.2566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2/x5vgysY3uB7NGhaNe5gwg2linLybgwUywdovnucOJsDEgzUouZsME6WJ/gvvye7CsSb/Xy/hC+PXVDM5UqAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7266
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023 at 04:51:25PM -0700, Sean Christopherson wrote:
> On Tue, May 30, 2023, Yan Zhao wrote:
> > On Thu, May 25, 2023 at 08:54:15AM -0700, Sean Christopherson wrote:
> > And I combined the __kvm_mmu_honors_guest_mtrrs() into
> > kvm_mmu_honors_guest_mtrrs(). Not sure if you like it :)
> 
> I would prefer to provide a separater inner helper, mainly so that the common
> case callers don't need to pass %false.  I don't love passing bools, but it's
> tolerable for a one-off use of an inner helper.

Ok. Will follow this way.
It's reasonable :)

> > +/*
> > + * Returns if KVM honors guest MTRRs
> > + * @override_vm_has_noncoherent_dma: Allow caller to override non-coherent DMA
> > + *                                   status returned from
> > + *                                   kvm_arch_has_noncoherent_dma()
> > + */
> > +bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm,
> > +                               bool override_vm_has_noncoherent_dma)
> > +{
> > +       bool noncoherent_dma = override_vm_has_noncoherent_dma ? true :
> > +                              kvm_arch_has_noncoherent_dma(kvm);
> 
> The "override" name is confusing, e.g. it won't be clear when it's safe/correct
> for a new caller to override kvm_arch_has_noncoherent_dma().  If we go with a
> single helper, I could live with:
> 
> bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool stopping_noncoherent_dma)
> {
> 	bool noncoherent_dma = stopping_noncoherent_dma ||
> 			       kvm_arch_has_noncoherent_dma(kvm);
> 
> 	...
> }
> 
> but that makes it awkward to use common code for start+stop assignment, and as
> above there are three "normal" callers that would have to pass magic %false
> values regardless of the name.
