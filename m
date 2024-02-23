Return-Path: <kvm+bounces-9529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC0B28615DD
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 16:32:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 435E31F256E9
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 15:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72DEC82897;
	Fri, 23 Feb 2024 15:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wdja1/in"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F1F81AC6
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 15:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708702334; cv=none; b=bFytEaVw1ibbwcRslt/0iLXVPJbouvtDZlpoJ6nwj7LQCu2v652eVvLfYIg7uP+LI0WkuGXJpommIBMes9myzXHt0X05EEyb7llUKPV72/Ix7G7fm9UDaEk9WkXTBWq7IfONy7e/rCyR6W4K/mGsbNS47tX5QK1SMsqiH+Jy+xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708702334; c=relaxed/simple;
	bh=ltXfiFuoTEtZlQ375zaRTODYeS+HobqFtlM+RXnHddQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AIJk7XtaC5NeXdZw9wBvGgZfKQo1jcfMNJJZBbUx7YdMWkZgrqa/5h1Cw0o0+pUadMaPPMRsfgB1v7wR40C8dI8l353ueBGUVSglptRMGVCzcCJ5X1UhO42Hug/keSPlApx5cuWUVKXfSe7eCYstBdbtU/Wb5DKCZ1dqvWm6C9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wdja1/in; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708702331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ltXfiFuoTEtZlQ375zaRTODYeS+HobqFtlM+RXnHddQ=;
	b=Wdja1/inM4QaLMLmP/B8dNsQKBEkCFbfIWl+djAp2J7Y9fhTJ+sbwnBm964VGBfy+rEcLs
	AYr4dpXO9YVqwMq/hH5oHr+Pdk/PA2jUWhy4RMnEZpDgU09rQH3vHMIg+R6oy93fA8I1A+
	jRKuPd62a3iZzW1ERDl7XiN24ICYHF8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-r5AyQHCRMOysG55kobEtYw-1; Fri, 23 Feb 2024 10:32:08 -0500
X-MC-Unique: r5AyQHCRMOysG55kobEtYw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-33d9fe87c4aso473720f8f.1
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 07:32:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708702327; x=1709307127;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ltXfiFuoTEtZlQ375zaRTODYeS+HobqFtlM+RXnHddQ=;
        b=wUFPGEOq8LGE2q3zSmbJ/8mToNVQthJKvYWwQgEA+e5smZh7bkCPq0CkKVUsF4aAVu
         MENZnTNPWfKUPEiS5RHCl0cq9k5NJkYe94u7VbmXW6gwMTF0EBwD8Mv0OlbBvntSrSOb
         1H2L14tFEO+LURSd2q1MI4IbZoPlPi+9cxC+y7zhe77Pbl1P+tXf81D3LlXqMSUKsFVw
         /Nbh/yLtsYODtoMb6RPXFI21ISu79MoJK5Duml3E0Z2LhMJ2UC//Jwzygalyc5ZjnUbK
         m0bD73w042YPO0J0CBiyAdIl2bJf32XV1yu87JdK0EiHXNhhyenXhYYP3gW8DWr7iVNP
         Wi2A==
X-Gm-Message-State: AOJu0YzfL02wTLhAbwYbCXuxPN77tiLmxWCgWdH5+zkuvRPbtDzHRsai
	6TCF9+wKSiVCuKLtXGiANsYztaZtTzDQQydtXWTqiLNGoiyp9d2LpyJveVR/o+ijCsHDiIzrcbu
	/815r5xiN6Y+gp+qwWC4lWMQ5zzB2TUQt1KzMcbsmDLpw6LYmKwPqrWTQxGpqwJsHc8oHwL4798
	1H1THBKrVY/TN3TY9nEyaSxWm0
X-Received: by 2002:adf:e511:0:b0:33d:5ae5:f356 with SMTP id j17-20020adfe511000000b0033d5ae5f356mr94657wrm.20.1708702327598;
        Fri, 23 Feb 2024 07:32:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGLm2G66Tw4sgodVUIb9Jzv+TjNHaof3FgriahBQfesSvJsXof4hqEVZ82kEIdVUXv/1jq4kYYkRea+6qJNwbM=
X-Received: by 2002:adf:e511:0:b0:33d:5ae5:f356 with SMTP id
 j17-20020adfe511000000b0033d5ae5f356mr94647wrm.20.1708702327323; Fri, 23 Feb
 2024 07:32:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240216155941.2029458-1-oliver.upton@linux.dev>
In-Reply-To: <20240216155941.2029458-1-oliver.upton@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 23 Feb 2024 16:31:55 +0100
Message-ID: <CABgObfYZBnTjXh4TqH77HjO3zTMRfekaorTUVqQoFOMPJLjJTg@mail.gmail.com>
Subject: Re: [PATCH] KVM: Get rid of return value from kvm_arch_create_vm_debugfs()
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com, 
	Sean Christopherson <seanjc@google.com>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 16, 2024 at 5:00=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> The general expectation with debugfs is that any initialization failure
> is nonfatal. Nevertheless, kvm_arch_create_vm_debugfs() allows
> implementations to return an error and kvm_create_vm_debugfs() allows
> that to fail VM creation.
>
> Change to a void return to discourage architectures from making debugfs
> failures fatal for the VM. Seems like everyone already had the right
> idea, as all implementations already return 0 unconditionally.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Feel free to place it in kvm-arm.

Paolo


