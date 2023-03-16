Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10E26BDB50
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 23:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjCPWHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 18:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjCPWHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 18:07:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FEB867E7;
        Thu, 16 Mar 2023 15:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679004452; x=1710540452;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PpIUR2wx6Fn/r6QFaoehxFSW2to7y9/mTSncTvZUZgg=;
  b=AkifIUcazPWAo1nf1RkAbv5jf0YT6ojiIbPHbcjSV7JBbJLy6XU2NdQL
   829wfTOHwooQc5fJN8nr2SsAHpRhow6Yf/JAw/937zLWp0iJItjPAlAW9
   FzqlWFvKqhm0haoedXlriCnkFb5vpKsCPpJRYHDaDZK60FejaLdqNrItX
   gI0xazOxxpFbntC4KnUBwz7c42UmGr7Ofc7JeEgjW342orU6MNmTdXGt/
   VcCHCRi1Vl6GtaOucW042nLovVI9Wz2dnzfYqEUIzakGmEuRrXu7LFUkS
   VDXtsTpngqi3FeDo+JGK/N5pkjc5qlvPUF3v164L5bQK+W9KWWMxWvQhX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="400708747"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="400708747"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 15:07:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="680059647"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="680059647"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2023 15:07:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 15:07:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 15:07:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 15:07:28 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 15:07:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alHMVoK59sd862HVrbr3oZAjvqDidjfIti1M0CgiLAg82tWP/VkzeSSFkxOIkJQb4PznRMVZdtotgu0/2kvnq51X+Xsu0uYQA1MRFS2bCGCfZ+Uuv9IPp38YAM+bDAiYk+c7aTbGcDNm+ky7PUaoM6cj8PT09vQPZF89N3DOHsOU9Ea8GCGpjyRKMBvTplzVOdYwY/pS6ZFOB2fpyjFtdhnf4XmrGtJZdUEExnqXOWNVYXsKldpyNiiQ1uZQVehuWU/kGDKURztkYvGcQr68cs9GqNWshQ3kLyP8DRSK2qcUfoag3z8la9ocr1Pp3uasPBDLXmekxyJfBwEQQAMyrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PpIUR2wx6Fn/r6QFaoehxFSW2to7y9/mTSncTvZUZgg=;
 b=idOnJyn5WQhU+DSgMmqTaW483esfs1M1rQrsbdYn831aIUijDnjatRZ9aEc3RbEuonImM1IlyrpHNJqOeRoRwd4vYd5qWKItZNntYZIg4wNCS8nNgVd5jIc2afNdmLGYTCXNYVgwfaCXWGBjawgW+AAQSt+uboYXNNLfVQda5PTk/0tWr5XAswa2xlw1Cla/0LW0dVCcXV2bpV4lLMw1DGsszU8dk146EnnQ8DBQu/ZeLU6jdFIxRd8sf9+IuhokEGgABMPplq4xIQPh3to/rzHkNkCJhCnv/2e/ADn+DmHcV6ihxrwgPWBJcIE4ynbkWQhiFiBIKfcCrAEa1D0ffA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6318.namprd11.prod.outlook.com (2603:10b6:930:3e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 22:07:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 22:07:24 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZUDU50M/RwoyayES+lzw7MeI2g67xefUAgAZUzQCAAZ2qAIAAIeiAgADqJACAAUSFAIACSfSA
Date:   Thu, 16 Mar 2023 22:07:24 +0000
Message-ID: <7e53ef5d3ad1b519672cddd8e0e8cd2cd6bf0f32.camel@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
         <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
         <20230308222738.GA3419702@ls.amr.corp.intel.com>
         <96b56c5b8a5876aaf6d5ccbb81bab334b10983eb.camel@intel.com>
         <20230313234916.GC3922605@ls.amr.corp.intel.com>
         <a62497059fc3f31706a532b822d6c966bd981468.camel@intel.com>
         <5c4a28c8-f17d-7395-cc63-3cbd9b31befb@intel.com>
         <a02f304ea0e62180e07e2eb63eaf2411b702c672.camel@intel.com>
In-Reply-To: <a02f304ea0e62180e07e2eb63eaf2411b702c672.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6318:EE_
x-ms-office365-filtering-correlation-id: a67102f5-1953-4dfd-b3ed-08db266ad2aa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PZyppkUtO65EYlBcCPSQ78B1FCXEvEyZL8PiE01/hhuz2af7bjzHVCby5MvZoXSu48mqdEiozkxqpucA6I/23H2vS750mE2vMfT5u7HQocwTI4IsEEt7QRLPvYJop+phI1FEv7T4CwRYqcrfP+BpgFh4kimgx65QF/NYjTx4xkN7xNQ3W3/37EIk7z7B9sQTAY9zDhEks7sprvuwhI9scTCBa6xxQPOweZVM43ZIdmEC/yHrV+uw6iL+JanT0XbFWxQzBfpC4VvR/k1mzDAe5l5FmQuH5ycCea5q+AB94eaJn9BwrHSsibmJR9oA3vpMbcqIApYs19MwZ8Jy67/HSqjkx9B6iNnwcQlakkVRIk6Oppmq+OjdirN8u8PumckJ2M0RKh/lbNXaf5bmjLA3lQcDGRwcHIKYutkvwlx5QNQyRjfwoK2c39y+3v5fe89OVX65vGPAuPjCFpQlb857TPGhYw0ofQXZN67x9G23BwXKKSkCMA20SiW245JfHWqrGraIvDyleG4Y/STpzrh8XtuYs+sgo7iKRAAuMIx8vlDUEO1V5z3tyap3D1ZSh+phr1kvlO+LQhFOM71mOLC8IPTvGiNUQ42eUXpGSCxT9Rp3EV9zJgKpM4jSXT+UifyI3TrBwbSPWpePK5T0Wyg7gdBdjznN3YbXlC6sB2CNKI9CX+7Nrt1v8Vz4LkjlLIRyGKIM05x1rL9o9xnFF2t8kA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199018)(8936002)(2616005)(4326008)(2906002)(83380400001)(6506007)(76116006)(66946007)(66476007)(316002)(71200400001)(53546011)(66556008)(6486002)(478600001)(91956017)(38070700005)(6512007)(5660300002)(54906003)(26005)(7416002)(64756008)(41300700001)(8676002)(66446008)(186003)(36756003)(82960400001)(122000001)(110136005)(38100700002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V09OSW5iSnJWdEZIcEZXZW0yeDJKV1UxSFlicEpkRFZ6NGJmRlJUa29ES3Jh?=
 =?utf-8?B?WHYwRWk1K05kOWNLWUp4aTFwMFkvVDk5YkpkZy9EUHZYSm5vRWpvV254dFFC?=
 =?utf-8?B?SlpwZVlTUmVTbW9qR2hZaXVHell2dEsyL0NGM3ZxL3JlZnlvNUVVYkNBdXpi?=
 =?utf-8?B?MEJNVXY2VU5jWXQwZnJJZTFZL3lFVCtDeFFqN1FYSTFFK3lobEZvd1d5M1Uz?=
 =?utf-8?B?RzVjdU9TekFnYTNJUGhoY2h0Q21TcUVhRnFNTDV5b3Jpd1J0QWpYTVFSK0F3?=
 =?utf-8?B?STVGbGUzaEhOZTFkbHI0RW85Y1pSTStpRmxKQ2NqOEtzeFJQOUlNY0lLQktk?=
 =?utf-8?B?SjhqM2FoQWYxZWRuRlhoakw3NmxnUkdKSzhmVk1wTjExcDJFVmlqRHl4N3Q0?=
 =?utf-8?B?YytKb2t5S0ljMlVVU3k5ZDM3djB5a3ZxYUlvMVc5dENmN2NQVXFpZWtmYW8w?=
 =?utf-8?B?NDBZTXRxaitOc0k4OTVQUlJxTzJkTVA4dTk3Y0g3L0c2VWlqb0pvVjI2TzM3?=
 =?utf-8?B?cFdwQllWMVh0MWZFdmNLdktqYnJvRDl5SW1ucTZmY0s4Uzl2bXJKUmFUQ1hy?=
 =?utf-8?B?bGg1WUFjTGdiYndCSXZaMnQwUUZLRTB2ZE1jbnRvbVMybUo4eFQwVnFOVjlW?=
 =?utf-8?B?ejRYRTVORUtYckh2allwb21hSVVsZUpHNWtldUdwUldha3B1VkNvaWQ0cHU0?=
 =?utf-8?B?SklSaUZ1TFY4U3FxK0REY2NGSHN3ZW42RXZtRjdQNDE1TmZ5Y1RDdklLMkFh?=
 =?utf-8?B?VlVkMmdZZTJkNWhnSTlpSFhPQUlPTEFnVW40TXh4T0krZWVCeTVXR1RUSi9m?=
 =?utf-8?B?TUlSZU1zYVFBL0Nsakxxa1FVV0ZPbFRwSG9xeWxBOWp1WVdGUS9LUkRRc1I3?=
 =?utf-8?B?ejhsMzd3emRNWkpORHY5aWFLWWZ0bU5ieXFweEU0VUN5SFNnUjJKVTIybndv?=
 =?utf-8?B?eDhCWFlwZ0d2SHd3cEFMVUNVaXlRcm16U0F1ZEFrY1MxR2JUMEt4RWY2Szhl?=
 =?utf-8?B?OCtKQVpLSldGUS85SmE3NUNxd0ltcEwvdm5jUXR2K0htaEtxdExPUUNjUU42?=
 =?utf-8?B?ZzRLc1FNWXh1RGtxNXI0a2JuNEl6YXFqMHFmck54TnJJU250RzdTc2x1dytR?=
 =?utf-8?B?ckVxdFhGV3RjMklMVkdKYnhjZXlzUGwreFBIVjdSOEZXUlhhSlMydHNWTkc0?=
 =?utf-8?B?eS8wNDlXd0dnZjdKOVBpWTB1RFZvR2NybXhxMEE2dmRhK3BEckRFVThSdklo?=
 =?utf-8?B?b0xvcmJVYVQ1blVwaEs5SHZxSXNaZ2d4eTU0QVFLVXFvcjY5WWZHTzNBTnZT?=
 =?utf-8?B?MzdjQzJMVDI5WHVnTzVDZXV0dkRJYUJ0UW00OHkxZEZHWDdyVnYrRldtbHdN?=
 =?utf-8?B?aE1ucG41UU03KytEdlFpWnloVU9hT05xalNteWs1WXh5Rk1TbktUMnNJa0V0?=
 =?utf-8?B?UDU2aXlWU3dBTEphSDJPQ1pHcE1ydVlVcGRZZE1QY25xeGZlSXIrL1hlV1E1?=
 =?utf-8?B?WUNHWXc0bWJ4QUhxblpQT0Z6MzdlbE9QZ2Q2WVFTd2tNSS85MlBCSEc3bERR?=
 =?utf-8?B?dWt4alMvaUV6TE81UktkOVB4VjlSMGI5YXpKQWxMN0lLaUI0QVJBUmNZbVJN?=
 =?utf-8?B?elo0RTFJZnJUVlZmQmllSXlFTHlTVHI4M3ZrckVzQ1pXc1FSKzE0L1JMNFE0?=
 =?utf-8?B?NkUyS2FNVVFNVE1hVSs2ZnhKMmVaWXl6TW1HVWZvVURGS2VIYWI4bUtGNkp6?=
 =?utf-8?B?OHBYY0RaN25tOURXTlNRRXBCdHRrazZjclBiZ0h2R1d1UlBrdVlkSld5dzc3?=
 =?utf-8?B?Rlh4cWVvMW1CaGV2SDJoUy84aG9kUGpBSFowRUE2TlV4c0kvWDRodzlaT01D?=
 =?utf-8?B?UXV0RXVyd1VDMERLVHFDKytXRVJSWXRPN1FzYVR6NG5jMkZoOTNLbWZ1dzVX?=
 =?utf-8?B?MkdQOFJZbGNRRUkvYW9mUW1iYUEyQTVwd2phTDRhU2oxeEoxOEVrTWx3OEdI?=
 =?utf-8?B?V20xN2FNUHRNK1JzbVliQUlqYW5QRDZ6dEE3c2R1OGdXR0FwZ2VaMFZScFV5?=
 =?utf-8?B?VHE4S1pncXg0dUU4ekVtNzJBZFBjQ0t2ZlJFWk81R3pzMFhkN08xd1QrTEVB?=
 =?utf-8?B?NnhmRXNjb0JWbHh2OFRYNnQ0RGxia0lidTNIaGoxUHFyOUxzUGFOMW5BeUZP?=
 =?utf-8?B?ZHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BCA6DC7FFE4107499FC23F619EC08E9C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a67102f5-1953-4dfd-b3ed-08db266ad2aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 22:07:24.5223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SEtNE1EX9nFzoTYNlP/4gtDlpIjzkmlEp2X9/s2jUgkAo8RSOzsSZZhD275IQuUIT0Qm3p3v3jS4eft7RuIJCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6318
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTAzLTE1IGF0IDExOjEwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUdWUsIDIwMjMtMDMtMTQgYXQgMDg6NDggLTA3MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+
IE9uIDMvMTMvMjMgMTg6NTAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiBPbiBNb24sIDIwMjMt
MDMtMTMgYXQgMTY6NDkgLTA3MDAsIElzYWt1IFlhbWFoYXRhIHdyb3RlOg0KPiA+ID4gPiBPbiBT
dW4sIE1hciAxMiwgMjAyMyBhdCAxMTowODo0NFBNICswMDAwLA0KPiA+ID4gPiAiSHVhbmcsIEth
aSIgPGthaS5odWFuZ0BpbnRlbC5jb20+IHdyb3RlOg0KPiA+ID4gPiANCj4gPiA+ID4gPiBPbiBX
ZWQsIDIwMjMtMDMtMDggYXQgMTQ6MjcgLTA4MDAsIElzYWt1IFlhbWFoYXRhIHdyb3RlOg0KPiA+
ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiA+ICtzdGF0aWMgaW50IHRyeV9pbml0X21vZHVsZV9n
bG9iYWwodm9pZCkNCj4gPiA+ID4gPiA+ID4gK3sNCj4gPiA+ID4gPiA+ID4gKyAgICAgICBpbnQg
cmV0Ow0KPiA+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiA+ICsgICAgICAgLyoNCj4gPiA+ID4g
PiA+ID4gKyAgICAgICAgKiBUaGUgVERYIG1vZHVsZSBnbG9iYWwgaW5pdGlhbGl6YXRpb24gb25s
eSBuZWVkcyB0byBiZSBkb25lDQo+ID4gPiA+ID4gPiA+ICsgICAgICAgICogb25jZSBvbiBhbnkg
Y3B1Lg0KPiA+ID4gPiA+ID4gPiArICAgICAgICAqLw0KPiA+ID4gPiA+ID4gPiArICAgICAgIHNw
aW5fbG9jaygmdGR4X2dsb2JhbF9pbml0X2xvY2spOw0KPiA+ID4gPiA+ID4gPiArDQo+ID4gPiA+
ID4gPiA+ICsgICAgICAgaWYgKHRkeF9nbG9iYWxfaW5pdF9zdGF0dXMgJiBURFhfR0xPQkFMX0lO
SVRfRE9ORSkgew0KPiA+ID4gPiA+ID4gPiArICAgICAgICAgICAgICAgcmV0ID0gdGR4X2dsb2Jh
bF9pbml0X3N0YXR1cyAmIFREWF9HTE9CQUxfSU5JVF9GQUlMRUQgPw0KPiA+ID4gPiA+ID4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICAtRUlOVkFMIDogMDsNCj4gPiA+ID4gPiA+ID4gKyAgICAg
ICAgICAgICAgIGdvdG8gb3V0Ow0KPiA+ID4gPiA+ID4gPiArICAgICAgIH0NCj4gPiA+ID4gPiA+
ID4gKw0KPiA+ID4gPiA+ID4gPiArICAgICAgIC8qIEFsbCAnMCdzIGFyZSBqdXN0IHVudXNlZCBw
YXJhbWV0ZXJzLiAqLw0KPiA+ID4gPiA+ID4gPiArICAgICAgIHJldCA9IHNlYW1jYWxsKFRESF9T
WVNfSU5JVCwgMCwgMCwgMCwgMCwgTlVMTCwgTlVMTCk7DQo+ID4gPiA+ID4gPiA+ICsNCj4gPiA+
ID4gPiA+ID4gKyAgICAgICB0ZHhfZ2xvYmFsX2luaXRfc3RhdHVzID0gVERYX0dMT0JBTF9JTklU
X0RPTkU7DQo+ID4gPiA+ID4gPiA+ICsgICAgICAgaWYgKHJldCkNCj4gPiA+ID4gPiA+ID4gKyAg
ICAgICAgICAgICAgIHRkeF9nbG9iYWxfaW5pdF9zdGF0dXMgfD0gVERYX0dMT0JBTF9JTklUX0ZB
SUxFRDsNCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gSWYgZW50cm9weSBpcyBsYWNraW5nIChy
ZHJhbmQgZmFpbHVyZSksIFRESF9TWVNfSU5JVCBjYW4gcmV0dXJuIFREWF9TWVNfQlVTWS4NCj4g
PiA+ID4gPiA+IEluIHN1Y2ggY2FzZSwgd2Ugc2hvdWxkIGFsbG93IHRoZSBjYWxsZXIgdG8gcmV0
cnkgb3IgbWFrZSB0aGlzIGZ1bmN0aW9uIHJldHJ5DQo+ID4gPiA+ID4gPiBpbnN0ZWFkIG9mIG1h
cmtpbmcgZXJyb3Igc3RpY2tpbHkuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gVGhlIHNwZWMgc2F5
czoNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBURFhfU1lTX0JVU1kgICAgICAgIFRoZSBvcGVyYXRp
b24gd2FzIGludm9rZWQgd2hlbiBhbm90aGVyIFREWCBtb2R1bGUNCj4gPiA+ID4gPiAgICAgICAg
ICAgICBvcGVyYXRpb24gd2FzIGluIHByb2dyZXNzLiBUaGUgb3BlcmF0aW9uIG1heSBiZSByZXRy
aWVkLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFNvIEkgZG9uJ3Qgc2VlIGhvdyBlbnRyb3B5IGlz
IGxhY2tpbmcgaXMgcmVsYXRlZCB0byB0aGlzIGVycm9yLiAgUGVyaGFwcyB5b3UNCj4gPiA+ID4g
PiB3ZXJlIG1peGluZyB1cCB3aXRoIEtFWS5DT05GSUc/DQo+ID4gPiA+IA0KPiA+ID4gPiBUREgu
U1lTLklOSVQoKSBpbml0aWFsaXplcyBnbG9iYWwgY2FuYXJ5IHZhbHVlLiAgVERYIG1vZHVsZSBp
cyBjb21waWxlZCB3aXRoDQo+ID4gPiA+IHN0cm9uZyBzdGFjayBwcm90ZWN0b3IgZW5hYmxlZCBi
eSBjbGFuZyBhbmQgY2FuYXJ5IHZhbHVlIG5lZWRzIHRvIGJlDQo+ID4gPiA+IGluaXRpYWxpemVk
LiAgQnkgZGVmYXVsdCwgdGhlIGNhbmFyeSB2YWx1ZSBpcyBzdG9yZWQgYXQNCj4gPiA+ID4gJWZz
YmFzZTo8U1RBQ0tfQ0FOQVJZX09GRlNFVCAweDI4Pg0KPiA+ID4gPiANCj4gPiA+ID4gQWx0aG91
Z2ggdGhpcyBpcyBhIGpvYiBmb3IgbGliYyBvciBsYW5ndWFnZSBydW50aW1lLCBURFggbW9kdWxl
cyBoYXMgdG8gZG8gaXQNCj4gPiA+ID4gaXRzZWxmIGJlY2F1c2UgaXQncyBzdGFuZCBhbG9uZS4N
Cj4gPiA+ID4gDQo+ID4gPiA+IEZyb20gdGRoX3N5c19pbml0LmMNCj4gPiA+ID4gX1NUQVRJQ19J
TkxJTkVfIGFwaV9lcnJvcl90eXBlIHRkeF9pbml0X3N0YWNrX2NhbmFyeSh2b2lkKQ0KPiA+ID4g
PiB7DQo+ID4gPiA+ICAgICBpYTMyX3JmbGFnc190IHJmbGFncyA9IHsucmF3ID0gMH07DQo+ID4g
PiA+ICAgICB1aW50NjRfdCBjYW5hcnk7DQo+ID4gPiA+ICAgICBpZiAoIWlhMzJfcmRyYW5kKCZy
ZmxhZ3MsICZjYW5hcnkpKQ0KPiA+ID4gPiAgICAgew0KPiA+ID4gPiAgICAgICAgIHJldHVybiBU
RFhfU1lTX0JVU1k7DQo+ID4gPiA+ICAgICB9DQo+ID4gPiA+IC4uLg0KPiA+ID4gPiAgICAgbGFz
dF9wYWdlX3B0ci0+c3RhY2tfY2FuYXJ5LmNhbmFyeSA9IGNhbmFyeTsNCj4gPiA+ID4gDQo+ID4g
PiA+IA0KPiA+ID4gDQo+ID4gPiBUaGVuIGl0IGlzIGEgaGlkZGVuIGJlaGF2aW91ciBvZiB0aGUg
VERYIG1vZHVsZSB0aGF0IGlzIG5vdCByZWZsZWN0ZWQgaW4gdGhlDQo+ID4gPiBzcGVjLg0KPiA+
IA0KPiA+IFRoaXMgaXMgdHJ1ZS4gIENvdWxkIHlvdSBwbGVhc2UgZ28gYXNrIHRoZSBURFggbW9k
dWxlIGZvbGtzIHRvIGZpeCB0aGlzIHVwPw0KPiANCj4gU3VyZSB3aWxsIGRvLg0KPiANCj4gVG8g
bWFrZSBzdXJlLCB5b3UgbWVhbiB3ZSBzaG91bGQgYXNrIFREWCBtb2R1bGUgZ3V5cyB0byBhZGQg
dGhlIG5ldw0KPiBURFhfUk5EX05PX0VOVFJPUFkgZXJyb3IgY29kZSB0byBURFggbW9kdWxlIDEu
MD8NCj4gDQo+ICJhbm90aGVyIFREWCBtb2R1bGUgb3BlcmF0aW9uIHdhcyBpbiBwcm9ncmVzcyIg
YW5kICJydW5uaW5nIG91dCBvZiBlbnRyb3B5IiBhcmUNCj4gZGlmZmVyZW50IHRoaW5nIGFuZCBz
aG91bGQgbm90IGJlIG1peGVkIHRvZ2V0aGVyIElNSE8uDQo+IA0KPiA+IA0KPiA+ID4gSSBhbSBu
b3Qgc3VyZSB3aGV0aGVyIHdlIHNob3VsZCBoYW5kbGUgYmVjYXVzZToNCj4gPiA+IA0KPiA+ID4g
MSkgVGhpcyBpcyBhbiBleHRyZW1lbHkgcmFyZSBjYXNlLiAgS2VybmVsIHdvdWxkIGJlIGJhc2lj
YWxseSB1bmRlciBhdHRhY2sgaWYNCj4gPiA+IHN1Y2ggZXJyb3IgaGFwcGVuZWQuICBJbiB0aGUg
Y3VycmVudCBzZXJpZXMgd2UgZG9uJ3QgaGFuZGxlIHN1Y2ggY2FzZSBpbg0KPiA+ID4gS0VZLkNP
TkZJRyBlaXRoZXIgYnV0IGp1c3QgbGVhdmUgYSBjb21tZW50IChzZWUgcGF0Y2ggMTMpLg0KPiA+
IA0KPiA+IFJhcmUsIHllcy4gIFVuZGVyIGF0dGFjaz8gIEknbSBub3Qgc3VyZSB3aGVyZSB5b3Ug
Z2V0IHRoYXQgZnJvbS4gIExvb2sNCj4gPiBhdCB0aGUgU0RNOg0KPiA+IA0KPiA+ID4gVW5kZXIg
aGVhdnkgbG9hZCwgd2l0aCBtdWx0aXBsZSBjb3JlcyBleGVjdXRpbmcgUkRSQU5EIGluIHBhcmFs
bGVsLCBpdCBpcyBwb3NzaWJsZSwgdGhvdWdoIHVubGlrZWx5LCBmb3IgdGhlIGRlbWFuZA0KPiA+
ID4gb2YgcmFuZG9tIG51bWJlcnMgYnkgc29mdHdhcmUgcHJvY2Vzc2VzL3RocmVhZHMgdG8gZXhj
ZWVkIHRoZSByYXRlIGF0IHdoaWNoIHRoZSByYW5kb20gbnVtYmVyIGdlbmVyYXRvcg0KPiA+ID4g
aGFyZHdhcmUgY2FuIHN1cHBseSB0aGVtLiBUaGlzIHdpbGwgbGVhZCB0byB0aGUgUkRSQU5EIGlu
c3RydWN0aW9uIHJldHVybmluZyBubyBkYXRhIHRyYW5zaXRvcmlseS4gVGhlIFJEUkFORA0KPiA+
ID4gaW5zdHJ1Y3Rpb24gaW5kaWNhdGVzIHRoZSBvY2N1cnJlbmNlIG9mIHRoaXMgcmFyZSBzaXR1
YXRpb24gYnkgY2xlYXJpbmcgdGhlIENGIGZsYWcuDQo+ID4gDQo+ID4gVGhhdCBkb2Vzbid0IHRh
bGsgYWJvdXQgYXR0YWNrcy4NCj4gDQo+IFRoYW5rcyBmb3IgY2l0aW5nIHRoZSBkb2N1bWVudGF0
aW9uLiAgSSBjaGVja2VkIHRoZSBrZXJuZWwgY29kZSBiZWZvcmUgYW5kIGl0DQo+IHNlZW1zIGN1
cnJlbnRseSB0aGVyZSdzIG5vIGNvZGUgdG8gY2FsbCBSRFJBTkQgdmVyeSBmcmVxdWVudGx5LiAg
QnV0IHllcyB3ZQ0KPiBzaG91bGQgbm90IHNheSAidW5kZXIgYXR0YWNrIi4gIEkgaGF2ZSBzb21l
IG9sZCBtZW1vcnkgdGhhdCBzb21lb25lIHNhaWQgc28NCj4gKG1heWJlIG1lPykuDQo+IA0KPiA+
IA0KPiA+ID4gMikgTm90IHN1cmUgd2hldGhlciB0aGlzIHdpbGwgYmUgY2hhbmdlZCBpbiB0aGUg
ZnV0dXJlLg0KPiA+ID4gDQo+ID4gPiBTbyBJIHRoaW5rIHdlIHNob3VsZCBrZWVwIGFzIGlzLg0K
PiA+IA0KPiA+IFREWF9TWVNfQlVTWSByZWFsbHkgaXMgbWlzc2luZyBzb21lIG51YW5jZS4gIFlv
dSAqUkVBTExZKiB3YW50IHRvIHJldHJ5DQo+ID4gUkRSQU5EIGZhaWx1cmVzLiDCoA0KPiA+IA0K
PiANCj4gT0suICBBZ3JlZWQuICBUaGVuIEkgdGhpbmsgdGhlIFRESC5TWVMuS0VZLkNPTkZJRyBz
aG91bGQgcmV0cnkgd2hlbiBydW5uaW5nIG91dA0KPiBvZiBlbnRyb3B5IHRvby4NCj4gDQo+ID4g
QnV0LCBpZiB5b3UgaGF2ZSBWTU0gbG9ja2luZyBhbmQgZG9uJ3QgZXhwZWN0IHR3bw0KPiA+IHVz
ZXJzIGNhbGxpbmcgaW50byB0aGUgVERYIG1vZHVsZSB0aGVuIFREWF9TWVNfQlVTWSBmcm9tIGEg
YnVzeSAqbW9kdWxlKg0KPiA+IGlzIGEgYmFkIChhbmQgcHJvYmFibHkgZmF0YWwpIHNpZ25hbC4N
Cj4gDQo+IFllcyB3ZSBoYXZlIGEgbG9jayB0byBwcm90ZWN0IFRESC5TWVMuSU5JVCBmcm9tIGJl
aW5nIGNhbGxlZCBpbiBwYXJhbGxlbC4gIFcvbw0KPiB0aGlzIGVudHJvcHkgdGhpbmcgVERYX1NZ
U19CVVNZIHNob3VsZCBuZXZlciBoYXBwZW4uDQo+IA0KPiA+IA0KPiA+IEkgc3VzcGVjdCB3ZSBz
aG91bGQganVzdCB0aHJvdyBhIGZldyByZXRyaWVzIGluIHRoZSBzZWFtY2FsbCgpDQo+ID4gaW5m
cmFzdHJ1Y3R1cmUgdG8gcmV0cnkgaW4gdGhlIGNhc2Ugb2YgVERYX1NZU19CVVNZLiAgSXQnbGwg
dGFrZSBjYXJlIG9mDQo+ID4gUkRSQU5EIGZhaWx1cmVzLiAgSWYgYSByZXRyeSBsb29wIGZhaWxz
IHRvIHJlc29sdmUgaXQsIHRoZW4gd2Ugc2hvdWxkDQo+ID4gcHJvYmFibHkgZHVtcCBhIHdhcm5p
bmcgYW5kIHJldHVybiBhbiBlcnJvci4NCj4gPiANCj4gPiBKdXN0IGRvIHRoaXMgb25jZSwgaW4g
Y29tbW9uIGNvZGUuDQo+IA0KPiBJIGNhbiBkby4gIEp1c3Qgd2FudCB0byBtYWtlIHN1cmUgZG8g
eW91IHdhbnQgdG8gcmV0cnkgVERYX1NZU19CVVNZLCBvciByZXRyeQ0KPiBURFhfUk5EX05PX0VO
VFJPUFkgKGlmIHdlIHdhbnQgdG8gYXNrIFREWCBtb2R1bGUgZ3V5cyB0byBjaGFuZ2UgdG8gcmV0
dXJuIHRoaXMNCj4gdmFsdWUpPw0KPiANCj4gQWxzbywgZXZlbiB3ZSByZXRyeSBlaXRoZXIgVERY
X1NZU19CVVNZIG9yIFREWF9STkRfTk9fRU5UUk9QWSBpbiBjb21tb24gDQo+IHNlYW1jYWxsKCkg
Y29kZSwgaXQgZG9lc24ndCBoYW5kbGUgdGhlIFRESC5TWVMuS0VZLkNPTkZJRywgYmVjYXVzZSBz
YWRseSB0aGlzDQo+IFNFQU1DQUxMIHJldHVybnMgYSBkaWZmZXJlbnQgZXJyb3IgY29kZToNCj4g
DQo+IFREWF9LRVlfR0VORVJBVElPTl9GQUlMRUQJRmFpbGVkIHRvIGdlbmVyYXRlIGEgcmFuZG9t
IGtleS4gVGhpcyBpc8KgDQo+IAkJCQl0eXBpY2FsbHkgY2F1c2VkIGJ5IGFuIGVudHJvcHkgZXJy
b3Igb2YgdGhlDQo+IAkJCQlDUFUncyByYW5kb20gbnVtYmVyIGdlbmVyYXRvciwgYW5kIG1heQ0K
PiAJCQkJYmUgaW1wYWN0ZWQgYnkgUkRTRUVELCBSRFJBTkQgb3IgUENPTkZJRw0KPiAJCQkJZXhl
Y3V0aW5nIG9uIG90aGVyIExQcy4gVGhlIG9wZXJhdGlvbiBzaG91bGQgYmUNCj4gCQkJCXJldHJp
ZWQuDQo+IA0KDQpIaSBEYXZlLA0KDQpTb3JyeSB0byBwaW5nLiAgQ291bGQgeW91IGhlbHAgdG8g
Y2hlY2sgd2hldGhlciBteSB1bmRlcnN0YW5kaW5nIGlzIGFsaWduZWQgd2l0aA0Kd2hhdCB5b3Ug
c3VnZ2VzdGVkPw0K
