Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354207436C5
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 10:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbjF3IOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 04:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbjF3IOl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 04:14:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBE31997;
        Fri, 30 Jun 2023 01:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688112880; x=1719648880;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=s0/IAQwXSmJimiCdkTzHRgerxyjC64N5Rn6U+j/DvgY=;
  b=iiMwhgBz99WKkMbWURXHXJIWqhk5VuV2sXFFk58nwNS+8b4cG2AxoeLn
   TF5DGqFGFsw83dl4J02bdRR6+3F3tky88PNuB6RPv1+AXauLaaBqvbhTw
   DYBpzmAEt7X/INWL62rW7X2wdSamL7AYsalyDn39h318gfdBIiKReNoXM
   mJJrUeTFiQzwcelpVIR9yh+CyR4siVueM1EXYyv4R9mQX451nPwYI5hSr
   eOlEWn+2OJADuA2fcV/Moedi3r/Q6lBj3SyvG//RA8iy5x4ScdeRdGM5U
   ESWM7Db6IflDOgFjdy16PeywZpLWzCpTZY1OeUFuAeUSoTMBKZ+t5w+tk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="347123539"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="347123539"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 01:14:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="807683575"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="807683575"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Jun 2023 01:14:39 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 01:14:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 01:14:38 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 01:14:38 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 01:14:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=id7bjQn2kOSY9z01rZkCK10HvYn4RFQpmKvGRNgCHWw5FqFqE30QzBBDnEco3GT8oh8wilvYP8lcWr7GMWjpLCBifNJZFzXTU9mhMTtg0aWmUQbX01U6pRc8vLnjtoUK3B/Xw2dacViapNdoCuQ9fKVc1Q8vmI4/IYnrDQoo3XGegE6higZipB78XuiVPU0w9yE/IgErqUcQgX6KJyHsnIq3Ds5zxOZUv4kBq04pBFw3tme2/XX1tCGh1LGNkmxEIx/jlS819B3i/z+7+US8ut8hZTyQOV3Lh87QsUsRg/nrB2LX4QKVKkGpoQJyjjfbeDvEtUoYx9HudWFk7oyigg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=leu4u3CH8Yb1OVnf9ZL+SkkZRT/LXWetI5OhE9/8uys=;
 b=XZ4ndluH/Zw0byraF5oWf3WoTlCbUH4f+1kqA90sN9hFWFQVaH1kGNfFUUTKbRuC/Kh7kw/vu8CgK1TOQkw14hexkdySW80VgaNeK1HicY0G04HbgM9G50S9aUUl4gV2mH6EgBQhc60N4Zd4BKVYkeytMQCtwrAmLrt3e51ePAVNx9LP7dILH8T0I8dsKOh24g2N103AHjwPPG5UAD5WuxLhjxDGC4I/KzxMNDwpLmskG9z/oky89MlNnkBICODeQGSqy7Pvpt/sRbDTB6U+8lFk0dnS50Npy6KBp7ksl17zEA3y5sEfgvNyWf8Ijj6x82Ak2FxIr4mCp6ZhGaPlhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ1PR11MB6275.namprd11.prod.outlook.com (2603:10b6:a03:456::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 30 Jun
 2023 08:14:31 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6%7]) with mapi id 15.20.6521.024; Fri, 30 Jun 2023
 08:14:30 +0000
Date:   Fri, 30 Jun 2023 15:49:10 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <chao.gao@intel.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 08/11] KVM: x86: move vmx code to get EPT memtype when
 CR0.CD=1 to x86 common code
Message-ID: <ZJ6I9vEfbaSPR7Rk@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023858.7503-1-yan.y.zhao@intel.com>
 <ZJy6xcIsOknHPQ9w@google.com>
 <ZJzWZEsRWOUrF7TG@yzhao56-desk.sh.intel.com>
 <ZJ3sxm6CngYC7pno@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJ3sxm6CngYC7pno@google.com>
