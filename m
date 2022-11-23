Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F346352B4
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 09:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236591AbiKWIcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 03:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236585AbiKWIb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 03:31:59 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F79312D2E;
        Wed, 23 Nov 2022 00:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669192318; x=1700728318;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W3Fe7nsAuRSQygS3JrO06wpS2F4SroInX1Xn55ARyiA=;
  b=l48k/a2xwbi1aCJ/IJdhbMEFAQAAiJPz5XvrqsGFJIYiTIJ2QSGgLoyo
   Lt6QYAMC7Jx8/GVAmoDjRJv747aSV+7XxgUyHwLPZ/j28Plgns4//b6vT
   KwGbguTvELOKDKfZdSo0ktrgUFt3aME0dNghrVrf6avEswJmoZSBgAsre
   lH4Q87H1z9yfaBxoXvLmPYnuCQjZlr1tgN1a90G7HTJnfQ6AcJAmz1vn1
   lyZTwaQGiiiH0SkV5sS+SNt3z0Ijs07RORmcOo2nla/79O27xP2kueMNq
   NRyeahs4hD5xselCfDzcx5Iv9d1bLqr5KgnepAJ6DDkXkUptVYAda0Ace
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="311642444"
X-IronPort-AV: E=Sophos;i="5.96,186,1665471600"; 
   d="scan'208";a="311642444"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 00:31:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="592440160"
X-IronPort-AV: E=Sophos;i="5.96,186,1665471600"; 
   d="scan'208";a="592440160"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 23 Nov 2022 00:31:57 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 00:31:57 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 00:31:56 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 00:31:56 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 00:31:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZL/b9XiuybwCfVmVTIvCh7H6gn2EVX4ANjsaYDQ9FbSSV/ByLBPwi/zFj+vXRe+v05pjGVQgBJSqUdExhCDTH+haHd85vzdvx0fJr8QieLVfw3fqBM3OVbiix/QoVFAQbdPN6PxZa342xzLipRz68TE2HdQR39rp6FH4SQ06q7q3BDp69i56CcntMFWQaXMHbS40RLKH/ubEyrGsMAlzTna71BYnM1Vg3OReigoOIy/0N3v1GkZ1deluiJTPZGkK2ljFxRyBWNzLq1ffceNxP8XCZzM9LckQiQsJlQTup1bhXJnP7czb3lSYWuxhwUqVj3DAWVmKldnilVmHVtPWHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enis6bpc+WfDUlIItqplYC/vdVLhUvMDEPFHsmrl9WQ=;
 b=CM9cvx5ZMr00uK99bO74m7Y6UXC0onivMcyyMtmbrc4sIQ0ZWmUimCBxHJi50blA8A1/IhXv0Lsxeiistg/nknwzC8w7sJq/XHHRz0rn4H2+106xo7/U/K8WwOdcpMhpYu6RD1rhG524jL03GoHNto35b7TH6b4wF2Ar0r5NVzhUwC8sAGKVXv2CAnbehTdp6gCFWJv5QwjpB9a6/YI/sPS87ofebTv18blUqE3AFgMU/ogpnMdjGCaY59KYP8LppiAhJQLRozwyXVqBOYW768LSeO7JfiEY2ExNF/YalnkqlO+iV8sI7JtYfVR52RzW/rrDQ2qUNXlg0Hqs1FCajw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by MN2PR11MB4583.namprd11.prod.outlook.com
 (2603:10b6:208:26a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Wed, 23 Nov
 2022 08:31:52 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::3a39:ae82:41a0:6492]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::3a39:ae82:41a0:6492%11]) with mapi id 15.20.5857.017; Wed, 23 Nov
 2022 08:31:52 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Topic: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Index: AQHY9M9YytlyKV7ob0GK/oJbeBhPY6433PwAgACmfxCAAO8aAIAAL0qAgAAENoCAAAgUAIAAGnuAgAA1qHCAACERAIADuBAAgABQYICAAXpoEIAAGnIAgAK/reCAANL/AIAAhVlggAcl+kCAAIRtgIAAu8Mw
