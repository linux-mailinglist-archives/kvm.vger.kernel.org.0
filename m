Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB555599ED
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 14:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiFXMyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 08:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiFXMyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 08:54:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A8C625A;
        Fri, 24 Jun 2022 05:54:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PIzLa5TKbcrqQiDgrReszmf+tkK9LVBdlyt+eIZgAqhdAkUl1npXe1IzES/zXYVOS8KZxncRQuS6zrygti7Al/IklYxgS2Ii1S5G2YQDBdbpuJdC+fZM+M0LSqRyAu9+TnpwjdL8QnMunl5soXEaAhWuegCMQRU3gPw4SwCqYJ9veEOfT+67w4jdAhTWzYEvyL0mp1O2ORapEbql1FPFr8ye2EeLxpOinZF0JmsiyB9l10LaFAX//EOQBZyUpW1qBVIX2io3J7WSwrDooXrk/QK6zwhl0zJ9Psjwj30u2trLlGX7TttnoKHXdZuzD6d/0N1lnJbre0AjJgk42qjHLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z4nuwiHwSt8E245YMqOQAqtMtRvLhq5VMWUpBw+W+Wk=;
 b=IqysHGOURBVQn9V0JFiR8X1uQP5dPc3c8M8Gj31yThhWUvjR+7Unm0Ur4/fPrExuTRh5acVTt5qddAdfGIt6DIwcbXZErRqjWH8XGw4Lk6VBi3gU+hlF+FBnvZAS5WT5Fk/Z2eciOuDLGm61Z0TJ2XmTqiyQw5ojneQmQP7ADhmeAOoN1hhx6hR7fzi8kxCl3zxzg8TQPsYnGPCfdUvB6FVjWhNXwnDjTB6WCvvwd6RJcY/klw6YRITKeWjzlOy9O9LNKb0TPS+s/Ku4s8F6CmN4NEj/00I/B1BzLj0GQeG2i/snBSuqGe9BZkOk0Kk8LTeSm5cAAoN/H1/SUxcbUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4nuwiHwSt8E245YMqOQAqtMtRvLhq5VMWUpBw+W+Wk=;
 b=rEAR+SxuYtHaXmxfzzBNR+wA5eQUnY/guQb1wxLFn6lL3EkSoSaJgKagR1YvGPtud2hMQaTMpi8kLrP6VMSfGqv53TlwzAINJlcREPkhhPgkHHoYc3BIrFRTST+skIqOXAO+FT/RDdLgWS9b00FISixleEXlluL0YKzUN97unL54YLbIEsacN4sE2z1gZly3vkEiDF+cG3bkedcRmKe/k4J3KeoXq+oztFWo3I3ymgeMHnJJb2e8XlEIlFSWKBUkWiVwb5Rvo0HOkDNv1vW4P4Id95gOcPjtL0ky+sfKyx3FPSSeZ4gJU7ssZUsDsS8Liz6nqDcXYcZxYnUF/Gvc0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by CH2PR12MB4070.namprd12.prod.outlook.com (2603:10b6:610:ae::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 24 Jun
 2022 12:54:01 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%8]) with mapi id 15.20.5373.017; Fri, 24 Jun 2022
 12:54:01 +0000
Message-ID: <b158ee0d-d7bf-c827-637b-3cd98c66b193@nvidia.com>
Date:   Fri, 24 Jun 2022 18:23:48 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 02/13] vfio/mdev: embedd struct mdev_parent in the parent
 data structure
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org, Neo Jia <cjia@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-3-hch@lst.de>
 <ab47e216-f027-2083-308b-89c6aaa2e806@nvidia.com>
 <20220623201844.GA48313@nvidia.com>
 <f152e97f-0d07-e7a5-baea-3ae7de5662cb@nvidia.com>
 <20220624123344.GL4147@nvidia.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220624123344.GL4147@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR0101CA0023.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::33) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7129dbd5-fae5-4261-8969-08da55e09c80
