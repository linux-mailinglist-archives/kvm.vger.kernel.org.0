Return-Path: <kvm+bounces-26344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54884974409
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:23:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78CC41C2562B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 20:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8FAE1A76CB;
	Tue, 10 Sep 2024 20:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GWraNwnX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47844183CC7;
	Tue, 10 Sep 2024 20:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725999780; cv=fail; b=YAyHG09pPMJOB97gCFuqwil2lZuod7mZ/rqyIwG73ng54FUAj5gYheMEB6IhDgFpwKaGMhvZ4oWKk53Xyu0N3dLuCVh35lpElPLrsTmi+GfR5cDdqs7ZWojolTJsGhNKBmoDa9YJWS03KxRhIgB4NfcyGpD1bQcNKIrDLigaOdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725999780; c=relaxed/simple;
	bh=xU7338DwD/4Ob6ZER+igshGGd9kURqnVP8oS//EABoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kUtQfxKz45DfPM5Ir09oZUh0iLTDmRi3rZIdwXu2Y9Evo7wlfWlJV5yEhj8Pz7I2vXlmdnfWvdMQhIj2T4VLTUwP+dKPiMOiCASDk+lRtywd7eBUaGBJx01q7PoceMVQpIvG0wjNpnYD3JDnBbi/Ff9AVISLB9Y57FrKXHAbvZw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GWraNwnX; arc=fail smtp.client-ip=40.107.237.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UEmRPlq894S/YxBD3ttCa9jkAPXv/xpuKP5jZsSbk+twoHiZE9s6FNCWEZmLLi/xYO+047w4vMhbh/B8u0Tvrw9MInaZPjUqJfXGa3fEzuwnXdaw2SasN2kDdm5LEEsoA+oD5+XRMApPKArIgzi1B7EJC3T1o3tT77xquMKbCBMdrWDP4VbU6j17qhNZqNlKXsbiPZ7+r8tCX2ZQ+/3OSGwQ2N8spYQxu70OIiS/qxOVt9n0pBiDBOtTmt5FRHM+484JpCjmJTUWgqOKTcQBNkVR9pef862g9pnhgjuOyD1cXDJ43nGbgPv68bXayLDMsgGnyX0dMy97tp8tGTL1fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LyF0pod8cnW45bByn/VnwjvMW3y4ps7ii/vE9W3lfiw=;
 b=BgZoSaYua9cvdwrjVUuhWH6LQHpYh/D22Wlc0dH8cqvW73gOD3l69zoToxcGq+NTRMZ6iUEljcXBWAT2WgTF9qHcfa2UECenmKjHLXobyxnDi/fQYNjD/i/SY3WPKWKoViSckrabse2Fufr4/rFhyBmG8YlflUOz3z7j9cTQVk2WuWnOdr+hjcy5fiQaj8DBJZLlk5FltuEe9por4omwfkBKErrB5WuxU55n3IpV6o11S1CYr+nQ5AaeRqSKQVo6IRaxInIsznVWpDhUYTWG1y970WBJq7eplI0DLmeoE7b1MnT9qg//AKIRCj0EZx9ER7Bs+NfK51xZjECBDtdGZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LyF0pod8cnW45bByn/VnwjvMW3y4ps7ii/vE9W3lfiw=;
 b=GWraNwnXwKS97ybK5d2OuFKtsVwSLrbmdn4CgUUBfC0V4bAJbKQ9YMmiigHOxBKhoS2BdMo8N9SQ+r5zHy8YNwUPdaTvBfsm8t4D7fJNXRAqme2bvIcL//X4Qi52eITXNAJNkef12d/VEZo/GqF3PqpaayAqo9GvwxzQ2B5jUhnvMLsm8D+qJ427KlEL30mGNahpWlRh39AEpog3iqTtS8YYnI+NCQb76LCl5Qi9Yj2o5BJc/JROnijNOuinZZ2wRYOrw/ztz6KP22ZR44ES8jrIhemG/3m+LV/1noA+k3l6AlR/6jBaeOxQfTX438IA4TDPho4jKfeABe0hsJaHww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MW6PR12MB8836.namprd12.prod.outlook.com (2603:10b6:303:241::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Tue, 10 Sep
 2024 20:22:53 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%5]) with mapi id 15.20.7939.022; Tue, 10 Sep 2024
 20:22:52 +0000
