Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F1C760153
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 23:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjGXVkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 17:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjGXVj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 17:39:58 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181121722;
        Mon, 24 Jul 2023 14:39:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GahqJOd0BWBbZxB+HEmpbqPJ2f0PMI9FunWABGXoZWuW2ZFJ8U70JXU+YHuVZ1EeEKaNlzhwP6mnZ+Bm5xVPMJtYuMUMzTO48bq6/qn4ZVhvlZXZJCOYjw/gzCJLJq7XsEIjdLoir9bW9yCBFgzr1W7zJOnt15OIUBdXgAP9ICm27GDrFVv3RU6XoZoA/MmSyoL2LPo2VzKJlCgwMyp9BqCRXz7N/LrNjxPkdtYY5GJqpEQLD93/Q2U53ljOHhX/OHDtF2c4d7R1PBKTMhFoQy5eYmMPBrEqzXfHv4RQp5lAYXBtqIsCIOGK1WgKxAZnuDpTiwKPds5w8U87hDR1ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=loN9lMSGx7X05QJdGrkO0GAeIiG5ZvDRIiNKisMXQ4g=;
 b=VtKU1En/Pd18VWGOcplWoq2gpl3o/ZL8yqmBfaCfptTjzKDvNIIx+AhdV/laBYHG+HX3GHgX9cUzteaZfjVG1wL0piCvtgqyH/I6vzUcfhVkA1DA5QJJEEaT2Op7A8hyj1qt+etOrX3Hnl38rQM527yCtaUc728EeceWQvAiGIFN2muSdPfKiWLdt3rAqNOIzkLGI+VseNn3X0woaGmi8AL+OzM2AMrsilrkK/IpFtSqi1D4ez/eVh8E8uFRZ4e85EaQXxDy0aWJaltYvr4WIh/7g5qO6PQJ+v2x8qUm/7yGW4bG49dAKE/86OcnU6+umJmydtnrmBYiONEgccsUeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loN9lMSGx7X05QJdGrkO0GAeIiG5ZvDRIiNKisMXQ4g=;
 b=41ROh8IBqvjoTBfLYFPxSBiqMbEksytqnwezgo/SHbO7vdWumIzTzZLow3nuo+o4Ew5QHZrhURDXJRmCSs4fWXyjOXnBdVB2IRQT2ciGTDsVg2jXH0n7/UdcAoi+Y0Ekl5aN40BjSEAK73FaIwPFMSdn3AyIgzmpgjp1PEDxtoM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by IA0PR12MB8907.namprd12.prod.outlook.com (2603:10b6:208:492::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 21:39:53 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf%5]) with mapi id 15.20.6609.029; Mon, 24 Jul 2023
 21:39:53 +0000
Message-ID: <4a8e7c20-0556-6466-89a1-5cbe228ae9d3@amd.com>
Date:   Mon, 24 Jul 2023 14:39:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v12 vfio 4/7] vfio/pds: Add VFIO live migration support
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
 <20230719223527.12795-5-brett.creeley@amd.com>
 <BN9PR11MB52761AA921E8A3A831DD4A1A8C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <259c5f0d-24bf-dfd4-a1c5-102944aecd4f@amd.com> <ZL51Wl3lTD/7U1i/@nvidia.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZL51Wl3lTD/7U1i/@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::9) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|IA0PR12MB8907:EE_
