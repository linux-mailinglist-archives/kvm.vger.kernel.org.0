Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCB453BE46
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 20:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238302AbiFBS6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 14:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238306AbiFBS6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 14:58:09 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2C32644;
        Thu,  2 Jun 2022 11:58:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQbFHayY5m3RQPNv9pMtC/VP0LYwkO4m4ifHowXTlpuTqVe1JGcIl03azEINVUN9TIec3e49AX9IwT+dUfc2hphy7gJ/c6wKrEY/X9LeLxd58s1v08CWaprPcWG9KLBGyWz0Xe6BVTPhPi8satkPilY4kE9UurTlz8sdHgJwu+YbNbm6VwiGW1OAxqCk0JB6/yInpGqRq5qP9XkAegUUfeygwosZ3hNrRfIT/rI6HOyzztWqPe7HsdjokPyKzPtdjERlVPPhDRcrenf+u/sG7OBDXFmQiDkRGA5mzmhOp60FH8cwYLWiV1Klw7rAyfhtBgooWwVbGKEIqyOl2r5Upw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0s4lwZ5cnv7/EiVHEppJEob5VgFpHYvXw3r9k78E4jc=;
 b=VhDNRjsY9Ih1E+rBzZ9J1sHL/74czv6WlEOhMa4IWr+lg+dPihuoQztMp09bfsZc1ECRIbQvcI+YHq76e8FqkLrF7qK+v7VcvBNeYbe6XUImNhHVWBfRmTSA/e83Pwo7Cac3g6N4FK0S2mOxDDj3XFU4fY2lGux1+nqdto2Nq7nPdFBraG+SMjEy7hUol72cjc/oA/SnAK0UG7NZtZHEEwiT3uvqq7OwxuO6LBj40P7lW8hOFhVUc6oDWE3JCcpGPWOes8lgOkhB7m48bnTfEdejHdEww6/usHDKKYwXh9bZ9EjBez/YOVCOUd/D3wty12Yu9hdx8olc/FM7GOd5jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0s4lwZ5cnv7/EiVHEppJEob5VgFpHYvXw3r9k78E4jc=;
 b=rPqtkDTx1Ez1TquZPph7fev15DS+8gkm25wSCUcEdJ0yr9Ph0CDHYLOePXMs8jxfaKfBVtyt0fN7e9tfWhYnJ7KmUaOTZvJNZOZHEuiJAbZUj/BMPB03xq2EYpHmzL3hZQFcCGhi5JRBnpsk1BpelU0AZ8WpqWH7MUuOYVNX+rnz218VfL0Ad0DZcEk/rtyN2WZcEzy0sOx9vWeFqCeA3SwMLkYIME1YR+cHKc2s70TQOcNuEP7B8IhSrI9ROElPH5v7uZTNRmiebHUmLUuFUQ2HHQgVolZkp6ehf0sbdz8f5QAYo/XQIcALijYKYDNkkVVhuMhBzlX0uAynyXzLDQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1930.namprd12.prod.outlook.com (2603:10b6:3:10d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.16; Thu, 2 Jun
 2022 18:58:06 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.015; Thu, 2 Jun 2022
 18:58:06 +0000
Date:   Thu, 2 Jun 2022 15:58:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 02/18] vfio/ccw: Fix FSM state if mdev probe fails
Message-ID: <20220602185805.GA3936592@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-3-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602171948.2790690-3-farman@linux.ibm.com>
X-ClientProxiedBy: BL0PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:208:91::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a6082e3-6a7c-4a0f-5b7e-08da44c9d414
X-MS-TrafficTypeDiagnostic: DM5PR12MB1930:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1930D7F1665A20B0442FC456C2DE9@DM5PR12MB1930.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1D9ZHRfLj1PU7OUnTS5K5Hu2yXA5LnhVyoLJ4bVhw9jqev6L+CojkH0fQJLcuEEVqB9bnBp4Ab349iwqqLKfY0uKPQkZxEWgdU+RhDQeUb1GTzdGemuT9j7LokhHxDKSBg9u9ffa8WcJjTgZ4Yq3lbfn+DDokV1lGF41xhyR8RvdVItWmeiyIz6jHBGGMvrmTQh58Tq9TjEYdFHSxgX3TQaDyR5b+QCp8zmPBd+hZsxbyIGXTJAvxPE5i2VBflmZcTfu5uKxafETu3/qJDxE+PUrQBhSXzc/K7vC5ph0fNj52DcK7dlGaUkrGFyf1AW510zjQYY8x1qhkmSVV1lZuMh1j8/vyWK7BZt6Ww7YFhsSNmq87KJkTRABqKokVgoS35kozAZp3cQ6MoYKrSFi1BM+4BPMhkx1SoQQnG2gf6rpNSH7OSSM/q3KkXRJIBiIbsBlTVhpCnL5ZduBDOwlE7tn18DboUz3HSFi+c6g348QQ97xzq6KtNReTV0/clD3XZyOFSeJptmErQGuoY33kGhbf/Drft4Fz9KgDjIfS4hsMhtYSX6rmBMs9FoNBc0NdBkfCmQStqfxSM5er2FAVQ8czWCx+Vr9w23xjQ9ubN/DEXVlQZ4Ekd6ZfDxv5eHL+VV/RTnEt0hcpywmahA21Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(33656002)(5660300002)(2616005)(2906002)(83380400001)(36756003)(6486002)(54906003)(1076003)(508600001)(66476007)(316002)(8676002)(66946007)(66556008)(4326008)(6506007)(6916009)(186003)(38100700002)(8936002)(6512007)(4744005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dA/R3AgAC8kUj2w0tL3ieI2iJZyBrzVF6tmxHWtZ6DWDvwtIbh2zrFOHEjAg?=
 =?us-ascii?Q?TIISbAKd5KidW2SxG1XjmxpWnWh16swfhhIJ3wlITuWFe3yrDjJObjSL6VUx?=
 =?us-ascii?Q?yr3JnjbYhAW+cOlpK4FA+GUrSW0sEYqqRaKlB6PYcEGRYwHML0T3T5DUDjua?=
 =?us-ascii?Q?PzEUV3RMCEsfx7dDEyeI+9L17OPwB0qrej+qx0bEXpwfVa5AFQhcalxF/PO6?=
 =?us-ascii?Q?EBpkTKuT+XUt5fg8DtLeTsKiGdBt+Rc39kBp6AzFq6x9J6PS40gQ1E0C+LUf?=
 =?us-ascii?Q?yUgLG9Pq1YM6jl0n+wLPEIWUI6aQdY90w7Wh90Ib3u9eirgbh7pVyAv4vc8K?=
 =?us-ascii?Q?7qOrshvZkrwTKOtvofKzhF4omLOWTnjdvOaAKzW5cnTLsrG72xVHHzfnHYwe?=
 =?us-ascii?Q?e+dsQNQntqEbpCHnvEUQQa95DxDfquY13WJ9JOgls+fyVytqK8fILAPlN1k2?=
 =?us-ascii?Q?/6CllvqcGSISI8xeQvJ6m65GmDK68dGzCtJSMxYDviUFj/kFX95IJPoXE5dc?=
 =?us-ascii?Q?ajJUvbXBFQc3t8BFS1RPJOhLf3foIsboi243tErrd8UjOK20gSyHSvpOzNGB?=
 =?us-ascii?Q?mT5PI2WL0pMDomdKD7DfAM6OE7EY1JGWuTzItUO9D8aA9nYNW3JCFru9zhPc?=
 =?us-ascii?Q?y5q/fKMoMC2fpfmnsby8vJLT0num4tipDL7xSNJnr5i/nw5wgL4sVbMfA45I?=
 =?us-ascii?Q?lAJw5jl6rpcy69f921pBlF1eVV6CDoFq5e2C1AkuHyjYzX+V9K3nNZR8zTDM?=
 =?us-ascii?Q?PSB1qDOlzdMOfuE6317uLkR8PO+xUpaBTTrai0tTkS0j2igUunORBMe8OXB4?=
 =?us-ascii?Q?mMxJbnIPQH9rbYExXaw1STUms1D9S5IxjCOmcLUIzW1UnyWfcbh/q2J63Rbt?=
 =?us-ascii?Q?D4z+fh9b5Agqaz8PnxcZLziK8mI3++aw+Ti6l0lDOtQLcAeuUMSYg+xd0ijU?=
 =?us-ascii?Q?5wk50SDMfzfUFl/fyIPMWZVB0xYUWtaEQ4wzFatUp9r8/xA2Z/B75gmZCxXh?=
 =?us-ascii?Q?SDrQX13LQlZRm8JXU83Lq2ZY+DL08CfDp/7IxgytvR49g095R6Prqruh732V?=
 =?us-ascii?Q?7J3Q8O0HvdPDi6TOCWdPcc3ax3FH9JCJDxudkCzJD+xqVpjcJSj/30m27Gsz?=
 =?us-ascii?Q?ZAhpHrs/cs/OLWsaj48PirE6E40/kZMs41FpjEX3jkYqk+dhb0/c9zGCJvQY?=
 =?us-ascii?Q?XuMsG3Dg1PvQqsdAsKZxar6iZH5izFzB5DlI9ZZNEMyQMhejLW5CH7ZPbOb5?=
 =?us-ascii?Q?JuDQ2v5Vgcvy4ZZbFSRx0sNnF8Hrc2zJuwqWmFo/PzvoxHTuN/QEjPv3AeZE?=
 =?us-ascii?Q?R4w19V1PcFd+k68oJS1Q3a61jOsHsgSRdkbODiA+X/0ij5vCdh/sN3XEmAWv?=
 =?us-ascii?Q?CpDgGtwUaoyGqWDHmEzPCbB+Ty5Uo4RQURrFXwrqji3ydN3fnJmdvCeEY5Gz?=
 =?us-ascii?Q?AcNilgSF50jdyw9xQwP5rvUIGrYgUf3jk03rts+jfDDDJdu5BEkoohofXvQJ?=
 =?us-ascii?Q?o4kz+xyv/rTs7BB0vVL70WnghVLi1gg7N4GpfT9wK39+Lj1uQQvkOehN7KDX?=
 =?us-ascii?Q?2WIP3jrnUnocv6FGJzyvNBY5/aCM0r7a7Tx1y5PKefdsNi4R0xOt/TF9FtOj?=
 =?us-ascii?Q?t7ssepxf2imwFI3vW4ZfEpQnwbKuVazBdN6VdDfo7subqakoxnRCWVPtdd8c?=
 =?us-ascii?Q?p8TSRrbr8vQJL3PcWCNq8JSUI+2tmjJDp5Q8/j87HJ9kOpzjFpEyJRRtL0p7?=
 =?us-ascii?Q?M9W1sPpVYA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a6082e3-6a7c-4a0f-5b7e-08da44c9d414
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 18:58:06.4659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bz6eHFho8Txm12sAIgsQI6cjxXVXPf/2fDd4Hh53f2fcy1S5rBfZCzdFHrwLa+ha
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1930
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 02, 2022 at 07:19:32PM +0200, Eric Farman wrote:
> The FSM is in STANDBY state when arriving in vfio_ccw_mdev_probe(),
> and this routine converts it to IDLE as part of its processing.
> The error exit sets it to IDLE (again) but clears the private->mdev
> pointer.
> 
> The FSM should of course be managing the state itself, but the
> correct thing for vfio_ccw_mdev_probe() to do would be to put
> the state back the way it found it.
> 
> The corresponding check of private->mdev in vfio_ccw_sch_io_todo()
> can be removed, since the distinction is unnecessary at this point.
> 
> Fixes: 3bf1311f351ef ("vfio/ccw: Convert to use vfio_register_emulated_iommu_dev()")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c | 2 +-
>  drivers/s390/cio/vfio_ccw_ops.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
