Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749B9406D63
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 16:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhIJOPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 10:15:38 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1284 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233706AbhIJOPh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Sep 2021 10:15:37 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18AE7fdM023952;
        Fri, 10 Sep 2021 14:14:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ZWHue2ooirFJM2/u+XGtNgseDPA9Yr4H9TMEzJ9M34M=;
 b=WlcjXfoSrujjXleyeOE0i8o7QUjbTti1Jbp6DBY55Iwhv/7zv89QsprkuouV5ZgA4/CI
 NHRSdxDhiu59Q0KPtyOJrYjnTM7cxM9VmjwmajQFH65Z8vEEeryfLuy0Jps97wMgrdBh
 g/iB37EJLt0/YdxcQCXtHj8WJl6tAAlzMi07nA9OdE/UQ4RGT90CmUOekK/DHKpOykur
 DfDHtJzdpPopMiqJQcaonTB+vvQ+bzkXw8Hwj21vknDeMTsI3VXrkWqXB4IXfN8PEdMf
 0YEkzGw0m/ubDg1RC/7aVZ7NY/fUZ6+T3UE4rDxwmfjXTZFnCrid60DluRtECRymdsJG Hw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ZWHue2ooirFJM2/u+XGtNgseDPA9Yr4H9TMEzJ9M34M=;
 b=XrFAJ8eZd48pXAYowKmcf5BGdhUqDzSDvWmk3HLRPmi5C/KcAsNsRHqrKY8H/nd1cRcB
 hdo3oWdFuw4m0avodB70/bqCz0ZF5Fm3IYSAyo8uwdbkaZzlYFscyUQzYh8v4bDkVqa2
 W+lJ9PFgwjlHQr6URoJjSgHUOX1e8omp8cz5Nl0v4AWw9jqkVCfeew77jUVL6ziT2B3T
 8W3kUV3O6R0u7zNeTqoMD0SgHgP0xdMN3BUMgOrJzWqFKQ33ExoQVGZNkYcyBSLHi3VM
 SvnIapCqTF+tjvZHKFPDTmkbiQmdxBz8ycAmZAutlTVy/orOB7MycTu4WfsRLitKWrZx AQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aytfka0hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 14:14:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18AEEL42124656;
        Fri, 10 Sep 2021 14:14:21 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3020.oracle.com with ESMTP id 3aytfycf0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 14:14:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmUUuhDv0SsZs1yQOzE+5YeHADTNtkFqX1nwyOAG+ZGXFl8ArDhE0hgAeepHKqOQ8O2YgsWeHlhiwcfgvT9cilwMoLigfvcu1TsUMbdyGAU0vJhf4pxFP94EB3F73BhhCS/CETxv9TYTPsTqHJwgZz9REDkg43IWfwSra0kThcVng76CX6S7Tw1OgJQC2z3XMSuUsXPKim+ISOuF3VFcr1+iRrQHLaGfhFJ3P1NPL3utEdVt2lAj92SWIAp4e+n/V8TPlFdC1I5knPw5IQZtUy6Rv6oCJu39CITurb9z0pqSB1iicI2dOqfriOn4+Hqj3fbaL8lpR5sX5A4g5HI2Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ZWHue2ooirFJM2/u+XGtNgseDPA9Yr4H9TMEzJ9M34M=;
 b=laxtbs7RV5ZI3SkbbfBGEF0p2Ucg+fndDS/dRnOX0PnIb1x4zqdJ9XXuXs41bI/rOmpM8/adfzn7VC5FyVxwgjixF6JBzmAR4AqPwFnTb4F+AvkWuacAEx8fPtAIOl5COO8UrFoeLdP014by2z2dJAx3nvJGfj4xsniHrv7vLUq43PdxcVAqFeBHqSt9GtAntVjzJ1BvEDdTNPaP9fvdoPx/BkF/OLdqDZQnhXMHo9X43hAbMzcZ7/SmFAVGex+AxsbBVoCvbmHUnR2j4nblLArTeVdNRsjbK4s2le/d9sjlIGN8qvjwpZYnfZvyrsuFHJUOlmf0alXWQlNi/Rrfnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWHue2ooirFJM2/u+XGtNgseDPA9Yr4H9TMEzJ9M34M=;
 b=PXri9fIhNNV5eV0KrlX6VEMmFvjKsXb8e2oz3Ai+uJRXOLrJc4AkR42Oz4Jw2vS2Nnj4wrVzXtHackAGVhV1sEZ1wlS95yLtEb09HJGva6KAOSSvHBnZa7xdfsOFRUu/nsX79RCybXIPNgwSPa32XBNn903WGxoxagPNvUYc5kU=
