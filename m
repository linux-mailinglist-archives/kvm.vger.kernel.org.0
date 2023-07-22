Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C8975DA8E
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 09:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjGVHGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jul 2023 03:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjGVHGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jul 2023 03:06:48 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAB13ABD;
        Sat, 22 Jul 2023 00:06:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTmT84gAsm2J92Ts/Ex4BDoidNKmxiwIzhyxzCyUm5el/2jweN3KFHe29vjwioY8SXPaUyCY65XWTB4ND6th0gQXCguOArnDtWo6URqKuVEtwNCYbWsjJTJGK/UNadiPtaZxETtMW8MFyhBXKb2O5BndfZS8XKv0AO+0NvXX6cehPmXzuuYpcDcT9ieu6oCOvQ56sdL+d+2m8BcwBpBWuXc2xpdKsIcerQ0Q1XydAr0ZHpzPJwWmR9UO0ulZ1D+5Ldz/M2aCtuZmmvq+aCnhNVStwJeQp47mw6Z/NQZU6odx3MxuPNfbEZBFYLyhTLpVaKK/h7ocJRkVlHCKFc6FLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61uhZ43PLyftsVt7IxWvqhVJZK6DsdPpf6ybXZJy2qA=;
 b=VtkyWem7csqMwgcwyIF+3EiuMB2AypCCiV61BRTBkykIieBZAPtNS0rlclq5309d10kvb61kQu0MrpyeyEINPhwXFP3ursXWKIRnjjm2BXe3MZvNMH5K75CN9b0ljIk6K9QFOFUgC3ln/FHb7MoLG6EMhwrFD2g+Wm2cItojBYKska7QiQK8sR/QQ6WGUKXxhY9J6+aGt7oP1KG8wQXaqGlVw5LoTscfN1j/+1yAyS0TFQrw7vWk9TIRoFo5NwBUDVQPdFe4cM3mTiUq9l3+pQuhQEQc038H1qzGYLWnUFcaWBvRHPvrpNjDId/HJii4JMk2cUmRIH/vHtEJYQCV5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61uhZ43PLyftsVt7IxWvqhVJZK6DsdPpf6ybXZJy2qA=;
 b=ulcGdS04enrt4g4XAlvzhvUh6FgrwxW0U7xAch6qUPfht8GRAo9NYPe5IBZoZdkjZlS7ZDSVNlL0wES0Ei845JiG9JVjkBP0OYOSCmTPHpJzyNWMx+N6E2cnbB6LbTtfEl9jlxCSFksVbqnrb52DE/cFar3oMMh9NMicrwvnOkE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DS0PR12MB8271.namprd12.prod.outlook.com (2603:10b6:8:fb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6609.28; Sat, 22 Jul 2023 07:06:42 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf%5]) with mapi id 15.20.6609.029; Sat, 22 Jul 2023
 07:06:42 +0000
Message-ID: <cd7d9c67-5589-8ce5-838d-cbf8dd5ef7c1@amd.com>
Date:   Sat, 22 Jul 2023 00:06:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v12 vfio 2/7] vfio/pds: Initial support for pds VFIO
 driver
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
 <20230719223527.12795-3-brett.creeley@amd.com>
 <BN9PR11MB52766A79CD8EDC013AE33B5A8C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <BN9PR11MB52766A79CD8EDC013AE33B5A8C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0001.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::6) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DS0PR12MB8271:EE_
