Return-Path: <kvm+bounces-65901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 80DC7CB9FA6
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 23:44:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F2D77309F090
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 22:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E4B72DE70D;
	Fri, 12 Dec 2025 22:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jkFOBrfa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0569224249
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 22:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765579372; cv=pass; b=HtJgVFHIRaBvtfL6Zt+gHzytJeTE7CFh9kWwSIFG5sLsGfDerCBIV4GyOM7aZHFeGxw6rfo2GNz5Unz/att3kScBPMQ7oFjpbod8Sby3ECu3rnRGjL3CTutUmaiEyia8w6e4vqd+t3sWrHQCFgT111EB2E/1uplEADGI0Jzhl+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765579372; c=relaxed/simple;
	bh=YOqs0y1dcE5aW9PtDdEhj4UaUFEQubxbJwDSGVsK6mc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J4BjM46X0GkKQ45jbyzTYeSIl0icZYFsHRWUm3lsB17I/neWKlRMDLz+EL2DBEX4oUUJNiUKwbto44cTn0CM1MYqIQgRV8wXwmYVR/+6ySfPyVvnE/8lz4zoSaAhtJPl2UYfqjMGsrBlQdi8OKE1Ih+n96HeZq87nnjSTCg2YC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jkFOBrfa; arc=pass smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4779e2ac121so198385e9.1
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 14:42:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765579369; cv=none;
        d=google.com; s=arc-20240605;
        b=NzMByvulLhJOkVoHhUUTw9mSn3Z3WVxXJr58Ma4fiNfph4/PHDiHvDdIEdC0uaG4T6
         6D0ACLRysYL3w7jvE67ojDN+JiJEAuQRXgsH3Yn6WEryC/drtlu7kIXFQ0VO6zX9i4O+
         r06pzU9IrNE2oWWBHIsAai6RBTWT/FqhlcaqF23cZpwKPeOQbPCrZ9R2cvHqcl0q8Qgw
         HeHlcv1bdtY/tH20dIhy3Q+0d3g6t5k2gydJAz/1/XkadgyIpDEZOFIZS+9E77qPdCYz
         pQjpRaZhqA2dFqniq4jAHDoodxN8Ek9epwdAXa0v/ngvKSs7jG5YloXBt9FlyknZjyaV
         K1DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GCLPUx88ZdHJmS22/LgzBzk06kvYjDGU5Iph4HFcUyk=;
        fh=AfR2sBriLyqsuMuqpG8C6xZ1vOqqdCkqsCFdNSplAoI=;
        b=NAECb7irW24eh7uHPv/shOF5fEe1E3WMiLW7/J5LbyqQtqRHFXgXXVxPN+hyzHKDpV
         XfPlru/veqekR2fMEcxa1w4OJu8bVl+aKkpGhviJTPejZ11oNQmnbZV6nDQENJgU6qVC
         Em3lka3++JP3TGEpcQoViHtj1KnRZFt9JNwWMgv2qGj1RBkLd1ZMQTz8cGtpacT0CPHg
         XpeptT4d8GBaxUSbKraExf6+ypfD3fPgFTYrldexVV8dmjeoL7zu27e97BoatMLQ2NFo
         PSEqz3nXUPscgZX5uCIIt+MUbbbaZZqPRp2k2vSDxYo6q4aNCher6ZnRSdFZcWJwSUR5
         Nqjg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765579369; x=1766184169; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GCLPUx88ZdHJmS22/LgzBzk06kvYjDGU5Iph4HFcUyk=;
        b=jkFOBrfaWg1+RgIZ0WUBN0/QPp9sk4JmqkjaQxaMY/ejTCHZEqksiF2kzdhI4g2VJo
         z0RCtjTBmj4DX/DhHF43Aty4wnaJ+pWXgLfKjU9wd8Wv/rMcbRkhWdP6E8cJQJ8VDpa3
         PtfasN95ZbEnv0thT4osg8XBfFMLttGdd+E9E9g1ecFwha6FXiOcW8pc+Yvx4vyCNu+I
         Qegw3dmwQZe7p/Z/+GoXgN9N+FOSzJgfdq8Gaq/XTsiPWVsv+D2/xU5TRXYAwr8dT2fl
         L0eQ7updJuBkfrtM+0aArNNpJG88nuZ4QG2iKCXhXcT9zcF275IG1KRofKyRkcoKB8Zb
         BCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765579369; x=1766184169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GCLPUx88ZdHJmS22/LgzBzk06kvYjDGU5Iph4HFcUyk=;
        b=OBm3yFQS6OOlhIz/rUpdQdG4oQcNGiUq2et+PQyHepLmWQsrMplRts8qOtjsb5D4nu
         OEibCJHby2KxLWQ0348dLh/Z1XEvFe43IlaWaAmCnrarl4LI6/JE8QjUrL1C57s4BiYL
         sDfHQQzh0nJtzSfet76BjFDMs3tB+ZrqNOw6c22w1iTVpZptlsNmqfBoInCYa7znxVds
         uOg44vaLQs71F5Y3bN4NwUVip24up546dusthY5PqtK1IFBIaB9HJ3TpCYmx0sVzVTY+
         fM2KTnAOJ7sFyhokV/k8GyWTqrr+H6Z0o/bhb5VukqCiMdpKvssRQSrcaoVxw0xzmi9U
         2xQA==
