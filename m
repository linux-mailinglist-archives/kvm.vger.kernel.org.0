Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE3F732964
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 10:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244285AbjFPIDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 04:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244149AbjFPIDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 04:03:05 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EB92726;
        Fri, 16 Jun 2023 01:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686902584; x=1718438584;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=5x7yYFQKs3wnhavpnrFlCngeVgZCB6RXmcSNbgiXP84=;
  b=C6QaYrD2Aol/gFKN9eXibAcv18Gdxr4a++xqtbFZxAgL1G1coROfB6Fq
   gJakD3taNOrNKDnQBcLX2Nx+X/iE+gl2RiNgmhnVbkqNK+j3S1gt0ztJa
   Jg9cdMA11AXcbeti5M8IeuWka/Sc35fS3HsC+jDLtU4pCp5FNT1UKJ0JI
   3suEVd5TKC8g7fNkP1TPLmpc2aBfYE35jsyW8/ZxvmM1oIKaz7ClzNUe4
   JM1SftvLhrLJc+MOvxY8Z+cZDQ+jOFev36zPGT1p8kFkrRY9BboAjKzdL
   kXrHLn3NIWh+iceleaS5TBTMf+ZiBDrOcEMRPi2JoG1r0qrb2spUOHWm8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="343896503"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="343896503"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 01:02:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="959536589"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="959536589"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jun 2023 01:02:55 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 01:02:55 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 01:02:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 01:02:54 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 01:02:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbEHODdKPzWrkiH3ZS2bY9dJsOwpCVD83+chjk2eJkFDuGD6Z9fVrNoBgtc9+kGch4Hu5YH4LIY/S15TxbaPGtptubdOYYLHUjZdS44AL8CjEaknITB1Ode9D+tUR0QvQeCvy3F2ylQWNw0oq38Sg2tuHrE65XBh/1W2TAIrKGrd8lTYuRwLjOGa1AFVpZET7/Gbvmm8xn9Lyc80vj7Sm2Yc/Q3zg6PGXrydocpvBYVr0HZVa4WlcwWdjHMrO+CEhRBLNdxFBmYEUhkz7pOV12djN6NGZ73PaiaUqMSzYNakw222fo304lTPFwdlw3nwPzo8GvpKJex3c4ahtTfnLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uSQt9h+Q4f6kmyKh4eqAm8SATKNv/W6EPEzGZiwxahU=;
 b=RXo2hWwjkXLPC9LRsqutCGQATwq9k3DMaUsWVoqugePAZRuXhY1NLWKK/6OStXJGgzVaOiYrVCDqsUjMMnaSOJGxig/9R62EJQywvPVb/0KGCC8d8Eo7dYP8sRpG4ouMxkuUNlXdq9SRcsbCE+zPeS8ZgqwNVeHPn8tg7vhdNiG4nZ0rh1dHC1lds7iSxfde3M2+dKb39AToXJHZHCmrUL+2HYiQWvgr6u7AupHL4k1cdBPRMjDWt/6psdTCEIz5ks10cEbQ010biRxWsPuBRevBKgLaskhdxSPS8sTIbjEWLz1k2uwCshQcqFAEvfzhywo7z/o7PSYZW934vYoBSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4881.namprd11.prod.outlook.com (2603:10b6:303:91::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.37; Fri, 16 Jun 2023 08:02:46 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6%7]) with mapi id 15.20.6500.026; Fri, 16 Jun 2023
 08:02:46 +0000
Date:   Fri, 16 Jun 2023 15:37:29 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <chao.gao@intel.com>,
        <kai.huang@intel.com>, <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 09/11] KVM: x86/mmu: serialize vCPUs to zap gfn when
 guest MTRRs are honored
Message-ID: <ZIwROWti5d0sCFwT@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023945.7570-1-yan.y.zhao@intel.com>
 <20230616074550.g2ikzbni2rjy7dfw@yy-desk-7060>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230616074550.g2ikzbni2rjy7dfw@yy-desk-7060>
