Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5EB177189
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 09:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbgCCIul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 03:50:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47315 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727322AbgCCIuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 03:50:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583225439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KHCYOJTmBBdpFLT9MqAvZOM7WPdtVRLxrFg9V7woKHU=;
        b=d8XyHeNuplJ0GjhI/xS+uc3spkH4I+jcRspXPf5Pxz6tniMjB6wrMuKKGAe3mynNK/SGoY
        4LZwtFGmJzvPuE1H4AypTgQ5hih4aL6bCHvTk5AynExwA0pSzJMovuWezDmveqSGojQYcZ
        /SvUeHkrfAx07PXSz8iFXZGIoPezc/M=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-OFU7Hr9NNma6BHjcp6jbOA-1; Tue, 03 Mar 2020 03:50:38 -0500
X-MC-Unique: OFU7Hr9NNma6BHjcp6jbOA-1
Received: by mail-wr1-f70.google.com with SMTP id w18so929145wro.2
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 00:50:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KHCYOJTmBBdpFLT9MqAvZOM7WPdtVRLxrFg9V7woKHU=;
        b=toEA7IdtjxszMwuApq/jXG7XJAtVVyVKZzZBtvkHBmMVXH3JEoGcMxOhn2DdT7m8b7
         1DWprpaDbtID7Cs2jf9IkrSs36JwtVneO8ds5vfoNeelAcv1bEI3YOtLbalOUM9Znyn4
         5ft5Rx6NvE5YUZG+ZBm6SSVXvCd6/6XA6N6DoPDtM121wF3pBbcpTlm+BGJuart2Wsrs
         nShVpWAbUKPEy5HM9zmOmur6MU+y6lppuW5VvbUR9fLkwh3PqEYR3zGL0kWOTXvD+DzV
         X5gtqXdZCHVrEY0/KdqZVkx5HI2nmJNO81s6EsBf4bijcM4oJpY2jYCpMiZsuLpyTJI3
         Y4+Q==
X-Gm-Message-State: ANhLgQ1an3STUBhBZjKQs8T8ujb8Lx7LpVwMA6Qi7IVVf4caN5PdSl+O
        acCznhVUcqGPOTKj7IpS+XTaR9C68yOF/L4OyIzSnz7VLKQUJPLYOF+eWs/AvxVXlKutL4FH2E3
        bnzOkVUeeMGFL
X-Received: by 2002:a7b:c183:: with SMTP id y3mr3222186wmi.0.1583225437085;
        Tue, 03 Mar 2020 00:50:37 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsHC5SYzgpmvbQfX4p+aLP1LZEoxbKKcMdLptVUvUe1f3DxH4lN1yoJQf/QIJzqiTTL5Nejkg==
X-Received: by 2002:a7b:c183:: with SMTP id y3mr3222168wmi.0.1583225436860;
        Tue, 03 Mar 2020 00:50:36 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4c52:2f3b:d346:82de? ([2001:b07:6468:f312:4c52:2f3b:d346:82de])
        by smtp.gmail.com with ESMTPSA id n3sm2748163wmc.42.2020.03.03.00.50.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 00:50:36 -0800 (PST)
Subject: Re: [PATCH] KVM: nVMX: Properly handle userspace interrupt window
 request
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
References: <20200303062735.31868-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2ba06866-b83d-969f-925d-acb2743de20d@redhat.com>
Date:   Tue, 3 Mar 2020 09:50:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303062735.31868-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 07:27, Sean Christopherson wrote:
> Odds are good that this doesn't solve all the problems with running nested
> VMX and a userspace LAPIC, but I'm at least able to boot a kernel and run
> unit tests, i.e. it's less broken than before.  Not that it matters, I'm
> guessing no one actually uses this configuration, e.g. running a SMP
> guest with the current KVM+kernel hangs during boot because Qemu
> advertises PV IPIs to the guest, which require an in-kernel LAPIC.  I
> stumbled on this disaster when disabling the in-kernel LAPIC for a
> completely unrelated test.  I'm happy even if it does nothing more than
> get rid of the awful logic vmx_check_nested_events().

Yes, userspace LAPIC is more or less constantly broken.  I think it
should be deprecated in QEMU.

Paolo

