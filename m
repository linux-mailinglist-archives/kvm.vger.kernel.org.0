Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C0858011D
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 17:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235810AbiGYPFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 11:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiGYPE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 11:04:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C412963F2;
        Mon, 25 Jul 2022 08:04:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JycwG0ekZNr3JgILgElj3VBVIEWhuzwmgZ2AsthA6b26ojrk6ae0GhU6Io2zJ8JVCXw7jrDHqEH8t2xDIMuwvSiqEdGPAKlgoEvye6pTXtDxDUP5lnzB6IjH/EHiDUA0Z9NjTm2PQPVC7lf2dkHoQmHweY9gQ9C90eC0n9fxOrKQ8uvMzgr7tH96AtjiTrY8XtKZzxMIO7XomrjKYOVUfuSI4e3jOw/Jz66leHFAk+NDMQSwuh7ZAPio+TtLmO7V2ysxG/w/WIO4UQBGaH8dnL6zvHBpCMSp9FU3N4PIbF/f9dy9TtNh8wfs1qA7aTGvpp08jWQhgu7dyxy0rA1xuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GtS745aC1kfm/yavZ1A5WOhL4qTyaMOKUUgj94JOQeE=;
 b=YSePFRRx/F0LpF8rhD0AoKXcUGt+qg4LiHoRht62bEPojCsKrSuMrIqjjJe6gneBJpRQC0k+z/vmcgRozcLbTbnub7RzmjYOCaEHmYQ37cFHTpi1RUhZLG6u+WHJfKiq946iBPqP3NpQYi6mUrdQN6aPouPZhR4abboyKaP3gqMb/ZVWY1xYs2GeI360sI23EDG38Hrnqo33mDTPNRy7lFZmkm81iR8d0phAa2/iHHxsUVHXuFVKDhNACJa2YFpvb5pEnb3ecFtX8kNQkkEF9FGvLQxbXbewVvLCw9Xa9lwo5Zno1HsFl2yBt3atJ6K0wcrVb80BsmxnjkH2HiL/Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtS745aC1kfm/yavZ1A5WOhL4qTyaMOKUUgj94JOQeE=;
 b=WoCHVNPLFHgaGk0ptg59s621t/+tchOhq9d6u5R70HFT4CwMIi+yR4gdbFXAYgpI8S9fWAhgk4XnDbq087lLdjjI+6zO9AkY9ZA/KSFWtT6jlg0hPWowSx0SIqWFvbn+vr+iJd6dyieBbHyl8zdCLRF8oDsAQ304nW9VV7lR4kRX5+yKvD5zNyaoE+SxF0mEBpjjpwVbaUECHD8n33MMmzMZxUvu58hBVEjx9p/5My+mZvzaDAeuo7ZfioNu8Py0FlpPXL87L+W5xuBtyYnLJiHZTMhVO2wqSbatlCO4Gz7AEuSJUQv4p1PDsO2/qceOor+w+XplTG18HDrxIhtcxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by BYAPR12MB4789.namprd12.prod.outlook.com (2603:10b6:a03:111::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.23; Mon, 25 Jul
 2022 15:04:53 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed%8]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 15:04:53 +0000
Message-ID: <9c9b9a7a-bee4-305a-019b-54b96ffba3af@nvidia.com>
Date:   Mon, 25 Jul 2022 20:34:40 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v5 5/5] vfio/pci: Implement
 VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
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
References: <20220719121523.21396-1-abhsahu@nvidia.com>
 <20220719121523.21396-6-abhsahu@nvidia.com>
 <20220721163442.7d2ae47f.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220721163442.7d2ae47f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR0101CA0072.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::34) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f261cd23-9111-4814-a3de-08da6e4f078a
