Return-Path: <kvm+bounces-50121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 38D8FAE1FD6
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 18:10:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7413E1C21005
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 16:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3658F2EAB61;
	Fri, 20 Jun 2025 16:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Am448sw1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Am448sw1"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011068.outbound.protection.outlook.com [52.101.70.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DFA2E7F13;
	Fri, 20 Jun 2025 16:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750435716; cv=fail; b=rR1Q5/fkTuB+LOPfSalUe6st/E2fSxYNCr3XOX2K+WlxFW7AyZEcNhEEovNL8cbYzycMGWj6KCgqLkWQMVqVlDolluSD4eZICgIqcNXsW0P6Fff5SZ2l4+eeFWY+Y60aWL5rFCyl+v6WQyEN09O59//JvrjArzi9eRMl29ePJ3A=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750435716; c=relaxed/simple;
	bh=jAr/E+5mqMwwQ6p07w7RGKSOUb+kVLds81NUfTIpOiU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ohKaL5gSTFroELm628moRZMqx+s2CHryZXETTKQ8PLUvlBH4ykeWgo+UqxN1cKZr97JJQPB5rLLFUSEK+Je9K+CKozvYsVhwlVY+LliQLLkg2bIu6xTT6beF6ZTkHvea3TE8PPiaHt32kGMAY89iVcl4od8OLu5zMHR3rH33bdQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Am448sw1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Am448sw1; arc=fail smtp.client-ip=52.101.70.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=VC8kFKahp5GEQROIxtqLOpn9McvilpOe5aHFanzyZymwtcYHjnasKefNICa+G0LqnyWKgEqlVLDLn5DvLAXDLWqKDbks5a5EqJCud4XMnuDnqevR3RHdEBPxoOacGx+HSq6AzgrrWT2LbyKj4SeYxE8ZFbqrOjB64Wtx+7DNcRpJWr+0ISqOGTYQkgGrBi3LBhf/Mf/1fNMh3CS6ynARB+8Wiae2vQOWGvwiWuw5+g+3thXnP+G991BHvMv93QeHhGTtgs+1CvuB1ewssyocUtBhWnvUyb6IhFdiY149uE0tJJQThJW1tiaECsX+ls2wqZ4oqhaW3ZtZO3Ie/EyojQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IYvde1tpdil9MPmtzJHXViue8NfMU7z4/gnZoPXmRCM=;
 b=eJ4uVFSfUGDL5941fUFS64V8aXlYYIP5b5yxk7dME0I/s3QmMxsazxGeXuyaQiSoXPOBcDxxJPn7EMQjXb+cWisU9oDe02NplTgcE7VB5yogA74X1U3pQ4b5jW0fvz1DqcFf8+7XVZU0YTyth+GLQybuqAulBRH8c23kliy5FluJHVMnYewc9XAIhwSOwJFUun6xqwSDnDV1N41abQr9m8QnEQIxAFedpf5Mp/XYBDzjoYceNmSAirSYpikPHaSjca840nw8ciYlEWOWo3OE+TdWFsRYJ//xZPa9bv/Nl6DfmDHdbbFdO76P3BmQY7TnYtkOYg+KHs1ivRbJ3xsSgg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYvde1tpdil9MPmtzJHXViue8NfMU7z4/gnZoPXmRCM=;
 b=Am448sw1/Un1CJI9tW61AuqVmwK48+iZkSpD9/+g2OxHIg2dC+9DZ6UOJ2ek4qqSDtYzmMLkLHOLs2O3EmjeQiikkFhO/W9kllzY8xhvU2ACCbpOs1/al1xQ7qUZyjp3zZPPsk7Weppiu47+fQzxJOFNNrFM1CHptjEO0kdbgVA=
