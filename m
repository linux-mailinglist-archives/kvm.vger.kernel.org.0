Return-Path: <kvm+bounces-67590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id CD75DD0B800
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:06:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CD9AC301B329
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43C6E365A07;
	Fri,  9 Jan 2026 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rwERlDPw";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rwERlDPw"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011017.outbound.protection.outlook.com [52.101.70.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD73931A06C
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.17
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978351; cv=fail; b=GqnLXifTmQi3Z0WPV3h6JEiV3DPJp+AZ0jc/3ld1TG1WgIUMJH2DU5KUQT5CK4w8cjQy8kcLf5tXK0np480Ad1JJGa1bm3jzlLlrN7ZRXnIwkt+GZCjSwUhUUh9wyDyGmFaNgJEzUUfZKmuWvwbMhwGJxAz6lCVxbr0C0KwpOu8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978351; c=relaxed/simple;
	bh=Osc/Sq3U9wWHHA2DkfiXXhy9JF/RpbT+fqZ1wwVrYv4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RX2nu2Sze08Eo7OvI6R+U4NmHeRTkgRx2+i9l6jUwXj5g+vnuIKpuUuCOVmNKb8TLhULq0kNxmVDYOY6Aw937w941BL7rB8CcGA04vVjPjiIOhLWUjP/Y71LY8FIyJgu/BxycUGk6btBAY+GLHUqmk1cyH2idhdk8ansNLf7hVo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rwERlDPw; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rwERlDPw; arc=fail smtp.client-ip=52.101.70.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TvBgDO4KhoEiaKFlN971hjU+z+NLYgcJZPNzXZmXKcVWrHOYrR15lB2wvB64Y2fR9l8iCz3q3bGyKD0Y+VdhD2GARudY0DM3oyKDUFTVM2B+uq5ZRmi+HUjO8+Ca+ezYS4lTPBugE8ceChkdMhd9CXhGQmj2AVRZZNMovl6F+bjyDEvHFwvFfcM6OCN30lJr2i4rEenPyKpNjjqK0iBnUpPxB+CFCAOzXkPaiCEyy5d+h3QT6+PJUrJn3kVZt40xClHxJKR2iOI0RbBnyL210Ho6A+4bcKNVMb0/mBbNHaO5VcEAzzM/aCRLQmoTjN8K5KQsyxMwjS88i41KxFGMpA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HccP6RVpVK58zdYiQNIcrp6dBL9a71SDFv8fqtENEmA=;
 b=WMBNq1mo/vNfPuQtAZLFwkDBiNDP8NdEeD8ISzS8wZbW2OVFoxvP3Mh9zGiw9n+fRUia9n4OX2R7uTS/szNu07E/Rtyj3UWB8WX1ggsaeyWXpqoQGNpHoPedjxfnwCKvali0nsKNRQbR2qYyfpQpbrS7uyofRGpUWWP88dYbJ3zJ14h9k8xaQNfvCmJ+g0oA5+YJEioYLfgT0i0ttne8FcIxhlcnqsJnjgFXkLwE1ne565+OukNWB8h3htqdayYaRgoHatFQC2EpPzpNlKmbyp3VS+y6nhEamuz+TV7UUL2lweKTm1AvVpdg61zParn47K2C5/3Pn+tulgcP1dkvVg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HccP6RVpVK58zdYiQNIcrp6dBL9a71SDFv8fqtENEmA=;
 b=rwERlDPwwjw9A0qmVBrkff3pRTTi0fUpLlL7oP670e+QcbjxwWbP72bsPeAgvWOdQs6AqiNvuby8mDm4n0lxS3XgPnfmE1rJ27OGIdzCeCDg4nxCHC3PHAUJIQUSM/zX09QghnrBqufCiXgoz3daWRpK47ckd8ovDBuRouZOucY=
Received: from AM0PR02CA0159.eurprd02.prod.outlook.com (2603:10a6:20b:28d::26)
 by AS2PR08MB8719.eurprd08.prod.outlook.com (2603:10a6:20b:55f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:05:42 +0000
Received: from AMS1EPF0000004B.eurprd04.prod.outlook.com
 (2603:10a6:20b:28d:cafe::c2) by AM0PR02CA0159.outlook.office365.com
 (2603:10a6:20b:28d::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:05:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004B.mail.protection.outlook.com (10.167.16.136) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MpOkHLQ+6J93LxDocgbSiYiwSjDAGoxhqXYiC2sztiosFTaumpuIl2bqS2l52u3TuweCoHDq5z/O5yZE1PQcTHDeVvLiVoGGXD0eNBHB//xs3lMSava5c6bkzQwKlHEeHnND1nG5VNxlpeVMvUSAq93m2Vmdnw/4pKfGoBJSgBmC2wExVFyxYeIelmLa9Pm258XL36hNs0z3HMcI3Uqgxod1gGPZO+7V4URYdempbfXeQmhR1XJccOlBXlke8EeNalIcKL4kYRXVYGoo+r5hr24KCo+4oc696yj8IQXcoAZStCg9Ak2h5xMj0F6Kcw0NGz2zuSSS54HCoUI1fpPvjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HccP6RVpVK58zdYiQNIcrp6dBL9a71SDFv8fqtENEmA=;
 b=Yw9GMahHq4L6yP1pdOcIwfZw/NXJgNSNPp2CDkWc2BrzSx+HyTFcgRPpHOKGGkT2x4zG5qztFQhprxH6VOC2apMRy1F9pKlpu3S2b/E9IvjYgl/s8RvUEuPgSqR3/EMAvhPHX17q+ektpMSIGCK+bPbTpooB6QF61e7b4HHT75zqD40YJruevlRC8p428HYYMfAl3EwLKsg5kDixCxNacPKaKhjiTD38EBmcsXyo5d3+yOos1IXfX1ALMTpLW7yf3irK1nKmHmwkNZETPCZj2WSu2uLslq9d94M3ImwJQbabPNjSLvoK22usbX44TiyXBGbW5EbmPxTvjKNd/C+EHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HccP6RVpVK58zdYiQNIcrp6dBL9a71SDFv8fqtENEmA=;
 b=rwERlDPwwjw9A0qmVBrkff3pRTTi0fUpLlL7oP670e+QcbjxwWbP72bsPeAgvWOdQs6AqiNvuby8mDm4n0lxS3XgPnfmE1rJ27OGIdzCeCDg4nxCHC3PHAUJIQUSM/zX09QghnrBqufCiXgoz3daWRpK47ckd8ovDBuRouZOucY=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:39 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:39 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v3 01/36] KVM: arm64: Account for RES1 bits in
 DECLARE_FEAT_MAP() and co
Thread-Topic: [PATCH v3 01/36] KVM: arm64: Account for RES1 bits in
 DECLARE_FEAT_MAP() and co
Thread-Index: AQHcgYoKgQVo8PR5Bku46fLutkFybw==
Date: Fri, 9 Jan 2026 17:04:39 +0000
Message-ID: <20260109170400.1585048-2-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
In-Reply-To: <20260109170400.1585048-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|AMS1EPF0000004B:EE_|AS2PR08MB8719:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d6ef2f1-9856-4dee-700f-08de4fa15273
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?A0kWakpvAgucyBxGcYc1Nbj8Gyz7KVGcmCuR/693OPvhECAyvwN95vxNh2?=
 =?iso-8859-1?Q?rjQB3fbKl0jzbF6xW4uWs7FacmXtRS6NQ0YwLEdSQeeAGtg07X6tHQ0+fT?=
 =?iso-8859-1?Q?UM5PYvfP6vtBZ1rmmIgN33e/yh2JCxHFdFx6fOJh5g4evzLo7pUvTj5fzK?=
 =?iso-8859-1?Q?SXpuy+NCG8eLCuYlmNjK2VDL4bWyM5HaPuI9bYM+fWQ664qfwQJm5eFl//?=
 =?iso-8859-1?Q?we1e/FRVaRt/02piEYFtiZ8UhGwwFiJd3DGbro5teNjqoFCHRGI3EkLapl?=
 =?iso-8859-1?Q?6z9Wf/bATRcISudFTcikyu7FXNOe3XJSH7W3H4LpdPfnSJz7SggJbXMGW+?=
 =?iso-8859-1?Q?t+qGtbq6r3jDaPwCBEZFKq2uWzOCphwTd2wLnj0VgBqtsGxA6q17YS+uJz?=
 =?iso-8859-1?Q?MB1knwNlKlj8I4rhSxJPj5txFPHHM9beUcpu6EdsArgpEd/3UAbjpDGYMn?=
 =?iso-8859-1?Q?FNQHhjhEGq+iQg7rgbjyM41/zT7s2PlLJyIJ5cEoxMziYUHCaIVjp9+blE?=
 =?iso-8859-1?Q?9vJcw4+iRZICcTOotv1C7YmJvmSK3XnZtY2VW1oaif3iomeNuw/74lTGTy?=
 =?iso-8859-1?Q?2OgLSHkrY3NY26dVKJ3TX+22ep62XzVSt5bzlBOBm4GwVtPTJi33NVuTvB?=
 =?iso-8859-1?Q?9O7JedTFN2jswXYnxVQthGfOSWEw2KvVdz/2MFJL2zrWVd4S2H9tD6VazF?=
 =?iso-8859-1?Q?gZrbaPs3PsvLSvgWsxMhQoxnmI//JBOz6FuXsXlHxtYLqieniKIEGyKSm+?=
 =?iso-8859-1?Q?ZZjfnUlOGZvZPxv4pBakuApjFF61tDfcCe5ajyFiRtNyBpn8HQ79i8KgyF?=
 =?iso-8859-1?Q?524iLhitn1qEqS8EJbxMafhpoq8mdpG8tWp8XW/ToNPPp4PgCUYdTNIowf?=
 =?iso-8859-1?Q?G3wTwg6ncyCnqVqJkkydYdzKq3osy+BawSMN7kIEsJ2hRp1ttwqe/zFx21?=
 =?iso-8859-1?Q?qxoIbIbqSWLyq8Yq9LamRWBPj6p09GijPs2vDuVw5yvx9cAT2oNCZx9NPY?=
 =?iso-8859-1?Q?14H6CKjdpsjNA9oiQJ2IH10SWt/G3R/+Fn9JMjR+ul+LS5hyO1KzS1pSlM?=
 =?iso-8859-1?Q?CI6rcmYdTAhmoUhz1nVQnGMWkpKvaAb/3uHl+ZOBbwSYfMuft0Oo7ZNs+V?=
 =?iso-8859-1?Q?vwPBog5PJC5pKel2Ov5sh60E60RAdZihia6w4nc0QCB4NN8meSGoT+fruj?=
 =?iso-8859-1?Q?Cu5oHdp/1jJbci4/FjWRiazhPiFT545p0JC6lXDNz8hpQ6c8UIdBYZq3qG?=
 =?iso-8859-1?Q?Tp5c24hpIteSBNXIBS+Ub0JoRdMT+rob+/wHX2cuv7Tv6nP/ywpxyOCFlB?=
 =?iso-8859-1?Q?L3PYQe186eKA57aERWcPrjc6CqJwQTLBHe/bHwa/7bRI4xy6zzVnEsl/39?=
 =?iso-8859-1?Q?Ul3UIJrhzY/bEzytXHSjFMILf67fU7JDF/+g8SllFwLUofsSWTvybtFxhR?=
 =?iso-8859-1?Q?mc2cYMGaiNNc7HzMym/EG4ySafaZKPpkryYpDPhExB4E2Hr8NwMR4Iv507?=
 =?iso-8859-1?Q?mOO17sue53c9rnZy0dX0cunx7NXJ69nn5/RPxGM70yXOnx+VFZg60SScxB?=
 =?iso-8859-1?Q?x0GyPdc5fQH41QxaLLGMMUKMsfU1?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6216
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	dbca2f2e-8744-4c88-2f5f-08de4fa12ce8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|14060799003|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?k/bg09SADy+A1kMNVA3frbpv4T5dDU8uN5Via0F61P3dO1DHvgQHAO/B4d?=
 =?iso-8859-1?Q?v0Vhf8khRByv9BKtYNSfBUhpjSEMMSFsmRukyvIPEGiAQQ9iezG4PihLLd?=
 =?iso-8859-1?Q?iHGDtAusKpmuLulcD3OmIVLFPT3NlkPjVhVKKaCvCnL0k5+t1CGh5d4mVy?=
 =?iso-8859-1?Q?nXIfJDreRLoFXaH7x18ajJE88AW/vg85St3vLwaf0hsnF/z1D+XBUbbhxy?=
 =?iso-8859-1?Q?Z0XwEBEomwO+3KBMO6rF6zCXdwUI4hg2krfx0BbXePwkLPtxIKmgSNcOoh?=
 =?iso-8859-1?Q?y990pWw7SMo04kakn0HNYoHTLPWdgIJF9SqIfVWA2ValjWIAImk+o7jush?=
 =?iso-8859-1?Q?qLZ/tJYPFu06LKh3BIEmohgoc9awVtVJ/9IOewJ+UoFQOSKj/5gk2Ecltz?=
 =?iso-8859-1?Q?xws/rOLkZ/kqLrR1zMFppgec/Dz1FCnfPSY2hjjmIR+r6Z8pa622DfmKZn?=
 =?iso-8859-1?Q?b3ZrI5uKZRLjDUL95cbXZvWH5yfOMhx74DkhkgtDvH8cKpI9Yp9l2fKCBT?=
 =?iso-8859-1?Q?pOVyLvcOKDJ1hm5eF7GMo2wQ8Mjqb1b7CtHlJNUgmIB4Ml6a0oprjTg+KO?=
 =?iso-8859-1?Q?Mt6Ekyej7RdvTbj8uHbuFCxHZZInNziovJd/w/iZnF8AxbuOTyGv4n+2zv?=
 =?iso-8859-1?Q?v8YgNn99a8diMOI/B5pmf5gV5JKdd9J6hRxDrvlSDxMNkbvIdsYJQcc+hH?=
 =?iso-8859-1?Q?pNOwuG9DLZREi5m9RL2xHuSI/X/TkZBP/YXYmY5AzOzOpMAR63t3Trnihk?=
 =?iso-8859-1?Q?icTA6Qh8VJrzMcQcdbON9ZG9ymflclNiE+Cjb5fC24VpPrTElF5TrFkry0?=
 =?iso-8859-1?Q?ypuhuLOzbPA8swjbp2RFZqC6kdlbz4WKBormheBw3IZaedBJPbzHtMNRFZ?=
 =?iso-8859-1?Q?FelGo/ExMrZRTd2AkWJNlM5/9xNcDBtRxt70oi605OhsCea+HcPyKi2Gw7?=
 =?iso-8859-1?Q?i8AwQT0EsfBInyq3V/r6v4UYmUTEVnoGJlzo0qu/WHsM/kHyVomqF/Al3k?=
 =?iso-8859-1?Q?BPnkmDlbnQ+QSgfrWgUZLJv6SY7SOUVhOxkBrMjIsigjDj7AB2foLwI/mE?=
 =?iso-8859-1?Q?GSEHMcVM1HBNZNyPg7AMgzvec5gQww3s9kfYyFAMl2wc+p+TU2QO/fM815?=
 =?iso-8859-1?Q?fbpBzZbiwpu6l2ZWX/68uJLcqe4Erba+7sDjZiOiA/u9Ddt6+qBL2tVm4l?=
 =?iso-8859-1?Q?FLW61gM2lg9HOZUkfEwzvFiodH17XAc3c0HPHCiZ6Foaxz7QZGhFU256wP?=
 =?iso-8859-1?Q?52MITbd923jZ2cV2CEZQy9iFPDR3rR3/ikt2SOl4NZSeRWJImvtHNVaUtm?=
 =?iso-8859-1?Q?HmK92Cn7opjVD60hfLKfh0CGM5vJuR6bR1qfePS3zepdh3ceFKXclQ/dT/?=
 =?iso-8859-1?Q?rzpLA7xMNRYlVgynU0DkVv2NhZ7ctyAM+oAX8FiGoQVw9cFrvDJMgwV8yN?=
 =?iso-8859-1?Q?E9Hm5ak5J2+jWdUyhUS9w7yLUx21VDf67dF1adzOcQYYtl2RVTLFwhQhRY?=
 =?iso-8859-1?Q?qELsUnmGgJsb+KO5ot/1M9/Xw/eumczZG9wWgV4sZTnz+vd+caPVX9R66K?=
 =?iso-8859-1?Q?F8zMCoPmZQJsUvDYRjZsg1+rrP4ScPWw5L+Z3Mfxp7gIDiaK7oYY2Mqn7D?=
 =?iso-8859-1?Q?DambSdKa4r0XE=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(14060799003)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:42.3866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d6ef2f1-9856-4dee-700f-08de4fa15273
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8719

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
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
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

