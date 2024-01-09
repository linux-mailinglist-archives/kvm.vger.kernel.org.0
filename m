Return-Path: <kvm+bounces-5908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42E6E828C9E
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 19:30:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB5C81F29ED5
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 18:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3263C6A3;
	Tue,  9 Jan 2024 18:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bibRrS8Q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76ECC3A8E1;
	Tue,  9 Jan 2024 18:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745D2C433F1;
	Tue,  9 Jan 2024 18:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704825017;
	bh=4e17EVKx9Ynx8QIA0PudyWmEbbNXeGXtvyR8zU7LvlI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bibRrS8QD/wewhZo5L890sUv0otbbRCZc2+2QomQk5/Yhfp8eKzNtnBMc0ZuUlTDX
	 UCj7heIf7PEVTUmKVgV8BrYVzWL4T7iujkSvHIdMZQSYtv9K2W+KJoQofyyX9AxAEV
	 +SfFXCcMGMhA5nyHPWrEQ/id8KVblr1ys1HDeRML0p3zbPyFqW8+ux+4LUu5G3nql6
	 q+7mYg6kCjZK9OT/OmtFQBvMceb7InhYr6diYboDHMrnmvGMQIlEqaPgG3tnhKux3v
	 SYFHGWGMuqrHYPpO1gUhyX/b64lzkZRhSBSBBbHmbbilG677kaxsbVETkd97yKVC/U
	 zaZXQvnxr++gQ==
Date: Tue, 9 Jan 2024 18:30:11 +0000
From: Conor Dooley <conor@kernel.org>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [v2 05/10] drivers/perf: riscv: Implement SBI PMU snapshot
 function
Message-ID: <20240109-vice-trash-89a4e1a171b2@spud>
References: <20231229214950.4061381-1-atishp@rivosinc.com>
 <20231229214950.4061381-6-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="kO73K9XjJLp1tLC+"
Content-Disposition: inline
In-Reply-To: <20231229214950.4061381-6-atishp@rivosinc.com>


--kO73K9XjJLp1tLC+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 29, 2023 at 01:49:45PM -0800, Atish Patra wrote:
> +static noinline void pmu_sbi_start_ovf_ctrs_snapshot(struct cpu_hw_events *cpu_hw_evt,
> +						     unsigned long ctr_ovf_mask)
> +{
> +	int idx = 0;
> +	struct perf_event *event;
> +	unsigned long flag = SBI_PMU_START_FLAG_INIT_FROM_SNAPSHOT;
> +	u64 max_period, init_val = 0;
> +	struct hw_perf_event *hwc;
> +	unsigned long ctr_start_mask = 0;
> +	struct riscv_pmu_snapshot_data *sdata = cpu_hw_evt->snapshot_addr;
> +
> +	for_each_set_bit(idx, cpu_hw_evt->used_hw_ctrs, RISCV_MAX_COUNTERS) {
> +		if (ctr_ovf_mask & (1 << idx)) {
> +			event = cpu_hw_evt->events[idx];
> +			hwc = &event->hw;
> +			max_period = riscv_pmu_ctr_get_width_mask(event);
> +			init_val = local64_read(&hwc->prev_count) & max_period;
> +			sdata->ctr_values[idx] = init_val;
> +		}
> +		/* We donot need to update the non-overflow counters the previous
> +		 * value should have been there already.
> +		 */

One nit for if this is resent, you've got the wrong comment style here.
Otherwise, looks like the things we discussed before got addressed:
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--kO73K9XjJLp1tLC+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZZ2QswAKCRB4tDGHoIJi
0gOyAP9likwaQtMp2ZSARj3vlQ58zp6Y3zWoiDNp0IPqPvRVpgD8D3p4Ng+GSYTf
Nk3Ly+1hHDxZAqd9avg+wQchMGHMCgg=
=lKYo
-----END PGP SIGNATURE-----

--kO73K9XjJLp1tLC+--

