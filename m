Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22193244A77
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 15:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgHNNf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 09:35:29 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19826 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgHNNf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Aug 2020 09:35:27 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3692e80000>; Fri, 14 Aug 2020 06:34:32 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 14 Aug 2020 06:35:27 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 14 Aug 2020 06:35:27 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 14 Aug
 2020 13:35:26 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 14 Aug 2020 13:35:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4H3kLRdNN6F8oOjsdhwk2sOWok0hDkeGbgqDEN+lcgxdO4pulhE85W/dbZW/Msgl4EvB+Cl2YQtXm3FN2mauOWI0psPAmp60M/u/MZEwz4yiVrTJyJJZcoBPy64HpFkFwa2CsyxZGJNbYmmVao+a1CPpvEDXohKjmZEPHDJtoqaG+2tcuR4xoYb7x0IDyf1wHaXRhK+fA1sH00YH35tjxcF2juNlif2sMAVmI9YjNrepOy0qrGygN3mnjmswolmBybpQHQKRP+jMMC/w38dyG0dV3osKgh0+HLOLltLSETWZyl6ElYiNEi+xfYPrDF3/7fQD2IoTCOBWqzan7laIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQgIVKo6fzkOwdqUsyq8/I0P+tpE4OWeO1KsRqtsH6s=;
 b=nIwpmDZ9ZBhT9Em336S9+2FC5YeZZxQaP0TQkSamORHsZhNcIa/QpVc/MDY3rbm65iEd9S9xDKdXMEKAn1gTaAexjqkCXBzLt6la0IwLiI1Xw+9A7T38GYBGDf8irIeCKsmxOXWwbnKkjEEvYEHgVy4sXAF8t5QWlKnN8B60OKJabebbJTqG55vpEqieZ7e811ZQPAg20qiUr2SuK9mSgUFdoaPWH7Yl6FkjuKimavebaNybksa/Z6Zl8ES6uRmKtxjW2E3eD0T6zLhsfaDhODnhzoWNbApX8YLGS7MDD08CFlbc4HFJ7KHn6rnB5CLmGlePEYKcfstTCFywDTtcxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2858.namprd12.prod.outlook.com (2603:10b6:5:182::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.22; Fri, 14 Aug
 2020 13:35:25 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3283.022; Fri, 14 Aug 2020
 13:35:25 +0000
Date:   Fri, 14 Aug 2020 10:35:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
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
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 00/18] Add VFIO mediated device support and
 DEV-MSI support for the idxd driver
Message-ID: <20200814133522.GE1152540@nvidia.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721164527.GD2021248@mellanox.com>
 <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
 <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
 <20200807121955.GS16789@nvidia.com>
 <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT1PR01CA0021.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::34)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0021.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Fri, 14 Aug 2020 13:35:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1k6Zre-006gGT-Ah; Fri, 14 Aug 2020 10:35:22 -0300
