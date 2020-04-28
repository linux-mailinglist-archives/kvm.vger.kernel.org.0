Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399921BCF67
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 00:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgD1WFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 18:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725934AbgD1WFb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 18:05:31 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEF6C03C1AD
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 15:05:31 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id s10so464504iln.11
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 15:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h2bHPcz+Hw06E5lzZhtzL1S3rXBWl8eeB+1yUBI5uj8=;
        b=nNu3XLmroPYOks/yCxzYV1EL5CI8jAtMlzb6VmCb0jjzwclVxBun8nO9feJIjPGdGT
         q/Y3WOunRu84FIpjDf9vi3u0DZyqMMzLNnlHXmy43Kb3xanMUAVfN3XB8Qc8Peck6UDE
         yj7OG2EKZAKU/xMsUyedyXwQHax1+FdCJOtdPQMZNccVb2rMlJJTr/v0ZPgpLv9a6CIv
         iOry9SyNOxchFJUt0J6Wkqr5/0184d3PZpPHYmKU38K4SwuIr1s8BXRiPo0ba7Mitkqb
         I6zwXpe/xagT8YIa36b9ibdVTYkjDIRTESPkVC+DYy5EeoYZg+CadrHRt/rhjYKVSwa7
         AqTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h2bHPcz+Hw06E5lzZhtzL1S3rXBWl8eeB+1yUBI5uj8=;
        b=Y/Ml8AUTToPVyK/YMRtaglwkfATsLaT6wDIhpE48NXEw/fW4oyaIsRAdSjesmVUU7g
         aSXYNZk+qrOwmT60J9J+TOKL3CelventmcRB5Th8jcvqgZEG8hJK5wSvNpYZCm7M+kIv
         g1TRLax/iunKLHksSUX5N/7asXraOfnrxbijOUdG1mM6mq69g/wJS+BxtmwHeqHRYGHz
         A+qCYa6jIVGk1/LN9vjd5n4RUtwqJWL5XW3t+MwAZYF+fOgDg70hgLreaZAnQb+d4YPn
         MOaWahEIIp+FdLwAOCey37yNooJs9FyTCpiVem5U2PlJ542unKjomhwPSRhUwD49nrAQ
         lYrw==
X-Gm-Message-State: AGi0PuatjAHk5zzxEiFJlMIoBJtvzYZdf8mBr58fZzkcZd07CnCv4znW
        j/iLI+dq4yVGNHgSiLQSSCg7s8WmMyWDbJniYm9DUw==
X-Google-Smtp-Source: APiQypLDs98qc/t/GpQOp6kjYdoPKQPXaTdVNmlb6AmBbafdjgYAMIpNm4XyVZ+txa4ysTmPI23Ggrj4mNTde/VZz28=
X-Received: by 2002:a92:da4e:: with SMTP id p14mr28533336ilq.296.1588111530404;
 Tue, 28 Apr 2020 15:05:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200423022550.15113-1-sean.j.christopherson@intel.com> <20200423022550.15113-11-sean.j.christopherson@intel.com>
In-Reply-To: <20200423022550.15113-11-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 15:05:19 -0700
Message-ID: <CALMp9eT+YkjPH3m9hTEDEn7pj1_y4Hw4bmUq861Odvg1Q47hxA@mail.gmail.com>
Subject: Re: [PATCH 10/13] KVM: x86: WARN on injected+pending exception even
 in nested case
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 7:26 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> WARN if a pending exception is coincident with an injected exception
> before calling check_nested_events() so that the WARN will fire even if
> inject_pending_event() bails early because check_nested_events() detects
> the conflict.  Bailing early isn't problematic (quite the opposite), but
> suppressing the WARN is undesirable as it could mask a bug elsewhere in
> KVM.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
