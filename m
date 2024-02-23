Return-Path: <kvm+bounces-9591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DBD1B861F46
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 22:51:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77139B22AD0
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 985671DDC3;
	Fri, 23 Feb 2024 21:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H+lI+Rj8"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3C4604D0
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 21:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708725089; cv=none; b=VNXJdRCx/4VlpDkpVNJHg4Pcd9Vw/GvgED3VM2A6C7Fov0yUYlZbCok0v6vojM60UtlNL/32w0wX3aPPyBzKvbM7Pq33qxtXrRWm5NcecjHCdvZHi0Vej+8V0afhB7S8T/vEcASKjRjV/siGSxLPUlRfShcBbAR23mlllD9gBMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708725089; c=relaxed/simple;
	bh=93F5H5ukZQOVSdrcrxmihCLMlpqa5YQe5yss4A+ZmBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nQ+oHczklWxknaQPXUBB1Lrbx1jwCulR45SrlF/ZwI3z++TLeSVHMPqpdLUsWpjNLoL9QpBioSyIW7AS8hpy5Faur0O0RWwJoj4koswZO79/oXYl0temr2HgOgHB6lTtAnbeZ3fk6eTmRHcsYpp9EPLCr0h5f1BXARDH22OQ/Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H+lI+Rj8; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708725085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jUtHteZepb4z50jTNHYGGTGy3lyvRj0SCUA4OkqA8eU=;
	b=H+lI+Rj8l5nTGp5sBTzGuzdI5khJ9NsvrJ3HNWZCOgT40yuj3u48TDv3nLLpO2T8PtfRp/
	YQZBCLCcnw3Pnx5Pqvq7c0TEDoBv1IPwSEDUGIz5MhmRHrQ1Yb9dgp9qA5DNgz/i/+QCeL
	QNq6wIZM3TtiE5phWqnapfnpWDCsG9g=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvmarm@lists.linux.dev,
	aneesh.kumar@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Michael Ellerman <mpe@ellerman.id.au>,
	Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sebastian Ene <sebastianene@google.com>,
	naveen.n.rao@linux.ibm.com,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH] KVM: Get rid of return value from kvm_arch_create_vm_debugfs()
Date: Fri, 23 Feb 2024 21:51:12 +0000
Message-ID: <170872506304.206263.3199862434632781431.b4-ty@linux.dev>
In-Reply-To: <20240216155941.2029458-1-oliver.upton@linux.dev>
References: <20240216155941.2029458-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 16 Feb 2024 15:59:41 +0000, Oliver Upton wrote:
> The general expectation with debugfs is that any initialization failure
> is nonfatal. Nevertheless, kvm_arch_create_vm_debugfs() allows
> implementations to return an error and kvm_create_vm_debugfs() allows
> that to fail VM creation.
> 
> Change to a void return to discourage architectures from making debugfs
> failures fatal for the VM. Seems like everyone already had the right
> idea, as all implementations already return 0 unconditionally.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: Get rid of return value from kvm_arch_create_vm_debugfs()
      https://git.kernel.org/kvmarm/kvmarm/c/284851ee5cae

--
Best,
Oliver

