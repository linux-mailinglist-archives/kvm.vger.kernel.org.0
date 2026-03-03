Return-Path: <kvm+bounces-72517-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mJhmHRe9pmlDTQAAu9opvQ
	(envelope-from <kvm+bounces-72517-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 11:51:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EF84B1ECF64
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 11:51:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E2EEE307B1BE
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 10:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9ADB398904;
	Tue,  3 Mar 2026 10:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fyQ68rZv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="olDPDQCL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79F4315D51
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 10:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772534889; cv=pass; b=DbHUYjxRft1jdnn3MuTDfoZKIwb/aabAxuitdHHh2oeysFOWX0XxMuRGF40EIwPJXpaIRl4h2vozatAHMmUKZOJZCrQ8fBuO2ZJJrQynGKzci1otQ8aT6D6Ha0NrvlDjiucs2+W+QSsdM/05uUw14CIsnQQrjJs4oPOjsm9d1/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772534889; c=relaxed/simple;
	bh=m/qcXj6mGP3zYdxM5zi6RmYl905Ja2cTV3CJXRm4xps=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BBLQgci3qy7tEUGsa0UKcXrmPqqmmWhf+WclSPIRSQfh0S4nXJ8ScyXimDvF8T08mcgZrpg3PUpDt7WxmIjM8fESYkpR5djw7edlqg59KkxMccWZwR8ueZHC73wtRkHxCzho7cxqFjfGP6TAL666UttNFvjZx1Aoyn/1hM/B40o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fyQ68rZv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=olDPDQCL; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772534886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m/qcXj6mGP3zYdxM5zi6RmYl905Ja2cTV3CJXRm4xps=;
	b=fyQ68rZvYsu7jZ7dngGBXuY01es6mUPzhlpKnxArE0TfrP2baerVKfgLttYHaAiOR7gi/P
	lvP20nye3uEIX428ETvs6Dj5KY9qmbebEdWIZ4E+8wZH+jMqDQlb+jWBgDg19k8qvRm9tv
	Jt8OglFsNm02Iy8RtlP4xbLb0D4Kdr4=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-zUid2HNcP9KLdpy9CZ3n1w-1; Tue, 03 Mar 2026 05:48:05 -0500
X-MC-Unique: zUid2HNcP9KLdpy9CZ3n1w-1
X-Mimecast-MFC-AGG-ID: zUid2HNcP9KLdpy9CZ3n1w_1772534884
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-354c0234c1fso4456755a91.2
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 02:48:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772534884; cv=none;
        d=google.com; s=arc-20240605;
        b=S/084GSf6R88ux1/fbo7nbR7yrZ1V2ngsGCTxKp48lRv5I7TSfSWWD+af6cyNtqrUp
         4Lt83IoUfargnYSNN2kzXmJwHZMTKsLmrn4wu/h3ILX5zMMhbNM2EqWWnLFz56iOq/XI
         tEZR/BZiQ4mnP2ckZAdWYXf5GxVprZ5n9L2ajB6AyXn+lS8mU0fx+Zbj7KsX1JYB1mHR
         AnLBZ82flwMsnDWxZuY9sNcZBiz2GOagRDznDdcfxfbRHBj5MmcYAw5LKmMtUjKUoxTu
         6MsP06Oi/mhYv+tUj6FbjChwR01hCe6BC0OhdqWG5SHoN5Br7avC7YxrpxWFy5sm/1LD
         AklA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m/qcXj6mGP3zYdxM5zi6RmYl905Ja2cTV3CJXRm4xps=;
        fh=Ao6D83EWFwTOypAQ27zmIhNJJAH/Ecy3K6/ABg8V228=;
        b=hTk02cf/z2++u28ebJ9fDxpOnmm+2f10OAOIX1E2bka9tWVc4N28a++GK4QQ+igQpd
         X8gleL5M9xXThDn4Rb2AjuFgK3GbR3ufOYtJ45KxWnx42dM1onK5gm4sMjLPZfZvEaq6
         cPYaMIRXGZRsqNXGlyq0QFuxMrBvisI3r1KzDwoYUFpBQ9eCaD5lw0nI7537UDtpG41V
         wAf4vK3NIXqwDTrJLkR4GCE+0I5rl76/1KefKRD/F7rRLCcWIYX8MI7iVTc5Df+T77aK
         Fsdnm0yTmzcwSfdddTuts9V6KMBxZ/mVaqrbmdzvaHoX2ZZ83uRvadDQjUb/d5ec5G2r
         TiIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772534884; x=1773139684; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m/qcXj6mGP3zYdxM5zi6RmYl905Ja2cTV3CJXRm4xps=;
        b=olDPDQCLyFLugoF0T6S8o2KLdSLIQnAoPR6Gz+SexQMsINmhrcCjVOQ++iRo213Pdi
         lhiuXFHX7SdDbm0EqvnGpNuJkIKI/J1HIPC11d6aCVqnL9jz1T/g8X1BzuAtt9KYC2Uf
         UmKZ2RSvfLk1d3NpHvEVK++Lt21A9Tkx+S6elTLFMb3G/oiOYKUvMGJRcQxOF0xopYxS
         B3TPuqtBbJGRCKcd43Tc68Hm1+HDabQCVido8TS6b3QlvhmGSoM8zyEFR82Fu1FwjcFh
         EO8wRPtH1CaGkUrRJhHOtTx6/sYo3fgIMcEK5Z//pxaTw0o5QhEdlikXyAUw7Cu6FSmB
         CIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772534884; x=1773139684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m/qcXj6mGP3zYdxM5zi6RmYl905Ja2cTV3CJXRm4xps=;
        b=w0PfGVaXzxCYqpUEo48L3+XdBaazVXo59aigoMKABciLXUz200/AZ/zea3fQ75H5hm
         lZLqrOpqLXP0gaex1mWoEXoHQ5Ueqbm5xUT4MvjsFaGyCp+VdEoYzb5doHKYPuDhNpOa
         VU3XmDYHviujEFxMAc4WIqlkLZuQdUgy9GgKWW0Z33X/OH0OGKqegGgE4pa5oNMC6jqt
         h0aEgpCqFdGK4DITqHGdpeeoiwKxbeQoThF8J+OTd4A+qy0e2YdRpXfMOuroq7wyEjgH
         3AYQ3iMYAcX9tpj/QtNyH3Z5VSHKuSiVPRZp25j932MqmXfK75RrxEKdTAbt4ClseoGM
         MQ5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUATa1vCuLCTgaluxU85fLwFaacxc/rEHK3MrxB2iKN+y6kbmHSBUeq1mFN7VVfekgzAk8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxfdE2QVnwMdazrFwMM3XVWu1+OL2C/RFoqLEnG0FiG6TUZNOm
	I1yEEjFeMoX9EaqaWzE7vZsueizux1Cm7uZT+Qek1+1cXjIUgc/eKXHPUAatxtjXjp1xJ4yiDu4
	QY/GmeB7G16WMGT86gDPhgHplU1TU3kLURMmK2IvNZwA+EeOPQDDc+kQmCcBsN56LzgKpqc0AH1
	oz2U7x8RXiMZGuhte8ofMgg0IXJsXe
X-Gm-Gg: ATEYQzwAj68r/44C/o7V/r/ibCeYXHM1Cg7QIjV1e3LvF7BFOLsJd8XpbBK25ZUc0NF
	C09JEdylv1Q9b+BvWw+O/+r56iNREBJG3jtXYUEff3lR74LnxX1chHvw8S75ifafhZ32/B7p7xD
	2mBXs4RKJHzVzQ4sXsX/0catajCFitKsASNlXXd8//AycD3zgmxnzNQcN+DKxxuHDszH461RwoC
	x6q5y/1mgENOvbOU1yBs9/EPfL5zRt8tt6zaB3RuYFahEApBrvp82sL/NFcCHJlrVOpYX/RS5H6
	bctWv066vqdHMShdUn5tw1w=
X-Received: by 2002:a17:90a:fc4d:b0:341:88d5:a74e with SMTP id 98e67ed59e1d1-35965ccbc07mr12186744a91.29.1772534884107;
        Tue, 03 Mar 2026 02:48:04 -0800 (PST)
X-Received: by 2002:a17:90a:fc4d:b0:341:88d5:a74e with SMTP id
 98e67ed59e1d1-35965ccbc07mr12186724a91.29.1772534883724; Tue, 03 Mar 2026
 02:48:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
 <20260226140001.3622334-10-marcandre.lureau@redhat.com> <99b0ab59-c1dc-4d23-addc-7bf4b87bfa03@kernel.org>
In-Reply-To: <99b0ab59-c1dc-4d23-addc-7bf4b87bfa03@kernel.org>
From: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Date: Tue, 3 Mar 2026 11:47:52 +0100
X-Gm-Features: AaiRm50RcuiyIwROlMmdwKZbzjq0MW23AX7s8d9DGltnMotTX0VCM0Qi-B83jOo
Message-ID: <CAMxuvazwmjjpnpsWpOd_=HcS-6ynpVjAw2u3R=VuE=Lhg=AnKw@mail.gmail.com>
Subject: Re: [PATCH v3 09/15] system/ram-discard-manager: implement replay via
 is_populated iteration
To: David Hildenbrand <david@kernel.org>
Cc: qemu-devel@nongnu.org, Ben Chaney <bchaney@akamai.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex@shazbot.org>, Fabiano Rosas <farosas@suse.de>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org, Mark Kanda <mark.kanda@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EF84B1ECF64
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72517-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[marcandre.lureau@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.998];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,patchew.org:url,mail.gmail.com:mid]
X-Rspamd-Action: no action

