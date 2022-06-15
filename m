Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0042654BFBF
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 04:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343802AbiFOCnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 22:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242752AbiFOCnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 22:43:32 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2792321801;
        Tue, 14 Jun 2022 19:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655261012; x=1686797012;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9is4Wtv18iXnGG040jECVRF40gaLkbneYddeUdfg+z8=;
  b=UdMIFU9lH5jQcO1ZYPzBQOXXOkMCsFd76HIHUfyFTpPASyP0OcjE7oiM
   EWAiCyAkCFMDM/yKawlSQwhoTYkuRcBJXhueRiB8xhEl+DQh/QcRgllO+
   hKNyEhKDl+WZiC0HWw9nCFeTaz7mqe2FsbnPqcdZOMbLFHHzvB4d7QI+d
   p9bOmhAZlYSeJgyRjESOX6+6uoQhXceTs9WrahzF72l2LfQo3KyjMfXo7
   eI81r8yI7ef2Xz13sJ4xWEM7HVgAcKnVdGulJVAxg2iGn15Pvz4dCG9xl
   CoHzkC0deL3b7m9F8ApheZNVLcbyPjWOqWEBFAzHV5HTPy9yruAa+2J5w
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="340473425"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="340473425"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 19:43:31 -0700
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="588834092"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 19:43:29 -0700
Date:   Wed, 15 Jun 2022 10:43:16 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, somduttar@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 5/7] KVM: x86: add vCPU scoped toggling for
 disabled exits
Message-ID: <20220615024311.GA7808@gao-cwp>
References: <20220615011622.136646-1-kechenl@nvidia.com>
 <20220615011622.136646-6-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615011622.136646-6-kechenl@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>@@ -5980,6 +5987,8 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
> int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> 			    struct kvm_enable_cap *cap)
> {
>+	struct kvm_vcpu *vcpu;
>+	unsigned long i;
> 	int r;
> 
> 	if (cap->flags)
>@@ -6036,14 +6045,17 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> 			break;
> 
> 		mutex_lock(&kvm->lock);
>-		if (kvm->created_vcpus)
>-			goto disable_exits_unlock;
>+		if (kvm->created_vcpus) {
>+			kvm_for_each_vcpu(i, vcpu, kvm) {
>+				kvm_ioctl_disable_exits(vcpu->arch, cap->args[0]);
>+				static_call(kvm_x86_update_disabled_exits)(vcpu);

IMO, this won't work on Intel platforms. Because, to manipulate a vCPU's
VMCS, vcpu_load() should be invoked in advance to load the VMCS.
Alternatively, you can add a request KVM_REQ_XXX and defer updating VMCS
to the next vCPU entry.

>+			}
>+		}
>+		mutex_unlock(&kvm->lock);
> 
> 		kvm_ioctl_disable_exits(kvm->arch, cap->args[0]);
> 
> 		r = 0;
>-disable_exits_unlock:
>-		mutex_unlock(&kvm->lock);
> 		break;
> 	case KVM_CAP_MSR_PLATFORM_INFO:
> 		kvm->arch.guest_can_read_msr_platform_info = cap->args[0];
>-- 
>2.32.0
>
