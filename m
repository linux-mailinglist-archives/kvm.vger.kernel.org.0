Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBA352B727
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 12:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbiERKHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 06:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234941AbiERKHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 06:07:15 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2044.outbound.protection.outlook.com [40.107.101.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399A714CDCF;
        Wed, 18 May 2022 03:07:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1I5P3wQTVk5zbKWMj2HxGzUNERNymjwxc1fgETZn3XogpXWmfgQm97hh4Ffss5T10+YNpZxn6SfpF+FsejPgEOLGRGQkLU6QPycp5BC8SwVESZP6MEiNJgl030W6mXPVsIjJ0cJ4ewDLcoHSV5AnGy3JhrCVWMShu5OyCVQ8sca3hni+9Juz3LjAVcbMpSimJzIxkO7hihGBKxBo9J5IQLUPuHyKfUK20lacUY8QeyFopepX5ufd510q+yFIkGobVxc0S26Je1OejpGEZI8ksB/LbwTUzdvsn/dpYPUb43weOKpbwm/QNnV2wvsiAHxed8C37gOLMgxcvT9/5NVfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fFHeKE/4/kP/ojVtLSDw8A2ssA3IvS2csM8Ney8cbeY=;
 b=dd9iDFr3W3jxqADo8oAsHB29Ko7DW2XUWFvmqOqzxoROjgSgsCaChpZLPmgUqr71tZvjDvpNngM4icAfRnPBxatRE8WAGHKgSclLlflAuxjP/2L+X6XS3BRlIFFQXSBasppiDis4XbKDrcmwWHpHnTWKmd0afdYLCvSHFJx5RmXdo7z8Kpsis7RzOsrjGJF1MwKfHKpvNp8nM7I6DiXFsU1tPvJJyTthshHBS0WhRfH4L4ugxyWn3AXzXJpad9jCw1gS2JJEK1gcIV6czR2dlL2wKdSHWJAZsM+YWe19gmbP1uO8lNK7276av0oDFEwyXtNzT6L3cyPc00EHODl2Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fFHeKE/4/kP/ojVtLSDw8A2ssA3IvS2csM8Ney8cbeY=;
 b=OAwMsxmHYT39MLh0myEJXu+1d425wUvUWshrj/UKdvh9eI43JCTevLpLv8SM3YqND/nPD0up59T0Gr1UtgCbrpWu1S/j/U71LUw7eLB/u3tzmnxUz4q6VztK8rgrMGYwszZ3NqcAukz2KcoUXHSADyBd8GcO5PX+bD7vSteteGX9t9jhwzCoBDD9+rfU0b9UIAEzDj14gssTS3Q+cRGr9YptGHIX4KJGhHyGS/GVIDbDnuqXY3EWqSeNIRXH+tt341Q2m3q5CqtV3bD5vC9PEIqXh03eQquKf7kUDhT0r3k0ALB0YMPNxYA5YxR3Kh/Jn6r5k8n6EruAcy+3dtNy9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by MN2PR12MB3296.namprd12.prod.outlook.com (2603:10b6:208:aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 10:07:12 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d%6]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 10:07:12 +0000
Message-ID: <ed5773f8-7194-4d2d-b5b2-7546c2f1b2bd@nvidia.com>
Date:   Wed, 18 May 2022 15:36:59 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v4 4/4] vfio/pci: Move the unused device into low power
 state with runtime PM
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
References: <20220517100219.15146-1-abhsahu@nvidia.com>
 <20220517100219.15146-5-abhsahu@nvidia.com>
 <20220517140259.1021cf85.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220517140259.1021cf85.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0098.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:af::8) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bd1ecc0-ef9b-4522-afee-08da38b62d28
