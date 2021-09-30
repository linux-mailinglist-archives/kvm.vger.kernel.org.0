Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900BD41DD07
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 17:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245307AbhI3PNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 11:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245139AbhI3PNQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 11:13:16 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B996C06176C
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 08:11:32 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id k23-20020a17090a591700b001976d2db364so5039518pji.2
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 08:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QMXkTSWKWE6IOTwgZL4qEhWkaG0vz1XKQFudBOV/uFM=;
        b=DZam6ASZNWqT//2uufR62sif+1Las8Y6W53M/dKFeka+a6T8T/wMUkKq4LfWwXrDlS
         AKeBKhORnyrCWco1bRD79u/8tR+v1IoJ9YHG5NR4e5ZRNbA2UVO+wg4uvT4Ka9Sh0PaP
         +HqPeWNFp/fTDC+GcAOuLLiUhXggiGO/IBIWXpAoxkXNqnXphVqgalZ6GrigCzDxzdt8
         bN6SzD7IPT2CiRE+IqRFb+xUtOI83CD09AKDCCbbBEnGtlK0AEuMqQpHM1oixXKfRGzn
         6ESDHBGFAj5axFshHo9uhJGDzEpH1jq++TVtyAV2fcuDl+xxzsrPhrXGJCVJTHWe3SBA
         hUwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QMXkTSWKWE6IOTwgZL4qEhWkaG0vz1XKQFudBOV/uFM=;
        b=A7HjUZ0TGcb5pdy0XRw18wCDMr6aHyftaIsf/KHqgRxSyKUXZBlQ3HaF6PgTsSjsHd
         NLy8D2j2zWEOkCwVDsWgzmZK/TZkRmnvhkNzwvekj3L0n1LcZzXqu1VMiwBZh87l8Kqa
         23YRVHZs5KDhFNrzUaCoZeJqljIHY72FZbOMRUMYke6tECUzEqCZ0UJcf8XobPaNtcoE
         O++1fNK/aQNw+vMaavGaP5ENC8QeL7qKXXor84X69CLp895HF8IEjPs8p1ngDaE7q0N9
         IaniyPI6x/3MxydJKzXLURWOcS6lMV/ulFKuSM/FQSSbwQGDKY7A1cbk5+xHnc15l4gy
         CJYQ==
X-Gm-Message-State: AOAM533VoswVdIKIpAIhoshcAps6Thv2vHNSkWDTtgWqCkgLHbo3EIXZ
        UMjb4gfWzrRE734pVbY3kJcw3DcbKi9xww==
X-Google-Smtp-Source: ABdhPJzWcwPdYwdLJ+5nxnLJ3fIdOxEitU8PB0EX6nFJI4cqI6Goe8KhCueoZ13Y7u1uUk383CaqNQ==
X-Received: by 2002:a17:90a:181:: with SMTP id 1mr7110103pjc.214.1633014691201;
        Thu, 30 Sep 2021 08:11:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c4sm3380348pfd.80.2021.09.30.08.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 08:11:30 -0700 (PDT)
Date:   Thu, 30 Sep 2021 15:11:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f3985126b746b3d59c9d@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Manually retrieve CPUID.0x1 when getting
 FMS for RESET/INIT
Message-ID: <YVXTnheIB6MCKGve@google.com>
References: <20210929222426.1855730-1-seanjc@google.com>
 <20210929222426.1855730-3-seanjc@google.com>
 <75632fa9-e813-266c-7b72-cf9d8142cebf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75632fa9-e813-266c-7b72-cf9d8142cebf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021, Paolo Bonzini wrote:
> On 30/09/21 00:24, Sean Christopherson wrote:
> >  	 * RESET since KVM emulates RESET before exposing the vCPU to userspace,
> >  	 * i.e. it'simpossible for kvm_cpuid() to find a valid entry on RESET.
> > +	 * But, go through the motions in case that's ever remedied.  Note, the
> > +	 * index for CPUID.0x1 is not significant, arbitrarily specify '0'.
> 
> Just one nit, this comment change is not really needed because almost all
> callers are using '0' for the same reason.
>
> But, perhaps adding kvm_find_cpuid_entry_index and removing the last
> parameter from kvm_find_cpuid_entry would be a good idea.

I like this idea, but only if callers are forced to specify the index when the
index is significant, e.g. add a magic CPUID_INDEX_DONT_CARE and WARN in
cpuid_entry2_find() if index is significant and index == DONT_CARE.

I'll fiddle with this, unless you want the honors?

> Also, the kvm_cpuid() reference needs to be changed, which I did upon
> commit.

Doh, thanks!
