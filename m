Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF89398D00
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 10:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731390AbfHVIH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 04:07:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57322 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728645AbfHVIH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 04:07:26 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BF8CDC05AA65
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2019 08:07:26 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id a17so2835649wrw.3
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2019 01:07:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pF3YGFREgBUzzvAMmFfzZCFDTbGTkVkyO/Xg4NkQLbg=;
        b=eijCarApFi2xPLx3W0hJzUO1VZhXH0OYmX6mMQYMwgVOouW6BehyRWty66DcrUcif+
         dIb0T0zACdhgrb/w1a63u09Rfq76Q5tX9EYZPUgCI3DigtC0+S2F+sE0umiNX6fzTM3+
         b0IIdsuXWwBjLi0N+udzp/mfH3MNVJrEfSVX/jG/L4RtJRjBgtI9IHAcs7rOcj+isjpb
         9E6Xg7tqyzfAnbaeae364hRJWRobDeux0oCigeq+QLJ4JruHg0eIDk4etbRkKtmPOP4t
         Pu0EyDjNp4PslzkVL7dmSB3ExZBNLRimiCtgRacA44GFZlRLjrwd5thn/nFWK0O0gFt4
         X8hA==
X-Gm-Message-State: APjAAAVH8B2tTXl6Dr7lXs1e012MuROeBaE0rrlpuqwx/ndDxBiDWpfn
        D/EKfEYARPYiNIlEqPLp/L6tzbhywz0Iw7299Xl5sa5YE8sPpFNdE87rZ02ZttLQ8TBVRFza0qM
        nvKshu43BLlRs
X-Received: by 2002:adf:a48f:: with SMTP id g15mr46940530wrb.172.1566461245247;
        Thu, 22 Aug 2019 01:07:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyKS7i8/l2gsUy685qpa5gOwkc8jiCcEIrrT+YYNuieEQ8e2G096e6ngarBG7s2GxLQuCFHpA==
X-Received: by 2002:adf:a48f:: with SMTP id g15mr46940485wrb.172.1566461244874;
        Thu, 22 Aug 2019 01:07:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:21b9:ff1f:a96c:9fb3? ([2001:b07:6468:f312:21b9:ff1f:a96c:9fb3])
        by smtp.gmail.com with ESMTPSA id k9sm20260132wrq.15.2019.08.22.01.07.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2019 01:07:24 -0700 (PDT)
Subject: Re: [PATCH RESEND] i386/kvm: support guest access CORE cstate
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <1563154124-18579-1-git-send-email-wanpengli@tencent.com>
 <ba3ae595-7f82-d17b-e8ed-6e86e9195ce5@redhat.com>
 <CANRm+Cx1bEOXBx50K9gv08UWEGadKOCtCbAwVo0CFC-g1gS+Xg@mail.gmail.com>
 <82a0eb75-5710-3b03-cf8e-a00b156ee275@redhat.com>
 <CANRm+Cw4V9AT1FOAOiQ5OSYHYcka_CxxKLewsPfZ9+ykTy354w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d2c93756-708e-3f8c-d9f2-8b80c73928e7@redhat.com>
Date:   Thu, 22 Aug 2019 10:07:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cw4V9AT1FOAOiQ5OSYHYcka_CxxKLewsPfZ9+ykTy354w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/08/19 02:31, Wanpeng Li wrote:
> On Wed, 21 Aug 2019 at 15:55, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 20/08/19 09:16, Wanpeng Li wrote:
>>> Kindly reminder, :)
>>
>> It's already in my pull request from yesterday.
> 
> Do you mean this pull
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg638707.html ?
> This patch is missing.

Oops, you're right.  I must have removed it by mistake while bisecting a
failure.  I've added it back now.

Paolo
