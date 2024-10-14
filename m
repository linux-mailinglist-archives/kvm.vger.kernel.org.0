Return-Path: <kvm+bounces-28770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A800799CF05
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 16:50:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1984AB24952
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 14:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A46271C876D;
	Mon, 14 Oct 2024 14:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="byWJXSFa";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="byWJXSFa"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2041.outbound.protection.outlook.com [40.107.22.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536431C7B7E;
	Mon, 14 Oct 2024 14:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917237; cv=fail; b=oYmkzVlfNzKwe1SiIB9UU7QA4dFaNwwCcb3vHj7YzThHjqVL7qOhfiNrgjBXKjbbEwTQGSx8GGsVUeXjnPT7/s8K6vaCPKjhDM+AgPmYwTk7rTsD4DgruHdCsJEtk5x93HY3C7N5uTOcrU7TenpUYSrwAmi6sMbdU0JYDsB7FDw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917237; c=relaxed/simple;
	bh=+Fz1R73ldd4yyJ5G4G2F/oEPcs198Gzzu064JfF1Rpo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lOEBOiGMsy9BaSCe9eInzOFoI2mUTnxEDXbdTzLDhXzDYTcT/5zB8WEiD1H/yUQwxnHKBbRGVreAardTqFS2k7EbY1Xm5rBRJMVvdXnyq+VyQN950EVI5YvEmNKMFP4B4pEsL/0xwh+EroQm+nusvLU7dP8k+Pf8nG7XxNCqj6Q=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=byWJXSFa; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=byWJXSFa; arc=fail smtp.client-ip=40.107.22.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dFB9F2dp0oiuQOvTCzWRfXRf2OTjG59bS3a36Wi0OCeBSbSi0boKJepAQxpIYoD7a/Etg3IaHsNUbxaFlEU2PlDX0wknE2H2DKMfz0YJ4LGn+6KovgLWCrl9KdlnEiYi9dNS5m/d/bsNnmXbBVW6FUGurODlH8dukZvmoItDFt+11k02kdK/iQI7GaqwbJPULqHosnLmRa0T0qJuMa+0D3IL0WxaNGlEwBdV7iqWLBXqB45OlQA96XEKuMeuytpakB85qix1HFXhkS4+AxcgQvu7Ruc+P47K/SL8oWlbwfl2z8sQ2Rq/vhv+l0QCTgp5gW9yjMkvqMbqNAYSgOWvQg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQM6S8QstQ01GaYTk6Ti2JxJ4k7ycHXXb8EH8GhPNVA=;
 b=joKwnUt/BHUtLCoPGB9meQ1Cyovd+1bxSFjfdufzdyNs6aVZ3x1let3sdXIe/YMwRXLsdZuDPcUMXocqjn6t2JKoKFPlcNf4jg0WdnZsj4o1hsLxZrAsPQrrlKKa+iYTMxqwlJmMagTBkKFTteAaA/ksFEEGsJOEqzYq+AZOCGsC03gGEuyn8CwjKDhEhztPJCm6GV1yFk/zljBAaA18jvvMgUj4BS1C1e7pYsL0la6I3V5FYGJWiwh8onECEzSVtn+ymTPx4dmkF54LlIc9uz1NytWbwGm+EmJxqzAlTIG2fshzO2ZSNB6yKeeVmP6up30q66zEAc0kgIGBWFXvCw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQM6S8QstQ01GaYTk6Ti2JxJ4k7ycHXXb8EH8GhPNVA=;
 b=byWJXSFagKXod8+zSUspg4N71QlS0MNHFh9V/kMbzhI4bltxVnqJNdcw5S3Crs3cK+uqHDdQcEJXQxY+BQgGMx5m5vdgGJoh30SOzfT7QnhpAIINaG6bH2hkqvipFeoEB4VCeTGnjqCsBgkfJgAho/5yXetF2Gezb5k7xj2RHi0=
Received: from DU7P191CA0022.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:54e::22)
 by DU0PR08MB8114.eurprd08.prod.outlook.com (2603:10a6:10:3ea::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.20; Mon, 14 Oct
 2024 14:47:00 +0000
Received: from DB5PEPF00014B89.eurprd02.prod.outlook.com
 (2603:10a6:10:54e:cafe::34) by DU7P191CA0022.outlook.office365.com
 (2603:10a6:10:54e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26 via Frontend
 Transport; Mon, 14 Oct 2024 14:47:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5PEPF00014B89.mail.protection.outlook.com (10.167.8.197) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Mon, 14 Oct 2024 14:47:00 +0000
Received: ("Tessian outbound 40ef283ec771:v473"); Mon, 14 Oct 2024 14:46:59 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 814322d8e08652be
X-TessianGatewayMetadata: kxJL4Do6320csnr5F0Ugik0bFtGvQJEpMmvEqJb0Krs1UwOEQNFwuefNx8fDIW87RTj84K7aOFSSo5+zY/BwT6XbwjAgDchjOwTCB81rmBcM726uETxLqhkAd+Xo4GxU96hOLA2VjU5SbI+rwAPZaxOS5WnjWivEDT4YBuHf2Ug=
X-CR-MTA-TID: 64aa7808
Received: from Lc22f3cfc2694.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 341263D5-F4E0-414A-9AFE-4D5BED9673C9.1;
	Mon, 14 Oct 2024 14:46:53 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id Lc22f3cfc2694.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 14 Oct 2024 14:46:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a+Bv4Ytr1gRXzX2Qot4HlCrEn1xj10LrGOtVH6EHWu5Fo+f95cHcroYYRN/Mp6RazMIPdJuyS7qD+9Y0sMYVGh8kiWxG5tM//Z5a2LS5J9SxKxGfSayx81E4u+F28OUNJIyrPXG7664yFKVrWG5+I1TIv3UVdsygFUXiMxyV0+xAUl85q6q+0az+nJI7/wvTqDat7Kt/07oyN+FDqCgJJXlLxMlixU4ouWbprkdTJQtTlmIGsCZAYA4pz2jqSZ6G03AQfHiXhSxT6nIWGPBPiWgUWPCzZ+zT76DjiEFoOZw4+qOr5JXysLJv+/tmnVDllzHHCh1aSGGZtiYBwCupFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQM6S8QstQ01GaYTk6Ti2JxJ4k7ycHXXb8EH8GhPNVA=;
 b=L0zr6nOGfYzeTQcxvJDdDaNoxHlHSq9oCryeihmSjOj0Vhu56LghDTJ2CUqkSwsUXngH35Kjy16PKAK9qHmoeuvh2c+JTwCJ/ZYwh16zCuU0KbP3RkR/V0TdZP1o1pRG1pXYsr54pRUJOO8rxxxB56lFOUdZKEBKx8YTXhlwn6h9RyrXGpNTcYYWaTSsHKS5fN6g7dkxPBgyrb8P9EznhK81Wwsh11KPY/t6iHCxtx6Ow2WicbWFLsvnQm/ViyKXWEX/Chs4Y/GRE6OHLtGUx3IKc+ZGOf9znRDp5tJS4L1KyBH0pr4lYXnEQF5ONseDuLO4JWm1TcSxF1y83gzKWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQM6S8QstQ01GaYTk6Ti2JxJ4k7ycHXXb8EH8GhPNVA=;
 b=byWJXSFagKXod8+zSUspg4N71QlS0MNHFh9V/kMbzhI4bltxVnqJNdcw5S3Crs3cK+uqHDdQcEJXQxY+BQgGMx5m5vdgGJoh30SOzfT7QnhpAIINaG6bH2hkqvipFeoEB4VCeTGnjqCsBgkfJgAho/5yXetF2Gezb5k7xj2RHi0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com (2603:10a6:150:6b::6)
 by AS8PR08MB6455.eurprd08.prod.outlook.com (2603:10a6:20b:338::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Mon, 14 Oct
 2024 14:46:50 +0000
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469]) by GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469%7]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 14:46:50 +0000
Message-ID: <56d9edcb-2574-43fe-8ebb-65cc4fdbc3d0@arm.com>
Date: Mon, 14 Oct 2024 15:46:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/11] virt: arm-cca-guest: TSM_REPORT support for
 realms
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, Gavin Shan <gshan@redhat.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Sami Mujawar <sami.mujawar@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, Dan Williams <dan.j.williams@intel.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-11-steven.price@arm.com>
 <5a3432d1-6a79-434c-bc93-6317c8c6435c@redhat.com>
 <6c306817-fbd7-402c-8425-a4523ed43114@arm.com>
 <7a83461d-40fd-4e61-8833-5dae2abaf82b@arm.com>
 <5999b021-0ae3-4d90-ae29-f18f187fd115@redhat.com>
 <11cff100-3406-4608-9993-c29caf3d086d@arm.com>
 <f3ce0718-064d-48e4-a681-7058157127b0@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <f3ce0718-064d-48e4-a681-7058157127b0@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0141.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::20) To GVXPR08MB7727.eurprd08.prod.outlook.com
 (2603:10a6:150:6b::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB7727:EE_|AS8PR08MB6455:EE_|DB5PEPF00014B89:EE_|DU0PR08MB8114:EE_
X-MS-Office365-Filtering-Correlation-Id: 87520963-3dde-4139-94d9-08dcec5f0f7f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?b29oQnFBcXdxOE4vc1V4Y2dWTWhCL1RTc25hSm5CRmlPcTdNSUt6Nkk4a0Za?=
 =?utf-8?B?VHRwS3N5N0Z1RWtPOWV2V0gvYlIzUW53SmRoQmxLSlhQamQ5emFPRnZqVkds?=
 =?utf-8?B?ODg5NTVYWktod2pCZmhFaGxrMEZrTlZUSUt3aDY1ZFRTa3FDTHcwdituSGdW?=
 =?utf-8?B?Ynd5OW9XYmJtajJQY25uWmZZS1UraktqZUtZSnlaVVNFeGpKc3BScWFRNWll?=
 =?utf-8?B?Sm1xM2F1NG1mUEwyUEtXV1hYNUFJOCtpdG93TG1RdXVuYk1JQ24rZkV0L2xF?=
 =?utf-8?B?bjJwTjUvdGtYRDRKSUpoeGRTL0FSMUR5dFpFa0p4Z3p0UWEwY2pkVXZUMzJk?=
 =?utf-8?B?K1pEd0hySEtWNE52MHpKbkI2Q1prU1MyRjcrTVNxaDBpblEwS25nU2grSkFl?=
 =?utf-8?B?dnQrTjU5OWlpN0Nla0dmRFVYczI2RksxMkRMcTkzSFNGWlMvT0h1OGF3TDhm?=
 =?utf-8?B?R3pmZk8wNzZ5eGxPN0hqZDhFM0ppTEx6eDBGQXRRa2piRkg2ZWYya05NdTJC?=
 =?utf-8?B?djdsWU5PWWl2T2IrbFkvR3JSUUxJZDFPWjRJMmxIV3RuTFk0ME1zMG1jY0lJ?=
 =?utf-8?B?dUtvNW1JSkJaY3dPdFFKTFRYdFE4ZUsxSVd2VWd3emdleXdQTlZZVkpFejht?=
 =?utf-8?B?YVp2c0NBZnJnL1V2NnMvZ2NHenlIV2p5Mk1WczVDcWdVeUdWMVNlUm1YTS9B?=
 =?utf-8?B?VForUnBmRGU0S0FoSDdQNTZOWHVNZWUwVVl3NnVGM2NtQS9Ud1AxOXAvbmZD?=
 =?utf-8?B?NHZlM1ZreFpFRjBxTlphbzlUenZxdEIyaCt0anRhWFJJeXg3Vm1JOWF6cUgv?=
 =?utf-8?B?SHF0TnVIMzNXQTNvM0lwYWs2MmhUcnZuQVVTSmRXdDNiT1VtWGFYSlBuSnAz?=
 =?utf-8?B?TWwxYVlvRzdnQ1FkbzNsMC9ra2Fma3ZROEhPVkJFRDZvY1NTemE5Z0RZWldB?=
 =?utf-8?B?cFgvYi9za3dzUm9wWUx6NEIyNGR6bkVkdFpBY1RRK2RQd1p0V3IzckVmU2RI?=
 =?utf-8?B?NURTV3ZXMDN4N0w4aXpLbTJBTURNQ20wY0oxT1YrRk9iNElFbi92RWpiTzNE?=
 =?utf-8?B?NFpOcUJLOW41VmFBN0FFelVIOGhJK3c0RHRBV3hvOW1SRlNxQ25BdFgrcDhU?=
 =?utf-8?B?blJaM2RXK1E3U05pSTJiRE5Xc3NFR1Z3UllUTUk3Uk9sVjJNbFo0a0FJa1p1?=
 =?utf-8?B?TFg5OFRpRHI2NnlvemY0Qlh5aTRDY0crRi8wSHB5Rm5saXc3S0svbHdUU3Zy?=
 =?utf-8?B?ZGJqdFdCSUlXcHNYQ1FGVks5K3A5SHFVVmk0ZG9mdDB2bUpLQVBQWVMyWjBs?=
 =?utf-8?B?bWRJWkNlZitjNU5WVkRiUGhFYXNXTjcveHJsR2FpWjB2WjdKM1pEMEcyL2FX?=
 =?utf-8?B?VXZSeEhVMDJGdWtpMWlKT2NTbU5lOWM3SnUzekRzQXB0V0JlZmdaYkFBdnhR?=
 =?utf-8?B?a3pwVzNzeUl2SEtFOUdFREt3UGFKeDVwUWt4eGNLdzNjeFhlaHg0OWdsQm1o?=
 =?utf-8?B?RGhjbFVQTlFEditndjlmY2tKZjRLUHhKcWp1Smg0U0FsV2pUcTJJZVFtdjFE?=
 =?utf-8?B?Z2x0M1dIL3lVUEFoYUNMTS9MbktWWTFIZ2dzcGlicG80c1crSDZuNGwvRUxz?=
 =?utf-8?B?WHBrU1RLM080dkZ2MXMzNmloV2NLSGpCV2NPbzF3TGdYa2gwdWFPWlhQNXQw?=
 =?utf-8?B?RkIyVXVYRFBTU0J0dUxYZnJxTWdaSFpGV1Y3T1BaYWFEeVVndFljMG13PT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB7727.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6455
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:6b::6];domain=GVXPR08MB7727.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B89.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	019d5741-4f46-43e6-4cdc-08dcec5f093e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TnhQZFZNdGxKOFpXMUh2MTBubi9TMUVyNE5VY2JnM2lxUUYxWnA0NDlYVjl5?=
 =?utf-8?B?TjRrTFBlYXN1WTFQeTlsQVl5V1RJa1hhY0dOWFp6bGNHZDFaMERqV0Z3UWRE?=
 =?utf-8?B?TVoxQ1lKQWluZytOOWVKcDNEQzZ2djExdit2L3R5clZMU0k1NlIxK2JYVmZK?=
 =?utf-8?B?N09Rbll2MmljUlBjcHpMRDg2RFZDc2dSbUIwL3JTTUtpdXpLdXNROXVLZHRj?=
 =?utf-8?B?OHFENzlqTnd2WVQxZlFCNEt0MVkyY1lNVjVuQ1FReitTZ08zSEFWWEJYVkpk?=
 =?utf-8?B?WndOa08vWk5ZSW1nTHZNLzlGWWltV0JzazFmYkVpN0tmOEdFbk1zdG1qc1FE?=
 =?utf-8?B?cVF2clVtR1JGSEV2a2JGQVJkcUkxaEhUOTVKQU9NWGdlRldIZmJwcUk5RGl1?=
 =?utf-8?B?N01XSGpXZDBiV1BCcGtSU1NWK0J4YVBPZm9DSzFGdVBXN09WQkt0VkdRRmlj?=
 =?utf-8?B?MUFCeHRhU3M3RXVrRE1QQ0RjcjFaNll3eWZwYTNiejhXQ2pkbW01WmJkeWNY?=
 =?utf-8?B?Q3I2MkRWbFFTcXU3cVo0cTQ1ZUNPWVpRdzlwbWJXYjIvVW5oMEVtenNVVmov?=
 =?utf-8?B?YWRiZEhtLzlMQ3lpN3Qyb2wrMExFT0hraGtDS1VhZGg1eVgwYVRQSkNDdTNx?=
 =?utf-8?B?TjM2eU1WZ1lNOHRtdWEwbDFSM21UMUt4WkJzN3d4UGpsV0JJWS9EcldLSlMw?=
 =?utf-8?B?bm5LSWd4c1NpVXlWVHhKRFN6Y29hK0VJdlBGaUU4SEEzV2FHaVRnYXZ3eTVM?=
 =?utf-8?B?ZHl3dnFkTTRRVEpVUDcxYWhqVHhrTUMxQjFNRnY1SW1WeFZOUGhQKzlYNU1z?=
 =?utf-8?B?YWlVcHhRRU9aNWhsSEx1dTUvOEJyNHlOUFlsdlE3akhYUElZWWxQOGhHUnM2?=
 =?utf-8?B?M2hJWDR6eEJOM1JSQVlCeEYvbkxsTFNhcE9XQUlXR3dGbGNqeVJjQlQ5QjFq?=
 =?utf-8?B?TnQrT1lVUUFVOHpxeXFqZGlyUmZRSEhsbjk1bC8wUDVHdnpvNjZmMTFxN0FF?=
 =?utf-8?B?MzE2OW1yNDEvb0YxWTBDQTRDcnpkLzJCN0tMckd3L2YxZVZWMjVsWStiL0Qy?=
 =?utf-8?B?cEJiWnJyR1lVSTMxdG9XaldaNGprRHV5OFBaMzZCSVBCSHU2SG1qY205Zzh2?=
 =?utf-8?B?SWNBMHZ1ZmY2OW85VHFjanR3ZWZPNW5YUEJQVHVTUXlRN1FkTUEzQ3JmQ3RY?=
 =?utf-8?B?Mm01NS9FZUdpbHdZd1NVekxoTlk1MElQakhuY092c0hhN3dhTXk4TEsrVk4y?=
 =?utf-8?B?VVFQTHBoMjRFaitQMlZmY2U5b0RzcUNWdDBJT20rNFQvdllQRzJ6eVVGc3NJ?=
 =?utf-8?B?QlVtOXNwTGVyaHFIL3pjSGZydFNNbk5jb1lOb0Z4U1VaMVp5bHJnaTYwejhq?=
 =?utf-8?B?TzBlZTFrR0VzUjVLUlpoM09CblBPVk1GRzI3c255ZTNhN1dzTFRIU3lOa1lG?=
 =?utf-8?B?TmFTNE5mQ0lhZTBkVDVBdm9GQVpOemphMHlORThqWm00STNkNXFXUXd0UzJv?=
 =?utf-8?B?VTFqRTBkUXZSVE1XSERqV3ljbm1IOEZaTUZsU2JjbElhWkJyUWtpR0lPOEx3?=
 =?utf-8?B?NGxGVjRlL0liUko5NXZ5T1Y5Q2V0cXV5TW5xT0Z1UytXam9kTU1SL0d1TjMx?=
 =?utf-8?B?WEFWeWJKQkh6L0lkK3VmSEFCQmlLTjV3VDlkbkwrSDlhM2lGM1BmcGUrR1VH?=
 =?utf-8?B?MEhtZ1NsTzMyTStzbjVnbFRsZHNlL1E0Si8vSy9qNHcvTTl3ZTdCUzlGQURh?=
 =?utf-8?B?aXE5WWF4VmNWTnB2cjZ6NDFERDBiUFNXVldtUFNwYVYzbE8wVVhEbTF1RWxv?=
 =?utf-8?B?ak1rM1NkTzlPRllOdXZKMXQ2cDMwTmJtTjF5NHJJeXhUbStDRi83cFpBMGRK?=
 =?utf-8?Q?8vP0aP/0HyC1s?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2024 14:47:00.5835
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87520963-3dde-4139-94d9-08dcec5f0f7f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B89.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8114

