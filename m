Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92316B35CE
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 06:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjCJFAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 00:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCJFAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 00:00:20 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C32AE5028;
        Thu,  9 Mar 2023 21:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678424419; x=1709960419;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BimtLir1ieXPIa0dQfVRqIZSuB3LMvKZErPZ4Im0Ryw=;
  b=ZN70sGXy/WrGO+9fB1ar5jUXFPDRb8c4B/5LiHK4AItlzXLNk5KVTV+f
   EO9gpeSfaCgdnpVbik7iNnMFsxr986rYKR3/qL1DX5gLYAjY7qPzUSUX1
   cYRJ0Q71BT0/91e10/HuVZv63afysLT5la1PfFpVquntmUzSL3tyKf3lK
   MetLKofb7c8h15f15CXbusuikBCtiy3/thgmiG4cmSc75nGIT8afGfaF7
   Fhbw8rjpT5Z4qDCp7HKSS6r5oYWQzCGk1p5xutk3mAk5jzBvOdXESa77c
   KApFvngpW9Erme59a764CuoHN/RsE/eTpsQIjst36ZLDRK+mXUh0oYWJk
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="336665077"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="336665077"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 21:00:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="680088515"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="680088515"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 09 Mar 2023 21:00:18 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 21:00:17 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 21:00:17 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 9 Mar 2023 21:00:17 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 9 Mar 2023 21:00:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=keegc64r4Cc8xMb+PiZ6inQmyA4OfJeV+TLDcCAcBCpnpqZYixASk0cl4bD3zUSXS6uIjevR1KzlVLh+TSti63tyHj0v4juqqVF0dsBtH7rUuAfh7EHep0JmMKZW9N2sucmyOiEA7LnWJNpFLNeXjcgB0GKS4gDrAp1FQcIPkFKUoZZ8VqCCAAUbmgPyYecES9TpEfM5JEMZEPRZkOITnY401MfSiczhdq3sRAiFBxJRU4D7L+7oj/lzFsDoaDw3FzrzZPclZLgiFyor8+M0304Nq2C46CbPxDUAUZveSwSX0oHkHSs86ylcI8XwxcIPw04F2fGhPD0OjNmHEmALUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dWb9e6QJ1U7InTY8/oWxUrX/OYlTJuiV2TIDRv8zqlY=;
 b=W0ZFLoN4i8+FONIUO4CKIySiTEi+3/0IzXSKCXrszNeW9/jWfY5xdIetMMfqo8Uy8UwgVCWoC5MTkF7lRg0MKUlP0qb3oEiObmji1MQ2e8tgTF/GDDRZaQuTsJdfb94l0TVXptyTJ3I0XqO3IQV/ssINM6aWaauwEtfo1xk4c6RUHxc7oN2XIBDK3VuIMmzIGtJ4fnRm9ynRnFsoBgzgDO46eLBxiXlDKRf8uruOELw5azMpGQ5QJuy80/q0YEH523JKW6pDWUMAUMAYMAYhPdzADpoH0C/N7tBf9jlz6Tz+DxxIjuTg3+xsr7oqd9DISrojMfnDHA+xaqdBeVKFmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB6246.namprd11.prod.outlook.com (2603:10b6:8:99::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 05:00:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 05:00:09 +0000
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
Subject: RE: [PATCH v6 09/24] vfio/pci: Only need to check opened devices in
 the dev_set for hot reset
Thread-Topic: [PATCH v6 09/24] vfio/pci: Only need to check opened devices in
 the dev_set for hot reset
Thread-Index: AQHZUcIHo2fCYQK3TkWemyQ7DJI8Ea7zdFAw
Date:   Fri, 10 Mar 2023 05:00:09 +0000
Message-ID: <BN9PR11MB52760DC51114BCB0ECE50B698CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-10-yi.l.liu@intel.com>
In-Reply-To: <20230308132903.465159-10-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB6246:EE_
x-ms-office365-filtering-correlation-id: 89f9ee3c-8f11-4cb9-b165-08db21245305
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QhkrxhxEQhXhiwkXXSlJ4yWFni+NuzPWN9C4TBBkYbvGqB/+8UzaXeFXfhwQnVY613TOKdJKaArwDKNeS2YMFhGXjOB/s265ILy56mAJgQIWJSQD8Tf4F+Uwf6Si0Eu4Jzmf+uw2r5WNo8HwwcSor97kGVtUmWrtw7aCzbhWTjQhi2IktsvTYqcDAN2QIbYyvVD5QnjXHValBrKef4rLwEQdK6WqYVDvq4OjwNwjmJOM3Fdg5TucAMbHB5gkavyWfQilwLdiLRoLv2KtLN+TqhVvDRqFK9eQbSdGtsR/O9Y1g696O0la1nZUy17pSreffoZd0VIVqBlh7HZQgY6blqZQyLvpJuCuCm6AoKTwelnEx0/tQzfK/Sq8m0t6hcGJc32X08mGwqyUtiJ5w/owkaEua516eS/8pNli8x/FGjBUv1ncCWi3cytQHnRSHV+VDEXa73mE/z3GBj8En6qm+d3J4dD4e4PkXYPP2SNdrJ7TriyXEo80p46HlHKHI2VdSmEkquESlQSl0vYBddwB8jWq0zY1/t6yFnqI8xSqtZGxJ87fjrRHkvJS072Vrh4Txb9W237WW6aCA05Zw9V7EL2h+K/iijoP2b2yNVB6ILhWoq4DFqR0FVpFgh6MpHuY7ZqFXZtK5EBwRdEwObdAPWcmn3+05tsswEsdHdj7ubXFpTeMBu4vPdxehN9C6bo+nPJSx3A/KOhmR4+IrEBQ2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199018)(33656002)(186003)(55016003)(71200400001)(7696005)(82960400001)(41300700001)(9686003)(83380400001)(26005)(76116006)(4326008)(52536014)(66946007)(66556008)(66476007)(8676002)(2906002)(64756008)(66446008)(5660300002)(7416002)(8936002)(38070700005)(122000001)(110136005)(86362001)(38100700002)(316002)(478600001)(54906003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GrIfiEILyzCMk6NbKp5bkBAb44NenPOIHn1Z+yL7dbcgRpmUbTex24t3l0/Q?=
 =?us-ascii?Q?FncRUQ7D1sdS5qn0GQ3fXKKSeteyrKgRG9dgiQcqvpQJ1evXIlHvVkBxedcg?=
 =?us-ascii?Q?32I5M1IKDELDrBPT4ynVPI1qhH3fABGZlJKNaYuNeLmSL4J1libVInqV7YcQ?=
 =?us-ascii?Q?jmgACTnyrdMbnHmUYbuEi5HjlAS4Xc1vj40LPYXwWeIg0ygVoAovYn7/qzgJ?=
 =?us-ascii?Q?2ae/YNFri7FuZ8jYBNstuurpjN0GQuGebU85fEltp3MLACpIJcEOLSm4BxCU?=
 =?us-ascii?Q?85f0Z0lAFjDuKqtra+dVmU0FEhKM8KpwQHyiyA3peGPyq44qamAbfIgYKb0r?=
 =?us-ascii?Q?tvfFVfS6OOGgv+CXmcBLsRIzYmq2Rgtb45kG8ahc/tk9bDYr1xh43NoGXhVX?=
 =?us-ascii?Q?qLskeS5R7pNjW3cI9HssmHYEFJrKeGF5fgw45xkmGyxMw89aeKIkj0D3x+dk?=
 =?us-ascii?Q?H3uPMN/qEWDzlHSewmOsjzOsnpPKtrSxPYYFzl0gR5dx+vF5swQ/5n+2DCmA?=
 =?us-ascii?Q?wuK18yP6Tvhgg9TdW2+OQuhd5M7baXSFQkIP3oDzf7h5KTEH/G8xXIreWHZs?=
 =?us-ascii?Q?71VFdq7e7HPQSFbFTQXQfSJT0DfSh0FDDFvlysSB2NsMAI99wJc8KYZ0ASSo?=
 =?us-ascii?Q?szmpAqt1jQ9rRdaMPPKW5rBuMJWtm1UDD4axtynWyAEJRyiFljl72fmTAuba?=
 =?us-ascii?Q?v9p+8ZChHpyEtN1P8cLTnM4qEcyoPzzCpnhbR8VMOcndEgt6422h4AZ0d0ka?=
 =?us-ascii?Q?Mz+IKIt09pQlnlsr0wObx3a59iKclAIddOUzKyrJLri55ofXGoB87fiIHUf4?=
 =?us-ascii?Q?+2PJIogSBgG6k4LCDWy9o80+YU9TFJSHmehRTyCMGa1TT2dyE/8Yb+MvuFjM?=
 =?us-ascii?Q?g+rGn4XbkAD+F40IELIsyQjLBSIDaWwU2K3QT/KkdqN22gmtemZ2A5QLBfJq?=
 =?us-ascii?Q?w6wvKYbiIMVYNvsoNIEjdpuagVOG5teY52lvSS7YFRxtjA4RRG3B2CJv4BIb?=
 =?us-ascii?Q?0s3ehdmMsNJoy4yjuKXgEV5VsbXRbeWGvk9uFJKsJ88gpJsrvN8dqEireEhW?=
 =?us-ascii?Q?tUbinVNOIFGu06saS1l/bC55CEKXP5WDGE1524M9LMwKLRpv3jrB5SdxRBqP?=
 =?us-ascii?Q?Zj6qLrLUNGRAOU09Kj6DMldI4ez9Lzn583X5n7GYUa32NlNsrk/e6vMhiVb/?=
 =?us-ascii?Q?WVek+PR/3qqxhje2vHQlMyOLdaGgZGfVarBD73LVjkpQsUDD6khXVrn+8y5t?=
 =?us-ascii?Q?UcjMfvG8mZyJllI2/UMpO5x7sm4WzQrtctToBzQKO7FozOPI/THFjyZEyZoY?=
 =?us-ascii?Q?9SRhu05gS2fO/Qsc6pyih08advmg8nAO5KNXK2mqbLxL/d4+0dL5C8VJVVCv?=
 =?us-ascii?Q?cvHBqcNeqGQ+OplN1VSneJl9waJGi47wYhGf4ggJguAv9T8jE0CJC5k23Zyp?=
 =?us-ascii?Q?GTT5wIpR3s+8qaezTI4n84lkTkK5E3CTFEkLn1iWMiDQQ6U/mctqPQkucXfa?=
 =?us-ascii?Q?tJvrYWCeyEb6lH+oDSc0JWuPAYLpkJFlhqgeCSNbUg+KPg8oevm/YITGX9ez?=
 =?us-ascii?Q?ZreP/yXGh1MBWvK95CK5vsFvFankOrECPWQDIaNP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89f9ee3c-8f11-4cb9-b165-08db21245305
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 05:00:09.7853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cOJos3QdMwMLuByEikoeVDJ1vkcrvb7zeW9/nnIZwviFkEq1Q5G/2OXYNuVmhrrLzbO4LVxDAjFya331LlmMHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6246
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
> Sent: Wednesday, March 8, 2023 9:29 PM
>
> @@ -2429,10 +2429,23 @@ static int vfio_pci_dev_set_hot_reset(struct
> vfio_device_set *dev_set,
>=20
>  	list_for_each_entry(cur_vma, &dev_set->device_list,
> vdev.dev_set_list) {
>  		/*
> -		 * Test whether all the affected devices are contained by the
> +		 * Test whether all the affected devices can be reset by the
> +		 * user.  The affected devices may already been opened or
> not
> +		 * yet.
> +		 *
> +		 * For the devices not opened yet, user can reset them as it
> +		 * reason is that the hot reset is done under the protection
> +		 * of the dev_set->lock, and device open is also under this
> +		 * lock.  During the hot reset, such devices can not be opened
> +		 * by other users.
> +		 *
> +		 * For the devices that have been opened, needs to check the
> +		 * ownership.  If the user provides a set of group fds, test
> +		 * whether all the opened affected devices are contained by
> the
>  		 * set of groups provided by the user.
>  		 */

		 * Test whether all the affected devices can be reset by the
		 * user.
		 *
		 * Resetting an unused device (not opened) is safe, because
		 * dev_set->lock is held in hot reset path so this device
		 * cannot race being opened by another user simultaneously.
		 *
		 * Otherwise all opened devices in the dev_set must be
		 * contained by the set of groups provided by the user.

the rest looks good:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
