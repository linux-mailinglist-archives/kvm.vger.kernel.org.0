Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2011539747
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 21:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344224AbiEaTor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 15:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347629AbiEaTo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 15:44:29 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2078.outbound.protection.outlook.com [40.107.102.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235CCA7753;
        Tue, 31 May 2022 12:43:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MD4zkwkdCOcgMLJJOsaDpi8Niladn1pvoo7ZRMh5nYPhtF36imEczwsb8otIUMUqJ+WP7a+IiQ28THdvwi7p8opW58u04+OuUuwNdnIzJFKkplAr0UMX4XnFzVGr65PZiTFs/BLlM8kcoMrpzZTtu4x0LiaKgtEGr+18Y/4HE/jJ7tG8oDL0ezC5cAnFjHpTm4BeYZD3OuzdP9+BAfPhWaO7OapoLd+Sc7hs8h6KDwC2T1vFkCPp8SFe6sQrEc4h3v4MJUVhIFcTzN25V3FDNlJ5iwmll4vSXuWMn1gldOhUxzXu4MjjwTssDsVZpRw0iWx+RMM3/oQzFNIE7xcMgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xogse79Npl/d1yCY89DojkmiFL474IRpOZPcy+Iqqw8=;
 b=DocBnC/AxpTKxKSHP0hN3MJ+fBgGUaGziHTxmrTmCtjzRSMkac6fttY62RQU6OUxwOC0vW+9+dVGx1lxjNE9NIv9/R9yX0NgCEh7SErPZD3Ur9FC/aiZl0XBfQRG7bo9ENNDInxwHbRuFq2kA8AG5xK7UJi0oRtBzsLPmnYCW1pV51mmukMpX0NtRNPyCUtY9u6Z6Z1tUYj4C+nm/8IsPhtOKlXzTL58HyxObRh6hJYSWEgbOAI/hUmoSRy8REplTPGFXRnEVWi3syP+ReQ66WfOOj9dhCvBA9KaOkLwxoUav6W8GZXuL3MZ4Bh8S4E87mzTLUAsrfYxXoUAojq5oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xogse79Npl/d1yCY89DojkmiFL474IRpOZPcy+Iqqw8=;
 b=OXICDtCFnP21V9vetsFrxrspFUJ9Dzsl4+KOPWk6L9yIAZriqFfp2sQJRB/s9QderbuNcrNdhDxTkAmHcQ2PLVV8RaAWRxD0b4R7+d9idbdX540XZTk0srT7YAMfi1+KJWl18IksZEpDOBNUFJI/W3k9srKjI/Z+d7u1mDow7+iDJlLVzuh4Xs6aA/6f1fRyisksgKzQmQTZiKAwymB+328KtW/yGnWokuBEwJ5Hbitx4e+aFKfaOpm9+BAEQGm8slVXM8/Ik6m4xPvIxW9lDy0g6qys9b+ELyGHLU8LFTUeMsaMJLbkz4yAg0dHHIQrU8cSNBqgTbc8JzYtwzYjWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB3859.namprd12.prod.outlook.com (2603:10b6:a03:1a8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Tue, 31 May
 2022 19:43:07 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.012; Tue, 31 May 2022
 19:43:06 +0000
Date:   Tue, 31 May 2022 16:43:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
Message-ID: <20220531194304.GN1343366@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
 <20220425092615.10133-9-abhsahu@nvidia.com>
 <20220504134551.70d71bf0.alex.williamson@redhat.com>
 <9e44e9cc-a500-ab0d-4785-5ae26874b3eb@nvidia.com>
 <20220509154844.79e4915b.alex.williamson@redhat.com>
 <68463d9b-98ee-b9ec-1a3e-1375e50a2ad2@nvidia.com>
 <42518bd5-da8b-554f-2612-80278b527bf5@nvidia.com>
 <20220530122546.GZ1343366@nvidia.com>
 <c73d537b-a653-bf79-68cd-ddc8f0f62a25@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c73d537b-a653-bf79-68cd-ddc8f0f62a25@nvidia.com>
X-ClientProxiedBy: YT1PR01CA0103.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::12) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 020aa98f-292c-4405-4803-08da433dc856
X-MS-TrafficTypeDiagnostic: BY5PR12MB3859:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3859F52DF879B3F615F9002DC2DC9@BY5PR12MB3859.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NPiAdQplkqotMch7rsaoRXyHmIH1fScX8wU3mSg/7PLBIhHlamNwgo2HvNSSsfYL+8qusP2hYvDeBO6sOMQ9IjugQwXwUlejEzDOuteB8xNX78ni7z6NyJzBzjoBixN8cNgvvFnAw6FuuYE6m19PtiKgleFSxPsn2wEJp/v20eT41O7PYw1CbSJBjFUx1EmAb8lFOAoFSKRKNwKPIOd9Bh5EujAl3Jxd4VURjm+ARYM+ekoTbwV7+QdRbyGHVv17wBd0vxpKqLCzYVNZQkGoJSo5ay7SdAW8AvPT2T8pndhK4FBMVhbEZUnTlUTJlrUaI7qZOTZv4CBp4jM0Bz3+6sBtriGZp52TicS5cCX1dZR+DFgtkRsAfAwdA6TmNFlj0IY7PpUgA/3PuUktV+mBfl+KIRjtR6z77WSqD1Sjy1yeKnitj3UrjBhMPJr77/LjawPamtp9IjrsbiQYkvhNsZlqRk2yzElz5cWaPwTBHw+kbXN+ot+M2KYT04DvYWDcWWX6Kz5OUMSYBacPO8LB5i/+rnyw8lf12IHZCbBrRVlph5ED41GE0Ctq8SUH7jPYq09OovJfNtutcOmbp+uan9X00PQl4MboHz8HXsDCODSOuzeTZQURJzBIvd9MerD7uMnhetGD1d+JojlHn5GxiFpKKy+ezOr6u05HGHv3n3i5X09Za+p09Lnwzgfd4LnQTLsXFKc5wTLS6BX58/TDAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6862004)(5660300002)(7416002)(38100700002)(8936002)(54906003)(6636002)(37006003)(1076003)(2616005)(186003)(6486002)(508600001)(6512007)(53546011)(6506007)(26005)(316002)(66946007)(8676002)(4326008)(66476007)(83380400001)(66556008)(33656002)(2906002)(36756003)(86362001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGpSb1VMMnhDSmh0N0pwV2VnV3NLWHhsNDlXS0ljK3pLT2RUaUN3T0NSVW5F?=
 =?utf-8?B?YmlYV0pNcnZ5TXVQWEh4emtiUzBoYlB0dENwNW9rRUpCU3V5dFY5MmRxT3U1?=
 =?utf-8?B?cU9mNUZtcjRRTGNaS0QxOWo0NUhnYnNGQlhzbHBwMUt0T0ozeHJoblBnZ2Vv?=
 =?utf-8?B?SE1WQ20wUEFMNGVqMkxjRS93bURpTERsWE96bXpxMUZqM2ZtOVBVZTRYRlA5?=
 =?utf-8?B?blc1d1BRUEV1UnVLS3MyS3E0WnFXSGdtMFYvdWdoeW5SR0JBNWxDM0FVakgw?=
 =?utf-8?B?UksvY29rK01oMGxHUWJoMDdFbDdXMVhUQ0ZaUlNaOUdSLzZBZ0ovak9Ca2Nr?=
 =?utf-8?B?c2sra0FwNE96d1VvZDJmc2lsM2IreE9GeVI0QlFhWEVqdUtPSkJ6VlJpWVpu?=
 =?utf-8?B?ekp5a05EQ3Rsd21tM1Q1SmtiR1NZUDdRS1pDM2FkQkRUd0IwLzlVZE5BSVdq?=
 =?utf-8?B?UmQ2Rno1Z2p4WnpuRW5qTWtEYXB6STNmVDZKa0JGZGhjMzJWY0pCWnVjZ1o0?=
 =?utf-8?B?OVBZMUxYZWxWbHJqaVFwTndjMTF2WFJ3OVNwMWUxNVdPMDExSjBhVjJNeEZq?=
 =?utf-8?B?YTY2bHE4RnV1OWo4VWM5ZExuTCtUTWQyUTJzcTJZSHZFcWovTENuRTBZR2Zj?=
 =?utf-8?B?cUpNQXd6T0ZUSmdiNEZLdWxYK3kxRXZyb2ZjeWdJRmFGOXFpQUFJdmxTbisy?=
 =?utf-8?B?R0x2OUEzSExFL1hRUXYvV0NWaWtXVDMxZXdOUVhFeWQ4R3VxMXhBdWQxbFVw?=
 =?utf-8?B?bG9pMUdITGZwTlVwUzM5Tms1Y29yNkxNZmI3SWVpL1FndzRXS1RXSFBiZXhk?=
 =?utf-8?B?WkZFR205VVhnMFREMFhNYno5REV6eW81ZjNvYUNIbzlmUkM5YkJMckNvRXhU?=
 =?utf-8?B?RUhYc29WemdxdmttR0NlSDNNdXJFZ3IxVFBjMTZjQ0JvamYvSzJHdXAzUnVK?=
 =?utf-8?B?SSswTlVGMjRtSUYxbFdhVWcvd1BrTWw0Qk1vVzh3NUxONEJ2OEd6NnNObkUv?=
 =?utf-8?B?Q0FhaWZTbmdyNDZtSnUwT043Q0daYlNwMXZ4WVBOWlk2bXhUeDZSTXJtWVpj?=
 =?utf-8?B?eWE3UUhTRHdvOVVPT01vY3kwNENxbFVWNElZYnFiYlhSKzkrcXJYWmFaNFAv?=
 =?utf-8?B?SVZvRkdSSit4KzkvWVFsUE45QXBJL0FCK1ZyZlhCR3l2WE9WRVh4b3V4dzIx?=
 =?utf-8?B?bktNeXk0aXZEeHJaZEpxZmVncVpLWDE1Q3BEV0h0dGhaL1cwcVZJYWZwbkE0?=
 =?utf-8?B?Y3E5T3l4NzFCelE2cVlOM3UvY0Z0VXJCaUhKR2dIOTJ6TmJDTU4venl4S0o1?=
 =?utf-8?B?L3RRdURYSG9aNGhCR3k1NmhtREE5QS9SN1FnWUw2L3pnSXhwekdkVXRZU2Mz?=
 =?utf-8?B?MTUyS29FL2dncGpiRVpLTVJQOHhEWWxoSWQ5RHV0OEdRTFBJeFVUaFFzd1Vh?=
 =?utf-8?B?M0lFL2V4eE5KeitmSTNCaXhJanlJQVhpSklra2psVktPVW5RaGRBS3pROFRn?=
 =?utf-8?B?ZTJCL2ROLzRqbHY0RkhNVDV0ajZKM2x3MFU3MTJEZkV6cW1FNnRmc0ZEdlZs?=
 =?utf-8?B?eUY1THhFZnB4bFRtNXlSc0lFRG5KNHhxeTRld1cvK2VQZzBPMEdaZjJkWkxX?=
 =?utf-8?B?U1RDWm5VMXNaM3NHQlNvSERFdWtaVWw3ZmlmeFJuR2hyRmFqUC9ORVZGNUlG?=
 =?utf-8?B?OWdMM25RL0s4RU8rVEJ6L0h2T3AxZUFzQ2E1QWc5ZVpYWlVjMzhQbXFMdC9Q?=
 =?utf-8?B?eVBVa3UrdG5aWkxlL1NDMm4yanI3ZklPWUtOMUNZRWQxRkc2dGRVYTJWTGJW?=
 =?utf-8?B?dVNqeGpIWW1PWWQ1eFVPVXU0YmswUXNvT0YzNzFvWXhYNlAxc3VzWUtUMW5G?=
 =?utf-8?B?MkprZ3l3OEYvK0VRME1pOG5tLzN0M2VhRjh3NWJBTXQ0bEFuVzIxbkx0Z2th?=
 =?utf-8?B?cktkcUVOZisxeHNsVzkraXhPUndJaVgvSFVEZlRvZnNRbzhMek41UzdHYURO?=
 =?utf-8?B?ZlBjRnJTMXFVRGcyTDlZRUpuVlQyUWU1NlRXeGhSUjFsc0l0enZ4blp0akFL?=
 =?utf-8?B?OW5mS1VQblBBRUJJYVY3YkFiTlhSMzY0MnJOaHNyV3FrMFpnUTVGMlpiR3Fx?=
 =?utf-8?B?SVJzUnJMOXQ2ZW9Fd1RUUy84S2NIYkhLU2dKbFBLeDNEb0lxczlnekVGRVds?=
 =?utf-8?B?ZmFYdmNRSGJoN3ZNZWxUejVkTHhaMzNXWnA4Q3BTbGdGbFNEVzd0RUw1QmRv?=
 =?utf-8?B?emN1TWNDUnBvU3JPNlpiUjFKVGtrbS9ma1R1TnBjbjI2aUhnRE4vVU1kdm1H?=
 =?utf-8?B?K1ZFbmQ1c1hEVXRnTFEwNjhFeHVKM3lqcDY0dUJ1T2sxdk1OWXl0Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 020aa98f-292c-4405-4803-08da433dc856
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 19:43:06.3103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 84SwpyaT75gvRc4UGN0UiD+E/zIojJWBtEwawT3FFRuBkomrUcoglzOUd+UjJKHZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3859
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 31, 2022 at 05:44:11PM +0530, Abhishek Sahu wrote:
> On 5/30/2022 5:55 PM, Jason Gunthorpe wrote:
> > On Mon, May 30, 2022 at 04:45:59PM +0530, Abhishek Sahu wrote:
> > 
> >>  1. In real use case, config or any other ioctl should not come along
> >>     with VFIO_DEVICE_FEATURE_POWER_MANAGEMENT ioctl request.
> >>  
> >>  2. Maintain some 'access_count' which will be incremented when we
> >>     do any config space access or ioctl.
> > 
> > Please don't open code locks - if you need a lock then write a proper
> > lock. You can use the 'try' variants to bail out in cases where that
> > is appropriate.
> > 
> > Jason
> 
>  Thanks Jason for providing your inputs.
> 
>  In that case, should I introduce new rw_semaphore (For example
>  power_lock) and move ‘platform_pm_engaged’ under ‘power_lock’ ?

Possibly, this is better than an atomic at least

>  1. At the beginning of config space access or ioctl, we can take the
>     lock
>  
>      down_read(&vdev->power_lock);

You can also do down_read_trylock() here and bail out as you were
suggesting with the atomic.

trylock doesn't have lock odering rules because it can't sleep so it
gives a bit more flexability when designing the lock ordering.

Though userspace has to be able to tolerate the failure, or never make
the request.

>          down_write(&vdev->power_lock);
>          ...
>          switch (vfio_pm.low_power_state) {
>          case VFIO_DEVICE_LOW_POWER_STATE_ENTER:
>                  ...
>                          vfio_pci_zap_and_down_write_memory_lock(vdev);
>                          vdev->power_state_d3 = true;
>                          up_write(&vdev->memory_lock);
> 
>          ...
>          up_write(&vdev->power_lock);

And something checks the power lock before allowing the memor to be
re-enabled?

>  4.  For ioctl access, as mentioned previously I need to add two
>      callbacks functions (one for start and one for end) in the struct
>      vfio_device_ops and call the same at start and end of ioctl from
>      vfio_device_fops_unl_ioctl().

Not sure I followed this..

Jason
