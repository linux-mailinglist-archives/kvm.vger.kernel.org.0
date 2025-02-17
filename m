Return-Path: <kvm+bounces-38369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EA0FA38413
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 14:11:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 090343B9B8F
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 13:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39EC721C177;
	Mon, 17 Feb 2025 13:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f1OsVoB7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAAA23C9
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 13:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739797556; cv=none; b=dk6QG4+sqMOVhjpcYcOxuGSRagfjzwuq7cuxWfM/WgOpXiaxzF+5O7sSAioMI+XxG0KyWrArRjBZdtgCcYl2iew+sohfc+aFaasx04t+6s3ClQmudJ7XmJPaMZRRe3Dfszz7bwHwPR3LIUQ+5386dZQSk+jNDDhFO7x9tDB5LsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739797556; c=relaxed/simple;
	bh=ZKAxYYLxdNCr5VowdCBtoLawSOPUB9oQdK09VtVgZeM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=R8x1eY8FzKWzSyEBn1ce+ha6VnzwcCNe8QU44F9aLole5WCV4urDxkFKkg8EWUu1M4CS1U+Ws/IyQbn4BN7LHDtpTtnZzzxAEhQ8qoS/UXxeGPIXHOFmgpQmtZaxrF7IbYRSRtZ0yi4aXF7m8PKfZj0BxWFUb98lSm5ZnIbNm6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f1OsVoB7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739797553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kSiOdtiiGo1JzX8LMRCdFTwQjInIJfdLf9Cgv1ZJH3g=;
	b=f1OsVoB70dTDcOJkkgi2gcwk1vrdjg6FixWGzHrriUOeAiZOu4gRmcWBCCHtvDUNUOxGL8
	tJ54gFwYOQwmemkNqJD6a7m+PgvZG5/AytNfhrFkyP4Scbc9mhZQxRaFxiTbzoWKDlNw3m
	zAsFyrHwVaw6sL4fLMFM5j+JHMWtl2Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-N3LSp413PMqTQNepC7Yi3w-1; Mon, 17 Feb 2025 08:05:52 -0500
X-MC-Unique: N3LSp413PMqTQNepC7Yi3w-1
X-Mimecast-MFC-AGG-ID: N3LSp413PMqTQNepC7Yi3w_1739797551
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38f2f78aee1so1635920f8f.0
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 05:05:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739797551; x=1740402351;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kSiOdtiiGo1JzX8LMRCdFTwQjInIJfdLf9Cgv1ZJH3g=;
        b=OQSK5Ed1EHcCvGXx2maqIvebSqc/KxmisG+UcEHcmt/aFJZNMB2uixP3QFN0QblYqP
         XKZ6Qw1MoqpLYbUvnU8ySxpGTYdP7yDWGQ09331oaHAv5EvtOAp+JK4pBemudM5gEzlb
         2qeQChjKnyIU2mdYLUP9Q9Q6cF4w8fGZcC6LSirRHtpqyOET8vYGy6I86BZ20bWeIpwm
         R/swWV5mFhWQY7Uy39GlVap4O+4cwdaou+4of8cHjni/quLhkWeMiieJDnMon6CDV3Gn
         2DWh2yI5P4hLTSUqPb47NtTk3vkukQEu8vRPaZlka8/bMvh7uYCYqowbmYVjkAVMMdti
         HBIw==
X-Forwarded-Encrypted: i=1; AJvYcCWMmGd/2wLhqATc8PTBZF0ZJh568zO/kQcCW4qAziq+1pW37L2l9z9U+fjh6QHyj3n2BrE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9L1BUVF2pNUFzUYGgR/589NFyIwBeVYAVrR6HYccYXxS6XMJE
	bZBWM7mj9fg+e7P9oO/BASPQfvvLiYDTVfvv6/9K9vPP5BujNn5oVMFlS1J1E1mkBIdlpNpJrLH
	qN/aFekz2BByLzQShcAhvUKOgfNM4qwJm/ldKphzb/MF7sy5QGf9hMhNi3Q==
