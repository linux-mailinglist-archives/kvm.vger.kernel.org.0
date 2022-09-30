Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946315F072C
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 11:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiI3JHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 05:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiI3JGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 05:06:48 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAD643321
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 02:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664528786; x=1696064786;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=KRKQ6/agswZfNMZ+xgRbMUXdENdUk+M+uM+XBfCS6Dk=;
  b=O0DzLbSZ/k341Fux9elIMC7ulK6Mo7cgmPZk6VvXb/4jdgQjuwKYdwkt
   wAtxaMuJBKvnDeu4sFi05fgMTiujvjeYj0ZPz+BXSXoGUllhIVvsxuAwJ
   KBl5bEexfG50dcb8D+DZqD9L4VzAMcBhK9DCAU1EMSBu8bjsuIG7+FNFq
   0RPEM+zAydYZGBE7HsiPc1JC2wsIjrCKMY33T0StQUxN0RV4LH/xQpw8y
   8OxMUq0d638Sz0/f5P2CbM2Yu3DHZBWuZVWb0RtMfOBT4hnQxrqafO30Y
   ZiLg1+PLMk03ZmdEHjAJVkyty3IzWfV9QEvtKutRkYtWmhgfIQlZYjcXS
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="303632459"
X-IronPort-AV: E=Sophos;i="5.93,357,1654585200"; 
   d="scan'208";a="303632459"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 02:05:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="765065768"
X-IronPort-AV: E=Sophos;i="5.93,357,1654585200"; 
   d="scan'208";a="765065768"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 30 Sep 2022 02:05:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 02:05:32 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 02:05:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 30 Sep 2022 02:05:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 30 Sep 2022 02:05:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYE0IQhWZdqWzePwViPlw7Dwmr92BvN2oDc/ldLOHTnFWOb4ukxB+7B3xEIcu3XRXpqecZWICO29UQrUbX9vulRrPQ73mgQ3ywidbt8/XUSDEs+agEzWXelAIgxfFDUFBFAmr5KtZXUOSae03MhIwB4e4TIWk+nt6kXRSb95n+2ut5fvKDL/Gx/Dbk+r8mvhljRroSl+bOq/Gt+mZs4KWCODrhQPDb47RprEZHYUl/bmvRzCg65Z3n80bBQs9NgLW+DzLQuh1DiPJrzzWLa3W7cbX1n+rtxMAon/T/gPXg/rvgaBiBJklDMnFtIRcFr4LDLwmAU/oxDpUatoJpdvqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dn6Xsn40lfWjOmg97oWYD2csjvvHY77R7a67o+cWICo=;
 b=DatAi5P0KQ5lYcunmftyE9Fzvi0V7qTGA1JYJ8kTuEmti3LCDKHe+1gF/fATm1o/d/u45MrBeC63SiBEJJRFLm3Weczrt4hy3szJNyR3N+herUZDQEDvWL7mqI1iB4bUCvPYOZ2qWlhLidbXPPW0zfxXO/plXkusk/3qeWuzte49ed4G9BCQ410k0TPVSOdvu4XNZ3ilwM0lY+NRYqayrAuoaC/nW+SoeyjZcmwCXxZylXzK+cx/8zIixeT6sxD22wBfOxI7hzAW5MYjpg5ZnBmMgC4E7Bx/98bTCZbnTyaTmVDxtqlbjDyxBCxVYxq7dAD2ZxTIXhVeTRkNqlmz1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB5552.namprd11.prod.outlook.com (2603:10b6:5:399::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 09:05:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ff76:db8b:f7e9:ac80]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ff76:db8b:f7e9:ac80%5]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 09:05:30 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 2/2] vfio: Change vfio_group->group_rwsem to a mutex
Thread-Topic: [PATCH 2/2] vfio: Change vfio_group->group_rwsem to a mutex
Thread-Index: AQHY1BQee20Q3FDENEWrThuXioz4wa33rz1Q
Date:   Fri, 30 Sep 2022 09:05:30 +0000
Message-ID: <BN9PR11MB52764DDB9024CD898406606F8C569@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-917e3647f123+b1a-vfio_group_users_jgg@nvidia.com>
 <2-v1-917e3647f123+b1a-vfio_group_users_jgg@nvidia.com>
