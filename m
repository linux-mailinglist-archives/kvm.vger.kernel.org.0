Return-Path: <kvm+bounces-27843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF10C98EE26
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 13:31:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F77F280D7A
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 11:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A1E155A53;
	Thu,  3 Oct 2024 11:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WbDe+GRa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F5B10E0;
	Thu,  3 Oct 2024 11:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727955077; cv=none; b=TUONC3zHy0t6pSTUw3acX6ZR/Ilk9tr/PJlYvoIoVRRh0M052tgxHOQUlv5AqunDF5Oq4knl1QphNv7tQj/q3w+kmWFmOA6dccT/N64/JMHqYkNH6w1G7dMy8S0UcU3b8OqHZvpGdskeZVkbANlmbiBs/Hynd0K+wXq76OX8FJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727955077; c=relaxed/simple;
	bh=dPHtbssT/NfJUfG2R3Ok7RLINFOaiqY1cVbe7NbvboI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGbB/udtAK+TS5qlfEaNoDr8VTd2IzTTaMJw19aNCX2RGl2quJX9XIw6U7Jr+2K1MwqE3u2RSL2gc2bZxDPE/fOPyduGf5cxYZ9UrEjNP21LodDXq5qpU9y0HZ9FxCLQMJyqhHvjEEb36vySW2FdKguYaxFGdYQp5UQaslovt00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WbDe+GRa; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5398e58ceebso883028e87.0;
        Thu, 03 Oct 2024 04:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727955074; x=1728559874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LGgGQGbdcBITdaCsGfvse9I6NkHWAfU3zmrPhGTl0so=;
        b=WbDe+GRa9p7/sKBpsgsMThEG3D8beTjBAddv5rUUrBS8d+l1dqYj5XTxPqUUK101nz
         DFxB0yPOOBWh5lclohmFwC7Z5CRfoWD/P1ZCip66BL0G25sFEC/6F7XvPIGY43iZG4/M
         6KKPDqoB4MBC2VEz61mEtjycHmC69JX+kVxpT1r4HGC6vXTisNAl0gjOpzlgbRuXL77Z
         UeD1JhNIUwdtg4/emjVNXdrz8jbwyaJLtKr6juep5XT0oQSLIpAvjTDw+acBNHBoP9qx
         saV7Pj4CYth5+vJBUMxTvnk5cS6L7Y3jaXD/l4et+DU02QZ51HeEySTS5o0F4hDcDNJz
         CnOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727955074; x=1728559874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LGgGQGbdcBITdaCsGfvse9I6NkHWAfU3zmrPhGTl0so=;
        b=Uocg82Z/pusgBd9KPdqvQkVUO4oXW+6nfuupbiowcU8NdmyjkbWWeD5qjgxPONi7dV
         M+elZeuohhwLKpRsLyKy7ntBpmQXMpzoSPj4StxWYgAOsgtxKqs+gz7b7Cx6eZr4vDMq
         F/9IdjmXf8ya7E/SsTli32Z+uUlb0MeVw++JfVo8XhlRTpLqLGItKz/g+uRyP3TBTSaW
         c5ituPCMkNzsrzG6sdYJMU0+CHaJS8Qs4DY794v0evsUivM55iXq3QH4/Us+5w603NPG
         9h51Vx6ETCtN8XX80ibgVLLIgMHHO4/cLW2rMbrboSvl8FUdi22j3JNkV4BPxeQ5m/a9
         oZdA==
X-Forwarded-Encrypted: i=1; AJvYcCU4BzcE7XcVTH+z9OOJVlzpwGxjKb5SZn60p6rXNeE8ulnwjfwSBNxUC0rjDjcPepbrM6Y=@vger.kernel.org, AJvYcCWjY03a5aGzZGYyFDTahmPIEbkfPbm1wRoRzurhfUz6a+v4JUW2EhrfKPb3mUeev7/HS7H0eN9oDcZiO3OU@vger.kernel.org
X-Gm-Message-State: AOJu0YzUQ9CdddrrHAXPXK/fGt+uaYP5x2+wVnDeuFEXhyMlHm5xXGrQ
	3PSM+xHhBg1GcdeT02oi/YAbucfRWmPYdyuT03RDA+taTmowBy/W
X-Google-Smtp-Source: AGHT+IHDBJJJkhVZ4zol7APNI5YIcYH9QdNSCLSVIno0G0gjDlcotlo7GFg5T65cfp2+5zcr9h9/DQ==
X-Received: by 2002:a05:6512:a8b:b0:533:4784:6aec with SMTP id 2adb3069b0e04-539a627691cmr1075184e87.27.1727955074073;
        Thu, 03 Oct 2024 04:31:14 -0700 (PDT)
Received: from localhost.localdomain (2001-14ba-7262-6300-e292-a4f4-185c-9cdf.rev.dnainternet.fi. [2001:14ba:7262:6300:e292:a4f4:185c:9cdf])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-539a8256af9sm158105e87.94.2024.10.03.04.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 04:31:13 -0700 (PDT)
From: =?UTF-8?q?Markku=20Ahvenj=C3=A4rvi?= <mankku@gmail.com>
To: seanjc@google.com
Cc: bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	janne.karhunen@gmail.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mankku@gmail.com,
	mingo@redhat.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	x86@kernel.org
Subject: Re: [PATCH 1/1] KVM: nVMX: update VPPR on vmlaunch/vmresume
Date: Thu,  3 Oct 2024 14:29:25 +0300
Message-ID: <20241003113050.22875-1-mankku@gmail.com>
X-Mailer: git-send-email 2.44.1
In-Reply-To: <Zv2Ay9Y3TswTwW_B@google.com>
References: <Zv2Ay9Y3TswTwW_B@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Sean,

> Talking to myself :-)
A good monologue. :)

As you said, PPR is updated constantly with kvm_vcpu_has_events() anyways.

Actually implicit updates, especially in kvm_apic_has_interrupt(), makes it a
bit difficult to follow when these updates take place. It is quite easy to
accidentally make an update in architecturally incorrect place. Could be
useful to make it explicit.

> Assuming it actually fixes your issue, this is what I'm planning on posting.  I
> suspect KVM botches something when the deprivileged host is active, but given
> that the below will allow for additional cleanups, and practically speaking doesn't
> have any downsides, I don't see any reason to withhold the hack-a-fix.  Though
> hopefully we'll someday figure out exactly what's broken.

It fixes the issue. Thanks a lot Sean!

Kind regards,
Markku

