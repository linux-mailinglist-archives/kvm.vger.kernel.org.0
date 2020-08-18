Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2CF248CB5
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 19:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgHRRSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 13:18:25 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13506 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbgHRRSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 13:18:23 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3c0d230001>; Tue, 18 Aug 2020 10:17:23 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 18 Aug 2020 10:18:21 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 18 Aug 2020 10:18:21 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Aug
 2020 17:18:17 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 18 Aug 2020 17:18:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RIeFVynbtcntAOKJ6vyvs7sYQf/LwYy/4TT5zWzKYv/AaVDVFUwm+pLf6oAqhblilWftUuM1BNCjxUlsLxrawPD4lv4c7tLr8rJf+b2IswW6+2l56ezbPlP2G+TllzV2Wnb3mkP9XttM4Lax45Pv/F+9BSivq7Ho3dQPKY1ylPxIDSNBZMQzkqd2aRsTPINhmC9MgghWKG0P3BHITgjBCw7W7aqwJPgYa8lc4Q3IwN3OUjSu1SvbsJL6Kfzkb8j/s/LLyfj84g0m56+LlZgjLq891bcrRGGvDsq1KXvdhFtEZkYsXasyiDF2fVwBG39SrxBGr3wRkR9oVEQ2exvapg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcmIGuOlthi+lHTMwJVgehiz15er1/Le0h4yDlCp97M=;
 b=GrNCegepcO0FBUGRZIEl8Qa89eWzTap6/4vFyetRuODQEQrqigWdePpalA9q8BHGdfepeniDbshu29V2IHeQ5IPqRP86dY882uER71QkQHHMyxh8XLyLbeAVmoCs+POfxgn4H/WRZgZVVLc87gUuVwYMbvKST7wM36cbXxnxsYJfrj2nn1aVkAh85n9+9xxl7UIeRBt2jH2yJ3//S+1C3DFRRHFTGMeP0rHuDubwMwEa5bBRZUNHVRzL5GO0FvrqYckjbOS3Ubf+s+lmTFMF45Oa2hPvIRf25aSDYPo5tHjnS5+kq4nmx8+yKvg8rQ4z/WX6sE40C2d3c2rhva83hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3307.namprd12.prod.outlook.com (2603:10b6:5:15d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Tue, 18 Aug
 2020 17:18:16 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3283.028; Tue, 18 Aug 2020
 17:18:16 +0000
Date:   Tue, 18 Aug 2020 14:18:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 00/18] Add VFIO mediated device support and
 DEV-MSI support for the idxd driver
Message-ID: <20200818171814.GB1152540@nvidia.com>
References: <20200807121955.GS16789@nvidia.com>
 <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200814133522.GE1152540@nvidia.com>
 <MWHPR11MB16456D49F2F2E9646F0841488C5F0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200818004343.GG1152540@nvidia.com>
 <MWHPR11MB164579D1BBBB0F7164B07A228C5C0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200818115003.GM1152540@nvidia.com>
 <0711a4ce-1e64-a0cb-3e6d-f6653284e2e3@redhat.com>
 <20200818164903.GA1152540@nvidia.com>
 <07fca197-3587-a45e-640b-bab0858067e2@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <07fca197-3587-a45e-640b-bab0858067e2@redhat.com>
