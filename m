Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA6B6D010F
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 12:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjC3KVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 06:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbjC3KVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 06:21:32 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A13E8A7C;
        Thu, 30 Mar 2023 03:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680171683; x=1711707683;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=d/SpdGN7bXeGwGDuTppj5+zxkU2rttJDXly9fPsvy00=;
  b=dtQycHeF3VyUSJVsq9mHLedInwXSAiQNNLYpH6qqijNxS3n79GZsN3Bx
   BhMYkFmviWAIz7Hrgoj/2Zi3sWB7iCSoAbqf6byuFGjBHeXHkfTWyqecO
   tXKiN8QpcDc9agXq1vU/5Z9+AbeKiFcsELWiuDc50OIdopVFSMpCW8E+u
   lWbJpKou/NEhKgZLOCszf5/nIj/NtHAok+R/+f1Xnniiq5vbJVvxP+A7G
   34vwqB8aMI/XRNp8bUG6GDtmmYEYtOS6ovQj5HGBKr83hgDzB4SKWNYLU
   mxvcKKKA9c513Bwz4J6CbXDHz8VjvsaixZx7kBV5DpBrQD31gMyruFYiM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="325051774"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="325051774"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 03:21:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="678142913"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="678142913"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 30 Mar 2023 03:21:22 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 03:21:22 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 03:21:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 03:21:22 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 03:21:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4Q8lq0igqdWUhXejnsFQdQglLvPQ1L0Srt4EIcIdBSQW5aiwcnqMSQDufKM+vpAApCx//AU6GG2Qr1Q/+YXiLISri0f7a8JgbpUEcOYf24cxBrRPhfDvQFN0okbUJ3HuW5whrwHOarziYuAzAEzG5K4nlY7w9viDCGTOeZ5OLsHi7F/wTTV4rBQLyjZSJlU3adgw1F0o2VyZbuTuHSKkx1+s+pIyR6ZrCvGz8RZm1WGTKWfeAWeuUknvmOp6Mousb3NbaXTdjtiJZhsRNOeSjyg8EkeHmSlEyAiKy/HIlYxSTb7V6d1Uc1snfe0GdZqeU94tRwEFkzle03ySGgZRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m/6ouXaQCTHxyFNhXFoT6Og2CB4u//jDwh7tP03YveY=;
 b=RpcwuGO8cHeyyJJT8SU1lfPcU6TBN2hA0+XHwKypJwmuDQriSvq8UEnwCsTQmu9HHxUf7hOQolUYgi0U3y/d+2vCFYSOyl14SwUw6we+68Y8F/tXtRI2kzEuUNncaomHnelws+7X1WV6FE5Y561vOK877+zceq/ySkfgWwnSSdlSqRzC0h3Vfwl+M9X/o35xQ4VcfJ/Qgzc6PMCUR4lxdYhY612xJdbx814YnPXUfsfoeN7410ShvnMx5v8duYP6O17qy7Yy6vCE3Z/Qg8KHhJHTiZe8slhX5dARpTbUILfXBxb+RnmEM6GrXxujDclO062uDY/ZSE02EUrZ+l7H+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB6575.namprd11.prod.outlook.com (2603:10b6:a03:477::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.35; Thu, 30 Mar 2023 10:21:18 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%5]) with mapi id 15.20.6222.030; Thu, 30 Mar 2023
 10:21:18 +0000
Date:   Thu, 30 Mar 2023 17:56:14 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] KVM: VMX: fix lockdep warning on posted intr wakeup
Message-ID: <ZCVcvuddkEFKW/0p@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230313111022.13793-1-yan.y.zhao@intel.com>
 <ZB4uoe9WBzhG9ddU@google.com>
 <ZCOaHWE6aS0vjvya@yzhao56-desk.sh.intel.com>
 <75ae80f7-b86e-3380-b3da-0e2201df4b7f@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <75ae80f7-b86e-3380-b3da-0e2201df4b7f@redhat.com>