Date:   Wed, 23 Nov 2022 08:31:52 +0000
Message-ID: <BN6PR1101MB216162F44664713802201FAFA80C9@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <BN6PR1101MB216141A21353AB84CEA541DFA8009@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y26jkHfK9INwU7Yy@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161E8217F50D18C56E5864EA8059@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3IFo9NrAcYalBzM@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161299749E12D484DE9302BA8049@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3NZQBJugRt07udw@hirez.programming.kicks-ass.net>
 <DM5PR1101MB2172D7D7BC49255DB3752802A8069@DM5PR1101MB2172.namprd11.prod.outlook.com>
 <Y3ZYiKbJacmejY3K@google.com>
 <BN6PR1101MB21611347D37CF40403B974EDA8099@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <BN6PR1101MB2161FCA1989E3C6499192028A80D9@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y302kxLEhcp20d65@google.com>
In-Reply-To: <Y302kxLEhcp20d65@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|MN2PR11MB4583:EE_
x-ms-office365-filtering-correlation-id: 78d25f51-5fd3-4bc4-dd85-08dacd2d2c2f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6H6kE/P5ep0X9gFO/S8bjOhJVKgk0L23g8u3WUA2RN7apdj7j3pWEl4dk/sQchPVs0Cdg7yV4lGXd4g3KtQMRFpKF2ga/n5RpPg4DMCUIY3fNHmFcGxbxZ8skFysDd/NagE7ZTY6bSIJNiS/IBaIP3MdtItMFSWKLeP6fky6++tcb+mO8JRCW8V1cAT0c70CiDWpeTs+klsgKfuWFa9+ibOYLqo518tAq0DHcNiiA5y1pidab//g/t1hveALcwkwMfxlIZIl9tjyJKM7/t2RsePkUaouKfChTEuDS0+PCt83/pIbKcmYPd+A4upAZ+kcNeJVCbCvF2T/YgppDUlfMGgd91ieWuzLOaSRzQwC+GJJ/BfxVQXl1hUz1ynEvBLIm4JJmrpoKDn/h0m3WKTlwGi937BCPvrlR1sTTW3n8sJQSDR7qoMoeHLMjPOT4vWUNeXYrtqUVP5o0f3qChKgf4+Ca7m+r3iAGrklVX9kV+2LLyP4M8D4FndeK55Y+J+Ncn9WvlBx28+5Uun5fvR5fGZ/JXssrpUM0H4q53Anvp0gWG2twMiU/YLS3XM7jkJ4RdFixFdIQ/uoLHm8H9NHPiwnXVcg/Mk1i2NwKO1xUIibJ2SbxR4z65qBm4XA7iNL5Ff399a5auDxQUqPe8n2hhqhhCiqTbz10wymUs1x1JrUUxGlfOrLbNechdO+96PbJGJBlP11yEcWrnyfu2+qWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(376002)(39860400002)(136003)(451199015)(38070700005)(38100700002)(86362001)(82960400001)(55016003)(122000001)(83380400001)(2906002)(64756008)(54906003)(66446008)(8676002)(478600001)(6916009)(66556008)(316002)(76116006)(8936002)(7416002)(5660300002)(52536014)(41300700001)(4326008)(66476007)(66946007)(186003)(71200400001)(9686003)(7696005)(26005)(6506007)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9kcZqxFo2pvpx/aFtgu+Yae/Enfw1gcszriqQShUf0fVw+10101ArdnZcsA/?=
 =?us-ascii?Q?2FiFLyQ2oBGMo3q93/rdgcdj2p2L9CZlhAmBmDdtlWjvOVVcbeenDPjsFNaa?=
 =?us-ascii?Q?kA79pi4LlrCrvy2BAEqb6qLQ5/SvCWEzwFdesTUgyTs5n9min8g+wd6cMpXW?=
 =?us-ascii?Q?j9VyLKrw8bUgHXjbhHNsg/aGBuFbbHG8UIypqeL/qQpAGle1tt7bSAThuyfH?=
 =?us-ascii?Q?YclKYyt9KyYQGft/4SwtMmd2kW/MUiRHBJCceN/DRhpmjHyLf+phslJynmfO?=
 =?us-ascii?Q?uvhR7YDhDQgr8hbT28VpWQcOQ/psxqItcLFGXYmdsGZ+4/+35AdejLFbzAhz?=
 =?us-ascii?Q?Z+6egHbRjxeE7H6MltnGwiIJG3mg/qFthNcTcT1F/qlPPnOPdACdJeFuCmxe?=
 =?us-ascii?Q?gL6uy+GIco3uv1CmSRK1QlYUHwr9I1TYAJZHcgI1u5zuyCZE56rgBvlo0skI?=
 =?us-ascii?Q?QebcSWVSsNEuS1WybmJhAMy5sP+4mhtd5K7XmmMOzRKadOTXiu86humlbsLy?=
 =?us-ascii?Q?j6hEU5hybFHbFWh0evRdtszuiXGpijXfQktzqKz6TV9Sf/ILTokY/wtU37RB?=
 =?us-ascii?Q?BFZG8Y8odeTvuJ73OTiaMaSw/XpUBkLp7rLFo49+PkDl+g+iUHs5OucJLEVO?=
 =?us-ascii?Q?Q9/FOW83Iz1ZxC/KB3Mq9KY7GxTcJ3VLh2udsdzzu8b8aLwTZDD2vO3W33Fk?=
 =?us-ascii?Q?XV03Bhdk5Pi87IzeZIXQNhSZV5a51QuKxDytpWxPCv64laJXmmmVl5yA8UxH?=
 =?us-ascii?Q?Jq7MzYwlsvxSeoVUCoo0O7YRWVVklxwo2Owz2Pbvg1d4T6z9RBsG7Wcg/BiV?=
 =?us-ascii?Q?sVvelgsBrVMc2tzDNLn/FWCxwcVkA7yyM1ERYz81w2/KmPVxXpeKPogh964L?=
 =?us-ascii?Q?O9OXgZbJoNA3+07Xuv9LKouhKj00w4FuprqN0dgji1UywALrJU81IMYltyIh?=
 =?us-ascii?Q?UrufXtMhc33EAM0lDFn6WiV0eB3J7I0lWExe4TXbVOXDmbKrs/XYTl1EnQfA?=
 =?us-ascii?Q?ZT/w7dhbaGMR177wJwjtAahtydaGhkbsKWm+KfaORqhz1cOnCnabnLw8YAGi?=
 =?us-ascii?Q?JXL3706Pd73afCEd+QxAM7P+e9QPfayhMC/4xGUxtUoJYwfGHdwAlVROfeVO?=
 =?us-ascii?Q?fwUceyWsh88YtsvevjN2fHniD3d52beXBoRitksiRspkMdMmP26xIsPdd1Y8?=
 =?us-ascii?Q?xxdbBZbhfPS3mxgZ/+AF2l+NR0Alii/yJHIR3kSDFxG9adCdU3uVzSihMFVT?=
 =?us-ascii?Q?r0bSBRHadEB18BN/XTFlem10oncNf500s7jdFZ114KGbtbmBrxiGYaBv6ss2?=
 =?us-ascii?Q?DltQMw9CcnbfczaxGgGcIoslospdlMbavW2rrm5SuhE+uecVVV4nwHe4Kov4?=
 =?us-ascii?Q?VLYHSOtsG+VO+k+y+50Ramj4RyfgzVH+PcVDdFCjy4rQN7QMdTM1qj/S0w8x?=
 =?us-ascii?Q?jdr9yFcIcmGlhh5Lm94WdaB4nknrhy2jT1XVQxONyF0Hswq1KBnp+eabEpNJ?=
 =?us-ascii?Q?5VimENN4PnPlx9j3zBR0Gto28RLYKlaOjHKpg0/J5gxPSgL1GlSd5ABQi1FC?=
 =?us-ascii?Q?AiJAdfGVHAWrIa6Kr2w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d25f51-5fd3-4bc4-dd85-08dacd2d2c2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 08:31:52.4747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s1jIF9R00zy9+htTHd2TFVtMRj+eo/CWTQGpfCt6/1z4NoV4bvjif3cIcqdV5Cf1SJwLAxXfrIzwRkRuj5Zbew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4583
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > > > > > And yes, the current code appears to suffer the same defect=
.
> > > >
> > > > That defect isn't going to be fixed simply by changing how KVM
> > > > forwards NMIs though.  IIUC, _everything_ between VM-Exit and the
> > > > invocation of the NMI handler needs to be noinstr.  On VM-Exit due
> > > > to NMI, NMIs are blocked.  If a #BP/#DB/#PF occurs before KVM gets
> > > > to kvm_x86_handle_exit_irqoff(), the subsequent IRET will unblock
> > > > NMIs before the original NMI is serviced, i.e. a second NMI could
> > > > come in at anytime regardless of how KVM forwards the NMI to the
> kernel.
> > > >
> > > > Is there any way to solve this without tagging everything noinstr?
> > > > There is a metric shit ton of code between VM-Exit and the
> > > > handling of NMIs, and much of that code is common helpers.  It
> > > > might be possible to hoist NMI handler much earlier, though we'd
> > > > need to do a super thorough audit to ensure all necessary host stat=
e is
> restored.
> > >
> > > As NMI is the only vector with this potential issue, it sounds a
> > > good idea to only promote its handling.
> > >
> >
> > Hi Peter/Sean,
> >
> > I prefer to move _everything_ between VM-Exit and the invocation of
> > the NMI handler into the noinstr section in the next patch set, how do =
you
> think?
>=20
> That's likely going to be beyond painful and will have a _lot_ of collate=
ral
> damage in the sense that other paths will end up calling noinstr function=
 just
