Return-Path: <kvm+bounces-34031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E15E09F5E3C
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 06:20:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B2101655D0
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 05:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16BE0153BFC;
	Wed, 18 Dec 2024 05:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XM5rBae4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C4B13E3F5;
	Wed, 18 Dec 2024 05:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734499221; cv=fail; b=r9s/+Yj3JnJsDfF3bHrUzylYoReYqz69dLdaPCIBaOikHu2TdHB6vZqcOU/UzZ4pUtz7Zkd7W9zEjc2XPDVGgktnzzGyb3Gf/GpAsvSf25FszPOLruSO9YVSBJuERjDwr2rB9QgHZXeN8WD72F28r/TrUoVKAco1/Pu3/aeaNHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734499221; c=relaxed/simple;
	bh=66Ij+kxASrU8YwopgkU+7ata/PIY6dTmNrZpeIoJf3k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Fp5Izy2mv/g4MqwKN+YYz0VHiz2yPzuibwh6AFGyGcL9brvfuYOUcyaF6nee85ZcQgRxmlJiuE8s6d0IoCiOBdbii5SwTvK9a5w9abzKzv+wJPN68pB0FftLHo64L6EKaG4Ixw+kKgZvs46ghBIPXVWQylvKRpd4x4gb1XHrnLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XM5rBae4; arc=fail smtp.client-ip=40.107.243.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sG4ylmI1FvDutf5skbwOHd9jWKt576yN+H8fqC9sSl74t7L+L8T6Gmq6yw6fzIxMKnuwihPexv/cE10H3/ui6GvXQzOJZCmZR7BgY5n2NgXQ2TxNgANWhj/KLA0R7e0lXtKXdqhs50CwkDPUIdy/LzCVzthhbjcdA3c3VRvtPZQFUPXxmqfbVgtvJfKebY9RE0jNUsiy3RNqkzKacsSmpsT9Y3yFfdao/CMOQviKEXxd2gGkkgkwK95qMmxWEN8ku04NxsCNx14fljxVGp5sHzOtdghFmyZPYWz3JxIzaXaikNKBDtiMYEKju6SWp7uXbMRxKgx7pfY2t5TiAwhftQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cSiMg5lNKdk82M4StUmLpSiom3BO73FdGF5tDzzEl/s=;
 b=ubnWuFoy04kLXtbOoknPKwxs+E75SNxDkkjTo4GG7oTB3K4ZUDYjLCvrai8aLzn09FfNo9Oy+Jk3ji67+5JzaX8zRmQ3Ge3BmXxPmFm3udStX17XUjAscym1lH/HXMmte3B0VRmJ71HMSpbCFF80NvKdJ1yvop3DGGcdnNFFG1lQzLDGOYsdg4fz/FyLfQAomhiqMH6gKFU6VOLW+xxdYhYcEcvJMzS+i/rOa+8nmk4RkCO3XYOJJi65d6Hwuu7lIQU9KAn7QDSrxgxkWIDKnoao5KvbDF1vhaKekQX9+iKffXZ3cwGcJUFPOuB5BLDoP/YnpWtlt23wcVQduwIwrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSiMg5lNKdk82M4StUmLpSiom3BO73FdGF5tDzzEl/s=;
 b=XM5rBae44oeQ8lDaNeNA0530OiBiRWsjRXlXmfuJKECiavexw1sjQQdneuPknO8/ubtoY6DXEwooCWrDQfHuZ2CsBjy8HIVaGMK+UVxt+7/elM4lhVuK0RJL2PyQvzqSePFJqvVplqFaOGLSpakVXYBZNJB+D80xfbpdftfNgrs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SN7PR12MB7956.namprd12.prod.outlook.com (2603:10b6:806:328::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Wed, 18 Dec
 2024 05:20:17 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8251.015; Wed, 18 Dec 2024
 05:20:16 +0000
Message-ID: <7a5de2be-4e79-409a-90f2-398815fc59c7@amd.com>
Date: Wed, 18 Dec 2024 10:50:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-7-nikunj@amd.com>
 <20241210121127.GBZ1gv74Q6IRtAS1pl@fat_crate.local>
 <b1d90372-ed95-41ce-976f-3f119735707c@amd.com>
 <20241210171858.GKZ1h4Apb2kWr6KAyL@fat_crate.local>
 <ff7226fa-683f-467b-b777-8a091a83231e@amd.com>
 <20241217105739.GBZ2FZI0V8pAIy-kZ8@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241217105739.GBZ2FZI0V8pAIy-kZ8@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0016.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::18) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SN7PR12MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: e9d2a7af-0425-4c7e-161a-08dd1f23a849
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZldNRWoxVlM5dVdlK2hkTS84SGNSVVFuajJDeThvdjdLUGNKSnlnYVVpS3BT?=
 =?utf-8?B?dUEzaWoxVWIwa0lNNXhhcG5ydXB6YU1oUVJpWnFueHI1OUF6NWpEOUNlSmxE?=
 =?utf-8?B?V2JZRTltclFoMkcvUWU1NitpbHYybGNGTHJRaFlnU2R3MnhlM0pZREJ0Ly81?=
 =?utf-8?B?VGpwcHphQnpKQWJwRjRkZWlLVnNnVUlVbXR6d29BRm1ZUzBkSFhRb3E4Nms3?=
 =?utf-8?B?dGZrbXkzKzBXL2dKMjdNMXVYN3lLZ1FJcnpmYVBObjVwQkVtZ0MrYTZBUlVI?=
 =?utf-8?B?QVhJVnN1Wk5lM0dkbWNhV0Fxb1lNZnYyVjAxdkhYNlhJLzl4U0NyU2JHdy9T?=
 =?utf-8?B?QU9FTUVOOS8zZkZXdGFiRm82VUJHNlRrbTJQUUhoeHoxV0c0eFVrenVldFp4?=
 =?utf-8?B?UGQxRE82eEFVZ1FoUlhtUDBuejNWSWprOVpXeFBjTHRVVzVGaThGRDVLdmxV?=
 =?utf-8?B?TDJyUkcybzliQnh1N1pVcXJHSGJUdkJoSlFhQytRSlNJMDlCMHpydFhkZlJT?=
 =?utf-8?B?bldxYlkyeS9rWld6WFhZMVlERFltMVd0eGJZZkQvZ1NXSzZJclkxYXFLczYy?=
 =?utf-8?B?YXRGWUJQaU5nekgyK1Y3RnpvcExmRVdpeTN1TjJhdmhIMUtzRjI3TVpuY2dq?=
 =?utf-8?B?RDFTMVYxOGdwQW43a0JxTDdIVm5PMXc2SWNWQ3paMlQrZUd5cE9neVlTMSs2?=
 =?utf-8?B?TUhwa0doSTNPeWxDdG9rcUlMbU9ESFREbGJuT0I3dS9Tc01GeldsVFUwY3lV?=
 =?utf-8?B?SGs4T1IvQUdiLzBwUjFHZ1E2NVplUi9xUGZCR0ZCVmsyVkp0WmRUbjNzOFhT?=
 =?utf-8?B?cjB6WS83eUdoKzlnWDF4M3AyOTFJWXFEM0Fqb0tZMzBNeVlwSU9yQ1ppSEhl?=
 =?utf-8?B?R2dTNjJwU3k3RzM4REF0QTk5Vk10V1RqaUM0cHZLdEVTVVUxNHZrT0dXaFdv?=
 =?utf-8?B?MnVKazZ2Vi9admUwT3M0TGl4RHc5bFhXU0cweFA3c2pZaTJrdUlib0NTL0NP?=
 =?utf-8?B?ejFiQ0pCUHV1UWlMUDBVRWx0dGRsV0JXb3VnbFJab3UyajloOWZtRFpHYUMw?=
 =?utf-8?B?REhCVE1vWkNrOHhyTyt5eE8wbXJRNnJKMUFNTXpaaTRYYnhrTlAvTUhuUU03?=
 =?utf-8?B?R041OGFER295YlJNdE4ycVZJMUVlNXllbDVWUWZkb2RNUVlpdGhNRERzeFI2?=
 =?utf-8?B?Um9VSktTZWtVbkx0VW9nanJvRkVBaCtIYTNuTlFNYmhMbDIvZTJ1MmJ6MzFh?=
 =?utf-8?B?ZC9QMm5MZVpzcnRQbmhjYkxPMG9pcHRqT0kxTklIeGp5SlZJekhTaDNSM1Jh?=
 =?utf-8?B?MHdEc1RWVHQycldDQ1QrMjdpRUk2U2RHeW93aXZUL21JemxkME9LUHpPMGE4?=
 =?utf-8?B?MTZkU2VRZXJMay9rSFhmU1Y3dW5iSlAwemVrWEN1YXB2NGNQWE1KbUwwaFJV?=
 =?utf-8?B?dzF4bjF4cTVTejFvdmx6SEZ0ZTBPeHBsTFBPd1NvMHNoN1kreUUrYjAxQk1n?=
 =?utf-8?B?UjZEdWY5RnRzT201b2lNZDBOc1NiQTVPbFJWZEFZOVVoYWhuUitSOGJvSFg1?=
 =?utf-8?B?cFZpUnVBcFhiQllsUWYrVmdDNW5JYjFwR3lqZUhvWU8zaXN3cFIrVithRFRR?=
 =?utf-8?B?dWhEdnRBOGZtZEFXcUtmNUd2ckJiTTd5UXVtYi9jY0J1dWJFbndLZ09rU3Jq?=
 =?utf-8?B?NU1Ja2Q4VThIZ25kOUh2TDNMTVdTS0l0ZUZyOEVVZThZRHZyVVVrWnc4YmU2?=
 =?utf-8?B?cmd4QWg1LzVITmdLakVOQ0dXRVZzQllQSXZ6RXdvVmE3SDRnUG5nTDZrQUdj?=
 =?utf-8?B?QjVGRkFZZVdjN01WY2JzSzkwRTQ4TzJ4UTZoalRTLzVqZW56Q3d2d0o0ZVBp?=
 =?utf-8?Q?IS5nF7DaBgEON?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXNrUjJKdlZoUDZQMHI3T0J2ZThrQVpEcWhZRnVna0Vwc0NBN09wS1JicWlD?=
 =?utf-8?B?VXJLOTczOEdYbTlKZ3Y0a2VjcmFzN2VJbWFuSlBjUUoveXlCNEU1OEtVcUZC?=
 =?utf-8?B?QmxlejFKRDVoY1pkb3FBM24yRG92ZEZERStZQ3BWODRjd2UrRjhrK2ZtUGcr?=
 =?utf-8?B?cjc1blhPQXBpc3NMZ0diR3VCVGlzM1JUeThQVFRjV3NjRWsyYVd3SU5VMU9z?=
 =?utf-8?B?UmJ3MTdHdjUyL0ZOQmtQRzhPRGs0UjBRbWFrK3poOFlXZE5FRHhQajJxYzc1?=
 =?utf-8?B?NFhUSGFmUU0zeElhc3Z3NnVJMHhZcVFPWUdlUXR2OHFDNWIwczNTQjlBaTNS?=
 =?utf-8?B?bXpCTjM0NTBZVEhNREhCYWFXL1BIRHc3R2FYODB3SDFDRDd5aCs4TjN4dysx?=
 =?utf-8?B?bTkwTU5qYXRFWjM2NG5iUzJaU2R1TVRrbFROei9xckdWaGZ5NUtwWStDQnVF?=
 =?utf-8?B?MTM4eUpVeHREejI4UkI3YitvQ1JSTCtDTitCQWFjS083a0RLN3ZOZHVsc3Bq?=
 =?utf-8?B?Z3RlN3lEeEZFaWkrWlc2LzlLVTg4UkpWVTZBQU9WaXcwMW94RTlLcG9RR1VO?=
 =?utf-8?B?R1Z4Y0J6V0FlOXp5czFlTlE0UEZNUGIvalErakpkMmJIQW11eGxwR3Y4Z05l?=
 =?utf-8?B?VHkrQzk2U2tZMlMzdnVST01INTU0RkpTZ3luUjhmdSsrTmpRaDBkSWpPeWtO?=
 =?utf-8?B?MUIrc1h1TksvVWVKWHg5emhnQzhzaTU1MEYwNEdrM29jUTRTc3VXNXEzZFln?=
 =?utf-8?B?WHI0SWtCVXFoeVNOVnlkSmdFM3kwaE1rS0pid2xWckpYQS9DVndyaFZyQWJN?=
 =?utf-8?B?anpmaCtXeG9iSENuU0Z0YlIwbFVwa1lYMXBoZ25QSGwrUVpxZkNublltYS9K?=
 =?utf-8?B?NmNMQUNCcW10empKb291S1cxTmF4VWRNNG5ibUh4Q0x6L2ZnWi85MEZ2ZlMz?=
 =?utf-8?B?TkZHL1RaZS9JdHhIQ0hFbEwwMXN6TFFsRDZaOWhMVlpoYmw4d3dSYXNUcmxz?=
 =?utf-8?B?dGVucUs5MUZJNUlPbWRlUGV5SGcrQ3MwQjNra3g0R1NJd2RXbEV4d1VPUFJ0?=
 =?utf-8?B?aWlJR0ZVU0tGcGxVNThJc05GanZOZkFkcWovUWR3SWI1RjJCSmR2UW9JNDlN?=
 =?utf-8?B?SjVraUVjL0JIYWlFK2ZWWDljNS9nNlg4UjBwYTgrbHJTY0hPTkJtc3hvb2xV?=
 =?utf-8?B?OVhGbm1nNEMrQmNKa2xiTGlaSEJjdmZLQkh4SXdTeHJpMWFJK3AwSXNmWDZp?=
 =?utf-8?B?UUpPaldHK0FWSWl0bTJ1M2VJeWtJelVWWlpTVi9WM3hxb0d0WWZyaDIxQytX?=
 =?utf-8?B?VmNpZVhFL1NpbEFqc2QxQU5UTDhPd211SE1GSVlJVHJKOGdINEorOXRPMmpq?=
 =?utf-8?B?dzZJOWY0bGpqZU9kWnB0UkhBV0VmUHF6Z3h5ZmdQeHh3SnFEbVQxTGxWaG1C?=
 =?utf-8?B?Z3JYUUUybjJqRU5qZjh4Q2ltQ3BlMGoxS2ZCWEFsS2pyME95SmcwMW84S1RX?=
 =?utf-8?B?K2RDUk1oUGxTNGgrRjNmaC9NelpxclhlN1czR25ac0VCWE42cC9ITkUvcTR3?=
 =?utf-8?B?M0xNTUthK3cyeTVudFJqcW9KNEUyeWhTT3V5NGdURTVXcHovY3diYit3anZY?=
 =?utf-8?B?RUlZMWRJcTRpVGk0eWs2cWN1ZHdYdTltNnpESzZ6TEZlcEdvYkNXNGV5V1Fu?=
 =?utf-8?B?T0krTzQ5d1NNNm5iOVJCNHB4bTJRb3hNQlRLbEl5eTg4UXRJb3ZlSk1xSUJa?=
 =?utf-8?B?U3BJN1VjRVJyVFZzaklTMlBKMXE4RTlvb2wyRXJGSTJra0pxbktCampmUUVl?=
 =?utf-8?B?V1pOM1JMMWxWeGYraCtWdFdEUGhUakVsT2FMdXhYMlpPM2tyT1hQYkhoeHBq?=
 =?utf-8?B?RzFlZlZkOFRVRXZEaUxOMUszSGllbkYzRmZ4dndLRTBhY3FYUXk1dU9EcjMx?=
 =?utf-8?B?QThpSFBzbHBBanZkY1FvODEzckpMRlM4WUNaNUc3SWlrRHhOaVlKcEtzRlc3?=
 =?utf-8?B?S1JONmdPUkE4VzZqMjNWenJ6eEgxTCs1eDdaQi9JeFcyS2tER21nNnZDbkdj?=
 =?utf-8?B?S3hyVGYzTEh4ZVJzc3puMjgxVVpHOE9Td3VtY0JVM2Q5Vm04NnZFbEdHMmVs?=
 =?utf-8?Q?rb13RG8n7U9accwXnCDAJpaBR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d2a7af-0425-4c7e-161a-08dd1f23a849
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 05:20:16.8287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UWHwTT+hReJ+8pbdtvY6rYl175LmD6MWBpPY6698hs2UVxbcv1PWb8tJT7SGtplmQCVi0f5tGwVYXWNl1ZvGHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7956

On 12/17/2024 4:27 PM, Borislav Petkov wrote:
> On Thu, Dec 12, 2024 at 10:23:01AM +0530, Nikunj A. Dadhania wrote:
>> @@ -1477,19 +1480,13 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>>  	case MSR_SVSM_CAA:
>>  		return __vc_handle_msr_caa(regs, write);
>>  	case MSR_IA32_TSC:
>> -		return __vc_handle_msr_tsc(regs, write);
>> +	case MSR_AMD64_GUEST_TSC_FREQ:
>> +		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
>> +			return __vc_handle_msr_tsc(regs, write);

With the above change, non-Secure TSC SNP guest will return following error:

$ sudo rdmsr 0xc0010134
rdmsr: CPU 0 cannot read MSR 0xc0010134
$

> Now push that conditional inside the function too.

With the condition inside the function, even tough the MSR is not valid in this configuration, I am getting value 0. Is this behavior acceptable ?

$ sudo rdmsr 0xc0010134
0
$

Regards,
Nikunj

