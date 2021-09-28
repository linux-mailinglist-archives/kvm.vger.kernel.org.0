Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE75A41B39A
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 18:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241740AbhI1QPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 12:15:55 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:2529
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241645AbhI1QPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 12:15:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgnLPepNhI5yGoddJpK/mRnBlz+SaSC4PY96beCPPcqcsqY4NGcjC58nzgiuI2F8DyY7vmeA4NU4WegB4uyAXKhVnWuZERMUcVcqMxMaIYiu1s4nhF9vRPFhcRT30Aaiu7pubYloEQzA3uE+Gz+GjGNP4XLHVBpNZjBnJGuY1jJaZusaqdbSs9vcqrfAFgddx9opKkkdng/Uvgfm2CRhnHnGGGHicddecbdnaogg4vD/5ssWXT5ddOoLE4nxsKdNjk4KwF9unn/tssLjOTAtsOmaMb6A5PEDxLPcVPLBm79KgcNbFDhhyOdIoGDmZ0xggJwOsc69d5VywE9mxVMAAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SoEstR/57QdSekQedtC6H3sazLzGQWhp578NmDdSDVE=;
 b=W6XU+X4jZ6LBkpnaRvb97hxgFosPCQRqzhWwa5kuKYZPuvrnQtyNKcavP5ENWAIFn2hW14wGlfrG/pTYFbs6xxkdHOwTxh9AbBYd0TRiEO0lbQsgd9pEIEaG6JMVXZHlKzvuDLXlFSrYPgx0Iiwfw0K1OMpyzM54cRGOX6d21djy0QhBpXbAJmTCytTEmM3fbYUPBHofQ4wDY95cNPajNTWrvrVD0FIrwv3kkOvLLDNtj2RHsRqWHkoffzzBVJAWs6opg3sUdKvPAmERotoGBJ8ll/upfYVU4H8OQeYyqszYFd+Wrs4fQcUVM1ktAOCMAtoAZw+YNqRcSkmlWOtrhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SoEstR/57QdSekQedtC6H3sazLzGQWhp578NmDdSDVE=;
 b=EcsAO1oXXfNEEFzbd2VbU2j7vdyuK6MeYiFYyG1Nkb8SIuE0PfL0CuzGf4e+faPCkxeKcZcjtrH2LqC6gwMj5mQ5ohVWO6/1+oFS/SLEyEcDUw92jHQbVo3jCebmv8t61gUBGJ9bF/QdavvBBcoQ/k60vu14ox4bQ7BG72VHsL1f13EUADz3gQ0NWXyhsi6PYwoe8IQqcu3/ZlqwOMck6I62cuKF990sbvsEybNLnX5maQ911cHKR3YqWBjdDrXHOFUYKGTdoVoVdxRH2yVL9sWlEtEB1Vtk2RXhtgnmeH7M5arjAzGHlCOSkOKaBlaooTLsD0/GKpwp0/JZGz1RKQ==
