Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F400797FC6
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 02:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239292AbjIHAeu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 20:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238111AbjIHAet (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 20:34:49 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EFC1BD3;
        Thu,  7 Sep 2023 17:34:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7Q4mPCEeQc+ldb2NieTtBrZn/lL2CSRQBCjtwfqJBr1FgqNftoIAkqfi3bPeQ0GkoqEwa9kUVuwJmd6QVz3Ofrzr9pC9jxGGRjSfVCUyZWZMoSMPt/LuDQytns0zReudEb1mxCYFHPean0xqkSW5KxH8a93NciMrmwrnNPO9xKhtOEpqwCTyJWNv9bz85INw34n5btRDk6PGdhsfVa6nMYi1a33x2l1S3pqX7zzVE1vJ+VuDdPNMZozaxr7Ga469ZB5IquSRFPvxRBPXUbnsooan4pF0KUkQLAu035AAOyNLJPqt7Ssw+I90iSiB0sBRo8QgGmn4RIaFJ0NjzTKwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kusBjr/9qnlRD0tynN+1+FwFnJbt01tPhHNfv0xExA=;
 b=G4cEIlPjL48WHeXRqzFQX776u1b9jld/SAWR0+8GTL9ZCU+kvc8xb3bU3Q40+rVh1hWZkYMkvpaLGhNVCWhdu5kFueYC9k9/cswpJ4nFNdDs13cY0jAtZIXjBbiXRoGmxTr5JgHu8UrNG8T0RSNxOUayapWasJCK7qzZqXCaWeVM5/EDyxX68JcuKf4aQFpY+Fi+Sb+YxH/OaEaRZeiNGQBSmUi1BDcXHExHEvi1gaS5Sa6L2SiGyPM+lomW1R9nNx4cQyyVF3tmjl/CmOoOmsVa2s+YYgmIA0xhgsVo4F7z7WHQJ4MNot4LVQOVB4Ei7afB5kUMR9mkDWVeVb9pgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kusBjr/9qnlRD0tynN+1+FwFnJbt01tPhHNfv0xExA=;
 b=cwetMvfJYUfN07QUaYh4zLu7gBQgxDR1YESVRNxk30eJqle2UQ7Yp2rpVou3x2rrcfbNhL5MXO0cdS9S3mLXwLxwrROuIRl1W50BIHHABackjrisge+mpRkA20qET3SbdfRanaiFe01V0IaD/OWvTzlJ9QXHf26AdapPV0HrnAOLr9Hrp0jMFOl2HHTgujunSEsY28NUsNzPIFqLilRqFQ8DfFc1Fo6MBPyO4Qng23WaU6Vy1j622BXdi4HEUVHRIQXSpoaXQAsoafs8IV6IaTk5SSs3wxWCjWtkSVysfIH2X5tmkIUPH6/w77l7xW36A3Wn9719aZg+ZFXFjYm8fQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB8347.namprd12.prod.outlook.com (2603:10b6:8:e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Fri, 8 Sep
 2023 00:34:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%5]) with mapi id 15.20.6745.035; Fri, 8 Sep 2023
 00:34:43 +0000
Date:   Thu, 7 Sep 2023 21:34:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ankita@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
        anuaggarwal@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v8 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZPpsIU3vAcfFh2e6@nvidia.com>
