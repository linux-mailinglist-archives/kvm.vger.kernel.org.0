Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D84BE27A8
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 03:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392257AbfJXBSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 21:18:39 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41803 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfJXBSi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 21:18:38 -0400
Received: by mail-pf1-f195.google.com with SMTP id q7so14012175pfh.8
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2019 18:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kLVSnMlZumdLAd3t/w8TuzWFNhlgWtrlkEHJaECjJN8=;
        b=UmeoGwukZmP5EtD/sq03lovbMcHfk0xC8cJFBe29bqPDn8WaHUhNo8YzAa2C/uWO60
         n9SaCyyoHaKJCV9kqy9KStXnZ1xpAzFuR0nBy6eobONdb5wyMHGXCrwYa92BhU8UqOio
         kb1w8a9K3+jdHTNiRSc3FMPl/ZAqHHG8M8SP7eKeFXriVRdhlvHFi/W3LN6kAoUb7ut9
         tbcGGJahY3Hny2yZ5sxb/uBO5FmTjRtVefJrB9HWV7HAXno/qxIzq73kPSKG9/K7I3Sa
         zOu0jJfStqSkEWZyHPQRUWUh/Cde0iv2NX6qj0f+OV/T7h7KhCVl+rSebGTdX1q/aUFr
         utrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kLVSnMlZumdLAd3t/w8TuzWFNhlgWtrlkEHJaECjJN8=;
        b=TDjMCJlW1Fe/BEPKSW2lVBIxr/08u84pRbwPiTASoGIdYnzKAQrP2RcNYPIy+hq2Qi
         H57V6VfTB0MDMN/RTm5PcKKM3OgVdPu8jzD4MgSgqMduXsK5Np7QhiISH97ETfozVGgU
         9Q4Owpd8/3OPbi39M3dUVzet30AKoTX5htp0xpB8aVrXIq23mx++XIFQFRQonCCvvURl
         fRrOroJ37+CrVED60CZySEAZ2MB/Q+WDSnz+LS1Y/44gnmasLAB9tJJPNPyqGlTp3MdE
         vWep8K9rFgLjLj1vTzM41lHR25zk5mfG3/cenRxISyAgb3pSxCfU0xUZW/89Ifv9jkzt
         m09w==
X-Gm-Message-State: APjAAAWcS/ZgJsZNxKnEiobS7OrY+RI90FZou68453WkfP4kbICHaRoi
        BrR8SWttW4MIDv0JCQxSK/7UEnRQiWY=
X-Google-Smtp-Source: APXvYqzbLIOE21UZN75oIdMiNqAjxWrltZcKrfhAmpcJUQXgo6hh8SdrwFftVXJ0bX2z4J2SddXBKQ==
X-Received: by 2002:a17:90a:19c1:: with SMTP id 1mr3689295pjj.52.1571879917763;
        Wed, 23 Oct 2019 18:18:37 -0700 (PDT)
Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:2:5e41:bb1f:98fb:39da])
        by smtp.gmail.com with ESMTPSA id w11sm30550322pfd.116.2019.10.23.18.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2019 18:18:36 -0700 (PDT)
Subject: Re: [PATCH v2] kvm: call kvm_arch_destroy_vm if vm creation fails
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        John Sperbeck <jsperbeck@google.com>
References: <20191023203214.93252-1-jmattson@google.com>
 <20191024000544.GA3744@linux.intel.com>
From:   Junaid Shahid <junaids@google.com>
Openpgp: preference=signencrypt
Autocrypt: addr=junaids@google.com; keydata=
 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
 iWogGkOc4UGfcj87Lt9ivHEsVoo/lwCTIiQ=
Organization: Google
Message-ID: <3ccc2f6c-9695-ee76-5734-e93eb802d7e2@google.com>
Date:   Wed, 23 Oct 2019 18:18:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191024000544.GA3744@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Plain-text resend]

On 10/23/19 5:05 PM, Sean Christopherson wrote:
> 
> Side topic, the loops to free the buses and memslots belong higher up,
> the arrays aren't initialized until after hardware_enable().  Probably
> doesn't harm anything but it's a waste of cycles.  I'll send a patch.
> 

Aren't the x86_set_memory_region() calls inside kvm_arch_destroy_vm() going to be problematic if hardware_enable_all() fails? Perhaps we should move the memslots allocation before kvm_arch_init_vm(), or check for NULL memslots in kvm_arch_destroy_vm().

