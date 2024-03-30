Return-Path: <kvm+bounces-13145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C0C892B26
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 13:18:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB59B28347F
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 12:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51CB239AF4;
	Sat, 30 Mar 2024 12:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ojjni/Q/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEDE2D057
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 12:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711801116; cv=none; b=D0mvhF+BbPWPDcAdiwkyws/fkbrfScxSmeJ2DlnXCt+XPgzpTQZPqWctGu9RbM8G793xRdS6TU+0hIObWSy7lilMqRhJUjJlg1J+knKscAzuigF6gsp7brDIakdr8vPaWtVUE2VFBJhkCPBo5BZtedpOTUT1U+Kmo7G9+hyJ/pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711801116; c=relaxed/simple;
	bh=rbWiV6LCoMIz4RT2OXgjrkziWWWOn2fBooEuycqpBRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z12z0IztQNJM0RXTp/tDMnCLkHHW9DOovfPqTZX+Mq1d7PvDEDTb7x3+VuEQLJrgkPgKF3lQW9nyqsRWYDMAUaIQIGwG1njod3oRu0m5XLnbPn99Ams40F9qevdNaxzkTnLYdf4AFhrBB9GzjfWh8nIWeeMHjmqRvEKTBV7CpAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ojjni/Q/; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-34100f4f9a2so1890427f8f.2
        for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 05:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711801113; x=1712405913; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bH0VKkyLThWY6MNf2JTOJyg2yMbF29kM0ZaMHkLqmAQ=;
        b=ojjni/Q/9R/6bhVvsgJxLjTKCi8WFD0JlJwhQOIBckIXzdlhbO7wL4EZgBYqsUvaZT
         p1ZLA95dQuMKn9OOgkb6+7978yyZjvV9elHb/pkYELtPiIn6wE2NYbYPbhgc3RDWKqt+
         alfhQ3vN1HVIU+X6GVyrOkwLoGywxlt8rXZC9MUmshj1o1wJyB/ycLUDhGdOzz+YprU4
         qwAUo8JutiBjqTvPgJ8Sl+8dsVuy+3aPzsYACFdtmFww9z4hslKpO5NQGQRyEBuvjohg
         xWAxz5/cmoCUZE2rBuQ96riN+F/6XgHVAOczdgecIrv+SI3L3eYzEiE4UyJ74FxvTeEt
         atCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711801113; x=1712405913;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bH0VKkyLThWY6MNf2JTOJyg2yMbF29kM0ZaMHkLqmAQ=;
        b=UBAqlAEYoU0SpxLNN1R1OWIHW07Qvmqxa5MVqQStyLl9lRi6D6QTruINS80g6/0Nwy
         Y23m713ztkT0ZWw04edX9CU+V0sGGzvQku+BB8oN0izuFQOuNTtYQZtOJ8O5S2yzdh4/
         drxAva8vVjnI609/ZNPBrtGXDqElGeKXlHhaXM4WC4Lia93+TQBbdWT7aphHheNvTlKg
         DBbJMGbZybNZP31P65PqwQF1c09cTM31X7OZ0Fs2ZrlL03TrOGNLr0jTs7MGHUpDfODX
         9LRWnmk4bxxdu0qTsBkKchx6xXR8AXZAk9Q2VSCJoJlDTnLKbdbgTEyyRHPaS4F21MYa
         /Smw==
X-Forwarded-Encrypted: i=1; AJvYcCUsgWR61I1qUY2nVvJzkDTq88+YvVwP+1RBc67i1LeYisJXch9a9uz7olzwEHKERrkMLGldpf6m70vqKZkIKRwU6Edp
X-Gm-Message-State: AOJu0YxymvSD2RCmx08rc7XBib2mhieiWGmkngFObkyEg2I3kHmZMmSx
	FxPb6zYoJIkEkvXEJKI+4ejsS3LhZLkrKwtyfp9hLp/d0lJcOwYfIlilpx5FAow=
X-Google-Smtp-Source: AGHT+IFXTj6Oopp+TgXdXNYNRNf/PPJajmoyEILRHRDR4VAErFFTxd6mVFOMxvFL+RdoGqW9r8ISHg==
X-Received: by 2002:adf:ecce:0:b0:33e:9292:b194 with SMTP id s14-20020adfecce000000b0033e9292b194mr3243693wro.14.1711801112726;
        Sat, 30 Mar 2024 05:18:32 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.223.16])
        by smtp.gmail.com with ESMTPSA id bl37-20020adfe265000000b0033b87c2725csm6349947wrb.104.2024.03.30.05.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 05:18:32 -0700 (PDT)
Message-ID: <f514d9e1-61fa-4c55-aea1-d70c955bb96a@linaro.org>
Date: Sat, 30 Mar 2024 13:18:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/19] amba: store owner from modules with
 amba_driver_register()
To: Russell King <linux@armlinux.org.uk>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Mike Leach
 <mike.leach@linaro.org>, James Clark <james.clark@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Linus Walleij <linus.walleij@linaro.org>, Andi Shyti
 <andi.shyti@kernel.org>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Vinod Koul <vkoul@kernel.org>,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Michal Simek <michal.simek@amd.com>, Eric Auger <eric.auger@redhat.com>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, coresight@lists.linaro.org,
 linux-arm-kernel@lists.infradead.org,
 linux-stm32@st-md-mailman.stormreply.com, linux-i2c@vger.kernel.org,
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
 linux-input@vger.kernel.org, kvm@vger.kernel.org
References: <20240326-module-owner-amba-v1-0-4517b091385b@linaro.org>
Content-Language: en-US
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <20240326-module-owner-amba-v1-0-4517b091385b@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 26/03/2024 21:23, Krzysztof Kozlowski wrote:
> Merging
> =======
> All further patches depend on the first amba patch, therefore please ack
> and this should go via one tree.
> 
> Description
> ===========
> Modules registering driver with amba_driver_register() often forget to
> set .owner field.
> 
> Solve the problem by moving this task away from the drivers to the core
> amba bus code, just like we did for platform_driver in commit
> 9447057eaff8 ("platform_device: use a macro instead of
> platform_driver_register").
> 
> Best regards,

I tried to submit this series to Russell patch tracker and failed. This
is ridiculous. It's 2024 and instead of normal process, like every other
maintainer, so b4 or Patchwork, we have some unusable system rejecting
standard patches.

First, it depends some weird, duplicated signed-off-by's. Second it
submitting patch-by-patch, all with clicking on some web (!!!) interface.

I did it, clicked 19 times and system was happy... but then on email
said the patches were rejected. Couldn't tell it after submitting first
patch via the web?

That's the response:
-------------
Your patch has not been logged because:

Error:   Please supply a summary subject line briefly describing
         your patch.


Error:   Please supply a "KernelVersion: " tag after "PATCH FOLLOWS" or
"---".

Error:   the patch you are submitting has one or more missing or incorrect
         Signed-off-by lines:

         - author signoff <krzkreg@gmail.com> is missing.

         Please see the file Documentation/SubmittingPatches, section 11
         for details on signing off patches.


Please see https://www.armlinux.org.uk/developer/patches/info.shtml
for more information.
-------------

This is unbelievable waste of time. I am not going to use this tracker.
It's huge obstacle and huge waste of submitters time.

Best regards,
Krzysztof


