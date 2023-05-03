Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57B96F6214
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 01:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjECX1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 19:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjECX1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 19:27:05 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43703900C;
        Wed,  3 May 2023 16:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683156414; x=1714692414;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+mpmtxrhKdGxxH5Au+N7xOS5hGvO4K2btQTEJd/T+iU=;
  b=hWOSUlT+6mFGGP+tMHmaMhxzZWs62ZF2AUZkcUUQmINvSZw8QyLtoD3d
   YmNpgG2TaWfh2wgr871F2r+pmxp3iA+kocizu1aAKpOZAsk8Qba5iVwiy
   B4yGg7GwqnHoIYfooBLwwy+RWIpp048aIeiA5P2EY6kXDuBqW8Z+qeWEI
   Alc5FH9OKxBAVQdzoYfsQ9LgH8KvACML0C3JnP0jjsRJUKSB3/oDYy3GN
   gvHaYyuxHgIoncWT5ndylL9nV2KKSUBEzcCb7OXlNaJRfgq1U7i1lEcyY
   R7IInieOPbzTF08GJxFQvpp9HBhy3ILzQIICOsdMRT4a5JHEkqB3JiL5x
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="346261889"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="346261889"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 16:26:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="674292201"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="674292201"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 03 May 2023 16:26:53 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 16:26:53 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 16:26:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 16:26:53 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 16:26:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCuhaIQxYJ9Q2OKUns3Q0wEW+7a861YgXTSeHC3+Gr5Cxut2aRLkx+cSGrvEA2u9ySPryGiehfe6gIRPlHfLwl9TjyTSTxDIP6lXinqoL2M7BPVfachpITltNOnog6Rru4Wqdie3e9jj9FduWf6tkHoRAosjfID4jS9NXEl9KrVBznFxC+MMLvSF2fOLC3Gq/BEmb50Qoy4M7qhMUJyK42dUzF9LTFiG0wkstHlxZ2q1otNObnWr8dqzBY0xv1dnkT28kIycPFZ/i7ldsTtb81XGpv8I7IGKFGsbbci9OefP+CkwTCkHXU1QJrF0xDQY0OX/TX9qjGv3swc1RB0h4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+mpmtxrhKdGxxH5Au+N7xOS5hGvO4K2btQTEJd/T+iU=;
 b=oKjZJTFAJ0dfKqUY/Xf4K/U728aPrBr5+NP6KAyHSdiN8x7DQBqILB970XHO4BtnDAR7V4PqbfOMw495cipNyP0Mu6NRp3/YIbMcAue2jR4BKKDPgz0PIw8RRb8y0CnHOsJnhjkQiRuNjeYm4CeOKaxYaUdH0ZpoeaGSl3+IZaKjY+nqzR76ky90irmPxa4s1zzj214FrRqr6GJDru7F3JgRodyEyzqPVrHTvDCTz/euqgWEqfWW6T+H62im0//0G8fU5LsuR253qwlNWMF0DYgve4gkzuJ1T/qVw6TM1W8FXIicWvk6u19VYvhUyyDAMW2iIMVDokfmzQMXjpiGUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5415.namprd11.prod.outlook.com (2603:10b6:208:315::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Wed, 3 May
 2023 23:26:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6340.031; Wed, 3 May 2023
 23:26:44 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Subject: Re: [PATCH 4/5] KVM: x86: WARN if writes to PAT MSR are handled by
 common KVM code
Thread-Topic: [PATCH 4/5] KVM: x86: WARN if writes to PAT MSR are handled by
 common KVM code
Thread-Index: AQHZfe1fgDsOc07/Ak+IAVOvOLh1Jq9JMZQA
Date:   Wed, 3 May 2023 23:26:44 +0000
Message-ID: <47e0d0cd1452383646a2cc9972f765b469fc51a6.camel@intel.com>
References: <20230503182852.3431281-1-seanjc@google.com>
         <20230503182852.3431281-5-seanjc@google.com>
