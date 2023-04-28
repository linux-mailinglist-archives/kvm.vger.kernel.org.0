Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685EB6F11D0
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 08:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345366AbjD1GgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 02:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345363AbjD1GgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 02:36:15 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412F140C8;
        Thu, 27 Apr 2023 23:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682663767; x=1714199767;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uyBC1zpQe+0M1i2r9NzqYSXBjr8m8a83YnxCfNpsOMQ=;
  b=Kb1fZKoG+4uw4M5RpXYfqkGPQuGIcxgKAD61zlWMOHqsucyUV4/FFzU4
   b193CcRSb5WUKQC6I6Pnea22nBNUuwy1PnzFsraS9F8KwXhk0ZnRHmSsV
   5XtI6DaaCRPlLY4YJQjaiFCOQnyqrD+ALFMcgNNeqKLnrTsp0XmQF0W7W
   GMbArAB7vp5RnBEXNJiBrx1Iq7f7KNgnk0MULairMXTRuRJSwuTLVAlmh
   ag3CSzrzOJQkv6UeWbM93MsVNin7W3HRRXBoNH9xbXb5Yoz+3ZyIvdwX/
   90fWDeRIdNMVxYvv3YApWjTktTkdlYdTlGr2zWiVVfjfgmmqaMvEbqoF+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="327286365"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="327286365"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 23:36:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="838743383"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="838743383"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 27 Apr 2023 23:36:06 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:36:06 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:36:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 23:36:06 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 23:36:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJ3/AoRC7ricsTUWwXd1SNDXQcDSa9MEzTFuCZuvINgchjLk+/Nr1qhBPT/iBEbDk5e6VLSIZ8Fy0/8fI1SSF2h4Jq1BfHslzmHweLx9hHZgZNyM+ZEtEQpkeSKy+SbxUMahmuLqvPfBM8r1bp+fVS+UzSaxmVUVk4TdCMK4xnWx3cJgsIhbXtJWoje4JlecDLbsKHROaHmS+6POafXLicNIFw7djukVnBUPawO6ai9BkY00JR8gsVreKqu3ad5dB1bnfJUGV1nyvsr9zMjtPztyzQjFd2YlmbyNoSYfp4DVis0zlvhPOmbU2MWoxz3Qk8cu6198sVAee+oeMhQDBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uyBC1zpQe+0M1i2r9NzqYSXBjr8m8a83YnxCfNpsOMQ=;
 b=hdjtrucQhhKgJMwv+zQCnuShzcijlqO+MrEQOXIkXVsDkN+263JgUBOye+uQMKYSPsMlKW74fYXwPz7fc4ij06+Ijjclfu1kHaO3C4GlLHFMSBKgsDDA/mNtxqU8F/yPhaxinTW5dHL/mUlSxWGg4eEHaiilidO021tOx1mfjSOBrcKnT5oQVjzxZDpuazqxpgLhg3orhSrwkNKeK+TOyMu0CA0ZB5f/dZktAglI4eO+fDMVWXr/WvOYWAEKA5udZ7P/yck+mAJVnaBipKfJ0ZA2eu1yOE4G4NIcBwThIhenjT6yoVcSyVyGiY7OmPGjSFvUMABfILajrf4ZjjdAbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB8376.namprd11.prod.outlook.com (2603:10b6:806:389::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Fri, 28 Apr
 2023 06:36:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 06:36:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V4 06/11] vfio/pci: Remove interrupt context counter
