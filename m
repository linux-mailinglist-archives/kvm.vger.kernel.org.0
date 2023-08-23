Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02258785B16
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 16:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbjHWOui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 10:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233614AbjHWOuf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 10:50:35 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2052.outbound.protection.outlook.com [40.107.101.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97020E6A;
        Wed, 23 Aug 2023 07:50:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPB9Zu5SZ67GsfMMz7Stuz+mjq5MmU2kE2j46HQLcHPYEofvnQ0z/nLkkEgQgtqShuvZEB1OQZBHIEIWrWCwnnFq2dJkiT8BwOgVCAmaAwmnLnmJvVlbuyO1CAlkxuvMqfQ4D06CQsvcMu+OhfI7yV4g23TQqo3ZLlQ/8wUCVVue8yZQ2dfB+gVxM+0ewAfGiOgUCyv8ZfpLaZbnb2Koj3zxlUDTFg10b+gtPGdVphTnrsxvhpGuw1Dv+aENiJWuRVkIUMDDF5tMM31VBOewsmE58ULCd575K9909zktPqAGd7ju5QHV0bfyJJWrM3CedXeFwmQINmm3erJiw8JnZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FhwVjQqnV4h9iqNDTKMO4yT05hvmCkOZFwQXl7Z+bn0=;
 b=iH/SQmQN2EHYTQSfgw3z0O+LCd1CZj35kcYdXgQdYxsb4Kx8TehAQJedSz9eWNTnuGBP9OfZj+YE7EsQP9U+ohXkikFyjJzgMe+yyibdy2lQnfkZcZZOf0SSdjETj92SGM68SyR7OiuDi6vIaEcMwgnw1dzuZCxxX2Tx/xsgyAED+KTyt+JazwCCac3T8PgaI75a4maUxqNtkQ5tDjfeGXXKFuV0/Rk52gZSL+NoJ6oQvy0zIqJ4ETC3Ripebae6Zxwf+OorGaTM9Qs51RoV12DWapro0WJnmx8jcf1rtoZuBYX0U250HEFU7fmZ49kmtg+hMNXCz8f5DGcBIYK8LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FhwVjQqnV4h9iqNDTKMO4yT05hvmCkOZFwQXl7Z+bn0=;
 b=USOcgoV6jPPWvL5EHi07+2O5PZk8wwXvfo4yrERklaARB+IQ+hnc3y/H2hZdxXEn3UisY8bnaVWuKxbESfH2BnIZCSThEC05i3v4IerBVnxhGuFYo7kogOF6ZtTWgXgFrgsdz7LzyzEEkHzXHOpV9Q90u1GiCG6PUcevdvKP0N8PlqNo3I2cvrZLbaqXEiGWlLiWwGjCChy6usqkLjg7WU3/feJ1CxUD4esDhlF45qioMFFBqwEAF0Z6+8RmQp3R1HCx67qXPS/4q4uoJyhjHTWtt+mDqr+ixZkzE9G3eEvLQp4Imm29TsdWkc7XG9pXSemhcQB4SeO8+OxfoFREeA==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by CH2PR12MB4229.namprd12.prod.outlook.com (2603:10b6:610:a5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.26; Wed, 23 Aug
 2023 14:50:31 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::9e7a:4853:fa35:a060]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::9e7a:4853:fa35:a060%2]) with mapi id 15.20.6699.026; Wed, 23 Aug 2023
 14:50:31 +0000
From:   Ankit Agrawal <ankita@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v7 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Index: AQHZ1TZ6Nms5b5NPG0K9tyfNGGuGJa/36LOAgAANtdw=
Date:   Wed, 23 Aug 2023 14:50:31 +0000
Message-ID: <BY5PR12MB37639528FCF1CDB7D595B6FFB01CA@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20230822202303.19661-1-ankita@nvidia.com>
 <ZOYP92q1mDQgwnc9@nvidia.com>
