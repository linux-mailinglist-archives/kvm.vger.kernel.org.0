Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46825458ED
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 02:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238485AbiFJADw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 20:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbiFJADt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 20:03:49 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAA32E93FD;
        Thu,  9 Jun 2022 17:03:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EvQtBfVmRzFXFZAuYv6CAefo1Ay6wvbhj+jY/c/prjqsFz8gL3GrFQ6C1EdIQaWdfEx7tQ9lZ3adQmRDxwaT9VAlq30xzlAYcu1VN8mpV+9KpGffr3PXN7WDQ3P7GQIS5wJcnVdvL3tF2arnuYlqZr+QNqlg95uPwlWyblZdcJLeiXFOFV0IZrmR8XlNJrrGXi3sud/xA40FDJToGLZXKLG6YIaZ8JGTF+I6rfolPJikdbi+QyXnyyC4BIVzuygUzTqW7PZVCiJc4RwIRsx91n+TcAfb8xwK6A2rWshAq2hRhqCehm88stqVa8F0nrEWz/0z56UBU/8DlYkNqn8VAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6qqQHMmqTOySnmLqMZOy5QpxYPjtc8tXCT0k/gcg2gE=;
 b=m8eQCUUrOnCtAOXqkaojP796PbVOcJNbMuVMsBaQKgSuKCeWCtYMzU5rlRFhKUFHg2Uqg/6Ctx28HWdsqXdwLrAj89HMDTw8UjrpNhHikV3ARH0p+7dnYdZBKjS0YSQFFuoOBr7Gr9FlKWORK1BEf263G4R3PCYb2nT9x7cuS4sVoj4woDgXgREq4q69YpqxgtDVEKDBBB9GvWePFKT3YAlxz0rMqxxYhwfHQ8RGcZZWjLMXuayzI+5+DmesOuNGjQDVRmvDGpOYlTr3HHnnpI90s2Ir21jpIvz+4ENedbpaTU59Rmmpa3YjccjZHtMB4czJ9PJoOglEHRvjYh+jEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6qqQHMmqTOySnmLqMZOy5QpxYPjtc8tXCT0k/gcg2gE=;
 b=cwS0Y33v+PYjlQVn3R8xagQ1baoEImWx1uN2WQVPFmACrlhHaaUTQkBSwH1TCLWJ1Q6VpZzOjFDXMm7lQYzvLpIVqUrKOX/1sYfM8InLWTcjII0GQlEu8Fgs/E86z5cNv/0Q0gWqYYqZ3j0tPJ9xbS8DhWAJLx20HAPB8Lkm1MteoDbdzvrUFgHNgUYFIkrbMBgd/Y8K29/Fn9cSOXn/sNc+kINzESLlVQmP1QFKMlYpy584r8J/qYZeoCt/PjSRH91aXtAlADmkwBj/2ReHLaflzv8D7SDbkKR0OEyJKpiq96lNKQsSRMFf5WMnyNDk7tHv2MyIBa3WpQHt/WnrKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR12MB1768.namprd12.prod.outlook.com (2603:10b6:903:11c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Fri, 10 Jun
 2022 00:03:45 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 00:03:44 +0000
Date:   Thu, 9 Jun 2022 21:03:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        baolu.lu@linux.intel.com
Subject: Re: [PATCH 1/2] vfio/type1: Simplify bus_type determination
Message-ID: <20220610000343.GD1343366@nvidia.com>
References: <07c69a27fa5bf9724ea8c9fcfe3ff2e8b68f6bf0.1654697988.git.robin.murphy@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07c69a27fa5bf9724ea8c9fcfe3ff2e8b68f6bf0.1654697988.git.robin.murphy@arm.com>
X-ClientProxiedBy: BL1PR13CA0198.namprd13.prod.outlook.com
 (2603:10b6:208:2be::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e42045da-66cb-4cbb-6387-08da4a74af3e
X-MS-TrafficTypeDiagnostic: CY4PR12MB1768:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB17686C5938ECCA7FC66442CCC2A69@CY4PR12MB1768.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jsfk4YiISAcWhhUwcvT5LSqvKVQ5he69EcNfi3/rnslld21KJT8q9X/aSwJEwM/9vbug3aGHGat5KKOuy18Jeik7O8kgNaSs3HPfu2l7EoSXAqT7/WbI3nt+N51dlHzvQpa9txoHJSyyhuxUaXCYA/jcAbZr2JJ2JpPUbTkvOl1/uRUEEvj1Kh4yKE5zXUS2V54CnWX8JYu1EWexhmFa883rlWKaScXiCTvuSdUZQ008xa3KXKy82vkrv79alai1EXPbjXaD8noylrq0qY5sBCHnQS/I/z4XWKf1zxA3gQAiuqOCmsPR69A/0e5Kx4jox9obwcwKcvbXjt/hxBb7LhfVDrJ49Ctz01jru+rgfKhIKVuPRxxfXpQbDcbnDp/xywGk7oPiO2Zj+UWG5vRlkRVOnfbxZVSH4VvleiLhZWuxZ55bxcAvke+kkkLgtKemu4sBc5sAIzAJIdP3Wvvtdj0NixOq4TzlmRDSBH/C5cEFYn++PkJWVv431qW4QjaToYF+7wntwQpKPmQPaZtIWU2VKuBNkwwkn5rc3EZjxJ34pgb6nMeCz95WZ3f38Nvj4YQr+E4VFImEuEgdr2c81uG96r+ub15Pa6wCg/puUGjZGfiFgzlFUN8CxSlvjlUS5T5EpAz81M0wMs6nGAVelA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(186003)(5660300002)(6916009)(4326008)(66946007)(83380400001)(8936002)(8676002)(66556008)(66476007)(508600001)(316002)(6486002)(33656002)(6506007)(86362001)(26005)(36756003)(2906002)(2616005)(6512007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fTUBiTtRbO2UXFtiI8FMNCJShA7f6zmkyDIFiMPmcpBRFNQ6xKRrOQ66P/8V?=
 =?us-ascii?Q?kqoaDRyTESAm0xqI8pvKIXK8Ar9w7qb7y131PzKRkPXf0WGzD9IQqGCAEGBG?=
 =?us-ascii?Q?cLLMPnlr4tGUg6gycXdkNkpooLfp2QgZQB5X0A7IzPtdcMlmQF32YZzixcpc?=
 =?us-ascii?Q?T4kwf5vjS9xJ22lFsnym3t0XgN4HOjJFas7AI89/KglRjYf5OUH3TASVOGYg?=
 =?us-ascii?Q?DBNQ7VsQ5mzJ6JKhx0RNKycbe4VPQ1ARLObrNzLLJ5uPDNSKcRghu/bjia5K?=
 =?us-ascii?Q?2sc21aTxmm6Ei/Qc6QT9gCh66dHnk4kXX0VuMMeMWwtoZ8LGeHUh9S5Pj2qx?=
 =?us-ascii?Q?se4kKV1hFbxI7rVPJblsALAM4txJjhIi8UmYjAQBty/JoCX1Ei/yBV/3RmRs?=
 =?us-ascii?Q?LsTWMFCgV7LWff+9ur+M3oyBNSLl9PEtVy2NF62hJT1GXPHiw5fTN4UVKlO+?=
 =?us-ascii?Q?Zgm5LETrfrbkN+VffWQ9h59/HvW51WhqRt1LW26Q1KoDGIsAzmMdDpa/vIGa?=
 =?us-ascii?Q?NDjzIoOhwOB/H3vHF5/rYfJQ0ofu1KO0KojDBpt/xsiV2xl6ZfSfnb1Igl18?=
 =?us-ascii?Q?RULBtv7HEGkqsodhz1AoNjtijwhs2d4IB6sTXJZ2QLdMeGv5cf8088iZpQoX?=
 =?us-ascii?Q?qLdjyR3mS5cHWx93cEePRqh62HVK647dzPUwECGNJQa/6KKXnyAQbnMGRUdg?=
 =?us-ascii?Q?CiCjkhhlSJjyIZphfANmfBpmiNoaGXLl9WGsJ2ohNikiHFeIJvnDjIgZPKVi?=
 =?us-ascii?Q?zz8uMggWAlFYuIljbNIhWWAEMqyDn+YW0J2AGIzfBYE/YJfOCZVMyaBsAawi?=
 =?us-ascii?Q?HKSwG2HuyxTLGlOGEN4jcY99JZK4ix1cdX7mEMoHJnDZpqbKhPlGssBPmSFO?=
 =?us-ascii?Q?cAJS0p7tIkxf+IRnC2EGJpt8BMS4UQ5Aajc+0eY260WfE/pv/W1y7BqD1PWv?=
 =?us-ascii?Q?XVWMKZW+/7dVR0hhaet6eAd6urx04+9UXoiGntcnSPXe1ZF3kb6ntWhoAAdE?=
 =?us-ascii?Q?aVj209mwAoCVtRXB/fGfahc/dbWS4GaVQ2bQfTSAjqd8x9pIv+fk7Z41ICce?=
 =?us-ascii?Q?HZ+vIvmqPh9cHI6do4L2InCA9rglZLAzcdAIDXWdD3WsoVXWacomZIraznd9?=
 =?us-ascii?Q?8uSoSC4RYb+9gp9JzDlMBC2n6dRqRMC9vMQRpesX0uycfjsFaTNVbJiu36gB?=
 =?us-ascii?Q?Zg5sOQs61d/7PO89QVyoOrM3HxjR/nlEz5biCU1RvIelZY8yiRQo1d9qJeX4?=
 =?us-ascii?Q?PWVqXz5nDCXOy8vcYTx83w8B4hP3PkvvQm9lmufQtk4QvG8VzZuFykUvv2wO?=
 =?us-ascii?Q?Qt650XZgHCf++mmaFa9Jghwx3OeXM7nxQVaCmoYDbi10eRneaIbBs74h6pPo?=
 =?us-ascii?Q?k5bckrdY1l+YCY7zENe9VXCtPM3CoYXe2ltCHiFNXVQ3I6AGZ/LtlTey3lTb?=
 =?us-ascii?Q?ZCqJlOd2YhcSvnJQMjqkOK4ngUj+gwP5/s5oCRm4iOopb0vW7xMSp7X8Xv2d?=
 =?us-ascii?Q?rdJwvPniJhOUctk4dXXXR4H8Xeloh9l4RPdnqvQvrYUKq5uvGQuaADeOPSq8?=
 =?us-ascii?Q?YiuIWb9poJp040D2zPjw5WX8TCnf/AFEMXsp7/08K0s0LqQea1eh0+GO66Zi?=
 =?us-ascii?Q?+6ttUefRWocVbjtRqUjbu1UdVoH8ZONC0rKYCUrnDlVTjaBI9Yx1ynLcYNYV?=
 =?us-ascii?Q?81W97Cb2ugSufVQGxBJG5nALpce5wa7CeZuDbACLiU0kVol1jZLCUjkRag3Q?=
 =?us-ascii?Q?YdG1TKJG3A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e42045da-66cb-4cbb-6387-08da4a74af3e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 00:03:44.5296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: arPN/1TmNfFt4xxvXW1NjpFXJHdY50VLrVh/MLFY+ioRBnYmWfa4DeIny/uB5k89
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1768
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 08, 2022 at 03:25:49PM +0100, Robin Murphy wrote:
> Since IOMMU groups are mandatory for drivers to support, it stands to
> reason that any device which has been successfully be added to a group
> must be on a bus supported by that IOMMU driver, and therefore a domain
> viable for any device in the group must be viable for all devices in
> the group. This already has to be the case for the IOMMU API's internal
> default domain, for instance. Thus even if the group contains devices
> on different buses, that can only mean that the IOMMU driver actually
> supports such an odd topology, and so without loss of generality we can
> expect the bus type of any arbitrary device in a group to be suitable
> for IOMMU API calls.
> 
> Replace vfio_bus_type() with a trivial callback that simply returns any
> device from which to then derive a usable bus type. This is also a step
> towards removing the vague bus-based interfaces from the IOMMU API.
> 
> Furthermore, scrutiny reveals a lack of protection for the bus and/or
> device being removed while .attach_group is inspecting them; the
> reference we hold on the iommu_group ensures that data remains valid,
> but does not prevent the group's membership changing underfoot. Holding
> the vfio_goup's device_lock should be sufficient to block any relevant
> device's VFIO driver from unregistering, and thus block unbinding and
> any further stages of removal for the duration of the attach operation.

The device_lock only protects devices that are on the device_list from
concurrent unregistration, the device returned by
iommu_group_for_each_dev() is not guarented to be the on the device
list.

> @@ -760,8 +760,11 @@ static int __vfio_container_attach_groups(struct vfio_container *container,
>  	int ret = -ENODEV;
>  
>  	list_for_each_entry(group, &container->group_list, container_next) {
> +		/* Prevent devices unregistering during attach */
> +		mutex_lock(&group->device_lock);
>  		ret = driver->ops->attach_group(data, group->iommu_group,
>  						group->type);
> +		mutex_unlock(&group->device_lock);

I still prefer the version where we pass in an arbitrary vfio_device
from the list the group maintains:

   list_first_entry(group->device_list)

And don't call iommu_group_for_each_dev(), it is much simpler to
reason about how it works.

Jason
