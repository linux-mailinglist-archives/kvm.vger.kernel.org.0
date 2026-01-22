Return-Path: <kvm+bounces-68889-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2FA+Kl4TcmksawAAu9opvQ
	(envelope-from <kvm+bounces-68889-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:09:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EAE8E666C2
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2D7F2921BBE
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57EACDDAB;
	Thu, 22 Jan 2026 11:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EidgmAbS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9459542AA9
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 11:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769083116; cv=none; b=bFyLOCGbocjewOtuufgHw3RbqFFATkC82yRodNAG2Nne1ateSsfwedlhCGjPUa81jmSm45wQf7UfWIUvG9EbrxqOrUAjv9U9fojTNMmF/pN+Ad9s4X4bz/3aIyYbH7XiXVxFRuVUf51VdbXe/dXKhXbyafYjWB0hTwwe6Tvy9Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769083116; c=relaxed/simple;
	bh=qkZw6KPaG5PKjEDDbBD5vX+nBUkzAzgwkRfkZFLg3pY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=eG4lFU5nloAJFd/cgQ2ed+Ztei51p6h3irJHvMCGaMTjqlxK7NjLt/so/0cjY7jC4DcztS0wSaynui8jGmcE0WzgzDeyyE5TGxJqmPI+C230bEaYg8XBEzvq4mbY7HAVV8DGEOZkXlqXPoAryNocnJlSwSFIxAhUdhLvw1/TLK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EidgmAbS; arc=none smtp.client-ip=209.85.128.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-4801d21c411so4616185e9.3
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 03:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1769083112; x=1769687912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gHfdd3PqXR+pNd5kr/XcJwuBr+hhdfms2ANVE1n3ues=;
        b=EidgmAbSc/gmlo51EG3VX6DMvtnNLHO4cIhRbUS8vDQbvvJHCwOeioAthy7MUNhS0h
         QeQ4AwlaFcBqv5WRAQijngcQMUWw+V3DYGqUTXbVNrcu8/RgxsmYPbTNFjo+ApBBQY+y
         BC6XVAGzoPwrVhGBCFur5QPkLgT7+kDie5c748xGEHmkDCQPb0JF9bsiVb+jXBHYrk5G
         Kxxk94MN3+LagDm+TcXZsuNxxi239eWOFw5pw7g+MBLRL4OEgQOapMIwPky2rciSya78
         yyo3z5kYZHIHmExi0pf5ez0Y2xi5GfmL1jT0jJo7ZiB2ZjMvSm9weA1tg26OI4vyLZfN
         PQmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769083112; x=1769687912;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gHfdd3PqXR+pNd5kr/XcJwuBr+hhdfms2ANVE1n3ues=;
        b=RHVhrEKWU7a8n5CkzG2a7enKJdSMFJ1HZuCfworDJ7STm5amiUCuWVBm62kvSO8XjH
         EUj19ghyTTLUJWqsiVsR4sjcuE1hy2GeQgSsh75H7DLCVCENh2/PNv+bXue/Q3dEqU8M
         EZPuXjQs55bfxws1UKhp5XZ2PBpXwlpo0FSwz5fY3uSfVgRWioeWUp+GMzkXqmcCzdLw
         kmsC4Uwm4qrr2+9MLu+7n+/pXLOcOBaCPlg03KG+07aBWv+CUzUOWQquej5NkGKD8R3x
         8je4terUSt/oRr3f5DMeTecGPZ/X4MqsMx3Nx84rMrnBSiJM8KiyEoBGsI2PlWJvgD2+
         hRFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmjsZtFqdZzF5JtZNbCWzaCBrubM45GmQacM2CDGOkRpKyt/aVuowoj+sabglvNWY+g4E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwR2KjPhkjCClifEzQJKXS3aidWWG4mAGLbMgpQiQx0QazM8OQk
	pcW3w6WDpJMvVg9XtZSW0ZdYBEUipMxYecKDNzzK1vtKyLvZ5mIB7QMk3Se4d2+ozWY=
X-Gm-Gg: AZuq6aIC1KbimWZy4pc/K+cg/HutxjUh82c7bzb8JdHS1xtaySR1v+ZokDPVb0AXyOT
	/3H97CQ2iHMxdXHtCt/2xhdkVF3It12gaHpnaLnVXIm2rUIERZgbpmZkUSFCDXTVmZoYKnUj3qg
	jhJGbTXvtILmvxe2xXGbFtypcY2oo6FRrxXMNq1Ed6rHZiwImYxjOnKzUq1OIps6e4/R1BQ5Q0U
	bfkdgJ0yy/DAjH/C3HZ4+Si+8sLkWUvnyUR4w7Wbx1JnSr0efCIOqzebMpfMoB7tjetdU+VpCqF
	aWhEX+WS5Ajc2sz6yBgoPjD/QeKiHWF2iIvnnRumN8bEFuOPdX6JN+GInamzFU0kFs5Kilq03kU
	qVFEXKSrOwjFUJnuAGT8MzwlpCNa8a+OR5dSegVQ/h6gZVuDb9n69Ehui2Jn+7xw9AucmrqGREe
	uT7BkPJrxLdQTE234gZwiYsAM=
X-Received: by 2002:a05:600c:630e:b0:479:3a86:dc1e with SMTP id 5b1f17b1804b1-4801e34f6e7mr326379705e9.36.1769083111644;
        Thu, 22 Jan 2026 03:58:31 -0800 (PST)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804702fab2sm60597375e9.1.2026.01.22.03.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 03:58:31 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 51C8D5F7C3;
	Thu, 22 Jan 2026 11:58:30 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>,  Stefan
 Hajnoczi
 <stefanha@gmail.com>,  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>,
  qemu-devel <qemu-devel@nongnu.org>,  kvm <kvm@vger.kernel.org>,  Helge
 Deller <deller@gmx.de>,  Oliver Steffen <osteffen@redhat.com>,  Stefano
 Garzarella <sgarzare@redhat.com>,  Matias Ezequiel Vara Larsen
 <mvaralar@redhat.com>,  Kevin Wolf <kwolf@redhat.com>,  German Maglione
 <gmaglione@redhat.com>,  Hanna Reitz <hreitz@redhat.com>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,  Mark
 Cave-Ayland <mark.cave-ayland@ilande.co.uk>,  Pierrick Bouvier
 <pierrick.bouvier@linaro.org>,  John Levon <john.levon@nutanix.com>,
  Thanos Makatos <thanos.makatos@nutanix.com>,  =?utf-8?Q?C=C3=A9dric?= Le
 Goater
 <clg@redhat.com>
Subject: Re: Call for GSoC internship project ideas
In-Reply-To: <995d4aaf-bbff-42be-9114-1f04bb51e37c@redhat.com> (Thomas Huth's
	message of "Thu, 22 Jan 2026 12:05:14 +0100")
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
	<CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
	<CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
	<CAJSP0QW4bMO8-iYODO_6oaDn44efPeV6e00AfD5A42pQ9d+REQ@mail.gmail.com>
	<aXH4PpkC4AtccsOE@redhat.com>
	<130b8f26-2369-48f5-bbd6-e27210707b9f@redhat.com>
	<aXIAmeEWMFjQM84o@redhat.com>
	<995d4aaf-bbff-42be-9114-1f04bb51e37c@redhat.com>
User-Agent: mu4e 1.12.15; emacs 30.1
Date: Thu, 22 Jan 2026 11:58:30 +0000
Message-ID: <87a4y5oo49.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk,nutanix.com];
	DMARC_POLICY_ALLOW(0.00)[linaro.org,none];
	TAGGED_FROM(0.00)[bounces-68889-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCPT_COUNT_TWELVE(0.00)[20];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex.bennee@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[draig.linaro.org:mid,dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,buildroot.org:url,qemu.org:url,linaro.org:dkim]
X-Rspamd-Queue-Id: EAE8E666C2
X-Rspamd-Action: no action

Thomas Huth <thuth@redhat.com> writes:

> On 22/01/2026 11.48, Daniel P. Berrang=C3=A9 wrote:
>> On Thu, Jan 22, 2026 at 11:43:35AM +0100, Thomas Huth wrote:
>>> On 22/01/2026 11.14, Daniel P. Berrang=C3=A9 wrote:
>>>> On Tue, Jan 20, 2026 at 04:42:38PM -0500, Stefan Hajnoczi wrote:
>>>>> Hi Marc-Andr=C3=A9,
>>>>> I haven't seen discussion about the project ideas you posted, so I'll
>>>>> try to kick it off here for the mkosi idea here.
>>>>>
>>>>> Thomas: Would you like to co-mentor the following project with
>>>>> Marc-Andr=C3=A9? Also, do you have any concerns about the project ide=
a from
>>>>> the maintainer perspective?
>>>
>>> I'm fine with co-mentoring the project, but could you do me a favour an=
d add
>>> some wording about AI tools to
>>> https://wiki.qemu.org/Google_Summer_of_Code_2026 to set the expectations
>>> right? Since we don't allow AI generated code in QEMU, I'd appreciate i=
f we
>>> could state this in a prominent place here to avoid that some people th=
ink
>>> they could get some quick money here by using AI tools, just to finally
>>> discover that AI generated code is not allowed in the QEMU project. Tha=
nks!
>>>
>>>> IMHO, our baseline for functional testing images ought to be
>>>> a Linux Kconfig recipe used to build a dedicate kernel, plus
>>>> a busybox build for the target.
>>>
>>> Not sure if we want to add kernel compilation time to the functional te=
sts
>>> (even if it's only done once during the initial build)...? That could e=
asily
>>> sum up to a couple of hours for a fresh checkout of QEMU...
>> That's absolutely *NOT* what I was suggesting.
>> We should have a 'qemu-test-images.git' repository that maintains
>> all
>> the recipes, with CI jobs to build and publish them (along with correspo=
nding
>> source). Those prebuilt images would be consumed by QEMU functional test=
s.
>> This would be quicker than what we have today, as the images downloaded =
by
>> functional tests could be an order of magnitude smaller, and boot more
>> quickly too.
>
> Ah, sorry for getting that wrong!
>
> Ok, so this sounds basically just like a gitlab-CI wrapper around what
> buildroot.org already provides. ... not sure whether that's
> challenging enough for a GSoC project?
>
> Also, adding this as a separate repository will easily burn your
> gitlab-CI minutes if you don't have a dedicated runner for this, so
> developing this feature might be no fun at all...

My intention was to get the test images as part of buildroots own
testing setup and re-use them for QEMU.

>
>  Thomas
>
>
>  Thomas

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

