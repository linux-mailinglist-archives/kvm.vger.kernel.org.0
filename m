Return-Path: <kvm+bounces-62766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A9E3C4DB93
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 13:31:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 60E4E4F1205
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 12:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 486F5354AF2;
	Tue, 11 Nov 2025 12:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tmkV+Cja"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632282737E7;
	Tue, 11 Nov 2025 12:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762863924; cv=none; b=WFB5zsKYpIkr/s3IH0YQFZBNCVlX/m9m+0MJML3jCw2OR1004mMpJVBgj9tiuEBulOVNCGp1uv/g56DjeQMTj/LkmqmjbXNbsfrs4OL4xvVhHbKbgLED5u3RPekpwF7HEGDij71q/3Lb1I3cwEfX3yqCAntv9Rq0drpzLLUdmWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762863924; c=relaxed/simple;
	bh=hdRYlFv1BM0TA2up7sgM34/8y2YohOBd/gO3L8ew3jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u7FQ/iW18GlHTc7PyULnBYdvicmNpKxkcBgxs2bEiSn1OqK61d1zBNuBP9VZ6gImhIlGch1g4clshmen5hD/iD3mSR4o62a7ug1TKh1fxe6jZxxSk8tNAaLrVRwzAAFfmjGuyZRg/2gXgN32Q3X6A0EaTJLZi7vfcxPU4dfhwEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tmkV+Cja; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A0BC4CEF5;
	Tue, 11 Nov 2025 12:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762863924;
	bh=hdRYlFv1BM0TA2up7sgM34/8y2YohOBd/gO3L8ew3jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmkV+Cja1QetbgbcXSwPGo+AXobFQ2hnRYB7oMUWSFieS/C9bGof5wXdAvn5C76Nq
	 LmES90H2AqbidNC7tQzwJhTVkQZchlipjTxCUX7rL81I77FdTZvdhdmu/WQvLMIRq1
	 L1fNSmMjDIl/uYsLxz9uTrSJfXn4i+CBYzi0bvTp/Aee5SjbTBIFs9pl1MqFPWI6fC
	 beAy5HAcotUo7q1w+0Lcmk9ft9xgalvQehrjE+7sqcGz/qjih3fkP3ttgT+p+P0/zQ
	 EBgqxLpSN9eOIQD5+TwNMlsYdaLnvTKVQpBlAAfnIkT5qIHG/uD3OtAEiJPvWs69TU
	 23mgcMOjTk6pg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vInR3-00000004ED3-3brA;
	Tue, 11 Nov 2025 12:25:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Finalize ID registers only once per VM
Date: Tue, 11 Nov 2025 12:25:16 +0000
Message-ID: <176286391603.1927379.11875919783471032489.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110173010.1918424-1-maz@kernel.org>
References: <20251110173010.1918424-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 10 Nov 2025 17:30:10 +0000, Marc Zyngier wrote:
> Owing to the ID registers being global to the VM, there is no point
> in computing them more than once.  However, recent changes making
> use of kvm_set_vm_id_reg() outlined that we repeatedly hammer
> the ID registers when we shouldn't.
> 
> Gate the ID reg update on the VM having never run.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Finalize ID registers only once per VM
      commit: 0f559cd91e37b7978e4198ca2fbf7eb95df11361

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



