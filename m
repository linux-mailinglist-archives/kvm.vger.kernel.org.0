Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C3C339424
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 18:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhCLRAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 12:00:25 -0500
Received: from mail-dm6nam10on2077.outbound.protection.outlook.com ([40.107.93.77]:36256
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232398AbhCLRAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 12:00:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PtXnQNz+bXVFkVpyQdqGTdY6shTVT1eI1Y30D3d2pzrdxu9Fxdwp53TKmXK+7g5c+GZKBoFZ5PR9zpDGSQQnz5w2HN0fdYBHD36sSjy2A3ykMvY6QLXx0Y+RjDn3i6Ap6p8sMKdnwYyiVazepVz0le7BFo7/pwd/75/EOzqzql5DAWzwT19eMrNOOCY+SbQY7bBJsQE9FoVSWcT+Bsma95WgAQyEa+XOxVBL6OLxpFpA0Lb2YPsH6QSppycC/QTj+MO9p9H09h/ohVS7zehBeJr6kx2ZLTqvftApExORXxXwYHVKv/HTLm4bic+QWb4CjmFBrv5L1H7sHCgNtXZFwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCZvQoAzbb7YpQc6uFubQc0SA9u4ARgxvrCDTWnzM+w=;
 b=mzv0w7h+5M216UmcqNa2KqTmR44bzEt2+5lja00MDhkMWHHAUf9cF2yEBNxVOKXEd3fijCG/eAJFyOEigHSm4vZeXwtHP5sq1jfi/zx5AQgU5Sq4MJyPBGvBNw4mVctg5LxCfb2AdVeUo3LoSKTSWZp2/qwlWfF6iXG8u2Du28avo55KAwrMboQYwEugIQALKdQ5GxsH5brz40CFcHxyJuHBPorsBgLgXsRujKbQ/iKswdhzIfJURFqH6kOzU+YuGrVCb7wKIJFecDu/guAJv9y/LhmfVYgFU3Ey1CwiBwXLIK6mw8+6fyTq0egleHVPN4J80yt0um6mNLEAlAIK1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCZvQoAzbb7YpQc6uFubQc0SA9u4ARgxvrCDTWnzM+w=;
 b=U57VHY8vqn9O9od+ol4NOGMJg+uhgeQweOTo1AmPYXhaXdBvpdc+J0x8bqYjP9IbBk5yIuLxvWuwJ/rmM7oprMPsEhuPgG1AE+dVPisxnFgyA8pBSVFhJ6MFyfDa+3bHJXjyo4/ab1/FEpIcT3aqBohRip8xRCIbMbWFzfjl0RGZ97QOkUTngm1oIJN6H8+bYwvtft8ypu3wy3f5Mvr1zacjf3IoOfTValxMSB4J3j1eRj5qZl2apDHoZh2u7rqg/OHv4gqtp2ODNA98OsTwDGSgCEAQi+inJBb8H1eEZD8ZofDtBPw8I1OKfiD8M2SAycHyzmot/4JWGbPwhwqPvQ==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0204.namprd12.prod.outlook.com (2603:10b6:4:51::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 12 Mar
 2021 17:00:05 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Fri, 12 Mar 2021
 17:00:05 +0000
Date:   Fri, 12 Mar 2021 13:00:03 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 03/10] vfio/platform: Use
 vfio_init/register/unregister_group_dev
Message-ID: <20210312170003.GF2356281@nvidia.com>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <3-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <20210310072850.GC2659@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310072850.GC2659@lst.de>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::11) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR07CA0001.namprd07.prod.outlook.com (2603:10b6:208:1a0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 12 Mar 2021 17:00:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKl8t-00CBcF-Kb; Fri, 12 Mar 2021 13:00:03 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7282307a-d4e8-4a92-d406-08d8e5784889
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0204:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB020497CDB9453C4A5293E555C26F9@DM5PR1201MB0204.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X/Nk5cHlBlIihOSGaWjsc5q3q7btcbGw6OBCPzYtLQXIpgvio8u0Hfe+PkGcW+XC5+LeRyDDoypH/QAMedotTcPSbNo8fAiBLJsIMama962eroSnYf2uu7oW6lK3GTaW1xgEEjBW9nxoN6dJ4PCDPvxMHGg0rYVKlFF3jqIMVHrUYtTCDvMAoFa1w/Dso0fqw5PPPqGi9I3uRGtdzmwLC8XOKIHOM0S3piP+ElMUNP6iOs8y7ENKYp5xTfsbyZm2WrfdrS+sT5m1Wj3SsboMvjsnvqmi9GwWx87SvRcViekgZK4ts3GwAge5ptyEmYIhnwxahg5qAVGc0+3F5dLoOhdtkShvW+Md3ULcBz0dDJEobeYQ6npcVt09JN+xUv08TbRrc1B19WBk+WdYsa74v4xW43R0aff2Y2YM+UHix9SL5+rDoDvobAGGT7gI0cNV3qYkyWb51/7a1kgQde/B/NG6UWytkqYC4DTst1RPbp9G8lhUjYdaLaf0wVjK9kg83+OqAWym7Twiv68hBAuKkL9uPkl3VKxUCd/SAEKU53ho03HGciJvI/G9BD7nlhtG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(5660300002)(8676002)(9786002)(9746002)(54906003)(6916009)(66476007)(2616005)(66556008)(8936002)(26005)(66946007)(86362001)(1076003)(107886003)(186003)(478600001)(4326008)(83380400001)(316002)(2906002)(33656002)(36756003)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qNyffw39eJvKucuot08vfr7GzVg8aaeDarqQ3zoR0AzeMTU3vmHesYdHXokj?=
 =?us-ascii?Q?SpYvIKB7sf+LAbClpfLWzqQNVOzXGYQy5zOUtCISgOIfC8nRPzb+q5/o3vNK?=
 =?us-ascii?Q?KHYbLdUOUBWaDOK2eksd2/9R28zVGSqi9IIwl8S0u6eRhcYgQm+EJaCeB6fJ?=
 =?us-ascii?Q?s6goZGL6pgg86E2vD72dESP9L26HeIzzRxYbsVpc7CQLsSfJeyu0GM41e+Gl?=
 =?us-ascii?Q?G8WMkX7c+5vc1SGPAzXG/6GCi4fJuHTbryD+0Di3K5hoHBAeRlLRHdX8Fjcu?=
 =?us-ascii?Q?lBWKWpVs7G9j/aQPUai0f+0w6p0ARMXakgsvbEiWNvuoR1bG2DO4KTW1yFI8?=
 =?us-ascii?Q?8ZgGOU6BlyQ+QD9bcyqgCQi3W4v65jX3sauXZ6Pf5riD0HkzvqysF+RXqqMq?=
 =?us-ascii?Q?2dv/B4H6oV11KnLfXI+GPUlLLjC+2q71C4xrL6JtJZvkDqOKFkJVhkn9NtTI?=
 =?us-ascii?Q?pOja782tFBdbjjTP8BjtqiFsXe7hLwg2+30olHFfSipzbU75H80y9bkJ3pt9?=
 =?us-ascii?Q?HN4Fcf9vX02Tl1M0AGPof0d01Pnuxpjs928FgOLnJmoEk/i9Sxu0pf0+s+NQ?=
 =?us-ascii?Q?FTIFkWaxoU8ok74BWcVnZ/GyBWdOwNyqUNIjRscNZdL5X67c2WbxSY9IeUjs?=
 =?us-ascii?Q?UERJhhBx/5/PInOpjvfmVlYPR2EBSdKfMcLQjDswbhnlzlXLNFcz/i3MBOxs?=
 =?us-ascii?Q?WTghby4giL2eWif+2ud5ntAmGoupW6uEByINliRdbhYqfslbOaLkGAT0uqLA?=
 =?us-ascii?Q?mFCueZWvk0UrIPV/PpiSBL2V3vH+niRxiprhUrDzHQnAT5HQgIPq4ba+44Tx?=
 =?us-ascii?Q?N//5an0v4uqOyzJPdqUzhqtchuUEhu9pLTqy5D9V87HhUlPB1RISWPYUWtM0?=
 =?us-ascii?Q?XxfVg2SnhKi2pnhEOiAjSmPvU13RXGdQMLH2NzvBEx4IeIfOxnph0e8Mhwuo?=
 =?us-ascii?Q?XZECDPmwWoQndquXLYykT3263qoeeVcvK6fWAY1b29GF+wsP+bhJAbwxrFim?=
 =?us-ascii?Q?S3JnCUvI66e3j3MCKvhoPwbaI0VpXbZdTcQb3Oh7lMX/e8PBFj5ymOKlpwD5?=
 =?us-ascii?Q?0zzr//7w0Lp3PSpS//M2DjAoguF5BfM54ppjr9qJyLN9GXb4XgXRFZ40CFH7?=
 =?us-ascii?Q?JrYZ+/h0KpeMXEJVcSLgSgK0Y5V+0DpCCIdGX+Lc/sTTDxXFaVDcd+1snKBI?=
 =?us-ascii?Q?RmAGixo0gE9pUbvj/H0pcpuvyJ4rkGPe3R8M3leJdlOxO6MI38+vUTtSdIMI?=
 =?us-ascii?Q?mw91qk8umAdl/QdL5St96bKF7pE9P9ifdQu2I1vjoCCptuDNQu1Gx0cTO3Tz?=
 =?us-ascii?Q?AURr0XNOWYayzZ4EPwqPUNMyzZsf6s3GdgKo7i4IPQzJcg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7282307a-d4e8-4a92-d406-08d8e5784889
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 17:00:05.1502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R/rad23ECxoZxgvUiqlMyF+JmKIhSFoDJRxQTz2geDht6LUzxGyMOakvzCHv7wsy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0204
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 08:28:50AM +0100, Christoph Hellwig wrote:
> On Tue, Mar 09, 2021 at 05:38:45PM -0400, Jason Gunthorpe wrote:
> > platform already allocates a struct vfio_platform_device with exactly
> > the same lifetime as vfio_device, switch to the new API and embed
> > vfio_device in vfio_platform_device.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/vfio/platform/vfio_amba.c             |  8 ++++---
> >  drivers/vfio/platform/vfio_platform.c         | 21 ++++++++---------
> >  drivers/vfio/platform/vfio_platform_common.c  | 23 +++++++------------
> >  drivers/vfio/platform/vfio_platform_private.h |  5 ++--
> >  4 files changed, 26 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
> > index 3626c21501017e..f970eb2a999f29 100644
> > +++ b/drivers/vfio/platform/vfio_amba.c
> > @@ -66,16 +66,18 @@ static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
> >  	if (ret) {
> >  		kfree(vdev->name);
> >  		kfree(vdev);
> > +		return ret;
> >  	}
> >  
> > -	return ret;
> > +	dev_set_drvdata(&adev->dev, vdev);
> > +	return 0;
> 
> Switching to goto based unwind here would be helpful as well..

Hurm. Lets just delete vfio_platform_device->name.

It is only used for a few diagnostic prints and in all those cases the
print is already a dev_XX on the parent:

-               dev_err(dev, "ACPI companion device not found for %s\n",
-                       vdev->name);

Here dev == vdev->dev.dev. So on platform this prints

foo_platform_device.0: ACPI companion device not found for foo_platform_device

AMBA will print the periphid, but someone who needs that can find it
in the sysfs from the parent name. I wrote a patch and will include it
in some follow up series

Jason
