Return-Path: <kvm+bounces-67793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C49FD144B8
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:17:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9B02130052AB
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 591F9378D8C;
	Mon, 12 Jan 2026 17:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dcktDard";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MdPPvCaY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4444221FF3F
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768238229; cv=none; b=M0t14H2K5ltIP0Dp5GsXO4/UlliSjC0uz3K+d7OoEk+homi3yyh6G8z9a4DyywnU3OBDgEdygeuCjD8kEbuO7qStr+B9cQHwBothbz3pfUrfnFjB0zttjn9do7UxFgu8V2ogx11R/PduM9tGCGt3uZWzG3GQ9d9YN/+XblniAB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768238229; c=relaxed/simple;
	bh=FXpRCfPVEiFw+dNjGTtGVWMadyU48Fx4vEKeGxrqzxc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PN38Kvaqh3GPOM/3Xo2O5kfUmU62f9PU6QY7SqkXaQOtucOwiZ8a7z/VBSiwTkWXQhUZwCD8p1uPKyMmSG+EOJEFzFzqpatCC/kzwuANkCLJ4lcS/Jj7b5X6skhApj6Tgtvf6LQfLHyJngwi2bg7dBY0M1mqMfEz1cvIc9y+z0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dcktDard; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MdPPvCaY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768238227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TbR55RWmy2+YFL3bBwo9GTjTQBKO2lUGM8h9kri2GdQ=;
	b=dcktDard+XWPyRnTzTdb7hgEK13CqCs9lyotDcfYv82f/3kxhATD2tf/RdacCJco0FXf8G
	cgQ25yWb5V/gnJQNFbA/OThADZlS5eZQdBeGAjWH22LujJde0h1vcNMHhSMPxwfkx+sJjM
	2y0VFrJLMTtv0LXxksZ+YfLrYY23Asw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-tL8H7cRBNC6Jm0sQMtqSCw-1; Mon, 12 Jan 2026 12:17:06 -0500
X-MC-Unique: tL8H7cRBNC6Jm0sQMtqSCw-1
X-Mimecast-MFC-AGG-ID: tL8H7cRBNC6Jm0sQMtqSCw_1768238225
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-430fd96b440so3382789f8f.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768238224; x=1768843024; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TbR55RWmy2+YFL3bBwo9GTjTQBKO2lUGM8h9kri2GdQ=;
        b=MdPPvCaYhuMmPwmKKw/zZKlSCHaq+kOBOV4KnuC+M1aC5kV7BunKR9bzsF+MZ3LtnO
         Z1SNzolUyL86jJS+RB/nQc0S3ygo6O6q/DQWzMw8KwefNvWMxw00thzUH4fm4KY5nz5N
         eJ9JXeFOrt5PuB8WJiMQBM6Z2UzclQbWcpR7Jj3WXImV+tAlNtHq3+Iu+xgaSOmfjtoB
         YOH0/U5uFJWTdj00Y1LPq19oT+4jSBT2YJu4FH8k3dkB90YnXV/KelcOlZgzy/7k+57D
         kye8FEFAmkK5Nhj/58OIIGFfKTBYIQtjEMLhLxrsJXsyDkVk5JY8NVsqVfmYAT4Ec4fS
         9cbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768238224; x=1768843024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TbR55RWmy2+YFL3bBwo9GTjTQBKO2lUGM8h9kri2GdQ=;
        b=du4fqEeu4tleWPMPaeefWIpyBcv7JKxGAS+l1GSGZobOwATguq0PljC19b3KaNUtDv
         ZVQClBYnNIkFLw0bR75/tvqsAIay4LgsqZ18kJdcpN7OWTQOIbnyJ2lNFMExJKRcIjD6
         YGRiX4vMUuguxFo1X+YI4KQpU/8ymaiMyevBYGAE5JgdQVmesW6PsiUM3vS5nOMvhucd
         3aRjIKsUWXHnW3gsxfIBR6zn9dY+pNwrKtpqgy+K4qe184BulMZwCYWF4BuStqilp5PS
         z+Dyg0tjEesgh8AIfhtNK8T4JKSy7zDR51EAVqsfu3acsZPHrqBzWa7VAKJj+29x+LYx
         VyQg==
