Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0BB21A6CE
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 20:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgGISYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 14:24:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54369 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726116AbgGISYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 14:24:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594319047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hrUu54pau6Z14x+8fMsvL9C3uFgIczVUTJI1abmxIqI=;
        b=TGPviVTPQ29Y2o+x0/bLQ9BJNkNcMdi/rFANMiip7ClWoBaarGGB4+WG7MVefvIslNfNUp
        5i3FLskQolAmUqL4PM2JqTnmxm+aOuYVBzRggFTtHrTzJgEEiD9PO7qWMRNdIPy9BoZDsa
        8QTAW6f8OVBSTVZSwzSemURGtE+FK+c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-gdhNUhaLPhqtjlP_fRzvKg-1; Thu, 09 Jul 2020 14:24:06 -0400
X-MC-Unique: gdhNUhaLPhqtjlP_fRzvKg-1
Received: by mail-wr1-f70.google.com with SMTP id b8so2692612wro.19
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 11:24:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hrUu54pau6Z14x+8fMsvL9C3uFgIczVUTJI1abmxIqI=;
        b=DRXc66sXx2/zdwZSh9SdgaaZYpRmWp1w35vexNGn8pnOlubOTr4UxSR5+lEd918nmP
         hN4SAaeaCSnKLzTDp0gwuWKyDv45tzi5B6ALOgcBL1zpsd1JVg2ZZnncjavlDoTnob+p
         Lf0n7i1GfQVOp2EbSaiGke8Ufind/MJZ0YotgIyXLCo22tu3JY/UolBtuWub9Q7NXWvr
         DysYU41oV7lFoFXRoH4bhkm7XWQO9/ZHWs4HMKsHqrmJTH5N3e5bx4QLYbCj1GUWMUHS
         ba8VPg0xhOwtUNP6jBN4vFNK8bDjgu2be4iWk6nAm3YWZDfO9uUABKAg9ZI7CVlFTiAz
         1z3Q==
X-Gm-Message-State: AOAM530FH0t1fStkg0x6QZ5FCFld7NOXN3jnMwsI7gMICCPY0UjYxCDV
        LTKZC5irQvlz690aPwxtYgololpD9k6S5YPa5280QUqxSFXmJ4u5fSv7ZEz9rhjmeyBB/S+3KHb
        RDpmYcxKXXluX
X-Received: by 2002:a5d:6987:: with SMTP id g7mr63901654wru.79.1594319045371;
        Thu, 09 Jul 2020 11:24:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3tt18EFpY6nLsMYasMrv46UnHAWmPZe5fYgh+nyfdNuqIuyQzmxb1CgwkTn1pj3QzgppBbA==
X-Received: by 2002:a5d:6987:: with SMTP id g7mr63901637wru.79.1594319045192;
        Thu, 09 Jul 2020 11:24:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id y7sm6668692wrt.11.2020.07.09.11.24.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 11:24:04 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
To:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200622220442.21998-1-peterx@redhat.com>
 <20200622220442.21998-2-peterx@redhat.com>
 <20200625061544.GC2141@linux.intel.com>
 <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com> <20200626180732.GB175520@xz-x1>
 <20200626181820.GG6583@linux.intel.com>
 <47b90b77-cf03-6087-b25f-fcd2fd313165@redhat.com>
 <20200630154726.GD7733@linux.intel.com> <20200709182220.GG199122@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7aa46e68-5780-2698-67f5-425693478fe1@redhat.com>
Date:   Thu, 9 Jul 2020 20:24:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709182220.GG199122@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 20:22, Peter Xu wrote:
>>> So I think Peter's patch is fine, but (possibly on top as a third patch)
>>> __must_check should be added to MSR getters and setters.  Also one
>>> possibility is to return -EINVAL for invalid MSRs.
> Yeah I can add another patch for that.  Also if to repost, I tend to also
> introduce KVM_MSR_RET_[OK|ERROR] too, which seems to be cleaner when we had
> KVM_MSR_RET_INVALID.

You can use either that or 0/1/-EINVAL.  I would be fine with that to
keep the patch small.

Paolo

