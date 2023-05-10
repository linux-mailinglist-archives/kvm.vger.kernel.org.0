Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B767E6FE54C
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 22:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbjEJUl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 16:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236605AbjEJUlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 16:41:20 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE88872AA;
        Wed, 10 May 2023 13:41:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKsiHOD9pT3TtMA4taQ36Iz2WwlqJU3KmSRaj5ICVngnuCo34c/rleIariqdXQRfiRCwpBIJ4UVlS6y5GBfIeyOt0UKG1TovEV3KbJKaKhSHdRIBy3iOc3ym3IxQwdwf846GrP/GBhQuzE3ucyhCfnckogaeZcZaIXWxmyBDYbAnXUeP7MLrT9Y13BGKfghGtu09YiFfomb0U/vrb+SHra+b9DQFLoPvbRvCWN9J82TrJwvesQFi0+rf02yq8m/xCmvpJwWstrv9xNcDBArsUU0L+Px8sM9UtwKYOZvTjX6zSRDD3lfrRM+Skbti4ShE7BXsXj1DrlcXm2TLbAcyiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Y9Tm61cFnRT0R3ck4L5v5CpwL7iXFI7jmnXzGD1ZAo=;
 b=jAqYsCptyL7BKpK7BRayQNfwPtvF+G4zGBgXqe2XlEnq5AoT4omTmMPzODteYpgwqBUm9tmdJTPswJF9rkzUuJudmHZhUk6t59RTxF3V7W19TgaP6/K5W2sVeTjTC3CfOcOD6sS3yTXXRZR+mqxPPCWbGv1sktgcGS89cQeWDNv5P709bGNI+slzhAMdqnGPaogQt3kxjQ/DT/0kHpc7/HdzrhYI/oZS+SPAtGlPnKuCccFk4WK9qifhQ9v1VWbPhmG3kJdoUIVmJsLJfFVEzVEtxN9hz3ZBSUbFL0R9pLWOjprHo/waT5doKPT47vrK50LZbhtPDqGqAT/0IL7ltw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Y9Tm61cFnRT0R3ck4L5v5CpwL7iXFI7jmnXzGD1ZAo=;
 b=KGUO5UAZeLoL9xnB6NpEebMtdXH6nOypyXaKfp/uLiM8OrIP5WllNucc9oWKjjnruOMvMy7aTrmLHNhaQyrjDaRcutSjIQD7ewXxe5zTK3HfeDI8OBZz8opHi4t474e6rlY0m1fb5zmmEureTRy6uulec8JRJGV4WTzRwgAlH+O0FAR09W4XFuJq1chkBd2ofZ+vfSOVON0fQsakcGSYts9rZOq66XXUMCzpxkvBYdUPvtVDHZCDJFEh0qaLU+FkBxGkUAIUCrkfScgoUpi2v+Hi37Jid5UM8uL4mWjxEfE5PbiiLXtcv9nC2epiPNh+F38cSY3+v9VxguiCWi5qYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4966.namprd12.prod.outlook.com (2603:10b6:a03:1da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Wed, 10 May
 2023 20:41:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.032; Wed, 10 May 2023
 20:41:08 +0000
Date:   Wed, 10 May 2023 17:41:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.tian@intel.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH] vfio/pci: take mmap write lock for io_remap_pfn_range
Message-ID: <ZFwBYtjL1V0r5WW3@nvidia.com>
References: <20230508125842.28193-1-yan.y.zhao@intel.com>
 <ZFkn3q45RUJXMS+P@nvidia.com>
 <20230508145715.630fe3ae.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508145715.630fe3ae.alex.williamson@redhat.com>
