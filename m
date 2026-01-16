Return-Path: <kvm+bounces-68369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FEBED3843A
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:27:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 874DF300F654
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B43B3A0B22;
	Fri, 16 Jan 2026 18:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FNREaMDf";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FNREaMDf"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011067.outbound.protection.outlook.com [52.101.65.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DFF39C634
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.67
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588047; cv=fail; b=ZbOOYHlSbknlGXVQeCLaoS69Yb1VdyN3NRUqDBHZcoWJElIAkD6QU8iJqVDzOVHuYSPGDDX2IeonCPMSVYEDpo/cxDOE5fjLX+DC1xfTjlHvRo8/prG+dQ8t7cMPdHhglUah/QVk3VN+2jjkXoeeVV85vtFzFc9rvtFMP9Vq3PA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588047; c=relaxed/simple;
	bh=glQXC2RnxKjwSLxWSGc0ZGx1j4R2e0UIY3L55DY6b+Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WTM7tBuHe4CvjGPvdKK5dgolP4Fge9BZpZCaJlAOoGI3PVpqWtSiKIPjuCroPXWXR5oyLhZ9vPZjprR5tkcidpSeOz9bNz5uer/HK9oEl9zA4dYKYLhhasS1ByxlLJEjTNjDABJJERinJcRzQ3cL6NeLceyP3UAYwMdrW+nTEhM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FNREaMDf; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FNREaMDf; arc=fail smtp.client-ip=52.101.65.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=iKIOtcPK8tk2TDsIoTCbTaKwlfFSQDDv8DzTOrz9pQAkrzQ+U5dipmoJh3lWdEsKMOli9m91KzaPKuw4YZRHC3m9ucN95Dr24MsU3yCkkuxE+AEtL8SZZK6WoL3KsoHmzaSqcoIrlojrj/jn8tU8R7BmK+St9Mwl5VfPCAv4pobFcK42pCQwWLCvrIJL41sszIkxdIQjnKLSj5MJkxgiqpNOfQgSfNQeICTlw+zFvdggIXo+eRNvhfIteGlWxVwvbERfw9UHRIg6zaaal77bsMFzHs6YQmbO3JhnLVwVAhyvX0fyGtP5eldDrskrZbUFw3VNpJ45nbrvhT+NF+VqVQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DZ2A2ScSbYaq+Cxe/F/Azvh3GyXFZJX/cuwCegB6R/U=;
 b=kgx2rzQuGcTPeM7gQC7WerIupDzEnmKSkuLDZzmmjKWWTOlQP/tGxqns/Lx26ytRYZhi+uFgN3zop670kJ534UUlXSHDJv0SzvlAdvltbX3eXZpVo2EDyFLoBqq9dFK6Q2+Z10sT9KXWJH6S5SIln3mLyPwej7vlqRKMDqIIHP9oID6OfLk3N1K2TO90aucMc3lKgp47KUFo0G89QQ6gwvqYHepdtXsRMoVxoXvyLrf6R/bVP0sAx3Idgd5s0GXHNX6/WwmUm1s5AREvlshB24ltBJ2Qw3NkmJLjYj3lBjg8G+caQaXUUte7YwGMjBqWavRLZbmEdxHDHEPX9sS3SA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZ2A2ScSbYaq+Cxe/F/Azvh3GyXFZJX/cuwCegB6R/U=;
 b=FNREaMDfytUHJGeIIwL4BBikKopL4GICDx5/XW5zZg4U7BQxtUOuxOr/YI6oafAURZ++h+NGS5MIfU3+Gzza3ke82wfl1OtSWiLnc2uuXj8QfO/Eqyes8Ridqc+YVbfYpV54avSPD0aY8JgtOFttJpfr/x9Jb6KeFGUhL3UQh5w=
Received: from PR3P192CA0024.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::29)
 by AM0PR08MB5427.eurprd08.prod.outlook.com (2603:10a6:208:183::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 18:27:21 +0000
Received: from AM4PEPF00025F9A.EURPRD83.prod.outlook.com
 (2603:10a6:102:56:cafe::17) by PR3P192CA0024.outlook.office365.com
 (2603:10a6:102:56::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.5 via Frontend Transport; Fri,
 16 Jan 2026 18:27:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F9A.mail.protection.outlook.com (10.167.16.9) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.0 via
 Frontend Transport; Fri, 16 Jan 2026 18:27:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wPwCmQ+0wXkA8FKtcZ6+ZKfr89BHJsN6Dxh6KJrHb8STeMnsOKCOePwdCCcCDoN4KAQF4BZo+6BWh1hl1Ey4xogHmI19Y61HD8nevZ5Pkakmeq7BIHQGX+c01qfIcOCSYjPQonW+yiFioQk4g9zrlx/UIekMex4yqW+wK4gdxzhZZVWxCCpawOMYleegYJrEKuSimDXJiC77gP8n6W3hf+WRqKW9Ng6AhOm8VDUAUZSYtO2rBbzzYPm27Lj4SHe6/jXqYc38ppe2i9x9IhH9QIJaRpGAPBpVQkD8QqPCkiB2zlO0DwnaicCnYBn6PfvaxrxHxnhnCbPf+0FqvJOfSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DZ2A2ScSbYaq+Cxe/F/Azvh3GyXFZJX/cuwCegB6R/U=;
 b=nCzhD8FOplhQDHdO4cEDSBiUtD3kCZcZRtER/iHg9liVe0fexEaaqxIlNdEguO4WnceQZ22wlPbfI+7xAA7srwf7s7MfNy2HgyLUCZm0swvhTClvJ31++QUqwUv7oRHqdYr9OuCPdv7muYNWwn/EnX7TJLFWXv3lC57mBb0jNg1XPl6tQDxMVQnfGo31Xrdz4+g8A9QiZZzmgaTyxqgeU1U9QJnvbaED/9T4F5P4dXOpWMHdUzrJoXzJteEB0txK2unx5TLEOFXQPzdIHqSST8AVb6P8oD0h8hLJCY5rqPrMozRXr754TRC720NHJFSGbV/bI+spgFRXL0LWLZufZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZ2A2ScSbYaq+Cxe/F/Azvh3GyXFZJX/cuwCegB6R/U=;
 b=FNREaMDfytUHJGeIIwL4BBikKopL4GICDx5/XW5zZg4U7BQxtUOuxOr/YI6oafAURZ++h+NGS5MIfU3+Gzza3ke82wfl1OtSWiLnc2uuXj8QfO/Eqyes8Ridqc+YVbfYpV54avSPD0aY8JgtOFttJpfr/x9Jb6KeFGUhL3UQh5w=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DU0PR08MB8731.eurprd08.prod.outlook.com (2603:10a6:10:401::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 18:26:18 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:26:18 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 02/17] arm64: Add basic support for creating a VM
 with GICv5
Thread-Topic: [PATCH kvmtool v2 02/17] arm64: Add basic support for creating a
 VM with GICv5
Thread-Index: AQHchxWbXZ92dDTu7066AftTcuQDXA==
Date: Fri, 16 Jan 2026 18:26:18 +0000
Message-ID: <20260116182606.61856-3-sascha.bischoff@arm.com>
References: <20260116182606.61856-1-sascha.bischoff@arm.com>
In-Reply-To: <20260116182606.61856-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DU0PR08MB8731:EE_|AM4PEPF00025F9A:EE_|AM0PR08MB5427:EE_
X-MS-Office365-Filtering-Correlation-Id: 31cbe673-86ee-488a-f8b1-08de552ce30c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?aLKAiZK4VpUabae5Y9TmyryUQjPl2gXM54pNQmDjSDoiymRPKOSe4Yy9wa?=
 =?iso-8859-1?Q?1/T474+2OXeRIJCSfnkxoi61Mq7PC4MfN7ILjtbd0xhxjLFNYD8lJ/c85H?=
 =?iso-8859-1?Q?xgH14xYJDhui5wSIoazowKbjgTCBpy+J9jf9MS9tBEXUE2lcdzsCbhCRuC?=
 =?iso-8859-1?Q?bisbA2ySlwBPD8zdgYC3FNTns0gZhZvK6h176YPtN3u1HELm62gWn52UbU?=
 =?iso-8859-1?Q?WjvclItflNC9IUXdSvitsClgJSJSGD/hFimxuC3JuePHmBsm3kKWd51vRl?=
 =?iso-8859-1?Q?EYXoRqLYHdjqWGEwDejLQKEFQRyxBpJTzfXcIOmqbCSYzvGyZRhF/84ui3?=
 =?iso-8859-1?Q?POWRByhtnuUGnK0aP+nvhv8aOHuH5lEWZ/UMgMEwZNg+6SztpxubiY9cdN?=
 =?iso-8859-1?Q?Hj4Kq4Mt2SVKYtzMI/LlL1k+Nv/JRq3QIXHmcNhx9v1iOWYQUk556sTLZ/?=
 =?iso-8859-1?Q?nz4IRPOFdJ1cuyG+b70HsMYf/QfrS6CnT0Sh3Us2m1kSkRwBfMi/ZmbNbm?=
 =?iso-8859-1?Q?rJixPNogPni4semra1a8Mz3acZRdvUej6S05vc8/sWb1n9fMkeAeqVUp8m?=
 =?iso-8859-1?Q?3D+CK6bQeEu/+LMZCYJwS9dcrqKTbFAy/qAO1jUFoEXWA1o8J9pBKIsmLY?=
 =?iso-8859-1?Q?vIjXUkXTqbr+tF27hvFqjIcd7k0voLkNEst1ZK6g2OxxsuUscqu56Xf7Vb?=
 =?iso-8859-1?Q?opQqj3mo5YnBcspUbaLeRBfuwssthURH18cnxo7+FvGiBn8wGAD4wqvNsx?=
 =?iso-8859-1?Q?LQ3ZpWdmEsobKxLS5EgQUfReF/goI/LwXw0UV7CyKKDttnfoMUQQmNJUya?=
 =?iso-8859-1?Q?clNSfz3zEH/oivhSDvWZMTkUj5aMkM1q8G29caf/G7jQP8kJYAAD7i+99p?=
 =?iso-8859-1?Q?2zSM7Yd///9sMR2zXWx7U4p+EB5sGCMmRJv8lpPjtaBxi8ysv8aMWjrb+d?=
 =?iso-8859-1?Q?s+5kXz/YDVApZ1+QM4aJKAuS0/ShAiqxo+N38LHys7FVLtBVF+zKFbn/Od?=
 =?iso-8859-1?Q?MCYmJQXEIc6LyRmKj/nYOXc1Qah/U9+JfQnbwDYypJX4T7lOsgMGqHPqHL?=
 =?iso-8859-1?Q?AUYcVync5sKDoOweq6cyyQi9DH0T0u0INwocy6xrSwQIN0K3EkVBAmzsxx?=
 =?iso-8859-1?Q?JTjcBhknv2lnaTTwtUXjZ0AG0R1SMMVQZibvKoOTHkRIPXMski2B4nnvG2?=
 =?iso-8859-1?Q?lizYGqVUf25PxmniSHY6BUwEYb+EDj1MDrDnjV6qcxOKn8xOhba3qGOZPK?=
 =?iso-8859-1?Q?KHHfe/8oaL0nYUuKHs002F06QE5KI7+XBMMdkpzs+YnFAaBolB0HLnqLs1?=
 =?iso-8859-1?Q?mG6RH7IUO1aLdndthZOrD7Is3bjwrXWyuZNUykQTnYiWeOaSRIjUANdow6?=
 =?iso-8859-1?Q?rwEsj2zZBYnhkbQeTCGhzuiZ2UIbQApKaeC7GMR7oZySmJ+jdC059TM9c4?=
 =?iso-8859-1?Q?Ur165znPbbeW5W4iccfxflXsHKTkUKE0VDEzgjHV38TPA8Etj3mGyd9A1G?=
 =?iso-8859-1?Q?5NQYfmzt0E4udU2BGvi8HAymwZ2d3JBjUDAWHC4yydBHJYkEnepWnL+2co?=
 =?iso-8859-1?Q?/PoH5QPUh9PgnqgBg9PAv/JUmTZTaLju3ZhVfW2mtlTgLhvgEWwni2D0T+?=
 =?iso-8859-1?Q?Dg7OQ5SYBZ7ooftmJ6/QtUJMfLgpTFtdkN7qhr8jBN5Qhdh+WOlAdvI4tm?=
 =?iso-8859-1?Q?bbWawlAbleIwv6N5SEc=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8731
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F9A.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3c9399ca-3544-488e-8f1f-08de552cbda5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|14060799003|36860700013|1800799024|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?K4zHwBzFa4+Un7OdavNUv0/cb5weaGDUjrFWefBdBWjn57F5b9lU5LWmyL?=
 =?iso-8859-1?Q?3sXZtPy4tPRi3s5u2R+y+iF4yLayI80EXWMIuJjcNnNpQ0usmBP6jwAfSF?=
 =?iso-8859-1?Q?1DNR16SxxAfEKi3Umesfq1izNWDmmTPPz1sHghLWGNMByc64eunHtUlRtZ?=
 =?iso-8859-1?Q?R+aE78BbEt507Gv6Hnr6u3Z7Yl3v+R43HHhBJVpTlXZGt9VcybR4z47jv8?=
 =?iso-8859-1?Q?/w4kJvq+bYbt4V8vaILaqxrDNuqO2yoTW7+Q0LUZTNbZVfUaN/hMFyaDrK?=
 =?iso-8859-1?Q?JGu/tsxKluHeG9TWfa/JRp8/10X25bfTYVgWJArKbErEnd8Zb5uMyuRWkh?=
 =?iso-8859-1?Q?O9H6j0zsl4tDbW+i6BRK47+XCuTxnOUF/ltRShTuBjUB9taetfmNLKpRe4?=
 =?iso-8859-1?Q?uSVv0N4OiG99Qsp2Ccagm0aglv0RSvLqKOsZNLdew6S/yJhMup1FjuOhqm?=
 =?iso-8859-1?Q?OLepCGMtgzFmQNs8zpeTs0bXcMAgVwl5EGWZXb/JB4gkMCWT/rEmmm7KZz?=
 =?iso-8859-1?Q?kcJBH2uEWNZAGrutWcnwGuZqM/tEqNSszm7q0N34CeDm+MN2MjgWOAiL2h?=
 =?iso-8859-1?Q?oZtPaEjJwSPQBQSQgghyWfvIVPF515NlBX8xumChGhC2yyQpncsfshSi0k?=
 =?iso-8859-1?Q?j5bGrNrlF8JR+/L09vFjM0oSC5hD/k88xraPwGzwJtWxgJOHIlXvGzPprr?=
 =?iso-8859-1?Q?/YfUmEYF6/2aHOXsxbDwgO/8FALVlw9hZv4HB90RofIxXGUXCzCti1Yprv?=
 =?iso-8859-1?Q?fdoXYdrpGGCTWWJcu3Dqkzj0qvxqw12VSB4l+CB1UwaAa1Kw7jV6tUAAmB?=
 =?iso-8859-1?Q?jZLNSvzoo0LavvfxECfPMiusJIxPUyd6LddobcfqOlm4HXOrvDpgKb23H4?=
 =?iso-8859-1?Q?PP80lF0WGgsu6+2btyW8b3ofUBUAB0KB6WGgXQe57KrQiX7gx99aDdLcOo?=
 =?iso-8859-1?Q?ONSn8Q8/xnjgIwm8gx6Mh+Z+IwMSEp/HT6qyok//tPVrgmbMoWEFoZHEAe?=
 =?iso-8859-1?Q?g6lcG2IMswuOjXEXmwjrZd7fQqTTJM/DfxT7mkbEa95Mo5Dms4Cie+CY94?=
 =?iso-8859-1?Q?A/jGYCg1dLk9JWKsMFmIywWihn5Dbs57S7uFQl+MbQP2OdDWOMYYHzlQ5C?=
 =?iso-8859-1?Q?AI1c6JApzF+xUPRQx2Jy/9w2mTA4rPFY+9xGyzeRVzq0eqDkCCW+/W7owQ?=
 =?iso-8859-1?Q?HpipX4NdjexxxXamYPXQkcLDugn3pCSjkCVaSRpJfEwrF42rBegq3SBL1p?=
 =?iso-8859-1?Q?jioA6svXbXZ52Q8ybx6Py39cKlXU+2vLJLztqTW96fL/KUllmQL32j66c7?=
 =?iso-8859-1?Q?yq7/9qWYaRtLBPm/wLSWVkuxb3k6lOMpYaFnZmWW1jIxlpPpU17OkpKiNt?=
 =?iso-8859-1?Q?Bq5eE6n8dxihOXf5BIdKhO/Ka2EyyFeDM5VprMv3xcZhcx98RmBp5lC4b7?=
 =?iso-8859-1?Q?IJM4GzYd6wMQpdNcx3Q3ohRGG9B5aToIw0ju9WWP4fuW8CXMRjoMpG3TNN?=
 =?iso-8859-1?Q?0qgyBgsL20P34LpgGMoH/drmfclmhH+jY/oaFCUGLSiNF3uHhq4/opdu6s?=
 =?iso-8859-1?Q?8NA4Q1LOCUqKn1uy1g5kYoU3uPTCDhYPZ4fjIWRn74OBsJ8oeuTxyzkgMC?=
 =?iso-8859-1?Q?FavILfihvDGWpyCV/CqvRLSaZudrGZ8xrw+ExsfjrafpxGCBqvnrxEWZCk?=
 =?iso-8859-1?Q?ZzOn2j+ayE5lI8gcHPQQ8v/T9rVskDVzgYYbcz1kucGG4mAKiyAsott/jn?=
 =?iso-8859-1?Q?PjEg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(14060799003)(36860700013)(1800799024)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:27:20.8512
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31cbe673-86ee-488a-f8b1-08de552ce30c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F9A.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5427

Bump the core arm64 GIC code to also support a GICv5 configuration -
invoked with `--irqchip=3Dgicv5`. Only the core GICv5 device is created
and initialised. No other GICv5-specific configuration is taking
place.

These changes are sufficient to start a GICv5-based VM and use PPIs
with some big limitations (realistically, only the timers will work),
but do not include any changes to the FDT. Therefore, any guest that
requires the FDT to boot will fail, i.e., Linux.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c             | 23 ++++++++++++++++++-----
 arm64/include/kvm/gic.h |  1 +
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index e35986c0..879f956e 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -41,6 +41,8 @@ int irqchip_parser(const struct option *opt, const char *=
arg, int unset)
 		*type =3D IRQCHIP_GICV3;
 	} else if (!strcmp(arg, "gicv3-its")) {
 		*type =3D IRQCHIP_GICV3_ITS;
+	} else if (!strcmp(arg, "gicv5")) {
+		*type =3D IRQCHIP_GICV5;
 	} else {
 		pr_err("irqchip: unknown type \"%s\"\n", arg);
 		return -1;
@@ -182,6 +184,9 @@ static int gic__create_device(struct kvm *kvm, enum irq=
chip_type type)
 		gic_device.type =3D KVM_DEV_TYPE_ARM_VGIC_V3;
 		dist_attr.attr  =3D KVM_VGIC_V3_ADDR_TYPE_DIST;
 		break;
+	case IRQCHIP_GICV5:
+		gic_device.type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+		break;
 	case IRQCHIP_AUTO:
 		return -ENODEV;
 	}
@@ -201,15 +206,20 @@ static int gic__create_device(struct kvm *kvm, enum i=
rqchip_type type)
 	case IRQCHIP_GICV3:
 		err =3D ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
 		break;
+	case IRQCHIP_GICV5:
+		break;
 	case IRQCHIP_AUTO:
 		return -ENODEV;
 	}
 	if (err)
 		goto out_err;
