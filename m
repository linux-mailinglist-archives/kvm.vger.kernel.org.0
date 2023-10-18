Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD877CE1BD
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 17:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjJRPwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 11:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbjJRPwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 11:52:50 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E015B116
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 08:52:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9NDaM7iR6/MdLg8ydpWFqFen6xz5UV0VF70CjbsbqMJdV8F17I8lYrZ/C2LvNvLSDJ/L0MTSP5JxHqSWYO5dd9l2SnzW75K+9dW7oJ/yCKmht2flmQWZNTszLBH9WP3n06S2fLPlEVjxGKtk4FNlj/Bu9oZf3hS6iH9QZdTF2VR3aNEQE1vwefX1tc2TbP1o/AcmYhBL+68qlGgeDR6XUNE3tPOXa+iXVM3gwdSRcxMMxLXhk6jGtul6/AwZiox/81CJ5iviiOLISCtiot8kJckFuyvOlGLqg8gbwDK/ryv/P4M209hNoyzsE6thWgzRAfWzGDM+jT56ZfDKybh3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cav6Vz+dL+3Ymq3H7dM7sbLcyHvFYAWzYce/Ep42ZyY=;
 b=J6djxtvL/wglNMBndkSydofghCHyJX6g88YqXh6mRXBu9XaZJezGFIuGSC0cnxBUhKj19vQcvxknS/mAdTplNBVXpUgdczz6GEUtijLAbBkWfJHnB63dmeZn5shk9KBGsI6HosROK8dyxXsHv2jh3AaZ8Y0hK3TCeVRTKNKfV8OzHSWJL1pDKFKEQ1XaNf7tabI0iD0syKsFWPx7jZ1zYFpq8E5sKiljWTKXc+1yyW6PqD8MVEHexojb1ziF4oZFDrvXwcTgis2e3j8TMt3qnjhDTC1b96g8tjpfuIFadzxfcL1zZVbWlYu4VtQPZdyEYIx1PT/+qVZqsOcxZEZ7FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cav6Vz+dL+3Ymq3H7dM7sbLcyHvFYAWzYce/Ep42ZyY=;
 b=rr2ZI8UBzBFtquUybJhhg4XuCANc9LSeuVpGTgDJbxCbls94U9Os89ba9gaKk7nHjwep6JjtRNQ2EhofgWHuoKWjcBQzwfstxSdYpNtFQUgd3axzalwC3lMwjmSviLbtL50vGn+D6Cqkq2Dle9hQkAudTykI4RY+KZEBoh3GciFiQDrHX5OM8tzTXy6W0q0t+uZrgvRRQF2SWUiubah65lUS1kf5b1oADg4j60LCgIH3KxB4CB0wU3U0g2pitL8iHvC02LJAVCKxqhHaOIZnC2+rlAsA7uzWb+xSJkoRnvSkIIkMEUWVUnDIm01MmduUrZaXl5cJj+lk3XqySEjE/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7933.namprd12.prod.outlook.com (2603:10b6:806:342::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 15:52:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 15:52:45 +0000
Date:   Wed, 18 Oct 2023 12:52:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Vasant Hegde <vasant.hegde@amd.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 18/19] iommu/amd: Print access/dirty bits if supported
Message-ID: <20231018155242.GY3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-19-joao.m.martins@oracle.com>
 <b7cb98c2-6500-1917-b528-4e4a97fc194d@amd.com>
 <e128845a-c5f8-4152-9781-cd7b5026ea8c@oracle.com>
 <2f78d1c7-694c-154e-51d0-4e3cd9b9b769@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f78d1c7-694c-154e-51d0-4e3cd9b9b769@amd.com>
