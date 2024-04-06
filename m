Return-Path: <kvm+bounces-13791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1145E89A96D
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 08:48:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3460A1C20F48
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 06:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807992209B;
	Sat,  6 Apr 2024 06:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CeyfZuYl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA0C139F;
	Sat,  6 Apr 2024 06:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712386088; cv=none; b=u+vFnphK+Fd5U+JqwtszMSazVSEFjb48iwKVq+N0xOJD5+pWpzRJOIQTONpbrqWxmL29PihS51ZSQsn8ksMlkxsA8tjCLldPJ0f+RBR1jtZTnoonyVH+vDv7ySn1jEMc6eNuqAF8ytIwyEPNi/iwi7Wd0RR68y3iKNYo9AHgLdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712386088; c=relaxed/simple;
	bh=nu4/Vi34vG4UZpRARu5d9nl5hpHsMKzoMSIzt8eV25U=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=MffH9NN7KUW7pZ1oQGoM7R9dUwMLVK/q3rWxs9eu1O3sMuQgmvjmto1zzX/OJn1YfEitBWYTX8doQmNXli4DYH4gofRsy7HJO2d9m7VL9mFmKJMNnpuuYa7hGRjK2bZNhXMd/JTFptb8FxSFNx4Dfw0TXLU2nWMuckv+tdbb6aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CeyfZuYl; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2a2f007a33dso1784740a91.0;
        Fri, 05 Apr 2024 23:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712386087; x=1712990887; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v6+JiqOGzbpzk2klVJFAulQ2pHe3C62qO52FD0G/JgA=;
        b=CeyfZuYlBEI+s6CrmexqGSQ+qkH1/LRKxUdtKztyHoKUqmXbhv+e+j8dP0GkHYzHHn
         Ei7Y0TZJcCM6gbKMAZ8l3b7VFw4alnUdRjn3V5spois9rQBQCHs5SnMPqG2BM6jAG4O+
         ZPaYkk5u+4lc18wAfX770FrTW0ZZvjpU1pEVkzhPQ0uzzeOkitUn419WQjWtS7cUBeqg
         +mN9/oNgoye2ZKsPX2RAxM14wiUg0ggCc1dX0enmIuvUKtWRDdr2ip9zSj8RYLHRhFqQ
         qm7UQxy9j0Hg0H9nLEKHcIH2gwcC9k/O7g7aQe4JiCWljQJv7HS6FwXCx1FoAY5WBZQx
         mlZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712386087; x=1712990887;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=v6+JiqOGzbpzk2klVJFAulQ2pHe3C62qO52FD0G/JgA=;
        b=GKjhu2ttgnknYWE44rMaY8Sfr8tMnIO+5FTUVCw2GACJiEpSoWEcNUQPALp58ETLKy
         sUVohz6S0CORRXbGllJN/ifWWxmBckl2u5grIPWulWksiG1HKn5BFbmQZPkW7PBhTDkB
         DxMXVHlvQZYfL6mAxNo+RImvXtQJCA3uSs3NMaEPgAjwqqfeT7uyU4fSq9q4zxz5rUwm
         7sEKCIguGG+3myXsPoLVvqtn6tLDNhBRyL6p6Zmye3yPirHx0J+xhzws5almTNMuoG0X
         SSt2/gLZDUNe1S3s5u1ry7lt6qcKrg9QyOXguJ/LLPGgbSmT+1otrnui/911Rr/lfqUe
         Vv4Q==
X-Forwarded-Encrypted: i=1; AJvYcCX3bCO0kU/tlj/SREyXzxXKCCW46UT0lkuYiiG8gW2XQ0r4HUMOq2FdBaInCP9Q/Ph9Dpp8Inrb3kug3ujRomapVmx2rly13OHm8pppzzmuBuTewgMq8WuCZKOEjvkKAA==
X-Gm-Message-State: AOJu0YzJwbQ2Z+6XcCZAb1LRhjg6dHgJ7CceuonnTQJsFtxCM9aW+tTu
	pEGqiaHsdF5ClRI5fzIiArcUB4yNT6e0kDguDMZxYQ3+OtuVbnxW
