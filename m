Return-Path: <kvm+bounces-28715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 232DA99C380
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 10:36:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C6C81C22509
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 08:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2905914D70B;
	Mon, 14 Oct 2024 08:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lHrkeewI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93921474A5
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 08:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728895002; cv=fail; b=rMum3P1i+OB90nFnXAQ9xjOce+K+klEXiA1/jNmy8+3WFlY4+IUH9uzGY5r9e6O6tUyq/HTPUMQMhJ+1v163dq/gDl/2NqTOEWt3zv3J+MdbbzpRrPn1soYdj6B+oc6Dfywi6ma0LKSIEQ0YaU0q/5F361EzceoYarG/doj6tF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728895002; c=relaxed/simple;
	bh=7CtW96DpnFfYSAEn2AbObV32uuhalxJmbhD1nJxNhRI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DWPErtUrTxCsajCmhHnURj07Q3rc4INg6l6eMB9mx1IkFR82ghR2I2FUqv5qmc6DI5CVnlsA/jv62N5hlYTGlesH5+1sgOELq9BCnTfP7em0Vx15WY19U4SuFitdiZol2fvaBnRJq63ksopDhpInMWrXsP+Lki5rhRWIMUwQGkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lHrkeewI; arc=fail smtp.client-ip=40.107.244.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P2CA9HZHoxhpn0DA/YzUhb1UHg1EwMxcveVRp6NPbhlsqVaLhpGQK3pJkttQcmSQeBjXCkOwovQUpGKWf3l9IfcXT4sM4iofJHI9qa52KLOTAOpe6Vu7pmWwGzj8ck2JZRPC6yI1inyJXmIrlRblJCOA7uH+wnWlB+DBpRyI8AwrQGVkGzlACNuusF5aD0dGeEljYluX3sHMReQhp6wjYIkR+0FigQH2CXcDKylTj/Q0HYv5j+9Rssqzqe7upWGy9H7/8znFrY+tdoLqxvBA64j5YhEGpM6x0xTQF67BMN4+F2F3+yZaiwrP2UWc57ZV6/fJY+ukFioF17+MjqpTEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7CtW96DpnFfYSAEn2AbObV32uuhalxJmbhD1nJxNhRI=;
 b=WY18dEN5TTJh7t/N0whEJPBiwcTdazefVgCsqBzdTEhx+R4v4rcXeIB0YY+Fxf5X7JIaDCfxAoumcGZODKOMHI+KwJ3BNT3ABzixzAjMfDk40SK6SLUnZtFFxS9e09GfLVhkP4zYdLwAgosZokPFYJC3rRUC5NtJIDSvErVC254LoWZOc0JTQnYx0YFlMTd6ghwn0h2FblfgmwYVQJezcyRvFkov+qnqYFMVQr1vof7n9bx1UfoAcWURzhLqnKQaSbmV0WlY0v3ATYFFqfKIfJ6GnHQv1LBeKpZBm+ZKBr4bz5xAlJhIste5ifLuqZG1RPM+tGvaCxcnAvoSk9oAfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7CtW96DpnFfYSAEn2AbObV32uuhalxJmbhD1nJxNhRI=;
 b=lHrkeewIP6YqX80g/R3tkWtBK6t3PFdyR2SeXMEuqyUtYBNh70Lqt1V3dziil8XMZ1a0iPWsUilPPnIrB7cLWIIWy9KoeQuQrR3nQN4zuqaXXkLEIwv0k5v2Pz5A+nSl3Zdteh/r7O2xn7FPslxLofEzLNZQBNczhuf4s4TjKAQ4+SDn0QTtuBVnbkde0raHv4m/kUURqVtibTnLqOmBgvZrEufGan7ME7pHjILjoi2Io8uO+2MGIM2oOQwYobAQXkzDL+6uBShmMNS8DK8B1+1BLiCC24OTEM2i8TzXDcnmbD1e2QJQNEM8307LHpXhY3JMR1meYgyliiHMfi1R8A==
Received: from SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22)
 by SA1PR12MB9470.namprd12.prod.outlook.com (2603:10b6:806:459::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.25; Mon, 14 Oct
 2024 08:36:38 +0000
Received: from SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a]) by SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a%4]) with mapi id 15.20.8048.017; Mon, 14 Oct 2024
 08:36:38 +0000
