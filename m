Return-Path: <kvm+bounces-11985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4F9C87EA9D
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 15:11:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60C3E28127F
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 14:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2931A4AEF1;
	Mon, 18 Mar 2024 14:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yOOmWtpW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C831B4A9BF
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 14:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710771100; cv=none; b=grmxGZVfDCTWddiHz1+xuWZQPsWq8W0kPoiX1vUAo/CcLFXTNibH56v+J/564B3TqAXo1I3/ComE2Ihi2LPcPWXSTfmphdptDdGc0O2Syl9vVZUHIjeMFPWNVzfM1umLA7IakEWcUBib6FjIo+NcBPd71SVZ7i5q7EBix+cyat4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710771100; c=relaxed/simple;
	bh=oym0AIJ+THr0KYNh2rLzj1Zqh/rdOPJlqoAFEVOa+1o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HiqUT8q+pyLzgXTxmSlQOTPhl/kkW+jJuqLe7Wr6FW8/BykPX8PF7LXeHOxCgQ+OCpQIvuS2UvWvK65XeyuUK+TOWCjJ53Hvay14hywdvtR+zJ6ah0a3As+3E9kQd0fsWz0s5gX2ctcWaNHktzbS+Dblm5N5JCTUUr2D46mnK9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yOOmWtpW; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-428405a0205so484341cf.1
        for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 07:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710771098; x=1711375898; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rU3zFykgVuweueIsoxzQMtKYDDN5Bjw0bqJ5bY+qA6E=;
        b=yOOmWtpWe9n6VfZafafmOnCGllfWqkA803NM5M/9GjM1clkFyoFk3AaRpXLJfWSDH2
         6QiVF7X2aK8mHO4A3MxDmdUtmHToqiQONHfWaJBczngOssXdSeeKPQsJFgUWVzt6NpXw
         keoOStOKhHdGC+jVjRT5QgZYB+W07hFaer55981F97Iubw1InR5qsDfmMTe089HVX6cG
         Uij7WYw2Xeul0akqpQTUagmRsjCGLItqqVm/LoYOjpkd5MVC1dMLwMN5tqDSM+TEBafj
         3570u0dlcoCud+2ytvrvaoFTbS+r9QCOAFj5GdMR0PYo0Y3zMNK3Q2rKPhypTR3SXAxc
         zycg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710771098; x=1711375898;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rU3zFykgVuweueIsoxzQMtKYDDN5Bjw0bqJ5bY+qA6E=;
        b=JLNNzZthPXytuL7ISYZ3jaKb8OtpC77/PDQTHn1RIKHtjLwy0TsixzfEU3hp4vPRKI
         vKf+kXYN8qdGL12peVcd+ql1k/E7HfKLr5beMM6Prn7fbHi063h2yzHXUdN8PjhNGdDA
         /ZZnyLuIY5dRYUEFiPi/gyCspPVzLj1e91j+Xv/ZivkwL56D/HasA7SJAap9tTacQizq
         VJmv57to12hyNUSie655u0wV5czywrGmRZJUopA7yoYK2FEUVmR3E+AeTgI3/+Lp+W8L
         UfrGa1UGgcL+VRe+MpJQ/k44aUkeqSPbU6ELeL7Iaa1Raysn28ZwkKwn7OiQ95KcNble
         rT7w==
X-Forwarded-Encrypted: i=1; AJvYcCV+tuiqBvVbvZgap6q8waF712ogiJENUTpSr35hw5KqWilE2CGFYWPi+2XfwqkU5ASarNAXlYpw6mBYNBP/ygie842o
X-Gm-Message-State: AOJu0YyH/XzoKZLQXMglItgcJkOPL+JKVtfl8Zl0j7G0uSN684IHqWwp
	YvvQCxXpQAhkioZv5h6YqmleuiX++66oL2kZZNAe/0z15gfii3XugO65KK2ipbLrSp1JRfSahXq
	FrdBNSAnr//uKit7qmG5bOBZsk301zmbl4xHj
