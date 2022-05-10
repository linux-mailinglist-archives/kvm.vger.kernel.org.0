Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8796452189D
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 15:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbiEJNj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 09:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244774AbiEJNiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 09:38:02 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB655798C;
        Tue, 10 May 2022 06:26:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUPHt0fyZOIca1gIbrotL64nIwpd+lo3UUSD7SdM35h19MUMvGG6bqR4amZgKKLAvB7bmO15hDI9BeDIYWkkRVgEQrq7pTYC3YZkgeWSZOWaw+Yc8gDHfpMHUpH3LgCrkAd0knotKRlEn00Rewa6rcwAwvVfiyZfemNw9jc6hzz4DL+8S5KqXKOR8j1GTX7pFrEQ59xHbsPJLKy2gR+FRgJPBu6fiQsaw59+Ph2vkM6VK4XVUur7mSbaAEq1/AKKtkxGi2Y0hqJSL5M23KZQCvX/GflwRrVc/XQ5HqUuqZQJEDoA+iof8H5U/6V7TCl9hDiajQUx1/8JMbpTytPrHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPOT/ApsF5nmCMAzUtxFNZECTDsfvNF85GbKrw1tfww=;
 b=XZm40YTIWziQJkn2FPwHAYJz7zNijOf+WqrDbltcRYgUVkhon7rygtz+CmfHvlmrkaE9XetxSgQTsOhtRbMJub3i6yIWEYJnFoPPWoIYMrysu39sBUP8mHK+/R+myf/LLKozhE+nQMKBJ/IcwPPt/ZsvYzUZL8CxqitQxwalZM4qV/ZjBj62YDAyoWnd2sj9+ImYlyFpBFZeZh3VQiuOGbtyzyHMFdFGB2GerUGWvGD/Q5S2FG+YGgn3Bjy9YtLt0kq907Ub3BX7BPsyAfxBB33ML2qRcWnkTQF148ogw8gnMIgc6zDoLA5JNS9PZgFONCYoV0+JaqZSJ94lJ09mzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPOT/ApsF5nmCMAzUtxFNZECTDsfvNF85GbKrw1tfww=;
 b=TeSpMF0u/oki4Z+j5Gm7aAbnP/d8fHS1nNegTTvf7UnZ4ZzJf35CKym3pqVHHHn4jcXRfPs4pz4PLNRGWRCEbHbAkxd+Wi9OgzT1ECLOwUV9oHezoLSBnMj+ietGmwdMiWxvKW1NUQSp2Sx4Df2qklmql0ECcVsRBjJ/kYHa1GsAUBuCvb0aWOiXfq5TLy91tTgK1FzoLM5L5QiJ56EXdWsgdnPRGpWM9XRiLHUH58KC/ATjhJUS+IeAWy0CrXxjJOkiMNHNoWC0kYbRGyJSiZNF4/XfswLeJVQp5asLxcVoQfOH+TwhFCvIwSIyhd7HZCv5lK+SsztIhGNHcwqJkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by BL1PR12MB5351.namprd12.prod.outlook.com (2603:10b6:208:317::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 13:26:16 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d%8]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 13:26:16 +0000
Message-ID: <68463d9b-98ee-b9ec-1a3e-1375e50a2ad2@nvidia.com>
Date:   Tue, 10 May 2022 18:56:02 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
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
References: <20220425092615.10133-1-abhsahu@nvidia.com>
 <20220425092615.10133-9-abhsahu@nvidia.com>
 <20220504134551.70d71bf0.alex.williamson@redhat.com>
 <9e44e9cc-a500-ab0d-4785-5ae26874b3eb@nvidia.com>
 <20220509154844.79e4915b.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220509154844.79e4915b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MAXPR0101CA0061.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::23) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a431b97-4f29-4b01-5460-08da3288a904
