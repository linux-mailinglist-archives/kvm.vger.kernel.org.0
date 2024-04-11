Return-Path: <kvm+bounces-14252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E6F8A156D
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 15:22:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7B9C284931
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 13:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B80414D430;
	Thu, 11 Apr 2024 13:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dIJkG7pQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD40640C09
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 13:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712841751; cv=none; b=OjusLzCHouiG3HTwNsN5nYD5OAoD/pdbO0Tsx7OHt+3YxySiE28F3rxdv99yg/PGsphpsVKF4S4kTV3giomMbz5NuVv1KzqNrIS6xLGR9ud67sTZFqos0pcb2mMNDu14iTuA376BaCD6OcgjegaPoF0uXa3TCaOwiGrsJZGXr94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712841751; c=relaxed/simple;
	bh=U9U4DrMa8C0Tg6a+6toTBCCdpB+9LfQnli9OY5KSfHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TqsXZMUVO6H837pLH+RFOGFC4ec/76fMcgz9YiJIkJqOmzqlRD58L1KMu1NnT5bHWHEY/OKUUzQAJ2bLjDSMAwpi9Vv2Bm2W4srp3Bg/AF7dMsHYUPDpBT+nIXjjvYGESSL5rrXf2lJUbIL5lUb2yHlavTmLFwTbqimPIuy4zgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dIJkG7pQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712841748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U9U4DrMa8C0Tg6a+6toTBCCdpB+9LfQnli9OY5KSfHk=;
	b=dIJkG7pQGejLEmPwY+1h6hUfOKRk0dGuM0pnd3oqD1WBmI/K/zO0ImY07Z9WeZyfF//gYB
	n93WY8jG32M9uEgSle+JsN7yO5svdy5SEX7l/x61iyyodoPc1bTmcMdMPy5oCp3kjznAYc
	DdSwyvtALmCY93zVEABxnSccIqJBGGM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-nlG0FUIpPdeG6L7hAOF9XA-1; Thu, 11 Apr 2024 09:22:26 -0400
X-MC-Unique: nlG0FUIpPdeG6L7hAOF9XA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-417ee376987so38595e9.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 06:22:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712841745; x=1713446545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U9U4DrMa8C0Tg6a+6toTBCCdpB+9LfQnli9OY5KSfHk=;
        b=aGHtI8DufBmxV7zNQXZhsngZhWYIjAn/rmwqyy7mn7CFYlrtSrFJm3zhLI7Um+rvGy
         En0pDdb6Uchwb6mq+Ns7us1wAAKOmJqb7rM246gnRoXlidiJfqV0Eb2JKrRv2RuVo+pC
         MZxyd586EojTVwp6DDTmyDvKFicfZp1SL0ry7g1gStSGs+58Qld5MBldIpTZgsVHUQa9
         X8X2zpvjltIRX7aZpinBNZL3OAoEZaBHNNXPByAOXhekcdLymPYqt4xxy484G5oyzkKD
         3n3EtC7vAhAaRvoFjmeXpFrgtMJSJAAOpyvKweiyQgqpLnPVk8OTxZ7hex1xKE5Sws/R
         6g7g==
X-Forwarded-Encrypted: i=1; AJvYcCWshvDno3SsfnB3oI26h7wRMTyMtBV6PXdGEwwKgL2dIOX7OxpLm569MTpXVTfS3nH0eC0GwjXVhIxOX9dbSFanUmEV
X-Gm-Message-State: AOJu0YysiCa0dMTcaEwQh25hMs8i0f0klydpitMcvpQQY9H0fOMUNgVj
	MYZIe2EeX31mywKylRV5z1DWV6RkFZn9E+wsNwYJy4lwPbFhClshAm/rvx4vcQE/jOVhmVo3shw
	ZNhPb3tMAuBf0DWsFZwLdMkERZ+3Ygjd5B5E8wL/EoOwRVIyVe+RM9T6V1mX1EQirD5iu/QGPf2
	RDdUWVs6oEMB9XloDJE+LOn8qD
X-Received: by 2002:a05:600c:3c89:b0:414:9676:4573 with SMTP id bg9-20020a05600c3c8900b0041496764573mr3428917wmb.36.1712841745436;
        Thu, 11 Apr 2024 06:22:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOqpae7e7YHtDrPKdTbcCevuUXTBRFS+swIe7b3hMN/ct9nTKRbjdAZ5D1U4nS1cq29M1FDblW8ISPSai+0+w=
X-Received: by 2002:a05:600c:3c89:b0:414:9676:4573 with SMTP id
 bg9-20020a05600c3c8900b0041496764573mr3428899wmb.36.1712841745063; Thu, 11
 Apr 2024 06:22:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com> <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
In-Reply-To: <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 11 Apr 2024 15:22:12 +0200
Message-ID: <CABgObfai1TCs6pNAP4i0x99qAjXTczJ4uLHiivNV7QGoah1pVg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
To: Alexandre Chartre <alexandre.chartre@oracle.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com, 
	pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de, konrad.wilk@oracle.com, 
	peterz@infradead.org, gregkh@linuxfoundation.org, seanjc@google.com, 
	dave.hansen@linux.intel.com, nik.borisov@suse.com, kpsingh@kernel.org, 
	longman@redhat.com, bp@alien8.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024 at 11:34=E2=80=AFAM Alexandre Chartre
<alexandre.chartre@oracle.com> wrote:
>
> So you mean we can't set ARCH_CAP_BHI_NO for the guest because we don't k=
now
> if the guest will run the (other) existing mitigations which are believed=
 to
> suffice to mitigate BHI?
>
> The problem is that we can end up with a guest running extra BHI mitigati=
ons
> while this is not needed. Could we inform the guest that eIBRS is not ava=
ilable
> on the system so a Linux guest doesn't run with extra BHI mitigations?

The (Linux or otherwise) guest will make its own determinations as to
whether BHI mitigations are necessary. If the guest uses eIBRS, it
will run with mitigations. If you hide bit 1 of
MSR_IA32_ARCH_CAPABILITIES from the guest, it may decide to disable
it. But if the guest decides to use eIBRS, I think it should use
mitigations even if the host doesn't.

It's a different story if the host isn't susceptible altogether. The
ARCH_CAP_BHI_NO bit *can* be set if the processor doesn't have the bug
at all, which would be true if cpu_matches(cpu_vuln_whitelist,
NO_BHI). I would apply a patch to do that.

Paolo


