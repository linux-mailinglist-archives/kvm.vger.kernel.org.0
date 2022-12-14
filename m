Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B00D64C7C8
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 12:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbiLNLRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 06:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiLNLRm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 06:17:42 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFF0F62;
        Wed, 14 Dec 2022 03:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671016660; x=1702552660;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KFj/KZo0Ii5Mdftr4AWeRiToox9vAxIvyVAnDtkB9Ho=;
  b=iteSoC1+Ly2Pk633eSLeg6zopx5mWiQh1W8I0N77peAxTOD+PapVomV5
   WvRVx4iEcZQS0zlC7t47tUEGDY0LBNDBb4wGoG4oqj465b+k5itSmKInT
   U0/9YdcZ1bsxrqHbLQSBRlQ0SmSFjVbn/1/9NFGVWclYvjWk8wUGIK2Gh
   85Bp+1RGGpJ1ZhliOdWR8ZhFnVSYH9ol5Hp3T0YbXJCs3Pg8N7m4nnMdV
   1izbOMdxzCHb057uxaOhD6lEwIhaSCv4a+u+R0XHN+FJLeNH+lej8/haH
   T8PfPJx2DzYQA4WhAovJdzkr0LBD0LxR6EvUxliQAXqGqY4nRxh7JoWbd
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="317078011"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="317078011"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 03:17:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="648973766"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="648973766"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 14 Dec 2022 03:17:38 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 03:17:38 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 03:17:37 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 03:17:37 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 14 Dec 2022 03:17:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X706JtWmq0LjvlvVpbqNRjvWCQoygktgdklYRE+1Cmc8vh4JCSSRNJ0ClBY+OGo3vcaocttDnJkKKeLEkcwC81mh2csdn8NCvGSn6dWGtGWM+FQ7bBhvwocp0kI0YtcphB1q01iXgeerSraxJFUZJbxYyBnVG+LvY79av79mTInnL+lyUmV8g2OZ8kd7BYX+PUn31MzcDpiWvK4b0anA3HRGPqD6XKeYizRjOCK5By8yF/ZiC8u8WtfbsLYS3hRQTXBrtCQeoeyeZx+3B9jlbri6M2Au0lwsdfCgFrcluhYynxyc5zwZR94gea2zSzNclNc0xII4vOTMNrjqzJuv+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KFj/KZo0Ii5Mdftr4AWeRiToox9vAxIvyVAnDtkB9Ho=;
 b=GaOOIdY2zbDFGiwwa+6aZ82v1C83ye173nbAcBZol2lTuYXXw8Upy7+z7t0Tkm0UjYYzK6jvtQlv2K7iX1OvRZ2aqdXu4NIR3/HffsiCXb7g6bFZjmNM8mxGZ606ueCb9L9qaSyWJ4IqGTHtvUhwKJ56/8+R1p+LATRwlLr6lj2DQCmRAT1pM0ME1HkLTNXv2gExm6pzUjKRnQKf7TPrwHT3qtQSztFPZf+cENKGuBjtLcUvAoNuQvFyx/76YluVJIf/Lltav1caHTysSL5Xo/4qGiuMlvm8u6tTcwib8os9kxN8fuZ+Em3936BlnbeKKdbxPK92B2TzBtiBATgo/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB7255.namprd11.prod.outlook.com (2603:10b6:8:10d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 11:17:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 11:17:32 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 047/108] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
