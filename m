Return-Path: <kvm+bounces-18726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C59118FAA5A
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 07:59:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B1061F23336
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 05:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0835B13DDC3;
	Tue,  4 Jun 2024 05:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PiF7iLVb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27FC847B
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 05:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717480738; cv=none; b=ZGK44reI0Yh9IfxifDKl1sPc5WrcPULsGs5fZz9sMwRAlyblptyyXwJWOs0/qxdaxBwIAhCKUMcQFOGEOwXOu3+7wFPZEh+7tHs9ONSEZTqL5eAcBvG0BBEpoRaNtqj1IYx2+zfXz4PidHQKpARlZ0CmHmaI2ODIjjjNIXSu3Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717480738; c=relaxed/simple;
	bh=bdEet59TQTyTVbSK//LkGfuAXacPoFmV4TWl20G9Am0=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=D+0AZ2RP+dEmrLACzfjvkiWeaLP2iCUGY1tj/NDL3kfDY+RAd4HZlw/uQ+OFhIcBTYRNLMfyhKLS1hDuumOy3hlZe+RyuLmmZGan7eaBUJAWUJbajBJ/z9QZbuEttvfMxgEquIHFp/B4gB7+hXzd5g5wi4NkvFPjbjy7zzKmS74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PiF7iLVb; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7024cd9dd3dso2800061b3a.3
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 22:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717480736; x=1718085536; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gl8nhqFsYbY5YUB00tLeYqld+esrzmjcXavcX0Ll0gA=;
        b=PiF7iLVbrJoJL7maosTgxLeekmSFuRtYFUTX/yjeHIoucEEARFgi042RaHGZuUiFGL
         E69R1Ll5qnvz2QQVLqn2Dxo7TNPtjr2Tuqg2pu7t25L6dzS+l9UHZXSo7suRdkeuoQIJ
         s/Een4fGGkvgYYzkIS6VjUtfjuQUNzjLDgefqxZshzVfS3+f8v5NbCjDqhty0iyB31ql
         lxrd7iLSl0S+e5RXy0IUFior4a6fT1WWLADac7rUWPBJ0tzvCucvUx+hP1/HLIN5l1ej
         EIFdFzZptI13NRb08D3y5VGN74U6rCCxZQhr1BNNFRFqLRl0AVsyRWNrxFPH9xlJ1f+M
         Ddjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717480736; x=1718085536;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gl8nhqFsYbY5YUB00tLeYqld+esrzmjcXavcX0Ll0gA=;
        b=bi/hfTJXVzYaz8vTV7f6xqvRHA/eSh2ZxAtWfyJoPNh4F5ofB8Jsd55yozpoqXiPL4
         5zON//KB+cLqPKF0eN7SjmSQeh9Xjy39OffDNhSd3xJ4QBprRPLisidFJcLKj/1mIeJJ
         WVF9DYbMMoPLd6lHitW1B5Cm1HB2HZE9i4ryNDwS8icYeC4ucMA60nXsOH8tQtW/IsO/
         u6cXkX6Zw7mIybra6yRUUrOBGssySZjlgqRqlTex+oJRNkfRTAlCkXehEvggUiISn/Nn
         FEcB2mPpJ+dE4QiySSFLIEnl9K/mlVoadcBV19abFaD9qfQ100TKqup6KxiHLJ1N6/SB
         R/WA==
X-Forwarded-Encrypted: i=1; AJvYcCV9VB5K8B1Si8EmHRiPYILgi+dh3dbUX/m0+RQHj9N6jSx09H71MWD4ZbXOATszgTooTr6oiQzM8uHYUbL6SGimucFA
X-Gm-Message-State: AOJu0YxYoOhG1Kl5hS05DlBerrlr2051ejABHUqnnGmjbnM/1crtTdax
	XaODGcgs3qZUSCn4xEDJBzCGL/1f+VpgxO3I5+ZZtr+yj7uFDaKE
