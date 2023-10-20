Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEDF7D08D9
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 08:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376344AbjJTGwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 02:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376298AbjJTGwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 02:52:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160A41A3
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 23:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697784760; x=1729320760;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=khCTWv7UMYbAb2C6kKEMQQUtYhLSf4o/MuKlL6MuXNg=;
  b=HYJsuPRl10HUVDa1TrJgJsrI2DT55pajjLiSLF3wepG6gV+ctabWAS/e
   N6fA5kJjuvYoX8L7AeVLUYE0NxQhEKJ2FHg2/4ML9xjfl//vM4wiyu6kZ
   KKlS745rPzk3VcjO3UN5s6btOQNaz6XhAQ01TiHJW7AYw6bi4a+0KiUOC
   62vV/b6026DeVZARepGks4am5Sk1wWUDxMKmHiJ/ykZFQp2nQcZzlwYXo
   SooiOqA+rj5fjHbON0qj8NkGeMYEy7a1BfAst0/MKHuD15K/Afw/3t9j/
   jOFzqGjmm9PIeKwIguob5WgWY9nkqRotfASbUmivHCCVG2nQR25gwgO7h
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="371515588"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="371515588"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 23:52:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="792299013"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="792299013"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Oct 2023 23:52:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 19 Oct 2023 23:52:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 19 Oct 2023 23:52:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 19 Oct 2023 23:52:35 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 19 Oct 2023 23:52:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TuNDoUYYa4VYrB4ja28KqNubE6s8NX0LoxGYVblKCpv+uzB7nG4EOm13EgF3BQDRNFNiS/771lcgekPUoHOaSfRdgDBT0VfzgIve7GJzX1sI1KEAQCBJia8F/KqOWg1BwInzlHi5f16CqA9OXW7fYm7RJ/FnQTmVcuU4Zx9nO10dCaTpmy/jfNkqzD6r1l1E5ndQCFI81X0h61wDxNR3B07SLLNJJ1VI8FcxnI40pCZl3g0yBrhfJ/AD3pX6q79S+4YKYMaVPsf05xkorMAFw4YZ7CDN4eJERgfMhzWbQnCI8bkN81hvW018LQFPShLr5TEFNgS1KYeoFUpHGoz8oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=khCTWv7UMYbAb2C6kKEMQQUtYhLSf4o/MuKlL6MuXNg=;
 b=TRepXySNMW/337GQceDQU3w8nqK6kLH8TrFgVWNWK1qGdJRNxu/+kOIQrmdsoRC0mLzELc8/Zxw21AWHzQHIrlfCXRiPGXd6nT5iySlBlQTLZjd3nM++OJgxpYX0THw0MyZzRUFEiyIwQie1HHdcc3PPGDqUG0yJ/LZ4UvfhKak3NBbFcxDa1b4tLD2kvunWHlB2A8WkFMWsg3SpGeHgf9V+ZeoLyy5G+TJHJFRuvj+w0/Ctcp1SKxoNfMh8hC1O7lFiFY17QvYUNog8lL0l52frwan+qWrE4T7AX34oTQK4SahWBF5rmNElJHkC1p+zWY49XVdTnEE/rM0O4708Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5134.namprd11.prod.outlook.com (2603:10b6:a03:2de::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 06:52:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 06:52:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Martins, Joao" <joao.m.martins@oracle.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>
Subject: RE: [PATCH v4 09/18] iommufd: Add a flag to skip clearing of IOPTE
 dirty
Thread-Topic: [PATCH v4 09/18] iommufd: Add a flag to skip clearing of IOPTE
 dirty
Thread-Index: AQHaAgGnusT+IrXvOECiJRQHHu0y4bBSP8xQ
Date:   Fri, 20 Oct 2023 06:52:13 +0000
Message-ID: <BN9PR11MB5276364ABD7783FA3267FBA98CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-10-joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-10-joao.m.martins@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5134:EE_
x-ms-office365-filtering-correlation-id: 3e3ef48b-8ded-458d-7cd1-08dbd139175e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LmVf+uf9uiWND80tnIS0MSADfWcyPyjsqA3rYYOfdI/pC0Ohv5l9KnhGGxzZVkZiKoVyKUdTFw5hn25N002fdMUtr+02Te8clFWAnH9IA59gZ4/7YPgCgx1PDei5Bf+gqyGRsxshEn9qVHRzTvqYpsYGA63nQ/+IjHjmoFKe5zToxutV0nKc0tIS++udblX+94TiT/xn/wFxgoKd7+V6jKRfoeHYZHno333Pkx1YbusQYLE2+4X41qh2upiyQWiH+InZjh87Tf9W1gnTaYpJfBCQ1Q8JOJTkHjpawkUqgfbaXqnh/jYxzlfYfS2vQSq6KrkzfsM7MZYlwvCx0yAmihBNxAqbLr6Y3k0ODzztdu44/4u2HSWiCYZGuTek6PLRfntWjVZCO77EXSAfAW/Onm7+hYeGR3Pf9lGxzJ0/nCCiDHkYqEKNHHt6AvPZM/MCCchy641xcO+FzJfOrQMXaGkgrv01xNic8Yu122oTgEPn4UDOTRnjEUdNiFnMtKpmm1RQh1gXNwq2D/BmWvTTTiFijGrAxFhLb/gpT5Opxb3XdI9RUK0jiaI6zpPUJ5ImKjBdrRBhmY9qRIcMTsy0Ls2mey1jMWHVJAf1+qk4OObSA1fl+n1AflGqNop05Kkg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(366004)(346002)(136003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(52536014)(8936002)(8676002)(4326008)(2906002)(7416002)(41300700001)(5660300002)(83380400001)(9686003)(6506007)(7696005)(26005)(71200400001)(38070700009)(38100700002)(33656002)(86362001)(122000001)(82960400001)(55016003)(110136005)(66476007)(316002)(478600001)(66446008)(54906003)(64756008)(966005)(76116006)(66556008)(66946007)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A/S7ic7dSzTIs1NbWM7iPnqRUMItBK4Jg7KJ+SO6gWwoH2c3nwbPJPOZV73+?=
 =?us-ascii?Q?CbTtHuBCfOiC3uWddUb+9ZA6HoE4XQSMA2iHU9BZSO8T96qRf4uK1e5QWId/?=
 =?us-ascii?Q?Px5tp4HEzA2+QKjnMqFgqy97M432104KWi4lhRk8Y/UN2S269KeF9G9c1zua?=
 =?us-ascii?Q?lFwNv3oB3kb6p+ZCRxzkGljVYpV2jlfjD5sME+qXZDhOPXku9NRkvNZ5nCXX?=
 =?us-ascii?Q?Dkrz5IZevi6bjmU/eQxsWs6cfkZ7yn1OiQ1YrAT7j7eU4Jwg61Awnr7W4ybs?=
 =?us-ascii?Q?7EXkvj89PX+uQcQX5usW5vZFVfjcNoIRjF9g+uTx7yDZLti2R1JCKfNGlh9N?=
 =?us-ascii?Q?jpwEi0PBOVZtongKMFuz7OwnRqBDx/gGkm2j16Y10KGr/yeTLE1cW/SEmXSg?=
 =?us-ascii?Q?dn9oaCxP85V91y79j+3KzpEhlYy/kt0TA40deURO9eEmBQHODv9Ze0KBQ82/?=
 =?us-ascii?Q?EAxUaAnYtNhMeNz8Frq0ETjHccZu01YVWXogRPfEHX1WFOXOij9PfnSu3FOS?=
 =?us-ascii?Q?e/nK9Qu6RVg0hTMTlL4aISdIdze9WONOBdmObMO7Wv3oJUr2NZgtev5ZrBUJ?=
 =?us-ascii?Q?/HqzJLvTll3EUIx0XKIcpu8Oa3+WPovtWzws5RsjJYvFrKJe/7Oztvw8KiT5?=
 =?us-ascii?Q?+u643N3vMudQ4OXrOKBhl24eihq44ifDWPIc6/oiIpnfotvOC0OA57gf32Ou?=
 =?us-ascii?Q?oRsksZLDpxM5u6+LwOuKwmmpWn+soLPRlVBHsjZlZpkzoJGPs1iYLaZAmmBM?=
 =?us-ascii?Q?tpZEIvbeXyeJ4UxF+j/7Ldmpgc5G5f74SrsHeNpu0vpQkfl0lyhOSEiDW7+L?=
 =?us-ascii?Q?PBRj+BRWJMD3ChWH8O2CQkqQkERWR7fToAnS7rRw/r+hkQekq2BnW+TRJF8l?=
 =?us-ascii?Q?Qoii7HcqirLOhk75HpohKz4Ca47dosriT8qOzXvpakXlolkneXiMcdZwrnUS?=
 =?us-ascii?Q?EHYJfa/V4jNTdX95JMefORiFt3f2OdHmrfAlCtYYpUoGM0RzKChcr/IpNyk0?=
 =?us-ascii?Q?qrxkoqCltpO31y5pUuRkHUoErOxRkYvwhAFtyHtxqEUM2MB+AtGU51ikiDSm?=
 =?us-ascii?Q?qGwXO7AaEVtiLDG1/KN1i7qr2iMizGfHuHiiUhyD4+D3kh51NCei+iYz+4/u?=
 =?us-ascii?Q?qWHh9snhNK1ZfoKbplp4E0HqL7lysUpCYQwT4CWrCRoZh/1jzUSigFw+7mNT?=
 =?us-ascii?Q?FSC4IGzOLfouGvcTwNkmcVxpeQSzpJ7JokkciRdgzFcWkN+1vMAyArvqjzOd?=
 =?us-ascii?Q?kEuKM5V77F0fWWFhJtLeschbYc+mPdKXugPAMc0P75iwzHBO1AjsFkPeINvm?=
 =?us-ascii?Q?lom9PauULGrHNA/HnI6SOzGAUwQPSjTNe+rpQNWeROwbd2zmgPnKDcE+HE1W?=
 =?us-ascii?Q?jlSsss1ZkVJj+2Ido+Zuy2bu3Zs5dH/zcD1it713Y0bWZ+kOkZmvggz3J2QX?=
 =?us-ascii?Q?HdGfFw86zU47CKgHHcRKBlNeGTl3rKWCzOLBYb/WSZoTh44iPMt62188IVok?=
 =?us-ascii?Q?bvcrhDCQcckkYIwhKqAA/1QT9dWH/lw6UWiFem5oPjdB74sAwxX91nk5Eam8?=
 =?us-ascii?Q?ME/y8a4ryytlx78w5lkssUBSFAjlZYI1oG4CjL31?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e3ef48b-8ded-458d-7cd1-08dbd139175e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2023 06:52:13.7849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g2kOaVcftuhpBAz7Gj2r6d/QS0+q7riOte/LWtx5QG5iK2cn+1MrmIPaqLT/tmWyohZ976Tlp8dQx0Wj3IxUoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5134
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Joao Martins <joao.m.martins@oracle.com>
> Sent: Thursday, October 19, 2023 4:27 AM
>=20
> VFIO has an operation where it unmaps an IOVA while returning a bitmap
> with
> the dirty data. In reality the operation doesn't quite query the IO
> pagetables that the PTE was dirty or not. Instead it marks as dirty on
> anything that was mapped, and doing so in one syscall.
>=20
> In IOMMUFD the equivalent is done in two operations by querying with
> GET_DIRTY_IOVA followed by UNMAP_IOVA. However, this would incur two
> TLB
> flushes given that after clearing dirty bits IOMMU implementations requir=
e
> invalidating their IOTLB, plus another invalidation needed for the UNMAP.
> To allow dirty bits to be queried faster, add a flag
> (IOMMU_GET_DIRTY_IOVA_NO_CLEAR) that requests to not clear the dirty
> bits
> from the PTE (but just reading them), under the expectation that the next
> operation is the unmap. An alternative is to unmap and just perpectually
> mark as dirty as that's the same behaviour as today. So here equivalent
> functionally can be provided with unmap alone, and if real dirty info is
> required it will amortize the cost while querying.
>=20
> There's still a race against DMA where in theory the unmap of the IOVA
> (when the guest invalidates the IOTLB via emulated iommu) would race
> against the VF performing DMA on the same IOVA. As discussed in [0], we
> are
> accepting to resolve this race as throwing away the DMA and it doesn't
> matter if it hit physical DRAM or not, the VM can't tell if we threw it
> away because the DMA was blocked or because we failed to copy the DRAM.
>=20
> [0] https://lore.kernel.org/linux-
> iommu/20220502185239.GR8364@nvidia.com/
>=20
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
