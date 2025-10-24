Return-Path: <kvm+bounces-61080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BC1B2C08574
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 01:44:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C0D8F35260A
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 23:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79F3230E848;
	Fri, 24 Oct 2025 23:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FbCXMJ03"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D632730E83E
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 23:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761349434; cv=none; b=cZ19ge9hgKOT46ymOqwiwxaJhG5HF7DCllTogIafBg/kg1TmwxR7It+HxIBtJsel2iNmMHGD5t0uUATNNrh93PRUHrkom/iWjtQcTGXPQZZFGthi5wIQGD5kvXMjCYZZJs+2LQTm7+vTMxRCGCsjZodSZPdTCNwJ5COkX/4eh8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761349434; c=relaxed/simple;
	bh=+NEftr7VWmliQcXUqkaO9sJG2DgzF/Yaw8WY6cHdu/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fcpGs+PSp0FmjHaRJIbJ6trluby/Nljroc/CDQ/JvyM3FWc8E5F9g06W6rHTFbf1hHe9spvUDH6DTF+Z12EvdJgbafZVbsY4SdIBBTqsGr1dAxtQdL8viK/BqUVMIKTyEOIz1M+UOjkGKtJp4al55Z8Bctm0s6QZJvqiclco88k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FbCXMJ03; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63c4b41b38cso5599152a12.3
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 16:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761349431; x=1761954231; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4qshgmZlkIM4+vcn2er+R5ZwtdRF9Gko5Hx8ZyCDhMI=;
        b=FbCXMJ030EbhJhkpIwtakUyhoHz7FsOTvmpRnnq60Srd2g+7vcUmIEBluZlGWYa2dg
         N6nD8vjZT/TGfJYYmn1ZXgCZNVoc+9TXQTu7rhw/z8PVN5Car3t93KlbCvSrwyYxliAV
         8CipqswpJ1TM8B3FiThJSDotIC5D+gSa2phaBk9+c0W155LNckKU9SV6c+8kB8HDrc/l
         /ZASOzO5UfrY3SWNibX9k+auz6P61Uhbf5QFPos3FFXN/5WsPIHdkrjKm8Wyc1fqM7Tf
         4Od620M5Qo13mwx5ZcTU2i9ONX+d6MiGt45hTd/ONLwycLJnDbtq9PPESypfEnDnqAQE
         tlKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761349431; x=1761954231;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4qshgmZlkIM4+vcn2er+R5ZwtdRF9Gko5Hx8ZyCDhMI=;
        b=kyhx5b2XFxSxW2syTQDGdgikyYNpjOkYc5dE0G4nBQKbw79JGbgKqVXnhiZSRLSWeu
         lFpqrsLUcy2h/4Ud9H1pUoi6VtIaOc2Zyla9nN7f5DkD+kVoORPld/CP1cwBxRQZJbiI
         KhAGqgOq6C3DSZtCV9Yy3+hDVnXkezniUSAF3d8wsfVnbu1aWzuSecI4/wJnfRzFFyE+
         lgzz3b3KiZpu7n07XBZL4XKWDqupeNDXYYraIZfekkexav226hwieOCuapvILMnoJxGc
         WATAKFIZ6mOQmurHyFUSL+/ESzcRfiMBgXfd024VP7cuF3ie9SEB98Cwg7VtWBJv//4e
         sDwA==
X-Forwarded-Encrypted: i=1; AJvYcCWNZvsQvoTqVGO6q+CeDfj04LF3D+ZMMXLaiEgoYMYYdBvWQAMBpwpX/7OBV7a8F1awWNc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwER5tA0Eh0GLGYgYvm70CSKyjVgYjLttQ++Ml43vrncym923on
	2T0bF21XUbgdV0CQLCfcVs/RhMa75c2CtTLmBG0M/aRK+zmUIf4yN9Qy
X-Gm-Gg: ASbGncun4t7sVrp6yDxCBVBf4edpfoWLeiGVk/jrI/N12y5lDfDb5igo6691ydDkAfD
	dYby/OulniIyzp3ZDZDjc60Uv7jOHV+CVw/3fUYINOPmnODbSqgF6jGK+8Y2qeteImV2ODutIDn
	/UdHIrEnESpGo9ewipaRJ2C6u12zeSEoFnw6eb9qAtLYS7LfZ8lDx+Cq9FV7QixkYGiK5LZtJvT
	Y0mL69aR88NhJBedCe0I6WY0KIGbMp5IdZ6NsCqgTgNOoQ2BvFM364JtPWeqKQ8DFpE9WOv3nh0
	R6Kwg516UXwJpcbUu62SF2auG+GlZDrWfhNpzz5i20iQCFjIzxxqmxLiiAw1LRI8mISTD+l2kn2
	3nYH1js9P5Bt0xdk6F6qTGoGW493vSk04JF2H4SP4dkwNeC6TwvtQDMYqWQ1FxYTGMA/qveumZA
	E9i9l2cw==
X-Google-Smtp-Source: AGHT+IEQw0TA1CC7no4fMAMA9oQRoUt9Lgbn+Uft1azRKrTnyGz7lCiyNuO6p2GHKFOC05VVJ/iKvw==
X-Received: by 2002:a05:600c:4f89:b0:471:a98:99a6 with SMTP id 5b1f17b1804b1-475cafae164mr64272055e9.11.1761342429974;
        Fri, 24 Oct 2025 14:47:09 -0700 (PDT)
