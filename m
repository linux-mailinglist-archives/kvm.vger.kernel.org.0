Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2E7472D2A
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 14:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237389AbhLMNYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 08:24:51 -0500
Received: from mail-dm3nam07on2079.outbound.protection.outlook.com ([40.107.95.79]:19457
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237411AbhLMNYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 08:24:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOTZnzBNIU+Dk4+uTKk5oAnfEtlLb1da5DJablClJEj0ywafgTJmCV8Z9XH6heTZud62aXOh0SgQZXiswUQVikSiTrMHjJvjbN29jzXqvusXQXqm4xi3+ogfIGQByjpuRAPjSxb7avuXbq78JunbgdtgCAKpTnAWoyI+SxtegcaN4Oo3Orqr9miSd6IdaeoHeMUVZi8RFrkLxVcMPZTodStRh/u0cfjvlurAgGo10C/p3jh5PobFOCBtnQJ53i9zqGAWhAusMBdMB4Q0RfTZVEOk0HeLC0itwSJcH8bcthwaOeYc/BJ728+UsTxtiX6QMFdMsd4ObW3/Rlo1ym59pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yir30ALPdw4GZhG7Qt+eng1cFM16ldlNqLHtDsTCNBk=;
 b=av8YO/TslTYN0LTUeuo8Cp3Uz+PB8eEeKUlb4QKl2M/WH9ExnHRN+se14i4gJFM5Ele+FwOyEnfLcUFJ/L4PaZPDzF3PGFeoqMFG1i1T71dOqSJIqnuJ0MR8ljpNb3nGM+hoA+aLihlFmjFbnyNy0wx3cyz1tuoG5wNsvav54QGbWMtaky3do8LAvbT7pB83Kv8NpLTITswh6npJiPmJGztGVmBygfy3qNJKaKlTx0WE/OHA9c9cJARDHBHIck4NzOYPk82b0QSlGbVmrDG3MtgME/tbjZHR0tE2ek6GZLNw/Q1P80RwZA2RFhHPSJHz/9yDP3xE79iCz7j9RNuv2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yir30ALPdw4GZhG7Qt+eng1cFM16ldlNqLHtDsTCNBk=;
 b=OK6jWTdt5JJ+Mo9mJmCzM4T/g/A9R9VDJ6cQtU/XKCr9UzcYHzO4TF9Mv96nDasvRbpVHew+0NzqA/P46CSPuNJUBbS6k9fqJpsv3VrUQXNQYmmk7GMXKV30WMeW26hNnwDtoncgHnTMHWORZ2r92Byb3wAfxIMja5U/iUvV645T/Knc/LEOhHisx4jPtXZtY4jnoJR3y0L9uVM9Ks72znrDrnqVyUs9HUwGi8BTBKaxDBWQzQloymo+Slz5XFNTwVwe+eutxChKu9jcwOdlG7PdqgUpY3UE9NKGTHk8V93q+1Y0AzeZ4iHGo6pRryjNL0innJ4R1Uk3q1Leb/5KpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5553.namprd12.prod.outlook.com (2603:10b6:208:1c9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Mon, 13 Dec
 2021 13:24:45 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 13:24:45 +0000
Date:   Mon, 13 Dec 2021 09:24:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/18] driver core: platform: Add driver dma ownership
 management
Message-ID: <20211213132443.GS6385@nvidia.com>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-5-baolu.lu@linux.intel.com>
 <Ya4f662Af+8kE2F/@infradead.org>
 <20211206150647.GE4670@nvidia.com>
 <56a63776-48ca-0d6e-c25c-016dc016e0d5@linux.intel.com>
 <20211207131627.GA6385@nvidia.com>
 <c170d215-6aef-ff21-8733-1bae4478e39c@linux.intel.com>
 <b42ffaee-bb96-6db4-8540-b399214f6881@linux.intel.com>
 <5d537286-2cb3-cf91-c0de-019355110aa1@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d537286-2cb3-cf91-c0de-019355110aa1@linux.intel.com>
X-ClientProxiedBy: YT3PR01CA0008.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::12) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39e7bdac-ab4e-4103-96d2-08d9be3bedb3
X-MS-TrafficTypeDiagnostic: BL0PR12MB5553:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB555379F72C79487E07DD0E90C2749@BL0PR12MB5553.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PrJ0M2DWJZm3Mopzb/P0Yszph6YwZD/LKf6XsKsJwjTSU1wlYDITQphc+m6tcNgRJtraxnm3+a/Mqnjv1wlrSLjoRaNtKQ6lVNnYjtMRN185Pfjj/vHfqD/UchKdber1AuHgeh4IHNX/zGKN02nd9bMFp3HGABRr+a2cavIO7b5mLvrGMlkBABiYM6MRqYrzFtEt6MrG3m5PQxpw4n2lAjDEofogJk2TZBp+LmqxmCb22xFRErHzOB9bkLdWDfxahI2tqeOYBVJwddIE8RsVZ0eLgPqDxt5JOHhCaGQL4sHfu/vk2HYtF1wV9FXBLMuMNT8JyAM97d6dKhez85GJWWNSYNzsURX3mWAWE1koYOrgIniyeqA/wLzJV2JR1djPFA6D17dS3gyOIQouObgNmGwA7V1BDLAQiqrxjWMyAile/BrlrL2X1nZ6Acz1n9Mdk0lhYpHHPJffOznB71CDeF4fC6X/+sN4zHJJSDULPED5VrgHEIg7QkpQhzk2RjHoiem+5hC9KyUJH6fZTh0tVQimgsjHxPTv+RV4sLW9uHZdmuARMDFRMfqr7caCTSBfnfM+jajJ4Ywq6vssBEiNIQqYuk8i32wgJPFonapZRLCvHv4LuU52VAEEQFV1nymv3Y/zp4nCPg2jOliqaGew9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(84040400005)(66556008)(1076003)(66476007)(6512007)(316002)(6486002)(66946007)(8936002)(54906003)(33656002)(8676002)(83380400001)(2906002)(36756003)(86362001)(2616005)(6506007)(6916009)(186003)(26005)(4744005)(508600001)(4326008)(5660300002)(38100700002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qgeNdbCgm6orJ4AJrkar+9GFRzzFIcHZRvfWQrQOBGA/fb8bF9BSTWkmAIld?=
 =?us-ascii?Q?wI9naXFedjpMlWjwrz4eQpqGdHFw9g9psfNswveyvHVmWfRelflXcSW4E0Xf?=
 =?us-ascii?Q?vo0ELz5+dJFIxzySgKA/4Ro97iZYglBPocc7rd10fwdWQEiHjRf+eLDFNKLz?=
 =?us-ascii?Q?MNYdsVuBEGMGq2JRSzUfm++hrPuU5ziDblMihITOhwhiNT1+U6wGpsZOtfeq?=
 =?us-ascii?Q?C1Z7ArUVrWNAfnVHXUE/Zu5/8JJu8ybhGXlMZe5TyrZdsiVoRRwTlyF2NwzM?=
 =?us-ascii?Q?cNq2zFtFGDMkwAJ+lptHV4P8MjGXdsHQLp3B4lSvk/2sMIgFi/NQlz4eEodV?=
 =?us-ascii?Q?eILMiIA5FhBiFO4LCCPaAdQlJfcr6GWHtuUgtStJA15MOoDaRWiUpx00EnNI?=
 =?us-ascii?Q?/N452gVYTGBv5UJfKJzjP3j/pMC1Qv3SsHOOTX5qzudOUuChFit/lGR0Y0s9?=
 =?us-ascii?Q?zaKXhRg+aQBeUoDggSnY0Q1FM+Og9/ng2FKkliaEMV1pIJxhzBYMcU8qrEGL?=
 =?us-ascii?Q?f4tQQVmkYsBMxx07qOr1lY/0FLgWo0yYJWaS+8PjXQxBDiCy9lnE2dgz+J1s?=
 =?us-ascii?Q?Nnm2KjAHMzlfXkbynak0UKVZTyqReXCjYqnFmcyRqfWjXpo9Z+YhBpoCMTd/?=
 =?us-ascii?Q?VEupV6GVmpdHT+1m6tjATi651NcmuhsiP3ZsLJXkEBNKBVn42L6qG8EZb4Xq?=
 =?us-ascii?Q?Xfb3IlCDGyJGaPojCcuaKekBzhX9BOZkWIwyq1TCW3iUDnCmC+h7N3i00yIG?=
 =?us-ascii?Q?W4uWRWaVKsYRCIBUTC3KzgpP8eVH0clbRxOQ/HRmkK/cZ5oMDBuK1K2EXaZw?=
 =?us-ascii?Q?KJntjIlr9jfu8MOug/oGdaqJ5RdGjwRIznAeP6LJheI7lsr+ejZ+3drF4+gT?=
 =?us-ascii?Q?+NMMrQVL8zIC5O6KJ2ottoZKxp3Gm6f9vDbbseE0Uto/yq9HVQXBO93qF43O?=
 =?us-ascii?Q?BVZVvkWXpI0ebsUhWS71hlQE6YPXyyS1lt7G+L6mK/Rqh0pkHL0SbQKvsEl8?=
 =?us-ascii?Q?HoYt7GPJO9rsTAPAEwUCG2SR825lYIHakvOn89peT+cf7mI7SsHJI0VsuBn3?=
 =?us-ascii?Q?ZTE8pOD04uQ45GzQiugtGfJHtKjlBcHtYN4bYaBkxQEdAmxycPiH1WqsNYlP?=
 =?us-ascii?Q?IIe9oT7Y6kI8fJXJlQQtSiEeMzvx5b1lwtWYGkDOt3Z1jZpwCslKoIM45dRt?=
 =?us-ascii?Q?P3HCt9cRtcsya0pEqDMCjxPWIBSa8MAuDq7Q/M5r9EtOHtZzaNmqS24M72Br?=
 =?us-ascii?Q?2vsAZbZxq/dpZjLhZgwBi8nmOmE0KceJUr/Uxj50LX3d3ksMegAD8umLq61o?=
 =?us-ascii?Q?rFdy6IkWfCQhYwifeJti3SIVTxQV0AZT+tpJqIQAXu9EzmbA7yBvbSUVv1NZ?=
 =?us-ascii?Q?86r7Ea3O/Qo972xrFlyraIieXJpT/5rHhfStMkPpMIg3nhhNX8TLW0vMEGLl?=
 =?us-ascii?Q?SW6GYJKzWGVWGOJLT7TZESevOmPF8xBYH7nC36fhhDmCCwL7J5y8bm/IVTYW?=
 =?us-ascii?Q?1fh4lNm9kXBJAtI9sIJXKrMUXvBNTnjUkU4fnRcTSkuGI53VtAigw8jdA9r/?=
 =?us-ascii?Q?x29dqwOXUAQBm2C8Vjc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39e7bdac-ab4e-4103-96d2-08d9be3bedb3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 13:24:45.7297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ep7rAoZ8i6hspNKrFdCWrbo79reGyBgFp1ELpMtz2UDeQfJ5RwHEVyx8iM0jBa1q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5553
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021 at 08:50:05AM +0800, Lu Baolu wrote:

> > Does this work for you? Can I work towards this in the next version?
> 
> A kindly ping ... Is this heading the right direction? I need your
> advice to move ahead. :-)

I prefer this to all the duplicated code in the v3 series.. Given it
touches almost every bus type that implements the dma_configure it
seems appropriate.

Jason