X-ClientProxiedBy: SG3P274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::28)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ1PR11MB6275:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e8f6be7-adcc-41bc-cc32-08db79420793
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /2mVYfFlTidVQZLclSBFqv4eaWKqki5ACLs53jnqGRadpBwP2xIJWOL9afVZ75HpQWcceSxPGhK8nREUrozl+m1oqrjwHuCVnz4XHCacwn4Ghdc4zvYsXCgbVoch5zT3BnpfSpcqSmUk4d1u199/r9gcif8JMD5VDbps/ruCn2nptMI+seBcNUCfM51+75cmRq4fk7O+rgL76Km+Yxed9WtaVU9+rTTGS3lWJfeGrpKBva5k/7cbPOCmIBsxUAZCYeePblluNi+zPlyNi5WcgTYaEhlsucBBaAFjW71PeFuJxL34cbNvzWpGwJj+kODaeW0NTQGmgj9hs0BKy8NNck//piBO26n5XXW2RLGuB8WX9oJo1dSfJR6zrIKI6Z77ODkIBYTtfjwm2KAV6fj8s75b8kTQ0wT8EswsfGe1NF0RbdkRXV45ZXwaz6mn+PHuiZb3KBjotRqpKaT7ymSRTK35gLY9yzBRZD47/Lwxw49/rsj2gbOdLZ+2oTJ50+yXpZbzqahGhhIrMK/8QxgU+sGIMT+wTvzPOtI/iz6jtYz3zY9EqusrY5v8Mo2Bp9EU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199021)(6512007)(6666004)(2906002)(186003)(6486002)(86362001)(38100700002)(83380400001)(82960400001)(6506007)(41300700001)(26005)(478600001)(316002)(66556008)(4326008)(66946007)(66476007)(6916009)(5660300002)(8676002)(3450700001)(8936002)(66899021);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ckza42uKXP/NtIokbzh5bNNUFAqEF6ZEjjR5P8qFKkwWQk2ooM6KI/j0gj1+?=
 =?us-ascii?Q?p57bW0urj6djdPz1cDAG665MG7R3BOPE/+xmJSXfyNwpNNKnGOi7MTS7T5Sm?=
 =?us-ascii?Q?f/HEieKDO6UjJCguzwX17r3gTQ55fZ9ofRzpyMeUylf84XmkbkMWZsNaTZ8c?=
 =?us-ascii?Q?Fe4GwuiODVY86iM8YVe6SiCOGSU1vaW7Rb0iO5ofLZecrPG8yOPXrLA4uu+7?=
 =?us-ascii?Q?VsiOfRmcCIlq/60ycxTBUvzvzCrsSrjfnhi3N1DfUky+DWvMO76ahSVN5mV4?=
 =?us-ascii?Q?wH+2m9RzvR1WhU4sR0W/OC0bFHKt6W3oQOMTl7YijTLkmwYA3eNGpU4Mh14b?=
 =?us-ascii?Q?dYLeWqdYeFqcdnp4b5OP4vmk5uqZMe6/6yoMCirKnrhylHltdXJRzh/j1hiB?=
 =?us-ascii?Q?krisx0ad3ggWTpP80o0hBxaAcjrw1B9AFKl8N2WDWdq9WPK2Yc5rGJe5bsa8?=
 =?us-ascii?Q?hkweQPOblLtyf4MYDXUroEVQenT2o2usf7pqgsCqpJJTMDO1tAM+EjFaHzCj?=
 =?us-ascii?Q?HBAA/MoyohxoWkR13yaQOUD4nnDpGlrW4LCukciFJKWhnn6dCJ17NB70uePw?=
 =?us-ascii?Q?ewIcMdfyE8wtTYVtzM9cwwKBBgTtDL8Twfh3pAo2jhr/Zjrc3l9JipuCJxw3?=
 =?us-ascii?Q?TkL17L0TEeA4330SmEsmt0IOuQJTnSQwFQ0yFMKZQmPLtxwWZYL00p3b1qD3?=
 =?us-ascii?Q?9BR7G6WHttRbG5RiZPlTSVspcwFytvb7PtmTdtYYMVYZjicPcH8eE+qz0ggl?=
 =?us-ascii?Q?od0aqZnU2Nny20x3Q07nEB8dPQ78gKjlL8O1z9ytMPQeu491BbyZKGVpzfXz?=
 =?us-ascii?Q?eomBL7Rannye8DWMVQxzqB4HhK2NVm5u9REYtrn6xZgQuAmbXYqOWclP58JI?=
 =?us-ascii?Q?EX0qsZKsSJGoW8rX26XCroPGBOyHz1cwFwVzBmGL1g5y3Zr9qPQCZ+/dWvVj?=
 =?us-ascii?Q?GZLyMrzLymVb6rsuYlxUcXUArcp1XkqUg6HfuZ9Gur2zGJ5VjRZKyAFMCWsM?=
 =?us-ascii?Q?TJtpgRt44B5DWWnciTHJWDfyAQBTD5Xg9SKc5GExQdl8Yhc9DEnieL5Y4BGV?=
 =?us-ascii?Q?pajThzm98sYkv+HszITI+AIYVRD+xnAy33NDLdT34HV6mduBxpKK7Jg7GVQD?=
 =?us-ascii?Q?6dxeNIjEVLRQsOVcaLBS/+mqZuzxv8CaX40TLl7jZsVy3SH+dPNpW2d+MMjO?=
 =?us-ascii?Q?c3SXJCLnc+VqolfJjmP2FsNGmwEAAWHHr2IA+ETMV+C12vgmDn7iWEF3hI0F?=
 =?us-ascii?Q?eeazyqvMbQAJ/dLJ7uXS1zKlO4ZTvL2MIYEEWtaqzInLYWJ5NDWFi2nvDJTO?=
 =?us-ascii?Q?417ToUcQfiMrnz+f27UHd0KOm3jkT5/x8Bwl6ivODc5yWAZ9hJKOTiAjy2wV?=
 =?us-ascii?Q?54kdOmwDdV2CAdn9BS+Gw3G8VsnweRX3FMV5lj+47Y/hljeUL3Qd/M1izUZV?=
 =?us-ascii?Q?L8dF047oiW9EDIXqvaTeyu6TREUZyOUgu73WvhUSJrWVXdjlBs4MCAgOCj62?=
 =?us-ascii?Q?BLligW5LY1Gy6oJD1aC8HYCKNvMQqGJ4m3wsXx+Xf41lszdGnb17i5Cy/Fo/?=
 =?us-ascii?Q?/uOA7l/GEmS7vhADKdp3kMZwVou5Vp/w9KoMpMhM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e8f6be7-adcc-41bc-cc32-08db79420793
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 08:14:30.6890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R88lB3PlLdnxNCH1R4kjfvqt02AD/qxiE3ZYbiX0o3Bm1RqIZJo+lJV2aa/9mjGKM/OLaqCz9JlNfPzZPuErPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6275
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 29, 2023 at 01:42:46PM -0700, Sean Christopherson wrote:
> On Thu, Jun 29, 2023, Yan Zhao wrote:
> > On Wed, Jun 28, 2023 at 03:57:09PM -0700, Sean Christopherson wrote:
> > > On Fri, Jun 16, 2023, Yan Zhao wrote:
...
> > > > +void kvm_mtrr_get_cd_memory_type(struct kvm_vcpu *vcpu, u8 *type, bool *ipat)
> > > 
> > > Hmm, I'm not convinced that this logic is subtle enough to warrant a common
> > I added this patch because the memtype to use under CR0.CD=1 is determined by
> > vmx specific code (i.e. vmx.c), while mtrr.c is a common code for x86.
> > 
> > I don't know if it's good to assume what vmx.c will return as in below open code. 
> > (e.g. if someone added IPAT bit for CR0.CD=1 under the quirk, and forgot
> > to update the code here, we actually need to zap everything rather than
> > zap only non-WB ranges).
> > 
> > That's why I want to introduce a helper and let vmx.c call into it.
> > (sorry, I didn't write a good commit message to explain the real intent).
> 
> No need to apologize, I fully understood the intent.  I'm just not convinced that
> the risk of us screwing up this particular case is worth the extra layers of crud
> that are necessary to let VMX and MTRRs share the core logic.
> 
> Absent emulating CR0.CD=1 with UC, setting IPAT is complete nonsense when KVM is
> honoring the guest memtype.
Yes, I'm just paranoid :)

> 
> I 100% agree that splitting the logic is less than ideal, but providing a common
> helper feels forced and IMO yields significantly less readable code.  And exporting
> kvm_mtrr_get_cd_memory_type() only adds to the confusion because calling it on
> SVM, which can't fully ignore gPAT, is also nonsensical.
Ok. I get your concern now. You are right.
Looks the easiest way now is to add some comments in VMM to caution that
changes in memtype when noncoherent DMA present and CR0.CD=1 may lead to
update of code for GFN zap.
Or, do you think it's worth adding a new callback in kvm_x86_ops, e.g.
static_call_cond(kvm_x86_get_cd_mt_honor_guest_mtrr)()?
