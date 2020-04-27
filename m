Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C085E1BA308
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 13:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgD0L62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 07:58:28 -0400
Received: from mail-db8eur05on2081.outbound.protection.outlook.com ([40.107.20.81]:63058
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726260AbgD0L62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 07:58:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dp9TaPUA8GrUXoToSedBImmvsL/wax2liMz6kq6PgFQrfDn1eImnM9ucx7EYbGu4cikeKAC0oR14thAOHW26J5eQI+uSEK8Eb0mMq86n+NHWhwUHTgYT8okdJ8PWn9Gu7rAd+8BwulHc3CkoVQkz1q3oOVilbG/Y/k5c13IZLnuqvZ4Ogkr9mjNss5D709/hZtUUky8Tgb3JXMqX+HrA26Xqt8VbNHDEnzM5sWuZ57c/lvn1+hrckdWZ+G09ZAjxde00hmCASHTlcWJjeeqjFV7ILHwFJoQ3NJc62s5CP25vobek5x1Qhp0ttNXCnOTwIAfl8ZfTaWJQ7r+xmroa2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiXxLaXL+jb45eK3DQwWfDBXKdHvPmQe0PcqPs8E2sk=;
 b=JtoENfCf+yfV3AUTB0IgFfTHEWFBYgDaKx16VUraFc58TA8MW6hSv5jar+rS+cycDxMxFW8C4lCG3+UW9aAOPOGm/p6UHokpJNPY/Tzp8BWhpBW6qpebksA5A7wDqWRvglQa13ucSI0pB+Is9GY6z07yrivxkty6Er7iU+Ux4PTjnhnEdWmB78OFFoeh/jO591N2yPo6RVFog2dulnhgaQ+QFpptzQZwZu9DQxICmdEdUGyS4Tx8ulAmZMrHUyYv7YQ8LqE2RuttSsNwMlPKTsh4wH55Rfq3RJaK1F17bAop6NaQdLczKYYVxSnTgidwYNoVxOydyhOXR26qWVl9Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiXxLaXL+jb45eK3DQwWfDBXKdHvPmQe0PcqPs8E2sk=;
 b=CASQ7H+ktYlgF68HTzEDUfBoejvLbNmk+ZKMoswH2QEXrsGCL/p0qBNygKJUOyl0XqWBmA6ap+ULw65YlysyXXwADur6Jp2HhXNFcmWQivZZgKqeenhxqmAFV/iA3oD+Wy4V9qC6xxxIjCV6WERa3Zp/58ubcmYvbfjvrkrkQdI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4767.eurprd05.prod.outlook.com (2603:10a6:802:68::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 11:58:23 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 11:58:23 +0000
Date:   Mon, 27 Apr 2020 08:58:18 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200427115818.GE13640@mellanox.com>
References: <20200422115017.GQ11945@mellanox.com>
 <20200422211436.GA103345@otc-nc-03>
 <20200423191217.GD13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8960F9@SHSMSX104.ccr.corp.intel.com>
 <20200424124444.GJ13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
 <20200424181203.GU13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
 <20200426191357.GB13640@mellanox.com>
 <20200426214355.29e19d33@x1.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426214355.29e19d33@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR11CA0007.namprd11.prod.outlook.com
 (2603:10b6:208:23b::12) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR11CA0007.namprd11.prod.outlook.com (2603:10b6:208:23b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 11:58:22 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jT2Ow-0002tk-P8; Mon, 27 Apr 2020 08:58:18 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1c132dfe-547f-4f82-eed9-08d7eaa248c2
X-MS-TrafficTypeDiagnostic: VI1PR05MB4767:|VI1PR05MB4767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4767489B576EDA22CBF992E0CFAF0@VI1PR05MB4767.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(52116002)(81156014)(66556008)(66476007)(33656002)(8936002)(6916009)(8676002)(1076003)(316002)(86362001)(66946007)(36756003)(186003)(9746002)(9786002)(26005)(2616005)(7416002)(2906002)(4326008)(54906003)(478600001)(5660300002)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ojPqI2igDFJy4KAHVZWahYAxkpbelRUIBPRpCyabDhWgY+5JhJS2n4prKqhBCHrLwDlljRbn/+190yQmbsp+hv145otb6bLdi0lxQJCNyldYuPvBkqxxUZlWGI6N6Be+eMhvvZ9e4BKzs/w94ymB7bT7v/EL53zzb/cyrKNDGIYfxrdAlOOzMAjdt/4HI/19y/SVmYKYNhob1KjEAEjZ926IYG9H0L/LjyGCr+CjMG+cXvTas2dO4Wm5nE+LTAFJvUrTPJwpb4yNytPu6HT7Tzm/9G6PqxTt4PkULginCeDlUyXPThlLbiwfbwLfrvuHq8rpmc0ud7gn0LDjobuPWbhLn4ww1ailO3RPUlV0gvgKqvH9apIfH8RF/zMSpKaWFyPFp4LTkf3cZkYr/oTvZfePEOmI0Ov8tBXYMZCgRgADdMUL0v4rfRYWZIfCWzNvrG9G5HX+ZOeRsf3m13vkyacAMDqfR66WUt9WKrPfRScUneUWn0KBT5YY+jFGNgA
X-MS-Exchange-AntiSpam-MessageData: uOp4EP9LzO1mHhHvfKE0KYe4xuERzWb3yBwD8pfrlgjWVRnBDl5fZr5OrciUdU1eBGpYYPfABUtG6g00kV2negSGKtl6znGpRomtThJONq3mNy+FZY/Zimg8i/ExBjwE2KGcg1Jhmrru6t3x7MZZUsZXNxaIxwI46XWZTHGV/V3AtVMJr+VRsePgeMoe9HI49mkfPqqXTvWyCf8KNrgb3ahCPlbysO4nhcx8zgKV5DpW+CnPDYq7+lnxDTE2eyOP/0RW913qWQQ1MJjoTWFjZP0yffs61mq4hP2HdK2GKq5M+fDArDolIQVrHsbmxB6fLlKYAgbDeUsNjlUxw+2nGREpWwMQOEtKx46igkZ8rDFFxvQLZFG/KqFABt4amPSUJYu6863rWL2DoyIeGba/VoECi0S2D7DKl4v4U5WY6AdWQ+XGHXpztLqiWEMHSQAxaVFnmCBvBwmV6ug4KN56J+hKHQjozsngKFsLXCFOoyjr5RQaYORIQ5ojR9d76j820NKzuATM+2zYMW/L4TbbPHfpps2y6DH3cBF/0PAHf/GXV3nZQCALWZ3U8TYJY48LD/GJP2Jt2JPE4u0yog5XaVwMIyBCEM2QhNSOvF0Ky603F24IJ005a2MkqsqiCGcB1t/iEIXYy607zqS43EPvmV30JU2epmDaxCcffuj66tnICxIA/HMoowFk7h0tRGzKuZn1RkF8KXRouLNC0QpOLyfid723XMbot2s9QmBu74FECuxrs34VyLKH6wa0ggXk0kI5r11BD7tHcquCr9Ko4VqwlYlZHrG1A5Bs5LksHVo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c132dfe-547f-4f82-eed9-08d7eaa248c2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 11:58:23.1745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K+w0sCC/zqeFU//oOh+/4VIU/iUCfdBZldHojEqu2lkVZoea8OSleloZXOnofDS2177BW98gYsNbhcDBvO0a4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4767
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 26, 2020 at 09:43:55PM -0600, Alex Williamson wrote:
> On Sun, 26 Apr 2020 16:13:57 -0300
> Jason Gunthorpe <jgg@mellanox.com> wrote:
> 
> > On Sun, Apr 26, 2020 at 05:18:59AM +0000, Tian, Kevin wrote:
> > 
> > > > > I think providing an unified abstraction to userspace is also important,
> > > > > which is what VFIO provides today. The merit of using one set of VFIO
> > > > > API to manage all kinds of mediated devices and VF devices is a major
> > > > > gain. Instead, inventing a new vDPA-like interface for every Scalable-IOV
> > > > > or equivalent device is just overkill and doesn't scale. Also the actual
> > > > > emulation code in idxd driver is actually small, if putting aside the PCI
> > > > > config space part for which I already explained most logic could be shared
> > > > > between mdev device drivers.  
> > > > 
> > > > If it was just config space you might have an argument, VFIO already
> > > > does some config space mangling, but emulating BAR space is out of
> > > > scope of VFIO, IMHO.  
> > > 
> > > out of scope of vfio-pci, but in scope of vfio-mdev. btw I feel that most
> > > of your objections are actually related to the general idea of
> > > vfio-mdev.  
> > 
> > There have been several abusive proposals of vfio-mdev, everything
> > from a way to create device drivers to this kind of generic emulation
> > framework.
> > 
> > > Scalable IOV just uses PASID to harden DMA isolation in mediated
> > > pass-through usage which vfio-mdev enables. Then are you just opposing
> > > the whole vfio-mdev? If not, I'm curious about the criteria in your mind 
> > > about when using vfio-mdev is good...  
> > 
> > It is appropriate when non-PCI standard techniques are needed to do
> > raw device assignment, just like VFIO.
> > 
> > Basically if vfio-pci is already doing it then it seems reasonable
> > that vfio-mdev should do the same. This mission creep where vfio-mdev
> > gains functionality far beyond VFIO is the problem.
> 
> Ehm, vfio-pci emulates BARs too.  We also emulate FLR, power
> management, DisINTx, and VPD.  FLR, PM, and VPD all have device
> specific quirks in the host kernel, and I've generally taken the stance
> that would should take advantage of those quirks, not duplicate them in
> userspace and not invent new access mechanisms/ioctls for each of them.
> Emulating DisINTx is convenient since we must have a mechanism to mask
> INTx, whether it's at the device or the APIC, so we can pretend the
> hardware supports it.  BAR emulation is really too trivial to argue
> about, the BARs mean nothing to the physical device mapping, they're
> simply scratch registers that we mask out the alignment bits on read.
> vfio-pci is a mix of things that we decide are too complicated or
> irrelevant to emulate in the kernel and things that take advantage of
> shared quirks or are just too darn easy to worry about.  BARs fall into
> that latter category, any sort of mapping into VM address spaces is
> necessarily done in userspace, but scratch registers that are masked on
> read, *shrug*, vfio-pci does that.  Thanks,

It is not trivial masking. It is a 2000 line patch doing comprehensive
emulation.

Jason
