Return-Path: <kvm+bounces-59273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 48106BAFBE6
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:55:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C2DA7A6713
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5E82D8375;
	Wed,  1 Oct 2025 08:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PNrTXExD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E702D59EF;
	Wed,  1 Oct 2025 08:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759308927; cv=none; b=ahWi03vC06/lNsW+CgMzRH7h76PZeA9fgbRI7YkGagGslEVrD1uMvyyb18iIF0b7nyJNaCXJWoqERRy0dJb9NTLUNHgwlx/0B72NgBX7j9VFwW2r05XL+LYXl3Fz0CpvtYiAZQugsR8z1bfgx6hqzBAc+DuS3CUkmlg4YOLZX94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759308927; c=relaxed/simple;
	bh=p8W6QHVJ850QiSHTlZrw/v+EW9y4/nqCmdTPGPlBhPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jJj87qnlz4CSL6Bh/AHYe2wAbxDRYI3W1ZQ+SjRSO3g6SHqLSxlmF2EuQIkL9Lucq7YDOZh5c9chlbwmvAtt7vu/Dbd12mcb/KnB1mvUw4v8i7Gi4WRlVRHtQN0G0uqrHS8g1x1RTGEA6ybZzed75LXmFG8ICDa2/Lu9xLs+nPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PNrTXExD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6034FC4CEF4;
	Wed,  1 Oct 2025 08:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759308926;
	bh=p8W6QHVJ850QiSHTlZrw/v+EW9y4/nqCmdTPGPlBhPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNrTXExDV5EC+PTr3jh7KC3iuQCZ+ikvIn7Gtf83cpUo2wAKTnhLFLRtMpmqi2OfE
	 8ESPh7CzdTfGeTdJxJoa1dEPAQF22wY50jMtkc3B1FyK2RsK0Hdea8rWlW3+RDFUQe
	 X+hSHyewtwAw59GAxH4ml5dg6FhWHGG2UXaI8HpiVigiv5xX+PPnshsps7wT44kLUy
	 PXZg1Y6/4wujopJ1Bv7N7T5bntMT627qZboyevwaGvHvfNwyT3hAFAuGydaxiqRy7y
	 0okdB1lj39KYtk09FpOrCTR6xQoaUlEIFo9n5EU9lYdV9QRBUZ+Vd3XaX8BmFwNMkr
	 IYFxzZXNmNLlQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3scO-0000000Akat-0Fhm;
	Wed, 01 Oct 2025 08:55:24 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: selftests: Fix irqfd_test for non-x86 architectures
Date: Wed,  1 Oct 2025 09:55:13 +0100
Message-ID: <175930891339.3590343.14549026164847245253.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250930193301.119859-1-oliver.upton@linux.dev>
References: <20250930193301.119859-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvm@vger.kernel.org, pbonzini@redhat.com, sebott@redhat.com, naresh.kamboju@linaro.org, seanjc@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 30 Sep 2025 12:33:02 -0700, Oliver Upton wrote:
> The KVM_IRQFD ioctl fails if no irqchip is present in-kernel, which
> isn't too surprising as there's not much KVM can do for an IRQ if it
> cannot resolve a destination.
> 
> As written the irqfd_test assumes that a 'default' VM created in
> selftests has an in-kernel irqchip created implicitly. That may be the
> case on x86 but it isn't necessarily true on other architectures.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: selftests: Fix irqfd_test for non-x86 architectures
      commit: 3ba969c9415f56c7cc20e9693cb4b5364840b668

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