X-MS-TrafficTypeDiagnostic: BYAPR12MB4789:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XFDmGZ7ocqnepdpfiRQDljHdRcXjYt35GoBSRXdnkYjWh9lIcIKzgRrgnEph/AZ8t5RXKFlr2GNTKFM2MxmF4phdyjdRr5dB06JaauTjEInWfLkqbyztBD+AtMeGVJbRBkkQSVhC6cry9YSWIIcNRvaxICDryc3uK15+FbAEE4JXEk5gO/BglTRoTieMcusA4q6c/xTKdbTIA0IwJsBgsjLygz33bgQwUfBYPTqTg5p1dkCliYXoJ1fo1qbkRTdZkcf9fu7TNvViZSbnPCX54IKiMEFvyMaB+NBiNC0ED3XKYeo6Cu7cG+KtAFsRj6uNWD5K5EaNdxFktqdR9vA0tkwdCZahTCeF33AEN4hiw55f1xWqFp8AYNLWJbZDSrukByjMTtFnwbbMEAsampAkCmzNKd/P16rCYEHeYpK2RT0/+OU+OTMy3g4lxl0s7yipF5oXsjp76/W03Bg6Zy4chdpVf3WRiPUkFR2+Vcz18yF2kNl61FjEQKj2i3j2hY0yeS/mWVc24r6Hw5QWTBEK33sosvRslGIzi2tpbj36TkfdT/Zy2h12wwHcaaV/CLDpRNclqORDp0nE2vurvsCVOe8W1cFIzRiUzGDCii5PxikXQozW3jdHVIx702hyHnHQ4r9SNSIva3l3mNS4FYmAAvC7oI6L9ehaU84t3Y66LjL+j3QDsJkxistD3p49YpEb4owc9W/m2xejLcdy5Pa64gmE2wYxVE7j+IgxRUGqS34MdfShTMnI9QAD4O5dHeSWUsN61l3iuOcqQhRGVJXJQkV+u6oLiSeiKe/GdBZERFstTpiR3U8RzpXw+Y02Cn0GMlRFKeuyTGAum4FFoQCHdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(186003)(38100700002)(4326008)(8676002)(66556008)(66476007)(316002)(66946007)(54906003)(6916009)(31686004)(36756003)(6486002)(6506007)(86362001)(6666004)(41300700001)(31696002)(26005)(2906002)(53546011)(55236004)(6512007)(7416002)(83380400001)(2616005)(5660300002)(8936002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDNoUVcwY0pNL3gxaTZTYmZVV3pUcy9SVE5OVG5HdmcwSkdFM3VGZkdUWlhj?=
 =?utf-8?B?d28zaWRRR1pMSmloOGg1bWtaZE5ZUFIvNDhyb3FPVXVWa2lMa3B2WkdQMXlP?=
 =?utf-8?B?T05iK1VsSjVSREtCYUUxNFlpdEJIeVU4OGp0T1d3NEZnQjRCRDVxN1hZM1RF?=
 =?utf-8?B?MHRBWkJZRld4aGFUQTVFdHB4MEIvZVd3REpEK0EzbElla1BxNTNINk8wRE9Q?=
 =?utf-8?B?V21ydENuZi9uM1Z3WVlTWVRZUHFBRkZSOWVWRk1PMWM3R2MyOWNSSUFleTIw?=
 =?utf-8?B?Sk9wTmdNUTZIWWdtYkpiWkx4MTl6dWZZNEFkMHBUbXRpdmQ3VnNoT2ZZYVNY?=
 =?utf-8?B?WU02ejRySGFQK210Um5HajE2YW9zUDczYVlocXdGUVZ6N0RmQlYvUG4xVXZS?=
 =?utf-8?B?cndFTjFkTU1rL3Y4bnRFMWFIL1B3aXRISHY3WWVKdG5OYUVNVi9TVzN5dUFI?=
 =?utf-8?B?V0JQYW1xT3lUNzYwNjNFT0hPejV4ZTl1VDJYVUxSd2RkUWw1TU9ocUtvUjhp?=
 =?utf-8?B?b3ZCVGVSQ2M3WDVjdXNZeWV0TW93Nm1aNk13LzhWZWVLSUhWYkRJWDdWejRj?=
 =?utf-8?B?a2JaMXFjREtwS29qUEVQQlgrUlBWNFBzNU5UR1hJMVROMUZPUE9XMVFLYWpR?=
 =?utf-8?B?WERjaS81VTBFSTJKREMyYjRNblJrWVhFNzhFWHhReWt6akxBdmUxQkhpZXpV?=
 =?utf-8?B?dkFURGtJTnpiQnFsMEtRangrTnRvNW9lb3VPQi9NaFIyZ3ZwZTlHVWpoeDBW?=
 =?utf-8?B?aDJIY0ZhMkk3dzQ2WGNyWnB1QWVkVUZmbElSdG1tY0lOaFFlR0UvTWUzcDJa?=
 =?utf-8?B?N2dqMVhMaWJuTzl2QmtvazBlS3d1L1NaUThlSGphTk9YK3RpWkVTQ1FOU013?=
 =?utf-8?B?WEZOU052RWxkWHhFc2JaZ3BKUXQ2OU81ODF0S2Q1WTRBOWNkZ1VvNFRoRU9x?=
 =?utf-8?B?ekxJVSsvalV0ck5aNnE3Ty9ZTzAvMVd2ZWlvSlhFTmNLNFZXMU5WNVpTUlly?=
 =?utf-8?B?aTlxU0tOL2RacVJ4WnFjc1V2RHE2SFRmaWxKWDI5TlJRd25GUEV1akZPb0Z4?=
 =?utf-8?B?V29nMUc5N1VtVEhRYkZOUzRkaTJEamZjU2xhSjlCaE9IUlp3SWVidXoxSFdr?=
 =?utf-8?B?NkJRV0dMMFYvZ1BqeHg4dGw1UHZkU2lBWnBGd0ZhSmo5VmtkVHk1V25IL25B?=
 =?utf-8?B?RlNKbXg1cUhKYUVzaDRsc2lIV3ZBMzBaY0hXblJ5OHcwT1NOUkp5YnJsNloy?=
 =?utf-8?B?ajFoWXZUU0s4R2krWldhdGtRcmRvSEJodWRDTVcrRWlYVzlZMVo0WFpoak5P?=
 =?utf-8?B?NVlLMlNITm1mWGwvWE9JM0xTYUY0WEVlWm91SHFyUm5YWHVZRVVjazFPRU1y?=
 =?utf-8?B?cndNYWxsNldpNG5vSmlTQVludCtvTmNaZStaUnJFUW56SXBncnNUZGd4a1R6?=
 =?utf-8?B?Zkh1cnlrU3MrcC94TDcwME5OOXp1QVJRV2k5enNNdXFGSGVsbzVPaXdQOTNK?=
 =?utf-8?B?NnVYNGM1Y2JGZUlNTDlRVUFybTFJVXhHVVUyMWhhaUtPdUxxREdjUVM2OCtx?=
 =?utf-8?B?MHNhL2RYbWtmNlk1ZGZRR3daUzhDRU9HZjFRdGQ2S1FzWHpBeDU0YVBFMHFi?=
 =?utf-8?B?ZUtoWXBaa1B1VFpKcHRzYjBOM3ZPaGsvMHkzS1FwQWlvcm9BNTdudlRRRHo2?=
 =?utf-8?B?VFVBdzZ2NEZDUjMvY3YzZWNzSjRXUTZHUnk3cWR2RDFZcEhTV215Uy9qOEJZ?=
 =?utf-8?B?ZDlJSnNVbTZpQW9JYXlCUlpmSW1nYmlvZlJLcUhVL1ZleG1LT1VTakZJWU9M?=
 =?utf-8?B?bHA5WDNGTkRrVnd6cHNERUV4Z2pkeXBsUTEzNXNpY24rZDJ3NmxSUGJFc0Nn?=
 =?utf-8?B?bHMrbVhEV1JGU0RYVVFKaUIwWnAwVDkxVXlCRUtQai8zakYzLzMraDZLcVAv?=
 =?utf-8?B?Q0RGWHE3ZXh1Y1cxdkJpZ3lGTjZVWHdPQ3M1bkFGUFhjeStETTRMOHd1eEpq?=
 =?utf-8?B?R2Rha2hQcmp6QVFaQjhkTG5ySGY1SU5zUVJPS2VubXd1d21UUGQ4ekpaY0dr?=
 =?utf-8?B?S3VXUEdwNXU0VlFXN1lPOXdVQUpDcE1GV2kzWXU4QjRyaTQ0SVFhRlZ0b1Rj?=
 =?utf-8?Q?CUBz/nWXTS8wSPjy79DGsmKbV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f261cd23-9111-4814-a3de-08da6e4f078a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:04:53.7781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K2M0goy8WE0pz8eMmXg5IvofdeqKpeUbdk5kQhGS0EGllfZz70taDjHQ4jzbj2gsS29QFFd75LBh507GQ1k6Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4789
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/22/2022 4:04 AM, Alex Williamson wrote:
> On Tue, 19 Jul 2022 17:45:23 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> This patch implements VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
>> device feature. In the VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY, if there is
>> any access for the VFIO device on the host side, then the device will
>> be moved out of the low power state without the user's guest driver
>> involvement. Once the device access has been finished, then the device
>> will be moved again into low power state. With the low power
>> entry happened through VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP,
>> the device will not be moved back into the low power state and
>> a notification will be sent to the user by triggering wakeup eventfd.
>>
>> vfio_pci_core_pm_entry() will be called for both the variants of low
>> power feature entry so add an extra argument for wakeup eventfd context
>> and store locally in 'struct vfio_pci_core_device'.
>>
>> For the entry happened without wakeup eventfd, all the exit related
>> handling will be done by the LOW_POWER_EXIT device feature only.
>> When the LOW_POWER_EXIT will be called, then the vfio core layer
>> vfio_device_pm_runtime_get() will increment the usage count and will
>> resume the device. In the driver runtime_resume callback,
>> the 'pm_wake_eventfd_ctx' will be NULL so the vfio_pci_runtime_pm_exit()
>> will return early. Then vfio_pci_core_pm_exit() will again call
>> vfio_pci_runtime_pm_exit() and now the exit related handling will be done.
>>
>> For the entry happened with wakeup eventfd, in the driver resume
>> callback, eventfd will be triggered and all the exit related handling will
>> be done. When vfio_pci_runtime_pm_exit() will be called by
>> vfio_pci_core_pm_exit(), then it will return early. But if the user has
>> disabled the runtime PM on the host side, the device will never go
>> runtime suspended state and in this case, all the exit related handling
>> will be done during vfio_pci_core_pm_exit() only. Also, the eventfd will
>> not be triggered since the device power state has not been changed by the
>> host driver.
>>
>> For vfio_pci_core_disable() also, all the exit related handling
>> needs to be done if user has closed the device after putting into
>> low power. In this case eventfd will not be triggered since
>> the device close has been initiated by the user only.
>>
>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_core.c | 78 ++++++++++++++++++++++++++++++--
>>  include/linux/vfio_pci_core.h    |  1 +
>>  2 files changed, 74 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 726a6f282496..dbe942bcaa67 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -259,7 +259,8 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>>  	return ret;
>>  }
>>  
>> -static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev)
>> +static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
>> +				     struct eventfd_ctx *efdctx)
>>  {
>>  	/*
>>  	 * The vdev power related flags are protected with 'memory_lock'
>> @@ -272,6 +273,7 @@ static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev)
>>  	}
>>  
>>  	vdev->pm_runtime_engaged = true;
>> +	vdev->pm_wake_eventfd_ctx = efdctx;
>>  	pm_runtime_put_noidle(&vdev->pdev->dev);
>>  	up_write(&vdev->memory_lock);
>>  
>> @@ -295,21 +297,67 @@ static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
>>  	 * while returning from the ioctl and then the device can go into
>>  	 * runtime suspended state.
>>  	 */
>> -	return vfio_pci_runtime_pm_entry(vdev);
>> +	return vfio_pci_runtime_pm_entry(vdev, NULL);
>>  }
>>  
>> -static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
>> +static int
>> +vfio_pci_core_pm_entry_with_wakeup(struct vfio_device *device, u32 flags,
>> +				   void __user *arg, size_t argsz)
>> +{
>> +	struct vfio_pci_core_device *vdev =
>> +		container_of(device, struct vfio_pci_core_device, vdev);
>> +	struct vfio_device_low_power_entry_with_wakeup entry;
>> +	struct eventfd_ctx *efdctx;
>> +	int ret;
>> +
>> +	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
>> +				 sizeof(entry));
>> +	if (ret != 1)
>> +		return ret;
>> +
>> +	if (copy_from_user(&entry, arg, sizeof(entry)))
>> +		return -EFAULT;
>> +
>> +	if (entry.wakeup_eventfd < 0)
>> +		return -EINVAL;
>> +
>> +	efdctx = eventfd_ctx_fdget(entry.wakeup_eventfd);
>> +	if (IS_ERR(efdctx))
>> +		return PTR_ERR(efdctx);
>> +
>> +	ret = vfio_pci_runtime_pm_entry(vdev, efdctx);
>> +	if (ret)
>> +		eventfd_ctx_put(efdctx);
>> +
>> +	return ret;
>> +}
>> +
>> +static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev,
>> +				     bool resume_callback)
>>  {
>>  	/*
>>  	 * The vdev power related flags are protected with 'memory_lock'
>>  	 * semaphore.
>>  	 */
>>  	down_write(&vdev->memory_lock);
>> +	if (resume_callback && !vdev->pm_wake_eventfd_ctx) {
>> +		up_write(&vdev->memory_lock);
>> +		return;
>> +	}
>> +
>>  	if (vdev->pm_runtime_engaged) {
>>  		vdev->pm_runtime_engaged = false;
>>  		pm_runtime_get_noresume(&vdev->pdev->dev);
>>  	}
>>  
>> +	if (vdev->pm_wake_eventfd_ctx) {
>> +		if (resume_callback)
>> +			eventfd_signal(vdev->pm_wake_eventfd_ctx, 1);
>> +
>> +		eventfd_ctx_put(vdev->pm_wake_eventfd_ctx);
>> +		vdev->pm_wake_eventfd_ctx = NULL;
>> +	}
>> +
>>  	up_write(&vdev->memory_lock);
>>  }
>>  
> 
> I find the pm_exit handling here confusing.  We only have one caller
> that can signal the eventfd, so it seems cleaner to me to have that
> caller do the eventfd signal.  We can then remove the arg to pm_exit
> and pull the core of it out to a pre-locked function for that call
> path.  Sometime like below (applies on top of this patch).  Also moved
> the intx unmasking until after the eventfd signaling.  What do you
> think?  Thanks,
> 
> Alex
> 

 Thanks Alex. The updated code looks cleaner.
 I will make the above changes.

 Regards,
 Abhishek

> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index dbe942bcaa67..93169b7d6da2 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -332,32 +332,27 @@ vfio_pci_core_pm_entry_with_wakeup(struct vfio_device *device, u32 flags,
>  	return ret;
>  }
>  
> -static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev,
> -				     bool resume_callback)
> +static void __vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
>  {
> -	/*
> -	 * The vdev power related flags are protected with 'memory_lock'
> -	 * semaphore.
> -	 */
> -	down_write(&vdev->memory_lock);
> -	if (resume_callback && !vdev->pm_wake_eventfd_ctx) {
> -		up_write(&vdev->memory_lock);
> -		return;
> -	}
> -
>  	if (vdev->pm_runtime_engaged) {
>  		vdev->pm_runtime_engaged = false;
>  		pm_runtime_get_noresume(&vdev->pdev->dev);
> -	}
> -
> -	if (vdev->pm_wake_eventfd_ctx) {
> -		if (resume_callback)
> -			eventfd_signal(vdev->pm_wake_eventfd_ctx, 1);
>  
> -		eventfd_ctx_put(vdev->pm_wake_eventfd_ctx);
> -		vdev->pm_wake_eventfd_ctx = NULL;
> +		if (vdev->pm_wake_eventfd_ctx) {
> +			eventfd_ctx_put(vdev->pm_wake_eventfd_ctx);
> +			vdev->pm_wake_eventfd_ctx = NULL;
> +		}
>  	}
> +}
>  
> +static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
> +{
> +	/*
> +	 * The vdev power related flags are protected with 'memory_lock'
> +	 * semaphore.
> +	 */
> +	down_write(&vdev->memory_lock);
> +	__vfio_pci_runtime_pm_exit(vdev);
>  	up_write(&vdev->memory_lock);
>  }
>  
> @@ -373,22 +368,13 @@ static int vfio_pci_core_pm_exit(struct vfio_device *device, u32 flags,
>  		return ret;
>  
>  	/*
> -	 * The device should already be resumed by the vfio core layer.
> -	 * vfio_pci_runtime_pm_exit() will internally increment the usage
> -	 * count corresponding to pm_runtime_put() called during low power
> -	 * feature entry.
> -	 *
> -	 * For the low power entry happened with wakeup eventfd, there will
> -	 * be two cases:
> -	 *
> -	 * 1. The device has gone into runtime suspended state. In this case,
> -	 *    the runtime resume by the vfio core layer should already have
> -	 *    performed all exit related handling and the
> -	 *    vfio_pci_runtime_pm_exit() will return early.
> -	 * 2. The device was in runtime active state. In this case, the
> -	 *    vfio_pci_runtime_pm_exit() will do all the required handling.
> +	 * The device is always in the active state here due to pm wrappers
> +	 * around ioctls.  If the device had entered a low power state and
> +	 * pm_wake_eventfd_ctx is valid, vfio_pci_core_runtime_resume() has 
> +	 * already signaled the eventfd and exited low power mode itself.
> +	 * pm_runtime_engaged protects the redundant call here.
>  	 */
> -	vfio_pci_runtime_pm_exit(vdev, false);
> +	vfio_pci_runtime_pm_exit(vdev);
>  	return 0;
>  }
>  
> @@ -425,15 +411,19 @@ static int vfio_pci_core_runtime_resume(struct device *dev)
>  {
>  	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
>  
> -	if (vdev->pm_intx_masked)
> -		vfio_pci_intx_unmask(vdev);
> -
>  	/*
> -	 * Only for the low power entry happened with wakeup eventfd,
> -	 * the vfio_pci_runtime_pm_exit() will perform exit related handling
> -	 * and will trigger eventfd. For the other cases, it will return early.
> +	 * Resume with a pm_wake_eventfd_ctx signals the eventfd and exits
> +	 * low power mode.
>  	 */
> -	vfio_pci_runtime_pm_exit(vdev, true);
> +	down_write(&vdev->memory_lock);
> +	if (vdev->pm_wake_eventfd_ctx) {
> +		eventfd_signal(vdev->pm_wake_eventfd_ctx, 1);
> +		__vfio_pci_runtime_pm_exit(vdev);
> +	}
> +	up_write(&vdev->memory_lock);
> +
> +	if (vdev->pm_intx_masked)
> +		vfio_pci_intx_unmask(vdev);
>  
>  	return 0;
>  }
> @@ -553,7 +543,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  	 * the vfio_pci_set_power_state() will change the device power state
>  	 * to D0.
>  	 */
> -	vfio_pci_runtime_pm_exit(vdev, false);
> +	vfio_pci_runtime_pm_exit(vdev);
>  	pm_runtime_resume(&pdev->dev);
>  
>  	/*
> 

