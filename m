Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3680339BE8C
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhFDRX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:23:57 -0400
Received: from mail-bn8nam11on2058.outbound.protection.outlook.com ([40.107.236.58]:4449
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229675AbhFDRX4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:23:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OivIECnRZx7L5hidVPuI7O6IJbsJm6uTISf00auvCTnFVboxn8Hb5Z2I7r/L4RYtEKf8PXlTuVSU+pb1/h498E7VWT+pddSG1BP7vZl+UkxPp2lx1pWSPAiQTaDUCdeT3RqYnh8lz8X8GfCRyIk6uOAloGjLhD9An8Xo9tqIPsspLyoiz+bcxYPf78GnX+PVY4HiGHmApwn75yhMQ96rHteIkfskcnZxuOy29v4z6Zk1H7EVnrsM00FWb0I4XBjJvWtJ8FHJ88mlSLXIZwBS3CWDFGeiNnocgdPz6n6mgRv+Jjszfzcw3/zrcHTgR1KG4ogavY1k4Ucie3QlXwjGfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCyH/0zz9hxT6Ak2VCMJeBgWPNLqosG0jZISCbP6zrM=;
 b=BNnmCRPLPbFMdsmYdT7lwAkGADD+KWlZmGQ4/sawHxp76iPP2ASOt+Yyh3mig9vjW/RaJwI2yI2InAoAy1h8+JYJDhdrV/hDlzHe76hpT0ufvPhbpZI7Wj5MllMcZ/4rzoD1iXDsQNspZ7uvMX/22xq/gCspvsOTiIsjrjzGlZdHT++byzGH2Ib/O6m/f5mhc8DBdsPboU96UX2AuERneg0J+NkOhO8TsQ6ApPe1HPqi6vQIxL1WuvLD/yn3fX9LqPuxIVsaIBus9uQzRNI4mLlUFiCn1lTEMna/MVRABqUrMtHcgaGjkwZThAXzo6wjqYuUmkgKJU8g4pIgd+6MtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCyH/0zz9hxT6Ak2VCMJeBgWPNLqosG0jZISCbP6zrM=;
 b=ER4YCcqmCGB//UVvFgH2l2ZCArSw/nZ7CWT4lSvUSwyVG3f7IwAzGlaMJazxzaDQuwuYR6HvRFOgrnRrT8c7yKUhvv9ZMfaE+zQ0phZNBTF2eDJmCNp7B76n/ljifJc5+cHwCl+6O07YMydmFTMF7uEUZQhStkDDX9JR/AzZ96uOCtsODsoPV24is0s23XJrz6wEWh+K667n/P2dcL2/kfA186iLNtmea0FSf/RqKnHDKJOUWmN8FdMwhDTCf+X3qU8jAwOiubFGDGB959OfLp5KAKhkYpSipmrpIdhWLJNpmCc5rswYP2ZICWMEJ9tnXxBXmuPs7nTKn2/jbMO5Tg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5269.namprd12.prod.outlook.com (2603:10b6:208:30b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Fri, 4 Jun
 2021 17:22:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 17:22:08 +0000
Date:   Fri, 4 Jun 2021 14:22:07 -0300
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
Message-ID: <20210604172207.GT1002214@nvidia.com>
References: <20210603201018.GF1002214@nvidia.com>
 <20210603154407.6fe33880.alex.williamson@redhat.com>
 <MWHPR11MB1886469C0136C6523AB158B68C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210604122830.GK1002214@nvidia.com>
 <20210604092620.16aaf5db.alex.williamson@redhat.com>
 <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
 <20210604155016.GR1002214@nvidia.com>
 <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
 <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR02CA0057.namprd02.prod.outlook.com
 (2603:10b6:207:3d::34) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR02CA0057.namprd02.prod.outlook.com (2603:10b6:207:3d::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Fri, 4 Jun 2021 17:22:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lpDWJ-001liB-Jt; Fri, 04 Jun 2021 14:22:07 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 620ee070-9405-4a52-71ee-08d9277d483c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5269:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5269C14D2CDD76ED4090FFC4C23B9@BL1PR12MB5269.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0mnauDbJ6KnVnuCWGbJlELLI3isnWntFp5RexKKdyI/fZAnBVR1TY75/ppVRxKw7RWu+tJNz11AtYKBOAvMtjDhtgB6E/b0cURPvBQ8rgfzyfiLic6bvUP4M9vtYe5VTLO1A94hJLm9jnA6gODV7iwMgQPb8cquGQNHRqop3jTtMGZLVk6opBXEEgLYawgn3wTNUGoaxOE27rh5G0fZHJAwyGbnikKkJaLm32ImXFU/4rpkaMzvJVzquOvWlESB10VyMVOnkW1z8qIgwYqN60UbWzYahxrWay3NlFWpTAuDgTm9L0wyFkM7IfJYNbsei0j9WKv6980c49QBCtCMo39iZkOwShCE1HPUDnOlGIYj3rSi0g1UjtI7i2/aUgDB9HNGxJtwdNGZ5Q3Tw3qU5qWeSt9mJAy/DelyuUqttbvUOxqmwaWUacoHIVm7wTlPZy2IpjJ0gCxTDAS8PNVxnaTv2rNrbPe9QyDBPMcSkyGO5wDNSQUOiWjjofZnCd/iTfwy2P8DqkEVbzvWE+5FRSb3kBSKzFMC1/GPXoZ9bT9Oh/8RD6iOSzpufzsOmQ/BSlOTd7prPF+zKyjMT1H3zgZKbbcJcFAa04nAR1ps90Qg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(54906003)(1076003)(38100700002)(426003)(66556008)(66476007)(4326008)(5660300002)(186003)(66946007)(316002)(53546011)(478600001)(26005)(6916009)(36756003)(86362001)(9786002)(7416002)(9746002)(83380400001)(8676002)(2906002)(2616005)(33656002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YE/ZarSi3clbZWc4AHwHYODFCdLDJBm5Nles3SZOgIm515LeUNfESPFsi5uT?=
 =?us-ascii?Q?Tj9Qa5hdggK+r5Nr22pIeRn+JATGo0BxueKVXvrKfATiXZ3YCNfkAG1m8Bkw?=
 =?us-ascii?Q?1BoXZtdHP9h3eo8DrSdZh9PL1jLYVcXoIyEFc7SYUpI7BSYFWcgdK4nYMRet?=
 =?us-ascii?Q?D/iRZGpfnnr4SgFZpzMJUCqJ5tNfEpJSb71gjJyvLQDJt9Ufa7nd8mcHDFSF?=
 =?us-ascii?Q?Orw/XyW6lHonGwNvP49371gTcYwjfmPSImA4AIhEYL0n/hJ0E3cx7qZEQNlj?=
 =?us-ascii?Q?oxLiVwfSqMUASLRikfMz6if1YvJLstH4OcsCIiiylpUSWmKfyGft2RQaQGN9?=
 =?us-ascii?Q?PsHnAitiUeX879/HIreIeco4KsEaNFMl4QWqe2FtAtXYfeIJ+og8kQvYm0lR?=
 =?us-ascii?Q?1gQ1Hp2I3Qh+g3jJUxfTP4nLUaPAG+4wFrzQP63I3TUvCqk3YJ28ToJrhP+D?=
 =?us-ascii?Q?U/pG4sfyHdhQHNbohsOHNMug8cYoA/XXuzLBPXGn6I1doMVKfeApOYZq1d87?=
 =?us-ascii?Q?mseZfKE8XVKEXHnS/+fGE4q4HoUzd/GC961hBPR7MTvdWp4jl/ZTalt4645P?=
 =?us-ascii?Q?uezuD5hEuTXQrtgqS+gcWZAtKzN5RAmzGvPMnSkmU4bGbeCmPicFIRHIecQk?=
 =?us-ascii?Q?Zkfyk+COTQbtmrwv1Zxvef9k5CUMeGcm9afeY9xrrrkT97LelpvKj0Cy/UMz?=
 =?us-ascii?Q?qwekNr7z7Yuo1oJ8jHS3t9znkW9pGICFR2tU9PE7Ic5f1PrPtmAqALyQIY5+?=
 =?us-ascii?Q?zY6S6qpT9r7ABjtgVF9eIcRqu2SFR/C7S1m/gi8J2fgoVPN3qoiN19xUy/bp?=
 =?us-ascii?Q?/Yqs+m9BgeMWS7WdaHoZ37M9M4lt3Ww+HwhmcNXqFN6gDGXoHw9rU9/uGfXZ?=
 =?us-ascii?Q?JUO5UiBaer7GeBSVlT0UqD0+ZK9Y2Nj1q/eGvr1HUiKKS5L+tOfdRhB58NfO?=
 =?us-ascii?Q?v61kXRPJ9EoiC+jRgmz3RPNDwLX6eJRM98od6CDauNguipo/LMJP9KN7XaJd?=
 =?us-ascii?Q?/atPyiktx6VSiZOkcZhKi2VTowC8KlMnDh7BwhXZnyXO+65QmDTdHPlwgDEj?=
 =?us-ascii?Q?1ENQL9ku2aR9IUKQ2l9Yfdq2uabfdowR8lwS66eXcSBCV7O+21mWDjgKE1DQ?=
 =?us-ascii?Q?p8VDNnfykCkMzZGhTcLFr0MKQPiRorp3VKy6lYbCaoGMu25WcFG8+p2A6biK?=
 =?us-ascii?Q?PBEGWSW3ULDQFNao5ndclumk9fpx/12BSlJuMyUZWadzS+ygviW7MTJq9fl9?=
 =?us-ascii?Q?12RIxuHJnoIQH5oK96hwn4G3mlYi0dzip6+/AlxSQvm+N93yviK94eSvbTtt?=
 =?us-ascii?Q?EtqbaBS0i7trUfJ3+uiMEexQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 620ee070-9405-4a52-71ee-08d9277d483c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 17:22:08.7306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wMuK0vTK1MrIC75I5tQZkEebS9jAKNa7CEwFQPKXtQ5LzWuJ8yWtFLJmt4i92H1d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5269
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 04, 2021 at 06:10:51PM +0200, Paolo Bonzini wrote:
> On 04/06/21 18:03, Jason Gunthorpe wrote:
> > On Fri, Jun 04, 2021 at 05:57:19PM +0200, Paolo Bonzini wrote:
> > > I don't want a security proof myself; I want to trust VFIO to make the right
> > > judgment and I'm happy to defer to it (via the KVM-VFIO device).
> > > 
> > > Given how KVM is just a device driver inside Linux, VMs should be a slightly
> > > more roundabout way to do stuff that is accessible to bare metal; not a way
> > > to gain extra privilege.
> > 
> > Okay, fine, lets turn the question on its head then.
> > 
> > VFIO should provide a IOCTL VFIO_EXECUTE_WBINVD so that userspace VFIO
> > application can make use of no-snoop optimizations. The ability of KVM
> > to execute wbinvd should be tied to the ability of that IOCTL to run
> > in a normal process context.
> > 
> > So, under what conditions do we want to allow VFIO to giave a process
> > elevated access to the CPU:
> 
> Ok, I would definitely not want to tie it *only* to CAP_SYS_RAWIO (i.e.
> #2+#3 would be worse than what we have today), but IIUC the proposal (was it
> yours or Kevin's?) was to keep #2 and add #1 with an enable/disable ioctl,
> which then would be on VFIO and not on KVM.  

At the end of the day we need an ioctl with two arguments:
 - The 'security proof' FD (ie /dev/vfio/XX, or /dev/ioasid, or whatever)
 - The KVM FD to control wbinvd support on

Philosophically it doesn't matter too much which subsystem that ioctl
lives, but we have these obnoxious cross module dependencies to
consider.. 

Framing the question, as you have, to be about the process, I think
explains why KVM doesn't really care what is decided, so long as the
process and the VM have equivalent rights.

Alex, how about a more fleshed out suggestion:

 1) When the device is attached to the IOASID via VFIO_ATTACH_IOASID
    it communicates its no-snoop configuration:
     - 0 enable, allow WBINVD
     - 1 automatic disable, block WBINVD if the platform
       IOMMU can police it (what we do today)
     - 2 force disable, do not allow BINVD ever

    vfio_pci may want to take this from an admin configuration knob
    someplace. It allows the admin to customize if they want.

    If we can figure out a way to autodetect 2 from vfio_pci, all the
    better

 2) There is some IOMMU_EXECUTE_WBINVD IOCTL that allows userspace
    to access wbinvd so it can make use of the no snoop optimization.

    wbinvd is allowed when:
      - A device is joined with mode #0
      - A device is joined with mode #1 and the IOMMU cannot block
        no-snoop (today)

 3) The IOASID's don't care about this at all. If IOMMU_EXECUTE_WBINVD
    is blocked and userspace doesn't request to block no-snoop in the
    IOASID then it is a userspace error.

 4) The KVM interface is the very simple enable/disable WBINVD.
    Possessing a FD that can do IOMMU_EXECUTE_WBINVD is required
    to enable WBINVD at KVM.

It is pretty simple from a /dev/ioasid perpsective, covers todays
compat requirement, gives some future option to allow the no-snoop
optimization, and gives a new option for qemu to totally block wbinvd
no matter what.

Jason
