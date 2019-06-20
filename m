Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 243E14CD82
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 14:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731784AbfFTMOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 08:14:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33391 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730886AbfFTMOL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 08:14:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id h19so6794022wme.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 05:14:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j6RqlD3tjx4apx8Dop5hpUBnB0AsX4GUNp1imsaFEWU=;
        b=ft7gQ3BGPXCHt+X/vgGmABVhYmoLHoz25BKE9LIHZAi6hCDeYahltHlvzJhwXoZFRX
         AKdJ2paF9DdaVxDzvkFcgKGzXtfFEgGNnRqSvaa6e0pUNFFlrO5KW2LjZPSFvwBGlQ0v
         Rau3lMOwJP+O0qfnwpKAIyAlksOMATzXsedwZLX/Tc2vF5dHVTmWFhCGRkB/ZXgouWsx
         RAmXGb38SFUMYDjUwvF+4DEyYYM0QR/xuhrXsBiGTtnr2kQKrBm9H37gJmBhH8jb7BEe
         k2TABheS0IZ95oCb0bZp1XZ20VZ0Hb5HoRxI4rUN+eXcNrmY880Ca1QpBL1CEq23ckbQ
         ZL9g==
X-Gm-Message-State: APjAAAXWGu1CC1+7AJyWdHHco1Ze0oqV0tLTrLmU4OgJHktBtkAW7eO0
        M+OqwkZzydSLoZ5zb9yi1iCtiw==
X-Google-Smtp-Source: APXvYqwqNN7z4fPCN4X79oZjI2lnVPj/ReOJhcvL+WrOsnOt4/UEvzaGwgwU76LsXJVRmVm2vDz7Eg==
X-Received: by 2002:a05:600c:228b:: with SMTP id 11mr2745365wmf.26.1561032849420;
        Thu, 20 Jun 2019 05:14:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7822:aa18:a9d8:39ab? ([2001:b07:6468:f312:7822:aa18:a9d8:39ab])
        by smtp.gmail.com with ESMTPSA id h133sm2091970wme.28.2019.06.20.05.14.08
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 05:14:08 -0700 (PDT)
Subject: Re: [PATCH RFC 0/5] x86/KVM/svm: get rid of hardcoded instructions
 lengths
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
References: <20190620110240.25799-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3515d812-e5dd-4436-b73f-1d64bc93b079@redhat.com>
Date:   Thu, 20 Jun 2019 14:14:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190620110240.25799-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/06/19 13:02, Vitaly Kuznetsov wrote:
> 
> P.S. If you'd like to test the series you'll have to have a CPU without
> NRIP_SAVE feature or forcefully disable it, something like:
> 
> index 8d4e50428b68..93c7eaad7915 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -922,6 +922,9 @@ static void init_amd(struct cpuinfo_x86 *c)
>         /* AMD CPUs don't reset SS attributes on SYSRET, Xen does. */
>         if (!cpu_has(c, X86_FEATURE_XENPV))
>                 set_cpu_bug(c, X86_BUG_SYSRET_SS_ATTRS);
> +
> +       /* No nrips */
> +       clear_cpu_cap(c, X86_FEATURE_NRIPS);
>  }
>  
>  #ifdef CONFIG_X86_32

Let's add a module parameter instead.  Patch sent (forgot to Cc you).

Paolo