Date: Tue, 10 Sep 2024 17:22:51 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <20240910202251.GJ58321@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHhdj6RAKACBCUG@google.com>
 <20240830164019.GU3773488@nvidia.com>
 <ZtWFkR0eSRM4ogJL@google.com>
 <20240903000546.GD3773488@nvidia.com>
 <ZtbBTX96OWdONhaQ@google.com>
 <20240903233340.GH3773488@nvidia.com>
 <ZuAlt9SsijRxuGLk@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZuAlt9SsijRxuGLk@google.com>
X-ClientProxiedBy: MN0P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::35) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MW6PR12MB8836:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a7a2554-9e58-405a-5131-08dcd1d658bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V29ZUWVWMllWbWduZElEYzFiRTdzeENLUTlQN1JxZWlkcU1LT3RBbERZLys0?=
 =?utf-8?B?QTFNL29pMXQ4clB0Q3BvTHJ5S0NYbG45UGJSNW52K2FDYS9mVE5raENFblNI?=
 =?utf-8?B?Mzk4bUVQTjRrUHo1R3E1SGFKVGlaaG5Rc1p6Ly9PSjFlMkpxbmZ3blRpK1k5?=
 =?utf-8?B?Z2JWT2Z3TDlVQ1RXRm5Oc1VPV3ZVbGFBc1VyQll3bWRlbmJoYlhDZm5ZblVS?=
 =?utf-8?B?SmxmQ1hHMm5PVWQ1bzQvaTFnQkZCZ3o0TVptanB2MHdMYzczZFA3Rk84MG9K?=
 =?utf-8?B?bTRvS3ZQcXdRZ25rSkNIcmYzOWViUGZpK3cvZ1Juc1pzZUQrT3BaZzJtUmJi?=
 =?utf-8?B?Um5nMmxvNUlaWStYV3cxMVdxNHVXOFE3RTZkOEV0SVUwOWZTWFJYRERyY2ZL?=
 =?utf-8?B?L25vTkI0NVplNVluN1FRVVNicDJ4eGw3SkxKM24xZkZidnhVN2krK0ozYUs4?=
 =?utf-8?B?d3dUb3YvSW5qYTBZelhVVC9aUXdkaDR6YVU4aEFDODJNQUtHeTdVVHI3RW5V?=
 =?utf-8?B?SmtUVVJWZXpiRWxxNFcyTmNWYkJEQUNqQnhSNGJOeHVGcHRHZVRRRGNIK3RW?=
 =?utf-8?B?SEtqeElEcHMyK210emg0cE5ISkJpN0VTZVZuU092SE03aHVtZ3hwNUk0Yzc2?=
 =?utf-8?B?V3ZUWlYyVGg3MkJLSGlrb2p2UjRlYXFzaWhEa1o1L3lqSFowVEhjcklxNVli?=
 =?utf-8?B?YlFsemM5WTFKWnJjeEZsekZNSnBSdDBBMlZNWmZub3BUelQ1dHUwM0FjTms4?=
 =?utf-8?B?OWpJQ1JSVVpqRnNoeXhHbTlhWWxqNUVJeXo2RVdURUxXUGZuWGpnZ3RmOW9D?=
 =?utf-8?B?UmlZZEN6OTE3MFRPZ3pLNDFDWHdPTXZtc1I0VnFseWlnMlh0ZjJWaUJTdnJw?=
 =?utf-8?B?RGJPd0xNZ3poUnhnM3hwbGJoZE03RVBJWlA1Z3VQTFJzMDdEQ0RBSTF0MUs1?=
 =?utf-8?B?WWphUHNpN2VDMGYyYWZYbloycThsaVp6S09MeU13c2U5MXVqcG9BbitxZTlP?=
 =?utf-8?B?eGxjNnlWSGZ2QmZUZEFmNlltSUU2Nlp5clNRaHdPT3VNeGttVkc5MGlmeEk5?=
 =?utf-8?B?Q0ZXaE1qSmRpSk5qSWlQRlNrTys4dTFNWklWMlN0Rk5QeDhYdWNuU3BqTk9u?=
 =?utf-8?B?cGkvYkVUME5PK0hxYkRRYXBQVGhGSkNpelkzUmhyMnVCTW5YQ3JuSTQ0cHBu?=
 =?utf-8?B?SU52bFZ4YVlKMzcvRGdQVGozMUREbE9jbGJ2NVlhVzlCbGUvQjBzTUszelpk?=
 =?utf-8?B?SHFsSkI1VFZqQm45SWJ1V0J6L3E1aVQzNTBDSER3ZHFGZTZiR2M3NVFEZzlW?=
 =?utf-8?B?UlRQS1ZCY2gzQXloOWFacjhOeXVBV202cXNkRmxkRlo1QjZMWFZ6VVF5OVQ5?=
 =?utf-8?B?dnkxV0RndHZYRjN0NEFZWGhFRTlWT1VoSEZlZDJzaFVDNmRTczkvdGt0eGhM?=
 =?utf-8?B?bEdJOEl4OENwazZUcXVuS3B6a3AvaXF6YUZjWk1FendpaEsxQm4vdHY1SUtO?=
 =?utf-8?B?YW0rOXFIQnhzbmJURFJjSlUwR2Fic1Z1d0ZNRVdEZ3ZxVkYvajBaRFlQZDNs?=
 =?utf-8?B?K0dnM1lTa3NRdnptNW90VUFrNFZ4Wkk1ODNSdzdTTXR1bkt3YXFzYnRFTEZS?=
 =?utf-8?B?NXhXZ1RKRFRKanA2TWJ0aTJBUmlxWDl1cVhNajdLM1NTSER4U0xLR3hoT1U2?=
 =?utf-8?B?MGdLcUxhcFREeGQzUFBITDVaUUhNZXRDR21yWnZuRjFabDhkUUkrUHRnamZO?=
 =?utf-8?B?cDljMjlNUXRQdXFtOVZ4bGtMSmlBTEpxODRnREQ0d3hPdWFZcUZTRE4yY2Ny?=
 =?utf-8?B?MkkreGd2WUN6clFnOVpodz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFJhbE0xWDFxWnJ5NFYyWWYzQU5zUlo5cDdKKzJKQmhTa3huUHd1aFNObC9J?=
 =?utf-8?B?UmxuNFFud2p0L0lkS3U3YWJnK2xTV0htM2U5cjZWUTc0UjBQMjJzd05kYVRJ?=
 =?utf-8?B?bDI4dzc4VFB4ME8yT09LQktVT1hEbWtVeUxLczdxSWxERTQxaExUaEJicllU?=
 =?utf-8?B?VldJcmYycERIV3hjLzBIc3lqOU1jMmo4dUlOM1JDVm4yY2RFa29RTW1ta1Nz?=
 =?utf-8?B?QWNpYUtmTHNudVhWYzR4R2ZPNmp0VmcxcUhMelUwYk9OdnIvdzRBbGFjZnpL?=
 =?utf-8?B?U004ZW9XWjZwVGFtUDMzQXRpVUpYSzMwR2F4aGVJek55TElzTGZmY0EvQ2hp?=
 =?utf-8?B?THJucmxnWUFyK2xEOFplR0JVQ3A2UWpUdDlySkl3dFNtbVVqN3QwenY0Ynky?=
 =?utf-8?B?bkdGTzlmcndmZDBCeGkycXd2YlpDaWpBdzhSZU5Ca2swRExLSEhXTytJSHZL?=
 =?utf-8?B?SDViWU1oZHU4Y2VKY0tzaWRjNnVmdWVqSXN5Y1p1bnZVTS9RSnFtbEtHNXVk?=
 =?utf-8?B?WDhhcS9yUlVncHRHek0vNXFVSnpkaUpta216MFlyMEJIZWhwSS82emdZSjht?=
 =?utf-8?B?S3ZoMEs5dnJ5VU96Y0lHcXJJbkVkMHJqelZXdnREWHoyRlhXV2dTMHhRa0JF?=
 =?utf-8?B?d0hPMlRGY2NKMzNsVWhCM0w2QWRHamV0QUZ6Mk1Ibmp6cnE0NzlJd014eno5?=
 =?utf-8?B?TEJublNXeGxNbG1CSGpncldrRU5TcEZGckZFcVN2cFErcG1GK0M5YWI3dGZX?=
 =?utf-8?B?WnJjTXZwUXgwM2dUZmFMM0RML0U3UUtkZGRycEcrYWpHMlAvYzVkOUs3NkF5?=
 =?utf-8?B?azFqMXFZWmN4dHpLSzBzeDNCazc5YWgrWGdFVEZJNWxielpLZnBJUmFNaTR4?=
 =?utf-8?B?WU9lWGxVQ3JuNEl2VzYwa3R0dWQyTFZCbm10S1dBZEpRdWwrMVlXQXhCa1R4?=
 =?utf-8?B?cFY1V1ZHbjR1MXNqN09RaU5BWFAxVmZPYTRabVNiNC82eHlOVFZtM2hRWWxo?=
 =?utf-8?B?bGh5dC9rbkdBNnRmRURWWmZzN3dSd1dRN1YweUduSnA1U0lac0hmVWJhajR3?=
 =?utf-8?B?bGRzeGhJZGdPeEZtanFWRkViYlJnWnR0aEdoVi9TRXMxSkcySDVJVkFDVi9q?=
 =?utf-8?B?Qlo5Ulo5UlFYd1kydjk3aUt1NzYzRndCODZTaDAxZCtpUVNUUUtVYlFvZ25J?=
 =?utf-8?B?NXIyT3RFNG81TDBVUmxtdGJhU2YyckNzMzlUQjZRQTFPeU9uWnVJbzdDTDZw?=
 =?utf-8?B?NVVwRGQ5ZlpwcXpSWWFPd2M3Rlp6QkN1SUVmNGF4NWJzVFl6MzNIYUpWbk1S?=
 =?utf-8?B?RlAzcEZJWElWNGZ0NnhmbDdQNzlDTko2blpmRmFyZXcwMDNlWW95aW9wSCti?=
 =?utf-8?B?WnQ0VWxVMkNJOThadDZ5MnpzK0IyNUJqanZDZmVFUHd3WEhVb2xrM1MxY0hT?=
 =?utf-8?B?SHVYTEZjcnVyYit6a0lTdDdYRUY1YWRacDJFK2JBN2RtNzdVbE1TUEYzbDRJ?=
 =?utf-8?B?Y0p5RWU2WG5ETXNKVGZRbmt3Wk4yQ1pKbUZUREoraERST2k2aTlGb1RnTkY1?=
 =?utf-8?B?YVlRWVZWWXhZWllBRTRIRnJYYkc0K0JIaGNFMm1ta0xvWHEyOUtUM2U0MFZo?=
 =?utf-8?B?dU5DVHA3RUVKSU5BczZmZHlRQWFrRC82c2lIQlpRNmc4T05FUDVJVEUyYXN4?=
 =?utf-8?B?MU1Xa2JtOEpGaEo3NHduM1FyeHBrbW5ESHpDSW5GYUIrbUdiNTdNVzBQNStt?=
 =?utf-8?B?QU9oNjc4aU11dHQwRjdidDNDSXc0Uzc4OERKeDdqK2NvQmxhTUNnaTVranhS?=
 =?utf-8?B?Vk0xK2hheG9PeERGY3FkNXk4WHFzaTZBZzlqMkdPaVVQejBQL3FBTE92Tm94?=
 =?utf-8?B?UVVjSmcwRWpQLzNXZlArMURvSkFMVEpVK093WG9tZ3ZIa2xtUTlGSTNiMDNj?=
 =?utf-8?B?NTVtK0tSMVhTMy84NUZFdWlOUGhyMmxPelRpbi90UGExUERhNVJkSENsYWpn?=
 =?utf-8?B?cTl0V1V1V2tNVjcxQWVYOTJ6V2dSYlZCNWUrSURqQmhhbmZFanRUWVg3WnBp?=
 =?utf-8?B?QURUSWdDMXJzekJCTitmNWdxT2haaUFNTlJNTmIrcGpEMnJKT1dUcm5yZXE4?=
 =?utf-8?Q?QM29IZ3iRacxzkkoRoUyLNWD3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a7a2554-9e58-405a-5131-08dcd1d658bb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 20:22:52.3340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kd8W7HXdocj84KjviZjCcvCDk+O6Wa9p//QzzEUEINqNqmlEea+ZMzWhIxzAa/kU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8836