X-Google-Smtp-Source: AGHT+IEYFWg8+9q/bQMiaUQc7asTNB8G+VtUoqv4E9bLDu0tOzj8XkKrkMiIqAvMosYPL5b0r3KrmA==
X-Received: by 2002:a17:90a:fe8d:b0:2a2:ba9:ba61 with SMTP id co13-20020a17090afe8d00b002a20ba9ba61mr3660048pjb.34.1712386086714;
        Fri, 05 Apr 2024 23:48:06 -0700 (PDT)
Received: from localhost (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y22-20020a63e256000000b005dc8c301b9dsm2582409pgj.2.2024.04.05.23.47.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 23:48:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 06 Apr 2024 16:47:56 +1000
Message-Id: <D0CU7BLHUQGG.2GG3SFOUSVPCL@gmail.com>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Thomas Huth" <thuth@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>,
 "Nadav Amit" <namit@vmware.com>, "David Woodhouse" <dwmw@amazon.co.uk>,
 "Ricardo Koller" <ricarkol@google.com>, "rminmin" <renmm6@chinaunicom.cn>,
 "Gavin Shan" <gshan@redhat.com>, "Nina Schoetterl-Glausch"
 <nsg@linux.ibm.com>, "Sean Christopherson" <seanjc@google.com>,
 <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests RFC PATCH 11/17] shellcheck: Fix SC2145
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>
X-Mailer: aerc 0.17.0
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-12-npiggin@gmail.com>
 <20240405-a35419152685e6aca33ccc04@orel>
In-Reply-To: <20240405-a35419152685e6aca33ccc04@orel>

On Sat Apr 6, 2024 at 12:35 AM AEST, Andrew Jones wrote:
> On Fri, Apr 05, 2024 at 07:00:43PM +1000, Nicholas Piggin wrote:
> >   SC2145 (error): Argument mixes string and array. Use * or separate
> >   argument.
> >=20
> > Could be a bug?
>
> I don't think so, since the preceding string ends with a space and there
> aren't any succeeding strings. Anyway, it's good to switch to *

Okay I think you're right.

Thanks,
Nick

>
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >  arm/efi/run             | 2 +-
> >  riscv/efi/run           | 2 +-
> >  scripts/mkstandalone.sh | 2 +-
> >  3 files changed, 3 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/arm/efi/run b/arm/efi/run
> > index f07a6e55c..cf6d34b0b 100755
> > --- a/arm/efi/run
> > +++ b/arm/efi/run
> > @@ -87,7 +87,7 @@ uefi_shell_run()
> >  if [ "$EFI_DIRECT" =3D "y" ]; then
> >  	$TEST_DIR/run \
> >  		$KERNEL_NAME \
> > -		-append "$(basename $KERNEL_NAME) ${cmd_args[@]}" \
> > +		-append "$(basename $KERNEL_NAME) ${cmd_args[*]}" \
> >  		-bios "$EFI_UEFI" \
> >  		"${qemu_args[@]}"
> >  else
> > diff --git a/riscv/efi/run b/riscv/efi/run
> > index 982b8b9c4..cce068694 100755
> > --- a/riscv/efi/run
> > +++ b/riscv/efi/run
> > @@ -97,7 +97,7 @@ if [ "$EFI_DIRECT" =3D "y" ]; then
> >  	fi
> >  	$TEST_DIR/run \
> >  		$KERNEL_NAME \
> > -		-append "$(basename $KERNEL_NAME) ${cmd_args[@]}" \
> > +		-append "$(basename $KERNEL_NAME) ${cmd_args[*]}" \
> >  		-machine pflash0=3Dpflash0 \
> >  		-blockdev node-name=3Dpflash0,driver=3Dfile,read-only=3Don,filename=
=3D"$EFI_UEFI" \
> >  		"${qemu_args[@]}"
> > diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> > index 86c7e5498..756647f29 100755
> > --- a/scripts/mkstandalone.sh
> > +++ b/scripts/mkstandalone.sh
> > @@ -76,7 +76,7 @@ generate_test ()
> > =20
> >  	cat scripts/runtime.bash
> > =20
> > -	echo "run ${args[@]}"
> > +	echo "run ${args[*]}"
> >  }
> > =20
> >  function mkstandalone()
> > --=20
> > 2.43.0
> >=20
> >
>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>


