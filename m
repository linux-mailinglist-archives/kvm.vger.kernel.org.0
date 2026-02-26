Return-Path: <kvm+bounces-72004-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oALtBv9ZoGlPigQAu9opvQ
	(envelope-from <kvm+bounces-72004-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:34:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A4A981A7A37
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:34:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 06FC73119D5D
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C145A3D6496;
	Thu, 26 Feb 2026 14:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ulUrmMFf"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010015.outbound.protection.outlook.com [52.101.46.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA0A3D331E;
	Thu, 26 Feb 2026 14:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772116130; cv=fail; b=VLhgoIafArITid0SJCX32cb6/Zqnw8IZxha1eQpGynU+ONqWQEqK9wDql9F/VvARg+ov3RDQbN6wkPxNIInzx9fh3PDyUo3eSnmXRUn8i6TaCYtpVdgp5UhI9LRxpEHZJ+K53WZkeI9a945IYWW6fwEHjoZM/DD3G4+/pdOhf5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772116130; c=relaxed/simple;
	bh=2AUSm9Zorse8kQhwJovqJgOGiav5YQ05SkxB06UYWIQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qq2qwU2Li2a8L4JJrlP/Pi0pvezQvB/Ut80jpi6eScPsbDuwY1EkngDZBk0hKDRLEev+wc44O8SVolqU4Iiep84CBibNJYUOWBe0W2hxbfuKh40uKIGKYxliezumFqlEiNigKj+ESHStcuNDnMwVVjLe42kfM/S1NHLNQljBk5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ulUrmMFf; arc=fail smtp.client-ip=52.101.46.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NNxwRZYvyx7P5S3sfS2+vJ7PeNk8uFXayF1eDNNv6uNHgX/Tbf0lpkO5+ymUoRm70eSMzKhZDEBS5+cY21eEBzm9J+3HOCOLLn6OgAKcwL3KaGXntQH8eGLsbDt0ZvP6uiL6LeCFICtpyI/+Xg2cN1/nf7Qk/ZMyv6lqFZdnRUphFPdhLItYsza2K/z6rSKIlJLaI8L0JI7QFURy5kZjcuX3Fg5afZ6hptLITJ9FZx1mGr3pteu1DkhKSaFHSXYpGDxw/y8uajqfZg2EKXGwWaBAmCezkaNuPbE3aIgxSD4blS5U/wBQjy8GxvskpSp4evGbQVqGMr9R36pFmdazNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ooANGx2tynn7MiUofPLXx/F5KcUXJZ9B0h6wR9ZVlE=;
 b=I5UvreM17ts3OjPJGfrplxljADc4RB/qGO1u5TaJu2oqw8Ct3crQrce2uFCd+MYpuvOv7PqVvPA7HrD08uV/xIm9y90Lu3w60PPD6r84buR8EwOGuhX9EOer/vMTxxBsp7cTRzyyoQCpn/+zMN3ZMEAtAHOTQcWa2VXITtfPHzLU+qV13C7l6UNGsRFH17rGF13w/2OkMXxyqcYLM01+8vkCfRJWBvigRJxUC3tIz8RwggizJjK6ZCzrZEX7b4q8hCF7anVLyUD8IawLnOnLVj0H/oshM9dNdZTRdUzS3fyGjSpqbYHbtC9YyctcWMJDE45Egk9ZGfOzbQRwcGwVnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ooANGx2tynn7MiUofPLXx/F5KcUXJZ9B0h6wR9ZVlE=;
 b=ulUrmMFfoAdxJLOQgC5/m37xbTRWhglGidmYxGhHPn83/Zc12X83W0aTPMT2JHjARJk1mdJK/xHEavENtgeRfqpVeBc8gQ35Tis5kJUfeF6Hd+1TDqHlUHfI4nRVRKjw35sfu0cEuTJkKFtOz1GwJeXwndxGHikVXajYA+wZLaShsqIAKI1JKtvOeJ23CacJC8PArOxCMrnk5nE+oaay2ijzeF0/Oes2E+FSNJC8KPU44LPmGlqaAYtaa/ZmEmyR5n0oUcGfCJzw+tl6MiEfUzCF7QBLI7iVsj4KnmQ9M9JczYSmVJjm/OrPLZACYOG7eBS6iwFzYqDspoWgOnbkvg==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by PH7PR12MB8053.namprd12.prod.outlook.com (2603:10b6:510:279::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 14:28:40 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%5]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 14:28:39 +0000
From: Shameer Kolothum Thodi <skolothumtho@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Jason
 Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "alex@shazbot.org" <alex@shazbot.org>
CC: Neo Jia <cjia@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC v2 02/15] vfio/nvgrace-gpu: Create auxiliary device
 for EGM
