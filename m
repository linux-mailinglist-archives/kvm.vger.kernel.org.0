Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324BD7005FE
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 12:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240925AbjELKtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 06:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240866AbjELKs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 06:48:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09C213855;
        Fri, 12 May 2023 03:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683888509; x=1715424509;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XSlqns6wXuBmkzJhsrkJbhKhljU12/B3HILz0kCfcTI=;
  b=maQ8fzjQHWl+nJBjXtM9QU5c69MvcnG9IvEX5qujSwHV6tSXymNwFLnh
   7f0/v7vcdYhBouU7Xs3g7laHiMNfP0Hjul+aqqk5yA/x7tHHjoG8QxgGS
   AE4h1kkfEuVt7iyJVOMJ2BuA1yMYCnusxVdKRIRvSIKbrO0vEU7oJeTPS
   NfNI2s6gyGU5UjcT0+D3g8g4szJuAvqU1mfijs/9AzVAZDg797sESKBuA
   BYTxUCiaYZsQ1fSYZy4R1NWfrQQSzCLpCzh6IrnkYXZerh7r0kpBjrB2D
   AKefpgqLFjigLxFXEbFFL122eXpmn5lFPDAh1SUe84t1pfPwmVqOk/6+7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="416393540"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="416393540"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 03:48:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="733005999"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="733005999"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 12 May 2023 03:48:28 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 03:48:28 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 03:48:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 03:48:27 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 03:48:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICwTIs35ErgDDhdw3g8jCKw5MvK6NSIRKDVGg+NiP/3Cw8X2k5VTnxxz/IY11ZBgwoNL85g1M0f4VMjFQ07hbPRq9N7AvX0t+LSgWwrQW1J+yIkaLxRVpP9orU6OqY6TX3Di78n01R7CMkEKmZzPmltp4ngKzT+VwhWy2pcuMMba+MK8aG0A3wzJlZ4mjuHTQJiwBYg9RXd/lrjFCV+Udtmy6mWBCEdBcgDK0N+oOPi4pdbxl7tIGwZN/fJK7Qb7hwmd4A0KEjE1pmkufnHCKF3Q53ZNeVSsq0XD/rYTjaOSg58ZAVRItJzeyeMITo0bQtmENq25QzU9LrrNdIsiCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSlqns6wXuBmkzJhsrkJbhKhljU12/B3HILz0kCfcTI=;
 b=Yq8a2NT/bSvixSJlq3qIDi9pVRt3goXkWdF+ZUEDFWX0WZtQmJ1CxezEoRGh0aSwoy2HyFkRB7G999IU0QoNDsaShf01mxbFQ1AHoEgUNtWsuYKnhR3iSLGguWWWnb3XaAeKfPuWiyYY2q1BkbNSOC2sa8lfs8H4yZvW6UIFuL7bPrjO8Y6SHsGX/Z/WVbTfc4kve2A5GeZnP441wbGODzo1Zeyrhu/8RPNCUCWVL0BFPZ6B+UUQ+zJKF6Oc7W1ASihzeHNzvQYDzCAm46HravbznpOmkZ8e5t6kLe7t7dzKNGkFRC6Ss1xQFrjzWYreTMf0W2F8yHot4c1DYolJNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6805.namprd11.prod.outlook.com (2603:10b6:806:24c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Fri, 12 May
 2023 10:48:20 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6387.023; Fri, 12 May 2023
 10:48:20 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Subject: Re: [PATCH v2 8/8] KVM: x86: Move common handling of PAT MSR writes
 to kvm_set_msr_common()
Thread-Topic: [PATCH v2 8/8] KVM: x86: Move common handling of PAT MSR writes
 to kvm_set_msr_common()
Thread-Index: AQHZhGEgbqcLbmhobk2ySqM+qzaGL69WdcKA
Date:   Fri, 12 May 2023 10:48:20 +0000
Message-ID: <8ac08604f64103ab78c4a55ef36d1a2b5388b7f8.camel@intel.com>
References: <20230511233351.635053-1-seanjc@google.com>
         <20230511233351.635053-9-seanjc@google.com>
In-Reply-To: <20230511233351.635053-9-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6805:EE_
x-ms-office365-filtering-correlation-id: c664a0b7-dce3-4164-597e-08db52d6669d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /k4gOhQPWkqCNDQRBddiVklA+RKGgmHJ5IGLLI/8fYYifgIqyldkhWrAi/VGclOvdegp4OGo6v0F7QdVQBdKUSkQyCh8ptIvJdQM/a41XhYnucZ2owTnBDNWawesJL9sRgFsGAhFB3QJHlkH9DCwyvXWq6Z8SdQ7+etQG7ExGMEcpxgImjHDN+vbL1u7TLY9cTJ852hBcoRmG554LAEEf1+BADsLnTJqgvJPgfxNbx1xm0GLBLRZHomW2iP0u4xiq0nPQP4f/lGlw+4tmUsxncTTxtqz8aCdtakPm1yWp3nHcfEr3V3jSQ/N7vV9a4qsDlkZt/y5HA9/rwl/UCq1MKZgcAwibjvMHJZhjYBjcIY023UIqzrGWJJs1LR5WTq89WvW7XLJIX6jKNXCYsQa3eX7AikElOMP6Sp1pjY4zH7t3+YgRWgyvT2sFJjEn1qr4YvLgN0rhVr2LuZGLItTS0j8a30WXw9NovaRRlrVycTlGTQRnmdUUdkhbO437W2GSuMf5Mgfcm7PTm5HMODEdpoIVFn0rPc6wdD8BglILJVRGub82BguIhrFvucQ6Wi9xe+CDCPv2SdtRlkdhW4KEPFoUTQMGjmpT9uyC4/rvcY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(366004)(346002)(39860400002)(451199021)(76116006)(66446008)(66946007)(66556008)(4326008)(64756008)(316002)(66476007)(91956017)(478600001)(83380400001)(122000001)(41300700001)(82960400001)(110136005)(54906003)(2616005)(38100700002)(8676002)(8936002)(6506007)(86362001)(6512007)(186003)(26005)(38070700005)(2906002)(5660300002)(71200400001)(6486002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVVGREdpMTlvZjVGVkZvYkdHK1U2ZWFCM2h5UjZ5cVZtaDFNRVU0cHpZaG1W?=
 =?utf-8?B?elQwcVdPOFJ2QnNLL29CcnduQ3htSTE5bXZNSE5oT2orbk1zYzRad09nOUpZ?=
 =?utf-8?B?cFZaa3R4VXRLVFRHQUJJNkRucFdmblJqYTRtQlF4MWUvV0xRRGpmcnN0aE5v?=
 =?utf-8?B?OUVYazNwWHhyYktMWmd2MXBWMS91ZEUrZHhUTUM2ZGtiN1pvcXhZSlhOK05y?=
 =?utf-8?B?Tk1qWVhjU283NnM3RWhVaGg1SzNSZEtwVUhJNDFvV1VYM3I0RndzTFcxTDBY?=
 =?utf-8?B?S21MYUwxdHNkL2JQRndRNFZzMy9HMTJuVlVaQ0ljZHBYREk5TGczY1orWkV6?=
 =?utf-8?B?Sld5WHM1ZkVNREQrTjZuUU56SGxQQmZScVB4Q3hMQTYxbFhRZ1B0ODloREI1?=
 =?utf-8?B?dk9CUTdnL3hCRGlGVGN6S2lFNW1jQmdQL29aQldIMEhrZXNwb0t0YkJGbFk3?=
 =?utf-8?B?eVBaaTlIZlg1VGk5Qk9nUXlYT3F6Z1J6UWF2alorOWxlR1JGT2djS1FZSHZr?=
 =?utf-8?B?dDBwcE9YdmV5dzNlZDhuZ3lHNUZQTjRIWXVjWkhMMnM4YThxZVRlNFlTaW1V?=
 =?utf-8?B?cVI0MzMwbVJzOWh3emNQMkkzcnNLVVBEN3dyVDZDVmsyeHdTVzc5UlRlRmt2?=
 =?utf-8?B?Z0E5emQ3bDJPTW9PM29FZ1R5d0hNY2ExanZkNDRXcDNsUVd3YkY5ajM1R1Q0?=
 =?utf-8?B?OWk1N1ozSjZVWVkxMWtjOWV5UjBkWTRjRlZLa1JuTFExRkU3NmlOYndRNHdU?=
 =?utf-8?B?dnVCL0JqWnE2aGJ6VFB6REJQV2hnaXprU0Uwc09lLythUEptRUtxZ0RXdUEw?=
 =?utf-8?B?b3IzV0RQNjIwVytwM1VNNW81eTBUNkpCZURhVURKTzVlVnNJaTMxUEViZ2l2?=
 =?utf-8?B?ZldmMlFKUFkranVYQ2o0cFRPN1d3K1ZWd1E4aEpTbzdSS2Z2bjJOc2lsV0Yr?=
 =?utf-8?B?L1RvV2ExVDJJRDR3NzloZGJqNnZkZFZUVFpmZVdzZnJDbmlROE0wSUh0V3Nw?=
 =?utf-8?B?R2VoWjhzNmZmV2YvTGhub2MrMjVVbDgvTFNkZFMvMmFjMVN4Qm03eDZLdjlM?=
 =?utf-8?B?WjQzYW9wR0R5aVBvQTI4UnRkT1RpS25zRlkxclpLV3VIN2V2cFFyS3lRVU16?=
 =?utf-8?B?MC96M0p2UVVCUXRvZ1hqd0IwL3kvUlhJbkw2VitBbUxhaGh2TnhDS0xMMzRr?=
 =?utf-8?B?VHd3a1dCOC94WVJrYWpqcER2NkJMRTBBTnBjMzEvd1ArQnVnSFBERkNwTzlT?=
 =?utf-8?B?dWtXZDYyeGVILy9lREFRYllrMjFaMjI4R0I0WVJBa3o0MlRuR2QyL2JCNnhk?=
 =?utf-8?B?dmxHZzNrQVdqNDdkUHFKd1NINmtBRTZ2Tm90dXFFYW1sUGRWSnpxRFJGdUM2?=
 =?utf-8?B?T2tBWWVHZHJyRWMydko0N2VWSVcrR1VvcnFlTklzL0hBN0NmTlNLVjJUZVVr?=
 =?utf-8?B?dktFK2ZkMkFUT0FGTXR6OVpRRVI1ZzZHWHZtZ09WcFVtVGNZMGRKdmdHNXVv?=
 =?utf-8?B?WE1mZEFHV1phS3k1TFBHc2plOW9teVNHRWlleDFkdzc1ZENvWFBsWE9OLytt?=
 =?utf-8?B?bUxKZTdocVBCSzVsR1dObzh2OFRQc2czYWMzc3M5RmtOQ3BUNkV3R2xOMUVn?=
 =?utf-8?B?ZFFsYitlbllFZUVSZnQxbUllVndGaERjZDNsWEkwUXFtUkdVYnJPUUF0K2lh?=
 =?utf-8?B?aFZiYVVJR2lodi9ienp6YWdjZ2IvNHlmb0h0SzBJSTFyVTIraVpVeExDYnJx?=
 =?utf-8?B?OEY1MThER3JDRkh3ajViNHprMkJ3elhSMmNmY2RONGprejI5MzFIbTNoUVBG?=
 =?utf-8?B?WW51Vi9Ua0RjRDFYRFY4MjVDK0FtVGMyZ20zQjNPY1gzWUpJeGZreTRNY1Fv?=
 =?utf-8?B?OFpjd3NjNVlDVFJPaFJqODZJZVlqR0p1WmlhTzRFdDBaQWY2R0QxT2prSGds?=
 =?utf-8?B?Nm42VnV4RlhYazRzV1lGTHg5ZW1CTFN1M1gxM2hBbnNVYythZkE1RnZYckdW?=
 =?utf-8?B?cTZDZXZYanp2ajBvTGZ1YTRsbmZBYXk2THhJeW9ZdmRFQVN4T3hrNXRGTVh6?=
 =?utf-8?B?UHN0bU8yOHhQTldpeGRsTVY2dEhXT0VtSTZIR3BVVENiL0daTEIySDJzdk9V?=
 =?utf-8?B?eE1FZkJZZzI4azViR1E5aHJsdldJbVlWSVNpdWxOOC9pcStYM2YzaHNITUpI?=
 =?utf-8?B?QWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A745651D9DB0345939C849B792CF49B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c664a0b7-dce3-4164-597e-08db52d6669d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 10:48:20.1006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mtMuDk1hDwDGx48GSW8pF2R5Lp3QRkEPEPJEYmza70Ll91iWsYVaCFepeXwBgMs+b+HXY1cVeFw2INVvzKhgkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6805
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA1LTExIGF0IDE2OjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBNb3ZlIHRoZSBjb21tb24gY2hlY2stYW5kLXNldCBoYW5kbGluZyBvZiBQQVQgTVNS
IHdyaXRlcyBvdXQgb2YgdmVuZG9yDQo+IGNvZGUgYW5kIGludG8ga3ZtX3NldF9tc3JfY29tbW9u
KCkuICBUaGlzIGFsaWducyB3cml0ZXMgd2l0aCByZWFkcywgd2hpY2gNCj4gYXJlIGFscmVhZHkg
aGFuZGxlZCBpbiBjb21tb24gY29kZSwgaS5lLiBtYWtlcyB0aGUgaGFuZGxpbmcgb2YgcmVhZHMg
YW5kDQo+IHdyaXRlcyBzeW1tZXRyaWNhbCBpbiBjb21tb24gY29kZS4NCj4gDQo+IEFsdGVybmF0
aXZlbHksIHRoZSBjb21tb24gaGFuZGxpbmcgaW4ga3ZtX2dldF9tc3JfY29tbW9uKCkgY291bGQg
YmUgbW92ZWQNCj4gdG8gdmVuZG9yIGNvZGUsIGJ1dCBkdXBsaWNhdGluZyBjb2RlIGlzIGdlbmVy
YWxseSB1bmRlc2lyYWJsZSAoZXZlbiB0aG91Z2gNCj4gdGhlIGR1cGxpY2F0YXRlZCBjb2RlIGlz
IHRyaXZpYWwgaW4gdGhpcyBjYXNlKSwgYW5kIGd1ZXN0IHdyaXRlcyB0byBQQVQNCj4gc2hvdWxk
IGJlIHJhcmUsIGkuZS4gdGhlIG92ZXJoZWFkIG9mIHRoZSBleHRyYSBmdW5jdGlvbiBjYWxsIGlz
IGENCj4gbm9uLWlzc3VlIGluIHByYWN0aWNlLg0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBLYWkgSHVh
bmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3Bo
ZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWku
aHVhbmdAaW50ZWwuY29tPg0KDQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL3N2bS9zdm0uYyB8IDcg
KysrKy0tLQ0KPiAgYXJjaC94ODYva3ZtL3ZteC92bXguYyB8IDcgKysrLS0tLQ0KPiAgYXJjaC94
ODYva3ZtL3g4Ni5jICAgICB8IDYgLS0tLS0tDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDcgaW5zZXJ0
aW9ucygrKSwgMTMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3Zt
L3N2bS9zdm0uYyBiL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMNCj4gaW5kZXggZGIyMzdjY2RjOTU3
Li42MWQzMjk3NjBmNmMgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMNCj4g
KysrIGIvYXJjaC94ODYva3ZtL3N2bS9zdm0uYw0KPiBAQCAtMjkzNSw5ICsyOTM1LDEwIEBAIHN0
YXRpYyBpbnQgc3ZtX3NldF9tc3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3QgbXNyX2Rh
dGEgKm1zcikNCj4gIA0KPiAgCQlicmVhazsNCj4gIAljYXNlIE1TUl9JQTMyX0NSX1BBVDoNCj4g
LQkJaWYgKCFrdm1fcGF0X3ZhbGlkKGRhdGEpKQ0KPiAtCQkJcmV0dXJuIDE7DQo+IC0JCXZjcHUt
PmFyY2gucGF0ID0gZGF0YTsNCj4gKwkJcmV0ID0ga3ZtX3NldF9tc3JfY29tbW9uKHZjcHUsIG1z
cik7DQo+ICsJCWlmIChyZXQpDQo+ICsJCQlicmVhazsNCj4gKw0KPiAgCQlzdm0tPnZtY2IwMS5w
dHItPnNhdmUuZ19wYXQgPSBkYXRhOw0KPiAgCQlpZiAoaXNfZ3Vlc3RfbW9kZSh2Y3B1KSkNCj4g
IAkJCW5lc3RlZF92bWNiMDJfY29tcHV0ZV9nX3BhdChzdm0pOw0KPiBkaWZmIC0tZ2l0IGEvYXJj
aC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gaW5kZXggMzNi
ODYyNWQzNTQxLi4yZDlkMTU1NjkxYTcgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgv
dm14LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiBAQCAtMjI4NywxMCArMjI4
Nyw5IEBAIHN0YXRpYyBpbnQgdm14X3NldF9tc3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1
Y3QgbXNyX2RhdGEgKm1zcl9pbmZvKQ0KPiAgCQkJcmV0dXJuIDE7DQo+ICAJCWdvdG8gZmluZF91
cmV0X21zcjsNCj4gIAljYXNlIE1TUl9JQTMyX0NSX1BBVDoNCj4gLQkJaWYgKCFrdm1fcGF0X3Zh
bGlkKGRhdGEpKQ0KPiAtCQkJcmV0dXJuIDE7DQo+IC0NCj4gLQkJdmNwdS0+YXJjaC5wYXQgPSBk
YXRhOw0KPiArCQlyZXQgPSBrdm1fc2V0X21zcl9jb21tb24odmNwdSwgbXNyX2luZm8pOw0KPiAr
CQlpZiAocmV0KQ0KPiArCQkJYnJlYWs7DQo+ICANCj4gIAkJaWYgKGlzX2d1ZXN0X21vZGUodmNw
dSkgJiYNCj4gIAkJICAgIGdldF92bWNzMTIodmNwdSktPnZtX2V4aXRfY29udHJvbHMgJiBWTV9F
WElUX1NBVkVfSUEzMl9QQVQpDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9h
cmNoL3g4Ni9rdm0veDg2LmMNCj4gaW5kZXggZDcxY2Y5MjRjZDhmLi4zNzU5NzM3YzA4NzMgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2
LmMNCj4gQEAgLTM3MDEsMTIgKzM3MDEsNiBAQCBpbnQga3ZtX3NldF9tc3JfY29tbW9uKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IG1zcl9kYXRhICptc3JfaW5mbykNCj4gIAkJfQ0KPiAg
CQlicmVhazsNCj4gIAljYXNlIE1TUl9JQTMyX0NSX1BBVDoNCj4gLQkJLyoNCj4gLQkJICogV3Jp
dGVzIHRvIFBBVCBzaG91bGQgYmUgaGFuZGxlZCBieSB2ZW5kb3IgY29kZSBhcyBib3RoIFNWTQ0K
PiAtCQkgKiBhbmQgVk1YIHRyYWNrIHRoZSBndWVzdCdzIFBBVCBpbiB0aGUgVk1DQi9WTUNTLg0K
PiAtCQkgKi8NCj4gLQkJV0FSTl9PTl9PTkNFKDEpOw0KPiAtDQo+ICAJCWlmICgha3ZtX3BhdF92
YWxpZChkYXRhKSkNCj4gIAkJCXJldHVybiAxOw0KPiAgDQo+IC0tIA0KPiAyLjQwLjEuNjA2Lmdh
NGIxYjEyOGQ2LWdvb2cNCj4gDQoNCg==
