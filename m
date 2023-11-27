Return-Path: <kvm+bounces-2481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 143FA7F985C
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 05:33:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C0661C20858
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 04:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16CAD2E2;
	Mon, 27 Nov 2023 04:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MCaUDmX5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553CC111
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701059598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oHPnN7jOaxBckPN1TMsb7lbSpEfJL8WREqjjpAz2omM=;
	b=MCaUDmX58HU3cIzhxa5tcOmrcw9fLNs4VOEXt609aFavJgIjwgfXKZH8qKhPHMT+cCzQ4q
	sTPHmQa6cMnCjzRq6Bg7jkHbZJ8y09Iy5Z4w1RixmwufvUMqBnr03miuOvZUnnTqOvt5aB
	gAjmuOI7etI4t3etjQLuwY+UJwyt0po=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-toW7RtvcMHC2nY29dcJtmA-1; Sun, 26 Nov 2023 23:33:17 -0500
X-MC-Unique: toW7RtvcMHC2nY29dcJtmA-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-5cf4696e202so18542347b3.2
        for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:33:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701059596; x=1701664396;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oHPnN7jOaxBckPN1TMsb7lbSpEfJL8WREqjjpAz2omM=;
        b=JVCqZ5WYM1cNkpByZyXx0KnAxtaEH7qPAju1vp4qpeX+0nRVVY11CrVHwhis+i2Fta
         mA0Nv7xUZjMLmy/D8rTIkOp5hjHUePx1wXlf8trlq79US7gigxTcMuKwRDkEUuGp5KRk
         wb+YrFrlN3wuQamsshmQM/oih3lOuUUcAHgbHX8n4PRGChxaNtQyEczeXBo+3uGpcVVb
         U7oJ1KeXyjV0nX1MQHmPEnEFh9oDsvUsnFiOZ6GDEqgXeuDVp0EhZvdB8nlOQyn5gl8O
         tw7bmSZcFViWyLK56OBGwouih1q6nwuCEE6QPgyRaURmWiu9srXtJH9vXfchIB7H0Wl+
         QGdA==
X-Gm-Message-State: AOJu0Yz45Vir/z6LXEMxbd9uwGNTiTs2g2DYmEUOJL8/z2dmUdKu8tYo
	SWZGhwAf+anFpBWKxtSm9KM2kh3RQxya0e+t7vsC4W6ABl7hyEoYRFT4LBT/2MrMTmITC+sfbHS
	xt9Ex+m33iSd9HmOF+678
X-Received: by 2002:a05:690c:886:b0:5cf:2d42:a61a with SMTP id cd6-20020a05690c088600b005cf2d42a61amr5226722ywb.29.1701059596629;
        Sun, 26 Nov 2023 20:33:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IExAiSMqRjB50PeEjSiH9Pkz4G359la5QiMaObaf5fX0Jc1yzEkfIjWDDVfzCTQ8714OJhDDA==
X-Received: by 2002:a05:690c:886:b0:5cf:2d42:a61a with SMTP id cd6-20020a05690c088600b005cf2d42a61amr5226712ywb.29.1701059596383;
        Sun, 26 Nov 2023 20:33:16 -0800 (PST)
Received: from [192.168.68.51] ([43.252.115.3])
        by smtp.gmail.com with ESMTPSA id s13-20020a62e70d000000b006cb8e394574sm6373833pfh.21.2023.11.26.20.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Nov 2023 20:33:16 -0800 (PST)
Message-ID: <6d71859f-e519-4afa-881a-f1db8ec8ca90@redhat.com>
Date: Mon, 27 Nov 2023 15:33:13 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 14/16] target/arm/kvm: Have
 kvm_arm_handle_dabt_nisv take a ARMCPU argument
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <20231123183518.64569-15-philmd@linaro.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231123183518.64569-15-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/24/23 05:35, Philippe Mathieu-Daudé wrote:
> Unify the "kvm_arm.h" API: All functions related to ARM vCPUs
> take a ARMCPU* argument. Use the CPU() QOM cast macro When
> calling the generic vCPU API from "sysemu/kvm.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/arm/kvm.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


