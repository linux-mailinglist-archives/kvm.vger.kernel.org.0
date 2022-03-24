Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E8E4E6517
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 15:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350888AbiCXO3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 10:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350864AbiCXO3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 10:29:21 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2059.outbound.protection.outlook.com [40.107.212.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E992D7B105;
        Thu, 24 Mar 2022 07:27:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPkqii1hWqkvNwyhwuUkCXbWRQfWD5EaoxSwDtcw75oqzXX1Pc+crWpchYaUMN3xIWpdcZBAu4GTV7Httiu8OUqaboWvG0hQpMkaKtElTAa30CQoeTIz3Yj7Lj2hrpJZdBqgaKs79i9CPi15G4HYqLaO5YVEVmFaZHqmFB/qxo6EmbCm1MAruTUpIK+t8zzKNG4+k4Qxk20cfwAdoB4qq5EK5yIRvBCNmd0uTonJZlA7yvIT01rvzCQTy7UAusETchE8z6vRKMvWNuRAK2nqXNHMegjRExXYj5giP936dvXtOPJssNY6pZBBQoQ0BIcrFQ9AIqGEiDFkqT1bI1WeXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unUhWp24+VF24LA4bfoRKRmx/J/xT9vAusHUjNe6GfE=;
 b=YejJ1rg38Vm2TwBNdKvWPrOvegWA+8Ew8scbs4vru/pN1rrjKZ06NSAbis30qS8wCm+flAjwAaRidzJaY81UXoOWHMfbP3j0J7QrFDu3MqWT9396cmkYAzagdLwlkfjCOXmX8WeMDcjzcSKMThOH9FjOFiX3zIji921oPB2L3T4K/F5YmfGZZiJ/AER5s61iHW2pMQb6izt6CaO8b/yHj7V8iyHQgga8GD8f+aNC/aDFLVevSypmnbV7JCGoSyXVaDJGFZjHZnV7Rd9WZt5JZMQsZe2WDLeVj6yvHLPLnIuwan7Z/mhfqv+EoLIpNT0fS7ikuSRPIdcI8non7LYS9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unUhWp24+VF24LA4bfoRKRmx/J/xT9vAusHUjNe6GfE=;
 b=owJGKmc14+tZvwk9c53y3pGw7S2YYEDi4HCiWxkV8PTpYhLbRAEb8S8gBrNntFq6DIezY37foDV3o1+z16TPLdTy5WuCvB655shRfZLCzCtozpXCFWrN8jHc5ZG59x68uBNnuSZ4m0tHdylXam6I4OkpRJe+FPTPGdc7Iglmq9H2qqwHOUGbFZiA2TSjettin4JcNPjoHwjZvc7oxzALDid/f8U85faKqfJTs84dvfxsn9WGfGa5E6dTKhZyGOMV7S55Y3NUWsBdK4frRuqYzohIrMSvIuZmWaIlf9V96z8lsJYt4rmFxGvnvrnNBzPzSLoKPo2idDVBFXuNunUGkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by MN2PR12MB3790.namprd12.prod.outlook.com (2603:10b6:208:164::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Thu, 24 Mar
 2022 14:27:45 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::d1ee:362f:4337:d03b]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::d1ee:362f:4337:d03b%8]) with mapi id 15.20.5102.019; Thu, 24 Mar 2022
 14:27:45 +0000
Message-ID: <9ccf422e-a3c0-d5b3-8d4a-53345619e980@nvidia.com>
Date:   Thu, 24 Mar 2022 19:57:28 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v2 5/5] vfio/pci: add the support for PCI D3cold state
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org
References: <20220124181726.19174-1-abhsahu@nvidia.com>
 <20220124181726.19174-6-abhsahu@nvidia.com>
 <20220309102642.251aff25.alex.williamson@redhat.com>
 <a6c73b9e-577b-4a18-63a2-79f0b3fa1185@nvidia.com>
 <20220311160627.6ec569a9.alex.williamson@redhat.com>
 <02691b8d-1aa7-e6a3-f179-8793410e7263@nvidia.com>
 <20220316124401.5e1d5554.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220316124401.5e1d5554.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0007.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:80::6) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c334563-6e36-4ead-ce12-08da0da27652
