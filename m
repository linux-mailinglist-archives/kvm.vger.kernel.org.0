Return-Path: <kvm+bounces-18206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB7808D18C3
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 12:40:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8419C288D5D
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 10:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3A2516B753;
	Tue, 28 May 2024 10:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FgXHIgvp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784CF16ABFA
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 10:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716892793; cv=none; b=rWmbH6Ie0bixg45bjKAPankGXNjcfGGfL1PZqRW2bCf1zDQffZKj1lSRURr668WDgp7zvYUeqCwGomg9GKk3YbLXEC3wGzhJJk3jmF5LOPnw1FdbKBRAjVMczXf2txWfjeFzpyTYHgaN6ygJzt6gLjVIwxSY17XIGT8STYx0fYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716892793; c=relaxed/simple;
	bh=aj45SEB7D9ldygzhYKXe3HytaBUsioM0atiT5UJiPD4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kmNqeq3xrMmJp+eIN0EnJtbSxwSfpRHq4zz9qHOE/S/iWjejvVFpgZHGFOFwzM3tVcny82IJVcymfvRZvSokt7DLEJjuea1zmICUMQ+GBlF240LK6Q1E0VUONclbd4ZprVleopsjjPE+3Oh6e5MYtyf5PmAwJqiTunXhswQ3EuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FgXHIgvp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716892791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cWr5rLzhCiKZuwW7h7YBmazKG48r0xrDo/cGy6it0/4=;
	b=FgXHIgvpyvHDZWIsSmKyDS3a9nnCVwIQFMXRIVQqjjKEhoNRYWMQKgYaRmdfMenuTYNG9V
	87/GUy1r/gI2fRU0fi8NxSz3yXYiW/YJOLiB2LCrVjIckVxrO7JWKFipLZp4av+ZCOzAzA
	Pxj9pnrcXKkUNTS/avqyaJNhzZp7WS4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-O31F0iwDOXOQ9_kIhzV-Eg-1; Tue, 28 May 2024 06:39:49 -0400
X-MC-Unique: O31F0iwDOXOQ9_kIhzV-Eg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-354f44ebfe7so479136f8f.2
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 03:39:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716892789; x=1717497589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cWr5rLzhCiKZuwW7h7YBmazKG48r0xrDo/cGy6it0/4=;
        b=n7tEa2Rxp4AKX8uuCNaq8vfzyMByYneyE0m09wFvA3vunPsf+hiA8hg5UBz7fIVOIE
         y9+5Vv6/sFKBbdv/0Tyn5vvAHxptNhGzim0yOJuqw2e//5zM+TVqdNuHnr6ana8EGXml
         GJphAXejgRx2Q7tPj7/RNHmy3Vc4h7Z+Y9IdsOZzAV73r/N2HqliknVSyaA7CnVs6THw
         7Cfg7pMyMQBLUP1sM103grgS5SBZn1ACSA4scnIfeK+uaRBFO6JJBPFhMUUWnoXBU7he
         HuOk4K+0RddKetphgSq6uq/8D0bRqXdVmwMQXOUjILQRlIaO4ZXEIUn95Gyte0cpSbSE
         AwSA==
X-Forwarded-Encrypted: i=1; AJvYcCWf6FBWLngmiheAkWLPW68QDuf5GCDdkWY5YdNg5K99wy7NWNxuYJrw0Q7uCD8srrLnyDKczjnbodA6EF7ap0m4nPY5
X-Gm-Message-State: AOJu0YxLbuelo9fWpsLwJXVLzIsV2CoIm52NoB0ZygwyoO6ZFZYukr3m
	A5LtxOaklMU4zoYqzxiny+Onh1GS6AIQXYWbMcgtpFqcflDiSGOgN7PDcF1KnqNQ6x6Z8WGW6z2
	2giiwAd5P+tY1lGcMsp6KcOUtsrLEPj2IgT5AufhJYuhb0BUIFBskY7w71GizhUQY+GhLIm2HeM
	F0hWXCgCqZtSe/URJTc+s0aamM
