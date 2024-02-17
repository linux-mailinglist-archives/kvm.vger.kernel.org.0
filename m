Return-Path: <kvm+bounces-8956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A49858E79
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 10:52:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A3101F22280
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 09:52:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E8ED1EB3A;
	Sat, 17 Feb 2024 09:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TEB/13Sm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619591E864
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 09:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708163547; cv=none; b=bTF5InooxaYwqYlI+Wj01g7n4AWTEhY4VF+pmIy0Anc4I9XDob+f3Tp6c6eWlhIFcvHMJBGuyCaX/poL4Xqag0T/HuxpAXEzAxChCA1PaZz5KccXUxgvzrv4EyQjRIMf0k5pExI+qrnaoac/0Qno4bPWBbfHi0KuhglRNADJhV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708163547; c=relaxed/simple;
	bh=CEpjrVkbt/D7eyxsGXNC7Cbq+WSkmsxFGkAuvlaUy7g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gBgn73SEtthdIs7rnV0GIBKK12cc84sglQf70T35G1p1tZBzqbyoG5zpaaoyBkMjZ6cRln6ED10X8iPfpu5pW3cfIjKrQOub6ufTlElKAYnl47OynBO24CfiYBDDglH/EJebD01+l9pWaiLpL0JvcEVy66jwJfMArj/DJ4v280Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TEB/13Sm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708163541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CEpjrVkbt/D7eyxsGXNC7Cbq+WSkmsxFGkAuvlaUy7g=;
	b=TEB/13SmgVhT+Gp8SZN0IVIhQIUBU8cucNADbTyQfvt3HwcexTcPUtZHAP0eMpsW6sE8Z2
	77OTjqPxvEMxj8aZgZD0XuKngX6P2tbvcBehXnefGbltXoj8t0GjjdjVKNhcSdh6DOppRO
	Woh4KIEnrskWm5fjoC/+qM7pJIgPcIs=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-OcMyuzEuO8OYp1wlPKrFwg-1; Sat, 17 Feb 2024 04:52:19 -0500
X-MC-Unique: OcMyuzEuO8OYp1wlPKrFwg-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2993035cd15so1508776a91.0
        for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 01:52:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708163538; x=1708768338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CEpjrVkbt/D7eyxsGXNC7Cbq+WSkmsxFGkAuvlaUy7g=;
        b=TX/u1KKPteM5ePkoqF7ox9VrJ+z/cHKCBO4OwErF7Ix9RJ0cGxEdu8J/PGbIgH979D
         tpZKcUVu/0BZkarfuJU2dv4uvWOEGuEuocoNSnnzKoH3FEKpDkqYkPe+xld1eTPoThyo
         0SgbnfiN2+4Yj2oTUJH0ml62TElUMGe+a90h6IyJ5ZQQYp5Xh3u7EjXx3fG9PVqlqKyl
         OrM3YkmdbEXGRbssqUCbSz0dqigTn0PVa/hXrb+WebwpV+e3wgz2taeoxSbEyjcy7H04
         5275y0MpWX6FN4q2omyc42f/Az8h3ozCnKhh4mBpfsVb0mFvcKU83LI2yU+NsL6W7ZgF
         AQ3w==
X-Forwarded-Encrypted: i=1; AJvYcCUA1ImlhcUq0Y5Xrceb9w0RwT4jcchPUmmx/HKtgsHetQ1jT6XplLuDClKfNf+yL3S1H6OY/f99inzfwuTiTLMpG8T5
X-Gm-Message-State: AOJu0Yzhl4Mito8DQ5MAS/foLEXCvaGaZOE1Pszpfyie7mmCEQYInQi0
	QHd2D6OAA9ZYocQX8UGMUT0hEJJiHHeBbeqtCOwbBpYwM8NPdWlAfzKmEiTRsJrLHyem6i9wbtx
	HnRtgUrsl3DT6mbTVwsdtinde69Te8Bp5Y6om7AwftOhT3H8/WQYy1rhdHgXcpDedmninQf9XVv
	WiOVJGehqeizLzC7wKyhobQHOQ
X-Received: by 2002:a17:90a:d482:b0:299:4ae4:7a17 with SMTP id s2-20020a17090ad48200b002994ae47a17mr2981677pju.15.1708163538614;
        Sat, 17 Feb 2024 01:52:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFYkfz1b4/wlthb+gBdlWaX30BfmMMKBTPc6rBpHGZjk3hiviXIU+8PW8obFj37j37I04puPccUKO3Yj+QIxP0=
X-Received: by 2002:a17:90a:d482:b0:299:4ae4:7a17 with SMTP id
 s2-20020a17090ad48200b002994ae47a17mr2981665pju.15.1708163538304; Sat, 17 Feb
 2024 01:52:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215133631.136538-1-max.kellermann@ionos.com>
 <Zc5sMmT20kQmjYiq@google.com> <a61b113c-613c-41df-80a5-b061889edfdf@zytor.com>
 <5a332064-0a26-4bb9-8a3e-c99604d2d919@redhat.com> <87ttm8axrq.ffs@tglx>
In-Reply-To: <87ttm8axrq.ffs@tglx>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 17 Feb 2024 10:52:05 +0100
Message-ID: <CABgObfY1GPbOhpvnds7tOD5xLOPO6SAmJULDWpT_Z2OGGR80aw@mail.gmail.com>
Subject: Re: [PATCH] arch/x86/entry_fred: don't set up KVM IRQs if KVM is disabled
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Xin Li <xin@zytor.com>, Sean Christopherson <seanjc@google.com>, 
	Max Kellermann <max.kellermann@ionos.com>, hpa@zytor.com, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 16, 2024 at 10:45=E2=80=AFPM Thomas Gleixner <tglx@linutronix.d=
e> wrote:
>
> On Fri, Feb 16 2024 at 07:31, Paolo Bonzini wrote:
> > On 2/16/24 03:10, Xin Li wrote:
> >
> > It is intentional that KVM-related things are compiled out completely
> > if !IS_ENABLED(CONFIG_KVM), because then it's also not necessary to
> > have
>
> That's a matter of taste. In both cases _ALL_ KVM related things are
> compiled out.
>
> #ifdeffing out the vector numbers is silly to begin with because these
> vector numbers stay assigned to KVM whether KVM is enabled or not.

No problem---it seems that I misunderstood or read too much into the
usage of CONFIG_HAVE_KVM up to 6.8, so I'm happy to follow whatever
FRED support did for thermal vector and the like, and remove the
#ifdef for the vector numbers.

Paolo


