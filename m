Return-Path: <kvm+bounces-70180-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EIFsKg0bg2l/hwMAu9opvQ
	(envelope-from <kvm+bounces-70180-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 11:10:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 14421E44C2
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 11:10:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 27F21302B397
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 10:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57F663D648F;
	Wed,  4 Feb 2026 10:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="cKjBg8EO"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013008.outbound.protection.outlook.com [52.101.83.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C767C3D646B;
	Wed,  4 Feb 2026 10:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770199771; cv=fail; b=QlA+r/ly3Mz86KLS84O8m+8DIwRxullPBPN1y/gjKLUOELo0o9JJsKxilfXUJan3Vea0LDPTfs4C3f7zQxAuOPgSaGSbWBXG3KNLs9ZwEInaj3FuIQ+ePo/zc2slNCmkVxLM9L/uf/NgfjFr7c5z65oN9hg7ubkEgYJCR83l1ec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770199771; c=relaxed/simple;
	bh=Rw8UfXek+tJrnwhDpXp/herfwL7FaOl0MxKnj/1mZqk=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=gvQk62OPQ9l9+5gbsxFEW12OAY1DX4x5hqLwhnBd6QWtQ5hYjnchHEKNTq2YeO8e2UOF0Ua9RKSL5gcMVFft4VteYmVhyU6vTsTEBGNcNWssyfeYRvdkaSlJENiEaic+VeQCZ2glXA1qDKDp/Qz6GEYGlfLrwo7H+jHsYyg6Rp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=cKjBg8EO; arc=fail smtp.client-ip=52.101.83.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gAo+TJW9zekTbhRNKyvtiRdR2yX5s3qYA7cly7iDzDjFG654wfVT3lYOTjFCG/CDP5CS3DeK9qloDJnq0rGoaWb7AnhvTWm+GSNsBnr6wcOKjLOJXvADBkxsVIwx27t4KXsGuEbnZ7z/PWl34Fr2tpWD6bIK/Kw/FHIjBwgxzfUUX0NaGKJQSuPZu8nZoHOYyZK1Ms4rEbXqX/qf546b8YNejeZJtyxqjmNcpouq9mp8IBTDh32n9Z+8rzu95LMWJh+bSAQVjU/PaRPejU5eeaSB0+TR/TD4WyrgfHPSUYw10+36BSzaqbEfMF8bOM9SSp1dZICUOyUaeoUHsmK8Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gtILn8QRQYxZp5XPFmYQWCI4OGUVSNg0whYhorGp3ww=;
 b=E3uZ+lLW3yYzkL5SD4mSvNku7dYNkJJzAS2vilZqkp1Pw8rrznlgNPxdlO8GuXjuyZK2MfTxmo+JUMrnG4KcDBLEDSs6//w7R9kTAzxu1g3pWwcGRfr5aeMuNu+ha9tOBxztwqNqeUzB+tHJn++Nwr1C0ZBykEGwQuDPcesyMzgCby10NXKT9y6k2M01HhmmheMw0YgxA+ZlIzxa+ZHO02z43YZlfcwzQiNLL+DAOqzf1ApoQpPp8KqWIahMgSvhLmywYAgJ6HU9DGm3TeNOs1/FS9/bawFhRJmzgay0oqYq2Ud/8SuCpCUxg4jXGKpP4Wq8+MipGYW9NtfrSniaZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtILn8QRQYxZp5XPFmYQWCI4OGUVSNg0whYhorGp3ww=;
 b=cKjBg8EOVmCPCimrGlDBpvUhrcog/pqVx9s+RgedIFJgaaEYAI6C8ty/+71h9TvT+NOpyjr9pG2tuViUPZ/Pnl5BveM7vrPyPcJFHaYbtOSFp1NogZ4NDRqB4ZqBohZ5NGvIh31LBCqC0uRBxA6jwzLTJ1+eeTD6RucBbEjTs2oDCHupiCOvZwD827s5t9k4G59Vo+vn4S+H/zuM4cFihK04LScsNVeBVbPc+k5uxBJgKuedOtay18RfsPoULGJ9l8HypONzwmlcNVgvSoD+7gU2qSEM55gKM14/JMRviFcbfUfZwHVuKMhZBlunBOfNrIvEOP0gGNImO8R/q7rlOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB8253.eurprd04.prod.outlook.com (2603:10a6:102:1bf::7)
 by AS8PR04MB8867.eurprd04.prod.outlook.com (2603:10a6:20b:42e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 10:09:28 +0000
Received: from PAXPR04MB8253.eurprd04.prod.outlook.com
 ([fe80::2b4e:8130:4419:d633]) by PAXPR04MB8253.eurprd04.prod.outlook.com
 ([fe80::2b4e:8130:4419:d633%3]) with mapi id 15.20.9587.010; Wed, 4 Feb 2026
 10:09:28 +0000
From: Ioana Ciornei <ioana.ciornei@nxp.com>
To: Alex Williamson <alex@shazbot.org>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] vfio/fsl-mc: add myself as maintainer
Date: Wed,  4 Feb 2026 12:09:12 +0200
Message-Id: <20260204100913.3197966-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P192CA0013.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::18) To PAXPR04MB8253.eurprd04.prod.outlook.com
 (2603:10a6:102:1bf::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB8253:EE_|AS8PR04MB8867:EE_
X-MS-Office365-Filtering-Correlation-Id: f6a79d84-8856-494c-66eb-08de63d57b1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|19092799006;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MZU7hYpjoMvIeb4oWJs8oPov625GPkp7Cb1lSd4dmUgoTICQ5a4RMlALN1BC?=
 =?us-ascii?Q?qaM7d3/O+N8x7NbEGAWjmFnfkJ/nbHhFyveez1X/r1vp4yf7Q4xIy8k34L6f?=
 =?us-ascii?Q?XOccL8MS2/SQz0LQ+QvhOrhD4CK6KuqNxelDbNVnW5SNZFm8vdBho0Kw1YoN?=
 =?us-ascii?Q?/gofXp+4FfN5b/ROO4jQVlgEHgWS6Ry+6ZpdWESgoOw/H8d19Ra7Bc5jL3Qh?=
 =?us-ascii?Q?LtaUk4LV4szDWl3CkucGrVOv1ScSyetm/3nUv+yWgUL6NY8eRg4bHHThaxJ5?=
 =?us-ascii?Q?vlYwnCoqfgWzDHDhTo4IEnR+ie9Wj5AlWsWrfRXjBhCiqOXuZseH6qis++Ad?=
 =?us-ascii?Q?PJtJwQW9fJdT4tkiu/9Jogmft3jMZr5mzQxWf8Q/59e9hxnQx6XPZ4CgTR6B?=
 =?us-ascii?Q?l+vYUyV9T9ObJk3l8mfjgBXljRL3BDfBNv5cWF4ckYm9kf6XN+hsYSeJM4p1?=
 =?us-ascii?Q?DYMAUDKMvUwYcovIcXMJifPd2L7xoWwuEpJ2qrBCXHKMvAS3RCQ6j8OJQTPp?=
 =?us-ascii?Q?vSsKq4T+tma4IN9XikMsl5RJHPWY5DAmWf5jBHInd2vOMl3bc82DLVz+TBFK?=
 =?us-ascii?Q?Fy2OCmoh3AREU1Jm7qlrRIDO9hU50yQBA2iABXZTHgo3tJL5vPrgWT3jgv8y?=
 =?us-ascii?Q?YQMGkph6MD3L6bnhxVVrT3u6O/WtLp839V6EbNpjx+onO8IlWNgxw99dj3Hz?=
 =?us-ascii?Q?MUAfhkk9KEKeZO2bLGiITbG2KTN/Nt3T7d9cqrrSiPb3dxdJvdFdVdPSg9vy?=
 =?us-ascii?Q?XOVmyzwBAw1Gv018RyD1pwkY+SnUxgx9FmIFpMxOui5Nmq1mesiW6aN6qXfb?=
 =?us-ascii?Q?1tNs79WedxhGi3wuADJGkXjXkB6ftCGj88E3bNYfh9GHfxUumFREOBS/lT7d?=
 =?us-ascii?Q?c+6duc1mIj6sov4zfj94/TQfKbtzC0wjxj2Y1WLKnxmQjrKOv3blE/+28ddX?=
 =?us-ascii?Q?RQEHdjJHMbCXKkzWalQ21It2hMTe3Jtj4OsC/HL+vqMnUKizMvs18J99fFPg?=
 =?us-ascii?Q?VA7GxHWhEa4nYmPM3V02ysMcU9+zFlO0CKp+Zfoshjkf2WL86Q2Tbzv8coqj?=
 =?us-ascii?Q?sFt68ecVJeUxpfTGznGxQbs6XZR/6ZrGmjSQmJN6B9TvZTglglIV3J2kkiMO?=
 =?us-ascii?Q?u6oMjYmEhHcfuda8tu0d62u+jSySvZjQoVsqpIqE3XKsY2SuJpnybhlTJrQP?=
 =?us-ascii?Q?GfwUY0EizzeohKydYqg9VTO85QpmdTxfkGX4R7smig1IpIY8SHINiYw4S80/?=
 =?us-ascii?Q?lpL2r46a8i90RKTW532nLbyKW8/Is5jAV8OwFTAC9TYkK+Q6lj4vYSAp3zz/?=
 =?us-ascii?Q?twpgC+IE7o1sz0jsNLBUKDFtnUlePpIG4lFFwUW1gF8abzHdY4Iw4ADupooi?=
 =?us-ascii?Q?q7t3qeT52IcY+P6yugRuFef/F/U2WFPQgj2xNm7IxivjR/1iE5fL/WZSFKnq?=
 =?us-ascii?Q?5aYB9p7PInt7TTHF3lW91/pKvhdBobvbmSUDz6xHuiivtQpXy++GzT2BbW5n?=
 =?us-ascii?Q?s9u6XGLiZ5ojBMamYs7HIop/g0kIf+wP+2aMEFzocymD05auKPBe9W1bpw/e?=
 =?us-ascii?Q?/z2BWJmReUgjUKoTGHU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8253.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(19092799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0GfAtPeUIQGHJ8haKjhsaBwZCrLE4rbac7Dx1joDKf0M3tUraR0wqIFgQhBF?=
 =?us-ascii?Q?TMdPpFS7Rjdz0KjFjLoQCOiY4yTqq2CYGlIZ9EdCNt49BQVU4CDPPoYaX3jI?=
 =?us-ascii?Q?XskeNibXSajQt+J/nor7pwN7GWkfpDBGgzuBCBsrAQVEyRf3sAvJs1vNX32l?=
 =?us-ascii?Q?3ssR7fN/WXX6haj5FcxFNIJudmAC0SXT7pdYbTYs2DZ2u4XVze/S9ICVcOJ9?=
 =?us-ascii?Q?qaoAyOLDy9eyeML52gmRBOiFMpbZVc8l8hLjzN07dBkVR7rRra2NN2NTW2Kv?=
 =?us-ascii?Q?AgUR+9iFzXkqcJDjGCgK8+c038WabX1KzZ8Sn75rBBZuBL4COBcRZ3lN/X3m?=
 =?us-ascii?Q?P/0+PkUPdOqM7iDBAaUqu4vPkIwP6Vw1wHt9Ab8YFbU0eLXIXI/dZJ4v1/Co?=
 =?us-ascii?Q?xYnVZGgNSgHqvmeJXSEy1YB4J8ulhT5B3QGxiA45eiJGVDJw/cZvxEg9cgvB?=
 =?us-ascii?Q?vomuobs5EAqQK0m8hfT47Y0WtmCh2qybEbKQ+lifntQFyDIm9MY/A5znq0M6?=
 =?us-ascii?Q?RWFqHWCjx1YLfxLL/X6YM2CcaHAQy6KHzomLzY5WE7S0FX82K4X1ae/Qy3Q3?=
 =?us-ascii?Q?DXqtRgNimZgSNVfPVaAqT3xpCkz+oV7HdL37ITbP6QgbvMlOAcfWfx/AdGTG?=
 =?us-ascii?Q?YFuejVZZUhi9Tap/PbY9Rsk+2ifOZVq5q7/7W7AZsQdtgICqR2u5WK8+w+Qg?=
 =?us-ascii?Q?YfJLmYSTqTgAqatCG+xWUNKFvNya6Af7nniirlRTvtB6V/6ehMMWQeLH5E7f?=
 =?us-ascii?Q?VDBnLAbksu288qJGcrWkdIBAvZQqPE94Ujp8dK8uwyNq4qouDtgOU/pxC8wK?=
 =?us-ascii?Q?Mp9tQNF3atSCTTor5hRYErvqvp1doeOS5O36K9G5LHmDgON1IIwn4olXloR+?=
 =?us-ascii?Q?RtSw6BMsB11NUobX0tJTffsfjaYTpZApFWRkhFzQ8OYCkK89XyHyB0Xl1asx?=
 =?us-ascii?Q?pTipwfgH7iq2QCcwxiB66/kq4C5oCqb0jkXNJZJ7DbHGeSbmaNCAICfYJ+7h?=
 =?us-ascii?Q?x/KnLkI4/qSXnlHKZ/ufGYhTbVuPW1VMdCbwjhJ4W9/KCCuaKYHuenIflURE?=
 =?us-ascii?Q?7DnHqwrhPSKnsVIwIoVu/FzZGXHZlQ8/1oYw50/QoBbbPKBGnw8fw1ESqqin?=
 =?us-ascii?Q?c/ixpTQa2nJSS3RYcd3zHUiYjulvzu/D4Ocnqpw8lZtNFJ0Ve5bU/PLIIShu?=
 =?us-ascii?Q?azXVkZ/Z+0cjRFi+dv8CpsU+Yzg+E4F++2RR7U+QLE+Bngpiree++RcSy8Li?=
 =?us-ascii?Q?m7JREtbguMBMogJitwcakp/6wXCjFxZyRPue0n3/yRAcZ9OCr5oZlJd4hg6r?=
 =?us-ascii?Q?bw403hFaHT/efvEaTKT5nvqJCMLxGKI7sQyAj1R3QeJqJu6pgKQCh8jyVlEm?=
 =?us-ascii?Q?CiUqNYgRCaUClV8lsIFtdQQ+iUvx8aCUfmKrzAKYznA+a/PxTYpiCfsvscZu?=
 =?us-ascii?Q?3nEloyoMNT7AGfQAj5SbtGwR0lmHEeUukapuRxwee0LUdrOV0jUdl36ON6HH?=
 =?us-ascii?Q?eQJkaSDxrxvPy+XgzczNDyTg4qACzGh6qVkz4HCyRThEpvA38uRFgNiFhICe?=
 =?us-ascii?Q?awQTAJ3/EWZnWVguuBXDWOn4rCUYYgCNlC4N2L6RAGkyNZT7Q4pqiU+gmrmw?=
 =?us-ascii?Q?iff+3XbnSRkMEBBYzONtVjJevxKBV8KJrSKFH3fmf2QqMMce2I8xlyFfevcC?=
 =?us-ascii?Q?8BJKpDHlOjdHsjnPCh5mTahkQaBQa7NdLs771TOlQol2w95hfIxNoFXUeM9W?=
 =?us-ascii?Q?KjHDX31hxA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6a79d84-8856-494c-66eb-08de63d57b1f
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8253.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 10:09:27.9706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Amj06SglCwL3c3xPHsKcIZjphQnAbDIlNkdsO7IzFFK6FDk9IOlSE0MndMfYN/PYOmM4Tv+HTgSv+I/IvsGEAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8867
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nxp.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[nxp.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[nxp.com:+];
	TAGGED_FROM(0.00)[bounces-70180-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ioana.ciornei@nxp.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nxp.com:email,nxp.com:dkim,nxp.com:mid]
X-Rspamd-Queue-Id: 14421E44C2
X-Rspamd-Action: no action

Add myself as maintainer of the vfio/fsl-mc driver. The driver is still
highly in use on Layerscape DPAA2 SoCs.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 MAINTAINERS                       | 3 ++-
 drivers/vfio/fsl-mc/Kconfig       | 5 +----
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 2 --
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 26898ca27409..66882df493cc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27677,8 +27677,9 @@ F:	include/uapi/linux/vfio.h
 F:	tools/testing/selftests/vfio/
 
 VFIO FSL-MC DRIVER
+M:	Ioana Ciornei <ioana.ciornei@nxp.com>
 L:	kvm@vger.kernel.org
-S:	Obsolete
+S:	Maintained
 F:	drivers/vfio/fsl-mc/
 
 VFIO HISILICON PCI DRIVER
diff --git a/drivers/vfio/fsl-mc/Kconfig b/drivers/vfio/fsl-mc/Kconfig
index 43c145d17971..7d1d690348f0 100644
--- a/drivers/vfio/fsl-mc/Kconfig
+++ b/drivers/vfio/fsl-mc/Kconfig
@@ -2,12 +2,9 @@ menu "VFIO support for FSL_MC bus devices"
 	depends on FSL_MC_BUS
 
 config VFIO_FSL_MC
-	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices (DEPRECATED)"
+	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
 	select EVENTFD
 	help
-	  The vfio-fsl-mc driver is deprecated and will be removed in a
-	  future kernel release.
-
 	  Driver to enable support for the VFIO QorIQ DPAA2 fsl-mc
 	  (Management Complex) devices. This is required to passthrough
 	  fsl-mc bus devices using the VFIO framework.
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index ba47100f28c1..3985613e6830 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -531,8 +531,6 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 	struct device *dev = &mc_dev->dev;
 	int ret;
 
-	dev_err_once(dev, "DEPRECATION: vfio-fsl-mc is deprecated and will be removed in a future kernel release\n");
-
 	vdev = vfio_alloc_device(vfio_fsl_mc_device, vdev, dev,
 				 &vfio_fsl_mc_ops);
 	if (IS_ERR(vdev))
-- 
2.25.1


