Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02840776E37
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 04:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbjHJCve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 22:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjHJCvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 22:51:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0ED1AA;
        Wed,  9 Aug 2023 19:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691635893; x=1723171893;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uCpPVmlveLTMPPhSJnU7jE2FDvNX91/AuCwtQBD2AEU=;
  b=iiUidUPI6aST/ENStxqseLQBAn63jaMh8KCHIudVHBtU6F5+ICSUR8pS
   ikYFKBk5QzVhPTxn/OBET8ufajzNfsi+pbpsiTA2c2q44mGAsN/sim4iJ
   bNS7EenAUVtSD8TI00KyBhLbdR87CU4pZqwv5OP3bZrjGaoWVIPfnwMLQ
   UqIV78i7bN6+bljdiq7VeiqC5cwhUgrFg5EQ550ChYNRpL5bkf5LMeZoI
   w20mi10VLaL9oYSApoIBMyGMNc7zxmbpR5gLqimBK7L/yyYU9TklDvIDP
   wZ52QF07zY5eLQKbgXv+yvOD3Hm/7YPbTKHcP6m+ewrjFNEkWnYBLy4Go
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="371276402"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="371276402"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 19:51:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="801995771"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="801995771"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 09 Aug 2023 19:51:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 19:51:32 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 19:51:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 9 Aug 2023 19:51:32 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 9 Aug 2023 19:51:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXM1G7kFq2/oWmxswfj5sndq2JJTENiDnccgVsXSz41vHRBjcWtAcz0hV8YS9r8mzUxyuJNKMv/TfQWAphOm8BG6FExkem7CtT9plTSwVpgkor2Ls0K9N9veFq/q7ChwwtYHKcslx+I+GSKXjCkQ04/G4Lt7cV0Wu8IgqEi5OVc901imWh78aRLrcUl/CnPtMW+pmjVfr/sWr+2ZeBdt6ghdxV7DaWi/WJk/H0Jl02QQqr/iAf+QV463xP3BJe20lN1USdnc26krhpS2w0PYTeRvvFaVHLpspMTLdeMD4mohyL4Wq7udARGtPBtD75mNWc2+ZHYBsPvuRNmMQbQdQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JlDbGWGNxL0VFeyJlqR+r4QKElG85ogz4Q/VU24nIWM=;
 b=Fyqigmfo1l2bXqHiQkWH+F8tqx2i6FZBkkgYccUtOSPjW+p9qBP72S7N5offQ20s11D2yj85nk0gFGbYl5FGFN0Bz1lVxlqrTb+heyGw76nyLBv4X2KTGKqTbhtbBdmQFDEXjd09u74hTbmtlViQRtr7LNuNdjmQh5lz+jmY0bfoquDT1wkbSOk92qdnoX/O2eTdmRx9RwsWY60vG1grBfMwvCqxWVLev1ZP3mizaOUsyT/NELeprLyv8if89LqYmXvObwhcjCJ7N++eLJw7SjzkvhrUeX2CVQEsDqDarHBOAyWSKyQUx6aAqe8+JxgPVe/t218Vj9Ol1zRp5e8zAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7594.namprd11.prod.outlook.com (2603:10b6:510:268::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 02:51:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 02:51:29 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Alex Williamson" <alex.williamson@redhat.com>
Subject: RE: [PATCH v3] vfio: align capability structures
Thread-Topic: [PATCH v3] vfio: align capability structures
Thread-Index: AQHZywC7EI5rhN/SqE6vo66ghbV2tq/i1QWA
Date:   Thu, 10 Aug 2023 02:51:29 +0000
Message-ID: <BN9PR11MB527660D04574640B081E7AA48C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230809203144.2880050-1-stefanha@redhat.com>
In-Reply-To: <20230809203144.2880050-1-stefanha@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7594:EE_
x-ms-office365-filtering-correlation-id: 82b432e2-f9ab-4fa5-6a40-08db994cb2c8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NsbdEFIaLzZnWFziPUtUTRiBYVkc0i2ajX0xgJXB4xc9yJpEXQW8xqE3E0HI9x+Wr6wxYZ/YlZ0SF6pGghJjazooPB7W0rVjTCZPy9cT+KqiwgihJv1YUK3FEoW0PpxupVwB9EB6/pzN4ajqutAlkU1gTUgb9cCHQa2vL01Ap8FBvE0CbDBGwpgfi+FCqyf93c3ZvmAr7PZwPw107X31t9x6xc473eKBUSj53rBWqZmfc1el2JwpWBWC3BO6l0Obq3dmKB5XevIMzxDzq+n/RxdhxAQGpeOiH1E/Bbwut9kjkhrXhhK8b9RhlVeEYm06fz8JBgCpYNgeCaquVA2xq+Ca3zmbO8iYov9hDFBKFOoXTOxZYgUfWd4WD+0eJ1zz1ooR54XWBZdiS9Dzr6Dvc40OyqleN7rgyON4+AvVZt//DQJdSazleTrrJAnB1TGflqxUJAUppqltAF8Y+VwVIJn3AduFs53vEi8dlRWtZktRr/sNG1B1fQ63UiZ7kX+SPj+u7zyofAhVsOIVAbWi27thtdFp+oR17aN9CrZueYRsCik8UsOfps2hc+t0Y23AJCgLlYPNdJvlA5QtpgH2GTmIViqycf4Jix7dE50iE7zrWVKTtRK5UAcHJ2x80cQj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199021)(1800799006)(186006)(71200400001)(26005)(6506007)(8936002)(8676002)(82960400001)(316002)(55016003)(86362001)(122000001)(478600001)(41300700001)(38070700005)(5660300002)(52536014)(7696005)(66556008)(66476007)(66446008)(64756008)(76116006)(66946007)(9686003)(33656002)(4326008)(2906002)(83380400001)(54906003)(110136005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HKP1k2kXyDiS5X8yJ8M/FGWpc4kIzzJgjoUXYMQIvZble2qlbOHGb8ImbWKU?=
 =?us-ascii?Q?Z5UgsL+etgmudtygNMNryV9uUS+QOqyPuOxtBrbPK8vbuv3RDMHQPHTMtV0c?=
 =?us-ascii?Q?CM6f1gabbehhgoMzVoTZpS+mRLKEqnubYcehKlIEH0L7S4wks5/dqFbUZVsb?=
 =?us-ascii?Q?wrVyZvfO/YM+ZBAPCCut8P1hCjPj03CkQn169P5Uos766FXodYqZcYB+S9eC?=
 =?us-ascii?Q?eKPf4xOPKkDe1NfYjj4GyNJROElpkpbAZ0YN+JqYLHWCe4Knm8pNXpV+N2PZ?=
 =?us-ascii?Q?90H0hmv6ikkghZK/drHfB3IArVo/Q3zoo3Desk96xlcvj1GpywfYvlolhu5B?=
 =?us-ascii?Q?muxW3WwCjKqh3a/ArW9S2hppKkWSz4nFZT1xKIG0fARQTHu9ked7gaPvJauo?=
 =?us-ascii?Q?ve0pbybwHlKbZpM6W3nbROxVWovjcETqmLbgxoSuzs0mjd3syAv1N3Zl6Q/T?=
 =?us-ascii?Q?VBh1o7RBscNRqixPDqwl0pEuzUuHlRIbnRYea+OmeOhIfinGNGRdqOMk3r3u?=
 =?us-ascii?Q?DVJZD2KXmtdveqzaVKIdQAmlSyRKDZjsWM9JbjHogE3JUlmAHDtzZ660DlMj?=
 =?us-ascii?Q?LN1ydL6G4BIX3O0+hMhwIQ51C/RnBnYzvg3uOKVE0ZGv8Ub585pmF6ky9D8r?=
 =?us-ascii?Q?BVTmhNmVWls20Yz5o+AJZyekujFN24Yoll8uxERreUOVKgAt0pzMLlFwA8JO?=
 =?us-ascii?Q?Mk0Kcgpauwug47Y4aTK1pXo278P5NjRrYYz7RGugQpizcuThRtudXKIP1wCV?=
 =?us-ascii?Q?fplwh+8HKKDYjsjGuvw5YPsYOVfwWDgQZbFSd/UUWYxOEMWF6XkzwenGoaVd?=
 =?us-ascii?Q?mWLPIs9f3hm55y/+GCXbvXgyr8HLmPoBDIB8Iy5kZeWHNy3m9B1AipQUuidh?=
 =?us-ascii?Q?5SeI6KUBZzS1es/B9+njd4IOiBIBma/W7sK9G/1OJsmdMnv71ULJypv/nI2j?=
 =?us-ascii?Q?hoiNZPmwVMIFvb+N0BSUVVed+pUgrM46ZLkCsT1TX0NUOnvZxL1rheZAeS9A?=
 =?us-ascii?Q?cj+fvSr6gJLtHUB6iSnEcARtsYcOWsydqjWONO6q2/zi7u3MQGrXr0vg2uOB?=
 =?us-ascii?Q?hpm3sp6d5im5j/3g2Nw6Gjbc82882vwTZ/brR7MyEdkgJHktvLKqivADpzWn?=
 =?us-ascii?Q?TdcMJRjI0vh5No1aHWLLUJSa/kE88WA0ZnZMdsegv1793QR4xq59uJpu8cQ2?=
 =?us-ascii?Q?oFJo00gHJGcCit8oTUQRx9lV9MNYhZyw9aXPQlNlEbLqr/b4lO9B9F07sp9j?=
 =?us-ascii?Q?iVnCkt2L2Rn/6kGvLwA1XFQr99Qh0/OdvgXaXilGDXJQIuigCmBoO+KLMU/8?=
 =?us-ascii?Q?f3XXPTkgmkyIcuObk/+Y0lkkTtrBZr3GLxzpTy+hg+1bExjy+TI+3kMNfUI1?=
 =?us-ascii?Q?kNsY9PVfTB03UIFYpozxdlLHvwbTwRYuzzUz7/5orV7+rfq4HwezYIbchwrF?=
 =?us-ascii?Q?nI4RUTkXIukeCQpOq3oN+n+RNwyDNLNg4T7OYPUOZJn6IVj0biru3TGGPgpT?=
 =?us-ascii?Q?1iivMg3BdQD9G4apycDzU+PAffCXuebThGIEBD7mqTGarrs+CXuLFZT5xdgy?=
 =?us-ascii?Q?WC8oURUBedGCcDW3QXzKeG0mpK6tGp5bGH4DqYJS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b432e2-f9ab-4fa5-6a40-08db994cb2c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2023 02:51:29.8710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mh2Bx71LfN3lSTbySrdSnaTaqjeKwbPp671SXiwn46qIlL45TaaOSYuwnU8axK/b2Xu6Bycizhkkk31NzNMURQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7594
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Stefan Hajnoczi <stefanha@redhat.com>
> Sent: Thursday, August 10, 2023 4:32 AM
>=20
> The VFIO_DEVICE_GET_INFO, VFIO_DEVICE_GET_REGION_INFO, and
> VFIO_IOMMU_GET_INFO ioctls fill in an info struct followed by capability
> structs:
>=20
>   +------+---------+---------+-----+
>   | info | caps[0] | caps[1] | ... |
>   +------+---------+---------+-----+
>=20
> Both the info and capability struct sizes are not always multiples of
> sizeof(u64), leaving u64 fields in later capability structs misaligned.
>=20
> Userspace applications currently need to handle misalignment manually in
> order to support CPU architectures and programming languages with strict
> alignment requirements.
>=20
> Make life easier for userspace by ensuring alignment in the kernel. This
> is done by padding info struct definitions and by copying out zeroes
> after capability structs that are not aligned.
>=20
> The new layout is as follows:
>=20
>   +------+---------+---+---------+-----+
>   | info | caps[0] | 0 | caps[1] | ... |
>   +------+---------+---+---------+-----+
>=20
> In this example caps[0] has a size that is not multiples of sizeof(u64),
> so zero padding is added to align the subsequent structure.
>=20
> Adding zero padding between structs does not break the uapi. The memory
> layout is specified by the info.cap_offset and caps[i].next fields
> filled in by the kernel. Applications use these field values to locate
> structs and are therefore unaffected by the addition of zero padding.
>=20
> Note that code that copies out info structs with padding is updated to
> always zero the struct and copy out as many bytes as userspace
> requested. This makes the code shorter and avoids potential information
> leaks by ensuring padding is initialized.
>=20
> Originally-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