Received: from andrea ([31.189.53.175])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47496d4b923sm89676705e9.14.2025.10.24.14.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 14:47:09 -0700 (PDT)
Date: Fri, 24 Oct 2025 23:47:04 +0200
From: Andrea Parri <parri.andrea@gmail.com>
To: Xu Lu <luxu.kernel@bytedance.com>
Cc: corbet@lwn.net, paul.walmsley@sifive.com, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, alex@ghiti.fr, robh@kernel.org,
	krzk+dt@kernel.org, conor+dt@kernel.org, will@kernel.org,
	peterz@infradead.org, boqun.feng@gmail.com, mark.rutland@arm.com,
	anup@brainfault.org, atish.patra@linux.dev, pbonzini@redhat.com,
	shuah@kernel.org, ajones@ventanamicro.com, brs@rivosinc.com,
	guoren@kernel.org, linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org,
	apw@canonical.com, joe@perches.com, lukas.bulwahn@gmail.com
Subject: Re: [PATCH v4 00/10] riscv: Add Zalasr ISA extension support
Message-ID: <aPvz2Pb6RuWnw9Ht@andrea>
References: <20251020042056.30283-1-luxu.kernel@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020042056.30283-1-luxu.kernel@bytedance.com>

On Mon, Oct 20, 2025 at 12:20:46PM +0800, Xu Lu wrote:
> This patch adds support for the Zalasr ISA extension, which supplies the
> real load acquire/store release instructions.
> 
> The specification can be found here:
> https://github.com/riscv/riscv-zalasr/blob/main/chapter2.adoc
> 
> This patch seires has been tested with ltp on Qemu with Brensan's zalasr
> support patch[1].
> 
> Some false positive spacing error happens during patch checking. Thus I
> CCed maintainers of checkpatch.pl as well.
> 
> [1] https://lore.kernel.org/all/CAGPSXwJEdtqW=nx71oufZp64nK6tK=0rytVEcz4F-gfvCOXk2w@mail.gmail.com/
> 
> v4:
>  - Apply acquire/release semantics to arch_atomic operations. Thanks
>  to Andrea.

Perhaps I wasn't clear enough, sorry, but I did mean my suggestion
(specifically, the use of .aq/.rl annotations) to be conditional on
zalasr.  Same observation for xchg/cmpxchg below.  IOW, I really
expected this series to introduce _no changes_ to our lowerings when
!zalasr.  If any !zalasr-changes are needed, I'd suggest isolating
/submitting them in dedicated patches.

But other than that, this looks pretty good to me.  Perhaps something
else to consider for zalasr is our lowering of smp_cond_load_acquire()
(can't spot an actual bug now, but recall the principle "zalasr -> use
.aq/.rl annotations ..."): riscv currently uses the "generic", fence-
based implementation from include/asm-generic/barrier.h; compare that
with e.g. the implementation from arch/arm64/include/asm/barrier.h .

  Andrea


> v3:
>  - Apply acquire/release semantics to arch_xchg/arch_cmpxchg operations
>  so as to ensure FENCE.TSO ordering between operations which precede the
>  UNLOCK+LOCK sequence and operations which follow the sequence. Thanks
>  to Andrea.
>  - Support hwprobe of Zalasr.
>  - Allow Zalasr extensions for Guest/VM.
> 
> v2:
>  - Adjust the order of Zalasr and Zalrsc in dt-bindings. Thanks to
>  Conor.
> 
> Xu Lu (10):
>   riscv: Add ISA extension parsing for Zalasr
>   dt-bindings: riscv: Add Zalasr ISA extension description
>   riscv: hwprobe: Export Zalasr extension
>   riscv: Introduce Zalasr instructions
>   riscv: Apply Zalasr to smp_load_acquire/smp_store_release
>   riscv: Apply acquire/release semantics to arch_xchg/arch_cmpxchg
>     operations
>   riscv: Apply acquire/release semantics to arch_atomic operations
>   riscv: Remove arch specific __atomic_acquire/release_fence
>   RISC-V: KVM: Allow Zalasr extensions for Guest/VM
>   RISC-V: KVM: selftests: Add Zalasr extensions to get-reg-list test
> 
>  Documentation/arch/riscv/hwprobe.rst          |   5 +-
>  .../devicetree/bindings/riscv/extensions.yaml |   5 +
>  arch/riscv/include/asm/atomic.h               |  70 ++++++++-
>  arch/riscv/include/asm/barrier.h              |  91 +++++++++--
>  arch/riscv/include/asm/cmpxchg.h              | 144 +++++++++---------
>  arch/riscv/include/asm/fence.h                |   4 -
>  arch/riscv/include/asm/hwcap.h                |   1 +
>  arch/riscv/include/asm/insn-def.h             |  79 ++++++++++
>  arch/riscv/include/uapi/asm/hwprobe.h         |   1 +
>  arch/riscv/include/uapi/asm/kvm.h             |   1 +
>  arch/riscv/kernel/cpufeature.c                |   1 +
>  arch/riscv/kernel/sys_hwprobe.c               |   1 +
>  arch/riscv/kvm/vcpu_onereg.c                  |   2 +
>  .../selftests/kvm/riscv/get-reg-list.c        |   4 +
>  14 files changed, 314 insertions(+), 95 deletions(-)
> 
> -- 
> 2.20.1
> 

