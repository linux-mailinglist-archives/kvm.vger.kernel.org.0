Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFDE5A4201
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 06:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiH2EtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 00:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiH2EtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 00:49:06 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A52B23BF6;
        Sun, 28 Aug 2022 21:49:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIcwsLr80fEaMl6yfQdc7JZ3FxP97WsEavA5AapOZ5lXgg+m2l7Dxvb2a1JJTYay2jy18D71orYep5CmNlHDw1jmXQaRGqnMXS2/RnoiQtFniooq8zmmUgPy0fSF4pVnXxJcVZG9dFlIvpnNr8pcmzyByq4WF7sKZazIdqOztSq+IMQmrZRb6p8xbhEUE/18HR9P7KozjC27gZ3chnuvBi0lVCM45h3OSxh2Ciw+7n6l3KMvRTMqoOv1tKEK9PxXXUM3eKKV+IbyNEVHWQBk+YBjsl/bteUsDIImB16IkKgCzTaRrAyJGwQHJNBY0xEb6gQ8W5WfP86B9cM/ZDwxuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L2Jf6JWS6QxRbYZHKu/VRyffSLwk/3S8eoVKFwVt+YQ=;
 b=kAvX9Mxtc8DVEdiLEjfItAMwt0fyBcbATMhO10M++RKhLWnE7cBJzU0QnMVUqqqCqiuQjeNF3nY2UCIK8G4EEBjPqcxJdUPUKSjPPPDk1H/bQTEFlUpcjdVKrr5ELVuE34WfmelmNesQrHbwUfnX7Jb6FbueWRm2zxid6wHt4phoUKRAUE58FIfl0vdLAbl84oSyHwaq6enx1W0lVXbJMjnVt6+8PyyEiHm873zM0bDmKvf8BLBFF3FbszhJJZ+jA2aUVWUyBVrcCwWYPj4MDtexQNcCZe5XZGx2nCNmUv7eGuh8ZRVbqo0C7lPRx2mQwSmXC2UU9kq5WNjQR/+RlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2Jf6JWS6QxRbYZHKu/VRyffSLwk/3S8eoVKFwVt+YQ=;
 b=cNEO+DlqjO4FB7ZA3VCPHYLz4rEMDY7Ku5dgXvXqsLOQxmvfEWvXos8AxYjO/6ZGdDPenlbWRDBc0s9H8cEXePwDXe/hILzEBObgcDYSmwdn6tmv15lofVyuvEp1R8yTOnY9g+/dkslil+Hx4STedfoawGH+RVT3Rdgy21Fo2+A=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by CH2PR12MB4822.namprd12.prod.outlook.com (2603:10b6:610:6::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Mon, 29 Aug
 2022 04:49:02 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74%3]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 04:49:02 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        Saravana Kannan <saravanak@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Thread-Topic: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Thread-Index: AQHYskryPWbD9sL0uUGy0CZ+78RqoK2zOJuAgAeq3xCAAA5ggIACkHJAgAB+fACAAL3fAIABQH2AgAAWLYCAAMjUQA==
Date:   Mon, 29 Aug 2022 04:49:02 +0000
Message-ID: <DM6PR12MB30824C5129A7251C589F1461E8769@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-3-nipun.gupta@amd.com> <Yv0KHROjESUI59Pd@kroah.com>
 <DM6PR12MB3082D966CFC0FA1C2148D8FAE8719@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwOEv6107RfU5p+H@kroah.com>
 <DM6PR12MB3082B4BDD39632264E7532B8E8739@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwYVhJCSAuYcgj1/@kroah.com> <20220824233122.GA4068@nvidia.com>
 <CAGETcx846Pomh_DUToncbaOivHMhHrdt-MTVYqkfLUKvM8b=6w@mail.gmail.com>
 <a6ca5a5a-8424-c953-6f76-c9212db88485@arm.com>
