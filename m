Return-Path: <kvm+bounces-8967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71EE3859016
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 15:28:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E65D282DCE
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 14:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA1257B3E6;
	Sat, 17 Feb 2024 14:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uae16Gps"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0687B3D0
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 14:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708180088; cv=none; b=ajOlayXbUwKJp5DqQxr+IXH6bfPr6lI+KY7tqAnpDgG/06P4BqrWkJhTSPI+1l7jtLQRb9DscH+caGvm2VRzzxuKW8ZY7swMrFOWTwzyKB7ntNhmUxoPIm4vhwqHW13M/Uahpq4FzYT5hWrpBbn1s4gKgeId1bwBAzy/VAhBzsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708180088; c=relaxed/simple;
	bh=/eUefz1FkIPQ1G768Xwe5fQSk8ibXAAs1dbntOk1WHo=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=rspgVQUuOdnGaV7YU+CIcSlw4WEPAOC0rVWOJs8Ftv0CB5p3SJJzFHQXUeTEYrieo0rDNhYGEnVBy6ETzVu9gjMkQw9YhiMcv9Rq8DUnnZiMcGnl4Ddtt0Z16gNQj30JGrXEv0WCruOslcJ7RfhHwGkwBJTwp+AVDn8HiJWg3B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uae16Gps; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e3e7d693ebso22202b3a.1
        for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 06:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708180087; x=1708784887; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g+gk6WZ54fJiu1kZj993McRBYTJsNzCZTM/wPmv5yGs=;
        b=Uae16GpsHRaiGIUnTdvtdEWLh201p4/TzzRY7/3YkJlNRTQzz/l3k/BEDnVj9nYXpY
         ZNPLCv+/EWeXI6oce0NlxcGc00hd8KwJu2ZpPFHWaqn6ZPhxE0wmbi0FXP/JE6RPMqEC
         rozzAI3AxGF0xV1ylTQSpZo0hRyNnjI9H9WQVUl0+4aO/qEB4NgXHDLXo2uTg7OTT28C
         vsrLg9KDUEDFlmq2fhiclrpNlUUF4effzK5XB+oD/0v9sTii9T9CbdaNSWAexI1jxVXo
         z+CtCSi2BMAum+FTwajQrBdaNJG8S/qQBAylgSj20XOzBdI87Mjr64haOHB447dhNFp4
         LlwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708180087; x=1708784887;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=g+gk6WZ54fJiu1kZj993McRBYTJsNzCZTM/wPmv5yGs=;
        b=CBQ1keo9J8K8+RQlzM2kXb6n794J/qVE+Xm8J9PR5y7OYFXPErC0gnnUSBQY4Cu8w1
         FjJVu1uLAe+J3ogjvnqzP6mV8rMQXzjoiZgE1+6Uh0TBDctngZgK1dsw4cc+rv9iezzB
         WG6lZX5pk/UGyhfiqv0l50xBiqPtzpCPpG2/vPI+ntrN+t5KDDT5h16HsAR1q4fu99nz
         shNrNQdd+HaP5F4S/BGFv9niIfHGs/OIp6JGpQeNkGD+GUUwYHZ6MjMB3t1SIAfnKEHW
         WCNZzFkbbIePcWowDZIPfy5n5wu0gu88pAUouUuJFnnEEH4ndXnnPv1GIkOzSZbGF8oD
         YNRg==
X-Forwarded-Encrypted: i=1; AJvYcCUhyaeXyiMAeRa3aBbst3rSG+sGxrSAIMtdeukLRtuYR8wnxcDJX/+K8ho9hrr/xXlwzQM5bfVn97GIyOTo7lImiatU
X-Gm-Message-State: AOJu0YyZqJxQmxrvaBzh6ZRLqbLFnwxG+pl0ix5rUKquh5WNClZTooue
	ydiY3iO4myVbwbauDC7Mjf+dZomid+AZBKSs6gGYmZN9sErqyEvW
X-Google-Smtp-Source: AGHT+IFwe6pUDc/1M4pyvFmiJ+KMjxnvE6MnQ+K1nbKYGGj9eImdGKdJQNDRn3TdcgP6ofO6CwJq4g==
X-Received: by 2002:a05:6a20:6f88:b0:19e:a5c9:144e with SMTP id gv8-20020a056a206f8800b0019ea5c9144emr8219405pzb.59.1708180086675;
        Sat, 17 Feb 2024 06:28:06 -0800 (PST)
Received: from localhost (123-243-155-241.static.tpgi.com.au. [123.243.155.241])
        by smtp.gmail.com with ESMTPSA id t11-20020a62d14b000000b006e27558af8esm1441995pfl.76.2024.02.17.06.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Feb 2024 06:28:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 18 Feb 2024 00:28:01 +1000
Message-Id: <CZ7FAVZ6J6DF.22SLKG0NAG6HL@wheely>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Alexandru Elisei" <alexandru.elisei@arm.com>,
 "Eric Auger" <eric.auger@redhat.com>, <kvm@vger.kernel.org>
Cc: <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar()
 multiple times
X-Mailer: aerc 0.15.2
References: <20240216140210.70280-1-thuth@redhat.com>
In-Reply-To: <20240216140210.70280-1-thuth@redhat.com>

On Sat Feb 17, 2024 at 12:02 AM AEST, Thomas Huth wrote:
> getchar() can currently only be called once on arm since the implementati=
on
> is a little bit too  na=C3=AFve: After the first character has arrived, t=
he
> data register never gets set to zero again. To properly check whether a
> byte is available, we need to check the "RX fifo empty" on the pl011 UART
> or the "RX data ready" bit on the ns16550a UART instead.
>
> With this proper check in place, we can finally also get rid of the
> ugly assert(count < 16) statement here.
>

Thanks, this seems to work well. But arm64 still behaves strangely
with QEMU migration. It seems some odd corruption around __getchar,
but this turns out not to have anything to do with the MMIO read,
but it's just because the test case generally is spinning there
when a migration happens.

I modified __getchar() to the following, which removes the MMIO
entirely and just waits a number of times called before returning
a getchar, chosen to be enough time for QEMU migration to complete
on my system...

int __getchar(void)
{
        static int i;
        static volatile int locked;
        int ret =3D -1;

        assert(!locked);
        locked =3D 1;
        assert(locked);
        cpu_relax();
        assert(locked);

        i++;
        if (i >=3D 3000000) {
                i =3D 0;
                ret =3D 1;
        }

        assert(locked);
        locked =3D 0;
        assert(!locked);

        return ret;
}

I get asserts on the line right after cpu_relax() on arm64 after a
few migrations on migration selftest.

Without the cpu_relax() it takes longer to hit an assert and it's
usually the first one. I expect this is related to TCG translation
blocks and where it exits back to be migrated. Something is very
strange, I suspect it's QEMU migration bug.

Thanks,
Nick

