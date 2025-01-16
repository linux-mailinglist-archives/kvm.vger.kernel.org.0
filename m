Return-Path: <kvm+bounces-35703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED1B0A14515
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 00:05:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 676AB3A6DD8
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 23:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93505232364;
	Thu, 16 Jan 2025 23:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o3CaHDxk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AAE155756
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 23:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737068723; cv=none; b=f44sTTdU9KKDh9sCG3OurnBXLgaTivjQbGUNp8MzVoscqeHM2rjyPzFHY+Tf3F3AiXFR/a+86oyRN3Z3vwUoavYDmQ8UtgeOXVeZ2SCSqzwnGHcQBRt+euLF9BRvVgCcg6aOwPg1lYSPAK0AHPSGozBoI41aUXTXoTuvkWiaMJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737068723; c=relaxed/simple;
	bh=suEN/33SYD9kr8IhLu9T5fGefoNFQ4pijv9IYyE6MGg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZnIbrCijYWQR/w+FK8PdUbl63n/DmMR3pkVxepHdPlhSLakBdAn9uF2CMBSoWVoRIS0YiIEOvqLeY9ir5RTS15jdQCgqCOqKKdJhptS5ed6T2Lumt9SBgVJrQVFm8laOdYMWcO1sNijmNaZP3G9fjTnOAWEXYXCaML6yoPAb5MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o3CaHDxk; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e398484b60bso2478562276.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 15:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737068721; x=1737673521; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ownLtPpk0wxf6r6Wq9E4jSgq7bXvrdC32yvYQuD3YI=;
        b=o3CaHDxkxhvXz05pkLmPM7UFfUBwP+L27TrlUHhYUWMeLvtfTRNTLpjRd00OaK1XGZ
         I8NrhzqaBRkRsJPsSwfdUIejI4B0TzW1tEkzlZAv4abwwSDrkT005BShdN0FqBrTPCMb
         eZkp64Uq0xGNap9X8s1wpRgX/H1PkWmD5TAhyPVIJNIEMACjApEm075s8Zi5bEWhNmu6
         TQP/vt8h+aDduuksHyM6tld3F2WsrLUsnv1awaxNOtkMB6HRGF02Dg8mx2znHZPRdRVQ
         iEYwTyHKWScIa7RO0y6FfwdJA1bIioYa/nSeq6jlkEhAdJNg8Ke1qoCks56dogrIZm6Y
         br6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737068721; x=1737673521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ownLtPpk0wxf6r6Wq9E4jSgq7bXvrdC32yvYQuD3YI=;
        b=MYXiJUa3SoPvIfoa4krc5med8kgECicLhbmwJr7sxtzaQc9366sdqLCcXESzKlVx9N
         QRBVsZm4h9+SGA86qGyIuRCOaiebDPiHV4Xjmk29EAdofEj7q9A8TmDYYql+hj/4E5gV
         +pHBUQ+sMbIdKmztkaAlzvuzqKBeV0WMucHObdm2RHxSZegUKpCTE8ty/4SukdWslJPw
         XzZ+ctDXj8rL3jTuaZsBtKNYZ2rXR7oE8/ckzsW7dyTz7tm3VH8MrdJ8gsI/HPSGaEvn
         RQGzBasHy/rY0vCiEr+pzGIkWT4kLdqZnjshOcXAvhDe+RVzEcQQh/TL5vhBfcRdkur7
         kknw==
X-Forwarded-Encrypted: i=1; AJvYcCXGRGN19VqSJloacKbNfoYQe1H+Em7DUFZ5T/UC5PLbnRiSPAtCbBxAPuM0HFOXH9DEqjs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUSTzyy3j8ch9JAWqS8Ta7NffmlroSKLqIlyvoCShc6Gqc56/6
	bibcaaLBTp56LQNhWdMZlcZvMC99Dy+6Ug9/zbAPu3DJ8hQ1YHy0rekxJCfTYkl8tFc5KPoGnNt
	otwzI2pEeLUQXNexwuaoGm1/sgV9YkskBWjUh
