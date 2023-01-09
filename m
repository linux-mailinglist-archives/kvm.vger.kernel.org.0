Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6586E662AE5
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 17:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbjAIQKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 11:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235086AbjAIQJy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 11:09:54 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DF73C0DD
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 08:09:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xq/WdrJd5undmUK2pbWpjnJ17rCn+mTAq0LRERZkeFXxLNHAypLrCpJeQLk1xZ3zHG8etnD5413LkumGBHwWOqZT+OuHSIA103QVssA3aErqUqTmBCdmqGDHrjaAFCwjAbEbzgdvHB7vJhZfmzKW0qCBcp9mwOtdw21hd3i0ST0RacQZhgbmXMuqTIKq+0WOJvins3eQR0LlXHoSeWUwVPHPjhlvd1s94/RUPqF8Ln09qoiVBgK9YWRDvtY7opJ23qnS8hBWb7OM5Ruu5p1sjUKiXPGMz2fIeJpbRQoibTW8nceXhecGCBDzkKzd7I+KlB6o7Vja5iPpl4OxGf07og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FSVBPp/SqoZGrIzX8OZ+B5E13pdj7XHXZMYMsb21fOE=;
 b=ANXnfi4tiqy4NxNY/drrwumBS9asMHjk4t2zqfwNVKxbQu1u1d8/sI/QbC7bJiQ0tdCEUi/WZfZJAiFAMx5jjX2XzsZ8soXW0VGo7p+CypDpu3dNeS2ZVYPXE8bq8u3mVnuUJXBYYQUO2uK1/I2HJ6g7HOWhlwQO/003aQ6qTiGq/XwejJeXZr+O2y90iBovYdKuSmortj2+KJxURLtJdRvQRmI7WsFlXZOd+42TlAVBVJOPGTGIivZ8EwVzdRIzieqzrLD3Bmsd7si1Ka7Vz9blZU7vwKJMK9zQ4t+wGRzIP9T6LHOKKrPyDwZzS+g1HefDRZbdlNMR+6Dx8p2zxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSVBPp/SqoZGrIzX8OZ+B5E13pdj7XHXZMYMsb21fOE=;
 b=PPugr/b6xcWKh4+sA7oS9Vb+tshBg9G5q6qE2t7erD44DqEbeu0OSLKNOuuTI2RQs18GQMiMrhwGW7eK5GPAFdrOqQ/qy6aNnX2fHUFT/QI7Wi+JkroZQCXw9gRbn2QHfWGhWGiRZMd0rD69CZlN9Xz3Dy3X1oC5/aOBnhswxBFoFNvFjvqdpcMqUZ4KVpttHW5O5wM1Yhwh7SeGFCkwTdA6K/ZS2kwj1E2dTjm0eAbrpUlHycjb7C0KxCuU3uacmPgMHZxRPuCevWqtKlnp2tmfPtFUxnXS2OVSOIuY2n3Cklvyz9nPvBm4LhezJc5D3pFVLYIJ7Vui78QYlk+7Cg==
