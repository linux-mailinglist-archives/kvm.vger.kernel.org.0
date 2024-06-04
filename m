Return-Path: <kvm+bounces-18788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A86A98FB5B4
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 16:40:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A6C7284F4E
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 499F9143C76;
	Tue,  4 Jun 2024 14:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dFL072f8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C2D12BEA4
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 14:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717511893; cv=none; b=Mn0P9+/IQk1KrNOOs20GCnPFjWUrDK0bIg9xqTJjpI9e1nM/xZMyZVECf1jGH3IH5v9xAMqOBnUbhvpv28XmhuPGmeQpGwooOWLFko74r9NLRwLMPFupIUEU9RDbvdSwcdyE+qsbyOFGrFVjXKFLeSSEoV+8yT7XGSJd21TBGBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717511893; c=relaxed/simple;
	bh=SvOAcx3aRIAzgWn6aB+3plUYPLK3g5l35N4V2ElfFpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BZ8f/OOKFdMZH/VE7qDQyrfn8ElVz19XSIpSVXRAtwM1kyJxW4niFuDpGeXp3gQRJNh6EWzKycFaZTk7P0Sic88cQWS+6ZaTpjPgDijiQydSTwz2DjQzzj5YvTm67y9ju4Yr0o1qVprZF92C3+n9Zze6Xaauio1qNqDD3d9Mnjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dFL072f8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717511891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xr9ylOu+Ho5X2V/wdxDEgy8q3HmQW5Mgx7cCtDimHFg=;
	b=dFL072f8g3czEe3wbdMQVLdJahMzMphB4XbMSACgdVP9Wp/DKZS+vXTLtC8NGgy1cCDNbc
	Ck+9O7T5EgJgdjXmbLVV30i9/D6zobUgPubkC2966Txnpyjc6HohHqslAivEjcDngkYYsg
	1oa6d5V8PzGQENuEeXdF8ry0TCwI3Kk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-2CuYiclqMlGr7ZXp10hG8g-1; Tue, 04 Jun 2024 10:38:08 -0400
X-MC-Unique: 2CuYiclqMlGr7ZXp10hG8g-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-35dceae6283so913868f8f.2
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 07:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717511887; x=1718116687;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xr9ylOu+Ho5X2V/wdxDEgy8q3HmQW5Mgx7cCtDimHFg=;
        b=geWG/i6NbpKf/Vqu9RdynRhoCK1vG9fF2eWE9hT9x8RMAUadAiL6Kibj+fr28lExav
         jXqJTUpHKTPjpH9qKQQJyNVvPvuWdKMl1XbrrqUhZ0Rf/gn4FTz+3996gd/8EcvbUqmG
         gu3fYVj2zx7sDYKnzUhPXzCjfiyFPm0eVz5jm2a+jKejmh1UgecE1YCT/3QQFiZmckX7
         Ith4h3JVuc2olp9s/mRsx3GF7agskgx8KVx++e1j0i15+TMGP15nLDwZt5gc/DpZmyyJ
         qxZI44b8QM7y6OuhD+oPjpuXAbhLD8/J9eq0LzbJiAwFY/a8UaPGcxesbUxNsEKP6/cw
         F8tA==
X-Forwarded-Encrypted: i=1; AJvYcCV/suGTX/sJEx4ycvZ4G50ttl+5Qv5hDF2/RQtmnyJpdo1muHQN0iKSWD1N2jSQrz2yFWUCico+wYrpTzrTsS8lOM9s
X-Gm-Message-State: AOJu0YzoxwTDmF0QnqQcHtLLtDyD2eLtFsctONw0R9/iz8T1IheT8Npj
	HTtym7pcRxi3Xs0n47sl57wd+733E6RuM+eRCg7BeCOLxQimx3sVFWmSM5SjwMcdMRM9D7Lpe2e
	5nevRpqMfsLrYT/6501faan5tF5Bry7Vm7jS33gDGVM63/SYxs2i6HmjWZw==
X-Received: by 2002:adf:ee92:0:b0:34d:99ac:dcd0 with SMTP id ffacd0b85a97d-35e0f30bd45mr7878772f8f.49.1717511887116;
        Tue, 04 Jun 2024 07:38:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHN4bWmB4zrEw4LkQdOIOiJIZYvvoljaMoLThP+COkwyWdXi2Y1Rams+YgbdLdHMIHif/HSiw==
X-Received: by 2002:adf:ee92:0:b0:34d:99ac:dcd0 with SMTP id ffacd0b85a97d-35e0f30bd45mr7878762f8f.49.1717511886743;
        Tue, 04 Jun 2024 07:38:06 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-97.web.vodafone.de. [109.43.178.97])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35dd04c0d6csm11829254f8f.1.2024.06.04.07.38.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 07:38:06 -0700 (PDT)
Message-ID: <8dffe7fe-3a2e-4030-812e-89827266bc43@redhat.com>
Date: Tue, 4 Jun 2024 16:38:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvm-unit-tests] realmode: rebuild when realmode.lds
 changes
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20240604143507.1041901-2-pbonzini@redhat.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240604143507.1041901-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/06/2024 16.35, Paolo Bonzini wrote:
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   x86/Makefile.common | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 4ae9a557..c5dd4970 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -103,9 +103,9 @@ test_cases: $(tests-common) $(tests)
>   
>   $(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/x86 -I lib
>   
> -$(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
> +$(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o $(SRCDIR)/$(TEST_DIR)/realmode.lds
>   	$(LD) -m elf_i386 -nostdlib -o $@ \
> -	      -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $^
> +	      -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $(filter %.o, $^)


Reviewed-by: Thomas Huth <thuth@redhat.com>


