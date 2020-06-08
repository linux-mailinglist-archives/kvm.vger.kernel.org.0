Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE971F1919
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 14:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgFHMvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 08:51:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39910 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727003AbgFHMvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 08:51:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NVMeqLaZj5lyXYDnWx/hOG/1m/ddxwQgh2GukSpwT7M=;
        b=aCbtlUzEk6Eh8KpYU/v6q3OCc3IJeTyI4WeAj1xg4vbVQfRi8hSm0b1+tW5v5EyJzrYNUV
        VIBA2744wQajIRcbiOG8w8UjfTAy+dhNPzuNbWF4+c10yA1uhNUKVlSdhyvIjvki0MrWzj
        wFZ9uUS1SWZbLKjjlzhHgyIH+jpo1/s=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-BUjvq3hOP0-YMioM6eImLw-1; Mon, 08 Jun 2020 08:51:20 -0400
X-MC-Unique: BUjvq3hOP0-YMioM6eImLw-1
Received: by mail-ej1-f72.google.com with SMTP id p27so566176ejn.5
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 05:51:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NVMeqLaZj5lyXYDnWx/hOG/1m/ddxwQgh2GukSpwT7M=;
        b=Is+C9xMn8SshJyjfmxVQtC+pOdloTas2bh/HangS5QSTvPIgfGOhINIsQbTLhz/sWY
         i/pUiA3Ndn8u6+cZeE9Pck9TfYnWfxxHHcV6sjFJfQG/gK0kXqA/zoprM54Gthl3cZeg
         jGqxam5uuJ6QRjH+Mmz6dOGucn3Q6DkA0plQSPjo0i5Q9cbSjMZ275R6LEskdpwhpB3k
         p2Q86EK6EfHLRtjTSY6SyPoMlKOEFg5oXcwS1aT1OFO2CKQcFff0I1OM75472K+PaCNv
         Wrv4cwbNDa0q+7zAw82RwT54StxvC5jljbT8MyBa0rByoSQKLzvDOObb0Jin12j6NGTc
         iYfA==
X-Gm-Message-State: AOAM533IydwyTZ7CGsWwkWCK0jjY3ifFQUWqj9sDSPl/eghI90TfeQQM
        YL6V83zwVL++FtM0eyRAyEVxurmMIyGJwhjB7ojdF8TnXVl7xdMO8/zI/B/XahJYpBh3k1mqyxZ
        6VogU/N9RKb1N
X-Received: by 2002:a17:906:5c0a:: with SMTP id e10mr6274847ejq.389.1591620678813;
        Mon, 08 Jun 2020 05:51:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwznb3Q7pGSNhjg8K3PzgwiJgh47LL1CoCkfvLhLC73i7kpFcsGfbIbjtXZtfhoqoraDN5Qg==
X-Received: by 2002:a17:906:5c0a:: with SMTP id e10mr6274841ejq.389.1591620678637;
        Mon, 08 Jun 2020 05:51:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ok21sm9905881ejb.82.2020.06.08.05.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 05:51:18 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Qian Cai <cai@lca.pw>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: fix calls to is_intercept
In-Reply-To: <20200608121428.9214-1-pbonzini@redhat.com>
References: <20200608121428.9214-1-pbonzini@redhat.com>
Date:   Mon, 08 Jun 2020 14:51:17 +0200
Message-ID: <87wo4hbu0q.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> is_intercept takes an INTERCEPT_* constant, not SVM_EXIT_*; because
> of this, the compiler was removing the body of the conditionals,
> as if is_intercept returned 0.
>
> This unveils a latent bug: when clearing the VINTR intercept,
> int_ctl must also be changed in the L1 VMCB (svm->nested.hsave),
> just like the intercept itself is also changed in the L1 VMCB.
> Otherwise V_IRQ remains set and, due to the VINTR intercept being clear,
> we get a spurious injection of a vector 0 interrupt on the next
> L2->L1 vmexit.
>
> Reported-by: Qian Cai <cai@lca.pw>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	Vitaly, can you give this a shot with Hyper-V?  I have already
> 	placed it on kvm/queue, it passes both svm.flat and KVM-on-KVM
> 	smoke tests.

Quickly smoke-tested this with WS2016/2019 BIOS/UEFI and the patch
doesn't seem to break anything. I'm having issues trying to launch a
Gen2 (UEFI) VM in Hyper-V (Gen1 works OK) but the behavior looks exactly
the same pre- and post-patch.

-- 
Vitaly

