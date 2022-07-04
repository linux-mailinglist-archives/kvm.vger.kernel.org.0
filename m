Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5150A56586C
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 16:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbiGDOPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 10:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiGDOPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 10:15:41 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1FCA476;
        Mon,  4 Jul 2022 07:15:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WFef6e6PjUG1Iue9gzlrjufESBaYw0Kwvyr+TklDBTNv+3pojX2eLUa29++R7PJXu+WXvr/PbQIno2UJ8ffhgvMFiP7ivg8+9bMjnDAb7GQfpvR0Bkhuxgi9cuvfqVccc19Q5IHssc6DePEWTuHjAzfhT1OzaJ0XIX13Cg4Kw8ixTQRiOgt1HRI2h6I8bI43Ts/Yna1Z15avOE0Qkyc0xhiLi6OsbYUe/GMkbpl7iQMkKzKCW7tjWwUohZVRSaChM537ynt8WJgl5mB25mpeJ0BDVOjDE3RaeRf/AQYDFdU3XzX/vpvfMExXQSkISgbO8V6ANVwWNbnOhvXPIVTtpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vBjDFR8+tjtNRnSbA+TPylOHslH03F7mW9ZjLfHNyPA=;
 b=ReoGMdL6Sytayref7EUwveXXJV9R27LhSByVRve/8iQkqCjbdqMkZx2S/0NopSu0Kh5k7S9jRzUUX/JgPpsj8XpgeXp+pLwQ6W+8/aYGtiwT358cAGu9+8Jjd6nE+uXreKFz9WiaFxQ3bThf+FUZOG9E3b6qeUenTsd9CD1ockHe0YrvR5U+3T32Go6UiT3jBIhEbIuvqrAYp6I4SHdIWLwD3si2ycIEKRI300T+X0CWkhSSIS9T40VES/NBfN276fTkggu7YKmK6dNPw1hr7FhQVFT49emUveiE/PWmmbWVkexMvS1NtrFwUgdq0TwUqIepO7VHaTwhosZwmbsDGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBjDFR8+tjtNRnSbA+TPylOHslH03F7mW9ZjLfHNyPA=;
 b=cYkxtfyeEHYYNXJtOq3BOZ68m4jgukeCiDX0MNQDe4LPGdGWUAXL4mfaM2OA6B8QvXO9O4WAwhnFtMa8XLr/dDF8Qh6/mZp/b5WYzk0zRka8fsOiHYPh23hGrsoFigdRGo1+0S1ybKC53AOUGJ/htYBZzI2kmPMsvtnKtS5hO3Ti7NiUzzi8N++tRJFKrH3xIntn0ugylCNev8QAc4XRE8M0r9swCruqsY/3E+aUPlHFjOA5Fj87hwEN4aVjAUlvLAawAnFosVBMD2iS7Ab0LNgYKbNgYb0T6coKxbP0F9TJ37wyqu4KXkoT2doZ4Zc7kVPINv100UsWbpIKPAhlcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB2684.namprd12.prod.outlook.com (2603:10b6:5:4a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Mon, 4 Jul
 2022 14:15:37 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 14:15:37 +0000
Date:   Mon, 4 Jul 2022 11:15:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH 02/14] drm/i915/gvt: simplify vgpu configuration
 management
Message-ID: <20220704141536.GB1423020@nvidia.com>
References: <20220704125144.157288-1-hch@lst.de>
 <20220704125144.157288-3-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704125144.157288-3-hch@lst.de>
