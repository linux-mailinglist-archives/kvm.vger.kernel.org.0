Return-Path: <kvm+bounces-31737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F2E49C6EFB
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 13:24:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CB9F283B93
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 12:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BDE5200BB1;
	Wed, 13 Nov 2024 12:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P1VzgYmX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046C6170A01
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 12:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731500636; cv=none; b=HlFpMAvZsS84Ur4tMDRccLNYR7Pq6cdvl6nYU0VrSIRK98NWB8JLJAyoJQic5Wf9c25cEdn1pblxelURSWtFum3m4nIomHQwdvbqpo3jRCj8Z5q/nBtI1//QMKavEXx3Ls5yStj6Ayf7X7CZPHt9DvkUBKpNGShWwl+8ExjaBTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731500636; c=relaxed/simple;
	bh=691iCJFmioydNSjINt6/WOMgqUtjBh2fMVuZtJDMJVU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K9XwfxXoJd1EJqqaDyAEr7aY3+6Zj9TJ6+LlLhIrGFWEviRyOCdYa53R4kUG1O+dC068K034DByUv97M64nLed7l3DSRjObR5MnsP/5UDEenmWPsfZodJaY35rJ8C7ncX2m2t33BrLxQ1A8iLfAKGDTJqieRcJ9QbV6qoOrBIrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P1VzgYmX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731500634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=691iCJFmioydNSjINt6/WOMgqUtjBh2fMVuZtJDMJVU=;
	b=P1VzgYmX491QCB3Gtgxj2XPUsAhqnPAZh0DndJqKE/E6siBdDT8pUkqS/H8hWi0SNzxZX4
	+Z8SpDFQs9HnMJsWXeBQVDFt+p/VXimPcS7yYhOvtnuB0GdeVL1asqrKmoPAf2mxvSJMcK
	w5tuw8PsqVd2im8iJ0hP8UaRByAB7bs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-Sh981VmXNxCMYXbp8yP54w-1; Wed, 13 Nov 2024 07:23:53 -0500
X-MC-Unique: Sh981VmXNxCMYXbp8yP54w-1
X-Mimecast-MFC-AGG-ID: Sh981VmXNxCMYXbp8yP54w
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4314f023f55so50701025e9.2
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 04:23:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731500631; x=1732105431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=691iCJFmioydNSjINt6/WOMgqUtjBh2fMVuZtJDMJVU=;
        b=Jd8KhJsReXB26NDoRHwmW/Bfl+Fxg+zDdwVCvuTiQB4aRH39LzhujffkED3TEvNyC3
         Ih7BOW7y0cMZsJuaY/WCN+9cQY3LFN0gEPXZXcW+JsrVyF99s1iDcNX3VIVxkWr8VRMy
         3PCj7oLnoElMly4KyDVjOP0YE1byJgQI/Q3buc7iyGaTDBhYKbjqPIKI+GQcjvKbiBtX
         Y26Yz8rSqC++5xwQAKKOS8KeqMtdf0NiTCOdLLfwKfYW3dCrCfWyysxhAqZ1CQNPRfFl
         OlFGkhodL++cdXfqe/CGFOwv162v/sPQ2c4Pc+MSpJ/rtuav0BGyTfyous/kfE691IZ6
         9X/Q==
X-Gm-Message-State: AOJu0YwXAmcqNYoGFzF8FJjtoMIo+4PdWkhuX42NtHvAGKq/8WnNrY04
	i9lmOT09XKaQj6e6AHRCOg35iwjCu0TUlQ5NSpX4gbs8cau3R++E3hV7Nmds0RmiMXaPbYyAzsO
	2CfQ7s/yeimOHlJxT6/MzVPtJJcAcNdWGlhri7Dxgi6p8r9U+HLtoOn44lHqbYfZzQ32ywH/9cF
	QGiVVPXk18stIxVtQ0TD3+z4tMhuZCJJdUU8U=
X-Received: by 2002:a05:600c:5124:b0:431:46fe:4cad with SMTP id 5b1f17b1804b1-432b7501d4emr183269405e9.9.1731500630722;
        Wed, 13 Nov 2024 04:23:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5w1uEWrW9uBfSXpu92W6DLFMUqwO7C+Qk7srcMFftnYjiG5WvPCv2OKiDxCTjbqhYn0ib1u+HRhKyEpTSb7c=
X-Received: by 2002:a05:600c:5124:b0:431:46fe:4cad with SMTP id
 5b1f17b1804b1-432b7501d4emr183269215e9.9.1731500630394; Wed, 13 Nov 2024
 04:23:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241112193335.597514-1-seanjc@google.com>
In-Reply-To: <20241112193335.597514-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 13 Nov 2024 13:23:38 +0100
Message-ID: <CABgObfaE6+uSwipaBUgVtYRh6F7RTyMPNYk=uRq1pTHcnOvMaw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86 changes for 6.13
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks, pulled.

Paolo

On Tue, Nov 12, 2024 at 8:33=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> AFAIK, there are no conflicts or dependencies with other architectures or
> trees.
>


