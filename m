Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A377698AA8
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 03:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBPCxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 21:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBPCxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 21:53:35 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB1046093;
        Wed, 15 Feb 2023 18:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676516013; x=1708052013;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qMSukxTPFCXApQsSqd3ywd2v1UIT22aFvDYlkVtwPB4=;
  b=drDEeYmeGwTsLLkzjgS4OhxrTfoF9ox50oum4OVKL/lEFMZygcZWY65o
   bCB5+uurM4MQRCZAZ7cUyn3WFteFW3UiVjchHwfMBnrfEEieNDBxrPIoH
   xuE6ktrlQgpr5uxTRpgDA17pTyYVMJsQNPfkhSdKCSw5RVXgCipBdd6pR
   YT6YPzJJQ+3pzTmsNqV9jrxOI6HwU2c/peC69ETbcit+0W2g5js19rUKs
   oahOSTlB1drMkwz7PaWkkJcmECLNhEz1LrY8xWRaqRCW985X22d/b31FU
   zOZPfdxsxGS1E9FDu1p3SNUGwq+5SrSeOfATWBqi4wxurwXKGo0uCjbGD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="330249882"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="330249882"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 18:53:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="619846528"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="619846528"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 15 Feb 2023 18:53:32 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 18:53:31 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 18:53:31 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 18:53:31 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 18:53:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6YXgmjMsnyhtEYHn8XQHWzdOO+Z6KFfzwdsrCShPqUfqn24hYO7C+pKOYUt4vEnnPj8R/S2EWiB0l/GZKyWRCOp80LdQ1cykAPyGuWfSzhCAFHCPNgUdQLN9qQgwrkbUyRM/LRVTuaPszbZYtHZ6Gn9N/rTnny+IHU9t4W4hGYaxEkWeiDaMnH5JEZ5kuuXbX46mUOShsQl0oenTo8JysMgxfG9WazEJunzlrDRtA3a+RbH5XNNAxmwQDNeLaODvZ7JinSvNqSfyWn0pTOxvz5bUGpIrUBxFhpALreIVw38G0P7QXbkKPYMBfKtaq+a0IoyMmCg///jxf6XP1kbpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qMSukxTPFCXApQsSqd3ywd2v1UIT22aFvDYlkVtwPB4=;
 b=Bo0ML4BpoZFE3eUo2K+uSKl0v4PDUBN1CRADG6CVQF7Kog8SCZ+CuWWhDXYwynpLOkPKZjMb4z8Y3af8sGhiI9eisXuY4rSZ+MbuTWWYyokTvgUJJ2D4L30F9gKXMnuAv0CrXxYoyIr4ScWfsc96MlfreBdUn7pHxZiJwm2pGfAwvpOBTsxKGzR934lr7Mldthpaix59ZzawNNmN72tWXoqiwPafw5yR013sntLhs5Xt09aqJ9JA9eO5aIoPLhG55sFqRL7hlApyNmsjc8ZddNezbHlZl0ZwOxtQMlrMmtmAQFarzrtyM1+M3KqxLogxulbE9IeaHHIObgXyMULWLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BY1PR11MB8007.namprd11.prod.outlook.com (2603:10b6:a03:525::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 16 Feb
 2023 02:53:28 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 02:53:28 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v3 00/15] Add vfio_device cdev for iommufd support
Thread-Topic: [PATCH v3 00/15] Add vfio_device cdev for iommufd support
Thread-Index: AQHZP73MTR3br74MlEe91B7qYhP/Qq7NSHqAgABiBDCAAO1EAIABCYRQgADR+ICAAHC8MA==
Date:   Thu, 16 Feb 2023 02:53:28 +0000
Message-ID: <DS0PR11MB752965F6710C83043A7C6B14C3A09@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
        <20230213124719.126eb828.alex.williamson@redhat.com>
        <DS0PR11MB75298788BCA03FD9513F991AC3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230214084720.74b3574e.alex.williamson@redhat.com>
        <DS0PR11MB7529CFCE99E8A77AAC76DC7CC3A39@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230215130909.5d98e878.alex.williamson@redhat.com>
