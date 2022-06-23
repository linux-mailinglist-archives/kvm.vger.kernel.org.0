Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B903557E5E
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 16:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiFWO70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 10:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiFWO7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 10:59:25 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860F55F73;
        Thu, 23 Jun 2022 07:59:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUgxNMfIZxwwWsgXlzx0mIxaZApr1b06rBd3/QRwPXub4+oTW1AhLUk9CpsU0cC/YlD3gr6EE/LNxamGQkAz7q+R8QNhC9vjn6pAZVkqcrkDzkGWINOw+fi+2QRhqu+bij/3y+5sRlrrTpsDuJrNuVo1PFiWtGWmjw3O/OXR15SQoikkJF7STbPj02yt0d1Z44hDi48LTmsJR2dxZl/+554ztM88OGNCUS5BUJeXlVFDmXUJHip/cdTN7mcPZqRG4/lrFvAuM+pa6fBdgzcL+zuRWuuwqUEieq9LsS7p17rdL8llvNWeg4yTT152DXw8CiMTwNBGDLr9DrytlUTjTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8SPCejF9rtxyWwiy2X/JBfJdq0P1ev8yI65TRMbBBNM=;
 b=iQo8QUQoFvSy7jjABQtSwjcjmDOiI9B2vNmdsvO8AX2tS90nDYGi+VTzfuNxtI8ubTI1gXCn8SlaZK+u3QDp0I4OWxRq0iIw/CxfdGpSfiKmOFfQv3FcJTuaHVx0kuagRXMNsya7jfhoHQiVXqSb95L11nT3x3yoXxcgnwLwD3iocoek4Qq+6agWnLqvSnhetPGuHXH4DUrJvZxszCVYeAnrN1p2HBXxcSWhsZVqM/tMzpvEv0HdkdWqO0STpIPahBhBkabTQjsZjRnrrBmAxlpx9JJcMXe2Z45/QtU5LfPQpMpnwuxNBP54aD8DKd/hxeRw6CyBydQnqAhpASSasg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8SPCejF9rtxyWwiy2X/JBfJdq0P1ev8yI65TRMbBBNM=;
 b=BBicqy7vErU8I0KZVMUesTjEPpSgQae5quAR6m4ayrh2eOEbUrLsmx7VMzZ1CCKEwrXbTzMJ2rC8LpTgTiSmUPLwK3reD4dYBm9khJDzxTvYUXf5aiOjkKjCWyOBjpuDo2H5i9J6wGci9ThkEUVR31u2+Hu3psiMnuB4789lvWn8/aYfLbzjqACtXxM0db3sDZvHYQS4OnE73lpvf5QWOtBpateavahutKqnDKMO54Gv3OWzVXRIzrZtnJms7RA2jcrQBUSBrStDAmkWSO2/Z9jS4enBYVOJW8utQSAyovNHPY9ZRrI9++PG+ENhhST8BpFBVB7e3Z4zc+1thsdW+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB4071.namprd12.prod.outlook.com (2603:10b6:610:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17; Thu, 23 Jun
 2022 14:59:23 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Thu, 23 Jun 2022
 14:59:23 +0000
Date:   Thu, 23 Jun 2022 11:59:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 04/10] vfio/ccw: Remove private->mdev
Message-ID: <20220623145921.GC4147@nvidia.com>
References: <20220615203318.3830778-1-farman@linux.ibm.com>
 <20220615203318.3830778-5-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615203318.3830778-5-farman@linux.ibm.com>
