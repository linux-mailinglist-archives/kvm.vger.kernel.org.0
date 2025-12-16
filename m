Return-Path: <kvm+bounces-66066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AD499CC28AB
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 13:09:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6EC0230726D3
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 11:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13D40350285;
	Tue, 16 Dec 2025 11:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="URxZ+bdf";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="URxZ+bdf"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011052.outbound.protection.outlook.com [40.107.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48E334FF53
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 11:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886174; cv=fail; b=V600HkNbEKXIPasU/6KrjWKWSHekQqL235+Jg4yHQQsNr24rFrcwkH2XWDzh9EGNDERVizODzGtvi3U7gVb4K3X4xfgwJrYVgS3iAtHs3kxO8C4IxsBdGFo0id+wnV5vzN6vDy4zk9Swi0ietidwmClAl+tSdc1PXWjU+4zZtGs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886174; c=relaxed/simple;
	bh=UbBaWPiEob+eQKYdZTGBdefbGTGtnYa8yz4E41agBxc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lM23f+R/oqB94lDqQw1U6jQb3pjWiwviOqAjwZsvAGADDKOUy8KZ2Ri+F7rHBpIJet1KkrVyE94doK8Pekl7noZP9w3mo85BQT+3/xpjt5ROObhmzMpK1zzNQRn/MfZtRh5sXsdRAUm4Qm5pCrPgcCZ6Y3RWEilHUQ0Fszj4EHM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=URxZ+bdf; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=URxZ+bdf; arc=fail smtp.client-ip=40.107.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=IvfNWuAvcGkY5Qcr+i5/NNttvrlMbwkWN6fruQL1fkkS/wtTl5bBWv3q61ZqyPcAPSZPaRknTUqfEV0sjDNBfdJK1D6lr1l3GGCDB3/yCw95WBmo0oS1Bq4GhRYV0mQdGbNBkCHFBrz/UBxrim+f8maQ4qRwhmG9qLwFWkzurCCLZp+OaUNGJVt7V2MhiklJzYE2U8CMC6gHIjsuAS7IAd1ddg6575myVgZLypKVKTJ1n9gGN99pCunvLAaKEqt++3i+0VXKiMgXT6CWJGtt9DLzHTII8aWoMkA5F+Wgzypp4+hJhfEEOxegvKBMJ6CQ8VdFz93YsXgk/jHJVYrHfw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UbBaWPiEob+eQKYdZTGBdefbGTGtnYa8yz4E41agBxc=;
 b=bXUo2iGW8A5DRXm6VFNMkEdNSDRadc3Ojx0bKLEdJK9R3flkvzsIHXXAhn09FY69Uqu9LQTqd5kmN/f3EHrFPiVcJqSoE9gW+N8DsS84kUIJJy0zcDpWNWRRp/Kr6ASPa4DYaLk8P+P0a4WX548DuuUGLawOGXX+eZlnhk/aICZZbRTjWt33UUXzWiLcGQbhNYHoljtnORcHQeOCiE9YoZMW7BEzpIYUokliEdaQiSxID4FT7d5M3FPnZjRB75XINOyc57a3N8wkHHLogOEt3wfD2bpMsBGthIc5xZBzEws7ZN4L9dJYkmuGWGry2TjqOG4gnJNF61lZGAYldg1aAw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UbBaWPiEob+eQKYdZTGBdefbGTGtnYa8yz4E41agBxc=;
 b=URxZ+bdfvnwveIx6fItRGo/UwnX8LpPRBd/1p+a0wqWpUbNhMjOoot4Iqtcdp2t4yJ+N4E1giDbAVF+eDQ936AaxwJ3mV4PWo/3WY6iJI8uW+SCnKxgYciQ0beY5bl6JuGxaSSM+XfrFj8zIEQblHzSO6eFbHUZtMja8LDY4TJg=
Received: from DUZPR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::11) by VI1PR08MB10200.eurprd08.prod.outlook.com
 (2603:10a6:800:1bd::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 11:56:02 +0000
Received: from DB1PEPF00039233.eurprd03.prod.outlook.com
 (2603:10a6:10:46a:cafe::d7) by DUZPR01CA0084.outlook.office365.com
 (2603:10a6:10:46a::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Tue,
 16 Dec 2025 11:56:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039233.mail.protection.outlook.com (10.167.8.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Tue, 16 Dec 2025 11:56:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cMZ3PhYMdjV1AvE2V6xnEbenQWp+gkLklUxc2xI2QA5fGVQfe8Kq9lw3DtQIMiwMbAJr2jC2AmaHK0eyqO5G6If3FWjSHRRUNTSuswJHsMJK4GuHRUH5yNrDc2yYrkGAnzqQQ+Vt/HaNeLDSHqcN7Juzg1HVbWu+u1uVOGgqLX66nQ0ZK9uHEJbZ971SUy2uQj32fLOasHj3xwHZciZda2dewlAmyXTRNqF3uhJ0VnS29fnHiQaQ2IWT9cMmOTfvBufxLvgyCoASKvuALkKlTcC9FhEYMH+0yMltjKDf7qOvYRHgDuDrV8K92DzVzzk3g4gtHtNBQ5n4XA4jgNz1Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UbBaWPiEob+eQKYdZTGBdefbGTGtnYa8yz4E41agBxc=;
 b=dhqlPZsrJfGVSJW+Pfguo7lDFoVMCXbp4nZovFscukHbZKyLQ9bEgOo3uRp2eng5/88UyHuq/knnq4a6JizOnriCrK1JRsGkbOi/ZFe+7op078JhugzdkX0clDtTbXswYDnbrSPkLzdnxBUnDRhgjEHpwcLdd65m3iNULKxlLmka3cD/1QlsZCUmbwaS8dQAoxhh1Bj5FWmNY7ynWhgFpExrFiwdMKXq34kLn/qp2Gi7xI3E/e+ImYkNhAiCMCnxfaYd3+vSypiBAxhBC9m/NH2zl6ZboTSXiVR1avFtHeJndxBApqz2uAXQNdKdqllHdIzjvMHRsy1YyUAOkv7SJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UbBaWPiEob+eQKYdZTGBdefbGTGtnYa8yz4E41agBxc=;
 b=URxZ+bdfvnwveIx6fItRGo/UwnX8LpPRBd/1p+a0wqWpUbNhMjOoot4Iqtcdp2t4yJ+N4E1giDbAVF+eDQ936AaxwJ3mV4PWo/3WY6iJI8uW+SCnKxgYciQ0beY5bl6JuGxaSSM+XfrFj8zIEQblHzSO6eFbHUZtMja8LDY4TJg=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DB9PR08MB8652.eurprd08.prod.outlook.com (2603:10a6:10:3d0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 11:54:59 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 11:54:59 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH 11/32] KVM: arm64: gic-v5: Trap and emulate
 ICH_PPI_HMRx_EL1 accesses
Thread-Topic: [PATCH 11/32] KVM: arm64: gic-v5: Trap and emulate
 ICH_PPI_HMRx_EL1 accesses
Thread-Index: AQHca3sm8YhLTF3L20aOpfRBsh1L6bUkGgaAgAAUnQA=
Date: Tue, 16 Dec 2025 11:54:59 +0000
Message-ID: <0f686dc9ea9e32fc37a1b11eb95b32cb958ff0a8.camel@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
	 <20251212152215.675767-12-sascha.bischoff@arm.com>
	 <86a4ziogjc.wl-maz@kernel.org>
In-Reply-To: <86a4ziogjc.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|DB9PR08MB8652:EE_|DB1PEPF00039233:EE_|VI1PR08MB10200:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ed71fd0-fea7-4934-5ea3-08de3c9a1610
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?TGxydUw5TmQwL1ZLeGQyN1FObGdsT0dpdzBtRS85VHFLMnVDWllSdktkaUZN?=
 =?utf-8?B?SFE5MnhZTXdvQnJHZ1lJSDNLNHZVcExBTnJaQmdUcGdxd25RMjRzbXFTL3R6?=
 =?utf-8?B?akFTZHQ2UzlJRXUrQWU5L3lmRDZUdnVTaTJtditxd0pyVUtEbDBNV3BwLzVH?=
 =?utf-8?B?azhDaDVBUTU2TStwdi90ZjYxc2JtWUN4aG5KcmZ4SnBES1lKL0hEZ1Rsc1pT?=
 =?utf-8?B?Ni85VW5YMjF5WDVhYisvTkxWaUM1UXhFVTFIR284SVQzZDJOWW4zbDQweDE2?=
 =?utf-8?B?SGhWa1NjdU5Pc2o3ODVZWSt3Uy9CdXV6ZkxBT1ZNbXFGdW9oSnBQUiszSEV2?=
 =?utf-8?B?c3FoL1R6MWJZQ2tHZS9vbXhPaWV3MUVuZzVMZFhPUitBeU5ybGpKUGZXWU9T?=
 =?utf-8?B?c0EremttR0Zsck1FbkdsVFpidXgwVVFGOGYzVEJVb2ppVyt1aEZWV2w5U0lJ?=
 =?utf-8?B?bjYydDlqYVQvMk52Z3pmM09KMlc5NGliYXZxS1IrQktkYnNsdWpGbnQ1eS9u?=
 =?utf-8?B?ZitaNzVOSzV2cDhiNUZOTFBTK0dyWmpEamFjWjZ2SFFWdGs2MCswck1iL2lQ?=
 =?utf-8?B?SUhVMnJNOTdxVlpYYVlqOXdFYlVoUzNZSUZXMG1GcXkrc2NQOEVNaktVSFhu?=
 =?utf-8?B?c0JIUzhzWTVYYzVCR3hhYlVMS3o4cldxNW5QTmlGUjg1NUpkdGtSM0FDNnlY?=
 =?utf-8?B?cjYwQnJrWGdaZDdLbDVKa1JzOTN2WXAzcG0xbUU2U0ttamt1Sks5Vnd4M2Jz?=
 =?utf-8?B?WS9hdmwycDZUcVIwVHRLcThKa2FBVXY1UW5DanZGZlhSY1paemtydk9vTmZo?=
 =?utf-8?B?dW9ZUWpnczVMd1Fudm9xeEdudEFRdEtUMzZMVkxuT1d3WGN2RnV4WVZZc0xi?=
 =?utf-8?B?S2pxakF6blFrS3hwSFljcmVDbERNQWJqd3Q5d3VMNXZ3MGN0WngvT3hTY2ZB?=
 =?utf-8?B?bW9EV2RsREJ6VVFmZ3RYZWpERTNxY1hsOHZRTG9QMFE3UGNEWWlqbEJKdE1N?=
 =?utf-8?B?UWlZS1dVOGZNeGt3aWs5M2F0K0pPSWpnTXZDUmE0SGJoS3dURnd2bmFVUnc5?=
 =?utf-8?B?UzI1UDJ5YzRzbXF1TElEMytjTHhhMzdpdW1CK1BLMDQraExEMzQ2bElSVWJo?=
 =?utf-8?B?em5GYmVYWjBrc1Z0TnZZaWFtU0VSaWNjbzdRRTd3bHVSOXZPM2dFZHNJbVFt?=
 =?utf-8?B?dFpnOHJkRURDd1FWTnFkWWlWQlZXUjVpQnZwTW9Od21YQk1xNEhFb0t0L3Rv?=
 =?utf-8?B?TzZ0d0c3LzlkN04xcHhzc2VDb08vWG55dEZtRVllNjFYK08zUngxMGxIUGF6?=
 =?utf-8?B?eWdiN0FoRWlESVZaUzFHZGxwSHFIZ3BmcWhaeVRjbTU0ZWxaVWZHa2o5Z2hL?=
 =?utf-8?B?dVpnNDZqTzNmS0xiWEh2M1c5VVUyZGF2WFl6aTFYMjVtQUFnZVgzLzNoTnda?=
 =?utf-8?B?T3ZoQzNYV1RSc3JUb2lZNXNUM05CSlIrZVVCc3BkZVJLUFVZODIxQUFSaDVB?=
 =?utf-8?B?Z3NMYktZMVpLVndlWTdRTWtJM3M3dG41OEFTQllOZ1BIZHcrTk84VDIya0NI?=
 =?utf-8?B?dWs5czdQL1hiMkl6ZWwzbzMyOFJDVFNzOWdlc2RER281dGsxeHBqR1NtclNQ?=
 =?utf-8?B?TWVobDJVcWVDUFByeWc5cGx3VEI5R2hhSWJtTkh1ZGhELzNoZzMrWHViZmFK?=
 =?utf-8?B?dURuaG1seGlSS1NDdlVtZzdoZ3VqUFo3V25Dd21FOEkxMlQ1UlhZekJjdi81?=
 =?utf-8?B?a3BPNElnb0I4V0NseVg3WUx4WStLdFBUU0lZN3l0Z3FYNHUreTFJLzM3OTVB?=
 =?utf-8?B?OEhWU0FrYlZEYUNLUG9FZDhsd2VIVHp2dVdnUHhxdElhd2laWFlHMzEvdFM5?=
 =?utf-8?B?aU8xZnlSeGw5ZWhwbWMvZm1qVFkrVzBqdlVpN2U4WnFKaTFUa1R4VzdaWE9J?=
 =?utf-8?B?Q2NLeFgyUElkb2hmL25WTG96MW1FaUlONWxTOU9veWRoVkUvSlFjZThGNitH?=
 =?utf-8?B?OC9vT0MvWTc5c1NIdXE3TkhtcDI3YTA1RStIb0pqSGk2SXBpdVJOKyt1dVlP?=
 =?utf-8?Q?maccqu?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C623D140BF06C468891A443ECA3B481@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8652
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039233.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7a902677-12f6-41dd-403b-08de3c99f07b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|35042699022|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WUFUS2hlNCswT1YvZy9JeXdCZXZ0ZUtXZzFUckUxd2lVL3IrNTMyR1Qvdjkx?=
 =?utf-8?B?aVdIRFp1ZE55WGhnNjY5bi9WTURvZ2JrWHJETjA0YkRLeFBTaUx2T2NKUjZN?=
 =?utf-8?B?SW9TQ2M1aG5rSmNnTUhpdStxaGlCcVlZcEV5RHQ1SG9HdWE4dEdmazBzaUJH?=
 =?utf-8?B?ZHEwV2t5akZJeTRFK29OTXB6dzZBMnBLcW1TMFl0M3BBc3pFWDNzYUFtcWN5?=
 =?utf-8?B?ekl4Q0ZWUzB3NTcwMzlWNGhQcXJQUmZpSFZWTnlXQnFjWWtmWnJlVDRDd1hB?=
 =?utf-8?B?L2p3bTFuNy9WKzNBWDBVYWFZc2Y0dUN2ZmErOGNBMW9qRThWTm5zYkxKeVpE?=
 =?utf-8?B?NTh2VzZaTlM1bWtRSGQ0OTN5NjEyTTRCWldvSWVyRGl3SE5QSlI0VVVUaGYv?=
 =?utf-8?B?UmdQUDdxRVE3YWVzZ1dFdlNRYUxZVlVJRXg1K3FNM2w4eFlORkl1b01XQUFF?=
 =?utf-8?B?b3dQWVd6VGpZNVRTMkdCY0I1aHAvUDQ0bG9YYy9oS0NKckJkRGtpMHlSbFVi?=
 =?utf-8?B?QWg4cHdpMWdiSTRmUU1Ea00yN29qUjB6MlpJMTNEUlJSZXBEYThMVjF4MHl2?=
 =?utf-8?B?WkhaNWpXcWN2ZDlBWGk3OUZTV2xtZnlqSEs4NFBadDcxanN4R0dwVFViblJG?=
 =?utf-8?B?a0UvZnJydE9vWTFuaCtCVi92eEU3aXZWUGZMK3dObG9UWlJ1NzB6MkxnTjhM?=
 =?utf-8?B?SHlpUkNoOENWNElGKytuTDIwcXV3VHNCSVpHYk1QR1RhdmNLQkRkVlZ0Sm9o?=
 =?utf-8?B?S0R1OEdtZ0VueEYrbFVWMWpVejUyeUIzNkc4MjRoeGorUk8vNlRHOXd6cjNs?=
 =?utf-8?B?WnJhNy85OWI4T0FUcVVqTDJ5UFdBM2F1Y0FhNVhKdVZPTnhWbVFyUDArRFhW?=
 =?utf-8?B?Nnl6cEVUdS9uSHBYT1h0aS8xZkdteWJyQ1FjRlk4UGFaTXZkYityTHBydVJY?=
 =?utf-8?B?NVB5bVdHanI2a2hNZ1NpUnoxeUtZcUNBVWxnbDRDTDQyeUttQTF3MjIzdzBh?=
 =?utf-8?B?TU5TOTJCeW5pQzBvR1I0WmpRekNIY09XNzN1QU1CU3N4bW1rWEdCRE9CaFR3?=
 =?utf-8?B?ZnRocGxoQU9VdjFtYkJOakRUejZyTldUR1Z5NEUvVmR3U2xwRHIwMWFKV0sx?=
 =?utf-8?B?WG5HL0FLL3Y1SVQ1VDNCUCtnUmhQMHF6SjR6Mi94amVIZlB1NDdMUnVpQVZq?=
 =?utf-8?B?R0g1WFBZUEhFZUdHVFFXVHE5amRsZlhkaXUzWWZlZC9BODBLQVdXUGpwZnNF?=
 =?utf-8?B?TkJQckViVUw3dGlkczFHWkV2SVpXU3ptbGR0bUZTelVVQzg2dHpTT0NNdjRQ?=
 =?utf-8?B?VVl0SHNaME9jQjdCVzE0SzFuaThZYm9BOFJPZUJaUkNkUHdxMVlUbk9WbWU2?=
 =?utf-8?B?cW01OVZ5dW8wS0pmUHJaNVBBWXZhQ1F2aVpob0lETkg2NDFyQTB5cXVGejBh?=
 =?utf-8?B?OFBaZ0VQMVhIdWkyUmxZU252Qm0rQzZneTJLNDg1Y3JLWDBuQjVjb0tsc01J?=
 =?utf-8?B?QXBTSGg5QjZwMVVvNUNIbjRxN2FPSXFYamYrRVpBQkRHM0tuWi9iNkZiNnht?=
 =?utf-8?B?QkUyakJsVUVXSjhTN21IR1MyMWdzN0dlUHVLQ1ZrbkxrdVo3a1l5ME50NVFB?=
 =?utf-8?B?QjZwUkptcUZhQzhSSDlBdW04UEhua1UvVWFjTDV1Y0RXeWhteDhWdXk1NlUv?=
 =?utf-8?B?WUpwKzZQbC9reXR0OWtQcWdjT3I0dVVTQ2VWY3UxWFBmRm5HQjhvcllNTUdR?=
 =?utf-8?B?ZUZUb0l5ZERBc3NzRjFOdC9FL0lOUWNrUnh1WFBHRVQrS2sxUVNjM1hIS3pv?=
 =?utf-8?B?Nnlud3VPYzhQa1FuLzF5cVZnU3c2eHhKUUduL3NLZlFrdmZKVEFkbjZLVnlX?=
 =?utf-8?B?UjhDUUxQdHFRM2pzZkpZbWlpUmRPZGRoVGZIM0pZeG92aHluQmtXOUdWNEJR?=
 =?utf-8?B?UG1SbU5sY0h5bWVFdlJPTHU2Wm9ROW9nU2Rrd0k2OWVETm93bENJbEZ6am1F?=
 =?utf-8?B?Wm5TVlI4MVQ5SlhSUGU2bTNTWjA5bFFJMnFwV1BiUWFNWnlQelVLNktsNjdD?=
 =?utf-8?B?YXBNck5ydk53Q1J2L0JHL290bzNwTGdwNmg0cmI1VXJLVjBlRzFuSHJieXV4?=
 =?utf-8?Q?MIxs=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(35042699022)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 11:56:02.4779
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed71fd0-fea7-4934-5ea3-08de3c9a1610
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039233.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10200

T24gVHVlLCAyMDI1LTEyLTE2IGF0IDEwOjQxICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIEZyaSwgMTIgRGVjIDIwMjUgMTU6MjI6MzkgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IFRoZSBJQ0NfUFBJX0hN
UnhfRUwxIHJlZ2lzdGVyIGlzIHVzZWQgdG8gZGV0ZXJtaW5lIHdoaWNoIFBQSXMgdXNlDQo+ID4g
TGV2ZWwtc2Vuc2l0aXZlIHNlbWFudGljcywgYW5kIHdoaWNoIHVzZSBFZGdlLiBGb3IgYSBHSUN2
NSBndWVzdCwNCj4gPiB0aGUNCj4gPiBjb3JyZWN0IHZpZXcgb2YgdGhlIHZpcnR1YWwgUFBJcyBt
dXN0IGJlIHByb3ZpZGVkIHRvIHRoZSBndWVzdC4NCj4gDQo+IHMvSUNIL0lDQy8gaW4gJFNVQkpF
Q1QNCj4gDQo+ID4gDQo+ID4gVGhlIEdJQ3Y1IGFyY2hpdGVjdHVyZSBkb2Vzbid0IHByb3ZpZGUg
YW4gSUNWX1BQSV9ITVJ4X0VMMSBvcg0KPiANCj4gVGhlIHNwZWMgZGlzYWdyZWUgd2l0aCB5b3Ug
aGVyZSAoc2VlIDkuNS40KS4NCj4gDQo+ID4gSUNIX1BQSV9ITVJ4X0VMMiByZWdpc3RlciwgYW5k
IHRoZXJlZm9yZSBhbGwgZ3Vlc3QgYWNjZXNzZXMgbXVzdCBiZQ0KPiA+IHRyYXBwZWQgdG8gYXZv
aWQgdGhlIGd1ZXN0IGRpcmVjdGx5IGFjY2Vzc2luZyB0aGUgaG9zdCdzDQo+ID4gSUNDX1BQSV9I
TVJ4X0VMMSBzdGF0ZS4gVGhpcyBjaGFuZ2UgaGVuY2UgY29uZmlndXJlcyB0aGUgRkdUcyB0bw0K
PiA+IGFsd2F5cyB0cmFwIGFuZCBlbXVsYXRlIGd1ZXN0IGFjY2Vzc2VzIHRvIHRoZSBITVIgcnVu
bmluZyBhDQo+ID4gR0lDdjUtYmFzZWQgZ3Vlc3QuDQo+IA0KPiBUaGUgcmVhbCBxdWVzdGlvbiBp
cyB3aGF0IHdlIGdhaW4gYnkgZW11bGF0aW5nIHRoaXMgcmVnaXN0ZXIsIGdpdmVuDQo+IHRoYXQg
dmlydHVhbCBQUElzIGFyZSBvbmx5IGd1YXJhbnRlZWQgdG8gZXhpc3QgaWYgdGhlIHBoeXNpY2Fs
DQo+IHZlcnNpb24NCj4gZXhpc3QuIElmIHRoZXkgZXhpc3QsIHRoZW4gdGhlIGhhbmRsaW5nIG1v
ZGUgaXMgZGVmaW5lZCBieSB0aGUNCj4gdGhhdCBIVywgYW5kIHdlIGNhbid0IGRldmlhdGUgZnJv
bSBpdC4NCj4gDQo+IEdpdmVuIHRoYXQsIEkgY2FuJ3QgcmVhbGx5IHNlZSB0aGUgcG9pbnQgaW4g
dHJhcHBpbmcgc29tZXRoaW5nIHRoYXQNCj4gaXMNCj4gYm91bmQgdG8gYmUgdGhlIHNhbWUgdGhp
bmcgYXMgdGhlIGhvc3QsIHVubGVzcyB0aGlzIGNvbWVzIHdpdGgNCj4gYWRkaXRpb25hbCByZXN0
cmljdGlvbnMsIGZvciBleGFtcGxlIGEgbWFzayBvZiBpbnRlcnJ1cHRzIHRoYXQgYXJlDQo+IGFj
dHVhbGx5IGV4cG9zZWQgdG8gdGhlIGd1ZXN0Lg0KPiANCj4gT3IgYW0gSSBtaXNzaW5nIHNvbWV0
aGluZz8NCg0KTm8sIEkgdGhpbmsgeW91J3JlIHF1aXRlIGNvcnJlY3QsIGFuZCB0aGlzIGRvZXNu
J3QgYWRkIG1lYW5pbmdmdWwNCnZhbHVlLg0KDQpUaGlzIGFsbCBzdGVtcyBmcm9tIG15IG1pc3Vu
ZGVyc3RhbmRpbmcgdGhhdCBHSUN2NSB2UFBJcyBhcmUNCmluZGVwZW5kZW50IGZyb20gdGhlIHBo
eXNpY2FsIFBQSXMuIFRoaXMgaXMgbm90IHRoZSBjYXNlLCBob3dldmVyLCBhcw0KdGhlIHNldCBv
ZiBpbXBsZW1lbnRlZCB2aXJ0dWFsIFBQSXMgbWF0Y2hlcyB0aGUgcGh5c2ljYWxseSBpbXBsZW1l
bnRlZA0KUFBJcy4gVGhlIGhhbmRsaW5nIG1vZGUgZm9yIGVhY2ggUFBJIHdpbGwgYmUgcmVmbGVj
dGVkIGluIHRoZQ0KSUNDL0lDVl9QUElfSE1SeF9FTDEgc3lzcmVncy4NCg0KVGhpcyBhY3R1YWxs
eSBoYXMgd2lkZXIgaW1wYWN0czoNCg0KICAgMS4gSXQgbWFrZXMgc2Vuc2UgdG8gZHJvcCB0aGlz
IGNvbW1pdCBhbHRvZ2V0aGVyLg0KICAgDQogICAyLiBXaGVuIGluaXRpYWxpc2luZyB0aGUgR0lD
djUgUFBJcyAoIktWTTogYXJtNjQ6IGdpYy12NTogSW5pdA0KICAgUHJpdmF0ZSBJUlFzIChQUElz
KSBmb3IgR0lDdjUiKSwgd2Ugc2tpcCBzZXR0aW5nIHRoZWlyIGNvbmZpZw0KICAgKExFVkVML0VE
R0UpLg0KICAgDQogICAzLiBJbiB2Z2ljX3Y1X3Jlc2V0ICgiS1ZNOiBhcm02NDogZ2ljLXY1OiBS
ZXNldCB2Y3B1IHN0YXRlIiksIHN5bmMNCiAgIHRoZSBob3N0J3MgUFBJIEhNUiBzdGF0ZSAoSUND
X1BQSV9ITVJ4X0VMMSkgdG8gS1ZNJ3MgdlBQSSBzaGFkb3cNCiAgIHN0YXRlIGFzIHRoZSB2aXJ0
dWFsIFBQSXMgc2hvdWxkIG1hdGNoIHRoYXQsIGFuZCB3ZSBuZWVkIHRoYXQgdG8NCiAgIGNvcnJl
Y3RseSBoYW5kbGUgU1ctZHJpdmVuIFBQSSBpbmplY3Rpb24uIEN1cnJlbnRseSwgdGhpcyBjb2Rl
DQogICBhY3R1YWxseSBjYWxjdWxhdGVzIHRoZSBITVIgY29udGVudHMgZm9yIHRyYXBwaW5nIGFu
ZCBlbXVsYXRpbmcsDQogICB3aGljaCBhZ2FpbiBjYW4gYmUgZHJvcHBlZCBhbHRvZ2V0aGVyLg0K
ICAgDQogICA0LiB2Z2ljX2htciBjYW4gYmUgZHJvcHBlZCBmcm9tIHRoZSB2Z2ljX3Y1IENQVUlG
IHRvby4NCg0KRG9lcyB0aGlzIHNvdW5kIHJlYXNvbmFibGUgdG8geW91Pw0KDQpUaGFua3MsDQpT
YXNjaGENCg0KPiANCj4gPiANCj4gPiBUaGlzIGNoYW5nZSBhbHNvIGludHJvZHVjZXMgdGhlIHN0
cnVjdCB2Z2ljX3Y1X2NwdV9pZiwgd2hpY2gNCj4gPiBpbmNsdWRlcw0KPiA+IHRoZSB2Z2ljX2ht
ci4gVGhpcyBpcyBub3QgeWV0IHBvcHVsYXRlZCBhcyBpdCBjYW4gb25seSBiZSBjb3JyZWN0bHkN
Cj4gPiBwb3B1bGF0ZWQgYXQgdmNwdSByZXNldCB0aW1lLiBUaGlzIHdpbGwgYmUgaW50cm9kdWNl
ZCBpbiBhDQo+ID4gc3Vic3F1ZW50DQo+ID4gY2hhbmdlLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYt
Ynk6IFNhc2NoYSBCaXNjaG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+ID4gLS0tDQo+
ID4gwqBhcmNoL2FybTY0L2t2bS9jb25maWcuY8KgwqAgfMKgIDYgKysrKystDQo+ID4gwqBhcmNo
L2FybTY0L2t2bS9zeXNfcmVncy5jIHwgMjYgKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4g
PiDCoGluY2x1ZGUva3ZtL2FybV92Z2ljLmjCoMKgwqAgfMKgIDUgKysrKysNCj4gPiDCoDMgZmls
ZXMgY2hhbmdlZCwgMzYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+IA0KPiA+IGRp
ZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9jb25maWcuYyBiL2FyY2gvYXJtNjQva3ZtL2NvbmZp
Zy5jDQo+ID4gaW5kZXggY2JkZDhhYzkwZjRkMC4uNzY4MzQwN2NlMDUyYSAxMDA2NDQNCj4gPiAt
LS0gYS9hcmNoL2FybTY0L2t2bS9jb25maWcuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL2Nv
bmZpZy5jDQo+ID4gQEAgLTE1ODYsOCArMTU4NiwxMiBAQCBzdGF0aWMgdm9pZCBfX2NvbXB1dGVf
aWNoX2hmZ3J0cihzdHJ1Y3QNCj4gPiBrdm1fdmNwdSAqdmNwdSkNCj4gPiDCoHsNCj4gPiDCoAlf
X2NvbXB1dGVfZmd0KHZjcHUsIElDSF9IRkdSVFJfRUwyKTsNCj4gPiDCoA0KPiA+IC0JLyogSUND
X0lBRkZJRFJfRUwxICphbHdheXMqIG5lZWRzIHRvIGJlIHRyYXBwZWQgd2hlbg0KPiA+IHJ1bm5p
bmcgYSBndWVzdCAqLw0KPiA+ICsJLyoNCj4gPiArCSAqIElDQ19JQUZGSURSX0VMMSBhbmQgSUNI
X1BQSV9ITVJ4X0VMMSAqYWx3YXlzKiBuZWVkcyB0bw0KPiA+IGJlDQo+ID4gKwkgKiB0cmFwcGVk
IHdoZW4gcnVubmluZyBhIGd1ZXN0Lg0KPiA+ICsJICoqLw0KPiA+IMKgCSp2Y3B1X2ZndCh2Y3B1
LCBJQ0hfSEZHUlRSX0VMMikgJj0NCj4gPiB+SUNIX0hGR1JUUl9FTDJfSUNDX0lBRkZJRFJfRUwx
Ow0KPiA+ICsJKnZjcHVfZmd0KHZjcHUsIElDSF9IRkdSVFJfRUwyKSAmPQ0KPiA+IH5JQ0hfSEZH
UlRSX0VMMl9JQ0NfUFBJX0hNUm5fRUwxOw0KPiA+IMKgfQ0KPiA+IMKgDQo+ID4gwqB2b2lkIGt2
bV92Y3B1X2xvYWRfZmd0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiBkaWZmIC0tZ2l0IGEv
YXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMNCj4g
PiBpbmRleCAzMWMwOGZkNTkxZDA4Li5hNGFlMDM0MzQwMDQwIDEwMDY0NA0KPiA+IC0tLSBhL2Fy
Y2gvYXJtNjQva3ZtL3N5c19yZWdzLmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS9zeXNfcmVn
cy5jDQo+ID4gQEAgLTY5OSw2ICs2OTksMzAgQEAgc3RhdGljIGJvb2wgYWNjZXNzX2dpY3Y1X2lh
ZmZpZChzdHJ1Y3QNCj4gPiBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IHN5c19yZWdfcGFyYW1zICpw
LA0KPiA+IMKgCXJldHVybiB0cnVlOw0KPiA+IMKgfQ0KPiA+IMKgDQo+ID4gK3N0YXRpYyBib29s
IGFjY2Vzc19naWN2NV9wcGlfaG1yKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0DQo+ID4g
c3lzX3JlZ19wYXJhbXMgKnAsDQo+ID4gKwkJCQkgY29uc3Qgc3RydWN0IHN5c19yZWdfZGVzYyAq
cikNCj4gPiArew0KPiA+ICsJaWYgKCF2Z2ljX2lzX3Y1KHZjcHUtPmt2bSkpDQo+ID4gKwkJcmV0
dXJuIHVuZGVmX2FjY2Vzcyh2Y3B1LCBwLCByKTsNCj4gPiArDQo+ID4gKwlpZiAocC0+aXNfd3Jp
dGUpDQo+ID4gKwkJcmV0dXJuIGlnbm9yZV93cml0ZSh2Y3B1LCBwKTsNCj4gPiArDQo+ID4gKwkv
Kg0KPiA+ICsJICogRm9yIEdJQ3Y1IFZNcywgdGhlIElBRkZJRCB2YWx1ZSBpcyB0aGUgc2FtZSBh
cyB0aGUgVlBFDQo+ID4gSUQuIFRoZSBWUEUgSUQNCj4gPiArCSAqIGlzIHRoZSBzYW1lIGFzIHRo
ZSBWQ1BVJ3MgSUQuDQo+ID4gKwkgKi8NCj4gDQo+IFVucmVsYXRlZCBjb21tZW50Pw0KPiANCj4g
PiArDQo+ID4gKwlpZiAocC0+T3AyID09IDApIHsJLyogSUNDX1BQSV9ITVIwX0VMMSAqLw0KPiA+
ICsJCXAtPnJlZ3ZhbCA9IHZjcHUtDQo+ID4gPmFyY2gudmdpY19jcHUudmdpY192NS52Z2ljX3Bw
aV9obXJbMF07DQo+ID4gKwl9IGVsc2UgewkJLyogSUNDX1BQSV9ITVIxX0VMMSAqLw0KPiA+ICsJ
CXAtPnJlZ3ZhbCA9IHZjcHUtDQo+ID4gPmFyY2gudmdpY19jcHUudmdpY192NS52Z2ljX3BwaV9o
bXJbMV07DQo+ID4gKwl9DQo+IA0KPiBuaXQ6IENhbiBwcm9iYWJseSBiZSB3cml0dGVuIGFzOg0K
PiANCj4gCXAtPnJlZ3ZhbCA9IHZjcHUtPmFyY2gudmdpY19jcHUudmdpY192NS52Z2ljX3BwaV9o
bXJbcC0NCj4gPk9wMl07DQo+IA0KPiBUaGFua3MsDQo+IA0KPiAJTS4NCj4gDQoNCg==

