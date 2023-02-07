Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA3668D18B
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 09:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbjBGIjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 03:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjBGIje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 03:39:34 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5E429423;
        Tue,  7 Feb 2023 00:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675759172; x=1707295172;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aABubgQJikNCe5vN9i9trw3kdC0d2q9HR9Egqcw/ODA=;
  b=ZimIZbSfeHhByTdIqCNTDyRlUAwyKRLiz3Iwy16JXlpZ1SQsdj2EjGK3
   A4/bTntZmqCIZW/+oAKXiAXDF/W2JOgKlJkXFgarQlX9blJgqsEqqKbZL
   8NtU+qsgoYjCJUQyyB9deUB2d0Ig7azKaws7MyDrAeiqNnNt5ANcU1/T1
   SkMepgXHSRjHjGHz9p6qgYfEiJEbmLWaN9GHC5FQfuzzV+PHootUIcHYX
   BVc53ZE7fyJIYmQW/XH8yFs0c4XUQmiBTBgF725nL60ntuvsJTAZ5TLoY
   aTA9nZ35qD4zfbbmM7s7iFTfN5v0CVFqldMBkTKrClPF0J0xdf7/uPGyl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="330741261"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="330741261"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 00:39:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="730348282"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="730348282"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 07 Feb 2023 00:39:30 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 00:39:30 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 00:39:30 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 00:39:30 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 00:39:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1hAVDm9u13ZGpbnPpmr8DaLbINGiQAX1IgfaEXsDDlHIBCkEX5zXDkX1F6td2MYuR+64qQZCmJhILqyMVR5dWId+dUFPzkuX+KDwJmvFLjMTxYm8iUrw3UVZDR/7avHCkOX9DxyutZUCAz+DaasRK3K9t9HtAcH1LrEVRolyz/PFlnkxVNYh2a3e+V0C0PEqEqHrtbuzrnzH8wAfUpzpe5HS7EnTn5SJY8K71TWIJxUfSrqC4jk7Tt3MiosWPvqfONuR4A8m8j92pKHlb/b1gFIPtyYrnHY47Pq18HZjfTNsWXnhIfuyKch0PIGim+fQetZrCoFq2jXDuv+s+u+vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aABubgQJikNCe5vN9i9trw3kdC0d2q9HR9Egqcw/ODA=;
 b=CuuhjrEAPKX/f7LAfJ/psTYhwZAP1Gwz83gHZiNsw7G94Lpf9tPfP5bQC+zb5oirvdGPrV5qjrLYRQ3vXyzqX084kANGyAVXcOAAA/DhcJUoMXHEnjq2d8EfdB1qrT0H64kz9WRBq7Gd7TcCBRQm3Yev86B1Hi25gVF04IDt3JzjX6W7IgBV9fp0sYUAIXqdPfttcpWjNnFSDbkjWQR+0o73eK36T8KG311PPq/5497Tej7zEHspNrGWAgM/nKhfcEVL45cVn/iVouvwQGtxs2L5FXlMh0qi/Q8DU+vCx117wPT8gWeL5decvY95jDiSpW8rbJtlvMgZqw1wdPqPPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB8092.namprd11.prod.outlook.com (2603:10b6:8:184::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 08:39:28 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 08:39:27 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v2 05/14] kvm/vfio: Accept vfio device file from userspace
Thread-Topic: [PATCH v2 05/14] kvm/vfio: Accept vfio device file from
 userspace
Thread-Index: AQHZOgo25GLoA6ebv0uxW3UPksEhia7C1rcAgABQelA=
Date:   Tue, 7 Feb 2023 08:39:27 +0000
Message-ID: <DS0PR11MB75291AF21AD96162E8099E84C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230206090532.95598-1-yi.l.liu@intel.com>
 <20230206090532.95598-6-yi.l.liu@intel.com>
 <BN9PR11MB5276CC3B1773CF183E147D6B8CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276CC3B1773CF183E147D6B8CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB8092:EE_
