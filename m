Return-Path: <kvm+bounces-67957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EE4B0D1A5EC
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:45:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6824B302B128
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 16:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CAE63126B7;
	Tue, 13 Jan 2026 16:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zOxgo5f1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D782EBBAA
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 16:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768322427; cv=pass; b=jIUH0e1lpYBUu8adI9tFNcVmWfa1s9F5iPq5c8wmfaXPkdt5fC94S7rs4OMxBPrQuDkEAHkHY+0A/2glnphLDNrpEyVEVPXp7wDYa7CF76FWv6jeXxOM0j/qxcXCacTpoC3rHNXiPv5JedFEk+K347QOwF6q0sHNj333C4k1UU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768322427; c=relaxed/simple;
	bh=g2b+HFILm5fmi7HZl6BNlQQqvxbFCfKuf++FZBc6GWM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=suiq9c1llFaVejtbgBQ2Q/4dhMUHyDbdQJY7z3dhmOxnS7wC3I2JtCdD6AurOdQHDAT0z2x5Z86XSKA7K3GbJXlCgEz2ckarZiQIsFJ/Xbo29V33M0hCF0hYWUt58f0R7u5TWzdfpMwLGeesdfwEfM2BRjglKcR4ExzVcoleDXg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zOxgo5f1; arc=pass smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-12331482a4dso5206c88.1
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 08:40:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768322425; cv=none;
        d=google.com; s=arc-20240605;
        b=Rq67rSPKYMR2k67JsRkfK1ELqCTdFq1SAZSV8prin3T5/GzLL+dzkjEfXfwLRGN8ij
         vTYcHRz1BD98hXNBtQqTIMU/InJ7UB9uUzu4CPCFKP6hK+fKrGT96CpDaNKrgh843sDC
         Oz3k7l/JXEmreqDi4Wv4E2Wc0LgRPRpGBRD60rNkgLYql4VHQPwE+vFuBvHRVOsfUV/t
         eINjPrhb/62i1lLh1YbO6jbJFL3xH2iJ33+DYvOGtY7mtD0eyG2g7QnR91oXkB6diDOf
         MWHeW+vB4MUYKzeC9YxeaWlaQhM7Y5djTk3N16DroNpfY73h6jfkKpk5s9qfxhHnct6P
         Jw3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Vs3/bf9opBXXo4IPo2eIhuvgO3/Md3pR7YNVkSRRcFI=;
        fh=/v+yIR9nPIv3Qz/LEpidRVMKSYzP4fU9jaHTScd0Vd8=;
        b=kSYxwt9WHX5rpVwsBKAYHOXjVpOzKXoIeWljW/gI2IZm94e+fLW0aA4c8F1Pb649eZ
         Y3pvanNUqLQS5eiQM2oH4xoMr4MVdMVScUOnmWfQsOSEmn7VhKyayFPzet/mobhzC7VT
         SJgpPgBrl/ejg1ZLw88NtcMnDEx+xzbkxOBnE4/d68VRU3103tEiI0okT0yqdyYtNM5X
         Kf1+K/Npbgz8trU+7ANnz4IqEc57VcWiMmQXWrHPU8FmUYBwl7lptgk06FrD3uejZqhV
         ZAVuvkmu1KFtBsXtUt3opKPVLdjZUc3LSq2RnXCdk517aCx0dVZFsMWrtfhUbS5gbLtW
         aNqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768322425; x=1768927225; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vs3/bf9opBXXo4IPo2eIhuvgO3/Md3pR7YNVkSRRcFI=;
        b=zOxgo5f1Y3JCsbJbmrbPHlwpZFrtpfr7ya/CgEhBxbso2S3rX3g/RBvdGvmJJwbXZA
         H85/eb91ojilS5Bvs9h/ja/W8YbJu/nQsE13qxNtGHrrld4Ay16dIrN5L8aTFogOrcbG
         uwh+b8mTji7GZ5Qtc4f27uCvTfw6WkcxtOdbS6qgMTiNvbrRXxcr20sr5JPMadPrPqXB
         +q7Vgw+OdaCa2g0QgnJJ3V6+TQzs6NM5tZc/7eSwr5GG/PbVaBfIopSmLUe+m+OMmql5
         CG/lmVoIGYeFmzkc9gicJfV8nO0V5EGYVn54crJZ/ecF5A4ye55K46oweQzDxjktEgAG
         qPrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768322425; x=1768927225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vs3/bf9opBXXo4IPo2eIhuvgO3/Md3pR7YNVkSRRcFI=;
        b=iLtDeKr1voX0Qg1vW08YfGBlmnbgECxfVSZQZLPihFBJJdOX7QteZBCuDZCa+IJGZo
         I6WWygLmhh47CW2d8ypG8bv5xOF9E3rjsUyDry3wDfGDgCid138ZstUghw39Sm28NHa4
         m2Boy3rwaupJP9Izo1T9EU7v75a1p+QQoar5nVYkRJ61A8da0r3xb9kCE2V5bTzoUmBQ
         oGpntVZVE3tUVv4DdT9Rndj3Rg/D8C7+OgbAi63OBiUaivW7FPudDFJJFrm7cayX8fSz
         xVuWPZP+KngFbedbEbCe2qXxXOXbLvluWX8lUCftCQYXU/RbKkzH14oLw9Pu8K6PoOWh
         9OdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXatb+ZBHzn5Y1wKcUYvpmpFTSWLiiVeg/y/SrHQD76eLctwxqD57olbcsmXc5kiZmLbHE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8DNcvsZ7qSndUhQ6N3X0NdskcUhWwZDRFhYUsKDWr9/T1aeXo
	QIoixaBQURAxaXu7tcURwpCnl8/gI1HG6i8UaKVAw6k+FSFI4uS+nyNiq+bmF7An2fvU20k5uxv
	J4grAYLviLv14VpCYTrWgli+lrNejClEbZp6usMUX
