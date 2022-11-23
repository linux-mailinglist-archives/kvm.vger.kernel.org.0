Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1AF636917
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 19:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbiKWShz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 13:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239590AbiKWSht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 13:37:49 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562AEBE2B
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 10:37:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSUcvYn6b5udstvthRMdwgydUjnadyOYZ+rYeqkeCTiozxl+PhlZUe30eQkVqVtI5amh1N3BnMbqae21cvIHkk5rI4gYod1pXmUVjDufZYWWUSVRWQMHV/R5aM6LeMAgq+bxF+xOUhgVnzEdqsMwZ/qlIJvhAr5/GFVqzvlioS+iKImleysVfp42a1qSa729guOl8Vq5Rfzp7vEuP1J0Hu7YZ+sPhz3AsTjaiFcMun8Oqhhg4t2uJM3+g4/muAAB12bAgsCDO4d4lwf8SIE0mxUyeJaTrXc8xjPGyKD8imgCEYh6mSonvGlpUixR8DG0VMSDrTBOmD3RCad9jgKNAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9odNNyCHQgFYGmjaR/Os+UcSjQdoxmTabT+OhqAxgA=;
 b=F4MyTqoFpuY2L1TgcVYLxzcgyMhhH3xyM/0IFA7EyBNiDOm4nsgrdCJieeSTdC0aH/oWGB7PkjPbfCxgliJPbTtrUzWbqBHVZq/AQveDBtSOWx+ALzRfOTrPMXtUMNmaoFhWDT0CVI6gNy8DD6j3LyP2Zb7eSZcPfzNqR6jKEaE4yE0cHAN1hOKUiPjGH2heBFJeo2iA9akZ5SCzcWc8FxPs7UCh92A8sMguhQFMUga8uYd6vk5b2ZpCxJWCybul1UBIzKGQw8Kj8uv2IrO+pOo7IbJR2qQObzQBlbBHNcVW690S4g2CjwhodU+E3r9bFXEKsEHgtSt08wU0MViMFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9odNNyCHQgFYGmjaR/Os+UcSjQdoxmTabT+OhqAxgA=;
 b=XSoLLyUJNbJYM+mymtHj2N+HfL646qsz2tI7N3kNtLzv4QIjs3Z9YRHoMTz8eXqOUW248TKihZEJ0O7D3UZ6vdQeZOLo6U/O7RAfWpE4O9QBX/5+INCd4LZ8/WhusudDdEPQZkZ9PqrUuzNsXlFwlC3uzTBlWbSK100BC9tRoeF22lvwXv+MxXPo54PA55lHz4phooksUSkDIdaV3fn9RtQw+IBmCoxCHeXIAn5Jj7focTMJkFMUO6Iqaqx2JeRzlRtc29htG9UJa+dZ3asFmB7UjaL0sYCNMcyhAjKjvMsv+aZ4cMq4bFR8CmwAV/5EcfOezzZ8b7MIAdv33PFYEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB8026.namprd12.prod.outlook.com (2603:10b6:806:34b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 18:37:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 18:37:42 +0000
Date:   Wed, 23 Nov 2022 14:37:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        eric.auger@redhat.com, cohuck@redhat.com, nicolinc@nvidia.com,
        yi.y.sun@linux.intel.com, chao.p.peng@linux.intel.com,
        mjrosato@linux.ibm.com, kvm@vger.kernel.org
Subject: Re: [RFC 10/10] vfio: Move vfio group specific code into group.c
Message-ID: <Y35oda74I+SXK0rg@nvidia.com>
References: <20221123150113.670399-1-yi.l.liu@intel.com>
 <20221123150113.670399-11-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123150113.670399-11-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB8026:EE_
X-MS-Office365-Filtering-Correlation-Id: a1c3c6ed-f694-4c78-d553-08dacd81ce8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9brgAPBR+GiSMAtxLbRAi1iyw6SRupUHuOE5tPj/QsvZtS9Giv17rnvX0PzCxZ4LhzEg3B3e9j6jJftDPO6HDmx5hwbcF8MpERwGavNIWnrsiDQMk872iKDt6yootbhiDAqHFJMbW3uw7+UePZgABv/br/ItW7smNrBSRPP9GvbRC+QTnfoRd+bGXU9TnXgMxaSSuUn6LrejUlh1JVqFAH8C8rZBmFxsZcxJnyVODz75p36vJ3gj0Y9qWmA4IwGu8Y9RqQ2aH79A4Ms0GduSgdnkcOM8ICQsygxdcp5mbbxfCb29swt5avtHG4izWAt22HeSQbeA//gcWrCTP5BpbYPSKQLJQh7Xqu+b5cRPcq36IKv+bXIOneQIglkl5C6WobpktOK7TRzA7wwwpPXpC53n2WfPYw76lHNn6PAmi70RrHkhQs4iHkK5tWgwQnhhOaPMYwCTQjKuzHxiinU3P1CUVh5yQmmWsRvU/a/bunn9vaBRDJVjvOQ+tWuSjbuH1w2VZ+41DSvXbD8sNEUYhlBBbiDtyKeUkRLOwsJmwJ93ROTZDPNY/34aO4BVRppAkAPvUa/bvXppremcNB8EMy2f/x7dV60+xEORopF55+f8sz0Ub+bsbglUpiSFAulMgQEMFNPpzU+CHPd3K7+gRAYWJ+nHWyA53WXJqneoe3iL8W9nVZw/9puXsF/GaFaS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(86362001)(36756003)(41300700001)(2616005)(8936002)(478600001)(186003)(5660300002)(2906002)(4744005)(316002)(6512007)(6916009)(6506007)(66946007)(66476007)(8676002)(66556008)(4326008)(26005)(38100700002)(6486002)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KNVgu6M2j4zWWhZ8RzooPJFxtFBIpGChSxRS4tjDBQ+RbyS9M/3xoRk6WIyg?=
 =?us-ascii?Q?BZ1fcAdBheyf8+hS80rtrO/cbpc2q8QLgNjvM0dPoEZIeRF5/J3yhG7hbOrW?=
 =?us-ascii?Q?m96YR9SbRKI6Iop8DMWqlDTZ1IUdz85oGNf8imz9OVK12DjpzDRsvZEc52bF?=
 =?us-ascii?Q?n0ySw7QxJTJL03puLYPBEoZnxqiZZpy10CZI+cIg9UnGkMQh0tXEhqHAqbaN?=
 =?us-ascii?Q?2Oxy85UBwFoSUBtZiq8cWnDEBScjZ1O7U3Y0snRJ8vq7fGaOp4WOn3hMKstk?=
 =?us-ascii?Q?SmdR1gjqzzh1cLi+oln4p0sf5Wu2HztDcyQlIZ0ISNUVhytcU2trTbbvrNEQ?=
 =?us-ascii?Q?ZN8gmT1J+jz2lDssYPsiwdrkNb7ESME4NU39qs5sFFIj3JKhtoYKyXzJmOm9?=
 =?us-ascii?Q?Q4nJ6BEvRBCUXp22dO+cxnCtfLQhGcrEZnay8zm1vAXgtwrftRvixKCrNiUK?=
 =?us-ascii?Q?6AhK5GsETONQ/nYQo65HWareocqwO7+4xjz16OYGZrYK/sTB+HqHj70Iiixl?=
 =?us-ascii?Q?9us0NPbv8/VDzoBiOvp8F+uRT1Pr/oKCwJYPjrH18FkDdildxuAycIyIDTf0?=
 =?us-ascii?Q?hzRlGB9GVP4yFKWd2MHOdXuxhcGbGjyH4dJc1vflAXoHRTSbYAmYoue+LOiH?=
 =?us-ascii?Q?j8sk9jlaMXXkpgHL7clEEWdqlfKYewH0LvAWucuP6VXM1Gj/owHFNVaZuqH7?=
 =?us-ascii?Q?B2xO4rCxR+5uRYRDJ96EZtfIrBxlpMgYUxe59Wg4W5z7JjN7g60SG/uNSf9A?=
 =?us-ascii?Q?SdvoqX+ZigN7YYPZ1J+KrkAwoQcvG4aUV48OEHc0Aj0/PlwoM3DfS9Ljs0t/?=
 =?us-ascii?Q?loN/Cmfs1myzk5aqdLWFnJsYQBCgqF82asmTPRu6b9mIOEFMbSLiK8KxEFH9?=
 =?us-ascii?Q?BQ3oKafTLj264hfcsKxmDwkb5ylAPN4fAxQAW/qE8JpBmK5Md1IfefnHm5s3?=
 =?us-ascii?Q?IjhzhPWzjAkUXl+Au4Zs3pWpPi3lhLBVVNokbUW8FeP9aEQLGZ/SCARM15a/?=
 =?us-ascii?Q?uLrbl4sj8ZfMjSalRMI5e6LutXPofCUVKNWdNurxLHvk2MqOgIo3Y5CDONFA?=
 =?us-ascii?Q?TbJ859fYW5Qdi5LLkG7ABhXcNw+vB6yQfa0bcydK4o7yJyAMaTgwvJ/TLaFA?=
 =?us-ascii?Q?C6R5DmlwBI/FF65O11GRkTYDmFqPoNZoMUnPKzDvMzHnLx3Nad+Xefh6ELWh?=
 =?us-ascii?Q?aOAaRdBBeTZRdaeezYacLk/PZdWl3Bxftu/sCIZkcZIWyi24zmJoweaeYHz7?=
 =?us-ascii?Q?p9KM03qb0yU82QxJUhuO9yZLVbzX1Sm5yJ1S88WR9pIXfopwrpC9WcMKBbvB?=
 =?us-ascii?Q?W9+dQPcmPzN8aKvvJ3sP+FwbyHIUffgJLQwVpUeeDh33k9KQyLfxZVQgwhZj?=
 =?us-ascii?Q?/2B2BV6RYbJwO8Z2k+mRbSfVa5diNc+883DdnHEMoDxxfTpMRMjdbrY85Z9C?=
 =?us-ascii?Q?rOvprZIAnj5M3mXPR9Ay8+1heoq243Ubr8/DdR/qooRdTErv73AUXIf9woTs?=
 =?us-ascii?Q?9Yzpqr1/ovUdVRXZUSGEPaXOAD3eApmoc98W29Ol3CoGILvPGDOIrhztNWHl?=
 =?us-ascii?Q?Ta02tBIEXU6jWh8WYHU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c3c6ed-f694-4c78-d553-08dacd81ce8c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 18:37:42.7095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tPg0EbCoVFACwQPgD5coXlgqLL/FO2wtrlH/44N/eylEraRbmm/roCwvGCBGZTIn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8026
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 07:01:13AM -0800, Yi Liu wrote:

> +void vfio_device_group_abort_open(struct vfio_device *device)
> +{
> +	mutex_lock(&device->group->group_lock);
> +	if (device->group->container)
> +		vfio_device_container_unregister(device);
> +	mutex_unlock(&device->group->group_lock);
> +}

I'm looking at your git branch and I don't see this called?

drivers/vfio/group.c:void vfio_device_group_abort_open(struct vfio_device *device)
drivers/vfio/vfio.h:void vfio_device_group_abort_open(struct vfio_device *device);

?

Jason
