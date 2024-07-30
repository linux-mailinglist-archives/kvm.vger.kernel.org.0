Return-Path: <kvm+bounces-22691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45DEB942040
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 21:04:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A6921C237B8
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 19:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D6418C900;
	Tue, 30 Jul 2024 19:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M4URxwe+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7FD1AA3C5
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 19:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722366241; cv=none; b=JSZD+u/F4Bqvv5qwATgxwnh1IAA5qp4bEgcr6WUH9H/IYCLCIhPUbEch04V2DjVMDTvHKAKF3tIGWhmTXFkSYU6pQGJqt8m9PF1QRlBjJYKsISbUBWEWuziSzoL25/DFRr/NuNUcU1UoQPCECyqV6bTMoEZKS0ZiV1AKWKWE/mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722366241; c=relaxed/simple;
	bh=IC3UoEhYTh2WtP4rnCb850lFSL6P1IuRKOhEzQit4co=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=juxn0wjz0Vkq5ZJw3ou55pSQiqfjEx/bAM4130kcO+KaDsSNOLIjlAibjKwDsxJQOuLQiBirnjKB2uvR77z+18d8D3C6aBkqx5MY3TfzrPdwOeGySwXooUCdtdr9/qViX/lVD9m+Bq5zIjfJm5eBXh4bXnb/pXkWj1bAV2U9oA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M4URxwe+; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-66a1842b452so28045457b3.3
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 12:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722366237; x=1722971037; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lqbSWDGfRec05xcYpphHjOYwTWmAIvqjJnT7JYSLr4w=;
        b=M4URxwe+4IfVI9c36GwzRJvTREe1r42eh7gs82bMTUd6Zw6WXOiYZuAFLkJqV2zHlO
         DD1n4NSZMr/RD2V/bx+okvpJonDEqScsURvb7ZWUO3qzoo6Ivs4/XiNXYjmtUaIVCUob
         wquVk5pAQ4U3oF0rewxEicmiXVIKcTVxH/SLig4cciKO5kKgtD0qzzf+WSTvKgvbA6AL
         aoxK3RLtjvljiIZoUyNKxbb8v9hnGaNZkKnlTMACB2QucN+xQ1dZw/a4Ibi7hwDmWbPV
         K/h1B/Ye9gzLSynLJHXOel4oi5uZNoL18bT4yq6oEwm3b6mP5DJ6sL2KP9McnMnrongG
         eQ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722366237; x=1722971037;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lqbSWDGfRec05xcYpphHjOYwTWmAIvqjJnT7JYSLr4w=;
        b=pySRVHu0ivyvbsglxRHV32NXD5eaOQRU+k5Gl69v+KPCOjH90R/ZrJtjI24mEYT20o
         pCINgCF2nttRVFOiM/zjxwMLLyQCDA71dYpB1QyZhMkEfWGP+UTIUTM+TrgsKyhBe8P3
         0Uzj8Km0gElHPJqpRgnD8HEYwKhJMTxQSqif6IpV4BDozojHP+2bHIaIlOm2HZP5GM5t
         zZHXlFd3y0L3o9YK13Rj4bas65U1Hptm32ONm9vyffLyDtgbHGaDXdprZiSHmzBj2g+Q
         gvpS+GJa/Aa5Q0hjNgBOccd3+AWVA0am9uWsX2Yy75a+2EuUrTHfcH2j0tWllWx2bZEu
         EDZA==
X-Forwarded-Encrypted: i=1; AJvYcCUBBCLHo1AVetx6iZvPfiLA2i4Ka3whl4VMgXAaLKJaQ+Lw4/OnRC01aWT9/8wLVeGSQ2hn2BUWe0uQQeHUzkP9twjg
X-Gm-Message-State: AOJu0YznoD3LzezQN5MtIiP6C7FTHWkRr6d4V4yvU+XBRafCpBngWp2j
	Uaa2gZ17XRvT9xzNY9eD3rlOzQxLc+nQPgZHy1obe2y7wtkcj9gOrvY0OVPnRyLI8ucmeP8Ae1S
	zHWXf0gU6Sw2TYkkDb+Gl5Y16/g/O6cokNoxT
X-Google-Smtp-Source: AGHT+IFKjqscjO6pouY8hxpbbCNPXhKKZjqEjRpJorpb+m2dfdtr1Xa6zlfgVyytvMdm/UvcP/s4zCEhMTkJmOLNAao=
X-Received: by 2002:a05:6902:2d07:b0:e0b:ace9:be9d with SMTP id
 3f1490d57ef6-e0bace9c02cmr1726522276.35.1722366237068; Tue, 30 Jul 2024
 12:03:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231212204647.2170650-1-sagis@google.com> <20231212204647.2170650-19-sagis@google.com>
 <ZebeuMoz8izs/SoG@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZebeuMoz8izs/SoG@yzhao56-desk.sh.intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Tue, 30 Jul 2024 14:03:44 -0500
