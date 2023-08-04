Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55D67706F7
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 19:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbjHDRXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 13:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjHDRXU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 13:23:20 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378D21994;
        Fri,  4 Aug 2023 10:23:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+T3rHr9jgfxhAVqzqhK4h5BOVOSvyGOcevri7knXzWLASKLUCVHz7E6zMpQnLkpxYbKoZnB1YiBwUArXgIZrtK3MV6i2bBcaG2OSn3n12hXwWLgHk/OqTwZOaPCyYB0Fvz2n3rYIZ+L3sZt1K1oQ9orIjJGdjpOXxhAyGfY9dln/hxti7Su4kB8XB5Qg2eKXTl3xLtxUqz7iGxl2moaAtdmHVnbAJh/phFNtL8kJR/mPkpkfczrdTxsUnsytAFlkzlwPujzH+16cVS1dQ9CzsxEU2pinbk5hguqBb8BdV4MyDu2memw7rZi6j/13XDCVWMKcRnATfqJQiNg1ybA1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mHL6DTh3jwDZGW/LLOiYzhfFQpko9c9QYdPqePz/WHw=;
 b=jmM4WRtbrI2hKF8SNIoneKs7qB9akzhSEVt3PJ14iIz6qEQesAidSD9/+B4OQhu1BGr3jWMwOWcLYzaaZeDScQbOb5gYe8GrfaxnBvX6HMxurfuXI1h4fz2R+u1/8lobTDcW0UNZ+WbWn6fWB1zdKjcaweJjRetfpqNJ03YmCUCjUF+xBKMLjR+PCvfyIwAi3/azb0G6KleCiT3tpEhPSXuYeAHVbj0yKXOxnBGRKNsIX89WDjeK51kxnY3EhR0lSEZyTzsdKWTLHcCPLuHADIcCcTXBByDoyyejZ5XzyTFA3kFA1d9zW3zrEzx99nKl6VVt+AUcE18sH1yLyZfOdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHL6DTh3jwDZGW/LLOiYzhfFQpko9c9QYdPqePz/WHw=;
 b=JRvqkh03U41Wb+VgWfmLxDisQNBCDxQUQ7k7I8EJh2KiF+Fq+lKPYTvnXtwBOGIaD9WmFCTjWvYgRlobmOMmWHlBqBLI2c8bX53CYlTV5ZGEPrfSBY/o+WmMz/kvfI8Wx98Q7rGHgXY32Qtzvv1f5Nh8hAGmrUPhX2cdPaxzcLM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by IA0PR12MB8647.namprd12.prod.outlook.com (2603:10b6:208:480::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.31; Fri, 4 Aug
 2023 17:23:16 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%4]) with mapi id 15.20.6652.021; Fri, 4 Aug 2023
 17:23:16 +0000
Message-ID: <44535ea4-9886-a33a-7ee2-99514f04b53c@amd.com>
Date:   Fri, 4 Aug 2023 10:23:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v13 vfio 3/7] vfio/pds: register with the pds_core PF
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        simon.horman@corigine.com, shannon.nelson@amd.com
References: <20230725214025.9288-1-brett.creeley@amd.com>
 <20230725214025.9288-4-brett.creeley@amd.com> <ZM0vTlNQnglE7Pjy@nvidia.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZM0vTlNQnglE7Pjy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::49) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|IA0PR12MB8647:EE_
