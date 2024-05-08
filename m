Return-Path: <kvm+bounces-16999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 262AF8BFD43
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 14:37:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 496F31C209F9
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 12:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA3E54F89;
	Wed,  8 May 2024 12:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="GlSblQkR"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F662BAED;
	Wed,  8 May 2024 12:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715171804; cv=none; b=LxZKJ3sRC8tBpONU0DhecDUIY2GPnUCdYjNnc/oddtqQSqP4pz3eNV4Csj5snDOZBCSeQ/tmrYysbn2ZFg0xh/vv+ByrO4lTjk3dr4317dWY1lvi2lLeY5D6YWe7QkBUgEOVClUwv4A/K9TOhWOh11OFAyrlBuWDT/TE0QAD708=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715171804; c=relaxed/simple;
	bh=sHlKHFUpBYnej+jAdfFB5RVQZxPG0xMiNILaB/TqGiU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rGXYDlDZ76uZOkvTJGcZrWW5WqbzJJedM6vVMSqnTgm0nOgST+52/RW6CdhcMYj78700/7QVvZGzWl0A4WKSdjYyE0TmTW0llobQUGc1tK3RnryceF72OEdSRPTmVuz4WyKj6UpK8d69Blkyz+d4iYYCR2N3D+sc4vSNqHSi3UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=GlSblQkR; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1715171797;
	bh=yZfVG4NHrpkSnPReaPO53GzUAb96Z27VcrDQVyegR40=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=GlSblQkRZ18yVtg+e7k/X7oifUEcihFeqt5cIFB0UOf4KmZ+/IbdcUfKggKM2kl6U
	 Goge19E2LwBUGRqI4FqGF3iLTCICHDU11dmFLL/0r2V1nR0BkzK7MPXdHyCCCLccBq
	 u0jhCjC8DrQl1nmwc2jHZyZLhXwXFfqMVksSE+rKFJ4PpmdGJCkvVdnW1046BoEPsu
	 KCulCV/1MC6gbme0QmfMnnomb/xrJJsl8AsuERjIpCfyZAD4to9DvN2tN4PynPLDN+
	 E8RYxgacEEBLJ7q+lq24Ni4D1MRlO3Rpt2VN1akrairH6UdxUv8o6HU0ink95LKqMo
	 mzTXwOOyYLdCg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VZF510x9Dz4x2v;
	Wed,  8 May 2024 22:36:37 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Gautam Menghani <gautam@linux.ibm.com>, npiggin@gmail.com,
 christophe.leroy@csgroup.eu, naveen.n.rao@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Vaibhav Jain
 <vaibhav@linux.ibm.com>
Subject: Re: [PATCH v6] arch/powerpc/kvm: Add support for reading VPA
 counters for pseries guests
In-Reply-To: <20240506145605.73794-1-gautam@linux.ibm.com>
References: <20240506145605.73794-1-gautam@linux.ibm.com>
Date: Wed, 08 May 2024 22:36:35 +1000
Message-ID: <87o79gmqek.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Gautam Menghani <gautam@linux.ibm.com> writes:
> PAPR hypervisor has introduced three new counters in the VPA area of
> LPAR CPUs for KVM L2 guest (see [1] for terminology) observability - 2
> for context switches from host to guest and vice versa, and 1 counter
> for getting the total time spent inside the KVM guest. Add a tracepoint
> that enables reading the counters for use by ftrace/perf. Note that this
> tracepoint is only available for nestedv2 API (i.e, KVM on PowerVM).
...
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 8e86eb577eb8..ed69ad58bd02 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -4108,6 +4108,54 @@ static void vcpu_vpa_increment_dispatch(struct kvm=
_vcpu *vcpu)
>  	}
>  }
>=20=20
> +static inline int kvmhv_get_l2_counters_status(void)
> +{
> +	return get_lppaca()->l2_counters_enable;
> +}

This is breaking the powernv build:

$ make powernv_defconfig ; make -s -j (nproc)
make[1]: Entering directory '/home/michael/linux/.build'
  GEN     Makefile
