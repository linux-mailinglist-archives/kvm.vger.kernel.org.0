Return-Path: <kvm+bounces-29352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCBCF9A9EE4
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 11:45:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72DA9283019
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 09:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBCB01991B9;
	Tue, 22 Oct 2024 09:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Tze8VMaB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEF9199EA3
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 09:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729590312; cv=fail; b=LikDtXhFTtiJgIDjQLeV0fSiV7ys4Jfm5qF9MvXdu5y4hLeRMhi5iSLOCEnYLxo/R+oHe3ea/hohJSsjO/53l/uuSprYWDCsypZsh4IeouBkKB47Uc5x8IwCeMoFpf4w5HNrJy5muPM+rgVYlME9yYFkPhryWMMorbePO/BuN3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729590312; c=relaxed/simple;
	bh=X9JCP4FaglR54gJ6EIlk5Lr32bzB2MZC8JCkrkVdE6k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Qn36o1cA3fc5HcFOed1SVNB6yvGQWfTI/5fUaFEDwyW65CvLMhDW2QNZ9NOVdkmPyLxRknK64zKw19w7uzUNJma99W7UzBikYEbIhVOusIwk4KDcrzIB3NGEdh4+YWr8jtU1aVQC9V+DdBkh7g5P6qabb6RElehDRAiA7n8CzAQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Tze8VMaB; arc=fail smtp.client-ip=40.107.94.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lsAM/4Z40v8iJbSp1//cAyDdNAUQty0KstXGl63mY6uwCZAHfzw/gqrftpNonFvFnqhYLGkjZpudPjD+v3quYSZnJvoeJqf/pZBR4xsGjIXJfJ0L3B4SWFzo9z/NJ/2QrPVueRT9RSXQ1GDPxC4O0kG/FqbQB52IzK804OuWnFGvvmGzJQ+D6SQReTzjZMqjTIH7aYFduxaiQbHScKq0/UbY1xcp3HMxzo2x8FIHHcH3LsnF2J5EHJnuoIp/PYoInH5VmsDc4Os6YkdY5C3IS/6eCQEmJaHcHOzUx/VlldCY0sPVN/F6bOKMD1djqbtCKOHgAj6pdmDEh3z3xoeBqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QHj4MbQASO8dIZ2VarOYxVRExIlc/7epQdOL6uAkuc=;
 b=f/S0w0mVBvjxkNIRWB+a8+ugAEdMLBRst5pDtLi2Q/JENyMNA2XL2ufPRDj9QMBKGv73W/Ou/i1D8k7tgsZrf6DHcV4T9mJWN0q52NvCjx+gC/KoSWcQiqp6MOxgP16YkTX46c0NF9fuy1BovNfL899qICh1jXQpoxxkRYpmD7CzDMTWcoohKg0XrSiYXpBwE/rXFSXOXmmdVhwT2JMTMy5tOzHeeZGMAO7ApHXmNL9Q4z+dbEnNKhmNQXoUrDlxThV6KaKNvXr+rQno5rAx8HWLpxIENpy12EYhJrW6+Hf7vJ+n8BLwBJvfWqEhJaD5Ju1nrA5CoJFXNg3uvO9yRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QHj4MbQASO8dIZ2VarOYxVRExIlc/7epQdOL6uAkuc=;
 b=Tze8VMaBu2Hgcwk9HWSpGBqr8doxsY5dnMRqJLDTWJRLs2/dMbo5+5TBtn8E612j4Or9CVNmm2RjYhxuTBe+I5fIydsD+b9fzzNGOn1LQHwo9DWZETGhGbWZ+7exLvrFMx9eC82SXUZMZ6lhdwGqLFtfpC+nLu9y526JPxmes7w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SJ2PR12MB8181.namprd12.prod.outlook.com (2603:10b6:a03:4f6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Tue, 22 Oct
 2024 09:45:08 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 09:45:07 +0000
Message-ID: <b6f7f648-c509-4e95-a697-f2c09b1cbf6e@amd.com>
Date: Tue, 22 Oct 2024 15:14:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] Support attaching PASID to the blocked_domain
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com, baolu.lu@linux.intel.com, will@kernel.org
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com
References: <20241018055824.24880-1-yi.l.liu@intel.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20241018055824.24880-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0154.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::7) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SJ2PR12MB8181:EE_
X-MS-Office365-Filtering-Correlation-Id: 54118cc9-0f00-465b-c9db-08dcf27e3664
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cXUzaUNKSm81dHFhRkJxLzF1aVNFSXFHV29Pcjk4akx4MmdzUXNnSDFsT0xF?=
 =?utf-8?B?SG9KRDdMdkNqNGkxU1lxMDljYnlka0JoT1JGbk5rK0x4OUdwS2x0ZzMvMWJ5?=
 =?utf-8?B?d2JFRG9taVNTeXdHNmxvbmdkNDd4eWx2Z2dYbnZuWGg1aXB2SU9KWXRkNW5M?=
 =?utf-8?B?ODRMdWYvWnMzMlBoOUsveXoxeXZaOUxBTGlMd3dvZS90TitId2FpTGtFdlll?=
 =?utf-8?B?UmNOVjJ6cXd5RlRxZWpyQ2JzK3NxbTRTa1lOWGZ4R2E1dnE2cFNlOG9QdXdL?=
 =?utf-8?B?YlFEL0N0SFh2K1YvNE91cnlGcHg3M0IyR2FJTmhUaVZ5dUlranBvN2FLRFRy?=
 =?utf-8?B?T3EreDNWalRRT3pyMllXM2RFdDh4S1VxUElKa3E0VzlXQ0t6SHdQVGo0UDJs?=
 =?utf-8?B?bzhoZHM4Y3h3bUNWaFZpVXA5TXFUNGFCZ1l6U1RXMjlYOGNhMEtCcEhaNEow?=
 =?utf-8?B?eGdKTHBQcEJ5RGptUG5Oc3o5bHd4WU9LZ2RFYytsNWJON3k3cDBsTER3b3kz?=
 =?utf-8?B?Zm5OSVo5YWovT2g2ZG43UVVWNFZKL2gxdGZqMHlGWVBxQURUazFwYzc2dFU2?=
 =?utf-8?B?cVJDSm9lZFhTeVRQS1ozTGk5S2F3MXY3UXgvRnoxdkF1a0VpK0NuK3JyemFL?=
 =?utf-8?B?cW1wcHpNTW5zTURXQUYrMTBBL3dTeGljeGZLVi9XQXgwUkh2Uk5WTlJUVEpn?=
 =?utf-8?B?STFodHNYczJGb1JUeG80enFIOTNDNzZhWldJSWQyb3cvRWVJalJ1UEcwNmVr?=
 =?utf-8?B?NTN5SkpYR2RUSkhmRWo3eGFqY0MxZGhJZGZlWEgvUVppcWpCVFg3d20yTFk3?=
 =?utf-8?B?NDV5ZkVpK0ZmcDEvYkpRMGhXV0gyZnpyTWM2RDhsazZiZEV6WGRyZ3hLVWc1?=
 =?utf-8?B?UzhrbUVxbkorNnVrNmYySkVVaWcvcm9YQk9DV0wwWkwzRWxnMWRYZkduRTd3?=
 =?utf-8?B?WGphSkxXeEE5Mk5mSkJaUlBYVk5yandYVlV4THNzTkdjVTJyMWVFNkNvcCtM?=
 =?utf-8?B?TzVTeWU3VncvZkZLVEt5bU5mZmZBbGt5UENyd21XL25hUFBtUWtBelZOTzZN?=
 =?utf-8?B?aGZyQlZ4Q3BHUjFEcDFtSGhsWEVMMGFYcmNicUJjc1Zpcm1XM1BacjZpWmRU?=
 =?utf-8?B?QjVMbDN1RTd4VVRPNjhEK0huRjJCUTFoTmVxWmNadW9SVFhBaU5PRTZuK2NB?=
 =?utf-8?B?b1ZFSitXN01JVmdBOGxHWjJGY2tqY0o4c285dXUrUXlGVHFJTmpyR3NRV3d3?=
 =?utf-8?B?TEVHZ3REV1lGTlo3bG55Z0dpN3A4aTZCcU54L2t2QVVGMmswclpzOXl3NHVv?=
 =?utf-8?B?TTA1WDR3ZHoralpXTVZ3UnpzZ0pzbTJQM0VFYnk3eTNhS3dXMTlGUDZtb2xM?=
 =?utf-8?B?L29rODRQU1MzV1VuN0pzZU5jZnJwc0NvOUJHc3ZZbjRwZTNUY0tONEZWc0Nu?=
 =?utf-8?B?RTA3bFRUTTVsZ250L0lWVmc0RitTVXFINjIxNGdZV1dSY0FJYjk2NHpWNzI2?=
 =?utf-8?B?dkdEQ1BKK3JtWk4xYUxXdXp2dmZZTTQzZ0t6TDBCOWczTEExN0k5OCtCeDFq?=
 =?utf-8?B?eEdXRHJqdFF0eVI1c1BMa2x4TTNCMC91emloNVFZc1pUMlVXSjcwMDhDdzBj?=
 =?utf-8?B?b1YzTUZsdXlEQjVOK2FGb3U0NDNaSlBiL2Q5Qk00YmZVVE9yeGtXUGFBRmpP?=
 =?utf-8?B?UnVvSDJDVTg2SWRESjFvR2NtY1JmK0Z3ektDaFVWdHg2SEd1M1lFbnJ3Z29X?=
 =?utf-8?Q?UdrKnSeR3xxYdHLN13OtX46anb4gJbEImxPXXbb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cE5OWlJEdkJKUTMweEFrcnJ1YXp4QVpkN05BczVBQU1GYXNKdDNtbXF6Z3NZ?=
 =?utf-8?B?bkFKOVcvbXZQdndGeENYays0OC8wUVZzakw4OUluT2UyYldUREtTdUc3cFhi?=
 =?utf-8?B?TEt2eXVxelMxSU51Uyt0M0k4SUtocFUzVmpEZ3RCUjdBZHZtTGhEa2RqZGFy?=
 =?utf-8?B?Z0U1SW5VRnNzT2VMSnJVR2NpbnRZaVdJekVBT1pxQmJrckhweUZmOTFjemVT?=
 =?utf-8?B?ZzdXRE12eHJqaTVXZTR5a1JOSWd3M1AyQUV6UmJlTUdBZzZ3QTRwWURZSXBZ?=
 =?utf-8?B?ZXgvdzJaajRWTHFWWkNBcXdOeTllREdGYmlJeUxtRktmK2RZUkU5b3RKNTI0?=
 =?utf-8?B?TUZJSWpaOTRKQzJQYjdVTVBSZGt2cUlZeitiVndMbjFSUjdFekQxc1BpbmU1?=
 =?utf-8?B?akl5ekREdEZrbHZHNjNDV2pseGtHcFZMWEdCWTR1QVRhdHNvRzN5aEY3SWFo?=
 =?utf-8?B?bmtHRFZXNi9TZzBZdzVsaHBFV2FOUTk0eVl3cHh6eXF5MlE0dmFBT2ZVQkNH?=
 =?utf-8?B?ZTdYRHVmTUV5Y1dWcUZPTndVdGZCUkdHUzNwOFJKOW9DeHJXb3NxTk40TXZt?=
 =?utf-8?B?d2Fac3FGQ2F6anZwUXlSUUxYM1lGTFhFeGZsNU1ucjJpNktnWlV3bkpZR3Ir?=
 =?utf-8?B?cXlXUjY3aThJMmlFZm5vRTNONTNlbUhpUUtoSVBVb3FnUkZOaks2RlhwODkr?=
 =?utf-8?B?dXlXaUhCQThZTXdnUzA1eWdwQzdoc0xuZHlyU0ZBdnNhK3kzbGJJSjlqUWdt?=
 =?utf-8?B?RloydURxcTRzSHU0MFFUOTRyOEh3RG1kK1gxTEdKdncwaWZCQ2hCdjI5U1hy?=
 =?utf-8?B?VG1ldW5SM1BJeU5vM1dpQVdIT3hzWXlaZzc5NitEaForZ3NpOWpZVFIzeWJ5?=
 =?utf-8?B?Z1VpY3VLR3lBWVdLNElLdVZDTVprblVKWEoxM2JxVVJ6MlVMRWtKWm1VMmdC?=
 =?utf-8?B?NE9HN1dOTi9zSFJGVWdKZW1URWxTOW4zb1g1ZDV1anlKTGFybTdPb3RvczFt?=
 =?utf-8?B?eTBVNDVhOTZYb1ZJTkorOTlJeEp1Y0RINlZwMEZHNHdHQTBUNHZmYXYyeEhx?=
 =?utf-8?B?Vkoxam40ZnFwVyttbHEvQ1F5MTl0dWNRNnI1ckxGUU9wV3VscTIxMTFlTk5G?=
 =?utf-8?B?djFhR2pHQmFlYU5qaWIrNXlrTDJhQ0J2NFY3bks3RVFzaFB1NUJMWWk1K2VU?=
 =?utf-8?B?a25UemR3eUNTc3FYVFlRQWRvZHBhY3ArajdDNm1scGdLTVJXUy9FaThJWFk5?=
 =?utf-8?B?WTlSOFNPSlVERmx6eXlFK29NeXF4REZDTk5aTXFDeTI4S2NSNDQvTENJTmJw?=
 =?utf-8?B?NGRFVjB5V0ZrZ1R6Mlc5OTh5Z1ZwMW52Y1JuMnNmT2IxalN5QmNZdFkrSWhT?=
 =?utf-8?B?TmwrTFlxU1lYbFZEeXF0K0xleVlJbHRlaytIS1ZRa2Y4czBJcDhpcGRYTytD?=
 =?utf-8?B?R1ltdlZ6QXZ5WjhVMkhEOHRtZmRhdXozSUpoVExENG9ab3dadFFKdWFDczhE?=
 =?utf-8?B?WDUyS1pBSG92M0RXbnRoNnNYLzdzbHY1d2tMS01pNENtd1lCdURTd0hsdkpa?=
 =?utf-8?B?UzlGdFNETHFMQUpSWVc4WStSU2ZlalM3TFF5SmhxcEJCOWVMeU5razRPT2Zs?=
 =?utf-8?B?L0t2Q1ZaandRbnJNV05tZzRVM3FLcE1iWHpkaHlsOUxrdUwwMUlQc01pL2do?=
 =?utf-8?B?YWFYN0tTcVRFNUR1ZHFXa0hLTjJrUFVHMWFtdUEvallINXhvN2JNeDc5aEpS?=
 =?utf-8?B?QXFmdXd3QTJpTkg4Q1R2bkxZKzNYM3ZrcEFoRTUvblRPZnpQdFFMZFNGSzN6?=
 =?utf-8?B?blV1NXZra1cvOTJNN3B5THZvaUhlRklVcDdpc0JlWFNSYjg1Z2dtaFovN1Ay?=
 =?utf-8?B?SjI1S2tuWUlLbFY1ZytuVFlrUzQra3pqUVNIUWVGWTRCUE05RFkraDc1WU8v?=
 =?utf-8?B?VEdEaDAvWS9GNjBlZytUZ1pNY0hIZG8xejF6N1BYMEFqUTJ0R2daRnhUbXdD?=
 =?utf-8?B?NFQ3RjJEZE9nY09weWRKek1URmt4Szg4L1hvVlRocUxmYzRvdnhMNXhXNVhB?=
 =?utf-8?B?Qmx0d1R1K2RnRCtUamVQaUVEWkIxOUxzdjBqckthcGozNjBkc2puQUpNTTBl?=
 =?utf-8?Q?xyheAAeVwiIMWdzuTRjG9G0FW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54118cc9-0f00-465b-c9db-08dcf27e3664
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 09:45:07.6599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NaGyAG/DWT+bXi2NKyPWMDcGoiYtRJuv2FcUvs2UHfYM5QnJyvTURoKUgytd5CSLj6u9o/IY7p9OZPsODofA1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8181

