Return-Path: <kvm+bounces-11450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BDA587724A
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 17:30:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DB1D1C20DAC
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 16:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0EA2107B3;
	Sat,  9 Mar 2024 16:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RGFZDq26"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542FB1368
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 16:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710001846; cv=none; b=SOGVq8fpHaSaTUV4Nba4scXLv+/bcybgJGxVeRh60OrXzVFJ0WxXcGCxirvnjA9U58gIfj98RI3ayTLNORmtprrUHJysXIeVHIpfcIZrsEpsPXekn2V20hNqZYJSvKRonPrLwBPx55pQwJjDZJFYUehiELJlbY/x+OAyUrJnTFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710001846; c=relaxed/simple;
	bh=Z48F++PaLJh6UFMIPA/i4w6z072wcmAlRmjqHdN1Vis=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VZPG3m8MqwmaAN3v7gTfdv4LHL0Ex41zeN9voeiSnR/St52CHTcvAha41EaIYpkuadKM8mJ1JGvG/eB/OJn8ofZb+194SDVUTlsxmmLBNgbKB9uQGOCdgBsQM05s5a3mY7hT5nIJxEXkYnxnhRa1Ft90Stgea0hhuk1oqd/ifRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RGFZDq26; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710001843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QRDzPfq8rjOgj9kG+t47uY/1Gv5y4mO3jGlGm7JE9GU=;
	b=RGFZDq26ieqSaMzKtvNb2cRIoBjpy5ulLlGn8HOKvc8s9evjaoDfvZWsuMYGiqWtT4100g
	0Pp6oIPlr6BvAW1L/wpG3g5tzzZMJTJbhulrgeMq3B2hOsDZbK8BvqyA5qrUM4IOOWmTCA
	hX/ivMepWJsClTcnBnX2jTCfB1l7754=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-qKl1wocbOlSN6r8o6YmdyA-1; Sat, 09 Mar 2024 11:30:41 -0500
X-MC-Unique: qKl1wocbOlSN6r8o6YmdyA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33e8b017632so71903f8f.1
        for <kvm@vger.kernel.org>; Sat, 09 Mar 2024 08:30:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710001840; x=1710606640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QRDzPfq8rjOgj9kG+t47uY/1Gv5y4mO3jGlGm7JE9GU=;
        b=r9nVdEZT+gChuiCq1YQnQR4pYpPkpkZ9pT2sBoQLdhJJ4wLVE7R5Gv7tK9bGVm/2IS
         wmmZ3I32bVZpaUqgi4KxOES5p2mX4VAPrLCzxKPg4NC2kIfojD/eLVjtzXAKUuhp1wvz
         IDOxngE4RA/3Y3USC2eAY1cWF5oAWVDJzak8/NZspDAVnvbCq08HSzMMeFLWFCN/zvJq
         Xbl1xmbz87ZUGk+bf0JnQviFX3TI180son2uIqgEK9LEXy+jI6An9Rh2wfoGNsIH0zeo
         am4UzaUphezmWSHV/IZ+ZyBOfiRf070RhG6cQtDkzxNIyDAgndrAxki0SqSq3mKQu7+E
         emuA==
X-Gm-Message-State: AOJu0Yzl8CcoxEcnrm4pq64xaSWDWZ6MKANIwNDKH0aoXFyLAAxszS3F
	g50loXkghr9TA2dV7H1v5jRC1OmJMfTBH0BrIKzCprN+7vVycmrchY7srFvQ8RlsOU0IWEO495G
	K0Plu4KzM2foFvPPEo2ELIrVBPVp1lcPKTRzzuToNygSt++EEDTZxcuw25eWOEKDJoDgyRoz2zK
	mPZArf3zgApbv57k/5POGYGhWCeoLPNFNP
X-Received: by 2002:adf:eac2:0:b0:33e:7896:a9d7 with SMTP id o2-20020adfeac2000000b0033e7896a9d7mr1848969wrn.67.1710001839910;
        Sat, 09 Mar 2024 08:30:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IENv8VK1KmDOmnTYmjyGxo5gsygAIU0tJFmweqBPdN9+cQc2nAzToFcPq9MthddkrTjlYyEHrU7JHcwK3BL/Wk=
X-Received: by 2002:adf:eac2:0:b0:33e:7896:a9d7 with SMTP id
 o2-20020adfeac2000000b0033e7896a9d7mr1848960wrn.67.1710001839526; Sat, 09 Mar
 2024 08:30:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240223211547.3348606-1-seanjc@google.com> <ZdkO0bgL40l10YnU@google.com>
In-Reply-To: <ZdkO0bgL40l10YnU@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 9 Mar 2024 17:30:26 +0100
Message-ID: <CABgObfbvJ=9hc0sxzgW4fXebn66wy4LoKdKg7HWc9t1mihBjAg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: GUEST_MEMFD fixes for 6.8
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 23, 2024 at 10:32=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Fri, Feb 23, 2024, Sean Christopherson wrote:
> > Minor fixes related GUEST_MEMFD.  I _just_ posted these, and they've on=
ly
> > been in -next for one night, but I am sending this now to ensure you se=
e it
> > asap, as patch 1 in particular affects KVM's ABI, i.e. really should la=
nd
> > in 6.8 before GUEST_MEMFD support is officially released.
> >
> > The following changes since commit c48617fbbe831d4c80fe84056033f17b70a3=
1136:
> >
> >   Merge tag 'kvmarm-fixes-6.8-3' of git://git.kernel.org/pub/scm/linux/=
kernel/git/kvmarm/kvmarm into HEAD (2024-02-21 05:18:56 -0500)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/kvm-x86/linux.git tags/kvm-x86-guest_memfd_fixes-6=
.8
> >
> > for you to fetch changes up to 2dfd2383034421101300a3b7325cf339a182d218=
:
> >
> >   KVM: selftests: Add a testcase to verify GUEST_MEMFD and READONLY are=
 exclusive (2024-02-22 17:07:06 -0800)
> >
> > ----------------------------------------------------------------
> > KVM GUEST_MEMFD fixes for 6.8:
> >
> >  - Make KVM_MEM_GUEST_MEMFD mutually exclusive with KVM_MEM_READONLY to
> >    avoid creating ABI that KVM can't sanely support.
> >
> >  - Update documentation for KVM_SW_PROTECTED_VM to make it abundantly
> >    clear that such VMs are purely a development and testing vehicle, an=
d
> >    come with zero guarantees.
> >
> >  - Limit KVM_SW_PROTECTED_VM guests to the TDP MMU, as the long term pl=
an
> >    is to support confidential VMs with deterministic private memory (SN=
P
> >    and TDX) only in the TDP MMU.
> >
> >  - Fix a bug in a GUEST_MEMFD negative test that resulted in false pass=
es
> >    when verifying that KVM_MEM_GUEST_MEMFD memslots can't be dirty logg=
ed.
> >
> > ----------------------------------------------------------------
> > Sean Christopherson (5):
> >       KVM: Make KVM_MEM_GUEST_MEMFD mutually exclusive with KVM_MEM_REA=
DONLY
>
> Almost forgot, just as an FYI, this has a minor conflict with your kvm/kv=
m-uapi
> branch.  I've been fixing it up in kvm-x86/next, and IIUC you don't feed =
kvm/master
> into -next, so I don't think Stephen will see a conflict?

I do feed it in linux-next, so he would, but it's not a big deal. I'll
pull it into kvm-next as well.

Paolo


