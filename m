Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC4E4D9E36
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349516AbiCOO6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349498AbiCOO5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:57:55 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A22D4B858;
        Tue, 15 Mar 2022 07:56:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5JEYTHotDHJP2Tic8zZ5Kdy8BKlQow8zrgI27p7MdFevSMgekikVLs6Plmp3jTCUoA1PUsAO2nxCf6oKal722S16tOU8fwEvP5PophgRxULudAHZjw83yW0De5W2L4QMjn6tLR4bhPWnbGddgI4liMWtt1lxO8iarhvVqvF6ykg4n7Ouupcc9sbbosyujWU4HKVQsTddegpKF33jnsoSqq45p5uiwIi/Tj2kU1xr5nkHUekT45Cb8JgQ7JVQ+uGcnXn4CBVArofKow3iJIv+Q1eyStU1/TbRmh+dfsKZSbcSGJ91tC+RwYEcLBWnVYm1+h+MN+hGvg0LFamcl4N4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3SJ4mH9DwrY4yHAwOXrM0haROJ+ZgL9ib3Z2Rxr7Bz8=;
 b=PWBWghjhYWAX5r2Bwxrm46APeQVxXDECGP1beabOLchvlY/gCoP/X+diOcJzy8el9gqz0+jVc4Ay//8z8GQ+q/aRpOimzQDCNB5Z5rdXdbuDJ0XXGr1p8RZLZgACHqOkTb7ImlLqAJprAwJCv5dNnZfi6eD/DRldUbbN1EcBWDyDiCC7Y2nFJbNbArwRHiTKH+pfWgP7oamN5LBu5arPNR9RNxGOu9rojo+e7mM0dip0Au96MFCfpslWWEcIKCoYdHmGHDiJiDUAHu2B/e3CgsTv6hc3xxx+WM0XomOb7dgABPq/FcWy7bjVBfMVxYWUJZtRWX4PkayMd6Gsns30xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SJ4mH9DwrY4yHAwOXrM0haROJ+ZgL9ib3Z2Rxr7Bz8=;
 b=sH5QRjI8AO6onOVqxAe9G0IYF+AMRaPcl+W6ypPxAGkTdd2L5sjJ+hsPRDtIuTJNMNlV29gF2jhZ68Zyn8h64L9MEuoUEucD7lfRmHIK+Pl2vAjImi2g7qX3ZguamJ52G3ZL1MmZkU9NUNXbukAHz6zdPWrkQ2Xv6P9A9UxKKWLS0uSU2iDi5DKBTF4bIK5vlflQM6k4FMr42GtnZfDhDvELva9RRko7vYgkWLf8MHdvJjq6IAhijSKZlFPlNQddTRJlEHWdHARyk2wts2A4D6RlE95jBN4ftr51fqtONR56+oyy12yF2omR5LaAlFWb8YTBZAMJ/J8LBI4FhA+Ymg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 14:56:41 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5061.029; Tue, 15 Mar 2022
 14:56:41 +0000
Date:   Tue, 15 Mar 2022 11:56:40 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 29/32] vfio-pci/zdev: add DTSM to clp group capability
Message-ID: <20220315145640.GA11336@nvidia.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-30-mjrosato@linux.ibm.com>
 <20220314214928.GK11336@nvidia.com>
 <35ccdbb0-eb21-0c25-638e-4d46fb12e7a9@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35ccdbb0-eb21-0c25-638e-4d46fb12e7a9@linux.ibm.com>
