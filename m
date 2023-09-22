Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76BE7AB212
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 14:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjIVMZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 08:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjIVMZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 08:25:14 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC0992
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 05:25:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7LfPeWjf1wJ2jfYjgW/74s4jd5wgkmItV+fJC08QG0C3wYmZMAUPQRMpy7YFtBI4XkIRvgfdyHN5HVEt77pgrFnRFPH1KU8x+oMVbM/jEyuZuqSJuxqqbYCYBL5xB/YY0nwJmsHxl4hwpqVQ6peqhrJ6i8rbGMQwNo0uEYl3fDmIa43BcYGY2LDLfElh5oMoQgqYOg4GwBaoUa2JgsvcTGgps8B2JmIVlrwtmqIbbWWYpZE3wLWu0pZuT5OQi5gNKebYeYj42lGm5jf0xsZ8BOVA94/2eQ7kqOFd0dwwfGZ7ay2YVVIF2g78+rQg9I8Z1KnHVNcKhLF90wupUGfNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9rjE86fzY2mn57HR3pxGcea6nWWSdFv0dQTjt2GySBY=;
 b=VvkFQnZrRN+Db3XzN/iJrRA8QccvTkmelm8DdZ0ZT8YXbqDreEApEn69kW9u2eEOc18RlQo4vKnQYRUl8iHvy/6p1lzu0NQnR3lBkasf7T9fxfrLKcp3H4xuvQ6MsPAsXW7bcBU/FP5D7VRFgDDAZCay0hZtSSIpWVKlKiTfQL8FDEdJCYAL1Xdd+oldUx8mtiIjStYy6ycVujW1f8+KG+ZCndph6RbqcIlPilOrAyn4RdEQd2SL7sHXjfz8tP9Vfoh9nnv6eIlK28JSLyM7S0Pary6UKu/5mYIBfSBfdNQ2KT3oW8QaBvVXY471yxPsoGts3ZwTlMA47C2pW15hlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9rjE86fzY2mn57HR3pxGcea6nWWSdFv0dQTjt2GySBY=;
 b=GUgmIk2dA0xQgS0D1UOsACimUl8z0nHamang7P9ooMN8kzSkX2ojUoDvphvDr6qiEL+yfWuH/Vx6Kxiq/nVbvn8PxpmXCFfW/JHZKSbBbhsoac0c7hm1qctCjnFh1o2Yf44rm4NNM03eNDZ2fm70SxSzW07j83E/JNSWPqAJAOC6vuaY5VegSs/2H7B7KITWiwWYt9eNxg5sKo1UP6S/ES7IzW42bg0L7Y9bYTr+m1hcwMWgxasi55f//s2gPmpfNPxBE17KOOCr1+xI69Wwst5knOOyJhdqepTpO30k3ox/H1PA+DJchkuTS6oU7BNAo2oYvr5pJg/921tnjEUAAA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by CY5PR12MB6058.namprd12.prod.outlook.com (2603:10b6:930:2d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Fri, 22 Sep
 2023 12:25:07 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::4002:4762:330c:a199]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::4002:4762:330c:a199%7]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 12:25:06 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jason Wang <jasowang@redhat.com>
CC:     "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: RE: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Topic: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Index: AQHZ7IkPl5ENqOgMC0yEzkOHANq/CLAlfIYAgAACZQCAAAJ1AIAAAaqAgAAD/QCAAAaKAIAAAwkAgAAF2ICAABWjgIAABYGAgAAGVYCAAHFrgIAAnJQAgAAAJ7A=
Date:   Fri, 22 Sep 2023 12:25:06 +0000
Message-ID: <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com>
 <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com>
