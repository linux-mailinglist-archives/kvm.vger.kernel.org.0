Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0660D4D8EEE
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 22:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240373AbiCNVjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 17:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237460AbiCNVjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 17:39:23 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F636DFDF;
        Mon, 14 Mar 2022 14:38:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXb84otQ65EkGDl+R8fDcSIPTN5oSJsCE3jeE74O9QOQHIu9MJZSaocioIeokQ9ze7gSDMnYjhgRMrklE9sliH7/hjgDkUB+mnCyiiTV+yCtbVFFbNTOYy/t1hBOMpW35T7K9ST2eQktD3970ZkcGfFgJ8lYi2DvXQx9oTxcHFHzMxJra1WJxMZVNYrkogONiS7WjTCgZN0f28tRQ3dcQjsHSLy3+bNqMgIOq6QFXAUgnBAhrCY+k7AWhOO0vLgHrMAhBaHe/sLzPQh99GXAIjBtiP1ptAX7nGcFneak5GV+zEno9dBM8AP7rtTxJ/ZQtpb351sApRkoN972XOvi9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oRo3HhNNhsyTfCOAycKpMW50ReP+FCo6fg4jtGVxbJI=;
 b=A2fi7kgwL0/9lgfhMM0Goag1EoKOTR7AT2yRK4p6Dm88msu/stSww31MP24bwToHC2erJ8B3E/2INRvHCHynrFKkez48w/dLhNWX88DJiwHnR2w6HlCQEiLEG5jlU3IVKLtOBVsJu9Y9fucOF5RPR9iDvOO8aYo87j/4QYbjnV9mqQO+IlFcVyxOsRjWRmEAUzLITPAC2jDAYSieQHmUx8ymL4o5tVwz/fMbJQCCdylaYe8N/cNTfFgAvG9ElcD6nNOjxWcAmqfJi3xKvrrMf/WCJuB95r9RkjOSlkcxoNrloewdzIWRUVDenWHi+VzcRKA/eTbhwmFyV0EtHCVCuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRo3HhNNhsyTfCOAycKpMW50ReP+FCo6fg4jtGVxbJI=;
 b=DwS+QhANvJYACLUwdQ+aadOGpd4MnP11s4/XCfzlpeMhWL4xHY5jzzRE3unb5DYzW28Uw4ST7hia5kQ+lObR/gtjjz5ZfQK3LRB2VnE6zGjhj09Ew6Z5aFNMyddOuJmN4BYC08Jmfjl4SUx5CsXB0CYmvugVnbUzCyXw0Hslz8Vc03NbJtCug+CFBB+SN4QWvGcyccwigTh3kjv6bCqLFHW669T5WdZE8UDyNNkTuoWwP+sTaKTtKO2HmZgXAT35e43JGLcZgE8oVNf9zZN3slG3abD7AqeK7Mqsb9HnFQSd74PgBGb0sTDdsxd63vP8m/slCHVukqLnkI+277yJPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB4022.namprd12.prod.outlook.com (2603:10b6:610:22::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Mon, 14 Mar
 2022 21:38:09 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 21:38:09 +0000
Date:   Mon, 14 Mar 2022 18:38:08 -0300
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
Subject: Re: [PATCH v4 15/32] vfio: introduce KVM-owned IOMMU type
Message-ID: <20220314213808.GI11336@nvidia.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-16-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314194451.58266-16-mjrosato@linux.ibm.com>
X-ClientProxiedBy: BL0PR0102CA0014.prod.exchangelabs.com
 (2603:10b6:207:18::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc7ebf55-3193-4ad3-3bbc-08da0602eee5
X-MS-TrafficTypeDiagnostic: CH2PR12MB4022:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB402288883FDBD243423BD2AEC20F9@CH2PR12MB4022.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3TalMx2KwWgYz1Abel+zM8BH5xOMgPP81gC6Vu028w13rH3klHmS7UrYTdZ8SCIwEXtC5UWqWqDrg4Ts4MIXQS4+992zujGmGfsXWOsqaPktSpKIA9xTQR6BZaCcksOtAPAp1ftqOFlPslNkDzq5xQyxbtyoMIkfiYTHU001EWR6AhFNw2/XODwrAwcAZQPn8t/PCgi1YtoiPWbDxAbRhVy5/7Czra8e09QmP0nfpnzogFlJ+gKg5tnbktvOtjzooLKIRz25Q6A5T462t6tfi+iAtJUX1gfUoVufVhKhNIS3bEDtLAf7KtbGr9wugObIcWo+xLpI0u5yyrJeOK1rObhK7gnxEeiemOoqdEzovSRTF/+H0AzzBHZXAlItJizxXdJ151McqMIsGQAgQjPXmEn4KmVJPcPwFui6mWrNtfyGm1WcUZewxQ/VSfPBADApMalJsIpCXWXQTAZit0JEchIjzr+h+ubAuTeaqpNcYTDfD/9/nqXkPODhqK9LKR9Y3H7HnSAQQMqvQDQW4myiM3VDtas7h5TP8c1oXlUJKnap6p7XNXjQZwgJG5zYE0oTi0feo4Uc0aaN4T+qbTm7ovdmob8lMv+455xnQC/46Qejx2nEvYWh1ehoqpUWQxWHGJbQkDLtjcDQOgZM31Ed5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(2616005)(86362001)(6512007)(2906002)(1076003)(6486002)(6506007)(38100700002)(508600001)(36756003)(7416002)(66476007)(4326008)(8676002)(5660300002)(66556008)(66946007)(8936002)(6916009)(33656002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1pyRq2G69GMqbpblv6Ew7ZC1TtLsADCFlLPsabOmDwZfVsmqERuok6+BP4nO?=
 =?us-ascii?Q?cKLw7QfeREPwvTyvNBkVojEVXaNw5h9seYvOHWhzuCF9JFG0RQ8b+m+58Jla?=
 =?us-ascii?Q?NqH46oE9Usd70dHOS3lCGJGrQh0bG8sGvzssb9XMApBv8DYES7BIIwLOMcNK?=
 =?us-ascii?Q?IzHoA9uF3819FNWPCNm2JF6G+c7FJsdlmxvdOr09yJlSkEcRGtRKmCX2SC4n?=
 =?us-ascii?Q?SImAcTNheku8AeR2qEaGluMLa7niqrGSKx5t4dTbz6DKPqcY53sW+RlXsCLI?=
 =?us-ascii?Q?iv3Cwk6+H/jlNRp3BCMmBfYX/I6Dt5GE+6OtnqpJR+f/72zHNg5h26t49zkc?=
 =?us-ascii?Q?SDGU9uB/1N/jW/ncyMNgZxFXTLIMj14R4eJR7ZloIysrPAZXLU+b7eDoZ2pW?=
 =?us-ascii?Q?G+BDSy0iBWQIt9In75BfjHBupqT2oKQcxRcflKx9MJDKPVrQufZTKBeggLhz?=
 =?us-ascii?Q?ff0D8+TdlomQeNmE//mkiTQofGiMSjCMl41vYR+1xcadaAqnEgg4zjdkyaTz?=
 =?us-ascii?Q?A+WkMwXVQeqJ+qnrms2hFYVkfgUUv9SGTyE/IoYjoeaaja2EBLvJ4Fg5TJRz?=
 =?us-ascii?Q?BXzJ3JQwankg0LLUaHj2STZOylRjPt+WIs8BrunzUSec04aJFTrS9ltau88I?=
 =?us-ascii?Q?0N8HSjjdeBo4hUNVdb8qSiyJUV2N+fIt8kfphzfvMTB7vfsNak0rtjBlQVXD?=
 =?us-ascii?Q?Bb3XKMGe+OlDa7Sk5cMShp5MSxYSuuX/vyk9dMuBVmzdrN4HuK6C4v6snNhk?=
 =?us-ascii?Q?einblX8VsLLv6xW6UbL6k3sUtU/+cbsuUnJDnrR0dboG7rAf2xTowYw/7S4v?=
 =?us-ascii?Q?zgTwkUxj4w4+yPxtq0VcHZVXDFjKgHv/GeXoZYwNxKFwqX/QYQHiMzc4TuQZ?=
 =?us-ascii?Q?MfahL4e6ypowEyBOVILur4bORj0j16wPRcwnX1imzUpO5Y1bNLD5DNAQJN4Q?=
 =?us-ascii?Q?baM8idUcLoL4LaVxxt1mpPKtbi/v9yIDtkV4AuBLYoNnDWHPmCs5Ld+vQzKr?=
 =?us-ascii?Q?bN6MZgu1ZfhBURC1e4lqxOGm3WViqixfQ5KW1/GSpQLy4Y8ISqyx57O570cy?=
 =?us-ascii?Q?9oZxUJdfo84XFTCvCG/dkvA70yy2JSE1fKBar9BBPoTK9CSAbxo6ALRC+nxs?=
 =?us-ascii?Q?3gbrxYkwIDDyPViNfP48CChxirfYmRy+WAlrN2mK9OktfMWFqZcwhMQjGqXS?=
 =?us-ascii?Q?QIyOG9fDGx2+6gTYEq0WlhfHd+WjZAdjzZl9zE8VdQ9QOm9GCVB7xwdmvqo1?=
 =?us-ascii?Q?PIoST8JeoMLASffbscI6ZKb+JOa4yhpkovBuU/4kbl0ut3UXpIFlZ+oLNMat?=
 =?us-ascii?Q?GnsFoca34ZXRzpM+M4pET69yM0Pt6j4bxVPrlyLnu0iQJCQ5XhlxrM7QWfbM?=
 =?us-ascii?Q?ML81lLTZ2se9ZLU+AYaXtr9K7d+zqZAkBT3ObQdo+1MliA9aUxRSf2LYvKGv?=
 =?us-ascii?Q?pAcf7JKL9ivx7hcgalbN7C3w7nptMRMl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc7ebf55-3193-4ad3-3bbc-08da0602eee5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 21:38:09.5141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bhLfUSldcY2P53J6XnuHewe+STAtMzIEkQnJOLXcmuwRq1dx4m5DXCc41T9sv87q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4022
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 14, 2022 at 03:44:34PM -0400, Matthew Rosato wrote:

> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 9394aa9444c1..0bec97077d61 100644
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -77,6 +77,7 @@ struct vfio_iommu {
>  	bool			nesting;
>  	bool			dirty_page_tracking;
>  	bool			container_open;
> +	bool			kvm;
>  	struct list_head	emulated_iommu_groups;
>  };
>  
> @@ -2203,7 +2204,12 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  		goto out_free_group;
>  
>  	ret = -EIO;
> -	domain->domain = iommu_domain_alloc(bus);
> +
> +	if (iommu->kvm)
> +		domain->domain = iommu_domain_alloc_type(bus, IOMMU_DOMAIN_KVM);
> +	else
> +		domain->domain = iommu_domain_alloc(bus);
> +
>  	if (!domain->domain)
>  		goto out_free_domain;
>  
> @@ -2552,6 +2558,9 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>  	case VFIO_TYPE1v2_IOMMU:
>  		iommu->v2 = true;
>  		break;
> +	case VFIO_KVM_IOMMU:
> +		iommu->kvm = true;
> +		break;

Same remark for this - but more - this is called KVM but it doesn't
accept a kvm FD or any thing else to link the domain to the KVM
in-use.

Jason