X-ClientProxiedBy: MN2PR01CA0060.prod.exchangelabs.com (2603:10b6:208:23f::29)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88c92194-096f-4439-fbaa-08da069403d9
X-MS-TrafficTypeDiagnostic: SA0PR12MB4400:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4400DF4FCD8215CAFCB87241C2109@SA0PR12MB4400.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7GJ/85r7u5HF0ovSr+VkQSgg8u7ubOFWZVd/+PVCOuCKwtJpulSeWVmiqncDBLLe6D75YkTph0J2zGFgDIzkVLVA53Td3bMCShhagHNGjsc0f4WtvMd2I3xlaj7J18B5QkNkGl3VCyEOMazlKxfx5EH1Kw9URdKkTI4nXfXncvB4SLOmnxwLXSHarq/Y6/wB8AOyo+2MPw+rcPlWnk2ZlahswOR+VBbI1JQn1rRnKLpb248ct5Z1WxbppeKHQS4nkFNxbekSngPppcfRcMmXsrtT/PPGLHfpt6E/rTJGTjiTojlOnCJR0YZTRAkfFcBYbbhqfHQ+D5ZUPPgVILDdSIxAehC/b39lOWG3O+BoequHrr8zshjBh5R0fBcRxnHPpv9Y9SNgEeSqERYudgseYoOLLURVP5TcrroONS0vsITbFOmo77e49ZNo2EYmOvvz/wvDelKEkCw507r/UJJDgqaYj/yJ3YhIbMWjIzvdAYq5/IhH0ongRH6QVcZZvQWO9uzmaTJovK1ifk8iNg5j3HG0e/s29Fd5Q5A4OPRi/yF1oZzU83qoL9pc3RU9LlDzStkfWdfpHZct4BGHwukO+pDaw3Ua5w07OxRf+lXK/3ShSIWQDOkCly47W76L+vl5dfmnOwXnmIxpT3cZ8XvM6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(4744005)(6486002)(186003)(26005)(5660300002)(8936002)(36756003)(1076003)(7416002)(508600001)(2616005)(4326008)(86362001)(33656002)(6506007)(316002)(6512007)(66946007)(66476007)(66556008)(8676002)(38100700002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?biYG/CU5kAl9tmZnZQXY/JE2m6tv7e147gCAx4j9MnCNwZop5Vzqm8h+H1Rb?=
 =?us-ascii?Q?C1vUjvgXK9FO7y1bS7V0dPKPX47eJuYAx+Z7sNJ6YkY3bHN7EkKbuVmzX9V7?=
 =?us-ascii?Q?VwPk6ucRyjG3Ce5ykLyk6ShBBcup947O8CiNKHj9fktDO3OymRw446ySAVc8?=
 =?us-ascii?Q?rbcd+GgdYCNONJN2w1dzLHliVU2QTJs+OSqJ6l8+qQ5kKhS0qJowiay4tdQ6?=
 =?us-ascii?Q?O5u7nYRKNcQyERg+bmLU4sXqj7P6qvSw++8EEG+Tt7uEr5aDiPApoIVsbb1X?=
 =?us-ascii?Q?15aiOLUilf7JtmSQWDxAT99r5A8M/qE8YwNWXl5meIqUx5z49TGIrP7+8SKp?=
 =?us-ascii?Q?rgp4DyzBSDzhCW4B2HFWLqqm9XdcA9sBqeDJeV/ACMM1yUQUGV6hG2Zq1IEa?=
 =?us-ascii?Q?tBtpN5efRPE4Er9mUHnfwLjDNA+ExKrGyv7vuQrsUh9kcYg3iNqRn3LbzkgQ?=
 =?us-ascii?Q?V7ImamegV91C0RDP0kk6keLUSnZnf9JGCGBdhi8d6hSt4V5DhTdYdx+Vm4Qm?=
 =?us-ascii?Q?iOM4ewCTwW1BI4//YC3UaY4K8kHNkR8gS/fuhmyE5UOA75qdvjdrYxo2/Kbe?=
 =?us-ascii?Q?7mSxhm6afpmGzVNQuHlWDEMByildd55uPoRP8YAH6sdFMPEFZmdkJHnFgRAs?=
 =?us-ascii?Q?+L2KorGQ4o121ilEDYOttJOTYfHHpWonOMKrJkKmVYLNB2hbkTzIMA89JYgh?=
 =?us-ascii?Q?8FHmRo1nGScFvrBhMTzcwG6pGhee+PjH3Srqddbdlq6+3Wf8PnkWY0fIH5Ba?=
 =?us-ascii?Q?HGyw4MrBi1p9rwK5qMtbhMqUCFhNyG8r0l/i7kvEkHlFGeCgNOVZd4duQBT+?=
 =?us-ascii?Q?1NpnkXeDmbY7mfV6uHd83F5CFmzzWWayxQpUQUZ9JtQFAz+nY4CnVBFRKtVg?=
 =?us-ascii?Q?xYPaMm6MZKMlRc74x8jj4eVSc1wbZPlrsd2Cu/oqD01O7t96yVfsziZUwgY2?=
 =?us-ascii?Q?+YAQx1m2QIgkSWpy2VqkUYduRTgVeGrhL+ayz8yPYRu++58HyM84V1mnT4sB?=
 =?us-ascii?Q?VjYGyzwbSOmRo5HNsgZKsQeZafc1CvSwXBttCCktSPVAMFynriSvFEExq3Pz?=
 =?us-ascii?Q?FLNWcazpGdgbiRB9ovOdvDhiTaj+OF2QxWs+HKd6TjPWOBFl3sTlpRO7U7+n?=
 =?us-ascii?Q?HsOSMpe1AOtjeOEuCFD54cB4Xjnx//YpYqVNlKh3TkAplQEN02tSQDUGbto5?=
 =?us-ascii?Q?4iM7wgCxJUP8sMgYZ6iDnqH6FEcMlPOodyWy2LIgqUBT4QSlhRYrI9Yli89L?=
 =?us-ascii?Q?5PGaYWdvlCec8iAPffCIaF5zHULHbhKNIwPe6qJOFn7RVgmkZucsYFwKM4+v?=
 =?us-ascii?Q?VTO5qd96ss+quP7QLICckS1Bq6GDOa6z8ls33eLb3Wz+E8Jd4IBj+xLJ3bJ0?=
 =?us-ascii?Q?FC6vr+cB+1WdWXtMrhkaghxkIADYj1AZv22zQ6VqPvd6pcb2xqX2dkEGH6j9?=
 =?us-ascii?Q?I6uiZDlkdXU1s48it/CX3qWys1ShDukk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c92194-096f-4439-fbaa-08da069403d9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 14:56:41.8077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zP7oA6p4S7xd/O4HgujK/48bJw5Y0yrUtnZ9a5s+/Y1AGNgm94dFtUMYh83QwU1F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4400
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 10:39:18AM -0400, Matthew Rosato wrote:
> > That is something that should be modeled as a nested iommu domain.
> > 
> > Querying the formats and any control logic for this should be on the
> > iommu side not built into VFIO.
> 
> I agree that the DTSM is really controlled by what the IOMMU domain can
> support (e.g. what guest table formats it can actually operate on) and so
> the DTSM value should come from there vs out of KVM; but is there harm in
> including the query response data here along with the rest of the response
> information for 'query this zPCI group'?

'Harm'? No, but I think it is wrong encapsulation and layering.

Jason
