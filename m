Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7360B4B3944
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 04:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbiBMDsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 22:48:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiBMDsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 22:48:40 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCAB5F27C
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 19:48:34 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id q145-20020a4a3397000000b002e85c7234b1so15416276ooq.8
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 19:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QSdnFiBinDgIcA1hTRtDqUXUIi2Jk2CcW/8udvXXzCk=;
        b=RxE77ljk8eftNsbAQyZkUw9NJOzfLUTp5Mrzhqt94i/PVDguJ5wX1AB177zsvPPllC
         zBLzklg03KGlux4vuhvfX6ssHG4HLqzn20alRkJpvoDmgUPeur68LfxwCgvTP28GjQhy
         81LbfAuBI8QH184ygxQbIySb5U/RPk9IkVlu68ysBtyf8uYB4uMWK/EWlNyoEqHWzQaN
         q8SYDZvDGN3A3jpR8uutlttxrhFirgRRW4xFWyHh+eAndFsxOBv7qu47Lx4evZrxpmMx
         LBLGcN15hXAl+XwJ/TIq6oCcLQhxINiucmql+UAPkH2f7jQlu+rRZdzwYkeGJGy9O4wg
         6xfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QSdnFiBinDgIcA1hTRtDqUXUIi2Jk2CcW/8udvXXzCk=;
        b=PIHsPXV+jlg8qIZlOEEGf5nOkSZQsZKH28JtU3zHrhC0h94WaI/9OeAVVpFOoh0iEw
         cfpSYaFpEmqVvkFgaVq+EijEC0UlERvIHRRMCaP5ZWR9N30XSaLSRq3k6u3UHjCBwcpS
         KDm3xzbrnRa92YclJiRwnPXjx4EbG7gxWxv9dCkQhc0T3iGpkTGNd/ZLJ7fvJ85DhtCM
         pw6rbbz72KyIVIrpdPO2qo2xfkfsGmgpjBP+y6Q3DssfI7aXaJe0C4fYFboH/IE5pgey
         OwsOhdi6NOwAxwPfyzZdFgfT7cWpBaPWmm3aOozMru1jo1900sPTR/50LnqYtNQaPPTV
         juvQ==
X-Gm-Message-State: AOAM5323K5gjHXSmyQZGINga8n5MJ69UAgdPGxlwAiJRXx3A5vrgv6H5
        mYj0R+4QDT+a81vCXdxl/jW0k3GVBIojuxyYcrCR+g==
X-Google-Smtp-Source: ABdhPJylzu3GCIaGyr34TpsbzMhbIwXmL/4ZSE4loqJAAdotcoe2UgqOpL7Xe0c07diRTwxYmCkK2zHQ9lW8YAxEun8=
X-Received: by 2002:a05:6870:6186:: with SMTP id a6mr2374009oah.153.1644724113811;
 Sat, 12 Feb 2022 19:48:33 -0800 (PST)
MIME-Version: 1.0
References: <20220209164254.8664-1-varad.gautam@suse.com>
In-Reply-To: <20220209164254.8664-1-varad.gautam@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Sat, 12 Feb 2022 19:48:22 -0800
Message-ID: <CAA03e5F0yDkaKhL42LKreLGyiy5gwZvtS4YR9q-ZFpqt2uxqnQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2] x86/efi: Allow specifying AMD
 SEV/SEV-ES guest launch policy to run
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 9, 2022 at 8:43 AM Varad Gautam <varad.gautam@suse.com> wrote:
>
> Make x86/efi/run check for AMDSEV envvar and set corresponding
> SEV/SEV-ES parameters on the qemu cmdline, to make it convenient
> to launch SEV/SEV-ES tests.
>
> Since the C-bit position depends on the runtime host, fetch it
> via cpuid before guest launch.
>
> AMDSEV can be set to `sev` or `sev-es`.
>
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  x86/efi/README.md |  5 +++++
>  x86/efi/run       | 38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+)
>
> diff --git a/x86/efi/README.md b/x86/efi/README.md
> index a39f509..1222b30 100644
> --- a/x86/efi/README.md
> +++ b/x86/efi/README.md
> @@ -30,6 +30,11 @@ the env variable `EFI_UEFI`:
>
>      EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/msr.efi
>
> +To run the tests under AMD SEV/SEV-ES, set env variable `AMDSEV=sev` or
> +`AMDSEV=sev-es`. This adds the desired guest policy to qemu command line.
> +
> +    AMDSEV=sev-es EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/amd_sev.efi
> +
>  ## Code structure
>
>  ### Code from GNU-EFI
> diff --git a/x86/efi/run b/x86/efi/run
> index ac368a5..9bf0dc8 100755
> --- a/x86/efi/run
> +++ b/x86/efi/run
> @@ -43,6 +43,43 @@ fi
>  mkdir -p "$EFI_CASE_DIR"
>  cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
>
> +amdsev_opts=
> +if [ -n "$AMDSEV" ]; then
> +       # Guest policy bits, used to form QEMU command line.
> +       readonly AMDSEV_POLICY_NODBG=$(( 1 << 0 ))
> +       readonly AMDSEV_POLICY_ES=$(( 1 << 2 ))
> +
> +       gcc -x c -o getcbitpos - <<EOF
> +       /* CPUID Fn8000_001F_EBX bits 5:0 */
> +       int get_cbit_pos(void)
> +       {
> +               int ebx;
> +               __asm__("mov \$0x8000001f , %eax\n\t");
> +               __asm__("cpuid\n\t");
> +               __asm__("mov %%ebx, %0\n\t":"=r" (ebx));
> +               return (ebx & 0x3f);
> +       }
> +       int main(void)
> +       {
> +               return get_cbit_pos();
> +       }
> +EOF

