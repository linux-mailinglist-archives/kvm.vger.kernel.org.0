Return-Path: <kvm+bounces-51674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17149AFB758
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 17:28:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 012E44A273E
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 15:28:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B7512E2EE4;
	Mon,  7 Jul 2025 15:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="19qgJSZZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C44288CA1
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 15:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751902125; cv=none; b=doAdWngSJ+HcANkouqmSHgFTiVDKzJhnhQZbX204iZnQ9Ywb8J9OOa83RdsixuX0otmfB8JjdFCQ86bK5Q0oRRA3K3ES5ljg1xS8bXLaSfAPYPTj8pE2hoGW0hvzRBIniaqdjYO23g/U1ssUvzC5c+MR0UyMAdxkzC59YzM9+5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751902125; c=relaxed/simple;
	bh=Bs0BYUn9/UoVk6PJ+MLEcNhBIx+z3uYMH3hgSRCU5jc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iY6I/nCOn8fpJsMwMywBUstGSaEFTl9WbZ30/zS/muB3SeNoCn0DoJqFjmDBl0jjGX/Xe7UHbcCKntUliQO59ih3eDMUDeHoO0tcCNixU5D6xR1NpKRDJ9TGLVMySvrKbqTB3rdjmlqHA6G70czNIwXQXMno9tc0oaZ2/t6k6wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=19qgJSZZ; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-531b4407cfbso1102584e0c.1
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 08:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1751902121; x=1752506921; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uOBN+MEsrfBI1z1kEY8yuWPFiZC3qr6VvY+Zt8xPU7Q=;
        b=19qgJSZZzQlHpjVUAqtyt/rIa/CdLVMAHLdycqBFt9NQbtvNjQUAFgfW5QsVE6U1B2
         duGuMemfQiTPT/Pn6EQdfOP5CIcHun5Fk83fyPycx2Z5K9JpD4X1myS4r7DF+lcPUx15
         5Q8F6Da5hR43QbLz07vJhrHsB85bwulGsVVvdigbNbc35KR1JBYuy15N77iahmrSqbf1
         qulQlNv/ntAlIBLrfjB1uXQix1L9HOK1FdU3RGlb9Mk7gcA8VC1e8W8OmLBOZQadKGB5
         4YOtPOoXM51F8XgUx/AcGczgHL+3jVxGIatkDxKBTBrkzu1vtQBWjh2iCmScrbgXeH5B
         PEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751902121; x=1752506921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uOBN+MEsrfBI1z1kEY8yuWPFiZC3qr6VvY+Zt8xPU7Q=;
        b=hCaO9cNsKcA0Ij0WAr9nyrZ/Su4loZ/dlw5EQbLWWaoxIi9e8OykceiK5qtujalCFx
         puLrKN9iqFuIVOVvLfnUn6ekKMO0tie9naC9mAgddQRBGaz/VfVTx+kDt72hg/sIuIG0
         p26YkTLOz+XI7IYNNSfN8dVYCKv+hY7mqviB6rDtwb5WUFg+9HBYR6oEa7rnfGwcK2wF
         NsE56Ukttbjyl4fIAY/dydrX1j3bE0nTMYQzRh+tyTLGlRskAsGSEm6tGMxbHX8eUljS
         FUNULRZCrOcusrzvsE4/tTMEw3CwtOv1tnMCL++z43n8fkgZniD6ylMeB8i2APNN5MCz
         ZmiQ==
X-Gm-Message-State: AOJu0Yz0Ehrr2xAAjycSRZMKDsfgwLTQz5nwyqLzAx4/9kcB7xkixBXm
	/Syb1iK/dCwoXy/wEQsDsve3NGkzHrlgKaj6nQkTJHNPpaTW5riUO37o/RsrjHl0Vm+j9OirkC7
	ohG8tBgIt4BXCfqX2EkBDRkmFazUmhtYrVQlQll78rQ==
