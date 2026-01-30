Return-Path: <kvm+bounces-69691-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4FzfH0x6fGmWNAIAu9opvQ
	(envelope-from <kvm+bounces-69691-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 10:30:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4142BB8F0D
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 10:30:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C6ED13014869
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 09:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D05F346AC8;
	Fri, 30 Jan 2026 09:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WB40RW+M";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WB40RW+M"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010035.outbound.protection.outlook.com [52.101.84.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606BC2E9ED6
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 09:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769765448; cv=fail; b=QrUg4oJpXv2tk/XEWaDKgP8rQZ0AboUKWp9ful9+i/ZIhQdtijb9kVFpVbA9FFN5Ec7e1WkZ6KG/IB6IOyFlSnjiH7ZmPIeYIx1w74q9sw3Rw7Hw8HsAwhlFcPGJ+9/v0pTD8fzUSkjTcY5/qLEfEDK5E4v5JRkVKLX3PIbaRv4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769765448; c=relaxed/simple;
	bh=tUBtZYwjOw9j9g+BdR5YHY2kFIjYrjpxxQResGFK7HQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R99s0bp0+cRNrKDP64DOxFx76vyxHs7VBilrCOJuXRsCNhuHKT+J6MnmM5SqfK4d0QFWuHfAAR1I1ZXACmnmuK80QZOrtbVleAaIwtvAnCKTaQ8zYA4Dy5Vb9TjtbgyGZFEKOo+xgqElTztPpR3H6YzBXz2sGDcq2ObaOsZ4/Ho=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WB40RW+M; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WB40RW+M; arc=fail smtp.client-ip=52.101.84.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=eCYY3WA7fmbAQb02YG0YjUP9ss1MSFi0M78MP7eKxTSRXB0xxNn1ntVMQpEYPsH6FeQIx+BvD2numcQ1t7yXx/h1XSMURK3mF/UpbXcd7lZaVCbJUrDKsq6dnWu+gmbtPrRxJiSgbam7jrms2A5+1UJ3/5aypOkJrXroVwMLyGpqUZg5QABQMoJsLyuAshY+VqN5lMPOn4cBVWgsaQ7+fJKZyaqHYGnYKEep10PyJRA7mBBT4AP7rmDWwz2CNRM12iJWFKdbYLqpOEMP1DS9HYZWeK3+BlCOcFXGSsybrD4tZrlTfQHFEr/OXBUU4jbwZeGZXmrzucL/VKasmyJFww==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tUBtZYwjOw9j9g+BdR5YHY2kFIjYrjpxxQResGFK7HQ=;
 b=hj1bNzS1O8BOWLCx3oiASw2o4D5OL7RVbJ+HcOOFguv5woPxI7Q2tpP2hWV+W6NiQeU0Abf/jioE5cEn1m5lcQWjwi8DVQ3OxZCfCwjKc2lM1HG21aeZ8wOy9eu/4pob8N8ciKoybyOqacPwWkfDBfDOXak+Kla5RN9xZLJmI9hChZpc2LINGW8Z022QDYnQdrWVpQBrKG5UY0aBnGTM754TnbTjRqJLzozC48YwOjp38sJ170UmHAcgDYRh9xxRknIZzC1xjLWYyF0meYzmxQGccFqMvllNXP3SqvTbvjruXeeS//FdwulvVM2u9xD9SEPLwphEQbn/7JcWs68llQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUBtZYwjOw9j9g+BdR5YHY2kFIjYrjpxxQResGFK7HQ=;
 b=WB40RW+MQF0o616sgwp4ARsl3+C9L+z+O5yYf0p/uR3ZZ3MVD3JDaJo0MOGofmaYMdxX9lG5s8kDndjKcNu135rqolse8J2ymHksSgDRKFeW02yVEn8oM19w1QsyW78aGILgV09RIqKx6kw57cjDzBM4YESVUG4dsOlSe+EX9Ws=
Received: from AS4P250CA0022.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:5e3::12)
 by AS4PR08MB7710.eurprd08.prod.outlook.com (2603:10a6:20b:511::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Fri, 30 Jan
 2026 09:30:38 +0000
Received: from AM4PEPF00025F9A.EURPRD83.prod.outlook.com
 (2603:10a6:20b:5e3:cafe::a6) by AS4P250CA0022.outlook.office365.com
 (2603:10a6:20b:5e3::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.11 via Frontend Transport; Fri,
 30 Jan 2026 09:30:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F9A.mail.protection.outlook.com (10.167.16.9) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.0 via
 Frontend Transport; Fri, 30 Jan 2026 09:30:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sH4GTSznAQabF3xZJ1OiLI7GMiiW6e+D5mRradzMIi/ySXLMdaowPO2DLtZhE2QcwW8di/Qc669kfCrjL3x8nXwAtK+xqQldD+evZrc2i2m+2D3UAgz7wBKJ7nuB1Xx50JATU/ENiyVRsV5zhZgc/MZTHh9fcoc4DuaFBiWO7kw6Zz5CcstfLIy2FRrv18grOkQ90hZqV+gra2ajGnOKZNajEEjlAS1PV19WAQrqYcBGRL801GSf4zoQ2VXx5caen/sAt5dO3TgaRhK7ZsZO0gujfIlJRZDMVdpGtK8CG+tiRzYWSoRdCXdzbNKth6/uD0mVaflerMSCut7IoCKdVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tUBtZYwjOw9j9g+BdR5YHY2kFIjYrjpxxQResGFK7HQ=;
 b=yPyH8gIpi8zOrFHoFiTe8i/uP1xlpKaEOojXM8e2kIF8sq3xhFAL+p7Aw5AkXp5yMvA1db6gG7XY7neD69M0yuN1g7UBLYsH8adHpA4fr3CVkxUye2hGh5Dlto7s9IgY8hhpXEK2vUP3ws55KH/prOdgzBZaJ2+0ZT69wiIlig9SCBci/DPdSVqojSQ2m9L2JiGlELeo3dTpzmyBoXtfXDI5MJVVCVpGUNomOP42+k/ve/u9HxaHZXMCy0+f4Xu4YPAoFTtc8cnzh6+gmvb2m8mwCp7HlUSdE6t2A/Xmhg1lgs2ToZexHD0MHgkrf/byWT1RbbML7CV2ubU20B07AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUBtZYwjOw9j9g+BdR5YHY2kFIjYrjpxxQResGFK7HQ=;
 b=WB40RW+MQF0o616sgwp4ARsl3+C9L+z+O5yYf0p/uR3ZZ3MVD3JDaJo0MOGofmaYMdxX9lG5s8kDndjKcNu135rqolse8J2ymHksSgDRKFeW02yVEn8oM19w1QsyW78aGILgV09RIqKx6kw57cjDzBM4YESVUG4dsOlSe+EX9Ws=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by GV1PR08MB8692.eurprd08.prod.outlook.com (2603:10a6:150:86::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Fri, 30 Jan
 2026 09:29:34 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 09:29:34 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: Andre Przywara <Andre.Przywara@arm.com>, "will@kernel.org"
	<will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Alexandru Elisei <Alexandru.Elisei@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH kvmtool v5 5/7] arm64: Add FEAT_E2H0 support
Thread-Topic: [PATCH kvmtool v5 5/7] arm64: Add FEAT_E2H0 support
Thread-Index: AQHcjHSJ5t2e4cgXVkS2GpSLkXzksLVqfPmA
Date: Fri, 30 Jan 2026 09:29:34 +0000
Message-ID: <5962c90ec1707d207bec102c7d6c12dcfe2027a4.camel@arm.com>
References: <20260123142729.604737-1-andre.przywara@arm.com>
	 <20260123142729.604737-6-andre.przywara@arm.com>
In-Reply-To: <20260123142729.604737-6-andre.przywara@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|GV1PR08MB8692:EE_|AM4PEPF00025F9A:EE_|AS4PR08MB7710:EE_
X-MS-Office365-Filtering-Correlation-Id: f80dfbcd-d98b-4118-82ee-08de5fe23a5a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?eENxUmFaU2hGcGJSMU5GdGhLOFIxNDFVQWJHUmxHN2txSFgvRGtoZkJKWDFF?=
 =?utf-8?B?bFdKd29zN0FEcXd1RkVpTklTSFZ6SmpnaHBsSVVFT2ovL2JGR1ZDb3M3SnlB?=
 =?utf-8?B?V2hBWXZ4OVV1a2tvMFh0TkNDWkl2KzRxdmV3Zk1GSGpsd01ETTZpcE9CVEhR?=
 =?utf-8?B?UEpsZVFkd3dOMXpPckJENERtVkI1WHNFcWJxeTdzQTZ1RStwK08rZG1vb1I2?=
 =?utf-8?B?Y0p3akJ5bk9GRlYrV2kwa016NjlLNDJ4eHpnZ1haOGl5bFhFSUNaVWFWL0Fu?=
 =?utf-8?B?cTdZTkJobW1KTzNTZnM0aFJZYmVNRUNrczRRME1FWVEwQ2U1NXpuNmtvUzg1?=
 =?utf-8?B?WHJJU2tQWktmREg1aDlIc2xpUjMyWVNZVVF5emRqN1lnNDhMRTZLS2F5OVRu?=
 =?utf-8?B?UEt5OW1VMHhweHRLenRhTkpneDhsMncrTDQ3eU1uQ25xWkNKYjk1WEdvWmJ3?=
 =?utf-8?B?OU9uMTMxR0g3alFtVlY3MHlaMHdSZWRrczBMK1lqdXZWR1cwNnZGWnBGVVdV?=
 =?utf-8?B?V1ZJSXVwbm9iYjdWTkZQL2gvKzZMWGl2akZ4bElsSjJ5R0w4MkpyVW14alJP?=
 =?utf-8?B?ZVVLYmtZOXdobmtFWnlhbGEwRWdWWGRIOVRqNUlOaHQzbXZZb2kxQUxWd2xq?=
 =?utf-8?B?UGd0UGZJby9LSmwrL3d1UnFJRWlwMFdCMUFnQnh0bitxRnJCa1lLZnRzNk54?=
 =?utf-8?B?cWlvV3dsQmVranpzRjVuU2hMS1IxMnlHK3dxSGhlWjkyQmZ4aVlvbmxxMmky?=
 =?utf-8?B?bkpTUHVKcFRaYjVOenRjcHN4dFhPUVNyaER1eEptejdzTTdiLzU4eG5YSFVs?=
 =?utf-8?B?a1NwVHY2M1lseDh4bUUzMjFQSVlGcG9VeERhekptVC8xVmtueUZ5aExGTm1y?=
 =?utf-8?B?ODVFR0t4aTNNbWEyR3JjakpZY1NLL0hYU1hDYlFyVWpqUktuM2R4Ym5pWVdJ?=
 =?utf-8?B?M2h2WmN1OWY5Um01MVlldC9ySy8zdVovVElJNFZOMmd5Yk1iWUt1MEFrWmdP?=
 =?utf-8?B?cnVBK01XRkdBdDFHZHU1TG80SEdHN1hRbDZwV01OZFFHN3BkTSt4RVdzQ0Fo?=
 =?utf-8?B?ZU1oL09aOXJCekxjcnpHdVUrcjY3aE5DaytUR1U3QXg2ZkhXS3BWM1paSG8r?=
 =?utf-8?B?K0JwcGR5eTBzN01sMmM3NW9BN0dEQlgrcjhleHh1T3l4ekZNWVQ0RG9yZ3Rl?=
 =?utf-8?B?MXlKNGV1cGJFV25Vd1VZNTJHWUlBUzE2WFJjOHM1VklpTkJvTE4xVEVLMFdw?=
 =?utf-8?B?cE41UjdKK3BuU3NLRVM1N2c5T0NQT013eDRJeE5jRk5qK0Y4dTBKem9uOHl2?=
 =?utf-8?B?Z0tucXF6VjFBL20rYVJ1Z2p5ais5MnoxSG4rdFJhRVlielJaS2hFL2hlemFx?=
 =?utf-8?B?QjJ0UzRqTXNQQTRKQVF4eFpmMHJsNmZzc01KNS9xVnBXb3dPcmhZNFZRVHlV?=
 =?utf-8?B?VDhQQmRCOXQ3SUgvR2Zsb2lnZ3h0ell4VERpamE4eUdRdnFRYm5JaFVBWTA3?=
 =?utf-8?B?Mm9STEJ3SjBwTjV3OTBmVkJOZElNbTQ1VllmY3MrdXpwNnEydnpkcTJ2RUps?=
 =?utf-8?B?VkN0V0lLYjJVSnQ1czV6bFdNdkp1RTRjdlVWYi9sOWl2Mlp6SEF6aUN6QVFx?=
 =?utf-8?B?dURTUXVlaXNad0dpU2paNjBvaVUvNC9GcHdvYUphemFrY29RMzNtZm9CUmVj?=
 =?utf-8?B?aFVBZHJzSXZ2ZWl4SjNGalAxTVA0WXRta2UyTENJa21ld01yNE1FQ0psV1pY?=
 =?utf-8?B?WnVERkttUmZhMW9DTkdEQ0c2dVUvclh0QTJCK3RYUVZaTTAyMjNyMzJVblRu?=
 =?utf-8?B?dkR3b3RneGY4amZReUNvMi9zaWFudzVHRjZjN1hueGY3Tjd2VlNMc3AzWkZ2?=
 =?utf-8?B?THJsM0lCa0J0QmpVRjlvUFBqbTh1eFBrZEpQV0RiLzNHVW9tM2Z1ZDZFZDdE?=
 =?utf-8?B?d1ZoNDdPYlRpTTZWZnQ0b0NVQUV6cFhlaEhDOERWR2hacFZtTFZCU1JjdkNE?=
 =?utf-8?B?TEhCMmtsODduU09CeldPQVBjSkRBQVBHbTJ1ZjdUNmozVFJBZUNNVk5KRnR6?=
 =?utf-8?B?UUFPWmpaNHhSOHJOcE8vZFZ1OHdCb3VxcHZuYXY1dVlNVm9kY3N1bGNGRnhE?=
 =?utf-8?B?algySVRBK2lsaVRsZzhBcU92OXEvVndvVG15VUp6MFVmVVcyY3FnUEtEcGF4?=
 =?utf-8?Q?SCAz6ByIFjkdQLvFM8OHSyI=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <1BF06F7F073FCC4DA75ABCE4C3AEFA96@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8692
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F9A.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e863a473-a6de-42a5-9dd5-08de5fe21496
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|35042699022|82310400026|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUx5OWVNT3greHhQOHg5TDZ1M1pVcFIwaXhySGhFckNTbmxLU05YNVc0KzZY?=
 =?utf-8?B?VEp0a0Q0RXZJVHBrUUJNR0xiQzcvcnNWd1pGUWdXelhoZkpGQk5ZdkQ3TzZD?=
 =?utf-8?B?alRuL3JBLytFNStKU1cyMGZiRUJMd01vdFhBYURjdGE0U3hyeXhRcEVRanVr?=
 =?utf-8?B?bXBjRE93a2VLSndiY1R4OWc5YU1CaGllOHdDRVNad2FSZVd4RWxXNjFBUXly?=
 =?utf-8?B?WU5RT1c0Rnk0OHpXemVxWlQ4QURTdEJNMStHWUQ4SzVIS0lDTlpHaytEQ2lM?=
 =?utf-8?B?N2NiYnNYNml2cTFhbFZLVGpzVCtlRVVoT1VUT21ZL0xzMmVYd29ZRE00Q1dS?=
 =?utf-8?B?dkZycG5TcXNDYjlRNkt4YnZ0L2lkZ2pWamIrQU1QRFVvejdHWEJiSnJGK24r?=
 =?utf-8?B?VlhmTGI5UGVGNis0WnozbHJabDlKRWJRZUpjbGVlN2FGalUzZ2o5RnlML2ZO?=
 =?utf-8?B?Q0N6Q3ZnendwN3BkdUtXRzdSMGVybU13VnVaTTZtZTA0Y0pkUUh2UU0zZkJ2?=
 =?utf-8?B?NG5DZVdyN3JRalBWRGYvV3FMZGQxazI0SUdPTURnbk4xcnpyWnFWV01YRXo2?=
 =?utf-8?B?T1FNUjBFNDhTWk1xYzJLb2ZaN0FkaStsWW1pbHFSQjhLSTQzWm1OWDR4dXoz?=
 =?utf-8?B?dTRMSWhseCsyVDVmOThFKys5MTkrNXhuUGFlY2l1dTJsTmduSDZwZTJJdDF1?=
 =?utf-8?B?Q0l5YjBzWjU5VjZvTCtiS2Zjb29uRTBCamp1RXFFZ1ZOeXpydXgvYXZ1QzZm?=
 =?utf-8?B?VlgyQUhwTHV0RGo0b0lPTlBXYS9URnYvMmZLMUliNnpxZ2J4SzAyMjdmNkxO?=
 =?utf-8?B?MHhiRVJ1b0w1bWhGVTgzQ1RqOVVBdVNaaURGY3ZyRW9rWjBaMXRmRUxtRlhv?=
 =?utf-8?B?aDBUQmh6a2pJNytpaEJXMmFRSzdEVHpLZHVvRFJERlVxc291NGxqUER6cDhu?=
 =?utf-8?B?U2VEUCtHemdHL2paTUllNlFiblNvamRXV1NTN3J1dnpnWFd2b0dWaTAwWEg2?=
 =?utf-8?B?Q01ZZzYyNEpENVN3aHVVb285TnJyTXExLzJ6RGVHamxCNUtvaFdRdjFkSDFk?=
 =?utf-8?B?ZENVa2FJQkxmMit6SStwYjN3RXBmU0h6TFVMcEFWa1ZFYlgyV2lvYnBvTTc1?=
 =?utf-8?B?blA5UnV6ak9rU2NVOGgrN2QvVWFDM29leVF0VDR6RnV6Rlg2UlNqQkZDTG5z?=
 =?utf-8?B?ZGNjMFFxZ2c4MGRLVUhLMVRrV3BWSlp3bTNvU2tpVGErUEFtbFpMTWtnZW52?=
 =?utf-8?B?aGx6di96OXR2T0ZQbEI2NHo4U3lZMWxpQVJTc0ZCNDlSVVZUQ1IyVEkxUlNK?=
 =?utf-8?B?V3hSYlMzTXFBR2p1aS9QaWx2M1dtZy9OQWFsTnZ2WTNNc2dFd0trTk9DV3RN?=
 =?utf-8?B?cnhlOVhIeGV0ZjlEVFZNQXVlUHJHcnVRdDlzaGhnZTFDN0xTYzU3ajBaWSti?=
 =?utf-8?B?WGVMRnU4SGhaaFR2c1g3VDlRaDhjeHBTenpFNWkrWHBKMUoyYUYrallrZzRy?=
 =?utf-8?B?WlFDZXdmVnNDcE54S3NYV21FWnd3WndzeFFrMGR1bjd1blo2UVZ2WTdHc1RT?=
 =?utf-8?B?RDkzMTMxWnZVV0toREtHL0ZVZWtwWE9TU2pSbWdrV1BPQ3hNNGZRdll4bW5n?=
 =?utf-8?B?ZG84Vm5KblkwTUlqbFR4eVNxcVBRM2Q0bWJqRXhiWTNFT3hVMUlHb3ZpN0F0?=
 =?utf-8?B?T3pGM0xtbmJOcUFqWGNZeGJBZjRkemJSTTFTNk1MSmx5dDdEdzBVcDY4UjM5?=
 =?utf-8?B?NzhOZks1MHZVdjRwdUVuUnNJQU5IZXdldEtxdkUvNEpqWkxXbzA4TXNiN2pL?=
 =?utf-8?B?MW1mRWFtOEw3ek1Qb3JMdW0zYUVBK3NiY3k4UlBXaERwV1l5eGR4Wm80YUFY?=
 =?utf-8?B?L3o0Y2E5OHJkTzVmVlRQa2psQlVVQ1RzSzhMMjRDU2lWaHVrK2dRRjZrd1hM?=
 =?utf-8?B?N0w2TFZ1dmFXWVI4UlJHdmRMMWRVeEIvb2pkWFZPM1g2MWNJOTVRSHJ2UGRv?=
 =?utf-8?B?YUwvem05emkyT25PWkZER1RGZTdnZnltVmsyWW5CYW1id0J0dHFBZWgrTHBz?=
 =?utf-8?B?L1NrZFBFbDNxY01hTXEwSE0wVWtGa3lvSkQyc25PUkUvMXhvYm1EOHd0QkYy?=
 =?utf-8?B?UW9YTjd6RXZYNkdtOVpMa3R0Y2l4eGFYc0M0WXIvcnRMeW9iVkh4ZndCNkhY?=
 =?utf-8?B?dG9EQTNGZzlpaUMyOGFqS01iRnpabG9BUmJ1WUFNZ1RQWS9LMWthbDZqUUZt?=
 =?utf-8?B?ZnZnVTFKTlo4dE1ONnNuNlZyZkN3PT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(35042699022)(82310400026)(14060799003)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+gA+woGLcQBV54lG0LuuZY8pTDfZS1jBTwNXobY6DNxOD4VpQXogOsFZcWgk8Gl4BrjQDUR4mYtGrX1A9gzI+zORIqX9MJ/IJwcrH1DZ0SKZHuKkv4zcNzVOtZbLop9Rw3sNW4UTiCBQv1n9ekGTAzYawZELhgHmuEWa11J4SX7u/mYjUO9c0pn80Ur3k0ufOKGgEDzA/IA4jmtlsbEHqRhDlhOpRdhurVGbk/iy6Q45pu5BGtZkOSnx9OAmvEN+mHS8G3GUJAI60XvFat6sced90qSwK59i9SmTaiX6zjsdbBTvrAoTv/5wo6S7QBlrvZvCjCEBAKW0sNBZ6jsJjWVvT3X5e1B6AHkFZqeH9IQ6OfPSXbcCnmZ0mDsauYJ4DYbe5iAq44S2p9qGIrptDjZ94HqLYWc13oRHgvCycknxTZGRUkS8OmPevpP4OSaL
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 09:30:37.8493
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f80dfbcd-d98b-4118-82ee-08de5fe23a5a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F9A.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7710
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.44 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69691-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[arm.com,kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,arm.com:dkim,arm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 4142BB8F0D
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAxLTIzIGF0IDE0OjI3ICswMDAwLCBBbmRyZSBQcnp5d2FyYSB3cm90ZToN
Cj4gRnJvbTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4NCj4gDQo+IFRoZSAtLW5lc3Rl
ZCBvcHRpb24gYWxsb3dzIGEgZ3Vlc3QgdG8gYm9vdCBhdCBFTDIgd2l0aG91dCBGRUFUX0UySDAN
Cj4gKGkuZS4gbWFuZGF0aW5nIFZIRSBzdXBwb3J0KS4gV2hpbGUgdGhpcyBpcyBncmVhdCBmb3Ig
Im1vZGVybiINCj4gb3BlcmF0aW5nDQo+IHN5c3RlbXMgYW5kIGh5cGVydmlzb3JzLCBhIGZldyBs
ZWdhY3kgZ3Vlc3RzIGFyZSBzdHVjayBpbiBhIGRpc3RhbnQNCj4gcGFzdC4NCj4gDQo+IFRvIHN1
cHBvcnQgdGhvc2UsIGFkZCB0aGUgLS1lMmgwIGNvbW1hbmQgbGluZSBvcHRpb24sIHRoYXQgZXhw
b3Nlcw0KPiBGRUFUX0UySDAgdG8gdGhlIGd1ZXN0LCBhdCB0aGUgZXhwZW5zZSBvZiBhIG51bWJl
ciBvZiBvdGhlciBmZWF0dXJlcywNCj4gc3VjaA0KPiBhcyBGRUFUX05WMi4gVGhpcyBpcyBjb25k
aXRpb25lZCBvbiB0aGUgaG9zdCBpdHNlbGYgc3VwcG9ydGluZw0KPiBGRUFUX0UySDAuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPg0KPiBTaWduZWQt
b2ZmLWJ5OiBBbmRyZSBQcnp5d2FyYSA8YW5kcmUucHJ6eXdhcmFAYXJtLmNvbT4NCj4gUmV2aWV3
ZWQtYnk6IFNhc2NoYSBCaXNjaG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+IC0tLQ0K
PiDCoGFybTY0L2luY2x1ZGUva3ZtL2t2bS1jb25maWctYXJjaC5oIHwgNSArKysrLQ0KPiDCoGFy
bTY0L2t2bS1jcHUuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCA1
ICsrKysrDQo+IMKgYXJtNjQva3ZtLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgfCAyICsrDQo+IMKgMyBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJtNjQvaW5jbHVkZS9rdm0v
a3ZtLWNvbmZpZy1hcmNoLmgNCj4gYi9hcm02NC9pbmNsdWRlL2t2bS9rdm0tY29uZmlnLWFyY2gu
aA0KPiBpbmRleCA0NGM0MzM2Ny4uNzNiZjQyMTEgMTAwNjQ0DQo+IC0tLSBhL2FybTY0L2luY2x1
ZGUva3ZtL2t2bS1jb25maWctYXJjaC5oDQo+ICsrKyBiL2FybTY0L2luY2x1ZGUva3ZtL2t2bS1j
b25maWctYXJjaC5oDQo+IEBAIC0xMSw2ICsxMSw3IEBAIHN0cnVjdCBrdm1fY29uZmlnX2FyY2gg
ew0KPiDCoAlib29sCQloYXNfcG11djM7DQo+IMKgCWJvb2wJCW10ZV9kaXNhYmxlZDsNCj4gwqAJ
Ym9vbAkJbmVzdGVkX3ZpcnQ7DQo+ICsJYm9vbAkJZTJoMDsNCj4gwqAJdTY0CQlrYXNscl9zZWVk
Ow0KPiDCoAllbnVtIGlycWNoaXBfdHlwZSBpcnFjaGlwOw0KPiDCoAl1NjQJCWZ3X2FkZHI7DQo+
IEBAIC02Myw2ICs2NCw4IEBAIGludCBzdmVfdmxfcGFyc2VyKGNvbnN0IHN0cnVjdCBvcHRpb24g
Km9wdCwgY29uc3QNCj4gY2hhciAqYXJnLCBpbnQgdW5zZXQpOw0KPiDCoAlPUFRfVTY0KCdcMCcs
ICJjb3VudGVyLW9mZnNldCIsICYoY2ZnKS0NCj4gPmNvdW50ZXJfb2Zmc2V0LAkJCVwNCj4gwqAJ
CSJTcGVjaWZ5IHRoZSBjb3VudGVyIG9mZnNldCwgZGVmYXVsdGluZyB0bw0KPiAwIiksCQkJXA0K
PiDCoAlPUFRfQk9PTEVBTignXDAnLCAibmVzdGVkIiwgJihjZmcpLQ0KPiA+bmVzdGVkX3ZpcnQs
CQkJXA0KPiAtCQnCoMKgwqAgIlN0YXJ0IFZDUFVzIGluIEVMMiAoZm9yIG5lc3RlZCB2aXJ0KSIp
LA0KPiArCQnCoMKgwqAgIlN0YXJ0IFZDUFVzIGluIEVMMiAoZm9yIG5lc3RlZA0KPiB2aXJ0KSIp
LAkJCVwNCj4gKwlPUFRfQk9PTEVBTignXDAnLCAiZTJoMCIsICYoY2ZnKS0NCj4gPmUyaDAsCQkJ
CQlcDQo+ICsJCcKgwqDCoCAiQ3JlYXRlIGd1ZXN0IHdpdGhvdXQgVkhFIHN1cHBvcnQiKSwNCj4g
wqANCj4gwqAjZW5kaWYgLyogQVJNX0NPTU1PTl9fS1ZNX0NPTkZJR19BUkNIX0ggKi8NCj4gZGlm
ZiAtLWdpdCBhL2FybTY0L2t2bS1jcHUuYyBiL2FybTY0L2t2bS1jcHUuYw0KPiBpbmRleCA0MmRj
MTFkYS4uNWU0ZjNhN2QgMTAwNjQ0DQo+IC0tLSBhL2FybTY0L2t2bS1jcHUuYw0KPiArKysgYi9h
cm02NC9rdm0tY3B1LmMNCj4gQEAgLTc2LDYgKzc2LDExIEBAIHN0YXRpYyB2b2lkIGt2bV9jcHVf
X3NlbGVjdF9mZWF0dXJlcyhzdHJ1Y3Qga3ZtDQo+ICprdm0sIHN0cnVjdCBrdm1fdmNwdV9pbml0
ICppbml0DQo+IMKgCQlpZiAoIWt2bV9fc3VwcG9ydHNfZXh0ZW5zaW9uKGt2bSwgS1ZNX0NBUF9B
Uk1fRUwyKSkNCj4gwqAJCQlkaWUoIkVMMiAobmVzdGVkIHZpcnQpIGlzIG5vdCBzdXBwb3J0ZWQi
KTsNCj4gwqAJCWluaXQtPmZlYXR1cmVzWzBdIHw9IDFVTCA8PCBLVk1fQVJNX1ZDUFVfSEFTX0VM
MjsNCj4gKwkJaWYgKGt2bS0+Y2ZnLmFyY2guZTJoMCkgew0KPiArCQkJaWYgKCFrdm1fX3N1cHBv
cnRzX2V4dGVuc2lvbihrdm0sDQo+IEtWTV9DQVBfQVJNX0VMMl9FMkgwKSkNCj4gKwkJCQlkaWUo
IkZFQVRfRTJIMCBpcyBub3Qgc3VwcG9ydGVkIik7DQo+ICsJCQlpbml0LT5mZWF0dXJlc1swXSB8
PSAxVUwgPDwNCj4gS1ZNX0FSTV9WQ1BVX0hBU19FTDJfRTJIMDsNCj4gKwkJfQ0KPiDCoAl9DQo+
IMKgfQ0KPiDCoA0KPiBkaWZmIC0tZ2l0IGEvYXJtNjQva3ZtLmMgYi9hcm02NC9rdm0uYw0KPiBp
bmRleCA2ZTk3MWRkNy4uZWQwZjEyNjQgMTAwNjQ0DQo+IC0tLSBhL2FybTY0L2t2bS5jDQo+ICsr
KyBiL2FybTY0L2t2bS5jDQo+IEBAIC00NDAsNiArNDQwLDggQEAgdm9pZCBrdm1fX2FyY2hfdmFs
aWRhdGVfY2ZnKHN0cnVjdCBrdm0gKmt2bSkNCj4gwqAJwqDCoMKgIGt2bS0+Y2ZnLnJhbV9hZGRy
ICsga3ZtLT5jZmcucmFtX3NpemUgPiBTWl80Rykgew0KPiDCoAkJZGllKCJSQU0gZXh0ZW5kcyBh
Ym92ZSA0R0IiKTsNCj4gwqAJfQ0KDQpBcyBwYXJ0IG9mIHRoZSBvdGhlciBkaXNjdXNzaW9uIEkg
c3BvdHRlZCB0aGUgbGFjayBvZiBuZXdsaW5lIGhlcmUuDQpQbGVhc2UgYWRkIGEgbmV3bGluZSBo
ZXJlIHRvIG1ha2UgaXQgY29uc2lzdGVudCB3aXRoIHRoZSByZXN0IG9mIHRoZQ0KZnVuY3Rpb24g
YW5kIGltcHJvdmUgcmVhZGFiaWxpdHkuDQoNClRoYW5rcyENClNhc2NoYQ0KDQo+ICsJaWYgKGt2
bS0+Y2ZnLmFyY2guZTJoMCAmJiAha3ZtLT5jZmcuYXJjaC5uZXN0ZWRfdmlydCkNCj4gKwkJcHJf
d2FybmluZygiLS1lMmgwIHJlcXVpcmVzIC0tbmVzdGVkLCBpZ25vcmluZyIpOw0KPiDCoH0NCj4g
wqANCj4gwqB1NjQga3ZtX19hcmNoX2RlZmF1bHRfcmFtX2FkZHJlc3Modm9pZCkNCg0K

