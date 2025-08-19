Return-Path: <kvm+bounces-55018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C627B2CA8F
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 19:29:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69A375A6918
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA3BA3074BA;
	Tue, 19 Aug 2025 17:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AE4K+FyU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BC93043CD;
	Tue, 19 Aug 2025 17:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755624540; cv=fail; b=ic6NMgi5D320bNBLhJ5MeP4fwbh8z4HE4KAY7WYGvt7yfwfZJoQFWLvBjcVz63AD/sc89ji5zMsWR/r7ov9iRPuk3wLtEP1EjarxuURXUyBiK6ftJavdyEOKhf1ntiWkbQ5TckefwgqiwyUspMDvK/7KhKsejRGJIZU1EFZeisQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755624540; c=relaxed/simple;
	bh=N59FKtpLV+S4AHIZQQIbgGtNX4UQyoxXApKw85OWA7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=s5zpKo0UytdMFAJJn2ZH5ezsYHRy4Z52f6xZoIk7kSwxhbvh+YJBY+m+msBxNpoGmNq4SiPZbUP2MsI1beRmwahlXtMywCkLJf2CRgh6Rp3cvtD4+TRVm6i6mTZN6WYGoqOzR6TP2vb9IRMI/SVDOJNmAUqTiBgfVsAE4xUEVuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AE4K+FyU; arc=fail smtp.client-ip=40.107.244.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x2fX4stiLYy0H5ISQcPN+pa8h+K0uYKRE0Lq5wtHQFW7/cYEiL+l3gcrcM5Yzq2TJ5ZSWF3QINxWXsyhj+Gk3Hrpb9RDZNsBnMVnWznQsHlibTrkX0o3TlSkrDTX+qoIwahAULvwbPcrHB9NPaB6GEg9hM+CpnpWYT18uWZpjqGOwNXCVtmGi2Nb6AeanOvoDJNgtGZZbyirQTxKmgUPMYV8T8M7kRThBggAwd2VjL04YIUNuPkPN9Azk7mQUvnlCF0eG14IrVJ+iBVaYFhSUafy2d3yeL9pQwFRXl/xLHAhpavo/McROtlB21rgNhw8B5etFbqdGpy70kvd/GHnTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PVjjbx96Qy4vZSD+DZtumPtyS5SbeMWaRVzvZ5X/kFY=;
 b=j/qGLbSzt6mioFn8VYgB+SWML5anGHFqY/8tJaiAXaY/6z1BwFskJGqPsYehshU9CwsMVzUb71Iwy/U+w/YWB0VEUrmmmIHS89QlvyYlaHLdFNKECPiRzOZM0ZQtb56ThmIowih4nCitZNQ+Ha0Xf9ZUZ7YNrXeGCZr+bcL2rAYhrdJfKo9frzbUGeznVGgGL5fSv0sOcqcbXyi0mpVgbEbJjSVFZLt81k5PexyX1ypOkQtbkjqRTwJbBA3iH7NiQoxg69p/GmMCTQufE7ATpFW1OQxGjabCZPun886lO8RjwStodAQqB2Us3rdCNOLQq9c1vZJ+d2SQ3iH6uSI6bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PVjjbx96Qy4vZSD+DZtumPtyS5SbeMWaRVzvZ5X/kFY=;
 b=AE4K+FyUHTZYwmd1eNO85j1zwdictkpsavYP/jLZV7b87dgSxivuzqCPGg96Hl0CvYlMAB8s3+WtnvjTpJnchGCIPpdAKbetKuYuvmvO6RQk+ZaUJ9v8P/qfpyitHvk5vgpFuPeqK4cWlCjhk7gTFXKFLOs/qtBSveSYoxtIbk0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB6373.namprd12.prod.outlook.com (2603:10b6:8:a4::7) by
 CH3PR12MB8753.namprd12.prod.outlook.com (2603:10b6:610:178::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Tue, 19 Aug
 2025 17:28:56 +0000
Received: from DM4PR12MB6373.namprd12.prod.outlook.com
 ([fe80::12f7:eff:380b:589f]) by DM4PR12MB6373.namprd12.prod.outlook.com
 ([fe80::12f7:eff:380b:589f%5]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 17:28:56 +0000
Date: Tue, 19 Aug 2025 13:28:46 -0400
From: Yazen Ghannam <yazen.ghannam@amd.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>, pbonzini@redhat.com,
	seanjc@google.com, vannapurve@google.com,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>, linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, kai.huang@intel.com,
	reinette.chatre@intel.com, xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
	ira.weiny@intel.com, isaku.yamahata@intel.com,
	Fan Du <fan.du@intel.com>, yan.y.zhao@intel.com, chao.gao@intel.com
Subject: Re: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
Message-ID: <20250819172846.GA578379@yaz-khff2.amd.com>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
 <20250819162436.137625-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819162436.137625-2-adrian.hunter@intel.com>
X-ClientProxiedBy: BL6PEPF00016413.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:b) To DM4PR12MB6373.namprd12.prod.outlook.com
 (2603:10b6:8:a4::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB6373:EE_|CH3PR12MB8753:EE_
X-MS-Office365-Filtering-Correlation-Id: d5370644-ec21-4ef8-dc96-08dddf45e009
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Xh8Jq130Zl/zkRunNIAd6qnCwb1e58tkER4Yem6/YDaHUZy6ooCjePFKMTRf?=
 =?us-ascii?Q?UNTI8xZYzXML615NP/66WLAKHAwTtRFka68IodCCvAzi4rFyElmYyflkVfO3?=
 =?us-ascii?Q?2xu6siYHQgRUwBAGz3MQezZHCd90LfVzbwfVV1tuFJ3viG1JlBviFwjFZlf4?=
 =?us-ascii?Q?+0EagyQK1+uWZ4Sr88pW61K18VAY9kDsuL89E0j5xwsAozWECHZAA4W9Z+9u?=
 =?us-ascii?Q?kYmkOg10bv9xF70CRVQfMDtATjsQDF1SQ1x5V3B1IYZzmemCTo4+VuHpAoXD?=
 =?us-ascii?Q?FqFuEJEiQx1ye2T1OyCi6NecPbUminKI1yxUSWArQBBowdPsKCW3fT+Cuc58?=
 =?us-ascii?Q?XBLikC+VYSxvSt5RvjJUJIldaFRxBNxnyXqsZgjiZAB5vsl+kXgKWhk+QGqS?=
 =?us-ascii?Q?/zywOld2MrQ4rxn+S219I8+fhkZo7az+uoQlNZ9x1nGVBRF67vZqbxpzkoCI?=
 =?us-ascii?Q?f5Vs/6uovt1Sh4vaIueEgE/9sL8rACHXcWZ57/mahXV3+qUSzd1pyAX6WAsZ?=
 =?us-ascii?Q?yFGeU9SGIasweoInQBh8HFYTJ0IEUGVxkEIVX5UZjREhiNeITZw28HoFA48p?=
 =?us-ascii?Q?ip290nkSgzG05bjbYCoWVmnhqRUJJW0gkIyPoWt7+Rqsye2RVssQqAgTYxEB?=
 =?us-ascii?Q?zEVXbpoIt8rS1+i6NTOy/zUjQH0Uh0uZblzuFJIZ7kqd5WVYTwJLSHinGSMV?=
 =?us-ascii?Q?bD7bU+QJ/UryzHypQqnoRMsDS6Tijj9QOM9YDiRF16gvPbQilEH6mAsLhZ/y?=
 =?us-ascii?Q?aNP/0vTEmiyn0SP40x53PnWJmyVsrsQhrPzAsOtAJ5aSaJMUDs2OHFneqRq9?=
 =?us-ascii?Q?IeaoN5ZBOGyYXZfmlvX5pHohjlJxLOwcoKkNliAwWp7Nth2M1/6+kGuZDEF/?=
 =?us-ascii?Q?BLaWrev9FmZ7Hh9vvla2eSUwwjxPTCiOsMaNcy053FfPP88GOf8lVkr81DDt?=
 =?us-ascii?Q?v7ULJuA3ZDoa8DVWtF1/QcKIKoycbDOdonsMCJ3GrEvw0snbiqiYGFNfx2lW?=
 =?us-ascii?Q?lZVu7zcDMfmePJxpQ4RmONxWp/5GTVHRVKycptlmakh/1+ienA/8KaCe+QGe?=
 =?us-ascii?Q?3funmTZaLJvyAK3KDQKxS7AidvsRvqPrFEsTmDH2CyWYuREIXBxOjBtFIDUy?=
 =?us-ascii?Q?C4bz1X+wRES5EuzKn+aCRFl8UxpUqrgarCdhsOC+i3CRQAj8pSnWDIgyjOBd?=
 =?us-ascii?Q?ENuO/Qqi9OZVa7aD+rNw5TpQpFONEo1JGqFtSHTntiZYZXb4hCLcnAT4tRyx?=
 =?us-ascii?Q?jS5Xo6Iu5u9YqH9xVLhbUtMN9cNTgUh0Q+i2iVDKtWUBxGEmmSst/x9H92U8?=
 =?us-ascii?Q?mm/jdOVW4dElv62SRPoFDqeu79xbshJkXEFEujerHDLcrLElohy96kdD9Dvp?=
 =?us-ascii?Q?oifJ9C4nwwJuk1MaJFT3g4yMaVR2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ukirp6cq24TEzZclHri8NaNhHhD6CdpDHC9gbIKaNcIsF4ikbgFFyum/HSJi?=
 =?us-ascii?Q?xUWCuKhkPknFH0i0RtYDWXXTVBO0rZrphbXoEwmifZ0BmBHCqfrJc2/vkFGl?=
 =?us-ascii?Q?RHl6KKXueWNrVj2WmLuMFzbIErPdX0+45JEotLwXMMnThkgy671E+rmRD6Rz?=
 =?us-ascii?Q?eAyfJZWEE/Vat2Bl2vWJcSeJSinwfuRGp0SuDarUPPONqk0M0VSdh6FETzuO?=
 =?us-ascii?Q?enAGWDgpdQGJehkYqOl9EBj/zyxKMLmKunum7YQAkO3cVSWCEBqZra+LgTf3?=
 =?us-ascii?Q?r2JhbtHL3LZsrwQ194i6tyVDXJWK1xmXpyaskjD58LBXGbmjN7UIKZzSIncR?=
 =?us-ascii?Q?VN7mvOZE+TQw4pI/dnZ3rH48rFzx6Z4hQA6hfcBJkHnnb9hm8sIKQ2Q6VHL0?=
 =?us-ascii?Q?uZi16XPRxBfLc28Kqhhh6aRIMIih8NO4WfnCD12f15JOAsbwg2cHu0gxJOae?=
 =?us-ascii?Q?G5O02ZzIl5ucqkOC2TJ/sto0qZX1yLDgMwoYv90EMQ1vqvQQFmaX4iGM/YPG?=
 =?us-ascii?Q?GWTnD2ijpC78X5gWhoGXRwJCIYnMG4UWAv1c5eOkXHSsY+xsKIDB9ZQ9fXdn?=
 =?us-ascii?Q?IxwXVGtz7+rIn+OoTzrszNI4Hef78iG7OO4p1q7S4D10XMPB7hgVSDpCDN/U?=
 =?us-ascii?Q?t3WrptO5RUabCGxFoAieJFd4Ytkst2uXylXdLjK8i+ZTequuxhPwQ2vqOrhg?=
 =?us-ascii?Q?EzGT2EAS23gYzbUerSE/KOliGyxLY6cKI37PCW97tJ0lac3claqYv65EPUfj?=
 =?us-ascii?Q?+2NSqErKluqWdCO2Qctp/oaSkWu6s6vDKGZShg+eBvPfir0YSwFvmtVNe7w+?=
 =?us-ascii?Q?hJhanovM7eEYxwkEmu/5s542Z3HEE1ywxH5LjP4xaU7wQ5w/Lf93ltHyRgXg?=
 =?us-ascii?Q?I72Shgu47zrUlziM8IhERHzs28Wih7y4gxEHkYsNVaTRjInWKZawuTFPUk+M?=
 =?us-ascii?Q?YnEiwv34M4Qkp5uI8yR0+frPxNQKlFosFvLcxYDgKYtvihmuZCs/G/AUw7Be?=
 =?us-ascii?Q?X+oGTIfvfzG5NyDwMExEOSMuZ/eXGKRgQxVfJFG8M6vKyNVCQBV+N299GSJg?=
 =?us-ascii?Q?pp0ACvpD1nm+NtYgWaJ7qBuhN4xqJ+qY2Hb5GdNwX02qE/sBoUSzpWIXvNJU?=
 =?us-ascii?Q?FY61fIVdJRM+FywvWecUAtGU6oIM5B/MjeTENjzdSHAQveQgGMcejb1V7khH?=
 =?us-ascii?Q?65b4wz42HYBKW1D3/RKAV4zvHHoTKJ157R9FAQAatY7VJQHcFAa5z+oZCpL3?=
 =?us-ascii?Q?0R1k7x7ubPK5eR1YfQHDPsj7QgWDCymT7jXFkOEMi8eDnOHazITpncKTgxM5?=
 =?us-ascii?Q?VeVDU18qSZfIzTKJscCYHQalKl7uhjttUvTACdFqUMJ7DrSbaGITND9NOTFM?=
 =?us-ascii?Q?PnchcN70iKRvT50hDbH6BQaYUt2YH/REq/aKfbEeBMX6Uh59mVIAL//L/eEf?=
 =?us-ascii?Q?DHwP2QYojSz4IZ4qcexNI7Cdemyk21AsYVFDZzZGzCYWYHLhIGObBFYjUeZo?=
 =?us-ascii?Q?k2bXj/wy+b02CM7LQ3DVM2Bor6nI5wspHQOaFu6HOzJqBNzSJBlTsk1H1skd?=
 =?us-ascii?Q?2/vUnG7MY2N1l1az/lBP7qmhD6ERzYMBWFz+H38m?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5370644-ec21-4ef8-dc96-08dddf45e009
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB6373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 17:28:56.2373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0zN3e+5eEUKxd/hAwnKhm5DjTHBr303Yy8pxw+hXI81dq/lzw1MUkhLWqd4WPavnQo1VHyxE/gkdWUlLaaDBVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8753

On Tue, Aug 19, 2025 at 07:24:34PM +0300, Adrian Hunter wrote:
> Commit 8a01ec97dc066 ("x86/mce: Mask out non-address bits from machine
> check bank") introduced a new #define MCI_ADDR_PHYSADDR for the mask of
> valid physical address bits within the machine check bank address register.
> 
> This is particularly needed in the case of errors in TDX/SEAM non-root mode
> because the reported address contains the TDX KeyID.  Refer to TDX and
> TME-MK documentation for more information about KeyIDs.
> 
> Commit 7911f145de5fe ("x86/mce: Implement recovery for errors in TDX/SEAM
> non-root mode") uses the address to mark the affected page as poisoned, but
> omits to use the aforementioned mask.
> 
> Investigation of user space expectations has concluded it would be more
> correct for the address to contain only address bits in the first place.
> Refer https://lore.kernel.org/r/807ff02d-7af0-419d-8d14-a4d6c5d5420d@intel.com
> 
> Mask the address when it is read from the machine check bank address
> register.  Do not use MCI_ADDR_PHYSADDR because that will be removed in a
> later patch.
> 
> It is assumed __log_error() in arch/x86/kernel/cpu/mce/amd.c does not need
> similar treatment.
> 
> Amend struct mce addr member description slightly to reflect that it is
> not, and never has been, an exact copy of the bank's MCi_ADDR MSR.
> 

I think it would be more accurate to say that the MCi_ADDR MSR is not,
and never has been, guaranteed to be a system physical address.

We could introduce a new field that represents the system physical
address, if one exists for the error type. This way we can operate on a
value without assumption or additional checks. And we can keep the raw
MCi_ADDR MSR value in case it is of value to debug folks or hardware
designers. In my experience, they seem to appreciate having the full,
unfiltered data. We don't give them that today, but we can work towards
that goal.

I have some old work in this area:
https://github.com/AMDESE/linux/commit/76732c67cbf96c14f55ed1061804db9ff1505ea3

This isn't a quick fix, so maybe we can come back to it if folks are
happy with your current solution.

But I do think there's value in sharing the data as given to us by
hardware. And providing new interfaces to users if we need to modify
something for them to take action.

Thanks,
Yazen

