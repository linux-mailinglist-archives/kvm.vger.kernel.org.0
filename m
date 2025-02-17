Return-Path: <kvm+bounces-38376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C44AEA388D6
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 17:09:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EB4F1625D6
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 16:04:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE6FB225385;
	Mon, 17 Feb 2025 16:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sympatico.ca header.i=@sympatico.ca header.b="pzeZuRu8"
X-Original-To: kvm@vger.kernel.org
Received: from cmx-mtlrgo001.bell.net (mta-mtl-007.bell.net [209.71.208.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DD8223700;
	Mon, 17 Feb 2025 16:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.71.208.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739808284; cv=none; b=uyKfPSdDiwZQwSizfgRabzwQrQjDa0hFlH5BII9PvSeqVta8msgscbIy2KwJE2WMAy5Fg5qsNQMlz2BJFkVxbM86RBC+uIfN/oxU+2ZsXbSAltQHHkXZSClh85KCcf2+6A9fkrexPRji9mi2MnJbdjY33tQMI9yaJShSlrnGQEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739808284; c=relaxed/simple;
	bh=z4UhrBKFHeB3vPXiHJ4Bl+axcEk//HmrgY726efRnW8=;
	h=Date:From:Message-ID:To:CC:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SAyN69Bti9Sc6FI0dCIqXC+/fkyliu253mPG8sOmWFTpxCLJZL0iOc29SDs2iVOpTXI/1yWqIQR09TK3yZuT90jkd4nrfN+GUWv818kZ4Rh/vjnuO6s/fPHJUCKMf8E2ARGSk5EwIGTMak1N2uI/PJvxkY46h9AtDgfiA5bBvD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sympatico.ca; spf=pass smtp.mailfrom=sympatico.ca; dkim=pass (2048-bit key) header.d=sympatico.ca header.i=@sympatico.ca header.b=pzeZuRu8; arc=none smtp.client-ip=209.71.208.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sympatico.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sympatico.ca
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sympatico.ca; s=selector1; t=1739808282; 
        bh=41DYd8S5nzPKADDvgmNVKMBye2mp3t96d0S4S/5x/MU=;
        h=Date:From:Message-ID:To:Subject:In-Reply-To:References:MIME-Version:Content-Type;
        b=pzeZuRu8tg/7ROFgQeHf2cK4meMsY0g5+WwLURx/dJgiYg5NiGVUdgewGCZzIuibh4nhKX9YHlHmafHr38A+XYcrhJwe5qeps0jOWOD/AQOzRhxHi+IblP1UL+v/Oe0OTWfYICJiE5vgF77ibD5lB+HP3IRf3oE/++dn4fhm7RiWUaYN2xv0UW9AGPM9DsgZx01Avw6dor6/jeP/glvoJyN2CtPAsMdlo3SpTOjcgOJ1kBx0GTbdWfOwtPHA9tb7oDvHC35QMPC505rez90KzhoG+Np/KL0m+m695ee4AQ3n+S4uby5H++G94g2GHtlHVKRzeBXtZcwOR4MkeCC2ig==
X-RG-SOPHOS: Clean
X-RG-VADE-SC: 0
X-RG-VADE: Clean
X-RG-Env-Sender: al.dunsmuir@sympatico.ca
X-RG-Rigid: 67ACA5AF01009087
X-RazorGate-Vade: dmFkZTGMu6JuLVqLuz3zvC7c6OKmmoJx/rp/Y62QFXTbJQCSvND99pzidzTNP0FoNoeT+DVV8xqc/cEi0E1ntBW/hE4KCN6Y5/Ni7BTyiox9QjrVemw03MswMXHZpvAvsWBAkOZ3G6Zz7VLWHE9aDveciqCfBYF1iLLPcu30qskWnCtVh42odawXvEiks5/HOlebHKhQNnKlTJU1BEFwS519tsIPbAD0MwH5R9jHvLjFUFsHR6FdH6m44PlkEDlLcCW2r+/aueZlns20RoZH8enOhYvFxpVtXKdzuWPnhIONQOnkInmckYWGZ1lwu5jJ+PYbQTgR5kj9Vtui1jnZ/Np9zkU+ldnZD5K6ITn+XVjpSCxzNzCpwX23nGIrg+5S75VC+BkRpfAMbblt78BjS+84cxt16e2PHfT6T5iqOz2/7q6UnrAJ7Fq2pvjqJG3D4k0hrmBFudt0e6xH/aUsN/TQJt1P69E2DKWgIr+VDrtu9nP9jAF0PesKZSHNbB4w3Ho/wZScR4vp/K4LKriQfT8+HxRmp6RrX+4SOYiihZ/24VdXY9x4EjTPn2R4LX6e7bloKkykLD1Rp+mzc5GDxZz3WWVNmcCM0IMEdYUbDhKPsIn7VvSTHRWZz1Aw73BXQSd9YgVq+H1vf5IiY2LRxNlRdF/wS+rq6PUgD5mbNAxFAIQFbA
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from bucky.alba.lan (76.71.36.239) by cmx-mtlrgo001.bell.net (authenticated as al.dunsmuir@sympatico.ca)
        id 67ACA5AF01009087; Mon, 17 Feb 2025 11:02:15 -0500
Date: Mon, 17 Feb 2025 11:02:15 -0500
From: Al Dunsmuir <al.dunsmuir@sympatico.ca>
Message-ID: <1972812751.20250217110215@sympatico.ca>
To: Alexandru Elisei <alexandru.elisei@arm.com>, 
 Andrew Jones <andrew.jones@linux.dev>
CC: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, 
 david@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org, 
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
 kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, will@kernel.org, 
 julien.thierry.kdev@gmail.com, maz@kernel.org, oliver.upton@linux.dev, 
 suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
 andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 03/18] scripts: Refuse to run the tests if not configured for qemu
In-Reply-To: <Z6o/rbweZttGReir@arm.com>
References: <20250120164316.31473-1-alexandru.elisei@arm.com> 
  <20250120164316.31473-4-alexandru.elisei@arm.com>
  <20250121-45faf6a9a9681c7c9ece5f44@orel> <Z6nX8YC8ZX9jFiLb@arm.com>
  <20250210-640ff37c16a0dbccb69f08ea@orel> <Z6o/rbweZttGReir@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello Alexandru,

On Monday, February 10, 2025, 1:04:29 PM, you wrote:

> Hi Drew,

> On Mon, Feb 10, 2025 at 02:56:25PM +0100, Andrew Jones wrote:
>> On Mon, Feb 10, 2025 at 10:41:53AM +0000, Alexandru Elisei wrote:
>> > Hi Drew,
>> > 
>> > On Tue, Jan 21, 2025 at 03:48:55PM +0100, Andrew Jones wrote:
>> > > On Mon, Jan 20, 2025 at 04:43:01PM +0000, Alexandru Elisei wrote:
>> > <snip>
>> > > > ---
>> > > >  arm/efi/run             | 8 ++++++++
>> > > >  arm/run                 | 9 +++++++++
>> > > >  run_tests.sh            | 8 ++++++++
>> > > >  scripts/mkstandalone.sh | 8 ++++++++
>> > > >  4 files changed, 33 insertions(+)
>> > <snip>
>> > > > +case "$TARGET" in
>> > > > +qemu)
>> > > > +    ;;
>> > > > +*)
>> > > > +    echo "'$TARGET' not supported for standlone tests"
>> > > > +    exit 2
>> > > > +esac
>> > > 
>> > > I think we could put the check in a function in scripts/arch-run.bash and
>> > > just use the same error message for all cases.
>> > 
>> > Coming back to the series.
>> > 
>> > arm/efi/run and arm/run source scripts/arch-run.bash; run_tests.sh and
>> > scripts/mkstandalone.sh don't source scripts/arch-run.bash. There doesn't
>> > seem to be a common file that is sourced by all of them.
>> 
>> scripts/mkstandalone.sh uses arch-run.bash, see generate_test().

