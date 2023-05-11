Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06BF56FF1E1
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 14:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237828AbjEKMvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 08:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236911AbjEKMvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 08:51:41 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334B46193;
        Thu, 11 May 2023 05:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683809500; x=1715345500;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CZcPhZANJsLv0ITZNZCrZUa+M6Mw2U6Dtkgvi5awHOA=;
  b=nibP+Akd2Vj8g0nArO/NbbFrAjKVomnCXoDB1DYEZfA8/7H0QIitDfxp
   zZsClH2VUuD0lfHT7QMY4DCkPPBAFIwURh8D9cKZWsNM3HpuUy+QCWcgv
   LODGtZzU8+HbLQf0+0IdvPyFvrwGbhdVKrGKLiPkO1MVdv5t70n7nV+cb
   Ns2AvlIyFr0IkMiV3KLtRxuN47VeP2Sp//bpSpre6hzT73FHPvWL1bfTv
   9Qi8VcpEdtrq42dNiXIeorIVqbRefWKpy5PMylmbFjgjUGmIG7EXVjvsB
   wQuFjDri/Vyn7CurWxxqsaoUTvVg4+CUJkd6er+Gn0bPvTSXTLY51Sb7r
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="378612974"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="378612974"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 05:51:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="693791856"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="693791856"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 11 May 2023 05:51:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 05:51:26 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 05:51:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 05:51:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 05:51:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpcktBocD+jYqRhAuq6rKN0kQ0cC4oulz0aCK9BBpzcLCk447zVhPGDOsXVr46+E2NOmYrfXP6Tr0L5vVNrmF2U/srM24uFxAwx3v/A9WkSPUoh4xzZ0lUAwLELIc4d5dbz9TUcWi49ahohPFoduk3UvsQISBPSqjTKeeVyxAPip4KYPSgRo05MBTyU0YbDMTlNzeqX2/Dg8kTxowL8lcCAMlV8NqREM2LCCJeFwQ3qAqpkKu9XXoKkMVo5K++XhpJWf4QurHUKutSrFskyxE3QzP8AE6cnf4nXTs4+up+fFd/zNrwkotRrrl+J11kqH0/9jCNDuNG3MAfe9gnqczQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZcPhZANJsLv0ITZNZCrZUa+M6Mw2U6Dtkgvi5awHOA=;
 b=SpjFIoaNKZNlZJrlWEueDJNUGjoINZujDD7S8amG0i5S9MruPbg1x1fNh+tHMhUK/Whl+ufYqaU/AGCCUIeq30NvVzAvExCdt+nzsMlxUTk6oOpeCpMSb1drbMBg0iYU+nJA4sha6/mx99rRH5ygcji3vw40osKSu8JTdv4qQODfY83Mo3gjaySdgJRcFyNpd9OfTpmURMIfi+91Zslkvy3AdWyr6rBslVNfjq6tBOetthhVltZJ5RjWmmlFmUpGD2nIZXKRMPhqeuMY9S3tyF/yaK9fSxZdLHBNgLyK84fk27TkOhdwm08nF7FhcQihKDwUrbihlMnq9tVt9lAJ5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7867.namprd11.prod.outlook.com (2603:10b6:610:12a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Thu, 11 May
 2023 12:50:58 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 12:50:58 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v8 2/6] KVM: x86: Virtualize CR4.LAM_SUP
Thread-Topic: [PATCH v8 2/6] KVM: x86: Virtualize CR4.LAM_SUP
Thread-Index: AQHZgwWcGoITj2apJUG2jRGbN3NxlK9VCGeA
Date:   Thu, 11 May 2023 12:50:58 +0000
Message-ID: <67a20fe2a41fbe99de1470254b14f282f72571c7.camel@intel.com>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
         <20230510060611.12950-3-binbin.wu@linux.intel.com>
