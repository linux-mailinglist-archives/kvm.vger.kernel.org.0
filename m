Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA6DC06BD
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 15:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfI0Nx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 09:53:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfI0Nx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 09:53:57 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3D7E92A09CE
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 13:53:57 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id t11so1035125wrq.19
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 06:53:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gd7FrvlLlLRCKChbLW2u6ntiAuLh4NurMyAXEeeS9bw=;
        b=COOLfpyJbvEuk9LMhtUXii/1xPmlMl4xVexogaIOVRmE7cQ6twl2GipzOIbK34lmZ/
         pXd1Rcim5F1y0cz+ZxJ2x9X3cJ8S/5MWTOd4yR7FkXVtZfBZqdSbScyhZIKwuayhiuRP
         KhoINsD8ocy+cUFHqsmYp8CJxy9ZSUZN0uLf/VvsqJfYjoNyZrOCZXdCsmDiBhVOwicg
         RYSsnyA1ioH00ftfLjFJcQLmRXSjENShHFpZeHPf+HvcfqrTYixutw08ETH0MkLK9jVU
         ZqVfRqetMz93V10vKY+KRSTXWQHZV04Ewodt5vcz3JB2nS4CdvnqVjmc3Z9JcdJUSZu3
         T4eg==
X-Gm-Message-State: APjAAAWCYCiWphTIKcjboh7grwWBQSgMbGmOzZ5vDGwVj8bTQIMNF443
        vcsHqWbrfTaoG3GmP0hI+5yio78zfF3d6zbmcEfaWo++aMe9Zxb3rcLmmG2dI3Uv/stYQxQ/RYL
        C1L/kKjcVa3Hk
X-Received: by 2002:adf:e605:: with SMTP id p5mr3259220wrm.105.1569592435978;
        Fri, 27 Sep 2019 06:53:55 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzZAreJITVYk5CoaSouF/d1FvWjHQVTpC2wb/tHJOtLB++11wia5Z9rRXfk5i7IBkrNOZ9tEg==
X-Received: by 2002:adf:e605:: with SMTP id p5mr3259205wrm.105.1569592435788;
        Fri, 27 Sep 2019 06:53:55 -0700 (PDT)
Received: from vitty.brq.redhat.com ([95.82.135.182])
        by smtp.gmail.com with ESMTPSA id a3sm8558894wmc.3.2019.09.27.06.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 06:53:55 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
In-Reply-To: <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com>
References: <20190821182004.102768-1-jmattson@google.com> <CALMp9eTtA5ZXJyWcOpe-pQ66X3sTgCR4-BHec_R3e1-j1FZyZw@mail.gmail.com> <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com> <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com> <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com> <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com> <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com> <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com>
Date:   Fri, 27 Sep 2019 15:53:54 +0200
Message-ID: <87ftkh6e19.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Queued, thanks.

I'm sorry for late feedback but this commit seems to be causing
selftests failures for me, e.g.:

# ./x86_64/state_test 
Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
Guest physical address width detected: 46
==== Test Assertion Failure ====
  lib/x86_64/processor.c:1089: r == nmsrs
  pid=14431 tid=14431 - Argument list too long
     1	0x000000000040a55f: vcpu_save_state at processor.c:1088 (discriminator 3)
     2	0x00000000004010e3: main at state_test.c:171 (discriminator 4)
     3	0x00007f881eb453d4: ?? ??:0
     4	0x0000000000401287: _start at ??:?
  Unexpected result from KVM_GET_MSRS, r: 36 (failed at 194)

Is this something known already or should I investigate?

-- 
Vitaly
