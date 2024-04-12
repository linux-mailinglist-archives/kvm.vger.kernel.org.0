Return-Path: <kvm+bounces-14546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C57528A336A
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 18:14:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 767BC281DB2
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48AE01494B3;
	Fri, 12 Apr 2024 16:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mio0CgLE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A375491F
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 16:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712938479; cv=none; b=M7Dhqz46pn0w73orpKs5cY/LkRtsWjcvgDhEX6JxAxvH76WGMzTm0azlnNQWdHQSJhcqnE2M0eSd08sR6zbKNKPnerQufwNVoaiVKyIdnGZYnw34wyQPqI9xCuqrRRY0Ot3yAFW9+6SlBpMX3LrafSs4+JoKF7hkPqtzf4raRjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712938479; c=relaxed/simple;
	bh=PCRufziofEZiX/6YEwS7oUJq9oS6b+/uOnyRCJn2M6o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z95lBeuoiOgsfld3tqKcNWXt1jeZ4aocjGiOoP3GvEekOeYARo5+Qg9RBLfUS891Ji3Or+vuDnmw6+fDe/awAS1oYxLrblpMonrvhR31ahp2O86LNDkb/i7v3Nj3MPtAK3XOCbkBJ/eB1sGxuQWG5zdkH+an1rgoP1rE9D0N0G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mio0CgLE; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-41819c27ea3so156585e9.0
        for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 09:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712938476; x=1713543276; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tpJCwPMBn6s4XI6wReA+2FDyhPO+4Y0Z8a5zt7g/d+8=;
        b=Mio0CgLEp/4cRx/ujQRUhRip+fJsDiIAKioohyF7hqgUauQFeQwOsWd7aPGyNRKVJg
         VAvXXwdMDa1K3/qoZOD7kdBaWSL/Iicne9E21aVBfev6JeJasd9Oalp3m0Lg7P/JvDQ0
         bdMqskm6xL55ZjyxwFWHYX6w0gKpR/79CEV09sn2W4mXnz+imVzR8vLOGdo3FK7SvvLI
         2F6jjGSVyYizR30ptO0uVkkxThDarx9dcG+qtjm907q6tTUxBCNJrdlbQmxrUL5RKCe0
         Ppp46ZiUH2Fq8PF8khLyXdV5kkAArrcgcUav6Ytm8wMAnwMP670A7i8A2K2sMKqCR8Yt
         0xbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712938476; x=1713543276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tpJCwPMBn6s4XI6wReA+2FDyhPO+4Y0Z8a5zt7g/d+8=;
        b=wCH7JeTgDDAgGn3/5mtZieppDCfo7IZ7LMUkjt90qBdkRqN48exrm5ZeLRO3gcjX9o
         oUEuJAz3Rs8nlolyrqqFMnlz/jlBp07bukEy2RyQvSWz2/5it+xHeiMP6srA7/bZlH0A
         Kqb3ff7Up9OZYMhMPYXHHlh9UZ+Vx/TJyo1ZC6ffOEVWh2fhg8zxJCylYL3mwYBIQGer
         RKteTzykRKE41yoTp2zISsYbMljv1xfDO6ezylGvLwdqtoagO7dDfYTqet9bN+Q6z9l+
         jR1NjL18ekAeMCOKBDOlmAgTgrI1TNhwi5MdvLp5GiJyWZcnR10Zxn8fPqgenpReIIRb
         jS8A==
X-Forwarded-Encrypted: i=1; AJvYcCVCPXZV4bo1DnZdJZDd4OAtg5Um5zZsSLObc/7pOy2z08WE/QxMtq/uki42WxMQv9b6DW2IgZ2QsxJ3IKiqezl3HFBG
X-Gm-Message-State: AOJu0YwuFB8TQfzOGAur3SHi+Z+uZrAfotxoSbxRWs7zGCMFmHNln417
	OhS5AQxG3NrWyLupYjh86Gmk8DUKOEZHxnTGWQvJNY6X1+HdcbQZlkSXguIqbfEYFFMibQ5yz9P
	jOfgzfVJ0Zx1DG/jesMGkge13iNsUuiEU9CyK
X-Google-Smtp-Source: AGHT+IHyTV0LRMV/2hHrQO2jlky1MKJbNlEM+EAY0lryP0/ucA7spHJer2a9zMcbJssw/ruzmOSLjQLqcZtt3AGko+s=
X-Received: by 2002:a05:600c:1907:b0:414:767e:6e76 with SMTP id
 j7-20020a05600c190700b00414767e6e76mr2282644wmq.21.1712938476309; Fri, 12 Apr
 2024 09:14:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240402213656.3068504-1-dmatlack@google.com> <cb793d79-f476-3134-23b7-dc43801b133e@loongson.cn>
 <CALzav=c_qP2kLVS6R4VQRyS6aMvj0381WKCE=5JpqRUrdEYPyg@mail.gmail.com>
 <Zg7fAr7uYMiw_pc3@google.com> <CALzav=cF+tq-snKbdP76FpodUdd7Fhu9Pf3jTK5c5=vb-MY9cQ@mail.gmail.com>
 <Zg7utCRWGDvxdQ6a@google.com>
In-Reply-To: <Zg7utCRWGDvxdQ6a@google.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 12 Apr 2024 09:14:09 -0700
Message-ID: <CALzav=coESqsXnLbX2emiO_P12WrPZh9WutxF6JWWqwX-6RFDg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG
To: Sean Christopherson <seanjc@google.com>
Cc: maobibo <maobibo@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 4, 2024 at 11:17=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Apr 04, 2024, David Matlack wrote:
> > > I don't love the idea of adding more arch specific MMU behavior (goin=
g the wrong
> > > direction), but it doesn't seem like an unreasonable approach in this=
 case.
> >
> > I wonder if this is being overly cautious.
>
> Probably.  "Lazy" is another word for it ;-)
>
> > I would expect only more benefit on architectures that more aggressivel=
y take
> > the mmu_lock on vCPU threads during faults. The more lock acquisition o=
n vCPU
> > threads, the more this patch will help reduce vCPU starvation during
> > CLEAR_DIRTY_LOG.
> >
> > Hm, perhaps testing with ept=3DN (which will use the write-lock for eve=
n
> > dirty logging faults) would be a way to increase confidence in the
> > effect on other architectures?
>
> Turning off the TDP MMU would be more representative, just manually disab=
le the
> fast-path, e.g.

Good idea. I'm actually throwing in some writable module parameters
too to make it easy to toggle between configurations.

I'll report back when I have some data.

