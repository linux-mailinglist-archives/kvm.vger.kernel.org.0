Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6F36A9372
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 10:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjCCJNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 04:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjCCJND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 04:13:03 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B69D514
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 01:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677834782; x=1709370782;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3Y/aCc9FugCT2plckcyFqgHFI1RbEncIvVT81EUFo2E=;
  b=HoSZEnuUQU8GM+g2gFGlTqm2LM/r5jWvkRfTHMC/Kbn+C5O2cEB4h1RY
   nG8+7EuYL6HHLjQq4IMayB+mI+IZbsQ3pCXovS7/JuCnvNkX9059M2CnF
   qdQYLmWczrbGXUvonzdgPQbAkF2xingsEDI/Tl9isAQgEMgzFzfAg6WWU
   jk+9KVTAhxERBEblCxfJ2Yr+sACOk0W3Xf6txo7M+bNvEVebALuuzqH0P
   12CkPuSj7hRwvrh2xsprlY/sa2f90zC8JJyKh06/2EWlzU9JIKwQ0FIYt
   64ufxjs/Lq34a7K1y2P8UCNlwRc/vrwFxYH/mcGXt99agFA6vWBwlu/87
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="362596058"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="362596058"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 01:12:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="744170782"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="744170782"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 03 Mar 2023 01:12:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 01:12:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 01:12:48 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 3 Mar 2023 01:12:48 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 3 Mar 2023 01:12:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqFUxz4WnOTPzf0JD7jFSLituxCAOV5xMN5yAcjB2RJPCoxc2unrz1ratlVL2ajIKNBWUZnVbJWrEt0GJGl9EMQrWo/zSg5NCT3Xq39SiZy4+NvlC/1HnJOMznqHpjhLghowZYEVfwGzFTN1beAb82SlXnToP8ezceRlUHH9GlZ1n2kjE0YxS2Y1LTDCi2hBuv4Z1E2A4ZmCqw6q4ZVtlcVpj1wNR2La6fdUgsaVSp4w4Wuu0eT34ABf3FjmRWwIpWstCJQUTYa3jwqR3dCuUV8mQa/iewGEknjshGQOmSySyH/Aj7uoEaikGqXxTzfqSfoJMKJSl+JhCuDK96/d7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Y/aCc9FugCT2plckcyFqgHFI1RbEncIvVT81EUFo2E=;
 b=mg8/i0vBwJlaAUIbDea1vefJpIacCnzmEqxDH6HjouGhU92LP8ZKQanQp8LfoL2x1qL/pAsOD4E4uD5TK0MCQs4jJti6bxD468A4SdSzfIAGxnjFGXT3FPDr7OjUVu/NuVrhgeLgB9RCgQLXEaUpGKtbpW2rRLXidDD5OgBOM9oD3/saZrilrsXrBNYZRO8CJMIx1g9pNBDo2EIbKW1uSGsou9gVMLjr2XfHIOuCBb0iXchN7bjysSHi9PIWTx4/7G5DP/PoS/Q+l+PHVBS/p3pJ/m7gNz1I/uvYDZPTrMy3IJDXg9b++/X08fRTF1UAfP2OV2Mo01xEs/NcUGgIuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 DM4PR11MB8203.namprd11.prod.outlook.com (2603:10b6:8:187::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.27; Fri, 3 Mar 2023 09:12:40 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58%8]) with mapi id 15.20.6156.018; Fri, 3 Mar 2023
 09:12:40 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "quintela@redhat.com" <quintela@redhat.com>,
        =?utf-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Mark Burton <mburton@qti.qualcomm.com>,
        Bill Mills <bill.mills@linaro.org>,
        Marco Liebel <mliebel@qti.qualcomm.com>,
        Alexandre Iooss <erdnaxe@crans.org>,
        "Mahmoud Mandour" <ma.mandourr@gmail.com>,
        Emilio Cota <cota@braap.org>, kvm-devel <kvm@vger.kernel.org>,
        =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: RE: Future of icount discussion for next KVM call?
