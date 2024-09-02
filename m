Return-Path: <kvm+bounces-25666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16C4F9683EC
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 12:00:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B47641F21273
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 10:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE61A13B586;
	Mon,  2 Sep 2024 10:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aO21rqgP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972842C6AF
	for <kvm@vger.kernel.org>; Mon,  2 Sep 2024 10:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725271251; cv=none; b=kZLQOTm43ZNGkrADpeAL7NGlgxtQFM9ZjWzDnt2ogK24n2V2gbBYF2CDkslp8j5rj0XLoYX1dfL1j+QGC59WeOuJ6OpSubNlt7hBpFlIbSCVTqLTIc25OC0N4CDuPUk0x4wp6vqJ0VfBF0jK096KheMAs/P7EYeoQQcueae/6Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725271251; c=relaxed/simple;
	bh=LBIzi1LpQ/rTjLpmqqbTh+L8ZKr4rAACHWK5C8SLLBI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WCAEWQVNuLNdAl2Mo5nH4t9I5ZtgtLTVsZIlEiWFdwODmqAg4LSUbfwEuAA1WU9ntktVM2GA4rw6lKu2pMWOoBKTbrcbHvRxUkLqlAHHiTfZ2/K8/aFe9hLLexaieoDo6/N+vO0Jny7xjv1o6aiLInFSXSm/v7fzw2t+KSgW8A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aO21rqgP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725271248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zwCtVYjTsC/+5qLh9aBp3HoHm+8Qd+MXKxdiS5FMHAw=;
	b=aO21rqgPtgD4NZv3G0JQndMpWc7jpBFRboAQLGGtYLmA3PEZPKuc8bfJpR3JJZM5vfDpbQ
	MTAy3JhvbFwh8zJBuZghUSK+889fM46MlmM1wihxdQKuVL8RSGq4yPUSHM5CN4kpJILNhj
	DZCiDJ4RNHX05t+IC6My6u/NTrkVSkQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-DVaexTw8NHqHtKmhjUf4Og-1; Mon, 02 Sep 2024 06:00:47 -0400
X-MC-Unique: DVaexTw8NHqHtKmhjUf4Og-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42bafca2438so46212125e9.3
        for <kvm@vger.kernel.org>; Mon, 02 Sep 2024 03:00:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725271246; x=1725876046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zwCtVYjTsC/+5qLh9aBp3HoHm+8Qd+MXKxdiS5FMHAw=;
        b=IN17l6EIKtykDjnbi1+8JnGRaIfdELXOxuvhyhVsK3830TV26UnHLwNJJdr8meaGL2
         FiWetoSYSHmBTsHmKqjAsVXkXNZFYx0gsfDFRXa0VI8RDsDJO85WsiZv7IiVp4DnC/Ui
         Pu/gMoQiWfRRXPKZNyq3C3z6f821l07/So0YEsbcbr/VgQ3PTjW5/jNfsfVWEkD4R2KL
         YbM4nAyy+vnhHGWyvmPBZCdCFmVz1tgQsezAmgcqodWGBwL7osY1jR05miqsE0ebIQMP
         CIJK2Qnrh8bObG6lLhUO+ERSaoGsLxbQ9TQtrHY/5KAG4tvqgGgkL4/XpaJmF143mHAH
         +MMQ==
X-Gm-Message-State: AOJu0YxKaB8amU277Oa6IFcDMupUSlv8qCeMQRO/vaoeB4MGldriGkir
	U0Y3VTOhKoq3xwJ4gL5T5EfV5D8y3YQR6KLu3yj/Fs29mVeEP+t1zXQnjD9BEbx/iAU4oWiJ754
	N/u0QyuZr1eZ5XciVZTnSh0wKQipHK0+uVX8rv7/8IxFPVoR029FSLBb/pSV3Rxo0Qfi32rrOkQ
	OaIT03Z2u8N/UKIFc0v3CdjDGk
X-Received: by 2002:a05:600c:474c:b0:429:c674:d9de with SMTP id 5b1f17b1804b1-42bb01ad776mr118711085e9.2.1725271246046;
        Mon, 02 Sep 2024 03:00:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOuviAeUInZpYXRD0meSDjikwC0zm0YoIdWxbYwWDChPxMnaeeJFb7+Xg7Qs/JQBeQAgsR71gAvgnbt2b40qQ=
X-Received: by 2002:a05:600c:474c:b0:429:c674:d9de with SMTP id
 5b1f17b1804b1-42bb01ad776mr118710895e9.2.1725271245574; Mon, 02 Sep 2024
 03:00:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240802195120.325560-1-seanjc@google.com> <172506359625.339073.2989659682393219819.b4-ty@google.com>
In-Reply-To: <172506359625.339073.2989659682393219819.b4-ty@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 2 Sep 2024 12:00:34 +0200
Message-ID: <CABgObfb390uz6c42PwjF=3Gss+H4MW1_Cs2r=V3cEG7xhYC9RQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM: x86: Fastpath cleanup, fix, and enhancement
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 31, 2024 at 2:21=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> Applied to kvm-x86 misc, I gave myself enough confidence the fastpath fix=
 is
> correct with a selftest update[*] (which I'll get applied next week).

Sorry for not reviewing this before vacation; done this belatedly and
patches 1/2 may require another thought (or a revert). Hopefully I'm
wrong.

Paolo


> [*] https://lore.kernel.org/all/20240830044448.130449-1-seanjc@google.com
>
> [1/5] KVM: x86: Re-enter guest if WRMSR(X2APIC_ICR) fastpath is successfu=
l
>       https://github.com/kvm-x86/linux/commit/0dd45f2cd8cc
> [2/5] KVM: x86: Dedup fastpath MSR post-handling logic
>       https://github.com/kvm-x86/linux/commit/ea60229af7fb
> [3/5] KVM: x86: Exit to userspace if fastpath triggers one on instruction=
 skip
>       https://github.com/kvm-x86/linux/commit/f7f39c50edb9
> [4/5] KVM: x86: Reorganize code in x86.c to co-locate vCPU blocking/runni=
ng helpers
>       https://github.com/kvm-x86/linux/commit/70cdd2385106
> [5/5] KVM: x86: Add fastpath handling of HLT VM-Exits
>       https://github.com/kvm-x86/linux/commit/1876dd69dfe8
>
> --
> https://github.com/kvm-x86/linux/tree/next
>


