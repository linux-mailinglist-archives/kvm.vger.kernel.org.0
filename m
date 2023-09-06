Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83FA794086
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 17:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242659AbjIFPiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 11:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235322AbjIFPiu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 11:38:50 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2071.outbound.protection.outlook.com [40.107.95.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFACC171C;
        Wed,  6 Sep 2023 08:38:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLbBxEKK+2En05mUIxo/h89peDtFQtvgcdF2eUMFzLouoeaPo4DYgocZ49x3p2KXnI8wfhfAprC8shc7u4RYAZwekFcUBr08TLJfW0HJ+uM+V9FE5kk5KF51521jJtFEZouXh2+g+Kcm8SueoSSrVUwUqxY/Zzx8SpnAGSL63zVwkSlgAz2hfdUEreOX4sy1/1mRP33neVwuf98ep5dbTXsOB0v/hPfcOi8hjzyS6oULtKCUhug7twY8bf5AMAmxySveTT596BIpe7kfGlyokOkT5Mm/XXgMUB7RzXMK91UgQDLf5c/iVTaGCcYl8b0txZE5AFMNcdL0j50bGBQT7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LsSKv4C1o4o/BdlFWXsabfIJHJW4nOtvCvxKRxQAH0A=;
 b=Aqgvkb5kyqqPrjONIOkYOP735Gg5nSfmCvCWvUhsREtyXKWdPRvVpXzMJmqpubXyN8ddMkGduL6jlLFsoUKd6X9IcHKal8SxgYNikoVdvNNTfhJiB/aGDrlo86czZq9Vrc3fMlNGE8aNWODWSs1hMilUaba8pdjSFJwEk2s1fl5JJ5d98Y67E26k5RH3KrH8ew/THX8jasniGcuvJnpzpBZwMoe7+rDyJN3h7pR/8NMwb56zHH3wx8SfPXXtfaZQEGv2f50C0tTr+l0T7I4pnKEgZqNXuUQVtyVJKUnOzWGO6iHbBjYu/YoBBg1fychAVt9DI1Hrd1CRzG5eB6SSMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LsSKv4C1o4o/BdlFWXsabfIJHJW4nOtvCvxKRxQAH0A=;
 b=z63xSP6CC8sx1cT+4WJzYYtQmCQZxmrIf+cqMWZPGcN75/pYkZLv6a53VokZyCFGKW9Hw5CaME6QNFM6pg0CXWmc5H1nVUAycdA9fELajrCBTH8C7x893B7d2bOJ/WdYogzcRDpWAZPTltPneOfmqemqBFdDBWs1zAPlu+nIG5Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 MW6PR12MB8957.namprd12.prod.outlook.com (2603:10b6:303:23a::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6745.36; Wed, 6 Sep 2023 15:38:42 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::6f26:6cea:cd82:df23]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::6f26:6cea:cd82:df23%3]) with mapi id 15.20.6745.034; Wed, 6 Sep 2023
 15:38:42 +0000
