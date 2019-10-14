Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5396BD5D31
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 10:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbfJNIMw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 04:12:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728384AbfJNIMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 04:12:52 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DB7E24E93D;
        Mon, 14 Oct 2019 08:12:51 +0000 (UTC)
Received: from [10.36.117.10] (ovpn-117-10.ams2.redhat.com [10.36.117.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81B435D6A7;
        Mon, 14 Oct 2019 08:12:37 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] lib: use an argument which doesn't require
 default argument promotion
To:     Thomas Huth <thuth@redhat.com>, Bill Wendling <morbo@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?THVrw6HFoSBEb2t0b3I=?= <ldoktor@redhat.com>,
        David Gibson <dgibson@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <CAGG=3QUL_OrjaWn+gF4z-R8brR2=3661hGk0uUAK2y8Dff7Mvg@mail.gmail.com>
 <986a6fc2-ef7b-4df4-8d4e-a4ab94238b32@redhat.com>
 <30edb4bd-535d-d29c-3f4e-592adfa41163@redhat.com>
 <7f7fa66f-9e6c-2e48-03b2-64ebca36df99@redhat.com>
 <CAGG=3QUdVBg5JArMaBcRbBLrHqLLCpAcrtvgT4q1h0V7SHbbEQ@mail.gmail.com>
 <df9c5f5d-c9ec-1a7b-1fec-67d1e7a5bbad@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <80d38421-76b0-dba7-4813-a139d6db0351@redhat.com>
Date:   Mon, 14 Oct 2019 10:12:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <df9c5f5d-c9ec-1a7b-1fec-67d1e7a5bbad@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 14 Oct 2019 08:12:51 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> That's certainly a solution... but I wonder whether it might be easier
> to simply fix the failing tests instead, to make sure that they do not
> pass a value > sizeof(int) to report() and report_xfail_status() ?

I really don't like that. Like if assert() would suddenly ignore 
anything above (32bit) - If this is the case then I shall be silent :D

> 
> Another idea would be to swap the parameters of report() and
> report_xfail_status() :
> 
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index b94d0ac..d6d1323 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -99,10 +99,10 @@ void report_prefix_pushf(const char *prefix_fmt, ...)
>                                          __attribute__((format(printf, 1,
> 2)));
>   extern void report_prefix_push(const char *prefix);
>   extern void report_prefix_pop(void);
> -extern void report(const char *msg_fmt, bool pass, ...)
> -                                       __attribute__((format(printf, 1,
> 3)));
> -extern void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...)
> -                                       __attribute__((format(printf, 1,
> 4)));
> +extern void report(bool pass, const char *msg_fmt, ...)
> +                                       __attribute__((format(printf, 2,
> 3)));
> +extern void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
> +                                       __attribute__((format(printf, 3,
> 4)));
>   extern void report_abort(const char *msg_fmt, ...)
>                                          __attribute__((format(printf, 1,
> 2)))
>                                          __attribute__((noreturn));
> diff --git a/lib/report.c b/lib/report.c
> index ca9b4fd..2255dc3 100644
> --- a/lib/report.c
> +++ b/lib/report.c
> @@ -104,18 +104,18 @@ static void va_report(const char *msg_fmt,
>          spin_unlock(&lock);
>   }
> 
> -void report(const char *msg_fmt, bool pass, ...)
> +void report(bool pass, const char *msg_fmt, ...)
>   {
>          va_list va;
> -       va_start(va, pass);
> +       va_start(va, msg_fmt);
>          va_report(msg_fmt, pass, false, false, va);
>          va_end(va);
>   }
> 
> -void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...)
> +void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
>   {
>          va_list va;
> -       va_start(va, pass);
> +       va_start(va, msg_fmt);
>          va_report(msg_fmt, pass, xfail, false, va);
>          va_end(va);
>   }
> 
> ... then we can keep the "bool" - but we have to fix all calling sites, too.

At least for my taste, please do keep the bool. This sounds like one way 
to do it.

> 
> Paolo, any preferences?
> 
>   Thomas
> 


-- 

Thanks,

David / dhildenb
