Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9067AF3ED
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 21:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235693AbjIZTOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 15:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235679AbjIZTOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 15:14:05 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6512192
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 12:13:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgdDtMtBTmW4QtWerEkLKQ5pqbh+MMha1Jmwg8ZfT5MJ23OzsmOolvNcthu9yyaWXmIpRt00Fs4JK30Ev476781cz7rpb9hcdG2IwIatq2PoigkNzGzP7OIizfnvKDqqUad58ginBcU57J9WDIp25EIypOjj/qW7Dw+ybEh0TkQ+wwPB3HuHZWmx45sMaMOUKhi6Q6or8tYogFbzvdgSWGmfnOp2/GQesRExReq0qVHZrkUCogqSY0Lp11M6pLRQ1tuOxdkwHqxWqmwz2JRgrucwbMHTHqz0IqXeiJx1+AIF70hXsQy+wA2RX77FZ2TxgU482KseKisIygFR96MLiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i86vJL+7b6Qr75eatOXM2Y03pUQTJ2oWfuup34CaAbU=;
 b=kRA6auDSbHYPj5SzONxWcUxWAfaXAxoJQSj7296cZOWtLga4pSfzErnOnJwaCNGCSDwJX1gy9VIQ0AroIEGGtHwippAe+xMLWEfw2FrebSACiBJxObvTqz4nX8g7l4BehOiMI7LETHTwQfMWMqxLylmey+xic5UGnWjszmKCxH6v436ff5vpmdn4GVvjJuz9wQJQ1WbNujZZQJ/bH7ypIgNxbP2XovbpKHzBY4NxYe0zcetSfBCmcdZkpzBQDT1uNWsS9ZQx59f53EXNFeL/DiVYsBKDsPEiS3cFYx3Sn+KZ3MsIJuLP4FApdOI9FKbpJSrICtxD6S6b7KGrCYoiNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i86vJL+7b6Qr75eatOXM2Y03pUQTJ2oWfuup34CaAbU=;
 b=dy9BGE16vFJxYmCktwoBc5he6JP3nh3szkS0FIgFksL5yYT1MgxQhnBhKF3Y7Tg6+A0WddugUrJ04Yz62URJpv/6OA1EYsAJROFgvO+jcArLsLsmghXvrYmoyeWRcJEtW17R8XZ1c8LgEPRbmPnXdeKY016VZoWVmQfWXXhCtavv8/6+vCvFZleDRMamTfRUsTYJgRxcEHnAdNUOVYdk1+zyiCYGh+Phk+fMYnfrfCJUPNzPtfkVFbEXufhjaw7HrE7HyZ+t25cIun+VcrV0Vcnrq5ibeOB+vtdOX66yuweufb/uMDZUnno9j9LsIrY3QvOVYFEGpnCq0zDFCTFDKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6201.namprd12.prod.outlook.com (2603:10b6:930:26::16)
 by DM6PR12MB4121.namprd12.prod.outlook.com (2603:10b6:5:220::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Tue, 26 Sep
 2023 19:13:55 +0000
Received: from CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::8bbf:3b92:2607:4082]) by CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::8bbf:3b92:2607:4082%4]) with mapi id 15.20.6813.017; Tue, 26 Sep 2023
 19:13:55 +0000
Message-ID: <6eb92b47-cefe-8b00-d3d2-f15ce4aa9959@nvidia.com>
Date:   Tue, 26 Sep 2023 15:13:51 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH vfio 01/11] virtio-pci: Use virtio pci device layer vq
 info instead of generic one
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-2-yishaih@nvidia.com>
 <20230921093540-mutt-send-email-mst@kernel.org>