X-Gm-Gg: AY/fxX6F0W8XBkC61wUsrl0c2TlXdLWcF7XlH7vFHzyw1hPwmBaN064wK6z4TyhVlz+
	6bq0z11CFAz5JpnrXB3Qnx8dVF7mO1YF0FWSwXBU5Su4JmyFtxCJXAod/ZWRzrjy5pPaxY1lY3t
	Oc3E0dNyLUFpFUt7kuVmfBTMbrd/j1t4EHAyzZWsdWvJVKraTkvrRD+exCNjyBdgWeDTTfuL12p
	K3KRZMtKrcVsQhUhyvLAH8FehQzJF/pyteG9bTw9ng6D7hDLlLTZvbSx/u4Ofb19a4TfyToJfGP
	jZVxWhDLsanKdgqvKb3OoRaRY/Lp
X-Received: by 2002:a05:7022:388:b0:120:5719:1856 with SMTP id
 a92af1059eb24-1232bef3656mr166409c88.20.1768322424954; Tue, 13 Jan 2026
 08:40:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com> <aV4hAfPZXfKKB+7i@yzhao56-desk.sh.intel.com>
 <diqzqzrzdfvh.fsf@google.com> <aWDH3Z/bjA9unACB@yzhao56-desk.sh.intel.com>
 <CAGtprH-E1iizdDE5PD9E3UHXJHNiiu2H4du9NkVt6vNAhV=O4g@mail.gmail.com>
 <CAEvNRgGk73cNFSTBB2p4Jbc-KS6YhU0WSd0pv9JVDArvRd=v4g@mail.gmail.com>
 <aWRQ2xyc9coA6aCg@yzhao56-desk.sh.intel.com> <aWRW51ckW2pxmAlK@yzhao56-desk.sh.intel.com>
 <CAEvNRgGCpDniO2TFqY9cpCJ1Sf84tM_Q4pQCg0mNq25mEftTKw@mail.gmail.com> <aWWQq6tHkK+97SOB@yzhao56-desk.sh.intel.com>