On Tue, Sep 10, 2024 at 10:55:51AM +0000, Mostafa Saleh wrote:
> On Tue, Sep 03, 2024 at 08:33:40PM -0300, Jason Gunthorpe wrote:
> > On Tue, Sep 03, 2024 at 07:57:01AM +0000, Mostafa Saleh wrote:
> > 
> > > Basically, I believe we shouldn’t set FWB blindly just because it’s supported,
> > > I don’t see how it’s useful for stage-2 only domains.
> > 
> > And the only problem we can see is some niche scenario where incoming
> > memory attributes that are already requesting cachable combine to a
> > different kind of cachable?
> 
> No, it’s not about the niche scenario, as I mentioned I don’t think
> we should enable FWB because it just exists. One can argue the opposite,
> if S2FWB is no different why enable it?

Well, I'd argue that it provides more certainty for the kernel that
the DMA API behavior is matched by HW behavior. But I don't feel strongly.

I adjusted the patch to only enable it for nesting parents.

> AFAIU, FWB would be useful in cases where the hypervisor(or VMM) knows
> better than the VM, for example some devices MMIO space are emulated so
> they are normal memory and it’s more efficient to use memory attributes.

Not quite, the purpose of FWB is to allow the hypervisor to avoid
costly cache flushing. It is specifically to protect the hypervisor
against a VM causing the caches to go incoherent.

