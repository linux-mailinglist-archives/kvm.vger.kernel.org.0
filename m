Return-Path: <kvm+bounces-55131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B6C0B2DEF3
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 16:18:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6BE1C1C482AC
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 14:13:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D0821FF24;
	Wed, 20 Aug 2025 14:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="geqLh41w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502CD265606;
	Wed, 20 Aug 2025 14:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755699162; cv=none; b=cjGrdqAazEiYPrrw0OrxdjLHgwtY9IEJDF7biLEJz1234vvpg9stv1tHp1LkiSukWoI0O2qHHOI53DEfBWPZWEbE//kJcELDzXcam96BYQZ1RUkd9gGJxwpcIxtIrYr8KRsJAxsIKBU4gRnvSuYUK3qBz440WrmbwBt5o/f7oYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755699162; c=relaxed/simple;
	bh=QKVHsbJgMvYCfZTkrepG838ks7bP5x79WQnW+dpnBJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pNCqce6rMGzqUq3xG4e2CEjf/1fkydFbmgf35TNbbdGX+2iNnGzA3B76Cq3gTeSMVqNZOJc5K4eh/SNcNFCK1pOJQ1D19+pjKRuC+7sOTONSOLpl61gYHnGLcWMoY0jxraciW/xtWX9k1pSHvcnqyvZR+KgIMpjWLQ3wdlrcwwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=geqLh41w; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so4148502b3a.0;
        Wed, 20 Aug 2025 07:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755699159; x=1756303959; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LAdkblPFT1J8wXUecZhIFUXb1WENrCb/QAfzdezG4no=;
        b=geqLh41wUoO+EUzzkdy6gIdn+piM0xSoLZC/xHyIelz70ZTsrSmVTtbRjdU07+AIWS
         /3U9z9wFwKWV7x8jg36JsmkQzKwASV9V5h8jAn7ln8aDqjHns2NrmI0RkMjbObYc2egY
         yN/Wjv/Nyh7bEYBu+OMiq17MlC5Gs1AxPLOOr90gkNYsi3CJivQpAjia2lKHHEISdOLS
         rVOFDR63OAKhPFniNtoquE2Tldo/k4Ca9TAW5FpVzmOl2S1Wb+F+KfDFCXeh30maxYYY
         iJtGfRXHBS/lBanK96p+s0zGHEiD/rYvJAvNK+GQASLkTop20QiGuDMI9JHs1byRfBuG
         wVaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755699159; x=1756303959;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LAdkblPFT1J8wXUecZhIFUXb1WENrCb/QAfzdezG4no=;
        b=CkrtE7DJECC5gi1EYzmEkEKxo8ZQMAAf8FVcTFXktNicpJ7kOiXxsx09i6JZ4z4Y5w
         rOQy6Iv3eTgR8P9y3WZ6L45l+BoCAbBNFleQ7BQJKI9J+sNCMJaEUeQizB1jelHYBGQN
         kaLW1B38dJ9bIdcbK7nVEPqbhnlNBATVkZMYGU5WP2nxYoMGP7EUKupiFNA8sS7v+OqZ
         vimU4YgsmdnNV8/nF/ClgI90s8zn6SsFRjoiWFySLq2MNbsGkM2uoRRB78KWEG0bsmWN
         9JRHXFszAB4Uin0zzEYPgS6jrnzB9V9Fly2A7bUAWyEX/K7zLhR3RK6LJEGkI6SAeBGy
         djzg==
X-Forwarded-Encrypted: i=1; AJvYcCXJhk2zAt4bZBNuhrsRwY3ABWMY3FzEQBOvbV7+p8MrFZRblTJpvsCciSwnQKL0Sldvm3lzP5ae7cI5bloS@vger.kernel.org, AJvYcCXMhrpyjbowXgptB7/cOJwMujGL7fOHAHAjLyh/7kJc9D/eY2Ng9bJukWcWaIxt2zLRSqI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm473o4Binhk5RhPE+U/QUp/urMnnr4V+7KCJQ1CdrDJJT7RRg
	UQ38MxOV+eMdC5eXLITRs7ggQUu6dbpYVmkxYE6qV9Xf5Etqx4CiC9AL
