Return-Path: <kvm+bounces-55039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76B51B2CD5C
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 21:53:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 567472A5E39
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 19:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A38D3101AA;
	Tue, 19 Aug 2025 19:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YToC+FKT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7C752F99
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 19:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755633223; cv=none; b=j0xkCpxrr6dqmFRtQMN7pi26s29ObIojMMBItXLkpNpbPefg8m9cR6XTypL0qSnSEM+tUm4KYjltUNs4KivkKTtk0Qge5qQ9dSv2voAHN7sstFKyEWcHHiAU57NM04DCxklPdUeWyDSSGXSaBxRkOJ73TFUh2Vtslnubc12bmBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755633223; c=relaxed/simple;
	bh=fS6j4mgWa9VcBbnm1aYEVqbu0SbI+LKwaOyUx0Dl64w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P9MQAkvDn5lvAyxQmXkc8XJgdahlPz8b5AAT8rtZmAqGCcukRsvP8a9QmgpkVwfY2PyF76v00gNSiaYqLKZ+JlI3z6JH9HmcySS64YJum417OoIZ4kS4jZGIGt/PFHK+oDlSb/F1g6j93q1YgxEzHdCid6Rr+LNnFtUICk9ZQ9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YToC+FKT; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-242d1e947feso52065ad.0
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 12:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755633222; x=1756238022; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FNbjqk8ttaB1ro/8zTt9BTLxqyHuv5ELRRxuG73JV9U=;
        b=YToC+FKT+vj5xe3mYSuiQrxDnA9d17Mbog75ZSu9LgZ2hcwfro5NxeATdJuPyoXPa9
         2HaDCHVZlLHfYLr+ignzGbiRUAdS2tfn9n3QXNfOmDIwxQxUTUkucyeLLE2ir5uyRwUT
         uCi6WByZu2dJw06RJCv6mnCtxGTsuDmtNv89nrBpQFH656SNVE0K2y0a1iUTAn0U/cH4
         tTsnILM/C7B1wMWoHi1JGOgolywRHggsGcqpMMGKhdW6+eLBhwHTl1/HJsrZeIYR0hLl
         1mYvEVDT9epJJFYL/KUxhKhT0vdAYTSD+pNOe+6VKyW+gXhHlWzQT7QfXS+C7i7sGRMF
         xlVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755633222; x=1756238022;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FNbjqk8ttaB1ro/8zTt9BTLxqyHuv5ELRRxuG73JV9U=;
        b=Z3XjgQid/d1FoojVwPFjF7Xg+Iwo+sJ5qr3G9A1UWmLDX1fPslObOEZ9NWm2Rf/2YZ
         B4QJWFDWp6fw4AB7AdaHlOXiFMiMB64CsI/+gHd7K7Go6sYTipTLXprmWsel+1aH9hWf
         YVjV/GKYS/dL958giFO/tiL0qt+gMg48u/rMoxwXtl0VeG/1w3ojEF2IffYCMSBrKo40
         vkVc3GtAXQeaoeRy0XJCwiCLbuh04cAd1HEk4ncJXS+gUTHvzOebnzMCbJI1xFfhGKVv
         RD3pKVVBdm38KjHq3mT+76XaHecTn6Jfxbg4D0WufRUJy8MLI5JgrZdIA5CgKc3Ews5G
         RXKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZbjw9ZEqce2/U+jTQqHxWUkjXj5m83xuGB/oiHtGlwmJz2i1cvKyQ1A5WO8TPgw7E5hk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1zeT/Q9NScBd7IH458wOLlz+Yi6aOi/ILfSUHp3hNlookbnbT
	zIrI3yfPgy2AmerSqzPgm/E0LDxGHV+6eethZWcfcMBgWsAlhh0zMK/8TAkIsLNjvk3rPASEAF5
	B79EJYxDETzq/F7C/nDQGxuDu71wfWrybJUAQ+csL
X-Gm-Gg: ASbGncu09iLyBkT4Cz2c8bS0nOB5ymQE+61ZnlJmM6CMZf0Zt92vhgZnWHJ8LumXcGc
	VWEBhK6wxc2Uzs9JxDm9E328dGxUo1Ue+sKuq86bOJ/k4HWaN/W5u3s4SMg28R2MYyugWRqDFXn
	fK4nv0smXV1jHrLM+Z2s2WhXvgcOqvr8PfFlKGGxxApovGxeBk9ZctpW8WVMileaSQom3wai7Qv
	X+n4Z7DUXpIEdEX7TNVyhf5LCqC1KrQwXIKyxgiK2Et
