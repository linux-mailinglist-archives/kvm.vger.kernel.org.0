Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53F4741E19
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 04:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbjF2CRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 22:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjF2CR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 22:17:29 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7A730CB;
        Wed, 28 Jun 2023 19:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688005046; x=1719541046;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=DfNdg9yE30XoRlW1uA0guGJxnOZwb4oeIaKJ1SOpnVI=;
  b=mONtxg/2Ae0jXnOzsDpAv14MzIOrN+ZZW9QlWQKBP1iaSsdwJRgz1WfB
   JMRNin96v/ZdGmgoDMCRINbktnCpQWU5T3xqUmc/yyxu0c00dsja7d7IU
   IIrGnFx1Ulx9HgsT5eN7ZYgnpYqL1UlrcUz6PJlm2gaCSGzvJ4sdT6YYx
   DItcOn5MPaO5MVmcoPTKtelH1IUbsT/fNgTasxftj+kJX3UDCux/vsZtZ
   FNWmy8iVV4W6YYRJHRXKvmxyerVKZHpfQg75OhhRuSF84V1+7MWR6bKDR
   P3bNHkbyWF6IlkX+hLe8Dncng1nZpCFmdv7gxXuI80VzzJg+Pzm3xHG/M
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="428022707"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="428022707"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 19:17:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="782518067"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="782518067"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 28 Jun 2023 19:17:25 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 19:17:24 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 19:17:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 19:17:24 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 19:17:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5bAnFd0E+OnaAm8JwntPiVtpnEopbiwihBG07rCVjidCl3RFHDD290ov3HnphhewRBLFoAikaZvFEwTKe1Aw7185e1Yr17WvKTYSo8S3j0XI3Kgn5oPhe9UqQZIM4heqjdsE+Z5a46JIDbx6oh3bGSkgVgDJqS3QZvO2NEq92yHtO2OlEW7SiHf6Lf4ipj7mOXDExDcW3LfM9wZDquLfLInnSX4kuXhxB/aONdfsU4UJ26knYfbY/pHrfdqxw/yN6a5IrJUolToL47pnwtRYijmgnTLMb7syQV6SZN/idAGu/9OI6x9Gd+jMXpjJ3RonSAEgtfszjkzhCcL+gaPfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AuBXDJmB1+U3UoN7q1QBTEeY6Rrg3DeS2rw115OFNao=;
 b=MeePqljuSTD/Wg9MKzCxuzRkym0uUj+uTek8b1hGRNXqs0tzpsTL52GE9S2R6uijBmOlJ/2RN1SiCTGAs9zsbo5VEFrVf7lDRVVKOIM/BHZL9UDqIF9N5Gl1xtgwnN3lNsJ2qWspsJc1wKjOGyTzKdD2UTCU/BI4ED6JdVse4+G1RXPLWN1v5a7rZqobfXlXU0/VwvSG2gX0fbK59NAWuWnTIuGaMb/5NYIIqh5MrYcAf7D1vxKby/Nhe5tlYOfs1a18Rod9hoIqCXqfaiEWr/o/6Zz1owIDxU5jvzLey4NtyKt26hFv0EmKTK0Vcz5NkYk5BWfaYxzfCyxBgNharA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7386.namprd11.prod.outlook.com (2603:10b6:208:422::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.24; Thu, 29 Jun 2023 02:17:20 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6%7]) with mapi id 15.20.6521.024; Thu, 29 Jun 2023
 02:17:20 +0000
Date:   Thu, 29 Jun 2023 09:51:53 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <chao.gao@intel.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 09/11] KVM: x86/mmu: serialize vCPUs to zap gfn when
 guest MTRRs are honored
Message-ID: <ZJzjuW8ytOuNhrzY@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023945.7570-1-yan.y.zhao@intel.com>
 <ZJy7pyQYmuYTXC67@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJy7pyQYmuYTXC67@google.com>
