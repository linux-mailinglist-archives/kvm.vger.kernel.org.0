Return-Path: <kvm+bounces-59543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C9E15BBF169
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 21:25:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 833EB4F0F92
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 19:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3DE12DE70E;
	Mon,  6 Oct 2025 19:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mYB/1Hwk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC2B156236
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 19:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759778696; cv=none; b=N8voNYM4+QebDz6H60A+SGiGKpD9Ik1ZRuCoKCLXKJZ8+X/XVYL8wRhL9tnov6A4gXgoDief6Um8I1t7LOvVTW9vzx6FKg6OJqmeTyhRcAfZXTQvqXwpgleXVncbhL8BzLzBOPMY8fmTBMYz34ixEsxrxkfRAfKeKDzqc0W7oE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759778696; c=relaxed/simple;
	bh=gzzvKnF6qJ7lJudLs/+S8tBn4LMDyPLqXA/nMHePsSc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lSwpbyPnrOTfEcF6QV1qc34/GfC+E6mGhW9MBNiwZTmfqEmhWf2bMSGIESwXNCtm54vbsR2IJUgvewCHayYhikiDlt/32DsCaf/oLt2nhRxYIJ/ar4O/pjt6qKUSON8m8RB9xc0T7VkXI1giyMsIKM7BQBW1kTqYv6WhCzQSeAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mYB/1Hwk; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-780fdbbdd20so4216894b3a.1
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 12:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759778694; x=1760383494; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MwCv/q5RLrOVP5H2/mUJFVpJKUB0tJIPOkj23AFdbos=;
        b=mYB/1Hwk5/djOTQkZojycRPAJ17J8MkN12THO24D6IxGz4uHfoLTEQZ6OE3cvFtbfP
         b4p2Ak4Dyc40UZKmkrqy7vXWJB6ce5yn+nW0ASQI4fRFEd4pZEdFnFuOkWawfqCzWdNj
         ciVjSDyM0vZ0IfpZezELznHeQkRtEWiKbBF4t9supT4HdBEOEeNyhAjryPJZEst6epx3
         6NV95NWGlQv2Nk9FrTr9wog3LXU215QcdMy0rS7YGnJdO4eBM5iUqfN2JegLVbRPIXHH
         NyAwGajYxqvkVCIsU4YCzepF3+y7AUNzIMg+Smz/daP2EXH0QaXL+oVnUTM4v1UWYvMo
         sENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759778694; x=1760383494;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MwCv/q5RLrOVP5H2/mUJFVpJKUB0tJIPOkj23AFdbos=;
        b=GwwcAQ/AEESGwJ8k49N9Pv7Vxcm8dXe6YihFZG+ZEZJUc15HI2E91JFLxIpBlafZQ9
         N/jV4zIyc1+nQRBF7DXIqwI/NS3rbpKF2z/7RHNmpGhNhVoqMTN/7vbzwgGR2EY9OQSb
         24SoIb5bjxSYrNfVAq/pu7J9Bk1wcuKsTCRvOcsM3u7InO9kn00G+ySwVfHpCPSMv9FC
         aPsP9FQVV+/q+wmyVQFhdclMgzfT9XkEuPpOHOz5L8RhIzQfLkwltvLggYrTCb9HPe0Y
         M7gCkKF7WvHSkgTIh61kkLRz62erLSS58lMyYC0aEy9/5pD4wGlaLc+z3WTnqVGra/++
         DHAw==
X-Forwarded-Encrypted: i=1; AJvYcCVwCuVtH6PUJ+mpymvKOE7d/uvjsPuwzeVsprzKFCRb/RzBTAYHAytXpv9HCs16uFCrFYQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkIbzWrp9kvLMeSTSKDyONLDXqnLBEZ+pxfAASVAjBoSfO1CSD
	H5VaeAdl5XMONxWDClYYp0dcE5AmcS/acPBzoIrU+U5QbtA7Tiul8Zj9n4ovH1lKwyjT8PbTWys
	XuYdOgg==
X-Google-Smtp-Source: AGHT+IHiIsra+i6pzpFSJKTUcR3R1ZEtEd8CiGXaiveuskEqCtWdUdLIj7ydtiLIe9mDGjYusezaU4r2um0=
X-Received: from pgbdo10.prod.google.com ([2002:a05:6a02:e8a:b0:b5f:5359:4b92])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:e290:b0:2c2:626b:b052
 with SMTP id adf61e73a8af0-32b6209da14mr18587401637.38.1759778693902; Mon, 06
 Oct 2025 12:24:53 -0700 (PDT)
Date: Mon, 6 Oct 2025 12:24:52 -0700
In-Reply-To: <diqz5xcrgaa5.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com> <20251003232606.4070510-14-seanjc@google.com>
 <diqz5xcrgaa5.fsf@google.com>
Message-ID: <aOQXhJyTXHt8Kw7F@google.com>
Subject: Re: [PATCH v2 13/13] KVM: selftests: Verify that reads to
 inaccessible guest_memfd VMAs SIGBUS
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 06, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Expand the guest_memfd negative testcases for overflow and MAP_PRIVATE to
> > verify that reads to inaccessible memory also get a SIGBUS.
> >
> > Opportunistically fix the write path to use the "val" instead of hardcoding
> > the literal value a second time, and to use TEST_FAIL(...) instead of
> > TEST_ASSERT(false, ...).
> >
> 
> The change the use "val" isn't in this patch, and I think the
> TEST_FAIL() change was intended for another earlier patch.

Yep.  I originally had the TEST_ASSERT => TEST_FAIL change in this patch, and
forgot all about the changelog when I added the SIGBUS "catch".

Thanks!

