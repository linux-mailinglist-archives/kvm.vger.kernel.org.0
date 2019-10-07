Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFF3CEA12
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 19:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbfJGRFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 13:05:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45685 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728688AbfJGRFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 13:05:32 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C62DA859FC
        for <kvm@vger.kernel.org>; Mon,  7 Oct 2019 17:05:31 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id b6so7879154wrw.2
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 10:05:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qWZZwMI60/Yk1Jo1iNOlqvg6GvjDVvDOelOPf/CZZOs=;
        b=qYyWL9PFT6KW5bBWqqpbq/DjDZ8EI01QMlYwClGMly98d6kxPRJRyHeQkCFd4NGw0f
         geZ8Xum671nvpRVapY5llW/HYIZ3OpvMEikeR6EwG+ruuQV4yZnQJdjR2JP6UBRIufVq
         7LIOi7Qa92aaZLMX9qvp0i4wOVT5PaCU7spOCkk7QOZ1zTAnNBwWhmFP9agoS+uT9KLV
         e7BozfP/z6jGHSd3YApvw7J0MatxPoqBhAHpSilT3XtDpTovb5zhvapHnXbZUIK6fyfb
         RTd/zYVEsfSIKF6gkBaUCE39DKqEgduicCnQqJpUVXCjF1OoOiTuMev8YKc4OXj02eG2
         TSiw==
X-Gm-Message-State: APjAAAVRSx4vZX0h92ClMaNQKo9Bd4jTjyy6mN3AVeLAlD3bBzm/1+jA
        mCSlS67QyMk2HzXk9h+irXY29g0db8YCrGfBWZNpCedRL0HUvr6GceJV8YPI3gOOncjbWQ3iGiM
        mgeFSWpljbFrb
X-Received: by 2002:adf:eb4d:: with SMTP id u13mr13794253wrn.224.1570467930414;
        Mon, 07 Oct 2019 10:05:30 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzzC3fvN/T7itcRThqgFQBEe9qKN64SezWk2klHi7Dhoy4KkaqSAol3vKnzlrw6BJtZMoXZ+g==
X-Received: by 2002:adf:eb4d:: with SMTP id u13mr13794225wrn.224.1570467930111;
        Mon, 07 Oct 2019 10:05:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dd9:ce92:89b5:d1f2? ([2001:b07:6468:f312:9dd9:ce92:89b5:d1f2])
        by smtp.gmail.com with ESMTPSA id d10sm206901wma.42.2019.10.07.10.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 10:05:29 -0700 (PDT)
Subject: Re: [PATCH 01/16] x86/intel: Initialize IA32_FEATURE_CONTROL MSR at
 boot
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-edac@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
References: <20191004215615.5479-1-sean.j.christopherson@intel.com>
 <20191004215615.5479-2-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <afd37a28-d135-7c34-bd63-7c11099998bc@redhat.com>
Date:   Mon, 7 Oct 2019 19:05:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191004215615.5479-2-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/19 23:56, Sean Christopherson wrote:
> Always lock IA32_FEATURE_CONTROL if it exists, even if the CPU doesn't
> support VMX, so that other existing and future kernel code that queries
> IA32_FEATURE_CONTROL can assume it's locked.

Possibly stupid question: why bother locking it?  It makes sense to lock
the MSR bits to _off_ in the firmware, but if the BIOS hasn't locked it,
why should the OS?

It seems to me that locking introduces a lot of complication.

Paolo
