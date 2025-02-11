Return-Path: <kvm+bounces-37841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9AE0A30AB9
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:49:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD721188BFB5
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 11:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FB311FAC4A;
	Tue, 11 Feb 2025 11:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GRO6E9e4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7C11F0E3D
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 11:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739274482; cv=none; b=ANBtiiRjSQOlK+AYlrgOF55AC8umbdoBlt2qqc8oTQKFrL0/MAVQdQ1OCZ4dnOdMFNsCQYdGABWpUwD8pzQgldI0w9cStzxeSi9Tu75twsDLFWDN+sBh6XZvzWuDtdnLucd8JXl8dUMKw7EFCleH436duy4LxLTg/Hh+QqGfAaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739274482; c=relaxed/simple;
	bh=jsD7Jb28adcsLv9m0Nq3TrLjIf6WBCKmbb9C15zdqgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IiPRqDm8Z1YueuQufWD8c1EnDTy3UlfOr9Hshaxncb5AClc/2I/5ewAB0lSk6ReIbRcZ69+ncWCpAzfjwyRzEeMyyM0Ew/Yd2fUxTuhqTDpxedKrZqR+HuPqwG2Ay30c5oU/5qqoOTE81NwNwpiA52u4+5e0gqF0LogbOtMUzqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GRO6E9e4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF03C4CEDD;
	Tue, 11 Feb 2025 11:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739274482;
	bh=jsD7Jb28adcsLv9m0Nq3TrLjIf6WBCKmbb9C15zdqgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GRO6E9e4zXM1j7K9SmUu1HuW1Bp+v6Hi38wPYqAJ+02PjQlezP1zlRvaN4Fy81ntD
	 HduuOCvBpbZHo8C2bGEPVr3s6w1XQrM8RYe3XFo03IklsHpYvDD4ix7Mi6hywu21Ta
	 kI7bt2rzR7fEPtRZosduAq8u2HEE3ujLoZXbDyNoGDodiixCkDqo4ftPtltMJ98ciY
	 P57KnS+0hhR6MTcfnU8xLDE8q3tGdLVvQ9WnVTZNC78wiO7oqFmK2kpESXdqvJ6x4M
	 8TZZT+rSpMdnN6WnJKrq+tWuuwHLzqswAQrY7W9zT0Mn9LQbdMqFmY1lasj9+eOXWm
	 iQxUnhi8mzeNg==
Date: Tue, 11 Feb 2025 11:47:57 +0000
From: Will Deacon <will@kernel.org>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool 1/2] cpu: vmexit: Handle KVM_EXIT_UNKNOWN exit
 reason correctly
Message-ID: <20250211114756.GC8965@willie-the-truck>
References: <20250211073852.571625-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211073852.571625-1-aneesh.kumar@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Feb 11, 2025 at 01:08:51PM +0530, Aneesh Kumar K.V (Arm) wrote:
> The return value for the KVM_RUN ioctl is confusing and has led to
> errors in different kernel exit handlers. A return value of 0 indicates
> a return to the VMM, whereas a return value of 1 indicates resuming
> execution in the guest. Some handlers mistakenly return 0 to force a
> return to the guest.

Oops. Did any of those broken handlers reach mainline?

> This worked in kvmtool because the exit_reason defaulted to
> 0 (KVM_EXIT_UNKNOWN), and kvmtool did not error out on an unknown exit
> reason. However, forcing a KVM panic on an unknown exit reason would
> help catch these bugs early.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  kvm-cpu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kvm-cpu.c b/kvm-cpu.c
> index f66dcd07220c..66e30ba54e26 100644
> --- a/kvm-cpu.c
> +++ b/kvm-cpu.c
> @@ -170,6 +170,7 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
>  
>  		switch (cpu->kvm_run->exit_reason) {
>  		case KVM_EXIT_UNKNOWN:
> +			goto panic_kvm;
>  			break;

The break is no longer needed.

Will