> because of VMX.  E.g. hw_breakpoint_restore(),
> fpu_sync_guest_vmexit_xfd_state(),
> kvm_get_apic_mode(), multiple static calls in KVM... the list goes on and=
 on
> and on.
>=20
> The ongoing maintenance for that would also be quite painful.

This is very complicated and I'm lost after reading the code around it.

Maybe some comments would help to explain the steps and order after VM exit=
.
(of course some people know it quite well)

>=20
> Actually, SVM already enables NMIs far earlier, which means the probabili=
ty of
> breaking something by moving NMI handling earlier is lower.  Not zero, as=
 I
> don't trust that SVM gets all the corner right, but definitely low.
>=20
> E.g. this should be doable

Do we need to recover *all* host states before switching to NMI stack and
handler?  if not what is the minimal set? If we restore the minimal set and
do "int $2" as early as possible, is it a quick and dirty approach?

>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
> cea8c07f5229..2fec93f38960 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7249,6 +7249,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu
> *vcpu)
>         if (unlikely(vmx->exit_reason.failed_vmentry))
>                 return EXIT_FASTPATH_NONE;
>=20
> +       <handle NMIs here>
> +
>         vmx->loaded_vmcs->launched =3D 1;
>=20
>         vmx_recover_nmi_blocking(vmx);
>=20
>=20
> thouh we'd like want a fair bit of refactoring so that all of vmx_vcpu_ru=
n() and
> svm_vcpu_run() don't need to be noinstr.

This sounds reasonable to me, however from Documentation/core-api/entry.rst=
,
we do need it. Maybe we could argue guest is logically orthogonal to host,
and the CPU is borrowed to another OS... (which also kind of explains neste=
d)=20

>=20
> Another wart that needs to be addressed is trace_kvm_exit().  IIRC, trace=
points
> must be outside of noinstr, though maybe I'm misremembering that.  And
> conversely, SVM doesn't trace exits that are handled in the fastpath.  Be=
st
> option is probably to move VMX's trace_kvm_exit() call to vmx_handle_exit=
(),
> and then figure out a common way to trace exits that are handled in the
> fastpath (which can reside outside of the noinstr section).