X-Google-Smtp-Source: AGHT+IEP1eDBtV9wwG22o9FLtfUkcC57ZS5hhvLcQHaosamz9mFsDACdCEemZgZ1KW9i0+WwUAZxZDxm/IPXpyAyIxs=
X-Received: by 2002:ac8:57cd:0:b0:430:9ee1:a8 with SMTP id w13-20020ac857cd000000b004309ee100a8mr330194qta.3.1710771097539;
 Mon, 18 Mar 2024 07:11:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
 <CA+i-1C34VT5oFQL7en1n+MdRrO7AXaAMdNVvjFPxOaTDGXu9Dw@mail.gmail.com>
 <CALzav=fO2hpaErSRHGCJCKTrJKD7b9F5oEg7Ljhb0u1gB=VKwg@mail.gmail.com> <8e3c2b45-356d-4ca9-bebc-012505235142@amazon.com>
In-Reply-To: <8e3c2b45-356d-4ca9-bebc-012505235142@amazon.com>
From: Brendan Jackman <jackmanb@google.com>
Date: Mon, 18 Mar 2024 15:11:25 +0100
Message-ID: <CA+i-1C3DtXzzkatepVvn-E45Gyxb3YmYd-irxfjDL5bL5MhWVA@mail.gmail.com>
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
To: "Manwaring, Derek" <derekmn@amazon.com>
Cc: David Matlack <dmatlack@google.com>, "Gowans, James" <jgowans@amazon.com>, 
	"seanjc@google.com" <seanjc@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"Roy, Patrick" <roypat@amazon.co.uk>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Woodhouse, David" <dwmw@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "lstoakes@gmail.com" <lstoakes@gmail.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"mst@redhat.com" <mst@redhat.com>, "somlo@cmu.edu" <somlo@cmu.edu>, "Graf (AWS), Alexander" <graf@amazon.de>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, kvmarm@lists.linux.dev, tabba@google.com, 
	qperret@google.com, jason.cj.chen@intel.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 8 Mar 2024 at 18:36, David Matlack <dmatlack@google.com> wrote:
> I'm not sure if ASI provides a solution to the problem James is trying
> to solve. ASI creates a separate "restricted" address spaces where, yes,
> guest memory can be not mapped. But any access to guest memory is
>  still allowed. An access will trigger a page fault, the kernel will
> switch to the "full" kernel address space (flushing hardware buffers
> along the way to prevent speculation), and then proceed. i.e. ASI
> doesn't not prevent accessing guest memory through the
> direct map, it just prevents speculation of guest memory through the
> direct map.

Yes, there's also a sense in which ASI is a "smaller hammer" in that
it _only_ protects against hardware-bug exploits.

>  it just prevents speculation of guest memory through the
> direct map.

(Although, this is not _all_ it does, because when returning to the
restricted address space, i.e. right before VM Enter, we have an
opportunity to flush _data buffers_ too. So ASI also mitigates
Meltdown-style attacks, e.g. L1TF, where the speculation-related stuff
all happens on the attacker side)

On Sat, 9 Mar 2024 at 03:46, Manwaring, Derek <derekmn@amazon.com> wrote:
> Brendan,
> I will look into the general ASI approach, thank you. Did you consider
> memfd_secret or a guest_memfd-based approach for Userspace-ASI?

I might be misunderstanding you here: I guess you mean using
memfd_secret as a way for userspace to communicate about which parts
of userspace memory are "secret"?

If I didn't misunderstand: we have not looked into this so far because
we actually just consider _all_ userspace/guest memory to be "secret"
from the perspective of other processes/guests.

> Based on
> Sean's earlier reply to James it sounds like the vision of guest_memfd
> aligns with ASI's goals.

But yes, the more general point seems to make sense, I think I need to
research this topic some more, thanks!

