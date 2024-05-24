Return-Path: <kvm+bounces-18093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E10CB8CDEF2
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 02:40:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 506C41F2251A
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 00:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 272BC4C99;
	Fri, 24 May 2024 00:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JRovGb42"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9056236D
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 00:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716511233; cv=fail; b=I7riLCLVkaZTV3h+c93bKJO00aKgRgitZAwxWVFDO9T1oEqa47yhkSTcDht7v7Pj+eYeIo6BHqhB+6bLVDqDJ/ccG6grmtpkNDuTziASSUueu6MJtpUz18b+sbgU9MSlmJEzhMLXiwClPepzc/iqTn013OcUF56xHshWtQ5ACNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716511233; c=relaxed/simple;
	bh=6QShrlefaNBAh31A4LWOYUMDUYUecXJRdARVwvUGg4s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IMqkSfyI+huLE2bRrp9XBlaCh5XdX9YHxE6HARMfgAp87omC6V0qIDAayR/yf6YsOS7CONlAM3W8yzU0rhXghiLJ2HHO2pyZBzjaZv3IDhTn87JGNuRDVVCQPs0nLJKK/6+4lVKIuzB7HRn6Gm6EEOzxB0X8YqjrIU2zGw14v0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JRovGb42; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716511231; x=1748047231;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=6QShrlefaNBAh31A4LWOYUMDUYUecXJRdARVwvUGg4s=;
  b=JRovGb42tPy9ML+x/jhGOhF75MuaUFKSnInO9DcV3jZv5VzzBlGos1t+
   7RbeclyvfZ34CLImjh4WlGTxsev+QdOwnif9x7pNFWplFZE1Rve0Tkr4G
   sfQATY4gCxucUwDygxSZ8CVVPHy2xfPLV3u3+xJvLDsTfQhD9z01WAfb2
   00jO9ABrzIrMiU6nnfv7EreOQoII0G9CdOhQbZaOEiD2AFd7rhmcs/9zn
   ZOmhFuqYB1RQEErF3BLEUbprN9CFCfsux72phPSkGj4HWS85gRAoALcX8
   SYOzmQhNOs3vXvOFof6TvwLOB3DvOHLLy78dEaLbrJGZ2REnlE+Gq1a2T
   g==;