X-ClientProxiedBy: SG2PR02CA0100.apcprd02.prod.outlook.com
 (2603:1096:4:92::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB6575:EE_
X-MS-Office365-Filtering-Correlation-Id: e8840b62-e6cd-4b12-c521-08db3108803e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R2NUt4pOMWtvSR7YB0vFPxd/HQx/9iWv8QFVNGdbKvQpg61F65H1nB4jaaKhZHYI2prvcQAgXmLsfGMWPJfk9Zs6RvvZP7ICB0GMt1AALtKl3+78k4Z6cQPuPUmSNft3VHXKJvNBub7k/xfw+UBX8fosE2mdMDBfyNsrwbH+ztPzZMNnT+dVV7BEFVYbyxlOjrdp2MwmTt0ytiWTLaBEvFOrhsAdNYrryal8NjjnXP/+zhIvCHBLtZ5dL/2Q5/10ntyY5Ovnj+muKNnFIOHesAZpog/ze5o+VQsC+wkIG0SNobbQU//Y0xL89bK7qc4vD79ZeWv6+po1rXjGSMML20GvdrFCb7+rksshXZIUQx62EEuuXR/OOPmWiuydpwvEdu7UWrO3Kxt6XnzT3qPjeRiC0l7AkT+x4rEZDnQkyX7/7Sd31xbJ2kNRXJypXULQ//7ro5uGRScApknW5Uq8WE7Q4agFcmLfgQ9BmOR+fwxi6w+Klg7Yxu+O/bfdJ3hSmPoNQHAxiy9p/4t5Be8i0/YKs3DUlwXRlFrwdGJ5zbVri6fNXba2ncgMC/4Sdx2i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199021)(2906002)(3450700001)(83380400001)(5660300002)(6916009)(6666004)(41300700001)(8936002)(478600001)(316002)(66556008)(8676002)(4326008)(66476007)(6486002)(186003)(66946007)(82960400001)(86362001)(26005)(6506007)(53546011)(6512007)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vqHCm/gQTZE5ysWaksF+L4cQGvzB3QXTI33xyoHmV6OUbmhBydBU+MiaRsnd?=
 =?us-ascii?Q?8yfg/j1fcs+xxbpLz2waZ35JAJ9fB3oJ6uFPoljp9XIW9MJUJKOIPmWMwFiu?=
 =?us-ascii?Q?jkGKEjsRSzJOk+K2wLodRWV37XKNX9aMwlp4HjfM8K+7iHqhz7jjv3mLe1Lr?=
 =?us-ascii?Q?W/TurFfDZaUmyPUpKcIUOO0663lGnT4WrYZoNye5r4L+qHVi65j2RjsGM6gG?=
 =?us-ascii?Q?uE/IrJ/O3iTLxNJJO5eegQA6mE6R3lAzhfK+ODtNNKC2z/BirOjDWWmmDBIN?=
 =?us-ascii?Q?SB1n7I0t0WVrLdIukst4KIXQeB4BidMx2nZSj2hd8iNE3B4pb/bXBZCFnvRu?=
 =?us-ascii?Q?arn7zYBVWp+wZNkySSohHq3m7WJ2EZvJGg/nr98JO7R44unac49Sq+nWwQok?=
 =?us-ascii?Q?p/CyKboiSxCZ9ISMchH9HB6P5X8iA425yi1hIA2LxPm1tGM+tzHFHzfD/mCa?=
 =?us-ascii?Q?zQ1fO02MYQvhdMJlPaM+9U0NeZSUYs7oryuQw0t7Wu774qegP03G5PXO2Er7?=
 =?us-ascii?Q?Lg0ppYKL47G7bHyla+o1S4Mw2znVLzASy7zlRLx/c3CC4PZBnLQfPuP38rhq?=
 =?us-ascii?Q?w795akpXkAGCEtwy6hT2668kh6rODBLGY6qjoOGGbdWiBs588f2H4EK9Z8FR?=
 =?us-ascii?Q?XsKmfECcw3VcpIsb56C+NkTjxGT1HG8tcTw+l/qZmIZkOljgxTkOxYu80Peg?=
 =?us-ascii?Q?EtSjZAEAJVzunYjfwghxRTL50M4g1glRU2N+NczJi3fid8E0sCfzb2AZ0+yA?=
 =?us-ascii?Q?mTQlDfzWuHPc9dIS8d0RJs/ubIKOXVtoXipCU1v9JhBBlsqVf/VBPt04KV3j?=
 =?us-ascii?Q?mGF7rxLEZ3p5CLaa6Xs7RquY4P+EB59eHit091F+PdXWBuFBdooQOv2mZKeq?=
 =?us-ascii?Q?L4NeuHDhQA503ZJuNHAgCYz/AZgRVuC7Pap/xEgGIL6AwB/FDSYkg+hy/IaD?=
 =?us-ascii?Q?2/yRD4D7IJedYdq1ubHgHYv+yGtGlkzFEc7CkO6Lq2HjzElNqb+b/X+ZRVyH?=
 =?us-ascii?Q?miW3WqZCKKP/CdlEY0kmxD31PSoJVCRXlPgnl0IsZt+Cv1zx562JVyrJCF4f?=
 =?us-ascii?Q?pAKiUxlnBxMb+ApFWbxibouQNY4GZvoHP+PcPZOAZIXUxfy1NODI8tj9oGCK?=
 =?us-ascii?Q?b0SI+38BxBW/xbA5tdjStvA+wn8MB/XBxNwNpAaJrYa7I8Qr4MjnWQpX6pFM?=
 =?us-ascii?Q?RmXenbPn9wuyffI/pAuyZ/peSawEMOzYE2AesPA9oHMMLvl/CrD0pkqAJyuG?=
 =?us-ascii?Q?wfJmUiQOy2eLcZCtMFzNH22XcZykz6yM+BTf7mxiUteNjnthxWpvaxgjsZi4?=
 =?us-ascii?Q?Cn+gQl66PRb403uOdCYHMEz+daEsofz05zmxLaB13PNclPIvmcEUY8OO/VWq?=
 =?us-ascii?Q?srKXbnyYRStIkIx3IjDE0WdgA4fA5+D9sbe+CHqOjJ7h2zezg/1Zg4rn5AhB?=
 =?us-ascii?Q?Zigqb8aFWkMGklbjw94//WtQj5oVR12gX9gF2o/871Yb6hGLzEptpOHxfyYS?=
 =?us-ascii?Q?v2CQCF71DEbjla3+cGNbXXh46r3DxYAq/7fg7tRr2wxJ62StQPwhGZD6LhS9?=
 =?us-ascii?Q?7n6eMhhtyQ8Tw9GmqIZOQ7YIntqtvtB1+/U4YFOR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e8840b62-e6cd-4b12-c521-08db3108803e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 10:21:18.6023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ht382xOQzmZ1OVBM6RXLeFN3BXP+1LWfsIDHvMhfwUOD41vc7JcqEIChWy1FEy3pFsKgrkyCS66hNDnhDhyc2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6575
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023 at 01:51:23PM +0200, Paolo Bonzini wrote:
> On 3/29/23 03:53, Yan Zhao wrote:
> > Yes, there's no actual deadlock currently.
> > 
> > But without fixing this issue, debug_locks will be set to false along
> > with below messages printed. Then lockdep will be turned off and any
> > other lock detections like lockdep_assert_held()... will not print
> > warning even when it's obviously violated.
> 
> Can you use lockdep subclasses, giving 0 to the sched_in path and 1 to the
> sched_out path?

Yes, thanks for the suggestion!
This can avoid this warning of "possible circular locking dependency".

I tried it like this:
- in sched_out path:
  raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu), 1);

- in irq and sched_in paths:
  raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));

But I have a concern:
If sched_in path removes vcpu A from wakeup list of its previous pcpu A,
and at the mean time, sched_out path adds vcpu B to the wakeup list of
pcpu A, the sched_in and sched_out paths should race for the same
subclass of lock.
But if sched_in path only holds subclass 0, and sched_out path holds
subclass 1, then lockdep would not warn of "possible circular locking
dependency" if someone made a change as below in sched_in path.

if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
            raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
            list_del(&vmx->pi_wakeup_list);
+            raw_spin_lock(&current->pi_lock);
+            raw_spin_unlock(&current->pi_lock);
            raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
}

While with v3 of this patch (sched_in path holds both out_lock and in_lock),
lockdep is still able to warn about this issue.


Thanks
Yan
