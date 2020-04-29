Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EC71BE47C
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 18:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgD2Q6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 12:58:52 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55639 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726689AbgD2Q6v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 12:58:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588179530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DZj+UypIq11W/7o5dpVittTTONbPwIV/7sCOfZvPFS0=;
        b=gp9l6sEVkVxYeKqa2Qx3W3EC8WQ9C7Id5NmqL4wCYkxvdevDVz9ioddeGRh13ODKJMs+mx
        03QduwTc/1UpA40DxDfLH4FGPDBDpuf//OwjaJSdyPYl5rrLMRrgIVq9NsNlzoJ2QGY6Ok
        32sCYVPDgIh+RB2rOINV3jMyxb8h824=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-80nNg36aN-SCZYKyJKlc3A-1; Wed, 29 Apr 2020 12:58:48 -0400
X-MC-Unique: 80nNg36aN-SCZYKyJKlc3A-1
Received: by mail-wr1-f70.google.com with SMTP id j16so2040095wrw.20
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 09:58:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DZj+UypIq11W/7o5dpVittTTONbPwIV/7sCOfZvPFS0=;
        b=kcwSVpVNPVFMOx2GYtA8h2xJV/kmkCXTAOrfKtn11SbrmmmfV1h+FL+se7uynGgHy1
         OpUNZs4HeHNRiWdfaTvu6heHJpf9/Qw0dPRXwjLkuV6uUgLUc+N93/4LE1pCs33dgQUa
         FrSyOR6f2siCpL8TuiIuZGc+/Kmg7qKNHdq5BNHDgIROiomIck3ZTj/tpN75E60nF/Ju
         z69LFyXfwst8wzKKBry3ZVGwiwyFqITU9dfwWWkM9cUBE+QuOA7rDu5oXYzG+g2wsLYR
         acqmrgWvluuIVNtOFdZwLDu7DgFt6me8dTT87VNZPVjn6dm/g+13rz33SX/r8fnLSdJW
         qZFA==
X-Gm-Message-State: AGi0PuYRt5/EU3wVP14ga1SdxjpBPhwOw9208tS6J9JNmtaIUIwUMntn
        crn2GXGwLonIoGNHWrNhWrrFPCcWK7Ln6yAyVdjoIngoZDGY7jZTH5E/w99yvheSwTSWcJiYsyT
        yv88Gam715+8A
X-Received: by 2002:a5d:6504:: with SMTP id x4mr43034839wru.164.1588179527019;
        Wed, 29 Apr 2020 09:58:47 -0700 (PDT)
X-Google-Smtp-Source: APiQypJNgX/vxwRcj0In+qKlYwCYcXKBrwuybWbL6MJwjPCNHgZ4umK2HzpOL2puRlq6jK7/5EAJjQ==
X-Received: by 2002:a5d:6504:: with SMTP id x4mr43034816wru.164.1588179526729;
        Wed, 29 Apr 2020 09:58:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac19:d1fb:3f5f:d54f? ([2001:b07:6468:f312:ac19:d1fb:3f5f:d54f])
        by smtp.gmail.com with ESMTPSA id h1sm9392173wme.42.2020.04.29.09.58.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 09:58:46 -0700 (PDT)
Subject: Re: [PATCH 12/13] KVM: x86: Replace late check_nested_events() hack
 with more precise fix
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
 <20200423022550.15113-13-sean.j.christopherson@intel.com>
 <CALMp9eTiGdYPpejAOLNz7zzqP1wPXb_zSL02F27VMHeHGzANJg@mail.gmail.com>
 <20200428222010.GN12735@linux.intel.com>
 <6b35ec9b-9565-ea6c-3de5-0957a9f76257@redhat.com>
 <20200429164547.GF15992@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <286738de-c268-f0b6-f589-6d9d9ad3dc4a@redhat.com>
Date:   Wed, 29 Apr 2020 18:58:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200429164547.GF15992@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/20 18:45, Sean Christopherson wrote:
> 
> Can you just drop 9/13, "Prioritize SMI over nested IRQ/NMI" from kvm/queue?
> It's probably best to deal with this in a new series rather than trying to
> squeeze it in.

With AMD we just have IRQ/NMI/SMI, and it's important to handle SMI in
check_nested_events because you can turn SMIs into vmexit without stuff
such as dual-monitor treatment.  On the other hand there is no MTF and
we're not handling exceptions yet.  So, since SMIs should be pretty rare
anyway, I'd rather just add a comment detailing the correct order and
why we're not following it.  The minimal fix would be to move SMI above
the preemption timer, right?

Paolo

