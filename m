Return-Path: <kvm+bounces-30077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59EB09B6C54
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:53:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23E17282875
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 18:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5B831CDFB4;
	Wed, 30 Oct 2024 18:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="km+izFB9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2080.outbound.protection.outlook.com [40.107.102.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A703A1BD9F1
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 18:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314424; cv=fail; b=MICyzFcm49r9d33UbBcN1hdO0qihrMrQiH6w81+SfgVcJOFURi+gQx28pvPfo33O2e1IodR+Pgeqo96MaN3yWHcf10j7+JydnZng1kAsTECqcQ2Dj1eeLlGfxKsE8PD8AGRPs+/1LqLaCMvKRunCohqY5EDZ7scc6xPmcSwY9jQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314424; c=relaxed/simple;
	bh=9w3ZhVtRX8xu6UBVCUZdZscYBqP6NABa/50JJjzJfik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WmdQw0b/8tM9fMJr1UsoEKa6PiZF8vGoXWgjsXUIqu057CVaB9wDvVoe7WX/FfoMcc1DI9r0SNYYB4xTK4wKqJQanlDqFLr/AXhXjtnkQ+SOjtMgH/D7TCxzuV3AJda1N1nyPurGizYNAXPc3L/1A3PCoaHcXhon6C4AL3iePSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=km+izFB9; arc=fail smtp.client-ip=40.107.102.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yXKXzr4yTFBwNQBp1i9ZLtagiimI1wzmx32uWawUhEb71z+Tktwd25cUXARbHNuHsn0z13yKls5cUqc2aITYJx2h/+g3pzp/+55dAAfWKR9onuQt8poJMgRyzVbfnDBNN6ITfwX8x1SHEm/XgCtu1rHjGTFSCa9dMEU4H6hkQkeuD93Pzg28cn/PtbCZ5g0OskefNw69bUZ7i05wCQoaunFbByRRcaQPYFM9FngoaW0nTf/x9WwXp7G1bZiY6VsIlidZAoA7p5lFxdtktR+ewmQ/eohMwMRgQPRfHGTHSQvD/DJE70CcEmFezToHLzHHQHu3x1V7CfDv0617cY/Jzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1GiqJ3eoo1I/nerVik9cXXidtMQ6sXRof/TkWZWyXVs=;
 b=L0jqPvyZV3IS7NCI0BHXuL47kMdTYU1iDfqcZ0HYwvgZJdrktYk8uzujPO4hXwxR6UHXqP0IgRMfEEdFNi6Eq8tK2SpGn5Y2RaLyTGdUy2bJ0gJR0yt7ktHg5yuKhaRrKi7Mxq6lHLZj/oF+0YJnpxYM2rWFrebMFaoXbLDLTg2TLzWs4DwtmzwlhUUm2tT0Pi4JV28Svwtf+mYwiBAEEybqfHJV0cNDdDfcWgSePgZLAT32116zlvZrIVhFvrB6byccbN0nGvnrbRrjPII/b52VQi71mjClT28RVj/D7V/SELw4HlC7oRWITe6nB0cuNmSHtxZNAvyTaBtJyVCD3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1GiqJ3eoo1I/nerVik9cXXidtMQ6sXRof/TkWZWyXVs=;
 b=km+izFB9Y/i34Muahb4UJr363aVNpwACaI+LVawX2uI53weNUkEsuG+Tiqidty4s+DQjN7QBlkrDtj2I076Rg2XuY+Hru+lQD937A9ZoXTiqGDd1WdRpAFkuA4zdwb/pGZhUiC9c3PiHc/vI//u/bzN1u95nnMnpMfJRGwp/sMY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by MW4PR12MB6899.namprd12.prod.outlook.com (2603:10b6:303:208::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23; Wed, 30 Oct
 2024 18:53:39 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92%5]) with mapi id 15.20.8093.021; Wed, 30 Oct 2024
 18:53:39 +0000
