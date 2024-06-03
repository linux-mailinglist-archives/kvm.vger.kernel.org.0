Return-Path: <kvm+bounces-18665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 146198D8512
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:32:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 456451C2159A
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 044F512EBCC;
	Mon,  3 Jun 2024 14:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b35BPGj1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B7857C9A
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 14:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717425123; cv=none; b=u8rVJaqqh5AdoDfv7YGHN5gOqXwPvRy+dmde9Y11e4lqWPSSZufn6+v8CALuB3q28nayxd2TAk/56bV5IDMq5qZ2hmk4dhogKIeidsgOfqvEqgb+PF0jmPNcFrl+XlVgS9ZafbHFcc7TAjeDQDoiYqrgC8+OWROdjSWdwra9YJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717425123; c=relaxed/simple;
	bh=uMnGCaUCOJM5udsLF47byKKqJDKb1E5kZ3laZqy4Wr8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vfs3T5z7zoRcNx8tgsMFvVko1TyvZcAOX2r5OpbjjmQfH9oHbg3j1t5i2ihXHVfkjALz92WG/6V1qSL5NwuYORpX1CybdD6auSEX9xfOdOhE3Oy4s5oBADacLHsNBBcd+lQlmCZ7JFMfgffe6TLTE36fB6Q3IeJ5acNB884T+iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b35BPGj1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717425120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uMnGCaUCOJM5udsLF47byKKqJDKb1E5kZ3laZqy4Wr8=;
	b=b35BPGj1ivaM/xtQPuSHTS2vlwcQtP2jRMfHIWN1UJ0+6XJ17spW+wVUvh9Rd5C72ajYmQ
	8HlJVSXkojBwJugNZpplwvcUfFJ7X3FXvelyB7c2omDrhPDk7gU+0Ti5A7VDpvkdOX0zgG
	Nt8D47QUMsLS2nVE8+q52X+P4Jonfuc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-3B3k4NlYOYiSK0XqUhuxDg-1; Mon, 03 Jun 2024 10:31:58 -0400
X-MC-Unique: 3B3k4NlYOYiSK0XqUhuxDg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4212b505781so19592005e9.0
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 07:31:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717425117; x=1718029917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uMnGCaUCOJM5udsLF47byKKqJDKb1E5kZ3laZqy4Wr8=;
        b=JjSlyNahoil5g5006MuwEN0S+epYyLDyu9t2Bv7rkwyInQjzEGSuPW0FFA8pwRDcNU
         tAjHgO5o6+T7eD/ZGF3121+fopLvgrabK4kcA8aXb040cu07m3cpAwCA4jeihx3q5LgN
         bQDFaA9dbnyQ3+9hfoWx1nUpzm1sofv4pJ7dIlfO1Rm5UPBWGYVkg/HLNoZu5iq2pEtw
         ihyi2MmoREPhLQ5ZmMWglK5zqRpqNAJrRajFiwzd8xY3G54jrclY9GmTOnIv46QO+q6n
         vWX1V+9mNQwnboEuCFodqpDOKuWM4SbncrWLnEPRlEjEpdtOeT5VrzQEPT2afeT05ewM
         pkKA==
X-Forwarded-Encrypted: i=1; AJvYcCWbmg6VDW1ExalmICO3mfIzaYfLjfQj8JKLOHNAcZHD8olIAL9Unp2dcQCuhllpvrdqfuR+XDGXM0AqAoNt9QX0inDc
X-Gm-Message-State: AOJu0YzA9q+bW62AHuxScsuMbXHJOsTw/jEMsnRIZggijWmJtJcmf7JD
	IYY0mPttIjRNnJzistd0Mj6OshKa2HLqo0Dkr8HbusyyVUiJ5st8rDsFgLmSE6DVvMBFQDYwmWE
	6+XQUDfvKdUjSyxMmEnAKWARiffvFAM7Vdb/38nCJN6+RwX0enyJoPzVBG3VJ++MldoZfvCaB79
	StYy/XCkHiH2fa1eetkjDR60hz
X-Received: by 2002:a05:600c:3b03:b0:421:37fa:e4c8 with SMTP id 5b1f17b1804b1-42137fae759mr47275395e9.1.1717425117187;
        Mon, 03 Jun 2024 07:31:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIqVgMiZETokwx4bnQfwEuYfXGJ9+dX3tDZuMpzrYFYkEGfDNRhvdAm2VeKVBzxGhk2RlybO7OquqkEUsJj0M=
X-Received: by 2002:a05:600c:3b03:b0:421:37fa:e4c8 with SMTP id
 5b1f17b1804b1-42137fae759mr47275195e9.1.1717425116846; Mon, 03 Jun 2024
 07:31:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-30-pankaj.gupta@amd.com> <Zl2vP9hohrgaPMTs@redhat.com>
 <wfu7az7ofb5lxciw2ewxoyf5xggex5npr7j2qookddfuaioikk@3lf2nzapab5c>
In-Reply-To: <wfu7az7ofb5lxciw2ewxoyf5xggex5npr7j2qookddfuaioikk@3lf2nzapab5c>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 3 Jun 2024 16:31:45 +0200
Message-ID: <CABgObfa1ha1MXYWLRTfBtMCTh0n=wNO=9jbRgbO10ksuzMO9hQ@mail.gmail.com>
Subject: Re: [PATCH v4 29/31] hw/i386/sev: Allow use of pflash in conjunction
 with -bios
To: Michael Roth <michael.roth@amd.com>
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>, qemu-devel@nongnu.org, brijesh.singh@amd.com, 
	dovmurik@linux.ibm.com, armbru@redhat.com, xiaoyao.li@intel.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 3, 2024 at 4:28=E2=80=AFPM Michael Roth <michael.roth@amd.com> =
wrote:
> So for now maybe we should plan to drop it from qemu-coco-queue and
> focus on the stateless builds for the initial code merge.

Yes, I included it in qemu-coco-queue to ensure that other things
didn't break split firmware (or they were properly identified), but
basically everything else in qemu-coco-queue is ready for merge.

Please double check "i386/sev: Allow measured direct kernel boot on
SNP" as well, as I did some reorganization of the code into a new
class method for sev-guest and sev-snp-guest objects.

Paolo


