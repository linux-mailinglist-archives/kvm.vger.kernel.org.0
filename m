Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A97139E615
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 20:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhFGSC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 14:02:59 -0400
Received: from mail-dm6nam12on2064.outbound.protection.outlook.com ([40.107.243.64]:52705
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231196AbhFGSC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 14:02:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ht0w1GgnBJalgJ26SvaY27McxtNeZdscH74gveDhLwA1YrdvPNnGeP3VIzPiCh8MlKNpdvBhw6FnjPcmIeDis2+XnJxKFO5OkTk7leIuWP58m55jk/emLYs5285WElMX7gKFgz8mI0DzyYtxH1ZDSdAfosM8OObgY2AZObo/ylxYVw2qWRQ5WQSYNru728EgbqMmRZALRzFXnrXFDr1aStZ7b+hlrrQEbLs7Y+LugkJpSySXy8kMg27httFKRTKUezQrBV1ovUoEoY/8Mh2HW/9xv323jgmPkupFEjsBOwxXspwIngo4NqoAZsmT5CPo6JVIzZMYuu7kcWRUmAtq4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nl9rC8EcFKacYV3yYUQc2grGv1xVZfV/Z7L1afImyks=;
 b=bY/sJPyIEz456z5Y2uEGU4/46EK1StFujOOMGUcNyxMbAHkB6iTN73AcMp5lmrs76xPyh8YcH5YsntMMbPdjooUvX94XvsV5tG9KIHCERgnlPy5aZs/yCrnwusFNi7LFF9tXgykyMqJeYsRFHOqs9Tn6igqkYzZuiR3SL9DPtVcf4WVMDuP7x6QJnWsK4YVZyTuVw66NpiGbPXLFZezh0rYRb+xB3xaxRmWtdo/bOkh/DFrWl/4PE6fa49v8kb8X9+KZMO8ySADmfQpmFkDA7cX5Ysr4jiS2QiL9Xd6+v3hQfNKJy4F5BlrGIr9vFb2+kiec+HeRB4qmvqsmltkVJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nl9rC8EcFKacYV3yYUQc2grGv1xVZfV/Z7L1afImyks=;
 b=PEt3xhAxfP3lc4N14VC0t0gBE+qm7Yls8gJnaH5A4zdpBP/AH+LqJ+PiuYzAXFUkHx94zCXdRetLvSe7uFO4QM/k0WMnYDEzyCEr6JFv5a1TaJ9OZjusronMrMBxdYXy6IbH1Ox0boC0YFhLSTvA/62P2TRhyaFSs+6YLz4U6BOQTlDXpR4/DZ9MlEQ3l1mTUwulE5Kqp+8VLCMpmicDQkkdhWQNkqjhCt1hMcaI+WfV4ivhDo9RJ2ODF/rUwozMaQprq3xuKmbH63ysJme4La/sSC4fMaQrGhMlrIkTWNTOUjMk+xLdMLpsjYKQX1VQWYTlCZw+oWlpBWXjj1CPvw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5109.namprd12.prod.outlook.com (2603:10b6:208:309::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Mon, 7 Jun
 2021 18:01:05 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 18:01:05 +0000
Date:   Mon, 7 Jun 2021 15:01:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210607180104.GK1002214@nvidia.com>
References: <20210604092620.16aaf5db.alex.williamson@redhat.com>
 <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
 <20210604155016.GR1002214@nvidia.com>
 <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
 <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <20210604152918.57d0d369.alex.williamson@redhat.com>
 <MWHPR11MB1886E95C6646F7663DBA10DD8C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <9dc6c573-94df-a7c1-b4df-7f60fc3cf336@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dc6c573-94df-a7c1-b4df-7f60fc3cf336@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR15CA0048.namprd15.prod.outlook.com
 (2603:10b6:208:237::17) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR15CA0048.namprd15.prod.outlook.com (2603:10b6:208:237::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Mon, 7 Jun 2021 18:01:05 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqJYe-003OmY-EH; Mon, 07 Jun 2021 15:01:04 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70b2a4b0-fca9-4632-a266-08d929de383b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5109269400427AB61A3827A7C2389@BL1PR12MB5109.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RGwJcEIOykWgKfBtTnBXcf+oM89qXU7y1jICLgRV4/D4za0bx7EDr9sSzcENoIlYHvUCpPsPwoii7vD+BIsYZjamh7xTaQ51e0QDDKxdAC1MsEr2sdiylyp1mzAddL8sBuhfG5UzH6CgR4f9drG8fXjzxmyHTDkC1CEUteexnWoCwVOHufmBBnuptSYflhHaUhgzXDV4rrNbVQsujFUZI4tagTcwbAbAKloBhEQA7aX85stFENHS/UzaXGLqroEsYEOtZCkz1xJO6R7k3ct5QQfEWLgYcXT/llMW3wG0DXXmwbmrbuiVcpCNrwd/fupoK76R8wkSkW6axM7nEQ5mnZqFkluxHHUqRRtPBRlosno6COx9UOGzsLsOa+qnxhXqC0dz23AFfJhoyM1dWIY4YBh9Nb4lXtl6PbRt5yCEyhEqs/omJnfYTIdS7umgI0E4FVtrN32sP9vIj6v7j/T/2MFoym82QbzBR6XNO+9ml/sB+Ga+JZRxwfbw7GyD3PJ87lFsHw6N99saZEOOJE1JalaF4ZS3CslpHasrfJYkstJdpHgK7+oV/1lSnRBlkPYbztzTAw6skKi/VaIhCanWofEjuHYm5HDnEa4rpKy9x1o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(366004)(396003)(376002)(2616005)(478600001)(36756003)(426003)(26005)(9746002)(4326008)(7416002)(9786002)(5660300002)(4744005)(53546011)(33656002)(86362001)(54906003)(316002)(66476007)(66946007)(66556008)(8936002)(83380400001)(8676002)(186003)(2906002)(1076003)(6916009)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RadfBjwtyZae319OhjidlCOStUG6jUovfX5jFljZbJyJ/sYLoCIs0TCPpy/H?=
 =?us-ascii?Q?6xPk9bifdW7QknWpN1MGmRC+bcUKeT4gNj1RZnhVmQDlD0GCsO0QL38nDEpI?=
 =?us-ascii?Q?naQBKLSBu173VQVSLehYKZhYwaodJO32rfLVofjWfAgagQ+Ufh0TCrOPIdV/?=
 =?us-ascii?Q?j0U69qykKKRTnzGCseSC3qlATS57Y6m6spsBgQbap8z1CJAwBo8Fj7cVodBc?=
 =?us-ascii?Q?XfqkzMrNvmEB5CViwsk7R9dsPNskBYcG8PmIkD9VIVCw1pim6CrSJZe/rC3y?=
 =?us-ascii?Q?Ys3hauc0V5Ln/PkRLxVnuKeyBXxAJnYgSAEURH2+0MYRvnMkxa95HLtNXNyf?=
 =?us-ascii?Q?n0MHaee3Nps57rQWpnqNzGA4EfR7KOJZTaOwANz+rQPJba+h2knNmmIhrv08?=
 =?us-ascii?Q?c20pfI1r1HzM6MYui9RsbVnACKHgjzGyiAfPkfT+3jjMwm0V41Ci/MhxVI77?=
 =?us-ascii?Q?QRzdE0a05NSSpr+43CQgCDtwCBL2NtwgEphI0f6ObgJFLjdiv8CI8x+2vClX?=
 =?us-ascii?Q?b8kcdubzv3lpm7Oe6S5qjuPtLWja/jfFE6eZjd90cp0Zo0Q0UzvpUYGHl5fE?=
 =?us-ascii?Q?vMUW0rgW2HHt2t5JDsHa8R38NoDsWBvjaNNwL8yKp7mvaTyJukFy2D36rNLV?=
 =?us-ascii?Q?4PzsdK/MRB/3KwX8iVWNDORhQZrbQsL5bkPezhVInC9hD5XNI0M5PC9x94nH?=
 =?us-ascii?Q?BeQs+VGPj61Z57YuYXSl0vdwYh/7USRZ/zbotJCRy2pxIYLI6DcSOldTT0BR?=
 =?us-ascii?Q?lgse6F25uzcZUAGyklvSRc/3ayMy2ckjcLkIR2iV+R0LixMQHhAPojW/xHf3?=
 =?us-ascii?Q?HK21S6c8YPBALCEnNICjFPQZrjnGQLXMRlZxNFheJ9t4fUM/AZD8woNkjjsU?=
 =?us-ascii?Q?Nu2AOTiRsKKHX7MqxHIhbShP6yoVZiQh0LLp6t21u4CzFsZ3qgIM9tlD283h?=
 =?us-ascii?Q?mXDgtr1Z63U/tsyO6hVQb+tF3xbKT0R65FYtEPJmTUDSyXPsGxKW/LS60CJc?=
 =?us-ascii?Q?OuaZlQiu48tZxGosNQpYwwqvkkCkIHkQrqY3ErjddTzuBv5Z00Km6Ow+3y0X?=
 =?us-ascii?Q?R0P8b3e9U3PESDHuamYErLLbmkhQ1zLjFC6YVAqkqBsFzPPZdQPx2WucAPO9?=
 =?us-ascii?Q?srnpHYfQKNosXCstf8t7OF8XLs2EvEZiCfBqpnzWtuQxTHSQUORB52K9yHsK?=
 =?us-ascii?Q?KZFUa+XG6YpKP9vPXMS5ZgC1SpihdCKfFsQN8IvVIUVUmFC3Ikz7oz6oHu28?=
 =?us-ascii?Q?2VbyRI8s0iuK4NGzHsDx6YZQL68PX39NhJ8cPF1zKUU7ie7nb0btxb8mdkFk?=
 =?us-ascii?Q?L+HOcSuOBoGBEbAYMdXMGBLQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70b2a4b0-fca9-4632-a266-08d929de383b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 18:01:05.4079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5zOaepWAscbeqRZ7fXxESPUQDztZUqwTFUY8bdCcRxiEoowGjYaDgeytmmopDZd9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 08:51:42AM +0200, Paolo Bonzini wrote:
> On 07/06/21 05:25, Tian, Kevin wrote:
> > Per Intel SDM wbinvd is a privileged instruction. A process on the
> > host has no privilege to execute it.
> 
> (Half of) the point of the kernel is to do privileged tasks on the
> processes' behalf.  There are good reasons why a process that uses VFIO
> (without KVM) could want to use wbinvd, so VFIO lets them do it with a ioctl
> and adequate checks around the operation.

Yes, exactly.

You cannot write a correct VFIO application for hardware that uses the
no-snoop bit without access to wbinvd.

KVM or not does not matter.

Jason
