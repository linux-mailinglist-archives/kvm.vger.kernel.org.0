Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98A91BF9F5
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 15:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgD3Ntm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 09:49:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47894 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726577AbgD3Ntm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 09:49:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588254580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IEBaJZZn8G4VkvBwEauwJGfaJC10NnAmuAyBH5fbQnA=;
        b=iaf3zV3Xgq0QboukIov4LFQs/xI3nDGXw1LztcirUB6aWpJmKX0eM2v1epQsV1mlMnsBS0
        3rF4EItQqOnOFsJ8/tb8LVl6CHKnbV3ddMXdxjJZZtu+by8aCCV7H/dxj0U3XkfZ0GOfX0
        KPspAjP8K2MnkPGU4ObYDYRB+lOFt/o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-B-HPsFwMPm2O4L81L7fZaA-1; Thu, 30 Apr 2020 09:49:36 -0400
X-MC-Unique: B-HPsFwMPm2O4L81L7fZaA-1
Received: by mail-wm1-f69.google.com with SMTP id f128so880836wmf.8
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 06:49:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=IEBaJZZn8G4VkvBwEauwJGfaJC10NnAmuAyBH5fbQnA=;
        b=dienl/MQRmdJeiZTCPgF0L6eQ3TitbhgxM5p0whIPiMiZkg98ogBGuNbANSgjsPEwF
         /7atGxHqEoZ1eIP2nS6woHwVumKjVq8ErQGvqXYnrcPRnP+segOWP5wZYoUBV//JB7PS
         wNIsMH7RCEs9k00hkdYQuUecryy2vdRR7PUYVf95aYWCjnNRNGEcB3wbCwq+sNpd6NK0
         8E5sZbtJ14tNTFrv+a4y6PyndlZ5mV5lqeSXUSdzDSHQEjmHGDPLCWftn/LGsO6TFTWd
         nuem7SXNZ8SbLsamk4QnXCDNdIavMtrS1qB8bq+UMXTRzvSC0/g8wSNAkZgQPO/MhPCV
         pFvg==
X-Gm-Message-State: AGi0Pubu5Tk2aM9vdVeuLqluOjN1epZs1ewiE5G28S5xTWmNSJJnIVWL
        LxEey2iZvcXjlwb2KJraV7sab3kik3Kx8cHZceXS5YvkOXx0fMcwEWOlBYkm/u2CWSnMKFKlUsF
        kHsEcML4dJ9xy
X-Received: by 2002:a1c:6a0b:: with SMTP id f11mr3082435wmc.123.1588254575072;
        Thu, 30 Apr 2020 06:49:35 -0700 (PDT)
X-Google-Smtp-Source: APiQypKPdUBEwRbmSXCzUBZ0gX8bjI8gMw9HBoTwk6kFinzxWLo9L+OUtgiEezO+fqbN+i/GXfMCCg==
X-Received: by 2002:a1c:6a0b:: with SMTP id f11mr3082411wmc.123.1588254574896;
        Thu, 30 Apr 2020 06:49:34 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 91sm4520928wra.37.2020.04.30.06.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 06:49:34 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 3/6] KVM: x86: interrupt based APF page-ready event delivery
In-Reply-To: <20200430132805.GB40678@xz-x1>
References: <20200429093634.1514902-1-vkuznets@redhat.com> <20200429093634.1514902-4-vkuznets@redhat.com> <20200429212708.GA40678@xz-x1> <87v9lhfk7v.fsf@vitty.brq.redhat.com> <20200430132805.GB40678@xz-x1>
Date:   Thu, 30 Apr 2020 15:49:33 +0200
Message-ID: <877dxxf5hu.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> On Thu, Apr 30, 2020 at 10:31:32AM +0200, Vitaly Kuznetsov wrote:
>> as we need to write to two MSRs to configure the new mechanism ordering
>> becomes important. If the guest writes to ASYNC_PF_EN first to establish
>> the shared memory stucture the interrupt in ASYNC_PF2 is not yet set
>> (and AFAIR '0' is a valid interrupt!) so if an async pf happens
>> immediately after that we'll be forced to inject INT0 in the guest and
>> it'll get confused and linkely miss the event.
>> 
>> We can probably mandate the reverse sequence: guest has to set up
>> interrupt in ASYNC_PF2 first and then write to ASYNC_PF_EN (with both
>> bit 0 and bit 3). In that case the additional 'enable' bit in ASYNC_PF2
>> seems redundant. This protocol doesn't look too complex for guests to
>> follow.
>
> Yep looks good.  We should also update the document too about the fact.
>

Of course. It will also mention the fact that #PF-based mechanism is
now depreceted and unless guest opts into interrupt based delivery
async_pf is not functional (except for APF_HALT).

-- 
Vitaly

