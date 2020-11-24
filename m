Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC782C1F0B
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 08:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730188AbgKXHms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 02:42:48 -0500
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:6542 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730073AbgKXHms (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 02:42:48 -0500
X-Greylist: delayed 2578 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2020 02:42:47 EST
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0AO6oEnN011699;
        Tue, 24 Nov 2020 01:59:48 -0500
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by mx0b-00128a01.pphosted.com with ESMTP id 34y0fh6v73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 01:59:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQbU9jp5L5kpUEhHpGpAmwLsiIRboBPMM6wkS+cdEAMO3zKupXLmGL+P3JoaVb32uk7DzZXAr62hS0aziKRSftsd9vSvwwevy7d+7qMBXPCaKXzIwmq9feWnH6lMriD99lo20cnZ97/BQWwb/0EsquJvEwiDymFAQN+VCvO7cMTVgtYmZyUwCiWm2BS/IH94SYY7A91LS+9OqpJ1CaRhhcL2XWVi9Zb7UL2Milb7rwn0C4aHDm+6/Wym1ITko7vUCuZd7Ru2wyPH3WG0r4ol36MmOuyW7A75PkZRrVEtS3T37VJ+tlgBE1taXuwfBZJ7m5yTf2dVa+Gm6ukO9Q8dtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAqwT7Nc26h/kUwls/rv05fuEBOSmKBY8xz4E9u0qc8=;
 b=kEH+KrAXw7chkI/w08BSxSsI/wlJqaYR6LG+Ov8gsjhKWN5L3KDP1MlgeixnL8xJ/cV7iyz8aiYSCPV0iJHcFDzp7/5AMvSKsZ5o7ycKYPRhw/ndDHxEviGNqrw/22qputDejuNxKJ8bXpoRjeRmLuYmi5ZPekKNHLb970K0w8DEjR0RN/QK4cA4CJIC0rKPR44v9I9UyGxFw7WqjMJhfp7JgGZXCbe81gQHgwIQxTjpMEDgZ/hYyItZxZe0f5kL806IYl8aYTha/OrZGW9F0qD6cWVHJE88A6kgO8869NTHpN3Brn13gD1w3jva3exuUCx1zq8C5ObUnd5VSDaFUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAqwT7Nc26h/kUwls/rv05fuEBOSmKBY8xz4E9u0qc8=;
 b=h39zRdVHXpo1JwjzQrJVx2Rx5tma2+3hPjpsuo2xyvn/w71c50pgX5gWENEs6Sbq9LMNhBPRmhXSxgj/PII6scunvuK9seOz1y2BnX4boJnd50rvWwXoXAI03ut+RUEiMB25df74jsSbh5vJPhvkSybwoe7jnIqY1d+3xTFbo88=
Received: from DM6PR03MB4411.namprd03.prod.outlook.com (2603:10b6:5:10f::14)
 by DM5PR03MB3243.namprd03.prod.outlook.com (2603:10b6:4:41::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.28; Tue, 24 Nov
 2020 06:59:45 +0000
Received: from DM6PR03MB4411.namprd03.prod.outlook.com
 ([fe80::f99d:8928:7e14:1a62]) by DM6PR03MB4411.namprd03.prod.outlook.com
 ([fe80::f99d:8928:7e14:1a62%6]) with mapi id 15.20.3589.030; Tue, 24 Nov 2020
 06:59:45 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "mst@redhat.com" <mst@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH v2] uio/uio_pci_generic: remove unneeded pci_set_drvdata()
Thread-Topic: [PATCH v2] uio/uio_pci_generic: remove unneeded
 pci_set_drvdata()
Thread-Index: AQHWwaUUIcZryZWIbUiXJB5cBXvgBKnW20eg
Date:   Tue, 24 Nov 2020 06:59:45 +0000
Message-ID: <DM6PR03MB441117D7BD9A2A539C2D2480F9FB0@DM6PR03MB4411.namprd03.prod.outlook.com>
References: <20201119145906.73727-1-alexandru.ardelean@analog.com>
 <20201123143447.16829-1-alexandru.ardelean@analog.com>
In-Reply-To: <20201123143447.16829-1-alexandru.ardelean@analog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYWFyZGVsZWFc?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy1hMThmZDdkOS0yZTIyLTExZWItYTVjZC00MTU2?=
 =?us-ascii?Q?NDUwMDAwMzBcYW1lLXRlc3RcYTE4ZmQ3ZGItMmUyMi0xMWViLWE1Y2QtNDE1?=
 =?us-ascii?Q?NjQ1MDAwMDMwYm9keS50eHQiIHN6PSIxODI5IiB0PSIxMzI1MDY3NDc4NDk0?=
 =?us-ascii?Q?MTI3NzMiIGg9InkrYzhuN0RCWlk0TE4xQ0piSUNIWTdHMjkrTT0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUVvQ0FB?=
 =?us-ascii?Q?Q2xFT2hqTDhMV0FaSWRFbHQwZTFtNGtoMFNXM1I3V2JnREFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQURhQVFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBZ3NWMDRRQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFh?=
 =?us-ascii?Q?UUJmQUhNQVpRQmpBSFVBY2dCbEFGOEFjQUJ5QUc4QWFnQmxBR01BZEFCekFG?=
 =?us-ascii?Q?OEFaZ0JoQUd3QWN3QmxBRjhBWmdCdkFITUFhUUIwQUdrQWRnQmxBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR0VBWkFCcEFGOEFjd0JsQUdNQWRR?=
 =?us-ascii?Q?QnlBR1VBWHdCd0FISUFid0JxQUdVQVl3QjBBSE1BWHdCMEFHa0FaUUJ5QURF?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQVlRQmtBR2tBWHdCekFHVUFZd0IxQUhJQVpRQmZBSEFBY2dC?=
 =?us-ascii?Q?dkFHb0FaUUJqQUhRQWN3QmZBSFFBYVFCbEFISUFNZ0FBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFBPT0iLz48L21l?=
 =?us-ascii?Q?dGE+?=
x-dg-rorf: true
authentication-results: analog.com; dkim=none (message not signed)
 header.d=none;analog.com; dmarc=none action=none header.from=analog.com;
x-originating-ip: [188.27.128.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b876e12d-b7ef-4a6f-75e2-08d8904686be
x-ms-traffictypediagnostic: DM5PR03MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR03MB3243159AE7A3E29AEB3B518FF9FB0@DM5PR03MB3243.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:480;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +cJD5RHodrAwR9Vjr6EeoGBq55ggR7ebNXD52kiNmCMS2Ypemmve1CJVZFlulqmuxiSOpDN7srbQFGwLUMfltirevmxWRuRiQ7VUVNvYpKEOG3dymW/iCaSQXjD0/NXlQoXLid8A9BKVJCikIRmK/7ZEpqq2YIr4I+FCGAuBKxQct8QW+2hYSzU1yXyFL8kCjQomMxrtd4k5ezE0ybht0ABdryb1TuURZriYoIFsYYhR+RVb9U1qMsqbAddmJyJ00CXJKkgMc+XOs3CYDdV7SmuBQjVZENoZ3F8yDWmrrmHIOPD5TkeLC3nG6dtQII4OX6KeiaiS8ZoSIgKRNC184KbLQfS5CdhhfmQte5Zqh5AurUL7DZ1O/V2taztEpeHW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR03MB4411.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(8676002)(2906002)(4326008)(8936002)(186003)(478600001)(33656002)(9686003)(66946007)(55016002)(26005)(52536014)(86362001)(83380400001)(5660300002)(316002)(53546011)(71200400001)(76116006)(66446008)(64756008)(66556008)(66476007)(6506007)(7696005)(110136005)(54906003)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ARz5hOQCb31fuEVyL7Jt2Jgys8/QApeIxT50nN6X9KMleziUrj5oGgK7im4sgjaE5AixpZnib/92b0rfHoTrgcFwrKvHPqfbGZ5DM2F/f+ivx4tzf8Lx9qt4+vYAqbidkFl007juskjL7sZUoysar1jtnWasrS+Ehwpn1SjbQ1Z6pCivtLXE5obtfIxzSZRsc2UFbI98zwT5vilqE/kPQCqhCmM0LCa6mr19r7fgACun1R2dfdbUpGRMq4VzNs+gSDErjMJwPHU4YTzHFVkjH9MMywEIYyohXiLN1y2gyrRjhC7M7Kn9TvPzXPbj74ftUbL+piMDU+fjBsEH7DWhkZ8+8Zk7GUNLOIFURMyF0PUraWHpftLjm4/ohmLdVFIx8YfWHzZwKrIVdPM7yWQWDiTZroU8t2B9O3wCkOU32zF0QnS3O2NTmq+vVzf3yIPcdIfx6il4dMEbilmoA3SXa5QvWtpvFilBzUiTC0k9CS4i8kHYeEiqDxaFIOXAUJn5NKdTogzWM9pkZOxIsV6PG0rBJSK/fyi/Drn1c5rCnA+HR9CcbRY5HqEk/Bg+25Ul78+I5uBLZNT2QJ5mZDUK4d9wtQSRbcZK+M6+DlnsjWAZbWRoWhFRFblYYRYmA42NVGd9BoGMHbku9iNPNizV0ARAKljOXAjjgW9OtiWv2umw9W/GiZbCqgaS+Wo7GaE9tNsCH2fOyfnYI2tI9uPr+XcFirOM1DCmMHHD7DGDmfwyz/saxqi6YEbzJIR9/uQn6F2WuZaA3/OlN0KRzQ2Rhn/HffWIHGVxFGF2f9btulyNy72tIZFkaVzcYAmH0iiN2U2013T8FExokmutJWJcQnUkitqVvPq9Qpg5IQK7DhOSEOOyRPulSQ+rqoVrzwI+f5SPa0akJVAmQDCJiRJzbw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4411.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b876e12d-b7ef-4a6f-75e2-08d8904686be
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2020 06:59:45.4285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BP0G8Ucqnorii7SF5P23Ux43Z+0/hFR+hP6hIgeZgDvl20bRkHoKKVkjJlZNV5LgllkpbhLRwkCWdc34Inv4sh/NBg+5xgijb1oo1dq4vD0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB3243
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_03:2020-11-24,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 clxscore=1015 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240039
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Sent: Monday, November 23, 2020 4:35 PM
> To: linux-kernel@vger.kernel.org; kvm@vger.kernel.org
> Cc: mst@redhat.com; gregkh@linuxfoundation.org; Ardelean, Alexandru
> <alexandru.Ardelean@analog.com>
> Subject: [PATCH v2] uio/uio_pci_generic: remove unneeded pci_set_drvdata(=
)
>=20
> The pci_get_drvdata() was moved during commit ef84928cff58
> ("uio/uio_pci_generic: use device-managed function equivalents").
>=20
> Storing a private object with pci_set_drvdata() doesn't make sense since =
that
> change, since there is no more pci_get_drvdata() call in the driver to re=
trieve the
> information.
>=20
> This change removes it.
>=20
> Fixes: ef84928cff58 ("io/uio_pci_generic: use device-managed function
> equivalents")
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---

Forgot the changelog
Apologies.

Changelog v1 -> v2:
* added Fixes tag
* updated commit comment a bit from V1

>  drivers/uio/uio_pci_generic.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>=20
> diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.=
c index
> 1c6c09e1280d..b8e44d16279f 100644
> --- a/drivers/uio/uio_pci_generic.c
> +++ b/drivers/uio/uio_pci_generic.c
> @@ -101,13 +101,7 @@ static int probe(struct pci_dev *pdev,
>  			 "no support for interrupts?\n");
>  	}
>=20
> -	err =3D devm_uio_register_device(&pdev->dev, &gdev->info);
> -	if (err)
> -		return err;
> -
> -	pci_set_drvdata(pdev, gdev);
> -
> -	return 0;
> +	return devm_uio_register_device(&pdev->dev, &gdev->info);
>  }
>=20
>  static struct pci_driver uio_pci_driver =3D {
> --
> 2.17.1

