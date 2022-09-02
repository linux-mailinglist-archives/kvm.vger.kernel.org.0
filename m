Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23ECF5AA954
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 10:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbiIBIAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 04:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234651AbiIBIAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 04:00:47 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C879E2B630;
        Fri,  2 Sep 2022 01:00:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7EJrOJ/2rN6OAUjMxKryp2HLFQNvgvwhsOXRE7igjKBbMkO9KMgbytbhRzIsDF6EvM9GB6KMs29q54W5ToXDvv8oHQXhvHjzgUnHZAPV5XsDVPjsV7OCvf6BXHPtSkjLMTn+Y8UITROqG6X4Gg8tXF3yDOIl/OiGL5AxBmuQOjZvE0hIIA4fM+dMpCJex6hBhkA59rImGs1gr4Nsy7yrHV8cNh3/RroTJiloidPolIsI4RSi0WUXUlqnnZLbhKLg5f+0Uk8yHTXaSZBZtAkbGVj7yWux3xI7dEHoHUvla0K1I+ajbYitAsLeS1vaLZ+P/6WxoCGCBFU1/7ZixBoqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAc6NoHIe4TRTh85s+UNR60FCk1XGkxBElH4xgyDXOA=;
 b=ADfvoJ8T9/Fi3wWAypBSl5lFa+QQo15vdMGL6npCvk0QsYvd5lpAWckK4MHoqaO/j/bmqNSwnDn6cFGw2BfucZX3C2b0pYygUjk6vWcGuL30Q//bh4+W5qMzBepXSMNYRiICOCQ8eC/WBUb21/H/KTfYZg93RjieG8uQZC2uB7zDk+KJr2nk5k1bW2WFI4mTGzm89Un0DqYQkXzE6rw037LCFU3Jvn1jOeLGEgSRn64xozexC9jla1OUTH7VcHaR6MpkRJpbEwXPiPTYvysupAZGaBgXBAVPIlqmvQ76Huv2RizjJJ2RiZwRtiuvuOTrI+l5M86hUMJKXae2NwYy5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAc6NoHIe4TRTh85s+UNR60FCk1XGkxBElH4xgyDXOA=;
 b=n3d8nLAm08aH8U8wSsfKXeeHyChAvVEcAZWs+ObsJfY2qabgApp4n03fZBz74TBvTD+5y/04b+3XzrQ3qfudJcgzuuJpbUGLt2Ngo1/l+EB4y1SoucSwA1/Fo7RRyyIDxHDvJmrUi+y8Ye/yWUgALD/zMQm+dVHXWqfxm6Zmby8U62oRaPSi710qGK4WcffjxUM61W+FURVTWrwKRcTaWWRle1bbZ7lgM+wKBBOyx6uWF1/GkwjbCT/88xzFlTwvf9aHUoMqFNHd156XrwEaUHfaq3MCwC/0Wmq39Hla/4BYXfF2camGrWitpXIXofhUhJkCbxGa5Y9VY2FK+80+pw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by CH2PR12MB4875.namprd12.prod.outlook.com (2603:10b6:610:35::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 08:00:45 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::753c:8885:3057:b0a1]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::753c:8885:3057:b0a1%3]) with mapi id 15.20.5588.012; Fri, 2 Sep 2022
 08:00:44 +0000
