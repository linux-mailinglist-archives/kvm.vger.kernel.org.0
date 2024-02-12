Return-Path: <kvm+bounces-8539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D65851037
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 11:01:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E9CD1F21468
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 10:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08555199AD;
	Mon, 12 Feb 2024 10:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VKNo5Sf4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6311E18643
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 10:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707732045; cv=none; b=amdoGvE2zhWE5EncqKr9pUzfz1GAu7An0Hk8LRrMFAjtDHqAO+jmFh1J/jhtzJLPzPeNTFeP7ySIuabWg6GXWfBTucB1nlJ6mHoSVwsYybs8qdJ4mMBlocQIKrbVBit3VJCoQ65PJSbL28SRSyhkSJwVLV66qTluq+qw6sZN9as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707732045; c=relaxed/simple;
	bh=3y4L/Ww9jOlNtiXvABcrsz/8FFXP25E4KZgEUZ8G8fc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uSHi0tZ3xAWD5UuF9YmzRj1p5yoVILeMF94M8URJmwbK8+/QA3QQaPXTFgOV6UBteUtESam230mrxUpJY21V30a8I9dWkRqJR8zuMHcTBGG2qyeez2RWNYCXLvU2kw7jFK9vitwM7j25WyLR+gB+fACTyqLiBC4/CvTHZsutqzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VKNo5Sf4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707732042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l44duX4bruiSysv390/0MeGikPC351P53LEkSBBfAnE=;
	b=VKNo5Sf4QInKr4uebPsc8z2T1wVZA01WR4LszBM8LNqFdt91VwiNsuHapU2GFmpbnU3EAF
	xjcIWgVImRn4uv6Jr33Nn/W04Ai7vHWg7JJXZkAGwVPCglChXLW8Q6DejMUvCD3LMNmx9d
	iMtxQoADJqYLJnzqezBxPaHSS+Z28a4=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-EJrvQP3ONLmfxfCrcORomA-1; Mon, 12 Feb 2024 05:00:40 -0500
X-MC-Unique: EJrvQP3ONLmfxfCrcORomA-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-7cee1755d80so2285944241.2
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 02:00:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707732040; x=1708336840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l44duX4bruiSysv390/0MeGikPC351P53LEkSBBfAnE=;
        b=bF2affQfASfvYjYVXVPZqRLRqIU2lcX4hCPCat+RsKuqRVkmsMSliyaPizFeZIsmMy
         LCpv3IsvLOrW2Q4hmGKADa0cHdPo4m4pTtvDN4zaI2X6AmQ8CMGmh4c72kdy1JkUimry
         +VeHKUVY0Ov6LcrV1QvqqSLRjO7TUkdllCCTZJv07l/FwvQRikdXyUwP99mOretMwvo2
         QfzsFVNWcAPlQftPW9iiIOuqZP8QmWvZwG/Ve6E2DnRr6lfKaxRWnSbM7xQi7sbdT94K
         +0jG30T8bzw8fWKpECIZxlx9ZApJqBYIkDPlGGtzxw4x9L++b+D7ph3gd8aJB7sd2xAO
         MWDA==
X-Forwarded-Encrypted: i=1; AJvYcCUIZNLsyzdtGUx9SHj4+v5OY/7Vs9+lRvut6z2fi1R7pxx7Eeb5UzyTz7tYzo04T+fUHJlKFxCHOmKbmtyQuSIpbDpe
X-Gm-Message-State: AOJu0YwWyel9DG2sSBfMH+7bGnf3YU70TMSi84/vYpiAH3zwGkWcM7x7
	jhJU+3vqSD80wCUoN/e+THplDkuV7RX7tfHcDj1WGMpaGRVfNW8PkI2p36b1lo9cmU4I5B2w6XI
	dpyPsrmEnDGSNSZavuogktRNWuo60DD/6ZjxFdilsJgAqaALzk4MpFrlpeha0MdxjeNAoSOaBq5
	Azi8qWPZS5OONZKX38qwpeMjQ0
X-Received: by 2002:a67:fdd9:0:b0:46d:162f:a77e with SMTP id l25-20020a67fdd9000000b0046d162fa77emr4229794vsq.16.1707732040104;
        Mon, 12 Feb 2024 02:00:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHNS2UrbWm61NEj4QS+lNMC4rXIR1d7f9tSEY7SuWQz9LtNYOaIt21AdO+LQgIosdUlO16W/y6MTDYLoVqP5+o=
X-Received: by 2002:a67:fdd9:0:b0:46d:162f:a77e with SMTP id
 l25-20020a67fdd9000000b0046d162fa77emr4229749vsq.16.1707732039543; Mon, 12
 Feb 2024 02:00:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231230172351.574091-1-michael.roth@amd.com> <20231230172351.574091-7-michael.roth@amd.com>
 <ZcKb6VGbNZHlQkzg@google.com>
In-Reply-To: <ZcKb6VGbNZHlQkzg@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 12 Feb 2024 11:00:27 +0100
Message-ID: <CABgObfbMuU5axeCYykXitrKGgV5Zw-BB843--Gp4t_rLe2=gPw@mail.gmail.com>
Subject: Re: [PATCH v11 06/35] KVM: x86/mmu: Pass around full 64-bit error
 code for KVM page faults
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 6, 2024 at 9:52=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Sat, Dec 30, 2023, Michael Roth wrote:
> > In some cases the full 64-bit error code for the KVM page fault will be
> > needed to determine things like whether or not a fault was for a privat=
e
> > or shared guest page, so update related code to accept the full 64-bit
> > value so it can be plumbed all the way through to where it is needed.
> >
> > The accessors of fault->error_code are changed as follows:
> >
> > - FNAME(page_fault): change to explicitly use lower_32_bits() since tha=
t
> >                      is no longer done in kvm_mmu_page_fault()
> > - kvm_mmu_page_fault(): explicit mask with PFERR_RSVD_MASK,
> >                         PFERR_NESTED_GUEST_PAGE
> > - mmutrace: changed u32 -> u64
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Link: https://lore.kernel.org/kvm/20230612042559.375660-1-michael.roth@=
amd.com/T/#mbd0b20c9a2cf50319d5d2a27b63f73c772112076
> > [mdr: drop references/changes to code not in current gmem tree, update
> >       commit message]
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
>
> I assume Isaku is the original author?  If so, that's missing from this p=
atch.

The root of this patch seem to be in a reply to "KVM: x86: Add
'fault_is_private' x86 op"
(https://patchew.org/linux/20230220183847.59159-1-michael.roth@amd.com/2023=
0220183847.59159-2-michael.roth@amd.com/),
so yes.

Paolo


