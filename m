Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2B37BD403
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 09:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345305AbjJIHGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 03:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbjJIHGc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 03:06:32 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2043.outbound.protection.outlook.com [40.107.212.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F210A3;
        Mon,  9 Oct 2023 00:06:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Idk6g4T+frIfdDNYlRJV8+yiEPxaa5l1VCp80RWUcueE/aAVj3Ow4M7Okm8ks3oGHCKPagjwS0RY6wm/N2wgQp+6aDmxhV9dexU+tUHHrnpqqHoXTVFtoiCOBstOny1uaawAs/W0NDs9gvJS8+T/iz/RMIuifrGw5qQp/ktS7BAD85lUKIG3rSajyZBZGMtLQkGZ+H+0ZIRvHvqDfUxvspfucwRjziipQ4h1/BaKXNQrOj2r5hoBZIuUU2utrbvNS3H9q00t2605ERo79PGBpy7eTrAbWQRldFO2sb1JZmlir39KTn2H/N45v6F3eKV7bshRziGjErvs1S9SEw0U5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNXS7XliifKbu9N34p4iqPAUCxS2JGhBoTzMEsX/KWQ=;
 b=cbItQr1d/DvKo6zALGxMyNTmu2cqJFzwPklBDt8w4QQgp1jQO+k0mvXRvJ0cJW7DHWKVFL+jRUl/kX3pXKfRxCWEqLdDHHDcURLQoyrFZQDbxnlvaXjH2ldZ62BQb0r7HS/W8/2M+T4il7CZBsZuqgh1sx7vzQv8ooxCB3dAWAE6f4ikcadKzeXqG5q3rynyOpGxPoyKfKfqLnKT2Qbzkllc0dUhAWCjKQvo8Yor7HiStMkGrsRcvPy3Te0lsPIkvDSJyse/bQtRmzJlsDA+Eh1rD7JiGv+sP9koMJDt8uShsmISBeHScw34XDyCdLm8BY8dENvr0KM9+AgB2Zz9UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNXS7XliifKbu9N34p4iqPAUCxS2JGhBoTzMEsX/KWQ=;
 b=hXrnlpm1IvjryuohRtHV9EmYjA7CLKIS7Glw/5qxpmDJe5TGwA+li/7GytNcjvypQ8eZVOstAMT8ddgcSctiydiqbYmkaEPVIAC0yxIbJZNbVYw1VOy/VQ1Bl+51zu8HpQqI9/PSaVoxXHm+QngTUnX7DNX1Ba4iM4ph71W7dwE88NTCMb9jg+FO61JULGeTFz6OU8pE6r057EiYy2lajmB55dCGjEvYIkg4AmxIEbFAPrJiqZvL2z6dKNBBcw6ZahrboyjYRHv35vW/HN4oM75SeogrFJC4100fB/C42dcbObpQWL78aJXFTxFOev2/S2Trgj4rgFRzzs9D2GQ0tQ==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by LV2PR12MB5990.namprd12.prod.outlook.com (2603:10b6:408:170::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Mon, 9 Oct
 2023 07:06:28 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::fddf:d4b8:44d9:d378]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::fddf:d4b8:44d9:d378%7]) with mapi id 15.20.6863.032; Mon, 9 Oct 2023
 07:06:28 +0000
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
Thread-Index: AQHZ5Xlk30nZFuaBXUOyCVsOMD7qbrAsnWKAgAAr3QCAEqqpAIAAgFWAgAE3jQCAAAd/AA==
Date:   Mon, 9 Oct 2023 07:06:28 +0000
Message-ID: <04488d248f425936fa8714552ed8b27c644a3257.camel@nvidia.com>
References: <20230912130132.561193-1-dtatulea@nvidia.com>
         <20230912130132.561193-10-dtatulea@nvidia.com>
         <CACGkMEsC_rgnKyG3stFbc-Mz2yiKGwNUYYqG64jQbNpZBtnVvg@mail.gmail.com>
         <c42db8942523afe8bbf54815f672acd9e47cfa67.camel@nvidia.com>
         <CACGkMEvZESDuOiX_oOvMUh0YqCWYqvmD3Ve9YEJW3+RXXyvGew@mail.gmail.com>
         <4f9759182636f7bb3cb15bc8b6ec6afbe0d6053d.camel@nvidia.com>
         <CACGkMEvt5B_3i1wOs2yt0KmEYPpSMd_DRJ2==xzp9eMCwww4oQ@mail.gmail.com>
