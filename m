Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC636EE448
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 16:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbjDYOwH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 10:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbjDYOwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 10:52:03 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6558E7DB0;
        Tue, 25 Apr 2023 07:51:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eTy60Hlv8umpiHMA9zZUAMrNaM9vyrvw0pGddD0OrOcCFmEbHjZvoPCodcLbbXaIxJ7DsFJx4haYDiilwwVuTkGEd+hkmdgH999Hp3/XrCh3fq0te8bnrnzAkee6zSiAkadZskwV4fB1LXr2iNtYUlPl/mAvAl5tY7qBrG0ysqRl7JA9M8lKYF9IWYXd/X+yTHuEcEfpJbVUvpReONj1YdKqbSmPl8Be6JTL1fD2Wjyvpf/89Hi03L603o568txQ4zkl1OBJWA02lkYNSFMXoKPIlqZJUEcmFKbBAX28UaK6RTDQZvM8DhGyPzfffE/1QhXQfbcjeyGcIBDCkSrZ6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hNS+mLFLSufWqHJ7Nih0A0wK5eAK7F+tJGXYfT6LgN4=;
 b=LK+jv8I0DTXhEHXwlE/zbgxYwVT2GS71N0783+WNAwS635I27Pdqk56YP/rvBUGyNz151eNC/yivq5eaF8srIXm+R1yhldHlxzswuw3UhZu3XVQyvjARSfpI/Omb7d9I/Psf4MCf0Di8k0rXXkFQgEeSocwbwt9jWGEYh3TRzgOKq69FEToOf5cTwjU3w0G00PhscMVvF8WIsRkp/eWchbi3dkZabdmOnz8KU8gwZM6+EuQ+kTSexqqRDXi0tYIknBz3MsgXBRvBH/QgydlYnNDShc4ohFFc9JlUq3Qc6f721b1edb2E0F1nR7t4WGrn3aXtl9xy5OGWMWiz2QP5yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hNS+mLFLSufWqHJ7Nih0A0wK5eAK7F+tJGXYfT6LgN4=;
 b=ZdCDxiC4DZ3C7rTRqfy90q5bp5gPhgO7A0UpZnZd0LnbftgfDxBYgaqB9RIBCFRijc/l32rY/DgJnb4NR5xCTcHJL9SEnLOKpWAenHwtPRii3U1/2Ts5d8sYljPxsCv3+ReBiUHuYZxipx0zvarzb2emUZS0XtFX5zbQZRytlLhTlAP0Bn6GI8TccTAjr6C2kIWb+9K0ewH7U0d6Cg3E2W/1JAdceXEPSylifanBphVtWhuYCoTHg350anhLWAgCHtOomBUbIUrpwt5wc4Gq0z2rWNPdfKTfink7xu4vh3D6Lx5i+ncBtEKb74/4azX/n/0mKT26+LJqz5+6C+Y/+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB6007.namprd12.prod.outlook.com (2603:10b6:8:7e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Tue, 25 Apr
 2023 14:51:54 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%5]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 14:51:54 +0000
Date:   Tue, 25 Apr 2023 11:51:51 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 08/10] vfio/pci: Probe and store ability to support
 dynamic MSI-X
Message-ID: <ZEfpB7m3bWr1bPlv@nvidia.com>
References: <cover.1681837892.git.reinette.chatre@intel.com>
 <0da4830176e9c4a7877aac0611869f341dda831c.1681837892.git.reinette.chatre@intel.com>
 <20230418163803.46a96fdc.alex.williamson@redhat.com>
 <64b99d1c-073f-cbc3-6c5a-100fa23bcb13@intel.com>
 <ZEa/rTKja3Xpy/j5@nvidia.com>
 <5167f01d-fcfd-d821-40fd-c53f4fc135ff@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5167f01d-fcfd-d821-40fd-c53f4fc135ff@intel.com>
