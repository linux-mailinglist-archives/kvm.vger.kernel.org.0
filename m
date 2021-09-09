Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49924405A6C
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 17:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236201AbhIIPxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 11:53:14 -0400
Received: from mail-co1nam11on2065.outbound.protection.outlook.com ([40.107.220.65]:22574
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231974AbhIIPxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 11:53:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQYGUaWvyHmKV5kfWEg+sdhrMAASvn9+ar2EO0IbSXX9kCPCVgLNoaGBSM9Wu9yOhV5+G2z2usniQSiOuw7cTiCvg21YfRFEenHVVeP9p46/4kq5WBszgEI65wlzyQNM1YqvivKyBW7NoUncVGbXRN+C5J7h81qZ7TDvDXpTPW6kCemHCLN717Mz4qF5K7YUM2QYcKYeK+YCUhM4YmWCBTDG7w8b3siIGBxTjwgHSwQ9TIYSJSaA4IRZiQUG+4PDHyUygFDtLDXvscE7zcQ7IWYWPHXob0mh53ZdEOsr496IIJi3HKE23S/cIU8HhYmDNwHcWiiM8NTdIeaNFcNnxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=J9zjW2lpl+zLneyuH9Pg5FhWW23ntlnepYXQT/x+kFo=;
 b=Iytx8V03qKylLDb9I4keq26UHpllaYndMP7iaPe25V6vZmWi35Sih8fpgyuVHlpuwKFRWwzxYDyGCBpOygwDcGnYNdWBzbgOXy+s7QibaF9au+0XQ/63URfp3Xo4jCqG+9HnA7eU+lrN6jOAuCHebc4Hd05Ni95ll69z/DFjgCvZ+6Hj61gQW5ikBdWglhhHOtlGWXS244XhFX8OeksDIjbuy/2cxaPnaUHrK+Hmj/Tshn0ExfkzNHU+5ier273zS7EBs3724FJl+GWUUviWFk7G2FYZz96fvD88VVxMlkVSorCi0wpw94RDtxBjxYMkKoWgqlC8Bp7LdZHwk9DXbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9zjW2lpl+zLneyuH9Pg5FhWW23ntlnepYXQT/x+kFo=;
 b=Kfu0lonU4p/dCwsX4WXNMqSwehW0uS+XQjqdujOtTQDVg+aiGjyAKR7LNcbUTu1iadvv1RGWk/3AOPJ5rYpj4uBSrmXocjnhuWXsMd6M84P6qoBTwEdMlqZ9rhuw3kLVUSMeLpP0Gd6g92G1u0y9FbPzZmeGxx4LRQKG/oXJAQ06gkY49ckrI+6Kp5vK+WM1MALoc6SKau8r7ipcWzf3E34eVowVlun1+JkRhoG4keHt66k0X8GWtEXfLYAto6ksWFmRX6bNBSaFKh/40kcKbvTCB9PuohZRQOe+5GCeepND6klqRrddvQzYVWRJIcddWdx7TckcMe4ICHF3mjv/ww==
Received: from CO2PR07CA0051.namprd07.prod.outlook.com (2603:10b6:100::19) by
 DM6PR12MB5535.namprd12.prod.outlook.com (2603:10b6:5:20a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.15; Thu, 9 Sep 2021 15:52:02 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:100:0:cafe::8) by CO2PR07CA0051.outlook.office365.com
 (2603:10b6:100::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend
 Transport; Thu, 9 Sep 2021 15:52:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Thu, 9 Sep 2021 15:52:02 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Sep
 2021 15:52:02 +0000
Received: from [172.27.14.161] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Sep
 2021 15:51:59 +0000
Subject: Re: [PATCH v2 1/1] virtio-blk: add num_io_queues module parameter
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>, <hch@infradead.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <israelr@nvidia.com>, <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210831135035.6443-1-mgurtovoy@nvidia.com>
 <YTDVkDIr5WLdlRsK@stefanha-x1.localdomain>
 <20210905120234-mutt-send-email-mst@kernel.org>
 <98309fcd-3abe-1f27-fe52-e8fcc58bec13@nvidia.com>
 <20210906071957-mutt-send-email-mst@kernel.org>
 <1cbbe6e2-1473-8696-565c-518fc1016a1a@nvidia.com>
 <20210909094001-mutt-send-email-mst@kernel.org>
 <456e1704-67e9-aac9-a82a-44fed65dd153@nvidia.com>
 <20210909114029-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <da61fec0-e90f-0020-c836-c2e58d32be27@nvidia.com>
Date:   Thu, 9 Sep 2021 18:51:56 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210909114029-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c84d703-05e0-4f89-732c-08d973a9c423
X-MS-TrafficTypeDiagnostic: DM6PR12MB5535:
X-Microsoft-Antispam-PRVS: <DM6PR12MB553594BEE3B847F2A93D3723DED59@DM6PR12MB5535.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: scc+7eZFxTwUHnp+aR62v7I9q4CL7jRMl/0VETL99YvEfgKHFA3vUXDMJgH//AHHllel7uW0tYI7rPB+HgH+HziFUutezCsPztbfhMDi2JU1lclajZiPKK3S3zHzuJ2aU+odr/QkLVTbe81a77N25ETW928r1iEYOSL+i31DWzr9BdRPMjyWitwFdK1M9+dgIXYiT8DGah+g46yeVW0o4//x2w/aejw3PgH++3GCxfeaonZX/6vbRS4KYLUbVut0R9T9kZFH3iTpJ/1mn1bPT9211uJwM+H7k4xbzIHftCe2jVKEWEL899d38L0+d1R0XaTCCagUsk7zn6vyH9OFKOI3e5S1sZtj31Zo9Tib1S2X70wQKtllu6881N4UbYSLTuPkdK4fQspB6WOUfv2bO5IokxLwQchiBKzxgt97YZRVRgO/l0Y/8MOSOunML3KcApPFVluF8q8YuT0KoGZd2AEvQG/d8Wny510VWo8sWAyl+tMff4bnLS95XGhwsi/MmmZfbAEM2h2R6S+89iYvpABo0Juhxm8t+0dlsZ/g/e88O3MQPRtwmMAwE4GFbDSLpk0TxwyT7GolQq4HmCfMYu728MQslz9ZCu8W3w25Tx0N2BLZQ9KuoaN5KQOKf0M7d1RkcKR62vZLuYGqF08VyTrb6DTllnV0pATR3JjxovuowudQtC5Eil3wthhbsTI4jh/myyjiHLDlKRkLwXbeT+4+lyi0wccnzlq8Q98J5vg=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8936002)(54906003)(316002)(8676002)(356005)(2906002)(16576012)(36906005)(7636003)(53546011)(16526019)(6666004)(26005)(86362001)(36860700001)(82310400003)(186003)(31686004)(70586007)(508600001)(5660300002)(70206006)(426003)(2616005)(6916009)(4326008)(31696002)(47076005)(336012)(36756003)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 15:52:02.5881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c84d703-05e0-4f89-732c-08d973a9c423
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5535
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/9/2021 6:40 PM, Michael S. Tsirkin wrote:
> On Thu, Sep 09, 2021 at 06:37:37PM +0300, Max Gurtovoy wrote:
>> On 9/9/2021 4:42 PM, Michael S. Tsirkin wrote:
>>> On Mon, Sep 06, 2021 at 02:59:40PM +0300, Max Gurtovoy wrote:
>>>> On 9/6/2021 2:20 PM, Michael S. Tsirkin wrote:
>>>>> On Mon, Sep 06, 2021 at 01:31:32AM +0300, Max Gurtovoy wrote:
>>>>>> On 9/5/2021 7:02 PM, Michael S. Tsirkin wrote:
>>>>>>> On Thu, Sep 02, 2021 at 02:45:52PM +0100, Stefan Hajnoczi wrote:
>>>>>>>> On Tue, Aug 31, 2021 at 04:50:35PM +0300, Max Gurtovoy wrote:
>>>>>>>>> Sometimes a user would like to control the amount of IO queues to be
>>>>>>>>> created for a block device. For example, for limiting the memory
>>>>>>>>> footprint of virtio-blk devices.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>>>>>> ---
>>>>>>>>>
>>>>>>>>> changes from v1:
>>>>>>>>>      - use param_set_uint_minmax (from Christoph)
>>>>>>>>>      - added "Should > 0" to module description
>>>>>>>>>
>>>>>>>>> Note: This commit apply on top of Jens's branch for-5.15/drivers
>>>>>>>>> ---
>>>>>>>>>      drivers/block/virtio_blk.c | 20 +++++++++++++++++++-
>>>>>>>>>      1 file changed, 19 insertions(+), 1 deletion(-)
>>>>>>>>>
>>>>>>>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>>>>>>>> index 4b49df2dfd23..9332fc4e9b31 100644
>>>>>>>>> --- a/drivers/block/virtio_blk.c
>>>>>>>>> +++ b/drivers/block/virtio_blk.c
>>>>>>>>> @@ -24,6 +24,22 @@
>>>>>>>>>      /* The maximum number of sg elements that fit into a virtqueue */
>>>>>>>>>      #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>>>>>>>>> +static int virtblk_queue_count_set(const char *val,
>>>>>>>>> +		const struct kernel_param *kp)
>>>>>>>>> +{
>>>>>>>>> +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
>>>>>>>>> +}
>>>>> Hmm which tree is this for?
>>>> I've mentioned in the note that it apply on branch for-5.15/drivers. But now
>>>> you can apply it on linus/master as well.
>>>>
>>>>
>>>>>>>>> +
>>>>>>>>> +static const struct kernel_param_ops queue_count_ops = {
>>>>>>>>> +	.set = virtblk_queue_count_set,
>>>>>>>>> +	.get = param_get_uint,
>>>>>>>>> +};
>>>>>>>>> +
>>>>>>>>> +static unsigned int num_io_queues;
>>>>>>>>> +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
>>>>>>>>> +MODULE_PARM_DESC(num_io_queues,
>>>>>>>>> +		 "Number of IO virt queues to use for blk device. Should > 0");
>>>>> better:
>>>>>
>>>>> +MODULE_PARM_DESC(num_io_request_queues,
>>>>> +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
>>>> You proposed it and I replied on it bellow.
>>> Can't say I understand 100% what you are saying. Want to send
>>> a description that does make sense to you but
>>> also reflects reality? 0 is the default so
>>> "should > 0" besides being ungrammatical does not seem t"
>>> reflect what it does ...
>> if you "modprobe virtio_blk" the previous behavior will happen.
>>
>> You can't "modprobe virtio_blk num_io_request_queues=0" since the minimal
>> value is 1.
>>
>> So your description is not reflecting the code.
>>
>> We can do:
>>
>> MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to use for blk device. Minimum value is 1 queue");
> What's the default value? We should document that.

default value for static global variables is 0.

MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues 
to use for blk device. Minimum value is 1 queue. Default and Maximum 
value is equal to the total number of CPUs");


>
>>>>>>>>> +
>>>>>>>>>      static int major;
>>>>>>>>>      static DEFINE_IDA(vd_index_ida);
>>>>>>>>> @@ -501,7 +517,9 @@ static int init_vq(struct virtio_blk *vblk)
>>>>>>>>>      	if (err)
>>>>>>>>>      		num_vqs = 1;
>>>>>>>>> -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
>>>>>>>>> +	num_vqs = min_t(unsigned int,
>>>>>>>>> +			min_not_zero(num_io_queues, nr_cpu_ids),
>>>>>>>>> +			num_vqs);
>>>>>>>> If you respin, please consider calling them request queues. That's the
>>>>>>>> terminology from the VIRTIO spec and it's nice to keep it consistent.
>>>>>>>> But the purpose of num_io_queues is clear, so:
>>>>>>>>
>>>>>>>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>>>>>>> I did this:
>>>>>>> +static unsigned int num_io_request_queues;
>>>>>>> +module_param_cb(num_io_request_queues, &queue_count_ops, &num_io_request_queues, 0644);
>>>>>>> +MODULE_PARM_DESC(num_io_request_queues,
>>>>>>> +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
>>>>>> The parameter is writable and can be changed and then new devices might be
>>>>>> probed with new value.
>>>>>>
>>>>>> It can't be zero in the code. we can change param_set_uint_minmax args and
>>>>>> say that 0 says nr_cpus.
>>>>>>
>>>>>> I'm ok with the renaming but I prefer to stick to the description we gave in
>>>>>> V3 of this patch (and maybe enable value of 0 as mentioned above).
