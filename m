Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51AD3B1ED7
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 18:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFWQna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 12:43:30 -0400
Received: from mail-dm6nam12on2062.outbound.protection.outlook.com ([40.107.243.62]:49504
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229523AbhFWQna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 12:43:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVwvbBXo2v2HR5eH7LrOAceT5RJk7yXlkQrt9MagO9ZUuBoYBaLkL/S4ESqd2eC4jkgN9l32qnm8X7TpdeIcgL0LxrHpCj+Cv5YXCrVyqE+TqzL/guGVEAnv8WeEziCMoKVFtCyL7EhiUE8fq9JODlI1bVg/Z94x5OCXc0PP7ufsrRcKdeRUjevBm5uSYDfisb6rICDe9PR/dElBBTWX4ihV4RvCtqdmDy+Uhy0HwrtALNT+Ey+sySnGKSC2qQPitqFkHVyqnsRV0gHvT8Fn8HfG1BzxN0arQYjDSGTvnnFvj9mbpexbBwYschpEdP8B2DuOlCy5Sjq5bguio5DsCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CcqD7kBHTIu8L7a6Z7JDlhO2suVhHYluffA0VJbrSHY=;
 b=ezw3lTP3Uvm63r3pbaVKi/JfX5PTpA97NhFG8itVP6IsxcSOung53d5HhCy5KclhL4YGYmDx3EZWPQNllbaVjcqcN0aeSuDxUdWxy9bor/6aJ2vLG0RnJ46AyEcU7Ew3Fd0a7mejNf7b5nM6jF3Ej312X2Lsd3/E98+AbQiuCdQvd7PLjnboDkBcL5d8r3xRMjD85pTFsuQnbncZj3KOxhoaDCPNCiauVQMJYTnuCzTfhnTXPWlujFPrfj2b1OCaF0rMQKsm0VMsJ/MOZOJRQzOafe65ZhgbuJFQk2l7XO+2zGeDpIIhJVYnVhL2z6UIaND0xJCHR5GaU/osMScTHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CcqD7kBHTIu8L7a6Z7JDlhO2suVhHYluffA0VJbrSHY=;
 b=n2vMwASKi/kFpkufZQVLlOqFm26JcXc9Wy5L6Aq6EL20hSLYJ0XoxuMO6m5zjkcY7cGtKr+Xan/4DXbVXPAOFpgE7ywf9d8k/TJ/NGSUeMEi8Xvoz9S2M+JMCpcB6lgkRqGcniK/120w8SCCynDQ26NLPIMn2qOj4ncWYPHHWlatN/Q3pW3uWWqvQf/hIFQ8MoqLK68SQG+AnZEeaQqQ6lLdahTa8+iWx2VL3HOOrTWRam8470ORKOvBKM42v+ov1tAfTGHvLgAvVLNpRDSEGT62Wb8dCc25gQjpX+/cR+MdXUqNapqincmeW1jzFmBXqehqkF29obuY8zEvyTYxmw==
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5539.namprd12.prod.outlook.com (2603:10b6:208:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Wed, 23 Jun
 2021 16:41:10 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4264.019; Wed, 23 Jun 2021
 16:41:10 +0000
Date:   Wed, 23 Jun 2021 13:41:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: Virtualizing MSI-X on IMS via VFIO
Message-ID: <20210623164109.GL2371267@nvidia.com>
References: <20210622131217.76b28f6f.alex.williamson@redhat.com>
 <87o8bxcuxv.ffs@nanos.tec.linutronix.de>
 <MWHPR11MB1886811339F7873A8E34549A8C089@MWHPR11MB1886.namprd11.prod.outlook.com>
 <87bl7wczkp.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bl7wczkp.ffs@nanos.tec.linutronix.de>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0404.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0404.namprd13.prod.outlook.com (2603:10b6:208:2c2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.9 via Frontend Transport; Wed, 23 Jun 2021 16:41:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lw5w5-00BXlV-CC; Wed, 23 Jun 2021 13:41:09 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfca2d0d-15c5-4743-3408-08d93665b4c2
X-MS-TrafficTypeDiagnostic: BL0PR12MB5539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB55391AB263896C5C9C23719EC2089@BL0PR12MB5539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FlyPMCIHB+HBekWikyAN4rBgLaLc0dYMQ7k1y0/aAza34nXzhUwEiMXGJdEk16FzekfFKtNcIw1d6prAiUA0WuHRtwVcKsLjpv6wHmLMJ2yTtp4uvoVNc4+7qNLsmIrfgG/UOOx98ks3cc8WXldEhUFPqOYWImrOJSNaenEz9ou7OCLtms+pF/y5WQzoNbDZA9AS3qgSectMpWEOgN7B/zmf8jDaDLK6EoD9okoyhaqLhIQccYeKqES92OSbjj00TTwNUF7uztU5goh0pzn51N9/KXPDUiqJOe5Ijj4z2xC1wx3Bo4Y0GIS4XiMYAnJKjqVaXsy1VRgkxr6zFEkeLQAEt5ZR0cWxq+za/iB6K3YwoTzrJHUJ0SY5GspvH/Br32yQt4n9iLaLQVO9qjvvSyDkxhQcmCLFchtxjKevVd1qwj5G4RVO7F77UkYFQxMnBATHIDVnZuvcBYCJSxrPamHZYzyl/JUV9/OfRfG9O6N8oEKO30smqN6OAR1NWFwmGk0bHP1siPy64TzkaBTHjAp0vSuFWZD05gxZ5JIJm/fZgspZcUQrBUBZ0dPUi7gQjJ9NRzQB6kF9v5D1DVei50YjjcN8AEJ0Crp5xClDs2AMEvAZHPeGzwfpGESlpOsmVSAdJpIX2y8OXG0BLLNZ9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(186003)(36756003)(8936002)(9746002)(5660300002)(9786002)(26005)(8676002)(4744005)(7416002)(426003)(33656002)(4326008)(6916009)(66946007)(66476007)(66556008)(86362001)(38100700002)(54906003)(83380400001)(478600001)(316002)(2616005)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f1PtV0tSu8kkpgGRfkHaB62vLYvaTLiHzKLPVIiY/oY7NGyM8QeElUXONZHw?=
 =?us-ascii?Q?CFEU8cLBQR0RW8vJ1IKoj+jad72xm0UGkQjr8n26RA26v/wa8KxlGl8dBs8f?=
 =?us-ascii?Q?FinNrGJe1uwZ+g5j/R/K7aNY3l1+hRuXuqq92FzgvUERQqAnPWcOYmjJpe7W?=
 =?us-ascii?Q?HeWgXcpQ6lKab7MCjT4r+N1AqnpAl1Eb0zv3Jpo9ZoVIgKv6wIkQyflcD5nb?=
 =?us-ascii?Q?/aTQlcK2NG7aSw2XOE771dSSDshzQp8EBwJWNQrxOJCruKKFD+yKfiuNOmXG?=
 =?us-ascii?Q?CVkVaUB+VHaeMk2NsOF0qaxR6/8AlWAE5S0aqDbwvkI6kBgSD6642WOZoubO?=
 =?us-ascii?Q?TXKtHuMu9KkpYow4GidIvhkhrKSpB8tasHAX/QpLMC2NGti59n+ZzsXMbN/D?=
 =?us-ascii?Q?pGhdm4SVZ5qgRBA0MwpfzZxXLgicsHadHO/S+vnGCxa2uS2526R/WvYfgGbY?=
 =?us-ascii?Q?/l7fqqekfDkg/BGYzAbexIc+2hqh5M9zO4Iqpgp8ZVwlpWsQLAMbzi+4qsrE?=
 =?us-ascii?Q?clhF/lpMzuM0XTmeOzXP2G+CmmtplBlRvBpS8a2pCk1P0ZYOTRoAhJQWx4VS?=
 =?us-ascii?Q?bUheXiQzeYWY2QP5jG9/mxI5mWUf5DZ4g2z78jTJ4lFVZ2mRvZqUgJMPvyn5?=
 =?us-ascii?Q?8rBcare9KpPUzUTD5y6KvaiM9+JWvZL1rVg7noPRvxQbQC+3vLV60zWYnGR5?=
 =?us-ascii?Q?1A1ceA0EcmFrvzQCjZM000ZETCCrNu0e4y6mtVZur8QnWyeN5j5D7DBi2h5V?=
 =?us-ascii?Q?GqhygoShvo4Xdj5krzNkZHmZebDr5xaXikxY/2QgZIDvzzd+/ciQoW+r2I0/?=
 =?us-ascii?Q?c/4A9Hjp3O8hzdSs+Ut6dNPYukoLM0WJXNaSub5LAY9HJVBKPCnbUpHHWNji?=
 =?us-ascii?Q?o57pcU1PoJt5pRfq1ReTHX8rGGWObyb3LF3iix3SUbCTFz7nhsbWmUd4bh6q?=
 =?us-ascii?Q?cslmhQP6p0VS68AAYLxor4ARYN87qdwqDkqMCT6C0/wX2NTDC7pUXJb3BkFR?=
 =?us-ascii?Q?JXW/yA8AdNWXpNqtqnyVu8eT8I2JEqeRbWDPwNhy5eZtpD1A3jfOqR3psaeh?=
 =?us-ascii?Q?aHeJYATGzIsJMTeOlsfiwzD2O1aLvoyD2rd6wW6VhG/GDdi5Fk+pluJKq/Jb?=
 =?us-ascii?Q?NKPbg6+vxcoZzdsdqUK4/pRr6XAZ7FyHI98E46Aa+/Lcxvp7k/duTMOJYdAm?=
 =?us-ascii?Q?PLuQztPgLEYMXRdWUPTSGkGIkt3IPAOnS2ZJ0TA83uf9M8XSYnvKWk2ffHiP?=
 =?us-ascii?Q?KKt5bQ5NCjqnHqqtrqF42eteUf6SRbmbaCHSiE7bcXiA1I5BxV+AdZJ5F3DW?=
 =?us-ascii?Q?xkThUxQUIXkqV+QuGEiHfOvf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfca2d0d-15c5-4743-3408-08d93665b4c2
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 16:41:10.4138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZBqS0Hs3J3SBHE6YTKrKPEArM13MsB4emRp3PlATkVSMAdYwYOb9EB6Clm6X7m9u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5539
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021 at 06:31:34PM +0200, Thomas Gleixner wrote:

> So IMO creating a proper paravirt interface is the right approach.  It
> avoids _all_ of the trouble and will be necessary anyway once you want
> to support devices which store the message/pasid in system memory and
> not in on-device memory.

I think this is basically where we got to in the other earlier
discussion with using IMS natively in VMs - it can't be done
generically without a new paravirt interface.

The guest needs a paravirt interface to program the IOMMU to route MSI
vectors to the guest's vAPIC and then the guest itself can deliver an
addr/data pair directly to the HW.

In this mode qemu would not emulate MSI at all so will avoid all the
problems you identified.

How to build that and provide backwards compat is an open
question. Instead that thread went into blocking IMS on VM situations..

Jason
