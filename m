Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A35E7AD289
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 09:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjIYH7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 03:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbjIYH7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 03:59:51 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2085.outbound.protection.outlook.com [40.107.212.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10724FE;
        Mon, 25 Sep 2023 00:59:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qk92HbTjK3wBW+wVkTCLPCpyGiL9Agrczg5T8HO5gqxaTg+1k3lHMUcJzxQQSUOl7YUDnE+B7Q++ekAY4k2UYxJo2ajwIWf018QWTvcJYzim3N1xJ196s8bZWUJqaIjBHDliscGwg3Mk/ZyNXI4wXuF3ycsZEDZxwgGeidFSmjgD8HnJUal8m4Ip1MjTD+udpFXhsGpfHz2FVbGyC6trWssMB+N/QhKA86nPDTrpRT6zA5jLXHEQunLxSioBcL8tXXbf94vrW9i9P6RZVZnMJ6ulRf5AybH9DoOH1noNuonk+fM3XNXyHiZS0CQwJUaSoUR8EH6CIJBeK1eG+6cjdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e7nDWNgPsdmVFpp9OAQxGDU7EHkeuLTcuama1v/1G1I=;
 b=JqBdiZsUYhYmQvic8OCpMw9hLlRyBDhnFFmosuMPDKIOrOR9cJpJlU1E0I+Lu9m/VtF88In75sY3eAcyTKX7lmICADmw8ewCZIYZ2pRdHjmtU+Q8cyLyE2G/ZyOkrd8b1Hl1oThbI55WbOx7YFm1so3UtQThGKJegqiyWfJMK6+ZrBS2+8m8iP0w8PrdAGYwd/UTO1QNGhuWSuGoNYlyfjKLP68urFndcrvC25kpvCjdu8r41NOIUDXXOVrmV+PKZ9+gfPPRR0dpbrbzYRAPwc+yTdF5wqa0XIbt9z/XDzr4MjTQvsKkxENeQ5ijW+xCqFGxzcQGiHeIY4gK9ehPsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7nDWNgPsdmVFpp9OAQxGDU7EHkeuLTcuama1v/1G1I=;
 b=aeUhVXwT9g4k6VI17DvKlK06SNCrkOxhF5e0LMxd4QRh8U0GPMMcX8RYHwSaEDy2r4W/MZ5WLBMR4zmEc6B4gjXOHt6zvEVRP7XP9k2NQuOubAFTSPTk9ihMyuC0STK4owrAfKpgUfh1Jo/JlZ7EgChEVKs6srw66skGw5SDrfjyZaMD6Bz1EUjfwVlL+LeyhRhJKZNuqTA3D/yKfdso/+fLudNfKhCz9l5+3+8JfEinDIM731Nxnc/FxZ50bzh6t3ZKAZYFtYPFZFwr79F6tnLErTSVa+FGE/Tk5Chnn1DcBqDfZ3H+kCnyeOrMgUTAXx0HUfSFVSCdU6KDWH+bEw==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by PH7PR12MB7915.namprd12.prod.outlook.com (2603:10b6:510:27c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Mon, 25 Sep
 2023 07:59:40 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::fddf:d4b8:44d9:d378]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::fddf:d4b8:44d9:d378%6]) with mapi id 15.20.6813.027; Mon, 25 Sep 2023
 07:59:40 +0000
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
CC:     Parav Pandit <parav@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH 00/16] vdpa: Add support for vq descriptor mappings
Thread-Topic: [PATCH 00/16] vdpa: Add support for vq descriptor mappings
Thread-Index: AQHZ5XlWwm3ZWo9//EK2iaK4bDf9KbArQYSA
Date:   Mon, 25 Sep 2023 07:59:40 +0000
Message-ID: <d9962b17aebd75b4c32c24437ad68c967f78377d.camel@nvidia.com>
References: <20230912130132.561193-1-dtatulea@nvidia.com>
In-Reply-To: <20230912130132.561193-1-dtatulea@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|PH7PR12MB7915:EE_
x-ms-office365-filtering-correlation-id: de001eb3-1a03-413c-28fd-08dbbd9d5ed5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uNmr0hkTt1FmQKXU+dGpML7WFsXZj3IqXcghEh1WkIKxQ2iGUQ7jEvp6PSActKzJVrcKRC31FpNLE0sqTjpyP+rbMLUwOEHrrswxC2OiLBO8YSQnlM1CMFcqrCt1bJsyrxaNeaIdrLafY6Vv5w/Ety+ItXB7UWekVY7jMfBfH//IZl05FA/HfuWErSfKva/po0ZQ3nxlmg47WZxRo5ef2FMU8HGt7strsWUj35dPQzUPC9f8Tj8dKc9uVv/ktjLDsgrYOBo16oIKvUUehibiLmZHB8hDgkreHkTZ1vFijn40Lmj49S7i/lkdifiIEeQLpBPoql446I6bKsIlduAoF60VACKxhfULj5UTThBnahKudFK8stAdeRkmhjHhCDAceB+D5MbxltsA5WloaMjyKbNYTvEBqlgJ2pJzlpUMVRM3N4qEzQbBhecvZhE5pkAOvncqTMM9kDJB2rfhbTmv2Rsa+X29QFEJcKPGIR+jBBM+b6iU1mQKwGU5J5K98FNdAvi8LxC2yOGXxK0a3ukgWt4bkHKtWiCA/97GaHSSN8oZFDQoQrncHiMzbFzS94U9VJzq9qZToyHY1cVbQaqhfs+CHOp6h86lHceeoWW82hn2vJ1aNvYX3Xl/6W0dNBJOG5Fpc9CjLU7BZCTJDXuqR4Mqi7rRzcg6/6NkThelJN0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(376002)(136003)(230922051799003)(451199024)(186009)(1800799009)(54906003)(83380400001)(2906002)(5660300002)(316002)(41300700001)(8676002)(8936002)(36756003)(4326008)(2616005)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(86362001)(966005)(110136005)(91956017)(6486002)(6512007)(6506007)(71200400001)(122000001)(38070700005)(38100700002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkVHSmxURVNUczZHdHozUGdONzJYUGNiQnJEdWZCaDM0ck1PR0tQbkRxaDFy?=
 =?utf-8?B?L1hXOEg5RUpEOHBtakwxbkxIZmcyTi9VVzhRWFhDMmZMM1RZZ2RMNjYwL2VH?=
 =?utf-8?B?RGMwRVp5S2QyWFFIY0VnSGRlUHdiUEdtSDBSeEtDRXh5U000WkRHaHF3WXp6?=
 =?utf-8?B?UTgxcmQwaXkyZ2E0MWZyL0wwV0g1QWlVWUU5d0FNR1hyUTFYM0tTM2txblEw?=
 =?utf-8?B?NmhHbnNoVWFxT1cyMFRxUm5JK1hNYk5sdjk4c1hxMUI3WlMzRDJFRHZMREFZ?=
 =?utf-8?B?YmRQc2JXSVFITmxUYXR1ZlhKWWpZVG9Ud09GbnU4RXIybS9XRy93MkROSDRm?=
 =?utf-8?B?dlAwN1Q3Nlc5NG9wVHV4emhINXVHWll4TGFraUpKNTYxeUEwYUdrbERYblhl?=
 =?utf-8?B?MVJGcGU0dWtQNmVSb0lMSjBqUHZsS3N4QU5RMXZramFQUEcya2NMZ1pkK2FL?=
 =?utf-8?B?RzU5N3ZTT000QjBIMjM4RHVjbDk2UUxjYVVLNnIzSm43TGVkRVFJb1dNSWww?=
 =?utf-8?B?RlBuTUFURGd3a0RiVFVpZFhLSFFYTjE5U1VrbGFTdll4RzE3NFB1bEVZNTBr?=
 =?utf-8?B?ekFiYUl6anRhTHJFSjBFaTVpOXBjVEJ1YVJsV3pwUzg1L294d1Z6MFlCZHcz?=
 =?utf-8?B?aUlZOHZ5SGMvM0orcitrYktGbWdJNzFPVXRjQlE3eTFIcW94Qm80V3hMK2M4?=
 =?utf-8?B?cTc3T0hMMy9KZkFPRG5xeWF4d0RIYVAzaXpnRnNJSFdCeHRlQWdqczlmQUZs?=
 =?utf-8?B?N25YU3RaV1hpN3I3STgzaFVZa2xpVWd1ZnkzVzVTdlBESEdUcGNzaThxRVFB?=
 =?utf-8?B?T3JqSUdMci85TUFQK0pUNkVETGVrRHdyU2VPTFkyN3lMdDVOZVQ2TmhjN2x0?=
 =?utf-8?B?Ri8vdVladjFobjNob0N6NEtvSnRrKzAvbm1HRGVXZnY0Z1dQMUdOUUNmV1Zl?=
 =?utf-8?B?dm1NSVJEK2NXbDdFRGpJbytHYnhzWXlkMHdlR0xZR1FCdHdTaGJuUzRLdUpt?=
 =?utf-8?B?MVZPMEFIc2w4engwT3VmNSt3Z2FGWnpLM2M1U3gyNmQ1TUVRU1g5SUlpMEEw?=
 =?utf-8?B?eXEvdmZ1V2dxZWdBSXZPOTUyTjRxLzZxWGVkY3NOWnExR2dJOTV4Z3czU3BV?=
 =?utf-8?B?VjZGMGlPM2J4aWV5dUJCZ2h4S1pGM3ppZFRzWDNDaEM0MU00T2pISUR5QU9O?=
 =?utf-8?B?MHNCa0NFVEQrMlhMRGh3NG5mTXlndVNRN0VFTUdYaVRrVXdlQWwraS9oR2dY?=
 =?utf-8?B?SlE4L2tWOEdta25zRzV6Y0ppMVg4cVFMS2Jzb2NLUjN4ZnA3Rk9HMFRybVhX?=
 =?utf-8?B?V3BBMlZLV3dzSzZTU2UyUkFDMEluaFF2bHd5ZjFSL2kzbEEzbTBMa2hFcmkx?=
 =?utf-8?B?R01yZ2tDaWd0SHNQNldOa1FSMW1laW1MdS9aUWNBc3NvTG5HK29LRzVZdkt6?=
 =?utf-8?B?RVlUQTVZZkNmTC9XdmptNUNjakNnTzdCTW9aT3FZd0tERzBXVml2K3o4Zmhq?=
 =?utf-8?B?ZGNDWDB5TkNjcWtYWGtURlhGYXMyUnNNV0Vmb296ZndhcnFWRGt1OXhnR3NC?=
 =?utf-8?B?dWR5SmVFL0p5Vm81NVNuL2VtcWRWZXhwVkxzdTJOWUpOdjdEc1h2T053aE9y?=
 =?utf-8?B?WTNlSW5kM3NVQ09WZHdZZWFhL3JsTDRlZnFGRnBTeS9FaFBzalF3Yzl1OGNr?=
 =?utf-8?B?akxkZ000ZU1OWGRxd2Z1VTdZb1dkRXFQby9ZSUVER20yc2xDUHVmQ3hPelAw?=
 =?utf-8?B?KzhTV1VpbzB2YXF5REVsMDltRU9rUmQ1OEk4ZXVadUdqZnhiMGl6WWFWVWNN?=
 =?utf-8?B?R3dtVUsvVkhJYUJna21MOTEzYzBKRFJhalhHenlRYkllVFBzZm1iSWkzUU1J?=
 =?utf-8?B?R0YxU1JJTERpOGdVM3NTRm1US0luN1J6UjR2T2pNSkx5Y3I3amZJem5PcUs3?=
 =?utf-8?B?T01OaFdVY3h5MFJodUlXOFI3RXlUVEhSWlQ1RU4wRHZybDh3T0lqdDZTSG55?=
 =?utf-8?B?VHMzNTNVVTZMQ0h1K1VNMytDRFM5VFZQY3IzTkFNQk5jZkR4aGdMcE95WlFL?=
 =?utf-8?B?SlFPbW5vbG9YNnJhK3ZuaXpuSy93Z2FHOERlVmVndFY4bEdhUEdVOG5LYldi?=
 =?utf-8?B?NFVDcG1Oa0pxMVRGc2RHb0xVUkVvM3FrU3NFcTNtVUVOaEZTczFrb1VVWUI0?=
 =?utf-8?Q?jKRXSUgk2oFkjxI1IJ7wYx5upCVnI+C52J5SSyF615Ay?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <42CBF7E36F19634883934936C637C101@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5565.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de001eb3-1a03-413c-28fd-08dbbd9d5ed5
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2023 07:59:40.1096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 55u/z5BPQjZB1SnQKLV6SR3VdLik9ihzn9O8+R3f1nYYJc+laMHnWy5poGrVe4VWPdL1bzs1QY8y/LhHzYoClQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7915
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA5LTEyIGF0IDE2OjAxICswMzAwLCBEcmFnb3MgVGF0dWxlYSB3cm90ZToN
Cj4gVGhpcyBwYXRjaCBzZXJpZXMgYWRkcyBzdXBwb3J0IGZvciB2cSBkZXNjcmlwdG9yIHRhYmxl
IG1hcHBpbmdzIHdoaWNoDQo+IGFyZSB1c2VkIHRvIGltcHJvdmUgdmRwYSBsaXZlIG1pZ3JhdGlv
biBkb3dudGltZS4gVGhlIGltcHJvdmVtZW50IGNvbWVzDQo+IGZyb20gdXNpbmcgc21hbGxlciBt
YXBwaW5ncyB3aGljaCB0YWtlIGxlc3MgdGltZSB0byBjcmVhdGUgYW5kIGRlc3Ryb3kNCj4gaW4g
aHcuDQo+IA0KR2VudGxlIHBpbmcuDQoNCk5vdGUgdGhhdCBJIHdpbGwgaGF2ZSB0byBzZW5kIGEg
djIuIFRoZSBjaGFuZ2VzIGluIG1seDVfaWZjLmggd2lsbCBuZWVkIHRvIGJlDQptZXJnZWQgZmly
c3Qgc2VwYXJhdGVseSBpbnRvIHRoZSBtbHg1LW5leHQgYnJhbmNoIFswXSBhbmQgdGhlbiBwdWxs
ZWQgZnJvbSB0aGVyZQ0Kd2hlbiB0aGUgc2VyaWVzIGlzIGFwcGxpZWQuDQoNClswXQ0KaHR0cHM6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbWVsbGFub3gvbGludXgu
Z2l0L2xvZy8/aD1tbHg1LW5leHQNCg0KVGhhbmtzLA0KRHJhZ29zDQoNCj4gVGhlIGZpcnN0IHBh
cnQgYWRkcyB0aGUgdmRwYSBjb3JlIGNoYW5nZXMgZnJvbSBTaS1XZWkgWzBdLg0KPiANCj4gVGhl
IHNlY29uZCBwYXJ0IGFkZHMgc3VwcG9ydCBpbiBtbHg1X3ZkcGE6DQo+IC0gUmVmYWN0b3IgdGhl
IG1yIGNvZGUgdG8gYmUgYWJsZSB0byBjbGVhbmx5IGFkZCBkZXNjcmlwdG9yIG1hcHBpbmdzLg0K
PiAtIEFkZCBoYXJkd2FyZSBkZXNjcmlwdG9yIG1yIHN1cHBvcnQuDQo+IC0gUHJvcGVybHkgdXBk
YXRlIGlvdGxiIGZvciBjdnEgZHVyaW5nIEFTSUQgc3dpdGNoLg0KPiANCj4gWzBdDQo+IGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL3ZpcnR1YWxpemF0aW9uLzE2OTQyNDg5NTktMTMzNjktMS1naXQt
c2VuZC1lbWFpbC1zaS13ZWkubGl1QG9yYWNsZS5jb20NCj4gDQo+IERyYWdvcyBUYXR1bGVhICgx
Myk6DQo+IMKgIHZkcGEvbWx4NTogQ3JlYXRlIGhlbHBlciBmdW5jdGlvbiBmb3IgZG1hIG1hcHBp
bmdzDQo+IMKgIHZkcGEvbWx4NTogRGVjb3VwbGUgY3ZxIGlvdGxiIGhhbmRsaW5nIGZyb20gaHcg
bWFwcGluZyBjb2RlDQo+IMKgIHZkcGEvbWx4NTogVGFrZSBjdnEgaW90bGIgbG9jayBkdXJpbmcg
cmVmcmVzaA0KPiDCoCB2ZHBhL21seDU6IENvbGxhcHNlICJkdnEiIG1yIGFkZC9kZWxldGUgZnVu
Y3Rpb25zDQo+IMKgIHZkcGEvbWx4NTogUmVuYW1lIG1yIGRlc3Ryb3kgZnVuY3Rpb25zDQo+IMKg
IHZkcGEvbWx4NTogQWxsb3cgY3JlYXRpb24vZGVsZXRpb24gb2YgYW55IGdpdmVuIG1yIHN0cnVj
dA0KPiDCoCB2ZHBhL21seDU6IE1vdmUgbXIgbXV0ZXggb3V0IG9mIG1yIHN0cnVjdA0KPiDCoCB2
ZHBhL21seDU6IEltcHJvdmUgbXIgdXBkYXRlIGZsb3cNCj4gwqAgdmRwYS9tbHg1OiBJbnRyb2R1
Y2UgbXIgZm9yIHZxIGRlc2NyaXB0b3INCj4gwqAgdmRwYS9tbHg1OiBFbmFibGUgaHcgc3VwcG9y
dCBmb3IgdnEgZGVzY3JpcHRvciBtYXBwaW5nDQo+IMKgIHZkcGEvbWx4NTogTWFrZSBpb3RsYiBo
ZWxwZXIgZnVuY3Rpb25zIG1vcmUgZ2VuZXJpYw0KPiDCoCB2ZHBhL21seDU6IFVwZGF0ZSBjdnEg
aW90bGIgbWFwcGluZyBvbiBBU0lEIGNoYW5nZQ0KPiDCoCBDb3ZlciBsZXR0ZXI6IHZkcGEvbWx4
NTogQWRkIHN1cHBvcnQgZm9yIHZxIGRlc2NyaXB0b3IgbWFwcGluZ3MNCj4gDQo+IFNpLVdlaSBM
aXUgKDMpOg0KPiDCoCB2ZHBhOiBpbnRyb2R1Y2UgZGVkaWNhdGVkIGRlc2NyaXB0b3IgZ3JvdXAg
Zm9yIHZpcnRxdWV1ZQ0KPiDCoCB2aG9zdC12ZHBhOiBpbnRyb2R1Y2UgZGVzY3JpcHRvciBncm91
cCBiYWNrZW5kIGZlYXR1cmUNCj4gwqAgdmhvc3QtdmRwYTogdUFQSSB0byBnZXQgZGVkaWNhdGVk
IGRlc2NyaXB0b3IgZ3JvdXAgaWQNCj4gDQo+IMKgZHJpdmVycy92ZHBhL21seDUvY29yZS9tbHg1
X3ZkcGEuaCB8wqAgMzEgKysrLS0NCj4gwqBkcml2ZXJzL3ZkcGEvbWx4NS9jb3JlL21yLmPCoMKg
wqDCoMKgwqDCoCB8IDE5MSArKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLQ0KPiDCoGRyaXZl
cnMvdmRwYS9tbHg1L2NvcmUvcmVzb3VyY2VzLmMgfMKgwqAgNiArLQ0KPiDCoGRyaXZlcnMvdmRw
YS9tbHg1L25ldC9tbHg1X3ZuZXQuY8KgIHwgMTAwICsrKysrKysrKystLS0tLQ0KPiDCoGRyaXZl
cnMvdmhvc3QvdmRwYS5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMjcgKysrKw0K
PiDCoGluY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmYy5owqDCoMKgwqDCoCB8wqDCoCA4ICstDQo+
IMKgaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjX3ZkcGEuaCB8wqDCoCA3ICstDQo+IMKgaW5j
bHVkZS9saW51eC92ZHBhLmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAxMSArKw0K
PiDCoGluY2x1ZGUvdWFwaS9saW51eC92aG9zdC5owqDCoMKgwqDCoMKgwqDCoCB8wqDCoCA4ICsr
DQo+IMKgaW5jbHVkZS91YXBpL2xpbnV4L3Zob3N0X3R5cGVzLmjCoMKgIHzCoMKgIDUgKw0KPiDC
oDEwIGZpbGVzIGNoYW5nZWQsIDI2NCBpbnNlcnRpb25zKCspLCAxMzAgZGVsZXRpb25zKC0pDQo+
IA0KDQo=
