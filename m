Return-Path: <kvm+bounces-34910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9551A075CA
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 13:32:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E7F23A6D8A
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 12:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98D28217670;
	Thu,  9 Jan 2025 12:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Whdcyk/Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FC51E515
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 12:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736425969; cv=none; b=hhapFKtfKRylm41Eox6pc9nzs1vhei60o5okP55YBEE6DUyGjfqfNLVLrt+Tn9iN3CY2JmVfkoa5+p7OIZ6hTpuXHqu5A9/F3izaGShyFdpK755sa3kj1Ah0ZcJ49A3dFD16RadRUaczZYy56O3b16xSe/OsUJc7KsCB11lRZ6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736425969; c=relaxed/simple;
	bh=ElowdUPH6tGbs8dtn398AiceT0bJrOtpEVcDuHQf2rs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tSC4GFn0N8Jmgnv9J34SDCtDnx1WCAe/uYFJEJwXOCFFUeQ8Y9pIZNMpjmBhUhVDA3RGGGcV/TkiX/+gHXXRsQJzjYbpK74pI3kbN9ed/Ib+viD818nSt/fYqy8gJqk2x5H+NpKMQe4qZYVCJTarJF64Evhh1vMpC8I4pTPpD/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Whdcyk/Q; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-467896541e1so240391cf.0
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 04:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736425967; x=1737030767; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ElowdUPH6tGbs8dtn398AiceT0bJrOtpEVcDuHQf2rs=;
        b=Whdcyk/QTZr+wWuTeAgcU68z02spheBp8JgQu7bTZ/nPoun74J2tBGCIA53xK4Erz6
         3Yz1fBMnPPyFdbSzDzcJ2QJxbo1F9jMjjztdOOQRI6N1bv59nIEMFqu5cSgmDGqrqqD0
         bq1e3sgGU9AWB/S/2Dfw4reEWPoTtEUDbRBbPNSSkNPNL459yYS/p7IR+VendE/AJvaN
         QdSF3/RcZ1RNsER2H8+PMHPkVAXTneFHX1pls08hSVplob99KwxKseuJHUD9c6gkGmbn
         f/rdAFkIgWpyCxUHFdt75q/jpf4wQzNIfrjt9wfIT3l1kdkaEeFO7Ed/mVvsAKi0NEEK
         kNhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736425967; x=1737030767;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ElowdUPH6tGbs8dtn398AiceT0bJrOtpEVcDuHQf2rs=;
        b=LtKJx/rAcmQb1swTqfcas9e7Nbzk4cEW7GwjlGcJHFdMubt94Xqb0lS2udPnZvrJrh
         +9kNAvJaY5Mn7QeLJ1DHKQ7TTGbyXy8rdSbRItryQ/uQ5ssJX7oDSdQgoIdDxzaFG1In
         I6eTsUdOSmulbeDBXc8Ox8CqrIaR1XD/BRTb+khvQ/yLpr8Wx2xjJ6Z5SC9F3zbYnSbV
         K2IkNt5Ch76YJnV7vbylYS8Ky4+t2LuxZXu25R6Kfu4ZyNzZK0+T6YbrZvSrie5tF08v
         folyROB7u3wyNI2GZje5ZLNHfEn2ohaaVb4TNYkBFuVG0UOFec81b2RicpAiKKWSI+Dh
         h9dw==
X-Forwarded-Encrypted: i=1; AJvYcCU96NgNE+82AvWGquprWGT95bSpgGar21FBD3wMmySTk1vrYQCCMzlmyM3CW3fbtn1fBLs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQL71XfsJSYCTaNjU3v+MzKUpd6IG6R0B6+/5hNRBvYGKFQ7ld
	kKeUxN1JSpOF9hLdTmAf9pS13mVRCBFDkUfZtakapN9dSFieJ0mIBbtTKQ54k9sb3UITbeX/s70
	NrnE9RJWFWM1oPOQFwEjTqVQPQmHK+8xrFxd8
X-Gm-Gg: ASbGncuBT5Zy/36z6z95o9KPiv9AIXt75TdyFGvJk4YHz9XExITPey/mjqztlrwKkUz
	Z6nkM1q6jff1lY02DtuHwsdPcmBZ4E+q8hJwTUhVFslpOWm9WDpFvLPNBG+sR0d4Jar8H
X-Google-Smtp-Source: AGHT+IGevsnR6joV4XchbP9WVhprQZWht8RSpL0AQ/Gcqz4+RDjOrr4IT0BDDP+r+8f+wEFR9RRqf5Pa4UgbGtVg/5I=
X-Received: by 2002:ac8:5946:0:b0:467:7c30:3446 with SMTP id
 d75a77b69052e-46c7cf52016mr2577921cf.25.1736425967022; Thu, 09 Jan 2025
 04:32:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241220-kvm-config-virtiofs-v1-1-4f85019e38dc@google.com>
In-Reply-To: <20241220-kvm-config-virtiofs-v1-1-4f85019e38dc@google.com>
From: Brendan Jackman <jackmanb@google.com>
Date: Thu, 9 Jan 2025 13:32:36 +0100
X-Gm-Features: AbW1kvZvRN-RL_9xpxLfZq3wiojOgiO5vJSmCm65NPiTm3PboNiuc_44PFzqbEY
Message-ID: <CA+i-1C3CWRdU22O5V7XDSkvZscGb_H_mGRQLiZ+6XTsM+Bwdzw@mail.gmail.com>
Subject: Re: [PATCH] kvm_config: add CONFIG_VIRTIO_FS
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 20 Dec 2024 at 15:07, Brendan Jackman <jackmanb@google.com> wrote:
>
> This is used for VMs, so add it. It depends on FUSE_FS for the
> implementation.

[Apologies for the duplicate mail, seems I accidentally switched HTML
on in my GMail]

Hi Paolo, happy new year. In the cold light of January I'm realising
this is not really a "KVM change" so sending it to you was a bit of a
random choice.

But, it does say "KVM" in the name and nobody in particular seems to
own it... so... what do you think?

