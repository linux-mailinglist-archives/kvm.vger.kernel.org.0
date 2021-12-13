Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9141473018
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 16:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhLMPHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 10:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbhLMPG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 10:06:57 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F21BC061574;
        Mon, 13 Dec 2021 07:06:57 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id w1so52985799edc.6;
        Mon, 13 Dec 2021 07:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=D+OM0ZcmedPw5LKW8sfyRrJjP9nbgID1f4xqcJPjBqg=;
        b=dGtwxoABqgZdJ5QjvI4V8UtjlNuiMAQ3vWwTGuWwrK2drWzZCZZI4vGHWuI/wD16Oc
         qjVBzujgQpZh89ulOq87nBrULvmABQfl84GIiSsuEj7f6TdCz1d1MaVVIZ7WTrb3A/6I
         rn3IRSdzHiebOeQlBeF5y+8oCt5tSdZft76fxgcwb0+aA8LBbcii2IIm1Q8C8tnIQssH
         /xUUITLAvM5UU3OqKHgsjhT6gfreOyXB5ZG0KG+T7X1muJl6xVswp8cxIFrvXl+IEYsV
         e+GhLek8C7BCKwPErAvxBMW9Qm3Ytrnaf+/5pRJT/x1yeheWfpqI5aZSdRddJoZD5QZw
         /v7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=D+OM0ZcmedPw5LKW8sfyRrJjP9nbgID1f4xqcJPjBqg=;
        b=YePVV+Mo4CYt8qxaIL6Q3/Ud4HeL8VJfkONogbozdIR51WiJaDX9YdWqxReP3Ez1rb
         NainbYvt9cSXNDLEcFbtJbyYmub4F6u62LnIb6qXcamECgXzRMzdCHWTg6NoFXVZneJp
         ZQBJj8/V8dOtkIfImNzzCFPEJ32rBwPXt98B1furkFinhF/szpXDpiUnKnM56pPltUps
         lHq2J7V0xKowbiRsPPJKg4ADvbWVh2Lx3K2C5YxUqgLsUlPfb27D4B3tRnIdPdRU801N
         pXP/xunt+oTaMZ/1G+tCCuR05Ad3EYskbybsRt9kWWqOxJy9szcu1IIIY3fjv1hcc9K4
         nN6g==
X-Gm-Message-State: AOAM531tZ3OsSLhdEctYW49CZ7xGSfT6Ib6eWgMHjCO/hqBFhoHK8MPF
        KDAFU5v1ji8GvneGxvl5LPo=
X-Google-Smtp-Source: ABdhPJwjITmETfb+FsdYrE5cod1vvUS9pztM2qIpHDo9t+iIrJaI3IyW7a5Kw0VCSn9jSjeOKWFbqA==
X-Received: by 2002:a17:907:7250:: with SMTP id ds16mr44384421ejc.54.1639408011892;
        Mon, 13 Dec 2021 07:06:51 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id cq19sm6308649edb.33.2021.12.13.07.06.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 07:06:51 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <452f3642-04fd-aa32-920e-5ad5925c0c91@redhat.com>
Date:   Mon, 13 Dec 2021 16:06:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/2] KVM: x86: Fix dangling page reference in TDP MMU
Content-Language: en-US
To:     Ignat Korchagin <ignat@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, bgardon@google.com,
        dmatlack@google.com, stevensd@chromium.org,
        kernel-team <kernel-team@cloudflare.com>
References: <20211213112514.78552-1-pbonzini@redhat.com>
 <CALrw=nEM6LEAD8LA1Bd15=8BK=TFwwwAMKy_DWRrDkD=r+1Tqg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALrw=nEM6LEAD8LA1Bd15=8BK=TFwwwAMKy_DWRrDkD=r+1Tqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/21 14:43, Ignat Korchagin wrote:
> The only difference I noticed is the presence of __tdp_mmu_set_spte
> between zap_gfn_range and __handle_changed_spte, which is absent from
> the original stacktrace.

That's just a difference in inlining decisions, so it doesn't really matter.

Let's see if Sean has some more ideas or finds something obviously wrong 
in my patch.

Paolo
