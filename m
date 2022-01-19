Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3ABB493C6A
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 15:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355366AbiASO7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 09:59:51 -0500
Received: from mail-bn1nam07on2058.outbound.protection.outlook.com ([40.107.212.58]:9187
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240278AbiASO7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 09:59:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NqRXKnY/5ptVwPHJrxky5jC6yMTQemrMEixsQj722WHKcCPBORZD+yy32TUVjkF72JTIu+2GGCRNb+hktkeIHrKJyUPdd5HYO930v1lzM3sNu9Qf7wxHe5FZRX3WvhA9QQRQ6zt8IKUvXDTPcPsmgC+3+SPXvCpUs/2ognqDoq2kc3PPXYiH9viUbcpa42IEAwDitJrQu+5lX0Ch7bXY77rxS8Gn83ImYAp/iZNOdNWFqv2sl/AShok5Veynx8XwIQKN8P5KezmweD1awFh9oZ3nH3OehLNJf7nfX5Q8W4C3Qeo3CTkvf7lo0ZC/Bwj0kFMrf4zoo4wufkxldx/r7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iI/YSYMXv0+8tX8i/MB1yuvBBrA3OgtqasQY0vtgaks=;
 b=dyYR66DG7RccoXY3atWh1tgBVX1Rv+hZrxtsAqJ6d0TKJiIFCnp5eDtzWgd1Votw+Y0/GMqMW9imfvErktOwjhU56TGHNjrv6Wlwc50FFKTRIfiXJQ5mGfo6wh1Q8iJNVleSSTQPB4b+Eb+CjIeLPPvHyZLthqx0QKqNX+M48l0fxPyKmKgYKpZRWng8BPJ4IsNm8K5Ydls6nxrQgXW0oHAGmrbqA04x7yf7Piby9zVjMg9KsTcxDeQ6J6DdnI1APhB9lc+vCVDlZ9guUP/Orcu76VT0VT1cjqRbxUVgJ8RCitBXuLy1d+3hPHs84/Fkr7Ig+w0VTDoqmPQ5+1R43A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iI/YSYMXv0+8tX8i/MB1yuvBBrA3OgtqasQY0vtgaks=;
 b=PjR0e6O63o4VgI3FY1g6otmbuIEGozJa/JqL+Fd5sF8R9Pv6vTU4tqXpdp0GJWQAJLUgk8IywIpK7dMZj2eAEwI3/HleE5K3iud4wnK7Cn9reqsghu9sJCrx0eWsbUGkzyDi9/mfzIRaby07HM7GMzZhE95UF9qFOayTXnRVoBn2g1p9PYaORir0t+kiIFfEdAgIVr8sxqvIeJTz839P41VCxC5UmTa/g/F8wHx0XAADVfKr1VEUXV8ZGIc/U/CMMdlUPhomnSQlEDy8KCQMoETjdPl5hAglK3nhiIf6HdKZRThJrEPMYXaXUhJO5OaQ3S9N2eGoNote7MZp+IjxWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by CH0PR12MB5027.namprd12.prod.outlook.com (2603:10b6:610:e2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Wed, 19 Jan
 2022 14:59:49 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%8]) with mapi id 15.20.4909.008; Wed, 19 Jan 2022
 14:59:48 +0000
Date:   Wed, 19 Jan 2022 10:59:47 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220119145947.GN84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
 <20220118210048.GG84788@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118210048.GG84788@nvidia.com>
X-ClientProxiedBy: MN2PR20CA0058.namprd20.prod.outlook.com
 (2603:10b6:208:235::27) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 593164c6-f765-462b-452e-08d9db5c56ab
