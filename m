Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64888230E7
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 12:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731569AbfETKES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 06:04:18 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42304 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729834AbfETKES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 06:04:18 -0400
Received: by mail-wr1-f67.google.com with SMTP id l2so13866268wrb.9
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 03:04:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eDTLgWjDZyEWBd4EOYN8wwdDkryUyB2GrBPhBkzPJWQ=;
        b=cdNaP90BU4Bc5lcnz+OF2KQb/sNja1wtjPcL6WIv9YhuqspNhAPpD74zQA1SoKFv6J
         smGAxlwZ1cZa9JZ/wAtyItUCf/nO+MeI63FboF884kiIY3Dk8CNxvaYATHj6ivET/BFg
         EiZ6Mq0B06BNZ7Hc2+suPHYCOnMIyil82V+1jpztmSZdCH4lpyhscZC6Z14OdTTPtBxs
         tsd9NvgCoq7rkRIYGo7usl9qelX6BGQXFqJWkqxf/j/JVvAF/WZWqtlrVx/sxw2gOZ3k
         D8SCg9bcpG4haFIQgXCdIYEQx8vHO5cMKSEB4gTnmOlDnWKKga+3X7kjIojpikdK6oDT
         GlGw==
X-Gm-Message-State: APjAAAWOKQeYk9NiiSxFkNF5nVvpeBI1SmhvVxHOFj3ci2hQS2JFHMG6
        xPZxqGsW5obPxyTFA2ACg66UvQ==
X-Google-Smtp-Source: APXvYqwfCPb6Ub4vQIPJsBa7bJbC8oN8bymcwi3g2iPRay1gsMD3vDLwcPgdt0g1QwW+/7PpXnm59g==
X-Received: by 2002:adf:aa09:: with SMTP id p9mr18212336wrd.59.1558346656829;
        Mon, 20 May 2019 03:04:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id v1sm16669809wrd.47.2019.05.20.03.04.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 03:04:16 -0700 (PDT)
Subject: Re: [PATCH 2/2] kvm: x86: Include CPUID leaf 0x8000001e in kvm's
 supported CPUID
To:     Jim Mattson <jmattson@google.com>, Borislav Petkov <bp@suse.de>
Cc:     kvm list <kvm@vger.kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>, Jacob Xu <jacobhxu@google.com>
References: <20190327201537.77350-1-jmattson@google.com>
 <20190327201537.77350-2-jmattson@google.com> <20190401171304.GD28514@zn.tnic>
 <CALMp9eRbe8VWzhGcs_HB0gBT5EQN4PCtop5am9j+-WG5pK8r8w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d98b62d0-846c-0af7-c8dd-6344c73bf801@redhat.com>
Date:   Mon, 20 May 2019 12:04:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eRbe8VWzhGcs_HB0gBT5EQN4PCtop5am9j+-WG5pK8r8w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/05/19 19:48, Jim Mattson wrote:
> On Mon, Apr 1, 2019 at 10:13 AM Borislav Petkov <bp@suse.de> wrote:
>>
>> On Wed, Mar 27, 2019 at 01:15:37PM -0700, Jim Mattson wrote:
>>> Kvm now supports extended CPUID functions through 0x8000001f.  CPUID
>>> leaf 0x8000001e is AMD's Processor Topology Information leaf. This
>>> contains similar information to CPUID leaf 0xb (Intel's Extended
>>> Topology Enumeration leaf), and should be included in the output of
>>> KVM_GET_SUPPORTED_CPUID, even though userspace is likely to override
>>> some of this information based upon the configuration of the
>>> particular VM.
>>>
>>> Cc: Brijesh Singh <brijesh.singh@amd.com>
>>> Cc: Borislav Petkov <bp@suse.de>
>>> Fixes: 8765d75329a38 ("KVM: X86: Extend CPUID range to include new leaf")
>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>> Reviewed-by: Marc Orr <marcorr@google.com>
>>> ---
>>>  arch/x86/kvm/cpuid.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>
>> Reviewed-by: Borislav Petkov <bp@suse.de>
> 
> Paolo?
> 

Queued both (for 5.2-rc2), thanks.

Paolo
