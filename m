Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD834CB338
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 01:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiCCAGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 19:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiCCAGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 19:06:18 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2068.outbound.protection.outlook.com [40.107.100.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0179D1FCC3;
        Wed,  2 Mar 2022 16:05:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGdc+KwxNrp0u/c0L36sHGogoY7qa12+QDwnHxT8seYwVYKXTWe2g9xfykc4iaCDW3fjdiPC0vDGs3cq7TVX4U3r9J583sxk8aMAG5gWNwOraqajPrXhGbfy3V7umkvUen9eHE0dEVMbVS6Ef6ocXVPIxyPxCduVlIcLkrdgYWmxjU0X5X6PUYwlHIVPg3+f2Ss5Q6VMKmUF+D2Os7qhEUEh0nLSf+GvnUa55Q9saURKAC1FTeArCJumE2qQ3QOgqy0fV+oLkMwtjG70mf8GiSRFXAt+KpyHnHRxOLjAudbpvS6mt5nCyGfPnU3b4LNqhht3pVIGl9A3Wzty6hmVuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3pOTCSv/0xG+8W9WNzd09eHKXeYodm0lVdd0OdR1enA=;
 b=ecc8VTj9H5+7lWU6ARXgK9cOa/Ozf1d+msEyMMKHO6KCAz9FIrtyefyCVUcpVIFCkpNYtoqLop0QXTXIxZapzI8K4BMYaCKS58JIfbjOl+RU4uQRwdDJ51jEnvrOgPDnAC20mFqfDXqS40MnRZaR+k6/tbIXzv3K3240qw6Jttn7pFmjkZ/qYz9yF1ImHHykW99kFjDgbK5AYPjcl4+LZuygpbPQiwZrKyCnV9N1UwC0M/3xenEL1OWTbBfLOT75adKM4xo6i59fcnimIN5+qnh5YijmX8gGv5lOCT2GvpPKI+aBLRDe/MUvKX+biAAy451XVyFFmkm1C7aN1qMAZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pOTCSv/0xG+8W9WNzd09eHKXeYodm0lVdd0OdR1enA=;
 b=JWHi/NV5N0jZwKpYNBcT1QaT/nvSYvGl8BNs7nRlxOVF4giLDLg7kiszFi1Y6EtTD1RA5Mbnk4XHPFm1gfgXgdjrW5y5EejHYNG5piQZLrg6AI6nh2J0UM2COakVmjgslOblVvKSHVY0JIFwazsyOPsgqR9/3pEpv0WnYMHulSbHjfSMZMbK3MbVJMa4r5guzHBZnTUnX+WrlPCGalxr7iz5jFHRf3R3PS8oXSjsTdiUAfdCsybu/ZguX0ckZk3fStuexkp3CxUn4kMtmCgypjcuZGryIf0uAb4DdzBzfW/ZrKny8g7wDWzhuWIxIuxWKekE1eY49Nf0nz7vgwvpAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5801.namprd12.prod.outlook.com (2603:10b6:208:391::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 00:05:31 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5038.015; Thu, 3 Mar 2022
 00:05:30 +0000
Date:   Wed, 2 Mar 2022 20:05:28 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        cohuck@redhat.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        linuxarm@huawei.com, liulongfang@huawei.com,
        prime.zeng@hisilicon.com, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH v7 07/10] vfio: Extend the device migration protocol with
 PRE_COPY
Message-ID: <20220303000528.GW219866@nvidia.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
 <20220302172903.1995-8-shameerali.kolothum.thodi@huawei.com>
 <20220302133159.3c803f56.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302133159.3c803f56.alex.williamson@redhat.com>
X-ClientProxiedBy: YT1PR01CA0147.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d53a402d-d301-41ef-5813-08d9fca9879d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5801:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB580119F331AB6DA10928E726C2049@BL1PR12MB5801.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zYI4JKQGeFVQM/GT53uVuOsWfIQYVeJzmdR9r4Dggdg16MJWYz70ZHEjpTZj/hC5cE3kNdfEp3KY7+St7RW2nFsRD5XFHXYGHJsO+Cg/tb961PFJRukw86D/x40HJkh6xHOdJH4pB54wUy4i06npteU2SxUe4Y5PIJaPA/098wuzhOdnvI3CESDa+wNlXX2viGTIO096XzFuraXqiVkBKe6BT0Llp1q79qrEVhpXFTUI07TDB5m2oWDMZ3CGv4ttB7p78bwrICjSwkAlkMRNgUi3kMelJIcMhFlOuor12Df9xKN8q9DQ81z6ANPXh8sCTsSfCwhUCWl3EVIlqLyRy9qx+Jg9md52l/ga/Dc4NRpn8Sbm+qvw8+cswfYqPKYUJTWA7kJmmsJ+2kE13N5pDPg+VioQy8lU2B07eLWsgfpTvnSytXCDlmjdZEuXv+0lhKAAheS2cFYS2ZQ84xV3k7rZxHTi25RzaqXN/o0F3cNLkWLLwAmKC6A7Hr0p5mkOzZBUb5AJhJEcnuyqKA7XR/5EVYBhL6pLkkMp5hIc61AGJSRO9EogbabetK1LlqdAK3lSjBWtWvIs7Y7c9tLQJXRm8+TvPFd51haiASFI8fTgvH0XjMjtH66AUwiWKs8ileZVRjYNDIdKlgUzIhgRdPrq7BtTNP/Do2TI6oRF/rPKivVU8+Nry4Kp9SexU9klfq7CKjYfCqkegD9DHR99bA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(2616005)(36756003)(8936002)(6512007)(1076003)(316002)(66556008)(8676002)(6506007)(2906002)(66946007)(7416002)(5660300002)(66476007)(4326008)(508600001)(38100700002)(86362001)(33656002)(6916009)(83380400001)(6486002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hAG2fBVcMfHYDlEC6p7YnJlG358hTwN9UE3dkPDgUn4eYNSEQ+JuYFGJsONL?=
 =?us-ascii?Q?fn1DVvZNa/T7L7xDpKFboyWvMkBPCTudUZDfOBW6+css84GQAwYJg75xsxfF?=
 =?us-ascii?Q?1D9I74qIUTqRoDLJvS3+tf3Q9ZUM3KBLIB06U3IZgTSIUIyNwOs+9ve9qQ/G?=
 =?us-ascii?Q?SseroG2J+aldjkjrDb1baXcm9NgevjgUoQDZXow3zh9S0UljjTILugQWwotL?=
 =?us-ascii?Q?WZgALtF7xjF2oW3YehkfMq5eJ409iYfJKSrIdcFvzmklbXh46TJHrUYbARjz?=
 =?us-ascii?Q?xtsPPFka4MO/PIPitN0QE4k9kjGLV77GfC3HK87soMdHL18vMt1pCvENQs59?=
 =?us-ascii?Q?boDebIIsSBpSRk08gq7I+y7LWzKK5+WNsxTanKV8OcUxwiD/l4cpwjBhaOfX?=
 =?us-ascii?Q?THosKA+7Zmw2Cb6XWju8SgK1U/1PTj/OfjeyLVzWWCbs6YPWdbODVM6H2RCv?=
 =?us-ascii?Q?KXrQF2fZmEOi2EaVOEYrwzTOYUY0JRTTa/t1xobWWo6y1I+lWZZCLqi869I8?=
 =?us-ascii?Q?UTxCqV4MmwuIlYm9EutG1WPZglHTgyoUbqOGitw8miy/JYS58hz1iazgiUog?=
 =?us-ascii?Q?PwoqGqDs5+jpAPT4FtJ8CsD2ybij44MaP77KG2sY1PDKdVhuYZntkfyIcnrJ?=
 =?us-ascii?Q?XNqBkK71GA00u94ipf6m+qzXPMUwPQ11w+7m3yeX2B5TarWt8lbGB/9qg87E?=
 =?us-ascii?Q?DBz+vAIYFtp2ASuXvvxihTUY91UJgWoKH9Ydy+TIDRslZYzPVVfMwVkvXD7k?=
 =?us-ascii?Q?5K/bySYFlWYuBqP7BJT+YznyRHu0PvBValyS9CK/N8LdTqHGOWBZKIlcMzhn?=
 =?us-ascii?Q?fSoTJKJTE7+mNX+f5pdOQpQs4jD2A+olhadvIlS7bFaJpK6CwdwMcZGTMeXA?=
 =?us-ascii?Q?SZayUmbDqBq2yoSK3oD3t1RJZGuFC80VMAZVIQ8yW/flT0AupDAtgUXeMoO0?=
 =?us-ascii?Q?rUmKs4on83mB1ZdqeF7HltocwakbSxXH0VXhuqXG6bA+IeJczxMmxSMrRsac?=
 =?us-ascii?Q?Oc0KisByYGa77GVQaV+BhAiNd1mmz/il2ppBqDjZH+emc4tbtFaFpm5U+QOz?=
 =?us-ascii?Q?0cSQBgLz4eT+2OIc60Q+sOWydAVEYnDhDJ0TjLqUk9IJQ0BzqrBRxp6njUT1?=
 =?us-ascii?Q?QQIjZzF9nXbW3Nx3avNfAgdXuU/tDsAazJtWKcWOnG6n50yHkTRc7Z4jaInF?=
 =?us-ascii?Q?Z1BkFRagozIlX26VfGGS931dSP6EUi2o+iFBpEyijf/F3uU52xfU7yjgmsh7?=
 =?us-ascii?Q?eQC3xmr+Gt/txGvyfU1mGn1cqaxlBOvRv1z4DTGZ3XgaJfSbTMddJm+RQKr/?=
 =?us-ascii?Q?F6sgD7/uAVFsZOTwkeyVcUZ4wDkTJS80+iufyE3Kz9A2TjW6zAdjqXGrOwXT?=
 =?us-ascii?Q?q0mvM/iSHMCgbd14JR7KIXZ/KCnmukcHmCg/t5iKQjyV6BFc2U40j93JgrIS?=
 =?us-ascii?Q?+AgUcBXfcielXRHe/29fvs6h+BdekJh3UYMV9glxJU5h1fqAEv2B/QHwGH6W?=
 =?us-ascii?Q?okkUlDTY1Vy3TirRFo4ay3T+4c1XiFD5KE3QWpHaNNyvJPaoyuDG1aFevQZK?=
 =?us-ascii?Q?qPltSDlrWeZCvS5Kikw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d53a402d-d301-41ef-5813-08d9fca9879d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 00:05:30.7667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BP1kRU+X3GRxNUFstlNxvZC0D9FftqmeRPVhzl9B/73awvSnMo/2vcaaO95YvVsJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5801
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022 at 01:31:59PM -0700, Alex Williamson wrote:
> > + * initial_bytes reflects the estimated remaining size of any initial mandatory
> > + * precopy data transfer. When initial_bytes returns as zero then the initial
> > + * phase of the precopy data is completed. Generally initial_bytes should start
> > + * out as approximately the entire device state.
> 
> What is "mandatory" intended to mean here?  The user isn't required to
> collect any data from the device in the PRE_COPY states.

If the data is split into initial,dirty,trailer then mandatory means
that first chunk.

> "The vfio_precopy_info data structure returned by this ioctl provides
>  estimates of data available from the device during the PRE_COPY states.
>  This estimate is split into two categories, initial_bytes and
>  dirty_bytes.
> 
>  The initial_bytes field indicates the amount of static data available
>  from the device.  This field should have a non-zero initial value and
>  decrease as migration data is read from the device.

static isn't great either, how about just say 'minimum data available'

>  Userspace may use the combination of these fields to estimate the
>  potential data size available during the PRE_COPY phases, as well as
>  trends relative to the rate the device is dirtying it's internal
>  state, but these fields are not required to have any bearing relative
>  to the data size available during the STOP_COPY phase."

That last is too strong. I would just drop starting at but.

The message to communicate is the device should allow dirty_bytes to
reach 0 during the PRE_COPY phases if everything is is idle. Which
tells alot about how to calculate it.

It is all better otherwise

> > + * Drivers should attempt to return estimates so that initial_bytes +
> > + * dirty_bytes matches the amount of data an immediate transition to STOP_COPY
> > + * will require to be streamed.
>
> I think previous discussions have proven this false, we expect trailing
> data that is only available in STOP_COPY, we cannot bound the size of
> that data, and dirty_bytes is not intended to expose data that cannot
> be retrieved during the PRE_COPY phases.  Thanks,

It was written assuming the stop_copy trailer is small.

Thanks,
Jason