Received: from DUZP191CA0068.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4fa::29)
 by AS8PR08MB6197.eurprd08.prod.outlook.com (2603:10a6:20b:294::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.21; Fri, 20 Jun
 2025 16:08:26 +0000
Received: from DU6PEPF0000B622.eurprd02.prod.outlook.com
 (2603:10a6:10:4fa:cafe::40) by DUZP191CA0068.outlook.office365.com
 (2603:10a6:10:4fa::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.25 via Frontend Transport; Fri,
 20 Jun 2025 16:08:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B622.mail.protection.outlook.com (10.167.8.139) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.21
 via Frontend Transport; Fri, 20 Jun 2025 16:08:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XE151XhYQcQxu71LL8/OGDpoYqD+nyQ6Y72ul8U2begkXzSSnLd0wL8nYt06z9Kz97mgmZ9JGrQuKHcRmsGVeB/K6LwugCBUGTdm9RdfsOtxNaHCdQxExQN8ybtd2Tydh9a8XJIR5x8wAimB9Of2WJrGCsNBR5qitJdOqJA/lwSg6YMIc+viiHYcQRBNnb3C9g0NbS+4fxWQaPKDDqmvMbZ1gKEbZdcGjHy9Mc2i1ULAcoNeAuilY1PMMRyH8xbu05Nu6xe04/az9bFKlE+hmDHK8xPwRaezJsjQcrhJXld3pmThyVUmbLab9pNnghIW53eumOw8365zC3blW7It1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IYvde1tpdil9MPmtzJHXViue8NfMU7z4/gnZoPXmRCM=;
 b=lrW6xAe8WrXQpSN12mYdE/0MG2N7/s9YdY4N8ZFlpg+fio5yIWnW8Dh+iPMgU/HwJhTH0tH+EbGxjE12yZ8z15Qot01CScF93yHW+2zz0lwRyg5zidLotPQ7PZ66P4AV5gbhNCgs5noAeeGunUOCipQ68V+TGCoUmPD8pc6JJepPA20TBAYZ/V00nCz8DCnH2fnEEuufQatu+iaz5WNb7b4XCLRQXB/AarKo63MxeiYdcNJwWqDZwX5pClqukRyya12Atvv8QPnpn887LBbQdGjHlJnEJa5NnU3+GTRP4Joe3aaO3lR/1YL81v0TUDd4xYt2J5VOUcHsu9/PM1AoBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYvde1tpdil9MPmtzJHXViue8NfMU7z4/gnZoPXmRCM=;
 b=Am448sw1/Un1CJI9tW61AuqVmwK48+iZkSpD9/+g2OxHIg2dC+9DZ6UOJ2ek4qqSDtYzmMLkLHOLs2O3EmjeQiikkFhO/W9kllzY8xhvU2ACCbpOs1/al1xQ7qUZyjp3zZPPsk7Weppiu47+fQzxJOFNNrFM1CHptjEO0kdbgVA=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by AS2PR08MB9474.eurprd08.prod.outlook.com (2603:10a6:20b:5e9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Fri, 20 Jun
 2025 16:07:54 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8835.027; Fri, 20 Jun 2025
 16:07:53 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: [PATCH 4/5] KVM: arm64: gic-v5: Support GICv3 compat
Thread-Topic: [PATCH 4/5] KVM: arm64: gic-v5: Support GICv3 compat
Thread-Index: AQHb4f15BBM4oiETR0uMyl7uJd3tLQ==
Date: Fri, 20 Jun 2025 16:07:51 +0000
Message-ID: <20250620160741.3513940-5-sascha.bischoff@arm.com>
References: <20250620160741.3513940-1-sascha.bischoff@arm.com>
In-Reply-To: <20250620160741.3513940-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|AS2PR08MB9474:EE_|DU6PEPF0000B622:EE_|AS8PR08MB6197:EE_
X-MS-Office365-Filtering-Correlation-Id: 09ac4a00-aa95-436e-0a4b-08ddb014b061
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?d1oMcwWj2VzIok2rvCnxEit6kO63MDMbUQKJ0IcrBeoV/qWn2S3L5MwNmm?=
 =?iso-8859-1?Q?cjv5xksKkChW9jBWb+3tEujCFKCg5Q1+NjHcC9uVQMaExYDkH29KNKE0AJ?=
 =?iso-8859-1?Q?lOlhMK+l1MAbQiwiQ+RlAOOKXPW7vly14kWOmp7ZzrE1VpjbKsh2bMIs50?=
 =?iso-8859-1?Q?c4ldikNHaMOG4ZUHzbH/ELD8ImThpN9CcQZ2203MDIEQ8iDz5r2g58RilN?=
 =?iso-8859-1?Q?BGR/G9Ymcoe/w2qOZXbX8klUQgYDcb4/uWeAi42oJhNY2a7zhgtpMzJ3yu?=
 =?iso-8859-1?Q?6m9HrZxQMFNg+s4l3a0MNUBSPcRLL3iYyU4HlFSCSKmAd8JPcFAF2efuGZ?=
 =?iso-8859-1?Q?R788osMUx2+gBeVkQ01BEk8F5CklcGk24V+OhbM/LlA2IYSU39E4uhJLwA?=
 =?iso-8859-1?Q?O4wHUt7KdK31uoOKaMj5WtzPQ1hP2P6elRwmTc+vTufpvgGlsMjpNUVCra?=
 =?iso-8859-1?Q?DVUxb0PRRCKD4yjYWYCSkETd+ee3mi9L/O/lLX9Hw6i5BH9tNblu3r2ILH?=
 =?iso-8859-1?Q?c7Royoo5c7sTGjVLfCaKJJVMJR5p1lNwK+o7Vx2i/n6jvTR41D0SnDe/Yv?=
 =?iso-8859-1?Q?ULZEdhJ2z8ft2VbdfB2G7NhGkFzbQbALbDfXo6CZNaqUhst+7fDnlskibW?=
 =?iso-8859-1?Q?225uL4OzaGEboNBGx20lL4L0YiW4limKcTJD4sYbtpK8yWysT/eA+7Hbpx?=
 =?iso-8859-1?Q?A4KUW3xXXegNgItRc3Vz4P2yFj+MVnpBYatgZZGuBWjgfdEjRbrx0fu1+V?=
 =?iso-8859-1?Q?LcOsqRaPCtdHOh5EtBPFtN6zuWOZW1muRlYHuw9q/izyA4PsKsEzChLN+K?=
 =?iso-8859-1?Q?ObSqYJRMrpC9Y7zI6fEZltNR+CBqckjxyIjJ2safGX/QcGYW9TrSwLIThU?=
 =?iso-8859-1?Q?V42z7fQWCMLebznBdQ68NHNzbFuyk+sVtF45MzUZ1Y1rN2gcWeq/4Lur7o?=
 =?iso-8859-1?Q?c23z3HrjH31WChVputt4LrwnWg29YdGEner/HWq4HF96eb/PoUi/iRlhUQ?=
 =?iso-8859-1?Q?hqyQv2yzI5Brp06swpW1Tbdf2bJ49CjcGUwyZfsXqH50xrteTJY5mT2Glh?=
 =?iso-8859-1?Q?+oNwdp7Z7cwcOydYGduE+vwTOC49Ipjj44ILR5OaCfqhsTDSoDMSOIdneb?=
 =?iso-8859-1?Q?WTNitP3xPPR5x8BIEAE4/83OocVhOBW1YiTamXkqpoh4zYuWTzDZ4hwmBe?=
 =?iso-8859-1?Q?y5lwnFQepHi3mgjjruLh1SU47PcE4nn6u3BofpdBFfHouRIPc/Xm+Bryv5?=
 =?iso-8859-1?Q?vS895ZEdqEKLMCgPgGoPIgI+gBZ+WlwhTSJJKrm8OZq6PySuiKDiLTTUY0?=
 =?iso-8859-1?Q?sWKVNbZo6pkdJv3cHXfEudSMwX2cWcQ4hCbCyeyh8pgDG/IUji0Fw9gfb2?=
 =?iso-8859-1?Q?6i8b1PTvdQXss9obzbAOPaWUlT0HUni3PpHuZIYB3UgOwMZFDfgI+OuEoG?=
 =?iso-8859-1?Q?IL+Kn0/dbjjpEi10fciCh0oMc1C9R7mSyGw5T03o3QpB2KhkzH/Qkzt9oB?=
 =?iso-8859-1?Q?oGLTZx3RVolDmU2Yairc0Rrabq+9kLVLkSgW4LPOOSiQ=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9474
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B622.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e497ceb9-a7e2-4c77-6fa6-08ddb0149d30
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|35042699022|14060799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?Syo1ZBpQbuEt7NjzdXrnqW8zkscs8w6j8FXTsZxfq8Kvn3npiM19INsvbD?=
 =?iso-8859-1?Q?fxK0E/jFEqN8dXa/jrfP/BcDXVimkZ2+8j8Lzb62rW8nVVJG4EWwTH1bfE?=
 =?iso-8859-1?Q?l6+FKL93OhT8SVCyaEuj4Db/U6bls5/u68ozROSV370BBX7m4P8TlrlOY6?=
 =?iso-8859-1?Q?qxrGOMysLNCsj0zb9HNjeTvXEiyrmH19cqUgy9eZIUT2yZIAa6aWR7lpWj?=
 =?iso-8859-1?Q?OFH8paNYh0I84GplYnpWggq2JgrjHHXcE0VsFtrZYl0EC987TyjS14pwkz?=
 =?iso-8859-1?Q?kyQnlE5d5vAKZ1G67D/GngeBAi2gSUSt+looFFIIP3QG5TQPe7T4kRe2Wg?=
 =?iso-8859-1?Q?A7mBupCTKz/rkbsDRehBxK9C1IaYJEZSyMMM/SGVIwPdajvkOfUZ9u88SC?=
 =?iso-8859-1?Q?H6/hZU0zLd/Muk5hw43Sg8ovrbXk0TlcJfDETNaNa+2bLbUeqdVH2TzBBN?=
 =?iso-8859-1?Q?oM7A3onLhJIqEd1qZItiIyGxzRJg58hIb/2MOVJ7Yojh4Qe+FKPXvR9xt1?=
 =?iso-8859-1?Q?KvmnKzSb1vAZCbpIk/QdE++h4u8kEXoEX7Txlo3Osw0WAOOQDV7ObV/48h?=
 =?iso-8859-1?Q?zbO0ga9HHWMtQGwmzUZZpxDsQS849mgEITejB9PujI5Ld4ccABvdX/+61C?=
 =?iso-8859-1?Q?vo2fL7LkkbWPd4lIvOkmgWVXq9LhPfVWpfcdymNivIj7XqK8TT+ji0W6lB?=
 =?iso-8859-1?Q?9estPbaq7/OtGWDZ8Fb8W9+sPYQs8baLSpEuK8ZK+A2RfyCyVUQzcilDUB?=
 =?iso-8859-1?Q?8ExrRKaxQ2RXboDEkEoKReGKIv4j1zZROVW41LQ/ehqyz9y8puyzgjOX6f?=
 =?iso-8859-1?Q?fHptK0E2SuiPNXhXA/cvNjxpQBY2aBkMKH236dugDWfqC9coSoxN2e1XKK?=
 =?iso-8859-1?Q?TzsvkPZioFiVzB6jDSNuNa7eUWdYbzx8ZRDD3EBTRIXsP8CxCecCXZC2nf?=
 =?iso-8859-1?Q?d6eftncxkG7dtNurXegybdzYWCaWlRhJO3yqIVFZYwnrlFmIWtD6zmkPux?=
 =?iso-8859-1?Q?S4VgENcRqGiO6tJawdVc2Z8CEUNFkzvDNRS7Po5ZgcpYtGveibSRmdjXPl?=
 =?iso-8859-1?Q?+3r55AMcioG6m77OYRXeO7BSsU42fVVxjuHyC7SCKlSKdTwuXyF7MCZMsh?=
 =?iso-8859-1?Q?wBSSGe5qGGShVpr1oLRYbIZEOUI1uWe+HP7D2j3nzOelzDYYQ69A2F8afp?=
 =?iso-8859-1?Q?MSB0cDqyUlxWcWOxUvbGq14VVRGifyCUbsBx+6ygyFYooaH7373zC5AtP1?=
 =?iso-8859-1?Q?KmAVDUEnfhBq7d5W0e2K5yY6Pc/gc3gBOaTECP/Dxekg+rbFK5cnlThT/m?=
 =?iso-8859-1?Q?g5wWhmkk4rYYrCv32ktqQPHczT0yk4YNU+qUFyqK9I9/pAiIMHcjYIYghB?=
 =?iso-8859-1?Q?fXptTW7cRFoAiPrJHvb6rrLNgSFGWaZJmx87OreI+UY2xJfhA6n3KGuSgW?=
 =?iso-8859-1?Q?sZha9O296XX14M0EZTsyFErH0Us22sRJhNe2PqawG2zP3F80bRG+Z+t5C4?=
 =?iso-8859-1?Q?w6XNQTmLJN4IjrOtWTYnl7xnS979+Vcvw6JoyE1uv6HrqHbZe/B8UrxopQ?=
 =?iso-8859-1?Q?skrmvTbRa0rm9FeLMgFvoLHM8Lv3?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(35042699022)(14060799003)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 16:08:26.0325
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09ac4a00-aa95-436e-0a4b-08ddb014b061
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B622.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6197

Add support for GICv3 compat mode (FEAT_GCIE_LEGACY) which allows a
GICv5 host to run GICv3-based VMs. This change enables the
VHE/nVHE/hVHE/protected modes, but does not support nested
virtualization.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  2 ++
 arch/arm64/include/asm/kvm_hyp.h   |  2 ++
 arch/arm64/kvm/Makefile            |  3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 12 +++++++
 arch/arm64/kvm/hyp/vgic-v3-sr.c    | 51 +++++++++++++++++++++++++-----
 arch/arm64/kvm/sys_regs.c          | 10 +++++-
 arch/arm64/kvm/vgic/vgic-init.c    |  6 ++--
 arch/arm64/kvm/vgic/vgic-v3.c      |  6 ++++
 arch/arm64/kvm/vgic/vgic-v5.c      | 14 ++++++++
 arch/arm64/kvm/vgic/vgic.h         |  2 ++
 include/kvm/arm_vgic.h             |  9 +++++-
 11 files changed, 104 insertions(+), 13 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index bec227f9500a..ad1ef0460fd6 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -81,6 +81,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_compat_mode_enable,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_compat_mode_disable,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index e6be1f5d0967..9c8adc5186ec 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -85,6 +85,8 @@ void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cp=
u_if);
 void __vgic_v3_save_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
+void __vgic_v3_compat_mode_enable(void);
+void __vgic_v3_compat_mode_disable(void);
=20
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 7c329e01c557..3ebc0570345c 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -23,7 +23,8 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.=
o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
-	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o
+	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
+	 vgic/vgic-v5.o
=20
 kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index e9198e56e784..61af55df60a9 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -475,6 +475,16 @@ static void handle___vgic_v3_restore_vmcr_aprs(struct =
kvm_cpu_context *host_ctxt
 	__vgic_v3_restore_vmcr_aprs(kern_hyp_va(cpu_if));
 }
=20
+static void handle___vgic_v3_compat_mode_enable(struct kvm_cpu_context *ho=
st_ctxt)
+{
+	__vgic_v3_compat_mode_enable();
+}
+
+static void handle___vgic_v3_compat_mode_disable(struct kvm_cpu_context *h=
ost_ctxt)
+{
+	__vgic_v3_compat_mode_disable();
+}
+
 static void handle___pkvm_init(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
@@ -603,6 +613,8 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
 	HANDLE_FUNC(__vgic_v3_save_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
+	HANDLE_FUNC(__vgic_v3_compat_mode_enable),
+	HANDLE_FUNC(__vgic_v3_compat_mode_disable),
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
 	HANDLE_FUNC(__pkvm_teardown_vm),
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-s=
r.c
index f162b0df5cae..b03b5f012226 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -257,6 +257,18 @@ void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cp=
u_if)
 	}
 }
=20
+void __vgic_v3_compat_mode_enable(void)
+{
+	sysreg_clear_set_s(SYS_ICH_VCTLR_EL2, 0, ICH_VCTLR_EL2_V3);
+	isb();
+}
+
+void __vgic_v3_compat_mode_disable(void)
+{
+	sysreg_clear_set_s(SYS_ICH_VCTLR_EL2, ICH_VCTLR_EL2_V3, 0);
+	isb();
+}
+
 void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if)
 {
 	/*
@@ -296,12 +308,19 @@ void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *=
cpu_if)
 	}
=20
 	/*
-	 * Prevent the guest from touching the ICC_SRE_EL1 system
-	 * register. Note that this may not have any effect, as
-	 * ICC_SRE_EL2.Enable being RAO/WI is a valid implementation.
+	 * GICv5 BET0 FEAT_GCIE_LEGACY doesn't include ICC_SRE_EL2. This is due
+	 * to be relaxed in a future spec release, likely BET1, at which point
+	 * this in condition can be dropped again.
 	 */
-	write_gicreg(read_gicreg(ICC_SRE_EL2) & ~ICC_SRE_EL2_ENABLE,
-		     ICC_SRE_EL2);
+	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv5_cpuif)) {
+		/*
+		 * Prevent the guest from touching the ICC_SRE_EL1 system
+		 * register. Note that this may not have any effect, as
+		 * ICC_SRE_EL2.Enable being RAO/WI is a valid implementation.
+		 */
+		write_gicreg(read_gicreg(ICC_SRE_EL2) & ~ICC_SRE_EL2_ENABLE,
+			     ICC_SRE_EL2);
+	}
=20
 	/*
 	 * If we need to trap system registers, we must write
@@ -322,8 +341,14 @@ void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if =
*cpu_if)
 		cpu_if->vgic_vmcr =3D read_gicreg(ICH_VMCR_EL2);
 	}
=20
-	val =3D read_gicreg(ICC_SRE_EL2);
-	write_gicreg(val | ICC_SRE_EL2_ENABLE, ICC_SRE_EL2);
+	/*
+	 * Can be dropped in the future when GICv5 BET1 is released. See
+	 * comment above.
+	 */
+	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv5_cpuif)) {
+		val =3D read_gicreg(ICC_SRE_EL2);
+		write_gicreg(val | ICC_SRE_EL2_ENABLE, ICC_SRE_EL2);
+	}
=20
 	if (!cpu_if->vgic_sre) {
 		/* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
@@ -423,9 +448,19 @@ void __vgic_v3_init_lrs(void)
  */
 u64 __vgic_v3_get_gic_config(void)
 {
-	u64 val, sre =3D read_gicreg(ICC_SRE_EL1);
+	u64 val, sre;
 	unsigned long flags =3D 0;
=20
+	/*
+	 * In compat mode, we cannot access ICC_SRE_EL1 at any EL
+	 * other than EL1 itself; just return the
+	 * ICH_VTR_EL2. ICC_IDR0_EL1 is only implemented on a GICv5
+	 * system, so we first check if we have GICv5 support.
+	 */
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv5_cpuif))
+		return read_gicreg(ICH_VTR_EL2);
+
+	sre =3D read_gicreg(ICC_SRE_EL1);
 	/*
 	 * To check whether we have a MMIO-based (GICv2 compatible)
 	 * CPU interface, we need to disable the system register
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 76c2f0da821f..de8297ccb31c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1811,7 +1811,7 @@ static u64 sanitise_id_aa64pfr0_el1(const struct kvm_=
vcpu *vcpu, u64 val)
 		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, CSV3, IMP);
 	}
=20
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V3) {
+	if (kvm_vgic_global_state.type =3D=3D VGIC_V3 || kvm_vgic_in_v3_compat_mo=
de()) {
 		val &=3D ~ID_AA64PFR0_EL1_GIC_MASK;
 		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
 	}
@@ -1953,6 +1953,14 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu=
,
 	    (vcpu_has_nv(vcpu) && !FIELD_GET(ID_AA64PFR0_EL1_EL2, user_val)))
 		return -EINVAL;
=20
+	/*
+	 * If we are running on a GICv5 host and support FEAT_GCIE_LEGACY, then
+	 * we support GICv3. Fail attempts to do anything but set that to IMP.
+	 */
+	if (kvm_vgic_in_v3_compat_mode() &&
+	    FIELD_GET(ID_AA64PFR0_EL1_GIC_MASK, user_val) !=3D ID_AA64PFR0_EL1_GI=
C_IMP)
+		return -EINVAL;
+
 	return set_id_reg(vcpu, rd, user_val);
 }
