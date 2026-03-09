Return-Path: <kvm+bounces-73256-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KQdSD6VfrmlbCwIAu9opvQ
	(envelope-from <kvm+bounces-73256-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 06:50:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 88A54233FDF
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 06:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4AE8F301DE21
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 05:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F8134C802;
	Mon,  9 Mar 2026 05:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Wv/Asx4N";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ooqelc5i"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8F326B742
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 05:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773035421; cv=fail; b=SWDBqTCstDW+SkJ1ozVERH4XVnbt3eCE0G4r0IibrLqnNmpNyLrfHMA0UjCh2EX4IEm/Fz1pCuiQt6tN/IW99g6CJisy9sdNLI/Vu3psBvZZUBqVwbVJgF6A5IEcEZjRZJsG6gNCIAxrcKnkgFO8pgreHt2w8bc7zbYiMOyLSto=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773035421; c=relaxed/simple;
	bh=ao8T15xZzho2DcWjwG9tTAowPzCU4Le04njMiE5ZcEY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tC/RRoYhEYfpWGHQYOrRItOfY33qxD9/CpxH5cHzxvlwkouktw6jOW/m70YW4NAUo+Z5oKKOOz6QZJ1ikXK5DFMi2WRXi9XPCa3aLUgBJbOgL2hNQnXKW4R6CBdgbasEsWdQuo++gWtkSxdDX+Ph3atcfjvCCVkEhyr5LgxsWqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Wv/Asx4N; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ooqelc5i; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6295bI7W3436334;
	Sun, 8 Mar 2026 22:50:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=ao8T15xZzho2DcWjwG9tTAowPzCU4Le04njMiE5Zc
	EY=; b=Wv/Asx4Ny5I165ecdNWz+RiUKyhmCmRgAWbkSJIg+YfpkoI1Uj1XgwX44
	W+53T4Y/lw0jwag0fbcsVn3JmsfgCqmnyoRMof+zjcxKJMfUM1GFTMyGI/aRGkBW
	+a28fNVFOZKDg5J5UOEYvb2Mu5jTwbmn0oDYdqMKRZIPkHetVFEiLiBNx89GaFpb
	ykrO1dDmpF5hQJQ8Gw4xwzIUwPsWxhznFf/hHYVY1qySFmXhpzNDoClDXHwckRmg
	xVA8A00ziRSUtCg1UPtdj/gpkxBly9LvAlBlU94/mSLlvUmQAksB4dGvqpR0dL2U
	gXTN2iRq4BMXIUlt9K2zLWTnv1lhA==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11022113.outbound.protection.outlook.com [40.93.195.113])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4crjecjp5p-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 22:50:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KANSEEiayQ09bXW35h72IWSlrel//tbhYfcrgClX3zy1vC3ioeuH8Ewgse84qaKpSHZDIS6YK8Pd/kJvK0bjPWg9oIn4Kosh7SZbp5hV/+O0Xr+2e1xJg3NAejrmH7lfcFVUGSXBwUV5DDDDacdY+tP2XCdZm9EWXDx7UK88q5V7hP/GfIeglwhjE8HJzIEWhNN3VuMFp3a/puTBeao8yIeN88e2kf0qPFxVe+7jY82UKGSgv8leeVZLu07OxwB+DBgeDmO8iocl1ybC1xyMVpDlB2ye121SUx5Q1pmoaNxddEFRiN5XCuNOSRVpM/px/WjonBbu1Op+aWEMaTGkpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ao8T15xZzho2DcWjwG9tTAowPzCU4Le04njMiE5ZcEY=;
 b=J7cO9Pi5J4FQ1tReHUAqjkx7gpUhywb6KKQUG0Oe9xOetbVCzyy6RABqcmN2IbJ9IzKfSnOZmtGXakoyE1ZJUUqT0tJhIyYs0EdEP5rhevi79oJvQkl/lh9Ffi0qYhi36656nf245gD99uqpHru7cPDkPedVUXak9ebHxAIXZkvovd5LLaGKw+/9V3pqcZyPeFqF1ic6jJ1ZDnot/iGIUc4JNKFe8jY3N8freh6Ouf1jwYRv2+KTBgY8DDWK/v30TXGmAUaPlfF/9y7McjYQ3UrCTvgwckX79lEA7ldq4LXc/xasnCvPIo9OFvyvluceoKfHzELVcsNbj2aHTVeSAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ao8T15xZzho2DcWjwG9tTAowPzCU4Le04njMiE5ZcEY=;
 b=ooqelc5igLSkTKYhNELPoMi2RSyKkxaZv2g+fOZAHDg+KbY0M6w9NIJ5rBmT7NqUYYtwN0HE/PWbQteovkIxiC4hL6QO08yCQKjh/1+y+W7e73nBuuq9YdngELhMrty0F6nay0/tHh/qqbpvWXae2P0kteF2xVCPkHOTSWgw3N4bZX5FkNDLYJtpJ+U5Mgd5xjCDezpxUWoAINS/BlmU7O8dUF9gp+3ZBmElsN0s5uTssAyaASVPi9O9GLoK4etPW9KDnrVurE/INaMJBDIaB5XfWaW3oUGi21SaLurr/avaD4TDk9m51DKWCS1G3xueFIer7ttq/WMtZiVLG08wqg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BN0PR02MB8079.namprd02.prod.outlook.com (2603:10b6:408:16d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Mon, 9 Mar
 2026 05:50:03 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.20.9678.023; Mon, 9 Mar 2026
 05:50:03 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC: Shaju Abraham <shaju.abraham@nutanix.com>, Jon Kohler <jon@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        "marcel.apfelbaum@gmail.com"
	<marcel.apfelbaum@gmail.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>,
        "eduardo@habkost.net" <eduardo@habkost.net>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 0/1] target/i386/kvm: Configure proper KVM SEOIB
 behavior
