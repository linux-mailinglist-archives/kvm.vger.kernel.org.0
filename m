Return-Path: <kvm+bounces-5733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 854318258F8
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 18:22:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F7F0285564
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 17:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F43C328A7;
	Fri,  5 Jan 2024 17:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ypf8SLvC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71040328B4
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 17:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-50e67e37661so2191305e87.0
        for <kvm@vger.kernel.org>; Fri, 05 Jan 2024 09:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1704475306; x=1705080106; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fgUg6yXSGJVGxpWb0GfnpK9ZphsLr10eK/u4ICIM5n8=;
        b=Ypf8SLvCV1/RY4qsfVKEK2z/GgWcaw4sHot2NqpfFIViPswT52QgXTgOeN+jQaScGS
         qnINIAjB/t8fVXH9npuSfT3zBwmeA59igznbxJMm5/BMYjnzycCP82HgnM6OqMtDu5on
         KA9Rdt4UJWFvsjPN2sAlO8uFovmcc1GBMuZXA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704475306; x=1705080106;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fgUg6yXSGJVGxpWb0GfnpK9ZphsLr10eK/u4ICIM5n8=;
        b=PK8An4cB6u7k3tvpSk/5auutg66k7nAhNS9GmW572Kjr9b88y8uUxjMTplPGUybLSL
         NLZNOTMDjUbiTNGVqmZoTHAp2wm6T1/UiejTPy7DG3JtNBlPBQ/8Rhs2W4xXNh+LqWkR
         cT+fnB/RakhB5tKzTViJ4CgBnINvrYi+AfylMzUtr+YqIThcFRVd0QEkzAJRkNRbtwzp
         8L5IG4sptdmbX48pUT22+ybSWq6ZY90C6Lo8V7EXai+739311y2gqVmk5PIqx+c2+Zu+
         ojKDAsgh0vexMt9c/7vvsnAq1zmpc7Vu/kki0osnZkYd9b7TJ/KgFqgHEB63dxZvAGPL
         XSEw==
X-Gm-Message-State: AOJu0YxCpX6K0g8Evq2ozVnqf0fsFZLA0uebQWcUxY+Nr7UOWAR1D2iE
	mrnRk1HstIe2JNQrBTPj4o7z7v/laMukzJcYXgp02NAmFwTDnP7y
X-Google-Smtp-Source: AGHT+IGdNZXY25/ikIekiwHfFjcoAhxH7vEEItMrstOLdj74ox4xUMOnDBHTlg7ejNawcMRcCI2LdA==
X-Received: by 2002:a05:6512:3b0f:b0:50e:7be1:f0e3 with SMTP id f15-20020a0565123b0f00b0050e7be1f0e3mr1688543lfv.83.1704475306329;
        Fri, 05 Jan 2024 09:21:46 -0800 (PST)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id z13-20020a17090655cd00b00a27d5e9b3ebsm1070091ejp.105.2024.01.05.09.21.45
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jan 2024 09:21:45 -0800 (PST)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a275b3a1167so214956166b.3
        for <kvm@vger.kernel.org>; Fri, 05 Jan 2024 09:21:45 -0800 (PST)
X-Received: by 2002:a17:906:fcc1:b0:a28:c9f:858d with SMTP id
 qx1-20020a170906fcc100b00a280c9f858dmr1422177ejb.136.1704475305154; Fri, 05
 Jan 2024 09:21:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240104154844.129586-1-pbonzini@redhat.com>
In-Reply-To: <20240104154844.129586-1-pbonzini@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Jan 2024 09:21:27 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi-i=YdeKTXOLGwzL+DkP+JTQ=J-oH9fgi2AOSRwmnLXQ@mail.gmail.com>
Message-ID: <CAHk-=wi-i=YdeKTXOLGwzL+DkP+JTQ=J-oH9fgi2AOSRwmnLXQ@mail.gmail.com>
Subject: Re: [GIT PULL] Final KVM fix for Linux 6.7
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peterz@infradead.org, 
	paulmck@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Jan 2024 at 07:48, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> * Fix Boolean logic in intel_guest_get_msrs

I think the intention of the original was to write this as

        .guest = intel_ctrl & ~(cpuc->intel_ctrl_host_mask | pebs_mask),

but your version certainly works too.

Pulled.

           Linus

