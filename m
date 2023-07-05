Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21AC748066
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 11:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjGEJFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 05:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbjGEJFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 05:05:13 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4821700
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 02:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688547911; x=1720083911;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NjFO60wEI0QskudvcqDqPd0K8u0lsCwRSU5inYyxrY8=;
  b=idFAEn7TDt6cjmoZuXfZ/5swTRjsuAGr/DSEwUNpH27s2A4WTV632WuI
   hRIzuG4FxB0zgTLNWjAFDh0jC2vaJ9TOoux1DJVC92sUS9NPZbIEvfBPa
   eU2v0Sl5PwVeofB68l9DfVXCa5U57CtavJtHU8k98Q2djgmjWxfLZ5U6Y
   pctShcmeg92AW11jeWvORxKwK939yzGrP1Bv2cX8mMKu3FuBwyuEJJpf8
   Onlx85DjfhdkoQj+2F3JVDibnpgAFTCn5if2aNXkt7ME8h3y+ndNeVKfk
   0ZqeKIBoZh3xzO7EHBH+FlhI3K18Of0UUzr1DtthRJwqcNc6/eb7hFa/x
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="429322860"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="429322860"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 02:04:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="809193092"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="809193092"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Jul 2023 02:04:46 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 02:04:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 02:04:45 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 5 Jul 2023 02:04:45 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 5 Jul 2023 02:04:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hf9cgthludsKYg6Y3O21Cm/qTWB7GuZ9vRjSxshEfKi8F8roZX6CWPTwsBsxBrUbwsgpGhCMtjee0WZaOWJft7cH2+qiPje1NADor5SLSqfZMAiVXEeMTmgguKd2lyy4mTymRd9aDeSIW7YEZNDBPY4WcHeXJeqoVL2k0Crs3Oj6/py3crDLm0FGmky/i5ABMoGTxBjx2ZQxMLyRk8mNfRyQNg34L9NtBe07Wc9k30DZZgPnDKFlAbvrXNP+mX+L3qU+46OuR85Qqvs7JaCCWy8HBauj6lTOeknHM8IE1PLYjqTcKTsDfcFZ7wL3I4KPWlokiGlqhCSscSFQRxodug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bIwiZm9OsHmS9K9ATjG5Mbs9yNa2gO9L2amHqrFCrcQ=;
 b=Kl9wddeUTAJsO/axw4Bhn8p59cWxUnpP1CTjVW7J8jctpeNoCfiazxOVGTRmkWNjKY9cTeL+xWujipnp1umuJKr/9TA6DWLEOLF9J+yFjAfwxm6e5wjkZM/qM4jy9BTJ7zsKIhdpofO6/RfqVlVabcoQM6zq4ErL/w0/zmFsX42zrK2tsAiLUaDd4OlUWnPtMbGHm86Y/Hz2PPddJumQRUHGQlXTx8TDWqMt1xfNN8l1zem3ff2xcd2Db4XgeMnnKc5RQIhb4wJoa/EwwUFz5Hmrs3CVKD90oaJuAX6Lq2oj+7lx30hIpo8/jC89piUBO5blByC6Yd6ELJunoHPfdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DS0PR11MB8020.namprd11.prod.outlook.com (2603:10b6:8:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Wed, 5 Jul
 2023 09:04:42 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5%4]) with mapi id 15.20.6544.024; Wed, 5 Jul 2023
 09:04:42 +0000
Date:   Wed, 5 Jul 2023 17:04:31 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Qi Ai <aiqi.i7@bytedance.com>, <pbonzini@redhat.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
        <kvm@vger.kernel.org>, <fengzhimin@bytedance.com>,
        <cenjiahui@bytedance.com>, <fangying.tommy@bytedance.com>,
        <dengqiao.joey@bytedance.com>
Subject: Re: [PATCH] kvm/x86: clear hlt for intel cpu when resetting vcpu
Message-ID: <ZKUyH+P2XmsdHp+p@chao-email>
References: <20230630072612.1106705-1-aiqi.i7@bytedance.com>
 <ZJ6rBwy9p5bbdWrs@chao-email>
 <ZJ9djqQZWSEjJlfb@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJ9djqQZWSEjJlfb@google.com>
