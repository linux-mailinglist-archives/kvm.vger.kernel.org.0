Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD28776E88
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 05:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbjHJD33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 23:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjHJD32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 23:29:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDEA1FF7;
        Wed,  9 Aug 2023 20:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691638167; x=1723174167;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=KOkgg0mDDrq2rSPFb1XTrfhf9U0JPSo1ZFVj7oB3Hdo=;
  b=h768+NXpkDop6eFPPB1+c1QuZ0k77yOdnBpnl2F4HQDbidf+hY6Fuy+L
   RPnwLbiUmCaJHUYivLxM3v02ij9pVUO5E2p6guwzZlNyREiuvJ5uJYI9A
   g8Q3yRM7tW0ga8FchPWys/3GMSHOi8H1N/MFW4a1pkhGl7O5F688om+jW
   lWDl5f0eLJ4w6IMuU9HyRPEx91bYzbwRHp1ATIT/3qNYpdowsDQ/gbdpc
   x5oaD9RMp9iKl/bC4NKay/BeXSyswUAv1xUItaPwfUzzx0ntBpY7YfBf7
   wrm4qs60SJcT4ktWHNXvOGWobgKjQWW/0Hvi6G6+RTlgiRzzh4q51sqhf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="402245469"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="402245469"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 20:29:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="797447544"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="797447544"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 09 Aug 2023 20:29:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 20:29:26 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 20:29:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 9 Aug 2023 20:29:26 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 9 Aug 2023 20:29:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyLP9Rwug/HHc5ZlZphEWxMbksG1Y+ZfmPOJvHoB7LFaYqkGTKzsy6NCL6inrAD4b8l2u/NbylRiD/ROe1CiK8kAOBitbARdLoo292Qx49AyLW0cXD/ZkvBDgmMJkXW7+n7PDMEkH57vfPr359n5GoZikSZ2liJu4FlrOZR0sKXDmZVQxnZpQordzKfS2K44/lb0ySnKWvn8xa05SN5TFIAANx5IjFyemJ9Ez87uFPc6CHeEIsyAfhNHsA5BVcsjEMoJsn9vTfy+oR5fANWzCdKOHj23MOWAR5XTNVWaeV1UGzC8dPvxTL2+qf1zMDqGLwvuYAuVaDN3UlxRBvsghA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oLEul8MzzQ58bYiDd7L5EOQ3WANWiQ3hyLqL5T8duLk=;
 b=oDWCKHtk+ihHOvRo6WMVmB74NfyTjri4lK3Dq2FwVKv5RQYAvvJdi4SbGNb+DtLieXFE/q/pYFjcvk7Hg5KCzbnBwZtix/WgKuoC6wlsKnbeFB96oLe581EAqxmzg8a8ItC+tuY9geZkQ3J/1DwCQ4Sdz9tmr7XyaGrUgjJMqo3dR4zY+LSmHEanWJDmeCDCu5lLlDuMPjh0GmPDboosvDYEwYiD3JLlp8PzcnvmJMNPOveXo49NKJPEx4gEF5dpjMchOJ5qwyD0Ceade55C6sizu9zG34PkEuVz1U5ic9P5t2dVfhAj8Ctj3U+m4rpF4YG86nAD22xNrN9jcXF0pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6614.namprd11.prod.outlook.com (2603:10b6:806:255::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.26; Thu, 10 Aug
 2023 03:29:18 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 03:29:17 +0000
Date:   Thu, 10 Aug 2023 11:02:19 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>, <kvm@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        "Zhenyu Wang" <zhenyuw@linux.intel.com>,
        Ben Gardon <bgardon@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        "Zhi Wang" <zhi.a.wang@intel.com>
Subject: Re: [PATCH 19/27] KVM: x86/mmu: Use page-track notifiers iff there
 are external users
Message-ID: <ZNRTO0hY8GJBrnOg@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-20-seanjc@google.com>
 <5581418b-2e1c-6011-f0a4-580df7e00b44@gmail.com>
 <ZNEni2XZuwiPgqaC@google.com>
 <ZNLlseYag5DniUg3@yzhao56-desk.sh.intel.com>
 <ZNOjyf2OHQZYfMEJ@google.com>
 <ZNQfX4JHTJu1Qtl0@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZNQfX4JHTJu1Qtl0@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: KL1PR0401CA0003.apcprd04.prod.outlook.com
 (2603:1096:820:f::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6614:EE_
X-MS-Office365-Filtering-Correlation-Id: d57460aa-9f2a-4e59-237e-08db9951fa4f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4M+Bs8xYOiyFQLO5A4DqAqd7j3TTmUxQGyzU+9EOEwFyFs0Bb4KEl1PnUEBOuXfxxtTtH16BMpOLf4kF8OAkHtEiBWsuG91nL2qB7UYeUtGO0g/8npHqZGkLcAJt4elPMPyqAS4DEhScPViWP3Vq6Zmb68Ij/NxmYe7F7EdkTaik59PQVuEkaAmyNjjezqhVjDPGO18+PlYA5cmDLt7SsV1RkJPNxCnmecHWa8h+tq1y+oARJy+qUp6Y1cAarsEK1jk1BR8dJYMP2TeJo9PAsxCAAyFPiFLMmiY7Nae9N4nrSSbt5be8M5WXOiNwrHXF/ChVTN7RRATznNWXNsGQ1Bd3IFOR4ZUJET8XRksLPTQuh7J2+Gg410aPYDr2yPODY63e+t9QcTPCTHv59LBDbM2nyQYZH4M5nN0ye1HmrSfZspXDpDMLSno8sdWyt5Vr7309/PSGiS8ccEFREFhDVaQZ7wP0V3EnX5E/GOPPJCTSLTp6h6QFqQ6+fzwn9hzsP/3PhiQ2gZkvWnhNCZqz4/GA+EgipMlwSNc9EXlLP5OI20jtcYF8rvrfK3d1ujxuEQYiDStiRpognq6X2b1k9VeIrCD8m9OvHAWIptq4ZB510H7Pcyc0psr91U55u5UVTBPMTxo6OnNSC289Ht6j1VBsNTxBBroReigWEoLUums=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(136003)(39860400002)(451199021)(186006)(1800799006)(921005)(66556008)(26005)(478600001)(6486002)(82960400001)(86362001)(6506007)(53546011)(6512007)(41300700001)(110136005)(66946007)(5660300002)(3450700001)(316002)(8676002)(8936002)(2906002)(6636002)(38100700002)(66476007)(83380400001)(26730200005)(19860200003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g0RXMTqs0igDElB6OifzfGM6zzolq1fpSWP89weHTJmcRVqxnRarIGhNINLn?=
 =?us-ascii?Q?sULqsk4l9ckdZ6Ogmb790+U+57rVguJqqIZYC1D1sB8ycM0GgYq3D39kfDdi?=
 =?us-ascii?Q?j6aBHvLmC/tZpIcVQAP6aBVo2GDUD1FYB4pCtusXWtaEw8FPNt5x5dFpj0NJ?=
 =?us-ascii?Q?+VuIAlsiLVgAQaI5VVcEmUwsbnZQYE3XKVW6owQrZ4IOGTVahYEhudG453sr?=
 =?us-ascii?Q?LsMPkzUUiB+Ag+Pof/F12Wl4P8B9qYW4sT9kWH3mqqClobvvS65gMC1UVrId?=
 =?us-ascii?Q?WI2LUyyMhJ1gtSkyOcapz5DiZKI0qPbmAIwVJvxdaPvP1ii5wIyNispDh6mV?=
 =?us-ascii?Q?YOSFPbVZaqKO3qH/sdmIU5GXpvEtzjacoHqAk3d6N0RtvtN086VKotyvJkxN?=
 =?us-ascii?Q?A93tDCle2srIeN5jsUPA/VTVFA0fWu00UQZcTKLgnCsR6sqfTuJe4LYaHxaY?=
 =?us-ascii?Q?IqP765+R4G0RyX64Mp0xsq9P8o6uwFv3eHSpcKZLbvO1BjZoWgzkevJJvjms?=
 =?us-ascii?Q?4qvPqbhxEvpLLw0VRw5ZgZLtumDxp5ESi/ptbJUn12EvINBWhh5dy4KPTyGl?=
 =?us-ascii?Q?HTHzbct5ncolwYl6+YReVpI8BlHCDy0uoJedsKNUnVJQbHUTm1n4lcTtPaz4?=
 =?us-ascii?Q?J63YtFe1W9raYWuiTAiVk3ZVh6TFDSLPbTXAz78M74DTTeCE/MltQuGPH12p?=
 =?us-ascii?Q?Xjonq8e24XRwWCE3UB3olKVEbndWjojYXUED9r+nOsbeoU6EguCHsINl7jlE?=
 =?us-ascii?Q?9n0JLV3bZW63foj9H1WmnqdW2mYhZWeay5hGmybjOOpFwnp3lsazk0/sNlwz?=
 =?us-ascii?Q?imDkeI1C5HQOqNFZuG4nUFrUIVRJJ0MVUHslIn2LvPL3d4rvwlrOIShblQLM?=
 =?us-ascii?Q?kurxbnpGZqJQFWrsTxk796UgxSIaV+rGyQ6agwccSNWfjkjxHVb/aaYVuuSs?=
 =?us-ascii?Q?yPiGFAFP2Sl/T+o8/5v4kg4l4yKCVbWYr0VRIonfM5dUU8+sT23OMQFkHr1E?=
 =?us-ascii?Q?U6evFNvfdoOE+LwCLU7SyPbmWNxCtrvN9zadF79aSTEPm+eJDNvPgQYLso6S?=
 =?us-ascii?Q?CIn2u6EjzcTg+eXqs0ekVtwnEdiEmauFx6j4fKu2gOa5rB8OxnRRhdv11bVR?=
 =?us-ascii?Q?t63Nf5VyHif0Xujbg9CzSoAxNo/TwwOZFChn8rHAGk/waO7ES8jUKwNTmeOQ?=
 =?us-ascii?Q?voTWvf85yl7+AlV1z4Owm6XBY92Wm1BcnS+StWEL4pDrFeHsQcKiNhJfrQCZ?=
 =?us-ascii?Q?GGS2WuC1pmLznP9XqqTy2yYlmtl+KkHW57eLq0bx3FB1oqNtYjfdlcZ3JZQj?=
 =?us-ascii?Q?ODf8kWLYmJO2+cZGU/Zh72T9SSsaASqEhQWDb6/U3bwRPZy/EByXkaOlaewm?=
 =?us-ascii?Q?nqisUE1Ommd36/Sp63zR/M2pTClyLXO7q8neBw+JZMfRN1BjbDkL+YJqyuyi?=
 =?us-ascii?Q?uw0pnLrKKrYWiGByJEURyNWz3jiaROAnmZP1gqs18LVD5/Ct/DkCkxviWf8d?=
 =?us-ascii?Q?Vmf1x5u9GwwyxnwB0vhMrNyvaIZJLcAG8aF6Yyr7f9XrgFk2z8mVXFc3dRru?=
 =?us-ascii?Q?JvAW2P5wGCZjfznhbvR8jUUXvLsyhPgJLu9Coqu8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d57460aa-9f2a-4e59-237e-08db9951fa4f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2023 03:29:17.6848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e7HeICjAxbYyEWCukFoXgsmueyXtNoRdlgh2dpjhxsXqZZoMVvBXRdRql2oDF1NLa3v/ylZKQcjl9y0YViM6Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6614
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023 at 07:21:03AM +0800, Yan Zhao wrote:
> On Wed, Aug 09, 2023 at 07:33:45AM -0700, Sean Christopherson wrote:
> > On Wed, Aug 09, 2023, Yan Zhao wrote:
> > > On Mon, Aug 07, 2023 at 10:19:07AM -0700, Sean Christopherson wrote:
> > > > On Mon, Aug 07, 2023, Like Xu wrote:
> > > > > On 23/12/2022 8:57 am, Sean Christopherson wrote:
> > > > > > +static inline void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> > > > > > +					const u8 *new, int bytes)
> > > > > > +{
> > > > > > +	__kvm_page_track_write(vcpu, gpa, new, bytes);
> > > > > > +
> > > > > > +	kvm_mmu_track_write(vcpu, gpa, new, bytes);
> > > > > > +}
> > > > > 
> > > > > The kvm_mmu_track_write() is only used for x86, where the incoming parameter
> > > > > "u8 *new" has not been required since 0e0fee5c539b ("kvm: mmu: Fix race in
> > > > > emulated page table writes"), please help confirm if it's still needed ? Thanks.
> > > > > A minor clean up is proposed.
> > > > 
> > > > Hmm, unless I'm misreading things, KVMGT ultimately doesn't consume @new either.
> > > > So I think we can remove @new from kvm_page_track_write() entirely.
> > > Sorry for the late reply.
> > > Yes, KVMGT does not consume @new and it reads the guest PTE again in the
> > > page track write handler.
> > > 
> > > But I have a couple of questions related to the memtioned commit as
> > > below:
> > > 
> > > (1) If "re-reading the current value of the guest PTE after the MMU lock has
> > > been acquired", then should KVMGT also acquire the MMU lock too?
> > 
> > No.  If applicable, KVMGT should read the new/current value after acquiring
> > whatever lock protects the generation (or update) of the shadow entries.  I
> > suspect KVMGT already does this, but I don't have time to confirm that at this
> I think the mutex lock and unlock of info->vgpu_lock you added in
> kvmgt_page_track_write() is the counterpart :)
> 
> > exact memory.
> > 
> > The race that was fixed in KVM was:
> > 
> >   vCPU0         vCPU1   
> >   write X
> >                  write Y
> >                  sync SPTE w/ Y
> >   sync SPTE w/ X
> > 
> > Reading the value after acquiring mmu_lock ensures that both vCPUs will see whatever
> > value "loses" the race, i.e. whatever written value is processed second ('Y' in the
> > above sequence).
> I suspect that vCPU0 may still generate a wrong SPTE if vCPU1 wrote 4
> bytes while vCPU0 wrote 8 bytes, though the chances are very low.
> 
This could happen in below sequence:
vCPU0 updates a PTE to AABBCCDD;
vCPU1 updates a PTE to EEFFGGHH in two writes.
(each character stands for a byte)

vCPU0                  vCPU1   
write AABBCCDD
                       write GGHH
                       detect 4 bytes write and hold on sync
sync SPTE w/ AABBGGHH
                       write EEFF
                       sync SPTE w/ EEFFGGHH


Do you think it worth below serialization work?

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a915e23d61fa..51cd0ab73529 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1445,6 +1445,8 @@ struct kvm_arch {
         */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
        struct kvm_mmu_memory_cache split_desc_cache;
+
+       struct xarray track_writing_range;
 };

 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index fd04e618ad2d..4b271701dcf6 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -142,12 +142,14 @@ void kvm_page_track_cleanup(struct kvm *kvm)

        head = &kvm->arch.track_notifier_head;
        cleanup_srcu_struct(&head->track_srcu);
+       xa_destroy(&kvm->arch.track_writing_range);
 }

 int kvm_page_track_init(struct kvm *kvm)
 {
        struct kvm_page_track_notifier_head *head;

+       xa_init(&kvm->arch.track_writing_range);
        head = &kvm->arch.track_notifier_head;
        INIT_HLIST_HEAD(&head->track_notifier_list);
        return init_srcu_struct(&head->track_srcu);
diff --git a/arch/x86/kvm/mmu/page_track.h b/arch/x86/kvm/mmu/page_track.h
index 62f98c6c5af3..1829792b9892 100644
--- a/arch/x86/kvm/mmu/page_track.h
+++ b/arch/x86/kvm/mmu/page_track.h
@@ -47,12 +47,46 @@ static inline bool kvm_page_track_has_external_user(struct kvm *kvm) { return fa

 #endif /* CONFIG_KVM_EXTERNAL_WRITE_TRACKING */

-static inline void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
-                                       const u8 *new, int bytes)
+static inline void kvm_page_track_write_begin(struct kvm_vcpu *vcpu, gpa_t gpa,
+                                             int bytes)
 {
+       struct kvm *kvm = vcpu->kvm;
+       gfn_t gfn = gpa_to_gfn(gpa);
+
+       WARN_ON(gfn != gpa_to_gfn(gpa + bytes - 1));
+
+       if (!kvm_page_track_write_tracking_enabled(kvm))
+               return;
+
+retry:
+       if (xa_insert(&kvm->arch.track_writing_range, gfn, xa_mk_value(gfn),
+                     GFP_KERNEL_ACCOUNT)) {
+               cpu_relax();
+               goto retry;
+       }
+       return;
+}
+
+static inline void kvm_page_track_write_abort(struct kvm_vcpu *vcpu, gpa_t gpa,
+                                             int bytes)
+{
+       if (!kvm_page_track_write_tracking_enabled(vcpu->kvm))
+               return;
+
+       xa_erase(&vcpu->kvm->arch.track_writing_range, gpa_to_gfn(gpa));
+}
+
+static inline void kvm_page_track_write_end(struct kvm_vcpu *vcpu, gpa_t gpa,
+                                           const u8 *new, int bytes)
+{
+       if (!kvm_page_track_write_tracking_enabled(vcpu->kvm))
+               return;
+
        __kvm_page_track_write(vcpu->kvm, gpa, new, bytes);

        kvm_mmu_track_write(vcpu, gpa, new, bytes);
+
+       xa_erase(&vcpu->kvm->arch.track_writing_range, gpa_to_gfn(gpa));
 }

 #endif /* __KVM_X86_PAGE_TRACK_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05a68d7d99fe..9b75829d5d7a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7544,10 +7544,13 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 {
        int ret;

+       kvm_page_track_write_begin(vcpu, gpa, bytes);
        ret = kvm_vcpu_write_guest(vcpu, gpa, val, bytes);
-       if (ret < 0)
+       if (ret < 0) {
+               kvm_page_track_write_abort(vcpu, gpa, bytes);
                return 0;
-       kvm_page_track_write(vcpu, gpa, val, bytes);
+       }
+       kvm_page_track_write_end(vcpu, gpa, val, bytes);
        return 1;
 }

@@ -7792,6 +7795,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,

        hva += offset_in_page(gpa);

+       kvm_page_track_write_begin(vcpu, gpa, bytes);
        switch (bytes) {
        case 1:
                r = emulator_try_cmpxchg_user(u8, hva, old, new);
@@ -7809,12 +7813,16 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
                BUG();
        }

-       if (r < 0)
+       if (r < 0) {
+               kvm_page_track_write_abort(vcpu, gpa, bytes);
                return X86EMUL_UNHANDLEABLE;
-       if (r)
+       }
+       if (r) {
+               kvm_page_track_write_abort(vcpu, gpa, bytes);
                return X86EMUL_CMPXCHG_FAILED;
+       }

-       kvm_page_track_write(vcpu, gpa, new, bytes);
+       kvm_page_track_write_end(vcpu, gpa, new, bytes);

        return X86EMUL_CONTINUE;

