Return-Path: <kvm+bounces-48171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C6AACAEC4
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 15:18:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A18373B5996
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 13:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D0F21C9EF;
	Mon,  2 Jun 2025 13:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qWVjjsrR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2064.outbound.protection.outlook.com [40.107.236.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF534A0F
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 13:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748870291; cv=fail; b=Txe5CI7WXV3PDuJtY58uZ7/SFU1wx1pGBQ5RRvW9kK1pYlk2C6Wu6sX0XU4MKBeipQV3RgPQc2VYpSm3LE1KUfGZpvt+BhFe2Dd1RaWSN/6gzt5lf8B1IhU9r67Sm5c5sIX3l8Mff3yMITa3RW+mxKVFSMQsHh9WdCu7gy5Mo20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748870291; c=relaxed/simple;
	bh=g3A5QOjOA4Qgxg4k6kVtYDVD8Jpevj+Ghd7aq+ynv0g=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u11h/ju0IxBpErn4IVJe0C9PeQphyD7btzMazbiEy9u99fWeEaZcs2HINHV2SS0Sa6cP0XxEhYuDP8QSGFnenXk9gkg7kPWOmAW7mJkJU70R1AbjM5GzUU49S2dE/F/D3YZt0DWIvHwypn6DnT9Vhr0/7FNNo1JQFJxAdyVwUfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qWVjjsrR; arc=fail smtp.client-ip=40.107.236.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RVM+B/vABzn2p0Vb0OTILSyXL2WUXSp/Nn5gTsFfGXezNTRaFqdcQiJ3GrQTJaCT8FqiNgP0wK0FWjVIk/s6nK8v+CxETupmA7SLbpjlRXsbYLiyG6Cdv0jEr2TsNsLufO0bl9TH9B5WXCfxRMlgkTJIWYqKTnLdjNfUf/a8ZXIsTzqwoF2+/DypD6XH0dv8HWh5odHnPrAav071OkZgs619GeMXvQfp4+xDFBgHZilY6U+TkX0ezFWplCMKojNc+Yg0NKLAs4Mm+xX7vR/UrVV/1LzY4xS6VjG6CXTSaNZjzB9jo13d8okDR1jJP+n1kfXoTHwIkUvC/11iRozoYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5yOhQmz9dXcAyoYb67UiqQIertQQHHdvJ1C9WObiPdk=;
 b=ApnKlU/uYwmNeVCc9OxIQzt4G87wQfZTt6+oxKsVFt9Hr4HbVD/yBDx3Np1NmvI6Z8R/3CyGPmLQIpLXi1O+1ZJ4xBtnovUU0kxRdLCNtPQCSkPyFgcFmYs3RzeCslfRsh/VsaC81nE1JBu1WBAc1fAe2syb2CZZGDEO277GmN7scblI84sS5fbW0Y3ZuAV+2+jrFc+ybUDlZNC4PC1VJdIOkRF0RS41pFfXvRMCB0NyWAG5G6KMhlTmnFIq4GIHM2ClBG8MxQjttrqONXj05cq1f+e9FFUFyFQ1IYn/4UabZGnyQ4NxZTuFlvW/b7PuvGN4OK79lELymlc3iS8tKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yOhQmz9dXcAyoYb67UiqQIertQQHHdvJ1C9WObiPdk=;
 b=qWVjjsrRGeCw9pAKfK/ZapFdEl4U66L0uC1e04GaZlsk0bJA6MzDtIRhubYECTIK6GPYXX3H+oItRs/QReRreibPGaqXkkD4cV+Iks4KkDVq+u3PXkWaWuFiGJV5ZNCMxAzC0tegtGliKe5WzAKbIo+fEYQgQnGVKPCxA0MEcas=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB8859.namprd12.prod.outlook.com (2603:10b6:806:37c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.36; Mon, 2 Jun
 2025 13:18:05 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8769.037; Mon, 2 Jun 2025
 13:17:57 +0000
Message-ID: <4bcfe4ff-939e-f669-8d80-4077cc7aeb60@amd.com>
Date: Mon, 2 Jun 2025 08:17:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] i386/kvm: Prefault memory on page state change
From: Tom Lendacky <thomas.lendacky@amd.com>
To: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, "Roth, Michael" <Michael.Roth@amd.com>
References: <f5411c42340bd2f5c14972551edb4e959995e42b.1743193824.git.thomas.lendacky@amd.com>
Content-Language: en-US
In-Reply-To: <f5411c42340bd2f5c14972551edb4e959995e42b.1743193824.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0786.namprd03.prod.outlook.com
 (2603:10b6:408:13f::11) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB8859:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c84ef0a-72be-418c-d60a-08dda1d7e3cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UEZCbzd6bktkT2N6cWhHdTlFWFI3RlFmck80NFBmdm14T1JrdXgwUHFSclVa?=
 =?utf-8?B?aitzSHJrSU04ZHlJS21Cd09sU256YnlzUHNlNU96K2wvaHFDMGpZYUF4dTZi?=
 =?utf-8?B?T2VGR25pekt2UVJTb3JxSGp4a2lPTmJIbTlUOCtxWmpQd2RaUGdNekZFaE9T?=
 =?utf-8?B?UUZGRVJxdXdjZmFsT29sU0I3NjV5cFdZS3hrVE1ZUmROWjRldzZhd3dRbUt4?=
 =?utf-8?B?K2gzRDArUFA2Qnd0MFluUUUybkhPVEljWm5pNzIveEg2UCt3T1lWWWFDV05Y?=
 =?utf-8?B?TkFvUEIrQ1h6VTFDbSt6bUJ4cUJUdWFsQmJ2d3ltSjVybWJBTzNieVZWQ2Zx?=
 =?utf-8?B?ekVKTmxuM2RDRkN6Qm9CR3JBZHdYUU10TW9iQ2Vvdjd4MHp3UVlOZXl3c3lU?=
 =?utf-8?B?ejJFZ3lqUVcwSWRKdWlPdnlJMDZFZy9TZkMxdEEzRGt4QmFZZldaMXNGOC91?=
 =?utf-8?B?TDlPY2dsQlBqdlpzRG0ydWhFR0tna1NFZ1FmeWFIRDY3K3QzdGtOdzRqRDBS?=
 =?utf-8?B?UWYrbjFVSGM2SXBkemlZWmZObDdnSkE2eWE2Um5nZjlyNkFsR1c1WEwwQm4z?=
 =?utf-8?B?Q0dYZm92eTFKZGhJc1FqOGh0U3U3M0E3dVZsNThqM2FFOVowbDZJV05FWC9q?=
 =?utf-8?B?WHV1RmpKT3lobjVXVWhiM21tQ1Y1MWxQUks2M1o4MmlYd0JISlcyNVBuWmJH?=
 =?utf-8?B?V0ZFaENRNEFucXR1akR0NFY2dXF2Q3VIbUFmMVhyZkp5cXZoTmc0K1hMZ3E1?=
 =?utf-8?B?QlRoak5aYk1CSmR2bnR4eDNTbTdwTmU3cGpGS0ZtdW04RjQ0TDN3MlhSVmkz?=
 =?utf-8?B?MisvRyt4Vm1XMTB4NitKVzlxK2RKYkpzR2U5dEFndGRBMW1jY2Y0UHJqTXR5?=
 =?utf-8?B?UmU3Wm5xbVNlaHJzSHV6aWpzaGpLemVnVXB2cm9ENlJ3aGZXZkdER1NlZVpS?=
 =?utf-8?B?c054TFE4bXRBUlNrNWQ1WkxvMk1TOUhrSmV5MVFhYSs3Z2FmTHgrWUM1Ukg3?=
 =?utf-8?B?ZGk1ZktxTGRrSDdFWWNYVThVRC9LWndDZEloTFIwUER1UHl3emEzVGQzcERP?=
 =?utf-8?B?eXZBWXlBdWZjU3dITGFhM3k4MlRQQzFIQWcya3hQS1dNZmRuQ0VWdWx1UlAr?=
 =?utf-8?B?ZlcxNXBCNHhQTHU3TzNvaXg1Qm5Wd1BLRWFSYUFIREtlQUtQK1hNWUxQVEhV?=
 =?utf-8?B?alA4Skk0dm1WRE1qVnlpbUlINkxtN0Nkc29yTnRWQUZlY2pzUmRXemROUCtu?=
 =?utf-8?B?eXVVMGY4OTJVZHM2K0J3ZFViY0ZJdjBkcGVBN3RrVVdXNkJPekVRTG5XRmIy?=
 =?utf-8?B?OE04TUZxQjFRazJXMFpxOW9vbldFL0cxcXNKQ3lzNDdHQ09nSmZGUUJPK2g3?=
 =?utf-8?B?OE9Wb3NBblBwblpLbmhFQ0N2NDBEcjBqQWlqSEkwaFREUElSRGljZGMrWFRt?=
 =?utf-8?B?M2N2Umc1d3NISCtyNDlQcTdaMFUxUWZYVWQzK3ZyQ0ZmREQyK0puSjh2bEhY?=
 =?utf-8?B?N2hXby9WaEJyWXl6ZFo3M1VhNkR5TlIyYWNEMFdvYTl1WVZ6MGRRVHhYOFNO?=
 =?utf-8?B?b2xZTSt4YlFvZ1hkUDNJYW5oMDdoUVlIYWhXNXJNRHZraDFyL1dkTU1SdDJD?=
 =?utf-8?B?MVhIbTE0amt1ZE8yaERVOVZpbmhnem1xR0YrSk1DdmdJTXRrQ3JzUmgwRlpo?=
 =?utf-8?B?RGFWMm01cmRMVmJiSnBmY0tWOWlzUXpZL1QzanFCRlhieXlPbGtBbjBVT1FR?=
 =?utf-8?B?c2FRSGRJUjRkU0VGWFNUYzdVb3JkbVExMGpOUVlrNTdSUjdVdVNlY3ljSVJ5?=
 =?utf-8?B?Q3BTK1hNTUN2R1FybWNUYk9sR3YxNHlqeFF2REpwK3JmN25ONVVXV09BZWZU?=
 =?utf-8?B?Znl6cWVCendSbkhicmpxeEJEMnBNNHNNNklRcDQvQm83cGl1MjZWR2NPM0V4?=
 =?utf-8?Q?V1U8trx4bxk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2xtcm5zZjNPN3A5WEdzSUs3ZzBybXNQVTQ4RXlCTzF2azhiQVBhb3hqSlg2?=
 =?utf-8?B?dGdhcTRLdHVycGdDdVRXVUJoOEFwcVJSMjF5UGtSelVYQnM0cjVHNWZ0b3ly?=
 =?utf-8?B?TjJhSVhrUkNZbXR3aGtmMEdzY1ZLV0F6YURwdHJNYlVJTEM5LzRCQ3NWZXJj?=
 =?utf-8?B?bndhRWZxZG1BbmVwWXVkelIwdlA3S04yR2kvcnVvSnlIeGtCcHJYczVqQ0M1?=
 =?utf-8?B?VGtadkU3c3JPOUZlYStVRG1JSmFoY01ic0ovS3NWenZ2MWM3aW5GR3phdld0?=
 =?utf-8?B?SVVrT1VsQUhVSzZXNmxjeGFXNldKaGxlMXRuQlJtRnJreXRaRURxeWRHbnIx?=
 =?utf-8?B?ekxzckFnVU9TRFdqQU5vcDU3aUJnaG9PbHlDejFmRHVpcEl4bVZJaEVlNlk5?=
 =?utf-8?B?WWlxdUhWSCtDNktxRHVSTmZSVmdlUzl4c0Q3N045bGJjNHZDakl0bUJjem9B?=
 =?utf-8?B?YVYxNm93OGdtQ1FWZ2dZZTVTM2dBL3JwNnZJOVhYTVkyWUZCUVpKd1ZSQTI0?=
 =?utf-8?B?WGFqWWVvUGppR0p0U0NLQ085Zjh4MUs1VVNmU3JvSVZBUmNMaUVBZlVHZHdy?=
 =?utf-8?B?VkNvMHhsWjZjU0IyTDFQd2xnc1ExSFVtZC9lVWNtRjFuRTRXbWJMczRZTDVO?=
 =?utf-8?B?TXZadkdIaGIyaGh3QUhCMmREVDRzSjRoZWRHbVhOQVY4Y0c5bzhac2IrNlVR?=
 =?utf-8?B?QXJ6WlVqZzVGdjlJVlBIU2xsVDUwWHBwNGVDOUs4ZkNjelhEbFVBYXhaTDlK?=
 =?utf-8?B?bmdEMUFORGk0TU4weW9FWUVId0hDdEJqK3pZOG9kQ0tETytsY0FvS0c1YkVU?=
 =?utf-8?B?K0NSMklpT2VaWnRIdlBnSzlITG00Tk11T1djWDNsMzFoSWpJd01mcFcrcTg2?=
 =?utf-8?B?L0ZWanNKRGcyM3FDbVdQZVZ4L2E1Z3JiTEZOMnc1RVFuelZyK0FFaWZyR0Ux?=
 =?utf-8?B?b2pvbVdxY0o1NUptWEw4YXcrQ09VOGkyQlQ4Uk0ydUpBU2c3L1duOWFRMWpE?=
 =?utf-8?B?czFCVjdFTUFHMkdoeHA0alNNRmZ1a3lKYTB6c082TXlrNXlvV3VpRFJJSnJG?=
 =?utf-8?B?Vzc0Vzd3ZG5laDY3WXJuZmNwL2xLR1VSdzdIdHVhUlZxUDcxTHI5VkJrVEFW?=
 =?utf-8?B?eXp3VHRhdnZGeTAyMCtkaEROQk14SGNaNGgybTVHTWo3NUpMc2lKZjBybjM0?=
 =?utf-8?B?WVpIRkhJK3dqVmZQNENYemdOQTh1bjFiZCtjTEZiUDM4akNtT1BuTUJzWkh1?=
 =?utf-8?B?SWV5K2V2bWRlMkExMEc5b1RWcmZkRnZGM2hnUkdMc1pFUXQ1S3d4bHl6YmI3?=
 =?utf-8?B?TVZNbEFoRVplM2RjNmNQSUZWY0tNeEdRMmJ4djkrd0tHTTZsY1JXb1lHSWxn?=
 =?utf-8?B?Y3RnWnBWcFdsNkhSZk5rWC82VmJBVFg0V1F3dlV1cFQyUWZCaGU3U2piOU1B?=
 =?utf-8?B?eGgrSGNPQjJVTFVlU25oT3o0Y1hzdmtuWEF0YXAzV1pjaXZQT0RPYlZFdllj?=
 =?utf-8?B?YW5FaWVuYnlteExKSjVZSGFuV2N3QThhRFFHaTdNNWYxZE5FYjNMNmt6MzRI?=
 =?utf-8?B?M2k1WjZsR1pCRGc5eFhhL3JmZWlCSm5LS1hTTE9vdy9XSFJ5VGNBQk52VGJ2?=
 =?utf-8?B?cXgyRHFqN0ZLT2ZCOW1mM3JsUTFVRlJyTzdUemdzbmdKczNxR0tSNmxzTGt5?=
 =?utf-8?B?YVkrSU5qWEllMmdpNENQZWZsQTJvdkZnaW1vRVNjV0hCRDltaHVQdjhzcGxQ?=
 =?utf-8?B?MDFjek5kRlZDMlM1cWVQbFBqWW1DcHdtS1VBVHpxN1ZvcDFOS3dWMHUzaXVp?=
 =?utf-8?B?MFhIWk5GMmFKWDRTOW15dHFuQjhpRWNpMmxEMVhyUFZqZ3ZDQjI5eGNrNytC?=
 =?utf-8?B?WGF3TTY0emsycmhhSERMMWthRWpCV1BpVU9LNitBMnZZd0MzSFNoQ21Ed3Ax?=
 =?utf-8?B?Si9paUhoNFhSVmQrV1U2S1lld3FWaVBXSzdoZUVPbzBpcGREb1FSYWxaRGxh?=
 =?utf-8?B?WnI4WEo4R3NvUnJlaEVoRXl3alM5V3d3VHNDQUpLYlRYWXh3MVVOMDZGWDls?=
 =?utf-8?B?UGtxQkdEejNwdDJuVCtRcEtIMk5jNzZDY2pxcUhBeis1NVR1bHlBOU5ib0lU?=
 =?utf-8?Q?YGaIYIirettDHZFqLLJ/CLWhR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c84ef0a-72be-418c-d60a-08dda1d7e3cf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 13:17:57.1588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iGC0EZDj9QkxHdlQJfQfymONvqTOiDMjcU39LbuKYcwkx+yzLoK/dutIUwcvZSwzT74oaA9+1jIkVExjo8+qNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8859

On 3/28/25 15:30, Lendacky, Thomas wrote:
> A page state change is typically followed by an access of the page(s) and
> results in another VMEXIT in order to map the page into the nested page
> table. Depending on the size of page state change request, this can
> generate a number of additional VMEXITs. For example, under SNP, when
> Linux is utilizing lazy memory acceptance, memory is typically accepted in
> 4M chunks. A page state change request is submitted to mark the pages as
> private, followed by validation of the memory. Since the guest_memfd
> currently only supports 4K pages, each page validation will result in
> VMEXIT to map the page, resulting in 1024 additional exits.
> 
> When performing a page state change, invoke KVM_PRE_FAULT_MEMORY for the
> size of the page state change in order to pre-map the pages and avoid the
> additional VMEXITs. This helps speed up boot times.

Ping...

> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  accel/kvm/kvm-all.c   |  2 ++
>  include/system/kvm.h  |  1 +
>  target/i386/kvm/kvm.c | 31 ++++++++++++++++++++++++++-----
>  3 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index f89568bfa3..0cd487cea7 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -93,6 +93,7 @@ bool kvm_allowed;
>  bool kvm_readonly_mem_allowed;
>  bool kvm_vm_attributes_allowed;
>  bool kvm_msi_use_devid;
> +bool kvm_pre_fault_memory_supported;
>  static bool kvm_has_guest_debug;
>  static int kvm_sstep_flags;
>  static bool kvm_immediate_exit;
> @@ -2732,6 +2733,7 @@ static int kvm_init(MachineState *ms)
>          kvm_check_extension(s, KVM_CAP_GUEST_MEMFD) &&
>          kvm_check_extension(s, KVM_CAP_USER_MEMORY2) &&
>          (kvm_supported_memory_attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +    kvm_pre_fault_memory_supported = kvm_vm_check_extension(s, KVM_CAP_PRE_FAULT_MEMORY);
>  
>      if (s->kernel_irqchip_split == ON_OFF_AUTO_AUTO) {
>          s->kernel_irqchip_split = mc->default_kernel_irqchip_split ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
> diff --git a/include/system/kvm.h b/include/system/kvm.h
> index ab17c09a55..492ea8a383 100644
> --- a/include/system/kvm.h
> +++ b/include/system/kvm.h
> @@ -42,6 +42,7 @@ extern bool kvm_gsi_routing_allowed;
>  extern bool kvm_gsi_direct_mapping;
>  extern bool kvm_readonly_mem_allowed;
>  extern bool kvm_msi_use_devid;
> +extern bool kvm_pre_fault_memory_supported;
>  
>  #define kvm_enabled()           (kvm_allowed)
>  /**
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 6c749d4ee8..7c39d30c5f 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -5999,9 +5999,11 @@ static bool host_supports_vmx(void)
>   * because private/shared page tracking is already provided through other
>   * means, these 2 use-cases should be treated as being mutually-exclusive.
>   */
> -static int kvm_handle_hc_map_gpa_range(struct kvm_run *run)
> +static int kvm_handle_hc_map_gpa_range(X86CPU *cpu, struct kvm_run *run)
>  {
> +    struct kvm_pre_fault_memory mem;
>      uint64_t gpa, size, attributes;
> +    int ret;
>  
>      if (!machine_require_guest_memfd(current_machine))
>          return -EINVAL;
> @@ -6012,13 +6014,32 @@ static int kvm_handle_hc_map_gpa_range(struct kvm_run *run)
>  
>      trace_kvm_hc_map_gpa_range(gpa, size, attributes, run->hypercall.flags);
>  
> -    return kvm_convert_memory(gpa, size, attributes & KVM_MAP_GPA_RANGE_ENCRYPTED);
> +    ret = kvm_convert_memory(gpa, size, attributes & KVM_MAP_GPA_RANGE_ENCRYPTED);
> +    if (ret || !kvm_pre_fault_memory_supported) {
> +        return ret;
> +    }
> +
> +    /*
> +     * Opportunistically pre-fault memory in. Failures are ignored so that any
> +     * errors in faulting in the memory will get captured in KVM page fault
> +     * path when the guest first accesses the page.
> +     */
> +    memset(&mem, 0, sizeof(mem));
> +    mem.gpa = gpa;
> +    mem.size = size;
> +    while (mem.size) {
> +        if (kvm_vcpu_ioctl(CPU(cpu), KVM_PRE_FAULT_MEMORY, &mem)) {
> +            break;
> +        }
> +    }
> +
> +    return 0;
>  }
>  
> -static int kvm_handle_hypercall(struct kvm_run *run)
> +static int kvm_handle_hypercall(X86CPU *cpu, struct kvm_run *run)
>  {
>      if (run->hypercall.nr == KVM_HC_MAP_GPA_RANGE)
> -        return kvm_handle_hc_map_gpa_range(run);
> +        return kvm_handle_hc_map_gpa_range(cpu, run);
>  
>      return -EINVAL;
>  }
> @@ -6118,7 +6139,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>          break;
>  #endif
>      case KVM_EXIT_HYPERCALL:
> -        ret = kvm_handle_hypercall(run);
> +        ret = kvm_handle_hypercall(cpu, run);
>          break;
>      default:
>          fprintf(stderr, "KVM: unknown exit reason %d\n", run->exit_reason);
> 
> base-commit: 0f15892acaf3f50ecc20c6dad4b3ebdd701aa93e