X-CSE-ConnectionGUID: FgMwvYmLQ3CWujYGEpd3bw==
X-CSE-MsgGUID: QBuVaAdwT4GCp7+mdvApyg==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="13048916"
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="13048916"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 17:40:30 -0700
X-CSE-ConnectionGUID: eTlBR55jQmehiK5Og6sTfA==
X-CSE-MsgGUID: 8p9olk0dQvejLZ16wCPvGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="71260246"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 17:40:30 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 17:40:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 17:40:29 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 17:40:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2zoNixZYkK0tKiWhkdBzi5RYtT5RFXvPu3aMtUJ75l651C7YkCJzpIa+OIFQCngQqricFKCmemguLNvR6MQrBiF36LJdbeA7mF74BKXHpiSIPzBNp83FQmqoIykvfPDimvMEUYpHsttRRYhT3W2KBFW7zrWyXHFs3F43B+246NruPR7cKF30quDs9N3nyr23Bo8g5HS/xTly/wh6PBYJA4ELo3cwbVcbr5MRfoRoKiN+5OdyNgVfQKEOLgePrCnPiYODa3Okob7M1E8e7ZPf/6oQGNGhQHkNxEDkSA1pMEyJusdo/6/8KF2dyjYPYw+LRRNTLHfnTXUOFVlrJTwIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qz/ykoHVddaYD4UW8XaVC1VV80TevFg0dBG84yO/xaA=;
 b=ZMoH2U0vSxfchOHCo5SPLfHv4W06CliCVYtzBZAmkjToulhn2luP7pD762kca20Dfniku/OlQWfOyh3lSgZZVYtQm0xAnrASdAI4KHr01NVQ21yWZttLqCBlP4wtjQQxFZ/vyMtWsnBqtNxEA9ACGUYMfWjFUQ0WN9wsJMcZW3/gwFz9IhG79cLeCiU5CKdZtYS9d1cIKNUJLy+EZs0Dxamtp7Qsh7fGVel1SfG8YdLxPVvrIXelFi6mqS2ZyVZnAZHpiXqCEPEsIlyDSy0NbzxUMWXqO8i9F1pBLkqWcy5RgO8w1tYmxvRZ2WP6dDU7yHT3Y6lhV4+Qdtg3/gj0Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN0PR11MB6087.namprd11.prod.outlook.com (2603:10b6:208:3cd::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.19; Fri, 24 May 2024 00:40:27 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 00:40:27 +0000
Date: Fri, 24 May 2024 08:39:37 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <ajones@ventanamicro.com>, <kevin.tian@intel.com>,
	<jgg@nvidia.com>, <peterx@redhat.com>
Subject: Re: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <Zk/hye296sGU/zwy@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
 <20240523195629.218043-3-alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240523195629.218043-3-alex.williamson@redhat.com>
X-ClientProxiedBy: SI2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:194::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN0PR11MB6087:EE_
X-MS-Office365-Filtering-Correlation-Id: 268649b3-35e9-4b4e-9cd1-08dc7b8a1b1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?f5OU6rJLlx8zcBAjulSOcdbUpq/dwdoBh30ylGTxcXwMGIl1FkMiVHtIQuDX?=
 =?us-ascii?Q?RWK322Vr13YfwtbiKMc2CzyZYZey8pfQ/26/jDd4JKzJgB4BiEPhm1Os8Tmu?=
 =?us-ascii?Q?oX+Knmin7cxlvn+IZ97RzkhStJANWPiHAdbKyaEzMHlLfLSYJv7C50koyuFn?=
 =?us-ascii?Q?gD+M5s9T+aWvIyk8ojUPx1x7bvur/RZChV4pz1+kQVfWGwu/WJoSWC+l/SfH?=
 =?us-ascii?Q?uf7w8Os5nynRHp0N65PH5obZ3mdMy34uyKUMj+7feGqn+T6hil9FLADbfDSe?=
 =?us-ascii?Q?TttVAKubIH0iBy5wrOzIyfQKRwcwELhUfmcPxcOys2ar6xbwjM9fVdMHn54S?=
 =?us-ascii?Q?El7Xcxx5K052NJoo2lWUlTDJQQAOfIjg23x/MNd+01BOdkOg9rfVX9IhcFUe?=
 =?us-ascii?Q?qX0315lk6UvwQrqejI0EosFEZGZgfFR5Khw6NA8SjzMfmpkpn2MGN6X3/2hZ?=
 =?us-ascii?Q?PfNHsxbRpskWigrST30J4usekl2DtoGqwwyny/eY2WgIiQvLJL2NtumORALl?=
 =?us-ascii?Q?cva1oqLzNdIG1zDI+VGgtqZdKbv94YlfnGT+gFZnv0s/tuBGfW7GqFH4G6xy?=
 =?us-ascii?Q?+NyNVnqyAiBjt3ixwRr2dMb2ROpp/1TQn0EvEXpZxOSJDWmPk2AM+/slYwdS?=
 =?us-ascii?Q?ZvbW8QSOr8k6mG3imwb54mbF66P8kE5fHU74uVgdNo7BmR5u3luFCkgUPKN6?=
 =?us-ascii?Q?XZo9klUHg9Icz61YYJlQI7N1vN/JmIwlHvXKsLX+djzdJESn/XEQAt5R2cv+?=
 =?us-ascii?Q?yIq9brG9ZitqsupFkI2NO8RxpS8JBMTr36ez9Q2ty32CgAvkoiBGwhQSxRny?=
 =?us-ascii?Q?DdJ0gVuVbdG3ERUePBZtuUQVGxGVAUnCH1hjvhelul0dHurSiTVhqMsrXBMh?=
 =?us-ascii?Q?ZiGflTzDIVNC1mXMMVRGj94yqSBshWiX95BJMYHmPF7LUueM9ZprpM8rua3S?=
 =?us-ascii?Q?wPaTvIH8vxjMNCjPV0+VtlfstukpojZksFztxCYzONuLaNdGCihyBiI0H3Zi?=
 =?us-ascii?Q?l7CKugZUizVAozQPP8P7fF5emqqCZfIlQB8oHGsioQCjfRUQuw56X1Xls5Dk?=
 =?us-ascii?Q?oS5E1rqb1xCN7KRXpFEfBUbxsmjGfdTOBXB4HBtGm120IB1zv7MfLCtsDV0G?=
 =?us-ascii?Q?vV5v7PIunTD9FvoF7aMAyYDa/kMcB1IhncU9OzWfD3pq1kAwLbjPmvh94pH/?=
 =?us-ascii?Q?/Q0gNrcRrB/o6/bXGoHaTuOHFgy1DVLx5w42gTRyPfjyj56Jv/C4BN2itJi6?=
 =?us-ascii?Q?kEGZZEz5PRxSzmiJnNEEhKDdGX4Rrs9DtHvV3OjerQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cLRQecanJcKqXSGuMwpIUNL0KFOWbDlzb72r05vuVRvsAzLZt/CU7hM/tJcV?=
 =?us-ascii?Q?nyVl0BI2j6mReEET8fMKU12iQrs9FJsPWah3XsYu+sLA2I+sxlcIc+Vvmngj?=
 =?us-ascii?Q?2U42NubgeZ5cwjkqpghauzNaMJNYZPwHee2trgDDUb0l9FE9IO3rsLb+gboz?=
 =?us-ascii?Q?lsxNG829S/quVzdppXEypIjv5N9EIxxKAg7wqFDOikrYzo329mxk8tvHKlL6?=
 =?us-ascii?Q?/Ynw2gFG+gSrV2DMpqDJeJ2jlmngvH4Msv9Rq7n+CCNoT/W1puMe3yRgpsOe?=
 =?us-ascii?Q?FCA5bArqK7mjLU/U/fvRrIPLWgpYnufIhO//t/WaS67TAD1/4IOo4efauWSd?=
 =?us-ascii?Q?D/Mq/IX3nwrmu4PKkK6ZIULtuPxqvCAx7gsU6u1SjTjpGTpWrL9Vncge/Kew?=
 =?us-ascii?Q?aQ0u8IDeAPbVECJfrKJCmxTRJaGIqSiMgtdXjo769p3luIlwUqQLYCzPR7kn?=
 =?us-ascii?Q?FimpLfJoydMBVPkMEDWvmslaKxKhats6d0dgCURZKnb9nWPhm3nU6srP7zA/?=
 =?us-ascii?Q?Z8hptlVFsZXshgCsjiETmpIi51lZBY1Nurh5Yz20sZ5+gL+5N/xq23E/TOAw?=
 =?us-ascii?Q?BPLLZB7AI0yA8aX+oEWwzNKx7uor0WGiW/BTXaqjdRXhrrKNrIZkvWFr98V2?=
 =?us-ascii?Q?5t6/F29kTwVRebnrv9kd/qHK2Vlz/K4z2pIEX2xLlZ40FfyrEyk3dhGvwwjl?=
 =?us-ascii?Q?IJRi1W3sOwh2B6KBPeAJ8wwh012asG5oaB0Cd1uMhqSgeZ8n3rtVWxaNau2W?=
 =?us-ascii?Q?pOKSWfv3/w4KiUp/Zv+saPndNxaGJvJ/ctkhkQnkurE+hnhyqjL825qvy7pj?=
 =?us-ascii?Q?vAvhcun/7CFiBqB7PDNCu1zSsgYTOSQ0LU6vlVWYIUw8MVDIOTIe2R5TTL6Z?=
 =?us-ascii?Q?W4v9fbIZg+dfN3RbncEp3jaNVjcuoAcnaRXa2a5JjGG5f5LIC5cC58F5Tjxk?=
 =?us-ascii?Q?hhtIcowiT2ciUEvi8BW+TfWkAdcDD1kmQHJFbfeItqY8wFQXSbIkaZRPe80A?=
 =?us-ascii?Q?Wjfb3F2WMmZMOCyScZu0NnSAejg/DRsiQQVEBVNUCqmkQJR9kCVVg3l7Kka2?=
 =?us-ascii?Q?ap7Bcs9HOc8HPKDgbLf2nW8pTioCE9JVlHwN+TDPOSIGJAAlBfJeaO0GcAtV?=
 =?us-ascii?Q?X7iuyBCYqlQMgZxGAfmiy7nZC1325ElJzA5bVdcTkx68G17vOigybjkLQajp?=
 =?us-ascii?Q?2S75WeumFQq/DatJPkRDOe1jx0E9H5PcKCGgqqHqOk9WV5C3CmXSHq+K2VMN?=
 =?us-ascii?Q?fuE0ANIpXWA+x/VBArbokwuJnesMYhm8H+Gqy+O2JyX1vmCkenmGhX4vOlVz?=
 =?us-ascii?Q?Cdlll62LPSEHX8Ja6/sUKFb5w5HcOq7k0GSEFHQ1D7lmpTPXVqFAM76MGLcW?=
 =?us-ascii?Q?At57a/sUkY27kSAKh+s0U8X6rxnNqOe2fKkosJD4mzdMq8gKPKSXXyS7bkYf?=
 =?us-ascii?Q?8Ohq6mQn+pCvSdB5V+A5vKTVPOEg3zB93RnMfNuIXMI5jMZcb0bxk8C1c4s7?=
 =?us-ascii?Q?ruFICpEVkeciZGDi/JXkZkCRfbbetpjCZApiuDZRwuruuMAcUAnqajmLv0hP?=
 =?us-ascii?Q?mDh7x3FbMQDUcgwVH7yTM6qmtfu20Hy5uTkezBIc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 268649b3-35e9-4b4e-9cd1-08dc7b8a1b1d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 00:40:27.1697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5IEezwlGm44m9YnDuaX0GAsmlFiw+p3XjKlwKmvqp/SN9gReb/Lq7bQ3cxH4H3MZ7cksO4EjA1BhSWlv4lgCFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6087
X-OriginatorOrg: intel.com

On Thu, May 23, 2024 at 01:56:27PM -0600, Alex Williamson wrote:
> With the vfio device fd tied to the address space of the pseudo fs
> inode, we can use the mm to track all vmas that might be mmap'ing
> device BARs, which removes our vma_list and all the complicated lock
> ordering necessary to manually zap each related vma.
> 
> Note that we can no longer store the pfn in vm_pgoff if we want to use
> unmap_mapping_range() to zap a selective portion of the device fd
> corresponding to BAR mappings.
> 
> This also converts our mmap fault handler to use vmf_insert_pfn()
Looks vmf_insert_pfn() does not call memtype_reserve() to reserve memory type
for the PFN on x86 as what's done in io_remap_pfn_range().

Instead, it just calls lookup_memtype() and determine the final prot based on
the result from this lookup, which might not prevent others from reserving the
PFN to other memory types.

Does that matter?
> because we no longer have a vma_list to avoid the concurrency problem
> with io_remap_pfn_range().  The goal is to eventually use the vm_ops
> huge_fault handler to avoid the additional faulting overhead, but
> vmf_insert_pfn_{pmd,pud}() need to learn about pfnmaps first.
>
> Also, Jason notes that a race exists between unmap_mapping_range() and
> the fops mmap callback if we were to call io_remap_pfn_range() to
> populate the vma on mmap.  Specifically, mmap_region() does call_mmap()
> before it does vma_link_file() which gives a window where the vma is
> populated but invisible to unmap_mapping_range().
> 

