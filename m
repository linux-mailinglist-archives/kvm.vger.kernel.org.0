Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827F36D9EA2
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 19:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240025AbjDFRWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 13:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240061AbjDFRVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 13:21:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBF2A5CB
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 10:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680801578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LP3YXXyYJvN3aEObqIIMiycghi8EaKj04VX+mmVHJy4=;
        b=LXWSrD7zLSUdRMeHi2N9qU9keqvVhNJxK7NZXIAN4is2+ALPBTfluEvVyZj02I+tt2oX36
        Xc+lu1bRpuiPTeUWx1cp/MfgZ+Wz8h7CV0ScWrJCtlMyynAm8N8tsNuSH3EHOyG5dFgL+E
        q6NRsb/tnnjgmc1hjYwhqboaIB7gBZY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-kZc7RE8HM6a3QK4q_xSEbg-1; Thu, 06 Apr 2023 13:19:36 -0400
X-MC-Unique: kZc7RE8HM6a3QK4q_xSEbg-1
Received: by mail-ed1-f70.google.com with SMTP id t14-20020a056402240e00b004fb36e6d670so52739489eda.5
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 10:19:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680801575; x=1683393575;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LP3YXXyYJvN3aEObqIIMiycghi8EaKj04VX+mmVHJy4=;
        b=mlvtsxnyabHytyx0Qw5T5nZPb9ZLqOH876wz7SrSb4oEEOoy0sHZh5zrU39DOnj5LB
         bOFPQNQ0wk8V7lxJCT5L8V8Iyu+MVf0uTgviwDioyoZ4BDreO6Sxl7goHEqaJ+XgSKbf
         VJh3BlIvYIb8+PrDtF9m0bPlRZnj1sa9yykxqN/ym5WYZTgbbUUj8yTvtt7aZLL7mPa3
         26NK8pPafTAG6zmu2v0MuQDGtQ7IPfwCxU+yZ+Q8+sC7Bgumyb9OFW2+WvElTRMa+dj8
         bXdcmoZMe4ciSKwf5d+rDk9m6adFzHj+LsRMlVcITCtgUaGZG0n/uGZPYDXll9Gr6/iy
         xZUw==
X-Gm-Message-State: AAQBX9ejq0pSdlAB2JCxE3VQ59GOHRNLlbr+6KvexVDquatCxdBmHanH
        L5fQU3+U3+MD82cKj0tGcHTC0aD+F1X3fBIVwED+OYPyia6VrYlv2Ynr7ghgbjRK9mj7cMEw02N
        e9tlaEFAhjk39Kc1UvtfP
X-Received: by 2002:a17:906:1754:b0:92d:44ca:1137 with SMTP id d20-20020a170906175400b0092d44ca1137mr6421307eje.43.1680801575038;
        Thu, 06 Apr 2023 10:19:35 -0700 (PDT)
X-Google-Smtp-Source: AKy350a5DIzoHAy5QTc+uAGixeCWzczV9Y6+81B3R8DL//DpfoqhKveFDbUoz+7LnVp4dosyJ4rYSA==
X-Received: by 2002:a17:906:1754:b0:92d:44ca:1137 with SMTP id d20-20020a170906175400b0092d44ca1137mr6421287eje.43.1680801574709;
        Thu, 06 Apr 2023 10:19:34 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id z98-20020a509e6b000000b004fd29e87535sm979422ede.14.2023.04.06.10.19.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 10:19:34 -0700 (PDT)
Message-ID: <92d87145-479b-05ad-8560-49765b1794ca@redhat.com>
Date:   Thu, 6 Apr 2023 19:19:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH] x86/flat.lds: Silence warnings about empty
 loadable segments
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20230329123814.76051-1-thuth@redhat.com>
 <168073550254.619716.10085104611122942655.b4-ty@google.com>
 <8b2fe89b-718c-074a-e566-41106dff016c@redhat.com>
 <ZC7+c42p2IRWtHfT@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZC7+c42p2IRWtHfT@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/6/23 19:16, Sean Christopherson wrote:
>> I can see a .note.GNU-stack entry in x86/efi/elf_x86_64_efi.lds ... maybe we
>> need something similar in x86/flat.lds ?
> I believe that just telling the linker that those sections don't need relocation
> info.  I suspect it's unnecessary copy+paste from UEFI sources.
> 
> The linker warning from setjmp64.o (and cstart64.o) is yelling about_not_  having
> .note.GNU-stack, which is a magic section that tells the linker that the binary
> doesn't need an executable stack.  If I'm reading the NOTE correctly, it's saying
> that the ability to have an executable stack is soon going away.

More or less; if I remember correctly they want to flip the default from 
executable stack to non-executable stack.  If you want an executable 
stack you'll have to add an ELF note or link with -z execstack.

All of this of course is irrelevant in a freestanding environment.

Paolo

