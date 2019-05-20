Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8540D2386E
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 15:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387734AbfETNmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 09:42:35 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35761 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731005AbfETNme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 09:42:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id m3so1706045wrv.2
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 06:42:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t2A3vVjUJjtMYYZ7H6X6d3No0VdUGhV5S5FP9C53JjE=;
        b=U/jfLpX8STJ6M2nfBVg94Y/OP0jEFdvAzJ4Es/yMvRrFZrKXF5kXFoAoov0E6YocPO
         x62uKs0E+68l6YsMkzYvpV9nSDyOEB+sjLznM1PQGCD/kSffLaMego5Z5fEaet/Mx9tD
         i0cZIeqIGJhIwvJmHu9x+b1EezzUFnz8QI4rSyZMi3rjI/hps1945Yna7GHokqJG4Z62
         S8FWvEO4akg6iTYzFtyiVhhvc4kXvfbHQmYWQJfdiPb3U90Z6DaEjmWSGR3s36iIbOXE
         qHoRcEDo2FOHTxCAw0ZWq8uF0W35wfnWap3RcaC1q/+CKoNC7ZUZaFAzc3o6p06l5ycP
         hvog==
X-Gm-Message-State: APjAAAVmigiSH+kpN/7NW3M7eAGxMObNwXBEx8EIPYpWHOeqN9vXPrpJ
        VPY3j273dr4/XUBVavrRfJsWMw==
X-Google-Smtp-Source: APXvYqwsucbgGTtRiULs4yqK7NJbIWN4Ha4hJl1K1D+MPLkzCoNvx/YNiRXYbAyNSWvK4D8HypykNQ==
X-Received: by 2002:adf:9794:: with SMTP id s20mr33259857wrb.104.1558359752738;
        Mon, 20 May 2019 06:42:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id m17sm19860510wmc.6.2019.05.20.06.42.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 06:42:32 -0700 (PDT)
Subject: Re: [PATCH] tools/kvm_stat: fix fields filter for child events
To:     Stefan Raspl <raspl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com
References: <20190421132624.51198-1-raspl@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <80d43f7f-a25a-4ee1-04f5-9da77ec7e95e@redhat.com>
Date:   Mon, 20 May 2019 15:42:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190421132624.51198-1-raspl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/19 15:26, Stefan Raspl wrote:
> From: Stefan Raspl <stefan.raspl@de.ibm.com>
> 
> The fields filter would not work with child fields, as the respective
> parents would not be included. No parents displayed == no childs displayed.
> To reproduce, run on s390 (would work on other platforms, too, but would
> require a different filter name):
> - Run 'kvm_stat -d'
> - Press 'f'
> - Enter 'instruct'
> Notice that events like instruction_diag_44 or instruction_diag_500 are not
> displayed - the output remains empty.
> With this patch, we will filter by matching events and their parents.
> However, consider the following example where we filter by
> instruction_diag_44:
> 
>   kvm statistics - summary
>                    regex filter: instruction_diag_44
>    Event                                         Total %Total CurAvg/s
>    exit_instruction                                276  100.0       12
>      instruction_diag_44                           256   92.8       11
>    Total                                           276              12
> 
> Note that the parent ('exit_instruction') displays the total events, but
> the childs listed do not match its total (256 instead of 276). This is
> intended (since we're filtering all but one child), but might be confusing
> on first sight.
> 
> Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
> ---
>  tools/kvm/kvm_stat/kvm_stat     | 16 ++++++++++++----
>  tools/kvm/kvm_stat/kvm_stat.txt |  2 ++
>  2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
> index 2ed395b817cb..bc508dae286c 100755
> --- a/tools/kvm/kvm_stat/kvm_stat
> +++ b/tools/kvm/kvm_stat/kvm_stat
> @@ -575,8 +575,12 @@ class TracepointProvider(Provider):
>      def update_fields(self, fields_filter):
>          """Refresh fields, applying fields_filter"""
>          self.fields = [field for field in self._get_available_fields()
> -                       if self.is_field_wanted(fields_filter, field) or
> -                       ARCH.tracepoint_is_child(field)]
> +                       if self.is_field_wanted(fields_filter, field)]
> +        # add parents for child fields - otherwise we won't see any output!
> +        for field in self._fields:
> +            parent = ARCH.tracepoint_is_child(field)
> +            if (parent and parent not in self._fields):
> +                self.fields.append(parent)
>  
>      @staticmethod
>      def _get_online_cpus():
> @@ -735,8 +739,12 @@ class DebugfsProvider(Provider):
>      def update_fields(self, fields_filter):
>          """Refresh fields, applying fields_filter"""
>          self._fields = [field for field in self._get_available_fields()
> -                        if self.is_field_wanted(fields_filter, field) or
> -                        ARCH.debugfs_is_child(field)]
> +                        if self.is_field_wanted(fields_filter, field)]
> +        # add parents for child fields - otherwise we won't see any output!
> +        for field in self._fields:
> +            parent = ARCH.debugfs_is_child(field)
> +            if (parent and parent not in self._fields):
> +                self.fields.append(parent)
>  
>      @property
>      def fields(self):
> diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
> index 0811d860fe75..c057ba52364e 100644
> --- a/tools/kvm/kvm_stat/kvm_stat.txt
> +++ b/tools/kvm/kvm_stat/kvm_stat.txt
> @@ -34,6 +34,8 @@ INTERACTIVE COMMANDS
>  *c*::	clear filter
>  
>  *f*::	filter by regular expression
> + ::     *Note*: Child events pull in their parents, and parents' stats summarize
> +                all child events, not just the filtered ones
>  
>  *g*::	filter by guest name/PID
>  
> 

Queued, thanks.

Paolo