Thread-Topic: [PATCH v10 047/108] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Thread-Index: AQHY7CiGPKQ26x0OSk+nInOi8x3lUK5tgv+A
Date:   Wed, 14 Dec 2022 11:17:32 +0000
Message-ID: <f3cb9b24c24122c590dd4ba27434b5c069f00372.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <9e8346b692eb377576363a028c3688c66f3c0bfe.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <9e8346b692eb377576363a028c3688c66f3c0bfe.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB7255:EE_
x-ms-office365-filtering-correlation-id: 9eded09f-bb0c-4b3a-fc36-08daddc4cb95
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GPwXPR8+cBDoqfitDEE49ItH9M3um7OwRIlsoIQWGQvZYhJqFcfm/DiBN9g9FPiGuZXgWfrwsYy9hsuHJzi4WKYBGiPxbsbayQLBAZgFhQAoM1RZnAU31fRg/DJxNVRaOSi0qpxIs39Y/FAj7q2mg4sc87nc4PuSpKv3Ph9P2XDRcq+eoUeK4PjqWcyluuq7rXMjYWlm0ythNj7J5QQNlBIXrVvpsqk7tY02hyxxi3D/g5BZzmjA/HcHv7kOGeuvJUP7VM5QBnhhfKKBqKq+w3dPz//nCC/rwgJUaz5IXCNVoNl98mDE7qiCIxbQCJLzqr+KD6KNdWsM7d/2u9J6bPDq4M95ICyp5JK2GAiiMXZy4Tlpr8grgI5WN3efpaBEB6AC3u5ApD2rAe2/F6KfNMMIKlvwmagqHc8/a40FjuOKGy1DYtUppIIb0+fvMqJsnCin9UMjVjNxnyKgdoZIgAFkhMlvc56vo5sH9R10EKVj1+ujT9rkJN2342m0h886JC/VmrtDUeK303F2p8oKbH/1YpAF2n21ITZYUIfeqDuSAIsHlFEmndI/IBL5aj0C+sspmudTYkqKixBOwm5YjOXfPo7yj53YZESZkNSoIZwgnW0qLz3+UksyAZOVO8l6/66eFVi/01kQsBJsBAGXbq+UuJjzOqngC6IC5GVqiKFiyAWM47ZqUxGOIU0KAZ1fr0UTO/Vt3AOqIfAv1+5d6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(136003)(396003)(346002)(451199015)(71200400001)(478600001)(6486002)(66476007)(66556008)(26005)(316002)(6636002)(6512007)(54906003)(8936002)(8676002)(66446008)(4326008)(91956017)(41300700001)(36756003)(6506007)(5660300002)(4001150100001)(38100700002)(2906002)(86362001)(64756008)(76116006)(186003)(2616005)(122000001)(66946007)(83380400001)(110136005)(38070700005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SFkxMHZvVW4zbGNyZ0crOGpqS1IzQWZ6RWZOd1ZpVDBPVmQ2eU9WWDZkeklC?=
 =?utf-8?B?L3AxMXk4Ujd6SFROU2JRNGx0S0c1VDJEV1B5Yk8weEZYN0MzUElkZkY1WFBL?=
 =?utf-8?B?Rk5EalpSc2tLbXFkenhSNEszeGo0T2VXN2VXU1pCZk5nYzdDZTJiWGc1VTdw?=
 =?utf-8?B?VnFwbmUrTTlybi9qR05IeWd6TGpITk91cjRWdkRIaUJ5aVFEZGc4QUJTalFk?=
 =?utf-8?B?eEJ6SlNGelMycTN2Nmw4VGc4VURmL1lvVE5UVS9wTlRiOVFZbTNKNVZITy9k?=
 =?utf-8?B?ZkVjMVdNakpqQ2poTEVVVSttVXVIaWhhdG9jTGhwVUZ2aDdJaEJiRkQ1TDkw?=
 =?utf-8?B?K3BIemc1ZjNvdXc4SThUUVBDdkRQRmk4TXlrenZnVlR6S1ZPTW5DTDNFU3h6?=
 =?utf-8?B?OWpva21SNzVWS0Z5UXdtVHB2OTY4UGNDSlk3azM0RXlZVjFSZWMyWkNXUkQ2?=
 =?utf-8?B?UEJVRURoUDZzVzdrVG9jZ2pFY0Z2b0pBTW5tQWVtVnFpT2VPVTMxUUZ4eDVl?=
 =?utf-8?B?a2h6UHVnY0ozMjl1c09mSC9kU2tHckdWcWdPVVZxTnVMZTJ6MXBzMWNybFFO?=
 =?utf-8?B?QWNiSG9saGpOaE01QXV5dHYwbUdmZExLbGJ6bUs2SmJpZER2QlFYRkRkclV4?=
 =?utf-8?B?V3UyVVFIUVk3Mk5wYjl0aVhGbit0SkNoL0ZBZ0FsL2k0aUFTUDNUQ2dCVk13?=
 =?utf-8?B?N0p6cFN1TkM3NGwzLytOY3VqRndQVWtjdzJ1QzE0eGNzQzhHRSthdENkZTNp?=
 =?utf-8?B?K1BqZWxNWWVCd2NrT2ZnVVNFak5kVVQzRDVTVG1Id3dhV3h2aElBVWNWOXZY?=
 =?utf-8?B?MXU3S1ZaQXlZZmVPWTFyTFBIN3UzMStDTGNsNlVPK3d6ckdoNkFUNXlzUjhT?=
 =?utf-8?B?U2NpSWovTW14TmltTk5BdkJPN0FHTWlTUXQ3ekxxMTZrcVIzNXhPakkrOWY3?=
 =?utf-8?B?U21ucGszdVNjU3JnN05kbFh2dnZLU1RBOFQ4ZGFLbzlvVldoNWd0cml2SVFq?=
 =?utf-8?B?RkViMkQyYVRuVlZiMUk4aTB0dGZpdnZ3cGFYWEIyZmpoSXZzcHBZM3BkaHpw?=
 =?utf-8?B?ejFRYmM5eCtpSzNKZVRwbWhqOUdVRHNTWkJyNHd1SXhqY3dONUdSNkZkbHkw?=
 =?utf-8?B?b3ZQN2dBRWo5QXZHM0EwQk11Q2cwTjhtblRZdkU4dk5KdGhPZTNhOUZscWww?=
 =?utf-8?B?RXgyWWJlRElnam80N3lvRkErQXhMVEd6MWxCTlZRRVBFdm1QcDEwK3lzM2N4?=
 =?utf-8?B?N2hkdFRvMTYyMlFrOHBhNG1VbnlSNGtNUHZoQlNxQXpzUFZuY0x5c2k2WnNo?=
 =?utf-8?B?NEl1dHh0VDE4bWRxdFVEU0laZGxBcTJoc2JZMUw1OVBWSGVVeWR6KzFHaVJm?=
 =?utf-8?B?cHdHY0lXN2YxLzRGakdmWUVjb1NmM2FhZ2ZtWDZNZnpHbWNyOXNwbm8rZVFh?=
 =?utf-8?B?TS9CZHcrSndsNkhINGlFQjZ3NGh3dExPMTQ0UU1tUUQ5OVN2OCtpVkVHOUty?=
 =?utf-8?B?ZmVkcFc1eGJVdlprcXVkbUxPaERuMjI5Z2lzMjJHRXoxRmRpV2ZHTFU0MXRK?=
 =?utf-8?B?S0N6WmlaWHl3QWNDU2dZMEdEdXU4UWdsRnpnVHg1REF3eDhFbzNNeTJ3OEJM?=
 =?utf-8?B?YytUL2dkaDlRYmxCUURuVFpDbjYzSWR4TXRjMWJ5TVlIc0RTUGZYcS9hVXhK?=
 =?utf-8?B?UThKR01Kc0I5WXFVWGVmRkdaMWpOcktxRjlLSzh5K3VzSmxHOXJjL0laR2Rv?=
 =?utf-8?B?QmYycUZ3K2xtNjN0RVFnR2JhREtTa210djhxeG94Rkhtb3N6eWR2TkZSRUdX?=
 =?utf-8?B?V3pBS3owdWtCUWhEbnBrUUxub3loSzZzNU94bUlBcVJ1a0tWOGtuVHdSNzJM?=
 =?utf-8?B?aEFiREQ1ck9LbldlWDdsTnduV3lYSnFLTmh5WkVpNmdHU1FWTjlBeUlFdElT?=
 =?utf-8?B?UFR5bG9NZER0alRQdkZnQy9iQUhUNXZnOVB2T0M5Y0I2ZlJ5OGRZbUg2ZmZV?=
 =?utf-8?B?N1k1dkRIZ0ltLzM5VGY4eTNYRmVuZzFHK0FQMThkVnR0TU9HTzVHeXVpMG1C?=
 =?utf-8?B?a0lXSlZzdUQxSXNwZmhpS0RGbjJ5anZFdDg4Rk9SbmlYcmZRSDlOL3MyZnFK?=
 =?utf-8?B?ZkdWU3p2MzNKSXliZW9NS0oxVk1jM2RTSnp3ZzRHMGJOdHNRS3hWY3B6Ty9V?=
 =?utf-8?B?NlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B052DD64C753F84995F2D035EA91A845@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eded09f-bb0c-4b3a-fc36-08daddc4cb95
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 11:17:32.4966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dd/OKuJatHI54w89S4qJiJ3dmoBqwmuK1HSb+t3x7QpD5+A49w9bfxLAttGerJ1RO+pKEUf8wGe72xBfwPX1Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7255
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIyLTEwLTI5IGF0IDIzOjIyIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJpc3RvcGhl
cnNvbkBpbnRlbC5jb20+DQo+IA0KPiBURFggc3VwcG9ydHMgb25seSB3cml0ZS1iYWNrKFdCKSBt
ZW1vcnkgdHlwZSBmb3IgcHJpdmF0ZSBtZW1vcnkNCj4gYXJjaGl0ZWN0dXJhbGx5IHNvIHRoYXQg
KHZpcnR1YWxpemVkKSBtZW1vcnkgdHlwZSBjaGFuZ2UgZG9lc24ndCBtYWtlIHNlbnNlDQo+IGZv
ciBwcml2YXRlIG1lbW9yeS4gIEFsc28gY3VycmVudGx5LCBwYWdlIG1pZ3JhdGlvbiBpc24ndCBz
dXBwb3J0ZWQgZm9yIFREWA0KPiB5ZXQuIChURFggYXJjaGl0ZWN0dXJhbGx5IHN1cHBvcnRzIHBh
Z2UgbWlncmF0aW9uLiBpdCdzIEtWTSBhbmQga2VybmVsDQo+IGltcGxlbWVudGF0aW9uIGlzc3Vl
LikNCj4gDQo+IFJlZ2FyZGluZyBtZW1vcnkgdHlwZSBjaGFuZ2UgKG10cnIgdmlydHVhbGl6YXRp
b24gYW5kIGxhcGljIHBhZ2UgbWFwcGluZw0KPiBjaGFuZ2UpLCBwYWdlcyBhcmUgemFwcGVkIGJ5
IGt2bV96YXBfZ2ZuX3JhbmdlKCkuICBPbiB0aGUgbmV4dCBLVk0gcGFnZQ0KPiBmYXVsdCwgdGhl
IFNQVEUgZW50cnkgd2l0aCBhIG5ldyBtZW1vcnkgdHlwZSBmb3IgdGhlIHBhZ2UgaXMgcG9wdWxh
dGVkLg0KPiBSZWdhcmRpbmcgcGFnZSBtaWdyYXRpb24sIHBhZ2VzIGFyZSB6YXBwZWQgYnkgdGhl
IG1tdSBub3RpZmllci4gT24gdGhlIG5leHQNCj4gS1ZNIHBhZ2UgZmF1bHQsIHRoZSBuZXcgbWln
cmF0ZWQgcGFnZSBpcyBwb3B1bGF0ZWQuICBEb24ndCB6YXAgcHJpdmF0ZQ0KPiBwYWdlcyBvbiB1
bm1hcHBpbmcgZm9yIHRob3NlIHR3byBjYXNlcy4NCj4gDQo+IFdoZW4gZGVsZXRpbmcvbW92aW5n
IGEgS1ZNIG1lbW9yeSBzbG90LCB6YXAgcHJpdmF0ZSBwYWdlcy4gVHlwaWNhbGx5DQo+IHRlYXJp
bmcgZG93biBWTS4gIERvbid0IGludmFsaWRhdGUgcHJpdmF0ZSBwYWdlIHRhYmxlcy4gaS5lLiB6
YXAgb25seSBsZWFmDQo+IFNQVEVzIGZvciBLVk0gbW11IHRoYXQgaGFzIGEgc2hhcmVkIGJpdCBt
YXNrLiBUaGUgZXhpc3RpbmcNCj4ga3ZtX3RkcF9tbXVfaW52YWxpZGF0ZV9hbGxfcm9vdHMoKSBk
ZXBlbmRzIG9uIHJvbGUuaW52YWxpZCB3aXRoIHJlYWQtbG9jaw0KPiBvZiBtbXVfbG9jayBzbyB0
aGF0IG90aGVyIHZjcHUgY2FuIG9wZXJhdGUgb24gS1ZNIG1tdSBjb25jdXJyZW50bHkuICBJdA0K
PiBtYXJrcyB0aGUgcm9vdCBwYWdlIHRhYmxlIGludmFsaWQgYW5kIHphcHMgU1BURXMgb2YgdGhl
IHJvb3QgcGFnZQ0KPiB0YWJsZXMuIFRoZSBURFggbW9kdWxlIGRvZXNuJ3QgYWxsb3cgdG8gdW5s
aW5rIGEgcHJvdGVjdGVkIHJvb3QgcGFnZSB0YWJsZQ0KPiBmcm9tIHRoZSBoYXJkd2FyZSBhbmQg
dGhlbiBhbGxvY2F0ZSBhIG5ldyBvbmUgZm9yIGl0LiBpLmUuIHJlcGxhY2luZyBhDQo+IHByb3Rl
Y3RlZCByb290IHBhZ2UgdGFibGUuICBJbnN0ZWFkLCB6YXAgb25seSBsZWFmIFNQVEVzIGZvciBL
Vk0gbW11IHdpdGggYQ0KPiBzaGFyZWQgYml0IG1hc2sgc2V0Lg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogSXNha3UgWWFtYWhhdGEgPGlzYWt1LnlhbWFoYXRhQGludGVsLmNv
bT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vbW11L21tdS5jICAgICB8IDg1ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKy0tDQo+ICBhcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUu
YyB8IDI0ICsrKysrKysrLS0tDQo+ICBhcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuaCB8ICA1ICsr
LQ0KPiAgMyBmaWxlcyBjaGFuZ2VkLCAxMDMgaW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS9tbXUuYyBiL2FyY2gveDg2L2t2
bS9tbXUvbW11LmMNCj4gaW5kZXggZmFmNjk3NzRjN2NlLi4wMjM3ZTE0MzI5OWMgMTAwNjQ0DQo+
IC0tLSBhL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL21tdS9t
bXUuYw0KPiBAQCAtMTU3Nyw4ICsxNTc3LDM4IEBAIGJvb2wga3ZtX3VubWFwX2dmbl9yYW5nZShz
dHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fZ2ZuX3JhbmdlICpyYW5nZSkNCj4gIAlpZiAoa3Zt
X21lbXNsb3RzX2hhdmVfcm1hcHMoa3ZtKSkNCj4gIAkJZmx1c2ggPSBrdm1faGFuZGxlX2dmbl9y
YW5nZShrdm0sIHJhbmdlLCBrdm1femFwX3JtYXApOw0KPiAgDQo+IC0JaWYgKGlzX3RkcF9tbXVf
ZW5hYmxlZChrdm0pKQ0KPiAtCQlmbHVzaCA9IGt2bV90ZHBfbW11X3VubWFwX2dmbl9yYW5nZShr
dm0sIHJhbmdlLCBmbHVzaCk7DQo+ICsJaWYgKGlzX3RkcF9tbXVfZW5hYmxlZChrdm0pKSB7DQo+
ICsJCWJvb2wgemFwX3ByaXZhdGU7DQo+ICsNCj4gKwkJaWYgKGt2bV9zbG90X2Nhbl9iZV9wcml2
YXRlKHJhbmdlLT5zbG90KSkgew0KPiArCQkJaWYgKHJhbmdlLT5mbGFncyAmIEtWTV9HRk5fUkFO
R0VfRkxBR1NfUkVTVFJJQ1RFRF9NRU0pDQo+ICsJCQkJLyoNCj4gKwkJCQkgKiBGb3IgcHJpdmF0
ZSBzbG90LCB0aGUgY2FsbGJhY2sgaXMgdHJpZ2dlcmVkDQo+ICsJCQkJICogdmlhIGZhbGxvYy4g
IE1vZGUgY2FuIGJlIGFsbG9jYXRpb24gb3IgcHVuY2gNCgkJCQkgICAgICAgXg0KCQkJCSAgICAg
ICBmYWxsb2NhdGUoKSwgcGxlYXNlPw0KDQo+ICsJCQkJICogaG9sZS4gIEJlY2F1c2UgdGhlIHBy
aXZhdGUtc2hhcmVkIGNvbnZlcnNpb24NCj4gKwkJCQkgKiBpcyBkb25lIHZpYQ0KPiArCQkJCSAq
IEtWTV9NRU1PUllfRU5DUllQVF9SRUcvVU5SRUdfUkVHSU9OLCB3ZSBjYW4NCj4gKwkJCQkgKiBp
Z25vcmUgdGhlIHJlcXVlc3QgZnJvbSByZXN0cmljdGVkbWVtLg0KPiArCQkJCSAqLw0KPiArCQkJ
CXJldHVybiBmbHVzaDsNCg0KU29ycnkgd2h5ICJwcml2YXRlLXNoYXJlZCBjb252ZXJzaW9uIGlz
IGRvbmUgdmlhIEtWTV9NRU1PUllfRU5DUllQVF9SRUciIHJlc3VsdHMNCmluICJ3ZSBjYW4gaWdu
b3JlIHRoZSByZXF1cmVzIGZyb20gcmVzdHJpY3RlZG1lbSI/DQoNCklmIHdlIHB1bmNoIGEgaG9s
ZSwgdGhlIHBhZ2VzIGFyZSBkZS1hbGxvY2F0ZWQsIGNvcnJlY3Q/IA0KDQo+ICsJCQllbHNlIGlm
IChyYW5nZS0+ZmxhZ3MgJiBLVk1fR0ZOX1JBTkdFX0ZMQUdTX1NFVF9NRU1fQVRUUikgew0KPiAr
CQkJCWlmIChyYW5nZS0+YXR0ciA9PSBLVk1fTUVNX0FUVFJfU0hBUkVEKQ0KPiArCQkJCQl6YXBf
cHJpdmF0ZSA9IHRydWU7DQo+ICsJCQkJZWxzZSB7DQo+ICsJCQkJCVdBUk5fT05fT05DRShyYW5n
ZS0+YXR0ciAhPSBLVk1fTUVNX0FUVFJfUFJJVkFURSk7DQo+ICsJCQkJCXphcF9wcml2YXRlID0g
ZmFsc2U7DQo+ICsJCQkJfQ0KPiArCQkJfSBlbHNlDQo+ICsJCQkJLyoNCj4gKwkJCQkgKiBrdm1f
dW5tYXBfZ2ZuX3JhbmdlKCkgaXMgY2FsbGVkIHZpYSBtbXUNCj4gKwkJCQkgKiBub3RpZmllci4g
IEZvciBub3cgcGFnZSBtaWdyYXRpb24gZm9yIHByaXZhdGUNCj4gKwkJCQkgKiBwYWdlIGlzbid0
IHN1cHBvcnRlZCB5ZXQsIGRvbid0IHphcCBwcml2YXRlDQo+ICsJCQkJICogcGFnZXMuDQo+ICsJ
CQkJICovDQo+ICsJCQkJemFwX3ByaXZhdGUgPSBmYWxzZTsNCg0KUGFnZSBtaWdyYXRpb24gaXMg
bm90IHRoZSBvbmx5IHJlYXNvbiB0aGF0IEtWTSB3aWxsIHJlY2VpdmUgdGhlIE1NVSBub3RpZmVy
IC0tDQpqdXN0IHNheSBzb21ldGhpbmcgbGlrZSAiZm9yIG5vdyBhbGwgcHJpdmF0ZSBwYWdlcyBh
cmUgcGlubmVkIGR1cmluZyBWTSdzIGxpZmUgDQp0aW1lIi4NCg0KDQo+ICsJCX0NCj4gKwkJZmx1
c2ggPSBrdm1fdGRwX21tdV91bm1hcF9nZm5fcmFuZ2Uoa3ZtLCByYW5nZSwgZmx1c2gsIHphcF9w
cml2YXRlKTsNCj4gKwl9DQo+ICANCj4gIAlyZXR1cm4gZmx1c2g7DQo+ICB9DQo+IEBAIC02MDY2
LDExICs2MDk2LDQ4IEBAIHN0YXRpYyBib29sIGt2bV9oYXNfemFwcGVkX29ic29sZXRlX3BhZ2Vz
KHN0cnVjdCBrdm0gKmt2bSkNCj4gIAlyZXR1cm4gdW5saWtlbHkoIWxpc3RfZW1wdHlfY2FyZWZ1
bCgma3ZtLT5hcmNoLnphcHBlZF9vYnNvbGV0ZV9wYWdlcykpOw0KPiAgfQ0KPiAgDQo+ICtzdGF0
aWMgdm9pZCBrdm1fbW11X3phcF9tZW1zbG90KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9t
ZW1vcnlfc2xvdCAqc2xvdCkNCj4gK3sNCj4gKwlib29sIGZsdXNoID0gZmFsc2U7DQo+ICsNCj4g
Kwl3cml0ZV9sb2NrKCZrdm0tPm1tdV9sb2NrKTsNCj4gKw0KPiArCS8qDQo+ICsJICogWmFwcGlu
ZyBub24tbGVhZiBTUFRFcywgYS5rLmEuIG5vdC1sYXN0IFNQVEVzLCBpc24ndCByZXF1aXJlZCwg
d29yc3QNCj4gKwkgKiBjYXNlIHNjZW5hcmlvIHdlJ2xsIGhhdmUgdW51c2VkIHNoYWRvdyBwYWdl
cyBseWluZyBhcm91bmQgdW50aWwgdGhleQ0KPiArCSAqIGFyZSByZWN5Y2xlZCBkdWUgdG8gYWdl
IG9yIHdoZW4gdGhlIFZNIGlzIGRlc3Ryb3llZC4NCj4gKwkgKi8NCj4gKwlpZiAoaXNfdGRwX21t
dV9lbmFibGVkKGt2bSkpIHsNCj4gKwkJc3RydWN0IGt2bV9nZm5fcmFuZ2UgcmFuZ2UgPSB7DQo+
ICsJCSAgICAgIC5zbG90ID0gc2xvdCwNCj4gKwkJICAgICAgLnN0YXJ0ID0gc2xvdC0+YmFzZV9n
Zm4sDQo+ICsJCSAgICAgIC5lbmQgPSBzbG90LT5iYXNlX2dmbiArIHNsb3QtPm5wYWdlcywNCj4g
KwkJICAgICAgLm1heV9ibG9jayA9IGZhbHNlLA0KPiArCQl9Ow0KPiArDQo+ICsJCS8qDQo+ICsJ
CSAqIHRoaXMgaGFuZGxlcyBib3RoIHByaXZhdGUgZ2ZuIGFuZCBzaGFyZWQgZ2ZuLg0KPiArCQkg
KiBBbGwgcHJpdmF0ZSBwYWdlIHNob3VsZCBiZSB6YXBwZWQgb24gbWVtc2xvdCBkZWxldGlvbi4N
Cj4gKwkJICovDQo+ICsJCWZsdXNoID0ga3ZtX3RkcF9tbXVfdW5tYXBfZ2ZuX3JhbmdlKGt2bSwg
JnJhbmdlLCBmbHVzaCwgdHJ1ZSk7DQo+ICsJfSBlbHNlIHsNCj4gKwkJZmx1c2ggPSBzbG90X2hh
bmRsZV9sZXZlbChrdm0sIHNsb3QsIF9fa3ZtX3phcF9ybWFwLCBQR19MRVZFTF80SywNCj4gKwkJ
CQkJICBLVk1fTUFYX0hVR0VQQUdFX0xFVkVMLCB0cnVlKTsNCj4gKwl9DQo+ICsJaWYgKGZsdXNo
KQ0KPiArCQlrdm1fZmx1c2hfcmVtb3RlX3RsYnMoa3ZtKTsNCj4gKw0KPiArCXdyaXRlX3VubG9j
aygma3ZtLT5tbXVfbG9jayk7DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyB2b2lkIGt2bV9tbXVfaW52
YWxpZGF0ZV96YXBfcGFnZXNfaW5fbWVtc2xvdChzdHJ1Y3Qga3ZtICprdm0sDQo+ICAJCQlzdHJ1
Y3Qga3ZtX21lbW9yeV9zbG90ICpzbG90LA0KPiAgCQkJc3RydWN0IGt2bV9wYWdlX3RyYWNrX25v
dGlmaWVyX25vZGUgKm5vZGUpDQo+ICB7DQo+IC0Ja3ZtX21tdV96YXBfYWxsX2Zhc3Qoa3ZtKTsN
Cj4gKwlpZiAoa3ZtX2dmbl9zaGFyZWRfbWFzayhrdm0pKQ0KPiArCQlrdm1fbW11X3phcF9tZW1z
bG90KGt2bSwgc2xvdCk7DQo+ICsJZWxzZQ0KPiArCQlrdm1fbW11X3phcF9hbGxfZmFzdChrdm0p
Ow0KPiAgfQ0KDQpBIGNvbW1lbnQgd291bGQgYmUgbmljZSBoZXJlLg0KDQo+ICANCj4gIGludCBr
dm1fbW11X2luaXRfdm0oc3RydWN0IGt2bSAqa3ZtKQ0KPiBAQCAtNjE3Myw4ICs2MjQwLDE4IEBA
IHZvaWQga3ZtX3phcF9nZm5fcmFuZ2Uoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm5fc3RhcnQs
IGdmbl90IGdmbl9lbmQpDQo+ICANCj4gIAlpZiAoaXNfdGRwX21tdV9lbmFibGVkKGt2bSkpIHsN
Cj4gIAkJZm9yIChpID0gMDsgaSA8IEtWTV9BRERSRVNTX1NQQUNFX05VTTsgaSsrKQ0KPiArCQkJ
LyoNCj4gKwkJCSAqIHphcF9wcml2YXRlID0gdHJ1ZS4gWmFwIGJvdGggcHJpdmF0ZS9zaGFyZWQg
cGFnZXMuDQo+ICsJCQkgKg0KPiArCQkJICoga3ZtX3phcF9nZm5fcmFuZ2UoKSBpcyB1c2VkIHdo
ZW4gUEFUIG1lbW9yeSB0eXBlIHdhcw0KDQpJcyBpdCBQQVQgb3IgTVRSUiwgb3IgYm90aCAodGh1
cyBqdXN0IG1lbW9yeSB0eXBlKT8NCg0KPiArCQkJICogY2hhbmdlZC4gIExhdGVyIG9uIHRoZSBu
ZXh0IGt2bSBwYWdlIGZhdWx0LCBwb3B1bGF0ZQ0KPiArCQkJICogaXQgd2l0aCB1cGRhdGVkIHNw
dGUgZW50cnkuDQo+ICsJCQkgKiBCZWNhdXNlIG9ubHkgV0IgaXMgc3VwcG9ydGVkIGZvciBwcml2
YXRlIHBhZ2VzLCBkb24ndA0KPiArCQkJICogY2FyZSBvZiBwcml2YXRlIHBhZ2VzLg0KPiArCQkJ
ICovDQoNClRoZW4gd2h5IGJvdGhlciB6YXBwaW5nIHByaXZhdGU/ICBJZiBJIHJlYWQgY29ycmVj
dGx5LCB0aGUgY2hhbmdlbG9nIHNheXMgImRvbid0DQp6YXAgcHJpdmF0ZSI/DQoNCj4gIAkJCWZs
dXNoID0ga3ZtX3RkcF9tbXVfemFwX2xlYWZzKGt2bSwgaSwgZ2ZuX3N0YXJ0LA0KPiAtCQkJCQkJ
ICAgICAgZ2ZuX2VuZCwgdHJ1ZSwgZmx1c2gpOw0KPiArCQkJCQkJICAgICAgZ2ZuX2VuZCwgdHJ1
ZSwgZmx1c2gsDQo+ICsJCQkJCQkgICAgICB0cnVlKTsNCj4gIAl9DQo+ICANCg0KQnR3LCBhcyB5
b3UgbWVudGlvbmVkIGluIHRoZSBjaGFuZ2Vsb2csIHByaXZhdGUgbWVtb3J5IGFsd2F5cyBoYXMg
V0IgbWVtb3J5DQp0eXBlLCB0aHVzIGNhbm5vdCBiZSB2aXJ0dWFsaXplZC4gIElzIGl0IGJldHRl
ciB0byBtb2RpZnkgdXBkYXRlX210cnIoKSB0byBqdXN0DQpyZXR1cm4gZWFybHkgaWYgdGhlIGdm
biByYW5nZSBpcyBwdXJlbHkgcHJpdmF0ZT8NCg0KSU1ITyB0aGUgaGFuZGxpbmcgb2YgTVRSUi9Q
QVQgdmlydHVhbGl6YXRpb24gZm9yIFREWCBndWVzdCBkZXNlcnZlcyBkZWRpY2F0ZWQNCnBhdGNo
KGVzKSB0byBwdXQgdGhlbSB0b2dldGhlciBzbyBpdCdzIGVhc2llciB0byByZXZpZXcuICBOb3cg
dGhlIHJlbGV2YW50IHBhcnRzDQpzcHJlYWQgaW4gbXVsdGlwbGUgaW5kZXBlbmRlbnQgcGF0Y2hl
cyAoTVNSIGhhbmRsaW5nLCB2dF9nZXRfbXRfbWFzaygpLCBldGMpLg0K
