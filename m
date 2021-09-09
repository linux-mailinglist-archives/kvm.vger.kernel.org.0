Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154F3405A3F
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 17:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhIIPiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 11:38:55 -0400
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:45280
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229745AbhIIPiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 11:38:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V29aDBSy+ksqbPVQf5H5TRGApQadg1ja7Ih892kDMuOdtSbqn/AoQDhynRDi2rlkWhGbSmPzGc6rpYmfnQREera30aOKW4FOaxDWmEOOMQdbQv6ohR1myPTKG64dkMA+XalOTjXg5NGAVHRL/TDxsncRmDpwAKPgMy6IfV5WcjJYdcAmtAamigHv81WgjIlHO7F4V5RXVPSymXWPIUwtioauxaHaKJ4AmARpg2QTgIpi2QeiEIFLusbiELZcLYSB+IaaSmBfG1kcv00xZV68Elur+RQtjhXFWYYjzBzkz6BHtE+SeupT/UyEoAUq+ehze9zGu0bFB9wuGV2GGJ+3mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Z5j2o6qJMl8MUEOYqoSQwl4SzOK1SLARbxkXtk44okQ=;
 b=cKXmgxvMG9UXnjtWNJa4ru37iugYDmfEz5PfxiRIWfBbsAUaSItmsrAc+klSBWm/5R3PdKMbIvkErOCzvqCn3yGRJtmcrAeyg/omGkdpdj9sZstSGt/jeFpRyhF8g3oshDf5rxsqfBrJ7DXyysKDbdfsvjPIybm9F719Rsto75jCPX65pUpGv0DqBiLOyrev+yFE94T1QH56I6Xy1ht0+RZNVrMi4KXo0Gyb+m4jq0zyxu0LpRDmMWqwHRqOBjNHU/CCWtxGyrAkPYs7KRzSPU07MY2RzYjAQCeDN7abKJZKBeYkbLpxM14uI7//OY4+YxmofDbPBwf77FdoEXZvpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5j2o6qJMl8MUEOYqoSQwl4SzOK1SLARbxkXtk44okQ=;
 b=DGP4yvLGJusBvr1UO8xr1GEItrWEb1D2t8i4MG8gWTF/DaZ8DZ0q3CNb4PqozgJLOnf4dizjyFw8aco53d2vCOOpLvuzMa8pQnDENm2YOwAILwbZ591KRrPfMgWpkUU9ZDYA8UbEuoBo0AFun+cwLyYFK6d9nYoerk89fGdpuA2sMdrwdxZl94yOOPwSvZruQx2nZtntoeXPACYEyvRAyYBa4CmlOr3WIBk8tQwxpl/qS2a8Q3AH6q0BNeprfoLlF7zBltb7wM1dCg50WUjs+oN1/7yLBH/jaYfNOqPenCWQ21mYOQnbFhSEmICasq7CyFhRfW51RuBOC/GSDm1KXQ==
