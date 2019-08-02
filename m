Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01FFB80247
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 23:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392193AbfHBVfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 17:35:40 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36849 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392160AbfHBVfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 17:35:39 -0400
Received: by mail-wm1-f67.google.com with SMTP id g67so63487513wme.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 14:35:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nAdpsMp0JwteBK+W0fAmX6K6NSq1AjtuMfd/ePK3wqA=;
        b=aomC3tgrHEgU5ilIktmFK1d5cJpSBOzfWlVYJCuEenMVVoJfjnIIBp2TUnRa9JuWFP
         lgkYyB9Ulq7f78YrCRHiO2HCEH4NKOCAcaAtcX6PfzqOa/Y8w8E396NipakR1PkIMPP3
         MJJaCyigDZLADy9cfey1Saz8184rTjBFdNS/zooBFbPmDOhdZ8w3oLr9LIhkKDN3kfTC
         lKiMV3GaX//Am6tJW2QUYePahiywxtxwhty48emrkLHBS5sqjnQowoXB6vZGXdaACAyG
         vNHwf2pnWJ07/ypLD3Gqp0avJv6Z1iquNAypcV8DV+9AZeDY89sOmKzkbX+SEYPyklNL
         WnbA==
X-Gm-Message-State: APjAAAUqCrqkuaMjzg65ZaReOCfoooWXzw6U7C0zW60eo/f7Vhn3o2Z/
        lEIsep2u+Ti5vBCyjHb++IWrVQ==
X-Google-Smtp-Source: APXvYqwqOtCPXQm2nTlhVq6wHxd0GIQxEdD61fQyKo6RtYwTbatiL3/CMTZFyDXKR7A0RpuJ5jHaVw==
X-Received: by 2002:a05:600c:240e:: with SMTP id 14mr5682450wmp.30.1564781737472;
        Fri, 02 Aug 2019 14:35:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id r123sm72240591wme.7.2019.08.02.14.35.36
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 14:35:36 -0700 (PDT)
Subject: Re: [patch 2/5] x86/kvm: Handle task_work on VMENTER/EXIT
To:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julia Cartwright <julia@ni.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, kvm@vger.kernel.org,
        Radim Krcmar <rkrcmar@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>
References: <20190801143250.370326052@linutronix.de>
 <20190801143657.887648487@linutronix.de> <20190801162451.GE31538@redhat.com>
 <alpine.DEB.2.21.1908012025100.1789@nanos.tec.linutronix.de>
 <20190801213550.GE6783@linux.intel.com>
 <alpine.DEB.2.21.1908012343530.1789@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1908012345000.1789@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c8294b01-62d1-95df-6ff6-213f945a434f@redhat.com>
Date:   Fri, 2 Aug 2019 23:35:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1908012345000.1789@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/08/19 23:47, Thomas Gleixner wrote:
> Right you are about cond_resched() being called, but for SRCU this does not
> matter unless there is some way to do a synchronize operation on that SRCU
> entity. It might have some other performance side effect though.

I would use srcu_read_unlock/lock around the call.

However, I'm wondering if the API can be improved because basically we
have six functions for three checks of TIF flags.  Does it make sense to
have something like task_has_request_flags and task_do_requests (names
are horrible I know) that can be used like

	if (task_has_request_flags()) {
		int err;
		...srcu_read_unlock...
		// return -EINTR if signal_pending
		err = task_do_requests();
		if (err < 0)
			goto exit_no_srcu_read_unlock;
		...srcu_read_lock...
	}

taking care of all three cases with a single hook?  This is important
especially because all these checks are done by all KVM architectures in
slightly different ways, and a unified API would be a good reason to
make all architectures look the same.

(Of course I could also define this unified API in virt/kvm/kvm_main.c,
so this is not blocking the series in any way!).

Paolo
