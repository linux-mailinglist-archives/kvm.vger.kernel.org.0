Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67BD75832E
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 19:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbjGRRBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 13:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbjGRRBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 13:01:22 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20622.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::622])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77701359E;
        Tue, 18 Jul 2023 10:00:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vjk/ShpLJAdCSozC9tNOVhOmKsql0++xCcXmic5pBEW5RIPY9ZdY7XTnKbjcbSq7meirv4f1N85glZwig6TKhCi4obTSkdVTsUsUcSmEi4yhrpUlsWz4R0+mJiBw2CizN1+dyX5JUs2/UF05PU9ZTi4lSPNbZaMlgtiS38Q6UFd88PA63/F5k5r0J/NyLOykotKs7P2bhHRN96xNyPBo+wimSK/KWOEGV4KAo2dz21/43K6VBT2i4vtrt6qf6kpolsv5O6mckE1jo6bzUmcxn3ZRGpeV+zevLqj0K/gE6UFl+i4J35szkHtwpokpw6s5rlrLwXtisO09m8jpFe2t5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ZBUXpk6TZlCuPBBv1InkpAJ0hO8S7oP5WAvY/zwyEU=;
 b=gPcpVggr9hD7R5Q/ObqhYlro1GSyjYxlEpdG/IwgFA8PYr4jNyx7BfBpp1G9/1+8XztfiOLP9rHaE/tRyGcyNYT+HBsmcuf4RXXm6OFnyhcSRDwUcgU1Ta1yOI0zzMl5yBOqolYJUJO3LvAsWs2tFok9pGwp4fJdGF9BoKBtdfpF3lHUfLWMqtXHhftDhuY8IZ8Od3AKBWp8FwR7Rwgjnc+D8+9OKSjz6/xuUS6+scUDjwxxnLI2cPez2jynaynQQ+H20PVAjfO080yXzrhFI+Ls+qU51/HjKDQZtk8kdY2ujB+0MWortVIGZK9ZDL8m5m2OZRUHB82psgNGWgmu6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ZBUXpk6TZlCuPBBv1InkpAJ0hO8S7oP5WAvY/zwyEU=;
 b=fz8oNPB3+0LIc3yIs2Evqj118dfh8RXtDV5umQ/KwwFBCYPtbuNKXICTGt6SiB+N/MUyb4bl3d2XFcZMB5mH+a+H6vIk7psVRPwdrm6LJBDlSHCMQJtp4RQgZw+SqC7sHZz590HnHsr59KlEDvD3RAL9YfioT4i9kSa1TXdLYYzhKoH0iQgUGzSCrPU56ZVnHd+2j0aUgFjehBKxxIf2Fx/ezB/JqV3RiklIHsD5Xqnn/WnIKmUI2qoWVKj7tppwlLCTvQcQ97TEBch5WZ+LUWLBp4SESQTxdhtH0JL37vgUgiGSMNw1spD5M8fpfvbCFNyFm5lbaXPgf7pKWM9bhA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8555.namprd12.prod.outlook.com (2603:10b6:208:44f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Tue, 18 Jul
 2023 16:57:49 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 16:57:49 +0000
Date:   Tue, 18 Jul 2023 13:57:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com
Cc:     kevin.tian@intel.com, joro@8bytes.org, robin.murphy@arm.com,
        cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v15 00/26] Add vfio_device cdev for iommufd support