In-Reply-To: <20230510060611.12950-3-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7867:EE_
x-ms-office365-filtering-correlation-id: 89b759a4-deda-4cb7-e3f6-08db521e5de0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CR/gW1gdj9POTMJbJHtsnT+hcfo3MlIbsazjQiCKEz0CVZcgD/q/Es/U6zlOS6jYyt9ZktmSMx77NJgGBgCzucaTdqpzm67SAJ9VJXc7R1b1Yzyj9y6qRNYgn0tpRt0167ixiXONkxsMXNzUIikVZa5Cu3aHKwi7tkwI6O0Z8Uy+SyUCXXrfzPcIfNgJi0Vl/flqy6TSqrMsLNrRV87P1nKInf4Ow1oGMKtD9OU11YmB/0U3WzS+Mfv599TplbckpYpRNrWh5YIPG7VLBiT3g2hiaeTefRm3kFGNg5afQLEPfmRVsFCcZTEawrqYP/jGOASMJXIP6BsEiHdIULAjvUb6M4SFiRLllOhDzzWqCgch4qF4qeyLOxKld+Omsn5b8oLlcbENuRbGlEvieKaSUSymRT2diAEZarAUS6GsbxNqfoelszVss9E+tDk1KGvtpa/piDNGOUzrqWWpqL3ao20CG+B8JHtr8jojDC+uzYa9TaS8rXOUFoYqI8n2VxMGT3Vg1+GhntkAJ/rvdytTT88VRyJDUX5L211ru/yw6XZYOQii7b1PRbWei1VTVrubmhSXvR9lwSNZ8z64Fyak0mVOphrBxvXpGhm0X0VGfTE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199021)(2616005)(478600001)(86362001)(54906003)(186003)(83380400001)(110136005)(6506007)(6512007)(26005)(71200400001)(6486002)(966005)(36756003)(316002)(4326008)(41300700001)(8936002)(91956017)(76116006)(66946007)(66556008)(64756008)(66446008)(66476007)(8676002)(5660300002)(2906002)(122000001)(82960400001)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkJ1TEZma3ZvQk8weDdnYVQ3d0t2N05DQkpUcDNiQk5qQzdNbmVJK2hocmdK?=
 =?utf-8?B?SWtUWVJPNWs4US9wMGphTnRpZURBMmJCbjVtQzlIa2xCdlZzckFLTi9mS1BB?=
 =?utf-8?B?TFVxRkdUb3hNaEs4czVPMHFBTHg5L2EybHlkalgvdklZTDBzb3FtRjVsRjNC?=
 =?utf-8?B?aWE4Y2JURUZGaTE1dG9odDcybGx1dXRBVjZrVUYwZHJZVG5nakNQdzJKMldX?=
 =?utf-8?B?MHJBTmM1L1BhZ1NFanFCK0Q5cERPU3ZTYmJib2xDT0tBSzRRTnNnR2JwenB0?=
 =?utf-8?B?cEVOS0d2eW9rY1dIZElvOVp5OTEwR1ZBSXVYd3BDdFRHczBIdzAyQ2VoWDY0?=
 =?utf-8?B?dU9aSHdxWHJRYkNWVGNmZW9GQkhrM0VPVFlCL3dOSFQxRTNHY2xMb1BNK1N2?=
 =?utf-8?B?Y3RWZStSVFBVRnIvdFJCK1gzMG9wTVdNc0s5Y3hNNjdIY3ZscDlDenNIWlNq?=
 =?utf-8?B?VnRzNlVnckE5SGxobU84bUE1TjRycUNQVkxWUVczR2svZHhwZjV1VWNXbDlL?=
 =?utf-8?B?cmhETE9zejRsaWwzS3MxOEN2NkYvblQrMzc1M1JGSW9OeFVZa25QMERRbU1E?=
 =?utf-8?B?Y1o0N0FEeWVkQ3pIODV3QWpMYm9JTkJ1R3ZSYTFsb1FkeXZTUzE3QzZZVkhF?=
 =?utf-8?B?bXVyeTljcytMNEduTEhVVWpQRmtZdldxRzhyeHVLVDNqNzNvTWZkcUVrWjg0?=
 =?utf-8?B?UnhnMHFtbkM4UzZ1M0dpZVc4QzltSVBDUUFSbWlGU3lDWE9UcmFMd0xpNU9S?=
 =?utf-8?B?QW83c1VJVDY3TlBiMkpFRm1aTDdNeWEyWmF6dG0wREdWRTJuNW5hMzQvY2dE?=
 =?utf-8?B?TVBaWDJmdVcvdHdWSnpVcGlQbkIzTEtBTFcra0Y3dW5PVU8yL1NDb0xrZWlk?=
 =?utf-8?B?VU55b1pOM0NsZVZCK0pLVEhDWUFFUDZBL2NoZ0pVT1JlOHhqQVc3eVFERmt2?=
 =?utf-8?B?OGZhcXMrWkcvR1JGSG5GSFpGajFWNC9SRzR2ZTZtaEsxM3dRMzFON29BYnpu?=
 =?utf-8?B?RzhmQlV2WGh0U3h2TGRzY21McUhXeHIybWE2dHRyM0JIVDdlaVkwSzlnNkNS?=
 =?utf-8?B?Ui9MekNIL3F6c2lJRkNhUTlJejlpV2FvaENRWUh0QkdFWjk5RmdCWWxOWDhs?=
 =?utf-8?B?NXlSZys5cC8wMlVpT2daTExwT3ZmdERvbUJORFUxTzBjeFk2TlhIS1lBdWFp?=
 =?utf-8?B?MzhYclhwT1F3ZGRuZVFUVVErN0JsK1c1NGl6V0JDYWV4SEd6bHRaYzdVcm5U?=
 =?utf-8?B?U25aQnVTQnByTlFQaVUxUCtLSVY3SnBCSTd0aXRBTlhRakIxUzRGaEt1WEhX?=
 =?utf-8?B?UzExT21lZlQxM2VqaUxNKzFtWHRpdnd2VnJweWJidHRmQkhZbG1IQ05TdHZV?=
 =?utf-8?B?ZzZsaFFIMmhqbndMNi9YbjM3TEtMUFpzaXdpL1RkS2UyRFZ3cVlvWk84SnZ0?=
 =?utf-8?B?WDJqWjBaQlBlSmFiSk5Gd2lRZHpYdE5QVTFxNVVEMFZJT2pST1BieVhqdWZB?=
 =?utf-8?B?SktzMkRRUTVUSmRRRytDZkxhRzUzWmtlTEF1d2lIb2s2bDZoQVpQQlkrNndn?=
 =?utf-8?B?VjN1cHg3b1l0NCtyeGpFeG83YWQrVjNPL29xeHljYi9HbUtRWHJqaElJako3?=
 =?utf-8?B?MXNIU2lLeVdRNnVmc0FmVlBlZHNwMzV4V1ptVk5pSVdzLzJ0VWFsRFpYQ0NW?=
 =?utf-8?B?OW9sOFcvSm91U3VhT25lb0JSY3dQc08ySExDSDZCNExpNW91MHcyTUVxZjNB?=
 =?utf-8?B?U3Z1eTJ2R0kxaFFOeDFjYlYvNjZ0V3VJeGg2TlV5czYxTUtwYndWL3k1VjlI?=
 =?utf-8?B?ZndXSEdZUlBUN3FxT3NjN1BCSE8yWi9QRGkra1BSQVl6M1kweDZ2QWdPOGtN?=
 =?utf-8?B?dUQ4T1o2RmdMK1o2KzhqeEFvWXk1MlpzSkNyalFKaDIyaTVyWlhDM0ozUGcw?=
 =?utf-8?B?aDF1UUs4blU3QndBRFhsK0sxcUtKR3laYThlUFY2WFNsMzdqOUVEUm9qekdr?=
 =?utf-8?B?OEpyaFRtM1F2ZENONHRqVzdlVWxjM0Fuc3l2Y09SWWQ3M2srN3h4Sm0vamJT?=
 =?utf-8?B?Q09aOXY4cnh4Nm9nZ1pCckd6WlBQVUhzQmNWTXZxVEFLMUU0NUxrb3dKQTl3?=
 =?utf-8?B?NnNPLzc2Y1RiSjVNWFQ1RFEvUUVjWXh1VFpPaHlRcDJFL0tvSEswRGU4aFBJ?=
 =?utf-8?B?dXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A1A4B672969A84883FC2C83744E6C1F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89b759a4-deda-4cb7-e3f6-08db521e5de0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 12:50:58.0306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ke6aoO75VmGSNb0NJbYYUCzNEvTnIKZYyo9Kftdsu73BQpof27P7RDQ5QKqa8OZv8oaqVjb6AFawLARoG7xvBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7867
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

