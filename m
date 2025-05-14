Return-Path: <kvm+bounces-46505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C633AB6E28
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 16:28:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB0C6862CE7
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 14:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3106193402;
	Wed, 14 May 2025 14:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oUMMZzDm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666009478
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 14:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747232898; cv=none; b=MvOrhaJzSIiDw/d/suWqid3KjQx8uL2WpFvvS6e/q56lFRnNMnIFZ0T/OBrRKThV6JlGHoyYY/EnFlP6jk51YDkub1ySnDUZMnY/apMX1/sPhjD2v3ENOxQPEQzC//+EXDkp2fSKINvEc6kUbr8aOyrJb/mPi9SjdMvAWw8qqZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747232898; c=relaxed/simple;
	bh=+CkoP5BlTkuB0KaCxwhsbWHrsVIGKhwqqS2uurcGshw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DU4A4in6EW1zQRQN2y+Ph/FDOKDjxdVamb/DM45auSJrtyScUHgj3GNBc1JTagendJcfWtvOzi1HpCo36zpgOP9XrYNOy/sjfNeE0EW+tKg1mBM+LZd//9dTAUMaFJpeqftbGLr8Yospllw6SVkrBbCyPnoqk+ooxBy0TIm76KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oUMMZzDm; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b0e0c573531so4643565a12.3
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 07:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747232897; x=1747837697; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7JwSZho1aVXd0gOKNCtJu6/KAYeC633U2Q8DtB/XeCo=;
        b=oUMMZzDmajrzLcVtTFOSkozMKzu5VUGxn0AmgKeeCoX1KeRChzcy/T59P2d/QwcXin
         EL63o9TSJmlxRSibsYqLMgr96EmqsOUCbc5nXd6ZxAcIrxC6sw+JKt27X1fV46L8FqVQ
         PBLlmpqC4ehQ+EvJXnyfJzwCQQ9SPJr18bdJvGVTgklg/XeAfkBtxgHrpN6aQXLE41KP
         cJMrz08e0qZIDYoCWTXzlVW+1CHXc4U0JL4utGKsAX39AhH40tqvhaH7L+2dz9d16xn2
         yVrfcuX0yZ2hREu4lk/NZmIHoID6M1W3jWk4peprI7JbKHtcSZLynZ3NcHszCWRncNRz
         IATQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747232897; x=1747837697;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7JwSZho1aVXd0gOKNCtJu6/KAYeC633U2Q8DtB/XeCo=;
        b=tIQTajNEoINFGNhcFVF84gK8qzYIqXu7UtHnSDWRd0SomgdMn39uh/7EADo4Qgmztj
         zCjSXmyJe2CLPmY/z4CCq9shnBD5O1wPRHkwfbezqzSY1dy5dg+RYV5BnpDR+tBIHNCU
         4Hlm806uOOX8vCqHvioGyubsEymT6eesBMGksjH4PyFRLNORywLJdTurTbELbW6OrpC+
         w+pnZIDIP40AFiCtviK3Za3CQU9lW07eVKbpWPbaDhJug1c1s1q9TAbCY/hHYvbvMPIV
         WYyT5AjDNCE8+OJfen9UKB6gxzszZClEsUaTMYmOB6QPDJVgxiwDB9pFMzMpir5NTLvh
         e6fA==
X-Gm-Message-State: AOJu0YzE2wOouOqUArVx2TbiY3jjUcSdfeSRjMfHOoDA2TJODnNM3qMf
	WghmOGatpLACWUaMhIyA1EKT2njzwPBNVdBrrNYldoFFFQZRe1r2u8Z42Uw3AATlM1z6U/2jTWI
	ZUg==
X-Google-Smtp-Source: AGHT+IEejYLU/CvC6l7GTpDB1yueWZLgwJKtIoxwmY92wteVivAmhIVBF47cYfmEL4ofY6C8LdKH5tp76EM=
X-Received: from pjbqc9.prod.google.com ([2002:a17:90b:2889:b0:2f9:e05f:187f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f4b:b0:2ff:784b:ffe
 with SMTP id 98e67ed59e1d1-30e2e5e5a8fmr5993301a91.11.1747232896994; Wed, 14
 May 2025 07:28:16 -0700 (PDT)
Date: Wed, 14 May 2025 07:28:15 -0700
In-Reply-To: <9ac64e89dc5467e15c397e7bc14f775c693f91d7.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250416002546.3300893-1-mlevitsk@redhat.com> <20250416002546.3300893-2-mlevitsk@redhat.com>
 <aAgnRx2aMbNKOlXY@google.com> <14eab14d368e68cb9c94c655349f94f44a9a15b4.camel@redhat.com>
 <aBuV7JmMU3TcsqFW@google.com> <9ac64e89dc5467e15c397e7bc14f775c693f91d7.camel@redhat.com>
Message-ID: <aCSof_0F2mE9gMYh@google.com>
Subject: Re: [PATCH 1/3] x86: KVM: VMX: Wrap GUEST_IA32_DEBUGCTL read/write
 with access functions
From: Sean Christopherson <seanjc@google.com>
To: mlevitsk@redhat.com
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, May 12, 2025, mlevitsk@redhat.com wrote:
> On Wed, 2025-05-07 at 10:18 -0700, Sean Christopherson wrote:
> AFAIK the KVM convention for msr writes is that 1 is GP, 0 success, and
> negative value exits as a KVM internal error to userspace. Not very developer
> friendly IMHO, there is a room for improvement here.

Yeah, it's ugly.  You're definitely not the first person to complain about KVM's
error code shenanigans.  Unfortunately, disentangling everything and doing so in
a way that is maintainable in the long term would be quite tricky, and absurdly
invasive. :-/

