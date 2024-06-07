Return-Path: <kvm+bounces-19044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1067D8FF9A3
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 03:38:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 087791C216FE
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 01:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B871610A24;
	Fri,  7 Jun 2024 01:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="l7LXbRY5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10olkn2056.outbound.protection.outlook.com [40.92.41.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E22611184;
	Fri,  7 Jun 2024 01:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.41.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717724299; cv=fail; b=Xu9oV0MQfRXYkSEkbbCeVX0z/HrnpjyoY/8yP/wVcPBxKm7uzn1G9veadlyHWmdHV2IGv4xFGeC4oVJz4WR4qy7bPUp4l61NUyPP3w9iUQd2ajpPyjJISmPJPmio6NIlGpHCmh1GnlVr/6t6QfoapWutvWPRiuHlP8HVYnZtBpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717724299; c=relaxed/simple;
	bh=5XpPkbvngXUaPP3NdW8EPhNhmfOtRtSATCoMfb//js4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o8AciQ9v7bhz/QOa7N/nkod/94u4d1c6buj0ggH+HQ7/MpFMPHihkf43aXNRjC6ZHKpxDb04gy+lW3VBP1Zq7G+EZbUNUHLny/UW8o4cDI/Qwdb8vhnqthsKPkFD3OhJj5Zov/dpkY/i6w3o8IeDYPxP3y5Tiqhtfls0bjeTurE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=l7LXbRY5; arc=fail smtp.client-ip=40.92.41.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ntot2qAoCvUZUDiWNXpgqWBl/jHX58QzQZFoeFnI1bnAGRQlgD19FgmABoEyX0IER3YuVKMEXyo2XKHRT8r30zTlEHfo7fbi6nPIeyuRlmNmLnTtahEkvPy0fWtEhykW7JWGWYRqfEj7D7l+0vXme21IwZThRWg+cGqbd60AG2TI9h+yIa6giDgqRPVfnBIW8ftuh/1NrYNDe7/qZZinz/YlTRuIExlBGVluMSwkhuKNotdc1/aNOxTwSr55xkfWpsmaJAYGmO+hj8zACLBxb2TdEJE4hB+7L7GLtKNuZ1VPY+cswNI1REh1pGHNyhIV6HLsYPZWcy4Eh+vVw2NvXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5XpPkbvngXUaPP3NdW8EPhNhmfOtRtSATCoMfb//js4=;
 b=VNo1uwdvngjG3eqLQVoMOvEQYG+HBsotenfgV4d95VJ56Nfw+O2hlEC5m2XYHpzRyj3lF5wuN2/p/Kd8P5/UGWcxmHjR8EsVQ4rIJzSQ4UkJxNxQ1IMdWj7wRaA+qAqxdcHbsErzL7ySEo/yxgdG+2EBN3gq6r6FW1nom38fHJ+lDSSYJPR3qdn8QqTNeJIkMn2gDGKW/xswz6qmOdZ5eUztFMh3fJFwhVBRkMSlZgMgaOUZHeZFzW5sQbt/j6qFMSiXP+cVoiNm2+8NSu061XLTDxKPijdYKEQJDP43xzyczbq+ghxCIdsyAZjXQ4L9+FNIapGPYkxtJA9E/ofFYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5XpPkbvngXUaPP3NdW8EPhNhmfOtRtSATCoMfb//js4=;
 b=l7LXbRY5JOQtaAO60NcHt2Y+aFAtzLWwjdpZBoUmwxW/G936nOSIkFQqcI+eROdX7cxuBeragUK3EcgEuVGb/9EIgOAN4+e+aY3F0/+E+Ntaz1tngUiqpWsFRxk+qnuCzIPmgMmQHYxqE3WZOZB4li77BTccH1xz49sOMpy/CCR3f0+gmF7sJ3SMfr/k3YJJy6Z5rGFaMzh3IAy/0xOwtz6v22sf4uwZn5/Ch3G8OzkFc0TtG0DygkLwRL3cgN0Lrz6ExKtTgLmAa8cE6AQAlwS/u0WSrPpL9LxqLHMgmr9ViE/Oz3xCdjEp7EP45SwltzXpq9c7a/32QgqMrUzDFg==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by CO1PR02MB8444.namprd02.prod.outlook.com (2603:10b6:303:157::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.34; Fri, 7 Jun
 2024 01:38:15 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.7633.033; Fri, 7 Jun 2024
 01:38:15 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Steven Price <steven.price@arm.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
CC: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, Oliver
 Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>, Alexandru
 Elisei <alexandru.elisei@arm.com>, Christoffer Dall
	<christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Ganapatrao
 Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: RE: [PATCH v3 00/14] arm64: Support for running as a guest in Arm CCA
Thread-Topic: [PATCH v3 00/14] arm64: Support for running as a guest in Arm
 CCA
Thread-Index: AQHatysPRYaUedD8SEOOWptuNOqVvrG7hVGQ
Date: Fri, 7 Jun 2024 01:38:15 +0000
Message-ID:
 <SN6PR02MB415739D48B10C26D2673F3FED4FB2@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20240605093006.145492-1-steven.price@arm.com>
In-Reply-To: <20240605093006.145492-1-steven.price@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tmn: [/7FyMFN+y6wC9bfMlT+Cd92p6p6XTb/g]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|CO1PR02MB8444:EE_
x-ms-office365-filtering-correlation-id: 22786f91-1838-422e-9d70-08dc86927fff
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199019|440099019|102099023|3412199016;
x-microsoft-antispam-message-info:
 x/I/eIR+yY3VrxuEnEJw313RHYshF9LluWWy8KY3jwWYFo3GkGqicEvvR7yj9gDtdJvnHYF+GrvDT1K8cUsoO6wxaCDJxlH2rgxWRjHodMx8hf/wYKQsae14V4gB8T66dscsEqrow0tl7jAnd6Zbq5WwaIlaWuHrCDZ8hJ5OXIatdcHHdqisxEmOiLT/6jxBBMe/2h3dodSW5wVXDgmxjxnazSUB+QxUGBk9eWtNqgVsneStb9Ni1y4BHpKhpmBz1U5WqmoPw/n2bCSVF9LL+4h4EdfeMNkVoBg86z6NquXLBJ0i7zHfQKgd++S22SVFcxrfpOgrHNMEyj12MjfPbwA1YLTw5k5EsEdp0CvKVnSfNCUCRjQ2GwWILcig7yIRosVpfzJLtyVXi5qEHEpLOQpVl9yWNv3UvuH6eRZU/ERNOynn1hJHA+dB+f70XLP8BAaD8/LnqHrpJrC2h5Bh4JvGnv3OC+zEdpGt0m/lzIz/TUqqvr3QLT28HEVjwlV+JiwPMI3z/3KQNj/LKesV5kat61LSwVO8uJKf6FJUbqzrbSt6JCXR22bGdHWsz67E
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?b1WVjQngpjHiXVDKPGCvthQx4dWxcjWRnsCSfwDSCgVvR4qRcDCqKNJkqnaz?=
 =?us-ascii?Q?LsLqwQa7AjeD8lns1CLyxNbYj5GbgYDRWOduoNxwB23bDlGQHqF3eW5bsF8S?=
 =?us-ascii?Q?5B7XS1CBcz6p38wIEU82JeWoYCxQARc0y7P58C3CjMefp8G98L1xH3Sc3oX6?=
 =?us-ascii?Q?G8Lp3s/u1l34+1pcEw77mwr2wRbD8xIA/DOB/Ole2akVp445wG7NxZK8621I?=
 =?us-ascii?Q?pbqW7ONlK2Rg58Uy7h9IuMFWhr/VKftI5aeyylNWBbyhD2WX7PQ+MWL/SVGb?=
 =?us-ascii?Q?7pbSh7UQdnzjN0Oqa8huOi65KjrH4rUrcNyw2/dHZCMlGFyygKyV+jZ9JGC+?=
 =?us-ascii?Q?swnU1lNEF1qquTBFNM1bgnrK//nhKkGF6Tt3UOjBE52zhylWHISoklnd38J8?=
 =?us-ascii?Q?kP5nanAvpWuUiMPv8p7pwWBEP3igRuXnuU9b2YZWJtHQXwc2rcmmITUoEFLd?=
 =?us-ascii?Q?EoVB/Zm/rF4CnZ86FN+zwVW21ixFHeXaFjnGdN+h/tMEAHY9hg1xjR7ReaJd?=
 =?us-ascii?Q?J8yHqgm8zazezfiUilZJ3vkIcE5OhAx17v8p1ggxIwQcTGnyCe+x8EwKbCbH?=
 =?us-ascii?Q?avScC35I2LfvdotwBWBlH2GG/VrYurFvtikLJ+novib1aNoPBrG57RzNaT1t?=
 =?us-ascii?Q?9TvhTsdyAkW4QnNdoag9YR9HQIitd8DRhIma4PVSn44kPyLHLP0fVC7xDPQS?=
 =?us-ascii?Q?/QKjU304A7hyxDvqskhulH6g9eJQRrpECWr2N+Sf9EQ0VBjpw0UM0Deh9e5E?=
 =?us-ascii?Q?1Aorj4GPIHpG+XBUw+GR/mIHDm4MJULbUd/xUFe5KcD8DA0+UnvI9Ola9+ZY?=
 =?us-ascii?Q?zlpDf/WOrNVpunYqcI5MdLQQgsVCzQ9ibg34/0w2/y/sJA+J/8Y20YuCy7Eh?=
 =?us-ascii?Q?58vFY32EkelIMxz89FX8D3wOv3MHli/jzZy7YA99F/CIPY9tV2iJiWdRn8Zo?=
 =?us-ascii?Q?2wFzvfAvvOtuXLX3s2RdS6bPBmpg2k6fC+wCZ1umnxBg01XHqLat6A2WV9BG?=
 =?us-ascii?Q?18a4U4U5NqW0WME18+FTQ1GR/GwG5B5HFAPLVD0waeie8EQBBsUil9MlYHXx?=
 =?us-ascii?Q?HM/+afdwmwBXG4nGglkD/6SB8HYM9iJ+LFryRFWbAGib5yqcVByzIjkrA6if?=
 =?us-ascii?Q?x/dVsEg63Id+Kci8Omd/N/nYnVSYHiMrTzAjBUvhcfhH3V3kqy/6ZhDSl5tF?=
 =?us-ascii?Q?XfldcyJEQLbnZxfiQF9wNTKC9azoaVIIlDG4dkCLHuN/znY6urlZHxV/MB8?=
 =?us-ascii?Q?=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 22786f91-1838-422e-9d70-08dc86927fff
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 01:38:15.0530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB8444

From: Steven Price <steven.price@arm.com> Sent: Wednesday, June 5, 2024 2:3=
0 AM
>=20
> This series adds support for running Linux in a protected VM under the
> Arm Confidential Compute Architecture (CCA). This has been updated
> following the feedback from the v2 posting[1]. Thanks for the feedback!
> Individual patches have a change log for v3.
>=20
> The biggest change from v2 is fixing set_memory_{en,de}crypted() to
> perform a break-before-make sequence. Note that only the virtual address
> supplied is flipped between shared and protected, so if e.g. a vmalloc()
> address is passed the linear map will still point to the (now invalid)
> previous IPA. Attempts to access the wrong address may trigger a
> Synchronous External Abort. However any code which attempts to access
> the 'encrypted' alias after set_memory_decrypted() is already likely to
> be broken on platforms that implement memory encryption, so I don't
> expect problems.

In the case of a vmalloc() address, load_unaligned_zeropad() could still
make an access to the underlying pages through the linear address. In
CoCo guests on x86, both the vmalloc PTE and the linear map PTE are
flipped, so the load_unaligned_zeropad() problem can occur only during
the transition between decrypted and encrypted. But even then, the
exception handlers have code to fixup this case and allow everything to
proceed normally.

I haven't looked at the code in your patches, but do you handle that case,
or somehow prevent it?

Thanks,

Michael



