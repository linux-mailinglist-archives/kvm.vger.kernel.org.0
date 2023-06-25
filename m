Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E31073CEC4
	for <lists+kvm@lfdr.de>; Sun, 25 Jun 2023 08:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjFYGyg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 02:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjFYGyf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 02:54:35 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865A9E56;
        Sat, 24 Jun 2023 23:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687676072; x=1719212072;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HAm8pqfrEUUrM6Mwlg4TDawpnHJBQESDEYNRffIo1Ys=;
  b=UjlSuj0AE+tLU2YJv0+r8a6CZbMrbGTPWmQRlhVetbR0dEL9KGFWEbBe
   /JXKmZ3e99aIBLS6rMcAYFFbn0igPZ+XJRBbc1/jnaO+Oi2F2r7GZDAg+
   Y9SE5nBLFrlRbwJsOXo3eEIr1EazB46Ml7p3ECIBh/YlTgUO5yGqw94iI
   4IrIwbCN6E5nBsmajiZnBN34P6NMM3Iv3sjfPyY2ESD5jjKD3rVqxqliD
   z5Y7uINC79LiRYq/PoYI6xaxDjAch3xg0xo3q6RZYTAXn8Rh3UOx64MhC
   jHN3y0Vrye9tJJfIwSKwTW7pCMcn0QofVNCN5goPFA7paR7LQzgVSlzJk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10751"; a="340625611"
X-IronPort-AV: E=Sophos;i="6.01,156,1684825200"; 
   d="scan'208";a="340625611"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2023 23:54:31 -0700
X-IronPort-AV: E=McAfee;i="6600,9927,10751"; a="750552633"
X-IronPort-AV: E=Sophos;i="6.01,156,1684825200"; 
   d="scan'208";a="750552633"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 24 Jun 2023 23:54:31 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 24 Jun 2023 23:54:31 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sat, 24 Jun 2023 23:54:30 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 24 Jun 2023 23:54:30 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 24 Jun 2023 23:54:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lyb45Vk0aPza6Nl8jr6jtpQE4ZAh8MXGXg5eUIFD/ZZXBEdEhyIhl7ixT/jSVrzdhaFvtOyp5H2QGE+wOzvEJoTPWCv4pl37Chm+YuBInU+rajvABGEKo9Af4FSK3PVideYriU+qJC0Ev6Oj4edkV9itILmXH1XdFDvRccgxqBp+W6J2xpEjZWJwgymJCJzVaX/iXrrwRrzd3gWE7C7IP2CZVcTy1CTdURzM9VidIYla31XdtGFGC3jLke8kWd2G5qzaiO735b4qIF4UyAtmo08rQRaLdiVj+KQg0X8acGtnTMNMkJ9QfwrfzsyyBNwgd5ZDV15Oimq5++OKl+XlhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RUupbyCKRY1N5VXt6pY0RktQX7TW2+UWvziMM6J3ZbE=;
 b=Y7qvhf8rdR87joU3edvVr53J7u8gJghCcA0N/ZVavPtHFsCPU0VaRATKdCvX1+B7O8meDUxAWtx1YWc1pIh7th252eKFEsLHxr7/1WYQF911JjWHlXUH76c7AYf0soNzpYFx4kqiq8SvZdZFUDzjy6YuMO0OY0hJLqDF7odRLCkZE22yOrJboUQg0WV7PLs73/FmDrJvCMxnKgUHG7s6LzoHT+3kf3KlUoqndZw6gHzOkHND3dB4UOH7VmWfPZtNCfmPvCdWi9HmsXJDUSRcrEn5rr7pAYD6+qIFzZQIVVr29ZQghcacpF1ycebjXY7BQdV5eHP9r0Y6j1lb8MzmSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19)
 by SA0PR11MB4528.namprd11.prod.outlook.com (2603:10b6:806:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Sun, 25 Jun
 2023 06:54:25 +0000
Received: from MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c3fd:5b99:a829:ebc6]) by MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c3fd:5b99:a829:ebc6%5]) with mapi id 15.20.6521.024; Sun, 25 Jun 2023
 06:54:24 +0000
From:   "Zhang, Xiong Y" <xiong.y.zhang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>
Subject: RE: [PATCH 3/4] KVM: VMX/pmu: Enable inactive vLBR event in guest LBR
 MSR emulation