Thread-Topic: [PATCH RFC v2 02/15] vfio/nvgrace-gpu: Create auxiliary device
 for EGM
Thread-Index: AQHcpNzcSAFpUg+tsU6P4Ukn/0VtQLWVAIBg
Date: Thu, 26 Feb 2026 14:28:39 +0000
Message-ID:
 <CH3PR12MB75486028D0D4BB95EE5B5B0DAB72A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
 <20260223155514.152435-3-ankita@nvidia.com>
In-Reply-To: <20260223155514.152435-3-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|PH7PR12MB8053:EE_
x-ms-office365-filtering-correlation-id: 51f7d550-9dc3-4c6e-51d2-08de754355ce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021|7053199007;
x-microsoft-antispam-message-info:
 4M8h7kU8NDaw4mS3/Ilct1UF3upxrTUSWGo4iVnhcVmcudxGHQ+YwaKa5jTB4VBJhdev1J9qC2p3lW2upoD2RMmRUSIWJjsdQSBoC8hUh7xkRbooHTW5Dl8n951SCnnZdOCpeLlOMZJWV93wptM2OlXYfplay4PXIRQMMlsN5NUbchX7iLuFQO5DKH3jo+HW49+4Uzh05JxhSI8YegMfmYFSJFKEdNw/1G089Yb7Q0SRbQh9eVxWgfs3QL8d78jrSi3hzGltoqXspbAAAvIP/RmcbjLtWeKXRb8Le7O8Yfjudau2S3JpMkrV7jc/ooI+k45KhHbpeyztyVuNSFQV6cEUqBoZnrjls8Eu9UxKRKi3CLdEbDfZAUJzfJI0QqdN4VrC/fGwPIaPRmIOyXgs2TOkEIYWWrBug0uOD+Q+iUinndhvijm/IoKdHZFUWmaBJkek2EYZiJzBIo27eRhaMQAXpxLNh8RrMOrVKEIl65+iHWoGQzG9So5rL4IAsPA2t23dDtap5nvaip0pr+v0zo08qZY3fkhFkkntpPvicFa2L3J7ZzPRYE9KaK/FToQgOW8g3hmUV+1UlIR9LRXyOK12m9ems1NfoSUDFvul3wRckd8l5fRy1KjV5zS/Zp/A8gUg0Nf7RQa8vmoYQSvI+Tfmp4CxifGyEOLds/2Kbq/3Wnij3aFTgYybR8WwXbR94XRWCVyKmFohaxQluFw2TGRVAhm6QKD48MScMIZhe3f5AZGfi1/BGfgL8zXXh0NpUtjwBW7ZCPejbTyV1d1iacDzjnSvyLSzCS0s9dsiaMc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?IznB4oS6CpLvCDEpoTNEP+WifYZxKVBoVohlPhE1sJUZRfI/DyLciC9+OCnx?=
 =?us-ascii?Q?e0OCLjdzeq8ImaoZuNOxoAIVuuW9mZ3EEQVnXrAi/WWcXGlJS7XGgb43iP8t?=
 =?us-ascii?Q?IGtWfQgPRtpvZfYt+/cfjcApf7K37eRcCTY60tAqecHNX4fTGs/XjdWo5B7/?=
 =?us-ascii?Q?PCSZN7J/lUZR0bWy2yZ+u7avf0fjfINdstdneYvDYhc/K3Jt9S8hpVBI2qg7?=
 =?us-ascii?Q?SbCnlnkNDRkZH4xlBbTlKKCMg6tUbW9jA5b0/I83XXKofShxsqAXPYZKBOLd?=
 =?us-ascii?Q?KGz6S0PjOyCrHxovZ/EV90ylaKOaXIKwpsL4ygf0m5lqf7mK9UAcZcIyloL/?=
 =?us-ascii?Q?XnqMrQN1ExY4uQy752jWMWPEBO8ku43Div896a2J8H076XHbUvuTQtMT9s+c?=
 =?us-ascii?Q?0d5x6oS3ttwv96KaAyY3Cvu8Vj0HgqLGv/gD06T/hpQgu++GS18tSZQ4nxW6?=
 =?us-ascii?Q?2GwOgiUCU+gOTO5NUHkiaX7JTkEE95oB2LZtDMn2h0qaY1eEdSwiZOGgPbGp?=
 =?us-ascii?Q?fxTq5M36/lBCa4OJdNPViQnkVWJuhuBSkR9Kl/AszlpKdoaHmr6WWWI6RxiL?=
 =?us-ascii?Q?Spt19fMuBx1i6DGSt/B70bnkSgueEXhO3SNWBQlAPElYkI7WVwUnDoWk7eRP?=
 =?us-ascii?Q?fBWPZt5CN2o8ZkOg6bsbm1Gv6yIiZpnpoDQjYpDJCWYT7BMf4SO7gQkPkHtW?=
 =?us-ascii?Q?J2jX04ub8sjOAf6UBdrBCO4VPjbEzAq0TpSaU20A21eXeaatLMLY4acEvNuQ?=
 =?us-ascii?Q?F7sj4fkR7m+FdHuCZHI6i8cC65pM3jJTNu9GBM5NgNT6aUNx2hSKLb9YQ9GC?=
 =?us-ascii?Q?Km2susa93a1uQhceSAnDyQsaPyZsULjb7mQpMhccbTJNJCzBkDs270YUEFel?=
 =?us-ascii?Q?qyMuK3EwDrkdU6ZaZZCGkqCIGtT89f6pX6B1yh65vWPJ4PSClY1cyzK9akZ5?=
 =?us-ascii?Q?bIo9O04o+ZwMwamH6ztlXRBcF+uG0p/MwJc9UuBGNiD0aEkK9ZjJcsmozXU7?=
 =?us-ascii?Q?spt198+Ul+qhytX2absMAglTG/ILabPp3IL4eNXIPWqCKb8IRbhK2HSmD/wF?=
 =?us-ascii?Q?l2Zys3XFrZxJNgyJx1/clQsdDmdWl7k2KoyKro1r6vv3vJwU0WPl86i1l/TI?=
 =?us-ascii?Q?X/i6YFSiMJgJgaMd8uOdCdWTqNZ2mqQ/UcIH8AnOfhriPSbs2b2guY0UX1os?=
 =?us-ascii?Q?7f3cSy+T7jLXdpJyKvg/nnXwrQ2UOrd1p/vWou0uoZCZITQBKiQDVH9OCy0U?=
 =?us-ascii?Q?Se39MuvkPKZ79FgknzVzUYaRNIZaKL6BF1mhLn5cNYE9B1FDXa0dggNNtxTB?=
 =?us-ascii?Q?tzZzxTMA97yutinVMnP/5kDZdsjyzLXobjSauybD8TGA+3SG9pbR1IPYReAJ?=
 =?us-ascii?Q?RrwPAoSa6vY7Xia/ldbPrekIiPE7vsBDZvcGvkaVZeiLhvnAqQv9iRq0RqMC?=
 =?us-ascii?Q?V3AXZ3LsaXEAzYcnp9l9axrpH2kB2Dajr3kjzWbTqI3kdH0t3VNQWLUj+B+V?=
 =?us-ascii?Q?mJKso5cuUX6x1fUQ82VFtXObZMv3y7PboX96oVbMY2VMP65Cvw5Ebm+Poykh?=
 =?us-ascii?Q?6cEr6FIqme7csD8ISVICMIpbWtW199DavI5Pu2zPi0GoMhYBp+KMXRxMAzAT?=
 =?us-ascii?Q?ZdPolXacROEVUSlJA4jZ1hgU4GJfc3iW4eyl5QU93EUm9lQH3UEeN+CMxjyw?=
 =?us-ascii?Q?TQgZ1wsbmpaQXi8nC0/0aG0KGlNi0q5BTuQNUiqc7GT0EMV02AQLUTL05FsW?=
 =?us-ascii?Q?E/Q+Tw5WHw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f7d550-9dc3-4c6e-51d2-08de754355ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2026 14:28:39.5194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vu9yZj7+XcR6JxxgebHPeGleFEEke+ceQbGIYH6pXKJg+MBYVxc39OKzjudlUHu+d/cF31YzLipXcYViQiOuVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8053
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72004-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,CH3PR12MB7548.namprd12.prod.outlook.com:mid]
X-Rspamd-Queue-Id: A4A981A7A37
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
> Subject: [PATCH RFC v2 02/15] vfio/nvgrace-gpu: Create auxiliary device f=
or
> EGM
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> The Extended GPU Memory (EGM) feature enables the GPU access to
> the system memory across sockets and physical systems on the
> Grace Hopper and Grace Blackwell systems. When the feature is
> enabled through SBIOS, part of the system memory is made available
> to the GPU for access through EGM path.
>=20
> The EGM functionality is separate and largely independent from the
> core GPU device functionality. However, the EGM region information
> of base SPA and size is associated with the GPU on the ACPI tables.
> An architecture wih EGM represented as an auxiliary device suits well
> in this context.
>=20
> The parent GPU device creates an EGM auxiliary device to be managed
> independently by an auxiliary EGM driver. The EGM region information
> is kept as part of the shared struct nvgrace_egm_dev along with the
> auxiliary device handle.
>=20
> Each socket has a separate EGM region and hence a multi-socket system
> have multiple EGM regions. Each EGM region has a separate nvgrace_egm_dev
> and the nvgrace-gpu keeps the EGM regions as part of a list.
>=20
> Note that EGM is an optional feature enabled through SBIOS. The EGM
> properties are only populated in ACPI tables if the feature is enabled;
> they are absent otherwise. The absence of the properties is thus not
> considered fatal. The presence of improper set of values however are
> considered fatal.
>=20
> It is also noteworthy that there may also be multiple GPUs present per
> socket and have duplicate EGM region information with them. Make sure
> the duplicate data does not get added.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  MAINTAINERS                            |  5 +-
>  drivers/vfio/pci/nvgrace-gpu/Makefile  |  2 +-
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 61 +++++++++++++++++++++
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.h | 17 ++++++
>  drivers/vfio/pci/nvgrace-gpu/main.c    | 76 +++++++++++++++++++++++++-
>  include/linux/nvgrace-egm.h            | 23 ++++++++
>  6 files changed, 181 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm_dev.c
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm_dev.h
>  create mode 100644 include/linux/nvgrace-egm.h
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 765ad2daa218..5b3d86de9ec0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -27379,7 +27379,10 @@ VFIO NVIDIA GRACE GPU DRIVER
>  M:	Ankit Agrawal <ankita@nvidia.com>
>  L:	kvm@vger.kernel.org
>  S:	Supported
> -F:	drivers/vfio/pci/nvgrace-gpu/
> +F:	drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> +F:	drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> +F:	drivers/vfio/pci/nvgrace-gpu/main.c
> +F:	include/linux/nvgrace-egm.h
>=20
>  VFIO PCI DEVICE SPECIFIC DRIVERS
>  R:	Jason Gunthorpe <jgg@nvidia.com>
> diff --git a/drivers/vfio/pci/nvgrace-gpu/Makefile b/drivers/vfio/pci/nvg=
race-
> gpu/Makefile
> index 3ca8c187897a..e72cc6739ef8 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/Makefile
> +++ b/drivers/vfio/pci/nvgrace-gpu/Makefile
> @@ -1,3 +1,3 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) +=3D nvgrace-gpu-vfio-pci.o
> -nvgrace-gpu-vfio-pci-y :=3D main.o
> +nvgrace-gpu-vfio-pci-y :=3D main.o egm_dev.o
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> new file mode 100644
> index 000000000000..faf658723f7a
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> @@ -0,0 +1,61 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights
> reserved
> + */
> +
> +#include <linux/vfio_pci_core.h>
> +#include "egm_dev.h"
> +
> +/*
> + * Determine if the EGM feature is enabled. If disabled, there
> + * will be no EGM properties populated in the ACPI tables and this
> + * fetch would fail.
> + */
> +int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm)
> +{
> +	return device_property_read_u64(&pdev->dev, "nvidia,egm-pxm",
> +					pegmpxm);
> +}
> +
> +static void nvgrace_gpu_release_aux_device(struct device *device)
> +{
> +	struct auxiliary_device *aux_dev =3D container_of(device, struct
> auxiliary_device, dev);
> +	struct nvgrace_egm_dev *egm_dev =3D container_of(aux_dev, struct
> nvgrace_egm_dev, aux_dev);
> +
> +	kvfree(egm_dev);
> +}
> +
> +struct nvgrace_egm_dev *
> +nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
> +			      u64 egmpxm)
> +{
> +	struct nvgrace_egm_dev *egm_dev;
> +	int ret;
> +
> +	egm_dev =3D kzalloc(sizeof(*egm_dev), GFP_KERNEL);
> +	if (!egm_dev)
> +		goto create_err;
> +
> +	egm_dev->egmpxm =3D egmpxm;
> +	egm_dev->aux_dev.id =3D egmpxm;
> +	egm_dev->aux_dev.name =3D name;
> +	egm_dev->aux_dev.dev.release =3D nvgrace_gpu_release_aux_device;
> +	egm_dev->aux_dev.dev.parent =3D &pdev->dev;
> +
> +	ret =3D auxiliary_device_init(&egm_dev->aux_dev);
> +	if (ret)
> +		goto free_dev;
> +
> +	ret =3D auxiliary_device_add(&egm_dev->aux_dev);
> +	if (ret) {
> +		auxiliary_device_uninit(&egm_dev->aux_dev);
> +		goto free_dev;
> +	}
> +
> +	return egm_dev;
> +
> +free_dev:
> +	kvfree(egm_dev);
> +create_err:
> +	return NULL;
> +}
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> new file mode 100644
> index 000000000000..c00f5288f4e7
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights
> reserved
> + */
> +
> +#ifndef EGM_DEV_H
> +#define EGM_DEV_H
> +
> +#include <linux/nvgrace-egm.h>
> +
> +int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm);
> +
> +struct nvgrace_egm_dev *
> +nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
> +			      u64 egmphys);
> +
> +#endif /* EGM_DEV_H */
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-
> gpu/main.c
> index 7c4d51f5c701..23028e6e7192 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -10,6 +10,8 @@
>  #include <linux/pci-p2pdma.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/memory-failure.h>
> +#include <linux/nvgrace-egm.h>
> +#include "egm_dev.h"
>=20
>  /*
>   * The device memory usable to the workloads running in the VM is cached
> @@ -66,6 +68,68 @@ struct nvgrace_gpu_pci_core_device {
>  	bool reset_done;
>  };
>=20
> +/*
> + * Track egm device lists. Note that there is one device per socket.
> + * All the GPUs belonging to the same sockets are associated with
> + * the EGM device for that socket.
> + */
> +static struct list_head egm_dev_list;

