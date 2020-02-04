Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22A6B151C6B
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 15:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgBDOmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 09:42:10 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53814 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727250AbgBDOmK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 09:42:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580827329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CtNuq+c53520XJbZSzjdH2GmUQ771nRPcTR/Jk2Pais=;
        b=GhK5f+pMeZWRQvW/yUXgbHCznJNiTlkNVWIZ0RCgpN04KOcdkkS6G1Ts5848aUysfgdeqf
        Txh1gXLZCCkbVAqv1pab7vDs/cpZOlbfrkPVnK2F3Enm4vtDul7TyvEoUEtrMmt7kLLqY+
        8f2iHCVb1SQ1jNiAZDFK/5vHoKJ5VMU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-z8CpsbBpNFutSNHC09dREA-1; Tue, 04 Feb 2020 09:42:07 -0500
X-MC-Unique: z8CpsbBpNFutSNHC09dREA-1
Received: by mail-wr1-f72.google.com with SMTP id v17so10219566wrm.17
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 06:42:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=CtNuq+c53520XJbZSzjdH2GmUQ771nRPcTR/Jk2Pais=;
        b=Xifz7OEBU/V2ytX1rJ3h293ZDPiArRMUPNhTgBpY+qwcW5ojbGSYQLdju0XZ2BijIP
         sTyYkIAirRGp5GxnVPz8sJ9Lteix631J6bT/KfKUownZBdnCwuxSpAMZMOuYzPzHOq7Q
         cxcBuGbjd+77jorq6kIUsPZkS0I6EKdlZKzWvVjv1yNnL9yqKi9xlTp78qwSPqcLZFnL
         /TYXNe5xOPEWCVr60i0FageulsighOc7zF15bWue67H4IIkUFnuDVB4/FmL+hIn1SQdA
         mPbtI15TTHdu3sXpnUjB1ZB3RLLZ5orAV+U5N9YO1raOsOf873UoPrPmuoS7fUCxZlqO
         JITQ==
X-Gm-Message-State: APjAAAWbmK1e8hE0FNwsQk16MRvGCP607tb+po7/a4v+07MxCl+EZA+q
        RZDrNL9eAmmgTUzP+O2S7X4oBPTFpcJbZO2rx0H6rwVpmth8XW/IauoIv51C3WKiZ78HJj0X7u1
        JZIRyzRmd9Lt/
X-Received: by 2002:a1c:9a84:: with SMTP id c126mr6355190wme.111.1580827326387;
        Tue, 04 Feb 2020 06:42:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqypTDEDakV76RkWQqeNB72gLx3oT4S4iakRJIIuDBeaPp0gC9/miKhqArP5K8jyNcHqIoM9Mg==
X-Received: by 2002:a1c:9a84:: with SMTP id c126mr6355174wme.111.1580827326200;
        Tue, 04 Feb 2020 06:42:06 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t5sm29943498wrr.35.2020.02.04.06.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 06:42:05 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: Pre-allocate 1 cpumask variable per cpu for both pv tlb and pv ipis
In-Reply-To: <20200204142733.GI40679@calabresa>
References: <CANRm+CwwYoSLeA3Squp-_fVZpmYmxEfqOB+DGoQN4Y_iMT347w@mail.gmail.com> <878slio6hp.fsf@vitty.brq.redhat.com> <CANRm+CzkN9oYf4UqWYp2SHFii02=pvVLbW4oNkLmPan7ZroDZA@mail.gmail.com> <20200204142733.GI40679@calabresa>
Date:   Tue, 04 Feb 2020 15:42:04 +0100
Message-ID: <871rrao1mr.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thadeu Lima de Souza Cascardo <cascardo@canonical.com> writes:

>> > >      /*
>> > > @@ -624,6 +625,7 @@ static void __init kvm_guest_init(void)
>> > >          kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
>> > >          pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>> > >          pv_ops.mmu.tlb_remove_table = tlb_remove_table;
>> > > +        pr_info("KVM setup pv remote TLB flush\n");
>> > >      }
>> > >
>
> I am more concerned about printing the "KVM setup pv remote TLB flush" message,
> not only when KVM pv is used, but pv TLB flush is not going to be used, but
> also when the system is not even paravirtualized.

Huh? In Wanpeng's patch this print is under

	if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME))

and if you mean another patch we descussed before which was adding
 (!kvm_para_available() || nopv) check than it's still needed. Or,
alternatively, we can make kvm_para_has_feature() check for that.

-- 
Vitaly

