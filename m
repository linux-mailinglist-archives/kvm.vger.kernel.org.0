Return-Path: <kvm+bounces-43670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1975AA93BA8
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 19:07:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CD373B965C
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 17:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5121F21ABAB;
	Fri, 18 Apr 2025 17:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rvbcqjq3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E490921480A
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 17:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744996022; cv=none; b=QGEElQZUknShuhMeKnrZjy4KrpJjlZmEEB09u874NVea9lHyUwrWxLnDUS7smoMWiQHC8r+M2KCqBxeBe+Rum+AbXIpREnhTWIa5O+9UnOBIX0asFbMYnxrCp4HiBmo4W2FC3fqpCRu7VS6JDUY9D04ngVVZv1Lrhe7I2lTeR3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744996022; c=relaxed/simple;
	bh=dY93s5xlNPJis5maikqoc3nvWotI3/prHpevh2OqyGA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UGzmiQTsJunQ8tmyQSDQd1IVNdpKPpoyIuBcsdaXSg3EqPc2RvcQwYWZ1IHzWauCZd4OdsXWtblqrEIqD7jsZm1FrAr9CMsFs0FwmoHrdxEIk31KblRgYHHIUUvBp+prsNEBXfy+i/XOLOw1e7wb0EUQAygdob2aWoMcqxildLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rvbcqjq3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744996019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JCApZ9bDM0mTQF/sV1g+0OzRggEcnamk2IjV7dXhr3g=;
	b=Rvbcqjq38b/HZ/N5lRPUgRAqwUUzgMVIIoc0TBg3luO9/6JmAp9oWbXWfpEc6zxpkxBEZc
	JWJthfGPXsVbIWkIHDqu3BW7GnK//J5NsJd41BkXbCYGpXOWSv0l8HAC+tV4fms9x+ax0K
	c7Hgk9EStHgoAtUJqIztDIV7tm3sIqg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-YoM---slN4yEEFW_6vbw0w-1; Fri, 18 Apr 2025 13:06:54 -0400
X-MC-Unique: YoM---slN4yEEFW_6vbw0w-1
X-Mimecast-MFC-AGG-ID: YoM---slN4yEEFW_6vbw0w_1744996014
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-391492acb59so1025875f8f.3
        for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 10:06:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744996013; x=1745600813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JCApZ9bDM0mTQF/sV1g+0OzRggEcnamk2IjV7dXhr3g=;
        b=Du64K/X0FwEbaBrWNuYiaStIcuR6qJSa41O/OLrAGoR7sn8wiGWhs+1vLWR4voVpBa
         z52SmRh//M2jM4yZnDvUinfnqbwF0CqIDnnzZKl7c/dbJgKJruddZi9hozHoiJOoBYWf
         qVqRe8NIijWiFlvm3YMncJCk+slOKJ/GaglEpWAAUOWcKfJ4XtyrTJfGqp9KtrnVBH1C
         kwDVzl0v5zZoRrIlusomGCUQ/x352eOiQRF4BB5oKLf3TH4WrJuhLND0OPxT8NmimtZL
         ZrrN58Bl5JJs8LxP3UPY2bhNMRgD7shG/YnlueKUNMXxaccqZXFItb32NePsbDA+r2Cl
         ycgA==
X-Forwarded-Encrypted: i=1; AJvYcCUPNDq3KmVuW97oJ9vENBVfAr8LFjmt991+rdVj9svvOIbJvn6XiZWsAd3NwnCclKe9SvU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFj9VNq/1ZnGDeKOMkDVYDP+2MPTyDv7ep8nsPqh/Yp+WY/XH1
	5g/hD2sxAYvb5bUBsfIZXf1c1n3WWla9pm3s/Jb2t4VGw1aNBLsp+6vReGn0Wr26FtDit/MJDgn
	VGrQQkz/Rt02dvx1osSqa2dtY6zBJz19f0rBKRSqz5rt4zSEP7QJEdbnIKX/4q9Oeg7UEZwpHnb
	zZkgnZDd50nrdAFYHFHKyw2H2R
X-Gm-Gg: ASbGncuRfJlGmpfqJv9AI4rir/L1fOz4D+6hq1Nr1OM+lCjRx1866xMxeSuyPf22HsX
	eHtFUTwXN/j6rd2S65EJx8Cnsdhh/claQ3EroyjChsqo4mqs2iuM9Vo/1JapdBU5mFeT5dQ==
X-Received: by 2002:a05:6000:40ce:b0:39a:ca05:54a9 with SMTP id ffacd0b85a97d-39efba5ee50mr2302151f8f.29.1744996013544;
        Fri, 18 Apr 2025 10:06:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGz7x52atyEeVRvyvfCStT64ya5TFPH2PFvDYUxHSgzy1LeCF8OUTI2yLx0txV76x4MJr2Vvi2ZGwH65zGFr4E=
X-Received: by 2002:a05:6000:40ce:b0:39a:ca05:54a9 with SMTP id
 ffacd0b85a97d-39efba5ee50mr2302126f8f.29.1744996013217; Fri, 18 Apr 2025
 10:06:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250418130644.227320-1-pbonzini@redhat.com> <CAHk-=wg8VBjy=yrDUmFnvBKdo6eKNab6C=+FNjNZhX=z25QBpw@mail.gmail.com>
In-Reply-To: <CAHk-=wg8VBjy=yrDUmFnvBKdo6eKNab6C=+FNjNZhX=z25QBpw@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 18 Apr 2025 19:06:41 +0200
X-Gm-Features: ATxdqUE9eY3BP55w8JgLHlUqGeE4CFznuzmzKqca_g7BChXFjnTJn76AcUaASFY
Message-ID: <CABgObfYzbWspmaEsvSZYkBr1UQ7C5rD0NQ+=UsnSU3OG5tkcDQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.15-rc3
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 18, 2025 at 6:13=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, 18 Apr 2025 at 06:06, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >   https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
>
> I pulled this, but then I unpulled it, because this doesn't work for
> me AT ALL. I get
>
>    ERROR: modpost: "kvm_arch_has_irq_bypass" [arch/x86/kvm/kvm-amd.ko]
> undefined!
>
> when building it. I assume it's due to the change in commit
> 73e0c567c24a ("KVM: SVM: Don't update IRTEs if APICv/AVIC is
> disabled") but didn't check any closer.

Yep.

> I think it's literally just because that symbol isn't exported, but I
> also suspect that the *right* fix is to make that function be an
> inline function that doesn't *need* to be exported.

Yes, that's possible since enable_apicv is already exported. Sorry for
the screwup.

Paolo


