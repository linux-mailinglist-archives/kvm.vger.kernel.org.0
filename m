Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE187248BFA
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 18:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgHRQtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 12:49:15 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16803 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgHRQtL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 12:49:11 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3c06160000>; Tue, 18 Aug 2020 09:47:18 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 18 Aug 2020 09:49:10 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 18 Aug 2020 09:49:10 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Aug
 2020 16:49:06 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 18 Aug 2020 16:49:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RsH8eoLcuddzy4lvDlWFz2pOrbayANGKdQHExZ4YG8u/FdiRg0LAfsZPsTm+/d9XLuy7zseVNy1gLPIBcJF3XUE/DvdG422UDjJp3l6oXTGDn9RnOJNBUv6Gq5j89N3YL26KGKs0g7xLH+MqyR0kh4PB9PC4mjlBIVzd+WhAAvi9k7FD6iB45Gane1cLe8EzfjuOZYxjNUWMVP4lk2TVZxH+SPFjs0SVX8yHswT+k3uIROmBRODV0VTk6Mm+sVV7YvKWMxy7Q9nt7I3/UZbCwrCw0FTKVcqJJr/KyDs3U/dLbuZDowewXcehNHmPy9W2mTnICMQm/g/+ZkCeBA4bLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rkSGjCScfNbjJPQ/qhiAkmrUHqRMHr1gX+zunOCM46A=;
 b=NVmZS+KebhqFRp3mrV19rgqw+Sq3E7OxdbKmMMEqbYG9lxGQnnduaZk5RkY+5aVOzofVryNUbAN2VQ9PHauSYht9G6PU8lOFnxJw2UdYPy8ot+hQQPZxs/CV/V1Hm/dnLCEJXEbhtls4CiLCNnAlaLHQyUwJGeSry80OCasDPmTFTfgyh2dVqf8VOyT4KXart+dvndKQIz7ioZIX4SmlJ3pIvcT1se7mpxA7/e8r8iokbhIDxgkkXQjByyxm4SRGWHNjeqmSCF1Eb2W701CgaKDpcJdx/ue8fNMgk+EoYu0R3omTyH1424yaB4fV0CJrFSm1i03KfrlQbYfcCyh9pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2487.namprd12.prod.outlook.com (2603:10b6:4:af::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Tue, 18 Aug
 2020 16:49:05 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3283.028; Tue, 18 Aug 2020
 16:49:05 +0000
Date:   Tue, 18 Aug 2020 13:49:03 -0300
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
Message-ID: <20200818164903.GA1152540@nvidia.com>
References: <20200724001930.GS2021248@mellanox.com>
 <20200805192258.5ee7a05b@x1.home> <20200807121955.GS16789@nvidia.com>
 <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200814133522.GE1152540@nvidia.com>
 <MWHPR11MB16456D49F2F2E9646F0841488C5F0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200818004343.GG1152540@nvidia.com>
 <MWHPR11MB164579D1BBBB0F7164B07A228C5C0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200818115003.GM1152540@nvidia.com>
 <0711a4ce-1e64-a0cb-3e6d-f6653284e2e3@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0711a4ce-1e64-a0cb-3e6d-f6653284e2e3@redhat.com>
X-ClientProxiedBy: BL0PR0102CA0058.prod.exchangelabs.com
 (2603:10b6:208:25::35) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR0102CA0058.prod.exchangelabs.com (2603:10b6:208:25::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Tue, 18 Aug 2020 16:49:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1k84nH-008VkF-JM; Tue, 18 Aug 2020 13:49:03 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 995c9018-6a64-45f9-8b26-08d843969e19
X-MS-TrafficTypeDiagnostic: DM5PR12MB2487:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB24874E28D008ACA5B3654399C25C0@DM5PR12MB2487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h0BpFpS1Ul2/3Y4F+i/IQHXmhIZAKPWnsMgl08KkHRhmg0GQQtso1x6ibowR1aq/9c03DM4lX/Nlj0yZaD8FZc+nOwgrztrTrypqCFb+3NM7ORrjOzUAfogPsX3OOvfBTsakSub/YmqyB6PgTox9Ik2vzktPQPztsE69XxAnlKMAvhf0DpwPFPcNbAnZQBcEoWJxire6VJAEz0GJXvllWXi7WlTWTrZHTdxnG5EGuqvlT9nDNDy0zUaS9qYGWjeMzThq8ys/inIIi3YQgt450X/uOZw3zXxOfTMmhx855S/CgThzFxwpRQjCS0zM4kAOlOfSQKSXWxU+4wbHu/wLQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(36756003)(66476007)(66556008)(7406005)(7416002)(8676002)(9746002)(1076003)(66946007)(2906002)(9786002)(426003)(86362001)(26005)(6916009)(4744005)(8936002)(5660300002)(316002)(186003)(53546011)(478600001)(54906003)(83380400001)(2616005)(33656002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xudimcu9dVNHMTwohSFRZw726v6mJXnmIjTLbx0vRP5D81Ea7LBcsEHvCSmBQwgFx9hgr05o37ZHTKaiizcQjZU0UUub/0kBmZkR/ifogqFZhpl6UJ2V+spYsuoFOKUECOwLE11IecXLDGBHTXfTMej7FluZKuu6aWP58pJ5H9hOU/ma+3682Cr77+QuRlXjbrT34hMmxT1QhArIWlTmcpdUMBTP6JSNqF+u4ixzhVJ1ZHP/CK12cwoU6SyC/+qU2rJ/4P+I6zUkHY17ajp4M+pjpOoRLE9gUrbLCYLcsS4azzTuS3KJAHPnu3ZycySXmbQ16z+DsKmPJIZZCrard2Mz6GgnhbUiyysn9ficlvaVbY3H8Agr1uUoo/eXsnUWC0/t8U5+yaowBuL3ELSvKDBudwkkNG2g5jvpTs6tG8VPxTjQ3tLxrODrHAL0hZDG57eICcL/wRdOLZkTdMmZyXxSmPiZaKU8nPQog7lN4VEINojA4Gzrtdf0u+OkWU0X0GP0CxMHTozuv+VapHNDo+RBAaN03Uw+BF1ldlV9jaJgs81Xl4HnHpRt+inbiS41GKmHcf4TTYEPRHjHEQSbGXCb+I/nCXKwa+f8OuxQaztLWR6sldvCoQYfio91u2bxPbd9B1W0zYSArGG1Vm90KQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 995c9018-6a64-45f9-8b26-08d843969e19
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2020 16:49:05.1343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PRK/RgnnSALI86jemSEnJH8y6bTh7jappx45rx4EeIJbj7GjT2jYoyO1bUEE5Q9b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2487
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597769238; bh=rkSGjCScfNbjJPQ/qhiAkmrUHqRMHr1gX+zunOCM46A=;
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
        b=SEzo8G+mXp+HcfugAbMSGXk4WmZnX4isWWOgCRDdSPmoH/YtpmfbgEXhQv1TT/d48
         2rY6A9gQy+U2Dzmx6uetSdEHcOSTO1nyHlkCMD9bVGJTTWuc3j6GYIE76xJbHzIrxg
         TkrVj6At00H5eOiESLt1XvBUBCpcH7618Se/Tew71j35+jkydho/2SjH8ppcmsGPlk
         JRSY+pKCKQbOIKcFfky34/Ret5viBoKP+Y69254dg6moQLtbw0a66+Dscx4OVxEZhM
         2SnHF2FzKYi+irElYjwQKhEM5fESv2klCE3XGGDJWql9OgnuOHy2u/VlV5RHxCJxel
         CxLRE/ddHQ9xw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 06:27:21PM +0200, Paolo Bonzini wrote:
> On 18/08/20 13:50, Jason Gunthorpe wrote:
> > For instance, what about suspend/resume of containers using idxd?
> > Wouldn't you want to have the same basic approach of controlling the
> > wq from userspace that virtualization uses?
> 
> The difference is that VFIO more or less standardizes the approach you
> use for live migration.  With another interface you'd have to come up
> with something for every driver, and add support in CRIU for every
> driver as well.

VFIO is very unsuitable for use as some general userspace. It only 1:1
with a single process and just can't absorb what the existing idxd
userspace is doing.

So VFIO is already not a solution for normal userspace idxd where CRIU
becomes interesting. Not sure what you are trying to say?

My point was the opposite, if you want to enable CRIU for idxd then
you probably need all the same stuff as for qemu/VFIO except in the
normal idxd user API.

Jason
