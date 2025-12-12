Return-Path: <kvm+bounces-65864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 49369CB91EC
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:28:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A960C308DAD2
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B164F3242B6;
	Fri, 12 Dec 2025 15:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SSJpnolr";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SSJpnolr"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013041.outbound.protection.outlook.com [40.107.159.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D294F322B6E
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553038; cv=fail; b=ux3PeOlaYBPwqill9w89/b/VVay2LKezHfu2Wjr3RuMtE/phlJu1ZSFAI9e2/80pDrOUZyini9toqREEkjxsxOkyWl4vUnzpW8vl6KcPcbX02qf7k6AAfVI+c2cRoHS8mHZCE9D1WTgL1jkQgMwPCj30kVlzU/SfHeVr0CVuJUQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553038; c=relaxed/simple;
	bh=9fcaaSeJYERoQBP+9vd0QOK0lWf4G2zD7dpfpGOfOQE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sea7AUfo/Lw7GnpeoaMcoq59LSs72emBYgGISAj3VS9yGcJjvTS0mZCF8clYP4Mmu3ysyOyqA7TTq7YT+86fcyVw3vUfMFaG+++ZL7+gitINhG9cSlXI7Xhw0IWZHWSRxCyGKYsV6odFddPCTmpWcKW1r7P3OhGZJFOHcp4zqmk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SSJpnolr; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SSJpnolr; arc=fail smtp.client-ip=40.107.159.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wC7xDmaa/p+tsNz4uO+jF+BV8rZ0TOTrPBAxrOFYzej5NCQG9BV6OKfaoynIcWnzL/t9em4v7boiqOhEjiyLnnM0S5aeV1hXi1UR2mcvR4vBWyqqKpg+pUT9N7ZH3SaHmGhFsdtOmFwTbaPkRrtPgZMv3iV5jlzBiOOGblz//gl6eIeSO3/Oe6iS4PRB1EYsosUHvKKTao2xSiCKTLUlh9GnS+uvAghg3fIVuUZQfryN6RJHRi0Ud2kOzB6+yXZS6stuT/UjbgDzzF/K9kWb0RhHGhu5BHMXaCxCLbINR0WqUWQvY3pdaZjPrF2glwFGsxN5tOzzjJHUXwyeCVxnAQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXpyZ/osx/uokT5vWWH2MWvKOqVTEByfGnDQHtqRMLM=;
 b=BtCc383wZxghDgL+65ekae1pme4+OlqBNomdfmC79RsTCGXf58JgbszyOlFyj8u+puBOC6jsioo7+99wwRSI86+gVLs8Oje7n9pWWsTEbx6bj99NYdKlo05v6L+APSc0W51cXVctoZRH+KvwUsFjlMAW1pWuxO1fVz1fjPwAUGZHR19Vr9nelelK/t5aMNHqOr9XVboXfSmqeC4oblXzXP4kEVb/aICkDzgaEngKZhjhUKQMgVFqQ+9ADbHVWGfZ5qk3JTND6op/l0k0DG2bv3dohhE8zIP+eGTC5JZF5S0SXu6VCQ+UJ7JLHWAB/m8y8/QyxQoiAwq0LdvK/iNv6w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXpyZ/osx/uokT5vWWH2MWvKOqVTEByfGnDQHtqRMLM=;
 b=SSJpnolr53MxGbS12Q4/xsaYaNBRBoykqLHfamHTcNGvnGcowz+Y3CEpjdxXhDrmFS8Gkwa7d/vfmknJiE5b+P8InGfYZtKL9NcFyxiJkkf8Wik4mQb/SAPd7hH9SRkgABzEXy9aEFlrbHyKWYzWbb+76QGnTDEqagxVcN9RnNk=
Received: from DU2P251CA0023.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:230::35)
 by AS8PR08MB10362.eurprd08.prod.outlook.com (2603:10a6:20b:56c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 15:23:46 +0000
Received: from DB5PEPF00014B95.eurprd02.prod.outlook.com
 (2603:10a6:10:230:cafe::ea) by DU2P251CA0023.outlook.office365.com
 (2603:10a6:10:230::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.9 via Frontend Transport; Fri,
 12 Dec 2025 15:23:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B95.mail.protection.outlook.com (10.167.8.233) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WK/9VuLaN6sxP192LZIHo4HQH/psgXeprEC7AHT9bqqJddyfO8vJQJpl7wCkfS3N+ZMaEEaqRNJo9ymdpvMOGYpUQu0S+DZbdkyXWi6vaLhprqJUhvsK7JvEwIx4uMYnEpHl++7TVYUlPdKH3HsK/qCun6fl103xw67pAqr0qaONaHssfsjKmJ2lFDhQu7PMnPfVkqxUb/M8wK5afetddocUZLkzmwdRcOWwHGoq2gtMsN1w+71mHuqH1fULYhlKlj5zrlKm9WzW5yOcKqwAsFxhlVsxyaPbknPtg7UVnMEMPl24kGO2MqyO8jCM30AZ+C0u/YSLyoLRIq4nVKtrMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXpyZ/osx/uokT5vWWH2MWvKOqVTEByfGnDQHtqRMLM=;
 b=xajKxkdgd5KcT8tG3Mky7k1K7BOzMtDKvLivMY3NTyICV2ai0hb85P/uMf9H60bcI6Dn/61dxv61wYwwILb59U5ddDwWc3GC/24dDu8CA3w1J3uP2LuDE8eHm6Z+1ionvjxoy1dGvGXwhvNV7Jo27u6U4jCsM2KaAFeZ6mls3N/Hzxj+RIYJAE1lUXfPAmn1zzUFA4ToHzvdiuLeVj+Yb+7shn6BH0xW0aN+WvzfUL1vRW6z9Sf4UOJE+eI1zKL9o22yVEgEHuBCtv342R5nbd1ywb6mD9yN3lujrGxWT2n05IH8rs7lQ6SZ7DV0IfJOyRpMlto1nXcmhtiDYJZGYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXpyZ/osx/uokT5vWWH2MWvKOqVTEByfGnDQHtqRMLM=;
 b=SSJpnolr53MxGbS12Q4/xsaYaNBRBoykqLHfamHTcNGvnGcowz+Y3CEpjdxXhDrmFS8Gkwa7d/vfmknJiE5b+P8InGfYZtKL9NcFyxiJkkf8Wik4mQb/SAPd7hH9SRkgABzEXy9aEFlrbHyKWYzWbb+76QGnTDEqagxVcN9RnNk=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:43 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:43 +0000
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
Subject: [PATCH 19/32] KVM: arm64: gic-v5: Init Private IRQs (PPIs) for GICv5
Thread-Topic: [PATCH 19/32] KVM: arm64: gic-v5: Init Private IRQs (PPIs) for
 GICv5
Thread-Index: AQHca3so0tqCAkGh8UOJeT6vNFGFdA==
Date: Fri, 12 Dec 2025 15:22:41 +0000
Message-ID: <20251212152215.675767-20-sascha.bischoff@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
In-Reply-To: <20251212152215.675767-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|DB5PEPF00014B95:EE_|AS8PR08MB10362:EE_
X-MS-Office365-Filtering-Correlation-Id: b0954ad8-12cc-4f06-97a1-08de3992716d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Bz2D8XTy+guyzKa1Janw9MUgV+GrMMkNwiIv0RXEGpN7I2oxb4uN4QqFrJ?=
 =?iso-8859-1?Q?6JkB1DgpSeSTtroFleLT8+tB7sQ1nUHM64cqi7qKY5vIS7JHnzKTBTzPil?=
 =?iso-8859-1?Q?2j8vD3isXTjwctn2ld6GxVEwRrw3FMabQUy4bdxsgt0imOqP0eoSToetJN?=
 =?iso-8859-1?Q?grDfIJ8PCNN3eyEjiZd1U5eqowlsU/d48a6nJpj7CXPOvrFxf8oM/HVSpa?=
 =?iso-8859-1?Q?cDOj6+6gWLjQfvLoGyNNA2EgdTstPZu6w3Z+2qQxdHXUoozMJqS5WRA9mB?=
 =?iso-8859-1?Q?q+XW7WgLQ47zzyjaGdi7gRXMhWCqk52cy080ZwFwNYZ7/imWFvldeG+EYO?=
 =?iso-8859-1?Q?Iu7uuY/aiuoZQc/qoCvAmUElYfg1Ny/8sRQi/rkoa2HOoVq1xdQIy8pjrh?=
 =?iso-8859-1?Q?M42pdHAnVgnvGAa1Uo1AhW9lfhBYVOKhjqyxwYHxZ39qoCFpSEftldlRKi?=
 =?iso-8859-1?Q?AjOoW7tR7ii2RqkZQPzDioFLk1QhWXiHjL1hNmOPxWlJ57JJ43PMcTBse6?=
 =?iso-8859-1?Q?p+lMwuRpaWZqirHDJ+JFvyybS4wO4iSNMiDIYP69Z6MT3DPnmgFL+IFWze?=
 =?iso-8859-1?Q?yto9rmZ3V4/upH8tQwJCUkZOzKzRHVy0e9bFQwtuTW7GYYqESlWRNAU1Pc?=
 =?iso-8859-1?Q?tFd+sZlrXYtMF9v+JY/HeAzgQ6mdduPdWmQWE7aWrnO5VaBmXVHwJJ8X55?=
 =?iso-8859-1?Q?ZZfUcV/eK59ysJEeLuziwvrzMuMXHMR3pF6Bap6lZgzMMb6ZISoSx4n7Ot?=
 =?iso-8859-1?Q?bnM1oh51hBY7OS5WbYV27/D+odOr7MK339uRazj3snepNYTmIYNlR9FTo1?=
 =?iso-8859-1?Q?v9eAGY5Ezos84qxfHpLQMbYjBJ0WQDK7PpLoccai+2YsKx2uPnp/2kUiNS?=
 =?iso-8859-1?Q?iUH77pFmTtmuaVMB5bIlpkJH1xaBDGcg4sGi1sweTDKZU+OOu4tYPYlGx9?=
 =?iso-8859-1?Q?QfGw6rRXOlJnnOGv7GTNaJoIYWCfpXwMuxwi31E+wMy+nNLI2htaSDd2QN?=
 =?iso-8859-1?Q?T8ZKLZshoDnuHHieuRoTuN7q7nVLT0uIwZUzBN+XnTDgkPHdVatZd/RLwq?=
 =?iso-8859-1?Q?Z7YZfg5U9XmjKOtWNAxArJOCU0fuIrHSKUYuzwwPE8iOX0139eOTYrHMSG?=
 =?iso-8859-1?Q?oFzOLnxJjy0YdO3pOCgmgh7s+dRYo/V/paRJN4k4ivf/aQAVpnGuSo4EXT?=
 =?iso-8859-1?Q?6YS+ab1IULd59H/u56fND3azQ1by4Br4YgW6yPZUEANZxDY17GmuWk3khY?=
 =?iso-8859-1?Q?leEZFFT30fqVVra/essUXe62k2CxjNxKZ6lQyTUFfkrW/UgzCTUA7FddnV?=
 =?iso-8859-1?Q?71/jWpYbZelPRo4WOHPtUr36POvLBCAqMPVr4RnRz6ztFGZRLEtkMSIIo1?=
 =?iso-8859-1?Q?9JHuwFyEloXvoc1bj9jDqXqJ2ilY9Oj8pHiKifSVCORbgi4Ibib0ROwQKR?=
 =?iso-8859-1?Q?gKHZPb9dywVbnSAW9rj12DAcU0LTO6b6VnsMMw6cEH5CbcKTSj1YB0N+HF?=
 =?iso-8859-1?Q?QKoYSTmYcjg8YkPPLXGy3kKiTxXxMPGFn59oKMGJPne3DUKyRzrR8KHYyu?=
 =?iso-8859-1?Q?SqBisFMRwDcNrd26XzvGKzrWbLFK?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10565
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B95.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9f92ff36-b65c-41cf-3b2d-08de39924bb5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|14060799003|35042699022|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?6P0AmV6Kn/0BxsjbiGQpw5h4VfIzFUzP/rSeZfcDh0c+bNlA/UOpnrFyXL?=
 =?iso-8859-1?Q?yryINrwRuAhUZgW3vE/omUj6sjDRxuZAQGKzub1blHQGtTqJend+r57PFN?=
 =?iso-8859-1?Q?IgVo7zOjPuGLPvGRTFffnu34jr32OI/DsaEGWaag8fAI4AmxuDLHP9lKYE?=
 =?iso-8859-1?Q?sD5z/XgI0NEekA3Vou+8s4nC/XwSGEogM3gq9Y7cT3J1Lubhuz8l1M9Keg?=
 =?iso-8859-1?Q?v0NZpGFumpToSOOSM1eUBk7Vwa59afHRoW6YuEJj8eDi81VaaO4Hakt9UG?=
 =?iso-8859-1?Q?r9L3DpBX27pTlAVnAuesqcUNtRUgEK7kNEhFs8TmmA0Xk1efOCnMXGep3E?=
 =?iso-8859-1?Q?hfbFXd6U3MnZRdd++7cWeHotevKqfOAtllCzJLigGG2O8Gg9Nsp4ltUs4j?=
 =?iso-8859-1?Q?cGWLSQRYUYw8FOxLGfZ6epAjFWB2RdJ+RF/jPjZuugNQdBmB7E9q9Z4A+A?=
 =?iso-8859-1?Q?klSlz1/WKcEB5oKkloRH81Q3eBkyZetfAPZrurci2Uzv5fbQXSLsbrm7d6?=
 =?iso-8859-1?Q?rDPqkh66q7qKy48gVnE6KsigDjBwuX6/ng9puFPt4rAsYEr/okGI5cOtwZ?=
 =?iso-8859-1?Q?AT4ExkCgloXh8SrfzHg8Sq8nZnPj4qCNafkqmaOD9rl2JSU8Ur0ePtFO67?=
 =?iso-8859-1?Q?qt842ZYKpRA8TQFnsnFyZhS2kl4LVGZpBJcSco/RHz/deiLv0K5zw5oh+3?=
 =?iso-8859-1?Q?4dZ3vSnS4WodUiSshgfSdVImp16O1zqDqU5miR4g8hJ5l9JvoRed+zfIt2?=
 =?iso-8859-1?Q?W2eqkkpYE2l6y5aWu7sQE6Cq+asLcIV1wzqlLptslKPf4SZIxNaW7Mn/US?=
 =?iso-8859-1?Q?PUThDHYqDTXV5tfypL6RF5D3p0mK/keE1G44+Xu0byLMJ5Pex+kvwpID2M?=
 =?iso-8859-1?Q?GxjSxNbsJYQ3OlA2BNQk2H20zskFtqiefcGcku4Cf+fhehkWhGzJj5+aRi?=
 =?iso-8859-1?Q?5jhk/vW3Fun2EqgA8W7OqAXCZ7fkPfX1ci5pD8J3yG4ZCpMzLEfsM0hqCD?=
 =?iso-8859-1?Q?LHfVoHy660SpQHNerJ0OEduCKueDRaS58bUcNCy2mXPOpPeKUbIuMTyn5k?=
 =?iso-8859-1?Q?fWtHQ48t1DTPF2232foRyho2c/i1HqOorSG/mlTuYm9fhzU/wIFtIyFO+v?=
 =?iso-8859-1?Q?x7mYNmUSn1ezFEtDJ+xTGnO+ULMalyMQVh/uDWlpsxJdm43oDAbQQuo+xw?=
 =?iso-8859-1?Q?pJtuwsrqu4BW3b6TrbYfq6z4o5s5gFJCgPIR1ldGPuLVuCzJyBuvekmNHy?=
 =?iso-8859-1?Q?9fNwalVKneOSfIVZqd9ATWO+o4Nsy8KJ82PvoqNLLAM++DSlcgJMydCjDV?=
 =?iso-8859-1?Q?t8tfVEvLYsCW/rXPytQ80JVEjZRATzQ+KBHMhCnhT6sprcaKSSwjX4mleq?=
 =?iso-8859-1?Q?XOgvMnCAQAlZ03T9R60rrSG6fC39709VTwCNrI7FLRxIRMxXOYzkb6Gbyq?=
 =?iso-8859-1?Q?YBg9CsR1x+77CDSskjIieo2Wceq4WRxcRwQvWbIm9ZS/uo3hv7SRIhVQTk?=
 =?iso-8859-1?Q?MNSS/94PcIOe7yGUVJWnsU+k1PeToQcCzWrnI9N4bI1fz3ffBlm1FpY7iS?=
 =?iso-8859-1?Q?j5x7Rv7WNpvFcyyWg4kTrHinBmtDksio89tuJ6s4NMOMRDvGuqGdj9Mafn?=
 =?iso-8859-1?Q?ovrWbyC/QR9oM=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(14060799003)(35042699022)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:46.3157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0954ad8-12cc-4f06-97a1-08de3992716d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B95.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10362

Initialise the private interrupts (PPIs, only) for GICv5. This means
that a GICv5-style intid is generated (which encodes the PPI type in
the top bits) instead of the 0-based index that is used for older
GICs.

Additionally, set all of the GICv5 PPIs to use Level for the handling
mode, with the exception of the SW_PPI which uses Edge. This matches
the architecturally-defined set in the GICv5 specification (the CTIIRQ
handling mode is IMPDEF, so pick Level has been picked for that).

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c    | 41 +++++++++++++++++++++++-------
 include/linux/irqchip/arm-gic-v5.h |  2 ++
 2 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index b246cb6eae71b..51f4443cebcef 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -263,13 +263,19 @@ static int vgic_allocate_private_irqs_locked(struct k=
vm_vcpu *vcpu, u32 type)
 {
 	struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
 	int i;
+	u32 num_private_irqs;
+
+	if (vgic_is_v5(vcpu->kvm))
+		num_private_irqs =3D VGIC_V5_NR_PRIVATE_IRQS;
+	else
+		num_private_irqs =3D VGIC_NR_PRIVATE_IRQS;
=20
 	lockdep_assert_held(&vcpu->kvm->arch.config_lock);
=20
 	if (vgic_cpu->private_irqs)
 		return 0;
=20
-	vgic_cpu->private_irqs =3D kcalloc(VGIC_NR_PRIVATE_IRQS,
+	vgic_cpu->private_irqs =3D kcalloc(num_private_irqs,
 					 sizeof(struct vgic_irq),
 					 GFP_KERNEL_ACCOUNT);
=20
@@ -280,22 +286,39 @@ static int vgic_allocate_private_irqs_locked(struct k=
vm_vcpu *vcpu, u32 type)
 	 * Enable and configure all SGIs to be edge-triggered and
 	 * configure all PPIs as level-triggered.
 	 */
-	for (i =3D 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
+	for (i =3D 0; i < num_private_irqs; i++) {
 		struct vgic_irq *irq =3D &vgic_cpu->private_irqs[i];
=20
 		INIT_LIST_HEAD(&irq->ap_list);
 		raw_spin_lock_init(&irq->irq_lock);
-		irq->intid =3D i;
 		irq->vcpu =3D NULL;
 		irq->target_vcpu =3D vcpu;
 		refcount_set(&irq->refcount, 0);
-		if (vgic_irq_is_sgi(i)) {
-			/* SGIs */
-			irq->enabled =3D 1;
-			irq->config =3D VGIC_CONFIG_EDGE;
+		if (!vgic_is_v5(vcpu->kvm)) {
+			irq->intid =3D i;
+			if (vgic_irq_is_sgi(i)) {
+				/* SGIs */
+				irq->enabled =3D 1;
+				irq->config =3D VGIC_CONFIG_EDGE;
+			} else {
+				/* PPIs */
+				irq->config =3D VGIC_CONFIG_LEVEL;
+			}
 		} else {
-			/* PPIs */
-			irq->config =3D VGIC_CONFIG_LEVEL;
+			irq->intid =3D i | FIELD_PREP(GICV5_HWIRQ_TYPE,
+						    GICV5_HWIRQ_TYPE_PPI);
+
+			/*
+			 * The only architected PPI that is Edge is
+			 * the SW PPI.
+			 */
+			if (irq->intid =3D=3D GICV5_SW_PPI)
+				irq->config =3D VGIC_CONFIG_EDGE;
+			else
+				irq->config =3D VGIC_CONFIG_LEVEL;
+
+			/* Register the GICv5-specific PPI ops */
+			vgic_v5_set_ppi_ops(irq);
 		}
=20
 		switch (type) {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index ff10d6c7be2ae..9607b36f021ee 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -13,6 +13,8 @@
=20
 #define GICV5_IPIS_PER_CPU		MAX_IPI
=20
+#define GICV5_SW_PPI			0x20000003
+
 /*
  * INTID handling
  */
--=20
2.34.1

