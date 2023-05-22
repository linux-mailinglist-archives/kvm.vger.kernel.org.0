Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DA070CF02
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 02:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234900AbjEWAHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 20:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235115AbjEVX2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 19:28:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E7218F;
        Mon, 22 May 2023 16:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684797529; x=1716333529;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EXN9fMDUR9IfNFdRT/ZkgTjpwFMFzU8WFBP27ZwYaAw=;
  b=X3DozTE1A168pwz8ti/4WFV1vgrcICeHC0d52R6bwOrg9XMNnmEGGrwB
   RozD8YtS7tXyBJC/Qj2n0XcL52tIufklL+9FOVqmhZ1ttvBjZAH/6IGiD
   yHQFh+YU6vrX69wxTHqy6jehUmpxyMltobpZZyINlRUOQv92v2DPBynXd
   xDqPwAuXRxEQC0FYF2breVw3jiNiqzoNhW1AFqUOqlZ0YgY4oODKGuE/8
   oT1S8ASPmotjuNQPTFPCd02P9n4WQm3sTjvfwGaE0Cn6oexI2e1zeV0Ai
   Q3IRhZ4O+brBy12LE1R6Jly6JDKQxQdHyHewV/Rj7IeBtoMH25+hxDYW4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="416533647"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="416533647"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 16:18:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="848014991"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="848014991"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2023 16:18:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 16:18:48 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 16:18:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 16:18:47 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 16:18:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dl5BOBMjpAapHILjpnTcHBd0QQVxytAFJt3HRK4S6pST3inD7bgpX9Q/EhoM0pcr8NJV2fqUn40F2oTvyFLjlLj7IT+qWgofWTmAAMc2VAYukdPXYys28MRWD1Vfs0E/IwVlq4qaMR1/3n2iAnPDnEm25u7v0du9tWD6AjlY1YPISEAlWFdvtUa6JW47xvGrDdO4U8FS9rK7MWBuQ+Xp6s9nCobHQsVHw1NG0MHQNpo+JMeeJ+D7HODTxSgk/gplmRDRKSrnwVzrbi2l67FQ7YZe9nw6B9YpQIeCHf7l90aNSoYFHYEGuAs/AOPm1s7sUsD8KckYOmpwaZO50kVVgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EXN9fMDUR9IfNFdRT/ZkgTjpwFMFzU8WFBP27ZwYaAw=;
 b=h/eQ3HYNGe3vktTU0DlF3CjakeMWtFDy3nAYHbzRhoDjoVCNrfbfUVmQgiMPjmunzwvmyRw6hdMsGadEYUbeo7VJE2GiNjALECuKYdz4YIHx4mNhsmNM429co/qAiNu5wffHSo1hBmXNwQ6nwq2C3URWSiYcAz+gOsMd+PY7NLzkK99DY7ysBLn36zJ+vasBqCg102XXsCPiISEJtBum2SoC/4m5SIjOY1pSqQeMkRKBLoX5Agl6ZrE6ZN07i1sdTKF21+SRCJ85IABJZEKndgUVrIpK4TCIdszGEkZbb6HUp6ojLQFv2pe9Kc9yT8nKhoigT0Q0UncLRc2e7256XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5240.namprd11.prod.outlook.com (2603:10b6:208:30a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 23:18:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 23:18:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 14/18] KVM: SVM: Check that the current CPU supports
 SVM in kvm_is_svm_supported()
Thread-Topic: [PATCH v3 14/18] KVM: SVM: Check that the current CPU supports
 SVM in kvm_is_svm_supported()
