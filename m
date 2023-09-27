Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6865E7B0248
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 12:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjI0K7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 06:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjI0K7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 06:59:30 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E31E191
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 03:59:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Whkj+2IOSKR92MZfZoDf+wcd8dpxgJq95vm+hm5KtNTv/LzSmUTCH2tKgSz2VgdKjiIt3/M+ZG0geOSegrq4LyxkLEbcNC/xB+JiEEtQWnGzz6x2eKAfXr3Ec4YIrkv+ZQKTi7y1WuXj0NRDG3yxAxdTwuIgdvUkiD8d+28SGCvHo1LgSnxJesyYurtWGPPOMJTDI6PkLj2DkIUF6gYXjGDDXV82wgxSswcRtSO38SCbv+LBaU2ipi764hr5oHLSpjp8l4WK0pNo3174/Uc4TYYLagQ/pyvdXISmpK82QU46XuOEUW83edPyp6x/G8Di03JIJnxCU6+ZuUvoC+3cjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zH26V/EB0u+o/RzgQ1JMIrT5nHKdlZHFgGI//tTsToQ=;
 b=PSG3x+2fUWVZHgsWNK6gRX2p2hFlWB4uDG2FntRXNivHw7axvQoWlUQs5KEmzmfNfWSdxCaEnNeo2P7l/L7TPXvKCpYtclChRMdQEhtfjsewSk9DWngMcm32toJAaRdoCVjlXt0eV5hpvN6CR3iYKAac8C2/cSvWTauWUHqu4dzWM/ClD9G7rjoW2j3Bx4iluv1uQwr/egfHlO/5q0mkd/sl5xgL6Bqd8bhgBuUBPd4HZEo1a8GNxGS0FS3Bdk9E6I0P0LJa3GuJreT+wtg9lEWXicz/kfputp8lhJhQtOBwa/2cGsxqV/hL37+wCHGKj2rGt+8Ox5asiwV5HJHpRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zH26V/EB0u+o/RzgQ1JMIrT5nHKdlZHFgGI//tTsToQ=;
 b=rplWwzu7g5mNWqmhnW6O7MxRNkLliEoOjGAZSLPWLh7o8SpVKsS1MrYwjD9cu4ZrFFbq2PNU7av1hCxj9RPYp7iZqbpkiVE4TQmscFHq559+fU+o6FHJPJcviZjWs2M1LBXmvoOIR9iiTwd7BPySeEY4oYwgfUu7RBXQfugfA8ghj5xHtAukMIIO/xs/WFdLoKtFsT+F/6lWPGqQbldSfNG6DNZ12QrnGb1vAV10QiO0yFzl/pdMXqXr7d3cbrnZV2GDfUL/fPxszLPGT2lnKHTyeUwFTMho+YKZFa/wt0SAxYTZgnbZP3EvuOF/j8Qk5CglVNpY9zL5OSE83YuYJA==