From: Zhi Wang <zhiw@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "airlied@gmail.com"
	<airlied@gmail.com>, "daniel@ffwll.ch" <daniel@ffwll.ch>, Andy Currid
	<ACurrid@nvidia.com>, Neo Jia <cjia@nvidia.com>, Surath Mitra
	<smitra@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, "zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 18/29] nvkm/vgpu: introduce pci_driver.sriov_configure() in
 nvkm
Thread-Topic: [RFC 18/29] nvkm/vgpu: introduce pci_driver.sriov_configure() in
 nvkm
Thread-Index: AQHbDO4P31Y+kUihTU61ZqQfAXOF0bJqtLIAgBtZ0AA=
Date: Mon, 14 Oct 2024 08:36:38 +0000
Message-ID: <86ea6768-cb94-45eb-ae57-e6757fad97fa@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-19-zhiw@nvidia.com>
 <20240926225610.GW9417@nvidia.com>
In-Reply-To: <20240926225610.GW9417@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6870:EE_|SA1PR12MB9470:EE_
x-ms-office365-filtering-correlation-id: 70329fed-54e6-41a2-0b56-08dcec2b51e7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?U21VV0pCMmM1eUFwSEdJeVZzb0tXZnNGaHVQR09wakp4cTV5QitYMzRJVVpI?=
 =?utf-8?B?cFlyV3dMdk81UUtjMWI1SW45TlVMVThrdVc3akdRNGFvVHNYQnh1TXdXbmlU?=
 =?utf-8?B?OEd3OWtBUGNiMjhSUmdhR0Z6QVBIYlMvWU5Dc2w3MGRZMjN1K2dhcE10NE1a?=
 =?utf-8?B?SVBuT29XNml0aGUxYi8rMG9La0QxYVo3aFRRWDRHOCtZWXArazNFZEtsZXNk?=
 =?utf-8?B?N0tQSFVuSlRyakIwNWFNY2VXVytmOE51cnhqNVQybG9DaGpkYjZTY0RrTnk2?=
 =?utf-8?B?bTljTGxOaW15OElYa1l2eVpmMXFTZjJVZDBrYnBlb1ZLV3V0WE5HY0o0UHdr?=
 =?utf-8?B?MFhhQVNTV0h3TGJlVmc0ZWdJZTJxQ1UyQmV1RmJwSHBNZnlhM0MraVRzblo5?=
 =?utf-8?B?c2N3RUhjWVZkclU3Y3RSQWJzTStIc3ZwN09iMHFSTXAvUVovTlVnVDlCOTZY?=
 =?utf-8?B?ejBNKzhlSURzQ1ZRdG1SMVJMdmVZY0FJUXRkN28zd3pOdUo4b3MwUEw3ekZs?=
 =?utf-8?B?cER5b1Yxa0hvbFV2NXo3UlBOYVRVblVNRkFxSWFoK2xyMnNMMDVqOXlYZDQz?=
 =?utf-8?B?a2lxYUxnUTNtcC9XWHZUR3NqMGk3VjliR1NNd09vOEw3WXNsVEVlNnE5VnY0?=
 =?utf-8?B?OWJ0TndYMGZLZDlaWmRnUjJ3OFRhbTF4RXd6TXVnc2krekJPVkJrNTIveVNG?=
 =?utf-8?B?Z3o1d3ZHbVZmeU9SNk9QTndCUTIrZThENmEyeDVhTFpjQnV5NG9HMmJxekM3?=
 =?utf-8?B?U08vRjJ0YzdqZGlsUG1TbWdPV1hIMzIwYnM3ZDZEMFppaGowQ2JaQlQveGRH?=
 =?utf-8?B?QTlKRFV0RjBmcFc4RllKY21oVnF6ZFRwN1BKZ0duZUxWZ3Z3QjlxdkdZZU4y?=
 =?utf-8?B?cXNWdlNvemNlWjRDRkliL2ZqZzFXZmhXd2RXd3JGTXcyRU5tTURUNEQ1RWM5?=
 =?utf-8?B?eGtPWGppWDJscHdyQXFTOUR0RGxGMXFlNHFHSmd5OTlvVjZGK0dWT01PZTNP?=
 =?utf-8?B?bWlWMzduQjA0aFFYcmdpWFBySVZuMWQ3UlFZK01Cd1ZHdzVCaENhY3hlQVMx?=
 =?utf-8?B?Wm5zWm9OejE0Q2tTUmoweTZWdFhCcm8vNXlLUUNLYU5BUm9GMzJhdFROa1RN?=
 =?utf-8?B?dktjV1RDOHE0R3JHYzVVazFxV3FNNzVaT25Qd25lWjRIZm1Za05ocGxFbjlr?=
 =?utf-8?B?NDU3cEpCZDN0NE5ucnlkTjdWWkJ2b3pzU0tVL0tLY1ZaakthS0lHbnNwQnFx?=
 =?utf-8?B?ak9sL1Zhby9vNUcxQWs0YnF5R3VhRXJDaUFIQ2F4ZlpBQldYY3hmbEttOTRz?=
 =?utf-8?B?UVdxVUZyZFVFcC9tMlE0S21wckhXc3lPbmkrQXVVeVUrQkNXaW1JbVF6dVZZ?=
 =?utf-8?B?NW1BWXl0VGNObmI4QjdZZXVlUTgzS1BjTzF6eHRLeTU3cVRFSEp5b2txaUxZ?=
 =?utf-8?B?blNtN203N1NDbTI0dW84T0tLRitLby9rVWM2R2h4am5TUzRTd1B1Mk80Um5w?=
 =?utf-8?B?ZlIvM20rUDZrekZCcm9uYzBXaHVaRXMzd2VUZjVCdmZLWVNQMEloUTFjcTFS?=
 =?utf-8?B?enR5cUVHT21TWGpLVjJlRno3eE5naS9EUDd1OFI3cnE0clMyQWN0ZTlsWnZJ?=
 =?utf-8?B?cmxlVExBcG43K3JvVElyVXJiQ3dmeENvTHNmK0d3ZWUveXdwMHBtTVpvRms1?=
 =?utf-8?B?KzUxckJXWksybXlhV1BiWTNFdjVHS3QwdWpJd0EzVFhIbnE0ZE5ra0hQYWRa?=
 =?utf-8?B?dXJLeFE1c2o4NjdBVU9CUnljRG4zR2RSS3pkdUZOZkUxUFFuVlFZRUNFSXdU?=
 =?utf-8?B?WFdDVHlGOVQrN1RDQTNRUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6870.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QzZNY1ZWenRBamRuc2VHZEFsMGU1L1ZGV1AyZ3hUN0lHM1Y2ZlJsTmZVRWFZ?=
 =?utf-8?B?QzNzN3BKUTVtM0xVNFVHcTB0STQ2RGNRWVg2L1pIb05ES0NCQ3NadFBiajYw?=
 =?utf-8?B?VUJVNzI4UkhlT1hRUDlZaUc0dHlyMmg0aGJRTU1QdEIvdWpXK28yRzBrZDhk?=
 =?utf-8?B?NXN2WFdWQ1Y4RDBheWNnM0tTd3FJTlVzNDRHa0JXeCsrcHpQL0haZnhJUzlE?=
 =?utf-8?B?VFFSSEVncmpyTkJFb2FDSDRBNFVJQnhwVjY1cUJibHhWODYwaExJMXBBVjBN?=
 =?utf-8?B?aS9LYW9kdnFUU1lHRFEzeUVHV2tLTkxEcExDRDVDSDVPWFNjUEpzbGFkTnFN?=
 =?utf-8?B?RWJtcGRNMmxsKytqWlBqaWNiNE5xeDA2SGJveUNRSFQweTR3cUdQMnVoVU5P?=
 =?utf-8?B?TzFRYlNBcHcxSUNPa2FuajZIN3FVU28zRndVY2VNWjcxMGZ0QVRTODBreTRN?=
 =?utf-8?B?d3hHUk1KWFgwdXM5NXlBeUZuckNNbzhoU2NpcmpXZldMZmRUZ2lwRU9mTVlC?=
 =?utf-8?B?VXVoM09haGRVOUdCcHlIWEp0Zkd6V0drRS91OUs3anYvZnI2b0RpWWZ4cG9Z?=
 =?utf-8?B?djdqb3V0ejlLSTJ3WFl3M2syQkZPZVhYeE81NnpqSDFmY2RkdC9oUzVLb3Ju?=
 =?utf-8?B?ZmhJSGJacU1BQ3lWTm0xaGZXanNNRHlqV2Z3OEFyZ2liWW1Zd2xOZHZIL2RR?=
 =?utf-8?B?MUZUOW5zQTcxUmp4REtzSVIyVXBLVWI1RVpQZjRFRnU2QzZqYmtwdzdMekc1?=
 =?utf-8?B?RmE5bHpzYUhObG52Uy80bWx3eFpWUi9CbU0wTGRFdXRRbjFnNThuVjRpRFdq?=
 =?utf-8?B?Z1hOeTMvUUlwaTl5UU1RVFNRdmFNdDdvWHI0OW1HV2doZ0Y4UHFJSFNPd3M5?=
 =?utf-8?B?aFJzL2hHSjFOMXBSbWlkc0VseDNSZW96YWNWdkdMNkZqalNKL0lpRU9ocFUw?=
 =?utf-8?B?dFNqdVdEUk5VRU1CVWhPZ1N0Uk1Xa2VBMW5BVGJjOWlTWmFsdWFZNlZjTTRS?=
 =?utf-8?B?RXVydFhUZmppVDg3TVdHSFhlaVh5TEczajBkM3pENVQ5aFp1WXREZzk3SlN5?=
 =?utf-8?B?ZHE0NWFnd3RiRGpUc2hNTC9ETTcrTmJoVzJFYm1tUEFwN1laQy9uQUNjb1Z6?=
 =?utf-8?B?MXpzVWpjODZHM3lkdTluS3dSbHN5OWRqNjE1Zk9WdFhac3ZZVVExeklOOHZJ?=
 =?utf-8?B?SUdwR2paaUlsNkYvYjBONnFPVnFzb3ZwbnJWUlkrY2JpWWxlcmd3U0R4aEw1?=
 =?utf-8?B?TlViOEFtOFUzOFZDTGZEcFNDVnEvNUFxek1OUmRKVE5PODJ0MDdZLzRPTW9X?=
 =?utf-8?B?dXh5SldsNktCNTF1OExCQis2QjYrbnpic25ieENwaXNRUHFhUEc1WkVqcWtE?=
 =?utf-8?B?Yzdhc05LODFkNE9yT3dJN0Q0Z0hDQW1USXVQYnFBWGtmS3BiZmxJTXZrblA0?=
 =?utf-8?B?VzlURkpjVG5FNFNKNmsweEFqTkh4QU9DRDY5eTNmZ1JPVml2VTU2UEt5Smpx?=
 =?utf-8?B?WnI4aEVlR3cxUmlMaGQ4T3NmeWsxQ3UrdWZkczNPenFkTUhwdFZyVmhzQmsw?=
 =?utf-8?B?RDdiVmFXb05wSGFWWTRHaHdvZG5iYlBqNWt5dy9lZHdTUEIvMnBnclM0RVlm?=
 =?utf-8?B?MEtEOXI5U0lqUitOc0N5WHVDcEhORDlMMDBadjE1R2xGdURYWlkxeUxCQ2pr?=
 =?utf-8?B?ZlltdGFHUVVwd0d1U1VkV3ZVR0p4SkxjL3BsemlkZmYzai9QU1E5TVR1YUg4?=
 =?utf-8?B?U2kyTCsyL2h1ZGo4blExaXBDTmU5SG9YTjdTc2VFYjBteHA4VE9vWEsvWXZ2?=
 =?utf-8?B?dVlFUEFUa2s0Z1daT1gwbzhOeG4yOC90ZTg2eE5KQXRnOS9vZW5icE0wbHRO?=
 =?utf-8?B?bEVUVzZKbGpzVExpN003UWVlZXFLV0NCbU41WE9UQ09FMXRRMWIxNVRxWWpI?=
 =?utf-8?B?KzNJSXBaaW5lRk5kMUxjcXdPbHF2dDJWdmtCYnJ5V05qVTYwbjZzNnFvV0xu?=
 =?utf-8?B?ZS9VZUtoRXZXSGJqVG5NRmpjNjI0b1FSY3lRNENESEU5M3NmamErT0x1L0dm?=
 =?utf-8?B?RUVvblBCeE5IaTI3bnhjazlMaXQvQTluWERrVURVSWt6N3E3SHIveUFXMGxy?=
 =?utf-8?Q?8CF0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8D410AEEE4E4143AFDE9EB7F178F079@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6870.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70329fed-54e6-41a2-0b56-08dcec2b51e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2024 08:36:38.1255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PEqvp5nQzS/khhhJ10st8U2IjOB3mLpNDuKWW3NpD4wk0QfY0+O+H/dDTCoOVN59
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9470

