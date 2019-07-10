Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16E0464167
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 08:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfGJGeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 02:34:08 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46463 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbfGJGeI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 02:34:08 -0400
Received: by mail-ed1-f67.google.com with SMTP id d4so992085edr.13
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2019 23:34:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J5KipV70foUU8ZDHSfbxKtNUPFs4vS9J459AyOxAvGM=;
        b=c2NhnSyzoQNfyhDv14eXJu8eo1XDIovBlOgbvvP796E9Xt6w1ch5+S+reKaQ7IPYoP
         imQdWTfoQTYBR59McMjISExNSQeEpB0IXjzCOX4xsE5f8oV6dXPdKTlEKaqxwVjShUUh
         LeFK4EzYioqlNr7Ghpmo7bkghXof73SjgKn92XxFPEr9p/7luu4jQLkJXWiZV1nQoPBr
         7jYHA9hYNUwGqatQ16OQy7GifA1ADghyVeKdEpYbNu30b1gVsZAlJPEBb1ewkB9X6GJR
         0f8jgea5UG+7i1y5yvOZOydM4OYP6+WZHE7eGzrCSKuM2s4cIsBkUbITgLHUVUmHuc/l
         8Alg==
X-Gm-Message-State: APjAAAVmmKqiv3P2qHxAMOdfe3ILd027ldbC3vTG4mr2zUkfGsuvTeKb
        529R22pkhdJrlGjmNn3sf7GffFMtu9E=
X-Google-Smtp-Source: APXvYqzqTMPNjCwtT/7mZ0wnEqoDGAx/LQ2+vzGyWcOQdNOsLF0bRspAi2qapk8oaWANI1ig6TID8g==
X-Received: by 2002:a05:6402:1456:: with SMTP id d22mr29919969edx.57.1562740446759;
        Tue, 09 Jul 2019 23:34:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:19db:ad53:90ea:9423? ([2001:b07:6468:f312:19db:ad53:90ea:9423])
        by smtp.gmail.com with ESMTPSA id y16sm1041817wrw.33.2019.07.09.23.34.06
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 23:34:06 -0700 (PDT)
Subject: Re: [PATCH 5/5] KVM: cpuid: remove has_leaf_count from struct
 kvm_cpuid_param
To:     Jing Liu <jing2.liu@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190704140715.31181-1-pbonzini@redhat.com>
 <20190704140715.31181-6-pbonzini@redhat.com>
 <bb5e81f4-bb34-2841-0fa1-63876b97e54c@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5a7d222e-3c49-2485-e11d-45c9e9ece8c8@redhat.com>
Date:   Wed, 10 Jul 2019 08:34:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <bb5e81f4-bb34-2841-0fa1-63876b97e54c@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/19 09:09, Jing Liu wrote:
> It seems the two func are introduced by 2b5e97e, as paravirtual cpuid.
> But when searching KVM_CPUID_SIGNATURE, there seems no caller requesting
> this cpuid. Meanwhile, I felt curious if KVM_CPUID_FEATURES is still in
> use but it seems kvm_update_cpuid() uses that. Not sure which spec
> introduces the latest pv cpuid.

Yes, KVM_CPUID_SIGNATURE is generally not very interesting for
userspace.  But KVM_CPUID_FEATURES is called here:

        for (w = 0; w < FEATURE_WORDS; w++) {
            /* Override only features that weren't set explicitly
             * by the user.
             */
            env->features[w] |=
                x86_cpu_get_supported_feature_word(w, cpu->migratable) &
                ~env->user_features[w] & \
                ~feature_word_info[w].no_autoenable_flags;
        }

Paolo
