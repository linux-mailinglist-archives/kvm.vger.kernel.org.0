Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45956B4EE2
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 18:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjCJRiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 12:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjCJRiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 12:38:19 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1B112B7F0;
        Fri, 10 Mar 2023 09:37:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xf/FGPu01Nq0D3u76apcdB5MKkA8oJ60EeR24UIwoEJvlTe0ERrvBU6lsIK++CsmMkYrSTgAp8RSOPcFtBoaUD+LFocBHsgUwNU0Ca5ZkQPqZ8u355HM5oHS9SsNk6EmDjWHxUQaout/0oIW9d2T23LXF7f00Nadfz9N6gVZ/GtPz2s8T4Glc/V8g+imV5imf7cG5gp7+Mri3nM6NAqu0OEp7Yc9hwBuz4wGiLcVZyqzoqi64AmEqmkfZH3Xnavq/Gd8yRVKd6Nb+nvbzmQ2tcBM/AMK4AB8eRb7MJaXwGgx5lC2RZt8yUGhQqCUh7h40vCi+KELbk7ySxphtuFUMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2JJ8Kj7i6EADbnMEucxpSE9RuDmi9TFVHb5eUnVxDdk=;
 b=JQNLsLs1jRop43l3FQ71dViVFYPbaQNpm5jjkH9hAvira20IP0NhfRha6RNGRbc/os5b0QVzE5SRDyXblmruW0j72hq0OrEihmNWlNObKgIaF0GWaU7uJ8c3qs0ncYIJ4i8LbdmNhU0cShOS1Hpp2CXZiOTb/07wHpwPPLTbhEpgKpTQMoVAd02cbiDWS2T0uUMniEFYWKE4G5empYLc5AnLYdndTd75smtnQMdqevUIrpvlDC2VeI3ukpOl60SL5wZK8y3QpgGHYliSd7KmvlcwxRnFznuj3Iuv3FCjsmilsORz4ocr+58JYXr03KGy6KHjFOt42bhPjsdRMFebOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JJ8Kj7i6EADbnMEucxpSE9RuDmi9TFVHb5eUnVxDdk=;
 b=APiEU052vOcTUBjTRQgMb+En1dvy/H6fLOVhjxZ9fHt/6ePEqd/9vaSyKAZfFer0Qoo8pES6k17M64d7nVqfggcCqHYw4YFipeLPCgtHxQYhB/CYPBtDK1DBAZPyVwGyN8boY7U53Nyh6nU8G8FBrpL3Esaf+HJ+LM7Mvc+BTvWzMqjdxRxiGUpwnC4XQH3S3480axrOtGQCG8fOJ+p5TjAC0fyICsjbgbT/jeBazdjM14fRsF3xe+VD3u5EABAnOvZq6OyuGVh75lnIYGNaai3rU7/gK8Uqt+HARdMnlDnntvEoPZgipnN+uAIyU9Vi882QSTvDwnj69USYDpLFzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB6653.namprd12.prod.outlook.com (2603:10b6:8:cf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Fri, 10 Mar
 2023 17:37:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.017; Fri, 10 Mar 2023
 17:37:06 +0000
Date:   Fri, 10 Mar 2023 13:37:04 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v1 2/5] vfio-iommufd: No need to record iommufd_ctx in
 vfio_device
