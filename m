Return-Path: <kvm+bounces-17650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F4918C8A9D
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7367EB21E1E
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F25E13DBB7;
	Fri, 17 May 2024 17:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cCDyj9wr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D40213DB8D;
	Fri, 17 May 2024 17:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715965883; cv=fail; b=IL1vP4SIuh+kyxt3/UKSOMoU9Bvtqwto1/n41QBIszYwlSq9s67174Kx9fCeGcVEioNj/K2vXrA6sQQm0qxfl+wk3nr8pqr59zd7JeWwA5GWfZTFPtCKHAIZvGaibM+EwH2KLNBc5UU+dcoEHB5Eem9FTLTXwGB+XJEwZZIHd6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715965883; c=relaxed/simple;
	bh=t3yltwot5f7S3vVHDCLiyuB5vTAChN7G5HFGd0k7dq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iovYeOpBcwPO0HXG6Utcii22nYSPtt80WopivWI+1hjblUbylZJLnLgrKPa+E+tX2dE484kvpjLwVkM3z6ZfoN0SsQ2gdA1MB1W8gzxp4ex9mEH/AOz11pOtM9dCuk5a6x4sdtc4sDxLrlHGD26tr1lf0j3tmQJQUvCiOHblPMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cCDyj9wr; arc=fail smtp.client-ip=40.107.92.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcdHZWrMnYaL7x8qiU+LbrjyFQOBvAz9VAUidd9OKac/8dIiQMja6iJaiSbaWnjo0D7L8Og5tVYZGbobr4gNje5lKxIusSWpQj0cRbOsS2ThPD28g8tMx1q2Roi5NLTpbb8zZxipM4kBTqbjbmMJ2FBQe2lrGcs396+GshG0ptBmJbFCdfsL4sYlN5QxlS0A6KkMs0jT8gA7WGymbmLAP+2bHa8nstYCvostUHlhYPbC8FHS9tBfMEppcTdXE8LJUNYLDMCYQ76PzykLxUFHFp4KjCMDhBgYYD1ADdKO3Awu2tXNqt1cfX7MmpZmVWQFPyePsS2KUwZU7eerQhtnhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWY8js2yIbn1iXvqxLsnyqtuD6Dr+kAnmuS9Cg0MsUQ=;
 b=d4MedcMXBeE6WnpYElyFbxvvhwbrsVvA8vuZcMlq7aqDDgpPqtozL/8KrwK2/A74uj2ayT7vHDEzWtU+H/EwoulQvkgVSPlioG9oSCpfm9GBGozwqP/6pwXhHYHUe7ajmorp6DiY+xOuzlj5K8e8QBATrQyD7gjwvVwF1kZ2sSuAjrlSd2QiwOpBIGfIEU95mAI7pB+aeGwhBF7YTd6N3CAbPFOH8wH6nWxzLEJyDd+0THCYKSBAYooqMTpeQry5vyce+TmpAhHs7BPi25bjmLcBDm6SPOEQKbNLPRhjeb4aHdWk84AJLmpK2x7vW5jxlctK5EZZTY5aCxjfuQVhGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWY8js2yIbn1iXvqxLsnyqtuD6Dr+kAnmuS9Cg0MsUQ=;
 b=cCDyj9wrPyca7fYNk/vppZnvY+Vw+jnoAgMHum3PNI1BkDg3DcISg+J0Yj7sw4FUCMM5M2PwB/HhbVPFHxJ0g6UnfDSJZPtmewafhELRMsmtIB/S+fIrXxS+w4WvP8CDtRogkByd2GUFAVwE5W759CrRPC+SMvi9ru5Uapyz4YPTVnEDZveY4zlkK1VOG/Bx/m5sS4p+OeDGH+9t6G5txVY0W6WmwlPAHG+uO3W52o5JyKd7qq9fixl6ic6ONU1oxlwFuVp+8S0dr5puqGtjvFXPw1+PCvY6CnsK4t4yfJZBLsvuQOF8hlf84U6FX1zPx0RkWrJLuGwhxuEZjzVDMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA0PR12MB8424.namprd12.prod.outlook.com (2603:10b6:208:40c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Fri, 17 May
 2024 17:11:18 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 17:11:18 +0000
Date: Fri, 17 May 2024 14:11:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240517171117.GB20229@nvidia.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062138.20465-1-yan.y.zhao@intel.com>
 <20240509121049.58238a6f.alex.williamson@redhat.com>
 <Zj33cUe7HYOIfj5N@yzhao56-desk.sh.intel.com>
 <20240510105728.76d97bbb.alex.williamson@redhat.com>
 <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
 <BN9PR11MB52766D78684F6206121590B98CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240516143159.0416d6c7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240516143159.0416d6c7.alex.williamson@redhat.com>
X-ClientProxiedBy: YTBP288CA0023.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::36) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA0PR12MB8424:EE_
X-MS-Office365-Filtering-Correlation-Id: 863b1499-7d6f-46f8-838a-08dc76945e20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3dglY4jDWOeJ5qTYFopGB9i/Jytlw32d9TM8rOh70eeCKl95hQZ68PbOEcTu?=
 =?us-ascii?Q?2XnC7CHDtthRrlL2ka0yNYQOjQx/631yZp2S0j848FaJyE6CTlnlQJEQwWhO?=
 =?us-ascii?Q?cvb/o6XDdSP/Zq//OT6zk0M90yVB5uUfb8kkGGksfqEW3xg45jQ8kRW3jCaj?=
 =?us-ascii?Q?s77pj02/HdLYXNB9ZNAZSVtcwWtN3X9We33yo3f8e4PDepwX+sTb4W1OIvjs?=
 =?us-ascii?Q?ri/VAiBP9PIS77aY+sBH/CcCy1G1CRCLLNW7Bc4k7WNyf2ircekaI6GTAHZ4?=
 =?us-ascii?Q?2PEugZd9zugVL3g88jxsclW+80VuBoENPLNlxbX1hmvHDjEoOaR4o1cyool/?=
 =?us-ascii?Q?nbm9BJuKZsDdJcasyw4+Lb+xll6+onrcqobaP/+CKd922FpEjWqqo4zDTNZx?=
 =?us-ascii?Q?XtGRicj72a37sP57vXR3Ae3eQdRTvGWr+lfE+ZWKbJoi/pQeEZeBhgdSIb1P?=
 =?us-ascii?Q?yfaP0NcJ3RckL4hiYHUHjuEWc0gamogun7FywFmq4Nia2ZLEhvZw0sBoyb/l?=
 =?us-ascii?Q?T7L3xk7jeOq17qrRPCj8yNXWLtlJ2r08VU2OwHoO7ArEFNSfM0d1amC7i0lz?=
 =?us-ascii?Q?0kWmVbEqxGW6m8gRyOQfc+HK4gqewZ+Be7QpjoZDhLRhy+eULycewszobCdq?=
 =?us-ascii?Q?o5iaW12t4wdQw+oTWSRG8xtO/r4X/ngi5C6Q+5UXpDDZ+VJyO8jLDJKCvSB9?=
 =?us-ascii?Q?t77TQLe3NBCRaiAqLFIQ47sFdpWfOIVteAEOntl1CtK0O6zBjYPK+40Az6SX?=
 =?us-ascii?Q?OX+dAjjo1Mcw8FIC4nSatqCwBF/fJjRcMM/8Ho3Y1Jr/rA47NGI+jojHrlv0?=
 =?us-ascii?Q?eu1Nabs3fox094d3MlpMB75UEJkm9Op/92TNcaATLLeevKc0SEOPkL+/gnJH?=
 =?us-ascii?Q?t7cX+5KifGVsVkVkcrA4e3a7d3w/BIkTbe0a68GEyvctwLG1TMKX8vEEUNd/?=
 =?us-ascii?Q?uIyaK4HplbeiwjSw0vaqYzqz+1q3h+VyGddEWU8keW0GwAA4CtwLCFyIbc9T?=
 =?us-ascii?Q?HIwK+pdPjwZu1HMO6aAeup2qVJdb4ceWMhKUWbqjQV9Zb1uYRKCv0FyIaG45?=
 =?us-ascii?Q?vncqIgzFeO5GE4+z2pmrLi27XXEWibcW41+jJKduWnRkE4vHJFo3lc+5fo62?=
 =?us-ascii?Q?HBt/tyxKpN9KjJglPqD43mnYxzQlIGi3dehH5PbvIXUKzpnnxfiDdGYSgcW1?=
 =?us-ascii?Q?rzoHQ8BwJNctAZNpSoL0vM4e9fBP5lA0Q8FVBqmuwddSmkEVg8p7F1Ga1jNK?=
 =?us-ascii?Q?fQ0t2ds6K8Gxbh2U8ROwNyV/WL74e4dNqkv3XR0SJg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FZPxmdGBnD+wr/rxlKDhT+/qA3jBhgTQr0q+msHYzD2tjcymw9MG/oN0O9NM?=
 =?us-ascii?Q?zVJL4C/kKjQeOiMdt/tjKGp8mP1cVa4hm0kgKR32YA1sSkBylHwi0trxNZf4?=
 =?us-ascii?Q?qu9SOTJjvzpZsq6/XbpIkwxPGucTYYenukC+69XEFOm3u+Lwwd0nXOR/k+J0?=
 =?us-ascii?Q?twt5VvA3pPlrJpqXwQtA1ELUEXRu8TfYfN+Rvs2jUbhwsxvlFEyueeI1fo1F?=
 =?us-ascii?Q?Yc9Oeso/IrvO8oXcICTrYB7bMLHV8Cnm9Tb6j691WSr7TbZBbSe6J7pIR0Wc?=
 =?us-ascii?Q?wOkK4eGAwPZygzC9ajZMrvcITKZeyuRkZ//qpJuofnhpNfuVpQ37Y1j4uP6z?=
 =?us-ascii?Q?E3DEgaQ8kCTwu0VVVSHziQSQWDAAJKZhjnxqrcLYbZhu2uYhxoRa47a6tscQ?=
 =?us-ascii?Q?fPV9xRifDgj16i0LK/zB91i+ixcoRdCHOgudeVlTRa2w2swunb/DrUDTSSU+?=
 =?us-ascii?Q?P7CBJS0AOtI3lWWPbwmv39V+OS1Ij86PTq6fMB694VTFSg6VupVFujrJ/pkG?=
 =?us-ascii?Q?Hm+bsc4d9KWXHjeV9fZ2YiABUbAT+PY9MmZk0yKycvmO2lbdNave1sJMP6tO?=
 =?us-ascii?Q?HDBldSZ5P+o+5iHtGNxqwC9WlErAzuS/eehqyaRAPL37bmcny7ZiBSZSEJT6?=
 =?us-ascii?Q?cD9Cifmh+dkpOxXJhAPzbfKkUM1eHmQ1GfwkgHw/e3+jiOwk0i7CyKUJl//C?=
 =?us-ascii?Q?y6eZOoKTR30i9KcNolUAY01PhNO2HYjHtG0wpFCh/0ZG4gj5jAbpjVjTk/jw?=
 =?us-ascii?Q?QgnflLrTXy3y9cfuzuvGBHItodmY8gfUtQlWfsvQF5A1N0r1zrWVZ7z1vinV?=
 =?us-ascii?Q?g8KguhxFMtJgCeYo8yZLuvRf8Pf7lofHey8rL8A+XyDC7z/wCZrXnB9ZOfsz?=
 =?us-ascii?Q?mxZJE4PlSnosxuw8PuQwqPYwjMa2Woelc4ZJwDDgeM6lkYZktdM9GhLnLJFK?=
 =?us-ascii?Q?u14KvSUuXArYUx5V9H0pL3kX8lIkR4AAPRnGFduhXZgtx2G76hZyPpFUOQPa?=
 =?us-ascii?Q?PABPYETRTI7trzcpnC9Yc3Wl/k6+YeAxK1mbo7k8DxS8szoNyOZhMNccA3oU?=
 =?us-ascii?Q?4j8ZdvjVtx8TDlz6fIwk6FcYYRR4xFqQhP7X6vTaLZLn7cMDu9DqnUP6t58A?=
 =?us-ascii?Q?mWsmD090NZPj7E7ZIsCPVASP6adv2iPIueQQntMOAFxWsDDY/sfkSwFLI0YV?=
 =?us-ascii?Q?qJNw4oFf+d86kOXCIWlY89YgcBB3IUXhj30iPN9BT+NMWguEqefM/xE3LwwA?=
 =?us-ascii?Q?V5qHDQIozNtHLHs0hAkiP5UZj5nr3lt4PP5l3KBgh7kzHovykV4MM1eHZU31?=
 =?us-ascii?Q?HNY8HEwUg7gwfJL05igD/leNLmPqYaUWpWFXm87+YqK6pzWQ9Z7Xm1f+O2DG?=
 =?us-ascii?Q?judHUnK0e+3e2gT8WFzetCBqSRzEvGUQYUI9FdpCbc70wtqJrGWlWxTm9d1F?=
 =?us-ascii?Q?K2e1drNrgdZ0Vr3KFMbHo3J8mxtpkDjV5on1dxuj3HO6rb7cKuHIT001f2/3?=
 =?us-ascii?Q?6TggP3t3rQS6T6cp1iD1GcUYCFKHHPWOskvSzzdyddDzxzYf4eCf4a2eqZtA?=
 =?us-ascii?Q?S9zTWlOCVoWrXdqO+WdKT5r6YrJz1UYggJH2qip0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 863b1499-7d6f-46f8-838a-08dc76945e20
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 17:11:18.7359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dFIQsdTditoQIL8aaC1gSOsefQFSg9ykI9rWG65mTgGzle58FFiWkp+Xub6J3zrh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8424

On Thu, May 16, 2024 at 02:31:59PM -0600, Alex Williamson wrote:

> Yes, exactly.  Zero'ing the page would obviously reestablish the
> coherency, but the page could be reallocated without being zero'd and as
> you describe the owner of that page could then get inconsistent
> results.  

I think if we care about the performance of this stuff enough to try
and remove flushes we'd be better off figuring out how to disable no
snoop in PCI config space and trust the device not to use it and avoid
these flushes.

iommu enforcement is nice, but at least ARM has been assuming that the
PCI config space bit is sufficient.

Intel/AMD are probably fine here as they will only flush for weird GPU
cases, but I expect ARM is going to be unhappy.

Jason

