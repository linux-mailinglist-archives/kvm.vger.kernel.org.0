Return-Path: <kvm+bounces-54001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16454B1B4E7
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5A36189C936
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6422C274B50;
	Tue,  5 Aug 2025 13:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZU9mKNe/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF7D22A4E1
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 13:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754400560; cv=none; b=sg8ge+spMNmDCSeGQol4qMRI4wt0SrxsXo4vGAqTBLkUYVZm/g96fXaBxXCVmqTpaPkycnlP9nN410jmWC/4zu1dMXS1xxEWKaaLk47OJ3ykpg8H8lkBP2gheXftroqz1rrQZn7udmYZXpN7c7qaegyCzA+u00xO0Y3WtcjW0Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754400560; c=relaxed/simple;
	bh=gJ9cXvAsqM/enVc1aXO5W+6MUHAIrb338LYuERqrbWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=itSg+mxVEiB1SxvUrMNsQtFOjXqem/TKpHhBmhGgVgSMiH06bG02BBAVJLxq9EeZVlGJW0zOCdEuqbN/OcHxwt07PwpoGN8aINliUkFNjBTr3qSnTaJ63zUVUDXhwl7x0D14qt5tv0r8+74ABwJykFohj+wPx2B0ElUsOfM+olU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZU9mKNe/; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-615398dc162so9796246a12.3
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1754400556; x=1755005356; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+ipjdbz9dkXcEYaCNiHZ/32p0xoqI5N0UZ1qphfpkvU=;
        b=ZU9mKNe/JNRaV6FV+wtuPnuQ7wvLwIj8ijZkgubfAzwd18n9IQehg8ZmUmUQ1567m3
         MJ6iBd2MzEuWUXdskLESSE/piPuwDcvCboVEn+f3WbJZPnbnPOTFD7mOuuKUbVTME+wB
         nxx4im6if3gIigVYNFxEtHT/dd3hATz5w43FU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754400556; x=1755005356;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ipjdbz9dkXcEYaCNiHZ/32p0xoqI5N0UZ1qphfpkvU=;
        b=bGMIRH3ITL92ZfnlW6hSWsD7Km46cOhC9l+OJFJ7VMtEn7kvlcqRvgi7bzZIFlXFaB
         uWyusxihBbRsAl4277k8urbLAXH63TovTRabKnzU18medlk4A65t8dcJF322j7qJLj/Y
         oEX4xyTr+aM5OuKcP8GiNWbcKnNikOLCU4i3hjaI0FQkEe+SpbJf+hdr74Mb823mj1TZ
         ZSEbd85fceo0qeqU6P6x3LCU7pa5KrquY8WinNfN7xvFKA5C0IkncxRddzXoGT7v7VNI
         ND6arjbKWJxt+L/Z6ghv5kuhOpKLOldoo0Pyx5hAYtZmFOtBpJSQueZne91QSN1OVmmY
         r9Fw==
X-Forwarded-Encrypted: i=1; AJvYcCUs2FFmFSaGCrpP8ompmWi+wykipv49SYwZjsQ/KrcTqvsDi48CWYQbKjWHvajcwxeI0jg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxE6FW2mTL+6wZJVsRTnnrcwGIxl90ISAAXKKQDoZ7fcuIy6sRW
	QJw5vAt1yB9kvxv1OqMLW1hnm0Y4ZTcDlhf2LiuWr++A9mtMznrJOvmXa5oXMchizWZkfvpoQqM
	swHg9RYqLfg==
X-Gm-Gg: ASbGncvGenyUGdOwaNQgXXrpjlBCbW4cHWUd4FjNN6LILcmUDwZ0FvurUjOnkdmfCt4
	m2YFg29A5yRiwCjf05lIaq2smz9uCg6BgDt6S4sxkEru3bwmRVQqPRxytA3pwukXHs0AkBY4t/i
	YCHHU7ZFqU8sZpjra4DkZa/46xUvRGI1OEzfdgurLzZtfX8mxs3JKDmSymDjaSOoMcLebbK2LKs
	ZU5lzpvSdBWpNm5u3hWKb3W2CVDPeahJj/SXMJzIVdP/hTpqwG1BfraBseukSO2gwdY0eoT23Mo
	MbZLlaFSDfHlnel/FuFuWN3wGJdRWege7jbLECv1M+MDtEwioNuX/8RXc4OFqEGq7Pc7YEvxYT1
	hQdQOfQjpyH38MVr2rdjhtpEB05oP2nT4rFs/oyNldHnLJB7kdYTgaaPd/rq0LiF8RmOIQWkbvf
	sIJn2yRRQ=
X-Google-Smtp-Source: AGHT+IGysgzP6scphYZ/qV1+OtVc9rKbzDHWXFP1E93z88LknbfDD0OqxjLGAV6pXTsabwr154vzSQ==
X-Received: by 2002:a05:6402:5210:b0:615:4ce4:3228 with SMTP id 4fb4d7f45d1cf-615e6eb68b7mr12832925a12.4.1754400556193;
        Tue, 05 Aug 2025 06:29:16 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8f2c265sm8380030a12.26.2025.08.05.06.29.15
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 06:29:15 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6157ed5dc51so9756306a12.1
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:29:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCULpXPTKU8jPrqPfoqZc0xKNjAfMRpQA97BOc/Ta7BQcIokORl3/P/2T1ETPpsTyYEbudA=@vger.kernel.org
X-Received: by 2002:a05:6402:40d4:b0:615:aa8e:a19c with SMTP id
 4fb4d7f45d1cf-615e7172bffmr11870059a12.32.1754400555257; Tue, 05 Aug 2025
 06:29:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com> <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com> <7f891077-39a2-4c0a-87ec-8ef1a244f7ad@redhat.com>
In-Reply-To: <7f891077-39a2-4c0a-87ec-8ef1a244f7ad@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Aug 2025 16:28:58 +0300
X-Gmail-Original-Message-ID: <CAHk-=wgX3VMxQM7ohrPX5sHnxM2S9R1_C5PWNBAHYCb0H0CW8w@mail.gmail.com>
X-Gm-Features: Ac12FXy4pouEpOs-tuosaE-SL0UAQrdOn097LdBH-sum6lMT-SjAL3WAjOmxvbk
Message-ID: <CAHk-=wgX3VMxQM7ohrPX5sHnxM2S9R1_C5PWNBAHYCb0H0CW8w@mail.gmail.com>
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: David Hildenbrand <david@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"lizhe.67@bytedance.com" <lizhe.67@bytedance.com>, Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 Aug 2025 at 16:20, David Hildenbrand <david@redhat.com> wrote:
>
> I think that would work, and we could limit the section check to the
> problematic case only (sparsemem without VMEMMAP).

We really don't need to, because unlike the nth_page() thing, the
compiler can see the logic and see "it's always zero".

And in the complex case (ie actual sparsemem without VMEMMAP), the
page_section() test is at least trivial, unlike the whole "turn it
into a pfn and back".

Because that "turn it into a pfn and back" is actually a really quite
complicated operation (and the compiler won't be able to optimize that
one much, so I'm pretty sure it generates horrific code).

I wish we didn't have nth_page() at all. I really don't think it's a
valid operation. It's been around forever, but I think it was broken
as introduced, exactly because I don't think you can validly even have
allocations that cross section boundaries.

So the only possible reason for nth_page() is that you tried to
combine two such allocations into one, and you simply shouldn't do
that in the first place. The VM layer can't free them as one
allocation anyway, so the only possible use-case is for some broken
"let's optimize this IO into one bigger chunk".

So people should actively get rid of that, not add to the brokenness.

           Linus

