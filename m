Return-Path: <kvm+bounces-2023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8CA67F0828
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 18:38:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E0541F22A77
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 17:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 750171946B;
	Sun, 19 Nov 2023 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ev4ShtAV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512A4115
	for <kvm@vger.kernel.org>; Sun, 19 Nov 2023 09:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700415491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UfEOa4dx8jbARfZI7SJUwpd5ijXfpmv9Ry2k8rEDX50=;
	b=Ev4ShtAVvqPFfziw2gV208mhc0ncM8rmcGKTJqxBvOVkVwwvEIYuaTxKKFWDUAoQBdEghu
	Ouck92goEYrrrU51SaBxvkT11rl3jXh8F30v+IXfMXOniOVhGbzxr7wELngHozvO8NjqPD
	IFbcnw5F2LRfuMC2pmTaf2FWcwdkILs=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-Xt5D6eQzOv6pWjO9G_8aKQ-1; Sun, 19 Nov 2023 12:38:09 -0500
X-MC-Unique: Xt5D6eQzOv6pWjO9G_8aKQ-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5079a8c68c6so3325650e87.1
        for <kvm@vger.kernel.org>; Sun, 19 Nov 2023 09:38:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700415488; x=1701020288;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UfEOa4dx8jbARfZI7SJUwpd5ijXfpmv9Ry2k8rEDX50=;
        b=u5pe9ePahePI6VxBhGMZKobWndkGpiHX900YmdKrsJntsrfjbtTUjcyyM4p4zItK5n
         7CTRaAWpOjpKF6Y7ktWEMKywm4cvSWeJTCXS37NX5sOEQhnPGjpm1fx1NIxaUJazJn04
         uKGhk2O5nIL1vtHFe7zH/Vw/htQ4CCoYd67S+3Ypu3uspsTO4lZiFy6CzwJDHosQrNkS
         dwHWbZKERlj1DAjFm3M4uNofFQOudqwtPEnx8A3fUMOaEzGXtVqh2CbgxDNWhN01rD5r
         tsgSnzrRAJjpCrBzZw1Sdh9xF4Bbnx8vAu2xJRscgavfDid4UmAi7w8iSMS3mVtTMgQj
         QtXA==
X-Gm-Message-State: AOJu0YxVnXo2ufi4Yh54G0OIKhOeWWt4wkkj0NeOFDIhErkqwmOgP9XA
	9SFcdagOj+I/bU1WPvEqTzrnuqWQ73s43pgVK2DITIIwXVwn8+WnDg2fkG8Y4XrPDtASV2d20BD
	0emTDo4qOITz1
X-Received: by 2002:a19:f80c:0:b0:509:1207:5e9a with SMTP id a12-20020a19f80c000000b0050912075e9amr3951851lff.42.1700415488268;
        Sun, 19 Nov 2023 09:38:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IExMBjE8+a7PVy5wXI/+thGPI75u5SYcZ3rTZpq032gUJPIYrccoKOVRfTufwtu6HC4wgWZFw==
X-Received: by 2002:a19:f80c:0:b0:509:1207:5e9a with SMTP id a12-20020a19f80c000000b0050912075e9amr3951842lff.42.1700415487986;
        Sun, 19 Nov 2023 09:38:07 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id d19-20020adf9b93000000b003316eb9db40sm6231643wrc.51.2023.11.19.09.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Nov 2023 09:38:07 -0800 (PST)
Message-ID: <c964b29b08854b2779a75584cf2c3bb1e5ccb26a.camel@redhat.com>
Subject: Re: [PATCH] KVM: selftests: Fix MWAIT error message when guest
 assertion fails
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 19 Nov 2023 19:38:06 +0200
In-Reply-To: <20231107182159.404770-1-seanjc@google.com>
References: <20231107182159.404770-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2023-11-07 at 10:21 -0800, Sean Christopherson wrote:
> Print out the test and vector as intended when a guest assert fails an
> assertion regarding MONITOR/MWAIT faulting.  Unfortunately, the guest
> printf support doesn't detect such issues at compile-time, so the bug
> manifests as a confusing error message, e.g. in the most confusing case,
> the test complains that it got vector "0" instead of expected vector "0".
> 
> Fixes: 0f52e4aaa614 ("KVM: selftests: Convert the MONITOR/MWAIT test to use printf guest asserts")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
> index 80aa3d8b18f8..853802641e1e 100644
> --- a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
> @@ -27,10 +27,12 @@ do {									\
>  									\
>  	if (fault_wanted)						\
>  		__GUEST_ASSERT((vector) == UD_VECTOR,			\
> -			       "Expected #UD on " insn " for testcase '0x%x', got '0x%x'", vector); \
> +			       "Expected #UD on " insn " for testcase '0x%x', got '0x%x'", \
> +			       testcase, vector);			\
>  	else								\
>  		__GUEST_ASSERT(!(vector),				\
> -			       "Expected success on " insn " for testcase '0x%x', got '0x%x'", vector); \
> +			       "Expected success on " insn " for testcase '0x%x', got '0x%x'", \
> +			       testcase, vector);			\
>  } while (0)
>  
>  static void guest_monitor_wait(int testcase)
> 
> base-commit: 45b890f7689eb0aba454fc5831d2d79763781677

I think that these days the gcc (and llvm likely) support printf annotations,
and usually complain, we should look at adding these to have a warning in such cases.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