Hi

On Thu, Feb 26, 2026 at 5:02=E2=80=AFPM David Hildenbrand <david@kernel.org=
> wrote:
>
> On 2/26/26 14:59, marcandre.lureau@redhat.com wrote:
> > From: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
> >
> > Replace the source-level replay wrappers with a new
> > replay_by_populated_state() helper that iterates the section at
> > min-granularity, calls is_populated() for each chunk, and aggregates
> > consecutive chunks of the same state before invoking the callback.
> >
> > This moves the iteration logic from individual sources into the manager=
,
> > preparing for multi-source aggregation where the manager must combine
> > state from multiple sources anyway.
> >
> > The replay_populated/replay_discarded vtable entries in
> > RamDiscardSourceClass are no longer called but remain in the interface
> > for now; they will be removed in follow-up commits along with the
> > now-dead source implementations.
> >
> > Signed-off-by: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
> > ---
>
> Isn't it significantly more expensive for large guests to possibly
> iterate in 4k granularity?

It's a bit hard to say. How likely is it to have a very large
RamDiscardManager with a min-granularity of 4k?

>
> The nice thing about the old implementation was that we could just scan
> a bitmap, that is ideally in 2M granularity.

We can still iterate with 2M granularity after this patch. However, it
may be less effective than iterating using find_next_bit(). Whether
this is noticeable remains to be seen.

Note: this change was a suggestion from Peter in v1, as discussed in
https://patchew.org/QEMU/20260204100708.724800-1-marcandre.lureau@redhat.co=
m/20260204100708.724800-7-marcandre.lureau@redhat.com/#aZyQWOQeKeT5yzIv@x1.=
local