X-Forwarded-Encrypted: i=1; AJvYcCVEPbCKjQYdEJj3W9nvWvxBXMX017aQ1M0CeY7YQsUJGAeHMdYjNVPoN6iWIk28qrFBNDA=@vger.kernel.org
X-Gm-Message-State: AOJu0YypE1Zqu85NFqLc81skETkTKiWlVmwRzjmKGNFhBMgd/Xub8Fz/
	0fB1LEn4f/FYnpuUz5JgB1AoU4l7sx6LjYpGM+v/P6lSxP+KTTSfnDPrTKVa/lsZ8hBYXL7uo4W
	YtZXUw2+k2uQBp1dy9NF/Qpr9CmdCs+u9hUnAM1Wo
X-Gm-Gg: AY/fxX6oNhLYbd/5BJHT5uuUt23YJlwOOkAbqwSWSHlcqw1BPLD4IvSN+cFYTH133kJ
	cPPCjCJ6M4GtCSD+/2yKNZp4fYAF4k4BjUuEOE2hWA+aeFTQ6BZEMXSDdoO+jXvif7ow/eOlpFi
	ybFMfdO9TsTZ6++uwSylyaVGClVawm5qE/JX+ZNRvb1haHewGmYZTOSbIFBVbqtpQJUUTuIEJey
	ygH6WNPohqmY9f6lSMCNI1p2fQReO8xlF7PJWa/0wlld6kDUx0KtP0gBjrUiCNEWAWwqr7Zfyrg
	n+jm2rDg/8TWpXodBr1JpVleCt9t
X-Google-Smtp-Source: AGHT+IGycUDLgfiYo6g1zTqU/jgYJfkyvEbX43ygSbXNWZeJGMb236iTpZ88xPMSD0uFM0/wQUo7NV0Ahf4F4PzTuS8=
X-Received: by 2002:a05:600c:83c4:b0:477:86fd:fb18 with SMTP id
 5b1f17b1804b1-47a94869ebbmr337505e9.8.1765579369059; Fri, 12 Dec 2025
 14:42:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251013185903.1372553-1-jiaqiyan@google.com> <20251013185903.1372553-3-jiaqiyan@google.com>
 <3061f5f8-cef0-b7b1-c4de-f2ceea29af9a@huawei.com> <CACw3F51mRXCDz7Hd4Vve98NoskhB2cSc88zAGfd6Hwr4uCBxPA@mail.gmail.com>
 <dbcfb853-5853-5967-1bf9-76c6b3839717@huawei.com>
