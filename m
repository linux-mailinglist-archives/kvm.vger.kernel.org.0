Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84B630D8AC
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 12:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhBCL3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 06:29:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234340AbhBCL2V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 06:28:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612351614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yf1gMS5lzQEVg3r7cZkjC3YL7CF1bZPMLFMUXZG5850=;
        b=BsyX/reMBjBUTvsVb27WNVNDsP6j03fDu2YR5uR98+zsQZ5Cm2j3k36dwzOy2IEC20dV17
        aG104zAWJQJsZFpfR6lEVboPr1Su7zveqpaydN05fvS10Dlaukp+33Kn+3QJd693wdcaJZ
        6iiTLSwB00U/vHAI0fSXeILp+uVvgnM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-_vlcaGxNNxWVn-XFlE_-Eg-1; Wed, 03 Feb 2021 06:26:53 -0500
X-MC-Unique: _vlcaGxNNxWVn-XFlE_-Eg-1
Received: by mail-ed1-f70.google.com with SMTP id a26so11347737edx.8
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 03:26:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yf1gMS5lzQEVg3r7cZkjC3YL7CF1bZPMLFMUXZG5850=;
        b=ORXMTPhhXjAR3wQCVpiuWLNTcmTl4sPfeJt+IUMQoElxMKsFTDFuvh+HqrAWOlSQ91
         iN7argKzU1LU4pKbTu/X2wOvRT7iVUzKGXMnNxEvgxVNqLmJG6zQtytmh38p27YTeKLW
         2Uc8xXEUysEp7LKsQTnbrIfqHyoISNdjLG3c6SAApsqIBRZy0SYCwS7jxFo8Ktu+CwIe
         cCRz6/TVsiVd0kACcyOFif/U6MNb0cm6bZibGrX2/6o5rood+n/0+BM4YpUIudPqYlY/
         sR8KPSkxd6CBSZVlrnyHHVavEV0uEhACvZHhVMNk9F9mRwzNvH1DIzB2Mcn88obGXalN
         Z0mg==
X-Gm-Message-State: AOAM5334xNsfqgTGzDlyeRuDdWzcoK5biMcqtAWQNEJLWv1SQCivGDd4
        psg06+p4fz7NJqKdyN5ZwiUS9Fn7OpOGHHuYXtpvZh8nJXh9TbiJaQ6X0UmUiVcTH0hH181toKs
        y+qdlcz3c2y5r
X-Received: by 2002:aa7:c407:: with SMTP id j7mr2390439edq.28.1612351612605;
        Wed, 03 Feb 2021 03:26:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFgG9dKnLjuQhzh0H7zffJi1oxnAdxTuCnrxpIi4XAb4Dgz66tAS3JhIwt2dJZg4gB37VSNg==
X-Received: by 2002:aa7:c407:: with SMTP id j7mr2390392edq.28.1612351611968;
        Wed, 03 Feb 2021 03:26:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g2sm851915ejk.108.2021.02.03.03.26.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 03:26:51 -0800 (PST)
Subject: Re: [PATCH v2 24/28] KVM: x86/mmu: Allow zap gfn range to operate
 under the mmu read lock
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-25-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <813695b1-bcfc-73ea-f9fe-76ffd42044cd@redhat.com>
Date:   Wed, 3 Feb 2021 12:26:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210202185734.1680553-25-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 19:57, Ben Gardon wrote:
> +#ifdef CONFIG_LOCKDEP
> +	if (shared)
> +		lockdep_assert_held_read(&kvm->mmu_lock);
> +	else
> +		lockdep_assert_held_write(&kvm->mmu_lock);
> +#endif /* CONFIG_LOCKDEP */

Also, there's no need for the #ifdef here.  Do we want a helper 
kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm, bool shared)?

Paolo