References: <20230825124138.9088-1-ankita@nvidia.com>
 <20230907135546.70239f1b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230907135546.70239f1b.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR22CA0023.namprd22.prod.outlook.com
 (2603:10b6:208:238::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB8347:EE_
X-MS-Office365-Filtering-Correlation-Id: 291233e6-96ff-4099-05ae-08dbb003653b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fIB1mAFdVV6g2lMa/AD4more+8XRD6RfOHebH8kxMNuOnMcW+wmOUIQLgPQGKoZLuOTZBLN37Iooo8vlQqpxJIBrakLKHGnnbXaM7y/GFe82bbT8PApqSBoM6voIChWprBIv4U+KeeqgoStbzhGiGTIc1fCOhFy+JBfAUFQYQ6lLMQIP+MsSpV9p6M6RBIC4htF+bNLoqnFnPSl6ew52PGPT9OQ9rpYW2mNCnFb0mJmCdQdC5hKVjO9rxwUpUUzVbx1cvRMs5cjznXjmAuDoMo2V797nXeGZ3ypIOktFfJzmqOaymk9ts9iU2LHFPZuqWiSso6wk0Et+cywgeAHF0EqlKSjYQKIPMg98R8PTeTkud1ma7gyzy1u2rJ+fSs7Z6CjhsUI+QWNtiNSWDQw5TlxzMUirWz0FqJWOenOZlEBc4NOAI3JR1krlj7nyQTRL98Ltvc3bq26hioN3DIgUrS85bMPY/8ThRHoUh9vSSwfn5QvRKOnFizTHoS85WhochJlPNkWc/v1jxdKMcf5Lu1bFRLEH9C7oD4M2PJjLZ4SARh4/i5WBdwvhDQzlaGrC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(366004)(396003)(346002)(136003)(451199024)(186009)(1800799009)(4744005)(41300700001)(5660300002)(86362001)(66556008)(478600001)(2906002)(316002)(8676002)(4326008)(8936002)(6916009)(66476007)(66946007)(26005)(6486002)(6506007)(2616005)(38100700002)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d34MZcznfs9f0PtJ9gE2aFyetm4Gi25E9wZ3VyXZXSu318dyUCvQ4CokUYvx?=
 =?us-ascii?Q?CVpzlIUS1n7ilBYRutgVESnLjYeuNJHlVs+0AZbnJ9T8XBF0Tg68XRI0DnBj?=
 =?us-ascii?Q?cFzkUiRtSzs2NHcu/PgNHyvE90fRO2UmQ7qC7k+Beiajc+vqAlKZjwX3D0og?=
 =?us-ascii?Q?VIQJCTPVSMG3DrXDCblkn6qFpeC6vpAR0C2M/QN7xM4RQOctUhw80fCZh2YM?=
 =?us-ascii?Q?tPX0GUsvTwqaQ0oFGO18prPqj8K2YAd/ifV6Uar76oV8l4Z396Wf81wtPQE6?=
 =?us-ascii?Q?CEaM0bUhtZ1aHJdFOgCdDKUGiTWrLMr3zQMp9t8Peq0TWnv8Yg+LTcI0GLuB?=
 =?us-ascii?Q?i8A4IXWTspDOcg9sKa34DS/vOKlBilm49K80weyhDoBZtwi/bagFIs4f3X9+?=
 =?us-ascii?Q?2efy6OTLs+gkCoTdZ9txETHZpdZQi1wVBmOhDZmnynSsUmVx2/SEgikU4V7B?=
 =?us-ascii?Q?cnB4SkyNRvbR17GsrMLlH4wggmNQ/iSAWw3QgZVpFOp/hMagndsRXQRfJBhW?=
 =?us-ascii?Q?3zmoDMh4Itbu1KQlS8QmUTDY1TBGX1vjWs7c/AUjtvwduqTm3vuojbMKQMHi?=
 =?us-ascii?Q?NfAajYOh781vFYB6vp+HfGnOOWbOUxpGfCya+zEG9JCHC2rwuMBI/XN806em?=
 =?us-ascii?Q?LWquAZzyywquHAY6pS8m6O8R3krlyZsW07iTBw+FxjARXvbqq/L8Q441E29I?=
 =?us-ascii?Q?MR+uzhznl3hyj84lAduHD3gIkzkasnbVG5zC35PFziW2eQRsGuFP809mlads?=
 =?us-ascii?Q?YHREX0hRtqVRcXlCp5NfYRrrksiyZdbTaiNp0KBvNJnGt+PLSTpYkRqCGdC4?=
 =?us-ascii?Q?USATOTeywAIZXwQeZa7Jk9hOSzIQeeqTgwvRgrVO+49Mk2x9QlhY38Ne+WrL?=
 =?us-ascii?Q?2qC6rwBBLOCYVao71uglcgTgfQEh0sOLixfvQE/HiypFCr7rhp8gb7IpsaM7?=
 =?us-ascii?Q?W9AjHN2iaXO9uxySf2YmK5sF2hDnhyDv1qIFbq2kOZ81WCXNR+x6WRgUFEB2?=
 =?us-ascii?Q?Z4bhswP7y8Mz7MYYrrLRvZxh81vh8IU32mCbNJuFBQBckQQWLZge1c6BCxge?=
 =?us-ascii?Q?oU5915znMk+Bd7gxWqGf5ZMp9SfUqquY+AKEKpKEI/xRhscjK8eDT+WlXDXT?=
 =?us-ascii?Q?iPKHBLo4PzGyPjQlmgRbVwCOzbLkk1lS9lnJycegvAw/LtE89YZ/7TZhej6f?=
 =?us-ascii?Q?MM9iAY/MQ6bbu46RRkDkoK3H5zhn4OZnaxOTXhEi8GvRhr7sZHvhAhSG33Rp?=
 =?us-ascii?Q?GntFWz/1JQQIPemTNUBBNr4f14Yc81kYXXaBus8XCLNC/FNy3NbiPuwB7BuD?=
 =?us-ascii?Q?tpp73398hGoVjn9K8EHMygxrG2zBUM71P9hnMTpPUOrBSMqjuBAUKH/NDHSr?=
 =?us-ascii?Q?0LPtX9ye4b8DRhTDaK4ZO5D0mfIWpz2pH6e63xaNOUbu5zfTIxciBAlp57Rr?=
 =?us-ascii?Q?C9xVVvI7al9zR/vg2iFskvVqb1QvY9drOgiKcpa6YjrNJVhNHgN2OQE8bwEB?=
 =?us-ascii?Q?RfnTSMyLAGRfCZeNvpGYYDE5Rx4k3bmN2WCGnngUQFGyLSxipwF7Xof7OgpS?=
 =?us-ascii?Q?YwXia5z4xw3A0FZjwiO1BjSSQMiD+aIvM8Pjn8Ik?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 291233e6-96ff-4099-05ae-08dbb003653b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2023 00:34:43.5331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LtYdY/Ea+D8tR5sQwyahwmtMq4fxfB1TydnGOsQdS3nckqrCwHxjuG2HHPnWrVGV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8347
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 07, 2023 at 01:55:46PM -0600, Alex Williamson wrote:

> There's perhaps an argument whether userspace should compose this
> device itself, for example finding the firmware attributes in sysfs and
> directly mmap'ing the coherent memory via /dev/mem to back a virtual
> BAR or otherwise pass-through this associated region.  

I don't think this works, secure boot turns off /dev/mem and other
things that would let you do this AFAIK.

> I've previously raised the point whether the coherent region here
> might be exposed as a device specific region (such as we do for the
> above IGD regions) rather than a virtual BAR, but the NVIDIA folks feel
> strongly that the BAR approach is correct.

I think it really depends on what the qemu side wants to do..

> Please continue the discussion, but I'm not seeing anything here that
> feels significantly different than what we created vfio-pci variant
> drivers to do.

Right, the driver seems fine for what the infrastructure was created
to do.

Jason
