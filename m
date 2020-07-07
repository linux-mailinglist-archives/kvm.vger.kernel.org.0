Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FA7217514
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 19:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgGGR0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 13:26:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49930 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727791AbgGGR0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 13:26:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594142769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KfTUk9PAGIk1UnNRy8zSV6nw0M/fTj95s0UbcyGGc9I=;
        b=YxD3WkaQS9phFJe3jt6z3pvdSB1HZ1q/Z41/hxmGQpLKsEsY8of2+rLSNUsuxZL342Nxkm
        sj5//zrOU+k/q9HrXbgaCtEJEFqHK4s555Tg6bX67f24rETTgtc+D7EcV2QTjK4TpK2ojO
        jNbD6g5LR1NMLECh/TeBX3NwjuL43AM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-H_XJtt4wPkew1PFf0W-hRw-1; Tue, 07 Jul 2020 13:26:06 -0400
X-MC-Unique: H_XJtt4wPkew1PFf0W-hRw-1
Received: by mail-wr1-f70.google.com with SMTP id c6so30018599wru.7
        for <kvm@vger.kernel.org>; Tue, 07 Jul 2020 10:26:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KfTUk9PAGIk1UnNRy8zSV6nw0M/fTj95s0UbcyGGc9I=;
        b=NbCdT2H7+wAIQqap286k/sNvlvDNTVC4LDjcOtolHLzprjoCMDBSUVX8fHhqyttpW3
         lRQn6rS+SJhWQB+6GHsVBYA55qLtdawijJOfgQlDrEPZuuliMw8eSh5O79JOP07fFNTA
         TKtLncMyopeXGoMzSw6cTEAx8PVBb9FFAFF4S4lXkJOA5hh2s5ZPspiOkMiLso/B+WIr
         7f+i+XYDqPNCqqJxXhXiYSEQKimLDJ/1lm3WZGbpbRDY6uE2yKzuTtKpeSsyfJBSxEV1
         h3Lqhsb3+RCJVtajBRXHw4WvoyfEr/XQ6rfcaQOR2gNoGF1eMsj5XftoS2oR32s10Ebc
         KfmA==
X-Gm-Message-State: AOAM532Vy6sTNmNB5dnBBNZxwf57wdm+0fvYjdcXAbtLT2uoIF2c07eJ
        seQiQn+jkT2+DrFu/ulAGnGcIZzyTsCj+jmEROjQ+P9ECQVdL3keY4/a1K//BxFehkO4uFYJxvB
        nlKPxWlVv7JmA
X-Received: by 2002:a5d:5587:: with SMTP id i7mr53279469wrv.314.1594142764779;
        Tue, 07 Jul 2020 10:26:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJys31mXYPkvFr+OKDY2YGUbbkO9gWFPb7K0WfeuTUl+TuLBtnwm1fCRnPSymz3Zh67H8Nqlmg==
X-Received: by 2002:a5d:5587:: with SMTP id i7mr53279447wrv.314.1594142764544;
        Tue, 07 Jul 2020 10:26:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e95f:9718:ec18:4c46? ([2001:b07:6468:f312:e95f:9718:ec18:4c46])
        by smtp.gmail.com with ESMTPSA id a3sm1808226wmb.7.2020.07.07.10.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 10:26:03 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: rewrite kvm_spec_ctrl_valid_bits
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20200702174455.282252-1-mlevitsk@redhat.com>
 <20200702181606.GF3575@linux.intel.com>
 <3793ae0da76fe00036ed0205b5ad8f1653f58ef2.camel@redhat.com>
 <20200707061105.GH5208@linux.intel.com>
 <7c1d9bbe-5f59-5b86-01e9-43c929b24218@redhat.com>
 <20200707081444.GA7417@linux.intel.com>
 <f3c243b06b5acfea9ed4e4242d8287c7169ef1be.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ed934ade-f377-4de1-55bb-d0c1a2770be0@redhat.com>
Date:   Tue, 7 Jul 2020 19:26:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <f3c243b06b5acfea9ed4e4242d8287c7169ef1be.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/20 13:35, Maxim Levitsky wrote:
> After thinking about this, I am thinking that we should apply similiar logic
> as done with the 'cpu-pm' related features.
> This way the user can choose between passing through the IA32_SPEC_CTRL,
> (and in this case, we can since the user choose it, pass it right away, and thus
> avoid using kvm_spec_ctrl_valid_bits completely), and between correctness,
> in which case we can always emulate this msr, and therefore check all the bits,
> both regard to guest and host supported values.

Unfortunately, passing it through is just too slow.  So I think it's
overkill.  There's two ways to deal with badly-behaved guests blocking
migration: 1) hide SPEC_CTRL altogether 2) kill them when migration
fails; both are acceptable depending on the situation.

Paolo

> Does this makes sense, or do you think that this is overkill?