In-Reply-To: <dbcfb853-5853-5967-1bf9-76c6b3839717@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 12 Dec 2025 14:42:37 -0800
X-Gm-Features: AQt7F2rl2f5bneq6f6crNhZuIfA-M_NY1_crL-5oW0NtvHoqkZtXMaIozb_07o8
Message-ID: <CACw3F51FQwCLe17E4VC5wtpnCyuBOMrchvoBYCcwTxPkuxD+fg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] KVM: selftests: Test for KVM_EXIT_ARM_SEA
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, duenwen@google.com, 
	rananta@google.com, jthoughton@google.com, vsethi@nvidia.com, jgg@nvidia.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, 
	will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, shuah@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2025 at 1:22=E2=80=AFAM Zenghui Yu <yuzenghui@huawei.com> w=
rote:
>
> On 2025/12/12 9:53, Jiaqi Yan wrote:
> > On Thu, Dec 11, 2025 at 5:02=E2=80=AFAM Zenghui Yu <yuzenghui@huawei.co=
m> wrote:
> > >
> > > I can also hit this ASSERT with:
> > >
> > > Random seed: 0x6b8b4567
> > > # Mapped 0x40000 pages: gva=3D0x80000000 to gpa=3D0xff80000000
> > > # Before EINJect: data=3D0xbaadcafe
> > > # EINJ_GVA=3D0x81234bad, einj_gpa=3D0xff81234bad, einj_hva=3D0xffff41=
234bad,
> > > einj_hpa=3D0x2841234bad
> > > # echo 0x10 > /sys/kernel/debug/apei/einj/error_type - done
> > > # echo 0x2 > /sys/kernel/debug/apei/einj/flags - done
> > > # echo 0x2841234bad > /sys/kernel/debug/apei/einj/param1 - done
> > > # echo 0xffffffffffffffff > /sys/kernel/debug/apei/einj/param2 - done
> > > # echo 0x1 > /sys/kernel/debug/apei/einj/notrigger - done
> > > # echo 0x1 > /sys/kernel/debug/apei/einj/error_inject - done
> > > # Memory UER EINJected
> > > # Dump kvm_run info about KVM_EXIT_MMIO
> > > # kvm_run.arm_sea: esr=3D0xffff90ba0040, flags=3D0x691000
> > > # kvm_run.arm_sea: gva=3D0x100000008, gpa=3D0
> > > =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
> > >   arm64/sea_to_user.c:207: exit_reason =3D=3D (41)
> > >   pid=3D38023 tid=3D38023 errno=3D4 - Interrupted system call
> > >      1  0x0000000000402d1b: run_vm at sea_to_user.c:207
> > >      2  0x0000000000402467: main at sea_to_user.c:330
> > >      3  0x0000ffff9122b03f: ?? ??:0
> > >      4  0x0000ffff9122b117: ?? ??:0
> > >      5  0x00000000004026ef: _start at ??:?
> > >   Wanted KVM exit reason: 41 (ARM_SEA), got: 6 (MMIO)
> > >
> > > Not sure what's wrong it..
> >
> > Does your test machine have SDEI or SCI enabled for host APEI? Do you
> > see any kernel log from "Memory failure:" saying hugetlb page
> > recovered, and recovered significant earlier than the KVM exit here.
> > It maybe the kernel has already unmapped hugepage in response to SDEI
> > or SCI before this test actually consumes memory error, so no SEA is
> > actually triggered.
>
> No kernel log was printed when I saw this failure.

Hmm, and even no CPER logged by APEI/GHES? That makes me suspect the
error wasn't injected successfully.

In that case, I found a bug in sea_to_user.c: GUEST_FAIL is not
handled by run_vm and results in unhandled MMIO.

Here is a fix I tested on my side, with some other minor fixes. Do you
mind trying it?

