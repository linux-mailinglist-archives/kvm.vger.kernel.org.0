Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A698600499
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 02:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiJQArk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Oct 2022 20:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJQAri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Oct 2022 20:47:38 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BFA356E5;
        Sun, 16 Oct 2022 17:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665967657; x=1697503657;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cneBL3akI07vrrRA1U/lW3hLm2HPKbsE3CHuHbbVWjo=;
  b=X9MrbcDhexiQrt0AMfI8SDAu5N3E63wdhx7HvcWxBEqCa5kr4CyhIx2y
   4Xhdyj9JSceJmS2d9ymg4qh5sg3RnybQId7CksxNDko31C2Eo1oRlMYty
   hSSZbql08lOHKhgL3BTq0VVp2QD9v9zeDGGr77aZmD/tpP0Zkvl1GkDpp
   YcLiR3uBPJCsKY5TbLpt1klSTWNx7LQPeWAaL17ZPETU6FnhoyTz7TDyS
   5ThsKWetVmMkf0mBQYoAaq1OY1gjbvnc8bksIz0dQ2yOrmeg2eopl9/1B
   cX6c2/YDbxto2G72tWCkDvoV54SFp4zFLvilVXBaSEvpKKFG4Wk2tKJ4f
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="332205116"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="332205116"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2022 17:47:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="753462643"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="753462643"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 16 Oct 2022 17:47:36 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 16 Oct 2022 17:47:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 16 Oct 2022 17:47:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 16 Oct 2022 17:47:35 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 16 Oct 2022 17:47:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+S+oeSA1SzC+c+ZKn968oyzZjz3z/6QUMhTdgJUPw1b2m/WRAq/KfMl3EqnUrKWH/UlWsYvQFOK5KuA0mlsqO9IeQC/kYuaFVcmVVEw+Cl/ReLM4ZqnVzOA9GvAbtRuIeOgu0Ut4+97xX1Blz38WkCvHriVvIzzNRyvwuxcFAPJhmfCpIBFcCeeFjM8WWDcTwh0CY3CN5ASqFBu7WMpawMLJ4OhWCg4eEbjq5nKEKTGpOJ8kzgTmLYBI1Uc4vPQw3QCbSA8fOlPhpm8j1TlM7sMXoCJ1xDm/MnkNUQDxeUPlqeovzISfovCaw+qsiuihmUHBE+eJ9gzmertlpfNVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tC4cieyoc6j8T0ihdbdKwuyuBLxrdyULpnOk7zz9n0Q=;
 b=PyZlix9a0YrGgMbvRBv+fsrwq8QjRbOILTIMXPzGwwEpQYC0pmJTJvRUpU/os/J/mmHJ+O+5buWa47D6nXIspl5KBBJH0OXNVgIQe0piArR98x4RQ/w8DVU6WCmsjQwAuJWLynCDPaZg81fginS0umNMrlptKORzyQp+UAguz6x8UTfj5Hgjgou+93cUF+lrYitUQTOpaEvCejml/8P2yAxpHROGu6FDCSyJrECQ1F8hYYSD/3t0k3OF8tLaUtCS1N0zx+ut2GB5Zs1/DE7OAHs6C7bK60/F1x+zxsKnpa1Zvh2QIj882NWNiQqFRaCUhtgs+Aer7ZP9zsN/V6Oflg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 DM8PR11MB5623.namprd11.prod.outlook.com (2603:10b6:8:25::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.26; Mon, 17 Oct 2022 00:47:33 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246%7]) with mapi id 15.20.5723.032; Mon, 17 Oct 2022
 00:47:33 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>
CC:     David Matlack <dmatlack@google.com>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 0/5] dirty_log_perf_test vCPU pinning
Thread-Topic: [PATCH v5 0/5] dirty_log_perf_test vCPU pinning
Thread-Index: AQHY3PSo5mk7BJgdskG84RjiFjmwJa4N+zRAgAAgogCAAAXFgIAAGXKAgAAKKgCAAkRCcA==
Date:   Mon, 17 Oct 2022 00:47:33 +0000
Message-ID: <DS0PR11MB6373B2EA960D5FAAC9208320DC299@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221010220538.1154054-1-vipinsh@google.com>
 <DS0PR11MB63735576A8FBF80738FF9B76DC249@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y0mPqNRSgpArgyS8@google.com>
 <CALzav=dU2-3avKGT2-AxO8d_uVH9bmYaO=ym8pPFM8esuSWP=A@mail.gmail.com>
 <CAHVum0d2Jfr=WVxKxvnmwGKzPfV3vN5dbz11=rdcW6qoSoobew@mail.gmail.com>
 <Y0myXiIjlT8pYyr8@google.com>
