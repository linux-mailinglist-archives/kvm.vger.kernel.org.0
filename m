Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 626076DA8F9
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 08:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239193AbjDGGbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 02:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbjDGGbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 02:31:18 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7655253
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 23:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680849076; x=1712385076;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=01snJBAZtkzOJMET2syIpvJPfSjM/hr4Wrlendop/4Q=;
  b=GD/huiyRjBZOJzzETEBTUd2yfjSpTQmCIL3npWMdaZkkp5RWJRHBwQT+
   TGNcriln7ZBUIlBVVBZPeQ2IY4y3+69gsSqBF/ACnMBCf8/p+aui5MeRR
   f1DiK5yQcYZCrYsRNSxrfFSEMEJlSkNC2xx5L7o4JhIBor4U8IG09K7+1
   ahksolHmzewwk2Y9rjptpPtzGCduyG7jA68vOv2OCYLX6dOOLllTItOlV
   RRL35sp3e1iCrEqxZ0OmKhboulEfzES1dtDr5rUE3DflzQBYZhBNFR/hs
   lPzLpz7raE0eP6enLsiIiX1COAmFlvA86Gh+sBAiw9smqu6b1sSps3/jQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="340425633"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="340425633"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 23:31:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="751940281"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="751940281"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 06 Apr 2023 23:31:14 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 23:31:13 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 23:31:13 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 23:31:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 23:31:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRacNH8BPTsflMDw/dRGRgV5L1zx7c7+FvefYsLuQDbjU9h4+unQR0SUucwevnbeoWyuN1zD6W1SVPKFuwRb2j+YLvryK/FsWGRdgfuKE1hphS7/LGvBW9MuPW/R1te4L3n7Nt6f9/750DV/7Y6DjsBSmxDrEfNOmsAS4fBcnAj+1ZS0DgFwj18zQcX7ZoNAra29CUHZbj9zmuLdIS8e8rA9ndT2Mr7gg8dXbk3xubSlRyUv/X7S5+O6dJ1Y5OL3o4vDNQ2LjQnfnsFLPEljP7JCXbJIM5swfEKGbz+B2NzioJQJc7ItbqAcSb9crvN7Vd+iMT0z42ttZjLxiImZ/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=01snJBAZtkzOJMET2syIpvJPfSjM/hr4Wrlendop/4Q=;
 b=kgSlTohFuAxaFbTHO6GQGJU2d12qcFDvOOMIppdc7Rg1zbX3tBGsT4Q9WIs4BR2djifbdbZ0SEAUeRgdqgQUIX+QtdbG1IgvZ0crn+UPivK74LQwlWBk1p7ZyXmu342R9Quy98BOQT+V9VQ+7eRKCNywwB2zdF/OeCm/VcXSSUeNfnuuAcdnkjBjVUMjw3FJAF9It/0KXeLQaRUn7rxnFqiNI4sgyIOuvUP76natT6ZWJBALNtNxwvqUJ9upwpMkRkfL0OmCA2patT6PE+BEiqFn4iXsRapB3C41cglWibCy/HCfZHi1IW/Zopbie3Ly0PlGr8jVeAK5jxxHxLgdfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by MN0PR11MB6034.namprd11.prod.outlook.com (2603:10b6:208:375::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Fri, 7 Apr
 2023 06:31:08 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948%6]) with mapi id 15.20.6254.035; Fri, 7 Apr 2023
 06:31:08 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Yao, Yuan" <yuan.yao@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "H.Peter Anvin" <hpa@zytor.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: RE: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
Thread-Topic: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
Thread-Index: AdlnGoO7DMFQx8JhSoqsl2dQLdydDABDU48AAAo299AAAlafAAAvCn2w
Date:   Fri, 7 Apr 2023 06:31:08 +0000
Message-ID: <SA1PR11MB6734DEF40B432E13260B511EA8969@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <SA1PR11MB673463616F7B1318874D11A3A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
 <ZC4hdsFve9hUgWJO@google.com>
 <BYAPR11MB37173810AE3328B5E28A18D795919@BYAPR11MB3717.namprd11.prod.outlook.com>
 <2e57ad5d-d17a-98b7-d4f9-912bdb23c843@redhat.com>
