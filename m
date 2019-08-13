Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 375D08B3F3
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 11:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfHMJS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 05:18:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36106 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfHMJS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 05:18:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id r3so13327260wrt.3
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 02:18:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IZRmvHQ/S4hTPY+RjwdslhJjoJMmuhgf33bqPBS5Vo0=;
        b=tCzGK5fMIOYxWUfyY2Au8ESy0IIULXc4g4SdZ6GwkZsrm0XO9qWeOIDdjYyBdMng7h
         3w/FcgdqiXSajHUCANtTVOOwpzjHd5etL9xoWyvQDNX5w0HroNEEbvdFcN1x94Phr4ry
         slbJFffEZaJmbk9lKQQIzlYzkhqWVa437SrbXL86dBugnR5Ug5xHgsUvmD6UnaemhMHY
         N73+DFMR6ve8s2/xVgB867NL9KlHc5L0MvzEp5//gPqQMRkVgAF20xs+9+hAFom+Dwm+
         pC+06pu046S2NJRTimdtyO45QE3RCqeNTAmRTMR1DRIgk1rk3opqjXewIh3IscFlyo9o
         48Bg==
X-Gm-Message-State: APjAAAXXdIXSyF5riTeQfjq554eAzvf6zl/i7gGnHoV6EotZeJ3ljDcc
        qXjllOCM9QpVGtYkeyDOWSrqcPYypO4=
X-Google-Smtp-Source: APXvYqwtQnCM7sq50W3r0VMXnUEHukyuzwOv/MX6D9s31ZjWhM+QEV2IF+RJkpJzTPaoAknQIFzUOA==
X-Received: by 2002:adf:dbcb:: with SMTP id e11mr4705392wrj.272.1565687905800;
        Tue, 13 Aug 2019 02:18:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5d12:7fa9:fb2d:7edb? ([2001:b07:6468:f312:5d12:7fa9:fb2d:7edb])
        by smtp.gmail.com with ESMTPSA id w15sm936813wmi.19.2019.08.13.02.18.24
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 02:18:25 -0700 (PDT)
Subject: Re: [RFC PATCH v6 76/92] kvm: x86: disable EPT A/D bits if
 introspection is present
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C Zhang <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-77-alazar@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9f8b31c5-2252-ddc5-2371-9c0959ac5a18@redhat.com>
Date:   Tue, 13 Aug 2019 11:18:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809160047.8319-77-alazar@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 18:00, Adalbert Lazăr wrote:
> Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index dc648ba47df3..152c58b63f69 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7718,7 +7718,7 @@ static __init int hardware_setup(void)
>  	    !cpu_has_vmx_invept_global())
>  		enable_ept = 0;
>  
> -	if (!cpu_has_vmx_ept_ad_bits() || !enable_ept)
> +	if (!cpu_has_vmx_ept_ad_bits() || !enable_ept || kvmi_is_present())
>  		enable_ept_ad_bits = 0;
>  
>  	if (!cpu_has_vmx_unrestricted_guest() || !enable_ept)
> 

Why?

Paolo
