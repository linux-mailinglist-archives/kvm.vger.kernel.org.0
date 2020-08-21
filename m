Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3EE24D19B
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 11:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgHUJhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 05:37:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51439 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725965AbgHUJhT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Aug 2020 05:37:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598002638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HM8iWB8SC7hD7f4RpIcbL31EFLRVSaFi+Uelkb/Y1jg=;
        b=eWAB+qhShsUWltjPybdtetrlw7UncoMXWN4prsyJQxrwbHXxEW29cJr+KVXKQEcLzXASCX
        vP80mvMtYKW/P7x2/zyI/Vg+XSg9HPXB1vhGEjkOIT9jM2otHU1wgBCD4q0bML2keh7PqM
        O9/FqDAKqdQwULwMRk0BPOrfYWvvhi0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402--gyg7i2HODO1qGquc4GANA-1; Fri, 21 Aug 2020 05:37:16 -0400
X-MC-Unique: -gyg7i2HODO1qGquc4GANA-1
Received: by mail-wm1-f69.google.com with SMTP id k204so735478wmb.3
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 02:37:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HM8iWB8SC7hD7f4RpIcbL31EFLRVSaFi+Uelkb/Y1jg=;
        b=H2DM3pWOSgbOrGdroY3O0H3XelnYqqqNShN28QQ9S3pWqZJ9Ce61rvp8V5J5tQw96I
         K55ChN43RiH8uy350qo3ogR6+BbkKHHY7wvhHhXb7p/smkAbDlcooJU5erYqu9VNEdB/
         W1LhOaVe7TyyuD1h+mxv2DnHyO7e5mBZ0GgkGKkrsIjcbujjq68WE+8GfSIljIva9rti
         6gGzYhjK76sh8+VMWvdL87q0Qen/4BByE0teyScJpMtu+IZdbuX4hMMaP0eOZmlkjMhC
         2FQah9rXWNpgomead9Asdg76KbvMV8J6H4DcBFUbV8SsC1V1EoJAA2cOXZ2cB9Sm8l+V
         TOzA==
X-Gm-Message-State: AOAM533G+e2LrE++ZKszZgImO4uoszvCgQfvLgaJ9JQVi440Jp4SWLFO
        rQwJQtoBpToVaBuc+f7XuUQ6eD+37KIo0zqcRKt8K562XsqSb8ThAkjkDc68BEneMmzNJFWYdeI
        wXZ3bcrTWittM
X-Received: by 2002:a7b:c84e:: with SMTP id c14mr3074374wml.51.1598002635064;
        Fri, 21 Aug 2020 02:37:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwC4R8JV8L5mLEba4NKsTdVDCxAA6Mt6rRW2RutzRg5Vy9Fkhbug+fOmXTIeN9cV11aJiiDA==
X-Received: by 2002:a7b:c84e:: with SMTP id c14mr3074345wml.51.1598002634800;
        Fri, 21 Aug 2020 02:37:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cc0:4e4e:f1a9:1745? ([2001:b07:6468:f312:1cc0:4e4e:f1a9:1745])
        by smtp.gmail.com with ESMTPSA id c10sm2887323wrn.24.2020.08.21.02.37.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 02:37:14 -0700 (PDT)
Subject: Re: [PATCH] x86/entry/64: Disallow RDPID in paranoid entry if KVM is
 enabled
To:     Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200821025050.32573-1-sean.j.christopherson@intel.com>
 <20200821074743.GB12181@zn.tnic>
 <3eb94913-662d-5423-21b1-eaf75635142a@redhat.com>
 <87r1s0gxfj.fsf@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f8597183-5a14-de7c-330b-46b9bf015d0c@redhat.com>
Date:   Fri, 21 Aug 2020 11:37:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87r1s0gxfj.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/08/20 11:28, Thomas Gleixner wrote:
> We all know that MSRs are slow, but as a general rule I have to make it
> entirely clear that the kernel has precedence over KVM.

I totally agree.  I just don't think that it matters _in this case_,
because the kernel hardly has any reason to use TSC_AUX while in ring0.

Paolo

> If the kernel wants to use an MSR for it's own purposes then KVM has to
> deal with that and not the other way round. Preventing the kernel from
> using a facility freely is not an option ever.
> 
> The insanities of KVM performance optimizations have bitten us more than
> once.
> 
> For this particular case at hand I don't care much and we should just
> rip the whole RDPID thing out unconditionally. We still have zero
> numbers about the performance difference vs. LSL.

