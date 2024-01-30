Return-Path: <kvm+bounces-7502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 258E4842D8D
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 21:15:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF6CA28996D
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 20:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E580471B43;
	Tue, 30 Jan 2024 20:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RB8zXF9h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927A371B2C
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 20:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706645734; cv=none; b=Rcyq9/lFt3Of6vfoNt9qzdJcaXPc72xsmb2j+GkTPS0X6bxnC4bWDN7TtfyCBDpaSho2kuhKH/MyeiZpyorqqoGj8uvHFnmA7jZC/Q4X5B9ZVLtqUREy3RqXB2WJLcmjvTZ/AqP2qyZthrzrPLqVOI+DHzwHLYafAliUL/Rqxi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706645734; c=relaxed/simple;
	bh=XozUepfSd8KQd3SFafEf9XmtiAOGmSV4V2xIjvbsvWE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a+dX4bRfN5kiWgg9WxBCprIBB4wHJ3YrIWpf0EQJ/t8CL41E8Em+foYdx+VP4VBHj5DCR9dABg8XDbInoVCQ82y7pXP8QPCngxo3c7QBVS3BjkRh1Zm3KYD4HyyjDIn0GVNiuflv/yc8yURkzdlj1nGw4zE9EJ9W/g+H0cFbG54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RB8zXF9h; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-59a29a93f38so1212254eaf.0
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 12:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706645731; x=1707250531; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=REUXrXnuJ7Xa2mxo3Z41o5PpH3dUV0+Zue19WtSRxzA=;
        b=RB8zXF9h1z4W1O34NfpkcxnUaqur4imaauM+FiLxBl076Ub7yEBis9Rl0BTBGCqQq7
         6uGMlDRzHiYQ2piS7zl6T3nAHZwrzmvFrLakozX4ADiTF0zkHNjetf832n2KGUbK1OU7
         dWfWHNx4WM9Pwdc4HtEGyHOFnYHWLHYthY0Ogr3J/Qxvtpas2yS/9uNqKn6keU24Ob3b
         oCwlOT7DjRGQtY2OoSzH1EXg6xv01UTitXdchEXLrBsqKAb4pUQjTfDJoqjf2GKwpt6V
         dqKgpJHRUlg9ZUGu598toTP8RwX95S3ILagi+w+F3hxS9ttSYAcXyGSwohiLrlU6u2Uf
         2poQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706645731; x=1707250531;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=REUXrXnuJ7Xa2mxo3Z41o5PpH3dUV0+Zue19WtSRxzA=;
        b=LclwOYFpqi+LkL3hkLf4g2O92MzOFxLfTcpKIiYEvUzBOp+os04n2NI89TFygFLsvR
         EDoBlXDqYeQRFtoZLj+NEtKynusJmhzOfDK47E2Oa/KziKbeH29/gf9IZFbvcKSLvnnm
         hnO+nNeqchozxywkQa1UFba0cs9oK4DbSAQb1Gcx6JgrygaAKWCo77qSQ1/BlFgHhl7g
         Eh7uCOvCGiLeoZYusqXrWyXeXxNdnEuxZBqflO6DvAoLfzB2sN+AkmVa+bvGYHIVK6dU
         84RyscvOCFrGNPM95v7u1TWqXICbZbSZ1OPHlqkowAxhSQ8W0RPp2aXN9//X4iGo+m2q
         UjFA==
X-Gm-Message-State: AOJu0Yx5c8XxGGy28xoDR72zkFCCjoQRd6Q2GrI2/2IkRmq6yIwb+ZtR
	wXrVPOgrWhg0FllredyFigPf9cOQOjzdjc6U4Fp30wmOcKGTZ7T0hdX2fbk6FKoTaXUf03k/HnX
	c0Db49Koc8QxRieBpWkNqjq16Qmz9oRbjBIQ=
X-Google-Smtp-Source: AGHT+IH8LiBNVjJpb9Td+TSmmyPlPnk6ONWUSG3n0mAvXHJFpzZBNLW/7ka32OOU0d30P16WzGF05Ovkf5jSZ89L8SA=
X-Received: by 2002:a4a:b819:0:b0:599:b548:e5f6 with SMTP id
 g25-20020a4ab819000000b00599b548e5f6mr6514558oop.4.1706645731236; Tue, 30 Jan
 2024 12:15:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QX9TQ-=PD7apOamXvGW29VwJPfVNN2X5BsFLFoP2g6USg@mail.gmail.com>
 <834f4e79-7495-42b3-b6b1-aa614c03d15e@csgraf.de>
In-Reply-To: <834f4e79-7495-42b3-b6b1-aa614c03d15e@csgraf.de>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 30 Jan 2024 15:15:18 -0500
Message-ID: <CAJSP0QUmBuToTt9_s0EG8uh+4Q5A=NmtcmRrkkrH5kjWD4=iqg@mail.gmail.com>
Subject: Re: Call for GSoC/Outreachy internship project ideas
To: Alexander Graf <agraf@csgraf.de>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Alberto Faria <afaria@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	German Maglione <gmaglione@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	"Richard W.M. Jones" <rjones@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Warner Losh <imp@bsdimp.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Daniel Henrique Barboza <danielhb413@gmail.com>, Song Gao <gaosong@loongson.cn>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>, Bernhard Beschow <shentey@gmail.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	"Koira, Eugene" <eugkoira@amazon.nl>, "Yap, William" <williyap@amazon.com>, 
	"Bean, J.D." <jdbean@amazon.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 30 Jan 2024 at 14:16, Alexander Graf <agraf@csgraf.de> wrote:
> === Implement -M nitro-enclave in QEMU  ===
>
> '''Summary:''' AWS EC2 provides the ability to create an isolated
> sibling VM context from within a VM. This project implements the machine
> model and input data format parsing needed to run these sibling VMs
> stand alone in QEMU.

Thanks, Alex. I have added this project to the wiki and added a few
links (e.g. EIF file format). Feel free to edit:

https://wiki.qemu.org/Google_Summer_of_Code_2024#Implement_-M_nitro-enclave_in_QEMU

Stefan

