Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3F573623C
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 05:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjFTDmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 23:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFTDme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 23:42:34 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56342E61;
        Mon, 19 Jun 2023 20:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687232553; x=1718768553;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=OP/3mfSJEn8/4/GFzNhbyv28MHOAfOdmH81IwiKp/2Q=;
  b=YgRYUkvnGV5CsY023WFd7cyzHnknSvmDa05ttp2g/bUXeO0w8PF9BjqD
   10hFMsRxcPAp1753JpdukNkrKiL0rNQ0jmCwRPb1WYFIW7A35FlQUeWRx
   pDGuTQtPIn1s83n+MLUovPkSQUmEAHET00dSybL2qmvO+lFGK/o3y28H2
   7BrkQzv/vxOuJ6Az3fOF6n9B/ZJInJgCQMhLwCkEMFdSX3GkOPXopxIM0
   SwRtPkOn3GRtXoBx8Asuo6GLeRflYOwPcXK13bBQoO833oy60I5Kw6X1Q
   LKywY4rA0axI5r5yLzgayyHX3Yi7pdWtgPUjdFw1IoZnZ1zgwJGI1PtCy
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="362297738"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="362297738"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 20:42:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="960616149"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="960616149"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 19 Jun 2023 20:42:32 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 20:42:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 20:42:31 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 20:42:31 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 20:42:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+ckpTBBjQ8pMBPWF2lpG6z5CaO7zpN3/vC5H45CdS6hEMymxhC+fmaC70tc1NNGmlLUHGXU7XXzfNMZPd3RoFrjCfDTQYQ0kgFXij+zWaZeZksEQRL1niK89jpZW0Xe7bgDvdHdzxVCDRrvzVLB5iJfazY0Y+zjfe8CCNo7qFiyKkMNMulXkvOQ++cS2zgYSJQgNc6uNjP6WePwgdOLDaHFv6Pma/Dan49WMmJ0TJBuXFsAFG9OiEg3bz2/af9Dbn80jO2Xm6J8V8GDoGUHWxs9Upqlkz1briWuWTaSYcgJe1cNwsegPp5W96pl33yH+aFn2yfjCHsJXwPpPgDPKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZ7oLxMKp+cohqgUzZ22eoY3EbWrvVbSMuiLjRd1P+Y=;
 b=IbPzwqfICjX2LqS2EFc/DeioAJucK04LQHw/QajrURyIn8NPo1pP5Pa6HR/3UHYW3LHTTdZD43BShHaYTlMP0xaARBfXoPwMoJFFwUTIQrGNUMkAPVeoNi9rDf2LqbvSnis41rkPp16ME5no5pGVOvhVNsgnc6lbtZ0v4M8jVs1EIyHJH29+LAS4CkHbk1SvAW9RaZrfYIRsvKNOnd2Rwzwzp+TGt4BSClGIqQSZxgtiGv16dbfTaWMo1xRKJUDyJzNdcDUFlCZZ6GZkqxOwuhcebeV4FGy/IwOxsVdt8yGkoaZlzXC0g0cMWLJC9J8XA548xuKB84X0sz9697OpzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7409.namprd11.prod.outlook.com (2603:10b6:8:153::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.29; Tue, 20 Jun 2023 03:42:27 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6%7]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 03:42:27 +0000
Date:   Tue, 20 Jun 2023 11:17:10 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Chao Gao <chao.gao@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 07/11] KVM: VMX: drop IPAT in memtype when CD=1 for
 KVM_X86_QUIRK_CD_NW_CLEARED
Message-ID: <ZJEaNlDe1jVkYyqz@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023815.7439-1-yan.y.zhao@intel.com>
 <ZJESMaG5Thb5LWtt@chao-email>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJESMaG5Thb5LWtt@chao-email>
