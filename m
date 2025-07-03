Return-Path: <kvm+bounces-51505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26D57AF7E5F
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4273A3B3AD6
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C3CC25A340;
	Thu,  3 Jul 2025 17:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OY1d3Aj0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EC1229B2E
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751562411; cv=none; b=JribPtbZjhx1oKZWjrw0bOfTX0HPfg+CTOOsGlQGSTGXr/LXghcnvmHopjKpOrvQIyhE0i3wfGnOfGd5/qyMoUjBZI57Y2BON8IQD3lcqopXceZGdC23eExbrXqXPul7idXq6k1jIG7tIl+RwWxPx3VLCcWOV5XOiZfCrs1+n+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751562411; c=relaxed/simple;
	bh=XFNc6xwG91kOZJ6aXSGb8CW72Hy9fPOUos38JJjfZ2s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r5n6PkJQraadau24DLRHBCCM1XJgnMvYiHI7t6T+VpXPadPsxCz+4KfjvRIx4qtyhD0QRNo3rFpiSf+GPTpyebwWsGqiVD/QjzhOxDzTpZ6ifuDvifAHr3E6HVRy0K6S4WjtVOEw7sbsQ2XXyO5DHEafuTrwKpnRa2v0NJrQd5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OY1d3Aj0; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-237f270513bso181345ad.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751562409; x=1752167209; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eSF4ELCBcv/ejvNBGx8gge/whzb89lSTMsKN5499Igg=;
        b=OY1d3Aj0iw5mbQ740COCI8giWXRoFvZfX+og0zTyUWIE1/m86YQrk0z45uQHGAQ58W
         N12EUnnhJpAUKrX3GI3wxSe5xVgvDEUdqC/3Cfa0e+zF6RIdGQLJV6w0te69okbWWA3O
         b+px58PehJNqUTMpg5zK32DwhNwD5aGCo0awqzeDLIxA1HOijYd0/4GAPbCFHTpBVS6z
         P4/UxhIskytLXfavh2fdPEvrWEa3JhWaE76OVryl0/MFBNVIt5Kl/HB+ZVnD3h8NDNea
         Zr9O5WSBASCaXte7Z/Sa69dcyKKhXF4CjJ4DuNqT/Q0cKKcDxRqxzEoMHcrot+TACERV
         hjqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751562409; x=1752167209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eSF4ELCBcv/ejvNBGx8gge/whzb89lSTMsKN5499Igg=;
        b=Dla0Y1pZHoEFSaEmCvu2ApIKEakGwuSzxa/p6CaCtNoY0cDO6WJgiPhsjazSM+/LIp
         QzIZTdKoEzpx+8jHHFuh1qJzgplj0j8yU3mIv02+CUzbhR9TnOn8XAAJUS//ydrga+m+
         ytkogX5sj3axzTBqWI/g9t90T27iGTcd9WDJTjyoHMAUFW5VJgTDZnxOb4jWvg/u8Htn
         qLW+4dv1nYGJs4yJXAfgPx9k2MEvqnf8dFfvzd7N1fAnnADBnRRzBpysIJSUQYRgt5De
         97WFueXYZyNGZy4rSY7qwOnXwftb/7K/dxfh1IiSFi1FaSVYMId3Qm7adfQegVtWKgFr
         sxNQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9uOGu23rCLN7YCC9+0afm9YIstFiIg4wh5fE4PtoYvFQyaF7JiSL9ameQr4eSlHepE7M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaSGdblGul50CLU55ZEXTdXIP3qvxw9rxGLAVecaMgivQJ31aZ
	dpAMw2RcVjuX6PS5diMqHzSXMX+r6C0nQUqvDDwIpFdowg4EZUbq6eo/O+4EJI+HngnZT1YHIja
	1ifi9K85rB6xYqiCqpk8KnFtLRQu2MQ3EZxXoGg7s
X-Gm-Gg: ASbGnculUFCc6XNo2RHCzzkRWgRBF0k82ALhjYcwIfwHlhXjj+8SnQT7h2UOXnAoULe
	vubbgVzT9XFJ0sqBpx1QwAxIEDSxe+Tk1NyPpVtDR35y1RCQQSMiCmM0T9H0cpilc5NDZLvacWb
	oyClakSJEm/vCY+owtYXJor7xpqHyuXcTnaEFGueFEb9k/pqGSvlZx2lSu04GZ1lz1TW+5ISTSh
	VfA
X-Google-Smtp-Source: AGHT+IHnnWGdf8QmGd8Hr11wufvvjdMxb9FgDXbu5zs80+5lo9XttQnuQtD5i4SFQ9YHInr7O8nelhdPZGUB0tytAnU=
X-Received: by 2002:a17:903:204b:b0:237:edb8:21c0 with SMTP id
 d9443c01a7336-23c7abfdd72mr1670955ad.11.1751562408792; Thu, 03 Jul 2025
 10:06:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250703153712.155600-1-adrian.hunter@intel.com> <20250703153712.155600-3-adrian.hunter@intel.com>
In-Reply-To: <20250703153712.155600-3-adrian.hunter@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Thu, 3 Jul 2025 10:06:36 -0700
X-Gm-Features: Ac12FXzZsjzgSZaYmWaV1ygqhrAm5h_0gcwl11dKry4BPYHYYH2L_GTimadldqw
Message-ID: <CAGtprH8boLi3PjXqU=bXA8th0s7=XE4gtFL+6wmmGaRqWQvAMw@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, pbonzini@redhat.com, seanjc@google.com, 
	Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org, H Peter Anvin <hpa@zytor.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kirill.shutemov@linux.intel.com, kai.huang@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 3, 2025 at 8:37=E2=80=AFAM Adrian Hunter <adrian.hunter@intel.c=
om> wrote:
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
>      access (refer TDX Module Base spec. 16.5. Handling Machine Check
>      Events during Guest TD Operation).
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

This patch looks good to me.

I would like to raise a related topic, is there any requirement for
zeroing pages on conversion from private to shared before
userspace/guest faults in the gpa ranges as shared?

If the answer is no for all CoCo architectures then guest_memfd can
simply just zero pages on allocation for all it's users and not worry
about zeroing later.