X-MS-Office365-Filtering-Correlation-Id: d98f3df4-dbf2-4427-5731-08db8c8e842c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q5eMThRIQ0JGPDzJgmq9ewWemHruhBYnuFNK/uWeMnJulQQHnUhp4nQ3im4uXAVJOFzOsPjE12pJTR8d10BVXXNoVAQ9krquWK3vdUENPIT5MFzr7PQVm3V85jBl2GivUTXDclwtLRO5o2bh2YDw9iLyY0w8uDnAJjyxg76ZuXPn0CcPukFg3VWWEOy/It+FGU90J2D4YU0QuuYBD23OWKQ307bafcQ5yxWI9hDqAA+q7x8eEUfcJoHw1SYDwXkfxBksTu7Lw7l/ZjhK/4W/N4aZK7p9+BzHqRbgXsZp+5UnUCLzCZ3Sq47LYPC45+A77j9S/qkE2LetryFW1wRSSnS314AyQzyWdl+DLCvVmeynEFAC7uqvd+GG7brlzYegugTpvrDPyrXRiW4IJNVBDJzqDy7VZmmhXYYl+7Px+kcg0o+P94lpobQPsY21o1C2DNDk6Q5yVI8Jsm2wTahfWDr3IxnmbSaQB/kxMIPjaY8vnMi561KvVZYPTK8/bep4mRgddwVEEUd3exEEYz1v32EhWQnzDTZHHWZ63WJIAp7BnhWs6ebQrCSVJDn4moaat5BppCszwhRJ5dHfyHJ/+2CxtDW0gSBfNtu2KvkfsYIdqb2G9glA+DLNdssaM9B6sHX1u7iICWEViBFHfLDglg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199021)(31696002)(478600001)(66556008)(66946007)(66476007)(4326008)(6916009)(2906002)(6486002)(41300700001)(6512007)(316002)(8936002)(8676002)(6506007)(26005)(54906003)(31686004)(5660300002)(186003)(53546011)(38100700002)(2616005)(83380400001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emdYY2Ewdmx4U1pnSVpIVFVWbUJiaUNlb2d0aEg2OGpPdjhnOENwTlRjM0lF?=
 =?utf-8?B?S0xMSnpBWTJ5Z2lYTndDM1h5MWFFV2tINGFtVXUvTU5ZbEZiV29OQXhJNUhv?=
 =?utf-8?B?NStINFZqUEZmUENvbHpLaW1jaGtqRW5NcmIvcUxqMVRaUEZta0hRaGJ4OTJh?=
 =?utf-8?B?QkZVSFd1cVdpQVQ4TUdSbGU2YWxUZUpmcHV1TFBkeGE4NnV3Q1c4Mnh0TlpJ?=
 =?utf-8?B?d0NZOHBoeUFzZWkwR0FkYmpRblphRjhVS1NZQVVDV3ZjenZqVjVmc1NwdS9z?=
 =?utf-8?B?dmh4SGlMQ2pxa0F3eGNraG1lT3VhL3JnMDd3djc0QUpkZ0c3UVFNWmk2ak9Y?=
 =?utf-8?B?TkNMRjd2Z0grUTRVVTlJOFA3OHVTM3l3ZWV4UE40QlhXYkozV0VEdWQzYXJm?=
 =?utf-8?B?MFBXSTltaGE3cWxtUGI1MGdEL25wb0YrVEFLTWMvODhXVksrYXZOQ0pwR2k3?=
 =?utf-8?B?c2FsaG5FY3ZrMWxnY0lzV0pYT1JWd3Zja2JuSUZ1VlJzcGZoR1l2UmZvcGNC?=
 =?utf-8?B?YjhtcjY0ckJjd3Jlc2xOTTF1dVZFMU4xcG81cWFwUGFUZUxMUzg5YmtMNVBi?=
 =?utf-8?B?L1dESlBaOXAvb2hRcHBBbWhZWVg4NDNreWY2SHV2ekdCeGYvVU5kS0lZZDJr?=
 =?utf-8?B?U0VsNUNtVzR1WkNsVlM2RzNmaEphVE42Ty9EYnl1b2xTZWk5R211bE0rT2w2?=
 =?utf-8?B?YXpDSjFOTXRTQkE3N0FvQUY5UVlwSjh5b3ZZOUpjNVl4VGpRUE9nbFJjdVIr?=
 =?utf-8?B?VGxzb2tMZHd2MlhIc3QrZmt0RlF3K3MvTnd3elRxTDhWTVlYNVJjNm5ibk5r?=
 =?utf-8?B?VktUTVkyczV4STBXcGo5M205RFJtUFQ1V2R2SjJUM0tqb1k5ajh1WFZESDJw?=
 =?utf-8?B?a1NQMlBBelpyVVJuSXRIUG1NeFVPTnlWbUs2VURHMk9BamVKR2xQSFZnQUE0?=
 =?utf-8?B?ZlozbjJXVTYrYk9OSjlrSmFCMUVaOVpOQWlRSGh4eWpYeDBNUjM0NVU1TC9S?=
 =?utf-8?B?MDhGL2VBcXZCcGNHeGlvM21od3ljeHdJbkh1dTdJNlNDa1czVmhRemVjZUZw?=
 =?utf-8?B?RElzYmFwYi9lZXJ3cDdsYWFvcXhkUU0xcllZR0xaZllvQ0FOTkt6cnpyVk0z?=
 =?utf-8?B?SHNRVGZRaXFuUGtxVDUvellCWERSM1l5Nml5cWl0MUV2SzJOTGpza2tSYUUz?=
 =?utf-8?B?YmVTUkxVLzZMRERObnZEYzJLYStxQmpRT3FUS0J1a2dYTzN1SThIalFBSlpY?=
 =?utf-8?B?S1BCTjVJQnFUakhuK2E0dWEza1ZaMGhDNjVlVlozWVBOMkx2WXJXT0ZiRndC?=
 =?utf-8?B?KzBJNXZPU1R5dXJycklla1cwRlRzL0V3djdERDJTd1Q0TXJBekRQUkI3dVZq?=
 =?utf-8?B?QzRvZ3FpMXpsdit2TGt5citBNnROWnZ0SUlENFc3TnJtM2RleG5zRGJLVW5C?=
 =?utf-8?B?dkxqMXdXcFB0N2tQcXBRdndqNGFhR3EwNTVEcWd1ZFBqcUZXcUp5R3JYVnlJ?=
 =?utf-8?B?S2dWQmducm4ySGhOc1pnMndsMDh3d3lPeWttQUdEOVVGS1hDS3NsMHpGYlh4?=
 =?utf-8?B?bS9KRjNxTmdleVZQZ0pTZEcwNHlFNWUvTkJCR3RiNWZ1QVJSN2xmTGplWXY1?=
 =?utf-8?B?MTJWKy9uYlVESmprTXFVclViaUk0MHU0ZTM5TEhpT3ZycjBFdlpDTnpwMEd1?=
 =?utf-8?B?QnFpbGJ3L0liZHNzNlJ1T0V4YUxOUW52MUN6TWM0czhleFlEZ1dNWjhxVGE3?=
 =?utf-8?B?VVl3NnFvblJPbHZmZThmdFVnU1hwQkcxaDJUMWtyaUV3Y2t1bFJCYzZQbXJk?=
 =?utf-8?B?RW5vR0phc1FzOVpFM0NOa2NDOGY0dUs3Tks1eTRGUTc4MnJlc0lrekowY2Qw?=
 =?utf-8?B?clMzSmlnTE5pQnpoL1czUElqakpDT0tCcWxZVzBRYU1ZdG0zemJPcThuaGZ1?=
 =?utf-8?B?dktsY3RzOVhJNkhsUVF5ZmMrM1hUNTdEYXQ4QzlTUnhHUzVSMkhMNHJOYkQr?=
 =?utf-8?B?aTJQL2V1cVJQcnV1MFVkSGZXZ3hHa0ZodEhBb2FOVjF2bThoMHh0Ui9JZ1JC?=
 =?utf-8?B?cCt3MmZTSzRlTnlxR0paZlo3eW14VmRKTnlIZTA1ek1RTVJGOXU2SXU0T2Ji?=
 =?utf-8?Q?RQ8ENEumtrfgDQKm1IQiDxIwG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d98f3df4-dbf2-4427-5731-08db8c8e842c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 21:39:53.5150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U1OZbHx4cTLwheWTwIBzwEClzMLq3B+CQtZIAl8RhSp4jMVHK2VPZU5n0MGZ0zoAGwFs3A/G7ZeNtFJV+9RpeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8907
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/24/2023 5:58 AM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Sat, Jul 22, 2023 at 12:17:34AM -0700, Brett Creeley wrote:
>>> I wonder whether the logic about migration file can be generalized.
>>> It's not very maintainable to have every migration driver implementing
>>> their own code for similar functions.
>>>
>>> Did I overlook any device specific setup required here?
>>
>> There isn't device specific setup, but the other drivers were different
>> enough that it wasn't a straight forward task. I think it might be possible
>> to refactor the drivers to some common functionality here, but IMO this
>> seems like a task that can be further explored once this series is merged.
> 
> You keep saying that but, things seem to be getting worse. There are
> alot of migration drivers being posted right now with alot of copy and
> paste from mlx5.

I understand and agree with what you guys are saying. However, I was 
also asked to simplify this code for our use case in v9, which I have 
done. I’d like to get this finalized so that I have a chance to get to 
the next step and maybe work with all involved to define what can be 
commonized and how to get there.

Brett

> 
> Jason
