Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E8B5AFA82
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 05:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiIGDRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 23:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiIGDRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 23:17:43 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52AF80361;
        Tue,  6 Sep 2022 20:17:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cX6pfHcPa7X+ZXX0cSJFa5e8AqhgpcdThv7fdseaKVsJ4fkKJsPh6xuEW6RNMlJy6HxzRI7X2YTHQqv2mHXcLWo3Q9qiwNs6G3n1PrZnNPH9wZQGgYQ7mhCoHLieDDdCbf5CCv+tNxQwUeS6eRmeBmKDGuiH+NgWDwYNQgRFTJArplRSnPjuz+GKBRvV6KcSiry0PwxI1nj0zpDEeCWC8PYPQumuwsvcsQLwUYBYUIs5ClW0+yxbjBboxv0Zg3tXUMUqbgS37/+v/NgTijd5bns9UF4jKFubyNGF23PAxIwz15WwcqbMdjVIBF5CRhjlLbBNHspKOMiKJ+IzVWepnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6nywLFBlE1AEzbp8iTiPvYz1lSkOVb2Z5TDNtHlVzP8=;
 b=XxdkkPprRKzTZsyv5ysiK7w6NAslMt2gMVs7D15eV5r83/fsbnqPNXpNLxb9GJX7oGt128gsvu8M/a1/uB6wsD/vrzqEQd/MjTcIkw1VCD34dbTdlJPIyVtDFbt0mjoDTpUabrK0FQI9P81kVfH1H/i3VINf6KXqfQZcMpsInNDOzlCUD9eZBv7le2Ir0/+O8PVIYWz2kNq2IHsBYf+4j7ZyMqy5gljiJQcjp8l97e7ZHCbQoxudwJhuRd4+CW3+qkjWB3BVrWPIfAk3rh/8C76o+22HBdQYx4Djhh4T3GSqdtkCe955p6fA4yhPbshhXesXnjfBLr9Rs48Cmr79jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nywLFBlE1AEzbp8iTiPvYz1lSkOVb2Z5TDNtHlVzP8=;
 b=joRlcFYsfC2KFxVi5FogqmrFrtnYIq2/PnxrpiM6BwFr7oQtA6cl5OqPb+j9ddAm1OkxD61Wlmsk77yBl6TRVhk8MsQhwX9Cxu5b/lGvkuon5LdWhbEHTqwjy1r1LVpiBSr9G8v43P9Os5R9/9du4LST+QgNpJenV8829FIp0lw=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by DM8PR12MB5413.namprd12.prod.outlook.com (2603:10b6:8:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.14; Wed, 7 Sep 2022 03:17:35 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74%3]) with mapi id 15.20.5588.014; Wed, 7 Sep 2022
 03:17:35 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Saravana Kannan <saravanak@google.com>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v3 3/7] iommu/arm-smmu-v3: support ops registration
 for CDX bus
Thread-Topic: [RFC PATCH v3 3/7] iommu/arm-smmu-v3: support ops registration
 for CDX bus
Thread-Index: AQHYwfdoyuEpNfotGUONz63q/8hFXq3TGJAAgAAzJ7A=
Date:   Wed, 7 Sep 2022 03:17:34 +0000
Message-ID: <DM6PR12MB30829DDDC62B36B17F87B204E8419@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-4-nipun.gupta@amd.com>
 <CAGETcx_W8QVe+CdpocN2rHjp08TwsW22FaJgrYW=0JNge_N6KQ@mail.gmail.com>
