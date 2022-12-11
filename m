Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A096494BA
	for <lists+kvm@lfdr.de>; Sun, 11 Dec 2022 15:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiLKOvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Dec 2022 09:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLKOvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Dec 2022 09:51:17 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC86BF63;
        Sun, 11 Dec 2022 06:51:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gU93HWk9irJZPfIugWu031dFg78wVh0Sl7cdmBba47aC2GRSzlQLfm4v2CBjNUAj17oS1QxUbbwSpplHqxfufKp6BMEM3awSwfFfRy/pDuqv3gFAMGv9m7Sfqkpi/rtvNzrgwiDlK/E/T76sXaNbZRtdpcBN4TijXe3pNvJp9BFQFXtcP8GpxkJDf8c7IFEdXLcRQ5hUM3XGU9Pw2waRFcXpINmfdIvMoo5AgdaMUyPsyESUMTRXEjTYoU0wWaq0S4hxQ0aRyEAD+NG2HBIKPrp+ROPVNdJXz1zISEChyar3ioXxSkfq8PQ5b7PQ1c5lNTfBngwJlguBi3hkqz3j/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ug+wqDOips3Wp5XlWj4LkqsigxLvN9OKXPvMr6NB2a4=;
 b=YEGY0AEGvt1+NDWz1hBF7qMpZ4nGiYu/zGX/nbNwI3QzkYrJn7QhqlnWm4vUGUWeVgWjgGN15CtuFAPZBiNUZIGOkCFta+/2uJ4oGt/nJWrLglfO/ys5r+5KeRLmAU+yKl0ZK6niceImLuFYA5o6eAu+TZnm5IBwqH633DoU5QTPn0hoXT+o04JmZEypRlzgMzI7mSNLx2oj6Fh2H9Up0xtk2bOezM6tJzU793TAT7Hjb0sCuvqgookAnciwO9Tf8hokwoHnka4GBiKKLlBWJxEoIrCok27QphHhqU8A8tZgY8evLGhWHn3t+Xy3IV06bGbY1YueH5pyWmYriZxCYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ug+wqDOips3Wp5XlWj4LkqsigxLvN9OKXPvMr6NB2a4=;
 b=GQxtNSk0rp3V8/ak8WdRF2wjPhbgCq6s7rdVp/DplkbQA33WoFXZUpiRRIPnu4rwnJGV3JZMQLU2QRL5TukZyxeCgIL7tPDq64MLbvlXZ9h6hTE7lg0n3P+M9/JEDLuYtXQ/axh30kubIRHvE4eqXhvOtj7fYIwIgC0jU15CZKxXdQ+8B/5nHI7VE2GriSW9pU+TLaXDSgjSa6yjyVQxwcdYbQEDfZ42UiOacwl3cIeLYRoXtKhpHHQsvRMGkXlbTjrvVvKLfWj6FJiewOd6gvsvF7KKjswhOfKC/ccc3XcONldoLDmtBxLZsujIsclm9xqpFxt/HxAd479NNygIFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by SN7PR12MB7910.namprd12.prod.outlook.com (2603:10b6:806:34b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sun, 11 Dec
 2022 14:51:13 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::3fb9:3266:7937:44fc]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::3fb9:3266:7937:44fc%8]) with mapi id 15.20.5880.019; Sun, 11 Dec 2022
 14:51:13 +0000
Message-ID: <d4aeda5c-d7bb-4427-5157-fb7530dfd1fb@nvidia.com>
Date:   Sun, 11 Dec 2022 16:51:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Content-Language: en-US
To:     "Rao, Lei" <lei.rao@intel.com>, Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kbusch@kernel.org, axboe@fb.com, kch@nvidia.com, sagi@grimberg.me,
        alex.williamson@redhat.com, cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com,
        Oren Duer <oren@nvidia.com>
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-6-lei.rao@intel.com> <20221206062604.GB6595@lst.de>
 <Y48+AaG5rSCviIhl@ziepe.ca> <20221206130901.GB24358@lst.de>
 <Y49JNvdmRPNWw26q@ziepe.ca> <20221206140002.GB27689@lst.de>
 <Y49PqoAhZOeraLVa@ziepe.ca> <20221206143126.GB30297@lst.de>
 <Y49WNo7XWZ2aFfds@ziepe.ca> <20221206150131.GA32365@lst.de>
 <9bc8e614-a687-e419-f9fd-e3177cfb41dd@nvidia.com>
 <cf88c2ec-bdd6-1df3-6c77-64a17dc3eb86@intel.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <cf88c2ec-bdd6-1df3-6c77-64a17dc3eb86@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0463.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::18) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:EE_|SN7PR12MB7910:EE_
