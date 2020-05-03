Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DB91C2FF8
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 00:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgECWWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 18:22:38 -0400
Received: from mail-eopbgr10075.outbound.protection.outlook.com ([40.107.1.75]:8865
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729151AbgECWWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 May 2020 18:22:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T67+1QR/atfukvCt3OBOFoVbJZ9CTd/RwO72rL/FjKuRSscKxN0vQ4mZ9Z+Ny1ZkIAfGGgdOkJvQa4FH4qVhI7kBV3rC/d055+/0/PiMRRhfKbUq7dRFmNsXqjjEhHwP980pj/Cq5LQ5KGLxgKlFo28BY2ZdSJJO+wm3j7pUkEQ3hd4ipbCCpdMGCAYXXDMbnFf7817DDIwMr00MiZpX1RwtYh6XW3M1LSGTrqOWNoQXJ2fVdudD9sAThgz9nDi/npwTto0hDbs01IbObp10br8F5jnrJj+tBOMaYP2VHcuq6g9JtrnS2ABBpiL2cZFB4r7pP2PyiFURCy+KuadZVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5OmvZaYe82iEsILDcpHVl6CFb4nh3Aw5jI+Ha/B+aU=;
 b=P9Y8M8WJG1hng55aZ1oLdxbQX9UKe8xyO7iOd6IAUGiYsFbzNi4BSGeLDEcbXHvUbaKgK/k8FoBGDEaX/XcJZ7M3e605UhqK/Onjm5AQNtBqPLrjGoyWI8LtSJFJoQ1T3sO1IiXpY6wsZfhmkgDKP85v/HTZ+K3J5fibio0GJnfJ10Mvq+sVhKFKZZ6qQFiPQ2ZxLOjGENzEJT/7hsuCxoW+bOpDtLWC5KTPB19AcBqYAzdhVrCBWFQ7oL37dM54g0ZyZXSigH3jBL7DaqDs1HBlaH8hofIzBW/JL5qva05wf/n/3GeIVegRyNW/2wS09lb4ZI3tcPXFGKCKgEBdSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5OmvZaYe82iEsILDcpHVl6CFb4nh3Aw5jI+Ha/B+aU=;
 b=LIQA3qhDKreSBSl4/WjY8GavwLtGjIKgBQJhf9RekQ7WqxoPTe2IsvayA8deTLhcskm9hNO4gJBtQWI3F9DTH2/eRjohstmNFY5zRtR8mF7eD8/ATXkoU5qtb1d7+C17Y3oiw455NDVKWqx5ev7PwgWPr0QYHtwnzqbyl4vcRSU=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none
 header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4157.eurprd05.prod.outlook.com (2603:10a6:803:4d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Sun, 3 May
 2020 22:22:33 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2958.029; Sun, 3 May 2020
 22:22:32 +0000
Date:   Sun, 3 May 2020 19:22:29 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Dey, Megha" <megha.dey@linux.intel.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, maz@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, Yi L Liu <yi.l.liu@intel.com>,
        baolu.lu@intel.com, "Tian, Kevin" <kevin.tian@intel.com>,
        Sanjay K Kumar <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>, Jing Lin <jing.lin@intel.com>,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, linux-pci@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200503222229.GE19158@mellanox.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
 <CAPcyv4gMYz1wCYjfnujyGXP0jGehpb+dEYV7hJoAAsDsj9+afQ@mail.gmail.com>
 <20200423191846.GE13640@mellanox.com>
 <098aef60-35a4-dc44-be07-ea43c1a726c7@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <098aef60-35a4-dc44-be07-ea43c1a726c7@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:208:d4::31) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR04CA0018.namprd04.prod.outlook.com (2603:10b6:208:d4::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Sun, 3 May 2020 22:22:32 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jVN0H-0002RC-Dw; Sun, 03 May 2020 19:22:29 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4278179e-0f57-4139-b294-08d7efb07956
X-MS-TrafficTypeDiagnostic: VI1PR05MB4157:|VI1PR05MB4157:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4157F88E2BC85CA94F7A8D03CFA90@VI1PR05MB4157.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0392679D18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P2LemrUTFqhaBidO6Ar4BRy1OXzEnJwvC5+Cv8aDhCE1rv+6IHEJPrqaHhYpilPKPd37pI2Smb0cvIFfTTsTLjMSxVKikBG7RYGd9psMh4qjfHWMKWs9ZfsvQnyA8GhGReFqY5+CCWSax904G6UlTGoL/xryu/UEhvtgDWUTYDLKHT5bT88PDWbFsR4ZxHT54RS3vmAo7xcWwxDLTD8YIGeoHbgYHU8ofiXcDa4J55a4MLZxN+fdS6f6tT2cytD4PzwdUHCKlIshgjmcfNJhumUKEekr+K3Mrz/L2RI8yREHmdHGemsav1IAFi5/FQ2xa4uzfzH4lNPdCK9T/LRFDaMRbvwSyyL0GLhmhfeyZUDPnCaL/jY91cdY2wVNzNQF8JTIIX3zPqUXTbc0RAyjblLbMgA6z5NGt6Ln3XtVntHrn/M/0U5ycLUzNkKmU2IQdzvVzWtwG6D/VBrrevsqmSHZCaoYZtE396dcMYEj7U7WnY5GZzLfV3mSYOLWhvSp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(33656002)(54906003)(2906002)(9746002)(9786002)(4744005)(1076003)(478600001)(52116002)(5660300002)(36756003)(186003)(6916009)(316002)(4326008)(26005)(2616005)(86362001)(8676002)(66946007)(7416002)(8936002)(66476007)(66556008)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9GysRJozWs3nhHCPOWWtnuLGnuIpZH7X7RP0e+/sMfY+TmNHH7cjUSTIRxmk+UHG8YSqfffpZdOupUuxIeGjAg2/c95/dSZXIvulAam/Pl5WNfWg2fMcPwNDc3NETmYtoVH5r1tshOjPigQHln1V6qqd6VohTXMvcxhLGMOvfLzEksiBC/5rMaQ/SJJkG8ORsrq+eT7U9ThUrw14qhZFNjSsGfVql2ise4VpKvx3UnK/NgRtJPAJJjwjTTbN0ExCXVE7sWI/E7iD6glU+SBbPiBD1QlUJCzCW7Pq6Jp+Ru77Ia5qdSo3yP/T1X02OsSUu3a9phqgaIbB7VkziFhpDqIg4nbjGPXg1ovY7Fn7VBMCmt5Pk8gaJCzTDOVhhVWAC23WwQAchaW9hCSDanqKWvPhBhZOfu9fx199NSFtVK1hdYxjAQd7haPR4Cq8gaqGB8gtKqoiicvrHTNfbDpWrxZCCgoX/05Maqtit0W/U0L5TGDLBHmQXa+2iCkoRKdfXreq0L3AN/bFyLWe0gudUT+xtUA3vOEDGEriH+w1OKnO56fT1sBy2XVAqATYs8l71v+3UDQ4bC2aAcx9U0H+te+aJOEsMRFq4fOQrvxJIp3S8dsiAMVHiy9ulsl5lG/TQlg8XvkTQeE0OXvjiLX1usK+yI25aRqZfHoLmsE+vdXn2WNenbN7eQ+j3LN8IRYohWdmAwqnb3lTyY7u77LMySwXzovqnu9rPmGpDbckUY/S3IhSpLUqQsK40Vt8nuiKIDz0J88F6MjEjTyqCu1I8a2LY1/bYScWHfq30UFfjhw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4278179e-0f57-4139-b294-08d7efb07956
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2020 22:22:32.8070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MMKu3pduSlpij2lIt6IfPRW1Ux7/NcjKZNefx/eSaxxDgm6zWMEb6fN7HljDlgjBgKtHW6gIVRvr3qo4TAFRNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 01, 2020 at 03:31:51PM -0700, Dey, Megha wrote:
> > > This has been my concern reviewing the implementation. IMS needs more
> > > than one in-tree user to validate degrees of freedom in the api. I had
> > > been missing a second "in-tree user" to validate the scope of the
> > > flexibility that was needed.
> > 
> > IMS is too narrowly specified.
> > 
> > All platforms that support MSI today can support IMS. It is simply a
> > way for the platform to give the driver an addr/data pair that triggers
> > an interrupt when a posted write is performed to that pair.
> > 
> 
> Well, yes and no. IMS requires interrupt remapping in addition to the
> dynamic nature of IRQ allocation.

You've mentioned remapping a few times, but I really can't understand
why it has anything to do with platform_msi or IMS..

Jason
