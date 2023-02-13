Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585A06954A7
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 00:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjBMXV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 18:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBMXVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 18:21:54 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9288E1EFE8;
        Mon, 13 Feb 2023 15:21:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ULDQnzW5BVTZeXuxGXTDu8s3INeV1MBCG9vuvUmkun4/nRRw+zDp6QzEJhaa2gFcEJNgjYT1N56NF1kUdLvjL1/bRtyvshYTDRr8dcaSv7jj7DwVPnTntbnJfAaT5vGg5aqBD3UafRvk5haj3wXwaiTuwlkQAjbIR75GEJIri+urcR/b5OKG74BG+QjLteaGn8XH4onmmu2gH6iG+5pgK/FyGJculnwCZwwmzXoH5laG54UKwatdNfLu82kYiktldwERVyQK1UO1AXF1JgbXx96uL/fuIgWsAfF9mzuwEmfrX5E3GSh+VyATLO9y/rtdVNZgQkQYFY6u94MPre+V6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0EDIFOUfuTVHZd1B/JeJJO2WXZLvjto/WY8vYEcbTJ4=;
 b=Dsw5HMXLz04sKmXfJ2Rc1LXX2G7czT9akYIeulktq6w1jP+En9enA/OR0blbJLklAJl3faGotC1uwozelHVjfXkIL5wGH3FbN6gWHk6N2lRfeYE+aud7q3wu3CC/13ktNUNZ/fmrF2HQn7UhDcOQNLxjVWp8Rg7OM9BjX3fCWfJFdyXfVqhtxKAe9Pcxl5ls0Fm334oPnCBhCLMcLhcamuQhbgIoQk2kdEloL36GKqkBBpNTQxWL2QQgaa5s6vl4hlPvpJdj+Yz8hMk91pi3uP6g6ulHJPYDmvxd2um6M1d9sYBQ7/LwhsA80Zqbt2JLmuEAVI8J2yApNu+m+9TRLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EDIFOUfuTVHZd1B/JeJJO2WXZLvjto/WY8vYEcbTJ4=;
 b=haJyllCP3dU/CviO1Izyllpgidd7z14AAP92wHV9Uon+yUVBmXa8LHpnKeJeY5VFh+Imyq5X2rh9xUyxvAR7ol+SBR+JLGZ6WCBQrRQNWafVE36nLBHh7EkMsf6bQTVDgrGMQ05LSjgDmIVIy5tHKFPdyjNDB3BEul4iEjoFFflPP7FjOiajOKDgf0pKxFrkdpQqZOogJ0d/TEu42P6dIAjKBLgS3502onIgHDom/ZO1P+iLRJ6QRRbrqfeUc5aokpoEmcy3ybKfpmzRSIn7TAGWGiRr8q1Tsd0SJ2ZJSeikK49Sc0KhWNYNKRbpjtI+tX9cbZub8eqQ0Mq+gTOVXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CO6PR12MB5489.namprd12.prod.outlook.com (2603:10b6:303:139::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 23:21:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%6]) with mapi id 15.20.6086.023; Mon, 13 Feb 2023
 23:21:50 +0000
