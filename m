Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC98C645209
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 03:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiLGCah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 21:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLGCaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 21:30:35 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68F754442;
        Tue,  6 Dec 2022 18:30:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8SAgreT4J0xXZNL22j/GkitGzehDBEXHgd2mkHQLBMLGpBRwkzgRdwl9SgtSA0yxb+sEiijf2I0nIsZYakI87+vzT3HZAyBEU5rqxq9nr5wYQ33+205M+el/Cmg6QPd9FcE9ZOkQUQujS/n0fEGaR8nO0X4nfrldMLvixGVRPH/ivbT4i0ZzeUaw6YxJQdsYNt04UOZZ3Bs3+uSC/x0YGiU3jeu59NDZhKKb8fvB8MG3BAIv0b/6sP6kkr0CSNKKhPLFo8S9Kmt0GRRL/eOSWrvqOyLkMBtzRD+Jv8j10LS4BrBb+ipdZ0H4bmeafYAzv+qqRKJoTe+7XGXP3D2sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IH/0k3IwzfnfSr6JyszSIxwGMPYoUskkx1PGp+YzYp4=;
 b=QbaKrxCtLkzkGAMLbLEkr4SLkSQt8FZytZ3Pg3ZbaI/XAZxmWXinsE1bFDKzBaxT/9LSIvP2XyaYe/Pq04w394o/h+k5zG9FVrZvOTSwlueyw0ntjX6iELQsWuqJoMf0jC751Bg16BWj86R8A+tUX8D90FUPWp2MeOADHnyDevS6voZDFlPDipNgK1MTuwrFMbpZpclGOLCjoo+zUsCdQYcRXG+UFHGh7wm1pOGdRlcoeDXonLqcVsqTAzhKmWIzc2cMunLXhDif5DQ0ZLtY61giJbUH+ZO+boTY9ssBrRaBq3lKlvD0rVtMLISH38qz7r7TFm+UUefD1/NBUvdgsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IH/0k3IwzfnfSr6JyszSIxwGMPYoUskkx1PGp+YzYp4=;
 b=UiGml8v6UiNa0trOrW49jaMoyqUQFk3lL3l+r0D4Bi+6iOoF+mik4GpGzo6kujbE3CcMPejCgf4zdAuyjsKmEphgfgDFrhupis56rfr8kmR7CAoiB7soUiLkN8ShBSc103LWzcmrEJMatHxP9pmobmK/sd83ei7DJNRR1P50aIK+Xy+KTpZTKADR1JISexKFNcj57t4P2PMIaguuJONtYKBw1OIivu8R8u7/IHGIYhPBpRbkIX2qwnOF2I+8xS96XbG9KM9Tgn2jnCc5s/8bnidVKuKDmetC4+uJBIGlHR9KDo+jMgnv321UrroIQporA8HncpCyCnfk03qEzEiA0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by BL1PR12MB5093.namprd12.prod.outlook.com (2603:10b6:208:309::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 02:30:31 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::3fb9:3266:7937:44fc]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::3fb9:3266:7937:44fc%9]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 02:30:31 +0000
Message-ID: <2975e217-749b-6929-cd2d-4b6276ef33d1@nvidia.com>
Date:   Wed, 7 Dec 2022 04:30:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
To:     Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>
Cc:     Lei Rao <lei.rao@intel.com>, kbusch@kernel.org, axboe@fb.com,
        kch@nvidia.com, sagi@grimberg.me, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-2-lei.rao@intel.com> <20221206061940.GA6595@lst.de>
 <Y49HKHP9NrId39iH@ziepe.ca> <20221206135810.GA27689@lst.de>
 <Y49eObpI7QoSnugu@ziepe.ca> <20221206153811.GB2266@lst.de>
 <Y49k++D3i8DfLOLL@ziepe.ca> <20221206165503.GA8677@lst.de>
 <Y4+U3VR2LeEh2S7B@ziepe.ca>
