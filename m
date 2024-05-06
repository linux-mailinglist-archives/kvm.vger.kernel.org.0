Return-Path: <kvm+bounces-16739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C0E48BD2B7
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 18:25:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7BC8285AEF
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 16:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E58156655;
	Mon,  6 May 2024 16:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZXSJuTEY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A013156258
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 16:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715012669; cv=none; b=NpH7mqXX/1mqBeOUDIcEv7lHuIFjNOAoOnoJQLiNC4b9AZMTArv5yaWluHo8wCB8oM6jX1MJSVPcG2tPwE+wbKwq+kU9q+s4eFBak+NicfbEDcX92tMZCK2fiJDhcPqnVB14TFGWb0Yuhf1M+uuqHH2ejgBRCP/wMNxnHr+vkL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715012669; c=relaxed/simple;
	bh=1umspOg6P+YBt+kF0yVj2x9Zp4XiH8wmBDIrxcQqV7g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S2kTNH2km8Vwb/anhrkWTXvGvCn8ZQJ6sDZqSjklv7csrmHpaz2Sr2evVcHkaamSy//9l387xFtetBNwEQDLFiveEHEeGgsTKD1SpYMRUrbNHypRtGMq1MyjBJ4yBKMSzbggUQpoIKmwpC6HrXay5VHXQ2xZrKq03byV8XdSwVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZXSJuTEY; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5724736770cso13805a12.1
        for <kvm@vger.kernel.org>; Mon, 06 May 2024 09:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715012665; x=1715617465; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v0dZxDAccYcCY4EmOhr7flN+YOjsFHzjNLPRNOnfYa0=;
        b=ZXSJuTEYUFZMmt8P2dFsiBGlWk/ItnjYTJnxAKAWaTAjoGb4HDCprRjJHsqZ1Gro/A
         ivY7sRYI8HacYb9zESUqJbUIu+2d96GkVZuTaS+X+RcNM40Gb8A9iCjQTlfmAU3GsLhl
         yjZr76Sc29wR1JJOIgP1SNyc7apW27T94OwVdPJFXB+0qXmFcMPviQxQQfqCElWtpMdv
         33DZnLp/c5YvRz/tsEEIU1LE8O0UETVNOIY48aHtTEyKCUTLFopbQ4fP8BHLzWiy+5Ay
         wyym0oONZ6UOi2bTtJuPyH2afKt+193nAO+wpPX8DNBoI+ws8QWgUj4bYr+Mck9V8BBt
         NXow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715012665; x=1715617465;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v0dZxDAccYcCY4EmOhr7flN+YOjsFHzjNLPRNOnfYa0=;
        b=wWzC0bzk0BskFJZXc65vZiWXR2245Oq/AZ4q0wSSDACpCgx4979Gyv1FLXn7pXkwQr
         xaQ/IO1Q25XsU9Ay9AQ/esn9ijEJrk1Adlsx9pXTJe6S6MJUt1N86Zu7nokDjFZMfMPw
         qM95/it+YQUgz//1L+thLvN3RTprSZ9upKhUWBLNTSAWugDSWlZfDDAsZ3co0tdyk0tP
         DxYVXco3qaAzPmsm2ltOc9HMGMAKlXLBLp31JNEve+i1jUKBn+0D1FVsyMOhxfuTrY26
         UZSZUWR5p1vrpQce+FliO5B+vF37s6yllZvvoXsN3LDhspIjTT5r1OUxDH0xiAXhpC6B
         o+DQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTG4pFWwwFQcbxK7Ye4SyxMDyr7he6RRV8Uvztqbs8H3O2AwoR+iR0fO/17916/5uOhnsUXxS6xdZboO61JTSJuwJC
X-Gm-Message-State: AOJu0YypQwWCeQfiIh2k6oPcdzj71U8PxI6402DHqpX442FmoRhAlkMu
	IpBgGLqfNSKEU4gZLC0Nw/aKvcmPtp548cev347MIZwYCYLTy3LDxaEfaV49VdINjIyA9btxroW
	0BzuOWx46ftT3JZ9W1fhlooct5w1+yW44yMZV
X-Google-Smtp-Source: AGHT+IFfKJPpR85/urooKgDXyAvRKv1p8Ab+gb4qgrqhtuI42OCDChtqOgl7yd9hwmAY+uLAF+ntmjZvvrebUqjOnAQ=
X-Received: by 2002:aa7:d44f:0:b0:572:e6fb:ab07 with SMTP id
 4fb4d7f45d1cf-572e6fbac14mr225538a12.7.1715012653454; Mon, 06 May 2024
 09:24:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240429060643.211-1-ravi.bangoria@amd.com> <20240429060643.211-3-ravi.bangoria@amd.com>
In-Reply-To: <20240429060643.211-3-ravi.bangoria@amd.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 6 May 2024 09:24:00 -0700
Message-ID: <CALMp9eQzbNVJpuxp1orNswnyfKy=aFSPYFRnd3H7fbi0+NfDvw@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86/bus_lock: Add support for AMD
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, seanjc@google.com, pbonzini@redhat.com, 
	thomas.lendacky@amd.com, hpa@zytor.com, rmk+kernel@armlinux.org.uk, 
	peterz@infradead.org, james.morse@arm.com, lukas.bulwahn@gmail.com, 
	arjan@linux.intel.com, j.granados@samsung.com, sibs@chinatelecom.cn, 
	nik.borisov@suse.com, michael.roth@amd.com, nikunj.dadhania@amd.com, 
	babu.moger@amd.com, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, santosh.shukla@amd.com, ananth.narayan@amd.com, 
	sandipan.das@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 28, 2024 at 11:08=E2=80=AFPM Ravi Bangoria <ravi.bangoria@amd.c=
om> wrote:
>
> Upcoming AMD uarch will support Bus Lock Detect (called Bus Lock Trap
> in AMD docs). Add support for the same in Linux. Bus Lock Detect is
> enumerated with cpuid CPUID Fn0000_0007_ECX_x0 bit [24 / BUSLOCKTRAP].
> It can be enabled through MSR_IA32_DEBUGCTLMSR. When enabled, hardware
> clears DR6[11] and raises a #DB exception on occurrence of Bus Lock if
> CPL > 0. More detail about the feature can be found in AMD APM[1].
>
> [1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
>      2023, Vol 2, 13.1.3.6 Bus Lock Trap
>      https://bugzilla.kernel.org/attachment.cgi?id=3D304653

Is there any chance of getting something similar to Intel's "VMM
bus-lock detection," which causes a trap-style VM-exit on a bus lock
event?

