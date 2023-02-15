Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8690C69818E
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjBOREU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjBORET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:04:19 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0943755B9;
        Wed, 15 Feb 2023 09:04:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zgvng1vxj33TKM60TaHv7RnlMa45A89IWRFby5WtaZMAqXtdUlOEC6T+9qQoNTzinQPIkBHEFdrR6qXwloorr4tufcIoDUc+JYe+X0TgwiTxeLeatqg76cJahfjHnAOB/tv6z2QMxmRhkUTLZ73X4FnCYtyiBPlF3Me1lJa0O5Wo8tivEUbgZoALslOR/Ps5ENWZw3LmVDkQlTwooHL3C2AhwrxpH9u4CBQ5MvvWgTO+zWsIKLcFY6OuyRmjZQb0UZM/W3c+9ezkwSh9o3tJQl7AVRgmWFL8dSd5KlfyOf68F87s89TjnP9P8GHnG6pB+1ACsDBZL4IgnODynG1krQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5b9lQc9EouqL4IqUUfWN5MzWeOUr3e0j22SqXiH55cY=;
 b=YogoX099U4CMndvyQ93jL6sP/vRNSDIcyMNK6ktKdbdZUvf52Td7wHvyTCQt13QY+Bd9b0iexu4QXa7oMiS4nYh5yoQ3ubGo3lQMazLQRaiphjGxskI+uGPGqGmvLjxRzDJG0luWDid7ghojowuUeFSIEeOIDMbWGiqyvjiBIxPZB6IQmXox6a+zQLR3Wa2sa58KdM/FpF0eIWZ/S3eaMiSm7xCr8zfTqw3ScDMSmhamEGl24gFDnuMjJYsSiSzNCf54fVPEEfgJywtJJjzvNfodhLqvAC3JYuqy8wQ2tXgEf/X8G9C2LKAzhFsWemVznI/gEQSOEWylbQET0bE2dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5b9lQc9EouqL4IqUUfWN5MzWeOUr3e0j22SqXiH55cY=;
 b=CytssQD/1VDWN+HgL17GS8k5FR5jp9urJoXiRbDdbOOxj1XLffR7JgS4gSngp9lNDBeq6ImOA/rdWzoDdaJJIH+Ih6DRnkOeJJLm19HQpnqdCeCQJ06Fwkq//fhQYCXCcGm1P+OqJ/RpPBn9slACO+XOo7YkqSZB80vkCuoDs/luwQWa9vTNZP5kxZiz6ZHGBOxvjQmYZCktybXevSj9EzYQbTL0RKYUucuwsA8WAwNU+aW3+OxXGhwMtBdCRL9W1YdkxJYXy0ym+aVHajfPDqSKnDdoCEThszkBbMv2h/jjD6YvufdenkXzil+EtskkQBVb/y2HE3Hqyf2DfTDwXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB6981.namprd12.prod.outlook.com (2603:10b6:806:263::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 17:04:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6086.024; Wed, 15 Feb 2023
 17:04:15 +0000
