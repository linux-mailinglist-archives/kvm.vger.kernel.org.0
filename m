Return-Path: <kvm+bounces-57980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96AF3B8310F
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 07:59:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C49A1771AC
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 05:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54B6F2D73BA;
	Thu, 18 Sep 2025 05:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=eviden.com header.i=@eviden.com header.b="dCxJnxh0";
	dkim=pass (2048-bit key) header.d=Eviden.com header.i=@Eviden.com header.b="V0Qf9V4i"
X-Original-To: kvm@vger.kernel.org
Received: from smarthost2.eviden.com (smarthost2.eviden.com [80.78.11.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1533B2D6E7C
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 05:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=80.78.11.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758175145; cv=fail; b=U/nYhjHbP3zsJ8DgTHZvFKvCvvJN5SDsRwAomD76y52viFJSJtEC6RzeVUrj4NQkOr7FwNx7cRDzo6I/hz31Oxzj7r6o0Xbaks9hVDUh6TqLVRF/trBMGmT61EZZiPJy4GMw5ebyw0QGHlVt+22bZTgnPx5bmoutp+LJEjL4ipM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758175145; c=relaxed/simple;
	bh=0bsvlu4rRph+NljdxmmnxYKWEBr0NN27WstqX+EaTbQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kY5XViqEbyvIJ5CVfgkjs+0jaWK81aWSn1EFeUQuFSLbGyQGU7QSqCnGbwP8ZrO58Yu/CK7AfjYjpop+9WEXcy3v8J0JrsYS4GBIFzx6sdIzL9MRfVJ8wk0PjUanB8gEQdsTQX/yKxQfMifpLHG7YSZep6UlwLlRbwJclfKtY9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=eviden.com; spf=pass smtp.mailfrom=eviden.com; dkim=pass (2048-bit key) header.d=eviden.com header.i=@eviden.com header.b=dCxJnxh0; dkim=pass (2048-bit key) header.d=Eviden.com header.i=@Eviden.com header.b=V0Qf9V4i; arc=fail smtp.client-ip=80.78.11.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=eviden.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eviden.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=eviden.com; i=@eviden.com; q=dns/txt; s=mail;
  t=1758175141; x=1789711141;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0bsvlu4rRph+NljdxmmnxYKWEBr0NN27WstqX+EaTbQ=;
  b=dCxJnxh0MZ9CzoyQGZMg5IQJgGFNuAphhtt6j4I3RHDy2fV+2pbwbZ6f
   uuA3Z/ZzF+bOwQdzvuku2p4zDHLxJ51cp5RyaeBfVE7YBaVxLW0p7Id4p
   vEN2EVPzj/6tNheBsp77siqp+lMkjYJ1lj83JuHS3OoGpDaCsaIHz4va+
   yVo0AUawbm8Ui6ssKlqSvi24EEkhkFzBq+0QpJBDDdaHSaHZlKHDxLx7o
   onAPtoRwvz9JgFUxkm0m6Ci6SAxX6cBtVrywTgrLsxbYbBK4DxOySpSEz
   Ss+XqOefGR9i/o7sutzxy+nTddVTTZ1wb5sKPwQCsFDmWjJpETBJjvDvh
   A==;
X-CSE-ConnectionGUID: PO+oL9DFSOGD+rSR0NEgDg==
X-CSE-MsgGUID: 6+ztTaTwTLCIrDD/unNxkA==
X-IronPort-AV: E=Sophos;i="6.18,274,1751234400"; 
   d="scan'208";a="43120147"
X-MGA-submission: =?us-ascii?q?MDF9jU75otgZ8WQ5WFIeKuhDT08LWkGrBWfSKt?=
 =?us-ascii?q?o0aDdrVzY4pCQLFG0yjAxvbqpz2dK/RKsjzzuA+EdEAmVrNsqArnDgs0?=
 =?us-ascii?q?aWq7n/hx+aQA7cQOC9+s2iDq0ADN/k3oGpKoplXGVXxmEhWC44s7x2+K?=
 =?us-ascii?q?Bj16CXCjFa0diPU31no1LA0A=3D=3D?=
Received: from mail-francecentralazon11013066.outbound.protection.outlook.com (HELO PA4PR04CU001.outbound.protection.outlook.com) ([40.107.162.66])
  by smarthost2.eviden.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 18 Sep 2025 07:53:48 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hdBEpyl1ofVCGe2UvSro5k3f8RPdLhMKmfOZOn5dTkdp6/+C7skEHfbb8xUZIrNuaie4xVeEa7UAa50Z9kFFfhsteSc1VHjj1EDKxw8jc02cJ7xlvDwPlrioaHkmVtlKPRy7OZxzPzdR8HT7IwAp/1nsACNW9hN3JrArbUCwbtXjLC6DLwBaeoHzaKnqxVbIPdkVSPJo70mbbTSu+sVo8zkN9nLidz4ro3IHzql0eIxuqV+Kk5Q4VX2nosYhUz3UViq3KZSKhNbntApY7a5fcGgPy2lkBtPAveUILzNsSAg/M7TxlMi3H55GGmxl6J2VhPyaw+ZGaKLmEisKZfhryg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0bsvlu4rRph+NljdxmmnxYKWEBr0NN27WstqX+EaTbQ=;
 b=K6piH53DCM9FOdb9PKisbW04w32lKTssPCVyKTGT+0S2eHO5BJ9SJLS709T8KCiTASX2WWWQWJvk3g4c5xKoywXyNzEQsJTaIzA+G4qqxa9PkzqZTDBfeQNBQyPZ6yXn3MCZAiBs6VF+Y+i7UfEpT8DfJ73/BYUQdIJvKhRmeaZn790gXtsRVPbO8UTWhUDeR3hhVYPJfMOtah0smq9ujHhkV8OQSjBuO++fo4j6Q9/sW1MeQQr3EDjYezVNhfmaY29tTxZeLW459ypYc6bwTjNvIwn5oIpg5AlKoYluwK/VQyyTTXIWkR8yCLpQzzXI3o3r6snyPr5yNPRzd9cssQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eviden.com; dmarc=pass action=none header.from=eviden.com;
 dkim=pass header.d=eviden.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eviden.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bsvlu4rRph+NljdxmmnxYKWEBr0NN27WstqX+EaTbQ=;
 b=V0Qf9V4i5CDCiAic22A8tzrOnqO85faARpDEoHlD62ZMBqwIdPKdbQXNVnAouyLvdBZ2HPoCrZtpYJoLS0QkexXcTo6xTLNKgosjBjIvyf+TSHIr8QieErCdv06P941ujFg83ujiyPtlBzDz++OFtfNG3jHlEGsRoyYsUuyrlobuP4Iwmm6BrpW93rMLZcA6QnZvZWGm42HSKb+nVfjtXE4+20Sq06Heuv585SG32x6EI/TFcRGfScjpigXUt6XmX3nzdzEgHfxGHCyja1hYMzxshLWyJt0roJmK/uzZlVG3zBIfCIyAqF57tmWOPmiN5g9bQWPn8XyimADTvr5z3Q==
Received: from AM8PR07MB7602.eurprd07.prod.outlook.com (2603:10a6:20b:24b::7)
 by AS5PR07MB9914.eurprd07.prod.outlook.com (2603:10a6:20b:67f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 05:53:45 +0000
Received: from AM8PR07MB7602.eurprd07.prod.outlook.com
 ([fe80::4b08:9add:5e19:eaaf]) by AM8PR07MB7602.eurprd07.prod.outlook.com
 ([fe80::4b08:9add:5e19:eaaf%5]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 05:53:45 +0000
From: CLEMENT MATHIEU--DRIF <clement.mathieu--drif@eviden.com>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>
CC: Richard Henderson <richard.henderson@linaro.org>, Peter Maydell
	<peter.maydell@linaro.org>, =?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?=
	<clg@kaod.org>, Steven Lee <steven_lee@aspeedtech.com>, Troy Lee
	<leetroy@gmail.com>, Jamin Lin <jamin_lin@aspeedtech.com>, Andrew Jeffery
	<andrew@codeconstruct.com.au>, Joel Stanley <joel@jms.id.au>, Eric Auger
	<eric.auger@redhat.com>, Helge Deller <deller@gmx.de>,
	=?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>,
	=?utf-8?B?SGVydsOpIFBvdXNzaW5lYXU=?= <hpoussin@reactos.org>, Aleksandar
 Rikalo <arikalo@gmail.com>, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Alistair Francis <alistair@alistair23.me>, Ninad Palsule
	<ninad@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Eduardo Habkost
	<eduardo@habkost.net>, "Michael S. Tsirkin" <mst@redhat.com>, Marcel
 Apfelbaum <marcel.apfelbaum@gmail.com>, Jason Wang <jasowang@redhat.com>, Yi
 Liu <yi.l.liu@intel.com>, Nicholas Piggin <npiggin@gmail.com>, Aditya Gupta
	<adityag@linux.ibm.com>, Gautam Menghani <gautam@linux.ibm.com>, Song Gao
	<gaosong@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, Jiaxun Yang
	<jiaxun.yang@flygoat.com>, Jonathan Cameron <jonathan.cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>, David Hildenbrand <david@redhat.com>, Igor
 Mammedov <imammedo@redhat.com>, Xiao Guangrong
	<xiaoguangrong.eric@gmail.com>, Beniamino Galvani <b.galvani@gmail.com>,
	Strahinja Jankovic <strahinja.p.jankovic@gmail.com>, Subbaraya Sundeep
	<sundeep.lkml@gmail.com>, Jan Kiszka <jan.kiszka@web.de>, Laurent Vivier
	<laurent@vivier.eu>, Andrey Smirnov <andrew.smirnov@gmail.com>, Aurelien
 Jarno <aurelien@aurel32.net>, BALATON Zoltan <balaton@eik.bme.hu>, Bernhard
 Beschow <shentey@gmail.com>, Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>, Jagannathan Raman
	<jag.raman@oracle.com>, Palmer Dabbelt <palmer@dabbelt.com>, Weiwei Li
	<liwei1518@gmail.com>, Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Matthew Rosato
	<mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, Thomas Huth
	<thuth@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, Christian Borntraeger
	<borntraeger@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Fam Zheng
	<fam@euphon.net>, Bin Meng <bmeng.cn@gmail.com>, Mark Cave-Ayland
	<mark.cave-ayland@ilande.co.uk>, Artyom Tarasenko <atar4qemu@gmail.com>,
	Peter Xu <peterx@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Max
 Filippov <jcmvbkbc@gmail.com>, "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
	"qemu-ppc@nongnu.org" <qemu-ppc@nongnu.org>, "qemu-riscv@nongnu.org"
	<qemu-riscv@nongnu.org>, "qemu-s390x@nongnu.org" <qemu-s390x@nongnu.org>,
	"qemu-block@nongnu.org" <qemu-block@nongnu.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>,
	=?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?= <clg@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, Alistair Francis <alistair.francis@wdc.com>
Subject: Re: [PATCH 10/35] hw/i386: QOM-ify AddressSpace
Thread-Topic: [PATCH 10/35] hw/i386: QOM-ify AddressSpace
Thread-Index: AQHcJ9KWx9pj3Mf0REGcmknY+/o41bSYcV8A
Date: Thu, 18 Sep 2025 05:53:45 +0000
Message-ID: <d571d1aa47ddbf466e9e8edf1cbb7d29f3bb0a83.camel@eviden.com>
References: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
	 <20250917-qom-v1-10-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20250917-qom-v1-10-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
Accept-Language: en-GB, fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eviden.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM8PR07MB7602:EE_|AS5PR07MB9914:EE_
x-ms-office365-filtering-correlation-id: ed90d55b-910d-47d8-f2df-08ddf677bb06
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?Q0lSeVNzalI5cEwyQ1IydlNQVk4rOVk2UENVVXk2YlJhRmVQNjNPRk9EcVRu?=
 =?utf-8?B?SHh0TGIyaFBXVW51M3MyR2dlUjMwWEJmYUNjZHY3elNwOG05UWFVU0IzZDJ0?=
 =?utf-8?B?VzRsZnRPM01aVSsrcm4vd0FhOVYxUzIwQjRzUTVKZUcydVJaY0tRU3lyU3BT?=
 =?utf-8?B?Nk9lK2w1Yk8wQVA4TXVLWkowSEwwbHdVRGNmMU9qZllZNTh4SWMwejdJbjY4?=
 =?utf-8?B?N3NQbG5BSFRobUlHMEdMOXJjaisyVnRhV1l1TnZ4dVZuMXp3UnpPMWJDVWJS?=
 =?utf-8?B?bGxWSWhuN1BsTTlrbWplYWNtb081ZHVwdzRvd2ErdW1LRXJpRktoZjdBT0Nh?=
 =?utf-8?B?b0NyTjczQndETVowNG92dWhmeXB4djhmdThnWjVxUGJUeU5NUHdWMElEc0Zq?=
 =?utf-8?B?bTNXTG5rMXpGRHBwWHUrOGhxSGlncUNPSjFmWE1WQkNrUUlJbThLMzFmWGti?=
 =?utf-8?B?SGZWRWxsU0dKazlLaDQyK2k3bkNvRXBWYTNjd2cwSk81bGNWOUd4elFjOVYy?=
 =?utf-8?B?MWRkSWZUdFB1VjFzMXBRbnNZTE1XNnY3TGNFbEh4U0tlUUtoRS9sZGtrYUpo?=
 =?utf-8?B?aHkvWERGMFpjQmkxemtIOHg0U1NJVFYyNVd5THc1ZHg0NnhrbjA1MlNtTlhn?=
 =?utf-8?B?aHlWSmFnTTVxRzQwWWJBVDVXd2JpTWRkUUY2cnFiU01HZnZjOVoyN3A5ZFVm?=
 =?utf-8?B?L01FUUNQQ09FSXB0OTM2VkpyUkJLbWVpM1ZuMmN1Y2V3NTM1WGdsd1pnYjNk?=
 =?utf-8?B?SllVV0lZeWxaRzV0NElBay9yUm1jUHJOVDRDeE1LZ0EwYVhjbkxMeTFUaFFW?=
 =?utf-8?B?M3ZQRjBkdXdVUkVRd2trUDF6VDR0Y2lxYmNjbE03TmFPdDNwT2RIeWtlQUxl?=
 =?utf-8?B?TWxYOXJVeHZadm1DNXQvMnBLc1ZLaHRjQi8wVnVmVmhCOEJRNy9UcTV2NXM3?=
 =?utf-8?B?WWY2aGdwK1hWMmowTmNiZjJzeFkrRTI1dm4zZ09kSnc5OXNUZFdoVW1RdWRF?=
 =?utf-8?B?K0dqc0RIbzc2UmVSalVzUExPVjIxNENXM3BUcGhmdXd1bXMwU09SYTJLbHlq?=
 =?utf-8?B?MWc4ZFRoZzduSkNYbUtpcjMwc012TVk2TEhpT1loQXlQWGsydml2ek5FaHhp?=
 =?utf-8?B?V1g0eXkxT0RnYUo0czBBM3JnUzc1QVgwM2JWaDNqSHhqaVFhNnJsY05vMFU0?=
 =?utf-8?B?Qjd4YzdnbzZ3aktCQURDdlU4UHkrV3RtYjNKRXlOQlpEZVhpWUpFK1hhc1NC?=
 =?utf-8?B?SWVrWDdYN1U4N25td0tJSkIxcmpOanpkZEJrKzdVSVA4Z29HR2xCQ1VmWnh3?=
 =?utf-8?B?MTRuVjk2ckNNVkt6anBWa0xScExMRlRzeWZ4dmZ3QVdxV0Npb2FsSjR4N0U0?=
 =?utf-8?B?QkVFN2pFdXRIcVpTTkxCSDRPUnJCZFlnSmc0YWcrOVowVmRWSURLcytQTWIr?=
 =?utf-8?B?K2ZXVTdMVkl6VVlySFBkeXR2SDlEREVTMGZHVVlxclpVOEM0MGVWeVdNdjNq?=
 =?utf-8?B?Zm1FRWl6clVBMXcwV1VCV3htQkdjKzZQUEVyNXRnKzNoOVkxTDlaVEQveGps?=
 =?utf-8?B?cytzWTVrM1hZemM0TDhEcmdqWDJNV245MXk2REVPMm13QlIwRUVJV0lmYWps?=
 =?utf-8?B?OCtIeEhXN0ZxS09hemxkZXNTY1BJVVV2UkI1V0FIcWl4QWlaYy91a3ZYeGtl?=
 =?utf-8?B?Z1dqckpmTlMyeGZCcnh5SXBnbkxjMXBocXY2T2FGWndTM0hnS0M5T0dBcG5X?=
 =?utf-8?B?eFl6SzdvaDh3U3hZZllyMUJhYkZhR0lIbndJOFhlY0M0VzFXQXVkcWxtQSth?=
 =?utf-8?B?UGFPUHBObnJZUmh2V0cvZnVSVzY4TjcxdUhqdWZNTTBsT05Ka3B5U2dzNisv?=
 =?utf-8?B?QUhmM0FDUFNwMDdMcEJzTm5mL01uWDluQmhUdlRUdzJRRnYwTnZjN2dIdzFN?=
 =?utf-8?B?dG92ZVJpMS96UXR4aTV3eXlsZTBtc2o4UWhodDlnWTFMVUw0WG1BcUp1VFNy?=
 =?utf-8?B?cm5hUEZOYlZBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR07MB7602.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?KzVDejlhZTJYV2h4OGJKTHZnMHErTzduSWlZK3k0amVUWGtPZjRWYndTUmlZ?=
 =?utf-8?B?WlFBakJWNzAydDByWmpieFd6am5RczlUY3pyVXU2dXJXM09BNjlCNWZLMVZP?=
 =?utf-8?B?ZUV3UlBTS1hOZWRPY0ttY2g2YjlUM0t1dTFSWTJKYjZoalVzRGVVU0hkdVhz?=
 =?utf-8?B?RkhleWlTYzA3Q1lSNmdDdE9yMUdPb0pESmZ3MjZDcmdpZDZLSUdiY0YxUlB1?=
 =?utf-8?B?NzQ0V3lJZEVKVi83WEpjR0NEamNFMU9rcDdHeTNPTllGS24rV0QxT0J0d0I1?=
 =?utf-8?B?SndpWVBJNVBBdVc2MktDYnZHUDRhc2dETkZHanp5UmxPbWRCcDg0L25hazND?=
 =?utf-8?B?bHR4bTc1WlkwV1BqTWhTcFhWcHRsRTFWNzFYRzl3OU1aKzhlY2JSUWdQK1By?=
 =?utf-8?B?NkdvU25JNnBqZTRPK2hwUUFHcS9kRWx5WEZ1YUxkQngyTWlVWDRSTnZiMjU2?=
 =?utf-8?B?VnhzTllGTElpYjAxcDJ3bnp4djZoNFIzK1p1L2wxRGlUWGV4RVRrZ2N5aDd0?=
 =?utf-8?B?MDlRZ2VwUERXT2NGeHNFaHhYZ3Z6UmJUMnFPSU9Kdm5uQVROSU5BRjJ3Nk1Y?=
 =?utf-8?B?Z0ozMmNibWs5ZnVYVUd1N2VGVGRGVnZhWkRkTnlPUTAxQVJKM0FLUFpzaGRD?=
 =?utf-8?B?L21sbzJkaTZKWUZZbDd4bEQ1aXFzdnRycTlDODFtalRzb3F1dEEvN05zVnJp?=
 =?utf-8?B?bDF3cGVVOVZaMDRFWEVtQkRIcUpXaEdXMjkrTktjanZlc2V4Y3lHekhyTW1r?=
 =?utf-8?B?emU0YkgzVGphWDVlWmdHcHJlSldURkZ0QnZ2Y2xNUDFhcVhvcU52a09pUmJ5?=
 =?utf-8?B?WmFhWVU3RVNHQXVxNG04WHR1Y1N6QkVEMFhKSGxqNFRxTnBwUFJNdkJ5MXF4?=
 =?utf-8?B?M25Xc1pOMlhEZmtCWXpWUHE2MnVhall4VzBMSTNET3dUUWJYbUJXdFZXSUZq?=
 =?utf-8?B?emc4SmZYempjYWhrMlJIeG1qU3ZPZDM0MjFuRzFwQ0FrNDE0ZHZiOXVnZ2tY?=
 =?utf-8?B?bEJkRlVBTlRXM2E5UXVhTTJ3NjNlTFJSR0txcDZrQThrVjR1K0JGUy9QYmpv?=
 =?utf-8?B?M2ZJcXNwcTdnS2ZRYmc3NEZ1M29pUDl2N0x6b3NIOFFXSCtxNnl0RWU1bkFp?=
 =?utf-8?B?Tm11SkUvN0xtNC9iOVZDYUxhRytEMVpDcUsxaUlwSFVCQWppaVQvclRyNVgz?=
 =?utf-8?B?SmpzUFpxUi80TUVLK1hRY1BKK0N1clJiQnBmNG03RG5rMnlveGV1SnA5ak1a?=
 =?utf-8?B?aVo4dWNEQzZIQUR4ZTM0Qjg3clAxelNjTDQ5K3dBaG9BeVVhV1JHVENsOCtB?=
 =?utf-8?B?T09JU3o2SE9Ib2l4b3JQbWxlK3p6SDJHYlRoRmp6VUwxQmo0TTU2MGZTbTNp?=
 =?utf-8?B?NkpBNUdENVR1UVNySTBIa1ZGQk1mamZwZzh4TlBBMStMMnhsYmY5Rm1wSGVZ?=
 =?utf-8?B?WlNheDhoUlhva0hQakw2VjZCMFJQQTM4M2dvR2NHakRUSGZZRGRJZUZrYnVN?=
 =?utf-8?B?REdEVGUvdFlVd3Ixd0NjS3BsQ1ZteHlIRU0wSno2SWVFV2tlTjFLbU1tQXk4?=
 =?utf-8?B?dit1dXphcHp3VzdIbEhkV0ozYnVVRlZCeHNXMHdqdzI1d2lpckVjbkQ5Rklx?=
 =?utf-8?B?Y3FNb0oyTlp5eGVkdWs0YVJxYVU1SFN0a0xId0tlK1lSUEJmeEFsY1ZoVEVj?=
 =?utf-8?B?bWxscGFKZUIzVFcxK3FraiswYUhLR0pRUFZ3UTZQS2pkWkRoRk1rTmpENzVG?=
 =?utf-8?B?dGRxY000b0dzWnNJNmlHRDJQL09CdWZCSUFKa2RuN1hEbkJtUTJ2S0NoaGJ5?=
 =?utf-8?B?RFkzYmJCWWIzMysrUHdUZmV3dDBDcWxKWDlWbGRTYTFvRmw2MDFDeG5pSmRt?=
 =?utf-8?B?Ukx3MDB3VTJESlN3QXl5MHlJR3pUVklMQXRsbFRBSGFjQ0JSMU13T210VWNU?=
 =?utf-8?B?Y042aTNTSUhPLy9ZZFhzVFIvbVNvbHduc3orcHM1eTJKZmJacmQvakNyNkFw?=
 =?utf-8?B?TmxTeW5iamkxN3NQQjJLMVJnaUVhSTFJSzZDSVliengrMFBmSnVnNHJYYWNy?=
 =?utf-8?B?VzVnNUtDTG1wRjd2ZDIwREpENloraWZxRnRKc3pOT2R6QTA3OWRKOUR2c3dw?=
 =?utf-8?B?VllnQTVOWGRLeGNVcW9FTmF5dmxKcHdsbWErVUpaSjBSVHVYdHlIeHlBV2Zi?=
 =?utf-8?Q?y9Pr9VcAHlUPvki1uA+gG3I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <64A3FBF2BF55624FA223ADFCEBDD2610@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: eviden.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR07MB7602.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed90d55b-910d-47d8-f2df-08ddf677bb06
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2025 05:53:45.5688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7d1c7785-2d8a-437d-b842-1ed5d8fbe00a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VkAsN/5pPGEC3cKl7kP1RhpAlkoRmkgpAiE2/Znmsg0WuKOxWAmm8cWVEn+8/ZxnDJrmse1w+RntbEeEAFf9WrNqjryacbelLyCQjxv9d7du9HvIJjPW5NmITqB1mJFK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR07MB9914

SGkgQWtpaGlrbywKCldoeSBkbyB3ZSBjaGFuZ2UgdGhlIG5hbWluZyBzY2hlbWUgaW4gYW1kLXZp
PyAgCkRpZCB5b3UgaGF2ZSBhbnkgaXNzdWUgd2l0aCB0aGUgb2xkIG9uZT8KCklmIHdlIGRlY2lk
ZSBub3QgdG8gc3RpY2sgdG8gdGhlIG9sZCBvbmUsIG1heWJlIHNwbGl0dGluZyB0aGUgc2xvdCBh
bmQgZnVuY3Rpb24gd291bGQgYmUgY29udmVuaWVudC4KClRoYW5rcwoKT24gV2VkLCAyMDI1LTA5
LTE3IGF0IDIxOjU2ICswOTAwLCBBa2loaWtvIE9kYWtpIHdyb3RlOgo+IAo+IAo+IE1ha2UgQWRk
cmVzc1NwYWNlcyBRT00gb2JqZWN0cyB0byBlbnN1cmUgdGhhdCB0aGV5IGFyZSBkZXN0cm95ZWQg
d2hlbiAgCj4gdGhlaXIgb3duZXJzIGFyZSBmaW5hbGl6ZWQgYW5kIGFsc28gdG8gZ2V0IGEgdW5p
cXVlIHBhdGggZm9yIGRlYnVnZ2luZyAgCj4gb3V0cHV0Lgo+IAo+IFRoZSBuYW1lIGFyZ3VtZW50
cyB3ZXJlIHVzZWQgdG8gZGlzdGluZ3Vpc2ggQWRkcmVzU3BhY2VzIGluIGRlYnVnZ2luZyAgCj4g
b3V0cHV0LCBidXQgdGhleSB3aWxsIHJlcHJlc2VudCBwcm9wZXJ0eSBuYW1lcyBhZnRlciBRT00t
aWZpY2F0aW9uIGFuZCAgCj4gZGVidWdnaW5nIG91dHB1dCB3aWxsIHNob3cgUU9NIHBhdGhzLiBT
byBjaGFuZ2UgdGhlbSB0byBtYWtlIHRoZW0gbW9yZSAgCj4gY29uY2lzZSBhbmQgYWxzbyBhdm9p
ZCBjb25mbGljdHMgd2l0aCBvdGhlciBwcm9wZXJ0aWVzLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFr
aWhpa28gT2Rha2kgPFtvZGFraUByc2cuY2kuaS51LXRva3lvLmFjLmpwXShtYWlsdG86b2Rha2lA
cnNnLmNpLmkudS10b2t5by5hYy5qcCk+ICAKPiAtLS0gIAo+IMKgaHcvaTM4Ni9hbWRfaW9tbXUu
Y8KgwqAgfCA1ICsrKy0tICAKPiDCoGh3L2kzODYvaW50ZWxfaW9tbXUuYyB8IDYgKysrKy0tICAK
PiDCoDIgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQo+IAo+
IGRpZmYgLS1naXQgYS9ody9pMzg2L2FtZF9pb21tdS5jIGIvaHcvaTM4Ni9hbWRfaW9tbXUuYyAg
Cj4gaW5kZXggYWYyMzkzOTBiYTA0Li41NDFiOWE4Yzg5ZTEgMTAwNjQ0ICAKPiAtLS0gYS9ody9p
Mzg2L2FtZF9pb21tdS5jICAKPiArKysgYi9ody9pMzg2L2FtZF9pb21tdS5jICAKPiBAQCAtMTQ5
NCw3ICsxNDk0LDcgQEAgc3RhdGljIEFkZHJlc3NTcGFjZSAqYW1kdmlfaG9zdF9kbWFfaW9tbXUo
UENJQnVzICpidXMsIHZvaWQgKm9wYXF1ZSwgaW50IGRldmZuKQo+IAo+IMKgwqDCoMKgIC8qIHNl
dCB1cCBBTUQtVmkgcmVnaW9uICovICAKPiDCoMKgwqDCoCBpZiAoIWlvbW11X2FzW2RldmZuXSkg
eyAgCj4gLcKgwqDCoMKgwqDCoMKgIHNucHJpbnRmKG5hbWUsIHNpemVvZihuYW1lKSwgImFtZF9p
b21tdV9kZXZmbl8lZCIsIGRldmZuKTsgIAo+ICvCoMKgwqDCoMKgwqDCoCBzbnByaW50ZihuYW1l
LCBzaXplb2YobmFtZSksICJhcy0lZCIsIGRldmZuKTsKPiAKPiDCoMKgwqDCoMKgwqDCoMKgIGlv
bW11X2FzW2RldmZuXSA9IGdfbmV3MChBTURWSUFkZHJlc3NTcGFjZSwgMSk7ICAKPiDCoMKgwqDC
oMKgwqDCoMKgIGlvbW11X2FzW2RldmZuXS0+YnVzX251bSA9ICh1aW50OF90KWJ1c19udW07ICAK
PiBAQCAtMTUyMiw3ICsxNTIyLDggQEAgc3RhdGljIEFkZHJlc3NTcGFjZSAqYW1kdmlfaG9zdF9k
bWFfaW9tbXUoUENJQnVzICpidXMsIHZvaWQgKm9wYXF1ZSwgaW50IGRldmZuKSAgCj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgICJhbWRfaW9tbXUiLCBVSU5UNjRfTUFYKTsgIAo+IMKgwqDCoMKgwqDCoMKgwqAgbWVtb3J5
X3JlZ2lvbl9pbml0KCZhbWR2aV9kZXZfYXMtPnJvb3QsIE9CSkVDVChzKSwgIAo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAiYW1kdmlfcm9v
dCIsIFVJTlQ2NF9NQVgpOyAgCj4gLcKgwqDCoMKgwqDCoMKgIGFkZHJlc3Nfc3BhY2VfaW5pdCgm
YW1kdmlfZGV2X2FzLT5hcywgTlVMTCwgJmFtZHZpX2Rldl9hcy0+cm9vdCwgbmFtZSk7ICAKPiAr
wqDCoMKgwqDCoMKgwqAgYWRkcmVzc19zcGFjZV9pbml0KCZhbWR2aV9kZXZfYXMtPmFzLCBPQkpF
Q1QocyksICZhbWR2aV9kZXZfYXMtPnJvb3QsICAKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBuYW1lKTsgIAo+IMKgwqDCoMKgwqDCoMKgwqAg
bWVtb3J5X3JlZ2lvbl9hZGRfc3VicmVnaW9uX292ZXJsYXAoJmFtZHZpX2Rldl9hcy0+cm9vdCwg
MCwgIAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgTUVNT1JZX1JFR0lPTigmYW1k
dmlfZGV2X2FzLT5pb21tdSksICAKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDAp
OyAgCj4gZGlmZiAtLWdpdCBhL2h3L2kzODYvaW50ZWxfaW9tbXUuYyBiL2h3L2kzODYvaW50ZWxf
aW9tbXUuYyAgCj4gaW5kZXggMWY0MGQ5MDQzMjZlLi41ZTZkN2Q1MTBlMDMgMTAwNjQ0ICAKPiAt
LS0gYS9ody9pMzg2L2ludGVsX2lvbW11LmMgIAo+ICsrKyBiL2h3L2kzODYvaW50ZWxfaW9tbXUu
YyAgCj4gQEAgLTQyMjEsNiArNDIyMSw3IEBAIFZUREFkZHJlc3NTcGFjZSAqdnRkX2ZpbmRfYWRk
X2FzKEludGVsSU9NTVVTdGF0ZSAqcywgUENJQnVzICpidXMsICAKPiDCoMKgwqDCoCB2dGRfaW9t
bXVfdW5sb2NrKHMpOwo+IAo+IMKgwqDCoMKgIGlmICghdnRkX2Rldl9hcykgeyAgCj4gK8KgwqDC
oMKgwqDCoMKgIGdfYXV0b2ZyZWUgY2hhciAqYXNfbmFtZSA9IE5VTEw7ICAKPiDCoMKgwqDCoMKg
wqDCoMKgIHN0cnVjdCB2dGRfYXNfa2V5ICpuZXdfa2V5OyAgCj4gwqDCoMKgwqDCoMKgwqDCoCAv
KiBTbG93IHBhdGggKi8KPiAKPiBAQCAtNDI2Myw4ICs0MjY0LDkgQEAgVlREQWRkcmVzc1NwYWNl
ICp2dGRfZmluZF9hZGRfYXMoSW50ZWxJT01NVVN0YXRlICpzLCBQQ0lCdXMgKmJ1cywgIAo+IMKg
wqDCoMKgwqDCoMKgwqAgdnRkX2Rldl9hcy0+aW92YV90cmVlID0gaW92YV90cmVlX25ldygpOwo+
IAo+IMKgwqDCoMKgwqDCoMKgwqAgbWVtb3J5X3JlZ2lvbl9pbml0KCZ2dGRfZGV2X2FzLT5yb290
LCBPQkpFQ1QocyksIG5hbWUsIFVJTlQ2NF9NQVgpOyAgCj4gLcKgwqDCoMKgwqDCoMKgIGFkZHJl
c3Nfc3BhY2VfaW5pdCgmdnRkX2Rldl9hcy0+YXMsIE5VTEwsICZ2dGRfZGV2X2FzLT5yb290LCAg
Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
InZ0ZC1yb290Iik7ICAKPiArwqDCoMKgwqDCoMKgwqAgYXNfbmFtZSA9IGdfc3RyY29uY2F0KG5h
bWUsICItYXMiLCBOVUxMKTsgIAo+ICvCoMKgwqDCoMKgwqDCoCBhZGRyZXNzX3NwYWNlX2luaXQo
JnZ0ZF9kZXZfYXMtPmFzLCBPQkpFQ1QocyksICZ2dGRfZGV2X2FzLT5yb290LCAgCj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYXNfbmFtZSk7
Cj4gCj4gwqDCoMKgwqDCoMKgwqDCoCAvKiAgCj4gwqDCoMKgwqDCoMKgwqDCoMKgICogQnVpbGQg
dGhlIERNQVItZGlzYWJsZWQgY29udGFpbmVyIHdpdGggYWxpYXNlcyB0byB0aGUKPiAKPiAtLSAg
Cj4gMi41MS4wCj4gCg==

