Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772B570BF2A
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 15:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbjEVNHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 09:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbjEVNHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 09:07:18 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A39100;
        Mon, 22 May 2023 06:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684760832; x=1716296832;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AzIpcKkqj6qzfAwfuKfEIjiGJQWriMaN7vUaKmgmaWA=;
  b=RHWhbPzpGSBradvuMAOOtusD5xRN8e5K2DjppbiN7g0tFkMS1rNAS/Di
   XssTA4MztWfUfd91hvHL1md/obWj4+QmWbZHXczLg67dl4aGCa6/WA6lT
   cp4RFfkevj5xMbCSQhzluQ+745L3k3bfxGG23owjZVIG2XY7+SYfmLpFB
   +Ue5wPoTGy5z9c+h3Vu7e+4yn5x34ohthTymgDWN1w23shsNIDnTxPKOj
   hXPC004PLQXrDkvDdsbyOHr+3wM0GJhQTmxgNo5mT3agaWT4H7MqDqYlS
   QYP0y7UOoo54/+5yuefslQYfEHiyXCd0byhNVZXTakwUuVfcs/D8AyNXp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="342366336"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="342366336"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 06:04:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="703495941"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="703495941"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 22 May 2023 06:04:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 06:04:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 06:04:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 06:04:41 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 06:04:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXS2RMcO55ChP1hITyRFCHCyVoRFpvBqCVMjUUuhNixJTb9yPThm2nVb5+l1m7olUlVDN8wCg0h7RBAsUXXGX11UGbFVg5/hMhw4GZQNx8KwM8fCEko9jgS5/iyW9Ks/rnum6L+2gsdCVllYkFYUkXEpESJ60IFnp0rglEkxUhdK8noqzMy/sXxCI/1z6Hf+1UszFEKJnt2S0oub22MHfG46IYMcKj0a3nUkJqQEzAQvkzAeEzKvKLvMmdXSYTlZQl6Vag1mPeOVi+ctkZDIv+Dgls3n5b4KSEQsOFRFKj1BqjhvMmmffUaaWGxk9MX0RsNR7lNEDLTPXSrHfBKqMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AzIpcKkqj6qzfAwfuKfEIjiGJQWriMaN7vUaKmgmaWA=;
 b=NKQ8mumRGQvowRfZbGD0zMYUxh7TRh5GXpSPeetNqWVe1d4W29Si9Gja84rttHuZPLyDQJtYt0HzqDWfgMWtxr+l3NGRHQs6//IlXpgZCsvNZ95uBFGVCA1VTs3AO34gm5XF1T/QRjvWVHTviEIwUt5ABC8EehEVCmVkfeTH4P9vO8JLVWKuJITzmgMSF9pr10Lm7SgbuC6kx4kPinfx0CEh+A7FRv/zBu3b9y13a18XT1lVt3+xCr2LIayhzLvRPS3MLb/jYnyWwswDw/XIAuamrgxK1AFTkkMXQP8ZJdnjlgyTYbfQebSKm0Q7bUyZD7eTgMbkccb5sv6qNHeeVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4840.namprd11.prod.outlook.com (2603:10b6:510:43::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 13:04:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 13:04:39 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 05/18] x86/reboot: Disable virtualization during reboot
 iff callback is registered
Thread-Topic: [PATCH v3 05/18] x86/reboot: Disable virtualization during
 reboot iff callback is registered
