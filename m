Return-Path: <kvm+bounces-55690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AE95B34E61
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 23:49:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F5433A02F2
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 21:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C71929BDB4;
	Mon, 25 Aug 2025 21:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qTb8ec3m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684B52989B5
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 21:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756158586; cv=none; b=APQSs5bqpPbLK/nweAeqoXISj7Hmr/mw/VJCwLNfOidmPzTN9JVGTyc0qhgeDJAmF/sYdKDNUbfdq/hp6cdZuDyughTM7CjtzNXFPxHHnpwZSxEuIL/VltxRhIx++1LssG6UJTinWZVkoewzbeYLfSO8ZutQ+a3vkSjIaQlKing=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756158586; c=relaxed/simple;
	bh=fy5g75Gjohffo41G8H4Phppfp0vfa7SAV3gyjp44gCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W4QdX6drENiDy+ek1a2XhhlyZlmLJ7HtQRwA1fmJRyloQ5XsAX/z2FP2gWp6dNgYLo2B1q50nkYXLFk6gUVljw4TpZk1bNjLnIBP5DaqMNW/RyB3wfk8QlHbD9ON6ij/qw6ezkPMJVfV7hydc9qfDCIMJzr6cVYn1gLhpkYry0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qTb8ec3m; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61c869b4623so2256a12.1
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 14:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756158583; x=1756763383; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fVzEeVBNofY6j9rdW6DpWj8LIZF2ix04ZA4TyYLiqsw=;
        b=qTb8ec3mLIipsyLXX1YSjBwW1vGdABKt1mWfyGwnRg9EMcspmDGkKRhLW2TKaONCL2
         QSIP/8s9Sz1GVe5iXtYY8NpiaU5WZ2EXtFUra1pOXM/Iwty7PYw+yvzRyQHBnrvO8zwy
         yDzmAtiDxj352H5ax4bK0wp0Qq3rJcoyGGzXwbhBoudg+r9S2LftVkTa7Suumlc8RH6s
         rbWzMblA4XTGfBEMItXKlNB17zZMgWcpxRNeL7thSM4dqTWdjbmdjEBpa2ftxn/+KwYi
         vMx57AVanngvdTNs4wBSJRnuAk58gK80T85iO7EwxLjFpMishXeFY4brgSSkp+9ehwkX
         1lTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756158583; x=1756763383;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fVzEeVBNofY6j9rdW6DpWj8LIZF2ix04ZA4TyYLiqsw=;
        b=acbnlEGEHdUj6U+xb/W/vTd4RYBfrvtlteI+sCg7Dwn2mwmsti/VBAuTx9/gr+d7WP
         cDBA7EYRs+QpUyx7kYUGw/j0TkYBpkq1VJBMfP9LyZX8AesB0dlPfe5VtZyMbYgBZZOW
         rDNM+0xfx+GemBiMVzbNt61Ixj1U7UgdItaFSRn/FUpTA275J5u9IcVg7SokAW72G4vb
         lCHRZ6BdNymk47p+W/lKh/N/iljaRMx3omRz6Pimhuzdp0rpAzbU8jFVXR7aPp9uJwpN
         RgNPQrnjX4aWGGD3mvXsnez0roUW260PF4hKUbO7WtWNswbC/MgyEGVcgiaBsfjaE+CV
         au7w==
X-Forwarded-Encrypted: i=1; AJvYcCVwn0loYf1B74lRBr4HdH6bhIhQivizkTZufuprSPmiOwe9bTJFQ5cNOBpBKuFTZJq6U8Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEnRltLmqBY8AhcjWHG8xpHjxM87xKuuzvDoWE/kBk4fJFKpRw
	a0ww6PLTDnZ9uD42y8o4/wfAAeaxYrrvna3a0QLP/gUMXWzMR5d2hP7HszW3bPS2obwzN25GBnM
	4odGjzZYDw50XRXEWqkI0uo/3WO+WKzWxKTVFuJRA