In-Reply-To: <aWWQq6tHkK+97SOB@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 13 Jan 2026 08:40:11 -0800
X-Gm-Features: AZwV_Qi2rTHumS0Mc-uUBtjh2HPFvZaj7QF8XEeF5V0Ze_pjDiDnciOORS1BH68
Message-ID: <CAGtprH8GuKYctwJFJHcztx=q9hfwQF+1_7e8=h9r3u1V_GgzmQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kas@kernel.org, 
	tabba@google.com, michael.roth@amd.com, david@kernel.org, sagis@google.com, 
	vbabka@suse.cz, thomas.lendacky@amd.com, nik.borisov@suse.com, 
	pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 10:13=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wr=
ote:
>
> > >> > >>
> > >> > >> Additionally, we don't split private mappings in kvm_gmem_error=
_folio().
> > >> > >> If smaller folios are allowed, splitting private mapping is req=
uired there.
> > >> >
> > >> > It was discussed before that for memory failure handling, we will =
want
> > >> > to split huge pages, we will get to it! The trouble is that guest_=
memfd
> > >> > took the page from HugeTLB (unlike buddy or HugeTLB which manages =
memory
> > >> > from the ground up), so we'll still need to figure out it's okay t=
o let
> > >> > HugeTLB deal with it when freeing, and when I last looked, HugeTLB
> > >> > doesn't actually deal with poisoned folios on freeing, so there's =
more
> > >> > work to do on the HugeTLB side.
> > >> >
> > >> > This is a good point, although IIUC it is a separate issue. The ne=
ed to
> > >> > split private mappings on memory failure is not for confidentialit=
y in
> > >> > the TDX sense but to ensure that the guest doesn't use the failed
> > >> > memory. In that case, contiguity is broken by the failed memory. T=
he
> > >> > folio is split, the private EPTs are split. The folio size should =
still
> > >> > not be checked in TDX code. guest_memfd knows contiguity got broke=
n, so
> > >> > guest_memfd calls TDX code to split the EPTs.
> > >>
> > >> Hmm, maybe the key is that we need to split S-EPT first before allow=
ing
> > >> guest_memfd to split the backend folio. If splitting S-EPT fails, do=
n't do the
> > >> folio splitting.
> > >>
> > >> This is better than performing folio splitting while it's mapped as =
huge in
> > >> S-EPT, since in the latter case, kvm_gmem_error_folio() needs to try=
 to split
> > >> S-EPT. If the S-EPT splitting fails, falling back to zapping the hug=
e mapping in
> > >> kvm_gmem_error_folio() would still trigger the over-zapping issue.
> > >>
> >
> > Let's put memory failure handling aside for now since for now it zaps
> > the entire huge page, so there's no impact on ordering between S-EPT an=
d
> > folio split.
> Relying on guest_memfd's specific implemenation is not a good thing. e.g.=
,
>
> Given there's a version of guest_memfd allocating folios from buddy.
> 1. KVM maps a 2MB folio in a 2MB mappings.
> 2. guest_memfd splits the 2MB folio into 4KB folios, but fails and leaves=
 the
>    2MB folio partially split.
> 3. Memory failure occurs on one of the split folio.
> 4. When splitting S-EPT fails, the over-zapping issue is still there.
>

Why is overzapping an issue?

Memory failure is supposed to be a rare occurrence and if there is no
memory to handle the splitting, I don't see any other choice than
overzapping. IIUC splitting the huge page range (in 1G -> 4K scenario)
requires even more memory than just splitting cross-boundary leaves
and has a higher chance of failing.

i.e. Whether the folio is split first or the SEPTs, there is always a
chance of failure leading to over-zapping. I don't see value in
optimizing rare failures within rarer memory failure handling
codepaths which are supposed to make best-effort decisions anyway.