Date: Wed, 30 Oct 2024 13:53:35 -0500
From: John Allen <john.allen@amd.com>
To: Zhao Liu <zhao1.liu@intel.com>, pbonzini@redhat.com
Cc: Babu Moger <babu.moger@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/7] target/i386: Add RAS feature bits on EPYC CPU
 models
Message-ID: <ZyKAr/KTkX7vgh16@AUSJOHALLEN.amd.com>
References: <cover.1729807947.git.babu.moger@amd.com>
 <63d01f172cabd5a7741434fb923ed7e1447776ee.1729807947.git.babu.moger@amd.com>
 <Zx82ReAE9h7bLSNN@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zx82ReAE9h7bLSNN@intel.com>
X-ClientProxiedBy: SJ0PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::19) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|MW4PR12MB6899:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cf6d3e5-4b61-45ec-4828-08dcf9142ae4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yNf0CXLzL0FZW9AUDiaGKu8oidW5cgyK65Fd1U0UQmcS/pVMeiWcqvS5gEo1?=
 =?us-ascii?Q?tKNNomWP+gXvZbfPEI6C8pGiHk/VfVHeFHOwDKOmExvut7HIaHcH2tfKq6H8?=
 =?us-ascii?Q?yKu1I7/5CQDl4FpRYshW0CI4/4jMfiBm7sKGv94CIyyjlMvg23SrQjqj9UvF?=
 =?us-ascii?Q?tJHFBCWG5fgZik/791EScGdbuCmllsWip9O1IRldzEx178hnZP6oIJD9XeNT?=
 =?us-ascii?Q?SGBplAxTjxszHbS1IJ2c1Sbinlylez3WnR9iFi4m2EYa1Z2JdljbgddwJFDJ?=
 =?us-ascii?Q?0UswKbur14tVmjx3N5E9xSKqkv71PoXQfvgByMcPtPRYdL8aacK+xBm2sOMl?=
 =?us-ascii?Q?7TpXfuvByJw0dOXVP+RLD8KpZQS+oAXY+iopO9a5LyaCHzizZ2MjwhvE74x9?=
 =?us-ascii?Q?QRloybFiyvd/3shJId7UeaX6cp0gFDeiP8x0FCAjS1UgkWwhKgm9XxnrwEfH?=
 =?us-ascii?Q?lmYXhv1GFGTR45amSjnYtxvc5E/VRSTdkyzZF5KCh4G9xbhJhoCQNm5z5F7A?=
 =?us-ascii?Q?W6vQdLnS0d1itSa+4vGhorBfrn8ARvHFVfNI9KXMBUEhbSgDjhWD1Ee25wBu?=
 =?us-ascii?Q?ZJ9ioYRbXSVGmQmQTPKNHYVYw7muS7CqMi0qSRj77GCW1X+MB7eBjmfFvSAJ?=
 =?us-ascii?Q?Q97/ZVsL6JhwHyGtGg3F7PPe/2l+ON4f5CZgUm9y2bMMH6C9B7xmVA99nn+T?=
 =?us-ascii?Q?X5vm6GDnqH5EjJHaoBz0Ls+ioxhGN8Cig8irk54KrQufWvqV0Cs8q6nPBB50?=
 =?us-ascii?Q?+TcC9KzA5oJU+EXWQZZltuvFSQG7S/H5ovM2asqllXxMbiC4gyNxqOmK/mKQ?=
 =?us-ascii?Q?ptWxfchr+qWWeN3XUUPO6xhgXJyQFxIcDNepQ5vs2W/9aIdb7fD3uGa0BtPB?=
 =?us-ascii?Q?QZHRayLgVin7bF4XZjiyeQQbr8rEn73oOAKd/UrbIxG8nmMW8FAp8w4JxhJx?=
 =?us-ascii?Q?WAjIxafhy77/VMdutsiVCs1r2dTKtlmYR2n3LRUW+hRPotlHchxcbEFhzRRQ?=
 =?us-ascii?Q?4L9wjKQUaiW+1JlzjapuSz8C2IYQUs70BYmWSgkKyjaNQrYXKTUwSU/jz9A0?=
 =?us-ascii?Q?Z/L7Pe4txW5t+J44UEn+tncJvM2595jcuqtaklRnpJRxAZ17pdPgGyZ3hHOA?=
 =?us-ascii?Q?vvqBVW4mDR/RWRrWP9i7l8CZjS0c7n2zEsW3fWpwuv/JmfpXWa0CLZaWYnFH?=
 =?us-ascii?Q?WvQBT2urZZsT3TeC/wYYhbIB9//UJ9JpXelk7EXR4fLMBU+vhofkyXll2oAS?=
 =?us-ascii?Q?gFlZqCq59TWTZkL68pQXGdOFVI0o85kICBGCZ8wunMFHcf9S7kDZQy8iauts?=
 =?us-ascii?Q?8CnVMC7h9M2b/dojEZ7eDEml?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PfF5HVVudwzAnjYjMEaM9AmpVNQ1BA99i6xSYN+1xNTHUcO0VRWsblcNbuKT?=
 =?us-ascii?Q?ELFPtJ7MPVK7Gv3WBLkJo6e7lcA5D0ag6H4yibLDALrFWZHQ27PCsLuR4ifP?=
 =?us-ascii?Q?L3MFVjRgwkbnoo08THx4pooafCqgbRnJqjhhSKUinFsMUY0Qp3KUGxk5cYsn?=
 =?us-ascii?Q?bwcgr12PnLKh4UASlyUhxDK9+Z5IovJoTBXQALwORU3zXFERoQWv04Gq3a68?=
 =?us-ascii?Q?uZBuklGEukPjMO3EqQryQ0wfmuZw+8Ekll2bOh1QqaAGCv93bYptBxsHdKA4?=
 =?us-ascii?Q?rdNeb8is54imbek/Dqvns8SVtcGsp3LBqBtDOkoRhyTrVgkwAwXSLZzrD1bf?=
 =?us-ascii?Q?BpCcIy78bDqRUeD/tczkdqq158X4uaiPIabU8nN1/fyL8TvzwMpuQYSnt7D4?=
 =?us-ascii?Q?bcveOnm0nv6MlBwQwE9YjBgk06gJMRN7NbHoM2h3XlkmM5XaIMftOrwjsA8W?=
 =?us-ascii?Q?1UATC2wwTR1diNwBLQOCB9b13aaQcFeCJEpkp/gkxjX//yNeKo/mhc3uvWoj?=
 =?us-ascii?Q?PvdXhhViWVcBM0Hvj/kxzpPE4TTG0lTy0tE9ouAdczsX3I9e8gDDoHX/qUfw?=
 =?us-ascii?Q?McEHFyBer3vTxv/zHZxfpPQEw8jVaXSk5Qbt3zHIJFNT094GtRo3U8eV33/q?=
 =?us-ascii?Q?48KLmMvrqtlLark5ArCW+7xyC8khpvdehlEUDNTL8FZPJ4iwqh/eyNv4K65R?=
 =?us-ascii?Q?E/AgTwYpzv/EceoJVxh8+cCpAjs2eAzMQIFKsGzk+rzsYxTRPfqRdaQQVtyp?=
 =?us-ascii?Q?jPYRZYbLudVqHFVyYuUjzl1eF+0Cj07ylt8KIJyvzoUaqlYb9GCalsH+V9ao?=
 =?us-ascii?Q?y68vSFQAa8psJ/F+jXJSb8mDOzQuIAKwyR3CpK1efSw7Kg0t5DfUtEWs/MiK?=
 =?us-ascii?Q?JsEhqSc1gG1UuxkgfIWq4sizUZxEDPB0CF9Jo8WnUwW9bnK6mzFR0eus0k2Z?=
 =?us-ascii?Q?wO9ox63Pq56i3GuK5/wWDBYWEWpjQKx3TPyu0hHzwn9e2717d8GpCmB5P3VC?=
 =?us-ascii?Q?2fOeZpYLHI3g9OEwMUVhTp+0jGBywweTrPO/xRUHQfsa7rXbkXDANELf++2I?=
 =?us-ascii?Q?aoOB6JF08puHI7NhUfeo5LXHZ2E+CvyAfWo5WA9mT2SIsI5Mei/77xmg1ahw?=
 =?us-ascii?Q?JAQE82c8pZ9ARu7DtP8U0aTgoWTIz82zZb4NgaqJO6t67JkHwmepKZgik57o?=
 =?us-ascii?Q?Io7/24sMhvXHRYmjW6kPnRVzD0ZajAG5lg+aLHOpdWuFLlZGWP2U5i8rAy6H?=
 =?us-ascii?Q?jkSsKg306E616MGvLvEsv8EX1o2+S/2S4kGv6D6dKtsCi6Ye7D2a18ecz6d0?=
 =?us-ascii?Q?DifpAdpD35lWg7X1WCss74cKViPN1sg37IHnOOTKIOP7lEStvdmnHGK/dK23?=
 =?us-ascii?Q?kMtYKb7yf8oikVl1tfpo6tUSlakhkws1IKjVlMYfwk51A/Uzygc9vuWwhs6m?=
 =?us-ascii?Q?8IZtEaURG2uMPB/sOi6y0UM4ZOgKexwFJNbzm4C+7j0bHq+3eYjMfVhV69IG?=
 =?us-ascii?Q?t6HLgzYis/C6hfOYfZyGez6G/733LjE46/whkR8CfsmpVEHkXp3SB/Am0z3G?=
 =?us-ascii?Q?vi1nUB/bwLmgLR6AlQP/1YqGmTYWYNxrkGSi0ZaS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cf6d3e5-4b61-45ec-4828-08dcf9142ae4
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 18:53:39.5813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B63aqgOWbzLTT6PMjn27hFpQOa+R4SXreWFWi6chY878fybYixg8rEMB3Z2AHExrNENtPR8VToMdhbk4iEdCYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6899