X-ClientProxiedBy: SI2PR01CA0040.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4881:EE_
X-MS-Office365-Filtering-Correlation-Id: bee7f926-bc03-4e34-ad0b-08db6e4011ae
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vCfbBL462TvdGkvQ0xLcWZrBTrCdJWHS1aPriNdo9vCsLrcB3uz2p6/IT5IOczXCnCxCJo62/bUl2SA9jnM3ZNp3O++lUXtn6tLgfNKl9hgBHdRJQVbFrylTWPrwfB/+//UtnwaMxHDFrW7DP61ehynxm2bSlHB8WSv1e37qPH4MRHzelgRx0fRy5ba9ttmMltlbxvboG8FVa1opJzg7+odfbwudcDBz1IF5iUSf0VyQqafvmwk/8lvMOCZ5bKATZmlg4SVgrMcgnt0zbpazdfgpPHEe4DhiMiBBVgh0G3zn/7UMGiMtd4YjN3ndM0IrJkKQMbCLaqycgGryuRbZLn3WMGUL+0OmxLpAZMLoFGk37X6lygMFUs/8L/138TZeQzbAjL4/Nh9VGxK80cIvWKc+L235zQ+wJ3daz1975d1P+IhObRKe8PTnezn+H9rZv68QONYSyn7dE0XMsQ72x75Q/cWvKxsmyGKVDwhQ/bhaDE9tPcQj8qALghqiKGQpvQRm6crsPUZIIoMbjQ2k7hXSAk0VfoEe5Rh5D8iogyZmZYzlTOihOjRV+/APhJR3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199021)(186003)(2906002)(3450700001)(38100700002)(86362001)(6512007)(26005)(83380400001)(6506007)(82960400001)(4326008)(316002)(6486002)(66476007)(66556008)(6666004)(6916009)(66946007)(478600001)(41300700001)(54906003)(8676002)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5E6G7mJozrkNT1fJfohaexcUWCmKCI5NUrDBcU4y2Vd7EtI60jPR0D86k5bH?=
 =?us-ascii?Q?T7b+E5tMu9lsA8UUEt7dG1EoKxnNhVzc0z0dwCOdpl2kkQyxIfRSyli0u6kl?=
 =?us-ascii?Q?r+cZffndBAk6yHRBhc2TgzHyZ9Hw7mu2JhOGDm+k1mWmxQro6j44JvgmaH/N?=
 =?us-ascii?Q?s/f0aoMKyNFtuLMJRvHe6yMZjqq+2qFTJBk7/T3QpY/W2NXPVxIWug6GQ17l?=
 =?us-ascii?Q?DM9RuizBmU1pgY7Z/Yr373y3biUnqfoBWEPeDNkIb7bKYgpV/6B0/yqoF1EW?=
 =?us-ascii?Q?bYjIQ5dr/GzKqS/oZLQbk324qlsRUPBIl3Qkb6Aj6FcQ5H3bPpuqapsYYPks?=
 =?us-ascii?Q?fAILY5JdUWNRYY/aQADVlRctAWdxtLNGfX76uEpcxtBdqUCmNuftwLF1hvfj?=
 =?us-ascii?Q?y/zlwhJtLa3iq6pnzbp8K0TA3nBSpzA8jdFmBYcuPSj7Nyxmk9wij8OqGHYk?=
 =?us-ascii?Q?zqF1ownvtBRmr31a0YCBdRNHszHs+2eBY3288P65Ctt9pS+lLh/Au9+IyVym?=
 =?us-ascii?Q?YnLLpvvkrI3OFTt82UTE2FwXjB28nkX1CYnnI+nLjqWzzjFbHFDwhUCcgIUy?=
 =?us-ascii?Q?R0+HcxyoBGmmq7zHM6vDXrVVOLjSg8xs2ShE0nVxqij/D82CF9DHiAMvGJU9?=
 =?us-ascii?Q?4OyBJ4U8u7X1nnN1xF9fMXEfLIdJTffQrTAxcO4RnzWsxQj3T5pt4RCFKxRT?=
 =?us-ascii?Q?N9Qr7u5VG+mKsObgqt6fWyBzZo1vOwi32KpTqIt6GmKdJqSRUKQzpojjI7Ad?=
 =?us-ascii?Q?bzjo67bqOqR1gJvm4aSoNJY1m2raxDKqjbAgguGpxhGWmgc4q5u3iTxZZgzq?=
 =?us-ascii?Q?maZZXlmzzTciXKnPW37D8OLh1RFzCigtIiuApAwiNmvgUW0rWhXnnRb91uwb?=
 =?us-ascii?Q?czN7qi/cIpXTD9KlS+RwW3mwwpAJVDSN9LgElsyAYhPaTXWvUyxB4JSPT3SM?=
 =?us-ascii?Q?f6BuM/1e/VJffLNbkeheXRejlD4q0Pj6/RcI+mJ8dOufRRgM/LucnIH5nFCa?=
 =?us-ascii?Q?rkwP20+yHC8dWF0jdiIKKfwAutw4OY/daJNfXXUTHKHOk35+XsEm4ADYQkcr?=
 =?us-ascii?Q?ZFBKeISH1B03rtzz0m0cDvCeYSlRMuLGiEjNnO2zQiYExsDAVK6rXTO1vOWB?=
 =?us-ascii?Q?+53IpnkBdjrhPadOHtSKYyiPWzn9Fwr00HQc6/0/45d0FGtIPYiVmwv+bqz2?=
 =?us-ascii?Q?5s8JlfVqk1xelTov5XZdxYPMeajsVuJqrq6bLWomKC+VqDtEI0osmuy49qQX?=
 =?us-ascii?Q?khLji5TdTLNzYEkA7IP1wbrFLC8EPp5mJS60DRRn6DkBYYeULLYKGcuw+qCT?=
 =?us-ascii?Q?cNHHhmeDrB5bvTFQjqcgJ3rMBrI6v8Qwj/fFCC2Csu0e9bT4eSnIKDDI9eeA?=
 =?us-ascii?Q?2ja0tv11gxOao5ZEBLB5JPJBcChoFdPJ45I6CO0HBMlIXPOxCMUZs6YK5nuQ?=
 =?us-ascii?Q?ZGAUH9wTodmPI/xIcnp6OM4APwgojyQw7u/aqliBm2zaZLWKcf1NsyH/8rJR?=
 =?us-ascii?Q?Q6w2dAVg+JZOhcnlh05Gi6/R35bH4dMGHPc37Tg5NuxczUPeI6G9NIWE9nyW?=
 =?us-ascii?Q?whK//YQsLe31O8Z+l04VC4Q9CRV0Jh0p3LfZEW2w?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bee7f926-bc03-4e34-ad0b-08db6e4011ae
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 08:02:46.5979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hNf6Gjtn4GNmeoK+Wh3tV95nXm3yH1NvCWGQR6rad3dHALONMtX9Czd9oreEEp6m8mil9UhYaESYBBQEBhKQSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4881
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023 at 03:45:50PM +0800, Yuan Yao wrote:
> > +/*
> > + * Add @range into kvm->arch.mtrr_zap_list and sort the list in
> > + * "length" ascending + "start" descending order, so that
> > + * ranges consuming more zap cycles can be dequeued later and their
> > + * chances of being found duplicated are increased.
> > + */
> > +static void kvm_add_mtrr_zap_list(struct kvm *kvm, struct mtrr_zap_range *range)
> > +{
> > +	struct list_head *head = &kvm->arch.mtrr_zap_list;
> > +	u64 len = range->end - range->start;
> > +	struct mtrr_zap_range *cur, *n;
> > +	bool added = false;
> > +
> > +	spin_lock(&kvm->arch.mtrr_zap_list_lock);
> > +
> > +	if (list_empty(head)) {
> > +		list_add(&range->node, head);
> > +		spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> > +		return;
> > +	}
> > +
> > +	list_for_each_entry_safe(cur, n, head, node) {
> > +		u64 cur_len = cur->end - cur->start;
> > +
> > +		if (len < cur_len)
> > +			break;
> > +
> > +		if (len > cur_len)
> > +			continue;
> > +
> > +		if (range->start > cur->start)
> > +			break;
> > +
> > +		if (range->start < cur->start)
> > +			continue;
> > +
> > +		/* equal len & start, no need to add */
> > +		added = true;
> 
> Possible/worth to ignore the range already covered
> by queued range ?

I may not get you correctly, but
the "added" here means an queued range with exactly same start + len
found, so free and drop adding the new range here.

> 
> > +		kfree(range);
> > +		break;
> > +	}
> > +
> > +	if (!added)
> > +		list_add_tail(&range->node, &cur->node);
> > +
> > +	spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> > +}
> > +
> > +static void kvm_zap_mtrr_zap_list(struct kvm *kvm)
> > +{
> > +	struct list_head *head = &kvm->arch.mtrr_zap_list;
> > +	struct mtrr_zap_range *cur = NULL;
> > +
> > +	spin_lock(&kvm->arch.mtrr_zap_list_lock);
> > +
> > +	while (!list_empty(head)) {
> > +		u64 start, end;
> > +
> > +		cur = list_first_entry(head, typeof(*cur), node);
> > +		start = cur->start;
> > +		end = cur->end;
> > +		list_del(&cur->node);
> > +		kfree(cur);
> > +		spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> > +
> > +		kvm_zap_gfn_range(kvm, start, end);
> > +
> > +		spin_lock(&kvm->arch.mtrr_zap_list_lock);
> > +	}
> > +
> > +	spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> > +}
> > +
> > +static void kvm_zap_or_wait_mtrr_zap_list(struct kvm *kvm)
> > +{
> > +	if (atomic_cmpxchg_acquire(&kvm->arch.mtrr_zapping, 0, 1) == 0) {
> > +		kvm_zap_mtrr_zap_list(kvm);
> > +		atomic_set_release(&kvm->arch.mtrr_zapping, 0);
> > +		return;
> > +	}
> > +
> > +	while (atomic_read(&kvm->arch.mtrr_zapping))
> > +		cpu_relax();
> > +}
> > +
> > +static void kvm_mtrr_zap_gfn_range(struct kvm_vcpu *vcpu,
> > +				   gfn_t gfn_start, gfn_t gfn_end)
> > +{
> > +	struct mtrr_zap_range *range;
> > +
> > +	range = kmalloc(sizeof(*range), GFP_KERNEL_ACCOUNT);
> > +	if (!range)
> > +		goto fail;
> > +
> > +	range->start = gfn_start;
> > +	range->end = gfn_end;
> > +
> > +	kvm_add_mtrr_zap_list(vcpu->kvm, range);
> > +
> > +	kvm_zap_or_wait_mtrr_zap_list(vcpu->kvm);
> > +	return;
> > +
> > +fail:
> > +	kvm_clear_mtrr_zap_list(vcpu->kvm);
> A very small chance race condition that incorrectly
> clear the queued ranges which have not been zapped by another thread ?
> Like below:
> 
> Thread A                         |  Thread B
> kvm_add_mtrr_zap_list()          |
>                                  |  kvm_clear_mtrr_zap_list()
> kvm_zap_or_wait_mtrr_zap_list()  |
> 
> Call kvm_clear_mtrr_zap_list() here looks unnecessary, other
> threads(B here) who put thing in the queue will take care them well.

> > +   kvm_zap_gfn_range(vcpu->kvm, gfn_start, gfn_end); 

Yes, if gfn_start and gfn_end here are not 0 and ~0ULL, the
kvm_clear_mtrr_zap_list() is not necessary.
Though in reality, they are always 0-~0ULL, I agree dropping the
kvm_clear_mtrr_zap_list() here is better.

Thanks!