X-ClientProxiedBy: SI2PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:4:194::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7386:EE_
X-MS-Office365-Filtering-Correlation-Id: f5be66ff-ea73-4ab7-99a4-08db7846f78d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5wRJNaldOJIl9wjhPmqOTQ13bGXuubmEd3tsHkX4iFHMhuhxW72HwYPQ1YaZpr0xCvu+8QgvbbKXP1vZzYI89OBKVnKwn/Q/lSqhU9XK3euwLND79Wjnk5bEoZofjFdDCl7ZckBc9I5zKPFSll+DbXOQi7LmggEU/TEeyAb/HTCf1oLBBGSp5h+5+OdeNySkLH+WykUUNqsr5JkARS1zEUStMbtzbHFbd0NwAGxWYNzH6hxgL1sWr5YuKFArUJryyDbPaF8amsVQrOlLAMtjPVZ+ECYVUNeKMEmJByHzNWkyfdWgP+LBlAQhJDX5aGKIiWne/oUZMmB/35taX1rGAAaatfbwhRYMKPTkzq3Dmr12je1cBSpPzxl33S91IMlymR7reuy6GwvqRjkvmCGUfl/VNWVSEI/1ejQotPcPAABJVdqBm0snrUbzDkyAYiAlavZpqhjBcFc08LEnr+qYaa5rNUDvyR3WWCg8bNz+43P3HnJrkirAKBurKQuSDzpB3HII6+oHat3mgDLYw9+U+jYcsoa/p69sRnfUw4n6Nk3SRaoTlz/4TMZmEeCbwII/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199021)(6512007)(2906002)(186003)(6486002)(83380400001)(38100700002)(82960400001)(6506007)(6666004)(26005)(86362001)(41300700001)(478600001)(316002)(66556008)(4326008)(66946007)(6916009)(66476007)(5660300002)(8676002)(8936002)(3450700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b+ziU5ag890Evv6h+v0c1+/1gqPSvd+9QkxIkkL/zfUJlrBr1ytTANLAZkn0?=
 =?us-ascii?Q?A5VQFo9cd2ZTqIPoJ1vYuP5YbsRdyaUeCEaK5gDOpJWYbtreqP9IbYfNnV0w?=
 =?us-ascii?Q?GtLkEaSKzYjpX9r1ql22lNbS2aJzRiTgOFBa57gwzTDGVVptRFTgn8HpgYMv?=
 =?us-ascii?Q?UV+iLi0c0Olsim351A7PLWurMdKOwDv7htLUeAoukxXco1umO5W0hOw9EwZ1?=
 =?us-ascii?Q?PppRTa9dBRaUQ7iYm4DGek2XKjGLBSzs7JmnuEVR8vRMU5BdH81Z2PYY4nNF?=
 =?us-ascii?Q?j7qw2vpp2/PeU8LtvOUPu5FAhMEjvO7fZDX0zPAcOkNBZJNfQ57Z2C9DkizP?=
 =?us-ascii?Q?QNH7p0W1VBzi3rf8xPiUHKm1k517NRjC8oa4//5h+APY09M0jBWTCclFrybZ?=
 =?us-ascii?Q?d+Ck/xRQ39oWZ0hRq1Tyskn6bhtzNiZdyAZ4gGDIAmvVgyFua8ZCj7WfNUTs?=
 =?us-ascii?Q?fRloFrosHk4k2bhGVgHMMqodlmjSVvnbXGh5Tpe6kJx+7GWOknE/2uzQwcUL?=
 =?us-ascii?Q?oOFj3w1/jrLXrYb/BGnVR3W0EEn62IpLaXgc8itBp4wUYEWCWHzLZoUy6EL+?=
 =?us-ascii?Q?dtSj8Wz27EiCtGbZvmZNEOeE/W3fM/ng95yD9BoS9Uj/4TRoLm7DaoH7Lgv4?=
 =?us-ascii?Q?GJntJ5q9P0XVePs2jkw+DKzt7rvFjGHWYG+7TbXO+ZF1RtS+YZ48Ft9lrrhu?=
 =?us-ascii?Q?ypRqm24OJW3y6fRuK/eRveLFR3DeicjABbZnwthNwib6RXcKUElw5a3E3Wdv?=
 =?us-ascii?Q?cCenrCkltNtSHtxt6upb18h2a6XIqnua3jxvE5JjAF1B7g4ElFtTgBgfstqg?=
 =?us-ascii?Q?rUMfS2XDqfUOzsSvjVMYo2QJLMo6RtvDfYd4kInOTr8WjMsuz2TwqrxarChZ?=
 =?us-ascii?Q?/09sppq8vdRok8NseWe4LAosOIo/rV7Rn190Y3D8CmiCdT9EApDKse9hM4H7?=
 =?us-ascii?Q?oib6lVpkNlFMlVEYXGxlE7pw8D34VYEBfkocES1om1hNU3niOOv6vWa3SdKa?=
 =?us-ascii?Q?6aePL4KAKoPgmUfiIMM7wVzsWULV+CzfDIlwXPWiiuWFioyPDxxj7k7TjHAv?=
 =?us-ascii?Q?sREzlL7Z8lMVdqtZSmonnTCIclaDm1+JYnnJq4GMmnldYeslr5NgtpqKPwhc?=
 =?us-ascii?Q?9fED6S76QNDajWzo2tDiwXTzN15asUd689MblHoUTdPpSNa2WcYu+8KtNPec?=
 =?us-ascii?Q?wvbckzP9YvOA641vgd1NIGjb8LKrJ1qcsc5lGTzCWbWUlXAkUGNi7QvjEkdV?=
 =?us-ascii?Q?1ua1D2YUE+2DVP0dLQEC3p9VFuOMewJKzPmgVw/PVlZuPq9q8aNzmorRTNgf?=
 =?us-ascii?Q?kBDiDjsJHvPTSUzFwyJIr2+wh/yomfIbSex2L14ftMdffBvdu0BPPfRMiFfU?=
 =?us-ascii?Q?IiVtdxilSzL3S6ZZxeQBHu2A14hhmzQS7llg+v0fA/NxYTvYfHtL6Qhvt3sZ?=
 =?us-ascii?Q?c0BJ7Gboavu6762jEFNFU81A3bRp8mP1PUlQ93uGMwHEK4S6M8rtxkNro8zx?=
 =?us-ascii?Q?skJmuCJnzVJ/FJ46mQOxiI4Xb8329QG2rHKIXA0JZDwHg2mbf39rLUIDRawu?=
 =?us-ascii?Q?djfZwuczMz2TXx/kw8YMbTcR4HuqIr8vSwRFF2+V?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f5be66ff-ea73-4ab7-99a4-08db7846f78d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2023 02:17:20.1212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bdr6btilllj7mRhUxnqGz9+y31aTzZSN2LIXAZ2pdg2w45/A7IQKAzELprxs169hMNAfeabn5vHSnTOmyGLcTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7386
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 04:00:55PM -0700, Sean Christopherson wrote:
> On Fri, Jun 16, 2023, Yan Zhao wrote:
> > diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> > index b35dd0bc9cad..688748e3a4d2 100644
> > --- a/arch/x86/kvm/mtrr.c
> > +++ b/arch/x86/kvm/mtrr.c
> > @@ -25,6 +25,8 @@
> >  #define IA32_MTRR_DEF_TYPE_FE		(1ULL << 10)
> >  #define IA32_MTRR_DEF_TYPE_TYPE_MASK	(0xff)
> >  
> > +static void kvm_mtrr_zap_gfn_range(struct kvm_vcpu *vcpu,
> > +				   gfn_t gfn_start, gfn_t gfn_end);
> >  static bool is_mtrr_base_msr(unsigned int msr)
> >  {
> >  	/* MTRR base MSRs use even numbers, masks use odd numbers. */
> > @@ -341,7 +343,7 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
> >  		var_mtrr_range(var_mtrr_msr_to_range(vcpu, msr), &start, &end);
> >  	}
> >  
> > -	kvm_zap_gfn_range(vcpu->kvm, gpa_to_gfn(start), gpa_to_gfn(end));
> > +	kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(start), gpa_to_gfn(end));
> >  }
> >  
> >  static bool var_mtrr_range_is_valid(struct kvm_mtrr_range *range)
> > @@ -437,6 +439,11 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
> >  void kvm_vcpu_mtrr_init(struct kvm_vcpu *vcpu)
> >  {
> >  	INIT_LIST_HEAD(&vcpu->arch.mtrr_state.head);
> > +
> > +	if (vcpu->vcpu_id == 0) {
> 
> Eww.  This is actually unsafe, because kvm_arch_vcpu_create() is invoked without
> holding kvm->lock.  Oh, and vcpu_id is userspace controlled, so it's *very*
> unsafe.  Just initialize these in kvm_arch_init_vm().
Will do. Thanks!

> 
> > +		spin_lock_init(&vcpu->kvm->arch.mtrr_zap_list_lock);
> > +		INIT_LIST_HEAD(&vcpu->kvm->arch.mtrr_zap_list);
> > +	}
> >  }
