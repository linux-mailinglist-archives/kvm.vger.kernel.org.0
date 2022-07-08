Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C86156B556
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 11:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbiGHJVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 05:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237753AbiGHJVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 05:21:48 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6ED2C677;
        Fri,  8 Jul 2022 02:21:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWh6xBDY383ZblEUDlj2AC92BdXyz3WTKiAh+CynIDWYOQlVJF9CeQaaOrL6JZRw3oid/u7KUMgsCC47jEhVwgtlAY3CmUWy38pKCYh94Nm8ZDiXmiyJoX7oH08eC0OOuv+9f6YXGTl3oB+ZTef+4OFOTBQMw/ODqed8j8ahNHwWg8ZNLGTummSn+qUF6bRHOUpl/4bl87u7V/aHT1uoaOi4+jZv6kSXhBqlr89eRbgyDYNIY19JxEYguhR7jQFsd0HsP0LFgS7Xv6J31NTZPBKMDo73LuFoutY2+tOLNDTW5+eTM2mdWlIridL6rEVanpLkv2QNGvpDPIYo72Xybw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R5smdUhw5ZHelZIotmt76q4UdQiWLSXiF7c65Ls89y8=;
 b=YPsIPvmqpGr8y0FvcxAfRoAczK5PUqnQolTTcCnUw+tEik4c8t8K75r3QxD3w2uOu/7HognWJjl2ISuKmqqPW84AIf1ej901HmcjogJICZ1BRw3ZSwSjVGVJcCAjhoIbvsCR3Kmj4GUBue74fqZ1XW5PChPSm67E/8tvyheqKj8EhXhEUBWQaESdeeSSYPHQv794SC08Dsawy3H0goHulAFkPVkMqlb1aOyhnVVqQgBzT5ctYFocwDEsWNeV/2esNu8/nCtJJU5KfT6txC6/BV5TaZitvUw3yduX9XCyjmCEe/xS40WjV4CRQbWLlmyVwDf09YP8iNXwHW8E+TBPYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5smdUhw5ZHelZIotmt76q4UdQiWLSXiF7c65Ls89y8=;
 b=SW5fFZnjSQ3qf5B4GtlodAQHkrKTji7oy4kCgYvm/hoBmL3dWZs9D3uOgjHWXFdBgIfoG/a6Jz9J9E6iK33PeS9/1JM/LnrkjFWMIdXH8DsJBCoKmyjF3/DELSP/dnf6rE6Zwdh/7bOMTEymtKFbOft2XKWjLXoJAkWrbxcfxvbrnvAEXk74YAvLkRkq1wzrigWEeJJTNnjvAgErwSmpLvwWPgUP7IWqlOfaSwuRnR9kBLxitcd53q3c6JOuhUyO/TiyLVP6TjexTJ5ajqyzXL7pEnMqyEQ1/agtP8tA958tD7IrU1slvAnYm+xj1SzQF4D4g0O2SGgtQHi7MUEdQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by SJ1PR12MB6316.namprd12.prod.outlook.com (2603:10b6:a03:455::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Fri, 8 Jul
 2022 09:21:42 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed%8]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 09:21:42 +0000
