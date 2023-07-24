Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B1B75FEED
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 20:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjGXSUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 14:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjGXSUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 14:20:51 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3469F10C3;
        Mon, 24 Jul 2023 11:20:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvA6L7tCZlY4ViCgNL7tHlc5FDZwPg7HBLSbL1jO6wBBEiGHB2hDmOo8d/8hSxibl1nXIoNDqbgv3ZAD0tKw7L3cxExC/rxMnvjiYpLBRrRpKW6HGq4PwcV5+P3bL25BIDbojc8uou3YxynYCaAP39ZNzj9OqEifBc3iiLpwrRg82LZftXJeu9u+7cDxjA0Zp1RCD7FOh2258rOj3yo7SWpiIVDtyYfhaXDn7wz8mzcn/qqacw7LFn9kNG/iGAzSwPNEGJgeRLE89vEY7tTWsQ3potbYRk16VLJ66p0+ACLxPXEFBxuy6Yzk39PeI18rsG9XviXfvcoGUNeGBh6PpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1c46BB2XlcHxtoHWpnVcWAo09jh546gaGkDXcCaG/4=;
 b=D5n/RKIQUyNUdMUYrTP2bfCo6yIdOeNijqHF4lzPUOtqBtcjNoX94778rdr+pmqy/MQDHz+P48p5h9Mf8pXxkiH+rcQjcacTOEavFCxYELe3mMrD1kSR4Jw7aNz8XguGOJzu5c3gz4URtC9yd/imSSFt+rY33phihxGPYfl29vDqtsVEjdQvVaEet2TslKRfSyLg7QA3OC8Z2e3JktoeZSibqHhj+xx4MNdFHeKnEfALeW/ZYnxdiEp/idjUoiZ0+/yYGY55tQeZ9A15gUAc4jJNWFMIzX2NPIziOkZV26P1+WojUKe2E1bZVX+hmL90/McgKdSzER2cws1msPsbZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1c46BB2XlcHxtoHWpnVcWAo09jh546gaGkDXcCaG/4=;
 b=wg95Uq1LpguKcofpWQCTVul9zgf1zrQYkAYaAd74zGTNsMoC4YcaDyb5uWzY+phYOlvMjX0wIjG/G7GWRhgbz8AZ/jlAvlbIqPLU/RXYocnvaUGV6utcg6xJF+q4VcCKpTdkIJaSYzrxWik9aBuw2gaCmH4CCnBrU9tKD3AjlQo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by SJ0PR12MB6807.namprd12.prod.outlook.com (2603:10b6:a03:479::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 18:20:44 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf%5]) with mapi id 15.20.6609.029; Mon, 24 Jul 2023
 18:20:44 +0000
Message-ID: <fff62e3d-997a-69fc-fb2c-43ef9e7def30@amd.com>
Date:   Mon, 24 Jul 2023 11:20:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v12 vfio 3/7] vfio/pds: register with the pds_core PF
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
 <20230719223527.12795-4-brett.creeley@amd.com>
 <BN9PR11MB527656A2E28090DDA4ED07728C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ea5cd85a-e29e-d178-5b17-1440be84f5fe@amd.com> <ZL516RPMMHS4Ds1k@nvidia.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZL516RPMMHS4Ds1k@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0367.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::12) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|SJ0PR12MB6807:EE_
