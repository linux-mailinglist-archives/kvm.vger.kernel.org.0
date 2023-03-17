Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045226BE45B
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 09:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjCQIxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 04:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjCQIxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 04:53:43 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E16561ABF;
        Fri, 17 Mar 2023 01:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679043219; x=1710579219;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=23lMRSPe0y+duSdf/9KMbxIKE8M/oe1zHqTsxpbCLU8=;
  b=BQ91ssGBR3v+FqAPPQM/ygDEpIqA5LYjQ2H6bez7/h879QgVOuAhS5/3
   9I5efhI5wZx6DnXpTxSIO31HaRCKI51FZC2qYzFNcVJE+6cNCZ6rE6kdH
   IhDO8ImVmlKY0z3CzkWAGXz+SOOR1TbDa288MROD2V4V4EjQxrf2H3DD7
   F3BJtFoG2YePlmCnGJly339rJezMMTnYGxeNUAyPa1SUqhtJAoAVpsooj
   bbvWLVbsutNGIYpcUQHdoDXMO/oh5ZJcPX++ogy9TY2xEujTXBu+h+0Rv
   6pWpQs/XiZJXSxmrSHz2/DwSOmLIERX+unFR/oB4LAgsya1x/IGTL7y/z
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="340578129"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="340578129"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 01:53:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="710423630"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="710423630"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 17 Mar 2023 01:53:38 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 01:53:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 01:53:37 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 01:53:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 01:53:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbACgVqKPYdtjjE2BLhCzJt9uIZ02ulS5l62w9/PfGe0SIjnP+DiR7x3IUmipPMejUZAxlD8qsbNZLVus5OzqaVmHxi93zapOxQ6zdllTGCfFK+fKh+AbX+Qi5l5aGZMLZF5BKnRemhHqZmz0d7Q9Sk+8GcOCFffVZ9JLbsqMGTzX5FGUq2oPC8so6FxwUUGu5aiv0gu90z0AKGYj/Lpi6mlsmCxSOXKtbPJcpaePx4xgMYiNh9DI+2vh8Cn+WSzM9QILjEQHcDwGWbWu5fe9MTlvF1pIelQnvPmW7v+TcdKkgLIIt4ZFD/vOn17T0j25DMK5FB1DCkEkp/Twx1ceA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ltcSREgpnaoV9SoA3ivl37ZuXNTAWx2RYSHstLOv2PQ=;
 b=RJsmEZHG9D6fKNP23HvklMlhHQRV82v/zGzKyP6EKg4j0x5G68uCj4k91OK/QwApVScXo3OPOX0UjAUMQ7V46DhDZ+cPlB6yBep0lzzU+ZQ2Wt9RQtjpR6nFHzu+Pyqm+25oyzZpPFUptwFBbyDG+4w7HioUpboDhYz5p302ZaYwqU7rC4JyC5X3qRW2DM9l1hN4eCPP4rT5jj5b2fcDZrjzVmCe3/npTloLy/J/KHD5i01QywxWGbj0a2NTNU7NPg+r6u5k9hFh9VA9A90vnNjQZFFXu6AqKyO7U/fyFJoiZHA91rkIkoTdqsJBHzHxdL2KySZVtibks/xECmHORQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7179.namprd11.prod.outlook.com (2603:10b6:610:142::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.35; Fri, 17 Mar 2023 08:53:34 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 08:53:34 +0000
Date:   Fri, 17 Mar 2023 16:28:56 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        <intel-gvt-dev@lists.freedesktop.org>
Subject: Re: [PATCH v2 25/27] KVM: x86/mmu: Drop @slot param from
 exported/external page-track APIs
Message-ID: <ZBQkyB3KJP34D9/h@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-26-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-26-seanjc@google.com>
X-ClientProxiedBy: SGBP274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::21)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7179:EE_
X-MS-Office365-Filtering-Correlation-Id: c47aeaaa-055a-421e-c381-08db26c5173e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aTDLEeqgHFylHohua1H0u7q2deeaJqJv+PeChDA/LScEan+kSREvpC4Uh/DJfoMP6S18v8+KnBHxAjyHZaF3tE5UFw0O+aAnTHiteIcGbdJ7rOK6JH9YIgw1Zwr4lm5AqkHUaPz8aIAu9jN96VOJ5VIe/BkVyIt0dMREtHDvUxzLcT7ysWjlNPf7kDTfjBGhhf/AuWS/FasCYpr/ZvnSUVLsJqGn745kcomScjVOpYcE5OD6NDbkLvM1nTXL1aNHYpmwYk8mzHf5MLJbjeVG+P/HzJgXLe3df32noQaial1in4WGwrQDWxe3Y1i+lMmrPjEhmCtsyAPvwHU4AgP+tqiJDeddSg3p4dn0t9VikUrhF07K2bt6pFs0IZmv0MC7VC9ZcrSjDqiqGlejFc+mJ0nk6S7AzDtK+RuQsK15gxuPe4ubVqMewulMu4XVo4SdHtokFAs/Sumbo4hsj+FSGluWTWgRvWW3772c15YwyuSGwnXTHrGxOKmS9wYUUMmDjH/3gQ04uCjKJwewfiNPnsNZKG3qIVQ+oHDYaRcHq1S7S5TMumms1hmqCUpzsj/vaU3is/vyKe1ALGLxYe132uodtZVSz0lRkmGDlaq7v10HnxrlG9qg7oNjiBTYZfgjlWKdfO4SSdHUf5IolST1sA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(396003)(136003)(346002)(451199018)(316002)(54906003)(478600001)(83380400001)(38100700002)(86362001)(82960400001)(6486002)(186003)(26005)(6506007)(6512007)(6666004)(8936002)(66946007)(8676002)(66476007)(66556008)(4326008)(3450700001)(2906002)(41300700001)(6916009)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JiCRr08+1cSg4OpSxevUy5JEYeK/+NH6tbNqcKV+dijaaaUJ83hw4/nX0lhq?=
 =?us-ascii?Q?vl5FAIvveVeo3gnIESX2IreMF33iRDDH4OuHNEWGgw9Qp2WfEqL6Y4o7VBjG?=
 =?us-ascii?Q?1ERogJGhmE2mkn1bmYwWfv+240H9ciXYkoej907Uk+CWMHeUxXTCe481FJDc?=
 =?us-ascii?Q?xDNtYSdmXZkmTvZeOUmkMYyCPf/5oWQBb9WPULREwI8JKXV9R0Au+SsOFMFI?=
 =?us-ascii?Q?KRit9zRb6biDfJQ8iUX8C18uZAtEsX1NJDudu91jccSvM/hH4+RxKA5SU+ER?=
 =?us-ascii?Q?1ztONVVytV+hGmJVyeolc8y+4+ADvy4s0EXF65idieJDlMMAOuMoLRqU+7zQ?=
 =?us-ascii?Q?1rSRrGY9em+7R0ZzQ4axaLrj/zD9eMieycvcNzc3pR1PiHSB5R3WTLr7ZXhL?=
 =?us-ascii?Q?Ru81k3LoccB4sJrSFzAMhdxyPujMrqNLR5ZaZySm9s2Izq+AkiBGib+msw3U?=
 =?us-ascii?Q?/oddWqM1J7SiHLHVXG2H5TaHnWgd3Lk0dtvFc4n5bPOeLvXfibuwTST86Fms?=
 =?us-ascii?Q?iFjKjJ9HE+l6Bptw6IMmxajLKIvwzGsHJqVviuaT4hDJzqRH3hpxwdyJ24eL?=
 =?us-ascii?Q?Hymbvbp9aUmACx646YxiiYpSvi4PYeE2c0hhjCg12NWhwOtVTBLA6DceRbma?=
 =?us-ascii?Q?2KtLSalse9GS7LsVwg2Uhx14je9CRUnaaEota7EVkQEMeGr3W6xE+Elz5FQJ?=
 =?us-ascii?Q?B3ekN5lVrlfxhOckrfN1Q6Pml5fyWdkp9FskMukfZntzeNGoqHiFlkk7vLXi?=
 =?us-ascii?Q?SIAtDWoOm1YAZck1o2Kcq8uDgpoI1Xu+DIb0JanCehBv5Y7OcZ8xAx2+UvZD?=
 =?us-ascii?Q?CN6guln6Gm+nf8gTeVV07WnymmJEu3/k6JYp71tKgrQ/XgAhqqA4kA+0Yk0X?=
 =?us-ascii?Q?V2SMDgwJdT29uUoptgZq6dBAw9EpCHDTnSMFTrLls+McReeokRZgk6Lgb7z+?=
 =?us-ascii?Q?YsZ7S6Zk7GBAez6CS0g2P9EP8sVXFxrFvoKaA9RUjJKBX3fxt37pANdYfB10?=
 =?us-ascii?Q?lyIOmr/7K7U1uUjP1PnqgAGRlyJsJWnFwQUy3S072AZvXbDtY+ctlAnvI7/u?=
 =?us-ascii?Q?Xk81/fbqw0xZ0CXxk1Dao0Gcre/ke92eG0o5Xm1CRCSfJnIO3UFVezWhqJa1?=
 =?us-ascii?Q?hWKII5U0yoCY+RVWHt/y9Ij1aqsDgodhDfEkdTm4zeX+/TlWN7sCZmFkaWoN?=
 =?us-ascii?Q?caHU7A0jbtJkyujSRg9c/AzgB+tCvzscA12r2tOxWrYBV+reZRLNyYfWcyql?=
 =?us-ascii?Q?nGsMjynfE/NOlpyDHPkEzOPWUwzcgLuqqH+jzSRAj7076uWl03jNShIX/ieJ?=
 =?us-ascii?Q?pkT/iL4FgW7DfzPKvyvLYMNJXcbz1c0yPHDNQu19mE7PwkSu+G0p4Ie68Tbg?=
 =?us-ascii?Q?LxrhMNTzQt6CYE1XQhAbSP0b89T+B+ZeyVoV40PUbyFHulUIORrFrh/0xOfO?=
 =?us-ascii?Q?LdswcRB4u6pNjOiV8M2Bss3TRSs4SC7wU/POJNzJI7jbtcmpOcjYRd+TC+o0?=
 =?us-ascii?Q?urMZkolzOQ783S5WoaGIDGrT6d/6XI9kHtP+JD4O2Mio+QKz3Je5ANdHyyjl?=
 =?us-ascii?Q?f7PVL8MZRtSkViQAIYZBsFdtxtvFM/0ptQeijt3hhytyum3Bf/WsdKwWn09R?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c47aeaaa-055a-421e-c381-08db26c5173e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 08:53:34.5178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O9WqyYVZFt9dm9+dSMpzmG/sO6h29dVQl3dMjqrnWHHExQnCPRL4+43bkNwOeobXhpHWMyL+l7rnblc2r848vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7179
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023 at 04:22:56PM -0800, Sean Christopherson wrote:
...
> +int kvm_write_track_add_gfn(struct kvm *kvm, gfn_t gfn)
> +{
> +	struct kvm_memory_slot *slot;
> +	int idx;
> +
> +	idx = srcu_read_lock(&kvm->srcu);
> +
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (!slot) {
> +		srcu_read_unlock(&kvm->srcu, idx);
> +		return -EINVAL;
> +	}
> +
Also fail if slot->flags & KVM_MEMSLOT_INVALID is true?
There should exist a window for external users to see an invalid slot
when a slot is about to get deleted/moved.
(It happens before MOVE is rejected in kvm_arch_prepare_memory_region()).

> +	write_lock(&kvm->mmu_lock);
> +	__kvm_write_track_add_gfn(kvm, slot, gfn);
> +	write_unlock(&kvm->mmu_lock);
> +
> +	srcu_read_unlock(&kvm->srcu, idx);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_write_track_add_gfn);
> +
> +/*
> + * remove the guest page from the tracking pool which stops the interception
> + * of corresponding access on that page.
> + *
> + * @kvm: the guest instance we are interested in.
> + * @gfn: the guest page.
> + */
> +int kvm_write_track_remove_gfn(struct kvm *kvm, gfn_t gfn)
> +{
> +	struct kvm_memory_slot *slot;
> +	int idx;
> +
> +	idx = srcu_read_lock(&kvm->srcu);
> +
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (!slot) {
> +		srcu_read_unlock(&kvm->srcu, idx);
> +		return -EINVAL;
> +	}
> +
Ditto.

> +	write_lock(&kvm->mmu_lock);
> +	__kvm_write_track_remove_gfn(kvm, slot, gfn);
> +	write_unlock(&kvm->mmu_lock);
> +
> +	srcu_read_unlock(&kvm->srcu, idx);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_write_track_remove_gfn);

