Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF60C76DCE5
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 02:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjHCAwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 20:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbjHCAwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 20:52:10 -0400
Received: from mgamail.intel.com (unknown [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6504F2D4A
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 17:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691023928; x=1722559928;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e482nf7tF797SGwliwd0Qzgn2wofZ9ZqgSCO7jQ7few=;
  b=Cp9U8N1VlNqXdj2LV3/NqJxE9551Zu8OkCnx8Ym1GZK3zLI7TMheFyes
   ndf7ePNilknb4Syr7WuAI/ubcw823O2vMBIJ9qCxFYjhjrkU9AeGb5nuc
   sSXAH8T1JRN4vdEP0WI+lKTTkseZ/Ce9jhedOlFGiUdzjInWPE4wMPdxW
   ypKZ/iiNnTxNPEMEhlxF1f6vMvHs7NTyOIDeJCFNqTULZSeHCX0PX247L
   jqZP0mb/TZOUocTP2y0gEnjy0BkewAD9evEr52zflKiJGiOOaQWFOjQor
   dQbZsJBzdrr7mcNvGtc+axXBu70EyLObMWrQnzCr1gqL6u9JZQxfYZGYH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="433577452"
X-IronPort-AV: E=Sophos;i="6.01,250,1684825200"; 
   d="scan'208";a="433577452"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 17:52:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="729345534"
X-IronPort-AV: E=Sophos;i="6.01,250,1684825200"; 
   d="scan'208";a="729345534"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 02 Aug 2023 17:52:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 2 Aug 2023 17:52:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 2 Aug 2023 17:52:03 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 2 Aug 2023 17:52:03 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 2 Aug 2023 17:52:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8fnt9v0hFA8x7x690fzRCLEFLMTZaAcqGoOkCaakoai5mdpHzQ+h41L/Ogq8W+qVyJJN2JrQf/NUUN+1MlSZohlV5S98bnrKGMKdT20P3o+w+0kHG2axRV3oUZLAPHnnLFBDhgt4RVvAeaep7Jw7nsbUb6iRtqx5lBdinsRBUasVlyrEpc1rj9S3rTIWn2tyEq3dZ3DbEndTJ7Yz6W5+4/vu+NXnbjtjR5oxXzky6J3y7RLcqBzQbtf5BqXjUT83HsbJmmq+CTtjjOH5Sc6IPpnScFyc2J9AoNZrmUsDnIHcDSVBVAjcidBzuCNpB0tETI+kzy++SWDQ8/h20iQmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e482nf7tF797SGwliwd0Qzgn2wofZ9ZqgSCO7jQ7few=;
 b=c2ORosrE4Uf/YFKuXuHhyqmPJD4xyUjja7jJ4sx8J0JdW3oXawqQGgp9L8S+e77zCcAts1K/zSCJ1PWEWBN8dK7ycRvwOEhMElDWZJ3smJn4Ojr0s3tDAjmXc7c50jmMvagq+8E2eGRygdAp4GnDf5c4jAr0xokkhUghs6+06HBvDFAdMNba0k0QZjv3leTOzSVh9Xv4GTkZywL/M7EhdiW3esIF0LRxyhmR3kz/9fXWVvG1OSWWFbYT4ywhAaGhXR+YshC3XHX3x9Dg4fcGVunxdL5EiOc0P0GrOokwAUdv2llIGv9raesdZvOwySpiXmo8621zs+a8VwJtNF0wAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19)
 by CH0PR11MB5330.namprd11.prod.outlook.com (2603:10b6:610:bd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Thu, 3 Aug
 2023 00:52:01 +0000
Received: from MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c8f6:72a0:67fa:5032]) by MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c8f6:72a0:67fa:5032%7]) with mapi id 15.20.6652.020; Thu, 3 Aug 2023
 00:52:00 +0000
From:   "Zhang, Xiong Y" <xiong.y.zhang@intel.com>
To:     "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Yang, Weijiang" <weijiang.yang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "Liang, Kan" <kan.liang@intel.com>
Subject: RE: [PATCH v2] Documentation: KVM: Add vPMU implementaion and gap
 document
Thread-Topic: [PATCH v2] Documentation: KVM: Add vPMU implementaion and gap
 document
