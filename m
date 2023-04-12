Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B8F6DFEB6
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 21:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjDLT1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 15:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjDLT1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 15:27:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548DD6181
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 12:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681327590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fk7frx7Q0Hw+X3uBa4tZdHWxv64cvAvwz6sWqL8gwxc=;
        b=MLh5aG9SpiLOBkMohI9H/LKALbugZ5xCaHuaO7JsMYXj0QkyZ0N6vkN/rrUJg6K3DO7kkZ
        yK7qVtsDHdQob4QcU6APJ/YiCLwGWRbWmlJ/TOYBAA82Nd4tpoDBsaQZptHwXFs9s3ztvJ
        Wg8WtGdzd0QEWrKi2m76LZVZtGjArOI=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-BOfeLgcMN3qYUUibhDlqOA-1; Wed, 12 Apr 2023 15:26:28 -0400
X-MC-Unique: BOfeLgcMN3qYUUibhDlqOA-1
Received: by mail-vs1-f72.google.com with SMTP id t6-20020a67d906000000b0042c91e8e2cbso729589vsj.23
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 12:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681327587; x=1683919587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fk7frx7Q0Hw+X3uBa4tZdHWxv64cvAvwz6sWqL8gwxc=;
        b=GkhcWreVKSx4A69f7qPDI6Qd+38dsist7utVi2Pk90Xv0SD7OevmsxaHpKUY72/Olm
         KB1iNPLXsfF26OfVTB6wQKsjgi2ILNwacPmlxmGNI//vkf9+46u1PXceJTboHp+dCT+L
         HD7Cce4OmcYG/DML7MBOdeoVc3AxnvmFRMwzMOUXWy4gWXiZe0Y7M7U1r3/6HzPwTXWc
         N2pEQhtF0fwz7uDxAk3ZKbSPF7s7kZD+GyqrAL9frE/SiTZ32tXHMwQsalpNySzeUNwp
         3f8u9PF/ltI3LmTkJLoJ2l4wX80vxqv1u4xfIIdJI8f1p0mkmoR0DuDoNr+u4Fb5AGT+
         qOeQ==
X-Gm-Message-State: AAQBX9cWxQBO+W4QneZM0L06I0l9bPToJ3sIY2tmxvINZrPUaaDbNdsz
        qFA+td/zuvQ0t2UqbYoFrsq3j5/Uz2OHhpCP9n8Q7ZHNTxOxFK3WGjBPDxCNCMMYf0sl79qe3d4
        vRFT64TTGTe9Eb02FBY4vs/bbCxVdgvsvbCMR
X-Received: by 2002:a67:e0da:0:b0:42c:c736:b832 with SMTP id m26-20020a67e0da000000b0042cc736b832mr30341vsl.1.1681327587681;
        Wed, 12 Apr 2023 12:26:27 -0700 (PDT)
X-Google-Smtp-Source: AKy350YEeq+WrR+r95DoHwR1fbJsfk2acups0RqQlqyDg7+hSNcQQACabEtfUYMknn8pnelQ+8gYoC/XGNTITKxUj1Y=
X-Received: by 2002:a67:e0da:0:b0:42c:c736:b832 with SMTP id
 m26-20020a67e0da000000b0042cc736b832mr30334vsl.1.1681327587359; Wed, 12 Apr
 2023 12:26:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230328050231.3008531-1-seanjc@google.com> <20230328050231.3008531-3-seanjc@google.com>
In-Reply-To: <20230328050231.3008531-3-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 12 Apr 2023 21:26:16 +0200
Message-ID: <CABgObfZQhQp3-S2HsF3dWiJykCwigAU9B_H8tf-nY6W9iDUxZg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 2/3] x86/msr: Add testcases for
 MSR_IA32_PRED_CMD and its IBPB command
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023 at 7:02=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Add test coverage to verify MSR_IA32_PRED_CMD is write-only, that it can
> be written with '0' (nop command) and '1' (IBPB command) when IBPB is
> supported by the CPU (SPEC_CTRL on Intel, IBPB on AMD), and that writing
> any other bit (1-63) triggers a #GP due to the bits/commands being
> reserved.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

I have a machine here (run-of-the-mill Skylake Xeon Gold) where
MSR_IA32_PRED_CMD does not fail for bits 1-63, so I am dropping that
bit.

Paolo

> ---
>  x86/msr.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> diff --git a/x86/msr.c b/x86/msr.c
> index 97cf5987..13cb6391 100644
> --- a/x86/msr.c
> +++ b/x86/msr.c
> @@ -85,6 +85,15 @@ static void test_msr_rw(u32 msr, const char *name, uns=
igned long long val)
>         __test_msr_rw(msr, name, val, 0);
>  }
>
> +static void test_wrmsr(u32 msr, const char *name, unsigned long long val=
)
> +{
> +       unsigned char vector =3D wrmsr_safe(msr, val);
> +
> +       report(!vector,
> +              "Expected success on WRSMR(%s, 0x%llx), got vector %d",
> +              name, val, vector);
> +}
> +
>  static void test_wrmsr_fault(u32 msr, const char *name, unsigned long lo=
ng val)
>  {
>         unsigned char vector =3D wrmsr_safe(msr, val);
> @@ -271,6 +280,23 @@ static void test_x2apic_msrs(void)
>         __test_x2apic_msrs(true);
>  }
>
> +static void test_cmd_msrs(void)
> +{
> +       int i;
> +
> +       test_rdmsr_fault(MSR_IA32_PRED_CMD, "PRED_CMD");
> +       if (this_cpu_has(X86_FEATURE_SPEC_CTRL) ||
> +           this_cpu_has(X86_FEATURE_AMD_IBPB)) {
> +               test_wrmsr(MSR_IA32_PRED_CMD, "PRED_CMD", 0);
> +               test_wrmsr(MSR_IA32_PRED_CMD, "PRED_CMD", PRED_CMD_IBPB);
> +       } else {
> +               test_wrmsr_fault(MSR_IA32_PRED_CMD, "PRED_CMD", 0);
> +               test_wrmsr_fault(MSR_IA32_PRED_CMD, "PRED_CMD", PRED_CMD_=
IBPB);
> +       }
> +       for (i =3D 1; i < 64; i++)
> +               test_wrmsr_fault(MSR_IA32_PRED_CMD, "PRED_CMD", BIT_ULL(i=
));
> +}
> +
>  int main(int ac, char **av)
>  {
>         /*
> @@ -283,6 +309,7 @@ int main(int ac, char **av)
>                 test_misc_msrs();
>                 test_mce_msrs();
>                 test_x2apic_msrs();
> +               test_cmd_msrs();
>         }
>
>         return report_summary();
> --
> 2.40.0.348.gf938b09366-goog
>

