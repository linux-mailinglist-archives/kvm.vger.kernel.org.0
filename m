Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34C97A7A37
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 13:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbjITLP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 07:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234449AbjITLPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 07:15:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EA79E
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 04:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695208519; x=1726744519;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+EzN2fbMxUt2FgqJTRah8ztF/3SIyTfEKHtS3GHB7No=;
  b=kFp4DqyNzL3Ssu71XtJZh7vMTkEXEDY7HagWgjcTnF0BfE9pW5USsXXo
   TTm6fgZ6wbOTurCroTBVdPsWYoYRWW/DK+3kyrASzMXQm9Kwh8JUYa1UY
   NLD6AGrTe4hIfYnFEOvQEBPjEJTnlBduIOtE25HLiVi5Yk7mmystUWhRt
   i2EZukxE/dBThv5FZt7KPcJiE4F/0uxIMl4qdVeZ7ZPGj5wqHTtEaWeBT
   QzfgEQqXKnqHnBdBDVq4PuWJFaN1jwVR5asclMF/o/KG2BMoQnibHtrdU
   YkvXR4mhZcXRlSbUbtNYv6ATksjE+E+taNtXNQ48lwZUeZ34yfwW/xZFm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="446662054"
X-IronPort-AV: E=Sophos;i="6.02,161,1688454000"; 
   d="scan'208";a="446662054"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2023 04:15:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="816867505"
X-IronPort-AV: E=Sophos;i="6.02,161,1688454000"; 
   d="scan'208";a="816867505"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Sep 2023 04:15:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 20 Sep 2023 04:15:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 20 Sep 2023 04:15:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 20 Sep 2023 04:15:10 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 20 Sep 2023 04:15:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyZPl2WeJBO6BXBEv/6iZLY21uwQesW/ZAf6jjfaEI+3jOnIj3oNewlM19brI7DKGfmkTBwpcIglVwPrl8oZd5j0gX3oRQVEGVyygTkV7EPjY05dAa+fL7pcOl+WBuVmm9nCfcFo5QSGclOUz46KCOshKl65JtglUhSVISqzIjHEXl6HUDnGVQ84ccwNErKqpxCpg2DY43eZqUtzlaQ6Z8YJSfCkvJXQ73jxAk/7wiDTaN+XvESXjfJ5MiTc4365LeW1f/5PLkEbxq26q3ibAsudJVZrMJVtkT4xDiqwD8kY1sIcGpdzsgPIDYtLNqOb/qobzWucwwzDYjCfKTvW6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+EzN2fbMxUt2FgqJTRah8ztF/3SIyTfEKHtS3GHB7No=;
 b=b0NWTY1SodNRTGvWDRUmNn1eYMgzpwmt7SjEicCxv65Il10mKqc5DK31hu0P9RHNlD9nPmZkdfPjwlqVBYdc6iEMvk5kHxRt1a08QGUAr/rjE86YRkSPypp8OC4XAcFntoHI33Cui5mOt1Cdf8+oziYZXd3Q5J9J2/bOV4vAQbP8E/4w/e+I64KWkDR1buhYpPwd4G72QXmVizCLiIdJ0lSmU6jCxP+VD0PC5BhEoevfbs7JuPDCKiQOf4naa0qWZ3N3QYm/spc5mNfqz7oA/XLOeihcfSVSRWesOETzFsvxSaSsV/bgVCMRl0130qg0z2mtlz3PNK4f/4c/ongoHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com (2603:10b6:a03:47d::10)
 by CH3PR11MB7844.namprd11.prod.outlook.com (2603:10b6:610:12a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20; Wed, 20 Sep
 2023 11:15:06 +0000
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::30d5:1067:980d:b8aa]) by SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::30d5:1067:980d:b8aa%6]) with mapi id 15.20.6792.026; Wed, 20 Sep 2023
 11:15:06 +0000
From:   "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "clg@redhat.com" <clg@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Subject: RE: [PATCH v1 02/22] Update linux-header to support iommufd cdev and
 hwpt alloc
Thread-Topic: [PATCH v1 02/22] Update linux-header to support iommufd cdev and
 hwpt alloc
Thread-Index: AQHZ2zAiRSEfZNgVY0KFJh4NW0O0irAafg0AgADLkaCACGSKgIAAAo1A
Date:   Wed, 20 Sep 2023 11:15:06 +0000
Message-ID: <SJ0PR11MB674416AF0DD0BA4F901608F292F9A@SJ0PR11MB6744.namprd11.prod.outlook.com>
References: <20230830103754.36461-1-zhenzhong.duan@intel.com>
 <20230830103754.36461-3-zhenzhong.duan@intel.com>
 <c2fb72a1-2e83-d266-c428-72dcfcd95a75@redhat.com>
 <SJ0PR11MB6744FE3F0DBD0E5A69EC37FF92F6A@SJ0PR11MB6744.namprd11.prod.outlook.com>
 <d191634a-1734-f446-8b7e-affe4ec195f4@redhat.com>
