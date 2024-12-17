Return-Path: <kvm+bounces-34006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E709E9F5AD4
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:59:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 309B116595A
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 23:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36A071FA8EA;
	Tue, 17 Dec 2024 23:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LjGq7mLW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DE81F8F04
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 23:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734479940; cv=none; b=EGkiEpthgvvhRI+2MMWmXvnjgT818uxzdlhI3ipj2k1Yj1HNSaZV71iBoXX9uaUTP6VVngS9sNHd4xf2ey5+Bvvkvr0yfhZ6tET7buhzejMVWcs/h7qeCtSIeXxzSXpvmmIV0fI7JKlWPkIjvq3XW/o9RksrPrDD24YXTTnWdkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734479940; c=relaxed/simple;
	bh=253X2/Ygyqv2mDIgmCRCiJ2f6echdqbAGCfdLInW6S8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bjS/8GEk1An/Zr0oGmMKszuiOKYNqjzr9ZvwtLu1uRfxgtHBUrJDV0HzpejPKsT4blwdKRw8YRz9Qm9IplBrmOgUc+srjmJsT2z4KlkYjUHVsuQdaTxrHnFG1XPXPHmCsGhEd/+WUKdg2sAvqPzLMYRnBB/v7QiUgUVzWYaxEEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LjGq7mLW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734479937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ctAzpqF3UG/0IGfBE9fGS9dSSJ927UqahSGZ4siHpoA=;
	b=LjGq7mLWdjgi/UDdYXnaZY8yy34NWCx50YjYWphXMvanjgseRr5ozZkw/ShUPiBfjB5Pvg
	iymzKIHowDSimR7sO6BNZ9XwwYjhrXuePt6Pzb4H74yLh1bHBFnYbfgXi919BC9/RGIRE+
	DXDd68ZmSgnqB1wXOeeQz2VKCheaVC8=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-nmy04h7FMZyPJ9SU18hztg-1; Tue, 17 Dec 2024 18:58:55 -0500
X-MC-Unique: nmy04h7FMZyPJ9SU18hztg-1
X-Mimecast-MFC-AGG-ID: nmy04h7FMZyPJ9SU18hztg
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a7d60252cbso2324765ab.0
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 15:58:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734479935; x=1735084735;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ctAzpqF3UG/0IGfBE9fGS9dSSJ927UqahSGZ4siHpoA=;
        b=JHUyiMkuAgvhhdDAX3QC28odihIg4YjmQkyfkMg/qdJFavPppNF/qsSf6t7xH0VwKd
         bC080zFKDi2z6FL1aNl73EDLp/ixg4+M82OcmVYqpWHn4uJBug3tobO3JT1TcYsc7KpE
         Z8w68P20kyHJuUtH225hS6Q2qxoPsWdHW7iSm1qSQ1bvKfP1M4HpqzXTCsE9gC0u4oaN
         vgoddwl0U+XpXzg7IxBz/+AknBJMpkNBmMYAZiDrhlrgXYf3yKptAvBs2Ch+Hi7sYom4
         gs7hm/ydue+xQ8CUp17U58sZfVqRmIf5dZF0v2d5cAxGFbbZYa3zQSC5iPvlgM9cFCzy
         kyFQ==
X-Gm-Message-State: AOJu0YwCLdHYgO+zRpi62YgtzmfOz05U44pBJoWtRQtO46ohur+JBZDB
	ssDmyQy2ar9q7nk5pdtqVUxuaf9RoR7j61YDArvUsvTI9LEDBFrHcioAdAp6+13PLnYO4M/df1t
	8PQc8HlBsBY16nJyBEU6QRWOU2PWytSMXl14Uk+u8LnEdz1FlqA==
X-Gm-Gg: ASbGncuqhiRcXheGv8+CL0giKhh0uM3vyiYbirCB6yKorEtDIWpiDl421pPYx/ChaPW
	Dx4J3lJFL1dTzEcVgMxzQLGAD+vzta3ap2rEVC9gb1IcFOkuyap9Xd5HRf1jxhWxYOn8IAzWbbp
	3nRz1NSBAjlbEMBBRagNSdbh1hII846igL+v+df9NI1z/djQhYtgSguh1kn58/FKbSJ6dGSizoa
	IJhvH+a+MCw74toHcJG/7OpfW+6P4436Y6P3IHTWfRx5YSOM/LZm52E
X-Received: by 2002:a05:6e02:1c81:b0:3a7:7bab:33f8 with SMTP id e9e14a558f8ab-3bb0ac12cbamr52792835ab.12.1734479935329;
        Tue, 17 Dec 2024 15:58:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGA+uenBegmVd3ZbmklJV5z9+lx0na5Cd6JyRPWDb28FbNFSzXQThlGzm9jXpNBxqxJhvkv+Q==
X-Received: by 2002:a05:6e02:1c81:b0:3a7:7bab:33f8 with SMTP id e9e14a558f8ab-3bb0ac12cbamr52792705ab.12.1734479935042;
        Tue, 17 Dec 2024 15:58:55 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e3c69e42sm1901805173.156.2024.12.17.15.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 15:58:54 -0800 (PST)
Message-ID: <f91364794fd3d08e2eb142b53a4e18c5b05cb7c4.camel@redhat.com>
Subject: Re: [PATCH 02/20] KVM: selftests: Sync dirty_log_test iteration to
 guest *before* resuming
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Tue, 17 Dec 2024 18:58:53 -0500
In-Reply-To: <20241214010721.2356923-3-seanjc@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-3-seanjc@google.com>
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
> Sync the new iteration to the guest prior to restarting the vCPU, otherwise
> it's possible for the vCPU to dirty memory for the next iteration using the
> current iteration's value.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index cdae103314fc..41c158cf5444 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -859,9 +859,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  		 */
>  		if (++iteration == p->iterations)
>  			WRITE_ONCE(host_quit, true);
> -
> -		sem_post(&sem_vcpu_cont);
>  		sync_global_to_guest(vm, iteration);
> +
> +		sem_post(&sem_vcpu_cont);
>  	}
>  
>  	pthread_join(vcpu_thread, NULL);


AFAIK, this patch doesn't 100% gurantee that this won't happen:

The READ_ONCE that guest uses only guarntees no wierd compiler optimizations are used.
The guest can still read the iteration value to a register, get #vmexit, after which the iteration
will be increased and then write the old value.


Is this worth to reorder this to decrease the chances of this happening? I am not sure, as this will
just make this problem rarer and thus harder to debug.
Currently the test just assumes that this can happen and deals with this.


Best regards,
      Maxim Levitsky


