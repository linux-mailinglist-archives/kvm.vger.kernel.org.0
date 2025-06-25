Return-Path: <kvm+bounces-50730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8792EAE8960
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 18:14:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E3631C23794
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3C12BEC2D;
	Wed, 25 Jun 2025 16:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EbLzvMFR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7A429AAEA
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 16:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750867978; cv=none; b=ZqXuBzXAqHY/XZYneRrKdtL0om81q9dSNWkcWb2CVqlnMDP7falyKMCbSzF52NDrdJQq1TQ2oYvS0O2uk7NblyJvl1vBUs+fAuTBrCwbNSwuJQSI6QRniFd7CJ6zOmvAuyjKdaetPKI230byidW6ApnZZoJ5b1Kpdfup6pklFdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750867978; c=relaxed/simple;
	bh=RMiNvzTmNQ6uGQUNTW8VoGhR52Bb9FCblhjSf+W7ab4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GAR2CBPcvTUws96VN44yoLfguV3RpP+VzoNEX1myAwZALj2PUgfkjCpdXrQD0WDg6cuVwFz2z7M0FDfrdsUjSOnF56WoDFGAwWGFmll4UUbHG8dg4h17KZhDf8pvsbLGlmwSxQXMtJJ62Y0Zspw7yD+3O0ojeI+bxozl/SW07JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EbLzvMFR; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74928291bc3so72965b3a.0
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 09:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750867976; x=1751472776; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lgTQMEzvYm9i1XdJKwLwAM5nfW1WsYbVr2cAlDFSC+k=;
        b=EbLzvMFRdjPLDrlwvqXwto8aU0Xym3blFt3kYzt4Nee+YMtr4tAXiKavbvDlxq57c+
         aewZDE2rsEEMGo6mrDRBWHgggxjuVksde/I6qQ7ZMRUpSM6MfbxFwAnhHGWmhqCQyfTb
         nsuO0SkD0qX/Yb3e6+Bw/79FnMA8ZoQILQPzuW0inrhEiBGlakNXmRgycf/kaVJTXuAC
         gW/w/du0vQ0CVJWgACK3Lw3GBkirVvUPwK/wg4Z/TDmspdW9HIU665IPILd6NCMvKHdH
         3tfnxL5Vlg/9LP3KLAvCIYnKx2ocpPiMpfDFrTo3wigUqWt4mKzxyuZ96ep7VWHnuU+6
         4yUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750867976; x=1751472776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lgTQMEzvYm9i1XdJKwLwAM5nfW1WsYbVr2cAlDFSC+k=;
        b=orsGEob+3dZqkYVWQEa/S3/0s+T0S/BauDaS28dD5huan8FsfV/n81luQov0/LDecx
         Cmc54+0myVO/pfR7y86pH/+tYW8r/1u3LpPmFjoy+7phuRdxBK4gQA/8B1V4SpS4GduD
         Epugopi7MCxspVq7PNa1Tw1zbQRIzlOaPdht5hyHHg1NJ/OCSY2rbKdPcfr+OeK+FS8a
         mE7RbP+BWeIGiFKBrFfwL+2LPlpxjydXowlxzpy0N2fDEL7U+QPY5XA4aLuD1dxahCHp
         C8VgDBrjwMBq99rzGuopWcO84rcuIhEcXwVoOKEYiUEwukdr+jrXT/zfB7Gc1zxab21n
         JbEg==
X-Forwarded-Encrypted: i=1; AJvYcCUEyoHHSXWhQJDiGlJPK1+ZSVfHmHNhqcW5aSDygq7rpesWKqrw98v0u+vTdkgqtReIJJE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywak0lQiSzBof35xwa1UZ+EZVqkRM/XwEJ4XC7kqWZafOdJjHXk
	ZfnZGjLwq/jZfaBzI7wouxokNwh70VZlCMoeUIAwqsBTYeQi8FJaEqF8IuOf2N08s6J7ZQfvJlv
	jUakWpw==
X-Google-Smtp-Source: AGHT+IHPfmLt7+7XMJQuLzEkKxOsf28vsWzElmisjOeqLOeHoGCN67LZ+qxnj2nNyKOR2Qy/uJXYVvmjBDE=
X-Received: from pfbhx20.prod.google.com ([2002:a05:6a00:8994:b0:748:dfd8:3949])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:210b:b0:220:92f:4d97
 with SMTP id adf61e73a8af0-2208c08a9a6mr687075637.4.1750867975980; Wed, 25
 Jun 2025 09:12:55 -0700 (PDT)
Date: Wed, 25 Jun 2025 09:12:54 -0700
In-Reply-To: <543bcbd5-c217-41f7-b478-e32e6dcf66dc@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250226181453.2311849-1-pbonzini@redhat.com> <20250226181453.2311849-24-pbonzini@redhat.com>
 <543bcbd5-c217-41f7-b478-e32e6dcf66dc@intel.com>
Message-ID: <aFwgBs2Gdvcj98nH@google.com>
Subject: Re: [PATCH 23/33] KVM: TDX: create/destroy VM structure
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Tony Lindgren <tony.lindgren@linux.intel.com>, 
	Sean Christopherson <sean.j.christopherson@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 25, 2025, Dave Hansen wrote:
> On 2/26/25 10:14, Paolo Bonzini wrote:
> > +static void tdx_clear_page(struct page *page)
> > +{
> > +	const void *zero_page = (const void *) page_to_virt(ZERO_PAGE(0));
> > +	void *dest = page_to_virt(page);
> > +	unsigned long i;
> > +
> > +	/*
> > +	 * The page could have been poisoned.  MOVDIR64B also clears
> > +	 * the poison bit so the kernel can safely use the page again.
> > +	 */
> > +	for (i = 0; i < PAGE_SIZE; i += 64)
> > +		movdir64b(dest + i, zero_page);
> > +	/*
> > +	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
> > +	 * from seeing potentially poisoned cache.
> > +	 */
> > +	__mb();
> > +}
> 
> Hey guys,
> 
> This ended up in KVM code when we already have the *VERY* similar
> reset_tdx_pages().
> 
> Could we consolidate them, please? There's no reason to sprinkle
> knowledge of movdir64b's memory ordering rules all across the tree.
> 
> Adrian, this is probably something to go do, first, before you try and
> poke at this code that probably shouldn't be in KVM in the first place.

+1

