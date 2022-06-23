Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8CB558A5A
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 22:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiFWUui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 16:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiFWUuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 16:50:37 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7484D9C2;
        Thu, 23 Jun 2022 13:50:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QaZVFMFgTURV03ydRH/qoFNcLaYXGuUZqBg4CSAIgcSqSmK4BXyLDDbxVlytIw/zWNNtvyYtaAcV6t+bDeGnHxPc0VIBGhA9qlFqVlJnzEgoQIY7fBLUgB2Ospmd8AcuogXNmhtl5xRnfYoRrWtVPu8tKsncGOUjWdU3TKugeLxisL6b8vpCwnzZ6XFuaGTc4zngQUbJ1slNhR9z/q33IWVNbrGAuECsDnJe8M6+THeQISOd5UgU6KD6KUZeS6RGBemiR7BC8u9PmJ5wIJtp+1AmtUTZkRpTxvMKnSvH8qvSYDTViBn2ie2acUvcSxqotgqi07NlJFHfYShXd9+P7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cqKdjnjHQ5n5G3z3A0A1RcCvqHjiTAVA/wUWl6oZ/6Q=;
 b=I8lKCHVpqEzx1/ZQlLqfLWfjItlpEdWzA+/JXB8dKPPysIMqWk7mgMYAisA3hJMuax5GMS11AEp8rToDSIKUgIQ3+ZDZWn+4//VffT1xYeP9t82VO5hc2wmhgXJIaMzcK5xSCTGT++LG8qbiGnQdKsxH5QwMr+FxX5nWkWVb0V8jtsaC6n08AVNmC4xApkqeZgqsuB8goriRecqGC9TCQusHdjnxQ+mN7ZsYT6lmC+ckzHaRwJ6pxzgNy7isuT/6Zp8nEKuPHgv9juOKXEse9R1jA4WfBOiwTm6QkiREv54L/RXYdloZPSdMgiWKKqNiMctrBeyiY0aMbQY5JmkuUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqKdjnjHQ5n5G3z3A0A1RcCvqHjiTAVA/wUWl6oZ/6Q=;
 b=D+gUEUB/l7A61gVJS0RC0TatuTsA42zWp+zT+tEJz7ZXotfXAO1vADZKAaIq+F7qMFxy2LTyrvtQTr7CV0kgh5fTR9rOFRUDdyuyfvL1iXyH/pZ06M57CO8qaFdmlwmbkga2QCBQaxCMwyVFrgHPRpSZ+SCd8bAImqvifxyKgSzA8uGhoUlRo21z0g0dTIAPBkzzMtMbX4+Vs95VJ3PEnAj1lTfY1LVMW3Nxt1UpN6XbSgpk+YIX8zGLEUJd42Ty44j9MGhnrQ4sMGRT31KfrbD/h397eHMbqyRGeP6eLYiKiBcwRn6UIxPSEwkvtshImeXAlepk2q3DuCCJbSkB6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1282.namprd12.prod.outlook.com (2603:10b6:404:1d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Thu, 23 Jun
 2022 20:50:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Thu, 23 Jun 2022
 20:50:34 +0000
Date:   Thu, 23 Jun 2022 17:50:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, cohuck@redhat.com,
        iommu@lists.linux.dev, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vfio/type1: Simplify bus_type determination
Message-ID: <20220623205032.GH4147@nvidia.com>
References: <b1d13cade281a7d8acbfd0f6a33dcd086207952c.1655898523.git.robin.murphy@arm.com>
 <20220622161721.469fc9eb.alex.williamson@redhat.com>
 <68263bd7-4528-7acb-b11f-6b1c6c8c72ef@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68263bd7-4528-7acb-b11f-6b1c6c8c72ef@arm.com>
X-ClientProxiedBy: BL1PR13CA0174.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 202ee41a-1e8b-430b-153c-08da555a0496
X-MS-TrafficTypeDiagnostic: BN6PR12MB1282:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hv/AQK4iwzsiUgxxTGmTInf7xHWbiAmRFi2NugUeBNquOQn1zmmbtkp+9aq4hsShiuixd9DQH++2w+ZEKZvP4N8jriVqO58Cny4beA5jPEBl/RMJK6lXNA33wRubIbh92bLGjn/65+eKJU5kNr3/3cxJrntLJxQZaFcIs/Uz8IBXI3JJdNwFMq+5qoImlZg72/8blL1nWGe1RXHTJQjwSRYau5u7lg+bVxc4a3tUL7AP+Dqw8zcdm4PwENDDeXpqPCZGKG/w2o7vAihmKYyK4HlUuFxSzcNPVNR/8oQUQgws7W8w+u5/3LtEn2xelgTYjOTsbM9aVkOdIpmL21576pQ+St8aKXHZhp3vahQ0tK0BkEkO7FsY4C5G6Tf34rwlGQUCNcy9/8pLi9/qcuNewe2TMLycSye33OhpdQ04eH5LG2ts+uQtQ4BJMzdYtaxwo2MoKWHT/ONKych6gw2pBDya/Yt/XniLzMiDPUvaDQr92D/4fdPItPULBr3i3HkgjMe2fEtMGB28TW0q78MVucNUVdYh0aVuCRjV5zRfXoMg4uD54Vu5/xLIrXzJk0DHLmhuNE7gLydcCOy1vv1XQlMwuKuVj3zCRL1NGADMyiXTg9zQOc0UEOmFDV0QDRByt2wkqc+fV0FzApzHwT6str3WuVq5SVEN3xNrz/STZxJc/1+gJiYfn3lhRdJlvFJ1+VrQwWVMXJxIG3ASachUHcmtPjWEo2t0Y7tp4UG+z/3hYU6OjCTZE0bADdRudaFx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(366004)(39860400002)(376002)(86362001)(66556008)(6506007)(4744005)(33656002)(66476007)(38100700002)(2906002)(6486002)(5660300002)(8676002)(26005)(6512007)(83380400001)(316002)(478600001)(4326008)(41300700001)(6916009)(36756003)(2616005)(8936002)(1076003)(66946007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uhctTAP5nDmjbxp6+1GEfnh3rjot14/GDwv7mjA/bnbyd2Kb/6c3hTtvUfA/?=
 =?us-ascii?Q?Z7KRf1i2ayF+1jMB3HkHugw8hAs/UaRmLEXTO4aiU/9hSJMQo0lrGF/9M1LL?=
 =?us-ascii?Q?If6ZSLFbIVW+ofTNOmmhU2FKUe3CUvVGFxAUGx9hbkV+/vxoqlzvkbaMbDL/?=
 =?us-ascii?Q?JFl5Qn6R14Q/C076D0tm8sGFnmBiKN6FZidxDhLWl32z2Iv3WFJBh0flFhBZ?=
 =?us-ascii?Q?ImYYI9CcB2FGf3MThhUXiHE5lLn3b3ofIhLcI+N59IxkwYFgBKayEVOX030w?=
 =?us-ascii?Q?gnSPGEKTetHmE6VGyPqTfsouoRUAWL5AcAz5O/ivgajNpdYF4z4lfBxCg1jE?=
 =?us-ascii?Q?FOLKo5gRyUtGBudrntBY3jKceUnrXW6tMsYoSf8RRsLcjbO3h9mDGFzDwdke?=
 =?us-ascii?Q?65Ms/qkFg/KsQZnl5LetgIRcymzRnGm2mmD/wQ6NJ2W5qyfzo0mCAAbzhrR+?=
 =?us-ascii?Q?fCZfBXuXOh1boUM7RGLrd45X/6G9MOUhv7JEqZJnTpLWtX/wnpRipvTt+Z1v?=
 =?us-ascii?Q?HHhItsYH2xTKF+HfcMKiiFSXWvL2Ox1Rt9JJJdJnlpt2DGTviCCyUAH9qndd?=
 =?us-ascii?Q?blZI+y6J/ZX4hkLW42laswpYnj8djbyb89HTLId8YN2PFS0NkqqiZOtF2Fb+?=
 =?us-ascii?Q?q34lp0G1VbjmekpWN/HomgjkxrFhKoIraee8VKmTOiy0Bai9pOi+9rrvH4Q4?=
 =?us-ascii?Q?5eCltX/iv3sfqRcDsw706PiwuDhLOGJfS9/Io3nV7lXmGYNQDKFQS69i+Fdr?=
 =?us-ascii?Q?+v4eQJZ6nizdnvBrFnyXp4MEnZcvEFmkqWBuivwSKMMXXQW6Uhu6RYrSE++u?=
 =?us-ascii?Q?bIFgj0rZTaswkG63OsmtWpniCCN0N1AuRwcfe+ezzvaOz0SlUH/sUqhcFN2N?=
 =?us-ascii?Q?1moOWYfB8Ksi2TovXFQV8pouIIvkqxgjOqO4RGcdA4ZpL86JXdstafSIj1oL?=
 =?us-ascii?Q?VUOBAn2B90Cw3UAJ5dXcgaaApO+0S29doXyjP+lBJVuXAtf/zvpeKTbp1ZEM?=
 =?us-ascii?Q?It2DTetYJ9v3Mq1Wd5jet9RZklmuKc6yaBwOunBPrR0sn6pS6sLPzRQWYEO0?=
 =?us-ascii?Q?jX5eF7s7FGiak1GBNKgnU16A5tfD0GhT05sVqypHWj+HGhWbD91UlQqihCNn?=
 =?us-ascii?Q?ligwtjrPIM4aBeRB0SOdC2z4l97q3kfb1Vtx8ADcMZMs9g3NkRNbK6HWkKYX?=
 =?us-ascii?Q?RkpjkIELpDSSzSpNneodxD17/R6HEfnEkyY9vDrCrq4DXM/CEqUYa24dk0hc?=
 =?us-ascii?Q?p1j1eY8ROLqGsAEVm4oVMvfsvCCP1uCqsd6DOzGDW2sdOt8fJKmsNZehsxu+?=
 =?us-ascii?Q?I6TuYZx+laa7vILLdMcSKajmGzWT7EzJKN9CwMqlSu3njV+lZznUV2bkJIZZ?=
 =?us-ascii?Q?dMRz0aP5ne6pWGkVdC3TLJ8NUHTcCD348q2a84QEzVH0KJQqcQbYw1/omoAz?=
 =?us-ascii?Q?QKDGzADh1PLVUJ9jEEs+qcIY1NyQgmy9pt9kUNGiw+X6vR6rP+77m1jpF6DT?=
 =?us-ascii?Q?aPC9ZCY1mKM+O3OKi8F+7WMH0QrzC3M8ZbmpB2Kl5cDXvImCFJ8y+GuHpmy3?=
 =?us-ascii?Q?uRaPgQ9GnJoHoOx7sq48+BPXWAu4Rx70DzJE+FRm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 202ee41a-1e8b-430b-153c-08da555a0496
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 20:50:33.9958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9kHh6+fTOG+rWJ/d7rDH7B3dUTAnPleJ9eQn0nsnJDrN4NPgVJ6O4NdzsVFLkKtP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1282
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 23, 2022 at 01:23:05PM +0100, Robin Murphy wrote:

> So yes, technically we could implement an iommu_group_capable() and an
> iommu_group_domain_alloc(), which would still just internally resolve the
> IOMMU ops and instance data from a member device to perform the driver-level
> call, but once again it would be for the benefit of precisely one
> user. 

Benefit one user and come with a fairly complex locking situation to
boot.

Alex, I'd rather think about moving the type 1 code so that the iommu
attach happens during device FD creation (then we have a concrete
non-fake device), not during group FD opening.

That is the model we need for iommufd anyhow.

Jason
