Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D316853B1D4
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 04:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbiFBCMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 22:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbiFBCMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 22:12:50 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58392259CEF;
        Wed,  1 Jun 2022 19:12:48 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id g205so3506390pfb.11;
        Wed, 01 Jun 2022 19:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wxKfqvYYl/WghEgwJ5qmNjs5BsgeCLKJPyNxktwdjE0=;
        b=nitiYWECyD22E07LtE1M87F1xS6kxYrIQ49bb25SA7Tm5ynHEQThT2gbAltSN4663q
         MJ/d3TTn6t23dAJEckpO2ThMSRS1fq2anlJenwID3WXfAOQtVQz+VBmdmn6tNgYvtni6
         RJnXPCl5JjVTgFAEpVsYtofeHS/NVoNuDJDBdcYYUg54mEIS+y2iYmVZXFdAYupP22s4
         SggJJAXgFkfsr+zmoJrZ2OpKgpnIzru1Gt/Y4YzIWYJzNq8SrYUNVoJ8S3g6kXe8t8Jd
         ogBOqxKNYpjr9mp7yA27gbT8yY4DYvAuV7jht0dsOF1FZWYbIouDjRGFSyGObkDI46DO
         Ldrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wxKfqvYYl/WghEgwJ5qmNjs5BsgeCLKJPyNxktwdjE0=;
        b=X9f6WL3gdlP430bObQGqZzeKAlXS+R130Y0qUO+5vL4e8U0vyidEjEneoFfo4sCevN
         gcqBtivMCBMlX2yGY2u6a95eiq4rEpsAnfBxrbMRdsosfyMEWUzqLi1vogfPuuj1LMqo
         QyquXcD7xyTfzpDyw7eMyLB+whFjv3tXfuUltz5SinAOJj0hA0TlsTRa9W+6ObJU8iWr
         ivofnDQ2k5DRbQwl7zY6D4X7TDNTHL0lEjqhZhx0r5T85vqFIWwuarfxYt9IQkCUFSdA
         Qc5wI5HeftOdEYbdMJ/VG4AK7E/jbE52QrAoSJTMYtUunUcqWtQvktxQ9fS8NnSclDGx
         su1w==
X-Gm-Message-State: AOAM531v40Ca/lvFKd9zNHfU5lpK9XJmA8fhktDGgeZDs1C534T7AGLe
        xX2RtshTNV3Q/HMcUZIzEMo=
X-Google-Smtp-Source: ABdhPJxNvpbJ6pNwxi2Qrcw44SATF/fKCkLbVJB1AISloHWjOtc/5RtM19dZo3xJ/+2OQEbJcBhr/w==
X-Received: by 2002:a62:ce4f:0:b0:51b:ac5c:4e49 with SMTP id y76-20020a62ce4f000000b0051bac5c4e49mr2479004pfg.81.1654135967685;
        Wed, 01 Jun 2022 19:12:47 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.14])
        by smtp.gmail.com with ESMTPSA id w20-20020a170902ca1400b0015e8d4eb285sm2112670pld.207.2022.06.01.19.12.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 19:12:47 -0700 (PDT)
Message-ID: <cbb9a8b5-f31f-dd3b-3278-01f12d935ebe@gmail.com>
Date:   Thu, 2 Jun 2022 10:12:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH 1/2] KVM: vmx, pmu: accept 0 for absent MSRs when
 host-initiated
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220531175450.295552-1-pbonzini@redhat.com>
 <20220531175450.295552-2-pbonzini@redhat.com> <YpZgU+vfjkRuHZZR@google.com>
 <ce2b4fed-3d9e-a179-a907-5b8e09511b7d@gmail.com>
 <YpeWPAHNhQQ/lRKF@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <YpeWPAHNhQQ/lRKF@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for your sincerity, always.

On 2/6/2022 12:39 am, Sean Christopherson wrote:
> On Wed, Jun 01, 2022, Like Xu wrote:
>> On 1/6/2022 2:37 am, Sean Christopherson wrote:
>>> Can we just punt this out of kvm/queue until its been properly reviewed?  At the
>>> barest of glances, there are multiple flaws that should block this from being
>>
>> TBH, our reviewers' attention could not be focused on these patches until the
>> day it was ready to be ravaged. "Try to accept" is a good thing, and things need
>> to move forward, not simply be abandoned to the side.
> 
> I strongly disagree, to put it mildly.  Accepting flawed, buggy code because
> reviewers and maintainers are overloaded does not solve anything, it only makes
> the problem worse.  More than likely, the submitter(s) has moved on to writing
> the next pile of patches, while the same set of people that are trying to review
> submissions are left to pick up the pieces.  There are numerous examples of
> accepting code without (IMO) proper review and tests costing us dearly in the
> long run.

I actually agree and understand the situation of maintainers/reviewers.
No one wants to maintain flawed code, especially in this community
where the majority of previous contributors disappeared after the code
was merged in. The existing heavy maintenance burden is already visible.

Thus we may have a maintainer/reviewers scalability issue. Due to missing
trust, competence or mastery of rules, most of the patches sent to the list
have no one to point out their flaws. I have privately received many complaints
about the indifference of our community, which is distressing.

To improve that, I propose to add "let's try to accept" before "queued, thanks".

Obviously, "try to accept" is not a 100% commitment and it will fail with high
probability, but such a stance (along with standard clarifications and requirements)
from reviewers and maintainers will make the contributors more concerned,
attract potential volunteers, and focus the efforts of our nominated reviewers.

Such moves include explicit acceptance or rejection, a "try to accept" response
from some key persons (even if it ends up being a failure), or a separate git 
branch,
but please, don't leave a lasting silence, especially for those big series.

Similar moves will increase transparency in decision making to reward and
attract a steady stream of high quality trusted contributors to do more and more
for our community and their employers (if any).

> 
> If people want their code to be merged more quickly, then they can do so by
> helping address the underlying problems, e.g. write tests that actually try to
> break their feature instead of doing the bare minimum, review each others code,
> clean up the existing code (and tests!), etc...  There's a reason vPMU features
> tend to not get a lot of reviews; KVM doesn't even get the basics right, so there's
> not a lot of interest in trying to enable fancy, complex features.

I'd like know more about "KVM doesn't even get the basics right" on vPMU. :D

> 
> Merging patches/series because they _haven't_ gotten reviews is all kinds of
> backwards.  In addition to creating _more_ work for reviewers and maintainers,
> it effectively penalizes teams/companies for reviewing each other's code, which
> is seriously fubar and again exacerbates the problem of reviewers being overloaded.
