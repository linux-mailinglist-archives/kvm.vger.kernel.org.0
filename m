Return-Path: <kvm+bounces-33240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB8029E7E4B
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 06:21:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7638328487C
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 05:21:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BE2A85626;
	Sat,  7 Dec 2024 05:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rd9ddYYz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933787404E;
	Sat,  7 Dec 2024 05:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733548876; cv=fail; b=h3AGvn3UPdhwk49ysArcbU2Cc/GTPsX3kWRHAuSLTJaNiPN+rXrJKuqadboiA75+tTnLC/+xv/ax7zqHAwwRl8UYv+oNbMeQPK7zee1rewC8ETLm7BjEtjPvbL1WCiokWqqVw4ctdOG0A2IafIPnGXz6KpWGLWfjvg2VNfrXGVo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733548876; c=relaxed/simple;
	bh=A9JFlZBDi26BM1O58Th1Ot/GFzFFawX2ujVM5Eah0hs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hTdXj/Aox7Ljl3CbFyPbockDAKrJIwnCURidAlDh3QCNMwfx/AHwRdeUWApCQXCAEkPgdqAtQovwB7mE/g0XiC+cArvYRFnavwlTCfvRmzEx9TQr25qIvB+EXeD5JKb2s10V8l1t/8Gw9G1Rqcp0ouRhHJGDtfy6K1HLdbXmbe0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rd9ddYYz; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H8nSWmqd7YjSWo9TUXRAhjKfAWqXdCsnsx/rXlLRlcoRp64KY9PCY9ZmcRc1bL4QwGx5DOp+gKtsov+/W81D8/HECTutOr+T7GVsNs/R0p2XpVPl88yzx6jfGntl0urkb/G5H6e+OzTHNGaTX8eVRv0W4ovObYVdsCbD+Ud3CCu3/jVM2RbPy27GbnuYFXvsXpd7eHzIBki9qWxu9beaNkB978UYQvoaW0qDNGzYfqo5E+nYd2A0FzBcu2/hCPV2FdZ/fzCdQg/wG6r2snHqdWvUN4yeZEiezDICk0oEayyFIDL9jcdNAW3kVAS00a1Sn8tZchK7sxXkr2k+ar6qDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZgPdSoCoXbX2yu4uNeSC80Dw85zjcYPZeRXukKuZdBM=;
 b=DjV+eBDXF+fHB6Yeg29jGhMYEZsQwRYlojecz0O1yOlQqCfQcqBAwWsdlsTS70d+WbiYMB5d8ZPw89y2mTPbTsmsNHMD4yJzT44Js0QyapHhQb8WNpQxEG/46S/ewGHvjEXlqfW7is0IG1AQeTrQ7DEb+vzNnmVXpTKTZ/4T5iSAnW1Hez7QGnEQD6bjSGFA3/ShQbnhSgXMqS+qpFOPrSA1il4fG5sOFBnn3sCkEJVenhCLRKnRb/pAOPrPrv37b/E2tP0nahTaEt0/tVK2m8nUhGKchhdh3wY+XwzzCwHdzfgD6UwJp6DYOWD/+PxqCeBpPx57Zte0q+iJ3iNo3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZgPdSoCoXbX2yu4uNeSC80Dw85zjcYPZeRXukKuZdBM=;
 b=rd9ddYYzwOSzHjCyOn03hbmzcJm/rgxNEyj02cnQLUHMUY3jNl10kOCRx0zlyXuGlqSjMRMpoWPSoHnjN0BXY/wHuMHs8/p9YXGOo4krpDCYhPBKK9xFspVg0lGWWW5iOUpAjfzP8gBQafk42T3CHJZF/cYiJuJQMG7olfczgu4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CYYPR12MB8938.namprd12.prod.outlook.com (2603:10b6:930:c7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.20; Sat, 7 Dec
 2024 05:21:11 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%7]) with mapi id 15.20.8207.017; Sat, 7 Dec 2024
 05:21:10 +0000
