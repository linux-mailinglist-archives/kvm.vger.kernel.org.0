Return-Path: <kvm+bounces-12270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C606880E6F
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 10:19:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB13B1C20B94
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F5A83A267;
	Wed, 20 Mar 2024 09:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i40DusDC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEFB3A1A1
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 09:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710926382; cv=none; b=TH5iqTFw/Gz1ofpXO/7lfTKBy/38mlybBlqbBZ7VYvn1M17Vvs0xJN+6Yex5PJky4JKIkjZPAsGYbHneoBmfrLDtDK9pxc3cStt3W5m8RD4FGMivZFvpL1rX9hKhMUl7LUOfTRiEygt2AcZjVTUCGISYyhRoF5VOYyG9DfsfPdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710926382; c=relaxed/simple;
	bh=nhA27sbNs6f8vkAPDzCBpOnGkwrWQhfxKwjNEHlIDGw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SViy7TfX5HdxdFrydQuhyEyRdJrGjhl/zxfinfi2ymArLWr7RBHURQuhtg5hg+5lMedmVLHkkT9cZlh4aY9u5V/Qn88xLPMy+3f+W7LCx9PpknCD3vvykIl0LHlk69FjKi/SAHBk8Aej70fKrjk+XvBQEEH/NCkUrozSmzGqWlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i40DusDC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710926379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DB0vWT0Z+EdyohLleucWWp9JAYZ/tAwg+pOedU6RK+o=;
	b=i40DusDC/gtyV20KhSfmoVeuCNj27jjPZokdu0plKqlAwe5bGsR7qPgg3r8fcTD+e1vZ0c
	s/fyvqNZZKOZGyA3YTFbAP/6a36WyAyPHKlnLVCmm5YCQUU5KIYsKOsiHyJ8gyQQwGDgkH
	WqqEQwYj1M5IDhNkSKATAIovIBHMgd0=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-kVpIlA7qPN-cZJOAN5IwQw-1; Wed, 20 Mar 2024 05:19:36 -0400
X-MC-Unique: kVpIlA7qPN-cZJOAN5IwQw-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2d4b150c9a0so31123681fa.0
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 02:19:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710926375; x=1711531175;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DB0vWT0Z+EdyohLleucWWp9JAYZ/tAwg+pOedU6RK+o=;
        b=a3XUk/+sAVX/daOPovMJZCAQ17DsLnLoryLReKZSb0pft/M7h41gaD2jUIKzFpOCR4
         O5Dxuuj/IHhONvR10l5zQGXqZz6p0Ari14nOdMRZ1tE0WJ9Ud6mtcFqWb5n76CIlv42z
         yHG41wGM3LY/CX/zVQH6/5x6U2X2IS2mI1pmiCslB+p9gepotNAisyErclSB5RFn/KJt
         iUQLeY6cjYKwMPrBKQjHxO0tVYrx+keFCzD/hMhqBDeSEifjhSyog1/7PT1uQMJ/xmjO
         24KabZGpp/cD5CTFZFaNErFfh6TObLntU33d1l27gpnpndij3Mdvx4PWooUYPyHTO6w4
         hftQ==
X-Gm-Message-State: AOJu0YyBZxFMPW5LKePt73fF3HjawIijyZdcWNE9w94LSMxv2ZDWWQu6
	kuA0nEvsFAlHGkg4Wf5EayTnM5F92WM2r7GHjxQL/9zOlt9Qwmjs3IBMZq+iMjg8lhTTFZ0eOwV
	WhIStEPCWkx7CF2cEx7PXLw+6V4pSqKxjBhBBexgQ4aXQKkIb/g==
X-Received: by 2002:a2e:6814:0:b0:2d4:6a34:97bf with SMTP id c20-20020a2e6814000000b002d46a3497bfmr8736677lja.49.1710926375429;
        Wed, 20 Mar 2024 02:19:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGo9MnXlyB54dCqjWyQGfrcUBLZH6ZyGSEV7fXznWcU684+dMRzEE2pe3w31FiYYiJ+Qe8ogw==
