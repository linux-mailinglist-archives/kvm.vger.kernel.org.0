Return-Path: <kvm+bounces-28228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7E989967E6
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 13:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DD86282EF7
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CA7C191496;
	Wed,  9 Oct 2024 11:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MRnb14mU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221DA156242;
	Wed,  9 Oct 2024 11:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728471628; cv=fail; b=b0tERJQGyEDc+P98fIM0wC8chcRTAXHm4HHfEP4c/erHsP2bobuxW+tDb7BHnTAro/lFyySyuILY+p/vWRRKcmsZi93jX8r3lZacbIad8oQPVl6C5uUkStoNTQLpM6tOoYVeQHnteHMTIR0AKozjFewLFTMO1L5uTPotISmrvIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728471628; c=relaxed/simple;
	bh=FDiIr+kZQazKD1xgTuNL/xG3LvbsLXRbuYI7h0sixUs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C5xT+4oMnbElLS9YcadSWQjT+MjhpiC7CWVoQZnO2pvZufR6yHSQ11NwKIN1d7Ca1/IHOqiwJc6ttqh0h8+BZNNxwq+TvKGyRnfao5BHdQQI3E6iXr6YrvmbNDkaveU+HG0Ay9wD2O9xjscjSm0L+4cixrgrCXW6yiGTV2P34bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MRnb14mU; arc=fail smtp.client-ip=40.107.92.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OLvmMmvc6eXjUKDhqnJMOMcNroMsn4oZh7c7E/x1oK/aAshcAY4+e/7wqFaVTxU126Yh7E/K2WE7mhMa6qX2jzEYPwz/bAv6I+DAXmmX0iXiNATMMbgMLe/XUExBanpr/4kvZGW3I+y+59q+uKwQr/xMCRbpY7mgkVgH5KBwFBfh8ESf8BJJylqGrj4aOpo7L5OyQuJqnE63a4++dCvk2nMcPIcbmaxNYxXXuDOT8cAKsAg0vfHyhYYengnB0FUCJ0PaXJmcagcWka/ThHXLfW5aMUHNymkpiWhzLea1u6cBAdD8veD+DijD2dJD0Y5ohdeaWfla0g4tlHunqaeMRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kn1jzqkQEPGX0DDVB7FM1+WSUxn0uSv9gz47QQ0be8k=;
 b=ac4ekja6dC55Lhg0WGQxSkqyjsmquza9BI53nfgI0wayf/c1F5E7G9DmRtk4XTiouc94nrY3AU1mhxeTEiQAzXBXIy0+0DDvckhIeqVM/tYsEAfpIh222CuuQm6lS5pN23IHCXU6EisHTblub+8prTUbOoqKxif/L7nHYwPjxXSms4q1WJX+D4qF9dslai3CQSyCLY4rNUNOxEgG5XENyQ+SJfS95pf4yT/xARhJSDHX36y+BwiiZ1LSd3Uz4ioTDaUKKkm9IGj8ocHPaj2jgKr7pWFwrSpqo8LzaW4vIqnaFPpPwVe3jYGu8ifqGuUPqRG1/FnxBLanTzG2y62nZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kn1jzqkQEPGX0DDVB7FM1+WSUxn0uSv9gz47QQ0be8k=;
 b=MRnb14mUzNwvsNf94oRXLSirF0p4gpTwv6bgQuumPtIq6HndGdQ/Y0HW/AuSTfDfsP2t5Gfbz4tuanCFL+jFgUcU1pUTK4WIFQOYv6c/pn4LwmE4iG2VbOVQzUTihiTDKA6kqm+s4nnMtknq8s/ch7mQsDDM1UmDYlAjC+CwoPQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CH3PR12MB7667.namprd12.prod.outlook.com (2603:10b6:610:14f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.22; Wed, 9 Oct
 2024 11:00:24 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8026.024; Wed, 9 Oct 2024
 11:00:24 +0000
Message-ID: <a3b2fba8-9356-4f69-9214-8c3723d6c919@amd.com>
Date: Wed, 9 Oct 2024 16:30:12 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <20241008191556.GNZwWE7EsxceGh4HM4@fat_crate.local>
 <8d0f9d2c-0ae4-442c-9ee4-288fd014599f@amd.com>
 <20241009052336.GAZwYTWDLWfSPtZe5b@fat_crate.local>
 <a1b2eba5-243c-4c7c-9ebd-3fce6cd4c973@amd.com>
 <20241009103821.GEZwZdHeZlUjBjKQZ5@fat_crate.local>
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241009103821.GEZwZdHeZlUjBjKQZ5@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0032.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4e::22) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CH3PR12MB7667:EE_
X-MS-Office365-Filtering-Correlation-Id: a4d63031-9be6-4ef5-b512-08dce851931a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TVdOL0FrNXVDUVVTV2R5a1djRXNRVHQwL1kyNXh1b0Rna3k1QzVRNk9PaHd4?=
 =?utf-8?B?S2xFbzlFNzh6QWxkNmdBclhjdDdJNFJPSmI2MStoZ2lOLy9nRmxQdjNXWXZ2?=
 =?utf-8?B?bytFRUt0alkycjNLRnlJcGNzSXlZODhIRDA1b1cvOU42eHUxRmtwSWp0OXh3?=
 =?utf-8?B?OVFuQzFaWm9FODNpdXVYdVhRa0RMZGp4MVBFc2FmblBiVVpuQkxpSW5rYXN3?=
 =?utf-8?B?cGlPdnQwelUvS1BxYXVnZ0tRL01ISEdPb0VOTHAwL0dIZ0Ztak5hS216Wk1k?=
 =?utf-8?B?NGNPNFJpZWlXMGdXWW42aVdaR3F0TUY2UDc2bThXQWZmZzVxV2ZLTSswR3hJ?=
 =?utf-8?B?dVU2RjlBLzFUTkhETWtaU0ZvRHlWSGNVR0tkNGZRSU4rbzNiOGZrdWJqelBh?=
 =?utf-8?B?SkZLREJPbWFCdFh3dWV0MWFSbXduTjFhUjI4cjRwd0tKWE03ZjZLcW9Ya2RM?=
 =?utf-8?B?UWhPOGFnL0dOMCtueHM2Q1VuNUY4U1BUd043NVFQUUJORzlYakR1MGdxcE1G?=
 =?utf-8?B?czhEYkVxeHVGVHdWQzVoLzV3ZmdQR3czSUE1ZGJXUm0zKzJmM1lhZkRseUU3?=
 =?utf-8?B?ZlliQ2lMSGd4OE9BNWpLcVI4QzRJekpaNjllTXJGUFFMWTljU0JvejZmTll4?=
 =?utf-8?B?RklCYk1NZzV6QTlPUzlUdys1MEMwSU9MSmNObFVrUG9jVFdsd21qWGlLMTIx?=
 =?utf-8?B?cjRzcHF4V0twWmV4M21wSGpQRUJLa01rUEY0cjB6TjIvK1o1STRBcTg1TGFR?=
 =?utf-8?B?ZjBNYmJPSnVZS3cyUVpXTnNEb3QzTU9iVFNrRWgybHVWcnlYN1Yvc2JzMEcy?=
 =?utf-8?B?QXNXcWREbUYyM3g3cHR4b25uL2g4KzhEUE1URzZTelJBSlI2UEVjVUFLU2Uy?=
 =?utf-8?B?Sm5SRWxFZ2NlV3NKTnNSVXIya2lmY01vWUJGRERKR0hTVU11dlRXLzNGSDRI?=
 =?utf-8?B?NnhERnQxam1DSlhkeHJiYjMyVzNRMTZ5TUcyK1I4R0RBN0c2Syt2NWx5MGtE?=
 =?utf-8?B?Q1ZtbTlidTJrQUFMU3hYVXhqNHMwZkk1c1NpdSszRko1UDZHWHdROTZsK29H?=
 =?utf-8?B?aUZEMTdnS2lCZEt3K3plQzRaWXFhYXUrTzJCUHpmb0dyYkc3Zmx1VFBqQkdY?=
 =?utf-8?B?eVRUbUF0ZncyWitBcXZIa0FrZ05UZ2g3QVg2dnN3NXdmY1lyMEpuYVJDY2JE?=
 =?utf-8?B?ZjhyUkdqM3BGUzdPRVZXYlBxL29oSC83K25ZMmlCSEF2WndWOTh1SkhHK2Na?=
 =?utf-8?B?UURtNEh1aUV0aG96dUpqQTFJVkRNaS9jYmZhdUVwc3JDeTR1UFlPRDduSEdz?=
 =?utf-8?B?QnVXTmlEMmVxZTVLdDNUUFpDdlBPeHorZzMveHdQYVZEVDRRS3lLZ1d4S1Y5?=
 =?utf-8?B?Rk5hS3ZzeTlZQmE1U1hhNmt1Y21WZXg2dVZNQVI2dlFiZzRkYXZIU1pvSlpw?=
 =?utf-8?B?cHltNHhFYXpNcXd0K0VJdVN3WmxxdlZ1ZndEYUpwTmc2QXgybFZZVXVUNHF1?=
 =?utf-8?B?NzEzVEQvNnM5aEVVL2xoNDFqM2t6aGovUHdMd29KaU1udXdhYmdFbXZ0SmV5?=
 =?utf-8?B?aFNqNHRuQ3B1cG5EMHNZbnlrbUZkZnFCb291Ti9hSEhoUjlXVTY3aGVoUnBW?=
 =?utf-8?B?a2R4UWRKZ1ozU2RjdkFQaHJzWERhVmg4bjVIaGpwRWlBYWJzVC9WUE1KS2dl?=
 =?utf-8?B?NHIycDFCc29QNndPOWtlUTlMS1NCRnVSZHlQN3BtUUJDcjg0MHV5c1lRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Umw2SEVqVVJDMno4SytzWldWdEZhV3VjQWpQdUd2bGMxSmtsSFlObTR6cmNw?=
 =?utf-8?B?NHpDSFJycGFDK1h2S2RNZVZkT01Db2NrT09tNzBZL0pmaEdlMDhsQVJ3N0Vw?=
 =?utf-8?B?SUtaRm1pbFZRbm9Gc1pqQUFwbytJNnlmanJzTTVoMUxJRXBqYUlXTUVORTcr?=
 =?utf-8?B?U0p3bVlvZGZtbm1NUEJ2ZThMR3FvemVMU1BKNGVkNGdXTFBYbG9KVW9TWVpQ?=
 =?utf-8?B?NWdTSGE1ZFZwV21ENkdobm9lQjQvaDBxZUZuKzh2a3pTZ1lJalgwUzRVNENH?=
 =?utf-8?B?WW9TbXkxVCtPMkV1cWlBb3NYWWs0VTJXOVBtMDhJWXZuR1pQUE5Scis1YWds?=
 =?utf-8?B?TmI0em11WXlYTlRpZFhjajl4eE1PczZjcCs2UWdDamJZSkpaWUFZbDcyalIy?=
 =?utf-8?B?bkNhVG5VQVlmVFQya2JKQ09SMFJOVHZKVzVTc1ZuNGw5OWsyb1F1aE12bW0w?=
 =?utf-8?B?bHR0eTVPb0xmSk1BY1BhdkpHVGFvK3BKaGpRWWpGZXorbGhGZE5hWC9oNDJj?=
 =?utf-8?B?WjlWRkg5Tk0veFlabGJsRzVDa0tLVjI4V0Exdlk2ODNCWS9yNGlnVTBWUGl5?=
 =?utf-8?B?amozZ0svQ3pUR0pqWHU5NlRhVW5FUUJzbmRzYmVvcjZnUnJ1MGNweCt3R1hT?=
 =?utf-8?B?NEl4cXdBdlBMTHFDNFFDV0dONkwzTXgzRnl1Z2RxMVBxMWV5dktYNVVMd25T?=
 =?utf-8?B?SllOY0ZvWXlTY2hKbngrRlhESDAyOXZxMnJPNnpDbXEwRUE5aVpxaXh4QVZt?=
 =?utf-8?B?R3prT1BGeEM5TXQ1dXIzUnZjSWp5VTFkc093SVFIRm13LzJMSVdhUmh5WVZ5?=
 =?utf-8?B?RzdjdUZRWnZ6RTZGT0FKWmpXZmo2TlhnS2hkYjFBbzY1bGFqSTBmSEppTzIx?=
 =?utf-8?B?dzRvVVp0UnN3bUw0dTU3ZUs4cWZwdVcvYkZUdVd2Qk1MVm9oL1ZUNlBxWW9J?=
 =?utf-8?B?UlorbXY3R0kvdE9URWltdjVzSGdpY3B1L08zMnloWHVUU1RKUjdYd0RMZkdT?=
 =?utf-8?B?TWhPc3FEaXlrV3VMaDNrcFhqMnY3YXZLNjM1Y3ZkcFZnSWk3UWt5SjBjWk1T?=
 =?utf-8?B?dWJ0ZmZBOFlIcUgwQy95Y2NuZkFWVlhuT3hJSUpLRXZZZnVJMlhmb2hWMUx3?=
 =?utf-8?B?R2hBOUVHb2xaeVR0VzhHR2ZnTDdTNTFXV3loR0prUndieUpncC8zVWZENmhj?=
 =?utf-8?B?aWF1UUFzQitpc0NnK202RDFaMWVseXA3Ry9mR01yajUrb212RFZ5ZjZUdW9L?=
 =?utf-8?B?VS9sTi90NEx1TE40R2o3WTlPN0Fpem9ZNVBPWGxLQ2ZEcEN0ejhlcVhSdlN5?=
 =?utf-8?B?UG1kZmU0WWJHS1AvVlZDeFlNL3dDTk1FZU5ybVdkV05NaTE3NUdxVWFTYStG?=
 =?utf-8?B?aDloZ1VYbUJ2ZnpFajdIbEVqMmt2QzE3ZHVQSGNMeVY3eGRoSEdyRmxCQVdR?=
 =?utf-8?B?U1Q5VGgwQ3hBcHRuK0Q2Ullmb0MvaWRoaVM5UHBVTmd1andVZllaaVljZ01p?=
 =?utf-8?B?NkpMbXFML3d6RjNDdDBBRDdOd1RvU3RBcGsrRG1SSFdVNEFISUJ2c2dvdjlx?=
 =?utf-8?B?OWZ5NlZ6WUUvdXoxbmlScGEzZ0ZHaTVmNnhHTG9LRkNCNGxrcjFoTXpxc1Vh?=
 =?utf-8?B?WWhPTFRZbmJvQ2tubzhTMVhuNHBKUzREaUt3TWx1bjYyY29VRHMrUlVhVkhW?=
 =?utf-8?B?ay9jWXY2VzNnSVc3WlJpY0xoVk1aVGp2T1IwNUhzUTVObFJGdVhSaVEyUjh0?=
 =?utf-8?B?ZzBRUHFYVnBGVzRMck8xSXRqNERZaHJES0ludVV1VTN4QTlROHVLNzRwUFd4?=
 =?utf-8?B?eCtVb0t2NkhIdmdwckRhTmNteElsTE1Rb1dLS2E3c2JlUW95VGpOVmdWU3RI?=
 =?utf-8?B?Uy9jdGlwQ3RhM1pxUTc4MjBDTi95dVQyS2djZWdIaXlMZGJqM29Sa1ZkRUtC?=
 =?utf-8?B?MTVBckNkLzNuK3d3N1owS3BzQTZrRkk1UDkzWVdmazZWNTVYakErV2VXc2FV?=
 =?utf-8?B?YXB3K3R1cjU0TFdrR3kyTGJxcElieTF5R2V0S2YyWndNSXI2VG1EdEE2VnZV?=
 =?utf-8?B?WVpFdXUwendiYmJvSlRLcmFmTVlFVXcwNkljK0kvT2RaajMwVkdvRGgwd2dG?=
 =?utf-8?Q?YYLu4p7srzdKmFzjAXDDoYSlV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4d63031-9be6-4ef5-b512-08dce851931a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 11:00:24.1519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lSr1c/5jmyOHFNQL3l07ToRyuSgnSxIjd1JDh2KKoT+JgX9rdrONf5oBTAqjIfGku8Gh92GNpxoC/JTCzqjrmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7667



On 10/9/2024 4:08 PM, Borislav Petkov wrote:
> On Wed, Oct 09, 2024 at 11:31:07AM +0530, Neeraj Upadhyay wrote:
>> Before this patch, if hypervisor enables Secure AVIC  (reported in sev_status), guest would
>> terminate in snp_check_features().
> 
> We want the guest to terminate at this patch too.
> 

If I understand it correctly, you are fine with adding MSR_AMD64_SNP_SECURE_AVIC_ENABLED 
to SNP_FEATURES_IMPL_REQ in this patch.

> The only case where the guest should not terminate is when the *full* sAVIC
> support is in. I.e., at patch 14.
> 

Got it. This version of the patch series is following that.


- Neeraj

