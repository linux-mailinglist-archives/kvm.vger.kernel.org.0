Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549D16F1212
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 09:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345340AbjD1HAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 03:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345433AbjD1HAS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 03:00:18 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C275D46A5;
        Fri, 28 Apr 2023 00:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682665217; x=1714201217;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TGxAMmZjxKWg9llVd99LNf6gQOWMtqw3rhVo0hUzUlE=;
  b=HDvDfaYgOmrBXu0uqUg//+/Yy2hgzR2cP9PnveNX8gtqHIukUKyYc+Oh
   exSY4PFMrSDt/HdazdVjPJmGx79MkdSZbwoIH/cMnFKe30AM+cRGE6lLK
   M2ToWyZhXOj8Msxrytb4o7RDWv1zjkkAUJXmD/f6pu8astRrLq3r15WeN
   4aZ6LOu077CO2uT2ZNpuacyUMaQo57Y8Dc6heO9efbVlJ/RDHbcdGxxFy
   uYHewnVuSCBTl6CMpLqtLmJ6oAIUoyrrgdqS44PxhWTmaL2WPKQvCqwBd
   nEDtu1Jxkre8w0KU1G+jAGHhj2OtTJOOzWIO/T9isumKYEjEDpW9E8Toe
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="410755049"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="410755049"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 00:00:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="764169876"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="764169876"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 28 Apr 2023 00:00:16 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 00:00:16 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 00:00:16 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 00:00:16 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 00:00:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhJg3pDk+Wxc5d+t1A8lX8OQA8upLKYJk15lHALu5plZRnK5MgF+axbGxVVM/ET/00vz/a9RfgIFN2g3hn3qK2T8t3VIo0JjQPfEWfwG3cfTQGb63tZefcVNUDIPxOf9mCJ9sCk3SETxb+FxKYKWb4RsBip9utUW+hwLLBSgSLOn7G4Q3vbN+TLyFJJnfKAErZg9xSqfx4JtSZEuWzn4t5u5T7/G78A9YTR3WSF6TzNCkRdI7JQyf8oQ78ALUv7DjSyk9t4JtNy/IRPGxr2K2tVu3zKqqoRlaWkTpApq8iV1GXa5Rbh43+pKjuE54fzhgnakluqxXvO32vOLmIDKBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TGxAMmZjxKWg9llVd99LNf6gQOWMtqw3rhVo0hUzUlE=;
 b=YehC1MsUM9397SyHPyQOWaQHonvgeT8YEp+cnHr01oppL1qhYXVebSWfYDNSOfb/KQBzfMEda5x5FyGTbx1V/e/eHxmrFJycbIioqMsECbM8aRe3NzDSrBrsSt019YuCnmiOVIOFtqQAaomWcs00RAq7zqN4PbDCf01mYvK38eU4TcvinxpNdpmRGofrQiRBuLTyO6Vqh43D1WWWS+oxi5RfSFL/QhhxsTECxsWIxvtAg5J6yz/LhDxgq9ShdXjbUuFQHt868SugxNYM+PHu1zErWu/5RkF1aOw3g8ob4ZnWcpsnaRmtFpfpquXfNWUGUn/LP6yPh3UJtztP41J81g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB6493.namprd11.prod.outlook.com (2603:10b6:8:c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 07:00:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 07:00:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Thread-Topic: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Thread-Index: AQHZeE8IJJf3ZFXia06J+R1rLA70za8+tH4ggAAGdICAAMGPgIAAxjMAgAAJ/cA=
Date:   Fri, 28 Apr 2023 07:00:13 +0000
Message-ID: <BN9PR11MB5276A619F48F99D70073682B8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-3-yi.l.liu@intel.com>
 <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752972AC1A6030CB442ACF3FC36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230427123203.22307c4f.alex.williamson@redhat.com>
 <a6b77884-1678-b17c-f6a4-28d56e6c366b@intel.com>
In-Reply-To: <a6b77884-1678-b17c-f6a4-28d56e6c366b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB6493:EE_
x-ms-office365-filtering-correlation-id: b9daec74-6043-4751-3b9e-08db47b63719
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RTh15fvdYQ3Pq2WXX/0efIGPfJ2y5760+BPEs2VxN3eW2PQ7ENXXforEiGPLtt4k07m06rifjD3jaD34lXlQhZKA6GVhcjtMecjrvLfz6R3vk2Sy+tVnEUm4v2nQzbZGypAsIvsqZX3+y0uQcatTvf2fW1y+GX3Ox+8M7epbJQQHGVTxNieCaaP39FlM7+X0vNdXjCKBDXHrd2eHacD9Jc6LxOw+FEIIU3fGbv2T1+QRy5vNKy3ECSqowehBNOq0YTbZnjOelhQeXHjf0rDY1A4ccODWth0evgXzrMWPSnv5Yk4lMRB3D+SVXhFgfnaNSFnvZZNubVjym+Tbxb9gaWeMkgCOSg9sCn2XBo2ULB4m3FlqI5kdXxJ+RGmFWXmVKq+DrpUo3MD/zX8OIqGEZJXr7pghgXdUBhJWEoWH5hOSTmfQlpiemgUQTzM4tQ2bZtMkL+q5PjEwcxu83r/MwH0/+NFN2qzrL/rXJxvWz7wb8rDI8ugJ3r8jigJZQ4UrEXNqQ2pYA2dbY0TVC57hGmziL13akOhX8prQ07bGx2EPNteFVE9nzSocTMZajWN2ahEjcpuBmm0uKUaID5nZWccfHjTSpBeb1YEJ3DDdajY4W8lrEZnvhyeWigP19e5I
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199021)(8676002)(82960400001)(9686003)(26005)(6506007)(53546011)(41300700001)(55016003)(7696005)(71200400001)(186003)(33656002)(54906003)(110136005)(66899021)(122000001)(478600001)(66556008)(66476007)(66946007)(64756008)(66446008)(76116006)(316002)(7416002)(38100700002)(4326008)(52536014)(5660300002)(38070700005)(86362001)(2906002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlByeU51REYzdWNaaE5HUG5QdUNSSHVwNjBKa24wd0tMWUNVN2FnRzZuMmw4?=
 =?utf-8?B?SnVXbENNRWluc2oyb0orejNyZHFOMklGWTVRM3M0VURzUER2R1RmcjJ6Q0Zt?=
 =?utf-8?B?YjRmVmdXdURDMEFheXlZYXNtbjhjMTk3US9GSnZGQkZ4Q09sMi9oQ3BkR3lY?=
 =?utf-8?B?eXE2eDJycGY5MlQ1cm1IN0NtSWw2L3hrbmcwc01oUHRXV2dJYUNIaXlZZVl2?=
 =?utf-8?B?a0FvYTgxcjR3WkdUazRYUjJ4dmJaNjVvSmtQeklBSHA3REdVSkZ2Z0ZxU3NR?=
 =?utf-8?B?ZFo1NGppWmYzU0xFR2dYZ25vMmZPOUk3YlhtTWJmV3pYK1JQeVNCbXpNRWJz?=
 =?utf-8?B?cEhSZUtBTjg0K0lqQ3N1Vi9yMStJUkl5eEhaMkhlK3NiVlVxMVRDOStnL1Zz?=
 =?utf-8?B?N2p4MzRwVWFFRDl0aWdzYWlyREo3K0pTem1lNTkzcFQzVlJvaDVlMG02MXJD?=
 =?utf-8?B?VWx5SUsvZGhVdktoZ1FyK3EzUkVyNm1MdHVqajVMVjQra0N0ZlNsbWZodEpB?=
 =?utf-8?B?V2RyL084Zzc4a2xNVE40dC9NNE5Bay8rUzJqM3RsTHBtckZPUmZaSGtpWDUx?=
 =?utf-8?B?cHEyNmNYMGVnUmU2d3lyTWVIU2lTVTlMSDJzUVdFZWQwTnZMUUQwL0d2SGZa?=
 =?utf-8?B?bDN0OGltSkpSYzhCaWlzUHdjUG9TL2U5UXRDZzdqWFdVc01Bd1NPd2E1Q2g5?=
 =?utf-8?B?d1RiQjNMdFpucVNVc1Y0MUoxVUNxNWJBd1hYSno5K28wVE9xMHhJRi9GMmM3?=
 =?utf-8?B?dFYrdmYzKzRQcFBTYnBha0syRHl5UVZNNFoxTHpzS1dGMGdtd0RiVWd1QzNO?=
 =?utf-8?B?eHBWUjhqTWRtditNVHlFUjJBL3VCcU51V1J4R0tNOEE1aVArQUkvZHFrQlgz?=
 =?utf-8?B?RW4wNVNENUJWSHo1Q3pzTEpzMXpGbThBd1I3dUZQQk1DbUpSeGRXd1NDT1VG?=
 =?utf-8?B?SzlXT1hLSm8vMHJ2bXBsTW10YkNnWnBKSC9BZVdTMkpxWjdENGlhU1MwRk5x?=
 =?utf-8?B?eEtUT2YvRU5wU2Z2YWE0S0Y2RENrdUtGT29hQUNmTzVaRm5FZjRaN3psbDhx?=
 =?utf-8?B?bmhFbjZSb2hmM3REb2VEeUZQenBhbkhQMkpiZHVlWC9odDIwd2w2MFR0Y2Vt?=
 =?utf-8?B?bHAwRERNZDhBSzRMT0hQMDQyQ3M4QnNoK3V6M3BkeTY3NXNYM0Jpdk51N1RP?=
 =?utf-8?B?TEV2UC9veWJGUzE0d3grNXhqUnErTXVSMm9sSzRjWkpQK1JSUklxazFHZ0dn?=
 =?utf-8?B?c1AzMVFTcVJJUFZhUWdkUDNOeEMvT2tWWnZ2TU1JY2RyMDhXcFhSM0tBK1Vj?=
 =?utf-8?B?WnlzUmc4ZFpyMWF2UUo3VjdLOVpKZm1WZWd2UzZDclRud2FGTUxjRkV6VUZ1?=
 =?utf-8?B?NGZ5bzdoRkcvbzRFQTg2bU9qY2tYcnZCNUpIOGE1eW1mNytzWFJjeTNrZXRO?=
 =?utf-8?B?TEF2cUsyc2NDTUYyUkxEQkRvb0JkUDl3bWVqczA1bXMrcGcwK1dJbHBrSWNv?=
 =?utf-8?B?bjZZSUI3RWo1ZUNiQnBZaUhsQm9sSjVxL0JlbG9hRmIxTmJRc3dTOWRFNlJh?=
 =?utf-8?B?bCtsZjlXbWV4aTRwY3hkbUlueUJIRFpyUXI2QUtDOFhheUR5VGMxVHV6ZTNC?=
 =?utf-8?B?T2xYUWRibEhPcEU4L3REU3NKVElsZHl2NE12ZlJ3Vm1QYW4vZGlyTHpvQWRZ?=
 =?utf-8?B?cTZsZ2xPSlNZQThlV1liTDI2UUR1NUNkUGx3MlpXUWxTclNvUEFDN0NhZTFF?=
 =?utf-8?B?bmtMWGIydE12SHZ3QXZYVnRVYVhNL1g4V3dYVExwZlRHeDBLNVhidmhLZ3BO?=
 =?utf-8?B?eUY0TWlvcDJBZng2bEtGMVZVVUFCVHNHWWtaaDZublFjb21tS25kWXM2ZmVU?=
 =?utf-8?B?WEZOMmY1eTY0RHBoa3lrU1Z4YTJMaTdzYlp1Vm5zOTdNdXUzcXhxWWtFb3c1?=
 =?utf-8?B?bjRYSklDL2RDbUowenIxbEE2aHhLeTRET0dFVU1SUEUyei9Hc2Y0UHQ3YytF?=
 =?utf-8?B?WjRpcHhqZHJ4K3ZCOHlxWU9RS2NwNWZ2dmdWSSt2blNLSXBURWxiL0tDTGZT?=
 =?utf-8?B?WFQ1MEhYUXcxVStWTkVIZjhRTTU3NGRTd2xOdWxoNFJOUi96RDNKQlBYTjZs?=
 =?utf-8?Q?ZmVVksqSgiIIwfLXXpDNae49F?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9daec74-6043-4751-3b9e-08db47b63719
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 07:00:13.6596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aBMO70kLlTNY+kdhKKqVEtBaewJz7xQCxxqblmiDQKrqd+f5LmJJ2DbhnQL7+5EJETQUMxA+B9/01JzHe6O23A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6493
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

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBB
cHJpbCAyOCwgMjAyMyAyOjIxIFBNDQo+IA0KPiBPbiAyMDIzLzQvMjggMDI6MzIsIEFsZXggV2ls
bGlhbXNvbiB3cm90ZToNCj4gPiBPbiBUaHUsIDI3IEFwciAyMDIzIDA2OjU5OjE3ICswMDAwDQo+
ID4gIkxpdSwgWWkgTCIgPHlpLmwubGl1QGludGVsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPj4+IEZy
b206IFRpYW4sIEtldmluIDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4gPj4+IFNlbnQ6IFRodXJz
ZGF5LCBBcHJpbCAyNywgMjAyMyAyOjM5IFBNDQo+ID4+Pg0KPiA+Pj4+IEZyb206IExpdSwgWWkg
TCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+Pj4+IFNlbnQ6IFdlZG5lc2RheSwgQXByaWwgMjYs
IDIwMjMgMTA6NTQgUE0NCj4gPj4+PiBAQCAtMTIxLDcgKzEyOCw4IEBAIHN0YXRpYyB2b2lkIHZm
aW9fZW11bGF0ZWRfdW5tYXAodm9pZCAqZGF0YSwNCj4gPj4+PiB1bnNpZ25lZCBsb25nIGlvdmEs
DQo+ID4+Pj4gICB7DQo+ID4+Pj4gICAJc3RydWN0IHZmaW9fZGV2aWNlICp2ZGV2ID0gZGF0YTsN
Cj4gPj4+Pg0KPiA+Pj4+IC0JaWYgKHZkZXYtPm9wcy0+ZG1hX3VubWFwKQ0KPiA+Pj4+ICsJLyog
bm9pb21tdSBkZXZpY2VzIGNhbm5vdCBkbyBtYXAvdW5tYXAgKi8NCj4gPj4+PiArCWlmICh2ZGV2
LT5ub2lvbW11ICYmIHZkZXYtPm9wcy0+ZG1hX3VubWFwKQ0KPiA+Pj4+ICAgCQl2ZGV2LT5vcHMt
PmRtYV91bm1hcCh2ZGV2LCBpb3ZhLCBsZW5ndGgpOw0KPiA+Pj4NCj4gPj4+IElzIGl0IG5lY2Vz
c2FyeT8gQWxsIG1kZXYgZGV2aWNlcyBpbXBsZW1lbnRpbmcgQGRtYV91bm1hcCB3b24ndA0KPiA+
Pj4gc2V0IG5vaW9tbXUgZmxhZy4NCj4gPj4NCj4gPj4gSG1tbS4gWWVzLCBhbmQgYWxsIHRoZSBk
ZXZpY2VzIHNldCBub2lvbW11IGlzIG5vdCBpbXBsZW1lbnRpbmcNCj4gQGRtYV91bm1hcA0KPiA+
PiBhcyBmYXIgYXMgSSBzZWUuIE1heWJlIHRoaXMgbm9pb21tdSBjaGVjayBjYW4gYmUgcmVtb3Zl
ZC4NCj4gPg0KPiA+IE5vdCB0byBtZW50aW9uIHRoYXQgdGhlIHBvbGFyaXR5IG9mIHRoZSBub2lv
bW11IHRlc3QgaXMgYmFja3dhcmRzIGhlcmUhDQo+ID4gVGhpcyBhbHNvIHNlZW1zIHRvIGJlIHRo
ZSBvbmx5IHBlcmZvcm1hbmNlIHBhdGggd2hlcmUgbm9pb21tdSBpcyB0ZXN0ZWQNCj4gPiBhbmQg
dGhlcmVmb3JlIEkgYmVsaWV2ZSB0aGUgb25seSBhY3R1YWwganVzdGlmaWNhdGlvbiBvZiB0aGUg
cHJldmlvdXMNCj4gPiBwYXRjaC4NCj4gDQo+IGJ1dCB0aGlzIHBhdGNoIG5lZWRzIHRvIHVzZSB2
ZmlvX2lvbW11ZmRfZW11bGF0ZWRfYmluZCgpIGFuZA0KPiB2ZmlvX2lvbW11ZmRfZW11bGF0ZWRf
dW5iaW5kKCkgZm9yIHRoZSBub2lvbW11IGRldmljZXMgd2hlbiBiaW5kaW5nDQo+IHRvIGlvbW11
ZmQuIFNvIG5lZWRzIHRvIGNoZWNrIG5vaW9tbXUgaW4gdGhlIHZmaW9faW9tbXVmZF9iaW5kKCkN
Cj4gYW5kIHZmaW9faW9tbXVfdW5iaW5kKCkgYXMgd2VsbC4NCj4gDQoNCllvdSBjYW4gY29udGlu
dWUgdG8gdXNlIHZmaW9fZGV2aWNlX2lzX25vaW9tbXUoKSBpbiB0aGlzIHBhdGNoLiBJdCdzIG5v
dA0KYmlnIGRlYWwgdG8gZHJvcCBpdCBmcm9tIHRoaXMgc2VyaWVzIGFuZCB0aGVuIGFkZCBiYWNr
IGluIGNkZXYgc2VyaWVzLg0K
