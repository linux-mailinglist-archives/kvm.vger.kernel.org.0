Return-Path: <kvm+bounces-32153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E2CF9D3CD7
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 14:56:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FDA92823B1
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 13:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 004D41AAE13;
	Wed, 20 Nov 2024 13:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HEnAUsld"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D73F1A2554
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 13:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732110959; cv=none; b=himRUSgCDyx231/QMcP6IL4Hu52BLwY6ukqisDIDd8PDaHXBuPt3C8PutbQMw0pg52reZu7RLTBE954RgnqXIjmJh7HcFRpps3mgZMVzr+ZyzPBTOCkCb40N+KCf55/EHDL+mBcNA/ku8NmqI/3t7B7qClBdb7f1RIUd+3WIuZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732110959; c=relaxed/simple;
	bh=lS0k0QVCakrIVbVemWDBp46czig0ShsrxsyUeBX5S/A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sgsz5w96PuRg8vT7btb2nEXeM8niwLkiXMMY+y270OZZiHePBoGo68FTZJ/jq+F74CYubKseZbBvXfK4Ot/rRYahaZUri2eCgiaJ2ci8svgJZ3FprLKAtO9qiFZKl4CIOzvhxtod7wPmzr/UmFJTrHVFlRtXKNqyCLlTVqOv44A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HEnAUsld; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732110956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Leu7njKM4u8OR2ZgAY8Gk/TTu8WWKCDop5cA+VNKFbo=;
	b=HEnAUsldtFyheVEeQsUTD1Da+NXAuASDiqevJFu6TQ3KDeQtfJO6ZtFw8IWfjHUs1Z6VHk
	JLPtycwT0xTlO4Cqn9u1kOJXkLzriOrDAvnTkM88gZDFYbFcNwnqrQ1O1UxsF03wTKEbTF
	MEtADbgQBccW7WkarDNtB99/Dofvf+o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-I83fEZ7CO32lhXKhE9JXIg-1; Wed, 20 Nov 2024 08:55:55 -0500
X-MC-Unique: I83fEZ7CO32lhXKhE9JXIg-1
X-Mimecast-MFC-AGG-ID: I83fEZ7CO32lhXKhE9JXIg
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43164f21063so41983295e9.2
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 05:55:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732110953; x=1732715753;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Leu7njKM4u8OR2ZgAY8Gk/TTu8WWKCDop5cA+VNKFbo=;
        b=gpi9HqcGrYaJCYfNpRF5UOLWXtXG1UZ3YH+prv+fBNUydXW+2sklHhPbtUpxiLsBF0
         DYDhMtegr9kjGnY0aq3qhAs+EqphsQwFAf0i82F2UkuA86eKQziESyokAfIJypQhbKPq
         fwe2+3AgQbO5iyTwsldEXAoQwaZ70yRC+GMAwtAfuuk0gOavEfBrdrhI4ma8kdyJ/soQ
         zx71+GrQMrPu/Jg4aKOSa8JXS2qTXC4Y8NnvvpaKtl0D8bNRE09HBIAuzyula2OkXShN
         fuXIVyFk2PrQlgJJQc1ErsgaKGABSR9NS5UcdPPEvGzNPM0MxNw4gAoI6lWN4HhIHVWR
         2lDQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0Z6EH2/inZupoNEDJ7881txTqplNeUqoG0nDeZhEL91QuUNkt9Wqx34MtyN7KQUWVK+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIIDYKKcbL5z0/KqQJPbnf2peA9QIvcRAgmwMVLxaMKQWamPLp
	pktvuTAmsnZT0RqVPps+Wax8BIkdcovyVEOhVBVDUcLxsdVuv5Q4R3e9XuLzarSNqOE+8hFd3V4
	IbakT7GomNZSRmk+fK76DnA6VLtL0PPaKRBkwrFg7A/qhG4DHaQ==
X-Received: by 2002:a05:600c:3505:b0:431:55c1:f440 with SMTP id 5b1f17b1804b1-4334f02192fmr27169905e9.30.1732110953524;
        Wed, 20 Nov 2024 05:55:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG51bpAuR/KKUWNbo3qmyx1+cV+HgfoA7+yduGe4E6R+OdTUIKh2z/ixXanUzaRBf/n3m5+HA==
