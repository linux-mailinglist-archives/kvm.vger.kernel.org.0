Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E56DCDF1CF
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 17:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfJUPnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 11:43:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfJUPnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 11:43:12 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CA39F36955
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 15:43:12 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id 4so3341538wrf.19
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 08:43:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i3hcrN2G/jT/TYfF85WItM60lrafy2GMJS2/GS4j6Zk=;
        b=S382YgwNBxDM8aw7NUXAUHbZcVjz9I4tdcbBhUAjqpDUxx9DhNCSEeTsqZxBwDlAVa
         MyILqRLG222/Mc5Z2Zkw5QW6Rzioihy4rJ2SCcl5Pchm0UWtWD9hCyGwR2YCvvHemk29
         QcVgOpoItgigijn4drBdnifemrcetx6ysLOEc1gQ00Q3XwexT2rkrVa0JEJXN1Nx/e7M
         Q/2Zz4J/g9kF8vS03bkeaVWu6TEIvncSWhGvIYlnTQYlZfv325TKB1YH3eohFyxUoNWV
         9iO4rdFPm6aRVkDRqZK7UzU3VSL3f2XJMlCgAT1t2wrZrRlTJpSxWXiAw+Pv0ho3AlS3
         C8Jg==
X-Gm-Message-State: APjAAAWXAhR4KQJV3OmfuqkiiQCmzP+6NM4DjiJ+0BW5Z1ktFxvopcr0
        JVf97XYKLsZVKOqC7s1xcEyBeag5EX6KAlj9L1VVDoIxO2lPmdQ6WetCdsxN+8MVadPw6/z8gLB
        +2fkYqkluNHUn
X-Received: by 2002:adf:f684:: with SMTP id v4mr14405700wrp.336.1571672591487;
        Mon, 21 Oct 2019 08:43:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwOKt9nrC7cOta3dgqX01zdtek86hT9C9HIMRkr/90alyTMusOgqBfcCJGmQh6FpxORgJNsNQ==
X-Received: by 2002:adf:f684:: with SMTP id v4mr14405676wrp.336.1571672591187;
        Mon, 21 Oct 2019 08:43:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:847b:6afc:17c:89dd? ([2001:b07:6468:f312:847b:6afc:17c:89dd])
        by smtp.gmail.com with ESMTPSA id y13sm22872195wrg.8.2019.10.21.08.43.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 08:43:10 -0700 (PDT)
Subject: Re: [kvm-unit-tests v2 PATCH 2/2] x86: realmode: fix esp in call test
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        alexandru.elisei@arm.com, thuth@redhat.com
Cc:     jmattson@google.com
References: <20191012235859.238387-1-morbo@google.com>
 <20191017012502.186146-1-morbo@google.com>
 <20191017012502.186146-3-morbo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f40c1573-4cfe-4f51-c92c-4a22ba8f6287@redhat.com>
Date:   Mon, 21 Oct 2019 17:43:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191017012502.186146-3-morbo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/19 03:25, Bill Wendling wrote:
> diff --git a/x86/realmode.c b/x86/realmode.c
> index 41b8592..f318910 100644
> --- a/x86/realmode.c
> +++ b/x86/realmode.c
> @@ -520,7 +520,7 @@ static void test_call(void)
>  	u32 addr;
>  
>  	inregs = (struct regs){ 0 };
> -	inregs.esp = (u32)esp;
> +	inregs.esp = (u32)(esp+16);

Applied with

+	inregs.esp = (u32)&esp[ARRAY_SIZE(esp)];

Paolo
