Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401D46DF18E
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 12:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjDLKFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 06:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjDLKE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 06:04:56 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EDD7ED8;
        Wed, 12 Apr 2023 03:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681293886; x=1712829886;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Zxp4cDHE68PVKLW+BBY70Sa9hFIn5DazSuONTdgglwg=;
  b=BLOTORaiJfGE549iPXruXN/vKvdzGNkDVhRuIu3yGiR2A3C+8rcYww7Y
   k3fjBV9abiO0Fvo5SO9fDXjEcQRleb9L6exyM46YHY+AvaxMc9HSlfAEx
   7ZvvjDniE4VWYr/SzOpCRGZZpJlHGkPMIDAj63op+2Vp7s3AA+cT7sKXt
   PDRSKeFY7eXj6M5cxoWj08NvpnvR9ClIiyQF0AU/KiB0J47QPZ/0IJQVH
   OwmbZWyDd2l/ym6NooIVoCvaVcUDVxVxaJWdngXUKzT8U3hAJCQzOjAgN
   l3A2aAaeBVR0i1CGxPxClIStZdqZ5y4BsCeY7P4fub/uzSpQjMeIMR81D
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="343857758"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="343857758"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 03:04:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="688907540"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="688907540"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 12 Apr 2023 03:04:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 03:04:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 03:04:42 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 03:04:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 03:04:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmOWB9BF03oCU9x9+jCNgqPzazNTuhTsm6KPSRyDV8Y+4rG4ecG/DEK4OfApQzAoSq1ysNDx7fpS38RfyIrkArXFktTFRLlh7sb2WQ6Wc5FeI4uBk61rRxtDf3YrYkL4x6VN2/1QPU8LbXSv5w22oDdwoiMRNl+v/1xqyiHhwNmmxSgJT6o3IZORlPLSrtn2r7Gx9j0BB4/DIblp/+jTQs5m4jm6nqDqnqid+xzBblZ6HiMEHrJU9XSYN/PkLqDvIVOw/TGY++Ol/pRySEOFc9/PqsGwpMhxTKCwOFBn5qjjhrvewU98N17qEENtcmHmbsgZUanXj4zL/fF723ekjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zxp4cDHE68PVKLW+BBY70Sa9hFIn5DazSuONTdgglwg=;
 b=NEk7sxtr9Oobig2MmKTK0Obr19BNiQOFMnimtpmdF7eCFLhedwBVP/eYvH2BNlWkCfBODQrsfr53swdzMMvmwQboJUIPOVVq4XzKhssZ2AZsN8QR/gKaO1w3mOkdFwDgji/d+LV0IcUByZSD7arFc1JGthWUGaeiWxqmJQi5kZARTYKlAxBAP2ezI0Z8SEBNwZOCtDqUuoph7zEz8C7bYMH15WteRo7/b859vrikLeKlHA03Pw53+3jf1FqFRPfxceqCsqVoKrQDC2fSJDcOavI/jk2dBQLNB2qrM6OirvgYefqLC/bB4BpP6aTiBy/pyRbJGshzDNEPyuZAF/0UkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5952.namprd11.prod.outlook.com (2603:10b6:510:147::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.22; Wed, 12 Apr
 2023 10:04:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6277.034; Wed, 12 Apr 2023
 10:04:34 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "eesposit@redhat.com" <eesposit@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pshier@google.com" <pshier@google.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "jthoughton@google.com" <jthoughton@google.com>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "leobras@redhat.com" <leobras@redhat.com>,
        "bgardon@google.com" <bgardon@google.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "amoorthy@google.com" <amoorthy@google.com>,
        "nikunj@amd.com" <nikunj@amd.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "mhal@rbox.co" <mhal@rbox.co>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "mizhang@google.com" <mizhang@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "aghulati@google.com" <aghulati@google.com>,
        "ricarkol@google.com" <ricarkol@google.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "flyingpenghao@gmail.com" <flyingpenghao@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axelrasmussen@google.com" <axelrasmussen@google.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "vipinsh@google.com" <vipinsh@google.com>,
        "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
        "Qiang, Chenyi" <chenyi.qiang@intel.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "aaronlewis@google.com" <aaronlewis@google.com>,
        "Szmigiero, Maciej" <maciej.szmigiero@oracle.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "pdurrant@amazon.com" <pdurrant@amazon.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "yu.c.zhang@linux.intel.com" <yu.c.zhang@linux.intel.com>,
        "junaids@google.com" <junaids@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jiaxi.chen@linux.intel.com" <jiaxi.chen@linux.intel.com>,
        "Li, Rongqing" <lirongqing@baidu.com>,
        "gshan@redhat.com" <gshan@redhat.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "babu.moger@amd.com" <babu.moger@amd.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "houwenlong.hwl@antgroup.com" <houwenlong.hwl@antgroup.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v3 2/2] Documentation/process: Add a maintainer handbook
 for KVM x86
Thread-Topic: [PATCH v3 2/2] Documentation/process: Add a maintainer handbook
 for KVM x86
Thread-Index: AQHZbJl2bam5K5kM1EeDePq3jK7KN68ncyUA
Date:   Wed, 12 Apr 2023 10:04:33 +0000
Message-ID: <4e3706bd9dccc6cd00eab9c59e06b3912b0c8dfe.camel@intel.com>
References: <20230411171651.1067966-1-seanjc@google.com>
         <20230411171651.1067966-3-seanjc@google.com>
