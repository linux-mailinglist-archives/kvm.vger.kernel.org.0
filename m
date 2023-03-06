Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6276ABD25
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 11:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjCFKoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 05:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjCFKoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 05:44:17 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10hn2214.outbound.protection.outlook.com [52.100.156.214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AA51C5BE
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 02:44:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asMrC83KWKxHSbZGsPITgxS5Rh78INcvUuFYVBD3QpyO3egpAcHphKGN5TSZOaja+0OsTRqiasevHQktZYBlfi9Cvpiwv6SKhLGEyqNysgnz0kzq5S+Q37sIT9lllO+kN0IRc8yAphbpwGkSVBfW+LgxhFnsDXgkia/S4zgbrKuZteUQ/rMYlTCWFf5BB+SnOD7Hm+SWSTox1Thq7UJ+Ke0NpbseDETM114kUh+xCZBeBpu4o9MmVFmFYOV1MVlgMgt97ysnQFX77DoobQQoLOGVPeCZv0h7l2ZJ2n8OodF5/IkOOa/ctbLfk0XCRrrGnDqCrFLFOGkCf54idy6IIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uJVEegsWgk1p6ZRf+hO9Q0YfM/yh1K6NI5nzG+so51Q=;
 b=IjGBPmLN+tsnrUTnro4bOCWAO/eLTTpKc0TiBoNOrT5ZJeWY3j+UYPYQpVRfEnWiUIW7iZe1Ak7GQX2NvAxmlmFwb+eItJM/NkYg6Fxrp1zbzHhDTOLIuH0mqWJsZiF9VzF54/ilIjCzExoCrw0rkJvtwVgIWlRSmJwFTe+cLw/aMfYHsb9xOQKgq+JVE7YRq2k0j2VxcpBQgdmmzT4woYo2ovRFBLbvfobwytM8/GUdpztOuJpMyZKhH2eVT0BgefdWsLcEKZ5IQp0Jm9odm8dpQ2kIMcLPvx0Tghw5vN6MdxXcn2x1LBTAWnd4af5Hl9d2cTPpNwbVvdnKGPVCxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uJVEegsWgk1p6ZRf+hO9Q0YfM/yh1K6NI5nzG+so51Q=;
 b=BtxocbMYbsHxkLxp6aYxrMuiZvfAVWe87F87tJnC/hyaN58iNd4cfyJ89Mn0DmRUcztfSeh4MJzhKQltgpEYr4W5ZpxA0sWIhrWfbZjV5ext0kf4jj3Fy/fEcvOaYeSQBUF0mKgOVWVmSRj22jLlUiKE02CTC0ZmCeBn7Qm0wdI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 IA1PR12MB6019.namprd12.prod.outlook.com (2603:10b6:208:3d5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 10:44:09 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3%7]) with mapi id 15.20.6156.019; Mon, 6 Mar 2023
 10:44:09 +0000
Message-ID: <c40ec6aa-1e89-866f-14ee-dd5b067ce001@amd.com>
Date:   Mon, 6 Mar 2023 21:44:00 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 4/5] powerpc/iommu: Add iommu_ops to report capabilities
 and
To:     Timothy Pearson <tpearson@raptorengineering.com>,
        kvm <kvm@vger.kernel.org>
References: <41528182.16281476.1677879021033.JavaMail.zimbra@raptorengineeringinc.com>
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@amd.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>
In-Reply-To: <41528182.16281476.1677879021033.JavaMail.zimbra@raptorengineeringinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYBPR01CA0020.ausprd01.prod.outlook.com (2603:10c6:10::32)
 To DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|IA1PR12MB6019:EE_
