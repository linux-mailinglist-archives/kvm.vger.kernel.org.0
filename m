Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C70F64D56F
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 04:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiLODG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 22:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiLODGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 22:06:54 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170D0511C1;
        Wed, 14 Dec 2022 19:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671073613; x=1702609613;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3P2PAmFIbEif+roxRvfmgBA2W+2Tvo14LTdN6yhn4WI=;
  b=UqXhEoA9UPTpk4e81U0DaDaLR5WKwoCjGddQsNL5BVPtcCc2MHRPKVsP
   H4yCtybOhgXzSXhJDZB4GtZF49cUM8hOZ0U0lv4oF0AgSv3cuB8+6DCF9
   buExuGDaeA9iPVm7JVMR6QU1P0RKNxsf+FvJ0OZ2Dcup3/4LDZMGDh5Jx
   ah1tm+cxrFqH+QjF4LBdq/o5cyUJvBm1G8PoKG5i8LusVm73OfQvAgveD
   zddjoxvTfiT7eAwRxlYtu/IkdQn6JiS3+p4OtSoJFinZPPc2GGSgR+3Y4
   adtfH2Nrt2zpcyOCDMkNf7CeS5hmBO8FVCI/BI26FhmLrDkIYp5Y+wpoX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="298248210"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="298248210"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 19:06:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="756164940"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="756164940"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 14 Dec 2022 19:06:42 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 19:06:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 19:06:41 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 19:06:41 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 14 Dec 2022 19:06:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brU8lbd+ildlaIluZtlDoeK4qCsEhDtAxdQ34Q45lR31QQPMYi9i5umECUAbIHEaExi9AoO0uAFkuha7236y4T9mXVN+9MVamXQlNECliBsvSJkK/LHXTgo26ZS2Z+W25RywCZCT1GodZswfo8y+JpQT2I+62/3vFFy1Ak7gWArl8h02QmKzOlxTuiqATTRKSOxL/g4497NdHnD6pofCRJtNHY2VXFP22TlYH1tgP6dFN5coZp3oQPtYCgSNEnfLxZU04GBnOzGIPeDLLrKaPHgtGofXP+Tj87LXXudwEnEab59mzlZsGpGil2xkKLK1hXs52XR2XGICFKAVfMXmjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q+3GM3PAP0UU+CZPaD0/nRWD465SYEcyKsKUfJc8xyQ=;
 b=Pb/dH0WoHkJZZ7J/3ovjDVY2AXxeNc75EUnzdZhZ+mVTqYr7oy3uxi7My8ZbHyeLEKNZxpbEzGse5vuKfxdm7n/Fallp3XiSJL1mXDoW3xYsqR/EAYcEkPmyUUfaL6RQ3FORHenNoydj83+G9q8u/qzGCeE+kA6BPJrCGlg/7EZmNaHGzke2/7jcvcjY3wF55nbUrBpa0Ts3LxNJXvDa68fPz0rKdjt83vuQWrpzyijMhRvdsWU9sVkwR/F/R1KjFAG9NH+t5eYUfQ77DCWcM3AdEgcqJ/5Xm+SwPIBzsk+8ihAk3Ch0MlKlVPmvYYNqHcBW+uOMqsIPGuI3te0n9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by SN7PR11MB6899.namprd11.prod.outlook.com
 (2603:10b6:806:2a7::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 03:06:39 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::5cbf:a669:456c:e130]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::5cbf:a669:456c:e130%6]) with mapi id 15.20.5924.011; Thu, 15 Dec 2022
 03:06:39 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Lutomirski, Andy" <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [PATCH 6/7] KVM: VMX: Provide separate subroutines for invoking
 NMI vs. IRQ handlers
Thread-Topic: [PATCH 6/7] KVM: VMX: Provide separate subroutines for invoking
 NMI vs. IRQ handlers
Thread-Index: AQHZDrmN5sCXvT6vVk+HmM53wIVCP65t5D5wgAA2KgCAACvJIA==
Date:   Thu, 15 Dec 2022 03:06:39 +0000
Message-ID: <BN6PR1101MB2161646D0E7FF2ABCAFD4177A8E19@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221213060912.654668-1-seanjc@google.com>
 <20221213060912.654668-7-seanjc@google.com>
 <BN6PR1101MB2161B2CB247273CDD85F4C19A8E09@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y5ppzEEqFB1XqhoJ@google.com>
