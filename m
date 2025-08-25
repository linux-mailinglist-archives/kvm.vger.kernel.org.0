Return-Path: <kvm+bounces-55594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 874E0B335D6
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 07:40:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A64123A8C74
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 05:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFBDA26D4EB;
	Mon, 25 Aug 2025 05:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="alRG6h58"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C20264614;
	Mon, 25 Aug 2025 05:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756100393; cv=none; b=aOobQkozQ5WEvQhPBttEEle8d2Ylfyj4eqiiMSCmqmud7SOhGpwQsnyBOZBRz/JZiXnrjRByXNEgnz7zIYRFKjD9f05AsVaeD3V2v5EoWbRb0sGG/ZDtjS0l+T2m3wDeDjwn3TDuAX5ln3Fan9/R089YdZ2/iSzsZFKDOzy8zEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756100393; c=relaxed/simple;
	bh=mxpK44SckMFXEKznJOFz2HiVGPh/8LC/M3h+S0GHDy4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Xf/2PiCyHO/bZepebL+56bXhgLKYm3Q6Kng3hsRoZVAuoIeRqhL2ZL/SA/YOi6iQyqLlpsONomrx6hWYmXJgd+Vp3vKeKqEKD3nnBWW/3HnZu6kkdbxL7qMdL1TGuBl7Ise9qEj7A9hAGnncue44ij9ngJ78/OuTj5do7qYKYYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=alRG6h58; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb7347e09so678690366b.0;
        Sun, 24 Aug 2025 22:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756100390; x=1756705190; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mxpK44SckMFXEKznJOFz2HiVGPh/8LC/M3h+S0GHDy4=;
        b=alRG6h5814rrRQnkHSNQwIWbHzkvYgg8S7+VrIgJb/sUDfLC/g6KR1uB3GqhglVw56
         kxj3D6Rh9M/mekYTcc00wiYQrG/fjTZjLC+EfdxQAdasSNp/8QLbnrSfbaOVemLCu7qP
         T8jOpJQxh/HHZTQsqTd96IjGgyDQmE1nfXIaRaZFYpp/gYUKVd6Q3CuvOaIidUERbSOC
         GIu7ibA/vzRR4eRmnX1IMbVsK4STK2LHeMS5Ru8JzCnpUkqDp9f6MFp/661Bhx8e5XQB
         KRVfh26LbpHZs4uiWuHp4nIa9z/9KnfOfkiiFysGmCNIXy8Az2V68ReSp3czAyPiBTUt
         m8nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756100390; x=1756705190;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mxpK44SckMFXEKznJOFz2HiVGPh/8LC/M3h+S0GHDy4=;
        b=lvmuezhB1QJ6mp8tZlI7JOeGq5kQtpWdp/r8RK4JUsj1MwkwdtnzjJtELujaFxbi4D
         hmgeqxf9eXx2oSKI16M96SRILHbDkwUcyzrLxCn6IwM5OM1yi7TD7qrMkHVeVKRVn665
         zYs/GmSZgIEghRYY1nfEZ9Cd7ZNZ1o+Z7hKHdh+Z3NYsJbsHDz54J7tEItxplEE8mKOt
         TnzOwyaUtkJfq7+ta78PEJvcKnEb2zpU4lfT8lpjp2HhNhHWqiO9AI58KlXY1s/8hJFd
         ot2py/P8Q33Q9L+H0fjSjjd3YM1CObZwActB7QvG2yLQo8lesbqSpW2CxzHbp4lE1Ac3
         pAQg==
X-Forwarded-Encrypted: i=1; AJvYcCWwvPYJUOOamacjEyRVNWP4Lmy0iL/2UfpkLKVI0yTLDZf3+iP5ozMVboYpVsG7+aLpSzvX/+/jtPI6pM0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDNOK3yAxX+aDzcXWAJ8Si/e10KdBx8iIon2KBDTHoR1ByUdQc
	z5oW/lQBYhgocm1Km7yQph628G0B7FYd9LPwHXcQzL27KOzLKuXqoIeTN7wNM1FFX8yCv6v8a/E
	O670Bn1C6xOEtcowrwTvI6MtoCi92F4yqJbM9Vfo=
X-Gm-Gg: ASbGnctIH1YkGdFPsaWjm+ZlVQX9v0MdVM+GElIWE6caJPkha8R3xMtYxfZLZ4v15QI
	7HWQWdrFH7NIBPrJyYOwBKW1IhbW+/rktrqbVMPLe4Mk0wuDyruCuNOujI8e7gix7sUR4WZXIqx
	/fhlV0tiYm5+rRU8AUlyI6ECGYtO5xxJcIApIiG31dPHpv/qXcq8HWlD5/wa3KTmr9Dm6zSBE9F
	Ia8pNCv
X-Google-Smtp-Source: AGHT+IEaQiaHsBBJtRrKxZMIeyC9U4+bkSPHRGLwijQt1ZLdhmO8gPOZQFtEAn7RtBhcHK9WXdQbrZmCEeZZUw8rJXY=
X-Received: by 2002:a17:907:3da0:b0:ae9:b800:2283 with SMTP id
 a640c23a62f3a-afe28fcf9cbmr1062548766b.15.1756100389297; Sun, 24 Aug 2025
 22:39:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jiaming Zhang <r772577952@gmail.com>
Date: Mon, 25 Aug 2025 13:39:06 +0800
X-Gm-Features: Ac12FXypkx-69iFqbRSt5JyexrJ5Txq-LkOZikAWLXnWlVCiiYBw2E9Fmo4FoY4
Message-ID: <CANypQFbEySjKOFLqtFFf2vrEe=NBr7XJfbkjQhqXuZGg7Rpoxw@mail.gmail.com>
Subject: [Discussion] Undocumented behavior of KVM_SET_PIT2 with count=0
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello KVM maintainers and developers,

I hope this email finds you well.

While fuzzing the KVM subsystem with our modified version of syzkaller
on Linux Kernel, I came across an interesting behavior with the
KVM_SET_PIT2 and KVM_GET_PIT2 ioctls.

Specifically, when setting kvm_pit_state2.channels[c].count to 0 via
KVM_SET_PIT2 and then immediately reading the state back with
KVM_GET_PIT2, the returned count is 65536 (0x10000). This behavior
might be surprising for developers because, intuitively, the data
output via GET should be consistent with the data input via SET. I
could not find this special case mentioned in the KVM API
documentation (Documentation/virt/kvm/api.rst).

After looking into the kernel source (arch/x86/kvm/i8254.c), I
understand this conversion is by design. It correctly emulates the
physical i8254 PIT, which treats a programmed count of 0 as its
maximum value (2^16). While the hardware emulation is perfectly
correct, it may potentially be confusing for users.

To prevent future confusion and improve the API's clarity, I believe
it would be beneficial to add a note to the documentation explaining
this special handling for count = 0.

I'm bringing this to your attention to ask for your thoughts. If you
agree, I would be happy to prepare and submit a documentation patch to
clarify this.

Thank you for your time and for your great work on KVM.

Best Regards,
Jiaming Zhang.