Message-ID: <ZAtqwO5p8JwYuKym@nvidia.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308131340.459224-3-yi.l.liu@intel.com>
X-ClientProxiedBy: SJ0PR03CA0139.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB6653:EE_
X-MS-Office365-Filtering-Correlation-Id: 6199534e-ee60-4a94-9516-08db218e117b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vH93hwTpykDiaFSwJflnB2hvNMHzo306NLZGv8/ZfQ2JXdGMfeiq4b2MO200Z1cyLJ8+nWrwIR8woK+ODJg819E5CrdDbVL/2QFAw0xaGh+RUjpZIoe4jiWT8SIu6IKCtIeqbsuswn6zhfkAnkbbI/gU2qtvt+Ai9NaRfhLYxJrbz8krLtkbPI2zsEsMEDZKa0q0jjANZJNVd5/0kktZXuT5buz87RhmylVr0SN65hTu+slz9jW8DjneIGSFV+lq0dRmApd24Bc+9yY5Y36GGwVqsZX12VSwpeLq7RaGwHN0BzcLdXK1+wnKs023dQ6Z1a30TGzoygBtq28+W6L3Dt2ky36a+aypYtlC9w5y0Iwzs77mkw2mVErkHv6cQZSK9GPbOx8rhTYiXTdEmlbB4GFmFqUeCd8uBI2VzqXQbJGks5eWX4OPbMDU5q4VWIaCJz5vNFxCEUz5lZ+kVRpzFstb2WecCjANRwk1YoKewPglEOEPsc9G3COsYAlpHfA9ck/cOBfNeL9liGEV5qYFH6QXUDyYSxolJ4CHZ+hOKuHx8zncyLhUg62pUDHJb4hh+/WtLU7jwiMfgQOiXS9tJUS348IqVKefIWeLsBeyKSt9MLTsQFsaEkPLlvnAxOWjUpkXfKPLu1ovUvwvBDdKLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199018)(7416002)(4744005)(36756003)(5660300002)(83380400001)(66556008)(186003)(478600001)(6512007)(6506007)(26005)(6486002)(2616005)(8676002)(4326008)(6916009)(66946007)(8936002)(41300700001)(66476007)(316002)(86362001)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?naRA3AyFmIjBTe86qTcACBvQwLPRoB9FlAdZJKb0c2gF/BpCE0p0o8aB3/oz?=
 =?us-ascii?Q?c4mYkTgDbEjnlch8o7ZAereD0SWuGNveh3pxNBP44CFnbjDg84Rr2vz3BAwS?=
 =?us-ascii?Q?rwdoMRKhiR4bNNvSsCYGVw4BKP33OsRJpNjF63Z4N5a34g8opFro9TS4FbK5?=
 =?us-ascii?Q?iG0TcK6Mkvt6xJ3CmZEsGoBFQx2pfXJ3FUl/6MHQN5kvX5rZBoi3jb2Efhld?=
 =?us-ascii?Q?ddQYjwwExwTo7LkDKPHAKBYJqp+jT+ye/F6OtKBnpVOaMPYw9WbwdyrY9Esf?=
 =?us-ascii?Q?aGab8q0T/WS2NiMDSy+VeynL7STvj2Se80mcAc7lV0SA/Pml4DChTv19/wam?=
 =?us-ascii?Q?kImVAELY1qn0sTvyhWC4cN8D3rdiG88/l+VrGqbuhGnPBMgZQMhXI9S69mzr?=
 =?us-ascii?Q?pwhTPmR7UJqcmQHL/dlcljrvcQGjgqHdyneSTOe6CNYaufFIEnbclhfaNd1p?=
 =?us-ascii?Q?VUrqknJ0YUxItGrajuvrHr82wm3JwpRH8/vfk5qYEQhe7uisHjSRV+A4h9fY?=
 =?us-ascii?Q?GIc2BXkY+vzVhCgShk3d9Mkv2FVaqzpaq7lXRWoxb31E65qdgHhkk0Ixl8c3?=
 =?us-ascii?Q?41TlxK4e2R9ssioQbk6qCI1MGHbkl1ZPpZ70UKlxDEvH66mtW/ppAJhLwWXF?=
 =?us-ascii?Q?ueCHYWKL2EZo4tkEEpstRD/0MJ1Z532Yo9qXxnyfFDo5/RWvZ6x2HH0hE+Au?=
 =?us-ascii?Q?ksr1wz44OH/FSqUDDHK6daHeqfjQ/WnyyYPiE2q2pkg3HCyPR8lywu1QRZ9n?=
 =?us-ascii?Q?qu9NDy7xjFJgLNdoSTLVQ6W5rIZeOBHNjMMGVqYActWpeCmVa7mltt7/ZzX7?=
 =?us-ascii?Q?I3Gaf5rUpAiDIhdJ4ncwTHkxTvGp971YATo0aXD6qDXPcwzXWsopdgmGW1pu?=
 =?us-ascii?Q?mbPQd0BSoUEgcSnEdp3AB+UBEwl1gj+9Oi23V4xylChBn8FR8/ZWoFdvAPbt?=
 =?us-ascii?Q?vMRKXrQVOjYV9jT8faEnE9IDaoOVFF9KRjQRRtt++F6G/t/+oo3XA5afojY8?=
 =?us-ascii?Q?GG/kjuLg5UVJvh0rpDJwGLBWjaKIpxOHm8cO76QK+JEle7X0hp2gE7kTwpgf?=
 =?us-ascii?Q?OFnj4Dm7DO5JlUfZ+XOl/X7XRwkRCqBVIqdQsdmB5Bjx5mOtEPbiMp3J5BZJ?=
 =?us-ascii?Q?jkEjW6EaNuf4TAcNJ2+gHJOBPnlVASnBmBGYjHrPGY6GeXuBsgaUlxJfkfyV?=
 =?us-ascii?Q?hQlfw9HKpjN0gU5tQVK7Eekqq6CbvytsS7oommmdPpZ/+ZrvO5w1iHzUP3Sq?=
 =?us-ascii?Q?7wPKqA8sV5OwjURQRltU5RDA1k+xW0qPxVN7nntdCzW5HQj5qYDDXCYDSf9e?=
 =?us-ascii?Q?wFs89KnO9i/IE40JsUcrsIZy0NlBP2J4zlnsFJRaie+wo8bQX19nwoN+zYzB?=
 =?us-ascii?Q?7HmefkpNYpXWFtXoYk7ArgD+/GwJFPxFw7cnMs0bxcWbgGyVT59KpE/+zsbc?=
 =?us-ascii?Q?E99FZzc5BdF/KWoIP0bxU1QwM1Wd60+DiC4YIX8jZX9yvD/VOOQgvykT2dq8?=
 =?us-ascii?Q?vCE5QOcxDjcpmSraQZNrt40DfjRejivBphPF5NRF7E/oG1kANhvFDjoTb1Yy?=
 =?us-ascii?Q?J+K1F1DsHwKFuLkQVvNu7ZclY/QF3b1frzzZVwIb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6199534e-ee60-4a94-9516-08db218e117b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 17:37:06.7784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8dg3h0qYVphJ1VDO/ef/vnhjgYFejyuDWzoZvi8nPfHEVLIx3wnzGx04/gSabtfE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6653
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 08, 2023 at 05:13:37AM -0800, Yi Liu wrote:
> iommufd_ctx is stored in vfio_device for emulated devices per bind_iommufd.
> However, as iommufd_access is created in bind, no more need to stored it
> since iommufd_access implicitly stores it.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/iommufd.c | 10 +---------
>  include/linux/vfio.h   |  1 -
>  2 files changed, 1 insertion(+), 10 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
