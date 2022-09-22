Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FF95E6487
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 16:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbiIVOAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 10:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbiIVN76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 09:59:58 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC6223148;
        Thu, 22 Sep 2022 06:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663855197; x=1695391197;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=us5XqW5HHvJt5at4cPMu2AIEuHOLjQct4+bnMgfnOqk=;
  b=LmQXkcZe0tkjzysYFz1X16lUdZOpHKWvLY3KRTwZXBaunI8QpJDs3ORI
   Luji+/2ijm9KLr1mXXfiILWRHgBrRQcSTFSlqE4TjGPXhMTyNe8W33ZvX
   Fy8j3P/0gt+bJu9XxtIOjLgPR2t3sCWk8kB0fM4dC2goEP3uKXMvVtwUg
   Actam22KeLUT/zNmwXP0TljUZbZFk1dMssaY6+ABy8VH/nt2oQH9MEgrX
   a1kUPMY9+fLo12cNG2C0uMd+YSEfkLGtne3JP8SqdKqQN1tO6bTnBTdoI
   CndUnUwxGehl7nUsbug2Oermp/HunDFIUKYXS64Uc9330rSuFVSkXG0wN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326622019"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="326622019"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 06:59:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="652977830"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 22 Sep 2022 06:59:56 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 06:59:56 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 06:59:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 22 Sep 2022 06:59:55 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 22 Sep 2022 06:59:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LjgK3VhYoz9gZjuVvi+4K3/GqA1ZB/DFQOv6ZAzUuFEWzUat9cBuHL2TPHucsx4v5EWyAr4jTJvTe8gt7myWMHNHq3+ekPuJlZgIP6+FvZ54bTdqiBP8/JUnbQx9UdtV6AtAK0X+NUje7fcTxcx9TrLnj0Lxy2j8kJaazZLtsQrS41VUiDZRfEnlcz14wYjvzB+57EgWHpbbNerq746FvoNYRx2stTGM3ad3ngECOEHi/w5DPAF8SohdRk9D6aLQBkoV3pIQ5+cw3XUm2kOSZSEg+k8nZlSmr5n3B3wHcG72XmBfHjGkbrfcjasjdWd2vOPkcwSZwa6ku46gx/cAmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=us5XqW5HHvJt5at4cPMu2AIEuHOLjQct4+bnMgfnOqk=;
 b=KEFY2WP4Di7Ryi5QKaRQor3m79tkTNgo7Q4rdFCTBjJAq3RcZDoJE/Rk3zoXwWbFDKB1TM8/4f6KznO7PcQtefcquCxiHOve0+gmKcNSgX/o0qVkCQe5yqbxWAQKnonAYtD1yQ7e2Vg1q4z4+wRQDIrcG+/aSaLSUGqYK5He2ZP7dyR1HoqjHK1ets4AenzYv6d5AIYMfGUUu5hwHpyipWBsCOcF5Yjz7zDZXq1DKrvLyT8uZydxeuNqCo4ekmNDJvkngwakxOrtG3aSbLogaSIMMWD/zPIZhiNBKl30Qdji7WoCcyQ8bb6ARD6MIj7JW65/6ETH+22hVzU4EEVx0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH0PR11MB5174.namprd11.prod.outlook.com (2603:10b6:510:3b::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.19; Thu, 22 Sep 2022 13:59:53 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::817a:fd68:f270:1ea0]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::817a:fd68:f270:1ea0%7]) with mapi id 15.20.5654.016; Thu, 22 Sep 2022
 13:59:53 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "Liang, Kan" <kan.liang@linux.intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Alexander Shishkin" <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export
 pt_get_curr_event()
Thread-Topic: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export
 pt_get_curr_event()
Thread-Index: AQHYzdmZiDfxfKVenUORyjhoUz2tZ63rY3WAgAAA7VCAABAZgIAAAWLQ
Date:   Thu, 22 Sep 2022 13:59:53 +0000
Message-ID: <DS0PR11MB637346E9F224C5330CDEF3BFDC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
 <20220921164521.2858932-3-xiaoyao.li@intel.com>
 <175b518c-d202-644e-a3a7-67e877852548@linux.intel.com>
 <DS0PR11MB6373C84139621DC447D3F466DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Yyxke/IO+AP4EWwT@hirez.programming.kicks-ass.net>
