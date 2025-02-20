Return-Path: <kvm+bounces-38781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74440A3E4F9
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 20:22:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A8EA420320
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 19:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164762641CD;
	Thu, 20 Feb 2025 19:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XfOTlS3I"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2050.outbound.protection.outlook.com [40.107.220.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82EF20B1F1;
	Thu, 20 Feb 2025 19:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740079319; cv=fail; b=ph1Jx+F3PQPQyD20lQ4IyiWeT1mPjugUTKZcywj8OfY4MjV7OQhK6IKCv4uOkaS3SsQR8NCWuC9d3BMKaV8DFRD6KzeieF3PM653BhBFDSNKFDyxCjO9ihAxEDY+lfwOGQ2FMirx2Kjr3yVnI+i5I/m0JZ47mnpTsff0tjlOo+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740079319; c=relaxed/simple;
	bh=nCQIwdIOkdQekHH9q9FbXzoJ08qKWEz6eZe5SpdfPuY=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=afp+0mCRIQUTDX1Iz6uev5mjhCMHOqPbN6IdEPouYK7jvcRN0hsdHSoJxp7bHWcVjS9dUlhu0JhEHJRHxqhRNgmn7YJbF19VtJuCVXXAv1t88hSoiZgN0jbMPnY91x8qO8MGW7sCowQp3m1WYQ14QgSiaoeP/UORKbnYtJwZhTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XfOTlS3I; arc=fail smtp.client-ip=40.107.220.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e4uq2Ic9xTjkE8JPUcCgKrwx+CVsHDN1Vp1zFG+cMRFIavXQPToj5NWw6rzdwBsJyJ4WR1JDqg6FkJrUxPiUvuc/Rz2ZWPApoSnxWOlhsl55sBSuxKtW92mdkdCfoIvbgNitCGuiU/zGa2N6MZ94j8E931bwEDNz2J7ut88/T/klnh/jCCHYxJYuZZhyRKI2+SyXF2pM0HvQHkqE/NBJYUOmMEuZm78a4Lyk0Fkpu6fCNSU7SXUoTTWW6Ci7z38ojq3pCfVKxCHuaqKcBcQL1Vn89xu8RfufggUpB0gnGtu9HeLPtwp1eHEF3b2wIXxXIYoul6ria/MTCrTIqLGnNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AXkdUsTPdhi8C2p21/iW5hqFGvgCb6L8eTXmzo7CVJI=;
 b=WK8nolLcXixuvHBOEXuGSiBymeUzQ+tUmBOulxfgi8qgtoksSC6nEBymycAjomACBp9H3DqaVWYDSrKsBa9OIgYKYTc4Yqo0fWXXHYPSjLLwmfR+e86ldDBrPoPLwf0LhsFA41x+6ptFs0qpr2kyzsiZ2QP0xzTxpvsS2Vv93XF3GgrUKW33g2YM9HR6QWiD+J8viz6Epw2kw6Qfg7T9xg92Z5Tl9Tx2OBfjgsMFRmSIZBSDs+yAkvBiuZiKOWUzyq/1LU+69yCW3Jo2+VfsP2nCHcFt2cOHilI/tp466BdP3cwRrNulpZiAeJyuEqfEHKSIRsYF3tNQndUWtJ6fVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXkdUsTPdhi8C2p21/iW5hqFGvgCb6L8eTXmzo7CVJI=;
 b=XfOTlS3I0gBuM8cgWoNuY7cVE53dqAne8F1N+BxcxJAkL9mQIg0qh+09kvMZobI9k+OuPTOq6T+mzGynGAzbtI52bIirdlCWeoydu2ju4xBuhL+tQ/Hy2C/3MVu/MA6nt5DiBsYnGcH5OQxJC8GUfMZxztVRYYslLGXlyqQkXhc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB7972.namprd12.prod.outlook.com (2603:10b6:8:14f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.15; Thu, 20 Feb
 2025 19:21:54 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.016; Thu, 20 Feb 2025
 19:21:53 +0000
Message-ID: <a6f653d2-a75f-44d0-587a-e57fef0164ad@amd.com>
Date: Thu, 20 Feb 2025 13:21:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1739997129.git.ashish.kalra@amd.com>
 <3751510d09c0811811e46e857942bf238aa52d05.1739997129.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v4 5/7] crypto: ccp: Add new SEV/SNP platform shutdown API
