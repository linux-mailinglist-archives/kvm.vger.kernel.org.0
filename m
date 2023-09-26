Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894E87AF413
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 21:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbjIZTX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 15:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbjIZTXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 15:23:54 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FF511D
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 12:23:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aX7mmzol1BCoxkwg2X5jNZhziYh5zQIlrIx1yGg/JQVAAsw/sm/olEqPd+k4UH1L5qCt3uHOmm66MJOQj2Mcu8xLCceqJyQuqt4PNatx6bWMYcx+sl0g41ISCwYnOyWTinNPO5x5j0ZDMQuG8te5L5CDcsqDSSemEY3/7q7f26A/r/l5bK/jnPAlLxj5275cxRpwlKVa9jmLJR+5hIYhCa/hAAoUXWGTroiZOlfTt9jw///BnuZCVL+mjY5Kc4g4JY2CKYCA/0AP+gh/e4/f75CfL0oFJnqQzOGMKVKINpQPdMnyhpfjzHekDTS9NbRTPI1oHwgVTW1vEsMclh16RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X3f/g/KIEbKPBpisjBbhslH/jdaM1Yc55/8HxgUrX2M=;
 b=FNd37NMXvDFOXvy8feZQ+pjbwdKAy5mBmFyi/ndhuNFJcDunPjFXNd2zaC3YG31pVvMchZo1F32F4SXVmh6vPRP4RGwRZr5zvofknOtjuvqky6sJXWXqg1FjC9CBXImstuUb0egQrM+hn/3xW26i+IT3aQ0y0R+Ov1VJahfkTRWL0K4xLst7mqAfiMrEXjXAC0cGe7tVovAu0EgD15+n6eDWoiavxfnyLTlCpFhXmxR2OoNjVpzqZDdS0c+S46nyz9fnnogpDa+uk7eBBO6gxZQGczUJUHtuZMQJKQzfhgSGA7rAkGKT/Mace+gqX4xIgolpQiwrkSI5tMryBd/FoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3f/g/KIEbKPBpisjBbhslH/jdaM1Yc55/8HxgUrX2M=;
 b=NwhP9ix1Is1H8EDWrrfm+Mrlt/j6KY5YZkj74CTa7wsilehykg5nw3aV9B/Zi0irr6gvjfsoGtuqB+44FQMvDhQhwdoG9W8/y0xrmX9MdHmT3R5vw9V4iTHflYlsqw1rVrvBXrMB3744XymkrgYyN0V6vtvNC4nVAqqq+jAFgffGa41fmfOwWCHb/LrDKJiJdGxUI1p7tIJ+Eeas0KtykbT9AEWXvLgzWaar524TGtSFLCrnwNQOdL2Y20Y3fBfQM3LYTsjfCrWqG8oXTb6SW2XfNf7968dBq/G8VWmZz6qC3BlW11iTD/pbPSpls4eIkH6Z9jX5xwjLWRRiE+C0ug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6201.namprd12.prod.outlook.com (2603:10b6:930:26::16)
 by CY5PR12MB6348.namprd12.prod.outlook.com (2603:10b6:930:f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Tue, 26 Sep
 2023 19:23:43 +0000
Received: from CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::8bbf:3b92:2607:4082]) by CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::8bbf:3b92:2607:4082%4]) with mapi id 15.20.6813.017; Tue, 26 Sep 2023
 19:23:43 +0000
Message-ID: <62df07ea-ddb6-f4ee-f7c3-1400dbe3f0a9@nvidia.com>
Date:   Tue, 26 Sep 2023 15:23:39 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH vfio 03/11] virtio-pci: Introduce admin virtqueue
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-4-yishaih@nvidia.com>
 <20230921095216-mutt-send-email-mst@kernel.org>