X-MS-Office365-Filtering-Correlation-Id: b3168ef8-1966-4092-b274-08db1e2fb762
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SUFzZytmZ3lsKy9jSHZtU0RKUTBtSS9BVXRkVWtCMEprL0EzMFRydzJqY3NU?=
 =?utf-8?B?RGN3ME92cGlaOUZuM2xsTnBpZUc5WUlROGw3clY2cEh5bFA0Q3hRVWtTS2xO?=
 =?utf-8?B?QUlESmNWZm1TdGlkMExVMml5eGFLTEhwRTNiZnp6SnNJdXNlOW1rMldNNVJK?=
 =?utf-8?B?UG85cFUwbS9UdHNpdkJaZGgydjJvanVqbTV6cWhzZFZTSFpYWk5DWDhLRlNs?=
 =?utf-8?B?WnV6clJzejN3ZDdHeXY1TERtVFUzb2FUdHVYL0dyMkp2SklvKy9WbitpNnN6?=
 =?utf-8?B?SklkU2llWkd6OGVmTVUrbWhyNXdnSDNhcitYNVFEMTlleXZXSWhERUpGL25k?=
 =?utf-8?B?enRCRTNJUFoyRnI2eDRiSTFWSHdmSzJnWW55UWlOMHhncmNUeFBOeThGRFRV?=
 =?utf-8?B?TWtjaS9ZcW1JMnFmcTJhL2tsdWd4L21PUndHdVhOVmFpTnhXR1p6WVRwaVdZ?=
 =?utf-8?B?UldLMVk4cUd3MlA4RFVmNEhML0lHZGg2c2xEVGh3azFrTXNqSHBBcm9iWjVM?=
 =?utf-8?B?dUpzVFJtVnJjZFptZm5qaU1SQkE2VHUyR0RYWDlPckZielpiZUdJQ1FwQi81?=
 =?utf-8?B?ZFZUcjdwNFdRZU0zVmYyU1R0OUVVVjl4aU9FZDZ0RDFTdHhzN3JFd2RtL1dF?=
 =?utf-8?B?ZDN2ME80aHNSTVBMSlJCYk1rYTI0NjBZSVEyVDZ3OGcwM25OeTZiTUlIMUx1?=
 =?utf-8?B?M1dDd3czUWZoWmhIMm9xWnNHWnljQW1iSm9EN3VDbVRZdmJaWFY4VnJ3bHhS?=
 =?utf-8?B?V3o5RXAzdkhhak43eVJhYU1FY25tYWI4OS9rUWtWMHREaVZmNlNyRDVZQjJi?=
 =?utf-8?B?Ty9zVmVyN0ZBWGJpOGFKVElLZlFZYWJuYms3NFdXdHBMM2hpNTA0Zkt0a1JK?=
 =?utf-8?B?TGhReTl6eHE2U3VJQjRWbkw1ZGRNYUtXOEZFeXJyU2xlcFZBWG5taDErWUhn?=
 =?utf-8?B?WFRVME1vcWpZOW5pUXlHU09MVzVLRGdlNmhSVWRXWTBZdzBkdCtFT2V2RlVF?=
 =?utf-8?B?RnRUbjNrVDM4UHVaSFJFRVBuOW91Lzh4SXhsby9jRytHdyt3NmNyMWdTaE1G?=
 =?utf-8?B?emdwSFRsQWgyZVNZMndmS3JrL2Y4cFpOWkdIOXBhZmVHbUczYVhQZFR3ZUV2?=
 =?utf-8?B?U0Z6cHQ0Ny9zRDFjWlRCT2VETmsyR2RlN3J5WGZzVmtrT2JTbXo0L2VYRkFr?=
 =?utf-8?B?dGhUc3JpeWlCOUYwbmt2UHNISmgzNVdJVXo4eVk3Qnk3YzJjcWVQMkZ6Uldq?=
 =?utf-8?B?Um1sUTBYZHR3Qko5ZG1UV1IyS1ZYUXFtaTBOclY4cHpMVy9TZHMyZWpkNWdK?=
 =?utf-8?B?SHNlMG1OTjNzdE5hcmFTTnlqMXRnVm1jZ2V1Y0hBSGpyTUJERmcyZ015Z1FH?=
 =?utf-8?B?dlM4b05IeXFPaFJ1UkpQYnY1RXZ4TVpmV1FxN0Y4UFBvM3NmVk01MENVaHRS?=
 =?utf-8?B?a1hxVTAySlhrN2g3bFl5TVhPSEsvVXVtdUxndDJpUzRLOVo0RTZEb0hBK1Mr?=
 =?utf-8?B?MnFGOVBldm51ZnZ3NUR1cEc4Rm5rMFFLbHA5NlpoUnhRdXIzRG9JY2I4M1o4?=
 =?utf-8?B?WGwrQm9OMWVHYUF2L05pa3F0YjNxbGQxbTBKclBnb0x0enpCeFY5YzNFczIr?=
 =?utf-8?B?LzVFZlJsU09SdU41Tytncmdabmhhbm1lSXIzYktOa1ZucXVIQ1k3MGtDOHNZ?=
 =?utf-8?B?REVJcXVwYXh1ZjIyWEpMVWRmQ0lrY0pEcFZabVRkS1UwbU10aFo0cE1Vc2p6?=
 =?utf-8?B?RUt3MVZNbTRoOEQ5TEhYQnRsNlBqWlRYWHBvUE9Bdi9vZFlHOGpOLzF0dHlq?=
 =?utf-8?B?MGlwbEI1Uk9VaDd6bzZtUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:9;SRV:;IPV:NLI;SFV:SPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(13230025)(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199018)(31686004)(2906002)(30864003)(38100700002)(31696002)(966005)(6486002)(6506007)(53546011)(186003)(478600001)(36756003)(6512007)(66946007)(66556008)(4326008)(8676002)(66476007)(83380400001)(110136005)(6666004)(2616005)(26005)(8936002)(5660300002)(316002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmE1a0RFWnZkVUx5WVJidkwxOFBkaTZSd1l6UFdOOUowT3RvSHBjbnlRWis1?=
 =?utf-8?B?a3pPOTRZK1kzalZqcC9LM25QdEhCb3dvbGN2T0VoSzE4ZmYvZ1ZUckFXRmxn?=
 =?utf-8?B?aFJHdVBRSTJZNXhwUHZwbWlPMXlaZ1FBV0kvbVpMQjVRN2dGT2laVkxnYWZN?=
 =?utf-8?B?bXU1RHArRzgycUEzWmdZMzUrQTFrYmdFNE45YXZYc3RIdTVJcFk3ZTQ4K0Ns?=
 =?utf-8?B?c1llOXVFMlo5Uy9WQUg5emgvWGYvVjFnazVXRXBqRjVncUtWVlNvV1JFWTho?=
 =?utf-8?B?Y3VNYlkrQVA3Zjc3SUYveFM3YjJRRkNYbWwwTWljaGFuMW12YThVejBUMFF0?=
 =?utf-8?B?TmRoZFRIWU1HNkFQY2N0VWlmc2xMdFdmZUhROFFUSnZuMVppM0pNN1VyOXFJ?=
 =?utf-8?B?U0NFQXk4MExGR3hBekR6N0k1Zjh4MllnTllncVJEZ3NMQ3RENk1Ha1o4aXpq?=
 =?utf-8?B?anZzMTlNUnppbzBybUZMQXdwUEVnNnZ5VXV4ZWpXWElteDFsWkgwVThyRU1V?=
 =?utf-8?B?cmIwdXRFRlFKMG9QZVR4c0dwb2NBYW5LeitXWm1Oak5BSmFJQnhidTVaSURv?=
 =?utf-8?B?dG41M2pjeUJjdFdiRnR5NUtPdVF1TkZURW84Q01kanIyQTdkRTBSR0tVYU15?=
 =?utf-8?B?THRUVTJCSldoT3IyRXVTcUNOTXNBb3hyMDBka3Q1YUNJVHU0Zk9yWmlOZTVm?=
 =?utf-8?B?MU93Y0pOdEtkZTRHZW5EQVZhZzNUdkM5ZndMYmNvYk9OZ250aEtsQUZscHQy?=
 =?utf-8?B?QTBMMjV5WU8rV1NiOG12OWlzVlZOS1MzREcwbU93dU4zRG9mREpXZHpGSEFS?=
 =?utf-8?B?aTh3YThrSkFtK1FOc1doTyt2NmtRMFJYVklRNDNaQlVvQk9LeVROdGJKcHZj?=
 =?utf-8?B?L0R3UHkyU28xZzRTTGdiRTZVQ24wV3VoVW9yQ1hOTDNROGxsZ1BFSzFTMHZP?=
 =?utf-8?B?WU1mUGxtNVAwKzhoT1Qvazh5RUgxVVMybVUxVHl4TE5wUEl2RmsxdUtGVzU5?=
 =?utf-8?B?ZVVpdlFxWmQxNThXd3lvaDUyYWpsVkN0MEdjR25Ua21oRnV3U1ZaNU5xWWd1?=
 =?utf-8?B?VWRHN29qRHpxRXExbjZ1d1lNOEJDQkcrWkZNOEppTkVTb211cXloMXZCZjhy?=
 =?utf-8?B?MnNaOVpvY1hLWiswamV4RUVOL1VZellPZ2U2ektJOGg1NUNraFo5eGs0MnJs?=
 =?utf-8?B?RGZ0R2c5OUZza3ZNL054UFlwL21RTFNOdjlOeTNUaTdLQklnR3lOSE03WThE?=
 =?utf-8?B?RE1vZWdxWjZzL3ZnYk0rV1FIRnUzQm9PTEYzK3RwRWpSdTJMS1dFTVJPeTF3?=
 =?utf-8?B?WVZ2WEdGMlB2T0JhTC80ZGNUTmF1WlJrcVQyWUk5MUlwTEJxL1FBZzBjVENL?=
 =?utf-8?B?Q3AyVUZzekorSzZuTWJobll6cVhSYVllZElKcUlDeFMzZGhXSzU4MzhIWllJ?=
 =?utf-8?B?akdkbmMrUXdXZ3JZSUtmOUY2MWFjS1MvUGh4a1h3RGdQMkQvZzdIbzM3TVN0?=
 =?utf-8?B?M1ZwTVVwQVVkQXJReXhxVVk3MS9mU1FuMkNtZ21JK0lmbEwwRHYvSm9mZ2My?=
 =?utf-8?B?L2NEcUozTHloVC9vL1Z1RVpVK2YyejRNWXM1Z3liWjhIN2NDN0RveUEyaFJT?=
 =?utf-8?B?czlEeU42S0c4MGZHL28rQi9vQzR6QjgrTUtHeWo1Y0tYSkJhY2JmcFhETVlN?=
 =?utf-8?B?YkpGUFV6UHBXM04xS0J4emhZN1JTc2lwclZ2VTA4djFZMm5lQjhuWk9Vb2pa?=
 =?utf-8?B?S29MVFZpR0d5elhHSmxEekNUUVZUbHQ1WUJCU3BMakw5amk2eU1xUTdjYm8z?=
 =?utf-8?B?N0M0NVVKYUdwSTBNK0Q4emRwcXc4SW1kOHFxejVoMW92Rm01STFmRGdyTFg1?=
 =?utf-8?B?WTZIQjZ5VnRMM3ZVS255UG14a3kxN3k0MHVCOWljMUwwa1ZKbVVWZTViODlI?=
 =?utf-8?B?RmdVTWluSWhsYzgxRWJXSndqVzRVUm5UcWw2RFU0UkFrb1ZwUnd3QXM2aERD?=
 =?utf-8?B?Sk1nMjFMTGFQLzNmY0YxVzVxY0t2MVo0WEpXdDJNT3E0WlVSNVhEMzBUQU5O?=
 =?utf-8?B?d1NDYkJUejZnU2ZsejIxa3FnNzZqZ2ZBQ21Pc1dEakhRR0h4ZW1WYjJvWExE?=
 =?utf-8?Q?fsznAHbVLFJMnYuJckgBImI7K?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3168ef8-1966-4092-b274-08db1e2fb762
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 10:44:09.3770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2+/seb8MDrx/ONdmkJ96T6gBqlc6qDTO3Djqpwm2pKQCqdWeEchJaWOUJzAp4O8e2PCkPVHxrnuplvdqGq5lhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6019
X-Spam-Status: No, score=-0.9 required=5.0 tests=AXB_X_FF_SEZ_S,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/03/2023 08:30, Timothy Pearson wrote:
>   allow blocking domains
> 
> Up until now PPC64 managed to avoid using iommu_ops. The VFIO driver
> uses a SPAPR TCE sub-driver and all iommu_ops uses were kept in
> the Type1 VFIO driver. Recent development added 2 uses of iommu_ops to
> the generic VFIO which broke POWER:
> - a coherency capability check;
> - blocking IOMMU domain - iommu_group_dma_owner_claimed()/...
> 
> This adds a simple iommu_ops which reports support for cache
> coherency and provides a basic support for blocking domains. No other
> domain types are implemented so the default domain is NULL.
> 
> Since now iommu_ops controls the group ownership, this takes it out of
> VFIO.
> 
> This adds an IOMMU device into a pci_controller (=PHB) and registers it
> in the IOMMU subsystem, iommu_ops is registered at this point.
> This setup is done in postcore_initcall_sync.
> 
> This replaces iommu_group_add_device() with iommu_probe_device() as
> the former misses necessary steps in connecting PCI devices to IOMMU
> devices. This adds a comment about why explicit iommu_probe_device()
> is still needed.
> 
> The previous discussion is here:
> https://patchwork.ozlabs.org/project/linuxppc-dev/patch/20220707135552.3688927-1-aik@ozlabs.ru/
> https://patchwork.ozlabs.org/project/kvm-ppc/patch/20220701061751.1955857-1-aik@ozlabs.ru/
> 
> Fixes: e8ae0e140c05 ("vfio: Require that devices support DMA cache coherence")
> Fixes: 70693f470848 ("vfio: Set DMA ownership for VFIO devices")
> Cc: Deming Wang <wangdeming@inspur.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Daniel Henrique Barboza <danielhb413@gmail.com>
> Cc: Fabiano Rosas <farosas@linux.ibm.com>
> Cc: Murilo Opsfelder Araujo <muriloo@linux.ibm.com>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
> ---
>   arch/powerpc/include/asm/pci-bridge.h     |   7 +
>   arch/powerpc/kernel/iommu.c               | 149 +++++++++++++++++++++-
>   arch/powerpc/platforms/powernv/pci-ioda.c |  30 +++++
>   arch/powerpc/platforms/pseries/iommu.c    |  24 ++++
>   arch/powerpc/platforms/pseries/pseries.h  |   4 +
>   arch/powerpc/platforms/pseries/setup.c    |   3 +
>   drivers/vfio/vfio_iommu_spapr_tce.c       |   8 --
>   7 files changed, 215 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
> index e18c95f4e1d4..fcab0e4b203b 100644
> --- a/arch/powerpc/include/asm/pci-bridge.h
> +++ b/arch/powerpc/include/asm/pci-bridge.h
> @@ -8,6 +8,7 @@
>   #include <linux/list.h>
>   #include <linux/ioport.h>
>   #include <linux/numa.h>
> +#include <linux/iommu.h>
>   
>   struct device_node;
>   
> @@ -44,6 +45,9 @@ struct pci_controller_ops {
>   #endif
>   
>   	void		(*shutdown)(struct pci_controller *hose);
> +
> +	struct iommu_group *(*device_group)(struct pci_controller *hose,
> +					    struct pci_dev *pdev);
>   };
>   
>   /*
> @@ -131,6 +135,9 @@ struct pci_controller {
>   	struct irq_domain	*dev_domain;
>   	struct irq_domain	*msi_domain;
>   	struct fwnode_handle	*fwnode;
> +
> +	/* iommu_ops support */
> +	struct iommu_device	iommu;
>   };
>   
>   /* These are used for config access before all the PCI probing
> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
> index d873c123ab49..46c8912ae87c 100644
> --- a/arch/powerpc/kernel/iommu.c
> +++ b/arch/powerpc/kernel/iommu.c
> @@ -35,6 +35,7 @@
>   #include <asm/vio.h>
>   #include <asm/tce.h>
>   #include <asm/mmu_context.h>
> +#include <asm/ppc-pci.h>
>   
>   #define DBG(...)
>   
> @@ -1158,8 +1159,14 @@ int iommu_add_device(struct iommu_table_group *table_group, struct device *dev)
>   
>   	pr_debug("%s: Adding %s to iommu group %d\n",
>   		 __func__, dev_name(dev),  iommu_group_id(table_group->group));
> -
> -	return iommu_group_add_device(table_group->group, dev);
> +	/*
> +	 * This is still not adding devices via the IOMMU bus notifier because
> +	 * of pcibios_init() from arch/powerpc/kernel/pci_64.c which calls
> +	 * pcibios_scan_phb() first (and this guy adds devices and triggers
> +	 * the notifier) and only then it calls pci_bus_add_devices() which
> +	 * configures DMA for buses which also creates PEs and IOMMU groups.
> +	 */
> +	return iommu_probe_device(dev);
>   }
>   EXPORT_SYMBOL_GPL(iommu_add_device);
>   
> @@ -1239,6 +1246,7 @@ static long spapr_tce_take_ownership(struct iommu_table_group *table_group)
>   		rc = iommu_take_ownership(tbl);
>   		if (!rc)
>   			continue;
> +
>   		for (j = 0; j < i; ++j)
>   			iommu_release_ownership(table_group->tables[j]);
>   		return rc;
> @@ -1271,4 +1279,141 @@ struct iommu_table_group_ops spapr_tce_table_group_ops = {
>   	.release_ownership = spapr_tce_release_ownership,
>   };
>   
> +/*
> + * A simple iommu_ops to allow less cruft in generic VFIO code.
> + */
> +static int spapr_tce_blocking_iommu_attach_dev(struct iommu_domain *dom,
> +					       struct device *dev)
> +{
> +	struct iommu_group *grp = iommu_group_get(dev);
> +	struct iommu_table_group *table_group;
> +	int ret = -EINVAL;
> +
> +	if (!grp)
> +		return -ENODEV;
> +
> +	table_group = iommu_group_get_iommudata(grp);
> +	ret = table_group->ops->take_ownership(table_group);
> +	iommu_group_put(grp);
> +
> +	return ret;
> +}
> +
> +static void spapr_tce_blocking_iommu_detach_dev(struct iommu_domain *dom,
> +						struct device *dev)
> +{
> +	struct iommu_group *grp = iommu_group_get(dev);
> +	struct iommu_table_group *table_group;
> +
> +	table_group = iommu_group_get_iommudata(grp);
> +	table_group->ops->release_ownership(table_group);
> +}
> +
> +static const struct iommu_domain_ops spapr_tce_blocking_domain_ops = {
> +	.attach_dev = spapr_tce_blocking_iommu_attach_dev,
> +	.detach_dev = spapr_tce_blocking_iommu_detach_dev,


This .detach_dev() is gone now, the upstream has it removed. I am not 
quite sure now what should be calling release_ownership(). Probably 
spapr_tce_iommu_ops is going to need default_domain_ops, which 
attach_dev() will call release_ownership().

Please send patches via "git send-email", it links the cover letter to 
the patches so they appear threaded and (more importantly) it adds all 
the people from cc: and sob: to the actual mails sent out so people get 
copied. In this case, we want Jason to see this, at least :) Thanks,


