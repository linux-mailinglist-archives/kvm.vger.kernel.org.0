Return-Path: <kvm+bounces-59017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2EEEBAA139
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:58:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25C3F188B99A
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD9430CB30;
	Mon, 29 Sep 2025 16:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JHi5tCux"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEE4CA52
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 16:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759165101; cv=none; b=M6FnZOUr4bkObThf6jJk9T6YR8cQpH0zLcDAvf6iGNU0p9TLzuJ+QJ3dqCxrP980BZySLXB7Mbm/May78s4ZAlKjHMS/etDGkBRks1mIXhr8c4RbUiJDidKuJjZ+5hlKmqJihO39TiCHmNvXRwXWf/J0k3rGaBJ14yhk+L6bvAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759165101; c=relaxed/simple;
	bh=VKv7d7cngFm3B2atDjN7UzlzemC3+Kxp14G5Vq/ZOjo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ga8wSHVO3LbPh4s7u/DpMLcDgyqMnc+fMdZGsY/Le8T1qSdNo1G7WlPZVD/qFg5GcnX4XMaCSMgqxtjANWMTXfdpJkGYR09m9GlhZTdhF6y0UEaokNP7G17dmdruihGchppnMEczmHZODqKcHa34iyvcUNmSPxGzw5yAvAirED8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JHi5tCux; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ee62ed6beso7543460a91.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 09:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759165099; x=1759769899; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OdMoWD+8sPd0aeFM+4LK6/jsYYVgbL8atz0RVERJLqs=;
        b=JHi5tCuxu3xkmu12I9QhTW5HR5F7G0NWRH3lcohUQ8w02gQ7rQyrVxL05ssJ3s4d6o
         k4J6+Nt2SBFAW5w4k58NxcYiCHviX6pdevnq24sZ04bt9ZhAu7kmuRhdGYIg1ghX1Kcv
         +oLsXg+XnZuJ/B9IUGR1nkve11pVT1O5EizX5vvGa6K798WnETgpFaHa9cRag3zTEPm+
         k9Y4G2n6kddn0EJD8C0WAjjKjVWAUs/WVrdipQ9gKuqEH8G4JNpR2mxGvtkdoBfCq0p6
         lFMVB90w2vtI2yX/02i4JWxgyP6Z4fuEHp3XdNlMuAJAEvcu6OcTwWX6vMzAIyC+UlKk
         ScxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759165099; x=1759769899;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OdMoWD+8sPd0aeFM+4LK6/jsYYVgbL8atz0RVERJLqs=;
        b=SMR0nWPn6sGSvJ8gJ+bf+96rlTXgWnxZE/3RmUobtfNoCNH8lnOBMpXfd3Pbi66HFA
         niqTUmbUdrtbb8Tqs2CNA3uXZTSGDm+gc4GlgEdrVEeqY+ErfUEpul0Sn9ipQuxZdhoF
         zeqCuKjHqKypULHk/LA9K0ZWt7dW/dxfh6j4LpzHQKtLR+R5qzvynAxFmopZG3TX6kZz
         7kWKJNZIaPVs7lOEyC6YzCos87rITt9sVXlyX4ZP2N5fos0NkS6hlTuCpbJeZjGE3ON6
         Tc79pXAtZ/I9mFvOvomPBAzdDPoJ/Yzu890LeDMQeJLHfTKwYdQUJYQZygHgjxCnNOPO
         /GMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCp5zbq+hpE2QaowhqD1r3L+o05AsqUhBax6Z5n0W8DVeKHl7UoKHS3FriNd3IfaiFam0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAfX+/n1UEDm+5rGEmSB8qhrR+kpvLyggyzRS9IJ6kHwFv3MMq
	swurJ1GobUfzfiUe4ibTw0cB40BiG18S3lQBgCdPRiqhm1oyyA7o62XbfA0jvz9TiMSCxHRIsbw
	7yU9NMw==
X-Google-Smtp-Source: AGHT+IGxM0nhs9sofgAtj0okpT2qHmx49/V7BxtqN7c0YglaG9gSJgb6NQiq+EjUWRDNDgrCXq58NIpX4qE=
X-Received: from pjsv7.prod.google.com ([2002:a17:90a:6347:b0:332:8246:26ae])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:314c:b0:32e:5cba:ae26
 with SMTP id 98e67ed59e1d1-3342a2ae68cmr18488652a91.23.1759165099219; Mon, 29
 Sep 2025 09:58:19 -0700 (PDT)
Date: Mon, 29 Sep 2025 09:58:17 -0700
In-Reply-To: <diqz1pnp34st.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-3-seanjc@google.com>
 <diqz1pnp34st.fsf@google.com>
Message-ID: <aNq6qWVEBLkWhWFc@google.com>
Subject: Re: [PATCH 2/6] KVM: selftests: Stash the host page size in a global
 in the guest_memfd test
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 29, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Use a global variable to track the host page size in the guest_memfd test
> > so that the information doesn't need to be constantly passed around.  The
> > state is purely a reflection of the underlying system, i.e. can't be set
> > by the test and is constant for a given invocation of the test, and thus
> > explicitly passing the host page size to individual testcases adds no
> > value, e.g. doesn't allow testing different combinations.
> >
> 
> I was going to pass in page_size to each of these test cases to test
> HugeTLB support, that's how page_size crept into the parameters of these
> functions.
> 
> Could we do a getpagesize() within the gmem_test() macro that you
> introduced instead?

We could, and I actually had it that way to start.  But I found that burying the
effective setting of page_size made it harder to see that it's a runtime constant,
versus something that can be configured by the test.

