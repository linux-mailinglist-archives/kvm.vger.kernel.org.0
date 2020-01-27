Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEF614ABC5
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 22:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgA0Vwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 16:52:30 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45105 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726080AbgA0Vw3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jan 2020 16:52:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580161948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=55UOneL2ms6DRqRkSC42nE9sElCV4+6dsT8xJuc/F90=;
        b=V1JT0i37/WeBVMyaF3+WiSS4aoni8rwOXrilPfRv9zopwvOHLwOjcWCqVSCa6geLqgtToa
        nZ3ABSIKGrCGgWruOYrQ1GR/yNOA/xVcDPbh4Gpu04Qg5LXevxIc22H2beyNHoO0t0O1Lw
        t1uSETkrVwrvDPbhwN0xL2tDXbFUlgo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-9pXfDR-ANReB5CFho_NrcQ-1; Mon, 27 Jan 2020 16:52:27 -0500
X-MC-Unique: 9pXfDR-ANReB5CFho_NrcQ-1
Received: by mail-wr1-f69.google.com with SMTP id c17so6911188wrp.10
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2020 13:52:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=55UOneL2ms6DRqRkSC42nE9sElCV4+6dsT8xJuc/F90=;
        b=LWmzWQZt3mEBErljd8pUZQKpEJvqy5TY8+CpMQfesHzKqwRJYFRkZikoT5gHPIxzit
         n9rBYLJUptmrIfzRvrD85NgKT3mSslAqCuBHxKK9YepvOQ6fVPPmIp5lRY06BkwLLVNS
         YXmD0bmuh7K2Wsp4pam0e4d1HDtjuvEY0fmhXxcCMy3vVezpYc+rVipeGESYu2bduK01
         mfUqNVKoeOrWL9K1VB+M+sOQAPPnLw+XE63Gxp8fykji8fhw/mxn1v+lK4t6XQTXSiei
         lMW+LQXyQhv5h3ZkpErM4QSej5tWx0L7hO91w5IljN4TsjO4r6H4+lfMN1zl/iOc7day
         LpNQ==
X-Gm-Message-State: APjAAAXaSxzNq3UtltmM1fjoCtjPKup5KU9vSEK1V1SSV8eV3PVsD5Ir
        vCu0IX4BJZ2sYCd/KWR2/LGiy1prrOwxONSHM/bwO6/DcoPZfiF1EseK6icQsE+I0WCS+FAEYuC
        AtahGEosSeUnB
X-Received: by 2002:adf:f491:: with SMTP id l17mr26182316wro.149.1580161946252;
        Mon, 27 Jan 2020 13:52:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqwW8T//Ne2f8Is87AT0Y5y0DKFSDxo9Fc+kgWX8pRXRYg+owSNawJWD3LvoveF6z4qyBIIsTA==
X-Received: by 2002:adf:f491:: with SMTP id l17mr26182296wro.149.1580161945983;
        Mon, 27 Jan 2020 13:52:25 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n28sm23292967wra.48.2020.01.27.13.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 13:52:25 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization out of nested_enable_evmcs()
In-Reply-To: <437c2710-7148-a675-8945-71dc7a90f7dd@redhat.com>
References: <20200115171014.56405-3-vkuznets@redhat.com> <6c4bdb57-08fb-2c2d-9234-b7efffeb72ed@redhat.com> <20200122054724.GD18513@linux.intel.com> <9c126d75-225b-3b1b-d97a-bcec1f189e02@redhat.com> <87eevrsf3s.fsf@vitty.brq.redhat.com> <20200122155108.GA7201@linux.intel.com> <87blqvsbcy.fsf@vitty.brq.redhat.com> <f15d9e98-25e9-2031-2db5-6aaa6c78c0eb@redhat.com> <87zheer0si.fsf@vitty.brq.redhat.com> <87lfpyq9bk.fsf@vitty.brq.redhat.com> <20200124172512.GJ2109@linux.intel.com> <875zgwnc3w.fsf@vitty.brq.redhat.com> <437c2710-7148-a675-8945-71dc7a90f7dd@redhat.com>
Date:   Mon, 27 Jan 2020 22:52:24 +0100
Message-ID: <87tv4glg87.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 27/01/20 16:38, Vitaly Kuznetsov wrote:
>>>> If there are no objections and if we still think it would be beneficial
>>>> to minimize the list of controls we filter out (and not go with the full
>>>> set like my RFC suggests), I'll prepare v2. (v1, actually, this was RFC).
>>> One last idea, can we keep the MSR filtering as is and add the hack in
>>> vmx_restore_control_msr()?  That way the (userspace) host and guest see
>>> the same values when reading the affected MSRs, and eVMCS wouldn't need
>>> it's own hook to do consistency checks.
>> Yes but (if I'm not mistaken) we'll have then to keep the filtering we
>> currently do in nested_enable_evmcs(): if userspace doesn't do
>> KVM_SET_MSR for VMX MSRs (QEMU<4.2) then the filtering in
>> vmx_restore_control_msr() won't happen and the guest will see the
>> unfiltered set of controls...
>> 
>
> Indeed.  The place you used in the RFC is the best we can do, I am afraid.
>

In case we decide to filter out the full set of unsupported stuff
there's basically nothing to change, feel free to just treat the RFC as
non-RFC :-) (and personally, I'd prefer to keep the 'full set' in the
filter as it is less fragile; the 'short list' I came up with is the
result of my experiments on one hardware host only and I'm not sure what
may make Hyper-V behave differently).

I can re-submit, of course, if needed.

-- 
Vitaly

