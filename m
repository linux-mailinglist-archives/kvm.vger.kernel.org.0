Return-Path: <kvm+bounces-28386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DCFAE99807C
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A9111F27463
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3EBF1D0402;
	Thu, 10 Oct 2024 08:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ByHuX7a4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD161D015E
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 08:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728548856; cv=none; b=oGfwWWrCMQRl8ztvssCklqlbak+IxUKnhyFJQeRrsnQhoUeCzOGvJXCVkWbadC5aC4cSucn9dhHmunn25qdbJZYMLlQXfDsVWI467Zuc0CDkUWwAZomugruoN+wwZvHp6PjhEgkYUuyLZ6LBJwBkAflxgrk08prgckTQWoEL4LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728548856; c=relaxed/simple;
	bh=UH55OCJxYN3lzn1SV9XugqIcRslFrGwqUIw0VVLXDM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rdylUouKA/tY1o+LwieZk2Kz58Lkgszuol5eRl9djBwghg0jVh0bvxv6HKUGJqvoPtQ49wBeRnn/NHQRphYstICGe69aDBNM5MW/2n6TgpVOSMt7lXFLGpMJgM4Q5HSIPd/s8nG81SKaf1QQbTvW7W0VDLcl21xTCDfmwWbFRgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ByHuX7a4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728548853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4WI6VxDWedosYSNCVHHfFlDuz1+hFQsSxUm4i7PVBCY=;
	b=ByHuX7a4HC2xyT7InNyoRdlGEDGUM8jurObTnxI8pA6+BYCBy2a0ndvzW02ovyhAEfdo2o
	1Qml2R5NlkiEq6dPSkfTXr8XgzTZMRhMS4kns5R5/7kq73lTfvB6U2b/JmkNKBJNHnZMzZ
	4wQHuAt1pVVy0B5uBiJE3s1DPMZDsww=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-PjiphXuPNiSA8_ExiUh2Jw-1; Thu, 10 Oct 2024 04:27:32 -0400
X-MC-Unique: PjiphXuPNiSA8_ExiUh2Jw-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5c9217064f6so436654a12.3
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 01:27:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728548851; x=1729153651;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4WI6VxDWedosYSNCVHHfFlDuz1+hFQsSxUm4i7PVBCY=;
        b=aCLqX8K/IWsQPfv15AtANN+LGD/rNtL5520cye3bBl4XrAgXEG05yiJNgtsnMOdBx7
         xyCjaigOcIp+ojzc4cd+6c4sI1s3gXMEdF+PYQ968R2xtriP4M40zA9UVzjSMedxVaRK
         LVinOEseMbsLarywgTTAkVnVq2gIqS4DhosVv1nORD2WpTrNfm+dXy3U1JREaGJb3d+g
         VT3nhpc0Biy9fNmfVkHgSf7ycQkSE+K2M9h6lsfPoKzHyk82gWP49F0hmDG7SkVFQq8s
         lCLYatx6EvkerMz/0EV70/93BYc/uJMpAX2E1GKCxZcaOKf1936liJFIPFnMcFVCY87Q
         81Ww==
X-Gm-Message-State: AOJu0YwVuSVY04xri/yOATcilAEZGFZuYOoDUhlDi6Zu+J10tRraALGS
	J3hC1sTcj052ZtMii472rj1/uTfJf6Jcn08SEiRjUY+abO7j2z6SvsbHFTkug4ObV2WwcNrlnyb
	jTu4CuCWi+FGTkOY25u5cC7HaJlVQDFTUc5WEEcLTzdtW7NGQYg==
X-Received: by 2002:a05:6402:1e8d:b0:5c9:2adb:1372 with SMTP id 4fb4d7f45d1cf-5c92adb161cmr2328736a12.11.1728548851070;
        Thu, 10 Oct 2024 01:27:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH82RxmbfgkXTvIViTsYhkNvct9kcXFOx8uMhsKbMXT7Jc1p9+f5SWXZcvDUV/6biLjAuTLfg==
X-Received: by 2002:a05:6402:1e8d:b0:5c9:2adb:1372 with SMTP id 4fb4d7f45d1cf-5c92adb161cmr2328720a12.11.1728548850616;
        Thu, 10 Oct 2024 01:27:30 -0700 (PDT)
Received: from [192.168.0.7] (ip-109-42-51-26.web.vodafone.de. [109.42.51.26])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c9371515a9sm458587a12.41.2024.10.10.01.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 01:27:30 -0700 (PDT)
Message-ID: <5a0b1ad9-17d4-4970-9caa-3317445d0d2a@redhat.com>
Date: Thu, 10 Oct 2024 10:27:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v1] configure: process arguments not
 starting with dash
To: Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
 imbrenda@linux.ibm.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20240913085709.122017-1-nrb@linux.ibm.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240913085709.122017-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13/09/2024 10.56, Nico Boehr wrote:
> We have arguments in the configure script which take an additional
> parameter, like --host-key-document. The syntax is as follows:
> 
>    --host-key-document=PARAMETER
> 
> We always expect an equals sign (=) after the argument name and the
> parameter.
> 
> If the user omits '=' between the argument name and parameter, both
> words will be interpreted as parameter-less arguments.
> 
> This on its own is not a problem, since the parameter would normally not
> be a valid argument name and should hence lead to an error message.
> However, this doesn't work currently.
> 
> The configure script stops parsing arguments when an argument starting
> with something other than a dash is encountered. This means that
> specifying arguments such as:
> 
>    --host-key-document /tmp/test --gen-se-header=/usr/bin/gen-se-header
> 
> Will actually lead to --gen-se-header being ignored. Note the space
> instead of equals sign after --host-hey-document.
> 
> In addition, --host-key-document only verifies its parameter when it is
> not empty so we will just continue as if no arguments were specified in
> the case above.
> 
> This can be highly confusing, hence consume _all_ specified arguments,
> even if they don't start with a dash. This will lead to an error in the
> case above.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   configure | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)

Thanks, applied!

  Thomas


