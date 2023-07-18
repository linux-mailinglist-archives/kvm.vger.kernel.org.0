Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0B07585B1
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 21:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbjGRTjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 15:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjGRTjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 15:39:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA122198D;
        Tue, 18 Jul 2023 12:39:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3T8Ft/NWlNqV0H+X7E8MfrRki6/MXEe6NYKGd0otAfA5h0mK3tXYXjoUOzGHWkVff1JDvp4AOCfqu1UWISvX5hPcPj/A8UNp2T2p6av+lR78Bo68McvhinjAehcYNdiKunnhuIJXyhh2lJI/plOBnmgrvgdSBl73ovRhljHsVBrGGhVV8nekI84Lib1O5BK1zkYv6HyWjDivcFw+ORYLZ9FPw0guOJAiBbYU9y4L5DeuvDNTPcFs+e37V8w7ewGiLoPacbQZ/QoJ3m0JJ5R+bn8MadKqq6VEDiyNtroH++kqweeKDdPWnnnkNFeoXWDE/8jhQchEB8SVEii3LOc7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sX3b6Ao7ClSmGUIj9QEySeXz7L9io/ojEwfOPrvZraE=;
 b=ZH9awWAZsqYTWsBhKQVQFJHKPljvJWF2jrgs3b8G1Ih0cCjHUmCk1Au0xN1U0y2z820svYILNmhqj+i/ru7gR70cCF4BZA50pO7vJTvoIXnx8OCGglFAiyLYJ8dpdGBdls4HnABJ5nyIzfHTRf+5mPmz23cG7Rb6OzZwpwsHJz7Ft5c5okEztAU3D2d/uMaH1qR3Zi6vOp4RJueFjsMl+K3bWbqrfbWtukQe2sbzj9flr1UsmiHlqwFbTWVHEfbcND9Ym8IVt1jdOqPfp4TUsV7n/fJGrX1lAAwMUhQgNH66M5UIRflS2PP4kLq/KIWrQUEplifLYnB632VMS5XUEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sX3b6Ao7ClSmGUIj9QEySeXz7L9io/ojEwfOPrvZraE=;
 b=GqbLhjd/deNPz9ImfRiQSw+kN4RScgNCrU1L5gNJmaj805HFeuWPLoUsfuL7fKXa7z1lx+McGiOK27NIJdH94tAWj1DbMF0iOgIbhXrx2GM0U7BS85RfMIIPTs7ji8OkS2/8tfsIR3/QpNN5p2ne5VgoE8E7IU5JJXMZsqcCDw4=
