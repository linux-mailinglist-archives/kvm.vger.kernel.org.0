Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768BD64ECA9
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 15:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiLPOKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 09:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiLPOKS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 09:10:18 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2305C771
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 06:09:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oRl4gJ/qeMn0lwb0viMwrwTs1rwU6AbnHf3W0we7PwJ+34guLYi+Sp+mtiEYC3em9GGuOnsri5vdT8FM8bobTPCFWJmXgBhRFU4VtpwRFGyh3n+Efw6Qtv6RMnOPUCoHhXaYK1kEFefcick1zdw3iTjCzrVCMQlbejuM9jZW7JNbveaEK1ksu0WPMj7Ln8I6og8ZuScNFSP0agKzVpbdy2198HwzyFSv1UP2gF2snJxS6RuPamuJhyD03Axhlx4OOYfvGMRlf50PwcqgYYICU59z4rXsRbOIPHwRjfoKGVJKBj2shl8TtLcA1tBTUrBKyQqz3cHcxK5s+tf2q517TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugEqp5Ze1xB0i4RQJa8+3peCNsm3MLJDEXokOA4KYO0=;
 b=SwvRxuNwXXxd5KiGJBKhCIZk6MHj2e1CAA9hBVkd8mVc4QzbAbM9SmKfVsB1Y0U+dTxR4rwvczidYlNVGtsIP5ojDzeNr/FSv0lqHZX7qGi5H5GVw5vraXy6C+REUqHZZOmipgtMn+UkuNCYpkTtk2dZeONYPA85QdIqh60V9p3mJtkFDVgY9m1e9h10HBbEvnwdX5XbyALsUCZo2/PEMSuojXLc5iCGbFXYHPDCQ4vlNg7ewYA4JdohR1qjNbiLeJm/FITb0XmpU9ZtXSCqZYwTBBlKUuZ6SZo1pMC1y54XX98IPBizOJs2WGTHt2wgUYscKK3rLrdxJB2PWJPkyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugEqp5Ze1xB0i4RQJa8+3peCNsm3MLJDEXokOA4KYO0=;
 b=rmcgKYme9uRpu7jueZmsJP8HX4Tmtk28yDKjAWysAGEnwWLVeQz58EL86a7TcmE4IsWreHW024ok0+UkK77Zro7LhcKklq0jWaVVLs3P9ndPLMmmiva3CbnazJ4yKv10dIU+QdsQuA6Mt5EBz3MLc2iRknePwRrfNyjMHKoqGmpyV6Jb0tvj2PR7pudgN7+DSuy+QWnvZ2uZqr2dn8hHNGd/0Mq2j+VbdkjaakREnJ357Uv0urDAKg4n/AgZ8dUHokonFfsH5pN7C/1/nVKIg1ZM95aWFJ1nPmZEFSKpXGXg7CPJfwqCRaXAAio7YSjOzrMHXwd+e10ZIKIB70TcPg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by PH7PR12MB6695.namprd12.prod.outlook.com (2603:10b6:510:1b2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Fri, 16 Dec
 2022 14:09:35 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::463f:4cb7:f39a:c4da]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::463f:4cb7:f39a:c4da%9]) with mapi id 15.20.5924.012; Fri, 16 Dec 2022
 14:09:35 +0000
Date:   Fri, 16 Dec 2022 10:09:34 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V5 2/7] vfio/type1: prevent locked_vm underflow
Message-ID: <Y5x8HoAEJA7r8ko+@nvidia.com>
References: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
 <1671141424-81853-3-git-send-email-steven.sistare@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1671141424-81853-3-git-send-email-steven.sistare@oracle.com>
