Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D533A741DF1
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 04:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbjF2CIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 22:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjF2CIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 22:08:37 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870411FD5;
        Wed, 28 Jun 2023 19:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688004516; x=1719540516;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=/Ocz3dWLH4UfiQHLCdKCanvUYBXiCiSj/ssbiP/w20I=;
  b=CRlCLSLflKohRiJ8VSj8rMfe8eXeyZINFzzogRs6fV3Ax5cT7yuApC03
   kgvzesZ1ktP0vcfDRlxwf94+2ToZCv2AMunaVDAIAkgvL7TgIVlayxq1X
   gkZFazmjpgF7OzlRlDx7lW2Vb86PR6tYfKMOyBrTKFDmg+0W4YUJPzMKr
   vMjdGKql4IhAC19o3/0p8qe0ukdh15Gcgf/BD5VPVna2m5CJcBKa8LoJu
   edevqKLbdt/1Ebo9F5F79VcoVE4Bhr0IYUmfhT+Ocbghe5IflzkPjb8a1
   PvP9I3YO9/MCAT5rPLF9A5dYq+RwdO8MKibbnV/6lUIswBCvIvD+poOwm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="392727220"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="392727220"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 19:08:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="807147784"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="807147784"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jun 2023 19:08:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 19:08:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 19:08:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 19:08:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 19:08:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZlRszQQOgBR5lfL2XpybinLoTIUy4Daxt2pD1xzrhtl6WpdCLIALKozlqsV0Zwm51uFhNALHA2JTtwu4Avmc67ge0Tyutu64iH+HoPuUpztw1bDMnK8eWyTBFYP2Wi4mNDDbCwgh5UBIcVb59EN1oHS7bLn80ISBu3CCxK7kbE64MQ+1TCRnQ5BVjQE9LkUuAPqdkB+uVo9W9w5o+R/85HoywCKCzxWXVvI5w8OQbIgWU+GKNN1dqVX7WvqgvoabgOLXEULSlQnNqXCqWV08hmxmZkewt5ydKSvXfXrPNr8xZYI/PHxbFMifPYhOgTn0lRPLa/+jtUg8ux/+r18DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TUzn4/yhubPvdWxLYmL6e2ua7kK5fRaoI3jiaob8IQI=;
 b=d5HjbjIat3VR+k5BkLWtyUqlLHyoc1KgJBGi+E5zjHd5Iem96HVB7indcHfBz/SgkMnUdeYfw398QnsT/D80l38eJ9AVI+KZa1guPIPe7Z070ConDnF3NosBr7RWonmt3J3ucRYq5EOuAd/191CR78BiRrwDIFnlNsOYBBIpRB27hgIANypsRSeljCR9hzEGxcqBTJSO9Ud20aqmzO5dZYe5wP7Q6xJqx9wiKf9ml/3nRIiZY9FZWpMTIXNz/IV+gRmBfGSPBKJW8e//Rt3htZov+ejjPavN76qTVK+i9SUk0rmdXgFJXGX3XTyfhXWZEWxdlIfsgKIijy+p7IMCBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB8455.namprd11.prod.outlook.com (2603:10b6:510:30d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 29 Jun
 2023 02:08:09 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6%7]) with mapi id 15.20.6521.024; Thu, 29 Jun 2023
 02:08:08 +0000
Date:   Thu, 29 Jun 2023 09:42:44 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <chao.gao@intel.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 03/11] KVM: x86/mmu: Use KVM honors guest MTRRs helper
 when CR0.CD toggles
Message-ID: <ZJzhlDSE4iaUryZ8@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023524.7203-1-yan.y.zhao@intel.com>
 <ZJytJB+mwdU6v/XJ@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJytJB+mwdU6v/XJ@google.com>
