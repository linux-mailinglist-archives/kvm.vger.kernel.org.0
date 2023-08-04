Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBB57708E8
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 21:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjHDTVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 15:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjHDTV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 15:21:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FE2B9;
        Fri,  4 Aug 2023 12:21:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0iVVAQ+pon86Zl0pDyRZEZ8Sz8lwma/osIolQ62nfcrl8YIQbjfh0wkRcAAp3kOJMGejs+jkAQ/2uWnBztuwfsrzG662WyKibivSOIfmAgILASfVkeruh0bw+77aU4ZY4zLT7TFxi2sqNbwetCQfsHxOeE0g9KNcUsQmo8Md4wAMjpghZFNq/EglSbZO83gE3t0GIiV2bkunRI65eVaxPB/J+yWDYkmxa8NYhbqLWHmRSqqPlLePPs1G9pVqNgRuSKCh8MFSBlbq61ENGl0l9Q0QzL7KaVaclOs5P7RFGRsigM0Wj8zp6emMqpEr8UzmFtBP7lH8gfetIKMubN9Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hi0dbPn5LyghegcjCTLnACafXx8MhvVCA5nRkRSFvDY=;
 b=Q42iLIbcv3/tdIm7SjBsUAw8j+S3olajY/WrxLkvx0HJ2n2GFh/dV8JHn1fs+mn4xWkrAAOA5Iq3IVWi4x5EGQ43g6XFR5dBDo/YKYE+asobuiJF6U6v2Hwdrl+cQaA0VM6Si+R870/rlMJI42jdCn976j28XvBPCYhGf3ZKBQdOGq7uqgfSscg4Bh+EsicMXoLAtY29lqoRHaMDso/VzcawH1rze2tv8B/LoHCk9B09cnzZLUfBnl2aAKMIOkwg1OeCzOfwetMBRyo18wyfdCysJpwOigpntC3F14QDMdKUOSDOfsq89De51s2fYaJp87Z7Z8czDlFXQh2WlHTMIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hi0dbPn5LyghegcjCTLnACafXx8MhvVCA5nRkRSFvDY=;
 b=G81SJGWMsDqgQiL+48sX5R8C32u2xnnZFZpMeUglaGKYJgfGJnniI//McxbFWAlMgsQIfBL8cuWPododOuHjWearLQQ/tmiiNaDaU0iBONkQkkUJj6b3FX3N3D26RjmUNu3an54hiea9oXxguOUnhrCK8+K+aEzYkeW/s+HrSB4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by SA1PR12MB6775.namprd12.prod.outlook.com (2603:10b6:806:25a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Fri, 4 Aug
 2023 19:21:23 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%4]) with mapi id 15.20.6652.021; Fri, 4 Aug 2023
 19:21:23 +0000
Message-ID: <afdd5231-cd7b-c940-7c51-c522b4cb5b90@amd.com>
Date:   Fri, 4 Aug 2023 12:21:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v13 vfio 3/7] vfio/pds: register with the pds_core PF
Content-Language: en-US
From:   Brett Creeley <bcreeley@amd.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        simon.horman@corigine.com, shannon.nelson@amd.com
References: <20230725214025.9288-1-brett.creeley@amd.com>
 <20230725214025.9288-4-brett.creeley@amd.com> <ZM0vTlNQnglE7Pjy@nvidia.com>
 <44535ea4-9886-a33a-7ee2-99514f04b53c@amd.com>
