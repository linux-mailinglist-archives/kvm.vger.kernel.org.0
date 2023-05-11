Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73566FED0C
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 09:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbjEKHmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 03:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236654AbjEKHmu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 03:42:50 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548D41738;
        Thu, 11 May 2023 00:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683790969; x=1715326969;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GkjUIWoL8dXjh/VAwrpH1nvwi6o8tqhAdWK1cOpasKc=;
  b=J9iyVfkhIPBQf/7PR0agpPu9LXsSKvT3GKWUajK2NLCDwrECqKsGLJv8
   GhmtYqyXEWgCcrElWY8J+HoSZOeBnqr7WObwoOoRAu1sQhRY9A+JbCz3S
   0klRIb3tInOBoSVzrGg9/c/AToaqge+1x5Tbj7Gyq0OQgnEn1j3LF9SoR
   y2QojTC7KSOlKb8bqeI8MacmaTpXiAu8/APQhL0Ls68FvlzUm6ryitvgJ
   zFRDqTlB2WnIRHBNIMXmEdmmAd/j9xmpyTysX7ZbMHuJYta1ezgabmqll
   OhovfGfCoQ9AFM3x3+lMxvoRHyBG1KFbDH0mV1O3EWejAAo74tOjjp5IK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="330048471"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="330048471"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:42:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="873865594"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="873865594"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 11 May 2023 00:42:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 00:42:48 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 00:42:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 00:42:47 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 00:42:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+x7o2O2+hcwOzdKG0wt41CZUeZtUB4SpRRSkpN/MH5vtqYY1pM6Aq0yepay1w9htsXIQgTj7QiX/+vIp2ObAMFd91i/ZbdclxfycNnI0gQX+/7kSNh7DBxXbDOCoUEyA9I4ZjvgiSdp4qw3zifB5hHv9/SDrJs07I0C8uNSCGA6olUvr9mw7siVY7o3eyvJQsGI1x3Yw4OBD4jnp3AcmZDKd6LeEQD/wpjHhNQTPsRPXxaKdVSJ6Q2neUSD4cXisGeu08jlzJWasDnRcJTBVwkkvwtUcyr519ZjAUZLUkq50wobETBD0D7ov+ztdBcjWzCBZJwiMFx80wHh3hSwRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GkjUIWoL8dXjh/VAwrpH1nvwi6o8tqhAdWK1cOpasKc=;
 b=FGMZlwIcLGvuL7T8lCaIZOFP+umf4nKU7pU3ZZyA/uvvKwU1tUXfdec0VcZjN+UpxMwqdcmxtNuv7ZbLqE2piCMxIjmbi3SKgPkt29HQQUBqn4O/TfXX/OpJj9woHWVmgYow6E8xdW52ZxgF4JXguf0yIzfgDXB+CMSVfDowQn9/q71m6GnwVrRob8ugpTTs17f1MtnXXc3I9IyP3R69Dm66djsyr8BfEw0B1CSpkpzTBgbYsdqejD4D9fYY8reyVIet3V1oxmAObjHEqrSPcPYuo1AVdGG9bx4vCdK0wIN0hOIDNaFZelPY//5Y6AEO9dHZfvbYf+mgyn6/wblh+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB8144.namprd11.prod.outlook.com (2603:10b6:610:18d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 07:42:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%8]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 07:42:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: vPASID capability for VF
Thread-Topic: vPASID capability for VF
Thread-Index: AdmCTgezzTkHY+EMTOCoyMjynB/f5AAeawOAAABU4SAAALJtAAAAuuowAAH+6IAAAPqjgAACPuHwACb35AAAFqRBEA==
Date:   Thu, 11 May 2023 07:42:45 +0000
Message-ID: <BN9PR11MB5276AE43183A3AA6AB806A398C749@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZFrMneCMKuCtu7JF@nvidia.com>
 <BN9PR11MB527627F407BB2942ADFF800E8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZFrThMhUnsYOE3WP@nvidia.com>
 <BN9PR11MB52760816DC23D5322A4318228C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230509183111.6a4a7f39.alex.williamson@redhat.com>
 <ZFrsYZPRpHqVyjcZ@nvidia.com>
 <BN9PR11MB52765638CD15BBDC762100EB8C779@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZFwA9vAJAaoUi4xE@nvidia.com>
