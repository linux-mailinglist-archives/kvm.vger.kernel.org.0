Return-Path: <kvm+bounces-24545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 217679571FC
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 19:20:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A37AB1F20FCE
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 17:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ACCF18757F;
	Mon, 19 Aug 2024 17:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XtJzVT5V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457852628C
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 17:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724088032; cv=none; b=E/ut91nnZjwackPN8VQEHN4QtJ5qt6QeiPR8vQ66+Du/U1Y1U25WwH6Cv/kf5a1z0FOg2USBzzWqT6PB/WEV5JsbyeoX/197Xb7cnAFMNfB6hhXjoVLy9dFpmxyPOSKZR5P0Y+z2rGWZa/GuTlXV2j8BMygYiPdhKuhQ16DBLzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724088032; c=relaxed/simple;
	bh=Fz7RTpNNAkygD/A9lFyA3Zpql12yI9+L0oMJ/FFal1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f2H4o0Jbv+G7G7g5SiEWhVKz+IysWtFStNPWp3WPGPDksc4jn1LpaDd71rDUuZa6I3/t20BDhtlGFxqnecllA22tkNB9Veu9N6dy9aeS02Sqlx0tPEJlNVurzIbM4OhR93b4YImsv5fSAMhUyHnImGarNGQPlGqnpG6Uzv7IiKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XtJzVT5V; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-710e39961f4so2999490b3a.3
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 10:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724088030; x=1724692830; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=44Ddv6twXoWtXHXqa94jX8MItnSbPFQyPRlP6d3WoMc=;
        b=XtJzVT5V42VeWVsfPy+nYw9EH//FYpjyX0x63hbYNFKj11U/N8aoRUBuFe0rrqgYN3
         ZN+/vq33Lm3y+KucwQFRSeZcXLh0oUoQ6Bt/R1kgTJ/aLGlk7coyLV2Jkx+7k947lD4X
         OUJ9LY9yvQkAzKFeYIneGCjW+mZcJCU1ewLt8SOZCOmf0jhWYllSJSVpMCiZiSA6VYAl
         B5JpiGQZHR3OGyC+oQ/tOcIT0vBoK6ZX4r2GmX0/rlyZcXjVzvhOaDD9waRXss4ORN6N
         Ex73KLgIkWh/iSXdYG3zzeRWZUlXfe3pKS0qhDPU0+PoJ9tue4E6HjBgxLSZwod7BUM/
         +9dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724088030; x=1724692830;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=44Ddv6twXoWtXHXqa94jX8MItnSbPFQyPRlP6d3WoMc=;
        b=hFj/NDwr6NEE707CJu8vdZBhTXSyU8/Y/h0xkvAhjbg2xXRvCTL2gTH5dhlUQvW+AX
         JsT++qsZrRF2VK0C4rmyxYWTd9ZDNsp0RNfN5yYam5pqmG1S2AuRwkFJ1caBFLFWPWMy
         dDExjYakB6cHyiOiLjdH2vyKQLM6UITwEhqWsiaPlMI48PWUTyFvj72aFIRafnN59II0
         STW8IcIer7fsDkHEPOl6tLkufVg/JYMSner/jjXFaZ5hVCzcZvn7BU96ZGVAvJatcEKz
         TcHifoATcSPW9QAcjpPLBL49AK8eTFs0CT4did5PDIeBIaNr2fv0nZIWjzuK76Vgn1lb
         HZ2w==
X-Forwarded-Encrypted: i=1; AJvYcCVAsAflpr5E1o4ovNI00c50m577x4yDuGv6WwI4zN8rQX4fxhYB+zOBpVP/QuFN5Wi5vZMDibqoUalB5rzVOFX5OfrY
X-Gm-Message-State: AOJu0YwG6nyrpv1KpazjvuCLymkRZhF1UZNFwRYnCWFXO//We59o51D+
	zN2Vr5iFmT6a5iOJotCJOTkN43TWW1sREDc4bE19vnljInwQTtCZGHGkJwBhBQ==
X-Google-Smtp-Source: AGHT+IFS46LqBKrm1MdFbLBCDRNytMMCr+3Tf953El5f+v9RCyTiFYwlhKpSQEfz+hDM+sJYIKpX8Q==
X-Received: by 2002:a05:6a21:3406:b0:1c4:d438:7dd2 with SMTP id adf61e73a8af0-1c904fb6496mr10239753637.32.1724088030116;
        Mon, 19 Aug 2024 10:20:30 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127addf5f5sm6801769b3a.6.2024.08.19.10.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 10:20:29 -0700 (PDT)
Date: Mon, 19 Aug 2024 10:20:23 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Split NX hugepage recovery flow into
 TDP and non-TDP flow
Message-ID: <20240819172023.GA2210585.vipinsh@google.com>
References: <20240812171341.1763297-1-vipinsh@google.com>
 <20240812171341.1763297-2-vipinsh@google.com>
 <Zr_gx1Xi1TAyYkqb@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr_gx1Xi1TAyYkqb@google.com>

On 2024-08-16 16:29:11, Sean Christopherson wrote:
> On Mon, Aug 12, 2024, Vipin Sharma wrote:
> > +	list_for_each_entry(sp, &kvm->arch.possible_nx_huge_pages, possible_nx_huge_page_link) {
> > +		if (i++ >= max)
> > +			break;
> > +		if (is_tdp_mmu_page(sp) == tdp_mmu)
> > +			return sp;
> > +	}
> 
> This is silly and wasteful.  E.g. in the (unlikely) case there's one TDP MMU
> page amongst hundreds/thousands of shadow MMU pages, this will walk the list
> until @max, and then move on to the shadow MMU.
> 
> Why not just use separate lists?

Before this patch, NX huge page recovery calculates "to_zap" and then it
zaps first "to_zap" pages from the common list. This series is trying to
maintain that invarient.

If we use two separate lists then we have to decide how many pages
should be zapped from TDP MMU and shadow MMU list. Few options I can
think of:

1. Zap "to_zap" pages from both TDP MMU and shadow MMU list separately.
   Effectively, this might double the work for recovery thread.
2. Try zapping "to_zap" page from one list and if there are not enough
   pages to zap then zap from the other list. This can cause starvation.
3. Do half of "to_zap" from one list and another half from the other
   list. This can lead to situations where only half work is being done
   by the recovery worker thread.

Option (1) above seems more reasonable to me.

