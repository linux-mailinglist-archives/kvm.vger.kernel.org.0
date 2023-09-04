Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8958B791319
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 10:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237686AbjIDION (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 04:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjIDIOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 04:14:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8043797;
        Mon,  4 Sep 2023 01:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693815249; x=1725351249;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=RwQ/cfQKnn4jCiviQNHdkkrYd/36Tcwvz1K6dQhWbok=;
  b=VZLBL06HKEAavqeUipGSTtODtmhuz7oStD2IoveXVSOgTRLw97xCcIFx
   yjJVXr1/UOnvDnBdwcr7fE5NAK4yt3acTFcd0PqJzYchp2HUr6iMXNufe
   3WUVCp5CNA9IbCAr/vJPzT4b06HFf5rlfztQIcKsqm16EMD0o3rP/oy4v
   OVaedbP/jfYoFAzU76aPt1XEDSpvXcA4hA689TG5xoMafPWmNtr3XG2lc
   3laiarkwkZi7AZLOd8A1slWF7uC9NdChk6IHKgaz36Ziy9Pg8DyF3Mu7v
   PEemCwtwlD1Y/3EM9eDqZri+kIju6e0i/kuW/CzsdxXJFxUJuneYMw7ij
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="366767801"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="366767801"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 01:14:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="734241547"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="734241547"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2023 01:14:08 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 01:14:07 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 01:14:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 4 Sep 2023 01:14:07 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 4 Sep 2023 01:14:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PG/AJoDxZHsgXULkwgI8BvZGEmtN6x+thgcBGRLNZ2KWdfGsb0WMNvNfZe1KcBEFOuCFOlTuSws0f2LQEIXXM6wlNNtGK6WVVOTvt5bswGYfugX5uUQuuELjqEnY0Rl4I3Nn7I7n+DTocLkq7WC2QmBx2eFBRTBpBs5j+B1r/OOLa5lzg0+ZswTTI1XG7+IxagRyEAFmMd90BAogpHO3LPkfsi0rG8cLFah2i85l83nMIbOZYdtb48FpPCpgnZ/vxX344oUDCeNph92npCh2c8QxHS4B7Jm/9dDEVb70UAxVd05AxP46MSFTa95GNWdW+nZ8BjN+w4zC/hCyEbT+ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UIfP6p7zjbssNARXf+D+b6ZgJsAFvTG+dMdLnHiKkLY=;
 b=mS9F4ReqNKRdZMP4k6d/Gzbg/ZTCz2GaLfN2IU/qn/WMQqAOgeCt5OWYpSbU30o8YC5PZLTseNRbydihJvde9ZltvIyW3wPrVoVK4C3bjdMUZxsOQRM0W8dMzxcrs2gmmE0SPxQTLERTD89I+PxxgBs/+cQnXxHNjU9Q8jCIKS+hxit4rD3gJdr1nMX7u57WOOhNIrKKDusEoFwMXP02q+Gb5Y3UQRkZTOf3CjI7V6A3xFo1jVwqSryjXJzHZBieOl0rJrvqpWet2xvZ/hidBRmjbAp9GPzlR4pR7jm/+rYbqWtbPKFzo4zZiURefQPA7jHvsWW9UFmQLPrklW1Rrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA2PR11MB5035.namprd11.prod.outlook.com (2603:10b6:806:116::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.30; Mon, 4 Sep
 2023 08:14:05 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602%6]) with mapi id 15.20.6745.030; Mon, 4 Sep 2023
 08:14:04 +0000
Date:   Mon, 4 Sep 2023 15:46:28 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <chao.gao@intel.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>, <yuan.yao@linux.intel.com>
Subject: Re: [PATCH v4 08/12] KVM: x86: centralize code to get CD=1 memtype
 when guest MTRRs are honored
Message-ID: <ZPWLVHSbwC+CBOqP@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
 <20230714065356.20620-1-yan.y.zhao@intel.com>
 <ZOkhH9A2ghtUb96U@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZOkhH9A2ghtUb96U@google.com>
