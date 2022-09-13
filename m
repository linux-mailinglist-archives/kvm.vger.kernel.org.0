Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C49C5B7D86
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 01:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiIMXcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 19:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiIMXcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 19:32:10 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037C871BD9;
        Tue, 13 Sep 2022 16:32:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Az7YWwFXsk0lvfzsqTJrXJqO1lI5nwt0iMwmW/yvl8RsAhCcXark1OWhy1kzBWn7VdxorOnCoRb8qkjprxBd2NpGJtwNwhkqEcskA87weNMxdO9TgCCSx0G/1vhzM+mReRcqfHScUEZMHyXGEU3liG/p4Hlsv2Quaph5Onei3mU7T+Eyu/BW5wQ+uRyQiTxe0CWRALicn9Ol9Btykorb1HkItLi/O0rpqi3fN6b2waSGvjO7B2NKXjAax35RFXwbPuPc5abwAfOUO+xVDE5rYv8SFf/DrUIh+j+t0Tq7xjpf1e0HdjmnP1GfqVRmaKQ9aYTOQfR2Ufg7Ih/3zCYKdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gq92rLT0ZEkvsc80t+Dbr36p6yXkSdXrNnryuDLAoXc=;
 b=QAriD0QHEZ1HXRlSr1OM3kVs0/eORx6gm6VwI37JWylK5AnChlgofN9po673u1ydpOs9ij+PrSaYKXdvJSBz4SoiDJRg6h8BoC/0tOmg1Ri5dpGk3jOU2TNaSGxnA/Os1EmeeVl7PgcpUKPtE8H2IDe7qXcMzFSGeKWDaUgFKbuzCtROoJDV6Ea8Ui3D8Iq64hCU1A0rQrrAFspuhonoWniD4uhWVjF1FSav1V4l5OFCuQiA8VKMvNBKc/640KsSmMNDbr4OedS8WdlVgEjz2T0xx9lIHvqRJKM0l+q1A3DVfHuyn1S4pjLUPvjqiYcqoyOXmepveh1plzYTvOjo5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gq92rLT0ZEkvsc80t+Dbr36p6yXkSdXrNnryuDLAoXc=;
 b=g0jsK6J3XE49NzEVx+6iNEFfzNZhEwSHe6djRz7dLLHsgUH+HAswodSGEojPVoU6B7Ry5mlPG/DU0NyOwMtesCamsZS+F7UrfKvpGlnoTQqs6Rw51i9hz3jgMRyfky0iY4k5ooJLr1eEU74BDmPCX0XBuj3X0Ti0P3xSRO8JhtU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 SA1PR12MB6821.namprd12.prod.outlook.com (2603:10b6:806:25c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Tue, 13 Sep
 2022 23:32:06 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::2cdd:defc:a6d3:7599]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::2cdd:defc:a6d3:7599%3]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 23:32:06 +0000
Message-ID: <aedb7677-528a-75b7-6517-ab1865515ad4@amd.com>
Date:   Tue, 13 Sep 2022 18:32:04 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2 13/23] KVM: x86: Disable APIC logical map if vCPUs are
 aliased in logical mode
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
References: <20220903002254.2411750-1-seanjc@google.com>
 <20220903002254.2411750-14-seanjc@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20220903002254.2411750-14-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR12CA0030.namprd12.prod.outlook.com
 (2603:10b6:610:57::40) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|SA1PR12MB6821:EE_
