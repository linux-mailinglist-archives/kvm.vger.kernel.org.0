Return-Path: <kvm+bounces-4590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F068814FEA
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 19:54:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62FFB287379
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 18:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF4D3FE43;
	Fri, 15 Dec 2023 18:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4YbdG9u3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1603EA6C
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 18:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-33644eeb305so734456f8f.1
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 10:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702666473; x=1703271273; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w0yhlLnli9k0VI7KUFKv0npC9sSJh/Clv7rMd6ohVtI=;
        b=4YbdG9u3epMfTOFMVMhwXMt0FoVjLUFa9bCv4+lm6wnldAGQiHQtDxmPZID9A8qmAd
         tQsSV6wpSJEnwg03riJLXi6MAANjvzdRjtrjIifZQKITJfqASbQs/5MCfZfm3lpn44K9
         uhS6fnkd0uHiKmd2ut6tLLFEjmYbZKbn7a1Cv9jpxyQp8cWBoJOdZvpRxnXAzXS6vxN1
         MB2OY5pRmFsPrtnPB5XkX5Owb8v0O7UtfZYc+FQ6vsDhTQNiaMWhaexfdqoubGpN8Z+b
         +Nvs3VD4xHexH+8pa52xNwywcRH2QsBrenqfddh7151JMcLIE2TeI/TK1L5Q7mC1m+2h
         EFGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702666473; x=1703271273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w0yhlLnli9k0VI7KUFKv0npC9sSJh/Clv7rMd6ohVtI=;
        b=VTmH3QAxtx3grIebCpy2rIVU6wAp/FzsGLemkCJkSlB0x5KNGPb44PuDY7bNctXw9h
         IZtxAUxy7zQbA/ZhAudFrqGzj2mYHP7sXamPt3TCUIJKO4hn3eiihAt0HDF4YRDuX35t
         aO+SQ5yYs2g2KeKWK6RFONjczlLFvj/UMKMHIHFafHvxJO5NifDcosi+Qgf2IrzZxfvX
         d0rppxIassXWYxfpnP+Zi+Mp//u1j4yQYMNqoBZtR0/49ekK5MQd52aJbhWA4qPVuwp4
         AN5Vu41bqeJ1GE8SU01SdrXHGVs6wRuzSy0QjWCdO9DSs3frB3QXpHijlb6gg5WIQrPh
         3DjA==
X-Gm-Message-State: AOJu0YyXLf6tZLgSutUv+b0RRc1tMlHCS3edATPZkutXOrBKhDQrVyBU
	VycwRPW/0QYelH1e4l4eVHkA51hQw9FemEeugHJltg==
X-Google-Smtp-Source: AGHT+IE34lQoNeNuvNXj90juk5IJps9k2aIPV/11nY+vSDykIRdGV6J/LHeJFvNMvCa4uco/LdEhELqecQbu4jjOX+U=
X-Received: by 2002:adf:ce06:0:b0:336:446d:7cc8 with SMTP id
 p6-20020adfce06000000b00336446d7cc8mr2132480wrn.132.1702666473386; Fri, 15
 Dec 2023 10:54:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214001753.779022-1-seanjc@google.com>
In-Reply-To: <20231214001753.779022-1-seanjc@google.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 15 Dec 2023 10:54:04 -0800
Message-ID: <CALzav=eFSoW4fWC4uKh3bm--ekzDriA4=jjq6kA5j+Mp=7n_wA@mail.gmail.com>
Subject: Re: [ANNOUNCE / RFC] PUCK Future Topics
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, James Houghton <jthoughton@google.com>, 
	Peter Xu <peterx@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Isaku Yamahata <isaku.yamahata@linux.intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Marc Zyngier <maz@kernel.org>, 
	Michael Roth <michael.roth@amd.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023 at 4:18=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> 2024.01.03 - Post-copy for guest_memfd()
>     Needs: David M, Paolo, Peter Xu, James, Oliver, Aaron

This works for me. And in case we need to reschedule I can also do any
of the other Wednesdays in January.

Thanks Sean!

