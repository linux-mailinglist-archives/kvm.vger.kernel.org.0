Return-Path: <kvm+bounces-66386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E55FCD0EF0
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:41:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7CD223048D66
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A205837D52A;
	Fri, 19 Dec 2025 16:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ew0V1qpl";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ew0V1qpl"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013016.outbound.protection.outlook.com [40.107.159.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BECA37D11B
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160847; cv=fail; b=ZlppbAUiqnKwmCWIOvbUe01VbFtnB4fMgJNIcjimlSC3tdLU3B+9cpzYxojAY1Eu+dcaULeGghxjTDAWnaexqDcuBRJMNrHTAXIVFU0EKIUcEekrtRm6YHvavVtcUp2pGXWgCMLcv8/i4XR2YWUIqMsip4jxQ/joJPOYJyYY6yo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160847; c=relaxed/simple;
	bh=DW01R0RRrasxgSvFOIz2KpjHMTUVrJZ1KH68SZICAao=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ew/oTpyMpGo2/j9TN/pGvep8RfXONzGk7woROK50Z5tmhsc3w+R9BGXlHNtH8purnbhwetpBT6WjZwmIFekaHHJyOhuxsP8gkDFvck+DNWzbBSay+apA7FPAGZnn4AfRC5cmn5aCjc0Z9eZNXSGjxNUw7d7LJGLfJl+EPpHNuVw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ew0V1qpl; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ew0V1qpl; arc=fail smtp.client-ip=40.107.159.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=CdlLQyk0b4mlmxU8d1USicoGp94d9/rjN0GiGm2i3hbxJrSS59EX3gTqBavj+A1ncCk2Nfp2sm/EouBP3azjHi8L+SRQNjWmyz8x5nptPgXpMEaNKpFzEMgDhp/kPH4zdqgWkX2YdqJwPStzP0zTCWJEbnnWfnT3VC7v+6y71ErQziQfhEE15n0QMaL29ESp9/wb4+tNhAehyxMNcw2yoxLjjQGC7I+vUUsZN8mWCAvdxI7CnppQlX4AwpQWUuIoaxPdBr+S+1rmGBOHRt00Dq8a7FhVRylrvsv6ApJy9fB74Sq0EnSv3HmDOND0WI/9ZoCAad/UBYiIjnC27RJDug==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OF/9lhvbepFECrPoHoNry2e5HwxAxeA7uVnIirYrGIA=;
 b=gMghRTKfNdQPWUvYrwEEnl5hxn6QsQ4nl5sy3QdpAusS/sNvXi57FedqvtcO2HQqp0M8dod4qCP33sQ+C3zZKGGEFEi9R6eDeuH396DiDJsBeChNYqAuwcfc0/N5mqzPsLwOK3qzRDwz51BAvesLfWhBB7Bi5eETXrhTSQZLqfx9ogYfip+t6SdFwJAIV6hF24KGDcn/YQqQX+1yTyRQLDAD2ftE/1a8lIeUXqIlMcrWrMb6EhvPHNLTw2Gb8QqKWINKMxjqUsLXlS7eeunxwcwCDUH1vWHN4TD2ZaLjNdmZUxEtO6spwbpGLWUXePXVigiiVcYTW4vaDkV4XRClnQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OF/9lhvbepFECrPoHoNry2e5HwxAxeA7uVnIirYrGIA=;
 b=Ew0V1qplQJ3P7B3R13/6lePC2aFbi0M/gVWsrtxMJPkCVwa5aGoIuuORveAC3VUNbAIAZJQvUqR0tV/64T0ajPK54BmB1MDW3fxMpC/E2GYSWQCsgTuCpzGmci4MrrbsN50PhJkKklL2a59kDDbahlBt3dM5soVB9TVE5770N90=
Received: from DB8PR04CA0025.eurprd04.prod.outlook.com (2603:10a6:10:110::35)
 by DB9PR08MB11532.eurprd08.prod.outlook.com (2603:10a6:10:608::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 16:14:01 +0000
Received: from DB1PEPF000509E7.eurprd03.prod.outlook.com
 (2603:10a6:10:110:cafe::fc) by DB8PR04CA0025.outlook.office365.com
 (2603:10a6:10:110::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 16:14:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E7.mail.protection.outlook.com (10.167.242.57) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 16:14:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H5tjvXToPMUsVflZcE1ngsO3Rsz2ppdhkE4+CFffNhGYVJaCxkZS6EDrGu2hA2Uyu5/TEHnnvUrfTvwcT90QjB9YGgRftJUe/VkJ5LRxS8ILbpoa0XJQm8FXTTptxUCvtitcGoCxzZkrm3zccLBpIlL62LgxQMGvOhiIJC4AIDC11nYUbPNCXyLyKXyUIKROzCus5ISCzWhjFTBcew3NwU2ocQ3L0mgwj3I6OVfoenyKAqM6RKYuheDlkFndOwui3jiCQSAcQJCVn9Bt/nuinNKm/25T57A7Piny6ZtzDdW3+gqHSjkp+SDm4o02kzF0tVY27MrEz2YrgQPFufxECw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OF/9lhvbepFECrPoHoNry2e5HwxAxeA7uVnIirYrGIA=;
 b=HQ3sfIrHCGT5KVsPxnjdjvKDhXtpSkaLbaqT/wz5b9gUdkXcwfEpr72uCxw6i9Yaw0gmeJuOc/HvPb/TZBCcvErrnP2yinVkQZD0MRdee1ZrWBkTnL0efxIJWVTRVJx9Fl841ayInAXyQqBmuLJujHp1Rs6dwWymYe9d2FPZGUCWXaNO3mWaBZdtM4jx4kBCARqkxbOYKsQpMX3u/B9YOsT4vgsfVHgETuqz90kmWlqBNOHhHMf91akQzY/qZ2/p1okX94wq6PsnOS3sWCOnpGKmvHooXzaJDHuwHdfeUPD5t0SLiK3Yoeh6qaPXrHnbVYY6od9ec4raMMpV6oyisA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OF/9lhvbepFECrPoHoNry2e5HwxAxeA7uVnIirYrGIA=;
 b=Ew0V1qplQJ3P7B3R13/6lePC2aFbi0M/gVWsrtxMJPkCVwa5aGoIuuORveAC3VUNbAIAZJQvUqR0tV/64T0ajPK54BmB1MDW3fxMpC/E2GYSWQCsgTuCpzGmci4MrrbsN50PhJkKklL2a59kDDbahlBt3dM5soVB9TVE5770N90=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by GVXPR08MB10452.eurprd08.prod.outlook.com (2603:10a6:150:149::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 16:12:55 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 16:12:55 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 02/17] arm64: Add basic support for creating a VM with GICv5
Thread-Topic: [PATCH 02/17] arm64: Add basic support for creating a VM with
 GICv5
Thread-Index: AQHccQJVxQEEXgOxd0GTLBa+6tzALQ==
Date: Fri, 19 Dec 2025 16:12:54 +0000
Message-ID: <20251219161240.1385034-3-sascha.bischoff@arm.com>
References: <20251219161240.1385034-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219161240.1385034-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|GVXPR08MB10452:EE_|DB1PEPF000509E7:EE_|DB9PR08MB11532:EE_
X-MS-Office365-Filtering-Correlation-Id: 91ecf240-4f2e-4853-1a4d-08de3f199f34
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?zPPdOAbNkJjix9tnXRNrzdmCC9NUfeqY0NKc9Ew717I92iAvxZQqeRjnsi?=
 =?iso-8859-1?Q?zqS9dqyQ/vFZL4vsudYaTGG20dEmxKXOaIhAkRim4+0fiwYYrUAnmMH645?=
 =?iso-8859-1?Q?9BIoPYgmpFkn9H1VTFejce1rrmcvy9vppc3UamrxW4+tkqSIbkpsfRi7XG?=
 =?iso-8859-1?Q?Va7hUvadzL/kCpU6ci5M0ZoCnm5Y5Hc2Qgy+nhqJHEPaNFFF7RaqYJ9/Nl?=
 =?iso-8859-1?Q?d4BZM8XMLVchmZ1HuAaKqwd6asYWI1DX5CPBBpAlpffWyehhjyl8XZOvYY?=
 =?iso-8859-1?Q?jPUbo2kuKNsEgOnvtvzykycZl0KZqFs3Ul2ZymHjaYzKTekYS30yR+Hbcr?=
 =?iso-8859-1?Q?d8A40GczVuNtvDFJ6+sOgRGUYr9o2mo6ZMG18qwAf34bDaEe9bXi/Mqfns?=
 =?iso-8859-1?Q?JM8f3hVchlfhD8xKGh3fSUTpxaEUAvuArvO9ItFrZ6xSHPLVDMYMjDuymZ?=
 =?iso-8859-1?Q?v4RWX7vPi0FtVLPK4f4xoxJBdsrvDcdvJB0YRH8CnKp1kdshFCOf1ChhXI?=
 =?iso-8859-1?Q?71AgnCiQy23h6oKQ91VdHy/WP5Qg8undfZNL8QEVckF1FXVY63269pKeqY?=
 =?iso-8859-1?Q?UYFdr3vWZ7/MOaRfhCR+0H5IWfgDwQM5jdUe1jokujcaWjxBrpXkSBzKj2?=
 =?iso-8859-1?Q?l7u56kBrVs61VTy93jl5RS5wPa/xAWWHfdZKH4OnpHATdxQj1AQkD6F4SF?=
 =?iso-8859-1?Q?Tb5Ij29oIrhhzEQuFnElQX1u8q43QbspdFLjS+RRWvOG/HbamAC6OILOA7?=
 =?iso-8859-1?Q?7ExWu+m5hPwCPr6x+O7VuktcQfirBPlQwkHGRFkW02qr6Mtaaxazf8rNBJ?=
 =?iso-8859-1?Q?7CJVTk9ta6k/5Z+o6/TyKVQ3JqOfLPHyRo46IfL1rAWd5ac5ksMnd/boiQ?=
 =?iso-8859-1?Q?w6WA0lI+qe7zmcqEeZVDko9wKK7zis6ByXYew3oAoewtvg5MgoP9iNc7kX?=
 =?iso-8859-1?Q?qHGYh8z7ggk87WFWPbf4x3IV6yvB7xWq1GXiF6OKY68KEGz+BGI39CfrBQ?=
 =?iso-8859-1?Q?h9aWTgfJUMLVxihsowL9e2CaDMOCoZxqaSL05KqrHHzvqK+xMMuaVWdDjq?=
 =?iso-8859-1?Q?LwtvBPUKuTh5b/M72NePvjqcmOgAoNyI+zgoS/5n3Hvc9n0p+ftYDhGvR1?=
 =?iso-8859-1?Q?JS3qcXZOUOffmyyHDD3KRDMtO9AwJNjDzrjm6bOLyeoG/0rb5wMnPpbXVC?=
 =?iso-8859-1?Q?ARXdHF5hR7Os1/9V6fid6T71vL4L1LoXE3DpR/GjYHVevBl5f5h+eekH2q?=
 =?iso-8859-1?Q?lwqQDt/49SvkBWeN/xOFFlHUZdnjdRQMbbb0Q+t6kV4yFwEJ/b0GUXiBkH?=
 =?iso-8859-1?Q?2gx9kAyoPX3X0Qk0le/dfV+NNfhA4IjnIPnnb7YFrlt4pnrL5rdEslYdeb?=
 =?iso-8859-1?Q?kNhpGVZr5KJY+ZZmL83Txt1/G6ir0Uh+FeueDjrdefi5d5H4rchQwsl22L?=
 =?iso-8859-1?Q?iMq6JjSXqABU38uTqfoVsSGAbBVYRNkhzm+wUbtLcMWWY6zIOPsNoWpKpx?=
 =?iso-8859-1?Q?X1fH3w4MY8dbu0inecJp+6dI5ClOj3PuwoT9wtjpxs4ecQTd9dnbuEg848?=
 =?iso-8859-1?Q?hf9elDZ2/eFin6pCv3z6QYuxvbXn?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10452
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E7.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ad166440-a01a-4cb4-924d-08de3f1977cf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|35042699022|376014|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?p8teVw4T/8teITkbcM5Rb61sKrGQNxJ9Rfb3mmcmP+SnLrtMZxoC1MQ3at?=
 =?iso-8859-1?Q?etP932K/FaGnpbTTm7S2up9AboNJsS1VGkPGOQQISZ005V+8Rw1gzNsuz+?=
 =?iso-8859-1?Q?nEZfU3B2YFyQiXLABn0F2C5HRW2tVsCM4LViP0a6rDIZXVUGpp/XcBU/HI?=
 =?iso-8859-1?Q?Ob3jt7HnbCDtb7vMgGYgjaafY1EBfYGRu96qtkph2JW7GkroEEm8bcO2lw?=
 =?iso-8859-1?Q?L3tmxgKy22VnP6OW7TxysiRyAFK6yqKWX6oCG6DCU7JRsuAoKqKhvEeVgc?=
 =?iso-8859-1?Q?DcQO4TUUhOu4UagaciJll7FtFvjuLTIYDil6HmOB4MkxgUVoZjvlQBCMrq?=
 =?iso-8859-1?Q?cG3DPPpD9p8AP25zQW7WrCSvOISUc8L9ZvRPc12wgA4fiKqJvvpAfXqTiH?=
 =?iso-8859-1?Q?DIC/6sbNWL6BPT1DaJ4uEMhF2C9rqw5SJXMRVnPCtUgL9DNxYnxQ0DaoJT?=
 =?iso-8859-1?Q?ajVU7R+hcG+MDD7f9ycSipnMpi85kiY9XSsLFm+apgeMNZSkoq5GAft1Dj?=
 =?iso-8859-1?Q?Y5TvH6bum3m6Z5ynmyjIx6HpqLjTyn7E2TLjQ+mlCfNf3VQp/QDb4bFhB2?=
 =?iso-8859-1?Q?9MwifAiVvhwVXPFNJnA6IzPnxuVZ+N2rjv4cGh9DP0GdcNBE7Ly98wA9gv?=
 =?iso-8859-1?Q?oV9VYBNro1mwxkRXc1gOLIipYXQKoWrPVAwfTxgkYEjKmru5MRniCnPD2N?=
 =?iso-8859-1?Q?5MXPShzh70UcJGCYy9PGdPdlw0UL/LepGDeSzhQSSTTBRYT0iHD1keprxA?=
 =?iso-8859-1?Q?rRj6M/D3ru2yvQqI8kbNFFf2fOCsF1Rk5pFAh2NKKUOAB2mGPca92OMQ8r?=
 =?iso-8859-1?Q?FMKs2n5+u+mjAAaSBlTZu8HC/jgquN0U8DHFRoFCmEavy9gwu5Kb13L7m0?=
 =?iso-8859-1?Q?A4Gq4nh4YUQ0vb0rwrxcQ+xVEwQLThPkci3YWES+jF3QNCSyE18BFw5TVk?=
 =?iso-8859-1?Q?Q2xuGw9XpZIvyS41MnIttNdKfr9jB0m87UOiLmvy5n7/Fva9nhEhJf0bRC?=
 =?iso-8859-1?Q?EAemEQoqQp2sKEcvI+Zf6ou2ipSIo5mVFUWvfKPU8AyoDcEq3Pt/bdNOTZ?=
 =?iso-8859-1?Q?Oj/jTDxMziA31M51cwsqoI7JeKAqBxuz40SmshKA4Xl2HrmOpOZ7P4EHXH?=
 =?iso-8859-1?Q?LOGt9WBBNZNAozXvvpMxoEdZe9Gmk6dh1erJBCX3mjl1mSmPbkZu0YEqaZ?=
 =?iso-8859-1?Q?MWA7dpGkpFuu3YCATcwnMT1lxNiDn6VyF7OxaPbgXofxdSPui774TVSDl6?=
 =?iso-8859-1?Q?9dGNObR/4Odsouh7OA20+BU9GjdCSe+858Zmfgpnq4FUK82rzSIc60dxAH?=
 =?iso-8859-1?Q?fCCHBp5gP0h3GTT+KayYCGXkBkGh3LR3L/kLkb98Cf3OCXZ8pLZHu6sSBX?=
 =?iso-8859-1?Q?SOTd0PLpuK7IYGjiYzkN22uiCZtsN8MwyCvkYX6UV5V2HBmqw6fzSEX5VI?=
 =?iso-8859-1?Q?kvbpZ4xnTUx8/TizQ4dM3cN8BaAK8xlIUvdJDJyHi4PgejX4ITcNn+OBUf?=
 =?iso-8859-1?Q?HPQsTE+S7NkVfQsP8WBxeoBYrZnHSYiWkfAYdsVFfHMR5FOofE42sw80xZ?=
 =?iso-8859-1?Q?ROUEwSdojxMG4KAPYKYhbD3M9ufvLbjzSsRehZgBU5Ob6UqsucOF/8bpfe?=
 =?iso-8859-1?Q?NIZntFfWQ6Zok=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(35042699022)(376014)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:14:00.9854
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ecf240-4f2e-4853-1a4d-08de3f199f34
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E7.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11532

Bump the core arm64 GIC code to also support a GICv5 configuration -
invoked with `--irqchip=3Dgicv5`. Only the core GICv5 device is created
and initialised. No other GICv5-specific configuration is taking
place.

These changes are sufficient to start a GICv5-based VM and use PPIs
with some big limitations, but do not include any changes to the
FDT. Therefore, any guest that requires the FDT to boot will fail.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c             | 23 ++++++++++++++++++-----
 arm64/include/kvm/gic.h |  1 +
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index 7461b0f3..8e4ff846 100644
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
@@ -420,7 +432,8 @@ u32 gic__get_fdt_irq_cpumask(struct kvm *kvm)
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
index 1541a582..83fbf89b 100644
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

