Return-Path: <kvm+bounces-66277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 953D6CCD169
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 19:07:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CAB6D3050407
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 18:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58AB7309DC0;
	Thu, 18 Dec 2025 17:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dYd576Mq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VxljDisO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F982F1FFA
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 17:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766080624; cv=none; b=TcGsbu7x6151se58mlOAjH1S57xSRAlnXG2G1splUYodwynfEJPhL7qh7TO4KgeHSYI/VXshDEr3xoBlKvgefjNSWdckMYESF9mOW4CsE+DKl7iwoe1G4wX/X0Xc0/eZ9rhkhRTPPHqUc2SCoh17HSxNt/7foW+Ln3MYfJlfBqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766080624; c=relaxed/simple;
	bh=MiLmbwESC6H7lBWNg7PikrKOKerqb2xLT60f6wh87W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bh1+7kl7dY2OFCmNZISzXpemxaFX5ZRpUDRc6DXYQzwrwS19hFlfhP+u8uj9Os1OjhhJ5+D+iHA1hIc0ScJXakij4GU+0eQHiZU6nT3MUOIsN1T5xnA/eyL7zRXWJPqbikjQLfIuqZSNYgRfk4HORdN17ZmPnmEvgNSNZypoPes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dYd576Mq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VxljDisO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766080621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MiLmbwESC6H7lBWNg7PikrKOKerqb2xLT60f6wh87W8=;
	b=dYd576MqhxkzhMaP0rEckl0tXHOb9CkmXKy8Qon8AyBcfL/oIUEcGKyrjIlX58mjSI5bqM
	mMQiKgPEo8SIWeJ2QsUCjEcUSL90vY2WWJoSmX1CCIO9Fk/9d0ITtLVbMhbyvFhDJ3KUKY
	TZmeX5M7wJcal4ley1qlAntoFN8oqTg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-8nhvazqLM0OgXPAXO_Ypxw-1; Thu, 18 Dec 2025 12:57:00 -0500
X-MC-Unique: 8nhvazqLM0OgXPAXO_Ypxw-1
X-Mimecast-MFC-AGG-ID: 8nhvazqLM0OgXPAXO_Ypxw_1766080619
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-64b45c2c84bso1055606a12.0
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 09:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766080619; x=1766685419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MiLmbwESC6H7lBWNg7PikrKOKerqb2xLT60f6wh87W8=;
        b=VxljDisOtefO/nFvCKjapO4heB4OunpyeylTFvw2WM+P7+HIXq/IjkvBq9sQNq3y+H
         IvkO5zc5gH9sXLB6/4jDkZNp25JQMssaeQFf2ZN0FwhUWsrM7vTr0+TeC5jDVhfwIRH5
         nRy4TD7umwNteiwwpKsCfBXQfxC4SPtzyVFBTB54C9xWQJPLjCyjYMZY9bennkhy7o5X
         yYP/MWbIjDcAFseTfl8uHncd5a+4AGmxgL94cavq7dgCvDMpeq4aHEFA3C7wFkTYkePa
         seVJyn71/SfA4Eedy/XUb3K8AlKNSvr+y2qxsiEpYobNncuPtDi9EHTQe08IuFygzxOF
         VfTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766080619; x=1766685419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MiLmbwESC6H7lBWNg7PikrKOKerqb2xLT60f6wh87W8=;
        b=WI9PzfWldjYHH9XR8hAxKf9P7KxsrCz2uhphfPasGW3pkaaq8fQ2TLV2u5WoSpmZQ7
         tWHzSM0UltQn8a02O6nMfnzVvEq3O2S82P/CVb0pJeQKbaiw57Bpl4P6/KJRfiu8xiV8
         KaChEkWJs13V8E23jqfoaBYyjF1tD3foMTwn5PExXjelksTMR596CclCrRCJmbXdWxQU
         R5Pj2Nzjy+gdHFkjSdwOxaDZOVkSx+W0HEVMqeloUK699x5HoHd2VuUxJMCKrZu6jsSL
         HGhjJSTbLUJ+lY9J0WXAW29FHf+BY1/CggSCnUTwIdy4KdsVc3DuGTmzkUezdL8gJ1L4
         Aisw==
X-Forwarded-Encrypted: i=1; AJvYcCUTVWd+CcN+WRj54N+c00RLQj6B/mSO8TH4VkSE9yHxUIhp+lvZaEdmU+y/NhzPDOkKaIY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXs33gLQ3LeZx6bsklhFF+UR+KME7N7kgdhpCSiqBZ4uUKgwlo
	rncn3RwjzvD8qpi3cCE7apVh0lZ+EZ2XXHCv4lrwBE5nY5Rf3J+bsIP2jVyrn6Q0fMuBLOrLPIw
	YddKfYMZ4+OkP0Uu0scBjHf9+6nR61VD/Vmu1AZlM2zHNVRnu/Z9BEA==
X-Gm-Gg: AY/fxX46KB8ooCquoFwQbl151dhJFSQnJj7Fe7+lSb4FNKo45Myb/iBKtpGhBpvjhZb
	DJK6K8yO6pMAFqko6PCWfxgORBtx3cVuZE3RPq8T81IdO3C9UdMPBXvpICq071/RJlTv9dK9oRa
	tYTPFhL+SPNcvO1nD3Z8AXav1PRWifBYm3SsrTpWTZ+3n2Dn0/9kGirbfCDCVS669AdhnMxw3Eu
	D6SbhDsx7OZtzM+2TWHqLapBBG9bi0hEup9V97hCQaWnp6PRBElAXAcSwD0c3leOsUVCrAOJMBN
	cn09XRWLqwf8TaA6a9oxe0GxbAHbgq06SIV20Qfiaqg+03gvjAf8XlEsgZEcfuviPpvx9A6L1q/
	3Kp6tGgBnzmb3WsHFWAniSVwno7k/pYx8CJvUudlvoZZYHYAXy4JaRY1se1RdA3vn2qPn8BWxsV
	OoDW/Fnzsmsoc=
X-Received: by 2002:a05:6402:510d:b0:64b:8e3a:603e with SMTP id 4fb4d7f45d1cf-64b8eb636e4mr231930a12.4.1766080618862;
        Thu, 18 Dec 2025 09:56:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEbJrP2bsDMIITgDGOs6fj+wiRDU0I4JE+3yRSzb3U9uoPVNENaUAKPb6Tp2A4AN+QZ0Vdetw==
X-Received: by 2002:a05:6402:510d:b0:64b:8e3a:603e with SMTP id 4fb4d7f45d1cf-64b8eb636e4mr231906a12.4.1766080618476;
        Thu, 18 Dec 2025 09:56:58 -0800 (PST)
Received: from [192.168.1.84] ([93.56.161.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b91599721sm18202a12.26.2025.12.18.09.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 09:56:57 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH 0/4] KVM: x86: Advertise new instruction CPUIDs for Intel Diamond Rapids
Date: Thu, 18 Dec 2025 18:54:31 +0100
Message-ID: <20251218175430.894381-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251120050720.931449-1-zhao1.liu@intel.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This series advertises new instruction CPUIDs to userspace, which are
> supported by Intel Diamond Rapids platform.
>
> I've attached the spec link for each (family of) instruction in each
> patch. Since the instructions included in this series don't require
> additional enabling work, pass them through to guests directly.
>
> This series is based on the master branch at the commit 23cb64fb7625
> ("Merge tag 'soc-fixes-6.18-3' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc").

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

I think these can wait for the next merge window since the corresponding
QEMU code will be released around the same time as 6.20.

Paolo