Hi Yi,


On 10/18/2024 11:28 AM, Yi Liu wrote:
> During the review of iommufd pasid series, Kevin and Jason suggested
> attaching PASID to the blocked domain hence replacing the usage of
> remove_dev_pasid() op [1]. This makes sense as it makes the PASID path
> aligned with the RID path which attaches the RID to the blocked_domain
> when it is to be blocked. To do it, it requires passing the old domain
> to the iommu driver. This has been done in [2].

I understand attaching RID to blocked_domain. But I am not getting why
we have to do same for PASID. In remove_dev_pasid() path we clear the entry in
PASID table (AMD case GCR3 table). So no further access is allowed anyway.

Is it just to align with RID flow -OR- do we have any other reason?


-Vasant


> 
> This series makes the Intel iommu driver and ARM SMMUv3 driver support
> attaching PASID to the blocked domain. While the AMD iommu driver does
> not have the blocked domain yet, so still uses the remove_dev_pasid() op.
> 
> [1] https://lore.kernel.org/linux-iommu/20240816130202.GB2032816@nvidia.com/
> [2] https://lore.kernel.org/linux-iommu/20241018055402.23277-2-yi.l.liu@intel.com/
> 
> v2:
>  - Add Kevin's r-b
>  - Adjust the order of patch 03 of v1, it should be the first patch (Baolu)
> 
> v1: https://lore.kernel.org/linux-iommu/20240912130653.11028-1-yi.l.liu@intel.com/
> 
> Regards,
> 	Yi Liu
> 
> Jason Gunthorpe (1):
>   iommu/arm-smmu-v3: Make the blocked domain support PASID
> 
> Yi Liu (2):
>   iommu: Add a wrapper for remove_dev_pasid
>   iommu/vt-d: Make the blocked domain support PASID
> 
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 ++++-----
>  drivers/iommu/intel/iommu.c                 | 19 ++++++++-----
>  drivers/iommu/intel/pasid.c                 |  3 ++-
>  drivers/iommu/iommu.c                       | 30 ++++++++++++++++-----
>  4 files changed, 45 insertions(+), 19 deletions(-)
> 

