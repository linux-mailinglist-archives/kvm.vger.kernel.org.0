Return-Path: <kvm+bounces-7493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95ACB842CF1
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 20:35:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51EEF28B4D5
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 19:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CE7A6E2AB;
	Tue, 30 Jan 2024 19:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BjhMQRtF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6804469DF3
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 19:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706643264; cv=none; b=UD5ETqXh5uR1/wOzm8e0DYStPUQLgnkcPfjGz/OeCaGCLNOW0xbpVtbn/Zv2QnvjBc0X/4H137s3+bU30ahyYOJ2WzUy8RKS524vKgwY310PsGMESP2fhQd3CyvnwO9Ed+ziIsN1Ky9q3+6mtMYPF1/Z1KUM5dSuPqIVAOdTt34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706643264; c=relaxed/simple;
	bh=0CvRLqTCzJ0AgIzxfXdNIE9ypfHTup9n0zpeW9FKuEU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UDrnHFJwxn2WMOGeOjGKOVD+4BgmbKMHku67JCCC89AbdaDGTGv+tUNlWUU9xn6H52nPfEvw/qCOh2mu7vIBeoJ8i+K91OuKk8y/w6/gbc3yVKOiNiNRDKzxIYSOm773UvZz9A6qXQDlKdomCO50Cg2vgAcgwkQci9HEWXnOWi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BjhMQRtF; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-59927972125so2526238eaf.3
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 11:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706643262; x=1707248062; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0CvRLqTCzJ0AgIzxfXdNIE9ypfHTup9n0zpeW9FKuEU=;
        b=BjhMQRtFd/+frNJ3h/48K4tNbMU8fjEuGRZthwXmBUVNrICL91vsOlK8G4V6poUeeS
         XzpYTrwEAbvJhlJv4bJEhvajW54sjLcs51qSedGuBpLeF4j+AIOYT2+CYFPCnnF9kZWJ
         fKcmsCL+ruLDWnfaxOnrm5rjVekqNMz/DRVmRdN+/55/ss640EGmgoxVTK9s3Ild7Ak/
         3a+RcxuuPk4O/aGo2SCqDIBPu7ijU898dPySJAYqELJflAUVTZOAZhD7VGY555xkR7Cx
         O0dN3nzfM6mDsTqvg+mIuapGTJnuxvybs0sYAvQo+A0hJLO75EIqxOrurnNtjI5RGxvb
         72mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706643262; x=1707248062;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0CvRLqTCzJ0AgIzxfXdNIE9ypfHTup9n0zpeW9FKuEU=;
        b=sIkqrsUaSkfI9PovmKdLtShvR8dPj+UN5pA9X/o62XUtmV162TpMqPlfdkkfykDWL/
         uFiYW2rmyRJy0a/RKv3YJT+rqP4AMXwNa5AwA5tv0ztFG4x1pgLhJWV40+vp65LVFkIf
         b+7vBxOj8vh2635IJi4WS/Vcoe0Dj7Zw5yJYl7pZ8A+vLCy4BPqBrQYUL+cTsnyBd33f
         cfiGM4ztw+iGmdNC6IL2fAU/5vrUE/MVbxLhIaFDsQu4RsxBsoeb66lbb0iJn9iKZhmO
         UGRQfWOZCavOrSQf8DQ0fpt+rbD3RplhkHHSvUYZgPq+JdYkgkIipYv7Zx6FruRO2BhD
         KOAg==
X-Gm-Message-State: AOJu0YwubffT1VTN7xlNdObblNWpeKOxZLwAp3uj8IHWVxzFmLUNNW54
	2JJ9lI/h6Ie8gEn4sSwq5nRjKX/Lp1ebqmr7iMn/x1KijwQsUF9fxAyQFiEKdYZm83hs8hsmUwQ
	Y3XHrh1p4MdkF3LQH92TQrE0UJ18=
X-Google-Smtp-Source: AGHT+IGImRyWXFYHGAlbvIzjSc8dtJi2NLXU7QQiMlyVarpvAImwdO/VtDgKy1UKIpBq2uBaW8PoGsIlCX9ByAURnMQ=
X-Received: by 2002:a4a:e60f:0:b0:59a:f1e:9b3d with SMTP id
 f15-20020a4ae60f000000b0059a0f1e9b3dmr6879315oot.2.1706643262457; Tue, 30 Jan
 2024 11:34:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QX9TQ-=PD7apOamXvGW29VwJPfVNN2X5BsFLFoP2g6USg@mail.gmail.com>
 <CAJaqyWdMNP3V=JL6C8SSbXV5AP_2O9SNJLUS+Go7AjVsrT1FdQ@mail.gmail.com>
 <CAJSP0QXMJiRQFJh6383tnCOXyLwAbBYM7ff-mtregO3MKAEC1A@mail.gmail.com> <CAJaqyWeKrjjMyRXo1LK4_2Q=HYKqd=omjDJ+by_=do9ppdCk3w@mail.gmail.com>
In-Reply-To: <CAJaqyWeKrjjMyRXo1LK4_2Q=HYKqd=omjDJ+by_=do9ppdCk3w@mail.gmail.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 30 Jan 2024 14:34:09 -0500
Message-ID: <CAJSP0QU09UCkV6Q6HfsB8ozaE0mMC1tCH02e5CEBMPC_=eyUOw@mail.gmail.com>
Subject: Re: Call for GSoC/Outreachy internship project ideas
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Alberto Faria <afaria@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	German Maglione <gmaglione@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	"Richard W.M. Jones" <rjones@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Warner Losh <imp@bsdimp.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Daniel Henrique Barboza <danielhb413@gmail.com>, Song Gao <gaosong@loongson.cn>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>, Bernhard Beschow <shentey@gmail.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Eugenio,
Stefano Garzarella and I had a SVQ-related project idea that I have added:
https://wiki.qemu.org/Google_Summer_of_Code_2024#vhost-user_memory_isolation

We want to support vhost-user devices without exposing guest RAM. This
is attractive for security reasons in vhost-user-vsock where a process
that connects multiple guests should not give access to other guests'
RAM in the case of a security bug. It is also useful on host platforms
where guest RAM cannot be shared (we think this is the case on macOS
Hypervisor.framework).

Please let us know if you have any thoughts about sharing/refactoring
the SVQ code.

Stefan

