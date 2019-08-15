Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6108ED99
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 16:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732698AbfHOODf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 10:03:35 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38645 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732300AbfHOODf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 10:03:35 -0400
Received: by mail-wr1-f66.google.com with SMTP id g17so2329950wrr.5
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2019 07:03:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=P6jtmJQJAOxQmjY3PzD+zR33iq9AQ8OzIHihVYNbvtU=;
        b=Zz0wGQhcQJ6L3ch961HK7a33OBbylNCO4w03QRiyVAO+2diyGGeSn9YOC7Hx5holdx
         iIVIiDGncTFvI8Dsj78u5OXiykKR7uoLdzJaB9eN35PfJBshp91vbgtzChw0v2GZ8ocC
         /ab/TUGsP6Q9m47fnOTAuoiq/urcTSSBL1SgsrYaAQ+9RIRpN/FYNh2HqgRSsu1r+IWT
         rkwQ8RgpeGvNjYpswtHEryVCl+0QqZ/m94vtPMLrRt2AHVnR/FWbfAWQVIjBWqdAaQK7
         FtbAvmXwvEAN7PDuBth1/WX7s1btNbvxZDszi7xm+4GO+zUGrXzFtSsoZ0aincZUc73P
         Ud5g==
X-Gm-Message-State: APjAAAUm4hVRTMf5jXEsnsvdKoZZ+R5jnk+6Jn11I+afdbmdScPiqtEe
        rcYHcDxP9PbqbRR9NeTFKtCktA==
X-Google-Smtp-Source: APXvYqz3n13iAarvnk398GKr173OsqGUtiGpYz002s0J1/siYVBnI9MVpRe8PGn9JMKu1I5a55aTDw==
X-Received: by 2002:adf:f204:: with SMTP id p4mr5874439wro.317.1565877813345;
        Thu, 15 Aug 2019 07:03:33 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t198sm2803371wmt.39.2019.08.15.07.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 07:03:32 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        rkrcmar@redhat.com, jmattson@google.com, yu.c.zhang@intel.com,
        alazar@bitdefender.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com
Subject: Re: [PATCH RESEND v4 5/9] KVM: VMX: Add init/set/get functions for SPP
In-Reply-To: <20190815134329.GA11449@local-michael-cet-test>
References: <20190814070403.6588-1-weijiang.yang@intel.com> <20190814070403.6588-6-weijiang.yang@intel.com> <87a7cbapdw.fsf@vitty.brq.redhat.com> <20190815134329.GA11449@local-michael-cet-test>
Date:   Thu, 15 Aug 2019 16:03:31 +0200
Message-ID: <87o90q8r0s.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yang Weijiang <weijiang.yang@intel.com> writes:

> After looked into the issue and others, I feel to make SPP co-existing
> with nested VM is not good, the major reason is, L1 pages protected by
> SPP are transparent to L1 VM, if it launches L2 VM, probably the
> pages would be allocated to L2 VM, and that will bother to L1 and L2.
> Given the feature is new and I don't see nested VM can benefit
> from it right now, I would like to make SPP and nested feature mutually
> exclusive, i.e., detecting if the other part is active before activate one
> feature,what do you think of it? 

I was mostly worried about creating a loophole (if I understand
correctly) for guests to defeat SPP protection: just launching a nested
guest and giving it a protected page. I don't see a problem if we limit
SPP to non-nested guests as step 1: we, however, need to document this
side-effect of the ioctl. Also, if you decide to do this enforecement,
I'd suggest you forbid VMLAUCH/VMRESUME and not VMXON as kvm module
loads in linux guests automatically when the hardware is suitable.

Thanks,

-- 
Vitaly
