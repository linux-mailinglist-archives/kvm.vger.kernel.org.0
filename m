Return-Path: <kvm+bounces-52641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 840BCB076BF
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 15:18:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06B887B49F6
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 13:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F2AE1A0BD0;
	Wed, 16 Jul 2025 13:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NSKAyFzv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2047.outbound.protection.outlook.com [40.107.236.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2F419ABD8;
	Wed, 16 Jul 2025 13:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752671884; cv=fail; b=uS72PNfjT4qDdF2XDxHw25OOfJmPOoq4LJKdac2Ufg8tI36qfHHyof3e/fQaZP0hgQM3UAoUA+SD9X5+wfQNAZ7aQm/Yyxmexw2PkE+XqzuylFDmVSTyk/sFrNxfEwAiUIgpsdJWbwolwcYbcP58AYEsOPhyKrOvOHABk2H2UmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752671884; c=relaxed/simple;
	bh=odlPxOPcrrq88ztJpYbUJjqQh8tiJcvsBI/AF4mGdDA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DJE3mVLsBbdIyfR6NdVbzg0N0EOouae1v7KVGoekUMlVxPdI5xqmj98mprDnGQRBx3+MKnbWfqDwi2XMACSKbdSv5eTzfn/DQ81ErPQEZDIFmcoKh37ox6zqIvBvaueUrCXUCE+rRSxL46MXPM1tALdfEixBGhcChgsqyC8wzQo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NSKAyFzv; arc=fail smtp.client-ip=40.107.236.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lSYohjpX0xFjk/WBQU4rT3KVLpkT+0KdqthcqP6DbNn3mJoGEcGVTtpz7DnVMjM4JdAqewPVlsXhYB1X2LVFHs52rfcP30IAZ7dEg/XC4JVspGKNlnkrrqqdDZ+fsceRN4XJGaGfkNNdAsVqJG7tVJGrSTVLWUHu9tfkwXs73aPtJFePQl1PKzPdKiM9R5MQDBAuwv9dwk+ST99Xl0uEHbBKYnXI0s0ii8qhbGRZOGmTYptfBtFCGE1R/YA0KZ3QaIB0O2hDPFn2Cr1M5ONpKoBo3LHmS2RR1CPvHciAQDk/mom6+4rvqv6pmXNbBYODSCSjWv1yGNE5F6iUIV64Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ImSEoAfXWSi8hjQHLyiXVut/n/oKSlNq6sq2pyYS6rw=;
 b=sQd+ZiiVPAGAoiiqYDBXFibm45mj0ZD4utib2ZcEA0zmHbJ86wl80vHNW7TestPedIy7i/JdLIFLEf0yZ32KVTCH8Zp5bg+/81TQ0MbaMejWxbadVMXpt8A6HBsuy+T+lwd2ZJNKUJNeYFdEL6/DLJ7Wu7VY81ZwVxv9ccQG2oTr/Ct0EOx69rPr1e2MBfX4pAGUIX2qFxBFbJdT3Y88F7hDI+EuZletVfhUlova/Uv1NDiJgXFL6VLa0Cloo5TWcks2+nR5uxjSLIsHGOD7auqZwXZ4sYQiaO/tBZY7SGQhwVTRvz3ImDnXDvey/eR4ZLvhQe3UW5DQiji1GTCM/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImSEoAfXWSi8hjQHLyiXVut/n/oKSlNq6sq2pyYS6rw=;
 b=NSKAyFzvosJKnxiSLRlPjRhvq26diZi/v7ZYP2FOD4yy8p5lSKXE0Is/q0nxaW0gek/Fz0fOjAIpTbEeWCYEgK1yS1mlEaal9BJnihBuVwuK28ObkFM13pJwhFUn+fTPRHpcjfqiVb8WxO5VJFAVXdyQLdV3ZDZ/abYRoIhApCM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA3PR12MB8804.namprd12.prod.outlook.com (2603:10b6:806:31f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Wed, 16 Jul
 2025 13:18:00 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8922.035; Wed, 16 Jul 2025
 13:18:00 +0000
Message-ID: <2d787a83-8440-adb1-acbd-0a68358e817d@amd.com>
Date: Wed, 16 Jul 2025 08:17:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] KVM: SEV: Enforce minimum GHCB version requirement for
 SEV-SNP guests
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, Michael Roth
 <michael.roth@amd.com>, stable@vger.kernel.org
References: <20250716055604.2229864-1-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250716055604.2229864-1-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0128.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::10) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA3PR12MB8804:EE_
X-MS-Office365-Filtering-Correlation-Id: 9286251c-3e4e-4b0b-7ce9-08ddc46b2faf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UDB5YzZ5VGwyVlBVcW5PNVBTcDFhbXZuQTg4VDdHSDFsT0pWRUxidTQ1M043?=
 =?utf-8?B?NGtsUUZ6bUpuUnY2L3lSR1QrYjBtemhyeFBFQTRzQnNSN01lbDFVVFhaZ2Jw?=
 =?utf-8?B?R0hiY2FPTklUb1k5cFdUajdOcUdibzd4UDJ3c0lHVXBmY0VuZThCN0FiN1d5?=
 =?utf-8?B?L245NE14bUhKME41ZzZYTG52eWpCV1BoNUlJdXk2NzY4SDdXNnZ5QXlQSFVs?=
 =?utf-8?B?bklCcjRqWXIxZTBmQm5HMVJwT2NZcGZnRFl1azlWd0EvOUgvVGJEdkFnZld0?=
 =?utf-8?B?YTVKbmExakVzeEpob3h5V0I3ajNVbmMxY2xvN0F4bTUzSTlXbUlDQzFTN3NX?=
 =?utf-8?B?Zlk3MWxGQkQxQTdOUkdyeEtxV2tNNU5JN1ZqeG10NVVwZXJFcE11YzVjU3BE?=
 =?utf-8?B?QyszaWh6UlFsd0dyZkduOURLT2E3L0ZGb2I1ZnBHQzBjbGQ1ZzVSbkl6Mndj?=
 =?utf-8?B?OHdVS3BreGdRWXFOejhlMDdXdEd4cGkxTCtPVk9FRFBhc2NQaEpZSTVXQ1lp?=
 =?utf-8?B?Y1ZLTUM2RGc0bnFJaytPckdEN01VSEtoYktyWkNndlFJaEJXa0YrUThoQzdQ?=
 =?utf-8?B?YlNKZXJXYnM2STMrd1VqL2xud0FESkRNdlQxUkljNHJtc3dMV0djMVJKSWpX?=
 =?utf-8?B?R1A1UlVzMWVGYi90SU4rb3dyVG1URTdyS1hDYUkyZHJ1Z0pTTUVRWXM5aFN3?=
 =?utf-8?B?LzVqM2dLNmtQZkFHZkNiNWI2a3BJY1UvUjYyNWZaU2JsejMvK2FXcXhUZkh1?=
 =?utf-8?B?YjRLRk1keWFJWThVaU5ZdWRuSFpYbTRmQUZ6YnZPekd5bkdBaVMzUzRobFpj?=
 =?utf-8?B?dHRMNHdoZkZjS1ZJTzUydjg0eGtiUFVEZFg2NFBydDNza1hhUmZHT2ltREFj?=
 =?utf-8?B?OGR1QU9UVE9qbWFJcWErc0d3TzhORjNlZkZVWDMwM2RNKzVaSUp2MTBpUllG?=
 =?utf-8?B?MVphUjQ5RFh4OVpTYmdkRnZDR2FCK3cvQWMzVGxWdVNpenpIeE4zMDM3M0VL?=
 =?utf-8?B?TTZ3MjJRaW41RytTbnBuU1hNajRaSUNGamE4OXBRNmlCdjFESDJBbHpRR1JW?=
 =?utf-8?B?TWI4ZFYzKzRwUVd1Sy80WjB3NWQxRnArU1BIZWJuWUJ2cnMzWXdPNXBEbWE5?=
 =?utf-8?B?cFdKSWpFZW5TeHB6bVM0ZVFHSE9STk54TjVKY0xLWG9NMTFPZENJN251ZzEr?=
 =?utf-8?B?RHY5cHllemlpNDE2R3R6c1VuNG92alNCYWQ0ak5VbkZCMDE5bGwvWXhiTlZG?=
 =?utf-8?B?QldyZUp0S0MvMkozTUtBOXFDM3hvaUVkdlJSK1VPanVKT2MyUkZwNnZJNU8z?=
 =?utf-8?B?K3k1L1k3Z0lJZHNpdEtoTjRzVHhCSDNpczVIWXdlQjNZaC9WRmdmZ1lkYnZF?=
 =?utf-8?B?K0NHcXlzVDV1aVpNVmhtT1dRbW4zNjdKM1VQbThtbGZ5KzNnS3F4UkpZY1M5?=
 =?utf-8?B?TmJ2N1YwT1hoYUtjbjFxY2Q3NHlOMU9GWXFUOWhrV2FvUm5MblFWemliV2JX?=
 =?utf-8?B?VmdLT3R6VTE0ZGtCcGwxVHB1Vk9nKzdLaXg0dDMweDhzMytnL2RFUFU3enJE?=
 =?utf-8?B?TUpuNzBhNmtkQVZmSWY1d2VCR05NWEJTdk1HdmNGeHhVWVg3RGtFVURTb2pL?=
 =?utf-8?B?dGZNdFg4Z1V3cXUzMFR0V2YxOXRVWmMyeXFTVEJZZ1lPQ2hQUHI3cmovMXYx?=
 =?utf-8?B?NlBXdU9yVmhCUFRybmtZVGR4djN6bWVlVXkyd21wTmZKMnlYN3J0OHYwSmNH?=
 =?utf-8?B?SW9iNFRmclVMeU40RW1nL3ZJVHBwRW1CSVBUMTdtcGZRbDVRRTZZSUd1MTN3?=
 =?utf-8?B?NStlV3RMOUxlei9QNW05bzlPNytGZ0dVTk5PV2JEOW5VT2N0LzhGQmI4Sm5K?=
 =?utf-8?B?bDZhOUtCempiOE1DenRla2grQmlmbFF1ajZYWUpsS1gwQ2c2N2dQV05yR2Jh?=
 =?utf-8?Q?ImwQLsGUpB8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWpTVmhxQVdOY0tSR0hGQXkyUTFMQVRZaTZmVDNscVdURXlnMU0xaDZyUjBn?=
 =?utf-8?B?L2grb3hTb09sdTF6c3F3bkVhM0IrSm5pYmRLUkRiYThVT0Q5YWxGcktLM3Fh?=
 =?utf-8?B?WXZHQ2xvcnlUbnU4NDFpZ0VpR2pyV2F0WEljQmdSd3ZMYm5lUjRwcjhPN1cy?=
 =?utf-8?B?Rk4zbGN5Y0xXeHI3UjFJaGZ4TTZzL2U0RnVpTVJqbGdzL3JMRmRSMzE4d1dP?=
 =?utf-8?B?TUQ3V3hLSVNtZG1FaUxvM0dXTzAzeDkycFcxL09KMytzUlpqeTRtaHl4bmg3?=
 =?utf-8?B?NDFiUnI4eXpXYTJGOW1mSk5NeGdUY0V6QjRCRDNGMnB5R2t1OWN1dVRNYUVJ?=
 =?utf-8?B?VTJ3cVpiRkJRZlRXY1Y2RWViVE1uYlJMVkovcitEeTBWVWY2Q1grckt3YkNv?=
 =?utf-8?B?MXU4UVhpcXBhaCsrS3pXa2ozdy9KdkxIaW0rOGpZNHA5ZmFkMTIzR2twbkkz?=
 =?utf-8?B?VDRpR0JzR2lza0wzMlFZNnlVekJHdlIyRDFnOWdTQzJYR25JZE1raUdsR0J3?=
 =?utf-8?B?aWtvdlc0NDZiNXQrNEJPd2VaNi9pYWpqWUxLNUltRWFqSDBPTU1NM3RVR0Q3?=
 =?utf-8?B?REIzdTh1ajFITzkvYldtRStNa3d1NWJTVGY0WURtN0JzOGxLT1lGcmp5VG1u?=
 =?utf-8?B?WCtGNWFwV0paYTFqS0UvcVJvNGNMZFIrWlcyUVVvRkY0bEFDNjZSVkppQUp2?=
 =?utf-8?B?eFJiNTZ6NmZFNjFZZWlqays0WjQ1SXU5VVBrOEpKYUw3ekU5cGx1K04xUTBB?=
 =?utf-8?B?V01aSzhrZ2kwVThzRkVOM0Z2TmNGLzI1V1B5eTNCT3pyVWFEcjkya04xU3Bs?=
 =?utf-8?B?RDJDTWQ1UkhtcGFWM0FqbW55Z3NZWmtMT1FBcTF3ZElielppcWlwT0xWcmZx?=
 =?utf-8?B?MnBkWWpEZTE1NDhKV1ZVekNIb3pqSU1xTVhNQWY3a3o5dGovRWRRNlQxcmta?=
 =?utf-8?B?ejNLYnhGd21QRjhwL1crYXFRem5LQllVdjlkdzhLVmRYaWRmMTZWQXBPUGZr?=
 =?utf-8?B?VHd1VVlveDlrT2E5QkVGWHJwSVNKZDNtMUxaT29ES21KTFJpNUdHWk8xRW5X?=
 =?utf-8?B?bmxjWGtRc1RRRGl6VW1qZFVnVmFmVDNKODVxUWlMOXJpL2UrdldHVlJDV0hH?=
 =?utf-8?B?V0p1RmxCalVXekF6ZEJNZkdITnh3SFp3Q0ZLZFNiUkNNUFVpQSsybGFkaWxO?=
 =?utf-8?B?MCticVliVGs0U0tSTWUrdUZzVTdCaTJrRUJxa2xicUxuNE9rd2FOR0NaZGwr?=
 =?utf-8?B?UTd3UFk1T3pQREFmQSt0alFmdUQ4dHY3a0pCRmc3YzhmV1VtWEUxVCtVeldv?=
 =?utf-8?B?aWttM0JpbE9WVlNoYlVZUGkvMi9zRnkycmt0eGZMQ2hLUDFsOGJNSzkvSFJz?=
 =?utf-8?B?QWcvUDFLRU0yeFNLOXVPUzc4enRWYitBRHpFWkRHNmVFQnkzMDUvMFhiaVpZ?=
 =?utf-8?B?WTIyREZZMk9sTjVvMVdoR0N3T3JKT092ODBFUWRORGtuSTRLdTQyQnlCTHNV?=
 =?utf-8?B?ZElSaWRnZ09XQXpDV0Q2SHRwQmkvZ3lVSjZkcno4QlhMRTd5L2Yxd29vM1Fn?=
 =?utf-8?B?VXRmcHh6THJUZjJ4akMwbm1LUXc2ZFo3V0VVcmlUWkNpVUt3ckxhSWZqc1NM?=
 =?utf-8?B?bUVGNVpvMndobG1mQVM3ZDRuZ1V2Z1lCYWdKOVFSM1JaSUJtVGsrUlNGVXlp?=
 =?utf-8?B?YUU3UngwU1dSV0lBUk1TN25VcWFsL1U4aXZSRDREcEk3bDZQSUREUWFXaGkr?=
 =?utf-8?B?bkgxaEQ0QmNKaW82NFBKRkdFdDVmYndhenZETmhXR2pzdzZoZnJlaFM2OWVD?=
 =?utf-8?B?LzBYN2xyOW9qaEE0OXlHR2Q0WVJQb1lseWYxY3BJYktoaXdJUTZ3MWcvcmF2?=
 =?utf-8?B?NUlKZ2tXaWoyNWw1Um9SQjczWis0SEtoZjJLYkpWZlQ0Z1lTeUN6QUoxdi9i?=
 =?utf-8?B?YnJJeEorWndUMGxhVG9mdExuQzR1ajJlRkZjaXRZOW1NVzVYM1VvbFkrTWVw?=
 =?utf-8?B?R2wrY3laZGovYjk5dDh1ZE5kRDR0NEVCSzREUW1HODlJMzVLNkJnWjd6ZE1Q?=
 =?utf-8?B?cVJLcWwwTm9qem1sVE1yMWt3bU1JNitnSG5uS0lvblJNOUZidmtyQ3BNVW9N?=
 =?utf-8?Q?1QfALE6QfFUyGOBS/ZBVBP0wi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9286251c-3e4e-4b0b-7ce9-08ddc46b2faf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 13:17:59.9697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rAwZGRYFCrNXtiRj5+dmtNKtUcGcoz9iamMH72ixS+kvMyploM5yC1TEcUoX1XsHyTZ1LvoHVM3bfOeEVSsa/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8804