> Are you referring to this bit:

> generate_test ()
> {
>         <snip>
>         (echo "#!/usr/bin/env bash"
>          cat scripts/arch-run.bash "$TEST_DIR/run")

> I think scripts/arch-run.bash would need to be sourced for any functions defined
> there to be usable in mkstandalone.sh.

> What I was thinking is something like this:

> if ! vmm_supported $TARGET; then
>         echo "$0 does not support '$TARGET'"
>         exit 2
> fi

> Were you thinking of something else?

> I think mkstandalone should error at the top level (when you do make
> standalone), and not rely on the individual scripts to error if the VMM is
> not supported. That's because I think creating the test files, booting a
> machine and copying the files only to find out that kvm-unit-tests was
> misconfigured is a pretty suboptimal experience.

>> run_tests.sh doesn't, but I'm not sure it needs to validate TARGET
>> since it can leave that to the lower-level scripts.

> I put the check in arm/run, and removed it from run_tests.sh, and this is
> what I got:

> $ ./run_tests.sh selftest-setup
> SKIP selftest-setup (./arm/run does not supported 'kvmtool')

> which looks good to me.

Grammar nit:  This should be
SKIP selftest-setup (./arm/run does not support 'kvmtool')

Al

>> 
>> > 
>> > How about creating a new file in scripts (vmm.bash?) with only this
>> > function?
>> 
>> If we need a new file, then we can add one, but I'd try using
>> arch-run.bash or common.bash first.

> common.bash seems to work (and the name fits), so I'll give that a go.

> Thanks,
> Alex



