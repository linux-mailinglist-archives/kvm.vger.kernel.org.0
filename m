Return-Path: <kvm+bounces-60079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 55982BDF2DB
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 16:55:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CE3264FF01A
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 14:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9168C2D5C74;
	Wed, 15 Oct 2025 14:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FO1gejyz"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012049.outbound.protection.outlook.com [40.107.209.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026A12D5950;
	Wed, 15 Oct 2025 14:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760540138; cv=fail; b=pSG8dUG/zmqwUq8K5FGLng5lM7SvtK9VXfu9d/0fnr8uhdZ0m6kjitn6PMQEWViBln9dqv1FrtBFqliUCjY7HISRlBp3raH+1CP7neairyK9A1xBJoZMg97+cBpIwKL2WPpfey7QAlCqRVm8eKoPAnGIWX8/sPV7KbyHvC5qTaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760540138; c=relaxed/simple;
	bh=Ycbj+EBx5sK+q1ry6I7aUaygKvg4Ok2tlzjn9zYnDy4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Pg56GtjA5/Rgj0hdUvcwVFpX4Vi/PUL7usbOSUmAdvwbokfXP9REG6eIM1R0LIHRW/5EhRQLX40oKmP3tZO0C87rC2FQ1FZy5f6bJkExfzdtwv/TpuBnrINBz6J+h1IL/bWigaZ74Eu/Ua3uPAkJ0h6TK3BJI0mzu8pT7ZSOr/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FO1gejyz; arc=fail smtp.client-ip=40.107.209.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uxqQx2qaAN4sFIEmMVpePb84BSg2UHcrHOyv140O3mGUwYrRZbnX5WcN5NTXxSXmCY/FJZOc0D9eUHda6GY5JyXXMF0FzPeQLg5P+xsH5onuCdxwAlkKMv2svwUPHfbJt8KSZygRnxP0NqxsyNXtepUfaIe0N8f4A7klFRZnZQFDxCRccfivyCB9iffffnZrzkiMzSwPGgG1P+b+p9XaNan++ulrAGjSK6dEsdNln5MgR1eYHBMxnGHSoKfIMTii3TRztSMm1l87hqVId+gNxLVngXUetOFDyuxQkUOXKjmXIH9Ck1cbmUV4u/4BdzkQ3Z52eV0im+sTw2r7iJvCQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iV5DrmpEEpOCIZsCjgMD7ecYk0r/JdBxUQH9GXbh2X4=;
 b=tULPBE/lecqptqtwapbIvsQ5XW4Y8D6WqgWTfrFqFXAwCOWiJ3GqZCDY+Yx4fL7v30AFPMJO4YsCtRvigtQXShaIn0PsORwhkr2cKxTWUmrkvEuTikB+LvXXO6bTcD8Lc8nYeyK5oHfHrUbhPkSYHyyxktwZ6idsQBkBoT2StT/fKTuxr3w2J3rkK3kPg1URbNvmF4cd+EV1KbKX6GVoLIEGmjBXH9CMcWb+a6tsY0JoO5IbKxMoqejrzSFBtyNoYRNaMDCB01GPUGsvkDTA2H2GTDg3v3pY0vZ0FGEN98rLWCQYWsrcA8uoDJgkot33jb23z1NWALfRI7QC88y/0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iV5DrmpEEpOCIZsCjgMD7ecYk0r/JdBxUQH9GXbh2X4=;
 b=FO1gejyzbuNX7X3tESpguqEMVfpQra/1+96JLu0kYgIc2XTN2c4Qj0yHFzQEGDcgcvDbdcS6qDE4+IuvT87eIjY4jx10z8h5Nm1LPFX+yPpAlgda/ca6Q08PiKgSpekgViOcHWBu5TfM4nqeRuJ8gQeNFNRikBve6TAHW9Hpou4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by DS7PR12MB6046.namprd12.prod.outlook.com
 (2603:10b6:8:85::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Wed, 15 Oct
 2025 14:55:29 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9228.010; Wed, 15 Oct 2025
 14:55:29 +0000
Message-ID: <a2961f11-705a-4d75-85ee-bf96c8091647@amd.com>
Date: Wed, 15 Oct 2025 09:55:27 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix MBM events being unconditionally enabled
 in mbm_event mode
To: Reinette Chatre <reinette.chatre@intel.com>, babu.moger@amd.com,
 tony.luck@intel.com, Dave.Martin@arm.com, james.morse@arm.com,
 dave.hansen@linux.intel.com, bp@alien8.de
Cc: kas@kernel.org, rick.p.edgecombe@intel.com, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org
References: <6082147693739c4514e4a650a62f805956331d51.1759263540.git.babu.moger@amd.com>
 <a8f30dba-8319-4ce4-918c-288934be456e@intel.com>
 <b86dca12-bccc-46b1-8466-998357deae69@amd.com>
 <2cdc5b52-a00c-4772-8221-8d98b787722a@intel.com>
 <0cd2c8ac-8dee-4280-b726-af0119baa4a1@amd.com>
 <1315076d-24f9-4e27-b945-51564cadfaed@intel.com>
 <3f3b4ca6-e11e-4258-b60c-48b823b7db4f@intel.com>
 <0e52d4fe-0ff7-415a-babd-acf3c39f9d30@amd.com>
 <7292333a-a4f1-4217-8c72-436812f29be8@amd.com>
 <a9472e2f-d4a2-484a-b9a9-63c317a2de82@intel.com>
 <a75b2fa6-409c-4b33-9142-7be02bf6d217@amd.com>
 <5163ce35-f843-41a3-abfc-5af91b7c68bc@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <5163ce35-f843-41a3-abfc-5af91b7c68bc@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR01CA0025.prod.exchangelabs.com (2603:10b6:805:b6::38)
 To IA0PPF9A76BB3A6.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|DS7PR12MB6046:EE_
X-MS-Office365-Filtering-Correlation-Id: f213bf90-bd28-4ace-53a6-08de0bfae20d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TGpYTEd5ZjNjeFp0eGY1Q3RFdVZyRmhtVWZQVGpIVll4eG9LeVNwbFVDaWZk?=
 =?utf-8?B?WDFiZWl0RWtPMzZ4VWZ1WGNSN2lXaGJibnpxWWlFOC9QQ1lxWE9NWTBTUTRy?=
 =?utf-8?B?Wk5ISVJUdFdjNmRFUDhPNnlvY2hoT2JicVk2TlUxdFI2QTJEUnpMSVRTZjhh?=
 =?utf-8?B?M3VRUHBCYjhYeklOYklldWZJTlAxSS9iMXh3QitXVVBnQ0VkNzlkR01JU0pw?=
 =?utf-8?B?eW9BNnowVm5TNUY4Q0RtczE3Y2E2UHRzYXYvbFlpblk5Sk5rZFJZcllJTjRY?=
 =?utf-8?B?S0VVUmYvcmc0UEFFTVM2a3NLVHpacWhKSDZvUFR4QTBaRVpkOFg1Qkx3UW9C?=
 =?utf-8?B?czA2SUt6VWJRYmJkeElZZXMxRHlWeEs3QS9vMkRWQVVkUGJYaWVxakVyMk5F?=
 =?utf-8?B?eVhVUkRiYklLdUhWdEIyYlhmQWovdDVuQWpzbnNxY056UFArSEpqZE5uOVlz?=
 =?utf-8?B?Q0MzZW9qMWpmNldoMmYzUElRUHF2U2JqMlVUTWtxZExDN0FjaGoyY0lwSWd3?=
 =?utf-8?B?ZG9zWExEQ3FMK2tScGlVTjhNZGFMMFRIelJiNnZ3djYzd2pldklCVjF5My9U?=
 =?utf-8?B?Vm9JSnFmM09DYTBwMkFSMEFBaGhTdklZRHBJYjJOYjRBNDVTYWRxUFdlNnJ4?=
 =?utf-8?B?VDJnQ3h2Q3JPdklLNmhaSHU0bXVwVlM5ZlFzOWRJYUtIWm93S2hYeXM3NVRa?=
 =?utf-8?B?eUhqLzdLV3QwaE5pMjBBdXpOUjBKb0RMelF6cXRHVmdoNHZXc3FxNFVmZEsx?=
 =?utf-8?B?bXI2QytxVktPN05HWkpiR3lKU0F6UGhIL21MRFUzMU5JNUlvVW81UUlOQzc3?=
 =?utf-8?B?NGY1VjRuT0FXb3BuUURMTjZVdnY0M2gzMGI5UmFzODFqQXhwMHh6NzJkM3Zu?=
 =?utf-8?B?NnE2UmFPNFR0SG1zYTdpN1hINUR0RkR5TXU2MXlBNEtibmNoRG0vaDM5b1dX?=
 =?utf-8?B?VDRzdCtvZ1ZsUmpzTTNpc05xTkNrS1hvN0VSSXB4ZU5na05rOE1pcEFIeFcw?=
 =?utf-8?B?Wmx0dU9ncTlXTnpZMWlDL0NFMGdtYzNtV2lZbGlVQmRpTFRodk5DcGRYQ2Jx?=
 =?utf-8?B?SjlxczloQ0NMZmNIS3NDMlFzVkxReHdGM3RqQUd2eWl4bDQvTzVtNFU2TDhY?=
 =?utf-8?B?REtTdk1BS2l0TnNOMVorU0p1RlVWOE42MDM1T1pmQmVOTGtzUE9RbzJLcmIz?=
 =?utf-8?B?elhQb1p2NjFJY1ZaN09DOXJyT3l2bEh3YjZ6TEZ3dHN1V1RxMy9EZkRQRGp4?=
 =?utf-8?B?QTFuOC9NRzRpbDRZVW95aGZFSWFMTVB2dDZodFQ3RkRFUkJsdFY5eDJuS2hi?=
 =?utf-8?B?eVkvWk1FYWY0YlpJaTVRdU1nREp4aGtjVDNKM3pwR0VIcFVEVktvOWZuYUZj?=
 =?utf-8?B?ZWNJVHViMFNrOFM5WVlrTHMrR3ZYb3Q0cUNpd3ZZZ09SaDZsaG9yWmgzTzFU?=
 =?utf-8?B?Y0JZUk9FbjBKV2xEZUQyaWZ3NWR5SjN1QlNMeVB5TG9rWmFEVENtQ3RsMDNO?=
 =?utf-8?B?VkZjc0NBL05NUTQ1NGpNblozNGM1aHozdGVpZ3VMSTI3VGxYaDgzM0UreXVV?=
 =?utf-8?B?dHF1TjR5UEszY0cwZGVEbnp4cVJiTjcvTmFPQXAyVWxWSENFcTdKd0J5NkZx?=
 =?utf-8?B?MUdQY09qcE9RQXhrZWhZdm5XRmlVbFQxNSt0TnZJajBmRklvQXNKTjIyR1hF?=
 =?utf-8?B?MVdQYWMrYWdPekZBSHpQMWtrL0x4VGR0TGNOSU5rMDBnSjdtZ2JHRmVHblY4?=
 =?utf-8?B?MkJEeXU2REU4Zkphd1NvVS93R2wra2pIQUkwV0REWWZLcldJTGZlekVXSjlV?=
 =?utf-8?B?MkdpK0ovaytTQU0reTdSam5BRE5kUzhxZ3FRd0N5cUNqSk5ESXZGSnFmeUxn?=
 =?utf-8?B?OVpsQ3QxV2dqdlNFejYyK1hoZXdpZy9MYlBqODI3cFlSK2NmSC9KMDA5Yjky?=
 =?utf-8?Q?AIUhD+6D7ytoTTSIXfV5VHU9EvaKAMSg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2plL1pabFNtNTZsaWRrb0NQelpNSEx1M3YvWlBIZDROWWFiUFRIM0N5Ukxm?=
 =?utf-8?B?ZS9nUnorODJVdXFwUlBPOS9HcllPR2psdk15bUdrMlhKT3dmb2dOa04xaldB?=
 =?utf-8?B?OTl2OVFuU0tpTDdqWWdsSmkwV1krU1plZjdKRlI5WnBLYm9Pd0xFM21BdGV2?=
 =?utf-8?B?TEEveTUrRU9xYWNwMmk5NHBWakJLeWtpVktBeU9TREV4M3l4V25UOEdlWG5U?=
 =?utf-8?B?VC9iK045bDlwZ0pnRnYxYXdNMjRXS0RUWFcwQkNoU1ViVi9uaEZBbDBqc2FL?=
 =?utf-8?B?K0JTOUtrUXhGRGhzb2s0TWIxSVR2TUpjcmdQRkZacXNJYk1hQ2l6ZlNlY3Fn?=
 =?utf-8?B?R296bUluNkdDMkhiWkQrN0RTOStpbFY4cEtoU3pxYVdhV21hTzNqMDhKMHFn?=
 =?utf-8?B?dFluWkRxRFZtSFNLbzJ2b1orRHBGWmR6amtOaUtmU0w2WkhMY3pWZWtkajdF?=
 =?utf-8?B?NURhZWhScGlLNGZYZ1AyTk9abUo1MXk1Z3hKamtadkRCWU9SaGlhMjQ2ZHZC?=
 =?utf-8?B?L0FoT1VFRlE4VWRXeTl4LzlydUh5OXNUOTNLRm5WeWxaMFBlM28vUUhIK05D?=
 =?utf-8?B?NUJJRkNxMktBTm9obE9PTDErRVhMNTR0QmVJeXRsQWg5czNuWE51QTB5a1E5?=
 =?utf-8?B?cDNlcmJOYlgxdm5RVUd3dXJNZ0I3VFlCSHh6aHkrczdkYkFGaWxuTW13WFRz?=
 =?utf-8?B?SXQ4Yjd0b2VyQUdMV1VxUU9vOVNpL3B3cktpSUduQ1EwbDNySHBkeHlpbm5Z?=
 =?utf-8?B?Nzl1MEJRdlNYMTN0VFlybHVDZ2FQVFZEVkNBaUhxZXR5RkZtRXd3VkRnS3Q0?=
 =?utf-8?B?SzlKalJTWEUxeldqZ2k5cDlSKzQzWEIycEwxRWdSRTV6bUU3d0QweDNHTXFM?=
 =?utf-8?B?TFVjU3pGMXRkRUl2UDE2ZVp6OGpzRjU3YmFEdjIxVi9jT2tRa000TkQrK0pO?=
 =?utf-8?B?SVU5akRTVHEvSXdYZCtaSGxvdy94T2N1MU9mRXkwWGtoVDlWaXpzb0RSeWdL?=
 =?utf-8?B?alF0SkhmSjNuc2hiVlBRSmlDUUxndnFrUnViTHpMQkVzME84M25EM3phTlk2?=
 =?utf-8?B?L3VyQW53enFwOENLRnlMMmdrempibFcrVm5URjQ3UzF5ZC9ublU3aEhJZTFS?=
 =?utf-8?B?ZGE4RUxtOEdXUzlJWDdDVUprck1lMzFoSGc4cGZ0NGFaY3c1QkMrRFMvZ25I?=
 =?utf-8?B?UHkxTVoyTG5WVjM5dmJjSmVpNDVEd3plKzJJTEhEYlRwemdEQkJxWVNtNHFl?=
 =?utf-8?B?Nkp3QWZQTlA3SDZtTUk3bERaeWNZcE14dDFwT2JnaDc4eFRBWHB2ckljWTZI?=
 =?utf-8?B?Qml4SmsvWG9jbWRRdDNiYllpQVVkZUcybWZmb1pIYjBZcktFQ3hNRG4zelh0?=
 =?utf-8?B?aEMyeVUvRDY3QXQ1Mld5YmdnQlAxVk5OQlRUM1Z6Z0p1WTJuMlkxQ2VqcHl1?=
 =?utf-8?B?VTlvRG9yU2RzMzgrTFpDUjNvTkdsY3VlVmJZL0lZWXpYb1lZNXlQSkg3aWpS?=
 =?utf-8?B?V2VkWnRuTDZZd1NMVmc5UFIxZVhtSDQ2bGRJaE11NWE5U3BqTEZacDVNMTN2?=
 =?utf-8?B?ZnFCMG4zUCtWTkJ5SWJ4S1N2TGlQcWhqZlFvejk3d2IwU2lGWTAya29PVDVX?=
 =?utf-8?B?Zmh0VHhtbkZiajIvbnBpeEcraURJazBiSnZrNXpaTmRPMzYrS2FaMDgzZnBE?=
 =?utf-8?B?QnAzdjUzbHVaSlZBeVRFM0dUdi9mbEZBKzBCRzZZK3VuWExHQTF3SEdyVVBM?=
 =?utf-8?B?ZFY3bEhYVmdBUUdZcGtDOTlkT2hmK1F5TlZUM25sb2tkZjJxTVZEdmwvdjNK?=
 =?utf-8?B?Q3Z6cW44UW5EUmZ6aUhMRlJGQ2I4enJEN21XYlYvQ3dZU2dLVlMvTUpZZk04?=
 =?utf-8?B?cHMvTHcxTWhsajc5NDVWSUJPV2pXcFFPNC9YYVA2dnFHdnlqOHFlRUNmNnRs?=
 =?utf-8?B?MHRDKzdmYjhQSktMMzRFYlJha3lpSmxWZUQvcndjVy91dTlWcTdYSDcxNXRa?=
 =?utf-8?B?WXBIRDFVdVhDakQxM2JwOU5DWXNaRFRKenNXU0NnK0o2SHlsZTJROENIQ0xI?=
 =?utf-8?B?Yk9rWUhRQzVuaUUxVisvZi9OTkpHcXJQY3daekNyYjFPV0xvcFQ0ekpjUklv?=
 =?utf-8?Q?RMCc=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f213bf90-bd28-4ace-53a6-08de0bfae20d
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 14:55:29.6953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: //clIt/jH5VjltEqQHqnYBphTVlVE7tlT4q4bRSUCeWcoYcVirg/4oxXjwlQl9Q3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6046

Hi Reinette,

On 10/14/2025 6:09 PM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 10/14/25 3:45 PM, Moger, Babu wrote:
>> On 10/14/2025 3:57 PM, Reinette Chatre wrote:
>>> On 10/14/25 10:43 AM, Babu Moger wrote:
> 
> 
>>>>> Yes. I saw the issues. It fails to mount in my case with panic trace.
>>>
>>> (Just to ensure that there is not anything else going on) Could you please confirm if the panic is from
>>> mon_add_all_files()->mon_event_read()->mon_event_count()->__mon_event_count()->resctrl_arch_reset_rmid()
>>> that creates the MBM event files during mount and then does the initial read of RMID to determine the
>>> starting count?
>>
>> It happens just before that (at mbm_cntr_get). We have not allocated d->cntr_cfg for the counters.
>> ===================Panic trace =================================
>>
>> 349.330416] BUG: kernel NULL pointer dereference, address: 0000000000000008
>> [  349.338187] #PF: supervisor read access in kernel mode
>> [  349.343914] #PF: error_code(0x0000) - not-present page
>> [  349.349644] PGD 10419f067 P4D 0
>> [  349.353241] Oops: Oops: 0000 [#1] SMP NOPTI
>> [  349.357905] CPU: 45 UID: 0 PID: 3449 Comm: mount Not tainted 6.18.0-rc1+ #120 PREEMPT(voluntary)
>> [  349.367803] Hardware name: AMD Corporation PURICO/PURICO, BIOS RPUT1003E 12/11/2024
>> [  349.376334] RIP: 0010:mbm_cntr_get+0x56/0x90
>> [  349.381096] Code: 45 8d 41 fe 83 f8 01 77 3d 8b 7b 50 85 ff 7e 36 49 8b 84 24 f0 04 00 00 45 31 c0 eb 0d 41 83 c0 01 48 83 c0 10 44 39 c7 74 1c <48> 3b 50 08 75 ed 3b 08 75 e9 48 83 c4 10 44 89 c0 5b 41 5c 41 5d
>> [  349.402037] RSP: 0018:ff56bba58655f958 EFLAGS: 00010246
>> [  349.407861] RAX: 0000000000000000 RBX: ffffffff9525b900 RCX: 0000000000000002
>> [  349.415818] RDX: ffffffff95d526a0 RSI: ff1f5d52517c1800 RDI: 0000000000000020
>> [  349.423774] RBP: ff56bba58655f980 R08: 0000000000000000 R09: 0000000000000001
>> [  349.431730] R10: ff1f5d52c616a6f0 R11: fffc6a2f046c3980 R12: ff1f5d52517c1800
>> [  349.439687] R13: 0000000000000001 R14: ffffffff95d526a0 R15: ffffffff9525b968
>> [  349.447635] FS:  00007f17926b7800(0000) GS:ff1f5d59d45ff000(0000) knlGS:0000000000000000
>> [  349.456659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  349.463064] CR2: 0000000000000008 CR3: 0000000147afe002 CR4: 0000000000771ef0
>> [  349.471022] PKRU: 55555554
>> [  349.474033] Call Trace:
>> [  349.476755]  <TASK>
>> [  349.479091]  ? kernfs_add_one+0x114/0x170
>> [  349.483560]  rdtgroup_assign_cntr_event+0x9b/0xd0
>> [  349.488795]  rdtgroup_assign_cntrs+0xab/0xb0
>> [  349.493553]  rdt_get_tree+0x4be/0x770
>> [  349.497623]  vfs_get_tree+0x2e/0xf0
>> [  349.501508]  fc_mount+0x18/0x90
>> [  349.505007]  path_mount+0x360/0xc50
>> [  349.508884]  ? putname+0x68/0x80
>> [  349.512479]  __x64_sys_mount+0x124/0x150
>> [  349.516848]  x64_sys_call+0x2133/0x2190
>> [  349.521123]  do_syscall_64+0x74/0x970
>>
>> ==================================================================
> 
> Thank you for capturing this. This is a different trace but it confirms that it is the
> same root cause. Specifically, event is enabled after the state it depends on is (not) allocated
> during domain online.
> 

Yes. Thanks

Here is the changelog.

x86,fs/resctrl: Fix BUG with mbm_event mode when MBM events are disabled

The following BUG is encountered when mounting the resctrl filesystem 
after booting a system with X86_FEATURE_ABMC support and the kernel 
parameter 'rdt=!mbmtotal,!mbmlocal'.
  
===========================================================================
[  349.330416] BUG: kernel NULL pointer dereference, address: 
0000000000000008
[  349.338187] #PF: supervisor read access in kernel mode
[  349.343914] #PF: error_code(0x0000) - not-present page
[  349.349644] PGD 10419f067 P4D 0
[  349.353241] Oops: Oops: 0000 [#1] SMP NOPTI
[  349.357905] CPU: 45 UID: 0 PID: 3449 Comm: mount Not tainted
                    6.18.0-rc1+ #120 PREEMPT(voluntary)
[  349.367803] Hardware name: AMD Corporation
[  349.376334] RIP: 0010:mbm_cntr_get+0x56/0x90
[  349.381096] Code: 45 8d 41 fe 83 f8 01 77 3d 8b 7b 50 85 ff 7e 36 49 
8b 84 24 f0 04 00 00 45 31 c0 eb 0d 41 83 c0 01 48 83 c0 10 44 39 c7 74 
1c <48> 3b 50 08 75 ed 3b 08 75 e9 48 83 c4 10 44 89 c0 5b 41 5c 41 5d
[  349.402037] RSP: 0018:ff56bba58655f958 EFLAGS: 00010246
[  349.407861] RAX: 0000000000000000 RBX: ffffffff9525b900 RCX: 
0000000000000002
[  349.415818] RDX: ffffffff95d526a0 RSI: ff1f5d52517c1800 RDI: 
0000000000000020
[  349.423774] RBP: ff56bba58655f980 R08: 0000000000000000 R09: 
0000000000000001
[  349.431730] R10: ff1f5d52c616a6f0 R11: fffc6a2f046c3980 R12: 
ff1f5d52517c1800
[  349.439687] R13: 0000000000000001 R14: ffffffff95d526a0 R15: 
ffffffff9525b968
[  349.447635] FS:  00007f17926b7800(0000) GS:ff1f5d59d45ff000(0000)
                     knlGS:0000000000000000
[  349.456659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  349.463064] CR2: 0000000000000008 CR3: 0000000147afe002 CR4: 
0000000000771ef0
[  349.471022] PKRU: 55555554
[  349.474033] Call Trace:
[  349.476755]  <TASK>
[  349.479091]  ? kernfs_add_one+0x114/0x170
[  349.483560]  rdtgroup_assign_cntr_event+0x9b/0xd0
[  349.488795]  rdtgroup_assign_cntrs+0xab/0xb0
[  349.493553]  rdt_get_tree+0x4be/0x770
[  349.497623]  vfs_get_tree+0x2e/0xf0
[  349.501508]  fc_mount+0x18/0x90
[  349.505007]  path_mount+0x360/0xc50
[  349.508884]  ? putname+0x68/0x80
[  349.512479]  __x64_sys_mount+0x124/0x150

When mbm_event mode is enabled, it implicitly enables both MBM total and
local events. However, specifying the kernel parameter
"rdt=!mbmtotal,!mbmlocal" disables these events during resctrl 
initialization. As a result, related data structures, such as 
rdt_mon_domain::mbm_states, cntr_cfg, and 
rdt_hw_mon_domain::arch_mbm_states are not allocated. This
leads to a BUG when the user attempts to mount the resctrl filesystem,
which tries to access these un-allocated structures.


Fix the issue by adding a dependency on X86_FEATURE_CQM_MBM_TOTAL and
X86_FEATURE_CQM_MBM_LOCAL for X86_FEATURE_ABMC to be enabled. This is
acceptable for now, as X86_FEATURE_ABMC currently implies support for 
MBM total and local events. However, this dependency should be revisited 
and removed in the future to decouple feature handling more cleanly.

Fixes: 13390861b426e ("x86,fs/resctrl: Detect Assignable Bandwidth 
Monitoring feature details")
Co-developed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>

====================================================

thanks
Babu

