Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E794F7B59C4
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 20:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjJBSH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 14:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjJBSHZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 14:07:25 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E89A7
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 11:07:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNZnlyT00MWprgmEQ8pGtO026xpM+MdsRm5vDGGE+uqQhc/igLiFmMFFaqg06KIAynC0MXsc8/nRXfZjW/tRTkHVdG/FMsT5iFGjN5Wvqxjdy2T/SaaRuaLUFd5rDR1DTBzD4Tcr0IpXw1q/xYweghFMYaS0TXDfsonHHJPSxzuSxIbTRmikXSZiiQYBx19jm+FSAdg6wmhmLuMRuv0Ch6Ek6W+Oy3YgFZ+pFe6VPmrOdfzrUQPoMvAnBT3y0CGznMgGr3ZyPzh+6k0UoKyvRvWachnvFpCsU064QIpJsMHJLScPwxSqEngg2gZdEEiPcJwsHM0/0tglSeYofCcy1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2G1QFvbbNto9iLlOHTiV2oclmRVdlFA2S6UFvqVpF30=;
 b=UqSB0OdYSMjrPOcBJteXavFoy6xaq/Rxw37QfADFoCRMukR/xcgdIwARdUIM2xi8dpU7tv7V8kBeaeefxiiOvq4hUgy7xx+mRrzJNPNsGQr1fJKrHI+0DIOFZbZ52bynMoZ9NXJVihvQXezh8zmbI1UfNhGTEL71cUr9xgi0fw/zSNTlQ4sDUHqqvxrteriAxpUkwJZbLinrA2Jcxv8AjNDnO6MlexkSjnRsqUimmKnl4l8iSbOMTTko8J3TCHEtMmOs+Mdu3woGg/3s1QIcFHkEzwIdjaqm7gjxZHCPbjJBZAU44+Z0aAYQ+gB+gVNXv6VDEPeb0nAwRB2TbCNE+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2G1QFvbbNto9iLlOHTiV2oclmRVdlFA2S6UFvqVpF30=;
 b=uahQerzV2VqVV+FN1hQODUpTiTc2DOf/cGjwv2EZknCgRBNiVaQQH8DtiKtiQppuLHmwF6M6a4EVNLa9qQDvhXApyocytKOHJ63MqzPBOODQkAdfqCITHtSW2wfZoaemTbmgIZfSNBXxPW1XGdKv4gmV/ycN3CEMUTFQXPTTmPtGbFzyvSDcDhaVdcW7T6eb/Cvm/Wc/jBPVY6LChzyds2hWyCmLTUcDkRjJAJr0ViXveWG6U2M3+2+lXMxOvZckpwART/wHYcHopjnTHb3mM1IfhTA35BMLeQBF97SEUaJ9twue1RkgcBY1ri1CxMxEfdjren7PrLLN7HZaKCqRMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6201.namprd12.prod.outlook.com (2603:10b6:930:26::16)
 by MW4PR12MB6780.namprd12.prod.outlook.com (2603:10b6:303:20e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.22; Mon, 2 Oct
 2023 18:07:20 +0000
Received: from CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::8bbf:3b92:2607:4082]) by CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::8bbf:3b92:2607:4082%5]) with mapi id 15.20.6813.017; Mon, 2 Oct 2023
 18:07:20 +0000
Message-ID: <1490617c-9c8e-2de6-41f6-c205cf8a89ea@nvidia.com>
Date:   Mon, 2 Oct 2023 14:07:17 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH vfio 03/11] virtio-pci: Introduce admin virtqueue
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        maorg@nvidia.com, virtualization@lists.linux-foundation.org,
        jgg@nvidia.com, jiri@nvidia.com, leonro@nvidia.com
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-4-yishaih@nvidia.com>
 <20230921095216-mutt-send-email-mst@kernel.org>
 <62df07ea-ddb6-f4ee-f7c3-1400dbe3f0a9@nvidia.com>
 <40f53b6f-f220-af35-0797-e3c60c8c1294@nvidia.com>
 <20230927172553-mutt-send-email-mst@kernel.org>
