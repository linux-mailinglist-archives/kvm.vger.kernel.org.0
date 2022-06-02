Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22AEA53BEC1
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238575AbiFBT0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238671AbiFBTZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:25:54 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2079.outbound.protection.outlook.com [40.107.212.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1ED13F6B;
        Thu,  2 Jun 2022 12:25:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOY/9TlzHFo0+R9PBPXqK4P/yUHabiDA6GA4C06CzOxIVGNGbYjv/Lc3OZdkQeeFpYm4fpilEbB3kjG8bOynDsc4qerWnRvZ3kbjC23m0DW1V6qNvm27KmzPEIBZPo0zOi80MTAOCqAf3IiSeMOxSUlRq8ZZDg4B+czRGfIwA6b95CJW+0SUnQE7giNe/Ko5GBZxzgVb7puBdZkkOsOiz7Bs9vsFn+xcmG19Vg/FvGIalHipFMsNmdzVqgvm1iLJavLQxYkXrLhzYgOEs62THo9Y15BiSeHZiLGcyf67v2fPvp4jvYYZRkVJEB7l1vwyQGsRohidXDvBpuo5+/zPjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i//jiSOVX3bAG9pIlsaa0+119P+tk9B++zk4rJVpiTQ=;
 b=BfFNBMXuApTCN2Q1hhXOGpcnrmEYHHR/t5s63oX253oZ2iKu9JORizZOcLc6BC5Z6f9Yojwy7xNB6uBPx94siVg9r8v73cGFcbRh+ZTua0HuuctQVbdRuW6JKM5IKcgpYVhiFJd3eUuqc1zcPrElX+BX1Z0pG5mtQ9wGinLkyc1tWIQZe/uZFj0YhsrzCb20PCkzxK7wphZ0ny/b/D0d9q7hIJJcwzahaYc/hqTsCDlkH5FNxYl4qo1fpX4j31cxn2wFdrlro2/hScmjGx1mP6zmnwc9+4IQh/ODo3XBpDDuPW3dexqYdPUsfr0EjJrctoldb5h9aOX93BYdEtOaAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i//jiSOVX3bAG9pIlsaa0+119P+tk9B++zk4rJVpiTQ=;
 b=NrWvlZiQskmzRSSKMXHOB23745dabJ4KEJ1XS3FgX8nqW67H8AWTi+51Ksn+V7mSQvY8PGq8gWj2AtTEDDq/S0hciP1lo2mbZGE1ZzIBS8Nrvsh5d2vHMllcXrOgVxoRaqZB79ZThO7YjXQYApJKjqh4ZaTyQKuQ0G5TzW36zgpbD2FOpFkNW6R4N6w4jnLUtAQwWRQpZeGssPJdAzBwoD7itniLvMACe3co+NwlGyUxfK8DvDzQIHaS0RmMWIcV+daiIAtI2Vi5HtP9HUfzJK05tmpAHLq+y7gwV9onmVCxXexj0TjIDpctDjTdlR8s4uq+ZL4905UVnLIOyb4WTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB3766.namprd12.prod.outlook.com (2603:10b6:610:16::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 2 Jun
 2022 19:25:37 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.015; Thu, 2 Jun 2022
 19:25:37 +0000
Date:   Thu, 2 Jun 2022 16:20:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 18/18] vfio/ccw: Manage ccw/mdev reference counts
Message-ID: <20220602192036.GK3936592@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-19-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602171948.2790690-19-farman@linux.ibm.com>
X-ClientProxiedBy: MN2PR17CA0009.namprd17.prod.outlook.com
 (2603:10b6:208:15e::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59f590c5-3cf7-48c5-3da8-08da44cdac04
X-MS-TrafficTypeDiagnostic: CH2PR12MB3766:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB37660DD39808F0EBF23FA952C2DE9@CH2PR12MB3766.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 19DGyLtA2bZfA/phbgoQD0J076Mvn7+r8puH/cpL3eZLIj9/cxCmdVzR/DMq4DyKN7xwehUebeXTnZy7jkFNi0d5PcnK6o1SY/IoUhN7Xj6FrbdNwBscWGnsTapn/pPK2UfXfUV/7QrmZGP2ZHd3ptxiD9rQpcoq0TCklvL3hVKrGWQy3Hr43AmZopXQS++PSV+yTxLufphNqddTSLmRlsN9OKYX7vcEI4/5PeJWU8C6+ubV9WMDSFG/ryTsARQVKKbq5whcOBXkXq5sZWc8r4uw+4SnVM+Pr9MIsJPMIyHi5DScqBIANrKoQNToMtqnE6iODgfpIVOeim6C2D5Z7gRBL1bkw3YeQ9e1g7YmQ+F8uGUf6zDcr9jXj9UU2StT/cxJfze4z2iIBYvGc8Knq7D1wXoeNEmHWE1qQ0rRxgXTbvihqOKzjHaa4pMTwAsAW6cEnhjSUmOMOQG2zujhM2fwrynKBXV/mUicGxRTYYYu6pBj7VqugMwh38vTXTY3C3+ZE/54shjohrm8zuFTpJxuIKQ6FfYCm7wjD99MMVaMWhzK2VMrZOxLbKcLhfayOU07gndTSQscTqn2DZByqFxyIh4N/iJpjAIXbNR0V9fJDJSljFaXVO+BwSIegrG7X3wT4zHizA7Kj1H3dYPVxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(6486002)(6512007)(66946007)(8936002)(26005)(6916009)(508600001)(33656002)(8676002)(4326008)(66556008)(66476007)(5660300002)(186003)(1076003)(4744005)(86362001)(316002)(38100700002)(54906003)(6506007)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?az80favke/cF5G+5adEnOT0gPS2jbVLEV8Ffti4843MWekvKNjJut9pMI5F3?=
 =?us-ascii?Q?gwVkPHWTQXRWQAZx3AZwNJdpCnBab6FW1y5EbQVaSmpL62IH9PskIBF6O1DD?=
 =?us-ascii?Q?leiQJZVgLi9YnkXA8upYuHQCHVBTRwWR8M+p0wrBoEy2dstOtG6D8Mu/DDxU?=
 =?us-ascii?Q?FM2/90QXGBeiN3cgG2ZLgItaPIFaALnKh1Dbe1IcZ690ICm0W/XBJsj1rpf+?=
 =?us-ascii?Q?T/Gy3dZ0/o3s5gMYs85Ym/MQKjCzCAgreRnveGweXrKeEpyeojnol4CocZFk?=
 =?us-ascii?Q?TpJW43A76U/7So5NwF9K0rZkRohYIs94C8/3aHdxYbXegriuUNIshA55d2PV?=
 =?us-ascii?Q?qxQSSGkZ834q2Iv9H9R5xye1wH10tYJHsiwDyZ8+RqvM9uiymsguz90USd/M?=
 =?us-ascii?Q?afjdLIHtF058zDARZwKnSTu0kZvQIW+UijKfw+6b2HvOXVN1DTezcxNKRR7j?=
 =?us-ascii?Q?4tLGm/qDp/h7GQc1M0vQ1oCx1cCFdjqQ+zzj6ZU4kQOyI5q/NiD6lYwTt4wt?=
 =?us-ascii?Q?Yhz2CRUH2T/WgR5y1xFMhFkws1+NPshJT+m7SIUx0U/HULpkZoVo49T5iytv?=
 =?us-ascii?Q?Q2iCOM+mmpynHIx0EepYJXMP/eDpDza11v971JPjLx9FJIkaBFip43Tz1uH9?=
 =?us-ascii?Q?tWzXlWxKcJZahYhXVM5W7eLhYuUwbQ+P7u62kn3bXkiUvWwcDAJoaa3+J9uY?=
 =?us-ascii?Q?emJfYWrylWXFOW/4uJEIifTbsocfZwfPKs1lZB3FNFQf7FCbv/Ey5iirPBam?=
 =?us-ascii?Q?U7Vv5cMSwWh2vaA85m9YD/QFaWxRkBBRDVWLx55D+cSyFHmh8rF8dLDyUv3O?=
 =?us-ascii?Q?+fTw2iXIFv1BNnZrdKuSRiNfRI7FNaIyovjvBunm/vz9x/Y5T3BtveWxhqLx?=
 =?us-ascii?Q?KUt6tIcn4ELc6PUe5qhgCTnMYA1LZk9DJW2ljHnTh8SmKyr8FqgmLqdxAURf?=
 =?us-ascii?Q?psbgIVuqsoWIQG1gGa/IMKw8vqnJ/lgyP8hx8DU7oNV7bj/zHnjlqaFkUGH1?=
 =?us-ascii?Q?+FtBR2ASm+Q8RnWKVZuV1IEAqa+WkZD5kgaIgvOngMiDrwCCpfnZT645pqf0?=
 =?us-ascii?Q?quJF9fRr7c/ax4BU42waa20O73KIQ4KsDHMf7D8gowuVY1ZIoWn4Eq+G1CLY?=
 =?us-ascii?Q?XFm5b9WxKRUKN5aNW0Gu9Du9xTmHIxaptDNB2PVDrelHMsJ9T1MQze27delE?=
 =?us-ascii?Q?pldA5nVdMkNFmq0uNm2c9bizGX07br54KKn+URwX/GVmAup1dSDrBgY8mSrQ?=
 =?us-ascii?Q?xqaDpVNlpPZi3TT05hHHM7rQRQsQACX2sP/WLlss690auRySAJt48vbBw+Vs?=
 =?us-ascii?Q?srdqV59HzvsBW2GOACCGDlVvfoGLlzQJtjOaXXNep8tbnAsfT3qwlbV2L/1I?=
 =?us-ascii?Q?RIuoY9E0pk4AohWkzDZgRjpdcCfKqo7UjZww+fyKqPMAAtLmDwfC26xvMzrm?=
 =?us-ascii?Q?k1tELfJKKOKemIjwiP63G0hALLu8r3KG5Hh9ZyXWhinesPqy/oRMQSkbu1RF?=
 =?us-ascii?Q?CUNTTGLcqxL+mZLjyfh4B4FMdtUeaB2Ma4k68Fl+OJOkfifoAveBTza5AuzC?=
 =?us-ascii?Q?1AY578HleQ5EPTgrFzgK1jvke3bBVgi2DPVCez0F3IO0KKzlLmIGea13SrHT?=
 =?us-ascii?Q?YVeSj6o0j4E9jjWr8fabBgtal2xfgIo6R0f/vy1c5fWmCECpDJR1IGRLnSZp?=
 =?us-ascii?Q?gRWlkiPJzIUkmUPpfzEEO6BlJv+pPg6qkKKCXcfkjXXBQiIhEmxak73fmvGI?=
 =?us-ascii?Q?Z1Dar5coow=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f590c5-3cf7-48c5-3da8-08da44cdac04
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 19:25:37.2227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: npwm3N7GhANKwP7DszTE/ViY8TvU8UfO54+HVRS5eHF5e7pHNw7QKbCgmFlhZLre
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3766
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 02, 2022 at 07:19:48PM +0200, Eric Farman wrote:
> diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
> index 3833204bd388..be238cf277ff 100644
> +++ b/drivers/s390/cio/vfio_ccw_private.h
> @@ -135,6 +135,8 @@ static inline struct vfio_ccw_private *vfio_ccw_get_private(struct subchannel *s
>  		return NULL;
>  
>  	private = dev_get_drvdata(&sch->dev);
> +	if (private && !vfio_device_try_get(&private->vdev))
> +		private = NULL;

I didn't try to check everything, but obviously any of the null checks
in prior patches that are eventually converted to this call should not
be made into WARN_ON's..

This looks OK too

Jason
