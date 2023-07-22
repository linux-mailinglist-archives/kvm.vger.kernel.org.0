Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BB375DA91
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 09:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjGVHKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jul 2023 03:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjGVHKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jul 2023 03:10:05 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAE1E44;
        Sat, 22 Jul 2023 00:10:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JB/LCbgN8rjfCVTJ+epUVOL7fJRCT/N0JmCSX+PYc4SqJWIhOyIRsCYX3mV2G7bw1iKCxsWS/cH+IyVF2mIuvfs6RXHDOFJAkdIFLbvLRmpDoOOgyz7XRoQj1Zvn4G669JAPdDj4Xq/LZd4kshkGGvV2hX9FmG24s9KTjGEYc2je0troZBnKLZcPkWozzZ7gmNjKzsJPhEWkJSYjoVFDs1GqDt2UDl0ov93QnJf2/7EyUmI/t4Wl7QTVbgq+iIGtdzTbrdhaKF5Y0FJ2WxqcUz2NsScCGjnKylwzxZ+smnei9iimovCGH0I3+n9oynwaqAVvCwPspLyDvo4mGx3XgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vp7SzpnvTw61ePdZp+GpQQEkoJAisl25W9Xc6mMtZvw=;
 b=X5lwSNJsVyYc2BaUMJ3Ysnx0Wl4DhIfAEV6JcFFBTpZ6N2n0THap4j+nDMmXohVaGRnPfjsFyfi1JKE39db8W0zyPrmeJ9250d5r6C4bQZaEvjJ57IAcpY6fiowDZBXup4f8DA3ALojgZrnaLpeHVhfUJyl/It00ZIUviGWCrzpZxGBzCjSGzJ4oAU3BMs+GJM3hDV3BVzEIo/1FGUd91f7gbcVcXNf8YPLgSnrR9yf8WYLGZ1c0hB24jJdMK1qzGxGnI4ElxqH9t+jn+s60a27WquxA0zcmFzH1/y2oe9vCeE0UGZtHJae/YAmUkISP+6xuLQkMjJvYZIh6T1bNPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vp7SzpnvTw61ePdZp+GpQQEkoJAisl25W9Xc6mMtZvw=;
 b=io97K9kscPrxvhfREc5XWLbQe1FLTLi7pSspmScOh2c7M4k/ZwbIqyoqElEOKbufwW91quY/yhuZzik1Dxe7pEDbFLr8BNSjywcfYlmBp5JS2AD8XnxBDscExTV6V+N/MTTGRibh0UTckS3L5s4cY4w8WcTmyUhQo+vQVYYx9ag=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DS0PR12MB8271.namprd12.prod.outlook.com (2603:10b6:8:fb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6609.28; Sat, 22 Jul 2023 07:10:01 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf%5]) with mapi id 15.20.6609.029; Sat, 22 Jul 2023
 07:10:01 +0000
Message-ID: <ea5cd85a-e29e-d178-5b17-1440be84f5fe@amd.com>
Date:   Sat, 22 Jul 2023 00:09:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v12 vfio 3/7] vfio/pds: register with the pds_core PF
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Cc:     "shannon.nelson@amd.com" <shannon.nelson@amd.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
 <20230719223527.12795-4-brett.creeley@amd.com>
 <BN9PR11MB527656A2E28090DDA4ED07728C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <BN9PR11MB527656A2E28090DDA4ED07728C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0311.namprd04.prod.outlook.com
 (2603:10b6:303:82::16) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DS0PR12MB8271:EE_
