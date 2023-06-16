Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4468B7329A0
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 10:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245211AbjFPIQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 04:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245219AbjFPIPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 04:15:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A31D30F7;
        Fri, 16 Jun 2023 01:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686903341; x=1718439341;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=U+dONiqgiv9/LHtbUk1mVlqM1xgXwTivsuZ9bSsFoHc=;
  b=Xw69qsrdghh7f8SujW/86vQJdtXeOdo/2VGkDMuHi9epU3LHYxB1Q+zi
   o2bJ99I+F7XdtSo0Xa8GfiALJKz7V5s0QC/tR8vwOgH80XdpBk0sEqKcY
   pkAwYSv4RFzAOqYAzf5bd6tywX3hMhbN2UVe7q4veP2My0TLn/YA3g0ew
   GWCX+WUsUibrg4ExklaZ+VvjSJ+Ipz6fOJamqTHYRECM5NE3Pazctxg7K
   xdDELM2LEqSyiVIw3rS3KSH/oea65bMsSHCySuyASJahFJE7+B3qlfb45
   bQJ27bmdcGwtOr+JhuCKOdT/hrE9XS8mey/P4Wnx+liXQJb6pvo7NymLa
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="338773192"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="338773192"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 01:15:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="959539619"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="959539619"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jun 2023 01:15:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 01:15:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 01:15:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 01:15:39 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 01:15:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/qw1Q4YJGlEKO2IcxHQVyx8+BGK1gsER80+mO3oN2/rjaDUYTtlGDkukQzsJ19pBxrKuvzCg3byUVk0cErT06Hax0QPFKTXJqraVZz1t8mmBRa/TPR0rXT4PEn4asgDhr4QaDH6OG4EN6Tc7rGzNFOHDg8iD4i5KHiJQ2kzd6MFxsm5xIbOcj/0oxTR2kgBWHOU7WZGpTORJ3mBDcSHcIUmMBnRmHHjRiY9mrGC59G2X2bww57OIf5vpOKbZKZu965w17wQFwmJTJ3xptmEbCORDUZwGEOXq8YAIDbqwbRqbmtUALhRpEQlXgD5ckZSuAsDDMG1fGts9/bGYGoadQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEpUqVIvTYX4nphLpoE9olnZYA4l1x8pU8IIm2Lx8bY=;
 b=jLvaxkP2Dsm4Nau/vNIBpRi+hT36TJTQ9jbjp+Bibr89tIvwIYavaJtWTR5FL0MriKNwMjPpBQYhknM2U+bpI0Ns/HpijMcotBbtapLiTvb+YMZnZH9l9D/F1cxElzSp3cfqOuPB4hyJZXitQRPIBns1C+p7DUYIMLAbR7gjGhyslNc3DqXZbHARnYUaHNwwZ4tVjtOQvHAFTRL+zxR5XDwLmRsIDwSNlwAy2lgIaR1XREhFM+JxksAtJPbj2n/W1vSktWV6K26ozZldhuRfTyL9VurR3USCedPYVmiS+CzWCVXhlTaq/ZAqN9hQL5n5EutbNgm6WkQuEDvx3NynMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6223.namprd11.prod.outlook.com (2603:10b6:8:98::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.27; Fri, 16 Jun 2023 08:15:37 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6%7]) with mapi id 15.20.6500.026; Fri, 16 Jun 2023
 08:15:37 +0000
Date:   Fri, 16 Jun 2023 15:50:19 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <chao.gao@intel.com>,
        <kai.huang@intel.com>, <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 09/11] KVM: x86/mmu: serialize vCPUs to zap gfn when
 guest MTRRs are honored
Message-ID: <ZIwUO/8W7dRYt2s8@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023945.7570-1-yan.y.zhao@intel.com>
 <20230616074550.g2ikzbni2rjy7dfw@yy-desk-7060>
 <ZIwROWti5d0sCFwT@yzhao56-desk.sh.intel.com>
 <20230616080917.fhekzs2fyhqtbitx@yy-desk-7060>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230616080917.fhekzs2fyhqtbitx@yy-desk-7060>
