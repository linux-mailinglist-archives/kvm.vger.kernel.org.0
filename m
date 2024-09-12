Return-Path: <kvm+bounces-26758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15E269772B9
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 22:31:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6ECC1F24E04
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 20:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0671C0DF4;
	Thu, 12 Sep 2024 20:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IuUxudrt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353E918BC19
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 20:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726173063; cv=none; b=mpgx1QEO1WmyMriZASQP0ADUUHfqyjuupBCAiqndLyobKpSneI84AQ9ez2QYqQYgzrWUskAZI7HHpAR6pTRWED5rBp0DoTqzTkDfz4U8ugIERfBjj54jRRdMUX5g1bpU70AEN/s8jRQsPz0tRJRtbytUIfaDs9p+2jRWdUzUvxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726173063; c=relaxed/simple;
	bh=u3+xTKiDZ6CgDyqF+o7xgUFgxz+T2D6SLtwRNZRyVS8=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=gV7v83lO56FIlGwY3bIVJ93IH9e1txpVyisUscwkW7PV1CBy22cS85q8s8C8r8wQuPAfxKoKgIVAsxsvJxoBqSXfRzX7N6mOrAymSqXCCtoX4drWj/AGLCATZ/1H7iuNgmg5dinYksxVZUR3/79I0W6N9fa2P/CxeNGbHc6/Aco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IuUxudrt; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-82cf28c74efso214836239f.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 13:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726173061; x=1726777861; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yLPhhW7Y6mbWdZPPRUIkvARITfuZTEZkDii7oKKU+Ek=;
        b=IuUxudrtlEScnPVJtdJIZL653Kzmq2KrkAJZPlos0BCzQ/d8bWSAWJkoHNmSMMvpzX
         baaUwY3pLIG5Q8FPiRzMLdlaTS1hNSet+8xvdak+omyblP51OedpMqboDXfBWT0v/rVB
         8tE537sMMR+gUfLWoUy5+xEH3z5fAzERmA5v7Bnw//1jsFw9/0TOahkCJLsXQUMYBNCF
         Z7SN5Rf/20K6pfJRiIHgQgYVJWfu587IeXQtEjx6LZFw64K0kp+5b+DQsRaFTes86bRV
         JGLk+EEFNQwUgbXyYligdHmcQnfPazUUNlbGOws4Mz15dOUCrjTI4NOM0+BbnvSbHhZB
         lcPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726173061; x=1726777861;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yLPhhW7Y6mbWdZPPRUIkvARITfuZTEZkDii7oKKU+Ek=;
        b=VzJ1TchsB0LRPmytThfc6el/Z0JfxkqX83bJ0F4uTEdb/KSxtA7ABeTod7rLpusMmD
         86X+8/ExKvEWDzfMv8cM3vL5mDXj6dmqZIlsGJm2pdR4aedl5KGftwPY1ZBXwfeCOHu1
         7lSlmaHC1f2vOz9WEHkOubUo+YY0p7vO6KqeQqNmtR2nVCMuOQFdNcgS3AbKWkN9ZviS
         jHAXpKHHvnIOPp0+Dp06pYQZWWVkbHfQ2L63XA8T0Hjydc8wKRehxvrHTFOWWrs+24+C
         S/sc9LEtlo85t6Opp5pstb3LNoguOFy/TpeIKhh4zId6DBNE1wHlPVVsaWrUQLyVcE/P
         HSRQ==
X-Gm-Message-State: AOJu0YxgdSQ2tF1L3/TafYLJVSJLEPnhZ0DTlyEOHtit0NjELg2yZRx9
	qna+080LDc7jfOorWwiEAlJ13j+e8GegZB3a6jSpkvYlK42nj0HQeC8VN2fXLuY8FY81KYVJ+xw
	TXBx5wfsw9H7ghVCn2hJIoA==
X-Google-Smtp-Source: AGHT+IEvNBP56SW+DzYGXpGSQjGH7l5m6WCB475tagf/GqT0PVTompxQRWYnVlmUdK8417EDaVC+g6P+CB3gV00+3Q==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:1412:b0:4c0:8165:c391 with
 SMTP id 8926c6da1cb9f-4d36136b75dmr162015173.4.1726173061371; Thu, 12 Sep
 2024 13:31:01 -0700 (PDT)
Date: Thu, 12 Sep 2024 20:31:00 +0000
In-Reply-To: <ZuIgE2-GElzSGztH@google.com> (message from Sean Christopherson
 on Wed, 11 Sep 2024 15:56:19 -0700)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntldzwd37f.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 5/5] perf: Correct perf sampling with guest VMs
From: Colton Lewis <coltonlewis@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, oliver.upton@linux.dev, peterz@infradead.org, 
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, 
	adrian.hunter@intel.com, kan.liang@linux.intel.com, will@kernel.org, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, christophe.leroy@csgroup.eu, naveen@kernel.org, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, tglx@linutronix.de, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Sep 11, 2024, Colton Lewis wrote:
>> Previously any PMU overflow interrupt that fired while a VCPU was
>> loaded was recorded as a guest event whether it truly was or not. This
>> resulted in nonsense perf recordings that did not honor
>> perf_event_attr.exclude_guest and recorded guest IPs where it should
>> have recorded host IPs.

>> Rework the sampling logic to only record guest samples for events with
>> exclude_guest clear. This way any host-only events with exclude_guest
>> set will never see unexpected guest samples. The behaviour of events
>> with exclude_guest clear is unchanged.

> Nit, "with exclude_guest clear" is easy to misread as simply "with  
> exclude_guest"
> (I did so at least three times).  Maybe

>    The behavior of exclude_guest=0 events is unchanged.

> or

>    The behavior of events without exclude_guest is unchanged.

> I think it's also worth explicitly calling out that events that are  
> configured
> to sample both host and guest may still be prone to misattributing a PMI  
> that
> arrived in the host as a guest event, depending on the KVM arch and/or  
> vendor
> behavior.

Done

