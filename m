Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D847BCE48
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 14:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344734AbjJHMEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 08:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344682AbjJHMEj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 08:04:39 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D3AB6;
        Sun,  8 Oct 2023 05:04:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GU7bj2haaWksxImdL/5t5Gq3Aw+5CB9Hd1e77lTW0ItBVDHZLbErdGP2U3h6nUkWavZg6DhbmMaDSSOiK11pTlsfbqnyHQr0Z9kMWHjBoDU+JsgI1nzFuj7qjY/EOoOnC0wrcOFfzFVHusycGu6zQSr+RCbnHjcbEwqJnNmxKw+tgKNpp66M5uKHmsRwEcYqSdJn3+QSRBCYlm8itu3+4qsBbcap/ct6ZHjOgKrTUIVeDDM0suAsKr1LRNVUxYH5XvK4gBBAK9VBGntLqE6bGBTeo9VvYmc7xpMn76MnJcXE7JIVcVGlvsQovq67Lncsf02KKMgakF8kneRP/UvusQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kc21trQFyB4Ocy0vjnb1e6MoEW66rJvvwXnuVW8C4DY=;
 b=i/G3WZmxUBxh/Jl4hkG2Y2TWC2YaOYQ6i9qUftnm04PMmn6VF+mDqWVTiRbaiUqGK4Qt7lCUC8ELxkXOCw2yDVqWyBGZx3TqU8DGpwwU+BmXVrbZXOTobuOz4mzM69hVs1DFsMGHT/bQLr/K5Q62PCkMlgaeDhqoWUCkFgGH7/kJ0BRhGA43wkMrdrnp/HCxKYOGIUyfAc8VVbeMj+4LEGWGNLsAW3qppWc42Me9phLCHOvGQMFI71vMm3rC4FLw9AtElduRC0Wu6+/AI4lfhTrHIzNhY07E3gfcxbw60LoBwBqfnttoHj+FOau/IvkCq2yKBx9XAFKACaWcLHCpQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kc21trQFyB4Ocy0vjnb1e6MoEW66rJvvwXnuVW8C4DY=;
 b=VJyaVAinPL+l2xET5SLoGGVf/U6uI9aYDcmCakEZR3AE+aL2xhnjHxXuMQ0PrRl70N1L2zaMsrD0g/+fGCGaSjN3TZHevLOf76uiAeqlgxxiSTw0Rvpm8/sBLr69YMGONzUA/zGz/NAi5hjRbzkScRkpGazD+U1Nztu+/rAotxBi9DjWw5xLG768DB468ULm7tlJP/8FjT4F10D8DMLcp2wQvYiYUKahUiuDYhROvRY/YfzFQAW9Jo1jBjhIDG9dv/yJozlLdb2R1jRmmfSqtfWPUN1ge6IlRoysNraiDANNNM9Zk1k05IBL+oMP+p6hLhXJYVGYjYzxVdYrPhfQQA==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by SJ1PR12MB6123.namprd12.prod.outlook.com (2603:10b6:a03:45a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.43; Sun, 8 Oct
 2023 12:04:33 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::fddf:d4b8:44d9:d378]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::fddf:d4b8:44d9:d378%7]) with mapi id 15.20.6863.032; Sun, 8 Oct 2023
 12:04:32 +0000
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     "jasowang@redhat.com" <jasowang@redhat.com>
CC:     "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
        Parav Pandit <parav@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH 09/16] vdpa/mlx5: Allow creation/deletion of any given mr
 struct
Thread-Topic: [PATCH 09/16] vdpa/mlx5: Allow creation/deletion of any given mr
 struct
Thread-Index: AQHZ5Xlk30nZFuaBXUOyCVsOMD7qbrAsnWKAgAAr3QCAEqqpAIAAgFWA
Date:   Sun, 8 Oct 2023 12:04:32 +0000
Message-ID: <4f9759182636f7bb3cb15bc8b6ec6afbe0d6053d.camel@nvidia.com>
References: <20230912130132.561193-1-dtatulea@nvidia.com>
         <20230912130132.561193-10-dtatulea@nvidia.com>
         <CACGkMEsC_rgnKyG3stFbc-Mz2yiKGwNUYYqG64jQbNpZBtnVvg@mail.gmail.com>
         <c42db8942523afe8bbf54815f672acd9e47cfa67.camel@nvidia.com>
         <CACGkMEvZESDuOiX_oOvMUh0YqCWYqvmD3Ve9YEJW3+RXXyvGew@mail.gmail.com>
