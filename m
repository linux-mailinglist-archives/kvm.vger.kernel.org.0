Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D69E672FC8
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 04:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjASDxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 22:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbjASDtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 22:49:15 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF8F6D6A3;
        Wed, 18 Jan 2023 19:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674100097; x=1705636097;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gieCoEvAYh44zo3/pt1P3CWDsxVSjwJEsvn/1B7WRwA=;
  b=ZEvZ/tEp7Ak/hvLRQaV3cmapSRskLDtvrSuHCijKkIyimKtE25SHoMwc
   TWQQLGkUToI88wlQeTJTZ1Ez/HzzwvKczh9CM5MAXUxrUykEnlSIwyFnI
   QMAA3mjiY0HNZ62hdRd9nEUg6inI3s9NkNf8Vq+R4Zxa1JlP1KGnjgQ7B
   RlnMGEdYfLz65nvNpX+rMoIEJyPhC5YAMtd0h6KWG60SKsBUTukIN/0FQ
   T6tRWhvOwtGQOqMEoEG1FQ+gF/bE6w7YmFXlwnDpDlSpaFgz6MfFiYj3A
   PBc8ao0j9RFO5iMEkVHIxzjJwbIrZ7HwICuJwFQGc9obLAl5ImAI3cqKT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="304868394"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="304868394"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 19:43:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="609919944"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="609919944"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 18 Jan 2023 19:43:39 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 19:43:39 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 19:43:39 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 19:43:39 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 19:43:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWHlOXfK8BLrEcHJdoqCTq40KNOGILpygxMjMzyVusULga/ALM8hHn86AG5EvdxYgBzGK7R91unMG0xEsc6QiDLGkJU3aAxgL9iIwcgYZWcOcNprZJu3vcqzpdZw+RnwHy9pmfb5ycD6WLNdUG/lsc2F78Qo/NMAp5L4rQ3kQ5YFhjfgnHys7mIBohsCBe+QHaUTfqcxFf8dwquXfbzGMuTW38IMkAKJUxvxobIok5q6gOKCAVMBL6QoiH33cpy7BUVIOYdr5mQY4aDX+p6tSmqyjI7R+FEJc/nK6L58SkInEHIN/DgQwTn8IYTgpkPHh3/wyzqBEigIUqyoHxy6XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gieCoEvAYh44zo3/pt1P3CWDsxVSjwJEsvn/1B7WRwA=;
 b=OWPauQMPedZD13fiXDg6vVZSV+LSduo+om2P6PZwAPIKJKxwvPY/chM187FN639ctFsl3bcbkqfLJ53lYRf2S/zxPNmVjijefuvPj0oMnSweiIelXtbrV4wBe90ysh846ua56YAkNauAn6SxhsTfOWcW81qz04BVOJGRtXa9ivnUwSoQ268MfJX6X/61ws7vtzQxd7iWVqJUmUIDr8EUphC5V2OW4Bsu9SQED66+p1M7kXof/r8SaM3PSkK4/hUn3yiI2A/V7OzztOfCmnhn8Pnt97RXPIzs89hCOdP4xrpG89Zd20eisFSf5tFe0ytfECrzC5PwqpeFFu5Sxj+syA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB7374.namprd11.prod.outlook.com (2603:10b6:8:102::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 03:43:36 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6002.025; Thu, 19 Jan 2023
 03:43:36 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: RE: [PATCH v4] vfio: fix potential deadlock on vfio group lock
Thread-Topic: [PATCH v4] vfio: fix potential deadlock on vfio group lock
Thread-Index: AQHZJ6vANRoQ9x2rxUaXBLM6X5ngE66jJF8AgADCPMCAAGPogIAA1ikg
Date:   Thu, 19 Jan 2023 03:43:36 +0000
Message-ID: <BN9PR11MB5276CC29F17B87D14D1E61FF8CC49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230114000351.115444-1-mjrosato@linux.ibm.com>
 <20230117142252.70cc85c7.alex.williamson@redhat.com>
 <BN9PR11MB52763D861C254248FD33F65C8CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <b5a7efc9-7cfa-3314-fe36-b8da4a25265d@linux.ibm.com>
In-Reply-To: <b5a7efc9-7cfa-3314-fe36-b8da4a25265d@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB7374:EE_
x-ms-office365-filtering-correlation-id: 7cbab47d-a605-463b-018d-08daf9cf5869
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MeguWyIz9Z+Dxq77gHrMBuBx54k8+jZzOwKuWmJq/QK8/eRkWkQb/Y+cvHkRN9bYXPr12c32v1pVL1SsmWiRGKJWgyqX2popAiN81CfUyt7A+NOgk0o8fUFOOwbksjOY9/FLzcef4DXixlTVVzxc2SrgZMpxUJV894grT3MhXxBT6jIG4VmBQpy5o+vyIbUtLJ3vCU9tI7zjFlUqKbU3e5FfB2TlfFzmeLRlDTZJpXE6XC+tVgV129rECBxe5VChpR76na82gQJgHuTvITY3pgSsS61j891+pfPT2JuWLjerjYR2c+D4R7eHyo/1fIMrkDfLW7auS7gPojBcUiErHYMotkMu0tM0j4gbS2NSe3dcl7tDMZeWZTlHmH6dVur+tXVLGodUKoxz7KOooUsPWmDq+Rzc90u0UhC3CW9SJPMxh1hvmknjL85bjreYyLbH2DQpMzzwfEQ+zGpVlvZV35I0PbG5sZ8IPswvrQprI9Zt7Wu013ixMXfGpIVkyC0ps8inWQ9Tu2ARVv3NnuiCOS8HyaxnL76bEszR3kiDPDpVBca3Lgne3LeDEsDKBiskjXo4Mf78EJPxzjJxVgFB6YXqOMZxa5lsluNfifM/eW+24WlyRdL7aTlOo1J0aio6zJtCb7silTichySS5YMnATZNrDLnOCXpSckHwTIwz4lvqOrBqkhnye3jEKntxu24i4vDQewlCfhm38xymp76ymKiFMpIvnTB6gMmzEM4ZTY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199015)(4326008)(38070700005)(64756008)(76116006)(8936002)(316002)(66446008)(66946007)(52536014)(66476007)(7416002)(8676002)(5660300002)(66556008)(55016003)(2906002)(83380400001)(38100700002)(82960400001)(41300700001)(122000001)(33656002)(966005)(7696005)(54906003)(110136005)(478600001)(71200400001)(86362001)(53546011)(6506007)(186003)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V2FHVnRPeFY3WG15REZ0KzZtbUNxQVllYm5iZjlQM1RTTEE0ZFMwaFkzMmpz?=
 =?utf-8?B?M1RPZlNEd3gxeGU3TlNmRHFpRUZaQUtTYTBzYi9mbjJZYXFOSDVVZDBoQk91?=
 =?utf-8?B?bFpLVTJGSEk1UmtocnNaamhCV0xZRE14bEowb0t4THMzd0VEaVlSaGpQdmln?=
 =?utf-8?B?Vk9NS0FjOTk3Q0FLTmZGTjMzUUlPYndTYVZDZDJheUp3em9TNndER28xWGxE?=
 =?utf-8?B?TkRBWUFUS1ZyNkxIU0F0Y0pZYjQ0TUZjNnpVaVF2dVR3cFdJZWlXWmQyYjJJ?=
 =?utf-8?B?clN1L2hURm11OGhXZlI2TUFJZkFzTEI0NXcvR2xXcXdOc1NhVFV1T1JSODRC?=
 =?utf-8?B?TTJsK3N6WllMYlZFL25tT2JwdXlIVXFyY09NS1A0R1F6MFlld0V4Qll3ZUlk?=
 =?utf-8?B?K2dGQkFOL2JjMDdZVHJHcEk5bks5ZGhNZkZXdGNGbUlESXNUZlVFN1Fwa2tU?=
 =?utf-8?B?WE0xOVNlNHlwWXdabHlCbXJBUzFXeU1lL2dQSEVuOHVjVHJ5MmszT29iVkFK?=
 =?utf-8?B?UUl5UDBXaU1aQUpkMmJUOUh0RmlKTXF0b3h5UjUzbHlGRFUyYU10UVM2TkFt?=
 =?utf-8?B?ZmdjVTl1d1ZCMXRjeDBML0JsS1F2cU90eEJOcHd3ZGNFTXFBaDNLN1JWV2NC?=
 =?utf-8?B?eHA3R3FYQjkxcVJMd1p6d1NxZWE4amc4bUFZYXkycEtVVHZ5cmpIdkFwVVpC?=
 =?utf-8?B?N21ZSzUzKzN0VnVUK2pwS3JWbG9qbmlQR2FTTHY4UGRkN1ZXUllqbjJGR29S?=
 =?utf-8?B?K3d2QkRuRG1NUjJoS1ZtV3NWbWx3Zm9CdXh0WGthSDRKZGZZNGxlZ2lrcGVq?=
 =?utf-8?B?UVNib3crdHdtR0U1OU9SbW1zcE03dU5iUWtLa2VzOVZTVS9ibU5Nb1dKaUwz?=
 =?utf-8?B?QkZRTHhWbnl0QmIvb0cyL25SU2lLcVFYQXo0RDZFaHFBMFZyTkJWR2VXcFFJ?=
 =?utf-8?B?RVRReWxyMFpsRzY3SFp4Sk5FU21GM1ZiTjlieThSWWZ3MXEwcWlKWHZRR0Vv?=
 =?utf-8?B?ZDdGWUtueEN1S2E2ZDdZOXN3UmFMTkplY3ZFdVNEc2RJWHBYZlBrTlZGNExH?=
 =?utf-8?B?YjdOOG5ONlNXUGlwRWhtdGZTdFQzdnJiSXRFRm1nOHhFWk85Y3ZFOWFQaXVi?=
 =?utf-8?B?YXVxSXZUMWZ1WWxleWhyL0Jwc3h1QVBtcy95Y0tzallEOWpHdHg3R1Z4YXlE?=
 =?utf-8?B?OWJMQWhUWkluenl1dGRMazlTNW1zVmpWSDkzdy9DU24xSEcxU3Y3MGtaL1cr?=
 =?utf-8?B?dXpBTGwrcjVFL2locXhJcUgrckR3QVVJaG5pWTJ2Q0pDTW5CZHZ0RDNGOUlv?=
 =?utf-8?B?Z1F4NU5DMUthMitCQ1NEU21SbWRxamV0SVlOcFB4TTl0NC9PL3VxSUV6ZTVw?=
 =?utf-8?B?a3JhVTVMci9aaXB2ZC91ZWMyb3dnb0NFdm1PY3JRN3VwTStJZjVWWld1SkZ4?=
 =?utf-8?B?YW4xTmFtMWwwZDNxY1l4R0NDczNqc1NlZDhUQVJOU3RJRmFhRmVmY1E1TTVW?=
 =?utf-8?B?amFCaG5kS0VwdmF0T3UrdkFXTXZsSFFLVW9CUWFMTkRUcm16MTg4UUVHMDJU?=
 =?utf-8?B?R0RnNUUwRDlzTmZCdVlzdC9ETlpTMVh4Z0RpdE5qMG5jcGREYldlODhzRHJa?=
 =?utf-8?B?RVpWbzhGVTk4Unc4SlZVbnR5dzJxOTVPbEY5cHE3UXlwYkdyNXcvNnRQUmJ5?=
 =?utf-8?B?SzlGRXJVMEREZGdBTE05ZjgrMXpSRXE0UlBseDMxZmR6VnA0NllMTXR6WlVU?=
 =?utf-8?B?SVN4eFZCY3o0L3JJOFF5VGZVeEtLRm52eEFaLzZTSzFodXArRzJSZmt5NitG?=
 =?utf-8?B?RmVKWm1SY0ZJRDNWMk9DQTlINFUwcGVkb1hrQlk3d2UrQm01WE9TNkZtZGpW?=
 =?utf-8?B?TXpxNGZXNkJGOXBzRkRHa21VNGloaWNNaG5oVzZNT3ArLzBaZnZmc3NlNFdV?=
 =?utf-8?B?NlZzNlU5bkpQT05NZTFwWXRHcm1hTVZ0UE02VElLakl3RkNZVUZTanF5QUgv?=
 =?utf-8?B?aVZFVzV6RGFpaU9rZUwwRU5hd0tBcnp2Ry9HSjZnekhidGtEMEZ2eml1Q2gw?=
 =?utf-8?B?azZrbmZzdEZib0swMmxsdFJUejFUaXhKTGpKaDkxZFNvYy9UV2VzNnlWQzIz?=
 =?utf-8?Q?8y3/PTEXR338PV/mwot1IGZmj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cbab47d-a605-463b-018d-08daf9cf5869
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 03:43:36.2701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m3GSE+aHnCvk9oXd8GOAo5d8N2EE7D01YYYjR0cMObUr7DqIWXDMfbSSDB0u2mof38DJQROARc8IlpCIS2flnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7374
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBNYXR0aGV3IFJvc2F0byA8bWpyb3NhdG9AbGludXguaWJtLmNvbT4NCj4gU2VudDog
V2VkbmVzZGF5LCBKYW51YXJ5IDE4LCAyMDIzIDEwOjU2IFBNDQo+IA0KPiBPbiAxLzE4LzIzIDQ6
MDMgQU0sIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24NCj4g
Pj4gU2VudDogV2VkbmVzZGF5LCBKYW51YXJ5IDE4LCAyMDIzIDU6MjMgQU0NCj4gPj4NCj4gPj4g
T24gRnJpLCAxMyBKYW4gMjAyMyAxOTowMzo1MSAtMDUwMA0KPiA+PiBNYXR0aGV3IFJvc2F0byA8
bWpyb3NhdG9AbGludXguaWJtLmNvbT4gd3JvdGU6DQo+ID4+DQo+ID4+PiAgdm9pZCB2ZmlvX2Rl
dmljZV9ncm91cF9jbG9zZShzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSkNCj4gPj4+ICB7DQo+
ID4+PiArCXZvaWQgKCpwdXRfa3ZtKShzdHJ1Y3Qga3ZtICprdm0pOw0KPiA+Pj4gKwlzdHJ1Y3Qg
a3ZtICprdm07DQo+ID4+PiArDQo+ID4+PiAgCW11dGV4X2xvY2soJmRldmljZS0+Z3JvdXAtPmdy
b3VwX2xvY2spOw0KPiA+Pj4gKwlrdm0gPSBkZXZpY2UtPmt2bTsNCj4gPj4+ICsJcHV0X2t2bSA9
IGRldmljZS0+cHV0X2t2bTsNCj4gPj4+ICAJdmZpb19kZXZpY2VfY2xvc2UoZGV2aWNlLCBkZXZp
Y2UtPmdyb3VwLT5pb21tdWZkKTsNCj4gPj4+ICsJaWYgKGt2bSA9PSBkZXZpY2UtPmt2bSkNCj4g
Pj4+ICsJCWt2bSA9IE5VTEw7DQo+ID4+DQo+ID4+IEhtbSwgc28gd2UncmUgdXNpbmcgd2hldGhl
ciB0aGUgZGV2aWNlLT5rdm0gcG9pbnRlciBnZXRzIGNsZWFyZWQgaW4NCj4gPj4gbGFzdF9jbG9z
ZSB0byBkZXRlY3Qgd2hldGhlciB3ZSBzaG91bGQgcHV0IHRoZSBrdm0gcmVmZXJlbmNlLiAgVGhh
dCdzIGENCj4gPj4gYml0IG9ic2N1cmUuICBPdXIgZ2V0IGFuZCBwdXQgaXMgYWxzbyBhc3ltbWV0
cmljLg0KPiA+Pg0KPiA+PiBEaWQgd2UgZGVjaWRlIHRoYXQgd2UgY291bGRuJ3QgZG8gdGhpcyB2
aWEgYSBzY2hlZHVsZV93b3JrKCkgZnJvbSB0aGUNCj4gPj4gbGFzdF9jbG9zZSBmdW5jdGlvbiwg
aWUuIGltcGxlbWVudGluZyBvdXIgb3duIHZlcnNpb24gb2YgYW4gYXN5bmMgcHV0Pw0KPiA+PiBJ
dCBzZWVtcyBsaWtlIHRoYXQgcG90ZW50aWFsbHkgaGFzIGEgY2xlYW5lciBpbXBsZW1lbnRhdGlv
biwgc3ltbWV0cmljDQo+ID4+IGNhbGwgcG9pbnRzLCBoYW5kbGluZyBhbGwgdGhlIHN0b3Jpbmcg
YW5kIGNsZWFyaW5nIG9mIGt2bSByZWxhdGVkDQo+ID4+IHBvaW50ZXJzIHdpdGhpbiB0aGUgZ2V0
L3B1dCB3cmFwcGVycywgcGFzc2luZyBvbmx5IGEgdmZpb19kZXZpY2UgdG8gdGhlDQo+ID4+IHB1
dCB3cmFwcGVyLCB1c2luZyB0aGUgInZmaW9fZGV2aWNlXyIgcHJlZml4IGZvciBib3RoLiAgUG90
ZW50aWFsbHkNCj4gPj4gd2UnZCBqdXN0IHdhbnQgYW4gdW5jb25kaXRpb25hbCBmbHVzaCBvdXRz
aWRlIG9mIGxvY2sgaGVyZSBmb3INCj4gPj4gZGV0ZXJtaW5pc3RpYyByZWxlYXNlLg0KPiA+Pg0K
PiA+PiBXaGF0J3MgdGhlIGRvd25zaWRlPyAgVGhhbmtzLA0KPiA+Pg0KPiA+DQo+ID4gYnR3IEkg
Z3Vlc3MgdGhpcyBjYW4gYmUgYWxzbyBmaXhlZCBieSBZaSdzIHdvcmsgaGVyZToNCj4gPg0KPiA+
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDIzMDExNzEzNDk0Mi4xMDExMTItNi15aS5s
LmxpdUBpbnRlbC5jb20vDQo+ID4NCj4gPiB3aXRoIHNldF9rdm0oTlVMTCkgbW92ZWQgdG8gdGhl
IHJlbGVhc2UgY2FsbGJhY2sgb2Yga3ZtX3ZmaW8gZGV2aWNlLA0KPiA+IHN1Y2ggY2lyY3VsYXIg
bG9jayBkZXBlbmRlbmN5IGNhbiBiZSBhdm9pZGVkIHRvby4NCj4gDQo+IE9oLCBpbnRlcmVzdGlu
Zy4uLiAgSXQgc2VlbXMgdG8gbWUgdGhhdCB0aGlzIHdvdWxkIGVsaW1pbmF0ZSB0aGUgcmVwb3J0
ZWQgY2FsbA0KPiBjaGFpbiBhbHRvZ2V0aGVyOg0KPiANCj4ga3ZtX3B1dF9rdm0NCj4gIC0+IGt2
bV9kZXN0cm95X3ZtDQo+ICAgLT4ga3ZtX2Rlc3Ryb3lfZGV2aWNlcw0KPiAgICAtPiBrdm1fdmZp
b19kZXN0cm95IChzdGFydGluZyBoZXJlIC0tIHRoaXMgd291bGQgbm8gbG9uZ2VyIGJlIGV4ZWN1
dGVkKQ0KPiAgICAgLT4ga3ZtX3ZmaW9fZmlsZV9zZXRfa3ZtDQo+ICAgICAgLT4gdmZpb19maWxl
X3NldF9rdm0NCj4gICAgICAgLT4gZ3JvdXAtPmdyb3VwX2xvY2svZ3JvdXBfcndzZW0NCj4gDQo+
IGJlY2F1c2Uga3ZtX2Rlc3Ryb3lfZGV2aWNlcyBub3cgY2FuJ3QgZW5kIHVwIGNhbGxpbmcga3Zt
X3ZmaW9fZGVzdHJveQ0KPiBhbmQgZnJpZW5kcywgaXQgd29uJ3QgdHJ5IGFuZCBhY3F1aXJlIHRo
ZSBncm91cCBsb2NrIGEgMm5kIHRpbWUgbWFraW5nIGENCj4ga3ZtX3B1dF9rdm0gd2hpbGUgdGhl
IGdyb3VwIGxvY2sgaXMgaGVsZCBPSyB0byBkby4gIFRoZSB2ZmlvX2ZpbGVfc2V0X2t2bQ0KPiBj
YWxsIHdpbGwgbm93IGFsd2F5cyBjb21lIGZyb20gYSBzZXBhcmF0ZSB0aHJlYWQgb2YgZXhlY3V0
aW9uLA0KPiBrdm1fdmZpb19ncm91cF9hZGQsIGt2bV92ZmlvX2dyb3VwX2RlbCBvciB0aGUgcmVs
ZWFzZSB0aHJlYWQ6DQo+IA0KPiBrdm1fZGV2aWNlX3JlbGVhc2UgKHdoZXJlIHRoZSBncm91cC0+
Z3JvdXBfbG9jayB3b3VsZCBub3QgYmUgaGVsZCBzaW5jZQ0KPiB2ZmlvIGRvZXMgbm90IHRyaWdn
ZXIgY2xvc2luZyBvZiB0aGUga3ZtIGZkKQ0KPiAgLT4ga3ZtX3ZmaW9fZGVzdHJveSAob3IsIGt2
bV92ZmlvX3JlbGVhc2UpDQo+ICAgLT4ga3ZtX3ZmaW9fZmlsZV9zZXRfa3ZtDQo+ICAgIC0+IHZm
aW9fZmlsZV9zZXRfa3ZtDQo+ICAgICAtPiBncm91cC0+Z3JvdXBfbG9jay9ncm91cF9yd3NlbQ0K
DQpZZXMsIHRoYXQncyBteSBwb2ludC4gSWYgQWxleC9KYXNvbiBhcmUgYWxzbyBPSyB3aXRoIGl0
IHByb2JhYmx5IFlpIGNhbg0Kc2VuZCB0aGF0IHBhdGNoIHNlcGFyYXRlbHkgYXMgYSBmaXggdG8g
dGhpcyBpc3N1ZS4gSXQncyBtdWNoIHNpbXBsZXIuIPCfmIoNCg==
