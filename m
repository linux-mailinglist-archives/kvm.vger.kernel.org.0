Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A3F6251F5
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 04:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbiKKDys (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 22:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiKKDyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 22:54:46 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607292BC8;
        Thu, 10 Nov 2022 19:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668138886; x=1699674886;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5hhnbOIO0hAtGvNFrNamRoVvu7xPKzVtkhlbVda1+VI=;
  b=gTmdZORwXfdGTWNqVdeiUURWDH1fpwoOCCnGIskHU9eiTrv8b+JFPU+K
   /1oF9j9Cx2ZLDUKkCQTKHUskVOr7pcnqgt6zN/zSDzRqXvFIT0KQ6ostt
   SqQkx20hoAN7uxTgjuQNVWmDpPg5+6wT0bgjdHfstl8YDeCHCFwbUTHyq
   9iWPwmrnEC05Pijktc0ie5J/h00cvckX8fU8MBLwsuvi5GDwQCP5Va9+U
   D4XCss1BfV3oN8B9NUUcKJtXyPp8uLg6x/y10tjnHd0JQr7T7ql77l7x/
   WxFQmkSPo8vUjmHn/88a/F/oA/IcyC4g8vA162RQni00RcBMXjZDaec0x
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="294871169"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="294871169"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:54:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="743137532"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="743137532"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 10 Nov 2022 19:54:33 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 19:54:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 19:54:32 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 19:54:32 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 19:54:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZJa6lokAO6CejRtSpSYWioB3FeU0epmioiXuMv1hNCrS8H0RYvTyIufmaDuEmgFwsl4T4q9TBCXLmieeFOFlaUhZJsPet/QKd0eVW9NCzMCArV7ODUgFzJnHXMFVeDIaV9XQk6tyPnQUqNwe73aTPkiFzl04NdQ0duz6hXzOgPsqm/ziEXsLPLWM+qSlnDPfagVe/8V2PdbWM20CjQhp8LGQ/TrBvLu3tQjDOUi4Jl4W5YOqykeMApkk4T1ctNiuKpzRdd42vu6u2xTsg7shEkAZeEmO27xgDF9kPbuYY9isJrasfdUsoWjlVbhL9Tc2ybdmGF0razLmoaiVpGLYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jTTA9QecS2rayJNixtdV24PQKxV/XaGDMSRjIhwVNA4=;
 b=Wc8XmpedYVUUSF0FSJSzClP3UIXM+RW+kyJ7mWiKgJm41l3/eRTWSNZX2isDgfy2S8sCs1If+tDYFxaXGEIdpzJEjHyK2nKRNVQNxcutTXkHiqBFecVp+O7WLaWoT5V8FyAqGe7aTcWN1hfw5Bmwm4xOUnd2ITt0Iy86u/FGbghIAWKNwc6gi02hd0EUKv0XFoTUCGpCPFd/tElSikh0mUtDoaNOlqqD5skcxDcgxIJOwJvnHI6w1YB56Vnk/Jd0InPDZx0h/rXNysotYMUDdNx4hZVn03X91KaEc51T46ATMiTE0HQA0rtBi+F/3nMeCVsh12cwXjjfB25ykZzFfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by MW4PR11MB6935.namprd11.prod.outlook.com
 (2603:10b6:303:228::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 03:54:24 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5813.013; Fri, 11 Nov
 2022 03:54:24 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: RE: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Thread-Topic: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Thread-Index: AQHY9M85Yu9uY6afW02HaiePlaJ2sq432uWAgAC2DaCAAFrXAIAALQzA
Date:   Fri, 11 Nov 2022 03:54:24 +0000
Message-ID: <BN6PR1101MB2161838006FDEFF5923F6750A8009@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-3-xin3.li@intel.com>
 <Y2y8obdYDXo9vlH/@hirez.programming.kicks-ass.net>
 <BN6PR1101MB21619E2092AFF048422C6311A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <BN9PR11MB52768BAEDEBCAE301383C5DE8C009@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52768BAEDEBCAE301383C5DE8C009@BN9PR11MB5276.namprd11.prod.outlook.com>
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
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|MW4PR11MB6935:EE_
x-ms-office365-filtering-correlation-id: fb626406-6171-49f9-a43c-08dac3986c0e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1GZqg3n9PhmV91RUmBdkg/p/B91dzWqxHVxPuI3ZsmnR1qNrV78Dd7cpOLuIx5KNcJrBvpwgvnBv5muizdr3M+5aFEP3y4acmoJlBxOWGjobYBirRBFdvzS2YAbEwBkHKOyinRNIDhwOB6AK5VfDlS4jM0KLIfO68wiXtRyfFrlzH/rAryY4yJ2lcI+3hFrNRnLK9WVTH6er+a5oBE7OQtnDBmVjhOBDAobf6J4458uLGMvxCfo5yzUm54UVv9tvDYCnOE8vzc1ryQ4UdmaENrs70K1RcuMfLScfXqJ+KW21WMoEvPHS+41JTjkbeOtVWUX2zQ/3hm4nNObPOfH9/VEWtTPY7VsKalSLkA1+W7ujG9vZX0H8YXfQmgIz2uDwD2U4RBFp2g5Iuhi0YD1KaJLcMiMr8DH1+qHAnX9HEmcRjzem38Wkw1J/todUJBFgz5EFW6blsIvd1jeOzNL5kYlfzpg/0ln2esaPd78MBpahHIPLxvEsTb0OYx+SAUAZlJLfZmKHi64TmhF7p6Th6L4KkqVnvqnot8xpEBDN2liPzXh8M8nPSI90peOFJq0waZ/s0URqU8vI99WWz9sbDU4/8VzKiKECZlm7pgl2vdEN0l5+z5rBQQZ+C6hWONOdQ5jsFP7UyMcZMKYpLuw2fhRv+N2EFgVQfoyQSq7BMFDD7l028Rg+C19vXFHGZ1dVI7AETMSofmAGQp79hZDkdyHwtT4v2Ge9gP+GC3/FhMbA9vsVvzR1NUXSSvPFmFfL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199015)(82960400001)(38070700005)(2906002)(38100700002)(122000001)(33656002)(86362001)(186003)(110136005)(71200400001)(478600001)(26005)(9686003)(6506007)(4744005)(7696005)(41300700001)(76116006)(66946007)(8676002)(4326008)(64756008)(66476007)(66556008)(52536014)(66446008)(7416002)(5660300002)(8936002)(54906003)(55016003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/6BBFN2OZxsCcC3SAnslNlaL3uCypvjBvgqqflOpqUxqnnA5ChxXAt48RTwj?=
 =?us-ascii?Q?rMzDVMS5oildkkwmV1ErrhJu8wBTFQbT1THCidZkLS4txMtgiXUb1/kngNHR?=
 =?us-ascii?Q?9tEljwoNrYLJz3v2M8cjFq2MqzDyXfUOS+PzhVKL+VHcYOt39K9eLMag9t+h?=
 =?us-ascii?Q?bwEakc/XLLk4t1yKbu8Zxhg5EjfibenWTH9P+Q1+rwt2NTk02jw1aec2kp7s?=
 =?us-ascii?Q?/lshU+mrL1DUs5rpbzYKbYvUSP6u54B0+c5r0RCBtRacrqRQ5wSBcK1b6UxX?=
 =?us-ascii?Q?NYY5cF66E1uyS8DtowgFBSMQl1overWaSByWOLU1n2FzEW0lV+f0hU5VZbvR?=
 =?us-ascii?Q?vtIjmAa+VHWUrIXHB6taZg5/naA3Jt02AjoJJjZ+ZqhR/OQASEtiR+QPAcEA?=
 =?us-ascii?Q?A7lL49b/34AWcz9ztAr2aF/r3WI2Qof7IT+x6GG7khr28x9Yo9tSMFNM9NOX?=
 =?us-ascii?Q?Ok3U3WOyaKywHISDjmBlC0DTK5NzU+eLoEh5thlF+Q3o4E5FyYBN/s/MseC0?=
 =?us-ascii?Q?EsaPznKcB6UXUD143NJzFZEOjPVusLIeuuBnvt5SlC66gLse6yS+83zGXSyh?=
 =?us-ascii?Q?P4tOl5w3qjGgUtjihR3M2MMctYVHtXEdfgLahdX9hlciGsOdtbKNLYRR0Tlh?=
 =?us-ascii?Q?dW3kVslK702ia5P1PludjBY/qUL2WeTlHDnkyeFYcmhpSAej0rtmhzMQn3+R?=
 =?us-ascii?Q?6qr4EzkewAWguxbMXQd61ffp83aI8pW11Hb4RmjfEiaaBaC1xChqbWeKG0QC?=
 =?us-ascii?Q?RXCPq7QKn1BA/diWU1OGm/hPINsce6P6Pn9ZRe+OR7s+tMq+d+1ngRdh5CHQ?=
 =?us-ascii?Q?SeRe3/XyrsjrVCqc6mymPvhq69q4Z+MtCzRPza+xHNnj0o/fzTGo7+v6SA0b?=
 =?us-ascii?Q?9zoq7gXCKaEaXvuD9YNBhhsvxm1KbmRo35+3lhCdGPQ8OABhXjTM+dcixq0B?=
 =?us-ascii?Q?oHGP1Kw0RVyHW0bJostYcgz/vo2GzVGVbebsqK/TYnbkFvaoxp1ApaEE2UZl?=
 =?us-ascii?Q?zgBDYn00n3TsCLCBKcbbGPOhOZzlK93q4cJNSWpcEKsy45S0cGhBiK69UqSx?=
 =?us-ascii?Q?D6MnqSMj16g8GyyKm2zslFFDamzYDAyP8Bu2lZ9Y4/kVrMixLOLbzqpbf30N?=
 =?us-ascii?Q?mPmSGY7IX5fJfua18eanUD9zRYRGiLShNJ3f75YL/sT/N9ZypLdypKZHbmpe?=
 =?us-ascii?Q?XuZ3lN2BnYXinAc7hBNh9oowu38/2fcbONn+DMhPXsuQoJRphMvfLcY6r3uy?=
 =?us-ascii?Q?UbOkx+OIih14ixKmcE/H/wCA3jU0UWi9MfQkWlpfGvBzqHPRZotcoaIj9wpn?=
 =?us-ascii?Q?ndTLKQluWPaH3yx4NlhNojFK0VPf2qLKaNyDTpTBW1m79vgCoofNf0MBp2LZ?=
 =?us-ascii?Q?zTQU4eGycEtNnW8TazwbGLH6tGbt4PIIcPq4Cd2MdpHomsAYzLugqB5WYEh7?=
 =?us-ascii?Q?SD9pkK5HLmPi3aJDeAwHHSfV9efz4wIrtp9dqt2Ty80TPqDo2YFqrs+lJckb?=
 =?us-ascii?Q?CePqzkUakkrj3XrQ6fxsce4fsBciM8mrdm3SRQomt9VlnWdJ+F4a+pAs2JwT?=
 =?us-ascii?Q?hbxiJXcJU1P6yzaMtw0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb626406-6171-49f9-a43c-08dac3986c0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 03:54:24.1065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4nn4gjdxkVjQhV5ul6Unh5DOePnjzCatYJw6gRIex/0+CdRhIzZr7u6Ne7h3Qg4jBXZwQWTde+xpNlv1REQAJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6935
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> > > > Signed-off-by: Xin Li <xin3.li@intel.com>
> > >
> > > This is not a valid SOB, it would suggest hpa is the author, but
> > > he's not in in From.
> >
> > HPA wrote the initial dispatch code for FRED, and I worked with him to
> > refactor it for KVM/VMX NMI/IRQ dispatch.  So use SOB from both.  No?
> >
>=20
> If main work was done by HPA while your work is trivial:
>=20
>   From: H. Peter Anvin (Intel) <hpa@zytor.com>
>=20
>   commit msg
>=20
>   Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
>   Signed-off-by: Xin Li <xin3.li@intel.com>
>=20
> if your contribution is non-trivial:
>=20
>   From: H. Peter Anvin (Intel) <hpa@zytor.com>
>=20
>   commit msg
>=20
>   Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
>   Co-developed-by: Xin Li <xin3.li@intel.com>
>   Signed-off-by: Xin Li <xin3.li@intel.com>
>=20
> It's documented in Documentation/process/submitting-patches.rst

Thanks, Kevin.

>=20