In-Reply-To: <CACGkMEvt5B_3i1wOs2yt0KmEYPpSMd_DRJ2==xzp9eMCwww4oQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|LV2PR12MB5990:EE_
x-ms-office365-filtering-correlation-id: cbc64471-4b58-4604-960e-08dbc8964216
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ErKKsePWe6P7yknTYy46hMElezYm1es4DJIFIWashU7+NcaovFIZSqEOe/igJhlY/nWcFKBdf2RcSDwKyijzPvH77jnCUiDgt8Vha84FvuRs3C8RAgnQmCCqUw/9x94NfocEWt1ZNx7ZyNtiza9WbZOJjMtdmkUYdTdbHWcL2OhvMa8hStNYf4/ptyU+e/3vm1p81i1Fogqe3RkdiczpEpfMlV6AL5CTSqbBM8+InW33VUXS5KoqZlYKqE/trTgNvGLMqK0k3qvKrFQAPZ8uz/oryaxLQpgnxwKviIwncSiKo1VxrPIPr9MoPCuOpE/NFzN6tsZNPtyX4K47OyVAoqh4SAZeT6ZqCMleWiCa6hPlr6EhcyqgaXt5v6xRtHspakUczz6wBoigXyB99sKJv92h1f2dePPCgXKjju+oMt2BIeIhPzRzub9JZi9bcQPF8M8k4W28KzAP4N0y9S4d1OUi1iRn5mHs2FUvXGKMUVpzXs3d7KhoMw8WXSfkinTszGTyk7f2fnmLyK1+UzpCSMJjU12V2u5OQDgJLVYNYi1+rHDL+faPev7K6cq+INpFN3LwKnCFRes22pWNpUPpha8ueLX6ocBmsaoPG+JwM6k/aStI+UfUumbfEOIP0PCk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(376002)(136003)(366004)(39860400002)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(83380400001)(107886003)(2616005)(26005)(66946007)(66476007)(66556008)(66446008)(64756008)(76116006)(91956017)(316002)(6916009)(54906003)(8936002)(8676002)(4326008)(41300700001)(5660300002)(6506007)(53546011)(71200400001)(6512007)(2906002)(6486002)(478600001)(36756003)(38070700005)(38100700002)(122000001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkV1b2toQ0tIN3F3TVB6SkZUM3Z5ZW02UE1GR1Ntc1RtaHA0ZUFHa0xsSEo5?=
 =?utf-8?B?dU5sbzlkb3Jwam81Y1k3VEIxeEVtSnloRGRMSDl6N0ZtNitYNU9qcld6R043?=
 =?utf-8?B?Q1F4dExvVExpODN2bm8rVkFWZmFhc1dOaEh6RWxHcW1CQlFkeFZoRUhkc2N0?=
 =?utf-8?B?MkUyVUE0SStCeWlUKy9jZHJXZHZVN1J4MTBQZk9RK2lZN3NLZXhDQldyQVVK?=
 =?utf-8?B?VTcvSEpTTndHTXgvUzZYNGphWXBYUldPYmpwVmEzb3lBUzdubDVpQjRaT3hD?=
 =?utf-8?B?clFLK2RQTE1xUnJYdmJQTWJmMS8xY1FjTnJUbk0wWDhRNFFpZVhLWXY5L200?=
 =?utf-8?B?aUtWWnU1YkxmeXlSQTU5Nzh1eDhDOHUwUm5PaGpUM0ZwcjVUWlRUM0tPK1JY?=
 =?utf-8?B?WmVCdVlxN0lXZnBzMjluRUluNkVacTZIUTFYcnNXQlU5Yk5BT0JVaGpjK0Fw?=
 =?utf-8?B?QVltV1kxV1I0aEhXTGplZHYrb2t4U1EyZEQ3Zm1TaU9Za05VbGtPMVNlV3lz?=
 =?utf-8?B?L3ZwZkJJMDBveTQwZ0RLejBPNGlHYmx4R053b0xSa1c0VHdjdWZIMlo2cFVK?=
 =?utf-8?B?WU5YanJmNHFmSGg4T2EzR1Q2V0FQUTZyUThIS2VHM0FaRlhTU093MmNhc2NP?=
 =?utf-8?B?SG1KYW9jZmZhRzY0d3N6SVZOOFo2TGlFcDhpL2ZZamluZ053amo4blB3dkgz?=
 =?utf-8?B?b0h4b3VVMVhJU3hKNDhweGtVVk45aERHYUM2bmRJMlMvMUZwRGRmTUtFZkla?=
 =?utf-8?B?elhnblcrU0hncTV0Y21BeXdrcGszMndMOVZ0WVhUeWZTZC9VRHJrSVkreWJG?=
 =?utf-8?B?NjBjUEhXMGdIbGJzVGlLenFLS0JHTDFjdXFwMmd5bkF3RlVRTVZqQXNaYTgz?=
 =?utf-8?B?bndZZncrSW54ZDdnenZ6NzYreHNWZXFXNG9kUlVBemFMdnRQeis2QVFQSGs2?=
 =?utf-8?B?ZXRQY1RaZ084OTVEU2lIdjFlQ2N1anFwTjZLYm9aYVBoRXZ5WWExQ0VWd2dC?=
 =?utf-8?B?d0ZOMldoMkxWYWhabFZhZ0I0ZEQrMDZLenF5UGMxN1pQVVlqK3VuVDE5cDhl?=
 =?utf-8?B?SXBKbHI5UjJETG5SZUtPS1R6OGVUYXpBekJtYW85dmt2TjR5MzExdjJJdU9W?=
 =?utf-8?B?VEhFb0dyVGk4ai8xU2cvb0lDV2ZWMmRjYTMxVGQwVm54eXdIcGxJSHlFL3Q5?=
 =?utf-8?B?b3FvZUhmUVRQUVZOS3R3UnFEME9abGRyZThjTURpUUx1alA3NDRvdTBTeFRB?=
 =?utf-8?B?RmZlOXk2NGxqWU5iVFdPcDJlaURCbENNZDFWZmNyQVRPOEVBUGR2amxFcGI5?=
 =?utf-8?B?MklUZWRHUXNZcDRjYmJKd1krbEd1eGIrYy9RcXJjb0JiMldRRWtLa3RlWDRv?=
 =?utf-8?B?MUF2MzJrUExFNUthZW1icGtMWGNuQURzK0krMzFoSmxSSnIxUWdYalBhcVpY?=
 =?utf-8?B?OVgrbWNlU1V2VTNRRHAxbTQxcUpqdEliSzRDcGlsQktFOXVHbGZnRjRCZS81?=
 =?utf-8?B?ZTA3bXdMS1pKdmJhNTlRMHZFNFBKek4wS0JUa05DQlBQdU9xMFB2cmpjSUF5?=
 =?utf-8?B?R0xvRHN2Uk9KL3RuV1ZtWU0xTm1XSWw4YUVYNVg4dW1xeGRHTER3Y2QweGJI?=
 =?utf-8?B?b201aEJtanl5NHBzcFlUUUFLKzJ4V3NTb09reEc2blFiNE83UDNiQUVmMDV2?=
 =?utf-8?B?TmJLR0FJNnh0eVRiMzdwdVpSRDJocEFBQXh5c2RqSXErcU55RVllS1FGWHht?=
 =?utf-8?B?QmNFK3E2SDlHbkZJY29jdFV2RDRaT0x4YldxSlJxS3BlMjhzME55UnZVVU1j?=
 =?utf-8?B?Zmoyalo0VTVJVHNrOWFFWHN2cVdZNW5hZVNJTkRSaE16YlNSdFlMU2Q4Z2hC?=
 =?utf-8?B?UzUxS0hxbXNDWE5mYWNtTWVlalkvODFPY0c4UHUvVDFvVUlQcVJBVDIvTk9l?=
 =?utf-8?B?ZmFrcFl4bWhublRIZ3RPM2dzR2l1MmVTZjF1MmhrWXNKY0tUTnpnSVNuNU94?=
 =?utf-8?B?Z005aWczNEpEKzlxN2NEMm5MTDQwbVc5ekpkZWQ0WlkxaUFnMVFmUEpBemla?=
 =?utf-8?B?SkR0b1BTdGlKRDFOMnM2L2RrRTdQRFV6ampaSUFBekdNSS9BcS9WbGY2WW8w?=
 =?utf-8?B?Q2d4TnZnWWlMcEhacExnTDErRUoyVjZjUE5LdkZlMjQxMHdsRERpcWxvNDZW?=
 =?utf-8?B?cVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1D28915A3334B4BA535D42A40B8765A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5565.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbc64471-4b58-4604-960e-08dbc8964216
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2023 07:06:28.1948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9qHU8sYYGo8LfMzoOTwsSXL9Jd6IxDwdLQ8MV48uBTkBzdnRJIlL3ixqycmCKm9+vn/FKYYEGkF+ev3awtPs9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5990
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTEwLTA5IGF0IDE0OjM5ICswODAwLCBKYXNvbiBXYW5nIHdyb3RlOg0KPiBP
biBTdW4sIE9jdCA4LCAyMDIzIGF0IDg6MDXigK9QTSBEcmFnb3MgVGF0dWxlYSA8ZHRhdHVsZWFA
bnZpZGlhLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gT24gU3VuLCAyMDIzLTEwLTA4IGF0IDEyOjI1
ICswODAwLCBKYXNvbiBXYW5nIHdyb3RlOg0KPiA+ID4gT24gVHVlLCBTZXAgMjYsIDIwMjMgYXQg
MzoyMeKAr1BNIERyYWdvcyBUYXR1bGVhIDxkdGF0dWxlYUBudmlkaWEuY29tPg0KPiA+ID4gd3Jv
dGU6DQo+ID4gPiA+IA0KPiA+ID4gPiBPbiBUdWUsIDIwMjMtMDktMjYgYXQgMTI6NDQgKzA4MDAs
IEphc29uIFdhbmcgd3JvdGU6DQo+ID4gPiA+ID4gT24gVHVlLCBTZXAgMTIsIDIwMjMgYXQgOTow
MuKAr1BNIERyYWdvcyBUYXR1bGVhIDxkdGF0dWxlYUBudmlkaWEuY29tPg0KPiA+ID4gPiA+IHdy
b3RlOg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBUaGlzIHBhdGNoIGFkYXB0cyB0aGUgbXIg
Y3JlYXRpb24vZGVsZXRpb24gY29kZSB0byBiZSBhYmxlIHRvIHdvcmsNCj4gPiA+ID4gPiA+IHdp
dGgNCj4gPiA+ID4gPiA+IGFueSBnaXZlbiBtciBzdHJ1Y3QgcG9pbnRlci4gQWxsIHRoZSBBUElz
IGFyZSBhZGFwdGVkIHRvIHRha2UgYW4NCj4gPiA+ID4gPiA+IGV4dHJhDQo+ID4gPiA+ID4gPiBw
YXJhbWV0ZXIgZm9yIHRoZSBtci4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gbWx4NV92ZHBh
X2NyZWF0ZS9kZWxldGVfbXIgZG9lc24ndCBuZWVkIGEgQVNJRCBwYXJhbWV0ZXIgYW55bW9yZS4N
Cj4gPiA+ID4gPiA+IFRoZQ0KPiA+ID4gPiA+ID4gY2hlY2sgaXMgZG9uZSBpbiB0aGUgY2FsbGVy
IGluc3RlYWQgKG1seDVfc2V0X21hcCkuDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IFRoaXMg
Y2hhbmdlIGlzIG5lZWRlZCBmb3IgYSBmb2xsb3d1cCBwYXRjaCB3aGljaCB3aWxsIGludHJvZHVj
ZSBhbg0KPiA+ID4gPiA+ID4gYWRkaXRpb25hbCBtciBmb3IgdGhlIHZxIGRlc2NyaXB0b3IgZGF0
YS4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gU2lnbmVkLW9mZi1ieTogRHJhZ29zIFRhdHVs
ZWEgPGR0YXR1bGVhQG52aWRpYS5jb20+DQo+ID4gPiA+ID4gPiAtLS0NCj4gPiA+ID4gPiANCj4g
PiA+ID4gPiBUaGlua2luZyBvZiB0aGlzIGRlY291cGxpbmcgSSB0aGluayBJIGhhdmUgYSBxdWVz
dGlvbi4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBXZSBhZHZlcnRpc2UgMiBhZGRyZXNzIHNwYWNl
cyBhbmQgMiBncm91cHMuIFNvIHdlIGFjdHVhbGx5IGRvbid0IGtub3cNCj4gPiA+ID4gPiBmb3Ig
ZXhhbXBsZSB3aGljaCBhZGRyZXNzIHNwYWNlcyB3aWxsIGJlIHVzZWQgYnkgZHZxLg0KPiA+ID4g
PiA+IA0KPiA+ID4gPiA+IEFuZCBhY3R1YWxseSB3ZSBhbGxvdyB0aGUgdXNlciBzcGFjZSB0byBk
byBzb21ldGhpbmcgbGlrZQ0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IHNldF9ncm91cF9hc2lkKGR2
cV9ncm91cCwgMCkNCj4gPiA+ID4gPiBzZXRfbWFwKDApDQo+ID4gPiA+ID4gc2V0X2dyb3VwX2Fz
aWQoZHZxX2dyb3VwLCAxKQ0KPiA+ID4gPiA+IHNldF9tYXAoMSkNCj4gPiA+ID4gPiANCj4gPiA+
ID4gPiBJIHdvbmRlciBpZiB0aGUgZGVjb3VwbGluZyBsaWtlIHRoaXMgcGF0Y2ggY2FuIHdvcmsg
YW5kIHdoeS4NCj4gPiA+ID4gPiANCj4gPiA+ID4gVGhpcyBzY2VuYXJpbyBjb3VsZCBpbmRlZWQg
d29yay4gRXNwZWNpYWxseSBpZiB5b3UgbG9vayBhdCB0aGUgMTMndGgNCj4gPiA+ID4gcGF0Y2gN
Cj4gPiA+ID4gWzBdDQo+ID4gPiA+IHdoZXJlIGh3IHN1cHBvcnQgaXMgYWRkZWQuIEFyZSB5b3Ug
d29uZGVyaW5nIGlmIHRoaXMgc2hvdWxkIHdvcmsgYXQgYWxsDQo+ID4gPiA+IG9yDQo+ID4gPiA+
IGlmIGl0DQo+ID4gPiA+IHNob3VsZCBiZSBibG9ja2VkPw0KPiA+ID4gDQo+ID4gPiBJdCB3b3Vs
ZCBiZSBncmVhdCBpZiBpdCBjYW4gd29yayB3aXRoIHRoZSBmb2xsb3dpbmcgcGF0Y2hlcy4gQnV0
IGF0DQo+ID4gPiBsZWFzdCBmb3IgdGhpcyBwYXRjaCwgaXQgc2VlbXMgbm90Og0KPiA+ID4gDQo+
ID4gPiBGb3IgZXhhbXBsZSwgd2hhdCBoYXBwZW5zIGlmIHdlIHN3aXRjaCBiYWNrIHRvIGdyb3Vw
IDAgZm9yIGR2cT8NCj4gPiA+IA0KPiA+ID4gc2V0X2dyb3VwX2FzaWQoZHZxX2dyb3VwLCAwKQ0K
PiA+ID4gc2V0X21hcCgwKQ0KPiA+ID4gc2V0X2dyb3VwX2FzaWQoZHZxX2dyb3VwLCAxKQ0KPiA+
ID4gc2V0X21hcCgxKQ0KPiA+ID4gLy8gaGVyZSB3ZSBkZXN0cm95IHRoZSBtciBjcmVhdGVkIGZv
ciBhc2lkIDANCj4gPiA+IHNldF9ncm91cF9hc2lkKGR2cV9ncm91cCwgMCkNCj4gPiA+IA0KPiA+
IElmIGJ5IGRlc3Ryb3kgeW91IG1lYW4gLnJlc2V0LA0KPiANCj4gSXQncyBub3QgcmVzdC4gRHVy
aW5nIHRoZSBzZWNvbmQgbWFwLCB0aGUgbXIgaXMgZGVzdHJveWVkIGJ5DQo+IG1seDVfdmRwYV9j
aGFuZ2VfbWFwKCkuDQo+IA0KT2gsIG5vdyBJIHVuZGVyc3RhbmQgd2hhdCB5b3UgbWVhbi4gVGhp
cyBpcyBub3QgdGhlIGNhc2UgYW55bW9yZS4gVGhpcyBwYXRjaA0Kc2VyaWVzIGludHJvZHVjZXMg
b25lIG1yIHBlciBhc2lkLiBtbHg1X3ZkcGFfY2hhbmdlX21hcCB3aWxsIG9ubHkgZGVzdHJveSB0
aGUNCm9sZCBtciBpbiB0aGUgZ2l2ZW4gYXNpZC4gQmVmb3JlLCB0aGVyZSB3YXMgb25lIG1yIGZv
ciBhbGwgYXNpZHMuDQoNCj4gwqBJIHRoaW5rIGl0IHdvcmtzOiBEdXJpbmcgLnJlc2V0IHRoZSBt
YXBwaW5nIGluDQo+ID4gQVNJRCAwIGlzIHJlc2V0IGJhY2sgdG8gdGhlIERNQS9weXNpY2FsIG1h
cCAobWx4NV92ZHBhX2NyZWF0ZV9kbWFfbXIpLiBBbSBJDQo+ID4gbWlzc2luZyBzb21ldGhpbmc/
DQo+ID4gDQo+ID4gPiBCdHcsIGlmIHRoaXMgaXMgYSBuZXcgaXNzdWUsIEkgaGF2ZW4ndCBjaGVj
a2VkIHdoZXRoZXIgb3Igbm90IGl0DQo+ID4gPiBleGlzdHMgYmVmb3JlIHRoaXMgc2VyaWVzIChp
ZiB5ZXMsIHdlIGNhbiBmaXggb24gdG9wKS4NCj4gPiANCj4gPiA+ID4gDQo+ID4gPiA+ID4gSXQg
bG9va3MgdG8gbWUgdGhlIG1vc3QgZWFzeSB3YXkgaXMgdG8gbGV0IGVhY2ggQVMgYmUgYmFja2Vk
IGJ5IGFuIE1SLg0KPiA+ID4gPiA+IFRoZW4gd2UgZG9uJ3QgZXZlbiBuZWVkIHRvIGNhcmUgYWJv
dXQgdGhlIGR2cSwgY3ZxLg0KPiA+ID4gPiBUaGF0J3Mgd2hhdCB0aGlzIHBhdGNoIHNlcmllcyBk
b3dlcy4NCj4gPiA+IA0KPiA+ID4gR29vZCB0byBrbm93IHRoaXMsIEkgd2lsbCByZXZpZXcgdGhl
IHNlcmllcy4NCj4gPiA+IA0KPiA+IEkgd2FzIHBsYW5uaW5nIHRvIHNwaW4gYSB2MyB3aXRoIEV1
Z2VuaW8ncyBzdWdnZXN0aW9ucy4gU2hvdWxkIEkgd2FpdCBmb3INCj4gPiB5b3VyDQo+ID4gZmVl
ZGJhY2sgYmVmb3JlIGRvaW5nIHRoYXQ/DQo+IA0KPiBZb3UgY2FuIHBvc3QgdjMgYW5kIHdlIGNh
biBtb3ZlIHRoZSBkaXNjdXNzaW9uIHRoZXJlIGlmIHlvdSB3aXNoLg0KPiANCkFjay4NCg0KVGhh
bmtzLA0KRHJhZ29zDQo=