X-ClientProxiedBy: SG2PR02CA0101.apcprd02.prod.outlook.com
 (2603:1096:4:92::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB8455:EE_
X-MS-Office365-Filtering-Correlation-Id: df35b44d-ddbd-4eba-f558-08db7845aea3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Og+FZPWENGZlkjI5L17KOQf0ossMHpQt4QdmbxKbzdu2vA4Z7aCa1VEXY8P3dySO656H/o3NHCj4ssy3QnA7mttSyp22EsdcVKVSImrffB2W6GdUdrWneBSAdA2SJa0cu/U4V+YChHnuLaJvGRf3BhwBUo8MPvdyVFqOPTRVxRMR3/q45F5fWE/wtg8aJnhdzFLtD42oMr06hBIY8me0AyZPEOLdH4LCKXxcuye9u4oh/dKZfuXDGHEqZWFNUaKqBXbxfb44Hj8Uh296vqd9wbiOHyIiO6Mg3wsx1pS8uUQ4NkCFCI4doSpiTGsYbtefIa205ne0v+LB9rBBIf6asx06skMdofxAdlJogTG+ke6osaGAoow8KwaOHYCesm2vP8NkRTdc/e5CgTqSYF1RIv+lJ/SsGQ0ClxZpuGaK9SrM7g7FvAPdjfj2pM0qnvj677HJdoLvy1oaezMa3jMRLorFztc7FGxuAF9sMazJNUBb1W1MwpNboAYgWFL+rADaMQQDwDojesWj2y83XM10f4K4Q8olHjgBbDFsBe+bjpaMMLv6Le1ysp+xtIeM4mhK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(396003)(376002)(366004)(451199021)(26005)(6486002)(478600001)(6666004)(2906002)(83380400001)(3450700001)(186003)(4744005)(6512007)(6506007)(5660300002)(6916009)(82960400001)(316002)(38100700002)(8676002)(8936002)(66946007)(66556008)(4326008)(66476007)(41300700001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CnBhaxi86cu0YhAQxeHMs5/5b8kNB6VZiqS9WgSGoXqR6cA9NGZKw0G9Oihn?=
 =?us-ascii?Q?ViVTiw99jnPgSRlYK5LuefdopIHGcGfNoBdcfGWfFAc06hUjQnC2T51haLqr?=
 =?us-ascii?Q?KFjV6DNeUjqYrau87aus9Dpks1bYnafGbPfaPxCn71kvFLph6nRdAs6i7B+W?=
 =?us-ascii?Q?8rxIBlZEJybuLIQBsbvjyRSvnyU52WNSal2aAmoZXUYtpj31vWq7gc5zrgIj?=
 =?us-ascii?Q?xM21PWts965hewOKh+i2Dyv3oKr+zAKVeIE7ejQL/XQ9LYmxzOjz6j1APRnY?=
 =?us-ascii?Q?PL0VeKgWSc/ixXX2Agi4JCZk+TgdRbvTZsOcD3W+aHQwb+Jb/PdSj8qD7975?=
 =?us-ascii?Q?9lTpIsaK0zWhhWxZNbpiF3XMVutzwTPa7l/lrNVXzqSt05CW4cLJ9GIsRm9t?=
 =?us-ascii?Q?xH7r1EUhQYUpgUI0yoDMw2Rq2GjeEQg+in1XmqqH3HQCIdyVggR8vCTnLt93?=
 =?us-ascii?Q?XIuNz9wHvzD0zeByYepiQPZREvHA1/k73oNNj0Nt/WATRCcGo87+GKqiGc1a?=
 =?us-ascii?Q?zW9XGkXqPEzw/FLqcfxqWTRROyRbcw9C0W80QYnEegtQDmyfZ7yiADLElP97?=
 =?us-ascii?Q?dyF7mqBDctmqEr8FT84SMWmQsBNCHkh49omROKivgO1ear2Fhq7elRGvekWs?=
 =?us-ascii?Q?/yPsZDmVQkvuInj6n2gxq3T2wkRNIucF00juve+rym6ac8NXHiP8KdRCSezS?=
 =?us-ascii?Q?Gifaw+dGj/ktX2/ulH4I4Mk+Yk3/NIrMBW8SUtskvNQ0BfLM9N4VCtlJec8H?=
 =?us-ascii?Q?2ro4YaGVFeKIp089I6taMkXKTjGU7p2e1t9OsLBoQfWFurDKJi4SUuKcSIub?=
 =?us-ascii?Q?rYBk8oVYKKJk+xZNVi2E8MZMOIJKFaSr8E1EJRiL4+1yozLF2hdCDx/IRg9D?=
 =?us-ascii?Q?tTjUr8QhyBxtXKIWLEOQbYpzJ2oT7wo1IS0UsW46XiBpqDGxpHgDa/To/JdO?=
 =?us-ascii?Q?7VMCineMb8xMToFiw4LAH7VyEbkfW10idvBHt/s0niHC5sZl1ptuuc0GQ2Oo?=
 =?us-ascii?Q?KmgoXc9fwnoX2p/7Y49K8wpq4g9aY//nJ6u0rZ08P8F+54WXlLA9fn4cqr/D?=
 =?us-ascii?Q?Y0KkoDUK5C8xMtrYiWQoKor7ueOQTfk3htD73omyRkHKRgd9J+WxMdmn25aj?=
 =?us-ascii?Q?Is+blWptEtAYpAqYUUZePzQIek+QEbDzcmSD31N/MpxmAiqCnKu511oeyCGm?=
 =?us-ascii?Q?FHoe5nzE1eq1VDOCPwvJotTSLgDmuHAybbCdQXtn2PAcNDGgnTi/ojaSZwlt?=
 =?us-ascii?Q?31klkryoHsUG6FVfiD3x20ifNmrzJRlwXWHXG1a7mU0bk/qhZnRbbkoEbIah?=
 =?us-ascii?Q?9P7+g11a2Bt8G3Jeg877CWjWe3374IZDNa2Div0oVf8embv10VoSJ1wWwiAR?=
 =?us-ascii?Q?PrReWwqApdVRAUArZt4Oo/IUxkk3QG2/cIGvNJZEipHjpytzsFGNclsOfKmd?=
 =?us-ascii?Q?FMllEwdkLFJ2H3eiMMR/sSjsM66wsYE6gZr1eTP1lI2AEHMCimz+rxex8pg0?=
 =?us-ascii?Q?5tDercqyp4RDWXkkYcwsCKywlmsEizAek7zuSoRRUAuzS642VbZoVdGZNn/k?=
 =?us-ascii?Q?kv5uXiECUiI6MZvO+qqTj8K9iSK5TDCNq7SPTRsC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df35b44d-ddbd-4eba-f558-08db7845aea3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2023 02:08:08.8041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u5e6fO44jUc8RhpbpjAqtok1Rl6EMxSHKuDQdgFwK0b57sRLPWirNx9QZzjhYDLywseQX4b/0N0NsUfS1Ztm6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8455
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 02:59:00PM -0700, Sean Christopherson wrote:
> On Fri, Jun 16, 2023, Yan Zhao wrote:
> > Call helper to check if guest MTRRs are honored by KVM MMU before zapping,
> 
> Nit, state the effect, not what the code literally does.  The important part is
> that the end result is that KVM will zap if and only if guest MTRRs are being
> honored, e.g.
> 
>   Zap SPTEs when CR0.CD is toggled if and only if KVM's MMU is honoring
>   guest MTRRs, which is the only time that KVM incorporates the guest's
>   CR0.CD into the final memtype.
> 
Thanks! Will update it. 
