Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065B820C20D
	for <lists+kvm@lfdr.de>; Sat, 27 Jun 2020 16:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgF0OYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jun 2020 10:24:43 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39136 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725850AbgF0OYm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 27 Jun 2020 10:24:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593267881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P20mCvZwl1CUQ5rTmZ1YZBWEHzrTo/uIYjUzY0MFAyo=;
        b=FPN1xFS/Xw62r89MNBVVbS31n1FAY7bf6piab4QNwqXyL2Sg4M0yq2vPcW3wPYUcthrYab
        bWrk15RNzRlDlbmABSVtWg2SlpE4BHqH1nCducy3iJSBxn1Qa7JowXCUMIdioG7WPou1eg
        JGc52/DE2L7yKdzNetMlyjboogLbS+c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-nQG3hd7jMMeoh9-r2eeY6g-1; Sat, 27 Jun 2020 10:24:39 -0400
X-MC-Unique: nQG3hd7jMMeoh9-r2eeY6g-1
Received: by mail-wm1-f72.google.com with SMTP id a7so14054248wmf.1
        for <kvm@vger.kernel.org>; Sat, 27 Jun 2020 07:24:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P20mCvZwl1CUQ5rTmZ1YZBWEHzrTo/uIYjUzY0MFAyo=;
        b=fAFf/eNUJm9zrnXv5Sw6KXsx6cc6zQNGT+LaRkxNn6JWJAsknYOIthrcYtRh4ObjK+
         bCSxBS/bXvPNrj5oPQfUmB0Y88xie8zwNrdqrFQYnyoTLeBNbgvHePcGWQHCOU+XptD9
         G+YBpoVQ48lXCYV09K4NB3lyhcxIsuCwnqUUNK9TChPdpTxtsQa13i8G45U5Ke7nJDcU
         zyfn9ZYA+1jMyooK3/pRGcDh+NfinTFvWbnbcpSAYt2ciO3ZlVqgmKzDgUtfJnURC35Z
         WznktX8kkmWSfqH/UgMNzxq5lU2LDg33u4OKhPL/F2H3kNPCODzyYHKG2xdt7SQ5/zQp
         jFLA==
X-Gm-Message-State: AOAM533M6ExJ/zVaBmfNGH9EJt6vVgniyAGOT07wBRNg4U7t5odX3b5u
        c2kTnyvNtDbJGNti7M5pC8NzwxtO394paSRBi1wKdYLJtlxtwfpCJVxBfzU0CLrJDOj1cXbITSm
        8OvnNAb4laska
X-Received: by 2002:a7b:cb05:: with SMTP id u5mr8361687wmj.169.1593267878070;
        Sat, 27 Jun 2020 07:24:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0VkB//JczbBHekSyJSSjMtIF2NLh/jQCyWHYF7NMRiJk562df/Zsr1mDTHUmouOs7PK7sTg==
X-Received: by 2002:a7b:cb05:: with SMTP id u5mr8361674wmj.169.1593267877856;
        Sat, 27 Jun 2020 07:24:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91d0:a5f0:9f34:4d80? ([2001:b07:6468:f312:91d0:a5f0:9f34:4d80])
        by smtp.gmail.com with ESMTPSA id h13sm1602625wml.42.2020.06.27.07.24.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Jun 2020 07:24:36 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200622220442.21998-1-peterx@redhat.com>
 <20200622220442.21998-2-peterx@redhat.com>
 <20200625061544.GC2141@linux.intel.com>
 <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com> <20200626180732.GB175520@xz-x1>
 <20200626181820.GG6583@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <47b90b77-cf03-6087-b25f-fcd2fd313165@redhat.com>
Date:   Sat, 27 Jun 2020 16:24:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200626181820.GG6583@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/06/20 20:18, Sean Christopherson wrote:
>> Btw, would it be more staightforward to check "vcpu->arch.arch_capabilities &
>> ARCH_CAP_TSX_CTRL_MSR" rather than "*ebx | (F(RTM) | F(HLE))" even if we want
>> to have such a fix?
> Not really, That ends up duplicating the check in vmx_get_msr().  From an
> emulation perspective, this really is a "guest" access to the MSR, in the
> sense that it the virtual CPU is in the guest domain, i.e. not a god-like
> entity that gets to break the rules of emulation.

But if you wrote a guest that wants to read MSR_IA32_TSX_CTRL, there are
two choices:

1) check ARCH_CAPABILITIES first

2) blindly access it and default to 0.

Both are fine, because we know MSR_IA32_TSX_CTRL has no
reserved/must-be-one bits.  Calling __kvm_get_msr and checking for an
invalid MSR through the return value is not breaking the rules of
emulation, it is "faking" a #GP handler.

So I think Peter's patch is fine, but (possibly on top as a third patch)
__must_check should be added to MSR getters and setters.  Also one
possibility is to return -EINVAL for invalid MSRs.

Paolo

