Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2C46BF065
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 19:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbjCQSHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 14:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjCQSHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 14:07:35 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D084EB4210;
        Fri, 17 Mar 2023 11:07:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2ULpo+busEXxVnGuFIOY9gXIglmgtKyxzJ+eRUACrXIaCbyrNJkw6JDiuWR4leiJSscWSIUJgRv8HmsEHvmlY8VYvVZASnZSq6bMznyIFwzjAZlEGXkNqHkhcTkLC/wN9gBrUg0bpRWFMVHQ+Ke6lIBgL007zFrefnYyMmfdt+OS95XMQNJVw3CZj3jPB7mSz44PAW/jkLoHL7WOpMos2ve+Y/+a1lXfzUCAaX/5TFvQThWcVHE5RP/gVesoojRAt8eMM2JS36mLRZ/Kr9j1FAw3TPTHXht5ViSOG5TNAvGXV00w/4OlqseTjbJ+09ppI+RNdqo0Z/WhNtCquk62w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3rv1/Yha0iQPYcOelk7B4mjzryJLb5l0YBYSRgG/rL4=;
 b=K0Q953+yp3ti6I9xRLPTJxZxc8E1A3/a6M87kv1WSTT7KP6qVL90r29CL0PR6+b3jtoCw5xxJR7yGGVf8M5UXf7NZrN5FT3UDGxK2P8VrxTSkhPtO8FwKoQq78sr5CRcOomdzW8lT24/hykoEpjOBI+xR3LwuDHjZd4DFaOmIVXrWDhL9MoIoTLS9H7kDAoPl6LNpodE57A45hB6Pe3jcqVujtN0e574n8k42fWolc3DuFaflUrnbseo5i0l+4y35QIbPY4/FbkGuTYRiJ0iHsCf1R3vfD9w3ZWNu/D0Llaa0PDTHmFMQCNB1uvpY/aKglDGDu1O/DsAiwWpzQVhVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rv1/Yha0iQPYcOelk7B4mjzryJLb5l0YBYSRgG/rL4=;
 b=2C9Tmh/cwNZdwZttW7PH+qMDsoa5V0rzKY/IG61847k0xX+V9bhYpVtpAkYWiYiZSuF+XqywZOHnWzm4zMKP6at3bmfnCJCS56dx/HWAgu+yEU790k+duE7q8/Lv53NNH9cEbI2gbY7u6oCpA0yshPoXAYkIi54q+yR1r0HBJno=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CH3PR12MB8583.namprd12.prod.outlook.com (2603:10b6:610:15f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 18:07:04 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60%5]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 18:07:04 +0000
Message-ID: <54a4ca2e-3389-dd48-1d1f-8b385fbfc0cf@amd.com>
Date:   Fri, 17 Mar 2023 13:07:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Does earlyprintk=ttyS0 work for an AMD SNP guest on KVM?
Content-Language: en-US
To:     Dexuan Cui <decui@microsoft.com>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        "sandipan.das@amd.com" <sandipan.das@amd.com>,
        "Gupta, Pankaj" <pankaj.gupta@amd.com>,
        "ray.huang@amd.com" <ray.huang@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <SA1PR21MB13359DBABC5625368E369A42BFA09@SA1PR21MB1335.namprd21.prod.outlook.com>
 <20230216091431.GA10166@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <SA1PR21MB13358707043E2901958819AEBFA09@SA1PR21MB1335.namprd21.prod.outlook.com>
 <e06d90cc-544b-5280-f8cd-b25684214b4a@linux.microsoft.com>
 <SA1PR21MB13352DCAA7371B90CB8A637CBFA69@SA1PR21MB1335.namprd21.prod.outlook.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <SA1PR21MB13352DCAA7371B90CB8A637CBFA69@SA1PR21MB1335.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN0PR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:408:ee::29) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CH3PR12MB8583:EE_