In-Reply-To: <20230411171651.1067966-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5952:EE_
x-ms-office365-filtering-correlation-id: 73ff5aa6-6300-4386-73ae-08db3b3d50bc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199021)(66446008)(64756008)(4326008)(76116006)(66476007)(71200400001)(66556008)(66946007)(8676002)(7366002)(7406005)(7416002)(5660300002)(6486002)(8936002)(966005)(26005)(66899021)(316002)(110136005)(6506007)(6512007)(86362001)(54906003)(478600001)(91956017)(41300700001)(2906002)(38070700005)(186003)(2616005)(36756003)(83380400001)(82960400001)(38100700002)(122000001);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA321DF98A44CB4086E7110007E08E31@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73ff5aa6-6300-4386-73ae-08db3b3d50bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 10:04:33.6283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dGsEYKQWrDKTwq1XObIE/d+hYlqINpjeNghmLB2YEReM2bW1DN5BxV8aw3+uJOQevYPbiqNpW41PbqheLRAbYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5952
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA0LTExIGF0IDEwOjE2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiArVGltZWxpbmUNCj4gK35+fn5+fn5+DQo+ICtTdWJtaXNzaW9ucyBhcmUgdHlwaWNh
bGx5IHJldmlld2VkIGFuZCBhcHBsaWVkIGluIEZJRk8gb3JkZXIsIHdpdGggc29tZSB3aWdnbGUN
Cj4gK3Jvb20gZm9yIHRoZSBzaXplIG9mIGEgc2VyaWVzLCBwYXRjaGVzIHRoYXQgYXJlICJjYWNo
ZSBob3QiLCBldGMuwqAgRml4ZXMsDQo+ICtlc3BlY2lhbGx5IGZvciB0aGUgY3VycmVudCByZWxl
YXNlIGFuZCBvciBzdGFibGUgdHJlZXMsIGdldCB0byBqdW1wIHRoZSBxdWV1ZS4NCj4gK1BhdGNo
ZXMgdGhhdCB3aWxsIGJlIHRha2VuIHRocm91Z2ggYSBub24tS1ZNIHRyZWUgKG1vc3Qgb2Z0ZW4g
dGhyb3VnaCB0aGUgdGlwDQo+ICt0cmVlKSBhbmQvb3IgaGF2ZSBvdGhlciBhY2tzL3Jldmlld3Mg
YWxzbyBqdW1wIHRoZSBxdWV1ZSB0byBzb21lIGV4dGVudC4NCj4gKw0KPiArTm90ZSwgdGhlIHZh
c3QgbWFqb3JpdHkgb2YgcmV2aWV3IGlzIGRvbmUgYmV0d2VlbiByYzEgYW5kIHJjNiwgZ2l2ZSBv
ciB0YWtlLg0KPiArVGhlIHBlcmlvZCBiZXR3ZWVuIHJjNiBhbmQgdGhlIG5leHQgcmMxIGlzIHVz
ZWQgdG8gY2F0Y2ggdXAgb24gb3RoZXIgdGFza3MsDQo+ICtpLmUuIHJhZGlvIHNpbGVuY2UgZHVy
aW5nIHRoaXMgcGVyaW9kIGlzbid0IHVudXN1YWwuDQo+ICsNCj4gK1BpbmdzIHRvIGdldCBhIHN0
YXR1cyB1cGRhdGUgYXJlIHdlbGNvbWUsIGJ1dCBrZWVwIGluIG1pbmQgdGhlIHRpbWluZyBvZiB0
aGUNCj4gK2N1cnJlbnQgcmVsZWFzZSBjeWNsZSBhbmQgaGF2ZSByZWFsaXN0aWMgZXhwZWN0YXRp
b25zLsKgIElmIHlvdSBhcmUgcGluZ2luZyBmb3INCj4gK2FjY2VwdGFuY2UsIGkuZS4gbm90IGp1
c3QgZm9yIGZlZWRiYWNrIG9yIGFuIHVwZGF0ZSwgcGxlYXNlIGRvIGV2ZXJ5dGhpbmcgeW91DQo+
ICtjYW4sIHdpdGhpbiByZWFzb24sIHRvIGVuc3VyZSB0aGF0IHlvdXIgcGF0Y2hlcyBhcmUgcmVh
ZHkgdG8gYmUgbWVyZ2VkIcKgIFBpbmdzDQo+ICtvbiBzZXJpZXMgdGhhdCBicmVhayB0aGUgYnVp
bGQgb3IgZmFpbCB0ZXN0cyBsZWFkIHRvIHVuaGFwcHkgbWFpbnRhaW5lcnMhDQo+ICsNCg0KSXQg
c2VlbXMgeW91IGRvbid0IGxpa2UgcmVzZW5kaW5nIHBhdGNoIGFzIGEgcGluZzoNCg0KaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIzMDQxMDAzMTAyMS40MTQ1Mjk3LTEtYWxleGpsemhl
bmdAdGVuY2VudC5jb20vdC8jbWQzMGFhNzdlNWMyNTkyYjViMWZiMDQwMWQxNGU2ZmRiZjUyYzJl
MDYNCg0KRG8geW91IHdhbnQgdG8gaW5jbHVkZSB0aGlzIHRvIHRoZSBkb2N1bWVudGF0aW9uIHRv
bz8NCg==