In-Reply-To: <3751510d09c0811811e46e857942bf238aa52d05.1739997129.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:806:f2::15) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB7972:EE_
X-MS-Office365-Filtering-Correlation-Id: afd07071-7800-4a54-a2c4-08dd51e3d550
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RDVNNEpmY2JJQUlibmdYWEM4MG9IS1VwcW90dmtyQU1ENFl1YjNodFJYZ2xO?=
 =?utf-8?B?ZzUxOXkvdGhScm00R0lxZ1ZrMWxkNEhVSkdtZW0vd1NFVE5vbk5seTFYRno3?=
 =?utf-8?B?OU9XNEVFS3JHMVB1SHlJVUtvc0VyZ24yQXRMM2dnYkhiOUhKMkE1cmZFK2Fq?=
 =?utf-8?B?OGlHVnNXbkFTVVBkcUpZRmh0dnBRTzdVUzk1akI1aG5hcGtpdG91Vkd3SUlP?=
 =?utf-8?B?Z2RDNmVzUjl6SjJLVW1qeUFyZU5zK25IYlNOeU5HQWxFMytGTTYvWDhINnEx?=
 =?utf-8?B?R1hmNDlJYWtZVVlURjdsdThhTUh3bXhVYXNCbkU1MG0rSlppUUMvZUczVnJR?=
 =?utf-8?B?TEVxSkxTYXdVTUFKYnJmNDNqMnlJaEJXeC9IL0JXejRTMERyN3QzMXhibTFO?=
 =?utf-8?B?V0cxQ0hKQXUwVkFpTkdOVmVoOEswTDhqekZEdEMzN0h2RTJnenlCTG9Bb3dl?=
 =?utf-8?B?V2owOVRHOUcrTEF0UjdGaXZkNGl0VXJ0VEdoYzdzRUJreHJEOGhacGNvSVBN?=
 =?utf-8?B?TjJLWE1JRGRZMjVlMS9TNS9tVXhBTGJvUXBMYXdUL1pWOHBzazlCdXR2dlVS?=
 =?utf-8?B?Rlk2bmYyMlVPajNET1RjSFJ6bVBPVTlET3ZaRWtDN0tSaWxKeGdVbFc5Y1lY?=
 =?utf-8?B?bUExb3lJU2NqTlpMUDNXemNDSC85MVIvUWUvbDQxemNNVFFDeEVyNFphUGp2?=
 =?utf-8?B?UmtPc3A1cVJQSTRSSTB3WVF2Sy9mQ1Fhc1JtLzh3MVllNHIrZXd2ek5YTFUx?=
 =?utf-8?B?dWNyaHpZWlRWSm9ZdlEwREwrSllDQm1QWlRZNUpZZCtCYnd6c253Z29YNlh3?=
 =?utf-8?B?aEdDaklNSS9QdFVETGR3MVJJTkNxS0dQR29yMUR4VWpzTFRzd0NkN2dGZEV2?=
 =?utf-8?B?UXk4TUV1UDZ3TURkbENab0xhWG5IVmtTenF5bjY1bkZieHMvMFkramIvVzVO?=
 =?utf-8?B?aXNEbVlISVJZcW51cnBtZUdwb1o3RHZpVXpBcEQxSUthbFVuZGcvRHNqVElr?=
 =?utf-8?B?WnhZTDlNVWNjTDVLVzJrenVXYVNMdmV6OUdUbzZyZU5LSFcvaUJuUS9zdnNo?=
 =?utf-8?B?MzRSU0gxNVNhMnozUG8xblZneEdlSVpTSC9mNGp4MThoWmRaaU8vNjMzMFYv?=
 =?utf-8?B?OTljNWZrYlN6aHdXdWRtbWNCWitZbUxGT2hmSWRUZEVLN3plTDFHVEw0ejJ6?=
 =?utf-8?B?T25rb0tUT0FEdVh4NzFrSnF4VDdWb0szdzJzSndtREdzR2Zjc3RRbjBDVk1l?=
 =?utf-8?B?T0JGWk54M3dnTjV1UjBtMFpuY3l2Z0NrYVJkb0pFR1Zpc3FvRlExdG1DME0y?=
 =?utf-8?B?MVNiWVV5UEg3b3JYeTAySEI0R1JBV01BVGlxVFRZSElSSlhPL2JCLzhXSXlt?=
 =?utf-8?B?VklZdkpwbTRwaXk1S1FYTUozazZwRXFaMnZ5ZmYxZGpvelVWc1JaS00yMzMz?=
 =?utf-8?B?VUhPdjhqeGN4MnViNVFwTGw4a3NlQVA4U2lYSHdIZFJ1Z2xPYUpSQmxqb1BG?=
 =?utf-8?B?ajV6RVhZZ2xwUEZYazdwV2hMcjN1Z3I4TU95NEtESnVQMzNrMUQ2NXVnVjdk?=
 =?utf-8?B?Znc5cXlTamdoS1RCdFpJZFppc2c5VmxoZCtMRFdIanBkL3QrRGRlQVJTRDhs?=
 =?utf-8?B?dWF3Y2FwZ0hNUjZhOWVVWjIwQjRRaTBLUXFrV3FjS245WUMwemQydzIwekhI?=
 =?utf-8?B?MDh1ZnpxS1VlUUEzcGx0eVdydWFxOWRVZDljM1lxU3BmSllaRUlFR2t1Zlhw?=
 =?utf-8?B?Z3U1YXpiYXhJeU5IRk9yTm5DMzJjZ0lsUXpJazROTjZXNXZ4dTRVMlR5dE8y?=
 =?utf-8?B?REpibUZ3NDVxOFNoY0NVdDRsMWtZeGFXM3R5bzUzWDlWWDArVWZzWmhNTmhV?=
 =?utf-8?B?WjZOZnRpOGxDOWQvVHMwVDIxWDhTamU0SGFXcUg0K21UeUs2VlJJZmZVenRM?=
 =?utf-8?Q?jRqLUiFNDT0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amRtNVJJRm9FdVlFZWtRRTdvZ2pNWmRyeURkVmx3aENTRlowcEZsbjFHdEI3?=
 =?utf-8?B?Uk1BVXJBK0YzNEFvcncyL0JRZmhOSHUyNG5rNTFDZ1BsYlpFdnA1VEFFRmtO?=
 =?utf-8?B?bEMramVlVVU1ZFp6RGlsQ0FYbWVRTkh2SWhBc2l2eEpaRmlhNWRXWjVXUGZ3?=
 =?utf-8?B?TVJ1MXVCc0gwYmtWV3ErMlVIdG1Sc2NKWklWNGhuSjFwTkN6S2ovaDZITVl3?=
 =?utf-8?B?L1pzeVplbFBNMDFLYWdDcDBtTXZBSmtjZFNFQ09aUUlWc2FNd0N4TlhPcDJJ?=
 =?utf-8?B?aWkyeXRyYXB1cTlCMVNMd2dHTmZ2U1lyWlRaVW5ndW5Wd080UkR5WGJOMlVj?=
 =?utf-8?B?MS9UVVcrY1RtSzJ6ZXViUTAvMGhqQk5yS25lcm5vK1pRVHRZcEJndkRDMEJT?=
 =?utf-8?B?U1o0SWNYMEkvbThvdlhkSCtWeWVNb2FzM29OSEdmdmN0VGI1SEx3dVJvejh1?=
 =?utf-8?B?OVNZRUc2bUNYRnc1ODRCYUs2elllblhkRVROL2pIV3BydDR0NjZnSWVGWEE3?=
 =?utf-8?B?RmRSN0NGb2hZMklySENwcU1pRGdzNU9hNDdxMUUvLzMycnFndFcxTDJ0YjdB?=
 =?utf-8?B?MHBsdUdNdzBOemYrSFowTWZVeEtCcDhyQ1BkdjQyenBtVlArcnoyTFMwNm1x?=
 =?utf-8?B?SmtEUEpyR3MwemxoMmk0T0Qzdm51TUQ3SnZBVU90ZGEyNjZEMytjcG1PQkM1?=
 =?utf-8?B?aDlkVU5KRnE4M2hheldOdzV6K0dobHc0N0pUM3NDV1RJczNhMm5NQ1JjMFh3?=
 =?utf-8?B?REMxVTV2NmlSMlA5dEhsUjBTaEtkcGU2SU1LRFAyUnVSbUNkWExhZkw0RTRU?=
 =?utf-8?B?bldieFBnc1RucHNtZ3VlMmtOWEx1UWV0VnVFcGYxQUVtWlRGdDQ1Q0NLa3Zu?=
 =?utf-8?B?QzQya1pPY1ZaWnJ2MlhSSTI3dU1YankySS9JU0ZBdzNEbVdDUkxhVmp0elNu?=
 =?utf-8?B?QlBBUjFWaitZVnZ3VzFONlJQZjBFcFVreEloQk8wclpvdGxUVk5ub1ZvNUZ4?=
 =?utf-8?B?cFg0Y0N5ckEyOUJUcmE5R0NpM2tGOUFyQ3F6ZnZrdHJuaU9GY3dVRlFJRXdW?=
 =?utf-8?B?RmVydWpERVRWbUN2ZlZKUklxTGQxOVJQOHlSc3NsTDR1SlJKU0FZeDlZQjRX?=
 =?utf-8?B?V1dvYlMycjd2UFBSQ1pPbTlpRVFvZWpMSVRHbE9COGJBUjNkVEl5YjJ2cFJS?=
 =?utf-8?B?ZldITXRMcmJjMDdnaVR4bkx2WjFsQUh4YzZjTjZHZTNyaVFJNkRCdHpxNFJa?=
 =?utf-8?B?YXlDQ1dhRkNmdkJQaGdPd2cybm5kVVZZa25vb0NlWitLNFg4eGFzdVh2YnRk?=
 =?utf-8?B?anJzUGU3SWVHcGtvRFptZ2J3eFJRUjVPQmpCZmdSOHBFOEEyRXZYN1Qzdmo3?=
 =?utf-8?B?YlZ3MWcvcS85NW40Nm1HUjIvdDRFbEhpa1JtN04rZ3B5dHZQWGNCZzFMS2J1?=
 =?utf-8?B?citWaXZjL285TlZKUXp2clBIVDBBQ3lWVVJwSGRTNGgvYlVEODJqUFFWcXh6?=
 =?utf-8?B?eXZzV1k4OVp4cFhrVjRsMjR3NHlUWUo3R2hRWlAraUEzUWRmRERWUC9tc0JO?=
 =?utf-8?B?Qkp5M2wyRkRSRlhmQUVXNWlESXJKUWErcDR2REs1aW9BbDJkcXRuekZ6NWox?=
 =?utf-8?B?ZGxFYmE4QnpJN0RqR0ZYdzV2R3pjN0RuQ3BxMDlNWG5xaTRxQzhIMXo0YVBy?=
 =?utf-8?B?bnZMYWlneFBWUWZuK1J4NjBpSmhnZkZlNU9BN0Y4ZFg2MmZtbGlSQnNDc3B4?=
 =?utf-8?B?U3RMaCtVNXhvaklMNWFaY3o2NmhyR1BsSGNyYjV0eGRjc2xyTUJpcTBDTGFo?=
 =?utf-8?B?TkxTRjhLbnNiWi9zQ3MzOGtDVzB5REhyN0EyRW5kMlZYMDEyT0pzeFdlTXVx?=
 =?utf-8?B?MFVsWHRDMU1IMlJwdGFvalBUcVZMMjh4UzJwenpXY1pNQXcxc2ozdXUrcWNy?=
 =?utf-8?B?S3Vla3hrZEhGa3RucDVYYlFKdWtXU2IrWUhMYXZyMG02eGpmcFRrSzBWcG1K?=
 =?utf-8?B?aHVZQUNCNllPOVFQMW00ek5LMjQxNHl2UE9pM0JOcnVSLzRzREpNeHA5cmVD?=
 =?utf-8?B?VDFxaktRelhFUzBRZHJ0Wk1hdGVDSUhCOWpPb0xuaTFSd3pmc1B1T3puelgx?=
 =?utf-8?Q?UZo7mxjNLwv9NU8KUpVv9SV12?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afd07071-7800-4a54-a2c4-08dd51e3d550
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 19:21:53.6537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OH/ttG+HFDpBmBq7k6DFvFhSYIyLZkcpQdkoYojj3l3JwWM/s7dmSSAjAuwV6hWHkWRGd4vywpgq8mlL/oNCcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7972

