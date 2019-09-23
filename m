Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5EFBB9FB
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 18:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502062AbfIWQxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 12:53:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39791 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502046AbfIWQxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 12:53:15 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6D41281DF2
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 16:53:15 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id t11so5098622wrq.19
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 09:53:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RCclZaSuQHlKr6RAQuL34ylahD5MmenLni28jEE8EUE=;
        b=hwCox2ikqX+/lmzFkAwlTqmREzgLd6qbjhg9Yqyx0BSjCR85Du75ntWjGs8lMiUHp1
         zigNeuPi5KDRtp4A35lKNXlmnMJ6XuiCTPyGKGs+JwcjOW/apFsQAZOReFX7KGeJbPAd
         0Yv5lDw+2/RV+VJ2ojLo2MsjyOMDb5xF+MoBy4/ubokNxLCySqeyvMkZxyPcvsIce1Dz
         AYzg9O5hQqYHb32sI19C1Hr88UkEeirrEAtdphGeGnDnqm5LHgXM/Xaxy1AeSBGPrpm0
         kf7ajAeqrglKd4sYq92HAdo7xQaNT7ItUCpfnLavjUuMzIvlJNuNfZA1qJaUdQYueFt3
         rywg==
X-Gm-Message-State: APjAAAVF+zUdT58TKte/lUnDnNrwFbAtchl/pX8/Xl/uJp1HIcWJnBCt
        zJ6BgiIof//6L8YwkeNsrH+kDkMKX9Wc3Ia7G7odBGiuhKNsr6WDYjCuCfrDvD10GAHQgpya4sv
        v1f4fZLd4qauq
X-Received: by 2002:adf:fa90:: with SMTP id h16mr318626wrr.52.1569257594018;
        Mon, 23 Sep 2019 09:53:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw1PrWGqSyv7BcQdJ7ID5JNf9nVJ2P4hXs/A2fRvAbEoPTgV55p280V+DXD5wa0V1ZMbivjFQ==
X-Received: by 2002:adf:fa90:: with SMTP id h16mr318609wrr.52.1569257593797;
        Mon, 23 Sep 2019 09:53:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id b22sm12176606wmj.36.2019.09.23.09.53.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 09:53:13 -0700 (PDT)
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
 <20190923163746.GE18195@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <24dc5c23-eed8-22db-fd15-5a165a67e747@redhat.com>
Date:   Mon, 23 Sep 2019 18:53:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190923163746.GE18195@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/19 18:37, Sean Christopherson wrote:
>> Would it be too much if we get rid of
>> kvm_vmx_exit_handlers completely replacing this code with one switch()?
> Hmm, that'd require redirects for nVMX functions since they are set at
> runtime.  That isn't necessarily a bad thing.  The approach could also be
> used if Paolo's idea of making kvm_vmx_max_exit_handlers const allows the
> compiler to avoid retpoline.

But aren't switch statements also retpolin-ized if they use a jump table?

Paolo