X-ClientProxiedBy: SI2PR01CA0030.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7409:EE_
X-MS-Office365-Filtering-Correlation-Id: 3647c32e-6021-4ea3-6331-08db71405db3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZozJ/VrzeK22htdRlHDDYRTMHlZdUtwQV4Y6ybVeFdLFcvOccyvIhxdVcbzMlz4uyGdjk/59N7YJFVygmeysAou43/ffYUFZwJOvl8n68/pyjMGRAjVauRu7W+FBB5dLkZBpoEnqHahN+3bNsY8w+cL22N1jmWsUjk1xVYsalEfdS082mn1HEVotbs7UrVXyhqh1StOARxpbgo0jIKTFh+4PqezQanifb8iC4HOymmBC1lIGW/LyXP5NzPtqJBvPuzgbgI4Q7iMqLubhUYWhUo/UaXbsa7N2G+VZFZr9iNe+jyShxb+SYaoqZES+3JjrbqdDb5fpo2s3xKqHyq/mlK8OwD7IvMCzu+jE87UGfMQy9Zt09eWqAsORvzQZ87sN9g6JbmjkM8YpwGP2Huv1zyy4ZrCUpQJbe85B0cmy3Vp7iyptbBIBEMXIry/2IzSx6kWXPYjleMTFA6x3DiPma6rG0vDx6LmT/ruU3KVGxWiTpbGRQmAzoLW/FwX8itnN2H0cQZCMgtaB+guwDyBlZuPLIXi6zJDVG7ssB7MNr/c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199021)(6666004)(66476007)(66556008)(66946007)(316002)(966005)(478600001)(4326008)(6636002)(86362001)(6512007)(26005)(186003)(6506007)(3450700001)(82960400001)(8676002)(8936002)(6862004)(5660300002)(38100700002)(41300700001)(2906002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LtDby6+GhF0RyRVtYUYIo0UJyYNwzl5P9dUnuopZqJDfuC96Mx+C8zlqabaG?=
 =?us-ascii?Q?K52Xe6cgn3RHE2ZufaPH6dpWnKnLbFpM7BO0B0LUtgO+Se9Wq65zlFr2N8Lg?=
 =?us-ascii?Q?aA5LEerUI0y5oq9He973Ndlec5FM2VJm1JOj65HtM/XaOiTBZ34Km5oApM+u?=
 =?us-ascii?Q?YRD2r1qWQ3WyIX30zxyIrOGOcGZUjg7BdOXKKYfz8nR/6Y7kYNWspkF/YMrs?=
 =?us-ascii?Q?5VX9ui1uk2InHOs6J9vw3M/MkjPh4Zh+rDUkFBQtco+sFw9F2AgkRPE9Yso+?=
 =?us-ascii?Q?k0IKc4+FkRTslSiMClBFr4rrw5XhT9UOhP1QnFSlhWmfHAhU82Gobg3LbDty?=
 =?us-ascii?Q?IZ5MoTfXTb9lz/aWlFPD4Sdfh76sCvOkEQwsilpxIEqso4t0wCw+N7gu2bDq?=
 =?us-ascii?Q?KXDZ/ttwbA68B4Eapr1LD/sbb10lWrBtpinOOzu71xFzVcX+XA8rDjRbK0l3?=
 =?us-ascii?Q?uP6vAptmbg6c73lSETCTKGDNjyqFr3tyJUMhUMWr+PZYiMMfVDa2i/FVhnh9?=
 =?us-ascii?Q?U2GFPCY2lT5OsjMHqzdtMY16+IFt5dk3tBDIrjrYqaYh8U2rEyGs9sRvUU6q?=
 =?us-ascii?Q?NKojBNk+JEoMoYAk+ibIiB8CmOYw+3qqqIueKIs4gJbP2QLWtUSXHuRgXzw7?=
 =?us-ascii?Q?aPQsZ00NBKU2fMj6ulFEB8hMQTWVxa7CwLClzjFlf1ndCQkohf/2aQiW6DYF?=
 =?us-ascii?Q?Isvtbc2guK8W9N/7kJcwgL50yDi9mNxfKr4/xy7u4eyLfcI0L6+h/Lu/9G5G?=
 =?us-ascii?Q?iVUAbLTa32UmOdPrPzWC8Tfjxvr+0+aRdLTZ8C+wp+Xns+GZY9xn/sQzwcw1?=
 =?us-ascii?Q?5WB04+GELv1Vch0iiwn7m0nm0g/ZJzOVKrHxCTwWPpUl048HhoTkN+fsyaxY?=
 =?us-ascii?Q?6usjGM8ZMCjv7NkBg6k7QWzoafAis2dG8jxR8D/23Mxrr4KS31FyF8IZ9gzD?=
 =?us-ascii?Q?sbLGaC2QBZcFZQbl8KFy07eobhFJ1iw8ZP952VbF8bHOdW84NYAT1lBgc6B+?=
 =?us-ascii?Q?fN+1v6uRR49oSa0MDe1mG4fWweQHhINl7rOaBYHUAXXj1xgtzw1n22x+bQkj?=
 =?us-ascii?Q?ig+aZlzxL471yA1arIxaE03OR8cEm4VyRcCcQwtTGaPDKZrn1DL+hToSrlcv?=
 =?us-ascii?Q?zMPwRo1rdlAujDcT/bDsJ015Ae1q8L06C6ocQwcmZXS+3AlvfCoL9gVCt1c0?=
 =?us-ascii?Q?NGcdSstloLjsQ/CIBrO98KtLKRO7DAJcPj0bkBaru4IUG8h5RfzYwQupB1V8?=
 =?us-ascii?Q?cn7gnwtq3+hYGezIoetcKbAGtsRBuVaMWKFNuGiqy/wtNzK30D6pO3hA46T7?=
 =?us-ascii?Q?eKLUywsevR25LDRgQJ10TG9O5pFkX68mH2muDlBZ/8cdmfxHwXb5yIYtq+Im?=
 =?us-ascii?Q?fS5ZnZRzHZqv0TUlWP/lOMNfsaa0PA+IPCKN0dsq04NwF7xuJE/68fMOi5F/?=
 =?us-ascii?Q?SSeDjlCn0E/1fxJMxOrYCwdsTTcDq3HfwJVfWa1emisEttLTnaHMox99SaeZ?=
 =?us-ascii?Q?DR3l0a2ekc7mhQwLzrHeJWFSR35B4KOTMNSj1h57LL2WbTmw4PI+VKC2/VXy?=
 =?us-ascii?Q?/SiSSAX+zHCnGr7dxJJpVcvSs8LmyGB48lqp/T/0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3647c32e-6021-4ea3-6331-08db71405db3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 03:42:26.8736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JzeVckbxVXEcZVN6dAu8rXzHa/oLvcUUW1ohgKDK0kwlmUCqdsDZKdnUAGm2/yRomP8YEcSIFcx3py2HVuc/Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7409
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 20, 2023 at 10:42:57AM +0800, Chao Gao wrote:
> >
> >diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >index 0ecf4be2c6af..c1e93678cea4 100644
> >--- a/arch/x86/kvm/vmx/vmx.c
> >+++ b/arch/x86/kvm/vmx/vmx.c
> >@@ -7548,8 +7548,6 @@ static int vmx_vm_init(struct kvm *kvm)
> > 
> > static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> > {
> >-	u8 cache;
> >-
> > 	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
> > 	 * memory aliases with conflicting memory types and sometimes MCEs.
> > 	 * We have to be careful as to what are honored and when.
> >@@ -7576,11 +7574,10 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> > 
> > 	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
> > 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
> >-			cache = MTRR_TYPE_WRBACK;
> >+			return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
> 
> Shouldn't KVM honor guest MTRRs as well? i.e., as if CR0.CD isn't set.

I proposed to return guest mtrr type when CR0.CD=1.
https://lore.kernel.org/all/ZHDZpHYQhPtkNnQe@google.com/

Sean rejected it because before guest MTRR is first time enabled, we
have to return WB with the quirk, otherwise the VM bootup will be super
slow.
Or maybe we can return WB when guest MTRR is not enabled and guest MTRR
type when guest MTRR is anabled to woraround it. e.g.

if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
	{
		cache = !mtrr_is_enabled(mtrr_state) ? MTRR_TYPE_WRBACK :
		kvm_mtrr_get_guest_memory_type(vcpu, gfn);
		return cache << VMX_EPT_MT_EPTE_SHIFT;
	}
	...
}

But Sean does not like piling too much on top of the quirk and I think it is right
to keep the quirk simple.

"In short, I am steadfastly against any change that piles more arbitrary behavior
functional behavior on top of the quirk, especially when that behavior relies on
heuristics to try and guess what the guest is doing."

> 
> > 		else
> >-			cache = MTRR_TYPE_UNCACHABLE;
> >-
> >-		return (cache << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> >+			return (MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT) |
> >+				VMX_EPT_IPAT_BIT;
> > 	}
> > 
> > 	return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
> >-- 
> >2.17.1
> >
