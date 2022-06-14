Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8984654ADFB
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 12:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242355AbiFNKLI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 06:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239079AbiFNKLF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 06:11:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D57D3F324;
        Tue, 14 Jun 2022 03:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655201464; x=1686737464;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dBfWQedS6elOO2eBhkmyX4mnDINuuu6QlMmxmplyGKU=;
  b=AIFXqJ3pslrzTcFbgEuAwORDXkhGh2jC/yOXaEQWerN05th8ahdO3eAo
   EkwahXTBMd345NxCiwrXukaQ/sM7aLkYqf6NFMM3VZSyjyVarXK2xjXcz
   7JLwiFMDJRlhsr2VCQWQiFTBfNABEDmJPckJRnrVhdc2SbB6eAwEFTfOT
   hKKwqDHAnQFT1ieAZh1RZPGslKFcuDoYEIId5cLw4IlREbS0vUu1Pjhhy
   Te8ELRQv6ZbYMSUg1Asj7xyZjFD6fDFu8hRgbQ8/VpG9lCzhlzOBE69dp
   CsJSrEjgGfTGi1qkFmGTo+230WEhg5XxuSymuqLP196xZULKSHiHxC2l4
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="340238701"
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="340238701"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 03:11:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="612166084"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 14 Jun 2022 03:11:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 14 Jun 2022 03:11:03 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 14 Jun 2022 03:10:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 14 Jun 2022 03:10:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 14 Jun 2022 03:10:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dkd/+AmAB6s1QlfCcDUoT4DJniTaYSj7Si+HgwU+Aq/TaX3oE9QezDBWrrF5vvj9L6t8xxBRDZHOCgQZBxJ77Bs+1Y0IwJcYdKN6roY2FbGQe4OoT2xmwZW7OmV05I6x24AyZoAbo3fBOfvK6jDyncXSo8ozc5kl4xI6mzfMG+N1KfjbJFfQ91iAf3BlP9zlN3Dko6YvlagFI1uDdZ2zpofC7vgt1QB2lq24RiBvCJe6sN/sIAYlcU+BaP8PHit4M69Rmzwi7YM7NQcTxuxBX1qHCkF3OzI+9cyqNntEpTosumqaJX47ljL3sYCchN3wfP0qxO0CoLJukB72m7vXaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pSNoXQdFhgsxSFl5ufOVBN0snq4Od43/a2fvaPWclhI=;
 b=TWZecFpWe0yR5ApVExYaic2I9syfV4grFJcCJ86TLOUblgpfXw/ymDIHUYPIBLXW33y+o/EoqVTbS2ddKT2gRsRxM1JVFeq6mkCug0FVb4ZOuaCncJEw/6M+TS0lCQnRkeqpC3AMOdkbjW7Tc0fcU29pfoCQTmBq7Kc8F8ZK+GNIIW9XUIzdm6eqA8YcsuDeMwv0R4DzMh5PCr18Xpt+x2cNd6P5ObhyXbhIV3go7XN7+P7bMH1ZRm0AtB4uAHdT02IpW4jmDSZ7A7qk+TUx1feiLaxS1JGZk34o6CYac173aqgbEq5Pd4GoI78UJZKbxR0aR2sFrt+TfFtK+wUSjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM5PR11MB1801.namprd11.prod.outlook.com (2603:10b6:3:106::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Tue, 14 Jun
 2022 10:10:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 10:10:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 09/13] vfio/mdev: consolidate all the device_api sysfs
 into the core code
Thread-Topic: [PATCH 09/13] vfio/mdev: consolidate all the device_api sysfs
 into the core code
