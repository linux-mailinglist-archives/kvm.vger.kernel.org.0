Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298704011ED
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 00:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236681AbhIEWWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 18:22:22 -0400
Received: from mail-bn8nam11on2080.outbound.protection.outlook.com ([40.107.236.80]:61297
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232617AbhIEWWV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 18:22:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwIJoWMnmiJC92jDdH9N3cMMqEVLxdO9+6QnRUUQf2Rs4B0LXNIpZMWoYHYTUUAlEjvZta+NDnkAH1VtpMYCtrory14ftO+JK8fVgx4E06/vzcRsXumZD8hSbNnx57RUlyYKsl2CdW/WXyGRiSH2u4Ojm+KUG8UrHa5OZdB8hTkKry1IoM+ZHch7o1+3IMy3ZSvYeuM7uykRNRAwqukdUjBIqCWEJ888QYfzvW9u34eOgFnA4XOAw7ZaOEp+g5BdLUCSZD4rPActtyyvDHo5rH7d3Wdd8FIR3jgXO0Oj98yl6jkGoVblMf1eNh6tkj7NHm5PyBWraph7ogVuS9Z4zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jWGdwH6ht//CC0tk8nyEqsG+qD6gMGYuZA5xWVv4VFo=;
 b=EgQMI/Sc3YyRajDZs0aUa5fQlyKFFUUO88IzgVLUz/EwRY+ae/xeZ+r9CahkmiwDhbvddpyjIzDI5UYxDd1zc/Pon/7xmggdZYKMdkjA2rLQEyB8+xJ9jc+YYzAbk2Q/JpuGCshSF61XVPDW6KXXbKnOLLaL8VWVymRuZiAR7vGz0kJnF9UIgHQeXyZG7rZo3ND10tpKcBjrhhoppO0Iuh0IZbGQeM2b/8Vc5dTEGdTxYx8xAs3OUeGcc3RX8dvN97etHVj2CKOvg4v9bjtGyZls7vX63ARZRrEa2C/9RUhZ0RXm8FLKBFqR1hxMm9Fn/06VCUY88y0MjbARlBmdHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWGdwH6ht//CC0tk8nyEqsG+qD6gMGYuZA5xWVv4VFo=;
 b=HBc6HBYWJhsjFd6Oss9Z3d7D8vmTs2/QXHIVWYThgNfr6TFpG61S2aD37AmjoRAUikkPZ0Fh5OQs+4bGtlzQQsN6jKrGiNVD6iJP4KfCgtI/A49kbIx+bt71IdRSkx24W3j5OCdGm7ppy0gQM2WXb6tZHrMdTmDNMuPZQO/tirQyrw+J+DRcV4jzD2EPCyUiIRqmXEcRhaRl2DZghYB4jvW9L7xc55vBVziAE+71+s6dWMin9Y4jXeYChAN/SmUJl44zwFuRPMk/gZ7gHXThFu4ulKreEpC1R3zEngbL3OCxmAIpDJ8WieC7yQaAgH/aiekcArxDtTts1jFr/FvOSw==
Received: from DM6PR01CA0021.prod.exchangelabs.com (2603:10b6:5:296::26) by
 DM6PR12MB2844.namprd12.prod.outlook.com (2603:10b6:5:45::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.21; Sun, 5 Sep 2021 22:21:15 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::ea) by DM6PR01CA0021.outlook.office365.com
 (2603:10b6:5:296::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.20 via Frontend
 Transport; Sun, 5 Sep 2021 22:21:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Sun, 5 Sep 2021 22:21:14 +0000
Received: from [172.27.0.7] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 5 Sep
 2021 22:21:12 +0000
Subject: Re: [PATCH 1/1] virtio: add VIRTIO_F_IN_ORDER to header file
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <stefanha@redhat.com>, <oren@nvidia.com>, <nitzanc@nvidia.com>
References: <20210905120911.8239-1-mgurtovoy@nvidia.com>
 <20210905110804-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <beab43c9-1264-8302-d945-006b4c82e46e@nvidia.com>
Date:   Mon, 6 Sep 2021 01:21:09 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210905110804-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ff48c21-6064-4c29-8b86-08d970bb7987
X-MS-TrafficTypeDiagnostic: DM6PR12MB2844:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2844238D56E809C9AE9FD803DED19@DM6PR12MB2844.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xJKlSqwcNrtQPajnLY8i7HeG1LImqs5tZN07Wytnv0KZzQXyi1g+biObS1pIpbsj2kfigkWXBneBrL6ESGR6yUKENaMBIVU9n1oTytOW/NSa2JDKefttmHAu05i9Dg3ssTaLtYYItjedQGpMWj7w61XexpHGX1LV0pkqMiASELttRhJLwmxyEZPADQopvrnWb0+fRMuk+CjhQAUHCA1gjJlAs4M00mtTh1FKLh3pEDmdh2do6yKqC7fy/jveeRvKEQR6qf9IVndYBZs8QYOGUYwjjol8g+O2cQZNrANIhwi4GIsfSZWY+siUtC8HXTJXweU4XnYiBhAWe/EKN5rcRBopr6Gf2cP2L8OeKMiROxgXHVT7OoXk/TkZB1gzdMpUcNWYiMilgN5MUFHMJPFh147L2dGQA6P6sD2FJuKIspNGkU72rpaPz9tiIeWUwRYiGsn/Ku7jVj5Gtb7NQjefMgxB8JsT64gApP/iO7+RzgeTzrB8PZlxIj1cS+LkH3MCSf1wnSFzIaFz0Tq6QorNSgt+F2XtLSCS4cwVCnRtT3POhm8RfZRsG4uy3WRs7VXLfseLPnIOuV8yIhULfcODgoiQDxHa2jyhxzP6oVpn27pIW8XaP02rI2xplBwm5JJ314N15Y1yScgUV27pV+rWXDXVYMZQUneHgFSf1jD8/bBvxaxzR+68kguFeUx6Yekx38lV9q7qZp6H32QsmrUDl3mkzJZS9cNKwMR6wSkKjZI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(136003)(46966006)(36840700001)(53546011)(54906003)(2616005)(36860700001)(83380400001)(6916009)(336012)(426003)(356005)(8936002)(16526019)(186003)(7636003)(8676002)(26005)(36906005)(107886003)(5660300002)(2906002)(31686004)(4326008)(31696002)(36756003)(316002)(16576012)(82740400003)(86362001)(6666004)(47076005)(478600001)(82310400003)(70586007)(70206006)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2021 22:21:14.8687
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ff48c21-6064-4c29-8b86-08d970bb7987
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2844
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/5/2021 6:09 PM, Michael S. Tsirkin wrote:
> On Sun, Sep 05, 2021 at 03:09:11PM +0300, Max Gurtovoy wrote:
>> For now only add this definition from the spec. In the future, The
>> drivers should negotiate this feature to optimize the performance.
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> So I think IN_ORDER was a mistake since it breaks ability
> to do pagefaults efficiently without stopping the ring.

I'm not sure I get it.

I wanted to use it for improving performance of a virtio-blk device by 
coalescing many completions to one interrupt.

> I think that VIRTIO_F_PARTIAL_ORDER is a better option -
> am working on finalizing that proposal, will post RSN now.
>
>
>> ---
>>   include/uapi/linux/virtio_config.h | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
>> index b5eda06f0d57..3fcdc4ab6f19 100644
>> --- a/include/uapi/linux/virtio_config.h
>> +++ b/include/uapi/linux/virtio_config.h
>> @@ -82,6 +82,12 @@
>>   /* This feature indicates support for the packed virtqueue layout. */
>>   #define VIRTIO_F_RING_PACKED		34
>>   
>> +/*
>> + * This feature indicates that all buffers are used by the device in the same
>> + * order in which they have been made available.
>> + */
>> +#define VIRTIO_F_IN_ORDER              35
>> +
>>   /*
>>    * This feature indicates that memory accesses by the driver and the
>>    * device are ordered in a way described by the platform.
>> -- 
>> 2.18.1
