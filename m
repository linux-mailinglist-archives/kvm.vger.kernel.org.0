Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185707977A3
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 18:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238799AbjIGQaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 12:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238880AbjIGQ35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 12:29:57 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8803893F3;
        Thu,  7 Sep 2023 09:27:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uhgxr8hxTryPoJnP9hKgkWouXAxXSlaqAtA8gdRUObMSryRFydaW5mOsMZGWBMFivWWDTsANzC6ES+Zb2k7NJNbFapDRYqzUZzA+SGkS3uPLD6+/wLyiGbcNKCfZUnq9+Me62HLBRxomjgL2ets+ZkoXd8Yl1WBes6P3bljlmT1E/m5uEE7UKclZBBvP03zhXqB2dcsB+wNNWK4/Cs8KGOjsrtptW2vZhxdmZFSHrL/A0EuYyFx3R3RALeln4xW3bo50yl1n+cWLm1PWy7HFH/hNOlNvVt/wLdYuiu/+fYNXhBJCW9QvPPOujQm3cUdAA3svQ8UYh/115TsmDH5j+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kAwkUCpiVtDyvH/QEtA0231i4H/zLxcv19DCkMBjfS8=;
 b=oTdUFBwLZNHfLKiDVnC1uWGTqMOlDcn8WmlsV+WtFgIw0D+rvWgQcoX9lKd/msLPuYAt3yZdUkuogpAegdDZqTRG9bPa/Rs7BRu0jrefcU2wu39sqZHnBZJScwNS9vdDRLDEhpAnwynqppl4r+ko1llYETmQE3sHQNGfZnnopGOqfEB2g9Kng6uAnYdin5HPkp8I0p0b/FlQDKNWFGGXRyHjGy9UxnddCk0zvxeSs+p/S+NU+zIW+LY2IBhYrYNrLby/OB5zUA/dJhCwxsUpEXIrTmD1qEp5y5wn/Ry4yFxbsfBy/LEvCb9WDYop0oM4pB/mhkdAdIFNIRAhRtUXxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kAwkUCpiVtDyvH/QEtA0231i4H/zLxcv19DCkMBjfS8=;
 b=K4Lo7poD9V9IgxdtYCxD6jkIwhzrW/Jf3SHu1M5SMdre0bSuZxgS+/YfEFmPtU3InCPFQnfU8McyIwuZN1kdV7q2wctnUL4xt07xUvN2LITJhqHw4Rg6XCweeWm/aAuoyENqABhV0m6JF4YLPfWJ3Y+h3mdipF0AhKC8zWVKt/o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by SJ0PR12MB7460.namprd12.prod.outlook.com (2603:10b6:a03:48d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Thu, 7 Sep
 2023 16:25:12 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%5]) with mapi id 15.20.6745.034; Thu, 7 Sep 2023
 16:25:12 +0000
