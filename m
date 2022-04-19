Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA76F506C1F
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 14:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349988AbiDSMTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 08:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241389AbiDSMTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 08:19:21 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2074.outbound.protection.outlook.com [40.107.101.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53AB2251C
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 05:16:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kd0tEDqwwZy+xUzLpOq0EULZu1/ljmp18mRnQTxX48yGK0T4yVg4LGpDwDnLsdtIPqfOhG49+sFaNiXhGJbwICt45kK2UaWUFMEdszcn4hjKfANuuVQ59mdzHAfsc4bP4YyPU/LKT2Hp5oThCdIZSMDiBIPVo+KpWm2IWRSY5bprU1sELWjKFgSK0933ALHUgcxrQyJWhV23JXOmxFxd8CrwBks/iBdpNe7SIyouLmgOsatl2HLcWOEcqO2iaugBpIm7BugpECJbO51Jb0/Ue3h2GwuYUO4ndcak4dMZRbuQnu3qyonchBb831BYs62C1iVYnHU4UH3fhZds4Mh+mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4hm+EDw94svbX2eckF8G7HuUcfq7iB+BTwxw7CGrhZY=;
 b=VZeytn68A/xOdf0/78xyQLAsdXe8s3n7SqvxvqQAcAojxm7DxQaBQIyYjr6guBTiD8/ShKp3M8TZRYDpy9zaXYD/sYql0nr9NOcAheZlL5y7889XxhP3nZ15zHkVI8DD+JtoV6hIcXltPEUNLH+uJ02odTUZj7sSihUWtqtFF5xSjUNVKBUKOWm9u3uvZuuFgnxCeuSWsA2b6AvlTrbcvnaRTunb8ssHNm63npSSXjsGUs2ndowGuHMVyYaJPupbITJvTxkgDaenS5TdzQztTWYVABlggFaVEa4BOTqWDc6v8f8P0JOQTtpQiEZ2POyI3Eu+F8YTnR928uxRRpCcSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4hm+EDw94svbX2eckF8G7HuUcfq7iB+BTwxw7CGrhZY=;
 b=fu+B46LUCcZ/hwTePH8FFvbZcfX9voe7vAl2mTMX/kA3h7xMtHVPoOv3Tvu9yHBe1ynQI+H7+6VtG/GoE8IuCbEB2JA0ZqePVUOlzlynu5Bg5tRGtYFAqQqs9Xx1odpON1PlgofCN57ONcUgZJm5ihLPpLfmYpvO8Mxdo13/oyMXUry4VW0qnsJ6siw+Q2Hq+k9z/j5br39lTnQD/BkEgWFt8vGO7Y5eoz0M3takotAl93govb1q4EGZsSF65pYuq5+dsZv1GOS+id219ZE7eGNkD96SPiHZ9FaSugvArqRuzN/sjYFUJ6rBoisjkjprLT4ret1XnpVp0j7sjErq4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4999.namprd12.prod.outlook.com (2603:10b6:a03:1da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 12:16:37 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 12:16:37 +0000
Date:   Tue, 19 Apr 2022 09:16:35 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH 04/10] vfio: Use a struct of function pointers instead of
 a many symbol_get()'s
Message-ID: <20220419121635.GS2120790@nvidia.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <4-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <BN9PR11MB52764D80F73203162C8E82268CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220415215407.GM2120790@nvidia.com>
 <BN9PR11MB5276D64258C6C41C252C5C4F8CF19@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220416013311.GP2120790@nvidia.com>
 <BN9PR11MB5276A67BA0AB9311C4A551498CF39@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276A67BA0AB9311C4A551498CF39@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0245.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::10) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c93b3d10-f8ed-400c-a644-08da21fe736f