In-Reply-To: <2-v1-917e3647f123+b1a-vfio_group_users_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB5552:EE_
x-ms-office365-filtering-correlation-id: 289d3d26-68ca-44e7-4dea-08daa2c2ec86
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MoO668xZfeCYuGrX+Kv0w/SRVtq/9Um46BL99vcc0OvJ0xK3D1JeoKXi8i4F63G0uzE7cjBn7R1AiWyRRyHOdUQ+sBVnPBlt0R3yyT+ne2uL1xdlDvKX8boHjSWHN/DkMXHTyid2dllMx0DfXzPd/VDpMm9h0UtE9qYM3eju96j8pwHSCxdrt2RxN2I7n2VLpngTbin8Dyi00vmyHkRn/cLpdZeQii+MZWBc4Pq/WZdrAHZbXolLrQ7MaFJpIsuPlJoTvO20F7MKs30YCkLXTm4r0BEIMsfhA7nbyT+7wq/fp/Dxw6jY/ovPEG7FtbhtfUn6hpDQr3gZvwfzdykgtiDy4CLe8Qnohbfnp2a5+q9+WAwOQrfRMvdo/qiNoaq3oAwwRgk+Ysl57eRMwNWLbuOIyoTZ5uy+nulMi0fhVBtuR5p/3rnUud06JxnFZilK1d/8IFzhSxudOqUC7lZhH1pQQTyG1kTl6KF3V7hauv21cGyJZ2aq8Nu+Lw0uyb4zDTn4AvgmaGsUB/ekJsx/xyE6/mRKWojcB3AwX+zrUh2Rm+GwqPGNNBrzcBNQtHe3w1PA1vrJC1OeS94emwCV3udIBu6/MDopSQyQtB4gF5fkQr2bzJ7Vrq29LsB8bpEcHzoGurBnTuTAg8rSJR6sONotopCwIg4gxUdaOT0I5Waws8rx0rEI1RIyQd44MsJ5lC0cNzoyaxKAgK6JjG9tPwuMrdkyJ8R8kpoCXDsPuTume0PXTpzKe2LYF25MxwU/ShRwvpCYj4aU6cYKXUYD/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(39860400002)(366004)(396003)(346002)(451199015)(71200400001)(55016003)(38100700002)(86362001)(122000001)(478600001)(38070700005)(26005)(9686003)(66446008)(110136005)(64756008)(66476007)(33656002)(5660300002)(52536014)(82960400001)(316002)(186003)(66556008)(4744005)(41300700001)(8936002)(2906002)(7696005)(6506007)(76116006)(66946007)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DvX+e2oAH/EDuGUQTgjQ/0pBNUPYGJDfL4NtRZXoq7E9DQ9x29qbPRyeK0pl?=
 =?us-ascii?Q?+YW6oSilmj5rLWIb4CWUuX3ajnLFb8VK2zya8fzPJJW3J0P4L7uZuSy6h+SM?=
 =?us-ascii?Q?DYi2H5VxX70kXHJT6bw2uuynzw+XFx8ZsdhLoAabkuoL4VC5R4iLycSAFFed?=
 =?us-ascii?Q?VpeibeKpz65BKr5lt3mwyZJyyuOCW9dvant0O10MJ4Cc4GC725+XcUgahi5N?=
 =?us-ascii?Q?JaKvw+EAzR5Qi9AgZOdjarQHoygEMQYqwglRJ+AMQn+/6UwK5xvWSQb5/vYV?=
 =?us-ascii?Q?tI6DLb1grhAXVbILAUBdU5tDwIXUYOK1cf5Wo9Km6nWSoif3mwtQskIpKYBk?=
 =?us-ascii?Q?6libEEFlSlfhJ2fdC444OMbnl89F9HogkgTj4fClDJzB6t0OUqhdqiEpCR1F?=
 =?us-ascii?Q?TvBplP/EUdyi9hkKW3JwC0fYVlo49Y8ZSa7RbWc3bMSlEZ7iqLX92axzVuyF?=
 =?us-ascii?Q?b/Jl2CZ3f03tbxkGxo0jG5DemvzuODtbDtrdHzi8zlLNdQsushycNnPjMhkf?=
 =?us-ascii?Q?dbU7R9SLlHK3sTo/nS3uOIulW2UPbJ6fiPJ7cuTGbkhKh/OBU/MVjrAdOPet?=
 =?us-ascii?Q?KwA58JHnwYeRMAkhceyyYpV8RoobX0U43rVmQpBdu+YmgnhR5anATM+njUeI?=
 =?us-ascii?Q?/yxptUhhKvqsJ6sqoe0Floc/Y+FK3LzbAb0N1b/VdMl0OuNc+rDZlugULHn4?=
 =?us-ascii?Q?g9I1F92t70d5/0w5QR8de9kcirxrCutmxGwYzFFR9ACS3rR8g5NoYMw7oSrN?=
 =?us-ascii?Q?mQDWShU2BPqP+274e0O22+/zaSr50cHPSL3cvTo+/Dp9l6HY0NgriMy2NKVN?=
 =?us-ascii?Q?CWgPUycnd7WPrsEvVPpEOrKIC7t+2uq3SGwGT4aWntedFBJjorOgrEsQmWij?=
 =?us-ascii?Q?um53UzoVRqJO+O2soDdx18b4nAodTJSwGa2/VLMtbInoEhcvqeyGNZbT8pcA?=
 =?us-ascii?Q?0EPDW4UrHbg5ejQcKuMRtu9pvs9ssnT9Ohs0XFi08mG2fO45riJnWPT+qDju?=
 =?us-ascii?Q?3bi+/WBmoYdavnEtvgBmgwMgopnCwp7bELF/20FH1sfcpXN7e7nkG7O7DUAQ?=
 =?us-ascii?Q?SkslCW+J7YEHvoItLWx0ndaNQn03TflEkxTyOFe+eUi2ho4JX4ic+3ZEmB+h?=
 =?us-ascii?Q?mCd6EsuTb+vS5T0wtlpPFrUjHXZ9ETb+CIhy4+IqjWQvRROUTN9yHxDNWHhu?=
 =?us-ascii?Q?HCnD/zBybruIJcAwxD4a3o0ltqrfvQyFl4S4fpbo9GEcjK9niuQfZblzLFcu?=
 =?us-ascii?Q?+5j7ryOk3Lt1q1ckuUHSkZe+EFSY7wXW7BpdAJRd4N0aVfowVdnNCFGLNKBn?=
 =?us-ascii?Q?PoaPeqlkUVVNmhJ3oy8tiYHUJMfBPYSlmDcLB2X4TzFuXQp5U+yu11UAwzIB?=
 =?us-ascii?Q?kMHYgZlxXvfC0lumwiAq6rEpGfICtMvFhCjP6esNLFPxCPaglu97n5/+W4Fv?=
 =?us-ascii?Q?Se213IhvFjF3hRngIMHBDZO/UZglW1Q8eSs9P9T/9/hQqR7Oyi5iegw0blFM?=
 =?us-ascii?Q?rqiWLdAl8H4eCfBPjyWNvdIGhewek+D4raLkjMSFQdn7dCLNjeozNY7JXlV5?=
 =?us-ascii?Q?BAhXCQkCQlkRRWfMAeDOb4jz1EccZYkG3gpgd06a?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 289d3d26-68ca-44e7-4dea-08daa2c2ec86
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2022 09:05:30.1613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JJyesszPwwBk9T4VxRVjLGBAzAO2GWD1+5zXoGPA3W2tVVYY1GalOzA1m4pGz1nVnorTSNa9vkisvedYTcXdvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5552
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, September 29, 2022 10:59 PM
>=20
> These days not much is using the read side:
>  - device first open
>  - ioctl_get_status
>  - device FD release
>  - check enforced_coherent
>=20
> None of this is performance, so just make it into a normal mutex.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
