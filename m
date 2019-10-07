Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD233CDEE4
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 12:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfJGKMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 06:12:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27239 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727411AbfJGKMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 06:12:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570443124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TDQsPDdwqfnlkmdpYjwG2YmmzePWDiIKlK9z4E1RNJ4=;
        b=ca+lvkNuCRyyHpbluxqcXq8sv5v8tGIkrH3mgySgVkXisbO4kD9/PSGLYeUPZT5uXWMBAy
        WMMQYjj7OsT+nBsHlzdT64dCoqg0E8wZBtSwjeJbs+R/Czf/TRaUDe9Wa3W1a70z69a4ma
        dCdc36AxDRUDV8FavrTIyOcPTvcjY2g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-G7_oq1q9OoSfKEHGoXGvrQ-1; Mon, 07 Oct 2019 06:12:00 -0400
Received: by mail-wr1-f72.google.com with SMTP id w2so7342277wrn.4
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 03:11:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i20BewS7uFdN8HMYZawpkUKebmHDspiyqT6Wq2XdTUY=;
        b=kDcQnXRPNlwXOIQO4dhTTQ2QmJOIcV5CBp/I7LiYA/z6QmmEWCMzYMMDX8GyV+UOy8
         Qp1izIJN3CLjbQdOFiggzT4OKyrjQfv4VTo2Cs/uk1p5ewLWN2hnh9PTyxx3rE8MzeYu
         Re0297Q1Ai7U7pUDQVtMIb08K+m4+eMybcpsA9mhdhzaZ+othhS9MuEE4MlBWd9qwtwV
         v8i4oewICh/1Cr6PJ2ejnxZjdNr0wDfP4efA/nKITgTUa9nl7YC85bLq9QmxBbM56SNO
         /+PJhi31jIYjt+QIpyeD8F9EWJ8bfE9ejOQy7GXLp3KxNUpHb8cPbVi2c9oxrmYtJOUr
         /eBA==
X-Gm-Message-State: APjAAAVb4+LIVYqJAnN3hCjTSPOj2TELJa2dGqxaP1/thFohFWChm4sL
        79XjooI6P98Az9q4mi0fLuK4RAbAlca/8rGMwlrakNDyagcKGA+q91MsA3ir+OfX6x1eQ5S+vog
        PPyPDzX55XQdO
X-Received: by 2002:adf:dc4b:: with SMTP id m11mr23433388wrj.269.1570443118499;
        Mon, 07 Oct 2019 03:11:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxtuTBs6lAZjwG2AhUBc42e0OSxA8i1K4oWyLwLkff63wKK49PZmRwNygNCOHA+Z2Z/g6xnYw==
