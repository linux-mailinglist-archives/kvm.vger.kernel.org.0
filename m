Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF823ABF30
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 01:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhFQXMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 19:12:16 -0400
Received: from mail-dm6nam12on2079.outbound.protection.outlook.com ([40.107.243.79]:31809
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231523AbhFQXMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 19:12:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gwRHFXA114XVja/AalWCBa+ZYaKj9FBByMQ3Cri4+jziFnuEF8Uco5PKQ3V2c2nhG5ChADpK3NYDTlBHHgkYI2OzVVvZxXbcCovW0dti3fZf3qnZ5AWSYKAMVNQE7klYfaRDcmchQrsht0nkF9jShhfXRcL/V22KzEvWIcBJBSovNbt2oDDCT1KobWjmItGMjEyUrURiThTASBM67+rch9Nk4F1m8GUMWpGHMyQ90MzW5lRiCZe9AGqwYNwjw5H52QLKRvZMxehfWw83VneiDP4hNJd1MeGxwios2UG3nWObsp86A/3Ev5X1Sa/9sRZ9lzY0qoNw/VwUFtCv4wEARA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEVTL/7SzelGvfFdb+tusyDdScz1wWBOQYBSJ31QZJk=;
 b=OUh/5GzI0RxGDV2NTeJG2jBa/fbjh9bP4pU6/K4N3/avj78ZdV6mdukcI+0Qayn3+HiJeoRDgb2eTjBaQ4TjHRiWDW2dd/bbxHqDJ+uy6lQO8MfgodFd6ESEuujSjg/ufVU9uebCTP6j78CTPMSVAS6eLT9QF9NZGXTnj2rzA9ny6vPZd0xWnsqsglGde+qFYXWJOpncZtkxwEeroEem+s5QVKNvLQITru6HA/td5XrqSNklBdARYsSGnKQF2vMSS4DvKAXqtP4VIuitGtzVUlVSK54UT2y9Ug4SQ4nOWQpJYEts5S8GyG8sXpf1a/oZ6K4kNlviF5pRJFZDR1Xhiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEVTL/7SzelGvfFdb+tusyDdScz1wWBOQYBSJ31QZJk=;
 b=fW+FQEK5weHqFPTR+Ak2FJnIDLd4xzVIc57iOFWGKjRUSICRfTnkDrsuUtA9V27Sqm/5K1518y0J+7hAIdUy+LtoXycYMvFei0MFuc82KAL/3MjphEI7uzVV2VgkyEVa6KXmiKcxNuWlQuTx715A25RJNVzYeMVIh6aikoqxS5P9ni48QHuoBCjGHyzEuBmbwDM8joP74J1ESwMLwTBduSrZauopYsN6RmKSTmzI4ze2+LQpuJc0V3Q3P7xX1YOZm2X9EGnNlYv0OtKGfZsR/FAVdvuRzxAiQ9uDD4ifDJr9zmr1J+sq6mFIcTRLbK9sr1J5rKPsEkiucLba5QCbBQ==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5032.namprd12.prod.outlook.com (2603:10b6:208:30a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 17 Jun
 2021 23:10:05 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 23:10:05 +0000
Date:   Thu, 17 Jun 2021 20:10:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210617231004.GA1002214@nvidia.com>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMCy48Xnt/aphfh3@8bytes.org>
 <20210609123919.GA1002214@nvidia.com>
 <YMrTeuUoqgzmSplL@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMrTeuUoqgzmSplL@yekko>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR22CA0028.namprd22.prod.outlook.com
 (2603:10b6:208:238::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR22CA0028.namprd22.prod.outlook.com (2603:10b6:208:238::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 23:10:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lu19A-008JvT-1c; Thu, 17 Jun 2021 20:10:04 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 807a5528-c5bc-4add-8d39-08d931e50aca
X-MS-TrafficTypeDiagnostic: BL1PR12MB5032:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5032A9D3DFA8B4282A99F161C20E9@BL1PR12MB5032.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lOqYdQVPHvgBthIe4hM8gc+07Wkuu3sIRRwck4EtY2GZ2fNjnq34uNL16bhBfBkDz2Yd3xSmDMr3SRU2piOtkiKTgHUbMqBJkENcucaSm5VQaRj2alGNG5VvhQE4ksaZ0WXrDTfmy3QpEtz9qmAcAuJSZbIFbGFctO//7ILicz/O/z/g6/8L80JeXdGaK98uom7lR1Y4uN3w1fa/xufAHimmN/s9d5k61fLuKOYqwt7wfW4iX124QDqHp/OHGS+NQbpXa0LE1BUDe/6pz7OocyCO5XNEgccRlizn21dU72m+75g2GcYRwkkjWiLGJKZqeV2EKp43cCiKU2pSbUs6PURFDQ6bLHPSgoUaFxyoCMH8Nne2ArDxtPNkzOMBQ82BjPjnFOIEsMb7BEHIBhNe8V5Eb63HzMIXSaU00RA281/WxcSidYZgZx0aRkO4LwQEu1BV/QA5/UpgaiD9h0pxx0qJnhbbfskWBeozkcYskoeNNxTXMSv0Llcnk2DN5QNWYgtjMAc+U6E4Z4qZcIE/8WGKCG0B+DdcjbStzOD/kv7fJcfgBIHc8zPXaeC/n0/TgCcBbXdrgO/eYzqV1fkQAYqsOjyd8Jjuae3TA+n1yvg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(38100700002)(66476007)(1076003)(6916009)(316002)(66556008)(426003)(7416002)(83380400001)(36756003)(66946007)(54906003)(2906002)(26005)(4326008)(9746002)(33656002)(9786002)(86362001)(8676002)(5660300002)(186003)(478600001)(8936002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VALPmIfLEAYXOhFCt5YFWh56+ccVZAhzXR28B2aXYqnUK2MMbWWSTDNjC57c?=
 =?us-ascii?Q?+6kk6eF172vTr6pIHEYMRFQpLN4F6VDqRPWVzWzSDnrPZ1ceJ3jI9HmbgzXw?=
 =?us-ascii?Q?0tW5bJtyz76rST2k2z/T+i57mmozYijrGteGt+uJvHiB0DO+QyYbeJ06EaFJ?=
 =?us-ascii?Q?dbeQLtgBFPaNeqQiHW9S6ADutzXWNkMUqSrDyiv72BAswcwESJVIVwvb1w8g?=
 =?us-ascii?Q?bLwvAnn/CUr3xfO7OUwbEB/MKo9DD/3wsJ33n3j46lSsgTW440Z3yc9veERI?=
 =?us-ascii?Q?u5Rfpd/CObB2KmSPwuH0ACg44prkEEorxgtVf82ZLXaaKQSM2fNxPYQAluAI?=
 =?us-ascii?Q?92dMFl6itt9qTBlK6R6cBZbTw7DMwJfgYQmh0K4rMH+TV2E02xjSESuXmXb4?=
 =?us-ascii?Q?yY/Q+0QlSg3B7Wodov/modR5+xua6Pn75+BM/mS/GfTfzzGuA5IAK76Ke9aJ?=
 =?us-ascii?Q?6j8ogdYxCn771wtTrjTh6UHxsCXQ93w3fO24YxZyR4OulRk91VKt0u3gK/Zl?=
 =?us-ascii?Q?VHrzvvUeU7nzvBPm40nam8m7TNY0nlHkGGRnckl8eU4VUMTUTHcoMkfhi6/n?=
 =?us-ascii?Q?45BT4x43f6kWj+b8Am7AC166ivUv6n7tRkV9YBtONlJYlsMaugYsCH9NXNnb?=
 =?us-ascii?Q?bXA6hqvr2RD7E2nkR9Pt7m2g3m2yV0OhRx2TUGM/zXyBSmbprQnjfl/Ydwon?=
 =?us-ascii?Q?a4ijQVRHtxAujOJ4DeB+k/MgidJLLMylYW6FMpUy/KO1hlV9OJ32kWfqEZx7?=
 =?us-ascii?Q?MMS8iMahEX+XJk5oQbUxVVNsKhWHcldL2Q9KPcV1eLAqQz9BW40skux9Up+Q?=
 =?us-ascii?Q?y4Cthu0ifzmH1MWOSZDwGfDbqUO626EqV1424N9HqCbGtaOCY1Y7rG5pvlG6?=
 =?us-ascii?Q?WYH4VBaDMuA9hKQYL57O3Xjvb2+F5mDUAJpTAGP9jLMiTLIBaydi3IAvnVU4?=
 =?us-ascii?Q?h0MEF3v0p7pQ4ruSegDgR0lUBXI0tsfutJVytzmA9X8QzOvLR0XkRLOA/M/w?=
 =?us-ascii?Q?ag0Yz2lIL1aosDLZyi1JtCHq4xVF98iEnJvr5nWTyCZLhnizDTo4hx6yb+zR?=
 =?us-ascii?Q?bIVV6k5S5fDEWSzhnC15XKnxNn1Qj2RzgTjC27G8ZOp2pMj6s7auBFMzUgXG?=
 =?us-ascii?Q?4STPLLf3S5hOZ0ShurExr0EItevFsFkVI6rtlTRmbR3Ir8oPyqDAkkkvsQVB?=
 =?us-ascii?Q?piP8dpWWmR165D7NdxMeA76Mk37uwJE5Up+pph0LoWLlF8lgK6lhhgyeAUDv?=
 =?us-ascii?Q?aumbe5pfOGyRx0Qg/cMjbnloFQz4Gh/LccCYkf0djxGjcs9LO1HSZZUnsKn6?=
 =?us-ascii?Q?+elWQIgIcd+9ccjxBypXb87o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 807a5528-c5bc-4add-8d39-08d931e50aca
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 23:10:05.0632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ba/wK7YdHAf6JOaEqT6y3+tTp9ioz0UhBtyO78KaFMiYfuKOfXmw7l+NBSUCkgLE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5032
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 17, 2021 at 02:45:46PM +1000, David Gibson wrote:
> On Wed, Jun 09, 2021 at 09:39:19AM -0300, Jason Gunthorpe wrote:
> > On Wed, Jun 09, 2021 at 02:24:03PM +0200, Joerg Roedel wrote:
> > > On Mon, Jun 07, 2021 at 02:58:18AM +0000, Tian, Kevin wrote:
> > > > -   Device-centric (Jason) vs. group-centric (David) uAPI. David is not fully
> > > >     convinced yet. Based on discussion v2 will continue to have ioasid uAPI
> > > >     being device-centric (but it's fine for vfio to be group-centric). A new
> > > >     section will be added to elaborate this part;
> > > 
> > > I would vote for group-centric here. Or do the reasons for which VFIO is
> > > group-centric not apply to IOASID? If so, why?
> > 
> > VFIO being group centric has made it very ugly/difficult to inject
> > device driver specific knowledge into the scheme.
> > 
> > The device driver is the only thing that knows to ask:
> >  - I need a SW table for this ioasid because I am like a mdev
> >  - I will issue TLPs with PASID
> >  - I need a IOASID linked to a PASID
> >  - I am a devices that uses ENQCMD and vPASID
> >  - etc in future
> 
> mdev drivers might know these, but shim drivers, like basic vfio-pci
> often won't.

The generic drivers say 'I will do every kind of DMA possible', which
is in-of-itself a special kind of information to convey.

There are alot of weird corners to think about here, like what if the
guest asks for a PASID on a mdev that doesn't support PASID, but
hooked to a RID that does or other quite nonsense combinations. These
need to be blocked/handled/whatever properly, which is made much
easier if the common code actually knows detail about what is going
on.

> I still think you're having a tendency to partially conflate several
> meanings of "group":
> 	1. the unavoidable hardware unit of non-isolation
> 	2. the kernel internal concept and interface to it
> 	3. the user visible fd and interface

I think I have those pretty clearly seperated :)
 
> We can't avoid having (1) somewhere, (3) and to a lesser extent (2)
> are what you object to.

I don't like (3) either, and am yet to hear a definitive reason why we
must have it..
 
> > The current approach has the group try to guess the device driver
> > intention in the vfio type 1 code.
> 
> I agree this has gotten ugly.  What I'm not yet convinced of is that
> reworking groups to make this not-ugly necessarily requires totally
> minimizing the importance of groups.

I think it does - we can't have the group in the middle and still put
the driver in chrage, it doesn't really work.

At least if someone can see an arrangement otherwise lets hear it -
start with how to keep groups and remove the mdev hackery from type1..

Jason
