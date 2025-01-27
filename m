Return-Path: <kvm+bounces-36667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C1F4A1DAF9
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 18:05:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87DA5162E47
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 17:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA5B18593A;
	Mon, 27 Jan 2025 17:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rXQHB3ac"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B026E3D64;
	Mon, 27 Jan 2025 17:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737997501; cv=none; b=IMHIX2qgxyRd3fRZksTUh9gDTphtSBe7QHUcLfztnAbQ6f+0FWo0srLeUeVNYXOr/fzcJNTZXNxot80JkOBf/jnvxhZuxXxadrFhBDrq44pEt06FHOrsXTK9YiwZJ7KpAWYqKbGmexXJjYVqPIZ0IpY7ervFDH2xpdQ5nvlASqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737997501; c=relaxed/simple;
	bh=wtQvYfhGaT1jbp7Bj2DZ6XtvGndu0qLWb03SfdHs9tg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSRvv1EgEFWO1c0oDd4+E6s+QFSXjYTypWylqlXM9T0N+fG/ZSkBuGqJKo8fA70qgFJChkWjNuegQa0jiAqCHBUs1L1wMz2laqnybRnT3FRa+VlgaVwbuE10/xQ8oi/qHo8bznjQBJ7Ntq7PGX2x+ic+tBkb+jVQd87uyf5rYzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rXQHB3ac; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C168BC4CED2;
	Mon, 27 Jan 2025 17:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737997501;
	bh=wtQvYfhGaT1jbp7Bj2DZ6XtvGndu0qLWb03SfdHs9tg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rXQHB3acUR7/UOp02EA5I7Sdfgo96+Qx2DTk61P4Kr5PP9eKWV2whuAupDtI0FsGI
	 sh3By87OuyVIdsirjTV7vLZ2V+kASc+raRcIoNOQWRcuNE1AdGDStOEYEMysXJS0vK
	 CnEAiE70QIJv51U12ni8+YL3Kd/H1e5JPJkP5pEDVwZp0oalMRV153UcN6rUaOj8m2
	 wHAbowtXjlCwPNcXiCHElhP5qFK9kKDeffcmIB4Ph40mJRhEISfgkhaaCztFY6RQWR
	 g4kqLsu/DfRxMME0orswqJCE2xC86jqEwEY0mtqnWvy1T+dWc8tA8wPsugeFWti2KE
	 dATH6DeyzuLOw==
Date: Mon, 27 Jan 2025 10:04:58 -0700
From: Keith Busch <kbusch@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Ensure NX huge page recovery thread is
 alive before waking
Message-ID: <Z5e8umkPeRri0Z_p@kbusch-mbp>
References: <20250124234623.3609069-1-seanjc@google.com>
 <Z5RkcB_wf5Y74BUM@kbusch-mbp>
 <Z5e4w7IlEEk2cpH-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5e4w7IlEEk2cpH-@google.com>

On Mon, Jan 27, 2025 at 08:48:03AM -0800, Sean Christopherson wrote:
> If vhost_task_create() fails, then the call_once() will "succeed" and mark the
> structure as ONCE_COMPLETED.  The first KVM_RUN will fail with -ENOMEM, but any
> subsequent calls will succeed, including in-flight KVM_RUNs on other threads.

The criteria for returning -ENOMEM for any KVM_RUN is if we have a NULL
nx_huge_page_recovery_thread vhost_task. So I think that part, at least,
is fine.

The call_once is just needed to ensure that only the very first KVM_RUN
even tries to create it. If the vhost_task_create fails, then all the
KVM_RUN threads will see the NULL nx_huge_page_recovery_thread and
return -ENOMEM.

What you're suggesting here will allow a subsequent thread to attempt
creating the vhost task if the first one failed. Maybe you do want to
try again, but the current upstream code doesn't retry this, so I
thought it best to keep that behavior.

