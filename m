Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3203A6DE7D5
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 01:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjDKXLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 19:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjDKXLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 19:11:40 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98BC1FD2
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 16:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681254690; x=1712790690;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0Lk1f+Z4pp0LZtdlm0VyL9tysplbIP7TTuWCQQkxoK0=;
  b=Nunx0n3p0yJyTHoi81QG00zcoyLNvkxrKPMT+dpJGWEdgR6HinHTgsOH
   xyqav4lOFb2Qp2juQqq3c1VhD2Obvrv2OENLeBOU8pL6cO5/arOrZPpyt
   27romHNo3ZtTOhP9I42MDr1rn62zbZ7CYYvnYhYPJ+uv/YROyzb0+qgFO
   wI1mf37EQmGT2tj/YimFq2R4WTN9RmIS2q7UQreC8zfHHc4lP/KBjQhnR
   K9uYeadt3s8lg+gwyDsFM1PE0X19CtCQBzoAJLOCKcajSG8ooSKmyVU0X
   uyHjZeYwh9SfYC8AvEPBYFgSGb2t2qPfg4LLEbFCqeJSDYhfK1sKaPDbN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="327859407"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="327859407"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 16:11:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="1018540329"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="1018540329"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 11 Apr 2023 16:11:30 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:11:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:11:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 16:11:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 16:11:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6nj2YAZwJHswRLJN7lu7SSGdgZ1xplGJC0bUBw2aBRdyfAsnSS53ipElcKwY+oLxEQ7jAg+8ST7rea40Ym5Y4d3vd6znvjJhe9mBCCN51Nud6yt9YxNkKVIJdI1h+s9oVf/MBf0OkzJ77jsHMkcyDiiXd+Nj+JeaVyowg1fx74X4pmiCc/nhJopufC0eA6uLAyGXQXWAC6E3MwmOc+pJXuy9qIrWqgJMt8qKS5+hD1Sk1uIDK2mtMLrKCTupA3R3xR7vLFTEdprUbTiI8d7kRSWLMwYNjAX2mbReeQ3kpfmSfUjgJ/eM/a6KZ2+e8u7pY6dRW9AbJGrcfI/Kvp46Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Lk1f+Z4pp0LZtdlm0VyL9tysplbIP7TTuWCQQkxoK0=;
 b=D8qBOH9L51nSSf/i183oD/W88WjG1ZA88EpgIuuA4qiQwWSFA4Un6zACvwU9hnPbR3f53YzJl0U5qQovkpDaspGduTBuwTyF5tp610pCqjDfmbKAR9sZuK6wA3uzlnXidM2ajEWrvV5RLxuLdsgPsd31QLUB26X0Ted/GRgsLbDV0mqfJRHVGnDdNK6Dfbm9nIvJZrK1BpL3YT7idgDeSmJpZTX3kHfy1VFY4aq1/hD2YbKoW8awOiqevSGYBCpnwFh533rPDFpAYaK7xzo1QmTXIz1LcSNmCRBXRQp71c2NIAuSKFMZW9+zhQVz/qYlETsFd78ExOG6kfkG4nCwCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8211.namprd11.prod.outlook.com (2603:10b6:610:15f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 23:11:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6277.034; Tue, 11 Apr 2023
 23:11:27 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "Guo, Xuelian" <xuelian.guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Topic: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Index: AQHZZva2XlM7fnwAvESmPCLhodGl668eQLaAgASgfQCAA+a8AA==
Date:   Tue, 11 Apr 2023 23:11:26 +0000
Message-ID: <a49de483c77ad012959d1013d3f479123f1e2a7c.camel@intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
         <20230404130923.27749-3-binbin.wu@linux.intel.com>
         <c3f62d20ac624f36723d41438b8eefedc413eb62.camel@intel.com>
         <99f7b894-ff4b-0a6d-be58-a0966d30e622@linux.intel.com>
In-Reply-To: <99f7b894-ff4b-0a6d-be58-a0966d30e622@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB8211:EE_
x-ms-office365-filtering-correlation-id: c6b78672-0a19-474c-5d08-08db3ae213ae
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ++0DeWqa30HO2huyG9X/L9Toecq+Gmq87vY88H+wFxrvWCwILQNX1Uc5/aWV+2c+yOuBNMac3wJvqxBebkDL/S47WBv+Y/AFAoP56iUxVX0IZu3R1DMXZuNvN9mj5kqd/QjBNaVc6BLxno2vrbg2U9AEM1dAG6e+BX3ecHvGioWOmp2Ps5Gvr6Tk6nx7VHA9nGr9M0PUTNDoZfgF+Iujur61F8AZ/g3dosURp7q1b34QFC75FJn/HLVhaqZg1P3ENB19Uoxi9O966hIgCNYXpH0DseYBCVO9mGRQsrUFS2Vw5axvGLJhWpVp9DaaKYzBB+ut0aMZ0SCdsa+1IksztIKfs58M/bN8zyva5+9a5KDU7NCk/bQHw+ufobakQL1Q8pVsr+qc8cDozHQOkkOrRvmZc7AquSVHDyl+gh+qpV4MOt8UYQj3Hsn+ZntFXse2dgoYEZsQbFVkuRgXEyA9INnkeWUOXjk122xHHZzK2UB0bPyWSjShHQILli50oDe29rR78zka8zLNMqHbXsnqBlS4Tho5LCf4nrbycIYV72LbAQSBGWFu23+tXCPoxby+UBGTDwYL4xdNs2K4V6y1HuAjQUMYfoTEogrAtywzoS6tyKv7Wd5U+aofvhZqFFJw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(396003)(366004)(346002)(451199021)(71200400001)(478600001)(82960400001)(36756003)(38100700002)(122000001)(86362001)(2616005)(38070700005)(4744005)(91956017)(2906002)(110136005)(6506007)(316002)(6512007)(186003)(5660300002)(26005)(54906003)(6486002)(66556008)(66446008)(64756008)(41300700001)(8936002)(66476007)(8676002)(76116006)(66946007)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Lys1akFTMXk1L0paS3dya1ZHR1QwODhQbzFlQ0dOVW5ZemhxMURZbkF4N1Nv?=
 =?utf-8?B?elB2OUNFZkwrL2w1VE1uUU1LZnpmbjVCa1BrVGNIR3NTTXY4UE1FSEdCQTZZ?=
 =?utf-8?B?d3dvTGU0SmdyTC9hd2ZETXNxbVE3SDZueFFCRENrMmRDd2NQV3ZYeGR1cU1X?=
 =?utf-8?B?S1loc2JKd3Z5eUlEZHdIcCtram1YaWhuTGF1czJZb0dQWkdUMnZqeWdBaVQ1?=
 =?utf-8?B?Z2JhSXEySnZFdzlrdVhRcE1IN0w4NDlnVzN3MWFNMFJtcVVzYXYya0daL1Ni?=
 =?utf-8?B?Y3NzU3ZXUllIUk9HUGxTVWIyZExnV1BKVHJkQ1hBRVVBQ0w3d01aQi82T0Vs?=
 =?utf-8?B?NkQ0NFIrRFF1dWdkL3hOR3RTbUxkYWZmVFJvdXgwdGtjVkhlazNieXM4QUNW?=
 =?utf-8?B?T0FRRkJWWjI0KzJJdHEyZnNFV0hSMlB6eVZja2M1TkpqcElDUEpWNFM3NG82?=
 =?utf-8?B?NGJXNnBSZ1NQejZzYzBiU3JSUi9hWTRoOEJzbzZkb2J3YTBkMkw5d29DKzZh?=
 =?utf-8?B?STFkT05OVCtBQ0p0R2k1RTBHNFh4aU83djFnYWw4OE5XRHlrbm50WlNQQy9S?=
 =?utf-8?B?SjRLWDVQdWtkSmJQSStOOTNjL3lrUVhjZkhlL2RJNTVCdzFmUW5LV003Sito?=
 =?utf-8?B?TmZZTXlEMmJkOVEzSmtsQ1E3WndCamd1TGZESDNGdWZDR2RwZmxyOHVOa2tL?=
 =?utf-8?B?dWNWNUpxT0Nwd1BLSW5qV3ppS01aVUsyOVI2RkwwVGtkZWpHb1MxQnRSY3hE?=
 =?utf-8?B?ZXVCUVcxa2tLOW81dnpxcDYxbXFOakxXekZtUFJoRXJzKzNka05ObWZ5MUpS?=
 =?utf-8?B?U3NZUWNXK1RCb2hoWnU5dnIxdURNT0M5aHUwdXhqd1dJWTZ4aitDOVA5b0d6?=
 =?utf-8?B?UFdEd2pBSTR0MFI3TkVaS3lMc0Eza3llNGdlWTdMTHVzaHNKNzg2ODFLUzRE?=
 =?utf-8?B?YjNZNFJEN21aQkpRdDRWNDN3TEpiWDhpZ2NlelZLQnl5ZmwyZjdnbjNSYU5t?=
 =?utf-8?B?Zml5c1lMKzZJQVMreExyZVJLUWQxK3ZZRVkwZW1hVzZiRVhnWFV4MG5xdElo?=
 =?utf-8?B?dkUzN2pvbFVJTkhzcXRLOGFYQUUxMEFoNkt0NkRWeURvZUxmajBPSk10bTJS?=
 =?utf-8?B?NDVnOUVEYjdvTStIK285R0VZeEdzQkJMSkhja1ZvWkM4Ni9yTkhOWTI1T21u?=
 =?utf-8?B?dmdWUzVJL3k3UDJJbmRQQUZvN0doa05BUWM1eHZ2VzFWWTFWNjBRWFZDWXRT?=
 =?utf-8?B?YUNwZkMxVkd2L0VpSE10NUc0OEF4M21RNzdxSUFlL3NteFQxV3Y3UW1vTC9i?=
 =?utf-8?B?bENMbzduM2JRNU9yazFEWlJJZ2Y1YTZEUFkvSm5SVTIwZGdTTmRkSGNkc0wy?=
 =?utf-8?B?OGg3UXE1b0hyeVhwWVowN01xbnlqTGlZMTY5ZmREZGJoWDVRSndDeUoreWFs?=
 =?utf-8?B?K2lWWVdxNUk5VDNZRDJZMXFTNHFRam45TndSMExTYVM1ajhiY2ozRUdnbWtQ?=
 =?utf-8?B?SFZzWXlpcm4xT1FTRzRvY3gzVWdxZUx5UTBJbzJ2Z3lvSWR6Yy9Hdm45am5u?=
 =?utf-8?B?VnVGMHdYR2JtemNvL3ZrcW5iRUtJK0J5VGwrRTloOFVQZ1ovQVZzTllHVFlZ?=
 =?utf-8?B?c3FlSzl4M1VKdlcrTnhDSEUvVXpnemJQY2E1MVBFT3RpMnNaWDRvaTdXMDFN?=
 =?utf-8?B?TFZEWkRIcnBGOVBEMG9WR0dTMWhNUTF2M2J5YitjVG4vbitUQ0U2UVcydWtr?=
 =?utf-8?B?STRnZW1qamlFTzMrR090UlI1dGdTZnBQS3lSdDlCcUhGZFR4a0Q3Zm4zY2ow?=
 =?utf-8?B?aElFMnZBL0ZDR2FsVXJQZndJL2xoSUJmajZQenNwVnZKcExyRjM1aXA2NUVU?=
 =?utf-8?B?dXVzUmdUL1UxMGR0aEhRcG5tekhUU1ltN05NcmVLa3RLemhZNnhtVUwzWjRL?=
 =?utf-8?B?ZThjREg5c2xtd1JjWHpZa3JyV01wb0tZTExHUmR0ZXZSR3I1U2s0eG9kWm94?=
 =?utf-8?B?NVZVY2xWcGFYMUhSNHJIWU1scDZ1ZS9uQkNZZ2hET1FWY3BhU01jUmxMeUtu?=
 =?utf-8?B?RFB4aUxKR1V4SVd3TlBFT05WYWtZMWJvTGd3WTVUbHUrSFRCT2NNVVF2TFAx?=
 =?utf-8?Q?wy/+Qe2s1hjQvLm+KzJAguCvv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8213087752218A4DA47AAB80DFF19610@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6b78672-0a19-474c-5d08-08db3ae213ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2023 23:11:27.0011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pljv74TmyYYlDFuNYDymf0rpmoLMwcb7222HKq+f319IPEoZjN03q3qiS0UCvJXzVvr7cKmXplKBG0XVc+6/8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8211
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+IA0KPiA+ID4gICAgYml0cyBmb3IgdGhlIHN1cHBvcnRlZCBmZWF0dXJlcy4NCj4gPiA+IC0g
QWRkIGt2bV9nZXRfYWN0aXZlX2NyM19jdHJsX2JpdHMoKSB0byBnZXQgdGhlIGFjdGl2ZSBjb250
cm9sIGJpdHMgdG8gZm9ybQ0KPiA+ID4gICAgYSBuZXcgZ3Vlc3QgQ1IzIChpbiB2bXhfbG9hZF9t
bXVfcGdkKCkpLg0KPiA+IEtWTSBoYW5kbGVzICNQRiBmb3Igc2hhZG93IE1NVSwgYW5kIGZvciBU
RFAgKEVQVCkgdGhlcmUncyBhbHNvIGEgY2FzZSB0aGF0IEtWTQ0KPiA+IHdpbGwgdHJhcCB0aGUg
I1BGIChzZWUgYWxsb3dfc21hbGxlcl9tYXhwaHlhZGRyKS4gIERvIHdlIG5lZWQgYW55IGhhbmRs
aW5nIHRvDQo+ID4gdGhlIGxpbmVhciBhZGRyZXNzIGluIHRoZSAjUEYsIGkuZS4gc3RyaXBwaW5n
IG1ldGFkYXRhIG9mZiB3aGlsZSB3YWxraW5nIHBhZ2UNCj4gPiB0YWJsZT8NCj4gPiANCj4gPiBJ
IGd1ZXNzIGl0J3MgYWxyZWFkeSBkb25lIGF1dG9tYXRpY2FsbHk/ICBBbnl3YXksIElNTyBpdCB3
b3VsZCBiZSBiZXR0ZXIgaWYgeW91DQo+ID4gY2FuIGFkZCBvbmUgb3IgdHdvIHNlbnRlbmNlcyBp
biB0aGUgY2hhbmdlbG9nIHRvIGNsYXJpZnkgd2hldGhlciBzdWNoIGhhbmRsaW5nDQo+ID4gaXMg
bmVlZGVkLCBhbmQgaWYgbm90LCB3aHkuDQo+IA0KPiBMQU0gbWFza2luZyBhcHBsaWVzIGJlZm9y
ZSBwYWdpbmcsIHNvIHRoZSBmYXVsdGluZyBsaW5lYXIgYWRkcmVzcyANCj4gZG9lc24ndCBjb250
YWluIHRoZSBtZXRhZGF0YS4NCj4gSXQgaGFzIGJlZW4gbWVudGlvbmVkIGluIGNvdmVyIGxldHRl
ciwgYnV0IHRvIGJlIGNsZWFyLCBJIHdpbGwgYWRkIHRoZSANCj4gY2xhcmlmaWNhdGlvbiBpbiB0
aGUgY2hhbmdlbG9nDQo+IG9mIHBhdGNoIDQuDQoNClllcyBJIHRoaW5rIHRoaXMgd2lsbCBiZSBo
ZWxwZnVsLiAgVGhhbmtzLg0KDQo=