In-Reply-To: <Yyxke/IO+AP4EWwT@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH0PR11MB5174:EE_
x-ms-office365-filtering-correlation-id: 3e02d12c-4a55-40e8-65bc-08da9ca2b930
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EseQgCBL71kiaZ2QWhPAKcI3y5hEXsC8ESnnIFIIJZr7yiMvhX/u9/BiE1+CrSell4ElRUnDkw6g95olIMd3V9n1KoZiMpuFQTPZRiRDPxFs26cVa0T06+WarA8a/xtGmDi0qkqaUMe9GzVQfM+Spah2xekJVavrZhvGtRFUdkYv2MWCwaUr1jQGIQhnWJqj1m0HF6h8xwX7NaZv9ZvFSaYkkQpWwPPT6rBLNcpIQnudAmV36aessUbqUR5+0RicIH/b290sQtCxQB9DLurh1BA628NohnouXjqxrV10mOlTQOEyHYCr81BQb0GunWB2THxFOYmaQC4uI7IpugnZhdVbzkTZl1HUw91//INL2ys4+yyIcwF+nRkOkE32samGJchAdkCK8PlKEk254vzcry8WktlXb5jr2yuNG0BNyw3BCnK0u22L8J4RkukoYBhjUuQZSl5jMhweAjhJOD7bvTR5ENdYR9i03QOSZwRMmbQitWrde6u7wJDSbamLwmv9pCkVZyRvBVwEnRJvt+1FIzWfKTKz8jZRhHahIUtIIgWljjcax7+ApgPKd/3y28K6imT0oXN2kdoNu216IMrTcIY0u88kqgxwsIsO/4zrSk1/b3nKoJHM1jWHfH8gI2evmUEAHCuEIqG3ZLFHtRDJdlVjMLdLncHSWbZW/h1Qn3YHrxDIpvEmPK+L/IVZMFDf+dsRKmumzSbVX135EDKSQ3v41lYuG16xNxggrVPq6JUCJLSZ4vkW28pX9wuNDFJ2aXGkZDAcIK1dkslKLhGXfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(39860400002)(346002)(396003)(451199015)(2906002)(66946007)(66556008)(66446008)(66476007)(76116006)(6916009)(52536014)(54906003)(316002)(478600001)(8676002)(64756008)(33656002)(5660300002)(7416002)(9686003)(4744005)(26005)(55016003)(186003)(86362001)(41300700001)(4326008)(7696005)(6506007)(83380400001)(8936002)(82960400001)(71200400001)(38100700002)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IS3I2x7h5Td2hnI6xgZ9hlwOSy+Nbn8Dhcm8oi8dWAn6w2WTqATKebgK/uii?=
 =?us-ascii?Q?T50p3zB7S4XNRiNBFODXobYSLsDqY/uvhOkZ2BxRsdqOda74B+ljig/sDdUP?=
 =?us-ascii?Q?bgTvMWsmlwvQM8FGSKBE1RpZHE1sWdmjjR/+6D3vzs/iOnJr71lt6Dlgx90f?=
 =?us-ascii?Q?lAC9W6ed9DYqKBZ47w266msLv/FSonI/58aOFGzz/e32MVxzXwFecvHQptVf?=
 =?us-ascii?Q?+b3r1s6LlvLHZUseAtxGlItlFABNXBC8avb9w3qHKXy4DZOrc31VcMdR4kN+?=
 =?us-ascii?Q?4rQNuFO7Bp/1MS5fITsxLuF1loJAt5x7bUl5NXQzsMQe2+ym/kJal+IaRBV0?=
 =?us-ascii?Q?dyk22gXf3Q4xYcnIsYqMXwzwt0zJ1e0qEAloPw+aeDnA4jK8YPmu5GHAxAtM?=
 =?us-ascii?Q?6CRnis2wQ4fypg4kLSwsmt+8ApoS6WmCDeXHS3h1yt4dOxqwtHCEVN3YEAay?=
 =?us-ascii?Q?d2nWfMwabAm3ldLLrmXrhOagMPpUKGGENUc8zqyou4qmIyijSyU01ME4OI0m?=
 =?us-ascii?Q?D//Rk7TS5Q233qpu0wt1DN88zMJpu/crkYLBnDPX/I7uRSn3b+J5ShXASVZi?=
 =?us-ascii?Q?i8JlXqIqVH54VGEg6XdYQQjkzqJDFzPRM/dT9ksLlTN6nld6XliTD6CfUyvQ?=
 =?us-ascii?Q?7I8K212trl3v/kEOWl08Dr7IsyYnb2hwUrUWQX+lFE/6aOLgz3GCq0xJLsj+?=
 =?us-ascii?Q?/MitxWExe67o9V9TdjXxkXuuy4IWJYi6SvBuwr2Ha0ZXz6rNN8EYPjKnESJm?=
 =?us-ascii?Q?RZjHFT3hjwG6CiStjeJS9ItR9KW9YSWlti9NgoQ4sHkU1kuGteQRi/hPdC1R?=
 =?us-ascii?Q?2orobL0pzyKlUHW+CTqmJqdu5PJKt3zX4+j5zoVYyfVrRoT2UTaCiX9zpm/p?=
 =?us-ascii?Q?iCw4tl05y3NhWu5EL+/34QiPcqhWz2Xxy90SrdoJrj4W29nbSusDf0jrL9vU?=
 =?us-ascii?Q?fg4AoMBKa955aI09pdiPoOW+Joa05vfdq10qB4tY2bRzeAxvttgngl8SAhN/?=
 =?us-ascii?Q?f6f2QqI27tKK0pq+dNuXgncdcuj3aF0jErml4Sq6dHL1fS14kYDUMIf7C7tz?=
 =?us-ascii?Q?wECILXY7dcmLPky6+ofrRxcZ5BkLqCVWuTqaUqAu8HddKy6SIr73okxUt8tG?=
 =?us-ascii?Q?voqAJa/1K62ApPLhFL/dJ836lIOeKi8XiIXkxpc09LOkTG9U/1v8Oa+/SsG/?=
 =?us-ascii?Q?UOOc3M3I2XK4GOAQNGkpfcqyWMBuFZYYaaj0aBotlxHT5mm8/plYyB/pxz/1?=
 =?us-ascii?Q?6ti9rFxAJhKeBUvSIcLST2cBY7/KTe5h/CV//reosJcxopXEdcjuIJs6gAEE?=
 =?us-ascii?Q?+PwbujIXYalUCEmI9sbPlPuKizfG7xi0E2mUrtgVhJHkE4O6NzlUlZFncipD?=
 =?us-ascii?Q?h50+49heq9oFZEwPlipX4jL5UhyudkFzEsR/WG2Q5xhSYPeSJD/gzTQSLpKX?=
 =?us-ascii?Q?xu3sXvYCuBePzzpk/GRV2xk68Ei7k48n82R2+YLraJawk3rnwh28Fqdci0on?=
 =?us-ascii?Q?5UqHLxDhwVFFJveTwr9LPeYf5kzSWa9+yweIHV7EEMo6Wibzb9Ri7tPo1n2y?=
 =?us-ascii?Q?L6mg8sl8PNjNIHr3SirGcvQm29SlxIuE0Wxdn8Q8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e02d12c-4a55-40e8-65bc-08da9ca2b930
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 13:59:53.1625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MAon0WkNl3bNghJBATIzAqjrek7vvH8kZPdoZs2h+ha0WXw8Bmpw2/HcB7uet+37n0ovRZfHVvxn9Ds/nMvAAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5174
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, September 22, 2022 9:35 PM, Peter Zijlstra
> On Thu, Sep 22, 2022 at 12:58:49PM +0000, Wang, Wei W wrote:
>=20
> > Add a function to expose the current running PT event to users. One
> > usage is in KVM, it needs to get and disable the running host PT event
> > before VMEnter to the guest and resumes the event after VMexit to host.
>=20
> You cannot just kill a host event like that. If there is a host event, th=
e guest
> looses out.

OK. The intention was to pause the event (that only profiles host info) whe=
n switching to guest,
and resume when switching back to host.

I don't think it is proper to directly disable it via clear MSR_IA32_RTIT_C=
TL, e.g. there
may be dangling PT bit in the interrupt status register, this invokes the P=
T interrupt handler
to re-enable it (for more details about the issue please see patch 3 commit=
).
Would you have any suggestions to pause it?=20

Thanks,
Wei