Received: from DM6PR03CA0027.namprd03.prod.outlook.com (2603:10b6:5:40::40) by
 MN2PR12MB4343.namprd12.prod.outlook.com (2603:10b6:208:26f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.25; Thu, 9 Sep 2021 15:37:44 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::1b) by DM6PR03CA0027.outlook.office365.com
 (2603:10b6:5:40::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend
 Transport; Thu, 9 Sep 2021 15:37:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Thu, 9 Sep 2021 15:37:43 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Sep
 2021 15:37:43 +0000
Received: from [172.27.14.161] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Sep
 2021 15:37:40 +0000
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
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <456e1704-67e9-aac9-a82a-44fed65dd153@nvidia.com>
Date:   Thu, 9 Sep 2021 18:37:37 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210909094001-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fa7350e-dc0d-4a1f-01b0-08d973a7c441
X-MS-TrafficTypeDiagnostic: MN2PR12MB4343:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4343793158CEA60172CBA76ADED59@MN2PR12MB4343.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M4vBxmvxzxGfOqvWNmTV/23AlikrjC1ggfJSlyaAih7MlLByU+f5FAU/r+2q0UXGeetB+QFWgNoENb6sonxV+7V+F+8XXfCxgUk2dkO3+S735/pAbch5q2KgD0N6xx8Ni62D4E57TL5ZJPsWs9ECOHqemLBOwizLbHB8x0mLfb2dtf+gUIX3Mrt/43K9m50SEbtHeG97wfdDURfMpIlh8kZM4EFixBheoDi1SGJyTiH9buYL6LaHONI5MTqCA7d2uHZCpkBVzCgAmLIULso+umyaSOy0Vjr17j6kDqwGU5+ALJeyRK36q3WECC4QhwKMess5VVh9X0Hn+KkPZAhwaeKmvL0AQ5hX4Y9u+MWL8WxoPWCfhUT55ihe2ZkwLguU1htWcPlUx7VVYv81QCMcRMOsjfn3AGJpXVisANgnjWiLBIUrs8SrxORvtnqZNHHrhoE3spnHNTtwd3cApr4YPErwqFEvG7x3owEZ5N+gADr/r4Jih8rH2A3bmSL338CZp3EhCBYwllEWKL+Tm6uh3IdqKL6AF/cQlrZ9nm2NwzVtg8XDPr12deTlN1JdH7FV4bkTuEroSe2FjqEEwmQurlycICS63nx5IitG3EZuKJh3DvUUuBU+F3/RI8nUyrq5yTZZvmfHjN5Hq8DuMHIbizCfcZWD1c9D9WBoch/gnP1uDF0aAToFqyy2fu2x4Q4XzZRzAv13tr0v3JFBkiNltoQLKATAvosSUkpXO2nWqnA=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(46966006)(36840700001)(478600001)(5660300002)(36906005)(36860700001)(31696002)(16576012)(31686004)(2616005)(53546011)(82310400003)(316002)(86362001)(47076005)(83380400001)(8676002)(70586007)(70206006)(36756003)(26005)(336012)(16526019)(6666004)(186003)(426003)(356005)(82740400003)(6916009)(2906002)(54906003)(4326008)(7636003)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 15:37:43.7883
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fa7350e-dc0d-4a1f-01b0-08d973a7c441
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4343
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/9/2021 4:42 PM, Michael S. Tsirkin wrote:
> On Mon, Sep 06, 2021 at 02:59:40PM +0300, Max Gurtovoy wrote:
>> On 9/6/2021 2:20 PM, Michael S. Tsirkin wrote:
>>> On Mon, Sep 06, 2021 at 01:31:32AM +0300, Max Gurtovoy wrote:
>>>> On 9/5/2021 7:02 PM, Michael S. Tsirkin wrote:
>>>>> On Thu, Sep 02, 2021 at 02:45:52PM +0100, Stefan Hajnoczi wrote:
>>>>>> On Tue, Aug 31, 2021 at 04:50:35PM +0300, Max Gurtovoy wrote:
>>>>>>> Sometimes a user would like to control the amount of IO queues to be
>>>>>>> created for a block device. For example, for limiting the memory
>>>>>>> footprint of virtio-blk devices.
>>>>>>>
>>>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>>>> ---
>>>>>>>
>>>>>>> changes from v1:
>>>>>>>     - use param_set_uint_minmax (from Christoph)
>>>>>>>     - added "Should > 0" to module description
>>>>>>>
>>>>>>> Note: This commit apply on top of Jens's branch for-5.15/drivers
>>>>>>> ---
>>>>>>>     drivers/block/virtio_blk.c | 20 +++++++++++++++++++-
>>>>>>>     1 file changed, 19 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>>>>>> index 4b49df2dfd23..9332fc4e9b31 100644
>>>>>>> --- a/drivers/block/virtio_blk.c
>>>>>>> +++ b/drivers/block/virtio_blk.c
>>>>>>> @@ -24,6 +24,22 @@
>>>>>>>     /* The maximum number of sg elements that fit into a virtqueue */
>>>>>>>     #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>>>>>>> +static int virtblk_queue_count_set(const char *val,
>>>>>>> +		const struct kernel_param *kp)
>>>>>>> +{
>>>>>>> +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
>>>>>>> +}
>>> Hmm which tree is this for?
>> I've mentioned in the note that it apply on branch for-5.15/drivers. But now
>> you can apply it on linus/master as well.
>>
>>
>>>>>>> +
>>>>>>> +static const struct kernel_param_ops queue_count_ops = {
>>>>>>> +	.set = virtblk_queue_count_set,
>>>>>>> +	.get = param_get_uint,
>>>>>>> +};
>>>>>>> +
>>>>>>> +static unsigned int num_io_queues;
>>>>>>> +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
>>>>>>> +MODULE_PARM_DESC(num_io_queues,
>>>>>>> +		 "Number of IO virt queues to use for blk device. Should > 0");
>>>
>>> better:
>>>
>>> +MODULE_PARM_DESC(num_io_request_queues,
>>> +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
>> You proposed it and I replied on it bellow.
>
> Can't say I understand 100% what you are saying. Want to send
> a description that does make sense to you but
> also reflects reality? 0 is the default so
> "should > 0" besides being ungrammatical does not seem t"
> reflect what it does ...

if you "modprobe virtio_blk" the previous behavior will happen.

You can't "modprobe virtio_blk num_io_request_queues=0" since the 
minimal value is 1.

So your description is not reflecting the code.

We can do:

MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to use for blk device. Minimum value is 1 queue");

>
>>>
>>>>>>> +
>>>>>>>     static int major;
>>>>>>>     static DEFINE_IDA(vd_index_ida);
>>>>>>> @@ -501,7 +517,9 @@ static int init_vq(struct virtio_blk *vblk)
>>>>>>>     	if (err)
>>>>>>>     		num_vqs = 1;
>>>>>>> -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
>>>>>>> +	num_vqs = min_t(unsigned int,
>>>>>>> +			min_not_zero(num_io_queues, nr_cpu_ids),
>>>>>>> +			num_vqs);
>>>>>> If you respin, please consider calling them request queues. That's the
>>>>>> terminology from the VIRTIO spec and it's nice to keep it consistent.
>>>>>> But the purpose of num_io_queues is clear, so:
>>>>>>
>>>>>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>>>>> I did this:
>>>>> +static unsigned int num_io_request_queues;
>>>>> +module_param_cb(num_io_request_queues, &queue_count_ops, &num_io_request_queues, 0644);
>>>>> +MODULE_PARM_DESC(num_io_request_queues,
>>>>> +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
>>>> The parameter is writable and can be changed and then new devices might be
>>>> probed with new value.
>>>>
>>>> It can't be zero in the code. we can change param_set_uint_minmax args and
>>>> say that 0 says nr_cpus.
>>>>
>>>> I'm ok with the renaming but I prefer to stick to the description we gave in
>>>> V3 of this patch (and maybe enable value of 0 as mentioned above).