In-Reply-To: <ZFwA9vAJAaoUi4xE@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH0PR11MB8144:EE_
x-ms-office365-filtering-correlation-id: 74afb78e-b048-43cd-a1a5-08db51f34f9a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: opQNODrUJskZgjvs9pFZ9icfdxmhQcL6/nmVS5vwlQHTeqt+pjW2mWKZ/iZ7zmEyLUo9XJIsYIddz7s8Nwz1Vg5HYMULeeT2erH9f/dkvu0pnwhNahkETfdJxTYop9tYtKfro53YTj2L/nsZd2k0N8t8pm9B9rba8kF70bwJhgpdiTB3Eo0jUtlvnraI9x6c3A/SAVWB2eNfTQme/gDlQMIPrkT8CoiR8Nkx0y9mwEXFWHFufxpm9Q6d/gZ+nOZxWsKGry/StHWMQBH1rqGDOvf0x8tUhQxgZQ02YkYOgYoA4aGNXCeqSZkcdrz66MQwKXl53FbcE8Eo16SBs1Z67vGsjgDdwjI/FinKmnHx+z3U2Od7GxMR5onmoMj9EYQfenm33fsUls8aqS1h8fFCZJhxuNCb0PXZPETO16B3uvivij6n9xYGsPBQA3vBMqUFhyIrxd2/il13x9sg/T1sAjiSm+GL+AbdW+cULgTpiWsT7wSnGRleXDlnSzaFxN3bye1st5TdFVYBGQs/HuFtHaX+pFwx6Kzv/8vCo+mxHtAcMbmTppihIuEWYlAkHkGv6XdCr5BBXgAIpyMNc/5o0qmjNNiace8RNlOLcnkLmbiYfFFRP9koY1QwfdgSBiph
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(136003)(366004)(396003)(376002)(451199021)(54906003)(6916009)(478600001)(3480700007)(86362001)(7696005)(316002)(66946007)(4326008)(76116006)(64756008)(66476007)(66556008)(66446008)(83380400001)(8676002)(41300700001)(122000001)(33656002)(8936002)(38100700002)(38070700005)(52536014)(55016003)(82960400001)(71200400001)(186003)(2906002)(26005)(5660300002)(6506007)(9686003)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qH9pYjb4d/IwRhL2DqKMXT2R+V8Ze3+FgWAikctrk1orgso7xuxpc0nDNSld?=
 =?us-ascii?Q?5/lD+mVq32KweVDjSc6solrfqn7FGEV0D9al1wMlcMSmDtJfIdyFXXWv4oIL?=
 =?us-ascii?Q?SbliN3HxC0ieeSOkmMOMpL6FtTziGkvMdaaqMvuTzDQj9CY9q9LiE+qSXd1A?=
 =?us-ascii?Q?idH+aJSZPyqxtS3r1lOcbp+mgb7XLTorsCYidznYvmyXtTqsQWGW0c9HdgIk?=
 =?us-ascii?Q?D/iIae+y+WuNg8WhoSXuV3+pgEki9QA9PfaZHsEhpYMzjAAXgUpX9dC+754Q?=
 =?us-ascii?Q?f32aVyaByoZgufiA3IgM4eXbXOwPfcieGtC4oDduGfNPThA1D0cB19h6Vnho?=
 =?us-ascii?Q?NbrwZ9xyNt6gg5BCFWZ9MkYy3EnNsGpYHDA+p6r1TdePkxmWHWelpuwQGYRG?=
 =?us-ascii?Q?5oRXRlGsZeT7xaKygRbuHC6PmzrYf1U4ftW6nMc10RuzL96Cyc8FO00dY7wv?=
 =?us-ascii?Q?0WItOuOrvcDTWgLV1/SyL+sI1IwVqi2D9HXwtjV/Pfz6625vHNAlgFGYyXvv?=
 =?us-ascii?Q?4yico2aPlttoI0Nex840qdPGP16mqHCv7J6VU6di756qo5Q6u9a1wefFYeRw?=
 =?us-ascii?Q?HkcFT6y5+Ab/zK2W3+y7ELAh9rK8+pVbet0Y2W/cyFFQsosPcXCCSYI3yW5W?=
 =?us-ascii?Q?OmMU5gnGCftt8sVJjFgJP+Ydk+wmnX+0J4WwiNb/k+Y2E/TpJeiTbtIWiJO6?=
 =?us-ascii?Q?ve9Aas+4U6tco6Pgkep4EIATfFJSP9NC0OGGdcE5r+ZQRaxDBvO9OUTKFfAi?=
 =?us-ascii?Q?RMKpIvVRWIuUS2Ox0JwV9anaJeVKU4uJRQFzZ7C7YwOZSIv8qEljmfjOPcU/?=
 =?us-ascii?Q?oOyCPJNDOdVWOwh/mJiemDaxDyk9FEU51nHKKt25/EMK5zgBHWuMOYhiXHTK?=
 =?us-ascii?Q?TNUiiy3bGWwpY3byImM4jaW41HxTpEObhUsGknHH+Kq+qUXJksLwFETu2I5U?=
 =?us-ascii?Q?sLnA/+guR0bcYhkQ4xMNUejIyrptKJmPBjlcqKxr70Ys60NSIlE+RjmbOeDN?=
 =?us-ascii?Q?lCdFkoYQNbIQZHuFEaJExGViVOnVeBdFW/40XOPU6yrpDv31+ExDjmkDvGE5?=
 =?us-ascii?Q?H8+AvZL/3LaZkBlNEy4AgVCbkCSpsTHONKo5tftgv8ll/zVsvO8P0HApqn1v?=
 =?us-ascii?Q?VR1LmWEmp8w3xC1Zuh6ulnjbjxojLVRspy+0AaeKOG4vpgrFR3h2wvbTOFhl?=
 =?us-ascii?Q?0vXz7wYilRmKiWTnO+xec2ekr4E8SClOUcyqP1mJidpyydVMT7ADfr7oLukg?=
 =?us-ascii?Q?aeWFqy/1uFuAfBjUOURfAGKRemwdO9N+ZTPgSWIAGgeQjVDVjIiiAM3ncbaO?=
 =?us-ascii?Q?BAa8YvCkk3v8c7bB5INmnrW8XhUSZqDeFbPsaBLBAOIQwnLSwfhjtonl/rg2?=
 =?us-ascii?Q?OOAjoRQXx8JRNnu2e03FHKTFj4oc3nd/jO2QbZNtZOi9+nZI0kQjN/goBOz9?=
 =?us-ascii?Q?98lsSnB/6BsSFi0BJei/JOCwOZnGThXDhNsA8LWVjHxZLFT79XI9bPTY/rMH?=
 =?us-ascii?Q?Bg81QudrTiSi9p5vgUI7otko+wi3/5+B/SQZA+u7f+O8AjYLAtpNcqAfF+ve?=
 =?us-ascii?Q?nNUfPGJ0W5IZQBzLcWofOFLRzsK/TFDYPfXtAYZS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74afb78e-b048-43cd-a1a5-08db51f34f9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 07:42:45.6965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AXxZHAxAGZ+LeK+aKABo+cNwqvVMK9FdRBg7Xu906SN6yCLJit02dTL25IUi9sDGlp13phCyUzNWcUKTPZzpRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8144
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

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, May 11, 2023 4:39 AM
>=20
> On Wed, May 10, 2023 at 02:16:05AM +0000, Tian, Kevin wrote:
>=20
> > We don't have a control knob to hide/unhide a specific PCI cap
> > today. It's hardcoded with proper virtualization policy in vfio-pci.
> >
> > Following current convention once vfio-pci adds the support for the
> > PASID cap it will be exposed if present (for VF it's the presence in PF=
).
>=20
> We probably shouldn't do this - the PASID cap should only exist if the
> VMM is actualy able to handle PASID throughout, and currently no VMM
> does this.
>=20
> So we can't just have the kernel unconditionally add the cap. There
> needs to be a negotiation with the VMM
>=20

emmm. if that is the case probably we want to convey the cap to
userspace in a separate interface. I don't think it's a good idea to
give the user inconsistent vconfig layout before and after the user
negotiates.

Probably a device feature? The VMM calls device feature ioctl to
query whether PASID is supported (together with the pasid bits)
and to enable/disable it.

This also allows the user to opt whether it wants to manage PASIDs
itself or go to a simple scheme to get them from the kernel.

The VMM is responsible for finding an offset in vconfig space, e.g.
adopting your suggestion to find a gap between caps and block hidden
registers on a device if vPASID is favored and add quirks otherwise.

