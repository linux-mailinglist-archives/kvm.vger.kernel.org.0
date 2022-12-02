Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F82640ADF
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 17:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbiLBQde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 11:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbiLBQdb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 11:33:31 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DE573F78;
        Fri,  2 Dec 2022 08:33:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHvizAvQiuCPZgKo7mbzLXhmnuybA4iFlTzUgZg9zU9fPQgzKE81B5MiB9pcouqc7CDdW7gA5qjyMCMcj1ayIBBxRFzqs3+D331sV60vWDcvqowTMqbtTFwqAsrF9uC3bV61mJ8K05F4KwTRvRYhSwOdmiJJgHsNY1tB0ihS7uGPdfirjcxptfahloddY+EO/40xIcfMFsNSP69mnqj2zI6fC8EvOuvJheLKlO8bjj0SNC5ojzlILBdHRucCJkDoF+COhTuZhYQEcAiMN/Pfdg4Y8ikiEw8vDj5pjJ2YN2hD53QqyrgyvEone9Ov9xFC3dDD76S8ZxHq/Ug4ZoU6Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNW8oFnpYAndvfoVVucXJq2TqB8jr2Z2VUBAeMZbRws=;
 b=b1lj086kHuN4DXRDj0Q5HrEQL18RaoELEi0Z0RP807GQiDN5kz3mpqVsH/xpeguYwFxzcf0DBa+oebB6pHISqbR/Ec6zQN5BRDJRZ3bktVBqdz2q5rZ7ETVJTuT4j86luJo3eRnLu/Vmb4jfr0I4eUwvsahEBTzdRGOLmT8dgEGymuathDdEKHCM46kTmRCN9R/zFaWlVLZd7y/ah8ZEQyh//Fmf7h/V5XAKhPzmceZA74lY4Ih3JThXmWAa8cI0TFL0tu6rRDzKqkN3d4Wjiuvn+CjLiMp6pZbm7My6wmeoWRFcgNzin5IJBhL9KAhTp/rs98yNuI2j1BAPkKF0sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNW8oFnpYAndvfoVVucXJq2TqB8jr2Z2VUBAeMZbRws=;
 b=AOwEaIhtm0Xdzv1qsxOD2H/C+2MwAjh/nsnmlMNVWbMq6+OQuxbaEt+N2nDHwPboZVfEOsMA4tcrwdgbgD7SJz8HraAscq+6JScqf/T+vw9DcCe7pjaEODEn6+eXVfOtm/8F0r/luRep7sKebLjC+6cSbqMkFB3z+7DH8ljEja52HFOAJR/HV1bBqQdirKMxu+b4zzx55t5DYu0Hx8qJIP8PD7J34Itd1hMOMJJNbydpj0hDz/3FCcSeLflO14FZ6AH+hK5vmjljuFPKDNoSWP6+xeIV9C+WxR+HyrE38kfvobqTsw52DyYJztpIfmnQtrFHehZOONv/DRj6BUCB2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB5977.namprd12.prod.outlook.com (2603:10b6:208:37c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 16:33:27 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 16:33:27 +0000
Date:   Fri, 2 Dec 2022 12:33:24 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [[iommufd] PATCH v3 0/2] Make mdev driver dma_unmap callback
 tolerant to unmaps come before device open
Message-ID: <Y4oo1DEuxFGeoYzy@nvidia.com>
References: <20221202135402.756470-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202135402.756470-1-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0327.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB5977:EE_
X-MS-Office365-Filtering-Correlation-Id: 393c24d2-7900-4486-ce73-08dad482f0c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CZ1RjQsjKT1YSjwFdp49Z3RMzZQjr5X62y4BpLbLB8/gFczq7fhPjTcjQ612wOc68ddYQHxtjKaO2YTEsVzMyV1GNF8rJroIAWgN1mOI6K2UGRgGn1Q75iFqEnUGWGuEyg0sv0yEdPuBmR7uGeSwg5hGJsJsYRUqXcy8luFs6BsagLhMu64GU2W0EsvC+ersHVRzkNmFjc4lTrIFvxPRUto2ddO647t1F+qbFnj5oZi077t5pq6HlDB78J4PShuuDXPcQdwRy6VCVZkec+7rlwXjASYhBVJbNBtR21KKIaPSkHYmLrnQmJy3GVqOVmqtX3ExWaqbeM73Sml8NUHBcFxM+kCIsxb/OgUAoPmSXSLsTLqTYTycc38uqdRIkKfU/hmuV+BKyzoZtFOJ4EP8fXUlW/leIBhKfnFPrQ/rtMaa+/c1bYwP/l47JtMl6oJv09K0q6qhu3rtHW5o5AaLOi0gTrFOpP2sr5An1BkVcOAeR/yQPVptdfrh4o9unpE6Y3s2R2wR3ccaRCDmQyeJ84gOXg1ufcluB+94zwrXItwy8JG8neCFqMTxx4dy4lLkTxh+1kJG1Wr0YMkdJZKPrxrZMu+Gin9SbRcQY/aoF11KU8+a667pPhFs0X8+JgJv+rQv16cYHCPw4Qd82rpjmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199015)(26005)(6486002)(2616005)(6512007)(5660300002)(186003)(41300700001)(86362001)(66946007)(6506007)(4326008)(36756003)(2906002)(54906003)(316002)(6916009)(38100700002)(8936002)(478600001)(66476007)(8676002)(66556008)(7416002)(6666004)(4744005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S8bfP1sxzNN2S+eBbDxHsQ4IVAaHT1KYdHylEFPp30kqXwH7uRKRz2++k33U?=
 =?us-ascii?Q?vvckUzcmjSZPU3luJD5bfVVLwL9AnFxryKMlz99p722CfmgSxyYTvLhhTq+v?=
 =?us-ascii?Q?kuwFxjqvX6JQAoapNqIEhiMG+CkwaE0XdR5u/edT4ixbgWdtbxy/bacq0J5H?=
 =?us-ascii?Q?cgmqmIFXVj/AH9/r8TqBSI0yXTYKgmXdZpZi0Z3+3fnufaSwRd7RKMipTrqI?=
 =?us-ascii?Q?Q9Q8FfNPVkxb+1oeuImF2s8LJgHhVE9FLSe6KB/wX8dvypZHwxz3D8AuORG1?=
 =?us-ascii?Q?XSbAN0zEsxFj+t/aATq4E0AKY3+qraqYIdJI2alwokRlUOAICcqpnHk8HG8n?=
 =?us-ascii?Q?cl6Gaw6Jall0zaP66TUITXXGqXJYUUG8POU/XSX8YqfsST9RHfmrl2WSMrP9?=
 =?us-ascii?Q?BklHRKy7piMf05okkReYTTrGoBCzX60Oi82W89jbxzR9gUycpgAmm3Cdr6Wc?=
 =?us-ascii?Q?8j3zhXIxwWn8w1T9MMzMtV35iQqR1CyBw1RMvuCG5CvmbxsirqbyCPp/gDDt?=
 =?us-ascii?Q?vLnaHh1SLVuzDTMtiTpONKd/iUC17g3fjpD8RNClqN5VvVUY3wye3VS2HFX8?=
 =?us-ascii?Q?hsxSa8Yx7PkztDVtnyWtCZgWuOru5pMXCEtdtDhH98RAyf+Jiqrt/p8Hh2+P?=
 =?us-ascii?Q?ZNm6GU2qdczfFrN5HxFo42aRoyBFbC1F9Ed4XNmo196aiDx2TBtfyakjzzpl?=
 =?us-ascii?Q?IcNZ6lO/fOD0K0mNow+ylEFLv6pHdoIfntC8Qv/Epnrn7odCIU6NqAkEI6TC?=
 =?us-ascii?Q?ZXRpeNMt+0YupkcakWElMIDycU6GehRHufOkqVzcBuoO4cjzuoMMjWgJmePV?=
 =?us-ascii?Q?hTjU86Ae/VObmiDbAbKTWrCjj38u3WoWGyj7LXL0XMTdvbFwpMwcGI00v9wY?=
 =?us-ascii?Q?r49XWxEw+xMX1Ushabfqi1B02TrcCJEohvWdvRF4XAbPYHqZFR50H3g2THT8?=
 =?us-ascii?Q?ohUJ+9DF3piX1PN1tGdDgvCvH9oabWs91Y2S/2LII6dk7gFe+e9ivQnkQP8I?=
 =?us-ascii?Q?jj+lKgvRGxXsvJzLes6ykp/sWYGkSmL+xiTyeXcyb8KzZJgRWAl0UPxrW7Qy?=
 =?us-ascii?Q?ZY2HcI5tOVj7IZnjmog852va3LtfkJTMC2FUDc0mhyYNZwX/StpWjlApMFYk?=
 =?us-ascii?Q?RpXoRqgIUbHQkVvs73EnDkL18o29u/YoPrBkrAeu8h0YYMpOtz6Z2IbxLCa8?=
 =?us-ascii?Q?LxNeQDHg8NNssUW1akes/7MJe1tVKC0wgqGZqIIlqoGZik27Tasgt6445ky6?=
 =?us-ascii?Q?tKWYhTpvPeyKDKjG5Iz+RbenA9H4pgH3sXitwmyZO9P77SxsRiXzCur/vtaT?=
 =?us-ascii?Q?gW39I1lsTfgU/UxPGLYBsyKLWvYs7npx5Dqfwbdjp/pWSe1j5z+8vodgrB/d?=
 =?us-ascii?Q?Ny5z/Xa5nVG5ay4AnQOlPCM4f9aFiCwpXCwMIcF/LAlt/nu2L+UOwIluQS50?=
 =?us-ascii?Q?J3AZRTMGcG+aCNlF6B2Je7dhVNwod7nDWyV+E+0IVxYAjomy0CsEGkDHIAW2?=
 =?us-ascii?Q?96y9qaWMBUvQqr04MhsCAiy6djwErL4BRbOB3FGVZFLt1tiMCFIcXUSlq15/?=
 =?us-ascii?Q?jDzEXhjOHsBfW1y6W5M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 393c24d2-7900-4486-ce73-08dad482f0c1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 16:33:27.7822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UkamLsJVlZs25yhmc0h0qGOY5F8bvWhok3YszIE9tvFwk4UVkaLduvmFckLGzkQ1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5977
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 02, 2022 at 05:54:00AM -0800, Yi Liu wrote:

> Matthew Rosato (1):
>   iommufd PATCH v2 2/2] vfio/ap: validate iova during dma_unmap and
>     trigger irq disable
> 
> Yi Liu (1):
>   i915/gvt: Move gvt mapping cache initialization to
>     intel_vgpu_init_dev()

I refreshed the patches with this version

Jason
