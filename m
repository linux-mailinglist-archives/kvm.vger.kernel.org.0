Return-Path: <kvm+bounces-11553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 939AA8781DA
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 15:43:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49F18282F2D
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 14:43:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862E94087E;
	Mon, 11 Mar 2024 14:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MWGxxpLO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFE13FB8F
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 14:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710168171; cv=none; b=VQSFMoJBjHR0RpU9y/2dW3Y4iRBzWLq7U0HoCMzCQIqrKMGn01mZxelD11/MfqJsT/C3jfLiJJuJKu+zWWkUCfpdfChEervbFUd6ijNWWKlpfm0nagVSwr9htkMkUjSR5Apf9ohBHasL9sTYXnGb7pdsHt1EEzoAqQKmThBnQ1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710168171; c=relaxed/simple;
	bh=A3oQXxWzlMn1lydUi7NGqY9tMDrbtGOIZKyu+vUBslQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p2edjC0sWhuzd6WihJFLaZJX4e2DQVirP/kP5nacsYTYUCUiZMZPuybRRqpOgpxzRiOWWC5C8Y7zFfwsz8fdGzGpV7HNqvy+nLwTYVxiDmZCML+q4ETEJy77EkIFNjngFGXUEvXOB+eO0jyO44ivkkIXZJRC+nW7Ov90f+GEEcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MWGxxpLO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710168169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GxZ9fFFPslO+OLKMfpAr9nGvMTH6LktDGeSdQkQFB5o=;
	b=MWGxxpLOkbTcQW5aVoHcHku9lgFCB/uTXTTHWYHF/9KxXegOHo3A0QyWy5QPrZr6kyw9uT
	bsxOblusixi162c5Kmuf3LTHUYzWSQ9rK3V5Q5ushnGlcP+oEDJeXMGwfbV63UyRWWTYjy
	3DjSloiIiLHMX/gjfMWvlAU93kM0ZmM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-OsN5I7NaNnuomGVJaNDUTg-1; Mon, 11 Mar 2024 10:42:47 -0400
X-MC-Unique: OsN5I7NaNnuomGVJaNDUTg-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a449be9db59so234893166b.1
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 07:42:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710168165; x=1710772965;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GxZ9fFFPslO+OLKMfpAr9nGvMTH6LktDGeSdQkQFB5o=;
        b=M2eQ2SYesucTrUUgvbIZMBOwxzXpoRmDCSYBh1xk2bjm8Iwd4OwrYgFgbjBCIyaFzd
         ZCHw/3S4UuoMZiwdom0jmSy2NIhPmTi+pu70JoH9rJ5sbh/54mhZtU514BFSyDL/V9MK
         qU1LSFWSAKOwZN3BHwRxv0rRSa4JPoGAXnQKp8GexblBkEcaGfM4brtwc3Jqqin6F18o
         Bz2ujk3ZvXVfB9LEwJRywkrFjQTUHd2GEml+c8fIJr7N80t2V7jYWiE+GGseHYhCdiPB
         mOj5gu3gLpzgFnRe6e4+7y8epGzYtGXYnVq1+FYcDQgGPGkkJjKzvNsuN8DJWn9HiQyl
         uTWQ==
X-Gm-Message-State: AOJu0Yx5bjKdBRrnXsjtnA4mLWF1qAHSMjl9CZ2Mp1Ok7a/yIFXVKk/f
	mujD6wOXZyNp6XMy4RutZYa7XBxh55f5Pd+97qy7j1PSj0MaOvR1d0YK4ACiKncmXBm4mRAPIXk
	BbEQdqFVO6FLAAxNxr6/vJP6/ShXgDwL269etym26jYRwZdlw7at0kKUrvA==
X-Received: by 2002:a17:906:13c2:b0:a45:b5a2:e963 with SMTP id g2-20020a17090613c200b00a45b5a2e963mr4620448ejc.22.1710168165705;
        Mon, 11 Mar 2024 07:42:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJQ9OaaLR4hlEWqsbUP4H9nNdXzE2njeF3Z98Buf4Bsx4IRNPe7qugxKpPOfhlcA/yvZK3/Q==
X-Received: by 2002:a17:906:13c2:b0:a45:b5a2:e963 with SMTP id g2-20020a17090613c200b00a45b5a2e963mr4620432ejc.22.1710168165372;
        Mon, 11 Mar 2024 07:42:45 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.77.21])
        by smtp.googlemail.com with ESMTPSA id t25-20020a1709063e5900b00a45c8c9a876sm2911741eji.88.2024.03.11.07.42.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 07:42:44 -0700 (PDT)
Message-ID: <4bd8b807-a52a-423e-925d-415a70a25b0b@redhat.com>
Date: Mon, 11 Mar 2024 15:42:41 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM: x86: VMX changes for 6.9
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240308223702.1350851-1-seanjc@google.com>
 <20240308223702.1350851-8-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240308223702.1350851-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/24 23:37, Sean Christopherson wrote:
> A small series for Dongli to cleanup the passthrough MSR bitmap code, and a
> handful of one-off changes.
> 
> The following changes since commit 41bccc98fb7931d63d03f326a746ac4d429c1dd3:
> 
>    Linux 6.8-rc2 (2024-01-28 17:01:12 -0800)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-x86/linux.git  tags/kvm-x86-vmx-6.9
> 
> for you to fetch changes up to 259720c37d51aae21f70060ef96e1f1b08df0652:
> 
>    KVM: VMX: Combine "check" and "get" APIs for passthrough MSR lookups (2024-02-27 12:29:46 -0800)

Pulled, thanks.

Paolo