X-MS-Office365-Filtering-Correlation-Id: c160acbc-64bc-48e6-48b6-08db271269dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o/LBoUYkz3kd+Sgm/OoIdxu/vSAY+a9LTo76DUDwe2LJ6C7cJpyWVuooiVGX8jmcC6p/P5V8oml/RmTAWaOBRFzK1dPhtLn44BrBSK1gmWGpHg7t/ZIRVekoMsKt9SMEZgmakgY4hvz3JNwk6e3EXiKzI+FeYFyW+Pi7a8oeZqN2o1EE0Rt4gIUa8ZTmkvBMHneQ543sHwRvTDzQ6XoZlhahGHhsuNqRgxXNklsJtm07gPxkH4mWnKcGgZpgyUj2XRJmASMALvD4CRRJASWTvIlgxWg0BsgvjNdzCqtK5Gm8CoZUoyjdZlZ2tmkt96H6//30YhDXW8RRYCmVkMR/rcwJqFaZumDBK8abqwB1MLZJ5ChbaAcb0mxNRUBGsqZQk50WbgmAaGYZolZVa1LyoTtwqvMrd60ijE2yD45Rj1p6i+1eaAXRzD8sbhEmvQoz2C4kuYngo1t5oQvesO7i2KMfVJKqkY8Wpr3KY3lPmleJEwlkSV7sCv/FL/tsGciK3FBqZS432Wt/VyqdP2dlaHomAKHhM9sfE2wj4MekI/3W7gsAM3I05Y3NoLVqEoadNATsKopWjVb8buE23XpTUEPHAGpPCPM+0JHJtO1OCyY4MngBKQsQNph35COGqQl7LXC+pFIIAjZ7wLjWKkz55j5dXt39puMGRLUpMqRmryybgifg2qT0SBnUFUYW9kUqF1nlFC04so8MVRz7Rzwx76hVzJZE1x1beAonFLiG0ls=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(451199018)(38100700002)(6666004)(5660300002)(8676002)(66946007)(66476007)(4326008)(316002)(478600001)(45080400002)(83380400001)(110136005)(66556008)(54906003)(8936002)(31696002)(86362001)(41300700001)(2906002)(36756003)(6486002)(53546011)(2616005)(186003)(31686004)(26005)(6512007)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzI5Yk4xa3NyTjFaKzQzZU5NNXJ2SUNPNm0wNXpyelZuZzlRRU0zUXBrZFg3?=
 =?utf-8?B?VzhFVE1UaFJjUjNaajg5Nzh5Nk1KZ3AwU3lCNVUzR0NKa0E5V09USnl6aDBG?=
 =?utf-8?B?dkRCMW9PMFhJQ3B2Vyt4ak54WFloOTJyQ0hhY25LbnhNNGhXK2RlK1I3aC9o?=
 =?utf-8?B?SW9iUjR5aDE3dmsvbW9EQnhxdmFhY3Z3eGtweUJFam5ZTllveFFUc1NVMTFV?=
 =?utf-8?B?d1FLa2lOOU1yRjRLNEo4ZnBBN2hLTno1M2xwbDBjWUMrcitwN29ocVcvcEhy?=
 =?utf-8?B?SkNFb2JLczNRUnVjamc3UFY2SjZWaHJtdzd0aWhWV2lCOCt2VzdXZGxlR0wr?=
 =?utf-8?B?S2tkRlBENXFWM0pXdm95RjRVZENKOEJVbi80WEtPTVhZaWJrS0tWcGpzbUpO?=
 =?utf-8?B?ckk5b0h4NXNqdUZtRG5tUDU2alZvMzZGTjVieERlNTBjdlh6Z015RDVpbGYr?=
 =?utf-8?B?b01Hb3AzTVF6Z0VsangzSDlSMXBCcGorT3Y2YjJxMGRWVVpkMXpTdStCeFJM?=
 =?utf-8?B?bitvaFFmZkw2ejRlMGNsRVNiZkpvMjMzNTZkcitxWUp2OHh0S2dnR1AxT2Nq?=
 =?utf-8?B?OG5yTGxLU2NkV2k3WnJsdDRJVU9pcm91Y2hCMS9xQ2dlVmxMTGloejdQR0tr?=
 =?utf-8?B?anlGZlFyekh0NHpjU1BjQzluTlhWZmduSGtEZDRPaGFBUnNYT3lOeHI4OU9Y?=
 =?utf-8?B?MndCL0kwZSs3SmhKZGQ3NWs3azJsT2lHNHNNZWN0OStGZEZ0dDdmMmx6VTlW?=
 =?utf-8?B?UXpDZGZFNUhQVTBmVkFhTDBuVUpWMlU0MDZ4dmlNM2RhYzhoZG1rUnN4K3ht?=
 =?utf-8?B?OXZSSUtCMmN3bXZ0LzJxT3RwNExkMHBOWjRicHl3OUwxSnRCWnN5aUFYVFUw?=
 =?utf-8?B?QmYxTzRaeUlzUXdRYjVucUNCNCs5ZVdScmxPUzVmS2lNVFJ0djhJc0UraVhC?=
 =?utf-8?B?bUplQ1dKWHdkSFZNdmU1QWZDTE5rOE1ldFAxNzRTMnRMMGluR0paQUtCM28x?=
 =?utf-8?B?dW1WMm1WZlZPWm1JbW9SU1RHeWFJZUQ2WDVIczNuSzFzWWVQNWtObGpPQUR2?=
 =?utf-8?B?bW9pRGNFVVEybC9UaGd5bTFUQ3R2U0tFQlQ3TGd2ZzJWZ1IzK3BxNHl6R1ZV?=
 =?utf-8?B?eTR5STY2amh0V1lZOTZveUQ5WVZSM0U0Y2ZPZUwyOXZFMWR5RmN1MVF1NlpI?=
 =?utf-8?B?NGJBQXYraUhqY1Y5OXRkSkNBQWM0MEkrdmFKM0k2Yitid0tiRXlpeGthOCtV?=
 =?utf-8?B?UEJxZ1JSV1BmUUNEUjlyaHdTNXV0QVprZXdMbmVON1lFTHNVN3hOUWRNRFFT?=
 =?utf-8?B?bTJnYWprdXYwaEJ3VWtTcC9tSUdNc0JjNnU1dTFrcUlBMzIya2F0dFNZSVdD?=
 =?utf-8?B?VXdJSWFxTU8xSzQ0NlIvUkExdk5tckFPeGNiU2gxWnBRN3AvOTBPeVFnRFgr?=
 =?utf-8?B?ZXpjM1o0K1RoWlVLejQ4U0w1UGpwY25qN0t0cDUzT3QvaGlEZzRNaEtkamts?=
 =?utf-8?B?M28yc0pBT3NwNURnSkdhOWFpOGFxT0RXVThlSnJML2srZWx6OFZxNEtxUERH?=
 =?utf-8?B?Q21MZHlOb0l2K1dTTlNWcWdxbGFtNDBCM1NuZFhMT1VDbTNCK2lzNkdCNkts?=
 =?utf-8?B?LzQ3YW5qajJXQUl6bWRhdTZDb2lLd1EycG04L2psRWM3RFVqUWlOSW1SbkNF?=
 =?utf-8?B?dEVPRHlkaXo0bjJTczg4WmNmOVI1Y1lhY0RCbFA5R1IvTCtZMzg2bnBpUTdn?=
 =?utf-8?B?L3YvSGN6WE96TDBlVTlCaEk5VzhIMWJxWjgxK0kva1RkTGdqVklMa3hzazVR?=
 =?utf-8?B?SVNPOUF0VVR2M044UDdGU3FzME9iU0xxcHlOTVFqdVcyUm00RFN0aHJibDJX?=
 =?utf-8?B?UWtaUWpYODhmdHlROUR6UmR3YkgrU25FWE1tM0FaNXBEU3RQaC9IVVhZdVdn?=
 =?utf-8?B?NlBGeFRnOU13eGRSM29YTGNBc0R3TXc1QkJEMzBTYXI1WmxkQTJMTHhqazdZ?=
 =?utf-8?B?Z0l0QmRlQ0NJYUFZamJUakhwZnhHNkdCbVcweXUxV2NpckllZzczZnlyZlp2?=
 =?utf-8?B?d0xMeHc5ZVppQncxZkJqeWJtUHZQNXVJMWlsWVIzVkE5K3JoOS9KR2J6YWxC?=
 =?utf-8?Q?VGmAx1X8joemJd3JVT9EdqdVH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c160acbc-64bc-48e6-48b6-08db271269dd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:07:04.3779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6cx9CT3ZlU5kyQI2DXNfdBLEifiI+8dvcg9rTXZ5IH8MYZLyI2d8D3ITwBMf6A9eM0b6W3gK54eu+U1ifUN8OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8583
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/23 20:54, Dexuan Cui wrote:
>> From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
>> Sent: Friday, February 17, 2023 4:51 AM
>> To: Dexuan Cui <decui@microsoft.com>
>>> [...]
>>> The comment before the first branch says:
>>>    On 4-level paging, p4d_offset(top_level_pgt, 0) is equal to 'top_level_pgt'.
>>>
>>> IIUC this means 'top_level_pgt' is equal to '_pgtable'? i.e. without
>>> CONFIG_RANDOMIZE_BASE, pgt_data.pgt_buf_size should be 0.
>>>
>>> Not sure why it's not getting into the first branch for you.
>>
>> Sorry, I got two things confused here. The relevant part of the comment is this:
>> "If we came here via startup_32(), cr3 will be _pgtable already".
>>
>> Booting a (non-SNP) guest via BIOS I end up in the first branch. Upstream SNP
>> support requires OVMF (UEFI) so we'll always reach the kernel in 64-bit mode
>> (startup_64?), and end up in the second branch.
>>
>> Jeremi
> 
> Here I'm running a C-bit mode SNP guest on Hyper-V via "direct-boot" (i.e.
> I run Set-VMFirmware to tell Hyper-V to boot the kernel directly without
> UEFI). Looks like arch/x86/boot/compressed/head_64.S: startup_32 runs
> first and calls startup_64 later (?) This might explain why I'm getting into
> the first branch, which I hope could be fixed by someone...

It sounds like there aren't enough pages available to satisfy the page 
split in order to make the GHCB shared. Have you tried changing 
BOOT_INIT_PGT_SIZE to increase it by 1 page. Splitting the page will 
require an additional page table, I think that is all that would be needed.

Thanks,
Tom
