Return-Path: <kvm+bounces-13329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3FB4894A35
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 05:58:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 410551F23FFE
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 03:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9AB1175A1;
	Tue,  2 Apr 2024 03:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="kPMRdRD9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E111426F
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 03:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712030281; cv=none; b=q8WRn0Ar5AAtYsd/cXKRzK/lt+JGf0MO5D0gQKUGaH4inNULjVH7lKzkcxu1YcfVASiALzRwNXIfP8YVZAW+eWDzoNAI4gTXC5JeWVSgLokZ/Cl2L4x7xFNRQpD1/2DD2aUmSvEpdBlrR0cRXAvflOulR6PYiIGi32J8C4nhMW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712030281; c=relaxed/simple;
	bh=tyVLhtmPJWAmFie25BBkUfhWuVb3hRPmqqATLUps3i0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sat8NukYQRwxbhUx+2T+To1EbignS8nnIw11y4b9X4JdupNpuk8Mf+yFue6GEac4X3qN3tqTQ0h3Psd9P0iMZEs7jlw7Q9JfxYTHa9B9cogjKMJABJl+COz481TbjiduxlTbYSXdljFNywxM9e6x0+8e6JMIVUbLHrawZ/eeoL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=kPMRdRD9; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-36899d11c2cso16198745ab.1
        for <kvm@vger.kernel.org>; Mon, 01 Apr 2024 20:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1712030279; x=1712635079; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DtV8SMERfeTzEpYWil2z5b9TZfic9o3ikGpE1jdHQFk=;
        b=kPMRdRD9/1e3rHYC41tdSBVPily6y6ow3sWS0tx9VtGb4J7Ts0lHHTok5Hr3bW2oUx
         vVyqohNFJ3usClaA+0l38xyhpx8eUl7UVX0hPyldq9+f6T9CtS9puzNlj+zoEvDVVxxp
         JUFSlMAsVc+K3h+YzH4GdWNkMlxu06xBz7YHTOEZ3TJxNr7qJnpgJyfJxSSFW6CP7MwV
         U+5XvFXhxEhHNbFWvtDH6AhjqEe0b2hv1RvpFrK1Q/dHmqqhGksBcGRROHzeUROq3dP3
         s9AKFNG8mYjQ+zm2+LhNUu9cXAElfPw9CazKYD3NbDTT9FLvEgUQnkoDakUQRUsm0+f6
         njCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712030279; x=1712635079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DtV8SMERfeTzEpYWil2z5b9TZfic9o3ikGpE1jdHQFk=;
        b=fGkOJGC9r6wrXHMoMIqhV+p1tKkQrGodqgNZT4y9GgdnyjAre5g3Ty1bP2TKTWKmQy
         zhGVlMz9v05wwNj/RiRXqfqFOMd3g5DvZEo+ONAFSfO1tju0cdjw2TPAedYmLYTiSCMp
         Avo0rjT1OvK1ttD9dDWEpYu5Z0efIo9/FT2viriKxKsmauiNF3H/Fl9d1aQprw8SfJhV
         BQ0FsMNIT/XQgnMDUhN52IwLm7rCxDOR7f6AvR2be0PIqBt4i2cValrB4W/KVkrzoh3u
         6h0hLTf6Q4elgm8qz19RmHUceemvRReiIX1D09uYneIAer+527kUaaYXZTMAg9ZCMcnc
         JQmw==
X-Gm-Message-State: AOJu0YyHgevSxvBlGE91UrV4ReBjAss/bRP45Fslsh2AaX2ZZqTiFW7F
	IwYTL/Ke0rDWE3Gh4CHwYMWok6xtKRR4ZMpKZgTxEoJaqlvjqM6b3F8sh3+L68aKKhoHjX8A1su
	1wqbdqBSXdKlPmnL+itfSIMJfudRP3FS3x8THlUZYeqzDXrvZt3khLw==
X-Google-Smtp-Source: AGHT+IEkXpEtaL94+3HzCYUoKj647VDtpL03CdvZB6qY7qksejyCkNPx8JwaSql9n6tdrZXd+ajjaLR5+OD8fcy5EcI=
X-Received: by 2002:a05:6e02:156e:b0:369:aaa9:a08c with SMTP id
 k14-20020a056e02156e00b00369aaa9a08cmr4021173ilu.16.1712030278776; Mon, 01
 Apr 2024 20:57:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240327075526.31855-1-duchao@eswincomputing.com> <20240327075526.31855-3-duchao@eswincomputing.com>
In-Reply-To: <20240327075526.31855-3-duchao@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 2 Apr 2024 09:27:47 +0530
Message-ID: <CAAhSdy3nHK294Mpe+P2S8MDYgR+K2Zbb5RT4ER8zhZP=YvTQkQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] RISC-V: KVM: Handle breakpoint exits for VCPU
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, atishp@atishpatra.org, 
	pbonzini@redhat.com, shuah@kernel.org, dbarboza@ventanamicro.com, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	haibo1.xu@intel.com, duchao713@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2024 at 1:29=E2=80=AFPM Chao Du <duchao@eswincomputing.com>=
 wrote:
>
> Exit to userspace for breakpoint traps. Set the exit_reason as
> KVM_EXIT_DEBUG before exit.
>
> Signed-off-by: Chao Du <duchao@eswincomputing.com>

I had already given Reviewed-by for this patch. In future, please include
tags obtained in previous patch revision over here otherwise reviewers
end-up wasting time reviewing already reviewed patches.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_exit.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index 2415722c01b8..5761f95abb60 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -204,6 +204,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struc=
t kvm_run *run,
>                 if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
>                         ret =3D kvm_riscv_vcpu_sbi_ecall(vcpu, run);
>                 break;
> +       case EXC_BREAKPOINT:
> +               run->exit_reason =3D KVM_EXIT_DEBUG;
> +               ret =3D 0;
> +               break;
>         default:
>                 break;
>         }
> --
> 2.17.1
>