X-ClientProxiedBy: SGXP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::17)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DS0PR11MB8020:EE_
X-MS-Office365-Filtering-Correlation-Id: afcf1ec0-80e3-4d56-b8f8-08db7d36de61
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oYxfYsBDTIaV1vte5/ShQuxSKKwXsxexnT9hB1rjQ1SBrpBSoTBXrLHs36a99nlY6EOGJ11tCexkVclOQ/LMOBLm3VcZg7CKoCT/uiHKCeRJs7Ov262jxvUUKaLcrmq/qCa/t3QcJvq1XeF4tsek/r0vZVHz30iJsXyX/ezQKjRM87mtK7K9xUqhCpW3HMk6oTqhQGorN9zIquSNGx7avyZH4N1bTR+Tt1tk1kMTt7SSLhO5aajdaBzolLbsKACdRY/nfGwwHoJMe0D+pNfAd2tzILcpnmxp1UKwCyFSHDLeRCLy1KlA7pEYeqye8jkakAdeW6gdlUp4U3nQkZSlWF5E+1NY/tPVgZ99K8af02eZaYzzPRTAONuU02OhUquh5qR5nWw85Ba3rBHshGPxxZK2yhqlRIe0UAletmkFloCVJpFu7PMYjhuFkemTAO56WhN8OGXaxznsEN/+Tj7PWqS6UipQrzZrZxg4F/i6TLNI6Bal0k+sj81JmCe92wt+xopuIiNtjMoOqn23nqG98KhIfElCRlxvDOft7CThprVETarUEg1CQNBfTF8hnpDh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(346002)(396003)(376002)(366004)(136003)(451199021)(44832011)(7416002)(316002)(66476007)(6916009)(66946007)(4326008)(66556008)(478600001)(5660300002)(8676002)(8936002)(2906002)(6512007)(41300700001)(86362001)(33716001)(6486002)(9686003)(186003)(26005)(38100700002)(6666004)(82960400001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wjp1Dyr7C5ggQCa6wZJbngcQTUad3F8wbqs73NVoOtmvB4noFSeWdJDbhy6p?=
 =?us-ascii?Q?wvUXEDekciLiVaZ8T+BwHEmhVyQmV5rY9raXDXfMwi56B51k3Dv3uakQ9chj?=
 =?us-ascii?Q?JNJ/0v/nSlJGgtWQC0nM1z0D293gAj2Lae6bB+6bhiaB9lfvKiksrhxgJq18?=
 =?us-ascii?Q?9xzXeDl38sj+IYHKxRUSPj/hKXNhLPK8tbaWwjRPAf9Drjvb0u0eTp1SWfSF?=
 =?us-ascii?Q?zpsR+Dy4IX+ZMMi0ou+9DuAIZNVsRWNQDbhfoKZlRAJU09B8Obk5wHP2ygFv?=
 =?us-ascii?Q?uKc8unOUBJKJDCq1jm/nJGmdOWcMcBvkAUx+ht0cRBBi+iO3S5MUHb+jg7Qe?=
 =?us-ascii?Q?EjLkKj54BKOTdh4A8EmTLTYQrjCJ4DyX4uTWl4sDT0oH1SnNBb8XiZZOSGZa?=
 =?us-ascii?Q?wQ0sMa209/iACeQX7ldIpSEAL99C1KXgnKlQyrRn7G3Skb3n6vYLhnhG9233?=
 =?us-ascii?Q?W9B44ZcAzQaoLJPYpa8nYHrymoyR9M9XwcnL5iYilIenbNnoNywdCe0NPEyv?=
 =?us-ascii?Q?eX5vLpOkYwD4zyi/ynqFxU6WDNwpoMuZCEmS6DZkr0dttLQaeCVIDHGXlt/I?=
 =?us-ascii?Q?QJjXYgqKEGhy0SBMyDICXnvM2jTa+z+X/ivge6nVUQGBYLWAoHZS6gibp0V3?=
 =?us-ascii?Q?8WQ+s7kjU0UuVdgG3nljGAibHH1t9IgtX3NVPH5M4+1sz+6Uz8Kxgwm+uLAw?=
 =?us-ascii?Q?H0Cpa4D/DYll4ijpQ3ySeSrjfTl8F9814AHq5wahQnisDrpopdneNdQW28Da?=
 =?us-ascii?Q?fXvENjVC9bt/c1sJlglMwcQ8GXrW1ln8S97mOj3Co2APjSi34/Rzw4RuvSMs?=
 =?us-ascii?Q?YRjuHArjQZRhvdvu3F3/pVxS/trDQQslZ3gf9mawi/XvmiMzyYYwUghLvltK?=
 =?us-ascii?Q?u6aEWfkDp8IgWDRH0QA58mBp3224lKdleIXjHlQT8Ytdzvcd6vJ5ltJlkyiM?=
 =?us-ascii?Q?ed/4oTxD2xSDIZDDxMCcrKuLe3r++9JVOQPkgXb0KNk5foxLXM9bVKMMripP?=
 =?us-ascii?Q?WYUj2IC9eu1mHE1Xknmhfx+HNSXv8/1KQATznLUEkGUuApt9RtyaSXmc9N6R?=
 =?us-ascii?Q?6nkhEUBqyaO9pXI/1eesZJaTc3DdiZnM0jV/jNow0jJaJLDa2uNtnVDOrvkm?=
 =?us-ascii?Q?WGvc2uCJ+vpOIefJDd0Jb0Xl2ID69RrHJpVCRB2f+GDZId4PnKwwk0OeQY2+?=
 =?us-ascii?Q?hZN8nF5RG64xz1cTVhTmJrJ1xye78Z+uZCTtmTisLhxxtjVTv7H8UrKRAupQ?=
 =?us-ascii?Q?nW4FHl6T34GkWPu3EzXP7repO21wXW765u6QDZNYMh+MU6AuQEpA0SN0a1pq?=
 =?us-ascii?Q?uxakTAVONpEY29pzycbDU/RNdbmyu/rHCmtId0vINNzwp3UGUVz9z9bsdoFa?=
 =?us-ascii?Q?FBezCNwIR7PKjqhftFmUS9ACWFwEAAUdFqEV22K2AvRkbvXcDVwg5ggXFw0H?=
 =?us-ascii?Q?xPT5KREVhErrogzsk4uXMcsCV7Xlm4iE2bNAb1CPQ1g9+2WC67fQpgAA65sP?=
 =?us-ascii?Q?oaxD6Ktuxdmu6Z5hE+O+DZUnJFQ8uqD65alKlbotU9Tcw1RrrmwK4wZkLRfI?=
 =?us-ascii?Q?pzCBCeu1b5GnAngdyE3w563W2eKXddUsnMHQh7xh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: afcf1ec0-80e3-4d56-b8f8-08db7d36de61
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2023 09:04:41.7393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zhu6LeEqLKzWRhHwpgmTE/YLcvPpfBo1+CbZN7JmrwjrJ/vz+TD18GoiQ8pVKP3gWrid/VdZFdR5LQTm5h1FdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8020
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 03:56:14PM -0700, Sean Christopherson wrote:
>mn Fri, Jun 30, 2023, Chao Gao wrote:
>> am wondering if we can link vcpu->arch.mp_state to VMCS activity state,
>
>Hrm, maybe.
>
>> i.e., when mp_state is set to RUNNABLE in KVM_SET_MP_STATE ioctl, KVM
>> sets VMCS activity state to active.
>
>Not in the ioctl(), there needs to be a proper set of APIs, e.g. so that the
>existing hack works,

I don't get why the existing hack will be broken if we piggyback on the
KVM_GET/SET_MP_STATE ioctl(). The hack is for "Older userspace" back to
2008. I suppose the "Older userspace" doesn't support disabling hlt exit.

>and so that KVM actually reports out to userspace that a
>vCPU is HALTED if userspace gained control of the vCPU, e.g. after an IRQ exit,
>while the vCPU was HALTED.  I.e. mp_state versus vmcs.ACTIVITY_STATE needs to be
>bidirectional, not one-way.  E.g. if a vCPU is live migrated, I'm pretty sure
>vmcs.ACTIVITY_STATE is lost, which is wrong.

Yes. Agreed.

>
>I'm half tempted to solve this particular issue by stuffing vmcs.ACTIVITY_STATE on
>shutdown, similar to what SVM does on shutdown interception.  KVM doesn't come
>anywhere near faithfully emulating shutdown, so it's unlikely to break anything.
>And then the mp_state vs. hlt_in_guest coulbe tackled separately.  Ugh, but that
>wouldn't cover a synthesized KVM_REQ_TRIPLE_FAULT.

I traced the process of guest reboot but I didn't see triple-fault
VMExit. So, I don't think this can fix the issue.

>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 44fb619803b8..ee4bb37067d1 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -5312,6 +5312,8 @@ static __always_inline int handle_external_interrupt(struct kvm_vcpu *vcpu)
> 
> static int handle_triple_fault(struct kvm_vcpu *vcpu)
> {
>+       vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
>+
>        vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
>        vcpu->mmio_needed = 0;
>        return 0;
>
>
>I don't suppose QEMU can to blast INIT at all vCPUs for this case?

IIUC, userspace can queue INIT to a vCPU via KVM_SET_VCPU_EVENTS ioctl()
with flags = KVM_VCPUEVENT_VALID_SMM and latched_init = 1.
