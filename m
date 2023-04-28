Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7486F11E1
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 08:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345395AbjD1GoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 02:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345385AbjD1GoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 02:44:11 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0056448C;
        Thu, 27 Apr 2023 23:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682664248; x=1714200248;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wI5FXKTFEde7rGniS0p3YcqDSHWzaHaAPU+YhdKhrm8=;
  b=OYDnIQQML9aSYxOmGMcYc+aRnVzUeX30zrMJYFOIuCvUDSM8Zs0cnmIJ
   PDPRKPLFZlKFBCHJoom4cdrjkvMz5Xvk00ZRVFGLqWs22nxIlXNYIDy6v
   bNlMFCSMgg7VJbsX7LjUzrH9gCQjP9421vVNZ7oldP69klAl3VLypdUVZ
   GUXFwAASI19oXk30J1Mt24O6holZgtiHig56bieYhxsp4qEMA3kcJ719F
   a314fPaWenVcxklhX5jvhzj2wDRrgsRAwt3WqlCGDaVVsRqLQ0Dg08AKt
   Hb/mN9vMfCxdfpcEwxw/2pkuykajFgVqSor+02GDmHUbSet0B9HKPMHLp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="327993046"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="327993046"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 23:43:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="697401309"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="697401309"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 27 Apr 2023 23:43:22 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:43:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:43:22 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 23:43:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 23:43:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RW4YRjz+TqEENxprXufNplfvod6gZ9+zXsIIw9bkWbO8brkqk8WQiCXfPw236fxidY9S+W21l6kxxs4mCYJ/UBSCrfoEtfXbXLXfIKd8SgIHjFeZh7R8Bta4IWSLzg5V8fQFXmNmvjMxRfNyE+MdRVOs2Ulwc8ZnJN0a/IeZNn2BkxOsGwSXVvMeYZD4icSavTwmqiDO2/06L0k0Scxh64eQy2xqeV9y9relvwLJDVfpRCUOC4J8fGnejm/S6VclBUU/xZiYk2NbgfodOUOSpFgxFy93IOXTQiJSPdu0iRr5MJTPXo3aawBCk1yUunesNfBwYmBJ2G3G6FMRllI6aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wI5FXKTFEde7rGniS0p3YcqDSHWzaHaAPU+YhdKhrm8=;
 b=WvY00e1OKyt1X5vzi9j9LcqVthADxuY/nYGeVl50lEWKPqDIvoTHpT/WRB+oFuZjlO45xWbSEfLHYmSmo5UY1K83ZedroxxX3EmhffsIB1OGkuERGkEYXp19J+VTto5Eq7bW5gaRP/JvHxwqJ4Xiqg2A4HeWO2LxUMxf21VoOVqOJC3e36Uvpet3iT3aYKtaQf4dd3xjmO3K4VVRkrzjiqYrRrJ2ME9bwnE3DFwKRVQNqrzMJheLQ5RJ0VCHxjkfLikRPEjRLk23AxYEFUuOvAulUazlj306n0gkA0SOQjO/HxjtDP+uIR/4KI33HsGr3U12LWHN6ea67e/zOha+1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BY1PR11MB8126.namprd11.prod.outlook.com (2603:10b6:a03:52e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 06:43:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 06:43:20 +0000
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
Subject: RE: [PATCH V4 09/11] vfio/pci: Probe and store ability to support
 dynamic MSI-X
Thread-Topic: [PATCH V4 09/11] vfio/pci: Probe and store ability to support
 dynamic MSI-X
Thread-Index: AQHZeS7PnLtKVoCULkyj9AGoHjL3j69ARwTQ
Date:   Fri, 28 Apr 2023 06:43:20 +0000
Message-ID: <BN9PR11MB52765DCF09ADC75D93F20A998C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <db312ebdcf31d61b8d443d8894f1add443399072.1682615447.git.reinette.chatre@intel.com>
In-Reply-To: <db312ebdcf31d61b8d443d8894f1add443399072.1682615447.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BY1PR11MB8126:EE_
x-ms-office365-filtering-correlation-id: 76f9bc57-3d22-41cd-add5-08db47b3daea
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NnwDi58m8ciuR2lf837xYNxsGxkL4cAD2gnY5mYji0fGVf5PtmLFhQX2vFbxaNbs9/bFOd838gEct+027VRAoZbwJ6YCO8H16a3RcmG3+tT2KvPEp9B3lokdA+Vr3a3puRhp3EG1wTRr5rqCkVDIehACww284r9rSpqvet/ltfEOHaNVdYQDAei0NVq8OhEMQHoLsVVDF2S3re2k7eY98TBGuF/8165RB6u/X2ET3ti1A/mVqg3AjnEkp55XT8x1we2NGexWu35gMPHh8Lwr0p9DbuGyGMo8VfNfrW7lD4YKVWGUUpQ8g6xRrtuGVwUarA9sEnDgsClaf7o7ug5V+HXGRipMBRrKR8wmeYeLSOs5lYN8jGnFbwVA5j8nPblpSxJIwZ3Vzg4mXexul05PEN6mkplVCzQkFVh4KL+pi4Cftypd9R6IYdwiBskIEAOqyoqM2I3OZZs++chCMjD+7PNA+EWkJkW3TbAW5b642XTmOW/JnHQYyMqEQLF/Hw7C1uF2FBnKY610mrfa6bWyovhBS1tjCdgf6JQ/2vI9VtILOWIwcAj+ZgBfjwYRBf48Kjd5fhsETUqsQ/lcZhq2C3/nAVzE2K7xH3yFFhAkuZAvn94NntJSm1sIsEZ61WVi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199021)(66446008)(66556008)(316002)(66476007)(4326008)(110136005)(76116006)(66946007)(54906003)(55016003)(5660300002)(82960400001)(52536014)(41300700001)(8936002)(64756008)(8676002)(38070700005)(2906002)(38100700002)(122000001)(4744005)(186003)(26005)(6506007)(9686003)(33656002)(86362001)(478600001)(7696005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l4Vust8tKhEaC9C3igc9+XgL6GlvQ4NyubgSt4Puypf8shTZhERDExblo9gK?=
 =?us-ascii?Q?pxqyPQRk7cG5F5BUMiOd5kQeTaZYfhQY/MedjH0KpRLdthlxtQpzIPX3ya82?=
 =?us-ascii?Q?UmAG/ankQ+VSWR2JgDH5K+VqxVQxHk5Xmp1bIQY+kXVAKDbG2NOfyZlIfQgg?=
 =?us-ascii?Q?HSgWzQ9lQ/5CU3bnQ7eCUK0cGC71RUc+2qUagE4yLcQ/fKcrzDzU4Bet9CCz?=
 =?us-ascii?Q?OPvhydW0S1XA5NIlPbXClC8fUVnJkKLkWWV7kVUr5yXZfQ4mrN9P7l1bwW+d?=
 =?us-ascii?Q?jpzDqs+xm2EpovXoa3ABzkDGBDgacnTD7SGxBHYkAYU1F0H7HgIe7ZI3yNcc?=
 =?us-ascii?Q?jpIdQueeWrk5amVq/MLeT2YfLeBzBbaBc39OKfgJW+O0yqWYUNu2k2WxZx7k?=
 =?us-ascii?Q?+I62FMV46Fn1bbOqKFvCWVIINkOAVNj+R+iqmrTfoN6y1GMexYLW6nFVELvG?=
 =?us-ascii?Q?eOchmeH7gb36FW63bhMs25mLoQ3XCMKL1tqS2ruww6Kpu8cnmFw62KEg3jtv?=
 =?us-ascii?Q?NUTmtsw4dFpU29EE14H0Zzhn3iIiMXPoHuj34gtn0BS/2tYCBz/1RrwYUk7/?=
 =?us-ascii?Q?AJ3gzIalxpdzp4DZqJE3kL6z8SQuE19iuzbsE5ws2cSY1W+vZ6OYoNDWNofV?=
 =?us-ascii?Q?hUFMarI1dGqPWY59I3qFuDdEXW3gwL//eK/ll4OIlIuyQ4Qjj0KiAjZ8Ur5c?=
 =?us-ascii?Q?PFI3v4Po3dQS4ch0U6A6gbBN0DzmogM/pz5PWbVtqUv0iux1j/pT5CMyIGjh?=
 =?us-ascii?Q?9yEYdrR9DJiXql3fXqqPSTDmeBaJu6Xpu4VGB9yaG/pIAovab/DRxRjFcTpJ?=
 =?us-ascii?Q?GMNlI1JWg3ZQnhCSYXok9uNxRPQ4FFy0MQR2BD0O1DkojoqCfV357JzuFEL1?=
 =?us-ascii?Q?svflBNVFuUzjkTQekRu5lOCn/UyPoiqs6gGSytrwY7DHE5pXR/dYAii0ggly?=
 =?us-ascii?Q?QdBHVAYLlqOyp2bU5siovx9Opfuw3NeaY4MbFnLQinX1IJtyHEfRNhJCjdBU?=
 =?us-ascii?Q?qzucp75z2UxIB3toZuONgawrNZm7vjlo1TICmT8YBpQ/SY3aQvt3cOw4ZTAV?=
 =?us-ascii?Q?pVv8DCXR4FI17kPGsQt5pR8PzxgoeKRH1IljMOdifF1QJVM8MMaovjaHN32/?=
 =?us-ascii?Q?Qsy4OcPsCQRX8JPkqel7TAGxWbrWjpAGtciEngqmWwC/h/YDHIifZGasCN0w?=
 =?us-ascii?Q?n8XIMNE8yyQU3KliZZD3hMv2oufuglGB+Y8w0AIPRpRb/xb2B/PdXPQUJPzA?=
 =?us-ascii?Q?alxnMCJicqidSewQDX7THE3m4gsj1DvzVYANy8LnIW2I63NbFOiqnZHie6WR?=
 =?us-ascii?Q?uQNXrRXRI81uMK0VxzslT6IVxVEe+DTxatR0QLBH6l6Sft0F8WixUKIw7tXF?=
 =?us-ascii?Q?8mZqULiPj5EM9jbxi1/RJGyDzp1dhl9RrJVfvOMfDhzi8t+zxjGPvB9WnTD/?=
 =?us-ascii?Q?LtMciVZUmxZmcKieGM+UhFkxREYC2wjZk849ZvmHnZactboNicA0g6AkFGZK?=
 =?us-ascii?Q?oRjev+oVfx2ETHSrOGcaoeiuDFLUekB+rtjEdAcdb6puKqbCYC6Gsr/POlVa?=
 =?us-ascii?Q?L0N+ZNqcNr7xcpYhxbkXZeM1iqd60jwl5yNi1qFY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76f9bc57-3d22-41cd-add5-08db47b3daea
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 06:43:20.0237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 401B/9AQnqo2TQ68bvUl3J7B5gpcGR9cnzzn7HNnJ3JjeSTW/Z00Xs/XtKfJxE9rdjMkIlvdu3b2ClF+2ht+BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8126
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Chatre, Reinette <reinette.chatre@intel.com>
> Sent: Friday, April 28, 2023 1:36 AM
>=20
> Not all MSI-X devices support dynamic MSI-X allocation. Whether
> a device supports dynamic MSI-X should be queried using
> pci_msix_can_alloc_dyn().
>=20
> Instead of scattering code with pci_msix_can_alloc_dyn(),
> probe this ability once and store it as a property of the
> virtual device.
>=20
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
