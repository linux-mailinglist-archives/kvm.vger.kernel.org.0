Return-Path: <kvm+bounces-35877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D6405A15924
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 22:45:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA8B87A18E3
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 21:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603791AA1D0;
	Fri, 17 Jan 2025 21:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IBli7hFN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456131B0409;
	Fri, 17 Jan 2025 21:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737150307; cv=fail; b=CCTooIruRH9+9YvA/BdlN8CDNgAYqrlIOUm1qzDj1MQYb/QCs3tQ8lIR2Q9I5IwBawFMnOlaq7WMjvMYYaQPlTUjFevSBFtRB50yJyiarvYvoHikWiCfobanLhJVnmtghi/0SMX3TrnnHXbxMOyQUxnb2bAxaIGLHU4LXXXWNe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737150307; c=relaxed/simple;
	bh=yo7Phql3TL6Mpx4kyij4VNUg39YpdnQylU3cDuDX29Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Rw2vHQwLOYesGrWsh4FhgY6Pwh9tKzAnMGU6Ny73AfaSwOyeds01pGCK372VzZvCHXSaSAKGICkbn6GLa/GArRat5Ur0UkdVv9cHpLBO/lBDQnNTGr8CT3vrQTtt0KomkIg0PSlRweoWcx6FTqXkwcXkrMkJbl87xU2gXjuXGIg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IBli7hFN; arc=fail smtp.client-ip=40.107.237.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VRJEuCPLkFIiLHlTZz1Df7Fx/+ZXqWVrgUFr7oKs5lQvGDMCO+9+ez57iGUYKezQHeq+LnIdtimtBloIWrfr0QX16YU4E0daPwutw01xENehKX9ZFyxFdSK5mcfBTjhtMzo+t4bm3l30IdIvU9rkBZ1Okh3lM8724KTCnsKYPy0IpsWKbcAGp1kIqGHuaLU+svyJh+AJ2rmCQqhtS/hFEHhlQ80XaSH4IbjsiHP2zif2+gL6KT3YxcTQPBXRxT1IhZZL+y3hxLlZQnxmZmiAbChvlePPdyMS1k5DfGETNE4Yt6GuqB7PCK0YwBs6A+Is1OYuH5VZ8iMKYFtBJiLfVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yo7Phql3TL6Mpx4kyij4VNUg39YpdnQylU3cDuDX29Y=;
 b=Dy293kOFZyeDUWj25Ww5BPLcQdVloHcilawy8NgwGsJTuZGLil+OhwZwxafCubtPuPTdrspneKzKVz6SXTsiRfFpaZ/Y6oSkWx83omAcoRvrd/Y/oObv1NO1X7ZxRge+WaJ1FQSxYdXEszZt/436PfOs12IzgJE2K2opmQxaYlYVgzzw0iwU6XgFWMiQHW4jk2qFFuZNKo7J/qMtJoIX5P1D9pUNWPBy0kWFRtP5aYuiiLb17Mf4XDZ5+pvKG8xPlKMAcNvGPTtwADE4enLAmwh5wlPObw/TaE919EgaK13ciA2MQAwqL68//fogiSiCASHF98/g1Z3wWKZ8tqeKmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yo7Phql3TL6Mpx4kyij4VNUg39YpdnQylU3cDuDX29Y=;
 b=IBli7hFNPi4H8r9xqnVuzRJdCX6rkQNuGdEuafY9r0hbezav4juMeVSy+FL2qnL5Vs9GXr9cz4Dn8ABBXqxN27k3pO3leCctA11s9ClTV9IuqYmXhWxXB+JCeTMUDV+xeYIaefmobUDH4nnbBAJWCJsndSrVQTgoTT5RstA7kEt//561UNeL8VRCNmuy6JbkRnRoKEJAS/q7vd+XnKDDj1dhdxg+nbwScFwXZIAGVM9ZIUFl7VmuR0O+EiVq/4KH8MeMcyOFiB5kfzLJfBxdHku7tko9sg1n3jiKjvFJbaHaMsmA3JK1HQnMCzKq338uDq7T9r5rLHAUW6AyfTQXHw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by MN2PR12MB4389.namprd12.prod.outlook.com (2603:10b6:208:262::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Fri, 17 Jan
 2025 21:45:02 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8356.010; Fri, 17 Jan 2025
 21:45:02 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Thread-Topic: [PATCH v3 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Thread-Index:
 AQHbaPPMr+5jgewsKU+/Cqp4ayIU/LMbSQ4AgAAJq1OAAApqAIAAEg3SgAANJgCAAAJPJw==
Date: Fri, 17 Jan 2025 21:45:02 +0000
Message-ID:
 <SA1PR12MB71992A6981DD27BCA932C29CB01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250117152334.2786-1-ankita@nvidia.com>
	<20250117152334.2786-4-ankita@nvidia.com>
	<20250117132736.408954ac.alex.williamson@redhat.com>
	<SA1PR12MB7199C77BE13F375ACFE4377EB01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
	<20250117143928.13edc014.alex.williamson@redhat.com>
	<SA1PR12MB7199624F639518D3CA59C7F4B01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250117163108.3f817d4d.alex.williamson@redhat.com>
In-Reply-To: <20250117163108.3f817d4d.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|MN2PR12MB4389:EE_
x-ms-office365-filtering-correlation-id: e6ffbe21-ecdc-48f5-7bef-08dd374032b0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?5gqPfSQRK+2cX6vDFv1SASwt0Er5FYs1UUNBmBAdFfzJFLz7zKsh50cStk?=
 =?iso-8859-1?Q?y7qo700seDfedTUYW+NKLuraL5ReBuAFFIl2DAJie+MglvpKl81u94up1V?=
 =?iso-8859-1?Q?TnUw4dxzArnbty/D4YDPRegs3PyfvhlT3iwccrcIhYzqGYxZU3qrMuvqXu?=
 =?iso-8859-1?Q?aNPb4XBU1bVKCIrIfUSi5cVpC2/O4ZSOd+f94hVNsIHlhLqevWon2WO4g8?=
 =?iso-8859-1?Q?oiJOjypjn7/wNSMPTV4deUZCpDxVp35z7agR90T7n4I176YS3I0mU5NACz?=
 =?iso-8859-1?Q?rMqYlRJbKJ3eSHx388J2ocnSk7Dp9JH+RmKxICV9pZkWaJ76vRuDpS4iBt?=
 =?iso-8859-1?Q?FQdFP8hf7ifkAIpVrwBQ1hiwqYNMPMlEbDhC+Mh3j0+6lFyQHK2IAYRuJh?=
 =?iso-8859-1?Q?EtSgnjISCaMulbTOYUhDQYljeE6te2IABZDVVjbOIRT15/aTxqxZDIikKp?=
 =?iso-8859-1?Q?Khk3PKEODCN7pYjUwq3YNHA/NpOHxeeb7HNQQeWImUFKm5bSBJpea7N8xn?=
 =?iso-8859-1?Q?t1breg9QC1gR28KvoYTYcSJ15QCdMz4zNUyJhyNQwN5ZCHH9nTOEn0bcr1?=
 =?iso-8859-1?Q?tTLfyNUqo55S8a8neQ6WwGVrOkFeSwJ6F3Wn/t8MRFC9nR9bV7r0hlAEPD?=
 =?iso-8859-1?Q?Mc/hiC5tJp5y0ZBdJ09mJWzAAxP8lJlUTL22Cps24gzgmDfesbZuvNwlWN?=
 =?iso-8859-1?Q?V9BL9gmy3C3b7P8TKbhxWLkAvEdshk4bb0tQC1Y98BbOyIjU471rEKYGyX?=
 =?iso-8859-1?Q?ODsoppByRdBmxN8S4h1EvTxDdb5c1aY0s0ZyP45l6dWNjTsCuia1IQG7Jl?=
 =?iso-8859-1?Q?lObAWmOMNW22Msz2z86WhVmrZ5knHAIGW2iLLWJnWEVZy+JVfLp0pcMn25?=
 =?iso-8859-1?Q?Yc8QTtdXdEYmjA6v3qn1KLt1l+T0pNo60ryd/Sr8ZBua3HE9SPH49anKS5?=
 =?iso-8859-1?Q?hhpfxLMTRCVXQb66qfuY2vcaHFkwnF+m5HQRS1oc7HjxXtrqxtQ342HHEe?=
 =?iso-8859-1?Q?M3oifueuptRngkFuIZsNDWnOaiNOs235gfpfQfu0Wd55UFp9kpS2v07qCp?=
 =?iso-8859-1?Q?aqzucm0wGw7agVQBgfh+5tX4aKZ6EVT3mqMlGkoMrrYftly9aA4pJanQOp?=
 =?iso-8859-1?Q?eyyLuF/hffmOluyYv+Y5uMO3MiPkBpcOejQHcfI0Q6eRnBbC2YbaqBbSN7?=
 =?iso-8859-1?Q?TV5ifH0sKNElfP4Q9Rp0uQcrx4zI7GxBbOqi82gbDQBD2k8N45aIAueT98?=
 =?iso-8859-1?Q?pwztk2k27B2kHcxSJx7JQlk61wI9Fa7UMRyXKjV0TwsHXU8KHpvtJ6DI/l?=
 =?iso-8859-1?Q?P89viDoJaqPuCoUP+ZIgjoTvfsn53+uhXGXhnOeoasDUT4lAKF/eyyW63E?=
 =?iso-8859-1?Q?s0sCoiVU1om2A//Xz9cLR4OlDKz3UtXHnuefeiIeNkEH0xwqqaSF62YLMX?=
 =?iso-8859-1?Q?A1vuc+1IToDHgvcueFMzx+7DURf6tGvBuah/sAP4IyyqyfehHWW7urdFco?=
 =?iso-8859-1?Q?Ls6JgP9/BOHBF6BJ67L1K0?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?9nqaB1+CTi8dqY9SUo1HJ5vkq1jvNiCiz40iF6PeLVIz7BWgLPp6BsCr62?=
 =?iso-8859-1?Q?QEMDzGvPlELnJYIWuhcJK3TsvdvGQ7BfAUE7CwAbLhJzQcU1RFD2vQMCiL?=
 =?iso-8859-1?Q?GvaeR+RacZoOgzAEShufgY3SePSDghZf10e5G9ki3CwN2n4h/djdU2LzJg?=
 =?iso-8859-1?Q?B9WvbusaAcN56lefG6OAG3TfkRukINZaKl20egJRehWZoNdJtphYSfSUOS?=
 =?iso-8859-1?Q?3gt6/bwmm381tnCdVcNF43217xsbtVqqdhb1/4jL1JlswenLdAKWUH0OWB?=
 =?iso-8859-1?Q?SZ/YfxIMTyDyN9Mm9gmkyY6924Zx3uprXiGo+yryTCRJVnsuHhuRDnO1mR?=
 =?iso-8859-1?Q?GM8g916HSHbpuRdNvA4iPjqzXnDXz01oj1v4u3ElvdcfJ8SQ+99KhXTHRu?=
 =?iso-8859-1?Q?pgteQgavSWS+3ZAVZ5ybOCTIQOckFMsTEzpiZdVP7GWhKDyI4tvbgwg8/e?=
 =?iso-8859-1?Q?usqbGnK8GQxMWEv0fp/O95GeFXX1Bgcyk3/uF0c8tbMaOh2f5CDlsDXY50?=
 =?iso-8859-1?Q?kF/k6Lgab8QdHeaU37VW6niw9xzVO8Nov8GoVxXydL1mpgSWzmlbethUoF?=
 =?iso-8859-1?Q?GwZ9Xz1qzWjRdh4KUeTwEs85BNrdSQ9k/Z0+UKNMHBdRO2GK1t0PTzDb8o?=
 =?iso-8859-1?Q?UIgQB7cZy98Z+oGRDOlB8Gm663FG/dMs5IgwsUaBvPiSAuOvz1YI6hXync?=
 =?iso-8859-1?Q?dQLSmeN+raNaNCoZ4xkHpLWMyVsCcjoIDRePm2H19cuSKCt4oKE98MHEum?=
 =?iso-8859-1?Q?zwCY6H7s7pW0M/xsHFfsdFuw39/oJlGv2RX3mEGOGDPaVh8sOUyyiOB0Me?=
 =?iso-8859-1?Q?bGCiGpWfP++P9yJRJ9BQcUdCCK3X4qX1dm+gCZT/UNgWv5UpP2EqXd+Rp6?=
 =?iso-8859-1?Q?v8qbW8Q+mXTlKRL7vdbtFdEovlypspVpWw9gK6aS3noJEgBHoCSEv504Nq?=
 =?iso-8859-1?Q?MrfOQRRQ377DllTli+hOtAaplzYEkXX0e1T/OKtjZwGE3iZQRZ/KzET+Ee?=
 =?iso-8859-1?Q?xTRrHWDCeCkAUGK/kuJHT9C/Q11DMQS8nZFK+vsAPWGm1uzqVQruGtZaBi?=
 =?iso-8859-1?Q?DLm5JgXHKjbIAv6RfCsign5f0+tqOkOo9xXJ+RZ7+C30JDXWeJ4QUTDhD/?=
 =?iso-8859-1?Q?NOiGeg14IZ8DQMNBdeZKY42NeutggNWAzvgF5gQceW59uaPox2ktg1lc6L?=
 =?iso-8859-1?Q?X91MVDgwwqdBSFOw5j7E2Z0TAskvl7or6H5PVwec3ZlUw3Or0iwOoJpCe0?=
 =?iso-8859-1?Q?brH5X+aWKFRxvoRM3Cl223/6YiCQarAkK13m+3EvLaCgO/kUpmNSnxuDTU?=
 =?iso-8859-1?Q?4Ofst6aMc7TZw1Z5FNp2BzZ0gD8R+/Xz9uFtd44KoahV8Ivfre/YRNf7nv?=
 =?iso-8859-1?Q?cQRvuuhu6doNP33Lfrc6COjMnz154jVCDEhV3QSfbsQ+yFp7C33D7Zga+T?=
 =?iso-8859-1?Q?CsaV9rro/QdSThzm9PQV/vCklQ1zdLeqQyc50L1d8GhpFy2XQGdR7r0QnY?=
 =?iso-8859-1?Q?4HhZcu2e9x2NhPJN7fWTlnlkMkxPyuX7vRyP0yVCkCrF/xpRq3Zl2GBJTD?=
 =?iso-8859-1?Q?l0gLthl3XPWx/c9OnTK+zQQdph3MrMo8oh71ohgfGhf2sEhS79isgF9VIb?=
 =?iso-8859-1?Q?0eMBfw9GE3O2w=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e6ffbe21-ecdc-48f5-7bef-08dd374032b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2025 21:45:02.3984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QwTORQCDcgEDWg09deknhfZZ5h9AUoHAVf83Q7XCOmgay+Tw5z+h9nhkTSfIXugbWw2Kazz4lc+IlC+W9lbuOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4389

>>=0A=
>> Ok, yeah. I tried to disable through setpci, and the probe is failing wi=
th ETIME.=0A=
>> Should we check if disabled and return -EIO for such situation to differ=
entiate=0A=
>> from timeout?=0A=
>=0A=
> No, the driver needs to enable memory on the device around the iomap=0A=
> rather than assuming the initial state.=A0 Thanks,=0A=
>=0A=
> Alex=0A=
=0A=
Ack, thanks for the suggestion.=0A=
=0A=
I'll change nvgrace_gpu_wait_device_ready to read the PCI_COMMAND=0A=
through pci_read_config_word before pci_iomap. And if PCI_COMMAND_MEMORY=0A=
is not set, update through pci_write_config_word.=0A=