X-Forwarded-Encrypted: i=1; AJvYcCXGPkNeRME7E1RtlzhH/xXpgNHWjA3V2q/GkxaFwR9/lbvE9/Rh4ZES0bWLRkI664rr8LE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZkDWQApzINklv55FAxszkykOxB3RVEBL09CXJpAsD+V4VwnBS
	aBx/fJ9UKCP3B+Qtg67ileUU1JENdSitA4qvbkd6ES2A7VjglwqjMbLdvyuB65A6cfBjeLynS9Z
	C1r5ojIfP8FzYFZQy3R8j2VusCaZ/lDdXyIoajylODkQvuJ5b9gL85asU2RuBY3LzVlGjcWl4sd
	c/n26z9qz9UV21/ITE7MG3RZt578Hbm1qrSYTO
X-Gm-Gg: AY/fxX5dOn2QqnOnVNWRGMO3SD2RsJdPsGBfFLZr+6Zulhqkt5ubzTPfhPK2AHrCO3I
	7nkp2U/2qUcWqDAFjol5vYYa3fQExnIN0Vprr0jB4HRg26QmsaIUS/NZxoVBzHdC1G/8AFxUzPl
	D1bqlaYaemGJ5s60jqvkaHhSB3lgkOgC64aZNvqWxRQApwmgYMdQRgG7T/LUpjfb7VDPMGdCt3F
	WtnG+CpCKhiWRCYaQf0BMip4kbrVgSSPzTq7P6Pep4m5XVI6T+AdCFSRuQEBkXum0ryow==
X-Received: by 2002:a5d:5288:0:b0:432:c37c:d83a with SMTP id ffacd0b85a97d-432c37cda23mr20069994f8f.15.1768238224525;
        Mon, 12 Jan 2026 09:17:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IECQTb3AWtvZ6WtGUK0wzslRe7ONR7YBquj6IL7iXXYKTj6yVbH5yuysBavac8M4eWjg1M++XI0XSm70YIW+a0=
X-Received: by 2002:a5d:5288:0:b0:432:c37c:d83a with SMTP id
 ffacd0b85a97d-432c37cda23mr20069956f8f.15.1768238224134; Mon, 12 Jan 2026
 09:17:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112132259.76855-1-anisinha@redhat.com> <20260112132259.76855-17-anisinha@redhat.com>
In-Reply-To: <20260112132259.76855-17-anisinha@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 12 Jan 2026 18:16:52 +0100
X-Gm-Features: AZwV_Qj1S01xS_RuEjlKcw9Q8j5Fzrs_W3hcCm8OfikDDZ1w-idEH_zwen_0kMY
Message-ID: <CABgObfaeyiubq1OZMsbL2h_fgfTrBY+YLJVTLksazCTF0mK9Hg@mail.gmail.com>
Subject: Re: [PATCH v2 16/32] i386/sev: add migration blockers only once
To: Ani Sinha <anisinha@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org, 
	qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 2:24=E2=80=AFPM Ani Sinha <anisinha@redhat.com> wro=
te:
> @@ -2764,6 +2749,11 @@ sev_common_instance_init(Object *obj)
>      cgs->set_guest_policy =3D cgs_set_guest_policy;
>
>      QTAILQ_INIT(&sev_common->launch_vmsa);
> +
> +    /* add migration blocker */
> +    error_setg(&sev_mig_blocker,
> +               "SEV: Migration is not implemented");
> +    migrate_add_blocker(&sev_mig_blocker, &error_fatal);
>  }

.instance_init callbacks cannot have side effects. For patch 17 this
is particularly bad because it causes a dangling pointer (the notifier
is attached to an object that might not be ever used, and instead
unreferenced/freed immediately), here it's just causing migration to
be blocked forever.

If you can find a good place to place these that would be best,
otherwise you can add the usual "static bool first" method/hack.

Paolo


