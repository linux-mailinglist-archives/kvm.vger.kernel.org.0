Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876207C00E4
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 17:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbjJJP6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 11:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbjJJP6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 11:58:19 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707DCAC
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:58:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxv2Pow47e4F0KxKKFkUhwwwfJJS8kZGsb0EE5TO/CsDhL0nJA5XpNLeNMmyP689MQ2Ox0zTmzg2aTMm2LGHErJ0+tvokq9lvBC4le6ulkv1Xjv5oKIvSJGXIe2TIqVcoCgPbKhnBlC6tuOmUpvQeMjLdl2oV+/Vgv/iJAGIyDTtgOeVexHfwRKTjXBHbxY0ReVqbPhcb87Dw+bsJsIJhed+6WmoQr+2kI9bjR8FAgW6Sw8RwhBlbqBkIN0ih8c2SyT0PU9LFDCXDu7aLx9nT5OrO7Y1ul1f1jnNRmuO/Z2P7OOsvnayxKEbLJOGEancOiixhz6BT1igxCeUfXyJ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yP8RR3zm30JBolX6uM1q3atIsbZB8GlS7rJmxU1FShE=;
 b=dDbQVBYQsV+CzkJTrkkZwd624ztgc8lML1TLMMh8jsXe2pEstkG+4er0lGt/XfboTWJE0siT4SGsi8AK7+388/iOcG5096wTo9TQ115rNWjCvgOCYIUhZblddpd0g39upMv8Bs9Ta0Z5dsE8eCEXBumpJpV3LlRXftt1cRbn4CsiCu3DuL4ZrzzU2r45BC+cdFEhH0JdVLwst1tjVVF+LwN4VC+YKcn88oFJWDs1XLcmFzWZUbSLEuOmdiuFyiFDm6qSx5xaMGlRdWbOStd67OAjzB7AhPHh4Otxy6sTQyO7sgK91yuag8mWQ0mHWW1TIX1iwyQnfO1CafB9A4Nfhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yP8RR3zm30JBolX6uM1q3atIsbZB8GlS7rJmxU1FShE=;
 b=ApOvVx7pGx0OISZM3becNhkr2m0iQ44st26Ch3ogOcuhL/nYmlZ/5SrAliP0VjNfRWzZBSCnnzrbmPYusgpi2JN4+OrqxS214/qmQZ10HneDhyUWIAoGagby8M5lBTJISsJIYMum6ACaLQWtvKQ4XDdUEPmeBiAYA8iFpHaYEarNYQivbTiWDP25BPWvNm0gjxSKoWRcJjxu+zns/TNzrJkFS2zjg672gnSyffh8FMX4kDPTWGB/WWM3/PTLbfDAvqFCYS4Bod4D3so7ApzKFg9xQOx0zUjTp/c87ASQZhrDFiBCgB6++fo1MzvnUUIEv74DByn5v6qkVsxsVntMHw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by IA1PR12MB6580.namprd12.prod.outlook.com (2603:10b6:208:3a0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Tue, 10 Oct
 2023 15:58:13 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::23d0:62e3:4a4a:78b5]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::23d0:62e3:4a4a:78b5%6]) with mapi id 15.20.6863.032; Tue, 10 Oct 2023
 15:58:12 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: RE: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over virtio
 device
Thread-Topic: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Thread-Index: AQHZ7IkOMX5QOSCSWUux5r7dl0LIwLAmnGSAgAZfpICAAAe+AIAJFnQAgACSqACABEvdAIAAJyoAgAGzmoCABkm1gIAADLUAgAADlYCAAAy8AIAABEkAgAABdACAAAf+AIAAAzDg
Date:   Tue, 10 Oct 2023 15:58:12 +0000
Message-ID: <PH0PR12MB54811D2D27041A6554FC3B48DCCDA@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <ZRpjClKM5mwY2NI0@infradead.org>
 <20231002151320.GA650762@nvidia.com> <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com> <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <8ea954ba-e966-0b87-b232-06ffd79db4e3@nvidia.com>