X-MS-TrafficTypeDiagnostic: BY5PR12MB4999:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB49992518796F5FEF9AA524A5C2F29@BY5PR12MB4999.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /X9H2Itxqgy7fLaY5Ho/BbhmaiAeJreEG8s4UEU5RSOygf54xXlA0WtBZE9WTH0uWWfgN3GHRau1Pf/2CWF3XUfL4r5AWHbPe/+EsU74ZbFlRTtsaF/6H/+qlRSbJ+2U3YwP39Um1IEHvPNLJY89pPD4OEQRdHsKWODovzziIiRQQV6MfO1tEvpIst+4T30sJioRoOoIc4LKmJNUPtko2gDszdaubZaTqnQzYA6FlM///BYJ4e0cCgvCj25o4vl40HmBAkOldON/ROw9t1cbwA8kvQNFyfllDnac86ppWgznhPRzBE6vvvXf81Su6FnFaEp55RvmemggJYQ1Wjd4zdVh/pvUX/K8euP0glzX6Et0L/Yk8x70Sf5+N5WSJVeffLNKZ/7H5G7xggxRma1yFGnMqcsEEOWCY3JKsJRgsuCIjFVHpNg3f9cask1ccgQxMgb2pDrL1ulK+JnaiPvBnd3P47sYdc+qvuyYqBzJH22f43B0AX5Rvm5dM2acwPeYbPugZZToCdSsCoiXP+qvh27WIIs8LjVvzkYQuzw+lAb4P4Zvv/UEoOsQIg1uKX8Ue6SnbRehgosNc/evzFR4W+tRhtYFDbrS9CGYVGugBB/E1wydSJGZuRynocrhc7SP/UIHFB1MEI6zpBbCXW0QpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(2906002)(6486002)(66476007)(5660300002)(186003)(1076003)(86362001)(66556008)(26005)(4744005)(4326008)(8676002)(33656002)(8936002)(66946007)(6506007)(2616005)(36756003)(508600001)(54906003)(6916009)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E8ffuz/Bc4TuPMQpJQ90Mif8WXg+c+yrzmUx9bb/lHwS25OuBjp0Trkqylt9?=
 =?us-ascii?Q?pXVyNAqALaV9qnwrJUKl84phAITjmNoGeVaq55MjwI+mruwJtuxzvFnsYhaI?=
 =?us-ascii?Q?VGhrxtZE37+VDybmefZjuZI79UZ3IKNqBaZo9/8zhrhwmy2l7EqsD7r+kx/f?=
 =?us-ascii?Q?sDwd47Y37DYSlgRyuk7UDPUakpDsPCAvlRYDXddkTflZGQ9Eu6vNahuXw2AP?=
 =?us-ascii?Q?uj12x3uuDrAuJed7LtZc+IlZibNPKoqPzjBanhhp14vZ4+BfSISx+kdEPdxL?=
 =?us-ascii?Q?O6uLw1nB/LLUWFrwnkHWcaL4jfZhrnEGtb4r7RTX6GfNSTkeWQrvL44np2h6?=
 =?us-ascii?Q?+iJU9s+uuJmZnU9vg74V1vH3yWrWj999TJZFdtQvni53RjjfGVb1f+fjGsUa?=
 =?us-ascii?Q?3lKFP4L3T7PaB5Mii3tsopOKOU2YQK6fnImd4HtYHrA4sgG9PDDjMPeLbjvo?=
 =?us-ascii?Q?qDit+tbblQAWASMkwaidbmFVbZtzGR0WyoTUe7jJHrR6Ul5w3cM+JVgDitVZ?=
 =?us-ascii?Q?YuZGEr8BfgUSLrdBgGH97XwpGpr3gMbsix6Vizmu7q9mBUenL/03PsHe0+i5?=
 =?us-ascii?Q?19VYslz4xiLSaB10TaO2FY13XcqjIPhL9b69F+/h8O+bNjGuziF+dOmYsm/V?=
 =?us-ascii?Q?NE7dDRHGc/+yV/JoGOGpLUy/PYX8pN/Tkea1VT0rWPKOSci/V+8vIwTXY99N?=
 =?us-ascii?Q?Idu16NLg9CmwQuMmTxyaPbQE2E69PtKAv+vJ5RR8s0203NWQ5bxjrUgBkjfz?=
 =?us-ascii?Q?vMrKMTAyo+g1VvAUZ+5eTKaJiFJh5Y2FAGERcd9gTb83PUiBQXjgNsjHmHot?=
 =?us-ascii?Q?E4y7ofT6pjRZ2QZ0WNExX4+xX5fsvbi7EnUhGDNWPFjfaj+Px8Ho3wDgwxtK?=
 =?us-ascii?Q?Kz7BaDU1UmM70JFRh2cSMIdrBaX4C7S2T5Ekm+UuHsuDwv2Px577TblE9yQV?=
 =?us-ascii?Q?z52LHlnc9K4dwBt08zKEwAEpKYcRBkEGY+v7WJokUqN9gzDedWCMoY+sY0fn?=
 =?us-ascii?Q?qFpwgsdG1wsi2QYgFcaQn129WS/AD/URZGsInCAQHJo2v6oTMg8CAAcRyqpN?=
 =?us-ascii?Q?ni6rloDH+8LzTio02ooz+TNfcOMPB2L2A0ZCBUoTyjCKwo1NZXt2P7+K9n23?=
 =?us-ascii?Q?d6DRSRGh24UpozGQOAq6Gnp861j2KFxZKJRpaOLjW8k/m3FiDlDXG7DM7Gdd?=
 =?us-ascii?Q?GNL7F2wGL9WPp7MX/ZkrN10Tz4Kab1MOo1uZYCFA9t73fwMGaItHlkeSJyaX?=
 =?us-ascii?Q?JCanwYFrtmURm6/5gQldNRjGa0DwEGKRlpeEqgUgOI7plz1OWRBqk7OsP9/o?=
 =?us-ascii?Q?V5eo4AC1uWiozyO8UFLUlT/zLdJal3QEG992oIs3nHl3v+mjEWewIe1OSR+T?=
 =?us-ascii?Q?RNXs/DSTAc5/bW2ND0nxgmoGG0x/oafZ1+nA/YcixxstQxTKtU9Ll1/3KC6V?=
 =?us-ascii?Q?HVCGpMNyrmdjyOsDfCtQjD7EbNRCmxCUa6H83ehv6t1S6QUG962gjAaX860z?=
 =?us-ascii?Q?X9jscfX5Zc6AEdsDN8bQCBiL/UZMupiOwbEm0LIQdfFbCboHaXXMPZELon+O?=
 =?us-ascii?Q?rAp+y+e5Uy2eKfpRjEu7ypFO6pZWC94eiK7sJ2+QdzJ0b7ZiTlTIlltkBVZO?=
 =?us-ascii?Q?/gk0W4Gw24hp6DXoj1nQ4nJ5rK7Dng5UQiWG0w1pWZWTSjIQwZwawnFMy55i?=
 =?us-ascii?Q?G5/zpetWR5pmbMCmGW1QBlv8PEwQNWmr7fOCQxowzFeboG84u1v9d3QY7XY1?=
 =?us-ascii?Q?a6N4jWAl+w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c93b3d10-f8ed-400c-a644-08da21fe736f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 12:16:37.0171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wofZu78mQbfiURVrSXYW05Rc5DCYrxXhzR12211dAT0ljDdhoNZCglQqv1vfSOQY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4999
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 18, 2022 at 03:56:01AM +0000, Tian, Kevin wrote:
 
> - Each mm is associated with a set of authorized PASIDs (ioasid_set);
> - VFIO driver provides a uAPI for userspace to attach a guest virtual
>   PASID (vPASID) to a hw page table in iommufd. In the uAPI:
>     - a physical PASID (pPASID) is allocated and added to mm's ioasid_set;
>     - the pPASID is used to actually attach to the hw page table;
>     - the pPASID is returned to userspace upon successful attach;
> - KVM provides a uAPI for userspace to map/unmap vPASID to pPASID
>   in CPU PASID translation structure. User-provided pPASID must be
>   found in mm->ioasid_set;

It is more logical to be current->ioasid_set, not mm

But yes, something like this. The mdev api may want to mirror the kvm
api and map/unmap vPASID to pPASID

Jason
