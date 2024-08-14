Return-Path: <kvm+bounces-24132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D833F951B02
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 14:40:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 981AD28163F
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 12:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A311B0124;
	Wed, 14 Aug 2024 12:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tcsXOBvc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E132115C9;
	Wed, 14 Aug 2024 12:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723639206; cv=fail; b=dooGkaOK5lSmk2+eyhI4HG6bRxYRA/Q9vyOtjQkP8++PPY98WJMYqFO0M2AwH897O2t9A4Vd+GGPsI7eRrzZ9z8G6DorxNSlvYmGxUnWlv8D2Sxhkopd+fLeopDlHxgaHOtLy55ejzJ7cONyRnrVAtQFrcqw1JggyONJG7St4xI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723639206; c=relaxed/simple;
	bh=Wi2QdcalG3TLC2ZrjmqNNtWEUFKEdrdvA/ReSEdi5Sc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=L61SedOIKQkR3cRusdmWEqD2Gjb6erHHTi0Er4eltPp9GdyTT+fUkwZi2zzWJffhMeyoZgQipzi/0fxjDeXnsq3oyg0ZvDT9l0BvepThhnAiUQMRzW3wvqa+OaSN+riwsnO9mAcB1l3fXoY/b3CafN3d1B+tyxMNPcBr063vwTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tcsXOBvc; arc=fail smtp.client-ip=40.107.237.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NLPHJLNw5WaSCcQtdVBpFdPlzHwoWsHFIL06o5TQ8BrGjVy1lUiXO2ihJidsdqaruibGqGpOpv62NY3eCmR9Scf2oKrzBPquBPrKWumTWCCSNrT5xX9ECfB4qq9XdxfmfMMCygL9uji7nVmBsrcf684mOf12zGpDNNa71Gq0+OyOiJhzNsMJefJ40w/m7iow87/29FBWUI0WJBsvX6LS9iU/5E2+5h9HREtLVQeJQexEQZ3VHoaddu4zB/q9Wp0kuUwG3VWfahMPT1/65I/X5fgCz6tI2RUdwzt9Gxzk/sC4ZN5OjYKLPw/MqsM+1jhaDTS5oaKX8Z32UTShGukQNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QKPTUkRutQ6zNmcBlfmzH6WOL8gyzeBS9Y/FZdbhz8w=;
 b=NZ4n2gZTOD+2zTWsXCJRO8Y6COWaJRnNvG2qO6Xog5AEMgZBoq1QKQQyeKOG/XXh0kR9zkQf0bHr621qyqb9Q+CDKPdvsOCeSZwB+7dZXGY2HclTJ3iwpzuiF7/4xtIMojpgF46dznx6DKL3DvPsfhU1sWbBz4ieSirBUJ3I1k+Y3ix8n1AJcZHnu/SnyKY6amzY5dOs8VirkVvfwlYMtwtVRJ0uMaTu41lI5zfydp+u4NHB60JVgUutcd+Zhxuw65WL4vF8zH2gIA7VFvFwNZyLyvYHIfL5NP872TGUxcD5/qwcsWy4HzE3WJy1f7GgLED52SkcCvb7XI9LRPClFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKPTUkRutQ6zNmcBlfmzH6WOL8gyzeBS9Y/FZdbhz8w=;
 b=tcsXOBvcUNMkEf4vHnXlcD9UNOXuBKoO/m6By3QoAwOZVrER1oE0bvN7OOdhmI3bq2KmI3fHuGSqvz21MD4ak4rt8XNs71dQmZklGgHVBU3HmW377zOShZ77G1SFj0XhdNrvj/PaslHHi4W9GMLF2qPRfUZXajFbza6sPnv2yi7h5czYY2QNNiozjz2SXkdpDMpXy32RJ0TEgzUkc5QcHT9JvAsh27vyylDVW02x7fwHkH5oieE6/PduRa/IQGw/d8pVZdhR4W3AOzR9D+/Zc4RhULLZkuGIC/obg07Kmk0/TO79R8FxVYuRQxeLY3GkXZkBMWTY7O+gOSe0dFFctA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16)
 by SA1PR12MB7175.namprd12.prod.outlook.com (2603:10b6:806:2b2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.20; Wed, 14 Aug
 2024 12:40:01 +0000
Received: from DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52]) by DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52%3]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 12:40:01 +0000
Date: Wed, 14 Aug 2024 09:40:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 03/19] mm: Mark special bits for huge pfn mappings when
 inject
