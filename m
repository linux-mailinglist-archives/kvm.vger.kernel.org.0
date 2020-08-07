Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528C023EE46
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 15:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgHGNeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 09:34:36 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19361 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgHGNef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 09:34:35 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2d58380003>; Fri, 07 Aug 2020 06:33:44 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 07 Aug 2020 06:34:35 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 07 Aug 2020 06:34:35 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 7 Aug
 2020 13:34:32 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 7 Aug 2020 13:34:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KlPnyjZk6GOmG4501sxUnWdbEjf4RFt/yHK/rCLrW9yweLYPGoRFuVlS2azih/HIxhtpRpA0IxfiHxLpwZODFS/kU/x7SWcTyeINzQz1LKjcNL9z7U10ZI+tL+0O7TamJnrfkeL+UrN345fDVmonKM8niOyPKD+l+HUr8H1zz/QQTyFsg0qrucBRpJCkWfv2NShM+/sJmiHxTVAzKNItvvRPfVbnxMEBFU+xZ3rZ2U5iUT3nSbXrWPXpj5q9F+NRVyJDtuaHn9OpiyX3Pe4qZ5U6k6yPcX9v3IF6MjhpTfVrDYqtli1GeCpHhCI8gGnj85x3WRXo0uhf+Xbvo5Bj+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tGLipTKdARWMK6+ASTldUg9/frr+eGFLEQUcKrT/nw=;
 b=DdzA/Ll0sRmu2k93R+aVrjhs90qNClrvJP6RJsmMHceL3Swb7L6Mz4cVGO3OnjzxpVekfJoLxMERZhkP/bHrl8ELBH7KmKg8l/2E028/ySGZYvR/LpRkCScTc644Pi+0uRl4ZT0DkeqI0pWb2iiLoflykXMzCtxDOdODF7pIcZo6ieog/CLWdwsYHvkBHI2PI8KlFyR0ckTltrPWiMLcJiHRz3Pr6MhP2vGjvCZFcyuyvqwj0HKY+jxyDF5sgYNmHoPEaVdGNeYRjsWoJv8xfQ+GDAPr+3/QNPhWmqqbP8Cx1hW0EA4D9Wr5jZQIjiFIOUMN8PO5/Knj++nxegg/Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4041.namprd12.prod.outlook.com (2603:10b6:5:210::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 13:34:30 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3239.024; Fri, 7 Aug 2020
 13:34:30 +0000
Date:   Fri, 7 Aug 2020 10:34:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        "Dey, Megha" <megha.dey@intel.com>, Marc Zyngier <maz@kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
Message-ID: <20200807133428.GT16789@nvidia.com>
References: <70465fd3a7ae428a82e19f98daa779e8@intel.com>
 <20200805225330.GL19097@mellanox.com>
 <630e6a4dc17b49aba32675377f5a50e0@intel.com>
 <20200806001927.GM19097@mellanox.com>
 <c6a1c065ab9b46bbaf9f5713462085a5@intel.com>
 <87tuxfhf9u.fsf@nanos.tec.linutronix.de>
 <014ffe59-38d3-b770-e065-dfa2d589adc6@intel.com>
 <87h7tfh6fc.fsf@nanos.tec.linutronix.de> <20200807120650.GR16789@nvidia.com>
 <20200807123831.GA645281@kroah.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200807123831.GA645281@kroah.com>
X-ClientProxiedBy: MN2PR02CA0030.namprd02.prod.outlook.com
 (2603:10b6:208:fc::43) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR02CA0030.namprd02.prod.outlook.com (2603:10b6:208:fc::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.20 via Frontend Transport; Fri, 7 Aug 2020 13:34:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1k42Vw-004iID-QE; Fri, 07 Aug 2020 10:34:28 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bdb05af-9100-4b97-c1ee-08d83ad69cb9
X-MS-TrafficTypeDiagnostic: DM6PR12MB4041:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB404113D5F5431A8A01F3A29BC2490@DM6PR12MB4041.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OMalF8tNHWCg7x0uwQwAD5bsq8N0PPwQefxYPrjW21GePn6V8cTM61+7YZDqFE8ESLbbYobzoFQBujpyVtND6DAXJsQi781sI2+1OidBbwVX1yZ6yzoMNZQWrrYrcM33i02whq2w7BLeiPQ50xEkbnCn9oZid/gUn+5OCr0AzDZf9Q9H2pjjlqQbt8/mOOrrJ3vtLH92A4RLp4tjlcu1SEomH3DqDCTL55t6wAmiyOOV8OOxMllSFEPcMYUtB9zG1upesBaZACYeVUQinre4QR2QU2YznZK2t7ll6blUzq4HffBDFjQzX5Ws3iOQRuEXWQEMNY0cylUp94QQdWRlY9il23KWmUEP2O7MTZiXKzyw9Atnje5GdY3+1O9RxmIDWgpp13VEqDXBg2gkgSmjQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(5660300002)(478600001)(66946007)(66556008)(66476007)(966005)(1076003)(316002)(9786002)(33656002)(9746002)(7406005)(7416002)(83380400001)(2616005)(186003)(26005)(8676002)(426003)(4326008)(86362001)(54906003)(6916009)(2906002)(36756003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qhvDxJ9s3fgN/Xhwe0l+oQEAZIqbtkkSfVQmpx2WbKR2kQBFseEPsId30CuNP05Q4+wKf6O5zPNmCiTti2AKhKnowlHI5DXKR05SVxAHiChChsKuXxAAMzkaEIBVQG2VdGNDa7d0CbNPUupsCyZ6Ez8NSdm9t8kdk+2smguiHL58lEp9djOIm/HDQTPQPRPUoHQ4JXk9+RC5SfbpJK3KSEAwkxuP/rhQk2RlPQHMLasvHTPLYDrCZ9SioF8tZUgaIX+QukU9mtT2IaL4BBVk7dMXWHJLOsAx9XJo7Nja1zZyGSYNaP2NHEmsOSHfq2WZr6cH4PGdBfNnlW04UaTpJma6luzAothTPVoIYn12Otoqqq+XuprQqoT1KX3EAeQgzNMZjvFB904EcZQwuewWCbrrO7rCtVTtUJIgYm+gXaOYwLqzwil8N8LqTE0k870skWFYTDs5/azI467mIK4oyC5Wd9wnEnPxEmmpdCmNMTn0DB267aIusyelhjSbM7Usj4w9tsUCUi8csJIOABXFqN4qXwOONbto9CyuhPpGvKdw5tQGA9jouuPy1PG1D4tcYw5+u8z2CTN5LpIsOtlPWgTVJnxShZUS2x3QVDwUWqaW1AzJjAIbYvbQYxMe75CdeDmKbZdajFIax7S0I1e+jA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bdb05af-9100-4b97-c1ee-08d83ad69cb9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 13:34:30.3984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RFCawgYomCfCI3AJNNyjCLPW0oR2VSYoCtXy6YwrwsCjuMpcZ8qSKJXu+XPHqTCl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4041
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596807224; bh=+tGLipTKdARWMK6+ASTldUg9/frr+eGFLEQUcKrT/nw=;
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
        b=g0gSYATJbaGtgH0YDL6CtCzE45LVsQ0MQhr1amXPqiOATOSJVnrpiGGsupQrwe4Al
         iyUuJxKImosPRXsNu7ANc8YELAaeK+4LXr656PHZAAkP6hPxXFap0b3k9qBAOmZ6pW
         Ui4mH0xkEA76m7EopLJmTVFHv70c/AQyvNFgLW/4omSQOnGNzVsQXO4VwgtMmrZGAG
         A2myiu+H5dYqEVCqUOeraTB2ll5LZ8ZojXwI+lbeYP34S8dbMmuC+d6GtvAxD6ttow
         cVFDfFjwDRJ5o7mGH2xY78TugSGqvXhDUdz9xUSnZLnTyIXRfsc7MJSSaJffYLgUyy
         LcbG8pmSqYPeg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 07, 2020 at 02:38:31PM +0200, gregkh@linuxfoundation.org wrote:
> On Fri, Aug 07, 2020 at 09:06:50AM -0300, Jason Gunthorpe wrote:
> > On Thu, Aug 06, 2020 at 10:21:11PM +0200, Thomas Gleixner wrote:
> > 
> > > Optionally? Please tell the hardware folks to make this mandatory. We
> > > have enough pain with non maskable MSI interrupts already so introducing
> > > yet another non maskable interrupt trainwreck is not an option.
> > 
> > Can you elaborate on the flows where Linux will need to trigger
> > masking?
> > 
> > I expect that masking will be available in our NIC HW too - but it
> > will require a spin loop if masking has to be done in an atomic
> > context.
> > 
> > > It's more than a decade now that I tell HW people not to repeat the
> > > non-maskable MSI failure, but obviously they still think that
> > > non-maskable interrupts are a brilliant idea. I know that HW folks
> > > believe that everything they omit can be fixed in software, but they
> > > have to finally understand that this particular issue _cannot_ be fixed
> > > at all.
> > 
> > Sure, the CPU should always be able to shut off an interrupt!
> > 
> > Maybe explaining the goals would help understand the HW perspective.
> > 
> > Today HW can process > 100k queues of work at once. Interrupt delivery
> > works by having a MSI index in each queue's metadata and the interrupt
> > indirects through a MSI-X table on-chip which has the
> > addr/data/mask/etc.
> > 
> > What IMS proposes is that the interrupt data can move into the queue
> > meta data (which is not required to be on-chip), eg along side the
> > producer/consumer pointers, and the central MSI-X table is not
> > needed. This is necessary because the PCI spec has very harsh design
> > requirements for a MSI-X table that make scaling it prohibitive.
> > 
> > So an IRQ can be silenced by deleting or stopping the queue(s)
> > triggering it. It can be masked by including masking in the queue
> > metadata. We can detect pending by checking the producer/consumer
> > values.
> > 
> > However synchronizing all the HW and all the state is now more
> > complicated than just writing a mask bit via MMIO to an on-die memory.
> 
> Because doing all of the work that used to be done in HW in software is
> so much faster and scalable?  Feels really wrong to me :(

Yes, it is more scalable. The problem with MSI-X is you need actual
physical silicon for each and every vector. This really limits the
number of vectors.

Placing the vector metadata with the queue means it can potentially
live in system memory which is significantly more scalable.

setup/mask/unmask will be slower. The driver might have
complexity. They are not performance path, right?

I don't think it is wrong or right. IMHO the current design where the
addr/data is hidden inside the platform is an artifact of x86's
compatibility legacy back when there was no such thing as message
interrupts. 

If you were starting from a green field I don't think a design would
include the IOAPIC/MSI/MSI-X indirection tables.

> Do you all have a pointer to the spec for this newly proposed stuff
> anywhere to try to figure out how the HW wants this to all work?

Intel's SIOV document is an interesting place to start:

https://software.intel.com/content/www/us/en/develop/download/intel-scalable-io-virtualization-technical-specification.html

Though it is more of a rational and a cookbook on how to combine
existing technology pieces. (eg PASID, platform_msi, etc)

The basic approach of SIOV's IMS is that there is no longer a generic
interrupt indirection from numbers to addr/data pairs like
IOAPIC/MSI/MSI-X owned by the common OS code.

Instead the driver itself is responsible to set the addr/data pair
into the device in a device specific way, deal with masking, etc.

This lets the device use an implementation that is not limited by the
harsh MSI-X semantics.

In Linux we already have 'IMS' it is called platform_msi and a few
embedded drivers already work like this. The idea here is to bring it
to PCI.

Jason