We could do this in bash directly, using the cpuid driver:
https://man7.org/linux/man-pages/man4/cpuid.4.html

I'm not a Linux shell wizard, but I found an example of a script using
this module here:
https://git.irsamc.ups-tlse.fr/dsanchez/spectre-meltdown-checker/src/branch/master/spectre-meltdown-checker.sh

After studying that script (for like an hour, lol), I was able to
extract the cbit position. Below, I explain how to do this with the
cpuid driver. My only complaint about using the cpuid driver is that
it's awfully hard to follow. So I'd be OK to stick with the C code
that you've got. Though it may be better to break out the C code into
an actual .c file, rather than embed it in the script like this, and
magically build it and clean it up, which seems pretty hacky. I know I
was doing something similar with a dummy.c file embedded in the run
script file to get the run_tests.sh script to work, and Paolo ended up
moving that into an explicit build target in the x86/ directory.

Getting the c bit position in pure bash, using the cpuid driver.
$ ebx=$(dd if=/dev/cpu/0/cpuid bs=16 skip=134217729 count=16
2>/dev/null | od -j 240 -An -t u4 | awk '{print $'"2"'}')
$ echo $(( $ebx&0x3f ))

Breaking it down:

# Use dd to read the 0x8000001f leaf via the cpuid driver:
# bs=16: block size of 16 bytes; required by the driver per it's man page
# skip=134217729: This is the CPUID leaf, 0x8000001f as a decimal number,
#      divided by the block size
# count=16: We actually only want to read a count=1 16 byte block
#      because {eax, ebx, ecx, edx} is a single 16 byte block.
However, our CPUID leaf,
#      0x8000001f, doesn't divide evenly by 16. It has a remainder of
15. So read the
#      previous 15 sixteen-byte blocks, plus the block we actually want to read.
$ dd if=/dev/cpu/0/cpuid bs=16 skip=134217729 count=16 2>/dev/null

# Use od to convert the binary data returned by the cpuid driver into ascii.
# -j 240: Skip the first 15 sixteen-byte blocks that we only read to
appease the 16 byte block size. (15 * 16 = 240).
# -An: Don't label the output with indexes.
# -t u4: Output the data as 4-byte unsigned decimal #'s.
od -j 240 -An -t u4

The od command above outputs the four CPUID values {eax, ebx, ecx,
edx}. On my machine:
      65551        367        509        100

Finally, use awk to take the second one -- ebx. And then take the
lower 6 bits for the c-bit position.

> +
> +       cbitpos=$(./getcbitpos ; echo $?) || rm ./getcbitpos
> +       policy=
> +       if [ "$AMDSEV" = "sev" ]; then
> +               policy="$(( $AMDSEV_POLICY_NODBG ))"
> +       elif [ "$AMDSEV" = "sev-es" ]; then
> +               policy="$(( $AMDSEV_POLICY_NODBG | $AMDSEV_POLICY_ES ))"
> +       else
> +               echo "Cannot set AMDSEV policy. AMDSEV must be one of 'sev', 'sev-es'."
> +               exit 2
> +       fi
> +
> +       amdsev_opts="-object sev-guest,id=sev0,cbitpos=${cbitpos},reduced-phys-bits=1,policy=${policy} \
> +                    -machine memory-encryption=sev0"
> +fi
> +
>  # Run test case with 256MiB QEMU memory. QEMU default memory size is 128MiB.
>  # After UEFI boot up and we call `LibMemoryMap()`, the largest consecutive
>  # memory region is ~42MiB. Although this is sufficient for many test cases to
> @@ -61,4 +98,5 @@ cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
>         -nographic \
>         -m 256 \
>         "$@" \
> +       $amdsev_opts \
>         -smp "$EFI_SMP"
> --
> 2.34.1
>
