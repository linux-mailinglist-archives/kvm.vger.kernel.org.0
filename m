Return-Path: <kvm+bounces-26439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B56DE97474C
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:22:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20C90B21033
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58451C147;
	Wed, 11 Sep 2024 00:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EhRKfGWx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E985B665;
	Wed, 11 Sep 2024 00:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726014110; cv=none; b=bs4hFEXWcPcGSC5c4grHJ9H65XD0BRrbkWpy9h2xUvP9UNAVdrTw56kl40xc9UCY9sNDmsw/P0guC/XxucpAtZaH4vutwaknKXA8qKYWyE+G3/4Z1HZDfja98mwCQdNHCHsmhE6XdRrcNQ3dNyK+9qP2ycKH7TAi2PA2s8kGNRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726014110; c=relaxed/simple;
	bh=XJsAOMeR1xyoAviG9h+i3BRNuKdHXmsziYQPTgOLA0g=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=hZ3KCzkRNwZEMM32OiD6Pskb7Sk5QXWMD0zN+ajBMdiWqDJ2zpUGoSDwzucZT5TlsuGfDM3m9uXEsT8aig74PGzWo5vfXzy5N4TfWwPF/AF4rfrYZdIYidG74ftB0jd7/wvERh5aDezVkoWLwJamZnhKtPi9gCfAIjwH8vse+bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EhRKfGWx; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20696938f86so51785305ad.3;
        Tue, 10 Sep 2024 17:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726014108; x=1726618908; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JeW4Y0h7gL1bTrw9BgVO7v31cFSL53BgLr+Fcn1Qzkw=;
        b=EhRKfGWxjbuTERUK7VTqGvcWFsnrEL/Lkfd6H+VXUwC5B+FKtdAI04Ah7yFqqQ4bTD
         FkiyLW5lclcYTik7zeHYq4GNConIt1yRyTY0fsSPVfAdGhNjuNnFBQJdwhYSFwoUVXA2
         o6XxAn53QkvlyL+TnuS1BbFWmI5geR+dJuROhJJ8TLvmHqOnaUcsdXtioLoR1+VQnTK6
         0s7esn/ntfpXt0ah/1dyS5jQLyMmJKu3Avpgx12xrVPfeMKlJhNfykAZf7LsUFStlIpA
         B+TxXeOFUoBnmA8G8Uobwxe/zBcJxI6ScgH9rnOWnHSZZVFVMaWBdQqWwJawGtw5wY2E
         IZjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726014108; x=1726618908;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JeW4Y0h7gL1bTrw9BgVO7v31cFSL53BgLr+Fcn1Qzkw=;
        b=ei2E2nAtzsaQS5Ofbf9oK9LPG9Z75Y8DQm3lxPVRwZpBWVEkTut3GBpwerGJgajk6j
         XupeO3D1up+m6Ydlvsi0OQ0ZfBv81pLfhfIq548zgc3OzhRN8Ylpqy/gpa4rwsuntLv1
         Cf8qjysAusbLILyuiigopLb0N5F7PgYso1W4MHvHPoNBuLLpcwrRrprVx1EukM/KymRK
         RpXjLsNSZSsx2v6lUKXKxwhOI2m+fK8pm4ec70SDD+w03IhQ5FBSp5W032yhFOdE2sQs
         92gV3cnS+JAUkrkXJpscScqAc8y+X3jBs6G0IcnsSI4SyvXt/pq3VTnhCs37N2cAGqff
         k5ew==
X-Forwarded-Encrypted: i=1; AJvYcCX9m7EobT44QEADo7wytyqrWgrJ7WE+lBTXL3gdZSLDqLPMw3TMzJC1sDFhWCRheoiIRJM=@vger.kernel.org, AJvYcCXGTAmF0hzhU6gPXskLgPJ+rAcdMazuAiYLerEIEZ0W8X21CodHrW1WvWgMLAuXlrNEYB8+A5WtnMJUXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YySfa1YU5spUA5e89U5GUwY8iWc35fALOG3PjOxU16rCtBUH+AT
	SSqV28R6BRg7gsIiFsicMyTRSFjLqFWEtrg72/LEYh/ZBzb1egfE
X-Google-Smtp-Source: AGHT+IGpFgBeviIk7STqAhQZktkyXQGuxb0SJW7P1uto6lzV5ThtJVUyImgUcmDFmHHJeJktFhH2hA==
X-Received: by 2002:a17:903:2447:b0:206:c75a:29d4 with SMTP id d9443c01a7336-2074c6ed1dfmr36845375ad.50.1726014108401;
        Tue, 10 Sep 2024 17:21:48 -0700 (PDT)
Received: from localhost ([1.146.47.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710e3365asm53646465ad.97.2024.09.10.17.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 17:21:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Sep 2024 10:21:39 +1000
Message-Id: <D430XMRU4FZD.1FFPMW6WVWRSD@gmail.com>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>, <kvmarm@lists.linux.dev>,
 <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>
Cc: <pbonzini@redhat.com>, <thuth@redhat.com>, <lvivier@redhat.com>,
 <frankja@linux.ibm.com>, <imbrenda@linux.ibm.com>, <nrb@linux.ibm.com>,
 <atishp@rivosinc.com>, <cade.richard@berkeley.edu>, <jamestiotio@gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/4] Makefile: Prepare for clang EFI
 builds
X-Mailer: aerc 0.18.2
References: <20240904105020.1179006-6-andrew.jones@linux.dev>
 <20240904105020.1179006-8-andrew.jones@linux.dev>
In-Reply-To: <20240904105020.1179006-8-andrew.jones@linux.dev>

On Wed Sep 4, 2024 at 8:50 PM AEST, Andrew Jones wrote:
> clang complains about GNU extensions such as variable sized types not
> being at the end of structs unless -Wno-gnu is used. We may
> eventually want -Wno-gnu, but for now let's just handle the warnings
> as they come. Add -Wno-gnu-variable-sized-type-not-at-end to avoid
> the warning issued for the initrd_dev_path struct.

You could also make a variant of struct efi_vendor_dev_path with no
vendordata just for initrd_dev_path?

It's taken from Linux or some efi upstream though so maybe it's annoying
to make such changes here. Okay in that case since it's limited to EFI.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>


>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  Makefile | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index 3d51cb726120..7471f7285b78 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -50,6 +50,8 @@ EFI_CFLAGS +=3D -fshort-wchar
>  # EFI applications use PIC as they are loaded to dynamic addresses, not =
a fixed
>  # starting address
>  EFI_CFLAGS +=3D -fPIC
> +# Avoid error with the initrd_dev_path struct
> +EFI_CFLAGS +=3D -Wno-gnu-variable-sized-type-not-at-end
>  # Create shared library
>  EFI_LDFLAGS :=3D -Bsymbolic -shared -nostdlib
>  endif