X-MS-TrafficTypeDiagnostic: CH2PR12MB4070:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /xXB2phSJDkOIHAZfGcwsLAOn6fqmh2eV17ugktP1pyNyjv8NNvh9fk+am8DCwJygkkwD8bUECFwgLiHhAFLMG9cSo1IeaM4GOK/W+1fn8zhLPymVObS0RFy1cPhKB+cJX0DBXpZL7zWtpWYyTyqo83kUPYT4fNVRUKxY7ia3zq2cQ5ZWZSfldF2xZhmPTcuMH5eCIT4zH/7mMiRAfHk2dEXdk11lIsprcP2p/OvgH+VOebkKx9IMr9gPhDgkOXP+ssp4htvakOvFRixOhzxdl0ARK9q+/GwyH2+THWnsTZXk493Mw2fdY5oXxBD6EuPvP4Y/V1CX1TE6EBvakG0W7D3t88z0uutN/U3hEeibfaHTRAJ3mqRReQdj+aVcwpPzDI6KacuFKIEjOKl4ojohf51moGdK0df/Xk1vVdzEJ5gWxwebE3YCBrkaUEnP4inYQqpaKChnIgX2cg1oxQIi7Yu0gV7LjSo48QdssxslPCAIbK6yUzvoOasNngunLiwmg0J/hG/jl9v+Wivd3JlvmSNufeQyQpQX+Lc/MC/LwhOui9gILF2rfmMdo/EWnHM64STiVaEcDaotyQRJR6+TLGmQEfApCwHwwK5l1bnJhFk5PasQNUtvl6AlRoy5vurFYUoC/fPHDRpFQmwA8txHau46JaWMRWnH3QnvFABATWMteKyoTlrNF5V6uz2bcS0DOsG3eWy/Htd7Emo9NS1C7KEA0p7cDHrAiLUbzl68yRgXCPPenFhdXzSQuCFosOLZvVqt2+ttu196rmnnkgfPzebmJh3UM1OeWtaLwumWq+hscBpNOP/RYlsXYmTRl5FmpmUkJILewoI79WPqY+FRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(6512007)(53546011)(107886003)(186003)(7416002)(2616005)(6506007)(55236004)(26005)(38100700002)(6862004)(2906002)(8936002)(5660300002)(6636002)(41300700001)(6666004)(66556008)(66476007)(66946007)(31686004)(36756003)(4326008)(6486002)(478600001)(316002)(54906003)(37006003)(8676002)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGJILy9McW1yaDdiTjc2QlMzVXlDdTFLUmxtaTd4bmd0WHgvY3JSWUhvR3hV?=
 =?utf-8?B?Wm1jd2pRMXNYZU1wVGRCYU9hNHJQNTNXZ0ZFWVpFNFp6bjVYa2VtRUpoZXg2?=
 =?utf-8?B?WEt2cnN5S1RNOGo4TllGZWtGeXNKWDlyM0xMN2NRTG45TFNtODhWL3REKzN4?=
 =?utf-8?B?UkFSTHoxRXhKTFVieDFrQjU4aVRIN3ZyOHd6RWI4aEdUVVdoN3RnOTY5b3Jp?=
 =?utf-8?B?cFh2UU1jbHZqMC9ZSS9QeHI4OFlHVGR3cjlpZ3VtK2ZrY0JseEdDUGVld1Nz?=
 =?utf-8?B?b0UzM05MWFpyTzQwZHQ1VEtrSWIrbU01a3dkNGFsakV0ZmJsbloxekZ0ek5T?=
 =?utf-8?B?RkpBVDk0TXpta3pLcDZ0UkppeXhjc1dXcTVGNXVHaDgwVkhvZ3NjOW0yN2xm?=
 =?utf-8?B?SGtGOWRKTlNMd2l1bEtBOTJWK0VOQjEvMnhjMHFJWnlEclNtRnRmcWxoKzdm?=
 =?utf-8?B?ZlQweldjV0pSQWVQZjhqcjhzWCtOblpxd0FqWGUxQU5sbXQ4RmhPckhwVlJz?=
 =?utf-8?B?Uk8zZGpSUnpnL2VKVWxBdGRHVGxpaWkrTy9uK0R0M3J1T0svbFdUaXptZWZM?=
 =?utf-8?B?Y0xvQ25VeXNiU01QWHQ2TXJuSkFSUEowVWxla05PYnRkN2ZMYW9QOHpDV1Ev?=
 =?utf-8?B?T0EzamhBTE9vc3ZTVDJYYmJEVU1ZQU5RQWhVTVdKYk5sRmdqNDJFZXpxcjFX?=
 =?utf-8?B?L0cwTTlQZ3htejhTbFRUTXBjZWlUVmJkSitPM3hEVkREai9PVEduWDlQUy9G?=
 =?utf-8?B?RTJVL0gyNG9lbHB6cFRPaTV0UDhYZnVzZkhJcSs3RHMySy9HWVRuUWdHWi82?=
 =?utf-8?B?QWlqYlBvWjg4VWNqY1VEQjZhV29KWXhwYUJVZ01paEVGMWtQQ25wckozSDNo?=
 =?utf-8?B?cXp3aS84QWhYOTFzVm5NR0NKbStpSmJvK2FFanhyZklPMEpRdEJHazg5MEdy?=
 =?utf-8?B?bHVlWlpuUEJlc2lYYWpDS3lkQWY0VWg1YzM4bmdma1FSckdsekRxdzA1Ymsy?=
 =?utf-8?B?dUprK05pdWFDMVRWY05MTFkzVSt0SDBKdWoxZzNwb2RWVEt4NlhTc2pxUGlu?=
 =?utf-8?B?dUFPYVRUcHNxNXJsY2ZuaFNzNTIwL2RnV0xUdTdVeGgxL2k5WkZvK1hBcmF1?=
 =?utf-8?B?NzJPbGdUeXR1anI2OVV5L1ovZjVKMktjdFMvRmVKUGdQMFhjVTRxbXNmbVRN?=
 =?utf-8?B?T3c4a1pkdG1tK0RCc2dwMTVtaDRna08vV0tOb3g3R1p4U1p4Y081QW9NQlp2?=
 =?utf-8?B?OTZiSndzbUdocGFMeXIwZjZCeVZ2cnoranBiK2NOb3VET3FEUHRob2VEby8z?=
 =?utf-8?B?Vmp2TmQ1RTR3SVhYZzBTUkpRTVRXRWtSaHlYL0lxWWhuL29aUkRQcThVbEJh?=
 =?utf-8?B?WDhRV2FrMW51bVlGdndlc1NodVRYZzE2YzFsSGErV0REdlJmWTRKT1ZBMmth?=
 =?utf-8?B?OHdIQU1sUjFvcGIwTUpCY0IvYVM0d2k0TTlMNDE5QjVNWmdyWlh0MCtNYlkw?=
 =?utf-8?B?Wmxkc0FXbXB4ejhNdUgxVVZScWQzUFd1VmdNb1FCQktUaHJyTGthSXVrRVdJ?=
 =?utf-8?B?UU8wb3dRY2VxbEkyZnZxOGNOd2FqbUFYWFFacmVid1NTTDVLWm8rUW1TV05Z?=
 =?utf-8?B?bitTdHdrakhlMG5iYzVFQWNQbnBXN2Q2SElnOGxDbTY0dHlRMkNwUXVCSDFR?=
 =?utf-8?B?K0dITmdlSVBtWGZUMkU0Z1lnWllaUDBudEE0ekoyZTlOeTZiT2N2cXF6WSt5?=
 =?utf-8?B?NXFHbzdhUm5RZ2gvSE0xTlFJNHhnZlNwSVhWaWR2OUZNNmhRQ0hMTGoyeG1X?=
 =?utf-8?B?NC94cmI1b1RhTDBWcDJCbURURXRRRUV4VXNDaTNnQnFoRUtaZWF2QUJQRFYy?=
 =?utf-8?B?RGZBRTNsSVRzZWtUSGlaN25MWncyRUVHY2w5SVBINXVkRnVsYXFDZmJzdVhy?=
 =?utf-8?B?THp1YUVpSUhWN1ZVZkVQVHlKYmJSVnVIZkF1NmFNWHhGSTh4aG8vS0M1aHFS?=
 =?utf-8?B?N3FzUVF0OXB1Y2h4WnBOS2RPYVllb3BCaGlxVEFMQTR3ZkNKL1ppQ0VXbTRF?=
 =?utf-8?B?TjZYS0graENSY2thU1R2R3J4VzQ0T3huSy9Da0NQeUY0c1FyYlVTNThPNURF?=
 =?utf-8?Q?1DdVG3eHvaORbGVuYwn1YtaCd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7129dbd5-fae5-4261-8969-08da55e09c80
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 12:54:01.6656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k9ejrPX/KoB1VxGJNEmRvaFQDvRRfyN3J90fIaj+j2AcpbnZRlN//PdrC0uctrSdTe+AEN4BXKF1SjrlUJuSOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4070
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/24/2022 6:03 PM, Jason Gunthorpe wrote:
> On Fri, Jun 24, 2022 at 05:59:58PM +0530, Kirti Wankhede wrote:
> 
>>> The reason this is here is because the type->parent is used in a few
>>> places and is put back in release:
>>>
>>> @@ -81,7 +81,7 @@ static void mdev_type_release(struct kobject *kobj)
>>>
>>>           pr_debug("Releasing group %s\n", kobj->name);
>>>           /* Pairs with the get in add_mdev_supported_type() */
>>> -       mdev_put_parent(type->parent);
>>> +       put_device(type->parent->dev);
>>>           kfree(type);
>>>    }
>>>
>>> If this was a simple sysfs kobj with only a show/store we wouldn't
>>> need to do anything as the natural kobj parentage holds a ref up to
>>> the struct device - but this kobj is used internally, ie dependent
>>> from mdev_device_create(), independently of the normal sysfs
>>> life-cycle so that doesn't protect enough either.
>>>
>>
>>
>> Life span of 'type' is from mdev_register_device to mdev_unregister_device.
>> If device/parent is being unregistered then only types are removed, so
>> referencing 'type' from mdev_device_create() is still safe. Therefore,
>> parent device's reference should be held and release from
>> register-unregister call.
> 
> No, I've already explained this.

Its not correct.

kobject_init_and_add(&type->kobj, ...) which called from
mdev_register_parent()
     -> parent_create_sysfs_files() holds reference for type->kobj

This is released from
  mdev_unregister_parent()
      -> parent_remove_sysfs_files()
          -> kset_unregister()

In the next patch [3/13] of this series, these calltraces are changed as
mdev_register_parent()
     -> mdev_type_add()
         -> kobject_init_and_add(&type->kobj, ...) holds reference for 
type->kobj

which is released from

mdev_unregister_parent()
     -> mdev_type_remove()
         -> kobject_put(&type->kobj)

Thanks,
Kirti