X-MS-TrafficTypeDiagnostic: MN2PR12MB3296:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3296B5D160FFDE2252558CBCCCD19@MN2PR12MB3296.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5X3s86J5aKuYlo8fUkgpyckb43c/ihM4hk1p7/DoabVD9i0XPExwN67mXuR9xiFuwYaJeimSM8IRUSk1CTpLQLLnvuaDg/UNdHK8IZoiuCNnEORTPFwOn3Bt4je05SO7aMFx90l3ky9vS98Rn0oLxmCax60qttMXrQe0j8B31XfHdC+Rsp+uPuWLtESxmt8rAywIawVjRv13VQdhBoSeQ3kAWMWviSH02RknJAMo8Lp6dZyTStfmmA2aa1929KbrZHh6Wci+pQv1N0nnpADTQn453gwCU4ndnytwhuLnKQY8CMW6dHeU4EhoM5gVIJ/cUpk5C+3EAS2FIQELfdktE1DAmR0t5iKEBKZ+dCk7XcE1wMDBIoYErjgiD0eNjdBIQ8XAL5cZN4pzoJ8yCgpbKBVX0w61tdjte71WsqGgl8BRghtE/9Pwge1DRkaBu7rW1lNoU81OY8jroDGFLnUgsqDrwQdAjm6+pjsU8fmknD3Kmh6iNbvkn2kL9sLW8ZuTUosfmn7ravXscMHBjUALZy7+qlxkZPsNH9CNigALYy2nRqkMuqXfUUuLlsfnNOiRf/ot0B0NeHYATxtN09tBZRhxxgu8lK2Htc9bQWdWIzdNJP8iX35idd6t/unWw6rDWbAeQnVZDUd1qKUwJdSlaumChyCwy1Z2o0Lbg+BVIAJ5TkVfbxMbk8+go+qYDT4wwtFCcIYbSVFlxF1BA7SpiSlpx/0JX8gwXs+v6dITD7SfdODyr0QXnVx2/mSkIQur
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6666004)(2906002)(186003)(55236004)(26005)(6512007)(53546011)(2616005)(6506007)(8936002)(316002)(31686004)(6916009)(54906003)(31696002)(36756003)(66556008)(4326008)(66946007)(8676002)(86362001)(66476007)(7416002)(5660300002)(508600001)(38100700002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDZ0VURCeWFFcEt2WGxrU2FTdUd6T2htOHVmWnZHZ1QxSHNMYzNqSFZnWk9z?=
 =?utf-8?B?Zm4wWmNCY2EyK1Nzbk04WnczVHc2eWRlaEcwOTEwTTE5WlB1ekNiY2tTQnpI?=
 =?utf-8?B?UWYvdG40V3FaNFdPUm41d1hMZ00xZ2lIT1A4SmpwRWplUW1ialRYRjQ5NHlo?=
 =?utf-8?B?Y1ZhbFpSZEtpdDZCSWZYOVJBcjIxQmVRcVRjWDlYMzZocVpuK0dWcVVJTXg0?=
 =?utf-8?B?ei94aXA1M0FSZk1OMzVNVVlmZHlNbDE1VDRvODZtMkJaTGxBa0EzdU8wSDhy?=
 =?utf-8?B?MVRCVDg2ZlRjcU1BNFg4bmtTTjlGOS9mOG52NGtUQkpYRGZReUpIVFhwV1NN?=
 =?utf-8?B?aUV4WlV0b2NXL2hZVVBxTlpxaklzOTEwQVM1dkYzTXE1YmQ4cit0YkRaVmNF?=
 =?utf-8?B?ODhyUmJYNGlZYmNIK3pyV253eVRGT3d6bTVIVmRTb0Z4NVdrVndLZHc4Vkx4?=
 =?utf-8?B?YlFnZkpsL2ZVdnR2SW40Vk5KTFJNTXc5NkdGK0dzOTJsMzhWckpSZ1g1cEVh?=
 =?utf-8?B?ZmdsakNTb3FGTE9lejNoVlI5dk5HUmFVZWFXdld6bDJ4UkFSZWFKckVkQVQ1?=
 =?utf-8?B?bjRCeS9TUVlCbUV2TWtaMFY1R21CcjRhcnRVRmhXU2xiTEVnbFN5bFduS2Vh?=
 =?utf-8?B?dzd2bEl6R014WFlRK3pZZ01NWnVYRDVXeXVnY2oyS3FVRC9tOWZlUEdVYXZx?=
 =?utf-8?B?ZGw0dnIxc2lBQzF0anZzZjRYQ0RBSXdMblhnUmhTTjRuSWdlVUtIRllTdThy?=
 =?utf-8?B?MTlmQXZLMjFxN05aeTcwS1ZlMVVUdG5Da21VTjg4WjF3RFo3MlRYNU85RGh1?=
 =?utf-8?B?dWJlOUdER3NJc3F4ZmxDNGtnQUdsdmpGOEoyTkMzNFRUYktPZlNkWmgyMDl5?=
 =?utf-8?B?MXZXUC9FUjNvQm5SY1ZCR0tqWlVNVS9hVnpLU2hFQ0o0KzMrclkrL1VkNERF?=
 =?utf-8?B?QUlqSjRoVUpUWXpQYkJnZVl2a2lCUG5PcTRGUitlek1vcDl4bllWeFBKOEY1?=
 =?utf-8?B?Umx4SklFUkFJNllLRGJhMjE0VFhwVDAyeWZUcWdKT2FJd1lDbXZwamFqV0hO?=
 =?utf-8?B?cEIzVzk5ZCttYnZET2hPMVd6V1NsdTJrOE4vaDBDcVo3MysxbmJiNVJyVHpk?=
 =?utf-8?B?WFhmbVI3a3hEa2VQTVd2YlVublJpQ3R6UTd0S21GZGE1VVR5ZUlUTloxdTNE?=
 =?utf-8?B?MHF3WFltZXh0SkdwcDVQaVdYbjc3V1V2Wlg4WWVibnNXRGVDWFI0NUhlTGVl?=
 =?utf-8?B?TDB4ZVZuVXRUUGxsRVB0ZSt5K3ZNUzJYdkRYb3dWZjJRYlk0ZlUwaUIzR2R3?=
 =?utf-8?B?MGFKVjZYK2R2WW10VE9waDl3UFVXNzVicXVOSUZZcGh6M0NnUnREaTYrUVUz?=
 =?utf-8?B?bmNiUS9qbGtmeDdUWWU5TUFOcnB0S0QyWnpDSW44THJoeEpjMitPTlIxTC9V?=
 =?utf-8?B?dWxFZzR0bk1OVCs0YzVTeGI4djRKU0xBNjROcG9DcXMzc28vc3ZlWHJGblg0?=
 =?utf-8?B?c3dpckhUNTAwaXJ3RGpMSGhmcUlvVVJ3UnVRRDBsMEx4RVViZUd4VjdoanFN?=
 =?utf-8?B?eEc5SUZhaE41M0RnS2prNzBWeWVjUVNxTnJGLzVhNFZ4cW5yTXZqMFRmdXFM?=
 =?utf-8?B?eW8vd1ZnYzVtQTVVS3RjNFpld1ZBSWNqcXNZWEFLWlhVRzdaQmpkazhSQ0lJ?=
 =?utf-8?B?NXBBaVM0SS9SalpRZUl4V2VLdVA0YUszTnNOZHhBSnMzRFgwbHJ1UDFZWjhx?=
 =?utf-8?B?d3B3aHlPT2pVN1h3K0J3cXFOUjZ6cmw4TnZrb3JJOFBxcmFmOEcyYXNKMmUy?=
 =?utf-8?B?U2U1b0R1M293QW1QTmpDMHNKaUhsWXUzMHRlWXpIV3llZHQ1RkVsTnY5aDdF?=
 =?utf-8?B?YVREcWdrVjNFVlhycnFBUnRoU2JnY1pUVkJKK3cyZDZoNkFvbS9xQUkrV1dC?=
 =?utf-8?B?eU93S1JIQlRrRFlYSXZTSi9iSUxpYW1YVXBBaHpRS3lhSHhlZW1mTHlMbDRk?=
 =?utf-8?B?MGpXYS92QXoxRXo1OFpNd0JyK2hQOHAxcDdqOVIrUlVuTU94L3ZGTGliREFw?=
 =?utf-8?B?dDd6RFNsdjYwcXYxZm8ybEtFSmptOUdMek9ETTFkYlB4NVZoay9kMkExSVNE?=
 =?utf-8?B?dzZHc2dra1dHZ3p2Q1RuMlQvb1hoVmVSOEovUW9LSGd1MnVGVlVqZTFSWU9x?=
 =?utf-8?B?M0gvam55dk0wdjdtcDc1MExmSXJRekE5V3dKWlI0d2V4TFNlZXJwOVVZZVBR?=
 =?utf-8?B?MHBVbmJ1NE1haHVybVl5MjJ0RFY3WTY4K1p1dlR3YkJZSWFzYW9CVTVtU0tQ?=
 =?utf-8?B?RXZsalpPby85cWFoOHlGSm5wOStvTHpLVExpNGZlQkRIZnRKa2krZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bd1ecc0-ef9b-4522-afee-08da38b62d28
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 10:07:12.2952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +p2dU0qnjnA4tzaep6Hu1ylPFgCfopGCK4/qckhbPBD1UvgK/aeLFHixhPOkdWCO5yiJTUVN+n2DkuqthUm3Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3296
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/18/2022 1:32 AM, Alex Williamson wrote:
> On Tue, 17 May 2022 15:32:19 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 4fe9a4efc751..5ea1b3099036 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -156,7 +156,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
>>  }
>>  
>>  struct vfio_pci_group_info;
>> -static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
>> +static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
>>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>  				      struct vfio_pci_group_info *groups);
>>  
>> @@ -275,6 +275,19 @@ void vfio_pci_lock_and_set_power_state(struct vfio_pci_core_device *vdev,
>>  	up_write(&vdev->memory_lock);
>>  }
>>  
>> +#ifdef CONFIG_PM
> 
> Neither of the CONFIG_PM checks added are actually needed afaict, both
> struct dev_pm_ops and the pm pointer on struct device_driver are defined
> regardless.  Thanks,
> 
> Alex
> 

 Yes. These are not needed for build.
 I will remove these explicit CONFIG_PM checks.

 Regards,
 Abhishek