Thread-Index: AQHZhSydPEyHlYSVF02BwoH2YKoLe69m/SUA
Date:   Mon, 22 May 2023 23:18:45 +0000
Message-ID: <393d84bef4c5896b896ffe94559ebe2d8173a8c5.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-15-seanjc@google.com>
In-Reply-To: <20230512235026.808058-15-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5240:EE_
x-ms-office365-filtering-correlation-id: 93c5672a-652e-4a49-5f21-08db5b1ae3cc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1sv6gEmDRc2RH5sYZKj6NBCgGdCgItc9GRZiw/cFSrOw0aJfT3DG3mDuTspB35sy0keOFfcrbiVvl2lOhnZFrr8egCts00GM52ZGAmpobplEvGwXEu3HrZqnZliMMIhzZY++wGST6zFypvynipDQvtwE/hQtFi+CNr7owlfGMUT+NK6/RrFwVSo6jqBKvEKzyPgaAR91AINr62ffFcrNKYi+rpFzqmBR+U1dkJ5+X7BwlrUZrKVp0EcySl2dIVjBSLRpkdSiv7G9NmV2KzzClovBkChdhob0o2bx1EonZDy0nbIqWqM6ko6Dlp4ZTjMSqtKDMroAg3nrg1YX4xq4q9rmJ8pYwexKbwK2WGxT3p+k6DRdl2rFLoRDeHNR1Os7adNp2Fv1CnJ9FTs28Y9KaI2AMKE9b1hDIp4xTPxDYUSfgvbQ7m4uQKs4O3nkgNrjZv3qHvFGtCFwmz6kNdai10JF8VwqPJENiWq1MH9vV0k+s/pC73MRTBDgziXy/BQmZ/ADSnJp4SjgJm0plRS/c8Gedob300hCO4jl1UnUu6YxKQK0haq/ZzY35aeSZ3b1klkTPyk6JSr9y96cgF5zcvtnL875ikOkWeRYT490aHk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(346002)(376002)(136003)(451199021)(2906002)(5660300002)(83380400001)(8676002)(8936002)(91956017)(76116006)(66946007)(64756008)(66556008)(36756003)(66476007)(966005)(4326008)(54906003)(110136005)(316002)(478600001)(41300700001)(71200400001)(66446008)(86362001)(2616005)(122000001)(82960400001)(26005)(6506007)(6512007)(186003)(6486002)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1BpNWZDQm9UcVRBY0tkZVJ4UnpaQXZtL1UrVXd4cTNtTVZzT3AzdzFkNGRO?=
 =?utf-8?B?MHZlU1lJYmNobVlDVkhvUHNtVDVzclFyZHNEb1F3dDRYREl6azk2aFE5K0do?=
 =?utf-8?B?clVDdzlsbHpZYmZpYmROc0Y2NkV3L0NaSmQwVTJkZHZMdzNDNWF3STBYU1Ba?=
 =?utf-8?B?eFI5RmNYc0YyeEFFNERwR3ppS2RnQWtwYm1iSXB2ZDNQZGphcDlZMGlXcjdH?=
 =?utf-8?B?R3dOeU1BODhtak1FcnhZQlE3TklidlhPZC9uQ21oUlREWGxaeFJka3pPNHN4?=
 =?utf-8?B?WjRnZmhwMnN5cTMrZ2U0NnR0NE1EaVoyTGVsczJ3NkNpUXB1cWN4dUdVeHNu?=
 =?utf-8?B?cjRWeG9wUU00TmxJRHVUMTRSQ0hrbi82V0NJajFUbnk5V1NZcHlwWEY2MnJ4?=
 =?utf-8?B?Q1Z5ZmtsNE1rVmQycFJJaUdEa3p2U2tNQ2k1WlI3N3BuWnJOYTR3NVJiRVBT?=
 =?utf-8?B?YjBYSmFRTHhabUpnOTNzQU1YWXdYQ2RKSklNdHYyNjEzZGtaTlpMcmpPU005?=
 =?utf-8?B?RUVDNWk3cDZMUWszNWRFS25mbXo0a1RoRStMY3J0dG1RZmdrcjdIaElZTFJ4?=
 =?utf-8?B?OFBnbXJWMjU3dHRmLzJPZ09jUnpHdnZRT0Yxd0MzZUgxU096a1NTd0p5M0Ja?=
 =?utf-8?B?WVRmeFg1VWhBSEE1OXM1ZWVmZ1h0eVRvWVJmVU45S2I4Mi82N3FPTGxwUTVz?=
 =?utf-8?B?WFl6dVhuZlRZOUY2UmE2QkpHMUlLYTZtT1ZYMDAzZWdKcWVPbjRMSHJVUlc1?=
 =?utf-8?B?azVOU3kxMUZYTG1wWnlUbHNmajVIOW9NeHlZckZEaDdxSkhoWFk4VkljaXY1?=
 =?utf-8?B?a042WisvSGJZRGNpaThmWHpkaTJmNXJuWmpoRkNjQlpIeFpWcDIxNVJ1aUtx?=
 =?utf-8?B?RWJZVFlvUjE4QUdHbXpzZGthU1JFTkNxY1dQeUUzbVNReko5OHJqV1JyYTl4?=
 =?utf-8?B?MFhFVVMxSkZ4M2xycCtBYzJCTHNIWjNzS09idTR5SVpqMHZmNXl3a3JTRC9J?=
 =?utf-8?B?VjFGNTRKUTh4bzQvYi9MVnByS3VYZnNYU2VQamhTUzRySllLYjAvNDRvVWN6?=
 =?utf-8?B?d3JhVlVFdlZza1grWmZLQUlGYkxIajBJdk1FZzhPNExFQy96RkRsenB1ODgr?=
 =?utf-8?B?S2VhcVBZcXVXdklTM3Z5S0lGT1VQNzBrZmdpaUgwNTlaZ1NkU1pDaDlOTEh4?=
 =?utf-8?B?ZXRsaWhPM2ZSVGQ5elE1UHVlLy9Ed0FsUE1teTBTb3J2d1UxK0JvNTloaEs4?=
 =?utf-8?B?Q3ZUZkEzNkJJTzNRWDRZNTdOZlpia2pTY2dOS0xIWnZXTWVuRHducHlISmFk?=
 =?utf-8?B?VEZZTTFPanVPZTdZdnlqekxaTXJqc2dvcnlsRFBhYnA3dDhhRTJhQWlaNkNE?=
 =?utf-8?B?bmhVVFYyeEdBbk5aR25iRFUzMHB2MUVBYlNMc1NoQUJSTWZkaDVaYU9HcE14?=
 =?utf-8?B?SE5admdWRjhsVVg0Q1JoM1Y1SERZWFFMT0s4N0g1bWVEK25NODYreENWMXFu?=
 =?utf-8?B?ZnZOV0hWK1AwN3NRd2ExR1NKM0xLUUliNWpQSHVaUDE4cVZjV0c0Vk5nNU9D?=
 =?utf-8?B?dkRhcXZEWk1Mc1lmcGVPV01URUhKOTBwcFp3TDhObktwUllIRU5wSC9kNGJE?=
 =?utf-8?B?bEl3UGFGVml1cjc0M3V1b3o5dzhESmc2amhsS1BUa05Wcm5NU3BrZUJROWVu?=
 =?utf-8?B?L0xRNmRaMjVDUWlNWmJaTkVWNUl3d2lGMDhHeTZ5Wlh0bkEzRjdSWW9NT04x?=
 =?utf-8?B?bWxJYWc0bVlQL1VpMml6dEErUHBicDRadEwvVlJOSmN1bmNWV2F0Sk9pWll4?=
 =?utf-8?B?cjVjYUVydEk1eGZ6ZVUwZXAxMVdGMUtPU0dSUFFHWS8yZ1puSSs2RTk5cjEx?=
 =?utf-8?B?eVJJRXNTWmYwSUFvZTZQczNsVlcrQWlDMzN1MmZoWkJCbVpWYUxVVkd6dzBa?=
 =?utf-8?B?ZStvQ2hNTmFKNXZlbmt1cUhBSnJaN3UvdzYvU1BRY0o3VmRvL01EbElXQWZZ?=
 =?utf-8?B?S3J1eHZXd0RjQnhneVJSUGpScXNaRFlxS01uU0JFK2htbXRVRVN4SWtCZFZT?=
 =?utf-8?B?Q24zSVl5VTFEdWxoY1FuaERJZVIrWE42dXpXWkVFbU1DNURsZERDaXN2M3Br?=
 =?utf-8?B?TW0xWDU2U0NWeVlRalFtcWVHNVZxTkZtY0d2LytGNHhsZ0I2S1ZoS2RualZT?=
 =?utf-8?B?QUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <04C21407AF45624CA07DE5F2BFC4360E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c5672a-652e-4a49-5f21-08db5b1ae3cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 23:18:45.1858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FK8pCvi+Ts91PAFruJNLVYC4nUsI/e3uJbTFrLecerqagBTjIto8n3rPGFe1F3tzbttHiPjq55Z/ZpgojTqMug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5240
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA1LTEyIGF0IDE2OjUwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBDaGVjayAidGhpcyIgQ1BVIGluc3RlYWQgb2YgdGhlIGJvb3QgQ1BVIHdoZW4gcXVl
cnlpbmcgU1ZNIHN1cHBvcnQgc28gdGhhdA0KPiB0aGUgcGVyLUNQVSBjaGVja3MgZG9uZSBkdXJp
bmcgaGFyZHdhcmUgZW5hYmxpbmcgYWN0dWFsbHkgZnVuY3Rpb24gYXMNCj4gaW50ZW5kZWQsIGku
ZS4gd2lsbCBkZXRlY3QgaXNzdWVzIHdoZXJlIFNWTSBpc24ndCBzdXBwb3J0IG9uIGFsbCBDUFVz
Lg0KPiANCj4gRGlzYWJsZSBtaWdyYXRpb24gZm9yIHRoZSB1c2UgZnJvbSBzdm1faW5pdCgpIG1v
c3RseSBzbyB0aGF0IHRoZSBzdGFuZGFyZA0KPiBhY2Nlc3NvcnMgZm9yIHRoZSBwZXItQ1BVIGRh
dGEgY2FuIGJlIHVzZWQgd2l0aG91dCBnZXR0aW5nIHllbGxlZCBhdCBieQ0KPiBDT05GSUdfREVC
VUdfUFJFRU1QVD15IHNhbml0eSBjaGVja3MuICBQcmV2ZW50aW5nIHRoZSAiZGlzYWJsZWQgYnkg
QklPUyINCj4gZXJyb3IgbWVzc2FnZSBmcm9tIHJlcG9ydGluZyB0aGUgd3JvbmcgQ1BVIGlzIGxh
cmdlbHkgYSBib251cywgYXMgZW5zdXJpbmcNCj4gYSBzdGFibGUgQ1BVIGR1cmluZyBtb2R1bGUg
bG9hZCBpcyBhIG5vbi1nb2FsIGZvciBLVk0uDQoNCiJub24tZ29hbCBmb3IgS1ZNIChhdCBsZWFz
dCBmb3Igbm93KSIgPyA6KQ0KDQo+IA0KPiBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9h
bGwvWkFkeE5ndjBNNlA2M29kRUBnb29nbGUuY29tDQo+IENjOiBLYWkgSHVhbmcgPGthaS5odWFu
Z0BpbnRlbC5jb20+DQo+IENjOiBDaGFvIEdhbyA8Y2hhby5nYW9AaW50ZWwuY29tPg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCg0KUmV2
aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0KPiAtLS0NCj4gIGFy
Y2gveDg2L2t2bS9zdm0vc3ZtLmMgfCAyNSArKysrKysrKysrKysrKysrKysrLS0tLS0tDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS9zdm0u
Yw0KPiBpbmRleCBiMzQ3MTczYjRlMjkuLmNmNWYzODgwNzUxYiAxMDA2NDQNCj4gLS0tIGEvYXJj
aC94ODYva3ZtL3N2bS9zdm0uYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+IEBA
IC01MjMsMTggKzUyMywyMCBAQCBzdGF0aWMgdm9pZCBzdm1faW5pdF9vc3Z3KHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSkNCj4gIAkJdmNwdS0+YXJjaC5vc3Z3LnN0YXR1cyB8PSAxOw0KPiAgfQ0KPiAg
DQo+IC1zdGF0aWMgYm9vbCBrdm1faXNfc3ZtX3N1cHBvcnRlZCh2b2lkKQ0KPiArc3RhdGljIGJv
b2wgX19rdm1faXNfc3ZtX3N1cHBvcnRlZCh2b2lkKQ0KPiAgew0KPiAtCWludCBjcHUgPSByYXdf
c21wX3Byb2Nlc3Nvcl9pZCgpOw0KPiArCWludCBjcHUgPSBzbXBfcHJvY2Vzc29yX2lkKCk7DQo+
ICsJc3RydWN0IGNwdWluZm9feDg2ICpjID0gJmNwdV9kYXRhKGNwdSk7DQo+ICsNCj4gIAl1NjQg
dm1fY3I7DQo+ICANCj4gLQlpZiAoYm9vdF9jcHVfZGF0YS54ODZfdmVuZG9yICE9IFg4Nl9WRU5E
T1JfQU1EICYmDQo+IC0JICAgIGJvb3RfY3B1X2RhdGEueDg2X3ZlbmRvciAhPSBYODZfVkVORE9S
X0hZR09OKSB7DQo+ICsJaWYgKGMtPng4Nl92ZW5kb3IgIT0gWDg2X1ZFTkRPUl9BTUQgJiYNCj4g
KwkgICAgYy0+eDg2X3ZlbmRvciAhPSBYODZfVkVORE9SX0hZR09OKSB7DQo+ICAJCXByX2Vycigi
Q1BVICVkIGlzbid0IEFNRCBvciBIeWdvblxuIiwgY3B1KTsNCj4gIAkJcmV0dXJuIGZhbHNlOw0K
PiAgCX0NCj4gIA0KPiAtCWlmICghYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX1NWTSkpIHsNCj4g
KwlpZiAoIWNwdV9oYXMoYywgWDg2X0ZFQVRVUkVfU1ZNKSkgew0KPiAgCQlwcl9lcnIoIlNWTSBu
b3Qgc3VwcG9ydGVkIGJ5IENQVSAlZFxuIiwgY3B1KTsNCj4gIAkJcmV0dXJuIGZhbHNlOw0KPiAg
CX0NCj4gQEAgLTU1Myw5ICs1NTUsMjAgQEAgc3RhdGljIGJvb2wga3ZtX2lzX3N2bV9zdXBwb3J0
ZWQodm9pZCkNCj4gIAlyZXR1cm4gdHJ1ZTsNCj4gIH0NCj4gIA0KPiArc3RhdGljIGJvb2wga3Zt
X2lzX3N2bV9zdXBwb3J0ZWQodm9pZCkNCj4gK3sNCj4gKwlib29sIHN1cHBvcnRlZDsNCj4gKw0K
PiArCW1pZ3JhdGVfZGlzYWJsZSgpOw0KPiArCXN1cHBvcnRlZCA9IF9fa3ZtX2lzX3N2bV9zdXBw
b3J0ZWQoKTsNCj4gKwltaWdyYXRlX2VuYWJsZSgpOw0KPiArDQo+ICsJcmV0dXJuIHN1cHBvcnRl
ZDsNCj4gK30NCj4gKw0KPiAgc3RhdGljIGludCBzdm1fY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCh2
b2lkKQ0KPiAgew0KPiAtCWlmICgha3ZtX2lzX3N2bV9zdXBwb3J0ZWQoKSkNCj4gKwlpZiAoIV9f
a3ZtX2lzX3N2bV9zdXBwb3J0ZWQoKSkNCj4gIAkJcmV0dXJuIC1FSU87DQo+ICANCj4gIAlyZXR1
cm4gMDsNCj4gLS0gDQo+IDIuNDAuMS42MDYuZ2E0YjFiMTI4ZDYtZ29vZw0KPiANCg0K
