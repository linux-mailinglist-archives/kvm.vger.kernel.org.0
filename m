Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B5BB0078
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 17:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbfIKPpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 11:45:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728770AbfIKPpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 11:45:38 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 54AD413D10
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 15:45:38 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id 124so1134415wmz.1
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 08:45:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SADBz17//6IZUgMolr43dOBxnVdH4VLHQ4h/pXjM1AE=;
        b=k+DdNilLe7rWkolLATwr1W9gdtFg1RNnRii+wCbuPdJsTqG8sW1NQ3/6JOpSeEzlOr
         1I6kQHwmOWF6yieR/RS+70fI6XVsx6J0xf9PgdqSCuSKrAaKT4Q69tudX6WKhPdur2CW
         bP8WJR2ceOI6ZEZFq9W+eqso4jcBpLNAk/bTpJ/LQblTpvB+Akinb2/U08qXc+qIDe8j
         K7JvQ2Dz3l2WFtv1hwn8m3kT6N3o1MdyP1ZquIMpKlPJCC7dJwVZjdQOWcRhuDnn817t
         mExdgbz5OvDlm3v1wlZIVhD0oTzj1ZxZ3PrJ4poXb8qxdmQBbajE/gPxOnJSgbqtE/D7
         +GFw==
X-Gm-Message-State: APjAAAVdKIG095/BWexgFN/jK0xszuZeZfZ2jAyASlr6E0zrCa7eWP2T
        RDbizoSPw1wKRoH7JnTCBfWjD0N73H63v57AosLmcrWx8Sgf00VCbGKbkxSLku21Df5/nXA5uQ0
        +UV5WEbfAdTze
X-Received: by 2002:adf:dbc6:: with SMTP id e6mr2930261wrj.149.1568216737012;
        Wed, 11 Sep 2019 08:45:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyLCxa4q+GLIjYVCFsrhHPkBHXqHP3cJI/AUYzz5eeLL8hVQWMDVy3YOLJWEgAtj6ni88uvOg==
X-Received: by 2002:adf:dbc6:: with SMTP id e6mr2930247wrj.149.1568216736760;
        Wed, 11 Sep 2019 08:45:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:102b:3795:6714:7df6? ([2001:b07:6468:f312:102b:3795:6714:7df6])
        by smtp.gmail.com with ESMTPSA id s12sm30969747wra.82.2019.09.11.08.45.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 08:45:36 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: INVEPT after modifying PA
 mapping in ept_untwiddle
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>
References: <20190828082900.88609-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <cbd1e9fd-6805-d739-4f71-1718bbc3d9a2@redhat.com>
Date:   Wed, 11 Sep 2019 17:45:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190828082900.88609-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/08/19 10:29, Oliver Upton wrote:
> ept_untwiddle modifies a PA mapping in the EPT paging structure.
> According to the SDM 28.3.3.4, "Software should use the INVEPT
> instruction with the "single-context" INVEPT type after making any of
> the following changes to an EPT paging-structure entry ... Changing
> the physical address in bits 51:12".
> 
> Suggested-by: Peter Shier <pshier@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  x86/vmx_tests.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 8ad26741277f..94be937da41d 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -2376,6 +2376,7 @@ static unsigned long ept_twiddle(unsigned long gpa, bool mkhuge, int level,
>  static void ept_untwiddle(unsigned long gpa, int level, unsigned long orig_pte)
>  {
>  	set_ept_pte(pml4, gpa, level, orig_pte);
> +	ept_sync(INVEPT_SINGLE, eptp);
>  }
>  
>  static void do_ept_violation(bool leaf, enum ept_access_op op,
> 

Queued, thanks.

Paolo