Message-ID: <5b77d19d-3f34-46d7-b307-738643504cd5@amd.com>
Date: Fri, 6 Dec 2024 23:21:06 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
To: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Peter Gonda <pgonda@google.com>,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au,
 x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <3319bfba-4918-471e-9ddd-c8d08f03e1c4@amd.com>
 <ZwlMojz-z0gBxJfQ@google.com> <1e43dade-3fa7-4668-8fd8-01875ef91c2b@amd.com>
 <Zz5aZlDbKBr6oTMY@google.com> <d3e78d92-29f0-4f56-a1fe-f8131cbc2555@amd.com>
 <d3de477d-c9bc-40b9-b7db-d155e492981a@amd.com> <Zz9mIBdNpJUFpkXv@google.com>
 <cb62940c-b2f7-0f3e-1710-61b92cc375e5@amd.com> <Zz9w67Ajxb-KQFZZ@google.com>
 <7ea2b3e8-56b7-418f-8551-b905bf10fecb@amd.com> <Z1N7ELGfR6eTuO6D@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z1N7ELGfR6eTuO6D@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0047.namprd04.prod.outlook.com
 (2603:10b6:806:120::22) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CYYPR12MB8938:EE_
X-MS-Office365-Filtering-Correlation-Id: 04f076d7-9703-47d5-11d1-08dd167ef5e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0xsNTBGOWdyMnF1djF4WDF4cTBPNkxFV01aYkJwbmVZeVNmbVVKNDN4c2Nw?=
 =?utf-8?B?QjR3R0VVU2ZrQkFvZlBFbXZhd2N2L1k0b0NCMVVjRjk2VFphR2NrMTBIalFI?=
 =?utf-8?B?bzVLT29wZUZ1aDdkRGwrZnpDYVRYeFZtNzZVZ2lFblJ5TXZ5M05WNGtRZ3J2?=
 =?utf-8?B?Tk9ObGZDc3VqMStZaVcwL29iWWc4OE40aG5zYTlXYWIzZFlVOE1XZ0Z2Yk9a?=
 =?utf-8?B?c0NIa0ZYN1FSbTNLRjNOcTBwTWt3RW40Qm9qUGJyQWNlTFhzbHBWUGp0MnlI?=
 =?utf-8?B?RmJkaWhtaHlDWUw0N0JDY2FnNEp0NU9XVUVzdjFrTTFXeW1Db3lJazZrNjNv?=
 =?utf-8?B?WUJ3dGI2RnA5bzA0TUo1Y0dqSzYyUm1ENmsxZ0ZCYkttZzVmM3JRbVJ3djJm?=
 =?utf-8?B?dXBiejVwTnhIMjlUNEUrU0VWSW1WRkZIcXlueEhJV1VZVHdhak9JQi85eU9S?=
 =?utf-8?B?S1luZURtQkJDQWhyM1A1a0lkRTNxNmlwV3ROankzalZBNmJIT0x2WDVIVkJk?=
 =?utf-8?B?VVBaL0lTZUtCakRSU3BvVEZMZmlVRHBQa25wWHRDVFhNbFlwUGNhcHBDRG42?=
 =?utf-8?B?WkgzWEEwblRKdmZOVGVoTHE3VmdvSHU5L0pDenY4eU8vRE9KRjdIdjBNa3hS?=
 =?utf-8?B?czRjR3Fmd0ZmYzUzRldheDFkdFAvR29HTjFRQUFFSVFWNS83S2RPTUVVMXIw?=
 =?utf-8?B?bFI4bjhqQ25ERkpwSVYxWHBkRUl6QWxTZUwwbDUrYlN3ckNrdnpyOWtBb3E4?=
 =?utf-8?B?aENkTHN3ekxFa2VlMklYYUVoSGY5elJwNFRuNk5ycEJUOW5ndk1lRHRtdUJI?=
 =?utf-8?B?S25tMGtBKy9tUnRUOXJNNlBlaGUyZHpoSDhpdjhWOHZZUTZoRFJ5YmJWSGRP?=
 =?utf-8?B?UkRYa09oa2Z3YmR2ZitsQXNxbExEWlZTZWJhNmNPWE8veFJxaHpqTjFieDUr?=
 =?utf-8?B?WWMxRTRKejV4L2xncVBybmVDSmRoeVpLR2RDRW80MmltaFBWTDdxTkxQeHhn?=
 =?utf-8?B?MVNuaTBpeCtFQWt0M2IraVp6L1AyeGRqamZaUG9QTWZhRG1HdTkwL0ZGQW85?=
 =?utf-8?B?dHZiZDZPU0s5YThHUHR0U1BLcklPYlRta0QvM2tyNVlIaHpWR0kyK2diVTZ6?=
 =?utf-8?B?VzJrZU5LWm9zWG1FeU5QSzRvSzFLWmFDVWx0U2tOYUgycGdIcnRGNGRNbFRw?=
 =?utf-8?B?ZFhMaXpNZm1BaFozYldkaUQxOS9SQmlXRmVPZHBqQ2VJUWFFWngzVTI5cHFD?=
 =?utf-8?B?ZVQ1cXY5N0VMQnZQM3FtK3FzMER4NUVYZHRCK3JxK013Q3c0REVUMjA5RHp4?=
 =?utf-8?B?RXdKK1ZTRENBSEtIMWVycVZyRFhsZS85eUhJL0tzMXB1dEkrS2pmM2VwZERt?=
 =?utf-8?B?SXNWcENLMk1lUlFlZFkrZEtHbWZDbVdxU0RCaG5kdWRRZWR1dTZIOHhxbGc1?=
 =?utf-8?B?Z21KanN0M1BpRkpEMnVMWFcva1VNcXZFTHdNZjNLM0NxekNCVWk3T21rQ2ow?=
 =?utf-8?B?SXY3dUVXYzBQd2xYQ2lLeWVTQ09SVEhEcVdMTVg0dm5CTUQ5T1VMVWsvZkJO?=
 =?utf-8?B?UExtS1pSYk83TFJ1aTlvcVpwbStvejVpdW14RURFcjc4NVdZNllzY3ovdEdz?=
 =?utf-8?B?bVFBcWlSSWZtZHRWR0V3K1RQOTY2d0c4K2VnVWlsZGhIWmJ4L3g2WVcyMkNk?=
 =?utf-8?B?cnFxblUrNU9iVGcwRkpiY2o1N2djaGNDM3Q5ZWtHWHlvNDQxcnkzWXVZN2dl?=
 =?utf-8?B?bkdDL2ZwcnRnUW9WRzUxcUFKZDJsNWZxVHlpaWlEOWx2bTNPNXFPaWxyVlFG?=
 =?utf-8?B?bGtYVTEyaDJkK01lMUliQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlNBNHJQZ0NPeDFpdHprU21YMTRyWStheVdEY2NVZDcycXhoZ25od0JFL1Ev?=
 =?utf-8?B?bDhsQXhQejFzZy9MZ3RxT2NSZ1Z2dlZvcFRQMVZUbUpvR1hQWDhCWTBGTzNB?=
 =?utf-8?B?VTFjdllZS2RmS3d4TlJZbEU4YlJFZG1YVSsrSDkrQXk4aFV6TFAwZzZoTk9S?=
 =?utf-8?B?ZWdIK3JSL2JkTEFHQm54UkgycmtKT1FJc0IzdDJYKzFrN1pjcnk5SmplMHA3?=
 =?utf-8?B?bTFWeWtWdklLWEg5Q1dFZ1I4TkpwUGtEbE1QYXNFUlhUMVYza3pHeUVIVG5v?=
 =?utf-8?B?Vis2ZElkSE1iYlRDaFhCSk5GRFUxcDY3aGxxdjlobktSdEVjM2FWcUdoY1Bi?=
 =?utf-8?B?dE5OV3BJVUVIdVVEQjlNMkpaZ1JJZEdzR1JHSVdtUmpqVkdsazZMcmU3SWFv?=
 =?utf-8?B?K3V2V052Q2NxUjJneURuTmlTMjRZdGduc01MR2d4clhFZllGVStYQjhsZE1t?=
 =?utf-8?B?cnZMVmMyVzFwZFhEZGtESHMvUEI5WEpsVVpkNStabkJpS3dhWHl4OW9jS2E5?=
 =?utf-8?B?Slhqa3dxREtDR2h5SmN5RUpvWlN0M2UvY0V0WnlCSUNOQW1Nc2w5NWRoWmdj?=
 =?utf-8?B?djYvaERGRUM4aTg3aTVwSTJuWEtuT0hQc0tCbm1sZ2w5Z3lCaTlNbkxZdURs?=
 =?utf-8?B?M1N6NVNOazZyV0RIVTloclhFdUdtcmwwUTFQb1JMd3p0RFZWUTJ3V1JVNVJr?=
 =?utf-8?B?RWhVU1pkajVlOWhkNU5ZbTBHL0pFYmR1US9TOWNSdGZ4MlVLSURoUjF4cjVR?=
 =?utf-8?B?eUtUZGpzNnFIOVdBZ1FPN084aFBxakJvdTdkM1NESkRFeFlBTWtCRWxOdjJm?=
 =?utf-8?B?TGlSMkswK2ExRjZMZXB1aTdoczNVaFEzMEMrTWdMNHhxam5VQnRBMTZNSFNI?=
 =?utf-8?B?L2ZSUmZ4QjB3czBBRDFzdXhFT2g0ZjdQR0drY2dzMVZheTAweFNmYWlFWkJX?=
 =?utf-8?B?bDErTUdUc3gxRjl4MGNKRkI3dE9hUVdYRFg2b1JlY2d3QjVaT2FoaVV4a3VB?=
 =?utf-8?B?OTcxSW8xVU45SkREeVZudzQ2Y0pmdzdhR2V4TEVXQ3JROWZEZGlQd2lSc1ZI?=
 =?utf-8?B?V2tCc0VxVkFCSFhOLzk2WUYxWk5obDkwbXNPZVd1cHlCc0QyRWQzVkRieTNZ?=
 =?utf-8?B?ZVpYVWJhL28rbklJc1pUUEwrVGg1ZHJDaENwNlBUclQ0VXl4dVlDODA3R0J6?=
 =?utf-8?B?MG9LYm5pNkc0ek90WTRGUUptZll2MzFGd2puN3l2SSt6NW1JM1BvWkluekl3?=
 =?utf-8?B?RFZrTHV5eDd3NS9ZeGZ0UFlrQk9sTDNsSDF3enlCYmRvMytYRjc3cURpZzZr?=
 =?utf-8?B?TCtRQTA3OG44cTd2UnpSUi9iSG54YngxNmpIeUdLMFBwZDljdmxDakNOeWY5?=
 =?utf-8?B?eU5DZS84SFI1MUJPMW05N2xDY3I5ZjVHYmd1SFpheHNWK2JXVnRxUjZucUN4?=
 =?utf-8?B?cHIyTllUSHJUK0F0Z3lmcGNHd0FBSERpVDRxc3piYzY5ZnBXODk0N1FrcGc3?=
 =?utf-8?B?WXBkSGViWHcyTDI3MUY1VGwydzVpZUVIL0kxR05tcktJYzhhMGxmYlN0bzdV?=
 =?utf-8?B?SC9nbXhUUURJMm9LdGN1Yjg4TWJGSDVzT0I0dGN1eGdNeUpIL2FocUNsZkRD?=
 =?utf-8?B?ZlpJWW1teThyZTY0MlBCeHYwOTRiYVNVcHZmeURiTm1GM3g2VHlLQnZwRFR6?=
 =?utf-8?B?c1BEVUlNQUQ5TUN1UTExSDRTRWxyVE02K09VM2I2ZmJPYm5iaThKa2R3RDlv?=
 =?utf-8?B?eWxGcWJBTDZ4a0xlM092QTJIcCtCMDBrQ0Z0SVlUQW1IclFneUhIK0dTVzFm?=
 =?utf-8?B?R0YzNDhyV3E1cE9RZ1I2bkhLRUtLYW9qNVVmOVkyRkQ3Q0VSVjBYaXM4UEFN?=
 =?utf-8?B?VXI1eFhvN2ZYSTFyV3g2bm9wQ3ErNzRkb3MvcTNld3BQaDkya1ZvNS9pRVRX?=
 =?utf-8?B?YWhkU2d1M0lMVXM0YzJ0TjI5U1J0NTdrODRhODFvY2ZxYXplcDJYVUsyTERx?=
 =?utf-8?B?NjU4UWJWY3JWN0hyZ3pab1gwRUJoYldVMFRmUkRvdWRER1VxT0dSVTF3SGJK?=
 =?utf-8?B?QXdEbEJpS2ljeEhlU1BTcnM1cVdZL3Mwc0JTbDl3eDFFQXFyVE4vUkRTN2V3?=
 =?utf-8?Q?DhnmnrW80T/2PmHcGj/Tokk76?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04f076d7-9703-47d5-11d1-08dd167ef5e2
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2024 05:21:10.5129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ctGhUplkZaVQfFahxXDRJ52yfFrf65K0pd7zgudRpA3gfMwn9m+Vf3H3ZRhUWQBUdc1m3jf7EEg0wwq+xjhYoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8938

