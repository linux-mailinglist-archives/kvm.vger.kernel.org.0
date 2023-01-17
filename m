Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702AC66D40C
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 03:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbjAQCGv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 21:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbjAQCGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 21:06:48 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7BC1E5D9;
        Mon, 16 Jan 2023 18:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673921207; x=1705457207;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=u6M77Jhe7i1UmyhRA/a6WzlgJacJA65Yc1u40bbsq1s=;
  b=kgzPHSIAmbVd4dIzELRDWkq1ySxyWiBIQFDalSTO1DNB0+05rqsSu4jZ
   kL/wxWnS0tU0y+Ig0Z3hk2cCc/5pfXluWHt/qJKu6iF/0xDO/00jVC2WR
   RoOa8VzTiA2vuPFOs402YA2AA/eP6oU6zJTbu8gcdvidnJjYq5rMqGFOz
   flCvfohOm5TDV+XBaV3o1IOcpBgR7+eBRUmzeiCkeZoW/wR5RU9LfQ3yg
   OWp+dVnSkQl4VJoDtAiZwteuIt9WrqCJp2/xeIaLP196CQh9aVU1vJvlS
   /62Ja9VeNHoBg2Bcp7xP2k5WqhFghAk7MufrbiWRe4QNqMb5yb4OFmm64
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="304966619"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="304966619"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 18:06:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="833000384"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="833000384"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 16 Jan 2023 18:06:47 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 18:06:46 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 18:06:46 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 18:06:46 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 16 Jan 2023 18:06:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5zyCfkh5q/G7NgdIBQEAwnJ830+BBkZF2zdeFFbp154pqDsFq1bV0ZGSfHQiJxDCUVlrQzfApn01154/H6c8xAzu5Ved1FRuGgsb83Xoubyz4GiDaKek0gF1W8edkLXMTdAm+MTR7dgoIGi5tn61dsiLiVTJdXfNai8ooVtoC1jD1DvQyYJrNONP1HCMxGQ8Xp9nvLTO9fnlRhIEWjxfTyGvw8U+YE1OfGPBwfy2RtHJX7vcWAWoo3wj6HkZUE/f/37cSTmzm8kO9E46dxLdQKPoEu/kEOl7uk+2tNwepSYHZz6MfY25cCibPW71ZNPbfawc7TQ0z/sUMb478P84A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u6M77Jhe7i1UmyhRA/a6WzlgJacJA65Yc1u40bbsq1s=;
 b=PQuHANxZNYPu3CWdS2ZzNh5X+AvutkekRp+51nXnnxWdPJ9j73NM/cHwRRx5eBgiLOFcsIA88E47IzZbileTYKgxB+Dz3gRj6ujWexZWcTjA73e7fCUh07xuTbtKO0+sHYy+S3yCIvqNrb1VY099sH+8NDz4Aadwil0y1TPHUE0hMUbc5RLVl8Y33QvIzQnQBSsIV5xel/MMu3it5UKHdvsRPfer1daaJvHG1u1j8wpsl20FZVLkZcZ3Lo/OsY/Z1UZQus4/KuS09lEB+7Ed0n6Dhi2XrtrEIj7YSFQNQ6hSeR10xw+B2lLPvZM1kfyfaAbftg82hXvhyts1lnkGVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4872.namprd11.prod.outlook.com (2603:10b6:510:32::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 02:06:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Tue, 17 Jan 2023
 02:06:44 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 055/113] KVM: x86/VMX: introduce vmx tlb_remote_flush
 and tlb_remote_flush_with_range
Thread-Topic: [PATCH v11 055/113] KVM: x86/VMX: introduce vmx tlb_remote_flush
 and tlb_remote_flush_with_range
