Return-Path: <kvm+bounces-3740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD63F8076E2
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:47:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4FDA9B20F34
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 535C96ABB4;
	Wed,  6 Dec 2023 17:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q06gnmi4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6ED8D46
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 09:46:56 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-50bf09be81bso30e87.1
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 09:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701884815; x=1702489615; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=40RVph6R6yt3n+vZ+PWPchr4/4jOFmgCoqk9cPDFhkM=;
        b=q06gnmi4/qD7JgaxyZtxstwMoS8lSEZrLmsYDrLEpXJHhJQnD5VgQtDR8Ek2NaRWN+
         2Utjl84JK+CbrI8NS/s/1k2xUoiLGH6rWy8Fy0c5nSG5CdnqGyEzsePf7HSDwhhS1eyX
         D2dQBk3OE16EmkJbmZHwr26T76nnIR2tauSDuqIlUbcyYy2KzGZBT5MbGFtblTel00Gp
         bkAE/gMGaj5r1qt3IISisamBrJJRpLFaIH2DIft5EhzbLCu8BGiNwKaFiH1Twimr8Ud1
         OjccF3zUMbTI5pThhaxXoJlVtxaMg+Sgq/k/QzjD+ThwDgV1Q9TwywGl9h9+yZbuxZR7
         MsCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701884815; x=1702489615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=40RVph6R6yt3n+vZ+PWPchr4/4jOFmgCoqk9cPDFhkM=;
        b=RSSeXDan4HAkcHZjz22lvwGR3jQVDhkNAUd5BAwwTzokYZnsIB/FsrhUY9PMdKA4X0
         nqR0M5L5U61GxOR2pQtCH+KMqI+2kjwzljnNc5UlCln1idjXFGuX5rghBYxNnVBq4Mky
         int8afESqpLmxTqBWbt2xY6KF4LLs03ppdpsbMR+w0F2rzioWS7hudrCYoYZa+6lQrnP
         IbbeZp+HJGXCmGtOHu2z6qvAHRXpSw1aTUBgOhRZNSCFVEwrraNBUa+3XMJm8xkKL3JB
         kPbSYkjteQo3F/HQ2TM3ng+Rmilbck2eJZVNHB5L0NYs8/cCjHzluXjE7xHHEVqUBHrU
         QjTw==
X-Gm-Message-State: AOJu0YwpZEObyekNxLsciO9gvHEodobG72q685jdsl/fFeTddbB2M5OW
	8wy9GcknwvwWu6xY1Eput2egQgJ95p6VE2ECpvNTCA==
X-Google-Smtp-Source: AGHT+IGStHTnn01sg/zP1v9g4k+SVZgsaH7zL+ozF8zFR4+YqFgj+VjQfKSSAPbT8vf0MCQMhkPE0MT3+VTAP3mTD24=
X-Received: by 2002:a05:6512:2255:b0:50c:147c:5022 with SMTP id
 i21-20020a056512225500b0050c147c5022mr52164lfu.6.1701884814669; Wed, 06 Dec
 2023 09:46:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231128125959.1810039-1-nikunj@amd.com>
In-Reply-To: <20231128125959.1810039-1-nikunj@amd.com>
From: Peter Gonda <pgonda@google.com>
Date: Wed, 6 Dec 2023 10:46:43 -0700
Message-ID: <CAMkAt6pULjLVUO6Ys4Sq1a79d93_5w5URgLYNXY-aW2jSemruA@mail.gmail.com>
Subject: Re: [PATCH v6 00/16] Add Secure TSC support for SNP guests
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org, 
	kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, dionnaglaze@google.com, seanjc@google.com, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 28, 2023 at 6:00=E2=80=AFAM Nikunj A Dadhania <nikunj@amd.com> =
wrote:
>
> Secure TSC allows guests to securely use RDTSC/RDTSCP instructions as the
> parameters being used cannot be changed by hypervisor once the guest is
> launched. More details in the AMD64 APM Vol 2, Section "Secure TSC".
>
> During the boot-up of the secondary cpus, SecureTSC enabled guests need t=
o
> query TSC info from AMD Security Processor. This communication channel is
> encrypted between the AMD Security Processor and the guest, the hyperviso=
r
> is just the conduit to deliver the guest messages to the AMD Security
> Processor. Each message is protected with an AEAD (AES-256 GCM). See "SEV
> Secure Nested Paging Firmware ABI Specification" document (currently at
> https://www.amd.com/system/files/TechDocs/56860.pdf) section "TSC Info"
>
> Use a minimal GCM library to encrypt/decrypt SNP Guest messages to
> communicate with the AMD Security Processor which is available at early
> boot.
>
> SEV-guest driver has the implementation for guest and AMD Security
> Processor communication. As the TSC_INFO needs to be initialized during
> early boot before smp cpus are started, move most of the sev-guest driver
> code to kernel/sev.c and provide well defined APIs to the sev-guest drive=
r
> to use the interface to avoid code-duplication.
>
> Patches:
> 01-08: Preparation and movement of sev-guest driver code
> 09-16: SecureTSC enablement patches.
>
> Testing SecureTSC
> -----------------
>
> SecureTSC hypervisor patches based on top of SEV-SNP Guest MEMFD series:
> https://github.com/nikunjad/linux/tree/snp-host-latest-securetsc_v5
>
> QEMU changes:
> https://github.com/nikunjad/qemu/tree/snp_securetsc_v5
>
> QEMU commandline SEV-SNP-UPM with SecureTSC:
>
>   qemu-system-x86_64 -cpu EPYC-Milan-v2,+secure-tsc,+invtsc -smp 4 \
>     -object memory-backend-memfd-private,id=3Dram1,size=3D1G,share=3Dtrue=
 \
>     -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,se=
cure-tsc=3Don \
>     -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram1,=
kvm-type=3Dsnp \
>     ...

Thanks Nikunj!

I was able to modify my SNP host kernel to support SecureTSC based off
of your `snp-host-latest-securetsc_v5` and use that to test this
series. Seemed to work as intended in the happy path but I didn't
spend much time trying any corner cases. Also checked the series
continues to work without SecureTSC enabled for the V.

Tested-by: Peter Gonda <pgonda@google.com>