X-ClientProxiedBy: MN2PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:208:c0::14) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR05CA0001.namprd05.prod.outlook.com (2603:10b6:208:c0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.10 via Frontend Transport; Tue, 18 Aug 2020 17:18:15 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1k85FW-008WEw-63; Tue, 18 Aug 2020 14:18:14 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cf5c2d6-7af5-4ebe-c254-08d8439ab174
X-MS-TrafficTypeDiagnostic: DM6PR12MB3307:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB330777D468D6CCB1A3B4BE9BC25C0@DM6PR12MB3307.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZZ4IwAsTmC2xP20rCRv4w0gcMNtW2mW3SDiRTG2G9zbVwz2KNWQeirVUhXciCXxvDzRQhKhmBU6ktvohfyKkTi//DZ1VvQ6VlM5zeZR2FAvcxcwrznhNY0ll/bD0CmLZQDxbyn3JSij/M4DYVWulcPRakN+a8c6bHtvLDPdYYdayLIakygSMzYgSNwWbSECFdl2ULnmDlDGdlmRKOymWqsoj/WZRPbDUQ9l7ZsJBl9lBZ2KubsS9sS2Knp/5ItusNAer88e+PyjQxMjrBRUEl6NWjmS3gha2VjBAT11koempLOiMcLk+l5sh+cGLQiKw/qdfA0wXac5FDbkG2qO6UQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(478600001)(316002)(54906003)(53546011)(2616005)(426003)(26005)(186003)(86362001)(36756003)(9786002)(9746002)(7406005)(2906002)(7416002)(66476007)(66556008)(66946007)(83380400001)(4326008)(33656002)(8936002)(6916009)(5660300002)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lsHU507d0Ww30YPyDzUn6J99OzKL1ksI4bt5W97Fvsl0U32ibecWcS+QY7Eh8SaQwrXKs/6O4/3EN4h0sGBeIxsKQjIbPhWYIarmMHdJa+zVP1yUREWn4uEjXln5v9iBlkdkGsq+2e/BP2cjsp3zeTFLIeF4K8FRInirNT6d8PPwgizZgju3VWiUHactmzee3xKZ5VJd4qQchxYDrujZd45kRr2OVW7Q2D0KBsGK08brL6JHW3RE6lV/6GDE5a1k8cMn9Z77Em3ckm/cPN9DRGv0MzUeXn0W3pj/yj8yz+yjIIRm4kjfRT5IkznDP8U6OKYXdXuhSHRcTd9j/rcEcd0FlCKgp9bhItYB2JkaXJdYikZKbP02RPsIc2Dehwn+uX522jiENh8kz0apukVGLs0uA4mZtdOsGrk4lAfZDLooMNa7z7d0u78wB1jNmbTzybRdWB9OXXEvkRdFXHCaZSyDzRJrhMN5/TZ96INbvW6Vea+Po8202D1ENEn4Nj63iHbD7a4QAT/ewZ2Gn3AJyk2mYWE7MvguOpe5BvJEDMncjDjQ+xBgosyX9Rx5Cnw12rb0yKiTKU2M2uhu15w7Yvyvnmy1tReZBTob2kKNGwCEAFxGTS0LMRGLNx+R1jfZow/86i1s5iRmqgSP8ro5wQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf5c2d6-7af5-4ebe-c254-08d8439ab174
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2020 17:18:15.8816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yLxEtAei7/PFAMu916wNtDUsMdds4sgC9JJRfPxvfc/1WwRcfhOBMAl3LVHJddwU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3307
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597771043; bh=QcmIGuOlthi+lHTMwJVgehiz15er1/Le0h4yDlCp97M=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-LD-Processed:
         X-MS-Exchange-Transport-Forked:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=gTOEDk2uJpyJZrlAJE3NNcMlgwMs/hHonMVcJqRhjyYCe9qVkZ+VCH1Afl2SCoTpn
         fAcQmXvjqhxHSdMzA7P8RX5njTdA/snoGq6o10lRyEt+VSWW/kzY7Nj7YOueSdi2KP
         ww/TcP0GrJsB5LQh1vqcwKdXh1YgJGh0iO+Jd1u//FO+6lQXh7xs04xpWj7ofn6yIq
         D47iuc8g+C7PVegm24/TZqc/IK32IykSDcKnu2Fyy4AA89p8cgWuSvV+YxFisiHhre
         k/rlNU3JlE4o9tt0fhoqAY4llp3/36Whrl21kOHLz+zFmKUFbPjWWoGvpHW1mhsqri
         zOeiPU1G/Z+yw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 07:05:16PM +0200, Paolo Bonzini wrote:
> On 18/08/20 18:49, Jason Gunthorpe wrote:
> > On Tue, Aug 18, 2020 at 06:27:21PM +0200, Paolo Bonzini wrote:
> >> On 18/08/20 13:50, Jason Gunthorpe wrote:
> >>> For instance, what about suspend/resume of containers using idxd?
> >>> Wouldn't you want to have the same basic approach of controlling the
> >>> wq from userspace that virtualization uses?
> >>
> >> The difference is that VFIO more or less standardizes the approach you
> >> use for live migration.  With another interface you'd have to come up
> >> with something for every driver, and add support in CRIU for every
> >> driver as well.
> > 
> > VFIO is very unsuitable for use as some general userspace. It only 1:1
> > with a single process and just can't absorb what the existing idxd
> > userspace is doing.
> 
> The point of mdev is that it's not 1:1 anymore.

The lifecycle model of mdev is not compatible with how something like
idxd works, it needs a multi-open cdev.

Jason
