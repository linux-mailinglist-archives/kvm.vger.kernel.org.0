Return-Path: <kvm+bounces-66350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 75128CD0A5E
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:56:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8298030C2ED0
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 15:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B503624A4;
	Fri, 19 Dec 2025 15:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EdQLvNEK";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EdQLvNEK"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011059.outbound.protection.outlook.com [40.107.130.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7414361DC3
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159628; cv=fail; b=mP8V2yzKIg0jYlOonhCE3984bpelBOIO2emICflUzLM4umkK18lY0dwG7DVTGAuftrUDamMj/eb8sh/N3BS2Qmh6JBZAD2L/OtLiMpyBd4INn1mB576BHSWnYT+Q0Q0Oc1mBDaha/NskDNjScDiM9iqpWh1ig4c3eIq8HlpqVr4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159628; c=relaxed/simple;
	bh=iqKoVDpuBU7VNB9pUL8wAVUyCjd1XuqMZsFXC3bwTqw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LKrbXUOH9NvloHF3oULf6i269iIaRs8HIpEnoRPZ1fvLxwOVAGN0Z64UxZ99ppeaSrUo/uK/nIgsQ5fDn5trYBdVaeRuKzBsJRSbA+ljKGO6/gcG1XL2d5vcKGWPUR86GPwG1RoysZV7dTcMnxvhut+hEeSe5zhogHTY+O+R9NQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EdQLvNEK; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EdQLvNEK; arc=fail smtp.client-ip=40.107.130.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=c68NhsGqB9szDEwWI8Cp5O5skAt9zuFb6rfYT5fwRGMTmFpZXu3/F17Uhpmgb+FA0YMwro8BdzKlf3lT454bLiRS8ASBCy7AcLeQGWUUJ+CYsRI54NMKEGttbZIuTkvZeqcX9OPyvSMxXkcMB9i2BumbIAUsMwlTUCd8a4sfKViSpCM6nj2qt9wSuchZ64fPUccj3zH7yWM+uYiu9WP7u76Nd+kNRAMeMHYN58AbB7vSSnEd3AObG53hI4EfWqwRPrxlUQG8oEPCPqY/3H0WbDl59JB3lt2WAjYhO+rdyEqFt+npR7fJVK29fWT1YgWvOHmk/8P0uPCmqZpPPQtSeQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HsK8Pm1dtDkFpvMEUzRWeR1FO0STQ+buo5NwvJoTPN8=;
 b=rNQoZ5ttBGVldylRBtKk4+U/0yUGAey+ZTwLroQzy/f4wlbs30+4oU5lFoAXNsmSu3usUXBEVYtG48Zm4JN8UWBwfvJL2II4M6xiZ6F78NlQFvmuLNaQS1Y5zxvtC5a3i/DTkPGrzSlOM4sWz59YepDOi6mVycnTxxARyDqZU7IuJkASv17xiWnHQzYn41vm3D/OiDWe+WeYU+zHiEhbiM1ce1hyjA8lh1wvTPPPK7obwrRoEyxsVaBPqoF1GRJ9f+6fT59k82ndPK72EErZv545A379WbUp8XfsrQRov0B/DJqoFeOgaYg1hD/haAFfMRFiznnOlWMZgkRLTr2W6A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsK8Pm1dtDkFpvMEUzRWeR1FO0STQ+buo5NwvJoTPN8=;
 b=EdQLvNEKMVgAvRqk27KiGCBHU0mKAI4kOhxvblvtRXSnIYwECOf0lR+sr3MZYfWYyJWO02VQfWvWl7f0JM0NvMHSUXMeAdkse3bcQF5rxlNP1AQnEeiLd4+uUfD1Vw9+hdTIIoqqSUT1FWfOOp7xn6WyzU7Ar3C+OP2JE3UCtpo=
Received: from DB9PR02CA0006.eurprd02.prod.outlook.com (2603:10a6:10:1d9::11)
 by VI0PR08MB11823.eurprd08.prod.outlook.com (2603:10a6:800:324::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:53:40 +0000
Received: from DU2PEPF00028D0E.eurprd03.prod.outlook.com
 (2603:10a6:10:1d9:cafe::ec) by DB9PR02CA0006.outlook.office365.com
 (2603:10a6:10:1d9::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.7 via Frontend Transport; Fri,
 19 Dec 2025 15:53:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0E.mail.protection.outlook.com (10.167.242.22) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 19 Dec 2025 15:53:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oJtVt+pHkRcGriMMieP42bT9YVYM4xoZBAReQtc7wO96A6TvJrPDfqJxecaxCKxxFruolk1wfMXun4QKGn/mBhXPVnp3cmzdrmTDDyiYI4Ls2GUH5JUdJ6rGUmUrsdxM09/QJ0+IoSLO4PgWQvdk3LyCg5yXX5WisyEw3zi9oWK6LWfv209XV0EvkM2FHHSEMIsvno3BIPeq8CnvQa72cOeBB2hjgf3K/7RDGYbqwCw0hMQup81JIokH3b8ckz8CUaJAmzAbqdmOCb+tnnfuW3rqLjJs6q2/v+qEHecNmFuAXjpqaqKVju/IxAxnZfCEWND77k0ei0unQqUaw6nY/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HsK8Pm1dtDkFpvMEUzRWeR1FO0STQ+buo5NwvJoTPN8=;
 b=R9+ljEkQk9Aby/EQKsyU+pyaeZdUPuPJ7L8pyE7mRc2J8jrNd1o9AMZ952cibclt3kIPZ/Oo7714PSi8yErYBbvIN1rvV5Us9bG5nYt+Gwcd/XzjPWK9DY6vbiTDtt8p9d6RCxL0HtAzRxgj1FKqQA5S0uKQgl9O28/sZUME8lP+B3kB+7+DrzGCLmwERA+Y/gCjk6F94RpGO35cP2NmzT+9yPC5j0l1QzSwm55PjYHR0VNbRYrLj1ddskYeyIQX/WWs+MqFsbg1OgMWn4F0dMofww1JLBwcBvjDF3/gr4oWnRcZaES3n8hx8KZKlNDjMSItiVenvj5gVBhmgl9l9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsK8Pm1dtDkFpvMEUzRWeR1FO0STQ+buo5NwvJoTPN8=;
 b=EdQLvNEKMVgAvRqk27KiGCBHU0mKAI4kOhxvblvtRXSnIYwECOf0lR+sr3MZYfWYyJWO02VQfWvWl7f0JM0NvMHSUXMeAdkse3bcQF5rxlNP1AQnEeiLd4+uUfD1Vw9+hdTIIoqqSUT1FWfOOp7xn6WyzU7Ar3C+OP2JE3UCtpo=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PAVPR08MB9403.eurprd08.prod.outlook.com (2603:10a6:102:300::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:52:37 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:37 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v2 01/36] KVM: arm64: Account for RES1 bits in
 DECLARE_FEAT_MAP() and co
Thread-Topic: [PATCH v2 01/36] KVM: arm64: Account for RES1 bits in
 DECLARE_FEAT_MAP() and co
Thread-Index: AQHccP9+5jWMu1BdNkKu1sIiC+BHFQ==
Date: Fri, 19 Dec 2025 15:52:36 +0000
Message-ID: <20251219155222.1383109-2-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219155222.1383109-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|PAVPR08MB9403:EE_|DU2PEPF00028D0E:EE_|VI0PR08MB11823:EE_
X-MS-Office365-Filtering-Correlation-Id: f6c11316-0a6f-4cc8-6b87-08de3f16c795
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?YLn45ysy0cPLPkXq+ZWWRUTxcF3m83IkmSVqcKGSckXt9QU8ks8OSiaHKG?=
 =?iso-8859-1?Q?h0fGmD2H5H/vMo5PA50ld6HW3Lzq1aYme8i9ygAJvjJ8fp5ZyuVnvwEwwT?=
 =?iso-8859-1?Q?LrtnI8hum8pMUFqVovMHMevWA3oMQKygqGZhzrXb9iXNDKUYoypVqXwX0T?=
 =?iso-8859-1?Q?c4ZlAnLsIkcJCxrh7jcfnQAwSpkqK0FqrNy/ZFHM+yHH0PY6gASek5SzPN?=
 =?iso-8859-1?Q?hsOFadTEUf4Xg9ilqWH1M9uUUdFsO6pl3GYPCOdyexdsNmdGmj0NJiNxOY?=
 =?iso-8859-1?Q?dG+xqhslJ56a0Jwfg8znIyp77uMQ4Une9X1fONu5JJcGr/fuTMgFLf+tjL?=
 =?iso-8859-1?Q?GLLOO+kUbN0JIYU91KNehBfTFAu2NuDcKrKXkaxWz0IHYJUgyVh7pXzQ6l?=
 =?iso-8859-1?Q?eGkeuyiYwYsSFJyK6gq+dGkclkn8b9qswGC5FMS0WrYGxzY87NNS6c3eML?=
 =?iso-8859-1?Q?f/Y4hb6vLviRrsnSOoAnHsbQPaoPl2BBN0lT48+Eb5oUwRasC2Z55gVu5E?=
 =?iso-8859-1?Q?ToEK1xIg0vEnQ99kqth/l6Xctjo6PA0Pw1kraX7ix84/3SqwkHjGwPbiAt?=
 =?iso-8859-1?Q?JwPN1MRpBehaQ+LWzr05xvMPKAKj6FIQm9RAXbBf95nG54jZ0hWFFNxd0g?=
 =?iso-8859-1?Q?aHM77CuIvtzz58niAJmmJzDMzEYw/fTjHRsngi8B4jUPh8p8qUQaP3/iEb?=
 =?iso-8859-1?Q?PYpPi/KB0Q99Ju6Vzf5ahX5db6gDRNX9CuKhLt41Fi1qzwdGvyS8dVB2rX?=
 =?iso-8859-1?Q?goZU2NBbhHSIZ0d0FMrMeGj0oXdH3c4pmmB1mbb9b3qfLrS0sXCEU/+rWo?=
 =?iso-8859-1?Q?3hnwLQ7NoPVSZSiaMKrIteuw/24WiiCrNMmO8wSBBKFq6Eodh3PopTf1N5?=
 =?iso-8859-1?Q?HFBJ6H7l9CZQ8pFqe2OlS5o7dfbnSCPVPaP0f6azu4y68vmSnU8U2zizmJ?=
 =?iso-8859-1?Q?ftq2E7jseYGwWe3+NY93wiikvpDx4khawl8BLlYi9RrwjyGXKNqB2NUzbx?=
 =?iso-8859-1?Q?nTF/zq2lNwfpZRMgG8N5YEEufKVUVF9300s0fpgJxCB0094kPvski36FDQ?=
 =?iso-8859-1?Q?iEKueCqq5iZRY6RMsOmXoVh0yK9z0KxQJrvEBbC+JbkmJ7gwe+oyZEfqpM?=
 =?iso-8859-1?Q?AlyWlO+PBr+iXpoiyNW7K81glQNSDrqE7AtVg4PlMKrnywvt6doFQhCP6C?=
 =?iso-8859-1?Q?VrDkAKowEMLVaFNlPjk2ujhN6dkIe/5UWcfiXPCxniv+KNOD3B0gBBDGgz?=
 =?iso-8859-1?Q?dT5+a6kd5mtqiDTlkN4ta/y1jRJiXNh9IP1KuHaJ9KvojajI850xdPGVbA?=
 =?iso-8859-1?Q?hUaFuXMGWbdwua+tls8Sp82rUWmOpDKxoKkVAjaQuNK3M0MBnDzTTaKs1I?=
 =?iso-8859-1?Q?PttM82bXfeCGM1GQEshWEfQxoyxa84yZhwitOIu7zSPBEOSH0rn7H8eqRF?=
 =?iso-8859-1?Q?FlzyWLtfW3AtbpWj//lADXtefAMEJUu/9wVZmsiNwBNML7Lwp5180OMe9V?=
 =?iso-8859-1?Q?bVRX81wCh0U3w6NL2Zfr4wS99T1ykbYtT5gNBNwQtgcj69FH2jD8xcoYgy?=
 =?iso-8859-1?Q?hq63N2o0685nAAmBwi4/h8dM1o+P?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9403
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0E.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b433a0ed-d905-4271-ea21-08de3f16a1cd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|82310400026|376014|36860700013|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?RnUdr6Ia3wbR5SFPlkmcQ+Ma98mA6fFDwObWyDP64XRcgBPDbDi2TG7U3I?=
 =?iso-8859-1?Q?Cjx2muIVW8nvhlA3vvyjx/B2Cvu0hds3UZfLapE5SSAbdUoU6/FGcZFaCf?=
 =?iso-8859-1?Q?NiBywqArZNOpfq/SWlR2yFoIhQtoWu8P70KTyAkwcTev1rQX9bdeq1afLY?=
 =?iso-8859-1?Q?CZrKPNuMwCY2JRTVo8MeG7jrOMgMoMm594kd4zSbzzR9tlwB5nv1Bz1V+N?=
 =?iso-8859-1?Q?maEA3NZsqUUMyL9VXi19CzkmhInEeMZJK8WHzJV0/fqZ7qb8fWfJi4J2Gn?=
 =?iso-8859-1?Q?/lNg7yji2d3XQ8dJKCMlOhSpfUzs0aiHoG6G0bLtIzrnfaW6DKXneMs1xF?=
 =?iso-8859-1?Q?wcUkyfOVs1zVvOH6rfwTdwfMnNc0xq0zNqJle6KXdZuFw3xX/yMI24OU8O?=
 =?iso-8859-1?Q?TnV0WNAyof0qj+qmJ31Q8M/Hbr9jMUhAQhJfvuG3SUp5FvAnDi61EOt0Ea?=
 =?iso-8859-1?Q?MIBc67mn/71wbrfYmd0cBskamkO+xZjJaz2TPs8ZXa/GVVtIsQzMqKOZR5?=
 =?iso-8859-1?Q?+PjNuR2ranhFfBu434SrzGQXy0BEx4UluJHeGSsozVOJLpKS//mVWzLup9?=
 =?iso-8859-1?Q?xyVDHfffw0G7YO4y7/wX694jPiONZSaYKG/K+CuboldMUwBbde3x4h5RFS?=
 =?iso-8859-1?Q?B0XfxgFzbmJ/+/8ViiGX2HbkWq78TJfuMCcy9soDPt26ZrL0X5ax0Jjkxz?=
 =?iso-8859-1?Q?p1emCXYjXTuoVi+ytW83i8JNjHtsqHLo8K6dptM1ebed+TYVWxT9awKmkL?=
 =?iso-8859-1?Q?2Av66MdwV65C+roipWQI/le65GSmg9jUIujLqfQiDxf9KAFepLKMFEZMlI?=
 =?iso-8859-1?Q?gb7Qed098nmSOOiEzZnhv0tIlOXvm3i9o8m/OFFzsFbKndiVLVAaa8g2zk?=
 =?iso-8859-1?Q?61M5Yphf+q7LU1y7Ia7aQmygAH5sI841igNoj10QIKMvi+afpXNzqR0Gic?=
 =?iso-8859-1?Q?1A0oDkEWpk+lftHJTlyztSjlEY6JFng8beGZUPPMyT1Z5php50tArq4+An?=
 =?iso-8859-1?Q?Ii0oD/hSj2JhKrR7d30jRr9wuIKTTwESMYq+s8AEBx/PJ0dO2u/E6Ul67q?=
 =?iso-8859-1?Q?B+/MYpDxILH6uhgdO1fiMBv/lJ9D7GtRg0/Bgj2nNHzugGLLKaaJSC9MmU?=
 =?iso-8859-1?Q?ErMJLEVwVGXKTxRSGJA8kWSNnivt5wyV7dJdVsQotXG00k3oGa0elQWJBM?=
 =?iso-8859-1?Q?JVot+C8IaupMfC1uo7s0r4CKTL251twVUTEZKpajtqtRojbJZ8UcM0Rh4t?=
 =?iso-8859-1?Q?pA8ZGNidsA1qVwseyHIqZIEU3wWotOLqtY84AByqYIalaeNAl6lkV043Ps?=
 =?iso-8859-1?Q?eUy3cLhc/FkJhUDSxk08+Gu6zcQ+49l4UUUDIPivENrOMk2Ow4M/CP+4Sx?=
 =?iso-8859-1?Q?HNmtlO3O5qr/e7cUFAAExd6aSyGfJ6JAw3vkChdHtFhCEwHTNgNSE7Qzdt?=
 =?iso-8859-1?Q?E4ZBHq4fSF3sv7dm4GaYD+r+s9GzDdrmqEGreGneIjbZjm+1kquJ6948Im?=
 =?iso-8859-1?Q?0HaPe1Ag5PazrShTpTNGq0SmGHct4dNhPtB4l9I3MxnbpL6fgTaxQ+Udfg?=
 =?iso-8859-1?Q?B7L2BSAYWZRU13A6dR3qimzMaZdONHHfu0AamwOX+NsEDeAZn6Y6cWTJLy?=
 =?iso-8859-1?Q?azjoiqtfNaB0o=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(82310400026)(376014)(36860700013)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:40.2341
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c11316-0a6f-4cc8-6b87-08de3f16c795
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0E.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11823

From: Marc Zyngier <maz@kernel.org>

None of the registers we manage in the feature dependency infrastructure
so far has any RES1 bit. This is about to change, as VTCR_EL2 has
its bit 31 being RES1.

In order to not fail the consistency checks by not describing a bit,
add RES1 bits to the set of immutable bits. This requires some extra
surgery for the FGT handling, as we now need to track RES1 bits there
as well.

There are no RES1 FGT bits *yet*. Watch this space.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/config.c           | 25 +++++++-------
 arch/arm64/kvm/emulate-nested.c   | 55 +++++++++++++++++--------------
 3 files changed, 45 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index ac7f970c78830..b552a1e03848c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -638,6 +638,7 @@ struct fgt_masks {
 	u64		mask;
 	u64		nmask;
 	u64		res0;
+	u64		res1;
 };
=20
 extern struct fgt_masks hfgrtr_masks;
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 24bb3f36e9d59..3845b188551b6 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -16,14 +16,14 @@
  */
 struct reg_bits_to_feat_map {
 	union {
-		u64	bits;
-		u64	*res0p;
+		u64		 bits;
+		struct fgt_masks *masks;
 	};
=20
 #define	NEVER_FGU	BIT(0)	/* Can trap, but never UNDEF */
 #define	CALL_FUNC	BIT(1)	/* Needs to evaluate tons of crap */
 #define	FIXED_VALUE	BIT(2)	/* RAZ/WI or RAO/WI in KVM */
-#define	RES0_POINTER	BIT(3)	/* Pointer to RES0 value instead of bits */
+#define	MASKS_POINTER	BIT(3)	/* Pointer to fgt_masks struct instead of bit=
s */
=20
 	unsigned long	flags;
=20
@@ -92,8 +92,8 @@ struct reg_feat_map_desc {
 #define NEEDS_FEAT_FIXED(m, ...)			\
 	__NEEDS_FEAT_FLAG(m, FIXED_VALUE, bits, __VA_ARGS__, 0)
=20
-#define NEEDS_FEAT_RES0(p, ...)				\
-	__NEEDS_FEAT_FLAG(p, RES0_POINTER, res0p, __VA_ARGS__)
+#define NEEDS_FEAT_MASKS(p, ...)				\
+	__NEEDS_FEAT_FLAG(p, MASKS_POINTER, masks, __VA_ARGS__)
=20
 /*
  * Declare the dependency between a set of bits and a set of features,
@@ -109,19 +109,20 @@ struct reg_feat_map_desc {
 #define DECLARE_FEAT_MAP(n, r, m, f)					\
 	struct reg_feat_map_desc n =3D {					\
 		.name			=3D #r,				\
-		.feat_map		=3D NEEDS_FEAT(~r##_RES0, f), 	\
+		.feat_map		=3D NEEDS_FEAT(~(r##_RES0 |	\
+						       r##_RES1), f),	\
 		.bit_feat_map		=3D m,				\
 		.bit_feat_map_sz	=3D ARRAY_SIZE(m),		\
 	}
=20
 /*
  * Specialised version of the above for FGT registers that have their
- * RES0 masks described as struct fgt_masks.
+ * RESx masks described as struct fgt_masks.
  */
 #define DECLARE_FEAT_MAP_FGT(n, msk, m, f)				\
 	struct reg_feat_map_desc n =3D {					\
 		.name			=3D #msk,				\
-		.feat_map		=3D NEEDS_FEAT_RES0(&msk.res0, f),\
+		.feat_map		=3D NEEDS_FEAT_MASKS(&msk, f),	\
 		.bit_feat_map		=3D m,				\
 		.bit_feat_map_sz	=3D ARRAY_SIZE(m),		\
 	}
@@ -1168,21 +1169,21 @@ static const DECLARE_FEAT_MAP(mdcr_el2_desc, MDCR_E=
L2,
 			      mdcr_el2_feat_map, FEAT_AA64EL2);
=20
 static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
-				  int map_size, u64 res0, const char *str)
+				  int map_size, u64 resx, const char *str)
 {
 	u64 mask =3D 0;
=20
 	for (int i =3D 0; i < map_size; i++)
 		mask |=3D map[i].bits;
=20
-	if (mask !=3D ~res0)
+	if (mask !=3D ~resx)
 		kvm_err("Undefined %s behaviour, bits %016llx\n",
-			str, mask ^ ~res0);
+			str, mask ^ ~resx);
 }
=20
 static u64 reg_feat_map_bits(const struct reg_bits_to_feat_map *map)
 {
-	return map->flags & RES0_POINTER ? ~(*map->res0p) : map->bits;
+	return map->flags & MASKS_POINTER ? (map->masks->mask | map->masks->nmask=
) : map->bits;
 }
=20
 static void __init check_reg_desc(const struct reg_feat_map_desc *r)
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-neste=
d.c
index 834f13fb1fb7d..75d49f83342a5 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2105,23 +2105,24 @@ static u32 encoding_next(u32 encoding)
 }
=20
 #define FGT_MASKS(__n, __m)						\
-	struct fgt_masks __n =3D { .str =3D #__m, .res0 =3D __m, }
-
-FGT_MASKS(hfgrtr_masks, HFGRTR_EL2_RES0);
-FGT_MASKS(hfgwtr_masks, HFGWTR_EL2_RES0);
-FGT_MASKS(hfgitr_masks, HFGITR_EL2_RES0);
-FGT_MASKS(hdfgrtr_masks, HDFGRTR_EL2_RES0);
-FGT_MASKS(hdfgwtr_masks, HDFGWTR_EL2_RES0);
-FGT_MASKS(hafgrtr_masks, HAFGRTR_EL2_RES0);
-FGT_MASKS(hfgrtr2_masks, HFGRTR2_EL2_RES0);
-FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2_RES0);
-FGT_MASKS(hfgitr2_masks, HFGITR2_EL2_RES0);
-FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2_RES0);
-FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2_RES0);
+	struct fgt_masks __n =3D { .str =3D #__m, .res0 =3D __m ## _RES0, .res1 =
=3D __m ## _RES1 }
+
+FGT_MASKS(hfgrtr_masks, HFGRTR_EL2);
+FGT_MASKS(hfgwtr_masks, HFGWTR_EL2);
+FGT_MASKS(hfgitr_masks, HFGITR_EL2);
+FGT_MASKS(hdfgrtr_masks, HDFGRTR_EL2);
+FGT_MASKS(hdfgwtr_masks, HDFGWTR_EL2);
+FGT_MASKS(hafgrtr_masks, HAFGRTR_EL2);
+FGT_MASKS(hfgrtr2_masks, HFGRTR2_EL2);
+FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2);
+FGT_MASKS(hfgitr2_masks, HFGITR2_EL2);
+FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2);
+FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2);
=20
 static __init bool aggregate_fgt(union trap_config tc)
 {
 	struct fgt_masks *rmasks, *wmasks;
+	u64 rresx, wresx;
=20
 	switch (tc.fgt) {
 	case HFGRTR_GROUP:
@@ -2154,24 +2155,27 @@ static __init bool aggregate_fgt(union trap_config =
tc)
 		break;
 	}
=20
+	rresx =3D rmasks->res0 | rmasks->res1;
+	if (wmasks)
+		wresx =3D wmasks->res0 | wmasks->res1;
+
 	/*
 	 * A bit can be reserved in either the R or W register, but
 	 * not both.
 	 */
-	if ((BIT(tc.bit) & rmasks->res0) &&
-	    (!wmasks || (BIT(tc.bit) & wmasks->res0)))
+	if ((BIT(tc.bit) & rresx) && (!wmasks || (BIT(tc.bit) & wresx)))
 		return false;
=20
 	if (tc.pol)
-		rmasks->mask |=3D BIT(tc.bit) & ~rmasks->res0;
+		rmasks->mask |=3D BIT(tc.bit) & ~rresx;
 	else
-		rmasks->nmask |=3D BIT(tc.bit) & ~rmasks->res0;
+		rmasks->nmask |=3D BIT(tc.bit) & ~rresx;
=20
 	if (wmasks) {
 		if (tc.pol)
-			wmasks->mask |=3D BIT(tc.bit) & ~wmasks->res0;
+			wmasks->mask |=3D BIT(tc.bit) & ~wresx;
 		else
-			wmasks->nmask |=3D BIT(tc.bit) & ~wmasks->res0;
+			wmasks->nmask |=3D BIT(tc.bit) & ~wresx;
 	}
=20
 	return true;
@@ -2180,7 +2184,6 @@ static __init bool aggregate_fgt(union trap_config tc=
)
 static __init int check_fgt_masks(struct fgt_masks *masks)
 {
 	unsigned long duplicate =3D masks->mask & masks->nmask;
-	u64 res0 =3D masks->res0;
 	int ret =3D 0;
=20
 	if (duplicate) {
@@ -2194,10 +2197,14 @@ static __init int check_fgt_masks(struct fgt_masks =
*masks)
 		ret =3D -EINVAL;
 	}
=20
-	masks->res0 =3D ~(masks->mask | masks->nmask);
-	if (masks->res0 !=3D res0)
-		kvm_info("Implicit %s =3D %016llx, expecting %016llx\n",
-			 masks->str, masks->res0, res0);
+	if ((masks->res0 | masks->res1 | masks->mask | masks->nmask) !=3D GENMASK=
(63, 0) ||
+	    (masks->res0 & masks->res1)  || (masks->res0 & masks->mask) ||
+	    (masks->res0 & masks->nmask) || (masks->res1 & masks->mask)  ||
+	    (masks->res1 & masks->nmask) || (masks->mask & masks->nmask)) {
+		kvm_info("Inconsistent masks for %s (%016llx, %016llx, %016llx, %016llx)=
\n",
+			 masks->str, masks->res0, masks->res1, masks->mask, masks->nmask);
+		masks->res0 =3D ~(masks->res1 | masks->mask | masks->nmask);
+	}
=20
 	return ret;
 }
--=20
2.34.1

