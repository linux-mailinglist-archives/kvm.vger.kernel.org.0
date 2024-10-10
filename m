Return-Path: <kvm+bounces-28429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89C97998ACA
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 17:02:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7468EB31A4A
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 14:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CCF41E104F;
	Thu, 10 Oct 2024 14:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="By2hAQo8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F7A1A2643
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 14:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728570029; cv=none; b=seicWw7JCDSkzM10e69fKXBgw6aOk1bJnV9nhZY1mF3w8Xye3tK/yfa+25cyP/oYmZotOzqzT24cqYRUVMnVJaSxT7TNRjVqQy/W5eCd6/1z44Ez6Cg8LRDBdlsirnOVS6cuqig2KsbjnolecG2YM0dTq1xfvUDRqUlzhSsL1Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728570029; c=relaxed/simple;
	bh=0m9SqYCySAqopdZchO2z9y9ImtwfVto6iw57ZOvn7+g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LjTwHIJYHujiDrn1yoPtuGUy7jMQqcjeE17AjCgDwA6cUZzZh9WWsOA4UWDo5K4GHCrMwnFHbeLALvwrk87N0FAq7Mlkqcdo2U7RVYYW231982EKhAvEAT0A4U/YC9jBFbtTJJZUVG4O/uZPjHSbp/qYZztSvORRC7HFD7kypis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=By2hAQo8; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42f6995dab8so262675e9.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 07:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728570026; x=1729174826; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+w8CJ/RDPjfeti6YgAdBDMpo2FJOpLITD1r8p3bqSw8=;
        b=By2hAQo8v3pmaWMlLD+GAgVmHSHCMlJm6InURjiUWzcNrq+vvfRWKo85mR1NnRwLiV
         Kn71V1a6oLAn751bJmKXJHsnV8t4PN4x/7q/R3pOXhtuM+AEKp1o8Wz7343O6njQqy1o
         SRGUjs4Hf3gKir0EWqjOL012thLAIXK3Ke61DgrgzAAz6XsqfGhtgrlmHzAXXYvGuIVZ
         hl6CgeOnjuIQ2jhI54U4DuiV3S57OBv0FzqXiB6W1v6/lNgqHT04jrsjKWx0YhxfF26u
         KWYbVrji8L8ykz8HEPa+gaFqBILweskH66gNdotoVgnmgs+y8iUo/G+qqT7tvKtDQie1
         sRHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728570026; x=1729174826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+w8CJ/RDPjfeti6YgAdBDMpo2FJOpLITD1r8p3bqSw8=;
        b=Yq6c56RgCYhWhhuWWafTtPu5qJHTpGME3X6YfLXIXk/7U8X4zbyfLAyexfOL7G3oWh
         W74r++DoGnQ8Dd2H1vJZkGu2J4vSjJDX6ek/Imtm0vK2O4nNFP6Z3KhAlfYaZUtpsBfG
         WfbRFQ1mdT8VhWsDXgaDlF6QV9gSe341lR1KFGFye/V3UHyAWn2omGPf5idJFPOZ8XUc
         APmEgaQizb5toEgcpTcm96zgtFeR6FtcN1Zs7XefkyIxW3+SPMjWGBjIzaitDHtyCtaC
         U0be6h99nH+bAzMSSnGBsQVtTU74n893lifSe3IhmDtgBuq96bSQA3KD9WvB3AojssAs
         thdA==
X-Forwarded-Encrypted: i=1; AJvYcCXzVSLK8nzoSBsdUVCmiTtmsL7yxN7kZE4DKhngq9BtgCdrkd8nyaXp2/bpwYbzDSheZiE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz798RTXdyjUC/uznaxJryoryISLeu3PwFHZZHLXagAVRRocIQo
	FZH0EPJFfOF74yWYqp++Ut3WJ4xye+j+Wfr9hEF6uQUl0wR+fu0nJwSdzXWM6UlE9oMa85Wh/Dh
	qNvXh+ufPir9aNs717KVvSM3I/SMOTXyP0T0JeT+0MCzRPUylMw==
X-Google-Smtp-Source: AGHT+IEq2nGzeSwcLcS92pWHCevoS80XziKTpELRl2C6cml/HyK+2ePkab9udoIZsfn5KZRDKpnyzsqMDxFX9pcb3R0=
X-Received: by 2002:a05:600c:34d2:b0:42b:8ff7:bee2 with SMTP id
 5b1f17b1804b1-43116e3608fmr3673255e9.5.1728570025862; Thu, 10 Oct 2024
 07:20:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
In-Reply-To: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Thu, 10 Oct 2024 19:50:12 +0530
Message-ID: <CAGtprH848Q=RMuOvjvPGPZYhjEmZYAF-Mos2otqKKLv8+TEcMA@mail.gmail.com>
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
To: David Hildenbrand <david@redhat.com>
Cc: linux-coco@lists.linux.dev, KVM <kvm@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2024 at 7:11=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> Ahoihoi,
>
> while talking to a bunch of folks at LPC about guest_memfd, it was
> raised that there isn't really a place for people to discuss the
> development of guest_memfd on a regular basis.
>
> There is a KVM upstream call, but guest_memfd is on its way of not being
> guest_memfd specific ("library") and there is the bi-weekly MM alignment
> call, but we're not going to hijack that meeting completely + a lot of
> guest_memfd stuff doesn't need all the MM experts ;)
>
> So my proposal would be to have a bi-weekly meeting, to discuss ongoing
> development of guest_memfd, in particular:
>
> (1) Organize development: (do we need 3 different implementation
>      of mmap() support ? ;) )
> (2) Discuss current progress and challenges
> (3) Cover future ideas and directions
> (4) Whatever else makes sense
>
> Topic-wise it's relatively clear: guest_memfd extensions were one of the
> hot topics at LPC ;)
>
> I would suggest every second Thursdays from 9:00 - 10:00am PDT (GMT-7),
> starting Thursday next week (2024-10-17).

Thanks for starting this discussion! A dedicated forum for covering
guest memfd specific topics sounds great. Suggested time slot works
for me.

Regards,
Vishal

>
> We would be using Google Meet.
>
>
> Thoughts?
>
> --
> Cheers,
>
> David / dhildenb
>
>

