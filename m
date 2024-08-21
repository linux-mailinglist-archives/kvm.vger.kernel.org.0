Return-Path: <kvm+bounces-24722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5FFA959B3D
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 14:06:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65E6A1F22B49
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 12:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 037281531C6;
	Wed, 21 Aug 2024 12:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XHzYi9r3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DDD1D1306;
	Wed, 21 Aug 2024 12:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724241974; cv=fail; b=jrGQxentM25gHVX0bupskd7QtIN/42vgUW6EmRUsdczX3BlZLa2HyM6C11RBmxyILV858cTCPfR2RYgSC5UhcGYFmiq2D057HSi2+EZWpV3ar5PIvZTB2QQvZTMv00JnugtMAzrYywC4FFXApjuSwoaVDGDaoCC6XN8yusHyqtg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724241974; c=relaxed/simple;
	bh=7jxjyJyoWucF/lQnxh5+qfQ8snssX5V71QOb2Sbq9LU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Sxk+NcPJb7aoKpXF0UN6j/HrmDLNOY+hqhqfD1EA6FiWaVxBjEGDDQq1EMvL5Bij8vog7MGRbGdMzm/0lsNIMe+gvozeFj1Lzg8zyvj9yRGdFHjIGxvZrO2vZxbmiuSsjtKKikGyXw346JE9hrUEG3qebnxrbU5Dqq6TRpyqeNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XHzYi9r3; arc=fail smtp.client-ip=40.107.220.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QB5NHoTM45Lk7Z7xsXfJAkK0XNQ3V4gkvJe4gwnzVNPh1HkrPprHuZwzUVQLlZD5BW83MEb4ib8nG0e5BT26iIjpA2cMPbs9+c2TYDC8PxUp1FGZ/8DV47DDs4DfTzqRUDJ4CRsvPw0Gmt61iKQq7lliBJkE/C8bwlIHUVW3t8vam78ktNHHDm273/3jqDFEvSUnHTRQQ3i49uSec+YsP0T/QziGLfWzpIdp6hJ+6thSIwzRdwHtfGFJrugoYlZR4hkXuwOXvuvmt9kH/sqKleFzZiyJD2aYTM/dr9F705aNmYrwmzGhu3xnRW1w6sVzJxSYY7Wr4BbAMktOmL+OhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7+v8nb/xfVy5mAqLlpzuv0u+fOXWKRqbEKZz6c2OE0=;
 b=fTh0xTtMLqC28wHk28IilnYSHMH7+hPLaBLEJXMF8l40qn5GK3wecI3q2cux7efBveDkpYJ/vPh+HpzVvQaxGml/1VKHtZVu+IvXfYh1cy+pae0aTIaPoJAAJd59hx1mNaCw/pIeAyZIx4MFpvlFXDJ8VDKYEyDy3dSsB35dkK4E0Sj+z1DtwrRo1RUKngsGj5EB508RIUqKWG20KafZRYqDHkNyUqr5Iw9z2S5f2an3wPl9RaBzuMs/1tZJMd850qdKCfqdaPLRf09/GOcev2+MRbiZbUN4xNRtEHfBrvLvdV/iOaOVlbZqt/jzj7iKb3aqPm3Hhh7uwJIc1AU/Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V7+v8nb/xfVy5mAqLlpzuv0u+fOXWKRqbEKZz6c2OE0=;
 b=XHzYi9r3qq7wJbsF/Rh38F4s84wjhKWGkssP8mD8UxUlk+FXnCHY5a2SyQHpJAbrfBWCE586kNJmMzloCoQAXInKADFV1mvnIlsQWCOiZLRWYOyF8VFBcdbdJx/LWNNCY4X/tjHhcUfuWc/6kIuQlfZ6/MHnYuFglJ/nzP8sroVk1jogwo5d2u+wS4E2HJ8gPiwFASB0qBeRLMiEoB7Ze1c9AZxARAr6slf2KvWmgz2IuqIjMAsPCwFA0BbhDTYg+DVt0aOFTw3QXRafWv+WLcWRSzm+LhKSCpm9AjqAGqJsPpECbETTUi1iDLhlrvvuD6PrE1nFw6oUTg1LYOuRQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6887.namprd12.prod.outlook.com (2603:10b6:806:261::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Wed, 21 Aug
 2024 12:06:09 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 12:06:09 +0000
Date: Wed, 21 Aug 2024 09:06:07 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <20240821120607.GI3773488@nvidia.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <2-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <ZsRUDaFLd85O8u4Z@google.com>
 <20240820120102.GB3773488@nvidia.com>
 <ZsT0Fd5FHS47gm0-@google.com>
 <20240820202138.GH3773488@nvidia.com>
 <ZsW5HRZj2O2hGQYc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZsW5HRZj2O2hGQYc@google.com>
X-ClientProxiedBy: BN0PR10CA0016.namprd10.prod.outlook.com
 (2603:10b6:408:143::23) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6887:EE_
X-MS-Office365-Filtering-Correlation-Id: 13128dca-b254-4f75-89fd-08dcc1d9a440
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?djI1TUpoUUZOY2VZMDBvMGVFRFBsdlJSdncrWnhJNGVseFNTRGVWSTE5WVRk?=
 =?utf-8?B?UUlCWDJvSFRNRU1TUkRYSWcyb01EVitPcFFFRGVPekhtdXA3Q2ZsVjI1MHNQ?=
 =?utf-8?B?TWxPWFdVNlZuOHNxZ0pwQ0pZaWE2MUVLWk5WRnpEUkYrUjBLdEV3Y0F4cU55?=
 =?utf-8?B?Qm9hM3diSkg1RklGTklXaDRXRTQyVlJwRUczZFVqNmZESWxQVzRNc2hmMlJn?=
 =?utf-8?B?WnVuMEtiUFBoazhCWkVKeG10VU9pN1AvVW1QcGJEZFhVa2VieTVTNGhuam44?=
 =?utf-8?B?cFR6MGlENkRuZHJ0Y0NVUjZZMVNPMFdCZC9CRUtMQWVDbmJ4dWh0ejhCNEU0?=
 =?utf-8?B?MXI4bGZHS3BNSE1QNm9ROTY3QTNlVThDUUM5MGRKTDdQcDVRYUNMRkYxUHk5?=
 =?utf-8?B?TlF5eW9JVkVqMXZUeExvNHhodnBvZ3JpK3JyWFpyVDI3WXZzWUtRc1RXcTFT?=
 =?utf-8?B?Q0pPeEcwMitya3A0M3JJckhMUVFIYjYyalUzM1U1Ny9qN3l6S0ptYTA5MlZz?=
 =?utf-8?B?WW01c3JteTZ0UngrVXZPU3hxYmhzRmtnd29USHhFcmhNZHdQNXBFeDNwM3NU?=
 =?utf-8?B?bUpQTjlOUmpKZGV5biswREt3RjNnaEM3WXk2YkIrQURJQWl2MExyNEpsMXVG?=
 =?utf-8?B?ajhCY3gvQWwvamdWcU1pUWQweVFaRFNuaHZiOFZ4OGJ0Z3FtNkh0TXZYOWdw?=
 =?utf-8?B?M3dIU0FEOFZNdzZJZ3JZS1p2Wk04U3dDdGMxcXViU2FHT1p0RDJwS3AwbmV3?=
 =?utf-8?B?NE04dDZ0ZUtFNHJxL2szNWxwWjZxd2Q3Qk9zenhhZEZzbE9keldEZkF2OWRs?=
 =?utf-8?B?Mzhwa0hVdC9ScmRXVm1BdXROakJwS3lTR2pYVU9HVGhKN2t0anUyN1U4dk1C?=
 =?utf-8?B?U3BWUG9GTU9va2lLbmNhUGtJcXIzZTZVd05mWFVUSk5oNXNKNU10Szd0c1NC?=
 =?utf-8?B?N2ttTGxucW9JTVA3QjNrUUpXTk1iU2EzMHhmb0I1Tk84ZnBXN2szekdFQ1F3?=
 =?utf-8?B?ZHFjODhiZWhCQzM5bHFadmw1K0tPSXB1NHorYTR4cndXQmNTYk1wNVdaWG9P?=
 =?utf-8?B?MDVPbXUzaDdPK2JJOW1OUnhheHVXL1J3dVFBM0F2cC9sMEw3UmdBYldYRU5x?=
 =?utf-8?B?cW9xdmdCanh0UFgzRE91UjQyQnFZNWN5d2xYVSt0WWRVbFl3NkhRemVJVktL?=
 =?utf-8?B?YUpaczIzZWs4RFloT0VUdkM3Tm1RS2RBQXU5YjlTTElSTG1MaldSdWZYSDY3?=
 =?utf-8?B?b0svK3loVVhzMlpuL3pna0VkNkhNYUhlVHZvMVg5SjZ1U1VhcmNQcFdnMXpX?=
 =?utf-8?B?SGNDdS9QWVlMaU9NRzVJaFhOazRMTDB2SDY2bkdOeXVzN0NWMmFkTkZTcDFh?=
 =?utf-8?B?VVVMVzhwK1hJeUVsUFdsK0tWeUdMNzY0WG5GZ2VKMEdYbDVwTm12clgrcnNu?=
 =?utf-8?B?TjhtM0RQdWlEOGsza0kyOVVYWElpckZqanZkallWdW5UTGdZZHJsS2k5R3oz?=
 =?utf-8?B?MmVMWFpQbXJFbmdTSjJmaUo5bEwrLzhhOFpONXB1dmpPdGROUG1hbStwZkt3?=
 =?utf-8?B?Nnhmc3Jqd1ZuSkdsdTRRdDB0eHNDZUtLbU9JQUNNSjlraUFDMDNaY3Nnb3JB?=
 =?utf-8?B?YTMrY0F4TkZGaVFIc25Lcm1yOHdHVHNGMmtQMlduOHhieWZISkgrZmh2ZE9U?=
 =?utf-8?B?aVEwQks4R29YUWt3dzdISXh0Q0JtR1ZEU2haOEZZQWN1NG1Ga2E4cDFaUWF2?=
 =?utf-8?B?QldZLzFXYnRSSHMxSi85ME5iRmgvOE5RV1RmTDV5RnFHU2tGZlVMOEI4eWNZ?=
 =?utf-8?B?eDA0Nk5IS09jbGhXNXNBUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajJGVCtqWWhkM3ZNejlKNmJwc3BNRk5LcGh5N3lKSGVFM3lnYlhmRE92T3BF?=
 =?utf-8?B?RTFxZFkreUw0KzlsVC9uZ1M4bkNpRXF1bWhLVTBtZWlyRS94UGFQSUd0RWR3?=
 =?utf-8?B?dDA1QnUzOTJaVTFsM3pSdUNzcGdDYkY4UzFFa1RYMGRNSEcwUFJxcUkwVTE3?=
 =?utf-8?B?UW1uL0VtRWV5N09MTGI1c0Nid2dlNHk5dFVzWGF6WE1XOEoxREl5UTA1WmJH?=
 =?utf-8?B?SzZ5bVBkSEhvdVBCSllzRThKNmhVWFFOUFdEYnljMXhnQTZ3blZCM05XaStX?=
 =?utf-8?B?dnBkblNRelFNN1g4b0FPMjVTSmw2UitxRHJ4MzFnUVgxV04xQmF6N1hIVURB?=
 =?utf-8?B?WDlDUjcxR210dDR0TzU1eHR5REY3L3d1c2ZJTTJkQ1lRNEF4Z0Zsbk1aT2E0?=
 =?utf-8?B?ejJyUERkd0g1cTBFeFcyNWNFTDIrdHR2STU2QklqTDZkVlVmRWpLUitWNjJB?=
 =?utf-8?B?NitVV29laFY1aVpBZ0ovenZKUTZIWFJxQzBoQ3IxM1Y2czRlSHZveGgxQnBL?=
 =?utf-8?B?QWhYK2xXK3ZzQ2pTeUdoWU9IL2FHckthTG9sRUZycXhkRVhMTDhOMUpBZXc5?=
 =?utf-8?B?aFhoSmJ2SUhpNnFjc3dBM2lRdnlhb2dVNEZ6bGFFaTQxZXY3TVJMMWttTzgv?=
 =?utf-8?B?VkpieGRhQ010S25uYkhmMXh3cEU2ckdkZ1lKYkpDYUJReGtmUEw1dlFNU00r?=
 =?utf-8?B?RlFIYTJObzYxdTNzRGwvM2h6eE1ia1UwOGJBUFpIS3RMdWpMT3Q4cGgvOGxh?=
 =?utf-8?B?azUyWEQ2RUVmU0lvQVFkc25MeStZd2I0S0xXRGY2VzIvSFRDLzQvVVo2S2RG?=
 =?utf-8?B?OXlIc3Q4NFk2UmRaeHNPZ1FjRWcxTVZYQkxRWGZtck95VW1SejF1anFFbDF4?=
 =?utf-8?B?NVNCM3NMa3JQTk9maXRRVWpZWGF2STgzL3dNMHpBYkNoVWlhMVJSRm96clEz?=
 =?utf-8?B?bzh5K0hvaytsSzhURC96RzNtVlpLMDIxWHU2K0Z4UWptVFU4VUwrbEJUZERl?=
 =?utf-8?B?LzBGRGd6bW9pTkFsTWdQMUZ6bWY3cFN6MTY4VWsyaWtzbzZ0TVd3VkM0TE9y?=
 =?utf-8?B?TUVjQ0Ntc0tnc1dPc2I2WlBTSjFCSWFOaGo4Ky95UU1sdGo3ZDV2SU14OEh0?=
 =?utf-8?B?WDRpWHBoMkJ6dDR3RnI2SW5lZ0VvaG00QWhrU3ZUUHZWN2VBL0FKZFJvRlI0?=
 =?utf-8?B?V1U2bVFhUjhlVUNHUkxtckYwL2grcjNyZ09YZmNvSmR2Sk1QR2NWOFNVaW1w?=
 =?utf-8?B?aTIvMjRUOTZzWDloZGpJQTZuem5McDM2N2tBaitac0lsUUdCYnBqM3JSZkll?=
 =?utf-8?B?aC9rTmtZYW1rSXBzcGwyUEU5TlFBMXNKLzdWMUlhS0Y1SUJTUEhBemJWWWxJ?=
 =?utf-8?B?a1BwQzMxNitjRTBYVVNFTE0zMnBFNHlWdnIrK00rcTRyN21mNzR3ZDNGbXoy?=
 =?utf-8?B?RWRLNWNEdkV4T1dHVkFjck9ZVlVBODFBZVdhVFFWaFJ4OHQvV00yMDA5YTMx?=
 =?utf-8?B?TUsrYTgzQUpERERyN0FiQWdXMDlEK2Z1eWQveFpVTThrWVk2RkZLZHJ0TVJn?=
 =?utf-8?B?dWl1bnVkd1dVZUovNUtrYjJoSkR5bGRJbkdPY09kcnUvUUJVWTFLL1M0aGll?=
 =?utf-8?B?eGVaRkxYL29jcDJMa2doREJYdm5wakk5Wnp1bEFib09IcXlhUDFtbVdhSU1k?=
 =?utf-8?B?emQrdU1WNGpSOEJ1cE9uQ3B0RnFSOENMM08ra2txZndacTgxbzhISVB1bnRM?=
 =?utf-8?B?NVptNzdjS3hKbkhzV284aC9CSkwrQzlXeGhqcHlxVnRpY2FjekRhM0VWelNk?=
 =?utf-8?B?MFFDdEFSNThqRHhFVWt4SU5WdEV5cmdRd2c0WnpkYzVKS1RsL2dFT0dUM093?=
 =?utf-8?B?UE5BUi9OR3Jrekp2U3R6dWQ5ZW5YUlowcE5CN0dwL0FnYmRNWW1CeWZYa2Uz?=
 =?utf-8?B?dEZ4OUZhOC9kK1IxMG0wcnJFRjNLZklocko3RGdybk9pblNaWjZHeUloZnRq?=
 =?utf-8?B?R1VlbTN3OTZGd0R3NUt1RC9iT0dlVHlrSjR5UVlIVnc1MWxBQzQzaFR0OTZO?=
 =?utf-8?B?MWQyWTFLR1h0KzI0dXNLV3FmR0N3OWpjcXI0S3BTTk5RRlB3dHQ5UGJiZmZU?=
 =?utf-8?Q?mq6joiOUXF3ERlYdBhRXvW4Hs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13128dca-b254-4f75-89fd-08dcc1d9a440
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 12:06:08.8992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8u4xQe6aPdPmB6kV86Mdk/DYpN7dQozJdHUs5Ld49EuGufoug1h19UmvVhZkMP0r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6887

On Wed, Aug 21, 2024 at 09:53:33AM +0000, Mostafa Saleh wrote:
> > Oh, from that perspective yes, but the entire point of S2FWB is that
> > VM's can not create non-coherent access so it is a bit nonsense to ask
> > for both S2FWB and try to assign a non-DMA coherent device.
> 
> Yes, but KVM sets FWB unconditionally and would use cacheable mapping
> for stage-2, and I expect the same for the nested SMMU.

Yes, you'd need some kind of handshake like Intel built for their GPU
cache incoherence to turn that off.

> > > What I mean is the master itself not the SMMU (the SID basically),
> > > so in that case the STE shouldn’t have FWB enabled.
> > 
> > That doesn't matter, those cases will not pass in IOMMU_CACHE and they
> > will work fine with S2FWB turned on.
> 
> But that won’t be the case in nested? Otherwise why we use FWB in the
> first place.

Right, without KVM support for guest cachability selection and cache
flushing in VFIO, is infeasible to allow non-coherent devices. It is a
medium sized problem if someone wants to tackle it.

> Maybe the SMMUv3 .capable, should be changed to check if the device is
> coherent (instead of using dev_is_dma_coherent, it can use lower level
> functions from the supported buses)

That would be the fix I expect. Either SMMUv3 does it, or the core
code adds it on top in the .capable wrapper. It makes sense to me that
the iommu driver should be aware of per-master coherence capability.

> Also, I think supporting IOMMU_CACHE is not enough, as the SMMU can
> support it but the device is still not coherent.

IOMMU_CACHE is defined as requiring no cache maintenance on that
memory.

If specific devices can't guarentee that then IOMMU_CACHE should not
be used on those devices and IOMMU_CAP_CACHE_COHERENCY for that device
should be false.

That is what I mean by support.

Anyhow, I'm going to continue to leave this problem alone for
nesting. Nothing gets worse by adding nesting on top of this. Even if
we wrongly permit VFIO to open non-coherent devices they won't
actually work correctly (VFIO forces IOMMU_CACHE and S2FWB). Most
likely anything trying to use them will just crash/malfunction due to
missing cache flushing.

Jason