X-MS-TrafficTypeDiagnostic: BL1PR12MB5351:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5351459FB5531B067DD99CACCCC99@BL1PR12MB5351.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kOYYB2kaSThF5qq2UjaCA588b9qcNGYPCmo3FDdkotLWgNI3FCHQAR3QczLXnYI1xkyvmE8VTT9fBeISqw72eqoKvu3haLEsKFeqE9u0xuFqStd5/cFhf5YwOFLZs8DPkmnSUy6WCjLA0dQEXn/OZoL+4QFOVk4Is4Wlrghtu5UlSy1fRcQbW79dcLOuvCLaYOZJyNdn0PBDtLJuQZH/GqQGVVc32C4F6QWCD5AtVXk5G+c6Eq9K6LK/DjaSpubS/J2ALJZiiufDeonaxSgkomjoUdKB4tEdgPvcf9ZPrhc5aX8WfIt8WLEI1NjB/stqMT87nvJDU0RAXZd03tclJbquHTHcw5oAwbwtpq2/S/BbudtG0YVYcgGFfDvXqWZAqTgAlwGzPb4zusy3fqzmoUpWnI+aipiVesYjlZBoVsYnjU/TMocaKJzk1v5l/soEy4qWz3Pz0qcTpLjbcsPPvr11lECr5DSCHFKj/HnfUXnbOJWpHZuz0jqtLYsAAC16s7YzpFsDgbU8P4YIMA0mc4tuIuSF1MOpf4GxRrpI4xZRyXNdjQFRubaEvwnRfrMOkes6fBy9QusU0HMaJ4s7aojy1Ry6qNnhGH9DN4JN52eZWo2Mqq2N8bAz5aCrxrR8ct7ZvDTeco8sAOl69Gf4ZduM01PAZX8H6whfLbbUovfNkkCJJWjDKzdpg52opKHi45MSNQ1KtpZjsZqMIUrkPAdYrp2FqPLBFhFMYqjC7vKS8rg2LQ3+D8cnatpRWmynD0lSJsoy57PZPSnoiks/Sw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(2616005)(7416002)(54906003)(86362001)(31696002)(38100700002)(2906002)(30864003)(5660300002)(8936002)(6486002)(316002)(8676002)(186003)(77540400001)(6666004)(4326008)(6506007)(508600001)(53546011)(66476007)(66556008)(55236004)(66946007)(6512007)(83380400001)(26005)(31686004)(36756003)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aG5GdXdQMmt5K1Z6bnJzTS9EbCtJWkJ5UXF2cWVJMnhaZW9MeDJ0RXpBblBz?=
 =?utf-8?B?blRsY3cyRVplMkV0VGozdEMzUXdqUml4WXBEQVJPYXFoM0dBTkc2RDNuZGFq?=
 =?utf-8?B?Qk8wbUllYm9LdEdCMUIwczY5dFRpUllDNkFscjNMOGJIaFVFVkNkN2ltRitO?=
 =?utf-8?B?NHJUY3FrdnFkZ2d4M2NSVjBXNllGVkJQZitwZ0x0MFc1R3VqNm1Tcm9FSXE1?=
 =?utf-8?B?L1VyU3JWMU9xUmRoTUhjZ3dRSXNTZDlKc2hlMmo3Z2RSeGxXeFBHMEVvb1h1?=
 =?utf-8?B?M1ZJK0M2Y3ZmQnRGWXZCOGFLYTcycVBhaHVHQys0V3Z1bVhadXFvd2kvRlNn?=
 =?utf-8?B?dWxtWjRmbDhJNW15d3NJV1BxNnJhTmczZk84SnZHbmYrYzJlQ3ZpWEJHR1RT?=
 =?utf-8?B?YmJSbEFCcEdFOVB3SlRqdWFaWUluQWVlYm00TWNuZ3hYTlM1dDREa0lmSk5l?=
 =?utf-8?B?bm8yNEJvUUcrc3hmMG5GbVFJaExEQU9RbnljTmNzbVc3c2NTMDJ2QzFzZlJS?=
 =?utf-8?B?Szc3Z2FySFh1Z1pCR1ZQUW10SVg3WGVqL29tUTNab1NTT1Y0Z25TblZvYVAw?=
 =?utf-8?B?ZzZBNG1wSnZWcWZGL05rR0IxTGJEWjllMFZkNVFYOWdKU1N1YnBUcUFHYWZx?=
 =?utf-8?B?ME5Bc0hHVlFwRzdheDBTd2xHV1NVZTNNTnEzQU9uTHRCTlNJWEZaYnJHN1lI?=
 =?utf-8?B?SVMzZTBFRlgwV2FhVEI5VVU1VVdmUWxHRTRPVkIwRE1CVWpvQ29OZHAvZ3o1?=
 =?utf-8?B?ZGJYZFA5TjdqN2VuTWlBa2NHZW9zSXNkTzYyRENGbWN3NklML1hMTWVWSjh5?=
 =?utf-8?B?bERKWGtQVEpBSHpiK0s2SlFYRzhpei91UHprUk5EYUlWVWNGWGg5S1ROSUlZ?=
 =?utf-8?B?dnZ4by9mV2liM2krZXl5eVUyd2NRdThJTGwrK2hhdFpleGRpNExrd1Fiazg3?=
 =?utf-8?B?MHBValg1TnBCbmQ4V05KYy9VdlZOeElrK2ZRdnNDU1hPdHg5RzBvNHFtb1VI?=
 =?utf-8?B?bXEzYndhV211eTVlMlBJdE9KS0JQSTZLMG9CUVVFUysyYUxaRyszTUozTksw?=
 =?utf-8?B?Ujc0QStNNzhlaWlEYldRcXNaTnJzWGpwcnJPUVRZcm9jcEk2czNGZUdWMUh6?=
 =?utf-8?B?TTdNbUR6aUFmd2YrRERTZ1R5RXI0T0Z6UEZUNnQvMkJZeTg1R1pqNEtnaG45?=
 =?utf-8?B?czkvdjR6L2lPRE5JNTJnUTF2U1J1SWNjZFVDL1lOLzJWUDliK1ZVVm5QT1Nh?=
 =?utf-8?B?OUVoTUo3MElVakw2SkRQTEJsWVlTWXlmZ1p6cUlSUEZHNUUwMmFOYk1ZMFNF?=
 =?utf-8?B?aGYxKzZmVEZRVHJ6RlllNWxiRXQ1NzVZZ0hTMGVTaEJ2ellMaWlMdERnL0FG?=
 =?utf-8?B?T3hsWFd3ZmkwMU50dG1mSEZncGcyWEdEOGFkYjZzUG5CUHdGUFFJanBGOVk3?=
 =?utf-8?B?bUZ0T0E2T1NIYWZwWUwxbG82Yldrcm83YzNYSnNsK3dEUTVXNU1aTERIVVpZ?=
 =?utf-8?B?U3R3d0xxMi9hRDRmK0V6OHBnOXdBdGtJOGZMWHdXQ3l0ZmNzWkFmM3hPUUVs?=
 =?utf-8?B?Z2dhemUyZkNzQndLcjlEOS8vcHR1R0tDSzVnUzFzZDkwRzZCYlpSL2JtaXcy?=
 =?utf-8?B?SWNzV1RWLzA2YnR6WXhMaFlzaExaSE0rU3J6bGp5WnErN3kwcUZDbmhiVTg3?=
 =?utf-8?B?YnpqRnpITEZiSTllbXVMMVRnM1BBempjTlRyL3dnemNsUk1rK2taVzQxSElJ?=
 =?utf-8?B?SzRteVROMzBVMFZ5SG9ETWtkUWxYTExqOHNqQlNrcTcweXNEKzV6bmJaQ1c3?=
 =?utf-8?B?NFZuNUYyMUd0QTg0QSsrSHUxa2ZrZFA2Y1ZjSzliTk1CdHZPMkRlekJXT3RG?=
 =?utf-8?B?VWp0VGZIU2ZYZDdsejVnVEg4TUdMT2txOWZRdXJmNGxoN20ybnV3RE9vSnQx?=
 =?utf-8?B?K3FrbXNJdllZWUFmQWhqU29kNHk0aGgzUmFxRnRJOEgzUktKZGRaQ3E3MG9R?=
 =?utf-8?B?UlhZN3crTktJbkIzcEh5R3p0SVBra0t4U3JvV2ZFekU0eVJrbnhJdzEwNlVC?=
 =?utf-8?B?c1RHNFY2QUtmaW9vYWN2V25NN044L2paWmxoeEpvQ0FkTlV6L2dWZ0RLanpx?=
 =?utf-8?B?bElJWjhBZ1d5dm5TVncxZ1EvT1RVeWhDdzFubE9rNnd5TmpkN2o0OWdpVGR3?=
 =?utf-8?B?TW11NnJSMW4yTWFrZW15Um9IWVRHbSt5dFZZTVZFOTJaNkNyT0J0NS8rVmxo?=
 =?utf-8?B?MkF5c2pYRkEwMGJUUGpzYk5QaFpZSzNUMEZXY3JMallTYnhacU5UelBoWUZC?=
 =?utf-8?B?T2JPY3R2WENlb3lzK0ZTOFBCT3BBVzdDVjZvMUJXVVZ5ajRvZC9XZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a431b97-4f29-4b01-5460-08da3288a904
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 13:26:16.2982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CgjFm+k9ZsqUf7j6UeyJ2Ddrg0khkjrBvha9E/oeodku3WdMc7NznlxpHbBT4RUnH+4iG376PM2vxMCGwhIV0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5351
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/2022 3:18 AM, Alex Williamson wrote:
> On Thu, 5 May 2022 17:46:20 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> On 5/5/2022 1:15 AM, Alex Williamson wrote:
>>> On Mon, 25 Apr 2022 14:56:15 +0530
>>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>>   
>>>> Currently, if the runtime power management is enabled for vfio pci
>>>> based device in the guest OS, then guest OS will do the register
>>>> write for PCI_PM_CTRL register. This write request will be handled in
>>>> vfio_pm_config_write() where it will do the actual register write
>>>> of PCI_PM_CTRL register. With this, the maximum D3hot state can be
>>>> achieved for low power. If we can use the runtime PM framework,
>>>> then we can achieve the D3cold state which will help in saving
>>>> maximum power.
>>>>
>>>> 1. Since D3cold state can't be achieved by writing PCI standard
>>>>    PM config registers, so this patch adds a new feature in the
>>>>    existing VFIO_DEVICE_FEATURE IOCTL. This IOCTL can be used
>>>>    to change the PCI device from D3hot to D3cold state and
>>>>    then D3cold to D0 state. The device feature uses low power term
>>>>    instead of D3cold so that if other vfio driver wants to implement
>>>>    low power support, then the same IOCTL can be used.  
>>>
>>> How does this enable you to handle the full-off vs memory-refresh modes
>>> for NVIDIA GPUs?
>>>   
>>  
>>  Thanks Alex.
>>
>>  This patch series will just enable the full-off for nvidia GPU.
>>  The self-refresh mode won't work.
>>
>>  The self-refresh case is nvidia specific and needs driver
>>  involvement each time before going into d3cold. We are evaluating
>>  internally if we have enough use case for self-refresh mode and then
>>  I will plan separate patch series to support self-refresh mode use
>>  case, if required. But that will be independent of this patch series.
>>
>>  At the high level, we need some way to disable the PCI device access
>>  from the host side or forward the event to VM for every access on the
>>  host side if we want to support NVIDIA self-refresh use case inside VM.
>>  Otherwise, from the driver side, we can disable self-refresh mode if
>>  driver is running inside VM. In that case, if memory usage is higher than
>>  threshold then we don’t engage RTD3 itself. 
> 
> Disabling PCI access on the host seems impractical to me, but PM and
> PCI folks are welcome to weigh in.
> 
> We've also discussed that the GPU memory could exceed RAM + swap for a
> VM, leaving them with no practical means to make use of d3cold if we
> don't support this capability.  Also, existing drivers expect to have
> this capability and it's not uncommon for those in the gaming community
> making use of GPU assignment to attempt to hide the fact that they're
> running in a VM to avoid falsely triggering anti-cheat detection, DRM,
> or working around certain GPU vendors who previously restricted use of
> consumer GPUs in VMs.
> 
> That seems to suggest to me that our only option is along the lines of
> notifying the VM when the device returns to D0 and by default only
> re-entering d3cold under the direction of the VM.  We might also do some
> sort of negotiation based on device vendor and class code where we
> could enable the kernel to perform the transition back to d3cold.
> There's a fair chance that an AMD GPU might have similar requirements,
> do we know if they do?
> 

 That SW involvement before going into D3cold can be possible for
 other devices as well although I am not sure about the current
 AMD GPU implementation. For NVIDIA GPU, the firmware running on the
 GPU listens for PME_turn_Off and then do the handling for self-refresh.
 For other devices also, if they have firmware involvement before
 D3cold entry then the similar issue can come there also.