Message-ID: <CAAhR5DHxMYWsBzs=FrjGdBjygEeohz8hMpBAiOJvu6tDKJCGrg@mail.gmail.com>
Subject: Re: [RFC PATCH v5 18/29] KVM: selftests: TDX: Add TDX MMIO writes test
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

On Tue, Mar 5, 2024 at 3:28=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> On Tue, Dec 12, 2023 at 12:46:33PM -0800, Sagi Shahar wrote:
> > The test verifies MMIO writes of various sizes from the guest to the ho=
st.
> >
> > Signed-off-by: Sagi Shahar <sagis@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ryan Afranji <afranji@google.com>
> > ---
> >  .../selftests/kvm/include/x86_64/tdx/tdx.h    |  2 +
> >  .../selftests/kvm/lib/x86_64/tdx/tdx.c        | 14 +++
> >  .../selftests/kvm/x86_64/tdx_vm_tests.c       | 85 +++++++++++++++++++
> >  3 files changed, 101 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/tdx/tdx.h b/too=
ls/testing/selftests/kvm/include/x86_64/tdx/tdx.h
> > index 13ce60df5684..502b670ea699 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/tdx/tdx.h
> > +++ b/tools/testing/selftests/kvm/include/x86_64/tdx/tdx.h
> > @@ -25,5 +25,7 @@ uint64_t tdg_vp_vmcall_instruction_wrmsr(uint64_t ind=
ex, uint64_t value);
> >  uint64_t tdg_vp_vmcall_instruction_hlt(uint64_t interrupt_blocked_flag=
);
> >  uint64_t tdg_vp_vmcall_ve_request_mmio_read(uint64_t address, uint64_t=
 size,
> >                                       uint64_t *data_out);
> > +uint64_t tdg_vp_vmcall_ve_request_mmio_write(uint64_t address, uint64_=
t size,
> > +                                     uint64_t data_in);
> >
> >  #endif // SELFTEST_TDX_TDX_H
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx.c b/tools/t=
esting/selftests/kvm/lib/x86_64/tdx/tdx.c
> > index b19f07ebc0e7..f4afa09f7e3d 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx.c
> > @@ -143,3 +143,17 @@ uint64_t tdg_vp_vmcall_ve_request_mmio_read(uint64=
_t address, uint64_t size,
> >
> >       return ret;
> >  }
> > +
> > +uint64_t tdg_vp_vmcall_ve_request_mmio_write(uint64_t address, uint64_=
t size,
> > +                                     uint64_t data_in)
> > +{
> > +     struct tdx_hypercall_args args =3D {
> > +             .r11 =3D TDG_VP_VMCALL_VE_REQUEST_MMIO,
> > +             .r12 =3D size,
> > +             .r13 =3D TDG_VP_VMCALL_VE_REQUEST_MMIO_WRITE,
> > +             .r14 =3D address,
> > +             .r15 =3D data_in,
> > +     };
> > +
> > +     return __tdx_hypercall(&args, 0);
> > +}
> > diff --git a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c b/tools/=
testing/selftests/kvm/x86_64/tdx_vm_tests.c
> > index 48902b69d13e..5e28ba828a92 100644
> > --- a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
> > +++ b/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
> > @@ -885,6 +885,90 @@ void verify_mmio_reads(void)
> >       printf("\t ... PASSED\n");
> >  }
> >
> > +void guest_mmio_writes(void)
> > +{
> > +     uint64_t ret;
> > +
> > +     ret =3D tdg_vp_vmcall_ve_request_mmio_write(TDX_MMIO_TEST_ADDR, 1=
, 0x12);
> > +     if (ret)
> > +             tdx_test_fatal(ret);
> > +
> > +     ret =3D tdg_vp_vmcall_ve_request_mmio_write(TDX_MMIO_TEST_ADDR, 2=
, 0x1234);
> > +     if (ret)
> > +             tdx_test_fatal(ret);
> > +
> > +     ret =3D tdg_vp_vmcall_ve_request_mmio_write(TDX_MMIO_TEST_ADDR, 4=
, 0x12345678);
> > +     if (ret)
> > +             tdx_test_fatal(ret);
> > +
> > +     ret =3D tdg_vp_vmcall_ve_request_mmio_write(TDX_MMIO_TEST_ADDR, 8=
, 0x1234567890ABCDEF);
> > +     if (ret)
> > +             tdx_test_fatal(ret);
> > +
> > +     // Write across page boundary.
> > +     ret =3D tdg_vp_vmcall_ve_request_mmio_write(PAGE_SIZE - 1, 8, 0);
> > +     if (ret)
> > +             tdx_test_fatal(ret);
> > +
> > +     tdx_test_success();
> > +}
> > +
> > +/*
> > + * Varifies guest MMIO writes.
> > + */
> > +void verify_mmio_writes(void)
> > +{
> > +     struct kvm_vm *vm;
> > +     struct kvm_vcpu *vcpu;
> > +
> > +     uint8_t byte_1;
> > +     uint16_t byte_2;
> > +     uint32_t byte_4;
> > +     uint64_t byte_8;
> > +
> > +     vm =3D td_create();
> > +     td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
> > +     vcpu =3D td_vcpu_add(vm, 0, guest_mmio_writes);
> > +     td_finalize(vm);
> > +
> > +     printf("Verifying TD MMIO writes:\n");
> > +
> > +     td_vcpu_run(vcpu);
> > +     TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
> > +     TDX_TEST_ASSERT_MMIO(vcpu, TDX_MMIO_TEST_ADDR, 1, TDG_VP_VMCALL_V=
E_REQUEST_MMIO_WRITE);
> > +     byte_1 =3D *(uint8_t *)(vcpu->run->mmio.data);
> > +
> > +     td_vcpu_run(vcpu);
> > +     TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
> > +     TDX_TEST_ASSERT_MMIO(vcpu, TDX_MMIO_TEST_ADDR, 2, TDG_VP_VMCALL_V=
E_REQUEST_MMIO_WRITE);
> > +     byte_2 =3D *(uint16_t *)(vcpu->run->mmio.data);
> > +
> > +     td_vcpu_run(vcpu);
> > +     TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
> > +     TDX_TEST_ASSERT_MMIO(vcpu, TDX_MMIO_TEST_ADDR, 4, TDG_VP_VMCALL_V=
E_REQUEST_MMIO_WRITE);
> > +     byte_4 =3D *(uint32_t *)(vcpu->run->mmio.data);
> > +
> > +     td_vcpu_run(vcpu);
> > +     TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
> > +     TDX_TEST_ASSERT_MMIO(vcpu, TDX_MMIO_TEST_ADDR, 8, TDG_VP_VMCALL_V=
E_REQUEST_MMIO_WRITE);
> > +     byte_8 =3D *(uint64_t *)(vcpu->run->mmio.data);
> > +
> > +     TEST_ASSERT_EQ(byte_1, 0x12);
> > +     TEST_ASSERT_EQ(byte_2, 0x1234);
> > +     TEST_ASSERT_EQ(byte_4, 0x12345678);
> > +     TEST_ASSERT_EQ(byte_8, 0x1234567890ABCDEF);
> > +
> > +     td_vcpu_run(vcpu);
> > +     TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_SYSTEM_EVENT);
> > +     TEST_ASSERT_EQ(vcpu->run->system_event.data[1], TDG_VP_VMCALL_INV=
ALID_OPERAND);
> Is it possible that this event is caused by an failure of the last 8 byte=
 write?
> i.e. though MMIO exit to host with correct value 0x1234567890ABCDEF, but =
guest
> sees ret as TDG_VP_VMCALL_INVALID_OPERAND.
>
> And if, coincidently, guest gets a ret=3D0 in the next across page bounda=
ry write,
> the selftest will show "PASSED", which is not right.
>
We can add another tdx_test_report_to_user_space to synchronize
between guest and host execution making sure that the guest is done
with all the valid writes before testing the negative case.
>
> > +     td_vcpu_run(vcpu);
> > +     TDX_TEST_ASSERT_SUCCESS(vcpu);
> > +
> > +     kvm_vm_free(vm);
> > +     printf("\t ... PASSED\n");
> > +}
> > +
> >  int main(int argc, char **argv)
> >  {
> >       setbuf(stdout, NULL);
> > @@ -905,6 +989,7 @@ int main(int argc, char **argv)
> >       run_in_new_process(&verify_guest_msr_reads);
> >       run_in_new_process(&verify_guest_hlt);
> >       run_in_new_process(&verify_mmio_reads);
> > +     run_in_new_process(&verify_mmio_writes);
> >
> >       return 0;
> >  }
> > --
> > 2.43.0.472.g3155946c3a-goog
> >
> >

