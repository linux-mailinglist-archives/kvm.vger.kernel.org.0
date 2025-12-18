Return-Path: <kvm+bounces-66281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22CA5CCD47E
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 19:55:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 89FD23088622
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 18:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7377130CD84;
	Thu, 18 Dec 2025 18:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dWoZmUCv"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012057.outbound.protection.outlook.com [52.101.48.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A2D25A2A2;
	Thu, 18 Dec 2025 18:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766083927; cv=fail; b=azaFJTeX9TbZFjYt7x3r4fFS5KHJ9ZR8K2BbnQuXqVVx27BAGMw+0GmAiJiwzxeH7EwcYrL/ANmlEcd7X3pVPmi234C52hrmmXWxiV89b+hRVAwmftrHhe/QmM93yEfCWmbsys9wzxXJ7Yuu/ACiIMikBxfyImf/lV8MSBsQ4eo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766083927; c=relaxed/simple;
	bh=vM9eXY9+ek5POYA0n1R9rPVtKc35bo1mhwWs6j8Djbc=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=qR+WY34SnPJDSoib+nMq9h9Pj+LPCGQJuSlOe5zzicnNuuQseEU0PGxbi3HwciGMJ2k0h6clh3p0cOc+TxeSnXQTeDh+JWG0uAvuKjUEng/A0Nq70TkRqtcmqoc9Iswhmyq33qNvS8bxfFy3Xi3uE9PZV4Yi0ehfOd4b83t+qrw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dWoZmUCv; arc=fail smtp.client-ip=52.101.48.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vV8/HmHcwCbbS6h+Y7LE+iESL4ARmCi9QUxqUxRZ94Df+/5LJJHChuJMbHhNRzoVAZiXKGCvhGVqMIO9TqhuTT6sr8J1DqdwwPgzheOyIOYlg2Byvk3Dx1Vd/HqWrWKUy3dMYcWE4oOiv/baSUdCnn9wFAnz93J0KFIn3eNS7A62J1XrlLJ0ALJn5WRoN9C7ifBjPPM7T1BPcS9ys52VaGPdb2k78SjU1YNWC+jW96baUSgpMg9MMNRQyNk4b7YpNveK1gFupaO7iQvNGTYsXqwaFdRxp3wcOPSJKAhOW//2u4g9/ayzl4zD+jXAGzfS1zdRdWlNuiLxy1BAeVvgFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=97DOY2lo8/L5zD8vVkX0Q1t9K3yAUE53e+CrUBMUXV4=;
 b=WA/x8nSmfud9pwrv4CXd4QWsWzu3x+8aADRl07qj1TqxhMmS56vBioB+sBK0xoOWjuIRv+aCOf3ogNTtZGdWqsoCiE8917nxm/n6Yd7TYskkLnJtQV4H4b5UfQlszDW3twkfsqYy3Ev5EH+1vm6IhXPllGMOlxDu2yimbGT79AGT1bqY353RqIwd5COqpz7DS9ygU5da9Y0+3kgP8CgleVE9XVoKRswmePvanxXZWnDJdGp0PTpJbssBJ76OmssiTe9ukF/QlxLf8+qhqqZuuAoBePt8WeWCbtSBG0Jk9cUv/DLnmxiuxdeFlU0kJOZf1qtJT8MxyJ1046AoTmjlSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=97DOY2lo8/L5zD8vVkX0Q1t9K3yAUE53e+CrUBMUXV4=;
 b=dWoZmUCviCxXkYa31t9u+whv63nguzzTXGJ9KerRuyyn2zADsd272slmsnsY8ZNgW6QH1p7ir6Ti3Ibjhh/BleLZS/FciFVtq50CRv9ZFPx/Q3csXjruqmc1fnydJRsEhqQfaHen6IiYp6Vx5dJBC5mQTrwZbv2swv402LgymT3q6PblRhrekSD+oSCGnu8kOCC0ilPB8gC7OGwX4zTVMHfg2ru/e1YMbAMXn3boYfm1Qzb7fQeT0pg61Dn8RfsGEHhzhlo5Sf1fCWA56ZS6gSbL5JZ0+qTcDTJP5ZrU+GhGJTZ+ULHOAoJz1mjbHKcWPr/Fpi/0FJFFHHEifX7grQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5974.namprd12.prod.outlook.com (2603:10b6:510:1d9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Thu, 18 Dec
 2025 18:52:02 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 18:52:02 +0000
Date: Thu, 18 Dec 2025 14:52:01 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20251218185201.GA308224@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="legah0MbMMhJeHHl"
Content-Disposition: inline
X-ClientProxiedBy: BL0PR0102CA0030.prod.exchangelabs.com
 (2603:10b6:207:18::43) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5974:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f3846d4-5798-441c-56f9-08de3e6687e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uWGJqU3Fe19XGn0qfLL6vAxLkeuS1QAbAoPAd7s8G3GEuOyPoW5eruvOFnV0?=
 =?us-ascii?Q?AuNygxopA7PQc/F+I/xWlmO93g3mwU8LyygT4h5tvXTgPpbRxJjyP1IHKT7V?=
 =?us-ascii?Q?NrZ+hGin43DPyDsK+ccGzNMuqvkqTLbWZBHcOL6PZ5RO6krz2AKY2dN8+bDY?=
 =?us-ascii?Q?ZDTwbYCBqXpMzbR2NkZGJ9vm+61BGOoTt7PFESLrgePQIkffjLBeCDyODhr6?=
 =?us-ascii?Q?lMFmr8riY8P72maB/wyBDbCRkzwZmfQsFQ1P8uVA72PNKUORiHpgX1jCGT/8?=
 =?us-ascii?Q?m9Sjcio5RAr2KWfzoqvv0R5ZZjQSK3napRVQ28mPBWxEI39mmv6jjLQpPxK2?=
 =?us-ascii?Q?SYserpbHMGFMuPepDTG1xT0tIW2gSvu8J1WbmfKlTeRYVqw56jG6V8jpXqn5?=
 =?us-ascii?Q?FXPkzBzBm/UTdBbhSboOhzyVqU7ubpEV0utRDVnygTpq2Lf1Fl+fYb00SuUp?=
 =?us-ascii?Q?6QgbGuwe4o4Popzz8rgqtYuB0FbMpmKXgawK4LiA+8EO0fq7cqQU3AI5o6i/?=
 =?us-ascii?Q?HGp2sNt61Yxn9H8Y2+7L75DaoZjJP+TLb0VsoDUiU1gSEcFNU+NCdllWbrLJ?=
 =?us-ascii?Q?RJlxpU0xnqgyW++PbKwI+quebNeDfuUmEIHh89pb1CmSeprv3Pu3Mhwr4Fc/?=
 =?us-ascii?Q?WBqXUmfl7nVANvNkycjpRvqbXnNBLQImy21ZzJxp4DjSy2S66oGFz8M7EDW+?=
 =?us-ascii?Q?a3qGKemWVQmYf+/YkybWaJvFSODhM7sgdkuHFb24fyd6GErRTjQTmviZ8+m8?=
 =?us-ascii?Q?+gsqvQf/07RnvwLMMDT3YZjpbRSlXJTWHp0emZ+tgPg/A17nQkgBWHq+Pfjm?=
 =?us-ascii?Q?/wqdLJA6X1Y0Mmhv6mGKSI5FolMyd8QCQoJ2IaBmKcKY426lr9X7Ek3892CX?=
 =?us-ascii?Q?0h7TiiTSFTmDaoecp6/0Usxfhqe7jhUeR8RQyLIq0ZFIEKGnUXnK4Iuf+isF?=
 =?us-ascii?Q?kRKVsn+6P7xEjNFpWihCE7NXmeD2s8Nol++KywDR6d2z8VgWZxRk6iBA0cAe?=
 =?us-ascii?Q?cpNdp4j2ymGnRaUPzKA/VihJLAz66C2mUGUtIIp54eODF5EWgtMSt9YNQMi+?=
 =?us-ascii?Q?9RiywmiK/fjkHFMPhsYs5IdYT5po999Pu7sArvwlIGqOQIBeB0k01EIzn6u/?=
 =?us-ascii?Q?uCl4YlVU4EH1YxO74iX1zf8clH7q0DJpiZSrxPoqHovdsUhssafKXY7smZWu?=
 =?us-ascii?Q?vGXoSEckHqfttn81r9/7KmWhoh8bvZI86IqhJhEr4L6KbKUjBak7rtJv1GpS?=
 =?us-ascii?Q?Li7AOHNGLykySDIHVCVGvO1M/AKyV2/8zRbKhnW0z7qHQIddfYclkpeWc2ys?=
 =?us-ascii?Q?gGNZfgNy2r1EnFgqyIV75TDKIwH376dmTDm+7UGnTG0oCZk3Jit1+247lVvs?=
 =?us-ascii?Q?lwmGxiBbPVwvT+ZcWOLRTD7cHtPeSFZ2Tm+rtyUcgwYXGw/FISlpVk+8uyxT?=
 =?us-ascii?Q?ygOvFhVwUefxqFgJ6AjAYE9o9JNVizS9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aUAY/rkciDQR0wZa5OoEiIdxLA4HNR7+2GWxU10C3D91lKgqzT4XlaEdq7DU?=
 =?us-ascii?Q?nJIXearA9ACl1VxSKMRYWViUboLpl73gdP9o86ZGp6l7wJ9eaKs7OoyYb64v?=
 =?us-ascii?Q?u7R5dTHmw8Hgnk6QRV++Tc1mi77hUusLpbR6qIrrq9ZFRMJw14MyAjKLLZ4Q?=
 =?us-ascii?Q?wlOQGm6pQQaCgvICrMQDnlcLq1JylVJsj+N/R/EQLTRTC6gFqjY0IYhCCxAI?=
 =?us-ascii?Q?sUN0VUz32yrYLWjEdvZACofE9w3SRmqKj1HfUATRgqtJDGG4CPRimewVZ08h?=
 =?us-ascii?Q?zK3bllTMrYYaqn7Z4DbJuRmFoMDXuZE3+Xv0XaQRc+e0xxsAPa7xXzH4HP8F?=
 =?us-ascii?Q?CH8AOOb5HSsS2IfGwRqlneY+eFNQAbGnvlCa3ZRoTpHft5lsPLg4XrjX9DQM?=
 =?us-ascii?Q?6efpunzK0SpevOQtetJl0W7obtvJDKLyQ6HgRwDb9KMxgN3YccJaGVyhDZ6V?=
 =?us-ascii?Q?LYHEIJjw3Adw8W/MkV9nxTGGnmWptS31FtSdwluuru7/QzhDeUMNcg56hS+f?=
 =?us-ascii?Q?5iNftCNvn+T0ZfOAa1yTRCkEhWvUpED6movGqTBBtScpPK2mygU/QbjxfMcG?=
 =?us-ascii?Q?JdH7jprMLkM9+dTcR8ropiHA5Px1qggQ65Z7mJDMQlx+2nrRT5rwmZo6QjXN?=
 =?us-ascii?Q?LMLRl/Vclrp+/j/gZgy+Qi3/UGYXQucPBn27VhsH8gnRdCOgUfqnT2k2GoW7?=
 =?us-ascii?Q?iC+FPHYCkP358ZosOmXDQNTSfLL5XG8F9sFNUwPtOUEFDvImKeX28hiV1dxa?=
 =?us-ascii?Q?SHbQEmgBsasdBIxOuQoxtCHDH3ciFD1y8aaAIVNbDgvM+0ftjhg4RBaCgNc1?=
 =?us-ascii?Q?fQkyzG+fk4cSm/kk7fBB7ozQgoevWhxdlJU5h/Mf4gIGp+Etuf3ctD3DaJFv?=
 =?us-ascii?Q?l9lZPbAi5w9bAp3v/CDxepFn1PCulNy8m8Cuc0NxepZC8tcpnaCguvXWqnvv?=
 =?us-ascii?Q?UX8CRa0mwHaGgH2QLNxqJulDviWJYpD+kHtTRwEuM+8o5vsTa5pW6iwBh/WN?=
 =?us-ascii?Q?+KZQLcx0B6lVSp+1QN7n4yY6fC0LmGi/fa1dlqmdj6vBXpOh84JrfCbggQS7?=
 =?us-ascii?Q?hBA2QjTDVX48INV5tG6P0U/47VtFd1E7dGYgDkVaMvoDjO3InwViF6+nUzOv?=
 =?us-ascii?Q?evdu4NEFutdVeQoVYVCR7lZ2Fj9zQXOTnsH/6XxM4BWtcIJ6UEc69HDzv/bt?=
 =?us-ascii?Q?ct9H5KdIrGoUeJZLF7155reK8DcBqYyNmTm18WU+efDsFQiRe8fkJU7cCyXG?=
 =?us-ascii?Q?qMcHtT8tZM4Uhdhr2NB9CudirxRTFyp2UBQYaZsZnUyz4vXEII6SCZHHgxwr?=
 =?us-ascii?Q?+QJL67vUCftShb4LCox4vVafn9vw+I102NK8bnhEaYP6kUuaFBJbehib82zc?=
 =?us-ascii?Q?usByKS0hGJQL81Fd5oHkzpOaLoECUV0VOBINRD789mzfDL1iDkRWvfx+0fan?=
 =?us-ascii?Q?dlIDA6+JAwvGERQhewJjTXEz0ihVb6B1kIXexKKIOAl0PjCbLKlPGxM0CdMy?=
 =?us-ascii?Q?8AZMbFJbvcy+Uds7bQr0yympLApyyAUVzVyLwT8OSpOXaCZfr5B4+oVkug7t?=
 =?us-ascii?Q?CmFLQ6uobb9gh2wBTa0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f3846d4-5798-441c-56f9-08de3e6687e9
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 18:52:02.3481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GUQPrpdrRI2RJrSWnf6sTIfVVVpefdbY2PYjZAwN1vAptGm0fPxsexJMJ7PaOZ24
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5974

--legah0MbMMhJeHHl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Two fixes for the selftests that syzkaller found and two compilation fixes.

Thanks,
Jason

The following changes since commit 8f0b4cce4481fb22653697cced8d0d04027cb1e8:

  Linux 6.19-rc1 (2025-12-14 16:05:07 +1200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to e6a973af11135439de32ece3b9cbe3bfc043bea8:

  iommufd/selftest: Check for overflow in IOMMU_TEST_OP_ADD_RESERVED (2025-12-16 11:53:40 -0400)

----------------------------------------------------------------
iommufd 6.19 first rc pull request

Few minor fixes, other than the randconfig fix this is only relevant to
test code, not releases.

- Randconfig failure if CONFIG_DMA_SHARED_BUFFER is not set

- Remove gcc warning in kselftest

- Fix a refcount leak on an error path in the selftest support code

- Fix missing overflow checks in the selftest support code

----------------------------------------------------------------
Arnd Bergmann (1):
      iommufd: Fix building without dmabuf

Jason Gunthorpe (3):
      iommufd/selftest: Make it clearer to gcc that the access is not out of bounds
      iommufd/selftest: Do not leak the hwpt if IOMMU_TEST_OP_MD_CHECK_MAP fails
      iommufd/selftest: Check for overflow in IOMMU_TEST_OP_ADD_RESERVED

 drivers/iommu/iommufd/io_pagetable.c    |  6 +++++-
 drivers/iommu/iommufd/selftest.c        | 14 +++++++++++---
 tools/testing/selftests/iommu/iommufd.c |  8 +++-----
 3 files changed, 19 insertions(+), 9 deletions(-)

--legah0MbMMhJeHHl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCaURNTgAKCRCFwuHvBreF
YQxZAP4+NjPGHx5hQrnyvLMospYIbjt6P8Y0CbuzUeSuzOjC4QD8DD/B33PHy5Ax
Dseu0cZSVKeBU6ri34Ou3p0ec4MWfQI=
=lcop
-----END PGP SIGNATURE-----

--legah0MbMMhJeHHl--

