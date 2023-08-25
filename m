Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C956D7884DC
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 12:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbjHYKZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 06:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240870AbjHYKZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 06:25:08 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BED26A0;
        Fri, 25 Aug 2023 03:24:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9IudAMu9odpQOh2dd5zjIctyRybuAMW43vOaNY63pBqcWITyA/8Ivco/qB7BkJncJ4r03BCrm0FRGcauGRZjiZF3LjwpSjjb49HeEQp50hKTsV2Rb0ZP3oM3jqeROnMGRutW0pzAgPV+Hmvlbq80UMW8gkmmKSY+dV9Z2udOfHs7F1Y9rHG52t4eZykxsuwE5If5XYZ0lamgnRt0bAaeicjwFCeI1CIBK3gSQOscq5yytP1wcNraZrSzD0HOPVlUEShjsBuV7yjswq2vs5eO8ZSn++vlJTZEiKwHKWZYMJwt5xinMwsQZ3v0WvCvVJ41Sh4Vb64p6B0W195Vpc7Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WVOlyqF/QFEi7GsKycchgt9KfoSCnDZqQ1LRx9GUqQY=;
 b=Md5CVKYBCBJsTXunh18sGi+sEUIaziIQOqn0ROwph0G65MLqOeMgJSoUy5QWb4+EnWvTwuT2apmbQI/vlmGTck1eD7EW2dUjoz0uOPKP4Zrq8WjY7J4hKpSWQlyymRF81OBXgPVUPfIgOE29v4ywIXRnBtF+b//pNZuzbXm6E3rbfSNDgJuwEuev5N3///pvvgl99dOcbckGNyUD5YQX4yTZYazzVMErBN24nzU/j+lXAZmUdIqkOchUww250byRuhY1In4t6wSB5AnyD6IjnEhQCQQPQX5fYf3mpQDS2QWxl2qRIx904pS5RCT3qHTbUU9u19TMP+7VCYncuHrNgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WVOlyqF/QFEi7GsKycchgt9KfoSCnDZqQ1LRx9GUqQY=;
 b=F2C4lKjxOLiUgb2U/DFkIZShtoMXn7i4DIeiM/55lW2/otJv6sshuVxGgfk/7yJd8d2fAYmsFVmiCauJc0L5PFrt9frmcdnMCnYPxRNGWlXoll78UeX1AYhHmbh4b7f1eblsL9NN6JnRG7209GglO8KhnBHGwlimxGhnqUwbCVQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2810.namprd12.prod.outlook.com (2603:10b6:5:41::21) by
 CH3PR12MB7497.namprd12.prod.outlook.com (2603:10b6:610:153::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.29; Fri, 25 Aug
 2023 10:23:30 +0000
Received: from DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::52dc:b225:8fec:154c]) by DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::52dc:b225:8fec:154c%4]) with mapi id 15.20.6699.028; Fri, 25 Aug 2023
 10:23:29 +0000
Message-ID: <a08dc726-0251-0063-398f-cc0872ebf285@amd.com>
Date:   Fri, 25 Aug 2023 12:23:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/2] KVM: SVM: Get source vCPUs from source VM for SEV-ES
 intrahost migration
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Gonda <pgonda@google.com>
References: <20230825022357.2852133-1-seanjc@google.com>
 <20230825022357.2852133-2-seanjc@google.com>