Thread-Index: AQHYf6rtZlpEhepWiUKmFb5OZBlj5K1OrfYA
Date:   Tue, 14 Jun 2022 10:10:52 +0000
Message-ID: <BN9PR11MB527698807D278693ACFC63A08CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-10-hch@lst.de>
In-Reply-To: <20220614045428.278494-10-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b59122a4-c645-4a87-afed-08da4dee29ca
x-ms-traffictypediagnostic: DM5PR11MB1801:EE_
x-microsoft-antispam-prvs: <DM5PR11MB1801063858B4BCAB292C07EB8CAA9@DM5PR11MB1801.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w6SQdBVlo3Hy+LOv0ihfLP4NECaene4lDixezIRyDlxHlInfFBkN2xqdLaHVki6UdeIl0LHjBp6pO8mPENuH00b9jdFLCvy0PgTrjQYwy3VQshFn9dYu1H8Il3gdfRr18yzzgfFNEvtfzrLRBQzXh4HXyXiphK2Yld3CIAvlHQpep0yYpiXBhh9/dYU7HrAqu0MKJq/8WiJmF1PAk3LclkO96ywZvS5QnG5WHbWK2W0Y2OUf6Lnt/FmkCtuk0pyn7qMmrPeN9F+oAtKz1JYhYd+TIvkFwE+0Gf2wUQ13vFza+mYcJ92b/Cu4cknWF69sf0piTVnQQLM5zsaKOxQBsY9gf0JibhuowsBtF55TiRvirDOes1tdZK6oZ8AVVosacu4sxJtDP8QeSjpsvxUpTXLtlg2KyqWPxX+ARLlz+VBT1Tei6sYDmkLIf7LPdgyM2wUWJRpqfFVKfnI70XhkMcl73d/lI4oBuhJ6H8FPWQoDwtdHcuhcJRD9psiTYWb4C3WaM772Nb/h9HqDHaaetn8KEk75pnS5zZuNseXroyxqiC9bpRYoJM8XL1Mci8Y4ph11p7qNf3uRlZJuJEcxLqK5pXKVizKNVWOtheHmYrGN00CD3/vmjSixz7NLPaMp4fRGKR0hyPWp55a/Qm8hhtgqymRj2gzUsNh842/qjpnlEvJwbIdXUZF/QOSg9pG/HUyC0e8jYfkpBuYYSfnP8boJSFcd7MJgc2YkYG7rfE8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(186003)(5660300002)(26005)(9686003)(7416002)(86362001)(4744005)(38070700005)(52536014)(66556008)(8936002)(921005)(66476007)(64756008)(76116006)(122000001)(66946007)(66446008)(38100700002)(82960400001)(2906002)(4326008)(33656002)(71200400001)(7696005)(8676002)(6506007)(316002)(55016003)(508600001)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wLsyqySV0bbF4PJovE/gawd+ikCz4olmm6ctJ4tyfy7Z/P4SPbC8gU7uU8Bv?=
 =?us-ascii?Q?KNSB/vIEPjThP5QTDt5wTI/a6xlY3F6q8WpQ1N11YKrK5r+6X+o2jZO1oX4v?=
 =?us-ascii?Q?YXHDzgHIfP34FIpcL+GKh+dSRI4M7rQqgq4kbtpdzaYBbpzkgxqLC7a073hc?=
 =?us-ascii?Q?SJ4HoyPBzKRrB5GmEkkeK5NQuQN7cIz89KuKhw8x18ywiEPwimtQ72KdCgyo?=
 =?us-ascii?Q?DoP3gF9hQWLCEuf0GV+Nt7g2qmw8K/8Bk9I7D+j+eHGUdj+WP1H3HBDvDKGo?=
 =?us-ascii?Q?tBpkiWD7l0cZGO1543kCwnynKZS5b/kvH1ZLtaSrZrrsTyd22iakga3/gmMe?=
 =?us-ascii?Q?LPw3g2e6CB2CQnx45FZSVncJmjnt4qY5otDh596q3UFzaDKTKEXcOncyEco1?=
 =?us-ascii?Q?9GQywfF4SCVOASn2wZ3Fjoqn2g/n6wf/HCjLeNslaQemvdSGzXBivqGAviNe?=
 =?us-ascii?Q?GqlFGoQQeLwA+lIoYCtxKEwAi9fxUnZEyzqCzNT3WurbNLk0srI08DyZdFPl?=
 =?us-ascii?Q?J4NAu3tcytGRaIMw0HuD4XuL3Y3Ta8ds0n4+Ew4ySGhpcSBwJ9tEw2PAFBRo?=
 =?us-ascii?Q?/TW/3TLWNy5ZDN49oOiRHtX14WcPWGDym9Wb0UDfPiWN3YGE/LV2qBZMV6fF?=
 =?us-ascii?Q?aJtGBICMuK51hpu5bKQB05pd9UsRxz5vWECG7QL8egJm624A5fVdthP+lzou?=
 =?us-ascii?Q?bhk6cxur5NcaJhs0l0ZPDfnO/hh745NvkOuJ26kDy+dxKALilaZh5KgpaL3w?=
 =?us-ascii?Q?Z0mDHmIWKVn9iNMF2w2Z2iaUlkaBtgqZFw7w8IMxuXSMp/HHJrlISQBAQhi+?=
 =?us-ascii?Q?xhfeFl9BmLjm0ulv2UHBqyB1LNE9sAD7gDSFE2n3HNW4P5ChXOGOtd9wK7Gj?=
 =?us-ascii?Q?oSoccGqk0pWyj81GjbY7otQNRN0OI0yE3BbxyS5PWKp425z5e0QFaRbvhwUm?=
 =?us-ascii?Q?5yFq+RL5R80S9x7HpY9AtyVMBKCa3Te4VDS6m8k5XBC6+S7UAZ54XS94Gjgt?=
 =?us-ascii?Q?hEyqUsChU3aLL9zK33rdqMFCKXL+s2MkZuKKa/2crRJ9EnMPDoQutKlyXp5X?=
 =?us-ascii?Q?61xtm0SeH9DAflyaGKKmEGBtgRKtG04/S8nkeUjkxJhx7zzO4XBTo16OlidQ?=
 =?us-ascii?Q?91DP820sxFgEnhDYkAzz+KwFBKqC5xyv73hGOH5ERy3+oNTRPj6YYl15rtus?=
 =?us-ascii?Q?WatO65xwGbl9dim1SX0Gp1rfm3GEZyFSZnzUBazL+BLUxtGbGYSQCcqhYRAy?=
 =?us-ascii?Q?55zol6TpPcZRyRsl7csNjXgTU/upgiYLnUWxcuviPhjmC/6m8PLrXZHNddwR?=
 =?us-ascii?Q?X8AJ7hWw+cRYFN82Ur1MyI+8chLryALQMUu/jhM1gTLWallB5nc+2AtR72Pp?=
 =?us-ascii?Q?xghakwdQ6nrWhmM4u4AGMIrmdybShiMEJUboSRg/em9iHkQgME183gVkzcng?=
 =?us-ascii?Q?5ijE7ahAQPOBsYfys3cv2HY1Ccx8b08w9CdNMiZ9KZQ4oMYBJzf29H96Srqt?=
 =?us-ascii?Q?O+RWdNS5qzQUGPTL+bIdr6OhD0dYhCJQaw78LbfvNOaVXhQMACd337Dcniv/?=
 =?us-ascii?Q?IK3pDMLTO+HlZWmXV/2YHhvc4x/BFMoG2tLTdOTz1fAE+5u40uq2bBOtHSoQ?=
 =?us-ascii?Q?/VtGppAWlkJqhxP20pGefIPzvelEhbPD72747Zr5N3zNGSKUzlMOXG1xrSKl?=
 =?us-ascii?Q?+V5gRwoBgjYyICXrgFewoiuGL1d4LuyaJui1u9DymilAl9DlxISX09OloLms?=
 =?us-ascii?Q?qVtVMUiFXA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b59122a4-c645-4a87-afed-08da4dee29ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 10:10:52.4582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N9vxqyhvuaDEKBUoYYI+VAnBJzhNqOGZ8k2/sGf/pfKNz/pllue1Z9Sfoijb4OYg0D9bkvb1SgywfIrS0n403A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1801
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig
> Sent: Tuesday, June 14, 2022 12:54 PM
>=20
> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Every driver just emits a static string, simply feed it through the ops
> and provide a standard sysfs show function.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>, with one nit:

>  /**
>   * struct mdev_driver - Mediated device driver
> + * @device_api:	String to return for the device_api sysfs
>   * @probe: called when new device created
>   * @remove: called when device removed
>   * @types_attrs: attributes to the type kobjects.
>   * @driver: device driver structure
>   **/

Use same indent here.