Thread-Topic: [RFC PATCH v2 0/1] target/i386/kvm: Configure proper KVM SEOIB
 behavior
Thread-Index: AQHcr4eRycrH35elTkivCISxd/xcP7WlsgqA
Date: Mon, 9 Mar 2026 05:50:03 +0000
Message-ID: <5FFC4697-CB66-4784-AD7D-B29329DC5EBC@nutanix.com>
References: <20260309054243.440453-1-khushit.shah@nutanix.com>
In-Reply-To: <20260309054243.440453-1-khushit.shah@nutanix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|BN0PR02MB8079:EE_
x-ms-office365-filtering-correlation-id: 44eb4c7e-c2ba-4e4b-082e-08de7d9fb5b7
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 UZ839tIPVv79YyqeA/4eou3Jd+SEPh7xzwA/GQgA1emgaRpqburTjbotHOuO6bDasReiPjwwY0fwC8nsuD44xN1lDcLJi57MncvrItB9r1ABtmw3KIBRhfEsOc6Mmw4Y0P6DuO1egD+vcERpBOyMUQ0MhJegX90wRix7zMW012dmvZqgr6tePT7UuxZ5hQlchtpofb02VtY5kN4or6FuC4uy2dfSWEfeOUzzV3J48DuJ8qrTL8pXveP8YLZnxfu4FlfXsEgaP3QJcwx0GJDwWMTQ7jiHVQaA1eO9WOd16XIuKlUIVyXVxhMfGTbsUzpS82K9yutKPw6YpZ32oVw0cGi4/j6dIQHM6Xtrxzg8G6d3qrdUImfGApC6upsdk351/93uhol6AEapFuP0VbOoU4QB+h2/U9i9DkHtLVEMoDJhT+ES5AFOgTqRaWQSJXWd4aNG2pkdsgPVJG4m3kZTABO14FWYxsdelbQNO6M0gP4CjOIvxwZTA7r4780GnYoN6P4oOEjfW+/jzOsI9f8NXOOKO68PYNvbUkTZJ52YD3WoyxiSmYXLAi01i38pXlY67YIjRPY2pa/C1wo4WY3KwYmW0M3kNZykfXls7jA2WsPLUv5WPAXn7tOxV4X06wyYhJTvh7eqxtCasPP34FTGLojPk/tBsIv6TeVYZCGD7n789XpjzpPKs+fgQX1Lap4iGfDHwTRKhThC8JDf3nZXjtwLD8R4PGhZWDBsV1fvrf6TvFKhjADMyMuzAC6ff8D5ro4lghn1SRmQ5zGULvZ0RbHWpYOrH11lqhdF7wN9XUk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RUU5dXZleGVwdkxOVDRxZ092MmMxanVsZ3QwV2QvQmxpWmF0UVE4a1BseHBu?=
 =?utf-8?B?U0ZibzFGTVhTbmZ6ZitFSkRiQytDQjVReU9OcnhKaHhLN01CakR5REVPa0JM?=
 =?utf-8?B?S1loMXJzUUwvOHU2bHU1MWQzL1I0Njc5czUreHNzdkZaTXF6OVoyYTl4TW1w?=
 =?utf-8?B?dnFEYzFDQVJONmdLOW1JZ1ZKajk3NVhYYW83OEx3dUZvdDd6THVqYVdEaUhu?=
 =?utf-8?B?UEc5cUNOYTlJa1VvWExiRTdFcE9GNExHTU5GOWFFaTN5b3dNV2ZGVDVabWgz?=
 =?utf-8?B?YWlYY2N4TktNZDVrMWZLNmc0V0p1c1JRZk16clUyRng4b085bDNaWitqZmh0?=
 =?utf-8?B?Z2dJaEhLZ1V5MUlQNlFaL1N3OWZwOHZUQVZtS1JoR3J4dk4vYnNUSFovbUlw?=
 =?utf-8?B?WHNWaUlVRjBvZE13SVhiWThyd3VhcFpTSTRvRG9STUpGS2E2ZkswT2hwRVND?=
 =?utf-8?B?V1M5WU54ZW5jN1FTNnlBMDVST3ZyNmFWZ0NxeEFCK1lwdHRqRSsvQ0x0aEtp?=
 =?utf-8?B?VG5TeWxOUkVOUnJYTGF6K2JVUWtmK3F0YlVmYVhoUUtTLzl0TEFVMC80ME5I?=
 =?utf-8?B?dVlzVzQvVkJJQXFXQmN0anNxbnNsbTh2YUhJMnRqaGx3Vjg4RnVBb29RbFpT?=
 =?utf-8?B?bkh5cmQrdmR4dThtQklCZmtSbm05eXVpVi9aSGVzRlcycnA1V1BQNmFuclZ6?=
 =?utf-8?B?Qkg1OElzQVoxdDQwa1pKMnFRckFiL0RkOTRqQzFuSFI3bmlNbmEyYVc2VmU5?=
 =?utf-8?B?QzNVVUtpUzdCbkZnQVJlS0VuTTAvbXpnMGJMbWY2eURPT3ZSYWNaM1hlNFFV?=
 =?utf-8?B?aDhRWW5hZzhNdXpoSlVZekkzZlQvMkJPTmZTdENyMmMwblV5ckY1QTk1RWs4?=
 =?utf-8?B?OE9YT3Rrb2ZBbHcweE4zdDhkSkpiK2QzdVZweng1OWRpMlFyaWZvdVRPYzZq?=
 =?utf-8?B?WnIwQkVlUnFxUm5zOFI5c0k0MTVPUk9mZENtR1RYQVZrMGUyUGNzeW9iRGxx?=
 =?utf-8?B?N29IRGFwelU1cGJ2UVJFVVIxMEpjMllVbStIWVNPL09SaDYySTRON3MyeEpD?=
 =?utf-8?B?SDkzMDZDNDRiRVd0T0Nic2JiTmJ1cUNQeVpVSXhUa0hzenZXRDdGWndoNEFm?=
 =?utf-8?B?Sk9xWURxczlQMURndkw4WEtmcG1tQ0tBSXRrUlRTS1lpYnVLQUxBZmFtd1Fu?=
 =?utf-8?B?MlRlTVowbWtYbEVXVXE3dFVjMURUV3U2b3dJYkdla1BYTk81UnNvY016QU1J?=
 =?utf-8?B?QWJrUTRncml0ekNtTERiOVVvSjQ1RVpLcTl1TU1BL0hrbGtJTVlhSGh2MC9z?=
 =?utf-8?B?UEpZdWJVdWgwSStoTlpQbEN0TzFibzVlcEJ0d3VMdE5VQW8yMWJkQkpvZGx6?=
 =?utf-8?B?c2daZUJ3L1ZnbEFGVTNsOGtLcHI1Vm1ORGgwNHJINEthdFozUzQwcUlzeTdt?=
 =?utf-8?B?TE1KYW9BYjhhcnZULzhTZG90NkxjN1hSZ1dSNy85RDJPRFJDaDloWlFNcjdO?=
 =?utf-8?B?ODVrKzZvYllmcU9RL3d2SXFxTGJsNWUxRVdFUXh6UzZjMmV5bFJ4NDFSdVlj?=
 =?utf-8?B?T01TUTNLVVdEMk5CNmtPWDdPVnVqR0gvT0tqcHBQVnZndExsYnFlSnVaRlh6?=
 =?utf-8?B?aC9xZVBKTGExNVdDWjV1OXJNOFcrRjE0OVFqNG9aMEd0L2ZHNTlHaUlmYVpz?=
 =?utf-8?B?WThSLzZaVlIxejZFRUVHWDZNWGg5UGdBb1lJNEpOMWgvUDZnY0hFZFNxaEtJ?=
 =?utf-8?B?N1dWYWVubm4zcDkybHpiZTlySHFyTGl6SUdKSXdxbnZEbWx0TVljY1Y2d0Zw?=
 =?utf-8?B?U1d6OHdQNHUrTjNmZ0d2ZTVtakl4YW5jV0IrZWxwUVpZNnMwQlMzZGZoOVE0?=
 =?utf-8?B?a2JQR3pibVJDOTFYWTljT3VPc0RuamNvK3hvMGJuVSt2dEhRRGRQSU85L1hy?=
 =?utf-8?B?UkZzdDBYYnczdm5TYmhwN3hOc2pCQWhwY3Qxd0MzZ1RCbi9HUk83SVpycUU4?=
 =?utf-8?B?ZDcwVG9wNUVFa1UyZ2VqODcwWUFoYUVUdXF1N1ROaVEvRTY0TnI3eXRuby9a?=
 =?utf-8?B?VmtCRXByKzRVb1Q5THpoQXRpYjhpSHpjQUdtWDl2OGhucGc2WklSY1ZQeUZw?=
 =?utf-8?B?WStNaTBraU43NS9VeDRtUDhPemJrT3d5MHdtNlhpZDgxT2N1TkZybkJNMVVi?=
 =?utf-8?B?M1dpVFFBb09tZEI3NXUvUWlVenJOUjF6RXJJR3dDWm9aQnJ3TWpqS3dIYm04?=
 =?utf-8?B?SEFBdlZqZThYNVhWZmtEaDhwS2doWDJJRGdMN21IbHh1M01lNzNoclVERlRH?=
 =?utf-8?B?c1JxOWJsQUVqUWhreVdndGdINEJzZ1pKUlVoZkQyUVR5N0dOR2kvR2s0Uzkr?=
 =?utf-8?Q?8g+OE07LAydWObiA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C197613ACDE5E428FF1183A45CA2A08@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	UlX3klNE1tX4IYe+MgTpyesVRmO6q+avHUoQ6T3rVdutiopRqHlcZiAHGcs2FYnuRufGXEv5CgVt5u/TiinmbpOqMVMItaxy8aI9ZqOPVv5IRUYrASEV/r1xclhXMScySPbovpADgWmpXCexACQwRXeHvMkl7bD1bWIWKbaJerLXoey/WGgiox0EMlTv6uT3uZGWEhTQN7WVzJ1sjDceMQIDrpZ7AagcYIKuA00YqVZz5ef4APEVjGPPbfvVH9QGye5QC8K9Bt1kkCoKumwHt8bPR9s+GuI1mcoRvjryANOScjwyVFZfq0YmjlE400t8E+i1tQasT/klqM2taqkS3w==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44eb4c7e-c2ba-4e4b-082e-08de7d9fb5b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2026 05:50:03.4630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GfBgSO1DhPtSqnQXViQCwbOFXWKGLzaN1H8K95OYe0WRzbNZIQQV++B9Py8nkPx3M5bxNlR6dd1TQGs0aK8RkHVcr4E14WEXHiuXVy19QVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB8079
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDA1MiBTYWx0ZWRfXzdfbjnvatqyx
 0ccKBUQtcNirr0RO+OzUUcP8t8zkfCaFQ7DuvBmaeOtlx0qr+t3bUMETprFd+AmqIoA+C9rMLeT
 /5/f/PCQJYQv0X03ZrB+JXk931PsISWpP1aonZxwIJq5d5asL5tkoysCh780PiR/RDbpHRIMCTC
 YrD1BG/BEWxK9TbSTgpVt0B6YIC/4zqXJ2nKlLJw2E+AXPBZZSQSAGiQecK6zCEmZ4GfD/D+5pj
 z0J9xotr/kdwOy3Ax6Rb5xLmJWPMcKsjej42J9TZ+BoWHNKJxUVqPlEON0qYnqxAwsKwlO7nsm8
 PvOHtMZ9MF+sPouavXGuFG/AcfNrBtrmUZMOHOOsjlML3cIsCGrtSiOw3Rtpvel6kcuybtH2wp+
 Bv9X8YcoFHqpihVleToVah8lBabw5pY9uwihZqY/ApfHK5Oh2ul3TNjawleIWMF5TDtKukgg0NR
 BYythe5fQ539me2YASg==
