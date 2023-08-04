Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401D577069E
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 19:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbjHDRDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 13:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjHDRDs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 13:03:48 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD584C31;
        Fri,  4 Aug 2023 10:03:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RSnyv2MB30Zcetfx/jWToG4S9r/d4oz5otqmbk2AVK9wvpxyRgTICHurO2MRqg0cJrHFXAO1qdHoPE/5nC67yu2SugT661A0poE4sJkLFFM9Kyj4g+CCSM8Zj7r+fy+XcAjJF70W6JtwlgQsggEGJScwwI7BiBV//R9NHtHJ1b3wUk/Bw1hY4k1+ZMs6K2+8frg/LuVaKiMXRaQVepZUQKTUodFMruqk35fMsFEmT9oXGSgalsNP3iLPSw2nYVaFW3JT0CknOgq0expr+YJ7XrHe6868FxI5xCqnxKQCmduNPOFsSMPWgPZcREpKTDD2mPrrYQ7UWMMNXTcbih/UGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hnXc2zZlROYpxVbQ1wjjrFn7p6EuDw01Cxf12ace1no=;
 b=jxT/TtAaJ5z2xIYg8kzx0T8pTk+ALkC028cDAWuGAjIrzhs4fC2TRMZfLopGSNsUI15F4te44uSd5ivcN3+j5SwpuDSvBqPx+U92o0PHJvn/jEhPiUQAF9mEy+GN4u+COsvuRvrUlQGf4n6JQPlNiTwroen9scZ1wBu03KwTPjNG4MTkBmJKUuFqKdz0DUmaew31HuGlduuFMjrx5lPOgnnxqku3jpmrJioi2ic/sWpibmVB4GWjYIqV98rXy9WvkXePqSE6P0HXitIZqZmEWE4uYENqkhmuW6VhIk55gSQ8o2vtvWDa6pwwWBVM7D8Ud7Xz2W9V7XkOE3amrCKmIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnXc2zZlROYpxVbQ1wjjrFn7p6EuDw01Cxf12ace1no=;
 b=BOS9DxFGPurJjUiR0NV00DBKyc2IBiY71VUg+4kDptKakcq23EzdMi3vtKjX1ikmPGtZT0KaE45cQAE9pWMyMKj8OLkwoldZYe474pULYrK/W+F8uLvOSMLLfsxZeHGh/kIj3/mYaXxlcB7gWK9+mMijrgmKy1yxXeTR01IgZXPISs14BcOBObpN91u5IlthxxxfXl2l0HUzM/HFR5ba+Tr68QHDNl9JnSHpJiL11xfEhdOkNdUZH8aBOO+1rtVf69hwO1et/jg5AUnX0tRPewF8izKd6Lw1XA13ZREtX/QBEky7wEwauKAaCM+2wbMOhv9jRMWWGzSA0rRVjuRieA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5903.namprd12.prod.outlook.com (2603:10b6:510:1d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.20; Fri, 4 Aug
 2023 17:03:11 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6631.046; Fri, 4 Aug 2023
 17:03:11 +0000
Date:   Fri, 4 Aug 2023 14:03:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        simon.horman@corigine.com, shannon.nelson@amd.com
Subject: Re: [PATCH v13 vfio 3/7] vfio/pds: register with the pds_core PF
Message-ID: <ZM0vTlNQnglE7Pjy@nvidia.com>
References: <20230725214025.9288-1-brett.creeley@amd.com>
 <20230725214025.9288-4-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725214025.9288-4-brett.creeley@amd.com>
X-ClientProxiedBy: BL0PR02CA0074.namprd02.prod.outlook.com
 (2603:10b6:208:51::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5903:EE_
X-MS-Office365-Filtering-Correlation-Id: 294dac5e-ceff-4be2-3834-08db950caf09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D4UFjX9tt6eA5CB9VGqvovmzHSXFHJF871rBYkHb728izMBS3AF7CGHkR23oF79DyAU85SpAAajcVBaD2ulUttq+EVZ92d+jpo9ld778KBlbavTpxvV6et9JnsYzIVu9JkVKHt3rpi7rcKidKKFE7tTx0ZM4jJF70vEkEbFjYaU4/Lf605xJpFr5PAfW1wkQrFmzslOD3J+PfUUHUrsgQLPYbs5qDMarni4Qpkv+rn8T76FqlV7V3FOoOKmcWM6RYT2SRil+7ZZaMeLoYgYcMTpEzdBJBa/BGWYP1iT5cTzJ0pnzCz0BCNuY4iCVNUpoyycJOpMRRHMjC8kijnkEZXOC0Dj53e9ZOVacwngbXo+SG2q8SLumEdYKpjn+Z4+KPnz/9EqFHTdElJLp2P5XqPQsZGXUt7eV2Hmtm0lPOYf4BvRRIA8IPLVWWTcIu+O65QjG0yUG02BHFkX2DslIuZCIDztz+07yZpWT5wDDh5g1JJI82+q8bTII0TRBX0xlwzco4rB21u40K6z7EhVfvZGqi+YxB3sxOFnT6vAvHWEzQfMy/BLlZqKaqamYSlB+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(451199021)(1800799003)(186006)(41300700001)(8936002)(8676002)(83380400001)(26005)(6506007)(2616005)(38100700002)(86362001)(316002)(6916009)(478600001)(6486002)(6512007)(66556008)(66476007)(36756003)(4326008)(2906002)(5660300002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uiSKCHRVmcrA663N1lqmeBnyzNkHKkW2ln+ecmMV6dz+5jTdkJiLvxfMEff7?=
 =?us-ascii?Q?3x7xao082QN/1VSZaa2zq8iXYdQ0jSQV9fGALFt1znY+cqZkmh8uLEkVndfh?=
 =?us-ascii?Q?P7PWn9XSbg8IyMEfT7b0RT1WW1kZCtSiN6+1wd1DH6yzaOf7jC7WmC7WMr5T?=
 =?us-ascii?Q?LpnPKh8mX6nUvqy8mJ23qL+ec4hNduHHW1k68zm1gEy4WR5bC3NVmGM9cSm5?=
 =?us-ascii?Q?nXmwtyZqMWw2jSkHqXt6C8UON2+1f+BFkCAL//HpAeEGIy4q0JNdPiZCbU6y?=
 =?us-ascii?Q?zG6r3WQAboYsR2Q+YfV1qQSFwO8qP2QGJZMlsRCwIid5IAwaO5XwMBwiYN4T?=
 =?us-ascii?Q?0InM5bJ4Euegm0tJQcZYE6sOr/8RwszFgXLbdgmHN9XT76vnQORFdaKiddj1?=
 =?us-ascii?Q?GDVZExgDOT5FgJmOYi4IS3VNDwW2iZ4I0XcI8J6KO7BAF3k+D8QqcIlEBCbb?=
 =?us-ascii?Q?cmOSOJjLHSbl7wR+Mp6SkY1K3M+fsT+c8j0rr9rNAud9SbVbtR2c1Q04KRkS?=
 =?us-ascii?Q?7rt4XOMhgoJLFZpawgmnGyxGFv/3XkgbuDSklwQMWedVm3qSh9hlkOswdwqN?=
 =?us-ascii?Q?7uPF8ihs2FOkyO+nXEDl9zZLtCE3wAc+cor2VBpBvusJks5R1EcyL8Q+IHks?=
 =?us-ascii?Q?SpH5kQ/og7bwy9U6QaKmg6O3s0n6XZlaqbYfBkTgUsRVrvIm+vwaops+eilc?=
 =?us-ascii?Q?ljqbnajC/WLILDHzr6D+HPRaHel1H7V277jf2ur6wsgPeSSHzYhnFKorM8Ar?=
 =?us-ascii?Q?RCA0FG9PFNgAzoj0LbhAqI2tENjFPuQACpWeRMwbIXulDUsBG0athoYgvAET?=
 =?us-ascii?Q?dLWwzYzai7wWOH2igtYLe/PRCTEDBH6DsHqSo7ujOECeG84pAoh1EeP9NDpp?=
 =?us-ascii?Q?HW+t1waO6lFKkyze8EDwCSChhdQOZuPVeYLma/YlpZasazYXPtN/vCrnoUcy?=
 =?us-ascii?Q?6MijG2lAQnHm0y4fPCBoFBZQ6gC8vNbi7kOsYRGczjD4lBa5q8OyHSTwSQl5?=
 =?us-ascii?Q?xcLZm1KoIg//N10LLNQiTK1WAAy6oP3ruUML7V8Co/dsO6H7occX8jn33qhM?=
 =?us-ascii?Q?OV5h0uC1+N/qFHCauNpWH1z8+irkyjDe6nBFnDqxwHY3UZ+DcbtZ/QHeM8Vi?=
 =?us-ascii?Q?dpo85uh9DR+DSTc//BhMvYr1fACPqAVBPu+RDmc67ZLtD2yJWcLC+Svg8S7R?=
 =?us-ascii?Q?eCJatTH5FV/94suaDdvQhxZJAZmYwEufBZovm6zjSdx5OjMPlNuc4PZHgazj?=
 =?us-ascii?Q?NnnuhtPMelHHou23ZCMlZkYxg2Q69/weY4rHKH+pT4ZgoL9EzT5IY2mZJBds?=
 =?us-ascii?Q?Hc2FKk2mb3TbFvdaOH4dmGyvRhgoyzo/ofzdP3od+w1Z4DtLf9+5OPY1t0zm?=
 =?us-ascii?Q?csqTLfi+VQPDpnQiyKI8LhMqtIVymVJLmJkulH6mnZE5oA7CK6JLwYOixcWP?=
 =?us-ascii?Q?OSrLuBDzGnE3m0EnZ5ck2vCNuXL+/cpBuSZxklO8HVv8yqHKdcL1nVxnxf5A?=
 =?us-ascii?Q?pHZZT6DPcGKFOZxehzPuBzNvYzrrOdd9C4anBVxpfWdNtMvoepUCbKoynGry?=
 =?us-ascii?Q?UWnIQif3olIZvLM3vBtRNI9A4M0QnuZAVeoieham?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 294dac5e-ceff-4be2-3834-08db950caf09
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 17:03:11.3135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3qbf0UtqpSB5YAiCtNvhTgvD4bA0N8Ez7t/m2weJwB+4LGHanZcJaq8GzJqUU7B9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5903
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023 at 02:40:21PM -0700, Brett Creeley wrote:

> diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
> new file mode 100644
> index 000000000000..198e8e2ed002
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/cmds.c
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#include <linux/io.h>
> +#include <linux/types.h>
> +
> +#include <linux/pds/pds_common.h>
> +#include <linux/pds/pds_core_if.h>
> +#include <linux/pds/pds_adminq.h>
> +
> +#include "vfio_dev.h"
> +#include "cmds.h"
> +
> +int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
> +	char devname[PDS_DEVNAME_LEN];
> +	int ci;
> +
> +	snprintf(devname, sizeof(devname), "%s.%d-%u", PDS_VFIO_LM_DEV_NAME,
> +		 pci_domain_nr(pdev->bus),
> +		 PCI_DEVID(pdev->bus->number, pdev->devfn));
> +
> +	ci = pds_client_register(pci_physfn(pdev), devname);
> +	if (ci < 0)
> +		return ci;

This is not the right way to get the drvdata of a PCI PF from a VF,
you must call pci_iov_get_pf_drvdata(). 

Jason
