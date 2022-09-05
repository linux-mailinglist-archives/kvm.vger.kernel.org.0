Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49C95AD450
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 15:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237940AbiIENzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 09:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237199AbiIENy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 09:54:58 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2075.outbound.protection.outlook.com [40.107.100.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B686114D02;
        Mon,  5 Sep 2022 06:54:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9kIT41vqUerp9Om6AhlVpzFwhUdfCmNvQCjkwYOXwa348QhrWibLQR5F/uVl3nSwTmBWkEl2JZfb4LobNNgM/iPlr3/am3tnzlt19pF1gAb32t0sAys0ZbZAxrVpWOqKsLgkW767s2GryZCVdVtK9Evk2+JS2kgH+KPzF4MtQ0uQ4pzOzTJbdMTCnolhEese0D5SK/TQqbSNjDwfoXehOo13OjFmvfTjkmBxq5D1wf5qO2jd/AA+w3BR0r6OXXYWCn3EAepPN0piHAkUn+q7zpDheK+HYoV5klRlpVPxvcgQjjoh/K8pwxiD0HzWQdahSH4ilfPz3jolReaPG1Qdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SJ7TB4ZUWILGO5q3TMu1CoLXvdIQzA0D4LrM3Qb5Poo=;
 b=f7xQa9o/F9sctkIrbr4L1Pyd89C3SkV/SU1VzB4Mapd/k2vp8qomx9SNLUADw9BRIrUU0qBAU5gt0l1RICmAdU/ABYfrbgVcBaG1WbNXxHyaLox1KznEKeRe0WVIqRY1QIOOOtfPvbl4/KTpGZRhCHRIztRGqBfg/rwTTLwnLsqVGpVMxiGQntMe0vlBuUtDMXDuH7OHN8rPYSf0m64+K8e0CIQlIBh9QECdLmSQyxWfeTmENuZxzE7lmSsvB5bbOWoKKJD9JKHkjWWXqY3PlcTiknIZpl16ZOcYEgq2H+u/rURp78ZsoZZcWuxxDlOJbc2JUqKYGwo8IFbzqBIuqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJ7TB4ZUWILGO5q3TMu1CoLXvdIQzA0D4LrM3Qb5Poo=;
 b=N+hiVC3Jtp3jW4AM969O6JvMLw+5pKOGbXYLkPUKvrVLmQPw6ItsJHfMg8nraKtZ4+PUlK74vDNESTmNNOXcrX7/NCNfIHd/utNFyUdM6qAcsa+SRIDDEJa6gURByO9XuNITlgBQ0HR2S4IggYJiXzyXJvx41690Q6mJPhwi0To=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by DM4PR12MB6039.namprd12.prod.outlook.com (2603:10b6:8:aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.15; Mon, 5 Sep
 2022 13:54:54 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74%3]) with mapi id 15.20.5588.014; Mon, 5 Sep 2022
 13:54:54 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Saravana Kannan <saravanak@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
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
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v2 6/6] driver core: add compatible string in sysfs
 for platform devices
Thread-Topic: [RFC PATCH v2 6/6] driver core: add compatible string in sysfs
 for platform devices
Thread-Index: AQHYskr/LaY6v+5gdkiC8zw49rqoJK2zOBkAgAAJUwCAHbgEEA==
Date:   Mon, 5 Sep 2022 13:54:54 +0000
Message-ID: <DM6PR12MB3082AF7C703A3C926A65D789E87F9@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-7-nipun.gupta@amd.com> <Yv0JsOJBfVW1lAOy@kroah.com>
 <CAGETcx_CXE6PPOrbJ9uxYPdNn2TPDUtxxTxXGu+A1OJOH0p5Tw@mail.gmail.com>