> I'd suggest perhaps splitting this patch series so that we can start
> taking advantage of using d3cold for idle devices while we figure out
> how to make use of VM directed d3cold without creating scenarios that
> don't break existing drivers.
>  

 Sure. I can make this patch series and will move the last 3
 patches in separate patch series along with the VM notification
 support for the wake-up triggered by host.

>>> The feature ioctl supports a probe, but here the probe only indicates
>>> that the ioctl is available, not what degree of low power support
>>> available.  Even if the host doesn't support d3cold for the device, we
>>> can still achieve root port d3hot, but can we provide further
>>> capability info to the user?
>>>  
>>
>>  I wanted to add more information here but was not sure which
>>  information will be helpful for user. There is no certain way to
>>  predict that the runtime suspend will use D3cold state only even
>>  on the supported systems. User can disable runtime power management from 
>>
>>  /sys/bus/pci/devices/…/power/control
>>
>>  Or disable d3cold itself 
>>
>>  /sys/bus/pci/devices/…/d3cold_allowed
>>
>>
>>  Even if all these are allowed, then platform_pci_choose_state()
>>  is the main function where the target low power state is selected
>>  in runtime.
>>
>>  Probably we can add pci_pr3_present() status to user which gives
>>  hint to user that required ACPI methods for d3cold is present in
>>  the platform. 
> 
> I expected that might be the answer.  The proposed interface name also
> avoids tying us directly to an ACPI implementation, so I imagine there
> could be a variety of backends supporting runtime power management in
> the host kernel.
> 
> In the VM I think the ACPI controls are at the root port, so we
> probably need to add power control to each root port regardless of what
> happens to be plugged into it at the time.  Maybe that means we can't
> really take advantage of knowing the degree of device support, we just
> need to wire it up as if it works regardless.
> 

 In the host side ACPI, the power resources will be mostly associated
 with root port but from the ACPI specification side, the power resources
 can be associated with the device itself. In the guest side,
 we need to do virtual implementation so either it can be associated
 with virtual root port or from the device itself.

 But with that also, the host level degree of support information
 won’t help much.