X-Received: by 2002:a2e:6814:0:b0:2d4:6a34:97bf with SMTP id c20-20020a2e6814000000b002d46a3497bfmr8736644lja.49.1710926374359;
        Wed, 20 Mar 2024 02:19:34 -0700 (PDT)
Received: from [192.168.10.118] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id an14-20020a17090656ce00b00a465b72a1f3sm4560080ejc.85.2024.03.20.02.19.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 02:19:33 -0700 (PDT)
Message-ID: <8386f7ac-418d-4d94-9553-1d2baac17cc1@redhat.com>
Date: Wed, 20 Mar 2024 10:19:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/49] scripts/update-linux-headers: Add setup_data.h
 to import list
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-3-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240320083945.991426-3-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/24 09:38, Michael Roth wrote:
> Data structures like struct setup_data have been moved to a separate
> setup_data.h header which bootparam.h relies on. Add setup_data.h to
> the cp_portable() list and sync it along with the other header files.
> 
> Note that currently struct setup_data is stripped away as part of
> generating bootparam.h, but that handling is no currently needed for
> setup_data.h since it doesn't pull in many external
> headers/dependencies. However, QEMU currently redefines struct
> setup_data in hw/i386/x86.c, so that will need to be removed as part of
> any header update that pulls in the new setup_data.h to avoid build
> bisect breakage.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Including Linux headers from standard-headers breaks build on
non-Linux systems, and <asm/setup_data.h> is the first architecture
specific #include in include/standard-headers/.

So this needs a small fixup, to rewrite asm/ include to the
standard-headers/asm-* subdirectory for the current architecture.
     
While at it, we should remove asm-generic/kvm_para.h from the list of
allowed includes: it does not have a matching substitution, so if it
appeared it would break the build it on non-Linux systems where there
is no /usr/include/asm-generic/ directory.

Applied patches 2-5 to my QEMU coco tree - still temporary, but
certainly better than the hack that I posted yesterday.  By the time
QEMU 9.1 opens there will be something more stable to import from.

Paolo

diff --git a/scripts/update-linux-headers.sh b/scripts/update-linux-headers.sh
index 579b03dc824..d48856f9e24 100755
--- a/scripts/update-linux-headers.sh
+++ b/scripts/update-linux-headers.sh
@@ -61,7 +61,6 @@ cp_portable() {
                                       -e 'linux/const' \
                                       -e 'linux/kernel' \
                                       -e 'linux/sysinfo' \
-                                     -e 'asm-generic/kvm_para' \
                                       -e 'asm/setup_data.h' \
                                       > /dev/null
      then
@@ -78,6 +77,7 @@ cp_portable() {
          -e 's/__be\([0-9][0-9]*\)/uint\1_t/g' \
          -e 's/"\(input-event-codes\.h\)"/"standard-headers\/linux\/\1"/' \
          -e 's/<linux\/\([^>]*\)>/"standard-headers\/linux\/\1"/' \
+        -e 's/<asm\/\([^>]*\)>/"standard-headers\/asm-'$arch'\/\1"/' \
          -e 's/__bitwise//' \
          -e 's/__attribute__((packed))/QEMU_PACKED/' \
          -e 's/__inline__/inline/' \
@@ -157,12 +157,13 @@ for arch in $ARCHLIST; do
          cp_portable "$tmpdir/bootparam.h" \
                      "$output/include/standard-headers/asm-$arch"
          cp_portable "$tmpdir/include/asm/setup_data.h" \
-                    "$output/linux-headers/asm-x86"
+                    "$output/standard-headers/asm-x86"
      fi
      if [ $arch = riscv ]; then
          cp "$tmpdir/include/asm/ptrace.h" "$output/linux-headers/asm-riscv/"
      fi
  done
+arch=
  
  rm -rf "$output/linux-headers/linux"
  mkdir -p "$output/linux-headers/linux"