X-Gm-Gg: ASbGnctG2+5IzdKSP3ur22lcjVlVHpCpjgJYeS9lTmCbw7UjQb02DrVx1z2cG9j71UF
	mgoLUlUKEAa92qIxshX7Ql8J6lllgAD4kHEUDFLdJDxH2CY7Bdrw2dkw5y/gX2h0Y7Nb9rEQ+kb
	BD/1ohhWGIboxQKnSgVik1nkml79cP5r/Fl2ZQlJJyuEvjbaRaNe2lEiuFncLWofwQuh0Mm8WZJ
	y/sbUMoJxDIyjNdDO4o34LTOQok5UpdplTIeMlObWdobI9g1QJciE3Gaw==
X-Google-Smtp-Source: AGHT+IF0Yf6BBGBBQQxS6rCnf3SLYNEuh7Oe6c3cDDlNpW01oaPLKk2o6DVmM9OCf3qcfLyanFbRWdfk6+bZxBP+570=
X-Received: by 2002:a50:ab54:0:b0:61c:6c9e:58dd with SMTP id
 4fb4d7f45d1cf-61c8f0289c4mr21949a12.2.1756158582423; Mon, 25 Aug 2025
 14:49:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com> <20250807201628.1185915-11-sagis@google.com>
 <ef499c6e-d62c-450e-982b-82c53054ea53@linux.intel.com> <c359e0d3-b840-4e98-b06d-94b4e3f7f792@linux.intel.com>
