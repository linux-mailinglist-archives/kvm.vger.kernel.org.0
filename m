Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94B93B2E3B
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 13:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhFXL6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 07:58:54 -0400
Received: from mail-dm6nam08on2071.outbound.protection.outlook.com ([40.107.102.71]:25600
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229445AbhFXL6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 07:58:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoRYqtsp4UjOBTDkZV6SRr4r62cncGZVG3M12CK9+CYtHKm3lUHutLofcNWRPerBwZIQdEFcEVK0/A3YCsfnI6BdufG0lJ7fLxCkn4wdcctStfIhj8TywEvseH7/T6XzmKVUvPbH4PHEtde1CaGSa0k51Av/lVpv+5BUSuucaRpYLYDk20t7iEPgCjya3BlM2lY+meN0RqzbB/mOUUO2S/Yw/jML3qU2KfUsu+yIPT/pQxHIo8jHtU3G+TqM5TD8y9uGPuhMqa3KksAy9NaUNkZ9OaIZzBuB+beJbNHCmH0kyF0bM4B08BV/F6JdAWKcSUdx94D3GKU7RrKj5PDBnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARzBKaXoTrSFCAiBuoYsEJfTmLYrid4HDn8r4GDP0t0=;
 b=NN4rjNPjYDe0/bHykLeEASMNIalUsTKlkFRnVsguQHZZLodleeKbKoUFF55g07Vp3cxciYgm3PbbXmaMpYseYjplB240qpn0OglTjQwqaMGBOofBnzigDVepyg0DnC1ZQiz5ciVVnWq6GJRpxTbrXad4rIQflQgxftpMS8EQvuxmjjBabmQtM1IdrStlgCCjQYJnUg4c7Nz55uEvEtIZFxCwNTRjQIYrnmyt2m5nIY0dMjJfv14dJtsRUQzhRbQs7824gEphuS2oNzB5nXGSZuzQlk9EZcaFmKGVUtYAMGL2/jADKjvF376Asy0QfgQ5jYc5qRFGh5SSjDNFC00qLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARzBKaXoTrSFCAiBuoYsEJfTmLYrid4HDn8r4GDP0t0=;
 b=IgprYvGFj5HTOv8C1QC72BKIJvng81/Oy0pZkfj8nelB+fY+CeKmCMsIoUssUJLz+RfmRlOHu0XKSKoyyBVIRyZ7MeFurHRDc6i+Ulqy1XW8WcRnFsimzOOumY2/UhOrv44/wP6s9gdPcQHBlSJij5idtcFfhph0KMEYaWRBp7187otgLGIDALBbhorOVgGZ98Cz8SJZWxSSN9r5mcKq2kFuLFDk1mDGdRHbWr0kjglEb79L9ZivnGLDbrZ5muMA2X9iwSuaNNb134EoDCcDhCvEr2dGn+eNuZRjAOXCyLJgY1tu6qUmiMfpwmrGgnGhPAnGrM6SE6ezsfsk/8DYug==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5285.namprd12.prod.outlook.com (2603:10b6:208:31f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Thu, 24 Jun
 2021 11:56:33 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4264.020; Thu, 24 Jun 2021
 11:56:33 +0000
Date:   Thu, 24 Jun 2021 08:56:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <20210624115631.GO2371267@nvidia.com>
References: <20210614140711.GI1002214@nvidia.com>
 <20210614102814.43ada8df.alex.williamson@redhat.com>
 <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
 <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMykBzUHmATPbmdV@8bytes.org>
 <20210618151506.GG1002214@nvidia.com>
 <YNQKKSb3onBCz+f6@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNQKKSb3onBCz+f6@yekko>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0141.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::26) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0141.namprd13.prod.outlook.com (2603:10b6:208:2bb::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.10 via Frontend Transport; Thu, 24 Jun 2021 11:56:33 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lwNyB-00C1gS-ST; Thu, 24 Jun 2021 08:56:31 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 313389b8-1ec0-4593-c0ca-08d937071c66
X-MS-TrafficTypeDiagnostic: BL1PR12MB5285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52851A78968862120802E6C5C2079@BL1PR12MB5285.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZZG5j/tNkx1BbxpQqWGKXQlQZFKRLqfpHHLYOgLIO8g01sYtSOHOO7P+OexLjdkqashllVrbIEr4otb6dN+ZRaZZxp8sIrPKqs2YJfJ52KnmwHG4Xh2t76aWixre2LlSCgRJOlp/B66gr7FyGmPJ/jIYhj1LMQ4sVOEsFYaYYOhNbuvXXHrXEaie1lVocttOaFlhjhJlfhVWrqQaAfq093TMQgmxWTAKVhJlBBDQSd9hWzWDWqW8kW2P9r5VQp3uYmdJ5MSVAzH3N4C0KUmBn+ghYNqVr7Yq0LdfSLf4MHLa5eXOgt9WISBb9FP+V+jb1LZiEdMaxcJUTD2AIwef2cwIJIvb6nDVlVRP/0Z0DR3TJ77rcpVIYa4T7+WLgxyPw/5NgAmjZ3fYGwm83WHFvrdDqhioqjrVWRVLmToE9VdJcjk9/kFWUwvmj8Zol7p98tgk2GVLXavqGx1ow6+SxjCgQLe4QeS1FRIpaoyajQzIWqWAfHkUWNXByOzHoA8AM74j90N48MwpBZMqa/LccwkPjqpjpZPGv52hY+qDVMzmWcVbX7RZs7MAssh4oME8+CwCfW10tqFDW9/4lFOkKwN8VerKGBt3eECdwC7ny/k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(4326008)(38100700002)(316002)(54906003)(36756003)(9746002)(9786002)(186003)(478600001)(26005)(2616005)(7416002)(6916009)(426003)(2906002)(66556008)(66476007)(66946007)(86362001)(33656002)(5660300002)(1076003)(4744005)(8676002)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bnx59wnAYKirujN5yfZ5GSI9f3M39jU3aJGopIEnd1MPhXi63w8fkO4v3in9?=
 =?us-ascii?Q?27G7QPo0PXGHMg4aSjsiFgNSFSjNSrkAuIZhtthGURCCmaFswus5TLW5Fn4B?=
 =?us-ascii?Q?A3HyXUwlMeLq7r06K3iJKljEy2nDzCNPiAeUYyn60DipO8d2DgvHnFUMt7jm?=
 =?us-ascii?Q?Gc2N7qqnbafIbfZpBYn0FvXG6j8II7BXMlDM4+d+YozY0BqJNnFKolWAxdjK?=
 =?us-ascii?Q?34YwMX59SEtDx3HjFr0w955Ljmb9SbFXfir8I8MxzO2awgiN+ocnMKslceBf?=
 =?us-ascii?Q?E8sbL31D3xcYuacRjOLfoinn2ZycfKagWrgWvHF+FcsBlFBXrqzcvt6HBUXa?=
 =?us-ascii?Q?qONLiH80dl7AwHOo4J5xzKMaxBXhY/yo2OPwEM4OcAeOnKcfXUWn3qNQ62gD?=
 =?us-ascii?Q?G204hCMmm+MPjDegnT7sHPwBJZlgsrxnHyHhcbUTLw7VeaU8n2GxJ7ggDrtl?=
 =?us-ascii?Q?waeQrhgQbpEtOzCAptelRO0MPhEV9t/TBKd3fH4Gv37ouTN/vytmSWhbO4+R?=
 =?us-ascii?Q?QwG8TmjggIDsmnaLg42dxuIp0bOBd1US19l3T41bB3A+9SHQDkkPHSgCppyQ?=
 =?us-ascii?Q?ph2mAIbJQ2G56OgeFW8FkT2XwIYKfLTH2kO85JaGJ16hvANdCY3LpMH66E4t?=
 =?us-ascii?Q?MU7VcoK46rv8LUKM6rUxevic1d30YCk87mqdyQD2ushrNSBOLzdtypeZ2fuv?=
 =?us-ascii?Q?yUgjLsSs6MBuATF99Go2J7yPBZF08kU2I0kmPjUy9DA+yygZ/dhPDNhdtqd9?=
 =?us-ascii?Q?LYL8/nTmVebkgsXgo3mirhc3rs6WeKmrHg5RGAF9oxLTSVbL+m9wI5cjDQux?=
 =?us-ascii?Q?GzMUw33/64tqKl/B3laOzIZRnNthIzO8We0iqjEhVrX1ullpeBQFhcq58ECN?=
 =?us-ascii?Q?hElr7owaNFJA2hVj+NByvtapoSVEDk56LkjW8yV8gv+K68rNLYHrUQb76AMz?=
 =?us-ascii?Q?4GtlHJu9arqXx7o20Jntd2fwr3jiTP46nwx04tSzJO4RXqednvOKV9OpTYOZ?=
 =?us-ascii?Q?db2/yD0SQmLXABur5bK40Jj/FgWKJNB5d6rAc4zkRVqdREZ1WQeNmAozETXT?=
 =?us-ascii?Q?mcxaGFJ8WX6HWMwixvaCu2fkT4bwAvzsFrWx8xKa/y4WRl1CZRtw7rQ0jdyd?=
 =?us-ascii?Q?LQ3MbZ3INlG0LZ88AMzRWZPXdhnuQjStLZ6K80V86AG7X57wPtEXzbtNHoWH?=
 =?us-ascii?Q?fYwAnAFUU7s98GINl5lKB0Ayk/+stjeC29ZAd/ASEA6Dxhv3fux/yqFHmwHq?=
 =?us-ascii?Q?WjiWq7W9ncqfVY2ufOP0AImYUrjRYfkfKECN4UluRmv9zIq0lVHyNePgnbHm?=
 =?us-ascii?Q?1V5+2iE7hYfDiDGRAiM13iyJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 313389b8-1ec0-4593-c0ca-08d937071c66
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 11:56:33.2601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DLvR/S3XZldb3qHXS2dtvXhKo6xnjLrn424w1oVwC2ftcIarh9A26JpOZBw2/ej2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5285
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 24, 2021 at 02:29:29PM +1000, David Gibson wrote:

> But as I keep saying, some forms of grouping (and DMA aliasing as Alex
> mentioned) mean that changing the domain of one device can change the
> domain of another device, unavoidably.  It may be rare with modern
> hardware, but we still can't ignore the case.
> 
> Which means you can't DMA block until everything in the group is
> managed by a vfio-like driver.

We just need the same restriction as today, the group fd will attach a
domain under quite a wide range of conditions, and we can copy that.

IIRC is not a requirement today that every device in the group have a
vfio driver bound to it?

Jason