X-ClientProxiedBy: SI2PR01CA0052.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6223:EE_
X-MS-Office365-Filtering-Correlation-Id: e81f7dd3-2afd-481c-1bfe-08db6e41dd0a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fgFgY+eh7QwApVJky4eg9kuuLDE1SIqrHi/iam7EZ4WAbnv6jHWAzhD6daJIS+rpRePTFoTysprVRXuPaF65EHTbt+lMZ6prUFkHJHwftcby8jPC4IGIqZypTjhLBTjegeBy6z4L9MAYLsmCWCudon1Som0MXjD558029Vui52h1I6bt/c9FGjMytUvHMVpyYGE6uJO7/jyuTK4CavcyNki5M70hkN9XPjDpJxI1HblDQ/5XaynMQCoxrXD+3ey4MLEhHp2Lkjws7yySnUY1yZ2ocN/I5uW7PkWKgOunJ/RKmzSUYIdvLR5STUubSB1smd88n1T8GS7+MtRUJ4YYN83iePmKcWiQNRRUcM7w93xy5DENUT7GVVS94OTGrnGp7lh7RPRa/VIRsrcAU6MIzPMPCRXkQjFgakSqfkcIA3qYTlDfdORcYqor2tqunIx+lZwP+s7qKkfec9JoLEtnjTOp6Q+PQZtXC8IIRJ3IE97CsYo7Kki5q3UPuJSa2GSn7VpAi5UIx66f67aD8OntAO/X4Xnh2O0Q1hi7HzPLiOYsShNR8OmVq6t5QMMsySHI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199021)(3450700001)(5660300002)(6666004)(54906003)(2906002)(41300700001)(8936002)(8676002)(316002)(4326008)(66556008)(6916009)(66946007)(66476007)(478600001)(6486002)(38100700002)(86362001)(186003)(82960400001)(83380400001)(6512007)(6506007)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WwPxe3pVlaaTY0Xin4oS+XyjLTdyq9NlB9sBFSWQJiHqNOLrf5WigBlYXfAS?=
 =?us-ascii?Q?fHjU5sZ1Zf/b5pc+rTGjhdeCE1TmqLTABEaTDwSx0wtEsO6bqhsXRSx9RVOH?=
 =?us-ascii?Q?Wx8MCgFqYiAz6nCMmhU3Wab2BTquho1t9OIcwFQm2WkvJoHc1BlWZJXdRGA4?=
 =?us-ascii?Q?80zgtb3gHsZmG2OAxR6tl3xKiMVBgueFeGvVy2JhbqqGM3sUO9gd50p45j5v?=
 =?us-ascii?Q?qQJwOuVkXGZdmMNZh+/k/4MzBjSRcoGMLgCRBec4+HnomeBx9qjcJk6k4fLB?=
 =?us-ascii?Q?TO8L4VtSLPotylHFp5Cvq4TwNjQiKEHuKfgVJhwej3Zn3kPN/z+snrYsiRhF?=
 =?us-ascii?Q?lVRMiIKs0MOcuG1v8EEQRpCY52+p4ZaMRwRZFARxr7f8/TWdpflsz1dZ7o33?=
 =?us-ascii?Q?OJ3hITyhiabhvp7hLXO6ygqKepv/HyZiHpxRlLU9iK1EC8EsSe3kMpGG8qr0?=
 =?us-ascii?Q?3MlAweR8t7cId16aKOpFhRrS4YV/dU3UmI7aeuk4hdnRXk91XRtcP1YBqMVg?=
 =?us-ascii?Q?km1vcg+VRe5RoJ53KzlWojp9kJQ4u3gjnM9RdS1LF9aA61yuPVSYPPuxffMK?=
 =?us-ascii?Q?G+mz7AfzwNk8QgqCtUXUxlBka45ntUWSHZrEkAR0qCFf5Q8TD4lxok/ra5V2?=
 =?us-ascii?Q?XGXtMTg/gKEC/UQK1qqXCi9buK8Bh36Gy8ROv2W266Lr2mamKKwQHJ5FOCy+?=
 =?us-ascii?Q?TQ1UbbweaItadod2vVxDzOTj5OApAMFe6KPMJWw80rqxy81USXxFesuWc7eM?=
 =?us-ascii?Q?GOKV7Rl/cGTNcBE25gQe1dMhqptVFsy/5u2Oc2o8lAll5wIQFWWZ/RKzlUQ+?=
 =?us-ascii?Q?YGOlKEReEM3VI2281NUA07iMMwhcRadBE+/w9ve2K5++ibxwkvVEXJaC09z4?=
 =?us-ascii?Q?rUegInUqnIMmyNn+5gwyLltY9PcdVjy2XGuPZIfdSHlTnPwbdzWf4I34iWlB?=
 =?us-ascii?Q?c5enltFvS27iiXXvW2dyIusqQgamGIFqlWMpoVxKeWNyVXP5mjrpHKCAUchl?=
 =?us-ascii?Q?EyCIoLxtX+dOkFF50nReRPt6YWQdKp1XI33CvC03wmijsIyVQFnCndKWfA5g?=
 =?us-ascii?Q?o6zsGMW+kPD1RJYZoDNrGxr5CAcjpgP7RAzkGVFHaiYZqGe/GXdf2XCfhmbh?=
 =?us-ascii?Q?69y1QDMbBDubsfYhUXAOt0nUevvaAg+72ZUjPw14pxfZXDaVwPcgmJxLckvE?=
 =?us-ascii?Q?BBvGy8zitGLqMWEWt7ViZHkZcNijUXWCzyh+cThH+h+hB8dnmJhjgxeSAXBe?=
 =?us-ascii?Q?ybecdk9l+WoCMQNLlvpZaSeosrH++6blrCiULmiqSqvrs26LYj+4QJRtvOuV?=
 =?us-ascii?Q?WKkbySsgNIUeEnC+gEwvXb1/iTV4MG/cch8oEnTTtUZeZnOxo96zRxt80FbH?=
 =?us-ascii?Q?2NQtyydi4jzMZNRxG6F6bWOS9+dRzwHp/tp131JiF70dWPVPfgJHZjQRtGbZ?=
 =?us-ascii?Q?m0or5WOzl2OeDwt7sL2BsXhusGhgGOJ24j7+mz5jcIRpoa7L5Yc2Q6KaKi7J?=
 =?us-ascii?Q?TqS7eoYDj+iU/nGEgLYVFxRvQgQzgQm/dFKDisPeyrRtJtXol75pMdLJlJ2E?=
 =?us-ascii?Q?ZKIe2plPtvaJ7abRG6FSzsW9MfE8B0d0PMzHp8CE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e81f7dd3-2afd-481c-1bfe-08db6e41dd0a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 08:15:36.5600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 26+STPTAwZXd1t5fkYzlhS+cmdQa3vrGECoPgOMzO2YzLnSSfSPwfCPFr6WPk0bAZ73z50saiLAVr56udKWRLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6223
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023 at 04:09:17PM +0800, Yuan Yao wrote:
> On Fri, Jun 16, 2023 at 03:37:29PM +0800, Yan Zhao wrote:
> > On Fri, Jun 16, 2023 at 03:45:50PM +0800, Yuan Yao wrote:
> > > > +/*
> > > > + * Add @range into kvm->arch.mtrr_zap_list and sort the list in
> > > > + * "length" ascending + "start" descending order, so that
> > > > + * ranges consuming more zap cycles can be dequeued later and their
> > > > + * chances of being found duplicated are increased.
> > > > + */
> > > > +static void kvm_add_mtrr_zap_list(struct kvm *kvm, struct mtrr_zap_range *range)
> > > > +{
> > > > +	struct list_head *head = &kvm->arch.mtrr_zap_list;
> > > > +	u64 len = range->end - range->start;
> > > > +	struct mtrr_zap_range *cur, *n;
> > > > +	bool added = false;
> > > > +
> > > > +	spin_lock(&kvm->arch.mtrr_zap_list_lock);
> > > > +
> > > > +	if (list_empty(head)) {
> > > > +		list_add(&range->node, head);
> > > > +		spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> > > > +		return;
> > > > +	}
> > > > +
> > > > +	list_for_each_entry_safe(cur, n, head, node) {
> > > > +		u64 cur_len = cur->end - cur->start;
> > > > +
> > > > +		if (len < cur_len)
> > > > +			break;
> > > > +
> > > > +		if (len > cur_len)
> > > > +			continue;
> > > > +
> > > > +		if (range->start > cur->start)
> > > > +			break;
> > > > +
> > > > +		if (range->start < cur->start)
> > > > +			continue;
> > > > +
> > > > +		/* equal len & start, no need to add */
> > > > +		added = true;
> > >
> > > Possible/worth to ignore the range already covered
> > > by queued range ?
> >
> > I may not get you correctly, but
> > the "added" here means an queued range with exactly same start + len
> > found, so free and drop adding the new range here.
> 
> I mean drop adding three B below if A already in the queue:
> 
> |------A--------|
> |----B----|
> 
> |------A--------|
>       |----B----|
> 
> |------A--------|
>   |----B----|
> 
Oh, I implemented this way in my first version.
But it will complicate the logic and increase time holding spinlock.
And as usually in the zaps caused by MTRRs update and CR0.CD toggles,
the queued ranges are duplicated in different vCPUs and non-overlapping
in one vCPU, I turned to this simplier implemenation finally.
