Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934FB6BAABF
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 09:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjCOI22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 04:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjCOI2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 04:28:25 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51700298C5;
        Wed, 15 Mar 2023 01:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678868903; x=1710404903;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Ox8DybnKsZVTzWXA4kYizC84BpDWcXejyRQ81zRWrSY=;
  b=AHRKLGUHpHnk/6MNZOm3pEyCW9PRQfu3j74BDoEPc3fta2rAJxfoktbI
   KTGCGhRdscMnaj+gGjNR0H5vm51m8ndvCdljUuOQUyrx5jPFVRE1ci0Kx
   MMifS8x6GihQGwqse1V46hT7OHuYPcpkTZ8tuUS4EZD6YuQt5sHYIAINy
   R5yB3Xis8ezt9SSzk3wnynKLUZhtb+ZAQx2lLK8vePUh0O0fCaRMhWj19
   SztTz2J6M4NK1i26XbxIbIlI8/PkaQXsCp0ICvTNYYgYQO3WJXMJRpWka
   oF3+F/3X9OUC+aUup77OWj7hogMXUCgluuMK3J/JcWFI2Rs/CYE7bHd8B
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="336333315"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="336333315"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 01:28:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="768418920"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="768418920"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Mar 2023 01:28:23 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 01:28:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 01:28:22 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 01:28:22 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 01:28:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bojiLBLcqdarzUZtFTSVIIXF6M/8JKio5ik8JjA3u0DPk/ZffkPA4L0uYp05Z95hqtAhEa0YRfd+dpk/Y1TkisH1N6baiTSwvHgoQA7G/xSUBnKwQWqLbRUGf6yMBFsplh7rzm+HWgi5jxTRif/YN/qI2qwZrfJRbk8iShYofW/nZTUdoswfH+gOayNFzceNSeOx4i8CRhPIholFCdm9UgSyGG0U8RV+nA/6R+ekCaAdU6CzHbcKERGDCZGjOwC7sFCsSsydEi6m2P4QME6mIvTRsh9dsdyzp2Enm7jd35BO3inFdRMaZ9txpxnhCQkfzdt/NXcQ6WgwY1oG1foZAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XyurlVRfXAm/O+QxL90snVLRywnkWmpvrPRXkML2CFk=;
 b=FoSLjx3fUn2Aib/8Zlv4dCFNEBV1xcVcEyU+SwQASk0U9yihNmkogmgTcvBv86paNO8FoN7HffTkTwQnU5OMidXPm3rqOseAOsaWjPRqMH7g9kp1xGvf6oeLA5n1+rLVsRn0mDUTnyGPPt1gUD6KFtMuUxFd/sVsfwrGGgXt/ECZ4JlQU/YzjNnBaRg1bmotYZNdGTrO7ZmXokNbSDW/sj+5e7SGpKwcEa6/lMhnF5atjQmYqhqItrx7Y1flfR6xWw++N5xNEIY7r+flGJoA8Z6ZEHCZQxbDrGbB1FDU3muhBx73eRndRuU3jJbSgzTyDB+XEo4J8BEPXsE99SPJWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4852.namprd11.prod.outlook.com (2603:10b6:303:9f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Wed, 15 Mar 2023 08:28:13 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 08:28:13 +0000
Date:   Wed, 15 Mar 2023 16:03:39 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 14/27] KVM: x86: Reject memslot MOVE operations if
 KVMGT is attached
