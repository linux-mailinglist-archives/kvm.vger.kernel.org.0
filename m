Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DFA466A90
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 20:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbhLBTn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 14:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhLBTn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 14:43:27 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6CEC06174A;
        Thu,  2 Dec 2021 11:40:04 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r11so2232631edd.9;
        Thu, 02 Dec 2021 11:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dHwrJI73FHKAKjsEuSTBnRqr7x9qzUpk8WqEFKe6BuM=;
        b=RrU+1xmwKh4Uf9FeWbbUyCdFmJl9HRr7I8kPUKJHL/BN2hgwg6qWO0KHjpE2MJo0Fq
         SYDW7TeZk3cczGUgcw5Z5HwigX8hbAyzvdwIEk8+VXKnO9KWxaE50aaY2G7apPaNFUX3
         Tez5AFZ6DtTIOzQKJ38HarfVgMQfZMvluJSvbDqyMrDbrTBGAeQmTk6yPQrus5pLeM30
         //1UfH5qLbuzpBYZFnYvfzGAiP1U6KML5kmma2mbyQaWMfnAUISnfUZ1n2+8M4oH+Xsp
         t2WM70wXfuGKKbadavlrR1eJQnnoiQXkLuM2fWIiOl6PNPc8cQuE5hxyKRwS+iXyGkDs
         tweA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dHwrJI73FHKAKjsEuSTBnRqr7x9qzUpk8WqEFKe6BuM=;
        b=nAWXHbEGtQeOCZzxG+84WjxVzzMlkau8OhYP4qjN7ECpjyb3S3Im9oDlDDtDymZsuV
         /vin2l8GZ4df0lRwx/JDXZQzK26IYpOiwfxyd2dK9Pg5r7OJ/WxuDQaPGLWvdxBzFsw7
         cor6TY8WxKMtiVCHcTM5NzA9ESYg1DUCIJesYl1eFjUc4RVoRJHdBTiYKpzLCJCZOQWn
         9ozHYcPxB45RPJEWIoGp1rr70xIJtD9329CcI16FClGIydIb2D7FflUG13+5oOdozw3E
         KSQs/g5OzxGMYnEkB0anX1GEqhzIXlU3RqNdk6CUoNsss3EO5npRWD0GdDZB8YbHiByn
         5AUg==
X-Gm-Message-State: AOAM5336KilPC99YvZU/Di96GqtDLQRLwOdqMyNRWRpADWDOBW/dInXP
        gOX6rXqBhazjBX2Suu7bhok=
X-Google-Smtp-Source: ABdhPJxNp08wHGsvcQMcikxLrvcsi6kKQQUhkaWBMyAaDaumSswoSrzuq8cknsI16GqYe6TZwkUjLg==
X-Received: by 2002:a17:907:9196:: with SMTP id bp22mr16925142ejb.69.1638474002953;
        Thu, 02 Dec 2021 11:40:02 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id i5sm468883ejw.121.2021.12.02.11.40.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 11:40:02 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <bcb33845-6fff-34c1-9e41-fb611b6f9319@redhat.com>
Date:   Thu, 2 Dec 2021 20:39:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <b57280b5562893e2616257ac9c2d4525a9aeeb42.1638471124.git.thomas.lendacky@amd.com>
 <5ce26a04-8766-7472-0a15-fc91eab0a903@redhat.com>
 <b0443caf-d822-f671-d930-ff317833d701@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <b0443caf-d822-f671-d930-ff317833d701@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/21 20:39, Tom Lendacky wrote:
>> Queued, thanks.  Though it would have been nicer to split the changes 
>> in the return values (e.g. for setup_vmgexit_scratch and 
>> sev_es_validate_vmgexit) from the introduction of the new GHCB exitinfo.
> 
> I can still do that if it will help make things easier. Let me know.

Well, at this point I've already reviewed it. :)

Paolo