=20
-	err =3D ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
-	if (err)
-		goto out_err;
+	/* Only set the dist_attr for non-GICv5 */
+	if (type !=3D IRQCHIP_GICV5) {
+		err =3D ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
+		if (err)
+			goto out_err;
+	}
=20
 	err =3D gic__create_msi_frame(kvm, type, gic_msi_base);
 	if (err)
@@ -258,7 +268,7 @@ int gic__create(struct kvm *kvm, enum irqchip_type type=
)
=20
 	switch (type) {
 	case IRQCHIP_AUTO:
-		for (try =3D IRQCHIP_GICV3_ITS; try >=3D IRQCHIP_GICV2; try--) {
+		for (try =3D IRQCHIP_GICV5; try >=3D IRQCHIP_GICV2; try--) {
 			err =3D gic__create(kvm, try);
 			if (!err)
 				break;
@@ -283,6 +293,8 @@ int gic__create(struct kvm *kvm, enum irqchip_type type=
)
 		gic_redists_base =3D ARM_GIC_DIST_BASE - gic_redists_size;
 		gic_msi_base =3D gic_redists_base - gic_msi_size;
 		break;
+	case IRQCHIP_GICV5:
+		break;
 	default:
 		return -ENODEV;
 	}
@@ -423,7 +435,8 @@ u32 gic__get_fdt_irq_cpumask(struct kvm *kvm)
 {
 	/* Only for GICv2 */
 	if (kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV3 ||
-	    kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV3_ITS)
+	    kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV3_ITS ||
+	    kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV5)
 		return 0;
=20
 	if (kvm->nrcpus > 8)
diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index 8490cca6..630f0bbd 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -29,6 +29,7 @@ enum irqchip_type {
 	IRQCHIP_GICV2M,
 	IRQCHIP_GICV3,
 	IRQCHIP_GICV3_ITS,
+	IRQCHIP_GICV5,
 };
=20
 struct kvm;
--=20
2.34.1

