Return-Path: <kvm+bounces-8582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36B57852734
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 03:00:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7C44286E49
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 01:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4593828F8;
	Tue, 13 Feb 2024 01:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Gw06reAf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C288A15A8;
	Tue, 13 Feb 2024 01:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707789590; cv=fail; b=kKFxzcCT1hR/eYA3rOAfJBO5Whz+8z25djAJ8h/ugrvo1cyv7HZwzF2l0Igv2ianKOpFtphSz0jEzudP+jA8XjCjPW7Xn6OAsgG7VvijnEWRR3Bx2vIAtdA47dOnZ7Y6UO8AVBSqtwQTT7rLMDMeclgM1BZXw7q3rFTn1hCugzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707789590; c=relaxed/simple;
	bh=aXOhvPxDY7H2DFEiXFZ6qovlQ/+9lrsQlRD3dyWEBKw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nsMLxHkEfxvqlc8X6LoRt1VgeUZEOejiAmu2KkLQkxzbkbKeVj2UqCOG0C95T+9QJYuH3doH7VbqP4MK3bPUUevJ+T7afNMbx78hQ0qx8EBOBvF8B7tEffEfikPWmKO1b6y2eqoTBtEdXvXJXtjW0N3WaXpMlRqHUt2WBPu1RQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Gw06reAf; arc=fail smtp.client-ip=40.107.223.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYU+cWCtid0S0cRUiOXeceYRjdPIIbpui+TYCQhK0NbvHieb55UnUQhBuVtGo4e86yo1SH/YV9oKpdbwhTsWnBXG2IDQzUsDsH9CJMZxnUMsVzMfRHL55ZuGIe74NOAro/VIVBtI9yB5y1g1jeToZk54ds1QmFARgs9xFf/Tn8bSfwZQcZYk+93QJ7KGmWw2CFx5zmY0iE12Nx0DByCMNa2QEt8vujy+i+K/MsxEL7RMDDcVPf/olCOvseD8ryTlh2CHA0a1xGHjBg2i9mlhSCoPoW9r9OwqlQ+I5/HUSnaOGrID7Iw4FtdicGK7LE0dfk1fmQWmeanOjXa9rPKlsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aXOhvPxDY7H2DFEiXFZ6qovlQ/+9lrsQlRD3dyWEBKw=;
 b=Q+KjbqQHvj1OA9LrllAsSx0BNHBOFRzr9CaLtGeMkEJ9L4Wjkt9jv/S0QJJsJTC8wBB+TKolmlnVROuCrW8a+GTfpMZfNpw0VNCy4kTElP5UjCP/VTqjoxhqKPK0QpAWMvRfOqNAeuMVtizNsN1TuTTLQkc9oPW6N3yHZh/vkQLmvlpXecaYEMGgnYRiSDoEExHTzntd+q7drtLjHmYJKdNlVITTG5t/rL0SLpSbE8mX5B5LC3WkTSuhV3Qi8MheFVqjpyOGxzJS9oWt5T2DSu1luATe+JhWlfRuCrKicQFjXzDxmjJHDTBN8n+ox+FuohjpbjF3LJm4EALsxYRneA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXOhvPxDY7H2DFEiXFZ6qovlQ/+9lrsQlRD3dyWEBKw=;
 b=Gw06reAf5C0maZlKgnXAQjsV+WCnAunMcCyoFx9i20u0VHeQfV/imb03QXThE0iongPACB2rqmT5OtunMxT4NyEJA1+YNvIezJNXcJoCRxL25R1cOCTF6len9pjy3XeElMnOy53UaXJOJSD0hOCJJ1L+5NpsoRxBTPl+7xLbCPNoLZn0HrxACQaAnOnqJclyo/KLUoDTat4RkUxzMVdBlk8/kOdxrwzBcAqAckAXPntx2GHOEV1ez7ULicZ9QoGSR6xzV3Q+VMf08dBuVc6pomyAt20LCpobocWVqu4qImzG0J6L/9KvnHg8i8xojjyzAA8hlfa9CGwfJpV8/2veIw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CYYPR12MB9015.namprd12.prod.outlook.com (2603:10b6:930:c8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.24; Tue, 13 Feb
 2024 01:59:46 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7292.013; Tue, 13 Feb 2024
 01:59:45 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe
	<jgg@nvidia.com>
CC: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "james.morse@arm.com" <james.morse@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "surenb@google.com" <surenb@google.com>,
	"stefanha@redhat.com" <stefanha@redhat.com>, "brauner@kernel.org"
	<brauner@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"andreyknvl@gmail.com" <andreyknvl@gmail.com>, "wangjinchao@xfusion.com"
	<wangjinchao@xfusion.com>, "gshan@redhat.com" <gshan@redhat.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "ricarkol@google.com"
	<ricarkol@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "rananta@google.com"
	<rananta@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"david@redhat.com" <david@redhat.com>, "linus.walleij@linaro.org"
	<linus.walleij@linaro.org>, "bhe@redhat.com" <bhe@redhat.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Matt
 Ochs <mochs@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 4/4] vfio: convey kvm that the vfio-pci device is wc
 safe
