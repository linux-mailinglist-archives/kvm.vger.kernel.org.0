Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6282F1BA6
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 18:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387728AbhAKQ7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 11:59:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38451 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733136AbhAKQ7v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 11:59:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610384304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=igkOTUJcRP6gu9zhWlV7c8sZTJEiaW9N/+UnuJVWJ/o=;
        b=idaRZNY/iOq2ZDyqJJqPzrvsASCdy3h5rJB1qUWQtNzCYsOzHKwe8e+n/MS9qUWZrE6l0s
        SReSXhKRcdGbyLVBk5UndGhw8jT1uGSm8DlSXulX/CDHhmKM5NSLDRCw7SHgJTYODE8TuY
        W9bA+4fcZ5CDieHFh2Rn7aZfPBpM6vI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-KaMqG44aPI6n6HIezquHEA-1; Mon, 11 Jan 2021 11:58:23 -0500
X-MC-Unique: KaMqG44aPI6n6HIezquHEA-1
Received: by mail-ed1-f69.google.com with SMTP id e11so8507112edn.11
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 08:58:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=igkOTUJcRP6gu9zhWlV7c8sZTJEiaW9N/+UnuJVWJ/o=;
        b=JAsimryJPZIKHdGgtI77BZPOhi7leRPP5ew/A1rtccJaSnKILOkqdRGloyrVhEvor3
         7pudXNdtoh5vAUkfbi5PsROVROgr1ZH5uRgido26NUNThTi1xWp9L/UwZLio/B13c4lG
         ssN/02NY5uwgzEkNNpSjB1hK5hWzJ4IjwM3dcLdmUR3l9zU5PMOF8zw3GHUZGg71xb2F
         CM21e7C2GtGAg2sCBjeHRAx9Ouq2ee691GkPPalB8B7xhSun5vRzViEK7UTEIGyvWbnC
         aUG7x7jwltD2gfzu2R9UESsWHyv/ecm5yKzfGXGqwFLcYoj2tzTTZcFfOh3NkZllfZU4
         oDLA==
X-Gm-Message-State: AOAM533MpKpRB20rEn6fBmIFCpAQ7OErbwFsHoUWHejbdEZAxlr55aCX
        /O0RjbtsEiHdFeFqRyjeY4TY7pSCG7umUsXBNf0SucnhePwvrJNnmv3v/C1FA4yO/05lKBg1pAV
        +ebrrpEhWNoJ8
X-Received: by 2002:a05:6402:46:: with SMTP id f6mr210867edu.163.1610384302017;
        Mon, 11 Jan 2021 08:58:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJytSY5BtaJ19lXCbalttemPTZvtMjBH6K6vdwtm4sajlroq/z3LVX3pK3k3hUyYE5eF96x5PQ==
X-Received: by 2002:a05:6402:46:: with SMTP id f6mr210849edu.163.1610384301870;
        Mon, 11 Jan 2021 08:58:21 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id zn5sm62063ejb.111.2021.01.11.08.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 08:58:21 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 03/13] KVM: SVM: Move SEV module params/variables to sev.c
In-Reply-To: <672e86f7-86c7-0377-c544-fe52c8d7c1b9@amd.com>
References: <20210109004714.1341275-1-seanjc@google.com>
 <20210109004714.1341275-4-seanjc@google.com>
 <87sg7792l3.fsf@vitty.brq.redhat.com>
 <672e86f7-86c7-0377-c544-fe52c8d7c1b9@amd.com>
Date:   Mon, 11 Jan 2021 17:58:20 +0100
Message-ID: <87k0sj8l77.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tom Lendacky <thomas.lendacky@amd.com> writes:

> On 1/11/21 4:42 AM, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>>> Unconditionally invoke sev_hardware_setup() when configuring SVM and
>>> handle clearing the module params/variable 'sev' and 'sev_es' in
>>> sev_hardware_setup().  This allows making said variables static within
>>> sev.c and reduces the odds of a collision with guest code, e.g. the guest
>>> side of things has already laid claim to 'sev_enabled'.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>   arch/x86/kvm/svm/sev.c | 11 +++++++++++
>>>   arch/x86/kvm/svm/svm.c | 15 +--------------
>>>   arch/x86/kvm/svm/svm.h |  2 --
>>>   3 files changed, 12 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 0eeb6e1b803d..8ba93b8fa435 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -27,6 +27,14 @@
>>>   
>>>   #define __ex(x) __kvm_handle_fault_on_reboot(x)
>>>   
>>> +/* enable/disable SEV support */
>>> +static int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
>>> +module_param(sev, int, 0444);
>>> +
>>> +/* enable/disable SEV-ES support */
>>> +static int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
>>> +module_param(sev_es, int, 0444);
>> 
>> Two stupid questions (and not really related to your patch) for
>> self-eduacation if I may:
>> 
>> 1) Why do we rely on CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT (which
>> sound like it control the guest side of things) to set defaults here?
>
> I thought it was a review comment, but I'm not able to find it now.
>
> Brijesh probably remembers better than me.
>
>> 
>> 2) It appears to be possible to do 'modprobe kvm_amd sev=0 sev_es=1' and
>> this looks like a bogus configuration, should we make an effort to
>> validate the correctness upon module load?
>
> This will still result in an overall sev=0 sev_es=0. Is the question just 
> about issuing a message based on the initial values specified?
>

Yes, as one may expect the result will be that SEV-ES guests work and
plain SEV don't.

-- 
Vitaly

