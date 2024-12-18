Return-Path: <kvm+bounces-34018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C5C09F5B0E
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:07:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6E8B1883DFF
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0718919D8A8;
	Wed, 18 Dec 2024 00:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C0D8JGUc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6364819B5A3
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 00:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734480194; cv=none; b=oG7KwcsJwGrWEgshmpWxznh/aal4r0GIxsV9TsZTtHp7DkfQ58TR/B6iLBXoOvvGZX+xYiFHKbUSlRFSy/Ja3OO9vOz5mzKcZrhjef4VnmdY5BDdG/tTDFer126mJz2t4YKZTWuOSpuux38BtoZ3r2Z4wvjv5qpxSkEwLUWLM/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734480194; c=relaxed/simple;
	bh=+8y0sJt/Y6P33OFP9tjZ5kEt4+lCwIFGiZs3DNl7sXI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XvUUrzWrPmb5wcaMkwy6RhskNUovMolwOTLA6VovXumnTRN6KarvnoRiPsFE8WxmLAM+2jiojMedX6MADXbXmr0/N5cA/6gGY4pw/IGB1F52ZvDnlXiM72ghqiY7VXxsyMu1PR6qJsgT8Pt7kY+jVWAY9hEZJiP2TFzM2zXoXBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C0D8JGUc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734480191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gx5N9I/1lsHGbnyrfo2lWSxL6bVpVGQji1pXukdz9iQ=;
	b=C0D8JGUcjyxGxEntmKWUo3NDCokgYJd/z4V8er1TL6B3gBSxfOKRY6jNU8ewTu7ycKwkwF
	pl8dy7kbnwRq8pBFgNegSKIJPLTi9Ydyr1o70g5DcXEqAzh9X78NwXfqRhCn9yrCzBkHpk
	sRxbC2Dqb3ZJ/XWTe0r0BFJqcMSkK/U=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-pK3U6U4GPXWyFz2Eo9KaOg-1; Tue, 17 Dec 2024 19:03:04 -0500
X-MC-Unique: pK3U6U4GPXWyFz2Eo9KaOg-1
X-Mimecast-MFC-AGG-ID: pK3U6U4GPXWyFz2Eo9KaOg
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3ab68717b73so57398235ab.2
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:03:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734480184; x=1735084984;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gx5N9I/1lsHGbnyrfo2lWSxL6bVpVGQji1pXukdz9iQ=;
        b=PjRN2JnO6PkGufmaNB8clB66CjyOgoX0KmvTbSpRx3p5dvc3HFLy3RlKCR546r4AUS
         cFDSng4cpJHCeYsCMVjW1Pcn4HgJ9JSdryS36/VlahFP8BFVmDBqzfPqPDLt2SBtRxlp
         SBi7Lpw3B96DbQe4Yt2TBb50CxECgcnkQYjFR0dcE0rWVPvOW5WrhWRM4EA4kG12MCWz
         2jyC39H/b00GTLPgRYm6ycFCmSpx8OcUfsfYmxoK3GL16JmKrmM+SK1cviDqbw1bnlIA
         EnkbuFj561SwGRwIis21fzXugN2V3KdXtnuO9lvohG8yOax7CBFPgxWi18HlgmCAo6x/
         IFtg==
X-Gm-Message-State: AOJu0YzQlWu6h7qLV4dEnzh0EWbf95z/axnC3MxHnNaQe6bKYM58ZgTn
	0EhQV8flYQT/cjnNNfKmUIGdFfIHEvgXGPNgA3XwO7/1xJfu9yURpRvZiRkbuW9uvXPgjjWD/aA
	zOuLIjYXmE78sl3fdbONi/f79ofJuausTK78dfprSwqMYeHJtsQ==
X-Gm-Gg: ASbGnctEHdcV7MYGf9oc9akSpz9TlN8haf4RdsY8IiWnwjRyZmUFt8cqFietky6MGV0
	Ml+JP89AzLUq9peT1CuYQ/e6CHRvDqEZXuzAKZQJ+bgxY++y7xvjyPgYjjAq1s0G0uO04vEnRTE
	30Uvngb0mLlvD3GssQfEZcffYmF72UmR4otbR8x+HaGY209VR/CoQcX9//9w62oa7YgeTxY1BBr
	kGGPhnvDRpoYbJ9JTbtHwP3v0Pe/o/4dyESpnwUnuO5z5eF62Gf3uEO
X-Received: by 2002:a05:6e02:16cf:b0:3a7:e539:c272 with SMTP id e9e14a558f8ab-3bdc4f186a1mr10355545ab.23.1734480183735;
        Tue, 17 Dec 2024 16:03:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG2rEHOYhifNGuWs9Bcg4PjuDqaE4nXoeH8qIzkTJ+3G+HZ7blptUJRmJ4YJtTTGYKcF2/lew==
X-Received: by 2002:a05:6e02:16cf:b0:3a7:e539:c272 with SMTP id e9e14a558f8ab-3bdc4f186a1mr10355265ab.23.1734480183348;
        Tue, 17 Dec 2024 16:03:03 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e3d5ea86sm1966419173.142.2024.12.17.16.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:03:02 -0800 (PST)
Message-ID: <948d663c3d5497ff7393305d3efebb7f6198faec.camel@redhat.com>
Subject: Re: [PATCH 17/20] KVM: selftests: Tighten checks around prev iter's
 last dirty page in ring
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Tue, 17 Dec 2024 19:03:02 -0500
In-Reply-To: <20241214010721.2356923-18-seanjc@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-18-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-12-13 at 17:07 -0800, Sean Christopherson wrote:
> Now that each iteration collects all dirty entries and ensures the guest
> *completes* at least one write, tighten the exemptions for the last dirty
> page of the previous iteration.  Specifically, the only legal value (other
> than the current iteration) is N-1.
> 
> Unlike the last page for the current iteration, the in-progress write from
> the previous iteration is guaranteed to have completed, otherwise the test
> would have hung.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 22 +++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 8eb51597f762..18d41537e737 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -517,14 +517,22 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long **bmap)
>  
>  			if (host_log_mode == LOG_MODE_DIRTY_RING) {
>  				/*
> -				 * The last page in the ring from this iteration
> -				 * or the previous can be written with the value
> -				 * from the previous iteration (relative to the
> -				 * last page's iteration), as the value to be
> -				 * written may be cached in a CPU register.
> +				 * The last page in the ring from previous
> +				 * iteration can be written with the value
> +				 * from the previous iteration, as the value to
> +				 * be written may be cached in a CPU register.
>  				 */
> -				if ((page == dirty_ring_last_page ||
> -				     page == dirty_ring_prev_iteration_last_page) &&
> +				if (page == dirty_ring_prev_iteration_last_page &&
> +				    val == iteration - 1)
> +					continue;
> +
> +				/*
> +				 * Any value from a previous iteration is legal
> +				 * for the last entry, as the write may not yet
> +				 * have retired, i.e. the page may hold whatever
> +				 * it had before this iteration started.
> +				 */
> +				if (page == dirty_ring_last_page &&
>  				    val < iteration)
>  					continue;
>  			} else if (!val && iteration == 1 && bmap0_dirty) {

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>