T24gV2VkLCAyMDIzLTA1LTEwIGF0IDE0OjA2ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IEZy
b206IFJvYmVydCBIb28gPHJvYmVydC5odUBsaW51eC5pbnRlbC5jb20+DQo+IA0KPiBBZGQgc3Vw
cG9ydCB0byBhbGxvdyBndWVzdHMgdG8gc2V0IHRoZSBuZXcgQ1I0IGNvbnRyb2wgYml0IGZvciBn
dWVzdHMgdG8gZW5hYmxlDQo+IHRoZSBuZXcgSW50ZWwgQ1BVIGZlYXR1cmUgTGluZWFyIEFkZHJl
c3MgTWFza2luZyAoTEFNKSBvbiBzdXBlcnZpc29yIHBvaW50ZXJzLg0KPiANCj4gTEFNIG1vZGlm
aWVzIHRoZSBjaGVja2luZyB0aGF0IGlzIGFwcGxpZWQgdG8gNjQtYml0IGxpbmVhciBhZGRyZXNz
ZXMsIGFsbG93aW5nDQo+IHNvZnR3YXJlIHRvIHVzZSBvZiB0aGUgdW50cmFuc2xhdGVkIGFkZHJl
c3MgYml0cyBmb3IgbWV0YWRhdGEgYW5kIG1hc2tzIHRoZQ0KPiBtZXRhZGF0YSBiaXRzIGJlZm9y
ZSB1c2luZyB0aGVtIGFzIGxpbmVhciBhZGRyZXNzZXMgdG8gYWNjZXNzIG1lbW9yeS4gTEFNIHVz
ZXMNCj4gQ1I0LkxBTV9TVVAgKGJpdCAyOCkgdG8gY29uZmlndXJlIExBTSBmb3Igc3VwZXJ2aXNv
ciBwb2ludGVycy4gTEFNIGFsc28gY2hhbmdlcw0KPiBWTUVOVEVSIHRvIGFsbG93IHRoZSBiaXQg
dG8gYmUgc2V0IGluIFZNQ1MncyBIT1NUX0NSNCBhbmQgR1VFU1RfQ1I0IGZvcg0KPiB2aXJ0dWFs
aXphdGlvbi4NCj4gDQo+IE1vdmUgQ1I0LkxBTV9TVVAgb3V0IG9mIENSNF9SRVNFUlZFRF9CSVRT
IGFuZCBpdHMgcmVzZXJ2YXRpb24gZGVwZW5kcyBvbiB2Y3B1DQo+IHN1cHBvcnRpbmcgTEFNIGZl
YXR1cmUgb3Igbm90LiBMZWF2ZSB0aGUgYml0IGludGVyY2VwdGVkIHRvIGF2b2lkIHZtcmVhZCBl
dmVyeQ0KPiB0aW1lIHdoZW4gS1ZNIGZldGNoZXMgaXRzIHZhbHVlLCB3aXRoIHRoZSBleHBlY3Rh
dGlvbiB0aGF0IGd1ZXN0IHdvbid0IHRvZ2dsZQ0KPiB0aGUgYml0IGZyZXF1ZW50bHkuDQo+IA0K
PiBTZXQgQ1I0LkxBTV9TVVAgYml0IGluIHRoZSBlbXVsYXRlZCBJQTMyX1ZNWF9DUjRfRklYRUQx
IE1TUiBmb3IgZ3Vlc3RzIHRvIGFsbG93DQo+IGd1ZXN0cyB0byBlbmFibGUgTEFNIGZvciBzdXBl
cnZpc29yIHBvaW50ZXJzIGluIG5lc3RlZCBWTVggb3BlcmF0aW9uLg0KPiANCj4gSGFyZHdhcmUg
aXMgbm90IHJlcXVpcmVkIHRvIGRvIFRMQiBmbHVzaCB3aGVuIENSNC5MQU1fU1VQIHRvZ2dsZWQs
IEtWTSBkb2Vzbid0DQo+IG5lZWQgdG8gZW11bGF0ZSBUTEIgZmx1c2ggYmFzZWQgb24gaXQuDQo+
IFRoZXJlJ3Mgbm8gb3RoZXIgZmVhdHVyZXMvdm14X2V4ZWNfY29udHJvbHMgY29ubmVjdGlvbiwg
bm8gb3RoZXIgY29kZSBuZWVkZWQgaW4NCj4ge2t2bSx2bXh9X3NldF9jcjQoKS4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IFJvYmVydCBIb28gPHJvYmVydC5odUBsaW51eC5pbnRlbC5jb20+DQo+IENv
LWRldmVsb3BlZC1ieTogQmluYmluIFd1IDxiaW5iaW4ud3VAbGludXguaW50ZWwuY29tPg0KPiBT
aWduZWQtb2ZmLWJ5OiBCaW5iaW4gV3UgPGJpbmJpbi53dUBsaW51eC5pbnRlbC5jb20+DQo+IFJl
dmlld2VkLWJ5OiBDaGFvIEdhbyA8Y2hhby5nYW9AaW50ZWwuY29tPg0KPiBUZXN0ZWQtYnk6IFh1
ZWxpYW4gR3VvIDx4dWVsaWFuLmd1b0BpbnRlbC5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYvaW5j
bHVkZS9hc20va3ZtX2hvc3QuaCB8IDMgKystDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3ZteC5jICAg
ICAgICAgIHwgMyArKysNCj4gIGFyY2gveDg2L2t2bS94ODYuaCAgICAgICAgICAgICAgfCAyICsr
DQo+ICAzIGZpbGVzIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggYi9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+IGluZGV4IGZiOWQxZjJkNjEzNi4uYzZmMDNkMTUx
YzMxIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+ICsr
KyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCj4gQEAgLTEyNSw3ICsxMjUsOCBA
QA0KPiAgCQkJICB8IFg4Nl9DUjRfUEdFIHwgWDg2X0NSNF9QQ0UgfCBYODZfQ1I0X09TRlhTUiB8
IFg4Nl9DUjRfUENJREUgXA0KPiAgCQkJICB8IFg4Nl9DUjRfT1NYU0FWRSB8IFg4Nl9DUjRfU01F
UCB8IFg4Nl9DUjRfRlNHU0JBU0UgXA0KPiAgCQkJICB8IFg4Nl9DUjRfT1NYTU1FWENQVCB8IFg4
Nl9DUjRfTEE1NyB8IFg4Nl9DUjRfVk1YRSBcDQo+IC0JCQkgIHwgWDg2X0NSNF9TTUFQIHwgWDg2
X0NSNF9QS0UgfCBYODZfQ1I0X1VNSVApKQ0KPiArCQkJICB8IFg4Nl9DUjRfU01BUCB8IFg4Nl9D
UjRfUEtFIHwgWDg2X0NSNF9VTUlQIFwNCj4gKwkJCSAgfCBYODZfQ1I0X0xBTV9TVVApKQ0KPiAg
DQo+ICAjZGVmaW5lIENSOF9SRVNFUlZFRF9CSVRTICh+KHVuc2lnbmVkIGxvbmcpWDg2X0NSOF9U
UFIpDQo+ICANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMgYi9hcmNoL3g4
Ni9rdm0vdm14L3ZteC5jDQo+IGluZGV4IDQ0ZmI2MTk4MDNiOC4uMzYyYjJkY2U3NjYxIDEwMDY0
NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92
bXgvdm14LmMNCj4gQEAgLTc2MDMsNiArNzYwMyw5IEBAIHN0YXRpYyB2b2lkIG5lc3RlZF92bXhf
Y3JfZml4ZWQxX2JpdHNfdXBkYXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gIAljcjRfZml4
ZWQxX3VwZGF0ZShYODZfQ1I0X1VNSVAsICAgICAgIGVjeCwgZmVhdHVyZV9iaXQoVU1JUCkpOw0K
PiAgCWNyNF9maXhlZDFfdXBkYXRlKFg4Nl9DUjRfTEE1NywgICAgICAgZWN4LCBmZWF0dXJlX2Jp
dChMQTU3KSk7DQo+ICANCj4gKwllbnRyeSA9IGt2bV9maW5kX2NwdWlkX2VudHJ5X2luZGV4KHZj
cHUsIDB4NywgMSk7DQo+ICsJY3I0X2ZpeGVkMV91cGRhdGUoWDg2X0NSNF9MQU1fU1VQLCAgICBl
YXgsIGZlYXR1cmVfYml0KExBTSkpOw0KPiArDQo+ICAjdW5kZWYgY3I0X2ZpeGVkMV91cGRhdGUN
Cj4gIH0NCj4gIA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5oIGIvYXJjaC94ODYv
a3ZtL3g4Ni5oDQo+IGluZGV4IGM1NDQ2MDJkMDdhMy4uZmU2N2I2NDFjY2U0IDEwMDY0NA0KPiAt
LS0gYS9hcmNoL3g4Ni9rdm0veDg2LmgNCj4gKysrIGIvYXJjaC94ODYva3ZtL3g4Ni5oDQo+IEBA
IC01MjksNiArNTI5LDggQEAgYm9vbCBrdm1fbXNyX2FsbG93ZWQoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LCB1MzIgaW5kZXgsIHUzMiB0eXBlKTsNCj4gIAkJX19yZXNlcnZlZF9iaXRzIHw9IFg4Nl9D
UjRfVk1YRTsgICAgICAgIFwNCj4gIAlpZiAoIV9fY3B1X2hhcyhfX2MsIFg4Nl9GRUFUVVJFX1BD
SUQpKSAgICAgICAgICBcDQo+ICAJCV9fcmVzZXJ2ZWRfYml0cyB8PSBYODZfQ1I0X1BDSURFOyAg
ICAgICBcDQo+ICsJaWYgKCFfX2NwdV9oYXMoX19jLCBYODZfRkVBVFVSRV9MQU0pKSAgICAgICAg
ICAgXA0KPiArCQlfX3Jlc2VydmVkX2JpdHMgfD0gWDg2X0NSNF9MQU1fU1VQOyAgICAgXA0KPiAg
CV9fcmVzZXJ2ZWRfYml0czsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gIH0p
DQo+ICANCg0KTEFNIG9ubHkgYXBwbGllcyB0byA2NC1iaXQgbGluZWFyIGFkZHJlc3MsIHdoaWNo
IG1lYW5zIExBTSBjYW4gb25seSBiZSBlbmFibGVkDQp3aGVuIENQVSBpcyBpbiA2NC1iaXQgbW9k
ZSB3aXRoIGVpdGhlciA0LWxldmVsIG9yIDUtbGV2ZWwgcGFnaW5nIGVuYWJsZWQuDQoNCldoYXQn
cyB0aGUgaGFyZHdhcmUgYmVoYXZpb3VyIGlmIHdlIHNldCBDUjQuTEFNX1NVUCB3aGVuIENQVSBp
c24ndCBpbiA2NC1iaXQNCm1vZGU/ICBBbmQgaG93IGRvZXMgVk1FTlRSWSBjaGVjayBHVUVTVF9D
UjQuTEFNX1NVUCBhbmQgNjQtYml0IG1vZGU/wqANCg0KTG9va3MgdGhleSBhcmUgbm90IGNsZWFy
IGluIHRoZSBzcGVjIHlvdSBwYXN0ZWQgaW4gdGhlIGNvdmVyIGxldHRlcjoNCg0KaHR0cHM6Ly9j
ZHJkdjIuaW50ZWwuY29tL3YxL2RsL2dldENvbnRlbnQvNjcxMzY4DQoNCk9yIEkgYW0gbWlzc2lu
ZyBzb21ldGhpbmc/DQoNCg==
