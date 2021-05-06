Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1F5375C43
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 22:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbhEFUcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 16:32:45 -0400
Received: from mail-mw2nam10on2060.outbound.protection.outlook.com ([40.107.94.60]:43392
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229965AbhEFUcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 16:32:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLNY8nDDflGVLHgrItPJ3jmUY10jSVw/vE7o/BXjD7A2UrpCA/LBP0acW9E5tctu51YdSpNgTAPaB6/J9YaI/+IMDfJr+ZEjRB5j7Tv4l5hZ5ooZp+q3Xunxmbtxvt3kx1K6qC+abR5ObgPCrc4qMgScHhIDFnQlbUjSTVc260NuwFHH9dej/ReVVntiAGo73Qqb3wn8gI3rn2Nq0wcCtcC3KXh3TMX58+j7Ov/9pV6N/Nim2L+4k8QcgUJ/QMJqZSPeugKV5rn0TxJW2RkrPZaW3O87OOUebZsyucPog8ieh7bTgEVCkNT0mPfK9WXx7ArtfVkmoEOFN4Hj9no2rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtcquEdwBXyPddvmV366xFLXx/ifoHZra35QirxoOoU=;
 b=RrfAWWtHD1QoNIfcIrx/A9XIt7bx7/AvkB4jqApluFa6uliRlkj/E+2WFrV2elNq5U4WYtelixJQcHWBKGmVGfpmlkwVF0RF2jbdH1rG17dOO59pT62XT5470aknzPZlUmNuuhHJBrOOQ0mLGpN9DhmYhuQ4XuLIwuJJVjaJkMoFZ1NV5DsA8kuKX2bBxswnwsFMRI6E7FhoDn16eRF1+w6B0m54R4rPPEqIbniBvwAi4xoL5lcZID8veNHkbbqUcXe1OiFyLsLZXvBvazf2ItXiCBRoHN0Xlk2K7P2M1rw1Y6RmASrx3oiCldrfV+LnDAM9FtZrhdyASm8nCnG+gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtcquEdwBXyPddvmV366xFLXx/ifoHZra35QirxoOoU=;
 b=0A/ebdCBUpE3eroXTPNQnI232a8IkYCqtuGk+ZIlkTtaNd52P/tsut0KhN0oOUHr2Rn2JRrEHF5P0eOlxofUrACwaP4nKr5YSdXpe6AiwMA1RcTj7ydWjlMlC3esqcAWbwWZn8nfJf5hiab6cXVghY/dwf+IvsaA3diZuWXkbGA=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4748.namprd12.prod.outlook.com (2603:10b6:5:33::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4087.40; Thu, 6 May 2021 20:31:44 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4108.026; Thu, 6 May 2021
 20:31:44 +0000
Subject: Re: [PATCH] KVM: SVM: Move GHCB unmapping to fix RCU warning
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <b2f9b79d15166f2c3e4375c0d9bc3268b7696455.1620332081.git.thomas.lendacky@amd.com>
Message-ID: <23e99df1-cfb5-e3d9-4de7-f573f4bc7532@amd.com>
Date:   Thu, 6 May 2021 15:31:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <b2f9b79d15166f2c3e4375c0d9bc3268b7696455.1620332081.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN7PR04CA0056.namprd04.prod.outlook.com
 (2603:10b6:806:120::31) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN7PR04CA0056.namprd04.prod.outlook.com (2603:10b6:806:120::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 20:31:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28e830ac-83ec-4279-a315-08d910cdf683
X-MS-TrafficTypeDiagnostic: DM6PR12MB4748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4748984BD65B168A344A5B2CEC589@DM6PR12MB4748.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qNlDyvSrXthbyMC2CwOss9zZ41WHXh23QNnOOUZLG9do+7Q9XeEf/WpDko1kztUzzV+ICPxoo+kP7fb75mXSSNwyEg7SX9saR4tv5nfROx8141aDtWV22xwCkRiQ3QMUi786HalYeH8rSm/1KSkAYxe9+SMzW0hI9bSLAbwSLhCAZ2lw7nPx+8413sAwAhAlf62YYwkamNpQxIa9cLPwmcuhHJB6IlgsL+k99wu4G3JtKGG9awOwgHTZdUftIUe3F5KxLgeeS85zuBwMogyID1OolVDD+n5ibVsvbuDHv+xNgMiS7cCdU1zmBTVMBmO1jVhjgppu04rfh3LWH9zPMPhjU+ExKHwHJC+IXwpobqyq2jTiiDqGV34wdYAqOeHv2/hNW/JZM33Z/vLiZ6OGBiJhj+4PxGUDGgnYjGG3nAs1HHmEsl+hUzo1VLFNj5/1cTc+DV8sZO9MuFMB7QysmWonwO6kEOVPfNjX0FnCCUCrZoYka6X532qxO6mrc8p93QdoF8zG2rp+zW85Nbk58E7nLv2KbuQ3L/gRLzAKDlNiHlmyvEZMHCrnSZhwwT7N2dW3t0uJ2Bjznlu1E4CShAPzcvj/RDxNs8CMjombcLAV4C85NB78EiAGGtT1CQrDy08Avrx91p89y7BgW/7td5P0OZEAwksu96MDi9UFJsBvzr4BFgfOQPKfgH4dzpRB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(366004)(376002)(5660300002)(2906002)(53546011)(66946007)(66476007)(31686004)(478600001)(31696002)(66556008)(4326008)(86362001)(956004)(2616005)(6506007)(6486002)(83380400001)(38100700002)(54906003)(7416002)(16526019)(26005)(316002)(8676002)(186003)(6512007)(36756003)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b1krVkdreER4Y09hOXBNT25FL2RIRktydm03Kzhod1VWbzZ6cDh6OERPSExX?=
 =?utf-8?B?WGZZQVoyM2s4dXcyUU55VWVXNWg2eXIzUThndElQT2lkVHEwaStMQzB4aGVV?=
 =?utf-8?B?T2lpUVBTRmYrc0RuRFFZRU5DRzZJRURsSWovTm5lZllNblE5MHdicXFIZk1z?=
 =?utf-8?B?NjZsZG5nb21Cem83aURMTE1TSElLd3RkT2UyVmxKOVdSN1pCajdiU05nZmVz?=
 =?utf-8?B?RmMvc2FjWUZ1d1ljeFZ0NlhYVVRpTUdrK1FmRE5Yam92cnZ4UlJOZVE0VTRM?=
 =?utf-8?B?dWdzSGlZMUlab21pMFFGUEZhLzR3alROTi9qTVpYeVZoUDltei8rYlY0M09D?=
 =?utf-8?B?SFNUNk9hRkVtTnJlTTdQVkx3dnd1WjRWMisvRWVzckljaDBpRENxbTRjTDlZ?=
 =?utf-8?B?WmticVJTWFBNNnRLbCtiT2ZXcTl2QjBBMGtPMjB5NktJZU4ySVdmQ2lZRWRO?=
 =?utf-8?B?Rkk1WnVXaGFtUU1jc0lYSFFVR1Rwakk1ejJRN3B4Y3A0WWF4T2JEY2JXK0t3?=
 =?utf-8?B?a0JEdWxwREt0c1VNTmoxeXd6YTRvWk4yVGJGdy9XY1B2R0hxT1J2M0xqblJn?=
 =?utf-8?B?VHkxTDBvemFFT2phdW8xNjh0TkFOaFJNVkEyUk5taDhDUGxIVStua0o3bmp5?=
 =?utf-8?B?bGpBR0xIaG8yNnlkSm56K0pIaUJCLy9lVW9DRC9aQ1krN2ljMHZhZWl2SEIz?=
 =?utf-8?B?MnR4TGNmL3dEWExwOTNLYlVHb3RWSnVqaWYyMkVxWUR6WVB6bWZKU0E3QmtR?=
 =?utf-8?B?bGRmdzU1T1BidEdsbXBncEhCK01QV0dqK0VuU3NJeHV2ODFXMzV2R3hQejQ2?=
 =?utf-8?B?d3c1NUxpeHBkTFVPYk85aTQ3NWppa2tSTE95ZVh3ZnhnV1JGam1ZTXpFZTBM?=
 =?utf-8?B?TFF0MUhOYzhrbkJkUjN5SUg2QzA3Y1RtZnVSTDR4eTJRMlpaemRON2JvNGNq?=
 =?utf-8?B?bFdFREJodVRrdTZqc2FSeWdiYW5SWnRYWkdwc1VhdEVBbzA2ZjBCK2I0dVBh?=
 =?utf-8?B?emRlMlBMdXp5SDNvajBuR2tDanJuSnBKMmlZc3RZUDBYVlh0K0owbjgyejdG?=
 =?utf-8?B?NU05NmpaVEFxSEtqYktPemNHcEk5YWxJa0RxUjV6Nm9OR1JjQkJFS2RXOXQ5?=
 =?utf-8?B?RW0vdVptSWlUQzM3aU9nVDduaUlhN1M3amtBTmptOEwxVEgvNnZqSnJUTFE0?=
 =?utf-8?B?ZEZWTTA4N3BGK1o1ZnE1YjB5QzNKVE8vcm1uejQ0bCsrMkZ5dlZRYmw1VmlW?=
 =?utf-8?B?NUJSWGpOYTVoV0JNOHhVRHJkVzNOMW1FOFJEMTdJQldpWkFYVDA5a2JMUndr?=
 =?utf-8?B?YzBRVzcxblRCWU54enBlSWhlc2tyQ3lFTHFLTkpPd0cyeGYzaXlJK1dsaHVL?=
 =?utf-8?B?L3o3cVE2M2F4RjhrU2lHQ3hZMUt5S3hKMVZUeXUwRWhScXU3eHF2Q1k0TTBW?=
 =?utf-8?B?Njg0UDlQeklPNERjaVR5RXVRcysyT2UxRlZOQWQ0VmJKaDlvbnY2NUxwMkRY?=
 =?utf-8?B?UDFzdjBGNnowd1hQVi9zWUJLUmhiY0FFSzdqY1pUUFlhMXNHL2tQMFIrOUxC?=
 =?utf-8?B?UlQ3R0crbTRhSVQ4T1VVQ01OMWxjbDlORENBMFNnSWw0b3pPUlU5R3ZSWlFi?=
 =?utf-8?B?ek1JQS81cDJVVmlnTlhJaTVZSmF2cDFtWGE4aVNaZDdMVnR6YStUQlY4aUJH?=
 =?utf-8?B?aCswSG5Ick9ERENrb3p3eFhtWU5JTlVWV2poc0JPdlZHSHFVS2ZSVG9LQ25M?=
 =?utf-8?Q?EALeMFSF6bgVLu01R6dkmG4vntvtxiV9PRSkT/t?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28e830ac-83ec-4279-a315-08d910cdf683
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 20:31:44.1037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z60GFQMlix+qGygjvpbhzL0XrYLvni2DgZ+Wui/LRxY2v31ULpdIOkBtFV/62ZcVl7l21MgzOxGyCgsEbipXgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4748
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/21 3:14 PM, Tom Lendacky wrote:
> When an SEV-ES guest is running, the GHCB is unmapped as part of the
> vCPU run support. However, kvm_vcpu_unmap() triggers an RCU dereference
> warning with CONFIG_PROVE_LOCKING=y because the SRCU lock is released
> before invoking the vCPU run support.
> 
> Move the GHCB unmapping into the prepare_guest_switch callback, which is
> invoked while still holding the SRCU lock, eliminating the RCU dereference
> warning.
> 
> Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")

I added the Fixes: tag in case this is to be sent back to stable. But,
5.11 SVM support doesn't have the prepare_guest_switch callback, it was
added in 5.12. This will apply to 5.12 with some fuzz.

Thanks,
Tom

> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 5 +----
>  arch/x86/kvm/svm/svm.c | 3 +++
>  arch/x86/kvm/svm/svm.h | 1 +
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a9d8d6aafdb8..5f70be4e36aa 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2198,7 +2198,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  	return -EINVAL;
>  }
>  
> -static void pre_sev_es_run(struct vcpu_svm *svm)
> +void sev_es_unmap_ghcb(struct vcpu_svm *svm)
>  {
>  	if (!svm->ghcb)
>  		return;
> @@ -2234,9 +2234,6 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
>  	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
>  	int asid = sev_get_asid(svm->vcpu.kvm);
>  
> -	/* Perform any SEV-ES pre-run actions */
> -	pre_sev_es_run(svm);
> -
>  	/* Assign the asid allocated with this SEV guest */
>  	svm->asid = asid;
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a7271f31df47..e9f9aacc8f51 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1424,6 +1424,9 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
>  
> +	if (sev_es_guest(vcpu->kvm))
> +		sev_es_unmap_ghcb(svm);
> +
>  	if (svm->guest_state_loaded)
>  		return;
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 84b3133c2251..e44567ceb865 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -581,6 +581,7 @@ void sev_es_init_vmcb(struct vcpu_svm *svm);
>  void sev_es_create_vcpu(struct vcpu_svm *svm);
>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>  void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
> +void sev_es_unmap_ghcb(struct vcpu_svm *svm);
>  
>  /* vmenter.S */
>  
> 