On 2/19/25 14:54, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Add new API interface to do SEV/SNP platform shutdown when KVM module
> is unloaded.

Just a nit below if you have to respin. Otherwise:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 13 +++++++++++++
>  include/linux/psp-sev.h      |  3 +++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 582304638319..f0f3e6d29200 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2445,6 +2445,19 @@ static void sev_firmware_shutdown(struct sev_device *sev)
>  	mutex_unlock(&sev_cmd_mutex);
>  }
>  
> +void sev_platform_shutdown(void)
> +{
> +	struct sev_device *sev;
> +
> +	if (!psp_master || !psp_master->sev_data)
> +		return;
> +
> +	sev = psp_master->sev_data;
> +
> +	sev_firmware_shutdown(sev);

	sev_firmware_shutdown(psp->master->sev_data);

and then you can get rid of the sev variable.

Thanks,
Tom

> +}
> +EXPORT_SYMBOL_GPL(sev_platform_shutdown);
> +
>  void sev_dev_destroy(struct psp_device *psp)
>  {
>  	struct sev_device *sev = psp->sev_data;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index f3cad182d4ef..0b3a36bdaa90 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -954,6 +954,7 @@ int sev_do_cmd(int cmd, void *data, int *psp_ret);
>  void *psp_copy_user_blob(u64 uaddr, u32 len);
>  void *snp_alloc_firmware_page(gfp_t mask);
>  void snp_free_firmware_page(void *addr);
> +void sev_platform_shutdown(void);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
> @@ -988,6 +989,8 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
>  
>  static inline void snp_free_firmware_page(void *addr) { }
>  
> +static inline void sev_platform_shutdown(void) { }
> +
>  #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
>  
>  #endif	/* __PSP_SEV_H__ */

