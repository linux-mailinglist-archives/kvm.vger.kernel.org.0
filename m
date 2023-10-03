Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175067B5FC1
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 06:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239006AbjJCESE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 00:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjJCESD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 00:18:03 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2055.outbound.protection.outlook.com [40.107.96.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0FDBF
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 21:18:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OAMerBjAZ/ANMVZEGiA1T9OSxtL0LmBu4dcqDMGW0AApjXyTYZ0UaU07G3pW3Wq6uBwqe+/frN3HKEZTyzVsYlS1htOp0HR36iuN0qNPd/3ZpEHG+dc9IrF7CcTxn1UnKHPgAui/g1p+/VEjhdpmjxMqrwdv1O06S1a15Of3nyEgQRRYLC94G9FwrtTzsE7svAA0wArJAQxgj1D4EdSri7Hfl13yFk/pWQo7lZFdejFGhTdGQLJQ3yN9AGUBG35TxzhvHqAj2DjLaE4aaySkfv1QkYrMIlbAdYOmYuapmymX9RtjHLiXhk0nNTbGnWxrHjp3JnBWa7PrpJC1tcYY5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tgWHtcRNlLE7qvpyI8dbsXJMUiACkNymGAPR++Lojtk=;
 b=YUHK0YR8htAmiKJI422YhU/QMWAIsQpo8IWm5IzXN+KBXfJoiObxxQc60jNq0Ebl2lCc3NZX8L9mCroT6XhI//IZhq+r16ptgMiHBu9aFxUN9TwM8JshJb/ymzmgWvDYuO/HFeBWZXCE3IoOEvqIDUNYZ7iD6g8NG0b75fzBBRk4JknLFeSObxCF65xTI1nCX4VGI6IZAG0N/0SL5ks5XUaQkb4+3blh7k1MdI8Wb3vaxgsytdP2myKWbDOW5X4IEZ6I3K4eXhgKj9cCnVpvSCcKkP6R3fbKjR6ZVuYJIjhJy1FAN1hOb2PpmVZjk9VIVdKMGj/8947wXWAPBaZs/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tgWHtcRNlLE7qvpyI8dbsXJMUiACkNymGAPR++Lojtk=;
 b=OkkPNJ3z/R5H7e0zTBZDwsH6yGHjKZs6YdVJIH9WkAkx1PR4y5o052nq18MzayQx2DI6CSC3Zouswct1CUDHvtYFJq+n0x+dxDgHS9KrA/+3haiewwPiPxo3bi/VcuDwAL8k1ada/x+T0o4Za997kDVEuPkHd7B8J65jAtNRzbo=
Received: from BL1PR12MB5333.namprd12.prod.outlook.com (2603:10b6:208:31f::11)
 by PH0PR12MB5433.namprd12.prod.outlook.com (2603:10b6:510:e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.29; Tue, 3 Oct
 2023 04:17:56 +0000
Received: from BL1PR12MB5333.namprd12.prod.outlook.com
 ([fe80::71c9:f18e:9507:e63c]) by BL1PR12MB5333.namprd12.prod.outlook.com
 ([fe80::71c9:f18e:9507:e63c%6]) with mapi id 15.20.6838.030; Tue, 3 Oct 2023
 04:17:56 +0000
From:   "Agarwal, Nikhil" <nikhil.agarwal@amd.com>
To:     Nathan Chancellor <nathan@kernel.org>,
        "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "trix@redhat.com" <trix@redhat.com>,
        "Rohila, Shubham" <shubham.rohila@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH] vfio/cdx: Add parentheses between bitwise AND expression
 and logical NOT
Thread-Topic: [PATCH] vfio/cdx: Add parentheses between bitwise AND expression
 and logical NOT
Thread-Index: AQHZ9VlYlqtzYHYjH0u+N9fbUI4AwbA3dcAw
Date:   Tue, 3 Oct 2023 04:17:55 +0000
Message-ID: <BL1PR12MB53339025973C7B3CFDED181A9DC4A@BL1PR12MB5333.namprd12.prod.outlook.com>
References: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
In-Reply-To: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=13c49e5b-97c3-41ce-bdba-b1f367773af0;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=0;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2023-10-03T04:15:21Z;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5333:EE_|PH0PR12MB5433:EE_
x-ms-office365-filtering-correlation-id: 75619162-5691-4f21-1a9b-08dbc3c7b833
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sZKD8+/vsdk8X0YqtwJLMU6IB/LPz+/d0ZVsgRPnbIQQZZGn0i3BaRZGf9nRiAuJXzmziYOL2aLLK7mBq8rEz+OERPZCaUaKLJ9B6yoqWKfAfNttWRoKJexHNDD62qPi0j4Z+LHmQNWgL6Qkt3AfT5/Nzq8UG8FSF5cDVKyiqouEQ55fWUUFblPtWBhjU3EW0e9+o/uQ4khbtsBZhCyVSvaMPEm2Yu2VSH8l2JTqfqjl5+eM9M9MU7aAKkdKN3iTOoiwSA+f5C7GkmwIH+qz4CZjd6PMpDGt6T1F6r2frJtu7nSuWF4FOlneyXWzVBHJ0QiDIPeF8OBaoIuSP0ZNuLC7ZK40cClP8i2P6ER1zdVYx8liqe4O2qVv4SnSmBwJ/eOuhuDnPdVYgODKfcvDvdRKmGVoJOyeTpGRlGQLwnGfSrVHedR+Q/6B8V0t5Mg4vkYyWZ0mFWCacV/aWZj/bj/lnaEYe28F08lU6l1QO/A42Q6AOTH8sWYlYPzUEn9sgjVXmeAMgBjtWNbg3jwQAnFT2jJzCfsDd7KM1QM1qgePuW0FL4wwm3z+DzsH36HECu7IekEwhBy+hBEEhPIhd/kWiUOTmlE4as1Lt0CKyZM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5333.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(376002)(396003)(366004)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(966005)(478600001)(55016003)(52536014)(76116006)(5660300002)(7696005)(71200400001)(6506007)(316002)(53546011)(2906002)(4326008)(66476007)(8676002)(110136005)(8936002)(41300700001)(66556008)(66946007)(66446008)(54906003)(64756008)(33656002)(9686003)(86362001)(26005)(83380400001)(38100700002)(38070700005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WFkzZEhkV2UrdU44MFE5eXZOekJuQjlZcFZlTDRHWDc4OGMyMzBhVVlmcnVV?=
 =?utf-8?B?MFNObDFhYVZ6N1NhSVNUT0ZTQmN2MFZvdDAvWDZwZHNOcGtNek1kU0NPUDlz?=
 =?utf-8?B?VlFaZ3E2c29hMklucHllMFpnU3dzL0pqQkJDSlFWRXBUekFHcDBkUU55STVY?=
 =?utf-8?B?bUwrUjg1U0lFZXpYN2UyQmU1YUovNVR1RVE2NmsyUURycUo0L3VCbytQM2Vk?=
 =?utf-8?B?WmJBQm1OKzFSbWIzRUFDc21NenFaMU5pTXFGc1dDUHkyaVZoenNFTHBnc2ZE?=
 =?utf-8?B?ZkxQcEpyaDJXRXZNc0lSWExRNG1EbHdrUEhxalI3elA5QXZQcHl0WWY0ZlZU?=
 =?utf-8?B?TzZiRTdvVkRDWCtqVHUwOFltNGx3V0lVb3VEWUYvWllzNFM4Ny9TKzZZUzRH?=
 =?utf-8?B?YUlpNkNBajNFL1dDRkNwbWg0Zkl6aDNRbVV2RnFhbkJvZ0tuaGxSUWVEeU1z?=
 =?utf-8?B?SFA0YThsZnVDZ3V5RVJBcUFwUlE4cUxSaGtVV2s5WVdMWnpTRTk3QzRQSzVI?=
 =?utf-8?B?RmZoem5DVHJZam0va0pYbHVoNVJoRUZMUnRNU0NNVjJsUnNDSURqeDJrUWdL?=
 =?utf-8?B?SU1WdlZvOEUydmVEWUk5WUdGMkd3SWpzc3hQaFluYmlyVjkydEYwNndKeUFy?=
 =?utf-8?B?bUh4N2FpRHlQZ3dKc2VLMFp3K0h6bU9LdlkzajZSZFd1ZWx5VlZuT3FwcFNx?=
 =?utf-8?B?aXJpVk5iY0ZyNXNkRFYwM0d3QVI2Q0NlYWU5bkdDR0VqS1orZitZNS9IYlpp?=
 =?utf-8?B?UTVpMTlqS2FYY2RqZWpFaHVrSFV6aEN3eGwzY0R6QlpNSWprZGliTDU0bjNi?=
 =?utf-8?B?NkFsWXRFbW8vY2lDRER2Q29kSGk0SDA4eHU4d2FXNTFSaVMyekgrNHoxeGJx?=
 =?utf-8?B?bmpYTytpSVpVYUtxOU1QaG40UkM3ZSt2TGFoMSs4Z3l0SVpXSGZidGZYa2pj?=
 =?utf-8?B?K0diV0xndTNKSG92dWx5OXA2b05lUEVqbXNFRlJiTVphQWMwZFNsNEUydWxI?=
 =?utf-8?B?RXlyMzZ6ZTJIb3hUMmNDcDB3SVZ5a2swdTAvTWszSDg0L2tYK3NHM3JWS2Z2?=
 =?utf-8?B?R3BJYWc5Zit2Z0wrVjBwSVQ3RzRGTFBrYTl6TzVKaEo5ckg1dG80YmlwZVY1?=
 =?utf-8?B?bWJIM3lCQ0ZSeXBCUjNSMTFSWWVwdExpMGlLY0FhdDNDaU51Z3U5bFR1RW4z?=
 =?utf-8?B?RzdpcmxoQnJneW9FV29jS2owejlXTm8zRkVMU3F1K0V1VTZaSEx5UnovenNI?=
 =?utf-8?B?S0pyL000eTZrc29VOUl1R2ZUaHFGaUwxVHlMSUgxam5qeVkza212WnpuOGV1?=
 =?utf-8?B?V2JGNitVdEVucHFOQ3FsTVg5U2xwekZQaWw1NXBWNFZvNGUyTWNUQzYvOXVx?=
 =?utf-8?B?ak93UEpIZ3JBaU01WngycWNoQjJDV2d1SFJORFFZOG5wa0xNbkVZTlFMMzhN?=
 =?utf-8?B?MXkvandFTk96emVUT2RhTHRsSVdDSW0rVXZFa1VwVTRjb2M1UGY0Q0ZlNENx?=
 =?utf-8?B?UGp4MzMwSnZiZzBGSWwrMmszKzZEZitubzd1QndvaTc4emJZcUNXNTVzRXJ1?=
 =?utf-8?B?eXEwVTN1TTNPR3ZrWWhtYVBnaGVrLzVvSzhTamNFRC9Lb0V5M3o5Nm9weUZC?=
 =?utf-8?B?NzJ1VW1pVHJoT3R5NlRSaFZhMzczYzV3S3dqMHR6NThQZ1E2L3FkNXBmTFVC?=
 =?utf-8?B?eXlOUjNxZTFObEplMDRjWm9MenFRSjd1clJKMGU3V2V6MmFlSU5ZcW9QVWRG?=
 =?utf-8?B?T0VDM3Jwanc4SzVzM0tPdG5sRWVBQ0dOQkR0eU51T1NUYStXK0xQenFyeXBD?=
 =?utf-8?B?QXVEQ0o4TWxEOTRCRFZ1NHBzdE5xQmRSWml6b2RGRGYzVEI3b2ZKdDdBcG93?=
 =?utf-8?B?N1V1dGVuV2lWNjIvMkthdThuNjY1Q1RKWjFSTEc5bWo4Q1U4dFY2OExJSE5B?=
 =?utf-8?B?K3ZzTE5wOEw4Z0lJNExTV214cldNYVdSVmVkczQ0ZTBjUnpsUlowQWNzYm0y?=
 =?utf-8?B?OVdlSGZMTGEwOGFJTzRXcDNlL3R0amZqT1lMMnAyNGcrSC9ib2RYdEVCOXBX?=
 =?utf-8?B?UXl6NERlc3ZUcXUyamRZaWNIaENjb21aVUhFS0t0RU1VaGpIdVNKVHR5ZTNU?=
 =?utf-8?Q?PhIM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5333.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75619162-5691-4f21-1a9b-08dbc3c7b833
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2023 04:17:55.8753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Az3W8a61T0jxDvSDaH9hKzYaIw5Qk3lVXqVMef42uvibBymdb/un1MhuwhFllHz2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5433
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCj4gRnJvbTogTmF0aGFuIENoYW5jZWxsb3IgPG5hdGhhbkBrZXJuZWwub3JnPg0K
PiBTZW50OiBNb25kYXksIE9jdG9iZXIgMiwgMjAyMyAxMToyMyBQTQ0KPiBUbzogR3VwdGEsIE5p
cHVuIDxOaXB1bi5HdXB0YUBhbWQuY29tPjsgQWdhcndhbCwgTmlraGlsDQo+IDxuaWtoaWwuYWdh
cndhbEBhbWQuY29tPjsgYWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20NCj4gQ2M6IG5kZXNhdWxu
aWVyc0Bnb29nbGUuY29tOyB0cml4QHJlZGhhdC5jb207IFJvaGlsYSwgU2h1YmhhbQ0KPiA8c2h1
YmhhbS5yb2hpbGFAYW1kLmNvbT47IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGxsdm1AbGlzdHMubGlu
dXguZGV2Ow0KPiBwYXRjaGVzQGxpc3RzLmxpbnV4LmRldjsgTmF0aGFuIENoYW5jZWxsb3IgPG5h
dGhhbkBrZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBbUEFUQ0hdIHZmaW8vY2R4OiBBZGQgcGFyZW50
aGVzZXMgYmV0d2VlbiBiaXR3aXNlIEFORCBleHByZXNzaW9uDQo+IGFuZCBsb2dpY2FsIE5PVA0K
Pg0KPiBXaGVuIGJ1aWxkaW5nIHdpdGggY2xhbmcsIHRoZXJlIGlzIGEgd2FybmluZyAob3IgZXJy
b3Igd2l0aA0KPiBDT05GSUdfV0VSUk9SPXkpIGR1ZSB0byBhIGJpdHdpc2UgQU5EIGFuZCBsb2dp
Y2FsIE5PVCBpbg0KPiB2ZmlvX2NkeF9ibV9jdHJsKCk6DQo+DQo+ICAgZHJpdmVycy92ZmlvL2Nk
eC9tYWluLmM6Nzc6NjogZXJyb3I6IGxvZ2ljYWwgbm90IGlzIG9ubHkgYXBwbGllZCB0byB0aGUg
bGVmdCBoYW5kDQo+IHNpZGUgb2YgdGhpcyBiaXR3aXNlIG9wZXJhdG9yIFstV2Vycm9yLC1XbG9n
aWNhbC1ub3QtcGFyZW50aGVzZXNdDQo+ICAgICAgNzcgfCAgICAgICAgIGlmICghdmRldi0+Zmxh
Z3MgJiBCTUVfU1VQUE9SVCkNCj4gICAgICAgICB8ICAgICAgICAgICAgIF4gICAgICAgICAgICB+
DQo+ICAgZHJpdmVycy92ZmlvL2NkeC9tYWluLmM6Nzc6Njogbm90ZTogYWRkIHBhcmVudGhlc2Vz
IGFmdGVyIHRoZSAnIScgdG8gZXZhbHVhdGUNCj4gdGhlIGJpdHdpc2Ugb3BlcmF0b3IgZmlyc3QN
Cj4gICAgICA3NyB8ICAgICAgICAgaWYgKCF2ZGV2LT5mbGFncyAmIEJNRV9TVVBQT1JUKQ0KPiAg
ICAgICAgIHwgICAgICAgICAgICAgXg0KPiAgICAgICAgIHwgICAgICAgICAgICAgICggICAgICAg
ICAgICAgICAgICAgICAgICApDQo+ICAgZHJpdmVycy92ZmlvL2NkeC9tYWluLmM6Nzc6Njogbm90
ZTogYWRkIHBhcmVudGhlc2VzIGFyb3VuZCBsZWZ0IGhhbmQgc2lkZQ0KPiBleHByZXNzaW9uIHRv
IHNpbGVuY2UgdGhpcyB3YXJuaW5nDQo+ICAgICAgNzcgfCAgICAgICAgIGlmICghdmRldi0+Zmxh
Z3MgJiBCTUVfU1VQUE9SVCkNCj4gICAgICAgICB8ICAgICAgICAgICAgIF4NCj4gICAgICAgICB8
ICAgICAgICAgICAgICggICAgICAgICAgICkNCj4gICAxIGVycm9yIGdlbmVyYXRlZC4NCj4NCj4g
QWRkIHRoZSBwYXJlbnRoZXNlcyBhcyBzdWdnZXN0ZWQgaW4gdGhlIGZpcnN0IG5vdGUsIHdoaWNo
IGlzIGNsZWFybHkgd2hhdCB3YXMNCj4gaW50ZW5kZWQgaGVyZS4NCj4NCj4gQ2xvc2VzOiBodHRw
czovL2dpdGh1Yi5jb20vQ2xhbmdCdWlsdExpbnV4L2xpbnV4L2lzc3Vlcy8xOTM5DQo+IEZpeGVz
OiA4YTk3YWI5YjhiMzEgKCJ2ZmlvLWNkeDogYWRkIGJ1cyBtYXN0ZXJpbmcgZGV2aWNlIGZlYXR1
cmUgc3VwcG9ydCIpDQo+IFNpZ25lZC1vZmYtYnk6IE5hdGhhbiBDaGFuY2VsbG9yIDxuYXRoYW5A
a2VybmVsLm9yZz4NCj4gLS0tDQpBY2tlZC1ieTogTmlraGlsIEFnYXJ3YWwgPG5pa2hpbC5hZ2Fy
d2FsQGFtZC5jb20+DQoNCg==
