Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC29639BC3A
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 17:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhFDPwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 11:52:06 -0400
Received: from mail-dm6nam10on2076.outbound.protection.outlook.com ([40.107.93.76]:50017
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229809AbhFDPwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 11:52:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4l85bCQdjeOZDeFgMQ6+3k1MmnZFjj3Z2Is8CoyOpJAonI8DT5uWt+Xzk0NRyx9kPw2KnGzoKUKeeBNVbD/BU6lZ7UrqmENuf7BDdg6Ke3qfJg7KJs/kCOdskb3h/6aSTODT6kI2PtQrhH4ilWqjUYC6h9Za60oW7SCU5zWtFKbhqPpK6H73zfadMivunU5aDIjUrz5xa9WjnFIO7odAnBFus0LxVsb1Sxc+Tz3NWLHv1ofzGFL6fa6e2BgV3VW1+mm7IpcMfDbUmBdyp4qUYHSXbUrrGkCgNkgYtP2ZyruXTZdnj7yetGESN1+wAVbIFFzSC04EUSjVIVThg/13g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6z5GlKrPEF/klFRu8Iccztpl8Hx/dJRWTjvZ3E3LPIw=;
 b=fW5qkwUMuSTVKmqB7vNvVrT2D39A/HWt3jYs6FuQDyzq8+KqElfE8o/tHehRHRvB6Jl+IEgp5EeaBIub6ej6vt2GUyA0Mj+11LUakxR9TEGd31kOzf9Gdk9mJQAKyalD3VHlvZ64YCA3xxHZaCCLKpXyrb+VCJ3viTng4rY1nsyIljrEqWsSS+AMkY7w/tt6KCzbCL05n8QLVhHxw2NAuRtCkwhLY1z3zqtHnaE3apoiwmvNR94VXNyy1LpknNsHrchhw2PljKFYr2j57Ys2iO+dgdPeRGiqESgTiU/0pzRCBbErcnpxMHmAcvw3pWE/QZcySfXk790fFW6KKHVZhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6z5GlKrPEF/klFRu8Iccztpl8Hx/dJRWTjvZ3E3LPIw=;
 b=H1tdeUeMmg2B7P2H0xLb8N950TMTFB9Uo9fFXNOoaTn5E5lXhJqWf8VzMjGR9NCEtUsubdFj+VVVq93hEictgStatKHO2Tn7NGxmXW+WSXnAwJ8s6pw23S3yFvQA+jWrnyXqKGItGQbtlDJd0oIMceHdNd0vfcSNuMePyM3UvsyyCiJGaA7Dx6MCuNVr4UmFfQuU39cUpnlnKCI1mByt+dVQUrLGC8fFgLOJcaN84bx9wyCj+I9pmzFfdXNh9fc4VUKR9rnTup9Wd6y/PP9ugUCn1h+13UyFb5kAGJWI51wPxb01psS2rV77RVWUGLNkKLUbgxVChqYwor0jRic3+A==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5380.namprd12.prod.outlook.com (2603:10b6:208:314::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Fri, 4 Jun
 2021 15:50:18 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 15:50:18 +0000
Date:   Fri, 4 Jun 2021 12:50:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <20210604155016.GR1002214@nvidia.com>
References: <20210602224536.GJ1002214@nvidia.com>
 <20210602205054.3505c9c3.alex.williamson@redhat.com>
 <20210603123401.GT1002214@nvidia.com>
 <20210603140146.5ce4f08a.alex.williamson@redhat.com>
 <20210603201018.GF1002214@nvidia.com>
 <20210603154407.6fe33880.alex.williamson@redhat.com>
 <MWHPR11MB1886469C0136C6523AB158B68C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210604122830.GK1002214@nvidia.com>
 <20210604092620.16aaf5db.alex.williamson@redhat.com>
 <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR11CA0005.namprd11.prod.outlook.com
 (2603:10b6:208:23b::10) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR11CA0005.namprd11.prod.outlook.com (2603:10b6:208:23b::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Fri, 4 Jun 2021 15:50:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lpC5Q-001jRc-VT; Fri, 04 Jun 2021 12:50:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c998a804-b8c3-4c54-0d12-08d9277073c3
X-MS-TrafficTypeDiagnostic: BL1PR12MB5380:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB538087457988071EFFADF94BC23B9@BL1PR12MB5380.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rMFsKujlfP8MUBjBAOSP1p5L0sT00QeitHZpi6uFB/KO46P7+twbFNN1wUiGi9+PaJhFjE1OuQbYC18D6wJrouBe285N1hHlaY6roic/i9PLNdaoCjzs/OkLpP5kVDXtlhIvE2CgWic59WNo2bkgZrurHO7A/CvXuVmYzGvzoddao+OyrfPYxEnGKWMKg5qYeyC0YmSP9zLaMdc2oTa1pmyA+QZJYWpoOW8/F1wqaJsX9/7DsWmBjcd7QuYfAs8C7PGJQ39FDj+dCAW6pvfZLmF7F8HYVZif/RxYisi7yMnFwfDQ3/OObldGAxEVueJEj8PN3ovj0QcZanBUesDwZyezU2EFpZWDXS9womTG9FW+xjqOoh+oFfEIWcEdLXv48zku43pWkGiaspZ3XG+kKB33gZ6aNj9Cazngz9Vt/fEBu+km0TLZi5lCKlC5oANLjpTytprg9yDXRT09ZY75V65LQweb/iAiZqrtvvEf/ClWpK8N+tHwQa9R3/UcJxterTX9kWX3lXU1K8w0RWTt0S0TbV6ikJ7rCUoEVQjSXPX4uiJqsvtvvFTSE6S+iaTUISMaGhORXCR1OWNPP1PPwhTFdRQa8TLkSK3wHHOCEdU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(8676002)(54906003)(4326008)(8936002)(5660300002)(478600001)(316002)(83380400001)(1076003)(26005)(53546011)(426003)(2616005)(66946007)(33656002)(9786002)(66556008)(38100700002)(2906002)(66476007)(9746002)(6916009)(7416002)(86362001)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MB3dVECLvC9plXG6YTV8lGPdnvag3DwJGN1t2V3Y2xmHECOTG/fSQ3qkth6s?=
 =?us-ascii?Q?Q4UwGvmBv5bEpkty3+tReQSlaqQw1BoknwcsR8oiUvHh6cSNAa79nClMHY7V?=
 =?us-ascii?Q?Gf3mNMKX0gb2DFt85eI5AyCw09oPtPgLVWxO4qVZxJvxIHXTVsGTWXfF+W/3?=
 =?us-ascii?Q?dsWTvIodXBLzv6lGnddMP9KVmMg+mh+aS2GbVio/Jfl6sQfJ6tsHXFgEPejO?=
 =?us-ascii?Q?VJLrtJum9sWL0YbAIHNcEDWpCUYuVrZjrk3xX30VTMJwUqFbtW5xsh/AMk5i?=
 =?us-ascii?Q?RYZElv7r0n+4edfiRBFCSmTcTuOQuFWfjw/7HgUZwPmnfIsXag+rTaZNcxa6?=
 =?us-ascii?Q?mneBE01DZvWQicqeqXF4Dev+/bogXDaIaeScDJqSTspWS9W8lCASVK40Akmu?=
 =?us-ascii?Q?JXIrhJiWvhSGNkS0noIPlKN5Rp2idWhVS02/204mlnEhEt2lFwMXlQUu7RQO?=
 =?us-ascii?Q?SlpuA8CHV3EJ3vXZ/T78DzFLswDVCldo8wjzeb94C82QIeZ8lLZpKaC+CHLs?=
 =?us-ascii?Q?XG6YOIS0SURQE9XIlE9i/c7OcvslWQF77ybeO2z6GkjsqyhxYBfH+j+eFqVE?=
 =?us-ascii?Q?5OQXu73t9/rgD/Y7DwLZvduO1ixI3CO+mV/7Y5Tq+DuVbPLwFgBe/OQfo1LW?=
 =?us-ascii?Q?3asBF0PUHsYdZESkLqnFhRNpyVgX3HSp2KNXvJEWrnly63sLnjTDJS2wmWXK?=
 =?us-ascii?Q?El8sgEOGscyNLGJPn9809e8YPfqZL2KXTtTDXPlG5MbqaSDTbWGoQY1IJ+Te?=
 =?us-ascii?Q?MbXs9d20vg3Mv18ji9+qYgcsgDdRlMS+njzsviKOIgmU36DbRX93axP0ecoE?=
 =?us-ascii?Q?NjIIL0G9Q7M4p8nfefMxWMmFhW7FDzpb73qXcUU4SiHEcD0G4tyAN+RxY+4C?=
 =?us-ascii?Q?RowwvqMwyVyemGNb4Zd+TrbfrZ0ekMUbnE+mgWaZHippIAL2YjWnN+CBbXmN?=
 =?us-ascii?Q?1XI0IkpZS4M5IwQL8EJHnETJKJa5CDo2XMxgecq4sDS1Nd8utmhhAZAL46Ub?=
 =?us-ascii?Q?el0XHTP6n3EeLeb0mV9qIEI3nUA60d9RqRtHXPeBEBk56/srhCnZVNZYA8tm?=
 =?us-ascii?Q?aUKbhCl/U7L+jl3WqTJHOuD6xKUIUgrlAfrzBf1MpF+EdqJJPILfZNUgDrRV?=
 =?us-ascii?Q?t7ozyDAhZj8hlZaFApPP40VmRug/NRLXbddbj+6uTcDW6YqWPvjahh1w1r0e?=
 =?us-ascii?Q?CEuTRKoU9nJuSm5iF5t5anoi/8Wb1oc5+2slCLjjplxDY3RgTYLIrNg1Ipmg?=
 =?us-ascii?Q?AlQFV7b5SsBVBWvAIaA2TcWfdAnJIVLqaYltS1rsDGUesINGqp2aupEBNu61?=
 =?us-ascii?Q?hbFkQJ+6YcvMRa1I6R2iX4Fc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c998a804-b8c3-4c54-0d12-08d9277073c3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 15:50:18.2893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: amEQUkaSOsgHiYnPrG7R8rZTKTKnHbo4wcmuDflpiIivLeZNEycd8iXkEqJfEwDW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5380
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 04, 2021 at 05:40:34PM +0200, Paolo Bonzini wrote:
> On 04/06/21 17:26, Alex Williamson wrote:
> > Let's make sure the KVM folks are part of this decision; a re-cap for
> > them, KVM currently automatically enables wbinvd emulation when
> > potentially non-coherent devices are present which is determined solely
> > based on the IOMMU's (or platform's, as exposed via the IOMMU) ability
> > to essentially force no-snoop transactions from a device to be cache
> > coherent.  This synchronization is triggered via the kvm-vfio device,
> > where QEMU creates the device and adds/removes vfio group fd
> > descriptors as an additionally layer to prevent the user from enabling
> > wbinvd emulation on a whim.
> > 
> > IIRC, this latter association was considered a security/DoS issue to
> > prevent a malicious guest/userspace from creating a disproportionate
> > system load.
> > 
> > Where would KVM stand on allowing more direct userspace control of
> > wbinvd behavior?  Would arbitrary control be acceptable or should we
> > continue to require it only in association to a device requiring it for
> > correct operation.
> 
> Extending the scenarios where WBINVD is not a nop is not a problem for me.
> If possible I wouldn't mind keeping the existing kvm-vfio connection via the
> device, if only because then the decision remains in the VFIO camp (whose
> judgment I trust more than mine on this kind of issue).

Really the question to answer is what "security proof" do you want
before the wbinvd can be enabled

 1) User has access to a device that can issue no-snoop TLPS
 2) User has access to an IOMMU that can not block no-snoop (today)
 3) Require CAP_SYS_RAW_IO
 4) Anyone

#1 is an improvement because it allows userspace to enable wbinvd and
no-snoop optimizations based on user choice

#2 is where we are today and wbinvd effectively becomes a fixed
platform choice. Userspace has no say

#3 is "there is a problem, but not so serious, root is powerful
   enough to override"

#4 is "there is no problem here"

Jason
