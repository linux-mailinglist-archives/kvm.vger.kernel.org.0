Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670F87A475D
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 12:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241129AbjIRKlh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 06:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241214AbjIRKlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 06:41:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57239DB
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 03:40:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD7AC433C8;
        Mon, 18 Sep 2023 10:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695033634;
        bh=mfTaBjYA8HHTuisBF3KK0QkdJTAjBxJvpOzzYrlDNk8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i1auMnEBV0IIbkZj7b5zMuVtDCupKfx6QXVclJ9FEr5S9WDXQeP0VC3mvkhmYNjDa
         SgVfoS8D+QD1Q0gtmekwcbCfhu7bNQdfJlUVOWLzUG740S6ZDHj3xiQwPTh70kumut
         Js6JOvG/QXdHCbrBxIVbCtb9hmh5FpuaA9150V0rgcmPq2YhDQP3W/YiBYs8FDWP7x
         o5P0zhjNNGdA+g57TMY4IcF6G0DnRNtiCjNEOPrccuh9GPn24m1ZXVLCBA2LIow+ip
         7BBuIB7Xe5/YETeOeRs7BNKr3quCFEr6th+FnQSEpfr5rxavTD1YbOH9Myu32IY9rG
         WtOTzy0M0XefA==
Date:   Mon, 18 Sep 2023 11:40:28 +0100
From:   Will Deacon <will@kernel.org>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [PATCH kvmtool v3 08/17] Add helpers to pause the VM from vCPU
 thread
Message-ID: <20230918104028.GA17744@willie-the-truck>
References: <20230802234255.466782-1-oliver.upton@linux.dev>
 <20230802234255.466782-9-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230802234255.466782-9-oliver.upton@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023 at 11:42:46PM +0000, Oliver Upton wrote:
> Pausing the VM from a vCPU thread is perilous with the current helpers,
> as it waits indefinitely for a signal that never comes when invoked from
> a vCPU thread. Instead, add a helper for pausing the VM from a vCPU,
> working around the issue by explicitly marking the caller as paused
> before proceeding.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  include/kvm/kvm-cpu.h |  3 +++
>  kvm-cpu.c             | 16 ++++++++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/include/kvm/kvm-cpu.h b/include/kvm/kvm-cpu.h
> index 0f16f8d6e872..9a4901bf94ca 100644
> --- a/include/kvm/kvm-cpu.h
> +++ b/include/kvm/kvm-cpu.h
> @@ -29,4 +29,7 @@ void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu);
>  void kvm_cpu__arch_nmi(struct kvm_cpu *cpu);
>  void kvm_cpu__run_on_all_cpus(struct kvm *kvm, struct kvm_cpu_task *task);
>  
> +void kvm_cpu__pause_vm(struct kvm_cpu *vcpu);
> +void kvm_cpu__continue_vm(struct kvm_cpu *vcpu);
> +
>  #endif /* KVM__KVM_CPU_H */
> diff --git a/kvm-cpu.c b/kvm-cpu.c
> index 1c566b3f21d6..9adc9d4f7841 100644
> --- a/kvm-cpu.c
> +++ b/kvm-cpu.c
> @@ -141,6 +141,22 @@ void kvm_cpu__run_on_all_cpus(struct kvm *kvm, struct kvm_cpu_task *task)
>  	mutex_unlock(&task_lock);
>  }
>  
> +void kvm_cpu__pause_vm(struct kvm_cpu *vcpu)
> +{
> +	/*
> +	 * Mark the calling vCPU as paused to avoid waiting indefinitely for a
> +	 * signal exit.
> +	 */
> +	vcpu->paused = true;
> +	kvm__pause(vcpu->kvm);
> +}
> +
> +void kvm_cpu__continue_vm(struct kvm_cpu *vcpu)
> +{
> +	vcpu->paused = false;
> +	kvm__continue(vcpu->kvm);
> +}

Why is it safe to manipulate 'vcpu->paused' here without the pause_lock
held? Relatedly, how does this interact with the 'pause' and 'resume'
lkvm commands?

Will