Hello Sean, 

Please see my responses below:

On 12/6/2024 4:30 PM, Sean Christopherson wrote:
> On Thu, Nov 21, 2024, Ashish Kalra wrote:
>> On 11/21/2024 11:42 AM, Sean Christopherson wrote:
>>> On Thu, Nov 21, 2024, Tom Lendacky wrote:
>>>> On 11/21/24 10:56, Sean Christopherson wrote:
>>>>> On Thu, Nov 21, 2024, Ashish Kalra wrote:
>>>>> Actually, IMO, the behavior of _sev_platform_init_locked() and pretty much all of
>>>>> the APIs that invoke it are flawed, and make all of this way more confusing and
>>>>> convoluted than it needs to be.
>>>>>
>>>>> IIUC, SNP initialization is forced during probe purely because SNP can't be
>>>>> initialized if VMs are running.  But the only in-tree user of SEV-XXX functionality
>>>>> is KVM, and KVM depends on whatever this driver is called.  So forcing SNP
>>>>> initialization because a hypervisor could be running legacy VMs make no sense.
>>>>> Just require KVM to initialize SEV functionality if KVM wants to use SEV+.
>>>>
>>>> When we say legacy VMs, that also means non-SEV VMs. So you can't have any
>>>> VM running within a VMRUN instruction.
>>>
>>> Yeah, I know.  But if KVM initializes the PSP SEV stuff when KVM is loaded, then
>>> KVM can't possibly be running VMs of any kind.
>>>
>>>> Or...
>>>>
>>>>>
>>>>> 	/*
>>>>> 	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
>>>>> 	 * so perform SEV-SNP initialization at probe time.
>>>>> 	 */
>>>>> 	rc = __sev_snp_init_locked(&args->error); 
>>>>>
>>>>> Rather than automatically init SEV+ functionality, can we instead do something
>>>>> like the (half-baked pseudo-patch) below?  I.e. delete all paths that implicitly
>>>>> init the PSP, and force KVM to explicitly initialize the PSP if KVM wants to use
>>>>> SEV+.  Then we can put the CipherText and SNP ASID params in KVM.
>>>>
>>>> ... do you mean at module load time (based on the module parameters)? Or
>>>> when the first SEV VM is run? I would think the latter, as the parameters
>>>> are all true by default. If the latter, that would present a problem of
>>>> having to ensure no VMs are active while performing the SNP_INIT.
>>>
>>> kvm-amd.ko load time.
>>
>> Ok, so kvm module load will init SEV+ if indicated by it's module parameters.
>>
>> But, there are additional concerns here. 
>>
>> SNP will still have to be initialized first, because SNP_INIT will fail if
>> SEV INIT has been done.
>>
>> Additionally, to support SEV firmware hotloading (DLFW_EX), SEV can't be
>> initialized. 
>>
>> So probably, we will have to retain some PSP style SEV+ initialization here,
>> SNP_INIT is always done first and then SEV INIT is skipped if explicitly
>> specified by a module param. This allows SEV firmware hotloading to be
>> supported.
>>
>> But, then with SEV firmware hotload support how do we do SEV INIT without
>> unloading and reloading KVM module ?
> 
> So the above says:
> 
>  SEV_CMD_SNP_INIT{_ES} cannot be executed if SEV_CMD_INIT{_EX} has been executed.
> 
> but the existing comment in _sev_platform_init_locked() says:
> 
> 	/*
> 	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
> 	 * so perform SEV-SNP initialization at probe time.
> 	 */
> 
> Which one is correct?  I don't think it matters in the end, just trying to wrap my
> head around everything.

