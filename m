Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB9C31A0EA
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 15:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhBLOvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 09:51:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229465AbhBLOvD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 09:51:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613141377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=fkGPzfF0og5mFRGxECEyKUhImqsi69DfMvfWekvM/uQ=;
        b=IJlsyoGZW2BXCTB2tpsDTB2zqUC75YNPHQ0jx0ZWU381uTAgyr7tJDxNqe4vp78F1D3NQs
        ZAz8f5IML6UDKNmHlFxcFk0Ae1uKINHVb+mrdIF9D3PGEZ0D0Km/k4fQYEgHWR3kc3GeQc
        q4SRslQsal097oZO/3+oVVRRqCUmAZ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-V7mVzj0cPg-YhuvelMLt7Q-1; Fri, 12 Feb 2021 09:49:32 -0500
X-MC-Unique: V7mVzj0cPg-YhuvelMLt7Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0C681005501;
        Fri, 12 Feb 2021 14:49:31 +0000 (UTC)
Received: from gigantic.usersys.redhat.com (helium.bos.redhat.com [10.18.17.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 20A2B5C675;
        Fri, 12 Feb 2021 14:49:31 +0000 (UTC)
From:   Bandan Das <bsd@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, wei.huang2@amd.com,
        babu.moger@amd.com
Subject: Re: [PATCH 0/3] AMD invpcid exception fix
References: <20210211212241.3958897-1-bsd@redhat.com>
        <ac52c9b9-1561-21cd-6c8c-dad21e9356c6@redhat.com>
Date:   Fri, 12 Feb 2021 09:49:30 -0500
Message-ID: <jpgo8gpbath.fsf@linux.bootlegged.copy>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 11/02/21 22:22, Bandan Das wrote:
>> The pcid-disabled test from kvm-unit-tests fails on a Milan host because the
>> processor injects a #GP while the test expects #UD. While setting the intercept
>> when the guest has it disabled seemed like the obvious thing to do, Babu Moger (AMD)
>> pointed me to an earlier discussion here - https://lkml.org/lkml/2020/6/11/949
>>
>> Jim points out there that  #GP has precedence over the intercept bit when invpcid is
>> called with CPL > 0 and so even if we intercept invpcid, the guest would end up with getting
>> and "incorrect" exception. To inject the right exception, I created an entry for the instruction
>> in the emulator to decode it successfully and then inject a UD instead of a GP when
>> the guest has it disabled.
>>
>> Bandan Das (3):
>>    KVM: Add a stub for invpcid in the emulator table
>>    KVM: SVM: Handle invpcid during gp interception
>>    KVM: SVM:  check if we need to track GP intercept for invpcid
>>
>>   arch/x86/kvm/emulate.c |  3 ++-
>>   arch/x86/kvm/svm/svm.c | 22 +++++++++++++++++++++-
>>   2 files changed, 23 insertions(+), 2 deletions(-)
>>
>
> Isn't this the same thing that "[PATCH 1/3] KVM: SVM: Intercept
> INVPCID when it's disabled to inject #UD" also does?
>
Yeah, Babu pointed me to Sean's series after I posted mine.
1/3 indeed will fix the kvm-unit-test failure. IIUC, It doesn't look like it
handles the case for the guest executing invpcid at CPL > 0 when it's
disabled for the guest - #GP takes precedence over intercepts and will
be incorrectly injected instead of an #UD.

Bandan
> Paolo

