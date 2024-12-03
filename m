Return-Path: <kvm+bounces-32958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1C609E2DFF
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 22:22:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BD5216027C
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 21:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C16D209F53;
	Tue,  3 Dec 2024 21:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wri70wNF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2080.outbound.protection.outlook.com [40.107.102.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26641D7E21
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 21:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733260875; cv=fail; b=UqVI/YWyHIic19pcX0R5h6DETTGSaITmDdLVDBaJm1kXfaQheNhhL05jgvdZUkI4XxsAMK6pLbtiQiwOxZNtvaEL8O442KS9NDNADJ8gR8zR7QFCcun/44o+Ix0Db0LTp6PX7EwvjnMINEERyOqGgU/D04Fwx2x9beY0SuyhFQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733260875; c=relaxed/simple;
	bh=AoVVqT11tmubGGb0PlC9c483UYzXTiUqy0lf3GZV26M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I21BHo1YwofxQEL37Hwr/n3Vsf/hUPshtu6jq6nf3RQ1IhiKRS8WyRnCAco7Z7k10JK/de2Htz8MUbNnYpu6CFSOd34GHFFsXMRKTKOcCf6+Ja8sy0zi+kLj3MYW/5/xNNlaj6dKp+JtCh/N2nL/tiSwHnvSf91jtLDt6v/dhmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wri70wNF; arc=fail smtp.client-ip=40.107.102.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sik8c7xVw1PXl3RwDoaOolco5zkwlqpyWRcHc3OpDdsACZQOTm2IURCtFR9RtTOeROvEbEzS/Ga905uIwnNn6HGeCm5hsu58l7BtOrmzEzMigMel/+I+xFJdo+LSVgpa5zlTKok4IEVaCMk3kTX78sHW40FH8bS9NuH+euRzyfjrJGTkNn2i7ig4lNmDlpUgBlyhdCrh1vnDq8R+GDPs+crrMb2McWdXa1+bWhDGONygsIQYt8Wo0yjtlRWVTkoXJvUSQ81eOJkYFyET/7a2g8EJt2kFFH857njGK/ym0RCHiRzykp0vtHnHAGs6UH3f12glIjZO5O6IwXQOYIjTZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nAmHZJUG/tua6E9f34wfFdVqR+QOnjneRzPRHkIICeU=;
 b=mctalLSJzEJ+q3TJnapE3Krl9HHZz2UwIX+Xue0yfEbvFOJvwQsluhUO1bvXHSHtzzxeOJ4prTeQL6RuuFRVXqbrVcGJp8p2ONlKOwB4wJ5iMX7+VJBGpSrNrNhyenDWYuvLurL7YlyvbW7strSiIfHGdJ3IIQfSC8FFBONPfk2DZEwHnURyWBRJyNBgbKHCbxukXG8yF8cIt/Y8RTIy9vs2eP9DlpxvmisJo0UhlezDW1UEJx3FOKyorRsjGJnYbqEi0+EuAz3Auld7ydOauZpz9GxSF+xXdE/sr8jGCRNI73Ukxbe/D/71geGLB02GzRDpBVRkyskPk4H4uA6MRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAmHZJUG/tua6E9f34wfFdVqR+QOnjneRzPRHkIICeU=;
 b=wri70wNFaAudkptPGPqHGV+7SB+1Aui8eoCJenCD8S1lJRhsIiMAa672mYs4A6+Ogar/njLsk3UNvdDepXlGQAd2MVdC5/hahqvqJNXJEb9z08tkNCU7E3fpQPHf6hLI/31G/5QiiPXteQ6QEw4KZGZ9OKPWp5ogJ3gho8q9G6I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB8443.namprd12.prod.outlook.com (2603:10b6:8:126::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 21:21:03 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 21:21:03 +0000
Message-ID: <fa958300-ffe3-8794-ea5b-d52d8e87691c@amd.com>
Date: Tue, 3 Dec 2024 15:21:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 08/15] KVM: SVM: Pass through GHCB MSR if and only if VM
 is SEV-ES
Content-Language: en-US
To: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
References: <20241127201929.4005605-1-aaronlewis@google.com>
 <20241127201929.4005605-9-aaronlewis@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241127201929.4005605-9-aaronlewis@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0112.namprd13.prod.outlook.com
 (2603:10b6:806:24::27) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB8443:EE_
X-MS-Office365-Filtering-Correlation-Id: 3233aef2-d3e6-4197-cdd0-08dd13e06437
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dU9pUEpCV2l1SGJ6cHoxWUhrRG9uZkx4a2lkT3poc1EzV3BhT21QU3FZZmVL?=
 =?utf-8?B?VWxwVE5sWjUwWTUxMWg1UEdGb1BGck1sVGhQdktEUFVJQjd1QlVXTzc0QU9i?=
 =?utf-8?B?R0pVQlBKeUsxeHJPYTVWMVJZVGYwaURuSDZYdnIraURCWHVRMXNEcE56NFF1?=
 =?utf-8?B?YTVVd2ZnK0dKQnh4cnpqdlBCTmFVR0M0ZllBc1NlMjIzeWRqVUdqN0ViQ1dt?=
 =?utf-8?B?RDJ0Vmk1RHFZTWtJbFNjZUJzRVBqc1lpcUpHV0dLUVp0Uld4VUVNakM3ZzNL?=
 =?utf-8?B?UThuL3o1SFREN1FvbTN2RGFvNUYwdzZlRE45cmNtQ3pDTkppbEswOVRKWjRG?=
 =?utf-8?B?WXhzSVczZ1Z4aWpER09BVFR2K0RzQ0tJamhvalRZaVJBWElSbkpPRkYrTWZx?=
 =?utf-8?B?cXphN2ZVMHRxRlFycDV5YXlTY2srT2lMUFBFOWtpbWFFZTJNcHVML2phYkJC?=
 =?utf-8?B?OGpLZFFaUGx0bTVNVVY3VFBkc1YrMjhRamVwVXJFYmcyU3J3dUxDa2dhTHdx?=
 =?utf-8?B?azBWb09QUnZIK2szNzE5YXYyZ29reFNiMHBVZ0FlWUhOMWZDbnlkWVVvQ1Z6?=
 =?utf-8?B?eDEyNzRKK0VQc0ZLbUxuVjkrTm1CUVAxUUwvWHcyUXpKdkh3NWNoWFBveGdQ?=
 =?utf-8?B?TUdZY2JxclNnWG11cWRwKzVRY3dMbG43SmlKTVdGSnlMNm9KSFF5Vkk3NVVh?=
 =?utf-8?B?NmluTGJwMm1sZ0RIZGJUZjFKbzI0YUorcXMzVDd2eDdlWkJTWUlEZ3E5VDVx?=
 =?utf-8?B?c2xoSEFjQXhjTmtvU2Jpakk5MDh2d0pkckFBSUNGVEVPTEllNXBoVytYNkJz?=
 =?utf-8?B?dHd2NHJ4N3hveHhIbHpQS2RMbTJRbURwN2g4STFyRWdiZW1QQ0M1eGN3Tnpx?=
 =?utf-8?B?MXZMTEJLZjVMYTRvVzlnMTJvYnAvR2JPZktWa3hOOXBYTWdVaHF6Wm8yT2Z5?=
 =?utf-8?B?cTM5Wlh3M1JvMFNvSHMxVi9NZGhjcnhZQXBjRnNtTC9IUlNDZjlXekx5M1Ay?=
 =?utf-8?B?cWU3aTRjQmJrM2pLTHVxM1E3K2xoQlh2N3R2RVNNV3hpSHhhN1QvY1B6YzZF?=
 =?utf-8?B?RjQ2L0Z0ZjJFbjRtZk5qN1lIbnNwR3d2cWIwdHRibzNlYlNOYlh4ajhlVUsz?=
 =?utf-8?B?VzNSaExXK3ozZFZvdmRBOXNDbVpvdUUxZDRBZ0dsWlNsb05qY3dqUEgrL1dO?=
 =?utf-8?B?TjZWbVd0aVIzeVdmTmFEc3R2ZklDUjRONTZrSk91TldSanVvdVZneUN0V2pC?=
 =?utf-8?B?cFJDcFN1QjNhbjlYckhqeExPRlZsTStCMjJINWJNWlJVMXM1V09MU2tuMjg2?=
 =?utf-8?B?SEdSYWkvOFFXajRGWk5HUEI0TkVoazViZHFlWTZEUnlGVTJwNXBDV2NHWXdB?=
 =?utf-8?B?SWM3c2ZsMU83L1RmZm1WZG9EOUdwcVVQdTJsV09QQ3YzakNsejhWZEh0c1Ew?=
 =?utf-8?B?U09aSGQvTXdnNm5yMExvN1dLaU81MXZVZ29OMmVXQllsZU1NUnVVZEhrNy85?=
 =?utf-8?B?NUtNNHUxRURsc043SklORVpvOHcvdXdxc0VhQit2OGtPZDNuVGZyN2hSZTJL?=
 =?utf-8?B?YXVPY1JtelM3M3QwUWhlUS9TcnZ3ZEIwY0tsWkdhTXZMVXlSVDJMVnNkQlpU?=
 =?utf-8?B?WXI4M0ZkRy9IVVNqS3Z4NjJPZUxCODlwOUtJcnZNZk1taDRtVngyMlBmWnhx?=
 =?utf-8?B?K0dFL2taaDBDSmpvVnN5QlczRjJVMElMV1NRN0NZRTlNNzR0T01UYm1PTHNh?=
 =?utf-8?B?SmpSV1hsVldkMFVJc2dXMHZNaks0Q3VzZjhJZW9PSDRMbXRDV2I1c1lhdU93?=
 =?utf-8?B?dEdwRmVsR0lBVVRTc09WQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?anhnREpHZm5ONmxweHNoU0N3RHBkbThLSWFFNXE5WFNKeUxSbHFhYnVXL1ZD?=
 =?utf-8?B?RHRoUVdlMFY5N0tBeCsyRVFaRnQrZ1lWWWlSNWZSUVMvYWlDNkhoUkwvSFhT?=
 =?utf-8?B?dTd5anBLcHRYYmRzUGRYMTIvVFVsaUM0aG4wejF6SENUYTQ1TTl0a3ZCNTBv?=
 =?utf-8?B?ZmJHMEg0bUNaNmNuV3FXQzhreG5VUGZKdlpaY2ZtNURFUTd3M253QkFhL0do?=
 =?utf-8?B?TlVNNWVCQlNld0tVQThZTlhjNDRsYVU4VXdVdU9wM2lnTUZVd1hqaVFNRGFW?=
 =?utf-8?B?VDE5bFduNVZra0FXdy9iNkdnUFRBdlN6OVpBeXgzYUdLNmh5QnBUMFdiVzk1?=
 =?utf-8?B?QkMrODdhQnpETFBESk56S2NSVzZHUHZ4emNZa3Y0eXh5TGpDMzlmZjNLVFVL?=
 =?utf-8?B?YkZocU5QNU5WamdSK1pEdU1Ic09zRXZ4M3J1SU1valZBTWNtNlVzL0R3V2tM?=
 =?utf-8?B?YXROT2dsZFU1MkFGT2xJWkRqdjN6ai9ld09IRm93M2pJK1VJczhnenFIOTVG?=
 =?utf-8?B?a2Y3cHVFZmRyM0lScVJQMkJuTE5VZEpmZ21ScGI1VUdHYVpGTXV1RnZOSVEy?=
 =?utf-8?B?WFVwSHFwSklWRndwaWs0TGtqUHVCa2hnR1NhS25MNmlEcFY2OGN0YmNSNnl1?=
 =?utf-8?B?ZHR6MCtKclA3REVoNmpOK0V5RlMxcG9KZEVFVVRLdElrbm5zcW12UE9DdXBi?=
 =?utf-8?B?akNac0J4NHUybmNWeUlYT2lxVlZsVlNhaElRSmZxNlNJd1RSOVJ6bXJpNUJR?=
 =?utf-8?B?RlNYSEZYWHp2N0ZzUzFsSUFZaitjZFZSaS8xcnovMldMUVBOM0FJejRmejRY?=
 =?utf-8?B?b0hJdlFwdUUrc1g1aWcySGwrK0tycTcwcml3S0ZoOW9vV0JBUG5Vb3pzc3N2?=
 =?utf-8?B?TWJod3NUNTI1Q0luTkhjVEZiK1ZQdXArT2Q3MHlOMEkwQ0RLVHBvRk1ZV095?=
 =?utf-8?B?dytzeWVBc0hGR2I2Mi9KT3V6ZEJmL2NiaHlOdVhBTkNpdzM4QkVWM2p6ODRn?=
 =?utf-8?B?ZDBXMkFscmN1MjlENEpYUnRReWxBMkZGM2ZDdUxxeHNENGgxd3dkWndFRk5J?=
 =?utf-8?B?VWNGSDYxbGVjWmwzV2hMeDlzby9WRjlULzRBMm1ESDBjcmZhN29tUEV6SEM4?=
 =?utf-8?B?enN4NnZ0N1BYT2FXNnlFdmFKNWdMZDNjV0l4dG1WRkFQQVMxWnFCbkdESFdZ?=
 =?utf-8?B?ZDRPRzhzbWRsUXBDZnBvOUYyUEI1dnZaMDFETDJjVVNCZ0JHd21EVGtMMlNQ?=
 =?utf-8?B?NVpNUTI2NXdlb3JSRE93VlRWYzlucXIweUJrdjVBYWtadEM4NGVaSHBMUk1F?=
 =?utf-8?B?aUZ0dExrd1Ird0MzVklHTkFoUXhacTNPWDdpQXFWRSswcDk0RytWcnk1YjdK?=
 =?utf-8?B?WWpTUURkSmRuSDh1UFJ6TXRMblZ0YTFXUGZVTk9KenJyc2UwYnJldFdRZjJ3?=
 =?utf-8?B?eUN1M2cwQTEramNTek0xNVRDSmRnaVY2aVFPMS9HN1Zod2dDeHgzbDQzZVU1?=
 =?utf-8?B?ZmxUWktPbTB2b01QZlZUbDdZOXJURThRczY2dmRCVnNEYlFUQmt1S0dnWWVM?=
 =?utf-8?B?UEdJZ2NlK0dvejNSNFlhTHpXYVVCQk8vZlF3QVQyRGVTOXdxdEVqYXRvZ2gw?=
 =?utf-8?B?ZWhYVHE4RHRPMHdRVENCdkNWZmVTcGdrc1BnNVMxcEFVblpMQm4zRm5PMkV0?=
 =?utf-8?B?cmtWenFuRWNWcHR2SXYycG0yN1hlRHVFVGM1dFVNUVBOcTVhcWJsTG1YRG1p?=
 =?utf-8?B?UURBTDFhcjVGNk9QQUJZbUtEeUN0VGdndnNkSjZoK0JwMlVoeDVhZkU5by95?=
 =?utf-8?B?RTM0bStOUnRJNllkN0QzSWhucFpUV3QzNC8wYjE2OCtDU2wvZnlJQ1FnN2Mw?=
 =?utf-8?B?dnhtRHc1d01laVo2U1laMVJNNXRFREJPMWYxandRays1Y3lscXA4NE80Q2xG?=
 =?utf-8?B?QzIyQ2VjeGRvc1FtcVhpRWJrTGdDU0d0WWJnb1RmYWdhWVhrbXlnYXplbXg1?=
 =?utf-8?B?bG16QzNid2ZOWGpiQlM5VE40LzZPRTVNYisydHY2NlNUeHAwVG5uK0Nwakcx?=
 =?utf-8?B?bHd5ekhTeWQzc3NFSDNMUTl0a2NnaENlb3Z2Y1FVYmlkQ3dBL2FGdkkzYjhu?=
 =?utf-8?Q?GH/O5fzSEmqmAqp+4BayGHPwT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3233aef2-d3e6-4197-cdd0-08dd13e06437
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 21:21:03.3349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RDdKtNLAA4qanCvecjowMaFwTdODIiOAqj+wAOh2fYKrI+iuva5Ikci4jYF0k8F2i6hzdKq1ng4ob2SlTXSWXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8443

On 11/27/24 14:19, Aaron Lewis wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2380059727168..25d41709a0eaa 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -108,7 +108,7 @@ static const struct svm_direct_access_msrs {
>  	{ .index = MSR_IA32_XSS,			.always = false },
>  	{ .index = MSR_EFER,				.always = false },
>  	{ .index = MSR_IA32_CR_PAT,			.always = false },
> -	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = true  },
> +	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = false },
>  	{ .index = MSR_TSC_AUX,				.always = false },
>  	{ .index = X2APIC_MSR(APIC_ID),			.always = false },
>  	{ .index = X2APIC_MSR(APIC_LVR),		.always = false },
> @@ -919,6 +919,9 @@ void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, unsigned long *msrpm)
>  		svm_disable_intercept_for_msr(vcpu, direct_access_msrs[i].index,
>  					      MSR_TYPE_RW);
>  	}
> +
> +	if (sev_es_guest(vcpu->kvm))
> +		svm_disable_intercept_for_msr(vcpu, MSR_AMD64_SEV_ES_GHCB, MSR_TYPE_RW);

It would probably be better to put this in sev_es_init_vmcb() with the
other MSRs that are removed from interception.

Thanks,
Tom

>  }
>  
>  void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)

