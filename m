Return-Path: <kvm+bounces-11968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A8E587DD4D
	for <lists+kvm@lfdr.de>; Sun, 17 Mar 2024 14:43:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B523F1F212DF
	for <lists+kvm@lfdr.de>; Sun, 17 Mar 2024 13:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72F391C696;
	Sun, 17 Mar 2024 13:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HnSMXJqR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12C31BDDB
	for <kvm@vger.kernel.org>; Sun, 17 Mar 2024 13:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710682964; cv=none; b=uob7GIktnUK1jdmC4o2eqAq0zOyx2ByI3H63XSPOAqsOGdvNV8dvstbQrDAqMSiGjknVT5cud7xSTU1o3gBByjZdL/tnjb9sJUVchlleNt8tfxpZkCTrX6g8Q1vGKwGWuDEIBCuPKk4MFeEcXuaZNa/TfMwCJCZtdbfWwAvvVYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710682964; c=relaxed/simple;
	bh=HKn+wSzPxAgbDRqOBP1YPX1DBZwiZhj/zwBVkf4MIT8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=qnKy7bjMsIhLMf57ABSayX9p+T69POjfXcej7ll0PEi9TeVudrk5bcXbZHukeaukThPruusDXy8cSyTmwW2oZAoxDJcNW9zH/gPWkAuYhREogRlICjdlrPOOQVr7wZ2T5EP1/K/wLF8mWfy2zcqgFeB7/FSeInFu9Zb+pNXAp5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HnSMXJqR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710682961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lE5LN5pRZ0/6bku3pPgtdVGUxkTbfetlBUflbCRYp0s=;
	b=HnSMXJqRmB0vDi/0IYqVUnyVwR13tol+6xjt+pqaPOE/A0w8LFU8U6vMKuonupLl2ZNKIu
	yylPPm4wut+OI13A+L/nCzGj8nDzb9scICioXo5VDVDvr4kNWsCZlKtdnWiuzhbzFNPo/z
	Wr7L8ySAwicpf/RwUpSUD7f28CkHC2M=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-Aqnk4dtcMO-E13Ttk-BjAw-1; Sun, 17 Mar 2024 09:42:37 -0400
X-MC-Unique: Aqnk4dtcMO-E13Ttk-BjAw-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2d449d68bc3so34255781fa.3
        for <kvm@vger.kernel.org>; Sun, 17 Mar 2024 06:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710682956; x=1711287756;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lE5LN5pRZ0/6bku3pPgtdVGUxkTbfetlBUflbCRYp0s=;
        b=OUCZR+QPiW8U8t4G9go+8ml3lvODEUCp6kxeVGCLumGu5nltRTr4y/dsIrIJgmlnK+
         BqrZxOf0GsCDkhM7pjTKXrxcgTNji3sVFbsWwfbUoV+zclDSVEsWRG0T3B4d0NHp1Adt
         RD49NYjdJ2RBg95WdEEgU/TqStNPdOjtaavFFAnqZP1rTpRfFZ+u4QxKENg8+0WbrmL9
         OW4Ia7vi0eJvr5OWAIPuqX2jISPQd7OCUcfnMqFBSpK/II2/UzUStnhmLyze1+HhH+mV
         11NtAGoNJ0EXYbzDJ2gMQ9Mkgqi/f9mQDA8//7pb7IlPqzvI6XwZr42pQpa20HDbI8j9
         PSyw==
X-Forwarded-Encrypted: i=1; AJvYcCXMyuQPULKAN3L6mO9T0v6IAJL5H3BqIJwC24NpXTxvvtMk8quNZIGupkrbcJIW2OFUKBoRjRSxlPqaY/UAAABmbdJe
X-Gm-Message-State: AOJu0Ywy3ppvlGCx8mP/EYwP22Z17SZQqDTcH9zuUxlcg3G7kc+s2qQX
	P8FXZwW3uAoHwsJEu0u0EcmOtGSPOYmTZLFsInGGoSDEO4DV/nCSxfxyGpnh1Yk21N3iYJPFuwI
	PpdGcXlzktyBcJlEC+8Z2NUponUDW8EfuPGAmOuWdQG2FrJRkpQ==
