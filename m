Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DD563FFD8
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 06:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbiLBFfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 00:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiLBFet (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 00:34:49 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10576DC4E8
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 21:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669959289; x=1701495289;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MppKHvPe3ien4lG7dMptFiuiG8E8Sxx1Eb7JDb1rYzo=;
  b=da5UBcXAh1NlZn7klNlG/PvASvor4IPkLCJwiGupij4vClnzu/Zx6HVw
   NFLWcuMNv21WFtrHLA3ldCg9HneWe9ohV6ojpF9ZMYy+Gr+TJ8LDmTMtb
   ZnUJKpdzfhQ1ODljhtcBte7v5nDGsKt0Fm6YCg92POodQMSbOayu4VhaM
   5iYD7j59mEZ+cDGU73S0k2VVRqxIeyVLliunyn9B0v0KwJhCEOXv5lAzx
   wae2obmJiePtHXWmKVNUAu922dOD1j/SH63THRg0GHvlUkzdCUjxKutOU
   LhQXWwGzPrv8/0FN7hwKe9mQvEblx6Z1z4QrhznqF20LIeBMru45SErSQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317023954"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="317023954"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 21:34:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="644911582"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="644911582"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 01 Dec 2022 21:34:48 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 21:34:48 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 21:34:47 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 1 Dec 2022 21:34:47 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 1 Dec 2022 21:34:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QUKgxKbt17wgoI+4yAF4vt9xaVBx3HzREOucjtmnx7nzwQUI7kEdeBWOM4LNaXnZP+AkM9CLxqp7N9joWNIk12bgGz744Oz4+TwQEYD/bYZZZ6CwTRuK/4q0jAlY1MoRVtkFe4PqY804HO6mR4sXUjO4nf+fXTy8Bs+/+AvUPcZWxCFXspr2crKu4zKDNc4W1L1kTiCgVlEIfaz3d3uR4UD/xlB3r2pdZ5ndYKjz01rzrCGUUthMh4FS5HvLv9TZpLC3XcctoW3WpY5UYsAFl3g7Ua+eswsU0PHIXqKStMZfI/HoGUCdDf0EKt/khW2DDI+ZLG96C7qqka6Y6N1N1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MppKHvPe3ien4lG7dMptFiuiG8E8Sxx1Eb7JDb1rYzo=;
 b=Jg/Qq5byDf5SXm5SLQs2p5u4chc3QcMUzy4iDRUg+MKuMqYmxxhQGFt+bU4nbYPGbmlbshAFGQC5YSijbP9Qj5JTNhwLGc9D80ysWUxOZhfbCiacfhKndfxifjYnllcO22LKbO9JOBHnP+j+DgkpG7hFmzYaJF4wkLHKIFw2t6diiPEbsYeOkdj+60t4n5EBgWjDNwBPLirRhaa6fNhtv37XsaP7zSvtaMk01n+QEetQA280sgH5cXLC+LOcUf/poy0PyhwpRH2ZtEGrRNkYaJKc5v1XcsNtkP7hdGdO8MQzgM+izk/JsKgLRf9ukQrlO1gxsbpeEpCqooon7Eux4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB4994.namprd11.prod.outlook.com (2603:10b6:303:91::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 05:34:43 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 05:34:43 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>
Subject: RE: [PATCH 04/10] vfio: Set device->group in helper function
Thread-Topic: [PATCH 04/10] vfio: Set device->group in helper function
Thread-Index: AQHZBZUK0MbXm7HYAE+7ugoDXw/D/q5aFEpg
Date:   Fri, 2 Dec 2022 05:34:43 +0000
Message-ID: <BN9PR11MB5276C647C2AF007458197B768C179@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
 <20221201145535.589687-5-yi.l.liu@intel.com>
In-Reply-To: <20221201145535.589687-5-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB4994:EE_
x-ms-office365-filtering-correlation-id: ca4be8fb-db6b-4cc2-f8f4-08dad426ea5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YI4r5h4a2LdXmOxHvdxmSRSNgA6fR257mvC1SPtUfmVRa3pyDsF2aFaB8hQgUY+Az+40sbgAimbzy5jHyyV+PuweiYpapgo/L9at9LnwDIj+gPkd8w2eVoft/ZKv5FiBXYZ1tOQIVNF6gmrFQnuWeC7V7VweA3d6502zZ6Z0KpOsRHk6bNXdg4DqUl2zC/9vJzA/xqCv1ufyo3CzF0xntwUFMBa9QboeLG45BEYuJYw7isAJa0BaiIsyD5/FG9odSeSl6sDXwcRyx5OgWxqJBEdQCTbFdAk5uG/ePJ4L+BWgu84X1JNwU3nKXhHwhu6PF5To+fF1qNGTKRFFs3rCO4tOpL5uBTn7Rv1LCsRxfaJJutiv7U21+B1Xu03Mz0AkfcBnnffZgy0XfZ4RZJ3kSrvepdm8KnX0KXgqcySfnm7aTC7GLv56JmmY9u49Sdf6Q9dBQrmagQJt05DVRn7ZL6BL8ICmnsdXEblmr/RSxjskTNtXuKNsiJLJIYqrnHCm9pS/brDLaLr5IC2hNXGctchZ+r9sIYYBxppsO84z8fvff5PYAJoEOcfSY/brhOozGPuoqNstOyc0kMnzAA8XgIPAPv4usXqHhP79bZMaDNp0K6Q1FgsX79pYhNFRkGoHGSfaLz5bfY6Y6bVkk/N4Vg/lRozfC6vErQDdVtI9H0aW4yLZpZmfaq2KkTltRYoi1+f1h7lErC16J6PkIUcV+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199015)(54906003)(122000001)(33656002)(316002)(558084003)(110136005)(38070700005)(55016003)(86362001)(38100700002)(186003)(7696005)(26005)(9686003)(2906002)(6506007)(82960400001)(8936002)(5660300002)(71200400001)(64756008)(41300700001)(66476007)(66556008)(52536014)(478600001)(66446008)(76116006)(4326008)(8676002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8p3BFlDjI624T8LVma+y3b/3/EZGSZ4mHZqlzxZcDaru8y7q6SCshjABY6yE?=
 =?us-ascii?Q?VO6kGWe6fB++By6/jEnGORdakYX6PZTHU/fdQwRn4w65Ua7lxfEtbBJRUlcg?=
 =?us-ascii?Q?dBd+iMCDSeyh/2MBTZr+0qVTutNlVU7+R9iliLE1n5jVBRIW+fT6Z91V/8Rk?=
 =?us-ascii?Q?05/N6QLQy6I8UNlAE2qWZvwKe3E8ckQ2c7XtBUXt494ZQcm0eJtOrZpAblcN?=
 =?us-ascii?Q?gF7s57c354vJisMb6vGmC12imZL12C3GuOBAZFWQGQ6yDfcJzIpKmziq2ko+?=
 =?us-ascii?Q?2H5cz0EnSt7PT9yE2YuF41hwvFAO8rYX49fSRk6/6kFikScVyrzMomTFHSU2?=
 =?us-ascii?Q?dJslJ+gsfqUSBJXJWTF+S6DCUk11o+lEXVH+uIOrlSQPFxL0NNJv31BZVLer?=
 =?us-ascii?Q?u2NySq9wGHLj984QXHogxlX1/+bUdAsXkSlcQt3NE12WidvyERQeRXDMK6Eg?=
 =?us-ascii?Q?7Qk8eZjEIGq/eamQUMu15MQCDpTnJiVymKwwRPIeVEumnUUuz9BhKt/lcnm/?=
 =?us-ascii?Q?Du3jqcl/jRYqqUE3ayZcgNm3jVkKI8WUxW95jTk+t5Ukz4G+buQ+iER42AXx?=
 =?us-ascii?Q?lFEl/a23msvcZ6LhM8WXBsGPPjj3N8au2iTz6nw3n3E4Oaft549atUU0coAT?=
 =?us-ascii?Q?OFB5o9eQje659tjIJ4aUm+NmpWJIvt+sKd+5mp1a7+eoRZJek1kVN9S8ikRY?=
 =?us-ascii?Q?p6S/154cHwyvs8zyQfqSqN8zfrtxSHvOvQv1HeEjaR2pcrrkfF3g95WRdTqZ?=
 =?us-ascii?Q?1YKU23XNLuEGT81QHd6V3o7vK689CrNt9CgdcgfEV8bTbRMT8JsBSwqhQm99?=
 =?us-ascii?Q?8/3qq8BhLIp3yjPATmkpnlXfnpQfJxM/cnLRE+VML1qgPnNaPsTD+QKtuNVw?=
 =?us-ascii?Q?DkN9XbZGXK1K1sanFAoL/6y0ccePvgCWfqMX83MS/OdPDHSRlM64TZNwcBN6?=
 =?us-ascii?Q?gf4xB2TKA1x8jDDBWt6ykwIFIJsl38u370XaOFTB1W3ty2nAdQWJID8CcQsW?=
 =?us-ascii?Q?8phslh/0wP1bDPT8o8+nX/ce54agF28y/xqxtFhPO70XKJmlIp1h//vvI8c1?=
 =?us-ascii?Q?T1S0tkI+TCwc19ANmjrrShgWTFP9cuiT9wgz2AR+RaDo5qmglfd+ZOSLqL79?=
 =?us-ascii?Q?k9FvF1w1R9pgpYav078GIdPY1jzW0CrLamWkYD3T61FPi1OoZer1nfwAWGg9?=
 =?us-ascii?Q?/VEOWcnQSnB3APBPy2x9nJzIE9M0Bn/YnruzjB4BeDsSa0rICEQ8/Qo1bxCb?=
 =?us-ascii?Q?VnwxBwVn3BhH8OIdVNzSaR+a3chxPJ4vIz8KUXa6otbrS7NkpxNN+74f1xb7?=
 =?us-ascii?Q?q6gLJlPPwypFqWTDQR7miPpFoEygKjDNCk4MtBzUV3uOjzMCB7x1+V8uWaRG?=
 =?us-ascii?Q?c7gcq93ms2qiYzoWWiZ+Yrx4DFsUsU+edsCjcYAk2yCVaFd4xYaICNpP3ZMF?=
 =?us-ascii?Q?C1M6bXJLwGYRrDki3lX9Vrmy9ktp9er9beMABYvOzjD5g67Ryee97vgggY8a?=
 =?us-ascii?Q?LKeD0bjpZwz507amwdN99DmhG8nrH93fhu+R/xAu72VuMCpbTa5gu+E+6Y2u?=
 =?us-ascii?Q?IZt8zTMKmV5IPZibzfSIroANwmNtkWezeywXZz9b?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca4be8fb-db6b-4cc2-f8f4-08dad426ea5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 05:34:43.1514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3PxyfCJRFqwceZ0/2qSuHj2nCF8KLwmYYp4A9OGr+kwHKa3VcalOZ9QkGMooMEgvkeJSiF0ZydFFF68pJjcjhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4994
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Yi Liu <yi.l.liu@intel.com>
> Sent: Thursday, December 1, 2022 10:55 PM
>=20
> This avoids referencing device->group in __vfio_register_dev().
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
