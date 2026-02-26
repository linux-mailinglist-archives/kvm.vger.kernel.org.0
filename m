Return-Path: <kvm+bounces-72011-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oOR6BexgoGkRjAQAu9opvQ
	(envelope-from <kvm+bounces-72011-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:04:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CB6B1A831B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:04:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9B774313F535
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D61133DA7CF;
	Thu, 26 Feb 2026 14:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jOi/ppEe"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012057.outbound.protection.outlook.com [40.107.209.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA601374166;
	Thu, 26 Feb 2026 14:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772117745; cv=fail; b=nu8hYyjz+hXxYpkI5lJdJ22/Xr/2RIWyZi3NEYV5dqCXOq0cluw9vi5KnJmVLErqShDB5+yn4mv4NCJvvyGB4iQMJJ6vlh7YxbRKoGqW0gZ1HsSOCuvBLUkj+IqYcKijDKCGg2zv/BD5mBXr0qnoZ2vvCMxZW9ij0Wg8mXGYB+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772117745; c=relaxed/simple;
	bh=a9WMdDK4soJIUE/9w6irJhyUqThIu/Lh4oDrZfCxEMY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mHSJ46SAf0+niBohPvSrtIGZOFRbpxLTdbANfpOKpVVNPc0KYDcP6gNzhBkqQAumFT2RnNWbqv2ZCYRVVblLhiRfSvVVKnKFcDKx5hvhIFdYghrfRZv0Ow22xB1cNZTODPmJf+jfzEL8/xuNsrF2e7+h7W5fRAtl6ozF7ac5rT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jOi/ppEe; arc=fail smtp.client-ip=40.107.209.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G6Ju0hRjpBt/oEf/NA/rhfDYeyLx+d+EqAzMXbiKZrMA6wVXSQWuky3p+sjbe5tsymLM8Z4DAe95QK0O6gHO5zaXIPtmzM2tiNg9bca2fB7ISFBPwJUDQEcpKvpehPurqGc/gJtTKzDkidkUGeVjPzw4OdqduZwh5nrx3e4OKWFqkLjW25X7Q76AjxNkRcbjn3q53V1NutAfUvzHXp6SuSdmISKfWjkC4VUmJOYhgxj6QQhNnMAZSEsEU9++/glk7DxfuC+1GO1izogjWbKTrPiTmyJboytyALFtrcNx2gCzTky16G5If/MUZsdi9nuaEtoJc5jQVodLSqmWA+H6yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e4AkYfraqlQC//6Kd5/qAWAgjxpimUK1n0P+/Ih4glo=;
 b=iqnkeInj+/1mTiKEG0P+up8n9gj149g1WFPrUWItZiuFnKlgaXf4k3DXzNV1BjQ194X92/Li4INiUxhfWf11B32matlPHMqw6HHebykg6e0MkIFIEbKdbhbnNjbkruGRBZQ5scNNqrDz+Es8UU7mfu629eRQbFaJ8TmIyBJRUDx/0RQ3UVC6Rv+K8bGN/Y2BOHeeo7fW0gww0MUOB2jx8lzR9gzCH8jQyZLmJG2KDhjmbRvoB+BShRz4boSELiZ+7HBxquecSO132fW+yoknN78+5rfhbEfviDucqfzGAuu2yg1nMNZgRVctbtzm5NK+ZDEWeGb3kX3PxlZtx7Ck4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4AkYfraqlQC//6Kd5/qAWAgjxpimUK1n0P+/Ih4glo=;
 b=jOi/ppEe/I2xHK8otV+E2UsxldfQOShekiSBV2XfAIwxlIML0xMns9lDnh+BND9hPvrDbIYrs4P1Dhq0GbAgCyWZTPi28FMT9gk+D6qZzjNcvihR7jWZIHa5KUzWAZYExUZ3B7hQ802DFEUwEbkZqcwsvHAFac2q9LhV338/rWW5Z8rYzPUeJZkQqwO4S/z0UCihriQYViuFUF7BnvvMw+dK+W5Yu1N+xaKaMFLwETjC6zhbqrB6A6jCdaZZJ+UkaD+9MVtpYVJ+ya5rql6HvDTDVLkifhWdDZNs8afmcUCImJPAmXSsc4vfK3/0dFbE1epiRH+RYlkEeN3PBhBSEA==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by CY5PR12MB6372.namprd12.prod.outlook.com (2603:10b6:930:e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Thu, 26 Feb
 2026 14:55:37 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%5]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 14:55:37 +0000
From: Shameer Kolothum Thodi <skolothumtho@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Jason
 Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "alex@shazbot.org" <alex@shazbot.org>
CC: Neo Jia <cjia@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC v2 03/15] vfio/nvgrace-gpu: track GPUs associated with
 the EGM regions
