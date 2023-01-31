Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC414683115
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 16:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbjAaPPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 10:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbjAaPPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 10:15:06 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC151568AB;
        Tue, 31 Jan 2023 07:13:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=InNZKNRSHwaDRXcuzuOeKry//D0BGMct6fRYFvru6unM/sjO76J5JcEbHn72QfxO9pU/wn+x6scac66UbTdu53b2rGlUgtSezcU0GzceWb6V94kmcBUT5il0mskJXrcykWbX5pMOx05SWPoqeR9fM3mULUDUdEoDylk4W91cn4465r5xJvCiSwqaHz9GreGbQ+ASTkj1YZ3+3cLE8RBHG+HOQchO5Avssj0XjrbQ6Ky5lNlrwXpallL7tWg6T0pJP1uv8lVNCvwE2gEoSXyJrxGxDiwP7ps1rPx40HoA+MY0xjp5/KAbhU6APKf5H6zuvcZDJKSEVMN3iOCZuVub/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c1kn6M4f9dnAKyIwaIULQJ8eNVckQsFmAUZYdRlkEeA=;
 b=GW3LfjhJ0gLfAshC09om4zhL4G4GHnZTu3Cv9HmdAa/+vQoLtm+Y0NamhQprQNQKRaDlLtAaHqJpjTb4tzWkpVUG4VWiMbFNpl6NAW1OQ/t3NFONI5WBfrw9BXJNJzba8+hm6uQGU6IxK3hOUEBitpI8z+AOQFg8DINg7Kd+cD1KyIq+b9bGLPGCVV6Hi43efAX10yiIc++GYW4CnuT8MzpYod17QXpZTToHIFxVeTk9yVPvcfLKqjrGk8KwhfwzEZ5o2iV4UZfXgYArBMdDaPcPfTmsRmrhzkIzTLVFfKGrckI82mnYQ7TLyH8gCBKeVIv/vzuGLPjOr2gqZO/AGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1kn6M4f9dnAKyIwaIULQJ8eNVckQsFmAUZYdRlkEeA=;
 b=HC+QaPo/QXVFdzG/YEvYH91kPCpqkPqLzqEJ4RzTSc/KBfuQW2K0MncEa9XY/WLHmrWx73e3f/dt2vnNvX2cVCjZzk49nlkpykEOUgZrhOWzvF6odEI08uyHvHZ2Jz/Ys8zqWB20PBG3rrxJdbkVjES171PnppkqqgbjnlzmOvspCifW5RFEOy4992BjjN+TrN3WtZGE/Ysepzol5vbdR5QXjKc9Widad1fqr//JTKi3vN0uLvmxRrIIr3R3NDzfppQnnS0rN6CudytPmabbLs3N/BmmCMaXiDgBjT+F5yXnhUgqP02Z5uX1eI9yog02OcPEG7O0U48YXHbELkNDmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6089.namprd12.prod.outlook.com (2603:10b6:208:3ef::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 15:12:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 15:12:50 +0000
Date:   Tue, 31 Jan 2023 11:12:47 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        pbonzini@redhat.com, kevin.tian@intel.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, jjherne@linux.ibm.com,
        pasic@linux.ibm.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        seanjc@google.com, linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm/vfio: Fix potential deadlock on vfio group_lock
Message-ID: <Y9kv70l4rES+9mg+@nvidia.com>
References: <20230120150528.471752-1-yi.l.liu@intel.com>
 <67ec09bf-cb24-34e3-6ec4-1ae87b0738bd@linux.ibm.com>
 <Y9km+xezgD4ovjDX@nvidia.com>
 <b0ed98f6-3586-3151-47e7-9ec86d6c716d@linux.ibm.com>
 <Y9kqNnJ5ayCQSW9z@nvidia.com>
 <03ff0663-da37-8907-53ec-15234fd7dcad@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03ff0663-da37-8907-53ec-15234fd7dcad@linux.ibm.com>