X-MS-Office365-Filtering-Correlation-Id: dbdf8ed0-d26d-4411-3cec-08db8a8233a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9SV4j7BKHZt3d++g3Y4Jd8GFMMio4xFA7qKcdav7erYsqnrcTBE+VXm77EWTo6IiGU6E9q61sQaGJvplp95IdzkeIbfAMI23PLSWtbgxREA3BxtUUYbfmkIokMplKWkFPgZsUwDR7zuJSzWSjQ/yD1vnFrg0B8UV5mrkKE0SUWwSog4AJuxvVemvEOAajcXkiLvSloPn22kECWnfW65dI9uDZoWCK3zR8Hr5rpz63qjFp6NmhkhyF83esdLUc2KgHNZQjaT2wp0YC1IJnkYIchvxrvNkQHpc+7a98iYsbtRDgAlDOHoy+244NJFaFgKsFSt4DyQsFFd0nvTJXfE/E8ZV++HqzCyhPsVzqC+Y2NtJBjajqMrjIYdC104YQVLKkUVZa+J0wFg+lZKf7eM5AFKvn7VAj81KwzV+TH4QDFrAUvUgzQ6GNdLrlM6RPcpbL4IanTXk+rTcFKD1V/lqjLqUT5VjcCYF5lPo4xti8S0tO0ZFypkjUbIOY3wrOU/Wtti1W5deM+bOJN+QArj2CUz5S1EHTxQiCl8oqmmqc+Myq6d+gp1lwGwggmi10FteWyBzPIIKZ4KXhHBnHSa4EzIQVQPk9oqHHvOj+2e80afv9q3Cp2M8PGb2tQE9HgnuEL8e7wjFAdw2fBAvvAyOkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199021)(53546011)(5660300002)(6506007)(8676002)(41300700001)(26005)(186003)(8936002)(31686004)(31696002)(38100700002)(110136005)(83380400001)(6666004)(6486002)(6512007)(66476007)(66556008)(66946007)(316002)(4326008)(2906002)(478600001)(36756003)(4744005)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1p3Q3BSRGpxdDI4aEE4QUFRcENHMTlnaFdEM0Y4c3ViQnE4OURjMjlTZ0pl?=
 =?utf-8?B?ekd5cmFObWZNZ1pEL2dJbjdGM0ZyMjljblFWdGViZFprZzZ6RzR5UGVENExQ?=
 =?utf-8?B?ZDZXSUs4V3Y2SkNncndEOVUraEVKVTJUMG9ueDY0MW01bW5Zek1NTjhzSUtE?=
 =?utf-8?B?SkRrQVBnd29nSTJnS1orUXhuVmZQNXJndThMNmU2SXdPeHF1dkRqS3lGUlZ5?=
 =?utf-8?B?RHdQekhUQndCMnErTVltenFOTldlYWVvWWN0VlFKMVFZMnZTaW1NaXVSVENV?=
 =?utf-8?B?TEZvemQvc3lleUdNS0gwKzdsMWtNSGtFR3VPaVd0RE9uOWNwWmpMMW5KdFVp?=
 =?utf-8?B?WEo3TTZlYldHdWZzemdZUTgxdGdlWG45N01BVm1QM3RjRUxyRUxTU0hDTVhR?=
 =?utf-8?B?eFg3NVVieEhuZFgzaHhWaW5UTU1mcXlPRHAyWDQxcDNpbElGZk5OVzlmYlVV?=
 =?utf-8?B?dEc5NFBqZFF3VmxYS3RRMWhRb0RONjFvYWhYV3FzR0FaeUhXcGs4THhkT1lt?=
 =?utf-8?B?MlZhaVFtTklob1NjMzVrUzRGWGZxRHFlb3R0blh2QTc5dUh0V0lnS0hPTnBM?=
 =?utf-8?B?VEdTdnhVQjlHUnpRTTROcWdsNE1xVmlkVUNxcWNpSWxTbTFrVGlBTkVTSTZX?=
 =?utf-8?B?TUdHOFNCTk9CVDJFYllEZENhNUhjYkQxTlRSSThOYW12NzBtV2p6cUdTd215?=
 =?utf-8?B?QjdBT0xTVCt2VWxzTitTZXg0bzRVOFBTbk93MDJsaWZ5YmFJejhmN0xXZm95?=
 =?utf-8?B?R2FHUnpLUFBkbGF1U25hNEE4aGdjTVE3SVZ0dHNRd2RzMXpUZ0IrZU4wNVBh?=
 =?utf-8?B?S0I2eWt1dEJrdzVKdGs0T0xsLzZlRnlRU2JvVmJDQ3dNRll3NXd5UFREMzNl?=
 =?utf-8?B?SWYxNzlOSHpLYmY4WmZMRjhBMGFML2t2ZHNkWXA5YXFLa2NKdjhGdDhoV1Vw?=
 =?utf-8?B?M1ZPZzVsa1lETnNWZ2NUeVl6TUdkQi9aTC9SK2FnTW15aEM1MVo3eFIzd2NG?=
 =?utf-8?B?SGtjeGpnMVhhcVRFclhrcklNNWNqa0hLOEJKdGlVSkI5dkt3cURsRXRoeVdr?=
 =?utf-8?B?c0oxWTBXT2MrVlZ5WSt6dGFMalM2cUoyeVBnaDNhT0VtMVAycnRrVTJoemRk?=
 =?utf-8?B?bUhYcFZ5L3gybE83SWpJMFFvS1B6QUFkL1U2Skp4SzkvMTJZbjUvYUVtWS95?=
 =?utf-8?B?OWZjYjFmaSs1VXJjQSs0bDVYTmtSRGo1YjVqK3F2ejJ5UmhoUWNNL0JtYVdn?=
 =?utf-8?B?SzlDMkZTUmRxM1g2bHhUaEhtc0NXblVWWTZ1WndwQWx6c2RYU2JoOExINWZs?=
 =?utf-8?B?Y0dWMEMxOGxtSFl1OTdnMmZKUnlSMFhINW5LblBQVjVzRUJ5YjAyWXVkY09L?=
 =?utf-8?B?OFNzbHNLUjhkNFBUTklrRHprMmt3bzBMMXZzRWNjTFZVTkZZVS8vWFJnbk4r?=
 =?utf-8?B?TU9xU1VKaWVkZmM3Zy95U21BSXJhLzFJRml0VE52VWFGbm9NMm5Bb1c0Tnpu?=
 =?utf-8?B?QWo1MHcwc1l3aS9VQ0t2Z0o5OFJ1QTVqamxzMktmaFBXUWVMMjBWMWFzenJT?=
 =?utf-8?B?SGJOK0dXQVpWSkxiRnFCaEsxQTZSdUdVdGZHSkhxNUJCREhwelp3VHExM2NP?=
 =?utf-8?B?UFh0NEpkOEtsekVnVGZZYVpJQlBrenhDdmw0MW9pYTNpS1FaY2lNVXhwcU1p?=
 =?utf-8?B?bVNlTzYwUnJETzJwZXJTekVwUmU3bnhWT3Q2YTFOZlhsOHJCeUMwNE93M0dw?=
 =?utf-8?B?ck0vZlhxeDZDNSs3NWx1NTMweTVEcUdXNi9qemNaR1FPaU81cUlZRXpXdW9N?=
 =?utf-8?B?aENoaEdSV2VvcHRiamVMY1g3Z3RubUdCSTdWTlByMm9qRDZWZHc4TndmYjRs?=
 =?utf-8?B?R0NMQWNKY3R2eXRlUnhURGROVGxkU09mR2RTU3hpOXhSYkpyaFdNRnhrdEFZ?=
 =?utf-8?B?TDJ1ZU9xV2g2RlZrSjN5OWV2Vy9YQlJkd2ZyeElpVDRxa0FDNjZpS2xYVUtW?=
 =?utf-8?B?cXZndmtTbERudFQrZ0xCSk1RM25YWFNmQlg0WG5xdHorY0Z4dE5CYTM3OC96?=
 =?utf-8?B?cVRWOUdZUXNvckdMSTczWWVHeCthUEdjRlRFOXRrT1FpMVVjcVoyQ0FSNWpa?=
 =?utf-8?Q?sokH7Hc0uXh/CtoeXrDI5kFR0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbdf8ed0-d26d-4411-3cec-08db8a8233a9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2023 07:06:42.1316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0sKLE5C6YkZsne4DoDq/sAKO8NtSlydsnvljCnL4IomdtaUAwLTkt4v87ILHV1IBEOpiSD7SNO2T9VGp1mB/g==
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

On 7/21/2023 1:53 AM, Tian, Kevin wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> From: Brett Creeley <brett.creeley@amd.com>
>> Sent: Thursday, July 20, 2023 6:35 AM
>>
>> +
>> +static int pds_vfio_init_device(struct vfio_device *vdev)
>> +{
>> +     struct pds_vfio_pci_device *pds_vfio =
>> +             container_of(vdev, struct pds_vfio_pci_device,
>> +                          vfio_coredev.vdev);
>> +     struct pci_dev *pdev = to_pci_dev(vdev->dev);
>> +     int err, vf_id;
>> +
>> +     err = vfio_pci_core_init_dev(vdev);
>> +     if (err)
>> +             return err;
>> +
>> +     vf_id = pci_iov_vf_id(pdev);
>> +     if (vf_id < 0)
>> +             return vf_id;
> 
> this returns w/o reverting what vfio_pci_core_init_dev() does.
> 
> A simpler way is to move it to the start.
> 

Yeah, this is a good catch/suggestion. I will fix this up in the next 
revision.

Brett
