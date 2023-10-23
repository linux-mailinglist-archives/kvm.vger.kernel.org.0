Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CD27D3E9F
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjJWSJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbjJWSJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:09:01 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585D6E6;
        Mon, 23 Oct 2023 11:08:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YnMVa8UqjqkG9s9PCf+hRlNuHRvaaEWHqMoNHCTFinijZwJ/QQqLEcpxa60ulk/BRL0FyTOmmVzCWc+Aj1IDlLC1vO3J3oxWoBJf5ljuREUTsFfG0p0PBQ3ctKh57RkGzFhKBiHQw6cyXUH82ew/yypSQB5X4Ij9t8nIriD5qy2+OX3jgBd8m28PCEHGQdMnBpTmYAtdHxzKSlALUD3j+iaD1Dh/fVpDQ2BKzmTnn4UEUlTH/rVqGqxlNC08ZMD/6ChF8/jTAf2NoORHNTJRqiLHRrG/GyhXVjoQNKRmh37IwSTscDAdlcJI1aqiqUPje0RIjQVt8W+KvxMrCbrzQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GTbJ2/sFPjRx5tOpSkuT9A0GBwjqERLXCJrj3zubuNo=;
 b=jVNpAhtowc+IVh/my1jw6IqQ0XQ4bx+odRRKNj+Z5L3zA48sM69ZuExj5vcXmhbRknZ9l8Kk11vc/RvaAKx5rZoCbnYm+XtEWmOO7U21PDaO/s9S+sA1Elx/A+KgJy1Jwvigg4ZANyDkeSU9gGz/2dA8NgSj/7ixtTVnLR0LBWVNp6cOXtQzs8aMBmae2QeZOnx7y/eBUPGQWC7w6EFdddV6RWB/X4Rcc8Nt95D9Y23XonwlkTxsTAGMJZG599WEJUOVETTXWgPb5fdvA+OCyIM+TwCKLqerrG0oKF7QW4bKXAdCXVWZBefTd+EuVczNZt0Y9nxU6ZhoxYtjr3CVMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GTbJ2/sFPjRx5tOpSkuT9A0GBwjqERLXCJrj3zubuNo=;
 b=nXnssfVz60K1foA2EusXdmxXNPAyAqEZr1nLgc2zXT6Uc/s3wEsE9aLcNCwpArzTQZxi6xVs62VaneezJdhD8Vc03DPUMZaodC6jujha1mk12iAMQSfhXWp5k1tAfYPZcxiuCPFZhdABdvFUt/4p59Pc3N1jWhtjKpmqLSMIKGyZz1BwefKbfWNsJxTkOCp2/2MZB8qtXVuHmD79afE+3fmQ9OHO1S3Mtd2cWaI7Y4wLuLPvW1PppQTZNeF0CxfEqUDGnkmPN2TXxiEdGVb1gAAle+Woh/xcf6j64TzfjB9PPIg/CxHjVFplKu+DmQ3qn6GfX3noEG+zouRIe47mbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV3PR12MB9412.namprd12.prod.outlook.com (2603:10b6:408:211::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 18:08:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Mon, 23 Oct 2023
 18:08:56 +0000
Date:   Mon, 23 Oct 2023 15:08:55 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Arnd Bergmann <arnd@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>,
        Shixiong Ou <oushixiong@kylinos.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: mlx5, pds: add IOMMU_SUPPORT dependency
Message-ID: <20231023180855.GG3952@nvidia.com>
References: <20231023115520.3530120-1-arnd@kernel.org>
 <20231023120418.GH691768@ziepe.ca>
 <a16758d6-964d-4e46-9074-4d155f9b3703@oracle.com>
 <20231023131229.GR3952@nvidia.com>
 <3b731349-38e4-43bd-9482-6fe43871b679@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b731349-38e4-43bd-9482-6fe43871b679@oracle.com>
X-ClientProxiedBy: DS7PR06CA0050.namprd06.prod.outlook.com
 (2603:10b6:8:54::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV3PR12MB9412:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a38b02c-6a0f-4d64-2130-08dbd3f31fb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9b89ozNsbqnJgLZg85+p+g6Z7QPBH+JpbIZHi+Hl62/zgl5ZFZqh1Q5WVrmoSAkq+uXVeMzddbphYO+/Ci5d27PJ0GvJhLtNiorPywsIY6n8YKJRaphIGtS6cobM5pn802ydseEROaaJYnkGIBW94TTnHRF4icFIAWIjwHrzd2fKYI6VJZzlIBZzg5aURhOKdIWMObnlt24bZ2vjcyHKCwz5covoG0xnh57Lv6RUjKbO9e23YNiwm+vheY6kLlvpZLLCZZ3emAxOk6mLP0RdTBUBztb0oGkYZ7RjJiU+/G5i5kMF+ONeoGVxFvtCHUGjiL4q36lUm0ScepGG2MT608n65ASBNUlC/jhlEYDTuJ9HatiLwk0f4fv6YMNL5X4eigm6aKuxne42DiOnIM52ITHpV5jFmm0c8Ee8p6bPW8xJMonxhD0vjwTYUr6aF70OEsbaLm/IeChJCnaOS3J6dkiZy1yBCFiY5/XxCgaGQO5YazrTvaTmnGOJRQF8GrueQu8tR1of7rXgzb6g3D0iuk2xSxNBJO12ECwG8kQrDvujDh3OrWzMyRp0M6G20bvV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(396003)(376002)(346002)(39860400002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(53546011)(6506007)(6512007)(316002)(66476007)(54906003)(6916009)(66946007)(66556008)(478600001)(5660300002)(4326008)(8676002)(8936002)(6486002)(41300700001)(4744005)(7416002)(2906002)(38100700002)(86362001)(2616005)(1076003)(26005)(33656002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dYN4UQDd2m7ANFaCQB0CAVq/jf85wGmaoE+o6fv9rGiAV8Na6kGtqyYOptgM?=
 =?us-ascii?Q?ympYj7N/soB1rI7S76plTS88glom8GgwRUjCTBsn0MaUH9hrADHmy/VMD9Et?=
 =?us-ascii?Q?CL6EeBiUk6JUwKYWtEVk6q+9po26HabICNR611Xpwaa51uW4bEdHpTN9D+vB?=
 =?us-ascii?Q?+JYzF2zCG8nql0F9Ln45aIYl4mQg4Nqm81+ocirfFu+kGO6rM7+nN+qOrisi?=
 =?us-ascii?Q?4KRvcbG3XPXkKDmwyOhNnpY4hO8PBcDT603YpDCe87ntoeOoVJzw7QXv5MsZ?=
 =?us-ascii?Q?aa1qXRLh4f+ew5MTAWoSG8R2aFdGyIPq8mAi7StqvZufMujbXXVsLuCzDFmV?=
 =?us-ascii?Q?VeJVSj2wn6UjUa3TV3MtXNSITXmK1rmrui/BXFnJkgN+1ayLax5s7cx36SmC?=
 =?us-ascii?Q?3M48CDPEKpmIViy7b9ZXIewiQYHZuxNRWrTJmMCXltnYno90T2aMAOytVa8q?=
 =?us-ascii?Q?dVBhah4CVK0UvLgw/zC7sJIqXAqffn5Enf3ByPxBYaHxi/5J+hqUMeY+zoZY?=
 =?us-ascii?Q?inHarCFkRvEN/kV3MXmQw3MCG2pVN/RBBu6pdk3TKlTFfASlU4bWLtN+xJnY?=
 =?us-ascii?Q?HC3Tpnq63d5cNLwqOYJ5CGbK/sA5YYhMu1YY4sfgSmJ5sLJWxwC8TpZR7rGg?=
 =?us-ascii?Q?ofALoUtEWScItDJ/T9QG+mLy3Zogw7F7fFZPVHai4WufWwjhGLwHld/ECSM+?=
 =?us-ascii?Q?unei0CnRgtwRDZ0DkCSQWfKGpO8JO57BqwfUT2GaYUCXsmS2cVcyN1a1ZGIS?=
 =?us-ascii?Q?Zi8sZjBwC6nPIs8tqbzPaohN/29fX/kEU2BWyf4MfvwCuM/PB9m+fHk1uNJk?=
 =?us-ascii?Q?CKtL4XF3tsKaew8JdP+BxjqDRlRdWVvEXjxNaPhbRnVLxrsOVmiO+cD1/pum?=
 =?us-ascii?Q?EtsEMXNtC5aUyb9sR1zN7znZnufJJUbxdFHQGlW4bV8v77S5uF6aBeQv8Ywu?=
 =?us-ascii?Q?91blNt1B7utjpKGlgm55OWStG/BGvTLgB7mPcbHgtO9Z/YOZZlByJD6y3WoI?=
 =?us-ascii?Q?FfdvaFWib50SaCtYCWzAbbHZh6zBcnH3/Bd39oBCdGCS87f7dQBJerE5aCsW?=
 =?us-ascii?Q?g3SLAbJh0lARqicsZS5xQC0uZpDQD3eCwdUSW29SQ4mQI2M2oOQBNoh8G3FL?=
 =?us-ascii?Q?5Y3aGBn4C9v7DIrVA1NhrWvDdKXpJEIFcNx4CNKfEkzJR0dt2oLiKdfG18aH?=
 =?us-ascii?Q?qQCzb2q2RNWvC7lweBYPrTc2ahTU6U4nBZlVIulJ0PHQ6wzU2zVA6Oj5DNS3?=
 =?us-ascii?Q?Aj6bOyih+MmyGS/zdArZG+RNW2ivBkI+5f4Wd7A42FN3vHCjMoosQb7bnm5H?=
 =?us-ascii?Q?miYB/LoNM0q73leKo3m5cs4b4nlOcAzQs+a+GpZYHMahpqOlMOANPy5Jcqz/?=
 =?us-ascii?Q?XmxctIPJ5lDzzdmzbcWF/SPFnaGBxGKt9KbOtGPfrmf/UrLvVB/fCVku4Kxg?=
 =?us-ascii?Q?HOJTmCZD4LmaE788ReFpqRge1kQdJ5ePkrX3Ka8Q3b3gpw7coR2qIvmeirh6?=
 =?us-ascii?Q?RmUw7cpXnk+NY8ZbYnDVYTRGR5E+V3zWeMPHDMRz1fzy+O4EYfqazmeRoSkk?=
 =?us-ascii?Q?AIUliwgpKcV7KYbjViMBYUxSFfUYUdAZHfTr0/+3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a38b02c-6a0f-4d64-2130-08dbd3f31fb9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 18:08:56.7062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8YYNRkXPxzjhbsLU/NhsfU9Vnvzs8zy8KPyvh7PfiUYpeTeRYExMN/RNFwZAcMBI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9412
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 06:50:05PM +0100, Joao Martins wrote:
> On 23/10/2023 14:12, Jason Gunthorpe wrote:
> > On Mon, Oct 23, 2023 at 01:37:28PM +0100, Joao Martins wrote:
> > 
> >> iommufd Kconfig is only included in the IOMMU_SUPPORT kconfig if clause; so
> >> moving it out from the iommufd kconfig out into iommu kconfig should fix it.
> >> Didn't realize that one can select IOMMU_API yet have IOMMU_SUPPORT unset/unmet.
> >> I'll make the move in v6
> > 
> > I think this is some cruft that accumulated over the years, it doesn't
> > make alot of sense that there are two kconfigs now..
> 
> To be specific what I meant to move is the IOMMUFD_DRIVER kconfig part, not the
> whole iommufd Kconfig [in the patch introducing the problem] e.g.

yes

> Perhaps the merging of IOMMU_API with IOMMU_SUPPORT should be best done separately?

Yes

Jason