> We might also want to consider parallels to device hotplug here.  For
> example, if QEMU could know that a device does not retain state in
> d3cold, it might choose to unplug the device backend so that the device
> could be used elsewhere in the interim, or simply use the idle device
> handling for d3cold in vfio-pci.  That opens up a lot of questions
> regarding SLA contracts with management tools to be able to replace the
> device with a fungible substitute on demand, but I can imagine data
> center logistics might rather have that problem than VMs sitting on
> powered-off devices.
> 
>>>> 2. The hypervisors can implement virtual ACPI methods. For
>>>>    example, in guest linux OS if PCI device ACPI node has _PR3 and _PR0
>>>>    power resources with _ON/_OFF method, then guest linux OS makes the
>>>>    _OFF call during D3cold transition and then _ON during D0 transition.
>>>>    The hypervisor can tap these virtual ACPI calls and then do the D3cold
>>>>    related IOCTL in the vfio driver.
>>>>
>>>> 3. The vfio driver uses runtime PM framework to achieve the
>>>>    D3cold state. For the D3cold transition, decrement the usage count and
>>>>    for the D0 transition, increment the usage count.
>>>>
>>>> 4. For D3cold, the device current power state should be D3hot.
>>>>    Then during runtime suspend, the pci_platform_power_transition() is
>>>>    required for D3cold state. If the D3cold state is not supported, then
>>>>    the device will still be in D3hot state. But with the runtime PM, the
>>>>    root port can now also go into suspended state.  
>>>
>>> Why do we create this requirement for the device to be in d3hot prior
>>> to entering low power   
>>
>>  This is mainly to make integration in the hypervisor with
>>  the PCI power management code flow.
>>
>>  If we see the power management steps, then following 2 steps
>>  are involved 
>>
>>  1. First move the device from D0 to D3hot state by writing
>>     into config register.
>>  2. Then invoke ACPI routines (mainly _PR3 OFF method) to
>>     move from D3hot to D3cold.
>>
>>  So, in the guest side, we can follow the same steps. The guest can
>>  do the config register write and then for step 2, the hypervisor
>>  can implement the virtual ACPI with _PR3/_PR0 power resources.
>>  Inside this virtual ACPI implementation, the hypervisor can invoke
>>  the power management IOCTL.
>>
>>  Also, if runtime PM has been disabled from the host side,
>>  then also the device will be in d3hot state. 
> 
> That's true regardless of us making it a requirement.  I don't see what
> it buys us to make this a requirement though.  If I trigger the _PR3
> method on bare metal, does ACPI care if the device is in D3hot first?
> At best that seems dependent on the ACPI implementation.
>

 Yes. That depends upon the ACPI implementation. 

