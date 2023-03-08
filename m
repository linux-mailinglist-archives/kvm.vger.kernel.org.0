Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE9E6B0955
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 14:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjCHNfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 08:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbjCHNee (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 08:34:34 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CF2474D5;
        Wed,  8 Mar 2023 05:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678282392; x=1709818392;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DmNTXMhMxFZRGdaxbDYutvAeRzEleiPrpCyBq5hsWHg=;
  b=VTr/6SRCnHlHkFJ6AvuTF6znu6/qQrjXF00sIEoYlYfddY1w6MOzvn0a
   iwd+Rp9GFMjIqpK2rUon0UPh8OBoR7zgY+boJIl4Hu/G8NIcb/37DXFwN
   IaqnTuMlChX9g2o15jHYhxEJ9K5WeLaXOoyzlT/Wbe6voCbcVs+Blij+w
   2iFIkyaLYwrRNxpG2pJtTWF/Hd9F1wv2dnB8HerWZsD2ZsJRUturXtIC6
   f5wnNP7QR1osjjrmAB1khePKqEP5oD/T4jo/vN65zv4spwMWzMfUVtNMN
   GIs9lKOM0v2DACI5yxVuqNDKP/WZTeFXY7v96hl5BfQswKHM1lpJoAwFM
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="422419339"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="422419339"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:31:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="851083892"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="851083892"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 08 Mar 2023 05:31:08 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 05:31:08 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 05:31:08 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 8 Mar 2023 05:31:08 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 8 Mar 2023 05:31:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U1wDMR7xBjt9v3xt15MDfw9N7cSJqyrClyZgqvDC/6RWOS2S+YMLjZaLxoWiEl4elNiDIC8snLbC1GrDomavjA8yD1m3raixlntLh0NdeJDx9FBxB7R3V8TdLoaieEng0whn5vhj5amBa14zejqQJdmS6q1rGXJmeDGGTA/X7tuvzC5BJZsgl3H3HyEgDjaI9QC9ieYUMdHTQkg8PdtuX56Ua7Qypa3wy9SHenckPAcCUtn6wmpLPrFuHS4JjDn2pPPrG0NF+ygjAtiILDRR1Rlq6HzMfoIM1c8gjlfAceKj9FdS8rYpK7HzaJqSfl9OspMO4m2R2UcMoe9I5TQq9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmNTXMhMxFZRGdaxbDYutvAeRzEleiPrpCyBq5hsWHg=;
 b=Qjr7Zn8iFUEBICZrvAzfhLliEVL+RBKFFb4hp4GC3h71lXxf5lex2aU4v96FkQNoWqY4v1uNnzsYzqp9ZAVfxVLxeW1IhScN52O4zwvO1NRqO6ZncPA8k/hG3GAg2D8dBYIw0nxQdiIJmfhkvhMtMl1K2U+OMqgikMdQ8fDg1/yBqN/mxNr1wmTlzxN3uRM24fXR6vs2c0Dlzfl+GEfhZPeL7+Pq2b4LOQxDoAPRDSbgVuvnIfK1GnUvKy0QZC7TID4QT2Eidn73Ik2hG+9+7U7N7f6DHIZElHMS5fzsh4kWjFAyf7MHs8yn7C4ZDmp+qTcfLDPmfp1Bz+BUSEkjnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SA2PR11MB5180.namprd11.prod.outlook.com (2603:10b6:806:fb::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.29; Wed, 8 Mar 2023 13:31:05 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58%8]) with mapi id 15.20.6156.028; Wed, 8 Mar 2023
 13:31:05 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] KVM: move KVM_CAP_DEVICE_CTRL to the generic check
Thread-Topic: [PATCH v2] KVM: move KVM_CAP_DEVICE_CTRL to the generic check
Thread-Index: AQHZG4HNZXzbfvkhhU2c8gVAer4AQ6668zoAgDYlsJA=
Date:   Wed, 8 Mar 2023 13:31:05 +0000
Message-ID: <DS0PR11MB637380AB654417B99D5FD590DCB49@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221229123338.4142-1-wei.w.wang@intel.com>
 <Y9r2AGx2vR8VW4cC@google.com>
