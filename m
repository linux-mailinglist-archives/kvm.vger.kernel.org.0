Return-Path: <kvm+bounces-72013-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MNqeEIdnoGkejQQAu9opvQ
	(envelope-from <kvm+bounces-72013-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:32:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A0C51A8C1E
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:32:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9949732DCC9B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64FBC3ED120;
	Thu, 26 Feb 2026 15:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cBEApV/N"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010023.outbound.protection.outlook.com [52.101.201.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380363ED139;
	Thu, 26 Feb 2026 15:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772118759; cv=fail; b=EfgeOsUbdXqJALqPlxRw3NxJnnoG4aa0Lhn+FDNIUwQNcq+Fs0Ges1PWqVDXEIAn0JPyhh+Lc2J9Nyn1rxapW0h22MG9SB9LjqlWfOQmk4O2cjrw+ECLjSi7bwTZU/G7FgMHXObA8Rm2tZtzYhz3bOKEudyHrMuvFK64hffxoDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772118759; c=relaxed/simple;
	bh=b9XlDulS1K/PvHtsx+sf6Cs+WdRS1/gC0rbWZIwPU1I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IMAORk75tjSa8gAr9rae6FueO97kpHhjKs7QSkx/YS6J8lXuQRVEZCw/ZKk1VaEOVCgM5D/XXipdT5dfia8iroLFgsvpbwr2bUAkLEfaU2uvkakFUudkKXXt7P6JzDUdWnEeqoxNQnsEz80gUC78b2gLH765E6EXnb04ttY7x8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cBEApV/N; arc=fail smtp.client-ip=52.101.201.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UgJkxCrpChvxDt+c6yD8uGT+ioQKUt5S8vFEiYD//k39DOC/iDPW/RuB4kpAQUn5DwkfYEFJpP4cqCDcrWK2oXKYTTq+8PjgSgb9ZEqw2iZIKn7ppeVEdJCZfGBWay1oQwSIFgIHVQ5KMl1JfKIzS92y7FsClHzdw3zn++/LIroEbkxXUSM6Mok1f0qzdaflw0xQstXJOtT+RIvNR4mXTXHfJ/n+rloPyVvQfdSIwiOji6sWXz/mXQwUxMUmqcJSbaGudauHDJsoO68+k3rFguc6osrhh5fbBuPxCecv/7wJu1Sf7ssRqbTIjp3oEnMfSpCwTFVNKb9LBdrheRBvhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gR+3sR+Jg0AwKEx/jxv6rnbPlGDZo4iKx1uGFGVUgvg=;
 b=AHFZ1XIUzjXrxmzTl6TsVp+Tcfh0Hcmi6bgpnAKnO32xnireS4eooZbdHFXBaL655tT7PQPwvB8VWCAwC9NI02hofylC+brwyIlafo/OwlD8OwHUPRxTReMkOA9ePx9QMAcdpgukG36UdmY8gzsIv6q2j+7A8rcx3LAk/cMZjeoUKAJDXPX0mubNIh8C7/lyXOWKpvlJP3R3xTW4hn1joPtpUDSOMO4ri4BFy63sw56+ratJW8nwTq9fewM+fY8Ovdq4PBq+uVy/drAIqVX/6u5gmY8AOwqfSUptjGJONZYBMqVZB6uXa0xzZuZdqqDQLNg0SqFfgH0uJa3SX7OhjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gR+3sR+Jg0AwKEx/jxv6rnbPlGDZo4iKx1uGFGVUgvg=;
 b=cBEApV/NjhNHoXjCTbP8YZQAK7zIReZEmtEMmDFbs0MCg4Pgz4PMcz0r+1hAnoPsiAIgMc5pv4H8xbO0F0OyBFxqI0LxENhsJ8uFaomM1YGkOqvEDiMmbu8O/xNAN94aMDTlYD8/syLihWv+2F078zfIk3ePBhzJp5Kyw1R40UFTykLIMRoV05/2Aws4MZVpdpgGSTWhLNjq08B2Lw1WTce/5gq/iHXg7mqkJs8z1lHfeBEZaLnU3X3T/vB99EOMMnuH4dBeoI+t6VlGltUOGF4zMOIFbyYc+p6Zqe3six5FhOcUKn3MZpFHk4SxPV4ICnP+hySqeIy2oWvfUUXAIw==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by DS7PR12MB9528.namprd12.prod.outlook.com (2603:10b6:8:252::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 15:12:32 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%5]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 15:12:32 +0000
From: Shameer Kolothum Thodi <skolothumtho@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Jason
 Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "alex@shazbot.org" <alex@shazbot.org>
CC: Neo Jia <cjia@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC v2 04/15] vfio/nvgrace-gpu: Introduce functions to
 fetch and save EGM info