commit b96a92d1006fbe2752ba133eb76b0c45c9c54265
Author: Jiaqi Yan <jiaqiyan@google.com>
Date:   Fri Dec 12 22:27:53 2025 +0000

    KVM: selftests: Improve sea_to_user test

    Several improvments to the test for KVM_EXIT_ARM_SEA:
    - refactor run_vm to catch GUEST_FAIL, instead of causing confusing
    kvm exit with unhandled MMIO
    - sync far_invalid to guest
    - exit with KSFT_SKIP or KSFT_FAIL when should

    Change-Id: I8b735de3b669297f0638bea2d32a0b36211f7f5c

diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c
b/tools/testing/selftests/kvm/arm64/sea_to_user.c
index 573dd790aeb8e..6fd3cd881b415 100644
--- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
+++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
@@ -98,11 +98,15 @@ static void write_einj_entry(const char
*einj_path, uint64_t val)

 static void inject_uer(uint64_t paddr)
 {
-       if (access("/sys/firmware/acpi/tables/EINJ", R_OK) =3D=3D -1)
-               ksft_test_result_skip("EINJ table no available in firmware"=
);
+       if (access("/sys/firmware/acpi/tables/EINJ", R_OK) =3D=3D -1) {
+               ksft_test_result_skip("EINJ table not available in firmware=
\n");
+               exit(KSFT_SKIP);
+       }

-       if (access(EINJ_ETYPE, R_OK | W_OK) =3D=3D -1)
+       if (access(EINJ_ETYPE, R_OK | W_OK) =3D=3D -1) {
                ksft_test_result_skip("EINJ module probably not loaded?\n")=
;
+               exit(KSFT_SKIP);
+       }

        write_einj_entry(EINJ_ETYPE, ERROR_TYPE_MEMORY_UER);
        write_einj_entry(EINJ_FLAGS, MASK_MEMORY_UER);
@@ -123,12 +127,13 @@ static void sigbus_signal_handler(int sig,
siginfo_t *si, void *v)
        ksft_print_msg("SIGBUS (%d) received, dumping siginfo...\n", sig);
        ksft_print_msg("si_signo=3D%d, si_errno=3D%d, si_code=3D%d, si_addr=
=3D%p\n",
                       si->si_signo, si->si_errno, si->si_code, si->si_addr=
);
-       if (si->si_code =3D=3D BUS_MCEERR_AR)
+       if (si->si_code =3D=3D BUS_MCEERR_AR) {
                ksft_test_result_skip("SEA is claimed by host APEI\n");
-       else
+               exit(KSFT_SKIP);
+       } else {
                ksft_test_result_fail("Exit with signal unhandled\n");
-
-       exit(0);
+               exit(KSFT_FAIL);
+       }
 }

 static void setup_sigbus_handler(void)
@@ -158,7 +163,6 @@ static void expect_sea_handler(struct ex_regs *regs)
 {
        u64 esr =3D read_sysreg(esr_el1);
        u64 far =3D read_sysreg(far_el1);
-       bool expect_far_invalid =3D far_invalid;

        GUEST_PRINTF("Handling Guest SEA\n");
        GUEST_PRINTF("ESR_EL1=3D%#lx, FAR_EL1=3D%#lx\n", esr, far);
@@ -166,7 +170,7 @@ static void expect_sea_handler(struct ex_regs *regs)
        GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_CUR);
        GUEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);

-       if (expect_far_invalid) {
+       if (far_invalid) {
                GUEST_ASSERT_EQ(esr & ESR_ELx_FnV, ESR_ELx_FnV);
                GUEST_PRINTF("Guest observed garbage value in FAR\n");
        } else {
@@ -185,25 +189,19 @@ static void vcpu_inject_sea(struct kvm_vcpu *vcpu)
        vcpu_events_set(vcpu, &events);
 }

-static void run_vm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+static void validate_kvm_exit_arm_sea(struct kvm_vm *vm, struct kvm_vcpu *=
vcpu)
 {
-       struct ucall uc;
-       bool guest_done =3D false;
        struct kvm_run *run =3D vcpu->run;
        u64 esr;

-       /* Resume the vCPU after error injection to consume the error. */
-       vcpu_run(vcpu);
+       TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_SEA);

-       ksft_print_msg("Dump kvm_run info about KVM_EXIT_%s\n",
-                      exit_reason_str(run->exit_reason));
+       ksft_print_msg("Dumping kvm_run as arm_sea:\n");
        ksft_print_msg("kvm_run.arm_sea: esr=3D%#llx, flags=3D%#llx\n",
                       run->arm_sea.esr, run->arm_sea.flags);
        ksft_print_msg("kvm_run.arm_sea: gva=3D%#llx, gpa=3D%#llx\n",
                       run->arm_sea.gva, run->arm_sea.gpa);

-       TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_SEA);
-
        esr =3D run->arm_sea.esr;
        TEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_LOW);
        TEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);
