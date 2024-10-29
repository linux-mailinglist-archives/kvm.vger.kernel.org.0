Return-Path: <kvm+bounces-29943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F39F69B4967
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 13:15:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70C701F23291
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 12:15:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C140F205E1E;
	Tue, 29 Oct 2024 12:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="idgIzBJO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED5B1DF960;
	Tue, 29 Oct 2024 12:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730204145; cv=fail; b=VRyjj93LgAyYUNcAYBuAa2f9Q+m2OdF6X+KQNmGIaV4BMIiY05dagIOfEH1tuHN8xfaojU4+mPzytTHqM4EUFoF4tfbmBv2tHGpgInqIbJRWBdAVms2bi8HM2JlrL6XSknMrK3xG4aIsKbVG/8NMPZHkDNebYWUpfE2YEXx1l+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730204145; c=relaxed/simple;
	bh=wr+sq+yC0IZyBKziXxJCK2JL6eS3uioUgdDEdVbXXFo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ORNMyVVgl+OjtmqxDBdIqYL103nWwlxV9T7ao67wlFGewzkWDJ1Hf87zJYBcMoGPORu/2eb3dDsiywhiP8Z4T3IOmFNFQShRSfXW7tdeazhEyU0hkYeufqMTslcG6Vl9iaNBJv2yrLCuPzm6jn+yvagPZSwjQu/blUW60ztcJzY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=idgIzBJO; arc=fail smtp.client-ip=40.107.92.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PDZb+g/eC/QKiFP6v/vme4z1xN6BhLF+mrZfi0YoLlR1z3f74Pr5eWGuUd4GgsyQlVgjGTDGwSz5EneCvuVwdOkcbor3rB0Oyb9ESyFGSsM8VxkVacvb+WMWz1ygF/VQ+KXZ6A9oVV24ZzRag/3qIWCXj+rrOi5WQhWjTkrOJFgvEXRXCbXfY7sqCha2VYjG34Ra+ZEt2B/1Pf1ip4x0DdPFL7oC7s61gHmjZFSrOe87KtEGbuqxF29yqD68ZolS4KlLaCC3R6cbbN1Mw3gzXw311nycz8BCJmSfxNQ3AARrPxeHBUIOGH9rgenZJo8fsWktZ7v13clRHO75cEhURQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ApzjFhsx1wsXb1Mtr9Tc40i8WBtyLBrH2Ga8BFhBUc8=;
 b=MMzzc2AIbWOUR/KS08PEPXPHd53gVOnI86mnVvcDJT26BhRLmm2vfuJW3tcxVP5q+M+7Vv3MKZUbX0xRtsc7uKtodvVizIpv87J02sy3TRwM6h7fOyfIz0FjNvyzz1YvcDL1NnkpxrHnlb0rMQ1RlVkaK1h6OuyC88VmqzYXfdXCvd66YCPHa2KuD/A8uhwalQDmcGwq7xTxNLTjZvlaCD0yusVEluF7/hG4MPyX8ZLNTNXjEGgxEqh9glWKseZDSaSWAwv6unUXYPd3j7/fBUMQ9wYX7WvrNw3PBVMZezGhRBCFXtknWeBQPsUeU+Zf7yvwVlewAhTkXeOlJKzeow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ApzjFhsx1wsXb1Mtr9Tc40i8WBtyLBrH2Ga8BFhBUc8=;
 b=idgIzBJOA3l4JWQEJgGspipO4Op8WxNP+0QkaQE0/DGb8F23IHWkNCRB6OSOufBsxnyU3XCpK+KTbwJQg7UsWIZQI5fXEACN1859iO4eT8an/2IoHSnhvSaZVOQkRY64FXPeSMbAxjcuqVJ9KwJYmoAq1ug6BC3adRc6FbSwAyg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CH2PR12MB4165.namprd12.prod.outlook.com (2603:10b6:610:a4::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.32; Tue, 29 Oct 2024 12:15:40 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8093.018; Tue, 29 Oct 2024
 12:15:40 +0000
Message-ID: <8015deec-08e7-4908-85e1-d42f55f4bb6b@amd.com>
Date: Tue, 29 Oct 2024 17:45:23 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/14] AMD: Add Secure AVIC Guest Support
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <vo2oavwp2p4gbenistkq2demqtorisv24zjq2jgotuw6i5i7oy@uq5k2wcg3j5z>
 <378fb9dd-dfb9-48aa-9304-18367a60af58@amd.com>
 <ramttkbttoyswpl7fkz25jwsxs4iuoqdogfllp57ltigmgb3vd@txz4azom56ej>
 <20241029094711.GAZyCvH-ZMHskXAwuv@fat_crate.local>
 <708594f6-78d3-4877-9a1e-b37c55ad0d39@amd.com>
 <submtt3ajyq54jyyywf3pb36nto27ojtuchjvhzycrplvfzrke@sieiu6mqa6xi>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <submtt3ajyq54jyyywf3pb36nto27ojtuchjvhzycrplvfzrke@sieiu6mqa6xi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0096.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::13) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CH2PR12MB4165:EE_