X-MS-Office365-Filtering-Correlation-Id: 48128192-02d1-4bba-dd48-08da95e02b9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wyus2OGbuGIDF8sOuBBuz5SiOk+72E+jA2h9GPL80aJGVouyBEj9kdIbYUI+ezTt4yVIhp4jobjAPAujMg/ke+0PJNvhpflkRA9Nr8BECNakrA9kTMe+X39BcXOwMPEwVn1OeDg78OAmu61V+7kgGbUJt21AvDL/U6lqG9v5GINIfGehq9bmG1QpkU/DvruEhrcZtwB+axgzk7Bo3eL3uutVnSCghvCcbPiFGwduGvR44yrQjTmqmQWdBk8Qz6Ogf63rPjCCc766mNkZd5fCp7kFBcfadPNheatRGdeB80c05AAq7eqCTkgM7AnXGZcLBSwsiXy6HBetIeX60X8Q+P2r/VM2BlLSftRG/0x+5RwyFNAql+u/JJ7bfjc5u1EuNv42SqliZpM1SER8zoa9WGUKhMI8VB72DfkGc6p4e3geCZy7iQHkvKo4TWjttXa8GBdwSi9LSg19HHJpufptCbGWALCaCwKrAyAJmck8V6pZhQIpDLDtdGV+lPnThH/NS7dB4dsUHJkEiQm6YLJTx2pqVg3Mn6sO+XD4cAw+A5PU+63F/vqud/r7qZNoa9zrG1tUSUwK6GdXL/ku8vvPW57opZIhB+qCs0s50dbHIlINy+rEDE8CcVafqsP0+wbPXp1npSIwjBuwljAwjO2zmgnDX09ORXZ+lsE0F0uytSYwyEDm/S1SeUWl+ULRjBENZVQ+witEi//+hPDeD0hpRQ8SppN1apzulPZjPOMoYnXiatDmMwFeIWgjo2F6epfNkUPFvOS7bX9KAQES49ClH37IZJENsCnrLDoURqS14X0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199015)(54906003)(26005)(31686004)(8936002)(316002)(41300700001)(2616005)(110136005)(6512007)(66476007)(83380400001)(2906002)(4326008)(53546011)(38100700002)(36756003)(6506007)(6486002)(31696002)(186003)(5660300002)(86362001)(478600001)(66556008)(8676002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmN6V1lKQndhbkhOaGsxMjF0WWIzU1RRQmJpM0hrckh6djY5N01OWXA1MFZa?=
 =?utf-8?B?d0FqeUJQZVJac1JsN0IrRlVmVTFuY25ySm0ycUs5VGFLQ09TSUVUVWlHbnJP?=
 =?utf-8?B?Ty9XTHNpTkRHUmNmZE9qV3dkNC91dVN2OXA5cUpzNXkrWjhTNFhjUzFzbHc5?=
 =?utf-8?B?SFV2cklDQjI1Z1VEOEZsd0NtTzIzR2l3eWlBRi8wL2ZtVUZCVkNJd1FBVDEx?=
 =?utf-8?B?Q2l6Vk5ZcGVXVmJWbFU3T0RlNnFMNHNiUFZ4aThVSTBqOHZNRXh4M0hOSE1L?=
 =?utf-8?B?aDF0MWpESEdLTlpFK0M1Q2lEZmdKRXJUVjhiS3RYYlB1NUNrYlhVLzVVc3RD?=
 =?utf-8?B?Wm53aFlPd3JtY3ptaExFVVZuVkNYT1F4SEY4WEVVMWFZMUlpem5KZ3RmK2lw?=
 =?utf-8?B?WENUSmNFV0s3M2N2a2JuUmN5SDVYTWtoaDRGNmRTTWoyTzdoVUhtSkl1c3Vt?=
 =?utf-8?B?Y3BDbWZXaDRmM2QvSmx3RjdkTVVKUVJKeVcxcFk1MXlkYUNqZG00MGRaZFpr?=
 =?utf-8?B?c1Q0UGgrVXc1WG9mVm0yTHEzSEhKSElyWVlkWWZGRytvd3ZGd3JHUUo1cG82?=
 =?utf-8?B?MlhNQ3k4c3R3TWtxWTJRWW5ZVkxTZHpoWXlDeEw0a1Y1amNhRHZKdkxxbXZ1?=
 =?utf-8?B?cHB4NlUvRjFwVkpzc0R3SUxvWURBMXY3RjVpMGltMDVGdm9mdENqbUZyOVhQ?=
 =?utf-8?B?QXR3QnROOVpUM1BVK0oyUkZBZlUrMXNJWXNWbDk0ejFRZ2RZSWRIOTZXZk0v?=
 =?utf-8?B?Vy9DM2w1QjhhOU9xYmJJRy9EQm53M3Zua1JocW95T1ZYb2JkV003RWVvSXZI?=
 =?utf-8?B?U2kyeStDcW1LMzUzQklHMkdXMGlCTmdSY2JxYjVLbm9ibHFqWG9zbVVEYjZX?=
 =?utf-8?B?WUdOeStKSlhnSldUZDNHd2d6OWZPbnZZazRCc240a0JsWVNKRUUzY3ZsdEpO?=
 =?utf-8?B?UGVXSyt4OVlpMWVZZHhjQlNJM2pMRDhKVU5FMVpGSmxkWVowV3lORWFROVJ2?=
 =?utf-8?B?RGNsUVZJY2k2a3ZOVEdWY2ZMWXJkeGN2UVZnR04zSnhYaHAwb2ZQaC8vRkx5?=
 =?utf-8?B?RStha250eDh5K3M2N0xzOXFzTmV2R0VpK0ZQNmJzcUFyaHhwaUhESlZjMkE3?=
 =?utf-8?B?ZDBpREl5cVdQdjIxWVN0NEcybU1aTXh5UnY4akF2eDI5eGVWU2RPOHFUV29L?=
 =?utf-8?B?c3oxUk9KR1ZDK1N4VjUrRXRHVkxoMmF5djhmUmtRbWNiOWdyNVFjOUtoZjNI?=
 =?utf-8?B?WWRxOHVLREdQRnMvenJEb2hFZlQ5K0c4VkFxMFlScmJ1eVJQQkFLSSs4ZnRs?=
 =?utf-8?B?NjVpeHRndUJlNm1hNmJJWUxrTlZSckJ0ejdkRWRhTDVZOWgvbFdGTnJrdnBB?=
 =?utf-8?B?Nlo1K01UZGZMdmhwZjRXUmNJc1c2SVlHOEc5TUdTczZTOWFMZ1BXVklCYWVG?=
 =?utf-8?B?TlVJVGxmeXdFNStiU3U1R2N5NU1HTU9xMkN5RFp4N0V0c0JhZVhtNUVSWEQ0?=
 =?utf-8?B?dVVBcjRteVB5Tk1TcW0wN2dLbGowRkR6NnczZEJobWMyUDN6UU0wMW1DYWlO?=
 =?utf-8?B?NGFNRWFkR3lTZmdoQVU4QmNyOVRWYVhoMGZTczcvcEZTSlJZUDc4eFZpdW92?=
 =?utf-8?B?MkhSOXUwYmFJeVlIZzYraXI3TWcxcnBWaldMTzBTVms3K0hnQmFUV2c1Mk5H?=
 =?utf-8?B?VXpFT3hRSWVNckdGRXNtd0hTc2hoaXE4TEFKVmI5THN4alQ0bW9SclVzVXZT?=
 =?utf-8?B?aUhXVHhmUmYxYmpmMGFDU0VsUCtJdmpuSTRTK1luOXlGWVR5R0VCSnQzZ1Zv?=
 =?utf-8?B?ek9hZE5HUnhWdVovU0cvbFd1MGdkbTQxZlhYcnY1c1JRbGRIUzc4YTk0UUkr?=
 =?utf-8?B?clczbjhFYUN5SE1uM1E5L2VoRXhCd1NzM2U0YzZxcFpYaXl1Q0kzTDhOWmZ3?=
 =?utf-8?B?WVlwaWRucnlSUGJUdStta0pkUEoySW52YlF5SjUrVjUyK1ZoQVRLc01QTnhP?=
 =?utf-8?B?Y0FmMDFYd2p5ZWxrMjRFVy8yeUdsMXdIdEZydnhxRTEzS1pmY2VaVnFhVHVi?=
 =?utf-8?B?THNTUVhQVHAwT1JyWXFhYk1oVDN1WmJUOVZRZTg3eHJGZ1dtS21xUWluRjRm?=
 =?utf-8?Q?7PejfRKj7zlHoyJRpUYc1WrE4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48128192-02d1-4bba-dd48-08da95e02b9b
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 23:32:06.4757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9g9WpNy7CVOvMuNoHAOTK8OfWGu+5D3UeaU5SjwLT4kLs/fI6AaqZijOF0iMZZhv/9IMxvAgaj00tenLxGWngg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6821
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean

On 9/2/2022 7:22 PM, Sean Christopherson wrote:
> Disable the optimized APIC logical map if multiple vCPUs are aliased to
> the same logical ID.  Architecturally, all CPUs whose logical ID matches
> the MDA are supposed to receive the interrupt; overwriting existing map
> entries can result in missed IPIs.
> 
> Fixes: 1e08ec4a130e ("KVM: optimize apic interrupt delivery")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/lapic.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 6b2f538b8fd0..75748c380ceb 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -303,12 +303,13 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>   		if (!mask)
>   			continue;
>   
> -		if (!is_power_of_2(mask)) {
> +		ldr = ffs(mask) - 1;
> +		if (!is_power_of_2(mask) || cluster[ldr]) {

Should this be checking if the cluster[ldr] is pointing to the same 
struct apic instead? For example:

		if (!is_power_of_2(mask) || cluster[ldr] != apic)

 From my observation, the kvm_recalculate_apic_map() can be called many 
times, and the cluster[ldr] could have already been assigned from the 
previous invocation. So, as long as it is the same, it should be okay.

Best Regards,
Suravee

>   			new->mode = KVM_APIC_MODE_XAPIC_FLAT |
>   				    KVM_APIC_MODE_XAPIC_CLUSTER;
>   			continue;
>   		}
> -		cluster[ffs(mask) - 1] = apic;
> +		cluster[ldr] = apic;
>   	}
>   out:
>   	old = rcu_dereference_protected(kvm->arch.apic_map,
