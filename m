Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC9B3E5002
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 01:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235336AbhHIXeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 19:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbhHIXeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 19:34:05 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C2AC0613D3
        for <kvm@vger.kernel.org>; Mon,  9 Aug 2021 16:33:44 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id bo18so8393451pjb.0
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 16:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V2c/S/LrwZpcBpKTpdOItZ7Sz1gaTCXfKY8kRI2j8ZQ=;
        b=dssDc9DnwTywEoUHtTg0h4HNe9/5swQv2xI9ksPxKKtX16AuPKlw6njsDkk+om8Vz5
         zjs1wHfVISScdCHvPyLahkek50XfcuwYCRYsOxcNlTUd0zcOLQNQEEwyuqisxY/ieiU9
         86p1GzQrqb1yfXySTvWkFl0jnX0hABIkSR9LN0yOUh/JXoKBU4TqyixlEhk8NUTQAJr3
         LMEJ/nt8nqtNNyuKnxmh+/R7RlSCu7n8Ba3LwNY5R7TzxKtIddcvoqY8h56DOheYO7Zx
         Z4t6o6Nr3Uu0d8o7Ww1l94/GCDqAjgWvuURKf9kiCHZChT5Ow0YQoGupwWNWGtbBlEgp
         zQGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V2c/S/LrwZpcBpKTpdOItZ7Sz1gaTCXfKY8kRI2j8ZQ=;
        b=My/Owv1YFEvK1wQ0mJHh5M9Z7aMTKiZwg7NwVlYRKeO4u5rzqahSdvbFPY72xfiBnE
         MqtF0wHzqatsMstBCu4QYuBmRWe5I1Tya2Wk46qxapsL9CfiO+lyKOa0QEhtBUrN8qe/
         AC7CwjcGxbE9iGMtaLrMPijJ9rvgnyALqlDFtn9yvebZpvvS+M4Amsps+AGxRdJg4uKU
         npSzTAl2iThH8/U4/sKtTYB9laueg+6iDl/6+bjGOvirPjNAyD3ze9u1lJMg+U6gXmTZ
         dGweqow8sINcICsuQup9LT1AE/acr3KqhEVyvDpl3TqcScF1wxGKrrfbRjwvNl9T/gsv
         NMEQ==
X-Gm-Message-State: AOAM530eOG+N2RQZmb4RJZvriBGmOfdxDSlGtwRpz5koVwAOQAE29GwD
        nj4Bt9BCKTv94CCtctLs0XH0dA==
X-Google-Smtp-Source: ABdhPJzRKhUsypoMkmp1CxLWq2G8VZ6jQyI6SBYExAFY0sino5cn9WnvgPn47coA7DhP5f0B8Vvchg==
X-Received: by 2002:a63:f242:: with SMTP id d2mr193701pgk.384.1628552023542;
        Mon, 09 Aug 2021 16:33:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ci23sm19346865pjb.47.2021.08.09.16.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:33:42 -0700 (PDT)
Date:   Mon, 9 Aug 2021 23:33:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Junaid Shahid <junaids@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        bgardon@google.com, pshier@google.com
Subject: Re: [PATCH] kvm: vmx: Sync all matching EPTPs when injecting nested
 EPT fault
Message-ID: <YRG7U3b3ZM17ggp4@google.com>
References: <20210806222229.1645356-1-junaids@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806222229.1645356-1-junaids@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 06, 2021, Junaid Shahid wrote:
> When a nested EPT violation/misconfig is injected into the guest,
> the shadow EPT PTEs associated with that address need to be synced.
> This is done by kvm_inject_emulated_page_fault() before it calls
> nested_ept_inject_page_fault(). However, that will only sync the
> shadow EPT PTE associated with the current L1 EPTP. Since the ASID

For the changelog and the comment, IMO using "vmcs12 EPTP" instead of "L1 EPTP"
would add clarity.  I usually think of "L1 EPTP" as vmcs01->eptp and "L2 EPTP"
as vmcs02->EPTP.  There are enough EPTPs in play with nested that it'd help to
be very explicit.

> is based on EP4TA rather than the full EPTP, so syncing the current
> EPTP is not enough. The SPTEs associated with any other L1 EPTPs
> in the prev_roots cache with the same EP4TA also need to be synced.

No small part of me wonders if we should disallow duplicate vmcs12 EP4TAs in a
single vCPU's root cache, e.g. purge existing roots with the same pgd but
different role.  INVEPT does the right thing, but that seems more coincidental
than intentional.

Practically speaking, this only affects A/D bits.  Wouldn't a VMM need to flush
the EP4TA if it toggled A/D enabling in order to have deterministic behavior?
In other words, is there a real world use case for switching between EPTPs with
same EP4TAs but different properties that would see a performance hit if KVM
purged unusable cached roots with the same EP4TA?