Date:   Wed, 15 Feb 2023 13:04:13 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Message-ID: <Y+0QjaIWr84eVzsp@nvidia.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-4-yi.l.liu@intel.com>
 <Y+rLKvCMivND0izd@nvidia.com>
 <DS0PR11MB7529B43C7D357D8A0C2438C7C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y+zSRklKkL3rc2FB@nvidia.com>
 <DS0PR11MB75299F5D92AAC33FD8690694C3A39@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y+zwSn63eA7HrefO@nvidia.com>
 <20230215083234.194d07a9.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215083234.194d07a9.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0201.namprd13.prod.outlook.com
 (2603:10b6:208:2be::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB6981:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c9ce9ad-ba00-4297-7a85-08db0f76aaff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W+BCwFHAcD2Z5Y9zn3EuNH0EgbkHVoS2dX2Nm392nMVh+LxwDaPDiYAQVp9l868Wgi8vWC5bXoy237oLJ81Zl3p1+fcX1boSKyT6SNfMMd945SLg+AalPZJ6NFXGToDMD1cGXMMI3dJr/Knok8Csm+etkZ+D+wSw+XW4A+Pi0KOGQ+D5B4oGWg93/AObd+uPOnYHBQKaXL/KW0/BwYxzkVWnaIw5FweqahfpMo4MAHKx0nLJrB6vFugWWTEGnX1uq1RSJX+MhrIR/v6HaUHF2wS2aqevoYDytoV7CEcjUYHbTbiaUQP5FaInm1jXpGCDTat2GizHB7ifGS3WF2syjj6msJ7cvDshcdf7z6sFmwmqONyCW/rq03HeI9oR6Q4u3Il+kDt0HZzyILRiSnM+vjerbpp4hnQ2dKpEI3hYtaXuwWwTj/vaA+FzwwEWvQU8wOx+VqW/g5gTeAWzs3wOCIzb+xv2/ylHvlzezoNHPqCxqSJizkuxnveqpr9gUEXybGmtLDR4m7yXI0UNIxJFeCde03+HgCqAmrP0n2P+SXg3gzYR+MXoJxaxSUFLvXICQp1h/0pWgToxuBsH4hhLz0CwVtkYqJzrthnyxEzqImNUVWRGHuCo/QNaLZChxWlUyPM/M0Ypg2/BV0Db1xOuno0vxFijAbSAmv/yjI1oUSix8dYF5WniFnXMmHsvs9ag
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199018)(54906003)(316002)(8936002)(7416002)(4744005)(5660300002)(41300700001)(38100700002)(2906002)(36756003)(83380400001)(66946007)(66556008)(8676002)(6916009)(4326008)(66476007)(6506007)(2616005)(6486002)(478600001)(86362001)(186003)(26005)(6512007)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XYG9I4OPG21tBeuSZ0wk0UGQyIr7ucIEtUJXe8Vkj0ujuVYuGew3Rl4uCVtp?=
 =?us-ascii?Q?4BmPR0w3b0tpfsWOptXIG5G3uc/15nn3P69+ysrRw5bY7g05okh5Slg8Q1w7?=
 =?us-ascii?Q?hsqXr2yUCtTwR2JPPFYwSXOTnuHhBfF22nEBBskjQg5ZcLxIiuhqk52DK4cS?=
 =?us-ascii?Q?QzZFzjEyzfFtGMuFdTDaWNlgoOdVgXYWdMLheBT82iBRxYn7kE5HhW17+j7+?=
 =?us-ascii?Q?U/kQk/vvD3g+c88xlPlZyW+dW0Yv7rKUceEHLEcBpyL2R12FefdgBwwSxvU2?=
 =?us-ascii?Q?CQdOTMyWYTvOVVRjFVzXTIQhhnP31ixko8VeRRQzFDkWmnyqtzJReREB/2iH?=
 =?us-ascii?Q?B0VV1Mzdpi7IYSQcZzExc3hGO1wfBek5L1eq24jP2y0a0wSiPxT6t0qzDdnV?=
 =?us-ascii?Q?iFFEB2s65fWWOUfgqBh/LkZD7oLc1zjGyrUbmP7qeYQvweMvsUTsRUP8iz1F?=
 =?us-ascii?Q?uMHJkw0uNDVYL0Vntz2xZfSlbGuzkIcROEgPwzydiY82xzG60B56rGe/KGIM?=
 =?us-ascii?Q?zU9Fta534JyMP3n3rRvfaAq5EgHZNVujj4QccSMze/3fS8Y1nQDLqAF/pQUN?=
 =?us-ascii?Q?bDoK4FiuFIWyKLiBnEfQbZOXnmFFDdNzMOX17mrY76fWj0qtlnDUrrqj+EEW?=
 =?us-ascii?Q?DStYReX2QIps+2t75++pr1pa1wdKY1cryQpBzBuzpZ1yIgGrpY8QR7mM8Nh/?=
 =?us-ascii?Q?z3epTU9Vwvu2VWWbMcw5pcWzqJcdQUEZz9hWhH3QMxC1QBI46rC2YXkWOqs8?=
 =?us-ascii?Q?6KzRtZyzqavnpqJOqCj7rtLHcdgaJ2lI9fanw6/H65MOw2SOIwLu9BVs8UeL?=
 =?us-ascii?Q?GZ35cgRj3SqKVVTw8SxtBfX5xA4IdnQkYBcW4Uy1L6tTi5bGx348R6OG4YLE?=
 =?us-ascii?Q?bgmomxmW+a+P05gqSN4u0+dRAoz24TUeAb+EMVnfpmiJ7gryllX1rAMSyWvi?=
 =?us-ascii?Q?sJYX9lD3yqjUu2f3Dr30YnkDYYnVKdpJBww62BiacsyHe9Ga26VC3EiZSJlY?=
 =?us-ascii?Q?hUbPZNxKNXC7/6LpfwFXMGNkhrmd9Z+5v+fgQCYpXc9ztEZOuwvqBXc3u2bd?=
 =?us-ascii?Q?Ub1RveqiZ/wW/ekJ6VbRHSYO6KAUxxLa0PZ3KZYNIR4VPSj0G0P8WJXIEgMs?=
 =?us-ascii?Q?EgTkopps31g2FhHHK64Z4XWtD0qSyrwH6chRTYGA35l8ZEVgglYDhi1D6T6K?=
 =?us-ascii?Q?lPqiSEIApuwm0Qj2YR+ujKUGq0z1a7ie948pUbZqscHCaGiqkXJeJN5k3RNo?=
 =?us-ascii?Q?cWTqxhoOEaX/el7ueLMWZRLf/gfPvn0/JmFGi12FYTmTXZ+xN05zZAQhHTo5?=
 =?us-ascii?Q?8HbTwlWEA5odJqFFM/ZUVTVscXJCgCXwIS39bLRfjGiQPjlxZBlD0p0vOs+O?=
 =?us-ascii?Q?ALpb3qujgym8vyI1wo8PScCt2hrnDs2yTQAvHklhdSmbQWAOs54u9K1f4aLX?=
 =?us-ascii?Q?DK7Aic0ytshin6xt4MEN5PjcmVsaeK6T7d7d+EPaSBdWmUssxK1EEbgAS8nn?=
 =?us-ascii?Q?aII7ZnFGGAywtaY306KxDAcUya6oks+GYKodstv7BEW4e+pd6TeWBCWYgat2?=
 =?us-ascii?Q?87yNIPoSqKm0+BOrgjizB2WUwzS+CrWavvSAnVBZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c9ce9ad-ba00-4297-7a85-08db0f76aaff
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 17:04:15.4671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VY5Zwzhk+ftUkElkKZvCOo3lA7yGI0T14LFknrO2giNtiGfQ+d4UU209fj9t13QI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6981
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 08:32:34AM -0700, Alex Williamson wrote:

> We've discussed this with Paolo before and I believe the bar of proof
> is not very high.  I suspect it's not a problem that the device itself
> is not yet accessible, so long as the user can prove they have the
> ability to access the device, such as access to a restricted file.  In
> most cases this isn't going to turn on wbinvd anyway since DMA will be
> coherent.  Thanks,

Isn't that a second problem, we don't know if the device is coherent
until it is bound?

Jason