X-MS-Office365-Filtering-Correlation-Id: b889d9ff-a1c2-4ea4-861a-08db8c72b1fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mtmy66q56PzRLkGs1peKOt26lnV8A3hpVb8VcZ4+JhJKkYCmAz8gfzCVyqMfF9453ihkJNxEsF5NmuD1hiielfctrxY/5G3kQzrA6NpC2sTqb/EipfLzuMMbZ/bZ7vdac6A6vbDu35CilZOkcVNTEZepmS39hgST98A44pTGZCf+YN51NB3QfcPlLIOSOKX0jbvlCzwGrXsEm+eysSomoxPD6aAHjsXsjUGvKQpkP9DiqFdVZ00diz/jQu0P8M1g5o6XDkO5d+5iQNFZroL7Tx17YWWjPoH6D522zpo40T6GsvsEXXYPq4tn60+HFHC39JUwOrh2jQXLX+W/5TnaY3L/jkxtQZlSpsjjiGgEzMmcGVnS39F8tewaS6e5KcHFnH+OyT+wzRNowMzi564rBSiU9yWMyKGYZlJmlKeDTqUWljrZRq9aqMYNv7nFLaaBuxasUJe+SK9n/Go6aIH7I5fRq+0sRIeB58k+JhmKAUxDdyDqz89pT9znhmF5zYZEqirM/GkIfDNKMClPVLCovrQeFfPL/Z0QylLESeXzf+REYQM+kjJ4Y0eDqSmzVXLYmF43d6DutFjsBEpvvcfLbY6Pxj52h1+ry7sLo6fTMIZDLNWjTCoT53WvYgwyqkfvkTeqMTB8Dhx2XMc9O40ToA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199021)(31686004)(31696002)(38100700002)(5660300002)(66476007)(66556008)(478600001)(6916009)(54906003)(41300700001)(4326008)(316002)(66946007)(8936002)(8676002)(6512007)(6486002)(2906002)(186003)(26005)(6506007)(83380400001)(36756003)(53546011)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDJneFVRLy9lSFZnNlFpNGtvdC9OOG5oL1B4NmNySzVIUWFsVnRJc01Db2Fv?=
 =?utf-8?B?NUVKL24rdTZzdUo4NWxxdDI5ZUdNYkZabE4zV05QVGRwcHZOck42Um5BaVd0?=
 =?utf-8?B?c2grbDl4TDVURlUvclpURVpPT3lUQU10RFluSGNlVVZpMWhDUy9VNXhYOXdN?=
 =?utf-8?B?WkdBYVBObUVnZzQ0cXR6aFEvcGVpUlZGbHUxODlCeEVRWlpZUUlJeXBUMWF4?=
 =?utf-8?B?U0V2TTcyWlZrM2trREF4OUhyQVdHQVRaOW8vWncvY3ErTDhwWm5sT2QvNU9K?=
 =?utf-8?B?NG1ucEt4dzE4em5QZFNYN0pjOVZMUlpBSDgvVUVHNHR2SVhEUWlGYXhUNTZR?=
 =?utf-8?B?R3VUbjBBdkU5K05OOVRrYkd5Q1BoaVlWWUs4R3ZtQ21hdDByak4wdndaSzkr?=
 =?utf-8?B?K0RCNjFDUi8yOHFnY204V1RwVG03dmJkc1ZxRkJhMk0xcUdoUnB3UDVBdlll?=
 =?utf-8?B?cWNvL2NtdE1nZGxsZFlITlhGQzM5SmEwSTFNdkdlNHJuL2l2dkNsRFJOTmU0?=
 =?utf-8?B?d2VOZkVEb2pHTzdGcGl1SnUwbUJGK01EVXFvc3NDcHp2WTBpR1Z5bTVpNklW?=
 =?utf-8?B?enlFcjF0RDNtQUkzd3ZGdTFKUEdVVUhrV0JVTFBndGtIRG9RSEcyUEczeHlk?=
 =?utf-8?B?RGh0L2Z3RElFYmNMaTl5MTh1dWVGZjdyT3VjMzVKSlBaT3FKNnNSTlVhSzlE?=
 =?utf-8?B?TFlQMUFZQVZ4bTFGcmh2Y2x6cWpSKzRSamNMbkFDYXMvb3liYTJlQzZDVExD?=
 =?utf-8?B?MHF4bjYxd2pCdmttT1RTWDZETDlDQ0NmbG9neGo3QVNJUFJLTWdMbXVOc3ow?=
 =?utf-8?B?eGNhbjFzdzZuRTFkamt0bm9maVE4TlFNdU9LTUZOYTBpVnJtT0g3TzVTMjZq?=
 =?utf-8?B?dXBXb2lsbzdVVXEvUDNTaWJVc0lyQ0cxMjU5dGRFM3ZHdkp2eE5kbVluSWtB?=
 =?utf-8?B?bDdSbHpmRWNTL21kajZWeTRiUzd1c0RwaU4zSFA4eENWeWJsMDRoZmdaTytq?=
 =?utf-8?B?ajNwd1dqdXh5emxkQzVCNVZxdGJ6YWpvQUJlTXFET2VsU2ZwbjdYTEJBakl5?=
 =?utf-8?B?YXBEdjhxQk5XUVJkTm8xYWhPeEpqdWtMWTBhbXNBV0pNQ2JlSTlGcmJuS0la?=
 =?utf-8?B?d2thU1lsWEtWMTdEMmkxd2VZekZBTE5uQTNHajh6eERyaG8xSnNaa0JQQzll?=
 =?utf-8?B?T0wwVDgrVVhmQ3RJR0dBeElWRmIwODFZemlTRXhFczRLQWVwZmprcFd4L2FI?=
 =?utf-8?B?enhUMjdnWmd4S09BTko2TEllYjhtT05VdWYvVWRrTW1pK3VxenFqdDJkaGVK?=
 =?utf-8?B?cXdzbmRKUStOTUhLMmg4bFhUYUVDcUJsakJZNjhpMVpZaUVocEx5ZTNQSjZk?=
 =?utf-8?B?bkh6WDlhOUV0Z3l0ajlUUGltaVpsZGMxWDZ0QnBnc09iL3I5dkdPQ3NzQ2Vl?=
 =?utf-8?B?N1pwWlltY3FsZEVidFNxQWE3L1REdFRtQVdrcTA0YkhLSTJzcVIvNHA5ZUF2?=
 =?utf-8?B?LzMwVkhjb1BoYVFXVWpYQWt3SHBsZlQ4bXdiT2VkaXBsRHdvMjRuMlY4NWhw?=
 =?utf-8?B?VFBVd3FnVFd1NUQ2WUxYZkM4OEJiakkyRitkS0VId2pnSVVtd1gwSFFxWDJ2?=
 =?utf-8?B?ZjNGY2pLZ2JaZ0tvY3YvUmhXRFRrOXZQWDZrd1FCcG52U1R6ZHRVMHZ2MC9s?=
 =?utf-8?B?eGFFdHFwam44eXlUTWlUbExObmgzVUI2U0lMRFhTRllwSWxYOGdrazdvc3BR?=
 =?utf-8?B?M0JINzl4U1ZzSXpFaERJTThvV1FvREt4a3NKM1FIUG51WDBjZzcyZUozUVhm?=
 =?utf-8?B?Smg0aFRXTm9lTHJ6dzY2NWxMbkk3TkovcGxRNTNwU2dlVnFoR2FLRjkvMEE0?=
 =?utf-8?B?WFZQcjVXSFI2dk5xZTROMUdWSVRWUWZHOFcxM2xCK25nVlkrMGtOeU5lVFlJ?=
 =?utf-8?B?ZXNRcUg4TnNBUkJmQmdIVytOVTgxcnM0UjhKV252V3FudnlLNTNnWXZyVVh2?=
 =?utf-8?B?WFVmQUVrQWcvbnltTjdJSWNURHdvOUlBRTh6ZGQ0OGpLcTlTT05KZDF5OTBT?=
 =?utf-8?B?N2hDbHVuU213YUhhajlFU2NHbFluV2psYnhJMGJBdXFlN0JDOHRZZkZLalND?=
 =?utf-8?Q?eB84jYUuDRU5v/I3dSsGZMBkE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b889d9ff-a1c2-4ea4-861a-08db8c72b1fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 18:20:44.4239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fEeNbYuUage03PEgfAS8C8b+vDwl54egA88I3vAy2rS+iIMfzdBjpasuY+6MzEpzBtA9Mn9Xe9zMyYXjaEER3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6807
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/24/2023 6:00 AM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Sat, Jul 22, 2023 at 12:09:58AM -0700, Brett Creeley wrote:
>> On 7/21/2023 2:01 AM, Tian, Kevin wrote:
>>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>>
>>>
>>>> From: Brett Creeley <brett.creeley@amd.com>
>>>> Sent: Thursday, July 20, 2023 6:35 AM
>>>>
>>>> +void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
>>>> +{
>>>> +     struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
>>>> +     int err;
>>>> +
>>>> +     err = pds_client_unregister(pci_physfn(pdev), pds_vfio->client_id);
>>>> +     if (err)
>>>> +             dev_err(&pdev->dev, "unregister from DSC failed: %pe\n",
>>>> +                     ERR_PTR(err));
>>>
>>> Why using ERR_PTR() here? it looks a common pattern used cross
>>> this series.
>>
>> Yes, this is intentional. This is more readable than just printing out the
>> error value.
> 
> That seems like a hack, it would be nicer if printk could format
> errnos natively

This is already being used all over the driver hierarchy.

> 
> Jason
