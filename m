Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB011B64C3
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 21:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgDWTtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 15:49:50 -0400
Received: from mail-eopbgr30076.outbound.protection.outlook.com ([40.107.3.76]:64642
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbgDWTtt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 15:49:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/EGZokF+8TbeLKwBwhCBcznldoclQdmjnrH6UTKzax0W8PrwCEPRvKNMR/6EUDYxz8y/AjiRGcIU0bEENiQZ06VJ3gN4blGJMkDeRgckdGqO08kJE9FohRGlYFLAH0OE4JHKlpWsGNgtvzZuE1mtYTpwvVTRFNfHrk8dsvNIZS84pfQcMJx7HtGKatLUv4WK2syDm/UTJQGT6fJVcyUQd7nq7kHvJm89tm2rMa5dMr/Wt6alVWUJ9w1/T1Yj23HqhpjDfO9Btk+zEr72oqGv5RiIJ4JoAT4BHm5Q+W8RUipib23kKsmsEWhjPasxosyBUyTHzUp79TUJxYn0bq01A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzvQLkO/xld9TcDTkwpHyIBcJ5JZG1r9RwFegksu4tc=;
 b=lpF+xVec/+VPWofBNjGNyQeooG4YPDlg9qgQ+SmvIrBAa9OKCws4BmGPdv4zLWwhiflQmoJ9SAb05HrzlwhoOXiiFTlB4VPwbc93PtB4ic4Gz+eHkz8Iutq4nGGXo8FwkbthEWn1Chw8mW7WXdXsQW/zu9wwf7iZUy4y7JNdw1Jt+zrmml/RLiswnw6yMx57aPYlaGvySnesIXrJ4GhEM3Ova/dxIqVfrPFV0ibybAWK1akZTDg8apWR5DTvfz4+F7ekLyjeR8eefOLIQTfwq3PkaOZHYTU7+kO7OCyN6STvgdlHz59iFIV3TFwaxv95m9Eit+oiLvnqBV6JHUwBNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzvQLkO/xld9TcDTkwpHyIBcJ5JZG1r9RwFegksu4tc=;
 b=YC4VUDJvLbVubbOwCfDMRRelHE7CvzdMnZhhYVOgtQrSvNdvUA/kVUeIRr0OoBSa6IIQqmjwYyz9CbDbiOlO6cP4K2HbtA/7LCz15l/YgtkEN8JXFCAscExTtMQECdgHLy61yKxaH7aaMrFk2XtYyWPtARO3tmB/AOE3AvPXRZs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB6864.eurprd05.prod.outlook.com (2603:10a6:800:18d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Thu, 23 Apr
 2020 19:49:44 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2921.030; Thu, 23 Apr 2020
 19:49:44 +0000
Date:   Thu, 23 Apr 2020 16:49:41 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vkoul@kernel.org>,
        Megha Dey <megha.dey@linux.intel.com>, maz@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, Yi L Liu <yi.l.liu@intel.com>,
        Baolu Lu <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Sanjay K Kumar <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>, Jing Lin <jing.lin@intel.com>,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, linux-pci@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200423194941.GG13640@mellanox.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
 <CAPcyv4gMYz1wCYjfnujyGXP0jGehpb+dEYV7hJoAAsDsj9+afQ@mail.gmail.com>
 <CAPcyv4hGX5jCzag8oQVUZ6Eq9GvZYLN_6kmBAgQMbrBbNzJ0yg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hGX5jCzag8oQVUZ6Eq9GvZYLN_6kmBAgQMbrBbNzJ0yg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR12CA0005.namprd12.prod.outlook.com
 (2603:10b6:208:a8::18) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR12CA0005.namprd12.prod.outlook.com (2603:10b6:208:a8::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Thu, 23 Apr 2020 19:49:43 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jRhqv-0007Qv-1Z; Thu, 23 Apr 2020 16:49:41 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6c1c6805-27c7-4618-9885-08d7e7bf7852
X-MS-TrafficTypeDiagnostic: VI1PR05MB6864:|VI1PR05MB6864:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB68642978D0C435E4D26606EACFD30@VI1PR05MB6864.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 03827AF76E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(9746002)(9786002)(86362001)(6916009)(33656002)(5660300002)(54906003)(8936002)(81156014)(7416002)(478600001)(316002)(26005)(52116002)(36756003)(2906002)(2616005)(186003)(66556008)(4326008)(8676002)(66946007)(66476007)(4744005)(1076003)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G4BKlTir9utjQof5cK/oslejjp3p/Il7VAEAxorU5mOcIJzYCHsYSR0Q5cVtHOHg7qJE1KGEmR0FaYJ6rtspcDH+eBao1tgmHsROXcd709QzzpwIFGlOiN4UKjLMAT2VnP1+ziG5Snj+9AQuLwH2upLzeAxbWfRje2vDNpUl9ZFzS7qb8w5lqgueT1RtHxcQBEmcKfbr37QlHWouIU50o35EXej2J/HEk2sALfqEmXFeFPk8CUN8N4xx6tmflGU3nvR/Oc6+oVOwBp70sFD9Yj2Udrbh4vCOM+KIBsB2TFiyfziW9dNwMlje6QIHCtS/rM3kHpeaMqDG3f4YsG+Row1SLIYfdIbtnRkYMrAdblMMjpOnWIYrVXmlwdLiEmbqhqizWXYFpmJAGcWNDutnSxcj17YEJyLz23vYu6Ckup6IKHov9ESOWkq8vnikytigivcoo6w+PsFtWDj77+5758Rue+RUSL4ytROJzkM9pOjrq+m/gELafALBXEPXadNI
X-MS-Exchange-AntiSpam-MessageData: II9LNYqnxYZsIEhP7A7xLL4CSGTLq4DeqSqKOkOlks7Mv6v7nmYeQv9sUfo8kwkaXd/DhCyWpOEneOEf4ghkoU9T6YLvRGzbzNDY+H6hx8WpqGUJkrVNo7UwcnjBKXJQYlAy709+C263g8iDS4ilmQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c1c6805-27c7-4618-9885-08d7e7bf7852
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2020 19:49:44.4550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FQ8MP1TWp8zNZlFkZqoibUtlubZPm/AOjyLpAyfTZBDrv7SuKwykQag9DMjOkoWGZdJBVlzLUlEmaA0wIxDFWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6864
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 12:17:50PM -0700, Dan Williams wrote:

> Per Megha's follow-up can you send the details about that other device
> and help clear a path for a device-specific MSI addr/data table
> format. Ever since HMM I've been sensitive, perhaps overly-sensitive,
> to claims about future upstream users. The fact that you have an
> additional use case is golden for pushing this into a common area and
> validating the scope of the proposed API.

I think I said it at plumbers, but yes, we are interested in this, and
would like dynamic MSI-like interrupts available to the driver (what
Intel calls IMS)

It is something easy enough to illustrate with any RDMA device really,
just open a MR against the addr and use RDMA_WRITE to trigger the
data. It should trigger a Linux IRQ. Nothing else should be needed.

Jason
