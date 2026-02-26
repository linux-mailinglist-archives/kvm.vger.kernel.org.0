Return-Path: <kvm+bounces-72064-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id COp5NH+PoGkokwQAu9opvQ
	(envelope-from <kvm+bounces-72064-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:22:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB981AD836
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:22:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2466C30B87E0
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DA8D3876CA;
	Thu, 26 Feb 2026 18:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c/U3XinD"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010009.outbound.protection.outlook.com [52.101.56.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542DC21ABD7;
	Thu, 26 Feb 2026 18:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772129740; cv=fail; b=ZwBnxVsVMY3/LdarNu4HS2ApaSGQxlw5gAUj3IRhBja8vdfZzRH3K+OhS/kBbo1VA/ORc0tjk2dT1+moncdtf3bzl1Qw1xj20d3KPu620v/ftByiplr7Lx82I/V0E1KcUNor3G5N56c0IsFq3A271efm3lNaagOz4MFbCuOsOdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772129740; c=relaxed/simple;
	bh=QwFWQ8BulaqEcmVaXLseg9/cFYZYxNqnjeyLYEYO2dw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WC7qYh2HnePK5QWKnlrbzc9qUpk/MZnaHQsdp2ll3vZnbBpuQnN/eZVBKXbidAhqfymDUIHaBXBYUoVVxFpQHznr05vCkaD+yF0Tm0RjyV6WI/ZVyl58gAVnVfdmoQ8miBD7kp7LcOnsxcCTcrCpkKQkx32vGRfS18QO3ay1bs0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c/U3XinD; arc=fail smtp.client-ip=52.101.56.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tMLA/vN2D35GKOfdmugrFdokmDpfgsZGFmN/zygcbwa/SlRIZHGnJI45K3OfIf+1MIGo0A+asZD7eK0vvuUFxOAH/SekCyMSs/5h8QfIW1jXBSR4YuR814WfTorgbzPxCueEJUdXSSAxSzmICB7gRVy6VFwitE8xsjz4QRgvoGRY8rkYtUMwGfOYwJOrVoqu/jpHiOkWAlcYkAxz2i4f4M230fmA48uSLva9RaaZBQWn13M9poIPzkMEwKNL2WN5wbPaYPV0PUvSM6H8CDq6A+xZrZOcOJgSpOsXYcxbHILYWY/9RfmTXuZICzX++MjQ76bLjfemBi5fR+2d79iUag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MctN6epQIqbZu/98BlBGlmd+Nt6rlr82seFA86bPkmM=;
 b=atwQyNChtOTV0hqHQc/XX68Mo714i1hMtNW6fgvyGRQndV/YBn1xY9ztOCkcnptQNIZjhBrJLq1lv59V/VapIweq58maCg3Xbe0QiY0pDGcb5D1CeY3yP2njE5TJ6nZ9F5cW8JskPINn1nj100HPjNHMq1Cdpe6PlXH+EX617Pc0+k5NadZ3WRe0PUpALW5wtF3/3VpF+jA2RJHJgdcMzKh76dkFg7qOBeZsWtKoUgtp60WtO9PUeyPsWgu2TAvEvYrm2ZHvIQP3NrYj89m96AQt2hZgFa7ea2Ix58fhfB+K6F8a0ZCDRFg5TDDWiyMJRmW+t4Hd7WydeqUqM+4hig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MctN6epQIqbZu/98BlBGlmd+Nt6rlr82seFA86bPkmM=;
 b=c/U3XinD0+5wMEqkYaRH0vKpoaNYZAh34LaeTiBQwFZfY937EhcA/MY3kZmUWqCtbWB7wYt25XIa4E9bB080PqIT2Gi2oKu6MQ93xHDxt4q6PNu0Hhz2LdxNfO1Jj7LQrV6y87l1cjqe1FyuBC4BRALf1Nw2dHtu7i9B7H+fNr7ateJ7Drvr23DwV3/5MaP6jGL0iePo2+MeCOP+DM8NFoENne1mL2EJStppTQeeBaQm39cDNUD6EVPlBjikl172I2+wMLZwZKLehOzKhF6mxv/KY+QMXvY9CaxJKfOfnWSa/slplcccG39ZT18Y58njzMgjBYUDXGt6G5GfI6IXDA==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by BN5PR12MB9537.namprd12.prod.outlook.com (2603:10b6:408:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 18:15:35 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%5]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 18:15:33 +0000
From: Shameer Kolothum Thodi <skolothumtho@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Jason
 Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "alex@shazbot.org" <alex@shazbot.org>
CC: Neo Jia <cjia@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC v2 10/15] vfio/nvgrace-egm: Clear Memory before
 handing out to VM