X-Gm-Gg: ASbGncub/O1+OKY+WraRMR60ox2T3tCFShTaOUiFhmxNPC3gHZGUtaCxfY6gS5mmj4h
	1Bg6xmVcuFbA9FQXS2umAbvVHCsJGa9cyNC8bbOAAq9uPjhxoi4gKWZlyuILL6988C8Fb
X-Google-Smtp-Source: AGHT+IHMnqWCK1543bGJ7is63MhDeR0ycyx0XklGqD/4LG6uvyEtx2Qm3xFEDxKFZ6o5qY44BdR/OD9k5OQNQTNdcJY=
X-Received: by 2002:a05:6902:707:b0:e38:8749:815e with SMTP id
 3f1490d57ef6-e57b1310a25mr249418276.30.1737068721056; Thu, 16 Jan 2025
 15:05:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
 <Z2simHWeYbww90OZ@x1n> <CADrL8HUkP2ti1yWwp=1LwTX2Koit5Pk6LFcOyTpN2b+B3MfKuw@mail.gmail.com>
 <Z4lp5QzdOX0oYGOk@x1n> <Z4lsxgFSdiqpNtdG@x1n> <Z4mFL8wfHjvz6F1Y@google.com>
In-Reply-To: <Z4mFL8wfHjvz6F1Y@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 16 Jan 2025 15:04:45 -0800
X-Gm-Features: AbW1kvYhIT_qdEvLNggXEyTtjFcK3iljN13YOJGI8jYSmtn1o-5KlOinkDsaqTE
Message-ID: <CADrL8HW_hgKZBX98Z17eNqC3iJruwLJcFv=pswgT8hKayMYbzw@mail.gmail.com>
Subject: Re: [PATCH v1 00/13] KVM: Introduce KVM Userfault
To: Sean Christopherson <seanjc@google.com>
Cc: Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Yan Zhao <yan.y.zhao@intel.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, 
	David Matlack <dmatlack@google.com>, Wei W <wei.w.wang@intel.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025 at 2:16=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Jan 16, 2025, Peter Xu wrote:
> > On Thu, Jan 16, 2025 at 03:19:49PM -0500, Peter Xu wrote:
> > > > For the gmem case, userfaultfd cannot be used, so KVM Userfault isn=
't
> > > > replacing it. And as of right now anyway, KVM Userfault *does* prov=
ide
> > > > a complete post-copy system for gmem.
> > > >
> > > > When gmem pages can be mapped into userspace, for post-copy to rema=
in
> > > > functional, userspace-mapped gmem will need userfaultfd integration=
.
> > > > Keep in mind that even after this integration happens, userfaultfd
> > > > alone will *not* be a complete post-copy solution, as vCPU faults
> > > > won't be resolved via the userspace page tables.
> > >
> > > Do you know in context of CoCo, whether a private page can be accesse=
d at
> > > all outside of KVM?
> > >
> > > I think I'm pretty sure now a private page can never be mapped to
> > > userspace.  However, can another module like vhost-kernel access it d=
uring
> > > postcopy?  My impression of that is still a yes, but then how about
> > > vhost-user?
> > >
> > > Here, the "vhost-kernel" part represents a question on whether privat=
e
> > > pages can be accessed at all outside KVM.  While "vhost-user" part
> > > represents a question on whether, if the previous vhost-kernel questi=
on
> > > answers as "yes it can", such access attempt can happen in another
> > > process/task (hence, not only does it lack KVM context, but also not
> > > sharing the same task context).
> >
> > Right after I sent it, I just recalled whenever a device needs to acces=
s
> > the page, it needs to be converted to shared pages first..
>
> FWIW, once Trusted I/O comes along, "trusted" devices will be able to acc=
ess guest
> private memory.  The basic gist is that the IOMMU will enforce access to =
private
> memory, e.g. on AMD the IOMMU will check the RMP[*], and I believe the pl=
an for
> TDX is to have the IOMMU share the Secure-EPT tables that are used by the=
 CPU.
>
> [*] https://www.amd.com/content/dam/amd/en/documents/developer/sev-tio-wh=
itepaper.pdf

Hi Sean,

Do you know what API the IOMMU driver would use to get the private
pages to map? Normally it'd use GUP, but GUP would/should fail for
guest-private pages, right?