X-MS-Office365-Filtering-Correlation-Id: 367bf8d0-81f5-4387-7a43-08db950f7d73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y5DJmunBiOMMLePcQNRZn7LdPQrwwwJUIeqjxabR76xZ1qn+akLOpFHJdg0reC3/HYoIB78Xy948/QE3b8WBkOOYBJ1RIt6I67AZBpEkPgVSozP28ODDpPTRaJiiTJYnvsSQ4z28kufoIwyOTUVOcVpVhU+1rsh+3EeeI0R05ZSd7RTOBPy7Ps1udpBK+6IK/NA7UzkOQQeVWienNMeUG36ZbPMMWub7Ly1tqVd145y4R+RBugfO89okya4YfmMkB+ld+WlbtiXPpsh6uWaK4o7PoCVAA6XPuD7Q8VT5zpwFZh9CNMi1aL3qSoWge8QM4tNRXvg6iHbj8cB3e7qDsH6kPFLTgGtVyX4k9aBu6TNgb6rT2os+RvBKGXPP6qpXlAExwn8FWBmPSUnx/cCRKW/kjBfllGvMSgBiUuFS0/HfszkAIoDHRBvdb6N+nKIAX1joJIzBsFkuTlavN2FRuNyRiC3fQCHXelnVCirA4QMhk3Lzw3KYOj358d2gB9t377WR3WDIsGaZKF1LL5CsHFRP6EtytxHqjxrPZHhU9B/guzP4OhKfYxH0mlgsHNe5FM0rjCN16UIeZobXzDa+Tt2QXO1N9mbkZsyRUXB33/JqaOLxGoYm+Njoekzmg1OUPPTMzLnc5k2RnuIA+x+PCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(1800799003)(186006)(451199021)(316002)(6636002)(4326008)(66946007)(66476007)(66556008)(5660300002)(53546011)(41300700001)(6506007)(38100700002)(26005)(8676002)(8936002)(6512007)(6486002)(478600001)(2906002)(110136005)(36756003)(83380400001)(31686004)(2616005)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEpoYXRhUTNtcVRvelU4VnJxOHBWTTkveUY3eUZWcXgxZGJqUmJybWNDcDFL?=
 =?utf-8?B?OW03Z3UxTndDYjdDVzdZZVZqellyMFIzWkRRdEFMeUQ4ZXo5empIVExTV0l1?=
 =?utf-8?B?dmtqL0VVd0RtbXFnMUVUNFNmY2svSlhxcStXNTdQTEJIT3UzMytUVVQ5elVi?=
 =?utf-8?B?Q3JJTWplLzQ2YlVOSnk3VDBXRzRnQW1kZmdwS2IzdzhQaFplRG1iRU42T2du?=
 =?utf-8?B?V3BoYzlmNTYxeGNwZXJYYkpXb21tdFdIdGE1QmRZdFZGM3I0NVE5ZjgvQW9C?=
 =?utf-8?B?UWZsN09lTytiWUE2am1sNitXeE04MGkrRnhPNGFKZFAzLzJidElYMHNDcW5s?=
 =?utf-8?B?SGFkeWtrUXE2NnF5T05KUjRsNnhQM2pjUjMxcjd3UUFwb3JrcXpYUXMwcHFo?=
 =?utf-8?B?bHhBTFVKcUhVTFNhdWE3QkkvTThBSWFTaHRhai9OQzFZVmIvdStxN2JsTFRK?=
 =?utf-8?B?Z1EwaHA0SHJEWGhUZEZaUG80MXBiT2dGVUs3di9CYzNFTWFTLzYvamtIUUkw?=
 =?utf-8?B?RmppOExNa1pGQVBoUENvT1RBSzIwazBISU5mMUdPUTJZQkI0a0F2aFNMamlT?=
 =?utf-8?B?U2R1Vm5GYlVueS90cXZsSGFMdHcrRWhWUTRycExFWWlKS0xRMlcwQ1grWDYy?=
 =?utf-8?B?TnU4ZHpKcXN3T09JTnJUZnhqTUJZYmxReXhibEJpN3lSSkczeVRlbWY0RFBI?=
 =?utf-8?B?cXBzNmlqUmxCVGpJcEg3cmVOQzY2dndPaUtxV29xRkxFUUFUeWVqTkZrRDVs?=
 =?utf-8?B?WDVEZ0xjZU91YnY4V1d1VWVUMEx5dEVxMnJ2TnRCdTJiUXpPT29pODBiWWxO?=
 =?utf-8?B?NFpOMmRNbmthSnRJVDVvTGkycVJ1QWFOcHNHOVh5LzJyYlhVZ0NQcDBEVHNE?=
 =?utf-8?B?cFR0cmFnTW10UDk4RHg4aHBiT09BMS8xQ2xRUlh3MGN1MjhhMDJscmJwUHJl?=
 =?utf-8?B?WW5NN0xsOFowbjMxSXdqUFpIVHE1dGVNMzNid210ZzYzVmZmQ0VRVHEvbldv?=
 =?utf-8?B?V0l1Nis1RDlsdXRVVjYwamhTcDNGdENuMjdFRUY4VStiUU9ROWQreHduY2dF?=
 =?utf-8?B?d05mYzNtRDVFSmk1NUhLVmdpOWRJQnVJd1pCSTl6MHdsWSs1Nlo0dzZTc2FH?=
 =?utf-8?B?Qis1MkN6MEtmaFBoWXJueXRRa3hIb0FIV3gxN1VvSVVmUHhaeWJWQWM3QzU0?=
 =?utf-8?B?Y0VWR2FqdXFpVE96NWUzL1dKRTF6K0QrRlFYcmZVeHl2RUwvaDYwZS9TZE5j?=
 =?utf-8?B?bzhwSGcxOEFJYVNlOVpzVWVUSy9IZlNqNlNqMkZKRnV4YVg5UWlHcENqZURY?=
 =?utf-8?B?TFVJbGhVTjQ0cThsaW80bkYvbFdDMFMxcFB4dFozQnczS2tMOWdhMkRsWWp3?=
 =?utf-8?B?SGdyR0hXRlIvbkVHakhBdTExaXBlUGF3OGs0SWkwem1PT2JBNkVscXkyRFR0?=
 =?utf-8?B?RE1FekttQVFPaGxCQmVXVi9QVjB4TW84SGY5TXdpN25wRFZldzNadmJ0TFJQ?=
 =?utf-8?B?cUwvdUsxYXVnTFBPRVQwb3pEZWh1eldHR0VTZGNOME9GY3ZzYTNENDlxRVJF?=
 =?utf-8?B?UG1TU2g1ckVoSW0yQ1RhRmQxMXJuSVJTMy9LU2F4eHpkMUxTRmZmalZVaFl4?=
 =?utf-8?B?bHdXekx4U0hYSDJNMHlRK0RYWE9TS0FnVWc0cndaU3E4cUxXSWM1MGZaSzZO?=
 =?utf-8?B?ZWRyUXM3Y2N0dWVJdmFFcnpLcWtEWTNTRTgreC9TYVd4eGlrdUdiTWYrZGpo?=
 =?utf-8?B?Ryt0RW9HN1c2ekthMHJuUnUxbko2UDFUNXpnRENDQjJWaHhUbzRGT2g4eTNq?=
 =?utf-8?B?RmRRc3Rla2FIaTVXYmpiMkZ4Znc2MDIrNjFuWnA2Um5JekF5YzA1cTV0Y0JD?=
 =?utf-8?B?ZGNodU53a291MVJvMklwWmRCQzBianluOEVoWHNxeGNCaXdBU2xZOGRDY25O?=
 =?utf-8?B?RUFtcnFYcTBtM3ZJaGlFL25RRkJ5M04zN3RTVDN2dFlTa0hrTHpKNGhLM3Ev?=
 =?utf-8?B?RFUwY3hRVVpiRU14OFY3a1hEVndQQmdDK3YvYlhWaWlydEpiSGhPemZDWU1q?=
 =?utf-8?B?dG1VVHdybXY4YTdabEEvWHROdDJaNG5LUExOZVMwcnJEa25POWIzNFRhS1Yx?=
 =?utf-8?Q?FuSg9d/9RahGczQXthm1uIM/c?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 367bf8d0-81f5-4387-7a43-08db950f7d73
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 17:23:16.5992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 36djnko5L8JU5jfOMOM07MJ4mw54IQKae/EyKDnd9a8G2o0IXv4cFzCbiV1ZEiu4Z2s4XLVS5bsDtiN8+i4iKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8647
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/2023 10:03 AM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Tue, Jul 25, 2023 at 02:40:21PM -0700, Brett Creeley wrote:
> 
>> diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
>> new file mode 100644
>> index 000000000000..198e8e2ed002
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/cmds.c
>> @@ -0,0 +1,44 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
>> +
>> +#include <linux/io.h>
>> +#include <linux/types.h>
>> +
>> +#include <linux/pds/pds_common.h>
>> +#include <linux/pds/pds_core_if.h>
>> +#include <linux/pds/pds_adminq.h>
>> +
>> +#include "vfio_dev.h"
>> +#include "cmds.h"
>> +
>> +int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
>> +     char devname[PDS_DEVNAME_LEN];
>> +     int ci;
>> +
>> +     snprintf(devname, sizeof(devname), "%s.%d-%u", PDS_VFIO_LM_DEV_NAME,
>> +              pci_domain_nr(pdev->bus),
>> +              PCI_DEVID(pdev->bus->number, pdev->devfn));
>> +
>> +     ci = pds_client_register(pci_physfn(pdev), devname);
>> +     if (ci < 0)
>> +             return ci;
> 
> This is not the right way to get the drvdata of a PCI PF from a VF,
> you must call pci_iov_get_pf_drvdata().
> 
> Jason

Okay, I will look at this and fix it up on the next version.

Thanks,

Brett
