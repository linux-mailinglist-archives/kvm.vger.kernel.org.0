Return-Path: <kvm+bounces-44963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D29E3AA53CF
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EC213B7FE1
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3F226658B;
	Wed, 30 Apr 2025 18:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZSEe9yWZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A06C264F96
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 18:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746038222; cv=none; b=Qx+FoV0/DmXPTJtnY0FrtlQhS9PRoDoV3b9ZFnPs20QvhHJz8lvH7+zZBK7iYw07YA7rEfaM8ugluw8/KMui/h5qdiJSjR7mazqKQ/0vT7Qy1IPuFf35e/ygxGHRLynWW4ANh3+DtUGur9PYZ86KRxqBjdkGdASW8vRPRgP5CmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746038222; c=relaxed/simple;
	bh=0rEfSf1sT6F8atJ1jcs2i+ricYxs2o/T7BRX2EF3IXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jciUkUwVNZEEmQ7wVV0iaASTOshZxwdwKFrjvQLKBHU5ticS6X0kkOIeDYYS0uU9QHrbYnUA2/YpPC2GSz6cDNSd/6qdaRJaaGEedTJqyuGD8Z/HszWPhS1YA8exYMn+1YIU2BkXyuH9iJ0wDk6l7udi95RHEGD2nqdRz56A3yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZSEe9yWZ; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22438c356c8so1844405ad.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 11:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746038220; x=1746643020; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qI0Qr3sJ8BWLNtDXHSs21GX1niptxc6s+/cv7MszLEM=;
        b=ZSEe9yWZEwZ3xI1Naw1C9C+up2S46Zzwi7zhPtLqZ8s5r7/6i2lMgdeMajPcBEf2Df
         F4Xk9/DxpLW8wWRzO5BC0CHywBur089cZDSA9izXcVNYJmUjQ6/b1VGwussdPxXBLp5B
         uUBFh00kDoQgi93K1av0vfjX9rbWxCPdaF8XJ2/dgXzf47flo561+MQJgcqHFx73x8VN
         /YD+bX4ytbsQyMxA//qmSkkMT8DSSSb04Gb6/BKGxGrVOtl4iMQUEiZ7D36RktNTZUuD
         H1O4JF8JTsWV91NwNEr6/wTX4U0ojRsDWzbdRKtwBTjlSvJIvHmoiOG8k4vHx3svlM6p
         6xrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746038220; x=1746643020;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qI0Qr3sJ8BWLNtDXHSs21GX1niptxc6s+/cv7MszLEM=;
        b=WdDPyJxKIB5MLUeBACYe2UXu2BPDIeMnvYtgevej1N/by/YsQqaZWZ/q6rOSCDo71L
         gHiHidI81d3Vr9siLpO26turveGaWKt5jIUjGTOsxk0Vbj8OF4wcMvwWFzqW7U4hez55
         /L8vsL1Ycai4xpEzrm3IHpHYPDzMqwT1vmtrYZGKbxbz/VAUcMr9wp97eLSi0wzGlJVl
         ZYXt0HGrNohy/NdijfM4qmSyQLiTF4uxIH+Jv4oswRLMdBwf5c/au6UExXjmwI2E9g34
         XtmNquVeIjOCn/QtrVj0qmEivDnLZxZlGi2dGaTXsHbDWq3CJzpEjBRhH6NUjLgnJyl+
         J3UQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTpYE1JbrXJbkNoC/rItnS/CSHg8ZQLPZkacStlm4e8QYIWkQJjPgfDLCDsb1nF8leKQE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe1r7UVOYNFMMeh91zbARlDQUUyGn76BrlbYgoHQw5Mp1XIEDo
	z3bL4pbL4I8CQ3hbDcM9T5qY02awtmg6M8YJ+uPStAjvtXdnSbMfaz3lgfDJo9s=
X-Gm-Gg: ASbGncsAwk+O7hNK4ITT4Qd4u8wEMyCfBu53qOCW0oyZ4epVOJvlqxMbmlOmfpkPAaW
	sYS8zeTutcVxbjXL4xRJ6nH7DWRftxDoEof1FUQ+BBamZvn/O7Is9UDhPJv/eNgW/PIpMb5m4KA
	59EunZ/7Kc+RSrf5z6At8iC8540Eh30dRdcGf7/diy97o4cVQOENJhL5FkbzTz81y8oGgIJ34mJ
	8Rt38TaYF7ALZpHR/s9Ev/54ATwNIUb3NSeRxLaTmPpUXgK5bMLCoxS9Ax0b3XRfy3MajYzKFNg
	OhynipLiZh+0NjnUt6Meubxiiv0vFCjLMfYsVrLIDgSocJdfqk+H02RKueW5R53nr8ieBZ6F7f+
	CSqC63R0=
X-Google-Smtp-Source: AGHT+IGYbEHufWt5jICpxhqSqovtwuspnzbcMjk29p/zyq7TxbJGOo+t2blgF/vfmRVoKNrbNlUnDQ==
X-Received: by 2002:a17:902:cec5:b0:215:acb3:3786 with SMTP id d9443c01a7336-22df34d5d89mr65461035ad.19.1746038219834;
        Wed, 30 Apr 2025 11:36:59 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db510272csm125428715ad.177.2025.04.30.11.36.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 11:36:59 -0700 (PDT)
Message-ID: <01400e4b-dbe3-4ea0-ab7c-3acc726d52ab@linaro.org>
Date: Wed, 30 Apr 2025 11:36:57 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/12] meson: add common libs for target and
 target_system
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org, anjo@rev.ng
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
 <20250430145838.1790471-4-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250430145838.1790471-4-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 07:58, Pierrick Bouvier wrote:
> Following what we did for hw/, we need target specific common libraries
> for target. We need 2 different libraries:
> - code common to a base architecture
> - system code common to a base architecture
> 
> For user code, it can stay compiled per target for now.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   meson.build | 78 +++++++++++++++++++++++++++++++++++++++++------------
>   1 file changed, 61 insertions(+), 17 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