On Mon, Oct 28, 2024 at 02:59:17PM +0800, Zhao Liu wrote:
> (+John)
> 
> Hi Babu,
> 
> This patch is fine for me.
> 
> However, users recently reported an issue with SUCCOR support on AMD
> hosts: https://gitlab.com/qemu-project/qemu/-/issues/2571.
> 
> Could you please double check and clarify that issue on AMD host?

Thanks for the heads up. I can reproduce this on an AMD host with
kvm.ignore_msrs=1. It seems like kvm will need to block this feature on
the guest when ignore_msrs is set, but it's not clear to me how that
should be done yet.

Paolo,

Do you have any ideas about how we should handle this situation?

Thanks,
John

> 
> Thanks,
> Zhao
> 
> On Thu, Oct 24, 2024 at 05:18:20PM -0500, Babu Moger wrote:
> > Date: Thu, 24 Oct 2024 17:18:20 -0500
> > From: Babu Moger <babu.moger@amd.com>
> > Subject: [PATCH v3 2/7] target/i386: Add RAS feature bits on EPYC CPU models
> > X-Mailer: git-send-email 2.34.1
> > 
> > Add the support for following RAS features bits on AMD guests.
> > 
> > SUCCOR: Software uncorrectable error containment and recovery capability.
> > 	The processor supports software containment of uncorrectable errors
> > 	through context synchronizing data poisoning and deferred error
> > 	interrupts.
> > 
> > McaOverflowRecov: MCA overflow recovery support.
> > 
> > Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > ---
> > v3: No changes
> > 
> > v2: Added reviewed by from Zhao.
> > ---
> >  target/i386/cpu.c | 30 ++++++++++++++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> 

