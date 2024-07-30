Return-Path: <kvm+bounces-22707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8476D942196
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 22:27:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3262B220B6
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 20:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13F4418DF63;
	Tue, 30 Jul 2024 20:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d0nosym+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656CD1662F4
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 20:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722371238; cv=none; b=RdjYt3g4vCqYnnho/2imfbGrBbgrsupxL0kNFYtiBEtIoJHmtUr735Kku23TKbJ0C2foLlx69REpEIL9kPPaubf6ucl7f1aPePmmREYtqaz7D9sHlGpXhAfyXZb03dYVz5b5l+8ykVkk+MPutT3NEcKpX+USTYG7HB9sLGB9x4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722371238; c=relaxed/simple;
	bh=umoPCtCkYW+giJeJdPSZn9npvUrDOn5+F2JD+veI3jI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H9del1bxWDi5LS5ZdGbiAtn131NueCSmRKw/4RnVk7fTYuCD1X9lobayOiUjQf1cXLlSYBgkIo80eGhIT/CdWnXb8Ga3KVwPNw91/HwTcLO40krzylxS3fs5TnXjzi+Ixw98kv/hXW++8J+fCfvBylviytEv2CsBWK1PfZoygL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d0nosym+; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0b8fa94718so3621355276.0
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 13:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722371235; x=1722976035; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BT66vEwt9iJsGeuvAMx6ZtRmhkH62brVnR8HWlVI5+E=;
        b=d0nosym+8R6bCaBuXVBpXfv/GjSuXEiQYb3hF6tQl9ipx8qP8Gspp8giuhqKUfmR7W
         6P2Gv52gy/QDmBDybuz8qdXvS9agSpXJW9LaNF932IuNO5JF4CDIfBfRTkLwb12ljUY2
         vTlQ6HKgtZJi525GLuGXx+p0GQBNoTDPJjGbx2WJK6sZ6sX4XrR0TiYYCwbCPgwIq1ak
         Gtv0IY89p7hLBN/DVkWGdvRDgKxvR+gwyaEb8craL7bBtWzme+0z27qFPOj6P7CZhuai
         v49XS/dG00ZIWDMaPajstx2rjxcwBWhdWF2A21z0UcfpB0M8m9vzlA/fVSSOjUWekMP4
         BnOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722371235; x=1722976035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BT66vEwt9iJsGeuvAMx6ZtRmhkH62brVnR8HWlVI5+E=;
        b=NqT+k/r0fOX7mtGkWW0GNslaNDbF7Fu4Xs83f3nxdcneK2j9s/isxUw21XMTYhtCn0
         1DHFDIl78j5edpKbzTAIclMSemw9DhjKaEHXgL5+3RyhowkSQYsvuudIv4tG7vn6KbD2
         waNEZw/dPftJEd5Tbmr759BOeTiCIPYlFmyNWm7sRMdQSUYbDZUl1yuSOck9PbrSj2vb
         tvsSxG4C6H1DKvVWp040GsNhkZWqD0iBajprAvNQqonJHlxWBJkeWNTx91vaPMzVXngs
         vbWrNXUjbL0mNMEayMl8J9qTtrh3MKYQk2qDaBIKAJa34RmACc7iObHT5nM1sP9Kh6UT
         zGRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrVCxLFyi9tY/RCcpLv2Vcse3UioER3+2kxfxSiQ7mxap+lQmjSCO8OEmLMOjoTCfUm0JChW8YxptetCptJIfpfNdC
X-Gm-Message-State: AOJu0Yy+INtftv+Fu57u+s6KSXACW/RyUdELwI7t+ZCAuUUVDaN2CfiO
	3qLPjmeSU5XRf+0E+Ne2VCZ/gPe6ACeKzdu2w9cd1KiMJlkTilJ6vVMxy5WK+LPGjF660NUlk0N
	sDw==
X-Google-Smtp-Source: AGHT+IFMmEFgsZNC3++LEDK0GsTGhukj/h4zxeGJVMgx7iz1341o1TDyzrL9DkroENLBZiGZP09HcP7Uxu0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1081:b0:e0b:1407:e357 with SMTP id
 3f1490d57ef6-e0b543f0dc9mr790814276.3.1722371235350; Tue, 30 Jul 2024
 13:27:15 -0700 (PDT)
Date: Tue, 30 Jul 2024 13:27:13 -0700
In-Reply-To: <db00e68b-2b34-49e1-aa72-425a35534762@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240730053215.33768-1-flyingpeng@tencent.com> <db00e68b-2b34-49e1-aa72-425a35534762@redhat.com>
Message-ID: <ZqlMob2o-97KsB8t@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Conditionally call kvm_zap_obsolete_pages
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: flyingpenghao@gmail.com, kvm@vger.kernel.org, 
	Peng Hao <flyingpeng@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 30, 2024, Paolo Bonzini wrote:
> On 7/30/24 07:32, flyingpenghao@gmail.com wrote:
> > 
> > When tdp_mmu is enabled, invalid root calls kvm_tdp_mmu_zap_invalidated_roots
> > to implement it, and kvm_zap_obsolete_pages is not used.
> > 
> > Signed-off-by: Peng Hao<flyingpeng@tencent.com>
> > ---
> >   arch/x86/kvm/mmu/mmu.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 901be9e420a4..e91586c2ef87 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6447,7 +6447,8 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
> >   	 */
> >   	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
> > -	kvm_zap_obsolete_pages(kvm);
> > +	if (!tdp_mmu_enabled)
> > +		kvm_zap_obsolete_pages(kvm);
> 
> Can't you have obsolete pages from the shadow MMU that's used for nested
> (nGPA->HPA) virtualization?

Yep.  And kvm_zap_obsolete_pages() is a relatively cheap nop if there are no
pages on active_mmu_pages.  E.g. we could check kvm_memslots_have_rmaps(), but I
don't see any point in doing so, as the existing code should be blazing fast
relative to the total cost of the zap.