X-ClientProxiedBy: BL0PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:208:2d::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 583f76b8-233d-44fa-3b69-08da5528f546
X-MS-TrafficTypeDiagnostic: CH2PR12MB4071:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB40716CF74DC7AC33A83943FFC2B59@CH2PR12MB4071.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qe4SqkTDcqLXZbswt5Qi9GNunqx4gT8MF1sB/jsCrYdcPWbP+NR1mPtYxZhDKGACmtOBsjOHJyYRG68A99fZZu2J5AqYcPf0oVPpDR7uQ4aXA+hZkA+u1s/aWCjuHYAjqMfg/EGpeVZw1e/Lz9VzFppQWD5t5nEck48yncsrJHXYEpcZZBSL99cH3OOC09l9jRBiVP3Y1XZYq6u4AyL7lJ+tX6fcWB48HqxaRcbMDomZ+X0vD2B8dIy3/EtLXCW/vPmr1GN1toxGMUidoVqSjKSeRhU+T5REqrKH1Yek8lUwi8FjvL7MUAlKz+3F35V0o/Mqu5lKUq5p1NbXYm0MtX10QGNzZqCH+vG5ebSAP6U7O7nG7vWTgV2WmZZT1EPcqQeloIokixZHj/FdfbevmZpKAM6b0aRHI3ITyldcWt5BiK8rf90ZoLRa/AUvYdEHFEvWoUQ3T1z7+2pVlxXTNbV0SJ0vcBgP3bVEfGN1CWJHkQup8p3+mOLS+fu4BZoyt96G8g9eKqcOcMv1Afw15ABR4OfA86czm6HgerObHDWk3tEjwYo0H9xaCmI/6Ckh3mrMHux7GZVkJln0XMQ5oAdflsndThL20Lx4j/CAEyw5qZgDk1jPqwsjLsP9IdNBswAmUtXvimvUBYQUwJSKq5iYSkd2auUUeaVdta66R/xwH20h6MxGxMfykDYlE+j0q+EpGSx0ujbCeTT3WOctzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(186003)(41300700001)(33656002)(83380400001)(36756003)(26005)(6512007)(1076003)(4744005)(2616005)(5660300002)(66946007)(316002)(6916009)(6486002)(8676002)(6506007)(478600001)(38100700002)(2906002)(86362001)(66476007)(54906003)(66556008)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2A7JLYzjfAOsnecRGr9bNMP7LlEkvw1EAjwPv+Gd54GnaL//Kg3Aob1OpXGY?=
 =?us-ascii?Q?qmVdzcLhGZXsEMiwJJXUzHtSlyGieaBPFLshKYuKwQnyili0xxkvcGUjYFXP?=
 =?us-ascii?Q?Kun3xJgdg0mnZ4ks7YMBUH1RLfbBoceUPvAIUu+NX/9rxnCOknx9zHxhOBG7?=
 =?us-ascii?Q?fRFtvp8IQPk/p3gyIw8o0KREHbJovRlvz4yhTYfv4iaClZjGuNzR4ThBDZ2D?=
 =?us-ascii?Q?71ny0iGAD8mqdFaUlIDVn5NP3Esxtsow85XiQuBWBh/4oVmjSRQDGd5pAiTe?=
 =?us-ascii?Q?7tLxg+u9Z7boGSNq7yg4hYrpBMu77sXvGu/wdRXVfaBypI8kaf2ZgYtHuBOF?=
 =?us-ascii?Q?xdfehNnVqf18ZfzMHRyLbKrT37oNrUqkJioxVO4y1dWt25xZKDN1Pzd4n8Q1?=
 =?us-ascii?Q?ClU0Yk7YCQ9/jdM+98W9sfhv6N1ZXLZvq91ny6o/78VM0CRDlA2OG/o2N+gQ?=
 =?us-ascii?Q?MG6XpJWRfsmYWyEImsGvq8rwVtwLAomW+IdadkeHC0q/+Y8nbo467rGbTISA?=
 =?us-ascii?Q?NeViXfL0xNKy+2tzOt+yKphd3d8INxWBmsCSCnfn/zSTQ0BTfIHnXs3SZG3a?=
 =?us-ascii?Q?NhahoEpCdclKyQ5n4VADKwbXx7GSuaBWxwt7EviZX38HxT7SPsNQlC9eFXZS?=
 =?us-ascii?Q?YmXyUkrs1vN/Q6RwPVxASNrseY5oF/I0CWm9p4P6Jco68P6Cua9vc0qjujvp?=
 =?us-ascii?Q?7ECSCUgAWTVmh5VZAecEjYcQTnOsBSMjBuUBrXBwpbYsyjyQ+bHWf3IK3FeU?=
 =?us-ascii?Q?pDWp3UkPhqhgOMgI95mG8e6pLGSnp4RmV2GzTviHUNzj50VOPMZBLSIzjnN2?=
 =?us-ascii?Q?i3tNYKqmPBHuGgMFJQFptFyBzyrpRNY7LxgJmiRrDXBj1aKpOKPGmUpIxeFh?=
 =?us-ascii?Q?4a6sGJkPflU5x8bfGVKfv635TeUlyFuySmjTWp7zbHH/EfuK7lLbVFyyfF56?=
 =?us-ascii?Q?SpHRf5+fVzjuyVW73Fg37pm5fgK1tvyzor4aEmQ49lloP8N+6IYKoOI2snxP?=
 =?us-ascii?Q?KXrDr2Jv2Ar0Qi0/J+1Qxbni5DF+YayePWPEWhgVokgK7/nZRCem438yJJ2f?=
 =?us-ascii?Q?oBX+JuV/osy60rywluEk2omUjsOntTNv6E2ez9Q0BeM7M4PaalosaaXJBNzj?=
 =?us-ascii?Q?Uqx+0sufWoloretAsHKO6q1ce+DfYH4uoTe0evPkt2t/M1A5NsuQN3RjK4Mc?=
 =?us-ascii?Q?L13qC70MyM71sJ4ysDWumc6A3Y3A7hP0IgxYStsqE/NjsoOGq8VruO5LUaqs?=
 =?us-ascii?Q?EtOPrp9mXPq6Cy2DeeNZ2C5Krkzgu+AvYUh7mELSS/6+bJHAsFdvt3loIyfX?=
 =?us-ascii?Q?HSogVP9TTarluvJMXLiPaHExcTUh2Asmx6DIPgyPK2DvjKzQlGEm0Nm9Rozy?=
 =?us-ascii?Q?B1LkGW3wDiTIlAsuyxprCnVSGG+gQVSOEdHwJXF+uaXKE+0GjRiiqG92tDh6?=
 =?us-ascii?Q?fchPIbxd56EEdj+rKxUrTJV/mAfmi53pgxQC14gGspOSynJxzRAPC2rUWWgc?=
 =?us-ascii?Q?S1KeC2BByuub6R/+OkeJ8ZjA0xLFSYFfSGarC0ez3FwpxhsO2htiLi1cTLfO?=
 =?us-ascii?Q?EoBvVH77GK2ykPFa4XQ/2kyTEzbA58eRgAAHVHcBEMDMFgMl09K/Fq3OF7Hr?=
 =?us-ascii?Q?34A5ntVT8Mnaw3AVRfQl1xyswOFJO6sX1Xb0vRDEdiM1btnZ7l6xRuwawb9z?=
 =?us-ascii?Q?lYUKD589Wa6H5Cl/JGAMTKTA7YOy3v5NNSJ/EWIiJrgogdLGef8Shpt5iual?=
 =?us-ascii?Q?u7BaZC+rvw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 583f76b8-233d-44fa-3b69-08da5528f546
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 14:59:23.0138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pH6HbEzYgAx3wnEZg3jYT64oPzTG5fnt3yol+EicsnBQVv9bzH0lhB8Epnmpeu8K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4071
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 15, 2022 at 10:33:12PM +0200, Eric Farman wrote:
> There are no remaining users of private->mdev. Remove it.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_async.c   | 1 -
>  drivers/s390/cio/vfio_ccw_ops.c     | 3 ---
>  drivers/s390/cio/vfio_ccw_private.h | 2 --
>  3 files changed, 6 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
