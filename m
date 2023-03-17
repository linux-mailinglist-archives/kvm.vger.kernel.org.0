Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0686BDE56
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 02:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCQBzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 21:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjCQBzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 21:55:06 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19AD40FE;
        Thu, 16 Mar 2023 18:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679018106; x=1710554106;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZOWnt4uMBn3uiUCIQcinIE1758vSUYk+n6lMxC1bOBg=;
  b=O7spjdUYXsKk0FB8tw7qnL8bnQ1uh902P8lqMPyr34bun4dQNHAapmSf
   bkDGmzQOdTNYftE4ELCTEERILHnB7D/oWd22y5GtRSImCJJP+jd64qclV
   G01ZMFB+R0NmPU9cJnFg+UmWbi696HDIpWqFZ0X9RmQ6g+sPkW+s2vU1S
   UaTGm0lDCgJeF/N53FoCQOYsLxS9jfCdjKcblBc87S0MT9fQYbVc30jR2
   d/3R3nbw1EH9e8XAGKnAyXDhiPXurnqsY54RZrsGeCXJ7Qrs2SkKw0Zy1
   d5JP3DA9jq20qQJ7/Fqkfw10wzOF4ZCerqvR0JPmsHvQzxAS6D1RgoQBv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="340527771"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="340527771"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 18:55:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="769178956"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="769178956"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Mar 2023 18:55:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:55:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:55:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 18:55:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 18:55:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J9SK47jHSPOCzIQW1HwD0+setYYH50j71EDGW6p8jZAqYKflbHeHYQHl8nkSkaVRt1gDT9GMFfDic/5dg8nAJw2Q8sUcKPNYpYzs9SIsQHZUS5tVCVV5e5reveAvnRN9M7QD+gLUQWQ7aUjRJIG0Jc0bjaau13hNIQQqH9SEc5M4sXz3papT2sWwAh7eqP24FU3b6CPNOCHdkEIz52ObmuYMmeNLjTEQb+tgzEDMNXJB/ur9mHdDBvp+sYJwnzr9pNYoXL1BDqCQLwFDJB2+EJlz8GF4zfNbRGej9gztswwOplztn2iDcqfmFQRWyejo1DFDwY8RBYCYf3nWO/VOgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/1OdflRwgo7QLG9w3DUZa5svx4KOHwWACYlHYy+ugrs=;
 b=mfIvvET0vbtL3KBkkwyNrndTfbiTlzfEPXs9dQoO+BdnJT76xhKnhFzCMpQvLk8jwyw+CmIEQszhlfPKG6406Eao3WhaaT4VmcmWcCc7JCThfAl0sFkjIflrAB8e83UoLc9M+x+P3NKZyLyg1u/q9MHsxuxpY71xDtEtGoY6rV8WW8QLBFlbuwaSwsjUq0HRO3uv9LZdVrOfqZiDK1zZ/xu5xVfUuYnR2XhtKAywm5uPhgm5QR6LYIy25sFple9brHbN87JCIuhRpFCKtQiuFbXROtQihWNhRdUtiHg8DZSVb3R6Zyv8jJPOgpzIMsierHMmBrBfBCKaiG8JgG4nPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33; Fri, 17 Mar
 2023 01:54:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 01:54:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v7 12/22] vfio-iommufd: Move noiommu support out of
 vfio_iommufd_bind()
Thread-Topic: [PATCH v7 12/22] vfio-iommufd: Move noiommu support out of
 vfio_iommufd_bind()
Thread-Index: AQHZWAapX0v3cXLRfUGo6BmyoLiYG67+NpHQ
Date:   Fri, 17 Mar 2023 01:54:57 +0000
Message-ID: <BN9PR11MB52768714726AF1131EF135998CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
 <20230316125534.17216-13-yi.l.liu@intel.com>
