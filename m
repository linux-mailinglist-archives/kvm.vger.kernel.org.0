Return-Path: <kvm+bounces-25214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34B80961A0D
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 00:36:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D44AB22D94
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 22:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2EB81D45F5;
	Tue, 27 Aug 2024 22:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="NURUJXK+"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020107.outbound.protection.outlook.com [52.101.56.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DBE1D0DE4;
	Tue, 27 Aug 2024 22:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724798195; cv=fail; b=qNUJWn2IFwUnrdlqJ+qJGVEIDg1bnGXRFnQGLWNF5n8coehc6vxAjABQgGSF7T0XJucx2MP3hbXa9r3vHQPEfvjO2GoESCKwAUr+gWsNWp1LcB8/Fzv0ONMyemGhZiZzmiSjAPav2prudCZ+gJgVPDeTZwU6K7GdQFZ30Msna5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724798195; c=relaxed/simple;
	bh=p3liCs+ZHfgDJtlYVtoEjy8RlSdvENtrH8VcFtmv71k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=AHEj0FDkJ8uyw7o+oB8neqn3qDYh9/QMoOyb8GY9XXbxYWiEuq44t/CXFRPPqTLNDho9aA+fcuxPiephCuVNySVaFNRaAvst+ZX1imFmzotE29RSkSYovrjU0eqmqLs7uMYGYhbwRwU2zVjhFK3UaCybWi/Jmqaur14g8V69a98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=NURUJXK+; arc=fail smtp.client-ip=52.101.56.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=COLdFO7XBlrbD/IJMEmrXWwuTYw57NN4Bkyou7zxDbW7ngfti4n5a16tty+6pcNnk+xhmV8YejhVG/IIKTQEi8TDOcNzi1I0HksoWguJhEEjbgBzzm+RARiFIcjcGaUsS1tWwt7jsxFm2VOz8Xt/t3pcP5uuFfiVuOcT/lVoCeuwoSQkWhZkhIJ1dZcrvKOwcZoAg/UjD5XPO9Vpo9lf40vx26reV7AQtgYZwc2fub3vpAuRTKDxsUx4H2dZtCEJlUF+p5twwIxCkzND2lA159y6tvzcbHrJB411gH/QxHi/Uito4VxPEG0CovX//PLgcaHBsePTmCKn7mfhy8DLaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6DFA0U7YMiQAae8yKrTN7dbye6wr9o+m2DvUQTmLkNU=;
 b=fqxWoD7tD3XRXwun0scpLYz79uju0BuIOdvgU98qzE1rhbx7Wtg4nAGrs9vjVz8Skz05sTV+ks/ZKzykTViXVthhjG81vBcRnwBJ7lBa6eFUG//p1qKkiAv4JhozDp3KSujm6nCDnueLyNIubfLPD+oLmvPFb2rnvCJOgZfhcN1c0sHzudcfrlsU+ErclPaICrfdjlZ3JCkmVqGn/CWWCBya54cgYUqWsdmraMaUYkDjH0zs/vKo8dCLv8TctoPak+MLqAtPGqhwCQp8q7BSpY3qr5JvO2dvKDE+NQ4BEQp6Tn+ExgBsVUfLvNhtWTVOxmJvVoBOBM46Dvuxofta/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DFA0U7YMiQAae8yKrTN7dbye6wr9o+m2DvUQTmLkNU=;
 b=NURUJXK+5tU7GmudvN5Lw1/QoDom/Cw+FVXuCGPWXIPJKU/d1S41bmYT0eDfkTkMmQ7uCwQFVUf4nWa7tVCH2vEp7dBiw4l3Lg7QDAZusgzGHevif+U1cQlCYX8wgdhvdnDyh3PV4LwEWTyRN2pCmisaBz1r/0MbfsTbMs0LcUQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 MW6PR01MB8415.prod.exchangelabs.com (2603:10b6:303:243::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.24; Tue, 27 Aug 2024 22:36:29 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%6]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 22:36:28 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
 linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, maz@kernel.org, arnd@linaro.org, Alex =?utf-8?Q?B?=
 =?utf-8?Q?enn=C3=A9e?=
 <alex.bennee@linaro.org>
Subject: Re: [PATCH 1/3] ampere/arm64: Add a fixup handler for alignment
 faults in aarch64 code
In-Reply-To: <20240827130829.43632-2-alex.bennee@linaro.org>
References: <20240827130829.43632-1-alex.bennee@linaro.org>
 <20240827130829.43632-2-alex.bennee@linaro.org>
Date: Tue, 27 Aug 2024 14:23:16 -0700
Message-ID: <86frqpk6d7.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR16CA0012.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::25) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|MW6PR01MB8415:EE_
X-MS-Office365-Filtering-Correlation-Id: 44b88599-8f5e-4085-fc14-08dcc6e8b11b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|1800799024|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N3VpREZNWXlHQjBaTmxQdzN3aWhXd0ZQcGFMYVU3ZE52VzJWd0pQTFhiUU9H?=
 =?utf-8?B?T1JUb3hFNEJVQmF3dnBRV1pNY0czclc2WHBkS2Z1Uy9sVW81Q05pZTNidFZV?=
 =?utf-8?B?YXcxenc4aDZxVDRzdW91Wnk5eCsxa2dGSGRVY0J4TTYwemRDc1N6UXNVS2Nx?=
 =?utf-8?B?U3VCZER1N0pGVmQzaFRhVHpwQW5MSURRYWxnWTlqYlJUaWZJY0t6MXFrMmVt?=
 =?utf-8?B?VWUwQks0ajhuRnFPcmRrZWhtbGhaKzdZcDFBdDc5bnBQMEF1WEJnZXA0SEps?=
 =?utf-8?B?a2FPMFhJZzR6bUtrbklCYTF5cW5EZUhvdFZjV3g5QWdiMDk4N2Y5S1FKMzhN?=
 =?utf-8?B?d0V5enB5RDVOVXN0Y0U3ajRScnhSTExBMUVMQkFoVVpCbTFPclI5bUlNM0U3?=
 =?utf-8?B?eU1ST1BYU3hCT25veGovU0g4bytxeDgwcHUrZWp5MGkwZEhHNmVUN1RYR0xM?=
 =?utf-8?B?Q1dWR3R6cXg0QmdEVDBReUFwVmlLRUJOb0ZvSnNDUHVrVEZVdExITTlvN1ZK?=
 =?utf-8?B?Q3pkR3gwUG5DQ3RLV0s2SXRkNVJnSWZzR2g0Ymd2WU9SRXMvakNnQ0xSM09q?=
 =?utf-8?B?NGo3REEwNlcxSHBtanQxR0ZGaTM5UWVBRFBJODE1eEJhNHJkMHhUYWhiMU9W?=
 =?utf-8?B?emZzK1BZZTM5dFllR1Uvcm9kdmRLckdtUDl0c3ZxQ2JOdnRVeSt6ajRvL2Vh?=
 =?utf-8?B?MWc3Umh3VDhYdEQ4YTRWVVpYWG9XUVdPQ1BPYm8xQ2xUVi85dWJWcG9ZK3dz?=
 =?utf-8?B?YzZjNEFTbzZHSlVucFFLNmhvTXF1bmRIUUYxZk93akxLZ3VIZlBncUl2ZndV?=
 =?utf-8?B?V0ltMTF0T0V1OFdFQ3NWRFpWNmJhdkdEU1Zoa1E0TGlZRDVHWG5MWnRCci9G?=
 =?utf-8?B?WHUxdHFFRVNwd0RicWtGZEpjbndYcEdiYWU3Wk4vUDF6OW9tSWtoejVjaFlD?=
 =?utf-8?B?S2Vxd0lFMG1TeVo4MzVGdmhCamNVa0FFMVRuaUZvTi82T25sOWFoMXM4eHZ6?=
 =?utf-8?B?NEg5YW9KNjBGSEpVcGhYLzVVaUo4ZHNxYkJXRStJQTJDby8rdFlYVGRvbE5v?=
 =?utf-8?B?YVlud1h0dkwwYVFxd3EvelpQeENoQkxHMDJBVjN5SGw1RU4rdDJpSlJFYnJq?=
 =?utf-8?B?M1Y4RnBnM0ZVU1FuUjdoZjNXWjFHNkVsNGRWRVNQajdTRCtjaW5tdFllS0dj?=
 =?utf-8?B?d1h0Q0oxT01vRVg1RVoyZ3M2MHFDSEU1K1NyWEQwMHRjamlUdVppdEVMSWM0?=
 =?utf-8?B?SEF1NTVqLzZRN1Z0RytCaGFsMVdvY0dzdlJwVzIxbCszY0FQQkFqMVhteWZU?=
 =?utf-8?B?ZU5vOFRuc0FvSTFJT2ppUlpQZ2pKNWhhU2x2Y0FuRXNkNjI0RnZOdWRMb0xt?=
 =?utf-8?B?NnYzTWxYM244UDVNeDlLRjZNUWMxZHZLd3FQMTgrSy9JUURTS2QzeXdLV3gw?=
 =?utf-8?B?dlJISWZzenhEdTUyb2VoSlBjcHFMazNQbmFnb1JxV0J6UFB6c2t5TGx1UEp1?=
 =?utf-8?B?bDhGeDJ2L1NIYzJaNytFMHRabSszbTRQZm9KVmZ5ZURZOW9aVlpGeldXMHNW?=
 =?utf-8?B?K0tpR0hJc3M1RFhSVGVXcW9JckhwV2dCdVh4NngrOFEwNnI3TjFPUmRhOGtw?=
 =?utf-8?B?cndycW01S3FRYU9zUGRIVytXVWI1QnpoZWMzUUxnenhsckgzN3VHbWlsQ20z?=
 =?utf-8?B?bEhOUWN0UnlTcXp4ZU5rZzYwM0hOZ2lGMlBtQVUwemhBOEs1bmg5bGlYSWw1?=
 =?utf-8?B?T0tiTlhRUmxzbEtvVWV2UHYrQUhKY21nWTJPVDM2K0JEaFl2MjlNOXdhMEEv?=
 =?utf-8?Q?pccoamPbNTa891vhRsGMthRBIi7Wbd5ampM2w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(1800799024)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1libW1MM05jL3VPQWJ1UFlUVGhDMWttUWtkKzdTUjQzMXB4V1VhZEdzRGc5?=
 =?utf-8?B?dHY1bHVQWVFsSzdoTGFkL3dwRVpPUWNhWjlMNkRFNmNtQk9rV2cxcEZiQW5m?=
 =?utf-8?B?Q2pUWXhkbVVjenVrdVVpaFhIM1dOSEkxRWg0ZmFGNExUZmVsWndFbll0Y25D?=
 =?utf-8?B?M2ZnU2JkNHY2U3VrbzJsUGpVKzhvbGEwREl5Z3hxcVNWZVJCczJpUi9wTlE1?=
 =?utf-8?B?T2l3UnR0TlFFdThuaVNCaXNMWGduMnFEWnN5ZHhITlg1NnBqeDI4UGZWZ1Fn?=
 =?utf-8?B?L0ZUcjBLUStSbmRiWEhScHpEMGM4ZnVibFIxWW1jUFVqZDg4N2dQVWphd1JX?=
 =?utf-8?B?enR2VEo5VXlKV1ZxUEZBMzB4YnZwS2hnZHAvRFNhNjl4dzJuRDNvOFBHVUdh?=
 =?utf-8?B?V0lsRHJDdnhtNzdTR25IWDRKUG5FazJ3Z0JscU1ZUXhoblpkL2p1bHdlOGkr?=
 =?utf-8?B?VWcxdmU1UFFNVmpUMDNiY0VVVzN5ZlkrWFI0M0tadWpIMWtrdjJObnpKZjNU?=
 =?utf-8?B?S2xQd2ZkMGtzbjBNWmkydmlPUUJwWWFEVTdnTFpmNWFyUXA4UCtybzcvZmQv?=
 =?utf-8?B?VHdJSVBGNHVia1YwZmdZeGR4aGFZK0QwdGhOcmNWem1reTlGQW5pR0p4Tmkr?=
 =?utf-8?B?K1dpVFAwNXE2WHlrME80eXcwWlA1dU93Rkt3TWZMd3VzREt0RnlMRnZLcFpD?=
 =?utf-8?B?dkdlMVlad09mTS9aM0FtQzBHdkhHM3J1UFFJaldOdVU4SkFDQm1nL0UwQ2Jt?=
 =?utf-8?B?d2swZysvNFNGUjV6YnZJUzlXZy8rVXA0cXhhVlVVN3Z5ZEdHMnJ6ZUZtSjhP?=
 =?utf-8?B?VzRxd0Rmci90Z3Z2ZCtHeWpzb0lXN0c5b1NnNXo4OGZQRGp1YzF2RHl5Sjll?=
 =?utf-8?B?M0liK095eTV3K3JjYW9XVlJVcndPdFh1b0s2TENlQ3BiV3FsL0l3YS8xdU1Q?=
 =?utf-8?B?bjh5bnFNT3FBS3JJQWU3VDZqTXU1dWwxN0FEREtBamRzVjB2cjVaYno1d0ZD?=
 =?utf-8?B?OEVrMEVEMmJ4cFVMTFMzTGpQNjNsSGJBVGJYd2ZwaTNsSmFvZ2F0d2owM0pl?=
 =?utf-8?B?RlB0aGs3Qys3bERIL3BLYXBnOG9ubFFLSGtIYTFLdUh4U0IzSjZnK1JyWGlI?=
 =?utf-8?B?djhSVlp0SHp3OFZBdnlIdTZaN2xmTitYakVzTUlRNC9UclpYUExycWw1Q3ln?=
 =?utf-8?B?R3g4aDFHVklxMUR2ZjQya2pEWlBjdXJROGJ6WWVtSjVNaHkzNFFIQ1VBdHNF?=
 =?utf-8?B?OEhvUzJydno5K3AwRER5NzV0R01jSFNZaWV6cE1WbG9rbUtNUXFoMzBYSG1V?=
 =?utf-8?B?d09Md3BtNHVoMUlYOHRIbjRvVEJycVRtZDhKS1BYelFRLzZOY0VhdkYxb1E4?=
 =?utf-8?B?MHlYcWxNcDcwTzNGWlRRUXdZTk5JL040dFJTR3N3a3BRYVNwbVAwWUJ6N1JG?=
 =?utf-8?B?WCt1M0lPQitMU08rYVNtd1NSR0hoZUE1VzNzUUpsTGNnWUEwVkNPdldvZnIv?=
 =?utf-8?B?cVdQMnNMamdzd29OMWV0M3R1dmFiU0RqVnZUdFdqdklVNitWNk5zNUtjYlBX?=
 =?utf-8?B?cEtpa3FyR0NGeWs1a3RTMlc3ZXBVNU4xVDRvaWVGR1JTNVdwOEgyREs2ZGdB?=
 =?utf-8?B?ZzJuRFl3WlhIWXV0SCtEYWlHTHliaWlHVS9pRnVnZS9xQmJZUDlGTmhEb2Nw?=
 =?utf-8?B?TkVwK1dSaW0rakRERUFJeklXZVRRMTZWaytHSHFWK0pNVXR6TXBzTlFEQ0l2?=
 =?utf-8?B?cEV1QUVuR1RIY2ZkTEQwSlRySE1lOGg5b295V1cwYnRHa1EzRlBRMStsTHlY?=
 =?utf-8?B?d1dOajY4a1RqcGJURVJSRU5MY1g4NS9KYjNEN21xTTM3SWZpVzlNbENpVjVS?=
 =?utf-8?B?SzdGcjdmWjFGU0gxUVY3eU1vc2k0Y1ljNE53RXlBdXRhNVhLWE81aXNleW40?=
 =?utf-8?B?d2tkUVY1eDFlZUlhRVZGZnR4aXd4RitiQkQrTTZ1d2lWQ0RKMkw4MjBKd2tx?=
 =?utf-8?B?bXFvbjNmV3gwWGNOTmhObENBRkQ5YTFnNTk0Mlo1ODl3MThjK0hiM010bnc2?=
 =?utf-8?B?dDI0MlJNeVRQZnV4TjZXaHQ2d1hKbUgzUk82NFhhSEtCSldpUEcveE8xdmRu?=
 =?utf-8?B?VXowSFZKZkpYYXF1QXVOVHhUbWJSRXM5TWo5R0xWMVNSRXhDR1VWOFVhdlVM?=
 =?utf-8?Q?xYRNXAr2fLb9hr0eAj98wxU=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44b88599-8f5e-4085-fc14-08dcc6e8b11b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 22:36:28.7985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4KkOK6ayMQ5jvDiYOSUuB6TJAumh5UA2hamQ08wmMc4G6cJGsqyTg3AkZxBXOUZvAu2rO34JLZWY9AvJb8rVRj0MTP/H2Escz0p/xUkeNaUx0ks3MaiA0wjDLmD7dbmS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR01MB8415

