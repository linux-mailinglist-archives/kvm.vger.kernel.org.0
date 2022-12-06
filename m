Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682A1644D97
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 21:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiLFU5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 15:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiLFU5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 15:57:08 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1547E40456
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 12:57:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZA/vonXEAK0rtCj9YOJrtYDje07I2aFik4oan4qcaFDanzUUOHu9sF1JO6Q9pgXw6R74ZZIs6JIhmjBrDf6YkVhJNzlVng8IA+jijCZbCpEEF30mmzLpn4xhkUTfsL62ieIH93wDW5PO3+HWmV4sVZlmd/BBJKRf1o59Sh4mzjyCP9ndVoLXzgbMjmOfIqYsSDx44XNydc2FfhPD5O95w/ESasY542El29rN7Fg8HGsSZBgWtUIl5b2W3QbSOtYbAHV1dGhO304iXd+93laKsjHzP2Q1UE5eLe2ZgNkZu2jSAIFQDBIxkH6Fjkzmca+g+0iq0sjb/tE4zEib6c10Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2ND3+kNI1iih93kxw5eGpkGBTfimvwmcMXAqKwynt4=;
 b=abn72ud+MYzle0ZqDHtcUef/dEgzaRvmyagmHEW8dJJPpIahMxhpF3ZvofuTkmslRHt5861aCgpYhN+Xu/hZEyvvNwAiJU0f8FmK1IE7idFiMFBxGRZK3gr4JhNexrBjRnrnscVODoFrBNEETUfdUt6XV6llRUKp0nLl9a9RSDiO9UkfsOiSnJ29AxW/RUVpfy8Xb9i0ag3K6iHkMqft+tMC/jmt3U5GdzpeIXQhV3uJfLLVs1RQ2WibUc8/gTmZ8qjz+YwjIalX/d71/zPpDAu7WyjFhwpd7UJOKhnyhLm5nsIYwT5pY0gPBU09m2WuW6EgpFy/BUwyLppPwSVf2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2ND3+kNI1iih93kxw5eGpkGBTfimvwmcMXAqKwynt4=;
 b=lyAI3SWd/kUnBg91HFd3wIoF8CAVo88NdWUhCF+wNe74kkzR6XvjjRom/9u+7oo/QhUiLaN7Cu4ixm5mlVsmk27LpT3nxxwdjw3yABdC8henFdqFC8d760CbinLQBNYCAc0urt8CBTLQOmpaTjg/oYFYFO3TM5wyIvvqT5J4GdFcloRoqTkL66p527y5vOkflGgBP2pIjlw5JwgYtdkZtOTQW9o+RXrJRc27qYnj3Kf3+biU8Oz7QvIoOl7DE5OhqEbRXWhosm4j5JUiIb7S0VtSh76vWagc0qabrhSfxkpysbKlfp7Ujvv+O3X+s47TJ+69gzvUPVl8D+iUCGMTtw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 20:57:05 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 20:57:05 +0000
Date:   Tue, 6 Dec 2022 16:57:04 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH v6 08/19] iommufd: PFN handling for iopt_pages
Message-ID: <Y4+soHUcUxGiaMBY@nvidia.com>
References: <8-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
 <235bce13-9855-940f-d43c-cec60f0714dc@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <235bce13-9855-940f-d43c-cec60f0714dc@linux.intel.com>