X-Gm-Gg: ASbGncuA/ljxye/ZU51F5H64XNbPGmBYyf5LJYBLCyyNuwzn6cqIV3jfuIIB5Uisz6z
	dSydxnXrWUxrYLNvn/FZEWWrnyNhPRmTm4+Wa+h2Jyg9WGXMdlKqgSk8wkrZSqNZ0DD4xYMAoJQ
	eY6t1fiKJcwhnmyUALeVb/v96wsHjqf3gkLDrF4Ac63x70Itpd130YaPgZ7h6RrFJ2fbaVTq3ue
	7Eehn0g5pPntevAidXMDV8IAEgf7spWbQtHyJ4ytVv5EfKha3W51FTNS5y5PtjLz1DbDw4oK23B
	KtWRElCRDPxNWEoolGqz5xDdmffcyOP4xRm/GM/AZlFhIrGD2v7My86d89amn4Kr4NX9zcANxJT
	zEiOoW6nvonD6GachwsYT5g==
X-Google-Smtp-Source: AGHT+IFSW/3dEhFGF+UkXPQhTiff9IsSfuIBE8GYjm9egl0BNtdmpt217YyBG6eXz3nmvXD/eCxZuA==
X-Received: by 2002:a05:6a20:4303:b0:243:78a:829c with SMTP id adf61e73a8af0-2431b970450mr4807135637.53.1755699159256;
        Wed, 20 Aug 2025 07:12:39 -0700 (PDT)
Received: from localhost ([216.228.127.129])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324e254e59esm2472861a91.17.2025.08.20.07.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 07:12:38 -0700 (PDT)
Date: Wed, 20 Aug 2025 10:12:36 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Juergen Gross <jgross@suse.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: simplify kvm_vector_to_index()
Message-ID: <aKXX1ITCwcVPrKNM@yury>
References: <20250720015846.433956-1-yury.norov@gmail.com>
 <175564479298.3067605.13013988646799363997.b4-ty@google.com>
 <aKXQ0Z4T0RzVnjI8@yury>
 <2927ccc7-07f2-47c9-a902-e66114ea8020@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2927ccc7-07f2-47c9-a902-e66114ea8020@suse.com>

On Wed, Aug 20, 2025 at 04:01:22PM +0200, Juergen Gross wrote:
> On 20.08.25 15:42, Yury Norov wrote:
> > On Tue, Aug 19, 2025 at 04:12:11PM -0700, Sean Christopherson wrote:
> > > On Sat, 19 Jul 2025 21:58:45 -0400, Yury Norov wrote:
> > > > Use find_nth_bit() and make the function almost a one-liner.
> > > 
> > > Applied to kvm-x86 misc, thanks!
> > > 
> > > P.S. I'm amazed you could decipher the intent of the code.  Even with your
> > >       patch, it took me 10+ minutes to understand the "logic".
> > 
> > Thanks Sean. :)
> > 
> > > [1/1] kvm: x86: simplify kvm_vector_to_index()
> > >        https://github.com/kvm-x86/linux/commit/cc63f918a215
> 
> Is this really correct?
> 
> The original code has:
> 
> 	for (i = 0; i <= mod; i++)
> 
> (note the "<=").
> 
> So it will find the (mod + 1)th bit set, so shouldn't it use
> 
> 	idx = find_nth_bit(bitmap, bitmap_size, (vector % dest_vcpus) + 1);
> 
> instead?
> 
> My remark assumes that find_nth_bit(bitmap, bitmap_size, 1) will return the
> same value as find_first_bit(bitmap, bitmap_size).

find_nth_bit indexes those bits starting from 0, so 

find_nth_bit(bitmap, nbits, 0) == find_first_bit(bitmap, nbits)
find_nth_bit(bitmap, nbits, 1) == find_next_bit(bitmap, nbits,
                                        find_first_bit(bitmap, nbits))

And so on. Check test_find_nth_bit() for the examples.

Also, bitmap_size has a different meaning, so let's refer 'nbits'
instead.

