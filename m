Return-Path: <kvm+bounces-47140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB169ABDD98
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 16:44:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76453189F59B
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 14:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC57424FC09;
	Tue, 20 May 2025 14:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cG7WNI3Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F3124E4DD
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 14:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747752159; cv=none; b=tEl9KqzuPszwqL7rfbXDc8zBIolFdNHtGcfHsQWi8SY0VW3/87Jur3n25WqPWUFGQyKygJbZL02OX3CyHgUv6kyvNR14l/PFaX1dSGnODg6n/0SMXC6OvcWvgVAF2Ie+WVE/mg/K4lb1Kly7aseMg8smu8j7iFq3BqqFUurj4nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747752159; c=relaxed/simple;
	bh=Gra0+MZowr3WZSCCQG6L5yEo0PIjNdYOZUPW9byFFZg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ng7gq+8cQuGE/v7GQqMFrRJhmqeFOyLdrEIncFMtwIumgxwCKugIZd5kL0ILWglf0WwE/Z5k+/DpN5RKkBTLXvD2eaMKYvVzfyIcvBbP4glviHv5ci1AgcTwRdwGfOLDqeT+gUTP6Ryp2m80carpWnf3KVIWvXa0g/lstTOBFOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cG7WNI3Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747752156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gra0+MZowr3WZSCCQG6L5yEo0PIjNdYOZUPW9byFFZg=;
	b=cG7WNI3Y3msqUAN7tL0at96f9HALXnZL3rPaZLa1nr1dT5f1uW2/0iryk/vGA96s0uZgQl
	W28t9zH9s5attpAcn1QemD3uHH2G8pfvZ6X04F9iFvgE/5Aay1rWWQH6QemFFalVdTZfuJ
	pEdObydbdCjBJ6U0kNDhU/rnhd1gw4U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-eBb8QrQkPKWv8bDvGZerOw-1; Tue, 20 May 2025 10:42:34 -0400
X-MC-Unique: eBb8QrQkPKWv8bDvGZerOw-1
X-Mimecast-MFC-AGG-ID: eBb8QrQkPKWv8bDvGZerOw_1747752154
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a3696a0d3aso1209406f8f.2
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 07:42:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747752152; x=1748356952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gra0+MZowr3WZSCCQG6L5yEo0PIjNdYOZUPW9byFFZg=;
        b=A6LY4quTk+pC8p7G5PH1eVD/Prda+kwhonSoWxTHTq1mQW9Z4jXmEimSv+BRp4lsQ/
         XhV1UtGaoUNuCDWgfAOeS4QXnZiqVqi/N9Oi7K+szUT263LV91GMJooyQxPZEapVzupH
         NHnN6sHP1qbWENjOS6C8F5tBoJAWN6je6rCha9/tF/gALxtJ+dvnaI17A5m90mlxv5Ci
         nUjSKph6lHeILgBT2WD4O2rq64bxjkUJMetdmSqLvtZnnpOhkjemcOWhpqOIePML9ZpA
         ioEDS/YJrFXRPF49hi0v0ripqb40HewWaJbHyD8jpNWVRYOhkimv22u1o6AWGJZNo9sM
         8wow==
X-Gm-Message-State: AOJu0YxY7ltNRXnxXDaOlu6nz4PNcY7sC6wSsB+C4Azn2RFela6jFq0f
	p1Omv1dX7YjUG00pc+d4yYCiDYcxxcccN0onva1mhXViYObAo6kOnzBzsUz4OcGaQLutZ2C5f3U
	aOloQ2bxEbqeWYkwao1XrE/PpXGspBNJ7KzdC2MbG/ZrmjrnLCJfgIOvNXLwQoMmVkBZdOH29cP
	QmyNXfTu0nXyGO3fnUvDXCyuCiAXHZz/0Zi9eM
X-Gm-Gg: ASbGnctMULP1JZquOiyWI4vMSgnxSpQQFIZ4EHQ8y/vYC5n2INejvnatFOc19rTpNI1
	r/csz+ZX3BylBlhiAc4fIHhTA5OAvziEOmM8HwXORvx7DOzhsbPNNxkbuYRfqtzxzzFI=
X-Received: by 2002:a5d:5c84:0:b0:3a3:7be3:cb92 with SMTP id ffacd0b85a97d-3a37be3cf2bmr1974446f8f.42.1747752152315;
        Tue, 20 May 2025 07:42:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNv6K3sS3FxTY6B0e3vzMwLrSUH4VeGRW7bxwLfDlRShdcMikfXMU3cfUseGSYV/4VsF8bZnz6jBIqfwQl5Eo=
X-Received: by 2002:a5d:5c84:0:b0:3a3:7be3:cb92 with SMTP id
 ffacd0b85a97d-3a37be3cf2bmr1974427f8f.42.1747752152007; Tue, 20 May 2025
 07:42:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250516215422.2550669-1-seanjc@google.com> <20250516215422.2550669-3-seanjc@google.com>
 <219b6bd5-9afe-4d1c-aaab-03e5c580ce5c@redhat.com> <aCtQlanun-Kaq4NY@google.com>
In-Reply-To: <aCtQlanun-Kaq4NY@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 20 May 2025 16:42:20 +0200
X-Gm-Features: AX0GCFsdS-BiZSQg4j0UJ0s2A9xwkhZmjTwQusqPP4S_x2ekzeOBO7nXoZ6HrtA
Message-ID: <CABgObfb7Q_ya+OEPz9VVgFF2A6=x2pBqkPj0=QaJmkrRGpd=6Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] KVM: x86: Use kvzalloc() to allocate VM struct
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2025 at 5:39=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> I'll slot the below in, unless you've got a better idea.

Nope, that's a good idea. Should have thought about it a couple months ago.

Paolo


