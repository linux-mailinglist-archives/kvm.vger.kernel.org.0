Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3195030D8A8
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 12:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhBCL3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 06:29:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234170AbhBCL1W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 06:27:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612351554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sEB/LyeruEcu4oLY1qq972Bq0pPdpUz5iU5q3+LYBtU=;
        b=RsRl5fMjKTfslSTE6pG7cd9MzYyeMLanY0JRLGyp16m3RvW+TD8Ay41h2MdvcMHM6Q6nFy
        hAeWDHl0vZRb10BRi6BShT0tRrNCunFdIigFSevie65GvMtJOEhH9/l47An/s2y24PE6Zq
        3JWJBSyTDbUd2INOnpPeeV3gAPcZCRk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-hRj5w5gdOluXyznyFwdbqA-1; Wed, 03 Feb 2021 06:25:53 -0500
X-MC-Unique: hRj5w5gdOluXyznyFwdbqA-1
Received: by mail-ej1-f70.google.com with SMTP id q11so11779518ejd.0
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 03:25:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sEB/LyeruEcu4oLY1qq972Bq0pPdpUz5iU5q3+LYBtU=;
        b=TLDy91LsiG7L0iLyCNHSSZXBJyBpa+p5ZlFElXggTqPTm8pk8uDGnJEfMNxjgkk00Z
         nRHxQPpwpuDTUJLbptSfawmQ6aiO+mf9IQrHLmfEc8y7hvR5nBuGD9xm+/6kyeWu0UYj
         hhg0LFs03A+l3Rz95z57KVu+18ZAgwqjqIFDr0MAr36wwp4hZkfZdQQ8OvrXCVYM9c1H
         IsMU57uWW93xg2txG8Qwg1CCdkLq4j/i5BUSa+JMgrzObwDdXfFF9yUoekCQ+OZWdUBp
         zHGwVJ0/2lOYS1koSBCgABHKVj/AcxgnH7Fy0ua/twG7HNRZRQZdDAxn9dpCgAmORRDO
         V0nw==
X-Gm-Message-State: AOAM531Wz5EenTN29vl1u8gFMXjxA6Ni9xHHM0B/xXntpW/c3tuzQnZf
        7Xs/qI4FlqwAZOdMoSVEh2D/Pn9GHDSvV7+WBfrmqX+kfgpHljLHtuKCqHahUqnheHQv5X3dC8y
        6Kyjcb7qGmqWJ
X-Received: by 2002:a17:906:9588:: with SMTP id r8mr2780615ejx.167.1612351552076;
        Wed, 03 Feb 2021 03:25:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw5LF7V/ZFdg7RG3zBOSMF7OAPRHvwsAl6XPGFjrumkESOYUbSt8oa9zNB8/FuSYZsHp14QOw==
X-Received: by 2002:a17:906:9588:: with SMTP id r8mr2780602ejx.167.1612351551955;
        Wed, 03 Feb 2021 03:25:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bo24sm711966edb.51.2021.02.03.03.25.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 03:25:51 -0800 (PST)
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
Message-ID: <fee9f2d3-85f8-30de-b198-0b69e4a78628@redhat.com>
Date:   Wed, 3 Feb 2021 12:25:50 +0100
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
> 
> @@ -5518,13 +5518,17 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>  		}
>  	}
>  
> +	kvm_mmu_unlock(kvm);
> +
>  	if (kvm->arch.tdp_mmu_enabled) {

Temporary compile error.

Paolo

