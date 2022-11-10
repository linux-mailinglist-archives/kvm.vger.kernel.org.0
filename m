Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68CB624C02
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 21:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbiKJUgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 15:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiKJUgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 15:36:42 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3AE22BE3;
        Thu, 10 Nov 2022 12:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668112601; x=1699648601;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o/kOhEwxjNcw8AG341RIXXCITET5Lw/D4CfIxFPcuC8=;
  b=P2zpf5uLAP9rgJUv8+ud7rcf7u6Ab9zaQCiadLHQGoinOXGZXHehkv/X
   AmlBV8aND/iLSI783kbvUwoVj6Heqw1ex/bY5Uz0B9ctpfdUzXG68PbkD
   4L0eKJjxOFSr4oppr0eVGtpNiwePqtLnVjUe6nYojMFI99cHYfg9SXe/5
   CnZ+he1dFc3D4FTgN77sEQqKthYzge/Fu08JOMgdQDdilvfhsj0x8ERh+
   C35XN1qPMO5HMQya1ElMSwzgYWpsB2plf3HNrVAusNtTCjNbdBmJAY8ia
   rYDmmkupWzCE8s36D6H7wRNudjSKa+3yQ2MZfnAKZiAmcl9ov9AY54K+w
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="311441216"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="311441216"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 12:36:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="588321193"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="588321193"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 10 Nov 2022 12:36:40 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 12:36:40 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 12:36:39 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 12:36:39 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 12:36:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKDhrGM8EZEV4osNoRuEq2eRsqLYzSV11uDshiBUqXr04m9HO0/URPkgxmCzRPWUS9CyXJNrII1Ow8JizAtDJBI51O2ygTEuxmyziRQ6HHSSZFTiS3rlsW52wqGuGByACUNi2v1UcrtzetssUXreLGOIzb2qxm7mqIg661OgFcWu9Kx49CJ4r8VJf52Qt0qgSLk9yYq54SkEu2x/EXxdOLT26Eq5EnGjbM1WbmsUrOZg91I7GX1xUs0FQZSZgPu0B6e3pawSIaNgjuW5HoU/5mqhEXa36hLg3JZyAyQlA1P3qwV3b6QBAtvD9osfqt3DouzXHtlKmPZuyMWljxEmCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZMuljkT1wxV8DapcaR/Rhum7GpCkHA6HBwg4pK+O1XY=;
 b=A2nenpaucNuot2y5piMMGNCeQWhmuNL9lSxxn5ELdqy2NLEQ9fFzQhS7eKdRI5QWWV3GTwh81ZVu6wau4/gJDD0dq7xkdbf9yJsqGKKFSqwFttIdXx+LjOGPQ6c8LTM+nPLLJDbBr80HMGuJkeAtBLgZFudEdRtOhSKPMs3JYYHEnoEVsfqwmNhppl73ve7mH3DcZUGOX94jzjKWzgPriYFjk3I+DCcB7dDIQPQcZTNsA8C95y4VcIeN2ebqgpu3QA/upvRDyWsj0cyg7i6mW/HWynKMaH72IAKowMkuZEtPRbWEa/YNyATIkhzHEGQE+c5U+QXY6739qGzIJ3uehA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by IA1PR11MB6466.namprd11.prod.outlook.com
 (2603:10b6:208:3a6::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 20:36:31 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5813.013; Thu, 10 Nov
 2022 20:36:31 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Li, Xin3" <xin3.li@intel.com>,
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
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Thread-Topic: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Thread-Index: AQHY9M85Yu9uY6afW02HaiePlaJ2sq432uWAgAC2DaCAAAq8AA==
Date:   Thu, 10 Nov 2022 20:36:30 +0000
Message-ID: <BN6PR1101MB2161DDABE8095ADC95B8BC73A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-3-xin3.li@intel.com>
 <Y2y8obdYDXo9vlH/@hirez.programming.kicks-ass.net>
 <BN6PR1101MB21619E2092AFF048422C6311A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
In-Reply-To: <BN6PR1101MB21619E2092AFF048422C6311A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
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
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|IA1PR11MB6466:EE_
x-ms-office365-filtering-correlation-id: 690d7ff1-5852-443b-0577-08dac35b400b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IJSB8i6kwTyhq8gYq4KnjrGb/i3U/hk527EeTrBIIdoF+210kQpauUpgNd/4n9Bvt1Qy7JsIL/uQEMS8tO5Ow4WYXj4jumOpsQ/Wt/OUaqk2XgcQv/5OKh8rfM1aP2apNCfarPCV1DCT4YwiRKI/5XaHz6qEBynK/Y83e4eCgHwpGXCLVjWuzl6/GH7XQ69xx0i2IlHM60CgJftvOOWqmORsvAcgyZ6OwguSRQMBiLTc86GYWtBBKqKJ2sBqcRdwLQDQXgnvDIMrY+eWVhGPYJxDMU9lxRPSUtXpXYvyh7kfhjpyPgOZPLtzlviyrFlbhGlGDd24qsNyptLl29Cta9WxZn4VJ7ofW3HfEEjZwABNnbTo3hyUzo07FtaZyvqn3Vb6c10ZZ6x8JNSDkvcrEt5YhkobPHtDkCJhJRnUY5eWCwDwuUnXXzPV7oTluMFu3GAhcgZb+YlhPl4xdJF6Ku4M+kaWPGKlLvfZb5DDmu/guPbHrcJxNSvoVLtn7d/i2AtilO5m7TeoMo0hlfq+VvBwQ6eDCryrnfeu+iVCE2r7PnfLUNKQ7JZ+JRUkcv1v3BeqomNYNZzTRj0sjZJ9llKRPRUnwKsL9KFvBWyR7YjX6e+tkksbVzIikhaOMisqO4eW7EypA9KS9TQzk9qaKqVsahqXAtI7yJ3ifbpz38NWtQTfilflYdZiPdv7JQQBOT4ES6uh0Oskt0pA2Rip6axBPlQUWvZy4KRxIaNghDnIF1MX/Fu/iM1x7N14EuVrw3DddWKxLmOdT0uRvSxRiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199015)(7696005)(6506007)(38070700005)(33656002)(86362001)(82960400001)(38100700002)(122000001)(186003)(2906002)(110136005)(9686003)(2940100002)(26005)(54906003)(7416002)(4744005)(5660300002)(52536014)(55016003)(8936002)(71200400001)(478600001)(64756008)(66476007)(66556008)(66446008)(41300700001)(316002)(8676002)(76116006)(66946007)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qY29QtE4XSK+z7yzOjtcslHCvIk9DCE4mo5ZWjp7o1Ntck8CdUs8392P2+Je?=
 =?us-ascii?Q?aA6BnF41SP1VbDSFlg4tXck+MvizH7DZTAPTD5uJIP3Ulp1MFVU8/lutYL55?=
 =?us-ascii?Q?g8jbqXPihO6HOZg3n7THE6ZNbpVOpE/271wEHVyPpJTqV/4CwbNCe7TjwXDT?=
 =?us-ascii?Q?XcUfC4iyMINsfpgeMVlRRrWEHLxz6GwYkzGoHyDDjU0siGxiUKKXYuxN7Hhp?=
 =?us-ascii?Q?h2ay8gEAJExVShlnW7WmCtkAC0RAq4aYZkbYRFDM9Op4ARGzju6RfojG7vTV?=
 =?us-ascii?Q?x4QQSAPCCduZbrTUheXSOj/ZfZmmPjTen9H+9ZtR9AgZG0oQlfHj+6RLv4aU?=
 =?us-ascii?Q?myh8KinXPV0PHHS3unL1l/NQG+nCTpxingMNb87+pAdPIVHxbtNhOXVq7F7n?=
 =?us-ascii?Q?+X/0qYOgL1D4HKxfDZJ0J3U7AzynqQb7cPIdDHY/95R5yLqhGzLCARQiiYep?=
 =?us-ascii?Q?TKUx4s7BgC0csgw/K6HDAqcBZs4GCBVm/6pxpRfdJZyqC3CldLklfBg4FQa1?=
 =?us-ascii?Q?IhfgYWuk/yc1oTeZJ/zYdqUu3ZCsKnH59ja/o9iOWUGiTcqkUukmMCKiCcjJ?=
 =?us-ascii?Q?L6fVibH/Lf2d7QhzOai5HwFjiBdBdFpN6QGkAfsVdVl3nAm0JwvtcwwLdEIv?=
 =?us-ascii?Q?dyAfFDhgx4cNDtUEo/AIEhXp9doRMakwe+wsMJhOhyCSHXJYd8WqRX2Vvtnd?=
 =?us-ascii?Q?tSLshhv4amJItuRPwtfR+mjL3aOTuX4j3H6ogRl/WuLNJpLp22oU4dnigMrN?=
 =?us-ascii?Q?J3vJWDQoDksGhA89+QdgRbE02TU2JavAIteq5wK+tBVOjMKtTGdIAlvkADjY?=
 =?us-ascii?Q?+nuseVxRT5zivKJy4xo8YkjUNP6UnjMXolAnlzLVE2C6rqK2+sK8tVWHh0DN?=
 =?us-ascii?Q?cDKb1qg8WhgXOpUIKploO+SUh7X++Htcxlg+BgdiEBWC8apzQxB3hJlcsDMJ?=
 =?us-ascii?Q?I31PuPmTyqcCZCEU0tSDNbFjVZiOi5DOWP8G/kKrPtw3ahWQ1KO72IecTCh5?=
 =?us-ascii?Q?GF3XecTXzb7qWssJX6kAbvQ1z8DULI7n/cI9f73GgiNy/iTIUVmtTW5DJtTM?=
 =?us-ascii?Q?l2rBt5z3wceqkNSyiyJKe5N6EbMwLIg4tNLT7sGlzDNd8p6ssiz3D0ofFBhC?=
 =?us-ascii?Q?xRhfE38K5GFI0v4tbHTUYRd8N+bpLuVU0D85ciwmaSMkcgjPMx/D5iPzuJD5?=
 =?us-ascii?Q?ojAqzRcTagAqJL5UYRMdhynBcqX3XmUqmoN/U4amxssPUyeFnqGEeg8v7QtD?=
 =?us-ascii?Q?M2nfvYW/sOOueORQRbS153vPwZH/sJVX5OiT045rfBNKoUHPMYGXFySkDtuX?=
 =?us-ascii?Q?4WFvRuwH15rLSfHDQfcCTdW5EslixEhzc5NDJhCU/r/LBdjR1mBzTj5sfR03?=
 =?us-ascii?Q?C+jtod6FLq1R/rhuZhr7wYbvz7uSueYU8ISpU/r+IcXcYvOM2orfJX4amMcU?=
 =?us-ascii?Q?jqr8Gv2FquK3WLdfue6642Yifxw7dB3/Cg55/Mpnj/JOHyN0aFjGssIvJAv4?=
 =?us-ascii?Q?a+JvxasezvaEUbWcODKE4pT7ANWUU7wR3pchzuDQW8XaFqYKzEQNhRrno1dx?=
 =?us-ascii?Q?90Iwa8NudW0q2Mtdpxc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 690d7ff1-5852-443b-0577-08dac35b400b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 20:36:30.9938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2KFDSImXeUt/RMGSB6mqTE7v7SHq5ZE8p+Ym/cpxiYFtAHaqcJD1WBFGiEqbz9cPQtyZNhGaHgAaj1K9BkOBUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6466
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > +#pragma GCC diagnostic push
> > > +#pragma GCC diagnostic ignored "-Wcast-function-type"
> >
> > How does this not break CFI ?
>=20
> I wasn't aware of it, will check.

CFI needs $(cc-option,-fsanitize=3Dkcfi), which, reported on LWN on Jun, 20=
02,
had not yet landed in the LLVM mainline (I'm using GCC).  So looks we are
replying on people keeping an eye on it to make sure it's not broken?

Even we are unable to test it now, we should find a solution.

Thanks!
Xin