X-Gm-Gg: ASbGnculQRfyTCpWQxBXTvi0dK+7IyVqUwKdbZ1YH/rKuz+V29SrI4BR4xAfQ+NxQ48
	KaXrwBSwFxUjAXj0+Tt6MKbmTK1AQrlasK1krPKgzbiAhPW7K2vfhfsbYk9vCq5ddQoBX/qw7Wn
	fISolreuyNY42KJOQesppuY6/Uw0aTT1REmcKCvUUI74qP
X-Google-Smtp-Source: AGHT+IHJmJTm54crwJdTYk+pQLPaupH+RQdu41Rnx8JFxP469hFA86WOBQzRO1FWmoeHxVf13yNYOh9E81QSPCKW2bU=
X-Received: by 2002:a05:6122:1d4f:b0:531:2afc:4628 with SMTP id
 71dfb90a1353d-5347e3c2d12mr8583310e0c.2.1751902121115; Mon, 07 Jul 2025
 08:28:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250704151254.100351-4-andrew.jones@linux.dev> <20250704151254.100351-6-andrew.jones@linux.dev>
In-Reply-To: <20250704151254.100351-6-andrew.jones@linux.dev>
From: Jesse Taube <jesse@rivosinc.com>
Date: Mon, 7 Jul 2025 08:28:30 -0700
X-Gm-Features: Ac12FXwPBXVUfNUBEC3RuwfXUX44Cm6B_LeFul2OMFGkkGFgmGVLqbEtxKTk35c
Message-ID: <CALSpo=YKMa142xhS8KSEenBLemaK6rqYKEd3FotQtCjpV5CciQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] riscv: Add kvmtool support
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	alexandru.elisei@arm.com, cleger@rivosinc.com, jamestiotio@gmail.com, 
	Atish Patra <atishp@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 4, 2025 at 8:13=E2=80=AFAM Andrew Jones <andrew.jones@linux.dev=
> wrote:
>
> arm/arm64 supports running tests with kvmtool as a first class citizen.
> Most the code to do that is in the common scripts, so just add the riscv
> specific bits needed to allow riscv to use kvmtool as a first class
> citizen too.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Jesse Taube <jesse@rivosinc.com>

> ---
>  README.md     |   7 ++--
>  configure     |  12 ++++--
>  riscv/efi/run |   6 +++
>  riscv/run     | 110 +++++++++++++++++++++++++++++++++++---------------
>  4 files changed, 96 insertions(+), 39 deletions(-)
>
> diff --git a/README.md b/README.md
> index 723ce04cd978..cbd8a9940ec4 100644
> --- a/README.md
> +++ b/README.md
> @@ -65,8 +65,8 @@ or:
>
>  to run them all.
>
> -All tests can be run using QEMU. On arm and arm64, tests can also be run=
 using
> -kvmtool.
> +All tests can be run using QEMU. On arm, arm64, riscv32, and riscv64 tes=
ts can
> +also be run using kvmtool.
>
>  By default the runner script searches for a suitable QEMU binary in the =
system.
>  To select a specific QEMU binary though, specify the QEMU=3Dpath/to/bina=
ry
> @@ -97,8 +97,7 @@ variable. kvmtool supports only kvm as the accelerator.
>
>  Check [x86/efi/README.md](./x86/efi/README.md).
>
> -On arm and arm64, this is only supported with QEMU; kvmtool cannot run t=
he
> -tests under UEFI.
> +This is only supported with QEMU; kvmtool cannot run the tests under UEF=
I.
>
>  # Tests configuration file
>
> diff --git a/configure b/configure
> index 470f9d7cdb3b..6d549d1ecb5b 100755
> --- a/configure
> +++ b/configure
> @@ -90,7 +90,7 @@ usage() {
>                                    selects the best value based on the ho=
st system and the
>                                    test configuration.
>             --target=3DTARGET        target platform that the tests will =
be running on (qemu or
> -                                  kvmtool, default is qemu) (arm/arm64 o=
nly)
> +                                  kvmtool, default is qemu) (arm/arm64 a=
nd riscv32/riscv64 only)
>             --cross-prefix=3DPREFIX  cross compiler prefix
>             --cc=3DCC                c compiler to use ($cc)
>             --cflags=3DFLAGS         extra options to be passed to the c =
compiler
> @@ -284,7 +284,8 @@ fi
>  if [ -z "$target" ]; then
>      target=3D"qemu"
>  else
> -    if [ "$arch" !=3D "arm64" ] && [ "$arch" !=3D "arm" ]; then
> +    if [ "$arch" !=3D "arm" ] && [ "$arch" !=3D "arm64" ] &&
> +       [ "$arch" !=3D "riscv32" ] && [ "$arch" !=3D "riscv64" ]; then