X-Received: by 2002:a05:600c:3505:b0:431:55c1:f440 with SMTP id 5b1f17b1804b1-4334f02192fmr27169745e9.30.1732110953176;
        Wed, 20 Nov 2024 05:55:53 -0800 (PST)
Received: from [192.168.10.3] ([151.49.84.243])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-433b45fa706sm20639425e9.16.2024.11.20.05.55.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 05:55:52 -0800 (PST)
Message-ID: <86811253-a310-4474-8d0a-dad453630a2d@redhat.com>
Date: Wed, 20 Nov 2024 14:55:50 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] KVM: ioctl for populating guest_memfd
To: Nikita Kalyazin <kalyazin@amazon.com>, corbet@lwn.net,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jthoughton@google.com, brijesh.singh@amd.com, michael.roth@amd.com,
 graf@amazon.de, jgowans@amazon.com, roypat@amazon.co.uk, derekmn@amazon.com,
 nsaenz@amazon.es, xmarcalx@amazon.com
References: <20241024095429.54052-1-kalyazin@amazon.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241024095429.54052-1-kalyazin@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 11:54, Nikita Kalyazin wrote:
> Firecracker currently allows to populate guest memory from a separate
> process via UserfaultFD [1].  This helps keep the VMM codebase and
> functionality concise and generic, while offloading the logic of
> obtaining guest memory to another process.  UserfaultFD is currently not
> supported for guest_memfd, because it binds to a VMA, while guest_memfd
> does not need to (or cannot) be necessarily mapped to userspace,
> especially for private memory.  [2] proposes an alternative to
> UserfaultFD for intercepting stage-2 faults, while this series
> conceptually compliments it with the ability to populate guest memory
> backed by guest_memfd for `KVM_X86_SW_PROTECTED_VM` VMs.
> 
> Patches 1-3 add a new ioctl, `KVM_GUEST_MEMFD_POPULATE`, that uses a
> vendor-agnostic implementation of `post_populate` callback.
> 
> Patch 4 allows to call the ioctl from a separate (non-VMM) process.  It
> has been prohibited by [3], but I have not been able to locate the exact
> justification for the requirement.

The justification is that the "struct kvm" has a long-lived tie to a 
host process's address space.

Invoking ioctls like KVM_SET_USER_MEMORY_REGION and KVM_RUN from 
different processes would make things very messy, because it is not 
clear which mm you are working with: the MMU notifier is registered for 
kvm->mm, but some functions such as get_user_pages do not take an mm for 
example and always operate on current->mm.

In your case, it should be enough to add a ioctl on the guestmemfd 
instead?  But the real question is, what are you using 
KVM_X86_SW_PROTECTED_VM for?

Paolo

> Questions:
>   - Does exposing a generic population interface via ioctl look
>     sensible in this form?
>   - Is there a path where "only VMM can call KVM API" requirement is
>     relaxed? If not, what is the recommended efficient alternative for
>     populating guest memory from outside the VMM?
> 
> [1]: https://github.com/firecracker-microvm/firecracker/blob/main/docs/snapshotting/handling-page-faults-on-snapshot-resume.md
> [2]: https://lore.kernel.org/kvm/CADrL8HUHRMwUPhr7jLLBgD9YLFAnVHc=N-C=8er-x6GUtV97pQ@mail.gmail.com/T/
> [3]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6d4e4c4fca5be806b888d606894d914847e82d78
> 
> Nikita
> 
> Nikita Kalyazin (4):
>    KVM: guest_memfd: add generic post_populate callback
>    KVM: add KVM_GUEST_MEMFD_POPULATE ioctl for guest_memfd
>    KVM: allow KVM_GUEST_MEMFD_POPULATE in another mm
>    KVM: document KVM_GUEST_MEMFD_POPULATE ioctl
> 
>   Documentation/virt/kvm/api.rst | 23 +++++++++++++++++++++++
>   include/linux/kvm_host.h       |  3 +++
>   include/uapi/linux/kvm.h       |  9 +++++++++
>   virt/kvm/guest_memfd.c         | 28 ++++++++++++++++++++++++++++
>   virt/kvm/kvm_main.c            | 19 ++++++++++++++++++-
>   5 files changed, 81 insertions(+), 1 deletion(-)
> 
> 
> base-commit: c8d430db8eec7d4fd13a6bea27b7086a54eda6da