In-Reply-To: <8ea954ba-e966-0b87-b232-06ffd79db4e3@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|IA1PR12MB6580:EE_
x-ms-office365-filtering-correlation-id: 965d5dc1-e7b9-4e2a-4768-08dbc9a9b4f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UdreSLlcJtLcifqUioFnD6WrpJM45tf9OY5iJFdDnLnz+4ccnfQas3K0lR1FO5sCxRGzBDU8SKktrJS8HHZBLc/J90tRnJiZ79MynlHXG9AHrAJTASdWa1w1Daid6vVZJMzMnZqxPthB23rFTqW3SKKLN1O682xyjIp742iufp+/F6hrpGzTbW6rNR1GLiSvQBVHWHdqgiaFpxV+2dNEhMW4JgzZdz2/GHZVQfmOhf6IvZ8MPIw3Qfn8z14ErBuagYXv2IWgu5e/C45ljpd3rO/ZjxZTbsgxTtYiEuZBZT/mTk9vWs/I2+LL1n+01cbh3fN5P5YF/YMEUZUOSkbx3kQRdCoDUFs5Xkazet7LYXetjrGxEkQm1Rhq5qWBTX0HA9VSooOcSTEOHFAGyJK9cOMkCifxDqZhY24S4vNctEfmcOAwLCT0D5fPSC9FVq6wH4lMSvk1b5XkZsTWJyCOyf+46oz20bueU+nW0yt7gMG35nxE7STjLhGvKt3TRG31NX+BB7sp9u17weLSPcnFwzSwXfQN1Upxs8EnXdZa/kCHglK4NuxeixRCTUHrtodQ18W+L50Aevmd7hzuGULTpK+4B18Ou28FKC86yhujtIBbkLAAVegBOSV+kPSQjypy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(346002)(376002)(396003)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(55016003)(53546011)(107886003)(9686003)(7696005)(6506007)(478600001)(316002)(41300700001)(71200400001)(83380400001)(2906002)(66476007)(76116006)(66556008)(66446008)(110136005)(5660300002)(54906003)(52536014)(64756008)(66946007)(8676002)(4326008)(8936002)(26005)(38100700002)(38070700005)(122000001)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3l6ck01TzJUTC9ybEpCdlp6N1RnQnBPOHR2UWhPMG1BVGEwYWduYisrZXpB?=
 =?utf-8?B?WnNpV0lka1RIMUxST0tCUUVCckU1ZHlUaEJ4QlNqS3NFYUNtYWM2azYvY2Yv?=
 =?utf-8?B?aE11Q3NLRTE5aTkxc1RUSEdFK2Z2SXBxYUhGaXQyZG1QeW1pbGNSZTRtNEU2?=
 =?utf-8?B?bTRCYTd2Q1BPOStaL1VGdnlSN2d3bEhsK2U3ZE9WWEtrWXpYdzYyT1pBNHJS?=
 =?utf-8?B?TGprT0tVME1IZnNjOHkvMndUMmxPMW11MnVZVnZ6T002dDdqVnFTZnNma0ZK?=
 =?utf-8?B?aUtGRjRzYXVmMU5CMVN2NXBzeUVGY2tSNTU3ajFnamdCVzB6VzRPWXAxUVh1?=
 =?utf-8?B?WnhZOXk3S3RtQkQxeWs3R1dvazRrUithMHR5b0M2K1YrRlZHekthYUI5bnpj?=
 =?utf-8?B?Y1Q1ZTJIT0RQbC85K3JTa1dCMHhCQS8rSmpmWmNwRWEzMUJHbDRUcXpmWGli?=
 =?utf-8?B?SStWT3NhZCsyeklLY1RzMitaY3I3dFNRL2NiQjdUL2ovTzRNMmpudDN2RlFG?=
 =?utf-8?B?YTJGNmJ3c3A0Ky90UDNDa1NNUFRzcUxlVGlqajdZMHZUSXNDcC9naHNWcGUz?=
 =?utf-8?B?T21FSU5Ud20rNThMa3cvSzRtL0RwZ2ZXTG1QQ3VVM3haNitRaUtuR24vaFZB?=
 =?utf-8?B?Rm9SMHNSOTdjNXZXUllUS0VWa25yWncwWUtjKzRhRmp6NEpITUhVSTBoeTdq?=
 =?utf-8?B?bzhDVlduMFd6RmdsWTNqeDVldmpEOGpqclh1OTNKNUIwVTVWRHBoeW44WWVw?=
 =?utf-8?B?YnlEeUI5NXIrUms1VEhBcjRtL2hZem9iV2t3ZG9zdFN3azZNQXlwaExuVlU3?=
 =?utf-8?B?MldOUTcrNEc5bjFKV0sxZkQ0TjYyS29IKzl0NVFrMjZjVEZFV2ViQVhoazhE?=
 =?utf-8?B?ZFhoRk4zRkM5MVo4MTFiS2JWZnlMNGNNTm9zZ2tYaUd2cXdNdTBFcE9qNGh5?=
 =?utf-8?B?eDh5aSsvQTNxc0pzbVVPbkZja2tRejU4VTFrUjRPVUlIaCtmeGtYMlBvZm51?=
 =?utf-8?B?NWNOOHdscHJDenBBQzAyUFhiZTBwQnVnYjg0d01TN1JNZFhLTG5jZ0Jva0RG?=
 =?utf-8?B?dmJucVlRYUgxOTU2b1IzeHpCdWo5K2h3djZ0T2V1eU1zeXlXY2ozQ3pBK1NB?=
 =?utf-8?B?UVFCeVY2WlYwZHBPczBGazVodU9JcTRtamo2d1dmdkxUYnNzWDFvMGpmVUNm?=
 =?utf-8?B?aUNiWWVqZWlSNHFndWRyeldYQ3BsaGF4aFdQS3BzK3pvcmcrQStVVituM0Uv?=
 =?utf-8?B?Vlg5OEp0NkVTaWZIN2hoS1lWZFNsSVZxR3FXTWlUbU9WWVJpSS9pdlNSZnlq?=
 =?utf-8?B?eUE0MVNldlRnRFZkV0JENERtT2RsR1plNjR2cGhMS3FabHpuQlNCVHhwK0lw?=
 =?utf-8?B?VU1vTlBScXJna2dWL2E4MU5NNWtNbDdHcjdCYlFPY001SUU2V0t3bUduSThC?=
 =?utf-8?B?OFk1TFlHeHpHTEpnemRUVWlxRklWclRnL210blFqVDRhOU4yTzlOWjlyOFpP?=
 =?utf-8?B?Um1XWTJkNy9pSDlSN01LUWE2VXZURkdsZFFNUW56ajQvaVRJNGE2ejlYaWt1?=
 =?utf-8?B?bnYrTVh2OVhmU0xDY1BGNGpHTVQ4b2RUdW82Z0ovT1h1T0IxS2pLVEpkd2dw?=
 =?utf-8?B?eXovUmZsRzVjNXFJT2hOTlZySVBBNlA4aHh4UlZSdHhUd3F4Y0F2UWhrbTRK?=
 =?utf-8?B?Nlh2bXVtSmxKQVh6SklJU3hDT0gzT3hibDdwOVlsWEtSTjhjYzNNeXRxeEw4?=
 =?utf-8?B?UVpIMmRmWmx5OWpvcDNMMWovdi9LVGtLakgzRFdSWTBxYzZYeWQxRGQ2WTEx?=
 =?utf-8?B?VUlpV1RMOU9INTRCV2pLRVBUd1JDZ3FGNHlIaVJ0aUFnMnZFRzNEeUgrcjhy?=
 =?utf-8?B?RUJNVCtkNWZ1L0NEanJRMXRINy90UXptSEZjc3lGdllHWnhWb1g1MFdKR1J6?=
 =?utf-8?B?MGpqTEpqMWhKMkxOYlNyREl6WFRYaU1maE9aOFZwaG1ibDFUb2kxQXJTclZD?=
 =?utf-8?B?TStVRG1QNTdZbzVZeGFOZTk3YUNLWitIaHRTZUQxOFF0SHhQUExCNXBQSkdt?=
 =?utf-8?B?T3hDR1ZUaUpjYWExbG0zTkhrT2Y4RDdpL2R3T2d4RTdLWjA4QXlpSnJwYXR0?=
 =?utf-8?Q?xH/Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 965d5dc1-e7b9-4e2a-4768-08dbc9a9b4f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2023 15:58:12.5337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WiYcxqTGgb/UZ2jVMeX4LjjA0DvUyd0e7OODawJMQQvXH2yuJU+W6tlAwTLkj7VQChCFeP+2hgZxNluB+sMoYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6580
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gRnJvbTogWWlzaGFpIEhhZGFzIDx5aXNoYWloQG52aWRpYS5jb20+DQo+IFNlbnQ6IFR1
ZXNkYXksIE9jdG9iZXIgMTAsIDIwMjMgOToxNCBQTQ0KPiANCj4gT24gMTAvMTAvMjAyMyAxODox
NCwgTWljaGFlbCBTLiBUc2lya2luIHdyb3RlOg0KPiA+IE9uIFR1ZSwgT2N0IDEwLCAyMDIzIGF0
IDA2OjA5OjQ0UE0gKzAzMDAsIFlpc2hhaSBIYWRhcyB3cm90ZToNCj4gPj4gT24gMTAvMTAvMjAy
MyAxNzo1NCwgTWljaGFlbCBTLiBUc2lya2luIHdyb3RlOg0KPiA+Pj4gT24gVHVlLCBPY3QgMTAs
IDIwMjMgYXQgMTE6MDg6NDlBTSAtMDMwMCwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiA+Pj4+
IE9uIFR1ZSwgT2N0IDEwLCAyMDIzIGF0IDA5OjU2OjAwQU0gLTA0MDAsIE1pY2hhZWwgUy4gVHNp
cmtpbiB3cm90ZToNCj4gPj4+Pg0KPiA+Pj4+Pj4gSG93ZXZlciAtIHRoZSBJbnRlbCBHUFUgVkZJ
TyBkcml2ZXIgaXMgc3VjaCBhIGJhZCBleHBlcmlhbmNlIEkNCj4gPj4+Pj4+IGRvbid0IHdhbnQg
dG8gZW5jb3VyYWdlIHBlb3BsZSB0byBtYWtlIFZGSU8gZHJpdmVycywgb3IgY29kZSB0aGF0DQo+
ID4+Pj4+PiBpcyBvbmx5IHVzZWQgYnkgVkZJTyBkcml2ZXJzLCB0aGF0IGFyZSBub3QgdW5kZXIg
ZHJpdmVycy92ZmlvIHJldmlldy4NCj4gPj4+Pj4gU28gaWYgQWxleCBmZWVscyBpdCBtYWtlcyBz
ZW5zZSB0byBhZGQgc29tZSB2aXJ0aW8gZnVuY3Rpb25hbGl0eQ0KPiA+Pj4+PiB0byB2ZmlvIGFu
ZCBpcyBoYXBweSB0byBtYWludGFpbiBvciBsZXQgeW91IG1haW50YWluIHRoZSBVQVBJIHRoZW4N
Cj4gPj4+Pj4gd2h5IHdvdWxkIEkgc2F5IG5vPyBCdXQgd2UgbmV2ZXIgZXhwZWN0ZWQgZGV2aWNl
cyB0byBoYXZlIHR3bw0KPiA+Pj4+PiBkcml2ZXJzIGxpa2UgdGhpcyBkb2VzLCBzbyBqdXN0IGV4
cG9zaW5nIGRldmljZSBwb2ludGVyIGFuZCBzYXlpbmcNCj4gPj4+Pj4gInVzZSByZWd1bGFyIHZp
cnRpbyBBUElzIGZvciB0aGUgcmVzdCIgZG9lcyBub3QgY3V0IGl0LCB0aGUgbmV3DQo+ID4+Pj4+
IEFQSXMgaGF2ZSB0byBtYWtlIHNlbnNlIHNvIHZpcnRpbyBkcml2ZXJzIGNhbiBkZXZlbG9wIG5v
cm1hbGx5DQo+ID4+Pj4+IHdpdGhvdXQgZmVhciBvZiBzdGVwcGluZyBvbiB0aGUgdG9lcyBvZiB0
aGlzIGFkbWluIGRyaXZlci4NCj4gPj4+PiBQbGVhc2Ugd29yayB3aXRoIFlpc2hhaSB0byBnZXQg
c29tZXRoaW5nIHRoYXQgbWFrZSBzZW5zZSB0byB5b3UuIEhlDQo+ID4+Pj4gY2FuIHBvc3QgYSB2
MiB3aXRoIHRoZSBhY2N1bXVsYXRlZCBjb21tZW50cyBhZGRyZXNzZWQgc28gZmFyIGFuZA0KPiA+
Pj4+IHRoZW4gZ28gb3ZlciB3aGF0IHRoZSBBUEkgYmV0d2VlbiB0aGUgZHJpdmVycyBpcy4NCj4g
Pj4+Pg0KPiA+Pj4+IFRoYW5rcywNCj4gPj4+PiBKYXNvbg0KPiA+Pj4gL21lIHNocnVncy4gSSBw
cmV0dHkgbXVjaCBwb3N0ZWQgc3VnZ2VzdGlvbnMgYWxyZWFkeS4gU2hvdWxkIG5vdCBiZSBoYXJk
Lg0KPiA+Pj4gQW55dGhpbmcgdW5jbGVhciAtIHBvc3Qgb24gbGlzdC4NCj4gPj4+DQo+ID4+IFll
cywgdGhpcyBpcyB0aGUgcGxhbi4NCj4gPj4NCj4gPj4gV2UgYXJlIHdvcmtpbmcgdG8gYWRkcmVz
cyB0aGUgY29tbWVudHMgdGhhdCB3ZSBnb3Qgc28gZmFyIGluIGJvdGgNCj4gPj4gVkZJTyAmIFZJ
UlRJTywgcmV0ZXN0IGFuZCBzZW5kIHRoZSBuZXh0IHZlcnNpb24uDQo+ID4+DQo+ID4+IFJlIHRo
ZSBBUEkgYmV0d2VlbiB0aGUgbW9kdWxlcywgSXQgbG9va3MgbGlrZSB3ZSBoYXZlIHRoZSBiZWxv
dw0KPiA+PiBhbHRlcm5hdGl2ZXMuDQo+ID4+DQo+ID4+IDEpIFByb2NlZWQgd2l0aCBjdXJyZW50
IGFwcHJvYWNoIHdoZXJlIHdlIGV4cG9zZWQgYSBnZW5lcmljIEFQSSB0bw0KPiA+PiBleGVjdXRl
IGFueSBhZG1pbiBjb21tYW5kLCBob3dldmVyLCBtYWtlIGl0IG11Y2ggbW9yZSBzb2xpZCBpbnNp
ZGUNCj4gVklSVElPLg0KPiA+PiAyKSBFeHBvc2UgZXh0cmEgQVBJcyBmcm9tIFZJUlRJTyBmb3Ig
Y29tbWFuZHMgdGhhdCB3ZSBjYW4gY29uc2lkZXINCj4gPj4gZnV0dXJlIGNsaWVudCB1c2FnZSBv
ZiB0aGVtIGFzIG9mIExJU1RfUVVFUlkvTElTVF9VU0UsIGhvd2V2ZXIgc3RpbGwNCj4gPj4gaGF2
ZSB0aGUgZ2VuZXJpYyBleGVjdXRlIGFkbWluIGNvbW1hbmQgZm9yIG90aGVycy4NCj4gPj4gMykg
RXhwb3NlIEFQSSBwZXIgY29tbWFuZCBmcm9tIFZJUlRJTyBhbmQgZnVsbHkgZHJvcCB0aGUgZ2Vu
ZXJpYw0KPiA+PiBleGVjdXRlIGFkbWluIGNvbW1hbmQuDQo+ID4+DQo+ID4+IEZldyBub3RlczoN
Cj4gPj4gT3B0aW9uICMxIGxvb2tzIHRoZSBtb3N0IGdlbmVyaWMgb25lLCBpdCBkcm9wcyB0aGUg
bmVlZCB0byBleHBvc2UNCj4gPj4gbXVsdGlwbGUgc3ltYm9scyAvIEFQSXMgcGVyIGNvbW1hbmQg
YW5kIGZvciBub3cgd2UgaGF2ZSBhIHNpbmdsZQ0KPiA+PiBjbGllbnQgZm9yIHRoZW0gKGkuZS4g
VkZJTykuDQo+ID4+IE9wdGlvbnMgIzIgJiAjMywgbWF5IHN0aWxsIHJlcXVpcmUgdG8gZXhwb3Nl
IHRoZQ0KPiA+PiB2aXJ0aW9fcGNpX3ZmX2dldF9wZl9kZXYoKSBBUEkgdG8gbGV0IFZGSU8gZ2V0
IHRoZSBWSVJUSU8gUEYgKHN0cnVjdA0KPiA+PiB2aXJ0aW9fZGV2aWNlICopIGZyb20gaXRzIFBD
SSBkZXZpY2UsIGVhY2ggY29tbWFuZCB3aWxsIGdldCBpdCBhcyBpdHMgZmlyc3QNCj4gYXJndW1l
bnQuDQo+ID4+DQo+ID4+IE1pY2hhZWwsDQo+ID4+IFdoYXQgZG8geW91IHN1Z2dlc3QgaGVyZSA/
DQo+ID4+DQo+ID4+IFRoYW5rcywNCj4gPj4gWWlzaGFpDQo+ID4gSSBzdWdnZXN0IDMgYnV0IGNh
bGwgaXQgb24gdGhlIFZGLiBjb21tYW5kcyB3aWxsIHN3aXRjaCB0byBQRg0KPiA+IGludGVybmFs
bHkgYXMgbmVlZGVkLiBGb3IgZXhhbXBsZSwgaW50ZWwgbWlnaHQgYmUgaW50ZXJlc3RlZCBpbg0K
PiA+IGV4cG9zaW5nIGFkbWluIGNvbW1hbmRzIHRocm91Z2ggYSBtZW1vcnkgQkFSIG9mIFZGIGl0
c2VsZi4NCj4gPg0KPiBUaGUgZHJpdmVyIHdobyBvd25zIHRoZSBWRiBpcyBWRklPLCBpdCdzIG5v
dCBhIFZJUlRJTyBvbmUuDQo+IA0KPiBUaGUgYWJpbGl0eSB0byBnZXQgdGhlIFZJUlRJTyBQRiBp
cyBmcm9tIHRoZSBQQ0kgZGV2aWNlIChpLmUuIHN0cnVjdCBwY2lfZGV2KS4NCj4gDQo+IEluIGFk
ZGl0aW9uLA0KPiB2aXJ0aW9fcGNpX3ZmX2dldF9wZl9kZXYoKSB3YXMgaW1wbGVtZW50ZWQgZm9y
IG5vdyBpbiB2aXJ0aW8tcGNpIGFzIGl0IHdvcmtlZA0KPiBvbiBwY2lfZGV2Lg0KPiBBc3N1bWlu
ZyB0aGF0IHdlJ2xsIHB1dCBlYWNoIGNvbW1hbmQgaW5zaWRlIHZpcnRpbyBhcyB0aGUgZ2VuZXJp
YyBsYXllciwgd2UNCj4gd29uJ3QgYmUgYWJsZSB0byBjYWxsL3VzZSB0aGlzIEFQSSBpbnRlcm5h
bGx5IHRvIGdldCB0aGUgUEYgYXMgb2YgY3ljbGljDQo+IGRlcGVuZGVuY2llcyBiZXR3ZWVuIHRo
ZSBtb2R1bGVzLCBsaW5rIHdpbGwgZmFpbC4NCj4gDQo+IFNvIGluIG9wdGlvbiAjMyB3ZSBtYXkg
c3RpbGwgbmVlZCB0byBnZXQgb3V0c2lkZSBpbnRvIFZGSU8gdGhlIFZJUlRJTyBQRiBhbmQNCj4g
Z2l2ZSBpdCBhcyBwb2ludGVyIHRvIFZJUlRJTyB1cG9uIGVhY2ggY29tbWFuZC4NCj4NCkkgdGhp
bmssDQpGb3IgIzMgdGhlIHZpcnRpbyBsZXZlbCBBUEkgc2lnbmF0dXJlIHNob3VsZCBiZSwNCg0K
dmlydGlvX2FkbWluX2xlZ2FjeV94eXpfY21kKHN0cnVjdCB2aXJ0aW9fZGV2aWNlICpkZXYsIHU2
NCBncm91cF9tZW1iZXJfaWQsIC4uLi4pOw0KDQpUaGlzIG1haW50YWlucyB0aGUgcmlnaHQgYWJz
dHJhY3Rpb24gbmVlZGVkIGJldHdlZW4gdmZpbywgZ2VuZXJpYyB2aXJ0aW8gYW5kIHZpcnRpbyB0
cmFuc3BvcnQgKHBjaSkgbGF5ZXIuDQo=
