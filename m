Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E7D6BA875
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 07:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbjCOGwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 02:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjCOGwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 02:52:37 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BFD66D08;
        Tue, 14 Mar 2023 23:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678863141; x=1710399141;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VGkfNAn89ZU7v33rcx1GbEZ1dKx7d0e1cGhiNquDyTE=;
  b=LpWgpf8VkMq6oarjncElbq4iJ+P/rQ30bkmlM7RwwzA5dx2BhkTjCerV
   JwYU69kyyn/ho/iW/NwruYsFhIzbrW6IuMicEy0FTzvpRBfAIakaM45xb
   Azh+XX7AAOaluMXcCmxwSWp65zEl+JhT4XLzdOzZcZnuANawuKBSG5D8J
   47DqQig04nr6kXvKB/+MgkSBt3hKnTuoJR266oGNY49GHvWOvqM8cFmHM
   JOmE4q4G1orcEIxeWwzlsJLiY7+a4eIoitzPPN7we77Ulcjrqej5nlLSY
   33C/8uUy5H6rcQtWo8z5jDyHuJ9IAa0Q/N7jkulxC5zPa1w3zOBtpcOuq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="402500856"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="402500856"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 23:52:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="711814023"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="711814023"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 14 Mar 2023 23:52:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 23:52:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 23:52:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 23:52:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 23:52:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oA9PA1O6VCei9ihcG/IbWhRe+wepIhKBgkm6D5jOInkmo4Qv2Jjo0CRsEeaH416/a5dgPmXDGxOrTk8tU9PIotO2H4q6fiPQq8wCbElTsj5XrbYrWuiVK/dCgyT//AA7YUSJCtC6llZyn+iKUn/6XD58t7WpMIiw829Bsa250iS3UI51+YA75orbQHtM2NduSliBkn+UzcirBqzX2D+9uzMGuudrhRVL/iz+98smJdzZB+4tmkkfy1HZQYfYaFgEVfMoRumWlSwovWflILPzE5LIhyGOUOfIQfENVB+T+K7jUeuhsdlr2ik2/1hwagXJemC+SaBPsqmo9mWJGhEOTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VGkfNAn89ZU7v33rcx1GbEZ1dKx7d0e1cGhiNquDyTE=;
 b=UGfdaMMH/joQMSc65Fq37Celn7EZkHxugex9n38UskaiUwB5a32z/k9odAyZI63q2ONfmI4d8Um/webGpu8L3OmDgQeHFPj+rokX756j6fDBm/CISPoA91rrbgcquVVoXaezcD8VEWcdtCwZ45TD4P5T7lONbJVM+9wuBEvAKmxc3HiILJMz3ijMcMuSNw18jx1jk3qWxn21urXXVKgVFSaJwOfjRhvS7EgDX6QcmyuTvJhxph9BVEJDie/wKx+WD8A9pye5gZBNZT1Gy2tQTW1inR0qIFNHQEDM+ybsCM63SPAu2uM9eqEbm2nXtUVsOtxnF7roukLbZvsPIvGRRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB5138.namprd11.prod.outlook.com (2603:10b6:303:94::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 06:52:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 06:52:09 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: RE: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Topic: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Index: AQHZUb/VKrDPi02EE0KOkFVtC1WCVq7zRkyAgAdh/YCAAL9UkIAAAa0AgAAIMwA=
Date:   Wed, 15 Mar 2023 06:52:08 +0000
Message-ID: <BN9PR11MB5276FDB32A40B521C0E351E68CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com>
 <BN9PR11MB52766F9DA462F5C7BC23654F8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBDCCYLJn32Yk/eI@Asurada-Nvidia>
 <BN9PR11MB52766160C546FA5075B191258CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFj8AZ4gWOW1PQs@Asurada-Nvidia>
In-Reply-To: <ZBFj8AZ4gWOW1PQs@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB5138:EE_
x-ms-office365-filtering-correlation-id: 35299e5e-adeb-41ee-374d-08db2521cc04
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GroFKT7Zo2jyGa/j2gehnRWU9bPRsXpID3uw1+/baa7hrkW3sLuxwyXbhqazC38b/nGaChmmqOwfUb7DJhR8ZT0K4GU+BM5f9Hh9eUt1hRGK2G6ytd0q8Y3CmgI8KR/crWJ+7DSB6o8wxcShVpmGSGCs8FyQN2RQhWaVEvgyIzkJBUF82iG7mENvkJ1s5uPXoAm40L6dMjiKmXnUlujnVywVgWtaTxSXUnY5+81GXDbRRMygB9HqvRslmBve3uc0bwkKa/fOH2V2jds33tOlU8cws/Y5ratEVMr9HXT1s3nIZU3S4JUVwfjQf31maOyXMU8INVU/HxHnzEEUFN1Id4yaY8tPJplh/OFzTlRCiOpKTxR/ds+IZjrYHuZL4+BuTBjXldie5EBLaAr0wV9/AEwGyVhy5f4EfsKoGSaEe7bma9NCBFfkuYKDk8hz/B88v7+xC5TM0nVmDUMbt4j7lmbveSLsSCrlZ/IDp3OzXGoHaPl2rRtKjYqr9/Iqm6LbaJqFnu0bELLuWBw++IiVsQRtQJ5Q+yer/ZFd9ItwbmWWGHwoqwdJJSbfoZuR+qHOmZ98a8Mz6FCKxp5Y2QXwT/Uw4/u2AAP+2lvXRAo/TSRkVWsKkeNFlR4irAniNHEnTBatOcfn8CVlGeaOB7/UcmsS66eMv5/x6afsfKKN2FIXhZI8ZPyhcqq+S9HQcfuW/aNnOZkT9zecfc64gmaYnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(136003)(39860400002)(396003)(376002)(451199018)(41300700001)(478600001)(7416002)(52536014)(8936002)(5660300002)(2906002)(38100700002)(86362001)(38070700005)(33656002)(122000001)(82960400001)(7696005)(66946007)(8676002)(66556008)(71200400001)(66446008)(76116006)(64756008)(66476007)(55016003)(4326008)(54906003)(110136005)(26005)(6636002)(83380400001)(316002)(9686003)(186003)(53546011)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3dReTRHdU1QakxNSDFOSWgyV1R5Qi8yeGZETnZmWU5MRjVySHA1a1Y3UHdi?=
 =?utf-8?B?K3lGaitLOUdXdHN5b0N0azNCdnk4SXlZQkdoOVVHMm1pZzJqbzFkbExFVjVN?=
 =?utf-8?B?T3BudGpZNkRQc3JDeVYzVFdZSzcrQm1yYWNQRE5qRzVaWTZ2dHVwL2h6RVpZ?=
 =?utf-8?B?Q2ZoeTlsY1BhTzJNNkp1Y2VnSG9oQ0REeTcrTGRkcFRZL3hiTzZOOHN5SWZn?=
 =?utf-8?B?MllWTVRyVDF1aDdUdUZtWVVhWTFWRkwrQlVZODVkZUZDZGpxWWdyWGhlQXZI?=
 =?utf-8?B?MU1mWFpjLzd1aHQzelFmUGJpc1VPOU5CZFIwMUJpY1pES0pISkRIdndkcSs0?=
 =?utf-8?B?bzd5eGMrcHdrWXJGWHlpU0UwUXNSUUZHMGlFOGNjeHltOE5JQXl5K0xSOXZu?=
 =?utf-8?B?dWF5Mi9ldkdieisvbXhBNE1UQkRRVS9tcHNwZEJiY3hNZ21qSzF2NC9melU0?=
 =?utf-8?B?VFlUNnJyejNzaExDQ0ZjcUR3NHNobFQrZmdSVmN3L2Juc2M5TlViVi84K0Zv?=
 =?utf-8?B?bW9qOUpZR2pYL3lLUE9URzUxU0hzU2R0YlZqOExvWXVuYzErMlViTXh6Tit0?=
 =?utf-8?B?bHN5RWdibjJMZWpSeDdnMW5EQjI0U09Zbk5ENVRJZ0ZqeG1XWndubDBPY2JU?=
 =?utf-8?B?RUVsY0dKMVpKV1pCN0ZudlNWc3ZZUXJSRHJYTmZjZENqa1dsN3VRcUJIdzRH?=
 =?utf-8?B?a1l2d1dFS0hVVGxQTmt2R3BxZVRVMFlMcUhYcmp1Q3FWU0JwTWJDYnBQUXVM?=
 =?utf-8?B?VjR0VWhUY3ZLS2g4NFdRRi9mMm5IcHZXZmNSNkQ0Zk41enhjTHJ2b2o4UTRJ?=
 =?utf-8?B?alpiQTNBWWZaSVVtOW9WZlRWNDhZbzg1K2o3YjhWWlJWeXVWdGNEcU92MXYz?=
 =?utf-8?B?bVV2M2hOcEJWM0c0ZS9lRGZtY2ZBZmFuUFZQU3BDUDBKbzZoWFRISjRVNHBZ?=
 =?utf-8?B?RXV6Z0tTRzU1QjdOdmZHNlN0L3JybGMvREZQRmhqZkNoMVAyZTNhUWVDS3pv?=
 =?utf-8?B?eWJLOUJ4TnkrWDZITkk0QzczSWgydy9YQW92c1laL3BaU3FhV09PTnpVYlcy?=
 =?utf-8?B?ZkRaQWRjOGkwYk84RCtScEt1WUZUQ1ExT2trNHQzSzdIVmpKNVdIQUVibzBj?=
 =?utf-8?B?OVd2dlpPNTZuM2xsbnl0Q2JNR0ZPSnpQWWVUN0hkcFN6S3ZRdlBSdVpaTktB?=
 =?utf-8?B?ZENSa2F0Z3RrS0IvZEFzcWUwRFZCemhpdUUveXJXYmFHOXFXMlFGYXRRYWhW?=
 =?utf-8?B?cmxaMnR4K3gxbjFDRk5Da2VrMEVUU0Q5S2VWd2hjdjNJODJ2RWlGNEJDTzRa?=
 =?utf-8?B?eCtLOE1ObzM5RTByWFd4Tzg4TXhoZTNWaXJUeHpnSG1YSWUySFBPcUVPcTN6?=
 =?utf-8?B?V1hQTzg3OWlPMHFlRTVadU9GakpnaWpvWHRXS3ZDR040YWtBRjdkbHgxN3pl?=
 =?utf-8?B?Y3JMWGlSSW1XMFBxMlVLc2NtcVVtZUZMcjk3ZGdBYUhuQWhsazRrZ1JWL3RS?=
 =?utf-8?B?Snk2eUpjUlFCVUpOYmpld25qMU9YcmxPVWlqek1QMHJZU01TUk54azNJNkhj?=
 =?utf-8?B?emhTejd1VDRGUURBd0ZmQVlCODl1U3Y0WjR3TGh6cWQ5WlNnUGlrazd3bnJn?=
 =?utf-8?B?MzdWaC9lWWQ3UndWSXhHc2VJY3NQNTRhWFBvdGFGOU1GYTV2VVNkajcwWnE0?=
 =?utf-8?B?YkFhRTJqdFFvSzhqTnl4bVc2R3kwM2J2RmlVYmFEUkF0bVkwSHBMWVhRaFJH?=
 =?utf-8?B?a1FFbnhra2xpQ0tNbFAvM2R5dHM0VUpEcjZIc0IrQ0VFTzdMUDdMYmF2RVEz?=
 =?utf-8?B?N3M3R05lQUNncWFwT1I3ZlhvK0cxL2o1L0VOclRTKzFWWlF3aUN3WFIrOW1y?=
 =?utf-8?B?WVJUVDFHdHo3WHVINkFEMVc5SDdGOGkvVG04RjNpTHY3bGZ0MVQzN2t6VlR5?=
 =?utf-8?B?aFI2WE5USnUxa0RkcFYxYlJUb2FObllLSDcxMGJWbWM2UWZTem5IYWRaNGdB?=
 =?utf-8?B?K0VxK0lpVzZWdnk5dWFWTmovTkpNSUhzTEMwVUNUamlNOGtsSG0vSWpqWGNJ?=
 =?utf-8?B?RXFhM1FQUE10YkhveEsvRDNlcmQvQzRVeUUyMzFuVHBqRDZhUk1ORWZKVXJ1?=
 =?utf-8?Q?lugl5Rts3bTDo3/tF/3+P77RB?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35299e5e-adeb-41ee-374d-08db2521cc04
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 06:52:08.9409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l0Qw+/Jyoy9FeWeHmYxpR2BA+3vOCdQbqveqRI6FTuCSnMxvHJc4QJb+QikmWr8/r5/JVLqo/62YEtFnJflVXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5138
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBOaWNvbGluIENoZW4NCj4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCAxNSwgMjAyMyAy
OjIyIFBNDQo+IA0KPiBPbiBXZWQsIE1hciAxNSwgMjAyMyBhdCAwNjoxNjozN0FNICswMDAwLCBU
aWFuLCBLZXZpbiB3cm90ZToNCj4gPiBFeHRlcm5hbCBlbWFpbDogVXNlIGNhdXRpb24gb3Blbmlu
ZyBsaW5rcyBvciBhdHRhY2htZW50cw0KPiA+DQo+ID4NCj4gPiA+IEZyb206IE5pY29saW4gQ2hl
bg0KPiA+ID4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCAxNSwgMjAyMyAyOjUxIEFNDQo+ID4gPg0K
PiA+ID4gT24gRnJpLCBNYXIgMTAsIDIwMjMgYXQgMDI6MDg6MTVBTSArMDAwMCwgVGlhbiwgS2V2
aW4gd3JvdGU6DQo+ID4gPiA+IEV4dGVybmFsIGVtYWlsOiBVc2UgY2F1dGlvbiBvcGVuaW5nIGxp
bmtzIG9yIGF0dGFjaG1lbnRzDQo+ID4gPiA+DQo+ID4gPiA+DQo+ID4gPiA+ID4gRnJvbTogTGl1
LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gPiA+ID4gU2VudDogV2VkbmVzZGF5LCBN
YXJjaCA4LCAyMDIzIDk6MTQgUE0NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IEBAIC00NDksMzMgKzQ1
MCwxOCBAQCBpb21tdWZkX2FjY2Vzc19jcmVhdGUoc3RydWN0DQo+IGlvbW11ZmRfY3R4DQo+ID4g
PiAqaWN0eCwNCj4gPiA+ID4gPiB1MzIgaW9hc19pZCwNCj4gPiA+ID4gPiAgICAgICBhY2Nlc3Mt
PmRhdGEgPSBkYXRhOw0KPiA+ID4gPiA+ICAgICAgIGFjY2Vzcy0+b3BzID0gb3BzOw0KPiA+ID4g
PiA+DQo+ID4gPiA+ID4gLSAgICAgb2JqID0gaW9tbXVmZF9nZXRfb2JqZWN0KGljdHgsIGlvYXNf
aWQsIElPTU1VRkRfT0JKX0lPQVMpOw0KPiA+ID4gPiA+IC0gICAgIGlmIChJU19FUlIob2JqKSkg
ew0KPiA+ID4gPiA+IC0gICAgICAgICAgICAgcmMgPSBQVFJfRVJSKG9iaik7DQo+ID4gPiA+ID4g
LSAgICAgICAgICAgICBnb3RvIG91dF9hYm9ydDsNCj4gPiA+ID4gPiAtICAgICB9DQo+ID4gPiA+
ID4gLSAgICAgYWNjZXNzLT5pb2FzID0gY29udGFpbmVyX29mKG9iaiwgc3RydWN0IGlvbW11ZmRf
aW9hcywgb2JqKTsNCj4gPiA+ID4gPiAtICAgICBpb21tdWZkX3JlZl90b191c2VycyhvYmopOw0K
PiA+ID4gPiA+IC0NCj4gPiA+ID4gPiAgICAgICBpZiAob3BzLT5uZWVkc19waW5fcGFnZXMpDQo+
ID4gPiA+ID4gICAgICAgICAgICAgICBhY2Nlc3MtPmlvdmFfYWxpZ25tZW50ID0gUEFHRV9TSVpF
Ow0KPiA+ID4gPiA+ICAgICAgIGVsc2UNCj4gPiA+ID4gPiAgICAgICAgICAgICAgIGFjY2Vzcy0+
aW92YV9hbGlnbm1lbnQgPSAxOw0KPiA+ID4gPiA+IC0gICAgIHJjID0gaW9wdF9hZGRfYWNjZXNz
KCZhY2Nlc3MtPmlvYXMtPmlvcHQsIGFjY2Vzcyk7DQo+ID4gPiA+ID4gLSAgICAgaWYgKHJjKQ0K
PiA+ID4gPiA+IC0gICAgICAgICAgICAgZ290byBvdXRfcHV0X2lvYXM7DQo+ID4gPiA+ID4NCj4g
PiA+ID4gPiAgICAgICAvKiBUaGUgY2FsbGluZyBkcml2ZXIgaXMgYSB1c2VyIHVudGlsIGlvbW11
ZmRfYWNjZXNzX2Rlc3Ryb3koKSAqLw0KPiA+ID4gPiA+ICAgICAgIHJlZmNvdW50X2luYygmYWNj
ZXNzLT5vYmoudXNlcnMpOw0KPiA+ID4gPiA+ICsgICAgIG11dGV4X2luaXQoJmFjY2Vzcy0+aW9h
c19sb2NrKTsNCj4gPiA+ID4gPiAgICAgICBhY2Nlc3MtPmljdHggPSBpY3R4Ow0KPiA+ID4gPiA+
ICAgICAgIGlvbW11ZmRfY3R4X2dldChpY3R4KTsNCj4gPiA+ID4NCj4gPiA+ID4gdGhpcyByZWZj
bnQgZ2V0IHNob3VsZCBiZSBtb3ZlZCB0byB0aGUgc3RhcnQgZ2l2ZW4gbmV4dCBwYXRjaA0KPiA+
ID4gPiByZW1vdmVzIHRoZSByZWZlcmVuY2UgaW4gdGhlIGNhbGxlciBzaWRlLg0KPiA+ID4NCj4g
PiA+IEkgZG9uJ3QgZmVlbCBxdWl0ZSBjb252aW5jaW5nIHRvIGp1c3RpZnkgZm9yIG1vdmluZyBp
dCBpbiB0aGlzDQo+ID4gPiBwYXRjaC4gUGVyaGFwcyB3ZSBzaG91bGQgZG8gdGhhdCBpbiB0aGUg
Zm9sbG93aW5nIHBhdGNoLCB3aGVyZQ0KPiA+ID4gaXQgbmVlZHMgdGhpcz8gT3IgYW5vdGhlciBp
bmRpdmlkdWFsIHBhdGNoIG1vdmluZyB0aGlzIGFsb25lPw0KPiA+ID4NCj4gPg0KPiA+IE5leHQg
cGF0Y2guIEkganVzdCB0cmllZCB0byBwb2ludCBvdXQgdGhlIHJlcXVpcmVkIGNoYW5nZSBjYXVz
ZWQNCj4gPiBieSBuZXh0IHBhdGNoLiDwn5iKDQo+IA0KPiBPSy4gSSBtYWRlIGEgc21hbGwgaW5k
aXZpZHVhbCBwYXRjaC4gUG9zdGluZyBoZXJlIHNvIFlpIGNhbiBqdXN0DQo+IHNxdWFzaCBpdCBp
bnRvIHRoZSBuZXh0IHBhdGNoOg0KPiANCj4gRnJvbSBkYmZlNzQ1N2QzNWVhOWE0ZGE5YzhlNmRh
YTgzOGIxMDFiYzhmNjIxIE1vbiBTZXAgMTcgMDA6MDA6MDANCj4gMjAwMQ0KPiBGcm9tOiBOaWNv
bGluIENoZW4gPG5pY29saW5jQG52aWRpYS5jb20+DQo+IERhdGU6IFR1ZSwgMTQgTWFyIDIwMjMg
MTI6NTE6MDcgLTA3MDANCj4gU3ViamVjdDogW1BBVENIXSBpb21tdWZkL2RldmljZTogRG8gaW9t
bXVmZF9jdHhfZ2V0KCkgYXQgdGhlIHRvcCBvZg0KPiAgaW9tbXVmZF9hY2Nlc3NfY3JlYXRlKCkN
Cj4gDQo+IFRoZSBmb2xsb3dpbmcgcGF0Y2ggd2lsbCByZW1vdmUgdGhlIGlvbW11ZmRfY3R4X2dl
dCgpIGNhbGwgcHJpb3IgdG8gdGhlDQo+IGlvbW11ZmRfYWNjZXNzX2NyZWF0ZSgpIGNhbGwgaW4g
dmZpb19pb21tdWZkX2VtdWxhdGVkX2JpbmQoKSwgZXhwZWN0aW5nDQo+IGlvbW11ZmRfYWNjZXNz
X2NyZWF0ZSgpIGNhbGwgY292ZXJzIHRoZSBpb21tdWZkX2N0eF9nZXQoKS4gSG93ZXZlciwgdGhl
DQo+IGlvbW11ZmRfYWNjZXNzX2NyZWF0ZSgpIG9ubHkgZG9lcyBpb21tdWZkX2N0eF9nZXQoKSBh
dCB0aGUgZW5kLiBUaHVzLA0KPiBtb3ZlIHRoZSBpb21tdWZkX2N0eF9nZXQoKSBjYWxsIHRvIHRo
ZSB0b3Agb2YgaW9tbXVmZF9hY2Nlc3NfY3JlYXRlKCkuDQo+IA0KPiBTdWdnZXN0ZWQtYnk6IEtl
dmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBOaWNvbGlu
IENoZW4gPG5pY29saW5jQG52aWRpYS5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9pb21tdS9pb21t
dWZkL2RldmljZS5jIHwgNiArKysrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pb21tdS9pb21t
dWZkL2RldmljZS5jDQo+IGIvZHJpdmVycy9pb21tdS9pb21tdWZkL2RldmljZS5jDQo+IGluZGV4
IDAxMzI4MDM0NDliZS4uZGMxMDE1YjAyYTUzIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2lvbW11
L2lvbW11ZmQvZGV2aWNlLmMNCj4gKysrIGIvZHJpdmVycy9pb21tdS9pb21tdWZkL2RldmljZS5j
DQo+IEBAIC02NDksMTMgKzY0OSwxNiBAQCBpb21tdWZkX2FjY2Vzc19jcmVhdGUoc3RydWN0IGlv
bW11ZmRfY3R4ICppY3R4LA0KPiAgew0KPiAgCXN0cnVjdCBpb21tdWZkX2FjY2VzcyAqYWNjZXNz
Ow0KPiANCj4gKwlpb21tdWZkX2N0eF9nZXQoaWN0eCk7DQo+ICAJLyoNCj4gIAkgKiBUaGVyZSBp
cyBubyB1QVBJIGZvciB0aGUgYWNjZXNzIG9iamVjdCwgYnV0IHRvIGtlZXAgdGhpbmdzDQo+IHN5
bW1ldHJpYw0KPiAgCSAqIHVzZSB0aGUgb2JqZWN0IGluZnJhc3RydWN0dXJlIGFueWhvdy4NCj4g
IAkgKi8NCj4gIAlhY2Nlc3MgPSBpb21tdWZkX29iamVjdF9hbGxvYyhpY3R4LCBhY2Nlc3MsIElP
TU1VRkRfT0JKX0FDQ0VTUyk7DQo+IC0JaWYgKElTX0VSUihhY2Nlc3MpKQ0KPiArCWlmIChJU19F
UlIoYWNjZXNzKSkgew0KPiArCQlpb21tdWZkX2N0eF9wdXQoaWN0eCk7DQo+ICAJCXJldHVybiBh
Y2Nlc3M7DQo+ICsJfQ0KPiANCj4gIAlhY2Nlc3MtPmRhdGEgPSBkYXRhOw0KPiAgCWFjY2Vzcy0+
b3BzID0gb3BzOw0KPiBAQCAtNjY4LDcgKzY3MSw2IEBAIGlvbW11ZmRfYWNjZXNzX2NyZWF0ZShz
dHJ1Y3QgaW9tbXVmZF9jdHggKmljdHgsDQo+ICAJLyogVGhlIGNhbGxpbmcgZHJpdmVyIGlzIGEg
dXNlciB1bnRpbCBpb21tdWZkX2FjY2Vzc19kZXN0cm95KCkgKi8NCj4gIAlyZWZjb3VudF9pbmMo
JmFjY2Vzcy0+b2JqLnVzZXJzKTsNCj4gIAlhY2Nlc3MtPmljdHggPSBpY3R4Ow0KPiAtCWlvbW11
ZmRfY3R4X2dldChpY3R4KTsNCj4gIAlpb21tdWZkX29iamVjdF9maW5hbGl6ZShpY3R4LCAmYWNj
ZXNzLT5vYmopOw0KPiAgCXJldHVybiBhY2Nlc3M7DQo+ICB9DQoNClJldmlld2VkLWJ5OiBLZXZp
biBUaWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT4NCg==