In-Reply-To: <ZOYP92q1mDQgwnc9@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|CH2PR12MB4229:EE_
x-ms-office365-filtering-correlation-id: 7bf7be8d-0195-4b51-35b7-08dba3e84c68
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CLi7X8KoADlsXDwRybSWfc8SGj9vEmnpZnZhPLjZkuYyRpbmyYSc73oNIIoPNRRo4eX0hhG17+EmNO/T9ycNipRYnf4pZbB92zbQdeWMh59AbMMcoqgZfZflbIUqSWsLoJXwtgUskiu57dc+qBiZQxTszkkyJA9aotbkTs3tGChMm0oIJbe2gFerz2ubix2m5+zD0oGIfvtMgKNfmIIfz8ZKHkz+MT+C0ZhPCDiBVHeq0qUyW3FfbYR/BpuKlIljv5ZKj68geze9cMNWswHvO/TyTLiyqb1NvqAM0YXPB9UpoFPnTqgPfuQti1vq6Q5M38ff+Tv6ook539fVMOiwIgBgsQktw+WKXkjmpTS6vBH7DNKFxrl4ow9SX6rlwaUV6JZSuOBfVse8uYHgz4sqVzLi0IUd06iMo0s1LyRiiXn63FIgHejnG1a7jcWFwW0lytYzon4mvUnFLj6G37QG5ysGzEeCt5coUuRv6axlzHpn+HbHmxBT44N7CCYPhOxWYXZfp5nNNv8v6US7PUn5pGYO/H7Ho2GPvx1QeXflzE9atn1ubtl/Oo0cbo6k2VnjO60GYau/SBQe8DvSdvvqMjDtbXuoJGUhVcWedcrwPiaUHfO2PDwPyY8cVKMJylRK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(396003)(376002)(346002)(1800799009)(186009)(451199024)(83380400001)(4744005)(2906002)(38100700002)(38070700005)(122000001)(33656002)(86362001)(55016003)(91956017)(9686003)(41300700001)(76116006)(54906003)(64756008)(66556008)(66946007)(66476007)(66446008)(7696005)(6506007)(316002)(6636002)(52536014)(6862004)(8676002)(4326008)(8936002)(478600001)(71200400001)(26005)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?F9iUuDo0LzBEIfK5cZ4JUVUy4pgDyqvTr8gh9Yb+pBqFsTO7pOR/GQRt8y?=
 =?iso-8859-1?Q?JddE7X5uckq6undiXpsfDAnYnp2qrvhOUh7Mn7EobsDimYGGySuvxrEw3g?=
 =?iso-8859-1?Q?Pq6x0gtRYs4tHCiP06cWa6ZuvLqjqfEtRi9xVs1DN0q6dzpDxe/MkYMHVD?=
 =?iso-8859-1?Q?f7JpNiWYzerHiro2t7jegQ4zoUv5aHRcDe3MK987MjFxrG9lGZtA7r++Jh?=
 =?iso-8859-1?Q?68Wy30WH8JqK9H0YSLWd5uD86K9SDBeJE9giAvv2g5xh0+DiD9+G5o1tJU?=
 =?iso-8859-1?Q?PWgJdZbFEiN4xiN0VQtYWMFgqMubOnUOxnzs3hKfu6u+vYcXlm7xbtP5q+?=
 =?iso-8859-1?Q?yey2pTKaWGYHq3MHuwSJUw6XMl2UpwzzEgeVWKmEevQEp+x8BHNBwk+OFu?=
 =?iso-8859-1?Q?inpPIttt+hICfGNc2wWbj8h3F8+fZY2B4iRS9vficla8rWlp4BKxx/kcwE?=
 =?iso-8859-1?Q?RWcTVp+Q/yuGI9ysyXTt9+VVud4Sux8Qlo8nl07gbDyf8zh4TIfhg7aQ2p?=
 =?iso-8859-1?Q?X4E3cff/Sj1JW7LsxUqx6odA3qF4HznkOAcfmDN/wx0MZUdOfoUcMlYif5?=
 =?iso-8859-1?Q?LE+ACmvo2HE9se/MnVLhEchJZAb512MmcZrOx3NpzHCjhE+786WLeAaRoL?=
 =?iso-8859-1?Q?Jqad/O+8lSLfbPEwNkIFF9Lf80SfWQGSpeyJUYHd6/kSeFuZLPxxaheU8u?=
 =?iso-8859-1?Q?lRRIN/2Ev/ZPAFOK5VOACR1Ke1YVEXABkjggcFj9QSklYYy1vdhnkTugQ2?=
 =?iso-8859-1?Q?1BvjaOZyaugHwRvEqr4GgYqEKxxycObft4wGSqh0Zfb1dCLsmVD2O8ZIVg?=
 =?iso-8859-1?Q?TNS5fE5CxkjX4Sfqy1qoPU/e39S0Hw/D9jucJ6lB9+flGJkbMQ8NxF+61j?=
 =?iso-8859-1?Q?gs2nS9TB5+XnkNsm1p+fuhNHRO7FRkNIvtE7ivbYrCsllLPEiVDkcfti6D?=
 =?iso-8859-1?Q?VFOZRtWaKyIEHNQREhxqfwcXyosmqldkKfPMHevkWDTVcnA+jRzRb96FBY?=
 =?iso-8859-1?Q?g3nket5BK1ZUVMCwSKwNm/XiTzjbdrqSpcA7spB4rPri9gq3VUvxGxwofD?=
 =?iso-8859-1?Q?xQFRtrnSkfuLWQkcM2Jmy96uPQrzuSzKP5g63SUnYAc3FI5rWcvOfqHF1H?=
 =?iso-8859-1?Q?/5eOAZbpet2Pd9UC01CXWfXqM56XlOb7UA5ULEuednupogl82oRR4ETUrp?=
 =?iso-8859-1?Q?PGz0ZkQ+LZxHgPeqNq8PnEpHUBctwTcUpqanCxIZA67VoTYVeuwRIoqi/6?=
 =?iso-8859-1?Q?pfT/Xy2+GI0RdpSgQKqLStGplzyBe3jJSxxVyC3gQWyM5GftJ/GAJFGcqA?=
 =?iso-8859-1?Q?VrI3cZmRmdS4Ps5kzH3B2uTTgCRMJ7sdpW8NdLhsT7xp+4pAdYZ6QksF5i?=
 =?iso-8859-1?Q?mYhQ1j2Yf3SaZ7MD+24cghuZOd+BiwqBbwndDi4FWQGNw7mgyTAU5e4sv8?=
 =?iso-8859-1?Q?8c0kMRpqP/QVXTGqXxxSwYhuGVHVAeMrKzC/i6Y1mpl8BDNg2n3m1D7Yoi?=
 =?iso-8859-1?Q?x3xHSnON7XnLXtCdQteREU/bE1gCDq64lQpvSEVkH/1JYCaZnf/QxX1qp7?=
 =?iso-8859-1?Q?MjddQZWQB8z+EJp1F2F6ic7Z9QpacGWZoOMl7+psjyCVNNRSkQQLPdBtKi?=
 =?iso-8859-1?Q?8f2KvazEhYOW8=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf7be8d-0195-4b51-35b7-08dba3e84c68
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2023 14:50:31.2650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m0YHQQ6XgmeFn/x8lxs87z0rbJwiRb9GjQrZrlDkVJZG/tB+eaQDnz+mfQxF6x1+HUfbnjw7iGU25TD5k1+Kvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4229
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> +     if (index =3D=3D VFIO_PCI_BAR2_REGION_INDEX) {=0A=
>> +             if (!nvdev->opregion) {=0A=
>> +                     nvdev->opregion =3D memremap(nvdev->hpa, nvdev->me=
m_length, MEMREMAP_WB);=0A=
>> +                     if (!nvdev->opregion)=0A=
>> +                             return -ENOMEM;=0A=
>> +             }=0A=
>=0A=
> [AW] Seems like this would be susceptible to concurrent accesses causing=
=0A=
> duplicate mappings.=0A=
>=0A=
> [JG] Needs some kind of locking on opregion=0A=
=0A=
Right, will add a new lock item in nvdev to control the access to opregion/=
memmap.=0A=
Please let me know if it is preferable to do memremap in open_device instea=
d of=0A=
read/write.=0A=
