Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D87B21A5E7
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 19:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgGIRgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 13:36:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33816 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727785AbgGIRgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 13:36:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594316169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Rf6KbfFtmIG7LnYNuQPoAXwBdSxwvydd2I4x8w9fQ4=;
        b=DX8MHb5+BobuxgJ8y7NIpYhYmc7yPvzfILziqd3uWeKVvztan8RkO1JiScI9Hn8JIS0APu
        WiVEEpUfsdVPGHPHGs8EVEeoOfEeTLpqMsWjb0D9obXisA7rPiSFa6pxVqmtNWpP7jvL7Z
        jOYUklUWZUajnpEVZQ05AjBT8qB1P/8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-L2052RQQMLSALcVKPOsCyQ-1; Thu, 09 Jul 2020 13:36:07 -0400
X-MC-Unique: L2052RQQMLSALcVKPOsCyQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0081E1DE0;
        Thu,  9 Jul 2020 17:36:04 +0000 (UTC)
Received: from gigantic.usersys.redhat.com (helium.bos.redhat.com [10.18.17.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C79919D61;
        Thu,  9 Jul 2020 17:36:03 +0000 (UTC)
From:   Bandan Das <bsd@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Makarand Sonare <makarandsonare@google.com>
Subject: Re: [PATCH] KVM: nVMX: fixes for preemption timer migration
References: <20200709171507.1819-1-pbonzini@redhat.com>
        <CALMp9eQPqUUDzzkdHbq05VPFfgm=fP4O6=47ZV7q5eOEVNFPXQ@mail.gmail.com>
Date:   Thu, 09 Jul 2020 13:36:02 -0400
In-Reply-To: <CALMp9eQPqUUDzzkdHbq05VPFfgm=fP4O6=47ZV7q5eOEVNFPXQ@mail.gmail.com>
        (Jim Mattson's message of "Thu, 9 Jul 2020 10:23:22 -0700")
Message-ID: <jpgmu48mvzx.fsf@linux.bootlegged.copy>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Thu, Jul 9, 2020 at 10:15 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> Commit 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer migration",
>> 2020-06-01) accidentally broke nVMX live migration from older version
>> by changing the userspace ABI.  Restore it and, while at it, ensure
>> that vmx->nested.has_preemption_timer_deadline is always initialized
>> according to the KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE flag.
>>
>> Cc: Makarand Sonare <makarandsonare@google.com>
>> Fixes: 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer migration")
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  arch/x86/include/uapi/asm/kvm.h | 5 +++--
>>  arch/x86/kvm/vmx/nested.c       | 3 ++-
>>  2 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>> index 17c5a038f42d..0780f97c1850 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -408,14 +408,15 @@ struct kvm_vmx_nested_state_data {
>>  };
>>
>>  struct kvm_vmx_nested_state_hdr {
>> -       __u32 flags;
>>         __u64 vmxon_pa;
>>         __u64 vmcs12_pa;
>> -       __u64 preemption_timer_deadline;
>>
>>         struct {
>>                 __u16 flags;
>>         } smm;
>> +
>> +       __u32 flags;
>> +       __u64 preemption_timer_deadline;
>>  };
>>
Oops!

>>  struct kvm_svm_nested_state_data {
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index b26655104d4a..3fc2411edc92 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -6180,7 +6180,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>>                 vmx->nested.has_preemption_timer_deadline = true;
>>                 vmx->nested.preemption_timer_deadline =
>>                         kvm_state->hdr.vmx.preemption_timer_deadline;
>> -       }
>> +       } else
>> +               vmx->nested.has_preemption_timer_deadline = false;
>
> Doesn't the coding standard require braces around the else clause?
>
I think so... for if/else where at least one of them is multiline.

> Reviewed-by: Jim Mattson <jmattson@google.com>

Looks good to me, 
Reviewed-by: Bandan Das <bsd@redhat.com>

