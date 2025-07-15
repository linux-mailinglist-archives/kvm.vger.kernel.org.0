Return-Path: <kvm+bounces-52490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7572CB05794
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 12:15:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1C573BAE3D
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 10:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B50FA2D8361;
	Tue, 15 Jul 2025 10:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NMXaYcd/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872C819DF6A;
	Tue, 15 Jul 2025 10:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752574540; cv=none; b=JRbQ5LINEKuC/RwhiPCd13fGno4XhcnH5YwolrXiM7kgw/VY3PAxA1Z5n6H6nUY+lDiIHCFytVGNrhXB0h/Cv8KVOthYGMCaH45MmZRio3jcLIncnb/k0EZxZgzJN1wJ1aYE77HDktsXWI75OykpqVVhXLOqhnUnjArbqQb4Vq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752574540; c=relaxed/simple;
	bh=VOgd/f+7ucVxgKPQt+le3tgaefSc/k2gkuYDcON9H3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZybHKgNwGJLYSVuLMOREN738LUgkc9pZsaIXM75/U3p/ug5LXWuTELVbBsrS9qTvIsnJWHqijyzNv9h452pBhKhkxwxN/qVlMdWvBvdCyHipuE0TluHkHr34llPcDjOKmqfvJfDSA89wI0gP1cJ+ovag445MLf+rnW4OGlmFO+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NMXaYcd/; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b34a8f69862so4343142a12.2;
        Tue, 15 Jul 2025 03:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752574539; x=1753179339; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/4avChY/XBw4AEVJGZpVoPxxAdPXVZUCe+lPK83QOGc=;
        b=NMXaYcd/YHFz3588FMGtJc7P72poF7fX8aDDBelW8WFsNPJZIBsgrDK851GaBX13qS
         uMFek6j7X4IYrpiKBBM70wzz+P4JwYjs2ZKBIzxnkjPLvPEHEwyCxRfpeolNReiOZGvz
         aRPKft7zMLyQll/D3GrQfo+bbNTOkrO4BRH1KlwL25gF59lmkcnRd5ASHOAVoHo17xIM
         FmTaBBY0efBy6f1ZuAE40lgH17H5pM2pKAAatE6qpxbHCzPxxnqvCRSafFyYqXaa4uIZ
         BJokwcee1JFpkif2KkT41sjRp7baFIW2LVVbYw3bfGPN5JOaXkgciWufaLEAsR0Zaz9Q
         i28A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752574539; x=1753179339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/4avChY/XBw4AEVJGZpVoPxxAdPXVZUCe+lPK83QOGc=;
        b=hrxpysDPmgfzMwTVJDFAuwwSfdUpfqgs8zbNy7HCbA8h5GpSWEoBGLqZSM3J4H07cC
         I5SGWKYTvYGAvT/sI2ocIA6syi6QDWYl4gllyZie4hHZGMZJMcHn5UN+Y1CNlnEeI4pz
         v9h3ckXRmntDzCnK9PsZTlY6kaUO+Dou1Q/zPa14TuDqtgGuWhya54YN4xkGwQmqTvcV
         Vb2BXc3sp7bIEWvbmVafsUBVbtnwP9DUmF/GBQyOxgBcT5G7Ieps1z4sRjdLqHBZcaN1
         6psUKc4nb8/dcwKxYBvmJadrDqIcWChKo6tcr2dVIcMoB/Nu4d6lxSfEgyVSxJ3QCF+S
         Kwng==
X-Forwarded-Encrypted: i=1; AJvYcCUScOUvc/Yg7eH0bAgrN4wo8ErlKmDwHzIW9m9bML6zvWsPVLxPoJK67S/b0rv+ZbLHvGg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQxZD2B8s9CcVUP79nMxZQQFlUCQAjVji5DoC6tkebEuQTGqYL
	BWdiXPC9BCLfx/FrabKn5CoNhrNyISnfwPv/o/+wlcTNgOQJ4eRW5UdUM30aB4FtgMrabkm3c0B
	6G+zXMcEuD6RSzY3xRF25egrCxht0Cps=
X-Gm-Gg: ASbGncuG5OKKdmxOsqhTbZyI9/QeYKz1a5qhwDOR57ag2VTdNon5oDi4gzVPVCrJ64D
	rHbh/EEe2Z6zc6Kgm+XbUXCLmD+7T8GZRZYh+Domv7dldX0oYGS8P/JjIK7WYZM+ZUTTeLgkBSd
	qTJZAVC5f2BgHR/DN0XSEOb6YNeyR8g3rJNcc4Wc9g1R6RCrIG3vX0HRhCNvryXWiYQw8gC95h2
	Dbq
X-Google-Smtp-Source: AGHT+IE7I2RsuWr7ACrcIo/YcOorfRXItv6vzpyfkWjxvDo8+MpUCPgiOvD2ujpz6C5lE5yFDfyT+2V44Fq491k/Ua8=
X-Received: by 2002:a17:90a:d407:b0:311:ea13:2e63 with SMTP id
 98e67ed59e1d1-31c4f4b80d9mr24131029a91.13.1752574538681; Tue, 15 Jul 2025
 03:15:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-24-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250709033242.267892-24-Neeraj.Upadhyay@amd.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Tue, 15 Jul 2025 18:15:02 +0800
X-Gm-Features: Ac12FXym7esCXmJPA4HP1g76dzCFL3wPHLvHrMA1R7G8B6a2u6tTXTiZbEuawcY
Message-ID: <CAMvTesCYoLfdpBG_w+LD1uFgVK7+iqZPs0UJj-kYf3EkVkWozA@mail.gmail.com>
Subject: Re: [RFC PATCH v8 23/35] x86/apic: Add update_vector() callback for
 Secure AVIC
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com, 
	kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com, 
	naveen.rao@amd.com, kai.huang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 9, 2025 at 11:44=E2=80=AFAM Neeraj Upadhyay <Neeraj.Upadhyay@am=
d.com> wrote:
>
> Add update_vector() callback to set/clear ALLOWED_IRR field in
> a vCPU's APIC backing page for vectors which are emulated by the
> hypervisor.
>
> The ALLOWED_IRR field indicates the interrupt vectors which the
> guest allows the hypervisor to inject (typically for emulated devices).
> Interrupt vectors used exclusively by the guest itself and the vectors
> which are not emulated by the hypervisor, such as IPI vectors, should
> not be set by the guest in the ALLOWED_IRR fields.
>
> As clearing/setting state of a vector will also be used in subsequent
> commits for other APIC regs (such as APIC_IRR update for sending IPI),
> add a common update_vector() in Secure AVIC driver.
>
> Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v7:
>  - No change.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>
--=20
Thanks
Tianyu Lan

