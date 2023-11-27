Return-Path: <kvm+bounces-2466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57BC77F980B
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 04:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13F46280D4D
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 03:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED56746BA;
	Mon, 27 Nov 2023 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="golyUZX0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89122127
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 19:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701057291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n/B2oeugV7rvsBl26QiNw/HUulmxvWDTO/1LAtO/5B4=;
	b=golyUZX0CJfbeXruztWXdFKEbm5lEixzqWikXfJm0iWs2Axm1HUnXSNSgZkmr9dDPd8NMg
	yebg1tq1JHo8lgFEz00m4B0BO1y6oeawCfgn3LeLiUwjWyeWWlDRAHODAxtGul+FCkyubE
	eGbpOhsY4WCzmjkKIT5Cx1qoaxqTPrI=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-7fYcutbZOYS0NwsrUZa_pQ-1; Sun, 26 Nov 2023 22:54:49 -0500
X-MC-Unique: 7fYcutbZOYS0NwsrUZa_pQ-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1cf9db1ac0cso33446135ad.1
        for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 19:54:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701057288; x=1701662088;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n/B2oeugV7rvsBl26QiNw/HUulmxvWDTO/1LAtO/5B4=;
        b=WCeTa6ylXM2so2q1ir2zX7Lx2M8HvPzoCy8vDJKrN24Ks3e+4D/MPpBKIZB7lcF8vY
         2a4bWWr9vnwAtItwJEXwczrg8ctKUopmuOsAj1CvnHFR7DJsT4SYUzmfSgIfVsRyc1HD
         pUSVU1BOit5JFFfEQXGDyRrwb6bwQe2Rodm/wugGfhAZcUjzY00PEvaaUlMoZJKn4wIx
         TV9PLmuak47sgVQsp1y3zcPGsiYWjv8TfW0+jvgQ7tFDJmQiTFEe4nIjRs8GzPn0SBLx
         lla2UpPvLYebU3xa+YbuYWrqTohxQQM+oeLoXn7xJ1+oFXBQXcThnCllpimvqJJkA1+G
         B/8g==
X-Gm-Message-State: AOJu0YzGhZQPXQP+AgN5dFIXmHAo1RFWUFIMfnn01Z+1hS+KaMdTAX3d
	u5OgFvqTX5WUJoTKoutsi84FfUNpxDR3kFf+ctWQFUGvmhwl+AbC1KPYt6JlBGk8NagfAKXirpR
	bPLWpyRt9UeBQ
X-Received: by 2002:a17:902:6946:b0:1cc:4fbe:9278 with SMTP id k6-20020a170902694600b001cc4fbe9278mr8703248plt.50.1701057288539;
        Sun, 26 Nov 2023 19:54:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHbVGuXlFhscebc296SQxZkjGJOTVtO8/tW/4/UC9LRQVEKcwKp2SqH21GWO8ErPdmfwEPtiA==
X-Received: by 2002:a17:902:6946:b0:1cc:4fbe:9278 with SMTP id k6-20020a170902694600b001cc4fbe9278mr8703235plt.50.1701057288243;
        Sun, 26 Nov 2023 19:54:48 -0800 (PST)
Received: from [192.168.68.51] ([43.252.115.3])
        by smtp.gmail.com with ESMTPSA id r4-20020a170902be0400b001bb99e188fcsm7129948pls.194.2023.11.26.19.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Nov 2023 19:54:47 -0800 (PST)
Message-ID: <f8e7ff04-dfb5-4bdb-8bce-ce34b9539c7d@redhat.com>
Date: Mon, 27 Nov 2023 14:54:42 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 01/16] hw/intc/arm_gicv3: Include missing
 'qemu/error-report.h' header
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <20231123183518.64569-2-philmd@linaro.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231123183518.64569-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/24/23 05:35, Philippe Mathieu-Daudé wrote:
> kvm_arm_its_reset_hold() calls warn_report(), itself declared
> in "qemu/error-report.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   hw/intc/arm_gicv3_its_kvm.c | 1 +
>   1 file changed, 1 insertion(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