Message-ID: <771890a8-f80d-155f-d24c-111a7b335329@amd.com>
Date:   Thu, 7 Sep 2023 09:25:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] vfio/pds: Add missing PCI_IOV depends
To:     oushixiong <oushixiong@kylinos.cn>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230906014942.1658769-1-oushixiong@kylinos.cn>
Content-Language: en-US
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230906014942.1658769-1-oushixiong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:a03:217::28) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|SJ0PR12MB7460:EE_
X-MS-Office365-Filtering-Correlation-Id: d1107f36-f3bf-40f9-0bd2-08dbafbf02c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lZ7jZCDZWsc9vdqkD8erOumG7wqklm6kx/ehVjwxDOYTbc21xociDKw8RASZaf6sFPAKzBY8TfzHvBeUXqJBFZoGiF8nk8TjgDHDVRqb4cZQzvf+5y+DDa09l3WjM4jcxtw8CQBP5wqjZnQEN4OQ5XYyqyVsMyUfAOT1clE04RnLhrr9Zt3POe3r1eErHyRLhkwVsIeTG0A7LRRSzVbN1K+0lu8OQqWJrEK/Bo/Ep1Li6ZgkUTfen/ngqv+a3OBKbKXLF84DTEiHgRlnF+sYjNJqA0EDdbvv+JSc8gOd5wj/6OUHSpV9Vig0+9LXMjjF6gXV/bXoDNr2umOBvvYf0LzVDJmnCXiZb7RHh4QaTKKHi/edW73dOwckpSltBmOQFcSzNhTJ28WjnZ3HuCUQsDCJrN4EZAu+K0afxLLy0ddYHmWh4ioZ/Q3WBhvF6fjVwJZMB5syRcwkPdaJja8Va26IuDDyAlwBXN02iEW2rbXrOzsWvk7/OaAag510SDdX8lAwmkYH+02nbd480Ek2ujMeoBHszg9ZhFwWWWUuo5Noe7aHEiKRCkdr9ZAfIEm9PdYlcwgxd28hSEGw3YBChqScMmKIVu9Is3lhn0m3HTaae1kU4Hqz4qEzqxxGfbPp7A6oVEs6pM1+bO3iNPRixA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(39860400002)(376002)(136003)(1800799009)(186009)(451199024)(31686004)(53546011)(6486002)(6506007)(31696002)(36756003)(38100700002)(2616005)(2906002)(26005)(478600001)(6512007)(83380400001)(66476007)(41300700001)(8936002)(8676002)(4326008)(5660300002)(316002)(66556008)(66946007)(54906003)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ymt1bVJzVnFjZjlUZGQxbkhwcmkxUC9HbHRyNVE3YTVHNFAyOWxSTlVQb2dJ?=
 =?utf-8?B?dnNrYXR4VmUya2kyYWtFRU5nN0JEeXhrN0NBdU10eS8wVHVZVFIwcU9BWGJl?=
 =?utf-8?B?ckt6eUtYd0NKdnlIeXlsSlBBK2p1cnQxZ284ZnRKU1crWmd2Y210NXAvY1Yy?=
 =?utf-8?B?Y3hxczEvMFRBVUR6NHJPRFkyQ1lvTFFLU1l5MWlFK2ZGMExVVWdheCtreFU1?=
 =?utf-8?B?K0NOWnRsb2VwaU92OXVwRGNJZmFQSUZqNHluVWxMSlJ4Q1VRM1hURTZCa09u?=
 =?utf-8?B?OG5IampjaWs1a21FeVRKYjMwMFNSdWJacko3bks4VlVKRE5kWFhjWUlUVVJk?=
 =?utf-8?B?U0lFMjJHQW5wTVpFS1o0SWJYcUd3STJ5di9lZWswTWdzZ25kdHNSNk13TlNj?=
 =?utf-8?B?bzR3VDM0blJveEJXQmZRazc4MUlpL0IxUEpGYjhadm4wbUpQRWpHa3l6RStC?=
 =?utf-8?B?WnRocFJVWXJyQ1ZqN3lSa3B4SlVmeHo1NE90ZDdkalllWWJaSWxBZTI1VEVt?=
 =?utf-8?B?MDNCcFBEVTV2VjFqTk5yOGViRzVoWVRldnpxNHJUV25UM2YxaDlUUGJFbUpy?=
 =?utf-8?B?dHZURUYzUDJUWUUxOWp0bVhyWC9xZGR2NVFZekVyRTVJQStJODdFcTFpbGtQ?=
 =?utf-8?B?cTI1YUkrRXhXYjFLUkNzRW8wN1pZRG5rczNZcUVKQUJJamk2SWZna1grQ2U3?=
 =?utf-8?B?eDdwTm5qY0d2amRNVkg2TVBYN25mTit5aEdOTUxSL3Q0TDU2bDRyVTJLM01Y?=
 =?utf-8?B?THFzOTBsejJEMGRVQzQ3djFzR3N4MmVrZEM5Ti9XazNlaTJYOFNmZWJvZlhp?=
 =?utf-8?B?bjNZOHFXK3dXM0NrbysyV1lBVndaMk5tTzExQ1dBcGh4SUFXTGk5c1dXc29j?=
 =?utf-8?B?ZGV3dG5qSmNFNWorbENwdjJkRk0yYVZ4bHlpbThmTXI4VDRMK0Eva1h4dWlr?=
 =?utf-8?B?bEZIc2E2NldXNG1Uak9kN1BiZW9qS1cwclZtWlJKdVhQL295cUtDMnVnNCt3?=
 =?utf-8?B?MFZSQ1ZpS05WTHFFRjhFSCt5anZNUlhwZVB2Z2NuNDJGeXFqbmlSdmFwYmZR?=
 =?utf-8?B?VjRwVy9iN291OS9EanFXaVVjd0xWTnljTHRzMStYVENralA4SldoWTYvYVJv?=
 =?utf-8?B?LzgwRHZlZTZHRWFBWms5UGFadTRqZkZaUkg4dGNJSlR2YUZzcjhvV0NUbUZL?=
 =?utf-8?B?QmZiTW9VV1pxQkVjZCtsYjBHT290RmNuRUJXY3VYVzNKZ3U0Q2VXSGNTS1dt?=
 =?utf-8?B?dkZxdFNmTm9oUEdDbUJCZU5zeEtmZ2hMZHF2ZWNuZ2JCQ29idVlYS3E0N1J1?=
 =?utf-8?B?Q2NlTVdVUDJxSWlVZy9rVnhnNngvdmlwYTJlVTVWQ2pqTFVNRE90R0hoL2ph?=
 =?utf-8?B?VWkrZXRKdElBY1hGLyt0c3A2bDZzL0xkR1NPZzMvYTlLbHczb1RWcFNiSmZl?=
 =?utf-8?B?Q3pkeWJHLzR0L1JoWVlWNmF1RE04TTd4TlBrcDY1YnlKOU96dzlwSnhmVjZy?=
 =?utf-8?B?eEhvS0lBSHR1REY5aXBVMkIxTnRUOEZMS250UHpJS2NYUE1RUWRhM3IvcmZN?=
 =?utf-8?B?ZTJxbWJJRFRpTWtxNnk0SldMNzhHbEJjaHhHRkxEZ3dUVy9CenF6cTB2WDBu?=
 =?utf-8?B?THNZODJTSkpzVWExNDZSZFJZMWxQMUNOWFd3Nk5QUXJIK2xteGFmajNVeVJq?=
 =?utf-8?B?SGswTmV6UU9sazM2RmR1ejJUUjlXY3d5Nm53N2pES0tydVF2UkhkNFFFdlJx?=
 =?utf-8?B?cGlaQ3FkSnlPNXppcGNDeGJUR3U0NDl6K2hrbk5UVHBmcmdrS2o5enFoZDBI?=
 =?utf-8?B?SkRscW5nVEZ2LzVRZ3J0VldjZk1VWkhCamxFY3FOWWh0ekhiWWM5eXo1R0ZI?=
 =?utf-8?B?Y2hYRnRCTXVPQ3NBUWNsd0ViSXZ4V3dlVlF0d0RwTVdRQUplMkVZeGNJcXNv?=
 =?utf-8?B?alRRcGZkbzlFVmdhWk12SXNadi9uQ1VFUU5VSUR3NWdjMTlsOWRLaEY1ZVly?=
 =?utf-8?B?ZUxjV1lyZmlNVVUrWUtzZy9PcllYbjVmaUw1bnF1R0o5WHpYMWtHcTNvemVY?=
 =?utf-8?B?T3lYUHB5NVFMWVRLTEJkeFNOTUMyV25tRVo1RHRkOEdmNTEzZENEdXRBYVZy?=
 =?utf-8?Q?DFHGhP0sP4kzOise5lyWe5OdF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1107f36-f3bf-40f9-0bd2-08dbafbf02c5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2023 16:25:12.6932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yri7DMzf2c+vPxEhzB72vQ9IVo5iyqkoDFJ+BEJAQmuNhTFQs36o+np3QUzp+l4t1cxZTdi5hvQhWHyOX3qfOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7460
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/5/2023 6:49 PM, oushixiong wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> From: Shixiong Ou <oushixiong@kylinos.cn>
> 
> If PCI_ATS isn't set, then pdev->physfn is not defined.
> it causes a compilation issue:
> 
> ../drivers/vfio/pci/pds/vfio_dev.c:165:30: error: ‘struct pci_dev’ has no member named ‘physfn’; did you mean ‘is_physfn’?
>    165 |   __func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
>        |                              ^~~~~~
> 
> So adding PCI_IOV depends to select PCI_ATS.
> 
> Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
> ---
>   drivers/vfio/pci/pds/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/pds/Kconfig b/drivers/vfio/pci/pds/Kconfig
> index 407b3fd32733..6eceef7b028a 100644
> --- a/drivers/vfio/pci/pds/Kconfig
> +++ b/drivers/vfio/pci/pds/Kconfig
> @@ -3,7 +3,7 @@
> 
>   config PDS_VFIO_PCI
>          tristate "VFIO support for PDS PCI devices"
> -       depends on PDS_CORE
> +       depends on PDS_CORE && PCI_IOV
>          select VFIO_PCI_CORE
>          help
>            This provides generic PCI support for PDS devices using the VFIO
> --
> 2.25.1
> 

LGTM! Thanks for fixing this.

Reviewed-by: Brett Creeley <brett.creeley@amd.com>