Received: from MW4PR04CA0112.namprd04.prod.outlook.com (2603:10b6:303:83::27)
 by BL0PR12MB2356.namprd12.prod.outlook.com (2603:10b6:207:4d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Tue, 28 Sep
 2021 16:14:13 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::70) by MW4PR04CA0112.outlook.office365.com
 (2603:10b6:303:83::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Tue, 28 Sep 2021 16:14:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 16:14:13 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 16:14:12 +0000
Received: from [172.27.0.114] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 16:14:09 +0000
Subject: Re: [PATCH 1/2] virtio: introduce virtio_dev_to_node helper
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <stefanha@redhat.com>, <oren@nvidia.com>, <nitzanc@nvidia.com>,
        <israelr@nvidia.com>, <hch@infradead.org>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210926145518.64164-1-mgurtovoy@nvidia.com>
 <20210927053121-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <bd0abefb-cc61-5156-f7e9-d07fc9187759@nvidia.com>
Date:   Tue, 28 Sep 2021 19:14:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210927053121-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a751aaa3-fa0f-4ad5-e463-08d9829b031f
X-MS-TrafficTypeDiagnostic: BL0PR12MB2356:
X-Microsoft-Antispam-PRVS: <BL0PR12MB235683DDB39095B3BFD872BFDEA89@BL0PR12MB2356.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R9bou9ax+fN+g1Izwa3ICEPvY+2Aokms9UxMOXgDeKWPvCBHlQQ4gveaDEC898tj8I5xzznNj5RGoY85YWuV3hl858H3pyNu3f/WIFVuXdjKeZSoxhYdVy0sETKbFn4HPvLiLUmGflyr72TDP8Upo9J26A8MIKnNBFb7RIJv8tDw8+NrAk02F/ynNGDSvket+P/ICz4w9u917xVL74p4DlCB2soTSUvrTpcAwNC3q7HhMg1tpTbYdU9DQVSr3MdiLRQMQlczSGoAzdBALqukvPZiK/CTBuuYnPgFyfa57PfXtwtO5nF9wq9xMuMCF00kU0FAXycdnozWT2Jk2qxXGNnMSpgQWHv8Gtl2Slpm1mlr2dOBES/EAtP5rliN9StxOOOmnwxcqe395C4gLZmru+ZOXWhkguNa15r5NbZpzrK2aRKoBjHwEV/hbI3T+o5bOak1Cx0ZFiHBJp+WlbTW8audu6F4YO4wcBTjiKLZK48/WcX/mNviS8UcRkSfJ5Twts9gU5+BPKRuW3gPOeUJOO1P8Y83mFX68snTvz0lD/DFBPfy7zSLiebZHYdIIBzq+vlglnH5WrL0I+CgvOGRbkyd2vYOO1DCEB8Wj55UK4gkZ8uRigYhzRJqyQJ++kaJq61UsVd7FOLV5NU/Ge4U2AiSP3jc0X/9uff7tbuI/+T9E6MvF5t5rwXdoU14tfJ1FNCwqNKXntd97ye8BK2XnbPMb+bpjXEXP/OC8RlyDN0=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(47076005)(6666004)(6916009)(70586007)(426003)(36756003)(8676002)(54906003)(336012)(31686004)(31696002)(356005)(26005)(70206006)(53546011)(36860700001)(86362001)(8936002)(82310400003)(186003)(36906005)(2906002)(4326008)(7636003)(83380400001)(16526019)(2616005)(316002)(508600001)(16576012)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 16:14:13.2330
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a751aaa3-fa0f-4ad5-e463-08d9829b031f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2356
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/27/2021 12:31 PM, Michael S. Tsirkin wrote:
> On Sun, Sep 26, 2021 at 05:55:17PM +0300, Max Gurtovoy wrote:
>> Also expose numa_node field as a sysfs attribute. Now virtio device
>> drivers will be able to allocate memory that is node-local to the
>> device. This significantly helps performance and it's oftenly used in
>> other drivers such as NVMe, for example.
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> If you have to respin this, it is better to split this in
> two patches, one with the helper one adding a sysfs attribute.

It's not a problem, but it will cause the first commit to include a 
method that is not used anywhere.

I'm not sure this is preferred but I can do it.

>
>
>> ---
>>   drivers/virtio/virtio.c | 10 ++++++++++
>>   include/linux/virtio.h  | 13 +++++++++++++
>>   2 files changed, 23 insertions(+)
>>
>> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
>> index 588e02fb91d3..bdbd76c5c58c 100644
>> --- a/drivers/virtio/virtio.c
>> +++ b/drivers/virtio/virtio.c
>> @@ -60,12 +60,22 @@ static ssize_t features_show(struct device *_d,
>>   }
>>   static DEVICE_ATTR_RO(features);
>>   
>> +static ssize_t numa_node_show(struct device *_d,
>> +			      struct device_attribute *attr, char *buf)
>> +{
>> +	struct virtio_device *vdev = dev_to_virtio(_d);
>> +
>> +	return sysfs_emit(buf, "%d\n", virtio_dev_to_node(vdev));
>> +}
>> +static DEVICE_ATTR_RO(numa_node);
>> +
>>   static struct attribute *virtio_dev_attrs[] = {
>>   	&dev_attr_device.attr,
>>   	&dev_attr_vendor.attr,
>>   	&dev_attr_status.attr,
>>   	&dev_attr_modalias.attr,
>>   	&dev_attr_features.attr,
>> +	&dev_attr_numa_node.attr,
>>   	NULL,
>>   };
>>   ATTRIBUTE_GROUPS(virtio_dev);
>> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
>> index 41edbc01ffa4..05b586ac71d1 100644
>> --- a/include/linux/virtio.h
>> +++ b/include/linux/virtio.h
>> @@ -125,6 +125,19 @@ static inline struct virtio_device *dev_to_virtio(struct device *_dev)
>>   	return container_of(_dev, struct virtio_device, dev);
>>   }
>>   
>> +/**
>> + * virtio_dev_to_node - return the NUMA node for a given virtio device
>> + * @vdev:	device to get the NUMA node for.
>> + */
>> +static inline int virtio_dev_to_node(struct virtio_device *vdev)
>> +{
>> +	struct device *parent = vdev->dev.parent;
>> +
>> +	if (!parent)
>> +		return NUMA_NO_NODE;
>> +	return dev_to_node(parent);
>> +}
>> +
>>   void virtio_add_status(struct virtio_device *dev, unsigned int status);
>>   int register_virtio_device(struct virtio_device *dev);
>>   void unregister_virtio_device(struct virtio_device *dev);
>> -- 
>> 2.18.1
