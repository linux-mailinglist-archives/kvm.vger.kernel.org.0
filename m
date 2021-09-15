Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C418040C59C
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 14:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbhIOMvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 08:51:06 -0400
Received: from mail-bn7nam10on2079.outbound.protection.outlook.com ([40.107.92.79]:32929
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233264AbhIOMvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 08:51:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PgAMKUfEiUYKnNc40qvp1G7XPwRZOPaV5lFUKSf9nvJY0D19lMY2oyTlY1d/KiW231/G9i5jlgbasOP5L90zO5sGjYusCohXmUlMxbqUSXBbZ5tmHZw3Pch4zc0kCKMYmnZ5TcQnd0S/oKmD9ckVtKm8V9MC04FRUI+d1Y118OqxKhxc/bikxM2+ntgaWFgXE888yO5J7IYVgT21dUsYKBu2Er80qM8R1r261O2TRFQbLAykYO0KaWC6UtDiCceWlGknwVrd095mXJQ+zxxJ2mXymMdoNw9wRezjUgR8vfT5x3JVF7ArgJYLhdyF9Wu15VSY7QfowlqrcZS8vGNy5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=IDS8sA9eZmXKMzH5p4dTTS/Yb3ILlVf0pW54Wg26GPM=;
 b=Xr7YM/eDiBPSy4pgdMCh/zAWYnk1cFMfLzwBxwq35ya5i546DMe5EqSxD6r5NzPm8x4prFYl/jKkHs+yW5m9S4WKmpYx3bsVYXs+BYRqMLf1CpgK8ATr2qhhPiRtsKecrsaSZdHIrciJLjScZm+SpseDdmabsVe+X1wOQ7YhLbwa6rzNahdJDP6jNV3lRzl98aa45Tx4Vj8qOgGZfTFrigzsb/2htQaiILMk03UqSsrUvILS1zJW1P04X0RN/DHgf3PIq1YF/GOxrFutJs+JNDVes9nkC3xzIquVHx5HFhhRkqGtI859bdlTiPjWprMovmajY5QD55gksSZcwYkaBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDS8sA9eZmXKMzH5p4dTTS/Yb3ILlVf0pW54Wg26GPM=;
 b=laKukLea0HKQTn34aUbGb55uCly11u2raEY+BZ2gXr6HCskWDpZTTt71jRwZeKbdGXCh+IUmFFWdWAo873yQJMe1maGyiqaLK+MisaJ9Aq9noVqRaLGTrZ3+AhQJZroRYiwaUDUaHoT2neGmq/hGv6UXfICjSQd/WQ7n2Gngg/PFWFfSkEiKe45ER3MXSbcnTWyoPmOFxznb0uTyNPv6ARFZaT7PTdD8mkw8BRia5AMNv6Gjs1o8HGN8SyN1bWPPWN77Vb0kp3H4RM7R2dAaWAaAMDR6Qb6bFaoO6A6J/PQQOMSbpfNnNwxhSaAgKt8HP8E/ZThGbP/p0YXIJ/N8Dw==
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 12:49:45 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4523.014; Wed, 15 Sep 2021
 12:49:45 +0000
Date:   Wed, 15 Sep 2021 09:49:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, alex.williamson@redhat.com,
        mgurtovoy@nvidia.com, linuxarm@huawei.com, liulongfang@huawei.com,
        prime.zeng@hisilicon.com, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH v3 1/6] crypto: hisilicon/qm: Move the QM header to
 include/linux
