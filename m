Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B88FDD78C5
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 16:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732779AbfJOOhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 10:37:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732448AbfJOOhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 10:37:00 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BC7E0757CC
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 14:36:59 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id h4so4451159wrx.15
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 07:36:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7gWYtkII8mtOVls6zkJP3id5nOPibyKp3U8OMw+vtSs=;
        b=AutA6zx/EESACVuL1jJGRlkJCOR0zP2eNwEGVbowiShBGRqT/uEuv2jaBbLRciq2pT
         3nt89Y9IvdHO5KJm941grqkLi2H6QnjYh2qiqznMx7QLJrMaeUXwsrW7pN7S+6GzT7bW
         6WP3cLn8DTzdhdEVt7wbaQNaHL+9oiHma8olSHvhiLIJFCITiYv0f5c8Y76dmIhSj6UF
         ihbhCdkqFG75dc9MODv3Byx8AUX+p3oiKPg/nSXRr8DHORgXhnS0MtNFC3pDJNf0boRU
         udwsJuSvxcSLX6bruVf2lkfQg52Zf+sH8mglUjMuk07mZnZkzgB3sk1vzeQUjfb/fTgy
         1c4A==
X-Gm-Message-State: APjAAAVLPn3giGOZRiXfgaodbb5qvegFLzCdc3xvEdnQkTr5vstsSXvl
        +aU3eb61LS47c/Qm7QaIszySIGJgjNbzynACiK0kC1ZB6eievWThxYIIgSmvIxfasEpkhnoWKKR
        fU3Jwbdr8QWaN
X-Received: by 2002:adf:a109:: with SMTP id o9mr6215043wro.96.1571150218499;
        Tue, 15 Oct 2019 07:36:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy42FIpOdPfkX/N+JnSoKHv+iGGPsS7ya7sjKODSLyv9Nu8uwV8cmZ4JAP7DceOJtB+Y0l45Q==
X-Received: by 2002:adf:a109:: with SMTP id o9mr6215021wro.96.1571150218266;
        Tue, 15 Oct 2019 07:36:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z1sm3637250wrn.57.2019.10.15.07.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 07:36:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: X86: Make fpu allocation a common function
In-Reply-To: <97255084-7b10-73a5-bfb4-fdc1d5cc0f6e@redhat.com>
References: <20191014162247.61461-1-xiaoyao.li@intel.com> <87y2xn462e.fsf@vitty.brq.redhat.com> <20191014183723.GE22962@linux.intel.com> <87v9sq46vz.fsf@vitty.brq.redhat.com> <97255084-7b10-73a5-bfb4-fdc1d5cc0f6e@redhat.com>
Date:   Tue, 15 Oct 2019 16:36:57 +0200
Message-ID: <87lftm3wja.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 15/10/19 12:53, Vitaly Kuznetsov wrote:
>> A very theoretical question: why do we have 'struct vcpu' embedded in
>> vcpu_vmx/vcpu_svm and not the other way around (e.g. in a union)? That
>> would've allowed us to allocate memory in common code and then fill in
>> vendor-specific details in .create_vcpu().
>
> Probably "because it's always been like that" is the most accurate answer.
>

OK, so let me make my question a bit less theoretical: would you be in
favor of changing the status quo? :-)

-- 
Vitaly
