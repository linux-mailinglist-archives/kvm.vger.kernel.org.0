Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C78F69EF35
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 08:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbjBVHSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 02:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjBVHRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 02:17:55 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB41E2D65;
        Tue, 21 Feb 2023 23:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677050274; x=1708586274;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2AEMiN24Nyn3TvZk0QlqW2BM/0gblwK1vBiLiGZbt5E=;
  b=YkVYYL45suSSzS3dqCdfnW9WalTvTqVdA4CIy736/zR/fZATfKEcTNNe
   QE9AK54gnJjcuLiF3SHk9xw5wJqj1gsfsaHRmkCH1bkDOTvy0wX7Bl7Ux
   eQUTmDdz1gJDKNZNFO9TNVYA1Ozu6xc0f9T1eervu5xRycUqfRErhv3yg
   yFDj2Zu+DmwGWYrQDnt82zd9xC1V+CLNwP3cTKL/O0uVSTMWyYzW2OvHm
   JrB6eyXlWfcHpGgihcuLIgNKcbuRtrQUva6AB3EtJU5NOBTPeVvVBLzFh
   d9LAspdgF1jc25JIoz6k0wuuiHPpVFZHAJUejUES6/sDyGBUnXe9KIKVJ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="395337296"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="395337296"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 23:17:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="814819522"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="814819522"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 21 Feb 2023 23:17:53 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 23:17:53 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 23:17:53 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 23:17:53 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 23:17:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXt6vHwWJTDIqGBpzG4ksLbVfsAOf8cbLsk+D/jT0re5Qj2mIoWCgq8E43MkHvlEs1MBMCRr01RsjT9t86LpmglAVC16oXU465M075SnzuLQ9rvs7ZflbBSuwSCSOMKcFNRIN1abTsvFyaXnXOk1zqYzdZE/yNx1MyFIXOqIHaX3HYawblIZtVuT1bVgMNALa2YL0CEmjHka7rPrj8zyfOgCrTHmkT+Gt/0HNXwT5QHBJhiW3xDRvURBNS9EISwfrn4fn8YlnzvGC/ISBTMsx2ZaILlN84wlkTgVc+7P5se+l4fE//z8fLeoESoclgBLCY5e1EinSRDIXNhW8xJevQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xmKirZcohYSzXr0ym25tqLY+oQIydQ9u2GORZabk7cc=;
 b=aL1Y/+qJJOBS5fKd0dpmKecPb2sYatN1r00Xl7MdMq4e2wROj9Tb2npdnrBz56w82ejTvkgDGDZEBhMizYyJUif93BKrDjscc7ybC0e4RIucXT2dlKW0pNDWkV2mJN9zZYY23RxHHAkGDlxJICqeIC1ZQ8Kn6qvzc3rBzRA3DTM4AExpuCW3v7GgRzbZjVi70txSLEpZIb3gKD98m8jeeOtqXPmotqtMZV2JZ9W5q4v0g9kEEL1Q1ZJ3j08j6gcUJcT4ZnU7xxsPO5sO6wm6pif+fxHOJDgB8ulfcZsnfQaqOy7FYHhPBPUHy4/UNdlyRLR8Q04trkBavCqFPkU3LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by CO1PR11MB4884.namprd11.prod.outlook.com (2603:10b6:303:6c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 22 Feb
 2023 07:17:48 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f%8]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 07:17:48 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v4 05/19] kvm/vfio: Accept vfio device file from userspace
Thread-Topic: [PATCH v4 05/19] kvm/vfio: Accept vfio device file from
 userspace