On 7/16/25 00:56, Nikunj A Dadhania wrote:
> Require a minimum GHCB version of 2 when starting SEV-SNP guests through
> KVM_SEV_INIT2. When a VMM attempts to start an SEV-SNP guest with an
> incompatible GHCB version (less than 2), reject the request early rather
> than allowing the guest kernel to start with an incorrect protocol version
> and fail later with GHCB_SNP_UNSUPPORTED guest termination.
> 
> Hypervisor logs the guest termination with GHCB_SNP_UNSUPPORTED error code:
> 
> kvm_amd: SEV-ES guest requested termination: 0x0:0x2
> 
> SNP guest fails with the below error message:
> 
> KVM: unknown exit reason 24
> EAX=00000000 EBX=00000000 ECX=00000000 EDX=00a00f11
> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
> EIP=0000fff0 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0000 00000000 0000ffff 00009300
> CS =f000 ffff0000 0000ffff 00009b00
> SS =0000 00000000 0000ffff 00009300
> DS =0000 00000000 0000ffff 00009300
> FS =0000 00000000 0000ffff 00009300
> GS =0000 00000000 0000ffff 00009300
> LDT=0000 00000000 0000ffff 00008200
> TR =0000 00000000 0000ffff 00008b00
> GDT=     00000000 0000ffff
> IDT=     00000000 0000ffff
> CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000000
> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
> DR6=00000000ffff0ff0 DR7=0000000000000400
> EFER=0000000000000000
> 
> Fixes: 4af663c2f64a ("KVM: SEV: Allow per-guest configuration of GHCB protocol version")
> Cc: Thomas Lendacky <thomas.lendacky@amd.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Cc: stable@vger.kernel.org