In-Reply-To: <CAGETcx_CXE6PPOrbJ9uxYPdNn2TPDUtxxTxXGu+A1OJOH0p5Tw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-05T13:56:55Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=6789e0bf-aed1-4bca-a455-f663f0c1f641;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8217a6c-b990-49f4-f040-08da8f4635e9
x-ms-traffictypediagnostic: DM4PR12MB6039:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iOxcgRE5I2dqrzO82QHR8skpgpMuY1A3Uy0jOrhXL1xynAxq00o7biXmWM3j/P69f/7xuVzf5xQ66BBA1QIUwLUy/uF0dN5okt7G+zEbpkt5V9IdmDQwdKic+/5p3JhGiKknRYA/4C5t5x5j8UqKirbq/bKPeKBtRHWkUEJ4WbvxNqqtRzlp8yXuxqZLi91EcN7K7AyD6BLnvZA9Xqp2r4nOma+FY3y7cNhasWLeY63mpFJXdsTLywB+Bd3wiraUoc2GF0Jdp4hw/K3DFMu3yBDAADC8W54FIaO4eqMLuhABQ9oVHy12Ktwq+0JRmtpP6TUkYRYMhQPDIg4d5tWdKGnD/j9TJ84iGGpndKc7fRzuWkVGt8GUZE6ks32D4LQx4LnPoja6c2oQWAszoB71SFpzAup9/jCNvlF/M1k5uaOJS7SmHF3egsA5r5+4MC7uH42plx/qjvpRrugP15XaW2/p0TH5jXJyjDUluTrnxdjNGBHm05exSHrtu0LgLsgoab+k1wbs0UfrSnIuH0EgJrKgZ7pgGmoeJSml1n5lkBgG/m/juC/Quli8QZUJUdywxrBTEj9peolGB/kjevLASZqat2PfYgaAY4zB/kyugKlMxq1obpgSS9Wi/8cMZqCoStihxRSutWd/VrvEv7mmFugAsRqhEA5P/Ifhwc055KWK/mDxRYpK+z1dL9RYiFhGhcJYbdGBxVZnlozKfXBEF2FrXzb2Rk8X7VrxCiOdavcjWRMaYPJxEiVQ7zJwVpPywB5zaLsaZ3Iwln1NRjGAWq7lSNgedeyjoEOZihMyvZw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(86362001)(7696005)(83380400001)(38100700002)(186003)(38070700005)(122000001)(9686003)(7416002)(66446008)(33656002)(26005)(64756008)(8676002)(76116006)(66476007)(66946007)(66556008)(316002)(2906002)(4326008)(110136005)(54906003)(8936002)(966005)(5660300002)(52536014)(55016003)(71200400001)(45080400002)(41300700001)(478600001)(6506007)(55236004)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VEhpdkV6ejNpbldSVGJlR2N3dWwzMVRSWTZKbWFydHA1bEJhdUxZQkJOSFM2?=
 =?utf-8?B?SlRiUjByODJtdG5XS0lxZmExVElqY1hvak5kOHU5bStVb04ydVBtd1BaRFgw?=
 =?utf-8?B?c3gzTDhqUEVQKytrVHFWeWRBR2phdGlINlBub1JLcjV1SnVhS2RINUlDV1Vk?=
 =?utf-8?B?L0tpQWlMM2xTbUxwYUl3RGxyRW9JbnpCdXBjMEN0VVhiNkZxaGRTWmhQL3dv?=
 =?utf-8?B?bmg2amJOaldZWHpIazhtN01jdXBVSkFuYzVvbHZUUERVS09ZZmR4WnY5V2FC?=
 =?utf-8?B?NSt6UENQbEdFSVJEU2NMMDZ2M3UvaXJ4ODlIdVB5SU5jWGhQaUFTREd1eVcz?=
 =?utf-8?B?cys3TW9weUlWdjNrTFZQOC9tbW50SXJMTkpsTDNiTHFhK3pwTzhBQUNsL3dM?=
 =?utf-8?B?dlJvM0ZrZ3d1c1VQdTJZZFQvNWFuaURONkJxNm1rR0J3MXU5a0wzbEVWUTVG?=
 =?utf-8?B?clN4RnFiSWhjQzg5WnNwRHJXMWMybW1RaHFTOUVzekZZU2hKNVFOSGJibVUv?=
 =?utf-8?B?V2N3VHdPbUtmcjlGSzk4RWtta0ZUMlFTYXl5OTgwOXB3WDI0Mjh5WlI0MjhX?=
 =?utf-8?B?VUhIeWNMU1VtVzdBTjVjM291bTV1eFJOYXZlSHR5V29lY24yeStnWnI2N3pk?=
 =?utf-8?B?QTZVa1hFMnk3YkxhNElyZi9PV1VqQjY5TWlHM3dpZEt1bTNBQ3BkeWhjaFVQ?=
 =?utf-8?B?dWphVElKdlRFQXd5SG5ZeU1uT0VvVmQ4WXBsRC83d3hhZWgyNVFiYnd6bEJw?=
 =?utf-8?B?Z09TUGdxdWJoWlBoS0Q0M2VPeW5ZOUJCUE9hUWJlcnBNbXlmblhiM1RWcmNi?=
 =?utf-8?B?RTB0VWRwSWtKWTdXZ3JjTnI1UXZ1cERMK202WEIxR0ltTFBrTW5qYURDbHdu?=
 =?utf-8?B?R1hIbDg4djgyc2x5SWt5Tk9vTG0xUDdNNlpNZUF4OHlySkFtWkZOMVN1MU9Z?=
 =?utf-8?B?bE5nUGhGdUtnL2Vnc1E0TGUxRWFNeE9VUm9yRU9INFUxSCtYUVpPMEpxRURy?=
 =?utf-8?B?NTBFdTVyME90YWRXMGp3R2RsYVZLSmZUTldncW94MkhEdjBHZ2xDRG8yUmRz?=
 =?utf-8?B?M2VTRHRycFE4MEJDZ0owazVXOW5pVi8vRDhrdVIzc1MwNWU1dHVTaVAyWXZ2?=
 =?utf-8?B?R2hSaFV1b29hMUxRN0JDNE9SZnBYZzNWTDBkVXUyTGNtbkdIQWU0Q0EyK21t?=
 =?utf-8?B?WGNsVmk3d0ViSXBpR2k1K1pPbmx2c2wvM2IwczlnY2ptV1JDcTZoWVlaeU1s?=
 =?utf-8?B?d09LRkNaRHdaV2drT2lwNjIxdWZWbzM0cUx5SnhoWTR1amhhQm9aeEZUTFdI?=
 =?utf-8?B?cThQYmVzc3lBMGxpeDhwWjMwZGQySkdiZG9xdHJDMHBFZ0tOQmR6ZXdwTVkv?=
 =?utf-8?B?eEY2em1LTzRvNkhHYVVCUS9yTU83SDhIWXB4bk1jZ0plYnIzeVpMNXhMTDUv?=
 =?utf-8?B?eEtmcTB1bUx4anBxMjR6Ny9TR1BKZ3FDUk5tem9YbHNmTEVsNXhHMlYxWnk1?=
 =?utf-8?B?Z2czWWNXczA5NlVaMThVUWJWMGtQYmQySE9lSSsrUDRKZ0J5eHhZZ21ZTHJl?=
 =?utf-8?B?MGxyUkdwckw3K1BkaU9xbVYxMVE2TG9xZ3QxUmZkYmpBT29lTUM4dDdld2Ft?=
 =?utf-8?B?Q0VaYURVbklQMWNPdCtuOWRJMG1odW1IR3lKSmpCazRQdjJYR2lYelVKd0p5?=
 =?utf-8?B?aXZLREJ1U3pJcUNsNkxFei82RUszYnhEenIvbm1yd0FZY0ZtdTYweVh2cnE4?=
 =?utf-8?B?L1puUGtSWGxBUXErT1E3SmlnNmdIcHZyeFkyVjNId1lpc2U1QUVOYk0zOGRO?=
 =?utf-8?B?RmljNGxvU2NjQVZrdXlzaThqS2N3Z1hYSjJ5QzRmUjBXNkh5blJDSk1GVWJB?=
 =?utf-8?B?QThMVjd2UmdUWUFjSkVPQ3JlNDMvV3VhV2t6NlNCczJra2JNRkc3R1d2YWlK?=
 =?utf-8?B?MlJHLy84NWVGMHhYdnF0QlR5QitXZU1VZ1l4cG1rVUorR0R3My8wUDhiNXBN?=
 =?utf-8?B?MEpma1JqVUVlanJmNUpOVlljY1Y5K2hVWVVmK1JCTUo1NnBCd2N6aHorZG1H?=
 =?utf-8?B?QlNoVlkxV1JiRGpURWNKbk5NNTFHYjBBRWJYdlllVzVBV2Y4RlYvL1M2Q0ZU?=
 =?utf-8?Q?Z57Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8217a6c-b990-49f4-f040-08da8f4635e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2022 13:54:54.0728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JUvhjcCwIKGMf/4c/+nifcE8zX08oPG5k6/PmEJ/b829ba4nCrvTNiwsSq9rl61w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6039
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
b20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgQXVndXN0IDE3LCAyMDIyIDk6MzQgUE0NCj4gVG86IEdy
ZWcgS0ggPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiBDYzogR3VwdGEsIE5pcHVuIDxO
aXB1bi5HdXB0YUBhbWQuY29tPjsgcm9iaCtkdEBrZXJuZWwub3JnOw0KPiBrcnp5c3p0b2Yua296
bG93c2tpK2R0QGxpbmFyby5vcmc7IHJhZmFlbEBrZXJuZWwub3JnOyBlcmljLmF1Z2VyQHJlZGhh
dC5jb207DQo+IGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tOyBjb2h1Y2tAcmVkaGF0LmNvbTsg
R3VwdGEsIFB1bmVldCAoRENHLUVORykNCj4gPHB1bmVldC5ndXB0YUBhbWQuY29tPjsgc29uZy5i
YW8uaHVhQGhpc2lsaWNvbi5jb207DQo+IG1jaGVoYWIraHVhd2VpQGtlcm5lbC5vcmc7IG1hekBr
ZXJuZWwub3JnOyBmLmZhaW5lbGxpQGdtYWlsLmNvbTsNCj4gamVmZnJleS5sLmh1Z29AZ21haWwu
Y29tOyBNaWNoYWVsLlNyYmFAc2V6bmFtLmN6OyBtYW5pQGtlcm5lbC5vcmc7DQo+IHlpc2hhaWhA
bnZpZGlhLmNvbTsgamdnQHppZXBlLmNhOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0K
PiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsga3ZtQHZnZXIua2VybmVsLm9yZzsgb2theWFA
a2VybmVsLm9yZzsgQW5hbmQsDQo+IEhhcnByZWV0IDxoYXJwcmVldC5hbmFuZEBhbWQuY29tPjsg
QWdhcndhbCwgTmlraGlsDQo+IDxuaWtoaWwuYWdhcndhbEBhbWQuY29tPjsgU2ltZWssIE1pY2hh
bCA8bWljaGFsLnNpbWVrQGFtZC5jb20+OyBnaXQNCj4gKEFNRC1YaWxpbngpIDxnaXRAYW1kLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggdjIgNi82XSBkcml2ZXIgY29yZTogYWRkIGNv
bXBhdGlibGUgc3RyaW5nIGluIHN5c2ZzIGZvcg0KPiBwbGF0Zm9ybSBkZXZpY2VzDQo+IA0KPiBb
Q0FVVElPTjogRXh0ZXJuYWwgRW1haWxdDQo+IA0KPiBPbiBXZWQsIEF1ZyAxNywgMjAyMiBhdCA4
OjMxIEFNIEdyZWcgS0ggPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiB3cm90ZToNCj4g
Pg0KPiA+IE9uIFdlZCwgQXVnIDE3LCAyMDIyIGF0IDA4OjM1OjQyUE0gKzA1MzAsIE5pcHVuIEd1
cHRhIHdyb3RlOg0KPiA+ID4gVGhpcyBjaGFuZ2UgYWRkcyBjb21wYXRpYmxlIHN0cmluZyBmb3Ig
dGhlIHBsYXRmb3JtIGJhc2VkDQo+ID4gPiBkZXZpY2VzLg0KPiA+DQo+ID4gV2hhdCBleGFjdGx5
IGlzIGEgImNvbXBhdGlibGUgc3RyaW5nIj8NCj4gDQo+IERpZG4ndCByZWFkIHRoZSByZXN0IG9m
IHRoZSBwYXRjaGVzIGluIHRoZSBzZXJpZXMgeWV0LCBidXQgTmFjayB0bw0KPiB0aGlzLiBUaGlz
IGluZm8gaXMgYWxyZWFkeSBhdmFpbGFibGUgdW5kZXI6DQo+IA0KPiA8ZGV2aWNlIGZvbGRlcj4v
b2Zfbm9kZS9jb21wYXRpYmxlIGZvciBhbnkgZGV2aWNlIGluIGFueSAob3IgYXQgbGVhc3QNCj4g
bW9zdCkgYnVzIHRoYXQgd2FzIGNyZWF0ZWQgZnJvbSBhbiBvZl9ub2RlLg0KPiANCj4gVW5sZXNz
IGNvbXBhdGlibGUgaXMgbm93IGFsc28gaW4gQUNQSS4gSW4gd2hpY2ggY2FzZSwgaXQncyBwcm9i
YWJseSBiZQ0KPiBiZXR0ZXIgdG8gaGF2ZSBhbiBvZl9ub2RlIGxpa2Ugc3ltbGluay4NCg0KV2Ug
d2lsbCBub3QgYmUgZ29pbmcgd2l0aCBwbGF0Zm9ybSBkZXZpY2VzIGZvciBDRFggYnVzIGFuZCB3
b3VsZA0KcmF0aGVyIGhhdmUgQ0RYIGRldmljZXM6DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9s
a21sL0RNNlBSMTJNQjMwODI3NTc3RDUwQUIxQjg3NzQ1ODkyM0U4Nzk5QERNNlBSMTJNQjMwODIu
bmFtcHJkMTIucHJvZC5vdXRsb29rLmNvbS8NClNvLCB0aGlzIGNoYW5nZSBpcyBub3QgdmFsaWQg
Zm9yIHVzLiBXZSB3b3VsZCBub3QgYmUgaGF2aW5nIHRoaXMgaW4gUmV2IFYzLg0KDQotIE5pcHVu
DQo=