X-MS-TrafficTypeDiagnostic: CH0PR12MB5027:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5027171FF1649442E14AF1F0C2599@CH0PR12MB5027.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 83PzFauksrRBL6dudQRJenSEshS0lo2UhJoiGGNck/ZKkJOGtXkWl/PrM1yKaGOCN1GSOH3pKN76ENtGVEdWgb59odjLe41q+DgLId0eRrcwaiL7SY1J/orve9OoqtLPik54d168dItaNG5GwxpBnrQJMw3092oDuNepJ4bssH3kKhZ7m2R5EdbMg1xF516yiaKZ4rP6CsULPuAR6gR21UZCDhzCwqkj2HGGBg4JEh7P2LtmKnGVWCTTXECKYnzY4szqY6c2GrOr7DWqYD4tf7RzBhyaFFXjNu1w7LajvZnqNSbWx2zt8r3I0zu0dVaFmXCtozC30wj2uKDFDBiBa2QANilxGiYr93Vk3R0Rpi6sPkCbNHhNg1BhrHy5Sj/MXNCPn9eQ9+l53AAF41TTgl/OZFz5D4sfTou0stXcgFhSXbuH78ZGHAMc+ZSDv/n54sdwB9CCv6ZNRUGwx/u8dkptp3+C0RCNOMjs7UsmUDWCcVjCnitOGs7NMQi2tvLi0tF71C+Co9bL/eCnIGOkKQ4NJnYOgCcda9tcB71S9amBZIHYsfhv6gVjzfcIB/UKC3/07bZ/+91CyyCwAyyYhTfhMABU7nxC4p2C4y/q/qG3DEZyyN8f5yAUEm9+btpl9qfW0FqLhgjyg9rqLMnCaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(38100700002)(15650500001)(2616005)(316002)(66476007)(83380400001)(8936002)(186003)(33656002)(36756003)(86362001)(4326008)(1076003)(107886003)(66556008)(5660300002)(66946007)(6512007)(6506007)(508600001)(26005)(8676002)(6916009)(6486002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jWIi95n3st7eblmcq10ErIRhYdNEIYB2olZuUdYeBdQ4Z44Z3GerYyQaeqCW?=
 =?us-ascii?Q?Gb+CyDU7D+UrOJxAjuzvzzSsFB75XyjRqcWGoGDjnp6nqsjqQGW1YUj/dFDJ?=
 =?us-ascii?Q?6WLON5ytKQWh12wmD/cKSDdeGLTScIw6Vwckh7aDiVr38JpYIuXRs1nkS/A3?=
 =?us-ascii?Q?vyzSJQvbegM20e2AhKAa0iyQaEQ9eMFnPYM3+MmGFasHl3h78tMYlIecrUXK?=
 =?us-ascii?Q?XMyRMlpx2UnSrzoEy+ND2Qvr4kSR3UN+1cpZEloV9S86XlJIb5rIJSVONh93?=
 =?us-ascii?Q?tiCxZRZ/YNLUkoZpvBSW/UcjXNZi2DBXpjdCklCe3FcimZYCYvDIX+4lWUuo?=
 =?us-ascii?Q?BnocM947INWjjvgXSB56nq2E3TFXYHuGHlbZxqJDwll09ldfSOZFH6Ipli6q?=
 =?us-ascii?Q?k5J7vpt8bQt82QusUzJK6yIEv3mXRiKJKCtklbCu7qnsm5bP7WFPHZpn3Ezc?=
 =?us-ascii?Q?xENj0+b+qP4w/7hCfINmNPYLRytnz2lBDfHb+iA79KTbBWBuuYWrO2+ffkwC?=
 =?us-ascii?Q?QUTLRL+d13JmZgASrnMp3N2hWNTf8Ky+U2J++AbHfqavM4pLJqH9dycK6Ee0?=
 =?us-ascii?Q?l4MfK0VmutDhX8cdJdlUYyn1deb165hVawjrCqRyo0HdisSN9/XioneBxX9D?=
 =?us-ascii?Q?iPXTjAcvwiyJAbh3ePLizCw1Jh+gneLTThKyxXDzbFGrFFk/s0szeKsedmq6?=
 =?us-ascii?Q?Ildih9ODhGQt42tBeXa5+6hQe6oBpQrnRRy9tPD6vp+G0jV/qFjL6GDctZNH?=
 =?us-ascii?Q?ZzlazZ12b6ldygnpCDRER4DCOPPhShzZODmhVqseBQovzBJkj7FYQyszMJpc?=
 =?us-ascii?Q?aqlP5xtGnzIxu0xWUwcJPMUwAlAlhWUne/DA2YHAa/V9crRy8dnu75w1R4Vh?=
 =?us-ascii?Q?Seaj4/uEdPv/oRZAT1opk0UjcTWh6gLPH1kt/nf6Ws+foUgW0eGotE2FTm33?=
 =?us-ascii?Q?T5f6mwY6oYDEbwwRwsIBbsbZ5nYoMpW3ra0T381MjKS7y5pBeAWu80BbiYxx?=
 =?us-ascii?Q?IYluaJ+z30WcHowPiJs6pB8Tpbev+sfIKLXzgNQoqNgkVLZmL0fbj2XYAiqE?=
 =?us-ascii?Q?Ki9/hWny/N34IgLFZGBkN7jmDo9GMiCjH1EEizxaBIR/jXgfl0Zvtd1tqnW7?=
 =?us-ascii?Q?dh0jyAxIAZzrecxp5ANcQBxUfKFTi84kI1rTZIP1EQJktu49TXcuEvQ8EceG?=
 =?us-ascii?Q?/oNXhP0HeDbmF87BUZde8Y7ZAv6yNX/UeYHVhme0RPVzgQQ9L3u9Ht2Nmtpv?=
 =?us-ascii?Q?w9MdsG3vyAkIDZ5LExjS/irMgFCcLcYis6WutORsUjgifr5tdEyvnRJ4pF+0?=
 =?us-ascii?Q?VE40p5AZay6rHXSn0o0WvEKqBue6tiqBR8Gny3l7Cm5OlNsRAJ7FFDI9G/0N?=
 =?us-ascii?Q?abk/nO9USFWsCiDOYuCIDKT9xQT93d2kTkq6i76ilu1F8yayt0nfkkfSjGXZ?=
 =?us-ascii?Q?xFjd4kWyJklsulAOIRUeyTaMGQiK74XWqyDJI1/aS09SRTiwt3tZGnV7PYG7?=
 =?us-ascii?Q?IqjhrbRdUEpGiba8t6ZbTWD7ImQtAETA1Lb2+I4uk5/9QJFKJ1GgifkKvJ1M?=
 =?us-ascii?Q?HNJu1eJcZozLpT3qNxM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 593164c6-f765-462b-452e-08d9db5c56ab
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 14:59:48.8593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j6yIn1srKWcN1RKa/+6EZQAKmi7q9nWbz2m6Y+SB4WnunVLm8aEXa49lSe2TP+4W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5027
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18, 2022 at 05:00:48PM -0400, Jason Gunthorpe wrote:
> > Core code "transitioning" the device to ERROR seems a little suspect
> > here.  I guess you're imagining that driver code calling this with an
> > pointer to internal state that it also tests on a non-zero return.
> 
> Unfortunately, ideally the migration state would be stored in struct
> vfio_device, and ideally the way to transition states would be a core
> ioctl, not a region thingy.
> 
> If it was an ioctl then I'd return a 'needs reset' and exact current
> device state.
> 
> > Should we just step-device-state to ERROR to directly inform the driver?
> 
> That is certainly a valid choice, it may eliminate the very ugly
> pointer argument too. I will try it out.

It looks more poor unfortunately.

The pointer has the second purpose of allowing the core code to know
when the driver goes to ERROR if it returned -errno. If we get rid of
this then the core code's idea of device state becomes desync'd with
the driver's version and it will start doing nonsense things like
invoking cur_state = ERROR. Currently the core code protects the
driver from seeing those kinds of arcs.

Second, the pointer is consolidating the code to update new state only
upon success of the driver's function - without this we have to open
code this in every driver, it increases the LOC of the mlx5
migration_step_device_state() by about 30% - though it is not
complicated new code.

(realy the whole pointer is some hacky approach to avoid putting the
device_state enum in struct vfio_device, and maybe we should just do
that in the first place)

Since the scheme has the core code update the current state's storage,
and I don't really want to undo that, adding a call to ERROR is just
dead core code at this point as mlx5 doesn't do anything with it.

This is still a reasonable idea, but lets do it when a driver comes
along to implement something for the ERROR arc. It can include this:

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index c02e057b87cd3c..913bf02946b832 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1800,6 +1800,7 @@ int vfio_mig_set_device_state(struct vfio_device *device, u32 target_state,
 	     !vfio_mig_in_saving_group(*cur_state)) ||
 	    (starting_state == VFIO_DEVICE_STATE_RESUMING &&
 	     *cur_state != VFIO_DEVICE_STATE_RESUMING)) {
+		device->ops->migration_step_device_state(device, VFIO_DEVICE_STATE_ERROR);
 		*cur_state = VFIO_DEVICE_STATE_ERROR;
 		return ret;
 	}
@@ -1813,7 +1814,11 @@ int vfio_mig_set_device_state(struct vfio_device *device, u32 target_state,
 		if (next_state == VFIO_DEVICE_STATE_ERROR ||
 		    device->ops->migration_step_device_state(device,
 							     next_state)) {
-			*cur_state = VFIO_DEVICE_STATE_ERROR;
+			if (*cur_state != VFIO_DEVICE_STATE_ERROR) {
+				device->ops->migration_step_device_state(
+					device, VFIO_DEVICE_STATE_ERROR);
+				*cur_state = VFIO_DEVICE_STATE_ERROR;
+			}
 			break;
 		}
 		*cur_state = next_state;

I have a feeling this might make sense for mdev based drivers that
implement a SW reset.

Jason
