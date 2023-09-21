Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1367A9B80
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjIUTCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjIUTBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:01:47 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A39CAF69D
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 11:40:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDHCfRYTtMNs0AhNsRtyHiQpbZ/liEiJnECxCHSLdXMNGu950LTJSf3Ozvce6c8hJkGbWXD1cElGXwLsVWWxfae2c9IQLikU3blystoHmpMjSQZP7Q0mNZLuol22gGw/8+/gDU4oUfCAtSVORxM9RDutBQKOHAIZ3Apb9KusWT6hb0rQQLMPsCQ4MAkdhYQkKbd4EjnSPHdP1m+jhXmG3NPNFFL990R/pXlz2gC4b1ghQi3Xewjqkny6gXoz/7F+lrsNLj03BB2R5WBpnu2y/yK8N+FEuufIBMiXfKtoG8KGIuWLdf3LQh+rjcNeQZtkg5+Nr5kWsy8asmJ75IODMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjtgQ7m0aFm3YHg2LyDq2m7mGLc+Y8P7SnyDi3UhAPo=;
 b=G+uW5JTYRWmsduWkuYPRaI1sqTEq5CvjDSGeP8iMVK98KaSWqxE65u/zNq1z02GBDCorhPeCNobELBjWcp9M5olHWxZIRkrSZ+W8yGf9knrshfeUkAoFymDeVl0MVU4LIpXYGXn3qQTuj130nkfzG9rueEKpR3B1E3T/dgUbGmHbDxOtxG5MK2ZQb489hR+a7kn7qFwGoF4cqjJBdWsr00Yxsi6vGU3tzj+nht1uMj1CaietxXNq88/P0GdmHV+MsnF2aEdJLP4WRmrk805SGqb1GQaG5qx/KIDrdGULMs/MfvTLosmBVTFPk7mrzm6ArYm/8VnmWktHMBfS8xYjqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjtgQ7m0aFm3YHg2LyDq2m7mGLc+Y8P7SnyDi3UhAPo=;
 b=gsfDDNtI7gVYacpKGtdIKe8MWCiWnKX0/IJpwYhxRc/YSiA45teqRooTEP4wLTP+xBzvFqt257ueG7GqIMJAJCWcz5Cm09bIwejArviD2tUDG+qclH3ZlWSEkcKCw8moEh/u/hFv7oIAQM1FlKfFEZMKax0kVCK7GIaEHPXnZnKY4a3/oGNYicH4mGPhvhmfdYkF+y0p03ziAt96rxtqhH7jsG68MYvIBlMBDwggk1HsgLGDdf/D4WRogUjZ1ddkMsnYHc41wDCfdonUlibdIDrztM/+wlc0IZ8Z+Eb8y9za6Y21IDbGQjyj70TQbPlptn8HRQvgUfZmeqPCOoRRmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB6874.namprd12.prod.outlook.com (2603:10b6:303:20b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 21 Sep
 2023 18:39:28 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 18:39:27 +0000
Date:   Thu, 21 Sep 2023 15:39:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921183926.GV13733@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921124331-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: CH2PR05CA0018.namprd05.prod.outlook.com (2603:10b6:610::31)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB6874:EE_
X-MS-Office365-Filtering-Correlation-Id: 89c8a4b5-0e36-488f-1c76-08dbbad215fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EbGGfGC6cU2aRSsRvm0XgNzbDqgKB6K/Cs2yqZrWSGJKw0Rbs97x0k1U4gQd38fZxWGW2vUh6h2NZR9XfT+2vBi5CBiU4gMAilJbn/tuqn1P6MCj9YrO973QRlf85mzjnd+YvpRCNx74sJ+wFCthPDWgn0qbb1UqWGr65qG5SEKQrV/926YmV11+mdyK8GhiKSF5I4ZX26B/bbI2R0rqkfkK6dxb7wzYl3YYq4rLsc2Lj7NYI1HCWlm/Q+Jcit4/4eKJzkoijpwARPdtNCINUaApgavbqgnBBe7m3Z/lF1WEoZNvraj8hHMOfDrTHu6m4xgJRNyQSfjIrny53KeXo2H+TPvIEJ1fL/VAatnFSLXIa+nwwPk0F62PGyw5XlT/aAv2w5zXEsRgMm22wkHOh4PWOI6xlv7JhN/1DVdq7Md20y7wdLnWjmSKhI3VnMW7bG4FdOmbTnKbtAefXyAJfF4sCPcXVot4VhhvPsdMUjdeisT4aW6XY0qbsuxPhRhSfFrhCPneuMUcJs1lMpI8+FFBgPgZ31JIGPGMtD8lv9XS6ZzG1Iw8HOcmlNYOELD2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(396003)(39860400002)(136003)(186009)(451199024)(1800799009)(66946007)(38100700002)(66476007)(66556008)(316002)(6916009)(2906002)(478600001)(8936002)(4326008)(8676002)(6486002)(41300700001)(86362001)(5660300002)(6512007)(2616005)(26005)(6506007)(1076003)(107886003)(36756003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n0XzIz0GACNeE3HHBwvuD2lfdqkqIGZSyFyR8mhMIi5kNa0QM1ZHpMzrm1D0?=
 =?us-ascii?Q?uGvFwIKGqmXocsLKplMdWUVlmR77qm0eEJdTtWwsgLGzBTPgEl6U97CbP2lW?=
 =?us-ascii?Q?Y9vGI8jUmdaG9VmEujV6wZ6cbtALzBp2zb6Jj+H4vLEqnW5t7VHMxBXrO0A1?=
 =?us-ascii?Q?D6xQpPkCWvyFc3HuL9CNn93DuRuc4vTaljEPToCeAyiTeaQu1cTJHEiWlZLj?=
 =?us-ascii?Q?YW7TOuXtB8He1GgMLNkj/ppTkFFOA9mm3M+5hhogN5irRxle+BqMM4DDj/lz?=
 =?us-ascii?Q?/egFx6EQT8fiHKSSht9D9NLRJeLAq485ggI80cfFXl4Zzdw1vkQ1ZiJHGbMV?=
 =?us-ascii?Q?RwHT48+Q/U4Nf4p3gfUWfmY+1XxvgZDNJawUb694u6pR8aUWPBnnbPJ2jxAE?=
 =?us-ascii?Q?l7FSpk1Mqe3tEIDhxdxI9ZmK014YsYR/WoMvq2/4cehRP4Ofjl5HM5rN0qjL?=
 =?us-ascii?Q?GjPitp7aU0ibSY0b2oIs2JPQryiYKdVhRnSthCgjX5QFA2B8nXfGpzq+V8JB?=
 =?us-ascii?Q?nN4Nds7vv0g6k3zZBNJhGDp0wqb4zrqNKkI4KDidui0+AluqZX7/rMFsg7OG?=
 =?us-ascii?Q?ljPEM5Z7jVfIoNFbLgCUI/gi1ePhcqLvq+vY/kNMyDxilaraVEpJiy9r0Bmf?=
 =?us-ascii?Q?gvJdEIyiiX5oe/mUowYgM/BgMezsBEVDy8aJka+5QoMpeLIHHsM9PzSQS4U1?=
 =?us-ascii?Q?/Nsf1LSAwGtvXti0ctN4ktg9d1X3eDPFx81cOEbiikF1DlTr/uPVYhdTETHr?=
 =?us-ascii?Q?Qzclck3bQ5nXNo+x0UoBdE1Y/PJ1SDT5EXa4+mZrfjx6khR8NbexQR5HDwyn?=
 =?us-ascii?Q?6u/9KqMllYqFcS4TR7yKKeaZCHdPpVXAHT/VdGl+R5PNLowxOpzlESwxKCA4?=
 =?us-ascii?Q?EMWIAoGaUflyi9BcxJZAcdMjxqrWyf3+v8fsmv4vavINWam2rimY0b4SCn2E?=
 =?us-ascii?Q?ZZVeEgpLSevrYmPKCObiovw0ctB4T9yB0O+d9O3TkorW4NnhHMYHr9Huu5tz?=
 =?us-ascii?Q?LFzA4w/VVZtQe1FAg6FiQLxgDHdTM1Kll4XLm7FsMEqBmfLMmAgsEnmc20jb?=
 =?us-ascii?Q?NgDoyX4k+HtJ/Ln9IsOTIe440ZzC8tEUn8GwNId9Gjd7IDjMKwtFW/A+7vrL?=
 =?us-ascii?Q?k0B90B+PiuwOIYNOxM02hheojZy1Vw96sPrNDH+l9bKTVW2N7oTdqkoGFv/S?=
 =?us-ascii?Q?p1gXf2rpDYx21znqW6AlMZ///7gDZH0YF2XmTwyhivwr+gBexfFDP2nuyR+q?=
 =?us-ascii?Q?EdYUcFw5MoUDgfSGppDg6jQFZLJS68ktCuXV/ZLaL32wdcFpfxvlz8VYq2yL?=
 =?us-ascii?Q?wWP105RnLa4aW6gqLhPI3oOZ/9oh4sKJcWPlHJtQoAILU/37X8oAhMfAGU2U?=
 =?us-ascii?Q?0bxwrCxi2Up1QToMv0SDQdmAqmgCyivRU1dv7xQ44cIdlCPnHMkzTslPLj08?=
 =?us-ascii?Q?qIdueb8DoF6VeUIn4BY321B/vKNYtNciccgGqkCHD8BJxJ1SiD6xr+0II/R/?=
 =?us-ascii?Q?SLIFazMYZfgVN4MDJgeEmpzFeCKHhX6RErCjuoglQafx2Z/2s2HWxTte5Ijk?=
 =?us-ascii?Q?AcmoPEj0SBGgWQ+tuL/m76tBiWkC+ZEZXR/+dzqo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89c8a4b5-0e36-488f-1c76-08dbbad215fa
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 18:39:27.9088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zGXGfHTdMr/78yrth9q4ZrNQDZ439seoWbYQ/pHGJwGkXps8kCLl0Xr7xSTzkXjU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6874
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 12:53:04PM -0400, Michael S. Tsirkin wrote:
> > vdpa is not vfio, I don't know how you can suggest vdpa is a
> > replacement for a vfio driver. They are completely different
> > things.
> > Each side has its own strengths, and vfio especially is accelerating
> > in its capability in way that vpda is not. eg if an iommufd conversion
> > had been done by now for vdpa I might be more sympathetic.
> 
> Yea, I agree iommufd is a big problem with vdpa right now. Cindy was
> sick and I didn't know and kept assuming she's working on this. I don't
> think it's a huge amount of work though.  I'll take a look.
> Is there anything else though? Do tell.

Confidential compute will never work with VDPA's approach.

> There are a bunch of things that I think are important for virtio
> that are completely out of scope for vfio, such as migrating
> cross-vendor. 

VFIO supports migration, if you want to have cross-vendor migration
then make a standard that describes the VFIO migration data format for
virtio devices.

> What is the huge amount of work am I asking to do?

You are asking us to invest in the complexity of VDPA through out
(keep it working, keep it secure, invest time in deploying and
debugging in the field)

When it doesn't provide *ANY* value to the solution.

The starting point is a completely working vfio PCI function and the
end goal is to put that function into a VM. That is VFIO, not VDPA.

VPDA is fine for what it does, but it is not a reasonable replacement
for VFIO.

Jason
