Return-Path: <kvm+bounces-34159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C1C49F7D8D
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 16:02:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC73016D8B2
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 15:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 458AD225799;
	Thu, 19 Dec 2024 15:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ipr4owQB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF4541C64
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 15:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734620500; cv=none; b=A75g+m7kpPW2chfe2h/WnREaqW+gQlrcj8t5Q8JnQdCtJhNR8UXFHJPt0dMOsH831UyQY1f/HsI2i5JXzpZyjTrJvIyP2tqrA/KvdZtiqoLMRCNk6pxUfDRCTo5enOgz7lit4wncN07MkSi99s7IA4+7E47cy5zDSwaEYf8S/Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734620500; c=relaxed/simple;
	bh=JW2dvRsu+WKaJD1wokv8hwFfvhqLfFHt8Eosj6gCcrU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Fn8JULiKnZBhyjhLTIC0jU99YFjGtIlRlYbg2cIfY+rcJFA5qk5jRdvA9TIK0GmsndPUpI/ppt38UeOKMWPZHir9+LVILR9SlkMUYDgP0d1z7TlHqHikdwWhA9qvUBUBeYWrKHbqa91AkbpSjJFuwfStAC3EzvsqJvtJjD4Kvm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ipr4owQB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734620497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ViPFqi2yF1rQ5/OaY+y9J3NqQ+aaVPbipXBkyEcrYEY=;
	b=ipr4owQBRfjUzyvON3w3EXqSAuEHT59CZOXyDN6M2GvHXiWX1QiYZymNbkJjUNv7NB2B5a
	89gLO5MCsnHSgAWBFWYIBKX6PO9JUPlTzxxOEXZZ4zqHM8dHeEMNsuIfSJIr6W7sBmMx0e
	ZcDwrET64avjUALoYzzYWFvGeZVjqqc=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-ch02RxnrOYavnAgk_QtTCQ-1; Thu, 19 Dec 2024 10:01:36 -0500
X-MC-Unique: ch02RxnrOYavnAgk_QtTCQ-1
X-Mimecast-MFC-AGG-ID: ch02RxnrOYavnAgk_QtTCQ
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a817e4aa67so7068855ab.2
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 07:01:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734620495; x=1735225295;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ViPFqi2yF1rQ5/OaY+y9J3NqQ+aaVPbipXBkyEcrYEY=;
        b=c+0UwcFJayTDMq+uNq7da3ruK3YZoFtdaTwd7w8jhMfdxxQAwHU6ZIpyKFJaEjgatQ
         TY2gsQv053113TTLFsfd3hNzqoRetpb/m5RQBLchmf6OhudeXy59zewd4uSs4uY9hsKk
         svpjciK9rTlJAUwIqCcHoROW8uore72E1ByI09eMMXGGb4vbJLRQsWEWpJTE0uGxpJM+
         xuLNxYEhAd0yiH+whImSoeClO0Pzb6eVEk7DzaMRilyZy7RX8/FQ6Ti9dawvccmFu2fI
         hDl5thw1nvoaO+rIY0rc4e+MXmvVMFF6HVTwUVP+uA3ch2zdxwfoK2Fr9rr4vbtP8e3x
         CD8g==
X-Gm-Message-State: AOJu0YyNy6gZikgCPHkFFzi7JKTDQ2FPUyF696akYeGcBKW+9yK8FIiv
	v6akniZMyzIZ3ifhqmEdFLiht2aV4qeiGQk1TFKBFnYT/wK0BUrOC/Sdx3CH4gP0uFAF1UljLdD
	tyMSfgs0scBhi6aux/AC9BbwzzOM3Uv3nKpDTFgKhxeTOYhleJjUwKco+sA==
X-Gm-Gg: ASbGncvkDp/1FKHWFHnquBux2v2ZhQVP+SagpFc9fX2lfqKaP71GYksldqhmv1kTGNd
	ux+iMZGqwaAZCaS0eQCjtzEqKwbwXBvHJlO5E7t2LpEiCfonhtKwvWSZlmmFCu0h0UYVylrzCGb
	jKBIso+N3HvF/BoLn8MKPbiV6W3OPc5dEPu0U6a6BhjwN8Y2fSbRZ4UVG7qSm1b/gcaOqS4Oldh
	rhY7iTfCspgqQ9V2mNr6h933PQHSyp6F0dNyxBGvBJZ4remStTyVBMM
X-Received: by 2002:a05:6e02:1c81:b0:3a7:c3aa:a82b with SMTP id e9e14a558f8ab-3bdc003e775mr61834485ab.1.1734620494995;
        Thu, 19 Dec 2024 07:01:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH2N9TF1k63Od4kikgXEkYiTMrQAPSa5Hk4ZXuksk3JLSjxWMWr1eWQIHuzkEKx2sEfTJNzWg==
X-Received: by 2002:a05:6e02:1c81:b0:3a7:c3aa:a82b with SMTP id e9e14a558f8ab-3bdc003e775mr61833965ab.1.1734620494562;
        Thu, 19 Dec 2024 07:01:34 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3c0deccf373sm3542685ab.28.2024.12.19.07.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 07:01:33 -0800 (PST)
Message-ID: <680a0b7b95b9300d2972246fbfd93f000ce0c0be.camel@redhat.com>
Subject: Re: [PATCH 14/20] KVM: selftests: Collect *all* dirty entries in
 each dirty_log_test iteration
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Thu, 19 Dec 2024 10:01:32 -0500
In-Reply-To: <93e571e9-5539-454f-9335-6de8339ffd8b@redhat.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-15-seanjc@google.com>
	 <fb179759bdc224431f6b031eaa9747c1897d296b.camel@redhat.com>
	 <Z2OBYYQq6cwptSws@google.com>
	 <93e571e9-5539-454f-9335-6de8339ffd8b@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2024-12-19 at 13:55 +0100, Paolo Bonzini wrote:
> On 12/19/24 03:13, Sean Christopherson wrote:
> > On Tue, Dec 17, 2024, Maxim Levitsky wrote:
> > > While this patch might improve coverage for this particular case,
> > > I think that this patch will make the test to be much more deterministic,
> > 
> > The verification will be more deterministic, but the actual testcase itself is
> > just as random as it was before.
> 
> Based on my recollection of designing this thing with Peter, I can 
> "confirm" that there was no particular intention of making the 
> verification more random.
> 
> > > and thus have less chance of catching various races in the kernel that can happen.
> > > 
> > > In fact in my option I prefer moving this test in other direction by
> > > verifying dirty ring while the *vCPU runs* as well, in other words, not
> > > stopping the vCPU at all unless its dirty ring is full.
> > 
> > But letting the vCPU-under-test keep changing the memory while it's being validated
> > would add significant complexity, without any benefit insofar as I can see.  As
> > evidenced by the bug the current approach can't detect, heavily stressing the
> > system is meaningless if it's impossible to separate the signal from the noise.
> 
> Yes, I agree.
> 
> Paolo
> 

In this case I don't have any objections.

Best regards,
	Maxim Levitsky