Thread-Topic: [PATCH RFC v2 04/15] vfio/nvgrace-gpu: Introduce functions to
 fetch and save EGM info
Thread-Index: AQHcpNzzWVAkt0yYckOOMDwYfQT4gLWVGL8w
Date: Thu, 26 Feb 2026 15:12:32 +0000
Message-ID:
 <CH3PR12MB754847015699056ABBACD441AB72A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
 <20260223155514.152435-5-ankita@nvidia.com>
In-Reply-To: <20260223155514.152435-5-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|DS7PR12MB9528:EE_
x-ms-office365-filtering-correlation-id: 8abb68ff-caf2-4767-39c7-08de7549770c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|7053199007;
x-microsoft-antispam-message-info:
 bO1dbjvYjS3OJkQjUQgGcnDrZTCpVz0NxoUR25ipT1P67LGXzsjGb2aTT2xeV6wa3PoquIXDzwId5haSNIGg3Bx69O9/AcqYR0TfvTGZ+gVli+nK+jABSFJ61ooLSkmxMtHqM2MPIhIqu1MYizGj//iotG5Z5PJitPLu1WLd1SYYCaovCmgBZb74ZXUwRH55NwcmyKi6RMgBVIaNGuN+cGJTN021zBkvZ/byW8HOQ74D3Onnd+ivS2KyV+sGizDPcaTZoXksIqT7WpEa8WMBePTvRLJMczWMRFmyjD6UC1akaLrce/goJrWTZe5kxU3hlel/LjfON/8ipFmCVscb00C+9sSmLDlLx3GbtoOFK1f76I2mSoVRR9oGupH8RllQdaGFlSAN3hUG5tM4kw8tNAOxuJNkuDqebJPmqmP+exE4QkD+cS67lK/bdN9hHf/54JCxLihjoBjIAOqoWo8GqREQD1sMKV8KY2+vmecnd1dxtaM9Ro8LeuT/WLgtpGzRrYQaNXv6QYBtzHYGiCczASWoyKBfWI1d7ihtn+CpQdYuSJh6XV6bkka8Zk2KUZl91RhPuXv424w/oA9B2HgKAdd61DE7yvJX9Zw320eMekGfhBc+ixSkZptw/kShxjeAxSsC2HQaA8jQhXGZ4uVC/sMB4vx0D+fM07rMBl98AFl2tjoMBBRQnOKyU20WIegZpd1q4yeH/UlQQisbPGK8ikPnQGThWXRKXJQJ7fEWi5vPP0H99jsgJLBVNRWN0lSnxZe3eYpJAybPyTq5MXZuGdjFryEfv3EP2foAYkHjYGk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ihMxLp4gXikM8Ar5pEOvwHlShQUMW+vh2Z2T2tg56L47vTqx3e5d8WexRFLv?=
 =?us-ascii?Q?JB6tyn6BH2hgPffpleAWirf2wQiYsddPWWXv/G0Yhnpno52x9dZn8aWsMZiT?=
 =?us-ascii?Q?DJg4XzHZIW4uyLn5ef7zyMzq/nYsyYMedYtc7QCC7a9bnfZJjQN/o3zG/Q/M?=
 =?us-ascii?Q?P45rB+C0i5NscY5WAD/D5VPhNp1vjEAvm15I4g/6/Y94hBl8NmD51ZTiYGnp?=
 =?us-ascii?Q?L992eMsNXkFHdAJit2G/WPGwdsIa2XWueFQj91sHdnIjyFIgQOqVUjlrui+V?=
 =?us-ascii?Q?Sk6Cj/y2HBl1q8FIoDeWQ7a/LGPaWOzR+xUyOLXxaEzHq+xltXmG9sRf1QlE?=
 =?us-ascii?Q?ejp1VtZ1zUf6Mm9rS1ja2Jwx6Vmxf1YyVaw++DAkfObWZH13kKw0KM7k1jZR?=
 =?us-ascii?Q?nvROE0ABl05EHH7RJmVF+yX0mh5FsvHqVlF/fIc+Txs3xaLaTIOjRA70ofvS?=
 =?us-ascii?Q?JWxVu2MMikx4tTEM0VA+coo3LULUOX4gWxILodNCC+RyDCEsqI1Qzw13aHj6?=
 =?us-ascii?Q?MFYYudgNcAp2I/QyDNeureg9klA50Z42RvTAoemi7ULSrJytQv5AFJ4EwwFR?=
 =?us-ascii?Q?/YeqVCBT/ZcXpI2lE2rKWZi7YVFUbtJ5eQFL9f+T594zDibep8SHHF1gaILT?=
 =?us-ascii?Q?+WJ5HM++qp+WTGRlzkbVgCoN/zrhSgBOJY97wijNTnEkrSeAc2bzCRwBb2JA?=
 =?us-ascii?Q?v77vhgtzz9LSBSXwvS2tkauNUd0Mnqj0T2a+ZDmlw3I+WhUqtrjJdOz5Smo2?=
 =?us-ascii?Q?WL2Pp8k5Mzn7szko9VEQMQ92/dhyHP+EvccOvOsr6EWW7SaS2X4vBttYzNwi?=
 =?us-ascii?Q?UA7NvGHUbrMzkfYLSArJ5INeQKeELiqjgmHoRmAiHtOn3P6bF4+seS0CTDrt?=
 =?us-ascii?Q?AbFJrA+3Yv0Uz5LMEEcR5KMquqTaVif2k7BSw/KW2UUwsOTqBuSRkuCs209u?=
 =?us-ascii?Q?bYlxDNHoPHMz9DtGO573Bavhj+r7mRr/DZC3LQcRqSVN41vpwg//JhY8mxf0?=
 =?us-ascii?Q?JgB1YgRcBhn867p+B6SfSIQ53zUQgVfL+zJ16PhheSdQOW3MKgpDcLcN7gWb?=
 =?us-ascii?Q?GPf/dHRAkmBxcSpZPB74dav+kTIirMYy5WwV7pUFeiat8N6PiMF+Ix5YfFRF?=
 =?us-ascii?Q?X8pCBzyCcfsD7n7c1SwMxd/ofKuGGz9iz5+pJi4xvz/RGV2LnKtwzftzzmWa?=
 =?us-ascii?Q?3GSKy/vLWYWj/GaaInf57bewpyMXtfsIG1kyROEDT3NSvyYA/zwS4Pv36L2F?=
 =?us-ascii?Q?0wtEWV7iH8StKRrg790jJaPdKpK48AqOJk1ev9ajh7WtDGxZ/q+njDUxZjnV?=
 =?us-ascii?Q?qzMMle7nQydEN/fOvHWVykWZ78RmA8tC2ulBGbrj3nHBfIkNjiawKmWwZvNw?=
 =?us-ascii?Q?CrMVQ8lsZnmtRgSo9Hy3K0tBIxVw15Up2jBwupw0CkDrOw3Ik4oP5xQ3OEmp?=
 =?us-ascii?Q?RRw1QZ8Xd3QHXcw++JDpuE0OLOgjRJSot3P6NP/et6QCkxYAFDQZaicVFPpU?=
 =?us-ascii?Q?aJCfxByf7sYmGsX+1ZJ7U7x20mqfCHg3QPhElJGlpiOk3hofd4gwTGMPVcZ2?=
 =?us-ascii?Q?CqyIWaSF/Rm2oxmAUrXPZoFgXBlSgMm2pD6sR2Na3z8q8rDx2XJZRSBUzwPs?=
 =?us-ascii?Q?gik61puUWVi5KO2ijx9JMvjZ+8YCIsD6sdAKHCrwyXEiye4EcHEaV9py4u7k?=
 =?us-ascii?Q?5dVmPlFs8z5MLCx1Ghe65U7Mta38dc8GZ1A7MTdj1l3BIbxpeQFrqyf825N5?=
 =?us-ascii?Q?XIt+kItC4w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7548.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8abb68ff-caf2-4767-39c7-08de7549770c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2026 15:12:32.3239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q/dEgzUwpWQf4Y2yaE1R62tHBjEffcbhPSPc6iyN4YbX2FgBFeHzlqQKyhywQpqBH2pEnW/w8v980q9ourE5JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9528
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72013-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skolothumtho@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,Nvidia.com:dkim,shazbot.org:email]
X-Rspamd-Queue-Id: 9A0C51A8C1E
X-Rspamd-Action: no action



