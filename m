Return-Path: <kvm+bounces-36481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B275CA1B64C
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:50:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACF693AB83D
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 12:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 734F979C8;
	Fri, 24 Jan 2025 12:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UHHvltpR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB861A270
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 12:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737723033; cv=none; b=h2nU04421ypfm43n9XAlMevyqI+1Z0qXF9zuOipbHHr7QF3xQ8OCNu2fZSsfjhi8r43J1pcrAN5KqwzfRn3kQAl+iUkRf0PW3VBaSmeNTFDS0354lW2Ts/YymdREvYfXEQzBsuX5Yr5buOWjyfBPxa4A7tAFl2GGF8fXh+ToDos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737723033; c=relaxed/simple;
	bh=AB2Veo0ifNebcRcOL1ytt2gp+aiTiH3Sf5xY6qaSWgQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=O6kZMkJHnam7zmOd+nIv1Oo527JofK0B/msnmTj+RpCamqqLrM554wTAH3f37qH64+iwNU5D3PsnTyCuhWFP1lEYMfu6wXZQlyBkMHLECfBpSGhJSrMjqX+fiODAd9CB5LnyuFM4Yi3Tg1yr4ZvPKZB5sMmpygyoHpGr8bkCnMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UHHvltpR; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5d4e2aa7ea9so3859740a12.2
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 04:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737723030; x=1738327830; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AB2Veo0ifNebcRcOL1ytt2gp+aiTiH3Sf5xY6qaSWgQ=;
        b=UHHvltpRhBzbajms8ANOW2gE6r4+uDsyyZdmv62SPSrPAc5/+q9hftRNdwNMjpZO6Y
         XXMSHlinclP1M6VKntQF7c7XxY4nMH6QFKybHlditRydJcBbHIx7VbZbqDNotqPQHgg3
         cMuDJmfKLc6IcMDkcRSxIGlTVrFeb1eFVK39mO6rwTt0kM+Ar1tfZ2grc+9aPaY0LiGN
         6fm9VCHiDKCDupSUGTJ31eMK2pHIbq7eOyBB0qopjeGsiqmkBCIcfj09v6O/YzE69jbx
         JhXimmp3uosW01yNaTQs9f4VLzh9J68Pe4y94VY50IWTgD6IeDSe0VTCwNDeBCGDGIgf
         yz3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737723030; x=1738327830;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AB2Veo0ifNebcRcOL1ytt2gp+aiTiH3Sf5xY6qaSWgQ=;
        b=ieXmpRdF/67PvHqwiqoSIa1N8cfV3cB0J6Bc2I2xytcXr6EQCkxMFTisbglV4WmXis
         A2v8njxPIIQPyC4E9wglytx1YIQMk0YFEO/N7+FchS/yAuPz3ZlkYrEDtxPkI/XVi7io
         oNBaKGP5AixgI8HDIuSdo27SO665mzFSfW4I358dd+blypLhUf2pjpA9Jgid6SjI5Fc2
         6BiRwK9r7C+4FBGyDzVcxmQp952WUfvPkpvEN1eSp828+UlyljkERnF4PI8RRnqIIYrp
         YIbSpKlWkX78v4unLNLXvYTW/lSiRnyh/BUTKmFtBZMG+l3m4q2dIBLvk4mRMrde8FBp
         v9pQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaJOg1ZelQUoK6c3S8E4CBY55IgVrbu1i3J65h2lWhvQl3wjeOk7v3+ZKmjEIAAX0tcB4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+cT3xcZHpe50h8R7TPNqLZXlJSJ6B1qF6P7nOrHj8dWstYKOZ
	aP7NaT8coSLFqYWYIS/SSY6C/y6Ao7ezx5+9ehpcehyT4ssO2e0EGj0Sb4KynmA=
X-Gm-Gg: ASbGncugsWAKrbZ+wiNW6lD3qj3vt6w4pjLaphEkxmrHtSZqho3prmhBnaDJFaO0Tq0
	n316KIW3u+oGViSS7ghF2FGEaE8SjIFIjW1g7r8zT+lKAVOfVbsmLLPodcBjV1eckuTBmaFj0W3
	4avmpbLNpTmojw5Gmr7WTTaGQHdrkqjDx0/XqRm96pijg7+J0tIYziWiXM8PcuZI99M0VsJ+F7S
	8RO3O2gRc2+tRYvQi2hcI8Crlw4eW6qG1TQlihfukKeUYD/LtCA0+xK3QvkjOgPB18hI+Zr9bar
	d1I=
X-Google-Smtp-Source: AGHT+IHgpCErm6J9FACp/DlMJmoU6m0AQvWBem6CobohmkoE2PSx9F3d28v8z9FWDQeB/0B9Gf2dDQ==
X-Received: by 2002:a05:6402:4403:b0:5da:b47:1092 with SMTP id 4fb4d7f45d1cf-5db7d2f9b01mr25474703a12.10.1737723030120;
        Fri, 24 Jan 2025 04:50:30 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc186d905asm1135005a12.79.2025.01.24.04.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 04:50:29 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 2C1185F8D0;
	Fri, 24 Jan 2025 12:50:28 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org,  Peter Maydell <peter.maydell@linaro.org>,  Paolo
 Bonzini <pbonzini@redhat.com>,  qemu-arm@nongnu.org,  Igor Mammedov
 <imammedo@redhat.com>,  kvm@vger.kernel.org,  qemu-ppc@nongnu.org,
  qemu-riscv@nongnu.org,  David Hildenbrand <david@redhat.com>,
  qemu-s390x@nongnu.org,  xen-devel@lists.xenproject.org,  Richard
 Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH 03/20] gdbstub: Check for TCG before calling tb_flush()
In-Reply-To: <20250123234415.59850-4-philmd@linaro.org> ("Philippe
	=?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Fri, 24 Jan 2025 00:43:57
 +0100")
References: <20250123234415.59850-1-philmd@linaro.org>
	<20250123234415.59850-4-philmd@linaro.org>
User-Agent: mu4e 1.12.8; emacs 29.4
Date: Fri, 24 Jan 2025 12:50:28 +0000
Message-ID: <878qr0jrzf.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> Use the tcg_enabled() check so the compiler can elide
> the call when TCG isn't available, allowing to remove
> the tb_flush() stub.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