Message-ID: <43807bc4-5206-2c1d-99c6-3fc566655748@nvidia.com>
Date:   Fri, 2 Sep 2022 13:30:32 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v7 0/5] vfio/pci: power management changes
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20220829114850.4341-1-abhsahu@nvidia.com>
From:   Abhishek Sahu <abhsahu@nvidia.com>
X-Nvconfidentiality: public
In-Reply-To: <20220829114850.4341-1-abhsahu@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0067.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::13) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9121202e-5f59-4f08-2943-08da8cb93ce5
X-MS-TrafficTypeDiagnostic: CH2PR12MB4875:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Df/XDKM6MpLV7nDdlEqUAgQveFEsALhewBHM0A/z9Jsh5q/FABe3lVOpc5gKon85KS2yiwyVfRxCxERD5qnmA1xoIa1Nm2SYvvFp5L0ADnbuTG1fj007EZlhk3lfJ2XyPU6ygLh2y/X7wBNJWxnKtuv032w/zhq7PUPqktIQLJVNf3tWDCntjYu5X9NaaM/Plv1GSvPiwOWYFHA7GqABXoXN/+BSQANvxEwNWoLCsxc1XMijNuinvYPXQj+TaOvDRhaM+ZQ/+RdvfOR3bFF9tO/vOemgCZ1RlhPkaZjNSrIRdFa9dFJ22JJd8lHuwDD9YZ0i5EWxs1dgCXqlQWK0n6JVbwykJch3U9us4KwMLs+rW0Po9EXcytKkcCYt8+ESaxXwRRuCePQYA8RnM3UTUMt3PSYoCQ9CtAHF0rrXZuOCkKqS3V8a5SANVxqcBQuBh9p4WUaVwSWdwMUzThnkyMlJWGCus0meyg4zBrIaiWRbU5p5jaOKpmho85O33g3Ra9oZ43El8wXgtnbrIFLDrN79ZLQt52TyXRd89jAijEmKLaFcnnaaqkW3tj+UodXBoyYzge634VymgPo8ZKFYx4l8DCvDtuVDZo1FhOo1vyMuqFIDvZAVzzQ0iQBSxLrBE97pPIWbqnjxC7MraKeXyQl4tljFDOJkiE0OwKc4crGIjdxdPSMgEExf6qTlM7/+vjvKVorGPoBYDqxMBVbxkKNaZHrz/fPIFVZlKnX9LhDqpouD/0C/8hxgUl//YJfrLBeX0AGlil4atqpdLUboKTB8UcztNmWLzlFey8MTapJWi4fkw1uXGYp2vXcjhlcz4/Yu+cUVmPxSBgDY/GWq616ipaJl6bnUd85Axy7OwlnB4CGRIDGHel2GhoGt/S4JPP4rTJ1HJ80f1CeTCqk6FfJAFVKcLp8V4fowMkFIg/U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(83380400001)(31696002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(110136005)(54906003)(316002)(2906002)(4744005)(7416002)(8936002)(5660300002)(55236004)(6506007)(6512007)(26005)(186003)(2616005)(966005)(41300700001)(478600001)(6486002)(86362001)(6666004)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THR3Qldwa09yT1hLSUhoMzM4SFdJdVVDUVU2UmNDR3YrSTRmZFlwK2lJTFlw?=
 =?utf-8?B?cDFnNEo5YkhYQ21aNW9GVUxRR1pYQUpPL0ZRa1diSXRhRkd5dkdIQVh2RjJG?=
 =?utf-8?B?VjFYd0NmZEhsN2pQNW9iSS9wWWN0OTVuM285YVkxeEt2bnlEM2toUlIwc0Ny?=
 =?utf-8?B?MFl6MGZyRTJBY1JRL0J0c3oyV0xuZG9LbzBmeXMxUjZ3c3dTQnBwd3JHZ005?=
 =?utf-8?B?ODl3YWRXSUlDQWJhL2Fzc0lwTGJsbTIreXpFREFXOFRiOE0yRk5GVS9NaGZn?=
 =?utf-8?B?M1pLcDVYS2p2eGJwQnNxK3ByaCtpZXRaUUJ3MXBxdmp1Vi9XTEd0VDdtOEpw?=
 =?utf-8?B?ZVk4bzJ2eSswQUhjVmcxL3BvWnBRN3ZMMXVuS0JXbTdNMEpPY0phTXZTQjBE?=
 =?utf-8?B?R05US3pyTUtXYko2eUQ1YVZ1K3hNT3FjSjNNVUVxM08xQlFRSEE4VGJRZDBS?=
 =?utf-8?B?aFJoMHNDM2Vjd2oxMVlPTEttZE42QjRVWEtrelhmWGNvTTV3R2FMZ2pPRHVp?=
 =?utf-8?B?dW1weDhWYXFuYkhWQTFZVDhhT3RmaUdpd09NdVYxZkNkZnNZanZNMnVIeHEv?=
 =?utf-8?B?aUtJYWJFeEJ1SWNDTHhVK1I0SHZMUTJWL042Rm1YTCtsdVVrMXcyVGgrRVcw?=
 =?utf-8?B?MjVwaE5zRTg2bjI5UnJFdlhldTlIZU9jbHBOYTF0QjZWTHd0ZXFLOHpUb3Vq?=
 =?utf-8?B?MzlxYUFHNzhUSmp6ZUlmd3N0OXNQdGg1L2g2Uy9hTnM2eFRKUmxwaGIrY2Qv?=
 =?utf-8?B?NzlRWDRtbkZ2STFrRjVhOCt1UTg3Q3d3MVg3c3ZmN3Q4MjQzRm01Z1J5UTZX?=
 =?utf-8?B?Rm9nSVYrZEFzeTErRDVoSkJlY25NU1hrRCswQ3dJV3pGaEU2dHVTQlVxbnho?=
 =?utf-8?B?MWJzc2hFSVk0Y0tkUzR0YXZjQXZhWk0rcm9TQjFlTzNpU29vT0N5OFNrY3hU?=
 =?utf-8?B?cHJua3hUb01CZm5IczZJNmMzWnIzZzhsdGY2SDVMWmdRa1RabjVWYW92RDND?=
 =?utf-8?B?MGVlZmQzUUdWd2pwZzIyNHUxYytzeDhQb2FTSzdCUEJDQkpTcGhxNGFHa2N2?=
 =?utf-8?B?UmVkTEorMm01bk9HbmxIbUh4ZXp6S2RMU3ZqRnJORElTbVZPRUxFay9LMk9z?=
 =?utf-8?B?aytBNVdTek5VZ1lud1hSZzJWYktCVXU3YmxMRm4vQW0zVFVTZS92VHFFKy95?=
 =?utf-8?B?YzJuQU1qc0RPbDhTaHUvQXAwN1BVN2JkNEQvSlJSaUM4VmNiakp6QUx2Q0Q0?=
 =?utf-8?B?dFM1dlR4YklSRmpQZjhvaHJUcWZyQWdPTDVhR0tOMGFXUXpYV3dkS1IzanpV?=
 =?utf-8?B?dVZ1Zk1JV2xQWndENSs2RENGcVhmLzhKR1NHQWplNW9sS3BaNXRpb0hKZmFv?=
 =?utf-8?B?QllmWFlqdTYxNzFmMDJXS1ZJTG1yMHVFUjduVEdvZkRjcHR5ZzZrR2kzeE9p?=
 =?utf-8?B?bGZ4TjY2emhNZiszK3FsdDFocEJUaDVLSlZKemxnWXVFaXMyK253cS9waENI?=
 =?utf-8?B?MTdKRE5ESG9ocUltWVZsNk90d1pBZWxvQWx4RjJzV2RsVU9KZXVJK1F5U2Ru?=
 =?utf-8?B?cnltYlJ1ZEhJd3hsaXNrLyttak5yTmc3K2M1VFdsQU05NzZOWUQrdFc3bjNt?=
 =?utf-8?B?NDZ0YjJMeHhSUG4zY2xSK0ZlTkRCYkFPdmdFbGQ1a2w1Mjc5VkFYUlgreHh5?=
 =?utf-8?B?dzQ1Skt6clFSdkNTTFJhR3pUNGdHc3VwajZ1NHhySUFUL2xNQ25ocXZWVXY4?=
 =?utf-8?B?dElybVRmeGVOdS9lUkx6RzBJMFJ0ekN0YTRkWmI3NmZibmovTjdSZEFWci91?=
 =?utf-8?B?UUVVNGxuSVVIVk1QZHJnUkRYSE9PU2h4NnE1YXZ2bWxKTkJpSGpITFpheCtK?=
 =?utf-8?B?S1RXT3pLNTJnWEo0b1pxNFRQVW93enZ6RWJQR0pXcFpxdTRYL3k4dDBXQ2pT?=
 =?utf-8?B?QVlhUHJwYnBlR052SXVZV3d6djYwVTBYbnZXL1JHa2c0TGxVbWZEM2o0bHhP?=
 =?utf-8?B?L3orMlk4M0V3OTdCSW84eENWNS9jNFZveTFnTS9INHlEZ0RtUjN3a1ZYUm9o?=
 =?utf-8?B?MlBacGt4MGp1SDlzbFp5c3hyTVdGNmtWaXh0UGtFc2pubkRtYkdHdlAyYllC?=
 =?utf-8?Q?i0p3gWqcsA1dzawk3PvaFcvrW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9121202e-5f59-4f08-2943-08da8cb93ce5
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 08:00:44.8115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hQjFCA2pDQ6x+pzdcbwpdodUZm2RNA94ICqWGgveXYpLK21uX4/o/5WkkEJkhc6bpUt3jxayOH4El+lzweH+pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4875
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> * Changes in v7
> 
> - Rebased patches over the following patch series
>   https://lore.kernel.org/all/0-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com
>   https://lore.kernel.org/all/0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com
> 

 This patch series is getting applied cleanly on top of Jason updated patch
 series as well. 

 https://lore.kernel.org/all/0-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com/

 Thanks,
 Abhishek

> - Since is_intx() is now static function, so open coded the same
>   (s/is_intx()/vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX) and
>   updated the commit message for the same.
> - Replaced 'void __user *arg' with
>   'struct vfio_device_low_power_entry_with_wakeup __user *arg'
> - Added new device features in sorted order in
>   vfio_pci_core_ioctl_feature().