X-ClientProxiedBy: SJ0PR03CA0169.namprd03.prod.outlook.com
 (2603:10b6:a03:338::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB6007:EE_
X-MS-Office365-Filtering-Correlation-Id: 949baca7-d766-4489-dbe3-08db459c9c29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mTEmiwW9LKzdg/bKaI1s1x6RG6uGXMAdw1WG/pu5ARbwz9XvaFu9t3jyt5n3dMdtPBODwMtNxo8TX5KTh892n2z5RMp4iK7bOYM6iSExis7dGwCfssxHFTgyH3qmxWJEU41sH8PE9z9DTBSxoPN29IoknzeKyze0G/qn9R67cCsQs/MUW4WR1si0X4MQT8IEzsqUJRGLjgm2O1JhNUXMiEDNKj+aiwAhV7Aer1y2h/6gXMlX6JIEwWV046zGFkNECLcI6spNabEETsYOO32Ji4fiBkwAHkG4ajVhJwyi4LXalR880mLj1eAQNdNKkvcLuQ19oBXLbbHbtFfoKeyMvxL8HOVtn0h5mQ/5kDzcAW9V7t7z8BEjgk07K5VyCUKnHUZjb1H43JhYhZcNwHpDvhKJwiNBqey1ETLiLEx8QMAzLX2WoDF5wyFzHLrLcdSgt+fqzrJmLfOM7E/b3SpG/61nfcVn/KNdeBkibqkLBYzWq2Wm0CwF5clLSbHh5x3xtp6Cy5mm147CtnGYTrneyiVG9oxKLXXDos/YDseSCL5tjbmdw4jYDNfKfcgYN0HiqDwpd2g2lFqWyp2gQ8k4JOtckaUVNR2eKk8ykGG4YNA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199021)(83380400001)(966005)(478600001)(6486002)(6666004)(2616005)(6512007)(6506007)(26005)(186003)(53546011)(2906002)(7416002)(5660300002)(36756003)(38100700002)(66946007)(6916009)(66476007)(66556008)(4326008)(41300700001)(86362001)(8936002)(316002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LTDiz3y6ktC1LgCvuP8aOVdlnJE3kOQYeqGdiqNt31+dgIKzTb0MijE0BAZB?=
 =?us-ascii?Q?bm/2otIF8JzI+cmNB6sllWnV7QW6BKJEkSQLqJcj2LR3oWOfCIcodT+xmmuo?=
 =?us-ascii?Q?nihSHFAcWMBdlRNDMBSajYa9deOhh9Z6wR6Jm33CzycaeoLbfmLd42wadiZi?=
 =?us-ascii?Q?+qEnBvhjsgFoUxuOvehhJkJhuY7MWcQDqBwqN4CF+CvOX0NECwuIkrntoXR8?=
 =?us-ascii?Q?94wOAUfw3kG0Fp7Zdo+Cx1/cy640qD5ZtzNvnh/nvga1/BXVITbrkT+0n06p?=
 =?us-ascii?Q?ru5TS5JeTELDznRIy8xq9/6Z487WqdSWpO+qxFHre37AnRju/EDnp7G85I/S?=
 =?us-ascii?Q?qf5j2ZSdfiBRi4o+BQ98D5Qm0FwXeFB5PEF0JGMlbU0FVxhrLj8wqDBl9g0s?=
 =?us-ascii?Q?LOga+OZKLsHI4Dcj66KJy1G6e03Rtg6WqHlf9APnPzBeqyHP0JTP5XIzHjfc?=
 =?us-ascii?Q?R5ROl2S9nMVx1YNQ8w0I2Q7t5H1OUlpzbsDbvZXFDSJFuwpwcP0fO7Ei26cj?=
 =?us-ascii?Q?qFKp/jFZQKckxhuFgGDjTDivUgIvsp5TQhZfjBrsT7QziCNu5CfsounL/FcZ?=
 =?us-ascii?Q?Y85su5gOAvAKn3dhEn/DIXdVdUusbrN6Pjv7Hbl5VKQ/R+jded8B81HhOrvP?=
 =?us-ascii?Q?E2Ioq/VoBvgVpYDud0wwbnVMU5zJpDK4/B/FtLU9UBJFpj6phpGuR7F4RJ4d?=
 =?us-ascii?Q?gqbTZESxbgU6wpSmoCQ+yfmyjjQklH0wRlkQje26tJ9djOMQZ3VanbLV7tXQ?=
 =?us-ascii?Q?7px8L3QNt0hsEoUsXIxlTwNNWmHJkXM9otTqLfQGMR90CezcYzQdZtgoDPVU?=
 =?us-ascii?Q?T/5PDgFmtFi1lHYV8WLWg5YJ1snWI+wdOEFhoBkIYLwqE1kDGWCHa7GyLeHH?=
 =?us-ascii?Q?jtna5yi7H7d3/6ptamAo8So6kvZ+ssN+RnZWJPYxK9+9ilwiixXNsnGbNWvg?=
 =?us-ascii?Q?oo9mdadCBi2m1UlOeTBdnSoYukgzeDVlF86cqxqBJwsUbJZ36YqfXhDs2i0s?=
 =?us-ascii?Q?Uco4q6Fyb9jU6RBeiPhdC0xkP7P6OE3QIJFd1lYZBz59r3XwloZ+sMj3omAc?=
 =?us-ascii?Q?jOk8B/clOxnHIDOgQu7x3bHqkPejKre9ITy4lZzV2CaqkfW6j1vM53LKOZX1?=
 =?us-ascii?Q?+RFzoJryLAQg7yDrhDRWxLMsVCES0eEpyQ06Bvk/FCwtySyDmpJTPt6RuA6s?=
 =?us-ascii?Q?1/9YPblAky/3qLIimOSGhHfuABjwSZOqZNMaBZyCl7zTADsud499gUywP8Ob?=
 =?us-ascii?Q?ErQxMXfVEVybXiwuTouPr9PKifjspGSQALv3l/qMT3aLENJiCwCVlgnYMFiB?=
 =?us-ascii?Q?jz5R2fDWiyc0Mk9m+yrwMMpeJW0Aq5msIqEt2zlbaVJqPA3+/uzu/7SeVA3B?=
 =?us-ascii?Q?xT3NUUmscCn7QV8NvOmgZHPMMRJp4vuLX2lkmv+cHVBobCQIi/JPqmuG8TC6?=
 =?us-ascii?Q?A6yozLGW6dQixe7wNuKOcH24+4inkBgz6eVwZU4v6ErVq34QAne9hXm/oeoX?=
 =?us-ascii?Q?PIPY/JQaBH0+bf0K9nRDrXd+S8zEvw434UYWTExBwcuZnrS7rGy7Sp8OB1We?=
 =?us-ascii?Q?IKfU+Sz0xbqeT5OjxLnsuuIh4Q2odWhhh/O43aLn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 949baca7-d766-4489-dbe3-08db459c9c29
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 14:51:54.2004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rg8XzlSRhxjNYA2VLji8ujsGmXJqq4SKEXg5A3ctQWeFZJTsSFhZ6nElPiOyMN0+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6007
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023 at 04:52:08PM -0700, Reinette Chatre wrote:
> Hi Jason,
> 
> On 4/24/2023 10:43 AM, Jason Gunthorpe wrote:
> > On Wed, Apr 19, 2023 at 11:11:48AM -0700, Reinette Chatre wrote:
> >> On 4/18/2023 3:38 PM, Alex Williamson wrote:
> >>> On Tue, 18 Apr 2023 10:29:19 -0700
> >>> Reinette Chatre <reinette.chatre@intel.com> wrote:
> 
> ...
> 
> >> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> >> index 4f070f2d6fde..d730d78754a2 100644
> >> --- a/include/linux/vfio_pci_core.h
> >> +++ b/include/linux/vfio_pci_core.h
> >> @@ -67,8 +67,8 @@ struct vfio_pci_core_device {
> >>  	u8			msix_bar;
> >>  	u16			msix_size;
> >>  	u32			msix_offset;
> >> -	bool			has_dyn_msix;
> >>  	u32			rbar[7];
> >> +	bool			has_dyn_msix;
> >>  	bool			pci_2_3;
> >>  	bool			virq_disabled;
> >>  	bool			reset_works;
> > 
> > Also, Linus on record as strongly disliking these lists of bools
> 
> This looks like an example:
> https://lkml.org/lkml/2017/11/21/384
> 
> > 
> > If they don't need read_once/etc stuff then use a list of bitfields
> 
> I do not see any direct usage of read_once in the driver, but it is not
> clear to me what falls under the "etc" umbrella.

Anything that might assume atomicity, smp_store_release, set_bit, and others

>  Do you consider all the bools in struct vfio_pci_core_device to be
> candidates for transition?

Yes, group them ito into a bitfield.

> I think a base type of unsigned int since it appears to be the custom
> and (if I understand correctly) was preferred at the time Linus wrote
> the message I found.

It doesn't matter a lot, using "bool" means the compiler adds extra
code to ensure "foo = 4" stores true, and the underyling size is not
well defined (but we don't care here)
 
> Looking ahead there seems be be a bigger task here. A quick search
> revealed a few other instances of vfio using "bool" in a struct. It
> does not all qualify for your "lists of bools" comment, but they
> may need a closer look because of the "please don't use "bool" in
> structures at all" comment made by Linus in the email I found.

IMHO bool is helpful for clarity, it says it is a flag. In these cases
we won't gain anything by using u8 instead

Lists of bools however start to get a little silly when we use maybe 4
bytes per bool (though x86-64 is using 1 byte in structs)

Jason
