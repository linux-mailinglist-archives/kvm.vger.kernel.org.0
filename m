Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504923F5DA8
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 14:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbhHXMJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 08:09:41 -0400
Received: from mail-co1nam11on2062.outbound.protection.outlook.com ([40.107.220.62]:25536
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234787AbhHXMJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 08:09:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxtJJ7gBDKbnG/+HGW8IWh71tHcqI5CqO5YOiWVf1enGCDMlsvntKUmXcFy+pmQ4BShadlcELehhcNS5jV7Qc6PEWqUHDty62gxbj/T9EannObDkWF2vAWlhV2pdGSDY/l6AGt8gDUP+Dfv/uu4MTjVtweiTRmGO4QfUe3zWFzhHf0dIQD7jHr7lUGYxCVDl0vS2FC9gNw7V2hSec95Mcnfe1hxu8084EOlZyev3BLmv4W3or5h6iHQAKxvpxI61B7fYo05ohwbTjlSuG8vTqQ91nK66l/ZB8nowS4oxmdsEocs0tAP1o/V+o9iucIKYMO3MmsD5im4GAIGim7fXjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLW74zCp8OnlgNrV1jk2i92s+FLa7FPC161Z4YhwZ2s=;
 b=odHFBKpPzf8d60RI5HHclVi63k/8ggCiOvWV5pKn0zQkqWiC1XRpoQGnbyFfUrQPyMF8qoFMLjIuVKgbWcEsYDP0kvx5uUY9PpeRpT37MOp2iJvir+nfUYj9eTBFU5GHF+gmPUvQf9l2KYg3yOUgVqYoNwqlHHEfcBFLTdhmITRbOJZLN99lo30RZ2IsYCcvdRkPidlJ5sK0SnLisnB6Nr7t371DVuII02yl/mdtf4zSJ1leAA/BxzGSzXUDQyCcUTs30RoIF0Vh+jgfCP/0Fgjt2GsZtNCbECBf0kXlkqwhx+nOizzJ6JZokQUY9ejAMtDv0+7nFR13s3YJehM4YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLW74zCp8OnlgNrV1jk2i92s+FLa7FPC161Z4YhwZ2s=;
 b=JQuNQabyhIOeDbB8yiB/3YTHpTu5eiknWOtOpjLaY3NPB+rsnJQJnvUo9R7jga/uHkKm2vX07dxRaHCNwmbTeTFaUCu0lX+AyPjsWTOXQXZnPjddpMgWyQBJtSO/TenupdQi1dF9s/poCUJ2Sj1IfwL+PN/Lpt4wKzhNrnQTOIUIi0eVFGgEaSCWwdtAtRHTTQSqaOkSvekHXqOe3D3+UEnklu++wA6j/fJ4CG736Cy1jx/fJiEDmfD2VDYCkdBkHKunxLcGe32Srsugt0orJnSQOTPkQ9mHKHE3NBroFgFiXVWsRacxAz6u5D0eR1UqlBR2y/AVDQAAQM07OU5MQQ==
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5110.namprd12.prod.outlook.com (2603:10b6:208:312::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 12:08:54 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 12:08:54 +0000
Date:   Tue, 24 Aug 2021 09:08:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: Re: [PATCH v4] vfio/ap_ops: Convert to use vfio_register_group_dev()
Message-ID: <20210824120852.GS1721383@nvidia.com>
References: <0-v4-0203a4ab0596+f7-vfio_ap_jgg@nvidia.com>
 <206c91b5-ad94-06d8-f187-d55d8708b7b2@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <206c91b5-ad94-06d8-f187-d55d8708b7b2@linux.ibm.com>
X-ClientProxiedBy: MN2PR22CA0002.namprd22.prod.outlook.com
 (2603:10b6:208:238::7) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR22CA0002.namprd22.prod.outlook.com (2603:10b6:208:238::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 12:08:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mIVEa-004QJA-N4; Tue, 24 Aug 2021 09:08:52 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ae90d36-4be0-4a2e-3f92-08d966f7f13a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5110:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5110A4CB4354462F21DC33B2C2C59@BL1PR12MB5110.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xb+YMUsGVnGdnESDokC12K6aqFdgkK7/P3oCjo4LCFAyD0qRvXH8rBtsdg8yXQpnZ8fEg8/rwRC6us+Hq3ePUl0JNhvq59yjVxMt3vrlkMR4igrtybbSgjJ8ERjovlviO42Q2nh1ba0WZuvcxcD5qKeXRpjN4GKs4z1xBSC2yON5eNg3ak27xAIVMlqy1LdtDZ51ldTlDHScmyRRsIKiU3oa208uQe40p2M4sP84T4c6zO2LBqjB5KPiWAPOcp7QDGcbNTNLnqmZeTI68WonYK0tqG5Z1cx3977K/NxAujrj5bik0rwkq8Ma72OqSWVVxlH/PeUo+Jmgef61j3GaSKOc7b1crvX99HfNXF1nmY/gwONkfX/o1KbBhpt+JknAH8MxbyeBiscIdW0LbhiumT8EEoAZk2rN7Z8ku1ffgy8XgrjJbagbf4wWPFP8aEO/Ts01NA1xkQCnwqtRnc6HqLDRcKwEmPLOaQdkkH4MFvxQXhQZL1fCrLbYzE5iMzebg4QAanw1+jw7rqJUYq1Wyf4jK7nBN5m1UFIHHW2VW4xOYuAVQtXjtlVluxWjYonKp4YhyKAFaLibg1II3Jt+t12uTXV0bpxGU8r8kW6UyS+9WthC9ZIhhgkK8228CTUbK8vsuJY7yjlc94UJaI3CWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(54906003)(36756003)(478600001)(26005)(316002)(8676002)(4326008)(8936002)(6916009)(1076003)(7416002)(38100700002)(2616005)(5660300002)(33656002)(9786002)(83380400001)(9746002)(86362001)(426003)(4744005)(66556008)(66946007)(66476007)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NTqoPHk6ggazxUeGmzyzoEjKDlzqbxhP+8eFMKIapBbNw1pnR2SFMnYVaN2x?=
 =?us-ascii?Q?sXRQ4vvpjvsTNsUHQ7zH7YYHMTq7VffCaae+rAvmRWgkdeU/+LGyFqVvrj3r?=
 =?us-ascii?Q?vtS6S+PAYAumuwHGaWKirA2SONZEsXoLI9xWuuDwe7qmryNOQYSvporFYI+f?=
 =?us-ascii?Q?VNvGn+qba0mUDKiVweBaJXvdV1sEkAarZOLXa4h9qokPUU3CQQgzvAPGfAx8?=
 =?us-ascii?Q?8tDeNPk9hLc/n1B3L3bkoy07KMjGM6Hb4k3YPPSuD4JiEQRwg4k5c7jV3YU8?=
 =?us-ascii?Q?GAtPcTP4vaZTVEhBPiMqfMUg2Ig6nQJbGD+M8PV/zUkvm5UIzxypsArM1aJT?=
 =?us-ascii?Q?bHadcMIn7kjgUuBcOCIK6FyXDNRq8UkQnay6ieYDrVIadaPPn5PofHW7AFMV?=
 =?us-ascii?Q?vDnzXzB/I4AACg3WZMRdJgeZ6X7Q/n/vjOS+EJc28ZqdSV51x9wWYBuUluR8?=
 =?us-ascii?Q?K3/diV8j5rL05Flyi4iEMHsmcvuU1ExU+yay1CMPJJPG0voFlQUa7T1c4Nex?=
 =?us-ascii?Q?E5LifZeyC75OodhoP+9GU7GHrtzbkDtp1pQfmoBinK7l4KQiPO/CB8LKbqMg?=
 =?us-ascii?Q?ViXaGqhQziK1LAtekdnyOqS6FzZ80t6ylR6O+BRYChH84w3K96O+LWYFXGpV?=
 =?us-ascii?Q?JMRiu6B6ZPBEtLvRRAaA260UdVLFEsj3hEnKJ1i0X6d3odGk+xuqnZLQSnSR?=
 =?us-ascii?Q?EMT5rBjNc5fp7hRgVW0w4du0eN0pCC0d4VwbcvbJM+kszAoaYNwbDaD0VbWA?=
 =?us-ascii?Q?WW5WfDLWO6hClEJLwZbhPrwsB7GDxGAH0hju2mKnsVkiIYFjWkHHcP+RpqY2?=
 =?us-ascii?Q?XD82o4IwC69rqd3M9tRBeLxCG/zOkyWhcQmn7za/1YDhHpqFOK6EHoBF4qWW?=
 =?us-ascii?Q?gIH6cB6IzdcHNfljYbo/ddubep29mPVXmEoti8Z6z/aQU8iR1o1GjUBkGRyJ?=
 =?us-ascii?Q?HOD3FSRdudoLmU9/9eEYTiQ6GIUvWTTZyjEDOhDy3dhUNAXlLMEns4V4Fpjj?=
 =?us-ascii?Q?pSFPFJLFqjtXFNEwzsfMF/jNCuEo+BgoP3Eq71xVVm8O5fvXwxFoyBGotndi?=
 =?us-ascii?Q?2Vcvav491sBOb3PZZklLQHq6OFQLYUTUXKwsZ06UJfZ3SNaRZnjhsMYUF4Qz?=
 =?us-ascii?Q?GXVUUE+2zG91+Nb3vQSYlYfrRUiF5DudxLq+uTKIa1ZRpNIAgRjJ5RhIgqUD?=
 =?us-ascii?Q?oCO8hoiQckBjpVZ4hJQnxyKOqwxGgg+xIzcWCjtVEfD5hxbNgoVOg4tpl9+k?=
 =?us-ascii?Q?0CGmPwHUne2oRzJ/Q2lTnV1unIzXzpibH1g2VSh8Rjcbsoj6JY0/L3gqBr7Z?=
 =?us-ascii?Q?QexegUK2UodIp5GgPytSUEmU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae90d36-4be0-4a2e-3f92-08d966f7f13a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 12:08:54.1340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aL0maZhupeHiLIFNiblocrviCn3ZDVEUstPDpW5hWvAlwsQCPBK4f6rysDir/9IS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 23, 2021 at 04:57:30PM -0400, Tony Krowiak wrote:

> > -	if (!try_module_get(THIS_MODULE))
> > -		return -ENODEV;
> 
> Not a big deal, but why did you remove this? Isn't it beneficial to
> get a message that the module can't be removed until
> the last ref is released?

The core code does it now

Jason
