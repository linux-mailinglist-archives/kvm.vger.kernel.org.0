Return-Path: <kvm+bounces-36594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D22A1C0E5
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 05:11:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1628D7A4F30
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 04:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF59206F04;
	Sat, 25 Jan 2025 04:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pNVuRUaZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A80148316;
	Sat, 25 Jan 2025 04:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737778291; cv=none; b=XvLP9qSlrF8tuTFSQFQF6B7D9nTKZGNNwwJewpGC2SvpugOcLZkvoPn2Zn8URZI3Gc9nntk3WJfU/zv7OQAkOwSfioYexuXDeN+sMYkYGvUcmPoTMn3EJcR08PwMVwxSmXunrASc6ido2Tg54isQwn9HeOrmA6Epk7TvZ0bUcZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737778291; c=relaxed/simple;
	bh=WJB9GpgYf4ZdqLK/uPw+tNP8Ol87+1QFIUtaUo5T6DU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RhIlMh093XcBHHZgVMQ+qu29nuRq7rAj6yHgoEuhlgN5qNhodYRFDIxjUqPhq0CVL6iBv1+++WMjc8IHGp6Nhzeg5/EYLTLc/JgL3qLjr6Yq7SZ8wjcDriYUhRvoqDLJCINHpEsF01nqW6rgL8WBcWhpvJPtZwXqx8E5EHH+4Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pNVuRUaZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCFFC4CED6;
	Sat, 25 Jan 2025 04:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737778291;
	bh=WJB9GpgYf4ZdqLK/uPw+tNP8Ol87+1QFIUtaUo5T6DU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pNVuRUaZYcRiDByhYrnMRIIfIbXtn+pek2B1Ef9YCMtRRVy8Gd13J/HnqIe2vzeZs
	 JPpd+zWVAeMjl+RE6TWYYTCp08I+iOU6G/v4/xZmttu+IbhG5p1PBge3jwvg7XVWhr
	 6BX1FyJqvcru806Ec/Ux3dVw6MEvlRTC5mRr46aVE0YUuhTv6hYqs83DSuYCwdhhWA
	 VWa0OAlwQ037+8kqWZ7hRQmZfRxvYpIG1YZZg6sSzkP4pq3RZWc6K3CuDkptI8cqnq
	 jLBZddqDjbVWI9x+HAdS8RYtLdmHLXVojn88YxHD+z4WboABDPGGJXrn2VHVNMZSgp
	 3agoyfJ8ZEeJQ==
Date: Fri, 24 Jan 2025 21:11:28 -0700
From: Keith Busch <kbusch@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Ensure NX huge page recovery thread is
 alive before waking
Message-ID: <Z5RkcB_wf5Y74BUM@kbusch-mbp>
References: <20250124234623.3609069-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250124234623.3609069-1-seanjc@google.com>

On Fri, Jan 24, 2025 at 03:46:23PM -0800, Sean Christopherson wrote:
> When waking a VM's NX huge page recovery thread, ensure the thread is
> actually alive before trying to wake it.  Now that the thread is spawned
> on-demand during KVM_RUN, a VM without a recovery thread is reachable via
> the related module params.

Oh, this is what I thought we could do. I should have read ahead. :)

> +static void kvm_wake_nx_recovery_thread(struct kvm *kvm)
> +{
> +	/*
> +	 * The NX recovery thread is spawned on-demand at the first KVM_RUN and
> +	 * may not be valid even though the VM is globally visible.  Do nothing,
> +	 * as such a VM can't have any possible NX huge pages.
> +	 */
> +	struct vhost_task *nx_thread = READ_ONCE(kvm->arch.nx_huge_page_recovery_thread);
> +
> +	if (nx_thread)
> +		vhost_task_wake(nx_thread);
> +}
> +
>  static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp)
>  {
>  	if (nx_hugepage_mitigation_hard_disabled)
> @@ -7180,7 +7193,7 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
>  			kvm_mmu_zap_all_fast(kvm);
>  			mutex_unlock(&kvm->slots_lock);
>  
> -			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
> +			kvm_wake_nx_recovery_thread(kvm);
>  		}
>  		mutex_unlock(&kvm_lock);
>  	}
> @@ -7315,7 +7328,7 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
>  		mutex_lock(&kvm_lock);
>  
>  		list_for_each_entry(kvm, &vm_list, vm_list)
> -			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
> +			kvm_wake_nx_recovery_thread(kvm);
>  
>  		mutex_unlock(&kvm_lock);
>  	}
> @@ -7451,14 +7464,20 @@ static void kvm_mmu_start_lpage_recovery(struct once *once)
>  {
>  	struct kvm_arch *ka = container_of(once, struct kvm_arch, nx_once);
>  	struct kvm *kvm = container_of(ka, struct kvm, arch);
> +	struct vhost_task *nx_thread;
>  
>  	kvm->arch.nx_huge_page_last = get_jiffies_64();
> -	kvm->arch.nx_huge_page_recovery_thread = vhost_task_create(
> -		kvm_nx_huge_page_recovery_worker, kvm_nx_huge_page_recovery_worker_kill,
> -		kvm, "kvm-nx-lpage-recovery");
> +	nx_thread = vhost_task_create(kvm_nx_huge_page_recovery_worker,
> +				      kvm_nx_huge_page_recovery_worker_kill,
> +				      kvm, "kvm-nx-lpage-recovery");
>  
> -	if (kvm->arch.nx_huge_page_recovery_thread)
> -		vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
> +	if (!nx_thread)
> +		return;
> +
> +	vhost_task_start(nx_thread);
> +
> +	/* Make the task visible only once it is fully started. */
> +	WRITE_ONCE(kvm->arch.nx_huge_page_recovery_thread, nx_thread);

I believe the WRITE_ONCE needs to happen before the vhost_task_start to
ensure the parameter update callback can see it before it's started.