X-Received: by 2002:adf:dc4b:: with SMTP id m11mr23433339wrj.269.1570443117791;
        Mon, 07 Oct 2019 03:11:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dd9:ce92:89b5:d1f2? ([2001:b07:6468:f312:9dd9:ce92:89b5:d1f2])
        by smtp.gmail.com with ESMTPSA id b186sm33753551wmd.16.2019.10.07.03.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 03:11:57 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Skip APIC-access address tests beyond
 mapped RAM
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20190910184916.50282-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <00538d63-1f71-e1ad-6517-66c7565b49d4@redhat.com>
Date:   Mon, 7 Oct 2019 12:12:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190910184916.50282-1-jmattson@google.com>
Content-Language: en-US
X-MC-Unique: G7_oq1q9OoSfKEHGoXGvrQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/09/19 20:49, Jim Mattson wrote:
> We no longer have any tests in vmx_tests.c that use
> xfail_beyond_mapped_ram. However, an upcoming change to kvm will exit
> to userspace with a kvm internal error whenever launching a nested VM
> with the vmcs12 APIC-access address set to a non-cacheable address in
> L1. Reuse the xfail_beyond_mapped_ram plumbing to support
> skip_beyond_mapped_ram, and skip any APIC-access address tests that
> use addresses beyond mapped RAM, so that the test won't induce a kvm
> internal error.
>=20
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  x86/vmx_tests.c | 289 +++++++++++++++++++++++-------------------------
>  1 file changed, 139 insertions(+), 150 deletions(-)
>=20
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index f035f24..5633823 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -3351,13 +3351,13 @@ success:
>  /*
>   * Try to launch the current VMCS.
>   */
> -static void test_vmx_vmlaunch(u32 xerror, bool xfail)
> +static void test_vmx_vmlaunch(u32 xerror)
>  {
>  =09bool success =3D vmlaunch_succeeds();
>  =09u32 vmx_inst_err;
> =20
> -=09report_xfail("vmlaunch %s", xfail, success =3D=3D !xerror,
> -=09=09     !xerror ? "succeeds" : "fails");
> +=09report("vmlaunch %s", success =3D=3D !xerror,
> +=09       !xerror ? "succeeds" : "fails");
>  =09if (!success && xerror) {
>  =09=09vmx_inst_err =3D vmcs_read(VMX_INST_ERROR);
>  =09=09report("VMX inst error is %d (actual %d)",
> @@ -3365,14 +3365,14 @@ static void test_vmx_vmlaunch(u32 xerror, bool xf=
ail)
>  =09}
>  }
> =20
> -static void test_vmx_invalid_controls(bool xfail)
> +static void test_vmx_invalid_controls(void)
>  {
> -=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_CONTROL_FIELD, xfail);
> +=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_CONTROL_FIELD);
>  }
> =20
> -static void test_vmx_valid_controls(bool xfail)
> +static void test_vmx_valid_controls(void)
>  {
> -=09test_vmx_vmlaunch(0, xfail);
> +=09test_vmx_vmlaunch(0);
>  }
> =20
>  /*
> @@ -3410,9 +3410,9 @@ static void test_rsvd_ctl_bit_value(const char *nam=
e, union vmx_ctrl_msr msr,
>  =09=09expected =3D !(msr.set & mask);
>  =09}
>  =09if (expected)
> -=09=09test_vmx_valid_controls(false);
> +=09=09test_vmx_valid_controls();
>  =09else
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09vmcs_write(encoding, controls);
>  =09report_prefix_pop();
>  }
> @@ -3509,9 +3509,9 @@ static void try_cr3_target_count(unsigned i, unsign=
ed max)
>  =09report_prefix_pushf("CR3 target count 0x%x", i);
>  =09vmcs_write(CR3_TARGET_COUNT, i);
>  =09if (i <=3D max)
> -=09=09test_vmx_valid_controls(false);
> +=09=09test_vmx_valid_controls();
>  =09else
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
>  }
> =20
> @@ -3546,23 +3546,21 @@ static void test_vmcs_addr(const char *name,
>  =09=09=09   enum Encoding encoding,
>  =09=09=09   u64 align,
>  =09=09=09   bool ignored,
> -=09=09=09   bool xfail_beyond_mapped_ram,
> +=09=09=09   bool skip_beyond_mapped_ram,
>  =09=09=09   u64 addr)
>  {
> -=09bool xfail =3D
> -=09=09(xfail_beyond_mapped_ram &&
> -=09=09 addr > fwcfg_get_u64(FW_CFG_RAM_SIZE) - align &&
> -=09=09 addr < (1ul << cpuid_maxphyaddr()));
> -
>  =09report_prefix_pushf("%s =3D %lx", name, addr);
>  =09vmcs_write(encoding, addr);
> -=09if (ignored || (IS_ALIGNED(addr, align) &&
> +=09if (skip_beyond_mapped_ram &&
> +=09    addr > fwcfg_get_u64(FW_CFG_RAM_SIZE) - align &&
> +=09    addr < (1ul << cpuid_maxphyaddr()))
> +=09=09printf("Skipping physical address beyond mapped RAM\n");
> +=09else if (ignored || (IS_ALIGNED(addr, align) &&
>  =09    addr < (1ul << cpuid_maxphyaddr())))
> -=09=09test_vmx_valid_controls(xfail);
> +=09=09test_vmx_valid_controls();
>  =09else
> -=09=09test_vmx_invalid_controls(xfail);
> +=09=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> -=09xfail =3D false;
>  }
> =20
>  /*
> @@ -3572,7 +3570,7 @@ static void test_vmcs_addr_values(const char *name,
>  =09=09=09=09  enum Encoding encoding,
>  =09=09=09=09  u64 align,
>  =09=09=09=09  bool ignored,
> -=09=09=09=09  bool xfail_beyond_mapped_ram,
> +=09=09=09=09  bool skip_beyond_mapped_ram,
>  =09=09=09=09  u32 bit_start, u32 bit_end)
>  {
>  =09unsigned i;
> @@ -3580,17 +3578,17 @@ static void test_vmcs_addr_values(const char *nam=
e,
> =20
>  =09for (i =3D bit_start; i <=3D bit_end; i++)
>  =09=09test_vmcs_addr(name, encoding, align, ignored,
> -=09=09=09       xfail_beyond_mapped_ram, 1ul << i);
> +=09=09=09       skip_beyond_mapped_ram, 1ul << i);
> =20
>  =09test_vmcs_addr(name, encoding, align, ignored,
> -=09=09       xfail_beyond_mapped_ram, PAGE_SIZE - 1);
> +=09=09       skip_beyond_mapped_ram, PAGE_SIZE - 1);
>  =09test_vmcs_addr(name, encoding, align, ignored,
> -=09=09       xfail_beyond_mapped_ram, PAGE_SIZE);
> +=09=09       skip_beyond_mapped_ram, PAGE_SIZE);
>  =09test_vmcs_addr(name, encoding, align, ignored,
> -=09=09       xfail_beyond_mapped_ram,
> +=09=09       skip_beyond_mapped_ram,
>  =09=09      (1ul << cpuid_maxphyaddr()) - PAGE_SIZE);
>  =09test_vmcs_addr(name, encoding, align, ignored,
> -=09=09       xfail_beyond_mapped_ram, -1ul);
> +=09=09       skip_beyond_mapped_ram, -1ul);
> =20
>  =09vmcs_write(encoding, orig_val);
>  }
> @@ -3602,7 +3600,7 @@ static void test_vmcs_addr_values(const char *name,
>  static void test_vmcs_addr_reference(u32 control_bit, enum Encoding fiel=
d,
>  =09=09=09=09     const char *field_name,
>  =09=09=09=09     const char *control_name, u64 align,
> -=09=09=09=09     bool xfail_beyond_mapped_ram,
> +=09=09=09=09     bool skip_beyond_mapped_ram,
>  =09=09=09=09     bool control_primary)
>  {
>  =09u32 primary =3D vmcs_read(CPU_EXEC_CTRL0);
> @@ -3628,7 +3626,7 @@ static void test_vmcs_addr_reference(u32 control_bi=
t, enum Encoding field,
>  =09}
> =20
>  =09test_vmcs_addr_values(field_name, field, align, false,
> -=09=09=09      xfail_beyond_mapped_ram, 0, 63);
> +=09=09=09      skip_beyond_mapped_ram, 0, 63);
>  =09report_prefix_pop();
> =20
>  =09report_prefix_pushf("%s disabled", control_name);
> @@ -3716,7 +3714,7 @@ static void test_apic_access_addr(void)
>  =09test_vmcs_addr_reference(CPU_VIRT_APIC_ACCESSES, APIC_ACCS_ADDR,
>  =09=09=09=09 "APIC-access address",
>  =09=09=09=09 "virtualize APIC-accesses", PAGE_SIZE,
> -=09=09=09=09 false, false);
> +=09=09=09=09 true, false);
>  }
> =20
>  static bool set_bit_pattern(u8 mask, u32 *secondary)
> @@ -3789,9 +3787,9 @@ static void test_apic_virtual_ctls(void)
>  =09=09=09report_prefix_pushf("Use TPR shadow %s, virtualize x2APIC mode =
%s, APIC-register virtualization %s, virtual-interrupt delivery %s",
>  =09=09=09=09str, (secondary & CPU_VIRT_X2APIC) ? "enabled" : "disabled",=
 (secondary & CPU_APIC_REG_VIRT) ? "enabled" : "disabled", (secondary & CPU=
_VINTD) ? "enabled" : "disabled");
>  =09=09=09if (ctrl)
> -=09=09=09=09test_vmx_valid_controls(false);
> +=09=09=09=09test_vmx_valid_controls();
>  =09=09=09else
> -=09=09=09=09test_vmx_invalid_controls(false);
> +=09=09=09=09test_vmx_invalid_controls();
>  =09=09=09report_prefix_pop();
>  =09=09}
> =20
> @@ -3818,22 +3816,22 @@ static void test_apic_virtual_ctls(void)
>  =09secondary &=3D ~CPU_VIRT_APIC_ACCESSES;
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary & ~CPU_VIRT_X2APIC);
>  =09report_prefix_pushf("Virtualize x2APIC mode disabled; virtualize APIC=
 access disabled");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary | CPU_VIRT_APIC_ACCESSES);
>  =09report_prefix_pushf("Virtualize x2APIC mode disabled; virtualize APIC=
 access enabled");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary | CPU_VIRT_X2APIC);
>  =09report_prefix_pushf("Virtualize x2APIC mode enabled; virtualize APIC =
access enabled");
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary & ~CPU_VIRT_APIC_ACCESSES);
>  =09report_prefix_pushf("Virtualize x2APIC mode enabled; virtualize APIC =
access disabled");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(CPU_EXEC_CTRL0, saved_primary);
> @@ -3862,22 +3860,22 @@ static void test_virtual_intr_ctls(void)
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary & ~CPU_VINTD);
>  =09vmcs_write(PIN_CONTROLS, pin & ~PIN_EXTINT);
>  =09report_prefix_pushf("Virtualize interrupt-delivery disabled; external=
-interrupt exiting disabled");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary | CPU_VINTD);
>  =09report_prefix_pushf("Virtualize interrupt-delivery enabled; external-=
interrupt exiting disabled");
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(PIN_CONTROLS, pin | PIN_EXTINT);
>  =09report_prefix_pushf("Virtualize interrupt-delivery enabled; external-=
interrupt exiting enabled");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(PIN_CONTROLS, pin & ~PIN_EXTINT);
>  =09report_prefix_pushf("Virtualize interrupt-delivery enabled; external-=
interrupt exiting disabled");
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(CPU_EXEC_CTRL0, saved_primary);
> @@ -3890,9 +3888,9 @@ static void test_pi_desc_addr(u64 addr, bool ctrl)
>  =09vmcs_write(POSTED_INTR_DESC_ADDR, addr);
>  =09report_prefix_pushf("Process-posted-interrupts enabled; posted-interr=
upt-descriptor-address 0x%lx", addr);
>  =09if (ctrl)
> -=09=09test_vmx_valid_controls(false);
> +=09=09test_vmx_valid_controls();
>  =09else
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
>  }
> =20
> @@ -3937,37 +3935,37 @@ static void test_posted_intr(void)
>  =09secondary &=3D ~CPU_VINTD;
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary);
>  =09report_prefix_pushf("Process-posted-interrupts enabled; virtual-inter=
rupt-delivery disabled");
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09secondary |=3D CPU_VINTD;
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary);
>  =09report_prefix_pushf("Process-posted-interrupts enabled; virtual-inter=
rupt-delivery enabled");
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09exit_ctl &=3D ~EXI_INTA;
>  =09vmcs_write(EXI_CONTROLS, exit_ctl);
>  =09report_prefix_pushf("Process-posted-interrupts enabled; virtual-inter=
rupt-delivery enabled; acknowledge-interrupt-on-exit disabled");
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09exit_ctl |=3D EXI_INTA;
>  =09vmcs_write(EXI_CONTROLS, exit_ctl);
>  =09report_prefix_pushf("Process-posted-interrupts enabled; virtual-inter=
rupt-delivery enabled; acknowledge-interrupt-on-exit enabled");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09secondary &=3D ~CPU_VINTD;
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary);
>  =09report_prefix_pushf("Process-posted-interrupts enabled; virtual-inter=
rupt-delivery disabled; acknowledge-interrupt-on-exit enabled");
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09secondary |=3D CPU_VINTD;
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary);
>  =09report_prefix_pushf("Process-posted-interrupts enabled; virtual-inter=
rupt-delivery enabled; acknowledge-interrupt-on-exit enabled");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09/*
> @@ -3977,21 +3975,21 @@ static void test_posted_intr(void)
>  =09=09vec =3D (1ul << i);
>  =09=09vmcs_write(PINV, vec);
>  =09=09report_prefix_pushf("Process-posted-interrupts enabled; posted-int=
errupt-notification-vector %u", vec);
> -=09=09test_vmx_valid_controls(false);
> +=09=09test_vmx_valid_controls();
>  =09=09report_prefix_pop();
>  =09}
>  =09for (i =3D 8; i < 16; i++) {
>  =09=09vec =3D (1ul << i);
>  =09=09vmcs_write(PINV, vec);
>  =09=09report_prefix_pushf("Process-posted-interrupts enabled; posted-int=
errupt-notification-vector %u", vec);
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09=09report_prefix_pop();
>  =09}
> =20
>  =09vec &=3D ~(0xff << 8);
>  =09vmcs_write(PINV, vec);
>  =09report_prefix_pushf("Process-posted-interrupts enabled; posted-interr=
upt-notification-vector %u", vec);
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09/*
> @@ -4048,19 +4046,19 @@ static void test_vpid(void)
>  =09vmcs_write(CPU_EXEC_CTRL1, saved_secondary & ~CPU_VPID);
>  =09vmcs_write(VPID, vpid);
>  =09report_prefix_pushf("VPID disabled; VPID value %x", vpid);
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(CPU_EXEC_CTRL1, saved_secondary | CPU_VPID);
>  =09report_prefix_pushf("VPID enabled; VPID value %x", vpid);
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09for (i =3D 0; i < 16; i++) {
>  =09=09vpid =3D (short)1 << i;;
>  =09=09vmcs_write(VPID, vpid);
>  =09=09report_prefix_pushf("VPID enabled; VPID value %x", vpid);
> -=09=09test_vmx_valid_controls(false);
> +=09=09test_vmx_valid_controls();
>  =09=09report_prefix_pop();
>  =09}
> =20
> @@ -4088,9 +4086,9 @@ static void try_tpr_threshold_and_vtpr(unsigned thr=
eshold, unsigned vtpr)
>  =09report_prefix_pushf("TPR threshold 0x%x, VTPR.class 0x%x",
>  =09    threshold, (vtpr >> 4) & 0xf);
>  =09if (valid)
> -=09=09test_vmx_valid_controls(false);
> +=09=09test_vmx_valid_controls();
>  =09else
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
>  }
> =20
> @@ -4117,7 +4115,7 @@ static void test_invalid_event_injection(void)
>  =09=09=09    "RESERVED interruption type invalid [-]",
>  =09=09=09    ent_intr_info);
>  =09vmcs_write(ENT_INTR_INFO, ent_intr_info);
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09ent_intr_info =3D ent_intr_info_base | INTR_TYPE_EXT_INTR |
> @@ -4126,7 +4124,7 @@ static void test_invalid_event_injection(void)
>  =09=09=09    "RESERVED interruption type invalid [+]",
>  =09=09=09    ent_intr_info);
>  =09vmcs_write(ENT_INTR_INFO, ent_intr_info);
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09/* If the interruption type is other event, the vector is 0. */
> @@ -4135,7 +4133,7 @@ static void test_invalid_event_injection(void)
>  =09=09=09    "(OTHER EVENT && vector !=3D 0) invalid [-]",
>  =09=09=09    ent_intr_info);
>  =09vmcs_write(ENT_INTR_INFO, ent_intr_info);
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09/* If the interruption type is NMI, the vector is 2 (negative case). =
*/
> @@ -4143,7 +4141,7 @@ static void test_invalid_event_injection(void)
>  =09report_prefix_pushf("%s, VM-entry intr info=3D0x%x",
>  =09=09=09    "(NMI && vector !=3D 2) invalid [-]", ent_intr_info);
>  =09vmcs_write(ENT_INTR_INFO, ent_intr_info);
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09/* If the interruption type is NMI, the vector is 2 (positive case). =
*/
> @@ -4151,7 +4149,7 @@ static void test_invalid_event_injection(void)
>  =09report_prefix_pushf("%s, VM-entry intr info=3D0x%x",
>  =09=09=09    "(NMI && vector =3D=3D 2) valid [+]", ent_intr_info);
>  =09vmcs_write(ENT_INTR_INFO, ent_intr_info);
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09/*
> @@ -4163,7 +4161,7 @@ static void test_invalid_event_injection(void)
>  =09=09=09    "(HW exception && vector > 31) invalid [-]",
>  =09=09=09    ent_intr_info);
>  =09vmcs_write(ENT_INTR_INFO, ent_intr_info);
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09/*
> @@ -4183,7 +4181,7 @@ static void test_invalid_event_injection(void)
>  =09=09=09    ent_intr_info);
>  =09vmcs_write(GUEST_CR0, guest_cr0_save & ~X86_CR0_PE & ~X86_CR0_PG);
>  =09vmcs_write(ENT_INTR_INFO, ent_intr_info);
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09ent_intr_info =3D ent_intr_info_base | INTR_INFO_DELIVER_CODE_MASK |
> @@ -4193,7 +4191,7 @@ static void test_invalid_event_injection(void)
>  =09=09=09    ent_intr_info);
>  =09vmcs_write(GUEST_CR0, guest_cr0_save & ~X86_CR0_PE & ~X86_CR0_PG);
>  =09vmcs_write(ENT_INTR_INFO, ent_intr_info);
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09if (enable_unrestricted_guest())
> @@ -4206,7 +4204,7 @@ static void test_invalid_event_injection(void)
>  =09=09=09    ent_intr_info);
>  =09vmcs_write(GUEST_CR0, guest_cr0_save & ~X86_CR0_PE & ~X86_CR0_PG);
>  =09vmcs_write(ENT_INTR_INFO, ent_intr_info);
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09ent_intr_info =3D ent_intr_info_base | INTR_TYPE_HARD_EXCEPTION |
> @@ -4216,7 +4214,7 @@ static void test_invalid_event_injection(void)
>  =09=09=09    ent_intr_info);
>  =09vmcs_write(GUEST_CR0, guest_cr0_save | X86_CR0_PE);
>  =09vmcs_write(ENT_INTR_INFO, ent_intr_info);
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary_save);
> @@ -4238,7 +4236,7 @@ skip_unrestricted_guest:
>  =09=09report_prefix_pushf("VM-entry intr info=3D0x%x [-]",
>  =09=09=09=09    ent_intr_info);
>  =09=09vmcs_write(ENT_INTR_INFO, ent_intr_info);
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09=09report_prefix_pop();
>  =09}
>  =09report_prefix_pop();
> @@ -4272,7 +4270,7 @@ skip_unrestricted_guest:
>  =09=09report_prefix_pushf("VM-entry intr info=3D0x%x [-]",
>  =09=09=09=09    ent_intr_info);
>  =09=09vmcs_write(ENT_INTR_INFO, ent_intr_info);
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09=09report_prefix_pop();
> =20
>  =09=09/* Positive case */
> @@ -4284,7 +4282,7 @@ skip_unrestricted_guest:
>  =09=09report_prefix_pushf("VM-entry intr info=3D0x%x [+]",
>  =09=09=09=09    ent_intr_info);
>  =09=09vmcs_write(ENT_INTR_INFO, ent_intr_info);
> -=09=09test_vmx_valid_controls(false);
> +=09=09test_vmx_valid_controls();
>  =09=09report_prefix_pop();
>  =09}
>  =09report_prefix_pop();
> @@ -4299,7 +4297,7 @@ skip_unrestricted_guest:
>  =09=09report_prefix_pushf("VM-entry intr info=3D0x%x [-]",
>  =09=09=09=09    ent_intr_info);
>  =09=09vmcs_write(ENT_INTR_INFO, ent_intr_info);
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09=09report_prefix_pop();
>  =09}
>  =09report_prefix_pop();
> @@ -4319,7 +4317,7 @@ skip_unrestricted_guest:
>  =09=09report_prefix_pushf("VM-entry intr error=3D0x%x [-]",
>  =09=09=09=09    ent_intr_err);
>  =09=09vmcs_write(ENT_INTR_ERROR, ent_intr_err);
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09=09report_prefix_pop();
>  =09}
>  =09vmcs_write(ENT_INTR_ERROR, 0x00000000);
> @@ -4356,7 +4354,7 @@ skip_unrestricted_guest:
>  =09=09report_prefix_pushf("VM-entry intr length =3D 0x%x [-]",
>  =09=09=09=09    ent_intr_len);
>  =09=09vmcs_write(ENT_INST_LEN, ent_intr_len);
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09=09report_prefix_pop();
> =20
>  =09=09/* Instruction length set to 16 should fail */
> @@ -4364,7 +4362,7 @@ skip_unrestricted_guest:
>  =09=09report_prefix_pushf("VM-entry intr length =3D 0x%x [-]",
>  =09=09=09=09    ent_intr_len);
>  =09=09vmcs_write(ENT_INST_LEN, 0x00000010);
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09=09report_prefix_pop();
> =20
>  =09=09report_prefix_pop();
> @@ -4405,9 +4403,9 @@ static void try_tpr_threshold(unsigned threshold)
>  =09vmcs_write(TPR_THRESHOLD, threshold);
>  =09report_prefix_pushf("TPR threshold 0x%x, VTPR.class 0xf", threshold);
>  =09if (valid)
> -=09=09test_vmx_valid_controls(false);
> +=09=09test_vmx_valid_controls();
>  =09else
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09if (valid)
> @@ -4557,22 +4555,22 @@ static void test_nmi_ctrls(void)
> =20
>  =09vmcs_write(PIN_CONTROLS, test_pin_ctrls);
>  =09report_prefix_pushf("NMI-exiting disabled, virtual-NMIs disabled");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(PIN_CONTROLS, test_pin_ctrls | PIN_VIRT_NMI);
>  =09report_prefix_pushf("NMI-exiting disabled, virtual-NMIs enabled");
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(PIN_CONTROLS, test_pin_ctrls | (PIN_NMI | PIN_VIRT_NMI));
>  =09report_prefix_pushf("NMI-exiting enabled, virtual-NMIs enabled");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(PIN_CONTROLS, test_pin_ctrls | PIN_NMI);
>  =09report_prefix_pushf("NMI-exiting enabled, virtual-NMIs disabled");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09if (!(ctrl_cpu_rev[0].clr & CPU_NMI_WINDOW)) {
> @@ -4583,25 +4581,25 @@ static void test_nmi_ctrls(void)
>  =09vmcs_write(PIN_CONTROLS, test_pin_ctrls);
>  =09vmcs_write(CPU_EXEC_CTRL0, test_cpu_ctrls0 | CPU_NMI_WINDOW);
>  =09report_prefix_pushf("Virtual-NMIs disabled, NMI-window-exiting enable=
d");
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(PIN_CONTROLS, test_pin_ctrls);
>  =09vmcs_write(CPU_EXEC_CTRL0, test_cpu_ctrls0);
>  =09report_prefix_pushf("Virtual-NMIs disabled, NMI-window-exiting disabl=
ed");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(PIN_CONTROLS, test_pin_ctrls | (PIN_NMI | PIN_VIRT_NMI));
>  =09vmcs_write(CPU_EXEC_CTRL0, test_cpu_ctrls0 | CPU_NMI_WINDOW);
>  =09report_prefix_pushf("Virtual-NMIs enabled, NMI-window-exiting enabled=
");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(PIN_CONTROLS, test_pin_ctrls | (PIN_NMI | PIN_VIRT_NMI));
>  =09vmcs_write(CPU_EXEC_CTRL0, test_cpu_ctrls0);
>  =09report_prefix_pushf("Virtual-NMIs enabled, NMI-window-exiting disable=
d");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09/* Restore the controls to their original values */
> @@ -4616,9 +4614,9 @@ static void test_eptp_ad_bit(u64 eptp, bool ctrl)
>  =09report_prefix_pushf("Enable-EPT enabled; EPT accessed and dirty flag =
%s",
>  =09    (eptp & EPTP_AD_FLAG) ? "1": "0");
>  =09if (ctrl)
> -=09=09test_vmx_valid_controls(false);
> +=09=09test_vmx_valid_controls();
>  =09else
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  }
> @@ -4702,9 +4700,9 @@ static void test_ept_eptp(void)
>  =09=09report_prefix_pushf("Enable-EPT enabled; EPT memory type %lu",
>  =09=09    eptp & EPT_MEM_TYPE_MASK);
>  =09=09if (ctrl)
> -=09=09=09test_vmx_valid_controls(false);
> +=09=09=09test_vmx_valid_controls();
>  =09=09else
> -=09=09=09test_vmx_invalid_controls(false);
> +=09=09=09test_vmx_invalid_controls();
>  =09=09report_prefix_pop();
>  =09}
> =20
> @@ -4725,9 +4723,9 @@ static void test_ept_eptp(void)
>  =09=09report_prefix_pushf("Enable-EPT enabled; EPT page walk length %lu"=
,
>  =09=09    eptp & EPTP_PG_WALK_LEN_MASK);
>  =09=09if (ctrl)
> -=09=09=09test_vmx_valid_controls(false);
> +=09=09=09test_vmx_valid_controls();
>  =09=09else
> -=09=09=09test_vmx_invalid_controls(false);
> +=09=09=09test_vmx_invalid_controls();
>  =09=09report_prefix_pop();
>  =09}
> =20
> @@ -4765,9 +4763,9 @@ static void test_ept_eptp(void)
>  =09=09    (eptp >> EPTP_RESERV_BITS_SHIFT) &
>  =09=09    EPTP_RESERV_BITS_MASK);
>  =09=09if (i =3D=3D 0)
> -=09=09=09test_vmx_valid_controls(false);
> +=09=09=09test_vmx_valid_controls();
>  =09=09else
> -=09=09=09test_vmx_invalid_controls(false);
> +=09=09=09test_vmx_invalid_controls();
>  =09=09report_prefix_pop();
>  =09}
> =20
> @@ -4785,16 +4783,16 @@ static void test_ept_eptp(void)
>  =09=09report_prefix_pushf("Enable-EPT enabled; reserved bits [63:N] %lu"=
,
>  =09=09    (eptp >> maxphysaddr) & resv_bits_mask);
>  =09=09if (j < maxphysaddr)
> -=09=09=09test_vmx_valid_controls(false);
> +=09=09=09test_vmx_valid_controls();
>  =09=09else
> -=09=09=09test_vmx_invalid_controls(false);
> +=09=09=09test_vmx_invalid_controls();
>  =09=09report_prefix_pop();
>  =09}
> =20
>  =09secondary &=3D ~(CPU_EPT | CPU_URG);
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary);
>  =09report_prefix_pushf("Enable-EPT disabled, unrestricted-guest disabled=
");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09if (!(ctrl_cpu_rev[1].clr & CPU_URG))
> @@ -4803,20 +4801,20 @@ static void test_ept_eptp(void)
>  =09secondary |=3D CPU_URG;
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary);
>  =09report_prefix_pushf("Enable-EPT disabled, unrestricted-guest enabled"=
);
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09secondary |=3D CPU_EPT;
>  =09setup_dummy_ept();
>  =09report_prefix_pushf("Enable-EPT enabled, unrestricted-guest enabled")=
;
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  skip_unrestricted_guest:
>  =09secondary &=3D ~CPU_URG;
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary);
>  =09report_prefix_pushf("Enable-EPT enabled, unrestricted-guest disabled"=
);
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(CPU_EXEC_CTRL0, primary_saved);
> @@ -4853,25 +4851,25 @@ static void test_pml(void)
>  =09secondary &=3D ~(CPU_PML | CPU_EPT);
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary);
>  =09report_prefix_pushf("enable-PML disabled, enable-EPT disabled");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09secondary |=3D CPU_PML;
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary);
>  =09report_prefix_pushf("enable-PML enabled, enable-EPT disabled");
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09secondary |=3D CPU_EPT;
>  =09setup_dummy_ept();
>  =09report_prefix_pushf("enable-PML enabled, enable-EPT enabled");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09secondary &=3D ~CPU_PML;
>  =09vmcs_write(CPU_EXEC_CTRL1, secondary);
>  =09report_prefix_pushf("enable-PML disabled, enable EPT enabled");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09test_vmcs_addr_reference(CPU_PML, PMLADDR, "PML address", "PML",
> @@ -4905,25 +4903,25 @@ static void test_vmx_preemption_timer(void)
>  =09exit &=3D ~EXI_SAVE_PREEMPT;
>  =09vmcs_write(EXI_CONTROLS, exit);
>  =09report_prefix_pushf("enable-VMX-preemption-timer enabled, save-VMX-pr=
eemption-timer disabled");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09exit |=3D EXI_SAVE_PREEMPT;
>  =09vmcs_write(EXI_CONTROLS, exit);
>  =09report_prefix_pushf("enable-VMX-preemption-timer enabled, save-VMX-pr=
eemption-timer enabled");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09pin &=3D ~PIN_PREEMPT;
>  =09vmcs_write(PIN_CONTROLS, pin);
>  =09report_prefix_pushf("enable-VMX-preemption-timer disabled, save-VMX-p=
reemption-timer enabled");
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09report_prefix_pop();
> =20
>  =09exit &=3D ~EXI_SAVE_PREEMPT;
>  =09vmcs_write(EXI_CONTROLS, exit);
>  =09report_prefix_pushf("enable-VMX-preemption-timer disabled, save-VMX-p=
reemption-timer disabled");
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(PIN_CONTROLS, saved_pin);
> @@ -4983,7 +4981,7 @@ static void test_entry_msr_load(void)
>  =09=09vmcs_write(ENTER_MSR_LD_ADDR, tmp);
>  =09=09report_prefix_pushf("VM-entry MSR-load addr [4:0] %lx",
>  =09=09=09=09    tmp & 0xf);
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09=09report_prefix_pop();
>  =09}
> =20
> @@ -5005,16 +5003,16 @@ static void test_entry_msr_load(void)
>  =09=09=091ul << i;
>  =09=09vmcs_write(ENTER_MSR_LD_ADDR,
>  =09=09=09   tmp - (entry_msr_ld_cnt * 16 - 1));
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09}
> =20
>  =09vmcs_write(ENT_MSR_LD_CNT, 2);
>  =09vmcs_write(ENTER_MSR_LD_ADDR, (1ULL << cpuid_maxphyaddr()) - 16);
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09vmcs_write(ENTER_MSR_LD_ADDR, (1ULL << cpuid_maxphyaddr()) - 32);
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09vmcs_write(ENTER_MSR_LD_ADDR, (1ULL << cpuid_maxphyaddr()) - 48);
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  }
> =20
>  static void guest_state_test_main(void)
> @@ -5088,7 +5086,7 @@ static void test_exit_msr_store(void)
>  =09=09vmcs_write(EXIT_MSR_ST_ADDR, tmp);
>  =09=09report_prefix_pushf("VM-exit MSR-store addr [4:0] %lx",
>  =09=09=09=09    tmp & 0xf);
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09=09report_prefix_pop();
>  =09}
> =20
> @@ -5110,16 +5108,16 @@ static void test_exit_msr_store(void)
>  =09=09=091ul << i;
>  =09=09vmcs_write(EXIT_MSR_ST_ADDR,
>  =09=09=09   tmp - (exit_msr_st_cnt * 16 - 1));
> -=09=09test_vmx_invalid_controls(false);
> +=09=09test_vmx_invalid_controls();
>  =09}
> =20
>  =09vmcs_write(EXI_MSR_ST_CNT, 2);
>  =09vmcs_write(EXIT_MSR_ST_ADDR, (1ULL << cpuid_maxphyaddr()) - 16);
> -=09test_vmx_invalid_controls(false);
> +=09test_vmx_invalid_controls();
>  =09vmcs_write(EXIT_MSR_ST_ADDR, (1ULL << cpuid_maxphyaddr()) - 32);
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  =09vmcs_write(EXIT_MSR_ST_ADDR, (1ULL << cpuid_maxphyaddr()) - 48);
> -=09test_vmx_valid_controls(false);
> +=09test_vmx_valid_controls();
>  }
> =20
>  /*
> @@ -6616,12 +6614,12 @@ static void test_sysenter_field(u32 field, const =
char *name)
> =20
>  =09vmcs_write(field, NONCANONICAL);
>  =09report_prefix_pushf("%s non-canonical", name);
> -=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD, false);
> +=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(field, 0xffffffff);
>  =09report_prefix_pushf("%s canonical", name);
> -=09test_vmx_vmlaunch(0, false);
> +=09test_vmx_vmlaunch(0);
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(field, addr_saved);
> @@ -6640,10 +6638,9 @@ static void test_ctl_reg(const char *cr_name, u64 =
cr, u64 fixed0, u64 fixed1)
>  =09=09vmcs_write(cr, val);
>  =09report_prefix_pushf("%s %lx", cr_name, val);
>  =09if (val =3D=3D fixed0)
> -=09=09test_vmx_vmlaunch(0, false);
> +=09=09test_vmx_vmlaunch(0);
>  =09else
> -=09=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
> -=09=09=09=09  false);
> +=09=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>  =09report_prefix_pop();
> =20
>  =09for (i =3D 0; i < 64; i++) {
> @@ -6658,8 +6655,7 @@ static void test_ctl_reg(const char *cr_name, u64 c=
r, u64 fixed0, u64 fixed1)
>  =09=09=09report_prefix_pushf("%s %llx", cr_name,
>  =09=09=09=09=09=09cr_saved | (1ull << i));
>  =09=09=09test_vmx_vmlaunch(
> -=09=09=09=09=09VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
> -=09=09=09=09=09false);
> +=09=09=09=09VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>  =09=09=09report_prefix_pop();
>  =09=09}
> =20
> @@ -6669,8 +6665,7 @@ static void test_ctl_reg(const char *cr_name, u64 c=
r, u64 fixed0, u64 fixed1)
>  =09=09=09report_prefix_pushf("%s %llx", cr_name,
>  =09=09=09=09=09=09cr_saved & ~(1ull << i));
>  =09=09=09test_vmx_vmlaunch(
> -=09=09=09=09=09VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
> -=09=09=09=09=09false);
> +=09=09=09=09VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>  =09=09=09report_prefix_pop();
>  =09=09}
>  =09}
> @@ -6711,8 +6706,7 @@ static void test_host_ctl_regs(void)
>  =09=09cr3 =3D cr3_saved | (1ul << i);
>  =09=09vmcs_write(HOST_CR3, cr3);
>  =09=09report_prefix_pushf("HOST_CR3 %lx", cr3);
> -=09=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
> -=09=09=09=09  false);
> +=09=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>  =09=09report_prefix_pop();
>  =09}
> =20
> @@ -6733,14 +6727,14 @@ static void test_efer_bit(u32 fld, const char * f=
ld_name, u32 ctrl_fld,
>  =09vmcs_write(fld, efer);
>  =09report_prefix_pushf("%s bit turned off, %s %lx", efer_bit_name,
>  =09=09=09    fld_name, efer);
> -=09test_vmx_vmlaunch(0, false);
> +=09test_vmx_vmlaunch(0);
>  =09report_prefix_pop();
> =20
>  =09efer =3D efer_saved | efer_bit;
>  =09vmcs_write(fld, efer);
>  =09report_prefix_pushf("%s bit turned on, %s %lx", efer_bit_name,
>  =09=09=09    fld_name, efer);
> -=09test_vmx_vmlaunch(0, false);
> +=09test_vmx_vmlaunch(0);
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(ctrl_fld, ctrl_saved | ctrl_bit);
> @@ -6749,10 +6743,9 @@ static void test_efer_bit(u32 fld, const char * fl=
d_name, u32 ctrl_fld,
>  =09report_prefix_pushf("%s bit turned off, %s %lx", efer_bit_name,
>  =09=09=09    fld_name, efer);
>  =09if (host_addr_size)
> -=09=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
> -=09=09=09=09  false);
> +=09=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>  =09else
> -=09=09test_vmx_vmlaunch(0, false);
> +=09=09test_vmx_vmlaunch(0);
>  =09report_prefix_pop();
> =20
>  =09efer =3D efer_saved | efer_bit;
> @@ -6760,10 +6753,9 @@ static void test_efer_bit(u32 fld, const char * fl=
d_name, u32 ctrl_fld,
>  =09report_prefix_pushf("%s bit turned on, %s %lx", efer_bit_name,
>  =09=09=09    fld_name, efer);
>  =09if (host_addr_size)
> -=09=09test_vmx_vmlaunch(0, false);
> +=09=09test_vmx_vmlaunch(0);
>  =09else
> -=09=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
> -=09=09=09=09  false);
> +=09=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(ctrl_fld, ctrl_saved);
> @@ -6791,7 +6783,7 @@ static void test_efer(u32 fld, const char * fld_nam=
e, u32 ctrl_fld,
>  =09=09=09efer =3D efer_saved | (1ull << i);
>  =09=09=09vmcs_write(fld, efer);
>  =09=09=09report_prefix_pushf("%s %lx", fld_name, efer);
> -=09=09=09test_vmx_vmlaunch(0, false);
> +=09=09=09test_vmx_vmlaunch(0);
>  =09=09=09report_prefix_pop();
>  =09=09}
>  =09}
> @@ -6803,8 +6795,7 @@ static void test_efer(u32 fld, const char * fld_nam=
e, u32 ctrl_fld,
>  =09=09=09vmcs_write(fld, efer);
>  =09=09=09report_prefix_pushf("%s %lx", fld_name, efer);
>  =09=09=09test_vmx_vmlaunch(
> -=09=09=09=09VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
> -=09=09=09=09false);
> +=09=09=09=09VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>  =09=09=09report_prefix_pop();
>  =09=09}
>  =09}
> @@ -6868,7 +6859,7 @@ static void test_pat(u32 field, const char * field_=
name, u32 ctrl_field,
>  =09=09=09vmcs_write(field, val);
>  =09=09=09if (field =3D=3D HOST_PAT) {
>  =09=09=09=09report_prefix_pushf("%s %lx", field_name, val);
> -=09=09=09=09test_vmx_vmlaunch(0, false);
> +=09=09=09=09test_vmx_vmlaunch(0);
>  =09=09=09=09report_prefix_pop();
> =20
>  =09=09=09} else {=09// GUEST_PAT
> @@ -6895,7 +6886,7 @@ static void test_pat(u32 field, const char * field_=
name, u32 ctrl_field,
>  =09=09=09=09else
>  =09=09=09=09=09error =3D 0;
> =20
> -=09=09=09=09test_vmx_vmlaunch(error, false);
> +=09=09=09=09test_vmx_vmlaunch(error);
>  =09=09=09=09report_prefix_pop();
> =20
>  =09=09=09} else {=09// GUEST_PAT
> @@ -6981,9 +6972,9 @@ static void test_vmcs_field(u64 field, const char *=
field_name, u32 bit_start,
>  =09vmcs_write(field, tmp);
>  =09report_prefix_pushf("%s %lx", field_name, tmp);
>  =09if (valid_val)
> -=09=09test_vmx_vmlaunch(0, false);
> +=09=09test_vmx_vmlaunch(0);
>  =09else
> -=09=09test_vmx_vmlaunch(error, false);
> +=09=09test_vmx_vmlaunch(error);
>  =09report_prefix_pop();
> =20
>  =09for (i =3D bit_start; i <=3D bit_end; i =3D i + 2) {
> @@ -6995,9 +6986,9 @@ static void test_vmcs_field(u64 field, const char *=
field_name, u32 bit_start,
>  =09=09vmcs_write(field, tmp);
>  =09=09report_prefix_pushf("%s %lx", field_name, tmp);
>  =09=09if (valid_val)
> -=09=09=09test_vmx_vmlaunch(error, false);
> +=09=09=09test_vmx_vmlaunch(error);
>  =09=09else
> -=09=09=09test_vmx_vmlaunch(0, false);
> +=09=09=09test_vmx_vmlaunch(0);
>  =09=09report_prefix_pop();
>  =09}
> =20
> @@ -7011,19 +7002,17 @@ static void test_canonical(u64 field, const char =
* field_name)
> =20
>  =09report_prefix_pushf("%s %lx", field_name, addr);
>  =09if (is_canonical(addr)) {
> -=09=09test_vmx_vmlaunch(0, false);
> +=09=09test_vmx_vmlaunch(0);
>  =09=09report_prefix_pop();
> =20
>  =09=09addr =3D make_non_canonical(addr);
>  =09=09vmcs_write(field, addr);
>  =09=09report_prefix_pushf("%s %lx", field_name, addr);
> -=09=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
> -=09=09=09=09  false);
> +=09=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> =20
>  =09=09vmcs_write(field, addr_saved);
>  =09} else {
> -=09=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
> -=09=09=09=09  false);
> +=09=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>  =09}
>  =09report_prefix_pop();
>  }
> @@ -7076,14 +7065,14 @@ static void test_host_segment_regs(void)
>  =09vmcs_write(HOST_SEL_SS, 0);
>  =09if (exit_ctrl_saved & EXI_HOST_64) {
>  =09=09report_prefix_pushf("HOST_SEL_SS 0");
> -=09=09test_vmx_vmlaunch(0, false);
> +=09=09test_vmx_vmlaunch(0);
>  =09=09report_prefix_pop();
> =20
>  =09=09vmcs_write(EXI_CONTROLS, exit_ctrl_saved & ~EXI_HOST_64);
>  =09}
> =20
>  =09report_prefix_pushf("HOST_SEL_SS 0");
> -=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD, false);
> +=09test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>  =09report_prefix_pop();
> =20
>  =09vmcs_write(HOST_SEL_SS, selector_saved);
>=20

Applied, thanks.

Paolo

