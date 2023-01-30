Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A7A680DAE
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 13:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbjA3MbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 07:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236458AbjA3MbW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 07:31:22 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4546B2685F;
        Mon, 30 Jan 2023 04:31:21 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30U7wH3n003313;
        Mon, 30 Jan 2023 04:31:16 -0800
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nd442he2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Jan 2023 04:31:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YP0QPjw4DkiBIopX+2znZxB+S9Dfj0k/I4o/AtBBshZC8Ax1yzZCMqQg4iDoF674XlafcjnAAwjd2r9ghwLZFQBBVI7iveyc8gGVQG8WpmfUotnOBzMkxaEgj8AsdffV8qTrONO8ML4FyrusxDnKmJOI644zSjm4u8D1MG6YX9nnMMq67AdDr21qCjJudso+09pVyo9t5nOw6S+fkf2/Ej3gZdU6usBYraagnXqjMPGIRfwcZuaiavfVCcOqsOQgHmw9OI37RTobQ0+A5xScXN6xIxtaDFt0+PABY6dqeFbb63vT22sdYzycGm9/aJ8QZST1BHj8hqsvpgDYj+bDcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IKgITQXr3rBO7b/YvLNyh8qnaz2+vjYL8abkJXEJJpw=;
 b=PupoAo7PoiVI0RZR1xVamD1RAZ+m5703R8KVigYJtmOPQQqiY5NvFUtn7dJH50tHb5O5wj3sS4XY/mI6h6a8tQrECdWFBhQjdAJovCgRKjSE2hFNuhkwgPlBGh7Pu8pofRbYeps2cpjjCE0ifmyKlgUQ6Z0HFWA2ThzcwtPEX/h0PnlMVLk8Z0gyjBYMrLhKPemicRXtpTh45V9MnJXeo1SWIsQ1BNDzwnzjB+MQ8he8t9yZvOLhMCa9RoJebajVYXc9C+SvI4077usn5B3vbB4rX2cbCdyONhZhCM7G25C8B7gpA7k48xcbtRiT3nEmVgVDZWGzXbBleov3/5CXnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKgITQXr3rBO7b/YvLNyh8qnaz2+vjYL8abkJXEJJpw=;
 b=aCadRNGzFxtuXY9EvseTlJ9avUXglN9biiTYJWA1R8xhaWFFNrJT6PQn1/zoDCGiRTGa2DHJuJ0aVqXmfIdXccD4r9W0+X9DijbH18Wd9/vnGRVTpc/L2/24sAivFNGoyyGHh3mNJQQlxt2nTzZxUZHuMiYGBtrHkO3B9b9Bo0I=