X-ClientProxiedBy: BYAPR11CA0083.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7933:EE_
X-MS-Office365-Filtering-Correlation-Id: bafcdfc5-fc75-42c8-a88a-08dbcff24534
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oqFUyuFIs11ul7rm21KhybJCtwa6TW4BSg/g7IH1m4wTbcauD1TGteuUKiJ/LRqgl7e2f6r/kvrBYXugHwiQxS1bpJW0Ziwbg2qfYasIw8lvUBlHg+FIlywgOzblkTSoEitF4OVrMWtWYYnV2ps5Tqsb4Z1quqHTBsiX/lUyTQz42nxQ9PXJr4wY5UKyDuehJ/PMjhVDd+Ea8E8tHLxHmwVPK9AJm9jdHwnrlBk1LVS3/iqmpNgZbxCvyANwYb0VxzSeg7fKqlCGsqclmHEL/zusw8rDoIfl1QrjoyMTuoRkBArLGemgE9NPs4B6MQhf+zRYY1kELVOs1H41gW/IruvhYB5T8LW0AwlU+RJxEI2It7hi38FsX9B7K2+I8EQvQMKYTbVg0B/6/mfpPn3h5YV7IXVygWmM+s2YA5f7mv9JSrAE3ZsE0EpoLpyi2zaDoSR5NC+sKbuvNzkFi+Gnw5EVrizKotXmXT/bdoyZHf5vLAc3IGjvNEwYj3Bz/iHsxvIg+MJ1dxZVSCQC6NrEbcvyKIgPA+LS0Ekyxlb2qJFEpo5Ust061QNBpawiE4/QpZ8/YFWsn54zbghT9BYKvrm/U1n/FnKEnk8qsvQMzZo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(366004)(376002)(136003)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(4744005)(66556008)(6916009)(54906003)(66946007)(66476007)(6486002)(478600001)(2616005)(36756003)(6666004)(26005)(6506007)(1076003)(5660300002)(33656002)(6512007)(7416002)(2906002)(8676002)(8936002)(4326008)(86362001)(316002)(41300700001)(38100700002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QSBwM/59xonPATRf2rr0jp5Gelu6/cilladYWd9iOSewdmSj7S5UcE2iOyDN?=
 =?us-ascii?Q?+lxhGqy23gB9uFdvXMDVyITX+zGg9isjPpsdP5o/6aKe0YIWSOCj15D1GuGD?=
 =?us-ascii?Q?8lyqDO36x95V6vs6ZiFQo3UfcQb49cuKjFIM2TPlo3ff+PZuMMAo9tP4s+iF?=
 =?us-ascii?Q?1Twj0dTZBlR5xdT4JT5/b32RcuUHBUhTAJcBJGKj/ZpMaiAf27MuaNVwh97B?=
 =?us-ascii?Q?U0e9zArybarg6qUlJP/YikxrPRxpRpYw0mJITYOuLZxx0E5+zCibH3gg1CMl?=
 =?us-ascii?Q?Xu7DHQVajSN04CzjAzzDXGVkCnwQCrjYVdXQk5ZR74GyteM2s4tVpe8zjH1A?=
 =?us-ascii?Q?lJwCQUCE/CZQMfGKH7ztGm9XEV1tDakz+DLDVvFtV4t6CAKOoNkUwPyG3qIO?=
 =?us-ascii?Q?TZJOxmPJX9kT5BIymEMkTjLnyuck4TTt+Lzobfc+Y+7osFB/sw7V6TnBCGmG?=
 =?us-ascii?Q?p/kwypAvkEmA/3u6E70JbIH8b4agRiM+BLtEVQYiu2PYoPVrrvP/ttLahWO7?=
 =?us-ascii?Q?J5xaMLQBcTWQFdbOyY+n1MAsLR0KGVZbnywYiWOsYdyx1/P5h9irzWbzJhfg?=
 =?us-ascii?Q?0NRJVejslnGuewWDi1hNwqSBTtNXRqdKzJUI0y+XoJv7RD+hO17pct5I/PXB?=
 =?us-ascii?Q?PK3WR9dUl9VKL2nBtfo6CTmPHR6qc1263REZL97Eve/N9Iwvx5Klarj3KEfm?=
 =?us-ascii?Q?hgRaAVh53p+AQLRfJv9fyFN1m1C274B7mybyw6eYJ7/Px4Z5lNgedZvQEP83?=
 =?us-ascii?Q?NkvbMYbt2hf9CZ9bM/O0l+taV4ocdjRN/vEU/wk5M57qURT2ufcQHy9Ng/24?=
 =?us-ascii?Q?jGVIyxe2wkwfYPEaoRMCzShYkNMUTjSBubLUkKXRMgm9H5QJ/jL+RthDWc/+?=
 =?us-ascii?Q?1IjATDnkeWUoTDIFjq846o6FA/Tqkh2Ul+qNwF+W0pUldV48qycwpRrEjhvV?=
 =?us-ascii?Q?5OumOymfz5Bw4PKywcwCzv0OOP0SIlO5orlfEQDhGDjtZkG0pPpbgXWRRAOC?=
 =?us-ascii?Q?TcQAxtM5cYu5ty2CRI2x0oyCs95fU4uCZMQ+q8KXxFz84xP//TWC5rAGAfrS?=
 =?us-ascii?Q?XnWoUsTrxNDGflegi3Qm+8cIF0WFEOmtOkGS80wVTp5nXoo4/58Em7VBcuIl?=
 =?us-ascii?Q?4U1IAFJty9/obt1rft/hs9t1EiCr4Qsl7XqccImxllYsZB7EVfsy3cZWO6ce?=
 =?us-ascii?Q?2y0dA63asPM08dOqX45fTA1vURh5ZGjGJIVKk3Satw876CCgI6eP4eUeda7d?=
 =?us-ascii?Q?HLX0fgmUifHSKbO0yLXjzPs9FFHO4aeQH65WaJ1U/hPGErKM6l0FQoieoOfW?=
 =?us-ascii?Q?4bFiK4LVOZuAj7Yz7G8adBtqQbtPbGJbMQU0tXKHHTHEYoYr2r/diXwnsgzT?=
 =?us-ascii?Q?r1ifLdjf/UdVu2a4cFZASlJ6d8/SoeQKCQq7Jh2e3gVcW7sUwj7PEF70sS4v?=
 =?us-ascii?Q?8nZxgfnZLBgwR7u7fA3Kzhruz/pgXsmLFOROQMyePxCJx2nCjXIer5NZZwW6?=
 =?us-ascii?Q?VjwPaf4T2V2d7FTvLTygLVEPQfK8gQ7pCzRB2sJN1HOLx5SVOgPzLFZA/qFY?=
 =?us-ascii?Q?3f1KRpZLjSvyqaF7mQgET+uYg9Jqfqhdz7eZ3M4P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bafcdfc5-fc75-42c8-a88a-08dbcff24534
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 15:52:45.4953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LL9FSKiL7GL6O1UXQX906/5NGpSOVY4FvLHBYFqEMXWQlw2gvyqnmCMzCcCAZj5l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7933
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 02:33:09PM +0530, Vasant Hegde wrote:

> IIUC this can be an independent patch and doesn't have strict dependency on this
> series itself. May be you can rebase it on top of iommu/next and post it separately?

No, we can't merge it that way. If this is required the AMD parts have
to wait for rc1

Jason
