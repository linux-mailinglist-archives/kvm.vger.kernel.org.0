Return-Path: <kvm+bounces-21522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0106992FD70
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:24:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31EA81C237D3
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8939173336;
	Fri, 12 Jul 2024 15:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YBxNIVFQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914F9171E55
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720797842; cv=none; b=p9yguMrZJ5eDGAUHSMzpDnMGf1i3QQ8KajoPAZd0ULmYC+JtGXwC1NXClGD6RN/aBsKZ1WclNqSHDi1r/nEt2jw1UcIK+Y04pHEKOJP+Z+koS/f5DUb5XD/9EdDb1mV1d4zEoD2TejjLaNrbq5FAs2wq8Bb7u5heAJKmFbCvQaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720797842; c=relaxed/simple;
	bh=2EqlVnEcPlUgYU2TK7tDUJK58Mn7vIB+p95JiCF5dq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PUM9unTDJrhfhdL/EkAWQwT2GJ0bksbyfX/fRCsQ8KOg6PY8JxAm6jrWuzUMNLKyijE/Wgcbp9AEPPkJx/mWwkZmUZvmkx1ok3eVSW+V8HIJ7qqUUQmbCsswpBmVriWFQ6jEq7FgBihC/3crB+fi2ADo9x4z8XJnVhBD/IqZqcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YBxNIVFQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720797839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MGzOi0mcN1gpHM6n5xGEHSGZPwc/Apw3EWbMa56Stsw=;
	b=YBxNIVFQhVZAXonlkW0HVLEwXSFyEXXbPbRDwjfWxLsyiBGZSOEHXENazSeWt+WpIf0LPR
	1IpflCznD8Dbso1yEgyZcdhBYrQ7tm1UxN0ZU+2k0pM3NodxO4f0FFwxVzqdSNcmEyudHm
	kittYuW0I269MoZdfv1lIH0j6odfzw8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-btFSwhH-OQCqTjordjktRw-1; Fri, 12 Jul 2024 11:23:58 -0400
X-MC-Unique: btFSwhH-OQCqTjordjktRw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-367f95ed73aso1245602f8f.3
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:23:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720797837; x=1721402637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MGzOi0mcN1gpHM6n5xGEHSGZPwc/Apw3EWbMa56Stsw=;
        b=qtJZZ7+bEX/05pJS4zEv54e9VwPtDAfGaRqyvTeyyNsk5cvpPuoTVvEeuwhgu+/CEf
         4zGoZgExJfrOKPIZfKFdqOr1BI3CH1Hgh/6JisuMISTQek+GK6hxFPojT5M9X+Lp0QS5
         DhMsmgd1aOE3UJHMRFohX6WN0qik5eJe1v4jyJuIxjvbD3t9LoYQYRBtdqOtLNCiq+y7
         TRUwV8YhCtnDbf5MYhxCvnmUU56f/d0QLKRFkEXtYLQbVmLKEGZw6P4sGzQMuN2Qj44J
         sVujEyU8vtPkt2esaVYFVW5XvWTxQd+N3alSFx3dO0nIoy9QAAaU8PQo3L3vvRWNVXIj
         DfEg==
X-Gm-Message-State: AOJu0YxDJ45OksODKSqM8M1H6f5BNUefPpF1xzfiAaN16a76msCffAGS
	JQ803Ma8rsT+QSZoAIrqmtzeeaNzyRjAUfVM2H3UZADf5jYYiHC+7QJFVFqqmrSkIEM1QDCCdvE
	uOgYAY/mXpuK8ugi/eBB2zdCFvnQ7VEVkAIa1Y8pVaRBPVHexKWyDrBFzJR4uJpbIllkBpcG+OI
	eAR17Nyoha3U16LBYwDeDJNgNu
X-Received: by 2002:a5d:4ec3:0:b0:367:94e7:9591 with SMTP id ffacd0b85a97d-367cea9643bmr7473290f8f.36.1720797836989;
        Fri, 12 Jul 2024 08:23:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWWWA6ULb295t40qJUfl0BIxfNmBzQZfn3oLBjJX3wQ37ZJrJcc4UwCuC4zX3texJ5JVV8/INj0bhDsdt57cc=
X-Received: by 2002:a5d:4ec3:0:b0:367:94e7:9591 with SMTP id
 ffacd0b85a97d-367cea9643bmr7473274f8f.36.1720797836621; Fri, 12 Jul 2024
 08:23:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240711110654.40152-1-frankja@linux.ibm.com>
In-Reply-To: <20240711110654.40152-1-frankja@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 12 Jul 2024 17:23:44 +0200
Message-ID: <CABgObfZzVwpewT88=dPRL4vp7v+HR79dd8=L96ht0HPxvzKkyQ@mail.gmail.com>
Subject: Re: [GIT PULL 0/3] KVM: s390x: changes for v6.11
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, david@redhat.com, borntraeger@linux.ibm.com, 
	cohuck@redhat.com, linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 11, 2024 at 1:08=E2=80=AFPM Janosch Frank <frankja@linux.ibm.co=
m> wrote:
>
> A couple of minor changes/fixes for 6.11 which aren't time critical.
>
> Christoph's ucontrol selftests are on the list but might need another
> round or two so they are not included but will be in 6.12.
>
> Please pull:
>
> The following changes since commit c3f38fa61af77b49866b006939479069cd4511=
73:
>
>   Linux 6.10-rc2 (2024-06-02 15:44:56 -0700)

> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/=
kvm-s390-next-6.11-1
>
> for you to fetch changes up to 7816e58967d0e6cadce05c8540b47ed027dc2499:
>
>   kvm: s390: Reject memory region operations for ucontrol VMs (2024-07-04=
 09:07:24 +0200)
>
> ----------------------------------------------------------------
> Assortment of tiny fixes which are not time critical:
>  - Rejecting memory region operations for ucontrol mode VMs
>  - Rewind the PSW on host intercepts for VSIE
>  - Remove unneeded include
> --------------------------------------

Done, thanks.

Paolo