Message-ID: <20240814124000.GD2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-4-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809160909.1023470-4-peterx@redhat.com>
X-ClientProxiedBy: BN9PR03CA0700.namprd03.prod.outlook.com
 (2603:10b6:408:ef::15) To DM4PR12MB7767.namprd12.prod.outlook.com
 (2603:10b6:8:100::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7767:EE_|SA1PR12MB7175:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bdf173f-eaad-45f1-7b39-08dcbc5e36c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pplfUQu6bGMijosN4Y9DPVrFqBm1xMc2FXkGxRYDOVRzg12gZ5b5IM3mC04R?=
 =?us-ascii?Q?Z6aZ97lDNoIODDD6rx0I/mCvt2I/36Xp4wRn1nOr4ncwFukD/4gwS+HEg9c6?=
 =?us-ascii?Q?Y7stMQJ+bhhOR0eTJaRcEkvRvtXoWrFnaAy2TNaNOYro18x1YYkQBXXdws0h?=
 =?us-ascii?Q?y9+vbL2ww/y8d4Gn/j/O/kfm1aZxtD+NuPY+gxa938f4VPCaP4oxpoVW+p/t?=
 =?us-ascii?Q?uXtX6isblDNTIawvoPZQQDH9rjluPy0doWm0132JMHONJcpfzcYa3N0Fb+HQ?=
 =?us-ascii?Q?Njeudmt8kl9xeuAsbTNgTDsSmB2DKcjP5v/kUJGfJahmUyi7QBN8T+6fdn4F?=
 =?us-ascii?Q?YzaipMT8CgKengoFsP/COC1+cmN5M8Hn3Q8y8cp5d88fPeTJh0qO7eR3DJXQ?=
 =?us-ascii?Q?6U5JsGd46054X3s7eSw1be3pr+xILIzA1kjyZhILjEGHANMyqHS2olkvQvPV?=
 =?us-ascii?Q?9Pj0oTVuP+1K+BuCPrRe380jcAGyGFMejkTxfz1dOpQK4YpE3FZLpHdAbs0s?=
 =?us-ascii?Q?5uGBOTyMw4av4xAlMxU2ozeNcfV8ZIXElYFE/sCOJ+GCoBw25hO8TqlGiaDg?=
 =?us-ascii?Q?96aIV7AjclkAO9tMFG87n5e2DLrZFRv1rbAZHq0OviEQmlLHF+Gw7Iu5NLCn?=
 =?us-ascii?Q?7wTGpKXtZUt0C13yydnoqQh2HdHJGU3rLmOAx6oC2wF6ui3qucy6UglDk/KM?=
 =?us-ascii?Q?alQKQyHwNFlBCNchQ6uC7ruIEQhYXXwLZdE+l1IMsCGimjRnmoEUK2g1M5a4?=
 =?us-ascii?Q?t64otoAGfMNtVfiA5uTGnlUs6KcN+tkXcikWWt+E44PIit/B4Id972EQF8FT?=
 =?us-ascii?Q?ICuD0QJkMgdVbHlNeSJruFG6e26h2cEoeFR7XTTfC1gnPc7nTkVykg5/1V2y?=
 =?us-ascii?Q?GH8AK1zMA1+WZvqYKH7/y6imPOY5ki2HKm9d/CZhnhpUDwGd1zsyhwNX6fxG?=
 =?us-ascii?Q?qygtygLzekEs+UnYKSS1T5LOajFrtgGx0/I48ssJ7+lHxBXQDnH4PhEajta8?=
 =?us-ascii?Q?d4bTn14UQk+or0jPKYsw6TRyaSze6Y7xOfK13haWr1VtbsKgg9V760OWZHzW?=
 =?us-ascii?Q?6whoEfgPZqOqlL32/Vu6/C8gxHiHwDQ/lHfawgABdpj5MZAl9QK/N9SG844r?=
 =?us-ascii?Q?Ype4PwrSD9W3Bn9TS7SIdTDg8RJX81NVG/mezkDoNcbUvmol7eBHLI2e+03H?=
 =?us-ascii?Q?kunYod7vc/d3Qc4HJjfRQS26/mBTQhOFdITh5KcsioaUwAAThv2dMWsZefLJ?=
 =?us-ascii?Q?i54CdMibH6XFB5Y0mAzz5AiVR5ReiLKzVQgF6xVp10Jg2L+Q4YJfy5htwvN+?=
 =?us-ascii?Q?P77CTq0lF9lAb+CEG7MROw+DB8sB2sKMMaIc5ZQLiA4rng=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LtzqR+xkFVlMsfAEPmF3w1l3qls/ePM86yU8kSjpO9T20qUSp4yC1XKYoY+J?=
 =?us-ascii?Q?qhnAHneMMIo8hryV+M5HMrpimA9L44zTXXz/heKHuZo+hYGW6x+e5V0Ijxjw?=
 =?us-ascii?Q?i63/HQWM216ncgPMkJ9a3/dijhodVvSAHproXOldCdNbX6KYD674O5Xn7M5r?=
 =?us-ascii?Q?1HxVeZnkcIB8q6LK8RdCpJEkuUoQL4+TOKhQ21PpY/pzkZh6Bjy+kFearICA?=
 =?us-ascii?Q?Cb8DB99Qy/pTcnzOUBZjSrblJPqg96WRHALe2kgzb9PLQGpSHJi+mOMIk9yl?=
 =?us-ascii?Q?dKiMJzs8kTkZYIJxRD8xT0RGUZTyIsmN/p+heSeHkX97P9NPNND2eOhMzMDs?=
 =?us-ascii?Q?GoPzyG2hkUcJ/7LZJo8ZRbOs2Lvt7DcL4tZgoDBVYb1fD5LPQWXb6UWSIXGS?=
 =?us-ascii?Q?tv2SbI+BKgB/W/re1rscCKLBy+eYJl6NI+lPP5xUDw2Vf2kobN+UO6+W4okd?=
 =?us-ascii?Q?RHcEBO2qhInEymNLL8fKi+KO2b2nHCh2JtgVy+Vq2TU7ylbRMsPwPMIHVlFw?=
 =?us-ascii?Q?9TiR01Rd7r4dxN4maR3vcJg3LPPGvl2vjOMpBL7DYZRdjyJVWJy79eGFbVqy?=
 =?us-ascii?Q?QCvAIbsnhT6EXKCYnD2s98LljNdMX7cc3c1KTcN3FD/V/SjvC8aEOgFfN4W8?=
 =?us-ascii?Q?uLR7ePTbj0e5GYcy3z5XEEe8HAKF2sZXXwDt0hRBLG42ldvFld3yJLycgZck?=
 =?us-ascii?Q?UinoYIDj0ObEGAL1YujHCZ587zus2hgTIgcmjSM8vXpmuZLEckekCKviVC42?=
 =?us-ascii?Q?LdSsIEmkpY5crWX/3RXccDXNwEBZwtRy+Znx/EuO+rd6vhlLlDSAj3s+6u0+?=
 =?us-ascii?Q?MISEoTe7azk9spTFGuGqiuL+cNE1wNOfj5BfZHoCtbU/ym1BPSw7dreoQkaJ?=
 =?us-ascii?Q?FwkT+da11UlXM69U1PidGjLqhktEWhPeDsU61foJLfDXgGMbN5TcYIaECiAi?=
 =?us-ascii?Q?s3VjS3uNUFA+I82m81Wl13ob7Ekmqcdns/OCn/BFU7mLufnfGq4eNNSjv4X8?=
 =?us-ascii?Q?d2GD+rF5srJOkyOCMMD2+3ZVIWR67wYW6fENoTO21/v6f2IvNWrY2mOFCZBE?=
 =?us-ascii?Q?B9GYKovL6W0uLRQEzpitOIaF9trUPS3cfhPhg4n3Ln22YMNrXCfLOEUJKf4S?=
 =?us-ascii?Q?ikmneobHxtk3BMrsN29q4GoVUGsc1HBDFhE1MtJBEflh/9Qe9SpUPGhkPAQJ?=
 =?us-ascii?Q?DjJMLAtVtxwSI77V6zZy5CUJBgwYQ4FglT/+yxGsIU0AubxTWylSK1Yz9oXX?=
 =?us-ascii?Q?wrHdAaHss3+Yy/+dogRe7FLnaaDqLBYDtK7snOx8LueCUf6X9/gzAi3x5zLV?=
 =?us-ascii?Q?hoSimIVXhCitbpQv/aARt6KTi7zEWRXbUBsOpAFruuViz/wFaDDJOHN7vzZm?=
 =?us-ascii?Q?+L3leZCM4wFUZfU5Zs157dLxGwaiax/46D9mpTEF+sj8HBv8brXSN2P0eH4V?=
 =?us-ascii?Q?k76Z40ORggSt9lWZRF1rpHxzW3X8V9Fb1Jb+h0kIsFjPTWXfPJQ8AGsOUuph?=
 =?us-ascii?Q?iz53jLX21XgZWsdl+K4bVyxqjwH2VABWMgjnWr7GwjHue/8ADqbJEgLuPYIt?=
 =?us-ascii?Q?AzGDIcM1F3Vvrt+3M7F4VLuzIR11cNabGg4AW8wU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bdf173f-eaad-45f1-7b39-08dcbc5e36c8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB7767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 12:40:01.3164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l5zteIcgU9VsxWLmimnSTKmZUTU0rrdvGYj+I9ZTkpUDcKiF6l/g3bFiQ76ZngOm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7175

On Fri, Aug 09, 2024 at 12:08:53PM -0400, Peter Xu wrote:
> We need these special bits to be around to enable gup-fast on pfnmaps.

It is not gup-fast you are after but follow_pfn/etc for KVM usage
right?

GUP family of functions should all fail on pfnmaps.

> Mark properly for !devmap case, reflecting that there's no page struct
> backing the entry.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  mm/huge_memory.c | 4 ++++
>  1 file changed, 4 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

