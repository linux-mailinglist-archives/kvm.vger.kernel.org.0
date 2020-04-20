Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD771B12E4
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 19:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgDTRZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 13:25:34 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36273 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726466AbgDTRZd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Apr 2020 13:25:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587403532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Wi4I6E0HOoTIiwC/qCL3vbIOZi357RgujrqauiVCgo=;
        b=SENqR6uYce9hUseA96cdXZPF5e7XvvAFPHPVRDQBlNxCgdlGMnn2oxSCfCDaGZ67o/5avu
        sKEui/+4ZUGdeGzP4l14e8dHiLvE9VYTSgJUWNzm83JymfA6Gtt/X6MtXw9C6Z4HslwpwR
        pfN0zV+7LMGhrEnWlm497HSXrWAHuMI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-mYRT3hG4OrOJtEypAdpgzw-1; Mon, 20 Apr 2020 13:25:31 -0400
X-MC-Unique: mYRT3hG4OrOJtEypAdpgzw-1
Received: by mail-wr1-f72.google.com with SMTP id f15so6061137wrj.2
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 10:25:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Wi4I6E0HOoTIiwC/qCL3vbIOZi357RgujrqauiVCgo=;
        b=c3UnbCcqO0Z4j4sjjGOgRUkN/HalBFCI/aHibp0c0qfW9hWD6KYE/YiFO+eFkD+083
         Gf9rvlPpkudmbTyYsZ4TIyD6oPCEoVThZ9sLXKbjcPEEEafI555KKSXDPbDuq56EblmZ
         +C8UKuA2tOc/BBof72ccPMPeH0Idls4c9JKMdtWOKoCzFErIqVYRUsZre98yX4vdzd04
         FUF4cBMUaSQAZ943e+QIVBtYgMJ793W2KxrkFQbGvD4zfSMm5/qzJyWUfJ9K5Tx3+pgu
         jKU7RXI0ILm1OS/TvmIZNMFF0wp/DtqT3psA5XJzg+UuuZOEa5BtNqq/ic8dW2iEMMre
         0aFg==
X-Gm-Message-State: AGi0PubbrKSUnmONAki9T/iNLEU3QMvBMVmXXikK/V7MCsvVaBvlM/H7
        DGWY477FDYx4EMH5JTWOeZCHzP1f2Oxxpp0PZXQW/clrt6tA4C59/S+r1DVPGQ384/hIxPnk+fD
        ndVVEu3ONUv9K
X-Received: by 2002:adf:c109:: with SMTP id r9mr19678382wre.265.1587403530026;
        Mon, 20 Apr 2020 10:25:30 -0700 (PDT)
X-Google-Smtp-Source: APiQypLifiyD2rISqsBTFDUXYG+CQzr+z4iBiqXWbcljpUFDAk2pWd1/77hoQLgJWF6OMqcIiIWbgw==
X-Received: by 2002:adf:c109:: with SMTP id r9mr19678363wre.265.1587403529829;
        Mon, 20 Apr 2020 10:25:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:199a:e5ab:a38c:544c? ([2001:b07:6468:f312:199a:e5ab:a38c:544c])
        by smtp.gmail.com with ESMTPSA id h2sm240458wro.9.2020.04.20.10.25.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 10:25:29 -0700 (PDT)
Subject: Re: [PATCH v2] kvm: Replace vcpu->swait with rcuwait
To:     Marc Zyngier <maz@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>
Cc:     tglx@linutronix.de, kvm@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>, peterz@infradead.org,
        torvalds@linux-foundation.org, bigeasy@linutronix.de,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        joel@joelfernandes.org, will@kernel.org,
        kvmarm@lists.cs.columbia.edu
References: <20200324044453.15733-1-dave@stgolabs.net>
 <20200324044453.15733-4-dave@stgolabs.net>
 <20200420164132.tjzk5ebx35m66yce@linux-p48b>
 <418acdb5001a9ae836095b7187338085@misterjones.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <22800f1b-3bdb-15b4-7592-93a7b244b45a@redhat.com>
Date:   Mon, 20 Apr 2020 19:25:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <418acdb5001a9ae836095b7187338085@misterjones.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/20 19:12, Marc Zyngier wrote:
>>
>>
>> -    trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
>> +    trace_kvm_vcpu_wakeup(block_ns, !block_check,
>> vcpu_valid_wakeup(vcpu));
> 
> This looks like a change in the semantics of the tracepoint. Before
> this change, 'waited' would have been true if the vcpu waited at all.
> Here, you'd have false if it has been interrupted by a signal, even
> if the vcpu has waited for a period of time.
True, good catch.  Perhaps add macros prepare_to_rcuwait and
finish_rcuwait?

Paolo