In-Reply-To: <20230922122246.GN13733@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|CY5PR12MB6058:EE_
x-ms-office365-filtering-correlation-id: 9be77deb-9323-42e3-1c0b-08dbbb66f4a0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V+mvdPkKg4DEkaWa718rVw93zWs+T8782j9IujSjgf2y2QYWvOXXW4bshLjp/vArzKCyiC3v909HZFBKppgcHuOxfWjbEhuvrMICWy2ZB9EPvgxvYRB94AkZuZAJi1y5/kktzgHlGrg//Pt4V2M5TwVap3eBX8lfR69djMOrWxyaqacJe1kiUw3d0ixsBiGddqZHh0AqFwe+/qc/IBeqw8e4WWdRFwIhqS1wDDpv/4k90RlikGfDSGbWcA1RsYsnvsl6+Pze0b0Ojzvq4dzvg+pDT6Hn217jOdjPdqNGI73vDBIZbNr/VqN2AHIEMWwcmJYOkbuecaflKJP8tJjm5CJbPhWUfGEOFQH18m7qeCXkc1b06VHV4gZOVJFRtUptnSFowkbYKCsQdjbroXhdDCcRwmJTw7C0gWj95hvNx1iW2v+VXdTas9a/k6jrMKO9xgu8PI/USoKWagp/IiDyj0c+iW8ogsx31r7ifZmGwpol2p4TWd+q9mkPMpzGH9r8SNNynaIdtMlmfXoPOV6/S4ZTX5PVu57owSVQTOkCeW1J/N9gghf9rXMbkEEBBu5zZdC/A5AUSfQzbgziNP2ilqX5JWbzFHYo2o1D3xNmkOZPWYl+GjTyEFvQLJtWCvSw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(366004)(376002)(396003)(136003)(186009)(1800799009)(451199024)(122000001)(38100700002)(38070700005)(33656002)(86362001)(55016003)(478600001)(2906002)(71200400001)(54906003)(110136005)(4744005)(66556008)(66476007)(66446008)(76116006)(66946007)(9686003)(64756008)(6506007)(7696005)(8936002)(8676002)(4326008)(5660300002)(52536014)(316002)(41300700001)(26005)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xAU2SfV23jzNSxo6eJKwj+H3n0nPDGklmpivvecpNzUS6UR6LTK51lrgnFYX?=
 =?us-ascii?Q?aIdkRg47z2bGFgQTQdMbwUwdfFLnUdf6HZsPUdzI1VtbqEhdM23oDoqzS7/6?=
 =?us-ascii?Q?nyV+vxQYwRCBZyJdxpbZ4a16rm11NQ3xftB6N+gOxaCTMw8+1mg8Uu/u6lDC?=
 =?us-ascii?Q?G6EBYfd1z9uZGoNMf0s7zM3BSnb1wYcgSkxwWv5fK3+e+0tRY3xapU+2vsiv?=
 =?us-ascii?Q?msi1AvoAG+4pgEBcvX8V3a14rYwSDo/vlXjMuXT7x8GLF9vaxbBxnYVspDFt?=
 =?us-ascii?Q?jSYoiRygLVNePgVic0lkrx4KVDAwBh3ysca8xD5uUT1jrGmycdXcQy9o5oLu?=
 =?us-ascii?Q?WU3kmnNCn+6drZXe0BlryYrCFyhxOMd3Du1RcaRCiDGQLPCYVFKSxuk0a3s3?=
 =?us-ascii?Q?yqmjd3/iyy4k/Jpc4RRpsBjrlg8+dDcP11Wo57E+w8TWecqjeUyJ9wagb8NA?=
 =?us-ascii?Q?hgCEj1GLjo+I64QUBeFsqVUOSPmWVWXENihA8/6BPCxRuaKRZT9MzVFPgVL4?=
 =?us-ascii?Q?Yl9wouFp3rTABBwrfThfr+0UxmOpMIFjy/qbdKrKiuNHsj1hk8IDohvEMxyC?=
 =?us-ascii?Q?77xGfLCD+4sQq6ge0sTMPgiKgfYRpa8p1if6f05sFMNEqGHF9lkFDbkDIGHW?=
 =?us-ascii?Q?TaXneN8nAk29WbImug0UGWYT71qrqO1bswm3d+SpvX2WnKVFpR/bwkmaOtTj?=
 =?us-ascii?Q?mr9WT/vnOw3PnLo415+OlbfV7VvUUD19Yei4WqUtgVbhpAw0cxTPZm99d36d?=
 =?us-ascii?Q?jo9Jg7TahqcBdiViAUgEHOo/i2x83NYQxe9gH+naMIyPT8Z+hyWfn4rGUfRC?=
 =?us-ascii?Q?tc6+wOVNfV6DnCiv8JCGmvr8cLN9yiSht7hhUTQ19fxRqd4x5qF6XMOky1qN?=
 =?us-ascii?Q?d8LuqXM5nZ+14zkLIenKzB+GsIQwcYToaRcybuPaNUXV2rDEJ6vVy+c9apG/?=
 =?us-ascii?Q?459AJDMk9dvMnkKE6yxo54XEu7Wg1lesW9GhhqhzEHcBmPV3Ehxq3TzmybyV?=
 =?us-ascii?Q?M/F14WTc5Oa87ZVT9lIVN6vQQN7e7L+65Sp45nSGoyJqri4PvYKWRAO54a1T?=
 =?us-ascii?Q?5z5ARftFGDTqYr1m3/eJxq8UdV8nmJ2QueVB6fvZWuPlxGtBFrIRskWM7ojl?=
 =?us-ascii?Q?rv/jyv3eR/x/o8bCvbB0uHrMosaeh1uQEy4F7oyXvW1/Gw74FVlAHXixb3DY?=
 =?us-ascii?Q?8w1bd0xXUofUvlr93sp8fm8XL/cwb8u03oHiXsgZGsgGalbBLw+876K3mAKs?=
 =?us-ascii?Q?Ao823DBgvTR7Pb4FchxWjAJUMgEHO5uhe6EXz2XSpjNUmsv69FmtrAq99Fga?=
 =?us-ascii?Q?38yUVkjUoj8Rg4ZNv0TPLe7HOV/8ewZ3IAGrgiqSwDQABRqj40h3oitc4RMU?=
 =?us-ascii?Q?bi5xOncErddq4OW/oJdKUwwDMEEBCiSJoLOnDSLolqjyVKqnvlZbMBn/MCHG?=
 =?us-ascii?Q?9t2Ojsz+SIjpFGkvt18VokDkvPoTN+VBPK8ibDTGYYtN09LrN+wJUFZdrWD+?=
 =?us-ascii?Q?tpEFvKOKfg0wsk9hxbEJVi0mDE7+fJvn4sRpIgHHnIIAQJQQ8mt4wWJDnU3G?=
 =?us-ascii?Q?M5N4qbfFQt84r+gkARA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be77deb-9323-42e3-1c0b-08dbbb66f4a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2023 12:25:06.8106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yT2QzZY/8nLOhSgDAhqiQ+NOjvzVvd/h+rD2pABLIlPd+p+qhGoBsh/ZWyGJy61B0Fmk4Dvvtv/vE9kLtg8JfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6058
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, September 22, 2023 5:53 PM


> > And what's more, using MMIO BAR0 then it can work for legacy.
>=20
> Oh? How? Our team didn't think so.

It does not. It was already discussed.
The device reset in legacy is not synchronous.
The drivers do not wait for reset to complete; it was written for the sw ba=
ckend.
Hence MMIO BAR0 is not the best option in real implementations.