Received: from SJ0PR05CA0056.namprd05.prod.outlook.com (2603:10b6:a03:33f::31)
 by CH3PR12MB8282.namprd12.prod.outlook.com (2603:10b6:610:124::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Tue, 18 Jul
 2023 19:39:43 +0000
Received: from DM6NAM11FT086.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:33f:cafe::cf) by SJ0PR05CA0056.outlook.office365.com
 (2603:10b6:a03:33f::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.23 via Frontend
 Transport; Tue, 18 Jul 2023 19:39:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT086.mail.protection.outlook.com (10.13.173.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6588.34 via Frontend Transport; Tue, 18 Jul 2023 19:39:42 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 18 Jul
 2023 14:39:39 -0500
Date:   Tue, 18 Jul 2023 14:39:18 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <isaku.yamahata@intel.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        <isaku.yamahata@gmail.com>, Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>, <chen.bo@intel.com>,
        Sagi Shahar <sagis@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH] KVM: x86: Make struct sev_cmd common for
 KVM_MEM_ENC_OP
Message-ID: <20230718193918.rgluetgaiuib662g@amd.com>
References: <2f296c5a255936b92cffde5e7d6414edfb93f660.1689645293.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2f296c5a255936b92cffde5e7d6414edfb93f660.1689645293.git.isaku.yamahata@intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT086:EE_|CH3PR12MB8282:EE_
X-MS-Office365-Filtering-Correlation-Id: d993590a-3060-46d2-51ee-08db87c6bbb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oOZdtfZK6IxFI0PZ6J38dYn8iUiKWPVGPrNybyFngtska+zcMcMduqHLbgeH5WDK/JW0OcJOH/jr5aJ8QeH1sPdXoImj+rypajxrt5Tb5L+Lh2G7+s6/d4w3HumiGtnMsa4xCgkGufj/iHwZH9uWce56cMAs/3OTRqON7BXZRH7Ja1Te+taeyH4r+a935Ak2ILWyiyxuR+uG/pOXPWlCLRJtKHIL06XimCc5y3kMS/jdQJdy5ykwOUjvmRmtePgHz2BhmIZNVx0gkf0PWeb/2KGIlMa7oq/N6lopWY6LxgBIMIVDvGtEyfkwB4BU/bkxopSdCHfhqcJ+6/hPvW4YJF4rFnj6KBsyA8XBh+RuGyBGXNWibWIOpel8JVFWnpi05lI2tPZwRFn7dEZ919uD3lycskYwh2ikCB88rjmfFtKFFd8uZ0Uy5PyZA+Bc0LXVSaJcaFAQ4SAiM+OTv6U/qJTvLNoEcOYLqqwhWkgFVJAmraB7BoXKhrA4mWzq/9YQHB76VRJaTD2HJWQm4ShYlablq7185E/RvOupdrSe8ggkPkB5229klaSev5XgdWOX+2+fjiShm4ZQXcW/wV3C+/ElR1l8suawqk9B6wcygeMEizdK7BAogciw2dsLacwz+7EhAjCW8SLQ1zanjQCeo/0qCzfXoAq2Gm3bSIczXH06Ip/9NRUVSBjRVTXQxuf9utzidHzOUsrqY8d+BoEsrdeTjWX6pkoUUnTW9gH37vZ6o/Tco6Lq4DngsgFMpQGmfdIltP4bKkKrIXqYPb4rBw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(346002)(136003)(82310400008)(451199021)(40470700004)(36840700001)(46966006)(2906002)(44832011)(7416002)(8936002)(8676002)(6916009)(4326008)(316002)(41300700001)(5660300002)(26005)(336012)(1076003)(36756003)(186003)(70586007)(70206006)(478600001)(6666004)(16526019)(40460700003)(54906003)(83380400001)(47076005)(2616005)(426003)(36860700001)(82740400003)(81166007)(356005)(40480700001)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 19:39:42.4838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d993590a-3060-46d2-51ee-08db87c6bbb6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT086.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8282
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 17, 2023 at 06:58:54PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX KVM will use KVM_MEM_ENC_OP.  Make struct sev_cmd common both for
> vendor backend, SEV and TDX, with rename.  Make the struct common uABI for
> KVM_MEM_ENC_OP.  TDX backend wants to return 64 bit error code instead of
> 32 bit. To keep ABI for SEV backend, use union to accommodate 64 bit
> member.
> 
> Some data structures for sub-commands could be common.  The current
> candidate would be KVM_SEV{,_ES}_INIT, KVM_SEV_LAUNCH_FINISH,
> KVM_SEV_LAUNCH_UPDATE_VMSA, KVM_SEV_DBG_DECRYPT, and KVM_SEV_DBG_ENCRYPT.
> 
> Only compile tested for SEV code.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/include/uapi/asm/kvm.h | 22 +++++++++++
>  arch/x86/kvm/svm/sev.c          | 68 ++++++++++++++++++---------------
>  arch/x86/kvm/svm/svm.h          |  2 +-
>  arch/x86/kvm/x86.c              | 16 +++++++-
>  5 files changed, 76 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 28bd38303d70..f14c8df707ac 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1706,7 +1706,7 @@ struct kvm_x86_ops {
>  	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
>  #endif
>  
> -	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
> +	int (*mem_enc_ioctl)(struct kvm *kvm, struct kvm_mem_enc_cmd *cmd);
>  	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>  	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>  	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 1a6a1f987949..c458c38bb0cb 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -562,4 +562,26 @@ struct kvm_pmu_event_filter {
>  /* x86-specific KVM_EXIT_HYPERCALL flags. */
>  #define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
>  
> +struct kvm_mem_enc_cmd {
> +	/* sub-command id of KVM_MEM_ENC_OP. */
> +	__u32 id;
> +	/* Auxiliary flags for sub-command. */
> +	__u32 flags;

struct kvm_sev_cmd doesn't have this flags field, so this would break for
older userspaces that try to pass it in instead of the struct kvm_mem_enc_cmd
proposed by this patch. Maybe move it to the end of the struct? Or
make it part of a TDX-specific union field.

But then you might also run into issues if you copy_to_user() with
sizeof(struct kvm_mem_enc_cmd) instead of sizeof(struct kvm_sev_cmd),
since the former might copy an additional 4 bytes more than what userspace
allocated.

So maybe only common bits should be copy_to_user()'d by common KVM code,
and the platform-specific fields in the union should be separately copied
by platform code?

E.g.

  struct kvm_mem_enc_sev_cmd {
      __u32 error;
      __u32 sev_fd;
  }

  struct kvm_mem_enc_tdx_cmd {
      __u64 error;
      __u32 flags;
  }

  struct kvm_mem_enc_cmd {
      __u32 id;
      __u64 data;
      union {
        struct kvm_mem_enc_sev_cmd sev_cmd;
        struct kvm_mem_enc_tdx_cmd tdx_cmd;
      }
  };

But then we'd need to copy_from_user() for common header, then for
platform-specific sub-command metadata like sev_fd, then for the
sub-command-specific parameters themselves.

Make me wonder if this warrants a KVM_MEM_ENC_OP2 (or whatever) that
uses the new structure from the start so that legacy constaints aren't
an issue.

-Mike

> +	/* Data for sub-command. Typically __user pointer to actual parameter. */
> +	__u64 data;
> +	/* Supplemental error code in error case. */
> +	union {
> +		struct {
> +			__u32 error;
> +			/*
> +			 * KVM_SEV_LAUNCH_START and KVM_SEV_RECEIVE_START
> +			 * require extra data. Not included in struct
> +			 * kvm_sev_launch_start or struct kvm_sev_receive_start.
> +			 */
> +			__u32 sev_fd;
> +		};
> +		__u64 error64;
> +	};
> +};
> +
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 07756b7348ae..94e13bb49c86 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1835,30 +1835,39 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  	return ret;
>  }
>  
> -int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
> +int sev_mem_enc_ioctl(struct kvm *kvm, struct kvm_mem_enc_cmd *cmd)
>  {
> -	struct kvm_sev_cmd sev_cmd;
> +	struct kvm_sev_cmd *sev_cmd = (struct kvm_sev_cmd *)cmd;
>  	int r;
>  
> +	/* TODO: replace struct kvm_sev_cmd with kvm_mem_enc_cmd. */
> +	BUILD_BUG_ON(sizeof(*sev_cmd) != sizeof(*cmd));
> +	BUILD_BUG_ON(offsetof(struct kvm_sev_cmd, id) !=
> +		     offsetof(struct kvm_mem_enc_cmd, id));
> +	BUILD_BUG_ON(sizeof(sev_cmd->id) != sizeof(cmd->id));
> +	BUILD_BUG_ON(offsetof(struct kvm_sev_cmd, data) !=
> +		     offsetof(struct kvm_mem_enc_cmd, data));
> +	BUILD_BUG_ON(sizeof(sev_cmd->data) != sizeof(cmd->data));
> +	BUILD_BUG_ON(offsetof(struct kvm_sev_cmd, error) !=
> +		     offsetof(struct kvm_mem_enc_cmd, error));
> +	BUILD_BUG_ON(sizeof(sev_cmd->error) != sizeof(cmd->error));
> +	BUILD_BUG_ON(offsetof(struct kvm_sev_cmd, sev_fd) !=
> +		     offsetof(struct kvm_mem_enc_cmd, sev_fd));
> +	BUILD_BUG_ON(sizeof(sev_cmd->sev_fd) != sizeof(cmd->sev_fd));
> +
>  	if (!sev_enabled)
>  		return -ENOTTY;
>  
> -	if (!argp)
> -		return 0;
> -
> -	if (copy_from_user(&sev_cmd, argp, sizeof(struct kvm_sev_cmd)))
> -		return -EFAULT;
> -
>  	mutex_lock(&kvm->lock);
>  
>  	/* Only the enc_context_owner handles some memory enc operations. */
>  	if (is_mirroring_enc_context(kvm) &&
> -	    !is_cmd_allowed_from_mirror(sev_cmd.id)) {
> +	    !is_cmd_allowed_from_mirror(sev_cmd->id)) {
>  		r = -EINVAL;
>  		goto out;
>  	}
>  
> -	switch (sev_cmd.id) {
> +	switch (sev_cmd->id) {
>  	case KVM_SEV_ES_INIT:
>  		if (!sev_es_enabled) {
>  			r = -ENOTTY;
> @@ -1866,67 +1875,64 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  		}
>  		fallthrough;
>  	case KVM_SEV_INIT:
> -		r = sev_guest_init(kvm, &sev_cmd);
> +		r = sev_guest_init(kvm, sev_cmd);
>  		break;
>  	case KVM_SEV_LAUNCH_START:
> -		r = sev_launch_start(kvm, &sev_cmd);
> +		r = sev_launch_start(kvm, sev_cmd);
>  		break;
>  	case KVM_SEV_LAUNCH_UPDATE_DATA:
> -		r = sev_launch_update_data(kvm, &sev_cmd);
> +		r = sev_launch_update_data(kvm, sev_cmd);
>  		break;
>  	case KVM_SEV_LAUNCH_UPDATE_VMSA:
> -		r = sev_launch_update_vmsa(kvm, &sev_cmd);
> +		r = sev_launch_update_vmsa(kvm, sev_cmd);
>  		break;
>  	case KVM_SEV_LAUNCH_MEASURE:
> -		r = sev_launch_measure(kvm, &sev_cmd);
> +		r = sev_launch_measure(kvm, sev_cmd);
>  		break;
>  	case KVM_SEV_LAUNCH_FINISH:
> -		r = sev_launch_finish(kvm, &sev_cmd);
> +		r = sev_launch_finish(kvm, sev_cmd);
>  		break;
>  	case KVM_SEV_GUEST_STATUS:
> -		r = sev_guest_status(kvm, &sev_cmd);
> +		r = sev_guest_status(kvm, sev_cmd);
>  		break;
>  	case KVM_SEV_DBG_DECRYPT:
> -		r = sev_dbg_crypt(kvm, &sev_cmd, true);
> +		r = sev_dbg_crypt(kvm, sev_cmd, true);
>  		break;
>  	case KVM_SEV_DBG_ENCRYPT:
> -		r = sev_dbg_crypt(kvm, &sev_cmd, false);
> +		r = sev_dbg_crypt(kvm, sev_cmd, false);
>  		break;
>  	case KVM_SEV_LAUNCH_SECRET:
> -		r = sev_launch_secret(kvm, &sev_cmd);
> +		r = sev_launch_secret(kvm, sev_cmd);
>  		break;
>  	case KVM_SEV_GET_ATTESTATION_REPORT:
> -		r = sev_get_attestation_report(kvm, &sev_cmd);
> +		r = sev_get_attestation_report(kvm, sev_cmd);
>  		break;
>  	case KVM_SEV_SEND_START:
> -		r = sev_send_start(kvm, &sev_cmd);
> +		r = sev_send_start(kvm, sev_cmd);
>  		break;
>  	case KVM_SEV_SEND_UPDATE_DATA:
> -		r = sev_send_update_data(kvm, &sev_cmd);
> +		r = sev_send_update_data(kvm, sev_cmd);
>  		break;
>  	case KVM_SEV_SEND_FINISH:
> -		r = sev_send_finish(kvm, &sev_cmd);
> +		r = sev_send_finish(kvm, sev_cmd);
>  		break;
>  	case KVM_SEV_SEND_CANCEL:
> -		r = sev_send_cancel(kvm, &sev_cmd);
> +		r = sev_send_cancel(kvm, sev_cmd);
>  		break;
>  	case KVM_SEV_RECEIVE_START:
> -		r = sev_receive_start(kvm, &sev_cmd);
> +		r = sev_receive_start(kvm, sev_cmd);
>  		break;
>  	case KVM_SEV_RECEIVE_UPDATE_DATA:
> -		r = sev_receive_update_data(kvm, &sev_cmd);
> +		r = sev_receive_update_data(kvm, sev_cmd);
>  		break;
>  	case KVM_SEV_RECEIVE_FINISH:
> -		r = sev_receive_finish(kvm, &sev_cmd);
> +		r = sev_receive_finish(kvm, sev_cmd);
>  		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
>  	}
>  
> -	if (copy_to_user(argp, &sev_cmd, sizeof(struct kvm_sev_cmd)))
> -		r = -EFAULT;
> -
>  out:
>  	mutex_unlock(&kvm->lock);
>  	return r;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 18af7e712a5a..74ecab20c24b 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -716,7 +716,7 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
>  extern unsigned int max_sev_asid;
>  
>  void sev_vm_destroy(struct kvm *kvm);
> -int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp);
> +int sev_mem_enc_ioctl(struct kvm *kvm, struct kvm_mem_enc_cmd *cmd);
>  int sev_mem_enc_register_region(struct kvm *kvm,
>  				struct kvm_enc_region *range);
>  int sev_mem_enc_unregister_region(struct kvm *kvm,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a6b9bea62fb8..14cfbc3266dd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7018,11 +7018,25 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  		goto out;
>  	}
>  	case KVM_MEMORY_ENCRYPT_OP: {
> +		struct kvm_mem_enc_cmd cmd;
> +
>  		r = -ENOTTY;
>  		if (!kvm_x86_ops.mem_enc_ioctl)
>  			goto out;
>  
> -		r = static_call(kvm_x86_mem_enc_ioctl)(kvm, argp);
> +		if (!argp) {
> +			r = 0;
> +			goto out;
> +		}
> +
> +		if (copy_from_user(&cmd, argp, sizeof(cmd))) {
> +			r = -EFAULT;
> +			goto out;
> +		}
> +		r = static_call(kvm_x86_mem_enc_ioctl)(kvm, &cmd);
> +		if (copy_to_user(argp, &cmd, sizeof(cmd)))
> +			r = -EFAULT;
> +
>  		break;
>  	}
>  	case KVM_MEMORY_ENCRYPT_REG_REGION: {
> 
> base-commit: 831fe284d8275987596b7d640518dddba5735f61
> -- 
> 2.25.1
> 