Message-ID: <ZBF72+flVlEbfg70@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-15-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-15-seanjc@google.com>
X-ClientProxiedBy: SI2PR01CA0051.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4852:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f4fb7b1-8c8f-4d6c-7418-08db252f37c2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7FtyLn7H/hrzeS0mbznADmiPf6dEIprJlpL5VFYXGMcLPd6LC0OPm/NNt49ddF8UtZdi7ABkK+0xzciV8e/UaViwgws+4vbyStXMnhX83uzz9bAapdyKgXgo+gFYM6ol4wXA8AOqDxTAvQtaGIsbl71iUo02v5CCHteL3rYygr/2Mu42tpT7damB8drnWSIb6XyyqXQojLWZmBMdFbDaFDLFE7xsDQOeTArxvqgBlM2r3bFYQKBlonizOBemJjO+tG+Jdm1fhSqvscaVveOEq96xj96OGtv1EVn8fOhxSTaxn10NGrlakIQt2S7W+YuH33fpMft/GYs9sj17jIC0kmHTbT7e1w8lbUOJfRhHG8GH6zqs32Dn9zmwiTngGXMQBVrvqFkZKV9Z2sa06bgnDIDwDrNUSA+bmQEu9PEOfffkVnuw0hzauEkQnUGG9N5f7dHEOzTveVwXh4yauBBbHrrVOQSidbgQTnSez2M7jfW1WFKXoLgCuub3je4FMOmeIT42/pbeAZT4ZuVwva+0Sjsd9SoZ618KpqgvglPvekUOqUy2XlXd+aMsAueMyt8xrYB0GYBVSw/SH2ZrlsQ/nBYi+tJgVVWRmn5A6RV7N7NCRqzEp7VC+26iv+6VfaKFP9vtZ8FBk7czv6Nnlu16ACVtPsKwE/VDad8KJyYTuVkDv2g1wGti3KBcqSmUc6Y0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(396003)(39860400002)(366004)(136003)(451199018)(478600001)(41300700001)(6916009)(66476007)(66556008)(66946007)(54906003)(316002)(4326008)(8936002)(6666004)(6506007)(26005)(6512007)(86362001)(186003)(2906002)(3450700001)(82960400001)(8676002)(5660300002)(6486002)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?waennHgHj1liGa31B6jCa8bT8PL5HBkNpe5kwewywxS5+TuRoR37VVpoGVAk?=
 =?us-ascii?Q?PcWVG/ELnSla+sqofwXy9wxTBDseGbkZwrhby9VuNYtGAwX4Qe8Jux/2KLZJ?=
 =?us-ascii?Q?9yW4WnLQFdG01WrYYrvyc6amW0MBKAOkT7o6Ho7YFgXHrTBKL/Fn2ISmCuhA?=
 =?us-ascii?Q?alv2I0AEXrd7PSKyIHRRvZJ3IGcfSexFwGdYbfMS0R2sFE8gZXJxecL98NaL?=
 =?us-ascii?Q?2QwpF4dBJP7dxCjlQdsQrtnooTYKzZkq139+x0HLuL7zNtRdoLC05d6v5KZE?=
 =?us-ascii?Q?AHCV6ZHMmHwQA37qkYr2ovMOZVzbGCVnOzJTrYUmbPCUM2Ir2twKZ9FIv9g/?=
 =?us-ascii?Q?d+Mjl4byBzYyB0QeFJEQ+SFC6IeZDYJiWkkSGIeuiK1z4BG3L5Lz7Gl3ag91?=
 =?us-ascii?Q?qwKW9r896zQXPcdgZSQpvHwTFU8IEvsqb+kHgcGjDuI2wJEHqEPshfLZJ5hL?=
 =?us-ascii?Q?MpsbRdo9+skiBsZN7OwprwtRKePFzGRiE6YVJPM9jQbOwhhBqnMTaGVdFEgD?=
 =?us-ascii?Q?7oRQDqxqR9gNNwsyEc4AUW+5fSas8YLc3IJeeg8LuXYozcZkVm8FZLn+VidG?=
 =?us-ascii?Q?GzjRUOUrspaBGR5DRZziM3jdj4FSBGOdYRZoerVyKlGP+GrG2/FcfGwmgHeV?=
 =?us-ascii?Q?oZ/PVb60pcDTVL+gnIltMTScm9PTeNESVxzaHdSk9/vOEYhEil9nnNwFfA8l?=
 =?us-ascii?Q?ZEWdXRUc3LKn9PZLt/t/zgLkt8zqNUbeBmoTU/iQQ8Dxg13TU47EgvQdKVCq?=
 =?us-ascii?Q?Htd5bb3OEmJ0SfDlzIyxDOypIxwTu686RhXwhQOpCcPCbc/bJRcjiSZU9Dmv?=
 =?us-ascii?Q?3xc7IP9AABmfTTC825Me1ID4trD1pyDOHzW0eMkiXOXRHYuZqg11ST911ssw?=
 =?us-ascii?Q?9LiwfswH4PB32BU3zRrnRvbJBxTC5ElidRw3hYxSNdrYIatTg9z2bhm+90MJ?=
 =?us-ascii?Q?Uk3Hwcfeu74Er4ovaKT1e+O+unUi1ZTjM0NVnyBeSD5+pWG7fR+MMr0k1qH+?=
 =?us-ascii?Q?aNRn3BhQdi1H0QGMBUJQsy174JoziN3xFg43A2aM4/UlFzA59EuICiMCk5St?=
 =?us-ascii?Q?A6VpcAo0gitdekLA0LuSGX7YnEHyY7sXiHW0ZNy7B9ZQoTcmyv7TlQj8V+jf?=
 =?us-ascii?Q?Iu+2YSPBdlli5EgU3XGMlrhY7BfQVFYCir1qNlfRvKRE9rG9rXzILNjon/x3?=
 =?us-ascii?Q?DvhIfkVvgjPjmw3m/jwpuWzLEupGDWTkelmVVIUgsfUxEAnGqqXu6QFz40Mi?=
 =?us-ascii?Q?aVgVl/qdZa1v+EtcgZ7wJlj9X6G1Gc7+b6FVCa6Ht8fLxjKgRObM3AHRn2PI?=
 =?us-ascii?Q?XBYgW2hF9n1PxOQKS5fjS/w4fWF9NUaExVlNol+qbtF48wY2e2JvBaQfvKWR?=
 =?us-ascii?Q?2eHQcQm1qnSg2I7B353aVZYiP/oA8XYpc29rNgu3J/+hrD/KhBHSOHiewRRM?=
 =?us-ascii?Q?UewD5x9k1i17F6rsHsa+rW01lvix9Gq82rfWyDKfFlqPleV1YCP39XdXjgR2?=
 =?us-ascii?Q?L8gXdpgQhIYpUgrQm6kGkkpovH4UDWIvwQIdr3x6Ki1Vw6nJwoGugqd7GdrY?=
 =?us-ascii?Q?c1AhSCucp9IsIVhIzmqPEiiCdBf6B+bG+OUvGto3ivtQDaA55raH/w9d6RyU?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4fb7b1-8c8f-4d6c-7418-08db252f37c2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 08:28:13.4269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sBfSgxoSQfN1Bi77i67BH0/k4b2Xxm+KCgh+cRZvDxVE5AbTap0xi86W/NnlmkllLlqQNIkJrzJ7O8Mh5G3WLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4852
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