=20
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index eb1205654ac8..5f6506e297c1 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -674,10 +674,12 @@ void kvm_vgic_init_cpu_hardware(void)
 	 * We want to make sure the list registers start out clear so that we
 	 * only have the program the used registers.
 	 */
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+	if (kvm_vgic_global_state.type =3D=3D VGIC_V2) {
 		vgic_v2_init_lrs();
-	else
+	} else if (kvm_vgic_global_state.type =3D=3D VGIC_V3 ||
+		   kvm_vgic_in_v3_compat_mode()) {
 		kvm_call_hyp(__vgic_v3_init_lrs);
+	}
 }
=20
 /**
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b9ad7c42c5b0..b5df4d36821d 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -734,6 +734,9 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v3;
=20
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv5_cpuif))
+		kvm_call_hyp(__vgic_v3_compat_mode_enable);
+
 	/* If the vgic is nested, perform the full state loading */
 	if (vgic_state_is_nested(vcpu)) {
 		vgic_v3_load_nested(vcpu);
@@ -764,4 +767,7 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
=20
 	if (has_vhe())
 		__vgic_v3_deactivate_traps(cpu_if);
+
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv5_cpuif))
+		kvm_call_hyp(__vgic_v3_compat_mode_disable);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
new file mode 100644
index 000000000000..57199449ca0f
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <kvm/arm_vgic.h>
+
+#include "vgic.h"
+
+inline bool kvm_vgic_in_v3_compat_mode(void)
+{
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv5_cpuif) &&
+	    kvm_vgic_global_state.has_gcie_v3_compat)
+		return true;
+
+	return false;
+}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 4349084cb9a6..5c78eb915a22 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -389,6 +389,8 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
 void vgic_v3_nested_update_mi(struct kvm_vcpu *vcpu);
=20
+inline bool kvm_vgic_in_v3_compat_mode(void);
+
 int vgic_its_debug_init(struct kvm_device *dev);
 void vgic_its_debug_destroy(struct kvm_device *dev);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4a34f7f0a864..6e16e303d80f 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -38,6 +38,7 @@
 enum vgic_type {
 	VGIC_V2,		/* Good ol' GICv2 */
 	VGIC_V3,		/* New fancy GICv3 */
+	VGIC_V5,		/* Newer, fancier GICv5 */
 };
=20
 /* same for all guests, as depending only on the _host's_ GIC model */
@@ -77,9 +78,15 @@ struct vgic_global {
 	/* Pseudo GICv3 from outer space */
 	bool			no_hw_deactivation;
=20
-	/* GIC system register CPU interface */
+	/* GICv3 system register CPU interface */
 	struct static_key_false gicv3_cpuif;
=20
+	/* GICv5 host system */
+	struct static_key_false gicv5_cpuif;
+
+	/* GICv3 compat mode on a GICv5 host */
+	bool			has_gcie_v3_compat;
+
 	u32			ich_vtr_el2;
 };
=20
--=20
2.34.1

