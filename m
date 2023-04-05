Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68FC66D7E44
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 16:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbjDEOAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 10:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbjDEOAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 10:00:16 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9165F1BDD;
        Wed,  5 Apr 2023 07:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680703211; x=1712239211;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CEYyxPe9KrUD6LbOi9OYJYrF4u4T3AAqRc0tpCTfsIs=;
  b=Dd2AyE4ldR5WPatUmr5S+n706BsQs0XxtSQUMkoYhw7UgTSiPAyZGGCo
   r7byV0iL9Ejn6xD3rK4G0Vn9qYFZ85BRYQXfUv9lkrkbaxJmWBZtDUzHa
   6Ju4MbjF4eSF3khagdBo/kw5f5iSpkjmRXaV34yu0BXZHEDMnsDkRyriv
   EYI+9UqDTWf6nPmAtIW6E5r2Dy3IGcKYR0ZcnnwJK7rtnna3r8XCu/yQL
   YHZVONBzD312QFeFqt1aSB/mNV9NU9hxXSR0L7YOXvcOc1DkriMmrrMsE
   L4nqTZZHv3nKtYJD6noZhsbHUOlxlUlawgn8tl2OIiqG5GUVCf/ixdYzj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="342474909"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="342474909"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 07:00:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="719332766"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="719332766"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 05 Apr 2023 07:00:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 07:00:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 07:00:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 07:00:09 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 07:00:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdD879jPr5uHT2bRKDUzGfFb7ssSDpR42TbepAQ34ExUpWoYbj5TxiBEAWNkGzhh2SSX1AWBR9BG3JvIIIcSuRkZlYGmsn/3w/TitT3K6aZJM8Tn91qMq1IPXylIohV3FEudkxrTe+DQZKL2FKLPwDRqr2jKi7A7tJhb2zVicZcpzNE5RPQCOh4GqpEKLrguliGC0wPDj0T0N385ZLFx8qaR7Ex/kG3i065keAYFbQWUr9bssTPwHccBCTguak23o6GG5ghbESwKj3kc2V6/m7T0ZlA7Ysw5XDskTD0Ebc2LWhOT6LPzKt+vUtYlY7JvAZHYzJpdwA1tx97yhy/XaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CEYyxPe9KrUD6LbOi9OYJYrF4u4T3AAqRc0tpCTfsIs=;
 b=Q0Plec0RPOudrhH4rh8UePi238kjQLhhe6zoVdOsfkAv8miStnoAKglyj5soIjpTm+tF41A9cRPL1j7mLvAtT/stoFEywyI/EBioa/kF06ZKfO8s6UWeZdR3/4GbKp5b7s6bgwNsY9F81JaWt8Ke1gwVkAueoT4SAqx72SXIiyNtk1nw21G4cZ6sTQ3gRekHoqEH03suCR5iSByqFPf93P0n/GtaTOaPYgtfOQrROlnj8Yc46NLVyFsA1pjKNZYPpm4Sxrc5b6tlehbHM485LDrt6NHJgn3pSGf2jEzkXf8Ccfc0UUTJO18Li+x74cEA99fzH29CK+jMpZjZDXSzhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA0PR11MB7911.namprd11.prod.outlook.com (2603:10b6:208:40e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 14:00:00 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 14:00:00 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v9 25/25] docs: vfio: Add vfio device cdev description
Thread-Topic: [PATCH v9 25/25] docs: vfio: Add vfio device cdev description
Thread-Index: AQHZZK1I22lo3oshSECHFVLEjZkUbK8cwGyAgAACgeA=
Date:   Wed, 5 Apr 2023 14:00:00 +0000
Message-ID: <DS0PR11MB752960F2A336E30ACA9E9ECEC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
 <20230401151833.124749-26-yi.l.liu@intel.com>
 <cc500fe5-1fdf-1b71-a5b4-f9f917b1abf2@redhat.com>
