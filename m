Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883DD3A8D1A
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 01:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhFPABg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 20:01:36 -0400
Received: from mail-dm6nam10on2061.outbound.protection.outlook.com ([40.107.93.61]:28033
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229811AbhFPABg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 20:01:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Efbl2iVcFEH1Xl7PSTzV9kJG/NmHDnhRXB2m0tv3GkldYP0/QXnGuqSRyK8DO4S4LFraRokCZmJzheQRJDMe+AdOI4uve9geM86KQARDI0c3Bg4q3U8Fkwmjh7NPp2XJFeM42NXCUmGEvaQjJwacjgqUncr7EW02tPIpkmDLoEMmi2wG+TkNSRBBt37JElwAIdGvhQQkUtqx5P7T0xDINQtam1G/OguZiwGSswno6R1rhF8YLyMF4ikMdywRpk+KtZ553TyzAcY453deKbzXV/e98Fztsk7VUPy/JXWkZ4DhLS9PTDcdcEWAUIqcVBLtyxovVGP32XpLesmZVE0Ujw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4M0XGo8cW1cQgA/8txH6+IUsbDdqFjIslipzPx22gE=;
 b=RRno2uuTBv24rnV2HVTdlqSZNnlDC/FnbybTTB93lPDidPXhubKb0Wxq02aR4A/tWyL4IOKjbAXBIAcDaU90kCIUBAYDNsSMrcgPEzUN9MQFr6qYvFbRAOFCgXDiXfQgBvDWGJvhNcsbipMoWwdpPnZarrCdPH9xLZx8JzSkozB9s/S7og8oEkDm08/1crjTBIGianEUZlYLQJ7K+OgeHs5AS9NIPRr5aNCzMjV5Xz3hBCEwTXZ/xyIyuc5cxajZzTbzvBMTG+73xCvoh9oIA2qkcBhJpBoYqClqeb5atVmqH5iFbR9LHUbdwZrMDmnYfuZleOdU4o6lQNENdVZzEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4M0XGo8cW1cQgA/8txH6+IUsbDdqFjIslipzPx22gE=;
 b=dzEoTd9vQXgJB1zIKDCO0/SOslsQR/fo/KWehqxEEWHatxU5S7Tfg3hYOuMlN0prdPyYI/0nn7t7ONxjrxG6SQkCd6tnaId9HL13PVnBPc3DRUTL9OKyO9d6UAVXsHk+S02aS9KobATnhYOccsKNzMnVCf7S/0qk6JPcjJWznf7913oDMMAC52lm+26s6/Ah/24ZRD5qxtaSrG3sqLqR8Q9h0eN16hkIFszujjdl3ebCXO5bmPkLAjsVH5ykoVLNI1yh7vJalB2DqlpR6Ei4pNCjfBM+TE+fFwrwFSIaqiXqEeVTYIY2+tb6n9leqCuqDxt8UY8nj0ABZ9BiOkLVew==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5096.namprd12.prod.outlook.com (2603:10b6:208:316::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Tue, 15 Jun
 2021 23:59:29 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.016; Tue, 15 Jun 2021
 23:59:29 +0000
Date:   Tue, 15 Jun 2021 20:59:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210615235928.GD1002214@nvidia.com>
References: <20210528233649.GB3816344@nvidia.com>
 <MWHPR11MB188621A9D1181A414D5491198C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603130519.GY1002214@nvidia.com>
 <MWHPR11MB1886BA2258AFD92D5249AC488C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615150630.GS1002214@nvidia.com>
 <MWHPR11MB1886E9553A5054DF7D51F27D8C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615230215.GA1002214@nvidia.com>
 <MWHPR11MB1886A0CAB3AFF424A4A090038C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615234057.GC1002214@nvidia.com>
 <MWHPR11MB1886FD4121F754A6F7C2102A8C309@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886FD4121F754A6F7C2102A8C309@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH2PR10CA0018.namprd10.prod.outlook.com
 (2603:10b6:610:4c::28) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR10CA0018.namprd10.prod.outlook.com (2603:10b6:610:4c::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Tue, 15 Jun 2021 23:59:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ltIxs-007Gw7-Aw; Tue, 15 Jun 2021 20:59:28 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8be640fa-ad34-48c5-63e9-08d930599d25
X-MS-TrafficTypeDiagnostic: BL1PR12MB5096:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB50964F2131A68687DA41CAFBC2309@BL1PR12MB5096.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ubXWUq2q5Cd18lPmfbA1Fa1RVtxkXZdocAyY4K+eyb0KLjawNDVhmoUNpRZHxcHGFIv0bT5DvUQkXdAj8HUkE/nydYVUHS7Onf4VYucV0Ckv5P1xWA7hgdYkbWX+eqb9/5xHldVRlNRhQU2VYYb2VhUmaEslD65zmBAFXVRE+FJk71eraRAw/08ijlstqqUgPlGPuoXI77yJIf11X+XhIgpJMEO93Bm2y3TXR+d2VXi2i8BCnrasFIl9+7zpLSv5Z+rPZ1l4ktgkisB+KD8FZCm2CkU0+k5JVAngQz+OHaM59nspydww+wlsUmcmnOFJw8t37KO3fGFWUmV1hnvg0BE8rmY2xamBN5lBd7SvwHEfhBaALIBty07GqKWu4OEl8+JoBvdAuDMBVPatBqmCIbfwsvkWjULxUcf3kevVwpws3VCglRZmaFRVADhc4YeFaCwPcxY+pwkIYuCi6go3al9CNV88aU9dntNAP9uPyI6VMbNIY7YcH1+PiNS3WCa/dpjGYGTZu+/kOK0w2kia3cV7UNO/EyhTWLAh2qM+UBXVshBnV2cJyhbX7QIbTJl7ckjlp0wiRqAKWqRksYqUKx2KAEW8CyOIY05YPmf9UaA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(426003)(33656002)(66556008)(86362001)(66476007)(8936002)(2906002)(6916009)(8676002)(186003)(38100700002)(478600001)(7416002)(4326008)(54906003)(5660300002)(9746002)(316002)(26005)(1076003)(2616005)(36756003)(66946007)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?27cXOMVLo1pk0TDBjY2ndvUJaYR3/DjgULs9AmRfjsKn4SRXyhLAsUeHqhYu?=
 =?us-ascii?Q?90YFmWVNk6LMSGyN+GKGj8BOMJgL7/OcOlLUrvS1L3la8EK4LdOQN9S3MPUw?=
 =?us-ascii?Q?teUE56reMAC1oeHqGEKZGvqd8nqufw9a/kqJ7C8qVAzFtQklmnhnJuhLIyIE?=
 =?us-ascii?Q?y2coQEf0ozPIv5utDwoBHmIaPnmYBeZSt36mKKzTr2vH8niN68HjyMvcJnlI?=
 =?us-ascii?Q?sGhbHg0VWknNXK2PgtRJNq5sQYPfcESB7w4YNJZJdLOoAi4E/t1HCsTGkyKU?=
 =?us-ascii?Q?IC3Z5S3JzIX3jrospLP1cdF4d3/rw2E8ojmyv/jrQYKcZ54eJpQoudMv+Cxi?=
 =?us-ascii?Q?qmzGccDWsj+5lPkPxl1/QGygi64wiw8pDgrl3pAzsWjhbQ8lCjq4bBvtudU6?=
 =?us-ascii?Q?dZmlla1Ux6XMxM42dVme5Ulg35gsVhhhy5xF2wtQCbk+CdLZ/bXGSOJAkmLO?=
 =?us-ascii?Q?tYYKeF/tVu+czmk61xASjhFkXi1TkQukWwWYy/dlwWmHI6BP4iaVOGz+oVD6?=
 =?us-ascii?Q?ic0tejZ1zHnpGZj2Sux7EXZdHpdZRdtfPI1PsvWXlgbMKPLR8whz167pcgrb?=
 =?us-ascii?Q?L8kaqFAKAJfkx9lJA5aMtwHMMVVrXhSyp9QavhlOzURf2YjvnCCbD6keGYL8?=
 =?us-ascii?Q?DXUNfVb/r1eNdVlgXC49xpO+7GGL+a1siojTspb4qQHbSwmAWfCvu+tpGYVL?=
 =?us-ascii?Q?In8JP0oigdmDSMvrM+EZwcu/BUUGi7fIcP0BWnUhWhoPmsPjO3qGcE8modrC?=
 =?us-ascii?Q?xtnWp/Rt4UcVGxseAxJPu7dnBciQwL0qJbtctImoF9frklqFCt613ImyLNEl?=
 =?us-ascii?Q?JXicFTKd1lMx0bvwlwtUMv0OMDWBsZprxVXvSK1WDIjVP2AkpBsZk9Alrdl9?=
 =?us-ascii?Q?w9WI38iXuhysyz+eB7pELRrmUh1P6396EL6Tdppo2WWvkIVDmo/61sqeBROc?=
 =?us-ascii?Q?o65WDQgdOksYEYcBFWz6Zn4XTXDjpU5tL+HFfHv+x9qganwLctKWrz2SeMyu?=
 =?us-ascii?Q?3q4nHiC/QRZDzfQ55BQyvJOroMPZgMso3fPRgTpm8IMrGCMr3bq+6/SABpJc?=
 =?us-ascii?Q?eH6KssNPYMN6IvAMkurpHrdtPQ3vCp00bV+zW9iLqtLEFFA5bdb0cD58ihWO?=
 =?us-ascii?Q?WUVNrSNVJqC29OeEVTHZtLLdg8Ik/zkeg/AVnukL6ApCnkaz28ZvYrsljeyi?=
 =?us-ascii?Q?jUQggdmXcKRQZDHBfc+vFGG1keYIa/jrvPkh+v6eh5aqz+n/lTX0PACzX0KX?=
 =?us-ascii?Q?SJBWEco3A9F3eVPML8Xtw5stwYiO3HyxHdx5OVxsg+szON/KvTlwLW20xlJG?=
 =?us-ascii?Q?hsf/HS1xKtGxC/8GSNzHFWCQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be640fa-ad34-48c5-63e9-08d930599d25
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 23:59:29.7904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IFeCKsSh4fvOljtY4PNeBEy5cuzWbOojhfZN9Of+5zwywtcZuU63imLn5+yTfFGb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 11:56:28PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, June 16, 2021 7:41 AM
> > 
> > On Tue, Jun 15, 2021 at 11:09:37PM +0000, Tian, Kevin wrote:
> > 
> > > which information can you elaborate? This is the area which I'm not
> > > familiar with thus would appreciate if you can help explain how this
> > > bus specific information is utilized within the attach function or
> > > sometime later.
> > 
> > This is the idea that the device driver needs to specify which bus
> > specific protocol it uses to issue DMA's when it attaches itself to an
> > IOASID. For PCI:
> 
> What about defining some general attributes instead of asking iommu
> fd to understand those bus specific detail?

I prefer the API be very clear and intent driven, otherwise things
just get confused.

The whole WBINVD/no-snoop discussion I think is proof of that :\

> from iommu p.o.v there is no difference from last one. In v2 the device
> driver just needs to communicate the PASID virtualization policy at
> device binding time, 

I want it documented in the kernel source WTF is happening, because
otherwise we are going to be completely lost in a few years. And your
RFC did have device driver specific differences here

> > The device knows what it is going to do, we need to convey that to the
> > IOMMU layer so it is prepared properly.
> 
> Yes, but it's not necessarily to have iommu fd understand bus specific
> attributes. In the end when /dev/iommu uAPI calls iommu layer interface,
> it's all bus agnostic. 

Why not? Just put some inline wrappers to translate the bus specific
language to your generic language if that is what makes the most
sense.

Jason