Are there plans to add i386 and x86_64 too?

>          echo "--target is not supported for $arch"
>          usage
>      fi
> @@ -393,6 +394,10 @@ elif [ "$arch" =3D "riscv32" ] || [ "$arch" =3D "ris=
cv64" ]; then
>      testdir=3Driscv
>      arch_libdir=3Driscv
>      : "${uart_early_addr:=3D0x10000000}"
> +    if [ "$target" !=3D "qemu" ] && [ "$target" !=3D "kvmtool" ]; then
> +        echo "--target must be one of 'qemu' or 'kvmtool'!"
> +        usage
> +    fi
>  elif [ "$arch" =3D "s390x" ]; then
>      testdir=3Ds390x
>  else
> @@ -519,7 +524,8 @@ EFI_DIRECT=3D$efi_direct
>  CONFIG_WERROR=3D$werror
>  GEN_SE_HEADER=3D$gen_se_header
>  EOF
> -if [ "$arch" =3D "arm" ] || [ "$arch" =3D "arm64" ]; then
> +if [ "$arch" =3D "arm" ] || [ "$arch" =3D "arm64" ] ||
> +   [ "$arch" =3D "riscv32" ] || [ "$arch" =3D "riscv64" ]; then
>      echo "TARGET=3D$target" >> config.mak
>  fi
>
> diff --git a/riscv/efi/run b/riscv/efi/run
> index 5a72683a6ef5..b9b75440c659 100755
> --- a/riscv/efi/run
> +++ b/riscv/efi/run
> @@ -11,6 +11,12 @@ if [ ! -f config.mak ]; then
>  fi
>  source config.mak
>  source scripts/arch-run.bash
> +source scripts/vmm.bash
> +
> +if [[ $(vmm_get_target) =3D=3D "kvmtool" ]]; then
> +       echo "kvmtool does not support EFI tests."
> +       exit 2
> +fi
>
>  if [ -f RISCV_VIRT_CODE.fd ]; then
>         DEFAULT_UEFI=3DRISCV_VIRT_CODE.fd
> diff --git a/riscv/run b/riscv/run
> index 0f000f0d82c6..7bcf235fb645 100755
> --- a/riscv/run
> +++ b/riscv/run
> @@ -10,35 +10,81 @@ if [ -z "$KUT_STANDALONE" ]; then
>         source scripts/vmm.bash
>  fi
>
> -# Allow user overrides of some config.mak variables
> -mach=3D$MACHINE_OVERRIDE
> -qemu_cpu=3D$TARGET_CPU_OVERRIDE
> -firmware=3D$FIRMWARE_OVERRIDE
> -
> -: "${mach:=3Dvirt}"
> -: "${qemu_cpu:=3D$TARGET_CPU}"
> -: "${qemu_cpu:=3D$DEFAULT_QEMU_CPU}"
> -: "${firmware:=3D$FIRMWARE}"
> -[ "$firmware" ] && firmware=3D"-bios $firmware"
> -
> -set_qemu_accelerator || exit $?
> -[ "$ACCEL" =3D "kvm" ] && QEMU_ARCH=3D$HOST
> -acc=3D"-accel $ACCEL$ACCEL_PROPS"
> -
> -qemu=3D$(search_qemu_binary) || exit $?
> -if [ "$mach" =3D 'virt' ] && ! $qemu -machine '?' | grep -q 'RISC-V Virt=
IO board'; then
> -       echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting.=
"
> -       exit 2
> -fi
> -mach=3D"-machine $mach"
> -
> -command=3D"$qemu -nodefaults -nographic -serial mon:stdio"
> -command+=3D" $mach $acc $firmware -cpu $qemu_cpu "
> -command=3D"$(migration_cmd) $(timeout_cmd) $command"
> -
> -if [ "$UEFI_SHELL_RUN" =3D "y" ]; then
> -       ENVIRON_DEFAULT=3Dn run_test_status $command "$@"
> -else
> -       # We return the exit code via stdout, not via the QEMU return cod=
e
> -       run_test_status $command -kernel "$@"
> -fi
> +vmm_check_supported
> +
> +function arch_run_qemu()
> +{
> +       # Allow user overrides of some config.mak variables
> +       mach=3D$MACHINE_OVERRIDE
> +       qemu_cpu=3D$TARGET_CPU_OVERRIDE
> +       firmware=3D$FIRMWARE_OVERRIDE
> +
> +       : "${mach:=3Dvirt}"
> +       : "${qemu_cpu:=3D$TARGET_CPU}"
> +       : "${qemu_cpu:=3D$DEFAULT_QEMU_CPU}"
> +       : "${firmware:=3D$FIRMWARE}"
> +       [ "$firmware" ] && firmware=3D"-bios $firmware"
> +
> +       set_qemu_accelerator || exit $?
> +       [ "$ACCEL" =3D "kvm" ] && QEMU_ARCH=3D$HOST
> +       acc=3D"-accel $ACCEL$ACCEL_PROPS"
> +
> +       qemu=3D$(search_qemu_binary) || exit $?
> +       if [ "$mach" =3D 'virt' ] && ! $qemu -machine '?' | grep -q 'RISC=
-V VirtIO board'; then
> +               echo "$qemu doesn't support mach-virt ('-machine virt'). =
Exiting."
> +               exit 2
> +       fi
> +       mach=3D"-machine $mach"
> +
> +       command=3D"$qemu -nodefaults -nographic -serial mon:stdio"
> +       command+=3D" $mach $acc $firmware -cpu $qemu_cpu "
> +       command=3D"$(migration_cmd) $(timeout_cmd) $command"
> +
> +       if [ "$UEFI_SHELL_RUN" =3D "y" ]; then
> +               ENVIRON_DEFAULT=3Dn run_test_status $command "$@"
> +       else
> +               # We return the exit code via stdout, not via the QEMU re=
turn code
> +               run_test_status $command -kernel "$@"
> +       fi
> +}
> +
> +function arch_run_kvmtool()
> +{
> +       local command
> +
> +       if [ "$HOST" !=3D "riscv32" ] && [ "$HOST" !=3D "riscv64" ]; then
> +               echo "kvmtool requires KVM but the host ('$HOST') is not =
riscv" >&2
> +               exit 2
> +       fi
> +
> +       kvmtool=3D$(search_kvmtool_binary) ||
> +               exit $?
> +
> +       if [ "$ACCEL" ] && [ "$ACCEL" !=3D "kvm" ]; then
> +               echo "kvmtool does not support $ACCEL" >&2
> +               exit 2
> +       fi
> +
> +       if ! kvm_available; then
> +               echo "kvmtool requires KVM but not available on the host"=
 >&2
> +               exit 2
> +       fi
> +
> +       command=3D"$(timeout_cmd) $kvmtool run"
> +       if ( [ "$HOST" =3D "riscv64" ] && [ "$ARCH" =3D "riscv32" ] ) ||
> +          ( [ "$HOST" =3D "riscv32" ] && [ "$ARCH" =3D "riscv64" ] ); th=
en

Shouldn't there be a check like this on arm for when  [ "$HOST" =3D
"arm" ] && [ "$ARCH" =3D "aarch64" ]?

> +               echo "Cannot run guests with a different xlen than the ho=
st" >&2
> +               exit 2
> +       else
> +               run_test_status $command --kernel "$@"
> +       fi
> +}
> +
> +case $(vmm_get_target) in
> +qemu)
> +       arch_run_qemu "$@"
> +       ;;
> +kvmtool)
> +       arch_run_kvmtool "$@"
> +       ;;
> +esac
> --
> 2.49.0
>

