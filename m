Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8541D29B1
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 10:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgENIIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 04:08:45 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30676 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgENIIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 04:08:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589443723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cOdfBW82qWXPUyvO4VieSyh6O7YUpxTbdcA3Up+HDqM=;
        b=DjVE1iKEB1GGJwA8uSomAe/1RAi3ydMMQT/kI74QBklshxnjUGB3JSuZQ8/MJItrtq+yPA
        lqYwlxJRApUpEp1yCtOomV+W/3YM+jLC17qLt3xGTjesjXjPgISb8yg4fjBCXrJbQVxXJO
        V8EvUpjAcO2DO5Sl4sZpl3MtAks+87c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-rfa_f0LkOAKPEwt-xi7Txg-1; Thu, 14 May 2020 04:08:41 -0400
X-MC-Unique: rfa_f0LkOAKPEwt-xi7Txg-1
Received: by mail-wr1-f70.google.com with SMTP id i9so1177900wrx.0
        for <kvm@vger.kernel.org>; Thu, 14 May 2020 01:08:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=cOdfBW82qWXPUyvO4VieSyh6O7YUpxTbdcA3Up+HDqM=;
        b=PaHNWKiDl2RsjjIEcQijkVncEI0+eV6noNDn3dyMTpriWH+7FSXbedKHNgv0B6fgmr
         Ar33Q4kHYuRyj8xLDNSNF7vIE629OnjZnzZB14cj1Rbjm0kWzjr5srGmSBF2pVDDt2PC
         Zeorrs2dMZgNLv+sCXEBmmDoYTO5PqAiwJrd0ihHLJJ/whzSnLAz5GsyToVv5q6EfcaL
         TWVBDrk1NADBoDROi2pl9AoRk/WhCzQXWDjaDa26RWDwMGPJsvFQHZf/dkRf1Eyv+nhU
         LZgH/mGgyU4ItskLGINix1JXujMdKOg6D7/DPzfjykNXMkIXrXDrqSAZRMjzCPcthz93
         iCzw==
X-Gm-Message-State: AOAM531JjSaHxuiLZbOgaoD0JOEhNggTs9zD8/CERjohkIO7TJTTK8Mj
        3jvuNyBPDJPhghG+pOgFZ5PcYxGovO1NRu8DcA5AGO0ilv5U+lmZdLCSaG2UqnZr0G5Yuv0nnTk
        aUP2bu4DQ83kS
X-Received: by 2002:adf:e7cb:: with SMTP id e11mr3781909wrn.145.1589443720510;
        Thu, 14 May 2020 01:08:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxWvR5OzaMV5kvMXVgfd5dF9p4W8++O/sutBCgKyZ2mU/1rmv9IjNsOFC+/o4Jqnay1RbHXA==
X-Received: by 2002:adf:e7cb:: with SMTP id e11mr3781898wrn.145.1589443720313;
        Thu, 14 May 2020 01:08:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 77sm2987286wrc.6.2020.05.14.01.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 01:08:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] KVM: x86: interrupt based APF page-ready event delivery
In-Reply-To: <20200513184641.GF173965@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com> <20200511164752.2158645-5-vkuznets@redhat.com> <20200512142411.GA138129@redhat.com> <87lflxm9sy.fsf@vitty.brq.redhat.com> <20200512180704.GE138129@redhat.com> <877dxgmcjv.fsf@vitty.brq.redhat.com> <20200513135350.GB173965@redhat.com> <87ftc3lxqc.fsf@vitty.brq.redhat.com> <20200513184641.GF173965@redhat.com>
Date:   Thu, 14 May 2020 10:08:37 +0200
Message-ID: <87zhabdjlm.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Wed, May 13, 2020 at 04:23:55PM +0200, Vitaly Kuznetsov wrote:
>
> [..]
>> >> Also,
>> >> kdump kernel may not even support APF so it will get very confused when
>> >> APF events get delivered.
>> >
>> > New kernel can just ignore these events if it does not support async
>> > pf? 
>> >
>> > This is somewhat similar to devices still doing interrupts in new
>> > kernel. And solution for that seemed to be doing a "reset" of devices
>> > in new kernel. We probably need similar logic where in new kernel
>> > we simply disable "async pf" so that we don't get new notifications.
>> 
>> Right and that's what we're doing - just disabling new notifications.
>
> Nice.
>
> So why there is a need to deliver "page ready" notifications
> to guest after guest has disabled async pf. Atleast kdump does not
> seem to need it. It will boot into second kernel anyway, irrespective
> of the fact whether it receives page ready or not.

We don't deliver anything to the guest after it disables APF (neither
'page ready' for what was previously missing, nor 'page not ready' for
new faults), kvm_arch_can_inject_async_page_present() is just another
misnomer, it should be named something like
'kvm_arch_can_unqueue_async_page_present()' meaning that 'page ready'
notification can be 'unqueued' from internal KVM queue. We will either
deliver it (when guest has APF enabled) or just drop it (when guest has
APF disabled). The only case when it has to stay in the queue is when
guest has APF enabled and the slot is still busy (so it didn't get to
process a previously delivered notification). We will try to deliver it
again after guest writes to MSR_KVM_ASYNC_PF_ACK.

-- 
Vitaly

