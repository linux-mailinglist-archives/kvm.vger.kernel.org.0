Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C722F856C
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 20:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387852AbhAOT32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 14:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbhAOT32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 14:29:28 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC10C061757
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 11:28:48 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id x18so5210169pln.6
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 11:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o173Lqk2c5CIYKhQy47SbWBS4LsgYs9/wPlGKEJUhZQ=;
        b=Uxl89bKbQ0EJR0bwVVwTY620vZrEk3wZRGOZUtb7fVjLryPulQ5OtdOqb+1ATwurxm
         jaFVqeUUm7pucJzBnd01cP9RttMAcnikELQ2DYPIl6O1HzoqZbTk1xFfAKAftpvfKQ0f
         LTRlvzC1Vk9G5OXXo5JeOM+CD9AiPFP+ZCAjkd+nmchQsRtrmAWrVG9UDvvdz2bLlgab
         8326RLbVcbuBFJvj54++CN8KsAUK50CCfn5YqvMFNshYFtIj4y5+c4tYWXGCBaEvcd0X
         JiR94/XOY/Ncxv7SEmmc958sKD+oZRx3v1FtXBzBHaxpOTaS3O3KNpOgnF4v71AN3+BS
         N0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o173Lqk2c5CIYKhQy47SbWBS4LsgYs9/wPlGKEJUhZQ=;
        b=WPabfeEyt5n2ywY82ZJ3YjwVya7XOTcYX/1SaNSigiulbghpo+ngWyYEmizDCYbIZ9
         ePcvu2lYNMru/lTUFHrh5Dz3n+FzxJD+xDGap4y+7wwf3W/BW5hPSW2Oo7vcgmK3TQaV
         PiXZPdMZIKn6HNqb1rEr4ur+gtkSFAiwtwjeTeAi3sFc7F1ugtryj9ilFKxDDoOrmDck
         5np9LFLc5qLzgHcJKQb5V4XFBcOulkC1fjxHhqil5GeL2j2ujrqXKZegEtM73KBYZcAJ
         Ngn/SHo3QQ4iAK1GXlWtCdyNn8r0QJjNKhNFB4HB3yIgLxP8IAq4IpCKNhffG72qHVPq
         Z92g==
X-Gm-Message-State: AOAM532AtKy6cKVs7WwKvAwLAtBhY3wtbSxzwwvIg38eFuqI6YDNSwrR
        5e3Mlh69Uc4RHJB7r3UILzMp+A==
X-Google-Smtp-Source: ABdhPJwfOsX4Wx5vyNX8XtAaos1vkW6wGTM5tGYWH1S5rzy+SMeefHNe8U0GzG04aTWa3jyis9E4uw==
X-Received: by 2002:a17:90a:5581:: with SMTP id c1mr12238856pji.86.1610738927523;
        Fri, 15 Jan 2021 11:28:47 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id b6sm8319056pfd.43.2021.01.15.11.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 11:28:46 -0800 (PST)
Date:   Fri, 15 Jan 2021 11:28:40 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 3/3] KVM/VMX: Use try_cmpxchg64() in posted_intr.c
Message-ID: <YAHs6KDoc+O50beV@google.com>
References: <20201215182805.53913-1-ubizjak@gmail.com>
 <20201215182805.53913-4-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215182805.53913-4-ubizjak@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 15, 2020, Uros Bizjak wrote:
> Use try_cmpxchg64() instead of cmpxchg64() to reuse flags from
> cmpxchg/cmpxchg8b instruction. For 64 bit targets flags reuse
> avoids a CMP instruction,

It ends up doing way more (in a good way) than eliminate the CMP, at least with
gcc-10.  There's a ripple effect and the compiler ends up generating the loop
in-line, whereas without the "try" version the loop is put out-of-line.

> while for 32 bit targets flags reuse avoids XOR/XOR/OR instruction sequence.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>

Reviewed-by: Sean Christopherson <seanjc@google.com> 
