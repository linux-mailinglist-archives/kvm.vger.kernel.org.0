Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57D9A2578E
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 20:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbfEUS2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 14:28:40 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52749 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728457AbfEUS2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 14:28:40 -0400
Received: by mail-wm1-f68.google.com with SMTP id y3so3964641wmm.2
        for <kvm@vger.kernel.org>; Tue, 21 May 2019 11:28:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qU0oxwfZcLk0iOxgnO8VPxDjgRoJbZAj9hi3V2Z/tgY=;
        b=JsKt2hCIu2YFB9shSNqWR9qQjSafhZn5VL1foKyRA8hEv2l229f7CyDfhhWoamU7uR
         aMz1cnmZVlTbFco7TqZqu59PZMZVF9AtKGZiuFrCBbkoV7DkFfLwAQASBjnt9rJFrGbx
         8NGHXe7LLqHe+x1VFG8T1zb8VKvhk/B+zPrK4aWq0mDSwwWAgMnkuplkDpQQjRPxpyV2
         VR/wElnSDjPRm2SluJP+mE7krt7DMXXoRzSNgLdpEcMivDaVms0aOVyBkzQ3YIz16W1m
         fCkPEXCkfofH8lUnEfmMYbkQptRzuAi90mzvdR2s1Fq3ZGBi5CUGMkU9lOVLPE/J3e97
         fJxg==
X-Gm-Message-State: APjAAAX4x5vT/wCvdU3PUnUze26zl82nYc1hfdKECj0aP3Wj48tRpqda
        I4Y5bd9P/Hv+fFKZeX0e9qfj0CiqkwM=
X-Google-Smtp-Source: APXvYqwpgoOcFRBOuD+emvtSHwHvjFqbmvhCKA8yAEUXDBfyEAFz6snlp9ZCWQRBAMU4YbulNx7dtg==
X-Received: by 2002:a1c:ed07:: with SMTP id l7mr4253630wmh.148.1558463317936;
        Tue, 21 May 2019 11:28:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id s127sm4011028wmf.48.2019.05.21.11.28.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 11:28:37 -0700 (PDT)
Subject: Re: [PATCH] kvm: change KVM_REQUEST_MASK to reflect vcpu.requests
 size
To:     Rik van Riel <riel@surriel.com>
Cc:     kernel-team@fb.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20190521132200.2b45c029@imladris.surriel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ae5402e2-b748-b144-c1ea-715357529621@redhat.com>
Date:   Tue, 21 May 2019 20:28:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190521132200.2b45c029@imladris.surriel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/19 19:22, Rik van Riel wrote:
> The code using KVM_REQUEST_MASK uses a pattern reminiscent of a bitmask:
> 
> 	set_bit(req & KVM_REQUEST_MASK, &vcpu->requests);
> 
> However, the first argument passed to set_bit, test_bit, and clear_bit
> is a bit number, not a bitmask. That means the current definition would
> allow users of kvm_make_request to overflow the vcpu.requests bitmask,
> and is confusing to developers examining the code.

This is true, but the meaning of the masking is that bits above 7 define
extra things to do when sending a request (wait for acknowledge, kick
the recipient CPU).  The fact that the "request number" field is 8 bits
rather than 5 or 6 is just an implementation detail.

If you change it to BITS_PER_LONG-1, the obvious way to read the code
would be that requests 0, 64, 128 are all valid and map to the same request.

Paolo

> Redefine KVM_REQUEST_MASK to reflect the number of bits that actually
> fit inside an unsigned long, and add a comment explaining set_bit and
> friends take bit numbers, not a bitmask.