Caches that are unexpectedly incoherent are a security problem for the
hypervisor.

> > > and we should only set FWB for coherent
> > > devices in nested setup only where the VMM(or hypervisor) knows better than
> > > the VM.
> > 
> > I don't want to touch the 'only coherent devices' question. Last time
> > I tried to do that I got told every option was wrong.
> > 
> > I would be fine to only enable for nesting parent domains. It is
> > mandatory here and we definitely don't support non-cachable nesting
> > today.  Can we agree on that?
> 
> Why is it mandatory?

Because iommufd/vfio doesn't have cache flushing.
 
> I think a supporting point for this, is that KVM does the same for
> the CPU, where it enables FWB for VMs if supported. I have this on
> my list to study if that can be improved. But may be if we are out
> of options that would be a start.

When KVM turns on S2FWB it stops doing cache flushing. As I understand
it S2FWB is significantly a performance optimization.

On the VFIO side we don't have cache flushing at all. So enforcing
cache consistency is mandatory for security.

For native VFIO we set IOMMU_CACHE and expect that the contract with
the IOMMU is that no cache flushing is required.

For nested we set S2FWB/CANWBS to prevent the VM from disabling VFIO's
IOMMU_CACHE and again the contract with the HW is that no cache
flushing is required.

Thus VFIO is security correct even though it doesn't cache flush.

None of this has anything to do with device coherence capability. It
is why I keep saying incoherent devices must be blocked from VFIO
because it cannot operate them securely/correctly.

Fixing that is a whole other topic, Yi has a series for it on x86 at
least..

Jason