X-ClientProxiedBy: SI2PR01CA0010.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA2PR11MB5035:EE_
X-MS-Office365-Filtering-Correlation-Id: df360bd8-dc36-49c9-648a-08dbad1ee767
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W2Fpj0rBPXBedWtmJE49xgaxu8yzl5+xDGx9gDmSxYW/ETX2G/YNlgfeT/FRA8KMtmFGAQT/Tw/FvLTOS+8GRl0r4t3HipjONaEItwHMAIfgaXFYssgN+49p/6Us2rmPbpH/fI4KE3SmSkiD1yHaGUdU99HMw0VOE8uHSJaVdXnAID9RzAlP2VAfXAxf15/hT4PsbOvVy7JcErxtrYGdDGRWhauz63K/No7sv4uuS2nCM2eNoHr18nD2VxmuTvle9P2QdF3be8ncNZjc7vmRyUdXsADb3ck3h+6xeWAmzO8IZDATVItPmbELkTxHgxYgRMJwSG9SB/e3WpwQBAAsX5s0jCD8xI9R+iPv8vg5m7SqRP/AVbxqIpGD2A9yYUV9Pfl7bzY85d/XWPVly8f7bas/wF9T4BITMT2q+JCG0EkxyY4HgPqWH1z4CCRVyx3JaTkCZFOcnDHsPYGl48a3LJ5Bgfec0RBsxl6u7D1aGCdawjKA2vQiDdapDzGYWhEIoXmagBHfLUqKQAASMNSvDxZxO6zHS9iuEGJf0pveTN0YKybsnCP1DHSWdwrIoiU+3ZKOt/rFMWA0Xl73szmQrZG+Fgqkshp/SbDGQLh5MwI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(396003)(376002)(39860400002)(366004)(186009)(1800799009)(451199024)(41300700001)(38100700002)(82960400001)(6666004)(86362001)(478600001)(83380400001)(26005)(6512007)(6486002)(6506007)(3450700001)(66946007)(2906002)(316002)(6916009)(66476007)(66556008)(8936002)(8676002)(5660300002)(4326008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZdV1lSMelASQjUZgsc9NfSslw5MOgyRuL6S+I0/eoYPvU1DWSTwfZVr9v6NB?=
 =?us-ascii?Q?s/v15j2iCyRvgjELAdmhw6xO943uotB9dM4FAO8nt6LdTc2cTj/8lJ+VZIf/?=
 =?us-ascii?Q?zryA5Pq8tBcEjRHlECVEo7m8DBDCW1yDk0KUHk57fHvVKynRSxW6ip4TQU4J?=
 =?us-ascii?Q?hfT7Gio3Nn3KwYeIbC+UMKm48etCf9iDs9FmK32DLD5dqpQem6+Vz059fj+O?=
 =?us-ascii?Q?/5GRF+VrpGOMpH7tL4rFabpHMIFNntzcfqnJ9YPZC++Wvxc2xYmqmA9K5piX?=
 =?us-ascii?Q?WycSDcz1U25Ul0MCymf/5PdxkwdEtACFHuydtRGodQhN0QFs6o6ll56QJKlr?=
 =?us-ascii?Q?4Bqu4nnCP7r6r6obk1jotBZqGeKLCDUV2n9gw21SWVulavt0YogO/sGmaZsT?=
 =?us-ascii?Q?Yvyy14dzZtZKalrqMv4jF8rMbeJF+6CiBTqr4aV3une47oYN0WNe3VEBlz7f?=
 =?us-ascii?Q?UsoxueNmJS9/A4C3AwDZHwmI3Yd7UTzyJ/emIdsvI87ZdIr3HRhYM4FShQHt?=
 =?us-ascii?Q?Csgu3CmK3QQgQl8ZlcYpvjvd2Z7PY26vupLzjMCdGGhRBBD8ZRQ40tBxQnKx?=
 =?us-ascii?Q?AeXKegK7chtpK59gT6AEzoWz28kJaykZbSOsU3psSaM4XajJoSrBKT48R8ym?=
 =?us-ascii?Q?37ljDHqD61tmvlqwdFE+7ZRE3srFF0T2jq76hYYq2i6ep/0GC58cO7RYTfKi?=
 =?us-ascii?Q?vJXiQCAbDpTXESZyc7bu+MVs4kdFgqzupqNlrJohh3hOSWtW2L5qtbWtWARc?=
 =?us-ascii?Q?bByU8VwnuvB95S8n7Ps7Te5RgYrrEpNY4ry4yY445jqi2BjqWQ2jFvlFrj8A?=
 =?us-ascii?Q?7BzdhDB62SylTLRYRXtJnsM25zsA46EP5ZYE2Cvo5xpNNr7VamCfB0WkS73G?=
 =?us-ascii?Q?CW5zVARTCPPakyoX14gPYiUkeCt3YSR+s2TUinuKAWKGqdOUDrNTL/YjBHJS?=
 =?us-ascii?Q?Fvn/vo+BZ8ZUdwnEHbM82gA+TSA73OZBY6llZD0WIjUlR5z9KarFcLVQ71Rq?=
 =?us-ascii?Q?Z9itP4jsQHd1IaeJqGVYEc4DW8Wol/sLgyXbg6a4V6oewOO7VwonL5TqZkZ4?=
 =?us-ascii?Q?h3Sw45UjRxhqCnz6IWIZJjOmWmXeMybNKkPi2FBlEDtMFNuyd+6GAcHXsSNq?=
 =?us-ascii?Q?H7yKIXYmJwKy/SJykmrIldJOXUtgOKkC37/bl74xYPhRQozAv942HtAD9v+M?=
 =?us-ascii?Q?WHLIumoEITuiCxHBLzJPO/5KM0B9Mgj8Z5ksWVX/t7NPWelrSLz7B67T5fDW?=
 =?us-ascii?Q?6v1RvnQ5ncdmOWB3r1zUS0d3crF8F1Vxf2RGQ5Dl2neVLBjBTSs20nrHiMiB?=
 =?us-ascii?Q?bk+xGsy2S9OxI/JHqgSjMxy4idRZmULbOCA4txLei8GZTChcjBdHsypJu/bT?=
 =?us-ascii?Q?qycFmHs1ohDtEefr9AyU0vIU9THsNyZWd2mEioF7bewaVa5kL+DoV96lgpMp?=
 =?us-ascii?Q?E6fB/f6mp0S1V1t8Y/RIpdrl6nS/Zame+vfGHgmfDJchF+GhgHR0aryRv7sN?=
 =?us-ascii?Q?ULecC1kjiFH2shQnNmemJzE7z2lfQEKP6kA9g3gqMn67NXwQI8nzIlUdjKlo?=
 =?us-ascii?Q?KqYvE6lylaRjMciwEuKAbwnuR19UwEAM5M3NyZVs?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df360bd8-dc36-49c9-648a-08dbad1ee767
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 08:14:04.8857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oKdkHxWBmnZ5BThTb9TrU3icX+FLHXsyYGI9tOGe0ZeLCU6tZTvkCqMF4Y2Bjzq4jarjlcGcShN7VuzI6AdtOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5035
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023 at 02:46:07PM -0700, Sean Christopherson wrote:
> On Fri, Jul 14, 2023, Yan Zhao wrote:
> > Centralize the code to get cache disabled memtype when guest MTRRs are
> > honored. If a TDP honors guest MTRRs, it is required to call the provided
> > API to get the memtype for CR0.CD=1.
> > 
> > This is the preparation patch for later implementation of fine-grained gfn
> > zap for CR0.CD toggles when guest MTRRs are honored.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/kvm/mtrr.c    | 16 ++++++++++++++++
> >  arch/x86/kvm/vmx/vmx.c | 10 +++++-----
> >  arch/x86/kvm/x86.h     |  2 ++
> >  3 files changed, 23 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> > index 3ce58734ad22..64c6daa659c8 100644
> > --- a/arch/x86/kvm/mtrr.c
> > +++ b/arch/x86/kvm/mtrr.c
> > @@ -721,3 +721,19 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
> >  
> >  	return type == mtrr_default_type(mtrr_state);
> >  }
> > +
> > +/*
> > + * this routine is supposed to be called when guest mtrrs are honored
> > + */
> > +void kvm_honors_guest_mtrrs_get_cd_memtype(struct kvm_vcpu *vcpu,
> > +					   u8 *type, bool *ipat)
> 
> I really don't like this helper.  IMO it's a big net negative for the readability
> of vmx_get_mt_mask().  As I said in the previous version, I agree that splitting
> logic is generally undesirable, but in this case I strongly believe it's the
> lesser evil.
> 
Ok, will drop this helper in the next version :)