Message-ID: <ZLbEigQvwSZFiCqv@nvidia.com>
References: <20230718135551.6592-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718135551.6592-1-yi.l.liu@intel.com>
X-ClientProxiedBy: SJ0PR03CA0230.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8555:EE_
X-MS-Office365-Filtering-Correlation-Id: bee68010-03f9-447f-1884-08db87b01e05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UabdzXZtGap6RPztvyQHWvm/amwAL77yJjl1+EsuuA9RBt0LePu/Mjti0CW4fktSgNRsYavCz87fjDfq4s8V/1dV513F14NdOUJ7xMB9xrF+/H9j3ULiOxgd2+xin+VgQs1Hl9lqS5AMe46I9McFxY7uRwbfOlSB0BWdpG14+LlIWA646wFs4fZOy+hH1RA58GN1khWph3DAs2TH5hfUcDtvBcSARPUPEhA4kCFiTPupeeB80avnoJ93/faXHUf1KxBN4SS+Qp/jL+alyElcsxEYByZ12eSgI3vxyQxT9bO8KbfLlsPpTmwUlGOff3+VUqvcFP4VXucL9Tq2NBp2rRgjMhLST4VKtz+0IzOD7zTWZKRZuZTvXhyE90YgYHIvy7XaqNTQUlOmlSrY0ArWJ1fWWD8bAwQirrMCFHupWXIa2JSkM514x72EZDyWgFDCdMjIQzFlEqr/Fwrtq85yFwN6HbKWK1NZ2uuPCRWhe04ouH07B9GfyJqb87eh6Gx6PJPpyoDrJXLp9pzdXNU0hp3f/MSVjkkh/5wOTPd3i+3eKMObC9yEwN3ui9acEml9KbEoIT/OA1OTKNWimaYXKvOLZR6nAkrel6QdCX5kIiw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199021)(316002)(41300700001)(66556008)(66476007)(4326008)(66946007)(5660300002)(8936002)(8676002)(6512007)(2616005)(83380400001)(86362001)(38100700002)(186003)(26005)(966005)(6486002)(6506007)(36756003)(478600001)(6666004)(7416002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bmeIEeSrlhJvD1szhKgzRPjQrDxaXAOzReH9ksIA9m6XP7wvtSCqbdMYbxWN?=
 =?us-ascii?Q?+W1p09qvKA0Ubrl7jcyXt6Fdz0y90NlnZEGQRRLqq6FZB40ClNKfZ7KGkiS9?=
 =?us-ascii?Q?OfaU83j9kxDNeA0bUUPEDwCOQvVn01UzrBpWyUWacKcYxbyNmWc3uel0Ak/1?=
 =?us-ascii?Q?XFHkZEfznzcb0QjKDoP1/NcfBJyHUzSV9iIkJQTE7bxTX/7+3/MDsjYwylqD?=
 =?us-ascii?Q?GHaJvy2eFYihcsz4fWTxh1QK0aWpY+9UZcgP8I6of/54krWWNq9a2oXfPR0q?=
 =?us-ascii?Q?ZJpsX7gfmUACZTKqPEE4RqA6xvJoK/zc5wEFkrRZ75+ywFslAPnFWevRDpg4?=
 =?us-ascii?Q?3TQBb+39/ZQcGBBAA4OW15HdfUXav11seNK6zj8fokSTHPu4UuQRshPOgpGH?=
 =?us-ascii?Q?ydXVzRSDrThctHMdQ/UJyJAADA1UQtYHkOXInvvuzP6ymnsxyzixTzZtrGBt?=
 =?us-ascii?Q?ntilWcklZSanyV4wyGrn6MVvMwYGI2xAnh76usNI+RyQM4OL4MvjkeS/BGtE?=
 =?us-ascii?Q?KCZ850EglG+DTcOijJBO3EyVK3iBfH8A9R4/6/+moc5NZIGNEKq8zalxz2/8?=
 =?us-ascii?Q?NLQMvXc8WMNV9j6w3ljqEL4R8tQiWhAIXxP2xY0jxCD0uRrtCJqoxKnLoR1w?=
 =?us-ascii?Q?ua0A1N2gBmGLVsdNOGomIXnBfWmf2dKFeEgdtKBwVY/L7+8PZ3Ek/GKNpOAi?=
 =?us-ascii?Q?8gY+mKBhB7W9Qd1a8UT8R4QD4/0TKWyBSgPt+RL1Rp1S+j5i/OdRaXnKQWn5?=
 =?us-ascii?Q?QU+0MAsUzZUCWiy2IMkGTvMzo0QkyhHReP1ttWj+YvHGMbFlu9vtwr7Yblq/?=
 =?us-ascii?Q?VM9pnv5WzOflbJpnfUx/8+XWlzvIxg9umFpa1h8bXH9zsjzpPwaQHux5BURi?=
 =?us-ascii?Q?PNAioFgE1pA4/yD2aIUiGH7hAz3gxFc6k66ps8KJpwraD6xH2ofBV8JFJGGi?=
 =?us-ascii?Q?zlv5DHEjDbq8ntoLBLf/3tdwtcu+ShrLPpSr1TNlyagFrwWi9dCH1h/ARrao?=
 =?us-ascii?Q?+mEQmQ/5nydwsEdM0eCbB5AL6+P39uxdcs+sUwBCrXBDCBdDLXxGKb4+zCnR?=
 =?us-ascii?Q?h4/qecNF/V6kmlquJMGq+d+jIJKDCnA4S6r+CqYcsilZfoX9P/GqfKtbo0rc?=
 =?us-ascii?Q?SbW4YmSUTXp5qQVgH9zojcSirYrOyjihpuyr72+KAQN1GEGpo0pFkngbIMAb?=
 =?us-ascii?Q?xHsbgs1Ald8BFx72jtpzNzb9N962NvK94UkqQ7q60lxci1OLKxPxoKi67f3q?=
 =?us-ascii?Q?B/5bEmJYeFP/CcFILGMPoHc9KEYx1J5M/wjWOieF+2jZGXZ2RaWx5beDZQAu?=
 =?us-ascii?Q?GF5T9+o51ESK0C8ek7B5mNJ1FnGPPFiCmUmUqoetZGbSlmxWck0wjjO5XQbz?=
 =?us-ascii?Q?K4JmWeop3GmSqYSlvI2WcelLL6H/bPTAgRWtfp5VpcNG5WWHs67K3Kv/0GyU?=
 =?us-ascii?Q?RtYwNPHVQUw0M/XYZQ/1Oj1DiEp6P95o2vxU8PsPELPpnRRP0oDDOKm6vkx+?=
 =?us-ascii?Q?sVLttMdlNbbPcb1Sn3jItjRhdrORuxoPDxYE2FH/ctZgn+EisYBL6m0jBGFZ?=
 =?us-ascii?Q?+yyNxEf8xsxIqIkz2Jhr6O7iykbXTk/2VcrzQjhG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bee68010-03f9-447f-1884-08db87b01e05
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 16:57:49.2073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q8djGYtda8718Ik5Lkl2QpUbR9vRT7pz+PNj6RKHc5+VS8CQd2ICWrT9tfAS4StM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8555
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18, 2023 at 06:55:25AM -0700, Yi Liu wrote:
> Existing VFIO provides group-centric user APIs for userspace. Userspace
> opens the /dev/vfio/$group_id first before getting device fd and hence
> getting access to device. This is not the desired model for iommufd. Per
> the conclusion of community discussion[1], iommufd provides device-centric
> kAPIs and requires its consumer (like VFIO) to be device-centric user
> APIs. Such user APIs are used to associate device with iommufd and also
> the I/O address spaces managed by the iommufd.
> 
> This series first introduces a per device file structure to be prepared
> for further enhancement and refactors the kvm-vfio code to be prepared
> for accepting device file from userspace. After this, adds a mechanism for
> blocking device access before iommufd bind. Then refactors the vfio to be
> able to handle cdev paths (e.g. iommufd binding, no-iommufd, [de]attach ioas).
> This refactor includes making the device_open exclusive between the group
> and the cdev path, only allow single device open in cdev path; vfio-iommufd
> code is also refactored to support cdev. e.g. split the vfio_iommufd_bind()
> into two steps. Eventually, adds the cdev support for vfio device and the
> new ioctls, then makes group infrastructure optional as it is not needed
> when vfio device cdev is compiled.
> 
> This series is based on some preparation works done to vfio emulated devices[2]
> and vfio pci hot reset enhancements[3]. Per discussion[4], this series does not
> support cdev for physical devices that do not have IOMMU. Such devices only
> have group-centric user APIs.
> 
> This series is a prerequisite for iommu nesting for vfio device[5] [6].
> 
> The complete code can be found in below branch, simple tests done to the
> legacy group path and the cdev path. QEMU changes are in upstreaming[7]
> and the complete code can be found at[8]
> 
> https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v15
> (config CONFIG_IOMMUFD=y CONFIG_VFIO_DEVICE_CDEV=y)

Alex, if you are still good with this lets make this into a shared
branch, do you want to do it or would you like a PR from me?

Thanks,
Jason
