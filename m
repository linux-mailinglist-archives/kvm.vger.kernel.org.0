Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6F06A74B7
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 21:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjCAUBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 15:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjCAUBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 15:01:13 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38274E5ED
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 12:01:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUjhgVG9iIl4WMUzJndbwe4U3A9o64hP4niKi4ZI8LmSI7Zxu/vEizo1dJppFphWSSl7ISKJ9/fxJFiexo516OIIZ+n5PhBBcQwDmL1gDKqgyMC9nTPt5VFDOJm+b1zkzFWrM2bKeSP4eJ95qBP3oXwnEpv8UtX9XNOJ6Zevj9WTmfFFxGvTM8N/+6URXEnXX1khSRQ0xg9lZmvnfYcmcdaj0nN0fdOMLkAPGg9sibVBdhk5hAal9hF0c/82VTEaqwEMlqMQtxiTFIFs5n/oOzVfGjxW8pTwCwvFWCgim2Hc++dJYtNLQ61bJq30Re7roxp9/0x7F9iz3k/aWqgWoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aoJfpmRjCFOLk2uORYXFHRs48gCdXAe0q6Yj5b7LE80=;
 b=SdVfQ7wArKkmBbIJr9PFDeMI/vO8X1mwkmiWNrb3/fhbnBDJjD9qMIvZFhPr2P7EIPGB2i66bT7wtCvhPOnhAcZKaiaUBSPweyc6lvL0CBfy48hwt4Si8bPTP5+qtV0NBjGQgvkx4LO2TyhaAikbgy6vqf5HJyOOPfXzAG/lq5qBXU285sG9YaBCDt6/rTZpcYUpAOByCyNE4TOyxJocuwioeww/RvBNEWYGuuxB1UgNoOjPfxjlkt5xIbxH6J9bID1MenSIOW9tsCqU829Yd6PYM2JOCXsdF5Z2zavI0k8FDkJrR0AuiewqZz7tISbRvl2D2hiQgD/nLrbGunvhww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aoJfpmRjCFOLk2uORYXFHRs48gCdXAe0q6Yj5b7LE80=;
 b=HTBS2lEJDEEo0Oq+yimrFZpbg8jxVwUyKZhDB0Ne483xdbIVEGmAY+ed/Xl/RBx1sDtF7B9d7d66xYQm8vgMwCAMCwLOlCJQ8Jdg0CPhaezel9HCq6ZmnCCCuTCnUGqwA69SR4uub3NLnh1fj1RyWkBpMuDL3Q3YiVGoKqh9lD4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by BY5PR12MB4228.namprd12.prod.outlook.com (2603:10b6:a03:20b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Wed, 1 Mar
 2023 20:01:09 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3490:de56:de08:46f6]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3490:de56:de08:46f6%8]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 20:01:09 +0000
Message-ID: <26a70833-b9fb-d975-4c90-3adaaa497bd2@amd.com>
Date:   Wed, 1 Mar 2023 14:01:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v2 0/5] target/i386: Update AMD EPYC CPU Models
To:     "Moger, Babu" <bmoger@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "yang.zhong@intel.com" <yang.zhong@intel.com>,
        "jing2.liu@intel.com" <jing2.liu@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "Huang2, Wei" <Wei.Huang2@amd.com>
References: <20230106185700.28744-1-babu.moger@amd.com>
 <20230127075149-mutt-send-email-mst@kernel.org>
 <8df55f5e-afd1-ab04-c7da-8ac70a8f9453@amd.com>
Content-Language: en-US
From:   "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <8df55f5e-afd1-ab04-c7da-8ac70a8f9453@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0421.namprd03.prod.outlook.com
 (2603:10b6:610:10e::26) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|BY5PR12MB4228:EE_
