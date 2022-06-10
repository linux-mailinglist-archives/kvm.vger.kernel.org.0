Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF095458F1
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 02:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238802AbiFJAEj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 20:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbiFJAEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 20:04:38 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200B52E93E7;
        Thu,  9 Jun 2022 17:04:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWw8qmAIQV8n4SLR+cTBch8sFHDZ7ONliENFZIaYSQv4wx9NkqaBmR8bMK/aF+EWfowcRaaj8JAzffRJZUM4T+Ba5zOaWlmfDQQfPMAFoRZ4kYj4j8czdM0mJiuwwsgYWlgxVQ3sxT6GFbFtBwpKwxO3k7LzG64HoPqXRfo+SEdHP2XJ2eZkiyGBbOYTu4aLNDOrGCZGIm4tBD5eE6UyEtFOrAoBFqR24UGNABy3E6WRbeY+lWef2N6tVKyrTUogmSTboNjd/30Kn0bFt2jTNEAGlH0sofX+mcYdkD9UKOKKs6SIBaCS9vn74nSXgYjQut547hYjLszw0E1/FS3Whw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BkJSpoqJIZ+uhN6zMr35XHimir9RM5KTDo8T0C1uJWg=;
 b=Gmeygob0T8EQRyHBjTNWGQS+ApV6G4B0EEtcumW+5eYAqVIv33Zn7jqWJwQAPf0tkDAyiDE6Z/+MUzDjnaIWXtCFZVS8U9AG/1PESYlvt5EeJsJhkuF/ttvuTxqWG0j2mkRp0ojZHRMzWpoqBy3qpaAUzlaA8fWrt3CFLzo5azX27qMC1FMz1vWic2cH74j1M/A8KfyxJk9lUSs433J/7IisuGOTcqutVJ+P5PZcLYiw6EZA/atpo2Bx/XwBUtd84JTvbUcBbVAJxGPZZ5UinmAtxS4WF4nXZMgt7Bkmwv8T3e65lgnmuMZmyeQGKObzsNAWXzJnS0LujjyMun0ymg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BkJSpoqJIZ+uhN6zMr35XHimir9RM5KTDo8T0C1uJWg=;
 b=q9Lpk4gf533toSPgrEjBEbgkc7mGPF+7Uvs+ttzLOtT4u1MC08cLaEs2+0KJYmH+NKpqZQbzJBLnYORLEmdQV4qE8Zh1lizBtuPEuddVUFaxlO7hSo7N9UusMF7sfWbHdmAOmeFJKXE8Imm3w85W+T+8e2qLMrVW37KVDzuL2CN9a+J5e+22/qpRvJhghQm9M7dO0q5Rsz6XZD5WNpA8jm+/IGGiiajizUEAurZagMIIzbfTPmx9hlJGktEtd+ndeHX9c8zSq1b0dDrI7xVefJv6JweIXOFXdXVBwsgB6Z+s7Ykv3ArD5Hem+BrAQJCiOEf2sRAxaFxzTuO03j4Cxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR12MB1768.namprd12.prod.outlook.com (2603:10b6:903:11c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Fri, 10 Jun
 2022 00:04:35 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 00:04:35 +0000
Date:   Thu, 9 Jun 2022 21:04:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kwankhede@nvidia.com, farman@linux.ibm.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, diana.craciun@oss.nxp.com, cohuck@redhat.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, yishaih@nvidia.com, hch@lst.de
Subject: Re: [PATCH] vfio: de-extern-ify function prototypes
Message-ID: <20220610000434.GE1343366@nvidia.com>
References: <165471414407.203056.474032786990662279.stgit@omen>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165471414407.203056.474032786990662279.stgit@omen>
X-ClientProxiedBy: MN2PR16CA0042.namprd16.prod.outlook.com
 (2603:10b6:208:234::11) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a54be9f8-45fe-4684-df7e-08da4a74cdbe
X-MS-TrafficTypeDiagnostic: CY4PR12MB1768:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1768D2513F9569138FA509B5C2A69@CY4PR12MB1768.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7InaZMIrXuv9s253r6D/zEYbk2FZ1fZclqCwT+QwR/Pel/3hhUSrf9Xd6Y/TuwfYIc6OJtXvbIm8C/wkQAP3Og+45311F+oVAL1m3QobgNlnh/2ITeBid0zHcM27UMq8iFOECEOR/Fl+1gOjW53OnlNLyCzVoDXyvfqX6yjS+QNrXtiZiv7oniiV+9JvqUO3UcLhtk8XEbGHoUWgnN6g73YLyFvtG/9Jt3BgrnTUvtXwLCg2+fk9vW7At2DhHo2vMskurIaRpdGxDbGv20xhC18VDqDcjnsDJKiWosxUyboABIX2WFDmRPEUa8xFp+Xn6Vk/XHg+mt/YmWwTROkme6YVrWBjv7R9/koSPm3fay/JPBr+Iu2gldsqFmcJIYiCP0VvKNWxFqKe+8XLXArE/yzdBYQJWi6QmyT78KSb9CVFYVLGQSfzAbFPKSKns/MKXCSILL+UCCmbiAF71lMMtxFuGRseF2RpW32J8W+RqeD7pHQb+obAN+t3/Y53Zo+O5zdomg6byXXpkLh03M/9FGRPfTtPy4CZkZTdBgDJpA4WMtNMxYqo1QHeKL3TYIz0p0UZZuSa1JcUL3NuAYGKoADExfVRRcE/5fMM32QN5aYRr0egz5fAWCjtbl63qNWTyizJbTeKaHB8WYro3gyHog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(186003)(5660300002)(6916009)(4326008)(66946007)(8936002)(8676002)(66556008)(66476007)(4744005)(508600001)(316002)(7416002)(6486002)(33656002)(6506007)(86362001)(26005)(36756003)(2906002)(2616005)(6512007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fbatCssn4GawTpeCIlXO4P+V9btiSQaWnecQzFFkF7ZXBJe73V5uPx2dOk2q?=
 =?us-ascii?Q?NKG5XCeoIc7wSxUG2gwmn5xpOmHMfWVP70gFSFNW7FcfWKoiBlC99HFBO+kd?=
 =?us-ascii?Q?ccp8CrcBTGgBcpZa7uggl9XTfwWQMFw2t57mvxmx1C4LpTXpRhvObW4VM3WO?=
 =?us-ascii?Q?kiZIhYJXQCdbcoezDGAsAt2PUH7JrQiWB2MBvnMvA9IWBwkudFMN1lJ+DUtr?=
 =?us-ascii?Q?1lNBaiaUZreizhHWphDUMTACansJSQesfewED79BVt0kMx5OvXKmgykhvW8g?=
 =?us-ascii?Q?y8NUoTh3bdUfimMlrW3FJ7ldVEcZWKicLvxxor1H+3Y6y67dQt2JvzpVw0CB?=
 =?us-ascii?Q?u9gFsL8zuBSS+LdQTP5yzeCiVJ9W+8GyP25dD5SedHRqDWn6WHo5Ct54WRU0?=
 =?us-ascii?Q?DXWVTYP1HMnlp2wW7nSTR2bMfhePBgMtGNCohUJ2KVeGIPofsw8a7hRyPICh?=
 =?us-ascii?Q?r7UraBQ45UV0nOe15/8kt5NyYKlMaUV2AlLcWOCeJAB/y7Z1qPvMkPwYLt0I?=
 =?us-ascii?Q?fER7GcHc4NPFB2T8dgCAK5y7n7VGjSW3ftadkFT81EHE2vgnsCI3Pj2ZdNam?=
 =?us-ascii?Q?BTPZSJU6wTW/SeP7y+QeEY/rkUwg9rwul0RK3yWO36CLErfuVB/IQ6T3bbas?=
 =?us-ascii?Q?ufI+JqweuzqIbQuePAIS0QKnJwGJuse3Yd3IjEC8JxnzWdblpBZUP8lAKZZq?=
 =?us-ascii?Q?7rAFGkBGw2SObjmXcrbZltQ4xNUWAInpy9aemWuNgx3Mm+qDujMEmIiJ1+q1?=
 =?us-ascii?Q?yjrTjgpBj3zaDpixU3uQOx2q5XHmjhTJ5lOXTJ3l3S18eWTuiyjg98mL07kL?=
 =?us-ascii?Q?XzBs1Tvsfni8dQmIx02WMvjLqzGOEcYCOPvCbpDKFgMQRJGtvvDjF12LBvx0?=
 =?us-ascii?Q?3mAWI2ni2xSHcfW3TWRmvFhbQ8ZJ102v8F8llcGGuzv6iN/hZ/xAGd0Y7l9D?=
 =?us-ascii?Q?tTQL3WSevWtvOksfrCZTUgx82DrxJ+ciDXqnunj+FSLIkkH51gI9Kd9k+eF2?=
 =?us-ascii?Q?vQqSJ+QzoTHuaDEDODAkXVNka6HA7RiXDVpQ/HDh3FCAhD62KY2KTsKDvWvg?=
 =?us-ascii?Q?zkgmmqUlfPOm0LtYmeN426Ck4jpGH8OxlNTpp1vWlU5M+pJMSsOv3sMV4zyE?=
 =?us-ascii?Q?BfbKY0LnfnQ4ISMc6Z249Xc/bDREScMI6jHAfhMQi4O0ovR+db7hfryepBfw?=
 =?us-ascii?Q?U2ArKnmZv1gCTMCuJRjUGvOYKUhYRxLnZVoZHlEfziibOOlxEv/Zyc5wsLjS?=
 =?us-ascii?Q?88GjvpkenX0xnzoFPo4upkQiuegpgO9UZstyeVViAmq5XFqriDJOrsesryFs?=
 =?us-ascii?Q?0JUIegerxK8k/8lDX3lUJmkSDvdbPHOHvtX9lSLqghL7A8N9in5LQbYHwgq+?=
 =?us-ascii?Q?laJzqzzQdHAqReLYnN9VQDrxrs+2j6tRhjlG9ODYl9k4qbDkdvj4P+jg176i?=
 =?us-ascii?Q?wfgQOXyzIRtwl0IrqMeZMuv0QF62LUtkHNAR75GYUBiszvgLCysI1qqEPNQ7?=
 =?us-ascii?Q?JNyKDK8zZuNmIEBaIyRU0WECGoNMCZ5B04BbwhT2QIEFkiHR7DYzV1BvFQnc?=
 =?us-ascii?Q?eBcXAQ25Xiw6ewnqKkIUuxoO0KJJd5gB7n6/sYUfyiWwlFzmuPKl8ibrUmgi?=
 =?us-ascii?Q?OE5Ebp0paROITbWFybTZKKvmWTnWpTbxk3cZtHoaIXKlBDoBpuVfDBXnHFHa?=
 =?us-ascii?Q?/eAJh7e/ywCKCWN0F2UiLbDLr5qwoHW59dSeptlrLjA8BldWspFsBi0zoREc?=
 =?us-ascii?Q?uIvnQUfhJQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a54be9f8-45fe-4684-df7e-08da4a74cdbe
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 00:04:35.6565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7rIPBbajZ9g25y1MrwWXPxrj+W01nrWfCnwVLe2nXhbGAhHXqKdUgJE5o0U0vUkN
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

On Wed, Jun 08, 2022 at 12:55:13PM -0600, Alex Williamson wrote:
> The use of 'extern' in function prototypes has been disrecommended in
> the kernel coding style for several years now, remove them from all vfio
> related files so contributors no longer need to decide between style and
> consistency.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> A patch in the same vein was proposed about a year ago, but tied to an ill
> fated series and forgotten.  Now that we're at the beginning of a new
> development cycle, I'd like to propose kicking off the v5.20 vfio next
> branch with this patch and would kindly ask anyone with pending respins or
> significant conflicts to rebase on top of this patch.  Thanks!

Can you stick it in your branch please?

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks
Jason