Content-Language: en-US
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <Y4+U3VR2LeEh2S7B@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0254.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::18) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:EE_|BL1PR12MB5093:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f36c604-1b7b-4bd2-80a0-08dad7fb0285
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /mNR/qJtx/vuWMaYmtr5PT6TU9bCIvLPhdWOpLEG9ag16/ziDpOzouQZiCmWb34ZS0O3btd3zfX34ipmh8z7Lr1kbInR6TvxqcyeRDXOkU93MHQaKpZqQQVLar5vTEG0hs1dDky0CoqgWb5J6wp1dN4yefCNx/JK4bDtcCFnp3gP+EbfOdYmje/sO34k99me3vomfJmoZuCLgKt7Y1zU+mu4iJa1M7e5OsdvQg4MMHQ1ycRXyEM6XjQlgsoPM9lW5ECMIRWUwLnj9e3VlCtrp6ErYepe4GBsIhnlaQe+nj6G42WxG/keGO1ewJZX/QxsiW8JekSdwhLS3ynXgwJIpPM/sILFf1uvG1vEFqllzM8G50hof0cfcQFKOxBfXqtMjdtlrwjMlW9LHzCsy7paxY8evkz+cvsFH2WRFZ0X8FdkqPlmnMB3Sj50UfaLihmCxwadHlyFXapCyRB5EEwuUbMg9itinJfSFcCi5wjSXb5szMFRL+OxHz1gyvitt87fyI16X2Gm6tu3FsGm1L/3xqhYuwgZtzWgRAst1cK/DwZpYE/ETXRNLmyHa/D98COFAWCcKt7Vy78mLB1hDfhnuYOrTHJUEa/D89YwTT41W8+IYCjIf/b5B9OeWEYw6J8a5iXFUrzgj3MATAHx/eFoKL3ymwrfDQQP3kr1frczbmZff454Xw63BovC09RhPd6w9VsvdaIONGiHKkBrkRL2NoVC5+2BM85hBOh4+IDNG8Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5040.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(451199015)(66899015)(36756003)(5660300002)(8936002)(31696002)(86362001)(4326008)(41300700001)(2906002)(7416002)(83380400001)(66476007)(316002)(6486002)(31686004)(2616005)(66556008)(66946007)(110136005)(38100700002)(8676002)(478600001)(186003)(6506007)(6512007)(6666004)(53546011)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXR6b2NVWHpoK2FlSkdrcmxES0dyWnhsUnVCK25WWk5xelVnTUZrS3g4aEg1?=
 =?utf-8?B?MFRMd25uaTgvNWNPOUFaWVZlWlc1NzJJMWpVdnNPOXpORWR0WTRjMXliWlp0?=
 =?utf-8?B?czdHRnlCaUh1bGlXaXlNcjVQaThoUG1UcG9FU0tQSXRtRVUrSzF3R3prZGE4?=
 =?utf-8?B?Ykl2dFZUa2kvOC84bit4dVNiRzJWdWFEbjIvY1R0MHE1bHpPM1hjT003aUJC?=
 =?utf-8?B?ZEVkbzU2Vm85dGUyRlZEemI2azBwRmRpWDBhQTZJUytkUCtVMEtJVzdTR1lY?=
 =?utf-8?B?T2JCR3ZFeThqcFNyTTdYQmtPeGpyT3F1QndmTkdFdFFONVlXVWI2U05VcWd6?=
 =?utf-8?B?RE91Zkl4VmtrbDZPNVZlVU4zNU5ZTVc5ZVNrWmVqZnoyQlZhRmpwTFFhRVJF?=
 =?utf-8?B?VzRENE5kZDl1MVJrbE1qK0RsTVVlazVORlR0eVdkcm5WNGErMnZ3cjhGSkpr?=
 =?utf-8?B?SUlYZWVlTGRUeHFoNTBxZUx6SG5vakN0NXVQaEZhQTJhUHV6MzgzSkNtSm1M?=
 =?utf-8?B?TENJd1VIRGszbmcxL3NBU1I1L25lSVU1djhsOUFRandoa3RLV0dyMnBQRExi?=
 =?utf-8?B?cU9OWnRXOHBXOFZXbEtGeVE5dktORjQwMHExU0JSaWo2dWxKdnppQjd1SVBh?=
 =?utf-8?B?K1oxZmlKeGJ3NW5hRmZyYzBhK2orZHhVOEszUlF0a1owdHhYcmF5OTVrbjg0?=
 =?utf-8?B?b3R2ZlFqbmxaamxOc2VDZ1kxeHZKbXBuYnVsY2dyWFY5dXMwVmx3YU9UWmtQ?=
 =?utf-8?B?N01INlQ5M09aTzU0Q053YjV5cGtLMXNISE1HanFVbkRRV0piVVlMOHlZZ3ZJ?=
 =?utf-8?B?MG5ScHh3ZEpKOG1abEFDR0tGUkI4MzhsK2RySDFFd25vREptTjkyNE9CLzRk?=
 =?utf-8?B?WU1lYlFXSEtUanpBRXBTNHZoTmZkbTV4SFcrTUFUNnk3ZjFDWkpIR3kwTG9X?=
 =?utf-8?B?SWp6TjQwMURHMngwOGRWUXBhRUtsd3UrcGZGUkpjWUVLelNtcGJ4T050aDM1?=
 =?utf-8?B?bk1yb25kLzZUSmtxbnZUdHpTbmFOQ3lsVW55U1cydUE1bVlBdlVVZTc5UUdP?=
 =?utf-8?B?UFVWUTVmNExjL0N4TmdHeHpDOWpQMHRwY3hLSmdGUnY5cnl1Q0dGVXpBNWVZ?=
 =?utf-8?B?cTNwVFpNd0NVQkIrQXZRT0V2dlR4SEFjenh1dWZMY0dQcmI1UzN6cHRHa2tD?=
 =?utf-8?B?Z3NjZ1FoSXJPVkhEenArQjFVelBkSFN5MUF3VzVvUzBiMWlyMVVpeGx3QlFr?=
 =?utf-8?B?Ty80RmhZVysvdU8wOTVRaWJKVkkycE1rS3AvdDJhZU1wbUhxbno2dU5ZUEZG?=
 =?utf-8?B?VFZINzIyN0N3Y3R3YjFBM0dRdENIdW1pR3Q1NzJqSnB2TGRaRDExaVo1ZUxM?=
 =?utf-8?B?WTIxQjhJQi9Rcml3Ky9KZi80M0NDY0VhMnRvT3JsS0haQWVFOHgwN2I1SHJa?=
 =?utf-8?B?QVZMU3cvSERJMzEvYm5RVWlBQy9KSDA4ZFRXcHMyN1RGZE9iTmc2YmIydjBN?=
 =?utf-8?B?Zy9qTXdCZ0dCMmlXdFZvUm10c1J4d1F6Z2dNaHJCUEdsR3N3cDUzTmNXNVVF?=
 =?utf-8?B?bVdISkF3L0RyVG51ZmFzTnJaVFBOSXRTanhiRDdZUzNLYkJWNTlTSDNOaFVF?=
 =?utf-8?B?Z0tGd2lrczFJbjFEQXFiRGs1L2k5dVo5cEs4RHVILzBTdW1US1N6RU0reUV2?=
 =?utf-8?B?YkFuQWtoOGJ1ZkJSVDNFemEzSlJuQVFqTGJUOC9xa3pnRGhpcE1rSnEwb21w?=
 =?utf-8?B?THZ2YlFtdWdIWHRIY29FazQvcEUvTnk4cFhjSHZkTGhwODZHL0RKb0d0TklG?=
 =?utf-8?B?T2RZTkhRQ2Z5NllHVWZ0ZzVnRS9CWFV4djg0UkI2c1Zobys4YytyajdmZStw?=
 =?utf-8?B?S2xhWnluekNRQ2dlTTRYRm1tdmRRYnNHWldya3gyZU82VmRUcC8rTHEwZkps?=
 =?utf-8?B?U3duWTNWaC9neDlibmNwZTBiTkZKR2E1ajBKekdqLzZHd1Y5K0I5bXQwaVNj?=
 =?utf-8?B?TExSeXk0WVNwN2RKc2dhVm9tVkhZTjEzenIvaDdWUzcyMU15ZWpwOUR0RFdU?=
 =?utf-8?B?QlVST2FXckErN3Q0MkZVcXpXSC91VzJqdmFSbHZ4U01pZG5qS2hpWGtENE82?=
 =?utf-8?Q?OUOnCJsjNfOtlJD8AhtLe8pin?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f36c604-1b7b-4bd2-80a0-08dad7fb0285
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 02:30:31.0881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nATgY9SMMzsRzaLFlepmd/BMt6L6SWBrh1+RW7FpWXYZ8hhJq0SG/Em8fG/1umQTqeuzzYkAYBvIApDP59rT0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5093
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/6/2022 9:15 PM, Jason Gunthorpe wrote:
> On Tue, Dec 06, 2022 at 05:55:03PM +0100, Christoph Hellwig wrote:
>> On Tue, Dec 06, 2022 at 11:51:23AM -0400, Jason Gunthorpe wrote:
>>> That is a big deviation from where VFIO is right now, the controlled
>>> function is the one with the VFIO driver, it should be the one that
>>> drives the migration uAPI components.
>> Well, that is one way to see it, but I think the more natural
>> way to deal with it is to drive everyting from the controlling
>> function, because that is by definition much more in control.
> Sure, the controlling function should (and does in mlx5) drive
> everything here.
>
> What the kernel is doing is providing the abstraction to link the
> controlling function to the VFIO device in a general way.
>
> We don't want to just punt this problem to user space and say 'good
> luck finding the right cdev for migration control'. If the kernel
> struggles to link them then userspace will not fare better on its own.
>
> Especially, we do not want every VFIO device to have its own crazy way
> for userspace to link the controlling/controlled functions
> together. This is something the kernel has to abstract away.
>
> So, IMHO, we must assume the kernel is aware of the relationship,
> whatever algorithm it uses to become aware.
>
> It just means the issue is doing the necessary cross-subsystem
> locking.

