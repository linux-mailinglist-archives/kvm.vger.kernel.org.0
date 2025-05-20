Return-Path: <kvm+bounces-47177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED317ABE379
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 21:12:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D6AE1BA406D
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 19:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64207280015;
	Tue, 20 May 2025 19:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dNQrtfE5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0ED4242D92
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 19:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747768365; cv=none; b=UH5pk7olTI0Y5H+llerAFduWqqFy6r42AFFYu/CavZ9P7fUbtt75+NnkVt3sZpNaJR8FeRgeESTrUTMa7BsCgM6TQeHwvD5xqH9+QKM+f8DTLbV/fziKbG0+bZQVC9rL0fz9lTcuFF9Hd6lOp1ihSYAVgSTNTrPFhdWXuIy1vUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747768365; c=relaxed/simple;
	bh=82P0t2yO1i5cBFlVquv3GCTGcdd8SMKT8Mrys7Rl5vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHH0UkdiIwykAW3DZSWz8RuQ87zR0yZHMGQMRNnrDt6YIKPOoHk/wRqng4/Imx1Pb5DuEadIbN1oNzfom+QTOTrXdWUiIwsc/26MFT3MU2GY0FXm24LMgk9T7UwEYk6F8/GT+Ju4g1My405WMwgprZ7FVe827ITXZ+FNi1T2U9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dNQrtfE5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747768362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2HyJTD3mME1yfu6pisM5LB773OGEDQNPNYsSNdYA/II=;
	b=dNQrtfE5U8fQY0zwH042xPOSUzBf1uxdhDAbdQvemJKvWbyc3U+XcNPhtnIuxUeSHadjyg
	FaRujfH0CGlwE6nFmLQHXKIO8MADJtgEm6NfU2R1mOg/81r3lhEqIP8pnlBX/gsNwfYJHe
	TIioPYIk/1wh8ZUZjrO2PyivDgyciig=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-9iq9WWzFNwiLAhiBEw3W1w-1; Tue, 20 May 2025 15:12:41 -0400
X-MC-Unique: 9iq9WWzFNwiLAhiBEw3W1w-1
X-Mimecast-MFC-AGG-ID: 9iq9WWzFNwiLAhiBEw3W1w_1747768360
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7c793d573b2so1073949985a.1
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 12:12:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747768360; x=1748373160;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2HyJTD3mME1yfu6pisM5LB773OGEDQNPNYsSNdYA/II=;
        b=D+ywtT7UcSrSodUr77IALjy0Gx8LV114GJ9RWq6MUgzI3CjIHM429hJlsLdxq3jEKR
         faaoPRSTcji5Y0Lot9jedv+YzFd6Cfh5vEo/eZUA9SW3WQtBvIXUFqqq2ss6YyL7/D1y
         022excLxNeczTWIa6NUud2mgomu5fhcwvTcIgLG8o2pITK545PB78C7MJmqsLbra56DK
         bxlEKNK1ihBdB6KtSs44lx3Dpi/gSG19mFTfFvxvR+LBnMShE5900p5MtxFrjgcpoLtf
         sl9bVLZIyPWiCZhZUgXBJ3vwUFEE4n5wk5saKRKpwQlwxjCVaR6eS3MMwa5Idb8/i2ql
         atBQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/CeG2Hh0Lbf3T0A5e4dkx2d4NhHAUYT1o6Ip4RsKaQfG0xIjgAH6LmSqdeszZ2Y+3Qq0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuHfBLa4wec2f4bjm9oTAhRTlnpcnlJXhjWI3Grp6PZu6ipDee
	A85FYaoRHV1h9k6qU6rTtg1ly8UW0iuqtOxHlsHC98OXklQbsfFHQaAHlcSqaeOkgLUAHCr+GQ6
	sgQgFau83qoBnUU08VgxpSmHvaHgSVve32CBTyOb55Moj9h7oPqavZg==
X-Gm-Gg: ASbGncuoLVwP3ObDUPXZ7dZNYDFLb3xzJ6+lPvrDkgl/DRi/7LER5YjJ1Uu98F7LQpA
	TmawHgZWWuY8WKWgNGp+eB4d7XlXpjst5jQkuxhcUgVLcblsxQ5Em2Os4sWjf+lV25r3uGRzJJb
	8zDGrrVzXejxXyFq4YhVNEG+jIfx0gdOF7MdQIc1u0tiqLcUTkEXIQAnQUbSEE+IDz8I9L/P0Ko
	+cN/IX6QQtk/sVOt46rzfbLF500kG8gWcTs08lrf64aXQtGURL02gLSBdFkg3vD8n6HQBumnoTd
	Lbk=
X-Received: by 2002:a05:620a:319d:b0:7c5:3b52:517d with SMTP id af79cd13be357-7cd467b0d86mr3038257185a.54.1747768360565;
        Tue, 20 May 2025 12:12:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWz4FNevXJR1OnAQxheNRs92oMXIa8Lbsy1YjYg0d6xnbO2XUQP0QG/i0To2I5eS4AQiANwQ==
X-Received: by 2002:a05:620a:319d:b0:7c5:3b52:517d with SMTP id af79cd13be357-7cd467b0d86mr3038253785a.54.1747768360219;
        Tue, 20 May 2025 12:12:40 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd467dae90sm774378185a.46.2025.05.20.12.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 12:12:39 -0700 (PDT)
Date: Tue, 20 May 2025 15:12:34 -0400
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	James Houghton <jthoughton@google.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>
Subject: Re: [PATCH v3 0/6]  KVM: Dirty ring fixes and cleanups
Message-ID: <aCzUIsn1ZF2lEOJ-@x1.local>
References: <20250516213540.2546077-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250516213540.2546077-1-seanjc@google.com>

On Fri, May 16, 2025 at 02:35:34PM -0700, Sean Christopherson wrote:
> Sean Christopherson (6):
>   KVM: Bound the number of dirty ring entries in a single reset at
>     INT_MAX
>   KVM: Bail from the dirty ring reset flow if a signal is pending
>   KVM: Conditionally reschedule when resetting the dirty ring
>   KVM: Check for empty mask of harvested dirty ring entries in caller
>   KVM: Use mask of harvested dirty ring entries to coalesce dirty ring
>     resets
>   KVM: Assert that slots_lock is held when resetting per-vCPU dirty
>     rings

For the last one, I'd think it's majorly because of the memslot accesses
(or CONFIG_LOCKDEP=y should yell already on resets?).  The "serialization
of concurrent RESETs" part could be a good side effect.  After all, the
dirty rings rely a lot on the userspace to do right things.. for example,
the userspace better also remember to reset before any slot changes, or
it's possible to collect a dirty pfn with a slot index that was already
removed and reused with a new one..

Maybe we could switch the sentences there in the comment of last patch, but
not a huge deal.

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks!

-- 
Peter Xu