Received: from DM6PR10MB4380.namprd10.prod.outlook.com (2603:10b6:5:223::19)
 by DM6PR10MB3260.namprd10.prod.outlook.com (2603:10b6:5:1ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Fri, 10 Sep
 2021 14:14:12 +0000
Received: from DM6PR10MB4380.namprd10.prod.outlook.com
 ([fe80::f4b1:d890:7745:30a3]) by DM6PR10MB4380.namprd10.prod.outlook.com
 ([fe80::f4b1:d890:7745:30a3%5]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 14:14:12 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     David Hildenbrand <david@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH RFC 5/9] s390/uv: fully validate the VMA before calling
 follow_page()
Thread-Topic: [PATCH RFC 5/9] s390/uv: fully validate the VMA before calling
 follow_page()
Thread-Index: AQHXpYuSHG/JrbFz7UmTxzxyXzbggKudUSEA
Date:   Fri, 10 Sep 2021 14:14:12 +0000
Message-ID: <20210910141404.fzgxymamjnfnvskf@revolver>
References: <20210909145945.12192-1-david@redhat.com>
 <20210909145945.12192-6-david@redhat.com>
In-Reply-To: <20210909145945.12192-6-david@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f79a503-e952-43ae-8bd1-08d9746543ba
x-ms-traffictypediagnostic: DM6PR10MB3260:
x-microsoft-antispam-prvs: <DM6PR10MB3260BE70B8C0E3E40EEA0D18FDD69@DM6PR10MB3260.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:187;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C5vC+cysjgzxRYqs+9PnAP/TpXcVf+W/GDJ03UYkO6OwLnQSYKtllq3Wh8mZIpSG3gRX1E1bL73IzKGILbAha/s2mOrE2CoifVJu3grBYPr7a6ZUfGTcNXhusdct0rBFstjQVBQ3iVCJuw97H2n3EX44Hq6+IxCJIuGXm1lrHtp+pwj/UzgIUS17+jC8on/MP5oQMqOPq3MBjrja09JX9zc9zm14YdrOJaU3SCRd1keVM9bHn31rTD7U7+3skjYUXzM0/9wvn1TZlFZQdJbtLJiCGZ6zizB5gmYKGMD5rGz+3JM9V2ScNwPvkgymk21wnZ1AKq3Ud0oRzkMr5jF2lyunywzGnRIsiSa83eqDYc6PyAWh8hdUfhmc1T/o5+mJJILxvWEOI81O7+ZejaqqbX1utawOLkRdn0JEYLfIz/VT6XaGPjD6QCq3b5xSSfUoUQ6bEK8VrWPEcdjOsu6fgBmb9xmWosxm4/m4TmohZVdoUnhfbAtkVUQabTW6NKabQHfhxsyljcOQi0g+dZm5A0usyWf2gEAQzYyt+LwTG7rkUjUAdd8d1oC2QGzh9GAsrDxA6UEXSrZ/wGFbwaaO+1cVSFTcExKw8e8pl8BDGQvRckqbZK7P1iMdHHHYbQt6G+t009Vzv3AY3xIho/vr5t/jwrlcHEOp+I0xHVchEj8q3wyolF7QRGID7x4Rc1tlrLSV1GD9mob2GKsAfTFvFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4380.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(346002)(39860400002)(396003)(136003)(376002)(366004)(2906002)(38100700002)(122000001)(71200400001)(38070700005)(6512007)(3716004)(54906003)(44832011)(9686003)(26005)(8676002)(91956017)(86362001)(316002)(8936002)(186003)(4326008)(478600001)(6916009)(6486002)(66446008)(66476007)(76116006)(66946007)(64756008)(66556008)(6506007)(1076003)(33716001)(5660300002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9+u3KGnwbXPwi9BfLGlYBi6j0AC27pIR2OvzpPH4hKHKPNKkNMC09iapHlUF?=
 =?us-ascii?Q?93bpVA6pHm6uDa4IDrPERHWIiTZ1m/s14xC1Kel5fBzNCMOVs0v0ab9B3zdE?=
 =?us-ascii?Q?ibRktQZYFOgfm3tr+hWLOKbDIRU9jmwd1B7lc66IX2qTXWiHRunvO4LTReCv?=
 =?us-ascii?Q?GCT6n+kio/Cur//7pB4O0QcaPL+6sQt8e/7UwhmRlTY+YSBjSeW7b0UCInc7?=
 =?us-ascii?Q?6J6r9yPYqEX3E7V2kdsjhNm3IbOq4N7Fdh/4GpGrnV9iYCFBGPxxXswrJ3+Y?=
 =?us-ascii?Q?gaku8ZX2qJBSGRlXtpFj6cdnaxNGROn3VF7xdV3L6iGaGXXpBoBRXfUHDNAU?=
 =?us-ascii?Q?Yn3LOCsS+arRnuF97YukL67+Sqxi3UtDLFGEJEX2GU1floo5kUoUSYGBhF7v?=
 =?us-ascii?Q?dePjjU3u2AO/cSAghK6IlEzXllHDz50+w/6XTC74FhfWQhEU6+0AJMqFxEcs?=
 =?us-ascii?Q?yD7Uh2uoPMK3lGWJ0br3ULmmAu00nc4pFDLKpwqzBvQ/Aw7tIo03RpHq2Xzm?=
 =?us-ascii?Q?5PZNGaGIeJmy+N2I+jDfOswNm1gIJmlPQT6L8oCuX5TQI8u9L1GEEesyFf/o?=
 =?us-ascii?Q?SJ6YRGhNgvMceg7QuK3CVO7nTjnz/Gfaz22Wc3HaTfIP+VIaJx6CfCg0MYYR?=
 =?us-ascii?Q?jcQVs17dbt3jSTxi51vZsK8CHeBLGNEmxyAbnoC1D//b+yYCv/jj/G6nY4e9?=
 =?us-ascii?Q?5PCJ9sm/PREjtK/ntkCHDV6Ckw/jJwGG0DUtWRIgDuQ93gre99DFRnm45u15?=
 =?us-ascii?Q?HU4fcDVjcZbWMKNFcOBglwxPWgfTSelYKrvEh+xfGjJzsOZ2ertxzmHsL6/F?=
 =?us-ascii?Q?ZB1Z/l2d1uJyxrObcu8QAk7+wQeBKvz2wAuH8oLy3VC8UAdTpF1pk8TDK+7L?=
 =?us-ascii?Q?CpO4wSdTfBWm5yhB2bf7P7Rk5K2j9+zeiYlJ1XBlf8gB6KqC/n3anrDYCd7g?=
 =?us-ascii?Q?ybNp6zAAxBOaN7PDj/u+dcAecyp+l2DPQkXUETSyxrd7ey0zgAyarbEfz2TI?=
 =?us-ascii?Q?qbQhjPTTF3z5m7G4TMTIJxRO7xiqOxpL9qgWHE+LU9d5qqTjGIOkaEtk6Lpa?=
 =?us-ascii?Q?WmtZkVWy1OIiihukqstfOqoQQvdd8c9rIWQe0YEJfZ0O+Z/6Q1TgVmq/kt+s?=
 =?us-ascii?Q?ZIx59w9PLXmubReGzqyJQqbU37o7HnzBmqDrzrySfpbEwsIl8KRIn0ZvsA9n?=
 =?us-ascii?Q?b8dr6rZmlwlQu8x/wGuyssMkvVmAG2tXTD4MB5Y8rT/Liq/R9NFzQtYKDMhi?=
 =?us-ascii?Q?9WrZQCkVK4L7XdDgsDEVj0+91BvqBZg2z4Eitwt4exztW1xKCxpxb8RYfe0c?=
 =?us-ascii?Q?+vsRnU827e9Kn11vUPJcHoGn?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <60DE37EC12A21945BFCF2237540DA475@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4380.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f79a503-e952-43ae-8bd1-08d9746543ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2021 14:14:12.0450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ALWxGLTFQIMa5Tsgvgngk8dXBZOHCbJsG6HicWsEncHQHYCS8DFulQN6IxeIUYBq4GaIkQmaNLkP6leWU54L1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3260
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10103 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0 mlxscore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109100082
X-Proofpoint-GUID: gS_Pt4dFafI7J9qllCzrqzzMk1gtAYvL
X-Proofpoint-ORIG-GUID: gS_Pt4dFafI7J9qllCzrqzzMk1gtAYvL
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Hildenbrand <david@redhat.com> [210909 11:01]:
> We should not walk/touch page tables outside of VMA boundaries when
> holding only the mmap sem in read mode. Evil user space can modify the
> VMA layout just before this function runs and e.g., trigger races with
> page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
> with read mmap_sem in munmap").
>=20
> find_vma() does not check if the address is >=3D the VMA start address;
> use vma_lookup() instead.
>=20
> Fixes: 214d9bbcd3a6 ("s390/mm: provide memory management functions for pr=
otected KVM guests")
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/kernel/uv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index aeb0a15bcbb7..193205fb2777 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -227,7 +227,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long=
 gaddr, void *uvcb)
>  	uaddr =3D __gmap_translate(gmap, gaddr);
>  	if (IS_ERR_VALUE(uaddr))
>  		goto out;
> -	vma =3D find_vma(gmap->mm, uaddr);
> +	vma =3D vma_lookup(gmap->mm, uaddr);
>  	if (!vma)
>  		goto out;
>  	/*
> --=20
> 2.31.1
>=20
>=20

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