X-ClientProxiedBy: SJ0PR05CA0129.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6089:EE_
X-MS-Office365-Filtering-Correlation-Id: dac2cb6b-6b45-492a-167e-08db039d9e76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GbnFBdboj9N4xhgWUgI3x8gAXzoFog1dLElvPsrDXlVnRsCoIZnrp1baJhUEGufRQpOUK0cWX0O8Y6xvBmlBPhGYoOEmdScK29dGvUjGMqrwT91s9FtXsnWLbiYRNAKfQEFIT0vpUIChNaRP4H0MR2iSwc5CxpxMvIoQeYKuyZAMWezAubZUs0TTVxWlf3GuvTW26CEmOhLlv7nsPDNKbshO1KULkir4UX27qE30euwWjLopVE4SkCl8wc/qiTqnRKt9MSEMoQas9eB//+/QFuXFDKYSvfVDkPkdV94IkeIJaAptoUwynKwQCj/i7qybSVGv8MgsLngrS8MKOJuAunRAIc8sYOqwBIrSw12JEw3NrnOvI1vX5Xt7/2sicnnqniWq/HYwWwStS30Kp+mahHnBC+4aZCSqx1Xuf/Naavm8g6JologMmFKpXLCG5Lf2499r5Zro5kyyGQHnfAE7lB/hUZIOg0gQVGMXBYV7yTF3eDymgUXTOyC3gPaU9JDHPiblCSEmuO05a9TxAZXM5wiwp/8xWzTEL+zzyYwF6UY08qojMP/arhz7vGUrDuExkvL53zYYDVTADkzhfRWbMZLSsNwnrKIeH3H2OL2eBb/ylgQX2yo12pCuK5V36J+DbNJH6cZf4Gn9mgpL07YGeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(39860400002)(376002)(366004)(451199018)(2906002)(5660300002)(86362001)(7416002)(83380400001)(8936002)(41300700001)(36756003)(26005)(478600001)(6512007)(186003)(6666004)(53546011)(6506007)(6486002)(54906003)(2616005)(4326008)(66476007)(66946007)(6916009)(66556008)(316002)(38100700002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5OEEPUBoIV5KR/m/fSiLxtUio/VhAOajZSwtx8a+KpThLab5cvobm0fL+cd6?=
 =?us-ascii?Q?p2BcUiESWNv6QKyCLpO89qfR5cx6CdmvBgo3M68GblvThxkuAiiKiOiYjF5h?=
 =?us-ascii?Q?oLmA0SSOk1h7YoV6oSpGPn6/1kYapcGJImqVikfiEPg/eU8hXf29qFSHTAcT?=
 =?us-ascii?Q?fg506myM5rMDG3zqwZoUOjXZLICvw84MOqDMpRMAvaHM3WKvcYpE2X1sDkTI?=
 =?us-ascii?Q?cBccbF3Qu3YMVWtSkCPbNWf6MazLKutG1nu1rQgYAK1Xc9/nh409xXFuWMG1?=
 =?us-ascii?Q?bM3TJb7fCAIPTtiZSAOd7/lFyv1ZKZlqFHtUOySblvGIx8HYe6UItzqGIVQc?=
 =?us-ascii?Q?skg3cOgWmXHV75mZLPjmqtVeT6qG4u1BeGWIRSF9VM7vHO77c5SEk/rwvEoO?=
 =?us-ascii?Q?3dQfxy+pAFR53iybsvdmrYVl91sq92s0iXFtd5X3yBMUz+fraPNiJIJ0ZEEn?=
 =?us-ascii?Q?i9hXH0DMiiviyLCo5Roz9pgu0Ca4GjiXG9FekZxxTiJanxmNobWX3V8IKcTX?=
 =?us-ascii?Q?PHw9d2KepxPBDP/x2jRe4OyA3UcZrjzRTUzW6BiymekDZ0E0fpG/sg+k/YT7?=
 =?us-ascii?Q?qJgTzNCefHb+oEnOzgLjgY4kie1VyDcl3ctS24EP+ds2sLw8GnvrIm61h1yy?=
 =?us-ascii?Q?6eMX6glYp2N3GhJaJwHxHD8haB0ljQ0iuGDAOCdTlfp9LtPFqIvqXnBcUxGH?=
 =?us-ascii?Q?YB4U5VD3ooNaVsaIruEeJaHkvX8R4J+T4zQdWWY9EAEZTIt815RxhoPF8F8C?=
 =?us-ascii?Q?fstp8F/fSwQSk5qqNuGbb1UO1TuHhOsEyeQO4ul7vZ5Hf99SQLuPwOQvDrbY?=
 =?us-ascii?Q?EzbZxNTOpXulyWaAmyl/NGMnAGo3+3rSENRI1IRiZNIdDK9qei5ZwbkHRUi1?=
 =?us-ascii?Q?p/rCkDDdJ2lZsZ4pDc2lrDdZPsShgsGshAXkUehFKQyACvgWFEfziFzH/LRp?=
 =?us-ascii?Q?6KrujjbwOOjuYzsJ3V25DCC0ixvV6A5mvgJmMCPB4AdRnN4l8PEsN8Qi58Tm?=
 =?us-ascii?Q?WLRi1Osn6WmNHj9DjeR+k3+W177Ft0CejBz0NhaN5ARBpWt6QLbh6qZ118+u?=
 =?us-ascii?Q?tKZgALBp/2avHqOIySCTuN9tpA2XCkNM6cP7Pc6ejqs3xsYRidx4/gnWx1DW?=
 =?us-ascii?Q?/G+n//XmNOrnBpMMfAZHBQoSzQH2MjjnMHiv6Sd6DygU6N6HqNKPw0iCyrgJ?=
 =?us-ascii?Q?h1f47UtrEAskOpn8djBM6xYF5hRQKR2MJXn0tdxl+2C8QSmHL+gTOXyIGNDR?=
 =?us-ascii?Q?y8frpdrNHLHu+7O6YPOHmYzbOIEaV0MPVYGkew6jCbaJppY21q3tfIbRPSre?=
 =?us-ascii?Q?2MkPOhDJCZtttmpGGFu1+Li8A1X0t1v5cytFe0fbPZ8Mu6yMegGZDVhm6Q/i?=
 =?us-ascii?Q?IfwO4mnwoBxTiDY3GUNzID9gNF0hr36F7PRO4GQWmHdroCmWR8k0BsKjN+1t?=
 =?us-ascii?Q?go5LVZ8bQCHrse4rTxnM/RSus6MClN4JhtQRSuHJSeJtQ/hHoPqN5huF9uQk?=
 =?us-ascii?Q?gdfuXSPdOuPjRk+kdZ8V/WJ8031RQRRbuKRwrzIBqvFcQVanCbmcWCPsUbol?=
 =?us-ascii?Q?n4Se+hDBVgrugqmm7w4K8NYqsdYw/iLlOZqXktDB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dac2cb6b-6b45-492a-167e-08db039d9e76
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 15:12:50.8219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q/D+IbDMlh6+AYJxwzbu1l9+r4UDzT+LiJhMVAdjtrgCwTkerS+VDi3NHYeMaujy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6089
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 10:00:14AM -0500, Matthew Rosato wrote:
> On 1/31/23 9:48 AM, Jason Gunthorpe wrote:
> > On Tue, Jan 31, 2023 at 09:46:18AM -0500, Anthony Krowiak wrote:
> > 
> >>> Maybe you should split that lock and have a dedicated apcb lock?
> >>
> >> I don't think that would suffice for taking the vCPUs out of SIE.
> > 
> > Then I think we have to keep this patch and also do Matthew's patch to
> > keep kvm refs inside vfio as well.
> > 
> 
> I don't think keeping kvm refs inside vfio solves this issue though
> -- Even if we handle the kvm_put_kvm asynchronously within vfio as
> previously proposed, kvm_vfio_release will eventually get called and
> it gets called with the kvm->lock already held, then proceeds to
> call vfio_file_set_kvm which gets the group->lock.  That order
> conflicts with the hierarchy used by the driver during open_device
> of vfio->group_lock ... kvm->lock.

The group lock is held by vfio_file_set_kvm() only because we don't
have a refcount and we have to hold it across the open call to keep
the pointer alive.

With proper refcounting you'd split this to a spinlock and hold it
only while obtaining the get ref for the open thread.

Jason
