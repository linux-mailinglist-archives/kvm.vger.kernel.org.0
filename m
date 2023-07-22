Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C9B75DA8D
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 09:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjGVHFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jul 2023 03:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjGVHFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jul 2023 03:05:37 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32503C04;
        Sat, 22 Jul 2023 00:05:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LqkjwJgCtOe4GFCbCo3w6qa2xSDR9ss3cm77CtJrXAHfWjX6bKj7wW8DJLO3mBKKS8mw6v+e8sAVsF6VyNhJ++O2QH/6ZAYJzxEkeJkVcchBpGJaInUxPZtGDQSOZhacLO9eBJDzGNfHJdhSC7NQAwJYdkji1qPIDK+iTxWAiCrlG2fEn1vxQEnonqN0Hd9joLNlrYb/aZu08WxMOZxGxFPJf1HGiFGKWaQw8k6qZZgd2MR+kl/DWUXWXIdtc8VOawGp7IpywzWJqv3bFPkodH65LmYZ2yuuSSRCixNWCf+b39YmQObBboACd9vwly57wyO44RlvYad/L2Rmvvpm8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SPAbXYpK8VQVRwMP9ggh23iiqT+rr76gMw7ImfaFdKU=;
 b=T9MhaKDTRCvlt+OUJaiXPc5Mewo4yDZrLyNw65KqS3DesLLPpC2ry9y/WWg+eAKdn9HgP+ZC6V9ymBs2ZUrNgmovXOHxpf7zEaSEutE3PAQeVTyX00UvrIqquKClFtXNU8FfyUq0sfvIu7A3kD+oJ1BLPk9GRJy6/ApuA8HNMSKbTEFE6ta1MPLULtHS1ni0HhjGkixdQoqdyHTqq+nvOmQHk/KkbHao8VfZrVc+93PPPuXfN7I2EnmxjRl/1wxu2nV7RXyfyx6fzs1olVJFzrOL56/RQCe6bbBIo6WIYiGm2ZrJ1sgezmHeSxLtPe3P0TC5g/yXkdG+TjINSIYM5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPAbXYpK8VQVRwMP9ggh23iiqT+rr76gMw7ImfaFdKU=;
 b=qi4KTlwKiKa4PO0n/odfpfCN7+9mVAHfNOxFO9dvgm7gzAr19CuvrDYfAQd7KNQuL87/6f65BuypvuSFEJKXNVilcYMz+XZykOcEumuaLNkuMQXVM2GvER+SNlQ0ryhaa+sdgf04vcPxlcT/N3k6fXV/Sir8KRKQ3BCHpnentn4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DS0PR12MB8271.namprd12.prod.outlook.com (2603:10b6:8:fb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6609.28; Sat, 22 Jul 2023 07:05:29 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf%5]) with mapi id 15.20.6609.029; Sat, 22 Jul 2023
 07:05:29 +0000
Message-ID: <907b25c6-b7a6-8065-87c5-af8b78b6bba8@amd.com>
Date:   Sat, 22 Jul 2023 00:05:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v12 vfio 1/7] vfio: Commonize combine_ranges for use in
 other VFIO drivers
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
 <20230719223527.12795-2-brett.creeley@amd.com>
 <BN9PR11MB527674C8514E38AD1E31B3528C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <BN9PR11MB527674C8514E38AD1E31B3528C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0302.namprd04.prod.outlook.com
 (2603:10b6:303:82::7) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DS0PR12MB8271:EE_