Thread-Topic: [PATCH v7 4/4] vfio: convey kvm that the vfio-pci device is wc
 safe
Thread-Index: AQHaXRJ7VoHXG/UeJ0C+ntDvjWGGPrEG8RYAgAAEMICAAAIJAIAAjqNJ
Date: Tue, 13 Feb 2024 01:59:45 +0000
Message-ID:
 <SA1PR12MB7199C6C925FD78EE3827BF6BB04F2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240211174705.31992-1-ankita@nvidia.com>
	<20240211174705.31992-5-ankita@nvidia.com>
	<20240212100502.2b5009e4.alex.williamson@redhat.com>
	<20240212172001.GE4048826@nvidia.com>
 <20240212102718.07543659.alex.williamson@redhat.com>
In-Reply-To: <20240212102718.07543659.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CYYPR12MB9015:EE_
x-ms-office365-filtering-correlation-id: 31dcd701-e464-492c-de9b-08dc2c3773d9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 h7R7fyJuiorGlg0lKAIoCMrx5Zx4OYiTMbZv22otqcBPY9wt6/oevpvkyTAn0M6l+AjXq2EWsnajaM8LtkBnzkL6LyeNrDmUyqeHrn+kkfvbNEjEmqWbJXHxoKxeSIn1gbkrJTu+K/h+YULMsv8bscmwI8ccEzk826GUC0bDP3f+CxZ/dNm4xr/ZIGUSkIZIWKO4JxEYDq6cyoD0epzSQx4/yWWidxI73WQXipn26LPXJ++dRmYQvEWUNPC+OFSd/KshhcTng9LmkjoUK/JLyzUfJ1NoF8a8j6dDUgf1EV73t8Wmg4oU6Xog0Y8fMac4Ff/49ZelhRE9gyTo3+nspJHaCSDkiKG/G08GqXOb2wUxCAGQ9rvguVBg6/UFqlEkRrW17jo1xRekXGB/aA+czQ7cXdpnB0T0UCkfb97ynYL1e7axZQ9F1KWOSBgJ9vstDfg8104G5PkLwPAE/VLTFtfvXwcWMWbcdZipollXMuROr/M0lFsrCusPgu2gJF8DK3+6tcPDUWzF+kkfjD8dkVF91uZz6rDzD1lJpN76VGUtIaqMHgxRxakOpQrk3M6c70GKsrQDtY3ENl7RD7k4NICN9Tk/OacZ9J8j22x4WPdYCd8+WwQAQubjc/eeeIqv
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(136003)(376002)(366004)(346002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(41300700001)(55016003)(52536014)(7406005)(7416002)(38100700002)(26005)(71200400001)(6506007)(7696005)(122000001)(4744005)(110136005)(76116006)(8676002)(38070700009)(4326008)(8936002)(91956017)(5660300002)(2906002)(66476007)(66446008)(66556008)(6636002)(316002)(64756008)(54906003)(66946007)(478600001)(33656002)(83380400001)(86362001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?XJSeWUNsp2bHfPRx4zPA6pq3t6iw5bBecwqBRYKsfV9s7zbta/c2g9WrSn?=
 =?iso-8859-1?Q?P8UYT67hF6rgH3Ww+uKGrw/P7Fey/wykuMlTAbDlRJpjQ2j3G78Bfq7yuc?=
 =?iso-8859-1?Q?EDoCPLfxKxiUOBVL2Aop09kLCnP0KqxlgfBAwzRJfB61WuoJofymCqHXoJ?=
 =?iso-8859-1?Q?1zCXU65bMBy39RDkAjpVoDRcq7+WrW/Tm0xOwgNLpbQVSBikORstA4CJAX?=
 =?iso-8859-1?Q?wwgOa6iffPlaYX/d+IyVw9+f1pTqiJ8MK/8TRBEa25JkxMNZeWMX97mlmg?=
 =?iso-8859-1?Q?DFTfTH+BjIHZworXmC6NT/bEeTdntdmMOFiOivZDRoDdVFWwPr0Ay3AACV?=
 =?iso-8859-1?Q?+dSkY9VO1NNOjenZ9Y95sdqwRYc7m9Axn3ogBvzigy+FzM5ALvdwzulLkW?=
 =?iso-8859-1?Q?8SeRudOZdd4alb+tGxpoyscqqT4PTPb8f5r1jAFSENOwhWosM5KbrkeXOb?=
 =?iso-8859-1?Q?G3PTydLJuOgdVm7wHBKoe28YTPzYXiUMWjPgOntFnYjhsYo8Yb/SHhzlSN?=
 =?iso-8859-1?Q?VbIukrxYwBA4yG5e2uQomueczOxgkdIoI/vBAVNxQ2OWNpQkLNdhUK/k3/?=
 =?iso-8859-1?Q?Y32JJOXMTT3cxhqKecl5C6qLdPyOL5bBf9yxjRDfftdLUBbFR8/72yUpYz?=
 =?iso-8859-1?Q?ZIwLgJcpecyCZiji1SVYLbU6am5Ax1BNYA24Y3FbRBokeKrgKGmGkz6Gl6?=
 =?iso-8859-1?Q?uK5Jei7kmZB8tcp7S+rNcLTW7IJDmAxAcX2eWbYserkKsKilWuGzikD9JD?=
 =?iso-8859-1?Q?H0CBBbL2KjhMa/U7ypFbLpAi6F1Z1pvtEreOs3Q36L3vbcJVUCgGSNm3j6?=
 =?iso-8859-1?Q?24VC8j5G3RtLRik/G6+7Vgbj6axBRRyohEEHOY73Xc16VHBtPxk9ksZ+X9?=
 =?iso-8859-1?Q?mYB7XMOKQBPTihQC1Bqzs3g4WtJffDGq4MBOPK6MhmoeiSAUviCNV4eaEO?=
 =?iso-8859-1?Q?1VGt5CvA5anIRyAjM98QwDo5XabtDk7sEWkunOHujrDeHi5O4BEr/NHPTE?=
 =?iso-8859-1?Q?VMGraoBwy3HUhlUgN7QLQZ4+yPDGhkWLtJAw/HBMYCppJH4XZaWBLAQaw5?=
 =?iso-8859-1?Q?yPqqW10EqAiScnywYSIqGMJUh+XIy87vpwoPrPgC/+EfvRO1PnkxDFxunv?=
 =?iso-8859-1?Q?yzcHz8/hQ4zAAmnmGTFYHo9oezCZjJ1t/N5GCeptIgjtDT0Qcsx8Biq2vi?=
 =?iso-8859-1?Q?7vwkGNLEu1MuLPe+wNIMvpo5JiYL9jWoHKXQgd1agbNPQjjYS9r1UZQEEu?=
 =?iso-8859-1?Q?iXMzMmm2JSWatcNXGoaLSSQSxasREccf9THVLVLAS3UDHaCwOmuvziTAZ7?=
 =?iso-8859-1?Q?8Uuslcr9elcAr07j+WqLQ8eXRPnl188Ex9H6lEL0qJt26kGjVSgenS9UlL?=
 =?iso-8859-1?Q?WNMYLXHphmDsC4sHQCMGVWb5fqh7vYiSOlEM/j4xR3BZ04JdIKp2kbc3Qd?=
 =?iso-8859-1?Q?QotyDRVia6Z8/y2Cy7KQ6r6xdbb1wBVVPSOUy/vgHyP1b0KITVCDKXD359?=
 =?iso-8859-1?Q?UYLxY6QmutRgBW+zqT4O2KbvMiN6DlEBBlVsxrRxru19BU4QRWchQLLoG3?=
 =?iso-8859-1?Q?n4/TK+toFXD5ytjkTdQsS179DckMwtxbQXm1US600IuCK+Zp4ORgtj8hk8?=
 =?iso-8859-1?Q?Gqqm0kKGGo1Fo=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31dcd701-e464-492c-de9b-08dc2c3773d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2024 01:59:45.7611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eI41hh1BRYzPWrSgB0hPfnVIfHpJy5MTZ7IiPH80DcqNafZ3Z7Bvts/fElEdpsqWLoJ87BnwZ55J5Sj0DSkW+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9015

>>=A0=A0 IP requires platform integration to take responsibility to prevent=
=0A=
>>=A0=A0 this.=0A=
>>=0A=
>>=A0=A0 To safely use VFIO in KVM the platform must guarantee full safety=
=0A=
>>=A0=A0 in the guest where no action taken against a MMIO mapping can=0A=
>>=A0=A0 trigger an uncontainer failure. We belive that most VFIO PCI=0A=
>>=A0=A0 platforms support this for both mapping types, at least in common=
=0A=
>>=A0=A0 flows, based on some expectations of how PCI IP is integrated. Thi=
s=0A=
>>=A0=A0 can be enabled more broadly, for instance into vfio-platform=0A=
>>=A0=A0 drivers, but only after the platform vendor completes auditing for=
=0A=
>>=A0=A0 safety.=0A=
>=0A=
> I like it, please incorporate into the next version.=0A=
=0A=
Yes, will fix the typos and add it.=0A=

