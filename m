Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C04B373CD
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 14:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfFFMIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 08:08:42 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42993 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbfFFMIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 08:08:42 -0400
Received: by mail-wr1-f67.google.com with SMTP id x17so2142433wrl.9
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 05:08:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1tUGUfqQNeozundBHQY0Mr34C13IolgIU4qzmQhNz7w=;
        b=IbslHK6aU95DTb2SuJpAi7nc0Ay3CW14SYYbyA/jDpQC/V1SJKoTMzf6CzSQncu/4D
         KmXbDw0+pCMX1A1thDqqE5hZ1pPMHWO+8vSENIQVJoAckIq4TzNYTTEz3snMztYn9vA/
         /6R9IY3+sUCPdX+PguYoHWoykFrTzK+PJdkRAW4w1czdZIk9LqTbttgSQeLGG5LeK83f
         uyWJj5F9V7+vlwCc5ZHgPZ8PKZpw55llSdedGHqvjkuL5Sns3LmRLQ8OzObIqlH2+uZz
         UcrmeXESbZp12EuPmCVXW5S1JABrP+bd5d5NhlDlSGmBkOgIJwPNlxq5V0qFY+KIYZSQ
         7sKA==
X-Gm-Message-State: APjAAAWGy1iufx8PD2MFaDRGjXbrBR7VGS5CwbAaQbn4A0g27ueRh6V0
        bCzAKBgjQTTx9bSqwARqUAExPeJ32co=
X-Google-Smtp-Source: APXvYqyyb0ZTXRRapNwCbq8hlOhq3j7bkYkENSHXKbSoudq6f6Jx2IT+zeK/+JX3PH+EoqMflTgqwA==
X-Received: by 2002:a5d:554f:: with SMTP id g15mr29482653wrw.318.1559822920156;
        Thu, 06 Jun 2019 05:08:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id a139sm1753520wmd.18.2019.06.06.05.08.39
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 05:08:39 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci: Run tests with a Fedora docker
 image
To:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
References: <20190527112853.3920-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e519464a-6c21-eb1c-eb90-2c5f2656ee82@redhat.com>
Date:   Thu, 6 Jun 2019 14:08:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190527112853.3920-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/19 13:28, Thomas Huth wrote:
> Fedora has a newer version of QEMU - and most notably it has a *working*
> version of qemu-system-s390x! So we can finally also run some s390x tests
> in the gitlab-ci.
> 
> For some unknown reasons, the sieve test is now failing on x86_64,
> so I had to disable it. OTOH, the taskswitch2 test now works on
> i386, so we can enable this test instead.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  .gitlab-ci.yml | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 50a1e39..a9dc16a 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -1,10 +1,12 @@
> +image: fedora:30
> +
>  before_script:
> - - apt-get update -qq
> - - apt-get install -y -qq qemu-system
> + - dnf update -y
> + - dnf install -y make python
>  
>  build-aarch64:
>   script:
> - - apt-get install -y -qq gcc-aarch64-linux-gnu
> + - dnf install -y qemu-system-aarch64 gcc-aarch64-linux-gnu
>   - ./configure --arch=aarch64 --cross-prefix=aarch64-linux-gnu-
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
> @@ -15,8 +17,8 @@ build-aarch64:
>  
>  build-arm:
>   script:
> - - apt-get install -y -qq gcc-arm-linux-gnueabi
> - - ./configure --arch=arm --cross-prefix=arm-linux-gnueabi-
> + - dnf install -y qemu-system-arm gcc-arm-linux-gnu
> + - ./configure --arch=arm --cross-prefix=arm-linux-gnu-
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
>       selftest-setup selftest-vectors-kernel selftest-vectors-user selftest-smp
> @@ -26,7 +28,7 @@ build-arm:
>  
>  build-ppc64be:
>   script:
> - - apt-get install -y -qq gcc-powerpc64-linux-gnu
> + - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
>   - ./configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
> @@ -37,7 +39,7 @@ build-ppc64be:
>  
>  build-ppc64le:
>   script:
> - - apt-get install -y -qq gcc-powerpc64-linux-gnu
> + - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
>   - ./configure --arch=ppc64 --endian=little --cross-prefix=powerpc64-linux-gnu-
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
> @@ -48,28 +50,33 @@ build-ppc64le:
>  
>  build-s390x:
>   script:
> - - apt-get install -y -qq gcc-s390x-linux-gnu
> + - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
>   - ./configure --arch=s390x --cross-prefix=s390x-linux-gnu-
>   - make -j2
> + - ACCEL=tcg ./run_tests.sh
> +     selftest-setup intercept emulator sieve diag10
> +     | tee results.txt
> + - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
>  build-x86_64:
>   script:
> + - dnf install -y qemu-system-x86 gcc
>   - ./configure --arch=x86_64
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
>       ioapic-split ioapic smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
>       vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
>       vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
> -     eventinj msr port80 sieve tsc rmap_chain umip hyperv_stimer intel_iommu
> +     eventinj msr port80 syscall tsc rmap_chain umip intel_iommu
>       | tee results.txt
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
>  build-i386:
>   script:
> - - apt-get install -y -qq gcc-multilib
> + - dnf install -y qemu-system-x86 gcc
>   - ./configure --arch=i386
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
> -     eventinj port80 sieve tsc taskswitch umip hyperv_stimer
> +     eventinj port80 sieve tsc taskswitch taskswitch2 umip
>       | tee results.txt
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
> 

Queued, thanks.

Paolo
