Return-Path: <kvm+bounces-34843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 837AAA0668B
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 21:44:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C31DD3A71CB
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 20:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E1F202C4A;
	Wed,  8 Jan 2025 20:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lo3fOwmy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244AF20468E
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 20:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736369014; cv=none; b=fsOh7V9HrIVKmHnhrSxECDMiUNVf5LCr59sZka6JJgpadsKdRYi6wEcgIhCs+2U2trmhkaxqcAQQuz+ISxGYQqOMCX61zeI98NjFrWmcf5kCSAv8kG3bWPUoxEaFmsdx5bC/ld3VwNElRec5M/J/MZh70Lf4DBJd0D5rXk9q2NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736369014; c=relaxed/simple;
	bh=qm8/CpXRhDiG6HZFuWxAWdER1SEARMMgNPHW2CIWaBQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DlL5zwY7Zl07H7o5+vAYhVue0GPdnrLlPYb4JbcH9AXsomqXjA+ZojAfjht+oyCCJM7ogqyA0/H2rW8wT90HtkykjFHtWKfXkwOk8c3hu5WaxjeRh/vedJ+KIw4o8XcVSIBs/gMHLc+F7TE8vS1Kmjjb0YMCQGZNH3mY5l4Nx8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lo3fOwmy; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aaee2c5ee6eso42242066b.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 12:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736369011; x=1736973811; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qm8/CpXRhDiG6HZFuWxAWdER1SEARMMgNPHW2CIWaBQ=;
        b=Lo3fOwmyf69LsTN1d81S5FY5dj57Tanru0n849pTfbDQiqUao+LQYjA7OGD7OlDMC2
         rjrtn2mVDIkK3ZyJOIw3QQkdrQTgS2KiCIpT3BWzFSXHOilsPyzhDV6+OOutoSR+u45B
         J2vGF6MV3U7UyMuQVWXM248lQB7BPPwLjAM76OCo4OgimqL+Q+L1wNW8r/8fNKGWMRW1
         SbqzIz8CRNR6DClDnzAva+memCKBaU0q8rfj8eiMQEoIRrQVvYqe9pzPXR79HYPmQLNl
         tKkZEu6LDOsUyJacVx0MN2bMxF8T1U5fdz3R/Vvo5ihelnvZxukt78WuK8TPivncb6HW
         CMyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736369011; x=1736973811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qm8/CpXRhDiG6HZFuWxAWdER1SEARMMgNPHW2CIWaBQ=;
        b=fpZ4niR26DZ+XRE7InM5xCMdKA1wQo4bkwfYw+CfcFXgx5oQs+awVC6z2mQBzKB9sb
         QHh5wyxKcqXLEIdd/i3zHdnz+AkzWfcFbr6JeY2GZK4AlcioxAJT4ImFMcGTsJCTZ/O0
         RqTW7R5QNduSWnEOGBGtEH+9hvrNydWAjA5K7ZxvNYoRyEi6zHdoqDNvSWETmzvMbn+x
         VvMwH0AEG1xwGHk6oDad3Z1OJVZN34EGrH/E1Ky0yP6Y1/lUJIT95dWCak/TtLptCJcV
         t/GN5YlZbsG5+QJ34P5oYh4+vQAvo7zS1xIN8eGmkLCso8F9VrUIjuietHHkj3ysmUUS
         7duQ==
X-Gm-Message-State: AOJu0YztnkyquYm/SD7dShgRUTVLDWG808rPnvylM1E7hy1sIUFQWm68
	vCNkOkpc0HmBeVhCzXiqN0CT/OwY+CffRo+Pcn5YS3kurn7Kn3oiwagqWwQl35kDow3Wm32x48m
	3zoU2eajNCovc/KmQDOZAS3xzpfnRYGyy5d4L
X-Gm-Gg: ASbGncuC6GaEZfGcaS5XjeA4UNI9cBj+k4QAaVaDxLyfit4jvRhZiq3JOwqmLbKG4GP
	pRKC2140aEMbC+3ZkvJSEUI0sLxtMQmhCjmQWBA==
X-Google-Smtp-Source: AGHT+IEgXNk03H0jABY9SNm5a/PKA1joLYa9MDRlPclWFEDo9UAEYFAiH8VAW/h/fz5g9qovHGnAzdnkeP/Q+WeAIRU=
X-Received: by 2002:a17:906:dc8d:b0:aaf:4008:5e2c with SMTP id
 a640c23a62f3a-ab2ab66fea4mr336788966b.2.1736369010944; Wed, 08 Jan 2025
 12:43:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241218152226.1113411-1-michael.roth@amd.com> <20241218152226.1113411-2-michael.roth@amd.com>
In-Reply-To: <20241218152226.1113411-2-michael.roth@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Wed, 8 Jan 2025 12:43:19 -0800
X-Gm-Features: AbW1kvbr7bbe_F2G-RXlZqhPDpFu5CzdRMz-FR5uA8gPAVNRMbKsDEBExbUIkyg
Message-ID: <CAAH4kHZnZn0xkhtuAutoPfbF+52LS1ovY1CSNf10+PWfemL6NQ@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, pankaj.gupta@amd.com, huibo.wang@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2024 at 7:23=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> For SEV-SNP, the host can optionally provide a certificate table to the
> guest when it issues an attestation request to firmware (see GHCB 2.0
> specification regarding "SNP Extended Guest Requests"). This certificate
> table can then be used to verify the endorsement key used by firmware to
> sign the attestation report.
>
> While it is possible for guests to obtain the certificates through other
> means, handling it via the host provides more flexibility in being able
> to keep the certificate data in sync with the endorsement key throughout
> host-side operations that might resulting in the endorsement key
> changing.
>
> In the case of KVM, userspace will be responsible for fetching the
> certificate table and keeping it in sync with any modifications to the
> endorsement key by other userspace management tools. Define a new
> KVM_EXIT_SNP_REQ_CERTS event where userspace is provided with the GPA of
> the buffer the guest has provided as part of the attestation request so
> that userspace can write the certificate data into it while relying on
> filesystem-based locking to keep the certificates up-to-date relative to
> the endorsement keys installed/utilized by firmware at the time the
> certificates are fetched.
>
> Also introduce a KVM_CAP_EXIT_SNP_REQ_CERTS capability to enable/disable
> the exit for cases where userspace does not support
> certificate-fetching, in which case KVM will fall back to returning an
> empty certificate table if the guest provides a buffer for it.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
Tested-by: Dionna Glaze <dionnaglaze@google.com>

Thanks for your patience.

--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

