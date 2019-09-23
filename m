Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9292FBB22C
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 12:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407636AbfIWKW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 06:22:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404970AbfIWKW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 06:22:26 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A665536961
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 10:22:25 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id k9so6451495wmb.0
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 03:22:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fOXb2zotSIWB4X/sQrsrANj/mMFRoi6WdNsUfB4y3ds=;
        b=WwmWYkJp53ZL27chU7u8ACfFi1OE5aHNAqXc7mUb2iBmyVzddrW/40TqVAuUtGxJXr
         otimUCJgzqDAKDbKF323W6xSOntLJwGdhzBD4LHxDoQzrPgtNrrVENSRWwC9+NBdXX1C
         9WQcruIhVX6bExdtjlFvpGLn58QfXRQu0vfEp0I1afcoF9ahd/Iy5ItLIyC4h4bAlT6T
         +zhCcQ4I3MSx07No+gs7m0638oisdmurZ49HS5zBwxKG6zLBdL64RWigN4ssLw8VAldJ
         CtqmkpRat5iHsoItkixe3PVf1MUq6x+2x/4g8SknuG/7Eep4vF0qxdvlkR/AvAFXy1Vj
         ejFg==
X-Gm-Message-State: APjAAAVqwDmhlgHK5mXOA3+CE6thGIFmEbU2/7rd44qLAnHfM+bgkLyi
        VDuvv3eKUZSjfLSKkTQsjYxjHJbwGyr275syZhqqToWwFo+JoeKoZHv4MeeNWB/uIwK4XoWLp4T
        rYB2WvvShNcpH
X-Received: by 2002:adf:f44e:: with SMTP id f14mr19897296wrp.290.1569234144366;
        Mon, 23 Sep 2019 03:22:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz6zfWDCrO5uyrF7XiNRNtg5AchHWZTbVkzNHhwvuNee2mlm3NGz1GASMsttwusekXqn0QzPw==
X-Received: by 2002:adf:f44e:: with SMTP id f14mr19897284wrp.290.1569234144093;
        Mon, 23 Sep 2019 03:22:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id o12sm17311097wrm.23.2019.09.23.03.22.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 03:22:23 -0700 (PDT)
Subject: Re: [PATCH 01/17] x86: spec_ctrl: fix SPEC_CTRL initialization after
 kexec
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-2-aarcange@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c56d8911-5323-ac40-97b3-fa8920725197@redhat.com>
Date:   Mon, 23 Sep 2019 12:22:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920212509.2578-2-aarcange@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/19 23:24, Andrea Arcangeli wrote:
> We can't assume the SPEC_CTRL msr is zero at boot because it could be
> left enabled by a previous kernel booted with
> spec_store_bypass_disable=on.
> 
> Without this fix a boot with spec_store_bypass_disable=on followed by
> a kexec boot with spec_store_bypass_disable=off would erroneously and
> unexpectedly leave bit 2 set in SPEC_CTRL.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

Can you send this out separately, so that Thomas et al. can pick it up
as a bug fix?

Thanks,

Paolo
