Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB7D2044BE
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 01:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731381AbgFVXrf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 19:47:35 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40232 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730544AbgFVXre (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 19:47:34 -0400
Received: by mail-pl1-f193.google.com with SMTP id x11so8298992plo.7
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 16:47:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JTvITH8zv2UiirsD4c1fgFQNvQdvFMxIvcN0BCe53iI=;
        b=ukJLPxT5CHUlOdv97M0Y6djm9T/pyeKZneCtXdx75I6qq2joZUPSHyrTw7pdTUdBSY
         G77s4coG9ERsLnOAPKNxcF1hi/EMaN5dRs2MfI0O+wFC5k37sgn/6YgHjInutrmZot+y
         hCoN8pZ3IC3HypLfJAX5wCONSqxcj13Fap2kQGqr6aqUGik+yI5zyjX99zmV9HIRtFL4
         csscBKtYRISuLmUUzFZEhouu3/1o1jT94pQMgIPokS3VRyvCgqoyfzOyQYf/gC5OCkfh
         oIP14dnje/Tqm+yqezjOJ+xFb5+FGHjNouBoM/UZpn8+ItiVvsP7jYeHhJrGYDcc2cnn
         OT1A==
X-Gm-Message-State: AOAM532WUUfe/FMRki+p1HgqmyAizSimuukxyd4AoqbhUBSBGrHgS0B6
        t+5jW17nvhz2azCB/M3EbxBIsGasbAk=
X-Google-Smtp-Source: ABdhPJx72Pm6LsNC4fLdGwlzl8iFtNOBSmeItFZY56V7VPMWLT75rU04HboqVu4maibgIS7/Fxkz1A==
X-Received: by 2002:a17:902:ee12:: with SMTP id z18mr21870343plb.211.1592869653523;
        Mon, 22 Jun 2020 16:47:33 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:3602:86ff:fef6:e86b? ([2601:646:c200:1ef2:3602:86ff:fef6:e86b])
        by smtp.googlemail.com with ESMTPSA id n189sm15178382pfn.108.2020.06.22.16.47.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 16:47:32 -0700 (PDT)
Subject: Re: [PATCH v2 00/11] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, babu.moger@amd.com
References: <20200619153925.79106-1-mgamal@redhat.com>
 <5a52fd65-e1b2-ca87-e923-1d5ac167cfb9@amd.com>
 <52295811-f78a-46c5-ff9e-23709ba95a3d@redhat.com>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <2bcdb1cb-c0c5-5447-eed5-6fb094ae7f19@kernel.org>
Date:   Mon, 22 Jun 2020 16:47:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <52295811-f78a-46c5-ff9e-23709ba95a3d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/19/20 4:07 PM, Paolo Bonzini wrote:
> On 19/06/20 23:52, Tom Lendacky wrote:
>>> A more subtle issue is when the host MAXPHYADDR is larger than that
>>> of the guest. Page faults caused by reserved bits on the guest won't
>>> cause an EPT violation/NPF and hence we also check guest MAXPHYADDR
>>> and add PFERR_RSVD_MASK error code to the page fault if needed.
>>
>> I'm probably missing something here, but I'm confused by this
>> statement. Is this for a case where a page has been marked not
>> present and the guest has also set what it believes are reserved
>> bits? Then when the page is accessed, the guest sees a page fault
>> without the error code for reserved bits?
> 
> No, for non-present page there is no issue because there are no reserved
> bits in that case.  If the page is present and no reserved bits are set
> according to the host, however, there are two cases to consider:
> 
> - if the page is not accessible to the guest according to the
> permissions in the page table, it will cause a #PF.  We need to trap it
> and change the error code into P|RSVD if the guest physical address has
> any guest-reserved bits.

You say "we need to trap it".  I think this should have a clear
justification for exactly what this accomplishes and how it benefits
what real-world guests.  The performance implications and the exact
condition under which they apply should IMO be clearly documented in
Documentation/, in the code, or, at the very least, in the changelog.  I
don't see such docs right now.

As I understand it, the problematic case is where a guest OS
intentionally creates a present PTE with reserved bits set.  (I believe
that Xen does this.  Linux does not.)  For a guest to actually be
functional in this case, the guest needs to make sure that it is not
setting bits that are not, in fact, reserved on the CPU.  This means the
guest needs to check MAXPHYADDR and do something different on different
CPUs.

Do such guests exist?  As far as I know, Xen is busted on systems with
unusually large MAXPHYADDR regardless of any virtualization issues, so,
at best, this series would make Xen, running as a KVM guest, work better
on new hardware than it does running bare metal on that hardware.  This
seems like an insufficient justification for a performance-eating series
like this.

And, unless I've misunderstood, this will eat performance quite badly.
Linux guests [0] (and probably many other guests), in quite a few
workloads, is fairly sensitive to the performance of ordinary
write-protect or not-present faults.  Promoting these to VM exits
because you
want to check for bits above the guest's MAXPHYADDR is going to hurt.

(Also, I'm confused.  Wouldn't faults like this be EPT/NPT violations,
not page faults?)

--Andy


[0] From rather out-of-date memory, Linux doesn't make as much use as
one might expect of the A bit.  Instead it uses minor faults.  Ouch.