X-MS-Office365-Filtering-Correlation-Id: e54747aa-f953-4d28-66a2-08db8a82aaa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Fj8ZS/m0Fb/t0K7GQDtOKMaHJYZwDTlt4aMEie4d/XA9qV5QJIH0j95WJgRRp0xJVlKjzio+zuM45AJt9WhFPGt7CW4j3sfVSLGp2/iRbEvAB5N4aEgWqHfZOKMpu9NyflMYBm5XWJlrInaiNfFzGq+oVL8xaWU4QQQuLG34sEznt0Tm2GbYJjkg+C9x5XuWjtBOzuc7wCNih7DFlnkxVmEMJtwerO5Z+bzi5ectc9bMTY7K9lowQDDB0H4bSNJ3z14aSlOxrEfs4hjjseSMx8a1JQfBtn+lg8cO+cJy+Zt+q0eaMS2EcBRnaWNtYDuV5SJOSaLtNvYmP/3uqy5SN9awmhkjOZpDZwYXBurmYqw93kkG4i+5LP7XG1wnIWK10I48K6rPimkTeuvzJbg1o9BI4bVON7dJkIi76+mkVhsfwiVLaseQjoWQcOZ8Ox4aCQPdExU99P08D5n9i2eKTdTDEaFeTm+ZfTLFVQqphVpNg+DchAkcyhEQOXoFdju4YJibIGCcGE9VPPTrcZYqiL6y2Vp3M9B+CfAdJRStpZdTmHF2eScfddXg5cNTZqhVj8tytRtaEhjifGqBw8hSoBTkX3ZVL5ITbq1mLau4Wjbzxwla2U5saWCdM4FvUIN6WlW9yNRXFLKh4UXLdigtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199021)(53546011)(5660300002)(6506007)(8676002)(41300700001)(26005)(186003)(8936002)(31686004)(31696002)(38100700002)(110136005)(83380400001)(6666004)(6486002)(6512007)(66476007)(66556008)(66946007)(316002)(4326008)(2906002)(478600001)(36756003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2JQSUZHUFB0Sk9xSUhEWGtVVVJ5QVhoNEhndE1sN1hPR0dFRVZPVVI0dVRp?=
 =?utf-8?B?MFJTbGRLWVQyOW5xMlg1Y1R0Y1Z5eVhnV2JjTEx3bE5vQTYzNmE1TDQxYStR?=
 =?utf-8?B?RkIyZDE2T0JYZ1duYWFiOW5zTzU5TkFmd1o5SWcxdFlpZlN2ZFkzd2dYUUhw?=
 =?utf-8?B?bWlZVzlRbUNvbXJLVWlaQ0ZxWXhNV3FqMkVhbjdRbnB3ZjNhWWxpdHZ3VDZ0?=
 =?utf-8?B?Vlg3WE1YMWg4NEFlSkxXajdBaldOZVZGaS9hYldzSnlIUGZpVUVJb0dsTmVG?=
 =?utf-8?B?a1l2SEpDYm9VbmRtZnFYczJWN1RCbENMU3hFdzJ1VWZmTXZNb1Q1Zi9qajUv?=
 =?utf-8?B?TlZsbFN4bFkwTnhTazd6V1NqYmJockJOQTJvQnRWN0Y4Tm9tZXlETFlKbjF5?=
 =?utf-8?B?d2gzcGFJbkYrN3cyZzFzeTZOR09NNS84Z3hlY1NYSERqazlFcmhKKzhRN2pW?=
 =?utf-8?B?cEdEU3IweHJ3eXJ4R2g4bW51cWxUL2x4dW4yOXY2ZGFOczZrRjNCajlvelps?=
 =?utf-8?B?ZXhUaTI0NVVUQlB0c2hhREEzcnRLQ2o4alBiWEtDbjlxZ3lGSm84WUpZN280?=
 =?utf-8?B?VW02dnc5MlQ2MzZDR3ZOWXIrMTJWRWsvNkNmZWhoOExGRU1rSzlLN3RNN2Zq?=
 =?utf-8?B?dTVtMzh1b1NuWUdob3BFS0Rud0owNGM4Z25uMnBVTEVBOGpkQTRxQmFYbU83?=
 =?utf-8?B?cXp0YmJxazN2L2JRWW1mRnNxdklVU3NTVkZnWGIzT3JmY2NUWkxmZXhQdU54?=
 =?utf-8?B?dFI0bFNnM0NKM3A5MlFzdEVSa3piZUZaUzV6WFRBTUJzK2swMDFkdTBoMlR5?=
 =?utf-8?B?QUJmVDU3K2NkUHZrSU90cU5vUjd5RXZpS2Q4NlFWci9DTU52ZUVoSFllR2J2?=
 =?utf-8?B?anU4eHRZUCtNSFoyaFJOcmdtWXdnNzFaNFRTWThEUGd2N2M0MXFMa1F0T3BL?=
 =?utf-8?B?SzYvYkM5dVNEbjdrTTQwVHpPNVI4bGFTNVJnYmJPTTZBUWJPK0xNMTJUejBL?=
 =?utf-8?B?VDlWVzh5UFNuUTNlOUgrUTB1Ym8ySzF1RnpEVFZ6Z1RxcVI0bjNmS05YZytV?=
 =?utf-8?B?bXM2ZzBZZzkvU2xFWDVWbUN3STdCenRGUG1TRjgrSmN0ZWhEWDNEdnczbzVS?=
 =?utf-8?B?TEhtUktKQkJ2ZUdZM1VJcm1HY2ljV2FmcFBpSW0yM3pxb2NuUGxOTmI0VXpy?=
 =?utf-8?B?YytCL1ZHUkd4K0JUL09PZCtNTE5rVVBvNndhOHlHSURDQlhBZWU0VTM5N1RE?=
 =?utf-8?B?by93SWRpdnBjOU16M1I4NWlGbk1EMDU2RjhlejhBeXNZZnE1RENya1JoT2tI?=
 =?utf-8?B?TmlXM29ncTR1UFR2VWVoYVlERnVFcW94QS9KaUpOZndxd2J3eHVKakVjTVo1?=
 =?utf-8?B?NXJWVjFocitNYVdwVWdBbmlvekVzVHlhbTIxVDNreWRmeGZDVTJJMTJDVFhK?=
 =?utf-8?B?VzFMTXBSbGdYejVnejcxTlJmQ280Q0pMSXp1bDFweXRHSnNCM1I3MTdPME5L?=
 =?utf-8?B?RUdQUFVCNm0xVHpqV0FZRnNmWlI0YUZnVEMwTHZldlZIQkluUVhqMW9iTHRk?=
 =?utf-8?B?bmE5aEYyd0M1cnVEZUl1U3NvRWc0eDc1eW5jNzlWN0JlZFh6UVF4dm9oZWpO?=
 =?utf-8?B?R0FqSDlTemJ4eTRnNGw2NDRLbllMRFhLam5sNk5Td0lISnFkRW11c3RVNGlT?=
 =?utf-8?B?NkZKa0pibU5KWUMrWnBtbzBrVExiS1FPNTNaV0Z1bHVGeThlTDdEVFZScjZV?=
 =?utf-8?B?bS9UcHl6WXdqSUd2VWhsRVVJTzdFeEo0NStMd2tTOWltVGRKa3V2S0xFbWZ4?=
 =?utf-8?B?dzl5a0xDYzYwTXlaS1hMM2xYamwzaE9IZUl4RzU5OVRIK3lGaTNiNWo3TkNh?=
 =?utf-8?B?Yzg0MDlNR0ljQlcrNFZCYnRqazMwNXFjQlo1eUZrNm9ZemtMc0haVlBPZXBT?=
 =?utf-8?B?QU9xNWloZCtLTndwZmMzS0VHNEZEZFlrTHVaSCtNMW1pZ01kenZ2KzNCQXAz?=
 =?utf-8?B?NGx6NWNZdTVrN3k5dTQydDhUbVZ1RC9FZVlXaFlYeFhkaEtLSmZaUWtoempy?=
 =?utf-8?B?MzZubkxHdnU1VUQrbUdmT0Y3NTVONVJ4TEtNREVoLzZBTkhaUCtuNVJnb2lJ?=
 =?utf-8?Q?HsOT63CcsihJkkZ7V73dO2J8x?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e54747aa-f953-4d28-66a2-08db8a82aaa5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2023 07:10:01.7697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F+hgPM1HrxX57QCIjqw1JkHyU+2xs6IMe77WNXR9VH+puj16QW++kw7O67bWErOMY4zBM3byOjCIcjjMhoXMhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8271
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/2023 2:01 AM, Tian, Kevin wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> From: Brett Creeley <brett.creeley@amd.com>
>> Sent: Thursday, July 20, 2023 6:35 AM
>>
>> +void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
>> +     int err;
>> +
>> +     err = pds_client_unregister(pci_physfn(pdev), pds_vfio->client_id);
>> +     if (err)
>> +             dev_err(&pdev->dev, "unregister from DSC failed: %pe\n",
>> +                     ERR_PTR(err));
> 
> Why using ERR_PTR() here? it looks a common pattern used cross
> this series.

Yes, this is intentional. This is more readable than just printing out 
the error value.

> 
>> @@ -34,12 +34,13 @@ enum pds_core_vif_types {
>>
>>   #define PDS_DEV_TYPE_CORE_STR        "Core"
>>   #define PDS_DEV_TYPE_VDPA_STR        "vDPA"
>> -#define PDS_DEV_TYPE_VFIO_STR        "VFio"
>> +#define PDS_DEV_TYPE_VFIO_STR        "vfio"
>>   #define PDS_DEV_TYPE_ETH_STR "Eth"
>>   #define PDS_DEV_TYPE_RDMA_STR        "RDMA"
>>   #define PDS_DEV_TYPE_LM_STR  "LM"
>>
>>   #define PDS_VDPA_DEV_NAME     "."
>> PDS_DEV_TYPE_VDPA_STR
>> +#define PDS_LM_DEV_NAME              PDS_CORE_DRV_NAME "."
>> PDS_DEV_TYPE_LM_STR "." PDS_DEV_TYPE_VFIO_STR
>>
> 
> then should the name be changed to PDS_VFIO_LM_DEV_NAME?
> 
> Or is mentioning *LM* important? what would be the problem to just
> use "pds_core.vfio"?

LM is important for the device. I don't plan to change this.