You kept the stable email.

Minor comment below about placement, but otherwise...

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> ---
> 
> Changes since v1:
> * Add failure logs in the commit and drop @stable tag (Sean)
> ---
>  arch/x86/kvm/svm/sev.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 95668e84ab86..fdc1309c68cb 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -406,6 +406,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	struct sev_platform_init_args init_args = {0};
>  	bool es_active = vm_type != KVM_X86_SEV_VM;
> +	bool snp_active = vm_type == KVM_X86_SNP_VM;
>  	u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
>  	int ret;
>  
> @@ -424,6 +425,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  	if (unlikely(sev->active))
>  		return -EINVAL;
>  
> +	if (snp_active && data->ghcb_version && data->ghcb_version < 2)
> +		return -EINVAL;
> +

Would it make sense to move this up a little bit so that it follows the
other ghcb_version check? This way the checks are grouped.

Thanks,
Tom

>  	sev->active = true;
>  	sev->es_active = es_active;
>  	sev->vmsa_features = data->vmsa_features;
> @@ -437,7 +441,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  	if (sev->es_active && !sev->ghcb_version)
>  		sev->ghcb_version = GHCB_VERSION_DEFAULT;
>  
> -	if (vm_type == KVM_X86_SNP_VM)
> +	if (snp_active)
>  		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
>  
>  	ret = sev_asid_new(sev);
> @@ -455,7 +459,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  	}
>  
>  	/* This needs to happen after SEV/SNP firmware initialization. */
> -	if (vm_type == KVM_X86_SNP_VM) {
> +	if (snp_active) {
>  		ret = snp_guest_req_init(kvm);
>  		if (ret)
>  			goto e_free;
> 
> base-commit: 772d50d9b87bec08b56ecee0a880d6b2ee5c7da5

