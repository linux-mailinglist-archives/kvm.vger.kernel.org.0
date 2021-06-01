Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF71397615
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 17:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbhFAPJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 11:09:37 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:54914 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234227AbhFAPJf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 11:09:35 -0400
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 151F2Noq021206;
        Tue, 1 Jun 2021 08:07:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=SyNEDVJLptiUED/dSHVeY6blVSIAv1Vco+VmRDq3674=;
 b=Pv6/poknI3Q+uaVUTF2b175ExIH05WNzEtLG+6kLA/3b+8mKtXlqslPLul/q61lCgDts
 y0jkmtUjPwBuZuBxYZHmN55PhefqBLUiX4BJMoMMSdZqIvbxHqtmgl3jOECOQ6j1JFmv
 1wG+eQ+VnQXo6U4SlDalAnfOH4WPNLw+GIvQdnFYT3MhMniT96dtB837kI94Mk5EITPK
 5GjPGbi/6FE4VYV3q+aeUm6khHeK7nMPpIS1cDouAUPPzrfhVAlquAFYzPgb7epnc+Ua
 XoKLSA/oWixomkqeh3NN1edH8dt2t71N0Es7nNmodgRcwCtWCMKrmixnBUpSuOeph2CH hg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-002c1b01.pphosted.com with ESMTP id 38wn2kraex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Jun 2021 08:07:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jlct9PBif1JkIFiWNDSl39JLA4CyExDUspn/RcNXu9DyUJqJAK+7uEMHIP1J/yFqkEuiI8lMjwFienLCX6mOD2ESWe/uwFe1Es6WqWYLCgYVDpey/i/UGLhhraglfZOe+jHa7iaWpVY2mlBHW9DT/Sb2GWrn6qjhnVAndK9p5gBlOCwcbT4mkzhDx18YsZUuquuADqf2eej/RMBYKrKZJjLEhWU5ZqqTW6LLvopyVKT9uWlFiRgqYMGOx6/SClJx6MjSgyJa4fjkow9sRC7J7Oyvef/6fAsb0KO6NpCYa7jRf30Oz35D7P5AYKhP/ysEjiesbJSCJEsAncBCS4ZcJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SyNEDVJLptiUED/dSHVeY6blVSIAv1Vco+VmRDq3674=;
 b=FPxuLSbMJaEHvS4vzGKxt/jRnILTdqG6wvsL5s+6VRQD9zSdFrInNM3md+CDKxhbHCZMF5/Mj/sgTykn55fedhY6ol5RVtVhRxktxopnd89FcxJqEcMk+r5qATbUobostiUEKq8m/VnnckSepgTIZBNFG+tH6gcAeeoBJAmjkWnffskCkJIUdBUY9qduZZA8Vf4QGOpiUV4UsvEy2yWVPnP8jHDwlU8J97kRaTf0lt69X+XgPvPLGIuFxuOGrgn7G34pPlJCEbJoTAwthJhcoPyVsyDvrSuMQacUrEX7b3j4lzZkAj17gXzDjHrVlgyn5DR3AAqOB5zMXyd0jpx48Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CH0PR02MB7898.namprd02.prod.outlook.com (2603:10b6:610:113::5)
 by CH0PR02MB8194.namprd02.prod.outlook.com (2603:10b6:610:ff::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 1 Jun
 2021 15:07:50 +0000
Received: from CH0PR02MB7898.namprd02.prod.outlook.com
 ([fe80::a91d:ad88:5b1f:c981]) by CH0PR02MB7898.namprd02.prod.outlook.com
 ([fe80::a91d:ad88:5b1f:c981%7]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 15:07:50 +0000
From:   Thanos Makatos <thanos.makatos@nutanix.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "vfio-users@redhat.com" <vfio-users@redhat.com>,
        John Levon <john.levon@nutanix.com>,
        Swapnil Ingle <swapnil.ingle@nutanix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: semantics of VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP
Thread-Topic: semantics of VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP
Thread-Index: AddW7IO1+z3RMVhGQnuoufV73IrJRwAA+gCAAAHZb7A=
Date:   Tue, 1 Jun 2021 15:07:50 +0000
Message-ID: <CH0PR02MB7898A86F3A4720DCD07BFC8A8B3E9@CH0PR02MB7898.namprd02.prod.outlook.com>
References: <CH0PR02MB7898402DC183E37BF74FF8868B3E9@CH0PR02MB7898.namprd02.prod.outlook.com>
 <20210601081423.47689d7a.alex.williamson@redhat.com>
In-Reply-To: <20210601081423.47689d7a.alex.williamson@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [78.149.4.199]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef03eae3-b9cb-4cb5-5f1a-08d9250f05de
x-ms-traffictypediagnostic: CH0PR02MB8194:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH0PR02MB8194FD9FEA61A9579C6FEA6C8B3E9@CH0PR02MB8194.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:901;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1cKS7hAhqwvq77V2pFwv9NK/MpumYD5QVp0o0Wvpd6mpuzfxDzABeU3W76LzzOudQxHfmsAC3MitqWWp9otn6eepWrU4uIeMwaGDWjh7yxzjK7jOZmcgd6xPCSOqhJOgNxTgfgP8E8gFDymmZkoVcCcj5WjKXkmw5htPHhOI1zMcn7z505fuufLgLK1Ev1I5ySlKmPn5YH+YqH+2Trvbt17N7jXoAiDQXd0niMn2Mwme6rIR/d8/tHiSE7mDVhdw2UfbxNq7gxo1vACtX2jI8V22GvNR1yfNjnxf2vA6a1DSySn5a2E9h1qodNVLEaPz4zbrs1znRbFFMCQ7RecmpcsgPOL+jxyLX+UOZhC18HW/OmVoPV8TJB5BK5fcQ5FSdohFQlizZ6Ywiox2TPz6yjVvZpSVHpLTS1SvB0GYvoZd6guBxFQkcitVJ1XwEfMtCphgbEpr3LMrHG3pQcb4s8+hIM88uA3kM4H74Fa4M3XS/SVWshs0QCYP9J2PSGYT93nZj6KmL2Mx89V9SgJj3yaJAYiz0+VsmSxNvBHHquTjgiLr7LJP3x/UywVD0ic9u3itAZPPXAXiRzNVfYTh8JApPLX/Z80311JWcLzvJKFd5NBZ/TEU2QRwoGDkMiztwwufPoxBi9z9cZrmXTUUFNqNSmQ3UiGfhQdJS4Tsqnula6xBB0yGAbDDBVIpO6ntacfUDCmK8JwSpewzpjI8y+4GwNSjLXLicHlB9K9+O7znXecfOf0O3tHr2oCWtytEG7ppCPZpLMKXHTKx/BD+MA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB7898.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(366004)(136003)(376002)(478600001)(2906002)(4326008)(6506007)(44832011)(7116003)(71200400001)(38100700002)(55236004)(66446008)(66556008)(66476007)(76116006)(6916009)(316002)(8936002)(7696005)(55016002)(64756008)(83380400001)(52536014)(9686003)(26005)(5660300002)(122000001)(966005)(186003)(8676002)(53546011)(19627235002)(86362001)(66946007)(54906003)(33656002)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uTAj2IAGeLmLPoZTJQZXM7fW6Ya10ohVsCh4NoNjx5CVty9NBI/aP1azskdL?=
 =?us-ascii?Q?Ozf/n72iTUqVL/6vfaDMfUD1L2L9NXC+FkhTeWh/sCnL/YtsCTZfqR+bD4PD?=
 =?us-ascii?Q?1kJ1wtJRWdYJgVrwt+sHfoNQU9GqCVbwyv/wPfMjfALtiqRUme8dZE1MATB4?=
 =?us-ascii?Q?Y10h4Azk5dlltSAbh5bvvQ/H+ftMCEt3b28L64+EYcJ/2uP9aeaJhAzFeXeD?=
 =?us-ascii?Q?RPbjxrybL9C8Isqs9MxxaX53CNDcdO0ROu7orwFzzAfPckt0bkbH/thnTvD6?=
 =?us-ascii?Q?RedsYbdf1ywJjNDV1YXk0Xz7UJrAswMT3izooLkRV6J1oxXaHEHePQpgAL9t?=
 =?us-ascii?Q?qsxEIzZ2AcZg/cGaxSx0fV7pC4oHbUIGc/+fwhD1si0Ht9aLx0z9Sl0ERw/8?=
 =?us-ascii?Q?hnisNbgQehSuDUOhXRF9PPCFJ2FS9PCrt0njz1FUZ3coeMKH4WHfr90AhmTH?=
 =?us-ascii?Q?28NAT+LDm8cZFYRbLdRTZ9yO/sQCJ2R1gFQM1abh1yb+VVFjuX+/bS4dbyCe?=
 =?us-ascii?Q?5B5V1rxSOX6ozRfMVgRMtqCG2aqzaTH5EvrIyw09+rTqK197kLW/puB5160a?=
 =?us-ascii?Q?1p/TY3njcQqcyFa1bfF+bh58Ofdj3Sqhdtx7JnOyn5VDV9ETYnzarnjrsqGQ?=
 =?us-ascii?Q?HsafbEDnGUSs8NLQxQGjoAj+yfB0XUc6usQADYbkRyU623GG5bt5ZPBrDztS?=
 =?us-ascii?Q?OHaH0NCOjxDV71+pQEO4yvlNjQpYYLcjYLqX35lE4p8ExqL8dkEC5tWlTCuB?=
 =?us-ascii?Q?axNHsFYj1FGbCsf9lxuHkxX+7yMMDe/aXK8p3CpJVnBpsIbPj7RqdEn+pEzf?=
 =?us-ascii?Q?Q26ozaGZyZvkOb/y+vha1oUPoKEE02ty3Ofgcz/7UwcLLlMXVvm+YPfUi/Yj?=
 =?us-ascii?Q?pitwev93Af+AThMXKAg1Wj55t1pGdSgNqtHKnEkQMDGEL8nUx1PF1L/UvJZ7?=
 =?us-ascii?Q?Y5uMuUN/+8UPWN1XD7KM7jsacl5w2OkjaNXkHw3G?=
x-ms-exchange-antispam-messagedata-1: PqdnIJmdSKCCDdPZUobDumeUJMTZzSE6YrTfMQR5iUaW5TYne4OisnSmHoxdUzw4waogAZluQx6ThuiSu2trs45VRlniz6KZs57qgPq65LT79QpRh/EvIlO39664cOOhnJ737yf9LJr5sEQaBiomIo7XqkrLJOdicclXhXgzkjgaEjgF5nbLtkWBFz5+tPW8ep3c1zxwmFngSCF41gY5fVUCw6uh9AkojLCl4s89nD3mZ4KLd7StUgCZgWblzpjJbzWOHPrSTPiOiUwLNsWd7MwkTJSAS6t/Iv3i7wQhYbaPA7xMEFL+kVTV3iR8nsCUahE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB7898.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef03eae3-b9cb-4cb5-5f1a-08d9250f05de
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2021 15:07:50.1707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XqmtvNS3cC7yhNJ5NKgaoaZpfgon5w54WNjzyxpJ3HRBYBZm2c+hZiIrnqgHqYj8WcFsXqJFuCS8+MKYerBnP8XEIP5rrSraB/tUFhUQcUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8194
X-Proofpoint-GUID: rpoYqLPuszX2dWYk7zCvoY6ILrj_0SKK
X-Proofpoint-ORIG-GUID: rpoYqLPuszX2dWYk7zCvoY6ILrj_0SKK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-01_07:2021-06-01,2021-06-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: 01 June 2021 15:14
> To: Thanos Makatos <thanos.makatos@nutanix.com>
> Cc: vfio-users@redhat.com; John Levon <john.levon@nutanix.com>; Swapnil
> Ingle <swapnil.ingle@nutanix.com>; linux-kernel@vger.kernel.org;
> kvm@vger.kernel.org
> Subject: Re: semantics of VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP
>=20
> On Tue, 1 Jun 2021 13:48:22 +0000
> Thanos Makatos <thanos.makatos@nutanix.com> wrote:
>=20
> > (sending here as I can't find a relevant list in
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__vger.kernel.org_v=
g
> > er-
> 2Dlists.html&d=3DDwICAg&c=3Ds883GpUCOChKOHiocYtGcg&r=3DXTpYsh5Ps2zJvtw
> 6og
> >
> tti46atk736SI4vgsJiUKIyDE&m=3DE6G0G_Z_M2cIQvruwQk6NRrha3NkW8gdO11
> pPUm8vg
> > k&s=3D-7KcTuEYFphAcU1aya0t_Jh4aP9jVPq2N2YxVu9Lu84&e=3D )
>=20
> $ ./scripts/get_maintainer.pl include/uapi/linux/vfio.h Alex Williamson
> <alex.williamson@redhat.com> (maintainer:VFIO DRIVER) Cornelia Huck
> <cohuck@redhat.com> (reviewer:VFIO DRIVER) kvm@vger.kernel.org (open
> list:VFIO DRIVER) linux-kernel@vger.kernel.org (open list)
>=20
> > I'm trying to understand the semantics of
> > VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP. My (very rough)
> understanding
> > so far is that once a page gets pinned then it's considered dirty and
> > if the page is still pinned then it remains dirty even after we're
> > done serving VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP. Is my
> > understanding correct?
>=20
> This is the current type1 implementation, but the semantics only require =
that
> a page is reported dirty if it's actually been written.
> Without support for tracking DMA writes, we assume that any page
> accessible to the device is constantly dirty.  This will be refined over =
time as
> software and hardware support improves, but we currently error on the sid=
e
> of assuming all pinned pages are always dirty.
> Thanks,=09

Makes sense, thanks.

>=20
> Alex