X-MS-Office365-Filtering-Correlation-Id: bfe4829b-cfca-4393-16ae-08dcf813676b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SGcwNDhYWnlKWkFZOFdXTVQvSVhsWWp4TUZrQThsSWt4T1N5Q2JvWGVENzJy?=
 =?utf-8?B?QzlzRUFKYmx1bkN0bG96MXBLNU1STnI5VlhtdGc4OXZrZDBJN3NiWHhSVHpB?=
 =?utf-8?B?YnBBa3h0TEFVaktsY3VWUVlZQVU5THJNMnN6NDdEcTl2RlFNckJUTzludHdH?=
 =?utf-8?B?V281RFRHL1JhR0dnQ3ZYeXRPRzd6eksrSTM1VEcwU2xqOGNITDJhS3Y3ZVlz?=
 =?utf-8?B?TnpwR0wxbnFNOTZaTitzQW1uM0tNRDEzSUVtZXJ3TjZmRlhhaUo1bEd3Umll?=
 =?utf-8?B?WE1iNGZrMnlHTm9EMU5UNjhXNmpqV1FHcFNLZWdMZUxkU1gyWDQwNTk5SlVn?=
 =?utf-8?B?MHptd0Q0ZElUUGJDUDZoUzVvby9SU2k3Q2o1eWxxQTQvZ0JIL2lhV01xaUxZ?=
 =?utf-8?B?T0FCdEZzaWNyQnhMbm5UZmhPbDYzYWc3M09VYmpXSkM1N3ZoKzcwNkcvQmlL?=
 =?utf-8?B?UGlBU2oyczcvWUNVd0ppWjlrdTVlaTdJSDVzZ1dGZ2xUdzM0V0V3WWNSY090?=
 =?utf-8?B?NWhvMk5hOU4xVWRIZFVKMTROcUM3SkhVR2FJM0FxOW5CZUhzMkxWNFMzU2JF?=
 =?utf-8?B?MndQdzZaVnRrdWhqSFdYM1BwOCs4bzF3OUt2Y254NXBsMHZac3Rscmhpcm9l?=
 =?utf-8?B?eE5hdkhRelpDZmt6Zk10bzk5SWFsZWkvSk80dHo5QS9ZL0NQTWtxSWJ4T3RD?=
 =?utf-8?B?eEtyR0UxN3FYcVcvb3ZhdHI4NmxyK0JkenZudHZ0eUwvenhkSEhZSXlLVXky?=
 =?utf-8?B?UjE1Nkg5MmR0czVRMXJuZ2NkaVk2Unp2aHV4TFlUd3F5TTVMd3B0anhhSE5E?=
 =?utf-8?B?QlgzUkJ3UW1VSGZlUi84ZytCVE1WTlRPZVU5QSs0YXg0YnhvWlVUYjFTSG5i?=
 =?utf-8?B?WGZwWGZ3YXNOSDNzT3FhZUUrcXYzVkR4S2pBRjhjVnNvdjI2eW5wSnZZVHNF?=
 =?utf-8?B?MXZQTVhsc0NVNElKOUhIWlRLbXI0QkE3akdmSE14cGhFZ2JmNThNVit0ZFJN?=
 =?utf-8?B?bUJuWnNpbDVtWG1WOWxQSEViL2tpb01lWGV4TEp0R1hScHFaL2Rvd09rbVR3?=
 =?utf-8?B?SUk5VndCN2wvQkJHZ3ZtK0JPRkJVMFQyR0VTcUUvekl3N0xzbXNXcVFadk9l?=
 =?utf-8?B?REhPcTQzM2l5TWxualNBOGhMd1ZQZWRXSkVYT1RRc0h0Z0ZRSWJwT01XbUdj?=
 =?utf-8?B?NVRQMDF4T0JoeFZkYktPMW9Rd05zazBNRkRqdkY1SXNkQWtnZjhwQ0paaU9s?=
 =?utf-8?B?M2xxTEZOd0lkUElxWHVEQlVIaWxENE5aNll0ZFZjT0tlU0VhMjhkcXR5bzd2?=
 =?utf-8?B?SVZya1U1UlZDQnR0QlJ5UCtqbnJVTkxjd1VvcFlETVdydEcrWnZaNXQyeGVk?=
 =?utf-8?B?ZmswRTZYYzdOemM2L0h4ai9ibVM2cTJXWjE1bHE1cTJHd016VzZnMnR4NVlH?=
 =?utf-8?B?ZVVUcnpsUzVQR1BZN0VLQzlNcWhZUVpKUThPdDZDNlRYVmR1RzQ3a3dxYTBl?=
 =?utf-8?B?SmRPcFdUbWFBZ3d3MVFab0lYVUJ2SUZRdEZQS3QzVUhRY0RCVXZ5N09GTzJT?=
 =?utf-8?B?YStSeUJqTysxZ2dqdllOZ0hJQ25GQ2FTcW80Q0tNeDNkOW92WVhCT3JyUE1s?=
 =?utf-8?B?WlVzY2ZpaVJpY1JEaDBqRDQ5aFBYNmpJeDJMNTZrSnVBcGhXRDlRamJtMVNB?=
 =?utf-8?B?QmdoNHVFNngzb2ltWG1ld2dnbWxwYVkySStCWnFPNHFFR3hEYk9vL0ozWVRo?=
 =?utf-8?Q?cJcKnNYBXM1okE0vIaxKox6ZzsNujiyGWUMAXak?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXJFY21KNU1HSTNobWpPQ2RsT0tlUWRtTE13cEprQWxXVC85UTVQcy9Idk44?=
 =?utf-8?B?TkgyK0l0K0MrL3lmSERqenV3NklIcWNqQ3h1UlB3Ry9JUzVEUXlPWHNnSUph?=
 =?utf-8?B?UW9sUytYaVE0N3ZRNzNZWFBJMFE4bjkrakQ1bitSRmJnVjF2czArU0puR1ZC?=
 =?utf-8?B?OEd5TTBvalkyYXVMVkRuMzZLTGRubTE5dmZWQU55ZUlESG15TjhiZGFaVEFH?=
 =?utf-8?B?cDBNYjd0dWlWdEF2Y29xQVU1OXF0VTEvV3J1Z2VQMDdrT25YeWFEbklwYmxM?=
 =?utf-8?B?K1pIWVpiazFzdVVNdkRrQlhSUHBJVzV2T0l0N0lJQitqWkdqK3lPSFVlRHpF?=
 =?utf-8?B?ZU0rc2FnWUJUN1BvL1hZRTFiUFpjSFRHMHZjTGZDdUlFV3NtenJxRk8zS1dw?=
 =?utf-8?B?emVRazF3U1RVTUkvUDM0cWV4TXoyWUhYUkQ3d3NYdHhHR29ERFdCUVNsL3Zv?=
 =?utf-8?B?eE9xSXVXTzZqaTVGckhWUWFrNXMyOUJWQ3lubUhiVTMvZEUyOENENm4ydWJL?=
 =?utf-8?B?VDU1WUJ3L01lbmc2NlhLQzdMRUtYQ2UxdjFvcW00UXBYYkdUUjRmYStheDRE?=
 =?utf-8?B?R2lZQ3hnNWlObnlSVkJXbUZLSGUzNldMNVR3ZWtyenZIeXFOaUVKT2RhOTd6?=
 =?utf-8?B?Smpyc2VKVUZjQUtOS2ZMY0hPM29jUkk3SnY1ak9tWldDaHNOOHUwRGJ0RVpV?=
 =?utf-8?B?ZW1kOU9TWHZIa1lyb09Nd0c1ckZhS0lUeEZPNHBPYmJVQy91ZkNwVi8xN0pT?=
 =?utf-8?B?WnRrQ3FRd3pycmN2bVc5ZzdIa3orK2EyRVl0WFBlbnl4UW1LQkNyVS8zYzU2?=
 =?utf-8?B?bU5rREFrblROVkpOZ0lVVERpS3hLTDVQY0wwSitxU2phWXd3YlJ0azloQ2J5?=
 =?utf-8?B?ZkJpUVlxNzNDM1d3TGI2UFBHSWRuQlVOMCthOGF0RjBZQm91WGdOZlkyN21F?=
 =?utf-8?B?T3ZOaVhOUnFSWjZ4Nnl1dWdmL1docjVidFJ3UHI0U253ckhKWlpHcWx6TC9w?=
 =?utf-8?B?WW5wSU5FNnFhc0UvaHlUNlloS1NjdmFSclZoTkxjVjNXd01XQXF3aTIzczNY?=
 =?utf-8?B?cmRlWVVoK2kvaEd5aE9VOHRtSE82bU14T0RubUdXN3IrMkJ5NFVtZE05b0Ez?=
 =?utf-8?B?RndnM1ltZk4xY29MK0htS2g0VUpIS1FpcjBtcXVKQXgveER2Z0dWeVBBR0dl?=
 =?utf-8?B?Tm9VSzl2VExZZUdheHNNcXdDNkU4SHlMV1l4Y3VOQkRjYzJYK3B6OXowMWFK?=
 =?utf-8?B?Z0FEMERlcGtGelpYemEvOHNKbEY2NWpuUkRWTm1GNnNxb09hMmR2NVlsdDM1?=
 =?utf-8?B?WE8wbGdnU3JvZFc2MndjREVYTElYQWlra2pRT21iMEJ2Z3RhUnlpYnltUHZN?=
 =?utf-8?B?dGdwRjRGRXJZY0NsYWhOVkt2Wlp1UnV5UW0weGYwWTFPbTFYRTFQSmx3TWZS?=
 =?utf-8?B?WU1rVXFkbjk1V1hJRTg5R0ZtSUk1TjRWZWNVY2FBbHM1M3hha3dTUjZFTVJH?=
 =?utf-8?B?bENwWkZaMTZud3JnL3B4MVVreHdjQksyWE5ibyttTVZJTTVvdmhSeWF3bHRP?=
 =?utf-8?B?a2xrLzYzR3ZFSTBSaUxrNWJ3T3hHTDFhQmptQzVKdFJWRlp4LzFsTzZtNXla?=
 =?utf-8?B?UFQwSzA1eVprVDdnUUdvaHp4N3FBM3VkRTFyVzBrSU5lak82bDIrakVsM3gv?=
 =?utf-8?B?d2djanFrMjdGRW1CZkduZmNOaDBkbzhlaVN2WEtKbWQzczRUOTNpVDMzZmNZ?=
 =?utf-8?B?SHhOb0xrcXozckNnZEE5QlNsQWJpUmtPUnlHZkZ5ekc2QVQ3M0E1ZklIRjVn?=
 =?utf-8?B?RHAzem1hbUhXVThSQlVxYXBtREtqLzh4YXdReFI1Mm91a1NNNFJHWHY3VVFt?=
 =?utf-8?B?bGlYNE9zaFRzYUhqdVlaT25ocjN2SmhlUFp6VCtrZklRSHlXTTF1Tm5kYStJ?=
 =?utf-8?B?ZGhQZHVUSTAwMkpLajFJZnc0aS9md3NXbUpWV2ZzbEI3dFBKZUFaZnlQV0FX?=
 =?utf-8?B?akZzVjdBNnNBSEdwSUpDbWJnaDlzcVZZUDhrSktPTUI5cVVVVU5qS0dPYlEx?=
 =?utf-8?B?Qml0eCtDcSs4SlJiNFBhVGxwNzV0S1RTZG5PbHZDL0VEYUV5ekw5YUJXbTRW?=
 =?utf-8?Q?YEJJmeXUkCCT9G0pHisA9VTKp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfe4829b-cfca-4393-16ae-08dcf813676b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 12:15:40.6677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WD4IeI+bdKF5/uzjo4nTEza4fQTDcPCJOQQiFZZhZYBaFCkSaVvzNaO0KC3IuyQXqtkgEA0l61C+TbQaSj9Kog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4165