On 14/10/2024 15:41, Steven Price wrote:
> On 14/10/2024 09:56, Suzuki K Poulose wrote:
>> On 12/10/2024 07:06, Gavin Shan wrote:
>>> On 10/12/24 2:22 AM, Suzuki K Poulose wrote:
>>>> On 11/10/2024 15:14, Steven Price wrote:
>>>>> On 08/10/2024 05:12, Gavin Shan wrote:
>>>>>> On 10/5/24 12:43 AM, Steven Price wrote:
>>>>>>> From: Sami Mujawar <sami.mujawar@arm.com>
>>>>>>>
>>>>>>> Introduce an arm-cca-guest driver that registers with
>>>>>>> the configfs-tsm module to provide user interfaces for
>>>>>>> retrieving an attestation token.
>>>>>>>
>>>>>>> When a new report is requested the arm-cca-guest driver
>>>>>>> invokes the appropriate RSI interfaces to query an
>>>>>>> attestation token.
>>>>>>>
>>>>>>> The steps to retrieve an attestation token are as follows:
>>>>>>>      1. Mount the configfs filesystem if not already mounted
>>>>>>>         mount -t configfs none /sys/kernel/config
>>>>>>>      2. Generate an attestation token
>>>>>>>         report=/sys/kernel/config/tsm/report/report0
>>>>>>>         mkdir $report
>>>>>>>         dd if=/dev/urandom bs=64 count=1 > $report/inblob
>>>>>>>         hexdump -C $report/outblob
>>>>>>>         rmdir $report
>>>>>>>
>>>>>>> Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
>>>>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>>>>> ---
>>>>>>> v3: Minor improvements to comments and adapt to the renaming of
>>>>>>> GRANULE_SIZE to RSI_GRANULE_SIZE.
>>>>>>> ---
>>>>>>>     drivers/virt/coco/Kconfig                     |   2 +
>>>>>>>     drivers/virt/coco/Makefile                    |   1 +
>>>>>>>     drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
>>>>>>>     drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
>>>>>>>     .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 211
>>>>>>> ++++++++++++ ++++++
>>>>>>>     5 files changed, 227 insertions(+)
>>>>>>>     create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
>>>>>>>     create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
>>>>>>>     create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
>>>
>>> [...]
>>>
>>>>>>> +/**
>>>>>>> + * arm_cca_report_new - Generate a new attestation token.
>>>>>>> + *
>>>>>>> + * @report: pointer to the TSM report context information.
>>>>>>> + * @data:  pointer to the context specific data for this module.
>>>>>>> + *
>>>>>>> + * Initialise the attestation token generation using the
>>>>>>> challenge data
>>>>>>> + * passed in the TSM descriptor. Allocate memory for the attestation
>>>>>>> token
>>>>>>> + * and schedule calls to retrieve the attestation token on the
>>>>>>> same CPU
>>>>>>> + * on which the attestation token generation was initialised.
>>>>>>> + *
>>>>>>> + * The challenge data must be at least 32 bytes and no more than 64
>>>>>>> bytes. If
>>>>>>> + * less than 64 bytes are provided it will be zero padded to 64
>>>>>>> bytes.
>>>>>>> + *
>>>>>>> + * Return:
>>>>>>> + * * %0        - Attestation token generated successfully.
>>>>>>> + * * %-EINVAL  - A parameter was not valid.
>>>>>>> + * * %-ENOMEM  - Out of memory.
>>>>>>> + * * %-EFAULT  - Failed to get IPA for memory page(s).
>>>>>>> + * * A negative status code as returned by
>>>>>>> smp_call_function_single().
>>>>>>> + */
>>>>>>> +static int arm_cca_report_new(struct tsm_report *report, void *data)
>>>>>>> +{
>>>>>>> +    int ret;
>>>>>>> +    int cpu;
>>>>>>> +    long max_size;
>>>>>>> +    unsigned long token_size;
>>>>>>> +    struct arm_cca_token_info info;
>>>>>>> +    void *buf;
>>>>>>> +    u8 *token __free(kvfree) = NULL;
>>>>>>> +    struct tsm_desc *desc = &report->desc;
>>>>>>> +
>>>>>>> +    if (!report)
>>>>>>> +        return -EINVAL;
>>>>>>> +
>>>>>>
>>>>>> This check seems unnecessary and can be dropped.
>>>>>
>>>>> Ack
>>>>>
>>>>>>> +    if (desc->inblob_len < 32 || desc->inblob_len > 64)
>>>>>>> +        return -EINVAL;
>>>>>>> +
>>>>>>> +    /*
>>>>>>> +     * Get a CPU on which the attestation token generation will be
>>>>>>> +     * scheduled and initialise the attestation token generation.
>>>>>>> +     */
>>>>>>> +    cpu = get_cpu();
>>>>>>> +    max_size = rsi_attestation_token_init(desc->inblob,
>>>>>>> desc->inblob_len);
>>>>>>> +    put_cpu();
>>>>>>> +
>>>>>>
>>>>>> It seems that put_cpu() is called early, meaning the CPU can go
>>>>>> away before
>>>>>> the subsequent call to arm_cca_attestation_continue() ?
>>>>>
>>>>> Indeed, good spot. I'll move it to the end of the function and update
>>>>> the error paths below.
>>>>
>>>> Actually this was on purpose, not to block the CPU hotplug. The
>>>> attestation must be completed on the same CPU.
>>>>
>>>> We can detect the failure from "smp_call" further down and make sure
>>>> we can safely complete the operation or restart it.
>>>>
>>>
>>> Yes, It's fine to call put_cpu() early since we're tolerant to error
>>> introduced
>>> by CPU unplug. It's a bit confused that rsi_attestation_token_init()
>>> is called
>>> on the local CPU while arm_cca_attestation_continue() is called on
>>> same CPU
>>> with help of smp_call_function_single(). Does it make sense to unify
>>> so that
>>> both will be invoked with the help of smp_call_function_single() ?
>>>
>>>       int cpu = smp_processor_id();
>>>
>>>       /*
>>>        * The calling and target CPU can be different after the calling
>>> process
>>>        * is migrated to another different CPU. It's guaranteed the
>>> attestatation
>>>        * always happen on the target CPU with smp_call_function_single().
>>>        */
>>>       ret = smp_call_function_single(cpu,
>>> rsi_attestation_token_init_wrapper,
>>>                                      (void *)&info, true);
>>
>> Well, we want to allocate sufficient size buffer (size returned from
>> token_init())  outside an atomic context (thus not in smp_call_function()).
>>
>> May be we could make this "allocation" restriction in a comment to
>> make it clear, why we do it this way.
> 
> So if I've followed this correctly the get_cpu() route doesn't work
> because of the need to allocate outblob. So using
> smp_call_function_single() for all calls seems to be the best approach,
> along with a comment explaining what's going on. So how about:
> 
> 	/*
> 	 * The attestation token 'init' and 'continue' calls must be
> 	 * performed on the same CPU. smp_call_function_single() is used
> 	 * instead of simply calling get_cpu() because of the need to
> 	 * allocate outblob based on the returned value from the 'init'
> 	 * call and that cannot be done in an atomic context.
> 	 */
> 	cpu = smp_processor_id();
> 
> 	info.challenge = desc->inblob;
> 	info.challenge_size = desc->inblob_len;
> 
> 	ret = smp_call_function_single(cpu, arm_cca_attestation_init,
> 				       &info, true);
> 	if (ret)
> 		return ret;
> 	max_size = info.result;
> 
> (with appropriate updates to the 'info' struct and a new
> arm_cca_attestation_init() wrapper for rsi_attestation_token_init()).

That sounds good to me.

Suzuki



