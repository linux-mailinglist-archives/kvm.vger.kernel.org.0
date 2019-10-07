Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBEECEA46
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 19:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbfJGRLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 13:11:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728081AbfJGRLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 13:11:24 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 766F16412B
        for <kvm@vger.kernel.org>; Mon,  7 Oct 2019 17:11:24 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id f3so7819142wrr.23
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 10:11:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bLYqevL9PdywyJeqkvnwbJNWCTwp+vmfpCLSwv3bSmE=;
        b=MEV6MU/V6mTpOSByVBjtn+2qqWz6qgBD+UFQ8WmN08sh80NuzVUYRbg9P379n52xos
         +PPsaSZ8ca/Yg/MLDT+1EU+osnkCc6cWrhG9N1zHtyyTHL4/0taFGCIoPlVRkZkI4XY+
         Y264pTLg994KTC0MeP0gtqJT0AUPHg0W1NWqjOVFERXixiLELVt3BUjit/mOVpLz3fvH
         /wDGsbm8OIl5SGIl6JjccAhXf/7yhn8wvyqIwEZxlFW5DlCKbIqrc7KIlq5r4xaLFxy7
         zBBhZb0P5MYqC0JoLvDfxpTfa8CgObNdolYHxlfQ7+CECAH/TrHEz+/yGG/bKF8vY3CZ
         ZjJw==
X-Gm-Message-State: APjAAAVvMugdoFeILv/OCTHH6rs67N8u0OqiZ8cHZfidJ0zPk8qPmudj
        Ktin0P3X+X5h7A4tQmoEX0EWzFBoDwZMzUDPZUzUjgNJCVntm9MshwqTjvVAzzREusB7zkvYBxS
        gbilWfzjSLiHP
X-Received: by 2002:a1c:dfc4:: with SMTP id w187mr212755wmg.107.1570468282980;
        Mon, 07 Oct 2019 10:11:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz1x9jK5iGjhn2UKiyqBvzJiOdXgI8Lounm92w3dtdmgh+zFpbdqLV1jAS7OA22NvBTOkz9Ew==
X-Received: by 2002:a1c:dfc4:: with SMTP id w187mr212734wmg.107.1570468282725;
        Mon, 07 Oct 2019 10:11:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dd9:ce92:89b5:d1f2? ([2001:b07:6468:f312:9dd9:ce92:89b5:d1f2])
        by smtp.gmail.com with ESMTPSA id n17sm13127190wrp.37.2019.10.07.10.11.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 10:11:22 -0700 (PDT)
Subject: Re: [PATCH 10/16] x86/cpu: Detect VMX features on Intel, Centaur and
 Zhaoxin CPUs
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
 <20191004215615.5479-11-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f26580de-d423-3369-42f4-682824dd592d@redhat.com>
Date:   Mon, 7 Oct 2019 19:11:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191004215615.5479-11-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/19 23:56, Sean Christopherson wrote:
> +	/*
> +	 * The high bits contain the allowed-1 settings, i.e. features that can
> +	 * be turned on.  The low bits contain the allowed-0 settings, i.e.
> +	 * features that can be turned off.  Ignore the allowed-0 settings,
> +	 * if a feature can be turned on then it's supported.
> +	 */
> +	rdmsr(MSR_IA32_VMX_PINBASED_CTLS, ign, supported);

For QEMU, we're defining a feature as supported if a feature can be
turned both on and off.  Since msr_low and msr_high can be defined
respectively as must-be-one and can-be-one, the features become
"msr_high & ~msr_low".

Also, shouldn't this use the "true" feature availability MSRs if available?

Paolo
