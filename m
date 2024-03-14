Return-Path: <kvm+bounces-11812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4875087C2B2
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 19:32:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C086B21A5C
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 18:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8B3E74E32;
	Thu, 14 Mar 2024 18:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YySIXHcJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514075675F
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 18:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710441113; cv=none; b=MwC6ImFs8WWNPzUlZFSPnlTsEZEqMRedMtLPTaWpSBKRwicZaIgvLclYzlVX+FwZE8hxnp2Kh5L6Jreb6oNTs36OlugMI6efaa3knrRZ8CiY8yWl7+Xvbd5qICrbuQhbftMue1G3+MhXI9wxBdGmp91s+sqVB5Ihjn1m8Zxm8ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710441113; c=relaxed/simple;
	bh=IDBDzfKssVcMMW6+rwk5o+1AuiqHGwAICo+u93V+rh4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LZ4sz5i08hYjG7ZZrvV0zZ1FMQhAH8TuStG5HAUCpphrThMgPlr6ff2us/WraEHuT1tsG1XWe/rbxsGyPVF5sR8GlGediSiuyoRU9VTA5UA7ove1YA9wyiBU9oTpZZNsDUzXQEt+gJR9x7JC65Jsp0uhaUSIneaUspcLcDsXz/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YySIXHcJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710441107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PoWgosSZqI3joHZKAbpl768QMI0gg7fwmXIVJSVSCzg=;
	b=YySIXHcJ7v74PaPARJuYp8qSxB3Nky3zTw3pY7YLQOjb2YRzU7HyLdNr8+DT/GbcDl3Ymc
	6mrE+E6aPREHgSW2uvHBYmxbYuV/IbQm0ByhPVa9DGDp9dLeapmZJp9RJnL1qZslom8u+U
	kQ6GE5XD6UQwvAaaj8HiWX/clOjp4Wg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-9tOixzAYNi2OJr5VS_4rKA-1; Thu, 14 Mar 2024 14:31:45 -0400
X-MC-Unique: 9tOixzAYNi2OJr5VS_4rKA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-513c9f60a39so1603193e87.0
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 11:31:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710441103; x=1711045903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PoWgosSZqI3joHZKAbpl768QMI0gg7fwmXIVJSVSCzg=;
        b=AlCIsl9ZFgaGeYEMMeR/yFjlDZ70xR8U323ueZa220f1d0XbvWflPfwPWf516vdL5A
         uurKeHiqJL2FNSCiFguOpmMiNVIzI7O5UAJV+yFBOptZjO1tAOXzCh8Yw7/Aln4YAQfV
         rYGSMlcVCmlSDOiRL3LiC2Lreo7nwto0CqrlWf8UttYBIPplxIG4R/biJbSLHLkeEndD
         tyBdw/A8MUs30rsrqoNWGGBRp2By7A3Y+SfyI/GE9ecBOzNyMKd31oOMMD7syrQR+g9D
         EkPuCrj9BhYxGDdu60WqMcyUxYaI592RkDGzdG+MDlGEvUowirmwf3avik7MdnW3mEdW
         ERtQ==
X-Gm-Message-State: AOJu0Yx2XEOU9VYwEvcHq6gd9IraQ1cbzbm7F/CqDU/BvFtGjRK/D93L
	yMOkgcAATbPfdZ/OfOBgZOOF3yqudq7vertqM95G1xCuO4JQSTMovb/H+UqtKfN5Ki5mkMU7So2
	fOBKox/h7Fy/ugG0WJrFF+tKCQwV0yDXhQ068nIodOoZGO45/bVGHqe62PLIx18XsALRur8Yvws
	2xNRxUIgsz/3hnyG6n2WvXczPRapEgkXwb
X-Received: by 2002:a19:5e04:0:b0:513:d021:afc9 with SMTP id s4-20020a195e04000000b00513d021afc9mr1670442lfb.19.1710441103510;
        Thu, 14 Mar 2024 11:31:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IERI/ykUS+EYQxjMLZNZ8K/KE9J1dutx39tYSDbcTu9d8AuNY3JjVGUuVK4CeIO40RB8iL6D3uG04FzFyHq5oM=
X-Received: by 2002:a19:5e04:0:b0:513:d021:afc9 with SMTP id
 s4-20020a195e04000000b00513d021afc9mr1670427lfb.19.1710441103166; Thu, 14 Mar
 2024 11:31:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240308223702.1350851-1-seanjc@google.com> <20240308223702.1350851-5-seanjc@google.com>
In-Reply-To: <20240308223702.1350851-5-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 14 Mar 2024 19:31:30 +0100
Message-ID: <CABgObfa3By9GU9_8FmqHQK-AxWU3ocbBkQK0xXwx2XRDP828dg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: MMU changes for 6.9
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 8, 2024 at 11:37=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
>  - Zap TDP MMU roots at 4KiB granularity to minimize the delay in yieldin=
g if
>    a reschedule is needed, e.g. if a high priority task needs to run.  Be=
cause
>    KVM doesn't support yielding in the middle of processing a zapped non-=
leaf
>    SPTE, zapping at 1GiB granularity can result in multi-millisecond lag =
when
>    attempting to schedule in a high priority.
>

Would 2 MiB provide a nice middle ground?

Paolo