In-Reply-To: <44535ea4-9886-a33a-7ee2-99514f04b53c@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8PR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::9) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|SA1PR12MB6775:EE_
X-MS-Office365-Filtering-Correlation-Id: 5729e7a7-a0a7-4112-3cb7-08db951ffd8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ldijyVrlIPmm/COp3G4DtrWdXhIajp12xaLougB4FlYqLCBKlM0ZVhDu13xBCuTRq5neEczCQH//q6K9S6fDqjncO6a/B4YsN16f3MmJpL+lGYck+yIYz9Z1lQTOOB8fCcuQgP7iNOi79+dWDsKb/j4HZxZrEIbxcyrKER2ERcBZangomthjGUckyj9AqC12vVObliwMHvjaLkmrhHZwPR+0ZisL4P1QwKkNcydPz9ql17P4YoekFqWSI3tnNGme/F6fhTIwcg40V5Mt7OXkaf5TF8qrgMEOCB9jr8waxlMRF4jZ639Bo9Bc2fW9rClmgM5VAZlOAkbjnYp5BoncfNhzlJKcyEMgjzd0vVSjWGL0C8P0uDafdX7Fcuso1g8Zpsfy6kXQq4q1z9oLut53TwcbD1iwMLw0ptjKnXa4buTP1ppgfY5vNHIOtK0PUPItwCMCev8r5E6ARYlLiOtdDByyhg88GPO68DfKRewH6pfNzE+tmrzzeLemncp+O9egVQzq9wV9qGkauNjZeR3hD7PJ8pVF+F96gdddU7m1lZB5XyqDcxsBTcDEAkWNlcQgif6b+PwoVS76AbNmDPEJYpml+VFNzPQXcujDmAj+0379y/m41qLS2hyE2Me7Qd5TLrsiD6DUjaSZ67lVXBumCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(451199021)(1800799003)(186006)(41300700001)(8936002)(8676002)(83380400001)(53546011)(6506007)(26005)(2616005)(38100700002)(31696002)(316002)(6512007)(478600001)(6486002)(110136005)(6636002)(4326008)(36756003)(31686004)(2906002)(66476007)(5660300002)(66946007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDhHTHl3Q0txYTMyOWpPU1l4ZTRiNGdwSy8rUDdUd05TL05xaUpPZjgxYlZC?=
 =?utf-8?B?V2NJeGVTZjB0ZFBrSmpqaUM4UWE2VzR1dFloeGkvTDNiRGVoYnhwWHNsM1g0?=
 =?utf-8?B?Unl3c09GbWJkWjY4djR3eldBUkVpVnc5RFRDL3paYTViTWo1ajFEc2Fhb3VW?=
 =?utf-8?B?LzFlMTBmdFk4L3dLb2pSYkJJVFlOOHVsc0k1SlJtbkppd1ZVY1p1N1Jzdllt?=
 =?utf-8?B?OG4wOXE5S2d2YzkzUDZPV0l6THVjTTFZMFZRakorK2VxT2pqMXdqRzFEa1lz?=
 =?utf-8?B?eEdhcFlFd3R3VkM3dlpSVC80T3hjenBNYmcxL244dG1UN05URFJRVENSYngw?=
 =?utf-8?B?VjJ1MHdZcTVJSDIvN1B1VW5UVXRubkd2YlkxWUhFYXhUd0RzZHZBUkF5K3Nl?=
 =?utf-8?B?RDBteExUYkhrQTBsUW9oeDAxUWJ0WlhWcEhZY3Q5VGZRZTNwZG5UWmFjMUs1?=
 =?utf-8?B?WUhDZjJWYTNVSVZJdVZ2WDhNTm91QnpBRSsrUGZ1a0dOK2MrNUJWSlNkUWpR?=
 =?utf-8?B?Qll6d09KSm9XRXluYmt0K1FNNVBadzdiUzJlMy9NbE1aa1M3bGxKbmtNRmw1?=
 =?utf-8?B?OG4xWEVOY3B2NW9hWDVSZFdzcWJoZFQzVEpsUVEyenozd2RYUUpIUStwczlO?=
 =?utf-8?B?cDlLRU00dm5iYmNYT294R05NTVNnQVdRdFlhaVF6bVduaVhGNlQvdGdEb1Vx?=
 =?utf-8?B?aERNWlRjNzRyLzFjMjlQTlBXN1JlbDRlbHBjVk1CWjM2UG01MjYwM3k4ZE1j?=
 =?utf-8?B?YTlZdDRmQWtoQ2x1VVBmOVB1WDlDMTlrRFJRQkhtWjJxNDRUQ0hSV2M0b2Ur?=
 =?utf-8?B?WE5iSkhZajZuQjRFSTYzZ28rRWRJbHBPbktrbXJoOEN0WXNVQUIyTGpMWmpz?=
 =?utf-8?B?OTZKeEpCSEg4UEJkN2JCYS9ZR0czZlRZLyt3VjlZNEZJbVVPeHAvTzFwOFQz?=
 =?utf-8?B?NkZsalNBa01zV0RJaE1EYlcxWXRwVWtQZCtZWDFhRzQxOVc0RENKdFBDdUVv?=
 =?utf-8?B?aVVJa010ZlZEMFVlTmtMYkRPTFh3d3RENGd4Tjc5OUw0ZWNGSkh0OGFoSWZv?=
 =?utf-8?B?ZlNDSzI2WXlJYmw5MDc4VmFMaUlXQmRaVVRpTGhVcTBsREIwczJxcytnSWRN?=
 =?utf-8?B?SjUrMEZjOVorK1JsWEtNMUNIcUExRjN0UmlXVXhxNkQ3YTNWdys2eVZySzdX?=
 =?utf-8?B?SW41OFVrbVBzL2FmREJJbmFMZXphRXVlRCs1TWhHOUJodSs1ZGhKQjdURlYx?=
 =?utf-8?B?WXRwWnFQZzJoU2NaRHMrd0hDSnJMRDdqditPNC9rZDY4K0FzcGh6RUFTT2to?=
 =?utf-8?B?NCtnVVliUi8rTS9NUEdPenFqWG5mQXVvMnZjTkhKb1BsTU1KWml0eTlrR3RM?=
 =?utf-8?B?MjYzaHZMNGQrZVQ5SldWeWpvZXpudy96SHZVT3VhRm1jY3NyQTY3UlRNdW5k?=
 =?utf-8?B?L1pJaGovbEp4aldnYzIyZnI1bXJ0NythNUdkYkNZZUZ2RHBaOFE0bmFlMEkz?=
 =?utf-8?B?OGsvZjlGRUNwOGJ6cHpiQ29uYzhnWkF3MlFqRUp5d3RoZXRWQU9IZGNVVTFC?=
 =?utf-8?B?WEZ6VndRUmpsaVdiYkRJSUdCcFhNcU9GUGN0bnRSUXYzczRKeit4bjVZMWJ3?=
 =?utf-8?B?V3NydllCeXRBVGtwbVVSTUpOck9qZFpnK0xzRUd1YUdOYzZlbzU1aXFlYjJx?=
 =?utf-8?B?OGpJNUdVejZySFZrRWRjNGJjVEdNYnMzTlVDVjB6TDVRZWkwblpzdTN6MXMv?=
 =?utf-8?B?OXdGOTVhNEJZeGdmc2dGRVk4QUdCYnBUZjUxb01UN1BZY2FnNWpmVDBZaTUx?=
 =?utf-8?B?VFlseFNHWXl4UThYdElIWTFBOXJzdG5vbUp5Ymt0QzNncG5oeXNxekRRYkto?=
 =?utf-8?B?aXdsOUxBUm8zd0JyMElQMjNNVHFMblFZREVLWGhNOVIrNy9HRjIwSzdXcnRq?=
 =?utf-8?B?V21OOWh6Y3FvNU1FNmV3SnhTYTRCRmFPRnQrZ0lJM1JaS1VYR29VV2pqV2N6?=
 =?utf-8?B?ejB0cnk3ZS9INlh4M3FOVnIyTFBDNndxdHBCUlZUN2VXTjlrQ3g0Z1kzWTRa?=
 =?utf-8?B?TkVXa3N4SS9sNEszYVo3WXY3OWJzbTJwRHEzclRRc0MxYWJmdWRLZmw4NjJl?=
 =?utf-8?Q?u35/xrDCmDaQo6bMhsx9jzBU9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5729e7a7-a0a7-4112-3cb7-08db951ffd8c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 19:21:23.4338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6hNcxYnbAjJALvpJI+out5vmyGZzoF+odu15eotM9H9ylnqQkEx9lDz3thimE1QaT07j+blWojrqi/k+OMrQwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6775
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/2023 10:23 AM, Brett Creeley wrote:
> On 8/4/2023 10:03 AM, Jason Gunthorpe wrote:
>> Caution: This message originated from an External Source. Use proper 
>> caution when opening attachments, clicking links, or responding.
>>
>>
>> On Tue, Jul 25, 2023 at 02:40:21PM -0700, Brett Creeley wrote:
>>
>>> diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
>>> new file mode 100644
>>> index 000000000000..198e8e2ed002
>>> --- /dev/null
>>> +++ b/drivers/vfio/pci/pds/cmds.c
>>> @@ -0,0 +1,44 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
>>> +
>>> +#include <linux/io.h>
>>> +#include <linux/types.h>
>>> +
>>> +#include <linux/pds/pds_common.h>
>>> +#include <linux/pds/pds_core_if.h>
>>> +#include <linux/pds/pds_adminq.h>
>>> +
>>> +#include "vfio_dev.h"
>>> +#include "cmds.h"
>>> +
>>> +int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
>>> +{
>>> +     struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
>>> +     char devname[PDS_DEVNAME_LEN];
>>> +     int ci;
>>> +
>>> +     snprintf(devname, sizeof(devname), "%s.%d-%u", 
>>> PDS_VFIO_LM_DEV_NAME,
>>> +              pci_domain_nr(pdev->bus),
>>> +              PCI_DEVID(pdev->bus->number, pdev->devfn));
>>> +
>>> +     ci = pds_client_register(pci_physfn(pdev), devname);
>>> +     if (ci < 0)
>>> +             return ci;
>>
>> This is not the right way to get the drvdata of a PCI PF from a VF,
>> you must call pci_iov_get_pf_drvdata().
>>
>> Jason
> 
> Okay, I will look at this and fix it up on the next version.
> 
> Thanks,
> 
> Brett

After taking another look this was intentional. I'm getting the PF 
pci_dev, not the PF's drvdata.

Thanks,

Brett