X-ClientProxiedBy: MN2PR08CA0029.namprd08.prod.outlook.com
 (2603:10b6:208:239::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb74971c-2142-42d5-9dd4-08da5dc7aaff
X-MS-TrafficTypeDiagnostic: DM6PR12MB2684:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BM81tgmn/5m/2OIWoHM9aSutzTV8fYJBNG20DtDUtGBw5K4EeyrojbqqsZk57XkeCJ5Azg3Bh92+FqDCjV1Xct6jzrRfmGwFypVBwvMKXBcNX13IDGh7JwzvlBGq3GtNQ3jl3H1MnW3qtyevQjserAF7a+XgGi9vwzsNH3mv6EIjZIZZUEhhHOsH7wGq/xfKQh/PMJ7fmKuejyDAyLO5jfl8u37VJPNsQTWuSGGi9/Yomf3EUjMt1S+zY1PdnNnd16PYlK/KX98F0XAo9s5ulT8qkN6s1xza0TCrh/vGC2sK8m9OECzfiJOrtNt7mxb9NpWN8jQtqvQujOk1aaNCyXXC04CXfKMY6ATdN/fvBgdMmi8WXj2ZitfjvTJOiKHMYJgR904RQAvJ+zy/+6UsQwT7xfcmIr9LHZm3soulBHBDquIgFowPyICeMJvGXPRBnKDM/O6tC1EBM8c1+9SwlvHgD99U9piRSNWkbAw5+g4QtDlHm1YQAOxa+hFd8lk/oxR6p5jqP/0zncKScyuN4CYIQx+B3zBYs9/fB3lFa/z8KBReER6AAs3hEPMWjTrR31uxB0r3uIAxywEO4XsOHZh5htEPy4RRgroEfVVdhxLphv6v5eakVms/vah51pvKCaqcnsE39kOxYrepqRQBamCYWEqNYO/ctyMkSWvEYSned5Rq1PhQm2I1mE2iPWvTGiun7CySLav970eVtfxj11slrbdn179hnxt95+DGQiWVzgJBebfsDEhp/DgLNSkmT8gZMuKhQjSa7rQTso39kA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(6486002)(66946007)(66556008)(41300700001)(478600001)(8676002)(316002)(4326008)(86362001)(6916009)(66476007)(54906003)(186003)(2616005)(1076003)(6506007)(83380400001)(26005)(38100700002)(6512007)(8936002)(7416002)(36756003)(2906002)(5660300002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2R2XkYBCSUzRYm5X2LVKxmGET8jvvJIX6rqvXjM4HqEmCM8Wimz/cfTStR7S?=
 =?us-ascii?Q?PRxDzAqeyif7jzGqKZJg8BvClyVJf9HrqXs+y758iH3d99dW9HjyzphvjdL0?=
 =?us-ascii?Q?MNldYLK1f7teLnSeQJTYozoWnvzvFVHi6M6avWM+Np99ReHvxwNge48DmFbW?=
 =?us-ascii?Q?COzNsq86K3Spnltoun7BSpz3o0MWm6SB3NmvMFzUN+bJfjkSbP9YOK5PF8IE?=
 =?us-ascii?Q?RIZEbqFzCgGkz8wHxlSQPmtzYAaiRr2EA23DClmT/xIQl4x0FR4NTgMAx67c?=
 =?us-ascii?Q?feIL+gGBPeC9jz1uslGhD+8HX7CWC01z2gPpulWIE4J4f9BWIbf5kT1SElO4?=
 =?us-ascii?Q?nmyw/EDMHmbp7SGxxKlvZynIC4jTk0Y9krpYAq9fumRfzLriAWAEOPXnf1Oi?=
 =?us-ascii?Q?ZiTcVGQY47wdOgoTM6LeurRUIZODIUSK81cbN9A0ZnhZURdBtyGtKB3uznkJ?=
 =?us-ascii?Q?viCu0sl19xsu4XLX3Rcxz4vwz00glWX9bE192pEprfG6JhaADw6r6rWG3vlb?=
 =?us-ascii?Q?ZM89BeXFfsO1CiKkLfVYb2sw7dCJPdEZU3VhI54gOitOc/+eqGcjlN8287P2?=
 =?us-ascii?Q?4QGfLVmkTD18TZdO9cvCIdZ5ioOVoPbSJNk6MvyvdYa3Tcvkh8O3iAWuQniv?=
 =?us-ascii?Q?BwO7vh5P5uGGmYbCrCqhJ5jCkXXSJMuEy+QCM8a/gVwNAoW6WW7EuArewFjA?=
 =?us-ascii?Q?Crt06s6tzGKPbwOBxgrORTzS0sT7c+VwMYRamD5gsxbBOXwiBSnPbBr4bTOX?=
 =?us-ascii?Q?EnbdINbheyVAUHSO15GjZ/SDqcWlLPk5bLc7wzE67Bkt+wBSnHAZUggEW7+C?=
 =?us-ascii?Q?fG4Anv7hKavLFRvPYNdcH/EyistgrGDd1sqXToGZ1YT61oFYCd8x+KXc1Wgu?=
 =?us-ascii?Q?1k4SvIU1g/pbQjwnBAe2HKLZdARAKgoHJ5PEQzXgQeU6XO4lQZLO61bwFHSS?=
 =?us-ascii?Q?7uwlfJrDqAYB09PS2O0pgkoHsR+YInJEjp5UZr29Khzkqku+ZMnFP/kLw3nu?=
 =?us-ascii?Q?Lf1yVJfBcGeGSVfF1YHkhN0WfRoZmTq5h1XVj+VLEHFfuzWcGbMD5J9zg3/y?=
 =?us-ascii?Q?M7LyyIOCHWcmEj4RWW5JKj0iNT84MeMcVGDg2yDawNA1mhLV5RYnDdIr6Oft?=
 =?us-ascii?Q?ee72CALJKSD7fIhvm2kNgVFeIyNqZw5naECAKlDvI5h/m5ThNDUoRlQ3JPpJ?=
 =?us-ascii?Q?ryNHZ8GdBrw2GvhpMfd9ENcWT30RP76oEKHGBuj2itXQAFUpva3iVcSej8KF?=
 =?us-ascii?Q?hPbdafvj9nFyKhoHxUuxOWxTUI5togk2K7XNBL/COctjdgu+gMwsec39dzB0?=
 =?us-ascii?Q?mPTb3Df7rMeLhjvm+E6Gx09DeFcLiNrxwBEpSETk1EJ55xLPY3fqTEU1Ccal?=
 =?us-ascii?Q?enU38/0c4yp83HfGype+lEGvSNRhZSEc7T2J9E83ll8cQw2MVTZG9o90DAiI?=
 =?us-ascii?Q?Lr1jM1F+yaGlFCvO8l3QHuTqBBMBO7wLPh1/kFbEKMDU1qy+x1y4RQq90n9i?=
 =?us-ascii?Q?d7cGFv8v1iOISFRLT2PZxJog0TFYc2jiyYKEVI2TCzmFjLgWnb4XGo8nRkxS?=
 =?us-ascii?Q?LZlYYkDYuWWGHa6TXdfc+jjn9ap97szYhtAveKwN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb74971c-2142-42d5-9dd4-08da5dc7aaff
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 14:15:37.5726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YkdXirzgaEtQVEJttaL/XE+pObSsdnCiuWQFkrSv+IT6xXiHIhZezlgs62Y52I7R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2684
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 04, 2022 at 02:51:32PM +0200, Christoph Hellwig wrote:

> +/*
> + * vGPU type name is defined as GVTg_Vx_y which contains the physical GPU
> + * generation type (e.g V4 as BDW server, V5 as SKL server).
> + *
> + * Depening on the physical SKU resource, we might see vGPU types like
> + * GVTg_V4_8, GVTg_V4_4, GVTg_V4_2, etc. We can create different types of
> + * vGPU on same physical GPU depending on available resource. Each vGPU
> + * type will have a different number of avail_instance to indicate how
> + * many vGPU instance can be created for this type.
> + */
>  #define VGPU_MAX_WEIGHT 16
>  #define VGPU_WEIGHT(vgpu_num)	\
>  	(VGPU_MAX_WEIGHT / (vgpu_num))
>  
> -static const struct {
> -	unsigned int low_mm;
> -	unsigned int high_mm;
> -	unsigned int fence;
> -
> -	/* A vGPU with a weight of 8 will get twice as much GPU as a vGPU
> -	 * with a weight of 4 on a contended host, different vGPU type has
> -	 * different weight set. Legal weights range from 1 to 16.
> -	 */
> -	unsigned int weight;
> -	enum intel_vgpu_edid edid;
> -	const char *name;
> -} vgpu_types[] = {
> -/* Fixed vGPU type table */
> +static const struct intel_vgpu_config intel_vgpu_configs[] = {
>  	{ MB_TO_BYTES(64), MB_TO_BYTES(384), 4, VGPU_WEIGHT(8), GVT_EDID_1024_768, "8" },
>  	{ MB_TO_BYTES(128), MB_TO_BYTES(512), 4, VGPU_WEIGHT(4), GVT_EDID_1920_1200, "4" },
>  	{ MB_TO_BYTES(256), MB_TO_BYTES(1024), 4, VGPU_WEIGHT(2), GVT_EDID_1920_1200, "2" },
> @@ -106,63 +103,34 @@ static const struct {
>   */

[..]

>  	for (i = 0; i < num_types; ++i) {
> -		if (low_avail / vgpu_types[i].low_mm == 0)
> -			break;
> -
> -		gvt->types[i].low_gm_size = vgpu_types[i].low_mm;
> -		gvt->types[i].high_gm_size = vgpu_types[i].high_mm;
> -		gvt->types[i].fence = vgpu_types[i].fence;
> +		const struct intel_vgpu_config *conf = &intel_vgpu_configs[i];
>  
> -		if (vgpu_types[i].weight < 1 ||
> -					vgpu_types[i].weight > VGPU_MAX_WEIGHT)
> +		if (low_avail / conf->low_mm == 0)
> +			break;
> +		if (conf->weight < 1 || conf->weight > VGPU_MAX_WEIGHT)
>  			goto out_free_types;

This is now clearly impossible right? Maybe a BUILD_BUG_ON is all that
is needed:

  #define VGPU_WEIGHT(vgpu_num)	\
         (VGPU_MAX_WEIGHT + BUILD_BUG_ON_ZERO((vgpu_num) > VGPU_MAX_WEIGHT) / (vgpu_num))

> +		sprintf(gvt->types[i].name, "GVTg_V%u_%s",
> +			GRAPHICS_VER(gvt->gt->i915) == 8 ? 4 : 5, conf->name);
> +		gvt->types->conf = conf;
> +		gvt->types[i].avail_instance = min(low_avail / conf->low_mm,
> +						   high_avail / conf->high_mm);

snprintf and check for failure?

Regardless, makes sense to me:

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