Message-ID: <20210915124943.GH4065468@nvidia.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <20210915095037.1149-2-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915095037.1149-2-shameerali.kolothum.thodi@huawei.com>
X-ClientProxiedBy: CH0PR03CA0205.namprd03.prod.outlook.com
 (2603:10b6:610:e4::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR03CA0205.namprd03.prod.outlook.com (2603:10b6:610:e4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 12:49:45 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mQUMB-000s69-SQ; Wed, 15 Sep 2021 09:49:43 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7acd806-4b50-4744-6629-08d978474b8a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB532005F5192A62FCE4AB8A3DC2DB9@BL1PR12MB5320.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Oxs/DnGqbo9Am7xw2eDn10Lfb7wg1DaEGftiilLbPvFHtNJ0+EO6QIP5JOkE9DmEduZ4gY2dayRxgGl1n0QQvaG/2gAK9iO/wCVfCEKFzwuTzVkQ5AgVG4GyPO+l8/a/Bquy6muCImqctwIN1gx8IP9/T259V8yXNkUCTLSJgmvdIzQQhzxC5y2SiLVMwe27XSlGbAuuiFKZWBvio/7yy2beC59CYLpNodGR9iSeT32dH6Lw98pbgBgqSvhXd8ljVFVXHKpSXYk6mDh+9CCXRfgP3in9D23vZxlYKPIW6wsyst6Vku6Df63QnrPV4k7AixuA146JP0qTtHBWwkE/DjiiQ6GHlZM91dkFbGDm4yYu33hUvKZ5X8L09P+IKNW4yhKlgIEaS7+oWQbtnJATW+DCtfwck5hsaQ4ZNVXnv8kdNJDuYbNSH1UCaV0qXwg/Nvy9lpmjDAwbu1jjOzFgcs264Iop5hFMrzKwAWuYMgsLgabBM9jXL9apr8oP5OxbNoN+QaNVRn55bHjfyzmMWUyYTTZxBBzt5szDfs8msOcJ6qjg6BeBWXLvD/e4x83suQOfxZBr8lQfvZbVARaMG2Xoo4r3mzgaeb7uU/ngAfggo1HyrXHaHwAeVvtcI4JwJramaT1XFpYYdxEI8Ncyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(316002)(66556008)(8936002)(66946007)(66476007)(4744005)(38100700002)(1076003)(2906002)(33656002)(426003)(2616005)(8676002)(7416002)(186003)(36756003)(5660300002)(9786002)(9746002)(26005)(4326008)(6916009)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FTcaKHUZPlwLIYApg9cNcbhfPOzSo/QciGoDRUXfu0Vfc+DfKtzn5Rg20dNt?=
 =?us-ascii?Q?foRqJAKGxuWOeHX5QNr4ruPCHqxLzgL6X9TFy/HeHd6sOP3DvNs5WI15EI4k?=
 =?us-ascii?Q?ZZBpILNHVRjW+NqP+X+h8gDZJP6Ngr3zRJg4J831o5VBXDvJjk35HlUwOUUj?=
 =?us-ascii?Q?pdkZ3IMCkXuD1Cl+Xb06AtCRLuqSsEympJPBoAPo8uiOKV8/L254mxT/WPIw?=
 =?us-ascii?Q?ZNXm7sqtkm4uJFU/0r30n8CIINbBRAGTIUBnT78fzMRx+OmnyDeGSkjtUWxZ?=
 =?us-ascii?Q?riPZSEJpfhh1ylMOwckvxAruIZN9jhy5JdtNyLj7SzYnFvthjOfuBekyoIA6?=
 =?us-ascii?Q?GAfJeIcm0hkq7+zr01Up6IktCqLf0/VfccfiYB6eOySgrvSAseOTxJA3Gl9e?=
 =?us-ascii?Q?lbDry36oiUSKmqDsa0juxIeRXVqz1aZoUC79TsOZX71x0qLnP45AtfGg2ddR?=
 =?us-ascii?Q?QY70CZpMj1vKBXrn1PFbSnDZKyemH7ayxVqrO0xL133YYyPR+3PP275PT6Tr?=
 =?us-ascii?Q?t1+QTv3rGvVNr8ohA2hxxWq1BCa0u9rn4OR3DKhMUaJI62T7CdDRgijTEH+V?=
 =?us-ascii?Q?bH7eieAZrXeOQf36cdVwUxrPPcYbwLbrKZKnC5CaNNqioBf/7SU6MyATK3M9?=
 =?us-ascii?Q?P2vc3PNsBc7uUhpO4l2DjHXEeThI03vObwZx/1tyIyuXKeTWfnkR/R8iE1LJ?=
 =?us-ascii?Q?Wjzk2u5k5NCHVEzgYpb5OLczzVYOLLiOs+XA2fc8mCLVQ9RXOWFLIYt5BUpn?=
 =?us-ascii?Q?AeUG5KmoIrCFD99ZfbRXWtNsyBtdp1/agOWz/KR9P1MMePjvQhPiLS6KPdmr?=
 =?us-ascii?Q?N/SHtYeprw+CtWjtD4DDC06u8PR2qowcmNuz8wb4nF7X6j087jItiIK0Nk2j?=
 =?us-ascii?Q?CWzuRmWYn70ceDo3aPCR2Ua+nzGzthR7C9Vn6QSMe03bVWIaq2AHjI3jfiCk?=
 =?us-ascii?Q?SkB54o/owfSZiQZOHI7kJXh1pJavO8Zj7NPuld+Pmb4RCfUSSMQLxq5q7iZC?=
 =?us-ascii?Q?qIsx1z4Lh+jBrtkUJPkoYy47617gZJga9BvO/wir7KVlfXXGGw2w1/30UDnA?=
 =?us-ascii?Q?nt4IMjx70ZGyxMM+PbdZRgHuQwRB5FMd6B+T3lsr+lL9k1U9BUnYSDiOXEXp?=
 =?us-ascii?Q?0ZXS0OiJyXazSNZEy8ghxkHmPVGh3CwDi103dInOWCltn9vJrS6Rod4jdYIk?=
 =?us-ascii?Q?c/NOHgE2le2aa2m8n8HR3NfjM8JdFxOCJ1rTnWFk9zg+VHsKltYRxipLHNf7?=
 =?us-ascii?Q?lhDr7RphfzJzTqRrnZM19a86lht9UT3OK1fTc9uoccuUwNZCbLLrOyrnoYP7?=
 =?us-ascii?Q?2NE/Q8ROD+oVzuNx4E9MQL+p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7acd806-4b50-4744-6629-08d978474b8a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 12:49:45.6581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gVZaPgL4V1aXPUHsNaNSltu4r5V9L/QyVNUZKTXqDeN0jfJEiLemD+A3umHdr62W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5320
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021 at 10:50:32AM +0100, Shameer Kolothum wrote:

> diff --git a/drivers/crypto/hisilicon/zip/zip.h b/drivers/crypto/hisilicon/zip/zip.h
> index 517fdbdff3ea..1997c3233911 100644
> +++ b/drivers/crypto/hisilicon/zip/zip.h
> @@ -7,7 +7,7 @@
>  #define pr_fmt(fmt)	"hisi_zip: " fmt
>  
>  #include <linux/list.h>
> -#include "../qm.h"
> +#include "linux/hisi_acc_qm.h"

Why < not " ?

Jason
