Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1F31C2FF4
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 00:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgECWV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 18:21:57 -0400
Received: from mail-eopbgr130089.outbound.protection.outlook.com ([40.107.13.89]:59879
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729151AbgECWV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 May 2020 18:21:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BoP9kH235Ss4iS81vpH4Pqtl+VayyLFSjbJRd4SnrYrqUE9lSpAInSd+bQSSfrkbeYyp8AeOSEE+8kq84WnqQJwlbTQtdXV9tF7b6Yh6vI/VJ1JO8X8QAuQCusu+7/fa9qrU/xR27L51sHngSwIjEWFbadl6+/29qC+CRzubM1Ihzcj/pE9INdnfMnd84GME76lSceSbJiOo7cZUxM3Q48pRpB5jxAV8Ty8gfBpxwX2FLecmbln2/iaCKax4Z2oIq/LeVmSl+BUcNU/lnU6uM0JBukpmjg3XAOW1IHazd/JjxLzdJkG17IeIa7dmzok8yLPmbs7K7dQEkYxZ0c/Okg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vIk2+lmBmmYTY32YXfy0lICjta5/9zOoRysPnAsThg=;
 b=Vvj5ORHgEFbFitRHUljHcDolKASlDyZHbX6mvaYVDqEHcoSkavIDyFvv8/U0ELfTGrMXo3PcWmiF0OBzUMJ18I/7xXbbXodpwXolhrLNjw/NHKM64VCIGesN6zFjRLvENeUdrBQJ5NUESIoaUlNIUdKOYuKPqWvOYbxRhjoWmGecDb6gUHGTyPv/FxC+0fwfHDsUZb4xFC1uthZvWCVGUXc0u+PkGK/TjRb0upKvkuK9zVU6lQNQJrDRc/a8U1b0M7t71ue1EeDqAJN39JbgTU5ne/l+PO1UofXt7izulhekQB8VGQTOdR1NlXshM4atbHcpgQHkIlEWwFz2ZmxJsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vIk2+lmBmmYTY32YXfy0lICjta5/9zOoRysPnAsThg=;
 b=BrdRd3I+qWE2d+p1Ics5/Mpkq5tUyf97OYdme5qzOvzUYgmaol7riIK33eyfGLMC1UqCg7V2/txAN9uvYJjf0ELBCuJR00266GIGnrqfFa4R9yltisZ0DybF++ZuvhLTI425kT88C5ZoxM2FBMkUwltb9Q47WGCOr82ARiB52qY=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none
 header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4157.eurprd05.prod.outlook.com (2603:10a6:803:4d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Sun, 3 May
 2020 22:21:51 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2958.029; Sun, 3 May 2020
 22:21:51 +0000
Date:   Sun, 3 May 2020 19:21:46 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Dey, Megha" <megha.dey@linux.intel.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, maz@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, Yi L Liu <yi.l.liu@intel.com>,
        Baolu Lu <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Sanjay K Kumar <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>, Jing Lin <jing.lin@intel.com>,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, linux-pci@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200503222146.GD19158@mellanox.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
 <CAPcyv4gMYz1wCYjfnujyGXP0jGehpb+dEYV7hJoAAsDsj9+afQ@mail.gmail.com>
 <CAPcyv4hGX5jCzag8oQVUZ6Eq9GvZYLN_6kmBAgQMbrBbNzJ0yg@mail.gmail.com>
 <20200423194941.GG13640@mellanox.com>
 <c50c2eda-88aa-00bc-7cd6-37cc26052cd5@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c50c2eda-88aa-00bc-7cd6-37cc26052cd5@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR01CA0036.prod.exchangelabs.com (2603:10b6:208:10c::49)
 To VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR01CA0036.prod.exchangelabs.com (2603:10b6:208:10c::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Sun, 3 May 2020 22:21:50 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jVMza-0002Q1-Pv; Sun, 03 May 2020 19:21:46 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e43b0aa9-136e-4282-aaca-08d7efb06049
X-MS-TrafficTypeDiagnostic: VI1PR05MB4157:|VI1PR05MB4157:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4157A0A84D4B6C96AD0904D0CFA90@VI1PR05MB4157.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0392679D18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: umyV3I9EstpaKb7Fq0XkT132tGKYMErZGjMT9FubnGcXUFxBNjiM+A+s6/uUrUq2lRVCL9kodv8QtmwXqt1eSWgDkJ4g0ldnPLB44Ye4oYQJaKreGHE1ZrZIqUs3WE1IhG16I4mb6yLlXKZ/cvryf3E4HI/xIcYA4haLDf5dNS3w/07oyaOwR07ksQnx3RHPN+PNCXdDILNyExvTl7SBcOnQtsmW4SWbWgs/4RqsSJUkNokedNkjftHniuR2zgbjRYBIFUstJcGwrTq0C/p/QgxI+8MKN6bqSxwxOvRPd/tfXnF1zvW/2r4xYGGAtylg7hY4CCJEaRZ8Vpkzo+F+w1rNz7zo6T/eOw3/UNYokIDTRUm7DUxYMu0yMti3OHVd8b5GIwyXff1l79mMoWwdXclPVBpdgJHGARR+FhA296/mplCP2SwtSa8RvGcI8k7a8GxbGSCW7Nd4ODFSEQTTc2/juO81mX1X30a4VaTDHQwFMrEqVnrS8c9q6mOJbUrD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(33656002)(54906003)(2906002)(9746002)(9786002)(1076003)(478600001)(52116002)(5660300002)(36756003)(186003)(6916009)(316002)(4326008)(26005)(2616005)(86362001)(8676002)(66946007)(53546011)(7416002)(8936002)(66476007)(66556008)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BLWz3YQRTEFVN8y+4DAx9EuLXa2y381FRevHe1Gew254VvXw+Qas3UzG6wOKKQOPkb4Y/EJNDFGy545LunLZVEMeXAFbilZAPAgxmhyIk9+h/Np4llJa5S04kkHtunontcsDGYojvFGbDyG937iesQEFGJbNqeoTlKwjlyMZvTFYL8+zZiPBaZuS3cSw/1IlrsOWFdl+V7HJWPhaLlUGc6Sx3YljEdrn6nyqNeC6Kx5DGYERgsb/7Y3OglypxlQD5ZCFd1AoenROMLbg97OMv82u3ux3iAYDIBquF2ZNVOzryljWyEB5iMKdBWrBlpZRzqLRC6HKnP/TpQE0NIzmrYvBkoKi36CQ7HwYuccXaNT0p+69IQDkOBrINmCKG9sx03HRfs1De9ZaxFyNyvFfRkVJZMtrPhNyYKYvtk+AWgHV6P35frIluTm/0mivHB0HCptKuamKB05fHjqaR/f7MNUaSsF0b/iYLnoKwHGMnS5YEyQCEdPcXXZPUgdDkvBl3u8SL+00wybHGlCXo7OFohgitvnD6VjKgcTTGe4hjAW47F5a6tUHxJdSiPr2vxpwHvLs4VkFbfFtPPVXhFBYv1Vd+u3FKqOKoLr8SqqH6Yu2VJVET/UVCsWu1PLrgsFNWpiMdySA2ZrG8MeyqrpVloRryIVfkj/OOjIXh9wUVzb9sCJDChO8ZegeEV+uFPt+ZnHxNw+B0TSmxbKOAWIjkUImO8zym7QYOtDZiCRl3gvb2OdS1a/AWxWujEwkDvBfTtrju3IFhP26OAFlBUOUxdpeJFqNKzWmilQirPqbCJU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e43b0aa9-136e-4282-aaca-08d7efb06049
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2020 22:21:50.8425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zqYnDMusTxOxRvFBqjFgt9lWcC+L/9K6rColQbTQNWKdABp3SqStiKxvqhkC5iUp27coHeSN1GTSoB23kdWGVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 01, 2020 at 03:31:14PM -0700, Dey, Megha wrote:
> Hi Jason,
> 
> On 4/23/2020 12:49 PM, Jason Gunthorpe wrote:
> > On Thu, Apr 23, 2020 at 12:17:50PM -0700, Dan Williams wrote:
> > 
> > > Per Megha's follow-up can you send the details about that other device
> > > and help clear a path for a device-specific MSI addr/data table
> > > format. Ever since HMM I've been sensitive, perhaps overly-sensitive,
> > > to claims about future upstream users. The fact that you have an
> > > additional use case is golden for pushing this into a common area and
> > > validating the scope of the proposed API.
> > 
> > I think I said it at plumbers, but yes, we are interested in this, and
> > would like dynamic MSI-like interrupts available to the driver (what
> > Intel calls IMS)
> > 
> 
> So basically you are looking for a way to dynamically allocate the
> platform-msi interrupts, correct?

The basic high level interface here seems fine, which is bascially a
way for a driver to grab a bunch of platform-msi interrupts for its
own use
 
> Since I don't have access to any of the platform-msi devices, it is hard for
> me to test this code for other drivers expect idxd for now.
> Once I submit the next round of patches, after addressing all the comments,
> would it be possible for you to test this code for any of your devices?

Possibly, need to find time

Jason