X-Google-Smtp-Source: AGHT+IG4CJE3FrmMgTu10qv+0+tLItc8I/b4fe1ou2jr3vSGPnHMMk3cVAozTTrsTuTDIcAYq5uyhlT4NUWU1Gr5ayk=
X-Received: by 2002:a17:902:f64e:b0:240:3521:1345 with SMTP id
 d9443c01a7336-245eeb80067mr604135ad.17.1755633221217; Tue, 19 Aug 2025
 12:53:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250819155811.136099-1-adrian.hunter@intel.com> <20250819155811.136099-4-adrian.hunter@intel.com>
In-Reply-To: <20250819155811.136099-4-adrian.hunter@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 19 Aug 2025 12:53:29 -0700
X-Gm-Features: Ac12FXxiS5LogQBLTdGRUCr_RpTV5puNW2fnnQ0DolA4sVJEIHlcEAIFzo6FHOk
Message-ID: <CAGtprH-es5yyNYQCBhwpq2sJb2ET+Jvq+YNB+zvrdatCXqhZDQ@mail.gmail.com>
Subject: Re: [PATCH V7 3/3] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, pbonzini@redhat.com, seanjc@google.com, 
	Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org, H Peter Anvin <hpa@zytor.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kas@kernel.org, kai.huang@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@linux.intel.com, 
	binbin.wu@linux.intel.com, isaku.yamahata@intel.com, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025 at 8:58=E2=80=AFAM Adrian Hunter <adrian.hunter@intel.=
com> wrote:
>
> Avoid clearing reclaimed TDX private pages unless the platform is affecte=
d
> by the X86_BUG_TDX_PW_MCE erratum. This significantly reduces VM shutdown
> time on unaffected systems.
>
> Background
>
> KVM currently clears reclaimed TDX private pages using MOVDIR64B, which:
>
>    - Clears the TD Owner bit (which identifies TDX private memory) and
>      integrity metadata without triggering integrity violations.
>    - Clears poison from cache lines without consuming it, avoiding MCEs o=
n
>      access (refer TDX Module Base spec. 1348549-006US section 6.5.
>      Handling Machine Check Events during Guest TD Operation).
>
> The TDX module also uses MOVDIR64B to initialize private pages before use=
.
> If cache flushing is needed, it sets TDX_FEATURES.CLFLUSH_BEFORE_ALLOC.
> However, KVM currently flushes unconditionally, refer commit 94c477a751c7=
b
> ("x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages")
>
> In contrast, when private pages are reclaimed, the TDX Module handles
> flushing via the TDH.PHYMEM.CACHE.WB SEAMCALL.
>
> Problem
>
> Clearing all private pages during VM shutdown is costly. For guests
> with a large amount of memory it can take minutes.
>
> Solution
>
> TDX Module Base Architecture spec. documents that private pages reclaimed
> from a TD should be initialized using MOVDIR64B, in order to avoid
> integrity violation or TD bit mismatch detection when later being read
> using a shared HKID, refer April 2025 spec. "Page Initialization" in
> section "8.6.2. Platforms not Using ACT: Required Cache Flush and
> Initialization by the Host VMM"
>
> That is an overstatement and will be clarified in coming versions of the
> spec. In fact, as outlined in "Table 16.2: Non-ACT Platforms Checks on
> Memory" and "Table 16.3: Non-ACT Platforms Checks on Memory Reads in Li
> Mode" in the same spec, there is no issue accessing such reclaimed pages
> using a shared key that does not have integrity enabled. Linux always use=
s
> KeyID 0 which never has integrity enabled. KeyID 0 is also the TME KeyID
> which disallows integrity, refer "TME Policy/Encryption Algorithm" bit
> description in "Intel Architecture Memory Encryption Technologies" spec
> version 1.6 April 2025. So there is no need to clear pages to avoid
> integrity violations.
>
> There remains a risk of poison consumption. However, in the context of
> TDX, it is expected that there would be a machine check associated with t=
he
> original poisoning. On some platforms that results in a panic. However
> platforms may support "SEAM_NR" Machine Check capability, in which case
> Linux machine check handler marks the page as poisoned, which prevents it
> from being allocated anymore, refer commit 7911f145de5fe ("x86/mce:
> Implement recovery for errors in TDX/SEAM non-root mode")
>
> Improvement
>
> By skipping the clearing step on unaffected platforms, shutdown time
> can improve by up to 40%.
>
> On platforms with the X86_BUG_TDX_PW_MCE erratum (SPR and EMR), continue
> clearing because these platforms may trigger poison on partial writes to
> previously-private pages, even with KeyID 0, refer commit 1e536e1068970
> ("x86/cpu: Detect TDX partial write machine check erratum")
>
> Reviewed-by: Kirill A. Shutemov <kas@kernel.org>
> Acked-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Vishal Annapurve <vannapurve@google.com>