X-ClientProxiedBy: MW4PR04CA0217.namprd04.prod.outlook.com
 (2603:10b6:303:87::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4966:EE_
X-MS-Office365-Filtering-Correlation-Id: f01f2d22-6c17-4fdb-720d-08db5196e24b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BNxlnfOsBKnxn9cAXx1SRtRSsy2fjOzN0A5rQkA2tODFR4N4uq2mg+uu5B0QnRUb9iK6iNKvf4RZ3BOCJOVuoBPu0vczZHkM6eRCzbfDMrzcqFJfY7kff8OoWcjg7cElgV/nJcbvq7rKTaTrz2wQa/yqzjAZE9plL7w9fD8MaT4zMeXzvtqSe0vBdyan7qNjOHOzDjZ9KwMQ4IMNt6UCFeJppqEq1IvO4MW1x97Inend9foX7O+Bv0aJ4rcR+q4BiE6KEYkoXUDmmt5u9u8lDg9ZU3gpEMm+O9/qRoofuYt2pq5TG44uSjJiJAYUfrwP1tkZWujbBLUmTwIvIAcl+RQdRcCpwQF56iZBFpt5yiVhB3PQuWMem2f7ap1VlM8jXmaqP6SdFyQXeU1QdmEWw3I8OBJvUhaS2BYGfqGlX+8jov5FcHjeM1fcIBq72h24xGhkeMHA5DrzrSHUPBpjvOYAnBdHN9zEjc62yeP1szOwqbThVfRGos485LmFUoC/7j4nYuTnGwl9Qmwey6bMV3PjW45aogLB0+wBwDaFPXsMhMIm+texofeohUBrn+nO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199021)(2906002)(2616005)(4744005)(6486002)(54906003)(66556008)(66946007)(316002)(66476007)(478600001)(8936002)(186003)(8676002)(6506007)(6512007)(26005)(41300700001)(5660300002)(6916009)(4326008)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ksAbYT6KcOeHHutdwWZxPJft+lr4QWa/dXba0xznp7aTdafUoseZ614+D5l4?=
 =?us-ascii?Q?W7JHqGNC+d96TR1+WiuSb8LJJ0GavF3lGY1MA6adIIRmHMuJ8vRRM0sj5tfd?=
 =?us-ascii?Q?4zzGMRjDK+cugX5W7jLAxYpGN500xoIdMnGUZ+0J+q5k5+Cj4q5Y2l49tZhf?=
 =?us-ascii?Q?fNlohS+rxNKgavDl0VSJyYmP025CVa6uqXw8jgtueKoThgyFi3f8/yV923A2?=
 =?us-ascii?Q?D78fSK36dMZ5KDU1ZSDOoraMGY+TmeVSyDoMZPc53xTXnjUxYCu5v3z/8DUK?=
 =?us-ascii?Q?/hM7//cDAxSJFbbxOaHUrE+g9286W7F+P71zOfPePBVi9WdWArYPGbji4oBr?=
 =?us-ascii?Q?OqlOF1j+cGXKeofzxFbqxYqsC25XWDmWQJeV6KJxEQU9TIPrmSeLfxiJYTHB?=
 =?us-ascii?Q?LdSLdE04iqK3lIgCpMqefjgAYTzShae41THWq510jbVzjzCMK1A2k5QDbykV?=
 =?us-ascii?Q?uYGotkSkBhaiyJF28Jby9/w8X687nH14dFQHLyNDI0+qphiDZK956PKwMb9K?=
 =?us-ascii?Q?vOiSxa0T/7GRKSaorZ0+vR041M7qg4gz3eldL2LIRR+ipKDFvwSAxOo/uRDz?=
 =?us-ascii?Q?tltUkOr8xMK/CA4nwcEWpw1FgkG80D5Hd18CZuZQQpxNpDaV+J5KRSyHR973?=
 =?us-ascii?Q?0l4HyE/BD3doPzVRSJBnn1fS1467GzjDdRo5k+k85ylcRnQefTiCGGNCLPcn?=
 =?us-ascii?Q?BVzLVIItNjdWB2TMVa3rVg2XXmOcWay4qBpMzLg8Ge4vcRwXEGssdIwfFXZP?=
 =?us-ascii?Q?bnWCe3sKx4CJ84pDMJrzecQ79tx03lBqFu2RE6qAikOWUQ0TTOz1RSzsU9FO?=
 =?us-ascii?Q?E4OpqX56BTmrunXF7IIuYYUUsEC5yCvvPFy4t02692gbwk8HXK20ZpARsJNO?=
 =?us-ascii?Q?h24aVdDbVp+uyCFnOnPWPbiMJFYGYZkAjcrcdpp575rvKF29GUrzYPplcfe/?=
 =?us-ascii?Q?j0YJHqa3bsZYR+CdVgetjjmwv1S21nsn0UKrIz8mVoyjUKp/rn0ua0r0JN/R?=
 =?us-ascii?Q?4w6ZAUCdzHXbU6pq+GmunezgwJwzQew6iNSmLI7gQlWrplE8A9azQt3ioNPv?=
 =?us-ascii?Q?hT/K7uYb3JqLcQ3z4GMtiZZJ8ZAQYCHEEryQoTLkc9NbnACgcv+8q3usXoqZ?=
 =?us-ascii?Q?Y9rMhQc4RFBSlyUeBwQlNF2QODwCwqo+nhYpNomuBr2osh4Eh9I0RsEnmVVi?=
 =?us-ascii?Q?4jK4tibPBJwqljjQru+zbVi2JVU9bAPHtS9CtdLN5mx/Y80Tng0OT687hbNc?=
 =?us-ascii?Q?U36i3BB/yP5tWrJuSJmQqJaPmHQUq2gQYR2RtLc2TSLh1MJrHQa2HUuWTuxe?=
 =?us-ascii?Q?DgMHNnsLnQxp4loIpb4JPyerZGpJF7hxNPuXvT7sPYTbgKrMSKiyLq5Co9Od?=
 =?us-ascii?Q?DIRaAZgkQmWmBz0DukiUoFlmGBl9RoZAbz93sToFOWViSbD1GROJDMNOfp9n?=
 =?us-ascii?Q?lZ3bBfmWvMfrqghYTvgmcF7+nHkrOQsmnpCk+i8la8nJYekklwg0VE89p1un?=
 =?us-ascii?Q?pQsbz1ZnEJI7qSiZH5K3Dvl96V40KsNA9kIZ2ClDxS2h14chgc3gGqPyakgr?=
 =?us-ascii?Q?Myuvx7HLgLghbD+dW2I=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f01f2d22-6c17-4fdb-720d-08db5196e24b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 20:41:08.8051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQWXhW9b/WNM2XhWIRQFQiRI8gtdVzZHvLADktS3Sp8/KVVQxJeEm35B6fPowOrU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4966
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 08, 2023 at 02:57:15PM -0600, Alex Williamson wrote:

> We already try to set the flags in advance, but there are some
> architectural flags like VM_PAT that make that tricky.  Cedric has been
> looking at inserting individual pages with vmf_insert_pfn(), but that
> incurs a lot more faults and therefore latency vs remapping the entire
> vma on fault.  I'm not convinced that we shouldn't just attempt to
> remove the fault handler entirely, but I haven't tried it yet to know
> what gotchas are down that path.  Thanks,

I thought we did it like this because there were races otherwise with
PTE insertion and zapping? I don't remember well anymore.

I vaugely remember the address_space conversion might help remove the
fault handler?

Jason
