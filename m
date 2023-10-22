Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613D37D219B
	for <lists+kvm@lfdr.de>; Sun, 22 Oct 2023 09:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjJVHIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Oct 2023 03:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjJVHIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Oct 2023 03:08:12 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9DBE9
        for <kvm@vger.kernel.org>; Sun, 22 Oct 2023 00:08:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZrMzBjwyoDAQtkXE83AyJlqy/O90NDObv0limFP0AlivuHVhbWVueh4e3jJtvbacUbBTiW2WSqaGUaEOrlM2LyimH+jDv/QSnWcWfDgApPfnZYizTkwZGuJXzclr+WD3Yll5jZ+pz2LV+mrWHPNnAwR812oLmRFuzH6wwNnewlb44DO8BY11Gu+0gbClU8gO9Qxo0k6KBKreNuwwBTJR8HmvhnkY06eLNN1YvuPFSxUa9ZJW4g4878w7RNrLcmN+CLcb6uWjc394Ay6luXi2DcBmj6fFzUxlTjBiuY6qk4N7o9jSir2qRXbapTO5+LpLTPg+6EPq+DIZtCp2zvxQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eWf7m4wjWtpRK6UiHcvNofDvywttYo1I5LSoxiiBFcI=;
 b=MOeK0deI/ZJJDbZv8K/ktFfyHGbuJPpzTyw7FvuXwYYEx0UZ+PV81yGlyWssrGD+jH1AfNR4tw1rRLoja+YqXREwjwiN2JJf9kxhp4b6Jhi3BbyY2g8h7qEAHSVZeFaYESP3M+VrCZBDkYB/u52ghE6BKtZrJ07RwiL+dWM2QOzHhQ+NQo7fjtm/UWzcdpsLT2k8s+0VK6rGJFvLq43ppi1tRWAfEjN7T/B0F8kGUiVXp9R8DIkexTvVNXMvyfW98DCXmSLMkwy5deX9T625H8LUxiPgjkHfpzk57q84CwXCu6YUN5n+c3bBaffA7qloZ/AikQCIekic0V057Mit9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eWf7m4wjWtpRK6UiHcvNofDvywttYo1I5LSoxiiBFcI=;
 b=mbDaLkAg6H+DikZUczTMDtwqP9F/JFg2WSeRU0VSt8xnaTRc0ysmufSbMDUVEIGc8v4dS0f4GmTgCi/InGJRutxgp3xm7IqIDwh0zhpbtdSgTB7WiqONRxlCzxtZhag9pvW0gs05ElDvNopm8JN92ig3vFe8uckBwcAKls9wFNUjlzjF9aL/WUVxwdwxXsmRwonLsi1kTnHYc+OlutBHqDS0fYzHf+Gy7GpZjOjOQ0vcMrvwZHsV3LXxuy4TnE87ke10t6BZIqjeYZaIzb0HtK3WsnR53A0i0mu1alwDg6ZaazhDWc8CbhguqtfQY072Jbsncz/W+FETxb301j91Ww==
