Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520133A0282
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 21:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbhFHTGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 15:06:33 -0400
Received: from mail-co1nam11on2073.outbound.protection.outlook.com ([40.107.220.73]:31425
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235813AbhFHTCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 15:02:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhH2rCXMReUFp483wDToccUs3BsEhNnPcWvu+9yjSswr/uDWht1bKzD7Qi43xQ5W5qGDam1R5zBR47Tiw5odUdtpS8q+Yol7pi/kU+iz/Vbyv/c16+MLfSR11VaEdQRhoIG7ttF6pW9VRdL8ixeUOYm9rWwtYBZc/tY5/ELZLME17X7hbSjUHbZxWc0dbhFZxxELtIP8EsYcwT3XwzLWQQewewvPWIGgYze68mwc001X8F0yD4FRL8QIG6mPtjsLKaNNgeArG4SvQ7yLXKxBr8kULinwxgmaWDKVHPqBSuDukdVBoCp2zglJhKdUFC8f3ej5EOHTWMbyXXs8q79OGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuLcNcP0pF2YgY2nKTijhzYsKgXGbRjA7v7yPq5m8Hw=;
 b=AuUXVuu0c8+EfHelT3NsfEe7my4ic+3FUP9bf363YBUcbgRp4lu/89RUdpZtJ0sfVqaka5jzkCvXzvIUGVUi7Jup3pc3P/0ToRWVudtD9Jw7/dBlALXT+VeQeozrH8UaQAyXzpN51QyCnel5o5CcPdXJyqLFM7NIOs/ywiziARnmA5pSrtNqFo/PcDelc1zQWjd+UPC9cHBhELJyjdRyDFrgcy8oVebmN9X6TWLSLy60ZgozGzlGP7dPtGz1yQZ3ohfbPMY3EngkzlhUn4uLCleXSroNyn9rfoJXzX5xuPV6LAShvKdC3a4bqC0mQeaUQlPJFvAFIK/JikJd/qfIxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuLcNcP0pF2YgY2nKTijhzYsKgXGbRjA7v7yPq5m8Hw=;
 b=aN7kfRdRxBLKz5Cv4vKEOHUSsss/qGCZzHwGsJ9vFtCFcFkvpFzPlcGTtToJ2uwH3LHi2owHl2Vb3MG0EwC45iqMFpIinwibkPW6HVsMNKgc5w1IIyu8y9h+bb3XA/XHrrS14aJHNybozFiKjw5YyEj42sEeZFMcjH7zzsXe9z3mBr7RwGq+JMyuySE58jCgZssS2O0Yp82BGnaf3Lr1LY2tVU3WrVMxGVHHmgnUIduW21KE7SGzWJxdO1a5kqH1gmHs2qSpdleM3lrUnVWJ468V/4rQGGK8wESd3kKCPMO7wTkOKMkg0l7IrWCjIxYOX653nSnckHtFFwb3xtNkMQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5286.namprd12.prod.outlook.com (2603:10b6:208:31d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Tue, 8 Jun
 2021 19:00:24 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 19:00:24 +0000
Date:   Tue, 8 Jun 2021 16:00:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210608190022.GM1002214@nvidia.com>
References: <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
 <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <2d1ad075-bec6-bfb9-ce71-ed873795e973@redhat.com>
 <20210607175926.GJ1002214@nvidia.com>
 <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
 <20210608131547.GE1002214@nvidia.com>
 <89d30977-119c-49f3-3bf6-d3f7104e07d8@redhat.com>
 <20210608124700.7b9aa5a6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608124700.7b9aa5a6.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:208:120::42) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:208:120::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Tue, 8 Jun 2021 19:00:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqgxa-0048bc-VO; Tue, 08 Jun 2021 16:00:22 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df15ee2d-ad71-4b17-3bf9-08d92aafabf8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5286:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52863FC26DD9E5D200F8095FC2379@BL1PR12MB5286.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UbZqGnrYJiVGXlkaqTZdSh8luQWk6G1MAF2ESN3EVy+m+j+nZzSJVHyCrZGZoSl69dl+GlxRjl3jZT38aIJkrQes6i3klAG2TZe9+qE9wYCxOL7dV8hHBcITbSdS2ev/Inw+PDzBC7YCa7C+6RznaTNy7DABt2QItwzVf3f4oW2X6B+0rbf4qBAfWWwuYAgoY8uzlpVd32PPbIalSc7oAPqB0F7xAB/qO4NtEbRPieEFVT9HMFsKwoZun+Zsnhoyc71gErOV9SAy54571aFVvLC2zPgQZZZqZTcFxRMOzpn/bRu8rC0IS2ixtEvHqL66HJLolCqJG4GtiZMYxSOpFsJycOEwUrQ5DSRVZHit3BCIMBoN388gYm1uH9Czshby3xJ0YTdIg8zGtgKIQ+awJWMPjd1o3v3A+j3PWP+jjm2YsyyAfTaihognHQ+Zae5TSPW15lHI4H75Q9oJ3RSNp/PFaslFkAQX4mGpNBccfl4CA3X6hp+maISCdIcQE7+xMv2O4UQb3gUWkujGL9jOJpQDZUH7NvL+9wNCxi/exPtlbytOBhKR4n6ebTdX8+6fQJK/OE2v+UYOoBD1/QUyo235aI5aUGlWVOqdJLIowkg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(9746002)(2906002)(26005)(8676002)(66556008)(33656002)(53546011)(54906003)(186003)(5660300002)(36756003)(426003)(478600001)(4326008)(38100700002)(6916009)(2616005)(83380400001)(1076003)(8936002)(66476007)(66946007)(86362001)(316002)(7416002)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yfzxFWQ3+JsramzeKZpsDk+Gj07qi210+wqCrAj0EyDGwmHlZ0NssIjlwsvS?=
 =?us-ascii?Q?VPDIKp2LZvePnsOxWYGsTKFbStrUIbiuAOI+gndcpVyJCUPBg8v9I+RXHoEs?=
 =?us-ascii?Q?BOOw70Xg+QZ6LV+Z0oPMdLc6w+5Joa3F05sBtJXo7Dzs7gw7YvCJGvx5UMvG?=
 =?us-ascii?Q?VO2IuJqeLVAunWO4rUY3V8EqqTs7hg2VUVG5VmiQm1YgB88uJTgR8CjgSbSh?=
 =?us-ascii?Q?6eavOCeWVEL6kj3LJ7mczAurmkDEhwL+3mPDkgODr3LD5n+BOQ2vMULVscSe?=
 =?us-ascii?Q?5ctAJm5uq3UYBGnk7QvmDu8D18SUpAiEPpj/zXYp2OkurhiOZ3BDxNGk4NuN?=
 =?us-ascii?Q?qOwkDzgd1fCk4gW/7961oboYH0f+srg/j7anPgAIAWheVxuBBucq9pKpjSm+?=
 =?us-ascii?Q?Dbb6mTFp5Oi2Lyx9sGO+dK6UhlHaw8qPWFedZwVphjQGRV6LgsHxaOVkzqxH?=
 =?us-ascii?Q?FckGGrY95XvySycYR4aNGmLd8yVsHLg2MtH/2VjC91TAvGrOTH8nA/TM2UmM?=
 =?us-ascii?Q?VuSVZ39x/3Dc2mOgqGsvS9P8y5vEuOH+nSAz7FtKmQwN+3UxJ5IgkhTaNW5z?=
 =?us-ascii?Q?PF3+4hkjoySTPX+PjqTqdz00/j5bpIHVenKxnh+ajUA2dm5ylxVNl39rt7tP?=
 =?us-ascii?Q?I/oGWwIUOzLTGB15FzgjWWiE7Dw71YJ7x6xDC2LGbSdyxZEHjdbxIJaW4jYP?=
 =?us-ascii?Q?5v+H9A9dl9bkCRz0mfaPDYLyOBwXFrjfoInDD87y3KDZMXPHUvrM2edbnrBU?=
 =?us-ascii?Q?k2q4lPFPAl8S2qcWXWB1ZttKepRdkXdt/BW0iV9YqfO6uoPuOmc3NDS1XBb1?=
 =?us-ascii?Q?n9+nmfVlinkl29QjNlwCcuj9x2eitBaWwVuC+/nTA3YGHtoaKisY+NuzRPey?=
 =?us-ascii?Q?7UKEk5Uq5i7BHRQ3HuiAbE1OKtJu0EnXjjkAzFx6FHifCznW6oEoT91ZA9SZ?=
 =?us-ascii?Q?oC8bQF2nECRzXtJ43bReSUGQr2+SwytzkMpwohTB+KrbTzX3YmWIRG8I2f0P?=
 =?us-ascii?Q?ysz4mBSyyZpWwBXSNXkhXXMhLGSf/DWRQu3kD2FIOvdCfHH/L2IMryDjCVN4?=
 =?us-ascii?Q?EIB+99ssgUBGHz/Y3ZHZJzebp41JgBWkHB+5UazmZXfYZZg05Aexh5xo2C4t?=
 =?us-ascii?Q?G3avfhOnkYss0Gh/eHtYpHQcPcVTWmvGl37HiAa3yP+WVu7pHtRQ9lXbkVEk?=
 =?us-ascii?Q?WXOEopYzdmNbg77DRuVvEUQjFp79DOBJU5+a/CMPtQyPcsTAxMETX25Vi5MF?=
 =?us-ascii?Q?UfVzC3ahj+90wt4p3RDYIVGAWQRJ996A91dW6CZvtunKgkUTAOI1bWh2d7xX?=
 =?us-ascii?Q?hvbYk+Zlf64JnAST0yGAlIQf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df15ee2d-ad71-4b17-3bf9-08d92aafabf8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 19:00:24.3885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fDLyXK9wMRSu7uCJpvYMztPFoDulEaRXY9ojhwuNhKr58iVExq6rZeyi2su+Pg42
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5286
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 12:47:00PM -0600, Alex Williamson wrote:
> On Tue, 8 Jun 2021 15:44:26 +0200
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> > On 08/06/21 15:15, Jason Gunthorpe wrote:
> > > On Tue, Jun 08, 2021 at 09:56:09AM +0200, Paolo Bonzini wrote:
> > >   
> > >>>> Alternatively you can add a KVM_DEV_IOASID_{ADD,DEL} pair of ioctls. But it
> > >>>> seems useless complication compared to just using what we have now, at least
> > >>>> while VMs only use IOASIDs via VFIO.  
> > >>>
> > >>> The simplest is KVM_ENABLE_WBINVD(<fd security proof>) and be done
> > >>> with it.  
> 
> Even if we were to relax wbinvd access to any device (capable of
> no-snoop or not) in any IOMMU configuration (blocking no-snoop or not),
> I think as soon as we say "proof" is required to gain this access then
> that proof should be ongoing for the life of the access.

This idea is not entirely consistent with the usual Unix access
control model..

Eg I can do open() on a file and I get to keep that FD. I get to keep
that FD even if someone later does chmod() on that file so I can't
open it again.

There are lots of examples where a one time access control check
provides continuing access to a resource. I feel the ongoing proof is
the rarity in Unix.. 'revoke' is an uncommon concept in Unix..

That said, I don't feel strongly either way, would just like to see
something implementatbale. Even the various options to change the
feature are more thought explorations to try to understand how to
model the feature than any requirements I am aware of.

> notifier to indicate an end of that authorization.  I don't think we
> can simplify that out of the equation or we've essentially invalidated
> that the proof is really required.

The proof is like the chown in the above open() example. Once kvm is
authorized it keeps working even if a new authorization could not be
obtained. It is not very different from chmod'ing a file after
something opened it.

Inablity to revoke doesn't invalidate the value of the initial
one-time access control check.

Generally agree on the rest of your message

Regards,
Jason