In-Reply-To: <d191634a-1734-f446-8b7e-affe4ec195f4@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB6744:EE_|CH3PR11MB7844:EE_
x-ms-office365-filtering-correlation-id: 2430986f-b050-4dc3-0c07-08dbb9cad843
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PQfEfFOyel8Qxv5wOVCpCP/z05cyY+4udWU4pTyHNq1MEemukPYC9pJbsAa8BBMjPr1cL92U3iWNKSox11iT+gYRjhsUUUevFfI/oTxnRWnK5eihqGgbd3JRCa08q7NjbZFV9BK97A+wrSSsK0Kn8mlR1chKrTrYa64+XNSrjCnTS3ycZblFDVIvmB4g2PaUTme+GXh6Zb34U9kWxG5mMsQMiQgUmxMnVShAKJKHEG51NoBEnlwAYqGaksLhXbT79RbMNX4RcI/bd00AU65YeOPcUYXtLemBByDBvbhjn5n6J45JM83kJQ6znqLM1/kIlncB0pn94rRP1D9nWuDBLUQo5IpVE5mRxlEipxuT7lWAnwi+z0a3Wrbi9qv1LZO8aoDcvMhXNDtbVDTkvdilzUsBdawUACSDMYtlFAyxMG6FlIG1gV/OvEPg8OWrt2ReQGAEnCulEQP6KZC8unlmwuw+na1aeUhw3NKS/w/iKkij9TPz3CkvZQ+5pwo/I/cR0sDQsXRBtzhY2j+JaXiFwvhU6Q2gq2OiNuXdeYIPyvi2vkdYUKDKW2qoEBd6qyoYH37+DwMIi++i2nmsTwF5oPVl07Dp4VcN5YgK3E/tJnk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB6744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(396003)(376002)(366004)(186009)(451199024)(1800799009)(4326008)(15650500001)(2906002)(7416002)(5660300002)(52536014)(8936002)(8676002)(55016003)(41300700001)(316002)(76116006)(66556008)(66476007)(110136005)(66946007)(54906003)(66446008)(64756008)(966005)(478600001)(53546011)(7696005)(83380400001)(9686003)(38100700002)(38070700005)(82960400001)(33656002)(6506007)(71200400001)(86362001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnZMWFluNURpRXk2S1JOVjRuS0QxTmtiT1kwT25qdGVzUmpndlJ4N2RyRWZy?=
 =?utf-8?B?K1Yxejk1NDRuTGZPMGsrUDF0MTFPMkprdzVkTWl0ODBMbjJkbXk1NFBqaFJp?=
 =?utf-8?B?SlVjamluM3oxYTBOTlhsY2RCUko2OGVSbGpOZWpGSm1TeFdaa2lEYUlObzVu?=
 =?utf-8?B?ckdjbzJDQWhiU1J5bnNqMm9PcnhveDJXQkJzc05JQUN1U2kvclExckc1T2Ez?=
 =?utf-8?B?RTlXL0JkN2VGM1lkeWRuOEhTaDQrL2gxTXZ6WE56SDRndUxzLy8zV2tGNFVo?=
 =?utf-8?B?YXhlcWNDNmthS1dSYSsrRFZlaS9LUGtqNDVkU01jK0xIQkFnSTJNTDY2aGky?=
 =?utf-8?B?RkZyWWxHWHJ2bER1ZDNLRG8reWZhRHZxNUFUUnhya25HM1UyanRMbVFxQ1Zn?=
 =?utf-8?B?R0RaSHpTTUY4cHdnTGpnaUJoM01TbmVYSFF6Y2s0SVhzSTgvNjZ6RWk2d0di?=
 =?utf-8?B?M0xIWjNKdWhuMkpFT1JoWlp1UDN2ZUxJNUN5ZzRjdFk2UHNSdWtydFhYTlBl?=
 =?utf-8?B?WEpLWU1NTEJKRkJrd29PWmR0WDVhUE9iRG9JaXI2dVVHUDFBdktBYmJPU1M2?=
 =?utf-8?B?YTEvUmdVb0lpd3F5U0d3NmV0MjB0SmhhMm9aM2I2RVlMWmV0cTVQWnlHYmdD?=
 =?utf-8?B?NUhyRlFObFZCSm5JMjVuOVJnM1ZpY0pPMGRvdFlJY3AzK0hPekFpQTNHcnEr?=
 =?utf-8?B?YVY5bTlzWG1RSVVBVGhSd0NTRCtDWkVLQU9mV21peXZGNFJDZC9FQ0g3NU44?=
 =?utf-8?B?L0dDdkZ6VGxXT2lYNkZGakF1TE5oZGhyUnRrTElWMWFnOVBSRUQ0NDlFM0Nl?=
 =?utf-8?B?cmFqTFNYS29LanRQcis4L2ZPYzBNRXZudyt6Zmw4dnlrWS9YcUw3eGVMaG5Q?=
 =?utf-8?B?djJ3b3czeUVRMjdZSnNQdlV0dThNN3hxTThyR2UwY3dkWUF2TWZ3YTNvZ1l2?=
 =?utf-8?B?WEFtU0ZKWHhsUEJJbDZrNmRaVzNJOW5vbDJCMEgzLyt0ajNQMExEMUZqMmFN?=
 =?utf-8?B?WnVRZGl0SEQyUUcyaU1DWHFsZTZRQmxEZEhSZkVQaXZyK0pHdTFENk5oeXo2?=
 =?utf-8?B?V0hya2lmL1FJN21jNTViTExFMFNrM2RBaFYxVzBSeWZRcDhqU0YvVHBKeWp4?=
 =?utf-8?B?TVpLZ0h4SUhuTGoyOTB4T016V2I2Yk1Fc3RpWjVURnlEblVxaFE0NWRqOVEw?=
 =?utf-8?B?aEl2Mm9od21HNEFLUkFTaUl0NzdneHFsT3l4MUxOMjZ6ZXcxbFVGTjNRTERI?=
 =?utf-8?B?V1JzQ0lQMTNHaU5JQ0h3SFMwS2paYkVyOHREYkZpQ25mdXQwQ0xPcktjOGNX?=
 =?utf-8?B?akFINGVlaFdkdXI0b05NTU1BblJveHFkUnM0S1lWSmNTa3pPTy93RjNRbXBK?=
 =?utf-8?B?bXpOTXJVRHhpZ3pwN3FaOThjKzBXK0lzMVBTdEM2QUdRWHZXWUVWV1RLa0JL?=
 =?utf-8?B?eUcyZXVZa3ZXQ1VlbEVoZWxKd1J1d1BVRnRYQWdUVDEyZFdLN2tVRU9vREI5?=
 =?utf-8?B?ckxOYU12WitRVlNWQ051ZUphQ0JObGdzQVZvVmZpanVYVHp5RWkzMWg4VHdD?=
 =?utf-8?B?NVhLdDRDV2c4UWNuVVF0bGVYTC9ZMnVITHJEazFwY1JGM1dLc3hCTmhkbEkr?=
 =?utf-8?B?RWJUaFMwR0lTdFRkNVdJUzc1b1Z2dUh3RGQ5VVgxdnhINzYrMEVoSk9LLzlu?=
 =?utf-8?B?akEzN2l2YkdRZzlFSEVMYTgwY0wxd05kbmJldXNBTnJjK29aZjgxVEwvOEpB?=
 =?utf-8?B?aktDRjhtR2pMMVlSYnhFQ21NNEl3YXVNNjRRd2wzckxobXRKZ0pyRU5xbDI3?=
 =?utf-8?B?UXhOUWd5SlBHSkJEWmM2QXlXVFRZLzg4amVkdE91UmhmRlhaMTBTSy9JcHE0?=
 =?utf-8?B?QU9iT3F6bWlxanBCV24zalRUd2JiWkZrbGFEMnpzQ0tZbXc4SVVobTVGM29m?=
 =?utf-8?B?QlNyVk92ZFpWUk04MVhBY0QrQm5NU2VGV0t3TGRsdVJXTUxJRS9SbHVMYXR6?=
 =?utf-8?B?dWR2QUxWM2tWRnQ0RjFOeGdIWmJ5SG5nRDZRdGJ0c3ljWGxoLzV1YlRTakVP?=
 =?utf-8?B?eDhQcmVMMGhCalZnNTlKVDhDTTVCeUUyYVVqcDIyY0JxYWpIVVR0L29hTS9u?=
 =?utf-8?Q?XYEY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB6744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2430986f-b050-4dc3-0c07-08dbb9cad843
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2023 11:15:06.5507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qvAB1ScrhnzX9O0LmrP3ZLfxFRRzeRAS8Nyt2gfBla7zy189bojCrsT3EdyCXhiDMho8GCq6nq1e9h5ZmYqs7mmj5k9j2wWXqh2CSuKju48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7844
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IEVyaWMgQXVnZXIgPGVyaWMu
YXVnZXJAcmVkaGF0LmNvbT4NCj5TZW50OiBXZWRuZXNkYXksIFNlcHRlbWJlciAyMCwgMjAyMyA3
OjA1IFBNDQo+U3ViamVjdDogUmU6IFtQQVRDSCB2MSAwMi8yMl0gVXBkYXRlIGxpbnV4LWhlYWRl
ciB0byBzdXBwb3J0IGlvbW11ZmQgY2RldiBhbmQNCj5od3B0IGFsbG9jDQo+DQo+DQo+DQo+T24g
OS8xNS8yMyAwNTowMiwgRHVhbiwgWmhlbnpob25nIHdyb3RlOg0KPj4gSGkgRXJpYywNCj4+DQo+
Pj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4+PiBGcm9tOiBFcmljIEF1Z2VyIDxlcmlj
LmF1Z2VyQHJlZGhhdC5jb20+DQo+Pj4gU2VudDogVGh1cnNkYXksIFNlcHRlbWJlciAxNCwgMjAy
MyAxMDo0NiBQTQ0KPj4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEgMDIvMjJdIFVwZGF0ZSBsaW51
eC1oZWFkZXIgdG8gc3VwcG9ydCBpb21tdWZkIGNkZXYNCj5hbmQNCj4+PiBod3B0IGFsbG9jDQo+
Pj4NCj4+PiBIaSBaaGVuemhvbmcsDQo+Pj4NCj4+PiBPbiA4LzMwLzIzIDEyOjM3LCBaaGVuemhv
bmcgRHVhbiB3cm90ZToNCj4+Pj4gRnJvbSBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC9qZ2cvaW9tbXVmZC5naXQNCj4+Pj4gYnJhbmNoOiBmb3JfbmV4dA0K
Pj4+PiBjb21taXQgaWQ6IGViNTAxYzJkOTZjZmNlNmI0MjUyOGU4MzIxZWEwODVlYzYwNWU3OTAN
Cj4+PiBJIHNlZSB0aGF0IGluIHlvdXIgYnJhbmNoIHlvdSBoYXZlIG5vdyB1cGRhdGVkIGFnYWlu
c3QgdjYuNi1yYzEuIEhvd2V2ZXINCj4+PiB5b3Ugc2hvdWxkIHJ1biBhIGZ1bGwgLi9zY3JpcHRz
L3VwZGF0ZS1saW51eC1oZWFkZXJzLnNoLA0KPj4+IGllLiBub3Qgb25seSBpbXBvcnRpbmcgdGhl
IGNoYW5nZXMgaW4gbGludXgtaGVhZGVycy9saW51eC9pb21tdWZkLmggYXMNCj4+PiBpdCBzZWVt
cyB0byBkbyBidXQgYWxzbyBpbXBvcnQgYWxsIGNoYW5nZXMgYnJvdWdodCB3aXRoIHRoaXMgbGlu
dXggdmVyc2lvbi4NCj4+IEZvdW5kIHJlYXNvbi4gVGhlIGJhc2UgaXMgYWxyZWFkeSBhZ2FpbnN0
IHY2LjYtcmMxLCBbUEFUQ0ggdjEgMDEvMjJdIGFkZGVkDQo+PiBJb21tdWZkLmggaW50byBzY3Jp
cHQgYW5kIHRoaXMgcGF0Y2ggYWRkZWQgaXQuDQo+PiBJIGFncmVlIHRoZSBzdWJqZWN0IGlzIGNv
bmZ1c2luZywgbmVlZCB0byBiZSBsaWtlICJVcGRhdGUgaW9tbXVmZC5oIHRvIGxpbnV4LQ0KPmhl
YWRlciINCj4+IEknbGwgZml4IHRoZSBzdWJqZWN0IGluIG5leHQgdmVyc2lvbiwgdGhhbmtzIGZv
ciBwb2ludCBvdXQuDQo+DQo+T0sgSSBzZWUNCj5kYTNjMjJjNzRhM2PCoCBsaW51eC1oZWFkZXJz
OiBVcGRhdGUgdG8gTGludXggdjYuNi1yYzEgKDggZGF5cyBhZ28pDQo+PFRob21hcyBIdXRoPg0K
Pm5vdy4gU28geW91IG5lZWQgdG8gYWRkIHRoZSBzaGExIGFnYWluc3Qgd2hpY2ggeW91IHJhbg0K
Pi4vc2NyaXB0cy91cGRhdGUtbGludXgtaGVhZGVycy5zaCBhbmQgaW4gdGhhdCBjYXNlIHlvdSBj
YW4gcHJlY2lzZSB0aGF0DQo+Z2l2ZW4gW1BBVENIIHYxIDAxLzIyXSBzY3JpcHRzL3VwZGF0ZS1s
aW51eC1oZWFkZXJzOiBBZGQgaW9tbXVmZC5oIGFkZGVkDQo+aW9tbXVmZCBleHBvcnQgYW5kIGdp
dmVuIFRob21hcycgcGF0Y2gsIG9ubHkNCj5pb21tdWZkLmggaXMgYWRkZWQuDQoNClN1cmUsIHdp
bGwgbWFrZSBpdCBjbGVhciBpbiB2Mi4NCg0KVGhhbmtzDQpaaGVuemhvbmcNCg==