#
# configuration written to .config
#
make[1]: Leaving directory '/home/michael/linux/.build'
../arch/powerpc/kvm/book3s_hv.c: In function =E2=80=98kvmhv_get_l2_counters=
_status=E2=80=99:
../arch/powerpc/kvm/book3s_hv.c:4113:16: error: implicit declaration of fun=
ction =E2=80=98get_lppaca=E2=80=99; did you mean =E2=80=98get_paca=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
 4113 |         return get_lppaca()->l2_counters_enable;
      |                ^~~~~~~~~~
      |                get_paca
../arch/powerpc/kvm/book3s_hv.c:4113:28: error: invalid type argument of =
=E2=80=98->=E2=80=99 (have =E2=80=98int=E2=80=99)
 4113 |         return get_lppaca()->l2_counters_enable;
      |                            ^~
In file included from ../arch/powerpc/include/asm/paravirt.h:9,
                 from ../arch/powerpc/include/asm/qspinlock.h:7,
                 from ../arch/powerpc/include/asm/spinlock.h:7,
                 from ../include/linux/spinlock.h:95,
                 from ../include/linux/sched.h:2138,
                 from ../include/linux/hardirq.h:9,
                 from ../include/linux/kvm_host.h:7,
                 from ../arch/powerpc/kvm/book3s_hv.c:18:
../arch/powerpc/kvm/book3s_hv.c: In function =E2=80=98kvmhv_set_l2_counters=
_status=E2=80=99:
../arch/powerpc/include/asm/lppaca.h:105:41: error: =E2=80=98struct paca_st=
ruct=E2=80=99 has no member named =E2=80=98lppaca_ptr=E2=80=99
  105 | #define lppaca_of(cpu)  (*paca_ptrs[cpu]->lppaca_ptr)
      |                                         ^~
../arch/powerpc/kvm/book3s_hv.c:4119:17: note: in expansion of macro =E2=80=
=98lppaca_of=E2=80=99
 4119 |                 lppaca_of(cpu).l2_counters_enable =3D 1;
      |                 ^~~~~~~~~
../arch/powerpc/include/asm/lppaca.h:105:41: error: =E2=80=98struct paca_st=
ruct=E2=80=99 has no member named =E2=80=98lppaca_ptr=E2=80=99
  105 | #define lppaca_of(cpu)  (*paca_ptrs[cpu]->lppaca_ptr)
      |                                         ^~
../arch/powerpc/kvm/book3s_hv.c:4121:17: note: in expansion of macro =E2=80=
=98lppaca_of=E2=80=99
 4121 |                 lppaca_of(cpu).l2_counters_enable =3D 0;
      |                 ^~~~~~~~~
../arch/powerpc/kvm/book3s_hv.c: In function =E2=80=98do_trace_nested_cs_ti=
me=E2=80=99:
../arch/powerpc/kvm/book3s_hv.c:4145:29: error: initialization of =E2=80=98=
struct lppaca *=E2=80=99 from =E2=80=98int=E2=80=99 makes pointer from inte=
ger without a cast [-Werror=3Dint-conversion]
 4145 |         struct lppaca *lp =3D get_lppaca();
      |                             ^~~~~~~~~~
../arch/powerpc/kvm/book3s_hv.c: In function =E2=80=98kvmhv_get_l2_counters=
_status=E2=80=99:
../arch/powerpc/kvm/book3s_hv.c:4114:1: error: control reaches end of non-v=
oid function [-Werror=3Dreturn-type]
 4114 | }
      | ^
cc1: all warnings being treated as errors
make[5]: *** [../scripts/Makefile.build:244: arch/powerpc/kvm/book3s_hv.o] =
Error 1
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [../scripts/Makefile.build:485: arch/powerpc/kvm] Error 2
make[4]: *** Waiting for unfinished jobs....
make[3]: *** [../scripts/Makefile.build:485: arch/powerpc] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [/home/michael/linux/Makefile:1919: .] Error 2
make[1]: *** [/home/michael/linux/Makefile:240: __sub-make] Error 2
make: *** [Makefile:240: __sub-make] Error 2


cheers

