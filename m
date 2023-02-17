Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B767569AA79
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 12:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjBQLdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 06:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjBQLdL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 06:33:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F25A6535A
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 03:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676633544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tFo2Wp9IgQFuBh3x/erGvc1GmA/wqCVf+VmHpdKFEto=;
        b=QuXk/thUj3WHgMFMLM48tGBF/XbYYbWcs9u3Pqs7K7aLeHno9U8+83jws1Oiv12iZhw3NI
        tgCUTOy1zSpUPlTEd17HDYOHsBpkrTe9NY4UkVxO+Mg0P0CN4KPt5hEa+0ch4h57dinfiU
        DReV9A7oZzQcoqPdfiqYJeKzB7ipQ9g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-31-NbvR-vRiMXKtfy1Wa1PWXw-1; Fri, 17 Feb 2023 06:32:23 -0500
X-MC-Unique: NbvR-vRiMXKtfy1Wa1PWXw-1
Received: by mail-wm1-f70.google.com with SMTP id y11-20020a1c4b0b000000b003dc5341afbaso563296wma.7
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 03:32:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tFo2Wp9IgQFuBh3x/erGvc1GmA/wqCVf+VmHpdKFEto=;
        b=J7bMSQe+XEoLc8fXtvS/sJbfqt9grA6LYmXi2nd/OqUfDc7GfJgOvB74S04JCtq1M/
         JEkjJ+fO5Mm0n30uMGo7cIZKk7OZHKqyfwI2Jw4U3EUjGYCNoMrHE8L3jdwbXtkNcwoX
         ohr6VZZcvCfafgf51q4KAUjwF9JwcqLxTAQ2dMY3W3AXA9p2TMvo9d7kVj5ZVoncPWuS
         m+dUjfa3p3afIUdPKRY/KZwUmKCD5dmEIHXnyXKohuAfJlYUDzDoUVB9STXMwvbl8cmE
         0OfTED88glLrjAqfg3y0Xj4gSQuXT7vvhiUwODjGNbNTWEizWceDAsHuK1TG4HXlp0Vw
         JPpw==
X-Gm-Message-State: AO0yUKWfMX88f/fcYks7TVhk7/1WlQUjBd0pdnBkzTaBW8r6AkhWDrJM
        xMWSa06TSMyCdihtvnWhdO5fWLVlctyxSZl0JQ+7q0SRgXE2bCyQqPGA5p0BmFXCcIjGzHvUk4n
        0K17khXic9CGTkI3W8w==
X-Received: by 2002:a05:6000:4:b0:2c5:941d:26b8 with SMTP id h4-20020a056000000400b002c5941d26b8mr3462309wrx.15.1676633541792;
        Fri, 17 Feb 2023 03:32:21 -0800 (PST)
X-Google-Smtp-Source: AK7set9z0VSv6vFYFUxc2JibA5rMdRqfesKqozBYoDdDZVR545b93kHzqNt5eh1OEGIsB0X5uIeL8A==
X-Received: by 2002:a05:6000:4:b0:2c5:941d:26b8 with SMTP id h4-20020a056000000400b002c5941d26b8mr3462290wrx.15.1676633541462;
        Fri, 17 Feb 2023 03:32:21 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id n13-20020adfe34d000000b002c546d169ddsm4038181wrj.11.2023.02.17.03.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Feb 2023 03:32:20 -0800 (PST)
Message-ID: <45e343f7-9b1b-fb23-30ee-4ba59b6dfa62@redhat.com>
Date:   Fri, 17 Feb 2023 12:32:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Ross Zwisler <zwisler@chromium.org>, linux-kernel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>, kvm@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
References: <20230215223350.2658616-1-zwisler@google.com>
 <20230215223350.2658616-5-zwisler@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 4/6] tools/kvm_stat: use canonical ftrace path
In-Reply-To: <20230215223350.2658616-5-zwisler@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/15/23 23:33, Ross Zwisler wrote:
> The canonical location for the tracefs filesystem is at /sys/kernel/tracing.
> 
> But, from Documentation/trace/ftrace.rst:
> 
>    Before 4.1, all ftrace tracing control files were within the debugfs
>    file system, which is typically located at /sys/kernel/debug/tracing.
>    For backward compatibility, when mounting the debugfs file system,
>    the tracefs file system will be automatically mounted at:
> 
>    /sys/kernel/debug/tracing
> 
> A comment in kvm_stat still refers to this older debugfs path, so let's
> update it to avoid confusion.
> 
> Signed-off-by: Ross Zwisler <zwisler@google.com>
> ---
>   tools/kvm/kvm_stat/kvm_stat | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
> index 6f28180ffeea..15bf00e79e3f 100755
> --- a/tools/kvm/kvm_stat/kvm_stat
> +++ b/tools/kvm/kvm_stat/kvm_stat
> @@ -627,7 +627,7 @@ class TracepointProvider(Provider):
>           name)'.
>   
>           All available events have directories under
> -        /sys/kernel/debug/tracing/events/ which export information
> +        /sys/kernel/tracing/events/ which export information
>           about the specific event. Therefore, listing the dirs gives us
>           a list of all available events.
>   

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

