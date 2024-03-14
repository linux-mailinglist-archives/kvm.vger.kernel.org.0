Return-Path: <kvm+bounces-11816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CBFD87C2F3
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 19:43:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1914E281E1B
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 18:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 077C5745C9;
	Thu, 14 Mar 2024 18:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yi+Akj9k"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EACA74C17
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 18:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710441815; cv=none; b=IkFwV5rWWpR473AC+lLsCqnPbwuB70L1uWWYZV3Vqabhi6FYc+2wVARwZ/1h9KVvkCdl41VWu8f38pGf6uLLk2SrLRM4GO83Dc9l/ldbjIOFwjsisb/NMn70qyzVQ22dgCMwKmIl0SLzmXacMZu9FjG8nSzITVg8lqd8FmjPnZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710441815; c=relaxed/simple;
	bh=xutuD0LuXBxACIRdNt3ihtagRBXo4ZIXDrd2H0Q/LQM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OdZy7JIujPDWvuMc+GOwWq4HWQAwNtT/1BOKRbsuYtBP+k+7CfqjieFEm9vjhXZQoI1AqshtqnFqns+pzq+3qPwaSm23+I73GZJjVr3u8//qiMZNGPdwGaasSTFhsk2o/46izra0EOe3YcbrPgFDwcYzK4URq/8msVRcjAl9S4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yi+Akj9k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710441812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=79OTvMl/2qzNCLG1xJnyizwsVJXyAUZTjESWoeWOxUM=;
	b=Yi+Akj9k9DwnX2T1frall/CRZKWG7/+5hcLEGDN+7/C8DEj/NDyeGUMj5qnIxJ1ZbDOp9y
	i/C6j9tGDOUkv1k9aHk+gj1vSFKwWqdk2Qq0o4wZZycw8yudADHW/MHrdKhFM5YDL2tWDc
	srmOtHLDzmklC65/FiZXfGkltQyr7hQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-250-o_Qd8NnfMAavGVYHQbgSoA-1; Thu, 14 Mar 2024 14:43:30 -0400
X-MC-Unique: o_Qd8NnfMAavGVYHQbgSoA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33ed0a8beb5so5818f8f.1
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 11:43:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710441809; x=1711046609;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=79OTvMl/2qzNCLG1xJnyizwsVJXyAUZTjESWoeWOxUM=;
        b=gRKCxJt3S9mpN2X1DzT16VcRqoV+lkac7knIxdfqtb0BnjhZO7KNOHmxEjO8XL1m47
         i3G6aW963obY7zzum8FVFXuUqfY5HvL6DSDD3mCVsbjdQc2Kza5KJEKty+JJTPOmJM2F
         47Z7xlXtQBvM2ypEhPTlorX8MKL7IjJOCSaOHvamZLwexxcaE5fYSRUmCHybvvLDwzK7
         homTELIkXCMA4cMys6f8BAqLGN+PMLv82ZsnLWAXejdDNpG3s5589Yfn4nL9ewPs63Xv
         Iz45N3lrORcoNWeUoG5KPS83abDbKbIDv6oJEWlARwMPOiwPmFtFjZdgK/e0qfvULslD
         +wCw==
X-Gm-Message-State: AOJu0Yy4cnzn2Ps6ApTQOMFJlzrF6TGyiHfyKn6a1ztGdP8qPc5mS584
	k6tbn/+jAwrSNL5OOirfB1MrmjpOKzdLzZZU77Dm52yuvcizc/Iu79zJoIyJ7eM8O5kA+gg6vL7
	FyEXG7S8MH1k1A4XNRsZsl12KR/UaMVDJMyM+lX05E1fe0au+5bTfRkUzSwGvb3nuqQdxsCppGq
	Q/M1dsf80palUjPbczODWFSxL6
X-Received: by 2002:adf:f6ce:0:b0:33e:834:13d5 with SMTP id y14-20020adff6ce000000b0033e083413d5mr650957wrp.69.1710441809381;
        Thu, 14 Mar 2024 11:43:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVgF62Ke8pOwjKjvGfkCJkiiceS38TRH4H3quMvarHzkZsz2xQbaOU+Zu/5wq90DQPecnfTUDbw2wUmLwf+/w=
X-Received: by 2002:adf:f6ce:0:b0:33e:834:13d5 with SMTP id
 y14-20020adff6ce000000b0033e083413d5mr650952wrp.69.1710441809069; Thu, 14 Mar
 2024 11:43:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240308223702.1350851-1-seanjc@google.com> <20240308223702.1350851-5-seanjc@google.com>
 <CABgObfa3By9GU9_8FmqHQK-AxWU3ocbBkQK0xXwx2XRDP828dg@mail.gmail.com> <ZfNEEFmTkx-RVuix@google.com>
In-Reply-To: <ZfNEEFmTkx-RVuix@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 14 Mar 2024 19:43:17 +0100
Message-ID: <CABgObfb7cc+q3qwr_zKk3SXec_3VtbJ5yWAkVwYXdsFQAB1X_Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: MMU changes for 6.9
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2024 at 7:38=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Mar 14, 2024, Paolo Bonzini wrote:
> > On Fri, Mar 8, 2024 at 11:37=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > >  - Zap TDP MMU roots at 4KiB granularity to minimize the delay in yie=
lding if
> > >    a reschedule is needed, e.g. if a high priority task needs to run.=
  Because
> > >    KVM doesn't support yielding in the middle of processing a zapped =
non-leaf
> > >    SPTE, zapping at 1GiB granularity can result in multi-millisecond =
lag when
> > >    attempting to schedule in a high priority.
> > >
> >
> > Would 2 MiB provide a nice middle ground?
>
> Not really?
>
> Zapping at 2MiB definitely fixes the worst of the tail latencies, but the=
re is
> still a measurable difference between 2MiB and 4KiB.

Yeah, but you said multi millisecond so I guessed 5/512 is a 10
microsecond latency, which should be pretty acceptable (for PREEMPT_RT
tests at Red Hat we shoot at 10-15 worst case, so for CONFIG_PREEMPT
it would be more than enough).

> And on the other side of the
> coing, I was unable to observe a meaningful difference in total runtime b=
y zapping
> at 2MiB, or even 1GiB, versus 4KiB.

Ok, that's the answer.

Paolo

> In other words, AFAICT, there's no need to shoot for a middle ground beca=
use trying
> to zap at larger granularities doesn't buy us anything.
>