On 10/29/2024 5:21 PM, Kirill A. Shutemov wrote:
> On Tue, Oct 29, 2024 at 03:54:24PM +0530, Neeraj Upadhyay wrote:
>> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
>> index aeda74bf15e6..08156ac4ec6c 100644
>> --- a/arch/x86/kernel/apic/apic.c
>> +++ b/arch/x86/kernel/apic/apic.c
>> @@ -1163,6 +1163,9 @@ void disable_local_APIC(void)
>>         if (!apic_accessible())
>>                 return;
>>
>> +       if (apic->teardown)
>> +               apic->teardown();
>> +
>>         apic_soft_disable();
>>
>>  #ifdef CONFIG_X86_32
> 
> Hm. I think it will call apic->teardown() for all but the one CPU that
> does kexec. I believe we need to disable SAVIC for all CPUs.
> 

I see it being called for all CPUs.

For the CPU doing kexec, I see below backtrace, which lands into disable_local_APIC()

disable_local_APIC
native_stop_other_cpus
native_machine_shutdown
machine_shutdown
kernel_kexec

For the other CPUs, it is below:

disable_local_APIC
stop_this_cpu
__sysvec_reboot
sysvec_reboot


> Have you tested the case when the target kernel doesn't support SAVIC and
> tries to use a new interrupt vector on the boot CPU? I think it will
> break.
> 

For a VM launched with VMSA feature containing Secure AVIC, the target
kernel also is required to support Secure AVIC. Otherwise, guest bootup
would fail. I will capture this information in the documentation.
So, as far as I understand, SAVIC kernel kexecing into a non-SAVIC kernel
is not a valid use case.



- Neeraj