>>> when our pm ops suspend function wakes the device do d0?  
>>
>>  The changing to D0 here is happening due to 2 reasons here,
>>
>>  1. First to preserve device state for the NoSoftRst-.
>>  2. To make use of PCI core layer generic code for runtime suspend,
>>     otherwise we need to do all handling here which is present in
>>     pci_pm_runtime_suspend().
> 
> What problem do we cause if we allow the user to trigger this ioctl
> from D0?  The restriction follows the expected use case, but otherwise
> imposing the restriction is arbitrary.
> 

 It seems then we can remove this restriction. It should be fine
 if user triggers this IOCTL from D0 and then the runtime power
 management itself will take care of device state itself.

>  
>>>> 5. For most of the systems, the D3cold is supported at the root
>>>>    port level. So, when root port will transition to D3cold state, then
>>>>    the vfio PCI device will go from D3hot to D3cold state during its
>>>>    runtime suspend. If root port does not support D3cold, then the root
>>>>    will go into D3hot state.
>>>>
>>>> 6. The runtime suspend callback can now happen for 2 cases: there
>>>>    are no users of vfio device and the case where user has initiated
>>>>    D3cold. The 'platform_pm_engaged' flag can help to distinguish
>>>>    between these 2 cases.  
>>>
>>> If this were the only use case we could rely on vfio_device.open_count
>>> instead.  I don't think it is though.    
>>
>>  platform_pm_engaged is mainly to track the user initiated
>>  low power entry with the IOCTL. So even if we use vfio_device.open_count
>>  here, we will still require platform_pm_engaged.
>>
>>>> 7. In D3cold, all kind of BAR related access needs to be disabled
>>>>    like D3hot. Additionally, the config space will also be disabled in
>>>>    D3cold state. To prevent access of config space in D3cold state, do
>>>>    increment the runtime PM usage count before doing any config space
>>>>    access.  
>>>
>>> Or we could actually prevent access to config space rather than waking
>>> the device for the access.  Addressed in further comment below.
>>>    
>>>> 8. If user has engaged low power entry through IOCTL, then user should
>>>>    do low power exit first. The user can issue config access or IOCTL
>>>>    after low power entry. We can add an explicit error check but since
>>>>    we are already waking-up device, so IOCTL and config access can be
>>>>    fulfilled. But 'power_state_d3' won't be cleared without issuing
>>>>    low power exit so all BAR related access will still return error till
>>>>    user do low power exit.  
>>>
>>> The fact that power_state_d3 no longer tracks the device power state
>>> when platform_pm_engaged is set is a confusing discontinuity.
>>>   
>>
>>  If we refer the power management steps (as mentioned in the above),
>>  then these 2 variable tracks different things.
>>
>>  1. power_state_d3 tracks the config space write.  
>>  2. platform_pm_engaged tracks the IOCTL call. In the IOCTL, we decrement
>>     the runtime usage count so we need to track that we have decremented
>>     it. 
>>
>>>> 9. Since multiple layers are involved, so following is the high level
>>>>    code flow for D3cold entry and exit.
>>>>
>>>> D3cold entry:
>>>>
>>>> a. User put the PCI device into D3hot by writing into standard config
>>>>    register (vfio_pm_config_write() -> vfio_lock_and_set_power_state() ->
>>>>    vfio_pci_set_power_state()). The device power state will be D3hot and
>>>>    power_state_d3 will be true.
>>>> b. Set vfio_device_feature_power_management::low_power_state =
>>>>    VFIO_DEVICE_LOW_POWER_STATE_ENTER and call VFIO_DEVICE_FEATURE IOCTL.
>>>> c. Inside vfio_device_fops_unl_ioctl(), pm_runtime_resume_and_get()
>>>>    will be called first which will make the usage count as 2 and then
>>>>    vfio_pci_core_ioctl_feature() will be invoked.
>>>> d. vfio_pci_core_feature_pm() will be called and it will go inside
>>>>    VFIO_DEVICE_LOW_POWER_STATE_ENTER switch case. platform_pm_engaged will
>>>>    be true and pm_runtime_put_noidle() will decrement the usage count
>>>>    to 1.
>>>> e. Inside vfio_device_fops_unl_ioctl() while returning the
>>>>    pm_runtime_put() will make the usage count to 0 and the runtime PM
>>>>    framework will engage the runtime suspend entry.
>>>> f. pci_pm_runtime_suspend() will be called and invokes driver runtime
>>>>    suspend callback.
>>>> g. vfio_pci_core_runtime_suspend() will change the power state to D0
>>>>    and do the INTx mask related handling.
>>>> h. pci_pm_runtime_suspend() will take care of saving the PCI state and
>>>>    all power management handling for D3cold.
>>>>
>>>> D3cold exit:
>>>>
>>>> a. Set vfio_device_feature_power_management::low_power_state =
>>>>    VFIO_DEVICE_LOW_POWER_STATE_EXIT and call VFIO_DEVICE_FEATURE IOCTL.
>>>> b. Inside vfio_device_fops_unl_ioctl(), pm_runtime_resume_and_get()
>>>>    will be called first which will make the usage count as 1.
>>>> c. pci_pm_runtime_resume() will take care of moving the device into D0
>>>>    state again and then vfio_pci_core_runtime_resume() will be called.
>>>> d. vfio_pci_core_runtime_resume() will do the INTx unmask related
>>>>    handling.
>>>> e. vfio_pci_core_ioctl_feature() will be invoked.
>>>> f. vfio_pci_core_feature_pm() will be called and it will go inside
>>>>    VFIO_DEVICE_LOW_POWER_STATE_EXIT switch case. platform_pm_engaged and
>>>>    power_state_d3 will be cleared and pm_runtime_get_noresume() will make
>>>>    the usage count as 2.
>>>> g. Inside vfio_device_fops_unl_ioctl() while returning the
>>>>    pm_runtime_put() will make the usage count to 1 and the device will
>>>>    be in D0 state only.
>>>>
>>>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>>>> ---
>>>>  drivers/vfio/pci/vfio_pci_config.c |  11 ++-
>>>>  drivers/vfio/pci/vfio_pci_core.c   | 131 ++++++++++++++++++++++++++++-
>>>>  include/linux/vfio_pci_core.h      |   1 +
>>>>  include/uapi/linux/vfio.h          |  18 ++++
>>>>  4 files changed, 159 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
>>>> index af0ae80ef324..65b1bc9586ab 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_config.c
>>>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>>>> @@ -25,6 +25,7 @@
>>>>  #include <linux/uaccess.h>
>>>>  #include <linux/vfio.h>
>>>>  #include <linux/slab.h>
>>>> +#include <linux/pm_runtime.h>
>>>>  
>>>>  #include <linux/vfio_pci_core.h>
>>>>  
>>>> @@ -1936,16 +1937,23 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>>>>  ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>>>>  			   size_t count, loff_t *ppos, bool iswrite)
>>>>  {
>>>> +	struct device *dev = &vdev->pdev->dev;
>>>>  	size_t done = 0;
>>>>  	int ret = 0;
>>>>  	loff_t pos = *ppos;
>>>>  
>>>>  	pos &= VFIO_PCI_OFFSET_MASK;
>>>>  
>>>> +	ret = pm_runtime_resume_and_get(dev);
>>>> +	if (ret < 0)
>>>> +		return ret;  
>>>
>>> Alternatively we could just check platform_pm_engaged here and return
>>> -EINVAL, right?  Why is waking the device the better option?
>>>   
>>
>>  This is mainly to prevent race condition where config space access
>>  happens parallelly with IOCTL access. So, lets consider the following case.
>>
>>  1. Config space access happens and vfio_pci_config_rw() will be called.
>>  2. The IOCTL to move into low power state is called.
>>  3. The IOCTL will move the device into d3cold.
>>  4. Exit from vfio_pci_config_rw() happened.
>>
>>  Now, if we just check platform_pm_engaged, then in the above
>>  sequence it won’t work. I checked this parallel access by writing
>>  a small program where I opened the 2 instances and then
>>  created 2 threads for config space and IOCTL.
>>  In my case, I got the above sequence.
>>
>>  The pm_runtime_resume_and_get() will make sure that device
>>  usage count keep incremented throughout the config space
>>  access (or IOCTL access in the previous patch) and the
>>  runtime PM framework will not move the device into suspended
>>  state.
> 
> I think we're inventing problems here.  If we define that config space
> is not accessible while the device is in low power and the only way to
> get the device out of low power is via ioctl, then we should be denying
> access to the device while in low power.  If the user races exiting the
> device from low power and a config space access, that's their problem.
> 

 But what about malicious user who intentionally tries to create
 this sequence. If the platform_pm_engaged check passed and
 then user put the device into low power state. In that case,
 there may be chances where config read happens while the device
 is in low power state.

 Can we prevent this concurrent access somehow or make sure
 that nothing else is running when the low power ioctl runs?

>>>> +
>>>>  	while (count) {
>>>>  		ret = vfio_config_do_rw(vdev, buf, count, &pos, iswrite);
>>>> -		if (ret < 0)
>>>> +		if (ret < 0) {
>>>> +			pm_runtime_put(dev);
>>>>  			return ret;
>>>> +		}
>>>>  
>>>>  		count -= ret;
>>>>  		done += ret;
>>>> @@ -1953,6 +1961,7 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>>>>  		pos += ret;
>>>>  	}
>>>>  
>>>> +	pm_runtime_put(dev);
>>>>  	*ppos += done;
>>>>  
>>>>  	return done;
>>>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>>>> index 05a68ca9d9e7..beac6e05f97f 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_core.c
>>>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>>>> @@ -234,7 +234,14 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>>>>  	ret = pci_set_power_state(pdev, state);
>>>>  
>>>>  	if (!ret) {
>>>> -		vdev->power_state_d3 = (pdev->current_state >= PCI_D3hot);
>>>> +		/*
>>>> +		 * If 'platform_pm_engaged' is true then 'power_state_d3' can
>>>> +		 * be cleared only when user makes the explicit request to
>>>> +		 * move out of low power state by using power management ioctl.
>>>> +		 */
>>>> +		if (!vdev->platform_pm_engaged)
>>>> +			vdev->power_state_d3 =
>>>> +				(pdev->current_state >= PCI_D3hot);  
>>>
>>> power_state_d3 is essentially only used as a secondary test to
>>> __vfio_pci_memory_enabled() to block r/w access to device regions and
>>> generate a fault on mmap access.  Its existence already seems a little
>>> questionable when we could just look at vdev->pdev->current_state, and
>>> we could incorporate that into __vfio_pci_memory_enabled().  So rather
>>> than creating this inconsistency, couldn't we just make that function
>>> return:
>>>
>>> !vdev->platform_pm_enagaged && pdev->current_state < PCI_D3hot &&
>>> (pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY))
>>>   
>>
>>  The main reason for power_state_d3 is to get it under
>>  memory_lock semaphore. But pdev->current_state is not
>>  protected with any lock. So, will use of pdev->current_state
>>  here be safe?
> 
> If we're only testing and modifying pdev->current_state under
> memory_lock, isn't it equivalent?
>

 pdev->current_state can be modified by PCI runtime PM core
 layer itself like when user invokes lspci, config dump command
 but in that case, platform_pm_enagaged should block this access.
 While for config space writes, the PM core layer code should not
 touch the pdev->current_state. So, yes we can use pdev->current_state.
 I will make this change and update the other patch in this series.

>>>>  
>>>>  		/* D3 might be unsupported via quirk, skip unless in D3 */
>>>>  		if (needs_save && pdev->current_state >= PCI_D3hot) {
>>>> @@ -266,6 +273,25 @@ static int vfio_pci_core_runtime_suspend(struct device *dev)
>>>>  {
>>>>  	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
>>>>  
>>>> +	down_read(&vdev->memory_lock);
>>>> +
>>>> +	/* 'platform_pm_engaged' will be false if there are no users. */
>>>> +	if (!vdev->platform_pm_engaged) {
>>>> +		up_read(&vdev->memory_lock);
>>>> +		return 0;
>>>> +	}
>>>> +
>>>> +	/*
>>>> +	 * The user will move the device into D3hot state first before invoking
>>>> +	 * power management ioctl. Move the device into D0 state here and then
>>>> +	 * the pci-driver core runtime PM suspend will move the device into
>>>> +	 * low power state. Also, for the devices which have NoSoftRst-,
>>>> +	 * it will help in restoring the original state (saved locally in
>>>> +	 * 'vdev->pm_save').
>>>> +	 */
>>>> +	vfio_pci_set_power_state(vdev, PCI_D0);
>>>> +	up_read(&vdev->memory_lock);
>>>> +
>>>>  	/*
>>>>  	 * If INTx is enabled, then mask INTx before going into runtime
>>>>  	 * suspended state and unmask the same in the runtime resume.
>>>> @@ -395,6 +421,19 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>>>>  
>>>>  	/*
>>>>  	 * This function can be invoked while the power state is non-D0.
>>>> +	 * This non-D0 power state can be with or without runtime PM.
>>>> +	 * Increment the usage count corresponding to pm_runtime_put()
>>>> +	 * called during setting of 'platform_pm_engaged'. The device will
>>>> +	 * wake up if it has already went into suspended state. Otherwise,
>>>> +	 * the next vfio_pci_set_power_state() will change the
>>>> +	 * device power state to D0.
>>>> +	 */
>>>> +	if (vdev->platform_pm_engaged) {
>>>> +		pm_runtime_resume_and_get(&pdev->dev);
>>>> +		vdev->platform_pm_engaged = false;
>>>> +	}
>>>> +
>>>> +	/*
>>>>  	 * This function calls __pci_reset_function_locked() which internally
>>>>  	 * can use pci_pm_reset() for the function reset. pci_pm_reset() will
>>>>  	 * fail if the power state is non-D0. Also, for the devices which
>>>> @@ -1192,6 +1231,80 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
>>>>  
>>>> +#ifdef CONFIG_PM
>>>> +static int vfio_pci_core_feature_pm(struct vfio_device *device, u32 flags,
>>>> +				    void __user *arg, size_t argsz)
>>>> +{
>>>> +	struct vfio_pci_core_device *vdev =
>>>> +		container_of(device, struct vfio_pci_core_device, vdev);
>>>> +	struct pci_dev *pdev = vdev->pdev;
>>>> +	struct vfio_device_feature_power_management vfio_pm = { 0 };
>>>> +	int ret = 0;
>>>> +
>>>> +	ret = vfio_check_feature(flags, argsz,
>>>> +				 VFIO_DEVICE_FEATURE_SET |
>>>> +				 VFIO_DEVICE_FEATURE_GET,
>>>> +				 sizeof(vfio_pm));
>>>> +	if (ret != 1)
>>>> +		return ret;
>>>> +
>>>> +	if (flags & VFIO_DEVICE_FEATURE_GET) {
>>>> +		down_read(&vdev->memory_lock);
>>>> +		vfio_pm.low_power_state = vdev->platform_pm_engaged ?
>>>> +				VFIO_DEVICE_LOW_POWER_STATE_ENTER :
>>>> +				VFIO_DEVICE_LOW_POWER_STATE_EXIT;
>>>> +		up_read(&vdev->memory_lock);
>>>> +		if (copy_to_user(arg, &vfio_pm, sizeof(vfio_pm)))
>>>> +			return -EFAULT;
>>>> +		return 0;
>>>> +	}
>>>> +
>>>> +	if (copy_from_user(&vfio_pm, arg, sizeof(vfio_pm)))
>>>> +		return -EFAULT;
>>>> +
>>>> +	/*
>>>> +	 * The vdev power related fields are protected with memory_lock
>>>> +	 * semaphore.
>>>> +	 */
>>>> +	down_write(&vdev->memory_lock);
>>>> +	switch (vfio_pm.low_power_state) {
>>>> +	case VFIO_DEVICE_LOW_POWER_STATE_ENTER:
>>>> +		if (!vdev->power_state_d3 || vdev->platform_pm_engaged) {
>>>> +			ret = EINVAL;
>>>> +			break;
>>>> +		}
>>>> +
>>>> +		vdev->platform_pm_engaged = true;
>>>> +
>>>> +		/*
>>>> +		 * The pm_runtime_put() will be called again while returning
>>>> +		 * from ioctl after which the device can go into runtime
>>>> +		 * suspended.
>>>> +		 */
>>>> +		pm_runtime_put_noidle(&pdev->dev);
>>>> +		break;
>>>> +
>>>> +	case VFIO_DEVICE_LOW_POWER_STATE_EXIT:
>>>> +		if (!vdev->platform_pm_engaged) {
>>>> +			ret = EINVAL;
>>>> +			break;
>>>> +		}
>>>> +
>>>> +		vdev->platform_pm_engaged = false;
>>>> +		vdev->power_state_d3 = false;
>>>> +		pm_runtime_get_noresume(&pdev->dev);
>>>> +		break;
>>>> +
>>>> +	default:
>>>> +		ret = EINVAL;
>>>> +		break;
>>>> +	}
>>>> +
>>>> +	up_write(&vdev->memory_lock);
>>>> +	return ret;
>>>> +}
>>>> +#endif
>>>> +
>>>>  static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
>>>>  				       void __user *arg, size_t argsz)
>>>>  {
>>>> @@ -1226,6 +1339,10 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
>>>>  	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
>>>>  	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
>>>>  		return vfio_pci_core_feature_token(device, flags, arg, argsz);
>>>> +#ifdef CONFIG_PM
>>>> +	case VFIO_DEVICE_FEATURE_POWER_MANAGEMENT:
>>>> +		return vfio_pci_core_feature_pm(device, flags, arg, argsz);
>>>> +#endif
>>>>  	default:
>>>>  		return -ENOTTY;
>>>>  	}
>>>> @@ -2189,6 +2306,15 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>>>  		goto err_unlock;
>>>>  	}
>>>>  
>>>> +	/*
>>>> +	 * Some of the devices in the dev_set can be in the runtime suspended
>>>> +	 * state. Increment the usage count for all the devices in the dev_set
>>>> +	 * before reset and decrement the same after reset.
>>>> +	 */
>>>> +	ret = vfio_pci_dev_set_pm_runtime_get(dev_set);
>>>> +	if (ret)
>>>> +		goto err_unlock;
>>>> +
>>>>  	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
>>>>  		/*
>>>>  		 * Test whether all the affected devices are contained by the
>>>> @@ -2244,6 +2370,9 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>>>  		else
>>>>  			mutex_unlock(&cur->vma_lock);
>>>>  	}
>>>> +
>>>> +	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
>>>> +		pm_runtime_put(&cur->pdev->dev);
>>>>  err_unlock:
>>>>  	mutex_unlock(&dev_set->lock);
>>>>  	return ret;
>>>> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
>>>> index e84f31e44238..337983a877d6 100644
>>>> --- a/include/linux/vfio_pci_core.h
>>>> +++ b/include/linux/vfio_pci_core.h
>>>> @@ -126,6 +126,7 @@ struct vfio_pci_core_device {
>>>>  	bool			needs_pm_restore;
>>>>  	bool			power_state_d3;
>>>>  	bool			pm_intx_masked;
>>>> +	bool			platform_pm_engaged;
>>>>  	struct pci_saved_state	*pci_saved_state;
>>>>  	struct pci_saved_state	*pm_save;
>>>>  	int			ioeventfds_nr;
>>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>>> index fea86061b44e..53ff890dbd27 100644
>>>> --- a/include/uapi/linux/vfio.h
>>>> +++ b/include/uapi/linux/vfio.h
>>>> @@ -986,6 +986,24 @@ enum vfio_device_mig_state {
>>>>  	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>>>>  };
>>>>  
>>>> +/*
>>>> + * Use platform-based power management for moving the device into low power
>>>> + * state.  This low power state is device specific.
>>>> + *
>>>> + * For PCI, this low power state is D3cold.  The native PCI power management
>>>> + * does not support the D3cold power state.  For moving the device into D3cold
>>>> + * state, change the PCI state to D3hot with standard configuration registers
>>>> + * and then call this IOCTL to setting the D3cold state.  Similarly, if the
>>>> + * device in D3cold state, then call this IOCTL to exit from D3cold state.
>>>> + */
>>>> +struct vfio_device_feature_power_management {
>>>> +#define VFIO_DEVICE_LOW_POWER_STATE_EXIT	0x0
>>>> +#define VFIO_DEVICE_LOW_POWER_STATE_ENTER	0x1
>>>> +	__u64	low_power_state;
>>>> +};
>>>> +
>>>> +#define VFIO_DEVICE_FEATURE_POWER_MANAGEMENT	3  
>>>
>>> __u8 seems more than sufficient here.  Thanks,
>>>
>>> Alex
>>>  
>>
>>  I have used __u64 mainly to get this structure 64 bit aligned.
>>  I was impression that the ioctl structure should be 64 bit aligned
>>  but in this case since we will have just have __u8 member so
>>  alignment should not be required?
> 
> We can add a directive to enforce an alignment regardless of the field
> size.  I believe the feature ioctl header is already going to be eight
> byte aligned, so it's probably not strictly necessary, but Jason seems
> to be adding more of these directives elsewhere, so probably a good
> idea regardless.  Thanks,
> 
> Alex
> 

So, should I change it like

__u8    low_power_state __attribute__((aligned(8)));

 Or

__aligned_u64 low_power_state

In the existing code, there are very few references for the
first one.

Thanks,
Abhishek