From:   Feng Liu <feliu@nvidia.com>
In-Reply-To: <20230921095216-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:5:334::26) To CY5PR12MB6201.namprd12.prod.outlook.com
 (2603:10b6:930:26::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6201:EE_|CY5PR12MB6348:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f48cb16-f043-4b4f-5899-08dbbec618dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 11o1JZo5eKaKg8wB5nOHABmwDKf+LRmeyI3uZhmRIZcsFA08clTpcovBGAgh/KDHDpQZEGF0EXfxDM6vtx5pfNQYIlIEMKeNz24xRL2qSmogpeCiJ0XRvb93/M1nVyCcy0Jq3XkCSoi2QZZ/bZUlzij7W/3saMBrmAi9Tt2bb7pVaRYI2QBuWVpijxaOKGsKbWIYJVozU7gJQZ7yThfkMuaHkUdcp1nOmYnaMOkO4L+Iq2xQ/fbkXvgtTGV31FJev9M9tof4/+71uT+yqIik74SI3kL6oYkGBKE8NdS1zPCOUY+380uuUWubL69o+l1mKoxxfbIzv6F8M8C2HXdv7NJoBBN5kEES4FFfpSWfaJEggL7wcKKjP3ynOBjgn8EhGkqdzqmAyXWzvSovHFjvnSYTAttLgauMEeOUSJKDVhwbI+/WYmXZmNJdwdYKFBHi7PPGDHbt5e2DT6wDVIN9Xoh00CyXY8WdVe5CIi1AZ+uteti+NoEbIfVy9S6OHbGFW+IlLGak/NnLtCySL/FhnYOeh4HhM9IWInBmbe7SBhdBH/BEzVhCqpae1Zgacr35j1PK8Pl5gsirNOiRNdn8yME8kWXfGgNGcQtbkaRLglEyiiXOkVpM9AwX0zbTmtn6qoBpeibCWvl8AINVHYXLIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(396003)(366004)(39860400002)(376002)(230922051799003)(451199024)(186009)(1800799009)(38100700002)(86362001)(41300700001)(8936002)(478600001)(110136005)(4326008)(6636002)(316002)(31686004)(8676002)(2616005)(26005)(2906002)(107886003)(31696002)(30864003)(5660300002)(6666004)(83380400001)(6506007)(66946007)(6486002)(66476007)(66556008)(36756003)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODdQWUFiY0xXKy9VTVVmQjFBQUdmajRyRDcxZnZvemhudE9SN2pkVEQ1QWhZ?=
 =?utf-8?B?Wkk3MFpmZUMzSm9NRjNXMUs1RndVdTBTZVo4VnZjeENIdXZBOU41ajgvajU1?=
 =?utf-8?B?RTBIakVmRGZ0bUlCa2kweVJRc3hEVzZIaGZlajV3dTQyNURvbFN1SVFjb1h4?=
 =?utf-8?B?dWJFTVJQZU5qME9DWTB3NDNCQTlHUFgway9OOEFTMFRWeElGRUUzRlVPWFdZ?=
 =?utf-8?B?V2paWHlDZXhFTk9Oc2dlbUI4WWR3ZEl4dDlka2tSbzB0TVVFZHd4ellRaXRE?=
 =?utf-8?B?bng4Q1gwMU5wZ3FvVVZ5dmNZNi8weittdTJ2d3IyT05MNXJGb3RLTFl2Ykd4?=
 =?utf-8?B?cjZQOU9EV2p6ZkswVDhSQUxNcFVWQklnUUU0UkRpZUdRTjh2YllJbzRubkhj?=
 =?utf-8?B?bmZpZndWK2labCtIdHJQcmxmTWxwMG1XdlJocnViU09kZUFNZ1pLZDZINGpt?=
 =?utf-8?B?UFlwMFZlblRRQ3k1YklOd1VIbUEraWh0YmFuTnIzWm9ZVlo4aXRDeVlFWnJ2?=
 =?utf-8?B?N2JaWHZIZFVPaEx5K1lCRVl5NjhndVZEbEVCalFYWFkvQWdheGZWVk1LUW81?=
 =?utf-8?B?c0VDVFhYL0F0QzhNSUY0UlJBN3BwL1llMnNpdWZpQzduTnJ5eGJqNTViaVZE?=
 =?utf-8?B?VDdCSXVPZml0U3BSK2p4c1lVb0tpbVVRL215eFZoWDI2cjN6V1B5RVU5Vk92?=
 =?utf-8?B?S21jQk9EdWVsZE10MzFGbWhseGJ5ZGQxTjN5Z3dLTTBYOGJ6Nys5RlZYWGN4?=
 =?utf-8?B?WjlNVjRmbVIrZkxqOWN5K3h4OUM2SjZ6NG82YjZ0N01KU2Jxb1hmdjNQeUdr?=
 =?utf-8?B?ZndOUWpWVlNOMXArRzlBclA3eDZOVU42c0FkTkJVV2FHaVh1OXV6c2NyenR6?=
 =?utf-8?B?MU9GUFFzRmx4RlJUOVlEVkVWVHVHdU1uK013WXR5aXh6SmtTdzl6SVh5MDRk?=
 =?utf-8?B?SzJTakU3N3ZBazVscUoreDZIWTlCZ3MwQ0lxM1dDZHh2Lzc4cHI4Y0VGWXpn?=
 =?utf-8?B?OEdRSWFyZldkZ1VlVGVoVHFuUFhBU2xHaWwvb0VwZThja01DTDBxQ0pMZWd0?=
 =?utf-8?B?ZVZURFdVSXg2NU5vcXpzM0toUmo3VzlBRi9TVllQMGt3TzlCbFdOTHlPWTcy?=
 =?utf-8?B?ZndST1JOdUtJMy9wc1E2ZmJzTXNFaFBSTTdlMzgwYVFXWVlSaXdDQ0Zyb3Zn?=
 =?utf-8?B?UjhmdWVaVEViZUVrUnNDS0xzbGVxRXp2cnFIc1hvdEpWUTdzVk5Ucm1XS05u?=
 =?utf-8?B?QWs0VFVpNC9oZGhMK2hxeVVuazRjUWpUOFNhazBaUTV1L0pmajhOQ1pqTHkz?=
 =?utf-8?B?TjFGd1pMcWxNMnIxYnBjcWlBbUh4SWpncllaT0hYeC9iWERoVDZZaEFITHZv?=
 =?utf-8?B?TU9TdE03OVRSSkR6cHozRldsZTdCMHZHdEVJSXdvbnA4bFpYTUprWVZyTFpJ?=
 =?utf-8?B?T3ZzdlpNOTZWUGhRam5XTm9QTS9jQXNFOG1DRzdtWktQVmZrWHNDTkkxSkRD?=
 =?utf-8?B?VEFxTTVPOVFuOUJIOE1xbWg5T3RtdkdYK3JUNVU1QzY0TCtxa0RvMzk2UWVu?=
 =?utf-8?B?TFFjYjI1ZVR6QU5yMkptdlBudzlLdHQzc2YyZ3pyTGxYNG53WldrZXFqRkZ1?=
 =?utf-8?B?WElTUlVmUWtEbXpHalVMSXBMcVduMXhxbnBVREl3MXBwRDI2THcvOHBlb3dv?=
 =?utf-8?B?MHNXY2p1ajZhSmxyU2ZTMStyMWpLT1BWSXAvdlVKVzYrdUdTYm9PNjFTY3Bq?=
 =?utf-8?B?ZjZweTd4VTZ6czQwbWsvMUFiWC9mdFkzVWRmdThJcHFPa0EyYXo2c1RySFVx?=
 =?utf-8?B?aHhwY1BmandPdEhjTndkcUVsUm44M3Rkb1NOTUF1bFZOQk02UkNORUlNL2ZI?=
 =?utf-8?B?aWtlNUlqdmc2WHVoVXlpR2xrc1hjb3JodzgyYWZmSDhxemRocEN6Ri90VSsz?=
 =?utf-8?B?aUFOeHZuaFI3Vkp3L2Nad3RKd3FOcFRablp1akxTNngvNEFPdSswZFlqL0Zy?=
 =?utf-8?B?RXRIU2NaSG1jdUxsZEc1emVDRThHVVZneUgxaGlmd0dqVzlkY2t5RmpoTVpV?=
 =?utf-8?B?NEp6cUV3MWFVeko2TW1jc1BCNDZRSUhIU1p0Z012SDMzalZwSEtScngvbDFr?=
 =?utf-8?Q?JwlmIXkIND6ay3mGi77lD1Or+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f48cb16-f043-4b4f-5899-08dbbec618dc
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 19:23:43.4197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GAEbL+6PMi+X/7nWCGqfH1lsfZD4wP3lU9t65+W3FjQBl4MU9/hSsExpBTPjv/G6YFakParUlLCEuBGjC/dwSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6348
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023-09-21 a.m.9:57, Michael S. Tsirkin wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Thu, Sep 21, 2023 at 03:40:32PM +0300, Yishai Hadas wrote:
>> From: Feng Liu <feliu@nvidia.com>
>>
>> Introduce support for the admin virtqueue. By negotiating
>> VIRTIO_F_ADMIN_VQ feature, driver detects capability and creates one
>> administration virtqueue. Administration virtqueue implementation in
>> virtio pci generic layer, enables multiple types of upper layer
>> drivers such as vfio, net, blk to utilize it.
>>
>> Signed-off-by: Feng Liu <feliu@nvidia.com>
>> Reviewed-by: Parav Pandit <parav@nvidia.com>
>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/virtio/Makefile                |  2 +-
>>   drivers/virtio/virtio.c                | 37 +++++++++++++--
>>   drivers/virtio/virtio_pci_common.h     | 15 +++++-
>>   drivers/virtio/virtio_pci_modern.c     | 10 +++-
>>   drivers/virtio/virtio_pci_modern_avq.c | 65 ++++++++++++++++++++++++++
> 
> if you have a .c file without a .h file you know there's something
> fishy. Just add this inside drivers/virtio/virtio_pci_modern.c ?
> 
Will do.

>>   include/linux/virtio_config.h          |  4 ++
>>   include/linux/virtio_pci_modern.h      |  3 ++
>>   7 files changed, 129 insertions(+), 7 deletions(-)
>>   create mode 100644 drivers/virtio/virtio_pci_modern_avq.c
>>
>> diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
>> index 8e98d24917cc..dcc535b5b4d9 100644
>> --- a/drivers/virtio/Makefile
>> +++ b/drivers/virtio/Makefile
>> @@ -5,7 +5,7 @@ obj-$(CONFIG_VIRTIO_PCI_LIB) += virtio_pci_modern_dev.o
>>   obj-$(CONFIG_VIRTIO_PCI_LIB_LEGACY) += virtio_pci_legacy_dev.o
>>   obj-$(CONFIG_VIRTIO_MMIO) += virtio_mmio.o
>>   obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
>> -virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o
>> +virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o virtio_pci_modern_avq.o
>>   virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) += virtio_pci_legacy.o
>>   obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
>>   obj-$(CONFIG_VIRTIO_INPUT) += virtio_input.o
>> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
>> index 3893dc29eb26..f4080692b351 100644
>> --- a/drivers/virtio/virtio.c
>> +++ b/drivers/virtio/virtio.c
>> @@ -302,9 +302,15 @@ static int virtio_dev_probe(struct device *_d)
>>        if (err)
>>                goto err;
>>
>> +     if (dev->config->create_avq) {
>> +             err = dev->config->create_avq(dev);
>> +             if (err)
>> +                     goto err;
>> +     }
>> +
>>        err = drv->probe(dev);
>>        if (err)
>> -             goto err;
>> +             goto err_probe;
>>
>>        /* If probe didn't do it, mark device DRIVER_OK ourselves. */
>>        if (!(dev->config->get_status(dev) & VIRTIO_CONFIG_S_DRIVER_OK))
>> @@ -316,6 +322,10 @@ static int virtio_dev_probe(struct device *_d)
>>        virtio_config_enable(dev);
>>
>>        return 0;
>> +
>> +err_probe:
>> +     if (dev->config->destroy_avq)
>> +             dev->config->destroy_avq(dev);
>>   err:
>>        virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
>>        return err;
>> @@ -331,6 +341,9 @@ static void virtio_dev_remove(struct device *_d)
>>
>>        drv->remove(dev);
>>
>> +     if (dev->config->destroy_avq)
>> +             dev->config->destroy_avq(dev);
>> +
>>        /* Driver should have reset device. */
>>        WARN_ON_ONCE(dev->config->get_status(dev));
>>
>> @@ -489,13 +502,20 @@ EXPORT_SYMBOL_GPL(unregister_virtio_device);
>>   int virtio_device_freeze(struct virtio_device *dev)
>>   {
>>        struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
>> +     int ret;
>>
>>        virtio_config_disable(dev);
>>
>>        dev->failed = dev->config->get_status(dev) & VIRTIO_CONFIG_S_FAILED;
>>
>> -     if (drv && drv->freeze)
>> -             return drv->freeze(dev);
>> +     if (drv && drv->freeze) {
>> +             ret = drv->freeze(dev);
>> +             if (ret)
>> +                     return ret;
>> +     }
>> +
>> +     if (dev->config->destroy_avq)
>> +             dev->config->destroy_avq(dev);
>>
>>        return 0;
>>   }
>> @@ -532,10 +552,16 @@ int virtio_device_restore(struct virtio_device *dev)
>>        if (ret)
>>                goto err;
>>
>> +     if (dev->config->create_avq) {
>> +             ret = dev->config->create_avq(dev);
>> +             if (ret)
>> +                     goto err;
>> +     }
>> +
>>        if (drv->restore) {
>>                ret = drv->restore(dev);
>>                if (ret)
>> -                     goto err;
>> +                     goto err_restore;
>>        }
>>
>>        /* If restore didn't do it, mark device DRIVER_OK ourselves. */
>> @@ -546,6 +572,9 @@ int virtio_device_restore(struct virtio_device *dev)
>>
>>        return 0;
>>
>> +err_restore:
>> +     if (dev->config->destroy_avq)
>> +             dev->config->destroy_avq(dev);
>>   err:
>>        virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
>>        return ret;
>> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
>> index 602021967aaa..9bffa95274b6 100644
>> --- a/drivers/virtio/virtio_pci_common.h
>> +++ b/drivers/virtio/virtio_pci_common.h
>> @@ -41,6 +41,14 @@ struct virtio_pci_vq_info {
>>        unsigned int msix_vector;
>>   };
>>
>> +struct virtio_avq {
> 
> admin_vq would be better. and this is pci specific yes? so virtio_pci_
> 

Will do.

>> +     /* Virtqueue info associated with this admin queue. */
>> +     struct virtio_pci_vq_info info;
>> +     /* Name of the admin queue: avq.$index. */
>> +     char name[10];
>> +     u16 vq_index;
>> +};
>> +
>>   /* Our device structure */
>>   struct virtio_pci_device {
>>        struct virtio_device vdev;
>> @@ -58,10 +66,13 @@ struct virtio_pci_device {
>>        spinlock_t lock;
>>        struct list_head virtqueues;
>>
>> -     /* array of all queues for house-keeping */
>> +     /* Array of all virtqueues reported in the
>> +      * PCI common config num_queues field
>> +      */
>>        struct virtio_pci_vq_info **vqs;
>>        u32 nvqs;
>>
>> +     struct virtio_avq *admin;
> 
> and this could be thinkably admin_vq.
> 
Will do.

>>        /* MSI-X support */
>>        int msix_enabled;
>>        int intx_enabled;
>> @@ -115,6 +126,8 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>>                const char * const names[], const bool *ctx,
>>                struct irq_affinity *desc);
>>   const char *vp_bus_name(struct virtio_device *vdev);
>> +void vp_destroy_avq(struct virtio_device *vdev);
>> +int vp_create_avq(struct virtio_device *vdev);
>>
>>   /* Setup the affinity for a virtqueue:
>>    * - force the affinity for per vq vector
>> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
>> index d6bb68ba84e5..a72c87687196 100644
>> --- a/drivers/virtio/virtio_pci_modern.c
>> +++ b/drivers/virtio/virtio_pci_modern.c
>> @@ -37,6 +37,9 @@ static void vp_transport_features(struct virtio_device *vdev, u64 features)
>>
>>        if (features & BIT_ULL(VIRTIO_F_RING_RESET))
>>                __virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
>> +
>> +     if (features & BIT_ULL(VIRTIO_F_ADMIN_VQ))
>> +             __virtio_set_bit(vdev, VIRTIO_F_ADMIN_VQ);
>>   }
>>
>>   /* virtio config->finalize_features() implementation */
>> @@ -317,7 +320,8 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>>        else
>>                notify = vp_notify;
>>
>> -     if (index >= vp_modern_get_num_queues(mdev))
>> +     if (!((index < vp_modern_get_num_queues(mdev) ||
>> +           (vp_dev->admin && vp_dev->admin->vq_index == index))))
>>                return ERR_PTR(-EINVAL);
>>
>>        /* Check if queue is either not available or already active. */
>> @@ -509,6 +513,8 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
>>        .get_shm_region  = vp_get_shm_region,
>>        .disable_vq_and_reset = vp_modern_disable_vq_and_reset,
>>        .enable_vq_after_reset = vp_modern_enable_vq_after_reset,
>> +     .create_avq = vp_create_avq,
>> +     .destroy_avq = vp_destroy_avq,
>>   };
>>
>>   static const struct virtio_config_ops virtio_pci_config_ops = {
>> @@ -529,6 +535,8 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
>>        .get_shm_region  = vp_get_shm_region,
>>        .disable_vq_and_reset = vp_modern_disable_vq_and_reset,
>>        .enable_vq_after_reset = vp_modern_enable_vq_after_reset,
>> +     .create_avq = vp_create_avq,
>> +     .destroy_avq = vp_destroy_avq,
>>   };
>>
>>   /* the PCI probing function */
>> diff --git a/drivers/virtio/virtio_pci_modern_avq.c b/drivers/virtio/virtio_pci_modern_avq.c
>> new file mode 100644
>> index 000000000000..114579ad788f
>> --- /dev/null
>> +++ b/drivers/virtio/virtio_pci_modern_avq.c
>> @@ -0,0 +1,65 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +
>> +#include <linux/virtio.h>
>> +#include "virtio_pci_common.h"
>> +
>> +static u16 vp_modern_avq_num(struct virtio_pci_modern_device *mdev)
>> +{
>> +     struct virtio_pci_modern_common_cfg __iomem *cfg;
>> +
>> +     cfg = (struct virtio_pci_modern_common_cfg __iomem *)mdev->common;
>> +     return vp_ioread16(&cfg->admin_queue_num);
>> +}
>> +
>> +static u16 vp_modern_avq_index(struct virtio_pci_modern_device *mdev)
>> +{
>> +     struct virtio_pci_modern_common_cfg __iomem *cfg;
>> +
>> +     cfg = (struct virtio_pci_modern_common_cfg __iomem *)mdev->common;
>> +     return vp_ioread16(&cfg->admin_queue_index);
>> +}
>> +
>> +int vp_create_avq(struct virtio_device *vdev)
>> +{
>> +     struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>> +     struct virtio_avq *avq;
>> +     struct virtqueue *vq;
>> +     u16 admin_q_num;
>> +
>> +     if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
>> +             return 0;
>> +
>> +     admin_q_num = vp_modern_avq_num(&vp_dev->mdev);
>> +     if (!admin_q_num)
>> +             return -EINVAL;
>> +
>> +     vp_dev->admin = kzalloc(sizeof(*vp_dev->admin), GFP_KERNEL);
>> +     if (!vp_dev->admin)
>> +             return -ENOMEM;
>> +
>> +     avq = vp_dev->admin;
>> +     avq->vq_index = vp_modern_avq_index(&vp_dev->mdev);
>> +     sprintf(avq->name, "avq.%u", avq->vq_index);
>> +     vq = vp_dev->setup_vq(vp_dev, &vp_dev->admin->info, avq->vq_index, NULL,
>> +                           avq->name, NULL, VIRTIO_MSI_NO_VECTOR);
>> +     if (IS_ERR(vq)) {
>> +             dev_err(&vdev->dev, "failed to setup admin virtqueue");
>> +             kfree(vp_dev->admin);
>> +             return PTR_ERR(vq);
>> +     }
>> +
>> +     vp_dev->admin->info.vq = vq;
>> +     vp_modern_set_queue_enable(&vp_dev->mdev, avq->info.vq->index, true);
>> +     return 0;
>> +}
>> +
>> +void vp_destroy_avq(struct virtio_device *vdev)
>> +{
>> +     struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>> +
>> +     if (!vp_dev->admin)
>> +             return;
>> +
>> +     vp_dev->del_vq(&vp_dev->admin->info);
>> +     kfree(vp_dev->admin);
>> +}
>> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
>> index 2b3438de2c4d..028c51ea90ee 100644
>> --- a/include/linux/virtio_config.h
>> +++ b/include/linux/virtio_config.h
>> @@ -93,6 +93,8 @@ typedef void vq_callback_t(struct virtqueue *);
>>    *   Returns 0 on success or error status
>>    *   If disable_vq_and_reset is set, then enable_vq_after_reset must also be
>>    *   set.
>> + * @create_avq: initialize admin virtqueue resource.
>> + * @destroy_avq: destroy admin virtqueue resource.
>>    */
>>   struct virtio_config_ops {
>>        void (*get)(struct virtio_device *vdev, unsigned offset,
>> @@ -120,6 +122,8 @@ struct virtio_config_ops {
>>                               struct virtio_shm_region *region, u8 id);
>>        int (*disable_vq_and_reset)(struct virtqueue *vq);
>>        int (*enable_vq_after_reset)(struct virtqueue *vq);
>> +     int (*create_avq)(struct virtio_device *vdev);
>> +     void (*destroy_avq)(struct virtio_device *vdev);
>>   };
>>
>>   /* If driver didn't advertise the feature, it will never appear. */
>> diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
>> index 067ac1d789bc..f6cb13d858fd 100644
>> --- a/include/linux/virtio_pci_modern.h
>> +++ b/include/linux/virtio_pci_modern.h
>> @@ -10,6 +10,9 @@ struct virtio_pci_modern_common_cfg {
>>
>>        __le16 queue_notify_data;       /* read-write */
>>        __le16 queue_reset;             /* read-write */
>> +
>> +     __le16 admin_queue_index;       /* read-only */
>> +     __le16 admin_queue_num;         /* read-only */
>>   };
> 
> 
> ouch.
> actually there's a problem
> 
>          mdev->common = vp_modern_map_capability(mdev, common,
>                                        sizeof(struct virtio_pci_common_cfg), 4,
>                                        0, sizeof(struct virtio_pci_common_cfg),
>                                        NULL, NULL);
> 
> extending this structure means some calls will start failing on
> existing devices.
> 
> even more of an ouch, when we added queue_notify_data and queue_reset we
> also possibly broke some devices. well hopefully not since no one
> reported failures but we really need to fix that.
> 
> 
Hi Michael

I didn’t see the fail in vp_modern_map_capability(), and 
vp_modern_map_capability() only read and map pci memory. The length of 
the memory mapping will increase as the struct virtio_pci_common_cfg 
increases. No errors are seen.

And according to the existing code, new pci configuration space members 
can only be added in struct virtio_pci_modern_common_cfg.

Every single entry added here is protected by feature bit, there is no 
bug AFAIK.

Could you help to explain it more detail?  Where and why it will fall if 
we add new member in struct virtio_pci_modern_common_cfg.


>>
>>   struct virtio_pci_modern_device {
>> --
>> 2.27.0
> 
