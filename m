Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB2F6C7E96
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 14:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbjCXNOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 09:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjCXNOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 09:14:53 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCCE2128;
        Fri, 24 Mar 2023 06:14:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HhzwqtnWRSaItaZE12WS3kjzkVx3ZVfDi2wg55uewkHzdEIsrA4NRt/GpMfBmyZrfro1tOc5aaaFrD+7XB6zM+/e6EtIrAcrC/BHaKJZRh26bdbnF1vvAz/hwmzmHo1nO6aXczvfT3HKpo1oMJfEj5H4oZUILu58EJ0BcFTFdEL4rkv2ooYJ2mEvXNPLo8K48YnSI8hoqoyAOzmjXrYpFcrzgz1aQS5o19qwne/sK+Vj9Ls3prLN1TYrUqtARUkighBhBvg5zvHKYjbdfcktFWfMPGtyQfNEhHvL+fNaC0CTTPGL9R6KonLK9BuH8aM8KxHivN4mPD9I4qNDE9GpHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=obnLIFpdgqa9gQN3dg449xos3Q7CnGGOD6KhVbfJarc=;
 b=Pdkl0zvve/2zclLniX0/iLdFcZDUyN/RSIZyhooeFYxQwTY1id+E/BIbiDpOkgkJ7IivJgXtmJAL9nGOT/TkWatlWimf/iasv2KdfPdPiEfTsNn4lhF11m3Yu62AEr+fYqHHdr9dt6PmoCwCyocrPSuYPps4+KzjhA7u4CmJptsD3xrXS8SiSbPwCYr3BvEjLuFxbBlhgqBGWCsCXGNjHToxg5Kna3ryCO+kNSENzuKttT1rLu5ZQHOj2mqYT8fM44vjPy9rojxF8BG56tzeTKl3FvePxMCsZYgkjzIcXsz47JRfnMpKreSeFZ8mjQPpMY+v8p58LvhvnSwAFOmyxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obnLIFpdgqa9gQN3dg449xos3Q7CnGGOD6KhVbfJarc=;
 b=YeCBSnehzcJ2qW4hpsE74pC1zw0K8/PQmCoFSYabxwQbnvxkPVHjPUof8fGBRRN3iGNYuRHg2KNv+tETshRQe5nFpyT7Ce+5ykI6ev12deR/X2GTF6opakBCl2Jz/bsrw8ElNeiVZxs009mMeuwKhxX5/yIgjoKyLCB6qB6YES9fomBpK/mkOLvsDeYTjrPDja3/4JDzbClHpxOQBo4hUUXHpSXfEz79U9Eg4kvHJYql+GJ1ErwqPhfWgYiWMzkRWPs74QJjQExobQBgKtZrGWt3CI+oFl746S09Ewrm/iKayVy9s4r4UYaEv3ltF9Poy5G35zEG67nMjKX/1Rl2mQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7316.namprd12.prod.outlook.com (2603:10b6:930:50::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Fri, 24 Mar
 2023 13:14:49 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Fri, 24 Mar 2023
 13:14:49 +0000
Date:   Fri, 24 Mar 2023 10:14:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZB2iRis6l/7sUKQf@nvidia.com>
References: <20230316182256.6659bbbd.alex.williamson@redhat.com>
 <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230317091557.196638a6.alex.williamson@redhat.com>
 <ZBiUiEC8Xj9sOphr@nvidia.com>
 <20230320165217.5b1019a4.alex.williamson@redhat.com>
 <ZBjum1wQ1L2AIfhB@nvidia.com>
 <20230321143122.632f7e63.alex.williamson@redhat.com>
 <ZBoYgNq60eDpV9Un@nvidia.com>
 <20230321150112.1c482380.alex.williamson@redhat.com>
 <BN9PR11MB52768F48FAFC65ED7AB45A428C849@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52768F48FAFC65ED7AB45A428C849@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BYAPR05CA0039.namprd05.prod.outlook.com
 (2603:10b6:a03:74::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7316:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a8e41e4-77b7-4360-b17b-08db2c69bf07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qnm13LO/onx7E15ir4Ojl1VEyTbWLOXYu/I3uIVLZcYsLLy8Lyk7J3OSH+5dpAi4JgeuOrz0QieW+cp7mUjwMnduD7sziWO99CXtJbupZyohsjlgsBttzScQll9bYpTsUMjOkVI6axOf9O1zL6z2E0Ig7Dwxd19WLdnCGF7PTpvCx2TR6K73sJQj2zyeTDKI+ZlijlSUej+ued8dU+bYVnP4CgqDc5EBFkXz6KBY3ruj+tPF4mrovqSM87en8SzcsDqy3ZTsF1tM5KJ3GJMghVykTMc1FbLWsnIgxorzIwBTPbqVjZjisEqGzcQwQKFITnEQ8iZHurueSLIEpUXWZUQWNdrCeqmJW7jSmrZqfo1OkSOS39K+ZVemKvhTkex5L8XiLZq/T7lVMx70OBtrYa1Qwdc7aPKc7TIm5J6nCrT8MrYfn+FgZVvWnDYEyJm2BNr1XycYt9pD1I54QQoJvgnhxg9ezW7j2oYVq6FYcYb/RPTQnd4+cLYr/rxBj9Fd+P6uGcwbVg/277g9ugJA52mj4QZG1JjtwVsP+kW3Yj0BQqLDQ5M1Yv1r2QKZpTam
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(451199018)(316002)(2616005)(54906003)(41300700001)(8936002)(2906002)(6916009)(4326008)(478600001)(6486002)(86362001)(8676002)(38100700002)(66946007)(186003)(66476007)(36756003)(66556008)(66899018)(5660300002)(6512007)(6506007)(26005)(7416002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZccDh1b34sglTVmRRR1W28dSDPc6RHh9qFvuypGzx9uvdK1ycSgEoH4vZp9K?=
 =?us-ascii?Q?Yhl+/TYMS+9pfrYgO45+0n60L5caRWIlkAaTtsWTAFegmbOA21U14rwBa0BZ?=
 =?us-ascii?Q?Uv2QpnTIU09YcjcxBrT04a1hif/0lAVCZwJoqVDPLqkB7F5DVAkBTVuopWI5?=
 =?us-ascii?Q?/9ITDdMQcdkDJ7HRdl6EhyApOQgoxQP8thPIEQtyP7CSO//QVky8+1DC8ICc?=
 =?us-ascii?Q?NtkRTxFqn/Ght8UWV/Xf0TsqdNFybX9IsjruC7DOGzpMbecXrGupy98J8+g6?=
 =?us-ascii?Q?VUFO+WNIRM8Cvx+dp3U3QGf9ukJHkAKpH1QJKZKF2RQdZ8FEbcBOUI0gQjVJ?=
 =?us-ascii?Q?bFNYy81Wlx7gaJchItQzm6ygnQrErYidNWtbVWDCdIGrdG4zw+EmxAwNvORD?=
 =?us-ascii?Q?Vz71MQ1oBYoGBZGNJePLWKiaArJNxF4wX5i7HXzf3SH2inZk5TGnmZi5AIJM?=
 =?us-ascii?Q?Vix2Vkc/vFW+DfCq/bHnkjv3wTzuxOfXIzKuoWxHELwFwZs+SzK3louISIad?=
 =?us-ascii?Q?PBa2A2cjhAvhZI1Q/9LIUg0zrnZOz6w1Zi3RpNTKsCOh/aebLvRwlXGfIa5W?=
 =?us-ascii?Q?QeuhZjy+juT1dB55uA3qZw7gwbqolMQAbfZA2Yy/W5T9+Fqrt+W7BYTsx4AA?=
 =?us-ascii?Q?acfYTPrqYBJSx2Mlj6fTwLFqbpkku7RSb7diY03u7PP+qkoXrxoqi0+J0Px+?=
 =?us-ascii?Q?pY8QEeS4HskhkMa3Yx10y4AlEYRkVT2CTrdNjPEa21Xz0xU30+lpkrP7wZkE?=
 =?us-ascii?Q?qztcnyGDecH2DbD9VHrxr7zezPVkDpK6BmGtDID2Oow+BZuEGiV9Rvl7JEz8?=
 =?us-ascii?Q?kT+jXRRSr0ZdMyHcmAMe0LReOQUrx4TBKTcScvmif1cZRrimoTu5t0RMYLRA?=
 =?us-ascii?Q?jpGEVdB+PRwAwkiWVsBhzXYX0tFHz9o1nuHTSQ2SllrK7vFE4laFuwc1voZi?=
 =?us-ascii?Q?YJwPCifYt8lVeonZV38QgM1Dzf/oumjlZzuVQwJqhFc6dVAnROnGeFtgjDYF?=
 =?us-ascii?Q?r05Xx6a/uoUnMPLqEkmvhZoAUDcSv4aEObk9PyXjDTDlyQ7Z+jff5Ui4ksy0?=
 =?us-ascii?Q?MezcV+ULTt4vMjMaqX71+QfKDKMA+lucKW6fJl0OXshtsL53ai52eAW0rzbP?=
 =?us-ascii?Q?eFIni3J7CKxARyxWHd29m+Iq1ymxwUkVMKYhntbap/cMrN4FlWaJRSOX9MRV?=
 =?us-ascii?Q?4yJd2zfZFHNTmFWhJBCWJql2ep2IFMqHBg9afI9j6JOcgQqXkaJt+Jmt0o07?=
 =?us-ascii?Q?0jsNIwcYYrt/A9jrzOitcJiefxtlB4viUhigZ2Ds8jrfBF29U9AoMmwDknxL?=
 =?us-ascii?Q?tgEcxUeWWOZyWXcRmO78psKjJnmi1swXutKFdYWqw2wySL6z2XBRBCXW4IlE?=
 =?us-ascii?Q?Ldpll6dMt8YqAxKdiqqmLdo+VaTF2xk+o57zxAlPZc4/KxU6BjrZ0GYRXkl6?=
 =?us-ascii?Q?q6wjzcSDl8YulTiBbewNPdtIlo2Jfb2Wh8uRDfkHRrPdDivksqjkopDttLUF?=
 =?us-ascii?Q?DDL3OLriU6NuYy695w1+9NV3hSexcjLCReSC+CCX1aDUj4bJq8u6hDIP2xSv?=
 =?us-ascii?Q?YwQGQHsD4grrHaSTv9AmyDI5ZsTRkRPgEK2NgUbc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a8e41e4-77b7-4360-b17b-08db2c69bf07
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 13:14:49.3390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1EZ4RgnJR/c8i944coQ7pe/JEU8rN7M1wpCs5MW59+TOZYaoJy8cTpPPfvq1UWAM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7316
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 24, 2023 at 09:09:59AM +0000, Tian, Kevin wrote:
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, March 22, 2023 5:01 AM
> > 
> > On Tue, 21 Mar 2023 17:50:08 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> > >
> > > Though it would be nice if qemu didn't need two implementations so Yi
> > > I'd rather see a new info in this series as well and qemu can just
> > > consistently use dev_id and never bdf in iommufd mode.
> > 
> > We also need to consider how libvirt determines if QEMU has the kernel
> > support it needs to pass file descriptors.  It'd be a lot cleaner if
> > this aligned with the introduction of vfio cdevs.
> > 
> 
> Libvirt can check whether the kernel creates cdev for a given device
> via sysfs.
> 
> but I'm not sure how Libvirt determines whether QEMU supports a
> feature that it wants to use. But sounds this is a general handshake
> problem as Libvirt needs to support many versions of QEMU then
> there must be a way for such negotiation?

Ideally libvirt would be able to learn what ioctls are supported on
the cdev fd after it opens it, but before binding. I don't think we
have something here yet, but I could imagine having something.

Clearly it is easier if cdev alone is enough proof to know that it
should go ahead in cdev mode.

Jason