From:   Feng Liu <feliu@nvidia.com>
In-Reply-To: <20230921093540-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR18CA0014.namprd18.prod.outlook.com
 (2603:10b6:5:15b::27) To CY5PR12MB6201.namprd12.prod.outlook.com
 (2603:10b6:930:26::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6201:EE_|DM6PR12MB4121:EE_
X-MS-Office365-Filtering-Correlation-Id: f3dde423-0894-4a5a-8fab-08dbbec4ba8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yxIeq/uqvI2PXIuNTyNVcHgqi7nX2vb60qsEAvCMlkDxLlZPWvTZ/GT4nc/dWNyhMCYIL94sjrhU/4IdKGKkTaj/D74ljZmIz1vpToCDBSmJm7PP9ukNbCYPxwInvhTjuxzDRXfc9nclB4xGmRahiFiR8a4aoCbfKFowQet6zJnsy/2bFxLZFwv2k88CAnWlo9szuCCkTPsbW4AVn/bROS8LvLZHgHINtPp5fQrNkxq75RWugMJwC+AE6Fl6BMx8xsuUJHNLmzQuwHC9ax9LVaVedm5LmfOXq2zvSmW3Hd0S8SHQmqotPrnM8tQ3mvs03BEIjNMaXWDpreAl2LJZBeBUg+pTXS4yYOA7cVYifVY65M2xDYD2KSW7FTL5/iMqzUbVBpJQY8wdIg95wv/KtSiiyTnHc9rs2DAF8roerAtvd5Q4tBtC8/krm2OM5TYRiOQn6vmIjKosByD61Hjz7owplX2dxcq43GxgIOtGP289uXjQUQ8qo7sO/GDs2zjXwjsDP0r6CqwoBhN1NOvswYiUNi9BVZvdSjoDB5MPZSUR4FDFvsYF/J3fVfMdzuM0QARyccoA1UwgM3zR3qSuXgc6MyYwmFdGi7Ov7kkpf3G2J8WXYVM58QdNAeHwj8f520ZJjajtHg/lbmocbbH9wjKL0y1o9hNEyOfr1emTJdE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(346002)(136003)(376002)(230922051799003)(451199024)(1800799009)(186009)(6666004)(6486002)(6506007)(83380400001)(2906002)(478600001)(107886003)(8676002)(5660300002)(66556008)(66476007)(4326008)(8936002)(66946007)(26005)(110136005)(41300700001)(316002)(6636002)(2616005)(38100700002)(31686004)(6512007)(86362001)(31696002)(36756003)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0VVNlZzbDA0OHBZaFhYLzlvS2JYUmd5R0lRaTV6cUR6TW4zT295NzBtd1pH?=
 =?utf-8?B?UHZsdmdObm9nbFRFYUUrOVFWTno5enlaVkV6L1FqcjlldjdieC9qZk16bEZJ?=
 =?utf-8?B?ZVVvWmZqWklvOXMrTE5RdWFqcXhuSnU1NDBsbWdHenpNNWJpYXJrRmk5MUVu?=
 =?utf-8?B?TmZucWxvbStpdHoveVI5eVNuUElYaXZDR3NJTjVBS2xLODhvSmwrdzF0Rll3?=
 =?utf-8?B?Y2RPcW0zZ281VWZVeG05L3FpZTZkUHhxTnJBSjltVWJVUGFBOGJvcnpXc2xj?=
 =?utf-8?B?Z21DMUFSdDVLRllicXZUa01FQmkwU3ZrZERaUGJCeWdpU1hrWlkveVl5S21a?=
 =?utf-8?B?SzB1U0toQWtzTXVGT3lnZ0Qwd1YwQW56SmF1eXRoc0NEMHZaZVNkY1BBYWRX?=
 =?utf-8?B?SkJCeVNSR25oaWlmYWlHWDlYVGpERGQwQ0d0cXliaCtpU1JMVGloVjBsWWda?=
 =?utf-8?B?Rkxqbk02MGdMWFM0bGFHR0pnVythaGJpVERRT1Ewb000ZDFST1BXaERCaE9E?=
 =?utf-8?B?QXJiYVNEQVZEcVBaTkcrSXNiOU9RcEdFeU8zV2RCVHFWQWZxMG0xUnprNDAw?=
 =?utf-8?B?US85VzYrNW92a25IUUhHbGlDSVMvNERVOFRPOUp2bGJrSkt0NFpkT0JQVlls?=
 =?utf-8?B?UDVEOFpjOVV3ZXRSTmVjY3ovUzA3dVJqbStzWENObDNEempFNVp6aFdxNVZp?=
 =?utf-8?B?SWZnSWZkOUIxM1B2TmFQN0tiUnZUa1d5OW1YREc1VHNHVjNSaWlna2FMWnlq?=
 =?utf-8?B?RFkvNk85T3NlODNGclJEWnZ6VEhsU01FNkZYczFDMXdtUjZDcER4aUhXQjJ0?=
 =?utf-8?B?b3ZuTnZibU9HZW9sdUZwSmxTUG5pclNYNUZybjI0R1pWNEwrUXUvT1JDamVV?=
 =?utf-8?B?ZUFnc1h0c2cxRWNpdG1MYS80SnRrU2daVmFJNXBFMi9vcWIyRms1VlZlanRi?=
 =?utf-8?B?WmE3WWk3MjVoVmtDSVdRNDJtN0VuQ1hSTU9kMzRxS2FQYTBpaGlpUlQvZEMr?=
 =?utf-8?B?dC9SSTgwdk1tME8ycDhTcTcyMzVxakxlTGo0RUd6SXpaeGNzaE5pVkpOckdK?=
 =?utf-8?B?a2s3OHM3R2N4VWtpSnloYTYyS0ZYQUorTUZWc21jSEJUdS9GNjdMZ3c1c3V5?=
 =?utf-8?B?N0ZyVW9QcUVQT1VxMlNEczI0RW1zdnFneE02ZVgxcFBkQ0s3SzBicytaekRO?=
 =?utf-8?B?SWZ5WkJLbk1VZktVVTF6M1BaOUp6ZUE2NlNadjVFbjJEZVhtQkUwUkZEdzE3?=
 =?utf-8?B?L1MybWRMazB3ZVVLREx3Ryt1cy83cjhDbEVabmFXUTNXdFNiT245Q0JWS0Vv?=
 =?utf-8?B?Y1FjY0h6R1VoczBucjNXdlRmeXh2QUVEUGJpZTNkbXROaVlXbmVsMWV4Y2dD?=
 =?utf-8?B?aTBLT0s4ZkRVVnlCMG5oNkhuUEZ5Zm9mQi8vRHAwYkg4ME52cUkydFlwQ1lJ?=
 =?utf-8?B?enpZMUt3NDRKbXNzNlplcUh1a3NQQUFmOVRPTWZjeDhvMnpRMkFsckdEeHhy?=
 =?utf-8?B?RjRZd2R6b2E2bWM4RGQ5YVNpZHdHNENnbXFPTUxUb0VWVnJEYnIwRDdidFph?=
 =?utf-8?B?a1UwVkN3aHZYMDZvamY1ekhkb0RXS25WTTg3aFpUVmlEdUVDOFJFQkNOeC83?=
 =?utf-8?B?NzFSREJTWXA5Z3BQZXNVM3IramN1cG15Tlh2YkN5dkx5OFJEOG5VYlp3eHhl?=
 =?utf-8?B?NnFBMDNBNlVBeFN3cmI2dlFydVlXNGQwa004U0ZSdFlFbmlWSjZIZU1VZmhr?=
 =?utf-8?B?VjhzVXhOTW9XVVJaK0pHMHFGNHczTldhMkhFVlNKNno5SnlGYkU2SHl5Nmll?=
 =?utf-8?B?NUx4RU8vaWhNUFFOTmFtNFhRQnd2NHd6WWZ0NU5NZ2RHUjgyVUVmTW5ybGFy?=
 =?utf-8?B?dWdtWmdjNWVGS0R3QS9ZTGFpZ21RVFdMMGxmMkNQMDQ0Qnk4OTZRKzVPMzVH?=
 =?utf-8?B?QU5SN1Blb0YxTmF6R0ZnVGFLLzdsNHdHa2RDYyttRFczdjlUcUFwOHhYUm9x?=
 =?utf-8?B?NGNNWGxVVFFxRThKcmx3MWFSek9qZTBiVFY2bjUxaTdoME1uYnViQUN4azAy?=
 =?utf-8?B?eDF6Z2JWakhkU0VleHR2dmdQZXlHeE1sTWVPQU5WTlVac3VNVksxTDVKK3dj?=
 =?utf-8?Q?JoU9eF56HuwCjBjlsSd0HDVa1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3dde423-0894-4a5a-8fab-08dbbec4ba8a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 19:13:55.6849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UixJf2I9s5RBX4LU/Gae4eUfdj5vbBU96/9DuKgSntmAQHnIoHuRfdPVljGaAH1KHUBiM0uAp9i3GPzh/wx2Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4121
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023-09-21 a.m.9:46, Michael S. Tsirkin wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Thu, Sep 21, 2023 at 03:40:30PM +0300, Yishai Hadas wrote:
>> From: Feng Liu <feliu@nvidia.com>
>>
>> Currently VQ deletion callback vp_del_vqs() processes generic
>> virtio_device level VQ list instead of VQ information available at PCI
>> layer.
>>
>> To adhere to the layering, use the pci device level VQ information
>> stored in the virtqueues or vqs.
>>
>> This also prepares the code to handle PCI layer admin vq life cycle to
>> be managed within the pci layer and thereby avoid undesired deletion of
>> admin vq by upper layer drivers (net, console, vfio), in the del_vqs()
>> callback.
> 
>> Signed-off-by: Feng Liu <feliu@nvidia.com>
>> Reviewed-by: Parav Pandit <parav@nvidia.com>
>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/virtio/virtio_pci_common.c | 12 +++++++++---
>>   drivers/virtio/virtio_pci_common.h |  1 +
>>   2 files changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
>> index c2524a7207cf..7a3e6edc4dd6 100644
>> --- a/drivers/virtio/virtio_pci_common.c
>> +++ b/drivers/virtio/virtio_pci_common.c
>> @@ -232,12 +232,16 @@ static void vp_del_vq(struct virtqueue *vq)
>>   void vp_del_vqs(struct virtio_device *vdev)
>>   {
>>        struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>> -     struct virtqueue *vq, *n;
>> +     struct virtqueue *vq;
>>        int i;
>>
>> -     list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
>> +     for (i = 0; i < vp_dev->nvqs; i++) {
>> +             if (!vp_dev->vqs[i])
>> +                     continue;
>> +
>> +             vq = vp_dev->vqs[i]->vq;
>>                if (vp_dev->per_vq_vectors) {
>> -                     int v = vp_dev->vqs[vq->index]->msix_vector;
>> +                     int v = vp_dev->vqs[i]->msix_vector;
>>
>>                        if (v != VIRTIO_MSI_NO_VECTOR) {
>>                                int irq = pci_irq_vector(vp_dev->pci_dev, v);
>> @@ -294,6 +298,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
>>        vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
>>        if (!vp_dev->vqs)
>>                return -ENOMEM;
>> +     vp_dev->nvqs = nvqs;
>>
>>        if (per_vq_vectors) {
>>                /* Best option: one for change interrupt, one per vq. */
>> @@ -365,6 +370,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
>>        vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
>>        if (!vp_dev->vqs)
>>                return -ENOMEM;
>> +     vp_dev->nvqs = nvqs;
>>
>>        err = request_irq(vp_dev->pci_dev->irq, vp_interrupt, IRQF_SHARED,
>>                        dev_name(&vdev->dev), vp_dev);
>> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
>> index 4b773bd7c58c..602021967aaa 100644
>> --- a/drivers/virtio/virtio_pci_common.h
>> +++ b/drivers/virtio/virtio_pci_common.h
>> @@ -60,6 +60,7 @@ struct virtio_pci_device {
>>
>>        /* array of all queues for house-keeping */
>>        struct virtio_pci_vq_info **vqs;
>> +     u32 nvqs;
> 
> I don't much like it that we are adding more duplicated info here.
> In fact, we tried removing the vqs array in
> 5c34d002dcc7a6dd665a19d098b4f4cd5501ba1a - there was some bug in that
> patch and the author didn't have the time to debug
> so I reverted but I don't really think we need to add to that.
> 

Hi Michael

As explained in commit message, this patch is mainly to prepare for the 
subsequent admin vq patches.

The admin vq is also established using the common mechanism of vring, 
and is added to vdev->vqs in __vring_new_virtqueue(). So vdev->vqs 
contains all virtqueues, including rxq, txq, ctrlvq and admin vq.

admin vq should be managed by the virito_pci layer and should not be 
created or deleted by upper driver (net, blk);
When the upper driver was unloaded, it will call del_vqs() interface, 
which wll call vp_del_vqs(), and vp_del_vqs() should not delete the 
admin vq, but only delete the virtqueues created by the upper driver 
such as rxq, txq, and ctrlq.


vp_dev->vqs[] array only contains virtqueues created by upper driver 
such as rxq, txq, ctrlq. Traversing vp_dev->vqs array can only delete 
the upper virtqueues, without the admin vq. Use the vdev->vqs linked 
list cannot meet the needs.


Can such an explanation be explained clearly? Or do you have any other 
alternative methods?

>>
>>        /* MSI-X support */
>>        int msix_enabled;
>> --
>> 2.27.0
> 