X-Originating-IP: [206.223.160.26]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73105564-1236-47ef-24c8-08d84056e60c
X-MS-TrafficTypeDiagnostic: DM6PR12MB2858:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB28583BE093FF570C8C7AB281C2400@DM6PR12MB2858.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xfhFI+LDyy0GWo756LjFOYYmxKj2VC/OrQW5Z0w+Sgg0TFgeiWJQdY7YbCvF+rnhpF/JpYM6TL4VLzXKDoRcnlmrG3hEhUCMdYuVwG+xnjclylWbNCYg/po5iuZeNRqPHIpDZpzNtswJecJQonENXY1/2MmtSTSWjSVdKs8JAp6zvn2b24MetvLvW0PNWID9xBeH+e8lJ3ESwJHuk1L7pHaRxQD/WFiUK4JT/xikDbRaKbR0fl1oggd0O/u5oWtUOD2JCBPHLXL8VnSeZvRqIqK1lbSr2cimGav9wZhQQeYzjLNA7xjSu+jOr1y9xPnO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(86362001)(8676002)(2906002)(6916009)(478600001)(316002)(54906003)(8936002)(7416002)(7406005)(9786002)(2616005)(1076003)(186003)(426003)(4744005)(33656002)(9746002)(4326008)(26005)(66476007)(66946007)(66556008)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YcldZ/jqWFVO4ZWMmAcfknwGOItCNW393eBPf9Ged5ghhsepUJzul3c186NQnFuIjelXm8Dcahq6nljXcPs5ZEUSS+lpCcDWft1oDN5lSgmow2pu01ZUzyt3DDgWWJHydeqnth4Ma3SqmIDi6ZWJFq6/KT8HqECM6gnHWozjA7G7hcvJQUr/JILmx5QklnVKdT9+uhxv/nzwfp6KPe4RaXjErvGMetatJgP+7l7AqsDT/Q1D3o9UR97k5YBoJ8MMMkSyWb+pbgvPgULuuSCkiaMBpZAmvZDiIBCT099EOUONlHyqF+QOGpSD6TN1m85Kd2zrJKh+jlcoVdhg4TNLDNH8Aa30GULk+6LS70+ECPEsVO40VrpMfMptRrpbt3CEhEFoYBQdErHbdtTozA/ZDLIHzK1PxSfJlyryJYvtnFwe4Vjsoqv9BO10oyy2GANtM/M1ifA4CyYOD6oJaswi9bp8ylj1tZ1LyFb/ojLM9GojQbI3rswtC6TCBFQ9WVSAaz50AxGqso0pjyJDILJ96KTcU+N0KMtE8r4vRxsGYnkhs2C27iAAPAuXDZMjhZDJ1EBxIejeGqCYTNUr5Zo5FPuWBMWYPVvoeZciNnv5jQpTenGGlCGHm4xD7V0sJASsMPNs5C8+yYr82x1FL/kdMA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 73105564-1236-47ef-24c8-08d84056e60c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2020 13:35:24.9372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ASUEzdfZ57dSg2arMGADMdvFsplcHYQkmHDbLuduOnB3IQV2QKZNsgrJatUZ/Oe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2858
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597412072; bh=xQgIVKo6fzkOwdqUsyq8/I0P+tpE4OWeO1KsRqtsH6s=;
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
        b=fGd5UiLKqZvWeQIT/m+MOaJJAW8Z90KwIxKTCCj7HzaCBCql4CUw203isD9TAv0Py
         2sKOHVN9EuM4yy5ZDMXjk5l39x40gFC74dg6gKbh59CDT7xVkxa86Ldr9SyXzOHraZ
         m8zd7hfnG/gXoJUkaqh3GeHUtnac844S6dmNEvzy+TpnTZPcqoXbrPVbXjexZUlEcz
         aYKmeofP3PhxvxdCI7tD1pN9a5ulikQtZ8dYAe3kjZ/JhuYLwowJ2qbnC52HIU4/uB
         DQ8lHWYHDEaqAZ1RICGnNugDCLNysiR7JYJR2cETkp5Q5S2KU/apK22a9ORxr4samh
         O+T21a+0btvKw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 10, 2020 at 07:32:24AM +0000, Tian, Kevin wrote:

> > I would prefer to see that the existing userspace interface have the
> > extra needed bits for virtualization (eg by having appropriate
> > internal kernel APIs to make this easy) and all the emulation to build
> > the synthetic PCI device be done in userspace.
> 
> In the end what decides the direction is the amount of changes that
> we have to put in kernel, not whether we call it 'emulation'. 

No, this is not right. The decision should be based on what will end
up more maintable in the long run.

Yes it would be more code to dis-aggregate some of the things
currently only bundled as uAPI inside VFIO (eg your vSVA argument
above) but once it is disaggregated the maintability of the whole
solution will be better overall, and more drivers will be able to use
this functionality.

Jason
