Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0C2486D7D
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 00:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245335AbiAFXDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 18:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245283AbiAFXDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 18:03:00 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10D9C061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 15:03:00 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id i30so3908842pgl.0
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 15:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fndk2gTaTevNR9uOpjYa5/HbXIHpfIaLIELQ1cRgEhk=;
        b=ke9/viSFChAf3UsTJUSU0KZBlwRjxjPeZiHoyLuN+ksnAWalCUDs9Kr6g2xtNhisc1
         nMU5OfSO8tmw3CJrH9cVE4aJUF6CnmkNFtdx5d4Pwg99Mz74OudmcS82xqixkwf+ONLv
         VfomdlE1pRkxnOuE7Nr1YjDMpYrZgDE9nb6XoXrmSS5ieDYfaIIdC+sfNN4raqRgOSAI
         Gul+5WWzYRbNf/4PEWhKC2zaRezFv8jqLVHa4LVsW0b+/K6ZnrgonaseWzB6Ql7MJmy0
         nZATfX6fjC7gYQcMZH8DR3kcsTUprw2xI8TYpisTkAiLVhm13nb+vTyK3iKnWNIc1SOu
         Wx6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fndk2gTaTevNR9uOpjYa5/HbXIHpfIaLIELQ1cRgEhk=;
        b=0CiL6TuoQeHv4SRcbv2zZR3KcP7Ntnp+4WlG81ueQgXCfxSRhslgZ+0TgQC0ig3RL5
         gATSUJSi0f7/oLmR5cEYbH96zIAPG6zxwwIsqAm3txmUPu3NwGp5n6NmVfXm4z+borRx
         VlbuZs9OSoEzbFJBCgl3xI+AnopARVZqdK/qyIxTfms7Dy+xZUXRYBam/RR8WacvMijM
         mf9p6w0LJDRF1SkeMm4BRyl+8e/TFiQrPLI98d6sXm8+4ycMeWxt7587H5x1SSjc6DFa
         7TzM/dT+05xXznMZOYBDu5p2tG1tRW/kfyyP6r8SE+NOEgMyvggW3tJrpMV+qWlaIFRr
         RMxQ==
X-Gm-Message-State: AOAM532z9tSnguXHt8HeblZuVcYpmZw87PuE6WZEyz75EnWJADzzcHMl
        UCz1clGvAlBMeQnq7lPm4wH8Rw==
X-Google-Smtp-Source: ABdhPJxTE7e4P380HZkFb+44DneJwH2bhlgHRMfqIRun/v/OheFKpZegAjNQt26rSRixYeCTrr+ZIg==
X-Received: by 2002:a05:6a00:985:b0:4bb:d3c:170c with SMTP id u5-20020a056a00098500b004bb0d3c170cmr61582862pfg.73.1641510178516;
        Thu, 06 Jan 2022 15:02:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v6sm2773407pgj.82.2022.01.06.15.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 15:02:57 -0800 (PST)
Date:   Thu, 6 Jan 2022 23:02:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 08/13] KVM: x86/mmu: Refactor TDP MMU child page
 initialization
Message-ID: <Ydd1HsZFzb0faEvV@google.com>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-9-dmatlack@google.com>
 <YddYGIoTaFloeENP@google.com>
 <CALzav=f4XPATmTA4YVMNswy4frCDYScpdA1+69oJ8pkJdT6hCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=f4XPATmTA4YVMNswy4frCDYScpdA1+69oJ8pkJdT6hCg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022, David Matlack wrote:
> On Thu, Jan 6, 2022 at 12:59 PM Sean Christopherson <seanjc@google.com> wrote:
> > Newline.  I'm all in favor of running over when doing so improves readability, but
> > that's not the case here.
> 
> Ah shoot. I had configured my editor to use a 100 char line limit for
> kernel code, but reading the kernel style guide more closely I see
> that 80 is still the preferred limit. I'll go back to preferring 80 and
> only go over when it explicitly makes the code more readable.

Yeah, checkpatch was modified to warn at 100 chars so that people would stop
interpreting 80 as a hard limit, e.g. wrapping due to being one character over,
but 80 is still the soft limit.
