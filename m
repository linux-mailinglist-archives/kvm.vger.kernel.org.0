Return-Path: <kvm+bounces-37842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 542DCA30AC4
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:50:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51F1B3A304F
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 11:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 876A21F8AF8;
	Tue, 11 Feb 2025 11:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JawVZNA2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F07B1C9EAA
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 11:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739274534; cv=none; b=I0z1sDJTitMtRzZtEcY+VXTWE4emnMa364HaDtGD2s+JZVx4o9l+CEa6qgTvQmPpDZyDGLgJOsGIHxoQldORwoMZkUBDiudnPMani9ymtztV5vu6I+RXrvuAX15Xr6zQQ0eIzV7LRC4WLZ6x4bwufV8SQkUChXWplsCvhGxVMTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739274534; c=relaxed/simple;
	bh=R74zgGAaMRnFf+DBtDrpQUfjkGEWSpVKuxMD0w1GjUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JCl9gp9nRGun/odIPhd/O5xPZZIy2iK94KvLUU9kCXvY+ymOI9opUfsJtnLkemsggfyt5xB65bEIsePLRwoV6/NxIIxXfxTe5ryVY5AAIKe1K3P+Oijv3Tiqp7F/eilwV4/BryPUx6x3dNUDYtE61s4U+wQcq/CHRLe/gH06ruo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JawVZNA2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18767C4CEDD;
	Tue, 11 Feb 2025 11:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739274534;
	bh=R74zgGAaMRnFf+DBtDrpQUfjkGEWSpVKuxMD0w1GjUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JawVZNA2qzPkUn+obN/dxlxLONQNPM7LQjxdowpW7+l/8FPjQ5PmfW+hXXUsvR9Mp
	 veDZy4IbB18oDyYSXTxE96rfH6O46v6i9wACqBcUp5WdFz/3oRWEEB8Q8TtotPnLZu
	 RJjXemftaa1RcFo8l0vRzW4/SnZnejY2wfWDacc/Z0VEQV0E6rZ/2095jMwsu6Y39x
	 18kVJVhkvP84jWgvzkLryLb3g9pCkgxS3jic4D/uJQuqrWtcGJU1ja2AVLEvo2OGkD
	 Ul3nMKoS+0O0XsYZtlaHcz0lt0QWa1ika0WuX0m5Yjh8yN3wQxq3MpMCDcgy6iF3YS
	 zV5D2Et7gWM4w==
Date: Tue, 11 Feb 2025 11:48:49 +0000
From: Will Deacon <will@kernel.org>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool 2/2] cpu: vmexit: Handle KVM_EXIT_MEMORY_FAULT
 correctly
Message-ID: <20250211114848.GD8965@willie-the-truck>
References: <20250211073852.571625-1-aneesh.kumar@kernel.org>
 <20250211073852.571625-2-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211073852.571625-2-aneesh.kumar@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Feb 11, 2025 at 01:08:52PM +0530, Aneesh Kumar K.V (Arm) wrote:
> Linux kernel documentation states:
> 
> "Note! KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in
> that it accompanies a return code of '-1', not '0'! errno will always be
> set to EFAULT or EHWPOISON when KVM exits with KVM_EXIT_MEMORY_FAULT,
> userspace should assume kvm_run.exit_reason is stale/undefined for all
> other error numbers." "
> 
> Update the KVM_RUN ioctl error handling to correctly handle
> KVM_EXIT_MEMORY_FAULT.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  kvm-cpu.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/kvm-cpu.c b/kvm-cpu.c
> index 66e30ba54e26..40e4efc33a1d 100644
> --- a/kvm-cpu.c
> +++ b/kvm-cpu.c
> @@ -41,8 +41,15 @@ void kvm_cpu__run(struct kvm_cpu *vcpu)
>  		return;
>  
>  	err = ioctl(vcpu->vcpu_fd, KVM_RUN, 0);
> -	if (err < 0 && (errno != EINTR && errno != EAGAIN))
> -		die_perror("KVM_RUN failed");
> +	if (err < 0) {
> +		if (errno == EINTR || errno == EAGAIN)
> +			return;
> +		else if (errno == EFAULT &&
> +			 vcpu->kvm_run->exit_reason == KVM_EXIT_MEMORY_FAULT)
> +			return;
> +		else
> +			die_perror("KVM_RUN failed");
> +	}

Probably cleaner to switch on errno?

Will

