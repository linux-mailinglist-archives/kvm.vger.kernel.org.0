Return-Path: <kvm+bounces-22272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BDB7593CAE9
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 00:36:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E9891F229DD
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 22:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4A4A149002;
	Thu, 25 Jul 2024 22:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DpCeRh08"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CD213CFA1
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 22:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721946953; cv=none; b=ruxTjl67JRm+Om8miV3N1iWYpYPrU8puO5thappancwVPBDW2hhTDd767ox7vGZr5dp4WWLlxgnWygjOu9S6B/UT1rHOWtr183yV1JGMm59XYcJnplEb8vF1K0vwgJrb61zIgRhFnaUScS3fsW3XnSBqkNN5st3abcUf9mkYRbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721946953; c=relaxed/simple;
	bh=cQJ+qcncN2IgnGJoOeQTzhJlYEh2QX5nFJxhGmYp1QY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iAJQxXDRfH8P94zaAcMyoVAYJmu5XyXBZJUZl/TxaxASLxJ7T47ShYfeC0LksDPtSw8//gPKfwL+81lok77D6Ykw4RzTwzBtjtTfxc/WPR5TY9yRHmBUtewMFOe7IuHX66pNahCBGV1hMcgaDHLwFCDdqcCEymTbufYJC/Zj9Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DpCeRh08; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e03caab48a2so1180125276.1
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 15:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721946950; x=1722551750; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YpVjP0KtbEWV6Tn7/HiYJHCVy9nNHdlo2E773Pd3yBk=;
        b=DpCeRh08dvW9SlqRRHtQs/vgMUl67JnQLO14pAQ8TNrVVYNH+1bbovQdg6l3M4NWXz
         XElly0us1es2NtxzbXGI/R/j2Y9/cMdrfoxAZTSFF83mixzJIaBlNHoQRpp3tlEju2k/
         dbXDh/VZvauC44DrXwcy5xWDJckJILxyO5A7hgnmLbiiVVHKgxrlIRFmMdcd+R8RiNFv
         3ZHkrbZYUD55avHo68EOnMnX7ma11gdhbm0ENozx8g/u0jTeF/jXJwrFDHWqYejyfwzp
         1ft1WKU5QZ9t9Aa+FVjfMpBPmpwMjytyfw95Fy4OTzy5mrCC5p+wDECZT70Z9DiYGGS8
         dvCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721946950; x=1722551750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YpVjP0KtbEWV6Tn7/HiYJHCVy9nNHdlo2E773Pd3yBk=;
        b=mx142VzHVm8YYP4hN3Wt3ni2qItEVNfqwEDdORiWjV+IaqtVWApdD3YhseX8YX2MSM
         CFq9IvG1DqZUT/npMSDpD1Z/8ONkesgIP5HquiyMzW5Z2jdgKxm2TbWuNaeqcBPGKBhu
         0skenYMIjm5cshvfHjTp2B1cjMHkYo3teeObIJwswfZOBuVT1oiyhq+Dw/OoweF7h5D1
         AR5+CILRZoyDZJyltdtVfCTofQ3GEGBkvTdQw0R1BUl24cRjp0gdiudskOqALFPviKXC
         RW/Jr+M1Kp2c1XCGlTy5p0tGi+WKtnPwnrK23GzYXcoy5lQZH/YZ8+g507XZnJHxKNYD
         yNWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWr0082yaowtdKlZs6TYfh7U6WeLLLaqCgFlxhO1ElHoV4fIRZ/Z5xCofKjYJ6c6/YeCT+JO+K2YppAY7uiSzHBOgfd
X-Gm-Message-State: AOJu0YxGep6221qQHpm84C6Ua074OXZu4MaoQV2E3jCwzr0sWlwYrl8H
	+9xDhx0lVPpnvSzOm5yMyllNgGoVbnrJBPxB8FGYoBOJncFTMyVkth4mOSVcPOFGzluTwNYP2Xx
	m+Ns1PuhDLwYYnnHQbj7sCZNMJUdVPqOXJJKi
X-Google-Smtp-Source: AGHT+IGmr4MPiaJyIpCo/BhgUoawx8fTUxSzitSrLmVUuttLQqaBuq66PsrBs3kKIRVwyyzZ1yf+Z6/bPBLBsogIgSI=
X-Received: by 2002:a5b:60a:0:b0:e05:e410:d166 with SMTP id
 3f1490d57ef6-e0b117aae60mr5820777276.18.1721946949830; Thu, 25 Jul 2024
 15:35:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231212204647.2170650-1-sagis@google.com> <20231212204647.2170650-11-sagis@google.com>
 <ZeUvtzHmMo9jdMnu@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZeUvtzHmMo9jdMnu@yzhao56-desk.sh.intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Thu, 25 Jul 2024 17:35:37 -0500