Thread-Topic: [PATCH RFC v2 10/15] vfio/nvgrace-egm: Clear Memory before
 handing out to VM
Thread-Index: AQHcpNzgjOBHgYQ9k0uXA/co5rrhHLWVSE7g
Date: Thu, 26 Feb 2026 18:15:33 +0000
Message-ID:
 <CH3PR12MB754812AD77FF9E02B0AB2F1DAB72A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
 <20260223155514.152435-11-ankita@nvidia.com>
In-Reply-To: <20260223155514.152435-11-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|BN5PR12MB9537:EE_
x-ms-office365-filtering-correlation-id: 209c98ac-c8f0-4e25-ff38-08de7563085f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|7053199007|38070700021;
x-microsoft-antispam-message-info:
 f7j1+W8otF2TobDw0Ueb1SE62CfGXqOW6OCGnnaHcXHLPU8aXxzjeJBTGzI0k7mNhb+tLuaUDMxs+nQmmfkU6D/QinzXGdfgQN/thgMaII4RJJuo2EOqWs24Jf96mvwhiXvt4xMNPGIT1hHu+e7WT/UZGtGKwgVmhwx+9eRszlflfDpdbJdTZjMNAqimPkclJthz2I76y9d/95ww3PkYWLUKI61aF7aukpAVeIpRf+s+UT8ut0FgTdvYb7vNK7rEVbfE5UtHmarTRY45H2er+hZuCkcWUPrTf89JZlUMY20k8LjRWSlyLEV/JCkBB5zTkNKY1iS2AskF+0f53cjxQC7ylmU3kGjMbuQTrIq6g383zyxFr/55c22lGk1yaKjLfvVk6i2ECqCpYOcMvriZrgceRL+c0mssNiyX+kaEe5ircu7oLKPljxPmB8thiS4zTu5NhgfCTZS1Qg9wWoceCHQ+HoE3WUdKT3B0pY+NilZoRvAqQZjrOL3CRWcBnzDNfDC3x8gobdiDPMjTEglZOoob7nAJi9Qnd7oAr98X6n9LoorXjQ00rIdbOQ9OlgYngPPrIEsyALu7HgHyV8F9zUwDzbkQM11lRe0+nWs5V9ygjc24riklddaZBTEFoqZvteqIZ0dx6mGvZI/uQKwE96lhKmGSEsJ2XHx84+d2cq1xDe92ngtsJ/NFh3RQUPNXWyLI2adEM7V9GI439OBWxU9+W/27bo0qYIOzk5o8PHbU4Si1ENczGG8Bv/s6zRwZ2koyX3L9ItKYbSPHN0RExb/k3vNglxADz3R27pM7Rbc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?xTPTM5M6v+gcWbtoxgz1TaLfzMPAMlrbx44F/c7eCnKAegaWrPYmR3zNaoJc?=
 =?us-ascii?Q?vQdQEuaN3pPNPprblo/OLXD9GeoDlfMNv1MdSVJXvv2wl/EYB9uT7VPQhA7I?=
 =?us-ascii?Q?Fb7ixKI6ujDRKsW8oA+6eSdCVH9mOS1FfnuR+IkdAq2RUm6nb0iaY7zVYlBr?=
 =?us-ascii?Q?y5+yBPM08KSxG5hejjy7ZnPD+DYHZrJ13ycLeV3EwNw3ONtTwCQj8fY9LfSS?=
 =?us-ascii?Q?yj0LqBC5E82zwdmOI4qInm7mF+u0+W0ZAE2OFW4RZcmfMGpscGCWnHZn3dr6?=
 =?us-ascii?Q?JFxfQZfNAiPjrI7odlgqPtlu8BjcDhfOFNNNiWOpKNAipcK/4NoZcux0BoWC?=
 =?us-ascii?Q?Hvez4yN5RLdGvzcGu8sJBvf6K9ec6MZpEFZxlrxKTQa47Pef6agRbD0I88vD?=
 =?us-ascii?Q?KeUWtD/q5Ph9Tgi3O0z23ybJGrIn4X4Ym9PWtMvCbX05prD7xcs5+2CPeuzO?=
 =?us-ascii?Q?BcMlZ3abA237W5G9iSFN7VygEbNA9OWV/1Q0AhH67ftq4l0P5MUSiYGmGmMI?=
 =?us-ascii?Q?Yq3T0AAbwZxfByvfaV+Cp+nFi6As+qY2BGdOgX+R0FeEglh01xeNRffC+A9o?=
 =?us-ascii?Q?xWlH59dHFMcWEeG/NElaEzMd08yvn4KT1j6YUiJP3bi3Twe70Pf5FWLbo8cD?=
 =?us-ascii?Q?NzsV3xcDiy6VeMnqeT0Qh/JCh2Mx7W04FIzSNSNaG22xR645Wxx7+5rY2dnf?=
 =?us-ascii?Q?1aQjBzaOlEvYtaWQexKyC6DW7WCR1s9aKe9uhJGixb3bN6BqB2FvL6N/dUSy?=
 =?us-ascii?Q?8cjDQjSf6qe11qhDFWhXguvjJbXi8ek626JKkYJutTsyMQ1mMwV97OS3xCVI?=
 =?us-ascii?Q?02LvfeI0MkLXHIhWZ2y2nLz7mpIRivpfmmHm3s5sDBmavLtNPgBB1SvmzCqS?=
 =?us-ascii?Q?8Rbvk6jyzyUE8Umccq3EBiEwVLTPasMF96/pqF6/rcZye4U8/GwYpl1yk9VX?=
 =?us-ascii?Q?0iT24/Kk85axvNjXxrpQKlZajxGo2d2bFuApXEgF7eIDnxNnDGG1EIl+Vpd+?=
 =?us-ascii?Q?8qZAL/sWVb7Fl7KzV3auKRI4qwmYYnTm0xM1Xn0Jr8h9WDKtNKhMww1YZ5gI?=
 =?us-ascii?Q?HmPwNa1038nJxqBNfRKzgq/ITb+AKzNqW2X1x6myLrXnrixABPKBO6DZrr5X?=
 =?us-ascii?Q?XFHjqiPyIq+rIvqpgYFOAERONf1iDrEDpdNwVOxLQLsIyv/vuJIncuqgvTgY?=
 =?us-ascii?Q?35iF6kqXQUHitG8VQcAHfrdTl1BaeJ4W300hg8jANntapnvWratYEBDODkXO?=
 =?us-ascii?Q?CfCmirATvGFF89z/8gqFJ4jaKhxrxU75Apmn5cl552MlBmi5B7uF+POUjMl3?=
 =?us-ascii?Q?dSJtV1U8yo5M7im2/Yvg9ZWP+HtqMBjO0YLBTnhMDG0NKpnQhnoFASIDDV4X?=
 =?us-ascii?Q?gknMz9gHHT28a8gKkYDwnJ3MIn3u4F82XhSxGS1K0YHQMeRNaAK2LIAhdPlK?=
 =?us-ascii?Q?FlEMsGITKBv968NTirIvM88jToUxYZh3wl6R0fHH1jy466tgYPr1XcjnH3oA?=
 =?us-ascii?Q?Hl29afJEUvjileVOYsedJFhzfDdloTDoBn44eY+6oAKu0aorrswBkhKKDw4e?=
 =?us-ascii?Q?39dvNfFlk/q5Dh/C+zwVqqFdUJfLpEIFuobvAGlsXf8JNj0SmHByre7+lkl6?=
 =?us-ascii?Q?qmAQoatKKTB90H9W6Wp0G27twp44p8T9PDoWnnHGacIbj2clyuxjGcvGXXZo?=
 =?us-ascii?Q?gif1UhcWQFOAwSsfZk9GNSXRJdEt7a5NBny5HSxxuFKQNGf7XKCd6tYG9Dct?=
 =?us-ascii?Q?KazkIoTcRg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 209c98ac-c8f0-4e25-ff38-08de7563085f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2026 18:15:33.4746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VAzoTIGgEU6Zw99psTrBrEDcbsabrWwMM0bYzeykitHz15df/3lHrvKuvqQD0HAMq/uv/GMy+kc4HcdJ+uHZHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9537
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72064-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ziepe.ca:email,nvidia.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,shazbot.org:email,intel.com:email]
X-Rspamd-Queue-Id: 8AB981AD836
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
> Subject: [PATCH RFC v2 10/15] vfio/nvgrace-egm: Clear Memory before
> handing out to VM
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> The EGM region is invisible to the host Linux kernel and it does not
> manage the region. The EGM module manages the EGM memory and thus is
> responsible to clear out the region before handing out to the VM.
>=20
> Clear EGM region on EGM chardev open. To avoid CPU lockup logs,
> zap the region in 1G chunks.
>=20
> Suggested-by: Vikram Sethi <vsethi@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/egm.c | 43
> ++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
>=20
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrac=
e-
> gpu/egm.c
> index 5786ebe374a5..de7771a4145d 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
> @@ -15,6 +15,7 @@ static DEFINE_XARRAY(egm_chardevs);
>  struct chardev {
>  	struct device device;
>  	struct cdev cdev;
> +	atomic_t open_count;
>  };
>=20
>  static struct nvgrace_egm_dev *
> @@ -30,6 +31,42 @@ static int nvgrace_egm_open(struct inode *inode,
> struct file *file)
>  {
>  	struct chardev *egm_chardev =3D
>  		container_of(inode->i_cdev, struct chardev, cdev);
> +	struct nvgrace_egm_dev *egm_dev =3D
> +		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
> +	void *memaddr;
> +
> +	if (atomic_cmpxchg(&egm_chardev->open_count, 0, 1) !=3D 0)
> +		return -EBUSY;
> +
> +	/*
> +	 * nvgrace-egm module is responsible to manage the EGM memory as
> +	 * the host kernel has no knowledge of it. Clear the region before
> +	 * handing over to userspace.
> +	 */
> +	memaddr =3D memremap(egm_dev->egmphys, egm_dev->egmlength,
> MEMREMAP_WB);
> +	if (!memaddr) {
> +		atomic_dec(&egm_chardev->open_count);
> +		return -ENOMEM;
> +	}
> +
> +	/*
> +	 * Clear in chunks of 1G to avoid CPU lockup logs.
> +	 */
> +	{
> +		size_t remaining =3D egm_dev->egmlength;
> +		u8 *chunk_addr =3D (u8 *)memaddr;
> +		size_t chunk_size;
> +
> +		while (remaining > 0) {
> +			chunk_size =3D min(remaining, SZ_1G);
> +			memset(chunk_addr, 0, chunk_size);
> +			cond_resched();
> +			chunk_addr +=3D chunk_size;
> +			remaining -=3D chunk_size;
> +		}
> +	}
> +
> +	memunmap(memaddr);

I am not sure this is safe. If userspace does:
open(fd)
mmap()
close(fd)

The mmap mapping stays alive and accessible in userspace even after
the close(). Since the release function decrements open_count on close(),
a second process could then call open() and wipe the mapping while it's
still live.

I may be wrong, but please double check the mapping lifecycle here.

Thanks,
Shameer