Here is a summary:

1). SNP_INIT(_EX) cannot be done if SEV INIT has been done, the above comment mentions the same,  
in other words, if SEV INIT has completed successfully then any subsequent SNP_INIT(_EX) will fail.

2). Also if SNP is enabled (SNPEn) system-wide, which is done during early kernel boot, then 
SNP_INIT_EX has to be done before SEV INIT, otherwise SEV INIT will fail. 

SNP is enabled system-wide if SNP support and RMP table support is enabled in BIOS and 
additionally RMP table sanity checks are successful, RMP table is mapped and SNP support is
enabled on the IOMMU.

This also means that if we only want to launch legacy VMs (SEV/SEV-ES), but SNP has been enabled
at early kernel boot then we still need to do SNP_INIT(_EX) before SEV INIT. 

Considering all these, SNP_INIT(_EX) is always attempted before SEV INIT as above.

If SNP is not enabled system-wide (CC_ATTR_HOST_SEV_SNP is not set), then SNP_INIT(_EX) will
be skipped.

If we specify KVM module parameter sev_snp=false, but if SNPEn is set system-wide, we
will still do SNP_INIT(_EX) before SEV INIT to ensure that SEV INIT is successful. 
But do note, in this configuration launching any SNP VMs will fail.

> 
> And IIUC, SEV_CMD_SNP_INIT{_EX} can be executed before firmware hotload, but
> SEV_CMD_INIT{_EX} cannot.  Is that correct?  Because if firmware hotload can't
> be done while SEV VMs are _active_, then that's a very different situation.
> 