X-ClientProxiedBy: BLAPR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:208:335::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5229:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b828c07-f133-4c6a-8608-08dad7cc6ea9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ALDNqdFQQXccGZFjLezZVLOidfTj8WGPd8HNIrgD2CYe2cwaAGhql7XvYLiwuXgwXHM7e8q+a7UDE073ZJryy8LBQIS9q5AuNqmP86fIlpnecLd2R1WPt3PQxWzZwH8/UsVSPpaLoRKcF2tq40NJNle2aJAp2Vz1OKev4wUafkysM6iLv03PIs3uZN9x4ZMlC2fXaN9cjOog/xkproS+cIUGAsXoOn7l+ndyUXAIInKTdYHQf5jP7NpgK6KSLGyxBqPMCHAtyEaAwIDswO+OjfNwh6rQ+w4L34KjCzlhBFYGoVi1+055zvYcoRTNSmVOaGqc4uAeuHMLiSVmbVSUa9END0H58vtNCuTwTGx4mxSJIO6JiK5Re2UnCzMrLeMzhl++t4AEuhE6Gg7gO1enpGjztftmfZJU61K7FnuP4toQJfdE2jHmd+c72EYsUB3bwwEztrx9iIR07+Udi0GJWfl0toF4VsEyQbf5Oqs/GNI7yzzVD1YD+MWsRF90dlUxPZ9K2ouUMdLIQqzA8E0FUti2zhAbDK1YU4wQuEyAAmtUaFyBtWeOL04TiRJJXv84TniCkE3aMXGVAD8qsSb53QJkRGMHS9Njn4uOIZmvWurz1gDJspeWkPIUN6Y3Bca/VYMybn1PYHU0mksAahiUsYyJBNYZ9eBDCGnDwKnHQD1CZxa5YGKEwwbW2s4EqPZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(376002)(39860400002)(366004)(451199015)(186003)(316002)(6486002)(6916009)(54906003)(478600001)(86362001)(36756003)(38100700002)(6512007)(83380400001)(6506007)(26005)(2616005)(5660300002)(2906002)(8676002)(41300700001)(7416002)(4326008)(66476007)(8936002)(66946007)(66556008)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xwp4n9TC55J9QYAvgY/BS7cdTK1ihCslnRvRhf7HEpQvJUcaGhN8oyCsDEKK?=
 =?us-ascii?Q?Ehw7FxAagw0Yu1SUCxp3jxMN6IPBuDsi7ON1woA2/JadwMBfY98iIFKv3eBr?=
 =?us-ascii?Q?ESx277ZO2vSik0pwyxX87Qd8HOpY+mD3PVEzHl6KRnliJNG67g4SOW98bwht?=
 =?us-ascii?Q?b51AjaxU6/oCBmYZdebchtgLUJ4JWZC2N6dvosjqR/P7RWO4/q51vjsWhCPo?=
 =?us-ascii?Q?6DQpfKRHUx8DIJIZ0s9jjt4xP63VWnErXMzZh7o7VyuZIr3Y3EggXI9zy74e?=
 =?us-ascii?Q?qEecU9kscOJ3+OmGg/k4dt4axannSroGO5Al2fTwxd7aKmj4+3m1FBVaYl4c?=
 =?us-ascii?Q?iiLt4uOc44eaFNngvrhztsmD3z6FNqOtipS2CaX1FVzNGWL3QSu/KXnIvVx6?=
 =?us-ascii?Q?y9syWhYn/uI8ZCWm/TVMftttb9tKh/FcU8UHvD/LkigJVaOU4T2FKs44xGpU?=
 =?us-ascii?Q?LIIzLvygwFlVTlzaj/9PCoop3X0omPK1rqDL1pCvWOCjT16l4WJp7S/l7SNr?=
 =?us-ascii?Q?brWxKuP1OOLJtb8YgQKXfEG9xpIWNWLoyqlEkVs5v2pkyQXJdaQszAY0gPa/?=
 =?us-ascii?Q?vlnKuATYhmRXRcUpxk40QZcqbEUVWPqzj35UVQEoG3jyuRibWiwHJRYmGtWv?=
 =?us-ascii?Q?nePoGmrTmIUtWWatB+4Pc60wByjuH3a9MqDUFG/XYakjK/XHxwQ1PaQj9zPI?=
 =?us-ascii?Q?nG0Vbz8SHmVP2dyKKAgSVHaA1dOVCUyMDoBeM9dTWDG+9fBpb5ZhE5KcBQ40?=
 =?us-ascii?Q?KkVXzbUc7WICRbfO0cmlzFTZ4TZfHfPgVhMhROEAZGZv/Q/h8H4ls/GmHl8e?=
 =?us-ascii?Q?4N9Bwk03I1d0E6VbEUQinz/cyaYLSR0L+9/ftHot8IeF2XY41vuSntiyAghJ?=
 =?us-ascii?Q?oAnVRIo5uotRvK6ZoNSL0cB7JFUqO7CYyaAfweIaElmfj/lzzELqRMbHMET8?=
 =?us-ascii?Q?c84YG1H8WgeecyZrQTHpyJ+eAsTtWuZ8zVqiRAdOeUKPTYo4lt01rqfk0Kdy?=
 =?us-ascii?Q?ZNWS4YghiZGx5yjfD94XVGP4Nar9mWF4I+ToxJcvW8vMIFikqVYe/6nBop/3?=
 =?us-ascii?Q?ymNkcV3n39X6mmJbQDt/izNu52o/uS4KOVzbPk2KmR12Dfpe64//lOt7suOK?=
 =?us-ascii?Q?rt1E/FC4RbfyciX3/zJHwD9Wf8xBhVMDF0MSTeOsuBF5GcBc6+1BkeoJmpru?=
 =?us-ascii?Q?wXYCW4uQq13MA8Ld1tfxOEh7Ss/OTcZ4cy3Y+e0JbOjaeYgbKrjepzXvcajC?=
 =?us-ascii?Q?A/ucAHSLAY4yNPYzMRO6K6BGmxX8TnINzsvcphXRr/uOzfTxPsZZfckrWnYx?=
 =?us-ascii?Q?5eKhNNUEDr8a+1Fz8UFimhQc5Rdb8nBskjp+iAUAjqg0VchANA8N6i1p4SpS?=
 =?us-ascii?Q?BN0dSsXxvXATfxIBfKg315tlw9DTD87w5u2lpwkbLjoIJwN8gTnHtHy9Br8G?=
 =?us-ascii?Q?OLpdPQh1zA89rkbFYYec8BHfylRVB3OcsIoLhJJQf5/p4hO2zTZqIFL/Mc3B?=
 =?us-ascii?Q?UuJ7V5lBej670Aki1yncBvo3GFeYNSRwpVnCNB8YbzCguWTXmk1oSCkvNak0?=
 =?us-ascii?Q?vJ0KVZmDCDIE4rSzPJM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b828c07-f133-4c6a-8608-08dad7cc6ea9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 20:57:05.7343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EyUdi/vVciFFa2cBDfyo99rl7fiGq1HU0gQGAeEUHJZ/dKAyUERdRQBIne35/ENJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5229
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 08:36:20PM +0800, Binbin Wu wrote:
> > +static void pfn_reader_user_destroy(struct pfn_reader_user *user,
> > +				    struct iopt_pages *pages)
> > +{
> > +	if (user->locked != -1) {
> > +		if (user->locked)
> > +			mmap_read_unlock(pages->source_mm);
> > +		if (pages->source_mm != current->mm)
> > +			mmput(pages->source_mm);
> > +		user->locked = 0;
> 
> Set back to -1 is more aligned with the definition of the locked?

Ok

> Although the value doesn't matter due to the end of lifecyle of
> pfn_reader_user.

Yep

> > +/* This is the "modern" and faster accounting method used by io_uring */
> > +static int incr_user_locked_vm(struct iopt_pages *pages, unsigned long npages)
> > +{
> > +	unsigned long lock_limit;
> > +	unsigned long cur_pages;
> > +	unsigned long new_pages;
> > +
> > +	lock_limit = task_rlimit(pages->source_task, RLIMIT_MEMLOCK) >>
> > +		     PAGE_SHIFT;
> > +	npages = pages->npinned - pages->last_npinned;
> 
> The passed in value of npages is not used?

Ooh, that is a mistake this line should not be present

However in all cases the npages is equal to the calculation so it is
harmless.

Thanks,
Jason