X-MS-Office365-Filtering-Correlation-Id: 70cfd475-7a9b-486c-8c73-08db8a8207ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uRVLjklnReA7XT2bt53qXwh/duLvUeBDE8IiPjO84e/e564eKTwW4rPGoO3nN6mEcQt/R0Z6FM1wYgsvfas6QPRCntBXQ/JLQuxovT0GlbcwiRXZ6ZlYgyYmbk41L/gnv3pKfp0Z7+qSSnu6Iaiy/xLIjQNJoD27WEzyoNqtWXb4RcPgZ+EYPI227BpcV1pyOJutIctRqbykmHug+KLItp2jto/i6Ze/Dw+3rURg7HlnP7QTAJgo7mbqHrHNogsS+6LUt5yAVIGv4NNBLcHLxQxlJweaJrbRc3m3ItpOL+zzobf7A9izc7kKCFdOvtTeVUGOgSWvmCWC3CjEFXCJF/AcfAsSwom3W6ug0U97qLrHLY8Eh0b06sXjVpZiaGvifEcqJ8WffjIvXYUQrhQ/bzFTp6dYaVWnDGfFqJVV10MnZdzmWBvxGJvY1WFJKBw7sp+Ju/GgUi6iWUT7mRgLUUq647Q1YT3+Gp2eJemIIzFs+ZPAbEwsHwnmgIZtjTBZ+egK/EJPpotompW5LIubqETUlVTu2jSxWIh+sS+m54bHUcWQzGFrBD7prBoBKvXnuf50dRjy3G/TkxEKmHwdNlCV78AtyArvro4leJqaUHfH4LP5XRG1bpuESIliiyfsv5ELhJ1mkLVvtN+SetROcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199021)(53546011)(5660300002)(6506007)(8676002)(41300700001)(26005)(186003)(8936002)(31686004)(31696002)(38100700002)(110136005)(83380400001)(6666004)(6486002)(6512007)(66476007)(66556008)(66946007)(316002)(4326008)(2906002)(478600001)(36756003)(4744005)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aitYVmxvNzVXUUFWZ3p4VGJveVV6b28wZHFMRldaWWZLSEx5NHhXTDZYTGVG?=
 =?utf-8?B?YnhyMHpWTzR5QnRLV0xaUzhNeUhpc3RERTNOcDgrbWhwQkhFWlJCM1JEblpk?=
 =?utf-8?B?QVc0NjFsNnptL3BXY0dQZFpBTndUZGtDNzFuSG9jMnFEYlFnbmVnbCtTN0Fo?=
 =?utf-8?B?Tm1kRmNrOHZtRngwWk1oL2NZM1ZRQW1OZEpYLy9QVDhXRklYQitCYURVSlM4?=
 =?utf-8?B?emdhUDd3NUhqT0ZqZmxLQ2JkMXArUTZ5SDZDMWhXb0JDbWJHeUw2OExWVkp3?=
 =?utf-8?B?T1dQZDJIbjV3MjJuOXdyRVhJeUQzelpYa0FGSjhQN1dPL25ERkpZSjRONXIw?=
 =?utf-8?B?dUZGOUt3NHdWR1F0QnlndzdMeUVaazkvR1E3ZTI1ZkNnekdUUWRhdXh0Q2w5?=
 =?utf-8?B?K3M3d3lIK256bStpWTRjY0tTY28xbmlDRyt6RHNiZmVKRFoxdG00NWlHWGth?=
 =?utf-8?B?Q1ZPUkRBYlZxaEdnWFArM0xRaE1XTnlXUHZ4MTF3NjZ1bS90d3FhVnl3TFl6?=
 =?utf-8?B?b1ZMNXBuMjJMNkp1dDMybWpSZ2JjKzRRa25XaEw1K3Mva3lUZEdFUmVpU0VK?=
 =?utf-8?B?OW1iSmZQYTM0bi9xemsxd2EwVjk0bE94NHZwTWlydGhkUHZSVHFoUDV0Y1p4?=
 =?utf-8?B?bjdNaHdETnlWN3lKQWJtRDZBSzJySHhJcTdhZWZxY2tDejMzenEwYUxyL29v?=
 =?utf-8?B?RnF5TjU5akp2TTV6ZGxhTG4yNVAvUnVvbUpjNm43Y00zQzRBWWpTY2pXUWND?=
 =?utf-8?B?UjdIOWFZY0t5R0RoWU1VODVQbjJLVFNaVmJoTEJUaDh2eklVem1uUXdvQUVC?=
 =?utf-8?B?Tjh5TkVSTmREaWNDR1Q3S1N6WVVkdG9yYmRwUE0zc1ZTMzdPTUFsVW91SFdh?=
 =?utf-8?B?c2JWU1ZSQW5QeEZCVkphNVZueVltdFFMOGNGZ2NqRWJraTlqS0kyOFFYUnUy?=
 =?utf-8?B?b0FCWXZlQ1NpYmljbmh5eGZLcEt1YkN4SmM2MjhXaGowQjE4bTNybWxCQ2ww?=
 =?utf-8?B?bkFHSkpSSStoUkplVUpNLzdNZlNIU1k2M2huckQzZkhZNE1WUzdIRGdFWDV4?=
 =?utf-8?B?Ni8xRkhGT0JyOVJpeis4K2ZRMGpySXVUdm1EVTVBVThQK0pTNkl0ZStLakRr?=
 =?utf-8?B?S2ZJSS8vYUsyVEZLZGpTM3VFRzBOWjNlT1hERk9nMjBjdkFTS2Zhc1NJYWNL?=
 =?utf-8?B?UVdzMDlLV0xxa0VpNzlOOFNnRCtqMkg1NWU3REo0RllPdW94TnZ3Z3Q5NUhx?=
 =?utf-8?B?Q1hzZlJTZzZOS1dCWGZBb0FGT0VIQWl0a2RMU3l1cFpYWDc0VWlYVXIwZ0N5?=
 =?utf-8?B?SnRsclNJY1NUT2xPbEhLK3d6d1VmMUF5VkVrK0xnRHRoTENGNzZTckZuY0kr?=
 =?utf-8?B?ODJDNzFYUWZ2eU9uV2tyVjR0eVhLMFRlOWozR0dNazM1N3lNdDNTMXJrSW1I?=
 =?utf-8?B?S3ZzcmIybVlKN1pLL005R3RaZjgwUFdKNXcyODJDSFQ1ZTloWWUwV0RkYXo0?=
 =?utf-8?B?YzF2NG9tWHBadmRoZTk1RjJOYzB4TUtCMHE3QUJ3eCtLcy9MNXBjWWZVOFlJ?=
 =?utf-8?B?bnV4Y0FOUDE3bFMvOE1nbnpUTnFCQlRZR0ovaStDb1U5bmE3TGV4bm51YlhF?=
 =?utf-8?B?cEQ3bWVUaHZwblB2OHUyUjJWbEdnWS91bTYrMW9qQ3pBRGJTNHhiOTBmemlk?=
 =?utf-8?B?WHpoUmRIZXBmTDFEUkdCZUpDRG0xSGhQWUo1ZUY5d1E3WnBJUzhoOW1QREo4?=
 =?utf-8?B?bndtOUxGejVpMmJFZGwwTHhNZnVSRTI2WXh6b0s4dkVPb21tNTd3VWdwS1pU?=
 =?utf-8?B?eHlsZzBYV3FtTjlsUVo3R1VHRWdYVDJNeWZLTUMyT1J4Ynl0MUFDTUcrTkNC?=
 =?utf-8?B?alRYQ0twK1k3U08yRHA5QWs5SStOMytJdmtFN1RqcHp5bXRMVUJ4TjJjSnEz?=
 =?utf-8?B?VE9FSkFrLzMyOTA1ZHRaOURoeW91VHp1YkpIclZSbE9aTlFFd3F0N2Z4SWd6?=
 =?utf-8?B?M1pQdFVLek0ySTJydnRrbEczVVlyYTVUYmQwSlRrSmNnY01mcFljdjk4Z3J4?=
 =?utf-8?B?S1VLMnVRZGZDYjk1bTN6Y3ErdkM2a0tIU2NvQWVHR3VkY0xKMXFac2JPVmlD?=
 =?utf-8?Q?4WnSgikGkhMO0I0b4FuXjG9EN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70cfd475-7a9b-486c-8c73-08db8a8207ff
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2023 07:05:29.0025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bGvU/VzIPtBlvsHzTzKojMAp6H95ThnowlkvNFSXXc5u8I2+FS1N1E9hHsDz9yU87fq3iCVsYqQ5b2E/F0MEVA==
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

On 7/21/2023 1:51 AM, Tian, Kevin wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> From: Brett Creeley <brett.creeley@amd.com>
>> Sent: Thursday, July 20, 2023 6:35 AM
>>
>> Currently only Mellanox uses the combine_ranges function. The
>> new pds_vfio driver also needs this function. So, move it to
>> a common location for other vendor drivers to use.
>>
>> Also, Simon Harmon noticed that RCT ordering was not followed
>> for vfio_combin_iova_ranges(), so fix that.
>>
> 
> It's not common practice to put name in the commit msg. Just
> describe what is changed.

Okay, I will keep that in mind in the future. Based on your other 
comments there are some minor tweaks that need to be done for a v13, so 
I will make sure to update this while I'm at it.

Thanks for the review.

Brett
