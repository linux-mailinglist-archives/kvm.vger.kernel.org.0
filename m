Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3824624C31
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 21:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbiKJUxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 15:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiKJUxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 15:53:40 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E881FFAB;
        Thu, 10 Nov 2022 12:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668113619; x=1699649619;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Oohw92gUOrvwQN02hNjSIZbGs3hnMANOhSlb+BLQgL4=;
  b=SZgyVvYGwEMNV7Q2S5bTS+7AGpBUN+o2HuxNNuO9MUSlWm39JOBTbyqZ
   EXm8w1Cj0FPpA9Xc2sbNQ4GfxLGvhjtOY3DMc2bkFB4td7TQDbc479iO+
   oOiYmptFScTmM6i6Rgpz8WuAFedpMnLfq0jN/rkQHUVszzA+9u3wzwGHS
   yuYpndbFZtdbesnM0jGBrRf+ZyFt25050sdo6I3PE5AWSzgSshyhkrRgX
   vfjXeKUy2zn0G4xZcKF2Hm0vn8av9PiCKDUIl+6CzcJR6Szph2O6xsQL9
   HA6EJoTjghl1CVE8oT2FfQVwRVAMC2LtJYdU0NITNKS6biDyvX7kmaGO0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="375693947"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="375693947"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 12:53:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="762431907"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="762431907"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 10 Nov 2022 12:53:38 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 12:53:38 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 12:53:38 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 12:53:38 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 12:53:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2UXaZSjj4k2kbRRJIyR61Z2INUx9DeDqU49q3WPxD9FZl25InCMvrPXWvvrGR76Bs0w9nvHPGWxgVVkbn0rnK0N1Dk1FMjgLjPziDOHQkWOlHRFzIhJgKoBnNzmbvg+9dJ8wk4Nj5JELjBDNVz07bqo2yRfn1YG+vfNRmQfQs2brvbNN09HUd4gXaDZezzmc21WQzRdnFx6iX5InYOgERH2vHpB8zikbJpfhKmpzSWuWF63rj0P552+O2TdR0MlWnrn9bUSbbbbQF1nEmyz8pwkd7Go0dTmyX7ibSOaAHnZu7kzSat+7yH8c3sTpQ49/ySbGlK2iGPWvjOzmmV46Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRvmZCzDMSw0G5Sl7lQZsL13lbMdXRFIAqNUhe9teBA=;
 b=RmGuK3Yavi8JQxM4AcfyH8BRovn0qPTopnXj1rkeVBUkRyz/ryoMCCetpdgLMVPS2lnRve4cXrLBJ4dAjaOXsZ+yAGtERFCmEprpqLBvCrvs5k9fmoMcCLSQ33hzOhlVJGJEpHKC8ZEwaBt2SeAe2gRj3fgvex3HkJlC9vSRHCP5OjZr3VaogvRYiEDW7xrWvl/hkVGPUuZVjxfJxCYpfe/YEBacfOdBIf5MGiEHkx+dcd6sO7iBr7FMdmpXcC8QmfyNMzv4dST3N+ATb3su4jH8/8bdQc8GEN85hA5l0bX0/ZEIVUA0jLuJQcP1MWXQRddUfcdn+8WLAsSCCqiVMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by CY5PR11MB6162.namprd11.prod.outlook.com
 (2603:10b6:930:29::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Thu, 10 Nov
 2022 20:53:30 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5813.013; Thu, 10 Nov
 2022 20:53:30 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Topic: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Index: AQHY9M9YytlyKV7ob0GK/oJbeBhPY6433PwAgACmfxA=
Date:   Thu, 10 Nov 2022 20:53:30 +0000
Message-ID: <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-6-xin3.li@intel.com>
 <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net>
In-Reply-To: <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|CY5PR11MB6162:EE_
x-ms-office365-filtering-correlation-id: e13389eb-d1e8-47ad-79c1-08dac35d9f8d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZAshlkchuo6jUOc5NcN75jO38VVFUH09r/c/e2NSNQ4uMjYJb8r7PRY87j+1QUMLi14wujYWGB3s0m0gDmKOT0Q8PMqjWNNRQftqkzzDvK2LaOV+Eh/48hKD6F2eiRcnlW4RSVfZUHtqKZD9GdiQtYVbTKL1AXL5Tjb5Mu/kg/A9r4Pn4lMJJjNgKtQpRZGrg5nK91sAE9Az8MvQ5lmkcQlYjrj15lfABFEnrlozWNS61AQqxEcJ0ykJ9FY4qqyFfxgzAmVeP45y/f3vIkdDYTS6q12HQYICT0OoZvBOrXrio7dK/CfmWxQjaYxwGP4va9Eu0VUUPo3IYa+0j/TVoYTIlOmbrA+nwKxwOiR8zMuTtb5VQsRWUM6ruFqzxU99a1o6zXLPPaIlpxzy1lyAt76HhjQqvbExkHUDmCJMI3eQgPhudhZL0oADrwi54NadG1aTRWkrWqoFLkd4s1dV7A6wSiX+xtMSRciFoHc6NxUckhdJ2EpM/wuqWgMnywDCZDe1disaLKHnQHHZgLWALmv3wRe0YC547oiBEAawrvDiiW/GsFy2YxYT+YFXmSfm6OULpVcfQDDyfvhaenz05vefZ6tstCDr4n3wFeddsXuNJI+Ho3gvolsKoPqpbBG5qsr7qjUScYTCY5c7hTZhLe18yNNeUav2jgerwV+AHUvnAGBkoyWfcZU+9Pkfk+VjYeFh4tfmo2SXV9rHf0SqWXSTYGKZxmuu/DvDEHlycYsib00SxW5V3UG21XedXkB3WlO4wyLuPWDTA+ce2z7ULw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(376002)(346002)(136003)(451199015)(66446008)(316002)(66556008)(54906003)(6916009)(66946007)(66476007)(52536014)(8936002)(4326008)(41300700001)(8676002)(64756008)(82960400001)(76116006)(38100700002)(86362001)(5660300002)(33656002)(38070700005)(83380400001)(122000001)(55016003)(478600001)(7696005)(9686003)(71200400001)(6506007)(26005)(7416002)(186003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nhp6Enmg6dmIJqQMDYUx6CvAjopgGVzxc3Jj4pW1C4usRzMhMsPwzhArzk9n?=
 =?us-ascii?Q?MAjRZH1a4RC3TWPGBwiYpVLm0dALeQD60PEtAqThcXmuIq6AnXqm0qcLOiW3?=
 =?us-ascii?Q?NndjbbMfzzPnHjSS8/ZKp3fB5ou/GN8CKCNrwStZ47+U/5ArFKseAyRMsQFb?=
 =?us-ascii?Q?bJVICURFX6ab/mmwZhusFWJvSdaiUnW7ul2EiQH1Fgr/74zEoz4RJNSKMU8M?=
 =?us-ascii?Q?DcumvjM0TiuJ47L8bMk1dgNIFYjcvwZftVNFp51uBL5UqgGVAOeDOT7/GQbP?=
 =?us-ascii?Q?ol3HVls2epOL2Sgyq2r5rONbaKE9aZq/o985K/89cEj0cVp7RqSqir3rrQ8p?=
 =?us-ascii?Q?xR8wNI2e96GYjc9+318YAwvyzFfnAu+ZzfuPDKr7Sso2ta6qMNX5TrGqc+Cb?=
 =?us-ascii?Q?ymt1xE4VCcq98bLV5y2mcaM8fHvj2eoYecLfFCpKGMhv7Nh1myWxCFn/krQc?=
 =?us-ascii?Q?WOWlUfMAeNntAMATonzNcTlY81VTp6swBYEisgRElkv2mhAQwrdMpZVeKEbg?=
 =?us-ascii?Q?H7bQMWuST2tKXYbGob9lGXaXc4MT48jwdznw2FkHd4f4QDDYuvIzwLO/np4E?=
 =?us-ascii?Q?Oi8Hk/yJ+7M9V2KNfJ1fWBfn5CsCJF8EXwNwRMDLsCtwGfYnjbPMQYMqXBc2?=
 =?us-ascii?Q?jgGUJV+DpXzLJImNIsIXM+kbPL0DTC+dzHQIjw/8ixQ4++RVvt/t/w3BLTKF?=
 =?us-ascii?Q?mosr4yGFtHSibWBizRqqQqNGZDjhFLaxDXmwTR4qRMKzKlp1QbR9jJadri0N?=
 =?us-ascii?Q?6M2hvvBS5CBcuQ09SwE4VUntzduysxrBSQR/tSU6arV/ujp9FYgPpKBGjMuW?=
 =?us-ascii?Q?sTlPCvRqxYwzC55IsKNvFqq+lpd/2/IgXrw7J85brk3T01TaqcBolrkcPMCU?=
 =?us-ascii?Q?XvKJK2/sfEN1+7lnynvMT1fgbvzLPofn46JPynP2jGrBFppkMx4ANKt89eQa?=
 =?us-ascii?Q?aBhrn7KQVl8KJ5OraIqQPZxnKOM4MAg34Xgmn61RCZIYl0HdkHyadRHWXErA?=
 =?us-ascii?Q?kOAjynVl7yzxCOHwrsH0mQcndWAv+J1+GDFEtgmNhyhhjm2UTpZvG1GWTg+6?=
 =?us-ascii?Q?mqY9k+lKQ0PJXbVmc6BMm/AbUAQ6PIfRQcvE+/04njwyldhe/coxB+MrK8o2?=
 =?us-ascii?Q?b3cKLh5imWTQLTcTXpNTsxxbLb8eKGFobuqjPwhgfVlgpciCfU372ErIUvPa?=
 =?us-ascii?Q?IoM7YYSNY17VWUGwQVzOiMOFvL4kMWpkXTEcDf7XCxdyjYlOeElzCV7JIES/?=
 =?us-ascii?Q?c9AqM54SIOv+mw1+CZ8+JOVGW3qPnua/2E223ETE65xka1EPXq1iiTK2DjzM?=
 =?us-ascii?Q?5PfmG92RLQDOUbwJcyzKloBJCyKNuXocs6kaOSotfK8SO3hcVnL8S9W2VLi+?=
 =?us-ascii?Q?O1qZu9iSeTz5BgnEkEl3ruz2trVKyqDouxFbaTpeQsZ0CVO/Q3MLhAHPbVJo?=
 =?us-ascii?Q?+jnvejq/90XVzycCUd4dDOe/KdXxlE/VOOVx8N3S9KCG6Hju1NyPT+Wls+B/?=
 =?us-ascii?Q?Z6Gbytxaq5FUXpIJ/9bfuCWypkSJh6mtdYG4pNy5IyGwM3r1mqyA2Cxfwda1?=
 =?us-ascii?Q?2pVvyNuy9BpSVC2s8DM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e13389eb-d1e8-47ad-79c1-08dac35d9f8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 20:53:30.2257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AbjhiAA95iZzjBjKT48Xkp82RmUgjK/ZVrSmuFzNxORk+oPvCQkCxJVzdelHzJ5iWwCRqBr63AyeR7bNjFXefw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6162
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > To eliminate dispatching NMI/IRQ through the IDT, add
> > kvm_vmx_reinject_nmi_irq(), which calls external_interrupt() for IRQ
> > reinjection.
> >
> > Lastly replace calling a NMI/IRQ handler in an IDT descriptor with
> > calling kvm_vmx_reinject_nmi_irq().
> >
> > Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> > Signed-off-by: Xin Li <xin3.li@intel.com>
>=20
> Idem.
>=20
>=20
> > +#if IS_ENABLED(CONFIG_KVM_INTEL)
> > +/*
> > + * KVM VMX reinjects NMI/IRQ on its current stack, it's a sync
> > + * call thus the values in the pt_regs structure are not used in
> > + * executing NMI/IRQ handlers, except cs.RPL and flags.IF, which
> > + * are both always 0 in the VMX NMI/IRQ reinjection context. Thus
> > + * we simply allocate a zeroed pt_regs structure on current stack
> > + * to call external_interrupt().
> > + */
> > +void kvm_vmx_reinject_nmi_irq(u32 vector)
>=20
> noinstr ?

Seems it's not needed to me.

>=20
> > +{
> > +	struct pt_regs irq_regs;
> > +
> > +	memset(&irq_regs, 0, sizeof(irq_regs));
> > +
> > +	if (vector =3D=3D NMI_VECTOR)
> > +		return exc_nmi(&irq_regs);
> > +
> > +	external_interrupt(&irq_regs, vector); }
> > +EXPORT_SYMBOL_GPL(kvm_vmx_reinject_nmi_irq);
> > +#endif
>=20
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
> > 63247c57c72c..b457e4888468 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -46,6 +46,7 @@
> >  #include <asm/mshyperv.h>
> >  #include <asm/mwait.h>
> >  #include <asm/spec-ctrl.h>
> > +#include <asm/traps.h>
> >  #include <asm/virtext.h>
> >  #include <asm/vmx.h>
> >
> > @@ -6758,15 +6759,11 @@ static void vmx_apicv_post_state_restore(struct
> kvm_vcpu *vcpu)
> >  	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));  }
> >
> > -void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
> > -
> > -static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
> > -					unsigned long entry)
> > +static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32
> > +vector)
> >  {
> > -	bool is_nmi =3D entry =3D=3D (unsigned long)asm_exc_nmi_noist;
> > -
> > -	kvm_before_interrupt(vcpu, is_nmi ? KVM_HANDLING_NMI :
> KVM_HANDLING_IRQ);
> > -	vmx_do_interrupt_nmi_irqoff(entry);
> > +	kvm_before_interrupt(vcpu, vector =3D=3D NMI_VECTOR ?
> > +				   KVM_HANDLING_NMI :
> KVM_HANDLING_IRQ);
> > +	kvm_vmx_reinject_nmi_irq(vector);
> >  	kvm_after_interrupt(vcpu);
> >  }
> >
> > @@ -6792,7 +6789,6 @@ static void handle_nm_fault_irqoff(struct
> > kvm_vcpu *vcpu)
> >
> >  static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)  {
> > -	const unsigned long nmi_entry =3D (unsigned long)asm_exc_nmi_noist;
> >  	u32 intr_info =3D vmx_get_intr_info(&vmx->vcpu);
> >
> >  	/* if exit due to PF check for async PF */ @@ -6806,20 +6802,19 @@
> > static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
> >  		kvm_machine_check();
> >  	/* We need to handle NMIs before interrupts are enabled */
> >  	else if (is_nmi(intr_info))
> > -		handle_interrupt_nmi_irqoff(&vmx->vcpu, nmi_entry);
> > +		handle_interrupt_nmi_irqoff(&vmx->vcpu, NMI_VECTOR);
> >  }
> >
> >  static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
> > {
> >  	u32 intr_info =3D vmx_get_intr_info(vcpu);
> >  	unsigned int vector =3D intr_info & INTR_INFO_VECTOR_MASK;
> > -	gate_desc *desc =3D (gate_desc *)host_idt_base + vector;
> >
> >  	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
> >  	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
> >  		return;
> >
> > -	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
> > +	handle_interrupt_nmi_irqoff(vcpu, vector);
> >  	vcpu->arch.at_instruction_boundary =3D true;  }
>=20
> How does any of this work? You're calling into entry/noinstr code from a
> random context.

Can you please elaborate your concern a bit more?

We are here in handle_external_interrupt_irqoff () because an external
interrupt happened when a guest was running and the CPU vm-exits to host
to dispatch to the IRQ handler with IRQ disabled.

