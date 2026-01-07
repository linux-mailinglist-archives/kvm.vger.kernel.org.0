Return-Path: <kvm+bounces-67233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E8FCCFECA4
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 17:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 81D4B3060592
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 15:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594BE341ACA;
	Wed,  7 Jan 2026 15:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=0x65c.net header.i=@0x65c.net header.b="pEWRrarZ"
X-Original-To: kvm@vger.kernel.org
Received: from m204-227.eu.mailgun.net (m204-227.eu.mailgun.net [161.38.204.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1C13904CE
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 15:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=161.38.204.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800259; cv=none; b=oAWTI2osC6ZMNIqsCeeTc2cVbuMCDWf1R0mKrLC1GD9JivDrz6KLCNeOcohukLTCUjxoMRvFZqh5jUOnhuZF4JuMH7WRAxAi/jw7c0lce2E2HIi4K4KmKwLRfCFop9zxSQ5K0LEjNAfQMvVDTfCmMVPa6af3qYvvoujAGkPQ/KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800259; c=relaxed/simple;
	bh=TQmYl+r4MgsPEZqU/dgO4nyjCTnnZepMfwpbuV/01kI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rnGkMdgj0gyicik5XWQCCNhSsxL89m/HXS8bGLuRsfD8h/2/DfcpqpElpBge+HMMdEXSXf3bqcf9u75tfPRpl569ySgIrsM1+wi7Rz+jT8puM/3Y0D8765KgMr6IIifNt7nQYfN5S76ZNqerORmG1XmdG7NxWu5OSZCTd2/Lug8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x65c.net; spf=pass smtp.mailfrom=0x65c.net; dkim=pass (2048-bit key) header.d=0x65c.net header.i=@0x65c.net header.b=pEWRrarZ; arc=none smtp.client-ip=161.38.204.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x65c.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0x65c.net
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=0x65c.net; q=dns/txt; s=email; t=1767800255; x=1767807455;
 h=Content-Type: Cc: To: To: Subject: Subject: Message-ID: Date: From: From: In-Reply-To: References: MIME-Version: Sender: Sender;
 bh=klGybuY/xGn6v3C0r58vztwgdWJovVA4JzJPJnJ3+CA=;
 b=pEWRrarZRIB19CxSHOoZMHAYeuszXV11EqI23vhg6QTzwvvMzBN5Km+SndsKReuNkjv1uhmjA+MUE5kUo/HyB7QtwhrU23k+1UR0CbFimsuCdgqlMY0isFqEep1tcyOl+BhqtQ7pC1hKFu4DEYbuqD2IFmZVAbQUemRgqOp/LS6UtjzTIYaZRArDcicYyz50kD8Lz32DdqDLLYQOEUNw5bdX+aZoLx6SfBYS4GXhF6agnfaQQ0hZ0DE/sOCQIOugZExRwlDYCplZDYYcbYkcD0lfoQpYEtYLum/LUo8jAKUYTU5Qy18AYyLYOwzXXKYJjlqT6PxiKznoXUkGOD4IQA==
X-Mailgun-Sid: WyI1MzdiMyIsImt2bUB2Z2VyLmtlcm5lbC5vcmciLCI1NGVmNCJd
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179]) by
 17d8445a2b493864ac13348340e4061bc7666dd3f454a97e208dcc528130dda2 with SMTP id
 695e77d52a2628e0767f5b18 (version=TLS1.3, cipher=TLS_AES_128_GCM_SHA256);
 Wed, 07 Jan 2026 15:12:21 GMT
X-Mailgun-Sending-Ip: 161.38.204.227
Sender: alessandro@0x65c.net
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-790b7b3e581so11679327b3.0
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 07:12:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVSg5E5bCVmfKWgHaykRN5y9zIW+EWh4KAAa3EW7XKA2EJvHEnNI1vU5/7t64d3Etg9JkY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9tjtFDSN0OkNZZ8hQv1uJD+uZT1DJtZ2agwbQSAcXrTirKBWv
	7rsbJtKkb5NZavjcFTV33cW4JRNhfzFC/3OfMHX/0u3WDC9SStJdt5NipuJGMIeH1372oNvj/AK
	XtCfGwUY1wH/ZoNgr135ybdXxxrG0dwc=
X-Google-Smtp-Source: AGHT+IHsegLs402ADRbnDAjvBRf2NzOtto6Q/Bsqcx/Emex8y4/4momb5Dn8jHhYlC//otlZv+b1lq6PJFRMCXx07CY=
X-Received: by 2002:a05:690c:6893:b0:790:8708:bdfa with SMTP id
 00721157ae682-790a9613bb6mr62156627b3.6.1767798740119; Wed, 07 Jan 2026
 07:12:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260104093221.494510-1-alessandro@0x65c.net> <aV1EF5DU5e66NTK0@google.com>
 <aV1HtKXlePEJ7CJd@google.com>
In-Reply-To: <aV1HtKXlePEJ7CJd@google.com>
From: Alessandro Ratti <alessandro@0x65c.net>
Date: Wed, 7 Jan 2026 16:12:08 +0100
X-Gmail-Original-Message-ID: <CAKiXHKeZNdXXMakcYcMxQqKUrQX4Dj+M1XPt=sc-Wjeba5W8-Q@mail.gmail.com>
X-Gm-Features: AQt7F2rPDtbqq4HRgk985GPEx12AxgEza5N4t-FLFwOEfQ2f7sPksATvm5WA8Go
Message-ID: <CAKiXHKeZNdXXMakcYcMxQqKUrQX4Dj+M1XPt=sc-Wjeba5W8-Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Retry guest entry on -EBUSY from kvm_check_nested_events()
To: Sean Christopherson <seanjc@google.com>
Cc: Alessandro Ratti <alessandro@0x65c.net>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 6 Jan 2026 at 18:34, Sean Christopherson <seanjc@google.com> wrote:

Hi Sean,

>
> On Tue, Jan 06, 2026, Sean Christopherson wrote:
> > On Sun, Jan 04, 2026, Alessandro Ratti wrote:
> > I'll post the below as part of a series, as there is at least one cleanup that
> > can be done on top to consolidate handling of EBUSY,
>
> Gah, I was wrong.  I was thinking that morphing EBUSY to '0' could be moved into
> a common helper, but kvm_apic_accept_events() needs to bail immediately on EBUSY,
> i.e. needs to see EBUSY, not '0'.
>
> I'll post this as a standalone patch and then try to add WARNs in a separate
> series.
>
> > and I'm hopeful that the spirit of the WARN can be preserved, e.g. by
> > adding/extending WARNs in paths where KVM (re)injects events.
>

Thanks for the detailed review and for working out the correct fix.
I completely missed the mp_state interaction and learned a lot from
your explanation.

I'm interested in contributing more to KVM. If you have any pointers
on good places to start learning the codebase (e.g. particular areas,
bug reports, or documentation), I'd really appreciate it.

Thanks again for your time.

Alessandro