X-MS-TrafficTypeDiagnostic: MN2PR12MB3790:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3790DBFA155AB5DBD402C9F7CC199@MN2PR12MB3790.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9axddBqUKon5rUM0Nse+YdygrrCQmsnjqJCBmq/2aQ6uEN1rOOPdHRrSYMqtDsOQxhowdc6Kvh84GFyUlvA3ALQ6ZNe3v/QGR1LTr0rCiFRTrBaqNRSdmLpZucElj/mMe6qCg+Dy2pFl6jcNmn/tVe+jj5xMxhry2i43UbelguhnqCC63B1a1XMcvPslSsI1pUZU3cfg16A7fpxhXXZBX1KL/ThxPx/sGMz1ALCeHayzuqUg97DcLNbaPxoKYA5A4fgk+HqKeGL/7Luj8/gedF2tiwAc3RxH5nxsZJtyl6Qj7sz15YVgi90z+TP1I7IsJc+YK2uAIwscN3H+Bz77ECDBYRSrM9iITKV5K3nGxSl+fE9xHcj2jPRhW3hPjId22Pc+XjsxuJgSKn/A1IGEO7SZMR/fkqVvVnbTVFAWOx5sJN5uOkD6+00IYesGZuQcBJsOGIb63dNJvqN+b7dMpTPIIajykVvzG+AOqrR0p8YyzfZiGLcylx4/VFVnn2TQqxc4KwtBn+v/FBsFcJyFqdZMZ2djFwgUMYKF7rmcYZ7Gv95XuFYpB+5Kzsr48ctkqgoh8JinMNVRlpqZKnG3T5WcncENNPUmJWwqMNN5Oh0W3NaWFZLRf1q7wtRXgfhPUYIOoOQ4N1MDfNngr763FXSlwYsPyOboBKs/m7w6TrNofq7VUzCwh9qM9wyiibJ69DkFpf/vtgNCNYgZSesIM2SVvFo9RJ1O8om2RsEHnp5fd3ibViwTNT/fsJSTDIjf14LCBD1BqcBEkXek5zHuAvj65z28EYAR1wI6ED5YdJM3vSIr17jRVjZwDQK7rkfcHL0vDrcHsU5CIDVxTikNj9ru9fU9l4OBHzV2irOakYLjbHsL4HJ5+QoYLcoKK0uE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(966005)(45080400002)(2906002)(66476007)(6916009)(4326008)(66556008)(66946007)(54906003)(316002)(8676002)(31686004)(508600001)(30864003)(8936002)(26005)(186003)(83380400001)(38100700002)(2616005)(86362001)(6666004)(31696002)(53546011)(55236004)(5660300002)(6506007)(6512007)(36756003)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzFWVVNiUCtxM1AwMGxlWlFTOWVNMmxocmhaMjhGenpUQUN1QmdFb2pKVm9C?=
 =?utf-8?B?VlRRRXFVNGE4S0xOWlZONFBpU2JTazE0ZjR2YVhuY2JFcmUzWDBjUmpSd0lj?=
 =?utf-8?B?cWliTGFYN1kwUk1RM3JZTENrejJFNGJxbHZ1Zjk1RVNJMllTd0c3SmIzWlEr?=
 =?utf-8?B?RmpvSDl4SVoyYlFiY3VoRFZJc0FLTnBuZWYwYTBlM1daTmNzYmhXYzU3RW9a?=
 =?utf-8?B?UzBWazhPamhMYlRGcG5yelYxNGZBZTlPSVZ6blZsVFU0cUNoa1NGak5PNnlk?=
 =?utf-8?B?dHdZa1JYRFhyblA2T1B5dTM2SUk0ekxvTnhPRVlGbVJ6bEVNYnU2d0ROTVht?=
 =?utf-8?B?NDhlSmI3dTNnMG1SalhrWll2amxVVUZiY0VNc01KWDdadUwzaGZxb2o0Qk9m?=
 =?utf-8?B?NGNxdXhsVVhJZW9jcGZiNU1SWVlIYjIxcE1BeVBqU0k4RkE3bHVuRnN2am5k?=
 =?utf-8?B?NXlMTENmMEp2cnVXSDZOckxqbzAxN0FWeURBakRhNG9hSVdocnIzczcreVh1?=
 =?utf-8?B?dU0rR2ZLdTBXQkdmSmFmNWt5NXRGc0taVW9CWUoxVzNuOXRWdVFzRFJRODZ1?=
 =?utf-8?B?Qyt4Wms0andHRkUwUldELzVKOFFvTFRSSmFVUVdvY1VPSVJObk1zR0VTVWpl?=
 =?utf-8?B?aEFJVFhSODRjcUY0K0RNdWhZZHFLUXBLeG1qUWZNS091eXdSSS9CQnJZdnU5?=
 =?utf-8?B?NE1ORGl6QVRMcjdza1RFNmVhejhJWW1uYnZxa21semdoa2owYkd0YXJLZWJj?=
 =?utf-8?B?SGxxUENTTk9kR3JoK09BR2pZbEJnSWtjUFI4SmIrUWdieUlldzR3MWk4R1Z0?=
 =?utf-8?B?ZzM1TitvbFFtNWhmbWJ6cG9vRTRqR1JwMDllSHJyQW9vL0tXeWc5R01iTGNh?=
 =?utf-8?B?L0t6aDFmTGc4UEJQMy9POGRmb0ljZVlaN1F3V1BhaG1JSE9KRE04Lyt4MkJj?=
 =?utf-8?B?a0tHang3bmRtSEdONkxLSW02SWNTYTJBMytyVFF3L0wrdXF3ZGFaS0RUVkVG?=
 =?utf-8?B?OE5CL2YxeUVBTnExRTgzeWJoZmQ2YnUyLzlFSVU4Y081ZmxmeUJCS0V4cHJ6?=
 =?utf-8?B?NW1ubXlUYUROV3BlN1l5NGx5SW9vQ0VZd3ZJU1lZb1lYZkk5TnltQUFXN0xO?=
 =?utf-8?B?aWpaNG1JNXVOUWJKcmRYS1VzQ1d6ZGV4dzFBS2ViL0l3QWJDdFlkRi9yaFdt?=
 =?utf-8?B?WHlpVkVtNVBVTURaeVl0bTlMOWQxa1lYR3A5aUFMUjQwT1hkelpXd0kwNGNX?=
 =?utf-8?B?MEFGNnlpbUU3ajlHMlBpK2x4elJFNG5oMlpVQjlRaWlyY3JwbytPZnNwMjhN?=
 =?utf-8?B?OHhqaWgwYitjd3pEeXJFdkZhS2VEcENvcXFBdHBOaVBJV043UTYxcUMwQkUr?=
 =?utf-8?B?ZkNsM1pDdnRoMzltdmZHenMwSEgrS0E4dFpGZFNCRWU0OS9Qd1k0UjZwTmF2?=
 =?utf-8?B?eG5PNFVLcmZBZUNjYUxxS1ZDd0dYazl0TkI0djR4NjlheldPVDYrRTlOemRC?=
 =?utf-8?B?YVcyOGxmSGJOTTM2ZG5uTDB0S3M1WTlPWU80dGJIUGJseVZrT2RtVE1kSGRI?=
 =?utf-8?B?WWNkZ1QvZE10Wlc3K0M0MFpabitSWDJlWUgwcCtoT0hCc3ZPbjlURmZtSTZ1?=
 =?utf-8?B?VkpBdmgva1EvMzVsTUZqTDlQY3hFSDgrdW9RQlg2WlByMjYvT2VLS2dWZVRl?=
 =?utf-8?B?VHBibW4rVExKQlBLbHVZVWhpUFRnNEdONXJPRkZqVzhNQ2d0cmNLcVZKSjVN?=
 =?utf-8?B?OG1FN0Zqd28yT0NvWkw3UDhvVVd4MkJSNVVJWklGeUdEQ3J0UXJ1b3pBa09j?=
 =?utf-8?B?NzJ2K0x6RFc2djcxSnI3ZEkzT1pta28zcHJLblVoQUlMYlN5OCtIMnFtWHFG?=
 =?utf-8?B?aWFXZTZtZjVTS2dnQjEzakpXUWVVelNwOHo1Y1pQQ0VJbnJheFAvTXZNN1JM?=
 =?utf-8?Q?Xq4W4658H3FnwQJoGOqLA/eD3vo4BRr0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c334563-6e36-4ead-ce12-08da0da27652
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 14:27:45.0641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ysWbZdpel20DWZPCca4Y1CigaAQuWNUAHirwG6JL0I+8SM5l4o2BDUzWNRPov+Vdtr27F2iqQNsphwje4OqBog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3790
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/17/2022 12:14 AM, Alex Williamson wrote:
> On Wed, 16 Mar 2022 11:11:04 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> On 3/12/2022 4:36 AM, Alex Williamson wrote:
>>> On Fri, 11 Mar 2022 21:15:38 +0530
>>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>>
>>>> On 3/9/2022 10:56 PM, Alex Williamson wrote:
>>>>> On Mon, 24 Jan 2022 23:47:26 +0530
>>>>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> ...
>>>>>> +             struct vfio_power_management vfio_pm;
>>>>>> +             struct pci_dev *pdev = vdev->pdev;
>>>>>> +             bool request_idle = false, request_resume = false;
>>>>>> +             int ret = 0;
>>>>>> +
>>>>>> +             if (copy_from_user(&vfio_pm, (void __user *)arg, sizeof(vfio_pm)))
>>>>>> +                     return -EFAULT;
>>>>>> +
>>>>>> +             /*
>>>>>> +              * The vdev power related fields are protected with memory_lock
>>>>>> +              * semaphore.
>>>>>> +              */
>>>>>> +             down_write(&vdev->memory_lock);
>>>>>> +             switch (vfio_pm.d3cold_state) {
>>>>>> +             case VFIO_DEVICE_D3COLD_STATE_ENTER:
>>>>>> +                     /*
>>>>>> +                      * For D3cold, the device should already in D3hot
>>>>>> +                      * state.
>>>>>> +                      */
>>>>>> +                     if (vdev->power_state < PCI_D3hot) {
>>>>>> +                             ret = EINVAL;
>>>>>> +                             break;
>>>>>> +                     }
>>>>>> +
>>>>>> +                     if (!vdev->runtime_suspend_pending) {
>>>>>> +                             vdev->runtime_suspend_pending = true;
>>>>>> +                             pm_runtime_put_noidle(&pdev->dev);
>>>>>> +                             request_idle = true;
>>>>>> +                     }
>>>>>
>>>>> If I call this multiple times, runtime_suspend_pending prevents it from
>>>>> doing anything, but what should the return value be in that case?  Same
>>>>> question for exit.
>>>>>
>>>>
>>>>  For entry, the user should not call moving the device to D3cold, if it has
>>>>  already requested. So, we can return error in this case. For exit,
>>>>  currently, in this patch, I am clearing runtime_suspend_pending if the
>>>>  wake-up is triggered from the host side (with lspci or some other command).
>>>>  In that case, the exit should not return error. Should we add code to
>>>>  detect multiple calling of these and ensure only one
>>>>  VFIO_DEVICE_D3COLD_STATE_ENTER/VFIO_DEVICE_D3COLD_STATE_EXIT can be called.
>>>
>>> AIUI, the argument is that we can't re-enter d3cold w/o guest driver
>>> support, so if an lspci which was unknown to have occurred by the
>>> device user were to wake the device, it seems the user would see
>>> arbitrarily different results attempting to put the device to sleep
>>> again.
>>>
>>
>>  Sorry. I still didn't get this point.
>>
>>  For guest to go into D3cold, it will follow 2 steps
>>
>>  1. Move the device from D0 to D3hot state by using config register.
>>  2. Then use this IOCTL to move D3hot state to D3cold state.
>>
>> Now, on the guest side if we run lspci, then following will be behavior:
>>
>>  1. If we call it before step 2, then the config space register
>>     can still be read in D3hot.
>>  2. If we call it after step 2, then the guest os should move the
>>     device into D0 first, read the config space and then again,
>>     the guest os should move the device to D3cold with the
>>     above steps. In this process, the guest OS driver will be involved.
>>     This is current behavior with Linux guest OS.
>>
>>  Now, on the host side, if we run lspci,
>>
>>  1. If we call it before step 2, then the config space register can
>>     still be read in D3hot.
>>  2. If we call after step 2, then the D3cold to D0 will happen in
>>     the runtime resume and then it will be in D0 state. But if we
>>     add support to allow re-entering into D3cold again as I mentioned
>>     below. then it will again go into D3cold state.
> 
> I was speculating about the latter scenario mechanics.  If the user has
> already called STATE_ENTER for d3cold, should a subsequent STATE_ENTER
> for d3cold generate an error?  Likewise should STATE_EXIT generate an
> error if the device was not previously placed in d3cold?  But then any
> host access that triggers vfio_pci_core_runtime_resume() is effective
> the same as a STATE_EXIT, which may be unknown to the user.  So if we
> had decided to generate errors on duplicate STATE_ENTER/EXIT calls, the
> user's state model is broken by the arbitrary host activity and either
> way the device is no longer in the user requested state and the user
> receives no notification of this.
> 

 I will check regarding this part and explore how we can do error
 handling along with arbitrary host activity.

> ...
>>>>>> +long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>>>>>> +                      unsigned long arg)
>>>>>> +{
>>>>>> +#ifdef CONFIG_PM
>>>>>> +     struct vfio_pci_core_device *vdev =
>>>>>> +             container_of(core_vdev, struct vfio_pci_core_device, vdev);
>>>>>> +     struct device *dev = &vdev->pdev->dev;
>>>>>> +     bool skip_runtime_resume = false;
>>>>>> +     long ret;
>>>>>> +
>>>>>> +     /*
>>>>>> +      * The list of commands which are safe to execute when the PCI device
>>>>>> +      * is in D3cold state. In D3cold state, the PCI config or any other IO
>>>>>> +      * access won't work.
>>>>>> +      */
>>>>>> +     switch (cmd) {
>>>>>> +     case VFIO_DEVICE_POWER_MANAGEMENT:
>>>>>> +     case VFIO_DEVICE_GET_INFO:
>>>>>> +     case VFIO_DEVICE_FEATURE:
>>>>>> +             skip_runtime_resume = true;
>>>>>> +             break;
>>>>>
>>>>> How can we know that there won't be DEVICE_FEATURE calls that touch the
>>>>> device, the recently added migration via DEVICE_FEATURE does already.
>>>>> DEVICE_GET_INFO seems equally as prone to breaking via capabilities
>>>>> that could touch the device.  It seems easier to maintain and more
>>>>> consistent to the user interface if we simply define that any device
>>>>> access will resume the device.
>>>>
>>>>  In that case, we can resume the device for all case without
>>>>  maintaining the safe list.
>>>>
>>>>> We need to do something about interrupts though. > Maybe we could error the user ioctl to set d3cold
>>>>> for devices running in INTx mode, but we also have numerous ways that
>>>>> the device could be resumed under the user, which might start
>>>>> triggering MSI/X interrupts?
>>>>>
>>>>
>>>>  All the resuming we are mainly to prevent any malicious sequence.
>>>>  If we see from normal OS side, then once the guest kernel has moved
>>>>  the device into D3cold, then it should not do any config space
>>>>  access. Similarly, from hypervisor, it should not invoke any
>>>>  ioctl other than moving the device into D0 again when the device
>>>>  is in D3cold. But, preventing the device to go into D3cold when
>>>>  any other ioctl or config space access is happening is not easy,
>>>>  so incrementing usage count before these access will ensure that
>>>>  the device won't go into D3cold.
>>>>
>>>>  For interrupts, can the interrupt happen (Both INTx and MSI/x)
>>>>  if the device is in D3cold?
>>>
>>> The device itself shouldn't be generating interrupts and we don't share
>>> MSI interrupts between devices (afaik), but we do share INTx interrupts.
>>>
>>>>  In D3cold, the PME events are possible
>>>>  and these events will anyway resume the device first. If the
>>>>  interrupts are not possible then can we disable all the interrupts
>>>>  somehow before going calling runtime PM API's to move the device into D3cold
>>>>  and enable it again during runtime resume. We can wait for all existing
>>>>  Interrupt to be finished first. I am not sure if this is possible.
>>>
>>> In the case of shared INTx, it's not just inflight interrupts.
>>> Personally I wouldn't have an issue if we increment the usage counter
>>> when INTx is in use to simply avoid the issue, but does that invalidate
>>> the use case you're trying to enable?
>>
>>  It should not invalidate the use case which I am trying to support.
>>
>>  But incrementing the usage count for device already in D3cold
>>  state will cause it to wake-up. Wake-up from D3cold may take
>>  somewhere around 500 ms – 1500 ms (or sometimes more than that since
>>  it depends upon root port wake-up time). So, it will make the
>>  ISR time high. For the root port wake-up time, please refer
>>
>>  https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Ftorvalds%2Flinux.git%2Fcommit%2F%3Fid%3Dad9001f2f41198784b0423646450ba2cb24793a3&amp;data=04%7C01%7Cabhsahu%40nvidia.com%7C55ab0ec2867c46a2a16208da077cf4ff%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637830530524517878%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=A28ExovVhK3MB19U1aFTuwd9LTRcjbDxqYQ7eHC83VQ%3D&amp;reserved=0
>>
>>  where it can take 1100ms alone for the port port on
>>  older platforms.
> 
> 
> Configuring interrupts on the device requires it to be in D0, there's
> no case I can imagine where we're incrementing the usage counter for
> the purpose of setting INTx where the device is not already in D0.  I'm
> certainly not suggesting incrementing the usage counter from within the
> interrupt handler.
> 
> 
>>> Otherwise I think we'd need to
>>> remove and re-add the handler around d3cold.
>>>
>>>>  Returning error for user ioctl to set d3cold while interrupts are
>>>>  happening needs some synchronization at both interrupt handler and
>>>>  ioctl code and using runtime resume inside interrupt handler
>>>>  may not be safe.
>>>
>>> It's not a race condition to synchronize, it's simply that a shared
>>> INTX interrupt can occur any time and we need to make sure we don't
>>> touch the device when that occurs, either by preventing d3cold and INTx
>>> in combination, removing the handler, or maybe adding a test in the
>>> handler to not touch the device - either of the latter we need to be
>>> sure we're not risking introducing interrupts storms by being out of
>>> sync with the device state.
>>>
>>
>>  Adding a test to detect the D3cold seems to be better option in
>>  this case but not sure about interrupts storms.
> 
> This seems to be another case where the device power state being out of
> sync from the user is troublesome.  For instance, if an arbitrary host
> access to the device wakes it to D0, it could theoretically trigger
> device interrupts.  Is a guest prepared to handle interrupts from a
> device that it's put in D3cold and not known to have been waked?
> 

 This behavior should depend upon driver and hypervisor implementation.
 From the host side, vfio driver triggers eventfd and then the driver
 ISR routine will be invoked directly without involvement of
 any other code in the kernel side. Now, if driver maintains internally 
 that the device in low power state then it can return early from ISR.
 But if driver tries to do any config space access, then the behavior
 will be undefined.

 To handle this case, would removing the handler be better option since
 it will make sure that no interrupt will be forwarded to guest or
 the vfio driver can handle this interrupt and discard it when the
 guest in D3cold. 

> ...
>>>>>> @@ -2219,11 +2341,61 @@ static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
>>>>>>  #ifdef CONFIG_PM
>>>>>>  static int vfio_pci_core_runtime_suspend(struct device *dev)
>>>>>>  {
>>>>>> +     struct pci_dev *pdev = to_pci_dev(dev);
>>>>>> +     struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
>>>>>> +
>>>>>> +     down_read(&vdev->memory_lock);
>>>>>> +
>>>>>> +     /*
>>>>>> +      * runtime_suspend_pending won't be set if there is no user of vfio pci
>>>>>> +      * device. In that case, return early and PCI core will take care of
>>>>>> +      * putting the device in the low power state.
>>>>>> +      */
>>>>>> +     if (!vdev->runtime_suspend_pending) {
>>>>>> +             up_read(&vdev->memory_lock);
>>>>>> +             return 0;
>>>>>> +     }
>>>>>
>>>>> Doesn't this also mean that idle, unused devices can at best sit in
>>>>> d3hot rather than d3cold?
>>>>>
>>>>
>>>>  Sorry. I didn't get this point.
>>>>
>>>>  For unused devices, the PCI core will move the device into D3cold directly.
>>>
>>> Could you point out what path triggers that?  I inferred that this
>>> function would be called any time the usage count allows transition to
>>> d3cold and the above test would prevent the device entering d3cold
>>> unless the user requested it.
>>>
>>
>>  For PCI runtime suspend, there are 2 options:
>>
>>  1. Don’t change the device power state from D0 in the driver
>>     runtime suspend callback. In this case, pci_pm_runtime_suspend()
>>     will handle all the things.
>>
>>     https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Felixir.bootlin.com%2Flinux%2Fv5.17-rc8%2Fsource%2Fdrivers%2Fpci%2Fpci-driver.c%23L1285&amp;data=04%7C01%7Cabhsahu%40nvidia.com%7C55ab0ec2867c46a2a16208da077cf4ff%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637830530524517878%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=yt%2FjogIO6Wbz6LJmcvTsU3nthgt6DrJvdF%2FNprnYkaI%3D&amp;reserved=0
>>
>>     For unused device, runtime_suspend_pending will be false since
>>     it can be set by d3cold ioctl.
> 
> So our runtime_suspend callback is not gating putting the device into
> d3cold, we effectively do the same thing either way, it's only
> protected by the memory_lock in the case that the user has requested
> it.  Using runtime_suspend_pending here seems a bit misleading since
> theoretically we'd want to hold memory_lock in any case of getting to
> th runtime_suspend callback while the device is opened.
> 
>>  2. With the used device, the device state will be changed to D3hot first
>>     with vfio_pm_config_write(). In this case, the pci_pm_runtime_suspend()
>>     expects that all the handling has already been done by driver,
>>     otherwise it will print the warning and return early.
>>
>>     “PCI PM: State of device not saved by %pS”
>>
>>     https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Felixir.bootlin.com%2Flinux%2Fv5.17-rc8%2Fsource%2Fdrivers%2Fpci%2Fpci-driver.c%23L1280&amp;data=04%7C01%7Cabhsahu%40nvidia.com%7C55ab0ec2867c46a2a16208da077cf4ff%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637830530524517878%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=feiNcCYVX%2FBElbXzd%2BzHqctiPYJGO0T2g71Kx1eHIXY%3D&amp;reserved=0
>>
>>>>  For the used devices, the config space write is happening first before
>>>>  this ioctl is called and the config space write is moving the device
>>>>  into D3hot so we need to do some manual thing here.
>>>
>>> Why is it that a user owned device cannot re-enter d3cold without
>>> driver support, but and idle device does?  Simply because we expect to
>>> reset the device before returning it back to the host or exposing it to
>>> a user?  I'd expect that after d3cold->d0 we're essentially at a
>>> power-on state, which ideally would be similar to a post-reset state,
>>> so I don't follow how driver support factors in to re-entering d3cold.
>>>
>>
>>  In terms of nvidia GPU, the idle unused device is equivalent to
>>  uninitialized PCI device. In this case, no internal HW modules
>>  will be initialized like video memory. So, it does not matter
>>  what we do with the device before that. It is fine to re-enter
>>  d3cold since the HW itself is not initialized. Once the device
>>  is owned by user, then in the guest OS side the nvidia driver will run
>>  and initialize all the HW modules including video memory. Now,
>>  before removing the power, we need to make sure that video
>>  memory should come in the same state after resume as before
>>  suspending.
>>
>>  If we don’t keep the video memory in self refresh state, then it is
>>  equivalent to power on state. But if we keep the video memory
>>  in self refresh state, then it is different from power-on state.
>>
>>>>>> +
>>>>>> +     /*
>>>>>> +      * The runtime suspend will be called only if device is already at
>>>>>> +      * D3hot state. Now, change the device state from D3hot to D3cold by
>>>>>> +      * using platform power management. If setting of D3cold is not
>>>>>> +      * supported for the PCI device, then the device state will still be
>>>>>> +      * in D3hot state. The PCI core expects to save the PCI state, if
>>>>>> +      * driver runtime routine handles the power state management.
>>>>>> +      */
>>>>>> +     pci_save_state(pdev);
>>>>>> +     pci_platform_power_transition(pdev, PCI_D3cold);
>>>>>> +     up_read(&vdev->memory_lock);
>>>>>> +
>>>>>>       return 0;
>>>>>>  }
>>>>>>
>>>>>>  static int vfio_pci_core_runtime_resume(struct device *dev)
>>>>>>  {
>>>>>> +     struct pci_dev *pdev = to_pci_dev(dev);
>>>>>> +     struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
>>>>>> +
>>>>>> +     down_write(&vdev->memory_lock);
>>>>>> +
>>>>>> +     /*
>>>>>> +      * The PCI core will move the device to D0 state before calling the
>>>>>> +      * driver runtime resume.
>>>>>> +      */
>>>>>> +     vfio_pci_set_power_state_locked(vdev, PCI_D0);
>>>>>
>>>>> Maybe this is where vdev->power_state is kept synchronized?
>>>>>
>>>>
>>>>  Yes. vdev->power_state will be changed here.
>>>>
>>>>>> +
>>>>>> +     /*
>>>>>> +      * Some PCI device needs the SW involvement before going to D3cold
>>>>>> +      * state again. So if there is any wake-up which is not triggered
>>>>>> +      * by the guest, then increase the usage count to prevent the
>>>>>> +      * second runtime suspend.
>>>>>> +      */
>>>>>
>>>>> Can you give examples of devices that need this and the reason they
>>>>> need this?  The interface is not terribly deterministic if a random
>>>>> unprivileged lspci on the host can move devices back to d3hot.
>>>>
>>>>  I am not sure about other device but this is happening for
>>>>  the nvidia GPU itself.
>>>>
>>>>  For nvidia GPU, during runtime suspend, we keep the GPU video memory
>>>>  in self-refresh mode for high video memory usage. Each video memory
>>>>  self refesh entry before D3cold requires nvidia SW involvement.
>>>>  Without SW self-refresh sequnece involvement, it won't work.
>>>
>>>
>>> So we're exposing acpi power interfaces to turn a device off, which
>>> don't really turn the device off, but leaves it in some sort of
>>> low-power memory refresh state, rather than a fully off state as I had
>>> assumed above.  Does this suggest the host firmware ACPI has knowledge
>>> of the device and does different things?
>>>
>>
>>  I was trying to find the public document regarding this part and
>>  it seems following Windows document can help in providing some
>>  information related with this
>>
>>  https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fwindows-hardware%2Fdrivers%2Fbringup%2Ffirmware-requirements-for-d3cold&amp;data=04%7C01%7Cabhsahu%40nvidia.com%7C55ab0ec2867c46a2a16208da077cf4ff%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637830530524517878%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=KVAt%2BajnWl5eM4XITUMmR2EYIDZdfYWt9fyDD%2BhKB4Y%3D&amp;reserved=0
>>
>>  “Putting a device in D3cold does not necessarily mean that all
>>   sources of power to the device have been removed—it means only
>>   that the main power source, Vcc, is removed. The auxiliary power
>>   source, Vaux, might also be removed if it is not required for
>>   the wake logic”.
>>
>>  So, for generic self-refresh D3cold (means in Desktop), it is mainly
>>  relying on auxiliary power. For notebooks, we ask to do some
>>  customization in acpi power interfaces side to support
>>  video memory self-refresh.
> 
> And that customization must rely on some aspect of the GPU state,
> right?

 The notebook customization is mainly related with ACPI
 implementation and HW side design so that the main power is
 turned off and the aux power is supplied during that time.

> We send the GPU to d3cold the first time and we get this memory
> self-refresh behavior, but the claim here is that if we wake the device
> to d0 and send it back to d3cold that video memory will be lost.  So
> the variable here has something to do with the device state itself.
> Therefore is there some device register that could be preserved and
> restored around d3cold so that we could go back into the self-refresh
> state?
> 

 Following is the more detail around this.

 1. For the first D0->D3cold transition, the driver running in the
    guest side uses the firmware state machine. The firmware will be
    still running since the GPU will be in powered on state unless
    the root port actually removes power.

 2. Before removing power, the root port sends PME_Turn_Off message.
    The detail around this area is documented in

    [PCIe spec v5, PME Synchronization 5.3.3.2.1]

 5.3.3.2.1 PME Synchronization

 PCI Express-PM introduces a fence mechanism that serves to
 initiate the power removal sequence while also
 coordinating the behavior of the platform's power management
 controller and PME handling by PCI Express agents.
 PME_Turn_Off Broadcast Message

 Before main component power and reference clocks are
 turned off, the Root Complex or Switch Downstream Port must
 issue a broadcast Message that instructs all agents
 Downstream of that point within the hierarchy to cease initiation of
 any subsequent PM_PME Messages, effective immediately upon
 receipt of the PME_Turn_Off Message. Each PCI Express agent is required
 to respond with a TLP “acknowledgement” Message, PME_TO_Ack that is always
 routed Upstream.


 3. The firmware running inside nvidia GPU listens for this
    PME_Turn_Off and move the video memory in self-refresh state.
 
 4. If video memory self-refresh is not required, then no handling
    is needed for these PME messages since power of all components
    is going to be removed and the driver will initialize the
    video memory from scratch again.

 Now, in the second D3cold transition, we won’t have firmware running
 which is responsible for putting the memory in self-refresh state and
 that is the reason why we can’t go into self-refresh state during
 second D3cold transition. This firmware load and initialization
 can happen only from the driver.

> 
>>>>  Details regarding runtime suspend with self-refresh can be found in
>>>>
>>>>  https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdownload.nvidia.com%2FXFree86%2FLinux-x86_64%2F495.46%2FREADME%2Fdynamicpowermanagement.html%23VidMemThreshold&amp;data=04%7C01%7Cabhsahu%40nvidia.com%7C55ab0ec2867c46a2a16208da077cf4ff%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637830530524517878%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=kddgrKLWH8j4upDlN4pXtU9pjjHa6Cxa3nQ8QS3Nq30%3D&amp;reserved=0
>>>>
>>>>  But, if GPU video memory usage is low, then we turnoff video memory
>>>>  and save all the allocation in system memory. In this case, SW involvement
>>>>  is not required.
>>>
>>> Ok, so there's some heuristically determined vram usage where the
>>> driver favors suspend latency versus power savings and somehow keeps
>>> the device in this low-power, refresh state versus a fully off state.
>>> How unique is this behavior to NVIDIA devices?  It seems like we're
>>> trying to add d3cold, but special case it based on a device that might
>>> have a rather quirky d3cold behavior.  Is there something we can test
>>> about the state of the device to know which mode it's using?
>>
>>  Since vfio is generic driver so testing the device mode here
>>  seems to be challenging.
>>
>>> Is there something we can virtualize on the device to force the driver to use
>>> the higher latency, lower power d3cold mode that results in fewer
>>> restrictions?  Or maybe this is just common practice?
>>>
>>
>>  Yes. We can enforce this. But this option won’t be useful for modern
>>  use cases. Let’s assume if we have 16GB video memory usage, in that
>>  case, it will take lot of time in entry and exit and make the feature
>>  unusable. Also, the system memory will be limited in the guest
>>  side so enough system memory is again challenge.
> 
> Good point, the potential extent of video memory is too excessive to
> not support a self-refresh mode.
> 
>>>>> How useful is this implementation if a notice to the guest of a resumed
>>>>> device is TBD?  Thanks,
>>>>>
>>>>> Alex
>>>>>
>>>>
>>>>  I have prototyped this earlier by using eventfd_ctx for pme and whenever we get
>>>>  a resume triggered by host, then it will forward the same to hypervisor.
>>>>  Then in the hypervisor, it can write into virtual root port PME related registers
>>>>  and send PME event which will wake-up the PCI device in the guest side.
>>>>  It will help in handling PME events related wake-up also which are currently
>>>>  disabled in PATCH 2 of this patch series.
>>>
>>> But then what does the guest do with the device?  For example, if we
>>> have a VM with an assigned GPU running an idle desktop where the
>>> monitor has gone into power save, does running lspci on the host
>>> randomly wake the desktop and monitor?
>>
>>  For Linux OS + NVIDIA driver, it seems it will just wake-up the
>>  GPU up and not the monitor. With the bare-metal setup, I waited
>>  for monitor to go off with DPMS and then the GPU went into
>>  suspended state. After that, If I run lspci command,
>>  then the GPU moved to active state but monitor was
>>  still in the off state and after lspci, the GPU went
>>  into suspended state again.
>>
>>  The monitor is waking up only if I do keyborad or mouse
>>  movement.
> 
> The monitor waking would clearly be a user visible sign that this
> doesn't work according to plan,

  I have confirmed this internally also from user space graphics driver
  folks and the GPU wake-up should not cause any monitor wake-up.

> but we still have the fact that the GPU
> is awake and consuming power, wasting battery on a mobile platform,
> still seems like a symptom that this solution is incomplete.
> >>> I'd like to understand how
>>> unique the return to d3cold behavior is to this device and whether we
>>> can restrict that in some way.  An option that's now at our disposal
>>> would be to create an NVIDIA GPU variant of vfio-pci that has
>>> sufficient device knowledge to perhaps retrigger the vram refresh
>>> d3cold state rather than lose vram data going into a standard d3cold
>>> state.  Thanks,
>>>
>>> Alex
>>>
>>
>>  Adding vram refresh d3cold state with vfio-pci variant is not straight
>>  forward without involvement of nvidia driver itself.
>>
>>  One option is to add one flag in D3cold IOCTL itself to differentiate
>>  between 2 variants of D3cold entry (One which allows re-entering to
>>  D3cold and another one which won’t allow re-entering to D3cold) and
>>  set it default for re-entering to D3cold. For nvidia or similar use
>>  case, the hypervisor can set this flag to prevent re-entering to D3cold.
> 
> QEMU doesn't know the hardware behavior either.
> 

 We can pass this information by command line parameter which user
 can set. This command line parameter can be specified per device,
 but this requires user to be aware of the behavior for PCI device.

>>  Otherwise, we can add NVIDIA vendor ID check and restrict this
>>  to nvidia alone.
> 
> Either of these solutions presumes there's a worthwhile use case
> regardless of the fact that the GPU can be woken by arbitrary,
> unprivileged actions on the host.

 Yes. In that case, another option would be to prevent GPU wake-up
 completely on the host side. If we add some flag in core PM code
 and return early without waking up the device if this flag is set.
 So, if user runs lspci or similar command, then the error will
 be returned from PM runtime resume API and all the value will be
 0xffff. In pass-through mode, the PCI device is owned by guest
 so if guest has put device into D3cold then host can honor that
 instead of waking the device.

 But we need to see how this model works with multi function device
 where only not all functions are bind with vfio driver.

> It seems that either we should be
> able to put the device back into a low power state ourselves after such
> an event

 For NVIDIA GPU, we can’t put the device into low power state
 since we need firmware to be present on the GPU and this can be
 loaded and initialized only by the driver.

> or be able to trigger an eventfd to the user which is plumbed
> through pme in the guest so that the guest can put the device back to
> low power after such an event.  Getting the device into a transient low
> power state that it can slip out of so easily doesn't seem like a
> complete solution to me.  Thanks,
> 
> Alex
> 

 Yes. But this is also won’t work in all the cases since it has
 dependency upon QEMU or hypervisor. The PME interrupt will go to
 root port inside of end-point so we need to create virtual root port
 also in that case. If nothing else works out then we can go for this
 approach.

 Thanks,
 Abhishek