Message-ID: <CAAhR5DHzVqX72jj=VUe0atbsMNuQO3S8n6OiFfuugh9grv=75w@mail.gmail.com>
Subject: Re: [RFC PATCH v5 10/29] KVM: selftests: TDX: Adding test case for
 TDX port IO
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: linux-kselftest@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
	Ryan Afranji <afranji@google.com>, Erdem Aktas <erdemaktas@google.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Peter Gonda <pgonda@google.com>, 
	Haibo Xu <haibo1.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Roger Wang <runanwang@google.com>, 
	Vipin Sharma <vipinsh@google.com>, jmattson@google.com, dmatlack@google.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 3, 2024 at 8:49=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> On Tue, Dec 12, 2023 at 12:46:25PM -0800, Sagi Shahar wrote:
> > From: Erdem Aktas <erdemaktas@google.com>
> >
> > Verifies TDVMCALL<INSTRUCTION.IO> READ and WRITE operations.
> >
> > Signed-off-by: Erdem Aktas <erdemaktas@google.com>
> > Signed-off-by: Sagi Shahar <sagis@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ryan Afranji <afranji@google.com>
> > ---
> >  .../kvm/include/x86_64/tdx/test_util.h        | 34 ++++++++
> >  .../selftests/kvm/x86_64/tdx_vm_tests.c       | 82 +++++++++++++++++++
> >  2 files changed, 116 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/tdx/test_util.h=
 b/tools/testing/selftests/kvm/include/x86_64/tdx/test_util.h
