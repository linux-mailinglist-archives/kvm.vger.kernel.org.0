Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229CF6603F6
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 17:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbjAFQJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 11:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235725AbjAFQIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 11:08:50 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9380FE68
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 08:08:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBN5VIzCQTVzeRmTI5wXLSqtr7gDD84MQQopmfAel2G5oCfuQN0gT3e7ZEbk2P7IDIOMV3afX64kVX6wxHimiHgFEEV+/qAE6+2D1apcNR5Ij7h+7aN2vvO6dYeHORdToDgx+6pqFqdVY4zYjhUYzulHmhmvfFMuYgrzYdqBEzXobkqGA+ORN5im+waxzSyhk7OGLZcXxmOjwzcox7Dvh9RYDUzn7tFxvAIiwRfV3iezpDtZ4gpa3YL/Y7LkNZKuxs15prh0bes+iy9FLu6Wdc0Mu2w0LANtkK3YWhSCHFrc2Y9EHeLY/fO3HooPDh319sgsOMTC5YGIlPtiDbP+ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSvsatn8+sUMYf+GLet4nE5PmpJc0/upbL0qkBdGysg=;
 b=lvTyPGMB8jdB/GYXUxhtPkq7XEtPucbZWIUyvXXTN8fmGH31Q6qNYwPnki+br0ialQFDAYghI+277JjLVuJHM+blvCYLjEozztY/hyR/AhEw6voXzBn7svpqeghoMcIzsVykZDhpsmeKRwQchP1XSjENfXgjJ4mtXNgoVYhkU8vc2/Xuw0qxrreAjCWj0Oprc7ZpjYzzhmNm3pV2FOw7TixEDshH4+NpUpaY5DRZ3NS7X1E49z5udcA4MKy+0bq2SKFI2xs66XrJ3J1Vb2gMsDsXtUnCBl2G/vU39jxML+rRp/wwV3sT6Q9oGDOAjkGqnpuTxxJPzIdt3iLP+9epiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSvsatn8+sUMYf+GLet4nE5PmpJc0/upbL0qkBdGysg=;
 b=Xnctt/pVRF1BTqyDq9gAXC8x0FIA8xexsbkY0YlxAJHkfZNNA6E8R/9HMkpPCh7bUipGxVhNvARbzT+ys46/hCedpwQXDm9XbBEa4Nw8vpYWy3dr4je/wPniuZYX0WpvcEc6LC7z/hwRU966cfTTENIgjEcL1lAQemYMKsleviD1NQbnB5QeYphYlL0RFQrDvpFAcG+IkpruH2ecP6YR9i3gneIbIU9hHPU1gavY4Oqd09VbtWYE4VP8R46WzGv5jC3fbA86MQ3x3m+m7Nqmmk4qER7p6PJ6AZHcGkruZGx6ZdJB/Uyylur8OgIK9A2Jdn2sx5Iw31cNsnfYjEHqCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4438.namprd12.prod.outlook.com (2603:10b6:208:267::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 16:08:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 16:08:22 +0000
Date:   Fri, 6 Jan 2023 12:08:20 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com
Subject: Re: [RFC 05/12] kvm/vfio: Accept vfio device file from userspace
Message-ID: <Y7hHdOo3UHAcVFLp@nvidia.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-6-yi.l.liu@intel.com>
 <Y7gxC/am09Cr885J@nvidia.com>
 <6af126f0-8344-f03a-6a45-9cdd877e4bcd@intel.com>
 <Y7g2WhrDFHpPPsaH@nvidia.com>
 <17e6b31c-1149-018b-e76f-f3c82e702144@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17e6b31c-1149-018b-e76f-f3c82e702144@intel.com>
X-ClientProxiedBy: BL0PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:208:2d::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4438:EE_
X-MS-Office365-Filtering-Correlation-Id: af68c93d-81f2-4c2a-6498-08daf0003bb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AXLr56Xc2SN6yGrzB2jKnnLp1j3oOZSeXREI3lx+yKz18q3m5Ipqg8xIG27Pw4ltBBFV3jSzyldMBT3AHHkM+Vz+2cI2y2pIz3QDowjxmxbgQ31KRpFy+EDsBWBO9n7mf09XVPwI7LacDZ3MhRMynwAtMGDMHn9IHvzkOkxGUVjwr1Ijaq0HTJa+K5QP6Y1ZDZpZK0nTUmZxJS+4iawJcllK2pmsjOvz4nZGG7LB2BCputKBxeDOXjMXSxplJ454JNi/1kps9Winbktw9KrSlZTwANNOJPdNaKC9Oc3XFZwwv9IOXym2+MN7hIdb4cGlT+sHDHkz6s+rHOg/kqFbJkEBRRA/rlfUFWSxrxObQTYyymNhdF/QBcs7h3y8n9sMf2JEHlMYRr96r768tnOMXZbRXE39LxRUWf6gFAcEIKAUywfEjZVljOOYH7+l5hIOZ3roAyxKipyRQ4dEkEpwV90X9icNoRxszdvywUmctUNSX5nOw7bPZSYOJhqrzqQQ6ZirLUefR+l9puG6/L2rXtFvLjaKRF0I++tOnK/P9qaS5zJdKwiDG/iG6hTQ8Myuc5yfKhnfVg+1UdxKmrFTxX2VN3bH8Z85NhYulEVeWsSEpXDfjwCt7ixYyGSyYZuLH4kK44unWDsgnI1fLTf+4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199015)(36756003)(6916009)(4326008)(66946007)(41300700001)(66556008)(66476007)(38100700002)(478600001)(8676002)(6486002)(186003)(6512007)(86362001)(26005)(2616005)(8936002)(2906002)(6506007)(7416002)(316002)(5660300002)(4744005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gGpkPhV11AoDJ9HTGYWs0FFWP3H1KVEXjhBJa4M92a0JXR+4IpQz45/LWzLM?=
 =?us-ascii?Q?N3L3nvlFafvqWabdReE4V08XDdFV1cIMLt0xT3lZ6sm4PkembI7zdjr1kHjR?=
 =?us-ascii?Q?AByGcgfdeG8NJMi7W770P/8XdWkSiUdKzKAESjYoMmUmNcwR2PTj4uNH3e9C?=
 =?us-ascii?Q?X/JuNgnTH5Xrk7CEIbD0o0UW67xANw5G+5N1jboZZCQlL++7aYAPII3aA5CQ?=
 =?us-ascii?Q?RBAKw3jXWfjKyab+LZkXavCc1gLMQsFFvnLXUQRyg+x1iYSQ7VhwBDbNJvgk?=
 =?us-ascii?Q?EHhgJ3Psv+SLrFIzi+HiJ52ydFXkq8ARgkRoEj3bheEVjKAwklSQ/Z/GycAj?=
 =?us-ascii?Q?jgnAJ4XmUw79kt54DmkS966vgarqHxg5mv1EQEVr7DjAw7xrxAk5tcPTqtV1?=
 =?us-ascii?Q?ZkdC3LdsLYPEbXZKGiirV8hAoDvoYcs1bagyKgrF0uEt8TIS3lu1d8kwg+84?=
 =?us-ascii?Q?wozLDXioAdLJjpgASTDb8zcq+8/oyedNewH914oIZM0T7jLxBUaMD32v3raH?=
 =?us-ascii?Q?1HK9jGsV50PGX8Javbg9Ywv6W7qgmh0mdiKYJKqQA0By4QVVos2evI81ZLor?=
 =?us-ascii?Q?KQYfLGFmJcuiNG3Agn5zrEB1W+f/bT8JTfAjbdYMGRajXHBwA5qf9rP+KXkX?=
 =?us-ascii?Q?zz0PdSMED5JcIKh2PqIaKw6w7Ny+C9F9JH5Hm8/6+HM9QhSNILoXtIp2s1Cc?=
 =?us-ascii?Q?OEaLD3eoxmgHGUvXjY9r5sZ3xetBs4d46CP8+HQ2FVjCahWIqqqtoV8DkQeY?=
 =?us-ascii?Q?53y7DZ3nSz7EqWoAt57bsJGW5os8Dxs4QvnVHdGraK2iACCVXC+hK5lrBvNY?=
 =?us-ascii?Q?glXBHfCtyi1ZPsGzJ4KJjq8Ks3BN8RP1x+/0yhTA7WSVtAOIbcP5iDr4Bty1?=
 =?us-ascii?Q?RcATlXoPJi6jeOOCHVPxtUV7WCtz4/1/tYlRA2+oXBlAR/S7XZsm546p38Tl?=
 =?us-ascii?Q?hwiS5+0Ls3qicKYMHimc2FmE4EN/m15XeIo23pb7sr5W3j+dQ+9O/FVnzP8w?=
 =?us-ascii?Q?bNMkNEF4vGBQZIMI87pek8cYdjX3x8qjpTgIo7QCRroScews5Nux/UKA6Jrd?=
 =?us-ascii?Q?2sZ3CG/sR+cQIw3a2O/lebNbnlVsPDjJqqRnmKdLnoy1a5WvUtMvW3MuR3vI?=
 =?us-ascii?Q?hFkpKoQxj3SV5SxyKG3gH5xyHezAJwuhIYJFD2e6Tj2blT1yDUf1tZ8WqNiD?=
 =?us-ascii?Q?FwsH6pqTOk1d1sCjjBZTBT9sZ5+qQjTq1EwG6iDUAgMbZFCFHDvQKK6uLMEz?=
 =?us-ascii?Q?ZUifta3aK1nzBS6nMxo+Z0aW/6YpzCFibIBdhNkMJB9ZQFNk0+Pxr8KReJB0?=
 =?us-ascii?Q?yEh0E/bJo9H5MmiVrkH4gNEvGEKLEIJ7skQZy5j48KPRFlX2A9Ydjjj+XRQV?=
 =?us-ascii?Q?ST3h9B13JXvKcJ+uJSepjOW5hd/cBDeZ/f6fvy/sTlvunYexpoKsBmnoFBA0?=
 =?us-ascii?Q?XIo3MqniV/G4u7rg3m2JI/hdmQKn6RkoeTI/5zDbZLHGhreXiOiExCa8+F2f?=
 =?us-ascii?Q?oYYCA1wePMFTVu7dgerrDrNqTlY7wEDsTI3VUhH9Hv706gSqTIG2B6q1YkRE?=
 =?us-ascii?Q?ksWy2d0povWD8v5v/MvX/zsK4jzeRhy7abOX5Y2y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af68c93d-81f2-4c2a-6498-08daf0003bb1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 16:08:21.9884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /pQS5lcnqSXZ8kh1DVIPz1AC+JStjnoqHHNmclmQkyAuU4NjInLtbwq+DlwjdQMF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4438
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 06, 2023 at 11:04:42PM +0800, Yi Liu wrote:

> > This will allow the VFIO device file to close and drop the users_count
> 
> yeah. It's interesting I haven't hit real problem so far. But this does
> look to be a circular. When I ctrl+c to kill qemu, I can boot qemu again
> with the same device assigned. anyhow, let me add some prtink to check
> it. thanks for the catch.

You have to test with one of the situations that hold the kvm ref
during open, eg gvt on intel

To make it happen hack the vfio code to hold the reference at
open_device and let it go during close_device, then you should see the
problem.

Jason
