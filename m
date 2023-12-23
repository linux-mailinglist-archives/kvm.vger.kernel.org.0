Return-Path: <kvm+bounces-5191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62F2B81D270
	for <lists+kvm@lfdr.de>; Sat, 23 Dec 2023 06:19:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1346F1F22B31
	for <lists+kvm@lfdr.de>; Sat, 23 Dec 2023 05:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 717C34C69;
	Sat, 23 Dec 2023 05:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q2W5ZfnX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7376C4A34;
	Sat, 23 Dec 2023 05:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-35fd9e40039so7706495ab.1;
        Fri, 22 Dec 2023 21:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703308735; x=1703913535; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XnwDpdbEms0r9ctWFykUHT4Fg9JnNMIjKFVXl1aMRgY=;
        b=Q2W5ZfnXAc2TcOqXmYv8i4TYy+KAvVXQPoZcHirjPh2l72VlM2uyCV9SgMCeIF6bsP
         oQtfLFGOVt4/dQhk5zSCIOONlglHm+ah7daxKtXYajnrKAuvOZFknyUleWUqhiL5twAb
         p23w/PQOXsk58vyqUrSq6hfJl4cIiaHYgeQvyBzLeMKG2b5cIuRhNBoxZ2k2LeieijgT
         loZregHNbFTCnZbEHoZWi/B+MNUhoJC0Aj00d9f2eGARUgTCPjrby/4ltH/+bVkrXcYU
         XhlBLRQA+1fnl3Ue/kaaPRMuPRJicqvr9dmNRiXhIv2OBXdonVt6sqb4SpyntZdUXk68
         ZUwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703308735; x=1703913535;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XnwDpdbEms0r9ctWFykUHT4Fg9JnNMIjKFVXl1aMRgY=;
        b=DDyyLk0GDXaeXlle4ZuJ5MhtsxGAF+VpCrR7jov62H0eKBVyJqOb867qKPlOGMXQep
         wQj05CucH+Vl/jpXmqGJ4nXeRGVo+xqI1LAO1aKd8FgtLTGb9KrvgBw6O/7niO8Wl3DI
         epdpC1cicW197XStUoC/kCu3piJzgR1WJxB09+N7iUGfwL6gvQCGCGFaODEAdI+Rg77a
         qB6rBS4BWecUm9gm1kGDeEchx8jEKzTsMljfIwQ5O8QGm6lzbf9pwMdZg+HD5EMC9AIf
         Lgho89c/zyS/FatcDktNt1xYC28Z4UnZ5kPY3VzEZMHfW5QjoPeJnsrsvuLjc0cuKQss
         d+BQ==
X-Gm-Message-State: AOJu0Ywj6A841gEzkrt1qxGzLli3Et8v6ZOidxD/tDn2DTMVkcWpwkg/
	isAu4ZwSit0EJZ1nbHj/bjQ=
X-Google-Smtp-Source: AGHT+IFaHzlucHRk+1cz9vp3pAi/3gV++IZOiVArAG66rH8YvEuO0wUOoZEKgYXgJDJX2cMfaNfq+A==
X-Received: by 2002:a05:6e02:1707:b0:35f:e71f:4c60 with SMTP id u7-20020a056e02170700b0035fe71f4c60mr2472288ill.13.1703308735520;
        Fri, 22 Dec 2023 21:18:55 -0800 (PST)
Received: from localhost ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id c6-20020a17090a020600b0028aed79c244sm3641553pjc.1.2023.12.22.21.18.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Dec 2023 21:18:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 23 Dec 2023 15:18:45 +1000
Message-Id: <CXVGJUAN6935.1L9WYI8NQ4R0O@wheely>
Cc: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>, "Laurent
 Vivier" <lvivier@redhat.com>, "Shaoqin Huang" <shahuang@redhat.com>,
 "Andrew Jones" <andrew.jones@linux.dev>, "Nico Boehr" <nrb@linux.ibm.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, "Alexandru Elisei"
 <alexandru.elisei@arm.com>, "Eric Auger" <eric.auger@redhat.com>, "Janosch
 Frank" <frankja@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
 <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH 1/9] s390x: clean lib/auxinfo.o
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>
X-Mailer: aerc 0.15.2
References: <20231222135048.1924672-1-npiggin@gmail.com>
 <20231222135048.1924672-2-npiggin@gmail.com>
 <20231222160414.5175ebba@p-imbrenda>
In-Reply-To: <20231222160414.5175ebba@p-imbrenda>

On Sat Dec 23, 2023 at 1:04 AM AEST, Claudio Imbrenda wrote:
> On Fri, 22 Dec 2023 23:50:40 +1000
> Nicholas Piggin <npiggin@gmail.com> wrote:
>
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >  s390x/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/s390x/Makefile b/s390x/Makefile
> > index f79fd009..95ef9533 100644
> > --- a/s390x/Makefile
> > +++ b/s390x/Makefile
> > @@ -227,7 +227,7 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-o=
ffsets)
> > =20
> > =20
> >  arch_clean: asm_offsets_clean
> > -	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*o=
bj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-=
key)
> > +	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*o=
bj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d lib/aux=
info.o $(comm-key)
>
> it seems other architectures don't need to do the cleanp? what are we
> doing wrong?

x86 does clean it via cflatobjs. arm and powerpc never build the .o
AFAIKS.

Thanks,
Nick