Received: from SN1PR12CA0090.namprd12.prod.outlook.com (2603:10b6:802:21::25)
 by IA1PR12MB6531.namprd12.prod.outlook.com (2603:10b6:208:3a4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Wed, 27 Sep
 2023 10:59:24 +0000
Received: from SA2PEPF000015CD.namprd03.prod.outlook.com
 (2603:10b6:802:21:cafe::b0) by SN1PR12CA0090.outlook.office365.com
 (2603:10b6:802:21::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.22 via Frontend
 Transport; Wed, 27 Sep 2023 10:59:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015CD.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Wed, 27 Sep 2023 10:59:23 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 27 Sep
 2023 03:59:11 -0700
Received: from [172.27.12.153] (10.126.231.35) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 27 Sep
 2023 03:59:08 -0700
Message-ID: <78298eea-b264-1739-9ded-7d8fa9c7208e@nvidia.com>
Date:   Wed, 27 Sep 2023 13:59:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH vfio 0/9] Add chunk mode support for mlx5 driver
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <maorg@nvidia.com>
References: <20230911093856.81910-1-yishaih@nvidia.com>
 <20230920183123.GJ13733@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20230920183123.GJ13733@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail202.nvidia.com (10.129.68.7)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CD:EE_|IA1PR12MB6531:EE_
X-MS-Office365-Filtering-Correlation-Id: 6befc17c-955e-4bad-a5bb-08dbbf48cf33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 09DqHrQpE0WP3kS6E9RMyZPBH6I27yDCPtI3+vG0pBKtGluB7x/YjcsO4RpzrWr6AsEiN7YAcGm4g46VGIyTQHfWDh3GZdiLd3LZ6oDhXW4yErC4+8P20kvf9+/VIeRMQiakDeF4zmnmrWT7Jfgb/qsRwICU7r6Cd7fu7r4ygSmT5VS6CG0Fli0MgFX4Q1SMFF4P8eW/ZnrGUm+taStDJ/OXVkeyPlvbPgDHRk8subPuh1Sz16Zj6sgo/vskBI/LvdZJl/6BmFLjlCjFvof0I+jbilD6aeKC/feRaPStbC9uVyJraAmIJAdCW+mgVd/jMbGaiof02pOrKI5iKy8K1P2dJukoNGwW/Wf5+hnfbCruQp7csBiLzbMFM3mlsOeibShdeJfbbIv6UfEyajMp8bCaVy8F/MAEO2E/C2n0+joanS7BU0/ob6txjDGvZk7ysb925w5ThfbWx2eOCXhQ0tRAvdgb0AoDHwaM4R7kyFmheA9gtFCddP0VKuQSnm4ym4QqxphcK3hzIByj6PCihXaxAH3LowpXDa3VTilEEnaSE+RLGb1gli3hJP4t8ZP61URSeywMiQqW0CPTnE1F2LbD3lX+Epgc8tNE4SyCSTUjhIVBVg0Y6jBA3BUlSk9kPzsy0tjgDP4oWGGsslONS/aFrUykHIT1qMTuMNNOQAcYveXVEFWlh6lvs8qqJwg/878zQXltdWnrMw7vt0darBaQ8u45+TfBmH+4+ej9emBltzRdXqGaF3N6QeYiSPjCmY1ynqNsD7VratAXtCBVBA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(39860400002)(396003)(346002)(230922051799003)(186009)(82310400011)(1800799009)(451199024)(46966006)(40470700004)(36840700001)(47076005)(53546011)(40480700001)(2616005)(4326008)(70586007)(54906003)(478600001)(336012)(26005)(8936002)(2906002)(70206006)(110136005)(107886003)(16526019)(316002)(16576012)(41300700001)(5660300002)(8676002)(82740400003)(36756003)(7636003)(426003)(40460700003)(31696002)(86362001)(36860700001)(356005)(83380400001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 10:59:23.6626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6befc17c-955e-4bad-a5bb-08dbbf48cf33
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF000015CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6531
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/2023 21:31, Jason Gunthorpe wrote:
> On Mon, Sep 11, 2023 at 12:38:47PM +0300, Yishai Hadas wrote:
>> This series adds 'chunk mode' support for mlx5 driver upon the migration
>> flow.
>>
>> Before this series, we were limited to 4GB state size, as of the 4 bytes
>> max value based on the device specification for the query/save/load
>> commands.
>>
>> Once the device supports 'chunk mode' the driver can support state size
>> which is larger than 4GB.
>>
>> In that case, the device has the capability to split a single image to
>> multiple chunks as long as the software provides a buffer in the minimum
>> size reported by the device.
>>
>> The driver should query for the minimum buffer size required using
>> QUERY_VHCA_MIGRATION_STATE command with the 'chunk' bit set in its
>> input, in that case, the output will include both the minimum buffer
>> size and also the remaining total size to be reported/used where it will
>> be applicable.
>>
>> Upon chunk mode, there may be multiple images that will be read from the
>> device upon STOP_COPY. The driver will read ahead from the firmware the
>> full state in small/optimized chunks while letting QEMU/user space read
>> in parallel the available data.
>>
>> The chunk buffer size is picked up based on the minimum size that
>> firmware requires, the total full size and some max value in the driver
>> code which was set to 8MB to achieve some optimized downtime in the
>> general case.
>>
>> With that series in place, we could migrate successfully a device state
>> with a larger size than 4GB, while even improving the downtime in some
>> scenarios.
>>
>> Note:
>> As the first patch should go to net/mlx5 we may need to send it as a
>> pull request format to VFIO to avoid conflicts before acceptance.
>>
>> Yishai
>>
>> Yishai Hadas (9):
>>    net/mlx5: Introduce ifc bits for migration in a chunk mode
>>    vfio/mlx5: Wake up the reader post of disabling the SAVING migration
>>      file
>>    vfio/mlx5: Refactor the SAVE callback to activate a work only upon an
>>      error
>>    vfio/mlx5: Enable querying state size which is > 4GB
>>    vfio/mlx5: Rename some stuff to match chunk mode
>>    vfio/mlx5: Pre-allocate chunks for the STOP_COPY phase
>>    vfio/mlx5: Add support for SAVING in chunk mode
>>    vfio/mlx5: Add support for READING in chunk mode
>>    vfio/mlx5: Activate the chunk mode functionality
> I didn't check in great depth but this looks OK to me
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks Jason

>
> I think this is a good design to start motivating more qmeu
> improvements, eg using io_uring as we could go further in the driver
> to optimize with that kind of support.
>
> Jason

Alex,

Can we move forward with the series and send a PR for the first patch 
that needs to go also to net/mlx5 ?

Thanks,
Yishai