Probably I asked this before...Does this need any locking?

> +
> +static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
> +{
> +	struct nvgrace_egm_dev_entry *egm_entry;
> +	u64 egmpxm;
> +	int ret =3D 0;
> +
> +	/*
> +	 * EGM is an optional feature enabled in SBIOS. If disabled, there
> +	 * will be no EGM properties populated in the ACPI tables and this
> +	 * fetch would fail. Treat this failure as non-fatal and return
> +	 * early.
> +	 */
> +	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
> +		goto exit;
> +
> +	egm_entry =3D kzalloc(sizeof(*egm_entry), GFP_KERNEL);
> +	if (!egm_entry)
> +		return -ENOMEM;
> +
> +	egm_entry->egm_dev =3D
> +		nvgrace_gpu_create_aux_device(pdev,
> NVGRACE_EGM_DEV_NAME,
> +					      egmpxm);
> +	if (!egm_entry->egm_dev) {
> +		kvfree(egm_entry);
> +		ret =3D -EINVAL;
> +		goto exit;
> +	}
> +
> +	list_add_tail(&egm_entry->list, &egm_dev_list);

Commit log mentions " Make sure the duplicate data does not get added"
But this doesn't have any check in case multiple GPUs points to the same
egm_dev, right? Or the commit meant something else?

Thanks,
Shameer