In-Reply-To: <Y5ppzEEqFB1XqhoJ@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|SN7PR11MB6899:EE_
x-ms-office365-filtering-correlation-id: 6ceb91f2-84a0-4a6b-10ba-08dade496274
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yC3BsBLtyPzcfAHaznIWCrMxsVzRhN4x0k2h4qGMBkZA/n6R6MhkW43oRWwC9LTyzGvKQRieYqeAJnRJGzK/HGY5vnzKHWxLCGwiZ9r89bX62/Wr7VrdR0MJGZExiELay3yjdaDF0E+DjuG9L68MkGdqa6jtULMp/dtIJYp1hbFX+aUTkTBRkZOuAdBApIJvFeWAxsouwYjafSu/ZrPUXjH9Kv3K6ggfzAR6kXga1msR1ENzZY0Hdr5W65B0lzGkdCV69a7ELCIG/Y+WxMceObR+vJ6HrLVWCUb8x0Y90fWTwh8//BbBAbSDjmlqocxeKzoyEdCA8SW6ui9f2NX0iMoXYItmPefPVCvZBUdNGm+SChNPr7QhulhZ8IMkZ6c+6ouWKiYO0riEHqRvget1ctk48jMJopLAfBEwAFQPFiIlMS1KR2PUDFKGfP0J9WbIJX2+wQ3g+U1AmxBM4BsjwmnZ1fTSBHypXJPIqLopUUO2ncrp+txZ4h/xkpzTZzdB3wrVLzNGVTGCH7wJYcWnV8F8b/qnbTa4cAa+sQvUSloaqw3/rvAOLbQJn5pLD7DeEtXVPLFtoDaQeODvIBVGQwE/YqANb5lNGPsO0+wq/xn6qZ3yowFR5AfnDatnEgTiV6U+Hg0dsWYBp8ZJA8hGUwlrbR6S9q0xtynk4xVJ7uVbNz1G1F2fxN2TjkPUaiBrtST4Q27wNmaahcGyErarEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(39860400002)(366004)(376002)(346002)(451199015)(4744005)(4326008)(8676002)(8936002)(66446008)(52536014)(66476007)(66556008)(76116006)(5660300002)(66946007)(64756008)(2906002)(54906003)(316002)(41300700001)(186003)(478600001)(82960400001)(6916009)(7696005)(6506007)(71200400001)(26005)(9686003)(83380400001)(33656002)(55016003)(86362001)(122000001)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VI3vpTFkbjdp1ra6I4IPMeIMY0BpLeT4yi/P+U5rhZy+Z7jH8/XfoXWVJn5h?=
 =?us-ascii?Q?2audCxhC+q+JoXFDnJsvs4nKZUsPRfRPrfLagcZJSQtyqTnuFL0hmdsY9DAn?=
 =?us-ascii?Q?t1AnDV2OOayZcgHP/7MSTzcM2vOQpOtiVQlDsRk3SpGvFMh7a/NahBRUkXMs?=
 =?us-ascii?Q?E7RkRuDw2sgQaQCMbfHw3SYWkDj+7HyJ8FJCZi4jPNFpIq7+S9oMX4UAur6s?=
 =?us-ascii?Q?UOVHgRtHr3ZI3l/0WqtCErOJ+g/1tM7jAVmutkb/7F63QzXi1PdBz67RC4rR?=
 =?us-ascii?Q?llt8J0Li3WCUEwPIYdFoMHX67wGw/s09NiECIqj03qID5BYbd5XIg7ijdESp?=
 =?us-ascii?Q?PujZ2KYbybRTg7Oep+LE61sl3gSLsPmGgm9RPbpZoKDjoYKf3mTpNtPCRNg4?=
 =?us-ascii?Q?bDzjKuJ5jP25JLnSSjTvoK9ZaoblqYc2ZkQ/4vvgfLgNIu5fPLswoxu3amK0?=
 =?us-ascii?Q?B92Pr3isrenxwmDIALuWJpRibUCveKkWtyURD66eYDNrDxtsQbINJ8srsEf7?=
 =?us-ascii?Q?PWYgdmX4TQSYE7x4UYelNK8ab3m85jCwXcEt5xesOGmdVPwnslIaiwJEXiVg?=
 =?us-ascii?Q?/dGo4Zw4umn6ylqi2NiuQ1SS8i0snQV3rZ1mczxd7/Rm40ZWzIdr2xZjQm+X?=
 =?us-ascii?Q?1Az+xn2gySNJjxbR51l00SFP9FmDQUisQRrMYQoxVysXfuOv80PMS31k2vaU?=
 =?us-ascii?Q?27wfbsuyFZA5v0znIwK/b8Y/adymXy+860jOZx4H/IYJxZannl9qypKpY5ln?=
 =?us-ascii?Q?pfL2jzFYi8fBjtn5p5Me/g1udKB0WnFQAPkhYl4GLlzSHCo6jPcX0L+L3eno?=
 =?us-ascii?Q?HtmKJAzjnj1zi03QqrS1/pIOqMZFM9UsIfy3jJvQJP4t9pT+MagVD1oioi10?=
 =?us-ascii?Q?4S31G3CUgW6PobSanmReyqmJifbpTyOXXjUSZeNoY6imjBRri5NYZkK6OQcR?=
 =?us-ascii?Q?SUWCdHjnaZq8UV60Pc9/NgM41Z5ESikqXa+t5HVwmabEDNdLcPTTZXe890ro?=
 =?us-ascii?Q?Dm73ehNagUruA8v0RWEv8XsXh0/pw1yhGeOyvrE3ftd9BObYrHGeNgnbfteR?=
 =?us-ascii?Q?lAgwlLJS6khj0FQbfTSwPredLz+pi6kS/+T4GqqEzQoqUW5OWUTHCt8QW0R1?=
 =?us-ascii?Q?t5WBKfcOfMc4rAu7IPNsrw0Afdz48VgNvqPQSW4aDmbaVLNaMhiJ+32L3YuT?=
 =?us-ascii?Q?vEm4P1gRqAWTfSi8r5ofBRVd8kGTVNiBdKz53QL6Kc5ZCb01J9ICo2vXcTP7?=
 =?us-ascii?Q?ar5n9GCYRKjAzYsXHw/TKbzG39HMzpGj7QmAwNKAl41Y6Is3NDauobMZnmXI?=
 =?us-ascii?Q?HYrSAjpS5vm7X0jU3yNyci+rSFbTllI1+1uCieNQod1FiBq7eLHJ+fVv7FpD?=
 =?us-ascii?Q?g5OOlZ0GukM/8pdYpdgP78iBqbuYauyb+jOvy9C14D289h2YUf8nD/xu00Oc?=
 =?us-ascii?Q?eOccmcqF4k23WPCFnBVCnC+CjvXb4wbch2irvc0x4OxtirAzcAFAmGPw1ust?=
 =?us-ascii?Q?IBcZl7Vk1y1blEobjeXDnMTjkDqXLBMA5X60/CSWKVkLf521mtjTZapAtsTv?=
 =?us-ascii?Q?c/LUHlDgkz6Zz56qlEhMCbbXCr3NXM6VQKHYE8Ob?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ceb91f2-84a0-4a6b-10ba-08dade496274
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 03:06:39.1786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wEw/pA/df8zTXzr/RcwbeDtF2G/s1/3n89NGbnZ4JS1OwEoxeEZje9RaZmBShiEIa3TKHUvNsXq+u66Oul8DiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6899
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > +	 * "Restore" RSP from RBP, even though IRET has already unwound
> > > RSP to
> > > +	 * the correct value.  objtool doesn't know the callee will IRET an=
d,
> > > +	 * without the explicit restore, thinks the stack is getting wallop=
ed.
> > > +	 * Using an unwind hint is problematic due to x86-64's dynamic
> > > alignment.
> > > +	 */
> > > +	mov %_ASM_BP, %_ASM_SP
> > > +	pop %_ASM_BP
> > > +	RET
> >
> > For NMI, after this RET instruction, we continue to block NMIs. IRET
> instead?
>=20
> No, IRET has already been done by the kernel-provided handler, e.g.
> asm_exc_nmi_kvm_vmx()
> by way of error_return().  That's why the CALL above (that got snipped) i=
s
> preceded
> by the creation of a synthetic NMI/IRQ stack frame: the target returns fr=
om
> the CALL
> via IRET, not RET.


You're right, this assembly makes another call into the asm entry point, wh=
ich
returns here with IRET.