Thread-Index: AQHZhSyU1W7vpFnI9EqujWhEh9FvLq9mUZEA
Date:   Mon, 22 May 2023 13:04:39 +0000
Message-ID: <babc4cb3856dd5fc1bc6fa742e484667dc02c054.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-6-seanjc@google.com>
In-Reply-To: <20230512235026.808058-6-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB4840:EE_
x-ms-office365-filtering-correlation-id: 3a2f8823-d6ad-4d80-e793-08db5ac519ca
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7YhGHQdRxRyOmxcH3MRNTmsrwBJ6a9ZBh3YX6BR8W3pmKMZF6P+gr2p2spIsOk3IgHeugM+zpY/YaP5b3xpdf1SS00cP/lyyU3ETeBmjDTYL6Upsm7njWL5ZDve6UtVstkwTROBLJhHNGmRPOMGvrBL1XqhsFAOp6q3+WgCRoCktE5AfLdEGiBJ1lPvGNBvQvYmZdgzlg08+P7CKPk8VaHAHdC4TMr8ZTHGzwHnaDdhcoDzAp392qVXoMLjH+sKxCWircBuxAhLRj9sHNv27EIMovW0p+9hSN2V8upTpy9HN2p0zg+eqNlNUh7NEWPfYdMI5NYaY13wEKL40g7DwV8ztU+m2Qyz7rddXATIX1fKK32+yQMmqfr7dIiyL7/XIjiQElmPh2AjL8ZvFsVoD0K9yaUGZ1m/SdGxxozs3XeMKh7QgVjM1VHSXaT74VwBR+/6eqesnAsn04xbX4Yi7zg+QPl3nAsNBBh7DUWLwDJC3zpRcUPF2FAQHBEr4b3OCZWxUVVK0S3DpN4HejxVZ6x1qEI3Dr427Xx2bSTZzS7Q7ibCUE9Wfhbd+nxzYV+/kxhzou0BYG6eqyYswFUFTbogIdo6fqfdZKQEDwjHNQM6DGHXCvbPfplY/S48vkTmc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(396003)(366004)(346002)(451199021)(2906002)(110136005)(54906003)(5660300002)(8676002)(8936002)(41300700001)(91956017)(76116006)(316002)(66446008)(66476007)(66556008)(66946007)(478600001)(4326008)(36756003)(6486002)(64756008)(71200400001)(6506007)(6512007)(122000001)(38100700002)(86362001)(2616005)(26005)(186003)(83380400001)(38070700005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFdNZmZ1R1BjZExtSVZBOEgxNENhSllnelhUTWlaYklBM0xxV25aNlU1Vm1P?=
 =?utf-8?B?cUtNYkYrSFVtRVo1Qmk2YVdxeWVtZGpJeEV6Y0NlMTQ5bkl3YTFqTURQOUF1?=
 =?utf-8?B?L2Z0ZTVWTk1VQWhuOWdrL0trazFuUEo2WVVrakhmME9hQ0RnT1dkNFUvMUtW?=
 =?utf-8?B?QUxXZXVtKy9xNVY2WGRscUtqa3JwU1lnbWdMYTVrTTRoY2JkM0VZZHhkSU5u?=
 =?utf-8?B?V2srZUFQNzZVRzE5RzFCdUN6eDIvbitrVlJObDl2b0ZXNVZIbDJYWW10cmhH?=
 =?utf-8?B?NXYxSU5uWnFBeFVoR1pndGtRaTdrcE1kbDc2UUJzTDNEVmtWN3F0Y1crR3hi?=
 =?utf-8?B?YWlqK1pYem41dkZzMDExNFlBUThVTDk4a2VzNVFZWTJvWGs4SDNWQjg2aWZL?=
 =?utf-8?B?WlJZQ29CMzNjZXhYK2hDUnZPek1iK1pPQjVYVFZ1TTdjUEZ2cFRKOG42dUNQ?=
 =?utf-8?B?c2JOaXRzdEdITVhTYXEwUUVNR3VVN3FpRW8wM2dlUGxWYUZaeC9iSDJIRjhx?=
 =?utf-8?B?dmlRZE92Qyt1cUlwY0thOVMzc1MycTQ5OFRLWm4rdFU5aFdNc0NZRG9OOUpm?=
 =?utf-8?B?b3AwUE9vTHVBMGZQUW9lWXR1N1gxZkR1UUxTTmNmQVZDdTFCN0RlRW9CU01n?=
 =?utf-8?B?Wm5IR0lSeURqMUJWa2lwMTBCSmQ2cjVoRE9SL1R1NUtnLzZrcFZRdVVkdFhU?=
 =?utf-8?B?Um0rTmt0U25pWHJnc3lSR3gyZzBtazFVWjBKV0t3clhidFViSWhCYnJpbEVj?=
 =?utf-8?B?Y3doN1RTa2JhMjJOZnRmMUwwalhzc1N1TDBkRkZiMGJFbDJQblpuSmhUSTZu?=
 =?utf-8?B?VnNSNHFZVzY1VTBKZHd0aWt3NXBkRmVlZTNsd2YxVXZtOEJQK1o1YklFQkln?=
 =?utf-8?B?TGdndXhGTjJRZjJobnBVMEMxR1V1d1R5bDVzSnVQYTdUaXdiVmUrTjNUUDhq?=
 =?utf-8?B?aGUwalMweFliUmpIbWdlN1cyRGFUM1JkdzVMalVGT3Ywd010N3NvTzNlRzFu?=
 =?utf-8?B?bDFaK3FCSHpnOFdVNENHVlREK01NSXM2emFiZktURjJReEIxcnJTUzV1UEps?=
 =?utf-8?B?LzQ3TDg2WHJrL29sL2lGNUhoLzRQeEUxRlFlVDkxZ2pMd1lldGt1WHRPbWp2?=
 =?utf-8?B?Vnhrc281SUM2N21SOFZHWHFra3FaN3M0MVlONFI5S1pGVDBwRUxOWHQ5TFND?=
 =?utf-8?B?ZThQKzRHU0RmU0p0SXp5RzdSSmFWMUdaS0dEcWQ1ZUxrdkVBeTNFeTF3bGR2?=
 =?utf-8?B?MUxleFlnU1k1U3FTbkxEem1KQVBwQkxhZ050V0lHMGNjNmhOUXVWMHZ1YzY2?=
 =?utf-8?B?OGtmQTZOdmU0K2hCS2FvRTNuSjZFWnVhK1l6T2V0UGI4Vk91NlJWQzViTTZZ?=
 =?utf-8?B?U3MxU1FNUERXc2I3cE5TUHJ4ek5CdVFRVXZvYXF0dkhiODZ1QnA4OHZWeG1h?=
 =?utf-8?B?cGF3QXdsZXVHVzg2dmk4d0YydTJiUDBxczcrQ1d3MVVBRFlNcDhJUmFFcUQv?=
 =?utf-8?B?VG9oVUI2ek5oLzZVUVl3ZDdXZXZuRWlnbmNYNnNpQWdRUStnZlBwRjJHSUx5?=
 =?utf-8?B?TDlrQ3YybE9nWFExdWlmbDc0UXJKMDR5elgxLysxL1BJQkVuZkh6Tk5xb0tK?=
 =?utf-8?B?N1Q0aUh2a1lNYjY0dUNMWTRZU0tVZXU4R1Z5TnpEL29HaE5vQ2s0dmpvY3Nn?=
 =?utf-8?B?SG1CNlRXVDR0R21wbmd0dy8wQ3liQWJiM3dWTElEQ3l3dVJxb0xwNEJsd0hC?=
 =?utf-8?B?R09DdkdFZ1JTeFNOQlNkYTh0NUVFYXpuV3Z2dmF5SjBjZGV4RmZIRGYxclhl?=
 =?utf-8?B?WFVhakora2F5QzFJOXdaaDA0a2VQVHNlUXQ0KytiZWJLdGpRNW1mZG1oRzlY?=
 =?utf-8?B?VFBRSHJ5Vkc2S0tvVUxjNUordVQ3aWJZSi9XTFdQQlQ1SldueXAwVGtrOWl1?=
 =?utf-8?B?K2oySlBxWlVlL2pvSm5VeWozaURyajB0c29UTXNpWkE0VmhKQVRsTWJtakJr?=
 =?utf-8?B?bTNJZGxVdDVLenlmR0RGbENDaWtzbkJ2Tk9YRGhEMUl3a3lIaWg1emg4Z2Z5?=
 =?utf-8?B?TlM2VkhTVm1xUWgwdzdGajFwWjY1OC96WEErMTVEWnNWT05vRzJuZVNLQWUz?=
 =?utf-8?B?cFF5S05HYXlraWtPd2pkcCtza0UrYUtyQVFKMzgvWjd0M2E3Wlh1dzl5MmVK?=
 =?utf-8?B?a1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF57C121B82C874D86F63A47E305ED55@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a2f8823-d6ad-4d80-e793-08db5ac519ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 13:04:39.0427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zitr+K4ScmA18f8FMqOFxG26//DT3yq5Snpr2KeR+7VLu2Yk2ofEnXWUt5ZI4lzi4/stlouvFhVZHx71btc5pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4840
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA1LTEyIGF0IDE2OjUwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBdHRlbXB0IHRvIGRpc2FibGUgdmlydHVhbGl6YXRpb24gZHVyaW5nIGFuIGVtZXJn
ZW5jeSByZWJvb3QgaWYgYW5kIG9ubHkNCj4gaWYgdGhlcmUgaXMgYSByZWdpc3RlcmVkIHZpcnQg
Y2FsbGJhY2ssIGkuZS4gaWZmIGEgaHlwZXJ2aXNvciAoS1ZNKSBpcw0KPiBhY3RpdmUuICBJZiB0
aGVyZSdzIG5vIGFjdGl2ZSBoeXBlcnZpc29yLCB0aGVuIHRoZSBDUFUgY2FuJ3QgYmUgb3BlcmF0
aW5nDQo+IHdpdGggVk1YIG9yIFNWTSBlbmFibGVkIChiYXJyaW5nIGFuIGVncmVnaW91cyBidWcp
Lg0KPiANCj4gTm90ZSwgSVJRcyBhcmUgZGlzYWJsZWQsIHdoaWNoIHByZXZlbnRzIEtWTSBmcm9t
IGNvbWluZyBhbG9uZyBhbmQgZW5hYmxpbmcNCj4gdmlydHVhbGl6YXRpb24gYWZ0ZXIgdGhlIGZh
Y3QuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29v
Z2xlLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rZXJuZWwvcmVib290LmMgfCAzICstLQ0KPiAg
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9yZWJvb3QuYyBiL2FyY2gveDg2L2tlcm5lbC9yZWJv
b3QuYw0KPiBpbmRleCA5MmIzODBlMTk5YTMuLjIwZjdiZGFiYzUyZSAxMDA2NDQNCj4gLS0tIGEv
YXJjaC94ODYva2VybmVsL3JlYm9vdC5jDQo+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9yZWJvb3Qu
Yw0KPiBAQCAtMjIsNyArMjIsNiBAQA0KPiAgI2luY2x1ZGUgPGFzbS9yZWJvb3RfZml4dXBzLmg+
DQo+ICAjaW5jbHVkZSA8YXNtL3JlYm9vdC5oPg0KPiAgI2luY2x1ZGUgPGFzbS9wY2lfeDg2Lmg+
DQo+IC0jaW5jbHVkZSA8YXNtL3ZpcnRleHQuaD4NCj4gICNpbmNsdWRlIDxhc20vY3B1Lmg+DQo+
ICAjaW5jbHVkZSA8YXNtL25taS5oPg0KPiAgI2luY2x1ZGUgPGFzbS9zbXAuaD4NCj4gQEAgLTU0
NSw3ICs1NDQsNyBAQCBzdGF0aWMgdm9pZCBlbWVyZ2VuY3lfcmVib290X2Rpc2FibGVfdmlydHVh
bGl6YXRpb24odm9pZCkNCj4gIAkgKiBEbyB0aGUgTk1JIHNob290ZG93biBldmVuIGlmIHZpcnR1
YWxpemF0aW9uIGlzIG9mZiBvbiBfdGhpc18gQ1BVLCBhcw0KPiAgCSAqIG90aGVyIENQVXMgbWF5
IGhhdmUgdmlydHVhbGl6YXRpb24gZW5hYmxlZC4NCj4gIAkgKi8NCj4gLQlpZiAoY3B1X2hhc192
bXgoKSB8fCBjcHVfaGFzX3N2bShOVUxMKSkgew0KPiArCWlmIChyY3VfYWNjZXNzX3BvaW50ZXIo
Y3B1X2VtZXJnZW5jeV92aXJ0X2NhbGxiYWNrKSkgew0KPiAgCQkvKiBTYWZlbHkgZm9yY2UgX3Ro
aXNfIENQVSBvdXQgb2YgVk1YL1NWTSBvcGVyYXRpb24uICovDQo+ICAJCWNwdV9lbWVyZ2VuY3lf
ZGlzYWJsZV92aXJ0dWFsaXphdGlvbigpOw0KDQoNCklJVUMsIGZvciBjcHVfZW1lcmdlbmN5X2Rp
c2FibGVfdmlydHVhbGl6YXRpb24oKSBpdHNlbGYsIGxvb2tzIGl0J3MgT0sgdG8gbm90DQpoYXZp
bmcgdGhlIHBvaW50ZXIgY2hlY2ssIHNpbmNlIGl0IGludGVybmFsbHkgd2lsbCBkbyByY3VfZGVy
ZWZlcmVuY2UoKSBpbnNpZGUNClJDVSBjcml0aWNhbCBzZWN0aW9uIGFueXdheS4NCg0KQnV0IG5t
aV9zaG9vdGRvd25fY3B1c19vbl9yZXN0YXJ0KCkgaXMgY2FsbGVkIGFmdGVyDQpjcHVfZW1lcmdl
bmN5X2Rpc2FibGVfdmlydHVhbGl6YXRpb24oKSwgYW5kIGhhdmluZyB0aGUgcG9pbnRlciBjaGVj
ayBoZXJlIGNhbg0KYXZvaWQgc2VuZGluZyBOTUkgdG8gcmVtb3RlIGNwdXMgaWYgdGhlcmUncyBu
byBhY3RpdmUgaHlwZXJ2aXNvci4NCg0KQW0gSSBtaXNzaW5nIHNvbWV0aGluZz8gIElmIG5vdCwg
aXMgaXQgd29ydGggdG8gY2FsbCB0aGlzIG91dCBpbiBjaGFuZ2Vsb2c/DQoNCj4gIA0KPiAtLSAN
Cj4gMi40MC4xLjYwNi5nYTRiMWIxMjhkNi1nb29nDQo+IA0KDQo=