Thread-Index: AQHZRadZIz/HpBgdr02cipkbMNZCGq7aj63g
Date:   Wed, 22 Feb 2023 07:17:48 +0000
Message-ID: <BL1PR11MB5271CB271B0BA961C7D977798CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-6-yi.l.liu@intel.com>
In-Reply-To: <20230221034812.138051-6-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|CO1PR11MB4884:EE_
x-ms-office365-filtering-correlation-id: 4b931e7e-b1bb-45c8-14d8-08db14a4e71c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qV0abnMqsuS9F2q/AknJ8fe1N/zQKtDvK1rcZmwcWNmt0kpAjPRwnfIXeZU6DiWYv7IgYIkleRP/DwNTfgGo+YA387WYVrtXUkVBZVf5Mf3EvNjIg5vbBK86LqWowf9Jo7qiAF9KgzpXqaLu7rnndvlVpSNnHNfb+ARGO81Khzbvr2BNuoKsejoD5NfQDZ3doPjH4jp6yH7KdgQNXeqWmuBmy0x7xFSbgoFa3H015/8rmvYYfxEtokyjq2rah1AN8hdq/CbtwosxBOzkNXXzp6VfQ9iFtGGTEN/hChul1mdVSfDVbzjQCANrbFIQseK5bdYkjHK/8cjMIxGEwjawxIyV+PsSQnktTwFuv1Y2pal0Ok8TsGyEP0R94+cBnhtLLu9uRe36xy/OfK85Of7fKYzIdiDhGazgN5OOP9JTaUkQHRL3isB22lNETA6DFoGYKeY145fUdn7TkabZ1SKGIQfBLSdFa43S6czgDgdDAAdV1izcBDz23Em2C9wPBe72xkgTt3FNfynjIKSzp76WWJnHPneK+iULwISwX8binQZpQ9NWLBQ0wyrOrCOocVfETiS0IZrcP7a07AP3wNQCOvXlvhZdY4mMHQHfOkVi4qN2k68N0DoCVFJdgpVQvVhQZPrjTn8szfeKZSWRumHmnirO97tYp8r5fn+TlQEwYGEg9N/Krq1a+N1OCbrLAeg/O2DCNZCDhBMQbtDfLGKU8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199018)(41300700001)(52536014)(76116006)(7696005)(9686003)(66476007)(55016003)(66946007)(66446008)(66556008)(8936002)(64756008)(6506007)(8676002)(186003)(26005)(4326008)(33656002)(86362001)(5660300002)(4744005)(7416002)(122000001)(478600001)(54906003)(316002)(71200400001)(82960400001)(110136005)(38100700002)(2906002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DBjG1NgSDY5QZ88waK1JdXCvzZN+hZFx3GYnwGr9BV+VQJ+u0TwAPtyvTSYF?=
 =?us-ascii?Q?uYpI39P94n2ASKD1e6AXrblPyQ9W02uMnuUoQsTOGlZtoPvCdA7DmjorFaKN?=
 =?us-ascii?Q?p0Dt4x9sUVkiHZXpj7YDUHxSe2n7IqA9UI7cDHD/s+BcX5H9WxbQQkd6gRd5?=
 =?us-ascii?Q?hve2TvsdF3VtrXReu1m+0ZH3a8MydWy5VqC9M9rsIfu2rStUDrUjR0xGdIgA?=
 =?us-ascii?Q?XzGuYDuucTonTwRBfB6mxVSlLLoP3t/YrrpgUQwVvSDdIRseP5TxbT6DKmyV?=
 =?us-ascii?Q?68kwFNzawWfP/xkW39LyG81xnv9EZqRYxzL3P6S7XY1hY7wp8uqxN+xyFnzZ?=
 =?us-ascii?Q?5WUcIXPuc/Fs7fBXHBbBwKzxgCMsoW48EzY/grWHmhycbyyDlztVs/5jXzzb?=
 =?us-ascii?Q?/Im8+8VKZn5IlT2OdmYoMvw9RHAfOBcdZWvStKGsKvzLCe9MU67rm33MKtk5?=
 =?us-ascii?Q?7q63q0tdBlREM9EHOKu0gCg+EdGxg29B/CRrTDUmnsX+s1XauCgITnVg/5Mo?=
 =?us-ascii?Q?zjAt7rxuli39T2hqsc1L93ZM4PH4UOt3HxUb8I06oX0/HGGReIhQ0aj+Bqxp?=
 =?us-ascii?Q?beO3+6RIxbdPeaYRhViDTkL00AfZgCbGpoIaU4FwcCHIFPngUoBXvVN/StSc?=
 =?us-ascii?Q?knoeci+fYeFT9ngtYrF4AiT9EmLczZajnU1yt8iZ+kcQHBMZFQUqB7s3cI4t?=
 =?us-ascii?Q?1tXeyjrgugbrefFi9Kinca3t4RSJWLqsC965Axtm/G3s52HnK0MY7kH3rh0M?=
 =?us-ascii?Q?IzghB7IuIoICIEDBntXJzENjEI1MZNiixb25v5+Da7xdiEkELiIf0ETKd3rE?=
 =?us-ascii?Q?OCF7usZ93V50HSmOabaGQ9gzcxeCThwpusrGiPSrGM05qKpOklaIQ9IkM7Jq?=
 =?us-ascii?Q?5Dnqbwqm0Tdw1vM62Tzrve1WE8R84MgKb8Gu7e0KSxnnxjJ6B6EKhmNUzOJO?=
 =?us-ascii?Q?mgDOQKUxiczwzfbzLIj0E3MJ1hj0+9I32KbGLvxrO24afx3Hf14lVCOu8M43?=
 =?us-ascii?Q?DqJGK6kYe+ZxTT5AKii+TGRm2WzoHGp+3d+BrqYTx1eG5hAQyJY+AdINAODy?=
 =?us-ascii?Q?u8Iiq4GBfS+4zZUaaDFkjkz35ZXB58b6iNdAeq7fuDjir20dstUlwaTRAtZz?=
 =?us-ascii?Q?m+Iqf21k8uXAleVsRxIlx2wuItkIwaS+NB5z3pKQBWAAiex3MtVvSlRRrnsY?=
 =?us-ascii?Q?oXmJYIbICUivaykWP2/IhZQ3ab6PAgnE01RPT1p3SyIu5igGrz4XmqY3z9NK?=
 =?us-ascii?Q?TbA6lTay8CKU0XVjaQebKplJBtMRncUUtHL2bjIAFFbLFrSLDN/3kmHalMWV?=
 =?us-ascii?Q?JuhwHQQ+kflYj7rtjMO8WB76w20q8oL9k/FKayqmv1ieLTlfNPBOYMUH8wkL?=
 =?us-ascii?Q?IxtXHDM8yojXImNI7H9N558+FGNIGANXkvwnK2PxkjQ4ZqX/2G6RgVNxT/87?=
 =?us-ascii?Q?O/KxMUhLQvJmoaupq7zhEbWAIHD2UULmKd5uYot4Hhgb5E5N49DFO2db9pCl?=
 =?us-ascii?Q?iAkJ4FnHaWYyAxYPyn3nVlVrxKHhIcZu4I9W63om4/y3jH65+Hsdjs7hc00M?=
 =?us-ascii?Q?lrIy5Wif8lZJt8SXpVs1MfhkqElzMRkWm5F2Iw+r?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b931e7e-b1bb-45c8-14d8-08db14a4e71c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 07:17:48.7001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R7e0/UTEcgm09Re5RS6nqdCo+kzfM83H4Q+eFer1bZZfUs2LBePkG5MFw3NrX2j++wVl9drCuUZZNRSEMIPpwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4884
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, February 21, 2023 11:48 AM
>=20
> +
> +  KVM_DEV_VFIO_FILE_SET_SPAPR_TCE: attaches a guest visible TCE table
>  	allocated by sPAPR KVM.
> +
> +	alias: KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE
> +
>  	kvm_device_attr.addr points to a struct::
>=20

I'm a bit lost from previous discussion in v3. If all agree that SPAPR
only works with group then is it necessary to add a FILE alias here?
