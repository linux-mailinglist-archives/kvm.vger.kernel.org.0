Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778F233E1E0
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 00:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhCPXHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 19:07:50 -0400
Received: from mail-bn8nam11on2040.outbound.protection.outlook.com ([40.107.236.40]:47232
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229632AbhCPXHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 19:07:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5IUdJJkTjGNp5puVya18paEot8TKrTiZfofj1bC9ZjtWxMlmdmKXcn6eKJ7D3cYnRa1xdoZ4/3fFIhtY4q6uuMeUWCpYimz1jK0bDc9mxqmL9N57NogELyGaQaFTiQMkvYDP/LHjoXuwNQWLm7Okff3pRgzvtv6GXoWXZp7KFuu90wH3cseOB9Vvgfy2cGeDKvVnXg5M9vw9OKp00f/gkhEsT+FxCBRy8trmh8DJUOFb3hLWHiibBMYZhP2WvafFGePyBIxaYTW74Ng4OCGsa7lfr6bO2yzIB68SJNRfX2dor5bZOE2gF7H3DKHvEjU06CcLAzdTMCkI4Xw5ISz+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mEnVhtj7UDQMIwYkJYo9toB6C8GuyntuAUvosFOKCGU=;
 b=RY/AjO/GOiy/wlEqJJlZ0F+XT2eifft4mKsxG0f1W82FhIvpzWY35Z3ROp/SpUECEyleSjoyE+MrzHZnoF3jg7e+v0T9YnCiMgFGAw1RJfmw9GbH9SK+B9HXcYy0eka61PBGULKQJ6nPo5SSbLUfQ+WWSeQABQAg+JndzvVGCPNQXhzqZgXgaIUsJnZeoScAQ532YyefQlJnPZKWbOmeBKQyj5emK/nH5iM0NafTjR+6yGeFIomVRZ9WZo7dc5FtdnM785yRV/VoK3jfZ9G3baSsuNOPxQFBwqQ3fqgRsk13G+mp6FB2GSo6N7oJlL/yzypgnm44cY9M3Bmr0nD9IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mEnVhtj7UDQMIwYkJYo9toB6C8GuyntuAUvosFOKCGU=;
 b=Gdu0rH5NCNXEn2AbAsKVOWWnyLATQ9EHSRphZx2tlx1sajlDHoIEzK4vF1Z/Zzc5F6cvNsbEtFiv013pCP/lhXg2+0OGdUk7uACKONXV+sUGr4vC1q7vblHOhFHlIrlSmmn+3yxmO53YBUWDSL6gCn9pgb+smMLtxXdNAXPYIYjKOaI99O7LNX85xWCJpkr+I46Csz2ybNxpG7JSqUwB3y/xwXCZkz4ZCw2nUji9w5H9KtJ1sGcP5uVcabmxTIbnpGmOnkscnG11JaguEC1gTU5fhic00lxb9VaftWm+J7oGfExtTXKNyfbbma/fzRgpbk5fLBxdERJWa/NPz+d7VA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3833.namprd12.prod.outlook.com (2603:10b6:5:1cf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 23:07:46 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.033; Tue, 16 Mar 2021
 23:07:46 +0000
Date:   Tue, 16 Mar 2021 20:07:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 01/14] vfio: Remove extra put/gets around
 vfio_device->group
Message-ID: <20210316230744.GB3799225@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <1-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <MWHPR11MB1886F207C3A002CA2FBBB21E8C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886F207C3A002CA2FBBB21E8C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BLAPR03CA0043.namprd03.prod.outlook.com
 (2603:10b6:208:32d::18) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0043.namprd03.prod.outlook.com (2603:10b6:208:32d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Tue, 16 Mar 2021 23:07:45 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lMImu-00Fwb8-AT; Tue, 16 Mar 2021 20:07:44 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5bf6f36-d4d4-4d13-a528-08d8e8d04f69
X-MS-TrafficTypeDiagnostic: DM6PR12MB3833:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB38336D1F2EC2945D6CD44ECBC26B9@DM6PR12MB3833.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SAQSxZDLOiHypeDA5gqQysZAkhmrrjplB/rZWtw6D98fruAM8WMvytN96S4nA/uD8Wc8Latuv+MrsKpYpLWLBJwaTSXtcQSldXIVs1pZuOYaFaAQL9lu/GUaQALh8Pf8qvdUCtlbf4NCo+EhWD088uo3/WUAHVlnW5q52f1ihfdmkgIyKwLr4t+Bc1CP5U3ZbK65+wC9xWHwrF6vKqH/s+KqyvpiBSZQBG01Dj9EkDWsKzms2PBBU7ycsTmIUGXJZIawFy+HuhsTSEsCaYxtPn3Em0Xuufc/o7taCL1c+rl+olkqxrG4mOmcVv3N/NDDBPXHdOI8krmu7P9fom2yzx/gyJ+VIAy2/ikosf7wuKeDs2mtfhnvB5vOVe2hxVzV7ast4AzPhFlc5CxlO7etPjt3HspScYyhFWLJmtQP/0YZLlNlWhcGKVZA5X3zAy2p5QPFYcu6TkR8aR5gO/FLLt/TA2PMvRU09uTCd5H5ZUAGDNV1s7Xz85rZHRLz9rV06K9fVumf7OAFKn6bFPJmMcQ3geZz04mfxVpdJfPpvD66aDlAvMuxxkAd6Tm6VdS8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(316002)(8676002)(478600001)(86362001)(83380400001)(66556008)(6916009)(5660300002)(2906002)(186003)(33656002)(1076003)(426003)(9786002)(2616005)(9746002)(8936002)(4326008)(107886003)(36756003)(26005)(66946007)(66476007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mGyRBBJagYQG/6b111WU9G/7wm7Sz6foZXSLhEF0afiUAprp1MnXNa4JnN6y?=
 =?us-ascii?Q?bZFtGN9hjvNE6us1ik1htfYQV5vNxmRk8zvI/3lu5KyO129CsS+nR+Unbouf?=
 =?us-ascii?Q?rm9bDn3V/GA/QjO5fKGDob2mzUWaWd4yUmwuygJGgj/b5Bml8Fi5/A1bRDk4?=
 =?us-ascii?Q?m+Ew+2XE89GXGhDkNxZcZ+3qYx5dfw7e58Eo3ZUwNILF0+ET5m5n72ZQdXcq?=
 =?us-ascii?Q?OSXBpP2KONycfQ63DO7ACUrWWhhh3YD+bPEhLbpri8+kthP+HJR2J6/Dr04H?=
 =?us-ascii?Q?asilfHEb7O/Sx1AJxPeiYNxCroJBqi0o0bNkwfD9F7PspqA7DOOetWr//1Ao?=
 =?us-ascii?Q?0DXS5zu2WFp9QNSwmylcegy1sMwCdBq/suTbaTd1QoJj9gDe5paFq9YqrFng?=
 =?us-ascii?Q?YsAt5sXKi32yrel9aFkfpQWMIF7LGthkkijJbAVF22qHxzcmoVUB1Vrahiye?=
 =?us-ascii?Q?0E6guTj4POe2/Pjl8s7sCn2Qntj/FrnNc/2QlAT0CL6rqb5RtjrTR160iCnG?=
 =?us-ascii?Q?zUTMlxqQhP3JZio8Y5XBDBWTG2yKSnfBn4Vi4zwnLI4SY42z4759GiO/Mqqr?=
 =?us-ascii?Q?YWmhIu0/Al4yGD3Rqm/GUmbWtHKE7fkSM3YkAvBbmO4iLrcRkCHngJBvVYAC?=
 =?us-ascii?Q?R4Q6ePzxGXoIxdiFQjaautllM76RVJH6AXEZYVFgyT3PoKYrGLHlmpchK1yl?=
 =?us-ascii?Q?zP/4U4IA2IFQm0AeOBeUx+pyz2AtwxDb7U0sXn50mBmV9DqRlus3YRaH3wj5?=
 =?us-ascii?Q?omAhBCFfuc6RMZzgtSteDIEtWR1nxvs3Gjx50GU5xTcU3Zago5Zp7xJQzbQE?=
 =?us-ascii?Q?X2+pq99BToL9fOdc93NiuvHkPQVUyY00DTjrgDrUvJkYYfpgvOAu3GZ5aT0f?=
 =?us-ascii?Q?VezxYNWWEpbJVOERNZqr4LYi34LTTn68Ugm0oUSvE2m2o3cDf+F+BLyqHCXa?=
 =?us-ascii?Q?cO80q1Kmz/Zc4EyCCOrhmF+CWLEXWsa92xfaioYp1i8a5G4awfKB/OyZymBa?=
 =?us-ascii?Q?mSkHUWsDqwujNViCXAeXgGeoEtfphcbOordeYZs6VczJ6taX3PVAqXLU61dH?=
 =?us-ascii?Q?vWuG9c9tFdf5ElZ8phWBKCUgGWHclI1PD2Klj5WjSrDbSF3cTOxugj4UUY/Z?=
 =?us-ascii?Q?Yw4r800SLk067gBnaoBInrVjrb2g8nMygjvv3PQvY8hUfolbrIVzCUd/J9bn?=
 =?us-ascii?Q?Syvyy4KejFi3oHDgMSVuxZWpHHeRa1elu8wKK+XQroLZp4IAJG1nk/HdxNKK?=
 =?us-ascii?Q?KOlEtdpG5tjA3ogF46tplfZOXllmUctZfsRlRomdWcGWmOfayM9N1pAAVCwL?=
 =?us-ascii?Q?NXMVS8uuBaBXsI+MZGtP6vCL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5bf6f36-d4d4-4d13-a528-08d8e8d04f69
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 23:07:46.0737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S3nnMLT7gyna9HAirnzAPKGjlo0s8318OPvOLCr555iq5K6khTTqYuEjsXFqvnps
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3833
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 07:33:55AM +0000, Tian, Kevin wrote:

> > It is tricky to see, but the get at the start of vfio_del_group_dev() is
> > actually pairing with the put hidden inside vfio_device_put() a few lines
> > below.
> 
> I feel that the put inside vfio_device_put was meant to pair with the get in 
> vfio_group_create_device before this patch is applied. Because vfio_device_
> put may drop the last reference to the group, vfio_del_group_dev then 
> issues its own get to hold the reference until the put at the end of the func. 

Here I am talking about how this patch removes 3 gets and 2 puts -
which should be a red flag. The reason it is OK is because the 3rd
extra removed get is paring with the put hidden inside another put.

> > @@ -1008,6 +990,7 @@ void *vfio_del_group_dev(struct device *dev)
> >  	if (list_empty(&group->device_list))
> >  		wait_event(group->container_q, !group->container);
> > 
> > +	/* Matches the get in vfio_group_create_device() */
> 
> There is no get there now.

It is refering to this comment:

/* Our reference on group is moved to the device */

The get is a move in this case

Later delete the function and this becomes perfectly clear

Jason
