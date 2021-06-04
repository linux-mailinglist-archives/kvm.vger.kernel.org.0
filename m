Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9708139C3A0
	for <lists+kvm@lfdr.de>; Sat,  5 Jun 2021 01:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhFDXC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 19:02:58 -0400
Received: from mail-co1nam11on2062.outbound.protection.outlook.com ([40.107.220.62]:12706
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229853AbhFDXC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 19:02:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B1jy2p1g+RJHk7Hlp3zcnnm4vIs/jcTd9V58jeio0XoIHbvPxgMtxShiIHStlc1gFnmTB7xMnWWl2BKfbTpK8ixlxqsjEI002+EVBuDqtrDMi30GT/ti/3U31sszuxnYQpQMsK/xP26g/25SyNR54Wrr4Dg0Gpw1ceak2i024zXyiNy2jc/0JEUqPaFAMBicdaqKjI7Lnx5+6FX9EnGz2Axg6yIR9RX03Zex74Nw5bP4+jnV6eRImzcXPwVozbotx6XPQWjjdDcbsR/SctdWfnCVqh8CqKf9tBzZghHg576ngmtb5mGqYToDDBWDqNMnJxxyuTVG2nuH3WyIE1F7fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fASiwXOMy0+Ki9g5yOtr++3eD9GR3Oh7W1EhjgjLXM=;
 b=junJQmqHWLZHdQRP8L9MLA5RyPS/JalSop7RhUIEWaqNe7bZ9eaTVcJFghtME9sGGXw6/hwMZhOC7wUcG8JSnWEosfeiyfTh+/LkdGXgJDjLufDYyir8ESk76RAu8l6NycsTnv3FZ/KsTa4R7E0IA9Z7vWj4WqT4R6B8LbVrWK5Y53tY/bKw9iWUTtOB5xPsCn1E9J6GJIS5finwmfw8BTxrwG82pOiE0SqgIxBv7fEUv2Y6atG9EqkLuX+zB2yA1vhLEQY0rRELDYql9QXAL2O8jDC41GsM4UG2lpIv5NWJoGmJhyAt8TNwIUJwTfYoFWD1h5bBPaMCNJDwnvMncw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fASiwXOMy0+Ki9g5yOtr++3eD9GR3Oh7W1EhjgjLXM=;
 b=s6DHmAIjauYSBVCdUICB96Ih1mhWEC47HV2pqalQQh6Le1z4cjEruGp0a+UcZA8dZSArXfcmOcNcRGvd68byaPNpCd3jeFwPNDGAFhOT2AhjzXQgo9cbwAOibMjgyzau5MCyhaX0c9VGlHhGvRLQjNfYIRIkCq/QL5+JhcG+scemnrp2X5QxLAXi2GlyoXplHnELk9gXbyaTEzv63lhRy5jH223pLG85QWGZ9NfYawQmMy89V8GW3rdlUaX7MpTShOJ6WZDK17Cj+Dy2DR/W7EkxTKEGfKeX4UhWHq6RkZkR5R2HvXYIra7jfBnVJsz8WVADLarZr6lojXjMwjsSZA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5539.namprd12.prod.outlook.com (2603:10b6:208:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Fri, 4 Jun
 2021 23:01:09 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 23:01:09 +0000
Date:   Fri, 4 Jun 2021 20:01:08 -0300
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
Message-ID: <20210604230108.GB1002214@nvidia.com>
References: <MWHPR11MB1886469C0136C6523AB158B68C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210604122830.GK1002214@nvidia.com>
 <20210604092620.16aaf5db.alex.williamson@redhat.com>
 <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
 <20210604155016.GR1002214@nvidia.com>
 <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
 <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <20210604152918.57d0d369.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604152918.57d0d369.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0432.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::17) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0432.namprd13.prod.outlook.com (2603:10b6:208:2c3::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.12 via Frontend Transport; Fri, 4 Jun 2021 23:01:09 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lpIoO-002Ga6-9s; Fri, 04 Jun 2021 20:01:08 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c693f1b-0324-4f44-779a-08d927aca41f
X-MS-TrafficTypeDiagnostic: BL0PR12MB5539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB553983AAD65C59D64FCB237EC23B9@BL0PR12MB5539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g/fmGEs6YVVqLsEQNhqRct7A1fKnJc5sGqi8EcIpBf5chsaCt/rsljX+2z6JMvPoKG+KTRmzxzhHiKiG8pL262ZNDsi5DHLCQle+McF/d2W6K3uXMAxX+P1GVN/8uMJYmGCOd5Mdws0bILDLcysd2Sk3ciUHwdLwCSt5klKnWc+xbBu9wn277qBoNlsSRouHWadJsagLFScf29O3yWE9DiJ5fO6rYVGfh//r3GnMdsij+ZJJfH7tveq9RIuppMZ48UUCx/LnU+vx7KHSbA9i4qiHVu9Nm5UxsXQV75s8yIuz/T9k6cp7MqUF1hw1qy2Nn/lBiMAwRu9MYVCZ2fiqi5pREkNPKZWpgGe8C99q5JajqydEum0r6PyrInktODTorSBZrTWNfgfZt41m0Nm7/m9ikcKjcIoe6izf4Xaq+1Gnlj8HjpzV2w22sJHgRDb4xbWGUiEzpbpzBOgFBO251XrtwCf1hVrQR8h/hCSE0WEOzMsB14KquPoIqZKt4o/fOfadNQ779II48SRHrsvagZMt0L61ocnzAEOkyo/QRmKxO0XVK7qMUO7tAZBXHLMQsn8Ir7DDTafJF7l832LLMRqG7X+g4s4ctvqtvY+30fI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(426003)(38100700002)(2616005)(1076003)(86362001)(83380400001)(66946007)(66556008)(36756003)(5660300002)(8676002)(66476007)(54906003)(8936002)(26005)(316002)(9786002)(186003)(33656002)(7416002)(53546011)(6916009)(2906002)(478600001)(9746002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uhjqEedV+lXfOXS3NOHNYpYO6gsxg9Tu98SU/2jMTRBh3TPSuLzKJQZ+tHH9?=
 =?us-ascii?Q?uYsqhVfyjvQsUY4dQn6ehTAyBaTUJFxlX5moFr+3V1/XBsc9Pd87vyU/g0kO?=
 =?us-ascii?Q?nvEeehmGgpnAQYIqcwT0UQkdp4vfL3zKvJ38+cYx8egbVcmg50rzXYfedPHT?=
 =?us-ascii?Q?XRSYKt2cafqmLSMJMsgjmELJudpX8aNqyun/EM8t6wJbeXIOxHjA3+uWr1Il?=
 =?us-ascii?Q?Yvf4vYiBlLBunwKbcIYjkQvp5+oumZt/2sQu8ZulKRiUgBDjma3RKBUdx/vr?=
 =?us-ascii?Q?7vDbokFD2FmQrfCqhSQRX7WusKREf4m72AGeiIkbIo/e+CLYg+Jt6iEjyATt?=
 =?us-ascii?Q?iQa91GCgOIPmpJjvkUuwm0Q0BLHbumQ0oeYNV22b329iGNCNRmUd29JeHNgY?=
 =?us-ascii?Q?54kU/5bUthJUU0aX6+8zNYBdIFBDWAGLU1JUe/aTWEYKIsFeFWgPk4c0n7xc?=
 =?us-ascii?Q?u2TGDG6kkZ+KLs0tMxqUwR8kUkt+fPpnP+FJAWWijSs4KVjy2NCzrgKn0hSP?=
 =?us-ascii?Q?4SNjSJGyeI0GryDdh2vOLJ7A5hwx0kgoRABjXBzNTIE/3U0uEDPzpECIrMNQ?=
 =?us-ascii?Q?otTj97oWWTjMB9OEJLwA6AUaF3JFN4P6kGXa+wG0HfQ0LNKzHAyQH9uoVj1O?=
 =?us-ascii?Q?JIlNd8Ey0hRfwJ64iGNl2CjpWrw86ScNJruBw38IfxzR5KsglupnR1pf4V6F?=
 =?us-ascii?Q?uzOAqEMkj8g/2j8m7wMcUMA6N+Jp8rAQ+Y506vG7YkJw2OSlhTyd5+efkE64?=
 =?us-ascii?Q?Tj7Db8wrj5ZCKJFDjLJsdnxSiAN+M5kgnpIFHmoQJc+gHlfy0Cw4yyeBcdzt?=
 =?us-ascii?Q?UlRJYmQRhfp7CZUdW56iEMz7lKd2zL9nKBOVqCG8YN10TxQuhDLGLO8N0X5j?=
 =?us-ascii?Q?+BHI1ZgqaUwmq9CfgOCTtJUptiN4uansPP+NPnb7yNqsx6ibfZXK6yDswXOz?=
 =?us-ascii?Q?aDrYR8SDntDT0BrL5NXhEa+416fgsPQ3t7Zdj3dv+pNI9DsgzjEEpg24cbJ4?=
 =?us-ascii?Q?/WQAdy74I+SEgCOxfwUwSkzGmhwKQx4xB3+3k5mdkQOkYERkAOjTmZLIC/6X?=
 =?us-ascii?Q?HhSQgGrjJ9DUOkd5IOoGBwdfEwxKHXZNrsB1zsjQJY0mj/eiZaXwpz+yUbk4?=
 =?us-ascii?Q?ZPF+9Qdyoyk9Me5K168XpGcxRYpd95Q9GMi0fx65U0NDjVjMg0mJ27PRY7Uf?=
 =?us-ascii?Q?zvVST5pG3TZdRor/MLKQFG9t+04zsy50toDU66v56Rpu4NVxDjm1sBUHQTCV?=
 =?us-ascii?Q?UNgynLziEyhCgmCqQ28VJonroDLBKJLRdG3bZyYrxhMKQ/bUszAVgak2ALcZ?=
 =?us-ascii?Q?07X2WN26pvSkTHiJx0xCUjME?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c693f1b-0324-4f44-779a-08d927aca41f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 23:01:09.2632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CR8pmzjgzV4s4FzNZrx4trzTCvUuM9EkeVIWVEXDg9cJekJ6bSds1sZ3U+X/Vazx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5539
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 04, 2021 at 03:29:18PM -0600, Alex Williamson wrote:
> On Fri, 4 Jun 2021 14:22:07 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Fri, Jun 04, 2021 at 06:10:51PM +0200, Paolo Bonzini wrote:
> > > On 04/06/21 18:03, Jason Gunthorpe wrote:  
> > > > On Fri, Jun 04, 2021 at 05:57:19PM +0200, Paolo Bonzini wrote:  
> > > > > I don't want a security proof myself; I want to trust VFIO to make the right
> > > > > judgment and I'm happy to defer to it (via the KVM-VFIO device).
> > > > > 
> > > > > Given how KVM is just a device driver inside Linux, VMs should be a slightly
> > > > > more roundabout way to do stuff that is accessible to bare metal; not a way
> > > > > to gain extra privilege.  
> > > > 
> > > > Okay, fine, lets turn the question on its head then.
> > > > 
> > > > VFIO should provide a IOCTL VFIO_EXECUTE_WBINVD so that userspace VFIO
> > > > application can make use of no-snoop optimizations. The ability of KVM
> > > > to execute wbinvd should be tied to the ability of that IOCTL to run
> > > > in a normal process context.
> > > > 
> > > > So, under what conditions do we want to allow VFIO to giave a process
> > > > elevated access to the CPU:  
> > > 
> > > Ok, I would definitely not want to tie it *only* to CAP_SYS_RAWIO (i.e.
> > > #2+#3 would be worse than what we have today), but IIUC the proposal (was it
> > > yours or Kevin's?) was to keep #2 and add #1 with an enable/disable ioctl,
> > > which then would be on VFIO and not on KVM.    
> > 
> > At the end of the day we need an ioctl with two arguments:
> >  - The 'security proof' FD (ie /dev/vfio/XX, or /dev/ioasid, or whatever)
> >  - The KVM FD to control wbinvd support on
> > 
> > Philosophically it doesn't matter too much which subsystem that ioctl
> > lives, but we have these obnoxious cross module dependencies to
> > consider.. 
> > 
> > Framing the question, as you have, to be about the process, I think
> > explains why KVM doesn't really care what is decided, so long as the
> > process and the VM have equivalent rights.
> > 
> > Alex, how about a more fleshed out suggestion:
> > 
> >  1) When the device is attached to the IOASID via VFIO_ATTACH_IOASID
> >     it communicates its no-snoop configuration:
> 
> Communicates to whom?

To the /dev/iommu FD which will have to maintain a list of devices
attached to it internally.

> >      - 0 enable, allow WBINVD
> >      - 1 automatic disable, block WBINVD if the platform
> >        IOMMU can police it (what we do today)
> >      - 2 force disable, do not allow BINVD ever
> 
> The only thing we know about the device is whether or not Enable
> No-snoop is hard wired to zero, ie. it either can't generate no-snoop
> TLPs ("coherent-only") or it might ("assumed non-coherent").  

Here I am outlining the choice an also imagining we might want an
admin knob to select the three.

> If we're putting the policy decision in the hands of userspace they
> should have access to wbinvd if they own a device that is assumed
> non-coherent AND it's attached to an IOMMU (page table) that is not
> blocking no-snoop (a "non-coherent IOASID").

There are two parts here, like Paolo was leading too. If the process
has access to WBINVD and then if such an allowed process tells KVM to
turn on WBINVD in the guest.

If the process has a device and it has a way to create a non-coherent
IOASID, then that process has access to WBINVD.

For security it doesn't matter if the process actually creates the
non-coherent IOASID or not. An attacker will simply do the steps that
give access to WBINVD.

The important detail is that access to WBINVD does not compell the
process to tell KVM to turn on WBINVD. So a qemu with access to WBINVD
can still choose to create a secure guest by always using IOMMU_CACHE
in its page tables and not asking KVM to enable WBINVD.

This propsal shifts this policy decision from the kernel to userspace.
qemu is responsible to determine if KVM should enable wbinvd or not
based on if it was able to create IOASID's with IOMMU_CACHE.

> Conversely, a user could create a non-coherent IOASID and attach any
> device to it, regardless of IOMMU backing capabilities.  Only if an
> assumed non-coherent device is attached would the wbinvd be allowed.

Right, this is exactly the point. Since the user gets to pick if the
IOASID is coherent or not then an attacker can always reach WBINVD
using only the device FD. Additional checks don't add to the security
of the process.

The additional checks you are describing add to the security of the
guest, however qemu is capable of doing them without more help from the
kernel.

It is the strenth of Paolo's model that KVM should not be able to do
optionally less, not more than the process itself can do.

> > It is pretty simple from a /dev/ioasid perpsective, covers todays
> > compat requirement, gives some future option to allow the no-snoop
> > optimization, and gives a new option for qemu to totally block wbinvd
> > no matter what.
> 
> What do you imagine is the use case for totally blocking wbinvd? 

If wbinvd is really security important then an operator should endevor
to turn it off. It can be safely turned off if the operator
understands the SRIOV devices they are using. ie if you are only using
mlx5 or a nvme then force it off and be secure, regardless of the
platform capability.

Jason