X-MS-Office365-Filtering-Correlation-Id: ec24db79-8acc-4860-9073-08dadb872564
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TVqnQAbOm9kvYlP8rNb4U/k6P/szIfmIs1gdFGYV1P0nm+Yv/Q+LU7lCGYsDTr+YTuwZKh8qlN0zi/4P33AIU11hpTvxYXrkg/DHSp703qSECHALc0OiMbCZLwUi1OgnKsUKbYLtV8H9PLJFMVEEO8R3pl17WrXYktOKtl2qG5o6iJq1PxpwZoqODgpDG1TfuJbgj+9gnE2eD0YQ82GYtZ828me+jQwyq1E/REBMajr/pkNZ3NT1bzWD0xv7M3ZgkzCSw2syeyuRGpXctsjBouSR6r0lSQswbGCPPxG8nWY1yYLYQXz7ndKiPM1RxhkH3uElMitwmOhPLndECPX+VQsYMK87YR6O5lO2R14DLK0QtzGbjSx9lZi1UmyzFdQ6Up6pinrKCi3zl69QURvjt2EskDCG/mtHYNAutbbKl6w8v0IxwZungexXTuIl+IQwC6Rb04U3ed7TaaEHsVFC33P9wyb2+OvuR3GvNMKoPvJLz5gFDz/H76Aw+2QP4MeY6y/991CTD+dZmQIejPH6eRAdtQtqVQyfbl/XLZ8B8lvhxuiDYEdbWdq+Sqm12gOl3busm4XXSkg9rgCLWbfSPypFEBdYYxlKK8os7xKK6YEWNMPIVmkS22RccOvs+KQsn+OWIc+sUO6n2F/QSmZ+hciLkooJpHFxUSTzgHx8a0GXxNCOGNQMBoOB0PRd7dNBbwLYSLzku26DXzHhxo0f+Ozs/G+q9m5kGM/KLtWD25M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5040.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(451199015)(478600001)(6506007)(53546011)(6486002)(6512007)(2616005)(26005)(186003)(110136005)(66476007)(8676002)(4326008)(31696002)(86362001)(2906002)(66946007)(41300700001)(83380400001)(316002)(66899015)(7416002)(5660300002)(6666004)(107886003)(31686004)(66556008)(8936002)(38100700002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEZob3IyaFl2TkRxNkxRcno4bGJFVGNYR2NmbEo4aHBqRXB4OS9HOG9veUg1?=
 =?utf-8?B?c3VRdTkrZnZhN3ZBd2NxOGI0VnBodVcxdFVNL0JVUWJYVGJkNHhydWlxNTdN?=
 =?utf-8?B?VDIyYjB3LzhIQmJmRExKcnpZZzlRdFVCN3I1dlczRDJzK2hUemwxOStIUXNC?=
 =?utf-8?B?N1ZlWTRUZDB5Z0tkQytKcUZ5aDhvdG9yc09XVjV3V3dnUHp0NjB5SkpybkI2?=
 =?utf-8?B?S2ZIL21MV2xBT2trNFRLNytJV2NzWFYxTWUwV1NRY0VGeHQ4TCtPWVQ2SWtM?=
 =?utf-8?B?WG0zeWd2bUVZKzVJVVJ4UUFSb2lDelFMRVFZbStvY3NRZElwdXJkaFFFbG1U?=
 =?utf-8?B?dnkwRFpZWERRVjZ5dU50ZGdjLzV4bHNQOUpRY1dkSE95aXNHaGhMZW9ZSkdp?=
 =?utf-8?B?ZGNQVXJiWTIyQ2E2TEJMMDBIQlZiT3BvZ0VsZVcvZWRtc1FHcEZ2Wk16dHZN?=
 =?utf-8?B?S3VZa05WbkRxaXo0dGFQNkEzZGNYYitQOU9oSHAxakI4anBvWUowQTExNlNC?=
 =?utf-8?B?bjNrVTlVd21YVXl5MjVCTGRkWUNidlYxR0tTRTdWVVZLekZabFN0U0lwQVpU?=
 =?utf-8?B?U1ZDTlBkK1kzRVpjWkZVMlplQUIzN1lBZUM1WWMvM3dQOHI4NVJtZjhGWkk3?=
 =?utf-8?B?OGdRQTgwNkpJRTNISHJFdDNGTmRrVkNDUWpxU1J6Uy91NFlYTU40aHQzOWxr?=
 =?utf-8?B?bGc0djVZUTcwOTZXZmJmQTRydS9LNlpiNGJYWW1VeTVFV3FOb2IvVWdqeFJv?=
 =?utf-8?B?MVpkbjR6d3ROeDZtMXdNeDc3MGluL1FlRTJWQ013NTFhV0tuVytIbi8yNU84?=
 =?utf-8?B?b004S0JjcXQ0VTE2V3FOckxOK2xOajRncWpDcEtZalFhYXRKbXpTbzhMVTEy?=
 =?utf-8?B?MnBVREhrQUV0S240WC9xejExcnR3UmRQalpOK0JldHpOcmVyUTBxQTBTdGxm?=
 =?utf-8?B?bGVML0MzWS93eEJaV3k4aU1qRFhnYmpOU0hJRHRQdlY2S25rOXk3aXoxZHJW?=
 =?utf-8?B?UGRXRFNtN1RUWWx2TEtUZFE1blBZYk05ZXcwZTJVTTNHbHVSelZRMUx1WmU1?=
 =?utf-8?B?V1BRTDZla0piNlVjYVQ5SWdkSG1FS3lsM0xZNFpHUkpXT0RCd1piRnQvbU9H?=
 =?utf-8?B?Z0tEdkxSK2ZsYXRjcDVFMGhPL0hmeWdMK3BGejlPRFl5OUVJNVF2RUwxQ1RY?=
 =?utf-8?B?TmVRcXRJWGxZbWI2MGM3NEY1M2VzTUkxMnFEU2NUeVorZUgxblIrUjc0Q0tF?=
 =?utf-8?B?dGNJMm9SS1cxMFA3U3V4SXMxdEVVMmNlSFdUOVhvbm1raDhXT0s2UmxMcU5M?=
 =?utf-8?B?NDhtazVIZ25tUnhYWmZGTFhEQUJxL3F4b05hOFRYbHJob3hnMG93aTJsd1pF?=
 =?utf-8?B?ZVEwYXFlVXI5YkZZQVI3QXpuSk5LQnRyS1lRQUVOaG9hYU00UDJWMG9zYmlw?=
 =?utf-8?B?RlRETUFrdWdlL3VHN0hyMzU4aDBTN3RmSnZvVkZBNTBzT2crUlVDYVRlQ3lH?=
 =?utf-8?B?aG12T1VmWS9nY0ZzdElUaDhhems5d0ZLalhMZ0M4TllYSllOTmpZZFlUU3lL?=
 =?utf-8?B?TGFmMHQ0dDMzdzZyek9UallNaHA2WnJLc1k5cHhCNVR3TGZPMklVWUZYN3VC?=
 =?utf-8?B?Q3paODA4bWk3eC9ORDRVdkhhaFlxV3E0Z3gyQ3JTR0wxMktxZXFHNVk2S0g5?=
 =?utf-8?B?RnE2TUc1dXRDOGhsam1sREFQMGNoTkJLWFR1TWwwazlTUE5jVGpCK09WQ0VT?=
 =?utf-8?B?WHZRTGZtb3JYOU1XdHIwWHdseDk2dStCa3U1NkJSM3FrTUZkQUliMzY1Ti9h?=
 =?utf-8?B?NzR6SitPUWEycmxOczNyb3RXcHR4YzBhL0dBTS85V2JnaUlIcjJ1Tk5pa3dY?=
 =?utf-8?B?ZGRaeUtEYlpLcEtQeTUrRU9aeHdOMjZ2cFdyemNvdTJZVjArcE5aMTZCS3JJ?=
 =?utf-8?B?TVo0SGdLZms5dkVDMzJRRnVMdHhJWndEeVZwMnQvdVArKzJlKzQxTkN3U3k0?=
 =?utf-8?B?YUJqZmpTWmpKcldONjJXYVFnL0t6alFGd1Y0bXBQYlBuaTBuWHl3RlhpWU1o?=
 =?utf-8?B?T3gzUnU5VlQ0bE9XN0R1Ym51aTdra2Z6TnB6dlhRNW1hMjVHNDFBUlBmd1JP?=
 =?utf-8?Q?UjuId53C2c6N/15vpwrcZNH7X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec24db79-8acc-4860-9073-08dadb872564
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2022 14:51:13.2322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EB+Yr/2yEYqsK2DtWzz+Tda9rXpLR541cfkmgPC6Do1HmZkS9o7F4r+aHCjZ3lgNM80+kZpZnKhGfGnQq0F59g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7910
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/11/2022 3:21 PM, Rao, Lei wrote:
>
>
> On 12/11/2022 8:05 PM, Max Gurtovoy wrote:
>>
>> On 12/6/2022 5:01 PM, Christoph Hellwig wrote:
>>> On Tue, Dec 06, 2022 at 10:48:22AM -0400, Jason Gunthorpe wrote:
>>>> Sadly in Linux we don't have a SRIOV VF lifecycle model that is any
>>>> use.
>>> Beward:  The secondary function might as well be a physical function
>>> as well.  In fact one of the major customers for "smart" multifunction
>>> nvme devices prefers multi-PF devices over SR-IOV VFs. (and all the
>>> symmetric dual ported devices are multi-PF as well).
>>>
>>> So this isn't really about a VF live cycle, but how to manage life
>>> migration, especially on the receive / restore side.  And restoring
>>> the entire controller state is extremely invasive and can't be done
>>> on a controller that is in any classic form live.  In fact a lot
>>> of the state is subsystem-wide, so without some kind of virtualization
>>> of the subsystem it is impossible to actually restore the state.
>>
>> ohh, great !
>>
>> I read this subsystem virtualization proposal of yours after I sent 
>> my proposal for subsystem virtualization in patch 1/5 thread.
>> I guess this means that this is the right way to go.
>> Lets continue brainstorming this idea. I think this can be the way to 
>> migrate NVMe controllers in a standard way.
>>
>>>
>>> To cycle back to the hardware that is posted here, I'm really confused
>>> how it actually has any chance to work and no one has even tried
>>> to explain how it is supposed to work.
>>
>> I guess in vendor specific implementation you can assume some things 
>> that we are discussing now for making it as a standard.
>
> Yes, as I wrote in the cover letter, this is a reference 
> implementation to
> start a discussion and help drive standardization efforts, but this 
> series
> works well for Intel IPU NVMe. As Jason said, there are two use cases:
> shared medium and local medium. I think the live migration of the 
> local medium
> is complicated due to the large amount of user data that needs to be 
> migrated.
> I don't have a good idea to deal with this situation. But for Intel 
> IPU NVMe,
> each VF can connect to remote storage via the NVMF protocol to achieve 
> storage
> offloading. This is the shared medium. In this case, we don't need to 
> migrate
> the user data, which will significantly simplify the work of live 
> migration.

I don't think that medium migration should be part of the SPEC. We can 
specify it's out of scope.

All the idea of live migration is to have a short downtime and I don't 
think we can guarantee short downtime if we need to copy few terabytes 
throw the networking.
If the media copy is taking few seconds, there is no need to do live 
migration of few milisecs downtime. Just do regular migration of a VM.

>
> The series tries to solve the problem of live migration of shared medium.
> But it still lacks dirty page tracking and P2P support, we are also 
> developing
> these features.
>
> About the nvme device state, As described in my document, the VF 
> states include
> VF CSR registers, Every IO Queue Pair state, and the AdminQ state. 
> During the
> implementation, I found that the device state data is small per VF. 
> So, I decided
> to use the admin queue of the Primary controller to send the live 
> migration
> commands to save and restore the VF states like MLX5.

I think and hope we all agree that the AdminQ of the controlling NVMe 
function will be used to migrate the controlled NVMe function.

which document are you refereeing to ?

>
> Thanks,
> Lei
>
>>
>>
