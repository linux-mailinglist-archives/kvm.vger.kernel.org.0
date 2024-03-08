Return-Path: <kvm+bounces-11373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38F65876851
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 17:25:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E81F4282C72
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 16:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B632D792;
	Fri,  8 Mar 2024 16:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QaprVCT2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6CA2C69B
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 16:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709915137; cv=none; b=JdyAxYgL6XtViqj2J6TjtqZasvK4FjtiHED/8sCkFqGdlu5qVX9r14nM+NFVdbzzIva6iGUe5k7nx8APUc6WuAo5oYyFJBfeLKOxRzeLrIjzRwARiIqCvTGvNGoVg3vIwOYgbUJJCsARXNFlWzhBAt2+AdSgrY93at/mxUywvMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709915137; c=relaxed/simple;
	bh=bNKllj7mYvx/xxkLemA0fJHMcGlcVpU323BzoEH+uFQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=POW7jjfUBWpJniPqdcUI1Z8w/mcoCxCih0kGzrZNvjveuwi/Sco+F/F1SdvYriBXW4UR6H1YxKAq+4MTrb/AlEyQ9+/lGP/tQmhyuL66IMw+9gqVAQ5+fFOAntv2MbjQN5mb1uF51gL6h3NpuTF73lc9EY3AcPGGciZSxkQ8DGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QaprVCT2; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-428405a0205so326981cf.1
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 08:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709915135; x=1710519935; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bNKllj7mYvx/xxkLemA0fJHMcGlcVpU323BzoEH+uFQ=;
        b=QaprVCT2UElK8J4sHfH1JZZtTRDWHLqkvsJh1EQwYcm0qKqQvugNLSobTmudF01clB
         /vGOXZ/wPanlPTxxI993ZGEOUWIMxUzrlRgMmkxqu9VHGI11lUq3czW96WEsa2o/CmxN
         5HnMbotGLMCtjIizx8T7q5zxlq3FeCs58z2euSxxZEQZn1Mtw+L8zh1sRCqM1RoyDByq
         SI5Ge5ayimkIljdfFnR+l3UfWnrt0efXiDLOa12A1UW1RCPEAVb8qYp/HyAjchGj/3sU
         QscTNmIEdEd8x/x5W+PtjHmHsKecbFcX0jQmWPBrpyOJ9zCjN93CU/xzJrYsudFNvdck
         L9Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709915135; x=1710519935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bNKllj7mYvx/xxkLemA0fJHMcGlcVpU323BzoEH+uFQ=;
        b=wiTAY7AWsoExi5/EkBZkNH4VToWNFFdfpa1rjZnGv7BKctVB2PCNU8wgLHHb9J+duX
         H3L1nUHojgjS+LQwsodbDqo6GBMtn5+kGEDuEpdq7uMohwlcGQ0EOq8BOCvMeuc5jr7h
         8RKCqE8eMpaOJ0Ghowlcros6/RuL/bxZIjj5dZR2lhdn9CuHw+plwCAK0pDFuohqKJcm
         EINZriLgGZnWwqZ2AYVwmynuwznz39lCbN2yl+w8zcvGNaJmDlvLqFZIid/V3muq65//
         U7FKLLZLI7ksZVLr6Fg4Gn8p4ulpTAqZKroUnRYUIZWYgxozpWsy7SY7910zUjrWRVx7
         t6pQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKABcp9WfMtibO3iYdpi0F7wMJTo0ET4CejWOUZnYFLuwk7OxnuJdpC8MguL5pqThMxlnrBouuILxYnCfJSjUeYQkx
X-Gm-Message-State: AOJu0YyzF6KpXrJOLkY7aI1Anikzj7VzO6EEXvNzeVX268YqakK/v+r8
	1URGMT/p4BEzMNaarjlLm0M7V8AX4tgFRKORfHH437p/0wbVAeYsJqyxcyd2ly1ubNOLM6iexLZ
	5H69mMf3aLQutm8uVEZTLK1unn1nob4Sg1muK
X-Google-Smtp-Source: AGHT+IElQ3xjmycZ+6ORMpUoTkFmduy8rLaNpVKLnGA7x+Z+sC1aXJ1BEUZ5RKJmqqEgd0tD5BJWRtLMqwd9EMqbzds=
X-Received: by 2002:ac8:7d41:0:b0:42f:a3c:2d53 with SMTP id
 h1-20020ac87d41000000b0042f0a3c2d53mr675497qtb.20.1709915134720; Fri, 08 Mar
 2024 08:25:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <AQHacXBJeX10YUH0O0SiQBg1zQLaEw==> <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
In-Reply-To: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
From: Brendan Jackman <jackmanb@google.com>
Date: Fri, 8 Mar 2024 17:25:21 +0100
Message-ID: <CA+i-1C34VT5oFQL7en1n+MdRrO7AXaAMdNVvjFPxOaTDGXu9Dw@mail.gmail.com>
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
To: "Gowans, James" <jgowans@amazon.com>
Cc: "seanjc@google.com" <seanjc@google.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "Roy, Patrick" <roypat@amazon.co.uk>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "Manwaring, Derek" <derekmn@amazon.com>, 
	"rppt@kernel.org" <rppt@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"Woodhouse, David" <dwmw@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"lstoakes@gmail.com" <lstoakes@gmail.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"mst@redhat.com" <mst@redhat.com>, "somlo@cmu.edu" <somlo@cmu.edu>, "Graf (AWS), Alexander" <graf@amazon.de>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi James

On Fri, 8 Mar 2024 at 16:50, Gowans, James <jgowans@amazon.com> wrote:
> Our goal is to more completely address the class of issues whose leak
> origin is categorized as "Mapped memory" [1].

Did you forget a link below? I'm interested in hearing about that
categorisation.

> ... what=E2=80=99s the best way to solve getting guest RAM out of
> the direct map?

It's perhaps a bigger hammer than you are looking for, but the
solution we're working on at Google is "Address Space Isolation" (ASI)
- the latest posting about that is [2].

The sense in which it's a bigger hammer is that it doesn't only
support removing guest memory from the direct map, but rather
arbitrary data from arbitrary kernel mappings.

[2] https://lore.kernel.org/linux-mm/CA+i-1C169s8pyqZDx+iSnFmftmGfssdQA29+p=
Ym-gqySAYWgpg@mail.gmail.com/