In-Reply-To: <cc500fe5-1fdf-1b71-a5b4-f9f917b1abf2@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA0PR11MB7911:EE_
x-ms-office365-filtering-correlation-id: 2878df51-15a1-48b8-e11f-08db35de0c03
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L4Km9pNGi7CkGww/ZGeEMnbBrNKYTeBIUl2k6IE69uH+2/qFp6Zj51iW1UcT6sMvmAcz4+XvQPv/dwbIGbNXhivz/yWOnHNFVvn9byDjcS32YSLLk8EkBQE4o90tZL/yNKKRZ/YjF93QqFC1HcQCIJ7cSdgA3DK5jGGy7D+UGRi/l3h8Ke+8YYs9noKsJUE9SVLGiA1ocl6BwjGKXPECTFCbxU8ucS9UadnWBDAXiNqhRCMDl+gvHWLcNHWkS/g6d2sPN1S967BvS4a2cAsvuGwaj64vjx8DafMrfwPCLm+J9MZbBdKDSC8HUU5kRSEno5DKdTIb73zxf5AFDG8ad+Slnr6ZX2ys4DSv7G2M4rXXWMEJ22oQfAEZ23K324BZg/Zpplu08s6iPTCH+o389+h8hfF7rO48IYksEB/Ms4UpBjJOEKhqYdpJT6EyleYz8iXdVSvaA8TyiSpTvJzrBE8l9JgB1Yj5Rf718RAd02mv73B//nKuJgmrVorlxKmrLIpUy/ZQdUDpubaPibSE3qhCHkDHofljndf5BYG0NcAUxbKny6YnYXe6TYIGFXABlW9B8Q/0g2621tuykxCWHE4jty6/jb0lJ7tuEwc+cPrAbd5hqsHxEbfXnxUXJQZIQ3N27Ey7q6PugFHe+704sw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(366004)(39860400002)(396003)(136003)(451199021)(82960400001)(2906002)(38100700002)(122000001)(478600001)(6636002)(316002)(83380400001)(33656002)(110136005)(54906003)(8936002)(8676002)(71200400001)(7416002)(66476007)(38070700005)(5660300002)(52536014)(41300700001)(4326008)(55016003)(9686003)(6506007)(86362001)(26005)(66556008)(76116006)(66946007)(53546011)(66446008)(186003)(64756008)(7696005)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azV2SVQ3SDNRb3NqK1ZGS1NMZ2kwemY3Q3ZEMjAvQzFHSVk3eTI4eVA3NFAy?=
 =?utf-8?B?dnNFV012eVdBdVJ3Nnl2VEo0Rytma0x4NjBDU0dDbHltUVV1M1VjMW1kb2oy?=
 =?utf-8?B?d0dObUNsZmJ0ZjRwRXRFczNoSHJHem5iQ3FjdWZINDUrdDNGS2xyNFhhWXov?=
 =?utf-8?B?MmNwdnlGOWduNVBXRGtTQTZzNGV6N0toTDF2eWQ3UDZkWjNiNGJVRkc0QXhZ?=
 =?utf-8?B?S0xFUVdjUmtGTmxram1mRjNyTElOeFNpOEdWQ3ExRmR1WThiQ2xDRzZzWkdU?=
 =?utf-8?B?SXo3cC83VmduV20zNkVDMXRwWEljVEVrSGdJVVpPV0dDV2VjZXhMQzUya1Yy?=
 =?utf-8?B?LzhoMkZBL1VTYSsyZGx1ZXdxclFIdTY4U3k5SUZZNEhXTUhSam0ycWM2YmNk?=
 =?utf-8?B?TENnWmJFVkVCUjVrZ0hydXYxckQyTWJzYVpNd29VdUw4REJNYUhGaFZkNTFB?=
 =?utf-8?B?d2VhOTM2UFF5RVNCbXJxcURFNzhoQVRRTjVWbUp6ZVF2RkhyeUpvVzF3TlRz?=
 =?utf-8?B?b1ZvMXlRbFJFdkFVVWlwYTY4TmZWbWhnNUh5d1d1aGw0OEpQc3djSjFQc0VT?=
 =?utf-8?B?SHBHaTVVUkNycFZTTUdKRmVjeVo2MGM2V0VrNEhweHRmaHhwQXoyckFOUEJO?=
 =?utf-8?B?NGRRRXVHZXNPQnVsdERxaVBrNFJKK25DQVBMdGQ5TG9ZTEFVcHZibnl2Yk85?=
 =?utf-8?B?cVZER1JncXhUQU1pZ2JLV1dPNTJxbzFSMC9kSTNUYUkyT2FyWk1VcmdIdmtW?=
 =?utf-8?B?OC9ud0l4dEMzOHlYWHEzZWJvWkxXMVNmbDZJYlNBUlcrR2Y0TWo1TGgySW5C?=
 =?utf-8?B?TGxaVnpKMWsxUFo5clU1MWhpSzRxcC9kNnR4QXdmdkdqQkhWNllEM1BOV09F?=
 =?utf-8?B?WENrbmgvaFFkRFdFc3FrZ1pJN0Z0c1QyamV4aTBuNmdvLzh5Y0Iwd2gzdFJG?=
 =?utf-8?B?NjRDcm9ZdGJHcngwNkVmQ1lwZTJCWVJQeUVhUGRkMTBEOGg5VEJkaVhkZXNy?=
 =?utf-8?B?bXhLT0lOSE5tVy9yaXIxbGdjUnM3SmduMGtTYXlSS2pROVU1aVNsR0lZb2xZ?=
 =?utf-8?B?ekhHS2NOTmNNUHh1TXljMVFocjlWT2FMR0FvWWh1b1M1RDNwOVhudjhPOTBn?=
 =?utf-8?B?d2M3SjFDeHl3MVNvbC9jbVZpQnZkYVZDeUl4eVJOVjlEektvd3hUMytIMyt2?=
 =?utf-8?B?ZjlVNGtNLzd5R2szVnBDL2krdlFQSEdjMjlLYWNnNHVTVTR0QmVadmxENzd4?=
 =?utf-8?B?VTJMbm9ZK0VvUkpUOVVPb0o5dDNCaGNPbnVNSTByNnNHQ0RsaFAxb0I4Skha?=
 =?utf-8?B?c3FFWG05QzBON2JrMytxRjZQNmZVdng3Z0RoYmc5VnBZeDNoUlhHZnE3VUZM?=
 =?utf-8?B?RGNTcVN2OUVoQ3M5OUNWN3FJRUlrZEFidi93azA3ZnJuUnJ5OUgzSkVISU91?=
 =?utf-8?B?aHA3a0JZcWE4b2VKOWs4VkRXWStOSnRvM1E1NVpFcCtqNnM2ODFQaFFWTk0v?=
 =?utf-8?B?SS9KdnNrWEUrMDUvZEp0QkFxT0Z0SWhvS2owNDV1RThvYzVnbVdxK3hIYlBZ?=
 =?utf-8?B?MjdkMUs1YTQ3YUMwNGNzS2NDVUY5TGFSa3ZubjZkb2tLaGNmTDAwR2FORUNn?=
 =?utf-8?B?NmFjUDN5SitQVXcwRGJyVnluMG9yYTZ4SHEzU0VrWmlTY3NGZ0x0VWw2WTlB?=
 =?utf-8?B?Zi8waEc4TTNBQW9pbzFmeUVBOGp4K2F4c1pZK1NoSW5mWjQrMHNVN1BmeTg2?=
 =?utf-8?B?Y0c0dWRHMHZSYXdUek9tcG5JdjlNL0QwcysxRkVBVytJck1ZcTBTRGw0OGt4?=
 =?utf-8?B?SWVWSUpHaGNjSmt0dnZIbzhUY2o4UGtNeFBCdlVCcGdvTFFydTNTNDllenFY?=
 =?utf-8?B?d3RoOFJIcnozemZBYTIyT2tDUE5uOW4zZ0xNaFUxVjl6OFIyRTlOZWhWNllT?=
 =?utf-8?B?T2w1dUZ0SkNxaHUwZ0RHZzdab0tESEZ5dWRxRmM1YVZBalR2bkhpUGRYVFlJ?=
 =?utf-8?B?Q0pRQWZNOHlOQXNBTzJiMmxCVzR4N283SXh6eUlTdnRSNVJIb3NFZ3BvWTZR?=
 =?utf-8?B?eEtYVGdHUXVoa3ROZDcwbU03RWtlOFNxUFpPWmJ4eHYra3hodEYyTXVQRGk0?=
 =?utf-8?Q?7moESS3IhpTnu4lR1cEQTRC/G?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2878df51-15a1-48b8-e11f-08db35de0c03
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 14:00:00.3033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 10CVJmIIPd7T+NU/+72zOMJggZt7p27sZv/f3H5soUJiuvNeL7v42pWVlCP7y6zSVEdo0nISPjDZ4/Qg/59Nqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7911
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFdlZG5lc2RheSwgQXByaWwgNSwgMjAyMyA5OjQ2IFBNDQo+IA0KPiBIaSBZaSwNCj4g
DQo+IE9uIDQvMS8yMyAxNzoxOCwgWWkgTGl1IHdyb3RlOg0KPiA+IFRoaXMgZ2l2ZXMgbm90ZXMg
Zm9yIHVzZXJzcGFjZSBhcHBsaWNhdGlvbnMgb24gZGV2aWNlIGNkZXYgdXNhZ2UuDQo+ID4NCj4g
PiBSZXZpZXdlZC1ieTogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4gU2ln
bmVkLW9mZi1ieTogWWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIERv
Y3VtZW50YXRpb24vZHJpdmVyLWFwaS92ZmlvLnJzdCB8IDEzMiArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEzMiBpbnNlcnRpb25zKCspDQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kcml2ZXItYXBpL3ZmaW8ucnN0IGIvRG9j
dW1lbnRhdGlvbi9kcml2ZXItYXBpL3ZmaW8ucnN0DQo+ID4gaW5kZXggMzYzZTEyYzkwYjg3Li40
ZjIxYmU3YmRhOGEgMTAwNjQ0DQo+ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kcml2ZXItYXBpL3Zm
aW8ucnN0DQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9kcml2ZXItYXBpL3ZmaW8ucnN0DQo+ID4g
QEAgLTIzOSw2ICsyMzksMTMwIEBAIGdyb3VwIGFuZCBjYW4gYWNjZXNzIHRoZW0gYXMgZm9sbG93
czo6DQo+ID4gIAkvKiBHcmF0dWl0b3VzIGRldmljZSByZXNldCBhbmQgZ28uLi4gKi8NCj4gPiAg
CWlvY3RsKGRldmljZSwgVkZJT19ERVZJQ0VfUkVTRVQpOw0KPiA+DQo+ID4gK0lPTU1VRkQgYW5k
IHZmaW9faW9tbXVfdHlwZTENCj4gPiArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+
ICsNCj4gPiArSU9NTVVGRCBpcyB0aGUgbmV3IHVzZXIgQVBJIHRvIG1hbmFnZSBJL08gcGFnZSB0
YWJsZXMgZnJvbSB1c2Vyc3BhY2UuDQo+ID4gK0l0IGludGVuZHMgdG8gYmUgdGhlIHBvcnRhbCBv
ZiBkZWxpdmVyaW5nIGFkdmFuY2VkIHVzZXJzcGFjZSBETUENCj4gPiArZmVhdHVyZXMgKG5lc3Rl
ZCB0cmFuc2xhdGlvbiBbNV0sIFBBU0lEIFs2XSwgZXRjLikgd2hpbGUgYWxzbyBwcm92aWRpbmcN
Cj4gPiArYSBiYWNrd2FyZHMgY29tcGF0aWJpbGl0eSBpbnRlcmZhY2UgZm9yIGV4aXN0aW5nIFZG
SU9fVFlQRTF2Ml9JT01NVSB1c2UNCj4gPiArY2FzZXMuICBFdmVudHVhbGx5IHRoZSB2ZmlvX2lv
bW11X3R5cGUxIGRyaXZlciwgYXMgd2VsbCBhcyB0aGUgbGVnYWN5DQo+ID4gK3ZmaW8gY29udGFp
bmVyIGFuZCBncm91cCBtb2RlbCBpcyBpbnRlbmRlZCB0byBiZSBkZXByZWNhdGVkLg0KPiA+ICsN
Cj4gPiArVGhlIElPTU1VRkQgYmFja3dhcmRzIGNvbXBhdGliaWxpdHkgaW50ZXJmYWNlIGNhbiBi
ZSBlbmFibGVkIHR3byB3YXlzLg0KPiA+ICtJbiB0aGUgZmlyc3QgbWV0aG9kLCB0aGUga2VybmVs
IGNhbiBiZSBjb25maWd1cmVkIHdpdGgNCj4gPiArQ09ORklHX0lPTU1VRkRfVkZJT19DT05UQUlO
RVIsIGluIHdoaWNoIGNhc2UgdGhlIElPTU1VRkQgc3Vic3lzdGVtDQo+ID4gK3RyYW5zcGFyZW50
bHkgcHJvdmlkZXMgdGhlIGVudGlyZSBpbmZyYXN0cnVjdHVyZSBmb3IgdGhlIFZGSU8NCj4gPiAr
Y29udGFpbmVyIGFuZCBJT01NVSBiYWNrZW5kIGludGVyZmFjZXMuICBUaGUgY29tcGF0aWJpbGl0
eSBtb2RlIGNhbg0KPiA+ICthbHNvIGJlIGFjY2Vzc2VkIGlmIHRoZSBWRklPIGNvbnRhaW5lciBp
bnRlcmZhY2UsIGllLiAvZGV2L3ZmaW8vdmZpbyBpcw0KPiA+ICtzaW1wbHkgc3ltbGluaydkIHRv
IC9kZXYvaW9tbXUuICBOb3RlIHRoYXQgYXQgdGhlIHRpbWUgb2Ygd3JpdGluZywgdGhlDQo+ID4g
K2NvbXBhdGliaWxpdHkgbW9kZSBpcyBub3QgZW50aXJlbHkgZmVhdHVyZSBjb21wbGV0ZSByZWxh
dGl2ZSB0bw0KPiA+ICtWRklPX1RZUEUxdjJfSU9NTVUgKGV4LiBETUEgbWFwcGluZyBNTUlPKSBh
bmQgZG9lcyBub3QgYXR0ZW1wdCB0bw0KPiA+ICtwcm92aWRlIGNvbXBhdGliaWxpdHkgdG8gdGhl
IFZGSU9fU1BBUFJfVENFX0lPTU1VIGludGVyZmFjZS4gIFRoZXJlZm9yZQ0KPiA+ICtpdCBpcyBu
b3QgZ2VuZXJhbGx5IGFkdmlzYWJsZSBhdCB0aGlzIHRpbWUgdG8gc3dpdGNoIGZyb20gbmF0aXZl
IFZGSU8NCj4gPiAraW1wbGVtZW50YXRpb25zIHRvIHRoZSBJT01NVUZEIGNvbXBhdGliaWxpdHkg
aW50ZXJmYWNlcy4NCj4gPiArDQo+ID4gK0xvbmcgdGVybSwgVkZJTyB1c2VycyBzaG91bGQgbWln
cmF0ZSB0byBkZXZpY2UgYWNjZXNzIHRocm91Z2ggdGhlIGNkZXYNCj4gPiAraW50ZXJmYWNlIGRl
c2NyaWJlZCBiZWxvdywgYW5kIG5hdGl2ZSBhY2Nlc3MgdGhyb3VnaCB0aGUgSU9NTVVGRA0KPiA+
ICtwcm92aWRlZCBpbnRlcmZhY2VzLg0KPiA+ICsNCj4gPiArVkZJTyBEZXZpY2UgY2Rldg0KPiA+
ICstLS0tLS0tLS0tLS0tLS0tDQo+ID4gKw0KPiA+ICtUcmFkaXRpb25hbGx5IHVzZXIgYWNxdWly
ZXMgYSBkZXZpY2UgZmQgdmlhIFZGSU9fR1JPVVBfR0VUX0RFVklDRV9GRA0KPiA+ICtpbiBhIFZG
SU8gZ3JvdXAuDQo+ID4gKw0KPiA+ICtXaXRoIENPTkZJR19WRklPX0RFVklDRV9DREVWPXkgdGhl
IHVzZXIgY2FuIG5vdyBhY3F1aXJlIGEgZGV2aWNlIGZkDQo+ID4gK2J5IGRpcmVjdGx5IG9wZW5p
bmcgYSBjaGFyYWN0ZXIgZGV2aWNlIC9kZXYvdmZpby9kZXZpY2VzL3ZmaW9YIHdoZXJlDQo+ID4g
KyJYIiBpcyB0aGUgbnVtYmVyIGFsbG9jYXRlZCB1bmlxdWVseSBieSBWRklPIGZvciByZWdpc3Rl
cmVkIGRldmljZXMuDQo+ID4gK0ZvciBub2lvbW11IGRldmljZXMsIHRoZSBjaGFyYWN0ZXIgZGV2
aWNlIHdvdWxkIGJlIG5hbWVkIHdpdGggIm5vaW9tbXUtIg0KPiA+ICtwcmVmaXguIGUuZy4gL2Rl
di92ZmlvL2RldmljZXMvbm9pb21tdS12ZmlvWC4NCj4gPiArDQo+ID4gK1RoZSBjZGV2IG9ubHkg
d29ya3Mgd2l0aCBJT01NVUZELiAgQm90aCBWRklPIGRyaXZlcnMgYW5kIGFwcGxpY2F0aW9ucw0K
PiA+ICttdXN0IGFkYXB0IHRvIHRoZSBuZXcgY2RldiBzZWN1cml0eSBtb2RlbCB3aGljaCByZXF1
aXJlcyB1c2luZw0KPiA+ICtWRklPX0RFVklDRV9CSU5EX0lPTU1VRkQgdG8gY2xhaW0gRE1BIG93
bmVyc2hpcCBiZWZvcmUgc3RhcnRpbmcgdG8NCj4gPiArYWN0dWFsbHkgdXNlIHRoZSBkZXZpY2Uu
ICBPbmNlIEJJTkQgc3VjY2VlZHMgdGhlbiBhIFZGSU8gZGV2aWNlIGNhbg0KPiA+ICtiZSBmdWxs
eSBhY2Nlc3NlZCBieSB0aGUgdXNlci4NCj4gPiArDQo+ID4gK1ZGSU8gZGV2aWNlIGNkZXYgZG9l
c24ndCByZWx5IG9uIFZGSU8gZ3JvdXAvY29udGFpbmVyL2lvbW11IGRyaXZlcnMuDQo+ID4gK0hl
bmNlIHRob3NlIG1vZHVsZXMgY2FuIGJlIGZ1bGx5IGNvbXBpbGVkIG91dCBpbiBhbiBlbnZpcm9u
bWVudA0KPiA+ICt3aGVyZSBubyBsZWdhY3kgVkZJTyBhcHBsaWNhdGlvbiBleGlzdHMuDQo+ID4g
Kw0KPiA+ICtTbyBmYXIgU1BBUFIgZG9lcyBub3Qgc3VwcG9ydCBJT01NVUZEIHlldC4gIFNvIGl0
IGNhbm5vdCBzdXBwb3J0IGRldmljZQ0KPiA+ICtjZGV2IG5laXRoZXIuDQo+ID4gKw0KPiA+ICtE
ZXZpY2UgY2RldiBFeGFtcGxlDQo+ID4gKy0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiArDQo+ID4g
K0Fzc3VtZSB1c2VyIHdhbnRzIHRvIGFjY2VzcyBQQ0kgZGV2aWNlIDAwMDA6NmE6MDEuMDo6DQo+
ID4gKw0KPiA+ICsJJCBscyAvc3lzL2J1cy9wY2kvZGV2aWNlcy8wMDAwOjZhOjAxLjAvdmZpby1k
ZXYvDQo+ID4gKwl2ZmlvMA0KPiA+ICsNCj4gPiArVGhpcyBkZXZpY2UgaXMgdGhlcmVmb3JlIHJl
cHJlc2VudGVkIGFzIHZmaW8wLiAgVGhlIHVzZXIgY2FuIHZlcmlmeQ0KPiA+ICtpdHMgZXhpc3Rl
bmNlOjoNCj4gPiArDQo+ID4gKwkkIGxzIC1sIC9kZXYvdmZpby9kZXZpY2VzL3ZmaW8wDQo+ID4g
KwljcnctLS0tLS0tIDEgcm9vdCByb290IDUxMSwgMCBGZWIgMTYgMDE6MjIgL2Rldi92ZmlvL2Rl
dmljZXMvdmZpbzANCj4gPiArCSQgY2F0IC9zeXMvYnVzL3BjaS9kZXZpY2VzLzAwMDA6NmE6MDEu
MC92ZmlvLWRldi92ZmlvMC9kZXYNCj4geW91IG1lbnRpb25uZWQgaW4gdGhlIHBjaSBob3QgcmVz
ZXQgc2VyaWVzIHRoYXQgdGhlIEJERiBjb3VsZG4ndCBiZSB1c2VkDQo+IGlmIGNkZXYgaXMgYmVp
bmcgdXNlZC4gQWNjb3JkaW5nIHRvIHRoZSBhYm92ZSwgaXQgY291bGQsIG5vPw0KDQpJdCBzaG91
bGQgYmUgdGhlIGRldmljZSBwYXNzaW5nIGNhc2UsIG90aGVyd2lzZSwgQkRGIGNhbiBiZSB1c2Vk
LiBCdXQNCmZyb20ga2VybmVsIHAuby52LiwgaXQgaGFzIG5vIGlkZWEgaG93IHVzZXIgZ2V0cyB0
aGUgZGV2aWNlIGZkLCBzbyBpdCBuZWVkcw0KdG8gYXNzdW1lIHVzZXIgbWF5IG5vdCBoYXZlIEJE
RiBrbm93bGVkZ2UuIA0KDQo+ID4gKwk1MTE6MA0KPiA+ICsJJCBscyAtbCAvZGV2L2NoYXIvNTEx
XDowDQo+ID4gKwlscnd4cnd4cnd4IDEgcm9vdCByb290IDIxIEZlYiAxNiAwMToyMiAvZGV2L2No
YXIvNTExOjAgLQ0KPiA+IC4uL3ZmaW8vZGV2aWNlcy92ZmlvMA0KPiA+ICsNCj4gPiArVGhlbiBw
cm92aWRlIHRoZSB1c2VyIHdpdGggYWNjZXNzIHRvIHRoZSBkZXZpY2UgaWYgdW5wcml2aWxlZ2Vk
DQo+ID4gK29wZXJhdGlvbiBpcyBkZXNpcmVkOjoNCj4gPiArDQo+ID4gKwkkIGNob3duIHVzZXI6
dXNlciAvZGV2L3ZmaW8vZGV2aWNlcy92ZmlvMA0KPiA+ICsNCj4gPiArRmluYWxseSB0aGUgdXNl
ciBjb3VsZCBnZXQgY2RldiBmZCBieTo6DQo+ID4gKw0KPiA+ICsJY2Rldl9mZCA9IG9wZW4oIi9k
ZXYvdmZpby9kZXZpY2VzL3ZmaW8wIiwgT19SRFdSKTsNCj4gPiArDQo+ID4gK0FuIG9wZW5lZCBj
ZGV2X2ZkIGRvZXNuJ3QgZ2l2ZSB0aGUgdXNlciBhbnkgcGVybWlzc2lvbiBvZiBhY2Nlc3NpbmcN
Cj4gPiArdGhlIGRldmljZSBleGNlcHQgYmluZGluZyB0aGUgY2Rldl9mZCB0byBhbiBpb21tdWZk
LiAgQWZ0ZXIgdGhhdCBwb2ludA0KPiA+ICt0aGVuIHRoZSBkZXZpY2UgaXMgZnVsbHkgYWNjZXNz
aWJsZSBpbmNsdWRpbmcgYXR0YWNoaW5nIGl0IHRvIGFuDQo+ID4gK0lPTU1VRkQgSU9BUy9IV1BU
IHRvIGVuYWJsZSB1c2Vyc3BhY2UgRE1BOjoNCj4gPiArDQo+ID4gKwlzdHJ1Y3QgdmZpb19kZXZp
Y2VfYmluZF9pb21tdWZkIGJpbmQgPSB7DQo+ID4gKwkJLmFyZ3N6ID0gc2l6ZW9mKGJpbmQpLA0K
PiA+ICsJCS5mbGFncyA9IDAsDQo+ID4gKwl9Ow0KPiA+ICsJc3RydWN0IGlvbW11X2lvYXNfYWxs
b2MgYWxsb2NfZGF0YSAgPSB7DQo+ID4gKwkJLnNpemUgPSBzaXplb2YoYWxsb2NfZGF0YSksDQo+
ID4gKwkJLmZsYWdzID0gMCwNCj4gPiArCX07DQo+ID4gKwlzdHJ1Y3QgdmZpb19kZXZpY2VfYXR0
YWNoX2lvbW11ZmRfcHQgYXR0YWNoX2RhdGEgPSB7DQo+ID4gKwkJLmFyZ3N6ID0gc2l6ZW9mKGF0
dGFjaF9kYXRhKSwNCj4gPiArCQkuZmxhZ3MgPSAwLA0KPiA+ICsJfTsNCj4gPiArCXN0cnVjdCBp
b21tdV9pb2FzX21hcCBtYXAgPSB7DQo+ID4gKwkJLnNpemUgPSBzaXplb2YobWFwKSwNCj4gPiAr
CQkuZmxhZ3MgPSBJT01NVV9JT0FTX01BUF9SRUFEQUJMRSB8DQo+ID4gKwkJCSBJT01NVV9JT0FT
X01BUF9XUklURUFCTEUgfA0KPiA+ICsJCQkgSU9NTVVfSU9BU19NQVBfRklYRURfSU9WQSwNCj4g
PiArCQkuX19yZXNlcnZlZCA9IDAsDQo+ID4gKwl9Ow0KPiA+ICsNCj4gPiArCWlvbW11ZmQgPSBv
cGVuKCIvZGV2L2lvbW11IiwgT19SRFdSKTsNCj4gPiArDQo+ID4gKwliaW5kLmlvbW11ZmQgPSBp
b21tdWZkOyAvLyBuZWdhdGl2ZSB2YWx1ZSBtZWFucyB2ZmlvLW5vaW9tbXUgbW9kZQ0KPiA+ICsJ
aW9jdGwoY2Rldl9mZCwgVkZJT19ERVZJQ0VfQklORF9JT01NVUZELCAmYmluZCk7DQo+ID4gKw0K
PiA+ICsJaW9jdGwoaW9tbXVmZCwgSU9NTVVfSU9BU19BTExPQywgJmFsbG9jX2RhdGEpOw0KPiA+
ICsJYXR0YWNoX2RhdGEucHRfaWQgPSBhbGxvY19kYXRhLm91dF9pb2FzX2lkOw0KPiA+ICsJaW9j
dGwoY2Rldl9mZCwgVkZJT19ERVZJQ0VfQVRUQUNIX0lPTU1VRkRfUFQsICZhdHRhY2hfZGF0YSk7
DQo+ID4gKw0KPiA+ICsJLyogQWxsb2NhdGUgc29tZSBzcGFjZSBhbmQgc2V0dXAgYSBETUEgbWFw
cGluZyAqLw0KPiA+ICsJbWFwLnVzZXJfdmEgPSAoaW50NjRfdCltbWFwKDAsIDEwMjQgKiAxMDI0
LCBQUk9UX1JFQUQgfCBQUk9UX1dSSVRFLA0KPiA+ICsJCQkJICAgIE1BUF9QUklWQVRFIHwgTUFQ
X0FOT05ZTU9VUywgMCwgMCk7DQo+ID4gKwltYXAuaW92YSA9IDA7IC8qIDFNQiBzdGFydGluZyBh
dCAweDAgZnJvbSBkZXZpY2UgdmlldyAqLw0KPiA+ICsJbWFwLmxlbmd0aCA9IDEwMjQgKiAxMDI0
Ow0KPiA+ICsJbWFwLmlvYXNfaWQgPSBhbGxvY19kYXRhLm91dF9pb2FzX2lkOzsNCj4gPiArDQo+
ID4gKwlpb2N0bChpb21tdWZkLCBJT01NVV9JT0FTX01BUCwgJm1hcCk7DQo+ID4gKw0KPiA+ICsJ
LyogT3RoZXIgZGV2aWNlIG9wZXJhdGlvbnMgYXMgc3RhdGVkIGluICJWRklPIFVzYWdlIEV4YW1w
bGUiICovDQo+IGRldl9pZCBpcyBub3QgbWVudGlvbmVkIGFueXdoZXJlIHdoZXJlYXMgaXQgaXMg
dXNlZCBpbiB0aGUgcmVzZXQgZ2V0DQo+IGluZm8uIFdvcnRoIHRvIGJlIG1lbnRpb25lZD8NCg0K
YSBnb29kIHBvaW50LiBidXQgaXQgaXMganVzdCBmb3IgUENJIGRldmljZXMsIG5vdCBzdXJlIGlm
IGl0IGlzIGdvb2QgdG8NCm1lbnRpb24gaXQgaGVyZS4gb3IgdGhlIGtkb2MgaW4gdGhlIEhPVF9S
RVNFVF9JTkZPIGlvY3RsIGlzIGFscmVhZHkNCmVub3VnaC4gQWxleCwgaG93IGFib3V0IHlvdXIg
dGFzdGU/Lg0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCj4gDQo+IE90aGVyd2lzZSBsb29rcyBnb29k
IHRvIG1lDQo+IA0KPiBFcmljDQo+ID4gKw0KPiA+ICBWRklPIFVzZXIgQVBJDQo+ID4gIC0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCj4gPg0KPiA+IEBAIC01NjYsMyArNjkwLDExIEBAIFRoaXMgaW1w
bGVtZW50YXRpb24gaGFzIHNvbWUgc3BlY2lmaWNzOg0KPiA+ICAJCQkJXC0wZC4xDQo+ID4NCj4g
PiAgCTAwOjFlLjAgUENJIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gODI4MDEgUENJIEJyaWRn
ZSAocmV2IDkwKQ0KPiA+ICsNCj4gPiArLi4gWzVdIE5lc3RlZCB0cmFuc2xhdGlvbiBpcyBhbiBJ
T01NVSBmZWF0dXJlIHdoaWNoIHN1cHBvcnRzIHR3byBzdGFnZQ0KPiA+ICsgICBhZGRyZXNzIHRy
YW5zbGF0aW9ucy4gIFRoaXMgaW1wcm92ZXMgdGhlIGFkZHJlc3MgdHJhbnNsYXRpb24gZWZmaWNp
ZW5jeQ0KPiA+ICsgICBpbiBJT01NVSB2aXJ0dWFsaXphdGlvbi4NCj4gPiArDQo+ID4gKy4uIFs2
XSBQQVNJRCBzdGFuZHMgZm9yIFByb2Nlc3MgQWRkcmVzcyBTcGFjZSBJRCwgaW50cm9kdWNlZCBi
eSBQQ0kNCj4gPiArICAgRXhwcmVzcy4gIEl0IGlzIGEgcHJlcmVxdWlzaXRlIGZvciBTaGFyZWQg
VmlydHVhbCBBZGRyZXNzaW5nIChTVkEpDQo+ID4gKyAgIGFuZCBTY2FsYWJsZSBJL08gVmlydHVh
bGl6YXRpb24gKFNjYWxhYmxlIElPVikuDQoNCg==
