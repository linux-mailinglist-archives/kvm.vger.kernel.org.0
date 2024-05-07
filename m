Return-Path: <kvm+bounces-16847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 760BD8BE754
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:22:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 145EAB22E8B
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 15:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8B421635B0;
	Tue,  7 May 2024 15:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SxyMA6jJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB4B160862
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715095133; cv=fail; b=tPK4MmMQz8TbRJFQBku6pAn5Q74KY59I8aXxw4JpP40mdLtmPtrKBNTfYiH/U9xw9zIcvKD5edOndh/oK5UyDULBLhAw+dKsaOh3BMxcRsze1ZKsVFg8SKqzbDBe7SHwPswQYMhOCsJvfQllFlu2FykZ1klrnY6zxFzzk68u8NU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715095133; c=relaxed/simple;
	bh=jzAK7AARQ9rKWdm0TLEd1gb/vlWX89FCnBTx0JZrDeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bZ8ZDINLvYlrFBqQunKvqDYY30Fc67Vks1rcw2bwa7Rbg+5fbThG13QLJjd3KFXeocrpOQpWqb0PX+63EpRuFxU9aKjEsuk4UaLkkUfG7I4bNyI7M4HV1HVd8mIoJ134LrdLQE9gt93cBrmB0TNnzxnDkX8VC5F1wOI9c5HYSnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SxyMA6jJ; arc=fail smtp.client-ip=40.107.244.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbFMpzq6RXgLPnJlIAwnj7f27cNMF+n+47zcnCzeEp1OjsptsGqcYay3pa2V+A0AAN1G/pkgFn7hHuKIr4u7O9XzJME2NtoF96mCLgeKXFur2fkV7Mbu52DOzjMTGcP+ouzHgbjB1gNrao0Ib3oiOKMYy0Miqkd1DACXJiNffDdlHPzQLRMoOBXuPsvuYDJwKZ1mDpquZX40NABSZrIeR1YbzQHYUjkg9R1ZMHCh/3qoilTnJBQSJCtAOUkFd1M9b8j93cOgVU6MVGv1kty6M+zyEQ1SITwmHtST0nzwx5YxMEal7TaE+WmQcFJTIQs/aNo+Ipr6uUgpMeOfPyZwXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fb5X3L79jp9Maob10sjVVuPmBTU6x8Lup2wZ6HraPyo=;
 b=a3pvrydVLOeyEWkCRszaHXSFCFyGTwzT8JcA1TPu+t8GlTxYS6c5KQhvX2fKbZMWcjlZougjCvADHdl7IymdO35+uj1W1icsB7gVdBMLKsieMdM7AOPv+pzWhIzeW3+F9keluzCQi7BuaNQfwhw0rcB9SJQxBzSZk8ClaOK1fWTDSS5QPc9FhuTWXzQ/WIdj/3qweb0vz9xALmQtko/FJ866VKhLsmcBG5ncGoUqGR238YDRjEj97xAqwKeSVL+2EDz/xes6BvWm9X22tjzbyiqe6miYwHb8RWicOt4gkytaP6WzBe9RGGhnUL/GC3pYCdTGgXL7ttDxUxNXNK18YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fb5X3L79jp9Maob10sjVVuPmBTU6x8Lup2wZ6HraPyo=;
 b=SxyMA6jJFd/uSWxkJ/dhAcwKePQNnS+AkDUzN/esWsekILadOhvm82Afuxyp3WeYfcFaif/cqtPzKpEhvj9EMvq6NjXpLXvk49+cRP9ovIi8Ejeyr1rXUL5D+7F+ejIpbGiCoRPkYENR126TxYnVcslhC6nBw3MCJka10Vjv3wdhiPxlI4VUTIWFJyRabFaHVjlWb1iqaz2J25EuuJGDGiozMKfXZr417+MyzRmgI398nnP5M1ru9vSgx2pbQ1eHgBMh/LMIyYKHfCoag0OO1LRJfAtMFahiBvyBcMiOfj4MqfQuyG9eqXzU3L42nfv0OKmqK8CDQVwqbbxUdRdppA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH2PR12MB4327.namprd12.prod.outlook.com (2603:10b6:610:7d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 15:18:49 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 15:18:49 +0000
Date: Tue, 7 May 2024 12:18:47 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 12/12] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
Message-ID: <20240507151847.GQ3341011@nvidia.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-13-yi.l.liu@intel.com>
 <BN9PR11MB5276E97AECE1A58D9714B0C38C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d466eb97-8c2b-4262-8213-b6a9987f59ea@intel.com>
 <b4fe7b7c-d988-4c71-a34c-6e3806327b27@linux.intel.com>
 <20240506133635.GJ3341011@nvidia.com>
 <14a7b83e-0e5b-4518-a5d5-5f4d48aa6f2b@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14a7b83e-0e5b-4518-a5d5-5f4d48aa6f2b@intel.com>
