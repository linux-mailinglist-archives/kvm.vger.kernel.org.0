Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EED5674732
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjASX0V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjASX0U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:26:20 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB171F5F4;
        Thu, 19 Jan 2023 15:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674170773; x=1705706773;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yg4l9lZy4ke2GAizXM2eNoFmdclQm1lsr3FvOufMdVE=;
  b=CyaxpX675ehirrqPN9fD6nTFljFjBYbn7rXgjmwc5gMaRmHhC0wINsPJ
   nd04k/LFLTu4COoeT61ayrwzCe2fVOpZcaI/0HwlE9u4vTW8p76MdkgYw
   S1qfVydEBwvO+mITYK0HsFXT4fLsCfX67w2ZvIj+vH7IekGCeRUtp7OMx
   SiHs3nznFUxHPZrXK8EU7ZfO4MuRmv0qtD7syZ+KqHohqc1d4BMRVGF8g
   ttPe+PrsZgxt1t6wd+TSExfUdrel13HteSMeeDB9DXcM4tbEwnDStlv3d
   jtkazNtMTtOpQssrhdY2Gy/j1MBZPvJdEWxHnViqh56Jf5q1x4fbk63Ws
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="326737516"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="326737516"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 15:25:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="768441422"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="768441422"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jan 2023 15:25:36 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 15:25:35 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 15:25:35 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 15:25:35 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 15:25:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTnvxZfSOoDzB2SCul3Jgl6TgK5sjJqApq6wu1ewBKrqBQDbPbAf7/EUfB2d1h/IIFCj0qyfLYS6r+HzNIXkXHhpq+qMdkCHwrldwBmNOY9RRTGe8VYx5GFIXstpbUIclOjPzULxIS8SGs6dloIkOxbl3nHHM5os9+Jw3v/Mr2qsFjxzRs0xtwVFBltIJ9rM4J4jTDZRU4PqPUA7B6xAbySms0+Yw4yzmxqmtiC2GRM++O6u6yF0DuA8GLiltyBMRAwo7CB33mNUiEY+F2+bkbDHRyjRxiN1rjeIIpeC6xX7/jxnJTp7T4MvWggVGrEymIbaRpWM01nSSIk5ePGD4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yg4l9lZy4ke2GAizXM2eNoFmdclQm1lsr3FvOufMdVE=;
 b=LvcIVsNcIv8bzG+Io62JHu+P7txCMTzkZQUMYpaZO35E9cjNc2qBoFifGKq1bZ6lPxSVgcG4zXQOzUWkWTvt7YF/qANharNMIv1neRuEZ8fu8RxJlbFzflRURxs6h1zfwAYqUUYsx57vwNCoFlEts5DaZOOsv7aYuoroR9IIWEzn3LF7qXF72XyuRGA8P+EfmhL+EnsZKq8PaAtyVD3nwVUlrN30V3gbAl6r+h59Q3aCuxq9Ca5cOU1zh2PLASffN8p0ZvtwzUFq37K5L4KRHudm+kZzyeixVEgzDgiRYu9k9WZcpptpi45j+yP/ExNDeDfqouWIfyzHDsGLiiwOMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB8174.namprd11.prod.outlook.com (2603:10b6:208:450::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 23:25:31 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 23:25:31 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Index: AQHZJqOgR/AYJ+DUHUGfsmh5dZfuuq6cVDsAgAAiagCAAS3PgIAFJp+AgAA/zQCAABQhgIAAAWcAgAKFUoCAAETpAIAAVHGAgAAP1gCAABm5AIAAAM8AgAADfwCAAABoAA==
Date:   Thu, 19 Jan 2023 23:25:31 +0000
Message-ID: <ff4547e53d90c626a0deb8339e257590369bfe70.camel@intel.com>
References: <20230114111621.00001840@gmail.com>
          <Y8bFCb+rs25dKcMY@google.com> <20230117214414.00003229@gmail.com>
             <Y8cLcY12zDWqO8nd@google.com> <Y8cMnjHFNIFaoX27@google.com>
         <eadc4a4e37ea0b04b8348395244b792bd34a762d.camel@intel.com>
         <Y8ljwsrrBBdh1aYw@google.com>
         <02b0e551647beed9ec3a2fefd3b659eb52c4846c.camel@intel.com>
         <Y8m34OEVBfL7Q4Ns@google.com>
         <38f506575caacd5488f73315b231c3282f893d46.camel@intel.com>
         <Y8nOIjkskcXAi00V@google.com>
         <6ad5de218ba9be52d63ebb5846ad6b2d1aa3eab8.camel@intel.com>
In-Reply-To: <6ad5de218ba9be52d63ebb5846ad6b2d1aa3eab8.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB8174:EE_
x-ms-office365-filtering-correlation-id: 199e2c33-2614-4e24-1dcb-08dafa747516
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iO2yOgh/8kVZQMYk4U5mzH5dSLtPK/HyrBwI+IilqJDEHTgJbsujRo4ZIbkQRkI4m9lkMTKRohCcxppDOHpmf4gJsq4WICym8nkebg8Rkyr6p2/UeJRnQzFtCKEtKNz3JJTNjsC7/BgvmEnnTjF4UexirGvzmWvEDqzPDRYgPmPrw29ogNv22lFRTR3Ms6sAzq08ruXIIRY+xZeHUc8tl4ASoczpeaOEchsH89iBfghW3WPW1QiqYD4mcBd+DFESdlw/mGjyAdWDptU3BtApiT0xTZioHehFtBSQ1sWHRMH0Aot+y9iSLsISfLUz61W69oF8CTLfV2TO26SXuGEaPJAAIXOveN1y7armOQ/DvI5ukY9XyHQZC+DGJ8l7BtBk9/vBiBlDboGrefD8wr+0yv4NIeh/CBDHeuv0EDja/O4n1D7hrzbkaEmO5gthAaoaEwwK1r1lIcgvBfcOnh8vi/yAiRsRLmPHF4hMaQZUTE3oDWgN2mV1q9ihrT+IJ5USAtbr8lRm7RGEC1CWSG269pebIJMNV7DUYkhMXEYXUElXOLAfPgDiq6nFCybZUrLIVtkXW9+T7t1xfj93K8dRpJtj4U+0vb86nI0QLNRBDsHKY1OS3dd+82On/u/MGRf9iVW72k9arCEKv0y3wgyrMsaks8VEMkMTzolBJQO2GZjkMelGsP1jK2aAkrPHhka0Yfdi+PyxlZsHkI0TlEkTKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199015)(6486002)(478600001)(86362001)(66556008)(122000001)(66946007)(2906002)(91956017)(8936002)(5660300002)(66476007)(82960400001)(76116006)(38100700002)(316002)(54906003)(107886003)(71200400001)(38070700005)(6506007)(36756003)(26005)(64756008)(8676002)(4326008)(66446008)(41300700001)(6916009)(2616005)(186003)(6512007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1hnMkVKNzJyUkVONUZkWkprRC9jRVlmM1N0cGZWZjBPQ204STlsL05IVnlt?=
 =?utf-8?B?Y1lDUmNsSFBRUFQzMUd4ZUJIU0hkN0NJWVVCYk1NMDM5MjJJbUdkWkNBbU52?=
 =?utf-8?B?THFCOHFSZXVrM3RJUXN6TitNMFhHOWF0MjhKeU02NlVFRFprQ09DYzhoNlNG?=
 =?utf-8?B?RVNzMyttMFpxRnY2alhkTTFtSGIwRWxRbjF5Z3hKcFlmQmZRNkxKTHN0alJW?=
 =?utf-8?B?K3JHTnRYaTJQblFnaGpaek85T0lsZjk1RDF5WkVmdmUxOVhnQkhuWUxMRHZx?=
 =?utf-8?B?ekt5ZGN5M3dkbDZuT3VKTjhUVjRwdzBiMllQMmNwNzR4bERNNmNrUWpTczk5?=
 =?utf-8?B?UEV3R1hqSWFwbHBOR0NaNEg1TzRUOE1CZldGcS9TZklRS1hxUUJWSFhSUGk5?=
 =?utf-8?B?ZE9qaUdkUkFvVi9oc1k0dXJMblgralU0VkhPMzNRRHlpYnNyZnUramoxc0Ny?=
 =?utf-8?B?bjZkL1Nnb05ISVA1NlVpOUIvNENxTGZIZEV6WXR0d3l1bTdHbnIvQUxiMFNs?=
 =?utf-8?B?UGc2S2lZNXF2ZnFqT0plMldacklwRzZFaHhRdDZJSCtPKzZ4U00vTXMzMFVn?=
 =?utf-8?B?T0thK2picGlyb2grT2ZBMjFKUDFuTXhINXQ2aUs5SjExZEdObXMrcGNpWU1W?=
 =?utf-8?B?MCtaSUNKaEErV1Y5MldIUFpwZjhTRnNQNk81cnR6S3lTdUpkUHl6a2xsWmR1?=
 =?utf-8?B?c1hubWlTQ0F4MHo2WWQrNnpkVWJuR1dDVEhtd0pPcTV6Q2o2UlhsQ0FndkVQ?=
 =?utf-8?B?ajVKZ2hHUHRmRlhMb081b2Z4S05HbHMxWjlXWXpnS0IwaEVjOWp5TWNScGVh?=
 =?utf-8?B?b1c3NTY2Sk1OR1FLRThVVXlVWHBaVFdnUXhEWmYweklCdC9wa2RMWGNKY3hW?=
 =?utf-8?B?MVROSkRMT3hiQjliYTg4NVMyWTZkYkJieVpQSHpZY1FXZ1RsNk9NRHM2bVp5?=
 =?utf-8?B?QVQwc3NOV0ZLc3JCWnRFbkdSS0FGdXdaWnBhVy80RG5WVGtoK2xoelpYWW9k?=
 =?utf-8?B?amMwTHBKM2wreTlCdTR6RlZvK3RIenR5RHRLNUl4c0h3T3k0d2tqdjhFYmZK?=
 =?utf-8?B?L3diblRBZ2tPd3JjZWlsMkpmaGJDUHVHdGdHNzN1YWdYQWw4aTFRS0x2Z3Br?=
 =?utf-8?B?clVTRUNuK2E4T0dITVBPbUFCSjVZY2JvRTcwS1dQaEhYL3RWMUhzWHNrd2dr?=
 =?utf-8?B?RGlsVjVpcC9iZkFudVY4RmFDRkpEdU5hUXdqSjdyUlNpbmNxdm9QLzcwTFh6?=
 =?utf-8?B?NUJRUURUSmtUVTNnazRIUHlEdFhUczNVL3hCc2JZS0J0REV1YVBZNG5DK3d2?=
 =?utf-8?B?ZUlYdVhYMksyQlkwcEVaRkZXNTdCRkRmVGw0OStQZmtWWmtGUHhNRWZldnd6?=
 =?utf-8?B?WmVkT0tQdy9RR09aNDhKL2J6SnNEMkt1VjNaUy9KS2R2VHdJVTJoSDFRS3Bs?=
 =?utf-8?B?ZWE5Y3FHdVE4WEJtYXpRODQ1YVR0Q3dSNVFHSU1hK1JRMWVvY1ZMWDRoRVJJ?=
 =?utf-8?B?OGFKSjZXQ2RLcUdDRFRKYlJxb3hpaTVkZ3JTUGg0emFZcmJmTDhXT2xuNlhN?=
 =?utf-8?B?bTdjWmVSZCtYbjVDMXhvcEdFaDJCZXZHcXRxV3h6ZXNqK1RoTmFwTHdMNGlX?=
 =?utf-8?B?K3p3RExINW1VSm40dHRCcEFOQnVQWEwvWWtLeUZ1c3VYSmxHSkIwSnRmN1Zm?=
 =?utf-8?B?WXhvQWFWeWJsU29FZFBUeFNveFRObmJMR1BITEU5NlAxWlhWQTNGcUVIZkxi?=
 =?utf-8?B?Q0pnTUt1cXlQT2NnVnpmL3RrazJHKzk3Y25ncDRtS2JYSXBOYndHbjR4MnJP?=
 =?utf-8?B?ZDJ1TllrTmZGYTNoYmYzb1l3MkxVYnJDWlc1ZkwyTmEreHdKL1MxMk55ek44?=
 =?utf-8?B?RE9qRCttaWZ6VUhLam1lTEVQblUvdDZib1Zsc0dVSk5jdTI5N0s3YXFsTVNl?=
 =?utf-8?B?aitGYVVna3NCZkRWL1NGdG5hTW9mY2k1L0NGSXlQeEZzSERjK3hIQ3I4bmFN?=
 =?utf-8?B?blN0WXU0MjZiOGJITjNVUTFaalBOZ1JpNThlakVYaFBXNmNuRmhhQlMxQmJm?=
 =?utf-8?B?Ky9jTDUybUhITWJ0V2JmenVJY1JXa01SMGN3dUJHOE90QkZqblJuTE1laENL?=
 =?utf-8?B?MTgxb2pVK2RlN0R5T05GQnBGbUQ2eTBtMEpyMnh2QVJzK2VHUFdIOUU5Y0Jt?=
 =?utf-8?B?eHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0B0DC285B050C4387F4AC9401EDF95E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 199e2c33-2614-4e24-1dcb-08dafa747516
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 23:25:31.3568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lq12IvpvQqe0osFw0On7gOvsA47u8M0FnvYpU78KiBPpK7Hc+pLpeKrWL8S/Ki1bzqMkVVehfBpCFTlLlxojUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8174
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

T24gVGh1LCAyMDIzLTAxLTE5IGF0IDIzOjI0ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUaHUsIDIwMjMtMDEtMTkgYXQgMjM6MTEgKzAwMDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3Jv
dGU6DQo+ID4gT24gVGh1LCBKYW4gMTksIDIwMjMsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiBP
biBUaHUsIDIwMjMtMDEtMTkgYXQgMjE6MzYgKzAwMDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3Jv
dGU6DQo+ID4gPiA+IE9uIFRodSwgSmFuIDE5LCAyMDIzLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
ID4gPiA+IE9uIFRodSwgMjAyMy0wMS0xOSBhdCAxNTozNyArMDAwMCwgU2VhbiBDaHJpc3RvcGhl
cnNvbiB3cm90ZToNCj4gPiA+ID4gPiA+IE9uIFRodSwgSmFuIDE5LCAyMDIzLCBIdWFuZywgS2Fp
IHdyb3RlOg0KPiA+ID4gPiA+ID4gPiBPbiBUdWUsIDIwMjMtMDEtMTcgYXQgMjE6MDEgKzAwMDAs
IFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gPiA+ID4gPiA+ID4gT24gVHVlLCBKYW4g
MTcsIDIwMjMsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gPiA+ID4gPiA+ID4gPiBP
biBUdWUsIEphbiAxNywgMjAyMywgWmhpIFdhbmcgd3JvdGU6DQo+ID4gPiA+ID4gPiA+ID4gT2gs
IHRoZSBvdGhlciBpbXBvcnRhbnQgcGllY2UgSSBmb3Jnb3QgdG8gbWVudGlvbiBpcyB0aGF0IGRy
b3BwaW5nIG1tdV9sb2NrIGRlZXANCj4gPiA+ID4gPiA+ID4gPiBpbiBLVk0ncyBNTVUgaW4gb3Jk
ZXIgdG8gd2FpdCBpc24ndCBhbHdheXMgYW4gb3B0aW9uLiAgTW9zdCBmbG93cyB3b3VsZCBwbGF5
IG5pY2UNCj4gPiA+ID4gPiA+ID4gPiB3aXRoIGRyb3BwaW5nIG1tdV9sb2NrIGFuZCBzbGVlcGlu
ZywgYnV0IHNvbWUgcGF0aHMsIGUuZy4gZnJvbSB0aGUgbW11X25vdGlmaWVyLA0KPiA+ID4gPiA+
ID4gPiA+IChjb25kaXRpb25hbGx5KSBkaXNhbGxvdyBzbGVlcGluZy4NCj4gPiA+ID4gPiA+ID4g
DQo+ID4gPiA+ID4gPiA+IENvdWxkIHdlIGRvIHNvbWV0aGluZyBzaW1pbGFyIHRvIHRkcF9tbXVf
aXRlcl9jb25kX3Jlc2NoZWQoKSBidXQgbm90IHNpbXBsZSBidXN5DQo+ID4gPiA+ID4gPiA+IHJl
dHJ5aW5nICJYIHRpbWVzIiwgIGF0IGxlYXN0IGF0IHRob3NlIHBhdGhzIHRoYXQgY2FuIHJlbGVh
c2UgbW11X2xvY2soKT8NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gVGhhdCdzIGVmZmVjdGl2
ZWx5IHdoYXQgaGFwcGVucyBieSB1bndpbmRpbmcgdXAgdGhlIHN0YWsgd2l0aCBhbiBlcnJvciBj
b2RlLg0KPiA+ID4gPiA+ID4gRXZlbnR1YWxseSB0aGUgcGFnZSBmYXVsdCBoYW5kbGVyIHdpbGwg
Z2V0IHRoZSBlcnJvciBhbmQgcmV0cnkgdGhlIGd1ZXN0Lg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+
ID4gPiA+IEJhc2ljYWxseSB3ZSB0cmVhdCBURFhfT1BFUkFORF9CVVNZIGFzIHNlYW1jYWxsX25l
ZWRicmVhaygpLCBzaW1pbGFyIHRvDQo+ID4gPiA+ID4gPiA+IHJ3bG9ja19uZWVkYnJlYWsoKS4g
IEkgaGF2ZW4ndCB0aG91Z2h0IGFib3V0IGRldGFpbHMgdGhvdWdoLg0KPiA+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gPiBJIGFtIHN0cm9uZ2x5IG9wcG9zZWQgdG8gdGhhdCBhcHByb2FjaC4gIEkgZG8g
bm90IHdhbnQgdG8gcG9sbHV0ZSBLVk0ncyBNTVUgY29kZQ0KPiA+ID4gPiA+ID4gd2l0aCBhIGJ1
bmNoIG9mIHJldHJ5IGxvZ2ljIGFuZCBlcnJvciBoYW5kbGluZyBqdXN0IGJlY2F1c2UgdGhlIFRE
WCBtb2R1bGUgaXMNCj4gPiA+ID4gPiA+IHVsdHJhIHBhcmFub2lkIGFuZCBob3N0aWxlIHRvIGh5
cGVydmlzb3JzLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFJpZ2h0LiAgQnV0IElJVUMgdGhlcmUn
cyBsZWdhbCBjYXNlcyB0aGF0IFNFUFQgU0VBTUNBTEwgY2FuIHJldHVybiBCVVNZIGR1ZSB0bw0K
PiA+ID4gPiA+IG11bHRpcGxlIHRocmVhZHMgdHJ5aW5nIHRvIHJlYWQvbW9kaWZ5IFNFUFQgc2lt
dWx0YW5lb3VzbHkgaW4gY2FzZSBvZiBURFAgTU1VLiANCj4gPiA+ID4gPiBGb3IgaW5zdGFuY2Us
IHBhcmFsbGVsIHBhZ2UgZmF1bHRzIG9uIGRpZmZlcmVudCB2Y3B1cyBvbiBwcml2YXRlIHBhZ2Vz
LiAgSQ0KPiA+ID4gPiA+IGJlbGlldmUgdGhpcyBpcyB0aGUgbWFpbiByZWFzb24gdG8gcmV0cnku
DQo+ID4gPiA+IA0KPiA+ID4gPiBVbSwgY3J1ZC4gIEkgdGhpbmsgdGhlcmUncyBhIGJpZ2dlciBp
c3N1ZS4gIEtWTSBhbHdheXMgb3BlcmF0ZXMgb24gaXRzIGNvcHkgb2YgdGhlDQo+ID4gPiA+IFMt
RVBUIHRhYmxlcyBhbmQgYXNzdW1lcyB0aGUgdGhlIHJlYWwgUy1FUFQgdGFibGVzIHdpbGwgYWx3
YXlzIGJlIHN5bmNocm9uaXplZCB3aXRoDQo+ID4gPiA+IEtWTSdzIG1pcnJvci4gIFRoYXQgYXNz
dW1wdGlvbiBkb2Vzbid0IGhvbGQgdHJ1ZSB3aXRob3V0IHNlcmlhbGl6aW5nIFNFQU1DQUxMcyBp
bg0KPiA+ID4gPiBzb21lIHdheS4gIEUuZy4gaWYgYSBTUFRFIGlzIHphcHBlZCBhbmQgbWFwcGVk
IGF0IHRoZSBzYW1lIHRpbWUsIHdlIGNhbiBlbmQgdXAgd2l0aDoNCj4gPiA+ID4gDQo+ID4gPiA+
ICAgdkNQVTAgICAgICAgICAgICAgICAgICAgICAgdkNQVTENCj4gPiA+ID4gICA9PT09PSAgICAg
ICAgICAgICAgICAgICAgICA9PT09PQ0KPiA+ID4gPiAgIG1pcnJvclt4XSA9IHh5eg0KPiA+ID4g
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG9sZF9zcHRlID0gbWlycm9yW3hdDQo+ID4g
PiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbWlycm9yW3hdID0gUkVNT1ZFRF9TUFRF
DQo+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc2VwdFt4XSA9IFJFTU9WRURf
U1BURQ0KPiA+ID4gPiAgIHNlcHRbeF0gPSB4eXoNCj4gPiA+IA0KPiA+ID4gSUlVQyB0aGlzIGNh
c2UgY2Fubm90IGhhcHBlbiwgYXMgdGhlIHR3byBzdGVwcyBpbiB0aGUgdmNwdTAgYXJlIHdpdGhp
biByZWFkDQo+ID4gPiBsb2NrLCB3aGljaCBwcmV2ZW50cyBmcm9tIHZjcHUxLCB3aGljaCBob2xk
cyB0aGUgd3JpdGUgbG9jayBkdXJpbmcgemFwcGluZyBTUFRFLg0KPiA+IA0KPiA+IFphcHBpbmcg
U1BURXMgY2FuIGhhcHBlbiB3aGlsZSBob2xkaW5nIG1tdV9sb2NrIGZvciByZWFkLCBlLmcuIHNl
ZSB0aGUgYnVnIGZpeGVkDQo+ID4gYnkgY29tbWl0IDIxYTM2YWM2YjZjNyAoIktWTTogeDg2L21t
dTogUmUtY2hlY2sgdW5kZXIgbG9jayB0aGF0IFREUCBNTVUgU1AgaHVnZXBhZ2UNCj4gPiBpcyBk
aXNhbGxvd2VkIikuDQo+IA0KPiBTb3JyeSwgSSBub3cgcmVjYWxsIHRoYXQgSSBvbmNlIGhhZCBw
YXRjaCB0byBjaGFuZ2Ugd3JpdGUgcGF0aCB0byBob2xkDQo+IHdyaXRlX2xvY2soKSBmb3IgVERY
IGd1ZXN0IHRvIGF2b2lkIHN1Y2ggcHJvYmxlbS4gIEkgdGhvdWdodCBpdCB3YXMgdXBzdHJlYW0N
Cj4gYmVoYXZpb3VyIDopDQoNCkkgbWVhbiBjaGFuZ2UgdGhlIHphcCBQVEUgcGF0aCB0byBob2xk
IHdyaXRlIGxvY2suIDopDQo=