Thread-Topic: [PATCH RFC v2 03/15] vfio/nvgrace-gpu: track GPUs associated
 with the EGM regions
Thread-Index: AQHcpN0G7hlCgK1VJ0ykiA7gpchG17WVEHyw
Date: Thu, 26 Feb 2026 14:55:37 +0000
Message-ID:
 <CH3PR12MB75483F6074324471868CC05EAB72A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
 <20260223155514.152435-4-ankita@nvidia.com>
In-Reply-To: <20260223155514.152435-4-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|CY5PR12MB6372:EE_
x-ms-office365-filtering-correlation-id: 6ebc75af-87c7-47bb-2035-08de75471a37
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|7053199007;
x-microsoft-antispam-message-info:
 fU9t5iK7w3K9UXeuEvArJt8Enth1PLIeN7fUbIbwj1Euh4eyLj10yf2O6TtbtqzG8EpI3P5wBDXyrp7oYQdIiuCm3w/ZaDLq94wwsQi9WKQ9ASJHbaT1aLPPlfLTOwppcXcNiCMjoWqS/32fMJabgZZJztGCEezNojnpvIf52stzi8W/bBMLXykvwD9CR9ue3UBsAbbJ75DgUFv1nnRA1mKYNahaRl4BAxnzVMk2H4sU8dj2KWbZxCfSf3/bHRcOU2nYB2ElvpSY+Dqj5rSZRu1qhUJsho83sUwIPJolMOoWHMJ05LsSl83q3mWbrDPdM4+vxAGkE3l0qA4/f5pbKG+WCqZ924h/DBe1mlUptL+ZMH76ZMYGhXMlxcDv9Qjl4CV8KMTIXrGi5S5BJAC/tQR3zZvM0EDpw1on+sdbfr6uY9LYMCWLFyEpvtSBmUGj+2gs1rbgF9W0Fpe1Hez++H7HbtxBnut/BLRtvRq1CqGOkOMFxq0M9M+NCwzrKG2FpbGnRJDQBFpAx36BE1ftnGjjmT0ELasRidIrmkZSdcWvuD1nKiWlr7MiBcwL1qGymqjN+svQXLYVO3MAe4ZiX9ly4MPg2/Fj6IjrVGKi0efU89GKJEcP+RJIPT2XmWg/06Ap+i0B6s1nGA1dOF4MyxZ+svE8hyPnnatatjBOlrnS9zVwIQl9oP7+UmxTzi5BrVAeJPj0GpILyFZDqe8jSR12SpEzmbZhX+1VzaorRdMQJP4x/naXZplQusDh+IYWe9lwXG3sHb5NnS/R/nEPyy1s2fsBn2UbCFZOII2QdS8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?/N6MazB2blFCP1wLafqiJwki6T2QbBTCqYrS61ZNaLcK5ll0zO02G9ich2EK?=
 =?us-ascii?Q?F/Ktv/ASFulupAQ+263su24iQvr+He13yxSOGjgUNYhxPMiSICFxo/4aOqNN?=
 =?us-ascii?Q?dgSgOqkpfR66ZRAVWExMeaL13vsfiuRvPY5nHJoU9Kqhc4P0cU3TQfnsdkZM?=
 =?us-ascii?Q?V2mvmorb1WSMPV05jM7XPNwXX5AosHQWbV6Fwy/JTOjH91KVQoN0i7d4sTw0?=
 =?us-ascii?Q?MTPgtamDJqsVGuO9er+Lo2ihKIxgAAaMUr3E4x36rcBbE8KdYXskMw6mF6rR?=
 =?us-ascii?Q?PpmZnXuTjevL/gd1/fBdXfnw6bPABpabbTIe1B7iL9DmxPWO2Gp1mQK23dDS?=
 =?us-ascii?Q?HwkHoFStaNcAsLpU0fWk6LptnsCXRBzloVzKiJXhcEDwOhKmaFJYqzfbQJpp?=
 =?us-ascii?Q?sTbIVCaPdwrpcEJr7+uYpWcvDp61O6nu0+gNRDA2oTYaCWWINA3381qfalUb?=
 =?us-ascii?Q?YYDqEWvkZgIzkNQdQxgGsmRONs54mUr0A/wzmJt/kYiDerp0KDDGtt5f5OHr?=
 =?us-ascii?Q?qWgJFD/DZFuLSpmKvtUcgUlwcGhvhPdNsCrwQP8daPORQNKV/XwOSYc4I2IO?=
 =?us-ascii?Q?TSiDwCLYhLXt+6OX+/PUY+9XqGZyYivqf2e8Q2zy1f1CVQBskpN06gfC8aEB?=
 =?us-ascii?Q?O4m6WX4KofQFerGHddgPFgf8VM5etXN+Y5G1QjYg14tA+39JfqxINGcjusi+?=
 =?us-ascii?Q?xgZYhlLIvAK8Yg+WlfRQyxb2wQBiNooy3wPg1LIkG3CVy+MJJfsD4kXpPexE?=
 =?us-ascii?Q?GLs7aPwSqS6k0kS4JGOc2kG1wncS51AjQHP5Cfc+YVCXxJtiE/jGApSzfA2I?=
 =?us-ascii?Q?crEHjsM8jb4Jp6dNQzM3kHjZEGZ3h2ZZ80pA/xWanvFW30dRupQSDyqc42ip?=
 =?us-ascii?Q?QXm1JiT7399cHkZ6E2Zu08oAIfkGW3sqlFChIH3y5sNh2CERXX676xt5RAg7?=
 =?us-ascii?Q?EDk7D3v6ARDtkyV6zI5RSL8zEnU3U86W1tIO307qFET3AVTgJKsB/OXvmck3?=
 =?us-ascii?Q?NqBQ6wU1BB1Hcj3Uly5lbT91tz4FWbQZ5aHYozDlGscmtJ775Fzlsyh6MA9O?=
 =?us-ascii?Q?ykghImCh9r9XR7h13quv+4Ep7qbzzulgfp18CHIDDlzVOgu9gKsMNAur1DtP?=
 =?us-ascii?Q?A2lmCkV0JlJJ3QdRSJG++D+Ms6yFJ/w2pU8vJLy4SHfR3lSoObCoFzNX2wux?=
 =?us-ascii?Q?wnAjbsD0qAmplrmUbIkg/+0AFEzw02cigXZNcMVO8dBF+xX3JDZ9B4j51puu?=
 =?us-ascii?Q?awmIe32A4MQW+d6kUCO1aSYlLlVd/GF8OTcOmjdrIO2xz0FUjKZXxt7sKBx7?=
 =?us-ascii?Q?uiP953D4789KBSTvtTyAZtF1o0ZtO/2UMmwedoYSeeyNTj/s8WcU43gSvpRR?=
 =?us-ascii?Q?snEErI6Kp0IIcJRJ3wzeX8CXUu4EqgizNoViDQEztBwsoLSebupOizdzKt8z?=
 =?us-ascii?Q?kvncZXvqg5av/teSKJcFgiuIOXa1BwHOFf43U0szIHMQ8Wkjp6LCpv661Wzg?=
 =?us-ascii?Q?Ltu7twjx1ACJL+5wNOGDMAClYjjrqhqOMZLhJ5RIcSN8uKIny9QyUOZ603A0?=
 =?us-ascii?Q?7IX4Z8VjIlEt48Die51ktV3dzBmBQn8pXD/4Ketf1zlIx8cyQF8ih96yzw2o?=
 =?us-ascii?Q?+lqUTljc0fFKMTaE49HVnWm5kkxtIqZp8iRcl+dio21xPfFbDRHBNZ+PkFxJ?=
 =?us-ascii?Q?TK9OU9jsubyyybmFS9XfZJRJzweICu7G16VNUrrHSNKZprXo+MlGy1/dUmXS?=
 =?us-ascii?Q?RLyguKc0yg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ebc75af-87c7-47bb-2035-08de75471a37
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2026 14:55:37.5824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fFp7aNPGZ1Ihb5S/IZ8/+0fNbKZvk153QogFxOd/mGDY7/3wm3Osk9uflz0P4h8zfbPhRY8FQZBxDZf6mYGrUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6372
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72011-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,nvidia.com:email,ziepe.ca:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,shazbot.org:email]
X-Rspamd-Queue-Id: 6CB6B1A831B
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
> Subject: [PATCH RFC v2 03/15] vfio/nvgrace-gpu: track GPUs associated wit=
h
> the EGM regions
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> Grace Blackwell systems could have multiple GPUs on a socket and
> thus are associated with the corresponding EGM region for that
> socket. Track the GPUs as a list.
>=20
> On the device probe, the device pci_dev struct is added to a
> linked list of the appropriate EGM region.
>=20
> Similarly on device remove, the pci_dev struct for the GPU
> is removed from the EGM region.
>=20
> Since the GPUs on a socket have the same EGM region, they have
> the have the same set of EGM region information. Skip the EGM
> region information fetch if already done through a differnt
> GPU on the same socket.
>=20
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 29 ++++++++++++++++++++
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.h |  4 +++
>  drivers/vfio/pci/nvgrace-gpu/main.c    | 37 +++++++++++++++++++++++---
>  include/linux/nvgrace-egm.h            |  6 +++++
>  4 files changed, 72 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> index faf658723f7a..0bf95688a486 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> @@ -17,6 +17,33 @@ int nvgrace_gpu_has_egm_property(struct pci_dev
> *pdev, u64 *pegmpxm)
>  					pegmpxm);
>  }
>=20
> +int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
> +{
> +	struct gpu_node *node;
> +
> +	node =3D kzalloc(sizeof(*node), GFP_KERNEL);
> +	if (!node)
> +		return -ENOMEM;
> +
> +	node->pdev =3D pdev;
> +
> +	list_add_tail(&node->list, &egm_dev->gpus);
> +
> +	return 0;
> +}
> +
> +void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
> +{
> +	struct gpu_node *node, *tmp;
> +
> +	list_for_each_entry_safe(node, tmp, &egm_dev->gpus, list) {

Looks like this gpu list also will require a lock.
Can we get rid of this gpu list by having a refcount_t in struct nvgrace_eg=
m_dev?

> +		if (node->pdev =3D=3D pdev) {
> +			list_del(&node->list);
> +			kfree(node);
> +		}
> +	}
> +}
> +
>  static void nvgrace_gpu_release_aux_device(struct device *device)
>  {
>  	struct auxiliary_device *aux_dev =3D container_of(device, struct
> auxiliary_device, dev);
> @@ -37,6 +64,8 @@ nvgrace_gpu_create_aux_device(struct pci_dev *pdev,
> const char *name,
>  		goto create_err;
>=20
>  	egm_dev->egmpxm =3D egmpxm;
> +	INIT_LIST_HEAD(&egm_dev->gpus);
> +
>  	egm_dev->aux_dev.id =3D egmpxm;
>  	egm_dev->aux_dev.name =3D name;
>  	egm_dev->aux_dev.dev.release =3D nvgrace_gpu_release_aux_device;
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> index c00f5288f4e7..1635753c9e50 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> @@ -10,6 +10,10 @@
>=20
>  int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm);
>=20
> +int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev);
> +
> +void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev);
> +
>  struct nvgrace_egm_dev *
>  nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
>  			      u64 egmphys);
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-
> gpu/main.c
> index 23028e6e7192..3dd0c57e5789 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -77,9 +77,10 @@ static struct list_head egm_dev_list;
>=20
>  static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
>  {
> -	struct nvgrace_egm_dev_entry *egm_entry;
> +	struct nvgrace_egm_dev_entry *egm_entry =3D NULL;
>  	u64 egmpxm;
>  	int ret =3D 0;
> +	bool is_new_region =3D false;
>=20
>  	/*
>  	 * EGM is an optional feature enabled in SBIOS. If disabled, there
> @@ -90,6 +91,19 @@ static int nvgrace_gpu_create_egm_aux_device(struct
> pci_dev *pdev)
>  	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
>  		goto exit;
>=20
> +	list_for_each_entry(egm_entry, &egm_dev_list, list) {
> +		/*
> +		 * A system could have multiple GPUs associated with an
> +		 * EGM region and will have the same set of EGM region
> +		 * information. Skip the EGM region information fetch if
> +		 * already done through a differnt GPU on the same socket.
> +		 */
> +		if (egm_entry->egm_dev->egmpxm =3D=3D egmpxm)
> +			goto add_gpu;
> +	}
> +
> +	is_new_region =3D true;
> +
>  	egm_entry =3D kzalloc(sizeof(*egm_entry), GFP_KERNEL);
>  	if (!egm_entry)
>  		return -ENOMEM;
> @@ -98,13 +112,24 @@ static int
> nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
>  		nvgrace_gpu_create_aux_device(pdev,
> NVGRACE_EGM_DEV_NAME,
>  					      egmpxm);
>  	if (!egm_entry->egm_dev) {
> -		kvfree(egm_entry);
>  		ret =3D -EINVAL;
> -		goto exit;
> +		goto free_egm_entry;
>  	}
>=20
> -	list_add_tail(&egm_entry->list, &egm_dev_list);
> +add_gpu:
> +	ret =3D add_gpu(egm_entry->egm_dev, pdev);
> +	if (ret)
> +		goto free_dev;
>=20
> +	if (is_new_region)
> +		list_add_tail(&egm_entry->list, &egm_dev_list);

So this is where you address the previous patch comment I suppose...
If so, need to change the commit description there.

> +	return 0;
> +
> +free_dev:
> +	if (is_new_region)
> +		auxiliary_device_destroy(&egm_entry->egm_dev->aux_dev);
> +free_egm_entry:
> +	kvfree(egm_entry);

Suppose the add_gpu() above fails, then you will end up here with an existi=
ng=20
egm_entry which might be in use.

Thanks,
Shameer


