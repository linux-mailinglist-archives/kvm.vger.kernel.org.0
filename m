Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3436641CC8
	for <lists+kvm@lfdr.de>; Sun,  4 Dec 2022 12:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiLDLyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 06:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiLDLyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 06:54:53 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3008917E19
        for <kvm@vger.kernel.org>; Sun,  4 Dec 2022 03:54:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+1PIX+7m05dvb3TWxbZfqOVDIUN8jMaBPtsTxjN3enEq5/oKhU4c4JkaNiFyUqtGsow/zbt3LVcEay3kDHIm/jZLnp9IYFRlao1C3zvtXlZCvwoIO1VzrftJEzdIK28Y74AqRqUrZ6+NBv4VqWOHheZA/vIAhNj3d6x56d/l5hO8mmY9N4X3K1uRfTH0Nxr0r0bl5fFnTbx8NymF23VMeXY/ndeVWsiJ1EFZIqNgmXK7+QZqoB2hIxUITpEN5GjQr1Nh2h94VO9SKHKdxTT2SpAYQsvfkJ5alZJJChAfEimDP6FwTw672InYohshq6lsYP/xDlKSUWZIO2GjvIVvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2gKAJnQFDFWqIEBfj1eKsihB2qS2th5JmT500Br1fkw=;
 b=fMAI64Pc9tMu5GjuEKO6x4aGoL3ruQHJ3BwjE/cN7hPSGyKw/sQqG5Pm2BAyx28CGyx79L5oVXU5y1lPFQHWf7dXPiK3eGQG9yE6rM7QfOun6tDoEJclYg5pDEmUEvCIgdx1KND8kdV4eEF9uuEbSOS9gqmm/MKiTGagPK3Ld1ULwiNqD6cTg80VAOScpAvHdK1IuuKdMQBjJLM1tPVXEHlmVfWIHNERdiOW41FxGpTntER1hv9oVx2/6eTA7KpumwjHqyJlbIXIuXpk7rVxEKX+E3YT1Jphkff7pJXwIYl66Gf/Hgh3fiW3rccJlc5mheNCqZccbiF8VzDA+Ii+SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gKAJnQFDFWqIEBfj1eKsihB2qS2th5JmT500Br1fkw=;
 b=ZPydu6kkEkbsitSyEnHt8hAPCj6ZmS6YpkqTSykAZwMRMcsfdxcr5r7Q5HrIph/LfAC9skv9vnp1BmZWlilozsOEWc/5I/Kb0WB7WdryKpPSmwYK2cMimo31lGfjHL2dM69i3Smz9qCBREaSJs5RptXMj6oX4yQzLURlFXElpgcLssn2p3Ld6rfgCkehaLfNAiVdYfFkoWNpU50ofonBUgRYeohzmOxtKh1mcdCdV5UsVWV1PYZ/w71kPAY3gdg6Az3O85ral+m/JxJBs+tolB3yHZpYp/oAfB+GLn9KyPfUnxbuDcas9te6aBZAMlqdehfCebyiN55qJtVWka7hkA==
Received: from DM6PR07CA0037.namprd07.prod.outlook.com (2603:10b6:5:74::14) by
 IA0PR12MB7650.namprd12.prod.outlook.com (2603:10b6:208:436::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Sun, 4 Dec
 2022 11:54:50 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::de) by DM6PR07CA0037.outlook.office365.com
 (2603:10b6:5:74::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13 via Frontend
 Transport; Sun, 4 Dec 2022 11:54:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13 via Frontend Transport; Sun, 4 Dec 2022 11:54:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 03:54:49 -0800
Received: from [172.27.11.40] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 03:54:46 -0800
Message-ID: <df08435e-324c-6d53-1cf5-bedea040bb2d@nvidia.com>
Date:   Sun, 4 Dec 2022 13:54:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH V2 vfio 00/14] Add migration PRE_COPY support for mlx5
 driver
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "shayd@nvidia.com" <shayd@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "avihaih@nvidia.com" <avihaih@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
 <BN9PR11MB5276C44FA0D38980746EC27A8C179@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <BN9PR11MB5276C44FA0D38980746EC27A8C179@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT017:EE_|IA0PR12MB7650:EE_
X-MS-Office365-Filtering-Correlation-Id: b7ab19b9-4286-4323-f50e-08dad5ee5960
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HeFaOdPIsscHC4edr4cqomHKW2TGzTu4NepUQCa9yWqXToIqeMnElkmcbpVcXeexIcJyN3DioxA8nQobMf8P90Wu13QffriNZZFHJwbn1/S6c8N8KWwXB3MHsdUDX/ffhOanjF/9PWhkemiNxRbM1TrDurR7XLvMGz2o77rDGJWI6Gyad8WAeRWsbvGw2k6dlyQOzGC/jecc6ZZrObfb10MwJ0rey0ei1BKc9xCrlqcVU8faEpXI5/XRUBdCK+tv9t7bXMmA5acLacVJ8yjFayrNni8axqXX2NMmAvjHHKU3pEf+lGN+SnP92b+up0A/OQyYrcLRwxqXxg6LTCFS1fFM6izbqkKIZjfFqq2jJb5vR/uHUm2ms747oA3skWFcNLOoiWehEKgP+ga/Sa8f4M38vBovMFRlNgrwCOj6Xbo5kVQtKHEsKqkNxbg7InAgd6pXysPstq7+6LixNLfyxpzWBI8u9A/X+r6PIxiQZGLC5UNMGK/FrIjE+y/CtnnnS00EvggXgPyz5zOcsq9gzCjxqFHelPEFnENnyA6YJx6UBHL2LMScJMh2xfuF7vclWTrs2asWC7zu173Bc3JntK0C7vXWOD/rqVH8d+RyJCOHcLqZcjOHWfDHWqnPREThi9Wud/ccNtREG90sBUt9gI+9MalX6n95fD8aLPGUPZLRBi8bZ/JqLX4uWz9/qpgMGBUIbJVhnrW5pJByDABMhU2eJtmHVudZdZZ9ke4315E=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(82310400005)(36756003)(40480700001)(316002)(16576012)(47076005)(426003)(186003)(53546011)(26005)(54906003)(336012)(6636002)(110136005)(86362001)(31696002)(2906002)(8676002)(70586007)(31686004)(70206006)(4326008)(36860700001)(356005)(7636003)(40460700003)(82740400003)(16526019)(478600001)(2616005)(8936002)(41300700001)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 11:54:50.3243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7ab19b9-4286-4323-f50e-08dad5ee5960
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7650
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/2022 10:57, Tian, Kevin wrote:
>> From: Yishai Hadas <yishaih@nvidia.com>
>> Sent: Thursday, December 1, 2022 11:29 PM
>>
>> In mlx5 driver we could gain with this series about 20-30 percent
>> improvement
>> in the downtime compared to the previous code when PRE_COPY wasn't
>> supported.
>>
> Curious to see more data here.
>
> what is the workload/configuration?
We tested with multiple workloads which were varied by the number of 
allocated resources, number of VFs on the VM, busy or idle device 
depending on some traffic that runs in the background, etc.
>
> What is the size of the full state and downtime w/o PRECOPY?

It depends on the amount of the allocated resources that were already 
opened upon the migration, and the other workloads parameters as 
mentioned above.

The downtime gain was mainly achieved by sending the initial/middle 
states having the metadata without regard to the size.

>
> with PRECOPY what is the size of initial/middle/final states?

Generally saying, the initial state may include metadata on the current 
state, the middle states may hold 'diff' compared to the 
initial/previous ones and in most cases may be smaller, the final state 
holds the data itself and may be larger.

Yishai