Thread-Topic: [PATCH 3/4] KVM: VMX/pmu: Enable inactive vLBR event in guest
 LBR MSR emulation
Thread-Index: AQHZoEacn/ONl4ZlqEiTKxW2MUPT76+Y5LQAgAImU6A=
Date:   Sun, 25 Jun 2023 06:54:24 +0000
Message-ID: <MW4PR11MB5824653862500CB4F9EE4519BB21A@MW4PR11MB5824.namprd11.prod.outlook.com>
References: <20230616113353.45202-1-xiong.y.zhang@intel.com>
 <20230616113353.45202-4-xiong.y.zhang@intel.com>
 <ZJYCtDN+ITmrgCUs@google.com>
In-Reply-To: <ZJYCtDN+ITmrgCUs@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5824:EE_|SA0PR11MB4528:EE_
x-ms-office365-filtering-correlation-id: 6ba8ca80-108c-48a2-7455-08db754902f2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BvCnDUBxpHhZRDM8Kxgltg1eo9r8OMrqySKQ3CkypFDRaC6I/43u4fR6Lm8WGyR4otkQXaPY6SbVdm2MgRbib2gH5ta4FjWOD6RcsKab+zGktlmhHwUXsQiAr5Fu3IgnSiZeW/XnmdggxOkaNGAESkyKUtkna1NsqnT3/QcuP6BnrH8RBS7SV9LJKRGJXCYAaUGIX5WODagFmLzaToZX+x8V2rpnFZNYBXFyfvEXpQ2QpBZzfh80WYhRtHucBADHkA+m4BBBjwIOzLj/E2GUHuG32mZs+Fq65lU3bl8YiROzxYY/qurSMlCXAY3jKeA/E++xBD6t7m1c23JqfK2hKIWqwBgg45JRAp3BLJYGOx54QXVCqPiTtWoBhvJFGdfpwnjpiHh9L3XWpBLUPuz5wgILMNpyJRoQY3QBm653c00BK0/t0y0IEeVrZQ92a792bK2S1/s62rlBEchDd2yBJI24o6V4ccFVxAI98tsZzqHVUOSPXhnnGtIFkNDkyQOv85VLpd/xpiGxhiv/wvT+GHtVNGsFm8+37wT9whSBnd2oe+R9xYg36PeIxYoOyexkJpR8EpQOSxr3cuXXLgvnCpnKUDcBMDch2XjcQAi2h7Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(396003)(136003)(366004)(451199021)(66446008)(478600001)(7696005)(71200400001)(54906003)(83380400001)(26005)(9686003)(6506007)(186003)(2906002)(5660300002)(52536014)(33656002)(38100700002)(122000001)(4326008)(82960400001)(66946007)(316002)(76116006)(55016003)(8936002)(8676002)(41300700001)(86362001)(64756008)(6916009)(38070700005)(66556008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fqOGAcsP2kaMgeWNl7Ndefh1iY7Wzc3U4OLpjcecYOZx5ZDCbZtkZzFEHWh+?=
 =?us-ascii?Q?pmmGiZBvtV4lsMtTjFhRhJ46QlIpSFHwEjihm/J0JcqHC70P5+Fh9bnDycwO?=
 =?us-ascii?Q?QAGK6M7RVQBAQnr58a5rpOpkRbbbBqOl8tSQ8TjvxSHI5NsjrtubIcVKq2e5?=
 =?us-ascii?Q?y3aTU0iL7bFyX1ZWAgqstqJLOLLhqhWCPb6v34vxdKf0/xLaBbUfU6KfDUUn?=
 =?us-ascii?Q?cIWAFdNDo7iOYBRcuKP+KTcp/crCla+7jaygFpLdKdAeClgUM6JsXl4ne0fm?=
 =?us-ascii?Q?oLswcRXvnQFrR9a/v27N0p2Qrvm6HJbP8XMDo1XI93bmI9yorcmiNSxZs7/+?=
 =?us-ascii?Q?N4IVEkC1ZSnB9mmX1tI+Jbq63b9D8dzAHwHHMBtCpStUQWADiWLUjJSr5BsH?=
 =?us-ascii?Q?SVpBTbn3n4AnoYbOuc7BQrzoU/ezyMucgsv5s2wTIhqQiinQ+eY3IpJ0QNMo?=
 =?us-ascii?Q?NQSbbTLLP2knjx85L9dyaZI4WtErV18fzBoy/KjUvvHhTjUJIhH4d1jhRBS5?=
 =?us-ascii?Q?cNtRPv4McLc7A1sZLKOBCdU1S9sUap5QKahxti2Rz2fCLgPxZca5SiM9UoMI?=
 =?us-ascii?Q?wI3BbFB8oZ6OgXI9CKN6nc5XXIJ/lAwCOPPp1JZtwVLbZULxL355UUyLX/S0?=
 =?us-ascii?Q?BuGsGjecUAn0/4Fbcx6a46H7NV8zK9BBKwGj5hhXQkLwUPrBaDUpOvJDG4wq?=
 =?us-ascii?Q?W85Y1Ym4vfj++0ctLSSKuCQI/rQdxRpXCwacYF9nQmgKAIgEfVPOOJ6k2B+k?=
 =?us-ascii?Q?pL4g/eO1ocuHMzpJpm+cqpxwbrbhgazZZ5mCUTLYRRjOeW2urRjhH4mNXr/B?=
 =?us-ascii?Q?N19dHc4/VdOQGHUe7BkfySWR7DDzlvsim1UIn176MIiOOnEwShKyO7OVdR+J?=
 =?us-ascii?Q?HspfrUncIhy5+4Jy6n/tZ+JoTbCE5YcDFoYeT08YPbxo+wNynXCBGpMI9wEr?=
 =?us-ascii?Q?tO/ko1v3ytuB+9DzC1xV4tk938x/DiCrLWlokARLQX+HaLt/mIn7Ek/sFEQV?=
 =?us-ascii?Q?73dxQFwOzw9pUBXC0ld49KIIOT1BgmRz/sZ8DHmjOOIideKfhnuS9ETERf02?=
 =?us-ascii?Q?w6EQyNkzlNUVLdWSdLq/y7FyEnPo2nW6rduvmerQE+hY9dgn6+WB+rBfpOOy?=
 =?us-ascii?Q?aMydnSbkKFpoClWM+mf8ci1SumEW8dskMqnkwPf9JfSGpZj1AP9Nx5TVC0HR?=
 =?us-ascii?Q?7FIX2H8R1QneT+Y/NQknjO+igDYENwyCpUCgkT8DKnLh+rYpvfv/rzCvrstq?=
 =?us-ascii?Q?W3I5n1Mgh9q/vW4huYqa9+FgeAwUxLSsg402vyRe95oOIE5XJurRt6OX+4my?=
 =?us-ascii?Q?lH0T3p2BrBr+AYzohDtsWop3BMkSnKgta/BK/4pU2HtJRDDpd3NRuRm4o0Gf?=
 =?us-ascii?Q?Z5v7LGIco75jbhZ+dpdLlngZtI2jFljfh5uhigNA+jDP0bRGd1ksN0PYX/VU?=
 =?us-ascii?Q?kwuzUv9WtgJ3QjCiy9RWeRblCxv1pXGnz2bnsusuAfU5eCPoX/8PgL37DqF7?=
 =?us-ascii?Q?dCyTbHuSpgYqlyHrtgyEY6WUIGwM9t3zlV24Sc0JgF76UTLOAR2hB+2BHSPO?=
 =?us-ascii?Q?3bVtZh4Sw275TQKwajzjn8ff8tKsydLZ3vqNHFu/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ba8ca80-108c-48a2-7455-08db754902f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2023 06:54:24.5014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3e3r73YPdCFiHdq/rQ6kWunoCZR7zF0jf9HlEYuAmOz3q98chi+/NI37/WpohGvrYnBHRu6xRTt0j0rbBNLQug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4528
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > On Fri, Jun 16, 2023, Xiong Zhang wrote:
> > vLBR event could be inactive in two case:
> > a. host per cpu pinned LBR event occupy LBR when vLBR event is created
> > b. vLBR event is preempted by host per cpu pinned LBR event during vm
> > exit handler.
> > When vLBR event is inactive, guest couldn't access LBR msr, and it is
> > forced into error state and is excluded from schedule by perf scheduler=
.
> > So vLBR event couldn't be active through perf scheduler even if host
> > per cpu pinned LBR event has released LBR, kvm could enable vLBR event
> > proactively, then vLBR event may be active and LBR msr could be
> > passthrough into guest.
> >
> > Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> > ---
> >  arch/x86/kvm/vmx/pmu_intel.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/vmx/pmu_intel.c
> > b/arch/x86/kvm/vmx/pmu_intel.c index 741efe2c497b..5a3ab8c8711b 100644
> > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > @@ -314,7 +314,16 @@ static bool intel_pmu_handle_lbr_msrs_access(struc=
t
> kvm_vcpu *vcpu,
> >  	if (!intel_pmu_is_valid_lbr_msr(vcpu, index))
> >  		return false;
> >
> > -	if (!lbr_desc->event && intel_pmu_create_guest_lbr_event(vcpu) < 0)
> > +	/* vLBR event may be inactive, but physical LBR may be free now.
>=20
> 	/*
> 	 * This is the preferred block comment style.
> 	 */
>=20
> > +	 * but vLBR event is pinned event, once it is inactive state, perf
> > +	 * will force it to error state in merge_sched_in() and exclude it fr=
om
> > +	 * perf schedule, so even if LBR is free now, vLBR event couldn't be
> active
> > +	 * through perf scheduler and vLBR event could be active through
> > +	 * perf_event_enable().
> > +	 */
>=20
> Trimming that down, is this what you mean?
Yes, thanks a lot.
>=20
> 	/*
> 	 * Attempt to re-enable the vLBR event if it was disabled due to
> 	 * contention with host LBR usage, i.e. was put into an error state.
> 	 * Perf doesn't notify KVM if the host stops using LBRs, i.e. KVM needs
> 	 * to manually re-enable the event.
> 	 */
>=20
> Which begs the question, why can't there be a notification of some form t=
hat
> the LBRs are once again available?
This is perf scheduler rule. If pinned event couldn't get resource as resou=
rce limitation, perf will put it into error state and exclude it from perf =
scheduler, even if resource available later, perf won't schedule it again a=
s it is in error state, the only way to reschedule it is to enable it again=
.=20
If non-pinned event couldn't get resource as resource limitation, perf will=
 put it into inactive state, perf will reschedule it automatically once res=
ource is available.
vLBR event is per process pinned event.
>=20
> Assuming that's too difficult for whatever reason, why wait until the gue=
st tries
> to read LBRs?  E.g. why not be more aggressive and try to re-enable vLBRs=
 on
> every VM-Exit.
Yes, it is a good suggestion. Actually vmx_passthrough_lbr_msrs() is called=
 on every
VM-exit, it also check vLBR event state, so I could re-enable vLBR in this =
function.
>=20
> And if we do wait until the guest touches relevant MSRs, shouldn't writes=
 to
> DEBUG_CTL that set DEBUGCTLMSR_LBR also try to re-enable the event?
Only perf know whether vLBR event could be active or not at this moment, if=
 vLBR is active, KVM could read/write DEBUG_CTL[0] with irq disable/enable =
pair in theory, but it is better that kvm don't touch perf hw resource dire=
ctly, as vLBR event is one host LBR event, host may have other LBR event, p=
erf will schedule them according to perf scheduler rule.  If vLBR is inacti=
ve, KVM shouldn't touch DEBUG_CTL MSR totally.
>=20
> Lastly, what guarantees that the MSRs hold guest data?  I assume perf pur=
ges
> the MSRs at some point, but it would be helpful to call that out in the c=
hangelog.
For DEBUG_CTL msr, VMCS has two fields for this:
1. "Save debug controls" in VM-Exit controls
2. "Load debug controls" in VM-Entry controls
For LBR records MSRs, perf will save them at process schedule out and load =
them at process schedule in.
Sure, I will add it into changelog.

> > +	if (lbr_desc->event && (lbr_desc->event->state =3D=3D
> PERF_EVENT_STATE_ERROR))
> > +		perf_event_enable(lbr_desc->event);
> > +	else if (!lbr_desc->event && intel_pmu_create_guest_lbr_event(vcpu)
> > +< 0)
> >  		goto dummy;
> >
> >  	/*
> > --
> > 2.25.1
> >