From:   "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20230825022357.2852133-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::14) To DM6PR12MB2810.namprd12.prod.outlook.com
 (2603:10b6:5:41::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2810:EE_|CH3PR12MB7497:EE_
X-MS-Office365-Filtering-Correlation-Id: 206349de-2fe7-4bba-c46d-08dba5555361
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KURZXZOjEjG/imi0s2pn0JNCXkuNrd8FVv2zXGO1aM/3LuknAsgqvrDSVH5cC8r0QVwqJKoiugXStdAmZnLWzOlyoDfYtoHC2vfz8MEuupMDw+MtqA+cS/FB1OO6fN8nsGtYgMCqKlkxFAn50tIwHoAsloyzy0/4Rm+DEHU7TDDD338/cfg5XAJYbqNgmohqU2659bKMqaWr6g5aFVdHTbnv3s5zGLKEOJ9X0p2X/napvPVWcGkFuSL7UjlDj5gzHcVupXzu0BWgKPm3QmmSW0Yi1rIpesNAOrSyF9/mmF5An48/RYZIyUETrbJ7PExevqZ4iWeg7angF3GXOVVMsZD5BeExj/qsuRqdbQfLnv3CvANEG0CMe2lVdI+LRA40mdq7SlO7aiDxgmsOknk65AlxoV1sWXAjNbSwpZwtlrr3UrKthJZrK5aqLhW08+kEE2WzmTBVj034jc4FHUKDbZDh2ZIz/YB5iQAtJ6FEweU8wfxOby4TC+IIvhv48F5pRKIProNeAG9o6Q6sMQE9HlZH4hw//DaPoVVLwpl14LQYlufkJsaiZvj8WtleCpUkjswBvq33qAoQ0KGMScmNI9g+0SkG1q02zCob9BH5UqLMIB/5z+pwyXdPi+PrVd94KEwfOBfEX/fZ2yPNLWn7tg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2810.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(396003)(346002)(366004)(451199024)(1800799009)(186009)(38100700002)(8676002)(4326008)(8936002)(31696002)(41300700001)(6486002)(6506007)(53546011)(6666004)(316002)(36756003)(66476007)(66556008)(110136005)(66946007)(86362001)(6512007)(26005)(478600001)(83380400001)(31686004)(2906002)(2616005)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1hXNEt1RlNSdncydVVSbUZiWmt5RG53YzVXTlBsL2FpL1I2MGJzazJSbGZi?=
 =?utf-8?B?OUYzbkhFTGdjZmIyOXU5Q29pVEp5SVlLUEszYWdLSERkY0d6M2k0cDBjTVU4?=
 =?utf-8?B?b1l3RUh5L1lldS92OU9GYmZvblBHMTJkaWE2Rm5MZnBFMlNKZzRMM0hMRWZq?=
 =?utf-8?B?Zzd0ZzhaeVlqOCtjdDlaS0d5dmhSeWFZTk1WNWtZSTN4WnNWbGEzbFFkSVh4?=
 =?utf-8?B?NnhSSlZWRi96dUlmd25LT2xhS0lmdVEydDlBbi90UEJYNittTmI1ZkdJLzhn?=
 =?utf-8?B?RjV3b0ZjaGZVRFJoZ1NLSWNzLzBDQURRbkZmK3c5dDJyUjIwQ1NZWHJoWGVF?=
 =?utf-8?B?ZElvenpCWnI2b1R4c3o2NTNVSjdjeEgrUWxrSjFyVG9FR0dtaXcwMm5XRHQx?=
 =?utf-8?B?eVRNanp6dFprdDUrakNnQkloM0Ureisya2k2RzZHWjZvTVhPeHJEZ0lSQmI1?=
 =?utf-8?B?TWlUU0xmdmFrZDB4RGxZQnFlQjR6dkpoSmp2aCtQTnYrV2M2SkVTZ0dvbmlV?=
 =?utf-8?B?RHdnWnp2Rmd0Yys0Z2FTakg3MVFqMjNWc0dEKzNuU2Mzd1F4VGozcHJscWNQ?=
 =?utf-8?B?ODdJVlJkL3pCeUQrVzVCZFdGQlFxT2J0L1pYUVN0dWxUTG9nd2EvYm9MeDl3?=
 =?utf-8?B?MU55NVV5MmdEcWRKcElIRHFOdVc3WlloKyt2UThzS0lGNlBzbzdCZEhlQXg4?=
 =?utf-8?B?UitSb1lVc1BlWkhGUG9IdFVISlF6cFI5ZDZaV1lab1plSVdHL2FxMW8ycGJS?=
 =?utf-8?B?Q0lLWlNPYVRTTXhlU1FDQjltaVBOQUVXU3hSbEFCZHZxM0VyYzB1aDg1YVBu?=
 =?utf-8?B?MGRsdENXc0ZNVlhSRDV1VS9ZZGhaV2pTRlFNVzIvQzBaWURYa0RoVHY0UC9v?=
 =?utf-8?B?Zk9FYmtyZXM5TXFzUkxSbkJiWlBHRmRnU1ZWOUZ4RUZlUE1VYVJsQ2NwNTdh?=
 =?utf-8?B?NG54bHZkdmRLdUNrNUVEeVBvQW5XUXcvb28zd0U1Q0M5L1FBZURONFJ0eUd0?=
 =?utf-8?B?cW1TaXVDbG1TemNTelhtZXhsVWZSeTRHV3dkbFhOdFg3dTJ1RUZMOWhaNWg3?=
 =?utf-8?B?RjNFUjVrT0lVZTV1OFVZUDJ3L01PQkVUR2kwQjFNSUd3NERLR0lmNXdFUmRE?=
 =?utf-8?B?N0RjUTU1c1d2alFObk93bVJadHI3N3VlVDhROGRyaUZJMlhqS1pMMWpkWG9T?=
 =?utf-8?B?NXBDRVh3NmNLRWhwbUlLY1RvcFNCZFJJNkpzQjJmc01oMnFmV1d1QWhVSGt2?=
 =?utf-8?B?WitmTG5pcjRUSXVyTzRsSC9IVjJnWE9hNC9YWDR5eHJkbUF6ay9kN3lYdEdW?=
 =?utf-8?B?SWxYWDFvZVF0MXU4Y20renFhYnp4YVF5SFRLK3Q0OU1TK2JoejVtYVZyRkJu?=
 =?utf-8?B?dXRzbDFHWXA4b0lHaUZCNFJrcllBK0V1WmlZTmkvVDltZHIzTERFR3oxb3g1?=
 =?utf-8?B?QVFPbWNiNHNwUzFGSzhueHNQM3FoUG9qR0lkTVp2WVFjSVdFZi9pZXoxZS8z?=
 =?utf-8?B?WUVCVi9sYWk1RFNjTzd0aDA0ZlJ4Skttb3UvbGZ4K3dOZzZ0ZXZCd1lzUndT?=
 =?utf-8?B?K3JrRVBweHZJWmJORXJrOVEwYXVLQWUrVENoMHlKcG5hbEh0MjZpcVpqSi9s?=
 =?utf-8?B?M1k3R0lsTGtuS2VSa3Z1ZnczT0l5SkpOQ1MvcjFaUTEzWEJFZHBMVm1HOEls?=
 =?utf-8?B?OE1taGdXU0hIcnJ0dFo1TjRmQWlYcWZaaGhvOFR1dDlFWXlkQWNvOFF1cVhS?=
 =?utf-8?B?M3o4M0dMYmJuN1FJSi9EMk5JMHpMOHYycnR0Y1RDNnVyZTdZMHJBaEpuZVhJ?=
 =?utf-8?B?bjFPeWNPSGFsMVFZRUc4ZHk2cVpLaGhHZnNCUE9nUllZTXRmUkFyZXhwamhF?=
 =?utf-8?B?QWxtMjBGUDQ0QWxYMmxFMTdPRHlKSjN2NHJnTXVSL3RDbWsvRmUzUlVOQVpv?=
 =?utf-8?B?RjlmRkhMMmM0MWlCbW8zaGxWSHIvL0dJLzc5ZG9ZMDZtdXZlNDRNR1JYYUQz?=
 =?utf-8?B?dEZKMjkzZWozOUhFZXVmUjZTNE5kSnJIZ3R3dFJsT09NSkpqQzZMMzlxR3g5?=
 =?utf-8?B?Q3ZjazJ4c2YwT2dzWitxL2VoMnNNZzFkMnBsWUtqVERxODJJWitrUG1RbUJz?=
 =?utf-8?Q?AeFIQzYHhlK+fCfU87uoSQbMz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 206349de-2fe7-4bba-c46d-08dba5555361
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2810.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 10:23:29.5534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: myKIgeF5Q/NVPcUzNZnxhRQ6FijPuW2cUSuRnxZGCaSVSdE4PuoicqnxQVV3Oyd3rk+9WuFooaTadDv9Zt+kzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7497
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/2023 4:23 AM, Sean Christopherson wrote:
> Fix a goof where KVM tries to grab source vCPUs from the destination VM
> when doing intrahost migration.  Grabbing the wrong vCPU not only hoses
> the guest, it also crashes the host due to the VMSA pointer being left
> NULL.
> 
>    BUG: unable to handle page fault for address: ffffe38687000000
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    PGD 0 P4D 0
>    Oops: 0000 [#1] SMP NOPTI
>    CPU: 39 PID: 17143 Comm: sev_migrate_tes Tainted: GO       6.5.0-smp--fff2e47e6c3b-next #151
>    Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 34.28.0 07/10/2023
>    RIP: 0010:__free_pages+0x15/0xd0
>    RSP: 0018:ffff923fcf6e3c78 EFLAGS: 00010246
>    RAX: 0000000000000000 RBX: ffffe38687000000 RCX: 0000000000000100
>    RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffffe38687000000
>    RBP: ffff923fcf6e3c88 R08: ffff923fcafb0000 R09: 0000000000000000
>    R10: 0000000000000000 R11: ffffffff83619b90 R12: ffff923fa9540000
>    R13: 0000000000080007 R14: ffff923f6d35d000 R15: 0000000000000000
>    FS:  0000000000000000(0000) GS:ffff929d0d7c0000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: ffffe38687000000 CR3: 0000005224c34005 CR4: 0000000000770ee0
>    PKRU: 55555554
>    Call Trace:
>     <TASK>
>     sev_free_vcpu+0xcb/0x110 [kvm_amd]
>     svm_vcpu_free+0x75/0xf0 [kvm_amd]
>     kvm_arch_vcpu_destroy+0x36/0x140 [kvm]
>     kvm_destroy_vcpus+0x67/0x100 [kvm]
>     kvm_arch_destroy_vm+0x161/0x1d0 [kvm]
>     kvm_put_kvm+0x276/0x560 [kvm]
>     kvm_vm_release+0x25/0x30 [kvm]
>     __fput+0x106/0x280
>     ____fput+0x12/0x20
>     task_work_run+0x86/0xb0
>     do_exit+0x2e3/0x9c0
>     do_group_exit+0xb1/0xc0
>     __x64_sys_exit_group+0x1b/0x20
>     do_syscall_64+0x41/0x90
>     entry_SYSCALL_64_after_hwframe+0x63/0xcd
>     </TASK>
>    CR2: ffffe38687000000
> 
> Fixes: 6defa24d3b12 ("KVM: SEV: Init target VMCBs in sev_migrate_from")
> Cc: stable@vger.kernel.org
> Cc: Peter Gonda <pgonda@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 2cd15783dfb9..acc700bcb299 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1739,7 +1739,7 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
>   		 * Note, the source is not required to have the same number of
>   		 * vCPUs as the destination when migrating a vanilla SEV VM.
>   		 */
> -		src_vcpu = kvm_get_vcpu(dst_kvm, i);
> +		src_vcpu = kvm_get_vcpu(src_kvm, i);
>   		src_svm = to_svm(src_vcpu);
>   
>   		/*

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