X-ClientProxiedBy: MN2PR07CA0004.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::14) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|PH7PR12MB6695:EE_
X-MS-Office365-Filtering-Correlation-Id: a7c0d168-cdbb-4398-3ec9-08dadf6f2937
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g3lq7M5Jbw7H9RUV8afIuNvLxNmQaI2b9Y3m8Gs9G1wqS7r4q+CGpxhvUGtbeOY85xkH7BVy9RAwspzdawz+7XzAi/0ktYRGsu+sZOT2iHfT0E2B5YkTPPZbaFokUa7ec3JDXAC7xRq5kxrir0l4Djv222yPHC+sr+4VjXr2BIhb8ZF2zBkYD+bJ32k9FO+QJvyl5E71KCK7DM6wIVrcyVg3UxlWLCRMQYW5m3qwiABabkwP6yeUupACXIpitXCsv76irSn3stG1NpTbSFye0B5K8PzZSU9fh22vPOmdr8ah1EuqDTjTWprNk9+QEd5hto9oZ85h/vfW03xFsp2QayM0MYK/uneyZQI6HXwZwHbjsFE5FEyFSbf/EjLdikNBmrBIULPmkVnI21i8++ocZJ/QuDlc5S0BowyGWnvDqNqFV6F/COb7p7A1CXLD0z02lxGPyA/62Rpnw1BkxtFN9FQroj8qYQY03suZerU+15BVJPLfodPgUewI1U+d+b9OTa4UyDgLTvq+dqCqjz6daj8riafYupmSDQSqy/bJ0aoyb6jhoZ/JR2ix9NDyjQkK9Yf9Ly2T94VusBUw7Ai98hYRKx/5KgWUb/q3f9J35gL9Fr/012tzfxhgMw29aWL1h8by3cqfhNLg53QiGnJyFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(451199015)(8676002)(36756003)(38100700002)(66946007)(66476007)(66556008)(4326008)(41300700001)(86362001)(26005)(6916009)(54906003)(316002)(8936002)(6512007)(5660300002)(2906002)(186003)(478600001)(6486002)(6506007)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QDu8mLUQO1EDIpsZuGArHfOUnv0UofzHmvk76XIgiBMajNF9yCoyHAv0MYTZ?=
 =?us-ascii?Q?68bgP1iaiSHp3hz5GNkIESnAB/pNKc9UNDF9Lbylv1wufwtUG9wZhmABovVv?=
 =?us-ascii?Q?jY3yJTWafltbylf+ZyTSuUm+MJmn3F/BKL6UsJBrCl5kXHFf36JrFc3Rr6ur?=
 =?us-ascii?Q?3tNOiFnmGq4PsMa8EPN9mBFd4XkARPlotCxuTI7tBttaAgK0zD5n8o1qRMeI?=
 =?us-ascii?Q?9iuIkL3lBM7Scrc8iKpQqDK944dftEyWWbBocr51JaCkGxdvr0hrPkWaqdvg?=
 =?us-ascii?Q?HiScAT8JloFh2PhzPDpsI0npzS0zZzla5ruLyBPlUf6gim99Q18y6O4qJEb8?=
 =?us-ascii?Q?Sp241zPVB0XxupBPBrR8L1uc8uVqqt57OeEEmOOBCLi+LkRIelkvS65byLTZ?=
 =?us-ascii?Q?pnHFpS/JVSwOA3ncxfwShThanemsuzDc2z8y36kKse3yOlv21TlI+/DB5Otz?=
 =?us-ascii?Q?9gn/L+BLseanQ4nnsgIlk7jo2oR2zby0IdhC90v5mQpHY/yKkL/+1/f6hiJY?=
 =?us-ascii?Q?cUjSSrBECwigiIuZahOmZ21RAAc08fx9zO7IdkoaZ5B+E3LrpihwYdjm/Rje?=
 =?us-ascii?Q?D1Ssn/8wR8Pbab7zzDqkPdyuEJFxa12tGGDwAKJBdxcgnkRgnUCXIPXfd/wV?=
 =?us-ascii?Q?+QLkiMNR7DyhC0jf9PXxEaOc2rOw0rHo17v9yBIxfVGReZSFWAL9saRnCrR9?=
 =?us-ascii?Q?NUOAOCnFhbdaDZ5j5An/IPhmbpAtoV3Dfvi3DS239PiDzPZCFZmwqsZvUweT?=
 =?us-ascii?Q?3Vi0WppAK/ybq0ryQC0bJsftapYy3w7sVwDHK9UoXTvP/wJOoRCKGgzaJD6j?=
 =?us-ascii?Q?lDZ8HOtCNf50bUgfHyPQFkq2G0DtCmarLEzvoxWpZRhVncjEp/Tc5OUqAzWy?=
 =?us-ascii?Q?7d5iGZlAveikOLHR+d2HmiX8K+FlJy4lHfdPdBS20tvdY79H5cLlP67se/tn?=
 =?us-ascii?Q?on+WBjNIPVoxWNem7Tqh9AD3+b+ETPnrB3fBUy+dmqotxp/b3s4YUfrBDDNU?=
 =?us-ascii?Q?0hOzU4lRqQaKGUN7BGi2cmxfB7Yc1Y48vBWbzKXptsiV1gmRQkDGaKAQSWir?=
 =?us-ascii?Q?Qz6vczJhNEDLpmiAVORw1j5ZcllGxihEKUqKPnxjw9EhbdHd7nxp0DB7R75l?=
 =?us-ascii?Q?EPIRKASTiXj3vwiTW+Ru2xoUZtEM0Rtd4NT9Hmb8ehC4AvEQI0U/zm5eZuAO?=
 =?us-ascii?Q?fSzwc2ylWv6nXpKZQ5YWMCzD4u9AM236F+ER+dKTM6sw9Bx5yyqzyTq0H3Kg?=
 =?us-ascii?Q?25HI42jF02HAHz8QqLJaWDuwY1vAUzrak6HFKBcnVYP1Ir8/KWVWRmfhm9xY?=
 =?us-ascii?Q?tOFHKSQiGZ/f/5byQ8+LNZwu55wJSwNFCJXRghsVFrFmNMr6R0hJA+4aRhmw?=
 =?us-ascii?Q?34Axj7sp610xzcDstfY00nN1FPRKAkJbi58w5AJ8fKaqaph2jInYr+FvsIQb?=
 =?us-ascii?Q?m8wWNkDJBoxUTJGLl1mqt57EfM1XlREv35tfJvRW+QqFGhyaK9mxSdiDB9ZP?=
 =?us-ascii?Q?kRMoGlCNU1zmWhXucKXuwhWg1NKMsEpYQnf2BiPMFdVuo4++vGmxLdakmrbP?=
 =?us-ascii?Q?bqUt8BfcFvLXfscDQ0I=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7c0d168-cdbb-4398-3ec9-08dadf6f2937
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 14:09:35.4071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uXI/dq7/hoH5y5MHbAzNLebZP0T/gH1PYZXep5/dy2AlCwufXHhwu3SUqMCbYYuJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6695
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022 at 01:56:59PM -0800, Steve Sistare wrote:
> When a vfio container is preserved across exec, the task does not change,
> but it gets a new mm with locked_vm=0.  If the user later unmaps a dma
> mapping, locked_vm underflows to a large unsigned value, and a subsequent
> dma map request fails with ENOMEM in __account_locked_vm.
> 
> To avoid underflow, grab and save the mm at the time a dma is mapped.
> Use that mm when adjusting locked_vm, rather than re-acquiring the saved
> task's mm, which may have changed.  If the saved mm is dead, do nothing.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)

Add fixes lines and a CC stable

The subject should be more like 'vfio/typ1: Prevent corruption of mm->locked_vm via exec()'

> @@ -1687,6 +1689,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  	get_task_struct(current->group_leader);
>  	dma->task = current->group_leader;
>  	dma->lock_cap = capable(CAP_IPC_LOCK);
> +	dma->mm = dma->task->mm;

This should be current->mm, current->group_leader->mm is not quite the
same thing (and maybe another bug, I'm not sure)

Jason