Agree. This is not the first time we have cross-subsystem interactions 
in the kernel, right ?

>
> That combined with the fact they really are two halfs of the same
> thing - operations on the controlling function have to be sequenced
> with operations on the VFIO device - makes me prefer the single uAPI.
>
>> More importantly any sane design will have easy ways to list and
>> manipulate all the controlled functions from the controlling
>> functions, while getting from the controlled function to the
>> controlling one is extremely awkward, as anything that can be
>> used for that is by definition and information leak.
> We have spend some time looking at this for mlx5. It is a hard
> problem. The VFIO driver cannot operate the device, eg it cannot do
> MMIO and things, so it is limited to items in the PCI config space to
> figure out the device identity.

Christoph,

I'm not sure how awkward is for migration driver to ask the controlling 
device driver to operate a migration action.

The controlling device driver can expose limited API for that matter.

I don't see why is it wrong to submit some admin commands between 
subsystems - we already have a way to send admin commands from linux cli 
or from nvmet drivers to an NVMe device.

Also the concept of primary controller that control it's secondary 
controllers is already in the SPEC so we can use it. It's not introduced 
in this RFC but we're here to fix it.

In our case the primary controller is the PF and the secondary 
controllers are the VFs.

If we'll think of  a concept of new optional "Migration Management" 
admin commands that will be supported by primary controllers to manage 
the migration process of its secondary controllers - we can at least 
solve the initial step of migrating VFs by its parent PF.

>
>> It seems mlx5 just gets away with that by saying controlled
>> functions are always VFs, and the controlling function is a PF, but
>> that will break down very easily,
> Yes, that is part of the current mlx5 model. It is not inherent to the
> device design, but the problems with arbitary nesting were hard enough
> they were not tackled at this point.

Agree. There are a lot of challenges in the non-nested migration that we 
can just limit the NVMe SPEC to it and extend later on - like we did in 
other features such as copy-Offload.

Most of the infrastructure work for LM was done in the VFIO subsystem in 
the last year so we can now focus on the Architecture aspects of NVMe.

>
> Jason
