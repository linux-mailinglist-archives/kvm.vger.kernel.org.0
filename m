Return-Path: <kvm+bounces-39871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F586A4BFDB
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 13:08:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E02C16BE99
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 12:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0DE920E313;
	Mon,  3 Mar 2025 12:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gmqbQPQH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A9B20E333
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 12:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741003661; cv=none; b=POBYyCUIe+cWwMct58Hps9lrajME7wW28LJSjaUK7GqxfXL8jdZ2JZxnTZ4qDl8Zo6AAPOgUF/1bTvPdLjjYw/H3yxpXlhLgi5oMcGLQD2jiZQwUR+aGwpQifTwexyEq00kXDVrjPvCpwtgwwwJsPpCayFljJeF82V0vjxloLjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741003661; c=relaxed/simple;
	bh=uju7sIH5BGh5W5JTJZHooDHmsXtbGtIZ2zwKahZ89tE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=brFPxdaMjXyji2lxYk4QZlX3HadHoBjPja7cnFDFlD+x3ca6yz0SZW8xX94RJk3jx5e6Q1kDcHUodK1CMNsVytZXf2slVOygLzhqrvOthRN6SDPQFQfBQwTTneAv8okBaDV6IjgJde2Wgx4yrdRWRVqogxIUiUmETrW9zCNFeeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gmqbQPQH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741003658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fw9/y9pO0Tgw7qMRxrC2z9OKO7bwRqJ7EcWxU9xvHxE=;
	b=gmqbQPQHo791kKnZNlAwQ2WG8QhP9DjrBjXU3zcVXamO33ueoXgjyOvC6wwe/j1ig12UV5
	hK26v7YCtKq/V6x0bopmKMEqUSqBq414eUcp8xxdg3SGwhcBfSm5tKyAWRQGLDKuvS0Ku4
	NvjVyPAG84vPrY7MPtyNHEHPIA0Wkk8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246-dzSe4f8UOw2hTU_rq6tQlg-1; Mon, 03 Mar 2025 07:07:32 -0500
X-MC-Unique: dzSe4f8UOw2hTU_rq6tQlg-1
X-Mimecast-MFC-AGG-ID: dzSe4f8UOw2hTU_rq6tQlg_1741003651
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-390de58dc4eso4030995f8f.0
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 04:07:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741003651; x=1741608451;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fw9/y9pO0Tgw7qMRxrC2z9OKO7bwRqJ7EcWxU9xvHxE=;
        b=dh+1z9SJKGfa1tnte3HjnSKxL3fFDznbRSwebOoLZCO9s6d/EtAHvhsjoeSuRTVX70
         RvUEsM/RYATfVpFOpvU5nhIsdddGrGueB6bQ1LOUt9vjMi2CjfWvPwnN5dJfwy3ozHbo
         Ak+sJNME6piZO+Yizj25x+pReMznHoMwA66BgaHFeuny+/sOMKzL2/aapC98I1hGMebs
         1ay8B+nueGu0S7wVgEjIMDIKsYUb0b8NUe3N5NAN6YHr8mV0XnS4rNFd0odk1rHD/Cd1
         lm+hecuru7UGxezyqPWiMHtW5lY5vNmyIuz49GTc5D6CpIAzmNQtzYrjHh3WspObWTyH
         i8KQ==
X-Forwarded-Encrypted: i=1; AJvYcCXboGAa7dKexOBeMiHGngkrWrjicy0S566FZ9LvD0wiAoPeZ3/hotYqcpxyyRb4YvTHid8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrUR+Yrtvgaemtfi/oBZOzVnqEHcadjmFOjklcwY1NstxVXCcO
	0BgtYCB5rdMaUn/UQDFWs2K9DiIy6x1BzO8gYexkdIqoO+QZVFEwiLmYqTDO4bt32GtVP8D24eY
	TJaHbf+WFi8YYbz0+NwlAT1tB3JYhhTsefzIINwnS7h1r2tV1DSeL/U+UWc+8sHQ6yxt1F4JjCO
	vmIIEsJ4SNL+6K779+/oPlI9Xa
X-Gm-Gg: ASbGncs7ECpI7UGHHXAfARo3UI14NkDwb9PsblIFVpghjMyVHP1UuZn+fobwj1TZ34U
	F8meBh+V4EMsIX+EY/i+FbGXgyHC62iGl2HZSLUKnJxx1DSOrL5Ggs9l3SWblEc7sVd7mw0FP
X-Received: by 2002:a05:6000:1543:b0:390:ef45:1a37 with SMTP id ffacd0b85a97d-390ef451caemr10434832f8f.55.1741003650997;
        Mon, 03 Mar 2025 04:07:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQibAQBZKGLMDrS/FjVYTrJktgwlJ/8V2jDfRODdesJgHBiBswiP6BF/IeHZ/V6AALHag0O/R4QLX3SW+KpHI=
X-Received: by 2002:a05:6000:1543:b0:390:ef45:1a37 with SMTP id
 ffacd0b85a97d-390ef451caemr10434799f8f.55.1741003650538; Mon, 03 Mar 2025
 04:07:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202503021436.STomlZOE-lkp@intel.com>
In-Reply-To: <202503021436.STomlZOE-lkp@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 3 Mar 2025 13:07:18 +0100
X-Gm-Features: AQ5f1JoWiKKm2LeQHKrPeE63Zh1-iaGQM-Bm15TiuDzT9_6uJl3yL4GkD6PHv6U
Message-ID: <CABgObfYnELV3FjMgZRASi4p6Hmp67yBLJngyLWbbp23czhHFFA@mail.gmail.com>
Subject: Re: [kvm:kvm-coco-queue 20/127] ERROR: modpost: "enable_tdx"
 [arch/x86/kvm/kvm-intel.ko] undefined!
To: kernel test robot <lkp@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org, 
	Farrah Chen <farrah.chen@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 2, 2025 at 7:25=E2=80=AFAM kernel test robot <lkp@intel.com> wr=
ote:
>
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue
> head:   9fe4541afcfad987d39790f0a40527af190bf0dd
> commit: a58e01fec9ad144302cd8dfc0b6524315cdb2883 [20/127] KVM: TDX: Add p=
laceholders for TDX VM/vCPU structures
> config: x86_64-randconfig-077-20250302 (https://download.01.org/0day-ci/a=
rchive/20250302/202503021436.STomlZOE-lkp@intel.com/config)
> compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd70=
8029e0b2869e80abe31ddb175f7c35361f90)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20250302/202503021436.STomlZOE-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202503021436.STomlZOE-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>, old ones prefixed by <<):
>
> >> ERROR: modpost: "enable_tdx" [arch/x86/kvm/kvm-intel.ko] undefined!
> ERROR: modpost: "tdx_cleanup" [arch/x86/kvm/kvm-intel.ko] undefined!
> ERROR: modpost: "tdx_bringup" [arch/x86/kvm/kvm-intel.ko] undefined!

All these failures are solved the same way, just

diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index fc013c8816f1..e8a3657d716e 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -2,7 +2,7 @@
 #ifndef __KVM_X86_VMX_TDX_H
 #define __KVM_X86_VMX_TDX_H

-#ifdef CONFIG_INTEL_TDX_HOST
+#ifdef CONFIG_KVM_INTEL_TDX
 int tdx_bringup(void);
 void tdx_cleanup(void);

Will apply to kvm-coco-queue.

Paolo