X-Google-Smtp-Source: AGHT+IEUimO7kKL5JzPZ4X9UjN4s4Rov2b/FPNTv9+n2YcOTF0OmtGxebNsWC6ZgEm82JBiWDYR9bw==
X-Received: by 2002:a05:6a00:23c6:b0:6ed:41f3:431d with SMTP id d2e1a72fcca58-70247666e1bmr12408633b3a.0.1717480736101;
        Mon, 03 Jun 2024 22:58:56 -0700 (PDT)
Received: from localhost ([1.146.11.115])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702425d9aeasm6373462b3a.50.2024.06.03.22.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 22:58:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Jun 2024 15:58:49 +1000
Message-Id: <D1R03V1KZTWF.2BW5FQ7M7SGZ9@gmail.com>
To: "Shivaprasad G Bhat" <sbhat@linux.ibm.com>, <cohuck@redhat.com>,
 <pbonzini@redhat.com>, <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>
Cc: <mst@redhat.com>, <danielhb413@gmail.com>, <qemu-ppc@nongnu.org>
Subject: Re: [PATCH 2/2] target/ppc/cpu_init: Synchronize HASHKEYR with KVM
 for migration
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.17.0
References: <171741555734.11675.17428208097186191736.stgit@c0c876608f2d>
 <171741557432.11675.11683958406314165970.stgit@c0c876608f2d>
In-Reply-To: <171741557432.11675.11683958406314165970.stgit@c0c876608f2d>

On Mon Jun 3, 2024 at 9:53 PM AEST, Shivaprasad G Bhat wrote:
> The patch enables HASHKEYR migration by hooking with the
> "KVM one reg" ID KVM_REG_PPC_HASHKEYR.
>
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
>  linux-headers/asm-powerpc/kvm.h |    1 +
>  target/ppc/cpu_init.c           |    4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/linux-headers/asm-powerpc/kvm.h b/linux-headers/asm-powerpc/=
kvm.h
> index fcb947f656..23a0af739c 100644
> --- a/linux-headers/asm-powerpc/kvm.h
> +++ b/linux-headers/asm-powerpc/kvm.h
> @@ -646,6 +646,7 @@ struct kvm_ppc_cpu_char {
>  #define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc4)
>  #define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc5)
>  #define KVM_REG_PPC_DEXCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc6)
> +#define KVM_REG_PPC_HASHKEYR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc7)
> =20
>  /* Transactional Memory checkpointed state:
>   * This is all GPRs, all VSX regs and a subset of SPRs
> diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
> index b1422c2eab..cee0a609eb 100644
> --- a/target/ppc/cpu_init.c
> +++ b/target/ppc/cpu_init.c
> @@ -5805,10 +5805,10 @@ static void register_power10_hash_sprs(CPUPPCStat=
e *env)
>          ((uint64_t)g_rand_int(rand) << 32) | (uint64_t)g_rand_int(rand);
>      g_rand_free(rand);
>  #endif
> -    spr_register(env, SPR_HASHKEYR, "HASHKEYR",
> +    spr_register_kvm(env, SPR_HASHKEYR, "HASHKEYR",
>              SPR_NOACCESS, SPR_NOACCESS,
>              &spr_read_generic, &spr_write_generic,
> -            hashkeyr_initial_value);
> +            KVM_REG_PPC_HASHKEYR, hashkeyr_initial_value);
>      spr_register_hv(env, SPR_HASHPKEYR, "HASHPKEYR",
>              SPR_NOACCESS, SPR_NOACCESS,
>              SPR_NOACCESS, SPR_NOACCESS,

Hmm... now that I look at it, the hashpkey value also needs to be set
in the machine and migrated, right? That looks broken. I *think* if we
make this spr_register_kvm_hv, and you will also need to add a KVM
API for the register, that should get it working becuse SPRs will
be migrated for us.

Thanks,
Nick

