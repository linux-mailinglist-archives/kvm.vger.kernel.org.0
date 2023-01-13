Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B21A66A3F7
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 21:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjAMUST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 15:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbjAMUSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 15:18:08 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E014A69B18;
        Fri, 13 Jan 2023 12:18:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSVHNHJwSDtB0FYitro+6EglwAGzpsMnQ+GJyp6JtLGhBhRlWkRVw2j8tOX7Y/zmQba70y/+RPidJHduXTFct8VuYi/Ld8a1Dl4ISGg1cINWwl72/0yIFYg9eZ8V2+Hl5xydllLiMz5SZ2UZpi051VpQ/upi0oDYg4C4Txa/InQ0zcJbPmVatwE75A2N09zoMhOF+HBcNuR6adRpuPpb5RRQ9dOtu8FsWlNXmY5Kwgb93PujvkY87JIK+ytI40gSZ3QLq2q5gTEr5dKtnpvoqOxFhgM5xrJfBgj3CQ9puKeBKtJZQIY/ziIEXSEBbRiysfqy//DMBte2mraiEvBxhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGSVvLsmKeKHUTfqcEowAbOhOQ6JEBQGcyGI4Eexqx0=;
 b=Io4Srk98M3As99GOsHx4u0sdqgM4rJnhXndkBQV3gEzBIUYSB5ziqilVR4o5/Qv+EgClmXZlxyfwWZWJ+s5Wdm7S166Z0WNewb7+ojQ139H7PwbnVEMFlZoV6yYnR73/zL4bTjySq/hUfbryCrhggNyWcyBN6i1/SymQjL384C15xdwGSBshhobrSmLskI8tYlF46EIrTt66Khz0UOEy/mFQTLOS04UdsvvXaIG8jcWExUNqqM53+Bu7GNy++lTkyF/HrI6Io7JexDogrogcyECf9x3tM+458dJb0dKY5Px2Pat/+tXQn9ldR95xbNcdl6gevBThQVdmLHMwqZZZBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGSVvLsmKeKHUTfqcEowAbOhOQ6JEBQGcyGI4Eexqx0=;
 b=Hw32Yie2EFRWwJ/GLPkJ9YaX7S8p2QqyvZzP51mrEoKOEi30MuBcqZ8xXNh5Qk0WJWvBWCwgYbLLGTDy6w2uUjIxJPEjpWq0Cog7I/FDwuzDX1On2G1TarxbNofBKsx6S/c4xpHm4LrfZ7Ajt+Robs2cpebASL+7l9iGNK11DrfPcKFOjf1HuglSeIj0CFTNhxwdu/NQ/WxRyGmQ1KIL8dprAF52WB8HS4mzydBMpZJJnenIDBe49NpOCaZWUrjZyv/YfRSri5Mv349tUA/Pa5uu3t28pLcdPi2uCbRzdU/Pupxjl9yD1Ot9VB9cJPj833opr/CaufIoR9StQyYBcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN6PR12MB8565.namprd12.prod.outlook.com (2603:10b6:208:47d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 20:18:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Fri, 13 Jan 2023
 20:18:01 +0000
Date:   Fri, 13 Jan 2023 16:18:00 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, pbonzini@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, seanjc@google.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfio: fix potential deadlock on vfio group lock
Message-ID: <Y8G8eNhmjc1QK4tC@nvidia.com>
References: <20230113171132.86057-1-mjrosato@linux.ibm.com>
 <Y8GoiCBQNiAuVcNw@nvidia.com>
 <e7ddd054-72dc-81c0-609a-59e98e2f835c@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7ddd054-72dc-81c0-609a-59e98e2f835c@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0091.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN6PR12MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: 694cf65f-d010-422a-0975-08daf5a344d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l+zIr7/y7UmBJmik0tt3SK8LIlIqzNrTVQtT8LEW+lheJZLXB13s3AegtFI0L+bE5kbSrTbiuPCGGhoC69/wE3B2sOkcb+e1gqzcBh7S7UgQ5d4ptVWUmP8rfyKCJSL2mbvOSOhUfkdBxsJM41RVf6Eer8lZi9qeVbe0xTEnJNhfMhF8C8OA+5wJ0QEbmOvLw+1v7Hxfl03OmDuSQyEldRnja5GR5igz/IVIOuQO9Ssm8bswSrpbKNW300qezyfhHvcnWFf7eMDToZ016ygkLzZVjKJ+xugMyO6NvUjudppTAB0E0CjChmHVp7lgmNUuaSQ8Fsk4bAttt3bOmro/FIBTai7Rfqr3DrP5uaLJ7cet5B+lDKoYgyi9Hjq83em4/k0T06jk2b3g+D/v+Vs+/2bqDbLrfAFOaxbiC+5GZURN0JipwMTN7MxiGP18teA11mqjU/kyQROcVxdhTN8DtkM00+ABYXxDx5U+cZlDp+hGi/10iVyKMdi3Ve5CzCOcaI5igTpmQcPCXBDinCoL6LiK+m0Ool8pUZtjZqr2IJqYP+qiwMPMx07zQw/nCyp2NHeDTQd/zKS1ZfPSMpCk+tfCNKk782avWhlg+vYi1rwMKlpA6THbdcd7VOWzdd+Aa7S4VNjkvSyUVbdWAK6ZRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(66556008)(41300700001)(36756003)(8676002)(2616005)(66946007)(316002)(6916009)(66476007)(86362001)(38100700002)(8936002)(83380400001)(4326008)(5660300002)(4744005)(7416002)(2906002)(6506007)(6486002)(186003)(478600001)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GG5hS+BRWuWoFZEF6y7YvyMjNk7YIA2Sv+w1MA3XJSV9jN26WXGLjCdT/56B?=
 =?us-ascii?Q?ZjbpSSCDHs+6fkhf1tTptD2n+kDQ6tJiFj1bNpbRMQXy/KtlLoQ8HkiRBXLw?=
 =?us-ascii?Q?9qlrcquAc+xHWDiGiS1VyTP5yhrntsFNPLKau2COzfjRhVonD/xPj6VJxbKD?=
 =?us-ascii?Q?o+F+I/+tBl0MqtpQJ8/N3WVpjjk3Pthl1IYf6U/33HDqK604Docm76PvYpfU?=
 =?us-ascii?Q?MdDjT9mtPJR5DQ2cwituOAQuct5XGbHMoMR5BGbGqKthFjM0rHuOT8hdi9kU?=
 =?us-ascii?Q?t34y8+VCc0oDZpbVB+aczYnruCaC1WGDvJzwBKfbUe2EO98xS8WKFBZ4VxtD?=
 =?us-ascii?Q?I/87ONw04Z/EJ6BjH138w78M7w5GyZpeKs41N8AfneK+oOyNcaYc3vq2EQY3?=
 =?us-ascii?Q?pSQxkTAje3QtxdTClZi2GaerpzDR1iMPSgPqzZyqEkMvv4SjQrH47piaNmJ0?=
 =?us-ascii?Q?mkz96znEVo1W22UUW/iBppeSR1W7tlHFDyoSmkUxHwbnYYWvqBAMRx3JpvJP?=
 =?us-ascii?Q?NTg/fqg8nbjiHQ3Hq99d6OzB5A0LLYaDqJOy7o2eZBbNqjmXQZ2hy6rLsWe+?=
 =?us-ascii?Q?xftOQv4ZDiDcuz74i998kr2xdJdh0NOsqpGOEcEhUJtluvNoZIeN3WRXhyhk?=
 =?us-ascii?Q?Bihh+2z90/rcU2AZLalYaz4gDy5OydKLFNphKn4n+gdz13LFbEKoOWOQqdNI?=
 =?us-ascii?Q?IKpGA9H75KLhIxQDFePySxOBvkhOkx2EjI7JBpKMpAifbFoUpO7DBaH0sBx4?=
 =?us-ascii?Q?fT7XEdCx6beWLU5wFLydJtHSSbgZ0g8drBlgyVmrHxq1oYN5d0S3JC0NUkKj?=
 =?us-ascii?Q?bW2b7y6NRcrjuXr0LpfJ46zgom1KeH7+ZsTCyOXPsYosYj6BPfGKSMEZ4F+j?=
 =?us-ascii?Q?D+X+7+McDoV34oO/iVrdEQty9J4aqHn2vXnMN0XvzJILXd9I8b3IdTys3lbs?=
 =?us-ascii?Q?DkIE45Zuh0/+dTIgxWseWEXbIcqiY0dL8FvVQuZERd91L18JZQAXGoet+KiN?=
 =?us-ascii?Q?AjbwBfPB7c6gv3uszxDZAJLbqmtm7S1uhGryX/mj/9EBaRgdVUtgpR2E2tRM?=
 =?us-ascii?Q?ko5idHu9C3Qoq5KBerX4dHytzY69QwoApQyxVy6o47nYKlod1Qn3h1gQ3ohH?=
 =?us-ascii?Q?ihPm7PVSMQgHTl+4s0LrtD2DDuBO1t7lTUOSmEcStTGMwifCPwV3SKqKseS6?=
 =?us-ascii?Q?CfSVJKvdcRhkQ6sK9Nf2JDURGo0JkuHzf+mtlV6+rjPfEsQVQlAZe8I+gTYq?=
 =?us-ascii?Q?TrNmsak3jeJ9BNZcse5QLlU29J9ON9J70GM5SNshydMlaeiiSMOxIaUvhN32?=
 =?us-ascii?Q?c/SxBtiKaCjE+zUG+SSQD/yz7xvvZx0hHXbono3YHOKDnN6dYlv4Hv8meflj?=
 =?us-ascii?Q?2aFpVtIIgUK/VYK7af1HlpNNkjGLSurt+jaV5Yy7siYm1vW5Bmz3IpfawzA+?=
 =?us-ascii?Q?928UEb7SfJaxLDXvgnsKJ5fHJWpp19uXbWFzj6t/+sACSb/BXsz/OoIq40mI?=
 =?us-ascii?Q?O6PSolnLfViKT1aHEgECJFEEnCsgq8frrZKbx7mVHJO8mUptcfwwY3Gvn3u4?=
 =?us-ascii?Q?zxtjT3ehuiQrzv5j+Sg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 694cf65f-d010-422a-0975-08daf5a344d7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 20:18:01.1638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7C5pYTSSlIKmWMkhAc7hzcPMZ0EShYmjElBu5ltaAOf/c4gBb1lHDEbhEeJKosIt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8565
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 13, 2023 at 03:09:01PM -0500, Matthew Rosato wrote:

> > This still doesn't seem right, another thread could have incr'd the
> > open_count already 
> > 
> > This has to be done at the moment open_count is decremented to zero,
> > while still under the original lock.
> 
> Hmm..  Fair.  Well, we can go back to clearing of device->kvm in
> vfio_device_last_close but the group lock is held then so we can't
> immediately do the kvm_put at that time -- unless we go back to the
> notion of stacking the kvm_put on a workqueue, but now from vfio.
> If we do that, I think we also have to scrap the idea of putting the
> kvm_put_kvm function pointer into device->put_kvm too (or otherwise
> stash it along with the kvm value to be picked up by the scheduled
> work).

Well, you have to keep the same sort of design, the
vfio_device_last_close() has to put the kvm on the stack until the
group lock is unlocked.

It is messy due to how the functions are nested, but not hard.

Jason