X-Gm-Gg: ASbGncukItfH/6Kf9dyDOd5ACyONDtKrmrib5anKd6XbymRubCc//vzkMs6wUHJQuWB
	czKWlhzKTtpxYGQdtdmPq8IBHKRmy5QZfWqzpzuGeUHTHbng1ysoCKr4scKei7hnSGb2Fo/9FsM
	PX/QjUl0xjs5kQ7h9v824apkeV3AX0iUF/KBZEH7nvvns88miHqfYi4OEXdPQolDl9wUfDsw8r2
	AnfXuCKBmowq5281ubl4xisGhSEtZ3Rij1dV8175yNLP80QQ0fNb0jVWRDyXidBdyekMx4kV3/M
X-Received: by 2002:a5d:6f19:0:b0:386:374b:e8bc with SMTP id ffacd0b85a97d-38f24d10851mr18090994f8f.15.1739797551246;
        Mon, 17 Feb 2025 05:05:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGSLtEqy93wRPXG9nMCMJ0lRt4GquiQhPG/wEddubWd1+r9Qa8A53oIvQqaL6k/Vn2poTgPqg==
X-Received: by 2002:a05:600c:4e8d:b0:434:9e17:190c with SMTP id 5b1f17b1804b1-4396e7d3b00mr82441835e9.0.1739797516788;
        Mon, 17 Feb 2025 05:05:16 -0800 (PST)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f25915146sm12383958f8f.56.2025.02.17.05.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 05:05:16 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Nikita Kalyazin
 <kalyazin@amazon.com>
Cc: pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, xiaoyao.li@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 roypat@amazon.co.uk, xmarcalx@amazon.com
Subject: Re: [PATCH 1/2] KVM: x86: async_pf: remove support for
 KVM_ASYNC_PF_SEND_ALWAYS
In-Reply-To: <Z6ucl7U79RuBsYJt@google.com>
References: <20241127172654.1024-1-kalyazin@amazon.com>
 <20241127172654.1024-2-kalyazin@amazon.com> <Z6ucl7U79RuBsYJt@google.com>
Date: Mon, 17 Feb 2025 14:05:15 +0100
Message-ID: <87frkcrab8.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Nov 27, 2024, Nikita Kalyazin wrote:
>> 3a7c8fafd1b42adea229fd204132f6a2fb3cd2d9 ("x86/kvm: Restrict
>> ASYNC_PF to user space") stopped setting KVM_ASYNC_PF_SEND_ALWAYS in
>> Linux guests.  While the flag can still be used by legacy guests, the
>> mechanism is best effort so KVM is not obliged to use it.
>
> What's the actual motivation to remove it from KVM?  I agreed KVM isn't required
> to honor KVM_ASYNC_PF_SEND_ALWAYS from a guest/host ABI perspective, but that
> doesn't mean that dropping a feature has no impact.  E.g. it's entirely possible
> removing this support could negatively affect a workload running on an old kernel.
>
> Looking back at the discussion[*] where Vitaly made this suggestion, I don't see
> anything that justifies dropping this code.  It costs KVM practically nothing to
> maintain this code.
>
> [*] https://lore.kernel.org/all/20241118130403.23184-1-kalyazin@amazon.com
>

How old is old? :-)

Linux stopped using KVM_ASYNC_PF_SEND_ALWAYS in v5.8: 

commit 3a7c8fafd1b42adea229fd204132f6a2fb3cd2d9
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Apr 24 09:57:56 2020 +0200

    x86/kvm: Restrict ASYNC_PF to user space

and I was under the impression other OSes never used KVM asynchronous
page-fault in the first place (not sure about *BSDs though but certainly
not Windows). As Nikita's motivation for the patch was "to avoid the
overhead ... in case of kernel-originated faults" I suggested we start
by simplifyign the code to not care about 'send_user_only' at all. 

We can keep the code around, I guess, but with no plans to re-introduce
KVM_ASYNC_PF_SEND_ALWAYS usage to Linux I still believe it would be good
to set a deprecation date.

-- 
Vitaly


