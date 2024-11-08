Return-Path: <kvm+bounces-31305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 720FA9C2273
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:53:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3684D2819F0
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE24D19923C;
	Fri,  8 Nov 2024 16:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MC/Kt6FK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15FB1990A1;
	Fri,  8 Nov 2024 16:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731084828; cv=none; b=C17SlX0AwVkA8ng5J6v/n/+XmAW/djgj6nBMFcSMFYEVtTFFB+4hedY6dH2WVcLpUNldBk0Y6/P8JHADrTQB1Dm6qufZYX/1Zg1RqHlb7401BVBXqPqoAA5ffaoaC0/nueaLhdlTOYlJGWoBq14zPiSyDnu6IsOHyarMefBb5ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731084828; c=relaxed/simple;
	bh=DU386yzf8MX7kl3Llow5qywjVc/LWGlEHoL6txh+x5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nOqgrsYPmrTrElGCatHENM6vaZ83i/2fHjq3xROPncbMwAlljtfZY+5tJ8ebmJ+VxmWNq0i56DizRXKp/yWbtgeO1Q4SdoZhNaXjExDl1EJG4Sih1FO9wk80eMyyMlz+ZjsoQCwRnY4RmbXD864KO5x5lzQGhbc486wICsA0X2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MC/Kt6FK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653D2C4CECD;
	Fri,  8 Nov 2024 16:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731084827;
	bh=DU386yzf8MX7kl3Llow5qywjVc/LWGlEHoL6txh+x5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MC/Kt6FKD4hHXzUnf5UYQHpZSqyq608ofsJJbKyFpOwWqx0NCIbgi/qn/iZi39nqM
	 ZG32t8ucnOyQDAw9+l5rQXEL1Lr851uTsewjzww1q0kql2j27OAjrduXisz0AVEfRE
	 qpdbhoymWx8WwycM7ilaneBWFKHLOfZXQt3xWPEWqIb5+njVWkgUQjeyerMeD3FPop
	 n3YgE16mGed8nhrm4psYWcEBAxrfYZPWO4Hpv0Zs4PccVqsvoUQgeOEhYno6Y027GY
	 kt+DWV3ZkP9PZsd3OIkYwmhdQvTT4FJuQgGq1/5Nm9IwJCUXavY3lrjqpOypSsUMKL
	 PS97m2yqPuG3g==
Date: Fri, 8 Nov 2024 06:53:46 -1000
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	michael.christie@oracle.com, Luca Boccassi <bluca@debian.org>
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
Message-ID: <Zy5CGpgRu8q7nrsx@slm.duckdns.org>
References: <20241108130737.126567-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108130737.126567-1-pbonzini@redhat.com>

On Fri, Nov 08, 2024 at 08:07:37AM -0500, Paolo Bonzini wrote:
...
> Since the worker kthread is tied to a user process, it's better if
> it behaves similarly to user tasks as much as possible, including
> being able to send SIGSTOP and SIGCONT.  In fact, vhost_task is all
> that kvm_vm_create_worker_thread() wanted to be and more: not only it
> inherits the userspace process's cgroups, it has other niceties like
> being parented properly in the process tree.  Use it instead of the
> homegrown alternative.

Didn't about vhost_task. That looks perfect. From cgroup POV:

  Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

