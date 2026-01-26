Return-Path: <kvm+bounces-69085-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CNnxHcY2d2nhdAEAu9opvQ
	(envelope-from <kvm+bounces-69085-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:41:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A32C7861FC
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:41:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2E3073003708
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 09:41:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB1632AAB2;
	Mon, 26 Jan 2026 09:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cb/PuZ/Z";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="pRSGeP0W"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BF4329E5C
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 09:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769420478; cv=none; b=Sz0ju9RuEG7ogdie/C3twJeU7r2Mz4Ey0wJZVcpnUYPv104xhny9C5n9KDGxossjMmneWf8zOqHxfE4br6HwkObRLfDElOHmg389w3Ggy7fKbyC/3RTjYTGyoi2mnoWhTBxYDl0S/H/fjTcQGs9FD17JoSzEomwPVk8j2pVqxcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769420478; c=relaxed/simple;
	bh=1C0k9gJ+5oI1N4mcv9s8dt3gMP1eRZworQGDszJ7AEE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=XygxnG+f/iAp/UPlxDE5Wa5WDeIVgOArp+AOKF1J2ZeEF926tAXN5uc24tGpZMHpzzqFpIoHzobGOGFeSqKjS8JVj4dhYd1iHLLlaoJ7NelGzwK6tqAWdOD8s3NsIyzsSagGP5LMoj2zKckW3b1dmZCrgBbepVmalUaf9rLs6xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cb/PuZ/Z; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=pRSGeP0W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769420476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o3nUjIOb0Yn17S7L5tMmCjp3A5l9DzXaUcdjJgTeGkw=;
	b=Cb/PuZ/ZzXbrzyMEBKuH99DKQMtRABYokkIhBudMRhQzDaHlnQycJ9Pu/vyLT39vBEWmb2
	pse3GfcfLqWp99qWi5kVLIfTh+7o1RPbr02aFUmI7QkmMB5Y2QlfnBKIl0u+vt8etzEbpR
	IwE7pOPpqVd25+c0iQY5mpHCG+FMcFE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-lITKSbQyOrWjA8EBwKnf5Q-1; Mon, 26 Jan 2026 04:41:14 -0500
X-MC-Unique: lITKSbQyOrWjA8EBwKnf5Q-1
X-Mimecast-MFC-AGG-ID: lITKSbQyOrWjA8EBwKnf5Q_1769420473
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4779d8fd4ecso26255265e9.1
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 01:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769420473; x=1770025273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o3nUjIOb0Yn17S7L5tMmCjp3A5l9DzXaUcdjJgTeGkw=;
        b=pRSGeP0WxEv/zkOdwz9fdyDVHQ7MK8cUX0rcdoHZp1vSAuGmaQlidSN3RSlZqH3HkV
         QOx9DdlUweITo/ePXixb/Ug5jzWlUpCA8pPT3M8OgPPdeAQjZWLNHkGpaTiFfGp2clgC
         0edaP85vY9Pt6Bxy7yUPB81yM7bwVN15YnLKH6ZudKzAD0lCDAWUj8U7LSIY9vAMs7Al
         X8bgkxTgrY8l9t9Rk/mtr4tRuuhBTv3MZfZfYvuzGmcxQDn93DsYZtLx7entRQG/8oSj
         0ATTlmio7tyNPV+nUNTJ5/YXiaJuuQkXjzrqwVV4+O4W/T62jSG6icDhCqxBuLybC/i4
         7Pkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769420473; x=1770025273;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o3nUjIOb0Yn17S7L5tMmCjp3A5l9DzXaUcdjJgTeGkw=;
        b=cCQgdgO5brKJi4j59yaVR4zVIhtS064ddPjsyFAuNgqdy5gu1eanXoDijJpo6JFOI2
         E55dFAZWA2Yu6rh6dgAmCeAyKnuSQhEFwuEdJOt5wTD54fREKKMMx1VFXhWY90s6JO79
         2v1ySlHG1hPDKELMLGu4eupKbCykh+mXTyEKwAZ15plr4InUBej04x2/IQAkviULXSDK
         ZLio1hsbA5Ihrbt2ABN1LqEONGHuyTdnXKsmZe7W3ys4tp+ZP7cEs9Ve+GnGbeJxdDby
         +6mZm6PtzdCLIhTehDVIq/VUQYiBKnE0YuznLKPx7wfsfcqg6ppXjgbNaF2VcD9xeJXE
         mumw==
X-Gm-Message-State: AOJu0Ywk5MGpRo9Nd9jkoOLT5CD5wouBL2aFtCcDv4YQba8P0wWxtnAY
	IDR22f7OEShF2OtP9nns4OhzcL5TFCh+y5j9taBL/QQPEot6qCrU9npsYzo8nPdfN1nIEJOE9Zz
	8CjWm6Rk79GqrDLbddS34itj5FBYfFO6PSxK+ZMI6jNRXZ/rQx9nHIA==
X-Gm-Gg: AZuq6aLvNepqyd11X8PR1y9ywdz346ikB6LQ52hl2hBjvPn67FI0+qs8AA/cusIkMXn
	2lwgMQEQDndXIW/WHwWVweWYePZ54s9VX0xY5hWWPnylMmMbmdzE1Qy69GbZST2QvR4bo1q3MeX
	j8rMWTzy85LcoXHc9yjfXPQzbexGPbU1h0zMD18b8znvre0q96NYQTWMiY6oT2Vwb7lpKFW3E3l
	ELqJeiZuucJS9R8U+OZyS8n1viVN83Yw26fYAzM9V80HRW4YxaqHZsymf/2FletMWMgO9Jx9fEw
	8VIFCv/kz72Bn+4it2/s6imbHtOKCKwKSlbg4C4K0+nG1PmqgeQgbt9fSnDJCdsFnc8aU9Xeifp
	++Fn9HQ==
X-Received: by 2002:a05:600c:698d:b0:47e:e2b8:66e6 with SMTP id 5b1f17b1804b1-4805ce4fba0mr63757075e9.14.1769420473027;
        Mon, 26 Jan 2026 01:41:13 -0800 (PST)
X-Received: by 2002:a05:600c:698d:b0:47e:e2b8:66e6 with SMTP id 5b1f17b1804b1-4805ce4fba0mr63756705e9.14.1769420472530;
        Mon, 26 Jan 2026 01:41:12 -0800 (PST)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804d5ffe12sm99503345e9.3.2026.01.26.01.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 01:41:11 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Alexander Graf <graf@amazon.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
 x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 nh-open-source@amazon.com, gurugubs@amazon.com, jalliste@amazon.co.uk,
 Michael Kelley <mhklinux@outlook.com>, John Starks
 <jostarks@microsoft.com>
Subject: Re: [PATCH] kvm: hyper-v: Delay firing of expired stimers
In-Reply-To: <769f538d-dd42-4d36-a4c5-7e6e48b209f6@amazon.com>
References: <20260115141520.24176-1-graf@amazon.com>
 <aXO8I6xuZyZB7CxV@google.com>
 <769f538d-dd42-4d36-a4c5-7e6e48b209f6@amazon.com>
Date: Mon, 26 Jan 2026 10:41:10 +0100
Message-ID: <87bjigaeyx.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,zytor.com,kernel.org,redhat.com,amazon.com,amazon.co.uk,outlook.com,microsoft.com];
	TAGGED_FROM(0.00)[bounces-69085-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vkuznets@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A32C7861FC
X-Rspamd-Action: no action

Alexander Graf <graf@amazon.com> writes:

> On 23.01.26 19:21, Sean Christopherson wrote:
>> On Thu, Jan 15, 2026, Alexander Graf wrote:
>>> During Windows Server 2025 hibernation, I have seen Windows' calculation
>>> of interrupt target time get skewed over the hypervisor view of the sam=
e.
>>> This can cause Windows to emit timer events in the past for events that
>>> do not fire yet according to the real time source. This then leads to
>>> interrupt storms in the guest which slow down execution to a point where
>>> watchdogs trigger. Those manifest as bugchecks 0x9f and 0xa0 during
>>> hibernation, typically in the resume path.
>>>
>>> To work around this problem, we can delay timers that get created with a
>>> target time in the past by a tiny bit (10=C2=B5s) to give the guest CPU=
 time
>>> to process real work and make forward progress, hopefully recovering its
>>> interrupt logic in the process. While this small delay can marginally
>>> reduce accuracy of guest timers, 10=C2=B5s are within the noise of VM
>>> entry/exit overhead (~1-2 =C2=B5s) so I do not expect to see real world=
 impact.
>> There is a lot of hope piled into this.  And *always* padding the count =
makes me
>> more than a bit uncomfortable.  If the skew is really due to a guest bug=
 and not
>> something on the host's side, i.e. if this isn't just a symptom of a rea=
l bug that
>> can be fixed and the _only_ option is to chuck in a workaround, then I w=
ould
>> strongly prefer to be as conservative as possible.  E.g. is it possible =
to
>> precisely detect this scenario and only add the delay when the guest app=
ears to
>> be stuck?
>
>
> This patch only pads when a timer is in the past, which I have not seen=20
> happen much on real systems. Usually you're trying to configure a timer=20
> for the future :).
>
> That said, I have continued digging deeper since I posted this patch and=
=20
> I'm still trying to wrap my head around under which exact conditions any=
=20
> of this really does happen. Let's put this patch on hold until I have a=20
> more reliable reproducer.

My bet goes to the clocksource switch, e.g. the guest disables (or just
stops using, good luck detecting that :-) ) TSC page and uses raw TSC
for some period or something.=20

I remember we had to add some fairly ugly hacks where we also "piled a
log of hope", e.g.:

commit 0469f2f7ab4c6a6cae4b74c4f981c4da6d909411
Author: Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Tue Mar 16 15:37:36 2021 +0100

    KVM: x86: hyper-v: Don't touch TSC page values when guest opted for re-=
enlightenment

Also, AFAIR we don't currently implement "Synthetic Time-Unhalted Timer"
from TLFS and who knows, maybe Windows' behavior is going to change when
we do...

--=20
Vitaly