@@ -211,39 +209,48 @@ static void run_vm(struct kvm_vm *vm, struct
kvm_vcpu *vcpu)
        TEST_ASSERT_EQ((esr & ESR_ELx_INST_SYNDROME), 0);
        TEST_ASSERT_EQ(esr & ESR_ELx_VNCR, 0);

-       if (!(esr & ESR_ELx_FnV)) {
-               ksft_print_msg("Expect gva to match given FnV bit is 0\n");
+       far_invalid =3D esr & ESR_ELx_FnV;
+       sync_global_to_guest(vm, far_invalid);
+
+       if (!far_invalid) {
+               ksft_print_msg("Expect gva to match\n");
                TEST_ASSERT_EQ(run->arm_sea.gva, EINJ_GVA);
        }

        if (run->arm_sea.flags & KVM_EXIT_ARM_SEA_FLAG_GPA_VALID) {
-               ksft_print_msg("Expect gpa to match given
KVM_EXIT_ARM_SEA_FLAG_GPA_VALID is set\n");
+               ksft_print_msg("Expect gpa to match\n");
                TEST_ASSERT_EQ(run->arm_sea.gpa, einj_gpa & PAGE_ADDR_MASK)=
;
        }
+}

-       far_invalid =3D esr & ESR_ELx_FnV;
-
-       /* Inject a SEA into guest and expect handled in SEA handler. */
-       vcpu_inject_sea(vcpu);
+static void run_vm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+       struct ucall uc;
+       bool guest_done =3D false;

        /* Expect the guest to reach GUEST_DONE gracefully. */
        do {
                vcpu_run(vcpu);
-               switch (get_ucall(vcpu, &uc)) {
-               case UCALL_PRINTF:
-                       ksft_print_msg("From guest: %s", uc.buffer);
-                       break;
-               case UCALL_DONE:
-                       ksft_print_msg("Guest done gracefully!\n");
-                       guest_done =3D 1;
-                       break;
-               case UCALL_ABORT:
-                       ksft_print_msg("Guest aborted!\n");
-                       guest_done =3D 1;
-                       REPORT_GUEST_ASSERT(uc);
-                       break;
-               default:
-                       TEST_FAIL("Unexpected ucall: %lu\n", uc.cmd);
+               if (vcpu->run->exit_reason =3D=3D KVM_EXIT_ARM_SEA) {
+                       validate_kvm_exit_arm_sea(vm, vcpu);
+                       vcpu_inject_sea(vcpu);
+               } else {
+                       switch (get_ucall(vcpu, &uc)) {
+                       case UCALL_PRINTF:
+                               ksft_print_msg("From guest: %s", uc.buffer)=
;
+                               break;
+                       case UCALL_DONE:
+                               ksft_print_msg("Guest done gracefully!\n");
+                               guest_done =3D 1;
+                               break;
+                       case UCALL_ABORT:
+                               ksft_print_msg("Guest aborted!\n");
+                               guest_done =3D 1;
+                               REPORT_GUEST_ASSERT(uc);
+                               break;
+                       default:
+                               TEST_FAIL("Unexpected ucall: %lu\n", uc.cmd=
);
+                       }
                }
        } while (!guest_done);
 }

>
> Thanks,
> Zenghui