Thread-Index: AQHZxCyHa6M1ISGl8kSz6PMeAT2vNK/WhBeAgAE3pNA=
Date:   Thu, 3 Aug 2023 00:52:00 +0000
Message-ID: <MW4PR11MB58244C7211F68A8973C663E9BB08A@MW4PR11MB5824.namprd11.prod.outlook.com>
References: <20230801035836.1048879-1-xiong.y.zhang@intel.com>
 <e0e478bd-282b-68fa-7c94-8efbcc450750@linux.intel.com>
In-Reply-To: <e0e478bd-282b-68fa-7c94-8efbcc450750@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5824:EE_|CH0PR11MB5330:EE_
x-ms-office365-filtering-correlation-id: 6bcd00cf-fdec-4629-22a5-08db93bbd8a8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j4jXCmzdb5OUmPOgEbpznQpd9Mgp9yZNSKmyATdNig7n8zqSBHzJOdOwLm7yF0nw16mFwwRuynYFNTK2FGcgQ03LsWQRsbGDM/LEisZsK4+aHMP4dlGWtIarPIoruGdIuUYI2PmEbj4dFbnjA+vwAXjxwpZCeUWAmsZ4EyjmIBAYQbu3nzlIf0iBMP5k6x5WTioqoNs+vGKkdSxfSGGlAxSBSuL0AXC1d7rjTT0uPjvPkvFJ8xJpXlXqtn8l9OREh3eEnFip2XAJZh7LBZNMWc+FTvTylVtmyKKsxGbMhaIbwj8kU7OjQswCPn2ZeACdQHa7FnDolfVod8xPnpfLekvAh4/RYbTIxk6nrMHeu/wuLQcbi+yRPi3GKebkG6Y3lVvaMzf7iUi2kaAAWVSaRiD7mmcsTHUV5XlaeA9qN7bEHkO9d6X9lybk1ed3DtymbupbQv/GAEZaSrHRrKBqhmQKRVYgMSczVoqD4BssvnznBqGwo5iqg0E1JdT9JRL7lQ6U2FnxHQsl7T7D8+sSRAd6kcbP1DugXc1ROXWUXIXhniRTXts9a1Ib6eNtXYzDXNcywtLKJu2KPdqqY2xn3yW9pHLjyjG03Ix94W0Up2lnRPm0Bv0bW64dSwxd9PlR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(39860400002)(376002)(136003)(451199021)(38070700005)(86362001)(33656002)(55016003)(54906003)(478600001)(110136005)(38100700002)(122000001)(82960400001)(83380400001)(186003)(6506007)(26005)(41300700001)(8676002)(8936002)(52536014)(9686003)(71200400001)(7696005)(316002)(64756008)(66446008)(66476007)(66556008)(5660300002)(4326008)(76116006)(2906002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dDJxK3laQWlzbFEwQWZ4RnIzOWVDaEpzR29HMGxWcnE1YlNMaEhyQWxLNkwr?=
 =?utf-8?B?VElEYjBWZEpwM1dNMDN6TUhXWGxWRnE0dTdEQmdsTmRVMzRoelRLdWJNTmlV?=
 =?utf-8?B?akh3aDFEMmFhdnJvUCt2SllqMUZseVZVdGJPU2poOFNlTER6SzQ5RXpweTg5?=
 =?utf-8?B?SUhQMzNQL2ErSUpRL0cxL1lFdjd3am9JZWZoVHNOTTJvdm5DUVZnWGhtYXNj?=
 =?utf-8?B?T0JXY2tSQnp2NW0xNWpYM2lxV0hmcExaaE80bU5LK1BxRVNDdCtveXRlSXFL?=
 =?utf-8?B?OE0wcURBOENyakVFbDF0cVhTY3lsWjJuWEk5SXJXQXhPWC9NZml2S09STnpC?=
 =?utf-8?B?cERFSlBPQ3RkT3dKdGpIeW5zNzA5OTJpU296YVBsMUtxbE51eUtnak15L083?=
 =?utf-8?B?M2ljczZrajltWS9YN2MzNVM4aldCQVB4RGZnUzJUdCs2b2hVYkJwMUtHMzNH?=
 =?utf-8?B?U016WmxnY2FtdlNuSTlTRjA0ZVBib3p2aittZTgvazVhTWNYY05kQnJHU3Rt?=
 =?utf-8?B?OW4zcTZ2d2hXcHdkbytndXN6bFRHaVJidy8wMHpkVDJPWlcwN2hwYmdTVUpF?=
 =?utf-8?B?dTlrQ1lSNThDeXYyQkxoTnZhaGVYdS9BVTFDZGMwZ3Z3RUlES0lMVUI2Njk3?=
 =?utf-8?B?ZmMyMEpKWEJlV3FiQ0lUcmMyTVNRbk9vQzBja2orYXVnTWljajhNc3BoS3E3?=
 =?utf-8?B?bE5oTlVjdmhWakc2SUxFYWlod2tnQnVaYUtnSDUxVmJWWjMzbEY1WXZXZlZu?=
 =?utf-8?B?RUZDc2F6UXJaZUZGcmhHTTE0cmc5d3lNZU5UUnQ2cXVJc01PeDZyeUJ5WlJi?=
 =?utf-8?B?U0xMZnVCOE1EMldHRkFFVnYvV3NpUGFaWjlRYU5YaHM2cGdUTEhpVkRsbkMw?=
 =?utf-8?B?ZWdVTnErcVJHS3dqWWhlYWVwWE5UM1E1ODcvTXkzYmp1dTczdHhKeXNHZFc0?=
 =?utf-8?B?cDhUSlQ4NmxKcm5yQlBWTWJBOEc5MExxMWk1ay8zYTZneEV3OWN5bERtN1Zs?=
 =?utf-8?B?QmpGMis0L1h6SFRqODhsTDFsSFN4Y0tUOTc2aWhGVHNpL05xN0VGWDZ1SmFE?=
 =?utf-8?B?VEhJUXpGaTRUN2ZuMXdwZ0ozaEcwc0ZxelljeUl0NGxwVFY4OFRWVkpGU3Ra?=
 =?utf-8?B?YVV2RCttK08zOFg5NS81bmgrd1RNTkdYYmcwa0RMTDhBQkRBaFNsdFJvRVdQ?=
 =?utf-8?B?UW1GK2trVEtraUpJTUdhcmptcmJseVJYYnRFMWVJS1ErT0tYbmxNcTAvS3JF?=
 =?utf-8?B?VjIwRGhBaG5IbHV0UyszTkpmampMQzljZ3VoOFgxbWV6QVRJaEtsQ3FQdkpW?=
 =?utf-8?B?WHZYSWtSQWdGVHdnc0lIckhGTWNvK0NuRHdCWXVtYUlmeU9jT1pyQi91bGhD?=
 =?utf-8?B?M0w2N29mSUFSTVA2ZnZ6Qy8vNVNHeStZUWhxWGVaaXQxems2VytJQ0lub25M?=
 =?utf-8?B?Rnd5RnQyLzB6N1NjTm13SEl4WlFFTTlTNkw2U3pqeW5ZY1N1OUF3VHdhNG5O?=
 =?utf-8?B?T1A2SWZUUjdRUmNXSHE4bHU3SlZCbUZEODZhZXRsbENmTmdlc1FPUkRTMmpL?=
 =?utf-8?B?RVFybDBab1NMM21IWnhxdysyOXVhdGtkenV3emVId1Fac2hFL05vQ3lrb3or?=
 =?utf-8?B?MWlPejU0MEVDcGpRMFd2UHNlYzBla0F4dUFDQXF1L2plT3lNakU1MWx4YU5r?=
 =?utf-8?B?bWk4ZFdBVFhlcWhmUGV3TGJHS2sxVGY3eUJERkxORzQyOGlBMUM4SStvVmww?=
 =?utf-8?B?VE1aaHBNOFlISThnc0FOdjZlM3kzc0l6QmRYdFZybnFHTzBoQkRGeVpUcnp4?=
 =?utf-8?B?NTJiTFNnYWFGU2pab01EUGlHUjJ6YWFOZ3I2ZjBzR1cwWjFmQ01KVVMrcHdm?=
 =?utf-8?B?SGZLa1VNTTgyb1dOU2pvZXFqZngzZWJxdlhFdHVoMmxoNHo0bmM1bGE5b0Zw?=
 =?utf-8?B?RmNXQko1Z0o0QVQvYkZ0aTNBWmpZdjRVUi95dzc1SStsZkdyTFZQcXRuYktt?=
 =?utf-8?B?anU4YVdnemxnRkdDb0dKQ3pRcHltbm16cnlEVXovRDlRaVBOKzhGUXl6SWJx?=
 =?utf-8?B?ZzBQS20vb0QyS1I4YmlYR0hSSDB3UXUwLzVjVXhpM25QcG1IbnZxTTZTMlJC?=
 =?utf-8?Q?HBy70hLC3cY1yXUUd3khK8xwt?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bcd00cf-fdec-4629-22a5-08db93bbd8a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 00:52:00.6053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mMkrmHT+XOxCsOcnMuuOzvi9qIDzt7ZY35FY96UtPr8+hmjKjx4hRUnA0ORGqx/V9Tvqft6jGMioEv/rIR046w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5330
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+ICsNCj4gPiArMy4gQXJjaCBQTVUgdmlydHVhbGl6YXRpb24NCj4gPiArPT09PT09PT09PT09
PT09PT09PT09PT09PT0NCj4gPiArDQo+ID4gKzMuMS4gT3ZlcnZpZXcNCj4gPiArLS0tLS0tLS0t
LS0tLQ0KPiA+ICsNCj4gPiArT25jZSBLVk0vUUVNVSBleHBvc2UgdmNwdSdzIEFyY2ggUE1VIGNh
cGFiaWxpdHkgaW50byBndWVzdCwgdGhlIGd1ZXN0DQo+ID4gK1BNVSBkcml2ZXIgd291bGQgYWNj
ZXNzIHRoZSBBcmNoIFBNVSBNU1JzIChpbmNsdWRpbmcgRml4ZWQgYW5kIEdQDQo+ID4gK2NvdW50
ZXIpIGFzIHRoZSBob3N0IGRvZXMuIEFsbCB0aGUgZ3Vlc3QgQXJjaCBQTVUgTVNScyBhY2Nlc3Np
bmcgYXJlDQo+ID4gK2ludGVyY2VwdGFibGUuDQo+ID4gKw0KPiA+ICtXaGVuIGEgZ3Vlc3Qgdmly
dHVhbCBjb3VudGVyIGlzIGVuYWJsZWQgdGhyb3VnaCBndWVzdCBNU1Igd3JpdGluZywNCj4gPiAr
dGhlIEtWTSB0cmFwIHdpbGwgY3JlYXRlIGEga3ZtIHBlcmYgZXZlbnQgdGhyb3VnaCB0aGUgcGVy
ZiBzdWJzeXN0ZW0uDQo+ID4gK1RoZSBrdm0gcGVyZiBldmVudCdzIGF0dHJpYnV0ZSBpcyBnb3R0
ZW4gZnJvbSB0aGUgZ3Vlc3QgdmlydHVhbA0KPiA+ICtjb3VudGVyJ3MgTVNSIHNldHRpbmcuDQo+
ID4gKw0KPiA+ICtXaGVuIGEgZ3Vlc3QgY2hhbmdlcyB0aGUgdmlydHVhbCBjb3VudGVyJ3Mgc2V0
dGluZyBsYXRlciwgdGhlIEtWTQ0KPiA+ICt0cmFwIHdpbGwgcmVsZWFzZSB0aGUgb2xkIGt2bSBw
ZXJmIGV2ZW50IHRoZW4gY3JlYXRlIGEgbmV3IGt2bSBwZXJmDQo+ID4gK2V2ZW50IHdpdGggdGhl
IG5ldyBzZXR0aW5nLg0KPiA+ICsNCj4gPiArV2hlbiBndWVzdCByZWFkIHRoZSB2aXJ0dWFsIGNv
dW50ZXIncyBjb3VudCBudW1iZXIsIHRoZSBrdm0gdHJhcCB3aWxsDQo+ID4gK3JlYWQga3ZtIHBl
cmYgZXZlbnQncyBjb3VudGVyIHZhbHVlIGFuZCBhY2N1bXVsYXRlIGl0IHRvIHRoZSBwcmV2aW91
cw0KPiA+ICtjb3VudGVyIHZhbHVlLg0KPiA+ICsNCj4gPiArV2hlbiBndWVzdCBubyBsb25nZXIg
YWNjZXNzIHRoZSB2aXJ0dWFsIGNvdW50ZXIncyBNU1Igd2l0aGluIGENCj4gPiArc2NoZWR1bGlu
ZyB0aW1lIHNsaWNlIGFuZCB0aGUgdmlydHVhbCBjb3VudGVyIGlzIGRpc2FibGVkLCBLVk0gd2ls
bA0KPiA+ICtyZWxlYXNlIHRoZSBrdm0gcGVyZiBldmVudC4NCj4gPiArDQo+ID4gKyAgLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICsgIHwgIEd1ZXN0ICAgICAgICAgICAgICAgICAg
IHwNCj4gPiArICB8ICBwZXJmIHN1YnN5c3RlbSAgICAgICAgICB8DQo+ID4gKyAgLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICsgICAgICAgfCAgICAgICAgICAgIF4NCj4gPiArICB2
TVNSIHwgICAgICAgICAgICB8IHZQTUkNCj4gPiArICAgICAgIHYgICAgICAgICAgICB8DQo+ID4g
KyAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICsgIHwgIHZQTVUgICAgICAgIEtW
TSB2Q1BVICAgIHwNCj4gPiArICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gKyAg
ICAgICAgfCAgICAgICAgICBeDQo+ID4gKyAgQ2FsbCAgfCAgICAgICAgICB8IENhbGxiYWNrcw0K
PiA+ICsgICAgICAgIHYgICAgICAgICAgfA0KPiA+ICsgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQ0KPiA+ICsgIHwgSG9zdCBMaW51eCBLZXJuZWwgICAgICAgfA0KPiA+ICsgIHwgcGVyZiBz
dWJzeXN0ZW0gICAgICAgICAgfA0KPiA+ICsgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0K
PiA+ICsgICAgICAgICAgICAgICB8ICAgICAgIF4NCj4gPiArICAgICAgICAgICBNU1IgfCAgICAg
ICB8IFBNSQ0KPiA+ICsgICAgICAgICAgICAgICB2ICAgICAgIHwNCj4gPiArICAgICAgICAgLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCj4gPiArCSB8IFBNVSAgICAgICAgQ1BVICAgfA0KPiA+ICsgICAg
ICAgICAtLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICsNCj4gPiArRWFjaCBndWVzdCB2aXJ0dWFs
IGNvdW50ZXIgaGFzIGEgY29ycmVzcG9uZGluZyBrdm0gcGVyZiBldmVudCwgYW5kDQo+ID4gK3Ro
ZSBrdm0gcGVyZiBldmVudCBqb2lucyBob3N0IHBlcmYgc2NoZWR1bGVyIGFuZCBjb21wbGllcyB3
aXRoIGhvc3QNCj4gPiArcGVyZiBzY2hlZHVsZXIgcnVsZS4gV2hlbiBrdm0gcGVyZiBldmVudCBp
cyBzY2hlZHVsZWQgYnkgaG9zdCBwZXJmDQo+ID4gK3NjaGVkdWxlciBhbmQgaXMgYWN0aXZlLCB0
aGUgZ3Vlc3QgdmlydHVhbCBjb3VudGVyIGNvdWxkIHN1cHBseSB0aGUgY29ycmVjdA0KPiB2YWx1
ZS4NCj4gPiArSG93ZXZlciwgaWYgYW5vdGhlciBob3N0IHBlcmYgZXZlbnQgY29tZXMgaW4gYW5k
IHRha2VzIG92ZXIgdGhlIGt2bQ0KPiA+ICtwZXJmIGV2ZW50IHJlc291cmNlLCB0aGUga3ZtIHBl
cmYgZXZlbnQgd2lsbCBiZSBpbmFjdGl2ZSwgdGhlbiB0aGUNCj4gPiArdmlydHVhbCBjb3VudGVy
IGtlZXBzIHRoZSBzYXZlZCB2YWx1ZSB3aGVuIHRoZSBrdm0gcGVyZiBldmVudCBpcw0KPiA+ICtw
cmVlbXB0ZWQuIEJ1dCBndWVzdCBwZXJmIGRvZXNuJ3Qgbm90aWNlIHRoZSB1bmRlcmJlYWNoIHZp
cnR1YWwNCj4gPiArY291bnRlciBpcyBzdG9wcGVkLCBzbyB0aGUgZmluYWwgZ3Vlc3QgcHJvZmls
aW5nIGRhdGEgaXMgd3JvbmcuDQo+ID4gKw0KPiA+ICszLjIuIEhvc3QgYW5kIEd1ZXN0IHBlcmYg
ZXZlbnQgY29udGVudGlvbg0KPiA+ICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQ0KPiA+ICsNCj4gPiArS3ZtIHBlcmYgZXZlbnQgaXMgYSBwZXItcHJvY2VzcyBwaW5u
ZWQgZXZlbnQsIGl0cyBwcmlvcml0eSBpcyBzZWNvbmQuDQo+ID4gK1doZW4ga3ZtIHBlcmYgZXZl
bnQgaXMgYWN0aXZlLCBpdCBjYW4gYmUgcHJlZW1wdGVkIGJ5IGhvc3QgcGVyLWNwdQ0KPiA+ICtw
aW5uZWQgcGVyZiBldmVudCwgb3IgaXQgY2FuIHByZWVtcHQgaG9zdCBmbGV4aWJsZSBwZXJmIGV2
ZW50cy4gU3VjaA0KPiA+ICtwcmVlbXB0aW9uIGNhbiBiZSB0ZW1wb3JhcmlseSBwcm9oaWJpdGVk
IHRocm91Z2ggZGlzYWJsaW5nIGhvc3QgSVJRLg0KPiA+ICsNCj4gPiArVGhlIGZvbGxvd2luZyBy
ZXN1bHRzIGFyZSBleHBlY3RlZCB3aGVuIGhvc3QgYW5kIGd1ZXN0IHBlcmYgZXZlbnQNCj4gPiAr
Y29leGlzdCBhY2NvcmRpbmcgdG8gcGVyZiBzY2hlZHVsZXIgcnVsZToNCj4gPiArMSkuIGlmIGhv
c3QgcGVyIGNwdSBwaW5uZWQgZXZlbnRzIG9jY3VweSBhbGwgdGhlIEhXIHJlc291cmNlLCBrdm0N
Cj4gPiArcGVyZiBldmVudCBjYW4gbm90IGJlIGFjdGl2ZSBhcyBubyBhdmFpbGFibGUgcmVzb3Vy
Y2UsIHRoZSB2aXJ0dWFsDQo+ID4gK2NvdW50ZXIgdmFsdWUgaXMgIHplcm8gYWx3YXlzIHdoZW4g
dGhlIGd1ZXN0IHJlYWRzIGl0Lg0KPiA+ICsyKS4gaWYgaG9zdCBwZXIgY3B1IHBpbm5lZCBldmVu
dCByZWxlYXNlIEhXIHJlc291cmNlLCBhbmQga3ZtIHBlcmYNCj4gPiArZXZlbnQgaXMgaW5hY3Rp
dmUsIGt2bSBwZXJmIGV2ZW50IGNhbiBjbGFpbSB0aGUgSFcgcmVzb3VyY2UgYW5kDQo+ID4gK3N3
aXRjaCBpbnRvIGFjdGl2ZSwgdGhlbiB0aGUgZ3Vlc3QgY2FuIGdldCB0aGUgY29ycmVjdCB2YWx1
ZSBmcm9tIHRoZQ0KPiA+ICtndWVzdCB2aXJ0dWFsIGNvdW50ZXIgZHVyaW5nIGt2bSBwZXJmIGV2
ZW50IGlzIGFjdGl2ZSwgYnV0IHRoZSBndWVzdA0KPiA+ICt0b3RhbCBjb3VudGVyIHZhbHVlIGlz
IG5vdCBjb3JyZWN0IHNpbmNlIGNvdW50ZXIgdmFsdWUgaXMgbG9zdCBkdXJpbmcNCj4gPiAra3Zt
IHBlcmYgZXZlbnQgaXMgaW5hY3RpdmUuDQo+ID4gKzMpLiBpZiBrdm0gcGVyZiBldmVudCBpcyBh
Y3RpdmUsIHRoZW4gaG9zdCBwZXIgY3B1IHBpbm5lZCBwZXJmIGV2ZW50DQo+ID4gK2JlY29tZXMg
YWN0aXZlIGFuZCByZWNsYWltcyBrdm0gcGVyZiBldmVudCByZXNvdXJjZSwga3ZtIHBlcmYgZXZl
bnQNCj4gPiArd2lsbCBiZSBpbmFjdGl2ZS4gRmluYWxseSB0aGUgdmlydHVhbCBjb3VudGVyIHZh
bHVlIGlzIGtlcHQgdW5jaGFuZ2VkDQo+ID4gK2FuZCBzdG9yZXMgcHJldmlvdXMgc2F2ZWQgdmFs
dWUgd2hlbiB0aGUgZ3Vlc3QgcmVhZHMgaXQuIFNvIHRoZSBndWVzdA0KPiA+ICt0b3RhbCBjb3Vu
dGVyIGlzbid0IGNvcnJlY3QuDQo+ID4gKzQpLiBJZiBob3N0IGZsZXhpYmxlIHBlcmYgZXZlbnRz
IG9jY3VweSBhbGwgdGhlIEhXIHJlc291cmNlLCBrdm0gcGVyZg0KPiA+ICtldmVudCBjYW4gYmUg
YWN0aXZlIGFuZCBwcmVlbXB0cyBob3N0IGZsZXhpYmxlIHBlcmYgZXZlbnQgcmVzb3VyY2UsDQo+
ID4gK3RoZSBndWVzdCBjYW4gZ2V0IHRoZSBjb3JyZWN0IHZhbHVlIGZyb20gdGhlIGd1ZXN0IHZp
cnR1YWwgY291bnRlci4NCj4gPiArNSkuIGlmIGt2bSBwZXJmIGV2ZW50IGlzIGFjdGl2ZSwgdGhl
biBvdGhlciBob3N0IGZsZXhpYmxlIHBlcmYgZXZlbnRzDQo+ID4gK3JlcXVlc3QgdG8gYWN0aXZl
LCBrdm0gcGVyZiBldmVudCBzdGlsbCBvd24gdGhlIHJlc291cmNlIGFuZCBhY3RpdmUsDQo+ID4g
K3NvIHRoZSBndWVzdCBjYW4gZ2V0IHRoZSBjb3JyZWN0IHZhbHVlIGZyb20gdGhlIGd1ZXN0IHZp
cnR1YWwgY291bnRlci4NCj4gPiArDQo+ID4gKzMuMy4gdlBNVSBBcmNoIEdhcHMNCj4gPiArLS0t
LS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICsNCj4gPiArVGhlIGNvZXhpc3Qgb2YgaG9zdCBhbmQgZ3Vl
c3QgcGVyZiBldmVudHMgaGFzIGdhcDoNCj4gPiArMSkuIHdoZW4gZ3Vlc3QgYWNjZXNzZXMgUE1V
IE1TUnMgYXQgdGhlIGZpcnN0IHRpbWUsIEtWTSB3aWxsIHRyYXAgaXQNCj4gPiArYW5kIGNyZWF0
ZSBrdm0gcGVyZiBldmVudCwgYnV0IHRoaXMgZXZlbnQgbWF5IGJlIGluYWN0aXZlIGJlY2F1c2Ug
dGhlDQo+IA0KPiBpbmFjdGl2ZT8gSXQgc2VlbXMgdGhlIGV2ZW50IHNob3VsZCBlbnRlciBlcnJv
ciBzdGF0ZSBiYXNlIG9uIHByZXZpb3VzDQo+IGRlc2NyaXB0aW9uPw0KW1poYW5nLCBYaW9uZyBZ
XSB5ZXMsIHRoZSBjb2RlIHdpbGwgcHV0IGl0IGludG8gZXJyb3Igc3RhdGUuIEkgdXNlZCBpbmFj
dGl2ZSBpbnN0ZWFkIG9mIGVycm9yIGluIGFsbCB0aGUgdlBNVSBzZWN0aW9uLCBteSBpbnRlbnRp
b24gaXMgdG8gbWFrZSB0aGluZyBlYXNpZXIgdG8gdW5kZXJzdGFuZCBpZiByZWFkZXIgaXMgbm90
IGZhbWlsaWFyIHdpdGggcGVyZiBzY2hlZHVsZXIsIGFuZCBpbXBsaWVzIHRoaXMgc3RhdGUgaXMg
cmVjb3ZlcmFibGUuIEkgc2hvdWxkIGNoYW5nZSBpdCB0byBlcnJvciBzdGF0ZSBzaW5jZSBwZXJm
IHNjaGVkdWxlciBzZWN0aW9uIGhhcyBpbnRyb2R1Y2VkIHRoaXMuDQoNCnRoYW5rcw0KDQo=