In-Reply-To: <Y0myXiIjlT8pYyr8@google.com>
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
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|DM8PR11MB5623:EE_
x-ms-office365-filtering-correlation-id: 6d7d63ee-41a3-49e3-bbd8-08daafd92dbe
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bSdGpla3MoU1DlqGiyOidsoBphJ0cXSvvXYeAGriRiW+kPdEaU2NUSgxPFnESbmA/YkrWsV+FYADMhGgUt9jjXJk9Qpam2h4O+EyCF5i8WAFmOjVnTduvmTOLoNGPtT9fGW3VwNFRJgQazVOrT4tT+o2aR/eHfKl2yLI0wdsdHrCuPQA3OFEwUoRy6otw8yEN5zetCyAJwK0TsSJLhUd2jNEGbVEnf3OaJGHFN/0vcGPhdJ7RFPhO/xk+a2W/rJIio5t5j7KTA2ThmqaQGnaPXk7cETht1z3maDsWa2XZSxYHxY+wB7UYXvOQc58+24FrIjxRxKrFm1mF/dZauPNasCI5ldkU7zNSjA5BEkXk/+EA/XS0jHyakJkkYhnjKe14F/+jwCCMUtMH2XjFzlRDGbPZVwG1EP6nGxU6eNWb5Pw2tNitbjQaJacykPSMVfBnVt9wqapA8IEiC0p7ULdx0yO04XzfpbGCJi+wRb1qVGgPWG5975aqcUT1fcWMDhsTqF/CQoNwtSS4pM9NtwxiWWFP1yHL+XuJ1VET2Seq6WdNrfkvlsIB8cmV5+m9bJSFhOsUBzoYGvqG3I/26TDB/nT7FGy/CgvMzi9GrDScll8s0CZM7S26z1oeulZ6rIdHObPy14wyEIJGPgBdb2/uGmfv9NHJmAPM69z6tw8eWghek9nUC7jVhqiSOSAeOynGQuZSYptYDU5zktV/BL5dXNGrjIRz1b6lL0z8uSMZSPR5jZFhCKaPzXOAJkzb632VORouaGK3uY8U9RvIXWco/OAYbVxZZnIs5bsS1K+WC8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199015)(71200400001)(478600001)(9686003)(38100700002)(82960400001)(38070700005)(26005)(4326008)(54906003)(5660300002)(86362001)(66476007)(8676002)(52536014)(64756008)(66446008)(122000001)(55016003)(33656002)(41300700001)(110136005)(8936002)(7696005)(53546011)(76116006)(2906002)(316002)(6506007)(66946007)(66556008)(186003)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hZ1J2d9f3GRl+uklyIdlDOrd711e225aT/KMShkgRSp9Evq9XoFULWgTKhyw?=
 =?us-ascii?Q?uRjRG/6BHp5LLW9rX7oRNlf0OYRNE1uCR/B9Z3BUcv7/gbo+cVKhK4+boJHF?=
 =?us-ascii?Q?npLb70gmDiBKDl16TZK0zrHzB7tkWwAR4nnNqo12WDQbPObEVqystNJZE3Cs?=
 =?us-ascii?Q?2vfqCerSbFRuzDWHxsDPURtBHW7IDZ3gMrjQioQsJRuZI0LuJmY2Zb7pb23M?=
 =?us-ascii?Q?0WtiqsyYGq8iNFxFz/G9MY5jonztQnGNGBiUPuDd4DlU1Igqia9vdeZsJmzo?=
 =?us-ascii?Q?BITS8ibquaw8rNfdixSikchJntCpDAA4Rp8fwKRIefeSPWVzTOHKvAZ4GUiL?=
 =?us-ascii?Q?kkpUss1C9s5NZFVHdhRPSlEKmW+wTkmq3Z4BOrEk0aOqm0Dffja79nkLaRC4?=
 =?us-ascii?Q?E5JcnLcFCdOjQkTnmDSu+KerOnw4cn0xNIODSCS46PZQghuQ+k7D/T6GzraX?=
 =?us-ascii?Q?iyytCynxzONlQlnZZ3WSTslrQCQI+wOiuOTyDX46TDPQYKmymo/Q1U8sMoIV?=
 =?us-ascii?Q?rwmTo6JwE3HNT7SLV1Lkyivrph0sTHmSskjcEL6tI3BpoiKNKdoeoWJXcxNm?=
 =?us-ascii?Q?Ep0G3MRWvd5MgzSgN5xw5cBBLxGLtwpGJa6fX2MLlq/ATCY7JtHELKgDLwxs?=
 =?us-ascii?Q?D1CPCrzd+KH45VGaLX4UHYYSBphrm8udIMXYl/LyiVybFj6c0Te4quYsaEVz?=
 =?us-ascii?Q?BHszDt9SMI+Y9GL45FEZ83clkuWV4cjuVf1NJd/0N5WsKt/XkGN6k2yxk7cG?=
 =?us-ascii?Q?AZzCvzTMz86OlO7iFnuBIWuBDBg6faiCqPnOrglJ64KPQ93ubP7B6XMLVw5B?=
 =?us-ascii?Q?/UfRPmS7P6hc863+y0wsSn4AxI5hqlFX4ANPMubnimGGSrKXYwYv+qNdTNdH?=
 =?us-ascii?Q?GZTRr+vgszsdlJNnffU3apQO4e4PX2IiMlXfLvofwOS/vj2SWwZT7gEHk2mX?=
 =?us-ascii?Q?t+FoDTSyH+1WhXmezd9FUOa9t+BfZE5a/JcY+6c7tN8xCrISfPjoyxplxP8N?=
 =?us-ascii?Q?+7h1h0Dupw5T/mYR5G7D3KwI8IYLmGi+Ndht+33eNQDCNyGUHX6ZwCrkbwuU?=
 =?us-ascii?Q?ArXhrXqQ8eJqLEuEiMQyRvEsKxcEo+juwAlzqZF+w4lKJUzaA/hMbqA2BfZ3?=
 =?us-ascii?Q?pG8A9TxPNcIzYSRL4lmq/cWsqIzaM5xFH50cv/3ECsLT2Q8gD4rtZ5n9NpXB?=
 =?us-ascii?Q?ycxFognbCqNS8nFSCd2mDPGg5aLcwnLrSGC5hH9l+NluJlrMkpZdyMgViAdl?=
 =?us-ascii?Q?aafxka4U+eVgDhXEtIkPyFYtZET27hpVyvgNKymS2agcRUH2/X9Vqkf6FL4H?=
 =?us-ascii?Q?Z3wawcPszoDaoW5XiGHtyKKznLD2XvFFF13iLZc3K1VIaFSAiBdKS/dlpiBk?=
 =?us-ascii?Q?QDnW8aeW3UbSbG3mmxaUlCYaf6g0S5WI6L6R/Voma17eTwE/RjdouGrfmQlT?=
 =?us-ascii?Q?bCd0+y9E2tBYJHDtO5SaIEsjYUdlJE3UgGwLe/ZPi6LTr3zyPo2uGvx6vLRz?=
 =?us-ascii?Q?KkHLzhvpAHcGNW3LnaTBy/dIuUoS1MDwvMIJ7isRSrNtm5ar+C0uNMROd1cY?=
 =?us-ascii?Q?JEPry4kie+Cmqi/PtIfVOY9IZw4vXbbLndczIvjL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d7d63ee-41a3-49e3-bbd8-08daafd92dbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2022 00:47:33.6428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2AVQ9HPAxrs10AfkGiK5NBUWY20T0kusrjQRYFOVf4HU90951YNUlgisY6ZLwYU85xKITEvn7luLpWFSHl9Vpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5623
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Saturday, October 15, 2022 3:03 AM, Sean Christopherson wrote:
> On Fri, Oct 14, 2022, Vipin Sharma wrote:
> > On Fri, Oct 14, 2022 at 9:55 AM David Matlack <dmatlack@google.com>
> wrote:
> > >
> > > On Fri, Oct 14, 2022 at 9:34 AM Sean Christopherson <seanjc@google.co=
m>
> wrote:
> > > >
> > > > On Fri, Oct 14, 2022, Wang, Wei W wrote:
> > > > > Just curious why not re-using the existing tools (e.g. taskset) t=
o do the
> pinning?
> > > >
> > > > IIUC, you're suggesting the test give tasks meaningful names so
> > > > that the user can do taskset on the appropriate tasks?  The goal
> > > > is to ensure vCPUs are pinned before they do any meaningful work.
> > > > I don't see how that can be accomplished with taskset without some
> > > > form of hook in the test to effectively pause the test until the us=
er (or
> some run script) is ready to continue.
> > >
> > > A taskset approach would also be more difficult to incorporate into
> > > automated runs of dirty_log_perf_test.
> > >
> > > >
> > > > Pinning aside, naming the threads is a great idea!  That would
> > > > definitely help debug, e.g. if one vCPU gets stuck or is lagging be=
hind.
> > >
> > > +1
> >
> > I also like the idea.
> >
> > Sean:
> > Do you want a v6 with the naming patch or you will be fine taking v5,
> > if there are no changes needed in v5, and I can send a separate patch
> > for naming?
>=20
> Definitely separate, this is an orthogonal change and I don't think there=
 will be
> any conflict.  If there is a conflict, it will be trivial to resolve.  Bu=
t since Wei
> provided a more or less complete patch, let's let Wei post a formal patch
> (unless he doesn't want to).

Yeah, I'm glad to take care of this. There are other places (e.g. hardware_=
disable_test.c)
that seem good to have this as well, I'll cover them in one patchset.
