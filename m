Return-Path: <kvm+bounces-68360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 126F1D383F7
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:09:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D5E3D3038CCD
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A47E3590D4;
	Fri, 16 Jan 2026 18:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Zmatgy0S";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Zmatgy0S"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013051.outbound.protection.outlook.com [52.101.72.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61ED2C0282
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768586920; cv=fail; b=k2b6OHr0YhBBHhjDmtUK/+6J4ixbSCvQwcSPqU7QXJnmEyJm3KWt84mYcMU2Ed+iWwhqrjiK/TTGgj3kDSUG27Rr/r/tMVkP34FRd96cDqhFW5j4BC8m+dcMxLNwRHp1FIE3B4AJxxlT89NsIP8N8FCr0vFDrBsNMmnH9a2zCwQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768586920; c=relaxed/simple;
	bh=GgS7LW8vnyYvQBduxY3b48xCRgaN/eR6+Xy68EMFHOo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aUf+Vj5X7SgHPuOWWCgJDzhOJRjCJPG8eFsJn0sJPIF3xI8D+rnoxcqG5Rm7GL/jpA+/H5vtyU+XzwovnIhl3tZ/OkKBivYCRA/dp7R5Vlr8dGu/77SyKSQWlSsvjX7N52n9EEduSkAngKMABiyrjwnBqDBocdmWUSMi220ySLg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Zmatgy0S; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Zmatgy0S; arc=fail smtp.client-ip=52.101.72.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XQ7XhfC5DUgRdY09C8ga73xQaVpveJe6QaDHG16eyPAaDLS6U1ceyzsVKFRBwnUM+JcLfbYORfMyOfWoJEECZqwr6AGbOKDSxRrjAgeqScAv1UbwmOLzjGEa78tYQxZQmzkZQ9Sr90wHLOXKiiMVHtPhClHBHJGgJ9NsIyJXd6amWbpT9QCXXu6k0zicDSHlTeTX6vbi1CvR+Zxwl0qQfUaadyrxXDrjxvk+ZSWyqWutFpKe/C4uRNiyCYwWWqpSVfTUgsiY5f3NmSmMf5Wbzoo3aj5n2bub/ebAPyj+xdTXIbBcxQt+xxQbVQSTusCmYzUpcAaSjsANMlA2VYW2Bg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GgS7LW8vnyYvQBduxY3b48xCRgaN/eR6+Xy68EMFHOo=;
 b=iuaraEltreHMy4RuZ83SZuxIabEYjKKQzhtcqBZjRidO5fDMhs0wlpgCKhYW3Zpn7z585aI12YIA1nq9SXYG8LcKFiZogf+qQLcveSATwKyWFrakN7XYNxuZhHYs+NdAAcvuno0fe/dpl6AusiPB6d4MXrKSDXZ0w0nkOzbTPhJGC4PehuRjdbfXNCv25EE7xNpEtjYavoheGYxn/H41Y4DiRiZLe1gp1VDfI/hb2CpE/bCcw6s1OAvRAX2NOy/rnqIV2r869ScLIJtFlXiioc7cUCnjl1HS0O7yQYhTkca2r4ezreIHVfjF2hTWiN7ChWZwv+uj7mbLdhc2NJeRgQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GgS7LW8vnyYvQBduxY3b48xCRgaN/eR6+Xy68EMFHOo=;
 b=Zmatgy0S6mE1lyUJGZjxqpDAaRALO2Ln/K2BE1zAOLH2Xsk0ClA1MjW/fNhMxuBVmQ2Ktto9DUKiVO7pxq0RCdkBVTRQbnj80ap2gUlUHOWnW6KrQKCyyfij38glanJvvs2HYbXtSClG5dKFjw7/BcUEbc9+8KRP8bD2Aa3PtiQ=
Received: from AS9PR05CA0089.eurprd05.prod.outlook.com (2603:10a6:20b:499::20)
 by GV1PR08MB8500.eurprd08.prod.outlook.com (2603:10a6:150:84::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 18:08:25 +0000
Received: from AMS0EPF00000196.eurprd05.prod.outlook.com
 (2603:10a6:20b:499:cafe::af) by AS9PR05CA0089.outlook.office365.com
 (2603:10a6:20b:499::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.7 via Frontend Transport; Fri,
 16 Jan 2026 18:08:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000196.mail.protection.outlook.com (10.167.16.217) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Fri, 16 Jan 2026 18:08:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vuAjirYdN6Ukn6+mhbI6CmIB+YUxG5EDXyG9a+0hbOFOAAUvCL81J0oR/8jjk+4lzqRUGDrc7wJc3nnlZJ7Ait5b/d7qKvJ+F4McaDQIh/FeCnNv5ivEbPczI4NJjaTTmP6Rokl3tSh+BmvYaqORON+PJWHBkScFJl6I8LxcTctZ46SeKSltSwYxmxDcqAcXgZ6te/mZf+qfizTZ6uQIp8Lh9v5lQV9kulNGoegZyL63QWqsM/lfftQoQg4B9T4SejnjKtGRvcUU8Q1gflHGwUs12Z1iACJlsB7nmBXoAHQ/0/OF0+sbs+UQLU9jAzKzN8xPZ7MZyMqVpkhKZQc3bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GgS7LW8vnyYvQBduxY3b48xCRgaN/eR6+Xy68EMFHOo=;
 b=CZ5WuN5q49jvuCjjOiH/ZzQG0IEITM4fxzT1g5K4hdSSsju9nm+oAevoAT0xWGBlxVnmQbl4hNE6T/W+me7fSO5AHpRBP9OjvpgG+u1CXAyryLkM+r0ltD0MOeambdBU8wruvtKndnToObYzS/EFAS4O9Nx8p5MzCsaka3OEjDG5A6YaLFBzwQajJXp/B57vtdp0VzV5agozeRWcym6I8CJ6HEZTXvKqXZVDuRV7HX1cCHbNt02VFEVOVQ9zo51m7TozmwwfiTr4A7ljC7I2k6JGOhnpNv/kjzbElo8AykE8FhotzEILmPyF/alFIL3OLmiLrkWyebiScQXE4FJSfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GgS7LW8vnyYvQBduxY3b48xCRgaN/eR6+Xy68EMFHOo=;
 b=Zmatgy0S6mE1lyUJGZjxqpDAaRALO2Ln/K2BE1zAOLH2Xsk0ClA1MjW/fNhMxuBVmQ2Ktto9DUKiVO7pxq0RCdkBVTRQbnj80ap2gUlUHOWnW6KrQKCyyfij38glanJvvs2HYbXtSClG5dKFjw7/BcUEbc9+8KRP8bD2Aa3PtiQ=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by GV2PR08MB8076.eurprd08.prod.outlook.com (2603:10a6:150:7a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 18:07:22 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:07:21 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: Andre Przywara <Andre.Przywara@arm.com>, "will@kernel.org"
	<will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Alexandru Elisei <Alexandru.Elisei@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH kvmtool v4 2/7] arm64: Initial nested virt support
Thread-Topic: [PATCH kvmtool v4 2/7] arm64: Initial nested virt support
Thread-Index: AQHcg6rkrBJc7eWgpk+/K6jPXo8bRLVVHpSA
Date: Fri, 16 Jan 2026 18:07:21 +0000
Message-ID: <951a9e78d83d5a0506f5ea12e8063a367f032045.camel@arm.com>
References: <20250924134511.4109935-1-andre.przywara@arm.com>
	 <20250924134511.4109935-3-andre.przywara@arm.com>
In-Reply-To: <20250924134511.4109935-3-andre.przywara@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|GV2PR08MB8076:EE_|AMS0EPF00000196:EE_|GV1PR08MB8500:EE_
X-MS-Office365-Filtering-Correlation-Id: bcbbe767-8c1c-426d-3f86-08de552a3de7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?MGhPSk4raEtmQzdnRS8rZEEvdjc1NTU0dDJxOTNkN2tmRExYZHRtWjlJK0dR?=
 =?utf-8?B?bTkvTTI3WEo0QkE5citWVUtBZlUrSzJjaVkyTkhZMThNRzFTSG1ZK3k0TE5y?=
 =?utf-8?B?SGRwVEt4eklxNVE2YW03YjBScDM4dW5OTUcxSzMvRVJScHFodEFEZ2R3K2Rx?=
 =?utf-8?B?a21wR2pmVUV5TWFLVmFyZWdwdG93LzdkNTJDQ3lmS1VSRHEzYVpGTjlxTVVv?=
 =?utf-8?B?N1BoWWNVbThNellCdDFvOEF0OE5LOUdyQ1JwTmZXZjFIcjREcmlmeVdaaFlD?=
 =?utf-8?B?aDB4Q0xpNmhYbGtSalc0Z0xyTnAzY05pMXdQVW10dXJYNlN5d0tUVWhPaWYx?=
 =?utf-8?B?SFVjWEpXRkgvQnBBQWlCemtMSXlUL3lzU2Z1b0l5M2RmMUlvd281K2VRZE5y?=
 =?utf-8?B?UlRkcGtyZ2J6OUlUU3d0NnFWY1VHSVZzZXBqUG8vck54UGRKR25NNTczYUg0?=
 =?utf-8?B?YlgwZVZMWlIwZFVZczR0Uk1NUWlmUm5hYUdxN1NQWnJKVGlDYk1yNHd4UFA3?=
 =?utf-8?B?TW4wVGFDazJ0OWc4c0c0STRUb3ZqUkZaa3FKQ0h6YlAyZDl3WG5HeENjS3hD?=
 =?utf-8?B?ZEJCWEN4aVpSZ3N6R1YwOWdhSXNEVWJCUHFKeHlqVC8ycFpYTkR4QmtjR05M?=
 =?utf-8?B?RHlaRHdIKzhCd2tkUEZGWnV1Zjk2eVZ5QXVVa3hxUU1kUk96cXEzdS9vbXIw?=
 =?utf-8?B?N0NKWWFTbTNGZ285SWRKa1RYM0xWdjhITS9ETkxKU0VGRTBzekRSTzAvNjVa?=
 =?utf-8?B?VmRpQ3N4R1hoTlhkQnJRRW5RSElLVlg4MUpuWlRReTVxTUNteWpjMllCR0ls?=
 =?utf-8?B?amhLanFhUjFIT0JQMkZmNFJzdUZiclRyaVJoOVlHUTVuZVBnK1JNYmhnbnlk?=
 =?utf-8?B?NDdFc3RWblZEQllGU2hhdVFpM1ZYTjlZZWZ6ZThtODNqMGJjL1NEUGhlQThn?=
 =?utf-8?B?NUg1MEhHc0p3ZGQ0eWYxRmlIbWFKeldwNm9ZV3NPb2gxZjJCZ1JkRXYyMjdM?=
 =?utf-8?B?TzVnUXZYZUt1b1ZYbVg3dUhzY2dtdFoxUEdzQzFDeWxkbjZQSGpIY25TYUJJ?=
 =?utf-8?B?WHFkcCs2bWNMbm12eU5SbVJzaHRHc3ZTKzZQSU5nbDRqb2RnM2ppbjJoQ3Jx?=
 =?utf-8?B?TW1xdE1yaklpL3FnZGxoUUFteXRUQ2IvZmlKNDRZVHR5bDBIS0FZUFVFeEgw?=
 =?utf-8?B?MnhaRDFTYUVPQWhGZkZYb0tIRDkyMkVRS2xTclo2c212a3Q5ZkJqdGZhMWtF?=
 =?utf-8?B?U3k2Z0tlOXFoVWJ4RTFhVGF5QTdzTm55TTY1MVpJV255SDdxZi9xUUs2TCtt?=
 =?utf-8?B?UXFZdlRJQmc5aS91d0JRV2tTL3FOYkdCdzNPZCtrRXlGS0RhbDBxV3JwSVJT?=
 =?utf-8?B?WGZrc0ZqU2ZyUGl2MWlyMy8veEhLTkdhSmNpUWJrM3AzS24vU0U1em9qZUl0?=
 =?utf-8?B?TEIyVS9XNFJXcWRqL3d0VzYvMXhUeXdpcVdEVER1WVNNOCtoNm12RmdzLzB2?=
 =?utf-8?B?bTZGWG5XWlVLNlVpd3dkUnlvZ2VxbUt3S3B2VTEwa1I5Z1F3bUpPeVN3bDVQ?=
 =?utf-8?B?YWVpWU1iUy8vVUNVcHByZ1ZsUzdNTFFuNmtGZlpNSlMyNEVmMEhuV25DWGsw?=
 =?utf-8?B?eVF4RVFZQXFNYVl0YURvMkJXN2cwdlJwQjZQek50dEdSeWJYQTNQSENNT3lW?=
 =?utf-8?B?MTU5TVMzL2duWk96SEZlelErWUNzcWN4bUhDWGJmcVE0SzcxYUJ3MVFjY2RS?=
 =?utf-8?B?UzI5WEhHZ1FIYU80VitlNXFtTjBnM25nNVFHK2R3aHVPUG1FVXl3RWFKYlBY?=
 =?utf-8?B?Y0YyczZndll1Q2tCSWQzZngyRW5QcVdMRnFYY2kzYW85a1UwNEw5NzkrNCts?=
 =?utf-8?B?a1BTeVVhSnFMMTBCb0U1VWRwdjc1Wi9LSU4ySzA2a1VpSWxhRXlSQmZhRE9D?=
 =?utf-8?B?di8wNkV6RmxzL0FQYTdJM2hEMEY2M3Y4dk95Y3FtZ3Q0MDVNS0tmS3gvbVlk?=
 =?utf-8?B?SVhiNVBxZ3pCTllCMDRzZkVPSGNUalBDU3dTMkV3OGp6YUFUVzZ5WUFmaHFN?=
 =?utf-8?B?aWZQZUk4UGlCaXhoT0Z5R0dJOGU5VFhmR2lrL1orVlVXVDc2V2s0a2xJSUlS?=
 =?utf-8?B?NDhlSHZKVDRXalBJVVJ3QjRVNVlWNDB2NGNlTmlzWjh6OVpic2pqQ2ExbVhV?=
 =?utf-8?Q?+EzyEUMr/V6KKwQ9pH/FBkE=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0F17645E4046A47AA639FCAB9A18920@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8076
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000196.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	49477026-0ef9-473c-97cc-08de552a184e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|14060799003|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cjlBL0N3UCs1aTlyV1Y2aisrU28zWDN6akZmL1ZQVy9QVnhQZWg4NXM1TURz?=
 =?utf-8?B?elNPTFkwR3Z5ekViSXFIcUFKR3BnYmxhbDJ1ekF1UU8wdSsvVTFhRUtxZzh5?=
 =?utf-8?B?akNHcFQxOTdNT3FvQ2pHa0trd2dxcTEyaStGWUJ5amU3NlVOSHRKYnFQQWY2?=
 =?utf-8?B?RlhLTVlGRlVEdGxEeS93WTkwbzZEYlRqeE9zTS9PUGlHY2gyRWQvSWVvbFVT?=
 =?utf-8?B?MHR1Uk55YTFpcWppbDFtdjlRSGNrZFBjV2xNMGhzb3V4Q0VnZzBvSUFzL3Ji?=
 =?utf-8?B?a2x6anNiM3AwVC9JbnRKNXgxTU91bGtUYjRkN2k1TXR6T3BUbTZENDJxWU81?=
 =?utf-8?B?N0lqckpEVER2QXMyMm9zRDRnQjlYbUtRc3R0UDFmVWwvbzVoeTlIbzRlczk4?=
 =?utf-8?B?ZUxjZGFOTHk1QitsbzJrTzZjR0J5REFPbWZHR0FuS2xZdjlSOStpb0hvTEor?=
 =?utf-8?B?Q29WcW5wUzBaT1BPTWpvNDRZVmhiZSt3K1pocjVDbWFYTStKRmdCeG5QcEtG?=
 =?utf-8?B?MlFDUm5qNnVESHE2MVBEeW9TVUYwL2JXQWVHUkpYMGd4NnBFdzJOTnY0VENM?=
 =?utf-8?B?MVhQemJHajRnRVc3Yjh2OHJ0WXRsc082ZGhzNHhnM2s5VkNMN3RiSlZrTzdm?=
 =?utf-8?B?WUtGMkV6UGtMSys5RkxoRUFjMW8xUExqSGFYNUxpbisyOXM1UmhsaXdjbFJ0?=
 =?utf-8?B?aHZ4L0dFMHFJWWxkdEIycWh0TGxEQ0lLeE1TaEw1RmhvUjVmSGxJUjRNVnFi?=
 =?utf-8?B?UDRsRUZnbXI4QkEveVJxMnE0eUU4Z0NsQndDWE51V3pJd1lhNVhGN2ZVWGlm?=
 =?utf-8?B?MGgxQUJXeHNRT3RtMlY5TFRKVklnK2VFblE2SG9TL0d2SmltdnZBZnFuMUtK?=
 =?utf-8?B?MmRVQ3d2OXdJcXhkTTJhVm5FY0dkazdTYzM4MmsxaWhnYzE5QzRXZkRCMGJU?=
 =?utf-8?B?S1RTS2UyYndqZWRKS1FzMkVURXNJOVVYT1JOTFM5QmIzWTIvSURZczFUOGp4?=
 =?utf-8?B?Wm1zeFRpNzErWmlnOXEyNUl3bnU1Q1lmaDNoQnpMVXprOTZUakJEdzZ2aE1W?=
 =?utf-8?B?aWozaDZwZXMzSUhpUUgvZ1RDTGpCOS95b1RUaEZCUUNQVSs1TXF1MGVQcTFV?=
 =?utf-8?B?amlTYWtwbFJrWFpibHJvci9EVnM0WTBQR3ZZUDNjVUNvbDZkU05ZL1JyOGtY?=
 =?utf-8?B?dmRiZXJZV1BjNzd1RFVHOVRGWEZUNWJucGxwak04eXBVUVJORlNDUWhzRnY2?=
 =?utf-8?B?dm9rNk9sczZoT0dHTThrU3BEcmVCaityd3Fibk9BODBrRGNEVGFQWmdxM3dS?=
 =?utf-8?B?QmNrcnBMeFFjYlFQNXplUVJtcWloQlRMOE5zZ3F0UVJtemVtYlVxQTZXWDZ3?=
 =?utf-8?B?N2dsTVRROTR6blZZVjI5c1BreFcyRTliWDgrZUpQZHIrZTh2d2Juemx5Ykdp?=
 =?utf-8?B?RWRHQkpLNXB6bFhZNEVnYkppbTE4clJCd0o5YlBHTy9iWm9Vc0NKWnplR1VL?=
 =?utf-8?B?dUxuTVJEMVluYjd1RCthRGdYclgyOXdkajR1Q0JNSGp0OGw4czBHWHY1Mk9Y?=
 =?utf-8?B?ZmVRaVJrSzUxRW03RzVCTHpQWEVaK0NaL0wvMFJFZE1DcWhKOXdtckpPdU1E?=
 =?utf-8?B?L3krTUlsaVpITUlodTBvSVBQaVEvMzZlZmdZWVdkS20zSm5LK0Q5bkczRDNq?=
 =?utf-8?B?RHJna0VkYjduYVpMcDBsbTlNTGhHbXdSREVYa0ZJQk45bDZJUUF4d0lVUUUw?=
 =?utf-8?B?ZnF5VHhIWVJlK0tvbXZMakQ5N2o1dVVmeXNpZGJKU1JZSEw1SURzRmJIM0F6?=
 =?utf-8?B?OHNpNlBwd0h4UmdJdDZFd0N5bDFrUUhKakMrT0p1QUhNK0NVVzdLVnVoRXY2?=
 =?utf-8?B?bGk3eXc4N1gyN2pmYlkxRDdlRDBCRGV6ZkY0TlU0OTJnN09JM08zaXA0SXBV?=
 =?utf-8?B?Y2hTS2p1UWU1TVdGbEE0UnRxMENCcU1OeW03SVVHejhCRGVqUSt2KzlhRTdE?=
 =?utf-8?B?SGd2Mmg2RnNlRDNnK05WdmlCMUM5dE9aU3YwTWVlYm5KM3k2VXpjVVdGUWdD?=
 =?utf-8?B?SmVyVE5GYnlPS1FFc1U2NDNHZzZhMWY3N01RblgxSnIvOGNsTXhWS0VMWUpL?=
 =?utf-8?B?L3VMV2czTG4yOUh6bEFyVzBlZ3JPM3E2S1lMRlBkS2FvNGJPSFpWaEVHVk0r?=
 =?utf-8?B?ajlEQXRQZ1BVQUVGamh6UlorOHN1SGlScTFhZDNSbmIrQmU1SjdMcXFydFlK?=
 =?utf-8?B?aXU0cSt6clcyT2FZeE8vUHhmT3VnPT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(14060799003)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:08:24.7850
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bcbbe767-8c1c-426d-3f86-08de552a3de7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000196.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8500

T24gV2VkLCAyMDI1LTA5LTI0IGF0IDE0OjQ1ICswMTAwLCBBbmRyZSBQcnp5d2FyYSB3cm90ZToN
Cj4gVGhlIEFSTXY4LjMgYXJjaGl0ZWN0dXJlIHVwZGF0ZSBpbmNsdWRlcyBzdXBwb3J0IGZvciBu
ZXN0ZWQNCj4gdmlydHVhbGl6YXRpb24uIEFsbG93IHRoZSB1c2VyIHRvIHNwZWNpZnkgIi0tbmVz
dGVkIiB0byBzdGFydCBhIGd1ZXN0DQo+IGluDQo+ICh2aXJ0dWFsKSBFTDIgaW5zdGVhZCBvZiBF
TDEuDQo+IFRoaXMgd2lsbCBhbHNvIGNoYW5nZSB0aGUgUFNDSSBjb25kdWl0IGZyb20gSFZDIHRv
IFNNQyBpbiB0aGUgZGV2aWNlDQo+IHRyZWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbmRyZSBQ
cnp5d2FyYSA8YW5kcmUucHJ6eXdhcmFAYXJtLmNvbT4NCg0KVGhpcyBsb29rcyBnb29kIHRvIG1l
LCBhbmQgaGFzIGJlZW4gdGVzdGVkIHdpdGggR0lDdjMgZ3Vlc3RzIG9uIEdJQ3Y1DQoiaGFyZHdh
cmUiIChGVlApIGR1cmluZyB0aGUgZGV2ZWxvcG1lbnQgb2ZzdXBwb3J0IGZvciBHSUN2MyBndWVz
dHMgb24NCkdJQ3Y1IGhvc3RzIChGRUFUX0dDSUVfTEVHQUNZKS4NCg0KUmV2aWV3ZWQtYnk6IFNh
c2NoYSBCaXNjaG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQoNClRoYW5rcywNClNhc2No
YQ0KDQo+IC0tLQ0KPiDCoGFybTY0L2ZkdC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA1ICsrKystDQo+IMKgYXJtNjQvaW5jbHVkZS9rdm0va3Zt
LWNvbmZpZy1hcmNoLmggfMKgIDUgKysrKy0NCj4gwqBhcm02NC9rdm0tY3B1LmPCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMTIgKysrKysrKysrKystDQo+IMKgMyBm
aWxlcyBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2FybTY0L2ZkdC5jIGIvYXJtNjQvZmR0LmMNCj4gaW5kZXggZGY3Nzc1ODc2Li45
OGYxZGQ5ZDQgMTAwNjQ0DQo+IC0tLSBhL2FybTY0L2ZkdC5jDQo+ICsrKyBiL2FybTY0L2ZkdC5j
DQo+IEBAIC0yMDUsNyArMjA1LDEwIEBAIHN0YXRpYyBpbnQgc2V0dXBfZmR0KHN0cnVjdCBrdm0g
Kmt2bSkNCj4gwqAJCV9GRFQoZmR0X3Byb3BlcnR5X3N0cmluZyhmZHQsICJjb21wYXRpYmxlIiwN
Cj4gImFybSxwc2NpIikpOw0KPiDCoAkJZm5zID0gJnBzY2lfMF8xX2ZuczsNCj4gwqAJfQ0KPiAt
CV9GRFQoZmR0X3Byb3BlcnR5X3N0cmluZyhmZHQsICJtZXRob2QiLCAiaHZjIikpOw0KPiArCWlm
IChrdm0tPmNmZy5hcmNoLm5lc3RlZF92aXJ0KQ0KPiArCQlfRkRUKGZkdF9wcm9wZXJ0eV9zdHJp
bmcoZmR0LCAibWV0aG9kIiwgInNtYyIpKTsNCj4gKwllbHNlDQo+ICsJCV9GRFQoZmR0X3Byb3Bl
cnR5X3N0cmluZyhmZHQsICJtZXRob2QiLCAiaHZjIikpOw0KPiDCoAlfRkRUKGZkdF9wcm9wZXJ0
eV9jZWxsKGZkdCwgImNwdV9zdXNwZW5kIiwgZm5zLQ0KPiA+Y3B1X3N1c3BlbmQpKTsNCj4gwqAJ
X0ZEVChmZHRfcHJvcGVydHlfY2VsbChmZHQsICJjcHVfb2ZmIiwgZm5zLT5jcHVfb2ZmKSk7DQo+
IMKgCV9GRFQoZmR0X3Byb3BlcnR5X2NlbGwoZmR0LCAiY3B1X29uIiwgZm5zLT5jcHVfb24pKTsN
Cj4gZGlmZiAtLWdpdCBhL2FybTY0L2luY2x1ZGUva3ZtL2t2bS1jb25maWctYXJjaC5oDQo+IGIv
YXJtNjQvaW5jbHVkZS9rdm0va3ZtLWNvbmZpZy1hcmNoLmgNCj4gaW5kZXggZWUwMzFmMDEwLi5h
MWRhYzI4ZTYgMTAwNjQ0DQo+IC0tLSBhL2FybTY0L2luY2x1ZGUva3ZtL2t2bS1jb25maWctYXJj
aC5oDQo+ICsrKyBiL2FybTY0L2luY2x1ZGUva3ZtL2t2bS1jb25maWctYXJjaC5oDQo+IEBAIC0x
MCw2ICsxMCw3IEBAIHN0cnVjdCBrdm1fY29uZmlnX2FyY2ggew0KPiDCoAlib29sCQlhYXJjaDMy
X2d1ZXN0Ow0KPiDCoAlib29sCQloYXNfcG11djM7DQo+IMKgCWJvb2wJCW10ZV9kaXNhYmxlZDsN
Cj4gKwlib29sCQluZXN0ZWRfdmlydDsNCj4gwqAJdTY0CQlrYXNscl9zZWVkOw0KPiDCoAllbnVt
IGlycWNoaXBfdHlwZSBpcnFjaGlwOw0KPiDCoAl1NjQJCWZ3X2FkZHI7DQo+IEBAIC01Nyw2ICs1
OCw4IEBAIGludCBzdmVfdmxfcGFyc2VyKGNvbnN0IHN0cnVjdCBvcHRpb24gKm9wdCwgY29uc3QN
Cj4gY2hhciAqYXJnLCBpbnQgdW5zZXQpOw0KPiDCoAkJwqDCoMKgwqAgIlR5cGUgb2YgaW50ZXJy
dXB0IGNvbnRyb2xsZXIgdG8gZW11bGF0ZSBpbiB0aGUNCj4gZ3Vlc3QiLAlcDQo+IMKgCQnCoMKg
wqDCoCBpcnFjaGlwX3BhcnNlciwNCj4gTlVMTCksCQkJCQlcDQo+IMKgCU9QVF9VNjQoJ1wwJywg
ImZpcm13YXJlLWFkZHJlc3MiLCAmKGNmZyktDQo+ID5md19hZGRyLAkJCVwNCj4gLQkJIkFkZHJl
c3Mgd2hlcmUgZmlybXdhcmUgc2hvdWxkIGJlIGxvYWRlZCIpLA0KPiArCQkiQWRkcmVzcyB3aGVy
ZSBmaXJtd2FyZSBzaG91bGQgYmUNCj4gbG9hZGVkIiksCQkJXA0KPiArCU9QVF9CT09MRUFOKCdc
MCcsICJuZXN0ZWQiLCAmKGNmZyktDQo+ID5uZXN0ZWRfdmlydCwJCQlcDQo+ICsJCcKgwqDCoCAi
U3RhcnQgVkNQVXMgaW4gRUwyIChmb3IgbmVzdGVkIHZpcnQpIiksDQo+IMKgDQo+IMKgI2VuZGlm
IC8qIEFSTV9DT01NT05fX0tWTV9DT05GSUdfQVJDSF9IICovDQo+IGRpZmYgLS1naXQgYS9hcm02
NC9rdm0tY3B1LmMgYi9hcm02NC9rdm0tY3B1LmMNCj4gaW5kZXggOTRjMDhhNGQ3Li40MmRjMTFk
YWQgMTAwNjQ0DQo+IC0tLSBhL2FybTY0L2t2bS1jcHUuYw0KPiArKysgYi9hcm02NC9rdm0tY3B1
LmMNCj4gQEAgLTcxLDYgKzcxLDEyIEBAIHN0YXRpYyB2b2lkIGt2bV9jcHVfX3NlbGVjdF9mZWF0
dXJlcyhzdHJ1Y3Qga3ZtDQo+ICprdm0sIHN0cnVjdCBrdm1fdmNwdV9pbml0ICppbml0DQo+IMKg
CS8qIEVuYWJsZSBTVkUgaWYgYXZhaWxhYmxlICovDQo+IMKgCWlmIChrdm1fX3N1cHBvcnRzX2V4
dGVuc2lvbihrdm0sIEtWTV9DQVBfQVJNX1NWRSkpDQo+IMKgCQlpbml0LT5mZWF0dXJlc1swXSB8
PSAxVUwgPDwgS1ZNX0FSTV9WQ1BVX1NWRTsNCj4gKw0KPiArCWlmIChrdm0tPmNmZy5hcmNoLm5l
c3RlZF92aXJ0KSB7DQo+ICsJCWlmICgha3ZtX19zdXBwb3J0c19leHRlbnNpb24oa3ZtLCBLVk1f
Q0FQX0FSTV9FTDIpKQ0KPiArCQkJZGllKCJFTDIgKG5lc3RlZCB2aXJ0KSBpcyBub3Qgc3VwcG9y
dGVkIik7DQo+ICsJCWluaXQtPmZlYXR1cmVzWzBdIHw9IDFVTCA8PCBLVk1fQVJNX1ZDUFVfSEFT
X0VMMjsNCj4gKwl9DQo+IMKgfQ0KPiDCoA0KPiDCoHN0YXRpYyBpbnQgdmNwdV9jb25maWd1cmVf
c3ZlKHN0cnVjdCBrdm1fY3B1ICp2Y3B1KQ0KPiBAQCAtMzEzLDcgKzMxOSwxMSBAQCBzdGF0aWMg
dm9pZCByZXNldF92Y3B1X2FhcmNoNjQoc3RydWN0IGt2bV9jcHUNCj4gKnZjcHUpDQo+IMKgCXJl
Zy5hZGRyID0gKHU2NCkmZGF0YTsNCj4gwqANCj4gwqAJLyogcHN0YXRlID0gYWxsIGludGVycnVw
dHMgbWFza2VkICovDQo+IC0JZGF0YQk9IFBTUl9EX0JJVCB8IFBTUl9BX0JJVCB8IFBTUl9JX0JJ
VCB8IFBTUl9GX0JJVCB8DQo+IFBTUl9NT0RFX0VMMWg7DQo+ICsJZGF0YQk9IFBTUl9EX0JJVCB8
IFBTUl9BX0JJVCB8IFBTUl9JX0JJVCB8IFBTUl9GX0JJVDsNCj4gKwlpZiAodmNwdS0+a3ZtLT5j
ZmcuYXJjaC5uZXN0ZWRfdmlydCkNCj4gKwkJZGF0YSB8PSBQU1JfTU9ERV9FTDJoOw0KPiArCWVs
c2UNCj4gKwkJZGF0YSB8PSBQU1JfTU9ERV9FTDFoOw0KPiDCoAlyZWcuaWQJPSBBUk02NF9DT1JF
X1JFRyhyZWdzLnBzdGF0ZSk7DQo+IMKgCWlmIChpb2N0bCh2Y3B1LT52Y3B1X2ZkLCBLVk1fU0VU
X09ORV9SRUcsICZyZWcpIDwgMCkNCj4gwqAJCWRpZV9wZXJyb3IoIktWTV9TRVRfT05FX1JFRyBm
YWlsZWQgKHNwc3JbRUwxXSkiKTsNCg0K

