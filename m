Return-Path: <kvm+bounces-18755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 222E28FB11F
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 13:27:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCABE282DFB
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 11:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0EB0145FEE;
	Tue,  4 Jun 2024 11:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="cgZVxJ/I"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C114145339;
	Tue,  4 Jun 2024 11:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717500403; cv=none; b=largmorjDHY2HKsujptxlt0/hOSTMozevnG6yle7Akwz1UrRuNENqyNih/cJ/ANxryukveTZPPlkfxFik/ZnfezdhW6MKPIQIQ42IWkhwarBwV/ssHa1O3YgvINHpf/lwWdbEVCXX/w4aijktuHT5tmb3T8jCblis+WsS79ZKaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717500403; c=relaxed/simple;
	bh=oL8M6qgTb/wgbH/ov5kWUJvU9JDEZKsp2ohmacVuXdE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fVz6nAGwIbIhuv7K70Mzhcxzit/kOyk7l0Jgz+MvdOD2jxjGAISJ3QjXK6Qa6BSpO1mzX8bhSNOOI7FeL6H9JaeMRMYIEiCp7J8bLTXZw6248hsY0n/lAqDE+E1j1scvkyxdeOGPThVVtcWEAOLvnoHO03xRbigI4PXdDPR51sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=cgZVxJ/I; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1717500397;
	bh=t+rduEbfoUs0dyalxeI4cE9kdl/8hw6YLtlweC8/mmU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=cgZVxJ/IkfjcygyfjaxKzIN6nXEks1+/rN8K8kQC6kV9KOUB/5jRXuLrYvjL+I+vk
	 Omx8HBYUidKGjWDSRBt/aSwhY07m/X0W6F3R2iFWlG4PMhRWYNBnu7cO1TLIZlb2fE
	 KnGvYSou/YepCcoQGUo7i7+zJcKDjOTrIFzQi7DtsguCqDGX0bCmf2enFrNQUFD72y
	 H0DEcVA3Hp9YCIyo8hQPI2pR8LJFrBkCK+I1Wm5had/4lKaL5otgv9gX94ZfDipBji
	 UL3oBzjRp2SB4/q/G4O2/0nmG1HnaXIQb/DqLHgFRnwoVhho6Vqr6M0R5iEG7JHrmA
	 vsINwfgMCYe0g==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VtpFm2NqBz4x12;
	Tue,  4 Jun 2024 21:26:36 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: pbonzini@redhat.com, naveen.n.rao@linux.ibm.com,
 christophe.leroy@csgroup.eu, corbet@lwn.net, namhyung@kernel.org,
 npiggin@gmail.com, pbonzini@redhat.com, sbhat@linux.ibm.com,
 jniethe5@gmail.com, atrajeev@linux.vnet.ibm.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] KVM: PPC: Book3S HV: Add one-reg interface for
 DEXCR register
In-Reply-To: <171741327891.6631.10339033341166150910.stgit@linux.ibm.com>
References: <171741323521.6631.11242552089199677395.stgit@linux.ibm.com>
 <171741327891.6631.10339033341166150910.stgit@linux.ibm.com>
Date: Tue, 04 Jun 2024 21:26:34 +1000
Message-ID: <87cyox2bkl.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Shivaprasad G Bhat <sbhat@linux.ibm.com> writes:
> The patch adds a one-reg register identifier which can be used to
> read and set the DEXCR for the guest during enter/exit with
> KVM_REG_PPC_DEXCR. The specific SPR KVM API documentation
> too updated.
>
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
>  Documentation/virt/kvm/api.rst            |    1 +
>  arch/powerpc/include/uapi/asm/kvm.h       |    1 +
>  arch/powerpc/kvm/book3s_hv.c              |    6 ++++++
>  tools/arch/powerpc/include/uapi/asm/kvm.h |    1 +
 
Headers under tools/ are not supposed to be updated directly, they're
synced later by the perf developers.

See: https://lore.kernel.org/all/ZlYxAdHjyAkvGtMW@x1/

cheers