Message-ID: <3b143762-d6ce-ac70-59ae-a0c2e66ffc1b@nvidia.com>
Date:   Fri, 8 Jul 2022 14:51:30 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 1/6] vfio/pci: Mask INTx during runtime suspend
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20220701110814.7310-1-abhsahu@nvidia.com>
 <20220701110814.7310-2-abhsahu@nvidia.com>
 <20220706093945.30d65ce6.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220706093945.30d65ce6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MAXP287CA0013.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::26) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7b9ee29-7e3b-491a-2f63-08da60c3450b
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6316:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KJquO61DgF6ae8Pj04xHOMrjySSj26SqdSZtUqF3dpYXkGRKlkAuo3kONrFjW4qQwWVQ64CuwyNkVtteBNFJ6zbkFz9hOsAI9sgfoUoNtF2rtZh2CpCkoUM3EKZ5b8eB9qdE9RDpcmUL4q5G1DbeMpKJbwC5KuQNWlDtaHQ3TXbUF4AiZ8uN42a7auhavfGT8wFCWKmy7b6hqQkrsTdw0n43qSlFrd7tj9tdaahYkq5yVVjUFC4dgaQY3NF+1MO/o5+dWajc7Gu0d9k3ybyzrXhJITvtMrS6pVx8MVjzaxNEORjpgfrmOYAiTGGE0/sfcpL1KJAlDoj1xVEraz3CNkq6PHhksmZTutf5y3grZ+suhLGJhmXwhX0tQuIbXVUokn0EALpCXIbQFM1uZ1GCb8gOzKkAvI/s+R/qwq/uZwlcSwbds5EX0TrBrkszG2kh5GhIZyF9GCCNT2yxK/t2+QrjkD7H9FbAQEA5Kh/wfUYqhuPELqw0YO5DDQQY6p+VJh26s6obxL/fwTiCZyCXtXgkRvczfC2864YeBTl5Jj667PgCRaedShBF09wWol83TG3Tm5sqDltQLphNDY/iXHogAFg8H5kLSf9p2rrDQmiue3xy4WGoaWsOyiZgIGZe5gBc4IdxfDWKJ3KeY+F+8QRWwnpj+W4mGK8xoOYXV04Jf+OUlk4rQIiChKfLkl138x/SgoA/ZAIAnC3CJBBtlf1nw7cvSu2gh/RYJBs+zPepa8pW1IW8aWn7Ge4Mff1s13khrv348arcvWNGWJQsb3mKvlzUuULVF3nCP/omHLa4umSR8i+XZ7LECzoO8iXaE25hiqOl/KX0HLWMFVxrqUAg9xqGo2o9U0m7qDwgP/k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(66556008)(41300700001)(186003)(66946007)(86362001)(54906003)(6486002)(2616005)(4326008)(316002)(31696002)(6916009)(478600001)(15650500001)(26005)(8936002)(6512007)(8676002)(66476007)(6666004)(55236004)(53546011)(38100700002)(83380400001)(5660300002)(36756003)(6506007)(31686004)(2906002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTVXNzc4Zk95UllIeGtPNk11VnhmSW5WSzg5REY1VlJxTUh2WTh0Sm43RkR4?=
 =?utf-8?B?N0lxcTF4THVIdmd4aEpYdXVtS0lFalduVFFVKytleW9mdjR4ekQvQUhyOUVD?=
 =?utf-8?B?YVVZdEpNb3M1bDdRSHlZUjRxUjEzWG5KajVkbHFSSTNuN2FUTVBadUZnVGp2?=
 =?utf-8?B?NnVkNmVaZE1YdUxkOTVHdWRpMkw0L2tNRE5STmlwbjcxWWhoQVZ5VUZYenhP?=
 =?utf-8?B?UHFjYjlpR3hFTitvM1RobnoyYlRZdjZSZEFsMWwyS1lrOFlDdzJvWnhPbytS?=
 =?utf-8?B?Wkl6TS9hK3B4M2hTaEhPZUtBanY5R3VyaUE3K25lWis5Y0g2eHNIcUgvQ1A5?=
 =?utf-8?B?aUdpYTl0WFV4QUF2b3pjdXpMWnpab21pOUFvKzlXRmVxaVBaTG1YYU9jS2Iv?=
 =?utf-8?B?eEl0S0Q4Nm9kbEw4QUFCZnFkZWhoY2FHd1lQL21iNUMxTk5sWm9TZW1vMDZC?=
 =?utf-8?B?b1ZIVDlVU0NQeks5eEZsNjdTeWh3bXZobWNFYU9JQmY1bk1UOC9BVVp2YXNj?=
 =?utf-8?B?NHpTNERTRDZGdlFjRHZXVzFuYytSVHpzYzhkOUdFYm5QOWQ2eTg1MEFaeGxu?=
 =?utf-8?B?N0lSVW5WRE9TWmtSRmlMdGM5UkRHWWRnR29aTjM2UDZYRWMwTXBHcUpydjU5?=
 =?utf-8?B?cDJrNERUWWI5Ri9XUjVpZ1BVdGZ0cWJrVXZWTjRWNlozekpoSXRPTTdpM0F6?=
 =?utf-8?B?dFNBRXF1ZFRSWkdJTTErdXppVTB5Nm1xVW5idFdkU0JReXVLZjVjYktJT1B0?=
 =?utf-8?B?YXhGU2I5eWpOVm5IZ05LUVpoOUJld3M3MTd3NmFKSHoxSmdtK0NxT3ZQWnA1?=
 =?utf-8?B?Y1hGR292ZWEzQjhNQ0t5REtiQzhXM3ROSDBwMEsrU2lCTmsrS2wrK0N1MURI?=
 =?utf-8?B?VmFCTFdaYU1xTGJDM1JEdXBGVkQ2aG5rSkpIaDg5RVJkTXI3S0gvR0tVUFJV?=
 =?utf-8?B?V09GQ29vTzBzdDBmdUpBeGRJa2FBMGRQZytqeW9CTHptUW04a0RKRVdVT2p4?=
 =?utf-8?B?R1VWaGkzVkRxK1pUQkFROFRKdVIydVFwcjl4QXZ5bDZFZFN2Y0twdHpQUUdD?=
 =?utf-8?B?MExNQ0Y5cUZRRWNVaHZUUU5BY3RzT29TQkZwWWtlNGRzY3MxanJHdVJWZzI5?=
 =?utf-8?B?cFdIaW14bXNjeDZ5RjkrdUpkaFhNZFhxSmVtRkxyRUhMcitmYVhSWGZSd0xp?=
 =?utf-8?B?dmV5OUF3RFFRZUlZejVCaGhSQkx3N1BWeXpvSHZSelhFQmtGaWN2bkQxV1dy?=
 =?utf-8?B?QlNaVFZSa2dCWFFXdi9Cb2dIUlIyNE9LSzk4eThxSXBWVVZXWHhKamJJcW92?=
 =?utf-8?B?RkJCaExTM2U2T1J4Nkd3SFJHWkNkR0dUM2wrYTNuSk9nMXA1S056aFYzaDFW?=
 =?utf-8?B?Rnh1MHdzV2RDQzc0QUhvZU5USXJ1SGNGQlhudWpqeXFraWVBNlBtNWJ5ZVlk?=
 =?utf-8?B?Tk5id1VxRlVicFZMUWpUOEo3QTY4eFVId290Mm1XSE1TNXVhR1FjMDJkOGJl?=
 =?utf-8?B?L3dyZjhhc0pxY1BQUW95Wm05QkU5YS9rNWVZa0l2QW91Q1ZVb1hWT0FZYzZC?=
 =?utf-8?B?SjBtU01LcHc2eU1YOUd2cVFoRHBFTlZpbmppRG5Xelg1RmFOR29sa2VEcCtL?=
 =?utf-8?B?R1pqbzk5bTMvc1NFYjIyU3IybWt6QUM5M0QwNnV6NWhRRFBpTk5EemRibzZx?=
 =?utf-8?B?U3lvajE1WDAycld5VmxCb0lLYjQ2c2RPK3g2Q2x3TkdDNlVNK0dqam90Yy9O?=
 =?utf-8?B?NjBqMkNLL1Z2bWZRNCtiOFg1RDZEekdUSlBQZUFFU3gyaXZ1bFBKRGlBUkx6?=
 =?utf-8?B?dXRWcWJCQkZSek02NWgyMkFHbm9nNmRIL1F3TXdnNXZ4WDUwQUlWVVhLZzBV?=
 =?utf-8?B?RWxlTGNySzd3MUhId256N0Q3eVBieEd2M1owSFRoenRmeEdtdjQ4b0ZkdXpH?=
 =?utf-8?B?aUx5cGkwU2JDcnFsTFFlTjRPWDdCS2lZRGFmeVh5ZnN6MmFHVHVjN2pwbTRx?=
 =?utf-8?B?Mm1yOEl5YjNHVThqT0pqL0tORFhKdmhodXN1am5qbUNEcmxDSGp3YWw1Sks3?=
 =?utf-8?B?MnhKcHVkSHFQTElJb0taY3J4SXdQbTB3RU1rbFM4UnFTYWxsV2x2WHlENzQ3?=
 =?utf-8?Q?BvYHep84FtaTB8xRiFOt0u/Dp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7b9ee29-7e3b-491a-2f63-08da60c3450b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 09:21:42.2876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lgf3V7WWGPKDUj/U/lQANxFlkn2yCTZ27kOqRQgF6Wz+7CIb8fKoDZ8BOmeGM4i7Vt0g8RYQ1abHSHy87zRY5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6316
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/6/2022 9:09 PM, Alex Williamson wrote:
> On Fri, 1 Jul 2022 16:38:09 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> This patch adds INTx handling during runtime suspend/resume.
>> All the suspend/resume related code for the user to put the device
>> into the low power state will be added in subsequent patches.
>>
>> The INTx are shared among devices. Whenever any INTx interrupt comes
> 
> "The INTx lines may be shared..."
> 
>> for the VFIO devices, then vfio_intx_handler() will be called for each
>> device. Inside vfio_intx_handler(), it calls pci_check_and_mask_intx()
> 
> "...device sharing the interrupt."
> 
>> and checks if the interrupt has been generated for the current device.
>> Now, if the device is already in the D3cold state, then the config space
>> can not be read. Attempt to read config space in D3cold state can
>> cause system unresponsiveness in a few systems. To prevent this, mask
>> INTx in runtime suspend callback and unmask the same in runtime resume
>> callback. If INTx has been already masked, then no handling is needed
>> in runtime suspend/resume callbacks. 'pm_intx_masked' tracks this, and
>> vfio_pci_intx_mask() has been updated to return true if INTx has been
>> masked inside this function.
>>
>> For the runtime suspend which is triggered for the no user of VFIO
>> device, the is_intx() will return false and these callbacks won't do
>> anything.
>>
>> The MSI/MSI-X are not shared so similar handling should not be
>> needed for MSI/MSI-X. vfio_msihandler() triggers eventfd_signal()
>> without doing any device-specific config access. When the user performs
>> any config access or IOCTL after receiving the eventfd notification,
>> then the device will be moved to the D0 state first before
>> servicing any request.
>>
>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_core.c  | 37 +++++++++++++++++++++++++++----
>>  drivers/vfio/pci/vfio_pci_intrs.c |  6 ++++-
>>  include/linux/vfio_pci_core.h     |  3 ++-
>>  3 files changed, 40 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index a0d69ddaf90d..5948d930449b 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -259,16 +259,45 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>>  	return ret;
>>  }
>>  
>> +#ifdef CONFIG_PM
>> +static int vfio_pci_core_runtime_suspend(struct device *dev)
>> +{
>> +	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
>> +
>> +	/*
>> +	 * If INTx is enabled, then mask INTx before going into the runtime
>> +	 * suspended state and unmask the same in the runtime resume.
>> +	 * If INTx has already been masked by the user, then
>> +	 * vfio_pci_intx_mask() will return false and in that case, INTx
>> +	 * should not be unmasked in the runtime resume.
>> +	 */
>> +	vdev->pm_intx_masked = (is_intx(vdev) && vfio_pci_intx_mask(vdev));
>> +
>> +	return 0;
>> +}
>> +
>> +static int vfio_pci_core_runtime_resume(struct device *dev)
>> +{
>> +	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
>> +
>> +	if (vdev->pm_intx_masked)
>> +		vfio_pci_intx_unmask(vdev);
>> +
>> +	return 0;
>> +}
>> +#endif /* CONFIG_PM */
>> +
>>  /*
>> - * The dev_pm_ops needs to be provided to make pci-driver runtime PM working,
>> - * so use structure without any callbacks.
>> - *
>>   * The pci-driver core runtime PM routines always save the device state
>>   * before going into suspended state. If the device is going into low power
>>   * state with only with runtime PM ops, then no explicit handling is needed
>>   * for the devices which have NoSoftRst-.
>>   */
>> -static const struct dev_pm_ops vfio_pci_core_pm_ops = { };
>> +static const struct dev_pm_ops vfio_pci_core_pm_ops = {
>> +	SET_RUNTIME_PM_OPS(vfio_pci_core_runtime_suspend,
>> +			   vfio_pci_core_runtime_resume,
>> +			   NULL)
>> +};
>>  
>>  int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>>  {
>> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
>> index 6069a11fb51a..1a37db99df48 100644
>> --- a/drivers/vfio/pci/vfio_pci_intrs.c
>> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
>> @@ -33,10 +33,12 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
>>  		eventfd_signal(vdev->ctx[0].trigger, 1);
>>  }
>>  
>> -void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
>> +/* Returns true if INTx has been masked by this function. */
>> +bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
>>  {
>>  	struct pci_dev *pdev = vdev->pdev;
>>  	unsigned long flags;
>> +	bool intx_masked = false;
>>  
>>  	spin_lock_irqsave(&vdev->irqlock, flags);
>>  
>> @@ -60,9 +62,11 @@ void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
>>  			disable_irq_nosync(pdev->irq);
>>  
>>  		vdev->ctx[0].masked = true;
>> +		intx_masked = true;
>>  	}
>>  
>>  	spin_unlock_irqrestore(&vdev->irqlock, flags);
>> +	return intx_masked;
>>  }
> 
> 
> There's certainly another path through this function that masks the
> interrupt, which makes the definition of this return value a bit
> confusing.

 For our case we should not hit that path. But we can return the
 intx_masked true from that path as well to align return value.