X-Authority-Analysis: v=2.4 cv=LLZrgZW9 c=1 sm=1 tr=0 ts=69ae5f8e cx=c_pps
 a=39fn0iQLwZAYlIgUf1ob7A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=64Cc0HZtAAAA:8
 a=lSTngBmy4_b3mwNFk4wA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: eWsou-Gf7gFydXUnND_2ikdvcJdjvFN3
X-Proofpoint-ORIG-GUID: eWsou-Gf7gFydXUnND_2ikdvcJdjvFN3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_02,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe
X-Rspamd-Queue-Id: 88A54233FDF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.44 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nutanix.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[nutanix.com:s=proofpoint20171006,nutanix.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[nutanix.com,gmail.com,redhat.com,linaro.org,habkost.net,vger.kernel.org];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73256-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,nutanix.com:dkim,nutanix.com:email,nutanix.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FROM_NEQ_ENVFROM(0.00)[khushit.shah@nutanix.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[nutanix.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

DQoNCj4gT24gOSBNYXIgMjAyNiwgYXQgMTE6MTLigK9BTSwgS2h1c2hpdCBTaGFoIDxraHVzaGl0
LnNoYWhAbnV0YW5peC5jb20+IHdyb3RlOg0KPiANCj4gVGhpcyBpcyBhbiBSRkMgcG9zdGVkIGZv
ciBkZXNpZ24gZmVlZGJhY2sgcmF0aGVyIHRoYW4gbWVyZ2UuDQo+IA0KPiBQcm9ibGVtDQo+IC0t
LS0tLS0NCj4gDQo+IEluIHNwbGl0LWlycWNoaXAgbW9kZSwgS1ZNIHVuY29uZGl0aW9uYWxseSBh
ZHZlcnRpc2VzIHgyQVBJQyBTdXBwcmVzcyBFT0kNCj4gQnJvYWRjYXN0IChTRU9JQikgc3VwcG9y
dCB0byB0aGUgZ3Vlc3QuIFRoaXMgaXMgd3JvbmcgaW4gdHdvIHdheXM6DQo+IA0KPiAgLSBJT0FQ
SUMgdjB4MTEgaGFzIG5vIEVPSSByZWdpc3Rlciwgc28gYWR2ZXJ0aXNpbmcgU0VPSUIgaXMgaW5j
b3JyZWN0Lg0KPiAgLSBFdmVuIHdpdGggSU9BUElDIHYweDIwLCBLVk0gaWdub3JlcyB0aGUgZ3Vl
c3QncyBzdXBwcmVzc2lvbiByZXF1ZXN0DQo+ICAgIGFuZCBjb250aW51ZXMgdG8gYnJvYWRjYXN0
IExBUElDIEVPSXMgdG8gdGhlIHVzZXJzcGFjZSBJT0FQSUMuDQo+IA0KPiBUaGlzIGNhbiBjYXVz
ZSBpbnRlcnJ1cHQgc3Rvcm1zIGluIGd1ZXN0cyB0aGF0IHJlbHkgb24gRGlyZWN0ZWQgRU9JDQo+
IHNlbWFudGljcyAoZS5nLiBXaW5kb3dzIHdpdGggQ3JlZGVudGlhbCBHdWFyZCwgd2hpY2ggaGFu
Z3MgZHVyaW5nIGJvb3QpLg0KPiANCj4gS1ZNIGZpeA0KPiAtLS0tLS0tDQo+IA0KPiBLVk0gbm93
IGV4cG9zZXMgdHdvIG5ldyB4MkFQSUMgQVBJIGZsYWdzIHRvIGdpdmUgdXNlcnNwYWNlIGNvbnRy
b2w6DQo+IA0KPiAgLSBLVk1fWDJBUElDX0VOQUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUDQo+
ICAtIEtWTV9YMkFQSUNfRElTQUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUDQo+IA0KPiBUaGlz
IHBhdGNoDQo+IC0tLS0tLS0tLS0NCj4gDQo+IFRoaXMgcGF0Y2ggd2lyZXMgdGhvc2UgZmxhZ3Mg
aW50byBRRU1VIHZpYSBhIG1hY2hpbmUtbGV2ZWwgZmllbGQNCj4gKGt2bV9sYXBpY19zZW9pYl9z
dGF0ZSkgd2l0aCB0aHJlZSBwb2xpY3kgc3RhdGVzOg0KPiANCj4gIC0gU0VPSUJfU1RBVEVfUVVJ
UktFRCAoZGVmYXVsdCk6IGxlZ2FjeSBiZWhhdmlvciwgbm8gZmxhZ3Mgc2V0DQo+ICAtIFNFT0lC
X1NUQVRFX1JFU1BFQ1RFRDogYWR2ZXJ0aXNlIFNFT0lCIGFuZCBob25vciBndWVzdCBzdXBwcmVz
c2lvbg0KPiAgLSBTRU9JQl9TVEFURV9OT1RfQURWRVJUSVNFRDogaGlkZSBTRU9JQiBmcm9tIGd1
ZXN0IChmb3IgSU9BUElDIHYweDExKQ0KPiANCj4gVGhlIGN1cnJlbnQgaW1wbGVtZW50YXRpb24g
YXV0b21hdGljYWxseSBzZWxlY3RzIGEgcG9saWN5IGJhc2VkIG9uIElPQVBJQw0KPiB2ZXJzaW9u
IGF0IFZNIHBvd2VyLW9uIHRpbWUsIGFuZCBtaWdyYXRlcyB0aGUgc3RhdGUgYXMgYSBWTVN0YXRl
IHN1YnNlY3Rpb24uDQo+IA0KPiBEZXNpZ24gY2hhbGxlbmdlcw0KPiAtLS0tLS0tLS0tLS0tLS0t
LQ0KPiANCj4gVGhlIEtWTSB4MkFQSUMgQVBJIGlzIG9uZS13YXk6IG9uY2UgYSBmbGFnIGlzIHNl
dCwgaXQgY2Fubm90IGJlIHJldmVydGVkDQo+IGJhY2sgdG8gdGhlIHF1aXJrZWQgc3RhdGUgKGNv
bnNpc3RlbnQgd2l0aCBvdGhlciB4MkFQSUMgQVBJIGZsYWdzKS4gVGhpcw0KPiBoYXMgc2V2ZXJh
bCBpbXBsaWNhdGlvbnM6DQo+IA0KPiAgLSBEdXJpbmcgaW5jb21pbmcgbWlncmF0aW9uLCB3ZSBt
dXN0IGRlZmVyIHNldHRpbmcgdGhlIGZsYWdzIHVudGlsIGFmdGVyDQo+ICAgIHRoZSBTRU9JQiBz
dGF0ZSBpcyBsb2FkZWQgZnJvbSB0aGUgbWlncmF0aW9uIHN0cmVhbSwgc2luY2Ugd2UgY2Fubm90
DQo+ICAgIGtub3cgdGhlIHNvdXJjZSBWTSdzIHBvbGljeSBpbiBhZHZhbmNlLg0KPiANCj4gIC0g
U25hcHNob3QgcmVzdG9yZSAobG9hZHZtKSBpcyBwcm9ibGVtYXRpYzogaWYgdGhlIHJ1bm5pbmcg
Vk0gaGFzIGFscmVhZHkNCj4gICAgc2V0IGVuYWJsZWQvZGlzYWJsZWQsIHJlc3RvcmluZyBhIFFV
SVJLRUQgc25hcHNob3QgY2Fubm90IHJldmVydCB0aGUNCj4gICAgS1ZNIHN0YXRlLiBRTVAvSE1Q
IGxvYWR2bSBtYWtlcyB0aGlzIHdvcnNlIHNpbmNlIGl0IGNhbm5vdCBiZSBkZXRlY3RlZA0KPiAg
ICBhdCBpbml0IHRpbWUuDQo+IA0KPiAgLSBUaGUgZmxhZ3Mgb25seSB0YWtlIGVmZmVjdCB3aGVu
IGt2bV9hcGljX3NldF92ZXJzaW9uKCkgaXMgY2FsbGVkIGluc2lkZQ0KPiAgICBLVk0sIHdoaWNo
IGhhcHBlbnMgZnJvbSBsaW1pdGVkIHBhdGhzIHN1Y2ggYXMgSU9BUElDIGluaXRpYWxpemF0aW9u
IG9yDQo+ICAgIEFQSUMgc3RhdGUgc2V0dGluZy4gVGhpcyByZXF1aXJlcyBzZXR0aW5nIHRoZSBm
bGFncyBiZWZvcmUgSU9BUElDIGlzDQo+ICAgIGluaXRpYWxpemVkLCBuZWNlc3NpdGF0aW5nIGZl
dGNoaW5nIHRoZSBJT0FQSUMgdmVyc2lvbiBmcm9tIGdsb2JhbA0KPiAgICBwcm9wZXJ0aWVzIHJh
dGhlciB0aGFuIGZyb20gdGhlIGluaXRpYWxpemVkIGRldmljZS4NCj4gDQo+ICAtIEF1dG9tYXRp
YyBwb2xpY3kgc2VsZWN0aW9uIChjdXJyZW50IGFwcHJvYWNoKSBjaGFuZ2VzIGJlaGF2aW9yIGZv
cg0KPiAgICBleGlzdGluZyBtYWNoaW5lIHR5cGVzIHdpdGhvdXQgdXNlciBvcHQtaW4sIGJyZWFr
aW5nIG1pZ3JhdGFiaWxpdHkNCj4gICAgZnJvbSBhIG5ldyBRRU1VIHRvIGFuIG9sZGVyIFFFTVUg
Zm9yIHRoZSBzYW1lIG1hY2hpbmUgdHlwZS4NCj4gDQo+ICAtIE1hY2hpbmUtdHlwZSBnYXRpbmcg
KHJlc3RyaWN0IHRvIDEwLjIrKSBoZWxwcyB3aXRoIG9sZGVyIG1hY2hpbmUgdHlwZXMsDQo+ICAg
IGJ1dCBzdGlsbCBicmVha3MgbWlncmF0aW9uIHRvIGEgZGVzdGluYXRpb24gd2l0aCBhbiBvbGRl
ciBrZXJuZWwgdGhhdA0KPiAgICBsYWNrcyB0aGUgU0VPSUIgQVBJLCBhZ2FpbiB3aXRob3V0IHVz
ZXIgb3B0LWluLg0KPiANCj4gUHJlZmVycmVkIGRpcmVjdGlvbg0KPiAtLS0tLS0tLS0tLS0tLS0t
LS0tDQo+IA0KPiBHaXZlbiB0aGUgYWJvdmUsIEkgYW0gbGVhbmluZyB0b3dhcmQgYSBLVk0gYWNj
ZWxlcmF0b3IgcHJvcGVydHkgKGZvcg0KPiBleGFtcGxlLCBgc2VvaWItcG9saWN5PXJlc3BlY3Rl
ZHxub3QtYWR2ZXJ0aXNlZHxxdWlya2VkYCkgd2l0aCB0aGUgZGVmYXVsdA0KPiBiZWluZyBxdWly
a2VkLg0KPiANCj4gVGhpcyBhcHByb2FjaDoNCj4gDQo+ICAtIFRoZSB1c2VyIGV4cGxpY2l0bHkg
b3B0cyBpbi4gQnV0IHJlcXVpcmVzIHVzZXIgdG8gdW5kZXJzdGFuZC9jb25maWd1cmUNCj4gICAg
dGhlIHByb3BlcnR5Lg0KPiAgLSBXb3JrcyB3aXRoIGFueSBtYWNoaW5lIHR5cGUsIG5vIG1hY2hp
bmUtdHlwZSBnYXRpbmcgbmVlZGVkLg0KPiAgLSBObyBuZWVkIHRvIGZldGNoIHRoZSBJT0FQSUMg
dmVyc2lvbiBmcm9tIGdsb2JhbHMuDQo+IA0KPiANCj4gTm90ZTogVGhlIGN1cnJlbnQgaW1wbGVt
ZW50YXRpb24gYWxzbyBkb2VzIG5vdCBoYW5kbGUgdGhlIFFNUC9ITVANCj4gbG9hZHZtIGNvcm5l
ciBjYXNlcy4gDQo+IA0KPiBJIHdvdWxkIGFwcHJlY2lhdGUgZmVlZGJhY2sgb24gdGhlIHByZWZl
cnJlZCBhcHByb2FjaC4NCj4gDQo+IENoYW5nZXMgaW4gdjI6DQo+IC0gVXBkYXRlIGZsYWdzIGlu
IHBhdGNoIGRlc2NyaXB0aW9uIHRvIG1hdGNoIGtlcm5lbCBuYW1pbmcuDQo+IA0KPiBLaHVzaGl0
IFNoYWggKDEpOg0KPiAgdGFyZ2V0L2kzODYva3ZtOiBDb25maWd1cmUgcHJvcGVyIEtWTSBTRU9J
QiBiZWhhdmlvcg0KPiANCj4gaHcvaTM4Ni94ODYtY29tbW9uLmMgICAgICAgICB8IDk5ICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiBody9pMzg2L3g4Ni5jICAgICAgICAg
ICAgICAgIHwgIDEgKw0KPiBody9pbnRjL2lvYXBpYy5jICAgICAgICAgICAgIHwgIDIgLQ0KPiBp
bmNsdWRlL2h3L2kzODYveDg2LmggICAgICAgIHwgMTIgKysrKysNCj4gaW5jbHVkZS9ody9pbnRj
L2lvYXBpYy5oICAgICB8ICAyICsNCj4gaW5jbHVkZS9zeXN0ZW0vc3lzdGVtLmggICAgICB8ICAx
ICsNCj4gc3lzdGVtL3ZsLmMgICAgICAgICAgICAgICAgICB8ICA1ICsrDQo+IHRhcmdldC9pMzg2
L2t2bS9rdm0uYyAgICAgICAgfCA0MyArKysrKysrKysrKysrKysrDQo+IHRhcmdldC9pMzg2L2t2
bS9rdm1faTM4Ni5oICAgfCAxMiArKysrKw0KPiB0YXJnZXQvaTM4Ni9rdm0vdHJhY2UtZXZlbnRz
IHwgIDQgKysNCj4gMTAgZmlsZXMgY2hhbmdlZCwgMTc5IGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pDQo+IA0KPiAtLSANCj4gMi4zOS4zDQo+IA0KDQpNaXNzZWQgbWFpbnRhaW5lcnMgaW4g
dGhlIGluaXRpYWwgbWFpbCwgZml4ZWQu