X-ClientProxiedBy: DS7PR03CA0206.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::31) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH2PR12MB4327:EE_
X-MS-Office365-Filtering-Correlation-Id: 93419a7e-b41c-47bf-4d36-08dc6ea8fefd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UCJhnK5h2UN48COrw9xRihg7rAbAkpkyCl8MIEvRZWElLdZ4cgkvBia02bbB?=
 =?us-ascii?Q?ThbgHi+AR3WWX5V8Ded0kmtTlSZRBk45JrEe3c3698Dn4Yx4ThaHUNSG+5sA?=
 =?us-ascii?Q?43NVchC0ImzPQpvR4iHyriLbwmBKJE+isA5d3TkzVjEjOonzNgw4TSCBSNTb?=
 =?us-ascii?Q?XqNRs5Ax4ee7foJUuz9kDcVPzD9ZA+VlEhjMtrUT/+tXBTcjCAxQGN4AX8Jr?=
 =?us-ascii?Q?s1onspfiAJAgcOFoWxS+PEx0nwsaavC0h1x9zm0dq/mIKalGQjSvZw+IPfLq?=
 =?us-ascii?Q?PAWEU9gkx8tqhmJMb+QMcusHI3K6PLhVakyCBeAsO0X1T/nYKnS/oibJ2OjV?=
 =?us-ascii?Q?UENtPR+SLDHDd+kiCMSzfAlAR5T+xzn5zbAPb3dqpHir9bHoP14FfEG3PU7o?=
 =?us-ascii?Q?GKqNUd6iYKgWgWnEJrvLL+e+ct5OI5vq3ngGxQH/6uqJX4fSv/bHptito6rA?=
 =?us-ascii?Q?WLhy3+pNdMbSBtx72xeN6kfnKGli3qOyNLkCSyLo1dCp5N0/lb32fkomLKEZ?=
 =?us-ascii?Q?jJGCiV6mrMlPkYwxA63zEIYs+MMXYACsxzdzo3nM3fKhQxt+RP4Mxw4CE/UG?=
 =?us-ascii?Q?LSR2RumpEq4mGfkcRRkigEciWAseQt2llqzV22Vttt+SwreTj1NGr4ch3qbQ?=
 =?us-ascii?Q?OUncjLL2ftVz8CP0KuMPG4Dhm5j/OvTQSnAh62HcCAEA9nlQSLQC2p8jxpBt?=
 =?us-ascii?Q?0spyEGRI8IPjVYktN+eD0ZwZdmyP3z2HjDo03HskurV7PXfV8IvVxrwhvF9H?=
 =?us-ascii?Q?+3b9E/lZFcl3EbWB+vpR8hGC7uelrBrJgJd14YZUXJuTWcRzEHRp5Gwi3lTp?=
 =?us-ascii?Q?mbxY7prluTwKrqWIdI1Sgesa8RxX2XfuBJfvlvNqIibnupKI0TMgz7gks4fv?=
 =?us-ascii?Q?2bseryjtwQGtMmPGzXAosF46XwIhsoKdVZ9hfCArgnex8fVIeLV0m968w49r?=
 =?us-ascii?Q?jFWWbacaW16dYYyOp30XJcvb0pSHfSD63wpXi2HYlZgFz/flwobuFKkL43TZ?=
 =?us-ascii?Q?oe3PZxe9oguDh7Ak/WR7DsWz9LdzVFBtXQDBUU78Sr/O77ah+T3JXUUmVvzh?=
 =?us-ascii?Q?B/cx+2obdnru6Me2JhNa37d731cRz7LGwZZ1Ys34ujo4YxUfKUGrhMCrKARu?=
 =?us-ascii?Q?0kc/1CuS4z4G0U73ss+xem+P7S0AykqvyXsUCNmtELK7wHP8F7mcT0EJ9Fq3?=
 =?us-ascii?Q?gymTlCFj8/PZ85taaRcJoxSrTQ1n93VMHGpROPZb1gWKbHVXgRyitDYSUl2w?=
 =?us-ascii?Q?hLe/4uDjdD4cxmxNHiJt0cAy0KIlg6927Q0I3n6Eqw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lAUZPYFYBc2G67zSKFDEVFzbbCeBN/SUdeU6aZ2xvPaPjScYqFJRIEMOoyge?=
 =?us-ascii?Q?INS3HJH07Z4s1yppSdXOkRqCI6cYBbTlS/tFs0g0sZkAhxJiKiLdi5OSj8F8?=
 =?us-ascii?Q?kQtOhFD2Uv185vYIWcpnHhnCMh5x9h/L8OgljWfdoduGhdeYuiJtYW875VCd?=
 =?us-ascii?Q?IZyumSh5FqtYJl2WJ5+CPZMUEWhp6kMpMiGhDmk4YByA+PPGPO36AhGgpX8J?=
 =?us-ascii?Q?RamD7MXzlqSWv2pIIGICzkGOFUkiZ2woNSo5KQDk+k2vXaNiClAo0vfd5TRM?=
 =?us-ascii?Q?ttVBKN0Y8ZizaB0h0HycClfNA2FDOdfP0va+euQ5/1pzeAN49GVpu7x21Deh?=
 =?us-ascii?Q?R+eNJbj1ueO2WfHcT1HYaTwj6AdcgpXiD+6uOmF3Ctl8jc9gmBbvSWSG2SJR?=
 =?us-ascii?Q?2W95U4wiRkOtR56iXgH+8uK4QI3DUkkdYJCXWL0b1LufheXQnS+zsJeYKXuD?=
 =?us-ascii?Q?gx1XLKwr8HY4srpOptCdeSZE/WE2z9wCFa1mbU0HHobk2kqVWF+MIGMleoKR?=
 =?us-ascii?Q?YcyF5Gkx8/XMMvrssByJm0EvRqHdhmZefsU50zSJ9X4iE+FWciCxIR39cyzM?=
 =?us-ascii?Q?vZ4Cng6Xlcujhcnupce6XySO7ZMS3q3u/peiVuNrHOYRwhLabKBPfAAB1y6l?=
 =?us-ascii?Q?MTnSr/z8VfK9ZRaT1vd5FiOxXH6TbS1tdEWNnAl98csqAwGSg1CTLh2gc64Z?=
 =?us-ascii?Q?iWGzpXf8B6o0wYYYAgEy8UKfydfzJOkCrnnZQjJfY75RlGT6pkuECmLPuwNm?=
 =?us-ascii?Q?OqhJoBzucd5j2hnJIASNhSgty0OHKkIZgh2kVe1lVV0xJLD5JC4ikm18Nnc8?=
 =?us-ascii?Q?ctFw9ZKkCcsgtkBexje63i3lyzNLSQLDqIux4vnKhlsUsa3BMBfJX/cU/Sdd?=
 =?us-ascii?Q?dT1I73m4N8OtrutJFivWhh9+9pVCzAk45i4dBowlpnK89dbehHPRe/kuEOO8?=
 =?us-ascii?Q?jHOAxMhhpEbij1ZW+fzAzUzwsT6o0P9NPZwQs3mDfXIJLN2poIvPyTg81whp?=
 =?us-ascii?Q?j6bL022quaZPRQ8LGdJKzRmsgaR2OKFfRjJYMhjr4e4igbtmE4cHbwyCk9oi?=
 =?us-ascii?Q?X/Sbg2tyAlC3kVKfpDnz84DixNtreWqnwNSNiXhCfZgvTUKk71EWm03MVuIM?=
 =?us-ascii?Q?4TupNWZkZDdFLK3GrSFCMEv+a5LWjGsEzzVUbb4DM0OaOenxb8IBGnhwtZ8E?=
 =?us-ascii?Q?v8mgSv01Bf4zIVEtXUp9G1hKJlQIZvMOjUzBbJOhNdoB3WF/1nrII1lkAMT/?=
 =?us-ascii?Q?TRr9hRSN26FLI4gNsgQMabkKaW7Q28G3kBp6F77aBd67q3NgZOX4FWHwwUt+?=
 =?us-ascii?Q?ne8GtgG8C2ZTDnXgCv3VFH7J9gTqD64fy+wx1U8db2rynWVXZWBJtQe30YBB?=
 =?us-ascii?Q?dtCoSaUUl5hReOSxDc2do/4W9aivGD6hJxeJJfyndaqgE3WoOD/e/ZWXHM/G?=
 =?us-ascii?Q?x7uGvLbT7UitqZ2SV3rvbF8BKEna2jPRuyF3zChzy2qWHSR/InItw9HxIqHa?=
 =?us-ascii?Q?YnIfFaBvPDRtz3/EIAPZERJauu9VYs1cpiVHwaTaCPNmCvmJED9nQ+XzdQ3y?=
 =?us-ascii?Q?PUWgckpCPIpto4/ixp82AVWwk1DKNLWfYyVl+Q/s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93419a7e-b41c-47bf-4d36-08dc6ea8fefd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 15:18:49.2839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FXsxQaMQJFm4UQNza03+1jZf5xOa7J6e6O1Ku0EC75DRuptcz66V0MaFEF2IoZKH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4327

On Tue, May 07, 2024 at 10:28:34AM +0800, Yi Liu wrote:
> > > We still need something to do before we can safely remove this check.
> > > All the domain allocation interfaces should eventually have the device
> > > pointer as the input, and all domain attributions could be initialized
> > > during domain allocation. In the attach paths, it should return -EINVAL
> > > directly if the domain is not compatible with the iommu for the device.
> > 
> > Yes, and this is already true for PASID.
> 
> I'm not quite get why it is already true for PASID. I think Baolu's remark
> is general to domains attached to either RID or PASID.
> 
> > I feel we could reasonably insist that domanis used with PASID are
> > allocated with a non-NULL dev.
> 
> Any special reason for this disclaim?

If it makes the driver easier, why not?

PASID is special since PASID is barely used, we could insist that
new PASID users also use the new domian_alloc API.

> I agree implementing alloc_domain_paging() is the final solution to avoid
> such dynamic modifications to domain's caps. If it's really needed for
> PASID series now, I can add it in next version. :)

Well, if it is needed. If you can do this some other way that is
reasonable then sure

Jason
 