Thread-Index: AQHZJqWgQurv9uJJv02TCPDHOipoo66h42MA
Date:   Tue, 17 Jan 2023 02:06:43 +0000
Message-ID: <d98561f16056d919626a46f0d078b774e2d56445.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <d69b281c23131254ae6fdea67e384ef931dbba8e.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <d69b281c23131254ae6fdea67e384ef931dbba8e.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB4872:EE_
x-ms-office365-filtering-correlation-id: d6d59cc1-1f3b-4106-3a52-08daf82f7b10
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Fp2nxCsju/g+1TxvEHIbcyDaGUnYcITyp5XSpvX3AtDTKhAnz27hUWsHsMDxgwS3sG5iKCGYZsgvUO4JIUtQFqs3KwJFqm+MAXZK6+XtNcAnNxSK8Wm8hqONt6O+5yLFbuUE8zl3ENwVrgIPbiGShlgIbEBMBSJtqNzlO+MNIE45lR8nQzGq1P/rBigSxwj4Zv4qiag+v8IuckG5SMLrQnF2Fb5NVrzaXHMeIWprr0EvKHesgf/hdu0i/cx1bLbdOo3N0ZRjvOsf4quNJxwWWQo+8JnqSYZLjDzj/pK/yvnyTxKSoQp24F/T6rk9nDhn8ciZiaitchvKTXO4F/vXVpBiuC/JsAKlHgHMHNYspguTxdrQvHxf6LiThXfxtbd/MHcpi89V1UA3XaGxlHh0lsTT6FmYyqaLouZKtK5ph82C2L3gPxtMKlN3fxZPtrC2VzESeksMWtO0ei5D3z9xs62tT2s7YiqDM+nO8KwugVuqKpM+9R4DCrwVdv5+5wjAvDM0fThADlmnzXo9QZcvWsDgbumesXtD7odVgTwXeEqFnJcHS/5dHR7N0WPWNIiFx1VlRIAM2gQY4WlncQRc/1rkBRT61zNaTHkbbELhJ3cN/XMVPHW+chHbcYLnTfm5GJdc2kxth5d1L7Xbia8gnBcsmOiNTQdxgmq+lHXSMb/q2FOwFYhyfLb+TJS3ZST3EV29gFDX1SVe4qa1oD1zw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(136003)(396003)(39860400002)(451199015)(36756003)(478600001)(71200400001)(6486002)(110136005)(54906003)(6636002)(6512007)(26005)(6506007)(2906002)(41300700001)(8936002)(5660300002)(316002)(4326008)(8676002)(91956017)(66946007)(66556008)(66476007)(66446008)(64756008)(76116006)(122000001)(186003)(38070700005)(38100700002)(2616005)(82960400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGZEK2RtVVpQc2NBbWpyY0E3Qm1UUGFLZWxXcEZJWUlySkkyUWZFTUlLT0NB?=
 =?utf-8?B?UHQ5TGgwMW96cm81cWlPZEUzbGdldVNPSC9obDJlT1BOcTRWdU1pRCtDV21Y?=
 =?utf-8?B?WmNMcjM2VUtZK1p2V3pWUUZTamhVZEpHeWN3QjNiNXRTOE5GQ3haVU9rNXda?=
 =?utf-8?B?eFQ2cUZaZWI3bWpiRkUrRnlrTXZvSCtYcHFLai9sTWttcE5nb0RQVVRWTzYv?=
 =?utf-8?B?TDVmZXNjUm93NWw0Tk9SVXdlVjNrYi9mRmwvVTF5cWFybkZQbm8yemk3MWQz?=
 =?utf-8?B?MHBrbjZVSWJmeDl4Mjk3THZmYmd6ZGxLT0xjWXpLditqdGJ2ZXZEaEdKS2ND?=
 =?utf-8?B?UWdTRkZ1R3RESWgvbGxsSGdQZ1FhUGRvU0Vmek0rTmJSM2NpaG1pVTVRWFVT?=
 =?utf-8?B?SDZnVkhQYlVYMVZadGhucGpsNmU0WGNoc3lzNEN0RVpPbTlXaTEyV3pRZUp6?=
 =?utf-8?B?ZWEraWJrZnBxT1FDdGttRFpGUXBMS1U3OWJHQ29wMFE0aGhpejJiVWpCNWhD?=
 =?utf-8?B?cVRSNkdodlBsL2g5bTAwaXFYSlJlb2xOQ1dDQUJacE5ydHpFZlNDTnRKQ05M?=
 =?utf-8?B?QmZ1NjhkTU43bjhQUi80S21YSWFxLyt4VkU1TlYyUDdTZm9sOE5nTktvMW1k?=
 =?utf-8?B?MTBhU2tvSCtra0EwNmp6QUpVTVN6NGZRM2RHaThCZzNxM1BMRUpuUWtZWlY1?=
 =?utf-8?B?VGduWTlNWTExaEgyd0YydWlUNEhtUFVvWk9Eb0dCd2xLK1FvYi92K1UySk9n?=
 =?utf-8?B?d2N1dkpNeE82anNRemJhN1RFM2RBQ2RXNVhEdnhMYm4vRWdkQXpMQmpxL3ZJ?=
 =?utf-8?B?c2FJSmRmdWk5dVBoaEpwLzlUelZnZFF3cXh0ZFgwa3haQlhZTndzNDJaODAv?=
 =?utf-8?B?TTgzYVVjTGpTbkFmcWlsL2VCVVE1S0o2RGp5UEZSeEJUNndmL25hZmJ3NmM0?=
 =?utf-8?B?NGlqRVJjcmp1MXdERllwWjdmTWJ5cm5kY3E2U1JzVEo4ckpJRVhYNG13Q2J5?=
 =?utf-8?B?V3VNRE8za3R2OXpEZzRKb0d3V3dCYjFBVjlsUVNuakg4S3AzYjZRUDZvVWZK?=
 =?utf-8?B?UlVzbWpWd2l2SnphNndGTVhYQ0NwQ2lRaSs1M0FDdGU5S2NXcWZneGxnMHFu?=
 =?utf-8?B?d2hLNmcvdUJpWnZhZUl3Wkk1QTA0TFNqeUcwcS9NbG4yR2FOcDRSSEtMQW5h?=
 =?utf-8?B?VytuUmErSU53d2RYalF5RHFtYWlPdXgydzR0WkxJQ0ZuMXd6ZjBCUnFzMXhG?=
 =?utf-8?B?a3h5YnNUWmlQbTRzcWtwUEZaZkZIMmFUeG10c2NTb21DZEp0Vmt0OWxwakFQ?=
 =?utf-8?B?NVp4Z3FsU2h2OEloS1dJWEhsampoYzF4M2VveFZEYmRYY1NWRlhMai8vWDZG?=
 =?utf-8?B?aXM4QS9PcDJJczBhdVpDMHdzRWd2dE85SERhQWVYci9HbVFEOUNZOTJkNENE?=
 =?utf-8?B?SHl5RzBGYnlDUGpQQUpoOHFKTG1ldU5PZ2FVM1NUSGhsK1p1c1dYNlVXN2Vm?=
 =?utf-8?B?TkNLallTK1hsYmpXNkN6cFltSyswTXNZNTlTNGZXSjk5QTRISndGcTdVOWVJ?=
 =?utf-8?B?Y3lvVUpzSjh6SjArYnczeVhtQmkyQ01QNmplRlUyTi90NTRtSXdnY2U0eGVH?=
 =?utf-8?B?RXRYSWRETEUwQTBBeTZwbHJYdVNxdjl2Y2F0enVzdVAvMGp0UnhHbXVmSlpa?=
 =?utf-8?B?TFk1amRQV1ZwcVU3eHA5Tk00U05HSGxtcXFKWTdEY3VKbDU5NDNrTHZQRk8y?=
 =?utf-8?B?Sm9kbFloaGFCOVNWYmFtUi93eHJIRFRtQWhkZ3FaVDFVRkt4K2w5dS9DSjVT?=
 =?utf-8?B?U2pzeVFOL09HN2QwZisyRFRwTW83UW1JaVFVN01Ga05wZkdpbGp1bEQwRmdi?=
 =?utf-8?B?Tk42dnFRc3ZRSENnc21sUHF5cU43M1Z2M1h5TUlkbi9XSlFIOVl6VTh5Y0VY?=
 =?utf-8?B?N25TSVVtblZMeWpmc21wMkx1UEhLa25UdUJQU3JIbVNPT1R1OU9yWm5FT3BS?=
 =?utf-8?B?NGprTmNqV0RsK0svYUFEM2lsYzcxRTBYZXZKL3BVSUhIem5xZCtnejBMeCta?=
 =?utf-8?B?bVZ5OHRublkxbVdrTlZMMVA4TS9OOEhxcXdmYzdZdEVQeXMyZFlkN3lldHQ1?=
 =?utf-8?B?Mko3dEozZ3VLUmlneTZPWm9HS1VkWkc4aUhDSTZ0OEprOG1JWWV6TC9LZ1gw?=
 =?utf-8?B?UkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4E2E1949150C048A08C4F16FB12B4DF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d59cc1-1f3b-4106-3a52-08daf82f7b10
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 02:06:43.8003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JQq+txZKvnXX9IZV5I3rfvHG8HKOsZJM3M0vSQ7y4XJR8P2W5Z+DS4lYNUzVqXNZ3o35n2yMbaoYmfgnINOIQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4872
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA4OjMyIC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gKysrIGIvYXJjaC94
ODYva3ZtL21tdS9tbXUuYw0KPiBAQCAtMjQ0LDcgKzI0NCw3IEBAIHN0YXRpYyB2b2lkIGt2bV9m
bHVzaF9yZW1vdGVfdGxic193aXRoX3JhbmdlKHN0cnVjdCBrdm0gKmt2bSwNCj4gwqB7DQo+IMKg
CWludCByZXQgPSAtRU5PVFNVUFA7DQo+IMKgDQo+IC0JaWYgKHJhbmdlICYmIGt2bV94ODZfb3Bz
LnRsYl9yZW1vdGVfZmx1c2hfd2l0aF9yYW5nZSkNCj4gKwlpZiAocmFuZ2UgJiYga3ZtX2F2YWls
YWJsZV9mbHVzaF90bGJfd2l0aF9yYW5nZSgpKQ0KPiDCoAkJcmV0ID0gc3RhdGljX2NhbGwoa3Zt
X3g4Nl90bGJfcmVtb3RlX2ZsdXNoX3dpdGhfcmFuZ2UpKGt2bSwgcmFuZ2UpOw0KDQpBZ2Fpbiwg
SU1ITyB0aGlzIGNvZGUgY2hhbmdlIGRvZXNuJ3QgbWFrZSBjb2RlIGFueSBjbGVhcmVyLiAgV2l0
aCB0aGUgbmV3IGNvZGUsDQpJIG5lZWQgdG8gZ28gaW50byB0aGUga3ZtX2F2YWlsYWJsZV9mbHVz
aF90bGJfd2l0aF9yYW5nZSgpIHRvIHNlZSB3aGF0J3MgZ29pbmcNCm9uLCBidXQgd2l0aCB0aGUg
b2xkIGNvZGUgSSBkb24ndC4NCg0KVGhhdCBiZWluZyBzYWlkLCBJIHRoaW5rIGt2bV9hdmFpbGFi
bGVfZmx1c2hfdGxiX3dpdGhfcmFuZ2UoKSBpcyBzb3J0IG9mDQpyZWR1bmRhbnQgYnV0IEkgY2Fu
IGFsc28gdW5kZXJzdGFuZCBjYWxsZXJzIGRvbid0IHdhbnQgdG8ganVzdCBjaGVjayB3aGV0aGVy
IHRoZQ0KY2FsbGJhY2sgaXMgdmFsaWQuDQoNCkJ0dywgSSBoYWQgc29tZSBtZW1vcnkgdGhhdCBJ
IGNvbW1lbnRlZCB0aGlzIGJlZm9yZSBpbiBzb21lIG9sZCB2ZXJzaW9uDQoodGhlcmVmb3JlIHRo
ZSAnQWdhaW4nIGluIG15IHJlcGx5KSwgYnV0IEkgZmFpbGVkIHRvIGRpZyBvdXQgLS0gcGFydGlh
bGx5IGR1ZSB0bw0KaW4gc29tZSBvbGQgdmVyc2lvbnMgKDw9IHY3KSBJIGZvdW5kIEkgaGF2ZSBu
byBjbHVlIHdoaWNoIHBhdGNoIHRvIGxvb2sgYXQgYnkNCmp1c3QgbG9va2luZyBhdCB0aGUgcGF0
Y2ggdGl0bGUuDQoNCg==