On Fri, Mar 10, 2023 at 04:22:45PM -0800, Sean Christopherson wrote:
> Disallow moving memslots if the VM has external page-track users, i.e. if
> KVMGT is being used to expose a virtual GPU to the guest, as KVM doesn't
> correctly handle moving memory regions.
> 
> Note, this is potential ABI breakage!  E.g. userspace could move regions
> that aren't shadowed by KVMGT without harming the guest.  However, the
> only known user of KVMGT is QEMU, and QEMU doesn't move generic memory
> regions.  KVM's own support for moving memory regions was also broken for
> multiple years (albeit for an edge case, but arguably moving RAM is
> itself an edge case), e.g. see commit edd4fa37baa6 ("KVM: x86: Allocate
> new rmap and large page tracking when moving memslot").
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
...
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 29dd6c97d145..47ac9291cd43 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12484,6 +12484,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  				   struct kvm_memory_slot *new,
>  				   enum kvm_mr_change change)
>  {
> +	/*
> +	 * KVM doesn't support moving memslots when there are external page
> +	 * trackers attached to the VM, i.e. if KVMGT is in use.
> +	 */
> +	if (change == KVM_MR_MOVE && kvm_page_track_has_external_user(kvm))
> +		return -EINVAL;
Hmm, will page track work correctly on moving memslots when there's no
external users?

in case of KVM_MR_MOVE,
kvm_prepare_memory_region(kvm, old, new, change)
  |->kvm_arch_prepare_memory_region(kvm, old, new, change)
       |->kvm_alloc_memslot_metadata(kvm, new)
            |->memset(&slot->arch, 0, sizeof(slot->arch));
            |->kvm_page_track_create_memslot(kvm, slot, npages)
The new->arch.arch.gfn_write_track will be fresh empty.


kvm_arch_commit_memory_region(kvm, old, new, change);
  |->kvm_arch_free_memslot(kvm, old);
       |->kvm_page_track_free_memslot(slot);
The old->arch.gfn_write_track is freed afterwards.

So, in theory, the new GFNs are not write tracked though the old ones are.

Is that acceptable for the internal page-track user?

>  	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
>  		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn())
>  			return -EINVAL;
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