Alex Benn=C3=A9e <alex.bennee@linaro.org> writes:

> From: D Scott Phillips <scott@os.amperecomputing.com>
>
> A later patch will hand out Device memory in some cases to code
> which expects a Normal memory type, as an errata workaround.
> Unaligned accesses to Device memory will fault though, so here we
> add a fixup handler to emulate faulting accesses, at a performance
> penalty.
>
> Many of the instructions in the Loads and Stores group are supported,
> but these groups are not handled here:
>
>  * Advanced SIMD load/store multiple structures
>  * Advanced SIMD load/store multiple structures (post-indexed)
>  * Advanced SIMD load/store single structure
>  * Advanced SIMD load/store single structure (post-indexed)

Hi Alex, I'm keeping my version of these patches here:

https://github.com/AmpereComputing/linux-ampere-altra-erratum-pcie-65

It looks like the difference to the version you've harvested is that
I've since added handling for these load/store types:

Advanced SIMD load/store multiple structure
Advanced SIMD load/store multiple structure (post-indexed)
Advanced SIMD load/store single structure
Advanced SIMD load/store single structure (post-indexed)

I've never sent these patches because in my opinion there's too much
complexity to maintain upstream for this workaround, though now they're
here so we can have that conversation.

Finally, I think a better approach overall would have been to have
device memory mapping in the stage 2 page table, then booting with pkvm
would have this workaround for both the host and guests. I don't think
that approach changes the fact that there's too much complexity here.