x-ms-office365-filtering-correlation-id: bac23f7e-5d78-4b80-9094-08db08e6d2e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T0O1A8MF5QCKGLSiBIUmHFHgq72oXm/q7J1g9Qv5/TEAKSjYJ0pWxMH1vmmrKuc9INPoVe7pLPMoaUO+PMWk40AjxPJAZ1lGwIxgEGnq7AEWq5s3gbwwhzU35kL25OBD4U65h7zXFDWj4G6aS68C8ime2du99IeLhEFQEm3DQDyoECWlo7kBH+3iviL6x5rpIYJtbK7SsXEuw+GKLFzuHiaKEIGYI0wEIEFC+qXWRLzFJNDaHJ+o+Xslkfp40iZvssTYewBxWfHJWa1XZUUt7MMxrLei3x20tkFUZpF9JfUtcb/3MV2MJHXiA02eXtHAFIGUZ6JK7fp3rW4mkiw1Pv9ie8df/+fv8BIOXzkewB5tro4kMZtdmbYufdtMGn5zplawXHpe2nJy7AW/Ceq2FSxbyoEHPeK3POP3JUkD5S0J61BtR+DZilkrF0tpvkVmYEHCjH2r+RYZd7vF+Yb8BemN607hR2JdIKeXket7kZFfRyRfvR5wHgaHIjgdGMYylVNqFfhMKbEdg1yGub9CGRifbBNRN4IZ7to0NkH9y6LAlA4w1wInKvR3gvh47kiLOHYc7fSp0W3wqvsuweCdX9N6v2yAi6WAlOQS8TUTymH2d1p4G5f82/OSB64LvQ1YEBDBgGYCCd49cWLt12Or35hOAZVNHjxOBtCBExTJ6x1AiO8x2X3AoSDZRucOfdcGblbiKburHsMt1ZOHSeXhDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(39860400002)(346002)(366004)(451199018)(2906002)(122000001)(38100700002)(38070700005)(83380400001)(5660300002)(66476007)(110136005)(66556008)(8676002)(316002)(54906003)(66946007)(66446008)(4326008)(76116006)(33656002)(8936002)(64756008)(52536014)(7416002)(55016003)(86362001)(41300700001)(6506007)(9686003)(26005)(7696005)(71200400001)(82960400001)(186003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGJXdnRKeHovZGV0aEZMY05zUW9laWdTZFJLNVdWTVdJT2RNZWMvM1pMTm15?=
 =?utf-8?B?b1VVL25ldXo0bnRoVmRwSU1HWGZydWMvdFlRTTVvNVFoNmFEU3EzQmIwUHA5?=
 =?utf-8?B?dlRnaUI4SC82YjJTVGlmSFJ6dk1GWWd1NWV3eDVxZG83Mm1xWjFFOExoRkgz?=
 =?utf-8?B?YlRPWUZsbEtabVdKU3p3cEYxTHp3RDJOekgyWVdTYTJzN1pzZ2ViMWlPQTd2?=
 =?utf-8?B?OU53eFBpWDZDeUNOeEUyaytCbHNHY2loaWpUMTlXMVhHMFN0Z3NKeUJUY2pH?=
 =?utf-8?B?ZUkvcHVHSzJEelpkYzJKVWpYOXZPTjdQMThnUW5VTHI4N1JLNzg3bnJsLzFh?=
 =?utf-8?B?eXN0S0IvU3pSczdxMTlYREQzTVhRK2x6RDJRV1JiUlpFbjFhaHpnSHlyL3hH?=
 =?utf-8?B?N3lsYUZSV0RNbTlLNVFuNGExcS9udnRMMWNVaGVpeGZ4bUZ6dGJXQ0krNkgy?=
 =?utf-8?B?NWhROGd1U3NrODMzMmJUUVRERGtUZUE2THZja3FUejhieUtmUVRWcUN4Vk1T?=
 =?utf-8?B?OGhJU0MzMm5VcE8vM2gwQ0pEb1FQQnY0d1p1VHZvLzFRSitYN1NIN3h6V2tD?=
 =?utf-8?B?Nkk4L2MxNk9aWVIrdUsvVVkzS0QrUlF5MzVlamhCZlZkV3BoREZrb0dWNk8x?=
 =?utf-8?B?S0ZCR2ZUNDdzTnFGMHlkb1NKYklrUDdyRi9WSXk1SWYrd1hianhVRXpPVjJS?=
 =?utf-8?B?eW5uS20vLzhKVlhQQkVqSlhXUUUydmdaaWREeklPTENLUWUyMlB3WGt0ZmFR?=
 =?utf-8?B?SDZvL1JCVG43b014alIvdEg2TWhCNEw4cEQ2cTczWHFBSEdTcUpqTnFud1NL?=
 =?utf-8?B?QzlreWdEVUYxeXcxbnNJYUp1cU1BNWovMURKVkRyTG93M29IZ01KeHlhc1VB?=
 =?utf-8?B?eG56ZHY4bi9UZG9QZ2xJOGVPVGxmR1lpVDJBWjRVZWFwQ29LUHdxeXByS3hk?=
 =?utf-8?B?M2pISTc2eFBnK2JEWE4xMzFQQVlSRlEzUU5scjhTVnB3MlpoWnM3MjZjVU1S?=
 =?utf-8?B?YXY5aXhEaHhHMjlsTUhMRWNDbjBZK1pxS3lNM1dFVzk1T2VqNkpPc2FoZ0Yv?=
 =?utf-8?B?UmpOOEU1dXF5bGl5K1Y3YmdRY1BFY0lmZ1gxeEg3dkg3ZDZTc3JRaHJwQ2hG?=
 =?utf-8?B?d1FhbEZPNFdpeDA1a2xEV2MzRGJMZktRaVNHQlFOQWJaMjY5Mk1tcGtkSDU0?=
 =?utf-8?B?YkV6UFg3SDAwY2RCNGJueCtmUm56c0lyYTBBMUk5Ry9Pekk0U1oyS3czVkZQ?=
 =?utf-8?B?MzN0NjhZelkxdnd5QjhpTlZjaTFudnM5MXFubklnd3luV2pSR0xWWGRMNDZ3?=
 =?utf-8?B?dFMzamhhOXBIOWZ0ejNFWU1iOHlwcE9IbFlTa2c1YUxkUS9HQzgxR0pRc3Ir?=
 =?utf-8?B?UENNM010MmcrV1pYbUZ3Yjd0eFFKVmRJU1pva1pIMjc1N1NoTXkvOGFmMHov?=
 =?utf-8?B?bGpEUHZwMUtqQnFBTXFRT2V2VXNMWHhhUm1ZeEVHK2tlQkZwbE1qTkVtSEo2?=
 =?utf-8?B?WEluRkJ2WU0yWjBOemZsVXdlbk9hT3l5OTc4eE91N2hQQW9lc2lDTWs3eGpk?=
 =?utf-8?B?M3kxZjM4SkRRdG1uVWdqNllXRmNBN1AwaFZDS1ozZlVYbUF6bkdDZTU4Yzlt?=
 =?utf-8?B?N2RiY2Y3cHdrWEZFbDBUbjFYTjdNeUV0WGVjUXJPUEQyR1pNTTlBNUpLTXpJ?=
 =?utf-8?B?NkRYTEVMQkg2VVN4VlMxc3RZK1VpVnhYd0VuT0RtRUprSHdLRDcxTi9UNmNU?=
 =?utf-8?B?N0x0eGF4dDJqVmVpaXZ0RG9ScTRQcHR3UFl3SVVOSmlIK2owUVRRQ0x1bVV6?=
 =?utf-8?B?Y3l0c3EvQmNMWVZreXBYbjRJcHQzQ3VBenBOWUJmUXJ0NElYTzRJd0tSUWg2?=
 =?utf-8?B?alBTaTJIdjZCZkt6ZG1nUnJCV2RBL0RlazQyVXd2MWNnRDhDUVBBR0hjS3dK?=
 =?utf-8?B?SzhaZ1REdTdJazlpblZFNlZYQlZtRmlJWlgvSlBYcFh5Q00wU2gzSENOTWRR?=
 =?utf-8?B?VmxWemMzSUpoODJ3c01YY052UnZGWldzQXcwMk5ndVVEeVJhNzVPdUZMR1Ri?=
 =?utf-8?B?R1dKbHBId1pnMFNJcWcza29GaUtWV0s5SGliNXVFTS9SUTVCa2tSeEllZUpS?=
 =?utf-8?Q?ifIwAnz9edfjoBd/4dUuF0OBl?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bac23f7e-5d78-4b80-9094-08db08e6d2e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 08:39:27.6308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4k+wsG0pwvMyO/qgOvZ7l0Xr9ONPrSeMP61ebpFejaa3/bmZCSey8CPb1o1mxQe3a0R/xQOfYQbnZziQQ39ttg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8092
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IFR1ZXNk
YXksIEZlYnJ1YXJ5IDcsIDIwMjMgMTE6MzcgQU0NCj4NCj4gPiBGcm9tOiBMaXUsIFlpIEwgPHlp
LmwubGl1QGludGVsLmNvbT4NCj4gPiBTZW50OiBNb25kYXksIEZlYnJ1YXJ5IDYsIDIwMjMgNTow
NSBQTQ0KPiA+DQo+ID4gVGhpcyBkZWZpbmVzIEtWTV9ERVZfVkZJT19GSUxFKiBhbmQgbWFrZSBh
bGlhcyB3aXRoDQo+ID4gS1ZNX0RFVl9WRklPX0dST1VQKi4NCj4gPiBPbGQgdXNlcnNwYWNlIHVz
ZXMgS1ZNX0RFVl9WRklPX0dST1VQKiB3b3JrcyBhcyB3ZWxsLg0KPiA+DQo+ID4gU2lnbmVkLW9m
Zi1ieTogWWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIERvY3VtZW50
YXRpb24vdmlydC9rdm0vZGV2aWNlcy92ZmlvLnJzdCB8IDQwICsrKysrKysrKysrKysrLS0tLS0t
LS0tLQ0KPiAtDQo+ID4gIGluY2x1ZGUvdWFwaS9saW51eC9rdm0uaCAgICAgICAgICAgICAgICB8
IDE2ICsrKysrKystLS0NCj4gPiAgdmlydC9rdm0vdmZpby5jICAgICAgICAgICAgICAgICAgICAg
ICAgIHwgMTYgKysrKystLS0tLQ0KPiA+ICAzIGZpbGVzIGNoYW5nZWQsIDQyIGluc2VydGlvbnMo
KyksIDMwIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24v
dmlydC9rdm0vZGV2aWNlcy92ZmlvLnJzdA0KPiA+IGIvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9k
ZXZpY2VzL3ZmaW8ucnN0DQo+ID4gaW5kZXggMmQyMGRjNTYxMDY5Li43Zjg0ZWMyNmNhNGEgMTAw
NjQ0DQo+ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9kZXZpY2VzL3ZmaW8ucnN0DQo+
ID4gKysrIGIvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9kZXZpY2VzL3ZmaW8ucnN0DQo+ID4gQEAg
LTksMjMgKzksMjYgQEAgRGV2aWNlIHR5cGVzIHN1cHBvcnRlZDoNCj4gPiAgICAtIEtWTV9ERVZf
VFlQRV9WRklPDQo+ID4NCj4gPiAgT25seSBvbmUgVkZJTyBpbnN0YW5jZSBtYXkgYmUgY3JlYXRl
ZCBwZXIgVk0uICBUaGUgY3JlYXRlZCBkZXZpY2UNCj4gPiAtdHJhY2tzIFZGSU8gZ3JvdXBzIGlu
IHVzZSBieSB0aGUgVk0gYW5kIGZlYXR1cmVzIG9mIHRob3NlIGdyb3Vwcw0KPiA+IC1pbXBvcnRh
bnQgdG8gdGhlIGNvcnJlY3RuZXNzIGFuZCBhY2NlbGVyYXRpb24gb2YgdGhlIFZNLiAgQXMgZ3Jv
dXBzDQo+ID4gLWFyZSBlbmFibGVkIGFuZCBkaXNhYmxlZCBmb3IgdXNlIGJ5IHRoZSBWTSwgS1ZN
IHNob3VsZCBiZSB1cGRhdGVkDQo+ID4gLWFib3V0IHRoZWlyIHByZXNlbmNlLiAgV2hlbiByZWdp
c3RlcmVkIHdpdGggS1ZNLCBhIHJlZmVyZW5jZSB0byB0aGUNCj4gPiAtVkZJTy1ncm91cCBpcyBo
ZWxkIGJ5IEtWTS4NCj4gPiArdHJhY2tzIFZGSU8gZmlsZXMgKGdyb3VwIG9yIGRldmljZSkgaW4g
dXNlIGJ5IHRoZSBWTSBhbmQgZmVhdHVyZXMNCj4gPiArb2YgdGhvc2UgZ3JvdXBzL2RldmljZXMg
aW1wb3J0YW50IHRvIHRoZSBjb3JyZWN0bmVzcyBhbmQgYWNjZWxlcmF0aW9uDQo+ID4gK29mIHRo
ZSBWTS4gQXMgZ3JvdXBzL2RldmljZXMgYXJlIGVuYWJsZWQgYW5kIGRpc2FibGVkIGZvciB1c2Ug
YnkgdGhlDQo+ID4gK1ZNLCBLVk0gc2hvdWxkIGJlIHVwZGF0ZWQgYWJvdXQgdGhlaXIgcHJlc2Vu
Y2UuICBXaGVuIHJlZ2lzdGVyZWQNCj4gd2l0aA0KPiA+ICtLVk0sIGEgcmVmZXJlbmNlIHRvIHRo
ZSBWRklPIGZpbGUgaXMgaGVsZCBieSBLVk0uDQo+ID4NCj4gPiAgR3JvdXBzOg0KPiANCj4gIkZp
bGVzIg0KDQpJdCBzaG91bGQgYmUgIkdyb3VwcyIg8J+YiiBIZXJlICJHcm91cHMiIG1lYW5zIHN1
YmNtZCBncm91cHMuDQoNCj4gDQo+ID4gLSAgS1ZNX0RFVl9WRklPX0dST1VQDQo+ID4gLQ0KPiA+
IC1LVk1fREVWX1ZGSU9fR1JPVVAgYXR0cmlidXRlczoNCj4gPiAtICBLVk1fREVWX1ZGSU9fR1JP
VVBfQUREOiBBZGQgYSBWRklPIGdyb3VwIHRvIFZGSU8tS1ZNIGRldmljZQ0KPiA+IHRyYWNraW5n
DQo+ID4gLQlrdm1fZGV2aWNlX2F0dHIuYWRkciBwb2ludHMgdG8gYW4gaW50MzJfdCBmaWxlIGRl
c2NyaXB0b3INCj4gPiAtCWZvciB0aGUgVkZJTyBncm91cC4NCj4gPiAtICBLVk1fREVWX1ZGSU9f
R1JPVVBfREVMOiBSZW1vdmUgYSBWRklPIGdyb3VwIGZyb20gVkZJTy1LVk0NCj4gPiBkZXZpY2Ug
dHJhY2tpbmcNCj4gPiAtCWt2bV9kZXZpY2VfYXR0ci5hZGRyIHBvaW50cyB0byBhbiBpbnQzMl90
IGZpbGUgZGVzY3JpcHRvcg0KPiA+IC0JZm9yIHRoZSBWRklPIGdyb3VwLg0KPiA+IC0gIEtWTV9E
RVZfVkZJT19HUk9VUF9TRVRfU1BBUFJfVENFOiBhdHRhY2hlcyBhIGd1ZXN0IHZpc2libGUgVENF
DQo+ID4gdGFibGUNCj4gPiArICBLVk1fREVWX1ZGSU9fRklMRQ0KPiA+ICsgIC0gYWxpYXM6IEtW
TV9ERVZfVkZJT19HUk9VUA0KPiA+ICsNCj4gPiArS1ZNX0RFVl9WRklPX0ZJTEUgYXR0cmlidXRl
czoNCj4gPiArICBLVk1fREVWX1ZGSU9fRklMRV9BREQ6IEFkZCBhIFZGSU8gZmlsZSAoZ3JvdXAv
ZGV2aWNlKSB0byBWRklPLUtWTQ0KPiA+IGRldmljZQ0KPiA+ICsJdHJhY2tpbmcga3ZtX2Rldmlj
ZV9hdHRyLmFkZHIgcG9pbnRzIHRvIGFuIGludDMyX3QgZmlsZSBkZXNjcmlwdG9yDQo+IA0KPiAi
Li4uIGRldmljZSB0cmFja2luZyIgYW5kICJrdm1fZGV2aWNlLmF0dHIuYWRkciBwb2ludHMgdG8u
Li4iIGFyZSB0d28NCj4gc2VudGVuY2VzLiBUaGV5IGFyZSBkZWxpYmVyYXRlbHkgYXJyYW5nZWQg
dG8gYmUgaW4gZGlmZmVyZW50IGxpbmVzLg0KDQpPaCwgeWVzLg0KDQo+ID4gKwlmb3IgdGhlIFZG
SU8gZmlsZS4NCj4gPiArCS0gYWxpYXM6IEtWTV9ERVZfVkZJT19HUk9VUF9BREQNCj4gPiArICBL
Vk1fREVWX1ZGSU9fRklMRV9ERUw6IFJlbW92ZSBhIFZGSU8gZmlsZSAoZ3JvdXAvZGV2aWNlKSBm
cm9tDQo+IFZGSU8tDQo+ID4gS1ZNDQo+ID4gKwlkZXZpY2UgdHJhY2tpbmcga3ZtX2RldmljZV9h
dHRyLmFkZHIgcG9pbnRzIHRvIGFuIGludDMyX3QgZmlsZQ0KPiA+ICsJZGVzY3JpcHRvciBmb3Ig
dGhlIFZGSU8gZmlsZS4NCj4gDQo+IGRpdHRvDQoNCldpbGwgY29udmVydC4NCg0KPiANCj4gPiAr
CS0gYWxpYXM6IEtWTV9ERVZfVkZJT19HUk9VUF9ERUwNCj4gPiArICBLVk1fREVWX1ZGSU9fRklM
RV9TRVRfU1BBUFJfVENFOiBhdHRhY2hlcyBhIGd1ZXN0IHZpc2libGUgVENFDQo+IHRhYmxlDQo+
ID4gIAlhbGxvY2F0ZWQgYnkgc1BBUFIgS1ZNLg0KPiANCj4gc29tZWhvdyBoZXJlIGl0IHNob3Vs
ZCBlbXBoYXNpemUgdGhhdCB0aGUgZmlsZSBjYW4gb25seSBiZSBncm91cA0KDQpZZXMuDQoNCj4g
PiAgCWt2bV9kZXZpY2VfYXR0ci5hZGRyIHBvaW50cyB0byBhIHN0cnVjdDo6DQo+ID4NCj4gPiBA
QCAtMzYsNiArMzksNyBAQCBLVk1fREVWX1ZGSU9fR1JPVVAgYXR0cmlidXRlczoNCj4gPg0KPiA+
ICAJd2hlcmU6DQo+ID4NCj4gPiAtCS0gQGdyb3VwZmQgaXMgYSBmaWxlIGRlc2NyaXB0b3IgZm9y
IGEgVkZJTyBncm91cDsNCj4gPiAtCS0gQHRhYmxlZmQgaXMgYSBmaWxlIGRlc2NyaXB0b3IgZm9y
IGEgVENFIHRhYmxlIGFsbG9jYXRlZCB2aWENCj4gPiAtCSAgS1ZNX0NSRUFURV9TUEFQUl9UQ0Uu
DQo+ID4gKwkqKSBAZ3JvdXBmZCBpcyBhIGZpbGUgZGVzY3JpcHRvciBmb3IgYSBWRklPIGdyb3Vw
Ow0KPiA+ICsJKikgQHRhYmxlZmQgaXMgYSBmaWxlIGRlc2NyaXB0b3IgZm9yIGEgVENFIHRhYmxl
IGFsbG9jYXRlZCB2aWENCj4gDQo+IHdoeSBjaGFuZ2luZyBhYm92ZSB0d28gbGluZXM/DQoNCnRo
aXMgaXMgZHVlIHRvIGNoYW5naW5nICItIiB0byBiZSAiKikiIGFzIHN1YmJ1bGxldCBhcyBiZWxv
dyBuZWVkDQp0byBhZGQgYWxpYXMuDQoNCj4gPiArCSAgIEtWTV9DUkVBVEVfU1BBUFJfVENFLg0K
PiA+ICsJLSBhbGlhczogS1ZNX0RFVl9WRklPX0ZJTEVfU0VUX1NQQVBSX1RDRQ0KPiANCj4gR1JP
VVANCg0KWWVzLg0KDQpSZWdhcmRzLA0KWWkgTGl1DQo=