In-Reply-To: <CAGETcx_W8QVe+CdpocN2rHjp08TwsW22FaJgrYW=0JNge_N6KQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-07T03:17:34Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=732d018a-d761-471b-9dc9-1c96e5a7be47;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d7e9b19-3f7b-423b-c034-08da907f826e
x-ms-traffictypediagnostic: DM8PR12MB5413:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bVntCbRBLOGQ+ZsJIV93kF0JRK/S36RkR4ncxJWis0YufpMuSoeY07u83IoFWQ/D5y+KWpuDq9JotN+LJA0voqqNOenHE6iKIW+ozbaJyJORKl6CkC7IAAIK8rekPQlc4T4Q9jopx1JbDQz9836dXNSNcqz/fzjodFiubrs2u/ncRDWns/EBR3BFVa5Q02m+TlizmIIAA1g+uQz3ae9TJtMBQZMuN+RpWQTdtmIXcrnsjfFDV2a9/WsqUAezO1IUYKiEUO83I64b5nBSNgtNiTpSo4vIYHKNGtFJbKxny+IICnPP7T9vejgQpcTvuy4rNw0T+vy3yKr1BhIqMVSl1KgHNYta0Jh56RF9lbUI2NFAIqYNknkg2lVsrOujLe9450we8QgI/x3l5mvhV7bJFnMVTd/7VRGlVfIyWWxE9msIoAwiP0jCDaF+X0RCcw05o7cqKUtXNGlT0bp7dQRUbvRSGFxqeyseDRIevhoF6o3d/U7lGorS6wnamEOzexQibiMp1xjRUlptGNJvDFJACpr24vq9iy3oRIfG8OYc9Mqfa9lGrUNhWOAiUe7YMobulEtJ2H5WPn0Ra8GbtlRZp545YzYo/xZ69rVZBDL5EP+NL3RiYrVW30CMBoBdEEhXFWF/b7s8pz3e71YCgvH+liLhh/YjAL9R+oBYOvJJm+gMBcdFJsLAkzyruf6UUCxrPajYqLpKvIunMrLZ6EPGI2zgMBg8JVQX5JsJZKl7qZ1+VML9OEQamDiQHZ9swIdDtMCLcJXQknRyYPVrTVbINw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(186003)(38070700005)(71200400001)(54906003)(122000001)(83380400001)(86362001)(316002)(6916009)(7416002)(5660300002)(52536014)(7406005)(8936002)(76116006)(66556008)(66476007)(64756008)(66446008)(478600001)(66946007)(41300700001)(8676002)(4326008)(38100700002)(55016003)(9686003)(33656002)(26005)(2906002)(53546011)(55236004)(6506007)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjVwVXhMbmxxam5zVlg3cXk1NStDekpFOXpTamJLaVc3djZJNGc1UGZtUWw4?=
 =?utf-8?B?UjJtWXJ5Z0FjWWExUlVIUHlRTW1tTDlRcmdsU0Z4U3k1bEpFeCtqZFR2Z1ph?=
 =?utf-8?B?bFJGS1p2RlVKOG5qd3FoM1BuK2ZxZ0Y0VHQvTXIzUmZhQlU5TEdHb1orRjls?=
 =?utf-8?B?ZDNML0JMbkpVTlhiaDVjc1A3SDR4WnQybDF0NE9JSjVPWnRoMXd5bHVSQzQ5?=
 =?utf-8?B?a1g3SGJyRWdMWWVXT2g1Y0plWWhMTEJBRHlIaERKbnVzWlJqcTV0WkVTN1Ev?=
 =?utf-8?B?d29VNEJ1TG1CUndXdlpJNXU1a0w0K3RxNHgxcEZBM2Nlc1BGby9WN2pCZjhq?=
 =?utf-8?B?MU0yUGpzVXJOdmVmQml6dGtVR2JFUTl2d09XRFlXZGNaV3A4V2liYTNVMnJn?=
 =?utf-8?B?N1VxTi9ocHNTZXlUc2F0b2pWZEVOczZyNUdLaVowVHdnajhPdkpBL0U3Um1C?=
 =?utf-8?B?cEhmakdTOEgrY0d2RzJOeHU1dmp4TndXelpPSzJmWmZlNlJBMVFNeVo3bm5X?=
 =?utf-8?B?U0RTeEVHVVVneC9tenBzSUwyUk5SYXNrd3luMVYrL2p1NVF1OCtwY1ZTNGlL?=
 =?utf-8?B?WUFDcFBCOXBheG4wc0N0dmIyamt4T2FENWJIck90WVZJcVpHditOa3lvQjdH?=
 =?utf-8?B?UVpWRmtLQU1MZmcra3U4bSsyYmVudjNqV0oyZnhVbVJmQmJHY2tPWEF1cFJ4?=
 =?utf-8?B?NWRkSWFIaFFJcnpjalJoQzhmcmlGUmhJc1BrbzVEN2RMRXh0YXo0VTlrMGJm?=
 =?utf-8?B?dWJLZ0NSSFZCa2NVTE1sRXpOOS9zNDVWdGlzRFFhUzBzMG5vaWpyRHJjazc4?=
 =?utf-8?B?dWkzTEpFUzNZOGdZNkJQaktNQmFqQ2pJditoRk12Ym5iZUFOOEx1bmlhRGpW?=
 =?utf-8?B?Nng5WGk4eE5PUFIvdTVJSnB2L21HdnAwcG9EMFZaU0Iwd00rSWFVdWgyMG0x?=
 =?utf-8?B?Y0l1cExQYVVJbVlZNUgzeGN5V2hDaCs3UHRmNVpnTFpxYVhzaWZVa0x1b2dO?=
 =?utf-8?B?VXJGMUlxUnFGTHV6TW0zV0hzVStkM2RiM3JiaHZXR1IvMjUyU3RpVEVoYU9a?=
 =?utf-8?B?TUxBRUtudnZTZkFQZDFsa3gydUR2TExGdGszTitWUVVMZUh2bVpDS3JURjZR?=
 =?utf-8?B?cFNJTWdTV01zSEtxWTJpb1pFdXhXSHNQSVJrN3BLODJJUHRhbGVBbjJKNmdQ?=
 =?utf-8?B?QXJVY1hJUGNkZXRjWFExNFN3b2k1UmJhS2lHeUZ0MHdTWnkzMmhIcy9WQndz?=
 =?utf-8?B?UkN6NXVITG4vRE9mbXVSS3pUTXF3NU02ZEZlcTd1QmMvWEpkbFhWUFdsay9X?=
 =?utf-8?B?eWx3RFR2VmlqS29TZ1BMcUt2MnNkRWRKa29pNzlCSXh5emk0RVBvR2dZYTdi?=
 =?utf-8?B?V3ZncHdmRFNuUkJpM0NFcXhOK05OcnZEQkNVNmswZnd5SUQrSnFQQ0lBZW1U?=
 =?utf-8?B?VndGYzBsT3lIWGtFR1pRUnMwWXlLaXh3c2VyMHFlLzRQc05nMGN0T3VSS0Nh?=
 =?utf-8?B?SzNJbnpid21ITWFiU1MzeXgyeEk2blVTOGFjMDN6ZWtTMURPNW1GcjBVaXd3?=
 =?utf-8?B?TGR0K1htUnNweWZrU2tPNnJwSER0b0JPV0Y5aXhDT3gvWjZPUmdobTk0REpP?=
 =?utf-8?B?bnhhQmxoWHcvMGlGdWkzRXdhRTJMQ1RLOCs1UW5ZVFhKOWIrUVZTV2RBQWRm?=
 =?utf-8?B?a0kveStTYW5yVXNyNHZ5RmdqRkU0VEV3amRSV2RPeEpRWUdYWjBjZG5Menhn?=
 =?utf-8?B?bEo4aWNVVk95MXhDUGRWN1FJK24vWGJpbjlzcDZuNHd3bzREQlpXemJ3dXJ0?=
 =?utf-8?B?OHV5V0x0NmxSS2d5RURERk1FWVBLdk40OC9EeEVxYlRSSzN0dUJKeVNobUJZ?=
 =?utf-8?B?andBMVVSVkVvNFdWcHVvaFFnQ0dmM2k0RFBLb3psRjZicUxUeDdSYW5uUExB?=
 =?utf-8?B?RUkwci9nU25NL21CZjczVG5lZXRHY2paVmZybjZtQksvU3hXaTZ6SFhqVEdP?=
 =?utf-8?B?eW50cXRFUjNKV01VNXRJUHFBR3BaaGo4ZEY2WTduSWFudUlmYVhsdy9PZ1do?=
 =?utf-8?B?c2ZvWTVMS2dqNXhIcTJlNXg3M09walM1TXdKRmNNcU5sVE9BVE0wQWZzdllB?=
 =?utf-8?Q?A/vA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7e9b19-3f7b-423b-c034-08da907f826e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 03:17:34.9576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sIbfraxjr2WLfzGQu0VWdnMKpeyhztuhh8Bi+Y2GF3HFjVI2ichjC2SgJ7RMcIB9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5413
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCg0KDQo+IC0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQo+IEZyb206IFNhcmF2YW5hIEthbm5hbiA8c2FyYXZhbmFrQGdvb2dsZS5j
b20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgU2VwdGVtYmVyIDcsIDIwMjIgNTo0MSBBTQ0KPiBUbzog
R3VwdGEsIE5pcHVuIDxOaXB1bi5HdXB0YUBhbWQuY29tPg0KPiBDYzogcm9iaCtkdEBrZXJuZWwu
b3JnOyBrcnp5c3p0b2Yua296bG93c2tpK2R0QGxpbmFyby5vcmc7DQo+IGdyZWdraEBsaW51eGZv
dW5kYXRpb24ub3JnOyByYWZhZWxAa2VybmVsLm9yZzsgZXJpYy5hdWdlckByZWRoYXQuY29tOw0K
PiBhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbTsgY29odWNrQHJlZGhhdC5jb207IEd1cHRhLCBQ
dW5lZXQgKERDRy1FTkcpDQo+IDxwdW5lZXQuZ3VwdGFAYW1kLmNvbT47IHNvbmcuYmFvLmh1YUBo
aXNpbGljb24uY29tOw0KPiBtY2hlaGFiK2h1YXdlaUBrZXJuZWwub3JnOyBtYXpAa2VybmVsLm9y
ZzsgZi5mYWluZWxsaUBnbWFpbC5jb207DQo+IGplZmZyZXkubC5odWdvQGdtYWlsLmNvbTsgTWlj
aGFlbC5TcmJhQHNlem5hbS5jejsgbWFuaUBrZXJuZWwub3JnOw0KPiB5aXNoYWloQG52aWRpYS5j
b207IGpnZ0B6aWVwZS5jYTsgamdnQG52aWRpYS5jb207IHJvYmluLm11cnBoeUBhcm0uY29tOw0K
PiB3aWxsQGtlcm5lbC5vcmc7IGpvcm9AOGJ5dGVzLm9yZzsgbWFzYWhpcm95QGtlcm5lbC5vcmc7
DQo+IG5kZXNhdWxuaWVyc0Bnb29nbGUuY29tOyBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJh
ZGVhZC5vcmc7IGxpbnV4LQ0KPiBrYnVpbGRAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnOw0KPiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsga3ZtQHZnZXIu
a2VybmVsLm9yZzsgb2theWFAa2VybmVsLm9yZzsgQW5hbmQsDQo+IEhhcnByZWV0IDxoYXJwcmVl
dC5hbmFuZEBhbWQuY29tPjsgQWdhcndhbCwgTmlraGlsDQo+IDxuaWtoaWwuYWdhcndhbEBhbWQu
Y29tPjsgU2ltZWssIE1pY2hhbCA8bWljaGFsLnNpbWVrQGFtZC5jb20+Ow0KPiBSYWRvdmFub3Zp
YywgQWxla3NhbmRhciA8YWxla3NhbmRhci5yYWRvdmFub3ZpY0BhbWQuY29tPjsgZ2l0IChBTUQt
WGlsaW54KQ0KPiA8Z2l0QGFtZC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENIIHYzIDMv
N10gaW9tbXUvYXJtLXNtbXUtdjM6IHN1cHBvcnQgb3BzIHJlZ2lzdHJhdGlvbg0KPiBmb3IgQ0RY
IGJ1cw0KPiANCj4gW0NBVVRJT046IEV4dGVybmFsIEVtYWlsXQ0KPiANCj4gT24gVHVlLCBTZXAg
NiwgMjAyMiBhdCA2OjQ4IEFNIE5pcHVuIEd1cHRhIDxuaXB1bi5ndXB0YUBhbWQuY29tPiB3cm90
ZToNCj4gPg0KPiA+IFdpdGggbmV3IENEWCBidXMgc3VwcG9ydGVkIGZvciBBTUQgRlBHQSBkZXZp
Y2VzIG9uIEFSTQ0KPiA+IHBsYXRmb3JtLCB0aGUgYnVzIHJlcXVpcmVzIHJlZ2lzdHJhdGlvbiBm
b3IgdGhlIFNNTVUgdjMNCj4gPiBkcml2ZXIuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBOaXB1
biBHdXB0YSA8bmlwdW4uZ3VwdGFAYW1kLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9pb21t
dS9hcm0vYXJtLXNtbXUtdjMvYXJtLXNtbXUtdjMuYyB8IDE2ICsrKysrKysrKysrKysrLS0NCj4g
PiAgMSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pb21tdS9hcm0vYXJtLXNtbXUtdjMvYXJtLXNtbXUt
djMuYw0KPiBiL2RyaXZlcnMvaW9tbXUvYXJtL2FybS1zbW11LXYzL2FybS1zbW11LXYzLmMNCj4g
PiBpbmRleCBkMzJiMDIzMzY0MTEuLjhlYzlmMmJhZjEyZCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2
ZXJzL2lvbW11L2FybS9hcm0tc21tdS12My9hcm0tc21tdS12My5jDQo+ID4gKysrIGIvZHJpdmVy
cy9pb21tdS9hcm0vYXJtLXNtbXUtdjMvYXJtLXNtbXUtdjMuYw0KPiA+IEBAIC0yOSw2ICsyOSw3
IEBADQo+ID4gICNpbmNsdWRlIDxsaW51eC9wbGF0Zm9ybV9kZXZpY2UuaD4NCj4gPg0KPiA+ICAj
aW5jbHVkZSA8bGludXgvYW1iYS9idXMuaD4NCj4gPiArI2luY2x1ZGUgPGxpbnV4L2NkeC9jZHhf
YnVzLmg+DQo+ID4NCj4gPiAgI2luY2x1ZGUgImFybS1zbW11LXYzLmgiDQo+ID4gICNpbmNsdWRl
ICIuLi8uLi9pb21tdS1zdmEtbGliLmgiDQo+ID4gQEAgLTM2OTAsMTYgKzM2OTEsMjcgQEAgc3Rh
dGljIGludCBhcm1fc21tdV9zZXRfYnVzX29wcyhzdHJ1Y3QNCj4gaW9tbXVfb3BzICpvcHMpDQo+
ID4gICAgICAgICAgICAgICAgIGlmIChlcnIpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAg
Z290byBlcnJfcmVzZXRfcGNpX29wczsNCj4gPiAgICAgICAgIH0NCj4gPiArI2VuZGlmDQo+ID4g
KyNpZmRlZiBDT05GSUdfQ0RYX0JVUw0KPiA+ICsgICAgICAgaWYgKGNkeF9idXNfdHlwZS5pb21t
dV9vcHMgIT0gb3BzKSB7DQo+ID4gKyAgICAgICAgICAgICAgIGVyciA9IGJ1c19zZXRfaW9tbXUo
JmNkeF9idXNfdHlwZSwgb3BzKTsNCj4gPiArICAgICAgICAgICAgICAgaWYgKGVycikNCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICBnb3RvIGVycl9yZXNldF9hbWJhX29wczsNCj4gPiArICAg
ICAgIH0NCj4gDQo+IEknbSBub3QgYW4gZXhwZXJ0IG9uIElPTU1Vcywgc28gYXBvbG9naWVzIGlm
IHRoZSBxdWVzdGlvbiBpcyBzdHVwaWQuDQo+IA0KPiBXaHkgZG9lcyB0aGUgQ0RYIGJ1cyBuZWVk
IHNwZWNpYWwgdHJlYXRtZW50IGhlcmUgKGxpa2UgUENJKSB3aGVuIHRoZXJlDQo+IGFyZSBzbyBt
YW55IG90aGVyIGJ1c3NlcyAoZWc6IEkyQywgU1BJLCBldGMpIHRoYXQgZG9uJ3QgbmVlZCBhbnkN
Cj4gY2hhbmdlcyBoZXJlPw0KDQpBRkFJVSwgdGhlIGRldmljZXMgb24gSTJDL1NQSSBkb2VzIG5v
dCB1c2UgU01NVS4gQXBhcnQgZnJvbSBQQ0kvQU1CQSwNCkZTTC1NQyBpcyBhbm90aGVyIHNpbWls
YXIgYnVzIChvbiBTTU1VdjIpIHdoaWNoIHVzZXMgU01NVSBvcHMuDQoNClRoZSBkZXZpY2VzIGhl
cmUgYXJlIGJlaGluZCBTTU1VLiBSb2JpbiBjYW4ga2luZGx5IGNvcnJlY3Qgb3IgYWRkDQptb3Jl
IGhlcmUgZnJvbSBTTU1VIHBlcnNwZWN0aXZlLg0KDQpUaGFua3MsDQpOaXB1bg0KDQo+IA0KPiAt
U2FyYXZhbmENCj4gDQo+ID4gICNlbmRpZg0KPiA+ICAgICAgICAgaWYgKHBsYXRmb3JtX2J1c190
eXBlLmlvbW11X29wcyAhPSBvcHMpIHsNCj4gPiAgICAgICAgICAgICAgICAgZXJyID0gYnVzX3Nl
dF9pb21tdSgmcGxhdGZvcm1fYnVzX3R5cGUsIG9wcyk7DQo+ID4gICAgICAgICAgICAgICAgIGlm
IChlcnIpDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgZ290byBlcnJfcmVzZXRfYW1iYV9v
cHM7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgZ290byBlcnJfcmVzZXRfY2R4X29wczsN
Cj4gPiAgICAgICAgIH0NCj4gPg0KPiA+ICAgICAgICAgcmV0dXJuIDA7DQo+ID4NCj4gPiAtZXJy
X3Jlc2V0X2FtYmFfb3BzOg0KPiA+ICtlcnJfcmVzZXRfY2R4X29wczoNCj4gPiArI2lmZGVmIENP
TkZJR19DRFhfQlVTDQo+ID4gKyAgICAgICBidXNfc2V0X2lvbW11KCZjZHhfYnVzX3R5cGUsIE5V
TEwpOw0KPiA+ICsjZW5kaWYNCj4gPiArZXJyX3Jlc2V0X2FtYmFfb3BzOiBfX21heWJlX3VudXNl
ZDsNCj4gPiAgI2lmZGVmIENPTkZJR19BUk1fQU1CQQ0KPiA+ICAgICAgICAgYnVzX3NldF9pb21t
dSgmYW1iYV9idXN0eXBlLCBOVUxMKTsNCj4gPiAgI2VuZGlmDQo+ID4gLS0NCj4gPiAyLjI1LjEN
Cj4gPg0K