Message-ID: <012c9897-51d7-87d3-e0e5-3856fa9644e5@amd.com>
Date:   Wed, 6 Sep 2023 21:08:25 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 00/13] Implement support for IBS virtualization
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     kvm@vger.kernel.org, seanjc@google.com, linux-doc@vger.kernel.org,
        linux-perf-users@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, bp@alien8.de, santosh.shukla@amd.com,
        ravi.bangoria@amd.com, thomas.lendacky@amd.com, nikunj@amd.com
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230905154744.GB28379@noisy.programming.kicks-ass.net>
From:   Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20230905154744.GB28379@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0062.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::11) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|MW6PR12MB8957:EE_
X-MS-Office365-Filtering-Correlation-Id: b18b5e96-772b-4959-4e4f-08dbaeef5910
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0GvFEBYRMVvJuUy8pzPgNFZSF1TvkBCB9fDNz5q8ESMNr8bEHrHGEkCVZ1j/4bfUorr3dZO0K1NbooN0LszWsyKaPd/pYFy0ztK9fUW6z0HhQ9I+6RMHWTLskNvQiuI0M77YZCZLl8IXVrrAaYsEHmihuR8N2kzUE0HncR57qwo4Vb9o5QGkVp5gry2Px3knk0VE8q7GHxD5vneEutzqqqzc+D/kBF1yDIReoSq8tWR9eMH3mXZX9npQsF+IlfH/njF+bGO52UQPvAa5DQSHTkuTU6IJTubHmmHYdzWHV2bjs8Spj2vhReuT/JfKDHc/39mmhh02hyxTX3twsiv5EmKCqexI259x0waXqFJD3Zj3vJZkcpK0FB55PEJxeINSU+F1oN85YbdI7BHXASkF4pIWF5bJvLzW7ErtSkCJYS7HgtMYGd6Vq3dgtZ0KWcvyqc2ZguYBnfvudnJXE3juKiMpAED3DHXW/Jwz4VHWPfRqoF33QVz+se2de+gAAmkRFehKH65pKQD4tXdu1AL0sFbzklW+jOp+I8T32XuwY+zJI2gC9XHvniqZnLvruA/ZXtUBL+oPqHBQEd+tVgGhFq+ufB/au3Z/c3qT08/W6jyjVXGpA13uUpSbIbD9Ge+S7WfpQVaj+4E9MPe0vaaDXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199024)(186009)(1800799009)(53546011)(6486002)(6506007)(6666004)(6512007)(478600001)(83380400001)(966005)(26005)(2616005)(2906002)(44832011)(6916009)(66476007)(66556008)(41300700001)(66946007)(316002)(5660300002)(4326008)(8936002)(8676002)(86362001)(31696002)(36756003)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGZDODVGK2pydmN0WDhpR1M0bHdFYXI5WjIwcUphcHcxQmZnTlE5a3NsTjZF?=
 =?utf-8?B?RTM5Yk9UR25JQTRqMVVobFAraFZsSXU0b3VLR0I4aVQrUE8vTEp5aytCMWxT?=
 =?utf-8?B?cmgwVTdXR09XaWhNTXl5NDErVGhvbG5RWVZhb252OTV0Y3hqNURiSnVuaENB?=
 =?utf-8?B?dWNMMkRlc0VIKzQyZEhQWGszVVp6N0l3TGszNzE0dEdxRURaamptOCtGcUVs?=
 =?utf-8?B?NG4xWmU1OWlZdEJ0cFJ3UlMxZWw1THNSUE4vMEt5VzhYR1U0UFNWSW8zcmEz?=
 =?utf-8?B?ZHFNclFyK1MxM0xaWGRUYy9qbW1WdCtMTEdlNFczS29DdGZFQk9BQzdZRGk4?=
 =?utf-8?B?bXF3MHVVTVIvcEZDMDBrTllFNFpsaWJZUWpEY2UzTGdlL21zclEvNit6R1Jr?=
 =?utf-8?B?bjJHSkt4UTR3QWdRZHFKYzhKN0U0OUZ0SDNnWm5lQUxOUk5kSVl2aUlYWXcy?=
 =?utf-8?B?VUhicE14MmZTNUlsSjRlUkZuRkdHdVVBUlhFQ09tblVpU0IzcE16V2ZHYS9E?=
 =?utf-8?B?aEtWeUJXcUlFUWozcnpoZXNacFU0ODRQcXBpeHdQN01adVFNS2FuY1hja2Rq?=
 =?utf-8?B?MHNaWFpmVnpoTFZicU9jeWJYNWRVdm10QUJEUFcxTDRxdGRQTWh2ZTRzOXJt?=
 =?utf-8?B?UUtHclZSbkdWaXFIU3F3SlFPL3dyNnpNNWlxZHpGeUo4UEtyWWVlWHp6QmdW?=
 =?utf-8?B?RVU3N3Vib1VWUGt2bXlhN3pKbXE5SFJuTkZkRUYwOElsRDVnT2RpZUN2emV2?=
 =?utf-8?B?Mk1Ha2YvSXRMeDVRa1V3NlA2dys1TzdYcjVHcTBLaXRpeVVjcVQ2aTJZUjNq?=
 =?utf-8?B?RHlmblVGbk41aTlqdGJlMUo0NzB1QURmOFB4L0dHSWV3OHovUnh6a3MyVmU4?=
 =?utf-8?B?NmZqMUd5czFCcCs4TTV2VmROMklLMzN3T2NScjRZRjVudlpzaW9XdjN2MWV0?=
 =?utf-8?B?MEVUKzFlT1RMQVBLTC9JTXgvNkY5T2ZqWXU2VGdad0dEc2FBUm1OZVZJdDFI?=
 =?utf-8?B?MmV6bWtyU2h1cGtpVXlrQmxvYlU3YVJ1R2UvZnJIVnlZaldtci9McEVob3pU?=
 =?utf-8?B?ZTh5V21PVC9GTmNlSUxZNGs5SVk4b01VM0x6RjV4UGN5T2tuOS96VldNM00w?=
 =?utf-8?B?YnBIcUZIeFdLYThRZkIyYlZrWHhWR0pzU1dlcHA0am1ZZUpJQnhzSk9lYTU0?=
 =?utf-8?B?Wm56Qi9DWGRqTHZlcFJXMThKd2RkajBCcXNMVlVLUlRYVzBjcWtaQVN1a0lJ?=
 =?utf-8?B?SFFXQWFDS0VGOXFCQ25EVHgxbVdncUMvNGV0eVZkM3YxcnVxZmgvUkpvdU5H?=
 =?utf-8?B?bHdldDhWdGpDTVVsL2diT1FvZ0NDNlRlcXRMVFNEazI2c1V4VTdQdmhnNHh1?=
 =?utf-8?B?TCtmNlNaUXRyVklqVmhlSGZyRVYyendFUHhsdVdZOFY5SWl6czNzUzdvNFlH?=
 =?utf-8?B?akxRZW1PVHBtWm44SWJhZWN4eS93OG5HOGwxZTExdGxlMy80bWl4MzY0cmxD?=
 =?utf-8?B?VEVZOUlIcWpQbHMxS3NRNW5WdDBJVjFYdUdXdm5JM1krd2tha0NkY3N1ODZ1?=
 =?utf-8?B?eEk0b3JnN2VzQmxpTWNST042WkZiTkowOTlCMHNMU2FuV0tTcDNHZUxUbXJY?=
 =?utf-8?B?Ri84N2tnbUVGMTJmQ3ZBenJDbXFhMUFHVmx1OTg1dldhT010dE80NzNkREJJ?=
 =?utf-8?B?Y3M0eDZhSTF1Yk15ZG9rTUQ5OGRhWFpDMk4wU3NyaExicDIxeU9UQkYycGIw?=
 =?utf-8?B?SGpJeHk0Wk1ramsweUlGbGRBb2gyRU5GTjU3aG03ajJVcDNtblByazRRWkQz?=
 =?utf-8?B?TU9leGQvTXZMS3YxQmhGMFlsWnZSZ1k5MnJwNFNnNjF0NmVhdW9zamNUWGNV?=
 =?utf-8?B?R3Q0K2VvM1R3bldwVVg4b3A2bVFxc1pScTlGWmxkdlFJSzBSQTh3clNEK0xk?=
 =?utf-8?B?UW12ZEswSzJ0dHlzUHhMN0dlZ3I5U29NUmp0SDFiQVNkVzRXUGlnbmhNblhj?=
 =?utf-8?B?SzZ6Uzl2VVNNZ0o4RWJsLytWanMvYkw5ZFR0MnArRExsVFFKeTJsMUZyWFh3?=
 =?utf-8?B?REU2WDFTYzM3TDlLMVE2OVBDU2ZiNFZyd3Q5ckRyUGlDNlQ4b2JtTzBrNDJW?=
 =?utf-8?Q?ZoSJDQqg02fn69IcoGG9VdTF9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b18b5e96-772b-4959-4e4f-08dbaeef5910
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2023 15:38:42.2107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eDAe8HKeHyLljb9+Cda9NJR/7GUFg9OjAXp/yjIDXYRhovPG3/NqlNJpDw0V5lkKhuPD9CVdk+VNyhXbbAoftg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8957
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