> -----Original Message-----
> From: Ankit Agrawal <ankita@nvidia.com>
> Sent: 23 February 2026 15:55
> To: Ankit Agrawal <ankita@nvidia.com>; Vikram Sethi <vsethi@nvidia.com>;
> Jason Gunthorpe <jgg@nvidia.com>; Matt Ochs <mochs@nvidia.com>;
> jgg@ziepe.ca; Shameer Kolothum Thodi <skolothumtho@nvidia.com>;
> alex@shazbot.org
> Cc: Neo Jia <cjia@nvidia.com>; Zhi Wang <zhiw@nvidia.com>; Krishnakant
> Jaju <kjaju@nvidia.com>; Yishai Hadas <yishaih@nvidia.com>;
> kevin.tian@intel.com; kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH RFC v2 04/15] vfio/nvgrace-gpu: Introduce functions to fe=
tch
> and save EGM info
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> The nvgrace-gpu module tracks the various EGM regions on the system.
> The EGM region information - Base SPA and size - are part of the ACPI
> tables. This can be fetched from the DSD table using the GPU handle.
>=20
> When the GPUs are bound to the nvgrace-gpu module, it fetches the EGM
> region information from the ACPI table using the GPU's pci_dev. The
> EGM regions are tracked in a list and the information per region is
> maintained in the nvgrace_egm_dev.
>=20
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 24 +++++++++++++++++++++++-
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.h |  4 +++-
>  drivers/vfio/pci/nvgrace-gpu/main.c    |  8 ++++++--
>  include/linux/nvgrace-egm.h            |  2 ++
>  4 files changed, 34 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> index 0bf95688a486..20291504aca8 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> @@ -17,6 +17,26 @@ int nvgrace_gpu_has_egm_property(struct pci_dev
> *pdev, u64 *pegmpxm)
>  					pegmpxm);
>  }
>=20
> +int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
> +				   u64 *pegmlength)
> +{
> +	int ret;
> +
> +	/*
> +	 * The memory information is present in the system ACPI tables as DSD
> +	 * properties nvidia,egm-base-pa and nvidia,egm-size.
> +	 */
> +	ret =3D device_property_read_u64(&pdev->dev, "nvidia,egm-size",
> +				       pegmlength);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D device_property_read_u64(&pdev->dev, "nvidia,egm-base-pa",
> +				       pegmphys);
> +
> +	return ret;
> +}
> +
>  int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
>  {
>  	struct gpu_node *node;
> @@ -54,7 +74,7 @@ static void nvgrace_gpu_release_aux_device(struct
> device *device)
>=20
>  struct nvgrace_egm_dev *
>  nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
> -			      u64 egmpxm)
> +			      u64 egmphys, u64 egmlength, u64 egmpxm)
>  {
>  	struct nvgrace_egm_dev *egm_dev;
>  	int ret;
> @@ -64,6 +84,8 @@ nvgrace_gpu_create_aux_device(struct pci_dev *pdev,
> const char *name,
>  		goto create_err;
>=20
>  	egm_dev->egmpxm =3D egmpxm;
> +	egm_dev->egmphys =3D egmphys;
> +	egm_dev->egmlength =3D egmlength;
>  	INIT_LIST_HEAD(&egm_dev->gpus);
>=20
>  	egm_dev->aux_dev.id =3D egmpxm;
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> index 1635753c9e50..2e1612445898 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> @@ -16,6 +16,8 @@ void remove_gpu(struct nvgrace_egm_dev *egm_dev,
> struct pci_dev *pdev);
>=20
>  struct nvgrace_egm_dev *
>  nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
> -			      u64 egmphys);
> +			      u64 egmphys, u64 egmlength, u64 egmpxm);
>=20
> +int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
> +				   u64 *pegmlength);
>  #endif /* EGM_DEV_H */
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-
> gpu/main.c
> index 3dd0c57e5789..b356e941340a 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -78,7 +78,7 @@ static struct list_head egm_dev_list;
>  static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
>  {
>  	struct nvgrace_egm_dev_entry *egm_entry =3D NULL;
> -	u64 egmpxm;
> +	u64 egmphys, egmlength, egmpxm;
>  	int ret =3D 0;
>  	bool is_new_region =3D false;
>=20
> @@ -91,6 +91,10 @@ static int nvgrace_gpu_create_egm_aux_device(struct
> pci_dev *pdev)
>  	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
>  		goto exit;
>=20
> +	ret =3D nvgrace_gpu_fetch_egm_property(pdev, &egmphys,
> &egmlength);
> +	if (ret)
> +		goto exit;
> +

This should only be done if this is not the add_gpu case below

Also, patch #3 has a comment:
" Skip the EGM region information fetch if=20
 * already done through a differnt GPU on the same socket."

That probably belongs here instead.

Thanks,
Shameer