X-MS-Office365-Filtering-Correlation-Id: 3be545b4-7581-44ad-1b91-08db1a8fb336
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u1KH1wRnnG4SIyI/gQt+JtXPVIW1yFczX9sx/wKXM/VMp1vdbKDY2RtHx9hB6DgJ+wFhFGkqJMHKUWzb8Pj0lLZq/ec2rvy0ji7/x3kWo02+nLDqPl/gpK+8NxfV0mdX8Hdc9XU8zqlXO2Mv12cXyG9adNlTnpQ2C8pNRYteFT4fflJ3IipQPgPwNdfbvrwEeFlvqP1MDZUVRB5iZ/M8KVLhnihwWO4rEej3xB7JSmZC6XOAbDtfDyTguTDNJdC9kfUin2m6uVN4xPZvo4SjkFI7kYi4xJ1Me1U9X5vejKLCUa9uLWB8rBRqP0M0xnuyuNmjA4HvbLy18km8tm84eUuBJqpZ5kd+V19yYwnL6Uammi0h5bBhmYQ1HA95vhOWi7K9V22WizJi2ggeAYznvNa3l306LblozCernjBR0THW9Y5WAUmyghFSmFitQXOtGS+TcTt+9nv8kl3it76HkOnHk9a0kvFM9PlCLqfXKpv8L/P5FYTtsPt2VvmovRAjb1NaeNuVTdBgYV8ON88srzbOusNkFSz4S581s9EUDyzHe0FJFtBEvuAO4s38WXIpkTEFnOEElcVp2Fc7i4ZZQu1lRWW7Stj7hd+IfMa2MfWMoiwSJOB7piRr+2OfwM9pLOBPAW3WmlMWdTLi5Iw4UkxZd96xmyclG+8hTAsDNAqeLPfyrvOfD8eRep3l/oLsda6tzfJ5l4o30s/2G3ApjgpsUX8kjIO4GjtvVguS0/T6uwnufdK4yDP7BiPAbwYrs6ziYpTue98js+t7QU/hjtCjrXcMOHJi6TB2ewVTBtM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199018)(186003)(6666004)(5660300002)(38100700002)(83380400001)(15650500001)(6506007)(66556008)(66946007)(7416002)(4326008)(2906002)(41300700001)(8936002)(478600001)(3450700001)(8676002)(66476007)(53546011)(26005)(6512007)(6486002)(316002)(36756003)(110136005)(31696002)(86362001)(31686004)(54906003)(2616005)(966005)(170073001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTlaOFZQLy9MbVZncEpFbTBnd2NZQUMxakNobWovUHlmelcvbnZYWjVUNERr?=
 =?utf-8?B?NGJRSWkwa1liV1VxSHlycnhPOEp1ck14czRua2JRMFNVRmhNaVU1c1ZUZHdy?=
 =?utf-8?B?bXpuekdWMG9rdU5yZ0Y4Q2tIS1M3U25qcDRnU1h3TGkrUWZ4WlZEcEE1elBO?=
 =?utf-8?B?RTl3L25ra3FiSU81VFJqdU4xNHlLMzdWMVhQSXQwc0s0OHFxSkNPK1MrRGRr?=
 =?utf-8?B?OFNHR2JUMGRuS1JnVmNjYk1GV3QwRDFZQ0xVTzJuV2lBSERkbEE2bzVrdHMy?=
 =?utf-8?B?M2p0RnpYZXdCTkgwWTlJdVo4M0JBaGFZamh6UWMzd0dyWWlmUFBMZUxsRnhV?=
 =?utf-8?B?cEVkVXBpeURKbFZFemJOTjNIQUpvSldwditTdXkyUm53allUOTRJV0NzZ1Qy?=
 =?utf-8?B?bVRUT295SGhlS3hrQlRvTGdtaTJ3SUpuNTdpckZhU3NOeGZIYmZOaDlKSFJ5?=
 =?utf-8?B?cXRkTjhVb3BDMnJaeXk1dVFubXh2dWpBeXZlblhwdFVFbHluaEg3ZktyRXVL?=
 =?utf-8?B?S3BraW5lMExTYmk2b2hEQzZuRXBBeHJpMDlRZEtaVndrSHAzbTU4cmFPNnhy?=
 =?utf-8?B?WlJITWZWQ3BWNEtPQ3BiOWVDOHJCaUs2VzdQZ1R2Mm45TTRXOWY2dEN6ZW1J?=
 =?utf-8?B?MU9tTm8ycTYvb2xWUmN2eGY3UUhRa2h3bElrTTV3ejFvYXRiTkd0cU5FQjds?=
 =?utf-8?B?NTZsMGFzb0RpaHB3QVI1UjJJSnR5Skc0QldGZFJEdEpJM3pBb1VDZ0psbEdJ?=
 =?utf-8?B?TlE4dlRCTjIxc3g5UTcxQmE4b1hpUm1CTUlqYnhYVDI1WVFqVXZwYUptdlhx?=
 =?utf-8?B?UEFCNW5PRmV5VEJWbHoxb3krdXpmNGg5bkdGWVppMVNsTktKYXVOV292NnFo?=
 =?utf-8?B?M2pJNGtxQWJzci9adDRHL2pMeHgvcDhKM1VpTjVoc1Z0VVlCaXN3MG1MRkVm?=
 =?utf-8?B?VnQrN1lMLzYrMUFSeTJmRCtWVzIreXZBdW5Ed1RLWVp2QTFVSzQzMEZkdlpD?=
 =?utf-8?B?WEUrTmNqekRmL3hnU0cvLzI1RmhFYWlSZkVDZlRMeFlsSnRVRjJlMkhWeU5Q?=
 =?utf-8?B?Z05GbEliNHpkV1hPY3A1dmlNbnBXV1dGcnEzQkNNNXVnbTZ5SlRoUUFVOTZz?=
 =?utf-8?B?b3piQTc0WU9UbUlzMjEwRFV6R3JHL2tzdjFRWEJXbm9xZ3NEMkMwcFlFa3U4?=
 =?utf-8?B?a3JqM0trZ1FQc2VqUnFqZ0l0N3BjdHRPbHlLQ0pLWUsxRFk3V2xMc2FKVElB?=
 =?utf-8?B?RWxFWjVtRlM5cmhQWmhaeWw2UGhPZWZ3Z0tFVFIyZFhMOHMxTEpJT3dYejFz?=
 =?utf-8?B?dWM3SXlqdHB5T0QxNzZPUEVxOTk1bEg2bWhOdS9vMnM5RVFWTmhxMngzUnRM?=
 =?utf-8?B?ai92ODJxbDR2UHJlVnl0eHAxZ3pjeUtTVTAyK2VIRE1KS3pReWtSSjhpRlhE?=
 =?utf-8?B?ZDJBMVRBSXZTSVpuMTdYSXE4Zjc1WitNblBtVzRRZDAwZlhrNTlESnJ6M0hh?=
 =?utf-8?B?YWVCeThEZzdGVjlsSUc5aFZSMWVOR3l0VzBqWTJKbnkyMWZDMWJBc0o5M3hU?=
 =?utf-8?B?cUdCNFpHeVRnem0zVmdzanRYWm1tYWZzS1RDaTBnZGMzTDg2MVAyTVZpK2Vo?=
 =?utf-8?B?cE9oMStzOCsxUURuOVZNaTJvMGE3c3ZlNGdQUnBDTHRCakRVU09lOHowTGtw?=
 =?utf-8?B?aitWMFFmL0FXMms0aFN1dTZ6YytyL2h5RCtWSDZVbVVNUE9WRGpjemxNeS9a?=
 =?utf-8?B?WTg4YSt3V3FCeHVTRXdWQ3J4bjFtNkluYmpwZFd3ZlBNVjM3R2ppRUtVZTB1?=
 =?utf-8?B?azZLSnc3d3E2U3lhT20vdHVyeGRQbjBySGtFdFA1M01oL3VKcmRnN0dPSmZw?=
 =?utf-8?B?QXFpNTV4T1hHdzk0U1ZrQVBkNkE4U1NTVnpVVzRVNWg0U2NtcGVSclVQcU5k?=
 =?utf-8?B?UnlpeHpSeFRZWW5xQm9JNXQxSzdIUnhkNmxOeFVxdFVrTWN3b0ZEWVE0M2t1?=
 =?utf-8?B?eEllQnh2eWpiUnVwQXFjVCsxVUNPV244eWx5eFJKN3o2cnhRenVwRG04dDli?=
 =?utf-8?B?RWpGL0xYeXUvd2k1NHRMUFUxcTdQWDRUUHV5YUZEcTNBdjhhZy9Pd1B4Tmsw?=
 =?utf-8?Q?NgCHGuH7L6jxHcddjlnMdy71h?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3be545b4-7581-44ad-1b91-08db1a8fb336
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 20:01:09.4088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HbV0sEQUMeRaa4hQmb1gffR19LRERKyCTXatL1Eu4PeVyYcTd8b7HB4muWuzQ6th
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4228
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gentle ping again. Hope this patch doesn't get lost.
Thanks
Babu

On 1/31/23 14:21, Moger, Babu wrote:
> 
>> -----Original Message-----
>> From: Michael S. Tsirkin <mst@redhat.com>
>> Sent: Friday, January 27, 2023 6:53 AM
>> To: Moger, Babu <Babu.Moger@amd.com>
>> Cc: pbonzini@redhat.com; mtosatti@redhat.com; kvm@vger.kernel.org;
>> marcel.apfelbaum@gmail.com; imammedo@redhat.com;
>> richard.henderson@linaro.org; yang.zhong@intel.com; jing2.liu@intel.com;
>> vkuznets@redhat.com; Roth, Michael <Michael.Roth@amd.com>; Huang2, Wei
>> <Wei.Huang2@amd.com>
>> Subject: Re: [PATCH v2 0/5] target/i386: Update AMD EPYC CPU Models
>>
>> On Fri, Jan 06, 2023 at 12:56:55PM -0600, Babu Moger wrote:
>> > This series adds following changes.
>> > a. Allow versioned CPUs to specify new cache_info pointers.
>> > b. Add EPYC-v4, EPYC-Rome-v3 and EPYC-Milan-v2 fixing the
>> >    cache_info.complex_indexing.
>> > c. Introduce EPYC-Milan-v2 by adding few missing feature bits.
>>
>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Michael, Thank you
> 
>>
>> who's merging this btw?
>> target/i386/cpu.c doesn't have an official maintainer in MAINTAINERS ...
> 
> I thought Paolo might pick this up.
> 
> Thanks
> Babu
> 
>>
>> > ---
>> > v2:
>> >   Refreshed the patches on top of latest master.
>> >   Changed the feature NULL_SELECT_CLEARS_BASE to NULL_SEL_CLR_BASE
>> to
>> >   match the kernel name.
>> >   https://lore.kernel.org/kvm/20221205233235.622491-3-
>> kim.phillips@amd.com/
>> >
>> > v1:
>> https://lore.kernel.org/kvm/167001034454.62456.7111414518087569436.stgit
>> @bmoger-ubuntu/
>> >
>> >
>> > Babu Moger (3):
>> >   target/i386: Add a couple of feature bits in 8000_0008_EBX
>> >   target/i386: Add feature bits for CPUID_Fn80000021_EAX
>> >   target/i386: Add missing feature bits in EPYC-Milan model
>> >
>> > Michael Roth (2):
>> >   target/i386: allow versioned CPUs to specify new cache_info
>> >   target/i386: Add new EPYC CPU versions with updated cache_info
>> >
>> >  target/i386/cpu.c | 252
>> +++++++++++++++++++++++++++++++++++++++++++++-
>> >  target/i386/cpu.h |  12 +++
>> >  2 files changed, 259 insertions(+), 5 deletions(-)
>> >
>> > --
>> > 2.34.1
> 

-- 
Thanks
Babu Moger
