Return-Path: <kvm+bounces-19443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 30E56905238
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1EA11F21C12
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 12:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EB4916F28F;
	Wed, 12 Jun 2024 12:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="otqIlA7n"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2088.outbound.protection.outlook.com [40.107.95.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E3315622F
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 12:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718194638; cv=fail; b=nUL6L7+WpLSKoCEM1bPvm3Mr4XVMvKdf6y+E7FZDmcapH3C1qnyOA+YR+wTh2bqv5k6i9jI0BGav4Ryktd+s/z9JKn11zCWxHxWrc6FvMqKfSCnm0lOhjt7saZxo8FI1qQq+UARJRJyKwVkVHaMDyvAHdQRmVMA50PzChZ28/Kg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718194638; c=relaxed/simple;
	bh=PP4BdrmQT0o8mOalyKiSAO68E3TjzdDpzbXRBnEqVpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QOV1ZZwnIeqv+r2OZ6BZWnzjkFxKsbDzuAFA79NiruwxewjkTSuzWzqtOPvtVNjz+d48zD3JNulNdIm1UY600ZXo1B8qVlB5wDw8kjsMjc6ahk5kNr6I5dVNfyG3yV7kkDsi1LsYWWowo1lFFJIJQTF5KvIMWN0Vnvb5sSBwFjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=otqIlA7n; arc=fail smtp.client-ip=40.107.95.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JiPCjjGpEqpUZwK4JoH3STDR+GXDVxW+q1/JrGKIE35ztgOd/1+D8JYuIMD1t6ZEk837M5rX9MCc0pr7wiMw/mGxV9zx8JkHwkLc0Q6mWhOcG0UCSCyIbMMa3qjJbDy40Z8yJid6FjMsdBHWvcQRGurX9T9sPGiHRQB+/rr1P59R+U9KdvYAIQ0kzIC7s2LfL/Rra3zNMWnHgk+J7ywAS/L6jHaZKoU151qSw+HyRBLJ3DzgCzQPFiIe2Ht7cSlmiyS0lAuQQfSTXbXSsbqoTArHyR9VGLuq06lLMh5snMbm0ZPJsp1g3z7VVgcomjPkimCOh0OqmrP7/nprthIzUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=981AfWL2NyvqDiCTpdr8cfE111sOM8ukulK9aJqzqgI=;
 b=FbJtKvRBE8lkiXEUSAVv+oCw3gWFegVVxqeB9B5wLKmVuOmo6T9E0GdwCcmGivpnUgim6Ks571gFZ3fEIwJ5m4wxVgxC+CVrWRz1wn9w8zEhVvWboaajBWMBVy/XWGyw+sU9gXIf5Qzx9qWUS2txdeseEKA++tAKynYlcUSNDFYvTwZawkl87bhHMhRLR10TN05JLDc9IDjVRCsc6xA2cKsEwCUEq5j/7azi7VG+7g7dU5ciiItpizGQdgmV1ckOqfkhkx6XCqQiCwRjoLO4NPYd+ef9wz8TlMaf+6DmVLbsLF2RLqCz7vnvVuU29lxbi9/KQaI/33CSRM36gYRB7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=981AfWL2NyvqDiCTpdr8cfE111sOM8ukulK9aJqzqgI=;
 b=otqIlA7nZ6+r9MmZqeRheEZWqaQgfmVHdoQ5jSzV6kKI0dNTL1YyU21u44gJxPoI8Bje1CESe+sTEDRf9aBezlUo7RCrInHbbWSfkC5HV+rsSIZCyYtSpJpHmfgqyqCNKUXB8ugrtPDm8fXAZEAwwfsqoihgvLlovFo9qwmBZsfgSaFce5KhfB+YZWOFnN9RWUVmaW5N94aeLQL0H4TUGGTVclRmetXSZtWVKzhc5+BCLvZ0rKz0OV2X6druPIbnemDnkIbXfnnc706bUuFXWz6OfDAyotoZMBB9gV6nmIwG9OnV6/JELrroKe2Eg7/hv9MNFiLrSrIgIivq3WSCtw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM6PR12MB4340.namprd12.prod.outlook.com (2603:10b6:5:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Wed, 12 Jun
 2024 12:17:14 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.036; Wed, 12 Jun 2024
 12:17:14 +0000
Date: Wed, 12 Jun 2024 09:17:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, ajones@ventanamicro.com, yan.y.zhao@intel.com,
	kevin.tian@intel.com, peterx@redhat.com
Subject: Re: [PATCH] vfio/pci: Insert full vma on mmap'd MMIO fault
Message-ID: <20240612121712.GY19897@nvidia.com>
References: <20240607035213.2054226-1-alex.williamson@redhat.com>
 <20240611092333.6bb17d60.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240611092333.6bb17d60.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR05CA0041.namprd05.prod.outlook.com
 (2603:10b6:208:335::24) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM6PR12MB4340:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ca3d600-264a-45d3-d2ec-08dc8ad997c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230032|1800799016|366008|376006;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dhKMOowoprhCfmvZ9mmVU+d4JiwI2PHFWnbtoPvJvf364AJ578dHtCo2K7si?=
 =?us-ascii?Q?03V+3EEu4m2jOZPBI8k4MxMkeSOvVvE31sc3xSVokmtVx+QtrtCELWVs43Vn?=
 =?us-ascii?Q?mPL+RE8Yw4KTCvOiZiol2jREOR/YKBqf5DJYPiqbAI3lRxYG2XjNFsDLxTmh?=
 =?us-ascii?Q?4k21ZOb3r3sp8hPXkvAK6OKg6DDsaAUI4+/zUjBG2AihLx//px9StAN/CyAZ?=
 =?us-ascii?Q?JBMQsFpCLfbavQDuSHz3CdJnXqQBGzjlQyH7n6pASXYlx/E6ub1jXMu8UFe5?=
 =?us-ascii?Q?0JoHQ5B9EVRY78hzGDqxd1nEOADWQQVmrkFxRdgOjZkL06fHzUnJ9Q0vtPQJ?=
 =?us-ascii?Q?UzcBz2ZHNN7uk5+1NsjNVO4YExofstWTwsXLDhtrldyzKF6rAmTdiE4c2gIB?=
 =?us-ascii?Q?b51/W3nlVTG5v956EQF6n83/9+2YPBiqhpDvOWhogpTvWCgxs+aURKPbcn71?=
 =?us-ascii?Q?bBuwTf3FC9diqeKf2oiz6JEAQ0CUMjwIMWqFSz3nYOszQI8kBgSvgQ4NmuHe?=
 =?us-ascii?Q?tihzAyLlxvrWsxaUB4ihDCb116G6VtQav9I4+gTYy9YMGI0YwbfcJjrzJQHk?=
 =?us-ascii?Q?dVj8kYYXZaViwwZaDjBGFBdc2UPcVypi3JSiyVOlztwv1HC2coCbikLcWYxc?=
 =?us-ascii?Q?HLc9al0haqybu4J++anHeC7aCrBuqiUBl0jm6d29cctARt7RElqMGzARfyQr?=
 =?us-ascii?Q?HF0RNGPXj7RWz1qCUfsuwyb7TtvRWQrmPDOkvdCdYcjb5b6J1AxUAbc6wmQ3?=
 =?us-ascii?Q?2ykgWC+wYkD15uBYkHCf1dNKkc3+t04gWezb5h659TgjIJc6SU5HO0sIkT9T?=
 =?us-ascii?Q?6lIiSLxQ/QNthefOseby73hOKu6wehzUEgvaA8oc36cPN8Qi8Je7jvdJ2F08?=
 =?us-ascii?Q?1yzLlmCf9L5IxqasWZpLLEkBDRvsZT8CVcwilot+s/AflZUX2LYsLXynX00J?=
 =?us-ascii?Q?WHPDfUKocn2sAifF9VwHXTBfkVGv0IPxkAs00rKkKSl566Wvtw/RMlwAZYY9?=
 =?us-ascii?Q?hamOIxQiq+dZzXF4c9Uao04gXVdazHKSpMdoLYWZTz7w8I9rY6oeU1+0sgvU?=
 =?us-ascii?Q?R9TQKAWl2zWV5NV6uN7SG8xjTNromQ2YBzKUS13WvsD3G/jySk0nyvJ9ynx5?=
 =?us-ascii?Q?fnfAjaq1+xGlRzaVFum6e9aV/tIhDG9XBpyaEZnB6iuvPnERkfP27BSSZR2C?=
 =?us-ascii?Q?eekyWHnogeDIwjNu26x6J1AiphaBneju2/izuvHBt2TCBCGw5bEMBJMOWMD7?=
 =?us-ascii?Q?aFgsQNHALb1/Lo0W2BkMDdyLnTn7y+pMiOCaYm2WeN4nR/XCNEL5WaSIU6ha?=
 =?us-ascii?Q?0qnh6tkjdzXayzwDVPVFFMRW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(1800799016)(366008)(376006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NMLAQFvQ6xrJvEabe9++KbRDWyoGvI+SwNg3EAFMlW1YyMAyCxMyyugCGC25?=
 =?us-ascii?Q?woC4YWNzai1lQQSplBbK/VXf15JlhEahqyPhUbKPbJrL1go4XsxqP6E/ehWh?=
 =?us-ascii?Q?0sSedVxQfO/bYQJkYuPThHFUOXheFUGQu7ANcwhKvdqtmOMHG9EbKvyhMAal?=
 =?us-ascii?Q?JXHmxyflmRLpfHrpBeziIMLdidlm/5S4ooVAY2X97MKxJOccpO1B6twQiszg?=
 =?us-ascii?Q?btOoA0AuFuVk6oQMjpxiDtZcoS3zJIEdxCPp8cpurVJT9oIGYA12uyHrjcMp?=
 =?us-ascii?Q?2bPg+hwcOIu1P15YypMULb7GMVYW+4MoVPKPakYlZUaXncT7+SzPB4f0hwJC?=
 =?us-ascii?Q?3LgUpkAeizDPrFXdZJ/MP3P9EdcJFhamEvEwWeLOWA9BAfiYKsqquMOprUdU?=
 =?us-ascii?Q?d/3LDlGOdlfZKRor31y2k6Xs7qPs0u6LErLwiuleQWf8l5CbOpbT+3c7Cb37?=
 =?us-ascii?Q?odUFDGk1yz/QTTrm1IimH8BO3ChjwhHipgBblavNf8LV7LlqitNtiNRjUjx0?=
 =?us-ascii?Q?tFlntkqEr20aWMhdySkepIkVl2si/oTmXr6o19ByJgZf6rpgOacbBFbIAxK4?=
 =?us-ascii?Q?RBDuVZ3oNtyA2vlrDE23CJ9+XSJVB5jzeM8BQSGuO5gx3jPyCgwDCqGkMAis?=
 =?us-ascii?Q?Ed6+amJkprwOEhwS3MJ7JKbL9Nrfl392owxSgTykZu5TuaHG7l21MJLG0cPZ?=
 =?us-ascii?Q?E3C6z+JnJfa4RjwKepgPVbZIhdNoRZJsxHY24Ql7YwLvnwjujemcC30rUTWQ?=
 =?us-ascii?Q?Y7sVzHgGFYp9TiOKkPpjSJg37sHQ5F6T/B0BRHM8wdFQZ4dSUXEuW13MQkhF?=
 =?us-ascii?Q?79Y47AmCGuslZyBTgjLfZ9g/GG1dywlx40pxtWwXr7CMwbr33IjjbkjQRMf6?=
 =?us-ascii?Q?wAxHVCKnZchMBv8rHCVVc/inxnWzi8QptTf5Cx1b5TjzWlK2XY6vO7INhNo5?=
 =?us-ascii?Q?SSbvDYY1WMqzv6JD7N4vx/Cy/5PXHCkUQWQi8nhWTobJE5iebHMnw6u7C8Av?=
 =?us-ascii?Q?ANb24KiigxKOb3kSRjVFTSw86or82G83zV2YC+FZx70eWoXtdJjZaEbe4Pw7?=
 =?us-ascii?Q?qe9CSDzrQ4kFySYAG2MLuFoT6J4A/JZx350K7MqxkZcxagSNVncrs236DUko?=
 =?us-ascii?Q?8zmjC3MQpTgVgBg9lpIwBC4fAhHIscMrGvisBNzGatqp138mPqljbcSoAj9v?=
 =?us-ascii?Q?dshNbs82DjlX7jH0K02UdYr3YSomiYtIxGKIlrqq0UhcrqGFpmKniwqkq0x+?=
 =?us-ascii?Q?g+Q/FpD94VrQYbDm8cW7LE6F0NUDymGM5kGTKhwXnF8mU9agE4pd3yh+dsuq?=
 =?us-ascii?Q?96p3bhPWEv/wPgv6cQtQcSH7KSHg+44D64mP3i/+hGafS6TUj+lahoyxTvRJ?=
 =?us-ascii?Q?Zl3a7OeUfBckJ85YK8Pwqn1Tn6YdvtCOmJf1edt2S+iYOJhhVNQlWi97WiFb?=
 =?us-ascii?Q?YLT9ZheZ/u8y+E813klgXTF8qNOFV7hSm5zHqsjoZNz/60matlu6gcWCsiIS?=
 =?us-ascii?Q?9Z+0LF29ncX/evZ2YC3E0t6qN7uPZMAkPvxR+kmaI+UddVVfnXuAolaxIOeB?=
 =?us-ascii?Q?XrHLqjJFTP83WA8O73i27mp00yQgcR0gOyaxxnM1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca3d600-264a-45d3-d2ec-08dc8ad997c2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2024 12:17:13.9267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VhTwaz25sWFwBBgJH5db9t2K53E6BXINv7+ELjt8Fmr6UbxVi9pacwLxbzC7kntl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4340

On Tue, Jun 11, 2024 at 09:23:33AM -0600, Alex Williamson wrote:
> 
> Any support for this or should we just go with the v2 series[1] by
> itself for v6.10?  Thanks,

I didn't think of a reason not to do this, but I don't know the fault
path especially well.

It sure would be nice to fault all the memory in one shot.

Jason