> Wouldn't it be simpler not to overload the masked flag on
> the interrupt context like this and instead set a new flag on the vdev
> under irqlock to indicate the device is unable to generate interrupts.
> The irq handler would add a test of this flag before any tests that
> would access the device.  Thanks,
> 
> Alex
>  

 We will set this flag inside runtime_suspend callback but the
 device can be in non-D3cold state (For example, if user has
 disabled d3cold explicitly by sysfs, the D3cold is not supported in
 the platform, etc.). Also, in D3cold supported case, the device will
 be in D0 till the PCI core moves the device into D3cold. In this case,
 there is possibility that the device can generate an interrupt.
 If we add check in the IRQ handler, then we won’t check and clear
 the IRQ status, but the interrupt line will still be asserted
 which can cause interrupt flooding.

 This was the reason for disabling interrupt itself instead of
 checking flag in the IRQ handler.

 Thanks,
 Abhishek

>>  /*
>> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
>> index 23c176d4b073..cdfd328ba6b1 100644
>> --- a/include/linux/vfio_pci_core.h
>> +++ b/include/linux/vfio_pci_core.h
>> @@ -124,6 +124,7 @@ struct vfio_pci_core_device {
>>  	bool			needs_reset;
>>  	bool			nointx;
>>  	bool			needs_pm_restore;
>> +	bool			pm_intx_masked;
>>  	struct pci_saved_state	*pci_saved_state;
>>  	struct pci_saved_state	*pm_save;
>>  	int			ioeventfds_nr;
>> @@ -147,7 +148,7 @@ struct vfio_pci_core_device {
>>  #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
>>  #define irq_is(vdev, type) (vdev->irq_type == type)
>>  
>> -extern void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
>> +extern bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
>>  extern void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
>>  
>>  extern int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev,
> 