In-Reply-To: <2e57ad5d-d17a-98b7-d4f9-912bdb23c843@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|MN0PR11MB6034:EE_
x-ms-office365-filtering-correlation-id: f01fe33f-970a-4f82-1a34-08db3731abfb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: advHVrWgMqWsuz2LGqZh8MELdQe6vqZmkEq94dwCjwAJkQPVoSGxme3/+hsyAkrqaWSjAK+/3Nz7RA8iQmacXWdgY24WCQknRwMZk7vg6rxePHl4Dtp/bZ8E9OLVUuK24W7UUrwwcMEd5EpMjmzjfc1i/V0FiOI15EBfJdTfBL3CAYA2XlpRsJaRIJijVAM5qVorGZjvcKaxHECwiI/bx3Et+yxEtFsJPnjyPkhWkbAl0Je/M8C5eKaIO8+U6h8XQlHVVss7ICyLA6tXDPSjtLtb7wJ/MmTrA3/4a87ZFtKEe8w477+sMRc/wBi5dol09PzbgsBx9ERLIR0jql1eKawwVG8hatRYXCpWYzboi5xKt+Y3/v34kOwev5Rqjw1b5FPQBqZM0AXJ+0aYxafMCU7hmVKYKsyM/BLRiYh40qwt+CY3KG1LEFShLs2+/mAtNEjVIfQB0e8Re5IphGI3ljiimeK7wL2OCPDalCFZpclQNRG0DqgW8rR3gnvgtPnXt5JgKL/9ucy8uQVQLDhKYhhV+zIFI8N05Ay+/ykygnT8gv4C6wwI4lVXuufaOKF1S/ls0Us4CE0rw8MRRmxGUMtePpPyGUmN3dVmy6iHhO5VOFqFJSBYdBZ/MoGNZmPD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(396003)(39860400002)(376002)(451199021)(86362001)(7696005)(478600001)(71200400001)(9686003)(54906003)(316002)(6506007)(26005)(4744005)(186003)(110136005)(107886003)(2906002)(52536014)(8936002)(38070700005)(66446008)(66946007)(66556008)(66476007)(76116006)(5660300002)(8676002)(41300700001)(4326008)(122000001)(55016003)(38100700002)(33656002)(82960400001)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEFYa3hhclFnbGx2c0VrYzZacTBVU2NuZitvd3ZnWWp3dVgreU9VOGRSczk2?=
 =?utf-8?B?dzRBTlRPa0RzNUNManQvZU92WlpoZER6RnZ2QkdyNEQ1Rmx1RERVKytaaHNw?=
 =?utf-8?B?T2tiYVNKMXl6WmRSSUtUVzM3U01RK0FNSFBOL0d3REhIaDd6QzBpL1RRRExH?=
 =?utf-8?B?SEw1dFB2aHhJS1pWeW9YRFdtYmkzeDk1MkFiaUFNWGlXY0RBY0x2b0NiUjkx?=
 =?utf-8?B?Nk1RR1pRbmhzeW1sZTExS2R0NFQzRDJjU05Uam8xOXlqRmd0V1hQV1JnS0Jv?=
 =?utf-8?B?UGVhVTFEcXZJQ212d1N5Y0J2V2F5M1E3WGpDRlo4enVURHV5VWVicEhxVUtJ?=
 =?utf-8?B?cVd0ZTVqYVVoQmw2Y2Rua3dWS0xmVXJPVDhlNFB5NTBDVVJ6Zlo1YTlsOTZP?=
 =?utf-8?B?dk9TbHlUT1dsZ2pWRnhMdmNUVjBYTDg1QUV3NGtQQnRKUDgwV2RsZlFWNTRu?=
 =?utf-8?B?OGtQTnZSUXhJL3loRS9sTldTa0ZheEwwVS9tNVM1Um1GZUF0a0xGV1NtWW1h?=
 =?utf-8?B?NkxkUEIvL0gvWEFCMmFudVNQMnBZZE1YVXVWVkRFTnQ5SUdxRGFwaFQxN3RW?=
 =?utf-8?B?SUl0b2g1Tlc4NTZYaVQ3N09BR1lOWktqM0NFM1Rkdk5DR1plZEw0NXgyRSsr?=
 =?utf-8?B?cFE2YXIxN2pCMlM2RDJPZ2EvZlNBeXZVT0R6NDBNRE81OFNvWlNhbHRFNDEr?=
 =?utf-8?B?UTBzV0VkVXZ5Zndwc2xQVnc5dTNHWWU1QTRxb2RLWWxkb3Y2aDgyMzYzQ2Ro?=
 =?utf-8?B?WjNJQXhFQ25FRGFBWXFySEZqZkJqdWV2VE55L2E4QkFGTmhuVm1EZHh0ZTc0?=
 =?utf-8?B?VmNpKzdRV3dwVXJYL0dqWXRIUEFBZ2xwVEw3MUdLWkN4dXZSck5yZFhIc092?=
 =?utf-8?B?Q3pDT0NnTi9EV2lLWWhKcHdjQTNYRDFHZWl1a1NSTU0xTTI1ZTlqazdQQU1N?=
 =?utf-8?B?RFJDelZIN0xnQ1JvUWNjellwWVAyMTJYZ0hKbk1GZ1FkRXVFYmd1cVRuTFBU?=
 =?utf-8?B?Y2d6c01VanNJaExTZFN4RmxCTzcwMGZGcmVRQ21aRXg1aGVIc2J0QU80bmti?=
 =?utf-8?B?YXNHR2NXTDEvUlZKY1hoOXpzRjArQlhPbjdaWkUvdGd0QVNNN3VmTnl2M1Nm?=
 =?utf-8?B?aGN1WVhwR2ZNRGZvU1RPSHF2Umg4RzloMW9pV0p4eWJMNVFtMHNaL1drTDEx?=
 =?utf-8?B?TnBtbjNEWmIwSVd5MEtnaGxrZkFVVW54TTltODNHWTlVZlJEbndSK1FTUmhV?=
 =?utf-8?B?c3lQQndkbW1tcEhad05TaGJoVlpRZ1FIWkJMeUxzN2xlc29WRUFvRzhzcXNv?=
 =?utf-8?B?WWlXYnhVT2VJMUx5YXVybGEwQzg0NHREVUR3Zm9pWGlEZ3NaOU5CVmhieFRY?=
 =?utf-8?B?cUowV1E4S3BWbVlCempFVW9nSFJzaDRZbnozOS9oWFNEZXpaSGliUElxYndY?=
 =?utf-8?B?dzQzZmcyTVcrbmZwaXNtOWRmbFFucGxzYklrMzRKTTJkVkpQUTdjT3k1aTFC?=
 =?utf-8?B?YVd4dCtkMDdNbU1MdjJEeDRBajFsR0RROHU1SCtNUk50eXpLak5pNG4vSVZm?=
 =?utf-8?B?QTczZnQ0SHVuNWZ6OFpTWExqdVRMVnFUcHRkbGdiNmdTeGY4ZVBFL2JyQjYy?=
 =?utf-8?B?NHpkam5xSDFHdXN5eHRIQXlTZWNWNVJIeDVoSmZPUi8rekIwbEs1WWcyMG9E?=
 =?utf-8?B?a0EzMVJ0SnpKWlZlUUtCdkpDVFJPQWdaSllldXh5NExJK1JIRUx2OVlVWUZP?=
 =?utf-8?B?VTluSUdybWw5OXVQcXM3czZKY3QydHBhQmFwcmo3cDRua0VFQ1l2NG5KNmZ3?=
 =?utf-8?B?ekl0Ujdpb0YxREVYQzlOQkoyNW1BUGx6RzJqdStyRzA2aVZoTCtWTmpITHlD?=
 =?utf-8?B?S1o5YVMyTFRNek1XdXNyQXJldnRmajIvV1hEYjkveVNXdXlRRkFobjAvQjkv?=
 =?utf-8?B?NFZHOGhQRVdabjRpU2ZoTURuajUrWVlmK200OUFERW5DSjJsWnJkeXdSb29l?=
 =?utf-8?B?WmQ4WjNtWkJnNlptck91UlRzUmxDMGd5YkNjSzdkZGJDMXoyOHlEQnFVRFdn?=
 =?utf-8?B?NktvcUQvM0d3QjJIcmhXckhMWXEvdWdCNzZBeUFjRG9iNzBYaDNDUjVDY09o?=
 =?utf-8?Q?E79g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f01fe33f-970a-4f82-1a34-08db3731abfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 06:31:08.0802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 90EcCsq2u8ML3UjPrEA0XQwEvdXN1xEB42eCh4wrNjHGxDKhJhFM3v4EoL+k9fgKOm2uv7knStZftFpOMkjM6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6034
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+IHJlLWV4ZWN1dGUgdGhlIEwyIGNvZGUuDQo+IA0KPiBZb3UgY2Fubm90IGtub3cgd2h5IEwx
IGluamVjdGVkIGFuIGV4Y2VwdGlvbi4gIEZvciBleGFtcGxlIEwxIGNvdWxkIGhhdmUNCj4gaW5q
ZWN0ZWQgYSBNQ0UganVzdCB0byB0ZXN0IHRoZSBjb2RlIGluIEwxLg0KDQpHb29kIGV4YW1wbGUh
DQoNCj4gDQo+IFRoaXMgaXMgYSBzY2FyeSBjaGFuZ2UsIGluIGEgc2NhcnkgYXJlYSBvZiBjb2Rl
LCB3aXRoIHVuY2xlYXIgYmVuZWZpdHMuDQo+IEl0J3MgZ29pbmcgdG8gYmUgaGFyZCB0byBjb252
aW5jZSBwZW9wbGUuIDopDQoNClllcywgdG90YWxseSwgSSdtIG5vdCBzZWVraW5nIGEgY2hhbmdl
IGJ1dCBtb3JlIG9mIGEgZGlyZWN0aW9uIGNoZWNrLg0KDQpIb3cgYWJvdXQgYWRkaW5nIGNvbW1l
bnRzIGFib3V0IHdoeSB3ZSBhcmUgTk9UIGRvaW5nIGl0Pw0KDQpUaGFua3MhDQogIFhpbg0K