X-Received: by 2002:adf:f605:0:b0:351:d78e:875e with SMTP id ffacd0b85a97d-35526c271e2mr7836485f8f.14.1716892788872;
        Tue, 28 May 2024 03:39:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4hqokdTCBlYq+yxpXGdOajfvNiw6vsJ+NmirTpEeZTh+x8A7CTg2keuO9ed6PBfJTW5YEfW34ZoQ5qL3Gp5w=
X-Received: by 2002:adf:f605:0:b0:351:d78e:875e with SMTP id
 ffacd0b85a97d-35526c271e2mr7836445f8f.14.1716892788425; Tue, 28 May 2024
 03:39:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240501085210.2213060-10-michael.roth@amd.com> <84e8460d-f8e7-46d7-a274-90ea7aec2203@linux.intel.com>
 <CABgObfaXmMUYHEuK+D+2E9pybKMJqGZsKB033X1aOSQHSEqqVA@mail.gmail.com>
 <7d6a4320-89f5-48ce-95ff-54b00e7e9597@linux.intel.com> <rczrxq3lhqguarwh4cwxwa35j5riiagbilcw32oaxd7aqpyaq7@6bqrqn6ontba>
 <7da9c4a3-8597-44aa-a7ad-cc2bd2a85024@linux.intel.com>
In-Reply-To: <7da9c4a3-8597-44aa-a7ad-cc2bd2a85024@linux.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 28 May 2024 12:39:36 +0200
Message-ID: <CABgObfajCDkbDbK6-QyZABGTh=5rmE5q3ifvHfZD1A2Z+u0v3A@mail.gmail.com>
Subject: Re: [PATCH v15 09/20] KVM: SEV: Add support to handle MSR based Page
 State Change VMGEXIT
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	seanjc@google.com, vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 27, 2024 at 2:26=E2=80=AFPM Binbin Wu <binbin.wu@linux.intel.co=
m> wrote:
> > It seems like TDX should be able to do something similar by limiting th=
e
> > size of each KVM_HC_MAP_GPA_RANGE to TDX_MAP_GPA_MAX_LEN, and then
> > returning TDG_VP_VMCALL_RETRY to guest if the original size was greater
> > than TDX_MAP_GPA_MAX_LEN. But at that point you're effectively done wit=
h
> > the entire request and can return to guest, so it actually seems a litt=
le
> > more straightforward than the SNP case above. E.g. TDX has a 1:1 mappin=
g
> > between TDG_VP_VMCALL_MAP_GPA and KVM_HC_MAP_GPA_RANGE events. (And eve=
n
> > similar names :))
> >
> > So doesn't seem like there's a good reason to expose any of these
> > throttling details to userspace,

I think userspace should never be worried about throttling. I would
say it's up to the guest to split the GPA into multiple ranges, but
that's not how arch/x86/coco/tdx/tdx.c is implemented so instead we
can do the split in KVM instead. It can be a module parameter or VM
attribute, establishing the size that will be processed in a single
TDVMCALL.

Paolo

>
> The reasons I want to put the throttling in userspace are:
> 1. Hardcode the TDX_MAP_GPA_MAX_LEN in kernel may not be preferred.
> 2. The throttling thing doesn't need to be TDX specific, it can be
> generic in userspace.
>
> I think we can set a reasonable value in userspace, so that for SNP, it
> doesn't trigger the throttling since the large request will be split to
> multiple userspace requests.
>
>
> > in which case existing
> > KVM_HC_MAP_GPA_RANGE interface seems like it should be sufficient.
> >
> > -Mike
> >
> >>
> >>>> For TDX, it may also want to use KVM_HC_MAP_GPA_RANGE hypercall  to
> >>>> userspace via KVM_EXIT_HYPERCALL.
> >>> Yes, definitely.
> >>>
> >>> Paolo
> >>>
>