From:   Feng Liu <feliu@nvidia.com>
In-Reply-To: <20230927172553-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0074.namprd12.prod.outlook.com
 (2603:10b6:802:20::45) To CY5PR12MB6201.namprd12.prod.outlook.com
 (2603:10b6:930:26::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6201:EE_|MW4PR12MB6780:EE_
X-MS-Office365-Filtering-Correlation-Id: c698940f-7e52-411c-fb3c-08dbc3726bc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rOehSBnIAyQjlZ58RTgpYtWuKfrfjaLyosOoNEGKkLa2brEd+InvANNsT6APR7AjpnyL1n+CzJ6xJr2xy6duKT1M/ld6OH1UrLIZ8qPfhsfOGDj0/QRsfE5m4WwU+uz94MB4gHmWwESkLivC5WJrQt8TjdPt2GfRBzIA6ZATU1SQwN83uIOvtpsgMaZmLrkCrPzg32DlSBIoY53rPYhJLXuJeEoyBigjy4++zKKoHIuip7YJLm6OGZpeBFwjbf+9C6iLRQG8/X9p2Tnp2ipXtgKL8VPtfeVI0pfqVqULbte9+0wGH68/i+Mwmn+lQ3zK8WS3iTprRAf1lEM8qfxuUAdyJpIYirZe061Yo3oVZzthB6a6zgWTfyPeFkHxzk3v5MTsHozdTMN1I/AvXUqtZp/JXIZ9YvEOCFLU6yJN3hs9hJpFogz6wBAzhMgRNwh/wch2aBcAEsFroSe70pcVQxstnGKVUC6krzOVc0Ok9v7w/ckBfkGrpscESaUX0pMUPgizY+A2s4i8a62P0vGOWQPgAWUoDsC8+KduHka/PVTk3yTy8UgdHC94QPAyG2yEZkFaKiEtykUeMv2cI7ikmtw7+cSWRMLTRE/zI8RFnZwePOltUrK9j0ub8IfXRM4hB7ve03kmv8efm5YF+g+37z70Zkv/pZQueWz3W2K9rKKnflQlbTuwL2MxS6Qw8gpw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(376002)(396003)(39860400002)(346002)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(478600001)(38100700002)(6666004)(966005)(6506007)(6486002)(66556008)(8936002)(107886003)(2616005)(41300700001)(26005)(66946007)(6916009)(5660300002)(316002)(4326008)(36756003)(31696002)(86362001)(66476007)(6512007)(4744005)(2906002)(8676002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjhibWhKR0QydFE2QnZMUjUrUDQ2MEJuRW9hVzdXMEVVcFBzSis5dTQxYnY4?=
 =?utf-8?B?alp6WUNHNGx4MG1tbVk2UHliNFA2aEUwQ3IyVldDWUdKRk42UEVoc01Ta2lK?=
 =?utf-8?B?bkNIVGFjemNFeEV0RTNWYjRwOVNRRFlRWVhCSXhWQ24vM3E0QXpyamEyL0tX?=
 =?utf-8?B?V2VoMzRUUGx1YXNRZkFEWjlPaUx1aHFFSGYrSW1QM0pBWHc1U1BVTmZxZitj?=
 =?utf-8?B?VlgxMWVDNldyc3B1Ym96Smt0cEFlMmFITmM2Mi9CYXhMbE8zSlkxQ0o2a0dT?=
 =?utf-8?B?YVlWRDAvZ1JvMWxEbm1FcWF1c25MWmVZalczSFJPRjRQNGhkWFpYZkRGZ2xt?=
 =?utf-8?B?S0g5SUhmckpIQmpTQm9PUFQvaFFmWHJ4ZUsxNksxZUpmVDQ1WSt6Q01NM2kw?=
 =?utf-8?B?TEliWm5Db2RtZlZ6S09JbHBOdC9HRG5JVGovbnVBU1pOTHhRVWVCOXl6ZmJh?=
 =?utf-8?B?S2J4NExvUUMzZVhQWUVFYXdPRm4xejNTMXVzeGo5VVIzNjhiRjFqWEI2cEIw?=
 =?utf-8?B?dE5TMmFnaFg4YTRFY0NlenJCcXcwemRLTk01eCtobmJBcXZJWStMamNwMmZB?=
 =?utf-8?B?QW5ZSldadDBGZVEwMGRSMlE0alBZZjkxQjJCNThHSkY5emhRNVBpdUxRTnp2?=
 =?utf-8?B?TWVuNHZ4aXczcUthNURsRTZHRWdpSUFBSFhYRWlQdFNZdzJMMGlZV3QyQmRz?=
 =?utf-8?B?aUpZSjgxTHdlakt6clpieHA3aTQrZGx5UGNoY2MrUllLbjdQMUN4L0VZSXBo?=
 =?utf-8?B?VDd2WW41NGhUU285SFNhY3BpNmZFSnRvYmlza0poOG0wNEJ3OHBoY21rcXhu?=
 =?utf-8?B?K29aZEtwUFJQMDhXS1Z3UG83S3lmR3A2bzJ4b0U0WTN4c0l2b3VvQzl5WGNN?=
 =?utf-8?B?aEpWWjkvLy9Tb3RXZTN1aXpuRExuRjNDQlJjZ3Nwd1NaMjMxSWRCenAwa2Rt?=
 =?utf-8?B?RjVkZjE0d241dFBIZ241RTJjSWd1bmhaWlNoMWM5WDRwWXBpbmcwSG9zRDE5?=
 =?utf-8?B?NEtSWHRWTlM1VUhVSVIxZ3ExelFDZUVDZnRzK3hBckNqYjRBekV6bGREZkIz?=
 =?utf-8?B?K05EQ2FiUS9BMTFFdUhITFE2WU1SK1Z3NUk5VGYybDNNNW1lNEVzdEpLa0gv?=
 =?utf-8?B?MVRYTDRoZVIwTUo3eDVzV09kQWRFVG5lckkycm9DNFpVeXF3U3ZXdXJsYmpS?=
 =?utf-8?B?QWY4VDNDWXluaE82RFQxWXcydHJRd2RVMTFleGdhUHlTcGpndHV5Z3FwWEtI?=
 =?utf-8?B?L0Y2NHQxUVZMNElZSnpYV2ZEV2UwRDhkdE11Y3NNQXpzOWRFSUNNZ1RMRytV?=
 =?utf-8?B?ajlZcUdtNTcyQ2hFSU5xb3BLOWIxL1MyR2RFR29tc2lPMnE3UE1ZWWNqZWIv?=
 =?utf-8?B?SThTVW5pM1RDL0JWeUNPenMvWGVTZ0Fmdy9sdUprakFyaDVyQUNmcS8ydWM4?=
 =?utf-8?B?eGRRT2VRMExoNlZQSmJlV2xkc1pUVktvVGFvOVpWWUJDRzBYSlc4MXQzdzFr?=
 =?utf-8?B?d0ZtenA1eGJhMjdhdHZ4a1Y3Rmx1ZHNhVmlHenBWdmN5VS9MN0xNNDBnSGFk?=
 =?utf-8?B?aUxuQ2R1WEkyM3BVSzU2eFpLNThYdWtNWXROclR0SlBVOW45SFNtNkYyVlhy?=
 =?utf-8?B?TmVNRTZTcDhyOU5walJKcGQyZU11Y1lmOHNBRUpLVVArYnVsSGxIUndXVEha?=
 =?utf-8?B?Qk9BODJJYTIyT2sxS1pHRlRGNXBQTE5GbDJyZWx5S2QzQlF1WmlCNUF3NEF0?=
 =?utf-8?B?MlcraVZtNTFYOEczWVRXV0RhQVRDRERIV3QwcTd1ZE9DUFJWOS9jRFNhTEtM?=
 =?utf-8?B?WEEzMVlabkJtSkQ0UTdQQVFreTI1MmNVUVROakhka0ZuZnBnQWltTkFSWnhS?=
 =?utf-8?B?cnZvT1lMalhWR2VEZTBweXQvaW9xdzVTQnBwVDZQNmV3ZE9kR0Q1YmdsZXd3?=
 =?utf-8?B?RElva3hVSWpCalk0Smx6a1BnMDhuS1VMUXBMcUhyM1JVdnlKaXFUZURpQ0Ni?=
 =?utf-8?B?YWgydnFkSVZpM1JSeFhNeXhjUnZmb0UyOHlQL0hwMzJLZVlXVHZtQjdBRk1y?=
 =?utf-8?B?R0dBMUNXckU5WVd2N1dteXFCMDI3Ykt6WkRGWHVQdm5Lb1A3Ui9yY3hQc1Ex?=
 =?utf-8?Q?usBunU/tCixO1X46s8chGcwGZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c698940f-7e52-411c-fb3c-08dbc3726bc5
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2023 18:07:20.6471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9E861Bu9PTSlwCiItIp6CapD87C2mpzxCJN+2CwU07mDpuY6M9Jzo7I8TBf8GI+rglYqe427geB48vjp/AHs9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6780
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023-09-27 p.m.5:27, Michael S. Tsirkin wrote:

> 
> If an existing device exposes a small
> capability matching old size, then you change size then
> the check will fail on the existing device and driver won't load.
> 
> All this happens way before feature bit checks.
> 
> 
Will do

Thanks
Feng

>>>>>
>>>>>    struct virtio_pci_modern_device {
>>>>> --
>>>>> 2.27.0
>>>>
>>> _______________________________________________
>>> Virtualization mailing list
>>> Virtualization@lists.linux-foundation.org
>>> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
> 