Received: from MW4PR03CA0071.namprd03.prod.outlook.com (2603:10b6:303:b6::16)
 by SJ1PR12MB6052.namprd12.prod.outlook.com (2603:10b6:a03:489::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Sun, 22 Oct
 2023 07:08:06 +0000
Received: from CO1PEPF000044EE.namprd05.prod.outlook.com
 (2603:10b6:303:b6:cafe::93) by MW4PR03CA0071.outlook.office365.com
 (2603:10b6:303:b6::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.31 via Frontend
 Transport; Sun, 22 Oct 2023 07:08:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044EE.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Sun, 22 Oct 2023 07:08:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 22 Oct
 2023 00:07:57 -0700
Received: from [172.27.13.77] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 22 Oct
 2023 00:07:52 -0700
Message-ID: <b95ff308-9ce3-ede6-dadd-b90344695e8b@nvidia.com>
Date:   Sun, 22 Oct 2023 10:07:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 11/18] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Joao Martins <joao.m.martins@oracle.com>
CC:     <iommu@lists.linux.dev>, Kevin Tian <kevin.tian@intel.com>,
        "Shameerali Kolothum Thodi" <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Zhenzhong Duan" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-12-joao.m.martins@oracle.com>
 <20231018231111.GP3952@nvidia.com>
 <2a8b0362-7185-4bca-ba06-e6a4f8de940b@oracle.com>
 <f2109ca9-b194-43f2-bed0-077d03242d1a@oracle.com>
 <20231019235933.GB3952@nvidia.com>
 <a8c478f1-209e-46b0-9b91-7cd8afccd7ca@oracle.com>
 <20231021161443.GI3952@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231021161443.GI3952@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EE:EE_|SJ1PR12MB6052:EE_
X-MS-Office365-Filtering-Correlation-Id: e15041d0-69b0-4aad-bc07-08dbd2cda40e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dqFG4/XM/+YQdh/PwnsBYRIBiltKm5ynRIS2y5YOnzL+/HX4j2eaI2QIXksEEEeJnbkCEaugP3MtD10kCl9CbdWlp64aA3F6mpUxnIud+cetIckiRbeS20IQX3QVcweaP91ynAY4um30IAlJ5JUMUfaIxX3dOVHujCexOjJEwd4Ghdz5gc1vxPhAzy6AH4eokINIi819vcYxM2w+1OtdQlXFL93d242JVYrrmUaX+sbW+j7/cnqfj67y/Nl0MlHAe2EyW+d6+A/6G+3iyoY+v5YQ93Lkfl7AFAxhhkGiDcWpUgwJ9pYNtwvwrN+B9lvG4wBC3ViLtioWI0N0gRA7mjrfrRMLMZMsdHG87w3vtCVVLY2Ox+LX/3hAvgOVGx3qduYrh/QLd+mbHcsYnz6VBAeHF/Ydr7+UrH/ZlN540ZBstoBdaBhNYAd2fCUtm2QOwV0jj+8WD059pz9UQ7mkRtBxLnvCE01ZV+mmfbYNPC5Z1pzqVlMVyjG/l5aKMvk2eFMaAuU+yB5yYYHU/EFcYaUMQwODa55/yXggEYs3vdreQHvxivE8UF7itwaZd0vWMXE5r/nQdXgM7tgAVl6l3KlUBvUNf/3ujsqQ4rRzmM09DRup82WLqSBqDfF3OAiBxU79WRZW83W1Nuu/eVVf58nifgnC2q9FXahKvw8zk8/VNFTXisMwyCXZKckNSx3RXaNh3z76i0SASyiujwo+UhaSSz2A0nsJjlTU6D00gLZTiZudOhLHecVLNi6G1km+TMUAzdOh/1mnkBfOc6542m48zisEH4WGKEFdpxkLdRs=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(376002)(136003)(39860400002)(230922051799003)(1800799009)(186009)(64100799003)(82310400011)(451199024)(36840700001)(40470700004)(46966006)(336012)(31686004)(53546011)(47076005)(426003)(54906003)(82740400003)(16526019)(26005)(356005)(70586007)(110136005)(70206006)(36860700001)(478600001)(83380400001)(2616005)(316002)(16576012)(7636003)(8936002)(8676002)(5660300002)(40460700003)(2906002)(31696002)(40480700001)(41300700001)(36756003)(4326008)(7416002)(86362001)(14143004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2023 07:08:06.4677
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e15041d0-69b0-4aad-bc07-08dbd2cda40e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000044EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6052
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/2023 19:14, Jason Gunthorpe wrote:
> On Fri, Oct 20, 2023 at 03:43:57PM +0100, Joao Martins wrote:
>> On 20/10/2023 00:59, Jason Gunthorpe wrote:
>>> On Thu, Oct 19, 2023 at 12:58:29PM +0100, Joao Martins wrote:
>>>> AMD has no such behaviour, though that driver per your earlier suggestion might
>>>> need to wait until -rc1 for some of the refactorings get merged. Hopefully we
>>>> don't need to wait for the last 3 series of AMD Driver refactoring (?) to be
>>>> done as that looks to be more SVA related; Unless there's something more
>>>> specific you are looking for prior to introducing AMD's domain_alloc_user().
>>> I don't think we need to wait, it just needs to go on the cleaning list.
>>>
>> I am not sure I followed. This suggests an post-merge cleanups, which goes in
>> different direction of your original comment? But maybe I am just not parsing it
>> right (sorry, just confused)
> Yes post merge for the weirdo alloc flow
>
>>>>> for themselves; so more and more I need to work on something like
>>>>> iommufd_log_perf tool under tools/testing that is similar to the gup_perf to make all
>>>>> performance work obvious and 'standardized'
>>> We have a mlx5 vfio driver in rdma-core and I have been thinking it
>>> would be a nice basis for building an iommufd tester/benchmarker as it
>>> has a wide set of "easilly" triggered functionality.
>> Oh woah, that's quite awesome; I'll take a closer look; I thought rdma-core
>> support for mlx5-vfio was to do direct usage of the firmware interface, but it
>> appears to be for regular RDMA apps as well. I do use some RDMA to exercise
>> iommu dirty tracking; but it's more like a rudimentary test inside the guest,
>> not something self-contained.
> I can't remember anymore how much is supported, but supporting more is
> not hard work. With a simple QP/CQ you can do all sorts of interesting
> DMA.
>
> Yishai would remember if QP/CQ got fully wired up

For now, QP/CQ are supported only over the DEVX API (i.e. 
mlx5dv_devx_obj_create()) of the mlx5-vfio driver in rdma-core.

In that case, data-path for RDMA applications should be done by the 
application itself based on the mlx5 specification.

Yishai

>
> Jason