Thank you for looking into this.

On 9/5/2023 9:17 PM, Peter Zijlstra wrote:
> On Mon, Sep 04, 2023 at 09:53:34AM +0000, Manali Shukla wrote:
> 
>> Note that, since IBS registers are swap type C [2], the hypervisor is
>> responsible for saving and restoring of IBS host state. Hypervisor
>> does so only when IBS is active on the host to avoid unnecessary
>> rdmsrs/wrmsrs. Hypervisor needs to disable host IBS before saving the
>> state and enter the guest. After a guest exit, the hypervisor needs to
>> restore host IBS state and re-enable IBS.
> 
> Why do you think it is OK for a guest to disable the host IBS when
> entering a guest? Perhaps the host was wanting to profile the guest.
> 

1. Since IBS registers are of swap type C [1], only guest state is saved
and restored by the hardware. Host state needs to be saved and restored by
hypervisor. In order to save IBS registers correctly, IBS needs to be
disabled before saving the IBS registers.

2. As per APM [2],
"When a VMRUN is executed to an SEV-ES guest with IBS virtualization enabled, the
IbsFetchCtl[IbsFetchEn] and IbsOpCtl[IbsOpEn] MSR bits must be 0. If either of 
these bits are not 0, the VMRUN will fail with a VMEXIT_INVALID error code."
This is enforced by hardware on SEV-ES guests when VIBS is enabled on SEV-ES
guests.

3. VIBS is not enabled by default. It can be enabled by an explicit
qemu command line option "-cpu +ibs". Guest should be invoked without
this option when host wants to profile the guest.

[1] https://bugzilla.kernel.org/attachment.cgi?id=304653
    AMD64 Architecture Programmer’s Manual, Vol 2, Appendix B. Layout
    of VMCB,
    Table B-2. VMCB Layout, State Save Area 
    Table B-4. VMSA Layout, State Save Area for SEV-ES
    
[2] https://bugzilla.kernel.org/attachment.cgi?id=304653
    AMD64 Architecture Programmer’s Manual, Vol 2, Section 15.38,
    Instruction-Based Sampling Virtualization


> Only when perf_event_attr::exclude_guest is set is this allowed,
> otherwise you have to respect the host running IBS and you're not
> allowed to touch it.
> 
> Host trumps guest etc..


- Manali