> > index 6d69921136bd..95a5d5be7f0b 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/tdx/test_util.h
> > +++ b/tools/testing/selftests/kvm/include/x86_64/tdx/test_util.h
> > @@ -9,6 +9,40 @@
> >  #define TDX_TEST_SUCCESS_PORT 0x30
> >  #define TDX_TEST_SUCCESS_SIZE 4
> >
> > +/**
> > + * Assert that some IO operation involving tdg_vp_vmcall_instruction_i=
o() was
> > + * called in the guest.
> > + */
> > +#define TDX_TEST_ASSERT_IO(VCPU, PORT, SIZE, DIR)                    \
> > +     do {                                                            \
> > +             TEST_ASSERT((VCPU)->run->exit_reason =3D=3D KVM_EXIT_IO, =
   \
> > +                     "Got exit_reason other than KVM_EXIT_IO: %u (%s)\=
n", \
> > +                     (VCPU)->run->exit_reason,                       \
> > +                     exit_reason_str((VCPU)->run->exit_reason));     \
> > +                                                                     \
> > +             TEST_ASSERT(((VCPU)->run->exit_reason =3D=3D KVM_EXIT_IO)=
 && \
> > +                     ((VCPU)->run->io.port =3D=3D (PORT)) &&          =
   \
> > +                     ((VCPU)->run->io.size =3D=3D (SIZE)) &&          =
   \
> > +                     ((VCPU)->run->io.direction =3D=3D (DIR)),        =
   \
> > +                     "Got unexpected IO exit values: %u (%s) %d %d %d\=
n", \
> > +                     (VCPU)->run->exit_reason,                       \
> > +                     exit_reason_str((VCPU)->run->exit_reason),      \
> > +                     (VCPU)->run->io.port, (VCPU)->run->io.size,     \
> > +                     (VCPU)->run->io.direction);                     \
> > +     } while (0)
> > +
> > +/**
> > + * Check and report if there was some failure in the guest, either an =
exception
> > + * like a triple fault, or if a tdx_test_fatal() was hit.
> > + */
> > +#define TDX_TEST_CHECK_GUEST_FAILURE(VCPU)                           \
> > +     do {                                                            \
> > +             if ((VCPU)->run->exit_reason =3D=3D KVM_EXIT_SYSTEM_EVENT=
)  \
> > +                     TEST_FAIL("Guest reported error. error code: %lld=
 (0x%llx)\n", \
> > +                             (VCPU)->run->system_event.data[1],      \
> > +                             (VCPU)->run->system_event.data[1]);     \
> > +     } while (0)
> > +
> >  /**
> >   * Assert that tdx_test_success() was called in the guest.
> >   */
> > diff --git a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c b/tools/=
testing/selftests/kvm/x86_64/tdx_vm_tests.c
> > index 8638c7bbedaa..75467c407ca7 100644
> > --- a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
> > +++ b/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
> > @@ -2,6 +2,7 @@
> >
> >  #include <signal.h>
> >  #include "kvm_util_base.h"
> > +#include "tdx/tdcall.h"
> >  #include "tdx/tdx.h"
> >  #include "tdx/tdx_util.h"
> >  #include "tdx/test_util.h"
> > @@ -74,6 +75,86 @@ void verify_report_fatal_error(void)
> >       printf("\t ... PASSED\n");
> >  }
> >
> > +#define TDX_IOEXIT_TEST_PORT 0x50
> > +
> > +/*
> > + * Verifies IO functionality by writing a |value| to a predefined port=
.
> > + * Verifies that the read value is |value| + 1 from the same port.
> > + * If all the tests are passed then write a value to port TDX_TEST_POR=
T
> > + */
> > +void guest_ioexit(void)
> > +{
> > +     uint64_t data_out, data_in, delta;
> > +     uint64_t ret;
> > +
> > +     data_out =3D 0xAB;
> > +     ret =3D tdg_vp_vmcall_instruction_io(TDX_IOEXIT_TEST_PORT, 1,
> > +                                     TDG_VP_VMCALL_INSTRUCTION_IO_WRIT=
E,
> > +                                     &data_out);
> > +     if (ret)
> > +             tdx_test_fatal(ret);
> > +
> > +     ret =3D tdg_vp_vmcall_instruction_io(TDX_IOEXIT_TEST_PORT, 1,
> > +                                     TDG_VP_VMCALL_INSTRUCTION_IO_READ=
,
> > +                                     &data_in);
> > +     if (ret)
> > +             tdx_test_fatal(ret);
> > +
> > +     delta =3D data_in - data_out;
> > +     if (delta !=3D 1)
> > +             tdx_test_fatal(ret);
> > +
> > +     tdx_test_success();
> > +}
> > +
> > +void verify_td_ioexit(void)
> > +{
> > +     struct kvm_vm *vm;
> > +     struct kvm_vcpu *vcpu;
> > +
> > +     uint32_t port_data;
> > +
> > +     vm =3D td_create();
> > +     td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
> > +     vcpu =3D td_vcpu_add(vm, 0, guest_ioexit);
> > +     td_finalize(vm);
> > +
> > +     printf("Verifying TD IO Exit:\n");
> > +
> > +     /* Wait for guest to do a IO write */
> > +     td_vcpu_run(vcpu);
> > +     TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
> This check is a vain, because the first VMExit from vcpu run is always
> KVM_EXIT_IO caused by tdg_vp_vmcall_instruction_io().
>
>
> > +     TDX_TEST_ASSERT_IO(vcpu, TDX_IOEXIT_TEST_PORT, 1,
> > +                     TDG_VP_VMCALL_INSTRUCTION_IO_WRITE);
> > +     port_data =3D *(uint8_t *)((void *)vcpu->run + vcpu->run->io.data=
_offset);
> > +
> > +     printf("\t ... IO WRITE: OK\n");
> So,  even if there's an error in emulating writing of TDX_IOEXIT_TEST_POR=
T,
> and guest would then find a failure and trigger tdx_test_fatal(), this li=
ne
> will still print "IO WRITE: OK", which is not right.

Changed this to "IO WRITE: DONE". This is a useful for understanding
errors if they happen so I don't want to remove this log entirely.
>
> > +
> > +     /*
> > +      * Wait for the guest to do a IO read. Provide the previous writt=
en data
> > +      * + 1 back to the guest
> > +      */
> > +     td_vcpu_run(vcpu);
> > +     TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
> This check is a vain, too, as in  write case.

There's no harm in adding this check and it helps debugging issues if
something unexpected happens.
Since this check always come together with td_vcpu_run I'm going to
simplify the code and introduce a TDX_RUN macro that simply runs the
CPU and checks for reported guest failures which is going to replace
the td_vcpu_run/TDX_TEST_CHECK_GUEST_FAILURE combo.
>
> > +     TDX_TEST_ASSERT_IO(vcpu, TDX_IOEXIT_TEST_PORT, 1,
> > +                     TDG_VP_VMCALL_INSTRUCTION_IO_READ);
> > +     *(uint8_t *)((void *)vcpu->run + vcpu->run->io.data_offset) =3D p=
ort_data + 1;
> > +
> > +     printf("\t ... IO READ: OK\n");
> Same as in write case, this line should not be printed until after guest
> finishing checking return code.
>
> > +
> > +     /*
> > +      * Wait for the guest to complete execution successfully. The rea=
d
> > +      * value is checked within the guest.
> > +      */
> > +     td_vcpu_run(vcpu);
> > +     TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
> > +     TDX_TEST_ASSERT_SUCCESS(vcpu);
> > +
> > +     printf("\t ... IO verify read/write values: OK\n");
> > +     kvm_vm_free(vm);
> > +     printf("\t ... PASSED\n");
> > +}
> > +
> >  int main(int argc, char **argv)
> >  {
> >       setbuf(stdout, NULL);
> > @@ -85,6 +166,7 @@ int main(int argc, char **argv)
> >
> >       run_in_new_process(&verify_td_lifecycle);
> >       run_in_new_process(&verify_report_fatal_error);
> > +     run_in_new_process(&verify_td_ioexit);
> >
> >       return 0;
> >  }
> > --
> > 2.43.0.472.g3155946c3a-goog
> >
> >
>

