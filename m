Return-Path: <kvm+bounces-1947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62ACE7EF352
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 14:04:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18E611F25CDF
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 13:04:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67AA931591;
	Fri, 17 Nov 2023 13:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="kq4p4qNs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9902D6C
	for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 05:04:39 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-28041176e77so1539110a91.0
        for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 05:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1700226279; x=1700831079; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6/F1OxU0rX7/2Awza+ieBvlQ9jwzfprHoNUntAoYQeA=;
        b=kq4p4qNsyI5PD1CWUJKQNHfxMljXlGi3/T9UBSLCkuM4zPv8MVAw/NlBJ86UtAbPBo
         jLyYmHJbetcKRIedfu1eoG28XPQwPt7G0qRGKp4JtlDfsW5zFFU5dfPmWPlzqzAATUcK
         bbhw3j+IFpZzcuoGv8tp9B/qGu4UFwLiOEht/UxsYfPqPWPDZXRoMN21XLsDmwFaxfNv
         Dddk78IkA44IqMLir3JJQLNEUjpGh4Za80ylBnwTF7LdEM4Oympco+oDWQvqrDSHGBDf
         xs07FhYP+9hrZE9d++y7sJ2gpmjdtp5UQvOrNspWF5kzMIehciWTqYX2vPs7gQZBw5SA
         Rjpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700226279; x=1700831079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6/F1OxU0rX7/2Awza+ieBvlQ9jwzfprHoNUntAoYQeA=;
        b=hbK/QdURYPqro3n5zhJWdqxTyyIxzB2ZH6xODGZXyPzdpsa4FbDsqOfTrd0lyTzjZw
         T6H/MtnOnRzOebesZEoLCH/TSCMY3LL31MgLKhQcvurHVja08BcZUIkg2HjCmYAdxb4c
         yQ1z4rztCWdqDH/mj+gIK2LVM2CicNBQF4JRaoKGsbtUOPm+WpG542f1G4imB5FhER7h
         kFYIq4ksj7b46c6IsrVCz2r2lFIj9RWoDhNCl9YVDNVQxU9SU+GfIyHa1OwcTMBS1Oim
         p0PeKp6yqhSPUoK1O8cCMgWL+M+mYFG4VuhCHR8tLUxmlDTzhPeb9bnb9bHm4XsPxru/
         mWVg==
X-Gm-Message-State: AOJu0YwWnmSEf4feNJE155Bd2mStzhjb4G5MdEwlrurLqRuyoVtpv02K
	jgdMsq+CkMjLy7CdmuvbO/P9UGQ3P0lEAyFSUbSVgg==
X-Google-Smtp-Source: AGHT+IEtPzE7lEOx2d7Ysp4LwrL/GBmShcmNUU9lJo3FtmpAf6sriMDVi9emlG1mMx8Yan2mKYsw1q3eMsjqCt3Pm70=
X-Received: by 2002:a17:90b:3904:b0:274:8949:d834 with SMTP id
 ob4-20020a17090b390400b002748949d834mr13014202pjb.49.1700226278671; Fri, 17
 Nov 2023 05:04:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231020072140.900967-1-apatel@ventanamicro.com>
 <20231020072140.900967-7-apatel@ventanamicro.com> <2023102113-harsh-trout-be8f@gregkh>
In-Reply-To: <2023102113-harsh-trout-be8f@gregkh>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 17 Nov 2023 18:34:27 +0530
Message-ID: <CAAhSdy1Beq-Qnio3E+Am0jVQ7ECaWa1HH2A1JkWRPN5y8tsgAQ@mail.gmail.com>
Subject: Re: [PATCH v3 6/9] RISC-V: Add stubs for sbi_console_putchar/getchar()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Anup Patel <apatel@ventanamicro.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Conor Dooley <conor@kernel.org>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 21, 2023 at 10:05=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Oct 20, 2023 at 12:51:37PM +0530, Anup Patel wrote:
> > The functions sbi_console_putchar() and sbi_console_getchar() are
> > not defined when CONFIG_RISCV_SBI_V01 is disabled so let us add
> > stub of these functions to avoid "#ifdef" on user side.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/sbi.h | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.=
h
> > index 12dfda6bb924..cbcefa344417 100644
> > --- a/arch/riscv/include/asm/sbi.h
> > +++ b/arch/riscv/include/asm/sbi.h
> > @@ -271,8 +271,13 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned=
 long arg0,
> >                       unsigned long arg3, unsigned long arg4,
> >                       unsigned long arg5);
> >
> > +#ifdef CONFIG_RISCV_SBI_V01
> >  void sbi_console_putchar(int ch);
> >  int sbi_console_getchar(void);
> > +#else
> > +static inline void sbi_console_putchar(int ch) { }
> > +static inline int sbi_console_getchar(void) { return -1; }
>
> Why not return a real error, "-1" isn't that :)

As-per SBI spec, the legacy sbi_console_getchar() returns
-1 upon failure hence the code.

Refer, section 5.3 of the latest SBI spec
https://github.com/riscv-non-isa/riscv-sbi-doc/releases/download/commit-fe4=
562532a9cc57e5743b6466946c5e5c98c73ca/riscv-sbi.pdf

Although, the users of this function only expect a negative
value upon failure so better to return proper error code here.

I will update.

>
> thanks,
>
> greg k-h
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

Regards,
Anup

