Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3EE3A4163
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 13:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhFKLoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 07:44:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54751 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230370AbhFKLoa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 07:44:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623411751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4xah37CV668UR0em2wUSE7B5M6OMw4FnlNzQxdYrv7E=;
        b=eMm1h9LpYXtNkcadRelZZsHHPkcxoNtrjFiin5A7MQKsSG2dyFwcbkcElSVpa+BzyFT9De
        msOdciUrHDDU7izS8QA8wAc9pzUDhDDA/E21gfwXsE358WP2B1ysvgwJbnbe+qW9Z3AXRy
        yAX1MmNEc9k6qCGHwlkrqKXfh56mbO0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-bbtxLkgkOPO9M6m3EPfVlg-1; Fri, 11 Jun 2021 07:42:30 -0400
X-MC-Unique: bbtxLkgkOPO9M6m3EPfVlg-1
Received: by mail-ej1-f69.google.com with SMTP id q7-20020a1709063607b02903f57f85ac45so1031555ejb.15
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 04:42:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=4xah37CV668UR0em2wUSE7B5M6OMw4FnlNzQxdYrv7E=;
        b=aixB3a8wHEcHl0S2DbEenVCKtEyxF/VXzeXFJjDA8rOZZwRk12WATSrnIadyWDRX7G
         rtuiMVxJY8AEiTVMlYUygJXNVm5MHZsDl9M7V2P3qLjoSNce6v9Zrh6vTdKftUPv71Y2
         dXdXqQA84BNij1FwGhdgSWZ1EqXlejHZ1yXMzNa26baBSekJLMOylTT8LIQaaHlsNjSf
         1qzluRwqeib4xuIJId1G28oBUYOIvCt8bwCtNLpu/IunMBEFUeFgBnU0QX0bCma4cdnL
         DgZnVAzSL4yWMHvhb6B12/rjf/nRSnsjhG5Hw2sOuARCYONoBPhiPDLOET6Nhmz6eUu4
         040g==
X-Gm-Message-State: AOAM532VfDaiwzPS6FQ6Kdm5jTDk5f+GBu5pZHsz6FOKhBXjNA9owf7K
        p+4TaqAgUJ7l+sIfRiXlBju31ZnqTeG5gmqedVPkj9KTOkPXbKwViXU1kCnonzHpK7hAb/KVmVk
        ARAvxxHQPgQf+
X-Received: by 2002:a17:906:3e8d:: with SMTP id a13mr3246978ejj.463.1623411749387;
        Fri, 11 Jun 2021 04:42:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzpnfhFNJxmsIpwiSgKIVCCo4PjW32uUUv+jwS/hcRej2ErguKmAdKdmBv+wsKECZ/MFw2rA==
X-Received: by 2002:a17:906:3e8d:: with SMTP id a13mr3246970ejj.463.1623411749224;
        Fri, 11 Jun 2021 04:42:29 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id kx3sm1992622ejc.44.2021.06.11.04.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 04:42:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/9] KVM: x86: Emulate triple fault shutdown if RSM
 emulation fails
In-Reply-To: <YMIwF/so0I+w60kt@google.com>
References: <20210609185619.992058-1-seanjc@google.com>
 <20210609185619.992058-3-seanjc@google.com>
 <87eedayvkn.fsf@vitty.brq.redhat.com> <YMIwF/so0I+w60kt@google.com>
Date:   Fri, 11 Jun 2021 13:42:27 +0200
Message-ID: <874ke4y6e4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Jun 10, 2021, Vitaly Kuznetsov wrote:
>> why don't we have triple fault printed in trace by default BTW???
>
> Or maybe trace_kvm_make_request()?

... or maybe just trace_kvm_check_request()? 

$ git grep  'kvm_make_request(' arch/x86/kvm/ | wc -l
115
$ git grep  'kvm_check_request(' arch/x86/kvm/ | wc -l
41

-- 
Vitaly

