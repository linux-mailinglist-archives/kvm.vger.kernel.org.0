Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3ED434277
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 02:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhJTAJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 20:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhJTAJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 20:09:27 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711DEC06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 17:07:14 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id q2-20020a17090a2e0200b001a0fd4efd49so2782391pjd.1
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 17:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AL0A8vYTo5t1fm/HzLOBmV3CGYEOZMcOSPvj8RAZoLk=;
        b=h/NxG+Hfov5SZFT2QuqgEhtZc0HGVqjvTKI7nZMCiJELqspXt8FoZjT6NS7+9ikJ33
         T2YIphN6AD4m+USMrzIyApmmDZr9ed0ED37boSV8JYOzC77Fzb5qcuUKSAQCxyWyk39/
         B6KOgYg8NKETHUyzaA61MOTy5mVol57c+oYDXxMHqqulyx0Tvt7OWyco9hdYmxwoCr4A
         aZNWots5XRdOzEaikeGvYf1LY+wwmtl1lXs5QaK5ka0G4FZZjwQwCHjQHSckF0cTKoyc
         gKavmtn9eYSDgPycgXx89ko8rA6x/NxqAdescACRmDhketYgU/ngJLYuyIFW0/yrn5pJ
         RTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AL0A8vYTo5t1fm/HzLOBmV3CGYEOZMcOSPvj8RAZoLk=;
        b=EJmqxYAwfIgzD+kHZw0FTA/Bmw/lekoxi2JmSZ/wHmYMyu7rh/ylOIHd3rb1Fk5njS
         JYs9+b8QGKgjyBhGNrHAm4nYI3Gglws75U/oKaNCatLn1OSElSovL2qGhY1j7TiPMtve
         /XD+6u/U+ojULw1jNoAvz+9dYHkCpljMKtwQZy8EftunFahwap3hxTn12rrOIDEdzs6E
         x19VTTgLL297AX4GMkt7DwjMznTtqdZHCtA0lF9P5zibdifLTMaYdiUkJ2xgth6gtCpo
         Fki7hWoX02fMhM8lxpWZx5+QvNytbmPLz0p5fxNxp15iC8LXn+qCVcnS5xwPFIKfUWR4
         AMpg==
X-Gm-Message-State: AOAM530643vhp/eZRi7bQc7wBEcZuLXjCSWN4d8EVQj0ALYG9AnmlFUC
        SnOhnmKNXo4dURti3oon1Imcuu/RGD4OXA==
X-Google-Smtp-Source: ABdhPJy4Ax1JORLBjULrXoDjXM4dXFLdsdQy+z0diwZVUox2h1KGzoM0OmFWzKkbeAcpxby3O5TeeA==
X-Received: by 2002:a17:90a:4b47:: with SMTP id o7mr3500829pjl.198.1634688433499;
        Tue, 19 Oct 2021 17:07:13 -0700 (PDT)
Received: from ?IPv6:2601:646:8200:baf:e459:c57e:6787:4f09? ([2601:646:8200:baf:e459:c57e:6787:4f09])
        by smtp.gmail.com with ESMTPSA id y1sm336270pfo.104.2021.10.19.17.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 17:07:13 -0700 (PDT)
Subject: Re: [PATCH v2] kvm: x86: mmu: Make NX huge page recovery period
 configurable
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
References: <20211019013953.116390-1-junaids@google.com>
 <CANgfPd8a3_snsbF7Y-McZMFx4xz4uwWLjXD3VTaKUBr1xnNTrg@mail.gmail.com>
From:   Junaid Shahid <junaids@google.com>
Message-ID: <1f62f999-3844-39e9-94b4-e06029fbe308@google.com>
Date:   Tue, 19 Oct 2021 17:07:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd8a3_snsbF7Y-McZMFx4xz4uwWLjXD3VTaKUBr1xnNTrg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/21 4:48 PM, Ben Gardon wrote:
> On Mon, Oct 18, 2021 at 6:40 PM Junaid Shahid <junaids@google.com> wrote:
>>
>> -static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel_param *kp)
>> +static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp)
>>   {
>> -       unsigned int old_val;
>> +       bool was_recovery_enabled, is_recovery_enabled;
>>          int err;
>>
>> -       old_val = nx_huge_pages_recovery_ratio;
>> +       was_recovery_enabled = nx_huge_pages_recovery_ratio;
>> +
>>          err = param_set_uint(val, kp);
>>          if (err)
>>                  return err;
>>
>> +       is_recovery_enabled = nx_huge_pages_recovery_ratio;
>> +
>>          if (READ_ONCE(nx_huge_pages) &&
>> -           !old_val && nx_huge_pages_recovery_ratio) {
>> +           !was_recovery_enabled && is_recovery_enabled) {
>>                  struct kvm *kvm;
>>
>>                  mutex_lock(&kvm_lock);
> 
> I might be missing something, but it seems like setting
> nx_huge_pages_recovery_period_ms through this function won't do
> anything special. Is there any reason to use this function for it
> versus param_set_uint?
> 

Yes, you are right. The original patch was using a 0 period to mean that recovery is disabled, but v2 no longer does that, so we indeed don't need to handle the period parameter through this function.

Thanks,
Junaid