Received: from DM4PR18MB4368.namprd18.prod.outlook.com (2603:10b6:5:39d::6) by
 SJ0PR18MB4493.namprd18.prod.outlook.com (2603:10b6:a03:3bb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 12:31:12 +0000
Received: from DM4PR18MB4368.namprd18.prod.outlook.com
 ([fe80::3117:f51c:37c2:fa05]) by DM4PR18MB4368.namprd18.prod.outlook.com
 ([fe80::3117:f51c:37c2:fa05%9]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 12:31:11 +0000
From:   Tomasz Duszynski <tduszynski@marvell.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "open list:VFIO PLATFORM DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
CC:     Jerin Jacob Kollanukkaran <jerinj@marvell.com>
Subject: RE: [PATCH] vfio: platform: ignore missing reset if disabled at
 module init
Thread-Topic: [PATCH] vfio: platform: ignore missing reset if disabled at
 module init
Thread-Index: AQHZMNewpePFVSldhUyVc0kESdCwdq62slYAgAA5LyA=
Date:   Mon, 30 Jan 2023 12:31:11 +0000
Message-ID: <DM4PR18MB43687D458F4EE8EEABBB3A24D2D39@DM4PR18MB4368.namprd18.prod.outlook.com>
References: <20230125161115.1356233-1-tduszynski@marvell.com>
 <BN9PR11MB527630B903EC14BC61351C668CD39@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527630B903EC14BC61351C668CD39@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR18MB4368:EE_|SJ0PR18MB4493:EE_
x-ms-office365-filtering-correlation-id: e41dde4e-588a-4563-7275-08db02bddf08
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QXfWR6aW/6YRz52mdv8zhO4lfJgbgZzH4F3C+UT87SkRfZz1JqnQ/Ae5z4pLfukud/Ycud1VBWNdgyeyUrt6vOBT2XJOa95QWReh7G/TAiYYqHMP/UccIZeMxy1+gS6UXh8opNpc8dm1E2OwBYtBMvH7GKusjFNudpBSMF8EzWnZ8OxhqOmp1DcuuhYjFmGn+XzVEFKmGRdQeg6yzKOIQYb72irQQuYMP+5Shbhn86EWdQn0q8IYNm6jlRFsWpDT+ZdlGMury6o39sY4A2ifEbbCDEmFr1ZLPuGEZr9oVIaG5EM/mWrvRZEL0imTY0nPNiZ8/2maybhs+rbKMQlpwH65ejcb8Pi0xSGa6ONY9XAmtx2iAs/qCRx0NiUuvl6Q5ReiBQeHCTGxFKRGZaLHsoklSSRLdJpbjTPezagCfOun1jF7hGbHsEbvKB8Hu1nWc1hyCJrzVnf3A2mN+oZlkuHIzy8cLRQeB3yDqEeA7MjNfqi2XsXxmXiNTUIk8WoADPUbnWwavjy8Gfy397x+ZmqFMD72A74Q+aot718WnuJj/qR8sn4gd2lvFl0mML4hi8KD0M5yXZ0nUkUCujaNNhCA0qjyzdjqax9QvHUd07oAFByE/m96AFHHJtaxxVgB3iS6UVZhFtb2mATwritJcdWcv6cvM4HdPVXLVIGib6FMDev6Fg3O6xQ2MtNS7RlvS8O7uk0pKHqLicwRjUawpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR18MB4368.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199018)(86362001)(33656002)(38070700005)(122000001)(38100700002)(5660300002)(8936002)(52536014)(66946007)(66476007)(110136005)(316002)(66446008)(76116006)(64756008)(4326008)(8676002)(66556008)(55016003)(2906002)(4744005)(83380400001)(7696005)(478600001)(41300700001)(71200400001)(26005)(6506007)(186003)(9686003)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GuLdr7/o3j8QNlrWLaJUq36ByR7JAgh+0iWYwq/yaRPMJGr17OIIyfdlnwN7?=
 =?us-ascii?Q?pBO6gNm1rEZw1Y1qKacQ+Xplz4E0hV7S5MGN7N1w14JeQ3XeRiUKochhVxre?=
 =?us-ascii?Q?A+RodJAeuz3tcZJkTYRli7fJGefYLd8+G0SvxsN6tZYGuvMlqND1MZj6A5E0?=
 =?us-ascii?Q?Zifr6B4GCCnFe85C8xCFBWU6wGeBJZND77mDHho0C0EZMfrdduTF6U+mJPRP?=
 =?us-ascii?Q?Q2A1ic6Z4/QftnUb2ZqbXI79MmoiHN+WLf0Mu0BtwYvSEdDDR1E4N3hQpUeT?=
 =?us-ascii?Q?OXTABGlaQcs/S4LK5CGoUk0hjtX7e4f7t4i5lyd9vANEaHmVqWt9AFkDKYKR?=
 =?us-ascii?Q?eUHnTVgS+EAqOhozQkrJPB4c6naygAywdKgGbpONUnyPDuuD5I4p55JARU+n?=
 =?us-ascii?Q?+q2uvnmPMnLBT6mRmxah6zQiAMy58/rLTqSBflUMPchnOkm28DjVGYUyr0Gu?=
 =?us-ascii?Q?qPT0SCoSmg8OVfUV9XXNwsodtLqwzn7mcnjhCApGlK4l4KaWCf9ZDX4vaqSi?=
 =?us-ascii?Q?XmLZimA/+lobeEvKdPkyAzO+Mc2xbXCUaEIhIbGMZQp5xi7bhAXSr5itNpY+?=
 =?us-ascii?Q?NdrotZsVe543UtZeIOuc6Pgixx0M87wfIibnRtfMpbBe5h6X6vZuX3d577fV?=
 =?us-ascii?Q?J/sW74KmXw3f8qAz0OHwMTc13dUE/o3dX+sNotl6j/AQDlTeXsXBViZhkMuH?=
 =?us-ascii?Q?Tbo6WnYyyGoqksPj6YYou0YYnLwNWPQ71Ch3AHCe1Ue7vNnOnz2d6dbt15bm?=
 =?us-ascii?Q?b1D7vhEKhvAULDlcKQhGhZE4dLsiuByMdLMXR3J3wIiRYYFlN0DuRifgdFny?=
 =?us-ascii?Q?46g5g+/Xgq2FnhxWICURY3h75sbwMwd1IDZiJKpBFAbyOkZEHxVtEzZjL+/1?=
 =?us-ascii?Q?b+C1U1DlZyUfCpbOsZnzPF8LNKe6lQuXCFarxYQxU4AamOsYSCBfNKyp42Hp?=
 =?us-ascii?Q?PuT208ZKpN+X5O+lXgkpmv3vEWVcsPbiSmBgbYjWIjydtT3JfOcSVxMYfaqo?=
 =?us-ascii?Q?OcqF+KqznptrNO7xcCkgBvmQ1F1mQEUvhrgtTfElEpukQbakLhnXortVyDRf?=
 =?us-ascii?Q?oVoiyaBCTfCiVsIBgGeS9AfCGR2sscGRMzpdJv6zvku62wT83RD92iVWOAfs?=
 =?us-ascii?Q?ldUXSx61BwkSncfmIGsU0AOOkqxSLUSVoxKrMuJxqNQg0i+hs/N86UUJFhGC?=
 =?us-ascii?Q?ZSZ53hjzNkKIt4Is7KKrxJKd1y1NzJixIr3DyA3jBcv8rxbOJgj5h8X2QQyZ?=
 =?us-ascii?Q?p8UMdukM+fzYMBTmK1AGX6lfTA2oY9dqrcYa54sKFmwy5mTychRZdEGFmX4j?=
 =?us-ascii?Q?2jWZH/ml27NnZe5AdQr/7m5Jis7w8/Ka08l6UUQpHoV2LLJm0QzUxGMXSOQ4?=
 =?us-ascii?Q?C9e16jURVG7umvTqzDDe68Jlq1ib97Api8YsVuYOEW8UfxOER1m6LluoRjmd?=
 =?us-ascii?Q?F+7G8cDAvWrUxBNkcX2xb518pLyB8CfoPN/vMMVRAYwP9+Uj0LaNw+Md/fcO?=
 =?us-ascii?Q?DVxm5L7H9Fz68y1QIx1cW6iuE2eqR04ayp17xIVnCG35rwDe8H0NZAdRit4O?=
 =?us-ascii?Q?6v1BdPJ0ajupYqT60alsTqGvE2Jtr1VGUObq+iE0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR18MB4368.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e41dde4e-588a-4563-7275-08db02bddf08
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 12:31:11.6379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4xh/l91C/IiGGuZbgYBfPAfhCX4ipkxy/KMGGhyM8QxJAq81oGk408v/lttwCbVeui6RKbYj0D1dXxqx/pek8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB4493
X-Proofpoint-GUID: wpcsnUgce4nEsHELBuiLqNvI8SctJ87e
X-Proofpoint-ORIG-GUID: wpcsnUgce4nEsHELBuiLqNvI8SctJ87e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-30_10,2023-01-30_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>-----Original Message-----
>From: Tian, Kevin <kevin.tian@intel.com>
>Sent: Monday, January 30, 2023 10:06 AM
>To: Tomasz Duszynski <tduszynski@marvell.com>; Eric Auger <eric.auger@redh=
at.com>; Alex Williamson
><alex.williamson@redhat.com>; Cornelia Huck <cohuck@redhat.com>; Jason Gun=
thorpe <jgg@ziepe.ca>;
>open list:VFIO PLATFORM DRIVER <kvm@vger.kernel.org>; open list <linux-ker=
nel@vger.kernel.org>
>Cc: Jerin Jacob Kollanukkaran <jerinj@marvell.com>
>Subject: [EXT] RE: [PATCH] vfio: platform: ignore missing reset if disable=
d at module init
>
>External Email
>
>----------------------------------------------------------------------
>> From: Tomasz Duszynski <tduszynski@marvell.com>
>> Sent: Thursday, January 26, 2023 12:11 AM @@ -653,7 +653,8 @@ int
>> vfio_platform_init_common(struct vfio_platform_device *vdev)
>>  	if (ret && vdev->reset_required)
>>  		dev_err(dev, "No reset function found for device %s\n",
>>  			vdev->name);
>> -	return ret;
>> +
>> +	return vdev->reset_required ? ret : 0;
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_platform_init_common);
>
>It reads slightly better to me as below:
>
>	if (ret & vdev->reset_required) {
>		dev_err(...);
>		return ret;
>	}
>
>	return 0;

Sure no problem.=20
