Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFE74358F6
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 05:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhJUDa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 23:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhJUDa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 23:30:26 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02DEC06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 20:28:10 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id u6-20020a17090a3fc600b001a00250584aso2068149pjm.4
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 20:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pnh8bcyRjTrFkmOUHRbArZzuERhrJtMq46zgeHiKn8Y=;
        b=Cauuv1ujQRryXJrICExsWu7CW72/1HWtrSb1GYwtYwkBFkUYrpj6ApUheJRnh2swyG
         O3vIPOYG0u3bLtQMAVbsIIxkOBliaB4RBU0S/JmihkqQNQuMdmHCN10KCH8Swx5uhw7F
         qY7hqiSbNgvLr6TVG7w71gWOlWavsV9ebke9c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pnh8bcyRjTrFkmOUHRbArZzuERhrJtMq46zgeHiKn8Y=;
        b=uXwS2J9qC9yaYT0EPmq8cXMAHu4pRktKCnCRL91luz7gqA8kI8WeX85Q25hR/8eL6x
         Qb/p+gmy/QOhWn8JJPEVSGfEl6aHqaWxhclH28OgUm148EC62oV3Z3jZrD3KLDREH94k
         qR+ULiYSlA+XMOYnBILA/bHlU8xXMghK8c4qu6uhCiEQpJRZxCBy0iR/Fbp2PJFeoIpv
         QsEw5vv6wCIy3zwt5PGwGFs2KhutzFJ55DKFDwVQCiAztJW0u1oorM9Kb8yUVCa6oYeE
         xdIk+KcsJeuuxF1s97wEjSeKbpcONgCcmfZr6fndTD/CqqxUuSBY5yVp6pXCzg3fkNM0
         7QeQ==
X-Gm-Message-State: AOAM532nqUdwIFR5GN0Bsk35mt3DB7HYvfhvGMYyEIUQIhrjp2/rQZas
        9eSMXQV0GbSu/Ybb6A0DRcPj1Q==
X-Google-Smtp-Source: ABdhPJwaIRddrQYFUanxcxcEgN/hjpiSMRxc12ELAY7BZjXycEPojgJ0N6zrRC73e8qptCTdmq4pPg==
X-Received: by 2002:a17:90a:c08d:: with SMTP id o13mr3559912pjs.181.1634786890448;
        Wed, 20 Oct 2021 20:28:10 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:3bbb:903f:245c:8335])
        by smtp.gmail.com with ESMTPSA id qe7sm374163pjb.1.2021.10.20.20.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:28:09 -0700 (PDT)
Date:   Thu, 21 Oct 2021 12:28:05 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suleiman Souhlal <suleiman@google.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCHV2 1/3] KVM: x86: introduce kvm_mmu_pte_prefetch structure
Message-ID: <YXDeRej39voc7lJU@google.com>
References: <20211019153214.109519-1-senozhatsky@chromium.org>
 <20211019153214.109519-2-senozhatsky@chromium.org>
 <CALzav=cLXXZYBSH6iJifkqVijLAU5EvgVg2W4HKhqke2JBa+yg@mail.gmail.com>
 <YW9vqgwU+/iVooXj@google.com>
 <CALzav=c1LXXWSi-Z0_X35HCyQtv1rh0p2YmJ289J51SHy0DRxg@mail.gmail.com>
 <YXDU/xXkWGuDJ/id@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXDU/xXkWGuDJ/id@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On (21/10/21 11:48), Sergey Senozhatsky wrote:
> 
> We are using TDP. And somehow I never see (literally never) async PFs.
> It's always either hva_to_pfn_fast() or hva_to_pfn_slow() or
> __direct_map() from tdp_page_fault().

Hmm, and tdp_page_fault()->fast_page_fault() always fails on
!is_access_allowed(error_code, new_spte), it never handles the faults.
And I see some ->mmu_lock contention:

	spin_lock(&vcpu->kvm->mmu_lock);
	__direct_map();
	spin_unlock(&vcpu->kvm->mmu_lock);

So it might be that we setup guest memory wrongly and never get
advantages of TPD and fast page faults?