Yes, that is true. As per SNP Firmware API specs, SNP DOWNLOAD_FIRMWARE_EX adds support 
for provisional updates and for updates while SNP firmware is in the INIT state.

The SNP firmware may be in any state. SEV must be in the UNINIT state.

>> This can reuse the current support (in KVM) to do SEV INIT implicitly when
>> the first SEV VM is run: sev_guest_init() -> sev_platform_init() 
> 
> I don't love the implicit behavior, but assuming hotloading firmware can't be done
> after SEV_CMD_INIT{_EX}, that does seem like the least awful solution.
> 
> To summarize, if the above assumptions hold:
> 
>  1. Initialize SNP when kvm-amd.ko is loaded.
>  2. Define CipherTextHiding and ASID params kvm-amd.ko.
>  3. Initialize SEV+ at first use.

Yes, the above summary is correct except for (3).

The initial set of patches will initialize SNP and SEV both at kvm-amd.ko module load,
similar to PSP module load/probe time.

For backward compatibility, the PSP module parameter psp_init_on_probe will still be
supported, i believe it is used for INIT_EX support.

I have the base set of patches ready which remove SEV/SNP platform initialization from
PSP module probe time and instead move it to KVM module load time (sev_hardware_setup)
and similarly for platform shutdown.

I will post this patch-set early next week.

On top of this base patch-set we will push the SNP CipherTextHiding support and SEV
firmware hotloading support. The SEV firmware hotloading support will add support
for (3) above.

> 
> Just to triple check: that will allow firmware hotloading even if kvm-amd.ko is
> built-in, correct?  I.e. doesn't requires deferring kvm-amd.ko load until after
> firmware hotloading.

Yes, this should work, for supporting firmware hotloading, the PSP driver's
psp_init_on_probe parameter will need to be set to false, which will ensure
that SEV INIT is not done during SEV/SNP platform initialization at KVM module
probe time and instead it will be done implicitly at first SEV/SEV-ES VM launch.

Hopefully, this summarizes all the possible configurations for SEV/SNP platform
initialization.

Thanks,
Ashish