T24gMjcvMDkvMjAyNCAxLjU2LCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6DQoNClJlLXNlbmQgdGhp
cyBlbWFpbCBhcyB0aGVyZSBhcmUgd2VpcmQgc3BhY2UgaW4gdGhlIHByZXZpb3VzIGVtYWlsIHdo
aWNoLg0KDQo+IE9uIFN1biwgU2VwIDIyLCAyMDI0IGF0IDA1OjQ5OjQwQU0gLTA3MDAsIFpoaSBX
YW5nIHdyb3RlOg0KPiANCj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2RybS9udmttX3ZncHVfbWdy
X3ZmaW8uaCBiL2luY2x1ZGUvZHJtL252a21fdmdwdV9tZ3JfdmZpby5oDQo+PiBpbmRleCBkOWVk
MmNkMjAyZmYuLjVjMmM2NTBjMmRmOSAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvZHJtL252a21f
dmdwdV9tZ3JfdmZpby5oDQo+PiArKysgYi9pbmNsdWRlL2RybS9udmttX3ZncHVfbWdyX3ZmaW8u
aA0KPj4gQEAgLTYsOCArNiwxMyBAQA0KPj4gICAjaWZuZGVmIF9fTlZLTV9WR1BVX01HUl9WRklP
X0hfXw0KPj4gICAjZGVmaW5lIF9fTlZLTV9WR1BVX01HUl9WRklPX0hfXw0KPj4gICANCj4+ICtl
bnVtIHsNCj4+ICsJTlZJRElBX1ZHUFVfRVZFTlRfUENJX1NSSU9WX0NPTkZJR1VSRSA9IDAsDQo+
PiArfTsNCj4+ICsNCj4+ICAgc3RydWN0IG52aWRpYV92Z3B1X3ZmaW9faGFuZGxlX2RhdGEgew0K
Pj4gICAJdm9pZCAqcHJpdjsNCj4+ICsJc3RydWN0IG5vdGlmaWVyX2Jsb2NrIG5vdGlmaWVyOw0K
Pj4gICB9Ow0KPiANCj4gTm90aGluZyByZWZlcmVuY2VzIHRoaXM/IFdoeSB3b3VsZCB5b3UgbmVl
ZCBpdD8NCj4gDQo+IEl0IGxvb2tzIGFwcHJveCBjb3JyZWN0IHRvIG1lIHRvIGp1c3QgZGlyZWN0
bHkgcHV0IHlvdXIgZnVuY3Rpb24gaW4NCj4gdGhlIHNyaW92X2NvbmZpZ3VyZSBjYWxsYmFjay4N
Cj4gDQoNCk9vcHMsIHRoZXNlIGFyZSB0aGUgbGVmdG92ZXJzIG9mIHRoZSBkaXNjYXJkIGNoYW5n
ZXMuIFdpbGwgcmVtb3ZlIHRoZW0gDQphY2NvcmRpbmdseSBpbiB0aGUgbmV4dCBpdGVyYXRpb24u
IFRoYW5rcyBzbyBtdWNoIGZvciBjYXRjaGluZyB0aGlzLg0KDQo+IFRoaXMgaXMgdGhlIGNhbGxi
YWNrIHRoYXQgaW5kaWNhdGVzIHRoZSBhZG1pbiBoYXMgZGVjaWRlZCB0byB0dXJuIG9uDQo+IHRo
ZSBTUklPViBmZWF0dXJlLg0KPiANCg0KQXMgdGhpcyBpcyByZWxhdGVkIHRvIHVzZXIgc3BhY2Ug
aW50ZXJmYWNlLCBJIGFtIGxlYW5pbmcgdG93YXJkcyBwdXR0aW5nDQpzb21lIHJlc3RyaWN0aW9u
L2NoZWNrcyBmb3IgdGhlIHByZS1jb25kaXRpb24gaW4gdGhlDQpkcml2ZXIuc3Jpb3ZfY29uZmln
dXJlKCksIHNvIGFkbWluIHdvdWxkIGtub3cgdGhlcmUgaXMgc29tZXRoaW5nIHdyb25nDQppbiBo
aXMgY29uZmlndXJhdGlvbiBhcyBlYXJseSBhcyBwb3NzaWJsZSwgaW5zdGVhZCBvZiBoZSBmYWls
ZWQgdG8NCmNyZWF0aW5nIHZHUFVzIGFnYWluIGFuZCBhZ2FpbiwgdGhlbiBoZSBmb3VuZCBoZSBm
b3Jnb3QgdG8gZW5hYmxlIHRoZQ0KdkdQVSBzdXBwb3J0Lg0KDQpUaGFua3MsDQpaaGkuDQoNCj4g
SmFzb24NCg0K