X-Received: by 2002:ac2:4db2:0:b0:513:e223:1959 with SMTP id h18-20020ac24db2000000b00513e2231959mr2789147lfe.23.1710682955895;
        Sun, 17 Mar 2024 06:42:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjeOo1KY2AdDRh6n3lebXG2sP7191wBJ4E4igHb0tO+gu4DHNA7iMBFowVrn06ww4A3teZ/Q==
X-Received: by 2002:ac2:4db2:0:b0:513:e223:1959 with SMTP id h18-20020ac24db2000000b00513e2231959mr2789134lfe.23.1710682955497;
        Sun, 17 Mar 2024 06:42:35 -0700 (PDT)
Received: from [127.0.0.1] (93-45-170-156.ip103.fastwebnet.it. [93.45.170.156])
        by smtp.gmail.com with ESMTPSA id r17-20020a1709067fd100b00a466782e438sm3787263ejs.139.2024.03.17.06.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 06:42:34 -0700 (PDT)
Date: Sun, 17 Mar 2024 14:42:32 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
To: Marc Zyngier <maz@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
CC: Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM changes for Linux 6.9 merge window
User-Agent: K-9 Mail for Android
In-Reply-To: <32892705-1A39-430A-9553-DBF254C723E7@redhat.com>
References: <20240315174939.2530483-1-pbonzini@redhat.com> <CAHk-=whCvkhc8BbFOUf1ddOsgSGgEjwoKv77=HEY1UiVCydGqw@mail.gmail.com> <ZfTadCKIL7Ujxw3f@linux.dev> <ZfTepXx_lsriEg5U@linux.dev> <CABgObfaLzspX-eMOw3Mn0KgFzYJ1+FhN0d58VNQ088SoXfsvAA@mail.gmail.com> <CAHk-=whtnzTZ-9h6Su2aGDYUQJw2yyuZ04V0y_=V+=SBxkd38w@mail.gmail.com> <86cyrt16x6.wl-maz@kernel.org> <32892705-1A39-430A-9553-DBF254C723E7@redhat.com>
Message-ID: <2A3D1FDC-CFA8-489E-AB00-FCE3FA36400C@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Retrying without HTML=2E

Paolo

Il 17 marzo 2024 14:34:02 CET, Paolo Bonzini <pbonzini@redhat=2Ecom> ha sc=
ritto:
>[first time writing to lkml from phone so I hope the formatting isn't too=
 bad]
>
>Il 17 marzo 2024 11:36:37 CET, Marc Zyngier <maz@kernel=2Eorg> ha scritto=
:
>>On Sat, 16 Mar 2024 16:01:47 +0000,
>>Linus Torvalds <torvalds@linux-foundation=2Eorg> wrote:
>>> > You can also make CONFIG_KVM_ARM64_RES_BITS_PARANOIA depend on !COMP=
ILE_TEST=2E
>>>=20
>>> No=2E
>>>=20
>>> WTF is wrong with you?
>>>=20
>>> You're saying "let's turn off this compile-time sanity check when
>>> we're doing compile testing"=2E
>>>     https://lore=2Ekernel=2Eorg/linux-next/20240222220349=2E1889c728@c=
anb=2Eauug=2Eorg=2Eau/
>>>=20
>>> and you're still trying to just *HIDE* this garbage?
>>>=20
>>> Stop it=2E
>>
>>Well, if you really need to shout at someone, it should be me, as I
>>was the one who didn't get Stephen's hint last time=2E
>
>No problem with being shouted at, but "depends on !COMPILE_TEST" is actua=
lly something that *is* used for "maintainers will look at it, it shouldn't=
 matter for linux-next compile testing"=2E Most notably it's used for -Werr=
or=2E
>
>When Stephen reported the failure, I should have noticed that the bandaid=
 doesn't do anything to fix allyesconfig/allmodconfig=2E If there's anythin=
g I can blame you for, I thought/understood that you would be able to fix t=
he failure between the report and the beginning of the merge window, so the=
re's that small miscommunication but that's it=2E
>
>>I'll try to resurrect it as a selftest, or maybe just keep it out of
>>tree for my own use=2E
>
>I still believe that "depends on !COMPILE_TEST" is what you want here, bu=
t yeah keeping out of tree or even under a special make target is an option=
 if Linus disagrees=2E
>
>Selftests have the advantage that they can be marked XFAIL, but I am not =
sure they're a good match here (also because the flip side is that I think =
XPASS fails the run)=2E
>
>Paolo
Paolo