Thread-Topic: Future of icount discussion for next KVM call?
Thread-Index: AQHZQfDqI9tbGvRklkm/jIyMCFf6BK7RmTE6gAABVpCADVW2UIAJ69uA
Date:   Fri, 3 Mar 2023 09:12:40 +0000
Message-ID: <DS0PR11MB637306EFDE0C89690D01AC8ADCB39@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <87bklt9alc.fsf@linaro.org>
        <CAHDbmO3QSbpKLWKt9uj+2Yo_fT-dC-E4M1Nb=iWHqMSBw35-3w@mail.gmail.com>
 <875yc1k92c.fsf@secure.mitica>
 <DS0PR11MB637307EE325932FC2F1AE7CFDCA09@DS0PR11MB6373.namprd11.prod.outlook.com>
 <DS0PR11MB63732F34D2E6B924B35B2393DCA99@DS0PR11MB6373.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB63732F34D2E6B924B35B2393DCA99@DS0PR11MB6373.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|DM4PR11MB8203:EE_
x-ms-office365-filtering-correlation-id: 060b732d-4ae0-4f5a-0031-08db1bc7707a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ECJvr0SnG/xN4+KhY9kAEUo2DifWSc/ZQ7nPDTp9FpN0RIJIXvM4a3dGMwgzFaPG61a/lgRWYefBSv6VPOit231m66XhcaidXFEGPtPp4N8zECimw08h9rLtYkXjpCMsL1E/MTJF/eCJ7Qe1NI446hzE++mDzfPyge9o4j6p1BhLRSxk9a9Fw5aJFN+Lk74LWpRwAF4JPF4CviBX3v+LgqYMxVzev1rXSOI5rf3sx6ZhH8VJOnT/BAvX/bhLBgTQ7WNidH8KBKXojjFjV2VTqQKHPHnC+LLjDAjcEGy9kUWyKPjWJs0GGbiIA7dHbJW7d/j76lKSw8DhnDKe+QBC42/4vJRLq/CfWmVWqc328thuIm6PqANa2kJTz3VolKizs8p+7Put1MU6fhaTluMfjrTvjQmz82Qj/KA8TawodQ1z1NuiwcmQIm0Bpkwf0fZfsCE4GvYX0NVws3r/xhnCae2mIwXvEimvXoVOTIe1PJHa/59eXGtQmSdcQSaitKA6pyxsNCp842MYC8GD6EbfHz/7+7FtoFZL7GFwvKoz74FjJbVtG4fv3T+9gFkrCiqv5V+yd5iPj9153EZTz2onMRNDQhPHzHoEvTs1XYpRPVsXVeIDbDq89Rl38VoPeyPtrJRR8jJ1nftWHgiyPN5AasVP1SCz4yHmVyfsNQmyJPIen21mMKeIJFBD7bXdO+xJJba7eqKiigdVPwHOwCyMihx32NKACDXRV03j4ctj98o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199018)(86362001)(5660300002)(82960400001)(478600001)(71200400001)(110136005)(8936002)(53546011)(26005)(966005)(316002)(52536014)(41300700001)(6506007)(9686003)(4744005)(186003)(7696005)(38070700005)(38100700002)(55016003)(64756008)(8676002)(4326008)(66476007)(66446008)(54906003)(83380400001)(7416002)(66556008)(2906002)(76116006)(66946007)(122000001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SmR2SGJQMjVtbW9EN2hxOEZEaFg4V0NSOWY5OGErM1EwOG5GUGl6empUbFI1?=
 =?utf-8?B?THZHV0lCMFNUSkRPRHZyS2U0ZXpUaWh5dVg2QWRpV0dkbDNHQ1FURDU1SXhS?=
 =?utf-8?B?L21hMUl6TE9WaGQ4SmFIUUZXNkFJUlh3eFlrMEVNTTRmT05TbjZXcVVJVllF?=
 =?utf-8?B?K0hFY3RrUlFPK2ozc1pKb1NjaU1Ia1YyckJaUmoyVGxRUDRJUDU4NENLYlZl?=
 =?utf-8?B?dXRJbkt0VCtpYXhKaElBdWFzV3VHNUpiNU1uOHB4NUdvUFF1QjhOVHBQM0R0?=
 =?utf-8?B?Wkh4eFFQK1JzcEVVVUJnZlJoYzluUy95ZnZ1dTZUQXpIYWdnUTZJV2Z2NjJD?=
 =?utf-8?B?TUQraE9WZnJIbTNodGk5YjZWMFcxd0szRXJqUDJEZitMaHEyNDZGMy9pVFpJ?=
 =?utf-8?B?RjFCZ254Y3Npc2hucFdRS0FsdWVEcStoMCt1R284aDdjNW5MT0RGOXpFTTk4?=
 =?utf-8?B?Z2U4TlJpUEYzM3krYXUrVFJzS3JReVVuVTJLVXpOeFlUei85MENyWm9RMENI?=
 =?utf-8?B?c3VQUzdVWUlvd1VJcFN1RkZLMEx3RFhzcEt1dE9pb0NFWFJzUW1zZXNOaVZJ?=
 =?utf-8?B?SnI1MlpHYlRNSENPc2IzcWVqUDlxditRUUJpWFVkT0lmdk5sUFIvR1NmTk9P?=
 =?utf-8?B?cGxTckFxR3kzaWtZdzJQNW9MUWFVdjNKRUVpNWRPalZsYjRoNnBydXNlbzJv?=
 =?utf-8?B?eUxjeXVYWFhsNEhsN0xhelg4L0U2eGNnVHV1dUdtSHJSU3Fpb3RFUEc1dzFs?=
 =?utf-8?B?SnZodTI5STd2aC9FZ3hReHN5K3ZEdUgvdVAxQVpVdVJ0Vy8yc0R0aTE4cFB2?=
 =?utf-8?B?SUorVTBPWHlxeUFBMk85WGpGN1ZlYjBUMmdGcFVyVTIzdEVjTHBvM1hpclVJ?=
 =?utf-8?B?bGp0NGNYS1pjM00wbldaSkZGcHBSb0ZneHNOQ3padjJDUkhxblYxNjdZdmJN?=
 =?utf-8?B?SGJzYmVYUVVmUjk1bTBoSDhIcHpVcDJEUFR5eHlDUnYzbUtma3VqRVloMnlj?=
 =?utf-8?B?R1RXWkdnRTJnY0tKcVhTd2hNTjlKbHJIYWtrbGJ5enJDQXRXT01CUG02ek93?=
 =?utf-8?B?YUEydW9yVlJSQVRET0JqaHNXbDQyNW9RbXViSWFGNjFtTTBwaHdPK2lMQjVU?=
 =?utf-8?B?cnVWMXVxUncvTkZvZ0ZITHBxZHlnOWUvVlZDVVlvTGVRL0NGVVZpRTBCOFRa?=
 =?utf-8?B?TldWd0ltSU5GeEdubFhid2lsZmdPVE1tdzJ0OW9Oc0hOSlRVMFRrMDVjaGEw?=
 =?utf-8?B?RjgraWJtZlZ1cVRKNC9UM0RlYTJSNXI1REIzVlI5WmVISVdGeFF1TzdLNmZE?=
 =?utf-8?B?dFd0YmtEeERzRXpmSTk1L2w5NVJkUjVyalBnRUR0N0JpS0FKaDFuUWt5eFZV?=
 =?utf-8?B?YVZVOU5IMG1jcE9CVk1MVjhtLzVDZjVwT0tyZCtjVGFtRVZTSnh0NUdLek1C?=
 =?utf-8?B?NVdMVkFsREFRK0dqWld0YVp6OGVDYmxNYmtJWXJ1eGh3dUlZRG9ZekhHcW85?=
 =?utf-8?B?SnNTaGYybnlKUzZmQnh6V3ZQamM2c05POUNZRURrSDRoMG13Mnl3eWFIdDBC?=
 =?utf-8?B?N2c5WmFrdjNjVXhYOTBrL2w0WGgrcWJteStxbDFDVS9uTnZML1RFN0FqdVZQ?=
 =?utf-8?B?OWxPOTJsbjZkNWdxV29wNTBsYXNLaG5rOHBxeFpNdENoR3pNallWMVdmWlBZ?=
 =?utf-8?B?M1QyRWxLT2d4L01neFhzQTFRUTA0SWc4OVpuWEliTTlJNU9vR0pubTkrYndr?=
 =?utf-8?B?bjZtdmNBRVlpVVJYVWh0a2VyRnBWcCs0T3cwRjNINzltUGhNZDF2MmNUNk9l?=
 =?utf-8?B?MGJpd1pwZUprV05TSXJqdjBzNjZORWFVeXBkSitITlE3Q3d3L0RzTm1Ja21p?=
 =?utf-8?B?Qm5zM05lWHFGbXNBME9CT09qQlVCTjBXZjQ2RzJ4cmFSdWU0aEtMUkcvSkJy?=
 =?utf-8?B?UkYzb3dyZUhUMmtxSUtBK05xeGl5RkRkNGJRZmFadHYyc0p2TEhsMGwxV050?=
 =?utf-8?B?Y2ZGN0g2RHNTRnhmajYvRFROQ3BxVXVGWFhFWStocXNpZWY3ZVJzMXh3YWpM?=
 =?utf-8?B?T3crVHFvNHJ6WlVNQnhYWThFKytxbm9Xc1NCV1ZsV2JEVGE5cEtXa1FzNjBu?=
 =?utf-8?Q?2AhYXRe0pdKFJjwIil2+OrxUf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 060b732d-4ae0-4f5a-0031-08db1bc7707a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2023 09:12:40.2073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X2xWVwdDRviY2cnYc0ufx9EQofqhcpC2RxMr4d/pW3F0LPou4wIeJ7Am2O/Xetcr6WL02kD6A4qO0JshmCNNHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8203
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

T24gVGh1cnNkYXksIEZlYnJ1YXJ5IDE2LCAyMDIzIDEwOjM2IFBNLCBXYW5nLCBXZWkgVyB3cm90
ZToNCj4gPiBPbiBUaHVyc2RheSwgRmVicnVhcnkgMTYsIDIwMjMgOTo1NyBQTSwgSnVhbiBRdWlu
dGVsYSB3cm90ZToNCj4gPiA+IEp1c3QgdG8gc2VlIHdoYXQgd2UgYXJlIGhhdmluZyBub3c6DQo+
ID4gPg0KPiA+ID4gLSBzaW5nbGUgcWVtdSBiaW5hcnkgbW92ZWQgdG8gbmV4dCBzbG90IChtb3Zl
ZCB0byBuZXh0IHdlZWs/KQ0KPiA+ID4gICBQaGlsbGlwZSBwcm9wb3NhbA0KPiA+ID4gLSBURFgg
bWlncmF0aW9uOiB3ZSBoYXZlIHRoZSBzbGlkZXMsIGJ1dCBubyBjb2RlDQo+ID4gPiAgIFNvIEkg
Z3Vlc3Mgd2UgY2FuIG1vdmUgaXQgdG8gdGhlIGZvbGxvd2luZyBzbG90LCB3aGVuIHdlIGhhdmUg
YSBjaGFuY2UNCj4gPiA+ICAgdG8gbG9vayBhdCB0aGUgY29kZSwgV2VpPw0KPiA+DQo+ID4gSXQn
cyBvayB0byBtZSB0byBjb250aW51ZSB0aGUgZGlzY3Vzc2lvbiBvbiBlaXRoZXIgRmViIDIxc3Qg
b3IgTWFyY2gNCj4gPiA3dGgsIGFuZCBJIHBsYW4gdG8gZmluaXNoIHNvbWUgdXBkYXRlIGFuZCBz
aGFyZSB0aGUgY29kZSBiZWZvcmUgZW5kIG9mDQo+IG5leHQgd2Vlay4NCj4gDQo+IEtWTSBjb2Rl
IGNhbiBiZSByZWFkIGhlcmU6IGh0dHBzOi8vZ2l0aHViLmNvbS9pbnRlbC90ZHgvICB0ZHgtbWln
LXdpcA0KPiBRRU1VIGNvZGUgd2lsbCBiZSBzaGFyZWQgc29vbi4NCg0KUUVNVSBjb2RlIGNhbiBi
ZSByZWFkIGhlcmU6IGh0dHBzOi8vZ2l0aHViLmNvbS9pbnRlbC9xZW11LXRkeC8gwqAgdGR4LW1p
Zy13aXANCg==
