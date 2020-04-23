Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D821B1B6403
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 20:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgDWSsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 14:48:06 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49737 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726116AbgDWSsF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 14:48:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587667684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UP4LvX8gxcGhISOea8YwNFKWeVA+DfOShDtScHbi7jk=;
        b=Lbf1zBYn3GSdWiAtap195sAc7J3kBOHIRy+mwOLP3/V1iv4jgs5zIA5F5SuWfHTwRxG0iF
        qZGioBMSm4gswCsuxSJ87X9YDOPGHJVyLmXPD5Ij5/Dk8NkoL6ry2vKg++osAYmgU4NyeE
        AfjMljJOIzFMrKB49GISWrqnLiXGLR4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-2QzuVPVSP0-9ULhMbJAOyQ-1; Thu, 23 Apr 2020 14:47:52 -0400
X-MC-Unique: 2QzuVPVSP0-9ULhMbJAOyQ-1
Received: by mail-wr1-f70.google.com with SMTP id x15so3366512wrn.0
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 11:47:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UP4LvX8gxcGhISOea8YwNFKWeVA+DfOShDtScHbi7jk=;
        b=OWyzScE83LbbKR8pWQ0ILihLsSZtSqGXcjrCaIs5qYdC9+mnImZni9Rv8ovHTrHiSX
         hKYWI0PdJfz+kK7nv06ggoFTmnhTFF3tkqUEHt8YWXgMOlp3z5zoadGHc5y/0OfKJbkO
         vMIMcry9K+9vWIuzDw/XvTaXsxL0LsJYHIjxjC7Wz5VSNQjt1EsxH8EPoM8gwmY7gQRJ
         wohFLVf0JwB9fh0KuV0PCd6ZSocG5yUot4PUszbRfy03x/ZgueZB+WHQrabDninYBC7I
         WpQRfdqLxXCo1hdItO+N8sY68VPbqJg0FWubxfRR3rGb2DzQt0N04yCCmzvDRPA9yNTP
         Hurw==
X-Gm-Message-State: AGi0PuZfYy0Mv5RfY+oB4v91cLhr+7BG4nHS20NTF4oqoRE916Ymm1zm
        Pp+gK3PyzZZvauywGD5g+8h5CFrTEaXuzwT3BpBcROn4pjPqY5ErIofcBzfU9Z6nvSHnbK9KezT
        MbDMpbXCzmvCN
X-Received: by 2002:a1c:5f56:: with SMTP id t83mr5378707wmb.61.1587667671278;
        Thu, 23 Apr 2020 11:47:51 -0700 (PDT)
X-Google-Smtp-Source: APiQypIGX+c0VaPtxeEQ+EdfwLa4HdBfcFzZxxcdOmn4WZe3Y2qrKzLPY6u6SWTyNn1roGFw4gNOxA==
X-Received: by 2002:a1c:5f56:: with SMTP id t83mr5378684wmb.61.1587667671025;
        Thu, 23 Apr 2020 11:47:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id h13sm4648105wrs.22.2020.04.23.11.47.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 11:47:50 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86: check_nested_events if there is an
 injectable NMI
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, vkuznets@redhat.com, wei.huang2@amd.com
References: <20200414201107.22952-1-cavery@redhat.com>
 <20200414201107.22952-3-cavery@redhat.com>
 <20200423144209.GA17824@linux.intel.com>
 <467c5c66-8890-02ba-2e9a-c28365d9f2c6@redhat.com>
 <28f3db39-4561-7873-09dc-a27ebe5501b6@redhat.com>
 <20200423183315.GM17824@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a4805d3a-357c-99bc-c6cc-97149d79916e@redhat.com>
Date:   Thu, 23 Apr 2020 20:47:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200423183315.GM17824@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 20:33, Sean Christopherson wrote:
> On Thu, Apr 23, 2020 at 05:45:07PM +0200, Paolo Bonzini wrote:
>> On 23/04/20 17:36, Cathy Avery wrote:
>>>
>>> You will have to forgive me as I am new to KVM and any help would be
>>> most appreciated.
>>
>> No problem---this is a _really_ hairy part.  At least every time we make
>> some changes it suddenly starts making more sense (both hacks and bugs
>> decrease over time).
> 
> LOL, no kidding, what sadist gave Cathy nested NMI as a ramp task? :-D

The suggestion was to write more tests, she decided to extend that to
fixing them!!

Paolo