In-Reply-To: <CACGkMEvZESDuOiX_oOvMUh0YqCWYqvmD3Ve9YEJW3+RXXyvGew@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|SJ1PR12MB6123:EE_
x-ms-office365-filtering-correlation-id: 9071e908-4985-4f33-43a6-08dbc7f6bb6a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: carW5QrQrpXPEcU2ui/wktba/j04dXYB6R0QwZk8bdLpHKv600FIWe4Z/kyYI7DmGxWzKB9x1hCIxbkRyz14N9cQRQAm/mw4PlwP21O3/P+v8Jb6/LRiMQNegkMcgTz/7t05j5miw3l6plI/2nCwBDVaLCpSxvZPrDGLN7L9tyC+UD045AG7PeF4vj1MPYjOtsLFvYoB+JbG23QLwK2iuRgTz3Bc6V13cn1CDWEtjxhafFIoZleOzN1DBrBcTX5KhqbwB8gSA4wg24yp8k1ufJaa/CcOkfNZdgY0k2D8BhCRX9LwDRcFxwcYmYlU/ssxcKEmJDAaIWW5g9UiCwY0U4M8p4BQpCx270CvkYhuLUZ5GfK2pPslWIritjAVF718D173ELGxtrIHK4VQmGRwsq/4t1jvUTYWuAJMI04tsCtfw00A+gWJF8Z5YLf0I6o0O1I/Ef221iv66KpjFzZ+FKtxVV51knZAnsxpLCzULAhCc8/2Z5f+c1GGMkL/DZ9bJtn8rU2cNUD1h3JJON4p6W3Uui9U9PAGm6Hr5Nb8NB2uq+1Nfoj0rsNrXBgOidKhdTZ3uKW62+mP7myOOdR9+nNNhojmL+qu8qoqyM99amzYjMHVnVRLiWRMtCTcBOfN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(376002)(136003)(39850400004)(366004)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(2616005)(71200400001)(26005)(53546011)(36756003)(38070700005)(86362001)(122000001)(38100700002)(107886003)(83380400001)(4326008)(2906002)(478600001)(6506007)(6512007)(8676002)(6486002)(8936002)(6916009)(316002)(41300700001)(5660300002)(76116006)(54906003)(66476007)(64756008)(66446008)(66946007)(66556008)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1ppRkZ4anpnOE1DMEdSR3NwUStGTE5CdTVsdGJxT3dBbG9MYk1jRTJNVmk2?=
 =?utf-8?B?SjZzWmN4Um1xR0ZlQkVRczFWSVluSWtTWm1iY2lPMW0xZzlaa2g3czY3NnBO?=
 =?utf-8?B?azc4T3RtNFh5SHdKdS92YkZKOUlMRGt3OHVna2JWSVRkUDhOUk9DTXBxZHoy?=
 =?utf-8?B?cEZ0cENPSDg2V1U1dVVyRzlXQ1dEcVFlbjR6d0JSQTRUYnpLVHhsRDVxWVo1?=
 =?utf-8?B?cVZqQlpBbmVLOE9GZzF6c0w4N2NiK2NsbktpOXNZRG5yZUsvc0NjQkQ1RTlu?=
 =?utf-8?B?K2RNSjlqWGlXcW52b0NzcmpiU3Jub0k5UXkzV3ZnMkxkaGJoMGxrMmwxaFpa?=
 =?utf-8?B?RVBkbnVTYUlhMjUwVmxUNjh5cURzZE1XSkR6R0huaXBaV1Z6STA1MEIycnhz?=
 =?utf-8?B?NFpIMGUxYTRKRHRFVzlTTnpsT1hCQ1R5bHhYTDBpTnUzSjYvWlNvUVE1TFlR?=
 =?utf-8?B?UTdXL3NPMFA4Z1MwVFpDZTFla1BzK0l6c2VJVnZKS3RuY09Pck8vTHFIOXR0?=
 =?utf-8?B?OS8zS2ZKWHF3TFVMTEhIRis3T3NFOXErdzVWcURtRmM1T3ZZTHBlYUZmVEox?=
 =?utf-8?B?RHR2M0s1YXB0WENzVWpTdldGL0VJSjhueVBRcnl6Z0w0TWFYbXdBaDRFN1Y0?=
 =?utf-8?B?UkZBR2gwVXBoVmE0Qm5pcnFUTzFkKzR2TTkvNlVpckNPczRscTZYMjREN3Jp?=
 =?utf-8?B?TVNsQ2dQL0ZvYk4rcjBIMTI3VzlNMmlOSmFzMzI3aklqNDBPOTJvRGQxZjZD?=
 =?utf-8?B?QVRZczZLTlFVdnJYNHJWRkF5M2Z6Q1RveTAyS3V2Q0cwU1NlWmlHcDY4SW0r?=
 =?utf-8?B?ejdLRVo4Tld1VStDWVJuL0Nidk9KZWhDQ2QrY1ltdzV3SGV6Qk50ZVFyT2V1?=
 =?utf-8?B?eWgrdTlXdnlQbFJMR2s0QXFzdndmTlpwT1IyTTVnL1kreTRWeGM3K01lTVc0?=
 =?utf-8?B?WDVGb29QZzFobFUxdW5lVDVUVmJsUFFuWGVXMTJZaEx5RXBxVENvdkpSS1pI?=
 =?utf-8?B?QXRuRHRJTGE0SGhRaFU0Z2svTzM1dDBKaERqWkxkd1RVb0FYL0ZweHBhWDNR?=
 =?utf-8?B?TVpXa2pRMTlmR3hIQ0xSNVVXTnUxSzZQR0F2L3VHTWFPc0FBejJkTzJ4dTlX?=
 =?utf-8?B?U0tNbTN1SUdzT29ndTZ5RFd4SFQ1Z3Q0aklzZ3RyN2dQN3E0MXBsK1c0b1dR?=
 =?utf-8?B?aW05VmlkSVFFSUJRby9rV3NDUGJOaVlGUU8rcGpMS2I5elZMMFcyUS9mMjgw?=
 =?utf-8?B?YmFRYUVDZ215UjRBUmZVbStQNEtwcUFKeFJrTjdQZ0gvZzVoVUZtSnZQanRs?=
 =?utf-8?B?dFpwWWJ4dU1ueGk5VEdRQmhyZjVoZE0ySHptT05WZkdaWVNqSjJ4WEZSZEVq?=
 =?utf-8?B?Y0xaMGZFZGpvVDU4bGhaQnVUQTVYZS8vNnVvdTZSNk1nTEtBdDF1dzNDYXNs?=
 =?utf-8?B?OEJxR041TkpJczVRZVRpOWowaGliRVN1UFRZdDRROHhmZmJDV3NGeVYxVXpy?=
 =?utf-8?B?aXNZRlhVajBad1h2V0EvazI1MERZL2hTL3FwSmlqSTIrc3pwK2NWZ2JWN3ZX?=
 =?utf-8?B?ZU1iWVNWS3M3MVZSZmJiUmFUNVIvdkJUT28yM2hJQmJWQ1ozSHJKc3M2Z1FI?=
 =?utf-8?B?QnZVallNanRNV0ZsSVpEdUt5d1czMm1UWlBENzQzYXRkTUZ2SCtzaVdxUHhz?=
 =?utf-8?B?MlBDd1BTZ1hpSEpSYnBFazRZTHNrWXpBaVVkNEZFcWVhNjFDRGQ5Smc0WXR4?=
 =?utf-8?B?bVZPcTNNUVdLZEx4bzE0NFdFUDBpUjI5T1R4WmNYUnY2bDBOYTJaU2pkODRk?=
 =?utf-8?B?b3VXZDZ2VWIyaDBWRWJqREdWd1J0c1A5MXpzdG95RGFFR0RNczIwOUlRNUsx?=
 =?utf-8?B?aXdMWHNoS2xZM3E4L0hPNy9LcVBIZVRMTXFhUWdHa0ZjSUgrQUNSdVJTclRK?=
 =?utf-8?B?SlRxeUxWYmlHdWFTT0tEZDlnSzZObzQzdmM3bnNBSlloSFRxVWNVb0RCRGJF?=
 =?utf-8?B?TExUeEVKSFRFb25XNDVEM3NhQU1Bb1IvdnNiQXZOR0tZckxzdDg0dS90NjNt?=
 =?utf-8?B?QWova0FOd2Q5VStReFM2Y2NVNHRzU00weklmT2JPUmNBRnd4dll5Q0R0L0dl?=
 =?utf-8?B?aTcvbnVzYzJMKzFOemlUaEV2TzI3MUgwYWNYeUF3T1RKNzBTdmlUMjI4TVBU?=
 =?utf-8?B?dXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95495FAFCC16F34AA24E65A9C0FCC5EB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5565.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9071e908-4985-4f33-43a6-08dbc7f6bb6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2023 12:04:32.2798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FyZmT77SajIOWLman597CNC3X+TKL1F6d6JXO4UmQqF9ZgFrk21XKR7vLo0AK9TERupJ3xo8T8L+L0F7N5CArg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6123
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIzLTEwLTA4IGF0IDEyOjI1ICswODAwLCBKYXNvbiBXYW5nIHdyb3RlOg0KPiBP
biBUdWUsIFNlcCAyNiwgMjAyMyBhdCAzOjIx4oCvUE0gRHJhZ29zIFRhdHVsZWEgPGR0YXR1bGVh
QG52aWRpYS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFR1ZSwgMjAyMy0wOS0yNiBhdCAxMjo0
NCArMDgwMCwgSmFzb24gV2FuZyB3cm90ZToNCj4gPiA+IE9uIFR1ZSwgU2VwIDEyLCAyMDIzIGF0
IDk6MDLigK9QTSBEcmFnb3MgVGF0dWxlYSA8ZHRhdHVsZWFAbnZpZGlhLmNvbT4NCj4gPiA+IHdy
b3RlOg0KPiA+ID4gPiANCj4gPiA+ID4gVGhpcyBwYXRjaCBhZGFwdHMgdGhlIG1yIGNyZWF0aW9u
L2RlbGV0aW9uIGNvZGUgdG8gYmUgYWJsZSB0byB3b3JrIHdpdGgNCj4gPiA+ID4gYW55IGdpdmVu
IG1yIHN0cnVjdCBwb2ludGVyLiBBbGwgdGhlIEFQSXMgYXJlIGFkYXB0ZWQgdG8gdGFrZSBhbiBl
eHRyYQ0KPiA+ID4gPiBwYXJhbWV0ZXIgZm9yIHRoZSBtci4NCj4gPiA+ID4gDQo+ID4gPiA+IG1s
eDVfdmRwYV9jcmVhdGUvZGVsZXRlX21yIGRvZXNuJ3QgbmVlZCBhIEFTSUQgcGFyYW1ldGVyIGFu
eW1vcmUuIFRoZQ0KPiA+ID4gPiBjaGVjayBpcyBkb25lIGluIHRoZSBjYWxsZXIgaW5zdGVhZCAo
bWx4NV9zZXRfbWFwKS4NCj4gPiA+ID4gDQo+ID4gPiA+IFRoaXMgY2hhbmdlIGlzIG5lZWRlZCBm
b3IgYSBmb2xsb3d1cCBwYXRjaCB3aGljaCB3aWxsIGludHJvZHVjZSBhbg0KPiA+ID4gPiBhZGRp
dGlvbmFsIG1yIGZvciB0aGUgdnEgZGVzY3JpcHRvciBkYXRhLg0KPiA+ID4gPiANCj4gPiA+ID4g
U2lnbmVkLW9mZi1ieTogRHJhZ29zIFRhdHVsZWEgPGR0YXR1bGVhQG52aWRpYS5jb20+DQo+ID4g
PiA+IC0tLQ0KPiA+ID4gDQo+ID4gPiBUaGlua2luZyBvZiB0aGlzIGRlY291cGxpbmcgSSB0aGlu
ayBJIGhhdmUgYSBxdWVzdGlvbi4NCj4gPiA+IA0KPiA+ID4gV2UgYWR2ZXJ0aXNlIDIgYWRkcmVz
cyBzcGFjZXMgYW5kIDIgZ3JvdXBzLiBTbyB3ZSBhY3R1YWxseSBkb24ndCBrbm93DQo+ID4gPiBm
b3IgZXhhbXBsZSB3aGljaCBhZGRyZXNzIHNwYWNlcyB3aWxsIGJlIHVzZWQgYnkgZHZxLg0KPiA+
ID4gDQo+ID4gPiBBbmQgYWN0dWFsbHkgd2UgYWxsb3cgdGhlIHVzZXIgc3BhY2UgdG8gZG8gc29t
ZXRoaW5nIGxpa2UNCj4gPiA+IA0KPiA+ID4gc2V0X2dyb3VwX2FzaWQoZHZxX2dyb3VwLCAwKQ0K
PiA+ID4gc2V0X21hcCgwKQ0KPiA+ID4gc2V0X2dyb3VwX2FzaWQoZHZxX2dyb3VwLCAxKQ0KPiA+
ID4gc2V0X21hcCgxKQ0KPiA+ID4gDQo+ID4gPiBJIHdvbmRlciBpZiB0aGUgZGVjb3VwbGluZyBs
aWtlIHRoaXMgcGF0Y2ggY2FuIHdvcmsgYW5kIHdoeS4NCj4gPiA+IA0KPiA+IFRoaXMgc2NlbmFy
aW8gY291bGQgaW5kZWVkIHdvcmsuIEVzcGVjaWFsbHkgaWYgeW91IGxvb2sgYXQgdGhlIDEzJ3Ro
IHBhdGNoDQo+ID4gWzBdDQo+ID4gd2hlcmUgaHcgc3VwcG9ydCBpcyBhZGRlZC4gQXJlIHlvdSB3
b25kZXJpbmcgaWYgdGhpcyBzaG91bGQgd29yayBhdCBhbGwgb3INCj4gPiBpZiBpdA0KPiA+IHNo
b3VsZCBiZSBibG9ja2VkPw0KPiANCj4gSXQgd291bGQgYmUgZ3JlYXQgaWYgaXQgY2FuIHdvcmsg
d2l0aCB0aGUgZm9sbG93aW5nIHBhdGNoZXMuIEJ1dCBhdA0KPiBsZWFzdCBmb3IgdGhpcyBwYXRj
aCwgaXQgc2VlbXMgbm90Og0KPiANCj4gRm9yIGV4YW1wbGUsIHdoYXQgaGFwcGVucyBpZiB3ZSBz
d2l0Y2ggYmFjayB0byBncm91cCAwIGZvciBkdnE/DQo+IA0KPiBzZXRfZ3JvdXBfYXNpZChkdnFf
Z3JvdXAsIDApDQo+IHNldF9tYXAoMCkNCj4gc2V0X2dyb3VwX2FzaWQoZHZxX2dyb3VwLCAxKQ0K
PiBzZXRfbWFwKDEpDQo+IC8vIGhlcmUgd2UgZGVzdHJveSB0aGUgbXIgY3JlYXRlZCBmb3IgYXNp
ZCAwDQo+IHNldF9ncm91cF9hc2lkKGR2cV9ncm91cCwgMCkNCj4gDQpJZiBieSBkZXN0cm95IHlv
dSBtZWFuIC5yZXNldCwgSSB0aGluayBpdCB3b3JrczogRHVyaW5nIC5yZXNldCB0aGUgbWFwcGlu
ZyBpbg0KQVNJRCAwIGlzIHJlc2V0IGJhY2sgdG8gdGhlIERNQS9weXNpY2FsIG1hcCAobWx4NV92
ZHBhX2NyZWF0ZV9kbWFfbXIpLiBBbSBJDQptaXNzaW5nIHNvbWV0aGluZz8NCg0KPiBCdHcsIGlm
IHRoaXMgaXMgYSBuZXcgaXNzdWUsIEkgaGF2ZW4ndCBjaGVja2VkIHdoZXRoZXIgb3Igbm90IGl0
DQo+IGV4aXN0cyBiZWZvcmUgdGhpcyBzZXJpZXMgKGlmIHllcywgd2UgY2FuIGZpeCBvbiB0b3Ap
Lg0KDQo+ID4gDQo+ID4gPiBJdCBsb29rcyB0byBtZSB0aGUgbW9zdCBlYXN5IHdheSBpcyB0byBs
ZXQgZWFjaCBBUyBiZSBiYWNrZWQgYnkgYW4gTVIuDQo+ID4gPiBUaGVuIHdlIGRvbid0IGV2ZW4g
bmVlZCB0byBjYXJlIGFib3V0IHRoZSBkdnEsIGN2cS4NCj4gPiBUaGF0J3Mgd2hhdCB0aGlzIHBh
dGNoIHNlcmllcyBkb3dlcy4NCj4gDQo+IEdvb2QgdG8ga25vdyB0aGlzLCBJIHdpbGwgcmV2aWV3
IHRoZSBzZXJpZXMuDQo+IA0KSSB3YXMgcGxhbm5pbmcgdG8gc3BpbiBhIHYzIHdpdGggRXVnZW5p
bydzIHN1Z2dlc3Rpb25zLiBTaG91bGQgSSB3YWl0IGZvciB5b3VyDQpmZWVkYmFjayBiZWZvcmUg
ZG9pbmcgdGhhdD8NCg0KVGhhbmtzLA0KRHJhZ29zDQo=