In-Reply-To: <a6ca5a5a-8424-c953-6f76-c9212db88485@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-29T04:50:52Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=6042099c-df13-4e27-b5bf-cac1a9da6c49;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57533024-933b-4c93-0ba7-08da8979cb75
x-ms-traffictypediagnostic: CH2PR12MB4822:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dqsbDi3lUDmwyfE4TH+T1qGFjd49urcfyonWzC+RsQg09hvb5u4aQaSXmsVHpr/1Y7xkB7NE6/cwh4/R80Fxv/qjAQ0GogKu7ZD/Xj5i4clx+SHNTmZkLX1bA3POxZV4g+eyCr6zzRxpQsdovq2pR0Hffk3vSs8ncdciFOd/wxWLbLEIAITjYYXR+fr5YERJizbFyGUxQwVfxozKY5W9Aht7ER3Zys8EgS0bfqPlBEuamI5IWbxfhGBOEfJp3c6w8DsIWLwhf4X/JabQqtXOHSbzPB26X+SHXQvj1I2Sczbh2ced1cfbhJFFgryZtv091ikMjt7OtPfZe+snbVomDaY4n8VdPQySxxIZBibUIE7BSb+mJa1B6qbcaQbVxObPHh5kxI8lP5de8aetOTS+Wmf4aOXyy114i5NL5c0NB2I2l6iwToYsAv2aUw5QZ7I0GwPD08SDcQdQRk/Or2z8R6INwg73ACNUIlR2PlT8V9d6i2GOYFf+dwEhh0+J7Pbt6hcCiKxJqobq5tk002iEm2V3k8J94PPdSR/CInO7c12q6pksP8K9PBCZu6oyf32EYG231LRkUBdc9A2vfFEFkoSerm48RZxmnOEjv1mjmrhav8AdvC++Wivs4Vd2d0X+FEx5XituX3A6PB9FqGdNi5o7xAGuoOvJ71qqvuat6F56wXAlichTa6lYdCLCWtRbNN+vDw/0YfFIPGc0zsfOXFAN7maZjIvLsAq5TidFY5lJfDVA7XIcNYllh/cV8IuQIApMuvNsqH+jNBeJCzrlVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(8676002)(110136005)(316002)(66946007)(66556008)(66476007)(66446008)(4326008)(64756008)(71200400001)(54906003)(76116006)(8936002)(86362001)(5660300002)(478600001)(41300700001)(7416002)(52536014)(38070700005)(53546011)(55236004)(122000001)(6506007)(9686003)(2906002)(26005)(7696005)(83380400001)(38100700002)(55016003)(186003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlZTK0FJWDhrUlczbld6cHlMaXBMVDBzOG1HWFg3RFFGWDVpWHJjQ1JNRCtP?=
 =?utf-8?B?a1ZoSE41amRuSmZuN2YwalByQW4yL29kbE92ZFJIeExoWUo0VUo2dWNpcVEy?=
 =?utf-8?B?K2QybmJiWDJJY2dEZkpYNERUYlNpMXJpc01Bc0RKRU4rdndOdmVFczdoZEty?=
 =?utf-8?B?ZkFMcXJ6MTIwelB0WTVPZmZFZ1pONXdMRFluY2creUdNNTlZeE8rdS9UK0xH?=
 =?utf-8?B?L3VnV2RPelNBdHdVNlpCbnZoTXV4WXdmZ0htei9FVmtDSGJBRGFXbUlJM0JP?=
 =?utf-8?B?UmN0d0lMWkNsRExFODkxTSsxYTVPSnZJMU1LdDVmVTdUUmMxcktKRHRjOWcw?=
 =?utf-8?B?OWlabHRlNjlEQ216Q1U4UGM3WnFIMTlHQzE0L1ZXaUdMZVlrSjZLL1ljYVJU?=
 =?utf-8?B?ZzVWTkhFZG5uWkRYanNaeTRjWkFGbnFsaWYxTG5jUUlqMlU3ME1ubUlYYW01?=
 =?utf-8?B?Y05CcFphQTN1dGxGS1A0Y0RHcTNmN0ZMVDFIdkcxSkxtSkFyQWQ3aUh2UFVF?=
 =?utf-8?B?c1VXRFpuUG1RMnl3WmpZWFZnWENtVUZhZmlmK04vajl6Tkh0RHZDalRlSDd1?=
 =?utf-8?B?Z0hYY1NUU1VvN2g0aUluTDBRL08xaS9jb0dPWXhVMmIraWw3Q1FPdjdYbGdu?=
 =?utf-8?B?WitXUUw4dW45YkQvcCt1cGpIeXgyWGxsQi9jUDZwZERiWWR2ZlV1Q0ZqRnBI?=
 =?utf-8?B?cXMveW9VUStiZWRrck1IMW96bDJieWVORGY0MG5UcGlLblczc2oyMFg0NzdT?=
 =?utf-8?B?UTJ1SlhKUkhMTHdLekMydVlZb0x3U0xYTWVYSlkxd2cwSVBkVUdqTTJQUU9m?=
 =?utf-8?B?ODhzemtXV0kxSDJTa0RTeEczcnFGMGNlYTV6S1kvVzlvTFBzczZ6azd2V2dx?=
 =?utf-8?B?SWRIS01GZFRWcFV0ZmtJZmFrUUVsK3JxUlhlVS9pZlVNT2czU2tmcjFWd1Nx?=
 =?utf-8?B?L0E3NmhiOE40dDRZZkxPU0Y2QlViczhoamdld2I1emN1bGNvUVc2REVaeEVR?=
 =?utf-8?B?ZWtvNnAzR0xMcjFISjJuVk1aNHJCRWhFNUkrMzVVVlBpM1R6T01iQS9ZTUls?=
 =?utf-8?B?N0creUNlWDF2M3VMakpDdDQwdFp5THJKS2FtYytGYmRzd05kSkdWdmt0WnVG?=
 =?utf-8?B?SWR3SmZxdTdGNzZQYXh6WHNaZ1NMckJlS2MyNWNOTDlBYnd1UEt3c0pvK05s?=
 =?utf-8?B?L3ZpSThVbjgrUEg1bkpWU0xlTXdTL1M2aXQ1WU1tSGFNQzVVaENranIvN051?=
 =?utf-8?B?T29EVnc0ZkhXaTJuUVZ5SHFDZjFsamdaL0tIUCtMMktra1ZyQTQ4Ny9UU21u?=
 =?utf-8?B?MXNNaHVPRFp1UUUwMVMrOFNMRkNGTzUzZVd3NW1vRUQxZFF3RmlUUTFFRTJS?=
 =?utf-8?B?RkZBUUVabUFySFF5aUVUdUZ6Z1VxMWFxbGF3SUxaSXV3Yk5XS1VqdW9ZMDlw?=
 =?utf-8?B?WjZWcHF4ZnJUSXFOZGRxM2RZRlM1RWdNMXhlQVVGMzR0Um1JWERQZ2RnVWFj?=
 =?utf-8?B?UDdZdzJ2ZDVnb3lnZU1yQmhiLzVBYXZpcGh5UlZ6NytaU25SZjFxMllwMnd5?=
 =?utf-8?B?emEvb2M0Rm55WFlXRnJLWWFwWlhPMm5Xb0hvcDZZRkhNMUxiN3NmSGhNQXVO?=
 =?utf-8?B?bFF4blVpbWppNm1MeDkwRWxyTzEwNG5vL2dsT3d2NzZsd1Z0aVdzdlUyN1FU?=
 =?utf-8?B?M0JuUHZhRjE2dmRKSzY5VVM4TkkvWWdQUGZvYW5DdGFmUEtZbFFMVU1CblpW?=
 =?utf-8?B?RlBLUEkzbVM5bFpnaVhvRnJ6YTBldzNNWjR6SElnZTZVc205SXpoNEVqaWZQ?=
 =?utf-8?B?TElFRmpMdENrQzNWUU1ycExXM3U1OHNNUVN4bzJXbU5YSElwbzJOejVOVHdx?=
 =?utf-8?B?U2wxZzdmcjFjT01JaHBmY0oyY3B0S3FUZzcyV1J2SlRKRFBFMTQ3K1laN3lD?=
 =?utf-8?B?cHVOaUdYNHdCVDV1ZlFFU1lpdUpCcTl2bHJJR283S0J0dWlZYmVjWDlHR3lV?=
 =?utf-8?B?Q0tQQUQ4U09hRWFNSFc1RDhWei9Mc2l4bVN4V3VVUjBTNlR1SzNRdHd6LzZQ?=
 =?utf-8?B?T3VLbGNsOG11bWVoZmxmZW5oZlNnRzVHdWhabFlibE5xQXljQm5mUlpzeXE3?=
 =?utf-8?Q?kbTs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57533024-933b-4c93-0ba7-08da8979cb75
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 04:49:02.3215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fbOCDJTfwof7o4rmb5FjhHYCdBVt9j4ypYWpalXeNnqA2JvDwd4FbNBCf/0bcAuS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4822
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
TWVzc2FnZS0tLS0tDQo+IEZyb206IFJvYmluIE11cnBoeSA8cm9iaW4ubXVycGh5QGFybS5jb20+
DQo+IFNlbnQ6IEZyaWRheSwgQXVndXN0IDI2LCAyMDIyIDE6MjggQU0NCj4gVG86IFNhcmF2YW5h
IEthbm5hbiA8c2FyYXZhbmFrQGdvb2dsZS5jb20+OyBKYXNvbiBHdW50aG9ycGUNCj4gPGpnZ0Bu
dmlkaWEuY29tPg0KPiBDYzogR3JlZyBLSCA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+OyBH
dXB0YSwgTmlwdW4NCj4gPE5pcHVuLkd1cHRhQGFtZC5jb20+OyByb2JoK2R0QGtlcm5lbC5vcmc7
DQo+IGtyenlzenRvZi5rb3psb3dza2krZHRAbGluYXJvLm9yZzsgcmFmYWVsQGtlcm5lbC5vcmc7
IGVyaWMuYXVnZXJAcmVkaGF0LmNvbTsNCj4gYWxleC53aWxsaWFtc29uQHJlZGhhdC5jb207IGNv
aHVja0ByZWRoYXQuY29tOyBHdXB0YSwgUHVuZWV0IChEQ0ctRU5HKQ0KPiA8cHVuZWV0Lmd1cHRh
QGFtZC5jb20+OyBzb25nLmJhby5odWFAaGlzaWxpY29uLmNvbTsNCj4gbWNoZWhhYitodWF3ZWlA
a2VybmVsLm9yZzsgbWF6QGtlcm5lbC5vcmc7IGYuZmFpbmVsbGlAZ21haWwuY29tOw0KPiBqZWZm
cmV5LmwuaHVnb0BnbWFpbC5jb207IE1pY2hhZWwuU3JiYUBzZXpuYW0uY3o7IG1hbmlAa2VybmVs
Lm9yZzsNCj4geWlzaGFpaEBudmlkaWEuY29tOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
OyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZzsgb2th
eWFAa2VybmVsLm9yZzsgQW5hbmQsIEhhcnByZWV0DQo+IDxoYXJwcmVldC5hbmFuZEBhbWQuY29t
PjsgQWdhcndhbCwgTmlraGlsIDxuaWtoaWwuYWdhcndhbEBhbWQuY29tPjsNCj4gU2ltZWssIE1p
Y2hhbCA8bWljaGFsLnNpbWVrQGFtZC5jb20+OyBnaXQgKEFNRC1YaWxpbngpIDxnaXRAYW1kLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggdjIgMi82XSBidXMvY2R4OiBhZGQgdGhlIGNk
eCBidXMgZHJpdmVyDQo+IA0KPiBbQ0FVVElPTjogRXh0ZXJuYWwgRW1haWxdDQo+IA0KPiBPbiAy
MDIyLTA4LTI1IDE5OjM4LCBTYXJhdmFuYSBLYW5uYW4gd3JvdGU6DQo+ID4gT24gV2VkLCBBdWcg
MjQsIDIwMjIgYXQgNDozMSBQTSBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPiB3cm90
ZToNCj4gPj4NCj4gPj4gT24gV2VkLCBBdWcgMjQsIDIwMjIgYXQgMDI6MTE6NDhQTSArMDIwMCwg
R3JlZyBLSCB3cm90ZToNCj4gPj4+PiBXZSBjYW4gc2hhcmUgdGhlIFJGQyBpbiBjYXNlIHlvdSBh
cmUgaW50ZXJlc3RlZCBpbiBsb29raW5nIGF0IGNvZGUgZmxvdw0KPiA+Pj4+IHVzaW5nIHRoZSBv
Zl9keW5hbWljIGFwcHJvYWNoLg0KPiA+Pj4NCj4gPj4+IFBsZWFzZSBubyBtb3JlIGFidXNlIG9m
IHRoZSBwbGF0Zm9ybSBkZXZpY2UuDQo+ID4+DQo+ID4+IExhc3QgdGltZSB0aGlzIGNhbWUgdXAg
dGhlcmUgd2FzIHNvbWUgZGlzYWdyZWVtZW50IGZyb20gdGhlIEFSTSBmb2xrcywNCj4gPj4gdGhl
eSB3ZXJlIG5vdCBrZWVuIG9uIGhhdmluZyB4eF9kcml2ZXJzIGFkZGVkIGFsbCBvdmVyIHRoZSBw
bGFjZSB0bw0KPiA+PiBzdXBwb3J0IHRoZSBzYW1lIE9GL0RUIGRldmljZXMganVzdCBkaXNjb3Zl
cmVkIGluIGEgZGlmZmVyZW50IHdheS4gSXQgaXMNCj4gPj4gd2h5IEFDUEkgaXMgbWFwcGVkIHRv
IHBsYXRmb3JtX2RldmljZSBldmVuIGluIHNvbWUgY2FzZXMuDQo+ID4+DQo+ID4+IEkgdGhpbmsg
aWYgeW91IHB1c2ggdGhlbSBkb3duIHRoaXMgcGF0aCB0aGV5IHdpbGwgZ2V0IHJlc2lzdGFuY2Ug
dG8NCj4gPj4gZ2V0IHRoZSBuZWVkZWQgYWRkaXRpb25hbCB4eF9kcml2ZXJzIGludG8gdGhlIG5l
ZWRlZCBwbGFjZXMuDQo+ID4+DQo+ID4+PiBJZiB5b3VyIGRldmljZSBjYW4gYmUgZGlzY292ZXJl
ZCBieSBzY2FubmluZyBhIGJ1cywgaXQgaXMgbm90IGEgcGxhdGZvcm0NCj4gPj4+IGRldmljZS4N
Cj4gPj4NCj4gPj4gQSBEVCBmcmFnbWVudCBsb2FkZWQgZHVyaW5nIGJvb3QgYmluZHMgYSBkcml2
ZXIgdXNpbmcgYQ0KPiA+PiBwbGF0Zm9ybV9kcml2ZXIsIHdoeSBzaG91bGQgYSBEVCBmcmFnbWVu
dCBsb2FkZWQgcG9zdC1ib290IGJpbmQgdXNpbmcNCj4gPj4gYW4gWFhfZHJpdmVyIGFuZCBmdXJ0
aGVyIHdoeSBzaG91bGQgdGhlIENEWCB3YXkgb2YgZ2V0dGluZyB0aGUgRFQNCj4gPj4gcmFpc2Ug
dG8gc3VjaCBpbXBvcnRhbnRhbmNlIHRoYXQgaXQgZ2V0cyBpdHMgb3duIGNkeF9kcml2ZXIgPw0K
PiA+Pg0KPiA+PiBJbiB0aGUgZW5kIHRoZSBkcml2ZXIgZG9lcyBub3QgY2FyZSBhYm91dCBob3cg
dGhlIERUIHdhcyBsb2FkZWQuDQo+ID4+IE5vbmUgb2YgdGhlc2UgdGhpbmdzIGFyZSBvbiBhIGRp
c2NvdmVyYWJsZSBidXMgaW4gYW55IHNlbnNlIGxpa2UgUENJDQo+ID4+IG9yIG90aGVyd2lzZS4g
VGhleSBhcmUgZGV2aWNlcyBkZXNjcmliZWQgYnkgYSBEVCBmcmFnZW1lbnQgYW5kIHRoZXkNCj4g
Pj4gdGFrZSBhbGwgdGhlaXIgcGFyYW1ldGVycyBmcm9tIHRoYXQgY2h1bmsgb2YgRFQuDQo+ID4+
DQo+ID4+IEhvdyB0aGUgRFQgd2FzIGxvYWRlZCBpbnRvIHRoZSBzeXN0ZW0gaXMgbm90IGEgdXNl
ZnVsIGRpc3RpbmN0aW9uIHRoYXQNCj4gPj4gcmFpc2VzIHRoZSBsZXZlbCBvZiBuZWVkaW5nIGFu
IGVudGlyZSBuZXcgc2V0IG9mIHh4X2RyaXZlciBzdHJ1Y3RzIGFsbA0KPiA+PiBvdmVyIHRoZSB0
cmVlLCBJTUhPLg0KPiA+DQo+ID4gSmFzb24sIEkgc2VlIHlvdXIgcG9pbnQgb3IgcmF0aGVyIHRo
ZSBwb2ludCB0aGUgQVJNIGZvbGtzIG1pZ2h0IGhhdmUNCj4gPiBtYWRlLiBCdXQgaW4gdGhpcyBj
YXNlLCB3aHkgbm90IHVzZSBEVCBvdmVybGF5cyB0byBhZGQgdGhlc2UgZGV2aWNlcz8NCj4gPiBJ
SVJDIHRoZXJlJ3MgYW4gaW4ga2VybmVsIEFQSSB0byBhZGQgRFQgb3ZlcmxheXMuIElmIHNvLCBz
aG91bGQgdGhpcw0KPiA+IGJlIG1vcmUgb2YgYSBGUEdBIGRyaXZlciB0aGF0IHJlYWRzIEZQR0Eg
c3R1ZmYgYW5kIGFkZHMgRFQgb3ZlcmxheXM/DQo+ID4gVGhhdCdkIGF0IGxlYXN0IG1ha2UgYSBz
dHJvbmdlciBjYXNlIGZvciB3aHkgdGhpcyBpc24ndCBhIHNlcGFyYXRlDQo+ID4gYnVzLg0KPiAN
Cj4gUmlnaHQsIHRoYXQncyBleGFjdGx5IHdoZXJlIHRoaXMgZGlzY3Vzc2lvbiBzdGFydGVkLg0K
PiANCj4gVG8gbXkgbWluZCwgaXQgd291bGQgZGVmaW5pdGVseSBoZWxwIHRvIHVuZGVyc3RhbmQg
aWYgdGhpcyBpcyBhICpyZWFsKg0KPiBkaXNjb3ZlcmFibGUgYnVzIGluIGhhcmR3YXJlLCBpLmUu
IGRvZXMgb25lIGhhdmUgdG8gY29uZmlndXJlIG9uZSdzDQo+IGRldmljZSB3aXRoIHNvbWUgc29y
dCBvZiBDRFggd3JhcHBlciBhdCBGUEdBIHN5bnRoZXNpcyB0aW1lLCB0aGF0IHRoZW4NCj4gcGh5
c2ljYWxseSBjb21tdW5pY2F0ZXMgd2l0aCBzb21lIHNvcnQgb2YgQ0RYIGNvbnRyb2xsZXIgdG8g
aWRlbnRpZnkNCj4gaXRzZWxmIG9uY2UgbG9hZGVkOyBvciBpcyBpdCAiZGlzY292ZXJhYmxlIiBp
biB0aGUgc2Vuc2UgdGhhdCB0aGVyZSdzDQo+IHNvbWUgZmlybXdhcmUgb24gYW4gTUNVIGNvbnRy
b2xsaW5nIHdoYXQgZ2V0cyBsb2FkZWQgaW50byB0aGUgRlBHQSwgYW5kDQo+IHNvZnR3YXJlIGNh
biBxdWVyeSB0aGF0IGFuZCBnZXQgYmFjayB3aGF0ZXZlciBwcmVjb21waWxlZCBEVEIgZnJhZ21l
bnQNCj4gY2FtZSBidW5kbGVkIHdpdGggdGhlIGJpdHN0cmVhbSwgaS5lLiBpdCdzIHJlYWxseSBt
b3JlIGxpa2UgZnBnYS1tZ3IgaW4NCj4gYSBmYW5jeSBoYXQ/DQoNCkRldmljZXMgYXJlIGNyZWF0
ZWQgaW4gRlBGR0Egd2l0aCBhIENEWCB3cmFwcGVyLCBhbmQgQ0RYIGNvbnRyb2xsZXIoZmlybXdh
cmUpDQpyZWFkcyB0aGF0IENEWCB3cmFwcGVyIHRvIGZpbmQgb3V0IG5ldyBkZXZpY2VzLiBIb3N0
IGRyaXZlciB0aGVuIGludGVyYWN0cyB3aXRoDQpmaXJtd2FyZSB0byBmaW5kIG5ld2x5IGRpc2Nv
dmVyZWQgZGV2aWNlcy4gVGhpcyBidXMgYWxpZ25zIHdpdGggUENJIGluZnJhc3RydWN0dXJlLg0K
SXQgaGFwcGVucyB0byBiZSBhbiBlbWJlZGRlZCBpbnRlcmZhY2UgYXMgb3Bwb3NlZCB0byBvZmYt
Y2hpcCBjb25uZWN0aW9uLg0KDQpXZSBhcmUgdHJ5aW5nIHRvIGRvIGFuIFJGQyB3aGljaCBwcm9w
b3NlcyBDRFggYXMgYSBuZXcgYnVzLiBJdCBzZWVtcyB0byBiZSBhDQpjbGVhbmVyIGludGVyZmFj
ZSB0aGFuIHdoYXQgd2FzIGFkZGVkIGluIFJGQyB2Mi4NCg0KPiANCj4gSXQncyBwcmV0dHkgbXVj
aCBpbXBvc3NpYmxlIHRvIGp1ZGdlIGZyb20gYWxsIHRoZSBlbXB0eSBwbGFjZWhvbGRlciBjb2Rl
DQo+IGhlcmUgaG93IG11Y2ggaXMgcmVhbCBhbmQgY29uc3RyYWluZWQgYnkgaGFyZHdhcmUgYW5k
IGhvdyBtdWNoIGlzDQo+IGZpcm13YXJlIGFic3RyYWN0aW9uLCB3aGljaCBtYWtlcyBpdCBwYXJ0
aWN1bGFybHkgaGFyZCB0byByZXZpZXcgd2hldGhlcg0KPiBhbnkgcHJvcG9zYWwgaGVhZGluZyBp
biB0aGUgcmlnaHQgZGlyZWN0aW9uLg0KDQpZb3UgY2FuIGNvbnNpZGVyIHRoZSBwbGFjZWhvbGRl
cnMgZm9yIG5vdyBhcyBBUEkgY2FsbHMgd2hpY2ggd291bGQgZXZlbnR1YWxseQ0KY29tbXVuaWNh
dGUgd2l0aCBGVywgYW5kIGZldGNoIHJlcXVpcmVkIGluZm8gbGlrZSBudW1iZXIgb2YgRlBHQSBk
ZXZpY2VzLA0KZGV2aWNlIHJlbGF0ZWQgcGFyYW1ldGVycyAodmVuZG9yX2lkLCBkZXZpY2VfaWQg
ZXRjKSwgYW5kIGNvbW1hbmQgdGhlDQpmaXJtd2FyZSB0byByZXNldCB0aGUgZGV2aWNlLg0KDQpJ
biBuZXh0IHJldiwgd2Ugd291bGQgYWRkIG5ldyBBUEkgc3R1YnMgaW5zdGVhZCBvZiBlbXB0eSBw
bGFjZWhvbGRlcnMgKGFzIEZXDQppbnRlcmFjdGlvbiBjb2RlIGlzIHVuZGVyIGRldmVsb3BtZW50
KSwgd2hpY2ggY291bGQgZ2l2ZSBtb3JlIGNsZWFyIHZpZXcuDQoNCj4gDQo+IEV2ZW4gaWYgaXQg
KmlzKiBlbnRpcmVseSBmaXJtd2FyZSBzbW9rZS1hbmQtbWlycm9ycywgaWYgdGhhdCBmaXJtd2Fy
ZQ0KPiBjYW4gcHJvdmlkZSBhIHN0YW5kYXJkaXNlZCBkaXNjb3ZlcnkgYW5kIGNvbmZpZ3VyYXRp
b24gaW50ZXJmYWNlIGZvcg0KPiBjb21tb24gcmVzb3VyY2VzLCBpdCBjYW4gYmUgYSBidXMuIEJ1
dCB0aGVuIGl0IHNob3VsZCAqYmUqIGEgYnVzLCB3aXRoDQo+IGl0cyBvd24gYnVzX3R5cGUgYW5k
IGl0cyBvd24gZGV2aWNlIHR5cGUgdG8gbW9kZWwgdGhvc2Ugc3RhbmRhcmQNCj4gaW50ZXJmYWNl
cyBhbmQgSURzIGFuZCByZXNvdXJjZXMuIE9yIGlmIGl0IGlzIHJlYWxseSBqdXN0IGEgdmVyeSBj
bGV2ZXINCj4gZHluYW1pYyBEVCBvdmVybGF5IG1hbmFnZXIgZm9yIHBsYXRmb3JtIGRldmljZXMs
IHRoZW4gaXQgY2FuIGJlIHRoYXQNCj4gaW5zdGVhZC4gQnV0IHdoYXQgaXQgc2hvdWxkIGNsZWFy
bHkgbm90IGJlIGlzIHNvbWUgaW4tYmV0d2VlbiBtZXNzDQo+IG1ha2luZyB0aGUgd29yc3Qgb2Yg
Ym90aCB3b3JsZHMsIHdoaWNoIGlzIHdoYXQgdGhlIGNvZGUgaGVyZSBpbmVzY2FwYWJseQ0KPiBz
bWVsbHMgb2YuDQo+IA0KPiBUaGFua3MsDQo+IFJvYmluLg0K