In-Reply-To: <20230316125534.17216-13-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB6020:EE_
x-ms-office365-filtering-correlation-id: 886588c8-d3d3-4db7-6df7-08db268a9c86
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O1SL4TIrKwAdul6vi93xl5CEUo++QHI51wAF2zqf8fs1XpD5XVI0eE9mftgtSXD1W5NQY4mbI831k1udbWaC0Q+aN2PsvgtyG+AYLCsgRK21nA/u8Q2zbHmWc4DKWr9G4c+Zm4BX/gdPkciatyXT6SUG7DlUL8o1eo3MxQA98LaBug19MmHsX5j8Xf9sxvDCUc7VvbmNE07x4Sh3tHeUd+XiPSX7wIVyNuN2/RFpzDaoNLpOElvLfRsdpT/NKWWExl8f5oNiGlfoP0TOv2tP3o2Z5Cf6ImlsmybQbVyZFqiudLST3HbIdOOUhlsifN3sqM8tQm/dSSDWzJ+u8aLP9KTFDG4rBFFhssidXtIQuLVsPYdwqD90xiyiixD9+WO5Qkh2J4Putbe35sNklaxVCI8/R8NikXbqchDy8j1Nui/aJ3mIZHE/UlE4eK6nb/zH0myPtQhEUrVvBh/FhHrZlFaTsJM3diNnKjcbtJXySgZpIi4NBRt4KKEv1kdmLRODT2jh/XrhEGpM6qHaNyasCSM4yH6ri8CJLCAhM58Mr08yz28dWzPZZNGquW3YevbDUCHSeEqv6VB4HszKZMQ0UanbmlRxoCyTZJG8BXtCPcTRmn7MrOGL9wDkl0OrTWcwDyOHNkncKXStuVtQUJFo+/QkpjL7EvlLP8ungoqVr9/r5iHmaxcWwNWvC3qgAy042sUA9j5QmKwy9GNVnnkQxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199018)(478600001)(316002)(64756008)(6506007)(71200400001)(7696005)(54906003)(110136005)(9686003)(4326008)(186003)(26005)(76116006)(66556008)(66446008)(66476007)(66946007)(8676002)(41300700001)(7416002)(8936002)(5660300002)(52536014)(4744005)(2906002)(82960400001)(122000001)(38100700002)(55016003)(86362001)(33656002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?f7tIif0Hl5yAsDfqBFawBiJrbuUPamEDcY6NDsWLWEpgF/JxLRFVjZ7WCH3T?=
 =?us-ascii?Q?yAD9DipwkMPMoDbU23uujSDsR61dbMiE2REA1ojTND4vQUQ301Ktm7vY9mVU?=
 =?us-ascii?Q?mpMNvbiqCVB637z+Rnqu4vZsS7NHD7O7GOOGUf1nRETeH0WuXj7o+OcZGyRB?=
 =?us-ascii?Q?6yPS2S0zERKJD9bnuilUuVUXB3vrLWrzb2amvmyXQDcUy74E8eaxwigQR6BN?=
 =?us-ascii?Q?1UVcMhqf1eH7Xrx6YHsfOKz7GbnUyW6t+WhzAYixJIelhJ2p73kMNbx9iLgi?=
 =?us-ascii?Q?ZSBwIoaIQ8u7VV0XLDq2G/aHaM3uKhObOMX2v6Y7djvlGXBm1DkjVRL/9t1x?=
 =?us-ascii?Q?+Y3cdmgI2cEA7SkFBaHQnDXxLaJmElXTkK29AE9b4k8KjzW78XrHQTcJvdGj?=
 =?us-ascii?Q?6W+MpaTa+tkWyRyd+0LIr+JWoJt8DuLbt/M6MAE/5vTD6k6C/e1p9JoY82GH?=
 =?us-ascii?Q?Wopc02LaT58S0sMw6DhJurMqWKp5LAviDg4RaZfJtUSHaUtFxbKLAow2JceM?=
 =?us-ascii?Q?Xu95iGpD4a9p7h/uY/xWP10xb8zaLDZGv7aHJHhaxwzFbDhyY+dtuhwbzysE?=
 =?us-ascii?Q?8FdloRunDaM6kmZV5BvfzEm1a+pCZx9xb0xrqO7cDM67Aeqi21qAZtI5b+JS?=
 =?us-ascii?Q?wrIwTSrT0ZNgqheRdWqYJocrsFeYUEd4bebuGm7FpXMtta/xrtS3IRIJ7gRf?=
 =?us-ascii?Q?fQWxyLPVuZC+4Vz6sRF7NOMSc1vgjZYU9Xec6dZVM6Uw1Ej3XzuP2Oy0P4Hs?=
 =?us-ascii?Q?+IMJWk+5eaf88O9lL7TdRUIZEKESSRxp2hP+r51CBpy19zl6ZUJ0Smj4b98g?=
 =?us-ascii?Q?O+caCruEfQSAUtWCh6ep7mP7vwi48aNYC3pAjZmtj5XX6183MEyRG/dfJpXi?=
 =?us-ascii?Q?kyt50C00BrNK3Yv4Zdxuge1RO7AJY5oUJwiO7wqV49k0knod8Z3SUvIgPvkW?=
 =?us-ascii?Q?zIOQAHbjYVK4a4sFBMo7MBzsujh6zfZOZlImYX9br4cjh9ayNUeSfLpB6e3P?=
 =?us-ascii?Q?ZpQS7F1kbmBwQUudDNwEvqRdi6+aNIWKSF8BAbqnuBzVAhgSFisvtyd+bhp6?=
 =?us-ascii?Q?ePLDEphwERnxWTnxz5AxkIE6KEV4FlUbEwkaLsTfEXA1ic2rNff4DKqfmJvY?=
 =?us-ascii?Q?cAE45BfqkcCsC97REzQoHcj03JI4+hjB0E0M/LP0sI+v2VWmJ1xNOjO0c5nx?=
 =?us-ascii?Q?3XwDwcgWGzEanO6s7CdBL29ipoDJTyuyLhGOB0Cm5KSZjb1lVRG0xFOEfTFb?=
 =?us-ascii?Q?5Cs0htJ1BHm50vSDVZXH4HoakbFWlM4MFBrlL2KVvtveJFQI0Xi390RuX4p2?=
 =?us-ascii?Q?JTTBNPnZWjbBqTuZvk9bSA2LBgyak0ghGGaeXsqHBYvbiKy2KEpHli5fgU6Z?=
 =?us-ascii?Q?/FDzRd5EG7HCqB7qwMKNINjrclN9FHoK2ZafHURJTsfTl/+zKreePmXbGKXn?=
 =?us-ascii?Q?V7YHOzo8xbsjdJyaPx4PDE1/pyVvwmB1Gyte32p64YAl2TWeOLIT0IiJ66p0?=
 =?us-ascii?Q?gkr0zjxoQNSKJrahu1XSsvW6f/stzB2Kk+AyfvWWKRmzzcVSYWcVNI6t8/FX?=
 =?us-ascii?Q?M6vUZtS1DE1rWzhEzxZkqd+8L52v8qbsWJmWC9rB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 886588c8-d3d3-4db7-6df7-08db268a9c86
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 01:54:57.5830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d6Q/Ch0+HcTs8bPycjCFe6x3HW0cN+JL7t78iCnNN67eT/a6JD32Oj5cRFQASouCjSIZSPIUMFYdKpwFEOksow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6020
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

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 16, 2023 8:55 PM
>
> @@ -192,6 +192,15 @@ static int vfio_device_group_open(struct
> vfio_device_file *df)
>  		vfio_device_group_get_kvm_safe(device);
>=20
>  	df->iommufd =3D device->group->iommufd;
> +	if (device->group->iommufd && vfio_device_is_noiommu(device)) {
> +		if (device->open_count =3D=3D 0) {
> +			ret =3D
> vfio_iommufd_enable_noiommu_compat(device,
> +								 device-
> >group->iommufd);

use df->iommufd which is simpler.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
