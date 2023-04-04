Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A9F6D5706
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 05:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbjDDDJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 23:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjDDDJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 23:09:49 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521971705
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 20:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680577788; x=1712113788;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GXHobsov11Z+nKYWzbq6WNzW041/LGOLWhFpA07m7/4=;
  b=e84Ud1sqXdjXmMXp7cRkrdo8n93f26g1KEE/Fqpyp1FtiBJilQdo0mIS
   9pVCj/Xl78Dg1TkqUcMax2pR5c/Ze4pV4zLzVX7v/kSozz69vknr2BwDX
   QBFnZ/py9mw4v6FgwD3K8e/aT9LTVPOw8chd/sMMhADUyaKhSnkXNxaPs
   rm40E+58V6Fxwp/e729nkPyacwKPzQugCvKN3hUDJKfx5uunlarZFAR7J
   d6Wy2sOvUzaE0BAZh5bgAPr1sOBLqodk35WKqXCt5eEJMUOnmc88jm+Sr
   t6A7GrfWbXLQb1HfMo4P0Xdt1X8l8VE1RMGXvdb9UbTkVZZ7ns1vP1tFf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="407136951"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="407136951"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 20:09:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="688726471"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="688726471"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 03 Apr 2023 20:09:47 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 20:09:46 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 20:09:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 20:09:46 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 20:09:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaaGSl0Ir8rtPnS4VLtv+yx6VaOn4p/4cM7Qwu9O9cycypzpLLjQ8r/ja7A3d7+0CbKJLHo/KpokOHqSNfG2T8etIrndYJgcJ+JSfxBE14i6LL4+ZVxpXMkHla9te8Rk51uGd/NZrxquApx14Nins+Rl/jajmNdC3DXweq2f0R0HSieTSyHvZ+dVGakllJ2wuD7xSCpgfNfMw4Ki339zDWw7NxYzse+V6KrF48fQUFjO48LgUm09GdDX/TgtqB7q1b3ZAY8YyFslpe24gcOa/IMsWkyNlUqKB4gffARTW/HETSvgamvbqee55TLWWZ/EVa0vaGhH5bOtGEiyD6YIVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GXHobsov11Z+nKYWzbq6WNzW041/LGOLWhFpA07m7/4=;
 b=GDaW7qKJgbTUxVQJRX39Q5P/RWH3iRJ4/mUlev3UdR092yqxw77S9Z/MVoU4CyHlxTlk204mmPAa/DS2AbSnydl70TwunAhNXm6XAb/aog9aSb6+mQnSOaq+yhimU8Y1TR9vDgHiLVAHn8Vn3hRKSpZZBC8xreybNMHbyCiakwL2LWdPJX3fZTefpTeBkvLIgYgsEOropk63zTx8TzrfR3FJ9+iMf/CEhZdBFPuM72D5na8y6uNwhdfIH8H9lt6P0apuM8sWDzbPMRWJ7PeRa7xnZHtNeWj/D9AzFISaqujkWNE6BpMnDfZ9v8sB5wQuMR2PrPMhvn2U5COG3id9gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7539.namprd11.prod.outlook.com (2603:10b6:806:343::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 03:09:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6254.033; Tue, 4 Apr 2023
 03:09:44 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Thread-Topic: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Thread-Index: AQHZWj/xX+6sX0Ji9kGqSs4peyRxha8DnNOAgAIo0ACACyFUgIAAH6+AgAAKWgCAAAFNgIABArSAgABXIQCABpqMAIAAgp4AgADpvYCAAAkBgIAADo2AgAAGtIA=
Date:   Tue, 4 Apr 2023 03:09:43 +0000
Message-ID: <74a840d0042b6413963c3fd37ffb83e0a4866735.camel@intel.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
         <20230319084927.29607-3-binbin.wu@linux.intel.com>
         <ZBhTa6QSGDp2ZkGU@gao-cwp> <ZBojJgTG/SNFS+3H@google.com>
         <12c4f1d3c99253f364f3945a998fdccb0ddf300f.camel@intel.com>
         <e0442b13-09f4-0985-3eb4-9b6a20d981fb@linux.intel.com>
         <682d01dec42ecdb80c9d3ffa2902dea3b1d576dd.camel@intel.com>
         <b9e9dd1c-2213-81c7-cd45-f5cf7b86610b@linux.intel.com>
         <ZCR2PBx/4lj9X0vD@google.com>
         <657efa6471503ee5c430e5942a14737ff5fbee6e.camel@intel.com>
         <349bd65a-233e-587c-25b2-12b6031b12b6@linux.intel.com>
         <fc92490afc7ee1b9679877878de64ad129853cc0.camel@intel.com>
         <559ebca9-dfb9-e041-3744-5eab36f4f4c5@linux.intel.com>
         <71214e870df7c280e2f7ddcd264c73e3191958d9.camel@intel.com>
         <9d0b7b6e-9067-0ff6-c28b-358b2e39b5a8@linux.intel.com>
In-Reply-To: <9d0b7b6e-9067-0ff6-c28b-358b2e39b5a8@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7539:EE_
x-ms-office365-filtering-correlation-id: 461adaab-3cc0-4eb0-5fe6-08db34ba09fc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NIL4Iz8X1RZeO8mDAvjKx7X9EcM0SgxoirZZcXKdMiVJVh2u4+6UAuSq7f9gkec0RCgMiw4NVh1SNu9GXmQkDvOztBg/7HpArnPqpqNcisGx8emIbkJLCaVJby1sq91m+uUR/SwZzWJvuUxfin53D8FG/6BEQFY6L179+f5S2OMB/mi9QRIhGLsg2Kd/x2JFSlnKEMa7QAb8hk8+S4KYIAcWdO6sZKvYYRiTc1zspHqToFYvfrSPdunmyaMj1341KbVqs/lAR0LvH6Ravc+RhdiASTD2grthR5IDdi347G5gHfWR/V6eqjpUYMBkXRL28g1LdZNIl24JtAToJlHk2xJKa1QhIMQuUb6oIxFVcFzVjQyJXDKNutN3xEJbMDk/6ITAUNxAqm/+qwGfMYC1+G3V9UQUDbZ9J4gf+Z3kHh4YSHTpKjnU2GUepay7iA5IguFMWO44ayW54z1C0P0w15ZCCdGb6j4FZx128LXiVB+Wl/7WDgHqpYcSP6XsTyKH7ZoT6LgAPFhaFxGPbANd5/PfdZJtNKX7CVDSOybPpnyE8VtUs5gVqatv1Uz11/eKzRdiI8U43KJj1zi1cQUNibJ1Rqy0wVlrjZkNyIOAKWL75gI7aqj/D0J+Hk2K7WxV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199021)(41300700001)(82960400001)(66476007)(76116006)(64756008)(478600001)(66946007)(66446008)(66556008)(91956017)(8676002)(316002)(122000001)(110136005)(54906003)(4326008)(5660300002)(38100700002)(186003)(53546011)(71200400001)(2616005)(6486002)(6512007)(6506007)(26005)(86362001)(36756003)(2906002)(38070700005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVNQS1lqNWNXM0pUUCtHQ3A3YlU1VFptaVlMaHpqN2FOQXdOWEJNMkdUOGhq?=
 =?utf-8?B?R0xyNWF1R2dxMHVqLzdEVU9SNk1MOGIyemIwekdUUld5Rm1NWHhjajlMS1Yy?=
 =?utf-8?B?Qnk5OWdQUzY3Sjl1ODk2ZTJ3U1drN255V1ZNeHd5dTArUFl4eVA2dnpMMksw?=
 =?utf-8?B?MzhoQXlSYTFXb0xBQlhITHZOU21ERmR3ZTdCWUZyeExCVHVLZy9lWEhhN211?=
 =?utf-8?B?Vi9NRlk2VnNmcTgwU3VyQitjN2RTYVZSUDNUUzYvZ29NREFoZGROWUdzWSt1?=
 =?utf-8?B?UFRDVWRhTnhZWFV4Rzh3dnhlbWlUTGl5eFNENmxOdi8yc0k5MHhFNXkzeWJK?=
 =?utf-8?B?VGFNZFNxZXA3cnh5cnlubHhaMHIvQzNqMllvempSdWFLZkVEVlM0TEdCc2di?=
 =?utf-8?B?NU1RZW9JZWxONHRGWHhkZTNxWlRDOWVjOERDTzhEeEdXWVgwWG1KdVgzeXlY?=
 =?utf-8?B?THFvcTBWMGY0MkQ1cU1iajZwczBLWUxSYlF0bndvU0tVWVh0cnRTT2RWV0JE?=
 =?utf-8?B?OW5NZTh4U2ZSQnpkRm5LcldnKzRqWktzek5rRTMxWVlkejROcWltbXg1UDFR?=
 =?utf-8?B?RXNCUXVaaU5CcmREYkhCTWhoaTRWaERBcUtTRkZ6N1FsK09FQS9xOWFsZ1RQ?=
 =?utf-8?B?OUNhWDJpU01QdjFwd1RFWUt2NWFPdFBpcjZTOUlxNzZpRzRmdko3bFY1Nk5B?=
 =?utf-8?B?UkhSTk5XaW56R0VRYndYM1UxTWNnQnZ6V3puUjA3UGQxMEhTM0ZGV2UzamU0?=
 =?utf-8?B?R1ZEMUhaZ0hVTEdQbFkrV0RxOHhwWm5VRnEyWVkvTCtoWCtmWXd6cS8vbytU?=
 =?utf-8?B?MzZsR0V6dUdlQVk3cjdvT1Fab0Q4eVpnNkRHVXpBdzZmaUY5a1ZTeW5udTRw?=
 =?utf-8?B?WGVnSlpCSnIxcUE4L1dXZ2FrcnhHMzVob1JXd1VYWEgzK2FwN1BIb0dHUGpL?=
 =?utf-8?B?cXBCOVhkVC9Cblc0Uk5VekVDNHg2R2xKR2xHeDNKMTV1N2hsSXdjZkFwNGto?=
 =?utf-8?B?anY1VW5FV0lNNGphOWRFY29yMTlPZXorL2JGS21jRGNGTjhXV2k2M1JpekhL?=
 =?utf-8?B?bXpEeEwvQ21mWmNIbkdzQ3JZR1JKaGV6eXUxek44ZDBOMWZLSTVmbm5QU1dJ?=
 =?utf-8?B?U2s0Rk5SL0VqSElURVNkcTRVbGFpSVJWR3BQdzgyVWJOeW8yd3pSd0ZYZ2o4?=
 =?utf-8?B?eWNNcnByK3lSTHV3dVVMTEEzL1lvVm1WMDV1bk5iaERua3gwd3NaeGpGNnUr?=
 =?utf-8?B?bFl4Vm1HTjRSMnkxNURFcElYV0dMMk5lVTRPVVpwYUxYa0l2NjdCTTJJUXhK?=
 =?utf-8?B?RHJRaVBnRVllRFQzNmRuYS9tc081emVBdUhNM1NLMlFndm5wbDVnWEZDNEkx?=
 =?utf-8?B?TnZiSnIzSE1zWWQxYzZJamFUY3Z0dDh5dUNVNFVscFdFclJSSkpncXlDYzQw?=
 =?utf-8?B?Z2JvN0VCcTJodk9ub3ZvUnRZZFJkdlYrZEJnLzU5ZmJ3eml0WEY4azN2d1NL?=
 =?utf-8?B?VDVKNnc0N1lRVmtoaFlOU003aWlQVGJVeXRxL1pBTEFHaDFXTkdESFpON2VQ?=
 =?utf-8?B?aUtmMHVCcllnQi80Z2UzRFR1Qzlxd2JhMHJleis2c0p2QjV0c0drd2djSkhx?=
 =?utf-8?B?TU1TOTJMaUlCL3lzMTA5NGplNzhHMjRtKzl5eElOOWdPNUFNYUJKZEdHa3FB?=
 =?utf-8?B?bGw5NXhUNmw5WjZlVlFDdk85WFViZFJEenA3Q0xMc2NNWDVtUzZQQXVWcW9q?=
 =?utf-8?B?aVVLd3dhT1JKZnhBUzhHRmg2aUNRdWZ1YzFqSmJQdUk2ZWZtK0dGNitKbnQ5?=
 =?utf-8?B?Z0pqZnBpWDRINUpsOG8wN09ySnBkTHlYenFYV1A4RFdkaENQRUMwSmFkcXU5?=
 =?utf-8?B?MmdZSnRyOUFwOTdOQnR4OWpXNDVPSzdnSG0yKzJsZ2Q3dHVMejJQWUpVMXlz?=
 =?utf-8?B?ZTFuUm9sZFB5MFZSV3psUWREcU1jNlRNTnJQQ2xYVWpJZ09tZ1VDMGo1U1Zw?=
 =?utf-8?B?dDgxZEtnODRIcThJOVlFRkxxaUViRk9PL2d2K1pQd0lhRGwxOWw2SklnQ3lz?=
 =?utf-8?B?NUpoOFZ3RUVYSURrcWVubzF0dTc0WTNERit1MXRQWnhoS2MwZUVZeGRoc2R1?=
 =?utf-8?Q?kAyFsZan5/+EPiKa0SaHSXSHX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF6D1E17FFCADF408DA65BB6581A7704@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 461adaab-3cc0-4eb0-5fe6-08db34ba09fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 03:09:43.8776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: prTZic7kYMrecbB/0pJFZIgGgNRUvgBgG+xc3sttG5Awyq6TAg4KOu6HOE+2mCgvjKC/BcZ577SDb0Iyff6ncw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7539
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA0LTA0IGF0IDEwOjQ1ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IE9u
IDQvNC8yMDIzIDk6NTMgQU0sIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gT24gVHVlLCAyMDIzLTA0
LTA0IGF0IDA5OjIxICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4gPiBPbiA0LzMvMjAyMyA3
OjI0IFBNLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEFueXdheSwg
SSB3aWxsIHNlcGVyYXRlIHRoaXMgcGF0Y2ggZnJvbSB0aGUgTEFNIEtWTSBlbmFibGluZyBwYXRj
aC4gQW5kDQo+ID4gPiA+ID4gc2VuZCBhIHBhdGNoIHNlcGVyYXRlbHkgaWYNCj4gPiA+ID4gPiBu
ZWVkZWQgbGF0ZXIuDQo+ID4gPiA+ID4gDQo+ID4gPiA+IEkgdGhpbmsgeW91ciBjaGFuZ2UgZm9y
IFNHWCBpcyBzdGlsbCBuZWVkZWQgYmFzZWQgb24gdGhlIHBzZXVkbyBjb2RlIG9mIEVOQ0xTLg0K
PiA+ID4gWWVzLCBJIG1lYW50IEkgd291bGQgc2VwZXJhdGUgVk1YIHBhcnQgc2luY2UgaXQgaXMg
bm90IGEgYnVnIGFmdGVyIGFsbCwNCj4gPiA+IFNHWCB3aWxsIHN0aWxsIGJlIGluIHRoZSBwYXRj
aHNldC4NCj4gPiA+IA0KPiA+ID4gDQo+ID4gU2hvdWxkbid0IFNHWCBwYXJ0IGJlIGFsc28gc3Bs
aXQgb3V0IGFzIGEgYnVnIGZpeCBwYXRjaD8NCj4gPiANCj4gPiBEb2VzIGl0IGhhdmUgYW55dGhp
bmcgdG8gZG8gd2l0aCB0aGlzIExBTSBzdXBwb3J0IHNlcmllcz8NCj4gDQo+IEl0IGlzIHJlbGF0
ZWQgdG8gTEFNIHN1cHBvcnQgYmVjYXVzZSBMQU0gb25seSBlZmZlY3RpdmUgaW4gNjQtYml0IG1v
ZGUsDQo+IHNvIHRoZSB1bnRhZyBhY3Rpb24gc2hvdWxkIG9ubHkgYmUgZG9uZSBpbiA2NC1iaXQg
bW9kZS4NCj4gDQo+IElmIHRoZSBTR1ggZml4IHBhdGNoIGlzIG5vdCBpbmNsdWRlZCwgdGhhdCBt
ZWFucyBMQU0gdW50YWcgY291bGQgYmUgDQo+IGNhbGxlZCBpbiBjb21wYXRpYmxpdHkgbW9kZSBp
biBTR1ggRU5DTFMgaGFuZGxlci4NCj4gDQo+IA0KDQpZZXMgSSBnb3QgdGhpcyBwb2ludCwgYW5k
IHlvdXIgcGF0Y2ggNi83IGRlcGVuZHMgb24gaXQuDQoNCkJ1dCBteSBwb2ludCBpcyB0aGlzIGZp
eCBpcyBuZWVkZWQgYW55d2F5IHJlZ2FyZGxlc3MgdGhlIExBTSBzdXBwb3J0LCBhbmQgaXQNCnNo
b3VsZCBiZSBtZXJnZWQsIGZvciBpbnN0YW5jZSwgYXNhcCBhcyBhIGJ1ZyBmaXggKGFuZCBDQyBz
dGFibGUgcGVyaGFwcykgLS0NCndoaWxlIHRoZSBMQU0gc3VwcG9ydCBpcyBhIGZlYXR1cmUsIGFu
ZCBjYW4gYmUgbWVyZ2VkIGF0IGEgZGlmZmVyZW50IHRpbWUgZnJhbWUuDQoNCk9mIGNvdXJzZSBq
dXN0IG15IDJjZW50cyBhbmQgdGhpcyBpcyB1cCB0byBtYWludGFpbmVycy4NCg==