In-Reply-To: <c359e0d3-b840-4e98-b06d-94b4e3f7f792@linux.intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Mon, 25 Aug 2025 16:49:29 -0500
X-Gm-Features: Ac12FXzWjUF5suI-kS5JLM-EDsLDh7zS9tyA6cW5QgEtLL7-maNy7Z9dfx-jyiM
Message-ID: <CAAhR5DE8BMUm68Cx70aukCi-6SJbNToknZU7ea5YJM4UijbHnw@mail.gmail.com>
Subject: Re: [PATCH v8 10/30] KVM: selftests: TDX: Add report_fatal_error test
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Roger Wang <runanwang@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2025 at 2:05=E2=80=AFAM Binbin Wu <binbin.wu@linux.intel.co=
m> wrote:
>
>
>
> On 8/13/2025 6:58 PM, Binbin Wu wrote:
> >
> >
> > On 8/8/2025 4:16 AM, Sagi Shahar wrote:
> >> The test checks report_fatal_error functionality.
> >>
> >> TD guest can use TDG.VP.VMCALL<ReportFatalError> to report the fatal e=
rror
> >> it has experienced. TD guest is requesting a termination with the erro=
r
> >> information that include 16 general-purpose registers.
> >
> > I think it's worth to mention that KVM converts TDG.VP.VMCALL<ReportFat=
alError>
> > to KVM_EXIT_SYSTEM_EVENT with the type KVM_SYSTEM_EVENT_TDX_FATAL.
> >
> >>
> >> Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
> >> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> >> Signed-off-by: Sagi Shahar <sagis@google.com>
> >> ---
> >>   .../selftests/kvm/include/x86/tdx/tdx.h       |  6 ++-
> >>   .../selftests/kvm/include/x86/tdx/tdx_util.h  |  1 +
> >>   .../selftests/kvm/include/x86/tdx/test_util.h | 19 +++++++
> >>   tools/testing/selftests/kvm/lib/x86/tdx/tdx.c | 18 +++++++
> >>   .../selftests/kvm/lib/x86/tdx/tdx_util.c      |  6 +++
> >>   .../selftests/kvm/lib/x86/tdx/test_util.c     | 10 ++++
> >>   tools/testing/selftests/kvm/x86/tdx_vm_test.c | 51 +++++++++++++++++=
+-
> >>   7 files changed, 108 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx.h b/tools=
/testing/selftests/kvm/include/x86/tdx/tdx.h
> >> index a7161efe4ee2..2acccc9dccf9 100644
> >> --- a/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
> >> +++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
> >> @@ -4,9 +4,13 @@
> >>     #include <stdint.h>
> >>   +#include "kvm_util.h"
> >> +
> >> +#define TDG_VP_VMCALL_REPORT_FATAL_ERROR 0x10003
> >> +
> >>   #define TDG_VP_VMCALL_INSTRUCTION_IO 30
> >>     uint64_t tdg_vp_vmcall_instruction_io(uint64_t port, uint64_t size=
,
> >>                         uint64_t write, uint64_t *data);
> >> -
> >> +void tdg_vp_vmcall_report_fatal_error(uint64_t error_code, uint64_t d=
ata_gpa);
> >>   #endif // SELFTEST_TDX_TDX_H
> >> diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h b/=
tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
> >> index 57a2f5893ffe..d66cf17f03ea 100644
> >> --- a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
> >> +++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
> >> @@ -15,5 +15,6 @@ struct kvm_vm *td_create(void);
> >>   void td_initialize(struct kvm_vm *vm, enum vm_mem_backing_src_type s=
rc_type,
> >>              uint64_t attributes);
> >>   void td_finalize(struct kvm_vm *vm);
> >> +void td_vcpu_run(struct kvm_vcpu *vcpu);
> >>     #endif // SELFTESTS_TDX_KVM_UTIL_H
> >> diff --git a/tools/testing/selftests/kvm/include/x86/tdx/test_util.h b=
/tools/testing/selftests/kvm/include/x86/tdx/test_util.h
> >> index 07d63bf1ffe1..dafeee9af1dc 100644
> >> --- a/tools/testing/selftests/kvm/include/x86/tdx/test_util.h
> >> +++ b/tools/testing/selftests/kvm/include/x86/tdx/test_util.h
> >> @@ -38,4 +38,23 @@ bool is_tdx_enabled(void);
> >>   void tdx_test_success(void);
> >>   void tdx_test_assert_success(struct kvm_vcpu *vcpu);
> >>   +/*
> >> + * Report an error with @error_code to userspace.
> >> + *
> >> + * Return value from tdg_vp_vmcall_report_fatal_error() is ignored si=
nce
> >> + * execution is not expected to continue beyond this point.
> >> + */
> >> +void tdx_test_fatal(uint64_t error_code);
>
> Another thing to mention is that tdx_test_fatal() and tdx_test_fatal_with=
_data()
> use R12 to pass the input error_code, which is functionally workable, sin=
ce both
> guest and userspace code are in KVM selftest test code.
>
> But TDX GHCI spec has its own format for R12:
> - 31:0
>    TD-specific error code
>    * Panic =E2=80=93 0x0.
>    * Values =E2=80=93 0x1 to 0xFFFFFFFF reserved.
> - 62:32
>    TD-specific extended error code.
>    TD software defined.
> - 63
>    Set if the TD specified additional information in the GPA parameter (R=
13).
> So, this patch series doesn't follow the format.
>
> Also, tdx_test_fatal_with_data() set bit 63 of R12, so, the value reporte=
d to
> userspace will be different in R12 from the original parameter passed by =
the
> guest, and setting bit 63 could collide with the error code defined by gu=
est.
>
> IMHO, it's better to follow the GHCI spec.
> But if TDX KVM selftest code doesn't want to follow it, then it should no=
t set
> bit 63 for tdx_test_fatal_with_data() in R12.
>

Other than the fact that the address pointed to by data_gpa is a fake
address, the rest of the implementation should follow the spec. And
even on a normal system, TDX doesn't guarantee that the address
provided by the guest is valid, it will simply send it to userspace as
is.

I can replace the setting of bit 63 with a GUEST_ASSERT to verify it
is set if data_gpa is provided by the guest.

> >>
> >> +
> >> +/*
> >> + * Report an error with @error_code to userspace.
> >> + *
> >> + * @data_gpa may point to an optional shared guest memory holding the=
 error
> >> + * string.
> >
> > A according to the GHCI spec, this is the optional GPA pointing to a sh=
ared guest memory, but in these TDX KVM selftest cases, it may not used tha=
t way. It may need some clarification about it. And based on the usage in t=
his patch series, the name data_gpa may be misleading.
> >
> >
> >> + *
> >> + * Return value from tdg_vp_vmcall_report_fatal_error() is ignored si=
nce
> >> + * execution is not expected to continue beyond this point.
> >> + */
> >> +void tdx_test_fatal_with_data(uint64_t error_code, uint64_t data_gpa)=
;
> >> +
> [...]