Thread-Topic: [PATCH V4 06/11] vfio/pci: Remove interrupt context counter
Thread-Index: AQHZeS7KkA78xvgKNEebs8CfOLWYCK9ARPug
Date:   Fri, 28 Apr 2023 06:36:03 +0000
Message-ID: <BN9PR11MB52761C5DBE9A609797A427A78C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <056fbd6c7c5161fb912d60b3f75e379ab3255d75.1682615447.git.reinette.chatre@intel.com>
In-Reply-To: <056fbd6c7c5161fb912d60b3f75e379ab3255d75.1682615447.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB8376:EE_
x-ms-office365-filtering-correlation-id: 2d1371e9-e246-4215-4723-08db47b2d6ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rlFNy6Yf9y/2eBY2JmdRlXZFDqWf8TkYP1FWmTpuBga9QK1+/o6rGtBPbZtwDmArcUSJxOLscxjCOLausipX0NeEu/c8hq3w7pqUQ6N3SmismMW7lvaPs0i4rEkFFWkovVAyT2JC4M/SEy0ApFinke24C0LOohspKkSxf3b5SEnuUwRci0le9R+NrYqru4ryFw3h0bx5dEcWwL2qAfjzvh0ClpENJ27GAV+MauYvYcLLkSUZDPdq8ZznvCFwWfy6DFNmAxCOFA9l8t0v7jiP4YVpa9Y4cMisYfLPgZ9MrJ0RBlPcjQOjafq/cmInUAPuTbTWiiRlZlrkZwQG4XRGunQecQucrEXqe29Kx1KVNq4tsYyOrPXqaDIl0dS+AE5Iu+42JaO61VRG2kBlyMUDm6XIQy4MwZci6BHKVn0aRdGAtF3OWLOHfrhi1EXwr5i2ZFr7xDy453Xu2ZB7RTrgGTd8LpYnBiaKUDXBKybo1udxuSfpUZ+ntBfL+CngOIudPgP6T4S0IiH1G7JclkNz9S7gHglQHmXGpegLTKnr4gl85ij31HclE1X85yVT0b5SJIS9XCt+qfkr/gTi7tTXsmAB2va+fsFgnKjclp0qsQ8Ije1s01WSzYrPMkzIM6Xo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199021)(38100700002)(82960400001)(71200400001)(478600001)(54906003)(110136005)(7696005)(186003)(66946007)(76116006)(66556008)(66476007)(64756008)(316002)(66446008)(4326008)(41300700001)(6506007)(26005)(9686003)(86362001)(8936002)(33656002)(122000001)(8676002)(38070700005)(55016003)(52536014)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6ESGLY0NdAfSlelCUZGA9F4c2nmFGQxid5m5XHwb7AVGqivwu3IF5Aw0M/et?=
 =?us-ascii?Q?8tdP0TmJCocYRPyfu71jnEedJ3REIlHWgmtE20alc+ZVijI9tnhqtA5NiQqs?=
 =?us-ascii?Q?FZDFgFVjjFmkI7M/9tPjqBvapyk1Z630DV7eM6wIBSlDKGfVBuVECLWkcPmI?=
 =?us-ascii?Q?idx/LCA8l62IemM/Eqa4n41SrEOf4l632Mxzqml0C5o14OW8pZh3uuHgtn0y?=
 =?us-ascii?Q?KSQE3PEVaTeGQfOeMsy+eP4Of55Z93YrQxXlBLmgMw3YKTEU8RT1IfNMrJ9/?=
 =?us-ascii?Q?wsRhj9xE89qcduIFHf6FIyrtDOd0PzT11SE90ViiGs1eW5JaUT4NS/gLXU2m?=
 =?us-ascii?Q?7ia0MuUy+exj7YDP0ghf+iL2z2IFiTGQd3JCFmmqtj+C5oHUXpwxbtlvMUzs?=
 =?us-ascii?Q?u/uvgzYY4UGfZ6fIiHKdAgqdjmZuc2SeZZgSuz5UTLqH4aT49WsEZKDautXR?=
 =?us-ascii?Q?ELzzp0AkHxrBXJT64oBTsiBC1kNi/F03vCdXH07t+p+dU6xvXIVW/hRcEg/0?=
 =?us-ascii?Q?wBY8PeMh2wjH/oKNy+PpbBq/i/pOBFatQABfuQLkf6btAWIxDA/Ke1/hhrQl?=
 =?us-ascii?Q?ag80bpckdAuePOrEwzmz9yYOyfzbSQRTKslBtskDbt65h6BSw0PJDFNhi60l?=
 =?us-ascii?Q?1lhTPFbe1mHGBdvrM2vmA/7PTwntd887UY3IOmcY89MFK8aY1swCuQFbh2xw?=
 =?us-ascii?Q?xV8/PkS1hkrqb0MQwepJhas2ZCl68mNpCR1SzT3nh/qNIF3uKgkFml23hxLX?=
 =?us-ascii?Q?A/WCysGd/LKeFmOWgbJgeaQBQmGqiZPoYHCqqWg8/hLFvvtBniADGShjg4q0?=
 =?us-ascii?Q?N8DdhnSNfg5UR2VNOD1ycWZZTlSkE8PC4IjNT4hKl55RNhJq1Tr9Xn92nyWy?=
 =?us-ascii?Q?oRDXXVzbodQqKhKfQJvEbYVROLvMB/U1tR40CnA5UbDhtcFMcK9c9Eh+1b+6?=
 =?us-ascii?Q?JlxlP7BB4KXr3gIoutEQH5myRwfvVHgbJmaMsnaTeTBLfO9LQ1/SWcBRANoc?=
 =?us-ascii?Q?3Dd1VAE/dpiLfpWBFgxkMDVYp5Nu3ixZXzowGIzoh2d22fH7Lis/sUy6c9lI?=
 =?us-ascii?Q?DB6Q5vTvuVS5UscZW0qdrkgZs+MeapyhrWdpaT/GozXAl+ejWmonJGUPoc7W?=
 =?us-ascii?Q?5xszHkuxkkuv9QAVpU5ty4ei6KFZIRqxLWEAtmRGdOG5YoGKhTlHLcDcPV4K?=
 =?us-ascii?Q?Z6tHJJfP4mDCQgv40axOUBsCd0iJYHCva9AXwpxn0KqSYReVH6JlrZQneTuz?=
 =?us-ascii?Q?6aCWwuELiAR4fFMdCIJNmcRsnem6Z63/8YQG4ufEvP/XF2pxm3+KqRFm0vpe?=
 =?us-ascii?Q?F+1Xf7BFbUKJ5hI4324mIMRjEGRO4BTOxbUF326MKtbrO3eipBXjCnyf7xnu?=
 =?us-ascii?Q?grVv8CAaJrgEZv8fde4CccxCZXHvAZP+DJNh8FrwZqfRSW6c+M8RtQpBsfKH?=
 =?us-ascii?Q?0N69gO36EtsIpTsAWTSNTZLoVdCEUGF3G7v1Uo8bynwJVaO8D6lpFXl8F8UA?=
 =?us-ascii?Q?lI4DD/A7FG9+JZ+7XxV1THDp1zIF3IeDmSrNFJuMgpBaqTSgLcqWxgIIAwaW?=
 =?us-ascii?Q?wIll9d0T0rrMJ998o1RJ6Jxg42vY0xlFaKfc7MkG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d1371e9-e246-4215-4723-08db47b2d6ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 06:36:03.8160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SA9vMdZvZ6prYjXJ+w+DSI2Ti4WkCe3WNAJuNREL2H+bxLBMK5bfL2spvLrjndoj60/M4TybeaUjwgl8FPVNiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8376
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Chatre, Reinette <reinette.chatre@intel.com>
> Sent: Friday, April 28, 2023 1:36 AM
>=20
> struct vfio_pci_core_device::num_ctx counts how many interrupt
> contexts have been allocated. When all interrupt contexts are
> allocated simultaneously num_ctx provides the upper bound of all
> vectors that can be used as indices into the interrupt context
> array.
>=20
> With the upcoming support for dynamic MSI-X the number of
> interrupt contexts does not necessarily span the range of allocated
> interrupts. Consequently, num_ctx is no longer a trusted upper bound
> for valid indices.
>=20
> Stop using num_ctx to determine if a provided vector is valid. Use
> the existence of allocated interrupt.
>=20
> This changes behavior on the error path when user space provides
> an invalid vector range. Behavior changes from early exit without
> any modifications to possible modifications to valid vectors within
> the invalid range. This is acceptable considering that an invalid
> range is not a valid scenario, see link to discussion.
>=20
> The checks that ensure that user space provides a range of vectors
> that is valid for the device are untouched.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