Date:   Mon, 13 Feb 2023 19:21:49 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, kevin.tian@intel.com,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 00/15] Add vfio_device cdev for iommufd support
Message-ID: <Y+rGDeEMTB8FxjAH@nvidia.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213124719.126eb828.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213124719.126eb828.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0292.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CO6PR12MB5489:EE_
X-MS-Office365-Filtering-Correlation-Id: 681c4682-9dcf-477a-da8f-08db0e191588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oIa+5d4JI2Rq1mScKrNPfswYq7CWbf+akXx7byfdHfuEbqUc9S80RsCvlhyQ2DKlRZf5PBYRgd0rz8t2AZmFtie/3OhLhzuzRtdOiL34f9gHdC/OEcVWt6FrArmvGe/cs1v48u0EjY8UwZMQTu0t5o1e9UStq7ssXH44b2a026kiuGHbECFqshvbTzY015DBw0hxRZDSTZYX3xrxzrHab1GXCIWwnauJjuranbrUJoL6cUlA8jvAuaf8HYOPbSjFWmwhXtBYnKDIBnAE+Z0RwX9BAkxrKoyuBU+Wm2GNs4wvMuUayyibgiZUeTSjOvPLP4sIk+Bf/HEI0YZ5Ga9LI66D+9HT1RaLdh5yeW9YdNnrzyWKLiCyy6hD0lkIjfTc8UXLxKbWe/cbZLVSWVAIeGL+FQHgDsbd4Fye/OspvV90XRw/24kDHqr6NUSjiiqhyS6qG86999Fdw48kOwPUfsXbsV72QwNOGUoxCdQQjRF6fN9aoHp5J8o4s3HiiLahMksRS67KSvLiF6RKvaX4u81dcmbEUpoPikpTShmaXMB84UwJ94lWSPiEvBAzSu0fAGVmRJSZ/A3DfU8JgVApG1UZonPgAxLt9hUUCHreQ3HYwYEtoaumESZhtcDf7BysaeZMTJarWG7hAItlJSLrC3M78SuuozlSsWZ+wW74qk5iO+bM4Kc7G24nZUPj8xAq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(451199018)(4326008)(6916009)(8676002)(316002)(36756003)(41300700001)(38100700002)(2616005)(66476007)(66556008)(66946007)(478600001)(2906002)(8936002)(7416002)(5660300002)(4744005)(186003)(6486002)(6506007)(6512007)(86362001)(26005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J1Ys0ekUafDGidl6jyQC2nm5IEBncTrGvd0IB/3HiFdJ+fDfArmGZDj5cY/C?=
 =?us-ascii?Q?bf7mlD1A//yxXoLh8PQUCGWjAZtrcDknw8k9lYK33gN5Ed4Krh6oVfIKufGM?=
 =?us-ascii?Q?VJ2Jhk6+UuoU2aZBoaDNJ5hsQOb0pncq1Xr6qlYTN4RQwCCvd/qmcZnTH0TQ?=
 =?us-ascii?Q?rtMTKIOns2eqwh9c5N7FcdSPhc9zhX1Lr76xd5ia0BTmzbJsKAHp49IRorDE?=
 =?us-ascii?Q?jo2zk7lhebY9G0mgw/mhlkvgJHTBCT1I+QkFJTqs/I20kXkc3iV0/TZyklGD?=
 =?us-ascii?Q?Q365J6ZWgx+q7GDx/Rz6QrNHigGqTnxBs5sfm7jARQCe4NpO6xuOQ34sFuxl?=
 =?us-ascii?Q?6rW/ctaG7TuE9hiFhDrXolyvJU37oXw8eXM9Npim4fAsbxrSHCIuwKr0jtXL?=
 =?us-ascii?Q?ZaO2CWSG/kvmMpYpol+MhFDVHbFBg1tKXq0PmlWbiVIKYqH34xy2VpXVSIW0?=
 =?us-ascii?Q?bfWXcJkTeeCXwBuEVPDSsysXsXA0DUPk4ppqNClSVgNNA93ZxMYXTI2bEjhF?=
 =?us-ascii?Q?qq5PyJHRf3sNNmCSbfo3z05e2F++VnpINgmU0pKQyA/oGCsN3JMmzUbB9HFM?=
 =?us-ascii?Q?xEoZGHnCpD8MUOlb0d2CGaCpc6fHIKrHrIpp8mGxKv6SHHrX/YceIocwpmlJ?=
 =?us-ascii?Q?APVfvJDOUfF+CnR/Y/9cS2ozhVFzDfw1zkS3XW0v0Y2gpP/vE9lJct5zhMYZ?=
 =?us-ascii?Q?8FB64cG/2Mqyz1Xe/A1au8i0rv4jQQrkMynsX6/ZHRDo4zOEWDXbTqZBbdzU?=
 =?us-ascii?Q?Vp3GE6yneaGyg4CKXTtCbiyGYzS89pOZmutAe0Bpx5YFZW0jdEHT58uPBovZ?=
 =?us-ascii?Q?gV1EzpA2mA1Mm+uiFU8WxHJp8zN88XEt8DTbOfJ7gO6406F6abIWEUsK+8BQ?=
 =?us-ascii?Q?o9BGUL9AsfevuymVMKtXSRir5rdxfMt6sPBuxm7vZkPnQ4oZpu0jBAMghMyP?=
 =?us-ascii?Q?155fubmkuXWzCTy5l2W1FlRpdAFHs38xCniOXwTkfqo7HbFJtv0rNtpZvT1+?=
 =?us-ascii?Q?9/0475zO1MX7wHFPbHhhfgKnBNmSreW+mjiLeHTAN6zWXqZaQ0b8Mjz3je1O?=
 =?us-ascii?Q?a5QZusihOOh4uJO73OU7KyglrZ9jHNQox22JUhPIdFG8IzpYXCulszpyP7rP?=
 =?us-ascii?Q?iaANeJGfKJdNy71kpAHPFObnaf8SANxyjrpycbne3JF/LULxwLzTbzopWou4?=
 =?us-ascii?Q?kkD53K7fDsZYKvDvkg0Un5TPF4rNAQphS8zST2T9xCY+EsM+ViI+rbYQEkxX?=
 =?us-ascii?Q?W79RYuyiAZg+RPgDWI2yLoMygxPLXSkm69Q6NgtfqYbvkeh8jyNHxiL30LPq?=
 =?us-ascii?Q?gAbkQKJw/hCs4D2cW3WT9blZOP21OGgGjrPBJCoOVnP95n4pBLEOwdqTgvGt?=
 =?us-ascii?Q?Y5bOvE9EG1SBv2a4fO6FO7kqKTXQ2sNni9jT11ypPvbbeqHTdZsOtqtBQp7G?=
 =?us-ascii?Q?sm5uJvXVgTt/0MqVP1qBb5pUChb59dZCpL/bdUHjzWeKz7UsaKDLWlRtYDUo?=
 =?us-ascii?Q?nqN/MaQMrg7XyrLbiXSBZwKfq9+LkNUsQGyW9a3iRnZFvx6ldLbKEj9AGE12?=
 =?us-ascii?Q?5mMl6JqPUJx/GclnZNgJAyovOqn8UpbvkuCGpd1K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 681c4682-9dcf-477a-da8f-08db0e191588
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 23:21:50.3193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /r1LZuw1ZzohVizc3Bf25ma7wnjRWJBQr2qb9nCf+hDmB7/Zr/Qh8wfmSEmaLTHU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5489
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 13, 2023 at 12:47:19PM -0700, Alex Williamson wrote:

> I think it's too late for v6.3 already, but given this needs at least
> one more spin, let's set expectations of this being v6.4 material.  Thanks,

Please let's continue to try to get this finished during the merge
window, all the other series depend on it. We can manage it with a
shared branch again..

Thanks,
Jason