> +};
> +
> +static bool spapr_tce_iommu_capable(struct device *dev, enum iommu_cap cap)
> +{
> +	switch (cap) {
> +	case IOMMU_CAP_CACHE_COHERENCY:
> +		return true;
> +	default:
> +		break;
> +	}
> +
> +	return false;
> +}
> +
> +static struct iommu_domain *spapr_tce_iommu_domain_alloc(unsigned int type)
> +{
> +	struct iommu_domain *dom;
> +
> +	if (type != IOMMU_DOMAIN_BLOCKED)
> +		return NULL;
> +
> +	dom = kzalloc(sizeof(*dom), GFP_KERNEL);
> +	if (!dom)
> +		return NULL;
> +
> +	dom->ops = &spapr_tce_blocking_domain_ops;
> +
> +	return dom;
> +}
> +
> +static struct iommu_device *spapr_tce_iommu_probe_device(struct device *dev)
> +{
> +	struct pci_dev *pdev;
> +	struct pci_controller *hose;
> +
> +	if (!dev_is_pci(dev))
> +		return ERR_PTR(-EPERM);
> +
> +	pdev = to_pci_dev(dev);
> +	hose = pdev->bus->sysdata;
> +
> +	return &hose->iommu;
> +}
> +
> +static void spapr_tce_iommu_release_device(struct device *dev)
> +{
> +}
> +
> +static struct iommu_group *spapr_tce_iommu_device_group(struct device *dev)
> +{
> +	struct pci_controller *hose;
> +	struct pci_dev *pdev;
> +
> +	pdev = to_pci_dev(dev);
> +	hose = pdev->bus->sysdata;
> +
> +	if (!hose->controller_ops.device_group)
> +		return ERR_PTR(-ENOENT);
> +
> +	return hose->controller_ops.device_group(hose, pdev);
> +}
> +
> +static const struct iommu_ops spapr_tce_iommu_ops = {
> +	.capable = spapr_tce_iommu_capable,
> +	.domain_alloc = spapr_tce_iommu_domain_alloc,
> +	.probe_device = spapr_tce_iommu_probe_device,
> +	.release_device = spapr_tce_iommu_release_device,
> +	.device_group = spapr_tce_iommu_device_group,
> +};
> +
> +static struct attribute *spapr_tce_iommu_attrs[] = {
> +	NULL,
> +};
> +
> +static struct attribute_group spapr_tce_iommu_group = {
> +	.name = "spapr-tce-iommu",
> +	.attrs = spapr_tce_iommu_attrs,
> +};
> +
> +static const struct attribute_group *spapr_tce_iommu_groups[] = {
> +	&spapr_tce_iommu_group,
> +	NULL,
> +};
> +
> +/*
> + * This registers IOMMU devices of PHBs. This needs to happen
> + * after core_initcall(iommu_init) + postcore_initcall(pci_driver_init) and
> + * before subsys_initcall(iommu_subsys_init).
> + */
> +static int __init spapr_tce_setup_phb_iommus_initcall(void)
> +{
> +	struct pci_controller *hose;
> +
> +	list_for_each_entry(hose, &hose_list, list_node) {
> +		iommu_device_sysfs_add(&hose->iommu, hose->parent,
> +				       spapr_tce_iommu_groups, "iommu-phb%04x",
> +				       hose->global_number);
> +		iommu_device_register(&hose->iommu, &spapr_tce_iommu_ops,
> +				      hose->parent);
> +	}
> +	return 0;
> +}
> +postcore_initcall_sync(spapr_tce_setup_phb_iommus_initcall);
> +
>   #endif /* CONFIG_IOMMU_API */
> diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
> index 7b371322f1ae..5f0b0bbfa90c 100644
> --- a/arch/powerpc/platforms/powernv/pci-ioda.c
> +++ b/arch/powerpc/platforms/powernv/pci-ioda.c
> @@ -1897,6 +1897,13 @@ static long pnv_ioda2_take_ownership(struct iommu_table_group *table_group)
>   	/* Store @tbl as pnv_pci_ioda2_unset_window() resets it */
>   	struct iommu_table *tbl = pe->table_group.tables[0];
>   
> +	/*
> +	 * iommu_ops transfers the ownership per a device and we mode
> +	 * the group ownership with the first device in the group.
> +	 */
> +	if (!tbl)
> +		return 0;
> +
>   	pnv_pci_ioda2_set_bypass(pe, false);
>   	pnv_pci_ioda2_unset_window(&pe->table_group, 0);
>   	if (pe->pbus)
> @@ -1913,6 +1920,9 @@ static void pnv_ioda2_release_ownership(struct iommu_table_group *table_group)
>   	struct pnv_ioda_pe *pe = container_of(table_group, struct pnv_ioda_pe,
>   						table_group);
>   
> +	/* See the comment about iommu_ops above */
> +	if (pe->table_group.tables[0])
> +		return;
>   	pnv_pci_ioda2_setup_default_config(pe);
>   	if (pe->pbus)
>   		pnv_ioda_setup_bus_dma(pe, pe->pbus);
> @@ -2918,6 +2928,25 @@ static void pnv_pci_ioda_dma_bus_setup(struct pci_bus *bus)
>   	}
>   }
>   
> +static struct iommu_group *pnv_pci_device_group(struct pci_controller *hose,
> +						struct pci_dev *pdev)
> +{
> +	struct pnv_phb *phb = hose->private_data;
> +	struct pnv_ioda_pe *pe;
> +
> +	if (WARN_ON(!phb))
> +		return ERR_PTR(-ENODEV);
> +
> +	pe = pnv_pci_bdfn_to_pe(phb, pdev->devfn | (pdev->bus->number << 8));
> +	if (!pe)
> +		return ERR_PTR(-ENODEV);
> +
> +	if (!pe->table_group.group)
> +		return ERR_PTR(-ENODEV);
> +
> +	return iommu_group_ref_get(pe->table_group.group);
> +}
> +
>   static const struct pci_controller_ops pnv_pci_ioda_controller_ops = {
>   	.dma_dev_setup		= pnv_pci_ioda_dma_dev_setup,
>   	.dma_bus_setup		= pnv_pci_ioda_dma_bus_setup,
> @@ -2928,6 +2957,7 @@ static const struct pci_controller_ops pnv_pci_ioda_controller_ops = {
>   	.setup_bridge		= pnv_pci_fixup_bridge_resources,
>   	.reset_secondary_bus	= pnv_pci_reset_secondary_bus,
>   	.shutdown		= pnv_pci_ioda_shutdown,
> +	.device_group		= pnv_pci_device_group,
>   };
>   
>   static const struct pci_controller_ops pnv_npu_ocapi_ioda_controller_ops = {
> diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
> index 6769d2c55187..1c911eedf8fb 100644
> --- a/arch/powerpc/platforms/pseries/iommu.c
> +++ b/arch/powerpc/platforms/pseries/iommu.c
> @@ -1727,3 +1727,27 @@ static int __init tce_iommu_bus_notifier_init(void)
>   	return 0;
>   }
>   machine_subsys_initcall_sync(pseries, tce_iommu_bus_notifier_init);
> +
> +#ifdef CONFIG_SPAPR_TCE_IOMMU
> +struct iommu_group *pSeries_pci_device_group(struct pci_controller *hose,
> +					     struct pci_dev *pdev)
> +{
> +	struct device_node *pdn, *dn = pdev->dev.of_node;
> +	struct iommu_group *grp;
> +	struct pci_dn *pci;
> +
> +	pdn = pci_dma_find(dn, NULL);
> +	if (!pdn || !PCI_DN(pdn))
> +		return ERR_PTR(-ENODEV);
> +
> +	pci = PCI_DN(pdn);
> +	if (!pci->table_group)
> +		return ERR_PTR(-ENODEV);
> +
> +	grp = pci->table_group->group;
> +	if (!grp)
> +		return ERR_PTR(-ENODEV);
> +
> +	return iommu_group_ref_get(grp);
> +}
> +#endif
> diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/platforms/pseries/pseries.h
> index 1d75b7742ef0..f8bce40ebd0c 100644
> --- a/arch/powerpc/platforms/pseries/pseries.h
> +++ b/arch/powerpc/platforms/pseries/pseries.h
> @@ -123,5 +123,9 @@ static inline void pseries_lpar_read_hblkrm_characteristics(void) { }
>   #endif
>   
>   void pseries_rng_init(void);
> +#ifdef CONFIG_SPAPR_TCE_IOMMU
> +struct iommu_group *pSeries_pci_device_group(struct pci_controller *hose,
> +					     struct pci_dev *pdev);
> +#endif
>   
>   #endif /* _PSERIES_PSERIES_H */
> diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
> index 8ef3270515a9..f16fcd93297a 100644
> --- a/arch/powerpc/platforms/pseries/setup.c
> +++ b/arch/powerpc/platforms/pseries/setup.c
> @@ -1125,6 +1125,9 @@ static int pSeries_pci_probe_mode(struct pci_bus *bus)
>   
>   struct pci_controller_ops pseries_pci_controller_ops = {
>   	.probe_mode		= pSeries_pci_probe_mode,
> +#ifdef CONFIG_SPAPR_TCE_IOMMU
> +	.device_group		= pSeries_pci_device_group,
> +#endif
>   };
>   
>   define_machine(pseries) {
> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
> index c3f8ae102ece..a94ec6225d31 100644
> --- a/drivers/vfio/vfio_iommu_spapr_tce.c
> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
> @@ -1200,8 +1200,6 @@ static void tce_iommu_release_ownership(struct tce_container *container,
>   	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i)
>   		if (container->tables[i])
>   			table_group->ops->unset_window(table_group, i);
> -
> -	table_group->ops->release_ownership(table_group);
>   }
>   
>   static long tce_iommu_take_ownership(struct tce_container *container,
> @@ -1209,10 +1207,6 @@ static long tce_iommu_take_ownership(struct tce_container *container,
>   {
>   	long i, ret = 0;
>   
> -	ret = table_group->ops->take_ownership(table_group);
> -	if (ret)
> -		return ret;
> -
>   	/* Set all windows to the new group */
>   	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i) {
>   		struct iommu_table *tbl = container->tables[i];
> @@ -1231,8 +1225,6 @@ static long tce_iommu_take_ownership(struct tce_container *container,
>   	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i)
>   		table_group->ops->unset_window(table_group, i);
>   
> -	table_group->ops->release_ownership(table_group);
> -
>   	return ret;
>   }
>   

-- 
Alexey