In-Reply-To: <20230215130909.5d98e878.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BY1PR11MB8007:EE_
x-ms-office365-filtering-correlation-id: ad4a0ca3-e116-4a2c-bab5-08db0fc8fb18
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qn2NRpZSYixfxytKETY72QtoaG1v20A9vYJDWyIN7lubuoyRERZgnpVNklaq+NBNyzvLBwgoFC2GFaDQkKHk4kmGObIc0yVaGugw6TAsRn50pqz89QIkTKYSymdhe4VXhFg1cobrnXj/hTay79OKW5KxRfNI+BS6J2tLqUMCmiOAjeIkiL5lERC3etcUOwaZEKOF+7Ygyn0DunAUMtXos0kSf0o0LAXSQgUiLjl2rQ7NG8ZJE9BlcSh57HVNfugZfrJLVGO2sq1xTaYHTHE8KEkaRCtA8QIVo93U8Pl+gnECkUW47pSdjudwtB88SrpnE+r6sChH8BOflE7WVatTvdpfm0TnfNUTwK8/SgW15+NyeCgCpm1GTp1tUNsT/uslBhkp1c1SUmPyozADcvgpqF/ge82+7zPZqChspe/dIhkePoFAk9onxWOLrVkqrBywed4+slzDg/4EvNHmy4/sDBBXP/H/1ytDJXkV/Uu1zNcvjfjHEwf3JJt8LkmqrXm82uAHc2h9djIAH+50nBHaRq5FMUk4FeQjuYDFdE7XzIKXJdI3V7hCD8Zci6StEjzq7EdKvRkTWT0f0lNuEsVYoJbJbYTatVS1hKuJ/TZcNbyTS/R9NxNKulSN+RAGLHEIE5GRPDmKb7sYfhGeT5v2BTeiTMBXUVFXWHFsk0UxENcY0J3zICkJuJC7MpJ0S4tj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199018)(7696005)(122000001)(86362001)(2906002)(71200400001)(38100700002)(5660300002)(316002)(33656002)(4326008)(83380400001)(54906003)(66446008)(64756008)(8676002)(66556008)(55016003)(76116006)(66946007)(41300700001)(66476007)(7416002)(6916009)(8936002)(52536014)(9686003)(6506007)(38070700005)(966005)(478600001)(26005)(186003)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ay9PNG91dVB6bnlXV1JWbzFBN3ZYK2pkS3E5RFBhQzNFR3F4MlNjbjAxa0xv?=
 =?utf-8?B?d3pRdm1jTk9YdjVscjdNeTVDc0JRaFd0YUR1MkZaek12aGZpaTZzd0lKWnow?=
 =?utf-8?B?M09vV1ZxN09mUGZzVXA3WmNrRkkrN0luanoweHZPTmlOMm1tVkRKbERwVS9E?=
 =?utf-8?B?cUsvTHJFc2lUV0JZdkdLNkpML1FjckZhQzVZQjZkWWFFVFFmdzZUbkpMMmR0?=
 =?utf-8?B?bGtac0FuUUwzR3ZvYU81Z0k1NkM1OWJLTHBvd0hzN1NtME9Qdmg0UERIclVG?=
 =?utf-8?B?UTIweUsxZTRxVkhkVDVXUG9COG9oQ0I5VXQ3NGlnQ09yZVgwSEgwNU4vaU05?=
 =?utf-8?B?S1Z0SFJiUHFmV1NRL2ZtcHZwZlZQSGhRTE1pVTl0MnFJZENwQWRxeUNxeVQr?=
 =?utf-8?B?TzY5RU5ONkFXUmwwQU42eWdwN2JVQkEvME9HMUJ1czdOTVpRc3hrejk1VkNk?=
 =?utf-8?B?WGJrSmNKaS9CRkIySkFqR0ZhWVdYWlEvNTBxWHFiNWdFNUdNOWdsR2IxeVMw?=
 =?utf-8?B?NXBFbWx1SlAvbFRqNm0rOFJadzN1U2lUREc4cFpmZzlObUpVSFBUWDlHREov?=
 =?utf-8?B?S2pJU09QQm9CQ2JzQWZZLzRHRTFkbXp4eUJQaVRlTU56cHM1QUpoYVlWWUx2?=
 =?utf-8?B?NHFCN2FVVWhRZHJhelplYUJJbTlWL1diMHhOd2Z5eG9mb2VZTjV1WFFxQ2Qw?=
 =?utf-8?B?OHQwMmJZTXVJanFOb3paRityUW04ZEZNaG01SElSeVBmS1BEVFBpQlZnZTN1?=
 =?utf-8?B?SlFoUWF3a0FPK0NUeDdCM0NMZXE4UGxNaitpVnMya3pML1RoaGFnSnEzQXp0?=
 =?utf-8?B?MTBxY1kwMGpPcXRZVHBKZEYyVDExZVkzUDUwUGR6MGlURnh5Y3JFRnpLa0Fw?=
 =?utf-8?B?SkNXQzlZVkQ2RWpRU0cvQnZFcDhzbUVKZVFqNEZrOTJUdXB2SXRaNkRsSmFZ?=
 =?utf-8?B?NTlBTmQ2Q3JWVFd5d1FadTAxbkQ1bmYxOEpQV1NBa1J4QjhzbzdhUDNzblE1?=
 =?utf-8?B?OEwwYlArbElBRXhsc2FoUURNSUVQdjNKeE5ZUXFKVWlmTlF2eElNM2NwdVRq?=
 =?utf-8?B?cUJvUXJJcVVyQUxycENZdVhYazdjUlpDWWlhMTRLSlFpSXRPZnBDZGluOHM3?=
 =?utf-8?B?Zm90QjYyMWZWL3BqYTRIVDBGTUNYL0w0a0UwUXROcHNZZGNmaTExN25QSjhO?=
 =?utf-8?B?RGxlQ1FqSmllSFBtSmgwSVYwZ1FRT1dGNXV3eldBanNkNTVCRk11SzhwcHha?=
 =?utf-8?B?am9lTm42a1Q4djlDZXBEMm0xa3RYVjhzVmRGMHg3Wmcya1JMYlowQkpkMGdl?=
 =?utf-8?B?alpWNE1YZXJSNU1BcVFzMm0wcjNtb2FFN2lDVmJncnUxS2w1VUxrc1J0UVRC?=
 =?utf-8?B?UnB4T2dLam8xVzdCMGtGQVo1dXFXRnFSVHRaN3hwSmM5NDc4WnBNWnc3TkUz?=
 =?utf-8?B?OFdpZ0tFZmFRSWZIbEpCSS9GWkovOW1IRVllTU0zMTJYeVIyUHZ3RDZacisx?=
 =?utf-8?B?dnlQTnZGY29hSFZEaEJkeTkrQzQ2SWhqSkdrYVB1eWRBaWJMbVNsaHBXSHBu?=
 =?utf-8?B?QTFmZFFHVUp0Nmx3QXY0cFZGUjkxVElEUDVXVGlpZWNNWHBVTXdvM2hmUEpV?=
 =?utf-8?B?Mm80WTlaVDd1SlIxbkhJNUtmN0loamN2Q3VYc2ZoS3JFanlKTEx1ZzVjV1pa?=
 =?utf-8?B?TEV2Tzg5Ym5xNEg1SitJTlpacDZQbU1Ec3dVZjRtemcwK09Gbk0rZEd3OW1X?=
 =?utf-8?B?dnI4NWF5eG1Ha3FVTnpSYURkdml4YVdLaEFYNzZ3R1NQZ29Ia0NpdDdlU0ZQ?=
 =?utf-8?B?RXd1UVpKYThqcEMzS2VrYmhVaHAxeDVsMGJWT21LaGxMQmFEWjhTRHl1ZWVv?=
 =?utf-8?B?RHp4YWlxZkhpQ2RkYTZHM0NZcmt4RFozRXJUQTN0cUdIMTAwdkg0Ym1BWGp3?=
 =?utf-8?B?RFFYN0ExNGxVazJ4bUxTUDFOa0JvWmtxelZ2MUN1cTBXNjhRK3gwV2tPRHNS?=
 =?utf-8?B?K2RsdXUvaURUcFI5UnBWRDZuRkk5Uzh3dmd3VHRSNHlwS2dnUy9GN29YSVYr?=
 =?utf-8?B?dFFyKzIvUG1WRUR2WmNlVGs3TjhKb2FJbG5lNVBqTFI5WHhaZ0tZcW1JM1Nt?=
 =?utf-8?Q?ucqcreciwVQoJGQ3U7ptChkUM?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad4a0ca3-e116-4a2c-bab5-08db0fc8fb18
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 02:53:28.3478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gfR8iccyfjs2aEC3+6zzHvLEScUAqEvbAJ31biWP5FvruE35C/DiKq9iJAcep3si7/S8QBWfG6kcjDSTwlPOKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8007
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUaHVyc2RheSwgRmVicnVhcnkgMTYsIDIwMjMgNDowOSBBTQ0KPiANCj4gT24gV2VkLCAx
NSBGZWIgMjAyMyAwNzo1NDozMSArMDAwMA0KPiAiTGl1LCBZaSBMIiA8eWkubC5saXVAaW50ZWwu
Y29tPiB3cm90ZToNCj4gDQo+ID4gPiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlh
bXNvbkByZWRoYXQuY29tPg0KPiA+ID4gU2VudDogVHVlc2RheSwgRmVicnVhcnkgMTQsIDIwMjMg
MTE6NDcgUE0NCj4gPiA+DQo+ID4gPiBPbiBUdWUsIDE0IEZlYiAyMDIzIDAxOjU1OjE3ICswMDAw
DQo+ID4gPiAiTGl1LCBZaSBMIiA8eWkubC5saXVAaW50ZWwuY29tPiB3cm90ZToNCj4gPiA+DQo+
ID4gPiA+ID4gRnJvbTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNv
bT4NCj4gPiA+ID4gPiBTZW50OiBUdWVzZGF5LCBGZWJydWFyeSAxNCwgMjAyMyAzOjQ3IEFNDQo+
ID4gPiA+ID4NCj4gPiA+ID4gPiBPbiBNb24sIDEzIEZlYiAyMDIzIDA3OjEzOjMzIC0wODAwDQo+
ID4gPiA+ID4gWWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+ID4gPiA+DQo+
ID4gPiA+ID4gPiBFeGlzdGluZyBWRklPIHByb3ZpZGVzIGdyb3VwLWNlbnRyaWMgdXNlciBBUElz
IGZvciB1c2Vyc3BhY2UuDQo+ID4gPiBVc2Vyc3BhY2UNCj4gPiA+ID4gPiA+IG9wZW5zIHRoZSAv
ZGV2L3ZmaW8vJGdyb3VwX2lkIGZpcnN0IGJlZm9yZSBnZXR0aW5nIGRldmljZSBmZCBhbmQNCj4g
PiA+IGhlbmNlDQo+ID4gPiA+ID4gPiBnZXR0aW5nIGFjY2VzcyB0byBkZXZpY2UuIFRoaXMgaXMg
bm90IHRoZSBkZXNpcmVkIG1vZGVsIGZvciBpb21tdWZkLg0KPiA+ID4gUGVyDQo+ID4gPiA+ID4g
PiB0aGUgY29uY2x1c2lvbiBvZiBjb21tdW5pdHkgZGlzY3Vzc2lvblsxXSwgaW9tbXVmZCBwcm92
aWRlcw0KPiBkZXZpY2UtDQo+ID4gPiA+ID4gY2VudHJpYw0KPiA+ID4gPiA+ID4ga0FQSXMgYW5k
IHJlcXVpcmVzIGl0cyBjb25zdW1lciAobGlrZSBWRklPKSB0byBiZSBkZXZpY2UtY2VudHJpYw0K
PiB1c2VyDQo+ID4gPiA+ID4gPiBBUElzLiBTdWNoIHVzZXIgQVBJcyBhcmUgdXNlZCB0byBhc3Nv
Y2lhdGUgZGV2aWNlIHdpdGggaW9tbXVmZA0KPiBhbmQNCj4gPiA+IGFsc28NCj4gPiA+ID4gPiA+
IHRoZSBJL08gYWRkcmVzcyBzcGFjZXMgbWFuYWdlZCBieSB0aGUgaW9tbXVmZC4NCj4gPiA+ID4g
PiA+DQo+ID4gPiA+ID4gPiBUaGlzIHNlcmllcyBmaXJzdCBpbnRyb2R1Y2VzIGEgcGVyIGRldmlj
ZSBmaWxlIHN0cnVjdHVyZSB0byBiZQ0KPiBwcmVwYXJlZA0KPiA+ID4gPiA+ID4gZm9yIGZ1cnRo
ZXIgZW5oYW5jZW1lbnQgYW5kIHJlZmFjdG9ycyB0aGUga3ZtLXZmaW8gY29kZSB0byBiZQ0KPiA+
ID4gcHJlcGFyZWQNCj4gPiA+ID4gPiA+IGZvciBhY2NlcHRpbmcgZGV2aWNlIGZpbGUgZnJvbSB1
c2Vyc3BhY2UuIFRoZW4gcmVmYWN0b3JzIHRoZSB2ZmlvIHRvDQo+IGJlDQo+ID4gPiA+ID4gPiBh
YmxlIHRvIGhhbmRsZSBpb21tdWZkIGJpbmRpbmcuIFRoaXMgcmVmYWN0b3IgaW5jbHVkZXMgdGhl
DQo+IG1lY2hhbmlzbQ0KPiA+ID4gb2YNCj4gPiA+ID4gPiA+IGJsb2NraW5nIGRldmljZSBhY2Nl
c3MgYmVmb3JlIGlvbW11ZmQgYmluZCwgbWFraW5nDQo+ID4gPiB2ZmlvX2RldmljZV9vcGVuKCkN
Cj4gPiA+ID4gPiBiZQ0KPiA+ID4gPiA+ID4gZXhjbHVzaXZlIGJldHdlZW4gdGhlIGdyb3VwIHBh
dGggYW5kIHRoZSBjZGV2IHBhdGguIEV2ZW50dWFsbHksDQo+IGFkZHMNCj4gPiA+IHRoZQ0KPiA+
ID4gPiA+ID4gY2RldiBzdXBwb3J0IGZvciB2ZmlvIGRldmljZSwgYW5kIG1ha2VzIGdyb3VwIGlu
ZnJhc3RydWN0dXJlDQo+IG9wdGlvbmFsDQo+ID4gPiBhcw0KPiA+ID4gPiA+ID4gaXQgaXMgbm90
IG5lZWRlZCB3aGVuIHZmaW8gZGV2aWNlIGNkZXYgaXMgY29tcGlsZWQuDQo+ID4gPiA+ID4gPg0K
PiA+ID4gPiA+ID4gVGhpcyBpcyBhbHNvIGEgcHJlcmVxdWlzaXRlIGZvciBpb21tdSBuZXN0aW5n
IGZvciB2ZmlvIGRldmljZVsyXS4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBUaGUgY29tcGxl
dGUgY29kZSBjYW4gYmUgZm91bmQgaW4gYmVsb3cgYnJhbmNoLCBzaW1wbGUgdGVzdCBkb25lDQo+
ID4gPiB3aXRoDQo+ID4gPiA+ID4gdGhlDQo+ID4gPiA+ID4gPiBsZWdhY3kgZ3JvdXAgcGF0aCBh
bmQgdGhlIGNkZXYgcGF0aC4gRHJhZnQgUUVNVSBicmFuY2ggY2FuIGJlDQo+IGZvdW5kDQo+ID4g
PiA+ID4gYXRbM10NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBodHRwczovL2dpdGh1Yi5jb20v
eWlsaXUxNzY1L2lvbW11ZmQvdHJlZS92ZmlvX2RldmljZV9jZGV2X3YzDQo+ID4gPiA+ID4gPiAo
Y29uZmlnIENPTkZJR19JT01NVUZEPXkgQ09ORklHX1ZGSU9fREVWSUNFX0NERVY9eSkNCj4gPiA+
ID4gPg0KPiA+ID4gPiA+IEV2ZW4gdXNpbmcgeW91ciBicmFuY2hbMV0sIGl0IHNlZW1zIGxpa2Ug
dGhpcyBoYXMgbm90IGJlZW4gdGVzdGVkDQo+ID4gPiA+ID4gZXhjZXB0IHdpdGggY2RldiBzdXBw
b3J0IGVuYWJsZWQ6DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiAvaG9tZS9hbHdpbGxpYS9Xb3JrL2xp
bnV4LmdpdC9kcml2ZXJzL3ZmaW8vdmZpb19tYWluLmM6IEluIGZ1bmN0aW9uDQo+ID4gPiA+ID4g
4oCYdmZpb19kZXZpY2VfYWRk4oCZOg0KPiA+ID4gPiA+IC9ob21lL2Fsd2lsbGlhL1dvcmsvbGlu
dXguZ2l0L2RyaXZlcnMvdmZpby92ZmlvX21haW4uYzoyNTM6NDg6IGVycm9yOg0KPiA+ID4g4oCY
c3RydWN0DQo+ID4gPiA+ID4gdmZpb19kZXZpY2XigJkgaGFzIG5vIG1lbWJlciBuYW1lZCDigJhj
ZGV24oCZOyBkaWQgeW91IG1lYW4g4oCYZGV24oCZPw0KPiA+ID4gPiA+ICAgMjUzIHwgICAgICAg
ICAgICAgICAgIHJldCA9IGNkZXZfZGV2aWNlX2FkZCgmZGV2aWNlLT5jZGV2LCAmZGV2aWNlLQ0K
PiA+ZGV2aWNlKTsNCj4gPiA+ID4gPiAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgXn5+fg0KPiA+ID4gPiA+ICAgICAgIHwgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkZXYNCj4gPiA+ID4gPiAvaG9tZS9h
bHdpbGxpYS9Xb3JrL2xpbnV4LmdpdC9kcml2ZXJzL3ZmaW8vdmZpb19tYWluLmM6IEluIGZ1bmN0
aW9uDQo+ID4gPiA+ID4g4oCYdmZpb19kZXZpY2VfZGVs4oCZOg0KPiA+ID4gPiA+IC9ob21lL2Fs
d2lsbGlhL1dvcmsvbGludXguZ2l0L2RyaXZlcnMvdmZpby92ZmlvX21haW4uYzoyNjI6NDI6IGVy
cm9yOg0KPiA+ID4g4oCYc3RydWN0DQo+ID4gPiA+ID4gdmZpb19kZXZpY2XigJkgaGFzIG5vIG1l
bWJlciBuYW1lZCDigJhjZGV24oCZOyBkaWQgeW91IG1lYW4g4oCYZGV24oCZPw0KPiA+ID4gPiA+
ICAgMjYyIHwgICAgICAgICAgICAgICAgIGNkZXZfZGV2aWNlX2RlbCgmZGV2aWNlLT5jZGV2LCAm
ZGV2aWNlLT5kZXZpY2UpOw0KPiA+ID4gPiA+ICAgICAgIHwgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBefn5+DQo+ID4gPiA+ID4gICAgICAgfCAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRldg0KPiA+ID4gPg0KPiA+ID4gPiBTb3JyeSBm
b3IgaXQuIEl0IGlzIGR1ZSB0byB0aGUgY2RldiBkZWZpbml0aW9uIGlzIHVuZGVyDQo+ID4gPiA+
ICIjaWYgSVNfRU5BQkxFRChDT05GSUdfVkZJT19ERVZJQ0VfQ0RFVikiLiBXaGlsZSwgaW4gdGhl
IGNvZGUgaXQNCj4gPiA+ID4gdXNlcyAiaWYgKElTX0VOQUJMRUQoQ09ORklHX1ZGSU9fREVWSUNF
X0NERVYpKSIuICBJIHRoaW5rIGZvcg0KPiA+ID4gPiByZWFkYWJpbGl0eSwgaXQgd291bGQgYmUg
YmV0dGVyIHRvIGFsd2F5cyBkZWZpbmUgY2RldiBpbiB2ZmlvX2RldmljZSwNCj4gPiA+ID4gYW5k
IGtlZXAgdGhlIHVzaW5nIG9mIGNkZXYgaW4gY29kZS4gSG93IGFib3V0IHlvdXIgdGFzdGU/DQo+
ID4gPg0KPiA+ID4gSXQgc2VlbXMgbmVjZXNzYXJ5IHVubGVzcyB3ZSB3YW50IHRvIGxpdHRlciB0
aGUgY29kZSB3aXRoICNpZmRlZnMuDQo+ID4NCj4gPiBJJ3ZlIG1vdmVkIGl0IHRvIHRoZSBoZWFk
ZXIgZmlsZSBhbmQgY2FsbCBjZGV2X2RldmljZV9hZGQoKQ0KPiA+IHVuZGVyICNpZiAoSVNfRU5B
QkxFRChDT05GSUdfVkZJT19ERVZJQ0VfQ0RFVikpIi4NCj4gPg0KPiA+ID4gPiA+IEFkZGl0aW9u
YWxseSB0aGUgVkZJT19FTkFCTEVfR1JPVVAgS2NvbmZpZyBvcHRpb24gZG9lc24ndCBtYWtlDQo+
IG11Y2gNCj4gPiA+ID4gPiBzZW5zZSB0byBtZSwgaXQgc2VlbXMgZW50aXJlbHkgcmVkdW5kYW50
IHRvIFZGSU9fR1JPVVAuDQo+ID4gPiA+DQo+ID4gPiA+IFRoZSBpbnRlbnRpb24gaXMgdG8gbWFr
ZSB0aGUgZ3JvdXAgY29kZSBjb21waWxpbmcgbWF0Y2ggZXhpc3RpbmcgY2FzZS4NCj4gPiA+ID4g
Q3VycmVudGx5LCBpZiBWRklPIGlzIGNvbmZpZ3VyZWQsIGdyb3VwIGNvZGUgaXMgYnkgZGVmYXVs
dCBjb21waWxlZC4NCj4gPiA+ID4gU28gVkZJT19FTkFCTEVfR1JPVVAgYSBoaWRkZW4gb3B0aW9u
LCBhbmQgVkZJT19HUk9VUCBhbg0KPiBvcHRpb24NCj4gPiA+ID4gZm9yIHVzZXIuICBVc2VyIG5l
ZWRzIHRvIGV4cGxpY2l0bHkgY29uZmlnIFZGSU9fR1JPVVAgaWYNCj4gVkZJT19ERVZJQ0VfQ0RF
Vj09eS4NCj4gPiA+ID4gSWYgVkZJT19ERVZJQ0VfQ0RFVj09biwgdGhlbiBubyBtYXR0ZXIgdXNl
ciBjb25maWdlZA0KPiBWRklPX0dST1VQIG9yDQo+ID4gPiA+IG5vdCwgdGhlIGdyb3VwIGNvZGUg
c2hhbGwgYmUgY29tcGlsZWQuDQo+ID4gPg0KPiA+ID4gSSB1bmRlcnN0YW5kIHRoZSBtZWNoYW5p
Y3MsIEkgc3RpbGwgZmluZCBWRklPX0VOQUJMRV9HUk9VUCByZWR1bmRhbnQNCj4gPiA+IGFuZCB1
bm5lY2Vzc2FyeS4gIEFsc28sIEtjb25maWcgc2hvdWxkIG5vdCBhbGxvdyBhIGNvbmZpZ3VyYXRp
b24NCj4gPiA+IHdpdGhvdXQgZWl0aGVyIFZGSU9fR1JPVVAgb3IgVkZJT19ERVZJQ0VfQ0RFViBh
cyB0aGlzIGlzIG5vdA0KPiA+ID4gZnVuY3Rpb25hbC4gIERlc2VsZWN0aW5nIFZGSU9fR1JPVVAg
c2hvdWxkIHNlbGVjdCBWRklPX0RFVklDRV9DREVWLA0KPiA+ID4gYnV0ICBWRklPX0RFVklDRV9D
REVWIHNob3VsZCBiZSBhbiBvcHRpb25hbCBhZGRpdGlvbiB0byBWRklPX0dST1VQLg0KPiA+DQo+
ID4gSG93IGFib3V0IGJlbG93PyBBcyBKYXNvbidzIHJlbWFyayBvbiBwYXRjaCAwMDAzLCBjZGV2
IGlzIG5vdCBhdmFpbGFibGUNCj4gPiBmb3IgU1BBUFIuDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy92ZmlvL0tjb25maWcgYi9kcml2ZXJzL3ZmaW8vS2NvbmZpZw0KPiA+IGluZGV4IDA0
NzZhYmYxNTRmMi4uOTY1MzVhZGMyMzAxIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdmZpby9L
Y29uZmlnDQo+ID4gKysrIGIvZHJpdmVycy92ZmlvL0tjb25maWcNCj4gPiBAQCAtNCw2ICs0LDgg
QEAgbWVudWNvbmZpZyBWRklPDQo+ID4gIAlzZWxlY3QgSU9NTVVfQVBJDQo+ID4gIAlkZXBlbmRz
IG9uIElPTU1VRkQgfHwgIUlPTU1VRkQNCj4gPiAgCXNlbGVjdCBJTlRFUlZBTF9UUkVFDQo+ID4g
KwlzZWxlY3QgVkZJT19HUk9VUCBpZiBTUEFQUl9UQ0VfSU9NTVUNCj4gPiArCXNlbGVjdCBWRklP
X0RFVklDRV9DREVWIGlmICFWRklPX0dST1VQICYmIChYODYgfHwgUzM5MCB8fCBBUk0NCj4gfHwg
QVJNNjQpDQo+ID4gIAlzZWxlY3QgVkZJT19DT05UQUlORVIgaWYgSU9NTVVGRD1uDQo+ID4gIAlo
ZWxwDQo+ID4gIAkgIFZGSU8gcHJvdmlkZXMgYSBmcmFtZXdvcmsgZm9yIHNlY3VyZSB1c2Vyc3Bh
Y2UgZGV2aWNlIGRyaXZlcnMuDQo+ID4gQEAgLTE0LDcgKzE2LDggQEAgbWVudWNvbmZpZyBWRklP
DQo+ID4gIGlmIFZGSU8NCj4gPiAgY29uZmlnIFZGSU9fREVWSUNFX0NERVYNCj4gPiAgCWJvb2wg
IlN1cHBvcnQgZm9yIHRoZSBWRklPIGNkZXYgL2Rldi92ZmlvL2RldmljZXMvdmZpb1giDQo+ID4g
IAlkZXBlbmRzIG9uIElPTU1VRkQgJiYgKFg4NiB8fCBTMzkwIHx8IEFSTSB8fCBBUk02NCkNCj4g
PiArCWRlZmF1bHQgIVZGSU9fR1JPVVANCj4gPiAgCWhlbHANCj4gPiAgCSAgVGhlIFZGSU8gZGV2
aWNlIGNkZXYgaXMgYW5vdGhlciB3YXkgZm9yIHVzZXJzcGFjZSB0byBnZXQgZGV2aWNlDQo+ID4g
IAkgIGFjY2Vzcy4gVXNlcnNwYWNlIGdldHMgZGV2aWNlIGZkIGJ5IG9wZW5pbmcgZGV2aWNlIGNk
ZXYgdW5kZXINCj4gPiBAQCAtMjMsOSArMjYsMjEgQEAgY29uZmlnIFZGSU9fREVWSUNFX0NERVYN
Cj4gPg0KPiA+ICAJICBJZiB5b3UgZG9uJ3Qga25vdyB3aGF0IHRvIGRvIGhlcmUsIHNheSBOLg0K
PiA+DQo+ID4gK2NvbmZpZyBWRklPX0dST1VQDQo+ID4gKwlib29sICJTdXBwb3J0IGZvciB0aGUg
VkZJTyBncm91cCAvZGV2L3ZmaW8vJGdyb3VwX2lkIg0KPiA+ICsJZGVmYXVsdCB5DQo+ID4gKwlo
ZWxwDQo+ID4gKwkgICBWRklPIGdyb3VwIGlzIGxlZ2FjeSBpbnRlcmZhY2UgZm9yIHVzZXJzcGFj
ZS4gQXMgdGhlIGludHJvZHVjdGlvbg0KPiA+ICsJICAgb2YgVkZJTyBkZXZpY2UgY2RldiBpbnRl
cmZhY2UsIHRoaXMgY2FuIGJlIE4uIEZvciBub3csIGJlZm9yZQ0KPiA+ICsJICAgdXNlcnNwYWNl
IGFwcGxpY2F0aW9ucyBhcmUgZnVsbHkgY29udmVydGVkIHRvIG5ldyB2ZmlvIGRldmljZSBjZGV2
DQo+ID4gKwkgICBpbnRlcmZhY2UsIHRoaXMgc2hvdWxkIGJlIFkuDQo+ID4gKw0KPiA+ICsJICAg
SWYgeW91IGRvbid0IGtub3cgd2hhdCB0byBkbyBoZXJlLCBzYXkgWS4NCj4gPiArDQo+IA0KPiBJ
IHRoaW5rIHRoaXMgZG9lcyB0aGUgY29ycmVjdCB0aGluZywgYnV0IEknbGwgcmVzZXJ2ZSBmaW5h
bCBqdWRnbWVudA0KPiB1bnRpbCBJIGNhbiB0cnkgdG8gYnJlYWsgaXQgOykNCj4gDQo+IFRoaXMg
bWVzc2FnZSBuZWVkcyBzb21lIHR1bmluZyB0aG91Z2gsIHdlJ3JlIG5vdCBmYXIgZW5vdWdoIGFs
b25nIHRoZQ0KPiBwYXRoIG9mIGNkZXYgYWNjZXNzIHRvIGNvbnNpZGVyIHRoZSBncm91cCBpbnRl
cmZhY2UgImxlZ2FjeSIgKGltbykgb3INCj4gZXhwZWN0IHRoYXQgdGhlcmUgYXJlIGFueSB1c2Vy
c3BhY2UgYXBwbGljYXRpb25zIGNvbnZlcnRlZC4gIFRoZXJlIGFyZQ0KPiBhbHNvIG11bHRpcGxl
IHNldHRpbmcgcmVjb21tZW5kYXRpb25zIHRvIGJlZnVkZGxlIGEgbGF5cGVyc29uLiAgUGVyaGFw
czoNCj4gDQo+IAlWRklPIGdyb3VwIHN1cHBvcnQgcHJvdmlkZXMgdGhlIHRyYWRpdGlvbmFsIG1v
ZGVsIGZvciBhY2Nlc3NpbmcNCj4gCWRldmljZXMgdGhyb3VnaCBWRklPIGFuZCBpcyB1c2VkIGJ5
IHRoZSBtYWpvcml0eSBvZiB1c2Vyc3BhY2UNCj4gCWFwcGxpY2F0aW9ucyBhbmQgZHJpdmVycyBt
YWtpbmcgdXNlIG9mIFZGSU8uDQo+IA0KPiAJSWYgeW91IGRvbid0IGtub3cgd2hhdCB0byBkbyBo
ZXJlLCBzYXkgWS4NCg0KR290IGl0LiBJJ2xsIHVwZGF0ZSBpdCB0byBteSBicmFuY2ggZmlyc3Qu
IPCfmIoNCg0KUmVnYXJkcywNCllpIExpdQ0KDQo=
