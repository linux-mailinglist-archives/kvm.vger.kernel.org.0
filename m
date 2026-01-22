Return-Path: <kvm+bounces-68891-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8LLTOPQecmmPdQAAu9opvQ
	(envelope-from <kvm+bounces-68891-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:58:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 78CE166F2F
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:58:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DCA6990473D
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78FC733F8A1;
	Thu, 22 Jan 2026 12:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ViAiI8bk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406F92D63F6
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 12:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769083365; cv=none; b=TsVlopM5Hhd9NfNfAFTei8v7k3IUB9ODa2SCZgErVnzhMQi2QKAgM9gDiBbKU+TdZpn1fylShUAdT7H4Pa/GlcVbB7rP8vsj3W846C7hYHltdQbanFbk26eaLxXo35hI+Y8/WupkYWq0UAeg+WYHc886GL1UHpaWBSBw09TCngE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769083365; c=relaxed/simple;
	bh=IV0TqbTg/+4uGAUoSxt9s9gvGUiNBTaujR9Ftl0cXgY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OqcJGrX11A4T7ciNq0Y3KfkntogQbLeP6e/Jk5cec3vTMtHSeoIW5mwsBOZVH3EvmssOKmzPAV1jeHcxM6vqEACIx9jgeMAqaLCRv8xKeUjiXmK3rINQYeKGQx5oWUJeb+qBSJunN50C5JAXMr9L5YDJ+7LfItm+4UNRKNfSTWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ViAiI8bk; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47ff94b46afso7202805e9.1
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 04:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1769083361; x=1769688161; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IV0TqbTg/+4uGAUoSxt9s9gvGUiNBTaujR9Ftl0cXgY=;
        b=ViAiI8bkeikiCbyJx9ygyzjn1YMYZSyyJBaY2RuBnyjZUZ8lOQKQ/gsYUQrMjyZFnN
         vEVuSJ9yZa34THlV9TYgYXsU5pH0WecXTxQ1ITk2g1JZwzoE4zJDfco6W5PjnejxJJA0
         Bsk3BiJDkITiuDca5j3YsDbPyIiJM5mjN/QzPARKNY2mCRimCu3mVFEXrNk3l1U3dbDA
         OX1MP+tWufMuVH0G1ahXvoNMDQDjJ+FNPxzgBOhZwWl7Rf8TW9EkmZsxLORj2T+UoYQT
         LXvzIZra5N+miQVZKgBfXOd2/FIsB6GEarJDXaiM3sITmJTuG1vsK1536/AcFDi7pw6I
         tuTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769083361; x=1769688161;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IV0TqbTg/+4uGAUoSxt9s9gvGUiNBTaujR9Ftl0cXgY=;
        b=Vn7RvMYchnt/ijc3eEEBX/X+TRFhwycmK4PzEcrrJ/LDz/kBiEUs51OSeMKT0A4OlC
         erFWQZMHg8ma1oNIZquUeJPmljbGowxKMCzSm17R9Ie8e+tcXdp5bfrDDWlSDRl3MIxs
         MYy+5TwNy8GyCnhQVB9pJpgRAOE2h1rHHERvtGMnpgNNaqp8WNVgm30wvXrvkE7DhyEY
         np22vO2zXxtJ1QbWf5AhI6DXgl/usXnH4U2j5HfkwXuci7Ydvw6a/u+0HDKU9sZEMHUU
         HyeBO3hAVFr8WV43j+EtcpDj/M/hJSWZQqKLzE8Moj4eZNAMlVvTo5EnZU7S7IFTiC5/
         r9qw==
X-Forwarded-Encrypted: i=1; AJvYcCU9cVohMKlD6RdnZiPtDIX1RcvRGGVhTaoSbKivUOpAbXBipClmJXcbg8Vj3oUmlduNcdg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpPwPK6/3R39J83VKWrkExepY1BQTwNOCbF3ZyXm9c9npGiCmb
	8adJmb4fQE1FmR15FWHTvkZjwR4P8GuPqUhmALiJS2U7IEwGT7KxjsFZJNZlfjT9w3I=
X-Gm-Gg: AZuq6aKXB0qaBU/nbN1E9LF2e1UV2vLMRW0MKPWMoOpe3FXhltYQ9b8UVUcHQtgBVQJ
	zi3H0vv+Pt0hecckMjW8tmTyCQqX/Z7e+dJtmbqYLpzrgmuGzE8MjIjUdKhQihNbY3Zh4r2LLEX
	jmh0jyqsztvy3nJ/UYnaN11PlIXs2Px7FeD9cOSfsfc7Q7KUnRfgPjYsIFUpuo2U2PGonE0tgxa
	63NrB0aTaNnmo2pn7wwTt3GhFYfynVZjyfniObyhPeXs6oExELAr0gMbe0BJwrgv9cMBC/FLq8d
	sh2i8VcaeohB3JFOCFhCTzyVwm9ECLJtux963N1mWCaacp3DEa4FQHbHU//Qi0wRmkg3gJoIZj7
	gmtLOZnHZEZPli1HyPtG1anJyaKg7TEJVOt/6ss+HAH8HxpBpZZQrvahN4w8m9Atwi4iLBAJXsR
	Ygr3EyqSx78yPU
X-Received: by 2002:a05:600c:c119:b0:47d:333d:99c with SMTP id 5b1f17b1804b1-480470aad7cmr37016245e9.18.1769083360846;
        Thu, 22 Jan 2026 04:02:40 -0800 (PST)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356999824csm43810152f8f.39.2026.01.22.04.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 04:02:40 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 2334E5F7C3;
	Thu, 22 Jan 2026 12:02:39 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>
Cc: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>,  Peter
 Maydell
 <peter.maydell@linaro.org>,  Stefan Hajnoczi <stefanha@gmail.com>,  Thomas
 Huth <thuth@redhat.com>,  qemu-devel <qemu-devel@nongnu.org>,  kvm@vger.kernel.org
 <kvm@vger.kernel.org>,  Helge Deller <deller@gmx.de>,  Oliver Steffen
 <osteffen@redhat.com>,  Stefano Garzarella <sgarzare@redhat.com>,  Matias
 Ezequiel Vara Larsen <mvaralar@redhat.com>,  Kevin Wolf
 <kwolf@redhat.com>,  German Maglione <gmaglione@redhat.com>,  Hanna Reitz
 <hreitz@redhat.com>,  Paolo Bonzini <pbonzini@redhat.com>,  Philippe
 =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Mark Cave-Ayland
 <mark.cave-ayland@ilande.co.uk>,  Pierrick Bouvier
 <pierrick.bouvier@linaro.org>,  John Levon <john.levon@nutanix.com>,
  Thanos Makatos <thanos.makatos@nutanix.com>,  =?utf-8?Q?C=C3=A9dric?= Le
 Goater
 <clg@redhat.com>
Subject: Re: Call for GSoC internship project ideas
In-Reply-To: <CAMxuvawgOvQbwoyCzFBLw++JqR0vFbVUhbv1AJWU6VqK1MM_Og@mail.gmail.com>
	(=?utf-8?Q?=22Marc-Andr=C3=A9?= Lureau"'s message of "Thu, 22 Jan 2026
 15:28:24 +0400")
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
	<CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
	<CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
	<CAJSP0QW4bMO8-iYODO_6oaDn44efPeV6e00AfD5A42pQ9d+REQ@mail.gmail.com>
	<aXH4PpkC4AtccsOE@redhat.com>
	<CAMxuvaw04pDNzHyw5+Qcv_KfrhDTiyp+MNxpECp+HfTa5iLOGw@mail.gmail.com>
	<aXH-TlzxZ1gDvPH2@redhat.com>
	<CAFEAcA_u6QUhs+6-cyYm_qttsDiV2zHbsc-_FbTb8QzWXk6+tw@mail.gmail.com>
	<aXICpFZuNM9GG4Kv@redhat.com>
	<CAMxuvawgOvQbwoyCzFBLw++JqR0vFbVUhbv1AJWU6VqK1MM_Og@mail.gmail.com>
User-Agent: mu4e 1.12.15; emacs 30.1
Date: Thu, 22 Jan 2026 12:02:39 +0000
Message-ID: <874iodonxc.fsf@draig.linaro.org>
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
	FREEMAIL_CC(0.00)[redhat.com,linaro.org,gmail.com,nongnu.org,vger.kernel.org,gmx.de,ilande.co.uk,nutanix.com];
	DMARC_POLICY_ALLOW(0.00)[linaro.org,none];
	DKIM_TRACE(0.00)[linaro.org:+];
	TAGGED_FROM(0.00)[bounces-68891-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex.bennee@linaro.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,linaro.org:dkim]
X-Rspamd-Queue-Id: 78CE166F2F
X-Rspamd-Action: no action

Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com> writes:

> Hi
>
> On Thu, Jan 22, 2026 at 2:57=E2=80=AFPM Daniel P. Berrang=C3=A9 <berrange=
@redhat.com> wrote:
>>
>> On Thu, Jan 22, 2026 at 10:54:42AM +0000, Peter Maydell wrote:
>> > On Thu, 22 Jan 2026 at 10:40, Daniel P. Berrang=C3=A9 <berrange@redhat=
.com> wrote:
>> > > Once we have written some scripts that can build gcc, binutils, linu=
x,
>> > > busybox we've opened the door to be able to support every machine ty=
pe
>> > > on every target, provided there has been a gcc/binutils/linux port at
>> > > some time (which covers practically everything). Adding new machines
>> > > becomes cheap then - just a matter of identifying the Linux Kconfig
>> > > settings, and everything else stays the same. Adding new targets mea=
ns
>> > > adding a new binutils build target, which should again we relatively
>> > > cheap, and also infrequent. This has potential to be massively more
>> > > sustainable than a reliance on distros, and should put us on a pathw=
ay
>> > > that would let us cover almost everything we ship.
>> >
>> > Isn't that essentially reimplementing half of buildroot, or the
>> > system image builder that Rob Landley uses to produce toybox
>> > test images ?
>>
>> If we can use existing tools to achieve this, that's fine.
>>
>
> Imho, both approaches are complementary. Building images from scratch,
> like toybox, to cover esoteric minimal systems. And more complete and
> common OSes with mkosi which allows you to have things like python,
> mesa, networking, systemd, tpm tools, etc for testing.. We don't want
> to build that from scratch, do we?

Well for vkmark it was easier to update the mesa in buildroot for the
latest bits for testing venus than wait for the distros to catch up with
library support.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