In-Reply-To: <20230503182852.3431281-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5415:EE_
x-ms-office365-filtering-correlation-id: ce70480e-97d5-486b-4658-08db4c2ddbc4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1ugedGoFlJEDMuSTNzazfVcEdeQS2se38gL4it4m7kL7sXjZ7WC8ttLI1SdIypqB3xGCQk5Abyv2G6UqpHjCopbfZysdwZtOPEbuZPqv9ipm3LiZl/Z5IRD32lIK1sb0gAL/q0ws4sdXE+XQKZOqxq1wn7DPc0DUoFJqeuq6b0vdYgHrx4bbvibsm6RAKbl79eyPrM/jvjw7vvz3j3V0AL2jAUxuguq9tF+digCAcm9EMiRspEjivbgkgI+ZHWwh0QQOW2MFIeel7z5cHCym0spSdEs4idEaM4xWiDixmkBPBgcxmFZfeww7NdN+qAPXGk2SXSd9TPiUPhtZGZHCCEsIAGgJEtE3oVjgy10HlbNU0vxwbQVWDxe2tBNOiBho4rSjSwEHx1zCUKm9vsRnlqt+h0x/N+f2j3+a4/ul09cDeGUkPETItX7TC0gEuE55whrj+bqu1oBUkzVleIHPjt7w9M6L1agbCkfOwcolg8FWLvqZ1jJMmTFvCcndz7ZllBU3Z/bdZV/CtrZB3rR9XHwbO/POUwaF8lqIvNm3I49SQMdyCFKBXISiNg7iV/uQ+KY3NYddccDM89sdoRQYw6neNjSUrdS7M83rAL3sx2bUW/A2qWrw7RVRbEaKW/hH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199021)(36756003)(86362001)(91956017)(54906003)(316002)(110136005)(66946007)(66476007)(66556008)(64756008)(4326008)(6486002)(76116006)(66446008)(478600001)(71200400001)(41300700001)(2906002)(8676002)(8936002)(5660300002)(2616005)(38100700002)(82960400001)(122000001)(38070700005)(186003)(6506007)(26005)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NTY2RzdrSzNvbW96d2tSdklHcWJqL3FvUCtIOFZwTm96MmxacHFqTWVDYzVG?=
 =?utf-8?B?S2N0cmNWK3dFWGY5QzQzL2lMaERCTjBLYWNIRGhKR3A4OFc4WWIrUHoxdHMr?=
 =?utf-8?B?SmlDVVdDdUdRa29oeU5vL3dobkc0dGJDUUFyb09BYk5pOCtRanhoTGMyWExj?=
 =?utf-8?B?QmZ0SHpJNjg5Zk5rSENhODBoUmxybVlMZE9zMVJOaVplZVR0SFdRNHhQTElF?=
 =?utf-8?B?V09razVjemRtZFlIY0RaR3Ridk41K0x6dkRLTkcyMmNpVzQ2UE9qYTRNSkRy?=
 =?utf-8?B?ODVKNDlLdXlEQ0tYSmdEZlpwejVKeDAvdUg1dFFRWGJWZVAybDlUQWIzUFBr?=
 =?utf-8?B?Z1F6Mnl0ODVaeHgvNnhLaWFQeEZrQVR4WjNzM29uRy9yR2tkQ01OV3JNOHMy?=
 =?utf-8?B?SS9oRmxFeFExa1NPZU1XYjRrOVppWjZCUnIxK25pV1VOTXBaci8zV3dpeFk5?=
 =?utf-8?B?bXpFcTd5V3FBNEdGUGhmVFRlOWRDWlgvYWJIOVVJVWx4elVGTU93OWlKUjZj?=
 =?utf-8?B?ZDQ5SDhYTGJXNGdkMFpyQmVLYWtVL2wzVUxraS9EYzBRUHJ2Zkg3OVVtQzRl?=
 =?utf-8?B?V2dTcmNqUGJndzlBY1kwZkg3VWZhcnJPbmkzc3lLYktIRkZFZ1UybE1pQTZk?=
 =?utf-8?B?bktkVEE0RGZDcVdadUtvSnRGWmNrV2VVUzZwRmRUemdsYitzVUh5VXoxTkpr?=
 =?utf-8?B?bHZzZGxlbjFLcy9Ya3lMcVdXNERVVFlQMi9IejE4NTJXS1BZY3g4d3llVnJE?=
 =?utf-8?B?VVhuVGZ5OHZDcDV5Wk9mNjduWTZTMENZcEw5QTNMU3lhQ2RBcUhxR01uaXU1?=
 =?utf-8?B?V0tnM2pYaU5xdEdTVzJzR1FvWGRPQ05GU2Z1VGxjRnhwRUVzZldGS1c1MlZX?=
 =?utf-8?B?ZFc3UGtNdTJpMFpqUWQ3YmNHUmlQcWFaMmhBNnN2Y3lFTklBbk1aK05oUW5J?=
 =?utf-8?B?VTg5OUdaUWkwclozOVpmREg0MVhqbjdhQzYwZFh5SGFzVmJTdFQ1cFNFb2Uv?=
 =?utf-8?B?WnNzUWg2N1BacmZPaTMzdExTYW85eWJqYUhJNWd3Vk1kaGxtc0pkUVpKNmov?=
 =?utf-8?B?ZldJVktWZEpRdjV3Y3JYY3pBRSswbnJsUStocEFnbkw3aDRvZzlVQ2JhcTh4?=
 =?utf-8?B?SWtPRUR5S0djYURTcEVYOXZlRnR5MUUrUW4wZEVRaFg3SnF0WllnNE5hSGs5?=
 =?utf-8?B?eVJZYXdBazk1TDRtdDVhekhBVFNWb0J2cTdDRXR4WDA5aEtrd2p4WlNpUjRh?=
 =?utf-8?B?b1N6OFdMMTVYdG1Wd0V6TUMwUk95VnU2V1lzUjExV1NZVnFHVXVTNHprVTho?=
 =?utf-8?B?TVhqTjdwcjFETWdEbVpNQ1VuTWRiUTN5b2VRekhsWXM5WElxV2dzbGhwWFNl?=
 =?utf-8?B?enQ5MzhkUzAwYjRqajMxOEcxbXMwZHBvTEpVYnE4UXUzbDdKZ0lteUtqVVdT?=
 =?utf-8?B?WjArOUtBZTd1d0hPdjJjbTc1MWk0Z3NPalozbnVTbmJaQTY0YWtKV05hRHpD?=
 =?utf-8?B?anhRb2dETEdPcFVvcEZvdCtQOUE0TXZwcDNVL0JNR2ZtdmZyZGZuV0FLMVR5?=
 =?utf-8?B?RHpqU2E4VmZSZ0NZNmlCRy9DVDdHTDhvZFkwVkVHMmtXT1hoYi9QQ1Y5RFZ1?=
 =?utf-8?B?NnpUNGs2aXJHQzNDSnZIcmN5aEJWb2tYQTVNNlRsWUczZmlIT2ExNDVEV0Iy?=
 =?utf-8?B?RG9leGEvT29OUkJyT2VIblY0NklpeEJTd1FER2dqZGNvT0dvWWlPOUtIK1JI?=
 =?utf-8?B?MmFrdDRaRDF5VVhkM0VSSzBtYWRDVkx0MVJUTlQ2dmN2Q25BeEJ4QjBnSGNM?=
 =?utf-8?B?UFVmUG44eFhCOE93a2tmWlhMR2tLOUp0dUZDbGtnR0hpVVQrUDlPQkJLb09U?=
 =?utf-8?B?Rmljc0ZOWVhtdGJ0UnE1dEh3dWdrT0F1T0JWVGV0MkVXYUhITzNkWUxqMXo1?=
 =?utf-8?B?T2VnaHdmTnNVZExXZ2s3aFNsSWlISGNwN0E0Ukl3a2NFVGx2WC9laDJKOHZv?=
 =?utf-8?B?Rjg5OU1RU3dySi96RUo1blBVZTdCTGlnOHcrK3paK0pDVWExbnNxNVVwOG5r?=
 =?utf-8?B?NEx0aHVJbnlLRG9KaWh5U0diNStSdk5NSzNlSEFVejBpWHRZdlJ0TmU2N3FJ?=
 =?utf-8?Q?Dg/UGrGY8mDtOXDtZ+rN5KR1N?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5086F0309253324ABCE2363ADF8B431E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce70480e-97d5-486b-4658-08db4c2ddbc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 23:26:44.6907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VMQHu1HM6yJJL8/tNO7YEhQOq40ErgUQGqHPDR8417ZcbdKbY4rJ1IQm4Z9ULFeLq+N3rM1HTZKVVomy1Wn4hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5415
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA1LTAzIGF0IDExOjI4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBXQVJOIGFuZCBjb250aW51ZSBpZiBhIHdyaXRlIHRvIHRoZSBQQVQgTVNSIHJlYWNo
ZXMga3ZtX3NldF9tc3JfY29tbW9uKCkNCj4gbm93IHRoYXQgYm90aCBWTVggYW5kIFNWTSBoYW5k
bGUgUEFUIHdyaXRlcyBlbnRpcmVseSBvbiB0aGVpciBvd24uICBLZWVwDQo+IHRoZSBjYXNlIHN0
YXRlbWVudCB3aXRoIGEgV0FSTiBpbnN0ZWFkIG9mIGRyb3BwaW5nIGl0IGVudGlyZWx5IHRvIGRv
Y3VtZW50DQo+IHdoeSBLVk0ncyBoYW5kbGluZyBvZiByZWFkcyBhbmQgd3JpdGVzIGlzbid0IHN5
bW1ldHJpY2FsIChyZWFkcyBhcmUgc3RpbGwNCj4gaGFuZGxlZCBieSBrdm1fZ2V0X21zcl9jb21t
b24oKS4NCg0KV2h5IG5vdCBqdXN0IG1lcmdlIHRoaXMgcGF0Y2ggd2l0aCB0aGUgbmV4dCBvbmU/
IA0KDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29v
Z2xlLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0veDg2LmMgfCA2ICsrKysrKw0KPiAgMSBm
aWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYw0KPiBpbmRleCA4YjM1NmM5ZDhhODEuLmMz
NjI1NmQwMDI1MCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQo+ICsrKyBiL2Fy
Y2gveDg2L2t2bS94ODYuYw0KPiBAQCAtMzcwMSw2ICszNzAxLDEyIEBAIGludCBrdm1fc2V0X21z
cl9jb21tb24oc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3QgbXNyX2RhdGEgKm1zcl9pbmZv
KQ0KPiAgCQl9DQo+ICAJCWJyZWFrOw0KPiAgCWNhc2UgTVNSX0lBMzJfQ1JfUEFUOg0KPiArCQkv
Kg0KPiArCQkgKiBXcml0ZXMgdG8gUEFUIHNob3VsZCBiZSBoYW5kbGVkIGJ5IHZlbmRvciBjb2Rl
IGFzIGJvdGggU1ZNDQo+ICsJCSAqIGFuZCBWTVggdHJhY2sgdGhlIGd1ZXN0J3MgUEFUIGluIHRo
ZSBWTUNCL1ZNQ1MuDQo+ICsJCSAqLw0KPiArCQlXQVJOX09OX09OQ0UoMSk7DQo+ICsJCWZhbGx0
aHJvdWdoOw0KPiAgCWNhc2UgTVRSUnBoeXNCYXNlX01TUigwKSAuLi4gTVNSX01UUlJmaXg0S19G
ODAwMDoNCj4gIAljYXNlIE1TUl9NVFJSZGVmVHlwZToNCj4gIAkJcmV0dXJuIGt2bV9tdHJyX3Nl
dF9tc3IodmNwdSwgbXNyLCBkYXRhKTsNCg0K