In-Reply-To: <Y9r2AGx2vR8VW4cC@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SA2PR11MB5180:EE_
x-ms-office365-filtering-correlation-id: c2e86e29-e2a7-45c3-10fd-08db1fd95e4a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: svBA9lCvb8eL+QwHn7QeB7ckLFuM4NQegNRHwixfEIkwrmBXL8cSY8MB8Jyenp8jZy+WuYC9yzXfxjpfPcF4JxcnAcRkvQhTVQFV/q1sDO4FitM5u2zVI8lMGCE/0xIrxpNBwWDqPn7+B5lrAnfDUwNVbYaUfNwmDRLYc22jtI2RWloB+RTOZhbn10K0JaEYrJwmJ2azHY62+E13pi5Pmq1s2HxgOKDyX7RKqVpqGLl5I9mQTSL+LrJ9RsoagJQJk2J6XDOoYbhB7rwnwl+k683/hKqTYYOi2JutgUAeY7qMBTfiZInlJsjOw2jUBtXT5hI9MrwOFG5XPfuQEzQj+hr/QHIGHj27f5g0XBFN3I1+Izgm7jmPHpQ/g5zxVvkfDF6/ONzsqcvVniwfAInOOD1Bma8D05acHHG04zpPdho8TLmidLwlMmrKhQEdxdsjgYn/YOtoY89ljrducQ/bUJj567lf81sa8ccD64mRNa5fYDfyqrrclKFIgzaIPixpkVa2mqAl+5sH9Tg/6Z7wl2HVmzIRvP2t7C5zQhnVfurqLG9C6+YuzAAJgp0au/o9vwntdI1Drzw7BzDR0blIVvt3pKoqvt2N+CmlbKyFaxAAkWadJdx5mpMdrRJHXKTLmVQIYllkXzSHbBe7qaCEcEX3UYuaLGxBu+f+BSNWb8Nhk72ip3aS1E2ZJz0PXA16wOXbWaWmhDu1BJji9v+T6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199018)(2906002)(71200400001)(186003)(26005)(4326008)(5660300002)(9686003)(66946007)(64756008)(8676002)(76116006)(6916009)(66476007)(66446008)(66556008)(7696005)(478600001)(54906003)(33656002)(966005)(86362001)(316002)(38070700005)(55016003)(6506007)(53546011)(52536014)(8936002)(41300700001)(122000001)(38100700002)(82960400001)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?U3ymhsD338avN3FdCYoqiu0y2y0F0q5YDpSmcXosdM6RsuwJhX2sY64M+H8u?=
 =?us-ascii?Q?EKmP6ioM2B1Z6gBiwicr2GSPOpgb+W8UBAcEYzEmtmjrgYGMx8TlHQwO28C7?=
 =?us-ascii?Q?glygwT4jsArXTuRpF4N6sb7wSknz4S/myGfWMjgRXrG9BGspSNKJf12c/hK5?=
 =?us-ascii?Q?bKc9Za0a9s1lE6vY1wHor6RHgxbIv5o7Cm7/BEvNMPXi8+tjXdo6X9x1scqZ?=
 =?us-ascii?Q?5AbiGo6IXILpVtjh9qc5omWT85cytu5x1vT06+PpLPRq6YolwXixzERp/4dl?=
 =?us-ascii?Q?szySzQZ6o5qKH0iWDcgN8ex8722Z21fnGat3Azw3gYyFKxGcmMImuhtJghuK?=
 =?us-ascii?Q?QJbT7wqGeQkEaha/l1KDHuQkTSTR3ViYznQUk4sYVv8g8Zv8/g2wXm2wyeRy?=
 =?us-ascii?Q?8gmF0iGy/lDZ0rQXbaISd1uKRpEHjMvwbIg6eifM/4JQtKFjefpHtkrrFkA5?=
 =?us-ascii?Q?Cc4TMFEAQ57wdlEu2yK0qSNEt+4i0uX7h8BeAwTPtk5c74+uxmZFZY27xbJf?=
 =?us-ascii?Q?KAJXdUn5uYDE+ktC6jF2CvKntsQBcu9dJL1z+sMGDbuF6u4FpoIHaxnl99KP?=
 =?us-ascii?Q?TmMk16lvJBczBGlXmS4vRUpgy1olhiWBuM8JpO16bIR0MaC+iFGcs8JhaxIK?=
 =?us-ascii?Q?WTwV7ESXEqU7RYOp254KYQNF2Q7rddWN8CVkNXZfhxptQ/yhRz19wsW//GFf?=
 =?us-ascii?Q?PE+46m0ZL2Y4A2p4E5PnfLj6unZIcI7YZvrcLV7rGcYaIczMBhgoxUkg+RYM?=
 =?us-ascii?Q?tff1ckM7PP6+edCn0ivqnleDH2A2A/GWlBWl+ua1d5ixHhbReRV4v1Vri4Ui?=
 =?us-ascii?Q?E6GYTd9dyC6Au78SYQEyTP1U2eoV77LQxpOj+Eh65VhmCBi2dk+15+Id+ZvU?=
 =?us-ascii?Q?cbkP7qnHYD4W1iphLizyP1DKvu6bjPX67oZ3S8T9wGozPKOL495kqcbQ4qo4?=
 =?us-ascii?Q?q2+B8ZgeFYERMbS1y19HJKx/iZ15jfYjbl2f5s+c4T0jDkg47ayx292OF1qc?=
 =?us-ascii?Q?0W7fLwMsbufIOx/5xc/OifZ8ZQOqz+sgeAceY79dSVe8C1bqP31vW48YUHJ1?=
 =?us-ascii?Q?ZZUxzySzhBm1YIqT36IMLtPM2/74VCKVcgXnOHtol5TAFphhT7JxsgFoMAPb?=
 =?us-ascii?Q?GHBzdyOZQ0SFPQJ5ApX6UO0hU9YNuN2OGBfHYnkA0vqSOiNF2MS7ZPOj8OKq?=
 =?us-ascii?Q?7pKTAdQYYWWWX2FJWEi/l8Jcj7/KcswPDcwVxZ9/GEtjCpNBpxEcjFAynJVM?=
 =?us-ascii?Q?sBTEigXNj240VhOA1zvthR4KBnWZE02epFbG8hkGfCZNy1tsCigGQRyWUCE0?=
 =?us-ascii?Q?JOoJ6DpkDwX6bujU4a96Cnv433jbVyNV+O9swBClji/krf6RRymBIEPsM3gO?=
 =?us-ascii?Q?ki/qbdwGWlTsPx3biu1gloIpqObqATQ8v5cA2CpoaQ8UkL1IEuOUJ4IiiSf5?=
 =?us-ascii?Q?gfsyuMKRJP5WDaEClATnUKc7/oQsmkdvxRnj0UIYpPnVlg/YsHGT7ROxVHWh?=
 =?us-ascii?Q?3SCAaX2/goCGQ87YWxHRweJsL0KC4NfYyDCAz4v6TdRDREK7AdQ2vPGqG7/A?=
 =?us-ascii?Q?huNeu5nORCNWMcVJXatAPPwj5caSN15Bs3fka9BB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2e86e29-e2a7-45c3-10fd-08db1fd95e4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 13:31:05.3177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k8q+yaeL/5MC08GtOdSgu0zUCh//yDXVqMGem9VdqsTaTuJbDmyRdbgNDoCwPg8/o6YtP2Hqdi3ddOrSyW5QkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5180
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, February 2, 2023 7:30 AM, Sean Christopherson wrote:
> On Thu, Dec 29, 2022, Wei Wang wrote:
> > KVM_CAP_DEVICE_CTRL allows userspace to check if the kvm_device
> > framework (e.g. KVM_CREATE_DEVICE) is supported by KVM. Move
> > KVM_CAP_DEVICE_CTRL to the generic check for the two reasons:
> > 1) it already supports arch agnostic usages (i.e. KVM_DEV_TYPE_VFIO).
> > For example, userspace VFIO implementation may needs to create
> > KVM_DEV_TYPE_VFIO on x86, riscv, or arm etc. It is simpler to have it
> > checked at the generic code than at each arch's code.
> > 2) KVM_CREATE_DEVICE has been added to the generic code.
>=20
> I think it's worth adding a link to the v1 patch, as that thread provides=
 the
> context for how KVM ended up unconditionally advertising the feature, e.g=
.
> instead of trying to be more precise.
>=20
> Link: https://lore.kernel.org/all/20221215115207.14784-1-
> wei.w.wang@intel.com
>=20
> > Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> > ---
>=20
> Reviewed-by: Sean Christopherson <seanjc@google.com>
Thanks.

Is this patch ready to be merged along with the link or
need me to re-send to have the link added?
