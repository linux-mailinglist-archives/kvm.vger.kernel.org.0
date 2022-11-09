Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2DD5622FD5
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 17:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbiKIQM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 11:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbiKIQMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 11:12:20 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DEC22523;
        Wed,  9 Nov 2022 08:12:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYK8+CHprvcx3np4FUkz2fCtQVcTQb0oABpLNKBXIrNadO4T8IMxlg0a5eTKmzVrSBUSAj2LS+Hyr4W0YQeL5nfCCpED8n3ChTf1VutRe2B4mbFFocQd28o0dzcvprN7d9/DCa6Kr+KFblX+4xUNEGTVJxspn5TQThDzNHbZX6QB/lLYp1nVEuNWmp0dLGxIQg4OdbuAlYDEt1u/JVE7IaowoDm+h7OyvWzxcilot+dDvf80E5MouZ9dS9qZjBwYlZTP3sOE+r0ZiUXsa7xUFWcsrjRCeUe1i5bMgW+dQrKVt0DAY4Tc7MmAXVU4wpwjcZgHoUTe8LX2gNbKsb54mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8kuQGJUg9lut1uiZf0qhhotu4Tr6lBNi9oLB9MivQY=;
 b=Dg8Pe4294bTWTh3inYkv/J7Tk5E+rlqOZLhW+vJL9+Un2ngI/i+Jrd3c7kbUo6OPmEThZ1QasY9e4nloVS7ZqbOaH8COGZPEwjRJNmUnEOdmbAcWkSYDGUB7eX1okAYjd0pOFIoaUwA7OaCbN00Z2p2IWvdYVEvqM0NRfw9Ci1tZ4Cxq7KkfAv54FJQGAzizTzmJXJXCEPOzKSIoj5Nl/XCxZNr/lMAupLc/6dD+zrrJkTrznXlr45iJwnK2O5vXps8+W9dB0ijHYvirjpvKfEUBU9LP6M2KwjCyIRsulir4LLy8dU3Anoh/QDg/bd8DUL7oj56RRy89m8egVadUGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8kuQGJUg9lut1uiZf0qhhotu4Tr6lBNi9oLB9MivQY=;
 b=sU2tmPsfKyy9V+i2BKI9nOxYppLMMCmyGytFwfJaz40thoTTA8ErRL35EeUsZSJ48qaJm30wTdgeM67yViT/cVYR8OY2ZiSKJufQD1IrRwfl0KPUaiHTuW1ARPcU+48CbB93JfVpLXoqghoSGQSxwbgbxx9vnhInWXJ4RqYw7th9Z46218FMkrY4lvcXJJbmpz+IkBupTlIvL4TRfOXdsFSipkQWkt146REbhfw3Y9V/z0s8cXU5W79Ldsw8RRCrk8dxOnUE4S1MCIL2FCm3NvqHavRXYX+4RDsnRA1gmYMp443ALbab58hbEdQ47pFWYwUKgI9mO2WtWopiCItsaw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB7091.namprd12.prod.outlook.com (2603:10b6:806:2d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 16:12:18 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 16:12:18 +0000
Date:   Wed, 9 Nov 2022 12:12:17 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Anthony Krowiak <akrowiak@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: S390 testing for IOMMUFD
Message-ID: <Y2vRYUXvIG21ytkT@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
 <Y2msLjrbvG5XPeNm@nvidia.com>
 <fbb84105-cc6e-59bd-b09c-0ea4353d7605@linux.ibm.com>
 <d814e245-2255-15ce-cf3d-65788aa61689@linux.ibm.com>
 <73dd6b0e-35c7-bb5d-b392-a9de012d4f92@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73dd6b0e-35c7-bb5d-b392-a9de012d4f92@linux.ibm.com>
X-ClientProxiedBy: MN2PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:208:c0::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB7091:EE_
X-MS-Office365-Filtering-Correlation-Id: 2df61584-b36a-4c8c-3f82-08dac26d2c6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GhxwDgGTgIKpoLNoITBwzIoB1068/oyUGbSenrxc9VS84hCnJ+jKuNBB8Ze2mZ6/db6X3bYzWJoycRNoRZ/tmdg7UPATfWMLA5/yfJg24tOk8mhrfUwZoI4pQ7KA5yRAkH9M8jooit4Z09wYBFkL6+otFXHzL+hWcflqQTrUEiUHeO5uAUtxv3I2W9xSQwD44MLzGvk2NM2vUbaTkz3cJIHDTpjpJbU8qYiTGYI1Lua3Wddo5/KOwHEGTf3ZUEZaKDBX+790PxrHyneRcp2/DhzvVT4L4upB2Ho+JzSwd56OWDGQ24sVruLpVE+64v3gbNk8kSQ5oFHgqQx7CCJyKctJvpQyDCnklZGD+xHP+rAQfed09LlRhnTtjRa2zP8X/BW2XzpRwCKTZ4tODEyJqlfu+oRcyqNtCWHptHnrJC6XKDdvL4Zh0rJpjCAKrtEJNxwhNEDrTqgcJc8AylG8IBm9uvLjm3WydOCLqCWsKFPz4xDTn4ffHzIkAiayt97LgJHhFg8ZAedNZF5z+fV/38SA199GbljBnJ6hiJpOJppZAk5A9lykwLM76nqd5wjRCmcAfM8orP6hsiySbBHLVemytqcKqMgNzRtP5OxZYjdcYa62Hk4u8Wpv8yxGtMNLu+5tFyVNMGx4TgMWo8DL5+48n3w37K/2JrkZRjd4Kx8oDXoM7fIHqALF9/EGI+fhDSwIN+RZCfFnfAN6FatOW8cyMXYuBegFf/l5bwaruD/YaywMeBWManuhj82HADr7VhZwJLHdPwQ30oj5+02ne6ldNKOjUh5UNxNSWnSU/ik=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199015)(4744005)(966005)(36756003)(41300700001)(6916009)(8676002)(316002)(4326008)(54906003)(2906002)(8936002)(66946007)(66476007)(6486002)(7416002)(66556008)(478600001)(5660300002)(38100700002)(6506007)(86362001)(26005)(6512007)(107886003)(2616005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PdLVMT5XifOvBWJBE7zaD9nLGYV9nqflNlKZjU4+d7vQWZFkBTp3qV5Inp3C?=
 =?us-ascii?Q?gAr6EcuYO+iJ0k1fauGP0ZpHe0iN+QBJt6e/KTTOOSkifhHfI6X/sVK5kpub?=
 =?us-ascii?Q?CyFXisTwLzGPd1LzBPvTApYLc8NsJZSVWePdZmZ9uzn8vpQheWOQBBmNBM/t?=
 =?us-ascii?Q?VkGv/YNDCXk8ce7D0AORdZRUnMTNclfW73WnQ+Jurl4F71uqCsjt3aLtoCMg?=
 =?us-ascii?Q?2MUjNA4xjX4UW+QeqfdCMZHnbjj+aEla+9OjrnlJgykLVGWbA+MH61TvVgU8?=
 =?us-ascii?Q?6M6mgjcYBq2BjRxfAomw32XGTlRNW+LNBIsYQj9za8963LdB3QR1nd0iWfel?=
 =?us-ascii?Q?iAnSw3xtMhz1D8a31YYgruMrHUYDcmsBAbp8EuMltlPfqxWhrCmTSb5k/3iK?=
 =?us-ascii?Q?WgtuME6kEAg43mT850FSyTEvoee51qR+AcenGHo7zkrASDDyMasGa2qES6K4?=
 =?us-ascii?Q?qCw0SJwEJuJieL0uk766Fh/0QuQ3O4xriv60qKlcRI3keqQL23/h3tIQvbhE?=
 =?us-ascii?Q?ZFe/rjI3s1C2kV/R8+HpZK9U461/uVEAWKcgqpzzttiEaj1gvu/edNWoqY9E?=
 =?us-ascii?Q?hNbboGlQIWCvzU8OjahQAOX4KYXQOyRMXW5PNqLwff9Bm38y9VFGVzrRC34A?=
 =?us-ascii?Q?OBUzvAQcKbhlT/HBwor+/QskBh+8EPoKvKSExtTS6EjHBudvgc7h3tWwQVkw?=
 =?us-ascii?Q?qnwQmW8OhFEMtkodJxUr0hu4ydxgkxtJkGqBnblfozywmJAidQf5whK3PqLA?=
 =?us-ascii?Q?Bcqw67zPl+In6QwERmLM6A08LuuAgwmxscRyyWtznfMzvbmR/5+xqbza6ktd?=
 =?us-ascii?Q?RRZ56djlUuFc5kJTgg0bwJFtd5gUneMqL+olKO8AwUX1+yH2vTYk8A1xuBwq?=
 =?us-ascii?Q?BIho5yYPS2D8TrxRJ/CTyOdMRsAafZpmpoaLoX57boWeOoWGoaY1kyntWjeT?=
 =?us-ascii?Q?OORiOHU1+wpVyx3FGl1bFu1KDnsFVnBexRtoAiBgI2+KphrEbDhEw8r/xYzY?=
 =?us-ascii?Q?T07rdU16oHBhbbThX4aIUQl3JZO0PNSbwa6gyD78WwtFLdqM5vkK80KEjqkO?=
 =?us-ascii?Q?AEbr0jH0IjhLYzGTU+az50HobpdVrNUCupAVu4dcDu6SZMLyRrFe4iO1Wmck?=
 =?us-ascii?Q?N6oQjZqzFtRrM+zUCbpax+1UdUFC6vmnAzzvoMASp5t0nkxZP610lrk5+Jo3?=
 =?us-ascii?Q?UqFks1neeFp81YKQ+cKtiJsMD6zxblvmFSSJRHlPKU3injlApCXn9uxyD4jG?=
 =?us-ascii?Q?SFhjgLPHTSSVkyy0bM7s9vgly27oQlnuNYfg/arcwmWZlWgNzEuip37e1smt?=
 =?us-ascii?Q?XFFTPn+J/bHDu1RDdg1c3cVEfi3fLDC6VX3yOPkVz4aPyQ+/+sob3NF5RxQ7?=
 =?us-ascii?Q?JivyEQ1Aotk9Oz1RBHoAP7RzMNMCMBNQ9i1ifJ7EfGgdq02BMhQUh4qMWInr?=
 =?us-ascii?Q?cD07+kAHwcKmcAFPdwtjLhln2h1LoB20PmGZcseaPqp0gt+GD8708F/axMcu?=
 =?us-ascii?Q?q7hlGwORwRZba/6+aY9xQxodaJFPWJSTaTXDvcEQWsqZpAMe+fe6u7TUIFKw?=
 =?us-ascii?Q?ofFDQXKY9YEtyw63PlI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2df61584-b36a-4c8c-3f82-08dac26d2c6f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 16:12:18.0620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bp0LuoGcd86x5lb7n0rBtEZmPvsuIyFztoccIswXhiql1HPtsOBiq/mLN2pM3rUB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7091
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 09:49:01AM -0500, Anthony Krowiak wrote:
> I cloned the https://lore.kernel.org/kvm/Y2q3nFXwOk9jul5u@nvidia.com/T/#m76a9c609c5ccd1494c05c6f598f9c8e75b7c9888
> repo and ran the vfio_ap test cases. The tests ran without encountering the
> errors related to the vfio_pin_pages() function

I updated the git repos with this change now

> but I did see two tests fail attempting to run crypto tests on the
> guest. I also saw a WARN_ON stack trace in the dmesg output
> indicating a timeout occurred trying to verify the completion of a
> queue reset. The reset problem has reared its ugly head in our CI,
> so this may be a good thing as it will allow me to debug why its
> happening.

Please let me know if you think this is iommufd related, from your
description it sounds like an existing latent bug?

Thanks,
Jason
