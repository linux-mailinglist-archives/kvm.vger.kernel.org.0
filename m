Return-Path: <kvm+bounces-58694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCCF0B9B871
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 20:39:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98B344C6FCA
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 18:39:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDCBD31A06C;
	Wed, 24 Sep 2025 18:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TKf/6W1L"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0F131B832;
	Wed, 24 Sep 2025 18:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758739096; cv=none; b=KZBvtTLGYZoPBaFUW3noyZ0cmsASi2SK9Kav+7XNxZsUg6ydsCNbtugGZjYf1WWmcHV6jfH+8xohsPNmFVdeFOXhB/HNxYbtoFkkKU8Ohrws7EOZQv7qUouqtDxj36whQbU1Rwa1wvnQkYRyOlcS7FLwrCb7ZSketL2RFFF7Jnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758739096; c=relaxed/simple;
	bh=RibivQVkgO0vX+EoL4fyGQgznIxN4M2CYO9kSjKIsv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eTKEanw7VjfoVGHvbbNJUmdk8hsReWXf56ErqVZklTJGG6FdEdv/x1HOo7Cyl4EI+zCo1npJtzsGY64QZ8Ji/lQzqxrQV56++loJB0XrgmdLAxS2H69zYPQkf9EuKwAubPcrot5RCydmNxKbxxhqbSsvLUIGboyCey1mTb/KSr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TKf/6W1L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C171C4CEE7;
	Wed, 24 Sep 2025 18:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758739096;
	bh=RibivQVkgO0vX+EoL4fyGQgznIxN4M2CYO9kSjKIsv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKf/6W1LoHc+9VB1zPOiLzVBfS4do4YbB+EfQI6uf0hx+2iNoWTP3zmbSKVDrkZrL
	 OMhpP9oXqu45GaLrHWdcHh09AUC6vuce5lr0e2vy0+Kx7YzvnsXOUKYIKBiP+gwZZz
	 I13JK7cEGgRltEdu7SXFmmlKEGrOfP3fG2iCbEGaOdWdjeSUQGRUYlWWg/rhElwWxg
	 nKYh+TiqSnievc12KEfPSG5qFeAGNF9ZwW4mxqz2M387IV7QN65HaZ+H7MUeaJmwu0
	 Pdi1pGsYRCiNc5FKwip0qPV4uvpukBpWAKVL299125fXFB9uYvqhdgGnHMtXqlTJQh
	 Nm7aHTF2o9cuA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v1UNa-000000097Nb-0Pye;
	Wed, 24 Sep 2025 18:38:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH 00/13] KVM: arm64: selftests: Run selftests in VHE EL2
Date: Wed, 24 Sep 2025 19:37:30 +0100
Message-ID: <175873905078.2372872.15523019507687059465.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250917212044.294760-1-oliver.upton@linux.dev>
References: <20250917212044.294760-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com, seanjc@google.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 17 Sep 2025 14:20:30 -0700, Oliver Upton wrote:
> I've been working on some MMU-related features that are unused by KVM
> meaning they're somewhat annoying to test. Because of that, I found the
> time / patience to port our existing selftests infrastructure over to
> running in VHE EL2, opportunistically promoting tests when the stars
> align.
> 
> Creating a VGIC is a hard requirement of enabling EL2 for a VM. As a
> consequence of this, I need to eat my words from my earlier conversation
> with Sean on this topic and hammer in a default VGICv3. This requires
> some participation from the arch-neutral code given the ordering
> constraints on vCPU and VGIC creation.
> 
> [...]

Applied to next, thanks!

[01/13] KVM: arm64: selftests: Provide kvm_arch_vm_post_create() in library code
        commit: 7326348209a0079a83c7bd7963a0e32d26af61c8
[02/13] KVM: arm64: selftests: Initialize VGICv3 only once
        commit: a5022da5f9a3a791ff2caf5fe3789561ae687747
[03/13] KVM: arm64: selftests: Add helper to check for VGICv3 support
        commit: b712afa7a1cdb787f311f51c04df81fc6f026368
[04/13] KVM: arm64: selftests: Add unsanitised helpers for VGICv3 creation
        commit: b8daa7ceac1c56e39b6ef4e62510a7d846511695
[05/13] KVM: arm64: selftests: Create a VGICv3 for 'default' VMs
        commit: 8911c7dbc607212bf3dfc963004b062588c0ab38
[06/13] KVM: arm64: selftests: Alias EL1 registers to EL2 counterparts
        commit: 1c9604ba234711ca759f1147f2fbc7a94a5a486d
[07/13] KVM: arm64: selftests: Provide helper for getting default vCPU target
        commit: a1b91ac2381d86aa47b7109bbcde0c71e775f6d9
[08/13] KVM: arm64: selftests: Select SMCCC conduit based on current EL
        commit: d72543ac728ae4a4708cbefad2761df84599c268
[09/13] KVM: arm64: selftests: Use hyp timer IRQs when test runs at EL2
        commit: 0910778e49c6639d265ab2d7a47d0b461b8e2963
[10/13] KVM: arm64: selftests: Use the vCPU attr for setting nr of PMU counters
        commit: 7ae44d1cdad8a2483465373b9c9e91f0461ca9b2
[11/13] KVM: arm64: selftests: Initialize HCR_EL2
        commit: 05c93cbe6653e7e77567962aa6533b618df5e19f
[12/13] KVM: arm64: selftests: Enable EL2 by default
        commit: 2de21fb62387459f762c93eec3d04e4f7540b952
[13/13] KVM: arm64: selftests: Add basic test for running in VHE EL2
        commit: f677b0efa93ce0afb127ccffb8aaf708045fcf10

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