Received: from BN8PR04CA0039.namprd04.prod.outlook.com (2603:10b6:408:d4::13)
 by DM4PR12MB5391.namprd12.prod.outlook.com (2603:10b6:5:39a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 16:09:31 +0000
Received: from BL02EPF00010206.namprd05.prod.outlook.com
 (2603:10b6:408:d4:cafe::d0) by BN8PR04CA0039.outlook.office365.com
 (2603:10b6:408:d4::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Mon, 9 Jan 2023 16:09:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00010206.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.15 via Frontend Transport; Mon, 9 Jan 2023 16:09:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 9 Jan 2023
 08:09:14 -0800
Received: from [172.27.11.12] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 9 Jan 2023
 08:09:10 -0800
Message-ID: <adf3f241-0287-25f9-d124-da8f41a4106d@nvidia.com>
Date:   Mon, 9 Jan 2023 18:09:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH V1 vfio 3/6] vfio: Use GFP_KERNEL_ACCOUNT for userspace
 persistent allocations
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>,
        <alex.williamson@redhat.com>
References: <20230108154427.32609-1-yishaih@nvidia.com>
 <20230108154427.32609-4-yishaih@nvidia.com>
 <c413089e-d7b9-8a56-6fe9-73e5b2ef4aa0@oracle.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <c413089e-d7b9-8a56-6fe9-73e5b2ef4aa0@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010206:EE_|DM4PR12MB5391:EE_
X-MS-Office365-Filtering-Correlation-Id: f853b69c-152c-4c6d-0fe0-08daf25be489
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JVa8UdLjR5OhdbVn5AgcSxAJp9BFEpA25BIqw3ySf6pagNQAL1v8hFEkqlh2PwDq8jmVPK6+geP2kJViwNhIRSfgqBcBJ0lIDoMb1j2ZTXGvlpDQAGKFbDSFzGOxxU1pSonS7khOTs8E+MroZfelOaG4Ibfe0ge/49vzUp8HKl9jL5c98g/B4iYcDw/5cUhmO3MfeelxAXphrCmoQgt2NjpEOLQ+7JK/SR5Wl+AazxIyUFyKe+Ph1j83IIevBUW7QBf7dYvHeVSY8Lkj21Fo5pTmeaYvG7OuUcF9W3RC6sM/8NrvXRehK9FfOzp/9tjPZ+Q7HPotN9+HUZpRwUY1MA3GvpVd9Ni591+hVCbDqo8W96jaZZOyKGRkcD8BxhidGFpUZMqGFTsc6OEq3ltEwscSGdsXdncuglwAizU410UM7HHVgndQYO6qg6tYPcMYrBk/FsY96s13SVyuFuCx+K8TRX6SfIm6Kj3TPP2fXk1Pae+lateSC+R5R4L9xWSnYVPxBCDEBUM/9JyPKYkG9v2SQA4Nuj1t67DCOQWEXiyxRJyiFtUTpnkniStgGZPEDayCT9V45YKhoomY9FreCfmW+B2stJiFrDVKqMVq6uVOFgFn777zH+aTAQJ8ZPKJpPKMz7MQekjwvG52JO9v5OJ4vvMT7de73YjhyLtitRr9DKq8w35aW58qQLAtPO2C7TxK9ZGRXr/dffg2aQP+et6+mvdqpyINw2meJ+gUkxvgfzPyKitfKxswgAlgSf2L
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199015)(40470700004)(36840700001)(46966006)(6636002)(36756003)(53546011)(186003)(8936002)(26005)(6666004)(2616005)(110136005)(54906003)(16526019)(5660300002)(40480700001)(16576012)(4326008)(316002)(40460700003)(356005)(86362001)(82740400003)(31696002)(70586007)(478600001)(7636003)(41300700001)(31686004)(70206006)(8676002)(47076005)(82310400005)(2906002)(83380400001)(426003)(336012)(36860700001)(43740500002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 16:09:31.4136
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f853b69c-152c-4c6d-0fe0-08daf25be489
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010206.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5391
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/01/2023 17:56, Joao Martins wrote:
> On 08/01/2023 15:44, Yishai Hadas wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>>
>> Use GFP_KERNEL_ACCOUNT for userspace persistent allocations.
>>
>> The GFP_KERNEL_ACCOUNT option lets the memory allocator know that this
>> is untrusted allocation triggered from userspace and should be a subject
>> of kmem accountingis, and as such it is controlled by the cgroup
>> mechanism.
>>
>> The way to find the relevant allocations was for example to look at the
>> close_device function and trace back all the kfrees to their
>> allocations.
>>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/vfio/container.c           |  2 +-
>>   drivers/vfio/pci/vfio_pci_config.c |  6 +++---
>>   drivers/vfio/pci/vfio_pci_core.c   |  7 ++++---
>>   drivers/vfio/pci/vfio_pci_igd.c    |  2 +-
>>   drivers/vfio/pci/vfio_pci_intrs.c  | 10 ++++++----
>>   drivers/vfio/pci/vfio_pci_rdwr.c   |  2 +-
>>   drivers/vfio/virqfd.c              |  2 +-
>>   7 files changed, 17 insertions(+), 14 deletions(-)
>>
> I am not sure, but should we add the call in the kzalloc done in
> iova_bitmap_init() too ? It is called from DMA_LOGGING_REPORT | FEATURE_GET. It
> is not persistent though, but userspace triggerable.
>
> 	Joao

You referred to the allocation inside iova_bitmap_alloc() I assume, right ?

In any case, we count persistent allocations, so there is no need.

Yishai

