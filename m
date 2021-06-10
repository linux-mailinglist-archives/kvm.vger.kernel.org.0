Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D3E3A36C4
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 00:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFJWC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 18:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJWCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 18:02:55 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFA0C061574;
        Thu, 10 Jun 2021 15:00:59 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 27so846042pgy.3;
        Thu, 10 Jun 2021 15:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HpssfE2d11sgeidmgSOPLPZa62XHgMUH6omyOPJeUxU=;
        b=OJKiL7+8haLUNHG9efJ0/Uj6pSCQJg9UAWouBeYQNDXlSZ7Zemp2OpqdAazWxCVw+8
         zNDRpn9s6cJkTUFDtGUvKjrUcEX1LKUv30WqUEjfb5YJAgMLSkCVk0VO5r+ui62ROCHo
         PCs3da/a19rRAF9spEfsVe4SAy5z8rAnE6TG3brAqOt4eK2so2ENF0Sk6EKikmuokkjH
         QbqfzcXESzBg2TkjuyQtewT8ELI5uRm1Q4QedI7EgZNj6qelhfRRzfU2Yk0m0HHAOaca
         pmeSIbvFkt51ljOuxgTYI7+67YUoF40XxE3HLWfFcK4s29hqMsh393JX1wV+es+abGMR
         5qdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HpssfE2d11sgeidmgSOPLPZa62XHgMUH6omyOPJeUxU=;
        b=OkLihsY+t64rs1KsDaIzIS4InugHaBZ0NGvUwcPKvFIPFU3sAkf9gfxWX2KBGUZm1i
         tGX/sxstVOHJ2iG/gLy2r5as0JIqVZ2rDE2EQbeWv381bs0LHVgeFzrVr/uWQdYpoSxp
         qoAL2/JaBjv1Kp6THU0xrbpdAt1wv2/AQo8qi0TVfv30/FQ/EgwkCBNYLKiH0wKqC+x8
         +dxByCsxDqHQMAPs7yP/Tk2W5AMv+cweS+TH9BKlb3Q4as9UCuYtQYXeZSjyCylIFdRC
         lT39Ii5HJGnq/aVWMfE2noC0ETXo149u4WzU2I92PPW3FCII5CWTmjL4VM6FbNRNOPg1
         hS2g==
X-Gm-Message-State: AOAM530MQBCbfeQn2KQlE/Plh448DwEbNp5RYCVYl8qTuWvXx2GgMVKs
        muQBEGUk8EHKbJRMZoKhRPI=
X-Google-Smtp-Source: ABdhPJwvwjkwUcRv6P9hdOdjEUpm9wBT0KL1IvpRLKCeg1kzYv1wmnJma6N1Kfh0fZduWpxusMi6Tg==
X-Received: by 2002:a65:6a45:: with SMTP id o5mr457271pgu.409.1623362458405;
        Thu, 10 Jun 2021 15:00:58 -0700 (PDT)
Received: from localhost ([2601:647:4600:1ed4:adaa:7ff5:893e:b91])
        by smtp.gmail.com with ESMTPSA id q4sm3352299pfh.18.2021.06.10.15.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 15:00:57 -0700 (PDT)
Date:   Thu, 10 Jun 2021 15:00:56 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH 00/10] KVM: x86/mmu: simplify argument to kvm page
 fault handler
Message-ID: <20210610220056.GA642297@private.email.ne.jp>
References: <cover.1618914692.git.isaku.yamahata@intel.com>
 <YK65V++S2Kt1OLTu@google.com>
 <936b00e2-1bcc-d5cc-5ae1-59f43ab5325f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <936b00e2-1bcc-d5cc-5ae1-59f43ab5325f@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for feedback. Let me respin it.

On Thu, Jun 10, 2021 at 02:45:55PM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 26/05/21 23:10, Sean Christopherson wrote:
> >    - Have kvm_mmu_do_page_fault() handle initialization of the struct.  That
> >      will allow making most of the fields const, and will avoid the rather painful
> >      kvm_page_fault_init().
> > 
> >    - Pass @vcpu separately.  Yes, it's associated with the fault, but literally
> >      the first line in every consumer is "struct kvm_vcpu *vcpu = kpf->vcpu;".
> > 
> >    - Use "fault" instead of "kpf", mostly because it reads better for people that
> >      aren't intimately familiar with the code, but also to avoid having to refactor
> >      a huge amount of code if we decide to rename kvm_page_fault, e.g. if we decide
> >      to use that name to return fault information to userspace.
> > 
> >    - Snapshot anything that is computed in multiple places, even if it is
> >      derivative of existing info.  E.g. it probably makes sense to grab
> 
> I agree with all of these (especially it was a bit weird not to see vcpu in
> the prototypes).  Thanks Sean for the review!
> 
> Paolo
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
